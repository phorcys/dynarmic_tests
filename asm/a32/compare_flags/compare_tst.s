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
    // TST: Test bits (AND and set flags)
    // TST r0, r1: flags as if r0 AND r1
    // TST 0xFF, 0x0F should give Z=0 (result is 0x0F, not zero)
    mov r0, #0xFF
    tst r0, #0x0F
    // Result is non-zero, Z=0
    movne r0, #1
    moveq r0, #0
    
    bkpt #0