/* CONFIG
{
  "Match": "All",
  "Q0": "0x00000000000000000000000000000000"
}
*/
// Test: SHA512SU1 Vd.2D, Vn.2D, Vm.2D - SHA512 schedule update 1

.text
.global _start
_start:
    // Initialize with zeros
    movi v0.2d, #0
    movi v1.2d, #0
    movi v2.2d, #0
    
    // SHA512SU1: SHA512 schedule update 1
    sha512su1 v0.2d, v1.2d, v2.2d
    
    brk #0
