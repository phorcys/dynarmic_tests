#!/usr/bin/env python3
"""
A32 测试用例生成器

生成 ARM32 指令测试用例，使用 QEMU 获取预期值
"""

import os
import subprocess
import sys
import tempfile
import json
from pathlib import Path

# ARM32 测试模板
TESTS = {
    # Group 1: 数据处理指令
    "mov_imm8": {
        "asm": """
    mov r0, #0
    mov r1, #255
    mov r2, #128
    mov r3, #1
    mov r4, #127
""",
        "regs": ["R0", "R1", "R2", "R3", "R4"]
    },
    "mov_shift": {
        "asm": """
    mov r0, #1, LSL #8
    mov r1, #1, LSL #16
    mov r2, #1, LSL #24
    mov r3, #255, LSL #8
""",
        "regs": ["R0", "R1", "R2", "R3"]
    },
    "mvn_imm": {
        "asm": """
    mvn r0, #0
    mvn r1, #255
    mvn r2, #0xFF
    mvn r3, #0
""",
        "regs": ["R0", "R1", "R2", "R3"]
    },
    "movw_test": {
        "asm": """
    movw r0, #0
    movw r1, #65535
    movw r2, #0x1234
    movw r3, #0xABCD
""",
        "regs": ["R0", "R1", "R2", "R3"]
    },
    "movt_test": {
        "asm": """
    movw r0, #0x5678
    movt r0, #0x1234
    movw r1, #0
    movt r1, #0xFFFF
    movw r2, #0x1111
    movt r2, #0x2222
""",
        "regs": ["R0", "R1", "R2"]
    },
    
    # Group 2: 算术指令
    "add_imm12": {
        "asm": """
    mov r0, #0
    add r0, r0, #4095
    mov r1, #1000
    add r1, r1, #3000
    mov r2, #0
    add r2, r2, #256
    add r2, r2, #256
""",
        "regs": ["R0", "R1", "R2"]
    },
    "add_reg_shift": {
        "asm": """
    mov r0, #1
    mov r1, #1
    add r2, r0, r1, LSL #1
    add r3, r0, r1, LSL #2
    add r4, r0, r1, LSL #3
""",
        "regs": ["R2", "R3", "R4"]
    },
    "adc_chain": {
        "asm": """
    mov r0, #0xFFFFFFFF
    mov r1, #1
    adds r0, r0, #1
    mov r2, #0
    adc r2, r2, #0
    mov r3, #0xFFFFFFFF
    mov r4, #0xFFFFFFFF
    adds r3, r3, r4
    mov r5, #0
    adc r5, r5, #0
""",
        "regs": ["R2", "R5"]
    },
    "sub_imm12": {
        "asm": """
    mov r0, #1000
    sub r0, r0, #500
    mov r1, #4095
    sub r1, r1, #4095
    mov r2, #100
    sub r2, r2, #50
""",
        "regs": ["R0", "R1", "R2"]
    },
    "rsb_test": {
        "asm": """
    mov r0, #10
    rsb r0, r0, #100
    mov r1, #5
    rsb r1, r1, #0
    mov r2, #100
    rsb r2, r2, #50
""",
        "regs": ["R0", "R1", "R2"]
    },
    "sbc_test": {
        "asm": """
    mov r0, #0
    mov r1, #10
    subs r1, r1, #20
    sbc r2, r0, #0
    mov r3, #100
    subs r3, r3, #50
    sbc r4, r0, #0
""",
        "regs": ["R2", "R4"]
    },
    "rsc_test": {
        "asm": """
    mov r0, #10
    mov r1, #20
    subs r1, r1, r0
    mov r2, #0
    rsc r2, r0, #0
""",
        "regs": ["R2"]
    },
    
    # Group 3: 逻辑指令
    "and_imm": {
        "asm": """
    mov r0, #0xFF
    and r0, r0, #0x0F
    mov r1, #0xFF00
    and r1, r1, #0xF0F0
    mov r2, #0xFFFF
    and r2, r2, #0x00FF
""",
        "regs": ["R0", "R1", "R2"]
    },
    "orr_imm": {
        "asm": """
    mov r0, #0xF0
    orr r0, r0, #0x0F
    mov r1, #0xFF00
    orr r1, r1, #0x00FF
    mov r2, #0
    orr r2, r2, #0xFFFF
""",
        "regs": ["R0", "R1", "R2"]
    },
    "eor_imm": {
        "asm": """
    mov r0, #0xFF
    eor r0, r0, #0x0F
    mov r1, #0xFFFF
    eor r1, r1, #0xFFFF
    mov r2, #0xAAAA
    eor r2, r2, #0x5555
""",
        "regs": ["R0", "R1", "R2"]
    },
    "bic_imm": {
        "asm": """
    mov r0, #0xFF
    bic r0, r0, #0xF0
    mov r1, #0xFFFF
    bic r1, r1, #0x0F0F
    mov r2, #0x12345678
    bic r2, r2, #0xFF
""",
        "regs": ["R0", "R1", "R2"]
    },
    "orn_imm": {
        "asm": """
    mov r0, #0
    orn r0, r0, #0xFF
    mov r1, #0xFFFF0000
    orn r1, r1, #0x0000FFFF
""",
        "regs": ["R0", "R1"]
    },
    
    # Group 4: 移位指令
    "lsl_reg": {
        "asm": """
    mov r0, #1
    mov r1, #4
    lsl r2, r0, r1
    mov r3, #1
    mov r4, #31
    lsl r5, r3, r4
""",
        "regs": ["R2", "R5"]
    },
    "lsr_reg": {
        "asm": """
    mov r0, #0x80000000
    mov r1, #4
    lsr r2, r0, r1
    mov r3, #0x80000000
    mov r4, #31
    lsr r5, r3, r4
""",
        "regs": ["R2", "R5"]
    },
    "asr_reg": {
        "asm": """
    mov r0, #0x80000000
    mov r1, #4
    asr r2, r0, r1
    mov r3, #0x80000000
    mov r4, #31
    asr r5, r3, r4
""",
        "regs": ["R2", "R5"]
    },
    "ror_reg": {
        "asm": """
    mov r0, #0x00000001
    mov r1, #4
    ror r2, r0, r1
    mov r3, #0x80000000
    mov r4, #1
    ror r5, r3, r4
""",
        "regs": ["R2", "R5"]
    },
    
    # Group 5: 比较指令
    "cmp_imm": {
        "asm": """
    mov r0, #100
    cmp r0, #50
    mov r1, #100
    cmp r1, #100
    mov r2, #50
    cmp r2, #100
""",
        "regs": ["R0", "R1", "R2"]
    },
    "cmn_imm": {
        "asm": """
    mov r0, #100
    cmn r0, #50
    mov r1, #100
    cmn r1, #100
    mov r2, #200
    cmn r2, #56
""",
        "regs": ["R0", "R1", "R2"]
    },
    "tst_imm": {
        "asm": """
    mov r0, #0xFF
    tst r0, #0x0F
    mov r1, #0xFF
    tst r1, #0xF0
    mov r2, #0
    tst r2, #1
""",
        "regs": ["R0", "R1", "R2"]
    },
    "teq_imm": {
        "asm": """
    mov r0, #0xFF
    teq r0, #0xFF
    mov r1, #0xFF
    teq r1, #0x0F
    mov r2, #0
    teq r2, #0
""",
        "regs": ["R0", "R1", "R2"]
    },
    
    # Group 6: 乘法指令
    "mul_flags": {
        "asm": """
    mov r0, #100
    mov r1, #50
    muls r2, r0, r1
    mov r3, #0
    mov r4, #0
    muls r5, r3, r4
""",
        "regs": ["R2", "R5"]
    },
    "mla_test": {
        "asm": """
    mov r0, #10
    mov r1, #20
    mov r2, #5
    mla r3, r0, r1, r2
    mov r4, #0
    mov r5, #0
    mov r6, #100
    mla r7, r4, r5, r6
""",
        "regs": ["R3", "R7"]
    },
    "umull_test": {
        "asm": """
    mov r0, #100000
    mov r1, #100000
    umull r2, r3, r0, r1
    mov r4, #0xFFFFFFFF
    mov r5, #2
    umull r6, r7, r4, r5
""",
        "regs": ["R2", "R3", "R6", "R7"]
    },
    "smull_test": {
        "asm": """
    mov r0, #100
    neg r0, r0
    mov r1, #100
    smull r2, r3, r0, r1
    mov r4, #0x80000000
    mov r5, #2
    smull r6, r7, r4, r5
""",
        "regs": ["R2", "R3", "R6", "R7"]
    },
    "umlal_test": {
        "asm": """
    mov r0, #1000
    mov r1, #1000
    mov r2, #0
    mov r3, #0
    umlal r2, r3, r0, r1
    mov r4, #0
    mov r5, #1
    mov r6, #0
    mov r7, #0
    umlal r6, r7, r4, r5
""",
        "regs": ["R2", "R3", "R6", "R7"]
    },
    "smlal_test": {
        "asm": """
    mov r0, #100
    neg r0, r0
    mov r1, #100
    mov r2, #0
    mov r3, #0
    smlal r2, r3, r0, r1
    mov r4, #0x80000000
    mov r5, #1
    mov r6, #0
    mov r7, #0
    smlal r6, r7, r4, r5
""",
        "regs": ["R2", "R3", "R6", "R7"]
    },
    
    # Group 7: 除法指令
    "sdiv_test": {
        "asm": """
    mov r0, #100
    mov r1, #5
    sdiv r2, r0, r1
    mov r3, #100
    neg r3, r3
    mov r4, #5
    sdiv r5, r3, r4
    mov r6, #100
    mov r7, #0
    sdiv r8, r6, r7
""",
        "regs": ["R2", "R5", "R8"]
    },
    "udiv_test": {
        "asm": """
    mov r0, #100
    mov r1, #5
    udiv r2, r0, r1
    mov r3, #0xFFFFFFFF
    mov r4, #2
    udiv r5, r3, r4
    mov r6, #100
    mov r7, #0
    udiv r8, r6, r7
""",
        "regs": ["R2", "R5", "R8"]
    },
    
    # Group 8: 位域指令
    "bfc_test": {
        "asm": """
    mov r0, #0xFFFFFFFF
    bfc r0, #4, #8
    mov r1, #0xFFFFFFFF
    bfc r1, #0, #16
    mov r2, #0xFFFFFFFF
    bfc r2, #16, #16
""",
        "regs": ["R0", "R1", "R2"]
    },
    "bfi_test": {
        "asm": """
    mov r0, #0
    mov r1, #0xFF
    bfi r0, r1, #8, #8
    mov r2, #0
    mov r3, #0xFFFF
    bfi r2, r3, #0, #16
""",
        "regs": ["R0", "R2"]
    },
    "sbfx_test": {
        "asm": """
    mov r0, #0xFF
    sbfx r1, r0, #0, #8
    mov r2, #0x80
    sbfx r3, r2, #0, #8
    mov r4, #0x80000000
    sbfx r5, r4, #31, #1
""",
        "regs": ["R1", "R3", "R5"]
    },
    "ubfx_test": {
        "asm": """
    mov r0, #0xFFFFFFFF
    ubfx r1, r0, #0, #8
    ubfx r2, r0, #8, #8
    ubfx r3, r0, #16, #16
""",
        "regs": ["R1", "R2", "R3"]
    },
    
    # Group 9: 饱和指令
    "ssat_test": {
        "asm": """
    mov r0, #1000
    ssat r1, #8, r0
    mov r2, #1000
    neg r2, r2
    ssat r3, #8, r2
    mov r4, #100
    ssat r5, #8, r4
""",
        "regs": ["R1", "R3", "R5"]
    },
    "usat_test": {
        "asm": """
    mov r0, #1000
    usat r1, #8, r0
    mov r2, #1000
    neg r2, r2
    usat r3, #8, r2
    mov r4, #100
    usat r5, #8, r4
""",
        "regs": ["R1", "R3", "R5"]
    },
    "qadd_test": {
        "asm": """
    mov r0, #0x7FFFFFFF
    mov r1, #1
    qadd r2, r0, r1
    mov r3, #0x80000000
    mov r4, #1
    neg r4, r4
    qadd r5, r3, r4
""",
        "regs": ["R2", "R5"]
    },
    "qsub_test": {
        "asm": """
    mov r0, #0x80000000
    mov r1, #1
    qsub r2, r0, r1
    mov r3, #0x7FFFFFFF
    mov r4, #1
    neg r4, r4
    qsub r5, r3, r4
""",
        "regs": ["R2", "R5"]
    },
    
    # Group 10: 条件指令
    "csel_eq": {
        "asm": """
    mov r0, #10
    mov r1, #20
    cmp r0, r0
    moveq r2, r0
    movne r2, r1
    cmp r0, r1
    moveq r3, r0
    movne r3, r1
""",
        "regs": ["R2", "R3"]
    },
    "csel_lt": {
        "asm": """
    mov r0, #10
    mov r1, #20
    cmp r0, r1
    movlt r2, r0
    movge r2, r1
    cmp r1, r0
    movlt r3, r0
    movge r3, r1
""",
        "regs": ["R2", "R3"]
    },
    
    # Group 11: 扩展指令
    "sxtb_test": {
        "asm": """
    mov r0, #0x7F
    sxtb r1, r0
    mov r2, #0x80
    sxtb r3, r2
    mov r4, #0xFF
    sxtb r5, r4
""",
        "regs": ["R1", "R3", "R5"]
    },
    "sxth_test": {
        "asm": """
    mov r0, #0x7FFF
    sxth r1, r0
    mov r2, #0x8000
    sxth r3, r2
    mov r4, #0xFFFF
    sxth r5, r4
""",
        "regs": ["R1", "R3", "R5"]
    },
    "uxtb_test": {
        "asm": """
    mov r0, #0x7F
    uxtb r1, r0
    mov r2, #0x80
    uxtb r3, r2
    mov r4, #0xFF
    uxtb r5, r4
    mov r6, #0x100
    uxtb r7, r6
""",
        "regs": ["R1", "R3", "R5", "R7"]
    },
    "uxth_test": {
        "asm": """
    mov r0, #0x7FFF
    uxth r1, r0
    mov r2, #0x8000
    uxth r3, r2
    mov r4, #0xFFFF
    uxth r5, r4
    mov r6, #0x10000
    uxth r7, r6
""",
        "regs": ["R1", "R3", "R5", "R7"]
    },
    
    # Group 12: 位操作指令
    "clz_test": {
        "asm": """
    mov r0, #0
    clz r1, r0
    mov r2, #1
    clz r3, r2
    mov r4, #0x80000000
    clz r5, r4
    mov r6, #0xFFFFFFFF
    clz r7, r6
""",
        "regs": ["R1", "R3", "R5", "R7"]
    },
    "rbit_test": {
        "asm": """
    mov r0, #1
    rbit r1, r0
    mov r2, #0x80000000
    rbit r3, r2
    mov r4, #0xF0F0F0F0
    rbit r5, r4
""",
        "regs": ["R1", "R3", "R5"]
    },
    "rev_test": {
        "asm": """
    mov r0, #0x12345678
    rev r1, r0
    mov r2, #0x00000001
    rev r3, r2
    mov r4, #0x01000000
    rev r5, r4
""",
        "regs": ["R1", "R3", "R5"]
    },
    "rev16_test": {
        "asm": """
    mov r0, #0x12345678
    rev16 r1, r0
    mov r2, #0xFF00FF00
    rev16 r3, r2
""",
        "regs": ["R1", "R3"]
    },
    "revsh_test": {
        "asm": """
    mov r0, #0x12345678
    revsh r1, r0
    mov r2, #0x0000FF00
    revsh r3, r2
""",
        "regs": ["R1", "R3"]
    },
    
    # Group 13: 系统指令
    "mrs_cpsr": {
        "asm": """
    mov r0, #0
    msr cpsr_c, #0x1F
    mrs r1, cpsr
    and r1, r1, #0x1F
""",
        "regs": ["R1"]
    },
}

def run_qemu_for_values(asm_code, reg_list):
    """使用 QEMU 获取寄存器值"""
    
    template = r'''
.cpu cortex-a15
.fpu neon-vfpv4
.syntax unified

.data
.align 4
regs: .skip 60

.text
.global _start
_start:
    @ Clear GPRs
    mov r0, #0; mov r1, #0; mov r2, #0; mov r3, #0
    mov r4, #0; mov r5, #0; mov r6, #0; mov r7, #0
    mov r8, #0; mov r9, #0; mov r10, #0; mov r11, #0
    mov r12, #0

{CODE}

    @ Save GPRs R0-R12
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
    str r8, [r8, #32]
    mov r9, r8
    str r9, [r8, #36]
    str r10, [r8, #40]
    str r11, [r8, #44]
    str r12, [r8, #48]
    str sp, [r8, #52]
    str lr, [r8, #56]

    @ Print values
    movw r9, #:lower16:regs
    movt r9, #:upper16:regs
    
    ldr r0, [r9, #0]; bl print_hex
    ldr r0, [r9, #4]; bl print_hex
    ldr r0, [r9, #8]; bl print_hex
    ldr r0, [r9, #12]; bl print_hex
    ldr r0, [r9, #16]; bl print_hex
    ldr r0, [r9, #20]; bl print_hex
    ldr r0, [r9, #24]; bl print_hex
    ldr r0, [r9, #28]; bl print_hex
    ldr r0, [r9, #32]; bl print_hex
    ldr r0, [r9, #36]; bl print_hex
    ldr r0, [r9, #40]; bl print_hex
    ldr r0, [r9, #44]; bl print_hex
    ldr r0, [r9, #48]; bl print_hex
    ldr r0, [r9, #52]; bl print_hex
    ldr r0, [r9, #56]; bl print_hex

    mov r7, #1
    mov r0, #0
    svc #0

print_hex:
    push {r4-r7, lr}
    mov r4, r0
    mov r7, #4
    mov r0, #1
    mov r1, #0
    add r1, sp, #0
    sub r1, r1, #20
    mov r5, r1
    mov r6, #0
    mov r2, #0
    strb r2, [r5, #8]
    mov r2, #8
1:
    mov r0, r4, LSR #28
    cmp r0, #10
    addlt r0, r0, #48
    addge r0, r0, #55
    strb r0, [r5, r6]
    add r6, r6, #1
    mov r4, r4, LSL #4
    cmp r6, #8
    blt 1b
    mov r0, #1
    mov r1, r5
    mov r2, #9
    svc #0
    pop {r4-r7, pc}
'''
    
    with tempfile.TemporaryDirectory() as d:
        src = os.path.join(d, "t.S")
        obj = os.path.join(d, "t.o")
        exe = os.path.join(d, "t")
        
        with open(src, 'w') as f:
            f.write(template.replace('{CODE}', asm_code))
        
        r = subprocess.run(['arm-none-eabi-as', '-mcpu=cortex-a15', '-mfpu=neon-vfpv4', '-o', obj, src], 
                          capture_output=True, text=True)
        if r.returncode != 0:
            return None, f"ASM Error: {r.stderr}"
        
        r = subprocess.run(['arm-none-eabi-ld', '-o', exe, obj],
                          capture_output=True, text=True)
        if r.returncode != 0:
            return None, f"LD Error: {r.stderr}"
        
        try:
            r = subprocess.run(['qemu-arm', '-B', '0x40000000', '-cpu', 'cortex-a15', exe], 
                              capture_output=True, text=True, timeout=5)
            output = r.stdout
        except subprocess.TimeoutExpired:
            return None, "QEMU timeout"
        
        # 解析输出
        values = output.strip().split('\n')
        reg_values = {}
        for i, reg in enumerate(["R0", "R1", "R2", "R3", "R4", "R5", "R6", "R7", "R8", "R9", "R10", "R11", "R12", "SP", "LR"]):
            if i < len(values):
                val = values[i].strip()
                reg_values[reg] = f"0x{val}"
        
        return reg_values, None

def generate_test_file(test_name, test_data, output_dir):
    """生成测试文件"""
    
    asm_code = test_data["asm"]
    reg_list = test_data["regs"]
    
    # 获取预期值
    reg_values, error = run_qemu_for_values(asm_code, reg_list)
    
    if error:
        print(f"  ERROR getting values for {test_name}: {error}")
        return False
    
    # 构建 RegData
    reg_data = {}
    for reg in reg_list:
        if reg in reg_values:
            reg_data[reg] = reg_values[reg]
    
    # 生成测试文件
    config = {
        "Match": "All",
        "RegData": reg_data
    }
    
    content = f'''/* CONFIG
{json.dumps(config, indent=2)}
*/
.text
.global _start
_start:
{asm_code}
    bkpt #0
'''
    
    output_file = os.path.join(output_dir, f"{test_name}.s")
    with open(output_file, 'w') as f:
        f.write(content)
    
    return True

def main():
    output_dir = Path(__file__).parent / "a32"
    output_dir.mkdir(exist_ok=True)
    
    print(f"Generating A32 tests in {output_dir}")
    print(f"Total tests to generate: {len(TESTS)}")
    print()
    
    generated = 0
    skipped = 0
    
    for test_name, test_data in TESTS.items():
        output_file = output_dir / f"{test_name}.s"
        
        # 跳过已存在的文件
        if output_file.exists():
            print(f"SKIP: {test_name}.s (already exists)")
            skipped += 1
            continue
        
        print(f"GEN: {test_name}.s ... ", end='', flush=True)
        
        if generate_test_file(test_name, test_data, output_dir):
            print("OK")
            generated += 1
        else:
            print("FAILED")
    
    print()
    print(f"Generated: {generated}")
    print(f"Skipped: {skipped}")

if __name__ == '__main__':
    main()
