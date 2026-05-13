/* CONFIG
{
  "Match": "All",
  "RegData": {
    "S0": "0x41100000",
    "S1": "0x40400000",
    "S2": "0x00000000"
  }
}
*/
// Test: FSQRT - floating-point square root
// S0 = 9.0, S1 = sqrt(9.0) = 3.0

.text
.global _start
_start:
    fmov s0, #9.0
    fsqrt s1, s0
    
    mov x2, #0
    brk #0
