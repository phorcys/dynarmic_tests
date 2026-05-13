/* CONFIG
{
  "Match": "All",
  "RegData": {
    "S0": "0x3F800000",
    "S1": "0x40000000",
    "S2": "0x40400000",
    "S3": "0x40800000",
    "D4": "0x3FF0000000000000",
    "D5": "0x4000000000000000"
  }
}
*/
// Test: FMOV with immediate - floating-point move immediate
// FMOV Sd, #imm - loads immediate into Sd
// Note: ARM64 FMOV immediate only supports specific values
// 1.0 = 0x3F800000, 2.0 = 0x40000000, etc.

.text
.global _start
_start:
    fmov s0, #1.0
    fmov s1, #2.0
    fmov s2, #3.0
    fmov s3, #4.0
    fmov d4, #1.0
    fmov d5, #2.0
    
    brk #0
