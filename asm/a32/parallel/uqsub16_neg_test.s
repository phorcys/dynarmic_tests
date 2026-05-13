/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000000" },
  "VecData": {}
}
*/
.text
.global _start
_start:
    // 测试 UQSUB16: UnsignedSaturation(0 - 1, 16) = 0
    // UQSUB16 Rd, Rn, Rm: Rd[15:0] = sat(Rn[15:0] - Rm[15:0]), Rd[31:16] = sat(Rn[31:16] - Rm[31:16])
    
    ldr r1, =0x00000000     @ [0, 0]
    ldr r2, =0x00000001     @ [1, 0]
    
    uqsub16 r0, r1, r2      @ [0-1→0, 0-0→0] = 0x00000000
    
    bkpt #0
.ltorg
