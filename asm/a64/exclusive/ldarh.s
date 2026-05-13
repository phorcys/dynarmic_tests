/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x000000000000002A"
  }
}
*/
// Test: LDARH Wd, [Xn] - Load-Acquire Register Halfword
// Load halfword with acquire semantics

.text
.global _start
_start:
    // Store a halfword on stack
    mov w0, #42
    strh w0, [sp, #-8]!
    
    // Load halfword with acquire
    ldarh w0, [sp]
    // X0 = 42 (zero-extended)

    brk #0