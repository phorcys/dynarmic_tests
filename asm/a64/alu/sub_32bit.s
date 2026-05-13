/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000000",
    "X1": "0x0000000000000001",
    "X2": "0x00000000FFFFFFFF",
    "X3": "0x0000000000000064",
    "X4": "0x0000000000000032",
    "X5": "0x0000000000000000",
    "X6": "0x0000000000000000",
    "X7": "0x0000000000000000"
  }
}
*/
// Test: SUB - 32-bit with underflow

.text
.global _start
_start:
    mov w0, #0
    mov w1, #1
    sub w2, w0, w1           // 0 - 1 = 0xFFFFFFFF (wrap)
    mov w3, #100
    sub w4, w3, #50          // 100 - 50 = 50
    mov x5, #0
    mov x6, #0
    mov x7, #0

    brk #0
