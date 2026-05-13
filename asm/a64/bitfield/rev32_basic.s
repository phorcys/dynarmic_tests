/* CONFIG
{
  "RegData": {
    "X0": "0x0200000001000000"
  }
}
*/
// REV32 reverse bytes in each 32-bit word

.text
.global _start
_start:
    mov x0, #0
    movk x0, #0x0001, lsl #0
    movk x0, #0x0002, lsl #32
    rev32 x0, x0          // reverse bytes in each word
    brk #0
