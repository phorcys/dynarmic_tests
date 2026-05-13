/* CONFIG
{
  "Match": "All",
  "TlsData": {
    "0x00": ["0x00000004", "0x00000000"],
    "0x08": ["0x00000080", "0x00000000"]
  },
  "SvcTest": [
    {"svc": "32", "action": "verify_layout", "offset": "0", "value": "0x00000004", "result_reg": "X6"},
    {"svc": "17", "action": "write_tls", "offset": "16", "value": "0x46534F43"},
    {"svc": "16", "action": "read_tls", "offset": "16", "result_reg": "X0"}
  ],
  "RegData": {
    "X0": "0x46534F43",
    "X6": "0x1"
  }
}
*/
// Test: Full IPC transaction simulation
// 1. Client prepares request in TLS
// 2. SVC call (sendSyncRequest)
// 3. Server processes, writes response to TLS
// 4. Client reads response
.text
.global _start
_start:
    mrs x0, tpidr_el0
    
    // Client: Build request
    // CommandHeader
    mov w1, #4              // type = Request
    str w1, [x0, #0]
    mov w1, #0
    str w1, [x0, #4]
    
    // data_size = 0x80
    mov w1, #0x80
    str w1, [x0, #8]
    str wzr, [x0, #12]
    
    // Send request (SVC verifies command header)
    mov x1, #0
    svc #32
    mov x6, x0              // Save verification result
    
    // Server: Write response header
    mov x1, #16
    svc #17
    
    // Client: Read response
    mov x1, #16
    svc #16
    // X0 = response data
    
    brk #0