/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R2": "0x81c35208",
    "R5": "0x3b576a0b",
    "R4": "0xbd1abc13"
  }
}
*/
.text
.global _start
_start:
    mov r0, #0
    cmp r0, #1      @ C=0, so CC passes.

    ldr r2, =0x81c35208
    ldr r5, =0x3b576a0b
    mov r4, #0

    uadd16cc r4, r5, r2

    bkpt #0
