/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0xFFFFFFFFFFFFFF80",
    "X1": "0x000000000000007F"
  }
}
*/
// Test: LDRSB - Load Register Signed Byte

.text
.global _start
_start:
    // Store test data: 0x80 (-128 signed), 0x7F (127 signed)
    movz x8, #0x7F80
    str x8, [sp, #-16]!
    
    // Load signed byte (sign-extended)
    ldrsb x0, [sp]       // Load 0x80, sign-extend to -128
    ldrsb x1, [sp, #1]   // Load 0x7F, sign-extend to 127

    brk #0
