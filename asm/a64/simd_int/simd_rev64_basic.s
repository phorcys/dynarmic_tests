/* CONFIG
{
  "RegData": {
    "X0": "0x0000000000000001"
  }
}
*/
// REV64 vector - reverses bytes in each 64-bit element

.text
.global _start
_start:
    movi v0.4s, #1
    rev64 v2.4s, v0.4s
    // v0.4s = {1, 1, 1, 1} as 32-bit words
    // REV64 reverses bytes in each 64-bit half
    // Result still has same 32-bit value 1 in each lane
    mov w0, v2.s[0]
    brk #0
