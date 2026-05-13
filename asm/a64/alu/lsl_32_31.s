/* CONFIG
{
  "RegData": {
    "X0": "0x0000000080000000"
  }
}
*/
// LSL 32-bit by 31

.text
.global _start
_start:
    mov w0, #1
    lsl w0, w0, #31       // 1 << 31 = 0x80000000 (32-bit)
    brk #0
