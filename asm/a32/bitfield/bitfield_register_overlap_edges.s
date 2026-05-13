/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x12347878",
    "R1": "0xFFFFFFFF",
    "R2": "0xFFFFFFFF",
    "R3": "0x00ABAB00"
  }
}
*/
.arch armv7-a
.text
.global _start
_start:
    ldr r0, =0x12345678
    bfi r0, r0, #8, #8

    ldr r1, =0x80000000
    sbfx r1, r1, #31, #1

    mov r2, #2
    sbfx r2, r2, #1, #1

    ldr r3, =0x00ABCD00
    bfc r3, #8, #8
    mov r4, #0xAB
    bfi r3, r4, #8, #8

    bkpt #0
