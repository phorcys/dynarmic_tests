#!/usr/bin/env python3
"""生成边界条件测试并运行 QEMU 获取预期值"""
import subprocess
import tempfile
import os
from pathlib import Path
import json

OUT_DIR = str(Path(__file__).resolve().parent / "a64_edge_cases")

def run_qemu_test(code):
    """运行 QEMU 并返回寄存器值"""
    template = f'''
.arch armv8.5-a
.text
.global _start
_start:
    // Clear registers
    mov x0, xzr; mov x1, xzr; mov x2, xzr; mov x3, xzr
    mov x4, xzr; mov x5, xzr; mov x6, xzr; mov x7, xzr
    
{code}
    
    // Exit
    mov x8, #93
    mov x0, #0
    svc #0
'''
    
    with tempfile.TemporaryDirectory() as d:
        src = os.path.join(d, "t.S")
        obj = os.path.join(d, "t.o")
        exe = os.path.join(d, "t")
        
        with open(src, 'w') as f:
            f.write(template)
        
        r = subprocess.run(['aarch64-none-elf-as', '-o', obj, src], capture_output=True, text=True)
        if r.returncode != 0:
            return None, f"ASM Error: {r.stderr}"
        
        r = subprocess.run(['aarch64-none-elf-ld', '-o', exe, obj], capture_output=True, text=True)
        if r.returncode != 0:
            return None, f"LD Error: {r.stderr}"
        
        # Use strace to capture output
        r = subprocess.run(['strace', '-e', 'write', 'qemu-aarch64', exe], 
                          capture_output=True, text=True, timeout=10)
        
        # Parse strace output for register values
        # We'll need to extract values differently - use a simpler approach
        # For now, just return success
        return {}, None

def gen_shift_tests():
    """生成位移边界条件测试"""
    tests = []
    
    # Test 1: LSL with shift >= 32
    tests.append({
        'name': 'shift_overflow_32',
        'regs': {'W0': '0x12345678', 'W1': '0x00000020', 'W2': '0x00000021'},
        'code': '''
    // Input: W0 = 0x12345678, W1 = 32, W2 = 33
    mov w0, #0x5678
    movk w0, #0x1234, lsl #16
    mov w1, #32
    mov w2, #33
    
    // LSL with shift >= 32 should return 0
    lsl w3, w0, w1    // w3 = 0 (shift 32)
    lsl w4, w0, w2    // w4 = 0 (shift 33)
    
    // LSR with shift >= 32 should return 0
    lsr w5, w0, w1    // w5 = 0 (shift 32)
    lsr w6, w0, w2    // w6 = 0 (shift 33)
    
    // ASR with shift >= 32: positive value -> 0
    asr w7, w0, w1    // w7 = 0 (shift 32, positive)
'''
    })
    
    # Test 2: ASR negative with shift >= 32
    tests.append({
        'name': 'shift_asr_negative',
        'regs': {'W0': '0xFFFFFFFF'},
        'code': '''
    // Input: W0 = 0xFFFFFFFF (negative)
    mov w0, #0xFFFF
    movk w0, #0xFFFF, lsl #16
    mov w1, #32
    mov w2, #33
    
    // ASR with shift >= 32: negative value -> all 1s
    asr w3, w0, w1    // w3 = 0xFFFFFFFF (sign fill)
    asr w4, w0, w2    // w4 = 0xFFFFFFFF (sign fill)
'''
    })
    
    # Test 3: Shift edge cases 0, 31
    tests.append({
        'name': 'shift_edge_0_31',
        'regs': {'W0': '0x12345678'},
        'code': '''
    mov w0, #0x5678
    movk w0, #0x1234, lsl #16
    mov w1, #0
    mov w2, #31
    
    // LSL with shift 0 and 31
    lsl w3, w0, w1    // w3 = w0 (shift 0)
    lsl w4, w0, w2    // w4 = w0 << 31
    
    // LSR with shift 0 and 31
    lsr w5, w0, w1    // w5 = w0 (shift 0)
    lsr w6, w0, w2    // w6 = w0 >> 31
'''
    })
    
    return tests

def gen_adds_tests():
    """生成 ADDS NZCV 测试"""
    tests = []
    
    # Test various overflow conditions
    cases = [
        # (a, b, expected_nzcv_name)
        ('0x7FFFFFFF', '1', 'overflow_positive'),
        ('0x80000000', '0x80000000', 'overflow_negative'),
        ('0xFFFFFFFF', '1', 'carry_no_overflow'),
        ('0', '0', 'zero'),
    ]
    
    for i, (a, b, name) in enumerate(cases):
        tests.append({
            'name': f'adds_nzcv_{i:02d}',
            'regs': {},
            'code': f'''
    // ADDS {a} + {b}
    mov w0, #{a}
    mov w1, #{b}
    adds w2, w0, w1
    mrs x3, nzcv
'''
        })
    
    return tests

def write_test(test, expected_regs):
    """写入测试文件"""
    config = {'Match': 'All', 'RegData': expected_regs}
    
    content = f'''/* CONFIG
{json.dumps(config, indent=2)}
*/
// Test: {test['name']}

.text
.global _start
_start:
{test['code']}

    brk #0
'''
    
    path = os.path.join(OUT_DIR, f"{test['name']}.s")
    with open(path, 'w') as f:
        f.write(content)
    print(f"Generated: {test['name']}.s")

def main():
    os.makedirs(OUT_DIR, exist_ok=True)
    
    # Generate tests without expected values (we'll need to manually add them or use QEMU)
    tests = []
    tests.extend(gen_shift_tests())
    tests.extend(gen_adds_tests())
    
    for test in tests:
        # For now, just generate without expected values
        # We need to manually verify or use a different approach
        write_test(test, {})
    
    print(f"\nGenerated {len(tests)} tests in {OUT_DIR}")
    print("Note: Expected values need to be filled in manually or with QEMU verification")

if __name__ == '__main__':
    main()
