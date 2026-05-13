/* CONFIG
{
  "Match": "All",
  "RegData": { "X0": "0x0000000000000000", "X1": "0x0000000000001234" },
  "VecData": {}
}
*/
.text
.global _start
_start:
    // LDAXR/STLXR 独占内存操作测试
    // 成功的 store 返回 0
    
    // 分配栈空间
    sub sp, sp, #16
    
    // 初始化内存
    mov x2, #0x1234
    str x2, [sp]
    
    // LDAXR - 带获取语义的独占加载
    ldaxr x1, [sp]             // x1 = 0x1234
    
    // STLXR - 带释放语义的独占存储
    mov x3, #0x5678
    stlxr w0, x3, [sp]         // w0 = 0 表示成功
    
    // 恢复栈
    add sp, sp, #16
    
    brk #0