/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x000000000000FF00",
    "X1": "0x000000000000FFFF"
  }
}
*/
// Test: ORR Xd, Xn, #imm - bitwise OR with immediate

.text
.global _start
_start:
    mov x0, #0xFF00
    
    // OR with 0x00FF
    orr x1, x0, #0xFF

    brk #0
