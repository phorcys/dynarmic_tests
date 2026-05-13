/* CONFIG
{
  "Match": "All",
  "TlsData": {
    "0x00": ["0x00000004", "0x00000000"],
    "0x08": ["0x00000040", "0x00000000"],
    "0x10": ["0x46534F43", "0x00000000"],
    "0x20": ["0x00000001", "0x00000002", "0x00000003", "0x00000004"]
  },
  "RegData": {
    "X0": "0x46534F43",
    "X1": "0x1",
    "X2": "0x4"
  }
}
*/
// Test: Parse IPC CommandHeader and payload
// Simulates parsing a real IPC request
.text
.global _start
_start:
    mrs x0, tpidr_el0
    
    // Parse CommandHeader
    ldr w1, [x0, #0]     // type field (bits 0-15)
    and w1, w1, #0xFFFF  // extract type = 4 (Request)
    
    // Verify type == Request (4)
    cmp w1, #4
    cset x1, eq          // X1 = 1 if type == 4
    
    // Parse CmifOutHeader at offset 16
    ldr x0, [x0, #16]    // magic "SFCO" = 0x46534F43
    
    // X2 = type value
    mov x2, x1
    mov w2, w1           // Actually: w2 = type = 4
    
    // Return: X0 = magic, X1 = verification result, X2 = type
    mov w2, #4
    
    brk #0