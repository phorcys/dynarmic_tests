/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x0000000A", "R1": "0x00000000" }
}
*/
.text
.global _start
_start:
    mov r0, #2
    mov r1, #0
    mov r2, #4
    mov r3, #2
    umlal r0, r1, r2, r3
    bkpt #0
