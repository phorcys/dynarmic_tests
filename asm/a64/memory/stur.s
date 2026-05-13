/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x00000000DEADBEEF"
  }
}
*/
// Test: STUR - Store Register (unscaled)

.text
.global _start
_start:
    // Store using STUR
    movz x8, #0xBEEF
    movk x8, #0xDEAD, lsl #16
    
    stur x8, [sp, #-16]
    
    // Load back to verify
    ldr x0, [sp, #-16]

    brk #0
