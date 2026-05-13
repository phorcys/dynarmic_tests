/* CONFIG
{
  "RegData": {
    "X0": "0x0000000000000000"
  }
}
*/
// CCMN basic - Conditional Compare Negative

.text
.global _start
_start:
    mov x0, #-5
    mov x1, #5
    cmp x0, x0            // Z=1 (x0 == x0)
    ccmn x1, #5, #0, eq   // if EQ, compute x1 + 5 = 10, NZCV = 0 (N=0, Z=0, C=0, V=0)
    mrs x0, nzcv          // x0 = 0x0
    brk #0
