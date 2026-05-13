/* CONFIG
{
  "Match": "All",
  "RegData": {"X0": "0x0000000000000007"}
}
*/
.text
.global _start
_start:
    mov w0, #1
    mov w1, #2
    mov w2, #3
    madd w0, w1, w2, w0
    brk #0
