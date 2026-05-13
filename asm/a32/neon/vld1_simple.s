/* CONFIG
{
  "Match": "All",
  "VecData": { "D0": "0x0000000400000003" }
}
*/
.text
.global _start
_start:
    @ VLD1 - Load single-element structure to one lane
    @ Load 64-bit value to D0
    ldr r0, =data_buf
    vld1.64 {d0}, [r0]
    bkpt #0
    
data_buf:
    .word 0x00000003
    .word 0x00000004
.ltorg
