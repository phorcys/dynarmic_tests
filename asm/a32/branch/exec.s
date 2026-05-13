/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00000008",
    "R1": "0x00000001"
  }
}
*/
.text
.global _start
_start:
    @ Conditional execution - EQ (equal/zero)
    mov r0, #5
    cmp r0, #5           @ Z=1 (equal)
    addeq r0, r0, #3     @ r0 = 5 + 3 = 8 (executed because Z=1)
    
    @ Conditional execution - NE (not equal)
    cmp r0, #8           @ Z=1 (equal to 8)
    movne r1, #0         @ Not executed because Z=1
    moveq r1, #1         @ r1 = 1 (executed because Z=1)

    bkpt #0
