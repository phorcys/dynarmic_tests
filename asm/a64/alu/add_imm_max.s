/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X1": "0x0000000000001000",
    "X3": "0x0000000000FFF001",
    "X5": "0x0000000000001000",
    "X7": "0x0000000000FFF001"
  }
}
*/
// ADD immediate maximum encodings in 64-bit and 32-bit forms.

.text
.global _start
_start:
    mov x0, #1
    add x1, x0, #4095

    mov x2, #1
    add x3, x2, #4095, lsl #12

    mov w4, #1
    add w5, w4, #4095

    mov w6, #1
    add w7, w6, #4095, lsl #12

    brk #0
