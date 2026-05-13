/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0xFFFFFFFFFFFFFFFF",
    "X1": "0x0000000000000000"
  }
}
*/

.text
.global _start
_start:
    cmp xzr, xzr
    csetm x0, eq
    csetm x1, ne
    brk #0

