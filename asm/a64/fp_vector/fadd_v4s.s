/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000802000008020"
  }
}
*/
// Test: FADD - Floating-point Add (4S)

.text
.global _start
_start:
    // V0 = {1.0, 1.0}
    movi v0.4s, #0
    mov w8, #0x3F80
    movk w8, #0x0000, lsl #16
    ins v0.s[0], w8
    ins v0.s[1], w8
    
    // V1 = {5.0, 5.0}
    mov w9, #0x40A0
    movk w9, #0x0000, lsl #16
    ins v1.s[0], w9
    ins v1.s[1], w9
    
    // FADD: 1.0 + 5.0 = 6.0
    fadd v0.4s, v0.4s, v1.4s
    
    fmov x0, d0

    brk #0
