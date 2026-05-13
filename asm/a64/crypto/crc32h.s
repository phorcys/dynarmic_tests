/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000000",
    "X1": "0x0000000000004142",
    "X2": "0x00000000C3945C81"
  }
}
*/
// Test: CRC32H - CRC32 calculate (halfword)

.arch armv8-a+crc
.text
.global _start
_start:
    mov x0, #0           // Initial CRC = 0
    mov x1, #0x4142      // halfword
    crc32h w2, w0, w1    // Calculate CRC32 of halfword

    brk #0
