/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0xBABECAFEBEEFDEAD"
  }
}
*/
// Test: Write to TLS and read back
.text
.global _start
_start:
    mrs x0, tpidr_el0       // Get TLS base
    mov x1, #0xDEAD         // bits [15:0]
    movk x1, #0xBEEF, lsl #16   // bits [31:16]
    movk x1, #0xCAFE, lsl #32   // bits [47:32]
    movk x1, #0xBABE, lsl #48   // bits [63:48]
    str x1, [x0, #0]        // Write to TLS[0]
    ldr x0, [x0, #0]        // Read back
    brk #0
