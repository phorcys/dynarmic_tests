/* CONFIG
{
  "Match": "All",
  "RegData": {
    "Q0": "0x40800000000000004080000000000000",
    "Q1": "0x00000000FFFFFFFF00000000FFFFFFFF"
  }
}
*/
// Test: FCMEQ Vd.4S, Vn.4S, #0.0 - compare equal to zero
// V0.4S = [0.0, 4.0, 0.0, 4.0]
// V1.4S = (V0 == 0) ? ~0 : 0 = [~0, 0, ~0, 0]
// S[0]=0.0 == 0 => ~0, S[1]=4.0 != 0 => 0
// S[2]=0.0 == 0 => ~0, S[3]=4.0 != 0 => 0
// V1 = [0xFFFFFFFF, 0, 0xFFFFFFFF, 0]

.text
.global _start
_start:
    // Load V0 with [0.0, 4.0, 0.0, 4.0]
    mov x0, #0x0000
    movk x0, #0x0000, lsl #16
    movk x0, #0x0000, lsl #32
    movk x0, #0x4080, lsl #48
    mov v0.d[0], x0
    mov v0.d[1], x0

    // Compare equal to zero
    fcmeq v1.4s, v0.4s, #0.0

    brk #0
