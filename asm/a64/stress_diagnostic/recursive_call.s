/* CONFIG
{
  "Match": "All",
  "RegData": { "X0": "0x0000000000000005" }
}
*/
.text
.global _start
_start:
    // Recursive call test - 5 levels with proper X30 preservation
    mov x0, #0
    mov x1, #5
    bl count_down
    brk #0

// Proper recursive function that saves X30 on stack
count_down:
    // Prologue: save X30 and X19 (callee-saved) on stack
    stp x30, x19, [sp, #-16]!
    
    // Body
    add x0, x0, #1
    cmp x0, x1
    b.eq done
    bl count_down
    
done:
    // Epilogue: restore X30 and X19 from stack, then return
    ldp x30, x19, [sp], #16
    ret