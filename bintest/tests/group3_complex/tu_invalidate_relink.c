// TU invalidation/relink stress.
// Repeatedly writes to the code page while executing hot direct and
// conditional control flow on the same guest page.
#include "test_syscall.h"

static volatile unsigned int touch_counter;

static unsigned int rotl32(unsigned int value, unsigned int shift)
{
    return (value << shift) | (value >> (32 - shift));
}

__attribute__((noinline, aligned(64)))
static void code_page_touch_target(void)
{
    __asm__ volatile("nop\nnop\nnop\n" ::: "memory");
    touch_counter++;
}

static void touch_code_page(void)
{
    volatile unsigned int *p =
        (volatile unsigned int *)(unsigned long)&code_page_touch_target;

    *p = *p;
    code_page_touch_target();
}

__attribute__((noinline))
static unsigned int hot_cfg(unsigned int x)
{
    for (unsigned int i = 0; i < 96; i++) {
        if (((x ^ i) & 1) != 0) {
            x = x * 1664525u + 1013904223u + i;
        } else {
            x = rotl32(x, 5) ^ (0x9e3779b9u + i);
        }

        if ((x & 15u) == 7u) {
            x ^= i * 0x045d9f3bu;
        } else if ((x & 3u) == 0u) {
            x += i * 17u + 0x10203u;
        } else {
            x -= (i + 3u) * 11u;
        }
    }

    return x;
}

int test_main(void)
{
    unsigned int sum = 0x12345678u;

    test_printstr("Testing TU invalidation/relink...\n");
    for (unsigned int i = 0; i < 256; i++) {
        if ((i & 15u) == 0u) {
            touch_code_page();
        }
        sum ^= hot_cfg(sum + i);
        sum = rotl32(sum, (i & 7u) + 1u) + 0x6d2b79f5u + i;
    }

    test_printstr("  checksum: ");
    test_printhex(sum);
    test_newline();

    if (sum != 0x2113fc01u || touch_counter != 16u) {
        test_printstr("[FAIL]\n");
        return 1;
    }

    test_pass();
    return 0;
}
