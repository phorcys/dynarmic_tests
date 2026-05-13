/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x000000000000000A"
  }
}
*/
// Test: ADDV - Add across Vector (4S)

.text
.global _start
_start:
    // Create V0 = {1, 2, 3, 4} using MOV instructions
    movi v0.4s, #0
    mov w8, #1
    mov w9, #2
    mov w10, #3
    mov w11, #4
    ins v0.s[0], w8
    ins v0.s[1], w9
    ins v0.s[2], w10
    ins v0.s[3], w11
    
    // ADDV: 1 + 2 + 3 + 4 = 10
    addv s0, v0.4s
    
    fmov w0, s0

    brk #0
