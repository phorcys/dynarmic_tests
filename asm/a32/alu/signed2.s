/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00000002",
    "R1": "0x00000001"
  }
}
*/
.text
.global _start
_start:
    @ Conditional execution - GT (greater than, signed)
    mov r0, #5
    mov r1, #3
    cmp r0, r1           @ N=0, Z=0, C=1, V=0 -> GT is true
    movgt r0, #2         @ r0 = 2 (executed)
    movle r1, #0         @ Not executed (LE is false)
    movgt r1, #1         @ r1 = 1 (executed)

    bkpt #0
