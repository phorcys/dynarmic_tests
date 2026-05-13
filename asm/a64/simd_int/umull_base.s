/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000009",
    "X1": "0x000000000000000A",
    "X2": "0x000000000000005A",
    "X3": "0x0000000000000000",
    "X4": "0x0000000000000000",
    "X5": "0x0000000000000000",
    "X6": "0x0000000000000000",
    "X7": "0x0000000000000000"
  }
}
*/
// Test: UMULL - unsigned multiply long (alias for UMADDL with Xzr)
// UMULL: Xd = Wn * Wm

.text
.global _start
_start:
    mov w0, #9
    mov w1, #10
    umull x2, w0, w1         // 9 * 10 = 90
    
    mov x3, #0
    mov x4, #0
    mov x5, #0
    mov x6, #0
    mov x7, #0

    brk #0
