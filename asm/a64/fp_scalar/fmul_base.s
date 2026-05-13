/* CONFIG
{
  "Match": "All",
  "RegData": {
    "S0": "0x40400000",
    "S1": "0x40800000",
    "S2": "0x41400000",
    "S3": "0x00000000"
  }
}
*/
// Test: FMUL - floating-point multiply (single precision)
// S0 = 3.0, S1 = 4.0, S2 = 3.0 * 4.0 = 12.0 (0x41400000)

.text
.global _start
_start:
    fmov s0, #3.0
    fmov s1, #4.0
    fmul s2, s0, s1
    
    mov x3, #0
    brk #0
