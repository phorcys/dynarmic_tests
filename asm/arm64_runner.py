#!/usr/bin/env python3
"""
ARM64 Test Runner - 使用 QEMU 验证测试用例的正确性

用法:
  python3 arm64_runner.py test.s           # 单文件模式
  python3 arm64_runner.py tests/asm/       # 目录模式

输出: 与 asmtest 类似的格式，方便对比验证

原理:
1. 读取 .s 测试文件
2. 生成包装代码，保存寄存器到固定地址
3. 使用 qemu-aarch64 运行
4. 解析 CONFIG 中的预期值，与实际值对比

MemData 支持:
- MemData 用于初始化测试内存
- 使用 mmap 分配内存，基地址存储在 membase 中
- 测试代码通过 ldr xN, =membase 获取基地址

注意: 此框架不支持测试函数调用(BL/RET)，因为会跳过 ret 指令。
      测试函数调用应该使用 dynarmic_asmtest。
"""

import subprocess, sys, tempfile, os, json, re
from pathlib import Path

RUNNER_TEMPLATE = r'''
.arch armv8.5-a+crc+lse+crypto+sha3+sm4
.data
hex: .ascii "0123456789ABCDEF"
buf: .ascii "0x00000000000000000000000000000000\n"
regs: .skip 248
fpregs: .skip 256
qregs: .skip 512
{MEMDATA}
membase: .quad 0  // Base address for MemData (filled at runtime)

// TLS region (0x1000 bytes)
.align 16
tls_area:
    .skip 0x1000
{TLSDATA}
{SETDATA}

.text
.global _start
_start:
    mov x0, #0; mov x1, #0; mov x2, #0; mov x3, #0
    mov x4, #0; mov x5, #0; mov x6, #0; mov x7, #0
    fmov d8, xzr; fmov d9, xzr; fmov d10, xzr; fmov d11, xzr
    fmov d12, xzr; fmov d13, xzr; fmov d14, xzr; fmov d15, xzr

    // Set up TLS by directly writing to TPIDR_EL0 (QEMU user mode supports this)
    ldr x0, =tls_area
    msr tpidr_el0, x0

{MEMALLOC}
{MEMINIT}
{TLSINIT}
{SETINIT}
{CODE}

__test_exit:
    sub sp, sp, #16
    str x9, [sp]
    ldr x9, =regs
    str x0, [x9, #0]
    str x1, [x9, #8]
    str x2, [x9, #16]
    str x3, [x9, #24]
    str x4, [x9, #32]
    str x5, [x9, #40]
    str x6, [x9, #48]
    str x7, [x9, #56]
    str x8, [x9, #64]
    str x16, [x9, #72]
    str x10, [x9, #80]
    str x11, [x9, #88]
    str x12, [x9, #96]
    str x13, [x9, #104]
    str x14, [x9, #112]
    str x15, [x9, #120]
    str x16, [x9, #128]
    str x17, [x9, #136]
    str x18, [x9, #144]
    str x19, [x9, #152]
    str x20, [x9, #160]
    str x21, [x9, #168]
    str x22, [x9, #176]
    str x23, [x9, #184]
    str x24, [x9, #192]
    str x25, [x9, #200]
    str x26, [x9, #208]
    str x27, [x9, #216]
    str x28, [x9, #224]
    str x29, [x9, #232]
    str x30, [x9, #240]
    ldr x10, [sp]
    str x10, [x9, #72]
    add sp, sp, #16

    ldr x9, =fpregs
    str d0, [x9, #0]
    str d1, [x9, #8]
    str d2, [x9, #16]
    str d3, [x9, #24]
    str d4, [x9, #32]
    str d5, [x9, #40]
    str d6, [x9, #48]
    str d7, [x9, #56]
    str d8, [x9, #64]
    str d9, [x9, #72]
    str d10, [x9, #80]
    str d11, [x9, #88]
    str d12, [x9, #96]
    str d13, [x9, #104]
    str d14, [x9, #112]
    str d15, [x9, #120]
    str d16, [x9, #128]
    str d17, [x9, #136]
    str d18, [x9, #144]
    str d19, [x9, #152]
    str d20, [x9, #160]
    str d21, [x9, #168]
    str d22, [x9, #176]
    str d23, [x9, #184]
    str d24, [x9, #192]
    str d25, [x9, #200]
    str d26, [x9, #208]
    str d27, [x9, #216]
    str d28, [x9, #224]
    str d29, [x9, #232]
    str d30, [x9, #240]
    str d31, [x9, #248]

    // Save Q registers (128-bit)
    ldr x9, =qregs
    stp q0, q1, [x9, #0]
    stp q2, q3, [x9, #32]
    stp q4, q5, [x9, #64]
    stp q6, q7, [x9, #96]
    stp q8, q9, [x9, #128]
    stp q10, q11, [x9, #160]
    stp q12, q13, [x9, #192]
    stp q14, q15, [x9, #224]
    stp q16, q17, [x9, #256]
    stp q18, q19, [x9, #288]
    stp q20, q21, [x9, #320]
    stp q22, q23, [x9, #352]
    stp q24, q25, [x9, #384]
    stp q26, q27, [x9, #416]
    stp q28, q29, [x9, #448]
    stp q30, q31, [x9, #480]

{PRINT}

    mov x8, #93; mov x0, #0; svc #0

phex:
    ldr x4, =hex; ldr x5, =buf
    mov x6, #2; mov x7, #60
1:  lsr x8, x0, x7; and x8, x8, #0xF; ldrb w8, [x4, x8]; strb w8, [x5, x6]
    add x6, x6, #1; subs x7, x7, #4; bpl 1b
    mov x8, #64; mov x0, #1; ldr x1, =buf; mov x2, #18; svc #0
    // Print newline
    mov x8, #64; mov x0, #1; ldr x1, =newline; mov x2, #1; svc #0
    ret

newline: .byte 10
'''

def parse_config(content):
    """解析测试文件中的 JSON CONFIG"""
    # 找 /* CONFIG ... */
    start = content.find('/*')
    if start == -1:
        return None
    
    config_pos = content.find('CONFIG', start)
    if config_pos == -1 or config_pos > start + 20:
        return None
    
    end = content.find('*/', start + 2)
    if end == -1:
        return None
    
    block = content[start + 2:end]
    json_start = block.find('{')
    if json_start == -1:
        return None
    
    json_text = re.sub(r'//.*', '', block[json_start:])
    try:
        return json.loads(json_text)
    except json.JSONDecodeError:
        return None

def extract_code(content):
    """提取 .text 段中的代码。

    测试文件里的 `brk`/`ret` 通常表示“测试到此结束”。
    不能简单删除，否则会错误落入后续 label，改变控制流。
    """
    lines = content.split('\n')
    code = []
    in_text = False
    for line in lines:
        s = line.strip()
        if s.startswith('.text'):
            in_text = True
            continue
        if s.startswith('.global') or s.startswith('_start:'):
            continue
        if s.startswith('.data') or s.startswith('.section'):
            break
        if in_text and s:
            if s.startswith('brk'):
                code.append('    b __test_exit')
                continue
            # 保持原始缩进，统一为 4 空格
            code.append('    ' + s)
    return '\n'.join(code)

def build_print_code(config):
    if not config:
        return ''

    def label_name(reg):
        return f'lb_{reg.lower()}'

    def emit_label(reg):
        return f'{label_name(reg)}: .ascii "{reg}="'

    expected_regs = config.get('ExpectedRegData', config.get('RegData', {}))
    expected_vecs = config.get('ExpectedVecData', config.get('VecData', {}))

    labels = []
    seen_labels = set()
    lines = []

    def add_label(reg):
        if reg not in seen_labels:
            seen_labels.add(reg)
            labels.append(emit_label(reg))

    def emit_print_label(reg):
        lines.append(
            f'    mov x8, #64; mov x0, #1; ldr x1, ={label_name(reg)}; mov x2, #{len(reg) + 1}; svc #0'
        )

    for reg in expected_regs:
        reg_upper = reg.upper()
        if reg_upper.startswith('W') and reg_upper[1:].isdigit():
            reg_upper = 'X' + reg_upper[1:]
        if reg_upper.startswith('X') and reg_upper[1:].isdigit():
            index = int(reg_upper[1:])
            add_label(reg_upper)
            emit_print_label(reg_upper)
            lines.append('    ldr x9, =regs')
            lines.append(f'    ldr x0, [x9, #{index * 8}]')
            lines.append('    bl phex')
        elif reg_upper.startswith('S') and reg_upper[1:].isdigit():
            index = int(reg_upper[1:])
            add_label(reg_upper)
            emit_print_label(reg_upper)
            lines.append('    ldr x9, =fpregs')
            lines.append(f'    ldr w0, [x9, #{index * 8}]')
            lines.append('    bl phex')
        elif reg_upper.startswith('D') and reg_upper[1:].isdigit():
            index = int(reg_upper[1:])
            add_label(reg_upper)
            emit_print_label(reg_upper)
            lines.append('    ldr x9, =fpregs')
            lines.append(f'    ldr x0, [x9, #{index * 8}]')
            lines.append('    bl phex')
        elif reg_upper.startswith('Q') and reg_upper[1:].isdigit():
            index = int(reg_upper[1:])
            add_label(reg_upper)
            emit_print_label(reg_upper)
            lines.append('    ldr x9, =qregs')
            lines.append(f'    ldr x0, [x9, #{index * 16 + 8}]')
            lines.append('    bl phex')
            emit_print_label(reg_upper)
            lines.append('    ldr x9, =qregs')
            lines.append(f'    ldr x0, [x9, #{index * 16}]')
            lines.append('    bl phex')

    for reg in expected_vecs:
        reg_upper = reg.upper()
        if reg_upper.startswith('V') and reg_upper[1:].isdigit():
            reg_upper = 'Q' + reg_upper[1:]
        if reg_upper.startswith('Q') and reg_upper[1:].isdigit():
            index = int(reg_upper[1:])
            add_label(reg_upper)
            emit_print_label(reg_upper)
            lines.append('    ldr x9, =qregs')
            lines.append(f'    ldr x0, [x9, #{index * 16 + 8}]')
            lines.append('    bl phex')
            emit_print_label(reg_upper)
            lines.append('    ldr x9, =qregs')
            lines.append(f'    ldr x0, [x9, #{index * 16}]')
            lines.append('    bl phex')

    if not lines:
        return ''
    return '\n'.join(['.data'] + labels + ['.text'] + lines)

def parse_int_literal(value):
    """解析十进制/十六进制/带符号字面量。"""
    if isinstance(value, int):
        return value
    return int(str(value), 0)

def emit_load_imm64(reg, value):
    """使用 literal 伪指令加载任意 64 位立即数。"""
    value &= 0xFFFFFFFFFFFFFFFF
    return [f'    ldr {reg}, =0x{value:X}']

def normalize_mem_values(values):
    """MemData/TlsData 允许单个值或值列表。统一转成列表。"""
    if isinstance(values, list):
        return values
    return [values]

def get_set_regdata(config):
    if not config:
        return {}
    return config.get('SetRegData', config.get('RegData', {}))

def get_set_vecdata(config):
    if not config:
        return {}
    return config.get('SetVecData', config.get('VecData', {}))

def parse_vec128(value):
    if isinstance(value, list) and len(value) >= 2:
        low = parse_int_literal(value[0]) & 0xFFFFFFFFFFFFFFFF
        high = parse_int_literal(value[1]) & 0xFFFFFFFFFFFFFFFF
        return low, high
    if isinstance(value, str):
        raw = value.lower().replace('0x', '').zfill(32)
        high = int(raw[:16], 16)
        low = int(raw[16:], 16)
        return low, high
    raise ValueError(f'Unsupported vector initializer: {value!r}')

def build_set_init(config):
    if not config:
        return '', ''

    setdata = []
    setinit = []

    for reg, value in get_set_regdata(config).items():
        reg_upper = reg.upper()
        if reg_upper.startswith('X') and reg_upper[1:].isdigit():
            reg_index = int(reg_upper[1:])
            setinit.extend(emit_load_imm64(f'x{reg_index}', parse_int_literal(value)))
        elif reg_upper.startswith('W') and reg_upper[1:].isdigit():
            reg_index = int(reg_upper[1:])
            setinit.extend(emit_load_imm64(f'x{reg_index}', parse_int_literal(value) & 0xFFFFFFFF))
        elif reg_upper == 'SP':
            sp_value = parse_int_literal(value) & 0xFFFFFFFFFFFFFFFF
            stack_base = (max(sp_value - 0x4000, 0)) & ~0xFFF
            stack_size = 0x8000
            setinit.append('    // Map stack pages for requested SP value')
            setinit.append('    mov x8, #222      // mmap syscall')
            setinit.extend(emit_load_imm64('x0', stack_base))
            setinit.extend(emit_load_imm64('x1', stack_size))
            setinit.append('    mov x2, #3        // PROT_READ | PROT_WRITE')
            setinit.append('    mov x3, #50       // MAP_PRIVATE | MAP_ANONYMOUS | MAP_FIXED')
            setinit.append('    mov x4, #-1       // fd = -1')
            setinit.append('    mov x5, #0        // offset = 0')
            setinit.append('    svc #0')
            setinit.extend(emit_load_imm64('x20', sp_value))
            setinit.append('    mov sp, x20')
        elif reg_upper.startswith('S') and reg_upper[1:].isdigit():
            reg_index = int(reg_upper[1:])
            label = f'set_s_{reg_index}'
            bits = parse_int_literal(value) & 0xFFFFFFFF
            setdata.append(f'{label}: .word 0x{bits:08X}')
            setinit.append(f'    ldr x9, ={label}')
            setinit.append(f'    ldr s{reg_index}, [x9]')
        elif reg_upper.startswith('D') and reg_upper[1:].isdigit():
            reg_index = int(reg_upper[1:])
            label = f'set_d_{reg_index}'
            bits = parse_int_literal(value) & 0xFFFFFFFFFFFFFFFF
            setdata.append(f'{label}: .quad 0x{bits:016X}')
            setinit.append(f'    ldr x9, ={label}')
            setinit.append(f'    ldr d{reg_index}, [x9]')

    for reg, value in get_set_vecdata(config).items():
        reg_upper = reg.upper()
        if (reg_upper.startswith('V') or reg_upper.startswith('Q')) and reg_upper[1:].isdigit():
            reg_index = int(reg_upper[1:])
            low, high = parse_vec128(value)
            label = f'set_q_{reg_index}'
            setdata.append(f'{label}:')
            setdata.append(f'    .quad 0x{low:016X}')
            setdata.append(f'    .quad 0x{high:016X}')
            setinit.append(f'    ldr x9, ={label}')
            setinit.append(f'    ldr q{reg_index}, [x9]')

    return '\n'.join(setdata), '\n'.join(setinit)

def parse_memdata(config):
    """解析 MemData 配置，返回内存初始化代码
    
    MemData 中的地址按测试里的绝对 guest 地址解释。
    例如 {"0x10000": ...} 会在 guest 0x10000 处建立映射并写入数据。
    membase 仅用于那些显式通过它取基址的测试。
    """
    if not config or 'MemData' not in config:
        return '', '', ''
    
    memdata_section = []  # .data 段中的数据定义
    memalloc_code = []    # mmap 分配代码
    meminit_code = []     # 运行时内存初始化代码
    
    memdata_config = config['MemData']
    
    entries = []
    min_addr = None
    max_end = 0
    for addr_str, raw_values in memdata_config.items():
        addr = parse_int_literal(addr_str)
        values = normalize_mem_values(raw_values)
        entries.append((addr, values))
        if min_addr is None:
            min_addr = addr
        else:
            min_addr = min(min_addr, addr)
        max_end = max(max_end, addr + len(values) * 8)

    base_addr = min_addr & ~0xFFF
    alloc_end = (max_end + 0xFFF) & ~0xFFF
    alloc_size = alloc_end - base_addr
    if alloc_size == 0:
        alloc_size = 0x1000

    # 生成 mmap 调用。使用 MAP_FIXED 把数据映射到测试里使用的绝对 guest 地址。
    memalloc_code.append('    // Allocate memory for MemData')
    memalloc_code.append('    mov x8, #222      // mmap syscall')
    memalloc_code.extend(emit_load_imm64('x0', base_addr))
    memalloc_code.extend(emit_load_imm64('x1', alloc_size))
    memalloc_code.append('    mov x2, #3        // PROT_READ | PROT_WRITE')
    memalloc_code.append('    mov x3, #50       // MAP_PRIVATE | MAP_ANONYMOUS | MAP_FIXED')
    memalloc_code.append('    mov x4, #-1       // fd = -1')
    memalloc_code.append('    mov x5, #0        // offset = 0')
    memalloc_code.append('    svc #0')
    memalloc_code.append('    mov x19, x0       // save base address in x19')
    
    # 存储基地址到 membase
    meminit_code.append('    // Store base address to membase')
    meminit_code.append('    ldr x9, =membase')
    meminit_code.append('    str x19, [x9]')
    
    # 为每个 MemData 条目生成数据和初始化代码
    for addr, values in entries:
        
        # 创建数据标签
        label = f'memdata_{addr:x}'
        
        # 在 .data 段定义数据
        memdata_section.append(f'{label}:')
        for v in values:
            if isinstance(v, str):
                val = v.replace('0x', '').replace('0X', '').zfill(16)
                memdata_section.append(f'    .quad 0x{val}')
            else:
                memdata_section.append(f'    .quad {v}')
        
        # 生成初始化代码：将数据复制到分配的内存
        num_values = len(values)
        for i in range(0, num_values, 2):
            offset = (addr - base_addr) + i * 8
            if i + 1 < num_values:
                meminit_code.append(f'    ldr x9, ={label}')
                meminit_code.append(f'    ldp x10, x11, [x9, #{i * 8}]')
                if offset == 0:
                    meminit_code.append(f'    mov x9, x19')
                elif offset <= 4095:
                    meminit_code.append(f'    add x9, x19, #{offset}')
                else:
                    # Use mov+movk for large offsets (ARM64 ADD immediate limit is 4095)
                    meminit_code.append(f'    mov x9, #{offset & 0xFFFF}')
                    if offset > 0xFFFF:
                        meminit_code.append(f'    movk x9, #{(offset >> 16) & 0xFFFF}, lsl #16')
                    if offset > 0xFFFF_FFFF:
                        meminit_code.append(f'    movk x9, #{(offset >> 32) & 0xFFFF}, lsl #32')
                    if offset > 0xFFFF_FFFF_FFFF:
                        meminit_code.append(f'    movk x9, #{(offset >> 48) & 0xFFFF}, lsl #48')
                    meminit_code.append(f'    add x9, x19, x9')
                meminit_code.append(f'    stp x10, x11, [x9]')
            else:
                meminit_code.append(f'    ldr x9, ={label}')
                meminit_code.append(f'    ldr x10, [x9, #{i * 8}]')
                if offset == 0:
                    meminit_code.append(f'    mov x9, x19')
                elif offset <= 4095:
                    meminit_code.append(f'    add x9, x19, #{offset}')
                else:
                    # Use mov+movk for large offsets (ARM64 ADD immediate limit is 4095)
                    meminit_code.append(f'    mov x9, #{offset & 0xFFFF}')
                    if offset > 0xFFFF:
                        meminit_code.append(f'    movk x9, #{(offset >> 16) & 0xFFFF}, lsl #16')
                    if offset > 0xFFFF_FFFF:
                        meminit_code.append(f'    movk x9, #{(offset >> 32) & 0xFFFF}, lsl #32')
                    if offset > 0xFFFF_FFFF_FFFF:
                        meminit_code.append(f'    movk x9, #{(offset >> 48) & 0xFFFF}, lsl #48')
                    meminit_code.append(f'    add x9, x19, x9')
                meminit_code.append(f'    str x10, [x9]')
    
    return '\n'.join(memdata_section), '\n'.join(memalloc_code), '\n'.join(meminit_code)

def parse_tlsdata(config):
    """解析 TlsData 配置，返回 TLS 数据定义和初始化代码
    
    TlsData 格式: {"offset": ["value1", "value2", ...]}
    偏移量是相对于 TLS 基址的偏移。
    """
    if not config or 'TlsData' not in config:
        return '', ''
    
    tlsdata_section = []  # TLS 数据标签定义
    tlsinit_code = []     # TLS 运行时初始化代码
    
    tlsdata_config = config['TlsData']
    
    # 为每个 TlsData 条目生成数据
    for offset_str, raw_values in tlsdata_config.items():
        offset = parse_int_literal(offset_str)
        values = normalize_mem_values(raw_values)
        
        # 创建数据标签
        label = f'tlsdata_{offset:x}'
        
        # 定义数据
        tlsdata_section.append(f'{label}:')
        for v in values:
            if isinstance(v, str):
                val = v.replace('0x', '').replace('0X', '').zfill(16)
                tlsdata_section.append(f'    .quad 0x{val}')
            else:
                tlsdata_section.append(f'    .quad {v}')
        
        # 生成初始化代码：将数据复制到 TLS 区域
        num_values = len(values)
        for i in range(0, num_values, 2):
            if i + 1 < num_values:
                tlsinit_code.append(f'    ldr x9, ={label}')
                tlsinit_code.append(f'    ldp x10, x11, [x9, #{i * 8}]')
                tlsinit_code.append(f'    ldr x9, =tls_area')
                tlsinit_code.append(f'    stp x10, x11, [x9, #{offset + i * 8}]')
            else:
                tlsinit_code.append(f'    ldr x9, ={label}')
                tlsinit_code.append(f'    ldr x10, [x9, #{i * 8}]')
                tlsinit_code.append(f'    ldr x9, =tls_area')
                tlsinit_code.append(f'    str x10, [x9, #{offset + i * 8}]')
    
    return '\n'.join(tlsdata_section), '\n'.join(tlsinit_code)

def run_qemu(asm_file):
    """运行 QEMU 并返回实际寄存器值"""
    with open(asm_file) as f:
        content = f.read()
    
    config = parse_config(content)
    code = extract_code(content)
    
    # 解析 MemData 并生成初始化代码
    memdata_section, memalloc_code, meminit_code = parse_memdata(config)
    
    # 解析 TlsData 并生成 TLS 初始化代码
    tlsdata_section, tlsinit_code = parse_tlsdata(config)
    setdata_section, setinit_code = build_set_init(config)
    
    with tempfile.TemporaryDirectory() as d:
        src = os.path.join(d, "t.S")
        obj = os.path.join(d, "t.o")
        exe = os.path.join(d, "t")
        
        with open(src, 'w') as f:
            template = RUNNER_TEMPLATE.replace('{CODE}', code)
            template = template.replace('{MEMDATA}', memdata_section)
            template = template.replace('{MEMALLOC}', memalloc_code)
            template = template.replace('{MEMINIT}', meminit_code)
            template = template.replace('{TLSDATA}', tlsdata_section)
            template = template.replace('{TLSINIT}', tlsinit_code)
            template = template.replace('{SETDATA}', setdata_section)
            template = template.replace('{SETINIT}', setinit_code)
            template = template.replace('{PRINT}', build_print_code(config))
            f.write(template)
        
        r = subprocess.run(['aarch64-none-elf-as', '-march=armv8.4-a', '-o', obj, src], 
                          capture_output=True, text=True)
        if r.returncode != 0:
            return None, f"ASM Error: {r.stderr}"
        
        r = subprocess.run(['aarch64-none-elf-ld', '-o', exe, obj],
                          capture_output=True, text=True)
        if r.returncode != 0:
            return None, f"LD Error: {r.stderr}"
        
        try:
            r = subprocess.run(
                ['qemu-aarch64', '-B', '0x40000000', '-cpu', 'max', exe],
                capture_output=True,
                timeout=5,
            )
            output = r.stdout.decode('utf-8', errors='ignore')
        except subprocess.TimeoutExpired:
            return None, "QEMU timeout"
        
        # 解析输出
        actual = {}
        q_values = {}  # 临时存储 Q 寄存器的多行值
        for line in output.strip().split('\n'):
            if '=' in line:
                key, val = line.split('=', 1)
                key = key.strip()
                val = val.strip()
                # Q 寄存器输出两行：第一行高64位，第二行低64位
                if key.startswith('Q') and key[1:].isdigit():
                    if key not in q_values:
                        q_values[key] = []
                    q_values[key].append(val)
                else:
                    actual[key] = val
        
        # 合并 Q 寄存器的两行值：高64位 + 低64位
        for key, vals in q_values.items():
            if len(vals) == 2:
                # 第一行是高64位，第二行是低64位
                high = vals[0].lower().replace('0x', '').zfill(16)
                low = vals[1].lower().replace('0x', '').zfill(16)
                actual[key] = f"0x{high}{low}"
            elif len(vals) == 1:
                actual[key] = vals[0]
        
        return actual, None

def normalize_hex(val):
    """标准化十六进制值：去掉前导零，统一格式"""
    val = str(val).lower().strip()
    if val.startswith('0x'):
        val = val[2:]
    # 去掉前导零，但保留至少一位
    val = val.lstrip('0') or '0'
    return '0x' + val

def compare_results(config, actual):
    """比较预期值和实际值"""
    errors = []

    expected_regs = config.get('ExpectedRegData', config.get('RegData', {}))
    if expected_regs:
        for reg, expected in expected_regs.items():
            reg_upper = reg.upper()
            
            # Handle W registers (32-bit, low half of X register)
            if reg_upper.startswith('W') and reg_upper[1:].isdigit():
                x_reg = 'X' + reg_upper[1:]
                if x_reg in actual:
                    # W register is lower 32 bits of X register
                    x_val = int(actual[x_reg], 16)
                    actual_val = x_val & 0xFFFFFFFF
                    expected_val = parse_int_literal(expected) & 0xFFFFFFFF
                    if actual_val != expected_val:
                        errors.append(f"{reg}: expected 0x{expected_val:08X}, got 0x{actual_val:08X}")
                else:
                    errors.append(f"{reg}: not in output (X{reg_upper[1:]} not found)")
            # Handle Q registers (128-bit vector) - output uses Q prefix
            elif reg_upper in actual:
                actual_val = normalize_hex(actual[reg_upper])
                expected_str = normalize_hex(expected)
                if actual_val != expected_str:
                    errors.append(f"{reg}: expected {expected_str}, got {actual_val}")
            else:
                errors.append(f"{reg}: not in output")

    expected_vecs = config.get('ExpectedVecData', config.get('VecData', {}))
    if expected_vecs:
        for reg, expected in expected_vecs.items():
            reg_upper = reg.upper()
            actual_key = reg_upper
            if reg_upper.startswith('V') and reg_upper[1:].isdigit():
                actual_key = 'Q' + reg_upper[1:]
            if actual_key in actual:
                low_val, high_val = parse_vec128(expected)
                high = f'{high_val:016x}'
                low = f'{low_val:016x}'
                expected_str = f"0x{high}{low}"
                actual_val = actual[actual_key].lower()
                # Normalize both for comparison
                expected_norm = normalize_hex(expected_str)
                actual_norm = normalize_hex(actual_val)
                if actual_norm != expected_norm:
                    errors.append(f"{reg}: expected {expected_norm}, got {actual_norm}")
            else:
                errors.append(f"{reg}: not in output")
    
    return errors

def run_test(asm_file):
    """运行单个测试"""
    with open(asm_file) as f:
        content = f.read()
    
    config = parse_config(content)
    if config is None:
        return False, "Failed to parse CONFIG"

    if 'QemuSkip' in config:
        return None, f"SKIP: {config['QemuSkip']}"

    # Check if test requires SvcTest - QEMU cannot handle this
    if 'SvcTest' in config:
        return None, "SKIP: SvcTest not supported by QEMU"
    
    actual, error = run_qemu(asm_file)
    if error:
        return False, error
    
    errors = compare_results(config, actual)
    if errors:
        return False, '\n'.join(errors)
    
    return True, None

def main():
    if len(sys.argv) < 2:
        print("Usage: python3 arm64_runner.py <test.s|directory>", file=sys.stderr)
        sys.exit(1)
    
    input_path = Path(sys.argv[1])
    test_files = []
    base_path = input_path
    
    if input_path.is_file():
        test_files = [input_path]
        base_path = input_path.parent
    elif input_path.is_dir():
        test_files = sorted(input_path.rglob('*.s'))
    else:
        print(f"Error: {input_path} is not a valid file or directory", file=sys.stderr)
        sys.exit(1)
    
    print("ARM64 Test Runner (QEMU)")
    print(f"Input: {input_path}")
    
    if len(test_files) > 1:
        print(f"\nFound {len(test_files)} test files")
    
    print()
    
    passed = 0
    failed = 0
    skipped = 0
    
    for test_file in test_files:
        rel_path = test_file.relative_to(base_path)
        print(f"Testing: {str(rel_path):<50} ... ", end='', flush=True)
        
        success, error = run_test(str(test_file))
        
        if success is None:
            # Skipped test
            print("\033[33mSKIPPED\033[0m")
            print(f"  {error}")
            skipped += 1
        elif success:
            print("\033[32mPASSED\033[0m")
            passed += 1
        else:
            print("\033[31mFAILED\033[0m")
            print(f"  {error}")
            failed += 1
    
    print()
    print("=" * 50)
    print(f"Summary: {passed} passed, {failed} failed, {skipped} skipped")
    
    sys.exit(0 if failed == 0 else 1)

if __name__ == '__main__':
    main()
