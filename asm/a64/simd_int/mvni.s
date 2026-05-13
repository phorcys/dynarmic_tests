/* CONFIG
{
  "Match": "All",
  "Q0": "0xFFFFFFFFFFFFFFFEFFFFFFFFFFFFFFFE"
}
*/
// Test: MVNI Vd.4S, #imm - Move Immediate NOT
// Moves the bitwise NOT of an immediate into each element

.text
.global _start
_start:
    // MVNI: move immediate NOT
    // ~0x01 = 0xFFFFFFFE
    mvni v0.4s, #0x01
    
    brk #0
