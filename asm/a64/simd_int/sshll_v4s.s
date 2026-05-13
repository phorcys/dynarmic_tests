/* CONFIG
{
  "Match": "All",
  "RegData": {
    "Q0": "0x00000000000000000003000400010002",
    "Q1": "0x00000003000000040000000100000002"
  }
}
*/
// Test: SSHLL Vd.4S, Vn.4H, #0 - signed shift left long (4x 16-bit to 4x 32-bit)
// V0.4H = [2, 1, 4, 3] (16-bit elements in low 64 bits)
// V1.4S = SSHLL V0.4H, #0 = [2, 1, 4, 3] (32-bit elements, no shift)

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

    // Signed shift left long (shift by 0)
    sshll v1.4s, v0.4h, #0

    brk #0
