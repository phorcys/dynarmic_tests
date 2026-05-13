/* CONFIG
{
  "RegData": {
    "X0": "0xFFFFFFFFFFFF8000"
  }
}
*/
// SXTH sign extend halfword

.text
.global _start
_start:
    mov w0, #0x8000
    sxth x0, w0           // sign extend halfword: 0x8000 -> 0xFF...8000
    brk #0
