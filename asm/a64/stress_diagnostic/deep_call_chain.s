/* CONFIG
{
  "Match": "All",
  "RegData": { "X0": "0x0000000000000014" }
}
*/
.text
.global _start
_start:
    // Deep call chain test - 20 levels with proper X30 preservation
    // Each level adds 1 to x0, final result should be 20 (0x14)

    mov x0, #0              // Counter
    mov x1, #20             // Target depth
    bl chain_start

    brk #0

chain_start:
    // Prologue: save X30 on stack
    stp x30, x19, [sp, #-16]!
    
    add x0, x0, #1
    cmp x0, x1
    b.eq chain_start_done
    bl chain_next
chain_start_done:
    // Epilogue: restore X30 and return
    ldp x30, x19, [sp], #16
    ret

chain_next:
    // Prologue: save X30 on stack
    stp x30, x19, [sp, #-16]!
    
    add x0, x0, #1
    cmp x0, x1
    b.eq chain_next_done
    bl chain_start
chain_next_done:
    // Epilogue: restore X30 and return
    ldp x30, x19, [sp], #16
    ret
