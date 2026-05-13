/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x000000000000000A",
    "X1": "0x0000000080000000"
  }
}
*/
.text
.global _start
_start:
    mov x0, #10
    cmp x0, #5
    // NZCV = 0x20000000 (N=0, Z=0, C=1, V=0)
    ccmp x0, #15, #0, gt
    // GT = Z==0 && N==V = true
    // Compare 10 vs 15: 10 - 15 = -5
    // N=1, Z=0, C=0 (borrow), V=0
    // NZCV = 0x80000000
    mrs x1, nzcv
    brk #0
