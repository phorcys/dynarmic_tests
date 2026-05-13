/* CONFIG
{
  "Match": "All",
  "RegData": {
    "Q0": "0x00000000000000000000000000000000",
    "Q1": "0x0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F",
    "Q2": "0xF0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0"
  }
}
*/
// Test: ORN Vd.16B, Vn.16B, Vm.16B - bitwise OR NOT

.text
.global _start
_start:
    // Load Q0 with all 0s
    mov x0, #0
    mov v0.d[0], x0
    mov v0.d[1], x0
    
    // Load Q1 with 0x0F pattern
    mov x1, #0x0F0F0F0F0F0F0F0F
    mov v1.d[0], x1
    mov v1.d[1], x1
    
    // ORN: Q2 = Q0 | ~Q1
    orn v2.16b, v0.16b, v1.16b

    brk #0
