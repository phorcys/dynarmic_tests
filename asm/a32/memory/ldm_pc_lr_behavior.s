/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x12345678",
    "R1": "0x00000001"
  }
}
*/
// LDM {..., pc} behavior.

.text
.arm
.global _start
_start:
    sub sp, sp, #64

    ldr r0, =0x12345678
    adr r1, return_here

    @ Push R0 and the return address (simulating LR)
    stmdb sp!, {r0, r1}

    mov r0, #0
    mov r1, #1

    @ Pop into R0 and PC. This should jump to return_here.
    ldmia sp!, {r0, pc}

    @ Should NOT reach here
    mov r1, #0xDEAD

return_here:
    add sp, sp, #64
    bkpt #0
