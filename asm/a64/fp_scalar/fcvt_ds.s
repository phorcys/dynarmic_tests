/* CONFIG
{
  "Match": "All",
  "RegData": {
    "D0": "0x4008000000000000",
    "S1": "0x40400000",
    "S2": "0x00000000"
  }
}
*/
// Test: FCVT - convert double to single precision
// D0 = 3.0 (double), S1 = 3.0 (single)

.text
.global _start
_start:
    fmov d0, #3.0
    fcvt s1, d0
    
    mov x2, #0
    brk #0
