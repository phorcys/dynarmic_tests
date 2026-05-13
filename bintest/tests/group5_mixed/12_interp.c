// Test interpolation and curve functions
#include "test_syscall.h"

int lerp_int(int a, int b, int t) {
    // Linear interpolation: a + t * (b - a)
    // t is in range [0, 100] (percent)
    return a + t * (b - a) / 100;
}

int bilinear_interp(int q00, int q10, int q01, int q11, int tx, int ty) {
    // Bilinear interpolation
    int r0 = lerp_int(q00, q10, tx);
    int r1 = lerp_int(q01, q11, tx);
    return lerp_int(r0, r1, ty);
}

int cubic_bezier(int p0, int p1, int p2, int p3, int t) {
    // Cubic Bezier curve
    // B(t) = (1-t)³P0 + 3(1-t)²tP1 + 3(1-t)t²P2 + t³P3
    // t is in range [0, 100]
    int one_minus_t = 100 - t;
    int c0 = one_minus_t * one_minus_t * one_minus_t * p0;
    int c1 = 3 * one_minus_t * one_minus_t * t * p1;
    int c2 = 3 * one_minus_t * t * t * p2;
    int c3 = t * t * t * p3;
    return (c0 + c1 + c2 + c3) / 1000000;
}

int ease_in_quad(int start, int end, int t) {
    return start + (end - start) * t * t / 10000;
}

int ease_out_quad(int start, int end, int t) {
    return start + (end - start) * t * (200 - t) / 10000;
}

int smooth_step(int edge0, int edge1, int x) {
    // Smoothstep interpolation
    if (x <= edge0) return 0;
    if (x >= edge1) return 100;
    int t = (x - edge0) * 100 / (edge1 - edge0);
    return t * t * (300 - 2 * t) / 10000;
}

int test_main(void) {
    test_printstr("Testing interpolation...\n");
    
    // Test 1: Linear interpolation
    int l1 = lerp_int(0, 100, 50);
    test_printstr("  lerp: ");
    test_printint(l1);
    TEST_ASSERT(l1 == 50);
    test_printstr(" OK\n");
    
    // Test 2: Lerp endpoints
    int l2 = lerp_int(0, 100, 0);
    int l3 = lerp_int(0, 100, 100);
    test_printstr("  lerp_end: ");
    TEST_ASSERT(l2 == 0);
    TEST_ASSERT(l3 == 100);
    test_printstr("OK\n");
    
    // Test 3: Bilinear interpolation
    int bi = bilinear_interp(0, 100, 0, 100, 50, 50);
    test_printstr("  bilinear: ");
    test_printint(bi);
    TEST_ASSERT(bi == 50);
    test_printstr(" OK\n");
    
    // Test 4: Cubic Bezier (linear case)
    int bz = cubic_bezier(0, 33, 67, 100, 50);
    test_printstr("  bezier: ");
    test_printint(bz);
    test_printstr(" OK\n");
    
    // Test 5: Ease in (quadratic)
    int ei = ease_in_quad(0, 100, 50);
    test_printstr("  ease_in: ");
    test_printint(ei);
    TEST_ASSERT(ei == 25);  // t² at t=0.5 is 0.25
    test_printstr(" OK\n");
    
    // Test 6: Ease out (quadratic)
    int eo = ease_out_quad(0, 100, 50);
    test_printstr("  ease_out: ");
    test_printint(eo);
    TEST_ASSERT(eo == 75);  // t*(2-t) at t=0.5 is 0.75
    test_printstr(" OK\n");
    
    // Test 7: Smoothstep
    int ss1 = smooth_step(0, 100, 50);
    int ss2 = smooth_step(0, 100, 0);
    int ss3 = smooth_step(0, 100, 100);
    test_printstr("  smooth: ");
    test_printint(ss1);
    TEST_ASSERT(ss2 == 0);
    TEST_ASSERT(ss3 == 100);
    test_printstr(" OK\n");
    
    test_printstr("All interpolation tests passed!\n");
    test_pass();
    return 0;
}
