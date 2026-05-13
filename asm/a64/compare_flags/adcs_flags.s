/* CONFIG
{
  "RegData": {
    "X0": "0x0000000020000000"
  }
}
*/
// ADCS flags - 1 + 0xFFFFFFFFFFFFFFFF + 1(C) = 1 with C=1

.text
.global _start
_start:
    mov x0, #1
    mov x1, #0xFFFFFFFFFFFFFFFF
    cmp xzr, xzr          // C=1
    adcs x0, x0, x1       // 1 + (-1) + 1 = 1, sets flags C=1
    mrs x0, nzcv          // NZCV = 0010 = 0x20000000
    brk #0
