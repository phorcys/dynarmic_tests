/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x0000002A" }
}
*/
.text
.global _start
_start:
    // Hint instruction sequence preserve sample
    
    mov r0, #42
    
    // NOP - No Operation
    nop
    
    // YIELD - Hint that thread is doing nothing useful
    yield
    
    // WFI - Wait For Interrupt (treated as NOP in user mode)
    wfi
    
    // WFE - Wait For Event (treated as NOP in user mode)  
    wfe
    
    // SEV - Send Event (treated as NOP in single-threaded)
    sev
    
    bkpt #0
