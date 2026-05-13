#!/usr/bin/env python3
"""
Generate A64 edge case tests with expected values from QEMU.
Simplified version that handles each test type properly.
"""

import subprocess
import tempfile
import os
import json
from pathlib import Path

OUTPUT_DIR = str(Path(__file__).resolve().parent / "a64_edge_cases")

# Template for running a test with QEMU and capturing all registers
RUNNER_TEMPLATE = '''
.arch armv8.5-a
.text
.global _start
_start:
    // Clear all registers first
    mov x0, xzr; mov x1, xzr; mov x2, xzr; mov x3, xzr
    mov x4, xzr; mov x5, xzr; mov x6, xzr; mov x7, xzr
    mov x8, xzr; mov x9, xzr; mov x10, xzr; mov x11, xzr
    mov x12, xzr; mov x13, xzr; mov x14, xzr; mov x15, xzr
    
    // Set input registers
{SET_REGS}
    
    // Test code
{CODE}
    
    // Save results to stack
    stp x0, x1, [sp, #-16]!
    stp x2, x3, [sp, #-16]!
    stp x4, x5, [sp, #-16]!
    stp x6, x7, [sp, #-16]!
    stp x8, x9, [sp, #-16]!
    stp x10, x11, [sp, #-16]!
    stp x12, x13, [sp, #-16]!
    stp x14, x15, [sp, #-16]!
    
    // Print X0-X15
    mov x0, #1; ldr x1, =out0; mov x2, #4; mov x8, #64; svc #0; ldr x0, [sp, #112]; bl phex
    mov x0, #1; ldr x1, =out1; mov x2, #4; mov x8, #64; svc #0; ldr x0, [sp, #120]; bl phex
    mov x0, #1; ldr x1, =out2; mov x2, #4; mov x8, #64; svc #0; ldr x0, [sp, #96]; bl phex
    mov x0, #1; ldr x1, =out3; mov x2, #4; mov x8, #64; svc #0; ldr x0, [sp, #104]; bl phex
    mov x0, #1; ldr x1, =out4; mov x2, #4; mov x8, #64; svc #0; ldr x0, [sp, #80]; bl phex
    mov x0, #1; ldr x1, =out5; mov x2, #4; mov x8, #64; svc #0; ldr x0, [sp, #88]; bl phex
    mov x0, #1; ldr x1, =out6; mov x2, #4; mov x8, #64; svc #0; ldr x0, [sp, #64]; bl phex
    mov x0, #1; ldr x1, =out7; mov x2, #4; mov x8, #64; svc #0; ldr x0, [sp, #72]; bl phex
    mov x0, #1; ldr x1, =out8; mov x2, #4; mov x8, #64; svc #0; ldr x0, [sp, #48]; bl phex
    mov x0, #1; ldr x1, =out9; mov x2, #4; mov x8, #64; svc #0; ldr x0, [sp, #56]; bl phex
    mov x0, #1; ldr x1, =out10; mov x2, #5; mov x8, #64; svc #0; ldr x0, [sp, #32]; bl phex
    mov x0, #1; ldr x1, =out11; mov x2, #5; mov x8, #64; svc #0; ldr x0, [sp, #40]; bl phex
    mov x0, #1; ldr x1, =out12; mov x2, #5; mov x8, #64; svc #0; ldr x0, [sp, #16]; bl phex
    mov x0, #1; ldr x1, =out13; mov x2, #5; mov x8, #64; svc #0; ldr x0, [sp, #24]; bl phex
    mov x0, #1; ldr x1, =out14; mov x2, #5; mov x8, #64; svc #0; ldr x0, [sp, #0]; bl phex
    mov x0, #1; ldr x1, =out15; mov x2, #5; mov x8, #64; svc #0; ldr x0, [sp, #8]; bl phex
    
    // Exit
    mov x8, #93; mov x0, #0; svc #0

.section .data
out0: .ascii "X0="
out1: .ascii "X1="
out2: .ascii "X2="
out3: .ascii "X3="
out4: .ascii "X4="
out5: .ascii "X5="
out6: .ascii "X6="
out7: .ascii "X7="
out8: .ascii "X8="
out9: .ascii "X9="
out10: .ascii "X10="
out11: .ascii "X11="
out12: .ascii "X12="
out13: .ascii "X13="
out14: .ascii "X14="
out15: .ascii "X15="
buf: .space 19
hex: .ascii "0123456789ABCDEF"

.section .text
phex:
    ldr x10, =buf
    mov x11, x0
    mov x12, #16
    ldr x13, =hex
1:  lsr x14, x11, #60
    and x14, x14, #15
    ldrb w15, [x13, x14]
    strb w15, [x10], #1
    lsl x11, x11, #4
    subs x12, x12, #1
    bne 1b
    mov x8, #64
    mov x0, #1
    ldr x1, =buf
    mov x2, #18
    svc #0
    ret
'''

def run_qemu_test(code, input_regs):
    """Run code with QEMU and return register values."""
    # Generate code to set input registers
    set_regs_lines = []
    for reg, val in input_regs.items():
        reg_upper = reg.upper()
        if reg_upper.startswith('W'):
            xreg = 'X' + reg_upper[1:]
        else:
            xreg = reg_upper
        val_int = int(val, 16)
        if val_int == 0:
            set_regs_lines.append(f"    mov {xreg}, xzr")
        else:
            set_regs_lines.append(f"    ldr {xreg}, ={val}")
    
    set_regs = '\n'.join(set_regs_lines)
    
    asm = RUNNER_TEMPLATE.replace('{SET_REGS}', set_regs).replace('{CODE}', code)
    
    with tempfile.TemporaryDirectory() as d:
        src = os.path.join(d, "t.S")
        obj = os.path.join(d, "t.o")
        exe = os.path.join(d, "t")
        
        with open(src, 'w') as f:
            f.write(asm)
        
        r = subprocess.run(['aarch64-none-elf-as', '-o', obj, src], 
                          capture_output=True, text=True)
        if r.returncode != 0:
            return None, f"ASM Error: {r.stderr}"
        
        r = subprocess.run(['aarch64-none-elf-ld', '-o', exe, obj],
                          capture_output=True, text=True)
        if r.returncode != 0:
            return None, f"LD Error: {r.stderr}"
        
        try:
            r = subprocess.run(['qemu-aarch64', '-cpu', 'max', exe], 
                              capture_output=True, text=True, timeout=5)
            output = r.stdout
        except subprocess.TimeoutExpired:
            return None, "QEMU timeout"
        
        # Parse output
        actual = {}
        for line in output.strip().split('\n'):
            if '=' in line:
                key, val = line.split('=', 1)
                actual[key.strip()] = val.strip()
        
        return actual, None

def normalize_hex(val):
    """Normalize hex value."""
    val = str(val).lower().strip()
    if val.startswith('0x'):
        val = val[2:]
    val = val.lstrip('0') or '0'
    return '0x' + val

def write_test_with_expected(name, input_regs, code, actual):
    """Write test file with expected values."""
    # Start with input registers
    reg_data = dict(input_regs)
    
    # Add output registers (X4-X15, or modified X0-X3)
    output_regs = {}
    for i in range(16):
        xreg = f'X{i}'
        wreg = f'W{i}'
        if xreg in actual:
            val = actual[xreg]
            # Check if this is an output (different from input or not in input)
            if wreg not in input_regs and xreg not in input_regs:
                # Use W register for 32-bit operations
                val_int = int(val, 16)
                if val_int <= 0xFFFFFFFF:
                    output_regs[wreg] = f"0x{val_int:08X}"
                else:
                    output_regs[xreg] = val
            else:
                # Check if modified
                orig = input_regs.get(wreg, input_regs.get(xreg, None))
                if orig:
                    orig_norm = normalize_hex(orig)
                    actual_norm = normalize_hex(val)
                    if orig_norm != actual_norm:
                        val_int = int(val, 16)
                        if val_int <= 0xFFFFFFFF:
                            output_regs[wreg] = f"0x{val_int:08X}"
                        else:
                            output_regs[xreg] = val
    
    reg_data.update(output_regs)
    
    config = {"Match": "All", "RegData": reg_data}
    
    filepath = os.path.join(OUTPUT_DIR, name)
    with open(filepath, 'w') as f:
        f.write(f'/* CONFIG\n{json.dumps(config, indent=2)}\n*/\n')
        f.write('.text\n')
        f.write('.global _start\n')
        f.write('_start:\n')
        f.write(code)
        f.write('    brk #0\n')
    
    return name

def gen_tests():
    """Generate all tests."""
    os.makedirs(OUTPUT_DIR, exist_ok=True)
    
    tests = []
    
    # Shift overflow tests
    tests.append((
        "shift_overflow_32.s",
        {"W0": "0x12345678", "W1": "0x00000020", "W2": "0x00000021", "W3": "0x000000FF"},
        '''
    lsl w4, w0, w1    // w0 << 32 = 0
    lsl w5, w0, w2    // w0 << 33 = 0
    lsl w6, w0, w3    // w0 << 255 = 0
    lsr w7, w0, w1    // w0 >> 32 = 0
    lsr w8, w0, w2    // w0 >> 33 = 0
    mov w9, #0x80000000
    asr w10, w9, w1   // negative >> 32 = -1
    asr w11, w9, w2   // negative >> 33 = -1
    mov w12, #0x7FFFFFFF
    asr w13, w12, w1  // positive >> 32 = 0
    asr w14, w12, w2  // positive >> 33 = 0
'''
    ))
    
    # Shift edge 0 and 31
    tests.append((
        "shift_edge_0_31.s",
        {"W0": "0x12345678", "W1": "0x00000000", "W2": "0x0000001F"},
        '''
    lsl w3, w0, w1    // w0 << 0 = w0
    lsr w4, w0, w1    // w0 >> 0 = w0
    asr w5, w0, w1    // w0 >>> 0 = w0
    lsl w6, w0, w2    // w0 << 31
    lsr w7, w0, w2    // w0 >> 31
    asr w8, w0, w2    // w0 >>> 31
    mov w9, #0x80000000
    asr w10, w9, w2   // 0x80000000 >>> 31 = 0xFFFFFFFF
'''
    ))
    
    # ADDS NZCV tests
    tests.append((
        "adds_nzcv_zero.s",
        {"W0": "0x00000000", "W1": "0x00000000"},
        '''
    adds w2, w0, w1    // 0 + 0 = 0, Z=1
    mrs x3, nzcv
'''
    ))
    
    tests.append((
        "adds_nzcv_overflow.s",
        {"W0": "0x7FFFFFFF", "W1": "0x00000001"},
        '''
    adds w2, w0, w1    // max + 1 = overflow, N=1, V=1
    mrs x3, nzcv
'''
    ))
    
    tests.append((
        "adds_nzcv_neg_neg.s",
        {"W0": "0x80000000", "W1": "0x80000000"},
        '''
    adds w2, w0, w1    // 0x80000000 + 0x80000000 = 0, C=1, V=1
    mrs x3, nzcv
'''
    ))
    
    tests.append((
        "adds_nzcv_wrap.s",
        {"W0": "0xFFFFFFFF", "W1": "0x00000001"},
        '''
    adds w2, w0, w1    // wrap to 0, C=1, Z=1
    mrs x3, nzcv
'''
    ))
    
    # SUBS NZCV tests
    tests.append((
        "subs_nzcv_zero.s",
        {"W0": "0x00000001", "W1": "0x00000001"},
        '''
    subs w2, w0, w1    // 1 - 1 = 0, Z=1, C=1
    mrs x3, nzcv
'''
    ))
    
    tests.append((
        "subs_nzcv_borrow.s",
        {"W0": "0x00000000", "W1": "0x00000001"},
        '''
    subs w2, w0, w1    // 0 - 1 = -1, C=0, N=1
    mrs x3, nzcv
'''
    ))
    
    tests.append((
        "subs_nzcv_overflow.s",
        {"W0": "0x7FFFFFFF", "W1": "0x80000000"},
        '''
    subs w2, w0, w1    // pos - neg = overflow, V=1
    mrs x3, nzcv
'''
    ))
    
    # Register overlap tests
    tests.append((
        "reg_overlap_adds.s",
        {"W0": "0x12345678"},
        '''
    adds w0, w0, w0    // w0 = w0 + w0
    mrs w1, nzcv
'''
    ))
    
    tests.append((
        "reg_overlap_subs.s",
        {"W0": "0x12345678"},
        '''
    subs w0, w0, w0    // w0 = w0 - w0 = 0
    mrs w1, nzcv
'''
    ))
    
    tests.append((
        "reg_overlap_lsl.s",
        {"W0": "0x00000004"},
        '''
    lsl w0, w0, w0     // w0 = 4 << 4 = 64
'''
    ))
    
    tests.append((
        "reg_overlap_mul.s",
        {"W0": "0x00000010"},
        '''
    mul w0, w0, w0     // w0 = 16 * 16 = 256
'''
    ))
    
    # CSEL tests
    tests.append((
        "csel_eq.s",
        {"W0": "0x00000001", "W1": "0x00000002", "W2": "0x00000003", "W3": "0x00000004"},
        '''
    cmp w0, w0         // equal, Z=1
    csel w4, w2, w3, eq  // if equal, w4 = w2
'''
    ))
    
    tests.append((
        "csel_ne.s",
        {"W0": "0x00000001", "W1": "0x00000002", "W2": "0x00000003", "W3": "0x00000004"},
        '''
    cmp w0, w1         // not equal, Z=0
    csel w4, w2, w3, ne  // if not equal, w4 = w2
'''
    ))
    
    tests.append((
        "csel_mi.s",
        {"W0": "0x00000001", "W1": "0x00000002", "W2": "0x00000003", "W3": "0x00000004"},
        '''
    subs w4, w0, w1    // 1 - 2 = -1, N=1
    csel w5, w2, w3, mi  // if minus, w5 = w2
'''
    ))
    
    # Division tests
    tests.append((
        "udiv_by_zero.s",
        {"W0": "0x12345678", "W1": "0x00000000"},
        '''
    udiv w2, w0, w1    // division by zero = 0
'''
    ))
    
    tests.append((
        "sdiv_by_zero.s",
        {"W0": "0x80000000", "W1": "0x00000000"},
        '''
    sdiv w2, w0, w1    // division by zero = 0
'''
    ))
    
    tests.append((
        "sdiv_intmin_neg1.s",
        {"W0": "0x80000000", "W1": "0xFFFFFFFF"},
        '''
    sdiv w2, w0, w1    // INT_MIN / -1 = INT_MIN
'''
    ))
    
    # Multiply overflow
    tests.append((
        "mul_overflow_32.s",
        {"W0": "0x00010000", "W1": "0x00010000"},
        '''
    mul w2, w0, w1     // 0x10000 * 0x10000 = 0x100000000, truncated to 0
'''
    ))
    
    tests.append((
        "umull_max.s",
        {"W0": "0xFFFFFFFF", "W1": "0xFFFFFFFF"},
        '''
    umull x2, w0, w1   // 0xFFFFFFFF * 0xFFFFFFFF
'''
    ))
    
    # ROR edge cases
    tests.append((
        "ror_edge.s",
        {"W0": "0x12345678", "W1": "0x00000000", "W2": "0x00000010", "W3": "0x0000001F"},
        '''
    ror w4, w0, w1     // rotate by 0
    ror w5, w0, w2     // rotate by 16
    ror w6, w0, w3     // rotate by 31
'''
    ))
    
    print(f"Generating {len(tests)} tests...")
    
    success = 0
    failed = 0
    
    for name, input_regs, code in tests:
        print(f"  {name}...", end=' ', flush=True)
        actual, error = run_qemu_test(code, input_regs)
        if error:
            print(f"FAIL: {error}")
            failed += 1
        else:
            write_test_with_expected(name, input_regs, code, actual)
            print("OK")
            success += 1
    
    print(f"\nDone: {success} succeeded, {failed} failed")

if __name__ == "__main__":
    gen_tests()
