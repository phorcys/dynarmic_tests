/* CONFIG
{
  "Match": "All",
  "Q0": "0x00000000000000000000000000000000"
}
*/
// Test: SM3SS1 Vd.4S, Vn.4S, Vm.4S, Va.4S - SM3 SS1

.text
.global _start
_start:
    // Initialize with zeros
    movi v0.4s, #0
    movi v1.4s, #0
    movi v2.4s, #0
    movi v3.4s, #0
    
    // SM3SS1: SM3 SS1 operation
    sm3ss1 v0.4s, v1.4s, v2.4s, v3.4s
    
    brk #0
