/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "R0": "0x00000042"
  }
}
*/
.text
.global _start
_start:
    // MOVNE: Move if not equal
    mov r0, #0
    mov r2, #5
    mov r3, #6
    cmp r2, r3      // 5 != 6, so NE condition true
    movne r0, #0x42
    moveq r0, #0xFF
    bkpt #0
