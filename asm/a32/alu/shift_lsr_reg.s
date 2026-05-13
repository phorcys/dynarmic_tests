/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R2": "0x00000001"
  }
}
*/
.text
.global _start
_start:
    @ LSR register - shift right by register amount
    mov r0, #0x10
    mov r1, #4
    lsr r2, r0, r1       @ r2 = 0x10 >> 4 = 1

    bkpt #0
