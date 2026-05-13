/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x11111111",
    "R1": "0x22222222",
    "R3": "0x0000000c"
  }
}
*/
// STM base-in-list behavior.
// For STM, if the base register is in the list and writeback is specified:
// - If it is the first register in the list, the original value is stored.
// - If it is not the first register, the stored value is UNKNOWN (or original).

.text
.arm
.global _start
_start:
    sub sp, sp, #64
    mov r4, sp

    ldr r1, =0x11111111
    ldr r2, =0x22222222
    add r3, r4, #16
    mov r5, r3

    @ Case: STM with base R3 in list, with writeback.
    @ We use R3 as base, and R3 is the LAST in the list {R1, R2, R3}.
    stmia r3!, {r1, r2, r3}

    @ Check the architecturally-defined stores using a valid stack-backed base.
    ldmia r5, {r0, r1, r2}

    @ Verify writeback: final R3 must be original_base + 12.
    sub r3, r3, r5

    add sp, sp, #64
    bkpt #0
