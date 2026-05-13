/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000020"
  }
}
*/

.text
.global _start
_start:
    mov x0, #1
    clz x0, x0        // 1 has 63 leading zeros
    brk #0

