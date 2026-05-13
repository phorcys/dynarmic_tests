/* CONFIG
{
  "Match": "All",
  "VecData": { "D0": "0x0000000041200000" }
}
*/
.text
.global _start
_start:
    @ VLDR - VFP Load Register
    @ Load single-precision float from PC-relative address
    vldr s0, float_data
    bkpt #0
    
float_data:
    .word 0x41200000    @ 10.0 in IEEE 754
.ltorg
