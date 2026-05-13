/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00000007",
    "R1": "0x00000001",
    "R2": "0xFFFFFFFF",
    "R3": "0x00000002"
  }
}
*/
.text
.global _start
_start:
    ldr r4, =0x00010000
    ldr r5, =0x00020000
    mov r6, #5
    smlawt r0, r4, r5, r6   @ 7

    ldr r4, =0x00010000
    ldr r5, =0x00010000
    mov r6, #0
    smlawb r1, r4, r5, r6   @ low halfword zero -> 0, use different sample below

    ldr r4, =0x00010000
    ldr r5, =0x00000001
    mov r6, #0
    smlawb r1, r4, r5, r6   @ (65536 * 1)>>16 = 1

    mvn r4, #0
    ldr r5, =0x00010000
    mov r6, #0
    smlawt r2, r4, r5, r6   @ (-1 * 1)>>16 = -1

    ldr r4, =0x00020000
    ldr r5, =0x00010000
    mov r6, #0
    smlawt r3, r4, r5, r6   @ 2

    bkpt #0
