/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x0000007F",
    "R1": "0xFFFFFF80",
    "R2": "0x000000FF",
    "R3": "0x00000000"
  }
}
*/
.text
.arm
.global _start
_start:
    ldr r4, =0x00000100
    ssat r0, #8, r4

    ldr r4, =0xFFFFFF00
    ssat r1, #8, r4

    ldr r4, =0x00000123
    usat r2, #8, r4

    ldr r4, =0xFFFFFFFF
    usat r3, #8, r4

    bkpt #0
