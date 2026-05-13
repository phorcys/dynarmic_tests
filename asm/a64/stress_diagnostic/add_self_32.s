/* CONFIG
{
  "RegData": {
    "X0": "0x0000000000000014"
  }
}
*/
// ADD self 32-bit

.text
.global _start
_start:
    mov w0, #10
    add w0, w0, w0        // 20 (32-bit)
    brk #0
