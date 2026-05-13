/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000000"
  }
}
*/
// Test: ISB - instruction synchronization barrier

.text
.global _start
_start:
    mov x0, #0
    
    // ISB: instruction synchronization barrier
    isb

    brk #0
