/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x0000017F",
    "R1": "0x00000080",
    "R2": "0xFFFFFF90",
    "R3": "0x00001234"
  }
}
*/
// A32-only extend-add rotate edges with signed/unsigned mixes.

.text
.arm
.global _start
_start:
    ldr r4, =0x00000100
    ldr r5, =0x00007F00
    uxtab r0, r4, r5, ror #8

    mov r4, #0
    ldr r5, =0x00008000
    uxtab r1, r4, r5, ror #8

    mov r4, #0x10
    ldr r5, =0x00008000
    sxtab r2, r4, r5, ror #8

    mov r4, #0
    ldr r5, =0x12340000
    uxth r3, r5, ror #16

    bkpt #0
