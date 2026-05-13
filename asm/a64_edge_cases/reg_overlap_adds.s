/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000096"
  }
}
*/
// Edge case test: reg_overlap_adds

.text
.global _start
_start:

    mov w0, #100
    adds w0, w0, #50   // result and source are same register


    brk #0
