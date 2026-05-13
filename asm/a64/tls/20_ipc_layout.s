/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x46534F43"
  }
}
*/
// Test: Simulate Switch IPC message layout
// HipcHeader at offset 0, CmifOutHeader at offset 16 (16-byte aligned)
.text
.global _start
_start:
    mrs x0, tpidr_el0       // Get TLS base
    
    // Write HipcHeader (8 bytes)
    mov w1, #0
    str w1, [x0, #0]        // type = 0
    mov w1, #0x0E
    str w1, [x0, #4]        // num_data_words = 14
    
    // Write CmifOutHeader at offset 16 (16-byte aligned)
    add x1, x0, #16
    mov x2, #0x4F43
    movk x2, #0x4653, lsl #16  // builds 0x46534F43
    str x2, [x1, #0]
    mov x2, #0
    str x2, [x1, #8]        // version, result
    str x2, [x1, #16]       // token, padding
    
    // Read back magic for verification
    ldr x0, [x0, #16]
    brk #0
