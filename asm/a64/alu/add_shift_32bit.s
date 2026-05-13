/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X2": "0x0000000080000001",
    "X4": "0x0000000000000002",
    "X6": "0x00000000FFFFFFFF",
    "X7": "0x0000000000000023"
  }
}
*/
// ADD shifted-register coverage in 32-bit mode.

.text
.global _start
_start:
    mov w0, #1
    mov w1, #1
    add w2, w0, w1, lsl #31

    mov w3, #0x80000000
    add w4, w0, w3, lsr #31

    mov w5, #0x80000000
    add w6, wzr, w5, asr #31

    mov w7, #3
    add w7, w7, w0, lsl #5

    brk #0
