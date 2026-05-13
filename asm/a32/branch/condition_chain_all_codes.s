/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00000005",
    "R1": "0x0000000A",
    "R2": "0x00000005",
    "R3": "0x00000003"
  }
}
*/
.text
.arm
.global _start
_start:
    mov r0, #0
    mov r4, #10
    cmp r4, #5
    addhi r0, r0, #1
    addcs r0, r0, #4

    mov r1, #0
    mov r4, #-1
    cmp r4, #1
    addlt r1, r1, #2
    addle r1, r1, #8

    mov r2, #0
    mov r4, #5
    cmp r4, #5
    addeq r2, r2, #1
    addge r2, r2, #4

    mov r3, #0
    ldr r4, =0x7FFFFFFF
    adds r4, r4, #1
    addvs r3, r3, #1
    addmi r3, r3, #2

    bkpt #0
