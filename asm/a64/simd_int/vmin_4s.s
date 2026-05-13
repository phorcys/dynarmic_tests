/* CONFIG
{
  "RegData": {
    "X0": "0x0000000000000003"
  }
}
*/
// VMIN 4x32-bit

.text
.global _start
_start:
    movi v0.4s, #3
    movi v1.4s, #5
    umin v0.4s, v0.4s, v1.4s   // min(3, 5) = 3
    mov w0, v0.s[0]
    brk #0
