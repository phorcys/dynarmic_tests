/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0xFFFFFFFF",
    "R1": "0x00000008",
    "R2": "0x00000005",
    "R3": "0x00000008"
  }
}
*/
.text
.global _start
_start:
    ldr r4, =0x00030002
    ldr r5, =0x00050007
    smusd r0, r4, r5

    mov r6, #9
    smlsd r1, r4, r5, r6

    ldr r4, =0x00010002
    ldr r5, =0x00030004
    mov r6, #0
    smlsd r2, r4, r5, r6

    mov r6, #3
    smlsd r3, r4, r5, r6

    bkpt #0
