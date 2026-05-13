/* CONFIG
{
  "Match": "All",
  "VecData": { "D0": "0x4140000041200000", "D1": "0x0000000041600000" }
}
*/
.text
.global _start
_start:
    @ VSTM - VFP Store Multiple
    @ Set up S0-S2 with values
    ldr r0, =0x41200000
    vmov s0, r0
    ldr r0, =0x41400000
    vmov s1, r0
    ldr r0, =0x41600000
    vmov s2, r0
    @ Store S0-S2 to stack memory
    sub sp, sp, #16
    vstmia sp, {s0-s2}
    add sp, sp, #16
    bkpt #0
.ltorg
