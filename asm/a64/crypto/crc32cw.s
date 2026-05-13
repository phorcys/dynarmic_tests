/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X2": "0x000000007AAEBBC2"
  }
}
*/
// Test: CRC32CW - CRC32C word

.text
.global _start
_start:
    mov x0, #0
    mov w1, #0x1234
    crc32cw w2, w0, w1

    brk #0
