/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x00000000000000AB",
    "X1": "0x000000000000ABCD",
    "X2": "0x0000000000001111"
  },
  "MemData": {
    "0x1000": ["0x0000000000000000", "0x0000000000000000"]
  }
}
*/
// Fastmem Test: Various Store Sizes (STRB, STRH, STR)

.text
.global _start
_start:
    ldr x6, =0x1000
    
    mov w0, #0xAB
    strb w0, [x6, #0]
    
    mov w1, #0xABCD
    strh w1, [x6, #2]
    
    mov x2, #0x1111
    str x2, [x6, #8]
    
    ldrb w0, [x6, #0]
    ldrh w1, [x6, #2]
    ldr x2, [x6, #8]
    
    brk #0
