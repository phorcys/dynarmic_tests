/* CONFIG
{
  "Match": "All",
  "VecData": { "D0": "0x0002000200020002" }
}
*/
.text
.global _start
_start:
    @ VMOVL.S8: Vector Move Long (sign extend 8-bit to 16-bit)
    @ VMOVL d0, d1 (sign extend each 8-bit element to 16-bit)
    
    mov r0, #2
    vdup.8 d1, r0           @ d1 = [2, 2, 2, 2, 2, 2, 2, 2] (8 bytes)
    
    vmovl.s8 q0, d1         @ q0 = sign extend d1 to 16-bit elements
    
    bkpt #0