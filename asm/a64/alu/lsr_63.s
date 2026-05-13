/* CONFIG
{
  "RegData": {
    "X0": "0x0000000000000001"
  }
}
*/
// LSR by 63

.text
.global _start
_start:
    mov x0, #-1
    lsr x0, x0, #63       // 0xFFFFFFFFFFFFFFFF >> 63 = 1
    brk #0
