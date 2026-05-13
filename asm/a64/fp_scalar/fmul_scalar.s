/* CONFIG
{
  "Match": "All",
  "RegData": {
    "S0": "0x40000000",
    "S1": "0x40400000",
    "S2": "0x40C00000"
  }
}
*/
// Test: FMUL Sd, Sn, Sm - scalar floating-point multiply

.text
.global _start
_start:
    // Load S0 = 2.0 (0x40000000)
    mov w0, #0
    movk w0, #0x4000, lsl #16
    fmov s0, w0

    // Load S1 = 3.0 (0x40400000)
    mov w1, #0
    movk w1, #0x4040, lsl #16
    fmov s1, w1

    // FMUL: S2 = S0 * S1 = 2.0 * 3.0 = 6.0 (0x40C00000)
    fmul s2, s0, s1

    brk #0