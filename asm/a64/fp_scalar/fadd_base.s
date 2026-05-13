/* CONFIG
{
  "Match": "All",
  "RegData": {
    "S0": "0x40400000",
    "S1": "0x40800000",
    "S2": "0x40E00000",
    "S3": "0x00000000",
    "D4": "0x0000000000000000",
    "D5": "0x0000000000000000",
    "D6": "0x0000000000000000",
    "D7": "0x0000000000000000"
  }
}
*/
// Test: FADD - floating-point add (single precision)
// S0 = 3.0 (0x40400000), S1 = 4.0 (0x40800000)
// S2 = 3.0 + 4.0 = 7.0 (0x40E00000)

.text
.global _start
_start:
    fmov s0, #3.0
    fmov s1, #4.0
    fadd s2, s0, s1
    
    mov x3, #0
    mov x4, #0
    mov x5, #0
    mov x6, #0
    mov x7, #0

    brk #0
