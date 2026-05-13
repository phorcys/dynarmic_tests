/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0xFFFFFFFFFFFFFFF0"
  }
}
*/
// Test: ORN Xd, Xn, Xm - Bitwise OR NOT
// Performs bitwise OR with complement of operand

.text
.global _start
_start:
    mov x0, #0x00
    mov x1, #0x0F
    
    // ORN: X0 = X0 OR (NOT X1)
    // X1 = 0x0F, NOT X1 = 0xFFFF...F0
    // X0 = 0x00 OR 0xFFFF...F0 = 0xFFFF...F0
    orn x0, x0, x1

    brk #0