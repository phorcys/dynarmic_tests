/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000006", "R1": "0x00000000" }
}
*/
.text
.global _start
_start:
    mov r0, #0
    mov r1, #0
    mov r2, #2
    mov r3, #3
    smlal r0, r1, r2, r3
    bkpt #0
