/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x80000000",
    "R1": "0x00000000",
    "R2": "0xC0000000",
    "R3": "0x80000001"
  }
}
*/
.text
.arm
.global _start
_start:
    mov r4, #0

    cmp r4, #0
    mov r0, #0
    rrx r0, r0

    cmp r4, #1
    mov r1, #1
    rrx r1, r1

    cmp r4, #0
    ldr r2, =0x80000001
    rrx r2, r2

    cmp r4, #0
    mov r3, #2
    rrx r3, r3

    bkpt #0
