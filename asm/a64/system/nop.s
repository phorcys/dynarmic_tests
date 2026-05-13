/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000000"
  }
}
*/
// Test: NOP - No Operation
// Does nothing

.text
.global _start
_start:
    mov x0, #0
    
    nop
    nop
    nop
    
    // X0 still 0

    brk #0
