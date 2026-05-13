/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x00000000DEADBEEF"
  }
}
*/
// Test: LDUR - Load Register (unscaled)

.text
.global _start
_start:
    // Store test data
    movz x8, #0xBEEF
    movk x8, #0xDEAD, lsl #16
    str x8, [sp, #-16]!
    
    // Load using LDUR (unscaled offset)
    ldur x0, [sp]

    brk #0
