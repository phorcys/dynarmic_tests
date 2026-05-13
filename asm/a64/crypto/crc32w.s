/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X2": "0x000000003B85ED6A"
  }
}
*/
// Test: CRC32W - CRC32 calculate (word)

.arch armv8-a+crc
.text
.global _start
_start:
    mov x0, #0           // Initial CRC = 0
    mov w1, #0x4142      // word value
    movk w1, #0x4344, lsl #16
    crc32w w2, w0, w1    // Calculate CRC32 of word

    brk #0
