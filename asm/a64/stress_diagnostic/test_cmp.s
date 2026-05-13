/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x000000000000000A",
    "X1": "0x0000000020000000"
  }
}
*/
.text
.global _start
_start:
    mov x0, #10
    cmp x0, #5
    // 10 > 5: N=0, Z=0, C=1, V=0
    // NZCV = 0x20000000
    mrs x1, nzcv
    brk #0
