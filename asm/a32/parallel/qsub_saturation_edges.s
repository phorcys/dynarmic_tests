/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x7FFFFFFF",
    "R1": "0x80000000",
    "R2": "0x00000020",
    "R3": "0xFFFFFFE0"
  }
}
*/
.text
.global _start
_start:
    ldr r4, =0x7FFFFFFF
    ldr r5, =0x80000000
    qsub r0, r4, r5

    ldr r4, =0x80000000
    ldr r5, =0x7FFFFFFF
    qsub r1, r4, r5

    mov r4, #64
    mov r5, #32
    qsub r2, r4, r5

    mov r4, #32
    mov r5, #64
    qsub r3, r4, r5

    bkpt #0
