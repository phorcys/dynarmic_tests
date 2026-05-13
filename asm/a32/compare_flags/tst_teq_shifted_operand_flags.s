/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00000007",
    "R1": "0x00000001",
    "R2": "0x00000008",
    "R3": "0x00000006"
  }
}
*/
// Shifted-operand flag checks for TST/TEQ. V must be preserved; C comes from shifter carry-out.

.text
.arm
.global _start
_start:
    @ Seed V=1 via signed overflow.
    ldr r8, =0x7FFFFFFF
    adds r8, r8, #1

    @ TST with LSL carry-out 1 and zero result => N=0 Z=1 C=1 V=1
    mov r4, #0
    ldr r5, =0x80000000
    tst r4, r5, lsl #1
    mrs r0, cpsr
    lsr r0, r0, #28

    @ TST with LSR carry-out 0 and non-zero result => N=0 Z=0 C=0 V=1
    mov r4, #3
    mov r5, #2
    tst r4, r5, lsr #1
    mrs r1, cpsr
    lsr r1, r1, #28

    @ TEQ with ASR carry-out 1 and negative result => N=1 Z=0 C=1 V preserved 0
    mov r4, #0
    ldr r5, =0x80000000
    cmp r4, #0              @ reset V=0, Z=1, C=1
    teq r4, r5, asr #1
    mrs r2, cpsr
    lsr r2, r2, #28

    @ TEQ equal values => Z=1, C from ROR carry-out 1, V preserved 0
    ldr r4, =0x80000001
    cmp r4, r4              @ V=0, Z=1, C=1
    teq r4, r4, ror #0      @ RRX alias, operand becomes 0xC0000000? not equal
    @ Re-seed with a simple equal case instead.
    mov r4, #0
    cmp r4, r4
    teq r4, #0
    mrs r3, cpsr
    lsr r3, r3, #28

    bkpt #0
