/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000001111",
    "X1": "0x0000000000002222",
    "X2": "0x0000000000003333",
    "X3": "0x0000000000004444",
    "X4": "0x0000000000005555",
    "X5": "0x0000000000006666"
  },
  "MemData": {
    "0x1000": ["0x0000000000001111", "0x0000000000002222", "0x0000000000003333",
               "0x0000000000004444", "0x0000000000005555", "0x0000000000006666"]
  }
}
*/
// Fastmem Test: Multiple Consecutive Memory Accesses
// Test multiple LDR/STR operations in sequence

.text
.global _start
_start:
    ldr x6, =0x1000
    
    ldr x0, [x6, #0]
    ldr x1, [x6, #8]
    ldr x2, [x6, #16]
    ldr x3, [x6, #24]
    ldr x4, [x6, #32]
    ldr x5, [x6, #40]
    brk #0