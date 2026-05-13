/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x0000000B",
    "R1": "0x00000000"
  }
}
*/
.text
.global _start
_start:
    mov r0, #1
    mov r1, #0
    ldr r2, =0x00020001
    ldr r3, =0x00040003
    smlaldx r0, r1, r2, r3  @ 1 + 10 = 11
    bkpt #0
