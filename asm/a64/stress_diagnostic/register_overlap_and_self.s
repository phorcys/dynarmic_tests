/* CONFIG
{
  "RegData": {
    "X0": "0x00000000000000FF"
  }
}
*/
// AND self: identity

.text
.global _start
_start:
    mov x0, #0xFF
    and x0, x0, x0
    brk #0
