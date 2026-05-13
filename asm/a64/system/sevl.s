/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x000000000000002A"
  }
}
*/
// Test: SEVL - Send Event Local
// SEVL is an alias for HINT #3
// Sends an event to the local processor

.text
.global _start
_start:
    mov x0, #42
    
    // SEVL: send event to local processor
    sevl
    
    // X0 should still be 42

    brk #0
