/* CONFIG
{
  "Match": "All",
  "RegData": { "X0": "0x0000000000000010" }
}
*/
// RSB (Return Stack Buffer) overflow test
// RSB size is typically 8 entries in dynarmic
// This test creates a call chain deeper than RSB size (16 levels)
// to test proper RSB management and fallback behavior

.text
.global _start
_start:
    // RSB overflow test - 16 levels of calls (exceeds 8-entry RSB)
    // Each level adds 1 to x0, final result should be 16 (0x10)
    
    mov x0, #0              // Counter
    mov x1, #16             // Target depth (exceeds RSB size)
    bl level1
    
    brk #0

// 16 unique functions to create deep call chain
level1:
    stp x30, x19, [sp, #-16]!
    add x0, x0, #1
    cmp x0, x1
    b.eq level1_ret
    bl level2
level1_ret:
    ldp x30, x19, [sp], #16
    ret

level2:
    stp x30, x19, [sp, #-16]!
    add x0, x0, #1
    cmp x0, x1
    b.eq level2_ret
    bl level3
level2_ret:
    ldp x30, x19, [sp], #16
    ret

level3:
    stp x30, x19, [sp, #-16]!
    add x0, x0, #1
    cmp x0, x1
    b.eq level3_ret
    bl level4
level3_ret:
    ldp x30, x19, [sp], #16
    ret

level4:
    stp x30, x19, [sp, #-16]!
    add x0, x0, #1
    cmp x0, x1
    b.eq level4_ret
    bl level5
level4_ret:
    ldp x30, x19, [sp], #16
    ret

level5:
    stp x30, x19, [sp, #-16]!
    add x0, x0, #1
    cmp x0, x1
    b.eq level5_ret
    bl level6
level5_ret:
    ldp x30, x19, [sp], #16
    ret

level6:
    stp x30, x19, [sp, #-16]!
    add x0, x0, #1
    cmp x0, x1
    b.eq level6_ret
    bl level7
level6_ret:
    ldp x30, x19, [sp], #16
    ret

level7:
    stp x30, x19, [sp, #-16]!
    add x0, x0, #1
    cmp x0, x1
    b.eq level7_ret
    bl level8
level7_ret:
    ldp x30, x19, [sp], #16
    ret

level8:
    // This is the 8th level - RSB should be full at this point
    stp x30, x19, [sp, #-16]!
    add x0, x0, #1
    cmp x0, x1
    b.eq level8_ret
    bl level9
level8_ret:
    ldp x30, x19, [sp], #16
    ret

level9:
    // 9th level - oldest RSB entry should be evicted
    stp x30, x19, [sp, #-16]!
    add x0, x0, #1
    cmp x0, x1
    b.eq level9_ret
    bl level10
level9_ret:
    ldp x30, x19, [sp], #16
    ret

level10:
    stp x30, x19, [sp, #-16]!
    add x0, x0, #1
    cmp x0, x1
    b.eq level10_ret
    bl level11
level10_ret:
    ldp x30, x19, [sp], #16
    ret

level11:
    stp x30, x19, [sp, #-16]!
    add x0, x0, #1
    cmp x0, x1
    b.eq level11_ret
    bl level12
level11_ret:
    ldp x30, x19, [sp], #16
    ret

level12:
    stp x30, x19, [sp, #-16]!
    add x0, x0, #1
    cmp x0, x1
    b.eq level12_ret
    bl level13
level12_ret:
    ldp x30, x19, [sp], #16
    ret

level13:
    stp x30, x19, [sp, #-16]!
    add x0, x0, #1
    cmp x0, x1
    b.eq level13_ret
    bl level14
level13_ret:
    ldp x30, x19, [sp], #16
    ret

level14:
    stp x30, x19, [sp, #-16]!
    add x0, x0, #1
    cmp x0, x1
    b.eq level14_ret
    bl level15
level14_ret:
    ldp x30, x19, [sp], #16
    ret

level15:
    stp x30, x19, [sp, #-16]!
    add x0, x0, #1
    cmp x0, x1
    b.eq level15_ret
    bl level16
level15_ret:
    ldp x30, x19, [sp], #16
    ret

level16:
    // Final level
    stp x30, x19, [sp, #-16]!
    add x0, x0, #1
    // Don't call further, just return
    ldp x30, x19, [sp], #16
    ret
