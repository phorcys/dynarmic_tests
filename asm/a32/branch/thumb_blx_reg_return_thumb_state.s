/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00000023",
    "R2": "0x00000020"
  }
}
*/
.syntax unified
.text
.arm
.global _start
_start:
    adr r5, thumb_entry
    add r5, r5, #1
    bx r5

.thumb
.thumb_func
thumb_entry:
    adr r4, arm_func
    movs r0, #0x20
    blx r4
    adds r0, #1
    mrs r2, cpsr
    movs r3, #0x20
    ands r2, r3
    bkpt #0

.arm
arm_func:
    add r0, r0, #2
    bx lr
