/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0xFFFFFFFFFFFFFFFF"
  }
}
*/
// Test: UQADD - Saturating Add (unsigned, 4S)

.text
.global _start
_start:
    // V0 = {0xFFFFFFFF, 0xFFFFFFFF} (max uint32)
    movz x8, #0xFFFF
    movk x8, #0xFFFF, lsl #16
    movk x8, #0xFFFF, lsl #32
    movk x8, #0xFFFF, lsl #48
    fmov d0, x8
    
    // V1 = {0x00000001, 0x00000001}
    movz x9, #0x0001
    fmov d1, x9
    
    // UQADD: 0xFFFFFFFF + 1 = saturates to 0xFFFFFFFF (max uint32)
    uqadd v0.4s, v0.4s, v1.4s
    
    fmov x0, d0

    brk #0
