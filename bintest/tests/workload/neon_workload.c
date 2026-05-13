/*
 * NEON SIMD Workload Test
 * Tests NEON vector operations using C constructs that generate SIMD
 */

#include "test_syscall.h"

/* Force compiler to use SIMD by operating on arrays */

/* Vector addition: out = a + b */
static void vec_add_f32(float *a, float *b, float *out, int n) {
    for (int i = 0; i < n; i++) {
        out[i] = a[i] + b[i];
    }
}

/* Vector multiply: out = a * b */
static void vec_mul_f32(float *a, float *b, float *out, int n) {
    for (int i = 0; i < n; i++) {
        out[i] = a[i] * b[i];
    }
}

/* Vector multiply-add: out += a * b */
static void vec_mla_f32(float *a, float *b, float *out, int n) {
    for (int i = 0; i < n; i++) {
        out[i] += a[i] * b[i];
    }
}

/* Dot product */
static float dot_product_f32(float *a, float *b, int n) {
    float sum = 0.0f;
    for (int i = 0; i < n; i++) {
        sum += a[i] * b[i];
    }
    return sum;
}

/* Vector min */
static float vec_min_f32(float *a, int n) {
    float min_val = a[0];
    for (int i = 1; i < n; i++) {
        if (a[i] < min_val) min_val = a[i];
    }
    return min_val;
}

/* Vector max */
static float vec_max_f32(float *a, int n) {
    float max_val = a[0];
    for (int i = 1; i < n; i++) {
        if (a[i] > max_val) max_val = a[i];
    }
    return max_val;
}

/* Integer vector operations */
static void vec_add_s32(int32_t *a, int32_t *b, int32_t *out, int n) {
    for (int i = 0; i < n; i++) {
        out[i] = a[i] + b[i];
    }
}

static void vec_mul_s32(int32_t *a, int32_t *b, int32_t *out, int n) {
    for (int i = 0; i < n; i++) {
        out[i] = a[i] * b[i];
    }
}

/* Test float vector operations */
static int test_float_vec(void) {
    test_printstr("Testing float vectors...\n");
    
    float a[16], b[16], out[16];
    
    /* Initialize */
    for (int i = 0; i < 16; i++) {
        a[i] = (float)i;
        b[i] = (float)(i * 2);
    }
    
    /* Add */
    vec_add_f32(a, b, out, 16);
    TEST_ASSERT(out[0] == 0.0f);
    TEST_ASSERT(out[1] == 3.0f);
    TEST_ASSERT(out[15] == 45.0f);
    
    /* Multiply */
    vec_mul_f32(a, b, out, 16);
    TEST_ASSERT(out[0] == 0.0f);
    TEST_ASSERT(out[1] == 2.0f);
    TEST_ASSERT(out[2] == 8.0f);
    
    /* MLA */
    for (int i = 0; i < 16; i++) out[i] = 1.0f;
    vec_mla_f32(a, b, out, 16);
    TEST_ASSERT(out[0] == 1.0f);
    TEST_ASSERT(out[1] == 3.0f);
    TEST_ASSERT(out[2] == 9.0f);
    
    test_printstr("  Float vectors: PASS\n");
    return 0;
}

/* Test dot product */
static int test_dot_product(void) {
    test_printstr("Testing dot product...\n");
    
    float a[8] = {1.0f, 2.0f, 3.0f, 4.0f, 5.0f, 6.0f, 7.0f, 8.0f};
    float b[8] = {1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f};
    
    float dot = dot_product_f32(a, b, 8);
    /* 1+2+3+4+5+6+7+8 = 36 */
    TEST_ASSERT(dot > 35.9f && dot < 36.1f);
    
    /* Another test */
    float c[4] = {1.0f, 2.0f, 3.0f, 4.0f};
    float d[4] = {4.0f, 3.0f, 2.0f, 1.0f};
    dot = dot_product_f32(c, d, 4);
    /* 1*4 + 2*3 + 3*2 + 4*1 = 4 + 6 + 6 + 4 = 20 */
    TEST_ASSERT(dot > 19.9f && dot < 20.1f);
    
    test_printstr("  Dot product: PASS\n");
    return 0;
}

/* Test vector min/max */
static int test_vec_minmax(void) {
    test_printstr("Testing vec min/max...\n");
    
    float arr[8] = {3.0f, -1.0f, 7.0f, 2.0f, -5.0f, 8.0f, 0.0f, 4.0f};
    
    float min_val = vec_min_f32(arr, 8);
    float max_val = vec_max_f32(arr, 8);
    
    TEST_ASSERT(min_val < -4.9f && min_val > -5.1f);
    TEST_ASSERT(max_val > 7.9f && max_val < 8.1f);
    
    test_printstr("  Vec min/max: PASS\n");
    return 0;
}

/* Test integer vector operations */
static int test_int_vec(void) {
    test_printstr("Testing int vectors...\n");
    
    int32_t a[16], b[16], out[16];
    
    for (int i = 0; i < 16; i++) {
        a[i] = i;
        b[i] = i * 10;
    }
    
    vec_add_s32(a, b, out, 16);
    TEST_ASSERT(out[0] == 0);
    TEST_ASSERT(out[5] == 55);
    TEST_ASSERT(out[15] == 165);
    
    vec_mul_s32(a, b, out, 16);
    TEST_ASSERT(out[0] == 0);
    TEST_ASSERT(out[2] == 40);
    TEST_ASSERT(out[5] == 250);
    
    test_printstr("  Int vectors: PASS\n");
    return 0;
}

/* Matrix-vector multiply using loops */
static int test_matvec_mul(void) {
    test_printstr("Testing matrix-vector...\n");
    
    float mat[16] = {
        1, 2, 3, 4,
        5, 6, 7, 8,
        9, 10, 11, 12,
        13, 14, 15, 16
    };
    float vec[4] = {1, 1, 1, 1};
    float out[4] = {0};
    
    /* Matrix-vector multiply */
    for (int i = 0; i < 4; i++) {
        for (int j = 0; j < 4; j++) {
            out[i] += mat[i * 4 + j] * vec[j];
        }
    }
    
    /* Row sums: 10, 26, 42, 58 */
    TEST_ASSERT(out[0] > 9.9f && out[0] < 10.1f);
    TEST_ASSERT(out[1] > 25.9f && out[1] < 26.1f);
    TEST_ASSERT(out[2] > 41.9f && out[2] < 42.1f);
    TEST_ASSERT(out[3] > 57.9f && out[3] < 58.1f);
    
    test_printstr("  Matrix-vector: PASS\n");
    return 0;
}

/* Convolution-like operation */
static int test_convolution(void) {
    test_printstr("Testing convolution...\n");
    
    float input[16];
    float kernel[4] = {0.25f, 0.5f, 0.25f, 0.0f};
    float output[13];
    
    for (int i = 0; i < 16; i++) {
        input[i] = (float)i;
    }
    
    /* Simple 1D convolution */
    for (int i = 0; i < 13; i++) {
        float sum = 0.0f;
        for (int k = 0; k < 4; k++) {
            sum += input[i + k] * kernel[k];
        }
        output[i] = sum;
    }
    
    /* output[0] = 0*0.25 + 1*0.5 + 2*0.25 = 1.0 */
    TEST_ASSERT(output[0] > 0.9f && output[0] < 1.1f);
    /* output[1] = 1*0.25 + 2*0.5 + 3*0.25 = 2.0 */
    TEST_ASSERT(output[1] > 1.9f && output[1] < 2.1f);
    
    test_printstr("  Convolution: PASS\n");
    return 0;
}

/* Stress test with many vector operations */
static int test_vec_stress(void) {
    test_printstr("Testing vector stress...\n");
    
    float a[64], b[64], c[64], d[64];
    
    for (int i = 0; i < 64; i++) {
        a[i] = (float)i;
        b[i] = (float)(i + 1);
        c[i] = 0.0f;
        d[i] = 0.0f;
    }
    
    /* Chain of operations: d = (a + b) * a + b */
    vec_add_f32(a, b, c, 64);
    vec_mul_f32(c, a, d, 64);
    vec_mla_f32(b, b, d, 64);  /* d += b * b */
    
    /* Check a few values:
       c[i] = 2i + 1
       d[i] = c[i] * a[i] + b[i] * b[i]
            = (2i+1) * i + (i+1)^2
            = 2i^2 + i + i^2 + 2i + 1 = 3i^2 + 3i + 1
       d[0] = 1, d[1] = 7, d[2] = 19
    */
    TEST_ASSERT(d[0] > 0.9f && d[0] < 1.1f);
    TEST_ASSERT(d[1] > 6.9f && d[1] < 7.1f);
    TEST_ASSERT(d[2] > 18.9f && d[2] < 19.1f);
    
    test_printstr("  Vector stress: PASS\n");
    return 0;
}

int test_main(void) {
    test_printstr("=== NEON Vector Workload Tests ===\n");
    
    test_float_vec();
    test_dot_product();
    test_vec_minmax();
    test_int_vec();
    test_matvec_mul();
    test_convolution();
    test_vec_stress();
    
    test_printstr("All NEON workload tests passed!\n");
    test_pass();
    return 0;
}
