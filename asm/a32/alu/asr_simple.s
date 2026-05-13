/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0xFFFFFF80" }
}
*/
.text
.global _start
_start:
    @ ASR immediate: Arithmetic Shift Right
    @ ASR Rd, Rm, #imm
    
    mov r1, #0x80
    asr r0, r1, #0       @ ASR #0 means ASR #32
                         @ R0 = sign_extend(0x80) = 0xFFFFFF80... wait no
    
    @ Actually ASR #0 is ASR #32
    ldr r1, =0x80000000
    asr r0, r1, #4       @ R0 = 0x80000000 >> 4 (arithmetic) = 0xF8000000
    
    @ Let's use a simpler example
    mov r1, #0x80
    lsl r1, r1, #24      @ r1 = 0x80000000
    asr r0, r1, #24      @ R0 = 0x80000000 >> 24 (arithmetic) = 0xFFFFFF80
    
    bkpt #0
