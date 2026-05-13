/* CONFIG
{
  "RegData": {
    "X0": "0x0000000080000000"
  }
}
*/
// SBCS flags

.text
.global _start
_start:
    mov x0, #0
    mov x1, #1
    msr nzcv, xzr         // C=0
    sbcs x0, x0, x1       // 0 - 1 - 1 = -2, N=1
    mrs x0, nzcv
    brk #0
