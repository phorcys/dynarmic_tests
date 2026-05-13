/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00000000",
    "R1": "0x00000022",
    "R2": "0x00000000"
  }
}
*/
.syntax unified
.text
.arm
.global _start
_start:
    adr r4, arm_target
    adr r5, thumb_entry
    add r5, r5, #1
    bx r5

.thumb
.thumb_func
thumb_entry:
    movs r0, #0
    cmp r0, #0
    it eq
    bxeq r4
    movs r1, #0x7f
    bkpt #1

.arm
arm_target:
    mov r1, #0x22
    mrs r2, cpsr
    and r2, r2, #0x20
    bkpt #0
