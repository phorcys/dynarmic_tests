/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000008"
  }
}
*/
// Test: UMADDL Xd, Wn, Wm, Xa - Unsigned Multiply-Add Long
// Xd = Xa + (unsigned)Wn * (unsigned)Wm

.text
.global _start
_start:
    // 2 + 3 * 2 = 8 (long multiplication)
    mov w1, #3       // multiplicand (32-bit)
    mov w2, #2       // multiplier (32-bit)
    mov x3, #2       // accumulator (64-bit)
    
    umaddl x0, w1, w2, x3   // X0 = 2 + 3 * 2 = 8

    brk #0
