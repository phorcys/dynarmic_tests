/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00000110"
  }
}
*/
.text
.arm
.global _start
_start:
    @ ADD with register-shifted register (RSR)
    @ ADDS Rd, Rn, Rm, LSL Rs
    mov r1, #0x10        @ r1 = 16
    mov r2, #4           @ shift amount = 4
    add r0, r1, r1, lsl r2  @ r0 = 16 + (16 << 4) = 16 + 256 = 272 = 0x110
    bkpt #0
