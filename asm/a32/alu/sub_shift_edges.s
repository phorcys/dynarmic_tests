/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x80000000",
    "R1": "0x00000001",
    "R2": "0x00000001",
    "R3": "0x00000010"
  }
}
*/
.text
.arm
.global _start
_start:
    mov r4, #1
    mov r0, #0
    sub r0, r0, r4, lsl #31

    ldr r5, =0x80000000
    mov r1, #2
    sub r1, r1, r5, lsr #31

    mov r2, #0
    sub r2, r2, r5, asr #31

    mov r3, #21
    sub r3, r3, r3, lsr #2

    bkpt #0
