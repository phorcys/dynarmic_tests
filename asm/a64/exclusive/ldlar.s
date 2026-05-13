/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000042",
    "X1": "0x000000000000ABCD"
  }
}
*/
// Test: LDLAR Xd, [Xn] - Load LOAcquire Register
// Load with LOAcquire semantics (weaker than LDAR)
// Note: LDLAR/LDLARH/LDLARB only support [Xn] form (no immediate offset)

.text
.global _start
_start:
    // Use stack for memory location
    sub sp, sp, #32
    
    // Store a 64-bit value
    mov x3, #0x42
    str x3, [sp]
    
    // Load with LOAcquire
    ldlar x0, [sp]
    // X0 = 0x42
    
    // Test LDLARH (16-bit)
    // Use a separate register for address
    mov x2, sp
    add x2, x2, #8
    mov w3, #0xABCD
    strh w3, [x2]
    ldlarh w1, [x2]
    // W1 = 0xABCD
    
    brk #0