/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "X0": "0x0000000000000000",
    "X1": "0x0000000000000000"
  }
}
*/
// FLAGS preservation under register pressure
// Tests that NZCV flags are correctly computed and preserved
// even when many registers are in use

.text
.global _start
_start:
    // Use many registers to create pressure
    mov x2, #2
    mov x3, #3
    mov x4, #4
    mov x5, #5
    mov x6, #6
    mov x7, #7
    mov x8, #8
    mov x9, #9
    mov x10, #10
    mov x11, #11
    mov x12, #12
    mov x13, #13
    mov x14, #14
    mov x15, #15
    mov x16, #16
    mov x17, #17
    mov x18, #18
    mov x19, #19
    mov x20, #20
    mov x21, #21
    mov x22, #22
    mov x23, #23
    mov x24, #24
    mov x25, #25
    mov x26, #26
    mov x27, #27
    mov x28, #28
    
    // Perform operations that set flags using 32-bit add
    // 0xffffffff (32-bit) + 1 = 0 with carry
    mov w0, #0xffffffff      // Use 32-bit move
    adds w1, w0, #1          // Sets Z=1, C=1 (32-bit operation)
    
    // Now do many operations that might corrupt flags
    add x2, x2, x3
    add x4, x4, x5
    add x6, x6, x7
    add x8, x8, x9
    add x10, x10, x11
    add x12, x12, x13
    add x14, x14, x15
    
    // Verify flags are still correct using conditional
    // X0 = 0 if Z was set correctly (Z=1 means result was zero)
    mov x0, #1
    b.ne skip_z
    mov x0, #0
skip_z:
    
    brk #0