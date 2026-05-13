/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "R0": "0x00000001"
  }
}
*/
.text
.global _start
_start:
    // TEQ: Test equivalence (XOR and set flags)
    // TEQ r0, r1: flags as if r0 XOR r1
    // TEQ 0xFF, 0xF0 should give Z=0 (result is 0x0F, not zero)
    mov r0, #0xFF
    teq r0, #0xF0
    // Result is non-zero, Z=0
    movne r0, #1
    moveq r0, #0
    
    bkpt #0