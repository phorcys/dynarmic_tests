/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x1"
  }
}
*/
// Test: Empty TLS - all zeros
// Verify reading from uninitialized TLS returns zero
.text
.global _start
_start:
    mrs x0, tpidr_el0
    
    // Read entire TLS region and verify it's zero
    mov x1, #0          // accumulator for comparison
    mov x2, #0          // offset counter
    mov x3, #0x100      // 256 bytes to check
    
check_loop:
    cmp x2, x3
    b.ge check_done
    
    ldr x4, [x0, x2]
    cmp x4, #0
    b.ne check_fail
    
    add x2, x2, #8
    b check_loop
    
check_fail:
    mov x0, #0
    b done
    
check_done:
    mov x0, #1          // All zeros = success
    
done:
    brk #0
