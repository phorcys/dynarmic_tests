/* CONFIG
{
  "RegData": {
    "X0": "0x0000000000000001"
  },
  "NZCV": "0x00000000"
}
*/
// CMP less than

.text
.global _start
_start:
    mov x0, #5
    cmp x0, #10           // 5 < 10: N=0, Z=0, C=0, V=0
    cset x0, lt           // x0 = 1 if less than
    brk #0
