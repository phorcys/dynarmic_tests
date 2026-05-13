/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00000001",
    "R1": "0x00000002",
    "R2": "0x00000003",
    "R3": "0x00000004"
  }
}
*/
// Branch taken / not-taken matrix for signed, unsigned and overflow paths.

.text
.arm
.global _start
_start:
    mov r0, #0
    mov r1, #0
    mov r2, #0
    mov r3, #0

    mov r4, #5
    cmp r4, #5
    beq 1f
    mov r0, #9
1:
    add r0, r0, #1

    mov r4, #5
    cmp r4, #4
    bhi 2f
    mov r1, #9
2:
    add r1, r1, #2

    mov r4, #1
    cmp r4, #5
    bge 3f
    add r2, r2, #3
3:

    ldr r4, =0x7FFFFFFF
    adds r4, r4, #1
    bvs 4f
    mov r3, #9
4:
    add r3, r3, #4

    bkpt #0
