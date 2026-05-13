/* CONFIG
{
  "NZCV": "0x00000000"
}
*/
// CMP less than

.text
.global _start
_start:
    mov x0, #5
    cmp x0, #10                // 5 < 10: N=0, Z=0, C=0, V=0
    mrs x0, nzcv
    brk #0
