/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x000000000000002A"
  }
}
*/
// Test: YIELD - Hint that this thread is spinning
// YIELD is an alias for HINT #1

.text
.global _start
_start:
    mov x0, #42
    
    // YIELD: hint that this thread is spinning
    yield
    
    // X0 should still be 42

    brk #0
