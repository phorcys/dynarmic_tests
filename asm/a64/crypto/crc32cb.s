/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X2": "0x00000000B3109EBF"
  }
}
*/
// Test: CRC32CB - CRC32C calculate (Castagnoli, byte)
// CRC32C uses different polynomial (iSCSI polynomial)

.arch armv8-a+crc
.text
.global _start
_start:
    mov w0, #0           // Initial CRC = 0
    mov w1, #0x41        // 'A' character
    crc32cb w2, w0, w1   // Calculate CRC32C of 'A'

    brk #0
