/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00000080",
    "R1": "0x00008000",
    "R2": "0x00000034",
    "R3": "0x00001234"
  }
}
*/
.text
.global _start
_start:
    ldr r4, =0x80000000
    uxtb r0, r4, ror #24

    ldr r4, =0x80000000
    uxth r1, r4, ror #16

    ldr r4, =0x12340000
    uxtb r2, r4, ror #16

    ldr r4, =0x12340000
    uxth r3, r4, ror #16

    bkpt #0
