/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x00000000DEADBEEF",
    "X1": "0x00000000CAFEBABE"
  }
}
*/
// Test: LDXP - Load Exclusive Pair

.text
.global _start
_start:
    // Store test data
    movz x8, #0xBEEF
    movk x8, #0xDEAD, lsl #16
    movz x9, #0xBABE
    movk x9, #0xCAFE, lsl #16
    stp x8, x9, [sp, #-16]!
    
    // Load exclusive pair
    ldxp x0, x1, [sp]

    brk #0
