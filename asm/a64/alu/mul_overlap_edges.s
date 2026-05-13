/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000031",
    "X1": "0x0000000000000007",
    "X2": "0x00000000FFFFFFFE",
    "X3": "0xFFFFFFFFFFFFFFFE",
    "X4": "0x0000000000000000"
  }
}
*/
// MUL overlap and wraparound coverage for 32-bit and 64-bit forms.

.text
.global _start
_start:
    mov x0, #7
    mov x1, #7
    mul x0, x0, x1              // overlap: 7 * 7 = 49

    mov w2, #0xFFFFFFFF
    mov w3, #2
    mul w2, w2, w3              // 32-bit wrap: 0xFFFFFFFF * 2 = 0xFFFFFFFE

    mov x3, #-1
    mov x4, #2
    mul x3, x3, x4              // low 64 bits of (-1 * 2) = -2

    mov x4, #0
    brk #0
