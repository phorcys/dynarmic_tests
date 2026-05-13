/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0xFF00FFFF"
  }
}
*/
.text
.arm
.global _start
_start:
    @ PKHTB - Pack Halfword Top and Bottom
    @ PKHTB Rd, Rn, Rm, ASR #imm
    @ Rd[31:16] = Rn[31:16], Rd[15:0] = Rm[15:0] after shift
    
    mvn r1, #0           @ r1 = 0xFFFFFFFF
    @ r2 = 0xFFFF0000
    mov r2, #0xFF
    lsl r2, r2, #24
    
    pkhtb r0, r2, r1     @ r0[31:16] = r2[31:16] = 0xFFFF, r0[15:0] = r1[15:0] = 0xFFFF
    bkpt #0
