/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000005",
    "X1": "0x0000000000000006",
    "X2": "0x0000000000000064",
    "X3": "0x0000000000000082",
    "X4": "0x0000000000000000",
    "X5": "0x0000000000000000",
    "X6": "0x0000000000000000",
    "X7": "0x0000000000000000"
  }
}
*/
// Test: UMADDL - unsigned multiply add long
// UMADDL: Xd = Wa * Wb + Xc

.text
.global _start
_start:
    mov w0, #5               // 32-bit unsigned
    mov w1, #6               // 32-bit unsigned
    mov x2, #100             // 64-bit addend
    umaddl x3, w0, w1, x2    // 5 * 6 + 100 = 130
    
    mov x4, #0
    mov x5, #0
    mov x6, #0
    mov x7, #0

    brk #0
