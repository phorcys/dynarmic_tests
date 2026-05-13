/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X2": "0x000000006B426855"
  }
}
*/
// Test: CRC32CH - CRC32C halfword

.text
.global _start
_start:
    mov x0, #0
    mov w1, #0x4142
    crc32ch w2, w0, w1

    brk #0
