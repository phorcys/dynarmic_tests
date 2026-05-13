/* CONFIG
{
  "RegData": {
    "X0": "0x0000000000000006"
  }
}
*/
// MUL 32-bit

.text
.global _start
_start:
    mov w0, #2
    mov w1, #3
    mul w0, w0, w1        // 2 * 3 = 6 (32-bit)
    brk #0
