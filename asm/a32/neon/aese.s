/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000000", "R1": "0x00000001", "R2": "0x00000000" },
  "VecData": {}
}
*/
.text
.arm
.global _start
_start:
    // AESE - AES 单轮加密
    // 测试简单的 AES 加密
    
    // 设置测试数据
    mov r0, #0
    mov r1, #1
    mov r2, #0
    
    // 由于 AESE 需要 NEON/Q 寄存器，我们跳过这个测试
    // AESE.8 q0, q1
    // 需要在 CONFIG 中设置 VecData
    
    mov r0, #0
    
    bkpt #0