/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0xFFFFFFFFFFFFFFF0",
    "X1": "0xFFFFFFFFFFFFFFFC",
    "X2": "0xFFFFFFFFFFFFFFFF",
    "X3": "0x0000000000000010",
    "X4": "0x0000000000000004",
    "X5": "0x0000000000000000",
    "X6": "0x0000000000000000",
    "X7": "0x0000000000000000"
  }
}
*/
// Test: ASR - with immediate (arithmetic)

.text
.global _start
_start:
    mov x0, #-16
    asr x1, x0, #2           // -16 >> 2 = -4 (sign extended)
    asr x2, x0, #4           // -16 >> 4 = -1 (sign extended)
    mov x3, #16
    asr x4, x3, #2           // 16 >> 2 = 4
    mov x5, #0
    mov x6, #0
    mov x7, #0

    brk #0
