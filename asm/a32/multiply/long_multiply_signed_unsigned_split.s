/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0xFFFFFFFE",
    "R1": "0xFFFFFFFF",
    "R2": "0x00000001",
    "R3": "0x00000000"
  }
}
*/
// Long multiply boundary with sign/unsigned split.

.text
.arm
.global _start
_start:
    mvn r4, #0              @ 0xFFFFFFFF
    mov r5, #2
    smull r0, r1, r4, r5    @ -1 * 2 = -2 => high all ones, low 0xFFFFFFFE

    umull r2, r3, r4, r5    @ 0xFFFFFFFF * 2 = 0x00000001FFFFFFFE
    mov r2, r3              @ pin high word in R2
    mov r3, #0

    bkpt #0
