// TU hot/cold relocation stress.
// This test keeps many same-page direct branches and local fallback exits in a
// single hot function so TU layout compaction must relocate direct branches.
#include "test_syscall.h"

static unsigned int rotl32(unsigned int value, unsigned int shift)
{
    return (value << shift) | (value >> (32 - shift));
}

__attribute__((noinline))
static unsigned int hot_cold_graph(unsigned int x)
{
    for (unsigned int i = 0; i < 192; i++) {
        if ((x & 1u) != 0u) {
            x = x * 1103515245u + 12345u + i;
        } else {
            x = rotl32(x ^ (0xa5a5a5a5u + i), 9);
        }

        if ((x & 0x20u) != 0u) {
            x += 0x3c6ef372u ^ (i * 13u);
        } else {
            x ^= rotl32(i * 0x1f123bb5u + 0x55aa55aau, (i & 15u) + 1u);
        }

        if ((i % 5u) == 0u) {
            x ^= x >> 7;
        } else if ((i % 5u) == 1u) {
            x += x << 3;
        } else if ((i % 5u) == 2u) {
            x = rotl32(x, 11);
        } else if ((i % 5u) == 3u) {
            x -= 0x1020304u + i;
        } else {
            x ^= 0x9e3779b9u - i;
        }
    }

    return x;
}

int test_main(void)
{
    unsigned int sum = 0xdeadbeefu;

    test_printstr("Testing TU hot/cold relocation...\n");
    for (unsigned int i = 0; i < 128; i++) {
        unsigned int v = hot_cold_graph(sum + i * 0x1009u);

        if ((i & 3u) == 0u) {
            sum ^= v;
        } else if ((i & 3u) == 1u) {
            sum += rotl32(v, 5);
        } else if ((i & 3u) == 2u) {
            sum -= v ^ 0xabcdef01u;
        } else {
            sum = rotl32(sum + v, 13);
        }
    }

    test_printstr("  checksum: ");
    test_printhex(sum);
    test_newline();

    if (sum != 0xa2e780efu) {
        test_printstr("[FAIL]\n");
        return 1;
    }

    test_pass();
    return 0;
}
