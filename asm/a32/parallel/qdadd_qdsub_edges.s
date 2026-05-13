/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x7FFFFFFF",
    "R1": "0x80000000",
    "R2": "0x00000008",
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
    qdadd r0, r4, r5

    ldr r4, =0x80000000
    mov r5, #1
    qdsub r1, r4, r5

    mov r4, #2
    mov r5, #3
    qdadd r2, r4, r5

    mov r4, #10
    mov r5, #3
    qdsub r3, r4, r5

    bkpt #0
