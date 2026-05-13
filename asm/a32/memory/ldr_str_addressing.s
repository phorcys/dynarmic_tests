/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x12345678",
    "R1": "0x12345678",
    "R2": "0xDEADBEEF",
    "R3": "0xCAFEBABE"
  }
}
*/
// Test: LDR/STR with various addressing modes

.text
.arm
.global _start
_start:
    @ Setup: allocate stack space
    sub sp, sp, #32
    
    @ Test 1: LDR/STR with immediate offset
    ldr r0, =0x12345678
    str r0, [sp, #4]        @ Store at sp+4
    ldr r1, [sp, #4]        @ Load from sp+4
    @ r1 = 0x12345678
    
    @ Test 2: LDR/STR with pre-indexed addressing
    add r2, sp, #8          @ r2 = sp+8
    ldr r3, =0xDEADBEEF
    str r3, [r2, #4]!       @ Store at r2+4, then r2 = r2+4
    @ Memory at sp+12 = 0xDEADBEEF
    ldr r3, [sp, #12]       @ Verify
    @ r3 = 0xDEADBEEF
    
    @ Test 3: LDR/STR with post-indexed addressing
    mov r4, sp
    add r4, #16             @ r4 = sp+16
    ldr r5, =0xCAFEBABE
    str r5, [r4], #4        @ Store at r4, then r4 = r4+4
    @ Memory at sp+16 = 0xCAFEBABE
    ldr r5, [sp, #16]       @ Verify
    @ r5 = 0xCAFEBABE
    
    @ Cleanup
    add sp, sp, #32
    
    @ Set expected values
    ldr r0, =0x12345678
    @ r1 already = 0x12345678
    ldr r2, =0xDEADBEEF
    ldr r3, =0xCAFEBABE
    
    bkpt #0
