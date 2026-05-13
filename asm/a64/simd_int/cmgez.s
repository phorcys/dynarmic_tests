/* CONFIG
{
  "Match": "All",
  "Q0": "0xFFFFFFFFFFFFFFFF0000000000000000"
}
*/
// Test: CMGE Vd.2D, Vn.2D, #0 - Compare Greater than or Equal to Zero
// Sets destination element to all 1s if source >= 0 (signed), else all 0s

.text
.global _start
_start:
    // v0.2d = [1, -1] (signed)
    mov x0, #1
    fmov d0, x0
    mov x0, #-1
    ins v0.d[1], x0
    
    // CMGE: compare greater than or equal to zero (signed)
    // [1, -1] >= 0 => [true, false] => [0xFFFFFFFFFFFFFFFF, 0]
    cmge v0.2d, v0.2d, #0
    
    brk #0
