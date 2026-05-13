/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x000000000000002A"
  }
}
*/
// CBNZ with W register form.

.text
.global _start
_start:
    mov w0, #1
    cbnz w0, taken
    mov x0, #1
taken:
    mov x0, #42
    brk #0
