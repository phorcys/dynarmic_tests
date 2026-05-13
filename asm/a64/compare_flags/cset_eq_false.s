/* CONFIG
{
  "RegData": {
    "X0": "0x0000000000000000"
  }
}
*/
// CSET when EQ false

.text
.global _start
_start:
    mov x1, #1
    cmp x1, #0      // Z=0
    cset x0, eq
    brk #0
