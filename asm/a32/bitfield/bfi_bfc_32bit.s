/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x12AB5678",
    "R1": "0xFF0000FF",
    "R2": "0x00000000",
    "R3": "0xAFFFFFFF"
  }
}
*/
.text
.arm
.global _start
_start:
    ldr r0, =0x12345678
    mov r4, #0xAB
    bfi r0, r4, #16, #8

    mvn r1, #0
    bfc r1, #8, #16

    mov r2, #0
    mov r4, #0xF
    bfi r2, r4, #28, #4
    bfc r2, #28, #4

    mvn r3, #0
    mov r4, #0xA
    bfi r3, r4, #28, #4

    bkpt #0
