/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x7FFFFFFF",
    "R1": "0x80000000",
    "R2": "0x7FFF7FFF",
    "R3": "0x7FFF8000"
  }
}
*/
.text
.global _start
_start:
    ldr r4, =0x7FFFFFFF
    mov r5, #1
    qadd r0, r4, r5

    ldr r4, =0x80000000
    mov r5, #1
    qsub r1, r4, r5

    ldr r4, =0x7FFF0001
    ldr r5, =0x00017FFE
    qadd16 r2, r4, r5

    ldr r4, =0x7FFF8000
    ldr r5, =0x00000001
    qsub16 r3, r4, r5

    bkpt #0
