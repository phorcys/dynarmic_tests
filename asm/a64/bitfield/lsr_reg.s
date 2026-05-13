/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000100",
    "X1": "0x0000000000000004",
    "X2": "0x0000000000000010",
    "X3": "0x0000000000000000",
    "X4": "0x0000000000000000",
    "X5": "0x0000000000000000",
    "X6": "0x0000000000000000",
    "X7": "0x0000000000000000"
  }
}
*/
// Test: LSR - register variant

.text
.global _start
_start:
    mov x0, #256
    mov x1, #4
    lsr x2, x0, x1           // 256 >> 4 = 16
    mov x3, #0
    mov x4, #0
    mov x5, #0
    mov x6, #0
    mov x7, #0

    brk #0
