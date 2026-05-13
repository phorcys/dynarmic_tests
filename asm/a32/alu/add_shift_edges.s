/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x80000001",
    "R1": "0x00000006",
    "R2": "0x00000002",
    "R3": "0x00000015"
  }
}
*/
.text
.arm
.global _start
_start:
    mov r4, #1
    add r0, r4, r4, lsl #31

    ldr r5, =0x80000000
    mov r1, #5
    add r1, r1, r5, lsr #31

    mov r2, #3
    add r2, r2, r5, asr #31

    mov r3, #7
    add r3, r3, r3, lsl #1

    bkpt #0
