/* CONFIG
{
  "Match": "All",
  "X0": "0x0000000000000001"
}
*/
// Test: B label - Branch
// Unconditional branch to label

.text
.global _start
_start:
    mov x0, #0
    b target
    mov x0, #2  // should be skipped
target:
    mov x0, #1
    brk #0
