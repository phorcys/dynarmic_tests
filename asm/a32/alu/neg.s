/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0xFFFFFF80"
  }
}
*/
.text
.global _start
_start:
    // SSAT: Signed Saturate (negative saturation)
    // SSAT R0, #8, R1 - Saturate R1 to signed 8-bit range (-128 to 127)
    // R1 = -200 -> saturates to -128 = 0xFFFFFF80
    mvn r1, #199      // r1 = -200
    ssat r0, #8, r1
    bkpt #0
