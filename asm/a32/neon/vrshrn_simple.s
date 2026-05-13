/* CONFIG
{
  "Match": "All",
  "VecData": { "D0": "0x0000000000020002" }
}
*/
.text
.global _start
_start:
    @ VRSHRN: Rounding Shift Right Narrow
    @ VRSHRN.I16 Dd, Qm, #imm
    
    mov r0, #6
    mov r1, #6
    vmov d1, r0, r1         @ Q1 = [6, 6]
    vmov d2, r0, r1
    
    vrshrn.i16 d0, q1, #2   @ Rounding shift: (6 + 2) >> 2 = 2
    
    bkpt #0
.ltorg
