/* CONFIG
{
  "Match": "All",
  "VecData": { "D0": "0x0000000000010001" }
}
*/
.text
.global _start
_start:
    @ VSHRN: Shift Right Narrow
    @ VSHRN.I16 Dd, Qm, #imm
    
    mov r0, #4
    mov r1, #4
    vmov d1, r0, r1         @ Q1 = D2:D1 = [4, 4]
    vmov d2, r0, r1
    
    vshrn.i16 d0, q1, #2    @ Shift right by 2: 4 >> 2 = 1
    
    bkpt #0
.ltorg
