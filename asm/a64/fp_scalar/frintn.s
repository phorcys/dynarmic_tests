/* CONFIG
{
  "Match": "All",
  "RegData": {
    "S0": "0x0000000040600000",
    "S1": "0x0000000040800000"
  }
}
*/
// Test: FRINTN Sd, Sn - floating-point round to integral nearest with ties to even

.text
.global _start
_start:
    // Load S0 with 3.5
    mov w0, #0x0000
    movk w0, #0x4060, lsl #16
    fmov s0, w0
    
    // FRINTN: round to nearest even (3.5 -> 4.0)
    frintn s1, s0

    brk #0
