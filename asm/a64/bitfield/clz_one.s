/* CONFIG
{
  "RegData": {
    "X0": "0x000000000000003F"
  }
}
*/
// CLZ one bit

.text
.global _start
_start:
    mov x0, #1
    clz x0, x0            // 63 leading zeros
    brk #0
