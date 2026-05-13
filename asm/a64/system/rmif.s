/* CONFIG
{
  "Match": "All",
  "RegData": { "X0": "0x00000000F0000000" },
  "VecData": {}
}
*/
.text
.global _start
_start:
    // RMIF - 旋转并插入标志位
    // RMIF Xn, lsb, mask
    // 从 Xn 中提取旋转后的 bits[31:28] 插入到 NZCV
    
    // X1 = 0xF0000000_00000000 (bits [63:60] = 1111)
    mov x1, #-0x1000000000000000
    
    // 旋转 60 位后，bits[63:60] 变成 bits[3:0]，然后左移 28 位变成 bits[31:28]
    // mask = 1111 (插入所有位)
    rmif x1, #60, #15
    
    mrs x0, nzcv        // Read NZCV
    
    brk #0