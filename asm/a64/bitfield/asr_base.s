/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000080000000",
    "X1": "0x0000000008000000",
    "X2": "0xFFFFFFFFFFFFFFF0",
    "X3": "0xFFFFFFFFFFFFFFFC",
    "X4": "0x0000000000000000",
    "X5": "0x0000000000000000",
    "X6": "0x0000000000000000",
    "X7": "0x0000000000000000"
  }
}
*/
// Test: ASR - arithmetic shift right (sign-extend)

.text
.global _start
_start:
    mov x0, #0x80000000
    asr x1, x0, #4           // arithmetic shift preserves sign
    mov x2, #-16
    asr x3, x2, #2           // -16 >> 2 = -4 (arithmetic)
    mov x4, #0
    mov x5, #0
    mov x6, #0
    mov x7, #0

    brk #0
