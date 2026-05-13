/* CONFIG
{
  "RegData": {
    "X0": "0x0000000000000001"
  },
  "NZCV": "0x00000006"
}
*/
// CMP equal

.text
.global _start
_start:
    mov x0, #10
    cmp x0, #10           // equal: Z=1, C=1
    cset x0, eq           // x0 = 1 if equal
    brk #0
