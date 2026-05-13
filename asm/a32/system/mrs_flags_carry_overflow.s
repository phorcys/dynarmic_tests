/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x90000010",
    "R1": "0x60000010",
    "R2": "0x90000010",
    "R3": "0x60000010"
  }
}
*/
.text
.global _start
_start:
    ldr r4, =0x7FFFFFFF
    adds r4, r4, #1
    mrs r0, apsr
    mrs r2, cpsr

    mvn r5, #0
    adds r5, r5, #1
    mrs r1, apsr
    mrs r3, cpsr

    bkpt #0
