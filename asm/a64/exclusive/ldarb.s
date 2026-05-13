/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x000000000000002A"
  }
}
*/
// Test: LDARB Wd, [Xn] - Load-Acquire Register Byte
// Load byte with acquire semantics

.text
.global _start
_start:
    // Store a byte on stack
    mov w0, #42
    strb w0, [sp, #-8]!
    
    // Load byte with acquire
    ldarb w0, [sp]
    // X0 = 42 (zero-extended)

    brk #0