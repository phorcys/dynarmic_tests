/* CONFIG
{
  "Match": "All",
  "Q0": "0x00000000000000000000000000000000"
}
*/
// Test: SHA512H Qd, Qn, Vm.2D - SHA512 hash update part 1

.text
.global _start
_start:
    // Initialize with zeros
    movi v0.2d, #0
    movi v1.2d, #0
    movi v2.2d, #0
    
    // SHA512H: SHA512 hash update
    sha512h q0, q1, v2.2d
    
    brk #0
