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
    // MOVEQ: Move if equal
    mov r0, #0
    mov r2, #5
    mov r3, #5
    cmp r2, r3      // 5 == 5, so EQ condition true
    moveq r0, #0x42
    movne r0, #0xFF
    bkpt #0
