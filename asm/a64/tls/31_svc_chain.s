/* CONFIG
{
  "Match": "All",
  "SvcTest": [
    {"svc": "32", "action": "verify_layout", "offset": "0", "value": "0x00000004", "result_reg": "X0"},
    {"svc": "17", "action": "write_tls", "offset": "16", "value": "0x46534F43"},
    {"svc": "32", "action": "verify_layout", "offset": "16", "value": "0x46534F43", "result_reg": "X1"}
  ],
  "RegData": {
    "X0": "0x1",
    "X1": "0x1"
  }
}
*/
// Test: SVC chain with verification
// Each SVC verifies or modifies state, chain continues
.text
.global _start
_start:
    // Write CommandHeader to TLS[0]
    // type = Request (4), no buf descriptors
    mrs x2, tpidr_el0
    mov w3, #4          // CommandType::Request
    str w3, [x2, #0]    // type = 4 in bits [15:0]
    mov w3, #0
    str w3, [x2, #4]    // no buf descriptors
    
    // Verify layout
    svc #32
    // X0 = 1 if valid
    
    // Write CmifOutHeader to offset 16
    mov x3, #0x4F43
    movk x3, #0x4653, lsl #16  // SFCO magic
    str x3, [x2, #16]
    
    // Verify again
    svc #32
    mov x1, x0    // X1 = verification result
    
    brk #0
