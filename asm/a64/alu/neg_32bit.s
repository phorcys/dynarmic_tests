/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000001",
    "X1": "0x00000000FFFFFFFF",
    "X2": "0x0000000000000000",
    "X3": "0x0000000000000000",
    "X4": "0x0000000080000000",
    "X5": "0x0000000080000000",
    "X6": "0x00000000FFFFFFFF",
    "X7": "0x0000000000000001"
  }
}
*/
// NEG Wd, Wm edge cases, including INT_MIN wrap and negative source input.

.text
.global _start
_start:
    mov w0, #1
    neg w1, w0                  // -1

    mov w2, #0
    neg w3, w2                  // 0

    mov w4, #0x80000000
    neg w5, w4                  // INT_MIN stays INT_MIN in 32-bit two's complement

    mov w6, #0xFFFFFFFF
    neg w7, w6                  // -(-1) = 1

    brk #0
