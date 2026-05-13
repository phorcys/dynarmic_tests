/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X3": "0x000000000000000A"
  }
}
*/
// Edge case test: csel_vs

.text
.global _start
_start:

    mov w0, #1
    lsl w0, w0, #31
    sub w0, w0, #1    // w0 = 0x7FFFFFFF
    adds w0, w0, #1   // overflow
    mov w1, #10
    mov w2, #20
    csel w3, w1, w2, vs   // w3 = 10 (overflow set)


    brk #0
