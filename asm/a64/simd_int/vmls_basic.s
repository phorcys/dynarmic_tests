/* CONFIG
{
  "RegData": {
    "X0": "0x0000000100000001"
  }
}
*/
// VMLS basic

.text
.global _start
_start:
    movi v0.4s, #2
    movi v1.4s, #2
    movi v2.4s, #5
    mls v2.4s, v0.4s, v1.4s  // v2 -= v0 * v1 = 5 - 2*2 = 1
    mov x0, v2.d[0]
    brk #0
