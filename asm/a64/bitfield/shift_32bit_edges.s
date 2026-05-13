/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X1": "0x0000000080000000",
    "X3": "0x0000000000000001",
    "X5": "0x00000000FFFFFFFF",
    "X7": "0x0000000080000000"
  }
}
*/
// 32-bit LSL/LSR/ASR/ROR boundary coverage.

.text
.global _start
_start:
    mov w0, #1
    lsl w1, w0, #31

    mov w2, #1
    lsl w2, w2, #31
    lsr w3, w2, #31

    mov w4, #1
    lsl w4, w4, #31
    asr w5, w4, #31

    mov w6, #1
    ror w7, w6, #1

    brk #0
