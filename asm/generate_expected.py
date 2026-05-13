#!/usr/bin/env python3
"""
Generate expected values for A64 edge case tests using QEMU.
This script runs tests with QEMU and updates the CONFIG with actual results.
"""

import subprocess
import sys
import tempfile
import os
import json
import re
from pathlib import Path

RUNNER_TEMPLATE = r'''
.arch armv8.5-a+crc+lse+crypto+sha3+sm4
.data
hex: .ascii "0123456789ABCDEF"
buf: .ascii "0x00000000000000000000000000000000\n"

.text
.global _start
_start:
    mov x0, #0; mov x1, #0; mov x2, #0; mov x3, #0
    mov x4, #0; mov x5, #0; mov x6, #0; mov x7, #0
    fmov d0, xzr; fmov d1, xzr; fmov d2, xzr; fmov d3, xzr
    fmov d4, xzr; fmov d5, xzr; fmov d6, xzr; fmov d7, xzr

{CODE}

    // Print X0-X15
    mov x8, #64; mov x0, #1; ldr x1, =lb0; mov x2, #4; svc #0
    mov x0, x0; bl phex
    mov x8, #64; mov x0, #1; ldr x1, =lb1; mov x2, #4; svc #0
    mov x0, x1; bl phex
    mov x8, #64; mov x0, #1; ldr x1, =lb2; mov x2, #4; svc #0
    mov x0, x2; bl phex
    mov x8, #64; mov x0, #1; ldr x1, =lb3; mov x2, #4; svc #0
    mov x0, x3; bl phex
    mov x8, #64; mov x0, #1; ldr x1, =lb4; mov x2, #4; svc #0
    mov x0, x4; bl phex
    mov x8, #64; mov x0, #1; ldr x1, =lb5; mov x2, #4; svc #0
    mov x0, x5; bl phex
    mov x8, #64; mov x0, #1; ldr x1, =lb6; mov x2, #4; svc #0
    mov x0, x6; bl phex
    mov x8, #64; mov x0, #1; ldr x1, =lb7; mov x2, #4; svc #0
    mov x0, x7; bl phex
    mov x8, #64; mov x0, #1; ldr x1, =lb8; mov x2, #4; svc #0
    mov x0, x8; bl phex
    mov x8, #64; mov x0, #1; ldr x1, =lb9; mov x2, #4; svc #0
    mov x0, x9; bl phex
    mov x8, #64; mov x0, #1; ldr x1, =lb10; mov x2, #5; svc #0
    mov x0, x10; bl phex
    mov x8, #64; mov x0, #1; ldr x1, =lb11; mov x2, #5; svc #0
    mov x0, x11; bl phex
    mov x8, #64; mov x0, #1; ldr x1, =lb12; mov x2, #5; svc #0
    mov x0, x12; bl phex
    mov x8, #64; mov x0, #1; ldr x1, =lb13; mov x2, #5; svc #0
    mov x0, x13; bl phex
    mov x8, #64; mov x0, #1; ldr x1, =lb14; mov x2, #5; svc #0
    mov x0, x14; bl phex
    mov x8, #64; mov x0, #1; ldr x1, =lb15; mov x2, #5; svc #0
    mov x0, x15; bl phex
    
    // Exit
    mov x8, #93
    mov x0, #0
    svc #0

lb0: .ascii "X0="
lb1: .ascii "X1="
lb2: .ascii "X2="
lb3: .ascii "X3="
lb4: .ascii "X4="
lb5: .ascii "X5="
lb6: .ascii "X6="
lb7: .ascii "X7="
lb8: .ascii "X8="
lb9: .ascii "X9="
lb10: .ascii "X10="
lb11: .ascii "X11="
lb12: .ascii "X12="
lb13: .ascii "X13="
lb14: .ascii "X14="
lb15: .ascii "X15="

phex:
    ldr x10, =buf
    mov x11, x0
    mov x12, #16
    ldr x13, =hex
phex_loop:
    lsr x14, x11, #60
    and x14, x14, #15
    ldrb w15, [x13, x14]
    strb w15, [x10], #1
    lsl x11, x11, #4
    subs x12, x12, #1
    bne phex_loop
    mov x8, #64
    mov x0, #1
    ldr x1, =buf
    mov x2, #18
    svc #0
    ret
'''

def parse_config(content):
    """Extract JSON config from test file"""
    start = content.find('/*')
    if start == -1:
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

def extract_code(content):
    """Extract code from .text section"""
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
        if s.startswith('brk') or s.startswith('ret'):
            continue
        if s.startswith('.data') or s.startswith('.section'):
            break
        if in_text and s:
            code.append('    ' + line)
    return '\n'.join(code)

def run_qemu(asm_file):
    """Run QEMU and return actual register values"""
    with open(asm_file) as f:
        content = f.read()
    
    code = extract_code(content)
    
    with tempfile.TemporaryDirectory() as d:
        src = os.path.join(d, "t.S")
        obj = os.path.join(d, "t.o")
        exe = os.path.join(d, "t")
        
        with open(src, 'w') as f:
            f.write(RUNNER_TEMPLATE.replace('{CODE}', code))
        
        r = subprocess.run(['aarch64-none-elf-as', '-march=armv8.4-a', '-o', obj, src], 
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

def update_test_file(asm_file, actual, config):
    """Update test file with expected values from QEMU"""
    with open(asm_file) as f:
        content = f.read()
    
    # Find which registers we need to check
    # Start with input registers
    input_regs = set(config.get('RegData', {}).keys())
    
    # Determine output registers (W4-W15 or X4-X15, or whatever the test modifies)
    output_regs = {}
    for reg in ['W4', 'W5', 'W6', 'W7', 'W8', 'W9', 'W10', 'W11', 'W12', 'W13', 'W14', 'W15',
                'X4', 'X5', 'X6', 'X7', 'X8', 'X9', 'X10', 'X11', 'X12', 'X13', 'X14', 'X15']:
        if reg not in input_regs:
            xreg = reg.replace('W', 'X')
            if xreg in actual:
                val = actual[xreg]
                # For W registers, take only low 32 bits
                if reg.startswith('W'):
                    val_int = int(val, 16) & 0xFFFFFFFF
                    val = f"0x{val_int:08X}"
                output_regs[reg] = val
    
    # Also check X0-X3 for modifications
    for reg in ['W0', 'W1', 'W2', 'W3', 'X0', 'X1', 'X2', 'X3']:
        xreg = reg.replace('W', 'X')
        if xreg in actual:
            val = actual[xreg]
            if reg.startswith('W'):
                val_int = int(val, 16) & 0xFFFFFFFF
                val = f"0x{val_int:08X}"
            # Only add if different from input
            if reg in input_regs:
                input_val = config['RegData'][reg]
                if val.lower() != input_val.lower():
                    output_regs[reg] = val
    
    # Update config with output registers
    if output_regs:
        config['RegData'] = config.get('RegData', {})
        config['RegData'].update(output_regs)
    
    # Rewrite the file
    # Find and replace the CONFIG block
    start = content.find('/*')
    end = content.find('*/', start + 2) + 2
    
    new_config = '/* CONFIG\n' + json.dumps(config, indent=2) + '\n*/'
    new_content = new_config + content[end:]
    
    with open(asm_file, 'w') as f:
        f.write(new_content)
    
    return output_regs

def main():
    if len(sys.argv) < 2:
        print("Usage: python3 generate_expected.py <test.s|directory>", file=sys.stderr)
        sys.exit(1)
    
    input_path = Path(sys.argv[1])
    test_files = []
    
    if input_path.is_file():
        test_files = [input_path]
    elif input_path.is_dir():
        test_files = sorted(input_path.rglob('*.s'))
    else:
        print(f"Error: {input_path} is not valid", file=sys.stderr)
        sys.exit(1)
    
    print(f"Processing {len(test_files)} test files...")
    
    success_count = 0
    fail_count = 0
    
    for test_file in test_files:
        print(f"  {test_file.name}...", end=' ', flush=True)
        
        with open(test_file) as f:
            content = f.read()
        
        config = parse_config(content)
        if config is None:
            print("SKIP (no config)")
            continue
        
        actual, error = run_qemu(str(test_file))
        if error:
            print(f"FAIL: {error}")
            fail_count += 1
            continue
        
        output_regs = update_test_file(str(test_file), actual, config)
        print(f"OK ({len(output_regs)} outputs)")
        success_count += 1
    
    print(f"\nDone: {success_count} succeeded, {fail_count} failed")

if __name__ == "__main__":
    main()
