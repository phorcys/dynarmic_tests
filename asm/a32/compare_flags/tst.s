/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000005", "R1": "0x00000001" }
}
*/
.text
.global _start
_start:
    // TST: Test Bits (AND and set flags)
    // TST R0, #imm sets flags based on R0 AND imm
    mov r0, #5          @ 0101
    mov r1, #0
    tst r0, #4          @ 0101 AND 0100 = 0100, sets Z=0

    movne r1, #1        @ Executed (Z=0)
    bkpt #0
