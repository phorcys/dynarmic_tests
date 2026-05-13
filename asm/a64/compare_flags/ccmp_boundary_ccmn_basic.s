/* CONFIG
{
  "RegData": {
    "X0": "0x0000000000000000"
  }
}
*/
// CCMN - compare negative: cmn x0, #imm compares x0 with -imm

.text
.global _start
_start:
    mov x0, #5
    mov x1, #3
    cmp x0, x1           // 5 vs 3, N=0, Z=0, C=1, V=0
    ccmn x0, #3, #0, gt  // if gt, compare x0 with -3: 5 vs -3
    // 5 > -3, so N=0, Z=0, C=1, V=0
    mrs x0, nzcv
    brk #0
