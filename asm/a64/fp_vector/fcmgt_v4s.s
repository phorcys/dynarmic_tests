/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0xFFFFFFFFFFFFFFFF"
  }
}
*/
// Test: FCMGT - Floating-point Compare Greater Than (4S)

.text
.global _start
_start:
    // V0 = {2.0, 2.0}
    movi v0.4s, #0
    mov w8, #0x4000  // 2.0 in IEEE 754
    movk w8, #0x0000, lsl #16
    ins v0.s[0], w8
    ins v0.s[1], w8
    
    // V1 = {1.0, 1.0}
    mov w9, #0x3F80  // 1.0 in IEEE 754
    movk w9, #0x0000, lsl #16
    ins v1.s[0], w9
    ins v1.s[1], w9
    
    // FCMGT: compare greater than
    fcmgt v0.4s, v0.4s, v1.4s
    
    fmov x0, d0

    brk #0
