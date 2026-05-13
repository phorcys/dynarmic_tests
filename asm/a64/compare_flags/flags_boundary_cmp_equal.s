/* CONFIG
{
  "NZCV": "0x00000006"
}
*/
// CMP equal

.text
.global _start
_start:
    mov x0, #10
    cmp x0, #10                // equal: Z=1, C=1
    mrs x0, nzcv
    brk #0
