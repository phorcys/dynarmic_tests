/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x00000000FFFFFFFF",
    "X1": "0x0000000000000001",
    "X2": "0x0000000000000000",
    "X3": "0x0000000000000064",
    "X4": "0x000000000000012C",
    "X5": "0x0000000000000000",
    "X6": "0x0000000000000000",
    "X7": "0x0000000000000000"
  }
}
*/
// Test: ADD - 32-bit (W registers)

.text
.global _start
_start:
    mov w0, #0xFFFFFFFF
    mov w1, #1
    add w2, w0, w1           // 0xFFFFFFFF + 1 = 0 (32-bit wrap)
    mov w3, #100
    add w4, w3, #200         // 100 + 200 = 300
    mov x5, #0
    mov x6, #0
    mov x7, #0

    brk #0
