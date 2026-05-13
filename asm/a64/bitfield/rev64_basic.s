/* CONFIG
{
  "RegData": {
    "X0": "0x0201040306050807"
  }
}
*/
// REV64 reverse bytes in doubleword

.text
.global _start
_start:
    mov x0, #0
    movk x0, #0x0102, lsl #0
    movk x0, #0x0304, lsl #16
    movk x0, #0x0506, lsl #32
    movk x0, #0x0708, lsl #48
    rev x0, x0            // reverse all bytes: 0x0708_0506_0304_0102 -> 0x0201_0403_0605_0807
    brk #0
