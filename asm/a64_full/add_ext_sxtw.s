/* CONFIG
{
  "Match": "All",
  "RegData": {"X0": "0x0000000000000080"}
}
*/
.text
.global _start
_start:
    mov x0, #0
    mov x1, #0x80
    add x0, x0, x1, sxtw  // 0x80 is positive in 32-bit context
    brk #0
