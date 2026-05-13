/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x000000000000002A"
  }
}
*/
// Test: LDAR Xd, [Xn] - Load-Acquire Register
// Load with acquire semantics

.text
.global _start
_start:
    // Store a value on stack
    mov x0, #42
    str x0, [sp, #-8]!
    
    // Load with acquire
    ldar x0, [sp]
    // X0 = 42

    brk #0
