/* CONFIG
{
  "Match": "All",
  "RegData": {"X0": "0x00000000000000AA"}
}
*/
// csneg: if cond then Xn else -Xm
// Z=1, so x0 = x0 = 0xAA
.text
.global _start
_start:
    mov x0, #0xAA
    cmp xzr, xzr
    csneg x0, x0, xzr, eq
    brk #0
