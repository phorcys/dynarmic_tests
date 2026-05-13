/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000005", "R1": "0x00000001" }
}
*/
.text
.global _start
_start:
    // TEQ: Test Equivalence (EOR and set flags)
    // TEQ R0, #imm sets flags based on R0 EOR imm
    mov r0, #5          @ 0101
    mov r1, #0
    teq r0, #5          @ 0101 EOR 0101 = 0000, sets Z=1

    moveq r1, #1        @ Executed (Z=1)
    bkpt #0
