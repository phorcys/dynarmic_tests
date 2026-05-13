/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00000012",
    "R1": "0x00000034",
    "R2": "0x00000056",
    "R3": "0x00000078"
  }
}
*/
.text
.global _start
_start:
    ldr r4, =0x12345678
    ubfx r0, r4, #24, #8
    ubfx r1, r4, #16, #8
    ubfx r2, r4, #8, #8
    ubfx r3, r4, #0, #8
    bkpt #0
