/* CONFIG
{
  "Match": "All",
  "RegData": {
    "Q0": "0x00000000000000000010007000100010",
    "Q2": "0x00000000000000000000000001070101"
  }
}
*/
// Test: SHRN Vd.8B, Vn.8H, #shift - shift right narrow

.text
.global _start
_start:
    // Load Q0 with halfwords
    // [16, 16, 112, 16] -> after >> 4: [1, 1, 7, 1]
    mov w0, #16
    mov w1, #16
    mov w2, #112
    mov w3, #16
    mov v0.h[0], w0
    mov v0.h[1], w1
    mov v0.h[2], w2
    mov v0.h[3], w3
    mov v0.d[1], xzr
    
    // SHRN: shift right and narrow
    // Each halfword >> 4, then truncated to byte
    shrn v2.8b, v0.8h, #4

    brk #0
