/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x00000000000000FF",
    "X2": "0x00000000AAAAAAA8"
  }
}
*/
// 32-bit BFM coverage.

.text
.global _start
_start:
    movn w1, #0
    mov w0, #0
    bfm w0, w1, #0, #7         // insert low 8 bits -> 0xFF

    movz w2, #0xAAAA
    movk w2, #0xAAAA, lsl #16
    movz w3, #0x5678
    movk w3, #0x1234, lsl #16
    bfm w2, w3, #0, #3         // low nibble from source -> ...A8

    brk #0
