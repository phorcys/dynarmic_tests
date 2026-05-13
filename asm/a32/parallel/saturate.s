/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "R0": "0x7FFFFFFF",
    "R1": "0x00000001",
    "R2": "0x7FFFFFFF"
  }
}
*/
.text
.global _start
_start:
    // QADD: Saturating add - positive overflow
    ldr r0, =0x7FFFFFFF   // Max positive int32
    mov r1, #1
    qadd r2, r0, r1       // Should saturate to 0x7FFFFFFF
    
    bkpt #0
