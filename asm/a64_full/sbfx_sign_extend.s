/* CONFIG
{
  "Match": "All",
  "RegData": {"X0": "0xFFFFFFFFFFFFFFFF"}
}
*/
.text
.global _start
_start:
    mov x0, #0x78       // 0b01111000
    sbfx x0, x0, #3, #4  // extract bits [6:3] = 0b1111 = 15, sign bit = 1
    brk #0
