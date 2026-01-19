#ifndef X86_SYSCALL_ARCH_H
#define X86_SYSCALL_ARCH_H

static inline long __syscall0(long n)
{
    long ret;
    __asm__ __volatile__(
        "int $0x80"
        : "=a"(ret)
        : "a"(n)
        : "memory");
    return ret;
}

static inline long __syscall1(long n, long a)
{
    long ret;
    __asm__ __volatile__(
        "int $0x80"
        : "=a"(ret)
        : "a"(n), "b"(a)
        : "memory");
    return ret;
}

static inline long __syscall2(long n, long a, long b)
{
    long ret;
    __asm__ __volatile__(
        "int $0x80"
        : "=a"(ret)
        : "a"(n), "b"(a), "c"(b)
        : "memory");
    return ret;
}

static inline long __syscall3(long n, long a, long b, long c)
{
    long ret;
    __asm__ __volatile__(
        "int $0x80"
        : "=a"(ret)
        : "a"(n), "b"(a), "c"(b), "d"(c)
        : "memory");
    return ret;
}

static inline long __syscall4(long n, long a, long b, long c, long d)
{
    long ret;
    __asm__ __volatile__(
        "int $0x80"
        : "=a"(ret)
        : "a"(n), "b"(a), "c"(b), "d"(c), "S"(d)
        : "memory");
    return ret;
}

static inline long __syscall5(long n, long a, long b, long c, long d, long e)
{
    long ret;
    __asm__ __volatile__(
        "int $0x80"
        : "=a"(ret)
        : "a"(n), "b"(a), "c"(b), "d"(c), "S"(d), "D"(e)
        : "memory");
    return ret;
}

static inline long __syscall6(long n, long a, long b, long c, long d, long e, long f)
{
    long ret;
    /* On i386, 6th arg passed on stack; here we use ebp as convention for 6th */
    __asm__ __volatile__(
        "int $0x80"
        : "=a"(ret)
        : "a"(n), "b"(a), "c"(b), "d"(c), "S"(d), "D"(e), "g"(f)
        : "memory");
    return ret;
}

#endif
