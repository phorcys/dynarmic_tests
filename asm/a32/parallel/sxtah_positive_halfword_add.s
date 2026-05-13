/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00008000" }
}
*/
.text
.global _start
_start:
    @ SXTAH basic add sample
    @ SXTAH Rd, Rn, Rm, ROR #n
    @ Rd = Rn + sign_extend(Rm[15:0])
    
    mov r1, #1
    ldr r2, =0x00007FFF     @ 0x7FFF = 32767
    
    sxtah r0, r1, r2        @ R0 = 1 + 32767 = 32768 = 0x8000
    
    bkpt #0
.ltorg
