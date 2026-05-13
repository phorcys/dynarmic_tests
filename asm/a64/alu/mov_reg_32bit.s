/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0xFFFFFFFF12345678",
    "X1": "0x0000000012345678",
    "X2": "0x0000000012345678"
  }
}
*/
// MOV register 32-bit zero-extension behavior.

.text
.global _start
_start:
    movz x0, #0x5678
    movk x0, #0x1234, lsl #16
    movk x0, #0xFFFF, lsl #32
    movk x0, #0xFFFF, lsl #48

    mov w1, w0
    mov w2, w1

    brk #0
