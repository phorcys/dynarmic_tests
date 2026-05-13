/* CONFIG
{
  "Match": "All",
  "Q0": "0x0000002A0000002A0000002A0000002A"
}
*/
// Test: MOVI Vd.4S, #imm, lsl #shift - Move immediate to vector with shift
// Loads shifted immediate value into all vector elements

.text
.global _start
_start:
    // MOVI: load shifted immediate into 32-bit elements
    movi v0.4s, #0x2A, lsl #0
    
    // V0 = [42, 42, 42, 42] (4 x 32-bit)

    brk #0
