/* CONFIG
{
  "Match": "All",
  "RegData": {
    "S0": "0x0000000040000000"
  }
}
*/
// Test: FRINTP - Round to plus infinity

.text
.global _start
_start:
    mov w0, #0x0000
    movk w0, #0x4000, lsl #16    // 2.0
    fmov s0, w0
    frintp s0, s0

    brk #0
