/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000000",
    "X1": "0x0000000000000001",
    "X2": "0xFFFFFFFFFFFFFFFF",
    "X3": "0x0000000000000000",
    "X4": "0x0000000000000000",
    "X5": "0x0000000000000000",
    "X6": "0x0000000000000000",
    "X7": "0x0000000000000000"
  }
}
*/
// Test: SUB - underflow and boundary cases
// Testing: 0 - 1 = -1 (wrap)

.text
.global _start
_start:
    // 0 - 1 = -1 (underflow)
    mov x0, #0
    mov x1, #1
    sub x2, x0, x1           // 0 - 1 = -1 (0xFFFFFFFFFFFFFFFF)

    mov x3, #0
    mov x4, #0
    mov x5, #0
    mov x6, #0
    mov x7, #0

    brk #0
