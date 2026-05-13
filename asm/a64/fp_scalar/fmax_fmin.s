/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x4000000000000000",
    "X1": "0x3FF0000000000000"
  }
}
*/
// Test: FMAX Dd, Dn, Dm / FMIN Dd, Dn, Dm - Floating-point Maximum/Minimum

.text
.global _start
_start:
    // FMAX of 1.0 and 2.0 = 2.0
    mov x0, #0x3FF0000000000000   // 1.0 in double
    fmov d0, x0
    mov x1, #0x4000000000000000   // 2.0 in double
    fmov d1, x1
    
    fmax d2, d0, d1
    fmov x0, d2                   // X0 = 2.0 (max)
    
    // FMIN of 1.0 and 2.0 = 1.0
    fmin d2, d0, d1
    fmov x1, d2                   // X1 = 1.0 (min)

    brk #0
