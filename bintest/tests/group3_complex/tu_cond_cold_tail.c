// TU conditional-edge cold-tail stress.
// Exercises two-edge conditional TU links and fallback stubs generated after
// both taken and not-taken paths.
#include "test_syscall.h"

static unsigned int rotl32(unsigned int value, unsigned int shift)
{
    return (value << shift) | (value >> (32 - shift));
}

__attribute__((noinline))
static unsigned int cond_pair(unsigned int x, unsigned int salt)
{
    for (unsigned int i = 0; i < 160; i++) {
        if (((x + salt + i) & 4u) != 0u) {
            x += (i + 1u) * 3u;
            if ((x & 0x80u) != 0u) {
                x ^= 0x7f4a7c15u + i;
            } else {
                x = rotl32(x ^ salt, 7);
            }
        } else {
            x ^= rotl32(salt + i * 0x1021u, (i & 7u) + 1u);
            if ((x & 0x1000u) == 0u) {
                x += 0x31415927u ^ i;
                continue;
            }
            x -= 0x27182818u + i * 5u;
        }

        if ((x & 0x20000u) != 0u) {
            x = rotl32(x + 0x9e3779b9u, 3);
        } else {
            x ^= (x >> 11) + 0x85ebca6bu;
        }
    }

    return x;
}

int test_main(void)
{
    unsigned int sum = 0x2468ace0u;

    test_printstr("Testing TU conditional cold tail...\n");
    for (unsigned int i = 0; i < 96; i++) {
        unsigned int v = cond_pair(sum ^ i, 0x10001u + i * 97u);

        if ((v & 1u) != 0u) {
            sum += rotl32(v, (i & 15u) + 1u);
        } else {
            sum ^= v + i * 0x45d9f3bu;
        }
    }

    test_printstr("  checksum: ");
    test_printhex(sum);
    test_newline();

    if (sum != 0x948020e2u) {
        test_printstr("[FAIL]\n");
        return 1;
    }

    test_pass();
    return 0;
}
