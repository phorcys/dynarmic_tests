/* CONFIG
{
  "RegData": {
    "X0": "0x0000000000000000"
  }
}
*/
// TST basic - 0xF & 0xF = 0xF, Z=0, NZCV = 0

.text
.global _start
_start:
    mov x0, #0xF
    tst x0, #0xF          // 0xF & 0xF = 0xF, Z=0
    mrs x0, nzcv
    brk #0
