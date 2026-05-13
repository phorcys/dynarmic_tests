/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x000000000000002A"
  }
}
*/
// Test: HINT #imm - Hint instruction
// NOP is encoded as HINT #0

.text
.global _start
_start:
    mov x0, #42
    
    // HINT #0 = NOP (no operation)
    hint #0
    
    // HINT #1 = YIELD
    hint #1
    
    // HINT #2 = SEV (Send Event)
    hint #2
    
    // HINT #3 = SEVL (Send Event Local)
    hint #3
    
    // HINT #4 = WFE (Wait For Event)
    hint #4
    
    // HINT #5 = WFI (Wait For Interrupt)
    hint #5
    
    // X0 should still be 42

    brk #0
