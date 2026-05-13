/* CONFIG
{
  "RegData": {
    "X0": "0xFFFFFFFFFFFFFFFF"
  }
}
*/
// EON self: all ones

.text
.global _start
_start:
    mov x0, #0xFF
    eon x0, x0, x0
    brk #0
