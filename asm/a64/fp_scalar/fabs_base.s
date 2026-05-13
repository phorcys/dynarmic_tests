/* CONFIG
{
  "Match": "All",
  "RegData": {
    "S0": "0xC0400000",
    "S1": "0x40400000",
    "S2": "0x00000000"
  }
}
*/
// Test: FABS - floating-point absolute value
// S0 = -3.0, S1 = |-3.0| = 3.0

.text
.global _start
_start:
    fmov s0, #-3.0
    fabs s1, s0
    
    mov x2, #0
    brk #0
