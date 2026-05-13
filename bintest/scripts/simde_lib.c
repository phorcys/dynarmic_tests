/* 
 * simde_lib.c - Support library for SIMDe bare metal tests
 */

#include "test_syscall.h"

/* Define size_t if not already */
typedef unsigned long size_t;

/* Math functions - sqrt using ARM64 fsqrt instruction */
float sqrtf(float x) {
    float result;
    __asm__ volatile("fsqrt %s0, %s1" : "=w"(result) : "w"(x));
    return result;
}

double sqrt(double x) {
    double result;
    __asm__ volatile("fsqrt %d0, %d1" : "=w"(result) : "w"(x));
    return result;
}

/* Memory functions */
void* memset(void* s, int c, size_t n) {
    char* p = (char*)s;
    while (n--) {
        *p++ = (char)c;
    }
    return s;
}

void* memcpy(void* d, const void* s, size_t n) {
    char* dst = (char*)d;
    const char* src = (const char*)s;
    while (n--) {
        *dst++ = *src++;
    }
    return d;
}

int memcmp(const void* a, const void* b, size_t n) {
    const unsigned char* pa = (const unsigned char*)a;
    const unsigned char* pb = (const unsigned char*)b;
    while (n--) {
        if (*pa != *pb) {
            return *pa - *pb;
        }
        pa++;
        pb++;
    }
    return 0;
}

size_t strlen(const char* s) {
    size_t len = 0;
    while (*s++) len++;
    return len;
}

/* nextafterf implementation */
typedef union {
    float f;
    unsigned int u;
} f32_union;

float nextafterf(float x, float y) {
    if (x == y) return y;
    
    f32_union ux;
    ux.f = x;
    
    /* Handle zero */
    if (x == 0.0f) {
        ux.u = 1;
        if (y < 0.0f) ux.u |= 0x80000000;
        return ux.f;
    }
    
    /* Increment or decrement based on direction */
    if ((x < y) == (x > 0.0f)) {
        ux.u++;
    } else {
        ux.u--;
    }
    
    return ux.f;
}

double nextafter(double x, double y) {
    if (x == y) return y;
    if (x == 0.0) return (y > 0) ? 1e-300 : -1e-300;
    return x + ((y > x) ? 1e-300 : -1e-300);
}

/* Heap */
extern char __heap_start[];
extern char __heap_end[];
char* __heap_current = 0;

void* malloc(size_t n) {
    n = (n + 7) & ~7UL;
    if (__heap_current == 0) {
        __heap_current = __heap_start;
    }
    if (__heap_current + n > __heap_end) {
        return 0;
    }
    void* p = __heap_current;
    __heap_current += n;
    return p;
}

void free(void* p) { (void)p; }

void* calloc(size_t nmemb, size_t size) {
    size_t total = nmemb * size;
    void* p = malloc(total);
    if (p) memset(p, 0, total);
    return p;
}

void* realloc(void* ptr, size_t size) {
    void* p = malloc(size);
    if (p && ptr && size > 0) memcpy(p, ptr, size);
    return p;
}
