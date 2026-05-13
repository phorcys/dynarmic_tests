/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x000000000000002A"
  }
}
*/
// Test: PRFUM imm, [Xn, #imm] - Prefetch Memory (unscaled offset)
// Prefetch hint instruction with unscaled offset

.text
.global _start
_start:
    mov x0, #42
    
    // PRFUM: Prefetch memory with unscaled offset
    prfum pldl1keep, [sp, #0]
    prfum pldl1strm, [sp, #8]
    prfum pldl2keep, [sp, #16]
    prfum pldl2strm, [sp, #-8]
    
    // X0 should still be 42

    brk #0
