/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000001234",
    "X1": "0x0000000000005678",
    "X2": "0x0000000000009ABC"
  },
  "MemData": {
    "0x1000": ["0x0000000000000000", "0x0000000000000000", "0x0000000000000000"]
  }
}
*/
// Fastmem Test: STR Hit Path
// Test that STR instructions work correctly through fastmem direct access

.text
.global _start
_start:
    ldr x3, =0x1000
    
    mov x0, #0x1234
    mov x1, #0x5678
    mov x2, #0x9ABC
    
    str x0, [x3]
    str x1, [x3, #8]
    str x2, [x3, #16]
    
    ldr x0, [x3]
    ldr x1, [x3, #8]
    ldr x2, [x3, #16]
    brk #0
