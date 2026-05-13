/* CONFIG
{
  "Match": "All",
  "RegData": {"X1": "0x000000000000FF00"}
}
*/
// BFI Xd, Xn, #lsb, #width
// Insert width bits from Xn[width-1:0] into Xd[lsb+width-1:lsb]
// bfi x1, x0, #8, #8: insert x0[7:0] into x1[15:8]
// x0 = 0xFF, x0[7:0] = 0xFF
// x1 = 0, result x1[15:8] = 0xFF -> 0xFF00
.text
.global _start
_start:
    mov x0, #0xFF
    mov x1, #0
    bfi x1, x0, #8, #8
    brk #0
