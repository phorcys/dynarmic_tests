/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00000007"
  }
}
*/
.text
.global _start
_start:
    @ ADDS - Add and update flags
    mov r0, #3
    adds r0, r0, #4      @ r0 = 7, Z=0, N=0, C=0, V=0

    bkpt #0