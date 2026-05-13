/* CONFIG
{
  "Match": "All",
  "VecData": { "D0": "0x4014000000000000" }
}
*/
.text
.global _start
_start:
    @ VCMP.F64: Vector Compare (double precision)
    @ Sets FPSCR flags
    
    vmov.f64 d0, #5.0
    vmov.f64 d1, #3.0
    
    vcmp.f64 d0, d1         @ Compare 5.0 vs 3.0, sets N=0, Z=0, C=1, V=0
    
    vmrs apsr_nzcv, fpscr   @ Transfer to APSR
    
    @ D0 remains unchanged at 5.0 = 0x4014000000000000
    
    bkpt #0