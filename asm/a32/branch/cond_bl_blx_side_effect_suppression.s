/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00000001",
    "R1": "0x00000002",
    "R2": "0x00000003",
    "R3": "0x00000004"
  }
}
*/
// Conditional BL/BLX-style side effects: false path must not perturb visible state.

.text
.arm
.global _start
_start:
    ldr r6, =callee

    mov r0, #0
    cmp r0, #1
    bleq callee             @ suppressed
    add r0, r0, #1

    mov r1, #0
    cmp r1, #0
    bleq callee             @ taken
    add r1, r1, #2

    mov r2, #0
    cmp r2, #1
    blxeq r6                @ suppressed
    add r2, r2, #3

    mov r3, #0
    cmp r3, #0
    blxeq r6                @ taken
    add r3, r3, #4
    bkpt #0

callee:
    bx lr
