/* CONFIG
{
  "Match": "All",
  "SvcTest": [
    {"svc": "16", "action": "read_tls", "offset": "0", "result_reg": "X2"},
    {"svc": "17", "action": "write_tls", "offset": "0", "value": "0xAAAAAAAAAAAAAAAA"},
    {"svc": "16", "action": "read_tls", "offset": "0", "result_reg": "X3"},
    {"svc": "17", "action": "write_tls", "offset": "0", "value": "0x5555555555555555"},
    {"svc": "16", "action": "read_tls", "offset": "0", "result_reg": "X4"},
    {"svc": "17", "action": "write_tls", "offset": "0", "value": "0xFFFFFFFFFFFFFFFF"},
    {"svc": "16", "action": "read_tls", "offset": "0", "result_reg": "X5"}
  ],
  "RegData": {
    "X0": "0x6",
    "X1": "0x9AEFBEAD78563412",
    "X2": "0x0",
    "X3": "0xAAAAAAAAAAAAAAAA",
    "X4": "0x5555555555555555",
    "X5": "0xFFFFFFFFFFFFFFFF"
  }
}
*/
// Test: State preservation across multiple SVC calls
// Verifies that caller-saved registers are preserved or properly restored
.text
.global _start
_start:
    // Save important value in X1 (caller-saved)
    mov x1, #0x3412
    movk x1, #0x7856, lsl #16
    movk x1, #0xBEAD, lsl #32
    movk x1, #0x9AEF, lsl #48
    // X1 = 0x9AEFBEAD78563412
    
    // First SVC: read TLS[0]
    mov x1, #0          // offset = 0
    svc #16
    mov x2, x0          // Save result
    
    // Restore X1 value
    mov x1, #0x3412
    movk x1, #0x7856, lsl #16
    movk x1, #0xBEAD, lsl #32
    movk x1, #0x9AEF, lsl #48
    
    // Second SVC: write to TLS[0]
    mov x1, #0
    svc #17
    
    // Restore X1 again
    mov x1, #0x3412
    movk x1, #0x7856, lsl #16
    movk x1, #0xBEAD, lsl #32
    movk x1, #0x9AEF, lsl #48
    
    // Third SVC: read TLS[0]
    mov x1, #0
    svc #16
    mov x3, x0
    
    // Restore X1 again
    mov x1, #0x3412
    movk x1, #0x7856, lsl #16
    movk x1, #0xBEAD, lsl #32
    movk x1, #0x9AEF, lsl #48
    
    // Fourth SVC: write to TLS[0]
    mov x1, #0
    svc #17
    
    // Restore X1 again
    mov x1, #0x3412
    movk x1, #0x7856, lsl #16
    movk x1, #0xBEAD, lsl #32
    movk x1, #0x9AEF, lsl #48
    
    // Fifth SVC: read TLS[0]
    mov x1, #0
    svc #16
    mov x4, x0
    
    // Restore X1 again
    mov x1, #0x3412
    movk x1, #0x7856, lsl #16
    movk x1, #0xBEAD, lsl #32
    movk x1, #0x9AEF, lsl #48
    
    // Sixth SVC: write and read
    mov x1, #0
    svc #17
    mov x1, #0
    svc #16
    mov x5, x0
    
    // Final X1 value
    mov x1, #0x3412
    movk x1, #0x7856, lsl #16
    movk x1, #0xBEAD, lsl #32
    movk x1, #0x9AEF, lsl #48
    
    // Success: X0 = 6
    mov x0, #6
    
    brk #0