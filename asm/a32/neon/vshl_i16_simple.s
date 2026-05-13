/* CONFIG
{
  "Match": "All",
  "VecData": { "D0": "0x0004000400040004" }
}
*/
.text
.global _start
_start:
    @ VSHL.I16: Vector Shift Left (immediate)
    @ VSHL d0, d1, #2
    
    mov r0, #1
    vdup.16 d1, r0          @ d1 = [1, 1, 1, 1] (4 halfwords)
    
    vshl.i16 d0, d1, #2     @ d0 = [1<<2, 1<<2, 1<<2, 1<<2] = [4, 4, 4, 4]
    
    bkpt #0