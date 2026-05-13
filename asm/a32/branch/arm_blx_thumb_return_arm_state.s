/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00000012",
    "R1": "0x00000012",
    "R2": "0x00000000"
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
    mov r0, #0x10
    blx r4
    add r0, r0, #1
    mov r1, r0
    mrs r2, cpsr
    and r2, r2, #0x20
    bkpt #0

.thumb
.thumb_func
thumb_func:
    adds r0, #1
    bx lr
