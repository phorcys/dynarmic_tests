/* CONFIG
{
  "Match": "All",
  "RegData": {
    "S0": "0x0000000040400000",
    "S1": "0x0000000040800000"
  }
}
*/
// Test: FCCMP Sn, Sm, #nzcv, cond - floating-point conditional compare

.text
.global _start
_start:
    // Load S0 with 3.0
    mov w0, #0x0000
    movk w0, #0x4040, lsl #16
    fmov s0, w0
    
    // Load S1 with 4.0
    mov w1, #0x0000
    movk w1, #0x4080, lsl #16
    fmov s1, w1
    
    // FCCMP: compare S0 and S1 conditionally
    fcmp s0, s1

    brk #0
