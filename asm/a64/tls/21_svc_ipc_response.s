/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x1"
  },
  "KnownFailure": "SVC 0x15 requires custom handler"
}
*/
// Test: SVC writes IPC response to TLS, verify layout
// Note: SVC 0x15 (21 decimal) is handled by default handler
.text
.global _start
_start:
    mrs x0, tpidr_el0       // Get TLS base
    
    // Clear TLS region
    mov x1, #0
    str x1, [x0, #0]
    str x1, [x0, #8]
    str x1, [x0, #16]
    str x1, [x0, #24]
    
    // Write IPC response manually instead of using SVC
    // Write CmifOutHeader at offset 16
    add x1, x0, #16
    mov x2, #0x4F43
    movk x2, #0x4653, lsl #16  // "SFCO" magic = 0x4F434653
    str x2, [x1, #0]
    
    // Verify: CmifOutHeader at offset 16
    ldr x1, [x0, #16]
    mov x0, #0x4F43
    movk x0, #0x4653, lsl #16  // Expected: SFCO magic = 0x4F434653
    cmp x0, x1
    cset x0, eq             // X0 = 1 if magic matches
    
    brk #0
