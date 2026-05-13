/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X2": "0x0000000000000000",
    "X4": "0x8000000000000001",
    "X6": "0x0000000000000001",
    "X7": "0x000000000000000B"
  }
}
*/
// ADC 64-bit boundary coverage including wraparound and overlap.

.text
.global _start
_start:
    movn x0, #0
    mov x1, #0
    cmp xzr, xzr
    adc x2, x0, x1              // -1 + 0 + 1 = 0

    movn x3, #0x8000, lsl #48   // 0x7FFFFFFFFFFFFFFF
    mov x4, #1
    cmp xzr, xzr
    adc x4, x3, x4              // max + 1 + carry-in = 0x8000...0001

    mov x5, #0
    mov x6, #1
    cmp x5, #1
    adc x6, x6, xzr             // carry clear: 1 + 0 + 0 = 1

    mov x7, #5
    cmp xzr, xzr
    adc x7, x7, x7              // overlap: 5 + 5 + 1 = 11

    brk #0
