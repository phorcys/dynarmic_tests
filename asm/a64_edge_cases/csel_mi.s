/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X3": "0x000000000000000A"
  }
}
*/
// Edge case test: csel_mi

.text
.global _start
_start:

    mov w0, #1
    lsl w0, w0, #31   // w0 = 0x80000000 (negative)
    mov w1, #10
    mov w2, #20
    cmp w0, #0
    csel w3, w1, w2, mi   // w3 = 10 (negative)


    brk #0
