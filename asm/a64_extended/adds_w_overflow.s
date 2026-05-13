/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000010000000"
  }
}
*/

.text
.global _start
_start:
    mov w0, #0x7FFFFFFF
    adds w0, w0, #1
    mrs x0, nzcv  // V=1, N=0
    brk #0

