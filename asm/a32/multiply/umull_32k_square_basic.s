/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x40000000", "R1": "0x00000000", "R2": "0x00008000", "R3": "0x00008000" }
}
*/
.text
.global _start
_start:
    mov r0, #0
    mov r1, #0
    mov r2, #0x8000      // R2 = 32768
    mov r3, #0x8000      // R3 = 32768
    
    // 32768 * 32768 = 0x40000000
    umull r0, r1, r2, r3
    
    bkpt #0
