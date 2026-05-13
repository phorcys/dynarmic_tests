/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000032",
    "X1": "0x0000000000000032",
    "X2": "0x0000000000000000",
    "X3": "0xFFFFFFFFFFFFFFFF",
    "X4": "0x0000000000000000",
    "X5": "0x0000000000000000",
    "X6": "0x0000000000000000",
    "X7": "0x0000000000000000"
  }
}
*/
// Test: CMN - compare negative (add and set flags)

.text
.global _start
_start:
    mov x0, #50
    mov x1, #50
    cmn x0, x1               // 50 + 50 = 100, flags set
    mov x2, #0
    mov x3, #-1
    cmn x2, x3               // 0 + (-1) = -1, N=1
    mov x4, #0
    mov x5, #0
    mov x6, #0
    mov x7, #0

    brk #0
