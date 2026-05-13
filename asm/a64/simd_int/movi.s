/* CONFIG
{
  "Match": "All",
  "Q0": "0x0000000000000000000000000000002A"
}
*/
// Test: MOVI Vd.16B, #imm - Move immediate to vector
// Loads immediate value into all vector elements

.text
.global _start
_start:
    // MOVI: load 42 into all bytes
    movi v0.16b, #42
    
    // V0 = [42, 42, ..., 42] (16 bytes)

    brk #0
