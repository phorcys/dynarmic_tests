/* CONFIG
{
  "NZCV": "0x00000002"
}
*/
// CMP greater than

.text
.global _start
_start:
    mov x0, #10
    cmp x0, #5                 // 10 > 5: N=0, Z=0, C=1, V=0
    mrs x0, nzcv
    brk #0
