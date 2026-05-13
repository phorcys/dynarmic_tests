/* CONFIG
{
  "RegData": {
    "X0": "0x0000000000000000"
  },
  "NZCV": "0x00000002"
}
*/
// TST nonzero

.text
.global _start
_start:
    mov x0, #0xFF
    tst x0, #0x0F         // 0xFF & 0x0F = 0x0F != 0, Z=0
    cset x0, eq           // x0 = 0 (not equal)
    brk #0
