/* CONFIG
{
  "RegData": {
    "X0": "0x000000000000000A"
  }
}
*/
// CSINC eq

.text
.global _start
_start:
    mov x0, #10
    mov x1, #20
    cmp x0, x0          // equal, Z=1
    csinc x2, x0, x1, eq  // if eq, select x0; else x1+1
    mov x0, x2
    brk #0
