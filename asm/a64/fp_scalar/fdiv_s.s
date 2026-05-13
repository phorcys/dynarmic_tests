/* CONFIG
{
  "Match": "All",
  "RegData": {
    "S0": "0x0000000041000000",
    "S1": "0x0000000040000000",
    "S2": "0x0000000040800000"
  }
}
*/
// Test: FDIV Sd, Sn, Sm - scalar floating-point divide

.text
.global _start
_start:
    // Load S0 with 8.0
    mov w0, #0x0000
    movk w0, #0x4100, lsl #16
    fmov s0, w0
    
    // Load S1 with 2.0
    mov w1, #0x0000
    movk w1, #0x4000, lsl #16
    fmov s1, w1
    
    // FDIV: 8.0 / 2.0 = 4.0 = 0x40800000
    fdiv s2, s0, s1

    brk #0
