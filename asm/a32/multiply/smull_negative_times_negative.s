/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x0000000F", "R1": "0x00000000" }
}
*/
.text
.global _start
_start:
    mvn r2, #2          @ -3
    mvn r3, #4          @ -5
    smull r0, r1, r2, r3
    bkpt #0
