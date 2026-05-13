/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x00000000000000FF",
    "X1": "0x00000000000000FF",
    "X2": "0x00000000000000FF",
    "X3": "0x0000000000000000",
    "X4": "0x0000000000000000",
    "X5": "0x0000000000000000",
    "X6": "0x0000000000000000",
    "X7": "0x0000000000000000"
  }
}
*/
// Test: ANDS - AND and set flags

.text
.global _start
_start:
    mov x0, #0xFF
    mov x1, #0xFF
    ands x2, x0, x1          // 0xFF & 0xFF = 0xFF, Z=0
    mov x3, #0
    mov x4, #0
    ands x5, x3, x4          // 0 & 0 = 0, Z=1
    mov x6, #0
    mov x7, #0

    brk #0
