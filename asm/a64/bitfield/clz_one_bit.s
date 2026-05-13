/* CONFIG
{
  "RegData": {
    "X0": "0x000000000000003F"
  }
}
*/
// CLZ with single bit

.text
.global _start
_start:
    mov x0, #1
    clz x0, x0            // 63 leading zeros in 64-bit
    brk #0
