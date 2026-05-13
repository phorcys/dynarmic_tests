/* CONFIG
{
  "Match": "All",
  "VecData": { 
    "V0": ["0xFFFFE1D7", "0"],
    "V1": ["0xFFFFEC88", "0"],
    "V2": ["0x00000496", "0"]
  }
}
*/
.text
.global _start
_start:
    // Test SQDMULH scalar 16-bit: a = -7721, b = -4968
    // Expected result: 1170 = 0x0492
    
    // h0 = -7721 = 0xE1D7 (16-bit view)
    // h1 = -4968 = 0xEC88 (16-bit view)
    
    sqdmulh h2, h0, h1   // SQDMULH 16-bit scalar
    
    brk #0
