/* CONFIG
{
  "RegData": {
    "X0": "0x00000000B3109EBF"
  }
}
*/
// CRC32CB - compute CRC-32C for byte 'A'

.text
.global _start
_start:
    mov w0, #0
    mov w1, #'A'
    crc32cb w0, w0, w1
    brk #0
