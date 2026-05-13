/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000000"
  }
}
*/
// Test: DSB - data synchronization barrier

.text
.global _start
_start:
    mov x0, #0
    
    // DSB: data synchronization barrier
    dsb ish

    brk #0
