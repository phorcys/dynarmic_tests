/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0xFFFFFF80",
    "R1": "0xFFFF8000",
    "R2": "0x00000034",
    "R3": "0x00001234"
  }
}
*/
.text
.global _start
_start:
    ldr r4, =0x80000000
    sxtb r0, r4, ror #24

    ldr r4, =0x80000000
    sxth r1, r4, ror #16

    ldr r4, =0x12340000
    sxtb r2, r4, ror #16

    ldr r4, =0x12340000
    sxth r3, r4, ror #16

    bkpt #0
