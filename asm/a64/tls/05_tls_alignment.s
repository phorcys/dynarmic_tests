/* CONFIG
{
  "Match": "All",
  "TlsData": {
    "0x10": ["0xAAAAAAAAAAAAAAAA", "0xBBBBBBBBBBBBBBBB"]
  },
  "RegData": {
    "X0": "0xAAAAAAAAAAAAAAAA",
    "X1": "0xBBBBBBBBBBBBBBBB"
  }
}
*/
// Test: 16-byte aligned access to TLS (LDP/STP)
.text
.global _start
_start:
    mrs x2, tpidr_el0       // Get TLS base
    add x2, x2, #16         // Offset 16 (16-byte aligned)
    ldp x0, x1, [x2]        // Load pair from TLS
    brk #0
