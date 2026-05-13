/* CONFIG
{
  "RegData": {
    "X0": "0x0000000040000000"
  }
}
*/
// ANDS zero result

.text
.global _start
_start:
    mov x0, #0x0F
    mov x1, #0xF0
    ands x0, x0, x1       // 0x0F & 0xF0 = 0, Z=1
    mrs x0, nzcv          // NZCV = 0x40000000 (Z=1)
    brk #0
