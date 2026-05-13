/* CONFIG
{
  "NZCV": "0x00000008"
}
*/
// CMP signed less

.text
.global _start
_start:
    mov x0, #-5
    mov x1, #5
    cmp x0, x1                 // -5 < 5: N=1, Z=0, C=0, V=0
    mrs x0, nzcv
    brk #0
