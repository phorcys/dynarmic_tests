/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00000042",
    "R1": "0x00000020"
  }
}
*/
.syntax unified
.text
.arm
.global _start
_start:
    adr r4, thumb_func
    add r4, r4, #1
    blx r4

arm_wrong_target:
    mov r0, #0x7f
    bkpt #1

.thumb
.thumb_func
thumb_func:
    adr r5, thumb_landing
    adds r5, #1
    mov lr, r5
    bx lr

thumb_landing:
    movs r0, #0x42
    mrs r1, cpsr
    movs r2, #0x20
    ands r1, r2
    bkpt #0
