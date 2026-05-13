/* CONFIG
{
  "Match": "All",
  "RegData": {
    "S0": "0x0000000040400000",
    "S1": "0x0000000040400000"
  }
}
*/
// Test: FRINTX Sd, Sn - floating-point round using current rounding mode

.text
.global _start
_start:
    // Load S0 with 3.0
    mov w0, #0x0000
    movk w0, #0x4040, lsl #16
    fmov s0, w0
    
    // FRINTX: round using current rounding mode
    frintx s1, s0

    brk #0
