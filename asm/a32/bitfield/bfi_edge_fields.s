/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x123456AB",
    "R1": "0x34567800",
    "R2": "0x0000000F",
    "R3": "0xF0000000"
  }
}
*/
.text
.global _start
_start:
    ldr r0, =0x12345600
    mov r4, #0xAB
    bfi r0, r4, #0, #8

    mov r1, #0
    ldr r4, =0x12345678
    bfi r1, r4, #8, #24

    mov r2, #0
    mov r4, #0xFF
    bfi r2, r4, #0, #4

    mov r3, #0
    mov r4, #0xF
    bfi r3, r4, #28, #4

    bkpt #0
