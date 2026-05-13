/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X2": "0x00000000000010FF"
  }
}
*/
// Edge case test: add_extend_64

.text
.global _start
_start:

    mov x0, #0x1000
    mov w1, #0xFF
    add x2, x0, w1, uxtb   // x2 = 0x1000 + 0xFF = 0x10FF


    brk #0
