/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x000000000000002A"
  }
}
*/
// Test: SEV - Send Event
// SEV is an alias for HINT #2
// Sends an event to all processors in a multiprocessor system

.text
.global _start
_start:
    mov x0, #42
    
    // SEV: send event to all processors
    sev
    
    // X0 should still be 42

    brk #0
