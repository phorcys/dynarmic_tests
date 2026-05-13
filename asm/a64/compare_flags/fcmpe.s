/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000001"
  }
}
*/
// Test: FCMPE - Floating-point Compare (with exceptions)

.text
.global _start
_start:
    // Load 1.0 into S0
    movz w8, #0x0000
    movk w8, #0x3F80, lsl #16
    fmov s0, w8
    
    // Load 1.0 into S1
    movz w9, #0x0000
    movk w9, #0x3F80, lsl #16
    fmov s1, w9
    
    // FCMPE: compare S0 with S1 (with exceptions)
    fcmpe s0, s1
    
    // If equal, set x0 = 1
    cset x0, eq

    brk #0
