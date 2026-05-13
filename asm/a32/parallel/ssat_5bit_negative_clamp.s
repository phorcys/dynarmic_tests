/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0xFFFFFFF0" }
}
*/
.text
.global _start
_start:
    mvn r1, #19          @ -20
    ssat r0, #5, r1
    bkpt #0
