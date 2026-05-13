/* CONFIG
{
  "RegData": {
    "X0": "0x000000003B85ED6A"
  }
}
*/
// CRC32W - compute CRC-32 for word 0x43444142

.text
.global _start
_start:
    mov w0, #0
    mov w1, #0x4142
    movk w1, #0x4344, lsl #16
    crc32w w0, w0, w1
    brk #0
