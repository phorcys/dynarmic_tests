/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x00000000FFFFFFFF",
    "X1": "0x00000000FFFFFFFF",
    "X2": "0x0000000000000001",
    "X3": "0x00000001FFFFFFFF",
    "X4": "0x0000000000000000",
    "X5": "0x0000000000000000",
    "X6": "0x0000000000000000",
    "X7": "0x0000000000000000"
  }
}
*/
// Test: ADC - add with carry

.text
.global _start
_start:
    mov x0, #0xFFFFFFFF
    mov x1, #0xFFFFFFFF
    mov x2, #1
    cmp x2, #1               // Set C=1 (no borrow)
    adc x3, x0, x1           // 0xFFFFFFFF + 0xFFFFFFFF + C = 0x1FFFFFFFF (truncated to 0xFFFFFFFF)
    mov x4, #0
    mov x5, #0
    mov x6, #0
    mov x7, #0

    brk #0
