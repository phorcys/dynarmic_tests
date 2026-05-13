/* CONFIG
{
  "Match": "All",
  "RegData": { "D0": "0x4008000000000000" }
}
*/
.text
.global _start
_start:
    @ VMOV immediate 64-bit
    @ VMOV.F64 Dd, #imm
    
    vmov.f64 d0, #3.0    @ D0 = 3.0 = 0x4008000000000000
    
    bkpt #0
