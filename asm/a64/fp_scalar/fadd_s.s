/* CONFIG
{
  "Match": "All",
  "RegData": {
    "S0": "0x40A00000",
    "S1": "0x40000000"
  }
}
*/
// Test: FADD S0, S1, S2 - scalar floating-point add

.text
.global _start
_start:
    // Load S1 = 2.0f (0x40000000)
    mov w0, #0
    movk w0, #0x4000, lsl #16
    fmov s1, w0

    // Load S2 = 3.0f (0x40400000)
    mov w0, #0
    movk w0, #0x4040, lsl #16
    fmov s2, w0

    // FADD: S0 = S1 + S2 = 2.0 + 3.0 = 5.0 (0x40A00000)
    fadd s0, s1, s2

    brk #0