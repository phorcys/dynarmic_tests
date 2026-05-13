#!/usr/bin/env python3
"""
ARM32 Test Runner - 使用 QEMU 验证测试用例的正确性

用法:
  python3 arm32_runner.py test.s           # 单文件模式
  python3 arm32_runner.py tests/asm/       # 目录模式

输出: 与 asmtest 类似的格式，方便对比验证

原理:
1. 读取 .s 测试文件
2. 生成包装代码，保存寄存器到固定地址
3. 使用 qemu-arm 运行
4. 解析 CONFIG 中的预期值，与实际值对比

注意: 此框架不支持测试函数调用(BL/RET)，因为会跳过 bx lr 指令。
      测试函数调用应该使用 dynarmic_asmtest_a32。
"""

import subprocess, sys, tempfile, os, json, re
from pathlib import Path

RUNNER_TEMPLATE = r'''
.cpu cortex-a15
.fpu neon-vfpv4
.syntax unified

.data
.align 16
tls_area:
    .skip 0x1000
{TLSDATA}
.align 4
hex: .ascii "0123456789ABCDEF"
buf: .ascii "0x00000000\n"
.align 4
regs: .skip 80
.align 8
fpregs: .skip 64
.align 16
qregs: .skip 128
{DATAMEM}

.text
.global _start
_start:
    @ Clear GPRs before test
    mov r0, #0; mov r1, #0; mov r2, #0; mov r3, #0
    mov r4, #0; mov r5, #0; mov r6, #0; mov r7, #0
    mov r8, #0; mov r9, #0; mov r10, #0; mov r11, #0
    mov r12, #0

    @ Clear VFP/NEON registers
    vmov.i32 q0, #0
    vmov.i32 q1, #0
    vmov.i32 q2, #0
    vmov.i32 q3, #0

{TLSINIT}

{CODE}

__test_exit:
    @ Save GPRs R0-R12 - use movw/movt to avoid literal pool issues
    movw r8, #:lower16:regs
    movt r8, #:upper16:regs
    
    str r0, [r8, #0]
    str r1, [r8, #4]
    str r2, [r8, #8]
    str r3, [r8, #12]
    str r4, [r8, #16]
    str r5, [r8, #20]
    str r6, [r8, #24]
    str r7, [r8, #28]
    @ Save r8 copy using r9 as temp
    mov r9, r8
    str r9, [r8, #32]
    str r9, [r8, #36]   @ r9
    str r10, [r8, #40]
    str r11, [r8, #44]
    str r12, [r8, #48]
    str sp, [r8, #52]
    str lr, [r8, #56]

    @ Save D0-D7
    movw r8, #:lower16:fpregs
    movt r8, #:upper16:fpregs
    vstr d0, [r8, #0]
    vstr d1, [r8, #8]
    vstr d2, [r8, #16]
    vstr d3, [r8, #24]
    vstr d4, [r8, #32]
    vstr d5, [r8, #40]
    vstr d6, [r8, #48]
    vstr d7, [r8, #56]

    @ Save Q0-Q3
    movw r8, #:lower16:qregs
    movt r8, #:upper16:qregs
    vst1.32 {q0}, [r8:128]!
    vst1.32 {q1}, [r8:128]!
    vst1.32 {q2}, [r8:128]!
    vst1.32 {q3}, [r8:128]

    @ Print all values
    @ Load regs address into r9 (preserved across calls)
    movw r9, #:lower16:regs
    movt r9, #:upper16:regs
    
    @ Print R0-R7 (save value on stack, print name, restore value, print hex)
    ldr r0, [r9, #0]; push {r0}; mov r1, #0; bl print_reg_name; pop {r0}; bl phex32
    ldr r0, [r9, #4]; push {r0}; mov r1, #1; bl print_reg_name; pop {r0}; bl phex32
    ldr r0, [r9, #8]; push {r0}; mov r1, #2; bl print_reg_name; pop {r0}; bl phex32
    ldr r0, [r9, #12]; push {r0}; mov r1, #3; bl print_reg_name; pop {r0}; bl phex32
    ldr r0, [r9, #16]; push {r0}; mov r1, #4; bl print_reg_name; pop {r0}; bl phex32
    ldr r0, [r9, #20]; push {r0}; mov r1, #5; bl print_reg_name; pop {r0}; bl phex32
    ldr r0, [r9, #24]; push {r0}; mov r1, #6; bl print_reg_name; pop {r0}; bl phex32
    ldr r0, [r9, #28]; push {r0}; mov r1, #7; bl print_reg_name; pop {r0}; bl phex32

    @ Print R8-R12
    ldr r0, [r9, #32]; push {r0}; mov r1, #8; bl print_reg_name; pop {r0}; bl phex32
    ldr r0, [r9, #36]; push {r0}; mov r1, #9; bl print_reg_name; pop {r0}; bl phex32
    ldr r0, [r9, #40]; push {r0}; mov r1, #10; bl print_reg_name; pop {r0}; bl phex32
    ldr r0, [r9, #44]; push {r0}; mov r1, #11; bl print_reg_name; pop {r0}; bl phex32
    ldr r0, [r9, #48]; push {r0}; mov r1, #12; bl print_reg_name; pop {r0}; bl phex32

    @ Print SP, LR
    ldr r0, [r9, #52]; push {r0}; mov r1, #13; bl print_reg_name; pop {r0}; bl phex32
    ldr r0, [r9, #56]; push {r0}; mov r1, #14; bl print_reg_name; pop {r0}; bl phex32

    @ Print D0-D7 (64-bit each: high32 then low32)
    @ vstr stores D registers as: [low32, high32] in little-endian
    movw r8, #:lower16:fpregs
    movt r8, #:upper16:fpregs
    
    @ D0: print as 0xHIGH32LOW32
    mov r1, #100; bl print_d_reg_name
    ldr r0, [r8, #4]; bl phex32
    ldr r0, [r8, #0]; bl phex32
    
    mov r1, #101; bl print_d_reg_name
    ldr r0, [r8, #12]; bl phex32
    ldr r0, [r8, #8]; bl phex32
    
    mov r1, #102; bl print_d_reg_name
    ldr r0, [r8, #20]; bl phex32
    ldr r0, [r8, #16]; bl phex32
    
    mov r1, #103; bl print_d_reg_name
    ldr r0, [r8, #28]; bl phex32
    ldr r0, [r8, #24]; bl phex32
    
    mov r1, #104; bl print_d_reg_name
    ldr r0, [r8, #36]; bl phex32
    ldr r0, [r8, #32]; bl phex32
    
    mov r1, #105; bl print_d_reg_name
    ldr r0, [r8, #44]; bl phex32
    ldr r0, [r8, #40]; bl phex32
    
    mov r1, #106; bl print_d_reg_name
    ldr r0, [r8, #52]; bl phex32
    ldr r0, [r8, #48]; bl phex32
    
    mov r1, #107; bl print_d_reg_name
    ldr r0, [r8, #60]; bl phex32
    ldr r0, [r8, #56]; bl phex32

    @ Print Q0-Q3
    movw r8, #:lower16:qregs
    movt r8, #:upper16:qregs
    
    @ Q0: word3, word2, word1, word0
    ldr r0, [r8, #12]; push {r0}; ldr r0, [r8, #8]; push {r0}; ldr r0, [r8, #4]; push {r0}; ldr r0, [r8, #0]; push {r0}
    mov r1, #200; bl print_q_reg_name
    pop {r0}; bl phex32; pop {r0}; bl phex32; pop {r0}; bl phex32; pop {r0}; bl phex32
    
    add r8, r8, #16
    ldr r0, [r8, #12]; push {r0}; ldr r0, [r8, #8]; push {r0}; ldr r0, [r8, #4]; push {r0}; ldr r0, [r8, #0]; push {r0}
    mov r1, #201; bl print_q_reg_name
    pop {r0}; bl phex32; pop {r0}; bl phex32; pop {r0}; bl phex32; pop {r0}; bl phex32
    
    add r8, r8, #16
    ldr r0, [r8, #12]; push {r0}; ldr r0, [r8, #8]; push {r0}; ldr r0, [r8, #4]; push {r0}; ldr r0, [r8, #0]; push {r0}
    mov r1, #202; bl print_q_reg_name
    pop {r0}; bl phex32; pop {r0}; bl phex32; pop {r0}; bl phex32; pop {r0}; bl phex32
    
    add r8, r8, #16
    ldr r0, [r8, #12]; push {r0}; ldr r0, [r8, #8]; push {r0}; ldr r0, [r8, #4]; push {r0}; ldr r0, [r8, #0]; push {r0}
    mov r1, #203; bl print_q_reg_name
    pop {r0}; bl phex32; pop {r0}; bl phex32; pop {r0}; bl phex32; pop {r0}; bl phex32

    @ Exit
    mov r7, #1
    mov r0, #0
    svc #0

@ Print register name based on r1 (R0-R12, SP, LR)
print_reg_name:
    push {r4-r5, lr}
    movw r4, #:lower16:reg_names
    movt r4, #:upper16:reg_names
    @ r1 * 4 = offset in reg_names table
    lsl r5, r1, #2
    ldr r0, [r4, r5]
    bl print_str
    pop {r4-r5, pc}

@ Print D register name based on r1 (100-107 for D0-D7)
print_d_reg_name:
    push {r4-r5, lr}
    movw r4, #:lower16:d_reg_names
    movt r4, #:upper16:d_reg_names
    sub r1, r1, #100
    lsl r5, r1, #2
    ldr r0, [r4, r5]
    bl print_str
    pop {r4-r5, pc}

@ Print Q register name based on r1 (200-203 for Q0-Q3)
print_q_reg_name:
    push {r4-r5, lr}
    movw r4, #:lower16:q_reg_names
    movt r4, #:upper16:q_reg_names
    sub r1, r1, #200
    lsl r5, r1, #2
    ldr r0, [r4, r5]
    bl print_str
    pop {r4-r5, pc}

@ Print null-terminated string pointed by r0
print_str:
    push {r4-r8, lr}
    mov r4, r0
    mov r5, #0
    mov r8, #0
1:
    ldrb r6, [r4, r5]
    cmp r6, #0
    beq 2f
    add r5, r5, #1
    b 1b
2:
    mov r7, #4
    mov r0, #1
    mov r1, r4
    mov r2, r5
    svc #0
    pop {r4-r8, pc}

@ Print 32-bit hex value in r0
phex32:
    push {r4-r8, lr}
    movw r4, #:lower16:hex
    movt r4, #:upper16:hex
    movw r5, #:lower16:buf
    movt r5, #:upper16:buf
    mov r6, #2
    mov r7, #28
    mov r8, r0
1:
    lsr r0, r8, r7
    and r0, r0, #0xF
    ldrb r0, [r4, r0]
    strb r0, [r5, r6]
    add r6, r6, #1
    subs r7, r7, #4
    bpl 1b
    mov r7, #4
    mov r0, #1
    movw r1, #:lower16:buf
    movt r1, #:upper16:buf
    mov r2, #11
    svc #0
    pop {r4-r8, pc}

.data
.align 4
reg_names:
.word name_r0, name_r1, name_r2, name_r3, name_r4, name_r5, name_r6, name_r7
.word name_r8, name_r9, name_r10, name_r11, name_r12, name_sp, name_lr
d_reg_names:
.word name_d0, name_d1, name_d2, name_d3, name_d4, name_d5, name_d6, name_d7
q_reg_names:
.word name_q0, name_q1, name_q2, name_q3

name_r0: .asciz "R0="
name_r1: .asciz "R1="
name_r2: .asciz "R2="
name_r3: .asciz "R3="
name_r4: .asciz "R4="
name_r5: .asciz "R5="
name_r6: .asciz "R6="
name_r7: .asciz "R7="
name_r8: .asciz "R8="
name_r9: .asciz "R9="
name_r10: .asciz "R10="
name_r11: .asciz "R11="
name_r12: .asciz "R12="
name_sp: .asciz "SP="
name_lr: .asciz "LR="
name_d0: .asciz "D0="
name_d1: .asciz "D1="
name_d2: .asciz "D2="
name_d3: .asciz "D3="
name_d4: .asciz "D4="
name_d5: .asciz "D5="
name_d6: .asciz "D6="
name_d7: .asciz "D7="
name_q0: .asciz "Q0="
name_q1: .asciz "Q1="
name_q2: .asciz "Q2="
name_q3: .asciz "Q3="
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
    
    try:
        return json.loads(block[json_start:])
    except json.JSONDecodeError:
        return None

def transform_special_lines(code_lines, config):
    """对 TLS TPIDRURO/SvcTest 做最小必要的代码改写"""
    if not config:
        return code_lines

    transformed = []
    svc_entries = list(config.get('SvcTest', []))

    for line in code_lines:
        stripped = line.strip().lower()

        if 'TpidruroInit' in config:
            m = re.match(r'mrc\s+p15,\s*0,\s*(r\d+),\s*c13,\s*c0,\s*3$', stripped)
            if m:
                reg = m.group(1)
                value = parse_int_literal(config['TpidruroInit'])
                transformed.append(f'    ldr {reg}, =0x{value:08x}')
                continue

        svc_match = re.match(r'svc\s+#(0x[0-9a-f]+|\d+)$', stripped)
        if svc_match and svc_entries:
            svc_value = parse_int_literal(svc_match.group(1))
            matched = None
            for i, entry in enumerate(svc_entries):
                if parse_int_literal(entry['svc']) == svc_value:
                    matched = svc_entries.pop(i)
                    break
            if matched:
                offset = parse_int_literal(matched.get('offset', 0))
                transformed.append('    ldr r12, =0x3000')
                if offset:
                    transformed.append(f'    ldr r11, =0x{offset:x}')
                    transformed.append('    add r12, r12, r11')
                action = matched['action']
                reg = matched['result_reg'].lower()
                if action == 'read_tls':
                    transformed.append(f'    ldr {reg}, [r12]')
                    continue
                if action == 'write_tls':
                    transformed.append(f'    str {reg}, [r12]')
                    continue

        transformed.append(line)

    return transformed

def extract_code(content, config=None):
    """提取 .text 段中的代码（跳过 bkpt 和 bx lr 指令）"""
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
        if s.startswith('bkpt'):
            code.append('    b __test_exit')
            continue
        if s.startswith('.data') or s.startswith('.section'):
            break
        if in_text and s:
            # Preserve indentation for ARM assembly
            if not line.startswith(' ') and not line.startswith('\t'):
                code.append('    ' + line)
            else:
                code.append(line)
    code = transform_special_lines(code, config)
    return '\n'.join(code)

def generate_datamem_asm(config):
    """从 DataMem 配置生成数据段汇编代码"""
    if 'DataMem' not in config:
        return ""
    
    lines = []
    for addr, values in config['DataMem'].items():
        # 地址格式: "0x1000"
        addr_int = int(addr, 16) if isinstance(addr, str) else addr
        label = f"mem_{addr_int:x}"
        lines.append(f".align 4")
        lines.append(f".global {label}")
        lines.append(f"{label}:")
        
        # 值可以是列表或单个值
        if isinstance(values, list):
            for val in values:
                val_int = int(val, 16) if isinstance(val, str) and val.startswith('0x') else int(val)
                lines.append(f"    .byte 0x{val_int & 0xFF:02x}")
        else:
            val_int = int(values, 16) if isinstance(values, str) and values.startswith('0x') else int(values)
            lines.append(f"    .word 0x{val_int:08x}")
    
    return '\n'.join(lines)

def parse_int_literal(value):
    if isinstance(value, int):
        return value
    return int(str(value), 0)

def normalize_mem_values(raw_values):
    if isinstance(raw_values, list):
        return raw_values
    return [raw_values]

def generate_tls_asm(config):
    """生成 TLS 数据定义和 TPIDR/TLS 初始化代码"""
    if not config:
        return "", ""

    tls_lines = []
    tls_init = []

    if 'TpidrurwInit' in config:
        value = parse_int_literal(config['TpidrurwInit'])
        tls_init.append(f"    ldr r0, ={value}")
        tls_init.append("    mcr p15, 0, r0, c13, c0, 2")

    if 'TlsData' in config:
        for offset_str, raw_values in config['TlsData'].items():
            offset = parse_int_literal(offset_str)
            values = normalize_mem_values(raw_values)

            tls_init.append("    ldr r12, =0x3000")
            if offset:
                tls_init.append(f"    ldr r11, ={offset}")
                tls_init.append("    add r12, r12, r11")
            cursor = 0
            for v in values:
                if isinstance(v, str):
                    val = int(v, 0)
                else:
                    val = int(v)
                if 0 <= val <= 0xFFFFFFFF:
                    tls_init.append(f"    ldr r1, =0x{val:08x}")
                    tls_init.append(f"    str r1, [r12, #{cursor}]")
                    cursor += 4
                else:
                    low = val & 0xFFFFFFFF
                    high = (val >> 32) & 0xFFFFFFFF
                    tls_init.append(f"    ldr r1, =0x{low:08x}")
                    tls_init.append(f"    ldr r2, =0x{high:08x}")
                    tls_init.append(f"    str r1, [r12, #{cursor}]")
                    tls_init.append(f"    str r2, [r12, #{cursor + 4}]")
                    cursor += 8

    return '\n'.join(tls_lines), '\n'.join(tls_init)

def run_qemu(asm_file):
    """运行 QEMU 并返回实际寄存器值"""
    with open(asm_file) as f:
        content = f.read()
    
    config = parse_config(content)
    code = extract_code(content, config)
    datamem_asm = generate_datamem_asm(config) if config else ""
    tls_asm, tls_init = generate_tls_asm(config)
    
    with tempfile.TemporaryDirectory() as d:
        src = os.path.join(d, "t.S")
        obj = os.path.join(d, "t.o")
        exe = os.path.join(d, "t")
        
        with open(src, 'w') as f:
            template = RUNNER_TEMPLATE.replace('{CODE}', code)
            template = template.replace('{DATAMEM}', datamem_asm)
            template = template.replace('{TLSDATA}', tls_asm)
            template = template.replace('{TLSINIT}', tls_init)
            f.write(template)
        
        # Use ARMv7 assembler with cortex-a15 for SDIV/UDIV support
        r = subprocess.run(['arm-none-eabi-as', '-mcpu=cortex-a15', '-mfpu=neon-vfpv4', '-o', obj, src], 
                          capture_output=True, text=True)
        if r.returncode != 0:
            return None, f"ASM Error: {r.stderr}"
        
        # Use ARM linker
        r = subprocess.run(['arm-none-eabi-ld', '-Ttext', '0x400000', '-Tdata', '0x3000', '-o', exe, obj],
                          capture_output=True, text=True)
        if r.returncode != 0:
            return None, f"LD Error: {r.stderr}"
        
        try:
            # Use qemu-arm with Cortex-A15 (ARMv7 with NEON/VFPv4)
            # -B 0x40000000 sets guest_base to avoid mmap_min_addr restriction
            r = subprocess.run(['qemu-arm', '-B', '0x40000000', '-cpu', 'cortex-a15', exe], 
                              capture_output=True, text=True, timeout=5)
            output = r.stdout
        except subprocess.TimeoutExpired:
            return None, "QEMU timeout"
        
        # 解析输出
        actual = {}
        d_values = {}  # 临时存储 D 寄存器的多行值
        q_values = {}  # 临时存储 Q 寄存器的多行值
        current_d = None  # 当前正在处理的 D 寄存器
        current_q = None  # 当前正在处理的 Q 寄存器
        
        for line in output.strip().split('\n'):
            line = line.strip()
            if not line:
                continue
                
            if '=' in line:
                key, val = line.split('=', 1)
                key = key.strip()
                val = val.strip()
                
                # D 寄存器输出：D0=HIGH32，下一行是 LOW32
                if key.startswith('D') and key[1:].isdigit():
                    current_d = key
                    current_q = None
                    if key not in d_values:
                        d_values[key] = []
                    d_values[key].append(val)  # 高 32 位
                # Q 寄存器输出四行
                elif key.startswith('Q') and key[1:].isdigit():
                    current_d = None
                    current_q = key
                    if key not in q_values:
                        q_values[key] = []
                    q_values[key].append(val)
                else:
                    current_d = None
                    current_q = None
                    actual[key] = val
            elif current_d is not None:
                # 这是 D 寄存器的低 32 位
                d_values[current_d].append(line)
            elif current_q is not None:
                # 这是 Q 寄存器的后续行
                q_values[current_q].append(line)
            # 忽略其他没有 "=" 的行
        
        # 合并 D 寄存器的两行值：高32位 + 低32位 -> 0xHIGHLOW
        for key, vals in d_values.items():
            if len(vals) == 2:
                high = vals[0].lower().replace('0x', '').zfill(8)
                low = vals[1].lower().replace('0x', '').zfill(8)
                actual[key] = f"0x{high}{low}"
            elif len(vals) == 1:
                # 单精度浮点，只有 32 位
                actual[key] = vals[0]
        
        # 合并 Q 寄存器的四行值：word3, word2, word1, word0 -> 0x[word3][word2][word1][word0]
        for key, vals in q_values.items():
            if len(vals) == 4:
                w3 = vals[0].lower().replace('0x', '').zfill(8)
                w2 = vals[1].lower().replace('0x', '').zfill(8)
                w1 = vals[2].lower().replace('0x', '').zfill(8)
                w0 = vals[3].lower().replace('0x', '').zfill(8)
                actual[key] = f"0x{w3}{w2}{w1}{w0}"
            elif len(vals) == 1:
                actual[key] = vals[0]
        
        return actual, None

def compare_results(config, actual):
    """比较预期值和实际值"""
    errors = []
    
    if 'RegData' in config:
        for reg, expected in config['RegData'].items():
            reg_upper = reg.upper()
            
            # Handle Q registers (128-bit vector)
            if reg_upper.startswith('Q') and reg_upper[1:].isdigit():
                if reg_upper in actual:
                    actual_val = actual[reg_upper].lower()
                    expected_str = str(expected).lower()
                    if not expected_str.startswith('0x'):
                        expected_str = '0x' + expected_str
                    if actual_val != expected_str:
                        errors.append(f"{reg}: expected {expected_str}, got {actual_val}")
                else:
                    errors.append(f"{reg}: not in output")
            # Handle D registers (64-bit)
            elif reg_upper.startswith('D') and reg_upper[1:].isdigit():
                if reg_upper in actual:
                    actual_val = actual[reg_upper].lower()
                    expected_str = str(expected).lower()
                    if not expected_str.startswith('0x'):
                        expected_str = '0x' + expected_str
                    if actual_val != expected_str:
                        errors.append(f"{reg}: expected {expected_str}, got {actual_val}")
                else:
                    errors.append(f"{reg}: not in output")
            elif reg_upper in actual:
                actual_val = actual[reg_upper].lower()
                expected_str = str(expected).lower()
                if not expected_str.startswith('0x'):
                    expected_str = '0x' + expected_str
                if actual_val != expected_str:
                    errors.append(f"{reg}: expected {expected_str}, got {actual_val}")
            else:
                errors.append(f"{reg}: not in output")
    
    if 'VecData' in config:
        for reg, expected in config['VecData'].items():
            reg_upper = reg.upper()
            if reg_upper in actual:
                # expected is [low, high] for 64-bit, or [w0, w1, w2, w3] for 128-bit
                if isinstance(expected, list):
                    if len(expected) == 2:
                        # 64-bit D register
                        high = str(expected[1]).lower().replace('0x', '').zfill(8)
                        low = str(expected[0]).lower().replace('0x', '').zfill(8)
                        expected_str = f"0x{high}{low}"
                    elif len(expected) == 4:
                        # 128-bit Q register
                        w3 = str(expected[3]).lower().replace('0x', '').zfill(8)
                        w2 = str(expected[2]).lower().replace('0x', '').zfill(8)
                        w1 = str(expected[1]).lower().replace('0x', '').zfill(8)
                        w0 = str(expected[0]).lower().replace('0x', '').zfill(8)
                        expected_str = f"0x{w3}{w2}{w1}{w0}"
                    else:
                        expected_str = str(expected[0]).lower()
                        if not expected_str.startswith('0x'):
                            expected_str = '0x' + expected_str
                else:
                    expected_str = str(expected).lower()
                    if not expected_str.startswith('0x'):
                        expected_str = '0x' + expected_str
                
                actual_val = actual[reg_upper].lower()
                if actual_val != expected_str:
                    errors.append(f"{reg}: expected {expected_str}, got {actual_val}")
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
    
    actual, error = run_qemu(asm_file)
    if error:
        return False, error
    
    errors = compare_results(config, actual)
    if errors:
        return False, '\n'.join(errors)
    
    return True, None

def main():
    if len(sys.argv) < 2:
        print("Usage: python3 arm32_runner.py <test.s|directory>", file=sys.stderr)
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
    
    print("ARM32 Test Runner (QEMU)")
    print(f"Input: {input_path}")
    
    if len(test_files) > 1:
        print(f"\nFound {len(test_files)} test files")
    
    print()
    
    passed = 0
    failed = 0
    
    for test_file in test_files:
        rel_path = test_file.relative_to(base_path)
        print(f"Testing: {str(rel_path):<50} ... ", end='', flush=True)
        
        success, error = run_test(str(test_file))
        
        if success:
            print("\033[32mPASSED\033[0m")
            passed += 1
        else:
            print("\033[31mFAILED\033[0m")
            print(f"  {error}")
            failed += 1
    
    print()
    print("=" * 50)
    print(f"Summary: {passed} passed, {failed} failed")
    
    sys.exit(0 if failed == 0 else 1)

if __name__ == '__main__':
    main()
