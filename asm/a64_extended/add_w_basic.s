/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000003"
  }
}
*/

.text
.global _start
_start:
    mov w0, #1
    mov w1, #2
    add w0, w0, w1
    brk #0

