/* CONFIG
{
  "Match": "All",
  "TlsData": {
    "0x00": ["0x00000002", "0x00000000"]
  },
  "SvcTest": [
    {"svc": "32", "action": "verify_layout", "offset": "0", "value": "0x00000002", "result_reg": "X0"}
  ],
  "RegData": {
    "X0": "0x1"
  }
}
*/
// Test: IPC Close command handling
// CommandType::Close = 2
.text
.global _start
_start:
    mrs x0, tpidr_el0
    
    // Write Close command type
    mov w1, #2          // CommandType::Close
    str w1, [x0, #0]
    mov w1, #0
    str w1, [x0, #4]
    
    // Verify
    svc #32
    // X0 = 1 (valid Close command)
    
    brk #0
