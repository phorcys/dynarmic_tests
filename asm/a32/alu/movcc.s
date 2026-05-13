/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "R0": "0x00000005",
    "R1": "0x0000000A"
  }
}
*/
.text
.global _start
_start:
    // Conditional MOV: MOVGE, MOVLT
    mov r0, #5
    mov r1, #3
    
    cmp r0, r1         // 5 > 3, so GE condition is true, LT is false
    movlt r0, #0       // Should NOT execute (LT is false), r0 stays 5
    movge r1, #10      // Should execute (GE is true), r1 = 10
    
    bkpt #0
