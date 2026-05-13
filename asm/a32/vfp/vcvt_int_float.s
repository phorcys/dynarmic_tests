/* CONFIG
{
  "Match": "All",
  "RegData": { "D0": "0x3F8000003F800000" }
}
*/
.text
.global _start
_start:
    @ VCVT between integer and float
    @ VCVT.F32.S32 - convert signed int to float
    
    mov r0, #1
    vdup.32 d0, r0       @ D0 = [1, 1]
    
    vcvt.f32.s32 d0, d0  @ D0 = [1.0, 1.0] = [0x3F800000, 0x3F800000]
    
    bkpt #0