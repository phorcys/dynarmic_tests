/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X2": "0x0000000000000F80",
    "X3": "0x0000000000001080",
    "X5": "0x00000000FFFF8FFF",
    "X7": "0x0000000000000E00"
  }
}
*/
// SUB extended-register forms in 32-bit destination mode.

.text
.global _start
_start:
    mov w0, #0x1000
    mov w1, #0x80
    sub w2, w0, w1, uxtb        // 0x1000 - 0x80
    sub w3, w0, w1, sxtb        // 0x1000 - (-128)

    mov w4, #0x8001
    sub w5, w0, w4, uxth        // 0x1000 - 0x8001
    sub w7, w0, w1, uxtb #2     // 0x1000 - (0x80 << 2)

    brk #0
