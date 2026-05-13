/* CONFIG
{
  "Match": "All",
  "Memory": {
    "0x10000": "0x0000000000000042"
  }
}
*/
// Test: STLLR Xd, [Xn] - Store LORelease Register
// Store with LORelease semantics

.text
.global _start
_start:
    // Setup memory location
    mov x0, #0x10000
    mov x1, #0
    
    // Store 0 initially
    str x1, [x0]
    
    // Store with LORelease
    mov x1, #0x42
    stllr x1, [x0]
    // Memory[0x10000] = 0x42
    
    brk #0
