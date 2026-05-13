/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x12345678", "R1": "0x00000009" }
}
*/
.text
.global _start
_start:
    ldr r0, =0x12345678
    mov r1, #9
    mov r2, #0
    mov r3, #5
    umlal r0, r1, r2, r3
    bkpt #0
.ltorg
