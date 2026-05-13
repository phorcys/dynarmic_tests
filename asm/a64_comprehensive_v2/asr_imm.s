/* CONFIG
{
  "Match": "All",
  "RegData": {"X0": "0xFFFFFFFFFFFFFFF8"}
}
*/
.text
.global _start
_start:
    mov x0, #0x78      // 正数 120
    asr x0, x0, #4     // 120 >> 4 = 7 (not what we want)
    // 要测试有符号右移，需要负数
    mov x0, #0x80
    movk x0, #0, lsl #16
    movk x0, #0, lsl #32
    movk x0, #0, lsl #48   // x0 = 128
    neg x0, x0          // x0 = -128
    asr x0, x0, #4      // -128 >> 4 = -8 = 0xFFFFFFFFFFFFFFF8
    brk #0
