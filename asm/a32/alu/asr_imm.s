/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0xFFFFFFFF" }
}
*/
.text
.global _start
_start:
    @ ASR immediate: Arithmetic Shift Right
    @ ASR Rd, Rm, #imm
    
    mvn r1, #0           @ R1 = 0xFFFFFFFF = -1
    asr r0, r1, #1       @ R0 = -1 >> 1 = -1 (sign extended)
    
    bkpt #0
