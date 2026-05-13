/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0xFFFFFFFF",
    "R1": "0xFFFFFFFE",
    "R2": "0x00000001",
    "R3": "0xFFFFFF80"
  }
}
*/
.text
.global _start
_start:
    ldr r4, =0x80000000
    sbfx r0, r4, #31, #1

    ldr r4, =0x80000000
    sbfx r1, r4, #30, #2

    ldr r4, =0x40000000
    sbfx r2, r4, #30, #2

    ldr r4, =0x00000080
    sbfx r3, r4, #0, #8

    bkpt #0
