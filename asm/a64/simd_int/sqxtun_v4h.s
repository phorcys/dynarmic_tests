/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000010000000000"
  }
}
*/
// Test: SQXTUN - Signed Saturating Extract and Narrow (Unsigned, 4H from 4S)

.text
.global _start
_start:
    // V0 = {0, -1, 256, 0xFFFFFFFF}
    movi v0.4s, #0
    mov w8, #0
    mov w9, #-1
    mov w10, #256
    mov w11, #0xFFFF
    movk w11, #0xFFFF, lsl #16
    ins v0.s[0], w8
    ins v0.s[1], w9
    ins v0.s[2], w10
    ins v0.s[3], w11
    
    // SQXTUN: extract with unsigned saturation
    // 0 -> 0, -1 -> 0 (saturates), 256 -> 255 (saturates), 0xFFFFFFFF -> 255
    sqxtun v0.4h, v0.4s
    
    fmov x0, d0

    brk #0
