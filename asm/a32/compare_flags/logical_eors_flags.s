/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R2": "0x00000000",
    "R0": "0x000000F0"
  }
}
*/
.text
.global _start
_start:
    @ EORS - XOR and update flags
    mov r0, #0xFF
    mov r1, #0xFF
    eors r2, r0, r1      @ r2 = 0, Z=1

    @ EORS with non-zero result
    mov r1, #0x0F
    eors r0, r0, r1      @ r0 = 0xFF ^ 0x0F = 0xF0

    bkpt #0
