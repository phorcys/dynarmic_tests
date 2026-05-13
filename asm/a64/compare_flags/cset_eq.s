/* CONFIG
{
  "RegData": {
    "X0": "0x0000000000000001"
  }
}
*/
// CSET when EQ true

.text
.global _start
_start:
    cmp x0, x0      // Z=1
    cset x0, eq
    brk #0
