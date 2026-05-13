/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000006"
  }
}
*/
// Test: UMULL Xd, Wn, Wm - Unsigned Multiply Long
// Unsigned 32x32 -> 64 multiplication

.text
.global _start
_start:
    mov w0, #2
    mov w1, #3
    
    // UMULL: X0 = W0 * W1 (unsigned, extended to 64-bit)
    umull x0, w0, w1     // X0 = 6

    brk #0
