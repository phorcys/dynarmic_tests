/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000001111",
    "X1": "0x0000000000002222",
    "X2": "0x0000000000003333",
    "X3": "0x0000000000004444"
  },
  "MemData": {
    "0x1000": ["0x0000000000001111", "0x0000000000002222", "0x0000000000003333", "0x0000000000004444"]
  }
}
*/
// Fastmem Test: LDP/STP Pair Instructions

.text
.global _start
_start:
    ldr x4, =0x1000
    
    ldp x0, x1, [x4, #0]
    ldp x2, x3, [x4, #16]
    
    brk #0