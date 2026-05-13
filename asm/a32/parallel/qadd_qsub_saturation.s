/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x7FFFFFFF",
    "R1": "0x80000000",
    "R2": "0x00000003",
    "R3": "0x00000004"
  }
}
*/
.text
.arm
.global _start
_start:
    ldr r4, =0x7FFFFFFF
    mov r5, #1
    qadd r0, r4, r5

    ldr r4, =0x80000000
    mov r5, #1
    qsub r1, r4, r5

    mov r4, #1
    mov r5, #2
    qadd r2, r4, r5

    mov r4, #5
    mov r5, #1
    qsub r3, r4, r5

    bkpt #0
