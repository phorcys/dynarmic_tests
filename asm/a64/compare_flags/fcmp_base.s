/* CONFIG
{
  "Match": "All",
  "RegData": {
    "S0": "0x40400000",
    "S1": "0x40800000",
    "X2": "0x0000000080000000",
    "X3": "0x0000000060000000",
    "X4": "0x0000000020000000",
    "X5": "0x0000000000000000"
  }
}
*/
// Test: FCMP - floating-point compare
// FCMP sets NZCV flags:
// - Less than: N=1, Z=0, C=0, V=0 => 0x80000000
// - Equal: N=0, Z=1, C=1, V=0 => 0x60000000
// - Greater than: N=0, Z=0, C=1, V=0 => 0x20000000

.text
.global _start
_start:
    fmov s0, #3.0
    fmov s1, #4.0
    
    // Test 1: 3.0 < 4.0
    fcmp s0, s1
    mrs x2, nzcv
    
    // Test 2: 4.0 == 4.0
    fcmp s1, s1
    mrs x3, nzcv
    
    // Test 3: 4.0 > 3.0
    fcmp s1, s0
    mrs x4, nzcv
    
    mov x5, #0
    brk #0
