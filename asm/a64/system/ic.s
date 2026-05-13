/* CONFIG
{
  "Match": "All",
  "X0": "0x0000000000000000"
}
*/
// Test: IC IVAU, Xt - Instruction Cache Invalidate
// Invalidates instruction cache by VA to PoU

.text
.global _start
_start:
    mov x0, #0
    
    // IC IVAU: instruction cache invalidate
    ic ivau, x0
    
    brk #0
