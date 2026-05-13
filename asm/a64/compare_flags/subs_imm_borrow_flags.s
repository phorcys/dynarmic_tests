/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000020000000",
    "X1": "0x00000000FFFFFFFE"
  }
}
*/
// Test: SUBS with immediate borrow - Subtract with flag set
// SUBS Xd, Xn, #imm: Xd = Xn - imm, sets NZCV

.text
.global _start
_start:
    mov x2, #0xFFFFFFFF
    
    // SUBS X1, X2, #1 = 0xFFFFFFFF - 1 = 0xFFFFFFFE
    // For 64-bit: X2 = 0x00000000FFFFFFFF, X1 = 0x00000000FFFFFFFE
    // N=0 (bit 63 = 0), Z=0, C=1 (no borrow: 0xFFFFFFFF >= 1), V=0
    // NZCV = 0x20000000
    
    subs x1, x2, #1
    
    mrs x0, nzcv
    
    brk #0