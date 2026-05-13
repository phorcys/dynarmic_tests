/* CONFIG
{
  "NZCV": "0x00000002"
}
*/
// ADCS carry chain

.text
.global _start
_start:
    mov x0, #-1
    mov x1, #0
    mov x2, #0
    adds x2, x1, #0            // clear flags, Z=1
    adcs x0, x0, x0            // -1 + -1 + C=1 = -1 with carry
    mrs x0, nzcv
    brk #0
