/* CONFIG
{
  "Match": "All",
  "TlsData": {
    "0x00": ["0x0000000000000000"],
    "0x08": ["0x0000000E00000000"]
  },
  "SvcTest": [
    {"svc": "32", "action": "verify_layout", "offset": "16", "value": "0x46534F43", "result_reg": "X0"}
  ],
  "RegData": {
    "X0": "0x1"
  }
}
*/
// Test: Full IPC request/response simulation
// 1. Code writes request to TLS
// 2. SVC callback verifies layout
// 3. Callback writes response
// 4. Code reads response
// Note: QEMU should skip this test (has SvcTest)
.text
.global _start
_start:
    mrs x0, tpidr_el0       // Get TLS base
    
    // Write HipcHeader
    mov w1, #0
    str w1, [x0, #0]
    mov w1, #0x0E           // num_data_words = 14
    str w1, [x0, #4]
    
    // Write CmifOutHeader at offset 16 (16-byte aligned)
    add x1, x0, #16
    mov x2, #0x4F43
    movk x2, #0x4653, lsl #16  // builds 0x46534F43
    str x2, [x1, #0]
    mov x2, #0
    str x2, [x1, #8]        // version=0, result=0
    str x2, [x1, #16]       // token=0
    
    // Call SVC to verify layout
    svc #32
    
    // X0 now contains verification result (1 = success)
    brk #0
