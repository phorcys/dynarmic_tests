/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X2": "0x0000000000001080",
    "X3": "0x0000000000000F80",
    "X5": "0x0000000000009001",
    "X7": "0x0000000000001200"
  }
}
*/
// ADD extended-register forms in 32-bit destination mode.

.text
.global _start
_start:
    mov w0, #0x1000
    mov w1, #0x80
    add w2, w0, w1, uxtb        // 0x1000 + 0x80
    add w3, w0, w1, sxtb        // 0x1000 + (-128)

    mov w4, #0x8001
    add w5, w0, w4, uxth        // 0x1000 + 0x8001
    add w7, w0, w1, uxtb #2     // 0x1000 + (0x80 << 2)

    brk #0
