/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000002"
  }
}
*/
// Test: TBNZ - Test Bit and Branch on Nonzero

.text
.global _start
_start:
    mov x0, #4      // bit 2 is set
    mov x1, #2
    
    tbnz x0, #2, target
    mov x0, #1       // skip this
    
target:
    mov x0, x1       // x0 = 2

    brk #0
