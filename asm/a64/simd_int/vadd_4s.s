/* CONFIG
{
  "RegData": {
    "X0": "0x0000000000000003"
  }
}
*/
// VADD 4x32-bit

.text
.global _start
_start:
    movi v0.4s, #1
    movi v1.4s, #2
    add v0.4s, v0.4s, v1.4s   // v0 = [3,3,3,3]
    mov w0, v0.s[0]            // extract first element: 3
    brk #0
