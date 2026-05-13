/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00000000",
    "R1": "0x00000000",
    "R2": "0x00010000",
    "R3": "0x00010000"
  }
}
*/
.text
.global _start
_start:
    ldr r4, =0xFFFFFFFF
    usat16 r0, #15, r4

    mov r4, #0
    usat16 r1, #15, r4

    ldr r4, =0x0001FFFF
    usat16 r2, #15, r4

    ldr r4, =0x00010000
    usat16 r3, #15, r4

    bkpt #0
