/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000005"
  }
}
*/
// Test: SMAXV - Maximum across Vector (signed, 4S)

.text
.global _start
_start:
    // Create V0 = {1, 5, 3, 2}
    movi v0.4s, #0
    mov w8, #1
    mov w9, #5
    mov w10, #3
    mov w11, #2
    ins v0.s[0], w8
    ins v0.s[1], w9
    ins v0.s[2], w10
    ins v0.s[3], w11
    
    // SMAXV: max(1, 5, 3, 2) = 5
    smaxv s0, v0.4s
    
    fmov w0, s0

    brk #0
