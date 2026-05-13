/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x000000000000002A"
  }
}
*/
// Test: WFE - Wait For Event
// WFE is an alias for HINT #4
// Suspends execution until an event occurs

.text
.global _start
_start:
    mov x0, #42
    
    // WFE: wait for event (in QEMU this typically returns immediately)
    wfe
    
    // X0 should still be 42

    brk #0
