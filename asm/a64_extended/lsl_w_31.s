/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000080000000"
  }
}
*/

.text
.global _start
_start:
    mov w0, #1
    lsl w0, w0, #31
    brk #0

