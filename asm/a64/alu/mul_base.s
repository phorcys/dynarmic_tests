/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x000000000000000C",
    "X1": "0x0000000000000007",
    "X2": "0x0000000000000054",
    "X3": "0x00000000000003E8",
    "X4": "0x00000000000003E8",
    "X5": "0x00000000000F4240",
    "X6": "0x0000000000000000",
    "X7": "0x0000000000000000"
  }
}
*/
// Test: MUL - basic multiplication

.text
.global _start
_start:
    mov x0, #12
    mov x1, #7
    mul x2, x0, x1           // 12 * 7 = 84
    mov x3, #1000
    mov x4, #1000
    mul x5, x3, x4           // 1000 * 1000 = 1000000
    mov x6, #0
    mov x7, #0

    brk #0
