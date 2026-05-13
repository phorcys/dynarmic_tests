/* CONFIG
{
  "Match": "All",
  "TlsData": {
    "0x00": ["0x1111111111111111"],
    "0x08": ["0x2222222222222222"]
  },
  "RegData": {
    "X0": "0x1111111111111111",
    "X1": "0x2222222222222222"
  }
}
*/
// Test: Access TLS memory through TPIDR_EL0 base
.text
.global _start
_start:
    mrs x2, tpidr_el0    // Get TLS base
    ldr x0, [x2, #0]     // Read TLS[0]
    ldr x1, [x2, #8]     // Read TLS[1]
    brk #0
