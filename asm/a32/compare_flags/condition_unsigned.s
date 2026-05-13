/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00000005",
    "R1": "0x0000000A",
    "R2": "0x00000006",
    "R3": "0x00000009"
  }
}
*/
.text
.arm
.global _start
_start:
    mov r0, #0
    mov r4, #20
    cmp r4, #10
    addhi r0, r0, #1
    addls r0, r0, #2
    addcs r0, r0, #4
    addcc r0, r0, #8

    mov r1, #0
    mov r4, #10
    cmp r4, #20
    addhi r1, r1, #1
    addls r1, r1, #2
    addcs r1, r1, #4
    addcc r1, r1, #8

    mov r2, #0
    mov r4, #10
    cmp r4, #10
    addhi r2, r2, #1
    addls r2, r2, #2
    addcs r2, r2, #4
    addcc r2, r2, #8

    mov r3, #0
    mov r4, #0
    cmp r4, #1
    addlo r3, r3, #1
    addls r3, r3, #8

    bkpt #0
