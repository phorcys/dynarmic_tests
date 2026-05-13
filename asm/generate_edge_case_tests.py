#!/usr/bin/env python3
"""
Generate comprehensive A64 edge case tests for dynarmic LoongArch64 backend.
Tests cover:
- Shift overflow conditions
- NZCV flags combinations
- Register overlap scenarios
- Integer overflow/underflow
- Special arithmetic cases
"""

import os
from pathlib import Path
import json

OUTPUT_DIR = str(Path(__file__).resolve().parent / "a64_edge_cases")

def write_test(filename, config, code):
    """Write a test file with JSON config and assembly code."""
    filepath = os.path.join(OUTPUT_DIR, filename)
    with open(filepath, 'w') as f:
        f.write(f'/* CONFIG\n{json.dumps(config, indent=2)}\n*/\n')
        f.write('.text\n')
        f.write('.global _start\n')
        f.write('_start:\n')
        f.write(code)
        f.write('    brk #0\n')
    print(f"Generated: {filename}")

def gen_shift_overflow():
    """Generate shift overflow tests - critical for LoongArch64 backend."""
    
    # LSL register form with shift >= 32
    config = {
        "Match": "All",
        "RegData": {
            "W0": "0x12345678",
            "W1": "0x00000020",  # shift = 32
            "W2": "0x00000021",  # shift = 33
            "W3": "0x000000FF",  # shift = 255 (max 8-bit)
        }
    }
    code = '''
    // LSL with shift >= 32 should produce 0
    lsl w4, w0, w1    // w0 << 32 = 0
    lsl w5, w0, w2    // w0 << 33 = 0
    lsl w6, w0, w3    // w0 << 255 = 0 (255 & 0xFF = 255, >= 32)
    
    // LSR with shift >= 32 should produce 0
    lsr w7, w0, w1    // w0 >> 32 = 0
    lsr w8, w0, w2    // w0 >> 33 = 0
    
    // ASR with shift >= 32 should fill with sign bit
    mov w9, #0x80000000   // negative number
    asr w10, w9, w1   // 0x80000000 >> 32 = 0xFFFFFFFF (sign fill)
    asr w11, w9, w2   // 0x80000000 >> 33 = 0xFFFFFFFF (sign fill)
    
    mov w12, #0x7FFFFFFF   // positive number
    asr w13, w12, w1  // 0x7FFFFFFF >> 32 = 0 (sign fill)
    asr w14, w12, w2  // 0x7FFFFFFF >> 33 = 0 (sign fill)
'''
    write_test("shift_overflow_32.s", config, code)
    
    # LSL/LSR/ASR 64-bit with shift >= 64
    config = {
        "Match": "All",
        "RegData": {
            "X0": "0x123456789ABCDEF0",
            "X1": "0x0000000000000040",  # shift = 64
            "X2": "0x0000000000000041",  # shift = 65
        }
    }
    code = '''
    // LSL 64-bit with shift >= 64 should produce 0
    lsl x3, x0, x1    // x0 << 64 = 0
    lsl x4, x0, x2    // x0 << 65 = 0
    
    // LSR 64-bit with shift >= 64 should produce 0
    lsr x5, x0, x1    // x0 >> 64 = 0
    lsr x6, x0, x2    // x0 >> 65 = 0
    
    // ASR 64-bit with shift >= 64 should fill with sign bit
    mov x7, #0x8000000000000000
    asr x8, x7, x1   // negative >> 64 = 0xFFFFFFFFFFFFFFFF
    asr x9, x7, x2   // negative >> 65 = 0xFFFFFFFFFFFFFFFF
    
    mov x10, #0x7FFFFFFFFFFFFFFF
    asr x11, x10, x1  // positive >> 64 = 0
    asr x12, x10, x2  // positive >> 65 = 0
'''
    write_test("shift_overflow_64.s", config, code)

def gen_shift_edge_cases():
    """Generate shift edge case tests."""
    
    # Shift by 0 and 31
    config = {
        "Match": "All",
        "RegData": {
            "W0": "0x12345678",
            "W1": "0x00000000",  # shift = 0
            "W2": "0x0000001F",  # shift = 31
        }
    }
    code = '''
    // Shift by 0 should be identity
    lsl w3, w0, w1    // w0 << 0 = w0
    lsr w4, w0, w1    // w0 >> 0 = w0
    asr w5, w0, w1    // w0 >>> 0 = w0
    
    // Shift by 31 (max valid for 32-bit)
    lsl w6, w0, w2    // w0 << 31
    lsr w7, w0, w2    // w0 >> 31
    asr w8, w0, w2    // w0 >>> 31
    
    // Negative number ASR by 31
    mov w9, #0x80000000
    asr w10, w9, w2   // 0x80000000 >>> 31 = 0xFFFFFFFF
'''
    write_test("shift_edge_0_31.s", config, code)
    
    # ROR edge cases
    config = {
        "Match": "All",
        "RegData": {
            "W0": "0x12345678",
            "W1": "0x00000000",  # rotate = 0
            "W2": "0x00000010",  # rotate = 16
            "W3": "0x0000001F",  # rotate = 31
        }
    }
    code = '''
    ror w4, w0, w1    // rotate by 0 = identity
    ror w5, w0, w2    // rotate by 16
    ror w6, w0, w3    // rotate by 31
'''
    write_test("ror_edge.s", config, code)

def gen_adds_nzcv():
    """Generate ADDS NZCV flags tests."""
    
    # ADDS producing different NZCV combinations
    tests = [
        # (a, b, expected_nzcv description)
        (0, 0, "Z=1, C=0, V=0"),
        (1, 0, "N=0, Z=0"),
        (0x7FFFFFFF, 1, "positive overflow -> N=1, V=1"),
        (0x80000000, 0x80000000, "negative + negative = 0, C=1, V=1"),
        (0xFFFFFFFF, 1, "wrap to 0, C=1, Z=1"),
        (0x40000000, 0x40000000, "no overflow, C=0"),
        (0x80000000, 0, "N=1 (negative result)"),
    ]
    
    for i, (a, b, desc) in enumerate(tests):
        config = {
            "Match": "All",
            "RegData": {
                "W0": f"0x{a:08X}",
                "W1": f"0x{b:08X}",
            }
        }
        code = f'''
    adds w2, w0, w1
    mrs x3, nzcv
    // {desc}
'''
        write_test(f"adds_nzcv_{i:02d}.s", config, code)

def gen_adcs_flags():
    """Generate ADCS with carry chain tests."""
    
    # ADCS with carry in
    config = {
        "Match": "All",
        "RegData": {
            "W0": "0xFFFFFFFF",
            "W1": "0x00000000",
        }
    }
    code = '''
    // First ADDS sets carry
    adds w2, w0, w1    // 0xFFFFFFFF + 0 = 0xFFFFFFFF, C=0
    // Actually we need carry=1, let's use CMN
    cmn w0, w0         // 0xFFFFFFFF + 0xFFFFFFFF, sets C=1
    adc w3, w0, w1     // 0xFFFFFFFF + 0 + 1 = 0 (with carry out)
    mrs x4, nzcv
'''
    write_test("adcs_carry_chain.s", config, code)
    
    # ADCS overflow cases
    config = {
        "Match": "All",
        "RegData": {
            "W0": "0x7FFFFFFF",  # max positive
            "W1": "0x00000000",
        }
    }
    code = '''
    // Set carry flag
    cmp wzr, wzr       // sets Z=1, C=1
    adcs w2, w0, w1    // 0x7FFFFFFF + 0 + 1 = 0x80000000, V=1
    mrs x3, nzcv
'''
    write_test("adcs_overflow.s", config, code)

def gen_subs_nzcv():
    """Generate SUBS NZCV flags tests."""
    
    tests = [
        (0, 0, "Z=1"),
        (1, 1, "Z=1"),
        (0, 1, "borrow, C=0, N=1"),
        (1, 0, "no borrow, C=1"),
        (0x80000000, 1, "negative - positive = more negative, V=0"),
        (0x7FFFFFFF, 0x80000000, "positive - negative overflow, V=1"),
        (0, 0x80000000, "0 - negative = overflow, V=1"),
    ]
    
    for i, (a, b, desc) in enumerate(tests):
        config = {
            "Match": "All",
            "RegData": {
                "W0": f"0x{a:08X}",
                "W1": f"0x{b:08X}",
            }
        }
        code = f'''
    subs w2, w0, w1
    mrs x3, nzcv
    // {desc}
'''
        write_test(f"subs_nzcv_{i:02d}.s", config, code)

def gen_sbcs_flags():
    """Generate SBCS with borrow chain tests."""
    
    config = {
        "Match": "All",
        "RegData": {
            "W0": "0x00000000",
            "W1": "0x00000001",
        }
    }
    code = '''
    // First SUBS clears carry (borrow occurred)
    subs w2, w0, w1    // 0 - 1 = 0xFFFFFFFF, C=0
    sbcs w3, w0, w1    // 0 - 1 - 1 = 0xFFFFFFFE, C=0
    mrs x4, nzcv
'''
    write_test("sbcs_borrow_chain.s", config, code)

def gen_register_overlap():
    """Generate tests with register overlap (same register for src and dst)."""
    
    # ADDS with same register
    config = {
        "Match": "All",
        "RegData": {
            "W0": "0x12345678",
        }
    }
    code = '''
    adds w0, w0, w0    // w0 = w0 + w0
    mrs x1, nzcv
'''
    write_test("reg_overlap_adds.s", config, code)
    
    # SUBS with same register (result = 0)
    config = {
        "Match": "All",
        "RegData": {
            "W0": "0x12345678",
        }
    }
    code = '''
    subs w0, w0, w0    // w0 = w0 - w0 = 0
    mrs x1, nzcv       // Z=1, C=1
'''
    write_test("reg_overlap_subs.s", config, code)
    
    # LSL with overlapping shift register
    config = {
        "Match": "All",
        "RegData": {
            "W0": "0x00000004",  # both value and shift amount
        }
    }
    code = '''
    lsl w0, w0, w0     // w0 = 4 << 4 = 64
'''
    write_test("reg_overlap_lsl.s", config, code)
    
    # MUL with overlap
    config = {
        "Match": "All",
        "RegData": {
            "W0": "0x00000010",
        }
    }
    code = '''
    mul w0, w0, w0     // w0 = 16 * 16 = 256
'''
    write_test("reg_overlap_mul.s", config, code)
    
    # AND/ORR/EOR with overlap
    config = {
        "Match": "All",
        "RegData": {
            "W0": "0xFF00FF00",
        }
    }
    code = '''
    and w1, w0, w0     // w1 = w0 & w0 = w0
    orr w2, w0, w0     // w2 = w0 | w0 = w0
    eor w3, w0, w0     // w3 = w0 ^ w0 = 0
'''
    write_test("reg_overlap_logic.s", config, code)

def gen_mul_overflow():
    """Generate multiply overflow tests."""
    
    # 32-bit multiplication overflow (high bits discarded)
    config = {
        "Match": "All",
        "RegData": {
            "W0": "0x00010000",
            "W1": "0x00010000",
        }
    }
    code = '''
    mul w2, w0, w1     // 0x10000 * 0x10000 = 0x100000000, truncated to 0
'''
    write_test("mul_overflow_32.s", config, code)
    
    # SMULL for signed multiply long
    config = {
        "Match": "All",
        "RegData": {
            "W0": "0x7FFFFFFF",  # max positive
            "W1": "0x7FFFFFFF",
        }
    }
    code = '''
    smull x2, w0, w1   // signed multiply long
'''
    write_test("smull_max.s", config, code)
    
    # UMULL for unsigned multiply long
    config = {
        "Match": "All",
        "RegData": {
            "W0": "0xFFFFFFFF",
            "W1": "0xFFFFFFFF",
        }
    }
    code = '''
    umull x2, w0, w1   // unsigned multiply long
'''
    write_test("umull_max.s", config, code)

def gen_div_edge():
    """Generate division edge case tests."""
    
    # SDIV edge cases
    config = {
        "Match": "All",
        "RegData": {
            "W0": "0x80000000",  # INT_MIN
            "W1": "0xFFFFFFFF",  # -1
        }
    }
    code = '''
    sdiv w2, w0, w1    // INT_MIN / -1 = INT_MIN (special case, no overflow)
    mrs x3, nzcv
'''
    write_test("sdiv_intmin_neg1.s", config, code)
    
    # UDIV by zero
    config = {
        "Match": "All",
        "RegData": {
            "W0": "0x12345678",
            "W1": "0x00000000",
        }
    }
    code = '''
    udiv w2, w0, w1    // division by zero = 0
'''
    write_test("udiv_by_zero.s", config, code)
    
    # SDIV by zero
    config = {
        "Match": "All",
        "RegData": {
            "W0": "0x80000000",  # negative
            "W1": "0x00000000",
        }
    }
    code = '''
    sdiv w2, w0, w1    // division by zero = 0
'''
    write_test("sdiv_by_zero.s", config, code)

def gen_cond_select():
    """Generate conditional select tests for all conditions."""
    
    conditions = [
        ("eq", 0, "Z==1"),
        ("ne", 1, "Z==0"),
        ("cs", 2, "C==1"),
        ("cc", 3, "C==0"),
        ("mi", 4, "N==1"),
        ("pl", 5, "N==0"),
        ("vs", 6, "V==1"),
        ("vc", 7, "V==0"),
        ("hi", 8, "C==1 && Z==0"),
        ("ls", 9, "C==0 || Z==1"),
        ("ge", 10, "N==V"),
        ("lt", 11, "N!=V"),
        ("gt", 12, "Z==0 && N==V"),
        ("le", 13, "Z==1 || N!=V"),
        ("al", 14, "always"),
    ]
    
    for cond, code_val, desc in conditions:
        config = {
            "Match": "All",
            "RegData": {
                "W0": "0x00000001",
                "W1": "0x00000002",
                "W2": "0x00000003",
                "W3": "0x00000004",
            }
        }
        code = f'''
    // Set flags: 1 - 2 = -1, N=1, Z=0, C=0, V=0
    cmp w0, w1
    csel w4, w2, w3, {cond}  // {desc}
'''
        write_test(f"csel_{cond}.s", config, code)

def gen_ccmp():
    """Generate conditional compare tests."""
    
    # CCMP with different conditions
    config = {
        "Match": "All",
        "RegData": {
            "W0": "0x00000005",
            "W1": "0x0000000A",
            "W2": "0x00000003",
        }
    }
    code = '''
    cmp w0, w1         // 5 vs 10, N=0, Z=0, C=0, V=0
    ccmp w0, w2, #0, lt  // if LT (false), set nzcv to 0
    mrs x3, nzcv       // should be from first cmp
'''
    write_test("ccmp_false.s", config, code)
    
    config = {
        "Match": "All",
        "RegData": {
            "W0": "0x00000005",
            "W1": "0x0000000A",
            "W2": "0x00000003",
        }
    }
    code = '''
    cmp w0, w1         // 5 vs 10, N=0, Z=0, C=0, V=0
    ccmp w0, w2, #0, le  // if LE (true, since 5 <= 10), compare 5 vs 3
    mrs x3, nzcv       // from ccmp: 5 vs 3, N=0, Z=0, C=1
'''
    write_test("ccmp_true.s", config, code)

def gen_bitfield():
    """Generate bitfield operation tests."""
    
    # BFI (Bitfield Insert)
    config = {
        "Match": "All",
        "RegData": {
            "W0": "0x12345678",  # destination
            "W1": "0x000000FF",  # source (low 8 bits to insert)
        }
    }
    code = '''
    bfi w0, w1, #8, #8   // insert bits [7:0] of w1 into bits [15:8] of w0
'''
    write_test("bfi_basic.s", config, code)
    
    # BFXIL (Bitfield Extract and Insert Low)
    config = {
        "Match": "All",
        "RegData": {
            "W0": "0x12345678",
            "W1": "0xABCDEF00",
        }
    }
    code = '''
    bfxil w0, w1, #8, #16  // extract bits [23:8] of w1, insert into bits [15:0] of w0
'''
    write_test("bfxil_basic.s", config, code)
    
    # SBFX/UBFX
    config = {
        "Match": "All",
        "RegData": {
            "W0": "0x80808080",
        }
    }
    code = '''
    sbfx w1, w0, #7, #9   // signed extract bits [15:7] and sign extend
    ubfx w2, w0, #7, #9   // unsigned extract bits [15:7]
'''
    write_test("bfx_signed_unsigned.s", config, code)

def gen_logical_flags():
    """Generate logical operation flags tests."""
    
    # ANDS flags
    config = {
        "Match": "All",
        "RegData": {
            "W0": "0x80000000",
            "W1": "0x80000000",
        }
    }
    code = '''
    ands w2, w0, w1    // result = 0x80000000, N=1, Z=0, C=0, V=0
    mrs x3, nzcv
'''
    write_test("ands_n_flag.s", config, code)
    
    config = {
        "Match": "All",
        "RegData": {
            "W0": "0x12345678",
            "W1": "0x00000000",
        }
    }
    code = '''
    ands w2, w0, w1    // result = 0, Z=1, C=0, V=0
    mrs x3, nzcv
'''
    write_test("ands_z_flag.s", config, code)

def gen_extend_arith():
    """Generate extended register arithmetic tests."""
    
    # ADD with extend
    config = {
        "Match": "All",
        "RegData": {
            "X0": "0x0000000012345678",
            "W1": "0x000000AB",  # will be sign/zero extended
        }
    }
    code = '''
    add x2, x0, w1, sxtw   // sign-extend w1 to 64-bit and add
    add x3, x0, w1, uxtw   // zero-extend w1 to 64-bit and add
'''
    write_test("add_extend_64.s", config, code)
    
    # ADD with shift and extend
    config = {
        "Match": "All",
        "RegData": {
            "X0": "0x0000000012345678",
            "W1": "0x000000FF",
        }
    }
    code = '''
    add x2, x0, w1, uxtw #2   // zero-extend and shift left by 2
'''
    write_test("add_extend_shift.s", config, code)

def main():
    os.makedirs(OUTPUT_DIR, exist_ok=True)
    
    print("Generating A64 edge case tests...")
    
    gen_shift_overflow()
    gen_shift_edge_cases()
    gen_adds_nzcv()
    gen_adcs_flags()
    gen_subs_nzcv()
    gen_sbcs_flags()
    gen_register_overlap()
    gen_mul_overflow()
    gen_div_edge()
    gen_cond_select()
    gen_ccmp()
    gen_bitfield()
    gen_logical_flags()
    gen_extend_arith()
    
    print(f"\nGenerated tests in: {OUTPUT_DIR}")
    print(f"Total files: {len(os.listdir(OUTPUT_DIR))}")

if __name__ == "__main__":
    main()
