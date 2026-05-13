/* CONFIG
{
  "RegData": {
    "X0": "0x0000000000000000"
  }
}
*/
// CLZ high bit set

.text
.global _start
_start:
    mov x0, #0x8000000000000000
    movk x0, #0x8000, lsl #48
    clz x0, x0            // 0 leading zeros
    brk #0
