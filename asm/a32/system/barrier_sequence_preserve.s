/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x0000002A", "R1": "0x0000002A" }
}
*/
.text
.global _start
_start:
    // DMB/DSB/ISB sequence preserve sample
    // These are NOPs in single-threaded context
    
    mov r0, #42
    
    // Data Memory Barrier
    dmb sy
    
    // Data Synchronization Barrier
    dsb sy
    
    // Instruction Synchronization Barrier
    isb sy
    
    // Check that R0 is unchanged
    mov r1, r0
    
    bkpt #0
