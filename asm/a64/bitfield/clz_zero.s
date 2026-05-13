/* CONFIG
{
  "RegData": {
    "X0": "0x0000000000000040"
  }
}
*/
// CLZ zero

.text
.global _start
_start:
    mov x0, #0
    clz x0, x0            // 64 leading zeros
    brk #0
