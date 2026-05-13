/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x000000000000002A"
  }
}
*/
// Test: PRFM imm, [Xn] - Prefetch Memory
// Prefetch hint instruction (does not affect program behavior)

.text
.global _start
_start:
    mov x0, #42
    
    // PRFM: Prefetch memory hint
    // PLDL1KEEP = 0 (prefetch for load, L1 cache, keep)
    prfm pldl1keep, [sp]
    
    // PRFM with other options
    prfm pldl1strm, [sp]
    prfm pldl2keep, [sp]
    prfm pldl2strm, [sp]
    prfm pldl3keep, [sp]
    prfm pldl3strm, [sp]
    
    // X0 should still be 42

    brk #0
