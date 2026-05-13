/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0xFFFFFFEB", "R1": "0xFFFFFFFF", "R2": "0x00000007", "R3": "0xFFFFFFFD" }
}
*/
.text
.global _start
_start:
    mov r0, #0           // R0 = 0 (accum low)
    mov r1, #0           // R1 = 0 (accum high)
    mov r2, #7           // R2 = 7
    mvn r3, #2           // R3 = -3
    
    // R0:R1 = R0:R1 + R2 * R3 = 0 + 7 * (-3) = -21 = 0xFFFFFFFFFFFFFFEB
    smlal r0, r1, r2, r3
    
    bkpt #0