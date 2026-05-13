/* CONFIG
{
  "Match": "All",
  "Q0": "0x00000000000000000000000000000000"
}
*/
// Test: SM3PARTW1 Vd.4S, Vn.4S, Vm.4S - SM3 PARTW1

.text
.global _start
_start:
    // Initialize with zeros
    movi v0.4s, #0
    movi v1.4s, #0
    movi v2.4s, #0
    
    // SM3PARTW1: SM3 PARTW1 operation
    sm3partw1 v0.4s, v1.4s, v2.4s
    
    brk #0
