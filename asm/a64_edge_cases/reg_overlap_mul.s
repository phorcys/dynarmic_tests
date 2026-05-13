/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000031"
  }
}
*/
// Edge case test: reg_overlap_mul

.text
.global _start
_start:

    mov w0, #7
    mul w0, w0, w0     // w0 = 7 * 7 = 49


    brk #0
