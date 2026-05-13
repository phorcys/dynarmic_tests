/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x0000002D",
    "R1": "0x0000002D"
  }
}
*/
.text
.arm
.global _start
_start:
    mov r0, #0x2A
    bl add_one
    mov r1, r0
    bkpt #0

add_one:
    push {lr}
    add r0, r0, #1
    bl add_two
    pop {pc}

add_two:
    add r0, r0, #2
    bx lr
