/* CONFIG
{
  "RegData": {
    "X0": "0x0000000000008000"
  }
}
*/
// UXTH zero extend halfword

.text
.global _start
_start:
    mov w0, #0xFFFF8000
    uxth x0, w0           // zero extend halfword: 0x8000 -> 0x8000
    brk #0
