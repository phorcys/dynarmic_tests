/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00000000",
    "R1": "0x80000000",
    "R2": "0x00000000",
    "R3": "0xFFFFFFFF"
  }
}
*/
// Test: ADD - border cases and overflow

.text
.arm
.global _start
_start:
    @ Max positive + 1 = overflow to min negative
    ldr r0, =0x7FFFFFFF
    add r1, r0, #1          @ 0x80000000
    
    @ Min negative + min negative = 0 (with carry)
    ldr r0, =0x80000000
    add r2, r0, r0          @ 0x00000000 (wraparound)
    
    @ All ones + 1 = 0 (with carry)
    mvn r3, #0              @ r3 = 0xFFFFFFFF
    add r3, r3, #1          @ 0x00000000
    
    @ Reset for verification
    mov r0, #0
    ldr r1, =0x80000000
    mov r2, #0
    mvn r3, #0              @ 0xFFFFFFFF
    
    bkpt #0
