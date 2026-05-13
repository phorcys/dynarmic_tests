/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x3FFF3FFF",
    "R1": "0xC000C000",
    "R2": "0x3FFFC000",
    "R3": "0x0001FFFF"
  }
}
*/
.text
.global _start
_start:
    ldr r4, =0x7FFF7FFF
    ssat16 r0, #15, r4

    ldr r4, =0x80008000
    ssat16 r1, #15, r4

    ldr r4, =0x7FFF8000
    ssat16 r2, #15, r4

    ldr r4, =0x0001FFFF
    ssat16 r3, #16, r4

    bkpt #0
