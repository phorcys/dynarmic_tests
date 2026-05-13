/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000009ABC",
    "X1": "0x0000000000001234",
    "X2": "0x0000000000005678"
  },
  "MemData": {
    "0x1010": ["0x0000000000001234"],
    "0x1020": ["0x0000000000005678"],
    "0x1030": ["0x0000000000009ABC"]
  }
}
*/
// Fastmem Test: Positive and Negative Offsets

.text
.global _start
_start:
    ldr x4, =0x1020
    
    ldr x0, [x4, #16]
    ldr x1, [x4, #-16]
    ldr x2, [x4, #0]
    
    brk #0
