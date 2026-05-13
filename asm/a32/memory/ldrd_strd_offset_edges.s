/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x11223344",
    "R1": "0x55667788",
    "R2": "0x99AABBCC",
    "R3": "0xDDEEFF00"
  }
}
*/
.text
.global _start
_start:
    sub sp, sp, #32

    ldr r4, =0x11223344
    ldr r5, =0x55667788
    strd r4, r5, [sp, #8]
    ldrd r0, r1, [sp, #8]

    ldr r4, =0x99AABBCC
    ldr r5, =0xDDEEFF00
    strd r4, r5, [sp, #16]
    ldrd r2, r3, [sp, #16]

    add sp, sp, #32
    bkpt #0
