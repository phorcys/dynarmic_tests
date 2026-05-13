/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X2": "0x00000000000013FC"
  }
}
*/
// Edge case test: add_extend_shift

.text
.global _start
_start:

    mov x0, #0x1000
    mov w1, #0xFF
    add x2, x0, w1, uxtb #2   // x2 = 0x1000 + (0xFF << 2) = 0x1000 + 0x3FC = 0x13FC


    brk #0
