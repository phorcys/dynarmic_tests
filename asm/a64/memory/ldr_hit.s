/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000001234",
    "X1": "0x0000000000005678",
    "X2": "0x0000000000009ABC"
  },
  "MemData": {
    "0x1000": ["0x0000000000001234", "0x0000000000005678", "0x0000000000009ABC"]
  }
}
*/
// Fastmem Test: LDR Hit Path
// Test that LDR instructions work correctly through fastmem direct access

.text
.global _start
_start:
    ldr x3, =0x1000
    ldr x0, [x3]
    ldr x1, [x3, #8]
    ldr x2, [x3, #16]
    brk #0
