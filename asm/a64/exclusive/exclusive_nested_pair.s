/* CONFIG
{
  "Match": "All",
  "RegData": { "X0": "0x0000000000000001" }
}
*/
// Test: Nested LDXP - second LDXP clears first monitor

.text
.global _start
_start:
    sub sp, sp, #32

    // Setup: Store pair values
    mov x2, #0x1111
    mov x3, #0x2222
    stp x2, x3, [sp]
    add x12, sp, #16

    // First LDXP at [sp]
    ldxp x6, x7, [sp]

    // Second LDXP at [sp+16] - should clear first monitor
    ldxp x8, x9, [x12]

    // STXP to [sp] should fail (monitor was cleared)
    mov x10, #0x5555
    mov x11, #0x6666
    stxp w0, x10, x11, [sp]     // w0 should be 1 (fail)

    add sp, sp, #32

    brk #0
