/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X2": "0x000000007FFFFFFE",
    "X3": "0x0000000000000000",
    "X5": "0x0000000080000001"
  }
}
*/
// EOR 32-bit coverage with edge values and overlap.

.text
.global _start
_start:
    movn w0, #0
    mov w1, #1
    lsl w1, w1, #31
    add w1, w1, #1
    eor w2, w0, w1

    movz w3, #0x5678
    movk w3, #0x1234, lsl #16
    eor w3, w3, w3

    mov w4, #0
    eor w5, w4, w1

    brk #0
