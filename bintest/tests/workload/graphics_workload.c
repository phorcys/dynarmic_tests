/*
 * Graphics Workload Test
 * Tests graphics-related computations: matrix transforms, color ops, etc.
 */

#include "test_syscall.h"

/* 4x4 matrix for 3D transforms */
typedef struct {
    float m[16];  /* Column-major */
} Mat4;

/* 3D vector */
typedef struct {
    float x, y, z, w;
} Vec4;

/* Identity matrix */
static Mat4 mat4_identity(void) {
    Mat4 r;
    for (int i = 0; i < 16; i++) r.m[i] = 0.0f;
    r.m[0] = r.m[5] = r.m[10] = r.m[15] = 1.0f;
    return r;
}

/* Matrix multiply: result = a * b */
static Mat4 mat4_mul(Mat4 a, Mat4 b) {
    Mat4 r;
    for (int col = 0; col < 4; col++) {
        for (int row = 0; row < 4; row++) {
            float sum = 0.0f;
            for (int k = 0; k < 4; k++) {
                sum += a.m[k * 4 + row] * b.m[col * 4 + k];
            }
            r.m[col * 4 + row] = sum;
        }
    }
    return r;
}

/* Transform vector by matrix */
static Vec4 mat4_transform(Mat4 m, Vec4 v) {
    Vec4 r;
    r.x = m.m[0] * v.x + m.m[4] * v.y + m.m[8]  * v.z + m.m[12] * v.w;
    r.y = m.m[1] * v.x + m.m[5] * v.y + m.m[9]  * v.z + m.m[13] * v.w;
    r.z = m.m[2] * v.x + m.m[6] * v.y + m.m[10] * v.z + m.m[14] * v.w;
    r.w = m.m[3] * v.x + m.m[7] * v.y + m.m[11] * v.z + m.m[15] * v.w;
    return r;
}

/* Translation matrix */
static Mat4 mat4_translate(float tx, float ty, float tz) {
    Mat4 r = mat4_identity();
    r.m[12] = tx;
    r.m[13] = ty;
    r.m[14] = tz;
    return r;
}

/* Scale matrix */
static Mat4 mat4_scale(float sx, float sy, float sz) {
    Mat4 r = mat4_identity();
    r.m[0] = sx;
    r.m[5] = sy;
    r.m[10] = sz;
    return r;
}

/* Approximate sine */
static float my_sinf(float x) {
    /* Taylor series approximation */
    float x2 = x * x;
    float x3 = x2 * x;
    float x5 = x3 * x2;
    float x7 = x5 * x2;
    return x - x3/6.0f + x5/120.0f - x7/5040.0f;
}

/* Approximate cosine */
static float my_cosf(float x) {
    return my_sinf(x + 3.14159265f / 2.0f);
}

/* Rotation around Z axis */
static Mat4 mat4_rotate_z(float angle) {
    Mat4 r = mat4_identity();
    float c = my_cosf(angle);
    float s = my_sinf(angle);
    r.m[0] = c;
    r.m[1] = s;
    r.m[4] = -s;
    r.m[5] = c;
    return r;
}

/* Test basic matrix operations */
static int test_matrix_basic(void) {
    test_printstr("Testing matrix basics...\n");
    
    Mat4 id = mat4_identity();
    TEST_ASSERT(id.m[0] == 1.0f);
    TEST_ASSERT(id.m[5] == 1.0f);
    TEST_ASSERT(id.m[10] == 1.0f);
    TEST_ASSERT(id.m[15] == 1.0f);
    
    Vec4 v = {1.0f, 2.0f, 3.0f, 1.0f};
    Vec4 r = mat4_transform(id, v);
    TEST_ASSERT(r.x == 1.0f);
    TEST_ASSERT(r.y == 2.0f);
    
    test_printstr("  Matrix basics: PASS\n");
    return 0;
}

/* Test matrix multiply */
static int test_matrix_mul(void) {
    test_printstr("Testing matrix multiply...\n");
    
    Mat4 scale = mat4_scale(2.0f, 3.0f, 4.0f);
    Mat4 trans = mat4_translate(10.0f, 20.0f, 30.0f);
    
    /* Combined transform: scale then translate */
    Mat4 combined = mat4_mul(trans, scale);
    
    Vec4 v = {1.0f, 1.0f, 1.0f, 1.0f};
    Vec4 r = mat4_transform(combined, v);
    
    /* After scale: (2, 3, 4), after translate: (12, 23, 34) */
    TEST_ASSERT(r.x > 11.9f && r.x < 12.1f);
    TEST_ASSERT(r.y > 22.9f && r.y < 23.1f);
    TEST_ASSERT(r.z > 33.9f && r.z < 34.1f);
    
    test_printstr("  Matrix multiply: PASS\n");
    return 0;
}

/* Test rotation */
static int test_rotation(void) {
    test_printstr("Testing rotation...\n");
    
    /* Rotate by 90 degrees (pi/2 radians) around Z */
    float angle = 1.5707963f;  /* pi/2 */
    Mat4 rot = mat4_rotate_z(angle);
    
    Vec4 v = {1.0f, 0.0f, 0.0f, 1.0f};
    Vec4 r = mat4_transform(rot, v);
    
    /* After 90 degree rotation around Z: (0, 1, 0) */
    TEST_ASSERT(r.x > -0.1f && r.x < 0.1f);
    TEST_ASSERT(r.y > 0.9f && r.y < 1.1f);
    
    test_printstr("  Rotation: PASS\n");
    return 0;
}

/* Color blending operations */
static int test_color_blend(void) {
    test_printstr("Testing color blending...\n");
    
    /* RGBA colors as 0-255 */
    uint32_t c1 = 0xFF0000FF;  /* Red (ABGR format) */
    uint32_t c2 = 0x00FF00FF;  /* Green */
    
    /* Extract components */
    uint8_t b1 = c1 & 0xFF;
    uint8_t g1 = (c1 >> 8) & 0xFF;
    uint8_t r1 = (c1 >> 16) & 0xFF;
    
    uint8_t b2 = c2 & 0xFF;
    uint8_t g2 = (c2 >> 8) & 0xFF;
    uint8_t r2 = (c2 >> 16) & 0xFF;
    
    /* Simple blend */
    uint8_t r_blend = (r1 + r2) / 2;
    uint8_t g_blend = (g1 + g2) / 2;
    uint8_t b_blend = (b1 + b2) / 2;
    
    /* r1=0, r2=255 -> r_blend=127 or 128 */
    /* g1=0, g2=255 -> g_blend=127 or 128 */
    /* b1=255, b2=255 -> b_blend=255 */
    TEST_ASSERT(b_blend == 0xFF);
    
    test_printstr("  Color blend: PASS\n");
    return 0;
}

/* Vertex transformation pipeline */
static int test_vertex_pipeline(void) {
    test_printstr("Testing vertex pipeline...\n");
    
    /* Model -> World -> View -> Clip transformation chain */
    Mat4 model = mat4_scale(2.0f, 2.0f, 2.0f);
    Mat4 view = mat4_translate(0.0f, 0.0f, -5.0f);
    Mat4 mvp = mat4_mul(view, model);
    
    /* Transform a vertex */
    Vec4 vertex = {1.0f, 1.0f, 1.0f, 1.0f};
    Vec4 clip = mat4_transform(mvp, vertex);
    
    /* After scale: (2, 2, 2), after view: (2, 2, -3) */
    TEST_ASSERT(clip.x > 1.9f && clip.x < 2.1f);
    TEST_ASSERT(clip.y > 1.9f && clip.y < 2.1f);
    TEST_ASSERT(clip.z > -3.1f && clip.z < -2.9f);
    
    test_printstr("  Vertex pipeline: PASS\n");
    return 0;
}

/* Test many small matrix operations */
static int test_matrix_stress(void) {
    test_printstr("Testing matrix stress...\n");
    
    Mat4 result = mat4_identity();
    Mat4 rot = mat4_rotate_z(0.1f);
    
    /* Chain 10 rotations */
    for (int i = 0; i < 10; i++) {
        result = mat4_mul(result, rot);
    }
    
    /* Transform a point */
    Vec4 v = {1.0f, 0.0f, 0.0f, 1.0f};
    Vec4 r = mat4_transform(result, v);
    
    /* After 10 rotations of 0.1 radians, should be roughly:
       cos(1.0), sin(1.0), 0 */
    float expected_x = my_cosf(1.0f);
    float expected_y = my_sinf(1.0f);
    
    /* Allow some error margin */
    TEST_ASSERT(r.x > expected_x - 0.1f && r.x < expected_x + 0.1f);
    TEST_ASSERT(r.y > expected_y - 0.1f && r.y < expected_y + 0.1f);
    
    test_printstr("  Matrix stress: PASS\n");
    return 0;
}

int test_main(void) {
    test_printstr("=== Graphics Workload Tests ===\n");
    
    test_matrix_basic();
    test_matrix_mul();
    test_rotation();
    test_color_blend();
    test_vertex_pipeline();
    test_matrix_stress();
    
    test_printstr("All graphics tests passed!\n");
    test_pass();
    return 0;
}
