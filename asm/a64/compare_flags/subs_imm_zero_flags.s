/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000060000000",
    "X1": "0x0000000000000000"
  }
}
*/
// Test: SUBS with immediate - Subtract with flag set
// SUBS Xd, Xn, #imm: Xd = Xn - imm, sets NZCV

.text
.global _start
_start:
    mov x2, #5
    
    // SUBS X1, X2, #5 = 5 - 5 = 0
    // N=0, Z=1, C=1 (no borrow), V=0 -> NZCV = 0x60000000
    
    subs x1, x2, #5
    
    mrs x0, nzcv
    
    brk #0