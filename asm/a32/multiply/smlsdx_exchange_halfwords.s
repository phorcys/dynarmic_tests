/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00000003"
  }
}
*/
.text
.global _start
_start:
    mov r3, #5
    ldr r1, =0x00020001
    ldr r2, =0x00040003
    smlsdx r0, r1, r2, r3   @ 5 + (1*4 - 2*3) = 3
    bkpt #0
