/* CONFIG
{
  "Match": "All",
  "RegData": {"X0": "0x0000000000000001", "X1": "0x0000000000000000"}
}
*/
.text
.global _start
_start:
    cmp xzr, xzr
    cset x0, eq
    cset x1, ne
    brk #0
