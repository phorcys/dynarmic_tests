/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000037",
    "X1": "0x0000000000000001"
  }
}
*/
// Test: Callee-saved registers preservation
// Sum x19-x28 = 1+2+3+4+5+6+7+8+9+10 = 55 = 0x37

.text
.global _start
_start:
    mov x19, #1
    mov x20, #2
    mov x21, #3
    mov x22, #4
    mov x23, #5
    mov x24, #6
    mov x25, #7
    mov x26, #8
    mov x27, #9
    mov x28, #10
    
    bl clobber_func
    
    add x0, x19, x20
    add x0, x0, x21
    add x0, x0, x22
    add x0, x0, x23
    add x0, x0, x24
    add x0, x0, x25
    add x0, x0, x26
    add x0, x0, x27
    add x0, x0, x28
    
    mov x1, #1
    brk #0

clobber_func:
    stp x29, x30, [sp, #-16]!
    stp x19, x20, [sp, #-16]!
    stp x21, x22, [sp, #-16]!
    stp x23, x24, [sp, #-16]!
    stp x25, x26, [sp, #-16]!
    stp x27, x28, [sp, #-16]!
    
    mov x19, #100
    mov x20, #200
    mov x21, #300
    mov x22, #400
    mov x23, #500
    mov x24, #600
    mov x25, #700
    mov x26, #800
    mov x27, #900
    mov x28, #1000
    
    ldp x27, x28, [sp], #16
    ldp x25, x26, [sp], #16
    ldp x23, x24, [sp], #16
    ldp x21, x22, [sp], #16
    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret
