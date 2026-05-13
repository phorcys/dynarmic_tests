/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0xFFFFFFFFFFFFFFF8",
    "X1": "0x0000000000000002",
    "X2": "0xFFFFFFFFFFFFFFFE"
  }
}
*/
// Test: ASR Xd, Xn, Xm - arithmetic shift right by register

.text
.global _start
_start:
    mov x0, #-8          // 0xFFFFFFFFFFFFFFF8
    mov x1, #2
    asr x2, x0, x1       // -8 >> 2 = -2

    brk #0
