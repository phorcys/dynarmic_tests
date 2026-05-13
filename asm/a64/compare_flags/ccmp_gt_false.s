/* CONFIG
{
  "RegData": {
    "X0": "0x0000000000000000"
  }
}
*/
// CCMP condition false - uses nzcv parameter (0) when condition fails

.text
.global _start
_start:
    mov x0, #5
    mov x1, #10
    cmp x0, x1           // 5 vs 10, N=1
    ccmp x0, #3, #0, gt  // condition false (5 not > 10), use nzcv=0
    mrs x0, nzcv
    brk #0
