/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000060000000",
    "X1": "0x0000000000000000"
  }
}
*/
// Test: NEGS with shifted register - flags verification (32-bit)
// NEGS Xd, Xn, shift #imm is alias for SUBS Xd, XZR, Xn, shift #imm

.text
.global _start
_start:
    mov x0, #0
    mov w2, #0x80000000   // w2 = 0x80000000 (min negative)
    
    // NEGS W3, W2, LSL #1
    // W2 << 1 = 0 (32-bit shift overflow)
    // SUBS W3, WZR, 0 = 0 - 0 = 0
    // N=0, Z=1, C=1, V=0 -> NZCV = 0x60000000
    negs w3, w2, lsl #1
    
    mrs x0, nzcv
    mov x1, x3
    
    brk #0