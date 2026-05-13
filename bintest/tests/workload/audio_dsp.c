/*
 * Audio Processing Workload Test
 * Simulates audio DSP operations
 */

#include "test_syscall.h"

/* Simple fixed-point audio sample (16-bit) */
typedef int16_t Sample;

/* Mix two audio samples */
static Sample mix_samples(Sample a, Sample b) {
    int32_t sum = (int32_t)a + (int32_t)b;
    /* Clamp to prevent overflow */
    if (sum > 32767) sum = 32767;
    if (sum < -32768) sum = -32768;
    return (Sample)sum;
}

/* Apply volume (0-256 scale) */
static Sample apply_volume(Sample s, int volume) {
    int32_t result = ((int32_t)s * volume) >> 8;
    return (Sample)result;
}

/* Test sample mixing */
static int test_mixing(void) {
    test_printstr("Testing sample mixing...\n");
    
    Sample a = 10000;
    Sample b = 20000;
    Sample mixed = mix_samples(a, b);
    TEST_ASSERT(mixed == 30000);
    
    /* Test overflow clipping */
    Sample c = 30000;
    Sample d = 10000;
    Sample clipped = mix_samples(c, d);
    TEST_ASSERT(clipped == 32767);  /* Clipped to max */
    
    /* Test negative clipping */
    Sample e = -30000;
    Sample f = -10000;
    Sample clipped_neg = mix_samples(e, f);
    TEST_ASSERT(clipped_neg == -32768);  /* Clipped to min */
    
    test_printstr("  Sample mixing: PASS\n");
    return 0;
}

/* Test volume control */
static int test_volume(void) {
    test_printstr("Testing volume...\n");
    
    Sample s = 10000;
    
    Sample half = apply_volume(s, 128);  /* 50% volume */
    TEST_ASSERT(half == 5000);
    
    Sample full = apply_volume(s, 256);  /* 100% volume */
    TEST_ASSERT(full == 10000);
    
    Sample quiet = apply_volume(s, 64);  /* 25% volume */
    TEST_ASSERT(quiet == 2500);
    
    Sample silent = apply_volume(s, 0);  /* 0% volume */
    TEST_ASSERT(silent == 0);
    
    test_printstr("  Volume: PASS\n");
    return 0;
}

/* Test audio buffer operations */
static int test_buffer_ops(void) {
    test_printstr("Testing buffer ops...\n");
    
    Sample buffer[64];
    
    /* Fill buffer */
    for (int i = 0; i < 64; i++) {
        buffer[i] = i * 100;
    }
    
    /* Find peak */
    Sample peak = 0;
    for (int i = 0; i < 64; i++) {
        if (buffer[i] > peak) peak = buffer[i];
    }
    TEST_ASSERT(peak == 6300);
    
    /* Calculate RMS-like value */
    int32_t sum_sq = 0;
    for (int i = 0; i < 64; i++) {
        int32_t val = buffer[i];
        sum_sq += val * val;
    }
    TEST_ASSERT(sum_sq > 0);
    
    test_printstr("  Buffer ops: PASS\n");
    return 0;
}

/* Test stereo panning */
static int test_panning(void) {
    test_printstr("Testing panning...\n");
    
    Sample mono = 10000;
    
    /* Pan left */
    Sample left_l = apply_volume(mono, 256);   /* Full left */
    Sample left_r = apply_volume(mono, 0);      /* Silent right */
    TEST_ASSERT(left_l == 10000);
    TEST_ASSERT(left_r == 0);
    
    /* Pan center */
    Sample center_l = apply_volume(mono, 128);
    Sample center_r = apply_volume(mono, 128);
    TEST_ASSERT(center_l == 5000);
    TEST_ASSERT(center_r == 5000);
    
    test_printstr("  Panning: PASS\n");
    return 0;
}

/* Test fade in/out */
static int test_fade(void) {
    test_printstr("Testing fade...\n");
    
    Sample buffer[10];
    
    /* Fade in */
    for (int i = 0; i < 10; i++) {
        buffer[i] = apply_volume(10000, i * 25 + 6);  /* 0% to ~100% */
    }
    
    TEST_ASSERT(buffer[0] < buffer[9]);  /* Should be increasing */
    
    /* Fade out */
    for (int i = 0; i < 10; i++) {
        buffer[i] = apply_volume(10000, 256 - i * 25);  /* 100% to ~0% */
    }
    
    TEST_ASSERT(buffer[0] > buffer[9]);  /* Should be decreasing */
    
    test_printstr("  Fade: PASS\n");
    return 0;
}

int test_main(void) {
    test_printstr("=== Audio Workload Tests ===\n");
    
    test_mixing();
    test_volume();
    test_buffer_ops();
    test_panning();
    test_fade();
    
    test_printstr("All audio workload tests passed!\n");
    test_pass();
    return 0;
}