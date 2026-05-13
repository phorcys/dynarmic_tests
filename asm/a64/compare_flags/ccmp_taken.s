/* CONFIG
{
  "RegData": {
    "X0": "0x20000000"
  }
}
*/
// CCMP when condition taken: cmp x1(=1), #0 -> N=0,Z=0,C=1,V=0

.text
.global _start
_start:
    mov x0, #0
    mov x1, #1
    cmp x0, #0      // Z=1
    ccmp x1, #0, #1, eq  // if EQ, compare x1 with 0, result: 1 > 0, C=1
    mrs x0, nzcv
    brk #0
