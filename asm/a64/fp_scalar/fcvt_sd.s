/* CONFIG
{
  "Match": "All",
  "RegData": {
    "S0": "0x40400000",
    "D1": "0x4008000000000000",
    "S2": "0x00000000"
  }
}
*/
// Test: FCVT - convert single to double precision
// S0 = 3.0 (single), D1 = 3.0 (double)

.text
.global _start
_start:
    fmov s0, #3.0
    fcvt d1, s0
    
    mov x2, #0
    brk #0
