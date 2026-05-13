/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000000",
    "X1": "0x00000000000000FF",
    "X2": "0x00000000000000FF",
    "X3": "0x000000000000FFFF",
    "X4": "0x000000000000FFFF",
    "X5": "0x0000000000000000",
    "X6": "0x0000000000000000",
    "X7": "0x0000000000000000"
  }
}
*/
// Test: ADD - with sign/zero extend

.text
.global _start
_start:
    mov x0, #0
    mov w1, #255             // 0xFF
    add x2, x0, w1, uxtb     // 0 + 255 (zero-extend byte) = 255
    mov w3, #0xFFFF
    add x4, x0, w3, uxth     // 0 + 65535 (zero-extend halfword) = 65535
    mov x5, #0
    mov x6, #0
    mov x7, #0

    brk #0
