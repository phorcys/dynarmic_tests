/* CONFIG
{
  "Match": "All",
  "RegData": { "X0": "0x0000000000000003", "X1": "0x0000000000000002", "X2": "0x0000000000000001" }
}
*/
.text
.global _start
_start:
    // ADC chain test - basic carry propagation

    // Test 1: Set carry and use ADC
    mov x0, #0xffffffffffffffff   // -1 (all 1s)
    mov x1, #1
    adds x0, x0, x1               // -1 + 1 = 0, sets C=1 (unsigned overflow)

    // Now ADC with carry set
    mov x0, #1
    adc x1, x0, xzr               // x1 = 1 + 0 + 1 = 2

    // Clear carry
    adds xzr, xzr, xzr            // 0 + 0 = 0, sets C=0

    // Test ADC without carry
    mov x0, #1
    adc x2, x0, xzr               // x2 = 1 + 0 + 0 = 1

    // Set carry again for final test
    mov x0, #0xffffffffffffffff
    adds xzr, x0, #1              // -1 + 1 = 0, sets C=1

    mov x0, #2
    adc x0, x0, xzr               // x0 = 2 + 0 + 1 = 3

    brk #0
