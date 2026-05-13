/* CONFIG
{
  "Match": "All",
  "TlsData": {
    "0x00": ["0x00000004", "0x00000000"],
    "0x08": ["0x00000020", "0x00000000"]
  },
  "SvcTest": [
    {"svc": "32", "action": "verify_layout", "offset": "0", "value": "0x00000004", "result_reg": "X5"},
    {"svc": "17", "action": "write_tls", "offset": "16", "value": "0x46534F43"},
    {"svc": "16", "action": "read_tls", "offset": "16", "result_reg": "X0"}
  ],
  "RegData": {
    "X0": "0x46534F43",
    "X5": "0x1"
  }
}
*/
// Test: Full IPC request-response cycle
// Simulates client sending request, server responding
.text
.global _start
_start:
    mrs x0, tpidr_el0
    
    // Client: Build request
    mov w1, #4          // CommandType::Request
    str w1, [x0, #0]    // type
    mov w1, #0
    str w1, [x0, #4]    // no buffer descriptors
    
    mov w1, #0x20       // data_size = 32
    str w1, [x0, #8]
    
    // Send request (verify layout)
    mov x1, #0
    svc #32
    mov x5, x0          // X5 = 1 if valid
    
    // Server: Write response header
    mov x1, #16
    svc #17
    
    // Read response
    mov x1, #16
    svc #16
    // X0 = response data
    
    brk #0