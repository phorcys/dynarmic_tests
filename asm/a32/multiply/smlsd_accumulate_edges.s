/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00000001",
    "R1": "0x00000005",
    "R2": "0xFFFFFFFF",
    "R3": "0x00000002"
  }
}
*/
.text
.global _start
_start:
    ldr r4, =0x00010001
    ldr r5, =0x00010001
    mov r6, #1
    smlsd r0, r4, r5, r6    @ 1 + 1 - 1 = 1

    ldr r4, =0x00020003
    ldr r5, =0x00010002
    mov r6, #1
    smlsd r1, r4, r5, r6    @ 1 + 6 - 2 = 5

    ldr r4, =0x00010000
    ldr r5, =0x0001FFFF
    mov r6, #0
    smlsd r2, r4, r5, r6    @ 0 - (-1) = 1? choose different below

    ldr r4, =0x00010000
    ldr r5, =0x00010001
    mov r6, #0
    smlsd r2, r4, r5, r6    @ 0 - 1 = -1

    ldr r4, =0xFFFF0001
    ldr r5, =0x0001FFFF
    mov r6, #0
    smlsd r3, r4, r5, r6    @ -1 - (-1) = 0? choose alternate below

    ldr r4, =0xFFFF0001
    ldr r5, =0x00010001
    mov r6, #0
    smlsd r3, r4, r5, r6    @ 1 - (-1) = 2

    bkpt #0
