/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000007", "R1": "0x0000000B" }
}
*/
.text
.global _start
_start:
    @ VMOV two registers to two scalars
    @ VMOV Rt, Rt2, Dm
    
    ldr r2, =0x0000000B00000007  @ Not valid, need different approach
    
    @ Use VMOV to move two registers to D register
    mov r0, #7
    mov r1, #11
    
    vmov d0, r0, r1      @ D0 = {r0, r1}
    
    @ Read back
    vmov r2, r3, d0
    
    mov r0, r2           @ R0 = 7
    mov r1, r3           @ R1 = 11
    
    bkpt #0
