/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x3FF0000000000000"
  }
}
*/
.text
.global _start
_start:
    // FABD - 浮点绝对差
    // FABD Dd, Dn, Dm
    // Dd = |Dn - Dm|
    
    // D1 = 1.0 (double)
    mov x8, #0x0000000000000000
    movk x8, #0x3FF0, lsl #48
    fmov d1, x8
    
    // D2 = 2.0 (double)
    mov x9, #0x0000000000000000
    movk x9, #0x4000, lsl #48
    fmov d2, x9
    
    // D0 = |1.0 - 2.0| = 1.0
    fabd d0, d1, d2
    
    fmov x0, d0

    brk #0