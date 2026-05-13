/* CONFIG
{
  "RegData": {
    "X0": "0x0000000000000003"
  }
}
*/
// ADC with carry in

.text
.global _start
_start:
    mov x0, #1
    mov x1, #1
    cmp xzr, xzr          // set C=1 (0 >= 0)
    adc x0, x0, x1        // 1 + 1 + 1 = 3
    brk #0
