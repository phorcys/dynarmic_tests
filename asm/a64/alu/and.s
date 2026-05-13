/* CONFIG
{
  "Match": "All",
  "X0": "0x000000000000000F"
}
*/
// Test: AND Xt, Xn, Xm - Bitwise AND
// Performs bitwise AND operation

.text
.global _start
_start:
    mov x0, #0xFF
    mov x1, #0x0F
    
    // AND: bitwise AND
    and x0, x0, x1
    
    brk #0
