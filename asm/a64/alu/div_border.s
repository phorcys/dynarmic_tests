/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000064",
    "X1": "0x0000000000000000",
    "X2": "0x0000000000000000",
    "X3": "0x0000000000000000",
    "X4": "0x0000000000000000",
    "X5": "0x0000000000000000",
    "X6": "0x0000000000000000",
    "X7": "0x0000000000000000"
  }
}
*/
// Test: DIV - division by zero (returns 0)
// Note: ARM64 DIV by zero returns 0, not an exception
// X0 remains 100 (0x64) since UDIV doesn't modify it

.text
.global _start
_start:
    mov x0, #100
    mov x1, #0
    udiv x2, x0, x1          // 100 / 0 = 0 (hardware behavior)
    
    mov x3, #0
    mov x4, #0
    mov x5, #0
    mov x6, #0
    mov x7, #0

    brk #0
