/* CONFIG
{
  "Match": "All",
  "Q0": "0x00000000000000000000000000000000"
}
*/
// Test: SHA512SU0 Vd.2D, Vn.2D - SHA512 schedule update 0

.text
.global _start
_start:
    // Initialize with zeros
    movi v0.2d, #0
    
    // SHA512SU0: SHA512 schedule update 0
    sha512su0 v0.2d, v0.2d
    
    brk #0
