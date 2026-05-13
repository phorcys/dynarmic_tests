/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "R0": "0x80000000",
    "R1": "0x00000001",
    "R2": "0x80000000"
  }
}
*/
.text
.global _start
_start:
    // QSUB: Saturating subtract - negative overflow
    ldr r0, =0x80000000   // Min negative int32 (-2147483648)
    mov r1, #1
    qsub r2, r0, r1       // -2147483648 - 1 = -2147483649, saturates to -2147483648
    
    bkpt #0