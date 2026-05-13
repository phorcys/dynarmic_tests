/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x000000000000002A"
  }
}
*/
// Test: WFI - Wait For Interrupt
// WFI is an alias for HINT #5
// Suspends execution until an interrupt occurs

.text
.global _start
_start:
    mov x0, #42
    
    // WFI: wait for interrupt (in QEMU this typically returns immediately)
    wfi
    
    // X0 should still be 42

    brk #0
