/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000055",
    "X1": "0xAA00000000000000",
    "X2": "0x0000000000000000",
    "X3": "0x0000000000000000",
    "X4": "0x0000000000000000",
    "X5": "0x0000000000000000",
    "X6": "0x0000000000000000",
    "X7": "0x0000000000000000"
  }
}
*/
// Test: RBIT - reverse bits

.text
.global _start
_start:
    mov x0, #0x55
    rbit x1, x0              // 0x55 = 01010101b, reversed
    mov x2, #0
    mov x3, #0
    mov x4, #0
    mov x5, #0
    mov x6, #0
    mov x7, #0

    brk #0
