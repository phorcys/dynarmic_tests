/* CONFIG
{
  "Match": "All",
  "RegData": {"X0": "0x0000780056341200"}
}
*/
.text
.global _start
_start:
    mov x0, #0x12
    movk x0, #0x3456, lsl #16
    movk x0, #0x78, lsl #32
    // x0 = 0x0000007800345612
    rev16 x0, x0
    brk #0
