/* CONFIG
{
  "Match": "All",
  "SvcTest": [
    {"svc": "17", "action": "write_tls", "offset": "0", "value": "0xCAFEBABE12345678"}
  ],
  "RegData": {
    "X0": "0xCAFEBABE12345678"
  }
}
*/
// Test: SVC writes to TLS, then read back in code
// Note: QEMU should skip this test (has SvcTest)
.text
.global _start
_start:
    mrs x0, tpidr_el0       // Get TLS base
    mov x1, #0
    str x1, [x0, #0]        // Clear TLS[0]
    svc #17                 // SVC 0x11: write to TLS[0]
    ldr x0, [x0, #0]        // Read back
    brk #0
