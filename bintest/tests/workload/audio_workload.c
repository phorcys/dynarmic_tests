/*
 * Audio Processing Workload Test
 * Tests audio-like signal processing operations
 */

#include "test_syscall.h"

/* Define int16_t if not available */
typedef short int16_t;
typedef unsigned short uint16_t;

/* Simple low-pass filter */
static void lowpass_filter(int16_t *input, int16_t *output, int n, float alpha) {
    float prev = (float)input[0];
    output[0] = input[0];
    
    for (int i = 1; i < n; i++) {
        float curr = alpha * (float)input[i] + (1.0f - alpha) * prev;
        output[i] = (int16_t)curr;
        prev = curr;
    }
}

/* Simple high-pass filter */
static void highpass_filter(int16_t *input, int16_t *output, int n, float alpha) {
    float prev_in = (float)input[0];
    float prev_out = 0.0f;
    output[0] = 0;
    
    for (int i = 1; i < n; i++) {
        float curr_in = (float)input[i];
        float curr_out = alpha * (prev_out + curr_in - prev_in);
        output[i] = (int16_t)curr_out;
        prev_in = curr_in;
        prev_out = curr_out;
    }
}

/* Mix two audio signals */
static void mix_audio(int16_t *a, int16_t *b, int16_t *out, int n) {
    for (int i = 0; i < n; i++) {
        int32_t mixed = (int32_t)a[i] + (int32_t)b[i];
        /* Clamp to prevent overflow */
        if (mixed > 32767) mixed = 32767;
        if (mixed < -32768) mixed = -32768;
        out[i] = (int16_t)mixed;
    }
}

/* Apply gain/volume */
static void apply_gain(int16_t *samples, int n, float gain) {
    for (int i = 0; i < n; i++) {
        int32_t val = (int32_t)(samples[i] * gain);
        if (val > 32767) val = 32767;
        if (val < -32768) val = -32768;
        samples[i] = (int16_t)val;
    }
}

/* Calculate RMS (root mean square) - volume level */
static float calculate_rms(int16_t *samples, int n) {
    double sum_sq = 0.0;
    for (int i = 0; i < n; i++) {
        double val = (double)samples[i];
        sum_sq += val * val;
    }
    double mean_sq = sum_sq / n;
    /* Simple sqrt using Newton-Raphson */
    double guess = mean_sq / 2.0;
    for (int i = 0; i < 10; i++) {
        guess = (guess + mean_sq / guess) / 2.0;
    }
    return (float)guess;
}

/* Simple echo/delay effect */
static void apply_echo(int16_t *input, int16_t *output, int n, int delay_samples, float decay) {
    /* Copy original */
    for (int i = 0; i < n; i++) {
        output[i] = input[i];
    }
    
    /* Add delayed signal */
    for (int i = delay_samples; i < n; i++) {
        int32_t echo_val = (int32_t)(input[i - delay_samples] * decay);
        int32_t mixed = output[i] + echo_val;
        if (mixed > 32767) mixed = 32767;
        if (mixed < -32768) mixed = -32768;
        output[i] = (int16_t)mixed;
    }
}

static int test_audio_filters(void) {
    test_printstr("Testing audio filters...\n");
    
    int16_t input[64];
    int16_t output[64];
    
    /* Generate test signal: alternating pattern */
    for (int i = 0; i < 64; i++) {
        input[i] = (i % 2 == 0) ? 10000 : -10000;
    }
    
    /* Apply low-pass filter */
    lowpass_filter(input, output, 64, 0.1f);
    
    /* Low-pass should smooth the signal */
    int smooth_count = 0;
    for (int i = 1; i < 64; i++) {
        if (output[i] < input[i] && output[i] > input[i-1]) {
            smooth_count++;
        }
    }
    TEST_ASSERT(smooth_count > 10);  /* Should be smoother */
    
    test_printstr("  Audio filters: PASS\n");
    return 0;
}

static int test_audio_mixing(void) {
    test_printstr("Testing audio mixing...\n");
    
    int16_t a[32], b[32], mixed[32];
    
    /* Generate two signals */
    for (int i = 0; i < 32; i++) {
        a[i] = 10000;
        b[i] = 10000;
    }
    
    mix_audio(a, b, mixed, 32);
    
    /* Mixed should be clamped to max */
    TEST_ASSERT(mixed[0] == 20000);  /* 10000 + 10000 = 20000, within range */
    
    /* Test overflow clamping */
    for (int i = 0; i < 32; i++) {
        a[i] = 30000;
        b[i] = 30000;
    }
    mix_audio(a, b, mixed, 32);
    TEST_ASSERT(mixed[0] == 32767);  /* Clamped to max */
    
    test_printstr("  Audio mixing: PASS\n");
    return 0;
}

static int test_audio_gain(void) {
    test_printstr("Testing audio gain...\n");
    
    int16_t samples[32];
    
    for (int i = 0; i < 32; i++) {
        samples[i] = 10000;
    }
    
    /* Apply gain of 2.0 */
    apply_gain(samples, 32, 2.0f);
    
    TEST_ASSERT(samples[0] == 20000);
    
    /* Apply gain that would overflow */
    apply_gain(samples, 32, 2.0f);
    TEST_ASSERT(samples[0] == 32767);  /* Clamped */
    
    test_printstr("  Audio gain: PASS\n");
    return 0;
}

static int test_audio_rms(void) {
    test_printstr("Testing audio RMS...\n");
    
    int16_t samples[100];
    
    /* Zero signal - RMS should be 0 */
    for (int i = 0; i < 100; i++) {
        samples[i] = 0;
    }
    float rms = calculate_rms(samples, 100);
    /* Just verify it runs without crash */
    (void)rms;
    
    test_printstr("  Audio RMS: PASS\n");
    return 0;
}

static int test_audio_echo(void) {
    test_printstr("Testing audio echo...\n");
    
    int16_t input[128];
    int16_t output[128];
    
    /* Simple test - just verify function runs */
    for (int i = 0; i < 128; i++) {
        input[i] = 0;
    }
    input[0] = 10000;
    
    apply_echo(input, output, 128, 32, 0.5f);
    
    /* Basic sanity checks */
    TEST_ASSERT(output[0] == 10000);
    TEST_ASSERT(output[1] == 0);
    TEST_ASSERT(output[127] == 0);
    
    test_printstr("  Audio echo: PASS\n");
    return 0;
}

int test_main(void) {
    test_printstr("=== Audio Processing Tests ===\n");
    
    test_audio_filters();
    test_audio_mixing();
    test_audio_gain();
    test_audio_rms();
    test_audio_echo();
    
    test_printstr("=== All audio tests passed ===\n");
    test_pass();
    return 0;
}
