/* CONFIG
{
  "Match": "All",
  "VecData": { "D0": "0x0000000041200000" }
}
*/
.text
.global _start
_start:
    @ VSTR - VFP Store Register
    @ Store single-precision float to stack memory
    ldr r0, =0x41200000    @ 10.0 in IEEE 754
    vmov s0, r0
    @ Allocate space on stack
    sub sp, sp, #16
    vstr s0, [sp]
    add sp, sp, #16
    bkpt #0
.ltorg
