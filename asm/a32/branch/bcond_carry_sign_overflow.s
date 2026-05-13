/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00000005",
    "R1": "0x00000003",
    "R2": "0x00000003",
    "R3": "0x00000001"
  }
}
*/
.text
.global _start
_start:
    mov r0, #0
    mov r4, #0
    cmp r4, #1
    bcc 1f
    mov r0, #9
1:
    add r0, r0, #1
    bcs 2f
    add r0, r0, #4
2:

    mov r1, #0
    mov r4, #0
    subs r4, r4, #1
    bmi 3f
    mov r1, #9
3:
    add r1, r1, #1
    bpl 4f
    add r1, r1, #2
4:

    mov r2, #0
    ldr r4, =0x7FFFFFFF
    adds r4, r4, #1
    bvs 5f
    mov r2, #9
5:
    add r2, r2, #1
    bvc 6f
    add r2, r2, #2
6:

    mov r3, #0
    ldr r4, =0x7FFFFFFF
    adds r4, r4, #1
    bmi 7f
    mov r3, #9
7:
    add r3, r3, #1
    bvs 8f
    add r3, r3, #2
8:

    bkpt #0
