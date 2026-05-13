/* CONFIG
{
  "RegData": {
    "X0": "0x0000000000000006"
  }
}
*/
// ADDS 64-bit carry: -1 + 1 = 0 with carry, Z=1,C=1

.text
.global _start
_start:
    mov x0, #-1
    adds x0, x0, #1            // carry out: C=1, Z=1 -> NZCV=0x60000000
    mrs x1, nzcv
    lsr x0, x1, #28            // 0x6
    brk #0
