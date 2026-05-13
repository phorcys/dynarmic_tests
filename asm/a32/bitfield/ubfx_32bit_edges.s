/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00000078",
    "R1": "0x00000056",
    "R2": "0x00000012",
    "R3": "0x0000000F"
  }
}
*/
.text
.arm
.global _start
_start:
    ldr r4, =0x12345678
    ubfx r0, r4, #0, #8
    ubfx r1, r4, #8, #8
    ubfx r2, r4, #24, #8

    ldr r4, =0xF0000000
    ubfx r3, r4, #28, #4

    bkpt #0
