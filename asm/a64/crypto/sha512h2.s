/* CONFIG
{
  "Match": "All",
  "Q0": "0x00000000000000000000000000000000"
}
*/
// Test: SHA512H2 Qd, Qn, Vm.2D - SHA512 hash update part 2

.text
.global _start
_start:
    // Initialize with zeros
    movi v0.2d, #0
    movi v1.2d, #0
    movi v2.2d, #0
    
    // SHA512H2: SHA512 hash update part 2
    sha512h2 q0, q1, v2.2d
    
    brk #0
