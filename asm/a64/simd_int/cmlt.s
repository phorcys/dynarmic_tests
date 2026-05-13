/* CONFIG
{
  "Match": "All",
  "Q0": "0x0000000000000000FFFFFFFFFFFFFFFF"
}
*/
// Test: CMLT Vd.2D, Vn.2D, #0 - Compare Less Than Zero (signed)
// Sets destination element to all 1s if Vn < 0 (signed), all 0s otherwise

.text
.global _start
_start:
    mov x0, #-1
    dup v0.2d, x0
    mov x1, #1
    dup v1.2d, x1
    
    // CMLT: compare less than zero (signed)
    // V0[0] < 0 (-1 < 0) -> all 1s
    // V0[1] < 0 (1 < 0) -> all 0s
    // Note: CMLT only supports comparison with zero
    mov v0.16b, v0.16b
    cmlt v1.2d, v0.2d, #0
    
    // Result in V1
    mov v0.16b, v1.16b
    
    brk #0