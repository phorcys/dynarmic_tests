/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00000008",
    "R1": "0x00000000",
    "R2": "0x0000000D",
    "R3": "0x00000000"
  }
}
*/
.text
.global _start
_start:
    mov r0, #1
    mov r1, #1
    mov r4, #2
    mov r5, #3
    umaal r0, r1, r4, r5

    mov r2, #1
    mov r3, #0
    umlal r2, r3, r4, r5
    umlal r2, r3, r4, r5

    bkpt #0
