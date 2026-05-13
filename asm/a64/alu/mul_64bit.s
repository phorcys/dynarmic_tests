/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x00000000000003E8",
    "X1": "0x00000000000003E8",
    "X2": "0x00000000000F4240",
    "X3": "0x0000000000000000",
    "X4": "0x0000000000000000",
    "X5": "0x0000000000000000",
    "X6": "0x0000000000000000",
    "X7": "0x0000000000000000"
  }
}
*/
// Test: MUL - 64-bit multiplication

.text
.global _start
_start:
    mov x0, #1000
    mov x1, #1000
    mul x2, x0, x1           // 1000 * 1000 = 1000000
    mov x3, #0
    mov x4, #0
    mov x5, #0
    mov x6, #0
    mov x7, #0

    brk #0
