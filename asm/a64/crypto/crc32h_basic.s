/* CONFIG
{
  "RegData": {
    "X0": "0x00000000C3945C81"
  }
}
*/
// CRC32H - compute CRC-32 for halfword 0x4142

.text
.global _start
_start:
    mov w0, #0
    mov w1, #0x4142
    crc32h w0, w0, w1
    brk #0
