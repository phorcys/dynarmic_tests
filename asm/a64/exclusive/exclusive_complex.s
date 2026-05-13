/* CONFIG
{
  "Match": "All",
  "RegData": { "X0": "0x000000000000002A", "X1": "0x0000000000000000", "X5": "0x0000000000000001" }
}
*/
.text
.global _start
_start:
    // Test exclusive monitor complex scenarios

    sub sp, sp, #64

    // === Test 1: STXR after LDXR to same address (should succeed) ===
    mov x0, #0
    mov x1, #0
    mov x2, #42
    str x2, [sp]            // Store 42 at [sp]
    ldxr x0, [sp]           // Load exclusive, x0 = 42
    mov x3, #99
    stxr w1, x3, [sp]       // Store exclusive, should succeed (w1=0)

    // === Test 2: STXR after LDXR to different address (should fail) ===
    mov x4, #0
    mov x5, #1
    ldxr x4, [sp]           // Load exclusive from [sp]
    add x6, sp, #8
    ldxr x7, [x6]           // Load exclusive from [sp+8] - clears previous monitor
    mov x8, #123
    stxr w5, x8, [sp]       // Store exclusive to [sp], should fail (w5=1)

    add sp, sp, #64

    brk #0
