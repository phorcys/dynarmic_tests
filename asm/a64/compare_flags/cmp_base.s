/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000064",
    "X1": "0x0000000000000032",
    "X2": "0x000000000000002A",
    "X3": "0x000000000000002A",
    "X4": "0x0000000000000000",
    "X5": "0x0000000000000000",
    "X6": "0x0000000000000000",
    "X7": "0x0000000000000000"
  }
}
*/
// Test: CMP - compare (subtract and set flags)

.text
.global _start
_start:
    mov x0, #100
    mov x1, #50
    cmp x0, x1               // 100 - 50 = 50, flags set
    mov x2, #42
    mov x3, #42
    cmp x2, x3               // 42 - 42 = 0, Z=1
    mov x4, #0
    mov x5, #0
    mov x6, #0
    mov x7, #0

    brk #0
