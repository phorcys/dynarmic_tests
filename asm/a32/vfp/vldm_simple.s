/* CONFIG
{
  "Match": "All",
  "VecData": { "D0": "0x4140000041200000", "D1": "0x0000000041600000" }
}
*/
.text
.global _start
_start:
    @ VLDM - VFP Load Multiple
    ldr r0, =float_data
    vldmia r0, {s0-s2}
    bkpt #0
    
float_data:
    .word 0x41200000    @ 10.0 - S0
    .word 0x41400000    @ 12.0 - S1
    .word 0x41600000    @ 14.0 - S2
.ltorg
