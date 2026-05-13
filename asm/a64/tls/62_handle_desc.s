/* CONFIG
{
  "Match": "All",
  "TlsData": {
    "0x00": ["0x8000004000000004", "0x0000000000000001"]
  },
  "RegData": {
    "X0": "0x1",
    "X1": "0x0",
    "X2": "0x0"
  }
}
*/
// Test: Handle descriptor parsing
// CommandHeader at offset 0:
//   - offset 0: raw_low = 0x00000004 (type=4)
//   - offset 4: raw_high = 0x80000040 (bit 31 = 1, data_size = 0x40)
// HandleDescriptorHeader at offset 8:
//   - value = 0x00000001 (send_pid=1, num_copy=0, num_move=0)
//
// TlsData: u64 at offset 0 = 0x8000004000000004 (little-endian packed)
// u64 at offset 8 = 0x0000000000000001
.text
.global _start
_start:
    mrs x0, tpidr_el0
    
    // Check enable_handle_descriptor (bit 31 of raw_high)
    ldr w1, [x0, #4]    // CommandHeader.raw_high = 0x80000040
    lsr w2, w1, #31     // enable_handle_descriptor = 1
    
    // HandleDescriptorHeader at offset 8
    ldr w3, [x0, #8]    // 0x00000001
    // bit 0: send_current_pid = 1
    and w4, w3, #0x1    // send_pid = 1
    // bits 1-4: num_handles_to_copy
    and w5, w3, #0x1E
    lsr w5, w5, #1      // num_copy = 0
    // bits 5-8: num_handles_to_move
    and w6, w3, #0x1E0
    lsr w6, w6, #5      // num_move = 0
    
    // Verify enable_handle_descriptor == 1
    cmp w2, #1
    cset x0, eq
    
    mov x1, x5          // Return num_handles_to_copy = 0
    mov x2, x6          // Return num_handles_to_move = 0
    
    brk #0
