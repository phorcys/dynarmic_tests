/* CONFIG
{
  "Match": "All",
  "Q0": "0x00000000000000000000000000000000"
}
*/
// Test: SM3TT1A Vd.4S, Vn.4S, Vm.4S - SM3 TT1A

.text
.global _start
_start:
    // Initialize with zeros
    movi v0.4s, #0
    movi v1.4s, #0
    movi v2.4s, #0
    
    // SM3TT1A: SM3 TT1A operation with immediate 0
    sm3tt1a v0.4s, v1.4s, v2.s[0]
    
    brk #0
