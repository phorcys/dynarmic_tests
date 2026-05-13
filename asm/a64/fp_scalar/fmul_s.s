/* CONFIG
{
  "Match": "All",
  "RegData": {
    "S0": "0x0000000040000000",
    "S1": "0x0000000040400000",
    "S2": "0x0000000040C00000"
  }
}
*/
// Test: FMUL Sd, Sn, Sm - scalar floating-point multiply

.text
.global _start
_start:
    // Load S0 with 2.0
    mov w0, #0x0000
    movk w0, #0x4000, lsl #16
    fmov s0, w0
    
    // Load S1 with 3.0
    mov w1, #0x0000
    movk w1, #0x4040, lsl #16
    fmov s1, w1
    
    // FMUL: 2.0 * 3.0 = 6.0 = 0x40c00000
    fmul s2, s0, s1

    brk #0
