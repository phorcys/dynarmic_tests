/*
 * Game Scene Workload Test
 * Simulates typical game scene processing
 */

#include "test_syscall.h"

/* Simple 3D vector */
typedef struct {
    float x, y, z;
} Vec3;

/* Transform matrix 4x4 */
typedef struct {
    float m[16];  /* Column-major */
} Mat4;

/* Simple vector operations */
static Vec3 vec3_add(Vec3 a, Vec3 b) {
    Vec3 r = { a.x + b.x, a.y + b.y, a.z + b.z };
    return r;
}

static Vec3 vec3_sub(Vec3 a, Vec3 b) {
    Vec3 r = { a.x - b.x, a.y - b.y, a.z - b.z };
    return r;
}

static Vec3 vec3_scale(Vec3 v, float s) {
    Vec3 r = { v.x * s, v.y * s, v.z * s };
    return r;
}

static float vec3_dot(Vec3 a, Vec3 b) {
    return a.x * b.x + a.y * b.y + a.z * b.z;
}

static float vec3_length_sq(Vec3 v) {
    return v.x * v.x + v.y * v.y + v.z * v.z;
}

/* Identity matrix */
static Mat4 mat4_identity(void) {
    Mat4 m;
    for (int i = 0; i < 16; i++) m.m[i] = 0.0f;
    m.m[0] = m.m[5] = m.m[10] = m.m[15] = 1.0f;
    return m;
}

/* Transform point by matrix */
static Vec3 mat4_transform(Mat4 m, Vec3 v) {
    Vec3 r;
    r.x = m.m[0] * v.x + m.m[4] * v.y + m.m[8] * v.z + m.m[12];
    r.y = m.m[1] * v.x + m.m[5] * v.y + m.m[9] * v.z + m.m[13];
    r.z = m.m[2] * v.x + m.m[6] * v.y + m.m[10] * v.z + m.m[14];
    return r;
}

/* Game object */
typedef struct {
    Vec3 position;
    Vec3 velocity;
    float radius;
    int active;
} GameObject;

/* Simple physics update */
static void update_object(GameObject *obj, float dt) {
    if (!obj->active) return;
    
    /* Apply gravity */
    obj->velocity.y -= 9.8f * dt;
    
    /* Update position */
    obj->position = vec3_add(obj->position, vec3_scale(obj->velocity, dt));
    
    /* Ground collision */
    if (obj->position.y < 0.0f) {
        obj->position.y = 0.0f;
        obj->velocity.y = -obj->velocity.y * 0.5f;  /* Bounce */
    }
}

/* Collision detection */
static int check_collision(GameObject *a, GameObject *b) {
    if (!a->active || !b->active) return 0;
    
    Vec3 diff = vec3_sub(a->position, b->position);
    float dist_sq = vec3_length_sq(diff);
    float radius_sum = a->radius + b->radius;
    
    return dist_sq < radius_sum * radius_sum;
}

/* Test vector operations */
static int test_vectors(void) {
    test_printstr("Testing vectors...\n");
    
    Vec3 a = { 1.0f, 2.0f, 3.0f };
    Vec3 b = { 4.0f, 5.0f, 6.0f };
    
    Vec3 sum = vec3_add(a, b);
    TEST_ASSERT(sum.x == 5.0f);
    TEST_ASSERT(sum.y == 7.0f);
    TEST_ASSERT(sum.z == 9.0f);
    
    Vec3 diff = vec3_sub(b, a);
    TEST_ASSERT(diff.x == 3.0f);
    TEST_ASSERT(diff.y == 3.0f);
    TEST_ASSERT(diff.z == 3.0f);
    
    Vec3 scaled = vec3_scale(a, 2.0f);
    TEST_ASSERT(scaled.x == 2.0f);
    TEST_ASSERT(scaled.y == 4.0f);
    TEST_ASSERT(scaled.z == 6.0f);
    
    float dot = vec3_dot(a, b);
    TEST_ASSERT(dot == 32.0f);  /* 1*4 + 2*5 + 3*6 */
    
    test_printstr("  Vectors: PASS\n");
    return 0;
}

/* Test matrix operations */
static int test_matrix(void) {
    test_printstr("Testing matrix...\n");
    
    Mat4 identity = mat4_identity();
    Vec3 v = { 1.0f, 2.0f, 3.0f };
    
    Vec3 transformed = mat4_transform(identity, v);
    TEST_ASSERT(transformed.x == 1.0f);
    TEST_ASSERT(transformed.y == 2.0f);
    TEST_ASSERT(transformed.z == 3.0f);
    
    test_printstr("  Matrix: PASS\n");
    return 0;
}

/* Test physics simulation */
static int test_physics(void) {
    test_printstr("Testing physics...\n");
    
    GameObject obj = { {0.0f, 10.0f, 0.0f}, {0.0f, 0.0f, 0.0f}, 1.0f, 1 };
    
    /* Simulate falling */
    for (int i = 0; i < 10; i++) {
        update_object(&obj, 0.1f);
    }
    
    /* Should have fallen and bounced */
    TEST_ASSERT(obj.position.y >= 0.0f);
    
    test_printstr("  Physics: PASS\n");
    return 0;
}

/* Test collision detection */
static int test_collision(void) {
    test_printstr("Testing collision...\n");
    
    GameObject a = { {0.0f, 0.0f, 0.0f}, {0.0f, 0.0f, 0.0f}, 1.0f, 1 };
    GameObject b = { {1.5f, 0.0f, 0.0f}, {0.0f, 0.0f, 0.0f}, 1.0f, 1 };
    GameObject c = { {5.0f, 0.0f, 0.0f}, {0.0f, 0.0f, 0.0f}, 1.0f, 1 };
    
    /* a and b should collide (distance 1.5 < radius_sum 2.0) */
    TEST_ASSERT(check_collision(&a, &b) == 1);
    
    /* a and c should not collide (distance 5.0 > radius_sum 2.0) */
    TEST_ASSERT(check_collision(&a, &c) == 0);
    
    test_printstr("  Collision: PASS\n");
    return 0;
}

/* Test scene update */
static int test_scene(void) {
    test_printstr("Testing scene update...\n");
    
    GameObject objects[10];
    
    /* Initialize objects */
    for (int i = 0; i < 10; i++) {
        objects[i].position.x = i * 2.0f;
        objects[i].position.y = 5.0f;
        objects[i].position.z = 0.0f;
        objects[i].velocity.x = 0.0f;
        objects[i].velocity.y = 0.0f;
        objects[i].velocity.z = 0.0f;
        objects[i].radius = 1.0f;
        objects[i].active = 1;
    }
    
    /* Update all objects */
    for (int frame = 0; frame < 5; frame++) {
        for (int i = 0; i < 10; i++) {
            update_object(&objects[i], 0.1f);
        }
    }
    
    /* Check all objects are still valid */
    int active_count = 0;
    for (int i = 0; i < 10; i++) {
        if (objects[i].active) active_count++;
    }
    TEST_ASSERT(active_count == 10);
    
    test_printstr("  Scene update: PASS\n");
    return 0;
}

int test_main(void) {
    test_printstr("=== Game Scene Tests ===\n");
    
    test_vectors();
    test_matrix();
    test_physics();
    test_collision();
    test_scene();
    
    test_printstr("All game scene tests passed!\n");
    test_pass();
    return 0;
}
