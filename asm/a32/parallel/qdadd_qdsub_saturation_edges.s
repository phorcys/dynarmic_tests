/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x7FFFFFFF",
    "R1": "0x80000000",
    "R2": "0x00000100",
    "R3": "0x00000020"
  }
}
*/
.text
.global _start
_start:
    ldr r4, =0x7FFFFFFF
    mov r5, #1
    qdadd r0, r4, r5

    ldr r4, =0x80000000
    mov r5, #1
    qdsub r1, r4, r5

    mov r4, #128
    mov r5, #64
    qdadd r2, r4, r5

    mov r4, #128
    mov r5, #48
    qdsub r3, r4, r5

    bkpt #0
