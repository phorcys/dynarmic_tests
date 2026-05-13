/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000001000",
    "X1": "0x0000000000000080",
    "X2": "0x0000000000001080",
    "X3": "0x0000000000000F80",
    "X4": "0x0000000080000001",
    "X5": "0x0000000080001001",
    "X6": "0xFFFFFFFF80001001",
    "X7": "0x0000000000001200"
  }
}
*/
// ADD with extend variants that are not covered by the basic tests.

.text
.global _start
_start:
    mov x0, #0x1000
    mov w1, #0x80
    add x2, x0, w1, uxtb        // 0x1000 + 0x80
    add x3, x0, w1, sxtb        // 0x1000 + (-128)

    mov w4, #1
    movk w4, #0x8000, lsl #16   // w4 = 0x80000001
    add x5, x0, w4, uxtw        // 0x1000 + 0x80000001
    add x6, x0, w4, sxtw        // 0x1000 + signext(0x80000001)
    add x7, x0, w1, uxtb #2     // 0x1000 + (0x80 << 2)

    brk #0
