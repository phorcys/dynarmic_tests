/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000002"
  }
}
*/
// Test: FDIV - Floating-point Divide

.text
.global _start
_start:
    // Load 6.0 into S0
    movz w8, #0x0000
    movk w8, #0x40C0, lsl #16
    fmov s0, w8
    
    // Load 3.0 into S1
    movz w9, #0x0000
    movk w9, #0x4040, lsl #16
    fmov s1, w9
    
    // FDIV: 6.0 / 3.0 = 2.0
    fdiv s0, s0, s1
    
    // Convert to integer
    fcvtzs x0, s0

    brk #0
