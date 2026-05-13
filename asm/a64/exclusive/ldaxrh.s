/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x000000000000002A"
  }
}
*/
// Test: LDAXRH Wd, [Xn] - Load-Acquire Exclusive Register Halfword
// Load halfword with acquire and exclusive semantics

.text
.global _start
_start:
    // Store a halfword on stack
    mov w0, #42
    strh w0, [sp, #-8]!
    
    // Load halfword with acquire exclusive
    ldaxrh w0, [sp]
    // X0 = 42

    brk #0