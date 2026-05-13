/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0xFFFFFFFF"
  }
}
*/
.text
.arm
.global _start
_start:
    @ PKHBT - Pack Halfword Bottom and Top
    @ PKHBT Rd, Rn, Rm, LSL #imm
    @ Rd[15:0] = Rn[15:0], Rd[31:16] = Rm[31:16] after shift
    
    mvn r1, #0           @ r1 = 0xFFFFFFFF
    @ r2 = 0x0000FFFF
    mov r2, #0xFF
    lsl r2, r2, #8
    orr r2, r2, #0xFF
    
    pkhbt r0, r2, r1     @ r0[15:0] = r2[15:0] = 0xFFFF, r0[31:16] = r1[31:16] = 0xFFFF
    bkpt #0
