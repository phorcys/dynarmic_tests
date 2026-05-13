/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "R0": "0x0000FFFE"
  }
}
*/
.text
.global _start
_start:
    // QSUB - Saturating Sub
    mov r1, #0x10000
    mov r2, #2
    qsub r0, r1, r2       // r0 = 0x10000 - 2 = 0xFFFE
    
    bkpt #0
