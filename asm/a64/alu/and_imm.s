/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000FFFFFFFFFFFF",
    "X1": "0x000000000000FFFF"
  }
}
*/
// Test: AND Xd, Xn, #imm - bitwise AND with immediate

.text
.global _start
_start:
    // Load X0 with 0xFFFFFFFFFFFF (48-bit value)
    mov x0, #0xFFFF
    movk x0, #0xFFFF, lsl #16
    movk x0, #0xFFFF, lsl #32
    
    // AND with 0xFFFF
    and x1, x0, #0xFFFF

    brk #0
