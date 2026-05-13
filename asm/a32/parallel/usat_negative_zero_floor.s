/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0xFFFFFFE0",
    "R1": "0x00000000",
    "R2": "0x0000000F",
    "R3": "0x0000007F"
  }
}
*/
.text
.global _start
_start:
    mvn r0, #31           @ -32
    usat r1, #4, r0       @ negative input saturates to 0

    mov r2, #0x1F
    usat r2, #4, r2       @ positive overflow saturates to 15

    mov r3, #0x7F
    usat r3, #8, r3       @ in-range value preserved

    bkpt #0
