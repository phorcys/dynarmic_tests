/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X2": "0x0000000080000000",
    "X4": "0x0000000000000000",
    "X6": "0x0000000000000001",
    "X7": "0x0000000000000001"
  }
}
*/
// SUB shifted-register coverage in 32-bit mode.

.text
.global _start
_start:
    mov w0, #1
    mov w1, #1
    sub w2, wzr, w1, lsl #31

    mov w3, #0x80000000
    sub w4, w0, w3, lsr #31

    mov w5, #0x80000000
    sub w6, wzr, w5, asr #31

    mov w7, #3
    sub w7, w7, w0, lsl #1

    brk #0
