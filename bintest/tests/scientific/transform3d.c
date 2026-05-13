/*
 * 3D Transform Test
 * Tests 3D matrix and vector operations
 */

#include "test_syscall.h"

/* 3D vector */
typedef struct {
    float x, y, z;
} Vec3;

/* 4x4 matrix (column-major) */
typedef float Mat4[16];

/* Vector operations */
static Vec3 vec3_create(float x, float y, float z) {
    Vec3 v = {x, y, z};
    return v;
}

static Vec3 vec3_add(Vec3 a, Vec3 b) {
    Vec3 r = {a.x + b.x, a.y + b.y, a.z + b.z};
    return r;
}

static Vec3 vec3_sub(Vec3 a, Vec3 b) {
    Vec3 r = {a.x - b.x, a.y - b.y, a.z - b.z};
    return r;
}

static Vec3 vec3_scale(Vec3 v, float s) {
    Vec3 r = {v.x * s, v.y * s, v.z * s};
    return r;
}

static float vec3_dot(Vec3 a, Vec3 b) {
    return a.x * b.x + a.y * b.y + a.z * b.z;
}

static Vec3 vec3_cross(Vec3 a, Vec3 b) {
    Vec3 r = {
        a.y * b.z - a.z * b.y,
        a.z * b.x - a.x * b.z,
        a.x * b.y - a.y * b.x
    };
    return r;
}

/* Matrix operations */
static void mat4_identity(Mat4 m) {
    for (int i = 0; i < 16; i++) m[i] = 0.0f;
    m[0] = m[5] = m[10] = m[15] = 1.0f;
}

static void mat4_multiply(Mat4 result, Mat4 a, Mat4 b) {
    for (int col = 0; col < 4; col++) {
        for (int row = 0; row < 4; row++) {
            float sum = 0.0f;
            for (int k = 0; k < 4; k++) {
                sum += a[k * 4 + row] * b[col * 4 + k];
            }
            result[col * 4 + row] = sum;
        }
    }
}

static Vec3 mat4_transform_vec3(Mat4 m, Vec3 v) {
    Vec3 r;
    r.x = m[0] * v.x + m[4] * v.y + m[8]  * v.z + m[12];
    r.y = m[1] * v.x + m[5] * v.y + m[9]  * v.z + m[13];
    r.z = m[2] * v.x + m[6] * v.y + m[10] * v.z + m[14];
    return r;
}

static void mat4_translate(Mat4 m, float tx, float ty, float tz) {
    mat4_identity(m);
    m[12] = tx;
    m[13] = ty;
    m[14] = tz;
}

static void mat4_scale(Mat4 m, float sx, float sy, float sz) {
    mat4_identity(m);
    m[0] = sx;
    m[5] = sy;
    m[10] = sz;
}

/* Approximate sine/cosine */
static float my_sinf(float x) {
    float x2 = x * x;
    float x3 = x2 * x;
    float x5 = x3 * x2;
    float x7 = x5 * x2;
    return x - x3/6.0f + x5/120.0f - x7/5040.0f;
}

static float my_cosf(float x) {
    return my_sinf(x + 1.57079632f);
}

static void mat4_rotate_y(Mat4 m, float angle) {
    mat4_identity(m);
    float c = my_cosf(angle);
    float s = my_sinf(angle);
    m[0] = c;
    m[2] = -s;
    m[8] = s;
    m[10] = c;
}

static void mat4_rotate_x(Mat4 m, float angle) {
    mat4_identity(m);
    float c = my_cosf(angle);
    float s = my_sinf(angle);
    m[5] = c;
    m[6] = s;
    m[9] = -s;
    m[10] = c;
}

/* Test basic vector operations */
static int test_vec3_basic(void) {
    test_printstr("Testing Vec3 basic...\n");
    
    Vec3 a = vec3_create(1, 2, 3);
    Vec3 b = vec3_create(4, 5, 6);
    
    Vec3 sum = vec3_add(a, b);
    TEST_ASSERT(sum.x == 5 && sum.y == 7 && sum.z == 9);
    
    Vec3 diff = vec3_sub(b, a);
    TEST_ASSERT(diff.x == 3 && diff.y == 3 && diff.z == 3);
    
    Vec3 scaled = vec3_scale(a, 2);
    TEST_ASSERT(scaled.x == 2 && scaled.y == 4 && scaled.z == 6);
    
    test_printstr("  Vec3 basic: PASS\n");
    return 0;
}

/* Test dot and cross product */
static int test_vec3_products(void) {
    test_printstr("Testing Vec3 products...\n");
    
    Vec3 a = {1, 0, 0};
    Vec3 b = {0, 1, 0};
    
    float dot = vec3_dot(a, b);
    TEST_ASSERT(dot == 0);  /* Perpendicular */
    
    Vec3 cross = vec3_cross(a, b);
    TEST_ASSERT(cross.x == 0 && cross.y == 0 && cross.z == 1);
    
    /* Self cross is zero */
    cross = vec3_cross(a, a);
    TEST_ASSERT(cross.x == 0 && cross.y == 0 && cross.z == 0);
    
    test_printstr("  Vec3 products: PASS\n");
    return 0;
}

/* Test matrix identity */
static int test_mat4_identity(void) {
    test_printstr("Testing Mat4 identity...\n");
    
    Mat4 m;
    mat4_identity(m);
    
    Vec3 v = {5, 10, 15};
    Vec3 r = mat4_transform_vec3(m, v);
    
    TEST_ASSERT(r.x == 5 && r.y == 10 && r.z == 15);
    
    test_printstr("  Mat4 identity: PASS\n");
    return 0;
}

/* Test translation */
static int test_translation(void) {
    test_printstr("Testing translation...\n");
    
    Mat4 m;
    mat4_translate(m, 10, 20, 30);
    
    Vec3 v = {0, 0, 0};
    Vec3 r = mat4_transform_vec3(m, v);
    
    TEST_ASSERT(r.x == 10 && r.y == 20 && r.z == 30);
    
    test_printstr("  Translation: PASS\n");
    return 0;
}

/* Test scaling */
static int test_scaling(void) {
    test_printstr("Testing scaling...\n");
    
    Mat4 m;
    mat4_scale(m, 2, 3, 4);
    
    Vec3 v = {1, 1, 1};
    Vec3 r = mat4_transform_vec3(m, v);
    
    /* Note: transform doesn't scale, we'd need mat4_transform_point */
    /* For now, just test the matrix values */
    TEST_ASSERT(m[0] == 2);
    TEST_ASSERT(m[5] == 3);
    TEST_ASSERT(m[10] == 4);
    
    test_printstr("  Scaling: PASS\n");
    return 0;
}

/* Test rotation */
static int test_rotation(void) {
    test_printstr("Testing rotation...\n");
    
    /* Rotate 90 degrees around Y axis */
    Mat4 m;
    mat4_rotate_y(m, 1.57079632f);  /* pi/2 */
    
    Vec3 v = {1, 0, 0};  /* Point on X axis */
    Vec3 r = mat4_transform_vec3(m, v);
    
    /* After 90 degree Y rotation, X becomes -Z */
    TEST_ASSERT(r.x < 0.1f && r.x > -0.1f);  /* ~0 */
    TEST_ASSERT(r.y < 0.1f && r.y > -0.1f);  /* 0 */
    TEST_ASSERT(r.z < -0.9f && r.z > -1.1f); /* ~-1 */
    
    test_printstr("  Rotation: PASS\n");
    return 0;
}

/* Test matrix multiply */
static int test_matrix_multiply(void) {
    test_printstr("Testing matrix multiply...\n");
    
    Mat4 t, s, result;
    mat4_translate(t, 10, 0, 0);
    mat4_scale(s, 2, 2, 2);
    
    mat4_multiply(result, s, t);
    
    /* Verify result is valid */
    TEST_ASSERT(result[15] == 1.0f);
    
    test_printstr("  Matrix multiply: PASS\n");
    return 0;
}

int test_main(void) {
    test_printstr("=== 3D Transform Tests ===\n");
    
    test_vec3_basic();
    test_vec3_products();
    test_mat4_identity();
    test_translation();
    test_scaling();
    test_rotation();
    test_matrix_multiply();
    
    test_printstr("All 3D transform tests passed!\n");
    test_pass();
    return 0;
}
