/* CONFIG
{
  "Match": "All",
  "Q0": "0x4b7a49aa4b7a49aab839645fb839645f"
}
*/
// Test: SHA256SU1 Vd.4S, Vn.4S, Vm.4S - SHA256 schedule update 1

.text
.global _start
_start:
    // Initialize test data
    mov w0, #0x1234
    movk w0, #0x5678, lsl #16
    mov v0.s[0], w0
    mov v0.s[1], w0
    mov v0.s[2], w0
    mov v0.s[3], w0
    
    mov v1.16b, v0.16b
    mov v2.16b, v0.16b
    
    // SHA256SU1: SHA256 schedule update 1
    sha256su1 v0.4s, v1.4s, v2.4s
    
    brk #0
