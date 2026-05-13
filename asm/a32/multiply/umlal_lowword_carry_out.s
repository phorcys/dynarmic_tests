/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000000", "R1": "0x00000001" }
}
*/
.text
.global _start
_start:
    mvn r0, #0
    mov r1, #0
    mov r2, #1
    mov r3, #1
    umlal r0, r1, r2, r3
    bkpt #0
