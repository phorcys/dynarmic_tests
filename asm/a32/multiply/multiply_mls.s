/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00000005"
  }
}
*/
.text
.arm
.global _start
_start:
    @ MLS - Multiply and Subtract
    @ MLS Rd, Rn, Rm, Ra
    @ Rd = Ra - (Rn * Rm)
    mov r1, #3           @ Rn = 3
    mov r2, #5           @ Rm = 5
    mov r3, #20          @ Ra = 20
    mls r0, r1, r2, r3   @ r0 = 20 - (3 * 5) = 5
    bkpt #0
