/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x0F0F0000"
  }
}
*/
.text
.global _start
_start:
    @ ROR immediate - rotate right
    ldr r1, =0x0F00000F
    ror r0, r1, #8       @ r0 = 0x0F00000F ROR 8 = 0x0F0F0000

    bkpt #0