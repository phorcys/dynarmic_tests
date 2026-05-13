/* CONFIG
{
  "Match": "All",
  "RegData": {
    "S0": "0x41240000",
    "S1": "0x41200000",
    "S2": "0x41200000",
    "S3": "0x41300000",
    "S4": "0x41200000",
    "S5": "0x00000000"
  }
}
*/
// Test: FRINT - floating-point round to integer
// FRINTN - round to nearest even
// FRINTZ - round toward zero
// FRINTP - round toward +infinity
// FRINTM - round toward -infinity
// Value: 10.25 = 0x41240000
// 10.0 = 0x41200000, 11.0 = 0x41300000

.text
.global _start
_start:
    // Load 10.25 into s0 using integer register
    // 10.25 = 0x41240000
    movz w0, #0x0000
    movk w0, #0x4124, lsl #16
    fmov s0, w0         // s0 = 10.25 (0x41240000)
    
    frintn s1, s0       // round to nearest even = 10.0 (0x41200000)
    frintz s2, s0       // round toward zero = 10.0 (0x41200000)
    frintp s3, s0       // round toward +inf = 11.0 (0x41300000)
    frintm s4, s0       // round toward -inf = 10.0 (0x41200000)
    
    mov x5, #0
    brk #0
