/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R2": "0x00010000",
    "R5": "0x00000000",
    "R4": "0x0000ffff"
  }
}
*/
.text
.global _start
_start:
    ldr r2, =0x00010000
    ldr r5, =0x00000000
    mov r4, #0

    uhasx r4, r5, r2

    bkpt #0
