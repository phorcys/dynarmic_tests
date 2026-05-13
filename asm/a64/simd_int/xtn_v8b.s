/* CONFIG
{
  "Match": "All",
  "RegData": {
    "Q0": "0x00000000000000000010000700030001",
    "Q2": "0x00000000000000000000000010070301"
  }
}
*/
// Test: XTN Vd.8B, Vn.8H - extract narrow (truncate halfword to byte)

.text
.global _start
_start:
    // Load Q0 with 8 halfwords: [1, 3, 7, 16, ...]
    mov w0, #1
    mov w1, #3
    mov w2, #7
    mov w3, #16
    mov v0.h[0], w0
    mov v0.h[1], w1
    mov v0.h[2], w2
    mov v0.h[3], w3
    mov v0.d[1], xzr
    
    // XTN: truncate each halfword to byte
    // [1, 3, 7, 16] -> [0x01, 0x03, 0x07, 0x10, 0, 0, 0, 0]
    xtn v2.8b, v0.8h

    brk #0
