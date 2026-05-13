/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00000001",
    "R2": "0xFFFFFFFF"
  }
}
*/
.text
.global _start
_start:
    @ SUBS - Subtract and update flags
    mov r0, #5
    subs r0, r0, #4      @ r0 = 1, Z=0, N=0, C=1

    @ SUBS with borrow
    mov r1, #1
    subs r2, r1, #2      @ r2 = 0xFFFFFFFF, C=0 (borrow), N=1

    bkpt #0