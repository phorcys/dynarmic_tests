/* CONFIG
{
  "Match": "All",
  "TlsData": {
    "0x00": ["0x00000000", "0x00000000"]
  },
  "SvcTest": [
    {"svc": "32", "action": "verify_layout", "offset": "0", "value": "0x00000001", "result_reg": "X0"}
  ],
  "RegData": {
    "X0": "0x0"
  }
}
*/
// Test: IPC error handling - invalid command type (0 = Invalid)
// Should fail verification
.text
.global _start
_start:
    mrs x0, tpidr_el0
    
    // Write invalid command type
    mov w1, #0          // CommandType::Invalid
    str w1, [x0, #0]
    
    // Try to verify - should return 0 (invalid)
    svc #32
    // X0 = 0 (verification failed)
    
    brk #0
