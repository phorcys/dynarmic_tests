/* CONFIG
{
  "RegData": {
    "X0": "0x0000000000000001"
  },
  "NZCV": "0x00000000"
}
*/
// TST zero

.text
.global _start
_start:
    mov x0, #0x0F
    tst x0, #0xF0         // 0x0F & 0xF0 = 0, Z=1
    cset x0, eq           // x0 = 1
    brk #0
