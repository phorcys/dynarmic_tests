#!/usr/bin/env python3
"""生成全面的 A64 边界条件测试"""
import os
from pathlib import Path
import json

OUT_DIR = str(Path(__file__).resolve().parent / "a64_edge_cases")

def write_test(name, regs, code, expected_regs):
    """写入测试文件"""
    config = {'Match': 'All', 'RegData': expected_regs}
    
    content = f'''/* CONFIG
{json.dumps(config, indent=2)}
*/
// Auto-generated edge case test: {name}

.text
.global _start
_start:
{code}

    brk #0
'''
    
    path = os.path.join(OUT_DIR, f"{name}.s")
    with open(path, 'w') as f:
        f.write(content)

def gen_all_tests():
    """生成所有边界条件测试"""
    os.makedirs(OUT_DIR, exist_ok=True)
    
    count = 0
    
    # =========================================
    # 1. 位移指令边界条件测试
    # =========================================
    
    # 1.1 LSL 寄存器版本 - shift >= 32
    write_test('lsl_reg_overflow_32',
        {'W0': '0x12345678', 'W1': '0x00000020'},
        '''
    mov w0, #0x5678
    movk w0, #0x1234, lsl #16
    mov w1, #32
    lsl w2, w0, w1    // shift=32, result should be 0
''',
        {'X0': '0x0000000012345678', 'X1': '0x0000000000000020', 'X2': '0x0000000000000000'}
    )
    count += 1
    
    write_test('lsl_reg_overflow_33',
        {'W0': '0x12345678', 'W1': '0x00000021'},
        '''
    mov w0, #0x5678
    movk w0, #0x1234, lsl #16
    mov w1, #33
    lsl w2, w0, w1    // shift=33, result should be 0
''',
        {'X0': '0x0000000012345678', 'X1': '0x0000000000000021', 'X2': '0x0000000000000000'}
    )
    count += 1
    
    # 1.2 LSR 寄存器版本 - shift >= 32
    write_test('lsr_reg_overflow_32',
        {'W0': '0x12345678', 'W1': '0x00000020'},
        '''
    mov w0, #0x5678
    movk w0, #0x1234, lsl #16
    mov w1, #32
    lsr w2, w0, w1    // shift=32, result should be 0
''',
        {'X0': '0x0000000012345678', 'X1': '0x0000000000000020', 'X2': '0x0000000000000000'}
    )
    count += 1
    
    # 1.3 ASR 寄存器版本 - shift >= 32 (positive)
    write_test('asr_reg_overflow_pos',
        {'W0': '0x12345678', 'W1': '0x00000020'},
        '''
    mov w0, #0x5678
    movk w0, #0x1234, lsl #16
    mov w1, #32
    asr w2, w0, w1    // shift=32, positive value, result should be 0
''',
        {'X0': '0x0000000012345678', 'X1': '0x0000000000000020', 'X2': '0x0000000000000000'}
    )
    count += 1
    
    # 1.4 ASR 寄存器版本 - shift >= 32 (negative)
    write_test('asr_reg_overflow_neg',
        {'W0': '0xFFFFFFFF', 'W1': '0x00000020'},
        '''
    mov w0, #0xFFFF
    movk w0, #0xFFFF, lsl #16    // w0 = 0xFFFFFFFF (negative)
    mov w1, #32
    asr w2, w0, w1    // shift=32, negative value, result should be 0xFFFFFFFF
''',
        {'X0': '0x00000000FFFFFFFF', 'X1': '0x0000000000000020', 'X2': '0x00000000FFFFFFFF'}
    )
    count += 1
    
    # 1.5 Shift edge: 0, 30, 31
    write_test('lsl_edge_shifts',
        {'W0': '0x00000001'},
        '''
    mov w0, #1
    mov w1, #0
    mov w2, #30
    mov w3, #31
    
    lsl w4, w0, w1    // shift=0, result=1
    lsl w5, w0, w2    // shift=30, result=0x40000000
    lsl w6, w0, w3    // shift=31, result=0x80000000
''',
        {'X4': '0x0000000000000001', 'X5': '0x0000000040000000', 'X6': '0x0000000080000000'}
    )
    count += 1
    
    write_test('lsr_edge_shifts',
        {'W0': '0x80000000'},
        '''
    mov w0, #1
    lsl w0, w0, #31    // w0 = 0x80000000
    mov w1, #0
    mov w2, #30
    mov w3, #31
    
    lsr w4, w0, w1    // shift=0, result=0x80000000
    lsr w5, w0, w2    // shift=30, result=2
    lsr w6, w0, w3    // shift=31, result=1
''',
        {'X4': '0x0000000080000000', 'X5': '0x0000000000000002', 'X6': '0x0000000000000001'}
    )
    count += 1
    
    # 1.6 64位位移边界
    write_test('lsl64_reg_overflow',
        {'X0': '0x123456789ABCDEF0', 'X1': '0x0000000000000040'},
        '''
    mov x0, #0xDEF0
    movk x0, #0x9ABC, lsl #16
    movk x0, #0x5678, lsl #32
    movk x0, #0x1234, lsl #48
    mov x1, #64
    lsl x2, x0, x1    // shift=64, result should be 0
''',
        {'X2': '0x0000000000000000'}
    )
    count += 1
    
    # =========================================
    # 2. ADDS/SUBS NZCV flags 测试
    # =========================================
    
    # 2.1 ADDS 正溢出
    write_test('adds_overflow_pos',
        {},
        '''
    mov w0, #1
    lsl w0, w0, #31
    sub w0, w0, #1    // w0 = 0x7FFFFFFF
    adds w1, w0, #1   // 0x7FFFFFFF + 1 = 0x80000000
    mrs x2, nzcv      // N=1, Z=0, C=0, V=1 => NZCV=0x90000000
''',
        {'X1': '0x0000000080000000', 'X2': '0x0000000090000000'}
    )
    count += 1
    
    # 2.2 ADDS 负溢出
    write_test('adds_overflow_neg',
        {},
        '''
    mov w0, #1
    lsl w0, w0, #31   // w0 = 0x80000000
    mov w1, #1
    lsl w1, w1, #31   // w1 = 0x80000000
    adds w2, w0, w1   // 0x80000000 + 0x80000000 = 0 (with overflow)
    mrs x3, nzcv      // N=0, Z=1, C=1, V=1 => NZCV=0x30000000
''',
        {'X2': '0x0000000000000000', 'X3': '0x0000000030000000'}
    )
    count += 1
    
    # 2.3 SUBS 借位
    write_test('subs_borrow',
        {},
        '''
    mov w0, #0
    subs w1, w0, #1   // 0 - 1 = 0xFFFFFFFF
    mrs x2, nzcv      // N=1, Z=0, C=0 (borrow), V=0 => NZCV=0x80000000
''',
        {'X1': '0x00000000FFFFFFFF', 'X2': '0x0000000080000000'}
    )
    count += 1
    
    # 2.4 SUBS 正溢出 (0x80000000 - 1 = 0x7FFFFFFF)
    write_test('subs_overflow',
        {},
        '''
    mov w0, #1
    lsl w0, w0, #31   // w0 = 0x80000000
    subs w1, w0, #1   // 0x80000000 - 1 = 0x7FFFFFFF
    mrs x2, nzcv      // N=0, Z=0, C=1 (no borrow), V=1 => NZCV=0x30000000
''',
        {'X1': '0x000000007FFFFFFF', 'X2': '0x0000000030000000'}
    )
    count += 1
    
    # 2.5 ADDS 结果为零
    write_test('adds_zero',
        {},
        '''
    mov w0, #0
    adds w1, w0, #0   // 0 + 0 = 0
    mrs x2, nzcv      // N=0, Z=1, C=0, V=0 => NZCV=0x40000000
''',
        {'X1': '0x0000000000000000', 'X2': '0x0000000040000000'}
    )
    count += 1
    
    # =========================================
    # 3. ADCS/SBCS 进位链测试
    # =========================================
    
    # 3.1 ADC 进位链
    write_test('adc_chain',
        {},
        '''
    mov w0, #0xFFFFFFFF
    mov w1, #0
    adds w2, w0, #1   // 0xFFFFFFFF + 1 = 0, C=1
    adc w3, w1, w1    // 0 + 0 + C = 1
''',
        {'X2': '0x0000000000000000', 'X3': '0x0000000000000001'}
    )
    count += 1
    
    # 3.2 SBC 借位链
    write_test('sbc_chain',
        {},
        '''
    mov w0, #0
    mov w1, #1
    subs w2, w0, #1   // 0 - 1 = 0xFFFFFFFF, C=0 (borrow)
    sbc w3, w0, w1    // 0 - 1 - !C = 0 - 1 - 1 = 0xFFFFFFFE
''',
        {'X2': '0x00000000FFFFFFFF', 'X3': '0x00000000FFFFFFFE'}
    )
    count += 1
    
    # =========================================
    # 4. 乘法溢出测试
    # =========================================
    
    write_test('mul_overflow_32',
        {},
        '''
    mov w0, #0xFFFF
    movk w0, #0xFFFF, lsl #16   // w0 = 0xFFFFFFFF
    mul w1, w0, w0              // 0xFFFFFFFF * 0xFFFFFFFF = 1 (mod 2^32)
''',
        {'X1': '0x0000000000000001'}
    )
    count += 1
    
    write_test('smull_max',
        {},
        '''
    mov w0, #0xFFFF
    movk w0, #0xFFFF, lsl #16   // w0 = 0xFFFFFFFF (-1)
    smull x1, w0, w0            // -1 * -1 = 1 (64-bit)
''',
        {'X1': '0x0000000000000001'}
    )
    count += 1
    
    # =========================================
    # 5. 除法边界测试
    # =========================================
    
    write_test('sdiv_intmin',
        {},
        '''
    mov w0, #1
    lsl w0, w0, #31   // w0 = 0x80000000 (INT_MIN)
    mov w1, #0xFFFF
    movk w1, #0xFFFF, lsl #16   // w1 = -1
    sdiv w2, w0, w1   // INT_MIN / -1 = INT_MIN (overflow, returns INT_MIN)
''',
        {'X2': '0x0000000080000000'}
    )
    count += 1
    
    write_test('sdiv_zero',
        {},
        '''
    mov w0, #123
    mov w1, #0
    sdiv w2, w0, w1   // division by zero returns 0
''',
        {'X2': '0x0000000000000000'}
    )
    count += 1
    
    write_test('udiv_zero',
        {},
        '''
    mov w0, #123
    mov w1, #0
    udiv w2, w0, w1   // division by zero returns 0
''',
        {'X2': '0x0000000000000000'}
    )
    count += 1
    
    # =========================================
    # 6. CSEL 条件选择测试
    # =========================================
    
    write_test('csel_eq',
        {},
        '''
    mov w0, #5
    mov w1, #5
    mov w2, #10
    mov w3, #20
    cmp w0, w1
    csel w4, w2, w3, eq   // w4 = 10 (equal)
''',
        {'X4': '0x000000000000000A'}
    )
    count += 1
    
    write_test('csel_ne',
        {},
        '''
    mov w0, #5
    mov w1, #6
    mov w2, #10
    mov w3, #20
    cmp w0, w1
    csel w4, w2, w3, ne   // w4 = 10 (not equal)
''',
        {'X4': '0x000000000000000A'}
    )
    count += 1
    
    write_test('csel_mi',  # negative
        {},
        '''
    mov w0, #1
    lsl w0, w0, #31   // w0 = 0x80000000 (negative)
    mov w1, #10
    mov w2, #20
    cmp w0, #0
    csel w3, w1, w2, mi   // w3 = 10 (negative)
''',
        {'X3': '0x000000000000000A'}
    )
    count += 1
    
    write_test('csel_vs',  # overflow
        {},
        '''
    mov w0, #1
    lsl w0, w0, #31
    sub w0, w0, #1    // w0 = 0x7FFFFFFF
    adds w0, w0, #1   // overflow
    mov w1, #10
    mov w2, #20
    csel w3, w1, w2, vs   // w3 = 10 (overflow set)
''',
        {'X3': '0x000000000000000A'}
    )
    count += 1
    
    # =========================================
    # 7. CCMP 条件比较测试
    # =========================================
    
    write_test('ccmp_basic',
        {},
        '''
    mov w0, #5
    cmp w0, #10       // 5 < 10, so N=0, C=1
    ccmp w0, #3, #0, ge  // if 5 >= 10, compare with 3; else set flags to #0
    mrs x1, nzcv      // should have flags from first comparison (5 < 10)
''',
        {'X1': '0x0000000020000000'}  # N=0, Z=0, C=1, V=0
    )
    count += 1
    
    # =========================================
    # 8. 寄存器重叠测试
    # =========================================
    
    write_test('reg_overlap_adds',
        {},
        '''
    mov w0, #100
    adds w0, w0, #50   // result and source are same register
''',
        {'X0': '0x0000000000000096'}  # 150
    )
    count += 1
    
    write_test('reg_overlap_mul',
        {},
        '''
    mov w0, #7
    mul w0, w0, w0     // w0 = 7 * 7 = 49
''',
        {'X0': '0x0000000000000031'}  # 49
    )
    count += 1
    
    write_test('reg_overlap_lsl',
        {},
        '''
    mov w0, #1
    mov w1, #4
    lsl w0, w0, w1     // w0 = 1 << 4 = 16
''',
        {'X0': '0x0000000000000010'}  # 16
    )
    count += 1
    
    # =========================================
    # 9. 位操作边界测试
    # =========================================
    
    write_test('bfi_basic',
        {},
        '''
    mov w0, #0xFF
    movk w0, #0xFF00, lsl #16   // w0 = 0x00FFFF00
    mov w1, #0x12345678
    bfi w1, w0, #8, #16   // insert bits [7:0] and [23:8] of w0 into w1 at position 8, width 16
                          // Result: replace bits [23:8] of w1 with bits [15:0] of w0
                          // w0[15:0] = 0xFF00
                          // w1 = 0x12FF0078
''',
        {'X1': '0x0000000012FF0078'}
    )
    count += 1
    
    write_test('bfxil_basic',
        {},
        '''
    mov w0, #0xABCD
    movk w0, #0x1234, lsl #16   // w0 = 0x1234ABCD
    mov w1, #0xFFFFFFFF
    bfxil w1, w0, #4, #12   // extract bits [15:4] of w0 and insert into w1 bits [11:0]
                            // w0[15:4] = 0xABCD >> 4 = 0xABC (bits [11:0])
                            // w1 = 0xFFFFFABC
''',
        {'X1': '0x00000000FFFFFABC'}
    )
    count += 1
    
    # =========================================
    # 10. ANDS 标志位测试
    # =========================================
    
    write_test('ands_n_flag',
        {},
        '''
    mov w0, #1
    lsl w0, w0, #31   // w0 = 0x80000000
    mov w1, #1
    lsl w1, w1, #31   // w1 = 0x80000000
    ands w2, w0, w1   // 0x80000000 & 0x80000000 = 0x80000000
    mrs x3, nzcv      // N=1, Z=0 => NZCV=0x80000000
''',
        {'X2': '0x0000000080000000', 'X3': '0x0000000080000000'}
    )
    count += 1
    
    write_test('ands_z_flag',
        {},
        '''
    mov w0, #0xFF
    mov w1, #0xFF00
    ands w2, w0, w1   // 0xFF & 0xFF00 = 0
    mrs x3, nzcv      // N=0, Z=1 => NZCV=0x40000000
''',
        {'X2': '0x0000000000000000', 'X3': '0x0000000040000000'}
    )
    count += 1
    
    # =========================================
    # 11. 扩展运算测试
    # =========================================
    
    write_test('add_extend_64',
        {},
        '''
    mov x0, #0x1000
    mov w1, #0xFF
    add x2, x0, w1, uxtb   // x2 = 0x1000 + 0xFF = 0x10FF
''',
        {'X2': '0x00000000000010FF'}
    )
    count += 1
    
    write_test('add_extend_shift',
        {},
        '''
    mov x0, #0x1000
    mov w1, #0xFF
    add x2, x0, w1, uxtb #2   // x2 = 0x1000 + (0xFF << 2) = 0x1000 + 0x3FC = 0x13FC
''',
        {'X2': '0x00000000000013FC'}
    )
    count += 1
    
    print(f"Generated {count} edge case tests in {OUT_DIR}")

if __name__ == '__main__':
    gen_all_tests()
