/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0xFFFFFFFFFFFFFF00",
    "X1": "0x0000000000000000",
    "X2": "0x00000000000000AB",
    "X3": "0x00000000000000AB",
    "X4": "0x0000000000000000",
    "X5": "0x0000000000000000",
    "X6": "0x0000000000000000",
    "X7": "0x0000000000000000"
  }
}
*/
// Test: UXTB - zero extend byte

.text
.global _start
_start:
    mov x0, #0xFFFFFFFFFFFFFF00
    uxtb x1, w0
    // x1 = 0 (zero extended from lower byte)
    mov w2, #0xAB
    uxtb x3, w2
    // x3 = 0xAB
    mov x4, #0
    mov x5, #0
    mov x6, #0
    mov x7, #0

    brk #0
