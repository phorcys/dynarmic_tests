/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x0000FFFF" }
}
*/
.arch armv7-a
.text
.global _start
_start:
    mov r0, #0
    mvn r1, #0
    bfi r0, r1, #0, #16
    bkpt #0
