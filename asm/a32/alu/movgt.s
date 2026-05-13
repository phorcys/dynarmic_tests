/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000005", "R1": "0x00000003", "R2": "0x00000014" }
}
*/
.text
.global _start
_start:
    // Conditional MOV - MOVGT (Move if Greater Than)
    mov r0, #5
    mov r1, #3
    mov r2, #10

    cmp r0, r1   @ Compare 5 vs 3 -> N=0, Z=0, C=1, V=0 (5 > 3, so GT is true)
    movgt r2, #20  @ Should execute since 5 > 3

    @ R2 should be 20 (0x14)
    bkpt #0