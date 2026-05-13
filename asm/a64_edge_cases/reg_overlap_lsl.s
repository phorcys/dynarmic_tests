/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000010"
  }
}
*/
// Edge case test: reg_overlap_lsl

.text
.global _start
_start:

    mov w0, #1
    mov w1, #4
    lsl w0, w0, w1     // w0 = 1 << 4 = 16


    brk #0
