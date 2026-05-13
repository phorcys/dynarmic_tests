/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0xBABECAFEBEEFDEAD",
    "X1": "0x1"
  }
}
*/
// Test: Access TLS at maximum offset (0xFF8 - last 8 bytes of 4KB)
// TLS size is typically 0x1000 (4KB), max 8-byte aligned offset is 0xFF8
.text
.global _start
_start:
    mrs x0, tpidr_el0
    
    // Write to last 8 bytes of TLS
    add x1, x0, #0xFF8
    mov x2, #0xDEAD
    movk x2, #0xBEEF, lsl #16    // bits [31:16] = 0xBEEF
    movk x2, #0xCAFE, lsl #32    // bits [47:32] = 0xCAFE
    movk x2, #0xBABE, lsl #48    // bits [63:48] = 0xBABE
    // x2 = 0xBABECAFEBEEFDEAD
    str x2, [x1]
    
    // Read back
    ldr x3, [x0, #0xFF8]
    
    // Compare
    cmp x2, x3
    cset x1, eq
    
    mov x0, x3          // Return the value
    
    brk #0
