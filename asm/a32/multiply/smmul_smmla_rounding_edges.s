/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x10000000",
    "R1": "0x10000001",
    "R2": "0xE0000000",
    "R3": "0xE0000001"
  }
}
*/
.text
.global _start
_start:
    ldr r4, =0x40000000
    ldr r5, =0x40000000
    smmul r0, r4, r5

    ldr r4, =0x40000000
    ldr r5, =0x40000000
    mov r6, #1
    smmla r1, r4, r5, r6

    ldr r4, =0x80000000
    ldr r5, =0x40000000
    smmul r2, r4, r5

    ldr r4, =0x80000000
    ldr r5, =0x40000000
    mov r6, #1
    smmla r3, r4, r5, r6

    bkpt #0
