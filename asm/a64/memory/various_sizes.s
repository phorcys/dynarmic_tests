/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000034",
    "X1": "0x0000000000001234",
    "X2": "0x0000000000005678"
  },
  "MemData": {
    "0x1000": ["0x0000000000001234", "0x0000000000005678"]
  }
}
*/
// Fastmem Test: Various Load Sizes (LDRB, LDRH, LDR)

.text
.global _start
_start:
    ldr x6, =0x1000
    
    ldrb w0, [x6, #0]
    ldrh w1, [x6, #0]
    ldr x2, [x6, #8]
    
    brk #0
