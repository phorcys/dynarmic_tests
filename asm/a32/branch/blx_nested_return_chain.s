/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x0000002A",
    "R1": "0x0000002A",
    "R2": "0x00000002"
  }
}
*/
.text
.arm
.global _start
_start:
    ldr r4, =first_level
    mov r0, #0x28
    blx r4
    mov r1, r0
    bkpt #0

first_level:
    push {lr}
    add r0, r0, #1
    mov r2, #1
    bl second_level
    pop {pc}

second_level:
    add r0, r0, #1
    add r2, r2, #1
    bx lr

.align 4
first_level_addr: .word first_level
