/* CONFIG
{
  "Match": "All",
  "RegData": { "X0": "0x7FFFFFFFFFFFFFFF" },
  "VecData": {}
}
*/
.text
.global _start
_start:
    // 加载 INT64_MIN = 0x8000000000000000
    // 方法: 分步加载
    mov x1, #1
    movk x1, #0x8000, lsl #48   // x1 = 0x8000000000000001... 不对
    
    // 正确方法: 先清零高位，再设置
    mov x1, xzr                  // x1 = 0
    movk x1, #0x8000, lsl #48    // x1 = 0x8000000000000000
    
    // 加载 -1
    mov x2, #-1                  // x2 = 0xFFFFFFFFFFFFFFFF
    
    // INT64_MIN + (-1) = INT64_MAX
    add x0, x1, x2
    
    brk #0