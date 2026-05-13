/* CONFIG
{
  "Match": "All",
  "SvcTest": [
    {"svc": "16", "action": "read_tls", "offset": "0", "result_reg": "X2"},
    {"svc": "17", "action": "write_tls", "offset": "0", "value": "0x1111111111111111"},
    {"svc": "16", "action": "read_tls", "offset": "0", "result_reg": "X3"},
    {"svc": "17", "action": "write_tls", "offset": "8", "value": "0x2222222222222222"},
    {"svc": "16", "action": "read_tls", "offset": "8", "result_reg": "X4"},
    {"svc": "16", "action": "read_tls", "offset": "0", "result_reg": "X5"}
  ],
  "RegData": {
    "X0": "0x5",
    "X2": "0x0",
    "X3": "0x1111111111111111",
    "X4": "0x2222222222222222",
    "X5": "0x1111111111111111"
  }
}
*/
// Test: Multiple consecutive SVC calls
// Tests that SVC callbacks work correctly in sequence
// SVC 16 = read_tls, SVC 17 = write_tls
.text
.global _start
_start:
    mov x0, #0
    mov x1, #0
    
    // First SVC: read TLS[0] (should be 0 initially)
    mov x1, #0          // offset = 0
    svc #16
    mov x2, x0          // Save result
    
    // Second SVC: write to TLS[0] (value from config)
    mov x1, #0          // offset = 0
    svc #17
    
    // Third SVC: read TLS[0] back
    mov x1, #0
    svc #16
    mov x3, x0          // Should be 0x1111...
    
    // Fourth SVC: write to TLS[8]
    mov x1, #8
    svc #17
    
    // Fifth SVC: read TLS[8]
    mov x1, #8
    svc #16
    mov x4, x0          // Should be 0x2222...
    
    // Sixth SVC: read TLS[0] again
    mov x1, #0
    svc #16
    mov x5, x0          // Should still be 0x1111...
    
    // Final: X0 = number of successful operations
    mov x0, #5
    
    brk #0
