/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000005", "R1": "0x00000006" }
}
*/
.text
.global _start
_start:
    @ VMOV: Move between two ARM registers and doubleword
    @ VMOV Rt, Rt2, Dm
    
    mov r0, #5
    mov r1, #6
    vmov d0, r0, r1         @ Move r0, r1 to d0
    
    mov r0, #0
    mov r1, #0
    
    vmov r0, r1, d0         @ Move d0 to r0, r1
    
    bkpt #0
.ltorg
