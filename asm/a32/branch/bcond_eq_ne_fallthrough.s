/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000001", "R1": "0x00000002" }
}
*/
.text
.global _start
_start:
    mov r0, #0
    mov r1, #1

    cmp r1, #1
    bne skip1
    mov r0, #10
skip1:

    cmp r1, #0
    beq skip2
    mov r0, #1

skip2:
    mov r1, #2
    bkpt #0
