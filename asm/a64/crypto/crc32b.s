/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000001DB7106"
  }
}
*/
// Test: CRC32B - CRC32 checksum (byte)

.text
.global _start
_start:
    mov x0, #0       // initial CRC
    mov w1, #0x41    // 'A'
    
    // CRC32B: compute CRC32 of byte
    crc32b w0, w0, w1

    brk #0
