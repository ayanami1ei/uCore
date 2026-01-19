#include "console.h"
#include "sbi.h"
// #include "keyboard.h"
#include "types.h"
#include <stdarg.h>
#include <stdint.h>

static void kputc(char c)
{
    put_char(c);
    return;
}

static void kputs(const char *s, int *count)
{
    if (!s)
    {
        s = "(null)";
    }
    while (*s)
    {
        kputc(*s++);
        if (count)
            (*count)++;
    }
}

static int print_unsigned(unsigned long value, int base, int uppercase)
{
    char buf[32];
    const char *digits_lower = "0123456789abcdef";
    const char *digits_upper = "0123456789ABCDEF";
    const char *digits = uppercase ? digits_upper : digits_lower;
    int i = 0;

    if (value == 0)
    {
        kputc('0');
        return 1;
    }

    while (value != 0 && i < (int)sizeof(buf))
    {
        int d = value % base;
        buf[i++] = digits[d];
        value /= base;
    }

    int count = 0;
    while (i-- > 0)
    {
        kputc(buf[i]);
        count++;
    }
    return count;
}

static int print_signed(long long value, int base)
{
    unsigned long long u;
    int count = 0;

    if (value < 0)
    {
        kputc('-');
        count++;
        u = (unsigned long long)(-value);
    }
    else
    {
        u = (unsigned long long)value;
    }

    count += print_unsigned(u, base, 0);
    return count;
}

static int print_pointer(const void *ptr)
{
    int count = 0;
    kputc('0');
    kputc('x');
    count += 2;
    count += print_unsigned((unsigned long long)(uintptr_t)ptr, 16, 0);
    return count;
}

int vprintf(const char *fmt, va_list ap)
{
    int count = 0;

    for (; *fmt; fmt++)
    {
        if (*fmt != '%')
        {
            kputc(*fmt);
            count++;
            continue;
        }

        fmt++; // skip '%'

        if (*fmt == '\0')
            break;

        // 暂时只支持一个或零个 'l' 修饰符
        int long_flag = 0;
        while (*fmt == 'l')
        {
            long_flag++;
            fmt++;
        }

        switch (*fmt)
        {
        case 'd':
        case 'i':
            if (long_flag)
            {
                long long v = va_arg(ap, long long);
                count += print_signed(v, 10);
            }
            else
            {
                int v = va_arg(ap, int);
                count += print_signed(v, 10);
            }
            break;
        case 'u':
            if (long_flag)
            {
                unsigned long long v = va_arg(ap, unsigned long long);
                count += print_unsigned(v, 10, 0);
            }
            else
            {
                unsigned int v = va_arg(ap, unsigned int);
                count += print_unsigned(v, 10, 0);
            }
            break;
        case 'x':
            if (long_flag)
            {
                unsigned long long v = va_arg(ap, unsigned long long);
                count += print_unsigned(v, 16, 0);
            }
            else
            {
                unsigned int v = va_arg(ap, unsigned int);
                count += print_unsigned(v, 16, 0);
            }
            break;
        case 'X':
            if (long_flag)
            {
                unsigned long long v = va_arg(ap, unsigned long long);
                count += print_unsigned(v, 16, 1);
            }
            else
            {
                unsigned int v = va_arg(ap, unsigned int);
                count += print_unsigned(v, 16, 1);
            }
            break;
        case 'p':
        {
            void *p = va_arg(ap, void *);
            count += print_pointer(p);
            break;
        }
        case 'c':
        {
            int c = va_arg(ap, int);
            kputc((char)c);
            count++;
            break;
        }
        case 's':
        {
            const char *s = va_arg(ap, const char *);
            kputs(s, &count);
            break;
        }
        case '%':
            kputc('%');
            count++;
            break;
        default:
            kputs("[?]", &count);
            break;
        }
    }

    return count;
}

int printf(const char *fmt, ...)
{
    va_list ap;
    va_start(ap, fmt);
    int ret = vprintf(fmt, ap);
    va_end(ap);
    return ret;
}

char scanf_char()
{
    return 'c'; // keyboard_trap();
}
