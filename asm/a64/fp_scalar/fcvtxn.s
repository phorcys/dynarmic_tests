/* CONFIG
{
  "Match": "All",
  "S0": "0x0000000040000000",
  "S1": "0x00000000C0000000"
}
*/
// Test: FCVTXN Sd, Dn - Floating-point Convert to Single, rounding to odd
// Convert double to single with rounding to odd (preserves precision on double-rounding)

.text
.global _start
_start:
    // Test 1: Convert 2.0 (double) to 2.0 (single)
    mov x0, #0x4000000000000000   // 2.0 in double
    fmov d0, x0
    fcvtxn s0, d0
    // S0 = 2.0 = 0x40000000
    
    // Test 2: Convert -2.0 (double) to -2.0 (single)
    mov x1, #0xC000000000000000   // -2.0 in double
    fmov d1, x1
    fcvtxn s1, d1
    // S1 = -2.0 = 0xC0000000

    brk #0