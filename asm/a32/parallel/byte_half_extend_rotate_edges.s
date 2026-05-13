/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0xFFFFFF80",
    "R1": "0x00000080",
    "R2": "0xFFFF8000",
    "R3": "0x00008000"
  }
}
*/
.text
.global _start
_start:
    ldr r4, =0x80000000
    sxtb r0, r4, ror #24

    ldr r4, =0x80000000
    uxtb r1, r4, ror #24

    ldr r4, =0x80000000
    sxth r2, r4, ror #16

    ldr r4, =0x80000000
    uxth r3, r4, ror #16

    bkpt #0
