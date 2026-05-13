/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000032",
    "X1": "0x0000000000000028",
    "X2": "0xFFFFFFFFFFFFFFF0"
  }
}
*/

// Test: SUB instruction (register and immediate)
// X0 = 50 - 0 = 50
// X1 = 50 - 10 = 40
// X2 = 0 - 16 = -16 (0xFFFFFFFFFFFFFFF0)

.text
.global _start

_start:
    mov x0, #50
    sub x1, x0, #10
    mov x3, #0
    sub x2, x3, #16
    brk #0
