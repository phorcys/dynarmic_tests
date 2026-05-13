/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x08000000"
  }
}
*/
.text
.arm
.global _start
_start:
    @ RBIT - Reverse bits
    @ RBIT Rd, Rm
    @ Reverse the bit order in a 32-bit word
    mov r1, #0x10        @ 0x00000010 = bit 4 set
    rbit r0, r1          @ Reverse: bit 4 -> bit 27 = 0x08000000
    bkpt #0
