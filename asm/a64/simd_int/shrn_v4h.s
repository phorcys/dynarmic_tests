/* CONFIG
{
  "Match": "All",
  "RegData": {
    "Q0": "0x00000004000000030000000200000001",
    "Q1": "0x00000000000000000000000000000000"
  }
}
*/
// Test: SHRN Vd.4H, Vn.4S, #16 - shift right narrow (4x 32-bit to 4x 16-bit)
// V0.4S = [1, 2, 3, 4] (32-bit elements)
// V1.4H = SHRN V0.4S, #16 = [0, 0, 0, 0] (shifted right by 16, then narrowed)

.text
.global _start
_start:
    // Load V0 with [1, 2, 3, 4] as 32-bit
    mov x0, #1
    mov x1, #2
    mov x2, #3
    mov x3, #4
    dup v0.4s, w0
    ins v0.s[1], w1
    ins v0.s[2], w2
    ins v0.s[3], w3

    // Shift right narrow by 16
    shrn v1.4h, v0.4s, #16

    brk #0
