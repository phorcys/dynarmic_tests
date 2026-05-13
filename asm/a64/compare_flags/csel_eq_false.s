/* CONFIG
{
  "RegData": {
    "X0": "0x00000000000000C8"
  }
}
*/
// CSEL eq false

.text
.global _start
_start:
    mov x0, #1
    mov x1, #100
    mov x2, #200
    cmp x0, #0      // sets Z=0
    csel x0, x1, x2, eq
    brk #0
