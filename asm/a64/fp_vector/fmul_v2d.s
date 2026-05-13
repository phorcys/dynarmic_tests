/* CONFIG
{
  "Match": "All",
  "RegData": {
    "Q0": "0x40100000000000004010000000000000"
  }
}
*/
// Test: FMUL V2D - vector floating multiply

.text
.global _start
_start:
    mov x0, #0
    movk x0, #0x4000, lsl #48    // 2.0 in double
    mov v0.d[0], x0
    mov v0.d[1], x0
    
    mov x1, #0
    movk x1, #0x4000, lsl #48    // 2.0 in double
    mov v1.d[0], x1
    mov v1.d[1], x1
    
    fmul v0.2d, v0.2d, v1.2d     // 2*2 = 4
    
    brk #0
