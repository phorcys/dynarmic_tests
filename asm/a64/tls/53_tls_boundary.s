/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x1",
    "X1": "0x00FF00FF00FF00FF",
    "X2": "0x00FF00FF00FF00FF"
  }
}
*/
// Test: TLS boundary - fill region with pattern
// Tests that all TLS memory is accessible
.text
.global _start
_start:
    mrs x0, tpidr_el0
    
    // Fill 256 bytes with 0x00FF pattern
    // 0x00FF00FF00FF00FF can be loaded with movk
    mov x1, #0x00FF
    movk x1, #0x00FF, lsl #16
    movk x1, #0x00FF, lsl #32
    movk x1, #0x00FF, lsl #48
    // x1 = 0x00FF00FF00FF00FF
    
    mov x2, #0
    mov x3, #0x200      // Fill 512 bytes
    
fill_loop:
    cmp x2, x3
    b.ge fill_done
    str x1, [x0, x2]
    add x2, x2, #8
    b fill_loop
    
fill_done:
    // Verify a few locations
    ldr x4, [x0, #0]
    ldr x5, [x0, #0x100]
    ldr x6, [x0, #0x1F8]
    
    cmp x4, x1
    ccmp x5, x1, #0, eq
    ccmp x6, x1, #0, eq
    
    cset x0, eq
    mov x1, x4
    mov x2, x5
    
    brk #0
