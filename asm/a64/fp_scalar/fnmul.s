/* CONFIG
{
  "Match": "All",
  "RegData": {
    "S0": "0x0000000040000000",
    "S1": "0x0000000040800000",
    "S2": "0x00000000C1000000"
  }
}
*/
// Test: FNMUL Sd, Sn, Sm - floating-point negate multiply

.text
.global _start
_start:
    // Load S0 with 2.0
    mov w0, #0x0000
    movk w0, #0x4000, lsl #16
    fmov s0, w0
    
    // Load S1 with 4.0
    mov w1, #0x0000
    movk w1, #0x4080, lsl #16
    fmov s1, w1
    
    // FNMUL: -(2.0 * 4.0) = -8.0
    fnmul s2, s0, s1

    brk #0
