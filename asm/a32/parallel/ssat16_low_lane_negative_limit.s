/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000001", "R1": "0x0000C000" }
}
*/
.text
.global _start
_start:
    ldr r0, =0x00008000
    ssat16 r1, #15, r0
    mov r0, #1
    bkpt #0
.ltorg
