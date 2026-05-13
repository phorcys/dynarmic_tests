/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000005678",
    "X1": "0x0000000000005678",
    "X2": "0x0000000000009ABC"
  },
  "MemData": {
    "0x1000": ["0x0000000000001234", "0x0000000000005678", "0x0000000000009ABC"]
  }
}
*/
// Fastmem Test: Pre-index and Post-index Addressing

.text
.global _start
_start:
    ldr x4, =0x1000
    
    ldr x0, [x4, #8]!
    ldr x1, [x4], #8
    ldr x2, [x4]
    
    brk #0