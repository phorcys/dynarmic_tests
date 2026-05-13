/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x0000007F"
  }
}
*/
.text
.global _start
_start:
    // SSAT: Signed Saturate
    // SSAT R0, #8, R1 - Saturate R1 to signed 8-bit range (-128 to 127)
    // R1 = 200 -> saturates to 127 = 0x7F
    mov r1, #200
    ssat r0, #8, r1
    bkpt #0
