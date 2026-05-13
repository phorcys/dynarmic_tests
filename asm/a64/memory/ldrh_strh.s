/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x000000000000BEEF",
    "X1": "0x000000000000DEAD"
  }
}
*/
// Test: LDRH W0, [X1] - load halfword (zero-extend)

.text
.global _start
_start:
    // Allocate stack space
    sub sp, sp, #32

    // Store halfwords: 0xBEEF at offset 0, 0xDEAD at offset 2
    mov w0, #0xBEEF
    strh w0, [sp]

    mov w0, #0xDEAD
    strh w0, [sp, #2]

    // Move stack pointer to X1
    mov x1, sp

    // Load halfword (should zero-extend)
    ldrh w0, [x1]

    // Load another halfword at offset 2
    ldrh w1, [x1, #2]

    add sp, sp, #32

    brk #0