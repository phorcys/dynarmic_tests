/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x7FFFFFFF",
    "R1": "0x3FFFFFFE",
    "R2": "0x80000000",
    "R3": "0x80000000"
  }
}
*/
.text
.global _start
_start:
    ldr r4, =0x40000000
    ldr r5, =0x40000000
    qdadd r0, r4, r5

    ldr r4, =0x3FFFFFFE
    mov r5, #0
    qdadd r1, r4, r5

    ldr r4, =0x80000000
    mov r5, #1
    qdsub r2, r4, r5

    ldr r4, =0x80000000
    mov r5, #0
    qdsub r3, r4, r5

    bkpt #0
