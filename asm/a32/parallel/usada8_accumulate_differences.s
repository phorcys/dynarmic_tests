/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000014" }
}
*/
.text
.global _start
_start:
    ldr r1, =0x01020304
    ldr r2, =0x00000000
    mov r3, #0
    ldr r1, =0x0A0A0A0A
    ldr r2, =0x05050505
    mov r3, #0
    usada8 r0, r1, r2, r3
    bkpt #0
.ltorg
