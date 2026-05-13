/* CONFIG
{
  "NZCV": "0x0000000A"
}
*/
// SBCS chain

.text
.global _start
_start:
    mov x0, #0
    mov x1, #0
    mov x2, #0
    adds x2, x1, #0            // Z=1, C=1
    sbcs x0, x0, x1            // 0 - 0 - !C = -1, N=1
    mrs x0, nzcv
    brk #0
