/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x0000000D", "R1": "0x00000000" }
}
*/
.text
.global _start
_start:
    mov r0, #1
    mov r1, #0
    mov r2, #2
    mov r3, #3
    umlal r0, r1, r2, r3
    umlal r0, r1, r2, r3
    bkpt #0
