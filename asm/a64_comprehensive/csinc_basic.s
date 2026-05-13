/* CONFIG
{
  "Match": "All",
  "RegData": {"X0": "0x00000000000000AA"}
}
*/
// csinc x0, x0, xzr, eq: if Z=1 then x0 else xzr+1
// Z=1, so x0 = x0 = 0xAA
.text
.global _start
_start:
    mov x0, #0xAA
    cmp xzr, xzr
    csinc x0, x0, xzr, eq
    brk #0
