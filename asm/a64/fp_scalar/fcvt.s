/* CONFIG
{
  "Match": "All",
  "S0": "0x40000000"
}
*/
// Test: FCVT Sd, Dn - Floating-point Convert (double to single)
// Converts double-precision to single-precision

.text
.global _start
_start:
    fmov d0, #2.0
    
    // FCVT: convert double to single
    fcvt s0, d0
    
    brk #0