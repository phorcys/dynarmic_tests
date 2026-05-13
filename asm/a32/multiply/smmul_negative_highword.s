/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0xFFFFFFFF",
    "R1": "0x00000000"
  }
}
*/
.text
.global _start
_start:
    mvn r2, #0
    mov r3, #1
    smmul r0, r2, r3      @ highword(-1 * 1) = -1

    mov r2, #1
    ldr r3, =0x10000000
    smmul r1, r2, r3      @ 0

    bkpt #0
