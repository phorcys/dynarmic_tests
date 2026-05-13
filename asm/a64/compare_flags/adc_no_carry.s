/* CONFIG
{
  "RegData": {
    "X0": "0x0000000000000003"
  }
}
*/
// ADC no carry in

.text
.global _start
_start:
    mov x0, #1
    mov x1, #1
    msr nzcv, xzr         // clear flags (C=0)
    adc x0, x0, x1        // 1 + 1 + 0 = 2
    add x0, x0, #1        // 3
    brk #0
