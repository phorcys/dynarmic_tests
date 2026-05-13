/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x4443424144434241",
    "X1": "0x4544434241414443"
  }
}
*/
.text
.global _start
_start:
    // Test unaligned SIMD load/store
    // ARMv8 allows unaligned LDR Q / STR Q

    sub sp, sp, #64

    // Store two 64-bit values to create a 128-bit pattern
    ldr x2, =0x4443424144434241
    str x2, [sp]
    ldr x3, =0x4544434241414443
    str x3, [sp, #8]

    // Load 128-bit Q register from aligned address
    ldr q0, [sp]

    // Store Q0 back to check
    str q0, [sp, #16]

    // Load the stored values back into X registers
    ldr x0, [sp, #16]
    ldr x1, [sp, #24]

    add sp, sp, #64

    brk #0