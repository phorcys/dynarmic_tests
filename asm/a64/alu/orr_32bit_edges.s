/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X2": "0x0000000080000001",
    "X3": "0x0000000000000000",
    "X5": "0x00000000FF00FF00"
  }
}
*/
// ORR 32-bit coverage with edge values, overlap, and immediate form.

.text
.global _start
_start:
    mov w0, #1
    lsl w0, w0, #31
    mov w1, #1
    orr w2, w0, w1

    mov w3, #0
    orr w3, w3, w3

    mov w4, #0
    orr w5, w4, #0xFF00FF00

    brk #0
