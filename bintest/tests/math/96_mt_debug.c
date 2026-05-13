// MT19937 uniform debug test
#include "test_syscall.h"

#define N 624
#define M 397
#define MATRIX_A 0x9908b0dfU
#define UPPER_MASK 0x80000000U
#define LOWER_MASK 0x7fffffffU

static unsigned int mt[N];
static int mti = N + 1;

void mt_init(unsigned int seed) {
    mt[0] = seed;
    for (mti = 1; mti < N; mti++) {
        mt[mti] = (1812433253U * (mt[mti-1] ^ (mt[mti-1] >> 30)) + mti);
    }
}

unsigned int mt_extract(void) {
    unsigned int y;
    static unsigned int mag01[2] = {0x0U, MATRIX_A};
    
    if (mti >= N) {
        int kk;
        for (kk = 0; kk < N - M; kk++) {
            y = (mt[kk] & UPPER_MASK) | (mt[kk+1] & LOWER_MASK);
            mt[kk] = mt[kk + M] ^ (y >> 1) ^ mag01[y & 1U];
        }
        for (; kk < N - 1; kk++) {
            y = (mt[kk] & UPPER_MASK) | (mt[kk+1] & LOWER_MASK);
            mt[kk] = mt[kk + (M - N)] ^ (y >> 1) ^ mag01[y & 1U];
        }
        y = (mt[N-1] & UPPER_MASK) | (mt[0] & LOWER_MASK);
        mt[N-1] = mt[M-1] ^ (y >> 1) ^ mag01[y & 1U];
        mti = 0;
    }
    
    y = mt[mti++];
    
    y ^= (y >> 11);
    y ^= (y << 7) & 0x9d2c5680U;
    y ^= (y << 15) & 0xefc60000U;
    y ^= (y >> 18);
    
    return y;
}

double mt_uniform(void) {
    return (double)mt_extract() * (1.0 / 4294967296.0);
}

int test_main(void) {
    test_printstr("Debug MT19937 uniform...\n");
    
    mt_init(42U);
    
    // Test raw values
    test_printstr("  raw values:\n");
    for (int i = 0; i < 5; i++) {
        unsigned int raw = mt_extract();
        test_printstr("    ");
        test_printhex(raw);
        test_printstr("\n");
    }
    
    // Reset and test uniform
    mt_init(42U);
    test_printstr("  uniform values:\n");
    for (int i = 0; i < 10; i++) {
        double u = mt_uniform();
        unsigned long long *p = (unsigned long long*)&u;
        test_printstr("    ");
        test_printhex(*p);
        test_printstr(" -> ");
        int bin = (int)(u * 10.0);
        test_printint(bin);
        test_printstr("\n");
    }
    
    // Distribution test
    mt_init(42U);
    int count[10] = {0};
    int bad_count = 0;
    for (int i = 0; i < 100; i++) {
        double u = mt_uniform();
        int bin = (int)(u * 10.0);
        if (bin >= 0 && bin < 10) {
            count[bin]++;
        } else {
            bad_count++;
        }
    }
    
    test_printstr("  counts after 100:\n");
    for (int i = 0; i < 10; i++) {
        test_printstr("    bin[");
        test_printint(i);
        test_printstr("]: ");
        test_printint(count[i]);
        test_printstr("\n");
    }
    test_printstr("    bad: ");
    test_printint(bad_count);
    test_printstr("\n");
    
    if (bad_count > 0) {
        test_printstr("  ERROR: found bad bins!\n");
        TEST_ASSERT(0);
    }
    
    test_printstr("All debug tests passed!\n");
    test_pass();
    return 0;
}
