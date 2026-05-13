/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000001",
    "X1": "0x000000000000003F",
    "X2": "0x8000000000000000",
    "X3": "0x0000000000000000",
    "X4": "0x0000000000000000",
    "X5": "0x0000000000000000",
    "X6": "0x0000000000000000",
    "X7": "0x0000000000000000"
  }
}
*/
// Test: CLZ - count leading zeros

.text
.global _start
_start:
    mov x0, #1
    clz x1, x0               // 1 has 63 leading zeros
    mov x2, #0x8000000000000000
    clz x3, x2               // high bit set, 0 leading zeros
    mov x4, #0
    mov x5, #0
    mov x6, #0
    mov x7, #0

    brk #0
