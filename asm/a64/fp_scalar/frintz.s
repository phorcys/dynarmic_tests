/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x4000000000000000",
    "X1": "0xC000000000000000",
    "X2": "0x4000000000000000"
  }
}
*/
// Test: FRINTZ Dd, Dn - Floating-point Round to Integral, toward Zero
// Rounds to nearest integer toward zero (truncate)

.text
.global _start
_start:
    // Test 1: 2.5 -> 2.0 (positive, round toward zero)
    mov x0, #0x4004000000000000   // 2.5 in double
    fmov d0, x0
    frintz d1, d0
    fmov x0, d1               // X0 = 2.0 (0x4000000000000000)
    
    // Test 2: -2.5 -> -2.0 (negative, round toward zero)
    mov x1, #0xC004000000000000  // -2.5 in double
    fmov d0, x1
    frintz d1, d0
    fmov x1, d1               // X1 = -2.0 (0xC000000000000000)
    
    // Test 3: 2.0 -> 2.0 (already integer)
    mov x2, #0x4000000000000000  // 2.0 in double
    fmov d0, x2
    frintz d1, d0
    fmov x2, d1               // X2 = 2.0

    brk #0
