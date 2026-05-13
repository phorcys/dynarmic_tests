/* CONFIG
{
  "Match": "All",
  "RegData": {
    "Q0": "0x40000000400000004000000040000000",
    "Q1": "0x40000000000000004000000000000000"
  }
}
*/
// Test: FCVTL Vd.2D, Vn.2S - convert single to double (long)
// V0.2S (lower half) = [2.0f, 2.0f]
// V1.2D = FCVTL from V0.2S = [2.0, 2.0] as doubles

.text
.global _start
_start:
    // Load V0 with [2.0f, 2.0f, 2.0f, 2.0f]
    // 2.0f = 0x40000000
    mov x0, #0x0000
    movk x0, #0x4000, lsl #16
    movk x0, #0x0000, lsl #32
    movk x0, #0x4000, lsl #48
    mov v0.d[0], x0
    mov v0.d[1], x0

    // Convert single to double (long from lower half)
    fcvtl v1.2d, v0.2s

    brk #0