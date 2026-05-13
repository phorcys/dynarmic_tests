/* CONFIG
{
  "Match": "All",
  "RegData": {
    "Q0": "0x40800000C040000040800000C0400000",
    "Q1": "0xFFFFFFFF00000000FFFFFFFF00000000"
  }
}
*/
// Test: FCMGE Vd.4S, Vn.4S, #0.0 - compare greater than or equal to zero
// V0.4S = [-3.0, 4.0, -3.0, 4.0]
// V1.4S = (V0 >= 0) ? ~0 : 0 = [0, ~0, 0, ~0]
// -3.0 = 0xC0400000, 4.0 = 0x40800000

.text
.global _start
_start:
    // Load V0 with [-3.0, 4.0, -3.0, 4.0]
    // d[0]: S[0]=-3.0, S[1]=4.0 => 0x40800000_C0400000
    mov x0, #0x0000
    movk x0, #0xC040, lsl #16
    movk x0, #0x0000, lsl #32
    movk x0, #0x4080, lsl #48
    mov v0.d[0], x0
    mov v0.d[1], x0

    // Compare greater than or equal to zero
    fcmge v1.4s, v0.4s, #0.0

    brk #0