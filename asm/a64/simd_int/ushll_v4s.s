/* CONFIG
{
  "Match": "All",
  "RegData": {
    "Q0": "0x00000000000000000003000400010002",
    "Q1": "0x00000006000000080000000200000004"
  }
}
*/
// Test: USHLL Vd.4S, Vn.4H, #1 - unsigned shift left long (4x 16-bit to 4x 32-bit)
// V0.4H = [2, 1, 4, 3] (16-bit elements)
// V1.4S = USHLL V0.4H, #1 = [4, 2, 8, 6] (shifted left by 1)

.text
.global _start
_start:
    // Load V0 with 16-bit values [2, 1, 4, 3]
    mov x0, #0x0002
    movk x0, #0x0001, lsl #16
    movk x0, #0x0004, lsl #32
    movk x0, #0x0003, lsl #48
    mov v0.d[0], x0
    mov v0.d[1], xzr

    // Unsigned shift left long (shift by 1)
    ushll v1.4s, v0.4h, #1

    brk #0