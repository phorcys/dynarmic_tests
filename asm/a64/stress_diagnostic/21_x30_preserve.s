/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000007"
  }
}
*/
// Test: X30 should be saved before nested BL
// main -> func1 -> func2
// func1 saves X30 before calling func2

.text
.global _start
_start:
    mov x0, #1
    bl func1
    brk #0

func1:
    // Save return address (X30) to stack
    stp x30, x1, [sp, #-16]!
    add x0, x0, #2
    bl func2
    // Restore return address
    ldp x30, x1, [sp], #16
    ret

func2:
    add x0, x0, #4
    ret
