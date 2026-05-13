/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000000",
    "X1": "0x0000000000000005"
  }
}
*/
// Test: ADDS with immediate - Add with flag set
// ADDS Xd, Xn, #imm: Xd = Xn + imm, sets NZCV

.text
.global _start
_start:
    mov x2, #3
    
    // ADDS X1, X2, #2 = 3 + 2 = 5
    // N=0, Z=0, C=0, V=0 -> NZCV = 0
    
    adds x1, x2, #2
    
    mrs x0, nzcv
    
    brk #0