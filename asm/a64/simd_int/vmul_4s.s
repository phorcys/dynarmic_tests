/* CONFIG
{
  "RegData": {
    "X0": "0x0000000000000006"
  }
}
*/
// VMUL 4x32-bit

.text
.global _start
_start:
    movi v0.4s, #2
    movi v1.4s, #3
    mul v0.4s, v0.4s, v1.4s   // v0 = [6,6,6,6]
    mov w0, v0.s[0]            // 6
    brk #0
