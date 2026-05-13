/* CONFIG
{
  "Match": "All",
  "RegData": {
    "S0": "0x40E00000",
    "S1": "0x40800000",
    "S2": "0x40400000",
    "S3": "0x00000000"
  }
}
*/
// Test: FSUB - floating-point subtract (single precision)
// S0 = 7.0, S1 = 4.0, S2 = 7.0 - 4.0 = 3.0

.text
.global _start
_start:
    fmov s0, #7.0
    fmov s1, #4.0
    fsub s2, s0, s1
    
    mov x3, #0
    brk #0
