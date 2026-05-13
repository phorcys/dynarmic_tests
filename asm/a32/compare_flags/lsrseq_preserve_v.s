/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00000003",
    "R2": "0x00000021"
  }
}
*/
// LSR{S} uses shifter carry-out for C and must preserve the incoming V flag.
// This regression mirrors fuzz seed 0x4a597dec:
//   lsrseq r2, ip, #26

.text
.arm
.global _start
_start:
    ldr r12, =0x87A1E588

    // Seed Z=1, C=1, V=1 so EQ passes and V must survive the instruction.
    ldr r1, =0x70000000
    msr cpsr_f, r1

    bne 1f
    movs r2, r12, lsr #26
1:

    mrs r0, cpsr
    lsr r0, r0, #28

    bkpt #0
