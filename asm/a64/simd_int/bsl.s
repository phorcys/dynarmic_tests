/* CONFIG
{
  "Match": "All",
  "Q0": "0x00000000000000FF00000000000000FF"
}
*/
// Test: BSL Vd.16B, Vn.16B, Vm.16B - Bitwise Select
// For each bit: if Vd bit is 1, select Vn bit, else Vm bit

.text
.global _start
_start:
    // Create test vectors
    movi v0.16b, #0xFF     // selector: all 1s
    movi v1.16b, #0xFF     // first operand
    movi v2.16b, #0x00     // second operand
    
    // BSL: For each bit in v0, if 1 select from v1, else from v2
    // v0 = all 1s, so result = v1 = all 1s
    bsl v0.16b, v1.16b, v2.16b
    
    // Result: v0 = 0xFF bytes

    brk #0
