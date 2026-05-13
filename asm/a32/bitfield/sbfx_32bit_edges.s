/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0xFFFFFF80",
    "R1": "0x0000007F",
    "R2": "0xFFFFFFFF",
    "R3": "0x00000001"
  }
}
*/
.text
.arm
.global _start
_start:
    ldr r4, =0x00000080
    sbfx r0, r4, #0, #8

    ldr r4, =0x0000007F
    sbfx r1, r4, #0, #8

    ldr r4, =0x80000000
    sbfx r2, r4, #31, #1

    ldr r4, =0x40000000
    sbfx r3, r4, #30, #2

    bkpt #0
