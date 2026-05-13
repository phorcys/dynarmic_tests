/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "R0": "0x10002000"
  }
}
*/
.text
.global _start
_start:
    // QSUB16: Saturating sub of two 16-bit pairs
    ldr r0, =0x10003000
    ldr r1, =0x00001000
    qsub16 r0, r0, r1
    
    bkpt #0
