/* CONFIG
{
  "Match": "All",
  "RegData": {"X0": "0x7800341256000000"}
}
*/
.text
.global _start
_start:
    mov x0, #0x78
    movk x0, #0x1234, lsl #16
    movk x0, #0x56, lsl #32
    // x0 = 0x0056341200000078
    rev64 x0, x0
    brk #0
