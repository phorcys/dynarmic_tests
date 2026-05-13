/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X2": "0x00000000E7D842A4"
  }
}
*/
// Test: CRC32CX - CRC32C doubleword

.text
.global _start
_start:
    mov x0, #0
    mov x1, #0x1234
    movk x1, #0x5678, lsl #16
    crc32cx w2, w0, x1

    brk #0
