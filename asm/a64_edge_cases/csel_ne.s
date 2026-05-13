/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X4": "0x000000000000000A"
  }
}
*/
// Edge case test: csel_ne

.text
.global _start
_start:

    mov w0, #5
    mov w1, #6
    mov w2, #10
    mov w3, #20
    cmp w0, w1
    csel w4, w2, w3, ne   // w4 = 10 (not equal)


    brk #0
