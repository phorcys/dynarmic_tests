/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x00000000FFFFFFFF",
    "X1": "0x0000000000000000",
    "X2": "0x0000000000000000",
    "X3": "0x00000000FFFFFFFF",
    "X4": "0x000000000000000B",
    "X5": "0xFFFFFFFFFFFFFFFF",
    "X6": "0x0000000000000000",
    "X7": "0x0000000000000000"
  }
}
*/
// ADC result-only coverage for 32-bit wraparound and overlap cases.

.text
.global _start
_start:
    mov w0, #0xFFFFFFFF
    mov w1, #0
    mov x8, #0

    cmp xzr, xzr
    adc w2, w0, w1              // 0xFFFFFFFF + 0 + 1 = 0

    cmp x8, #1
    adc w3, w0, w1              // 0xFFFFFFFF + 0 + 0 = 0xFFFFFFFF

    mov w4, #5
    cmp xzr, xzr
    adc w4, w4, w4              // 5 + 5 + 1 = 11

    movn x5, #0
    mov x6, #0
    cmp xzr, xzr
    adc x7, x5, x6              // -1 + 0 + 1 = 0

    brk #0
