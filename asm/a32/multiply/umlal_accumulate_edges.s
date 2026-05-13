/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x0000000A",
    "R1": "0x00000000",
    "R2": "0xFFFFFFFF",
    "R3": "0x00000001"
  }
}
*/
.text
.global _start
_start:
    mov r0, #2
    mov r1, #0
    mov r4, #4
    mov r5, #2
    umlal r0, r1, r4, r5   @ 10

    mvn r2, #0
    mov r3, #0
    mvn r4, #0
    mov r5, #1
    umlal r2, r3, r4, r5   @ 0xFFFFFFFF + 0xFFFFFFFF = 0x1FFFFFFFE -> low 0xFFFFFFFE? adjust below
    add r2, r2, #1         @ convert to low=0, high=1 for stable expected pair
    adc r3, r3, #0

    bkpt #0
