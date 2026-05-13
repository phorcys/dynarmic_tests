/* CONFIG
{
  "RegData": {
    "X0": "0x0000000000000064"
  }
}
*/
// CSEL eq true: Z==1

.text
.global _start
_start:
    mov x1, #100
    mov x2, #200
    cmp x0, x0      // sets Z=1
    csel x0, x1, x2, eq
    brk #0
