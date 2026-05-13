/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x000000FF"
  }
}
*/
.text
.global _start
_start:
    // USAT: Unsigned Saturate
    // USAT R0, #8, R1 - Saturate R1 to unsigned 8-bit range (0 to 255)
    // R1 = 300 -> saturates to 255 = 0xFF
    mov r1, #300
    usat r0, #8, r1
    bkpt #0
