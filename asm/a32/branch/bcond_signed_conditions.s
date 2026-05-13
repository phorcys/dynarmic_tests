/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00000001",
    "R1": "0x00000002",
    "R2": "0x00000004",
    "R3": "0x00000003"
  }
}
*/
.text
.arm
.global _start
_start:
    mov r0, #0
    mov r1, #0
    mov r2, #0
    mov r3, #0

    mov r4, #5
    cmp r4, #3
    bgt 1f
    mov r0, #9
1:
    mov r0, #1

    mov r4, #-3
    cmp r4, #5
    blt 2f
    mov r1, #9
2:
    mov r1, #2

    mvn r4, #0
    cmp r4, r4
    bge 3f
    mov r2, #9
3:
    mov r2, #4

    ldr r4, =0x7FFFFFFF
    adds r4, r4, #1
    bvs 4f
    mov r3, #9
4:
    add r3, r3, #1
    bmi 5f
    mov r3, #9
5:
    add r3, r3, #2

    bkpt #0
