/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00000001",
    "R1": "0x00000002",
    "R2": "0x00000004",
    "R3": "0x00000008"
  }
}
*/
.text
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
    mov r0, #1

    mov r4, #5
    cmp r4, #4
    bne 2f
    mov r1, #9
2:
    mov r1, #2

    mov r4, #5
    cmp r4, #4
    beq 3f
    mov r2, #4
3:

    mov r4, #5
    cmp r4, #5
    bne 4f
    mov r3, #8
4:
    bkpt #0
