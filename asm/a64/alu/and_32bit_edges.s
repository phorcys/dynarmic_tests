/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X2": "0x0000000080000001",
    "X3": "0x0000000012345678",
    "X5": "0x000000000000FFFF"
  }
}
*/
// AND 32-bit coverage with edge values and overlap.

.text
.global _start
_start:
    movn w0, #0
    mov w1, #1
    lsl w1, w1, #31
    add w1, w1, #1
    and w2, w0, w1

    movz w3, #0x5678
    movk w3, #0x1234, lsl #16
    and w3, w3, w3

    movn w4, #0
    and w5, w4, #0xFFFF

    brk #0
