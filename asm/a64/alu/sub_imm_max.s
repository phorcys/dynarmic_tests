/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X1": "0x0000000000000001",
    "X3": "0x0000000000000001",
    "X5": "0x0000000000000001",
    "X7": "0x0000000000000001"
  }
}
*/
// SUB immediate maximum encodings in 64-bit and 32-bit forms.

.text
.global _start
_start:
    mov x0, #0
    add x0, x0, #4095
    sub x1, x0, #4094

    mov x2, #1
    add x2, x2, #4095, lsl #12
    sub x3, x2, #4095, lsl #12

    mov w4, #0
    add w4, w4, #4095
    sub w5, w4, #4094

    mov w6, #1
    add w6, w6, #4095, lsl #12
    sub w7, w6, #4095, lsl #12

    brk #0
