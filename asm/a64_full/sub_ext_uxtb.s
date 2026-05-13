/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000001"
  }
}
*/

.text
.global _start
_start:
    mov x0, #0x100
    mov x1, #0xFF
    sub x0, x0, x1, uxtb  // 0x100 - 0xFF = 1
    brk #0

