/* CONFIG
{
  "Match": "All",
  "X0": "0x0000000000000000",
  "X1": "0x00000000E8C9A1A1"
}
*/
// Test: CRC32B Wd, Wn, Wm - CRC32 checksum byte
// Computes CRC32 checksum of a byte

.text
.global _start
_start:
    mov x0, #0       // CRC initial value
    mov w1, #'A'     // ASCII 'A' = 0x41
    
    // CRC32B: CRC32 of byte
    crc32b w0, w0, w1
    
    brk #0
