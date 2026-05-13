/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "R0": "0x00000001"
  }
}
*/
.text
.global _start
_start:
    // MOVCS: Move if carry set (unsigned >=)
    mov r0, #0
    mov r2, #5
    mov r3, #3
    cmp r2, r3      // 5 > 3 (unsigned), so CS (carry set)
    movcs r0, #1
    movcc r0, #0
    bkpt #0
