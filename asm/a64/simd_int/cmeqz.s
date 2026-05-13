/* CONFIG
{
  "Match": "All",
  "Q0": "0xFFFFFFFFFFFFFFFF0000000000000000"
}
*/
// Test: CMEQ Vd.2D, Vn.2D, #0 - Compare Equal to Zero
// Sets destination element to all 1s if source equals zero, else all 0s

.text
.global _start
_start:
    // v0.2d = [0, 1]
    mov x0, #0
    fmov d0, x0
    mov x0, #1
    ins v0.d[1], x0
    
    // CMEQ: compare equal to zero
    // [0, 1] == 0 => [true, false] => [0xFFFFFFFFFFFFFFFF, 0]
    cmeq v0.2d, v0.2d, #0
    
    brk #0
