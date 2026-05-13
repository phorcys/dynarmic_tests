/* CONFIG
{
  "RegData": {
    "X0": "0x0000000080000000"
  }
}
*/
// CCMP condition true

.text
.global _start
_start:
    mov x0, #5
    mov x1, #3
    cmp x0, x1           // 5 vs 3, N=0, Z=0, C=1, V=0
    ccmp x0, #10, #0, gt // if 5>3, compare x0 vs 10
    mrs x0, nzcv         // 5 < 10, so N=1
    brk #0
