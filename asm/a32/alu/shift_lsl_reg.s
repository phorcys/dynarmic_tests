/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R2": "0x00000100"
  }
}
*/
.text
.global _start
_start:
    @ LSL register - shift left by register amount
    mov r0, #1
    mov r1, #8
    lsl r2, r0, r1       @ r2 = 1 << 8 = 256 = 0x100

    bkpt #0