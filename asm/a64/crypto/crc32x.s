/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000000",
    "X1": "0x00000000CCAA009E"
  }
}
*/
// Test: CRC32X Wd, Wn, Xm - CRC32 checksum
// CRC32 single byte calculation

.text
.global _start
_start:
    // CRC32 of byte 0
    mov w0, #0
    mov x1, #0
    crc32x w0, w0, x1    // CRC32(0, 0)
    
    // CRC32 of byte 1
    mov w1, #0
    mov x2, #1
    crc32x w1, w1, x2    // CRC32(0, 1)

    brk #0
