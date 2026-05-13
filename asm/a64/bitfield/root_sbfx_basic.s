/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000080000000",
    "X1": "0xFFFFFFFFFFFFFFFF",
    "X2": "0x000000007FFFFFFF",
    "X3": "0xFFFFFFFFFFFFFFFF",
    "X4": "0x0000000000000000",
    "X5": "0x0000000000000000",
    "X6": "0x0000000000000000",
    "X7": "0x0000000000000000"
  }
}
*/
// Test: SBFX - signed bit field extract

.text
.global _start
_start:
    mov x0, #0x80000000
    sbfx x1, x0, #31, #1
    // Extract bit 31 (sign bit), sign extend
    // x1 = -1 (sign extended)
    mov x2, #0x7FFFFFFF
    sbfx x3, x2, #0, #8
    // Extract bits [7:0] = 0xFF, sign extend
    // x3 = -1 (sign extended because bit 7 = 1)
    mov x4, #0
    mov x5, #0
    mov x6, #0
    mov x7, #0

    brk #0
