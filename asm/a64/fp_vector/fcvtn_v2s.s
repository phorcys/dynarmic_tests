/* CONFIG
{
  "Match": "All",
  "RegData": {
    "Q0": "0x40000000000000004000000000000000",
    "Q1": "0x00000000000000004000000040000000"
  }
}
*/
// Test: FCVTN Vd.2S, Vn.2D - convert double to single (narrow)
// V0.2D = [2.0, 2.0] as doubles
// V1.2S = [2.0f, 2.0f] (only low 64 bits of V1 are written)

.text
.global _start
_start:
    // Load V0 with [2.0, 2.0] as doubles
    mov x0, #0x0000
    movk x0, #0x0000, lsl #16
    movk x0, #0x0000, lsl #32
    movk x0, #0x4000, lsl #48
    mov v0.d[0], x0
    mov v0.d[1], x0

    // Convert double to single (narrow)
    fcvtn v1.2s, v0.2d

    brk #0