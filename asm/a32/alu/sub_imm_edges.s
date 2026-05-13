/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0xFFFFFFFF",
    "R1": "0x7FFFFFFF",
    "R2": "0x00000000",
    "R3": "0x00000001"
  }
}
*/
.text
.arm
.global _start
_start:
    mov r0, #0
    sub r0, r0, #1

    ldr r4, =0x80000000
    sub r1, r4, #1

    mov r2, #5
    sub r2, r2, #5

    ldr r3, =0x00001000
    ldr r4, =0x00000FFF
    sub r3, r3, r4

    bkpt #0
