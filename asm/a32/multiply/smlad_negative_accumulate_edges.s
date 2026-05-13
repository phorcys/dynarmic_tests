/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0xFFFFFFF2",
    "R1": "0x00000000",
    "R2": "0x00000016",
    "R3": "0x00000001"
  }
}
*/
.text
.global _start
_start:
    ldr r4, =0x0003FFFF    @ hi=3 lo=-1
    ldr r5, =0xFFFC0002    @ hi=-4 lo=2
    mov r6, #0
    smlad r0, r4, r5, r6   @ (-1*2) + (3*-4) = -14

    ldr r4, =0x00020003
    ldr r5, =0x00050004
    mov r6, #0
    smlad r2, r4, r5, r6   @ 22

    ldr r4, =0x00010000
    ldr r5, =0x0001FFFF
    mov r6, #0
    smlad r3, r4, r5, r6   @ -1

    bkpt #0
