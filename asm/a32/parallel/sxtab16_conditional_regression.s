/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R1": "0x53d16aa6",
    "R5": "0xec3043b0",
    "R7": "0xec014356"
  }
}
*/
.text
.global _start
_start:
    mov r0, #0
    cmp r0, #0      @ Z=1, so LE passes.

    ldr r1, =0x53d16aa6
    ldr r5, =0xec3043b0
    mov r7, #0

    sxtab16le r7, r5, r1

    bkpt #0
