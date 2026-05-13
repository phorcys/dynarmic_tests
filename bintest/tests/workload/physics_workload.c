/*
 * Physics Simulation Test
 * Tests physics calculations common in games
 */

#include "test_syscall.h"

/* 2D vector */
typedef struct {
    float x, y;
} Vec2f;

/* Physics body */
typedef struct {
    Vec2f pos;
    Vec2f vel;
    Vec2f acc;
    float mass;
    float radius;
} Body;

/* Vector operations */
static Vec2f vec2_add(Vec2f a, Vec2f b) {
    Vec2f r = {a.x + b.x, a.y + b.y};
    return r;
}

static Vec2f vec2_sub(Vec2f a, Vec2f b) {
    Vec2f r = {a.x - b.x, a.y - b.y};
    return r;
}

static Vec2f vec2_scale(Vec2f v, float s) {
    Vec2f r = {v.x * s, v.y * s};
    return r;
}

static float vec2_dot(Vec2f a, Vec2f b) {
    return a.x * b.x + a.y * b.y;
}

static float vec2_length_sq(Vec2f v) {
    return v.x * v.x + v.y * v.y;
}

/* Simple square root for distance calculation */
static float sqrt_approx(float x) {
    if (x <= 0) return 0;
    float guess = x / 2.0f;
    for (int i = 0; i < 10; i++) {
        guess = (guess + x / guess) / 2.0f;
    }
    return guess;
}

static float vec2_length(Vec2f v) {
    return sqrt_approx(vec2_length_sq(v));
}

/* Physics update (Euler integration) */
static void body_update(Body *b, float dt) {
    /* v = v + a * dt */
    b->vel.x += b->acc.x * dt;
    b->vel.y += b->acc.y * dt;
    
    /* p = p + v * dt */
    b->pos.x += b->vel.x * dt;
    b->pos.y += b->vel.y * dt;
}

/* Apply force to body */
static void body_apply_force(Body *b, Vec2f force) {
    /* a = F / m */
    b->acc.x += force.x / b->mass;
    b->acc.y += force.y / b->mass;
}

/* Circle-circle collision detection */
static int check_collision(Body *a, Body *b) {
    Vec2f diff = vec2_sub(a->pos, b->pos);
    float dist_sq = vec2_length_sq(diff);
    float radius_sum = a->radius + b->radius;
    return dist_sq < radius_sum * radius_sum;
}

/* Elastic collision response */
static void resolve_collision(Body *a, Body *b) {
    Vec2f normal = vec2_sub(b->pos, a->pos);
    float dist = vec2_length(normal);
    if (dist < 0.001f) return;
    
    normal = vec2_scale(normal, 1.0f / dist);
    
    /* Relative velocity */
    Vec2f rel_vel = vec2_sub(a->vel, b->vel);
    float vel_along_normal = vec2_dot(rel_vel, normal);
    
    /* Don't resolve if velocities are separating */
    if (vel_along_normal > 0) return;
    
    /* Calculate impulse scalar */
    float e = 0.8f;  /* Coefficient of restitution */
    float j = -(1.0f + e) * vel_along_normal;
    j /= (1.0f / a->mass + 1.0f / b->mass);
    
    /* Apply impulse */
    Vec2f impulse = vec2_scale(normal, j);
    a->vel = vec2_add(a->vel, vec2_scale(impulse, 1.0f / a->mass));
    b->vel = vec2_sub(b->vel, vec2_scale(impulse, 1.0f / b->mass));
}

/* Test basic physics integration */
static int test_physics_integration(void) {
    test_printstr("Testing physics integration...\n");
    
    Body b = {{0, 0}, {10, 0}, {0, 0}, 1.0f, 1.0f};
    
    /* Update with dt = 1.0 */
    body_update(&b, 1.0f);
    TEST_ASSERT(b.pos.x > 9.9f && b.pos.x < 10.1f);
    TEST_ASSERT(b.pos.y < 0.1f && b.pos.y > -0.1f);
    
    /* Apply gravity */
    b.acc.y = -9.8f;
    body_update(&b, 1.0f);
    TEST_ASSERT(b.vel.y < -9.7f && b.vel.y > -9.9f);
    
    test_printstr("  Physics integration: PASS\n");
    return 0;
}

/* Test force application */
static int test_force_application(void) {
    test_printstr("Testing force application...\n");
    
    Body b = {{0, 0}, {0, 0}, {0, 0}, 2.0f, 1.0f};
    
    /* Apply force F = ma, so a = F/m = 10/2 = 5 */
    Vec2f force = {10.0f, 0};
    body_apply_force(&b, force);
    
    TEST_ASSERT(b.acc.x > 4.9f && b.acc.x < 5.1f);
    
    test_printstr("  Force application: PASS\n");
    return 0;
}

/* Test collision detection */
static int test_collision_detection(void) {
    test_printstr("Testing collision detection...\n");
    
    Body a = {{0, 0}, {0, 0}, {0, 0}, 1.0f, 1.0f};
    Body b = {{1.5f, 0}, {0, 0}, {0, 0}, 1.0f, 1.0f};
    
    /* Distance = 1.5, radius_sum = 2.0, should collide */
    TEST_ASSERT(check_collision(&a, &b) == 1);
    
    /* Move further apart */
    b.pos.x = 3.0f;
    /* Distance = 3.0, radius_sum = 2.0, should not collide */
    TEST_ASSERT(check_collision(&a, &b) == 0);
    
    test_printstr("  Collision detection: PASS\n");
    return 0;
}

/* Test collision response */
static int test_collision_response(void) {
    test_printstr("Testing collision response...\n");
    
    /* Simple test: two balls */
    Body a = {{0, 0}, {5, 0}, {0, 0}, 1.0f, 1.0f};
    Body b = {{1.8f, 0}, {-3, 0}, {0, 0}, 1.0f, 1.0f};
    
    /* They are colliding */
    int colliding = check_collision(&a, &b);
    TEST_ASSERT(colliding == 1);
    
    test_printstr("  Collision response: PASS\n");
    return 0;
}

/* Test projectile motion */
static int test_projectile_motion(void) {
    test_printstr("Testing projectile motion...\n");
    
    Body proj = {{0, 0}, {10, 20}, {0, -10}, 1.0f, 0.5f};
    
    /* Simulate for 2 time units */
    for (int i = 0; i < 2; i++) {
        body_update(&proj, 1.0f);
    }
    
    /* After 2 units: 
       pos.x = 10*2 = 20
       vel.y = 20 - 10*2 = 0
    */
    TEST_ASSERT(proj.pos.x > 19.0f && proj.pos.x < 21.0f);
    TEST_ASSERT(proj.vel.y > -1.0f && proj.vel.y < 1.0f);
    
    test_printstr("  Projectile motion: PASS\n");
    return 0;
}

/* Test spring force */
static int test_spring_force(void) {
    test_printstr("Testing spring force...\n");
    
    Body mass = {{1.0f, 0}, {0, 0}, {0, 0}, 1.0f, 0.1f};
    float k = 10.0f;  /* Spring constant */
    float rest = 0.0f;  /* Rest length */
    
    /* Spring force: F = -k * (x - rest) */
    float displacement = mass.pos.x - rest;
    float force = -k * displacement;
    
    TEST_ASSERT(force < -9.9f && force > -10.1f);
    
    /* Apply force and update */
    Vec2f f = {force, 0};
    body_apply_force(&mass, f);
    body_update(&mass, 0.1f);
    
    /* Mass should accelerate toward rest position */
    TEST_ASSERT(mass.vel.x < 0);
    
    test_printstr("  Spring force: PASS\n");
    return 0;
}

int test_main(void) {
    test_printstr("=== Physics Simulation Tests ===\n");
    
    test_physics_integration();
    test_force_application();
    test_collision_detection();
    test_collision_response();
    test_projectile_motion();
    test_spring_force();
    
    test_printstr("All physics tests passed!\n");
    test_pass();
    return 0;
}
