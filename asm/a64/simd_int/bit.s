/* CONFIG
{
  "Match": "All",
  "Q0": "0x00000000000000000000000000000000"
}
*/
// Test: BIT Vd.16B, Vn.16B, Vm.16B - Bitwise Insert if True
// For each bit: if Vn bit is 1, set Vd bit to Vm bit

.text
.global _start
_start:
    // Create test vectors
    movi v0.16b, #0x00     // destination: all 0s
    movi v1.16b, #0x00     // mask: all 0s
    movi v2.16b, #0xFF     // source: all 1s
    
    // BIT: For each bit in v1, if 1 set v0 bit to v2 bit
    // v1 = all 0s, so no bits changed
    bit v0.16b, v1.16b, v2.16b
    
    // Result: v0 = all 0s (unchanged)

    brk #0
