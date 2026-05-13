/* CONFIG
{
  "Match": "All",
  "RegData": { "Q0": "0x00000001000000010000000100000001" }
}
*/
.text
.global _start
_start:
    @ VMOVL: Vector Move Long (sign/zero extend)
    @ VMOVL.S16 Q0, D0 - sign extend 16-bit to 32-bit
    mov r0, #1
    vdup.16 d0, r0    @ D0 = [1,1,1,1] as 16-bit
    vmovl.s16 q0, d0  @ Q0 = [1,1,1,1] as 32-bit
    bkpt #0
