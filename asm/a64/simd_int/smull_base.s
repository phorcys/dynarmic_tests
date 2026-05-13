/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000007",
    "X1": "0x0000000000000008",
    "X2": "0x0000000000000038",
    "X3": "0x0000000000000000",
    "X4": "0x0000000000000000",
    "X5": "0x0000000000000000",
    "X6": "0x0000000000000000",
    "X7": "0x0000000000000000"
  }
}
*/
// Test: SMULL - signed multiply long (alias for SMADDL with Xzr)
// SMULL: Xd = Wn * Wm

.text
.global _start
_start:
    mov w0, #7
    mov w1, #8
    smull x2, w0, w1         // 7 * 8 = 56
    
    mov x3, #0
    mov x4, #0
    mov x5, #0
    mov x6, #0
    mov x7, #0

    brk #0
