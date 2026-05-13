/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000001" }
}
*/
.text
.global _start
_start:
    // Test flags through arithmetic
    // CMP sets flags
    
    mov r1, #5
    cmp r1, #4           // 5 - 4 = 1, sets N=0, Z=0, C=1, V=0
    
    // Read back flags
    mrs r0, cpsr
    lsr r0, r0, #29      // Shift C flag to bit 0
    and r0, r0, #1       // Extract C flag (should be 1)
    
    bkpt #0
