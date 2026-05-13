/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000002"
  }
}
*/
// Test: TBZ - Test Bit and Branch on Zero

.text
.global _start
_start:
    mov x0, #1      // bit 2 is not set
    mov x1, #2
    
    tbz x0, #2, target
    mov x0, #1       // skip this
    
target:
    mov x0, x1       // x0 = 2

    brk #0
