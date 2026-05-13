/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00000000",
    "R1": "0x00000001"
  }
}
*/
// VMSR writes FPSCR, VMRS reads it back.

.text
.arm
.global _start
_start:
    mov r0, #0
    vmrs r0, fpscr

    mov r1, #1
    lsl r1, r1, #22         @ set a low-risk FPSCR control bit
    vmsr fpscr, r1
    vmrs r1, fpscr
    lsr r1, r1, #22
    and r1, r1, #1

    bkpt #0
