/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x000000000000002A"
  }
}
*/
// Test: LDAXRB Wd, [Xn] - Load-Acquire Exclusive Register Byte
// Load byte with acquire and exclusive semantics

.text
.global _start
_start:
    // Store a byte on stack
    mov w0, #42
    strb w0, [sp, #-8]!
    
    // Load byte with acquire exclusive
    ldaxrb w0, [sp]
    // X0 = 42

    brk #0