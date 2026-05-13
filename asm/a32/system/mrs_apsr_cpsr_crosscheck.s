/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00000009",
    "R1": "0x00000008",
    "R2": "0x00000006"
  }
}
*/
// MRS APSR/CPSR flags cross-check.

.text
.arm
.global _start
_start:
    ldr r4, =0x7FFFFFFF
    adds r4, r4, #1
    mrs r0, cpsr
    lsr r0, r0, #28

    mov r4, #0
    subs r4, r4, #1
    mrs r1, apsr
    lsr r1, r1, #28

    mov r4, #1
    cmp r4, #1
    mrs r2, cpsr
    lsr r2, r2, #28

    bkpt #0
