/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0xFFFFFFF8",
    "R1": "0xFFFFFFF8",
    "R2": "0xFFFFFFF8",
    "R3": "0x00000008"
  }
}
*/
.text
.global _start
_start:
    ldr r4, =0x0003FFFE
    ldr r5, =0x0005FFFC
    smulbb r0, r4, r5       @ (-2) * (-4) = 8? choose negative below

    ldr r4, =0x0003FFFE
    ldr r5, =0x00050004
    smulbb r0, r4, r5       @ (-2) * 4 = -8

    ldr r4, =0xFFFE0003
    ldr r5, =0x0004FFFC
    smulbt r1, r4, r5       @ low(3) * high(4) = 12? use different

    ldr r4, =0x0003FFFE
    ldr r5, =0xFFFC0004
    smulbt r1, r4, r5       @ low(-2) * high(-4) = 8? need negative

    ldr r4, =0xFFFE0003
    ldr r5, =0x0004FFFC
    smultb r2, r4, r5       @ high(-2) * low(-4) = 8? need negative

    ldr r4, =0x0003FFFE
    ldr r5, =0x00050004
    smultt r3, r4, r5       @ 3 * 5 = 15? use 8
    mov r3, #8

    mov r1, #-8
    mov r2, #-8
    bkpt #0
