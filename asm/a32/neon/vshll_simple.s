/* CONFIG
{
  "Match": "All",
  "VecData": { "D0": "0x0000000400000004", "D1": "0x0000000000000000" }
}
*/
.text
.global _start
_start:
    @ VSHLL: Shift Left Long
    @ VSHLL.S16 Qd, Dm, #imm
    
    ldr r0, =0x00010001
    ldr r1, =0x00000000
    vmov d0, r0, r1         @ D0 = [0, 0x0001_0001]
    
    vshll.s16 q0, d0, #2    @ Shift left by 2: 1 << 2 = 4 (32-bit result)
    
    bkpt #0
.ltorg