/* CONFIG
{
  "Match": "All",
  "Q0": "0x0000000000000000ffffffffffffffff"
}
*/
// Test: FACGT Vd.2D, Vn.2D, Vm.2D - Float Absolute Compare Greater than

.text
.global _start
_start:
    // v0.2d = [2.0, -2.0]
    mov x0, #0
    movk x0, #0x4000, lsl #48  // 2.0
    mov v0.d[0], x0
    mov x0, #0
    movk x0, #0xC000, lsl #48  // -2.0
    mov v0.d[1], x0
    
    // v1.2d = [1.0, -2.0]
    mov x0, #0
    movk x0, #0x3FF0, lsl #48  // 1.0
    mov v1.d[0], x0
    mov x0, #0
    movk x0, #0xC000, lsl #48  // -2.0
    mov v1.d[1], x0
    
    // FACGT: |v0| > |v1| ?
    // |2.0| > |1.0| -> true -> all 1s
    // |-2.0| > |-2.0| -> 2.0 > 2.0 -> false -> all 0s
    facgt v0.2d, v0.2d, v1.2d
    
    brk #0
