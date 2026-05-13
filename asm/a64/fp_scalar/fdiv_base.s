/* CONFIG
{
  "Match": "All",
  "RegData": {
    "S0": "0x41400000",
    "S1": "0x40400000",
    "S2": "0x40800000",
    "S3": "0x00000000"
  }
}
*/
// Test: FDIV - floating-point divide (single precision)
// S0 = 12.0, S1 = 3.0, S2 = 12.0 / 3.0 = 4.0 (0x40800000)

.text
.global _start
_start:
    fmov s0, #12.0
    fmov s1, #3.0
    fdiv s2, s0, s1
    
    mov x3, #0
    brk #0
