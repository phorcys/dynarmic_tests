/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000001" }
}
*/
.text
.global _start
_start:
    @ MOVW: Move Wide (16-bit immediate)
    movw r0, #0x1234
    
    @ AND with mask to verify
    ldr r1, =0xFFFF
    and r0, r0, r1     @ R0 = 0x1234 & 0xFFFF = 0x1234
    
    @ Test bit 12 set
    movw r0, #0x1000
    mov r0, r0, LSR #12   @ R0 = 1
    
    bkpt #0
.ltorg
