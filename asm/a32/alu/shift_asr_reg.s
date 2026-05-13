/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R2": "0xFFFFFFFF"
  }
}
*/
.text
.global _start
_start:
    @ ASR register - arithmetic shift right by register amount
    ldr r0, =0xFFFFFFF8   @ -8
    mov r1, #4
    asr r2, r0, r1       @ r2 = -8 >> 4 = -1 = 0xFFFFFFFF

    bkpt #0
