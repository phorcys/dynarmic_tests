/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000000", "R1": "0x00000000" }
}
*/
.text
.global _start
_start:
    mov r2, #0
    mvn r3, #0
    umull r0, r1, r2, r3
    bkpt #0
