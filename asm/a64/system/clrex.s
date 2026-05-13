/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000000"
  }
}
*/
// Test: CLREX - clear exclusive monitor

.text
.global _start
_start:
    mov x0, #0
    
    // CLREX: clear local exclusive monitor
    clrex

    brk #0
