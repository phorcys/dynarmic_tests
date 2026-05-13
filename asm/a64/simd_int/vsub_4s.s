/* CONFIG
{
  "RegData": {
    "X0": "0x0000000000000005"
  }
}
*/
// VSUB 4x32-bit

.text
.global _start
_start:
    movi v0.4s, #10
    movi v1.4s, #5
    sub v0.4s, v0.4s, v1.4s   // v0 = [5,5,5,5]
    mov w0, v0.s[0]            // 5
    brk #0
