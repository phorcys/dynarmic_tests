/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x000000000000000C"
  }
}
*/

.text
.global _start
_start:
    fmov s0, #3.0
    fmov s1, #4.0
    fmul s0, s0, s1
    fcvtzs w0, s0
    brk #0
