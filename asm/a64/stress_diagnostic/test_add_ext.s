/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000010",
    "X1": "0x0000000000000080",
    "X2": "0xFFFFFFFFFFFFFF90"
  }
}
*/
// Test: ADD X2, X0, W1, SXTB
// X0 = 16, W1 = 0x80 (byte = -128 when sign extended)
// X2 = 16 + (-128) = -112 = 0xFFFFFFFFFFFFFF90

.text
.global _start
_start:
    mov x0, #16
    mov x1, #0x80
    add x2, x0, w1, sxtb
    brk #0
