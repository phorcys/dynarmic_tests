/* CONFIG
{
  "Match": "All",
  "X0": "0x0000000000000002"
}
*/
// Test: B.cond label - Branch Conditional
// Conditional branch based on condition flags

.text
.global _start
_start:
    mov x0, #1
    mov x1, #1
    cmp x0, x1
    
    // B.EQ: branch if equal
    b.eq target
    mov x0, #0  // should be skipped
    b done
target:
    mov x0, #2
done:
    brk #0
