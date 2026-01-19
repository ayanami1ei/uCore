static inline long __syscall0(long n)
{
    long ret;
    __asm__ __volatile__(
        "mv a7,%1\n\t"
        "ecall\n\t"
        "mv %0,a0"
        : "=r"(ret)
        : "r"(n)
        : "a0", "a7", "memory");
    return ret;
}

static inline long __syscall1(long n, long a)
{
    long ret;
    __asm__ __volatile__(
        "mv a7,%1\n\t"
        "mv a0,%2\n\t"
        "ecall\n\t"
        "mv %0,a0"
        : "=r"(ret)
        : "r"(n), "r"(a)
        : "a0", "a7", "memory");
    return ret;
}

static inline long __syscall2(long n, long a, long b)
{
    long ret;
    __asm__ __volatile__(
        "mv a7,%1\n\t"
        "mv a0,%2\n\t"
        "mv a1,%3\n\t"
        "ecall\n\t"
        "mv %0,a0"
        : "=r"(ret)
        : "r"(n), "r"(a), "r"(b)
        : "a0", "a1", "a7", "memory");
    return ret;
}

static inline long __syscall3(long n, long a, long b, long c)
{
    long ret;
    __asm__ __volatile__(
        "mv a7,%1\n\t"
        "mv a0,%2\n\t"
        "mv a1,%3\n\t"
        "mv a2,%4\n\t"
        "ecall\n\t"
        "mv %0,a0"
        : "=r"(ret)
        : "r"(n), "r"(a), "r"(b), "r"(c)
        : "a0", "a1", "a2", "a7", "memory");
    return ret;
}

static inline long __syscall4(long n, long a, long b, long c, long d)
{
    long ret;
    __asm__ __volatile__(
        "mv a7,%1\n\t"
        "mv a0,%2\n\t"
        "mv a1,%3\n\t"
        "mv a2,%4\n\t"
        "mv a3,%5\n\t"
        "ecall\n\t"
        "mv %0,a0"
        : "=r"(ret)
        : "r"(n), "r"(a), "r"(b), "r"(c), "r"(d)
        : "a0", "a1", "a2", "a3", "a7", "memory");
    return ret;
}

static inline long __syscall5(long n, long a, long b, long c, long d, long e)
{
    long ret;
    __asm__ __volatile__(
        "mv a7,%1\n\t"
        "mv a0,%2\n\t"
        "mv a1,%3\n\t"
        "mv a2,%4\n\t"
        "mv a3,%5\n\t"
        "mv a4,%6\n\t"
        "ecall\n\t"
        "mv %0,a0"
        : "=r"(ret)
        : "r"(n), "r"(a), "r"(b), "r"(c), "r"(d), "r"(e)
        : "a0", "a1", "a2", "a3", "a4", "a7", "memory");
    return ret;
}

static inline long __syscall6(long n, long a, long b, long c, long d, long e, long f)
{
    long ret;
    __asm__ __volatile__(
        "mv a7,%1\n\t"
        "mv a0,%2\n\t"
        "mv a1,%3\n\t"
        "mv a2,%4\n\t"
        "mv a3,%5\n\t"
        "mv a4,%6\n\t"
        "mv a5,%7\n\t"
        "ecall\n\t"
        "mv %0,a0"
        : "=r"(ret)
        : "r"(n), "r"(a), "r"(b), "r"(c), "r"(d), "r"(e), "r"(f)
        : "a0", "a1", "a2", "a3", "a4", "a5", "a7", "memory");
    return ret;
}
