/* CONFIG
{
  "Match": "All",
  "Q0": "0x0000000000000000FFFFFFFFFFFFFFFF"
}
*/
// Test: CMLT Vd.2D, Vn.2D, #0 - Compare Less Than Zero
// Sets destination element to all 1s if source < 0 (signed), else all 0s

.text
.global _start
_start:
    // v0.2d = [0, -1] (signed)
    mov x0, #0
    fmov d0, x0
    mov x0, #-1
    ins v0.d[1], x0
    
    // CMLT: compare less than zero (signed)
    // [0, -1] < 0 => [false, true] => [0, 0xFFFFFFFFFFFFFFFF]
    cmlt v0.2d, v0.2d, #0
    
    brk #0
