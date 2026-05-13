/* CONFIG
{
  "Match": "All",
  "RegData": {
    "S0": "0x0000000040400000",
    "S1": "0x0000000040400000"
  }
}
*/
// Test: FRINTI Sd, Sn - floating-point round to integral exact

.text
.global _start
_start:
    // Load S0 with 3.0
    mov w0, #0x0000
    movk w0, #0x4040, lsl #16
    fmov s0, w0
    
    // FRINTI: round to integral exact
    frinti s1, s0

    brk #0
