/* CONFIG
{
  "Match": "All",
  "Q0": "0x00000000000000000000000000000000"
}
*/
// Test: SM4EKEY Vd.4S, Vn.4S, Vm.4S - SM4 key expansion

.text
.global _start
_start:
    // Initialize with zeros
    movi v0.4s, #0
    movi v1.4s, #0
    movi v2.4s, #0
    
    // SM4EKEY: SM4 key expansion
    sm4ekey v0.4s, v1.4s, v2.4s
    
    brk #0
