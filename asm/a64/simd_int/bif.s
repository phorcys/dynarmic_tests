/* CONFIG
{
  "Match": "All",
  "Q0": "0x00000000000000000000000000000000"
}
*/
// Test: BIF Vd.16B, Vn.16B, Vm.16B - Bitwise Insert if False
// For each bit: if Vn bit is 0, set Vd bit to Vm bit

.text
.global _start
_start:
    // Create test vectors
    movi v0.16b, #0x00     // destination: all 0s
    movi v1.16b, #0xFF     // mask: all 1s
    movi v2.16b, #0xFF     // source: all 1s
    
    // BIF: For each bit in v1, if 0 set v0 bit to v2 bit
    // v1 = all 1s, so no bits changed
    bif v0.16b, v1.16b, v2.16b
    
    // Result: v0 = all 0s (unchanged)

    brk #0
