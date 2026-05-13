/* CONFIG
{
  "Match": "All",
  "TlsData": {
    "0x00": ["0x8000004000000004", "0x0000000000000001", "0x0000004200000001"]
  },
  "RegData": {
    "X0": "0x1",
    "X1": "0x42"
  }
}
*/
// Test: Domain message header parsing
// CommandHeader at offset 0:
//   - raw_low = 0x00000004 (type=4)
//   - raw_high = 0x80000040 (enable_handle_descriptor=1)
// HandleDescriptorHeader at offset 8: 0x00000001 (send_pid=1)
// DomainMessageHeader at offset 16:
//   - offset 16: num_objects = 1
//   - offset 20: object_id = 0x42
//
// TlsData packed (little-endian):
//   u64 at offset 0 = 0x8000004000000004
//   u64 at offset 8 = 0x0000000000000001
//   u64 at offset 16 = 0x0000004200000001 (object_id in high 32 bits)
.text
.global _start
_start:
    mrs x0, tpidr_el0
    
    // Check enable_handle_descriptor (bit 31 of raw_high)
    ldr w1, [x0, #4]    // CommandHeader.raw_high = 0x80000040
    lsr w2, w1, #31     // enable_handle_descriptor = 1
    
    // HandleDescriptorHeader at offset 8
    ldr w3, [x0, #8]    // 0x00000001 (send_pid=1)
    
    // DomainMessageHeader at offset 16
    ldr w4, [x0, #16]   // num_objects = 1
    ldr w5, [x0, #20]   // object_id = 0x42
    
    // Verify enable_handle_descriptor == 1
    cmp w2, #1
    cset x0, eq
    
    mov x1, x5          // Return object_id
    
    brk #0
