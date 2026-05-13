/* CONFIG
{
  "RegData": {
    "X0": "0x0000000001DB7106"
  }
}
*/
// CRC32B - compute CRC-32 for byte 'A'

.text
.global _start
_start:
    mov w0, #0
    mov w1, #'A'
    crc32b w0, w0, w1
    brk #0
