/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000000"
  }
}
*/
// Test: DMB - data memory barrier

.text
.global _start
_start:
    mov x0, #0
    
    // DMB: data memory barrier
    dmb ish

    brk #0
