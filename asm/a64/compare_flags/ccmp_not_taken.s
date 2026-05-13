/* CONFIG
{
  "RegData": {
    "X0": "0x60000000"
  }
}
*/
// CCMP when condition taken: cmp x2(=2), #2 -> N=0,Z=1,C=1,V=0

.text
.global _start
_start:
    mov x0, #0
    mov x1, #1
    mov x2, #2
    cmp x0, #1      // Z=0 (NE)
    ccmp x2, #2, #2, ne  // if NE, compare x2 with 2 -> equal, Z=1, C=1
    mrs x0, nzcv
    brk #0
