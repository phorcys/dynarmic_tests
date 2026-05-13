/* CONFIG
{
  "Match": "All",
  "RegData": {"X0": "0x7800000012005634"}
}
*/
.text
.global _start
_start:
    mov x0, #0x12
    movk x0, #0x3456, lsl #16
    movk x0, #0x78, lsl #32
    // x0 = 0x00000078_00345612
    rev32 x0, x0
    // REV32 reverses bytes in each 32-bit word
    // [31:0] 0x00345612 -> 0x12563400
    // [63:32] 0x00000078 -> 0x78000000
    // Result: 0x78000000_12563400
    brk #0
