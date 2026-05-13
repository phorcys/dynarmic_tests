/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x7FFFFFFF"
  }
}
*/
.text
.global _start
_start:
    // QADD: Saturating Add
    // QADD R0, R1, R2 - R0 = saturate(R1 + R2)
    // R1 = 0x7FFFFFFF, R2 = 1 -> saturates to 0x7FFFFFFF
    ldr r1, =0x7FFFFFFF
    mov r2, #1
    qadd r0, r1, r2
    bkpt #0
