/* CONFIG
{
  "Match": "All",
  "RegData": {
    "Q0": "0x00800000000100000080000000010000",
    "Q1": "0x000000080000000F000000080000000F"
  }
}
*/
// Test: CLZ Vd.4S, Vn.4S - count leading zeros
// V0.4S = [0x00010000, 0x00800000, 0x00010000, 0x00800000]
// V1.4S = [15, 8, 15, 8] (count of leading zeros)

.text
.global _start
_start:
    // Load V0 with [0x00010000, 0x00800000, ...]
    mov x0, #0x0000
    movk x0, #0x0001, lsl #16
    movk x0, #0x0000, lsl #32
    movk x0, #0x0080, lsl #48
    mov v0.d[0], x0
    mov v0.d[1], x0

    // Count leading zeros
    clz v1.4s, v0.4s

    brk #0