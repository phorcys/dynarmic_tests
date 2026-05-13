/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x00000000000000FF"
  }
}
*/
// Test: ORR Xd, Xn, Xm - Bitwise OR
// Performs bitwise OR

.text
.global _start
_start:
    mov x0, #0xF0
    mov x1, #0x0F
    
    // ORR: X0 = X0 OR X1
    orr x0, x0, x1       // X0 = 0xFF

    brk #0
