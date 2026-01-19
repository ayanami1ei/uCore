
build/kernel:     file format elf32-i386


Disassembly of section .text:

0010000c <_start>:
    .section .text.entry, "ax"
    .code32                 # 明确告诉汇编器是 32 位代码
    .globl _start
_start:
    # 初始化内核栈指针 ESP
    mov $boot_stack_top, %esp
  10000c:	bc 00 40 11 00       	mov    $0x114000,%esp

    call main               # 调到 C 里的 main()
  100011:	e8 38 04 00 00       	call   10044e <main>

00100016 <.hang>:

    # 如果 main 返回，简单死循环或停机
.hang:
    hlt
  100016:	f4                   	hlt
    jmp .hang
  100017:	eb fd                	jmp    100016 <.hang>

00100019 <print_unsigned>:
            (*count)++;
    }
}

static int print_unsigned(unsigned long value, int base, int uppercase)
{
  100019:	55                   	push   %ebp
  10001a:	89 e5                	mov    %esp,%ebp
  10001c:	57                   	push   %edi
  10001d:	56                   	push   %esi
  10001e:	53                   	push   %ebx
  10001f:	83 ec 3c             	sub    $0x3c,%esp
  100022:	89 d6                	mov    %edx,%esi
    char buf[32];
    const char *digits_lower = "0123456789abcdef";
    const char *digits_upper = "0123456789ABCDEF";
    const char *digits = uppercase ? digits_upper : digits_lower;
  100024:	85 c9                	test   %ecx,%ecx
  100026:	74 40                	je     100068 <print_unsigned+0x4f>
  100028:	bf 00 20 10 00       	mov    $0x102000,%edi
    int i = 0;

    if (value == 0)
  10002d:	85 c0                	test   %eax,%eax
  10002f:	74 3e                	je     10006f <print_unsigned+0x56>
    int i = 0;
  100031:	b9 00 00 00 00       	mov    $0x0,%ecx
    }

    while (value != 0 && i < (int)sizeof(buf))
    {
        int d = value % base;
        buf[i++] = digits[d];
  100036:	89 c3                	mov    %eax,%ebx
  100038:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  10003b:	41                   	inc    %ecx
        int d = value % base;
  10003c:	89 d8                	mov    %ebx,%eax
  10003e:	ba 00 00 00 00       	mov    $0x0,%edx
  100043:	f7 f6                	div    %esi
        buf[i++] = digits[d];
  100045:	8a 14 17             	mov    (%edi,%edx,1),%dl
  100048:	88 55 c7             	mov    %dl,-0x39(%ebp)
  10004b:	88 54 0d c7          	mov    %dl,-0x39(%ebp,%ecx,1)
        value /= base;
  10004f:	89 da                	mov    %ebx,%edx
  100051:	89 c3                	mov    %eax,%ebx
    while (value != 0 && i < (int)sizeof(buf))
  100053:	39 f2                	cmp    %esi,%edx
  100055:	72 2c                	jb     100083 <print_unsigned+0x6a>
  100057:	83 f9 20             	cmp    $0x20,%ecx
  10005a:	75 dc                	jne    100038 <print_unsigned+0x1f>
  10005c:	be 1f 00 00 00       	mov    $0x1f,%esi
    }

    int count = 0;
    while (i-- > 0)
  100061:	bb 1f 00 00 00       	mov    $0x1f,%ebx
  100066:	eb 24                	jmp    10008c <print_unsigned+0x73>
    const char *digits = uppercase ? digits_upper : digits_lower;
  100068:	bf 11 20 10 00       	mov    $0x102011,%edi
  10006d:	eb be                	jmp    10002d <print_unsigned+0x14>
    put_char(c);
  10006f:	83 ec 0c             	sub    $0xc,%esp
  100072:	6a 30                	push   $0x30
  100074:	e8 40 0c 00 00       	call   100cb9 <put_char>
    return;
  100079:	83 c4 10             	add    $0x10,%esp
        return 1;
  10007c:	b8 01 00 00 00       	mov    $0x1,%eax
    return;
  100081:	eb 28                	jmp    1000ab <print_unsigned+0x92>
    while (i-- > 0)
  100083:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  100086:	85 c9                	test   %ecx,%ecx
  100088:	7e 29                	jle    1000b3 <print_unsigned+0x9a>
  10008a:	89 de                	mov    %ebx,%esi
    put_char(c);
  10008c:	83 ec 0c             	sub    $0xc,%esp
  10008f:	0f be 44 2b c8       	movsbl -0x38(%ebx,%ebp,1),%eax
  100094:	50                   	push   %eax
  100095:	e8 1f 0c 00 00       	call   100cb9 <put_char>
    while (i-- > 0)
  10009a:	89 d8                	mov    %ebx,%eax
  10009c:	4b                   	dec    %ebx
  10009d:	83 c4 10             	add    $0x10,%esp
  1000a0:	85 c0                	test   %eax,%eax
  1000a2:	7f e8                	jg     10008c <print_unsigned+0x73>
  1000a4:	89 f0                	mov    %esi,%eax
  1000a6:	85 f6                	test   %esi,%esi
  1000a8:	78 10                	js     1000ba <print_unsigned+0xa1>
  1000aa:	40                   	inc    %eax
    {
        kputc(buf[i]);
        count++;
    }
    return count;
}
  1000ab:	8d 65 f4             	lea    -0xc(%ebp),%esp
  1000ae:	5b                   	pop    %ebx
  1000af:	5e                   	pop    %esi
  1000b0:	5f                   	pop    %edi
  1000b1:	5d                   	pop    %ebp
  1000b2:	c3                   	ret
    return count;
  1000b3:	b8 00 00 00 00       	mov    $0x0,%eax
  1000b8:	eb f1                	jmp    1000ab <print_unsigned+0x92>
  1000ba:	b8 00 00 00 00       	mov    $0x0,%eax
  1000bf:	eb e9                	jmp    1000aa <print_unsigned+0x91>

001000c1 <vprintf>:
    count += print_unsigned((unsigned long long)(uintptr_t)ptr, 16, 0);
    return count;
}

int vprintf(const char *fmt, va_list ap)
{
  1000c1:	55                   	push   %ebp
  1000c2:	89 e5                	mov    %esp,%ebp
  1000c4:	57                   	push   %edi
  1000c5:	56                   	push   %esi
  1000c6:	53                   	push   %ebx
  1000c7:	83 ec 2c             	sub    $0x2c,%esp
  1000ca:	8b 75 08             	mov    0x8(%ebp),%esi
    int count = 0;

    for (; *fmt; fmt++)
  1000cd:	8a 06                	mov    (%esi),%al
  1000cf:	84 c0                	test   %al,%al
  1000d1:	0f 84 2b 03 00 00    	je     100402 <vprintf+0x341>
    int count = 0;
  1000d7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  1000de:	e9 77 02 00 00       	jmp    10035a <vprintf+0x299>
            continue;
        }

        fmt++; // skip '%'

        if (*fmt == '\0')
  1000e3:	8a 46 01             	mov    0x1(%esi),%al
  1000e6:	84 c0                	test   %al,%al
  1000e8:	0f 84 1b 03 00 00    	je     100409 <vprintf+0x348>
            break;

        // 暂时只支持一个或零个 'l' 修饰符
        int long_flag = 0;
        while (*fmt == 'l')
  1000ee:	3c 6c                	cmp    $0x6c,%al
  1000f0:	0f 85 1e 03 00 00    	jne    100414 <vprintf+0x353>
  1000f6:	8d 4e 02             	lea    0x2(%esi),%ecx
  1000f9:	89 ca                	mov    %ecx,%edx
  1000fb:	41                   	inc    %ecx
  1000fc:	8a 41 ff             	mov    -0x1(%ecx),%al
  1000ff:	3c 6c                	cmp    $0x6c,%al
  100101:	74 f6                	je     1000f9 <vprintf+0x38>
        {
            long_flag++;
            fmt++;
  100103:	89 d7                	mov    %edx,%edi
        }

        switch (*fmt)
  100105:	3c 25                	cmp    $0x25,%al
  100107:	0f 84 d5 02 00 00    	je     1003e2 <vprintf+0x321>
  10010d:	8d 48 a8             	lea    -0x58(%eax),%ecx
  100110:	80 f9 20             	cmp    $0x20,%cl
  100113:	77 14                	ja     100129 <vprintf+0x68>
            long_flag++;
  100115:	29 f2                	sub    %esi,%edx
  100117:	8d 5a ff             	lea    -0x1(%edx),%ebx
        switch (*fmt)
  10011a:	80 f9 20             	cmp    $0x20,%cl
  10011d:	77 0a                	ja     100129 <vprintf+0x68>
  10011f:	0f b6 c1             	movzbl %cl,%eax
  100122:	ff 24 85 30 20 10 00 	jmp    *0x102030(,%eax,4)
    while (*s)
  100129:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10012c:	89 d3                	mov    %edx,%ebx
  10012e:	b0 5b                	mov    $0x5b,%al
  100130:	be 29 20 10 00       	mov    $0x102029,%esi
  100135:	29 d6                	sub    %edx,%esi
    put_char(c);
  100137:	83 ec 0c             	sub    $0xc,%esp
  10013a:	0f be c0             	movsbl %al,%eax
  10013d:	50                   	push   %eax
  10013e:	e8 76 0b 00 00       	call   100cb9 <put_char>
            (*count)++;
  100143:	43                   	inc    %ebx
    while (*s)
  100144:	8a 04 1e             	mov    (%esi,%ebx,1),%al
  100147:	83 c4 10             	add    $0x10,%esp
  10014a:	84 c0                	test   %al,%al
  10014c:	75 e9                	jne    100137 <vprintf+0x76>
  10014e:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  100151:	e9 f6 01 00 00       	jmp    10034c <vprintf+0x28b>
        switch (*fmt)
  100156:	bb 00 00 00 00       	mov    $0x0,%ebx
        {
        case 'd':
        case 'i':
            if (long_flag)
  10015b:	85 db                	test   %ebx,%ebx
  10015d:	74 67                	je     1001c6 <vprintf+0x105>
            {
                long long v = va_arg(ap, long long);
  10015f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100162:	83 c0 08             	add    $0x8,%eax
  100165:	89 45 d8             	mov    %eax,-0x28(%ebp)
  100168:	8b 45 0c             	mov    0xc(%ebp),%eax
  10016b:	8b 18                	mov    (%eax),%ebx
  10016d:	8b 70 04             	mov    0x4(%eax),%esi
    if (value < 0)
  100170:	85 f6                	test   %esi,%esi
  100172:	78 2d                	js     1001a1 <vprintf+0xe0>
        u = (unsigned long long)value;
  100174:	89 5d d0             	mov    %ebx,-0x30(%ebp)
  100177:	89 75 d4             	mov    %esi,-0x2c(%ebp)
    int count = 0;
  10017a:	be 00 00 00 00       	mov    $0x0,%esi
    count += print_unsigned(u, base, 0);
  10017f:	b9 00 00 00 00       	mov    $0x0,%ecx
  100184:	ba 0a 00 00 00       	mov    $0xa,%edx
  100189:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10018c:	e8 88 fe ff ff       	call   100019 <print_unsigned>
  100191:	01 f0                	add    %esi,%eax
                count += print_signed(v, 10);
  100193:	01 45 e4             	add    %eax,-0x1c(%ebp)
                long long v = va_arg(ap, long long);
  100196:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100199:	89 45 0c             	mov    %eax,0xc(%ebp)
  10019c:	e9 ab 01 00 00       	jmp    10034c <vprintf+0x28b>
    put_char(c);
  1001a1:	83 ec 0c             	sub    $0xc,%esp
  1001a4:	6a 2d                	push   $0x2d
  1001a6:	e8 0e 0b 00 00       	call   100cb9 <put_char>
        u = (unsigned long long)(-value);
  1001ab:	89 d8                	mov    %ebx,%eax
  1001ad:	89 f2                	mov    %esi,%edx
  1001af:	f7 d8                	neg    %eax
  1001b1:	83 d2 00             	adc    $0x0,%edx
  1001b4:	f7 da                	neg    %edx
  1001b6:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1001b9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  1001bc:	83 c4 10             	add    $0x10,%esp
        count++;
  1001bf:	be 01 00 00 00       	mov    $0x1,%esi
  1001c4:	eb b9                	jmp    10017f <vprintf+0xbe>
            }
            else
            {
                int v = va_arg(ap, int);
  1001c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1001c9:	83 c0 04             	add    $0x4,%eax
  1001cc:	89 c6                	mov    %eax,%esi
  1001ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  1001d1:	8b 00                	mov    (%eax),%eax
                count += print_signed(v, 10);
  1001d3:	89 c1                	mov    %eax,%ecx
  1001d5:	c1 f9 1f             	sar    $0x1f,%ecx
  1001d8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  1001db:	89 4d dc             	mov    %ecx,-0x24(%ebp)
    if (value < 0)
  1001de:	78 2a                	js     10020a <vprintf+0x149>
        u = (unsigned long long)value;
  1001e0:	89 c1                	mov    %eax,%ecx
  1001e2:	c1 f9 1f             	sar    $0x1f,%ecx
  1001e5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  1001e8:	89 4d dc             	mov    %ecx,-0x24(%ebp)
    count += print_unsigned(u, base, 0);
  1001eb:	b9 00 00 00 00       	mov    $0x0,%ecx
  1001f0:	ba 0a 00 00 00       	mov    $0xa,%edx
  1001f5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1001f8:	e8 1c fe ff ff       	call   100019 <print_unsigned>
  1001fd:	01 d8                	add    %ebx,%eax
                count += print_signed(v, 10);
  1001ff:	01 45 e4             	add    %eax,-0x1c(%ebp)
                int v = va_arg(ap, int);
  100202:	89 75 0c             	mov    %esi,0xc(%ebp)
  100205:	e9 42 01 00 00       	jmp    10034c <vprintf+0x28b>
    put_char(c);
  10020a:	83 ec 0c             	sub    $0xc,%esp
  10020d:	6a 2d                	push   $0x2d
  10020f:	e8 a5 0a 00 00       	call   100cb9 <put_char>
        u = (unsigned long long)(-value);
  100214:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100217:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10021a:	f7 d8                	neg    %eax
  10021c:	83 d2 00             	adc    $0x0,%edx
  10021f:	f7 da                	neg    %edx
  100221:	89 45 d8             	mov    %eax,-0x28(%ebp)
  100224:	89 55 dc             	mov    %edx,-0x24(%ebp)
  100227:	83 c4 10             	add    $0x10,%esp
        count++;
  10022a:	bb 01 00 00 00       	mov    $0x1,%ebx
  10022f:	eb ba                	jmp    1001eb <vprintf+0x12a>
        switch (*fmt)
  100231:	bb 00 00 00 00       	mov    $0x0,%ebx
            }
            break;
        case 'u':
            if (long_flag)
  100236:	85 db                	test   %ebx,%ebx
  100238:	74 22                	je     10025c <vprintf+0x19b>
            {
                unsigned long long v = va_arg(ap, unsigned long long);
  10023a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10023d:	8d 58 08             	lea    0x8(%eax),%ebx
                count += print_unsigned(v, 10, 0);
  100240:	8b 00                	mov    (%eax),%eax
  100242:	b9 00 00 00 00       	mov    $0x0,%ecx
  100247:	ba 0a 00 00 00       	mov    $0xa,%edx
  10024c:	e8 c8 fd ff ff       	call   100019 <print_unsigned>
  100251:	01 45 e4             	add    %eax,-0x1c(%ebp)
                unsigned long long v = va_arg(ap, unsigned long long);
  100254:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  100257:	e9 f0 00 00 00       	jmp    10034c <vprintf+0x28b>
            }
            else
            {
                unsigned int v = va_arg(ap, unsigned int);
  10025c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10025f:	8d 58 04             	lea    0x4(%eax),%ebx
                count += print_unsigned(v, 10, 0);
  100262:	8b 00                	mov    (%eax),%eax
  100264:	b9 00 00 00 00       	mov    $0x0,%ecx
  100269:	ba 0a 00 00 00       	mov    $0xa,%edx
  10026e:	e8 a6 fd ff ff       	call   100019 <print_unsigned>
  100273:	01 45 e4             	add    %eax,-0x1c(%ebp)
                unsigned int v = va_arg(ap, unsigned int);
  100276:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  100279:	e9 ce 00 00 00       	jmp    10034c <vprintf+0x28b>
        switch (*fmt)
  10027e:	bb 00 00 00 00       	mov    $0x0,%ebx
            }
            break;
        case 'x':
            if (long_flag)
  100283:	85 db                	test   %ebx,%ebx
  100285:	74 22                	je     1002a9 <vprintf+0x1e8>
            {
                unsigned long long v = va_arg(ap, unsigned long long);
  100287:	8b 45 0c             	mov    0xc(%ebp),%eax
  10028a:	8d 58 08             	lea    0x8(%eax),%ebx
                count += print_unsigned(v, 16, 0);
  10028d:	8b 00                	mov    (%eax),%eax
  10028f:	b9 00 00 00 00       	mov    $0x0,%ecx
  100294:	ba 10 00 00 00       	mov    $0x10,%edx
  100299:	e8 7b fd ff ff       	call   100019 <print_unsigned>
  10029e:	01 45 e4             	add    %eax,-0x1c(%ebp)
                unsigned long long v = va_arg(ap, unsigned long long);
  1002a1:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  1002a4:	e9 a3 00 00 00       	jmp    10034c <vprintf+0x28b>
            }
            else
            {
                unsigned int v = va_arg(ap, unsigned int);
  1002a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002ac:	8d 58 04             	lea    0x4(%eax),%ebx
                count += print_unsigned(v, 16, 0);
  1002af:	8b 00                	mov    (%eax),%eax
  1002b1:	b9 00 00 00 00       	mov    $0x0,%ecx
  1002b6:	ba 10 00 00 00       	mov    $0x10,%edx
  1002bb:	e8 59 fd ff ff       	call   100019 <print_unsigned>
  1002c0:	01 45 e4             	add    %eax,-0x1c(%ebp)
                unsigned int v = va_arg(ap, unsigned int);
  1002c3:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  1002c6:	e9 81 00 00 00       	jmp    10034c <vprintf+0x28b>
            }
            break;
        case 'X':
            if (long_flag)
  1002cb:	85 db                	test   %ebx,%ebx
  1002cd:	74 1f                	je     1002ee <vprintf+0x22d>
            {
                unsigned long long v = va_arg(ap, unsigned long long);
  1002cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002d2:	8d 58 08             	lea    0x8(%eax),%ebx
                count += print_unsigned(v, 16, 1);
  1002d5:	8b 00                	mov    (%eax),%eax
  1002d7:	b9 01 00 00 00       	mov    $0x1,%ecx
  1002dc:	ba 10 00 00 00       	mov    $0x10,%edx
  1002e1:	e8 33 fd ff ff       	call   100019 <print_unsigned>
  1002e6:	01 45 e4             	add    %eax,-0x1c(%ebp)
                unsigned long long v = va_arg(ap, unsigned long long);
  1002e9:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  1002ec:	eb 5e                	jmp    10034c <vprintf+0x28b>
            }
            else
            {
                unsigned int v = va_arg(ap, unsigned int);
  1002ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002f1:	8d 58 04             	lea    0x4(%eax),%ebx
                count += print_unsigned(v, 16, 1);
  1002f4:	8b 00                	mov    (%eax),%eax
  1002f6:	b9 01 00 00 00       	mov    $0x1,%ecx
  1002fb:	ba 10 00 00 00       	mov    $0x10,%edx
  100300:	e8 14 fd ff ff       	call   100019 <print_unsigned>
  100305:	01 45 e4             	add    %eax,-0x1c(%ebp)
                unsigned int v = va_arg(ap, unsigned int);
  100308:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  10030b:	eb 3f                	jmp    10034c <vprintf+0x28b>
            }
            break;
        case 'p':
        {
            void *p = va_arg(ap, void *);
  10030d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100310:	8d 58 04             	lea    0x4(%eax),%ebx
  100313:	8b 30                	mov    (%eax),%esi
    put_char(c);
  100315:	83 ec 0c             	sub    $0xc,%esp
  100318:	6a 30                	push   $0x30
  10031a:	e8 9a 09 00 00       	call   100cb9 <put_char>
  10031f:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  100326:	e8 8e 09 00 00       	call   100cb9 <put_char>
    count += print_unsigned((unsigned long long)(uintptr_t)ptr, 16, 0);
  10032b:	b9 00 00 00 00       	mov    $0x0,%ecx
  100330:	ba 10 00 00 00       	mov    $0x10,%edx
  100335:	89 f0                	mov    %esi,%eax
  100337:	e8 dd fc ff ff       	call   100019 <print_unsigned>
            count += print_pointer(p);
  10033c:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  10033f:	8d 44 06 02          	lea    0x2(%esi,%eax,1),%eax
  100343:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            break;
  100346:	83 c4 10             	add    $0x10,%esp
            void *p = va_arg(ap, void *);
  100349:	89 5d 0c             	mov    %ebx,0xc(%ebp)
    for (; *fmt; fmt++)
  10034c:	8d 77 01             	lea    0x1(%edi),%esi
  10034f:	8a 47 01             	mov    0x1(%edi),%al
  100352:	84 c0                	test   %al,%al
  100354:	0f 84 af 00 00 00    	je     100409 <vprintf+0x348>
        if (*fmt != '%')
  10035a:	3c 25                	cmp    $0x25,%al
  10035c:	0f 84 81 fd ff ff    	je     1000e3 <vprintf+0x22>
    put_char(c);
  100362:	83 ec 0c             	sub    $0xc,%esp
  100365:	0f be c0             	movsbl %al,%eax
  100368:	50                   	push   %eax
  100369:	e8 4b 09 00 00       	call   100cb9 <put_char>
            count++;
  10036e:	ff 45 e4             	incl   -0x1c(%ebp)
            continue;
  100371:	83 c4 10             	add    $0x10,%esp
  100374:	89 f7                	mov    %esi,%edi
  100376:	eb d4                	jmp    10034c <vprintf+0x28b>
        }
        case 'c':
        {
            int c = va_arg(ap, int);
  100378:	8b 45 0c             	mov    0xc(%ebp),%eax
  10037b:	8d 58 04             	lea    0x4(%eax),%ebx
    put_char(c);
  10037e:	83 ec 0c             	sub    $0xc,%esp
  100381:	0f be 00             	movsbl (%eax),%eax
  100384:	50                   	push   %eax
  100385:	e8 2f 09 00 00       	call   100cb9 <put_char>
            kputc((char)c);
            count++;
  10038a:	ff 45 e4             	incl   -0x1c(%ebp)
            break;
  10038d:	83 c4 10             	add    $0x10,%esp
            int c = va_arg(ap, int);
  100390:	89 5d 0c             	mov    %ebx,0xc(%ebp)
            break;
  100393:	eb b7                	jmp    10034c <vprintf+0x28b>
        }
        case 's':
        {
            const char *s = va_arg(ap, const char *);
  100395:	8b 45 0c             	mov    0xc(%ebp),%eax
  100398:	83 c0 04             	add    $0x4,%eax
  10039b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  10039e:	8b 45 0c             	mov    0xc(%ebp),%eax
  1003a1:	8b 30                	mov    (%eax),%esi
    if (!s)
  1003a3:	85 f6                	test   %esi,%esi
  1003a5:	74 32                	je     1003d9 <vprintf+0x318>
    while (*s)
  1003a7:	8a 06                	mov    (%esi),%al
  1003a9:	84 c0                	test   %al,%al
  1003ab:	74 4a                	je     1003f7 <vprintf+0x336>
  1003ad:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1003b0:	89 d3                	mov    %edx,%ebx
  1003b2:	29 d6                	sub    %edx,%esi
    put_char(c);
  1003b4:	83 ec 0c             	sub    $0xc,%esp
  1003b7:	0f be c0             	movsbl %al,%eax
  1003ba:	50                   	push   %eax
  1003bb:	e8 f9 08 00 00       	call   100cb9 <put_char>
            (*count)++;
  1003c0:	43                   	inc    %ebx
    while (*s)
  1003c1:	8a 04 1e             	mov    (%esi,%ebx,1),%al
  1003c4:	83 c4 10             	add    $0x10,%esp
  1003c7:	84 c0                	test   %al,%al
  1003c9:	75 e9                	jne    1003b4 <vprintf+0x2f3>
            const char *s = va_arg(ap, const char *);
  1003cb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1003ce:	89 45 0c             	mov    %eax,0xc(%ebp)
  1003d1:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  1003d4:	e9 73 ff ff ff       	jmp    10034c <vprintf+0x28b>
        s = "(null)";
  1003d9:	be 22 20 10 00       	mov    $0x102022,%esi
    while (*s)
  1003de:	b0 28                	mov    $0x28,%al
  1003e0:	eb cb                	jmp    1003ad <vprintf+0x2ec>
    put_char(c);
  1003e2:	83 ec 0c             	sub    $0xc,%esp
  1003e5:	6a 25                	push   $0x25
  1003e7:	e8 cd 08 00 00       	call   100cb9 <put_char>
            kputs(s, &count);
            break;
        }
        case '%':
            kputc('%');
            count++;
  1003ec:	ff 45 e4             	incl   -0x1c(%ebp)
            break;
  1003ef:	83 c4 10             	add    $0x10,%esp
  1003f2:	e9 55 ff ff ff       	jmp    10034c <vprintf+0x28b>
            const char *s = va_arg(ap, const char *);
  1003f7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1003fa:	89 45 0c             	mov    %eax,0xc(%ebp)
  1003fd:	e9 4a ff ff ff       	jmp    10034c <vprintf+0x28b>
    int count = 0;
  100402:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
            break;
        }
    }

    return count;
}
  100409:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10040c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  10040f:	5b                   	pop    %ebx
  100410:	5e                   	pop    %esi
  100411:	5f                   	pop    %edi
  100412:	5d                   	pop    %ebp
  100413:	c3                   	ret
        fmt++; // skip '%'
  100414:	8d 7e 01             	lea    0x1(%esi),%edi
        switch (*fmt)
  100417:	3c 25                	cmp    $0x25,%al
  100419:	74 c7                	je     1003e2 <vprintf+0x321>
  10041b:	8d 50 a8             	lea    -0x58(%eax),%edx
  10041e:	80 fa 20             	cmp    $0x20,%dl
  100421:	0f 87 02 fd ff ff    	ja     100129 <vprintf+0x68>
  100427:	0f 87 fc fc ff ff    	ja     100129 <vprintf+0x68>
  10042d:	0f b6 c2             	movzbl %dl,%eax
  100430:	ff 24 85 b4 20 10 00 	jmp    *0x1020b4(,%eax,4)

00100437 <printf>:

int printf(const char *fmt, ...)
{
  100437:	55                   	push   %ebp
  100438:	89 e5                	mov    %esp,%ebp
  10043a:	83 ec 10             	sub    $0x10,%esp
    va_list ap;
    va_start(ap, fmt);
  10043d:	8d 45 0c             	lea    0xc(%ebp),%eax
    int ret = vprintf(fmt, ap);
  100440:	50                   	push   %eax
  100441:	ff 75 08             	push   0x8(%ebp)
  100444:	e8 78 fc ff ff       	call   1000c1 <vprintf>
    va_end(ap);
    return ret;
}
  100449:	c9                   	leave
  10044a:	c3                   	ret

0010044b <scanf_char>:

char scanf_char()
{
    return 'c'; // keyboard_trap();
}
  10044b:	b0 63                	mov    $0x63,%al
  10044d:	c3                   	ret

0010044e <main>:

// 在这里真正定义全局定时器实例
//struct timer t;

int main()
{
  10044e:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  100452:	83 e4 f0             	and    $0xfffffff0,%esp
  100455:	ff 71 fc             	push   -0x4(%ecx)
  100458:	55                   	push   %ebp
  100459:	89 e5                	mov    %esp,%ebp
  10045b:	51                   	push   %ecx
  10045c:	83 ec 04             	sub    $0x4,%esp
   gdt_install();
  10045f:	e8 82 03 00 00       	call   1007e6 <gdt_install>
   trap_init();
  100464:	e8 4d 0c 00 00       	call   1010b6 <trap_init>
   page_init();
  100469:	e8 dd 04 00 00       	call   10094b <page_init>

   printf("Welcome to uCore!\n");
  10046e:	83 ec 0c             	sub    $0xc,%esp
  100471:	68 38 21 10 00       	push   $0x102138
  100476:	e8 bc ff ff ff       	call   100437 <printf>

   printf("Starting user app...\n");
  10047b:	c7 04 24 4b 21 10 00 	movl   $0x10214b,(%esp)
  100482:	e8 b0 ff ff ff       	call   100437 <printf>
   user_app_run();
  100487:	e8 1a 0d 00 00       	call   1011a6 <user_app_run>
   printf("User app finished\n");
  10048c:	c7 04 24 61 21 10 00 	movl   $0x102161,(%esp)
  100493:	e8 9f ff ff ff       	call   100437 <printf>

   shutdown();
  100498:	e8 6e 08 00 00       	call   100d0b <shutdown>

   return 0;
}
  10049d:	b8 00 00 00 00       	mov    $0x0,%eax
  1004a2:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  1004a5:	c9                   	leave
  1004a6:	8d 61 fc             	lea    -0x4(%ecx),%esp
  1004a9:	c3                   	ret

001004aa <memset>:
#include "string.h"
#include "types.h"

void *memset(void *dst, int c, uint n)
{
  1004aa:	55                   	push   %ebp
  1004ab:	89 e5                	mov    %esp,%ebp
  1004ad:	53                   	push   %ebx
  1004ae:	8b 5d 08             	mov    0x8(%ebp),%ebx
  1004b1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  1004b4:	8b 55 10             	mov    0x10(%ebp),%edx
    char *cdst = (char *)dst;
    int i;
    for (i = 0; i < n; i++)
  1004b7:	85 d2                	test   %edx,%edx
  1004b9:	74 0b                	je     1004c6 <memset+0x1c>
  1004bb:	89 d8                	mov    %ebx,%eax
  1004bd:	01 da                	add    %ebx,%edx
    {
        cdst[i] = c;
  1004bf:	88 08                	mov    %cl,(%eax)
    for (i = 0; i < n; i++)
  1004c1:	40                   	inc    %eax
  1004c2:	39 d0                	cmp    %edx,%eax
  1004c4:	75 f9                	jne    1004bf <memset+0x15>
    }
    return dst;
}
  1004c6:	89 d8                	mov    %ebx,%eax
  1004c8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1004cb:	c9                   	leave
  1004cc:	c3                   	ret

001004cd <memcmp>:

int memcmp(const void *v1, const void *v2, uint n)
{
  1004cd:	55                   	push   %ebp
  1004ce:	89 e5                	mov    %esp,%ebp
  1004d0:	56                   	push   %esi
  1004d1:	53                   	push   %ebx
  1004d2:	8b 45 08             	mov    0x8(%ebp),%eax
  1004d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  1004d8:	8b 75 10             	mov    0x10(%ebp),%esi
    const uchar *s1, *s2;

    s1 = v1;
    s2 = v2;
    while (n-- > 0)
  1004db:	85 f6                	test   %esi,%esi
  1004dd:	74 23                	je     100502 <memcmp+0x35>
  1004df:	01 c6                	add    %eax,%esi
    {
        if (*s1 != *s2)
  1004e1:	8a 08                	mov    (%eax),%cl
  1004e3:	8a 1a                	mov    (%edx),%bl
  1004e5:	38 d9                	cmp    %bl,%cl
  1004e7:	75 0d                	jne    1004f6 <memcmp+0x29>
            return *s1 - *s2;
        s1++, s2++;
  1004e9:	40                   	inc    %eax
  1004ea:	42                   	inc    %edx
    while (n-- > 0)
  1004eb:	39 c6                	cmp    %eax,%esi
  1004ed:	75 f2                	jne    1004e1 <memcmp+0x14>
    }

    return 0;
  1004ef:	b8 00 00 00 00       	mov    $0x0,%eax
  1004f4:	eb 08                	jmp    1004fe <memcmp+0x31>
            return *s1 - *s2;
  1004f6:	0f b6 c1             	movzbl %cl,%eax
  1004f9:	0f b6 db             	movzbl %bl,%ebx
  1004fc:	29 d8                	sub    %ebx,%eax
}
  1004fe:	5b                   	pop    %ebx
  1004ff:	5e                   	pop    %esi
  100500:	5d                   	pop    %ebp
  100501:	c3                   	ret
    return 0;
  100502:	b8 00 00 00 00       	mov    $0x0,%eax
  100507:	eb f5                	jmp    1004fe <memcmp+0x31>

00100509 <memmove>:

void *memmove(void *dst, const void *src, uint n)
{
  100509:	55                   	push   %ebp
  10050a:	89 e5                	mov    %esp,%ebp
  10050c:	56                   	push   %esi
  10050d:	53                   	push   %ebx
  10050e:	8b 75 08             	mov    0x8(%ebp),%esi
  100511:	8b 45 0c             	mov    0xc(%ebp),%eax
  100514:	8b 4d 10             	mov    0x10(%ebp),%ecx
    const char *s;
    char *d;

    s = src;
    d = dst;
    if (s < d && s + n > d)
  100517:	39 f0                	cmp    %esi,%eax
  100519:	72 1a                	jb     100535 <memmove+0x2c>
        d += n;
        while (n-- > 0)
            *--d = *--s;
    }
    else
        while (n-- > 0)
  10051b:	85 c9                	test   %ecx,%ecx
  10051d:	74 10                	je     10052f <memmove+0x26>
  10051f:	01 c1                	add    %eax,%ecx
  100521:	89 f2                	mov    %esi,%edx
            *d++ = *s++;
  100523:	40                   	inc    %eax
  100524:	42                   	inc    %edx
  100525:	8a 58 ff             	mov    -0x1(%eax),%bl
  100528:	88 5a ff             	mov    %bl,-0x1(%edx)
        while (n-- > 0)
  10052b:	39 c8                	cmp    %ecx,%eax
  10052d:	75 f4                	jne    100523 <memmove+0x1a>

    return dst;
}
  10052f:	89 f0                	mov    %esi,%eax
  100531:	5b                   	pop    %ebx
  100532:	5e                   	pop    %esi
  100533:	5d                   	pop    %ebp
  100534:	c3                   	ret
    if (s < d && s + n > d)
  100535:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  100538:	39 d6                	cmp    %edx,%esi
  10053a:	73 df                	jae    10051b <memmove+0x12>
        while (n-- > 0)
  10053c:	8d 51 ff             	lea    -0x1(%ecx),%edx
  10053f:	85 c9                	test   %ecx,%ecx
  100541:	74 ec                	je     10052f <memmove+0x26>
            *--d = *--s;
  100543:	8a 0c 10             	mov    (%eax,%edx,1),%cl
  100546:	88 0c 16             	mov    %cl,(%esi,%edx,1)
        while (n-- > 0)
  100549:	4a                   	dec    %edx
  10054a:	83 fa ff             	cmp    $0xffffffff,%edx
  10054d:	75 f4                	jne    100543 <memmove+0x3a>
  10054f:	eb de                	jmp    10052f <memmove+0x26>

00100551 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void *memcpy(void *dst, const void *src, uint n)
{
  100551:	55                   	push   %ebp
  100552:	89 e5                	mov    %esp,%ebp
  100554:	83 ec 0c             	sub    $0xc,%esp
    return memmove(dst, src, n);
  100557:	ff 75 10             	push   0x10(%ebp)
  10055a:	ff 75 0c             	push   0xc(%ebp)
  10055d:	ff 75 08             	push   0x8(%ebp)
  100560:	e8 a4 ff ff ff       	call   100509 <memmove>
}
  100565:	c9                   	leave
  100566:	c3                   	ret

00100567 <strncmp>:

int strncmp(const char *p, const char *q, uint n)
{
  100567:	55                   	push   %ebp
  100568:	89 e5                	mov    %esp,%ebp
  10056a:	53                   	push   %ebx
  10056b:	8b 45 08             	mov    0x8(%ebp),%eax
  10056e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  100571:	8b 55 10             	mov    0x10(%ebp),%edx
    while (n > 0 && *p && *p == *q)
  100574:	85 d2                	test   %edx,%edx
  100576:	74 16                	je     10058e <strncmp+0x27>
  100578:	8a 18                	mov    (%eax),%bl
  10057a:	84 db                	test   %bl,%bl
  10057c:	74 17                	je     100595 <strncmp+0x2e>
  10057e:	3a 19                	cmp    (%ecx),%bl
  100580:	75 13                	jne    100595 <strncmp+0x2e>
        n--, p++, q++;
  100582:	40                   	inc    %eax
  100583:	41                   	inc    %ecx
    while (n > 0 && *p && *p == *q)
  100584:	4a                   	dec    %edx
  100585:	75 f1                	jne    100578 <strncmp+0x11>
    if (n == 0)
        return 0;
  100587:	b8 00 00 00 00       	mov    $0x0,%eax
  10058c:	eb 0f                	jmp    10059d <strncmp+0x36>
  10058e:	b8 00 00 00 00       	mov    $0x0,%eax
  100593:	eb 08                	jmp    10059d <strncmp+0x36>
    return (uchar)*p - (uchar)*q;
  100595:	0f b6 00             	movzbl (%eax),%eax
  100598:	0f b6 11             	movzbl (%ecx),%edx
  10059b:	29 d0                	sub    %edx,%eax
}
  10059d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1005a0:	c9                   	leave
  1005a1:	c3                   	ret

001005a2 <strncpy>:

char *strncpy(char *s, const char *t, int n)
{
  1005a2:	55                   	push   %ebp
  1005a3:	89 e5                	mov    %esp,%ebp
  1005a5:	56                   	push   %esi
  1005a6:	53                   	push   %ebx
  1005a7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  1005aa:	8b 55 10             	mov    0x10(%ebp),%edx
    char *os;

    os = s;
    while (n-- > 0 && (*s++ = *t++) != 0)
  1005ad:	8b 4d 08             	mov    0x8(%ebp),%ecx
  1005b0:	89 d6                	mov    %edx,%esi
  1005b2:	4a                   	dec    %edx
  1005b3:	85 f6                	test   %esi,%esi
  1005b5:	7e 23                	jle    1005da <strncpy+0x38>
  1005b7:	43                   	inc    %ebx
  1005b8:	41                   	inc    %ecx
  1005b9:	8a 43 ff             	mov    -0x1(%ebx),%al
  1005bc:	88 41 ff             	mov    %al,-0x1(%ecx)
  1005bf:	84 c0                	test   %al,%al
  1005c1:	75 ed                	jne    1005b0 <strncpy+0xe>
        ;
    while (n-- > 0)
  1005c3:	85 d2                	test   %edx,%edx
  1005c5:	7e 13                	jle    1005da <strncpy+0x38>
  1005c7:	89 ca                	mov    %ecx,%edx
  1005c9:	8d 5c 31 ff          	lea    -0x1(%ecx,%esi,1),%ebx
        *s++ = 0;
  1005cd:	42                   	inc    %edx
  1005ce:	c6 42 ff 00          	movb   $0x0,-0x1(%edx)
    while (n-- > 0)
  1005d2:	89 d9                	mov    %ebx,%ecx
  1005d4:	29 d1                	sub    %edx,%ecx
  1005d6:	85 c9                	test   %ecx,%ecx
  1005d8:	7f f3                	jg     1005cd <strncpy+0x2b>
    return os;
}
  1005da:	8b 45 08             	mov    0x8(%ebp),%eax
  1005dd:	5b                   	pop    %ebx
  1005de:	5e                   	pop    %esi
  1005df:	5d                   	pop    %ebp
  1005e0:	c3                   	ret

001005e1 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char *safestrcpy(char *s, const char *t, int n)
{
  1005e1:	55                   	push   %ebp
  1005e2:	89 e5                	mov    %esp,%ebp
  1005e4:	56                   	push   %esi
  1005e5:	53                   	push   %ebx
  1005e6:	8b 45 08             	mov    0x8(%ebp),%eax
  1005e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  1005ec:	8b 4d 10             	mov    0x10(%ebp),%ecx
    char *os;

    os = s;
    if (n <= 0)
  1005ef:	85 c9                	test   %ecx,%ecx
  1005f1:	7e 19                	jle    10060c <safestrcpy+0x2b>
  1005f3:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
  1005f7:	89 c1                	mov    %eax,%ecx
        return os;
    while (--n > 0 && (*s++ = *t++) != 0)
  1005f9:	39 f2                	cmp    %esi,%edx
  1005fb:	74 0c                	je     100609 <safestrcpy+0x28>
  1005fd:	42                   	inc    %edx
  1005fe:	41                   	inc    %ecx
  1005ff:	8a 5a ff             	mov    -0x1(%edx),%bl
  100602:	88 59 ff             	mov    %bl,-0x1(%ecx)
  100605:	84 db                	test   %bl,%bl
  100607:	75 f0                	jne    1005f9 <safestrcpy+0x18>
        ;
    *s = 0;
  100609:	c6 01 00             	movb   $0x0,(%ecx)
    return os;
}
  10060c:	5b                   	pop    %ebx
  10060d:	5e                   	pop    %esi
  10060e:	5d                   	pop    %ebp
  10060f:	c3                   	ret

00100610 <strlen>:

int strlen(const char *s)
{
  100610:	55                   	push   %ebp
  100611:	89 e5                	mov    %esp,%ebp
  100613:	8b 55 08             	mov    0x8(%ebp),%edx
    int n;

    for (n = 0; s[n]; n++)
  100616:	80 3a 00             	cmpb   $0x0,(%edx)
  100619:	74 0e                	je     100629 <strlen+0x19>
  10061b:	b8 00 00 00 00       	mov    $0x0,%eax
  100620:	40                   	inc    %eax
  100621:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  100625:	75 f9                	jne    100620 <strlen+0x10>
        ;
    return n;
}
  100627:	5d                   	pop    %ebp
  100628:	c3                   	ret
    for (n = 0; s[n]; n++)
  100629:	b8 00 00 00 00       	mov    $0x0,%eax
    return n;
  10062e:	eb f7                	jmp    100627 <strlen+0x17>

00100630 <dummy>:

void dummy(int _, ...)
{
  100630:	c3                   	ret
  100631:	66 90                	xchg   %ax,%ax
  100633:	90                   	nop

00100634 <trap_entry>:
     * EIP
     * Vector (Pushed by macro)
     */

    /* ---------- 保存段寄存器 ---------- */
    pushl %ds
  100634:	1e                   	push   %ds
    pushl %es
  100635:	06                   	push   %es
    pushl %fs
  100636:	0f a0                	push   %fs
    pushl %gs
  100638:	0f a8                	push   %gs

    /* ---------- 保存通用寄存器 ---------- */
    pusha
  10063a:	60                   	pusha

    /* ---------- 切换到内核数据段 ---------- */
    mov $0x10, %ax              /* 内核数据段选择子 */
  10063b:	66 b8 10 00          	mov    $0x10,%ax
    mov %ax, %ds
  10063f:	8e d8                	mov    %eax,%ds
    mov %ax, %es
  100641:	8e c0                	mov    %eax,%es
    mov %ax, %fs
  100643:	8e e0                	mov    %eax,%fs
    mov %ax, %gs
  100645:	8e e8                	mov    %eax,%gs

    /* ---------- 调用 C 处理函数 ---------- */
    pushl %esp                  /* struct trapframe* */
  100647:	54                   	push   %esp
    call trap_handler
  100648:	e8 77 0a 00 00       	call   1010c4 <trap_handler>
    addl $4, %esp
  10064d:	83 c4 04             	add    $0x4,%esp

    /* ---------- 恢复寄存器（严格反序） ---------- */
    popa
  100650:	61                   	popa
    popl %gs
  100651:	0f a9                	pop    %gs
    popl %fs
  100653:	0f a1                	pop    %fs
    popl %es
  100655:	07                   	pop    %es
    popl %ds
  100656:	1f                   	pop    %ds
    
    /* 弹出 vector 号 (4字节) */
    addl $4, %esp 
  100657:	83 c4 04             	add    $0x4,%esp

    /* 弹出 err 号 (4字节) */
    addl $4, %esp
  10065a:	83 c4 04             	add    $0x4,%esp

    /* ---------- 判断返回到用户态还是内核态 ---------- */
    /* iret 会根据栈上 CS 的 ring 位自动决定是否弹出 SS/ESP */
    testl $3, 4(%esp)  /* 检查 CS 的低2位是否为3 (用户态) */
  10065d:	f7 44 24 04 03 00 00 	testl  $0x3,0x4(%esp)
  100664:	00 
    jnz user_return
  100665:	75 01                	jne    100668 <user_return>

00100667 <kernel_return>:

kernel_return:
    /* 返回到内核态 */
    ret
  100667:	c3                   	ret

00100668 <user_return>:

user_return:
    /* 返回到用户态 */
    iret
  100668:	cf                   	iret

00100669 <trap_entry_0>:
    #ret
    .endm

    # 生成 syscall 向量 0x80 的 stub
    .if 1
    TRAP_STUB 0
  100669:	6a 00                	push   $0x0
  10066b:	6a 00                	push   $0x0
  10066d:	eb c5                	jmp    100634 <trap_entry>

0010066f <trap_entry_1>:
    TRAP_STUB 1
  10066f:	6a 00                	push   $0x0
  100671:	6a 01                	push   $0x1
  100673:	eb bf                	jmp    100634 <trap_entry>

00100675 <trap_entry_2>:
    TRAP_STUB 2
  100675:	6a 00                	push   $0x0
  100677:	6a 02                	push   $0x2
  100679:	eb b9                	jmp    100634 <trap_entry>

0010067b <trap_entry_3>:
    TRAP_STUB 3
  10067b:	6a 00                	push   $0x0
  10067d:	6a 03                	push   $0x3
  10067f:	eb b3                	jmp    100634 <trap_entry>

00100681 <trap_entry_4>:
    TRAP_STUB 4
  100681:	6a 00                	push   $0x0
  100683:	6a 04                	push   $0x4
  100685:	eb ad                	jmp    100634 <trap_entry>

00100687 <trap_entry_5>:
    TRAP_STUB 5
  100687:	6a 00                	push   $0x0
  100689:	6a 05                	push   $0x5
  10068b:	eb a7                	jmp    100634 <trap_entry>

0010068d <trap_entry_6>:
    TRAP_STUB 6
  10068d:	6a 00                	push   $0x0
  10068f:	6a 06                	push   $0x6
  100691:	eb a1                	jmp    100634 <trap_entry>

00100693 <trap_entry_7>:
    TRAP_STUB 7
  100693:	6a 00                	push   $0x0
  100695:	6a 07                	push   $0x7
  100697:	eb 9b                	jmp    100634 <trap_entry>

00100699 <trap_entry_8>:
    TRAP_STUB 8
  100699:	6a 00                	push   $0x0
  10069b:	6a 08                	push   $0x8
  10069d:	eb 95                	jmp    100634 <trap_entry>

0010069f <trap_entry_9>:
    TRAP_STUB 9
  10069f:	6a 00                	push   $0x0
  1006a1:	6a 09                	push   $0x9
  1006a3:	eb 8f                	jmp    100634 <trap_entry>

001006a5 <trap_entry_10>:
    TRAP_STUB 10
  1006a5:	6a 00                	push   $0x0
  1006a7:	6a 0a                	push   $0xa
  1006a9:	eb 89                	jmp    100634 <trap_entry>

001006ab <trap_entry_11>:
    TRAP_STUB 11
  1006ab:	6a 00                	push   $0x0
  1006ad:	6a 0b                	push   $0xb
  1006af:	eb 83                	jmp    100634 <trap_entry>

001006b1 <trap_entry_12>:
    TRAP_STUB 12
  1006b1:	6a 00                	push   $0x0
  1006b3:	6a 0c                	push   $0xc
  1006b5:	e9 7a ff ff ff       	jmp    100634 <trap_entry>

001006ba <trap_entry_13>:
    TRAP_STUB 13
  1006ba:	6a 00                	push   $0x0
  1006bc:	6a 0d                	push   $0xd
  1006be:	e9 71 ff ff ff       	jmp    100634 <trap_entry>

001006c3 <trap_entry_14>:
    TRAP_STUB_err 14
  1006c3:	6a 0e                	push   $0xe
  1006c5:	e9 6a ff ff ff       	jmp    100634 <trap_entry>

001006ca <trap_entry_15>:
    TRAP_STUB 15
  1006ca:	6a 00                	push   $0x0
  1006cc:	6a 0f                	push   $0xf
  1006ce:	e9 61 ff ff ff       	jmp    100634 <trap_entry>

001006d3 <trap_entry_16>:
    TRAP_STUB 16
  1006d3:	6a 00                	push   $0x0
  1006d5:	6a 10                	push   $0x10
  1006d7:	e9 58 ff ff ff       	jmp    100634 <trap_entry>

001006dc <trap_entry_17>:
    TRAP_STUB 17
  1006dc:	6a 00                	push   $0x0
  1006de:	6a 11                	push   $0x11
  1006e0:	e9 4f ff ff ff       	jmp    100634 <trap_entry>

001006e5 <trap_entry_18>:
    TRAP_STUB 18
  1006e5:	6a 00                	push   $0x0
  1006e7:	6a 12                	push   $0x12
  1006e9:	e9 46 ff ff ff       	jmp    100634 <trap_entry>

001006ee <trap_entry_19>:
    TRAP_STUB 19
  1006ee:	6a 00                	push   $0x0
  1006f0:	6a 13                	push   $0x13
  1006f2:	e9 3d ff ff ff       	jmp    100634 <trap_entry>

001006f7 <trap_entry_20>:
    TRAP_STUB 20
  1006f7:	6a 00                	push   $0x0
  1006f9:	6a 14                	push   $0x14
  1006fb:	e9 34 ff ff ff       	jmp    100634 <trap_entry>

00100700 <trap_entry_21>:
    TRAP_STUB 21
  100700:	6a 00                	push   $0x0
  100702:	6a 15                	push   $0x15
  100704:	e9 2b ff ff ff       	jmp    100634 <trap_entry>

00100709 <trap_entry_22>:
    TRAP_STUB 22
  100709:	6a 00                	push   $0x0
  10070b:	6a 16                	push   $0x16
  10070d:	e9 22 ff ff ff       	jmp    100634 <trap_entry>

00100712 <trap_entry_23>:
    TRAP_STUB 23
  100712:	6a 00                	push   $0x0
  100714:	6a 17                	push   $0x17
  100716:	e9 19 ff ff ff       	jmp    100634 <trap_entry>

0010071b <trap_entry_24>:
    TRAP_STUB 24
  10071b:	6a 00                	push   $0x0
  10071d:	6a 18                	push   $0x18
  10071f:	e9 10 ff ff ff       	jmp    100634 <trap_entry>

00100724 <trap_entry_25>:
    TRAP_STUB 25
  100724:	6a 00                	push   $0x0
  100726:	6a 19                	push   $0x19
  100728:	e9 07 ff ff ff       	jmp    100634 <trap_entry>

0010072d <trap_entry_26>:
    TRAP_STUB 26
  10072d:	6a 00                	push   $0x0
  10072f:	6a 1a                	push   $0x1a
  100731:	e9 fe fe ff ff       	jmp    100634 <trap_entry>

00100736 <trap_entry_27>:
    TRAP_STUB 27
  100736:	6a 00                	push   $0x0
  100738:	6a 1b                	push   $0x1b
  10073a:	e9 f5 fe ff ff       	jmp    100634 <trap_entry>

0010073f <trap_entry_28>:
    TRAP_STUB 28
  10073f:	6a 00                	push   $0x0
  100741:	6a 1c                	push   $0x1c
  100743:	e9 ec fe ff ff       	jmp    100634 <trap_entry>

00100748 <trap_entry_29>:
    TRAP_STUB 29
  100748:	6a 00                	push   $0x0
  10074a:	6a 1d                	push   $0x1d
  10074c:	e9 e3 fe ff ff       	jmp    100634 <trap_entry>

00100751 <trap_entry_30>:
    TRAP_STUB 30
  100751:	6a 00                	push   $0x0
  100753:	6a 1e                	push   $0x1e
  100755:	e9 da fe ff ff       	jmp    100634 <trap_entry>

0010075a <trap_entry_31>:
    TRAP_STUB 31
  10075a:	6a 00                	push   $0x0
  10075c:	6a 1f                	push   $0x1f
  10075e:	e9 d1 fe ff ff       	jmp    100634 <trap_entry>

00100763 <trap_entry_0x80>:
    TRAP_STUB 0x80
  100763:	6a 00                	push   $0x0
  100765:	68 80 00 00 00       	push   $0x80
  10076a:	e9 c5 fe ff ff       	jmp    100634 <trap_entry>

0010076f <user_enter>:

# 参数：eax = 用户态栈顶地址 (user_esp)
#        ebx = 用户代码入口 (entry)

user_enter:
    cli
  10076f:	fa                   	cli
    # C调用约定：
    #   第一个参数 [esp+4]  -> entry (用户程序入口)
    #   第二个参数 [esp+8]  -> user_esp (用户栈顶)
    mov eax, [esp + 8]    # user_esp
  100770:	8b 44 24 08          	mov    0x8(%esp),%eax
    mov ebx, [esp + 4]    # entry
  100774:	8b 5c 24 04          	mov    0x4(%esp),%ebx

    push 0x23             # SS (用户数据段选择子，ring3)
  100778:	6a 23                	push   $0x23
    push eax              # ESP (用户栈顶)
  10077a:	50                   	push   %eax
    pushfd
  10077b:	9c                   	pushf
    or dword ptr [esp], 0x200
  10077c:	81 0c 24 00 02 00 00 	orl    $0x200,(%esp)
    push 0x1B             # CS (用户代码段选择子，ring3)
  100783:	6a 1b                	push   $0x1b
    push ebx              # EIP (用户入口)
  100785:	53                   	push   %ebx
    iret
  100786:	cf                   	iret

00100787 <idt_flush>:

    
.intel_syntax noprefix
.globl idt_flush
idt_flush:
	mov eax, [esp+4]  #参数存入 eax 寄存器
  100787:	8b 44 24 04          	mov    0x4(%esp),%eax
	lidt [eax]        #加载到 IDTR
  10078b:	0f 01 18             	lidtl  (%eax)
	ret
  10078e:	c3                   	ret

0010078f <set_gdt_entry>:

struct gdt_entry gdt[GDT_SIZE];
struct gdt_ptr gp;

void set_gdt_entry(int num, uint32_t base, uint32_t limit, uint8_t access, uint8_t flags)
{
  10078f:	55                   	push   %ebp
  100790:	89 e5                	mov    %esp,%ebp
  100792:	53                   	push   %ebx
  100793:	8b 55 08             	mov    0x8(%ebp),%edx
  100796:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  100799:	8b 45 10             	mov    0x10(%ebp),%eax
    gdt[num].base_low = base & 0xFFFF;
  10079c:	66 89 0c d5 22 40 11 	mov    %cx,0x114022(,%edx,8)
  1007a3:	00 
    gdt[num].base_middle = (base >> 16) & 0xFF;
  1007a4:	89 cb                	mov    %ecx,%ebx
  1007a6:	c1 eb 10             	shr    $0x10,%ebx
  1007a9:	88 1c d5 24 40 11 00 	mov    %bl,0x114024(,%edx,8)
    gdt[num].base_high = (base >> 24) & 0xFF;
  1007b0:	c1 e9 18             	shr    $0x18,%ecx
  1007b3:	88 0c d5 27 40 11 00 	mov    %cl,0x114027(,%edx,8)

    gdt[num].limit_low = limit & 0xFFFF;
  1007ba:	66 89 04 d5 20 40 11 	mov    %ax,0x114020(,%edx,8)
  1007c1:	00 
    gdt[num].granularity = ((limit >> 16) & 0x0F) | (flags & 0xF0);
  1007c2:	c1 e8 10             	shr    $0x10,%eax
  1007c5:	83 e0 0f             	and    $0xf,%eax
  1007c8:	8a 4d 18             	mov    0x18(%ebp),%cl
  1007cb:	83 e1 f0             	and    $0xfffffff0,%ecx
  1007ce:	09 c8                	or     %ecx,%eax
  1007d0:	88 04 d5 26 40 11 00 	mov    %al,0x114026(,%edx,8)

    gdt[num].access = access;
  1007d7:	8b 45 14             	mov    0x14(%ebp),%eax
  1007da:	88 04 d5 25 40 11 00 	mov    %al,0x114025(,%edx,8)
}
  1007e1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1007e4:	c9                   	leave
  1007e5:	c3                   	ret

001007e6 <gdt_install>:

void gdt_install()
{
  1007e6:	55                   	push   %ebp
  1007e7:	89 e5                	mov    %esp,%ebp
  1007e9:	83 ec 14             	sub    $0x14,%esp
    gp.limit = sizeof(gdt) - 1;
  1007ec:	66 c7 05 00 40 11 00 	movw   $0x2f,0x114000
  1007f3:	2f 00 
    gp.base = (uint32_t)&gdt;
  1007f5:	c7 05 02 40 11 00 20 	movl   $0x114020,0x114002
  1007fc:	40 11 00 

    // Null descriptor
    set_gdt_entry(0, 0, 0, 0, 0);
  1007ff:	6a 00                	push   $0x0
  100801:	6a 00                	push   $0x0
  100803:	6a 00                	push   $0x0
  100805:	6a 00                	push   $0x0
  100807:	6a 00                	push   $0x0
  100809:	e8 81 ff ff ff       	call   10078f <set_gdt_entry>

    // 内核代码段 (CPL=0)
    set_gdt_entry(1, 0x0, 0xFFFFF,
  10080e:	83 c4 14             	add    $0x14,%esp
  100811:	68 c0 00 00 00       	push   $0xc0
  100816:	68 9a 00 00 00       	push   $0x9a
  10081b:	68 ff ff 0f 00       	push   $0xfffff
  100820:	6a 00                	push   $0x0
  100822:	6a 01                	push   $0x1
  100824:	e8 66 ff ff ff       	call   10078f <set_gdt_entry>
                  SEG_PRESENT | SEG_CODE | SEG_RING0,
                  GDT_GRAN_4K | GDT_32BIT);

    // 内核数据段 (CPL=0)
    set_gdt_entry(2, 0x0, 0xFFFFF,
  100829:	83 c4 14             	add    $0x14,%esp
  10082c:	68 c0 00 00 00       	push   $0xc0
  100831:	68 92 00 00 00       	push   $0x92
  100836:	68 ff ff 0f 00       	push   $0xfffff
  10083b:	6a 00                	push   $0x0
  10083d:	6a 02                	push   $0x2
  10083f:	e8 4b ff ff ff       	call   10078f <set_gdt_entry>
                  SEG_PRESENT | SEG_DATA | SEG_RING0,
                  GDT_GRAN_4K | GDT_32BIT);

    // 用户代码段 (CPL=3)
    set_gdt_entry(3, 0x0, 0xFFFFFFFF,
  100844:	83 c4 14             	add    $0x14,%esp
  100847:	68 c0 00 00 00       	push   $0xc0
  10084c:	68 fa 00 00 00       	push   $0xfa
  100851:	6a ff                	push   $0xffffffff
  100853:	6a 00                	push   $0x0
  100855:	6a 03                	push   $0x3
  100857:	e8 33 ff ff ff       	call   10078f <set_gdt_entry>
                  SEG_PRESENT | SEG_CODE | SEG_RING3,
                  GDT_GRAN_4K | GDT_32BIT);

    // 用户数据段 (CPL=3)
    set_gdt_entry(4, 0x0, 0xFFFFFFFF,
  10085c:	83 c4 14             	add    $0x14,%esp
  10085f:	68 c0 00 00 00       	push   $0xc0
  100864:	68 f2 00 00 00       	push   $0xf2
  100869:	6a ff                	push   $0xffffffff
  10086b:	6a 00                	push   $0x0
  10086d:	6a 04                	push   $0x4
  10086f:	e8 1b ff ff ff       	call   10078f <set_gdt_entry>
                  SEG_PRESENT | SEG_DATA | SEG_RING3,
                  GDT_GRAN_4K | GDT_32BIT);

    // TSS段 (GDT[5])
    memset(&tss, 0, sizeof(tss));
  100874:	83 c4 1c             	add    $0x1c,%esp
  100877:	6a 68                	push   $0x68
  100879:	6a 00                	push   $0x0
  10087b:	68 60 40 11 00       	push   $0x114060
  100880:	e8 25 fc ff ff       	call   1004aa <memset>
    tss.ss0 = 0x10; // 内核数据段选择子
  100885:	c7 05 68 40 11 00 10 	movl   $0x10,0x114068
  10088c:	00 00 00 
    tss.esp0 = 0;   // 需要在任务切换时设置
  10088f:	c7 05 64 40 11 00 00 	movl   $0x0,0x114064
  100896:	00 00 00 
    uint32_t base = (uint32_t)&tss;
    uint32_t limit = sizeof(tss) - 1;
    set_gdt_entry(5, base, limit, 0x89, 0x00); // 0x89: present, type=32位TSS
  100899:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1008a0:	68 89 00 00 00       	push   $0x89
  1008a5:	6a 67                	push   $0x67
  1008a7:	68 60 40 11 00       	push   $0x114060
  1008ac:	6a 05                	push   $0x5
  1008ae:	e8 dc fe ff ff       	call   10078f <set_gdt_entry>

    // 加载 GDTR
    asm volatile("lgdt (%0)" : : "r"(&gp));
  1008b3:	b8 00 40 11 00       	mov    $0x114000,%eax
  1008b8:	0f 01 10             	lgdtl  (%eax)

    // 更新段寄存器，内核态 CS/DS/ES/FS/GS/SS
    asm volatile(
  1008bb:	66 b8 10 00          	mov    $0x10,%ax
  1008bf:	8e d8                	mov    %eax,%ds
  1008c1:	8e c0                	mov    %eax,%es
  1008c3:	8e e0                	mov    %eax,%fs
  1008c5:	8e e8                	mov    %eax,%gs
        :
        :
        : "ax");

    // 加载TSS
    asm volatile("ltr %%ax" : : "a"(5 << 3));
  1008c7:	b8 28 00 00 00       	mov    $0x28,%eax
  1008cc:	0f 00 d8             	ltr    %ax
}
  1008cf:	83 c4 20             	add    $0x20,%esp
  1008d2:	c9                   	leave
  1008d3:	c3                   	ret

001008d4 <tss_set>:

// 设置TSS的esp0（内核栈顶），可在任务切换时调用
void tss_set(uint32_t kernel_stack)
{
  1008d4:	55                   	push   %ebp
  1008d5:	89 e5                	mov    %esp,%ebp
    tss.esp0 = kernel_stack;
  1008d7:	8b 45 08             	mov    0x8(%ebp),%eax
  1008da:	a3 64 40 11 00       	mov    %eax,0x114064
}
  1008df:	5d                   	pop    %ebp
  1008e0:	c3                   	ret

001008e1 <set_idt_gate>:
struct idt_entry idt[IDT_SIZE];
struct idt_ptr idtp;
extern void idt_flush(uint32_t);

void set_idt_gate(int vec, void (*handler)(), uint16_t selector, uint8_t flags)
{
  1008e1:	55                   	push   %ebp
  1008e2:	89 e5                	mov    %esp,%ebp
  1008e4:	8b 45 08             	mov    0x8(%ebp),%eax
  1008e7:	8b 55 0c             	mov    0xc(%ebp),%edx
    uint32_t addr = (uint32_t)handler;

    idt[vec].offset_low = addr & 0xFFFF;
  1008ea:	66 89 14 c5 00 41 11 	mov    %dx,0x114100(,%eax,8)
  1008f1:	00 
    idt[vec].selector = selector;
  1008f2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  1008f5:	66 89 0c c5 02 41 11 	mov    %cx,0x114102(,%eax,8)
  1008fc:	00 
    idt[vec].zero = 0;
  1008fd:	c6 04 c5 04 41 11 00 	movb   $0x0,0x114104(,%eax,8)
  100904:	00 
    idt[vec].type_attr = flags;
  100905:	8b 4d 14             	mov    0x14(%ebp),%ecx
  100908:	88 0c c5 05 41 11 00 	mov    %cl,0x114105(,%eax,8)
    idt[vec].offset_high = (addr >> 16) & 0xFFFF;
  10090f:	c1 ea 10             	shr    $0x10,%edx
  100912:	66 89 14 c5 06 41 11 	mov    %dx,0x114106(,%eax,8)
  100919:	00 
}
  10091a:	5d                   	pop    %ebp
  10091b:	c3                   	ret

0010091c <idt_load>:

void idt_load(void)
{
  10091c:	55                   	push   %ebp
  10091d:	89 e5                	mov    %esp,%ebp
  10091f:	83 ec 14             	sub    $0x14,%esp
    idtp.limit = sizeof(idt) - 1;
  100922:	66 c7 05 e0 40 11 00 	movw   $0x7ff,0x1140e0
  100929:	ff 07 
    idtp.base = (uint32_t)&idt;
  10092b:	c7 05 e2 40 11 00 00 	movl   $0x114100,0x1140e2
  100932:	41 11 00 

    asm volatile("lidt %0" : : "m"(idtp));
  100935:	0f 01 1d e0 40 11 00 	lidtl  0x1140e0

    idt_flush((uint32_t)&idtp);
  10093c:	68 e0 40 11 00       	push   $0x1140e0
  100941:	e8 41 fe ff ff       	call   100787 <idt_flush>
}
  100946:	83 c4 10             	add    $0x10,%esp
  100949:	c9                   	leave
  10094a:	c3                   	ret

0010094b <page_init>:
__attribute__((aligned(4096))) struct PagedDirectoryEntry page_directory[1024];
__attribute__((aligned(4096))) struct PageTableEntry page_table[512][1024]; // 512个页表，每个1024项
uint8_t phys_bitmap[512];                                                   // 每位表示一个物理页

void page_init()
{
  10094b:	55                   	push   %ebp
  10094c:	89 e5                	mov    %esp,%ebp
  10094e:	56                   	push   %esi
  10094f:	53                   	push   %ebx
    // 初始化页目录和页表
    for (int i = 0; i < 1024; i++)
  100950:	b8 00 00 00 00       	mov    $0x0,%eax
    {
        page_directory[i].present = 0;
        page_directory[i].rw = 1;
  100955:	8a 14 85 00 60 31 00 	mov    0x316000(,%eax,4),%dl
  10095c:	83 e2 fa             	and    $0xfffffffa,%edx
        page_directory[i].user = 0;
  10095f:	83 ca 02             	or     $0x2,%edx
  100962:	88 14 85 00 60 31 00 	mov    %dl,0x316000(,%eax,4)
        page_directory[i].reserved = 0;
  100969:	66 81 24 85 00 60 31 	andw   $0xf007,0x316000(,%eax,4)
  100970:	00 07 f0 
        page_directory[i].table_addr = 0;
  100973:	81 24 85 00 60 31 00 	andl   $0xfff,0x316000(,%eax,4)
  10097a:	ff 0f 00 00 
    for (int i = 0; i < 1024; i++)
  10097e:	40                   	inc    %eax
  10097f:	3d 00 04 00 00       	cmp    $0x400,%eax
  100984:	75 cf                	jne    100955 <page_init+0xa>
    }

    for (int i = 0; i < 4; i++)
  100986:	be 00 00 00 00       	mov    $0x0,%esi
    {
        for (int j = 0; j < 1024; j++)
  10098b:	b9 00 00 00 00       	mov    $0x0,%ecx
        {
            page_table[i][j].present = 0;
  100990:	89 f3                	mov    %esi,%ebx
  100992:	c1 e3 0a             	shl    $0xa,%ebx
  100995:	8d 04 0b             	lea    (%ebx,%ecx,1),%eax
            page_table[i][j].rw = 1;
  100998:	8a 14 85 00 60 11 00 	mov    0x116000(,%eax,4),%dl
  10099f:	83 e2 fa             	and    $0xfffffffa,%edx
            page_table[i][j].user = 0;
  1009a2:	83 ca 02             	or     $0x2,%edx
  1009a5:	88 14 85 00 60 11 00 	mov    %dl,0x116000(,%eax,4)
            page_table[i][j].reserved = 0;
  1009ac:	66 81 24 85 00 60 11 	andw   $0xf007,0x116000(,%eax,4)
  1009b3:	00 07 f0 
            page_table[i][j].frame_addr = 0;
  1009b6:	81 24 85 00 60 11 00 	andl   $0xfff,0x116000(,%eax,4)
  1009bd:	ff 0f 00 00 
        for (int j = 0; j < 1024; j++)
  1009c1:	41                   	inc    %ecx
  1009c2:	81 f9 00 04 00 00    	cmp    $0x400,%ecx
  1009c8:	75 cb                	jne    100995 <page_init+0x4a>
    for (int i = 0; i < 4; i++)
  1009ca:	46                   	inc    %esi
  1009cb:	83 fe 04             	cmp    $0x4,%esi
  1009ce:	75 bb                	jne    10098b <page_init+0x40>
        }
    }

    // 初始化物理页位图，所有页初始为可用（除了内核使用的）
    memset(phys_bitmap, 0, sizeof(phys_bitmap));
  1009d0:	83 ec 04             	sub    $0x4,%esp
  1009d3:	68 00 02 00 00       	push   $0x200
  1009d8:	6a 00                	push   $0x0
  1009da:	68 00 50 11 00       	push   $0x115000
  1009df:	e8 c6 fa ff ff       	call   1004aa <memset>
  1009e4:	83 c4 10             	add    $0x10,%esp
    // 标记内核使用的页为已用（假设内核使用前64页，256KB）
    for (int i = 0; i < 64; i++)
  1009e7:	b8 00 00 00 00       	mov    $0x0,%eax
    bitmap[bit / 8] |= (1 << (bit % 8));
  1009ec:	bb 01 00 00 00       	mov    $0x1,%ebx
  1009f1:	eb 1a                	jmp    100a0d <page_init+0xc2>
  1009f3:	c1 fa 03             	sar    $0x3,%edx
  1009f6:	89 c1                	mov    %eax,%ecx
  1009f8:	83 e1 07             	and    $0x7,%ecx
  1009fb:	89 de                	mov    %ebx,%esi
  1009fd:	d3 e6                	shl    %cl,%esi
  1009ff:	89 f1                	mov    %esi,%ecx
  100a01:	08 8a 00 50 11 00    	or     %cl,0x115000(%edx)
    for (int i = 0; i < 64; i++)
  100a07:	40                   	inc    %eax
  100a08:	83 f8 40             	cmp    $0x40,%eax
  100a0b:	74 0b                	je     100a18 <page_init+0xcd>
    bitmap[bit / 8] |= (1 << (bit % 8));
  100a0d:	89 c2                	mov    %eax,%edx
  100a0f:	85 c0                	test   %eax,%eax
  100a11:	79 e0                	jns    1009f3 <page_init+0xa8>
  100a13:	8d 50 07             	lea    0x7(%eax),%edx
  100a16:	eb db                	jmp    1009f3 <page_init+0xa8>
    {
        set_bit(phys_bitmap, i);
    }

    // 映射前 4MB 内存
    for (int i = 0; i < 1024; i++)
  100a18:	b8 00 00 00 00       	mov    $0x0,%eax
    {
        page_table[0][i].present = 1;
        page_table[0][i].rw = 1;
  100a1d:	8a 14 85 00 60 11 00 	mov    0x116000(,%eax,4),%dl
  100a24:	83 ca 03             	or     $0x3,%edx
        page_table[0][i].user = 0;
  100a27:	83 e2 fb             	and    $0xfffffffb,%edx
  100a2a:	88 14 85 00 60 11 00 	mov    %dl,0x116000(,%eax,4)
        page_table[0][i].frame_addr = i; // 映射到物理地址 i * 4KB
  100a31:	89 c1                	mov    %eax,%ecx
  100a33:	c1 e1 0c             	shl    $0xc,%ecx
  100a36:	8b 14 85 00 60 11 00 	mov    0x116000(,%eax,4),%edx
  100a3d:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  100a43:	09 ca                	or     %ecx,%edx
  100a45:	89 14 85 00 60 11 00 	mov    %edx,0x116000(,%eax,4)
    for (int i = 0; i < 1024; i++)
  100a4c:	40                   	inc    %eax
  100a4d:	3d 00 04 00 00       	cmp    $0x400,%eax
  100a52:	75 c9                	jne    100a1d <page_init+0xd2>
    }

    // 设置页目录的第一个条目指向第一个页表
    page_directory[0].present = 1;
    page_directory[0].rw = 1;
  100a54:	a0 00 60 31 00       	mov    0x316000,%al
  100a59:	83 c8 03             	or     $0x3,%eax
    page_directory[0].user = 0;
  100a5c:	83 e0 fb             	and    $0xfffffffb,%eax
  100a5f:	a2 00 60 31 00       	mov    %al,0x316000
    page_directory[0].table_addr = ((uint32_t)page_table[0]) >> 12;
  100a64:	ba 00 60 11 00       	mov    $0x116000,%edx
  100a69:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  100a6f:	a1 00 60 31 00       	mov    0x316000,%eax
  100a74:	25 ff 0f 00 00       	and    $0xfff,%eax
  100a79:	09 d0                	or     %edx,%eax
  100a7b:	a3 00 60 31 00       	mov    %eax,0x316000

    // 映射直接映射区域 0xC0000000 到物理 0 (前 4MB)
    for (int i = 0; i < 1024; i++)
  100a80:	ba 00 00 00 00       	mov    $0x0,%edx
    {
        page_table[1][i].present = 1;
  100a85:	8d 8a 00 04 00 00    	lea    0x400(%edx),%ecx
        page_table[1][i].rw = 1;
  100a8b:	8a 04 8d 00 60 11 00 	mov    0x116000(,%ecx,4),%al
  100a92:	83 c8 03             	or     $0x3,%eax
        page_table[1][i].user = 0;
  100a95:	83 e0 fb             	and    $0xfffffffb,%eax
  100a98:	88 04 8d 00 60 11 00 	mov    %al,0x116000(,%ecx,4)
        page_table[1][i].frame_addr = i; // 映射到物理地址 i * 4KB
  100a9f:	89 d3                	mov    %edx,%ebx
  100aa1:	c1 e3 0c             	shl    $0xc,%ebx
  100aa4:	8b 04 8d 00 60 11 00 	mov    0x116000(,%ecx,4),%eax
  100aab:	25 ff 0f 00 00       	and    $0xfff,%eax
  100ab0:	09 d8                	or     %ebx,%eax
  100ab2:	89 04 8d 00 60 11 00 	mov    %eax,0x116000(,%ecx,4)
    for (int i = 0; i < 1024; i++)
  100ab9:	42                   	inc    %edx
  100aba:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  100ac0:	75 c3                	jne    100a85 <page_init+0x13a>
    }

    // 设置页目录的第768个条目指向第二个页表 (0xC0000000)
    page_directory[768].present = 1;
    page_directory[768].rw = 1;
  100ac2:	a0 00 6c 31 00       	mov    0x316c00,%al
  100ac7:	83 c8 03             	or     $0x3,%eax
    page_directory[768].user = 0;
  100aca:	83 e0 fb             	and    $0xfffffffb,%eax
  100acd:	a2 00 6c 31 00       	mov    %al,0x316c00
    page_directory[768].table_addr = ((uint32_t)page_table[1]) >> 12;
  100ad2:	ba 00 70 11 00       	mov    $0x117000,%edx
  100ad7:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  100add:	a1 00 6c 31 00       	mov    0x316c00,%eax
  100ae2:	25 ff 0f 00 00       	and    $0xfff,%eax
  100ae7:	09 d0                	or     %edx,%eax
  100ae9:	a3 00 6c 31 00       	mov    %eax,0x316c00

    // 预先设置用户程序页目录项（页目录索引2，对应0x00800000）
    page_directory[2].present = 1;
    page_directory[2].rw = 1;
    page_directory[2].user = 1;
  100aee:	80 0d 08 60 31 00 07 	orb    $0x7,0x316008
    page_directory[2].table_addr = ((uint32_t)page_table[2]) >> 12;
  100af5:	ba 00 80 11 00       	mov    $0x118000,%edx
  100afa:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  100b00:	a1 08 60 31 00       	mov    0x316008,%eax
  100b05:	25 ff 0f 00 00       	and    $0xfff,%eax
  100b0a:	09 d0                	or     %edx,%eax
  100b0c:	a3 08 60 31 00       	mov    %eax,0x316008

    // 内核页表，0-1MB

    // 加载页目录地址到 CR3 寄存器
    asm volatile("mov %0, %%cr3" : : "r"(&page_directory));
  100b11:	b8 00 60 31 00       	mov    $0x316000,%eax
  100b16:	0f 22 d8             	mov    %eax,%cr3

    // 启用分页，设置 CR0 寄存器的分页位
    uint32_t cr0;
    asm volatile("mov %%cr0, %0" : "=r"(cr0));
  100b19:	0f 20 c0             	mov    %cr0,%eax
    cr0 |= 0x80000000; // 设置分页位
  100b1c:	0d 00 00 00 80       	or     $0x80000000,%eax
    asm volatile("mov %0, %%cr0" : : "r"(cr0));
  100b21:	0f 22 c0             	mov    %eax,%cr0
}
  100b24:	8d 65 f8             	lea    -0x8(%ebp),%esp
  100b27:	5b                   	pop    %ebx
  100b28:	5e                   	pop    %esi
  100b29:	5d                   	pop    %ebp
  100b2a:	c3                   	ret

00100b2b <alloc_phys_page>:

uint32_t alloc_phys_page()
{
  100b2b:	55                   	push   %ebp
  100b2c:	89 e5                	mov    %esp,%ebp
  100b2e:	56                   	push   %esi
  100b2f:	53                   	push   %ebx
    return (bitmap[bit / 8] >> (bit % 8)) & 1;
  100b30:	8a 1d 00 50 11 00    	mov    0x115000,%bl
    for (int i = 0; i < 4096; i++)
    {
        if (!get_bit(phys_bitmap, i))
  100b36:	f6 c3 01             	test   $0x1,%bl
  100b39:	74 38                	je     100b73 <alloc_phys_page+0x48>
    for (int i = 0; i < 4096; i++)
  100b3b:	b8 00 00 00 00       	mov    $0x0,%eax
  100b40:	eb 1e                	jmp    100b60 <alloc_phys_page+0x35>
    return (bitmap[bit / 8] >> (bit % 8)) & 1;
  100b42:	c1 fa 03             	sar    $0x3,%edx
  100b45:	8d b2 00 50 11 00    	lea    0x115000(%edx),%esi
  100b4b:	8a 9a 00 50 11 00    	mov    0x115000(%edx),%bl
  100b51:	89 c1                	mov    %eax,%ecx
  100b53:	83 e1 07             	and    $0x7,%ecx
  100b56:	0f b6 d3             	movzbl %bl,%edx
  100b59:	d3 fa                	sar    %cl,%edx
        if (!get_bit(phys_bitmap, i))
  100b5b:	f6 c2 01             	test   $0x1,%dl
  100b5e:	74 22                	je     100b82 <alloc_phys_page+0x57>
    for (int i = 0; i < 4096; i++)
  100b60:	40                   	inc    %eax
  100b61:	3d 00 10 00 00       	cmp    $0x1000,%eax
  100b66:	74 2c                	je     100b94 <alloc_phys_page+0x69>
    return (bitmap[bit / 8] >> (bit % 8)) & 1;
  100b68:	89 c2                	mov    %eax,%edx
  100b6a:	85 c0                	test   %eax,%eax
  100b6c:	79 d4                	jns    100b42 <alloc_phys_page+0x17>
  100b6e:	8d 50 07             	lea    0x7(%eax),%edx
  100b71:	eb cf                	jmp    100b42 <alloc_phys_page+0x17>
  100b73:	b9 00 00 00 00       	mov    $0x0,%ecx
  100b78:	be 00 50 11 00       	mov    $0x115000,%esi
    for (int i = 0; i < 4096; i++)
  100b7d:	b8 00 00 00 00       	mov    $0x0,%eax
    bitmap[bit / 8] |= (1 << (bit % 8));
  100b82:	ba 01 00 00 00       	mov    $0x1,%edx
  100b87:	d3 e2                	shl    %cl,%edx
  100b89:	09 d3                	or     %edx,%ebx
  100b8b:	88 1e                	mov    %bl,(%esi)
        {                            // 页空闲
            set_bit(phys_bitmap, i); // 标记为已用
            return i * PAGE_SIZE;    // 返回物理地址
  100b8d:	c1 e0 0c             	shl    $0xc,%eax
        }
    }
    return 0; // 没有空闲页
}
  100b90:	5b                   	pop    %ebx
  100b91:	5e                   	pop    %esi
  100b92:	5d                   	pop    %ebp
  100b93:	c3                   	ret
    return 0; // 没有空闲页
  100b94:	b8 00 00 00 00       	mov    $0x0,%eax
  100b99:	eb f5                	jmp    100b90 <alloc_phys_page+0x65>

00100b9b <free_phys_page>:

void free_phys_page(uint32_t addr)
{
  100b9b:	55                   	push   %ebp
  100b9c:	89 e5                	mov    %esp,%ebp
  100b9e:	8b 45 08             	mov    0x8(%ebp),%eax
    int index = addr / PAGE_SIZE;
  100ba1:	89 c1                	mov    %eax,%ecx
  100ba3:	c1 e9 0c             	shr    $0xc,%ecx
    bitmap[bit / 8] &= ~(1 << (bit % 8));
  100ba6:	c1 e8 0f             	shr    $0xf,%eax
  100ba9:	83 e1 07             	and    $0x7,%ecx
  100bac:	ba 01 00 00 00       	mov    $0x1,%edx
  100bb1:	d3 e2                	shl    %cl,%edx
  100bb3:	f7 d2                	not    %edx
  100bb5:	20 90 00 50 11 00    	and    %dl,0x115000(%eax)
    clear_bit(phys_bitmap, index);
}
  100bbb:	5d                   	pop    %ebp
  100bbc:	c3                   	ret

00100bbd <alloc_page>:

void alloc_page(uint32_t fault_addr, bool is_write, bool is_user)
{
  100bbd:	55                   	push   %ebp
  100bbe:	89 e5                	mov    %esp,%ebp
  100bc0:	57                   	push   %edi
  100bc1:	56                   	push   %esi
  100bc2:	53                   	push   %ebx
  100bc3:	83 ec 1c             	sub    $0x1c,%esp
  100bc6:	8b 7d 0c             	mov    0xc(%ebp),%edi
  100bc9:	8b 45 10             	mov    0x10(%ebp),%eax
  100bcc:	89 45 e0             	mov    %eax,-0x20(%ebp)
    uint32_t dir_idx = (fault_addr >> 22) & 0x3FF;   // 高 10 位
  100bcf:	8b 5d 08             	mov    0x8(%ebp),%ebx
  100bd2:	c1 eb 16             	shr    $0x16,%ebx
    uint32_t table_idx = (fault_addr >> 12) & 0x3FF; // 中间 10 位
  100bd5:	8b 45 08             	mov    0x8(%ebp),%eax
  100bd8:	c1 e8 0c             	shr    $0xc,%eax
  100bdb:	25 ff 03 00 00       	and    $0x3ff,%eax
  100be0:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    struct PagedDirectoryEntry *pde = &page_directory[dir_idx];

    if (!pde->present)
  100be3:	f6 04 9d 00 60 31 00 	testb  $0x1,0x316000(,%ebx,4)
  100bea:	01 
  100beb:	75 30                	jne    100c1d <alloc_page+0x60>
    {
        // 设置PDE指向对应的页表
        pde->table_addr = ((uint32_t)page_table[dir_idx]) >> 12;
  100bed:	89 da                	mov    %ebx,%edx
  100bef:	c1 e2 0c             	shl    $0xc,%edx
  100bf2:	81 c2 00 60 11 00    	add    $0x116000,%edx
  100bf8:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  100bfe:	8b 04 9d 00 60 31 00 	mov    0x316000(,%ebx,4),%eax
  100c05:	25 ff 0f 00 00       	and    $0xfff,%eax
  100c0a:	09 d0                	or     %edx,%eax
  100c0c:	89 04 9d 00 60 31 00 	mov    %eax,0x316000(,%ebx,4)
        pde->present = 1;
        pde->rw = 1;
        pde->user = 1;
  100c13:	83 c8 07             	or     $0x7,%eax
  100c16:	88 04 9d 00 60 31 00 	mov    %al,0x316000(,%ebx,4)
    }

    struct PageTableEntry *pte = &page_table[dir_idx][table_idx];
    uint32_t phys_page = alloc_phys_page(); // 新分配一个 4 KB 物理页
  100c1d:	e8 09 ff ff ff       	call   100b2b <alloc_phys_page>
  100c22:	89 c6                	mov    %eax,%esi

    // 通过直接映射区域清零物理页
    uint32_t virt_addr = 0xC0000000 + phys_page; // 直接映射虚拟地址
    memset((void *)virt_addr, 0, PAGE_SIZE);
  100c24:	83 ec 04             	sub    $0x4,%esp
  100c27:	68 00 10 00 00       	push   $0x1000
  100c2c:	6a 00                	push   $0x0
    uint32_t virt_addr = 0xC0000000 + phys_page; // 直接映射虚拟地址
  100c2e:	8d 80 00 00 00 c0    	lea    -0x40000000(%eax),%eax
    memset((void *)virt_addr, 0, PAGE_SIZE);
  100c34:	50                   	push   %eax
  100c35:	e8 70 f8 ff ff       	call   1004aa <memset>

    pte->frame_addr = phys_page >> 12;
  100c3a:	c1 e3 0a             	shl    $0xa,%ebx
  100c3d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100c40:	01 c3                	add    %eax,%ebx
  100c42:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  100c48:	8b 04 9d 00 60 11 00 	mov    0x116000(,%ebx,4),%eax
  100c4f:	25 ff 0f 00 00       	and    $0xfff,%eax
  100c54:	09 c6                	or     %eax,%esi
  100c56:	89 34 9d 00 60 11 00 	mov    %esi,0x116000(,%ebx,4)
    pte->present = 1;
  100c5d:	83 ce 01             	or     $0x1,%esi
    pte->rw = is_write ? 1 : 0;
  100c60:	83 e7 01             	and    $0x1,%edi
  100c63:	d1 e7                	shl    %edi
  100c65:	83 e6 f9             	and    $0xfffffff9,%esi
    pte->user = is_user ? 1 : 0;
  100c68:	8a 55 e0             	mov    -0x20(%ebp),%dl
  100c6b:	83 e2 01             	and    $0x1,%edx
  100c6e:	c1 e2 02             	shl    $0x2,%edx
  100c71:	89 f0                	mov    %esi,%eax
  100c73:	09 f8                	or     %edi,%eax
  100c75:	09 d0                	or     %edx,%eax
  100c77:	88 04 9d 00 60 11 00 	mov    %al,0x116000(,%ebx,4)

    // Invalidate TLB entry for the fault address
    __asm__ __volatile__("invlpg (%0)" : : "r"(fault_addr));
  100c7e:	8b 45 08             	mov    0x8(%ebp),%eax
  100c81:	0f 01 38             	invlpg (%eax)
}
  100c84:	83 c4 10             	add    $0x10,%esp
  100c87:	8d 65 f4             	lea    -0xc(%ebp),%esp
  100c8a:	5b                   	pop    %ebx
  100c8b:	5e                   	pop    %esi
  100c8c:	5f                   	pop    %edi
  100c8d:	5d                   	pop    %ebp
  100c8e:	c3                   	ret

00100c8f <r_cr2>:

int r_cr2()
{
    uint32_t val;
    asm volatile("mov %%cr2, %0" : "=r"(val));
  100c8f:	0f 20 d0             	mov    %cr2,%eax
    return val;
}
  100c92:	c3                   	ret

00100c93 <page_not_found_handler>:

void page_not_found_handler(uint32_t err)
{
  100c93:	55                   	push   %ebp
  100c94:	89 e5                	mov    %esp,%ebp
  100c96:	83 ec 0c             	sub    $0xc,%esp
  100c99:	8b 45 08             	mov    0x8(%ebp),%eax
    asm volatile("mov %%cr2, %0" : "=r"(val));
  100c9c:	0f 20 d1             	mov    %cr2,%ecx
    uint32_t fault_addr = r_cr2();
    uint32_t err_code = err;
    bool is_write = err_code & (1 << 1);
    bool is_user = err_code & (1 << 2);
  100c9f:	89 c2                	mov    %eax,%edx
  100ca1:	c1 ea 02             	shr    $0x2,%edx
  100ca4:	83 e2 01             	and    $0x1,%edx

    alloc_page(fault_addr, is_write, is_user);
  100ca7:	52                   	push   %edx
    bool is_write = err_code & (1 << 1);
  100ca8:	d1 e8                	shr    %eax
  100caa:	83 e0 01             	and    $0x1,%eax
    alloc_page(fault_addr, is_write, is_user);
  100cad:	50                   	push   %eax
  100cae:	51                   	push   %ecx
  100caf:	e8 09 ff ff ff       	call   100bbd <alloc_page>
}
  100cb4:	83 c4 10             	add    $0x10,%esp
  100cb7:	c9                   	leave
  100cb8:	c3                   	ret

00100cb9 <put_char>:
#include "sbi.h"

static char *video_memory = (char *)0xb8000;

void put_char(char c)
{
  100cb9:	55                   	push   %ebp
  100cba:	89 e5                	mov    %esp,%ebp
  100cbc:	53                   	push   %ebx
  100cbd:	8b 55 08             	mov    0x8(%ebp),%edx
  100cc0:	88 d1                	mov    %dl,%cl
    // 简单的换行处理 logic
    if (c == '\n')
  100cc2:	80 fa 0a             	cmp    $0xa,%dl
  100cc5:	74 20                	je     100ce7 <put_char+0x2e>
        uint32_t next_row_offset = (current_row + 1) * 80 * 2;
        video_memory = (char *)(0xb8000 + next_row_offset);
    }
    else
    {
        *video_memory = c;
  100cc7:	a1 38 38 10 00       	mov    0x103838,%eax
  100ccc:	88 10                	mov    %dl,(%eax)
        video_memory++;
        *video_memory = 0x07; // 黑底灰字
  100cce:	c6 40 01 07          	movb   $0x7,0x1(%eax)
        video_memory++;
  100cd2:	83 c0 02             	add    $0x2,%eax
        video_memory = (char *)(0xb8000 + next_row_offset);
  100cd5:	a3 38 38 10 00       	mov    %eax,0x103838
    }

    // 也写到串口 COM1（0x3F8），便于在 QEMU 中使用 -serial stdio 查看
    unsigned short port = 0x3f8;
    asm volatile("outb %0, %1" ::"a"(c), "Nd"(port));
  100cda:	ba f8 03 00 00       	mov    $0x3f8,%edx
  100cdf:	88 c8                	mov    %cl,%al
  100ce1:	ee                   	out    %al,(%dx)
}
  100ce2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  100ce5:	c9                   	leave
  100ce6:	c3                   	ret
        uint32_t current_offset = (uint32_t)(video_memory - 0xb8000);
  100ce7:	a1 38 38 10 00       	mov    0x103838,%eax
  100cec:	8d 90 00 80 f4 ff    	lea    -0xb8000(%eax),%edx
        uint32_t current_row = (current_offset / 2) / 80;
  100cf2:	bb cd cc cc cc       	mov    $0xcccccccd,%ebx
  100cf7:	89 d0                	mov    %edx,%eax
  100cf9:	f7 e3                	mul    %ebx
  100cfb:	c1 ea 07             	shr    $0x7,%edx
        video_memory = (char *)(0xb8000 + next_row_offset);
  100cfe:	8d 04 92             	lea    (%edx,%edx,4),%eax
  100d01:	c1 e0 05             	shl    $0x5,%eax
  100d04:	05 a0 80 0b 00       	add    $0xb80a0,%eax
  100d09:	eb ca                	jmp    100cd5 <put_char+0x1c>

00100d0b <shutdown>:

static inline void outw(uint16_t port, uint16_t value)
{
    __asm__ volatile("outw %0, %1" : : "a"(value), "Nd"(port));
  100d0b:	b8 00 20 00 00       	mov    $0x2000,%eax
  100d10:	ba 04 06 00 00       	mov    $0x604,%edx
  100d15:	66 ef                	out    %ax,(%dx)

void shutdown()
{
    outw(0x604, 0x2000); // QEMU power off
    for (;;)
        __asm__ volatile("hlt");
  100d17:	f4                   	hlt
    for (;;)
  100d18:	eb fd                	jmp    100d17 <shutdown+0xc>

00100d1a <sys_write>:
#include "../../console.h"

static uint32 heap_end = 0x900000; // 初始堆顶，假设在用户空间

uint32 sys_write(int fd, const char *str, uint32 len)
{
  100d1a:	55                   	push   %ebp
  100d1b:	89 e5                	mov    %esp,%ebp
  100d1d:	57                   	push   %edi
  100d1e:	56                   	push   %esi
  100d1f:	53                   	push   %ebx
  100d20:	83 ec 0c             	sub    $0xc,%esp
  100d23:	8b 75 0c             	mov    0xc(%ebp),%esi
  100d26:	8b 7d 10             	mov    0x10(%ebp),%edi
    // fd=1 (stdout) 或 fd=2 (stderr) 都可以输出
    if ((fd != 1 && fd != 2) || str == 0)
  100d29:	8b 45 08             	mov    0x8(%ebp),%eax
  100d2c:	48                   	dec    %eax
  100d2d:	83 f8 01             	cmp    $0x1,%eax
  100d30:	77 2a                	ja     100d5c <sys_write+0x42>
  100d32:	85 f6                	test   %esi,%esi
  100d34:	74 2d                	je     100d63 <sys_write+0x49>
        return -1;
    for (uint32_t i = 0; i < len; ++i)
  100d36:	85 ff                	test   %edi,%edi
  100d38:	74 18                	je     100d52 <sys_write+0x38>
  100d3a:	89 f3                	mov    %esi,%ebx
  100d3c:	01 fe                	add    %edi,%esi
        put_char(str[i]);
  100d3e:	83 ec 0c             	sub    $0xc,%esp
  100d41:	0f be 03             	movsbl (%ebx),%eax
  100d44:	50                   	push   %eax
  100d45:	e8 6f ff ff ff       	call   100cb9 <put_char>
    for (uint32_t i = 0; i < len; ++i)
  100d4a:	43                   	inc    %ebx
  100d4b:	83 c4 10             	add    $0x10,%esp
  100d4e:	39 f3                	cmp    %esi,%ebx
  100d50:	75 ec                	jne    100d3e <sys_write+0x24>
    return len;
}
  100d52:	89 f8                	mov    %edi,%eax
  100d54:	8d 65 f4             	lea    -0xc(%ebp),%esp
  100d57:	5b                   	pop    %ebx
  100d58:	5e                   	pop    %esi
  100d59:	5f                   	pop    %edi
  100d5a:	5d                   	pop    %ebp
  100d5b:	c3                   	ret
        return -1;
  100d5c:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  100d61:	eb ef                	jmp    100d52 <sys_write+0x38>
  100d63:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  100d68:	eb e8                	jmp    100d52 <sys_write+0x38>

00100d6a <sys_exit>:

__attribute__((noreturn)) void sys_exit(int code)
{
  100d6a:	55                   	push   %ebp
  100d6b:	89 e5                	mov    %esp,%ebp
  100d6d:	83 ec 08             	sub    $0x8,%esp
    shutdown();
  100d70:	e8 96 ff ff ff       	call   100d0b <shutdown>

00100d75 <sys_sbrk>:
    __builtin_unreachable();
}

uint32 sys_sbrk(int increment)
{
  100d75:	55                   	push   %ebp
  100d76:	89 e5                	mov    %esp,%ebp
    uint32 old_heap = heap_end;
  100d78:	a1 3c 38 10 00       	mov    0x10383c,%eax
    heap_end += increment;
  100d7d:	89 c2                	mov    %eax,%edx
  100d7f:	03 55 08             	add    0x8(%ebp),%edx
  100d82:	89 15 3c 38 10 00    	mov    %edx,0x10383c
    // 这里可以添加页面分配逻辑，如果需要
    return old_heap;
}
  100d88:	5d                   	pop    %ebp
  100d89:	c3                   	ret

00100d8a <syscall>:

void syscall(struct trapframe *tf)
{
  100d8a:	55                   	push   %ebp
  100d8b:	89 e5                	mov    %esp,%ebp
  100d8d:	56                   	push   %esi
  100d8e:	53                   	push   %ebx
  100d8f:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if (!tf)
  100d92:	85 db                	test   %ebx,%ebx
  100d94:	74 2c                	je     100dc2 <syscall+0x38>
        return;
    int id = tf->eax;
  100d96:	8b 43 1c             	mov    0x1c(%ebx),%eax
    int ret = -1;
    uint32 args[6] = {tf->ebx, tf->ecx, tf->edx, tf->esi, tf->edi, tf->ebp};
  100d99:	8b 53 10             	mov    0x10(%ebx),%edx
  100d9c:	8b 4b 18             	mov    0x18(%ebx),%ecx
  100d9f:	8b 73 14             	mov    0x14(%ebx),%esi
    __attribute__((unused)) uint32 eip = stack[0];
    __attribute__((unused)) uint32 cs = stack[1];
    __attribute__((unused)) uint32 eflags = stack[2];
    __attribute__((unused)) uint32 user_esp = stack[3];
    __attribute__((unused)) uint32 user_ss = stack[4];
    switch (id)
  100da2:	83 f8 5d             	cmp    $0x5d,%eax
  100da5:	74 22                	je     100dc9 <syscall+0x3f>
  100da7:	83 f8 5e             	cmp    $0x5e,%eax
  100daa:	74 22                	je     100dce <syscall+0x44>
  100dac:	83 f8 40             	cmp    $0x40,%eax
  100daf:	75 2c                	jne    100ddd <syscall+0x53>
    {
    case SYS_write:
        ret = sys_write(args[0], (const char *)args[1], args[2]);
  100db1:	83 ec 04             	sub    $0x4,%esp
  100db4:	56                   	push   %esi
  100db5:	51                   	push   %ecx
  100db6:	52                   	push   %edx
  100db7:	e8 5e ff ff ff       	call   100d1a <sys_write>
        break;
  100dbc:	83 c4 10             	add    $0x10,%esp
    default:
        printf("unknown interrupt or exception");
        sys_exit(args[0]);
        break;
    }
    tf->eax = ret;
  100dbf:	89 43 1c             	mov    %eax,0x1c(%ebx)
}
  100dc2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  100dc5:	5b                   	pop    %ebx
  100dc6:	5e                   	pop    %esi
  100dc7:	5d                   	pop    %ebp
  100dc8:	c3                   	ret
    shutdown();
  100dc9:	e8 3d ff ff ff       	call   100d0b <shutdown>
    uint32 old_heap = heap_end;
  100dce:	a1 3c 38 10 00       	mov    0x10383c,%eax
    heap_end += increment;
  100dd3:	01 c2                	add    %eax,%edx
  100dd5:	89 15 3c 38 10 00    	mov    %edx,0x10383c
        break;
  100ddb:	eb e2                	jmp    100dbf <syscall+0x35>
        printf("unknown interrupt or exception");
  100ddd:	83 ec 0c             	sub    $0xc,%esp
  100de0:	68 74 21 10 00       	push   $0x102174
  100de5:	e8 4d f6 ff ff       	call   100437 <printf>
    shutdown();
  100dea:	e8 1c ff ff ff       	call   100d0b <shutdown>

00100def <idt_init>:

__attribute__((aligned(4096))) char trap_page[0x1000];
__attribute__((aligned(4096))) char user_stack_top[0x1000];

void idt_init(void)
{
  100def:	55                   	push   %ebp
  100df0:	89 e5                	mov    %esp,%ebp
  100df2:	83 ec 0c             	sub    $0xc,%esp
    memset(idt, 0, sizeof(idt));
  100df5:	68 00 08 00 00       	push   $0x800
  100dfa:	6a 00                	push   $0x0
  100dfc:	68 00 41 11 00       	push   $0x114100
  100e01:	e8 a4 f6 ff ff       	call   1004aa <memset>

    set_idt_gate(0x80, trap_entry_0x80, 0x08, IDT_PRESENT | IDT_INT_GATE | IDT_RING3);
  100e06:	68 ee 00 00 00       	push   $0xee
  100e0b:	6a 08                	push   $0x8
  100e0d:	68 63 07 10 00       	push   $0x100763
  100e12:	68 80 00 00 00       	push   $0x80
  100e17:	e8 c5 fa ff ff       	call   1008e1 <set_idt_gate>
    set_idt_gate(0, trap_entry_0, 0x08, IDT_PRESENT | IDT_INT_GATE | IDT_RING3);
  100e1c:	83 c4 20             	add    $0x20,%esp
  100e1f:	68 ee 00 00 00       	push   $0xee
  100e24:	6a 08                	push   $0x8
  100e26:	68 69 06 10 00       	push   $0x100669
  100e2b:	6a 00                	push   $0x0
  100e2d:	e8 af fa ff ff       	call   1008e1 <set_idt_gate>
    set_idt_gate(1, trap_entry_1, 0x08, IDT_PRESENT | IDT_INT_GATE | IDT_RING3);
  100e32:	68 ee 00 00 00       	push   $0xee
  100e37:	6a 08                	push   $0x8
  100e39:	68 6f 06 10 00       	push   $0x10066f
  100e3e:	6a 01                	push   $0x1
  100e40:	e8 9c fa ff ff       	call   1008e1 <set_idt_gate>
    set_idt_gate(2, trap_entry_2, 0x08, IDT_PRESENT | IDT_INT_GATE | IDT_RING3);
  100e45:	83 c4 20             	add    $0x20,%esp
  100e48:	68 ee 00 00 00       	push   $0xee
  100e4d:	6a 08                	push   $0x8
  100e4f:	68 75 06 10 00       	push   $0x100675
  100e54:	6a 02                	push   $0x2
  100e56:	e8 86 fa ff ff       	call   1008e1 <set_idt_gate>
    set_idt_gate(3, trap_entry_3, 0x08, IDT_PRESENT | IDT_INT_GATE | IDT_RING3);
  100e5b:	68 ee 00 00 00       	push   $0xee
  100e60:	6a 08                	push   $0x8
  100e62:	68 7b 06 10 00       	push   $0x10067b
  100e67:	6a 03                	push   $0x3
  100e69:	e8 73 fa ff ff       	call   1008e1 <set_idt_gate>
    set_idt_gate(4, trap_entry_4, 0x08, IDT_PRESENT | IDT_INT_GATE | IDT_RING3);
  100e6e:	83 c4 20             	add    $0x20,%esp
  100e71:	68 ee 00 00 00       	push   $0xee
  100e76:	6a 08                	push   $0x8
  100e78:	68 81 06 10 00       	push   $0x100681
  100e7d:	6a 04                	push   $0x4
  100e7f:	e8 5d fa ff ff       	call   1008e1 <set_idt_gate>
    set_idt_gate(5, trap_entry_5, 0x08, IDT_PRESENT | IDT_INT_GATE | IDT_RING3);
  100e84:	68 ee 00 00 00       	push   $0xee
  100e89:	6a 08                	push   $0x8
  100e8b:	68 87 06 10 00       	push   $0x100687
  100e90:	6a 05                	push   $0x5
  100e92:	e8 4a fa ff ff       	call   1008e1 <set_idt_gate>
    set_idt_gate(6, trap_entry_6, 0x08, IDT_PRESENT | IDT_INT_GATE | IDT_RING3);
  100e97:	83 c4 20             	add    $0x20,%esp
  100e9a:	68 ee 00 00 00       	push   $0xee
  100e9f:	6a 08                	push   $0x8
  100ea1:	68 8d 06 10 00       	push   $0x10068d
  100ea6:	6a 06                	push   $0x6
  100ea8:	e8 34 fa ff ff       	call   1008e1 <set_idt_gate>
    set_idt_gate(7, trap_entry_7, 0x08, IDT_PRESENT | IDT_INT_GATE | IDT_RING3);
  100ead:	68 ee 00 00 00       	push   $0xee
  100eb2:	6a 08                	push   $0x8
  100eb4:	68 93 06 10 00       	push   $0x100693
  100eb9:	6a 07                	push   $0x7
  100ebb:	e8 21 fa ff ff       	call   1008e1 <set_idt_gate>
    set_idt_gate(8, trap_entry_8, 0x08, IDT_PRESENT | IDT_INT_GATE | IDT_RING3);
  100ec0:	83 c4 20             	add    $0x20,%esp
  100ec3:	68 ee 00 00 00       	push   $0xee
  100ec8:	6a 08                	push   $0x8
  100eca:	68 99 06 10 00       	push   $0x100699
  100ecf:	6a 08                	push   $0x8
  100ed1:	e8 0b fa ff ff       	call   1008e1 <set_idt_gate>
    set_idt_gate(9, trap_entry_9, 0x08, IDT_PRESENT | IDT_INT_GATE | IDT_RING3);
  100ed6:	68 ee 00 00 00       	push   $0xee
  100edb:	6a 08                	push   $0x8
  100edd:	68 9f 06 10 00       	push   $0x10069f
  100ee2:	6a 09                	push   $0x9
  100ee4:	e8 f8 f9 ff ff       	call   1008e1 <set_idt_gate>
    set_idt_gate(10, trap_entry_10, 0x08, IDT_PRESENT | IDT_INT_GATE | IDT_RING3);
  100ee9:	83 c4 20             	add    $0x20,%esp
  100eec:	68 ee 00 00 00       	push   $0xee
  100ef1:	6a 08                	push   $0x8
  100ef3:	68 a5 06 10 00       	push   $0x1006a5
  100ef8:	6a 0a                	push   $0xa
  100efa:	e8 e2 f9 ff ff       	call   1008e1 <set_idt_gate>
    set_idt_gate(11, trap_entry_11, 0x08, IDT_PRESENT | IDT_INT_GATE | IDT_RING3);
  100eff:	68 ee 00 00 00       	push   $0xee
  100f04:	6a 08                	push   $0x8
  100f06:	68 ab 06 10 00       	push   $0x1006ab
  100f0b:	6a 0b                	push   $0xb
  100f0d:	e8 cf f9 ff ff       	call   1008e1 <set_idt_gate>
    set_idt_gate(12, trap_entry_12, 0x08, IDT_PRESENT | IDT_INT_GATE | IDT_RING3);
  100f12:	83 c4 20             	add    $0x20,%esp
  100f15:	68 ee 00 00 00       	push   $0xee
  100f1a:	6a 08                	push   $0x8
  100f1c:	68 b1 06 10 00       	push   $0x1006b1
  100f21:	6a 0c                	push   $0xc
  100f23:	e8 b9 f9 ff ff       	call   1008e1 <set_idt_gate>
    set_idt_gate(13, trap_entry_13, 0x08, IDT_PRESENT | IDT_INT_GATE | IDT_RING3);
  100f28:	68 ee 00 00 00       	push   $0xee
  100f2d:	6a 08                	push   $0x8
  100f2f:	68 ba 06 10 00       	push   $0x1006ba
  100f34:	6a 0d                	push   $0xd
  100f36:	e8 a6 f9 ff ff       	call   1008e1 <set_idt_gate>
    set_idt_gate(14, trap_entry_14, 0x08, IDT_PRESENT | IDT_INT_GATE | IDT_RING3);
  100f3b:	83 c4 20             	add    $0x20,%esp
  100f3e:	68 ee 00 00 00       	push   $0xee
  100f43:	6a 08                	push   $0x8
  100f45:	68 c3 06 10 00       	push   $0x1006c3
  100f4a:	6a 0e                	push   $0xe
  100f4c:	e8 90 f9 ff ff       	call   1008e1 <set_idt_gate>
    set_idt_gate(15, trap_entry_15, 0x08, IDT_PRESENT | IDT_INT_GATE | IDT_RING3);
  100f51:	68 ee 00 00 00       	push   $0xee
  100f56:	6a 08                	push   $0x8
  100f58:	68 ca 06 10 00       	push   $0x1006ca
  100f5d:	6a 0f                	push   $0xf
  100f5f:	e8 7d f9 ff ff       	call   1008e1 <set_idt_gate>
    set_idt_gate(16, trap_entry_16, 0x08, IDT_PRESENT | IDT_INT_GATE | IDT_RING3);
  100f64:	83 c4 20             	add    $0x20,%esp
  100f67:	68 ee 00 00 00       	push   $0xee
  100f6c:	6a 08                	push   $0x8
  100f6e:	68 d3 06 10 00       	push   $0x1006d3
  100f73:	6a 10                	push   $0x10
  100f75:	e8 67 f9 ff ff       	call   1008e1 <set_idt_gate>
    set_idt_gate(17, trap_entry_17, 0x08, IDT_PRESENT | IDT_INT_GATE | IDT_RING3);
  100f7a:	68 ee 00 00 00       	push   $0xee
  100f7f:	6a 08                	push   $0x8
  100f81:	68 dc 06 10 00       	push   $0x1006dc
  100f86:	6a 11                	push   $0x11
  100f88:	e8 54 f9 ff ff       	call   1008e1 <set_idt_gate>
    set_idt_gate(18, trap_entry_18, 0x08, IDT_PRESENT | IDT_INT_GATE | IDT_RING3);
  100f8d:	83 c4 20             	add    $0x20,%esp
  100f90:	68 ee 00 00 00       	push   $0xee
  100f95:	6a 08                	push   $0x8
  100f97:	68 e5 06 10 00       	push   $0x1006e5
  100f9c:	6a 12                	push   $0x12
  100f9e:	e8 3e f9 ff ff       	call   1008e1 <set_idt_gate>
    set_idt_gate(19, trap_entry_19, 0x08, IDT_PRESENT | IDT_INT_GATE | IDT_RING3);
  100fa3:	68 ee 00 00 00       	push   $0xee
  100fa8:	6a 08                	push   $0x8
  100faa:	68 ee 06 10 00       	push   $0x1006ee
  100faf:	6a 13                	push   $0x13
  100fb1:	e8 2b f9 ff ff       	call   1008e1 <set_idt_gate>
    set_idt_gate(20, trap_entry_20, 0x08, IDT_PRESENT | IDT_INT_GATE | IDT_RING3);
  100fb6:	83 c4 20             	add    $0x20,%esp
  100fb9:	68 ee 00 00 00       	push   $0xee
  100fbe:	6a 08                	push   $0x8
  100fc0:	68 f7 06 10 00       	push   $0x1006f7
  100fc5:	6a 14                	push   $0x14
  100fc7:	e8 15 f9 ff ff       	call   1008e1 <set_idt_gate>
    set_idt_gate(21, trap_entry_21, 0x08, IDT_PRESENT | IDT_INT_GATE | IDT_RING3);
  100fcc:	68 ee 00 00 00       	push   $0xee
  100fd1:	6a 08                	push   $0x8
  100fd3:	68 00 07 10 00       	push   $0x100700
  100fd8:	6a 15                	push   $0x15
  100fda:	e8 02 f9 ff ff       	call   1008e1 <set_idt_gate>
    set_idt_gate(22, trap_entry_22, 0x08, IDT_PRESENT | IDT_INT_GATE | IDT_RING3);
  100fdf:	83 c4 20             	add    $0x20,%esp
  100fe2:	68 ee 00 00 00       	push   $0xee
  100fe7:	6a 08                	push   $0x8
  100fe9:	68 09 07 10 00       	push   $0x100709
  100fee:	6a 16                	push   $0x16
  100ff0:	e8 ec f8 ff ff       	call   1008e1 <set_idt_gate>
    set_idt_gate(23, trap_entry_23, 0x08, IDT_PRESENT | IDT_INT_GATE | IDT_RING3);
  100ff5:	68 ee 00 00 00       	push   $0xee
  100ffa:	6a 08                	push   $0x8
  100ffc:	68 12 07 10 00       	push   $0x100712
  101001:	6a 17                	push   $0x17
  101003:	e8 d9 f8 ff ff       	call   1008e1 <set_idt_gate>
    set_idt_gate(24, trap_entry_24, 0x08, IDT_PRESENT | IDT_INT_GATE | IDT_RING3);
  101008:	83 c4 20             	add    $0x20,%esp
  10100b:	68 ee 00 00 00       	push   $0xee
  101010:	6a 08                	push   $0x8
  101012:	68 1b 07 10 00       	push   $0x10071b
  101017:	6a 18                	push   $0x18
  101019:	e8 c3 f8 ff ff       	call   1008e1 <set_idt_gate>
    set_idt_gate(25, trap_entry_25, 0x08, IDT_PRESENT | IDT_INT_GATE | IDT_RING3);
  10101e:	68 ee 00 00 00       	push   $0xee
  101023:	6a 08                	push   $0x8
  101025:	68 24 07 10 00       	push   $0x100724
  10102a:	6a 19                	push   $0x19
  10102c:	e8 b0 f8 ff ff       	call   1008e1 <set_idt_gate>
    set_idt_gate(26, trap_entry_26, 0x08, IDT_PRESENT | IDT_INT_GATE | IDT_RING3);
  101031:	83 c4 20             	add    $0x20,%esp
  101034:	68 ee 00 00 00       	push   $0xee
  101039:	6a 08                	push   $0x8
  10103b:	68 2d 07 10 00       	push   $0x10072d
  101040:	6a 1a                	push   $0x1a
  101042:	e8 9a f8 ff ff       	call   1008e1 <set_idt_gate>
    set_idt_gate(27, trap_entry_27, 0x08, IDT_PRESENT | IDT_INT_GATE | IDT_RING3);
  101047:	68 ee 00 00 00       	push   $0xee
  10104c:	6a 08                	push   $0x8
  10104e:	68 36 07 10 00       	push   $0x100736
  101053:	6a 1b                	push   $0x1b
  101055:	e8 87 f8 ff ff       	call   1008e1 <set_idt_gate>
    set_idt_gate(28, trap_entry_28, 0x08, IDT_PRESENT | IDT_INT_GATE | IDT_RING3);
  10105a:	83 c4 20             	add    $0x20,%esp
  10105d:	68 ee 00 00 00       	push   $0xee
  101062:	6a 08                	push   $0x8
  101064:	68 3f 07 10 00       	push   $0x10073f
  101069:	6a 1c                	push   $0x1c
  10106b:	e8 71 f8 ff ff       	call   1008e1 <set_idt_gate>
    set_idt_gate(29, trap_entry_29, 0x08, IDT_PRESENT | IDT_INT_GATE | IDT_RING3);
  101070:	68 ee 00 00 00       	push   $0xee
  101075:	6a 08                	push   $0x8
  101077:	68 48 07 10 00       	push   $0x100748
  10107c:	6a 1d                	push   $0x1d
  10107e:	e8 5e f8 ff ff       	call   1008e1 <set_idt_gate>
    set_idt_gate(30, trap_entry_30, 0x08, IDT_PRESENT | IDT_INT_GATE | IDT_RING3);
  101083:	83 c4 20             	add    $0x20,%esp
  101086:	68 ee 00 00 00       	push   $0xee
  10108b:	6a 08                	push   $0x8
  10108d:	68 51 07 10 00       	push   $0x100751
  101092:	6a 1e                	push   $0x1e
  101094:	e8 48 f8 ff ff       	call   1008e1 <set_idt_gate>
    set_idt_gate(31, trap_entry_31, 0x08, IDT_PRESENT | IDT_INT_GATE | IDT_RING3);
  101099:	68 ee 00 00 00       	push   $0xee
  10109e:	6a 08                	push   $0x8
  1010a0:	68 5a 07 10 00       	push   $0x10075a
  1010a5:	6a 1f                	push   $0x1f
  1010a7:	e8 35 f8 ff ff       	call   1008e1 <set_idt_gate>

    idt_load();
  1010ac:	83 c4 20             	add    $0x20,%esp
  1010af:	e8 68 f8 ff ff       	call   10091c <idt_load>
}
  1010b4:	c9                   	leave
  1010b5:	c3                   	ret

001010b6 <trap_init>:

void trap_init()
{
  1010b6:	55                   	push   %ebp
  1010b7:	89 e5                	mov    %esp,%ebp
  1010b9:	83 ec 08             	sub    $0x8,%esp
    idt_init();
  1010bc:	e8 2e fd ff ff       	call   100def <idt_init>

    asm volatile("sti");
  1010c1:	fb                   	sti
}
  1010c2:	c9                   	leave
  1010c3:	c3                   	ret

001010c4 <trap_handler>:

void trap_handler(struct trapframe *tf)
{
  1010c4:	55                   	push   %ebp
  1010c5:	89 e5                	mov    %esp,%ebp
  1010c7:	53                   	push   %ebx
  1010c8:	83 ec 04             	sub    $0x4,%esp
  1010cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if (!tf)
  1010ce:	85 db                	test   %ebx,%ebx
  1010d0:	74 60                	je     101132 <trap_handler+0x6e>
        return;

    switch (tf->trapno)
  1010d2:	8b 43 30             	mov    0x30(%ebx),%eax
  1010d5:	83 f8 0e             	cmp    $0xe,%eax
  1010d8:	74 24                	je     1010fe <trap_handler+0x3a>
  1010da:	3d 80 00 00 00       	cmp    $0x80,%eax
  1010df:	74 45                	je     101126 <trap_handler+0x62>
  1010e1:	83 f8 0d             	cmp    $0xd,%eax
  1010e4:	74 28                	je     10110e <trap_handler+0x4a>
        return;
    default:
        break;
    }

    printf("CPU Exception %d occurred!\n", tf->trapno);
  1010e6:	83 ec 08             	sub    $0x8,%esp
  1010e9:	50                   	push   %eax
  1010ea:	68 bb 21 10 00       	push   $0x1021bb
  1010ef:	e8 43 f3 ff ff       	call   100437 <printf>
    shutdown();
  1010f4:	e8 12 fc ff ff       	call   100d0b <shutdown>

    return;
  1010f9:	83 c4 10             	add    $0x10,%esp
  1010fc:	eb 34                	jmp    101132 <trap_handler+0x6e>
        page_not_found_handler(tf->err);
  1010fe:	83 ec 0c             	sub    $0xc,%esp
  101101:	ff 73 34             	push   0x34(%ebx)
  101104:	e8 8a fb ff ff       	call   100c93 <page_not_found_handler>
        return;
  101109:	83 c4 10             	add    $0x10,%esp
  10110c:	eb 24                	jmp    101132 <trap_handler+0x6e>
        printf("General Protection Fault at EIP: 0x%x\n", tf->eip);
  10110e:	83 ec 08             	sub    $0x8,%esp
  101111:	ff 73 38             	push   0x38(%ebx)
  101114:	68 94 21 10 00       	push   $0x102194
  101119:	e8 19 f3 ff ff       	call   100437 <printf>
        shutdown();
  10111e:	e8 e8 fb ff ff       	call   100d0b <shutdown>
  101123:	83 c4 10             	add    $0x10,%esp
        syscall(tf);
  101126:	83 ec 0c             	sub    $0xc,%esp
  101129:	53                   	push   %ebx
  10112a:	e8 5b fc ff ff       	call   100d8a <syscall>
        return;
  10112f:	83 c4 10             	add    $0x10,%esp
}
  101132:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  101135:	c9                   	leave
  101136:	c3                   	ret

00101137 <user_app_load>:

int user_app_load(uint32 *info)
{
  101137:	55                   	push   %ebp
  101138:	89 e5                	mov    %esp,%ebp
  10113a:	57                   	push   %edi
  10113b:	56                   	push   %esi
  10113c:	53                   	push   %ebx
  10113d:	83 ec 1c             	sub    $0x1c,%esp
  101140:	8b 45 08             	mov    0x8(%ebp),%eax
    uint32 start = info[1];
  101143:	8b 50 04             	mov    0x4(%eax),%edx
  101146:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    uint32 end = info[2];
    uint32 length = end - start;
  101149:	8b 78 08             	mov    0x8(%eax),%edi
  10114c:	29 d7                	sub    %edx,%edi

    // 预分配用户程序的页面
    for (uint32 addr = BASE_ADDRESS; addr < BASE_ADDRESS + length; addr += PAGE_SIZE)
  10114e:	8d b7 00 00 80 00    	lea    0x800000(%edi),%esi
  101154:	81 fe 00 00 80 00    	cmp    $0x800000,%esi
  10115a:	76 1f                	jbe    10117b <user_app_load+0x44>
  10115c:	bb 00 00 80 00       	mov    $0x800000,%ebx
    {
        alloc_page(addr, 1, 1); // 写权限，用户权限
  101161:	83 ec 04             	sub    $0x4,%esp
  101164:	6a 01                	push   $0x1
  101166:	6a 01                	push   $0x1
  101168:	53                   	push   %ebx
  101169:	e8 4f fa ff ff       	call   100bbd <alloc_page>
    for (uint32 addr = BASE_ADDRESS; addr < BASE_ADDRESS + length; addr += PAGE_SIZE)
  10116e:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  101174:	83 c4 10             	add    $0x10,%esp
  101177:	39 f3                	cmp    %esi,%ebx
  101179:	72 e6                	jb     101161 <user_app_load+0x2a>
    }

    memset((void *)BASE_ADDRESS, 0, length);
  10117b:	83 ec 04             	sub    $0x4,%esp
  10117e:	57                   	push   %edi
  10117f:	6a 00                	push   $0x0
  101181:	68 00 00 80 00       	push   $0x800000
  101186:	e8 1f f3 ff ff       	call   1004aa <memset>
    memmove((void *)BASE_ADDRESS, (void *)start, length);
  10118b:	83 c4 0c             	add    $0xc,%esp
  10118e:	57                   	push   %edi
  10118f:	ff 75 e4             	push   -0x1c(%ebp)
  101192:	68 00 00 80 00       	push   $0x800000
  101197:	e8 6d f3 ff ff       	call   100509 <memmove>

    return (int)length;
}
  10119c:	89 f8                	mov    %edi,%eax
  10119e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  1011a1:	5b                   	pop    %ebx
  1011a2:	5e                   	pop    %esi
  1011a3:	5f                   	pop    %edi
  1011a4:	5d                   	pop    %ebp
  1011a5:	c3                   	ret

001011a6 <user_app_run>:

void user_app_run(void)
{
  1011a6:	55                   	push   %ebp
  1011a7:	89 e5                	mov    %esp,%ebp
  1011a9:	83 ec 14             	sub    $0x14,%esp
    user_app_load((uint32 *)_app_num);
  1011ac:	68 00 30 10 00       	push   $0x103000
  1011b1:	e8 81 ff ff ff       	call   101137 <user_app_load>

    // 预分配用户栈页面
    for (uint32 addr = USER_STACK_TOP - PAGE_SIZE; addr < USER_STACK_TOP; addr += PAGE_SIZE)
    {
        alloc_page(addr, 1, 1); // 写权限，用户权限
  1011b6:	83 c4 0c             	add    $0xc,%esp
  1011b9:	6a 01                	push   $0x1
  1011bb:	6a 01                	push   $0x1
  1011bd:	68 00 e0 7f 00       	push   $0x7fe000
  1011c2:	e8 f6 f9 ff ff       	call   100bbd <alloc_page>
    }

    tss_set((uint32_t)boot_stack_top);
  1011c7:	c7 04 24 00 40 11 00 	movl   $0x114000,(%esp)
  1011ce:	e8 01 f7 ff ff       	call   1008d4 <tss_set>
    user_enter(BASE_ADDRESS, USER_STACK_TOP);
  1011d3:	83 c4 08             	add    $0x8,%esp
  1011d6:	68 00 f0 7f 00       	push   $0x7ff000
  1011db:	68 00 00 80 00       	push   $0x800000
  1011e0:	e8 8a f5 ff ff       	call   10076f <user_enter>
}
  1011e5:	83 c4 10             	add    $0x10,%esp
  1011e8:	c9                   	leave
  1011e9:	c3                   	ret
