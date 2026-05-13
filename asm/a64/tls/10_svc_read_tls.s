/* CONFIG
{
  "Match": "All",
  "TlsData": {
    "0x00": ["0xDEADBEEFCAFEBABE"]
  },
  "SvcTest": [
    {"svc": 16, "action": "read_tls", "offset": 0, "result_reg": "X0"}
  ],
  "RegData": {
    "X0": "0xDEADBEEFCAFEBABE"
  },
  "KnownFailure": "QEMU cannot simulate custom SVC handling for TLS read"
}
*/
// Test: SVC reads TLS and returns value
// This test requires dynarmic's SVC callback support
.text
.global _start
_start:
    mrs x0, tpidr_el0       // Get TLS base
    ldr x1, [x0, #0]        // Read TLS[0]
    str x1, [x0, #0]        // Write back (ensure visibility)
    mov x1, #0
    svc #16                 // SVC 0x10: read TLS[0] to X0
    brk #0
