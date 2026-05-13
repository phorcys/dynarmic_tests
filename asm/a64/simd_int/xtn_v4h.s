/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0004000300020001"
  }
}
*/
// Test: XTN - Extract Narrow (4H from 4S)

.text
.global _start
_start:
    // V0 = {0x00000001, 0x00000002, 0x00000003, 0x00000004}
    movi v0.4s, #0
    mov w8, #1
    mov w9, #2
    mov w10, #3
    mov w11, #4
    ins v0.s[0], w8
    ins v0.s[1], w9
    ins v0.s[2], w10
    ins v0.s[3], w11
    
    // XTN: extract lower 16 bits of each 32-bit element
    xtn v0.4h, v0.4s
    
    fmov x0, d0

    brk #0
