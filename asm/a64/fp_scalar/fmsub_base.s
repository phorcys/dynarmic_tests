/* CONFIG
{
  "Match": "All",
  "RegData": {
    "S0": "0x40400000",
    "S1": "0x40800000",
    "S2": "0x41880000",
    "S3": "0x40A00000",
    "S4": "0x00000000"
  }
}
*/
// Test: FMSUB - floating-point multiply-subtract
// FMSUB S3, S0, S1, S2 = S2 - S0 * S1 = 17.0 - 3.0 * 4.0 = 5.0

.text
.global _start
_start:
    fmov s0, #3.0
    fmov s1, #4.0
    fmov s2, #17.0
    fmsub s3, s0, s1, s2
    
    mov x4, #0
    brk #0
