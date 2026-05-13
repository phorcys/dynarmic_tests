/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000002"
  }
}
*/
// Test: CBNZ - Compare and Branch on Nonzero

.text
.global _start
_start:
    mov x0, #1
    mov x1, #2
    
    cbnz x0, target
    mov x0, x1       // skip this
    
target:
    mov x0, x1       // x0 = 2

    brk #0
