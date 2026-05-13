/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000090000000",
    "X1": "0x8000000000000000"
  }
}
*/
// Test: ADDS 64-bit overflow detection
// Tests signed overflow when adding large positive numbers

.text
.global _start
_start:
    // 0x7FFFFFFFFFFFFFFF + 1 = 0x8000000000000000 (overflow)
    movz x2, #0xFFFF
    movk x2, #0xFFFF, lsl #16
    movk x2, #0xFFFF, lsl #32
    movk x2, #0x7FFF, lsl #48  // x2 = 0x7FFFFFFFFFFFFFFF (max positive)
    
    mov x3, #1
    
    adds x1, x2, x3
    
    // Result: 0x8000000000000000 (min negative)
    // N=1, Z=0, C=1 (unsigned overflow), V=1 (signed overflow)
    // NZCV = 0x90000000
    
    mrs x0, nzcv
    
    brk #0
