/* CONFIG
{
  "Match": "All",
  "RegData": { "X0": "0x0000000000000004" }
}
*/
// RSB pollution test - tests RSB with non-return jumps
// Simplified version without literal pool loads

.text
.global _start
_start:
    // Test 1: Normal BL/RET sequence
    mov x0, #0
    bl normal_func
    // x0 = 1 now
    
    // Test 2: BLR (indirect call) using ADRP+ADD
    adrp x2, indirect_func
    add x2, x2, :lo12:indirect_func
    blr x2
    // x0 = 2 now
    
    // Test 3: Multiple calls to different functions
    bl func_a
    // x0 = 3
    bl func_b
    // x0 = 4
    
    brk #0

normal_func:
    add x0, x0, #1
    ret

indirect_func:
    add x0, x0, #1
    ret

func_a:
    add x0, x0, #1
    ret

func_b:
    add x0, x0, #1
    ret