/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000001", "R1": "0x00000001", "R2": "0x00000002" }
}
*/
.text
.global _start
_start:
    // CMN: Compare Negative
    // CMN R0, R1 sets flags based on R0 + R1
    mov r0, #1
    mov r1, #1
    mov r2, #0
    cmn r0, r1          @ 1 + 1 = 2, sets Z=0

    moveq r2, #1        @ Not executed (Z=0)
    movne r2, #2        @ Executed (Z=0)
    bkpt #0
