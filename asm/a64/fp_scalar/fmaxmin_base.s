/* CONFIG
{
  "Match": "All",
  "RegData": {
    "S0": "0x40400000",
    "S1": "0x40800000",
    "S2": "0x40800000",
    "S3": "0x40400000",
    "S4": "0x40800000",
    "S5": "0x40400000"
  }
}
*/
// Test: FMAX/FMIN - floating-point maximum/minimum
// FMAX Sd, Sn, Sm - returns maximum of Sn, Sm
// FMIN Sd, Sn, Sm - returns minimum of Sn, Sm

.text
.global _start
_start:
    fmov s0, #3.0      // 0x40400000
    fmov s1, #4.0      // 0x40800000
    
    fmax s2, s0, s1    // max(3.0, 4.0) = 4.0
    fmin s3, s0, s1    // min(3.0, 4.0) = 3.0
    
    fmax s4, s1, s0    // max(4.0, 3.0) = 4.0
    fmin s5, s1, s0    // min(4.0, 3.0) = 3.0
    
    brk #0
