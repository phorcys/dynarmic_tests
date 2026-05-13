/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X2": "0x0000000000000000"
  }
}
*/
// Edge case test: sdiv_zero

.text
.global _start
_start:

    mov w0, #123
    mov w1, #0
    sdiv w2, w0, w1   // division by zero returns 0


    brk #0
