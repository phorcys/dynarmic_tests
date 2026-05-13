/* CONFIG
{
  "Match": "All",
  "X0": "0x0000000000000000",
  "X1": "0x0000000048D7A1A1"
}
*/
// Test: CRC32CB Wd, Wn, Wm - CRC32C checksum byte
// Computes CRC32C checksum of a byte

.text
.global _start
_start:
    mov x0, #0       // CRC initial value
    mov w1, #'A'     // ASCII 'A' = 0x41
    
    // CRC32CB: CRC32C of byte
    crc32cb w0, w0, w1
    
    brk #0
