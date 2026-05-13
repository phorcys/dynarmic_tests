/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x4000000000000000",
    "X1": "0x0000000040000000"
  }
}
*/
// Test: FMOV Dd, Dn / FMOV Sd, Sn - Floating-point Move
// Move floating-point values between registers

.text
.global _start
_start:
    // Move double: 2.0
    mov x0, #0x4000000000000000   // 2.0 in double
    fmov d0, x0
    fmov d1, d0
    fmov x0, d1                   // X0 = 2.0
    
    // Move single: 2.0
    mov w1, #0x40000000           // 2.0 in single
    fmov s0, w1
    fmov s1, s0
    fmov w1, s1                   // W1 = 2.0 (in X1, upper bits may not be zeroed)

    brk #0