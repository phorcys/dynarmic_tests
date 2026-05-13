/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00000000",
    "R1": "0x00000005",
    "R2": "0x00000001",
    "R3": "0x00008000"
  }
}
*/
.text
.global _start
_start:
    ldr r4, =0x00010001
    ldr r5, =0xFFFFFFFF
    mov r6, #2
    smlad r0, r4, r5, r6    @ (-1) + (-1) + 2 = 0

    ldr r4, =0x00020003
    ldr r5, =0x00010001
    mov r6, #0
    smlad r1, r4, r5, r6    @ 3 + 2 = 5

    ldr r4, =0x00010000
    ldr r5, =0x0001FFFF
    mov r6, #0
    smlad r2, r4, r5, r6    @ 0 + (-1) = -1

    ldr r4, =0x40004000
    ldr r5, =0x00010001
    mov r6, #0
    smlad r3, r4, r5, r6    @ 0x4000 + 0x4000 = 0x8000

    bkpt #0
