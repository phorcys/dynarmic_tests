/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000001"
  }
}
*/

.text
.global _start
_start:
    mov w0, #0x80000000
    lsr w0, w0, #31
    brk #0

