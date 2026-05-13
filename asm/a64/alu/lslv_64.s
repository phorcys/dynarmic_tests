/* CONFIG
{
  "RegData": {
    "X0": "0x0000000000000001"
  }
}
*/
// LSLV by 64 (mod 64 = 0)

.text
.global _start
_start:
    mov x0, #1
    mov x1, #64
    lslv x0, x0, x1       // shift by 64 mod 64 = 0
    brk #0
