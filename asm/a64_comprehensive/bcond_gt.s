/* CONFIG
{
  "Match": "All",
  "RegData": {"X0": "0x0000000000000x0"}
}
*/
.text
.global _start
_start:
    mov x0, #0
    cmp xzr, xzr       // Z=1, C=1, N=0, V=0
    b.gt 1f
    mov x0, #0
    b 2f
1:
    mov x0, #1
2:
    brk #0
