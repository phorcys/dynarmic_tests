/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000030000000",
    "X1": "0x7FFFFFFFFFFFFFFF"
  }
}
*/
// Test: SUBS 64-bit underflow detection  
// Tests borrow when subtracting larger from smaller (unsigned view)

.text
.global _start
_start:
    // 0x8000000000000000 - 1 = 0x7FFFFFFFFFFFFFFF (borrow from sign bit)
    movz x2, #0x0000
    movk x2, #0x0000, lsl #16
    movk x2, #0x0000, lsl #32
    movk x2, #0x8000, lsl #48  // x2 = 0x8000000000000000 (min negative)
    
    mov x3, #1
    
    subs x1, x2, x3
    
    // Result: 0x7FFFFFFFFFFFFFFF (max positive)
    // N=0, Z=0, C=1 (no borrow for unsigned), V=1 (signed overflow: neg - pos = pos)
    // Wait, let me recalculate:
    // x2 = 0x8000000000000000 (interpreted as unsigned: very large, as signed: -2^63)
    // x2 - 1 = 0x7FFFFFFFFFFFFFFF (as unsigned: very large - 1, as signed: -2^63 - 1 is not representable)
    // For signed: -2^63 - 1 causes overflow because result would be -2^63-1 which is < -2^63
    // Actually -2^63 - 1 in 64-bit signed wraps to 0x7FFFFFFFFFFFFFFF
    // N=0 (result is positive), Z=0, C=1 (no borrow: 0x8000000000000000 >= 1), V=1 (signed overflow)
    // NZCV = 0x30000000
    
    mrs x0, nzcv
    
    brk #0
