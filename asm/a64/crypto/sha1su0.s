/* CONFIG
{
  "Match": "All",
  "Q0": "0x56781234567812345678123456781234"
}
*/
// Test: SHA1SU0 Vd.4S, Vn.4S, Vm.4S - SHA1 schedule update 0

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
    
    // SHA1SU0: SHA1 schedule update 0
    sha1su0 v0.4s, v1.4s, v2.4s
    
    brk #0
