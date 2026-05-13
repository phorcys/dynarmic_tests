/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x000000000000002A"
  }
}
*/
// TBNZ on the top bit of a W register.

.text
.global _start
_start:
    mov w0, #1
    lsl w0, w0, #31
    tbnz w0, #31, taken
    mov x0, #1
taken:
    mov x0, #42
    brk #0
