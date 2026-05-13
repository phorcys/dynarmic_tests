/* CONFIG
{
  "Match": "All",
  "RegData": {
    "Q0": "0x00000000000000030000000000000003",
    "Q1": "0x00000000ffffffff00000000ffffffff"
  }
}
*/
// Test: CMGT Vd.4S, Vn.4S, #0 - compare signed greater than zero
// V0.4S = [3, 0, 3, 0]
// V1.4S = (V0 > 0) ? 0xFFFFFFFF : 0 = [true, false, true, false]

.text
.global _start
_start:
    // Load V0 with [3, 0, 3, 0]
    mov x0, #3
    mov x1, #0
    dup v0.2s, w0
    ins v0.s[1], w1
    ins v0.s[2], w0
    ins v0.s[3], w1

    // Compare greater than zero
    cmgt v1.4s, v0.4s, #0

    brk #0