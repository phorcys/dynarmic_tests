/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "R0": "0xFFFFC000"
  }
}
*/
.text
.global _start
_start:
    // ASR: Arithmetic shift right
    // 0x80000000 >> 17 = -2^31 >> 17 = -2^14 = -16384 = 0xFFFFC000
    ldr r0, =0x80000000
    mov r1, #17
    asr r0, r0, r1
    
    bkpt #0
.ltorg