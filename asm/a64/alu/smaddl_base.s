/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000003",
    "X1": "0x0000000000000004",
    "X2": "0x0000000000000010",
    "X3": "0x000000000000001C",
    "X4": "0x0000000000000000",
    "X5": "0x0000000000000000",
    "X6": "0x0000000000000000",
    "X7": "0x0000000000000000"
  }
}
*/
// Test: SMADDL - signed multiply add long
// SMADDL: Xd = Wa * Wb + Xc

.text
.global _start
_start:
    mov w0, #3               // 32-bit signed
    mov w1, #4               // 32-bit signed
    mov x2, #16              // 64-bit addend
    smaddl x3, w0, w1, x2    // 3 * 4 + 16 = 28
    
    mov x4, #0
    mov x5, #0
    mov x6, #0
    mov x7, #0

    brk #0
