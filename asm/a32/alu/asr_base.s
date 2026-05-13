/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0xFFFFFFFC",
    "R1": "0x00000004",
    "R2": "0xFFFFFFFF",
    "R3": "0x00000002"
  }
}
*/
// Test: ASR - arithmetic shift right (preserves sign bit)

.text
.arm
.global _start
_start:
    @ Test 1: ASR negative number (sign extension)
    @ -16 >> 2 = -4 = 0xFFFFFFFC
    mvn r4, #15             @ r4 = ~15 = 0xFFFFFFF0 = -16
    mov r0, r4, asr #2      @ -16 >> 2 = -4 = 0xFFFFFFFC
    
    @ Test 2: ASR positive number - 16 >> 2 = 4
    mov r4, #16
    mov r1, r4, asr #2
    
    @ Test 3: ASR preserves sign - -1 >> 31 = -1
    mvn r4, #0              @ r4 = -1
    mov r2, r4, asr #31     @ -1 >> 31 = -1
    
    @ Test 4: ASR positive shifted - 8 >> 2 = 2
    mov r4, #8
    mov r3, r4, asr #2
    
    bkpt #0
