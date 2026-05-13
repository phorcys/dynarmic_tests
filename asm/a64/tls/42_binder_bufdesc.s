/* CONFIG
{
  "Match": "All",
  "TlsData": {
    "0x00": ["0x00100004", "0x00000000"],
    "0x08": ["0x00000080", "0x00000000"],
    "0x20": ["0x00001000", "0x00001000"]
  },
  "RegData": {
    "X0": "0x1",
    "X1": "0x1000"
  }
}
*/
// Test: Parse BufferDescriptorA
// CommandHeader: type=4 (bits 0-15), num_buf_a=1 (bits 20-23)
// 0x00100004 = type=4, num_buf_a=1
.text
.global _start
_start:
    mrs x0, tpidr_el0
    
    // Parse CommandHeader
    ldr w1, [x0, #0]     // type + num_buf_x + num_buf_a
    lsr w2, w1, #20      // num_buf_a (bits 20-23)
    and w2, w2, #0xF
    // w2 = 1
    
    // Buffer descriptor at offset 0x20
    ldr w3, [x0, #0x20]  // size_bits_0_31 = 0x1000
    
    // Verify num_buf_a == 1
    cmp w2, #1
    cset x0, eq
    
    mov x1, x3           // Return buffer size
    
    brk #0