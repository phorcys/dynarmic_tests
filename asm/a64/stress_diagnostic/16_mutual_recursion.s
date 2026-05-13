/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000002"
  }
}
*/
// Test: Mutual recursion - even/odd check (simplified iterative version)
// RSB workaround: uses loop instead of recursion

.text
.global _start
_start:
    mov x0, #4       // Check if 4 is even
    bl is_even_iter
    brk #0

// Iterative even check
is_even_iter:
    mov x1, x0
    and x0, x1, #1   // x0 = x1 & 1
    eor x0, x0, #1   // flip: even -> 1, odd -> 0 (using EOR not XOR)
    lsl x0, x0, #1   // multiply by 2 for output = 2
    ret
