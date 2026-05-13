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
    @ Conditional execution - HI (higher, unsigned)
    mov r0, #5
    mov r1, #3
    cmp r0, r1           @ C=1, Z=0 -> HI is true
    movhi r0, #2         @ r0 = 2 (executed)
    movls r1, #0         @ Not executed (LS is false)
    movhi r1, #1         @ r1 = 1 (executed)

    bkpt #0
