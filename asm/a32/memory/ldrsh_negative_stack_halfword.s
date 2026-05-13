/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0xFFFF8888" }
}
*/
.text
.global _start
_start:
    sub sp, sp, #16
    ldr r2, =0x8888
    strh r2, [sp]
    ldrsh r0, [sp]
    add sp, sp, #16
    bkpt #0
