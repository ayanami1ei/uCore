
bin/user_app.elf:     file format elf32-i386


Disassembly of section .startup:

00800000 <_start>:
.section .text.entry
.globl _start
_start:
    # push argc(0) and argv(NULL)
    push $0
  800000:	6a 00                	push   $0x0
    push $0
  800002:	6a 00                	push   $0x0
    call __start_main
  800004:	e8 03 00 00 00       	call   80000c <__start_main>

00800009 <.hang>:
.hang:
    hlt
  800009:	f4                   	hlt
    jmp .hang
  80000a:	eb fd                	jmp    800009 <.hang>

Disassembly of section .text:

0080000c <__start_main>:
#include "unistd.h"

extern int main(int, char **);

int __start_main(int argc, char **argv)
{
  80000c:	55                   	push   %ebp
  80000d:	89 e5                	mov    %esp,%ebp
  80000f:	83 ec 10             	sub    $0x10,%esp
    exit(main(argc, argv));
  800012:	ff 75 0c             	push   0xc(%ebp)
  800015:	ff 75 08             	push   0x8(%ebp)
  800018:	e8 4b 04 00 00       	call   800468 <main>
  80001d:	89 04 24             	mov    %eax,(%esp)
  800020:	e8 2f 04 00 00       	call   800454 <exit>
    return 0;
  800025:	31 c0                	xor    %eax,%eax
  800027:	c9                   	leave
  800028:	c3                   	ret
  800029:	66 90                	xchg   %ax,%ax
  80002b:	90                   	nop

0080002c <print_unsigned>:
    if (count)
        (*count) += (int)len;
}

static int print_unsigned(unsigned long value, int base, int uppercase)
{
  80002c:	55                   	push   %ebp
  80002d:	89 e5                	mov    %esp,%ebp
  80002f:	57                   	push   %edi
  800030:	56                   	push   %esi
  800031:	53                   	push   %ebx
  800032:	83 ec 3c             	sub    $0x3c,%esp
  800035:	89 c3                	mov    %eax,%ebx
  800037:	89 d6                	mov    %edx,%esi
    char buf[32];
    const char *digits_lower = "0123456789abcdef";
    const char *digits_upper = "0123456789ABCDEF";
    const char *digits = uppercase ? digits_upper : digits_lower;
  800039:	85 c9                	test   %ecx,%ecx
  80003b:	74 33                	je     800070 <print_unsigned+0x44>
  80003d:	bf c4 04 80 00       	mov    $0x8004c4,%edi
    int i = 0;

    if (value == 0)
  800042:	85 db                	test   %ebx,%ebx
  800044:	75 33                	jne    800079 <print_unsigned+0x4d>
    {
        buf[i++] = '0';
  800046:	c6 45 c8 30          	movb   $0x30,-0x38(%ebp)
  80004a:	be 01 00 00 00       	mov    $0x1,%esi
  80004f:	31 ff                	xor    %edi,%edi
  800051:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
  800058:	8d 55 c8             	lea    -0x38(%ebp),%edx
        char tmp = buf[l];
        buf[l] = buf[r];
        buf[r] = tmp;
    }

    write(stdout, buf, i);
  80005b:	57                   	push   %edi
  80005c:	56                   	push   %esi
  80005d:	52                   	push   %edx
  80005e:	6a 01                	push   $0x1
  800060:	e8 d3 03 00 00       	call   800438 <write>
    return i;
}
  800065:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800068:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80006b:	5b                   	pop    %ebx
  80006c:	5e                   	pop    %esi
  80006d:	5f                   	pop    %edi
  80006e:	5d                   	pop    %ebp
  80006f:	c3                   	ret
    const char *digits = uppercase ? digits_upper : digits_lower;
  800070:	bf d5 04 80 00       	mov    $0x8004d5,%edi
    if (value == 0)
  800075:	85 db                	test   %ebx,%ebx
  800077:	74 cd                	je     800046 <print_unsigned+0x1a>
    int i = 0;
  800079:	31 c9                	xor    %ecx,%ecx
  80007b:	eb 08                	jmp    800085 <print_unsigned+0x59>
  80007d:	8d 76 00             	lea    0x0(%esi),%esi
        while (value != 0 && i < (int)sizeof(buf))
  800080:	83 f9 20             	cmp    $0x20,%ecx
  800083:	74 53                	je     8000d8 <print_unsigned+0xac>
            int d = value % base;
  800085:	89 d8                	mov    %ebx,%eax
  800087:	31 d2                	xor    %edx,%edx
  800089:	f7 f6                	div    %esi
            buf[i++] = digits[d];
  80008b:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  80008e:	41                   	inc    %ecx
  80008f:	8a 14 17             	mov    (%edi,%edx,1),%dl
  800092:	88 55 c7             	mov    %dl,-0x39(%ebp)
  800095:	88 54 0d c7          	mov    %dl,-0x39(%ebp,%ecx,1)
            value /= base;
  800099:	89 da                	mov    %ebx,%edx
  80009b:	89 c3                	mov    %eax,%ebx
        while (value != 0 && i < (int)sizeof(buf))
  80009d:	39 f2                	cmp    %esi,%edx
  80009f:	73 df                	jae    800080 <print_unsigned+0x54>
    write(stdout, buf, i);
  8000a1:	89 c8                	mov    %ecx,%eax
  8000a3:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  8000a6:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  8000a9:	89 c6                	mov    %eax,%esi
  8000ab:	89 c7                	mov    %eax,%edi
  8000ad:	c1 ff 1f             	sar    $0x1f,%edi
    for (int l = 0, r = i - 1; l < r; ++l, --r)
  8000b0:	8d 55 c8             	lea    -0x38(%ebp),%edx
  8000b3:	85 c9                	test   %ecx,%ecx
  8000b5:	74 a4                	je     80005b <print_unsigned+0x2f>
  8000b7:	31 c0                	xor    %eax,%eax
  8000b9:	8d 55 c8             	lea    -0x38(%ebp),%edx
        char tmp = buf[l];
  8000bc:	8a 1c 02             	mov    (%edx,%eax,1),%bl
  8000bf:	88 5d c7             	mov    %bl,-0x39(%ebp)
        buf[l] = buf[r];
  8000c2:	8a 1c 0a             	mov    (%edx,%ecx,1),%bl
  8000c5:	88 1c 02             	mov    %bl,(%edx,%eax,1)
        buf[r] = tmp;
  8000c8:	8a 5d c7             	mov    -0x39(%ebp),%bl
  8000cb:	88 1c 0a             	mov    %bl,(%edx,%ecx,1)
    for (int l = 0, r = i - 1; l < r; ++l, --r)
  8000ce:	40                   	inc    %eax
  8000cf:	49                   	dec    %ecx
  8000d0:	39 c8                	cmp    %ecx,%eax
  8000d2:	7c e8                	jl     8000bc <print_unsigned+0x90>
  8000d4:	eb 85                	jmp    80005b <print_unsigned+0x2f>
  8000d6:	66 90                	xchg   %ax,%ax
  8000d8:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  8000db:	b9 1f 00 00 00       	mov    $0x1f,%ecx
  8000e0:	be 20 00 00 00       	mov    $0x20,%esi
  8000e5:	31 ff                	xor    %edi,%edi
  8000e7:	eb ce                	jmp    8000b7 <print_unsigned+0x8b>
  8000e9:	8d 76 00             	lea    0x0(%esi),%esi

008000ec <vprintf>:
    write(stdout, buf, idx);
    return idx;
}

int vprintf(const char *fmt, va_list ap)
{
  8000ec:	55                   	push   %ebp
  8000ed:	89 e5                	mov    %esp,%ebp
  8000ef:	57                   	push   %edi
  8000f0:	56                   	push   %esi
  8000f1:	53                   	push   %ebx
  8000f2:	83 ec 6c             	sub    $0x6c,%esp
  8000f5:	8b 75 08             	mov    0x8(%ebp),%esi
    int count = 0;

    for (; *fmt; fmt++)
  8000f8:	8a 06                	mov    (%esi),%al
    int count = 0;
  8000fa:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
    for (; *fmt; fmt++)
  800101:	84 c0                	test   %al,%al
  800103:	75 2b                	jne    800130 <vprintf+0x44>
  800105:	e9 88 00 00 00       	jmp    800192 <vprintf+0xa6>
  80010a:	66 90                	xchg   %ax,%ax
    {
        if (*fmt != '%')
        {
            uputc(*fmt);
  80010c:	88 45 c6             	mov    %al,-0x3a(%ebp)
    write(stdout, &c, 1);
  80010f:	6a 00                	push   $0x0
  800111:	6a 01                	push   $0x1
  800113:	8d 45 c6             	lea    -0x3a(%ebp),%eax
  800116:	50                   	push   %eax
  800117:	6a 01                	push   $0x1
  800119:	e8 1a 03 00 00       	call   800438 <write>
            count++;
  80011e:	ff 45 94             	incl   -0x6c(%ebp)
            continue;
  800121:	83 c4 10             	add    $0x10,%esp
  800124:	89 f3                	mov    %esi,%ebx
    for (; *fmt; fmt++)
  800126:	8d 73 01             	lea    0x1(%ebx),%esi
  800129:	8a 43 01             	mov    0x1(%ebx),%al
  80012c:	84 c0                	test   %al,%al
  80012e:	74 62                	je     800192 <vprintf+0xa6>
        if (*fmt != '%')
  800130:	3c 25                	cmp    $0x25,%al
  800132:	75 d8                	jne    80010c <vprintf+0x20>
        }

        fmt++; // skip '%'

        if (*fmt == '\0')
  800134:	8a 46 01             	mov    0x1(%esi),%al
  800137:	84 c0                	test   %al,%al
  800139:	74 57                	je     800192 <vprintf+0xa6>
        fmt++; // skip '%'
  80013b:	8d 5e 01             	lea    0x1(%esi),%ebx
            break;

        int long_flag = 0;
        while (*fmt == 'l')
  80013e:	3c 6c                	cmp    $0x6c,%al
  800140:	0f 85 e6 01 00 00    	jne    80032c <vprintf+0x240>
  800146:	66 90                	xchg   %ax,%ax
        {
            long_flag++;
            fmt++;
  800148:	43                   	inc    %ebx
        while (*fmt == 'l')
  800149:	8a 03                	mov    (%ebx),%al
  80014b:	3c 6c                	cmp    $0x6c,%al
  80014d:	74 f9                	je     800148 <vprintf+0x5c>
        }

        switch (*fmt)
  80014f:	3c 25                	cmp    $0x25,%al
  800151:	0f 84 d9 01 00 00    	je     800330 <vprintf+0x244>
  800157:	83 e8 58             	sub    $0x58,%eax
  80015a:	3c 20                	cmp    $0x20,%al
  80015c:	77 0a                	ja     800168 <vprintf+0x7c>
  80015e:	0f b6 c0             	movzbl %al,%eax
  800161:	ff 24 85 1c 05 80 00 	jmp    *0x80051c(,%eax,4)
    size_t len = 0;
  800168:	31 f6                	xor    %esi,%esi
  80016a:	31 ff                	xor    %edi,%edi
        len++;
  80016c:	83 c6 01             	add    $0x1,%esi
  80016f:	83 d7 00             	adc    $0x0,%edi
    while (*p++)
  800172:	89 f0                	mov    %esi,%eax
  800174:	80 be ed 04 80 00 00 	cmpb   $0x0,0x8004ed(%esi)
  80017b:	75 ef                	jne    80016c <vprintf+0x80>
    if (len > 0)
  80017d:	09 f8                	or     %edi,%eax
  80017f:	0f 85 0d 02 00 00    	jne    800392 <vprintf+0x2a6>
        (*count) += (int)len;
  800185:	01 75 94             	add    %esi,-0x6c(%ebp)
    for (; *fmt; fmt++)
  800188:	8d 73 01             	lea    0x1(%ebx),%esi
  80018b:	8a 43 01             	mov    0x1(%ebx),%al
  80018e:	84 c0                	test   %al,%al
  800190:	75 9e                	jne    800130 <vprintf+0x44>
            break;
        }
    }

    return count;
}
  800192:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800195:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800198:	5b                   	pop    %ebx
  800199:	5e                   	pop    %esi
  80019a:	5f                   	pop    %edi
  80019b:	5d                   	pop    %ebp
  80019c:	c3                   	ret
                long v = va_arg(ap, long);
  80019d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001a0:	8b 30                	mov    (%eax),%esi
    if (value < 0)
  8001a2:	85 f6                	test   %esi,%esi
  8001a4:	0f 88 16 02 00 00    	js     8003c0 <vprintf+0x2d4>
        u = (unsigned long)value;
  8001aa:	89 f0                	mov    %esi,%eax
    int count = 0;
  8001ac:	31 f6                	xor    %esi,%esi
                long v = va_arg(ap, long);
  8001ae:	83 45 0c 04          	addl   $0x4,0xc(%ebp)
    count += print_unsigned(u, base, 0);
  8001b2:	31 c9                	xor    %ecx,%ecx
  8001b4:	ba 0a 00 00 00       	mov    $0xa,%edx
  8001b9:	e8 6e fe ff ff       	call   80002c <print_unsigned>
  8001be:	01 f0                	add    %esi,%eax
                count += print_signed(v, 10);
  8001c0:	01 45 94             	add    %eax,-0x6c(%ebp)
  8001c3:	e9 5e ff ff ff       	jmp    800126 <vprintf+0x3a>
            void *p = va_arg(ap, void *);
  8001c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001cb:	8d 78 04             	lea    0x4(%eax),%edi
  8001ce:	8b 00                	mov    (%eax),%eax
    buf[idx++] = '0';
  8001d0:	66 c7 45 c6 30 78    	movw   $0x7830,-0x3a(%ebp)
    if (value == 0)
  8001d6:	85 c0                	test   %eax,%eax
  8001d8:	0f 84 cd 01 00 00    	je     8003ab <vprintf+0x2bf>
    int i = 0;
  8001de:	31 c9                	xor    %ecx,%ecx
  8001e0:	89 5d 8c             	mov    %ebx,-0x74(%ebp)
  8001e3:	eb 0c                	jmp    8001f1 <vprintf+0x105>
  8001e5:	8d 76 00             	lea    0x0(%esi),%esi
        while (value != 0 && i < (int)sizeof(tmp))
  8001e8:	83 f9 20             	cmp    $0x20,%ecx
  8001eb:	0f 84 ff 01 00 00    	je     8003f0 <vprintf+0x304>
            tmp[i++] = digits[d];
  8001f1:	89 ca                	mov    %ecx,%edx
  8001f3:	8d 49 01             	lea    0x1(%ecx),%ecx
  8001f6:	89 c6                	mov    %eax,%esi
  8001f8:	83 e6 0f             	and    $0xf,%esi
  8001fb:	8a 9e d5 04 80 00    	mov    0x8004d5(%esi),%bl
  800201:	88 5d 90             	mov    %bl,-0x70(%ebp)
  800204:	88 5c 15 a6          	mov    %bl,-0x5a(%ebp,%edx,1)
        while (value != 0 && i < (int)sizeof(tmp))
  800208:	c1 e8 04             	shr    $0x4,%eax
  80020b:	75 db                	jne    8001e8 <vprintf+0xfc>
  80020d:	8b 5d 8c             	mov    -0x74(%ebp),%ebx
  800210:	8d 45 a6             	lea    -0x5a(%ebp),%eax
  800213:	8d 54 15 a6          	lea    -0x5a(%ebp,%edx,1),%edx
  800217:	be 02 00 00 00       	mov    $0x2,%esi
  80021c:	eb 0c                	jmp    80022a <vprintf+0x13e>
  80021e:	66 90                	xchg   %ax,%ax
    while (i-- > 0 && idx < (int)sizeof(buf))
  800220:	4a                   	dec    %edx
  800221:	83 fe 22             	cmp    $0x22,%esi
  800224:	0f 84 ba 01 00 00    	je     8003e4 <vprintf+0x2f8>
        buf[idx++] = tmp[i];
  80022a:	46                   	inc    %esi
  80022b:	8a 0a                	mov    (%edx),%cl
  80022d:	88 4c 35 c5          	mov    %cl,-0x3b(%ebp,%esi,1)
    while (i-- > 0 && idx < (int)sizeof(buf))
  800231:	39 d0                	cmp    %edx,%eax
  800233:	75 eb                	jne    800220 <vprintf+0x134>
    write(stdout, buf, idx);
  800235:	89 f0                	mov    %esi,%eax
  800237:	99                   	cltd
  800238:	52                   	push   %edx
  800239:	50                   	push   %eax
  80023a:	8d 45 c6             	lea    -0x3a(%ebp),%eax
  80023d:	50                   	push   %eax
  80023e:	6a 01                	push   $0x1
  800240:	e8 f3 01 00 00       	call   800438 <write>
            count += print_pointer(p);
  800245:	01 75 94             	add    %esi,-0x6c(%ebp)
            break;
  800248:	83 c4 10             	add    $0x10,%esp
            void *p = va_arg(ap, void *);
  80024b:	89 7d 0c             	mov    %edi,0xc(%ebp)
            break;
  80024e:	e9 d3 fe ff ff       	jmp    800126 <vprintf+0x3a>
                long v = va_arg(ap, long);
  800253:	8b 45 0c             	mov    0xc(%ebp),%eax
  800256:	8d 70 04             	lea    0x4(%eax),%esi
                count += print_unsigned(v, 16, 0);
  800259:	8b 00                	mov    (%eax),%eax
  80025b:	31 c9                	xor    %ecx,%ecx
  80025d:	ba 10 00 00 00       	mov    $0x10,%edx
  800262:	e8 c5 fd ff ff       	call   80002c <print_unsigned>
  800267:	01 45 94             	add    %eax,-0x6c(%ebp)
                unsigned int v = va_arg(ap, unsigned int);
  80026a:	89 75 0c             	mov    %esi,0xc(%ebp)
  80026d:	e9 b4 fe ff ff       	jmp    800126 <vprintf+0x3a>
            int c = va_arg(ap, int);
  800272:	8b 45 0c             	mov    0xc(%ebp),%eax
  800275:	8d 70 04             	lea    0x4(%eax),%esi
            uputc((char)c);
  800278:	8b 00                	mov    (%eax),%eax
  80027a:	88 45 c6             	mov    %al,-0x3a(%ebp)
    write(stdout, &c, 1);
  80027d:	6a 00                	push   $0x0
  80027f:	6a 01                	push   $0x1
  800281:	8d 45 c6             	lea    -0x3a(%ebp),%eax
  800284:	50                   	push   %eax
  800285:	6a 01                	push   $0x1
  800287:	e8 ac 01 00 00       	call   800438 <write>
            count++;
  80028c:	ff 45 94             	incl   -0x6c(%ebp)
            break;
  80028f:	83 c4 10             	add    $0x10,%esp
            int c = va_arg(ap, int);
  800292:	89 75 0c             	mov    %esi,0xc(%ebp)
            break;
  800295:	e9 8c fe ff ff       	jmp    800126 <vprintf+0x3a>
                unsigned int v = va_arg(ap, unsigned int);
  80029a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80029d:	8d 70 04             	lea    0x4(%eax),%esi
                count += print_unsigned(v, 16, 1);
  8002a0:	8b 00                	mov    (%eax),%eax
  8002a2:	b9 01 00 00 00       	mov    $0x1,%ecx
  8002a7:	ba 10 00 00 00       	mov    $0x10,%edx
  8002ac:	e8 7b fd ff ff       	call   80002c <print_unsigned>
  8002b1:	01 45 94             	add    %eax,-0x6c(%ebp)
                unsigned int v = va_arg(ap, unsigned int);
  8002b4:	89 75 0c             	mov    %esi,0xc(%ebp)
  8002b7:	e9 6a fe ff ff       	jmp    800126 <vprintf+0x3a>
                long v = va_arg(ap, long);
  8002bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002bf:	8d 70 04             	lea    0x4(%eax),%esi
                count += print_unsigned(v, 10, 0);
  8002c2:	8b 00                	mov    (%eax),%eax
  8002c4:	31 c9                	xor    %ecx,%ecx
  8002c6:	ba 0a 00 00 00       	mov    $0xa,%edx
  8002cb:	e8 5c fd ff ff       	call   80002c <print_unsigned>
  8002d0:	01 45 94             	add    %eax,-0x6c(%ebp)
                unsigned int v = va_arg(ap, unsigned int);
  8002d3:	89 75 0c             	mov    %esi,0xc(%ebp)
  8002d6:	e9 4b fe ff ff       	jmp    800126 <vprintf+0x3a>
            const char *s = va_arg(ap, const char *);
  8002db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002de:	83 c0 04             	add    $0x4,%eax
  8002e1:	89 45 90             	mov    %eax,-0x70(%ebp)
  8002e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002e7:	8b 00                	mov    (%eax),%eax
    if (!s)
  8002e9:	85 c0                	test   %eax,%eax
  8002eb:	0f 84 c5 00 00 00    	je     8003b6 <vprintf+0x2ca>
    while (*p++)
  8002f1:	80 38 00             	cmpb   $0x0,(%eax)
  8002f4:	74 28                	je     80031e <vprintf+0x232>
    size_t len = 0;
  8002f6:	31 f6                	xor    %esi,%esi
  8002f8:	31 ff                	xor    %edi,%edi
  8002fa:	66 90                	xchg   %ax,%ax
        len++;
  8002fc:	83 c6 01             	add    $0x1,%esi
  8002ff:	83 d7 00             	adc    $0x0,%edi
    while (*p++)
  800302:	89 f2                	mov    %esi,%edx
  800304:	80 3c 30 00          	cmpb   $0x0,(%eax,%esi,1)
  800308:	75 f2                	jne    8002fc <vprintf+0x210>
    if (len > 0)
  80030a:	09 fa                	or     %edi,%edx
  80030c:	74 0d                	je     80031b <vprintf+0x22f>
        write(stdout, s, len);
  80030e:	57                   	push   %edi
  80030f:	56                   	push   %esi
  800310:	50                   	push   %eax
  800311:	6a 01                	push   $0x1
  800313:	e8 20 01 00 00       	call   800438 <write>
  800318:	83 c4 10             	add    $0x10,%esp
        (*count) += (int)len;
  80031b:	01 75 94             	add    %esi,-0x6c(%ebp)
            const char *s = va_arg(ap, const char *);
  80031e:	8b 45 90             	mov    -0x70(%ebp),%eax
  800321:	89 45 0c             	mov    %eax,0xc(%ebp)
  800324:	e9 fd fd ff ff       	jmp    800126 <vprintf+0x3a>
  800329:	8d 76 00             	lea    0x0(%esi),%esi
        switch (*fmt)
  80032c:	3c 25                	cmp    $0x25,%al
  80032e:	75 20                	jne    800350 <vprintf+0x264>
            uputc('%');
  800330:	c6 45 c6 25          	movb   $0x25,-0x3a(%ebp)
    write(stdout, &c, 1);
  800334:	6a 00                	push   $0x0
  800336:	6a 01                	push   $0x1
  800338:	8d 45 c6             	lea    -0x3a(%ebp),%eax
  80033b:	50                   	push   %eax
  80033c:	6a 01                	push   $0x1
  80033e:	e8 f5 00 00 00       	call   800438 <write>
            count++;
  800343:	ff 45 94             	incl   -0x6c(%ebp)
            break;
  800346:	83 c4 10             	add    $0x10,%esp
  800349:	e9 d8 fd ff ff       	jmp    800126 <vprintf+0x3a>
  80034e:	66 90                	xchg   %ax,%ax
        switch (*fmt)
  800350:	83 e8 58             	sub    $0x58,%eax
  800353:	3c 20                	cmp    $0x20,%al
  800355:	0f 87 0d fe ff ff    	ja     800168 <vprintf+0x7c>
  80035b:	0f b6 c0             	movzbl %al,%eax
  80035e:	ff 24 85 a0 05 80 00 	jmp    *0x8005a0(,%eax,4)
                long v = va_arg(ap, long);
  800365:	8b 45 0c             	mov    0xc(%ebp),%eax
  800368:	8d 70 04             	lea    0x4(%eax),%esi
                int v = va_arg(ap, int);
  80036b:	8b 38                	mov    (%eax),%edi
    if (value < 0)
  80036d:	85 ff                	test   %edi,%edi
  80036f:	0f 88 88 00 00 00    	js     8003fd <vprintf+0x311>
        u = (unsigned long)value;
  800375:	89 f8                	mov    %edi,%eax
    int count = 0;
  800377:	31 ff                	xor    %edi,%edi
    count += print_unsigned(u, base, 0);
  800379:	31 c9                	xor    %ecx,%ecx
  80037b:	ba 0a 00 00 00       	mov    $0xa,%edx
  800380:	e8 a7 fc ff ff       	call   80002c <print_unsigned>
  800385:	01 f8                	add    %edi,%eax
                count += print_signed(v, 10);
  800387:	01 45 94             	add    %eax,-0x6c(%ebp)
                int v = va_arg(ap, int);
  80038a:	89 75 0c             	mov    %esi,0xc(%ebp)
  80038d:	e9 94 fd ff ff       	jmp    800126 <vprintf+0x3a>
        write(stdout, s, len);
  800392:	57                   	push   %edi
  800393:	56                   	push   %esi
  800394:	68 ed 04 80 00       	push   $0x8004ed
  800399:	6a 01                	push   $0x1
  80039b:	e8 98 00 00 00       	call   800438 <write>
  8003a0:	83 c4 10             	add    $0x10,%esp
        (*count) += (int)len;
  8003a3:	01 75 94             	add    %esi,-0x6c(%ebp)
            break;
  8003a6:	e9 dd fd ff ff       	jmp    800188 <vprintf+0x9c>
        tmp[i++] = '0';
  8003ab:	c6 45 a6 30          	movb   $0x30,-0x5a(%ebp)
    while (i-- > 0 && idx < (int)sizeof(buf))
  8003af:	31 d2                	xor    %edx,%edx
  8003b1:	e9 5a fe ff ff       	jmp    800210 <vprintf+0x124>
        s = "(null)";
  8003b6:	b8 e6 04 80 00       	mov    $0x8004e6,%eax
  8003bb:	e9 36 ff ff ff       	jmp    8002f6 <vprintf+0x20a>
        uputc('-');
  8003c0:	c6 45 c6 2d          	movb   $0x2d,-0x3a(%ebp)
    write(stdout, &c, 1);
  8003c4:	6a 00                	push   $0x0
  8003c6:	6a 01                	push   $0x1
  8003c8:	8d 45 c6             	lea    -0x3a(%ebp),%eax
  8003cb:	50                   	push   %eax
  8003cc:	6a 01                	push   $0x1
  8003ce:	e8 65 00 00 00       	call   800438 <write>
        u = (unsigned long)(-value);
  8003d3:	89 f0                	mov    %esi,%eax
  8003d5:	f7 d8                	neg    %eax
  8003d7:	83 c4 10             	add    $0x10,%esp
        count++;
  8003da:	be 01 00 00 00       	mov    $0x1,%esi
  8003df:	e9 ca fd ff ff       	jmp    8001ae <vprintf+0xc2>
  8003e4:	b8 22 00 00 00       	mov    $0x22,%eax
  8003e9:	31 d2                	xor    %edx,%edx
  8003eb:	e9 48 fe ff ff       	jmp    800238 <vprintf+0x14c>
  8003f0:	8b 5d 8c             	mov    -0x74(%ebp),%ebx
  8003f3:	ba 1f 00 00 00       	mov    $0x1f,%edx
  8003f8:	e9 13 fe ff ff       	jmp    800210 <vprintf+0x124>
        uputc('-');
  8003fd:	c6 45 c6 2d          	movb   $0x2d,-0x3a(%ebp)
    write(stdout, &c, 1);
  800401:	6a 00                	push   $0x0
  800403:	6a 01                	push   $0x1
  800405:	8d 45 c6             	lea    -0x3a(%ebp),%eax
  800408:	50                   	push   %eax
  800409:	6a 01                	push   $0x1
  80040b:	e8 28 00 00 00       	call   800438 <write>
        u = (unsigned long)(-value);
  800410:	89 f8                	mov    %edi,%eax
  800412:	f7 d8                	neg    %eax
  800414:	83 c4 10             	add    $0x10,%esp
        count++;
  800417:	bf 01 00 00 00       	mov    $0x1,%edi
  80041c:	e9 58 ff ff ff       	jmp    800379 <vprintf+0x28d>
  800421:	8d 76 00             	lea    0x0(%esi),%esi

00800424 <printf>:

int printf(const char *fmt, ...)
{
  800424:	55                   	push   %ebp
  800425:	89 e5                	mov    %esp,%ebp
  800427:	83 ec 10             	sub    $0x10,%esp
    va_list ap;
    va_start(ap, fmt);
  80042a:	8d 45 0c             	lea    0xc(%ebp),%eax
    int ret = vprintf(fmt, ap);
  80042d:	50                   	push   %eax
  80042e:	ff 75 08             	push   0x8(%ebp)
  800431:	e8 b6 fc ff ff       	call   8000ec <vprintf>
    va_end(ap);
    return ret;
}
  800436:	c9                   	leave
  800437:	c3                   	ret

00800438 <write>:
#include "syscall.h"
#include "syscall_ids.h"
#include "stddef.h"

ssize_t write(int fd, const void *buf, size_t count)
{
  800438:	55                   	push   %ebp
  800439:	89 e5                	mov    %esp,%ebp
  80043b:	53                   	push   %ebx
}

static inline long __syscall3(long n, long a, long b, long c)
{
    long ret;
    __asm__ __volatile__(
  80043c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80043f:	b8 40 00 00 00       	mov    $0x40,%eax
  800444:	8b 55 10             	mov    0x10(%ebp),%edx
  800447:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80044a:	cd 80                	int    $0x80
    return (ssize_t)syscall(SYS_write, fd, (long)buf, (long)count);
  80044c:	99                   	cltd
}
  80044d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800450:	c9                   	leave
  800451:	c3                   	ret
  800452:	66 90                	xchg   %ax,%ax

00800454 <exit>:

void exit(int code)
{
  800454:	55                   	push   %ebp
  800455:	89 e5                	mov    %esp,%ebp
  800457:	53                   	push   %ebx
    __asm__ __volatile__(
  800458:	b8 5d 00 00 00       	mov    $0x5d,%eax
  80045d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800460:	cd 80                	int    $0x80
    syscall(SYS_exit, code);
}
  800462:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800465:	c9                   	leave
  800466:	c3                   	ret
  800467:	90                   	nop

00800468 <main>:
#include"stdio.h"
int main() {
  800468:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  80046c:	83 e4 f0             	and    $0xfffffff0,%esp
  80046f:	ff 71 fc             	push   -0x4(%ecx)
  800472:	55                   	push   %ebp
  800473:	89 e5                	mov    %esp,%ebp
  800475:	57                   	push   %edi
  800476:	56                   	push   %esi
  800477:	51                   	push   %ecx
  800478:	83 ec 28             	sub    $0x28,%esp
   printf("Hello World,there is user app\n");
  80047b:	68 24 06 80 00       	push   $0x800624
  800480:	e8 9f ff ff ff       	call   800424 <printf>
   printf("%d + %d = %d\n", 1, 2, 1 + 2);
  800485:	6a 03                	push   $0x3
  800487:	6a 02                	push   $0x2
  800489:	6a 01                	push   $0x1
  80048b:	68 f1 04 80 00       	push   $0x8004f1
  800490:	e8 8f ff ff ff       	call   800424 <printf>

   char s[]="Sample String";
  800495:	8d 7d da             	lea    -0x26(%ebp),%edi
  800498:	be 0b 05 80 00       	mov    $0x80050b,%esi
  80049d:	b9 0e 00 00 00       	mov    $0xe,%ecx
  8004a2:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
   printf("String: %s\n", s);
  8004a4:	83 c4 18             	add    $0x18,%esp
  8004a7:	8d 45 da             	lea    -0x26(%ebp),%eax
  8004aa:	50                   	push   %eax
  8004ab:	68 ff 04 80 00       	push   $0x8004ff
  8004b0:	e8 6f ff ff ff       	call   800424 <printf>
   return 0;
  8004b5:	31 c0                	xor    %eax,%eax
  8004b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004ba:	59                   	pop    %ecx
  8004bb:	5e                   	pop    %esi
  8004bc:	5f                   	pop    %edi
  8004bd:	5d                   	pop    %ebp
  8004be:	8d 61 fc             	lea    -0x4(%ecx),%esp
  8004c1:	c3                   	ret
