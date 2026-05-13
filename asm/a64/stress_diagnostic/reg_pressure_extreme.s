/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "X0": "0x0000000000000001",
    "X1": "0x0000000000000002",
    "X2": "0x0000000000000003",
    "X3": "0x0000000000000004",
    "X4": "0x0000000000000005",
    "X5": "0x0000000000000006",
    "X6": "0x0000000000000007",
    "X7": "0x0000000000000008",
    "X8": "0x0000000000000009",
    "X9": "0x000000000000000A",
    "X10": "0x000000000000000B",
    "X11": "0x000000000000000C",
    "X12": "0x000000000000000D",
    "X13": "0x000000000000000E",
    "X14": "0x000000000000000F",
    "X15": "0x0000000000000010",
    "X16": "0x0000000000000011",
    "X17": "0x0000000000000012",
    "X18": "0x0000000000000013",
    "X19": "0x0000000000000014",
    "X20": "0x0000000000000015",
    "X21": "0x0000000000000016",
    "X22": "0x0000000000000017",
    "X23": "0x0000000000000018",
    "X24": "0x0000000000000019",
    "X25": "0x000000000000001A",
    "X26": "0x000000000000001B",
    "X27": "0x000000000000001C",
    "X28": "0x000000000000001D"
  }
}
*/
// Register pressure extreme test - ALL 29 general-purpose registers (X0-X28)
// This maximizes register allocation pressure to expose bugs in:
// 1. Register allocator using reserved registers (s0-s5)
// 2. Incorrect spill/restore of callee-saved registers
// 3. JIT state pointer (GprState/s0) corruption
//
// X0-X28 should each contain their own index (1-29)
// If any register is corrupted, the test fails

.text
.global _start
_start:
    // Initialize ALL registers with unique values
    mov x0, #1
    mov x1, #2
    mov x2, #3
    mov x3, #4
    mov x4, #5
    mov x5, #6
    mov x6, #7
    mov x7, #8
    mov x8, #9
    mov x9, #10
    mov x10, #11
    mov x11, #12
    mov x12, #13
    mov x13, #14
    mov x14, #15
    mov x15, #16
    mov x16, #17
    mov x17, #18
    mov x18, #19
    mov x19, #20
    mov x20, #21
    mov x21, #22
    mov x22, #23
    mov x23, #24
    mov x24, #25
    mov x25, #26
    mov x26, #27
    mov x27, #28
    mov x28, #29
    mov x29, #30   // FP = 30 (just for testing)
    
    // Now perform operations that require temporary registers
    // This should NOT corrupt any of the existing register values
    // because the register allocator should spill properly
    
    // Store all registers to stack temporarily
    sub sp, sp, #256
    
    stp x0, x1, [sp, #0]
    stp x2, x3, [sp, #16]
    stp x4, x5, [sp, #32]
    stp x6, x7, [sp, #48]
    stp x8, x9, [sp, #64]
    stp x10, x11, [sp, #80]
    stp x12, x13, [sp, #96]
    stp x14, x15, [sp, #112]
    stp x16, x17, [sp, #128]
    stp x18, x19, [sp, #144]
    stp x20, x21, [sp, #160]
    stp x22, x23, [sp, #176]
    stp x24, x25, [sp, #192]
    stp x26, x27, [sp, #208]
    stp x28, x29, [sp, #224]
    
    // Perform some calculations that use temporaries
    mov x0, #100
    mov x1, #200
    add x2, x0, x1      // x2 = 300
    sub x3, x1, x0      // x3 = 100
    mul x4, x0, x1      // x4 = 20000
    
    // Restore all registers
    ldp x0, x1, [sp, #0]
    ldp x2, x3, [sp, #16]
    ldp x4, x5, [sp, #32]
    ldp x6, x7, [sp, #48]
    ldp x8, x9, [sp, #64]
    ldp x10, x11, [sp, #80]
    ldp x12, x13, [sp, #96]
    ldp x14, x15, [sp, #112]
    ldp x16, x17, [sp, #128]
    ldp x18, x19, [sp, #144]
    ldp x20, x21, [sp, #160]
    ldp x22, x23, [sp, #176]
    ldp x24, x25, [sp, #192]
    ldp x26, x27, [sp, #208]
    ldp x28, x29, [sp, #224]
    
    add sp, sp, #256
    
    // At this point, all registers should still have their original values
    // X0=1, X1=2, ..., X28=29, X29=30
    
    brk #0
