/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0xFFFFFFFFFFFF8000",
    "X1": "0x0000000000007FFF"
  }
}
*/
// Test: LDRSH - Load Register Signed Halfword

.text
.global _start
_start:
    // Store test data: 0x8000 (-32768 signed), 0x7FFF (32767 signed)
    movz x8, #0x8000
    movk x8, #0x7FFF, lsl #16
    str x8, [sp, #-16]!
    
    // Load signed halfword (sign-extended)
    ldrsh x0, [sp]       // Load 0x8000, sign-extend to -32768
    ldrsh x1, [sp, #2]   // Load 0x7FFF, sign-extend to 32767

    brk #0
