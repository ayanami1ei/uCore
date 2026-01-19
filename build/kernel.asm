
build/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080200000 <_entry>:
    .section .text.entry
    .globl _entry
_entry:
    la sp, boot_stack_top
    80200000:	00014117          	auipc	sp,0x14
    80200004:	00010113          	mv	sp,sp
    # 将 trap_entry 的地址装入通用寄存器，再写入 stvec
    #la t0, trap_entry
    #la t0, user_save
    #csrw stvec, t0
    call main    
    80200008:	478000ef          	jal	ra,80200480 <main>

000000008020000c <trap_entry>:
    
    .globl trap_entry
trap_entry:
    call trap_handler
    8020000c:	1d3000ef          	jal	ra,802009de <trap_handler>
    sret
    80200010:	10200073          	sret

0000000080200014 <print_unsigned>:
            (*count)++;
    }
}

static int print_unsigned(unsigned long long value, int base, int uppercase)
{
    80200014:	715d                	addi	sp,sp,-80
    80200016:	e486                	sd	ra,72(sp)
    80200018:	e0a2                	sd	s0,64(sp)
    8020001a:	fc26                	sd	s1,56(sp)
    8020001c:	f84a                	sd	s2,48(sp)
    8020001e:	f44e                	sd	s3,40(sp)
    80200020:	0880                	addi	s0,sp,80
    char buf[32];
    const char *digits_lower = "0123456789abcdef";
    const char *digits_upper = "0123456789ABCDEF";
    const char *digits = uppercase ? digits_upper : digits_lower;
    80200022:	00001817          	auipc	a6,0x1
    80200026:	27e80813          	addi	a6,a6,638 # 802012a0 <e_text+0x2a0>
    8020002a:	e609                	bnez	a2,80200034 <print_unsigned+0x20>
    8020002c:	00001817          	auipc	a6,0x1
    80200030:	28c80813          	addi	a6,a6,652 # 802012b8 <e_text+0x2b8>
    int i = 0;

    if (value == 0)
    80200034:	fb040713          	addi	a4,s0,-80
    int i = 0;
    80200038:	4481                	li	s1,0
    {
        kputc('0');
        return 1;
    }

    while (value != 0 && i < (int)sizeof(buf))
    8020003a:	02000613          	li	a2,32
    if (value == 0)
    8020003e:	c515                	beqz	a0,8020006a <print_unsigned+0x56>
    {
        int d = value % base;
        buf[i++] = digits[d];
    80200040:	0014869b          	addiw	a3,s1,1
        int d = value % base;
    80200044:	02b577b3          	remu	a5,a0,a1
        buf[i++] = digits[d];
    80200048:	2781                	sext.w	a5,a5
    8020004a:	97c2                	add	a5,a5,a6
    8020004c:	0007c783          	lbu	a5,0(a5)
    80200050:	00f70023          	sb	a5,0(a4)
        value /= base;
    80200054:	02b557b3          	divu	a5,a0,a1
    while (value != 0 && i < (int)sizeof(buf))
    80200058:	02b56163          	bltu	a0,a1,8020007a <print_unsigned+0x66>
    8020005c:	0705                	addi	a4,a4,1
        value /= base;
    8020005e:	853e                	mv	a0,a5
        buf[i++] = digits[d];
    80200060:	84b6                	mv	s1,a3
    while (value != 0 && i < (int)sizeof(buf))
    80200062:	fcc69fe3          	bne	a3,a2,80200040 <print_unsigned+0x2c>
    80200066:	44fd                	li	s1,31
    80200068:	a821                	j	80200080 <print_unsigned+0x6c>
    put_char(c);
    8020006a:	03000513          	li	a0,48
    8020006e:	00000097          	auipc	ra,0x0
    80200072:	47a080e7          	jalr	1146(ra) # 802004e8 <put_char>
        return 1;
    80200076:	4505                	li	a0,1
    80200078:	a825                	j	802000b0 <print_unsigned+0x9c>
    }

    int count = 0;
    while (i-- > 0)
    8020007a:	4501                	li	a0,0
    8020007c:	02d05a63          	blez	a3,802000b0 <print_unsigned+0x9c>
    80200080:	fb040793          	addi	a5,s0,-80
    80200084:	97a6                	add	a5,a5,s1
    80200086:	893e                	mv	s2,a5
    80200088:	0014899b          	addiw	s3,s1,1
    8020008c:	40f989bb          	subw	s3,s3,a5
    put_char(c);
    80200090:	00094503          	lbu	a0,0(s2)
    80200094:	00000097          	auipc	ra,0x0
    80200098:	454080e7          	jalr	1108(ra) # 802004e8 <put_char>
    {
        kputc(buf[i]);
        count++;
    8020009c:	197d                	addi	s2,s2,-1
    while (i-- > 0)
    8020009e:	012987bb          	addw	a5,s3,s2
    802000a2:	fef047e3          	bgtz	a5,80200090 <print_unsigned+0x7c>
    802000a6:	fff4c513          	not	a0,s1
    802000aa:	957d                	srai	a0,a0,0x3f
    802000ac:	8d65                	and	a0,a0,s1
    802000ae:	2505                	addiw	a0,a0,1
    }
    return count;
}
    802000b0:	60a6                	ld	ra,72(sp)
    802000b2:	6406                	ld	s0,64(sp)
    802000b4:	74e2                	ld	s1,56(sp)
    802000b6:	7942                	ld	s2,48(sp)
    802000b8:	79a2                	ld	s3,40(sp)
    802000ba:	6161                	addi	sp,sp,80
    802000bc:	8082                	ret

00000000802000be <vprintf>:
    count += print_unsigned((unsigned long long)ptr, 16, 0);
    return count;
}

int vprintf(const char *fmt, va_list ap)
{
    802000be:	7119                	addi	sp,sp,-128
    802000c0:	fc86                	sd	ra,120(sp)
    802000c2:	f8a2                	sd	s0,112(sp)
    802000c4:	f4a6                	sd	s1,104(sp)
    802000c6:	f0ca                	sd	s2,96(sp)
    802000c8:	ecce                	sd	s3,88(sp)
    802000ca:	e8d2                	sd	s4,80(sp)
    802000cc:	e4d6                	sd	s5,72(sp)
    802000ce:	e0da                	sd	s6,64(sp)
    802000d0:	fc5e                	sd	s7,56(sp)
    802000d2:	f862                	sd	s8,48(sp)
    802000d4:	f466                	sd	s9,40(sp)
    802000d6:	f06a                	sd	s10,32(sp)
    802000d8:	ec6e                	sd	s11,24(sp)
    802000da:	0100                	addi	s0,sp,128
    802000dc:	89aa                	mv	s3,a0
    int count = 0;

    for (; *fmt; fmt++)
    802000de:	00054503          	lbu	a0,0(a0)
    802000e2:	2a050863          	beqz	a0,80200392 <vprintf+0x2d4>
    802000e6:	8b2e                	mv	s6,a1
    int count = 0;
    802000e8:	4a01                	li	s4,0
    {
        if (*fmt != '%')
    802000ea:	02500a93          	li	s5,37
        if (*fmt == '\0')
            break;

        // 暂时只支持一个或零个 'l' 修饰符
        int long_flag = 0;
        while (*fmt == 'l')
    802000ee:	06c00913          	li	s2,108
        {
            long_flag++;
            fmt++;
        }

        switch (*fmt)
    802000f2:	05300c13          	li	s8,83
    802000f6:	00001d17          	auipc	s10,0x1
    802000fa:	05ad0d13          	addi	s10,s10,90 # 80201150 <e_text+0x150>
        s = "(null)";
    802000fe:	00001d97          	auipc	s11,0x1
    80200102:	1d2d8d93          	addi	s11,s11,466 # 802012d0 <e_text+0x2d0>
    80200106:	00001c97          	auipc	s9,0x1
    8020010a:	1d2c8c93          	addi	s9,s9,466 # 802012d8 <e_text+0x2d8>
        switch (*fmt)
    8020010e:	00001b97          	auipc	s7,0x1
    80200112:	ef2b8b93          	addi	s7,s7,-270 # 80201000 <e_text>
    80200116:	a829                	j	80200130 <vprintf+0x72>
    put_char(c);
    80200118:	00000097          	auipc	ra,0x0
    8020011c:	3d0080e7          	jalr	976(ra) # 802004e8 <put_char>
            count++;
    80200120:	2a05                	addiw	s4,s4,1
            continue;
    80200122:	84ce                	mv	s1,s3
    for (; *fmt; fmt++)
    80200124:	00148993          	addi	s3,s1,1
    80200128:	0014c503          	lbu	a0,1(s1)
    8020012c:	26050463          	beqz	a0,80200394 <vprintf+0x2d6>
        if (*fmt != '%')
    80200130:	ff5514e3          	bne	a0,s5,80200118 <vprintf+0x5a>
        fmt++; // skip '%'
    80200134:	00198693          	addi	a3,s3,1
        if (*fmt == '\0')
    80200138:	0019c783          	lbu	a5,1(s3)
    8020013c:	24078c63          	beqz	a5,80200394 <vprintf+0x2d6>
        while (*fmt == 'l')
    80200140:	27279a63          	bne	a5,s2,802003b4 <vprintf+0x2f6>
        fmt++; // skip '%'
    80200144:	84b6                	mv	s1,a3
    80200146:	4705                	li	a4,1
    80200148:	9f15                	subw	a4,a4,a3
            long_flag++;
    8020014a:	009709bb          	addw	s3,a4,s1
            fmt++;
    8020014e:	0485                	addi	s1,s1,1
        while (*fmt == 'l')
    80200150:	0004c783          	lbu	a5,0(s1)
    80200154:	ff278be3          	beq	a5,s2,8020014a <vprintf+0x8c>
        switch (*fmt)
    80200158:	fdb7879b          	addiw	a5,a5,-37
    8020015c:	0ff7f713          	andi	a4,a5,255
    80200160:	00ec6963          	bltu	s8,a4,80200172 <vprintf+0xb4>
    80200164:	00271793          	slli	a5,a4,0x2
    80200168:	97de                	add	a5,a5,s7
    8020016a:	439c                	lw	a5,0(a5)
    8020016c:	97de                	add	a5,a5,s7
    8020016e:	8782                	jr	a5
        fmt++; // skip '%'
    80200170:	84b6                	mv	s1,a3
    while (*s)
    80200172:	05b00513          	li	a0,91
    80200176:	00001997          	auipc	s3,0x1
    8020017a:	16298993          	addi	s3,s3,354 # 802012d8 <e_text+0x2d8>
        kputc(*s++);
    8020017e:	0985                	addi	s3,s3,1
    put_char(c);
    80200180:	00000097          	auipc	ra,0x0
    80200184:	368080e7          	jalr	872(ra) # 802004e8 <put_char>
            (*count)++;
    80200188:	419987bb          	subw	a5,s3,s9
    8020018c:	014787bb          	addw	a5,a5,s4
    while (*s)
    80200190:	0009c503          	lbu	a0,0(s3)
    80200194:	f56d                	bnez	a0,8020017e <vprintf+0xc0>
            (*count)++;
    80200196:	8a3e                	mv	s4,a5
    80200198:	b771                	j	80200124 <vprintf+0x66>
        fmt++; // skip '%'
    8020019a:	84b6                	mv	s1,a3
        int long_flag = 0;
    8020019c:	4981                	li	s3,0
        {
        case 'd':
        case 'i':
            if (long_flag)
    8020019e:	04098363          	beqz	s3,802001e4 <vprintf+0x126>
            {
                long long v = va_arg(ap, long long);
    802001a2:	008b0793          	addi	a5,s6,8
    802001a6:	f8f43423          	sd	a5,-120(s0)
    802001aa:	000b3b03          	ld	s6,0(s6)
        u = (unsigned long long)value;
    802001ae:	855a                	mv	a0,s6
    int count = 0;
    802001b0:	4981                	li	s3,0
    if (value < 0)
    802001b2:	000b4f63          	bltz	s6,802001d0 <vprintf+0x112>
    count += print_unsigned(u, base, 0);
    802001b6:	4601                	li	a2,0
    802001b8:	45a9                	li	a1,10
    802001ba:	00000097          	auipc	ra,0x0
    802001be:	e5a080e7          	jalr	-422(ra) # 80200014 <print_unsigned>
    802001c2:	0135053b          	addw	a0,a0,s3
                count += print_signed(v, 10);
    802001c6:	01450a3b          	addw	s4,a0,s4
                long long v = va_arg(ap, long long);
    802001ca:	f8843b03          	ld	s6,-120(s0)
    802001ce:	bf99                	j	80200124 <vprintf+0x66>
    put_char(c);
    802001d0:	02d00513          	li	a0,45
    802001d4:	00000097          	auipc	ra,0x0
    802001d8:	314080e7          	jalr	788(ra) # 802004e8 <put_char>
        u = (unsigned long long)(-value);
    802001dc:	41600533          	neg	a0,s6
        count++;
    802001e0:	4985                	li	s3,1
    802001e2:	bfd1                	j	802001b6 <vprintf+0xf8>
            }
            else
            {
                int v = va_arg(ap, int);
    802001e4:	008b0793          	addi	a5,s6,8
    802001e8:	f8f43423          	sd	a5,-120(s0)
    802001ec:	000b2b03          	lw	s6,0(s6)
        u = (unsigned long long)value;
    802001f0:	855a                	mv	a0,s6
    if (value < 0)
    802001f2:	000b4f63          	bltz	s6,80200210 <vprintf+0x152>
    count += print_unsigned(u, base, 0);
    802001f6:	4601                	li	a2,0
    802001f8:	45a9                	li	a1,10
    802001fa:	00000097          	auipc	ra,0x0
    802001fe:	e1a080e7          	jalr	-486(ra) # 80200014 <print_unsigned>
    80200202:	0135053b          	addw	a0,a0,s3
                count += print_signed(v, 10);
    80200206:	01450a3b          	addw	s4,a0,s4
                int v = va_arg(ap, int);
    8020020a:	f8843b03          	ld	s6,-120(s0)
    8020020e:	bf19                	j	80200124 <vprintf+0x66>
    put_char(c);
    80200210:	02d00513          	li	a0,45
    80200214:	00000097          	auipc	ra,0x0
    80200218:	2d4080e7          	jalr	724(ra) # 802004e8 <put_char>
        u = (unsigned long long)(-value);
    8020021c:	41600533          	neg	a0,s6
        count++;
    80200220:	4985                	li	s3,1
    80200222:	bfd1                	j	802001f6 <vprintf+0x138>
        fmt++; // skip '%'
    80200224:	84b6                	mv	s1,a3
        int long_flag = 0;
    80200226:	4981                	li	s3,0
            }
            break;
        case 'u':
            if (long_flag)
    80200228:	02098063          	beqz	s3,80200248 <vprintf+0x18a>
            {
                unsigned long long v = va_arg(ap, unsigned long long);
    8020022c:	008b0993          	addi	s3,s6,8
                count += print_unsigned(v, 10, 0);
    80200230:	4601                	li	a2,0
    80200232:	45a9                	li	a1,10
    80200234:	000b3503          	ld	a0,0(s6)
    80200238:	00000097          	auipc	ra,0x0
    8020023c:	ddc080e7          	jalr	-548(ra) # 80200014 <print_unsigned>
    80200240:	01450a3b          	addw	s4,a0,s4
                unsigned long long v = va_arg(ap, unsigned long long);
    80200244:	8b4e                	mv	s6,s3
    80200246:	bdf9                	j	80200124 <vprintf+0x66>
            }
            else
            {
                unsigned int v = va_arg(ap, unsigned int);
    80200248:	008b0993          	addi	s3,s6,8
                count += print_unsigned(v, 10, 0);
    8020024c:	4601                	li	a2,0
    8020024e:	45a9                	li	a1,10
    80200250:	000b6503          	lwu	a0,0(s6)
    80200254:	00000097          	auipc	ra,0x0
    80200258:	dc0080e7          	jalr	-576(ra) # 80200014 <print_unsigned>
    8020025c:	01450a3b          	addw	s4,a0,s4
                unsigned int v = va_arg(ap, unsigned int);
    80200260:	8b4e                	mv	s6,s3
    80200262:	b5c9                	j	80200124 <vprintf+0x66>
        fmt++; // skip '%'
    80200264:	84b6                	mv	s1,a3
        int long_flag = 0;
    80200266:	4981                	li	s3,0
            }
            break;
        case 'x':
            if (long_flag)
    80200268:	02098063          	beqz	s3,80200288 <vprintf+0x1ca>
            {
                unsigned long long v = va_arg(ap, unsigned long long);
    8020026c:	008b0993          	addi	s3,s6,8
                count += print_unsigned(v, 16, 0);
    80200270:	4601                	li	a2,0
    80200272:	45c1                	li	a1,16
    80200274:	000b3503          	ld	a0,0(s6)
    80200278:	00000097          	auipc	ra,0x0
    8020027c:	d9c080e7          	jalr	-612(ra) # 80200014 <print_unsigned>
    80200280:	01450a3b          	addw	s4,a0,s4
                unsigned long long v = va_arg(ap, unsigned long long);
    80200284:	8b4e                	mv	s6,s3
    80200286:	bd79                	j	80200124 <vprintf+0x66>
            }
            else
            {
                unsigned int v = va_arg(ap, unsigned int);
    80200288:	008b0993          	addi	s3,s6,8
                count += print_unsigned(v, 16, 0);
    8020028c:	4601                	li	a2,0
    8020028e:	45c1                	li	a1,16
    80200290:	000b6503          	lwu	a0,0(s6)
    80200294:	00000097          	auipc	ra,0x0
    80200298:	d80080e7          	jalr	-640(ra) # 80200014 <print_unsigned>
    8020029c:	01450a3b          	addw	s4,a0,s4
                unsigned int v = va_arg(ap, unsigned int);
    802002a0:	8b4e                	mv	s6,s3
    802002a2:	b549                	j	80200124 <vprintf+0x66>
            }
            break;
        case 'X':
            if (long_flag)
    802002a4:	02098163          	beqz	s3,802002c6 <vprintf+0x208>
            {
                unsigned long long v = va_arg(ap, unsigned long long);
    802002a8:	008b0993          	addi	s3,s6,8
                count += print_unsigned(v, 16, 1);
    802002ac:	4605                	li	a2,1
    802002ae:	45c1                	li	a1,16
    802002b0:	000b3503          	ld	a0,0(s6)
    802002b4:	00000097          	auipc	ra,0x0
    802002b8:	d60080e7          	jalr	-672(ra) # 80200014 <print_unsigned>
    802002bc:	01450a3b          	addw	s4,a0,s4
                unsigned long long v = va_arg(ap, unsigned long long);
    802002c0:	8b4e                	mv	s6,s3
    802002c2:	b58d                	j	80200124 <vprintf+0x66>
        fmt++; // skip '%'
    802002c4:	84b6                	mv	s1,a3
            }
            else
            {
                unsigned int v = va_arg(ap, unsigned int);
    802002c6:	008b0993          	addi	s3,s6,8
                count += print_unsigned(v, 16, 1);
    802002ca:	4605                	li	a2,1
    802002cc:	45c1                	li	a1,16
    802002ce:	000b6503          	lwu	a0,0(s6)
    802002d2:	00000097          	auipc	ra,0x0
    802002d6:	d42080e7          	jalr	-702(ra) # 80200014 <print_unsigned>
    802002da:	01450a3b          	addw	s4,a0,s4
                unsigned int v = va_arg(ap, unsigned int);
    802002de:	8b4e                	mv	s6,s3
    802002e0:	b591                	j	80200124 <vprintf+0x66>
        fmt++; // skip '%'
    802002e2:	84b6                	mv	s1,a3
            }
            break;
        case 'p':
        {
            void *p = va_arg(ap, void *);
    802002e4:	008b0793          	addi	a5,s6,8
    802002e8:	f8f43423          	sd	a5,-120(s0)
    802002ec:	000b3983          	ld	s3,0(s6)
    put_char(c);
    802002f0:	03000513          	li	a0,48
    802002f4:	00000097          	auipc	ra,0x0
    802002f8:	1f4080e7          	jalr	500(ra) # 802004e8 <put_char>
    802002fc:	07800513          	li	a0,120
    80200300:	00000097          	auipc	ra,0x0
    80200304:	1e8080e7          	jalr	488(ra) # 802004e8 <put_char>
    count += print_unsigned((unsigned long long)ptr, 16, 0);
    80200308:	4601                	li	a2,0
    8020030a:	45c1                	li	a1,16
    8020030c:	854e                	mv	a0,s3
    8020030e:	00000097          	auipc	ra,0x0
    80200312:	d06080e7          	jalr	-762(ra) # 80200014 <print_unsigned>
    80200316:	2509                	addiw	a0,a0,2
            count += print_pointer(p);
    80200318:	01450a3b          	addw	s4,a0,s4
            void *p = va_arg(ap, void *);
    8020031c:	f8843b03          	ld	s6,-120(s0)
            break;
    80200320:	b511                	j	80200124 <vprintf+0x66>
        fmt++; // skip '%'
    80200322:	84b6                	mv	s1,a3
        }
        case 'c':
        {
            int c = va_arg(ap, int);
    80200324:	008b0993          	addi	s3,s6,8
    put_char(c);
    80200328:	000b4503          	lbu	a0,0(s6)
    8020032c:	00000097          	auipc	ra,0x0
    80200330:	1bc080e7          	jalr	444(ra) # 802004e8 <put_char>
            kputc((char)c);
            count++;
    80200334:	2a05                	addiw	s4,s4,1
            int c = va_arg(ap, int);
    80200336:	8b4e                	mv	s6,s3
            break;
    80200338:	b3f5                	j	80200124 <vprintf+0x66>
        fmt++; // skip '%'
    8020033a:	84b6                	mv	s1,a3
        }
        case 's':
        {
            const char *s = va_arg(ap, const char *);
    8020033c:	008b0793          	addi	a5,s6,8
    80200340:	f8f43423          	sd	a5,-120(s0)
    80200344:	000b3b03          	ld	s6,0(s6)
    if (!s)
    80200348:	020b0663          	beqz	s6,80200374 <vprintf+0x2b6>
    while (*s)
    8020034c:	000b4503          	lbu	a0,0(s6)
    80200350:	cd15                	beqz	a0,8020038c <vprintf+0x2ce>
        s = "(null)";
    80200352:	89da                	mv	s3,s6
        kputc(*s++);
    80200354:	0985                	addi	s3,s3,1
    put_char(c);
    80200356:	00000097          	auipc	ra,0x0
    8020035a:	192080e7          	jalr	402(ra) # 802004e8 <put_char>
            (*count)++;
    8020035e:	013a07bb          	addw	a5,s4,s3
    80200362:	416787bb          	subw	a5,a5,s6
    while (*s)
    80200366:	0009c503          	lbu	a0,0(s3)
    8020036a:	f56d                	bnez	a0,80200354 <vprintf+0x296>
            const char *s = va_arg(ap, const char *);
    8020036c:	f8843b03          	ld	s6,-120(s0)
            (*count)++;
    80200370:	8a3e                	mv	s4,a5
    80200372:	bb4d                	j	80200124 <vprintf+0x66>
    while (*s)
    80200374:	02800513          	li	a0,40
        s = "(null)";
    80200378:	8b6e                	mv	s6,s11
    8020037a:	bfe1                	j	80200352 <vprintf+0x294>
        fmt++; // skip '%'
    8020037c:	84b6                	mv	s1,a3
    put_char(c);
    8020037e:	8556                	mv	a0,s5
    80200380:	00000097          	auipc	ra,0x0
    80200384:	168080e7          	jalr	360(ra) # 802004e8 <put_char>
            kputs(s, &count);
            break;
        }
        case '%':
            kputc('%');
            count++;
    80200388:	2a05                	addiw	s4,s4,1
            break;
    8020038a:	bb69                	j	80200124 <vprintf+0x66>
            const char *s = va_arg(ap, const char *);
    8020038c:	f8843b03          	ld	s6,-120(s0)
    80200390:	bb51                	j	80200124 <vprintf+0x66>
    int count = 0;
    80200392:	4a01                	li	s4,0
            break;
        }
    }

    return count;
}
    80200394:	8552                	mv	a0,s4
    80200396:	70e6                	ld	ra,120(sp)
    80200398:	7446                	ld	s0,112(sp)
    8020039a:	74a6                	ld	s1,104(sp)
    8020039c:	7906                	ld	s2,96(sp)
    8020039e:	69e6                	ld	s3,88(sp)
    802003a0:	6a46                	ld	s4,80(sp)
    802003a2:	6aa6                	ld	s5,72(sp)
    802003a4:	6b06                	ld	s6,64(sp)
    802003a6:	7be2                	ld	s7,56(sp)
    802003a8:	7c42                	ld	s8,48(sp)
    802003aa:	7ca2                	ld	s9,40(sp)
    802003ac:	7d02                	ld	s10,32(sp)
    802003ae:	6de2                	ld	s11,24(sp)
    802003b0:	6109                	addi	sp,sp,128
    802003b2:	8082                	ret
        switch (*fmt)
    802003b4:	fdb7879b          	addiw	a5,a5,-37
    802003b8:	0ff7f713          	andi	a4,a5,255
    802003bc:	daec6ae3          	bltu	s8,a4,80200170 <vprintf+0xb2>
    802003c0:	00271793          	slli	a5,a4,0x2
    802003c4:	97ea                	add	a5,a5,s10
    802003c6:	439c                	lw	a5,0(a5)
    802003c8:	97ea                	add	a5,a5,s10
    802003ca:	8782                	jr	a5

00000000802003cc <printf>:

int printf(const char *fmt, ...)
{
    802003cc:	711d                	addi	sp,sp,-96
    802003ce:	ec06                	sd	ra,24(sp)
    802003d0:	e822                	sd	s0,16(sp)
    802003d2:	1000                	addi	s0,sp,32
    802003d4:	e40c                	sd	a1,8(s0)
    802003d6:	e810                	sd	a2,16(s0)
    802003d8:	ec14                	sd	a3,24(s0)
    802003da:	f018                	sd	a4,32(s0)
    802003dc:	f41c                	sd	a5,40(s0)
    802003de:	03043823          	sd	a6,48(s0)
    802003e2:	03143c23          	sd	a7,56(s0)
    va_list ap;
    va_start(ap, fmt);
    802003e6:	00840593          	addi	a1,s0,8
    802003ea:	feb43423          	sd	a1,-24(s0)
    int ret = vprintf(fmt, ap);
    802003ee:	00000097          	auipc	ra,0x0
    802003f2:	cd0080e7          	jalr	-816(ra) # 802000be <vprintf>
    va_end(ap);
    return ret;
}
    802003f6:	60e2                	ld	ra,24(sp)
    802003f8:	6442                	ld	s0,16(sp)
    802003fa:	6125                	addi	sp,sp,96
    802003fc:	8082                	ret

00000000802003fe <scanf_char>:

char scanf_char()
{
    802003fe:	1141                	addi	sp,sp,-16
    80200400:	e406                	sd	ra,8(sp)
    80200402:	e022                	sd	s0,0(sp)
    80200404:	0800                	addi	s0,sp,16
    return keyboard_trap();
    80200406:	00000097          	auipc	ra,0x0
    8020040a:	02c080e7          	jalr	44(ra) # 80200432 <keyboard_trap>
}
    8020040e:	60a2                	ld	ra,8(sp)
    80200410:	6402                	ld	s0,0(sp)
    80200412:	0141                	addi	sp,sp,16
    80200414:	8082                	ret

0000000080200416 <uart_enable_rx_interrupt>:
{
    return *(volatile uint8 *)(UART0_BASE + offset);
}

void uart_enable_rx_interrupt()
{
    80200416:	1141                	addi	sp,sp,-16
    80200418:	e422                	sd	s0,8(sp)
    8020041a:	0800                	addi	s0,sp,16
    return *(volatile uint8 *)(UART0_BASE + offset);
    8020041c:	10000737          	lui	a4,0x10000
    80200420:	00174783          	lbu	a5,1(a4) # 10000001 <TF_SIZE+0xffffee1>
    uint8 ier = uart_read_reg(UART_IER);
    ier |= 0x01; // bit0 = 1: Enable Received Data Available Interrupt
    80200424:	0017e793          	ori	a5,a5,1
    *(volatile uint8 *)(UART0_BASE + offset) = val;
    80200428:	00f700a3          	sb	a5,1(a4)
    uart_write_reg(UART_IER, ier);
}
    8020042c:	6422                	ld	s0,8(sp)
    8020042e:	0141                	addi	sp,sp,16
    80200430:	8082                	ret

0000000080200432 <keyboard_trap>:

char keyboard_trap()
{
    80200432:	1101                	addi	sp,sp,-32
    80200434:	ec06                	sd	ra,24(sp)
    80200436:	e822                	sd	s0,16(sp)
    80200438:	e426                	sd	s1,8(sp)
    8020043a:	1000                	addi	s0,sp,32
    uint8 lsr = 0;
    while ((lsr & 0x01) == 0)
    {
        lsr = r_LSR();
    8020043c:	00000097          	auipc	ra,0x0
    80200440:	14c080e7          	jalr	332(ra) # 80200588 <r_LSR>
    while ((lsr & 0x01) == 0)
    80200444:	8905                	andi	a0,a0,1
    80200446:	d97d                	beqz	a0,8020043c <keyboard_trap+0xa>
    }

    uint64 rhr = r_RHR();
    80200448:	00000097          	auipc	ra,0x0
    8020044c:	154080e7          	jalr	340(ra) # 8020059c <r_RHR>
    80200450:	84aa                	mv	s1,a0
    char c = (char)(rhr & 0xFF);

    printf("%c", c);
    80200452:	0005059b          	sext.w	a1,a0
    80200456:	00001517          	auipc	a0,0x1
    8020045a:	e8a50513          	addi	a0,a0,-374 # 802012e0 <e_text+0x2e0>
    8020045e:	00000097          	auipc	ra,0x0
    80200462:	f6e080e7          	jalr	-146(ra) # 802003cc <printf>
    return c;
    80200466:	8526                	mv	a0,s1
    80200468:	60e2                	ld	ra,24(sp)
    8020046a:	6442                	ld	s0,16(sp)
    8020046c:	64a2                	ld	s1,8(sp)
    8020046e:	6105                	addi	sp,sp,32
    80200470:	8082                	ret

0000000080200472 <add>:

// 在这里真正定义全局定时器实例
struct timer t;

int add(int a, int b)
{
    80200472:	1141                	addi	sp,sp,-16
    80200474:	e422                	sd	s0,8(sp)
    80200476:	0800                	addi	s0,sp,16
   return a + b;
}
    80200478:	9d2d                	addw	a0,a0,a1
    8020047a:	6422                	ld	s0,8(sp)
    8020047c:	0141                	addi	sp,sp,16
    8020047e:	8082                	ret

0000000080200480 <main>:

int main()
{
    80200480:	1141                	addi	sp,sp,-16
    80200482:	e406                	sd	ra,8(sp)
    80200484:	e022                	sd	s0,0(sp)
    80200486:	0800                	addi	s0,sp,16
   trap_init();
    80200488:	00000097          	auipc	ra,0x0
    8020048c:	53e080e7          	jalr	1342(ra) # 802009c6 <trap_init>
   //init_timer(0);

   printf("Welcome to uCore!\n");
    80200490:	00001517          	auipc	a0,0x1
    80200494:	e5850513          	addi	a0,a0,-424 # 802012e8 <e_text+0x2e8>
    80200498:	00000097          	auipc	ra,0x0
    8020049c:	f34080e7          	jalr	-204(ra) # 802003cc <printf>
   user_app_run();
    802004a0:	00000097          	auipc	ra,0x0
    802004a4:	718080e7          	jalr	1816(ra) # 80200bb8 <user_app_run>

   shutdown();
    802004a8:	00000097          	auipc	ra,0x0
    802004ac:	058080e7          	jalr	88(ra) # 80200500 <shutdown>

   return 0;
}
    802004b0:	4501                	li	a0,0
    802004b2:	60a2                	ld	ra,8(sp)
    802004b4:	6402                	ld	s0,0(sp)
    802004b6:	0141                	addi	sp,sp,16
    802004b8:	8082                	ret

00000000802004ba <plic_enable_uart0>:
{
    return *(volatile uint32 *)addr;
}

void plic_enable_uart0(void)
{
    802004ba:	1141                	addi	sp,sp,-16
    802004bc:	e422                	sd	s0,8(sp)
    802004be:	0800                	addi	s0,sp,16
    *(volatile uint32 *)addr = val;
    802004c0:	0c0007b7          	lui	a5,0xc000
    802004c4:	4705                	li	a4,1
    802004c6:	d798                	sw	a4,40(a5)
    return *(volatile uint32 *)addr;
    802004c8:	0c002737          	lui	a4,0xc002
    802004cc:	08072783          	lw	a5,128(a4) # c002080 <TF_SIZE+0xc001f60>
    802004d0:	2781                	sext.w	a5,a5
    // 1. 设置 UART0 的优先级 > 0
    plic_write32(PLIC_BASE + 4 * UART0_IRQ, 1);

    // 2. 在 hart0 S-mode enable 寄存器里打开 UART0 对应的 bit
    uint32 en = plic_read32(HART0_SENABLE);
    en |= (1u << UART0_IRQ);
    802004d2:	4007e793          	ori	a5,a5,1024
    *(volatile uint32 *)addr = val;
    802004d6:	08f72023          	sw	a5,128(a4)
    802004da:	0c2017b7          	lui	a5,0xc201
    802004de:	0007a023          	sw	zero,0(a5) # c201000 <TF_SIZE+0xc200ee0>
    plic_write32(HART0_SENABLE, en);

    // 3. 把 S-mode threshold 设为 0（只要有优先级>0 的中断就能进来）
    plic_write32(HART0_STHRESHOLD, 0);
}
    802004e2:	6422                	ld	s0,8(sp)
    802004e4:	0141                	addi	sp,sp,16
    802004e6:	8082                	ret

00000000802004e8 <put_char>:

    return a0;
}

int put_char(char c)
{
    802004e8:	1141                	addi	sp,sp,-16
    802004ea:	e422                	sd	s0,8(sp)
    802004ec:	0800                	addi	s0,sp,16
    register uint64 a1 asm("a1") = arg1;
    802004ee:	4581                	li	a1,0
    register uint64 a2 asm("a2") = arg2;
    802004f0:	4601                	li	a2,0
    register uint64 a7 asm("a7") = which;
    802004f2:	4885                	li	a7,1
    asm volatile("ecall"
    802004f4:	00000073          	ecall
    return sbi_call(PUT_CHAR_MODE, (uint64)c, 0, 0);
}
    802004f8:	2501                	sext.w	a0,a0
    802004fa:	6422                	ld	s0,8(sp)
    802004fc:	0141                	addi	sp,sp,16
    802004fe:	8082                	ret

0000000080200500 <shutdown>:

int shutdown()
{
    80200500:	1141                	addi	sp,sp,-16
    80200502:	e406                	sd	ra,8(sp)
    80200504:	e022                	sd	s0,0(sp)
    80200506:	0800                	addi	s0,sp,16
    put_char('s');
    80200508:	07300513          	li	a0,115
    8020050c:	00000097          	auipc	ra,0x0
    80200510:	fdc080e7          	jalr	-36(ra) # 802004e8 <put_char>
    put_char('h');
    80200514:	06800513          	li	a0,104
    80200518:	00000097          	auipc	ra,0x0
    8020051c:	fd0080e7          	jalr	-48(ra) # 802004e8 <put_char>
    put_char('u');
    80200520:	07500513          	li	a0,117
    80200524:	00000097          	auipc	ra,0x0
    80200528:	fc4080e7          	jalr	-60(ra) # 802004e8 <put_char>
    put_char('t');
    8020052c:	07400513          	li	a0,116
    80200530:	00000097          	auipc	ra,0x0
    80200534:	fb8080e7          	jalr	-72(ra) # 802004e8 <put_char>
    put_char('d');
    80200538:	06400513          	li	a0,100
    8020053c:	00000097          	auipc	ra,0x0
    80200540:	fac080e7          	jalr	-84(ra) # 802004e8 <put_char>
    put_char('o');
    80200544:	06f00513          	li	a0,111
    80200548:	00000097          	auipc	ra,0x0
    8020054c:	fa0080e7          	jalr	-96(ra) # 802004e8 <put_char>
    put_char('w');
    80200550:	07700513          	li	a0,119
    80200554:	00000097          	auipc	ra,0x0
    80200558:	f94080e7          	jalr	-108(ra) # 802004e8 <put_char>
    put_char('n');
    8020055c:	06e00513          	li	a0,110
    80200560:	00000097          	auipc	ra,0x0
    80200564:	f88080e7          	jalr	-120(ra) # 802004e8 <put_char>
    put_char('\n');
    80200568:	4529                	li	a0,10
    8020056a:	00000097          	auipc	ra,0x0
    8020056e:	f7e080e7          	jalr	-130(ra) # 802004e8 <put_char>
    register uint64 a0 asm("a0") = arg0;
    80200572:	4501                	li	a0,0
    register uint64 a1 asm("a1") = arg1;
    80200574:	4581                	li	a1,0
    register uint64 a2 asm("a2") = arg2;
    80200576:	4601                	li	a2,0
    register uint64 a7 asm("a7") = which;
    80200578:	48a1                	li	a7,8
    asm volatile("ecall"
    8020057a:	00000073          	ecall
    return sbi_call(SHUTDOWN_MODE, 0, 0, 0);
}
    8020057e:	2501                	sext.w	a0,a0
    80200580:	60a2                	ld	ra,8(sp)
    80200582:	6402                	ld	s0,0(sp)
    80200584:	0141                	addi	sp,sp,16
    80200586:	8082                	ret

0000000080200588 <r_LSR>:

uint8 r_LSR(void)
{
    80200588:	1141                	addi	sp,sp,-16
    8020058a:	e422                	sd	s0,8(sp)
    8020058c:	0800                	addi	s0,sp,16
    return *(volatile uint8 *)(UART0_ADDRESS + UART_LSR);
    8020058e:	100007b7          	lui	a5,0x10000
    80200592:	0057c503          	lbu	a0,5(a5) # 10000005 <TF_SIZE+0xffffee5>
}
    80200596:	6422                	ld	s0,8(sp)
    80200598:	0141                	addi	sp,sp,16
    8020059a:	8082                	ret

000000008020059c <r_RHR>:

uint8 r_RHR(void)
{
    8020059c:	1141                	addi	sp,sp,-16
    8020059e:	e422                	sd	s0,8(sp)
    802005a0:	0800                	addi	s0,sp,16
    return *(volatile uint8 *)(UART0_ADDRESS + UART_RHR);
    802005a2:	100007b7          	lui	a5,0x10000
    802005a6:	0007c503          	lbu	a0,0(a5) # 10000000 <TF_SIZE+0xffffee0>
}
    802005aa:	6422                	ld	s0,8(sp)
    802005ac:	0141                	addi	sp,sp,16
    802005ae:	8082                	ret

00000000802005b0 <memset>:
#include "string.h"
#include "types.h"

void *memset(void *dst, int c, uint n)
{
    802005b0:	1141                	addi	sp,sp,-16
    802005b2:	e422                	sd	s0,8(sp)
    802005b4:	0800                	addi	s0,sp,16
    char *cdst = (char *)dst;
    int i;
    for (i = 0; i < n; i++)
    802005b6:	ce09                	beqz	a2,802005d0 <memset+0x20>
    802005b8:	87aa                	mv	a5,a0
    802005ba:	fff6071b          	addiw	a4,a2,-1
    802005be:	1702                	slli	a4,a4,0x20
    802005c0:	9301                	srli	a4,a4,0x20
    802005c2:	0705                	addi	a4,a4,1
    802005c4:	972a                	add	a4,a4,a0
    {
        cdst[i] = c;
    802005c6:	00b78023          	sb	a1,0(a5)
    802005ca:	0785                	addi	a5,a5,1
    for (i = 0; i < n; i++)
    802005cc:	fee79de3          	bne	a5,a4,802005c6 <memset+0x16>
    }
    return dst;
}
    802005d0:	6422                	ld	s0,8(sp)
    802005d2:	0141                	addi	sp,sp,16
    802005d4:	8082                	ret

00000000802005d6 <memcmp>:

int memcmp(const void *v1, const void *v2, uint n)
{
    802005d6:	1141                	addi	sp,sp,-16
    802005d8:	e422                	sd	s0,8(sp)
    802005da:	0800                	addi	s0,sp,16
    const uchar *s1, *s2;

    s1 = v1;
    s2 = v2;
    while (n-- > 0)
    802005dc:	ce15                	beqz	a2,80200618 <memcmp+0x42>
    802005de:	fff6069b          	addiw	a3,a2,-1
    {
        if (*s1 != *s2)
    802005e2:	00054783          	lbu	a5,0(a0)
    802005e6:	0005c703          	lbu	a4,0(a1)
    802005ea:	02e79063          	bne	a5,a4,8020060a <memcmp+0x34>
    802005ee:	1682                	slli	a3,a3,0x20
    802005f0:	9281                	srli	a3,a3,0x20
    802005f2:	0685                	addi	a3,a3,1
    802005f4:	96aa                	add	a3,a3,a0
            return *s1 - *s2;
        s1++, s2++;
    802005f6:	0505                	addi	a0,a0,1
    802005f8:	0585                	addi	a1,a1,1
    while (n-- > 0)
    802005fa:	00d50d63          	beq	a0,a3,80200614 <memcmp+0x3e>
        if (*s1 != *s2)
    802005fe:	00054783          	lbu	a5,0(a0)
    80200602:	0005c703          	lbu	a4,0(a1)
    80200606:	fee788e3          	beq	a5,a4,802005f6 <memcmp+0x20>
            return *s1 - *s2;
    8020060a:	40e7853b          	subw	a0,a5,a4
    }

    return 0;
}
    8020060e:	6422                	ld	s0,8(sp)
    80200610:	0141                	addi	sp,sp,16
    80200612:	8082                	ret
    return 0;
    80200614:	4501                	li	a0,0
    80200616:	bfe5                	j	8020060e <memcmp+0x38>
    80200618:	4501                	li	a0,0
    8020061a:	bfd5                	j	8020060e <memcmp+0x38>

000000008020061c <memmove>:

void *memmove(void *dst, const void *src, uint n)
{
    8020061c:	1141                	addi	sp,sp,-16
    8020061e:	e422                	sd	s0,8(sp)
    80200620:	0800                	addi	s0,sp,16
    const char *s;
    char *d;

    s = src;
    d = dst;
    if (s < d && s + n > d)
    80200622:	02a5e563          	bltu	a1,a0,8020064c <memmove+0x30>
        d += n;
        while (n-- > 0)
            *--d = *--s;
    }
    else
        while (n-- > 0)
    80200626:	fff6069b          	addiw	a3,a2,-1
    8020062a:	ce11                	beqz	a2,80200646 <memmove+0x2a>
    8020062c:	1682                	slli	a3,a3,0x20
    8020062e:	9281                	srli	a3,a3,0x20
    80200630:	0685                	addi	a3,a3,1
    80200632:	96ae                	add	a3,a3,a1
    80200634:	87aa                	mv	a5,a0
            *d++ = *s++;
    80200636:	0585                	addi	a1,a1,1
    80200638:	0785                	addi	a5,a5,1
    8020063a:	fff5c703          	lbu	a4,-1(a1)
    8020063e:	fee78fa3          	sb	a4,-1(a5)
        while (n-- > 0)
    80200642:	fed59ae3          	bne	a1,a3,80200636 <memmove+0x1a>

    return dst;
}
    80200646:	6422                	ld	s0,8(sp)
    80200648:	0141                	addi	sp,sp,16
    8020064a:	8082                	ret
    if (s < d && s + n > d)
    8020064c:	02061713          	slli	a4,a2,0x20
    80200650:	9301                	srli	a4,a4,0x20
    80200652:	00e587b3          	add	a5,a1,a4
    80200656:	fcf578e3          	bgeu	a0,a5,80200626 <memmove+0xa>
        d += n;
    8020065a:	972a                	add	a4,a4,a0
        while (n-- > 0)
    8020065c:	fff6069b          	addiw	a3,a2,-1
    80200660:	d27d                	beqz	a2,80200646 <memmove+0x2a>
    80200662:	02069613          	slli	a2,a3,0x20
    80200666:	9201                	srli	a2,a2,0x20
    80200668:	fff64613          	not	a2,a2
    8020066c:	963e                	add	a2,a2,a5
            *--d = *--s;
    8020066e:	17fd                	addi	a5,a5,-1
    80200670:	177d                	addi	a4,a4,-1
    80200672:	0007c683          	lbu	a3,0(a5)
    80200676:	00d70023          	sb	a3,0(a4)
        while (n-- > 0)
    8020067a:	fef61ae3          	bne	a2,a5,8020066e <memmove+0x52>
    8020067e:	b7e1                	j	80200646 <memmove+0x2a>

0000000080200680 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void *memcpy(void *dst, const void *src, uint n)
{
    80200680:	1141                	addi	sp,sp,-16
    80200682:	e406                	sd	ra,8(sp)
    80200684:	e022                	sd	s0,0(sp)
    80200686:	0800                	addi	s0,sp,16
    return memmove(dst, src, n);
    80200688:	00000097          	auipc	ra,0x0
    8020068c:	f94080e7          	jalr	-108(ra) # 8020061c <memmove>
}
    80200690:	60a2                	ld	ra,8(sp)
    80200692:	6402                	ld	s0,0(sp)
    80200694:	0141                	addi	sp,sp,16
    80200696:	8082                	ret

0000000080200698 <strncmp>:

int strncmp(const char *p, const char *q, uint n)
{
    80200698:	1141                	addi	sp,sp,-16
    8020069a:	e422                	sd	s0,8(sp)
    8020069c:	0800                	addi	s0,sp,16
    while (n > 0 && *p && *p == *q)
    8020069e:	c229                	beqz	a2,802006e0 <strncmp+0x48>
    802006a0:	00054783          	lbu	a5,0(a0)
    802006a4:	c795                	beqz	a5,802006d0 <strncmp+0x38>
    802006a6:	0005c703          	lbu	a4,0(a1)
    802006aa:	02f71363          	bne	a4,a5,802006d0 <strncmp+0x38>
    802006ae:	fff6071b          	addiw	a4,a2,-1
    802006b2:	1702                	slli	a4,a4,0x20
    802006b4:	9301                	srli	a4,a4,0x20
    802006b6:	0705                	addi	a4,a4,1
    802006b8:	972a                	add	a4,a4,a0
        n--, p++, q++;
    802006ba:	0505                	addi	a0,a0,1
    802006bc:	0585                	addi	a1,a1,1
    while (n > 0 && *p && *p == *q)
    802006be:	02e50363          	beq	a0,a4,802006e4 <strncmp+0x4c>
    802006c2:	00054783          	lbu	a5,0(a0)
    802006c6:	c789                	beqz	a5,802006d0 <strncmp+0x38>
    802006c8:	0005c683          	lbu	a3,0(a1)
    802006cc:	fef687e3          	beq	a3,a5,802006ba <strncmp+0x22>
    if (n == 0)
        return 0;
    return (uchar)*p - (uchar)*q;
    802006d0:	00054503          	lbu	a0,0(a0)
    802006d4:	0005c783          	lbu	a5,0(a1)
    802006d8:	9d1d                	subw	a0,a0,a5
}
    802006da:	6422                	ld	s0,8(sp)
    802006dc:	0141                	addi	sp,sp,16
    802006de:	8082                	ret
        return 0;
    802006e0:	4501                	li	a0,0
    802006e2:	bfe5                	j	802006da <strncmp+0x42>
    802006e4:	4501                	li	a0,0
    802006e6:	bfd5                	j	802006da <strncmp+0x42>

00000000802006e8 <strncpy>:

char *strncpy(char *s, const char *t, int n)
{
    802006e8:	1141                	addi	sp,sp,-16
    802006ea:	e422                	sd	s0,8(sp)
    802006ec:	0800                	addi	s0,sp,16
    char *os;

    os = s;
    while (n-- > 0 && (*s++ = *t++) != 0)
    802006ee:	872a                	mv	a4,a0
    802006f0:	a011                	j	802006f4 <strncpy+0xc>
    802006f2:	8642                	mv	a2,a6
    802006f4:	fff6081b          	addiw	a6,a2,-1
    802006f8:	00c05963          	blez	a2,8020070a <strncpy+0x22>
    802006fc:	0705                	addi	a4,a4,1
    802006fe:	0005c783          	lbu	a5,0(a1)
    80200702:	fef70fa3          	sb	a5,-1(a4)
    80200706:	0585                	addi	a1,a1,1
    80200708:	f7ed                	bnez	a5,802006f2 <strncpy+0xa>
        ;
    while (n-- > 0)
    8020070a:	86ba                	mv	a3,a4
    8020070c:	01005b63          	blez	a6,80200722 <strncpy+0x3a>
        *s++ = 0;
    80200710:	0685                	addi	a3,a3,1
    80200712:	fe068fa3          	sb	zero,-1(a3)
    80200716:	fff6c793          	not	a5,a3
    8020071a:	9fb9                	addw	a5,a5,a4
    while (n-- > 0)
    8020071c:	9fb1                	addw	a5,a5,a2
    8020071e:	fef049e3          	bgtz	a5,80200710 <strncpy+0x28>
    return os;
}
    80200722:	6422                	ld	s0,8(sp)
    80200724:	0141                	addi	sp,sp,16
    80200726:	8082                	ret

0000000080200728 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char *safestrcpy(char *s, const char *t, int n)
{
    80200728:	1141                	addi	sp,sp,-16
    8020072a:	e422                	sd	s0,8(sp)
    8020072c:	0800                	addi	s0,sp,16
    char *os;

    os = s;
    if (n <= 0)
    8020072e:	02c05363          	blez	a2,80200754 <safestrcpy+0x2c>
    80200732:	fff6069b          	addiw	a3,a2,-1
    80200736:	1682                	slli	a3,a3,0x20
    80200738:	9281                	srli	a3,a3,0x20
    8020073a:	96ae                	add	a3,a3,a1
    8020073c:	87aa                	mv	a5,a0
        return os;
    while (--n > 0 && (*s++ = *t++) != 0)
    8020073e:	00d58963          	beq	a1,a3,80200750 <safestrcpy+0x28>
    80200742:	0585                	addi	a1,a1,1
    80200744:	0785                	addi	a5,a5,1
    80200746:	fff5c703          	lbu	a4,-1(a1)
    8020074a:	fee78fa3          	sb	a4,-1(a5)
    8020074e:	fb65                	bnez	a4,8020073e <safestrcpy+0x16>
        ;
    *s = 0;
    80200750:	00078023          	sb	zero,0(a5)
    return os;
}
    80200754:	6422                	ld	s0,8(sp)
    80200756:	0141                	addi	sp,sp,16
    80200758:	8082                	ret

000000008020075a <strlen>:

int strlen(const char *s)
{
    8020075a:	1141                	addi	sp,sp,-16
    8020075c:	e422                	sd	s0,8(sp)
    8020075e:	0800                	addi	s0,sp,16
    int n;

    for (n = 0; s[n]; n++)
    80200760:	00054783          	lbu	a5,0(a0)
    80200764:	cf91                	beqz	a5,80200780 <strlen+0x26>
    80200766:	0505                	addi	a0,a0,1
    80200768:	87aa                	mv	a5,a0
    8020076a:	4685                	li	a3,1
    8020076c:	9e89                	subw	a3,a3,a0
        ;
    8020076e:	00f6853b          	addw	a0,a3,a5
    80200772:	0785                	addi	a5,a5,1
    for (n = 0; s[n]; n++)
    80200774:	fff7c703          	lbu	a4,-1(a5)
    80200778:	fb7d                	bnez	a4,8020076e <strlen+0x14>
    return n;
}
    8020077a:	6422                	ld	s0,8(sp)
    8020077c:	0141                	addi	sp,sp,16
    8020077e:	8082                	ret
    for (n = 0; s[n]; n++)
    80200780:	4501                	li	a0,0
    80200782:	bfe5                	j	8020077a <strlen+0x20>

0000000080200784 <dummy>:

void dummy(int _, ...)
{
    80200784:	715d                	addi	sp,sp,-80
    80200786:	e422                	sd	s0,8(sp)
    80200788:	0800                	addi	s0,sp,16
    8020078a:	e40c                	sd	a1,8(s0)
    8020078c:	e810                	sd	a2,16(s0)
    8020078e:	ec14                	sd	a3,24(s0)
    80200790:	f018                	sd	a4,32(s0)
    80200792:	f41c                	sd	a5,40(s0)
    80200794:	03043823          	sd	a6,48(s0)
    80200798:	03143c23          	sd	a7,56(s0)
    8020079c:	6422                	ld	s0,8(sp)
    8020079e:	6161                	addi	sp,sp,80
    802007a0:	8082                	ret

00000000802007a2 <sys_write>:
#include "syscall_ids.h"
#include "sbi.h"

uint64 sys_write(int fd, const char *str, uint len)
{
    if (fd != 1 || str == 0)
    802007a2:	4785                	li	a5,1
    802007a4:	04f51763          	bne	a0,a5,802007f2 <sys_write+0x50>
    802007a8:	c5b9                	beqz	a1,802007f6 <sys_write+0x54>
{
    802007aa:	7179                	addi	sp,sp,-48
    802007ac:	f406                	sd	ra,40(sp)
    802007ae:	f022                	sd	s0,32(sp)
    802007b0:	ec26                	sd	s1,24(sp)
    802007b2:	e84a                	sd	s2,16(sp)
    802007b4:	e44e                	sd	s3,8(sp)
    802007b6:	1800                	addi	s0,sp,48
    802007b8:	89b2                	mv	s3,a2
        return -1;
    for (uint i = 0; i < len; ++i)
    802007ba:	c215                	beqz	a2,802007de <sys_write+0x3c>
    802007bc:	84ae                	mv	s1,a1
    802007be:	fff6091b          	addiw	s2,a2,-1
    802007c2:	1902                	slli	s2,s2,0x20
    802007c4:	02095913          	srli	s2,s2,0x20
    802007c8:	0905                	addi	s2,s2,1
    802007ca:	992e                	add	s2,s2,a1
        put_char(str[i]);
    802007cc:	0004c503          	lbu	a0,0(s1)
    802007d0:	00000097          	auipc	ra,0x0
    802007d4:	d18080e7          	jalr	-744(ra) # 802004e8 <put_char>
    802007d8:	0485                	addi	s1,s1,1
    for (uint i = 0; i < len; ++i)
    802007da:	ff2499e3          	bne	s1,s2,802007cc <sys_write+0x2a>
    return len;
    802007de:	02099513          	slli	a0,s3,0x20
    802007e2:	9101                	srli	a0,a0,0x20
}
    802007e4:	70a2                	ld	ra,40(sp)
    802007e6:	7402                	ld	s0,32(sp)
    802007e8:	64e2                	ld	s1,24(sp)
    802007ea:	6942                	ld	s2,16(sp)
    802007ec:	69a2                	ld	s3,8(sp)
    802007ee:	6145                	addi	sp,sp,48
    802007f0:	8082                	ret
        return -1;
    802007f2:	557d                	li	a0,-1
    802007f4:	8082                	ret
    802007f6:	557d                	li	a0,-1
}
    802007f8:	8082                	ret

00000000802007fa <sys_exit>:

__attribute__((noreturn)) void sys_exit(int code)
{
    802007fa:	1141                	addi	sp,sp,-16
    802007fc:	e406                	sd	ra,8(sp)
    802007fe:	e022                	sd	s0,0(sp)
    80200800:	0800                	addi	s0,sp,16
    shutdown();
    80200802:	00000097          	auipc	ra,0x0
    80200806:	cfe080e7          	jalr	-770(ra) # 80200500 <shutdown>

000000008020080a <syscall>:
}

extern char trap_page[];

void syscall()
{
    8020080a:	1141                	addi	sp,sp,-16
    8020080c:	e406                	sd	ra,8(sp)
    8020080e:	e022                	sd	s0,0(sp)
    80200810:	0800                	addi	s0,sp,16
    struct trapframe *trapframe = (struct trapframe *)trap_page;
    int id = trapframe->a7, ret;
    80200812:	00013697          	auipc	a3,0x13
    80200816:	7ee68693          	addi	a3,a3,2030 # 80214000 <trap_page>
    8020081a:	0a86c783          	lbu	a5,168(a3)
    8020081e:	0a96c703          	lbu	a4,169(a3)
    80200822:	0722                	slli	a4,a4,0x8
    80200824:	8f5d                	or	a4,a4,a5
    80200826:	0aa6c783          	lbu	a5,170(a3)
    8020082a:	07c2                	slli	a5,a5,0x10
    8020082c:	8f5d                	or	a4,a4,a5
    8020082e:	0ab6c783          	lbu	a5,171(a3)
    80200832:	07e2                	slli	a5,a5,0x18
    80200834:	8fd9                	or	a5,a5,a4
    80200836:	2781                	sext.w	a5,a5
    uint64 args[6] = {trapframe->a0, trapframe->a1, trapframe->a2,
                      trapframe->a3, trapframe->a4, trapframe->a5};
    switch (id)
    80200838:	04000713          	li	a4,64
    8020083c:	04e78763          	beq	a5,a4,8020088a <syscall+0x80>
    80200840:	05d00713          	li	a4,93
    80200844:	0ce78963          	beq	a5,a4,80200916 <syscall+0x10c>
        break;
    case SYS_exit:
        sys_exit(args[0]);
        // 不返回
    default:
        ret = -1;
    80200848:	557d                	li	a0,-1
        break;
    }
    trapframe->a0 = ret;
    8020084a:	00013797          	auipc	a5,0x13
    8020084e:	7b678793          	addi	a5,a5,1974 # 80214000 <trap_page>
    80200852:	06a78823          	sb	a0,112(a5)
    80200856:	00855713          	srli	a4,a0,0x8
    8020085a:	06e788a3          	sb	a4,113(a5)
    8020085e:	01055713          	srli	a4,a0,0x10
    80200862:	06e78923          	sb	a4,114(a5)
    80200866:	0185571b          	srliw	a4,a0,0x18
    8020086a:	06e789a3          	sb	a4,115(a5)
    8020086e:	03855713          	srli	a4,a0,0x38
    80200872:	06e78a23          	sb	a4,116(a5)
    80200876:	06e78aa3          	sb	a4,117(a5)
    8020087a:	06e78b23          	sb	a4,118(a5)
    8020087e:	06e78ba3          	sb	a4,119(a5)
    80200882:	60a2                	ld	ra,8(sp)
    80200884:	6402                	ld	s0,0(sp)
    80200886:	0141                	addi	sp,sp,16
    80200888:	8082                	ret
    uint64 args[6] = {trapframe->a0, trapframe->a1, trapframe->a2,
    8020088a:	00013797          	auipc	a5,0x13
    8020088e:	77678793          	addi	a5,a5,1910 # 80214000 <trap_page>
    80200892:	0807c603          	lbu	a2,128(a5)
    80200896:	0817c703          	lbu	a4,129(a5)
    8020089a:	0722                	slli	a4,a4,0x8
    8020089c:	8f51                	or	a4,a4,a2
    8020089e:	0827c603          	lbu	a2,130(a5)
    802008a2:	0642                	slli	a2,a2,0x10
    802008a4:	8f51                	or	a4,a4,a2
    802008a6:	0837c603          	lbu	a2,131(a5)
    802008aa:	0662                	slli	a2,a2,0x18
    802008ac:	8e59                	or	a2,a2,a4
    802008ae:	0787c703          	lbu	a4,120(a5)
    802008b2:	0797c583          	lbu	a1,121(a5)
    802008b6:	05a2                	slli	a1,a1,0x8
    802008b8:	8dd9                	or	a1,a1,a4
    802008ba:	07a7c703          	lbu	a4,122(a5)
    802008be:	0742                	slli	a4,a4,0x10
    802008c0:	8f4d                	or	a4,a4,a1
    802008c2:	07b7c583          	lbu	a1,123(a5)
    802008c6:	05e2                	slli	a1,a1,0x18
    802008c8:	8dd9                	or	a1,a1,a4
    802008ca:	07c7c703          	lbu	a4,124(a5)
    802008ce:	1702                	slli	a4,a4,0x20
    802008d0:	8f4d                	or	a4,a4,a1
    802008d2:	07d7c583          	lbu	a1,125(a5)
    802008d6:	15a2                	slli	a1,a1,0x28
    802008d8:	8dd9                	or	a1,a1,a4
    802008da:	07e7c703          	lbu	a4,126(a5)
    802008de:	1742                	slli	a4,a4,0x30
    802008e0:	8f4d                	or	a4,a4,a1
    802008e2:	07f7c583          	lbu	a1,127(a5)
    802008e6:	15e2                	slli	a1,a1,0x38
    802008e8:	0707c503          	lbu	a0,112(a5)
    802008ec:	0717c683          	lbu	a3,113(a5)
    802008f0:	06a2                	slli	a3,a3,0x8
    802008f2:	8ec9                	or	a3,a3,a0
    802008f4:	0727c503          	lbu	a0,114(a5)
    802008f8:	0542                	slli	a0,a0,0x10
    802008fa:	8ec9                	or	a3,a3,a0
    802008fc:	0737c503          	lbu	a0,115(a5)
    80200900:	0562                	slli	a0,a0,0x18
    80200902:	8d55                	or	a0,a0,a3
        ret = sys_write(args[0], (const char *)args[1], args[2]);
    80200904:	2601                	sext.w	a2,a2
    80200906:	8dd9                	or	a1,a1,a4
    80200908:	2501                	sext.w	a0,a0
    8020090a:	00000097          	auipc	ra,0x0
    8020090e:	e98080e7          	jalr	-360(ra) # 802007a2 <sys_write>
    80200912:	2501                	sext.w	a0,a0
        break;
    80200914:	bf1d                	j	8020084a <syscall+0x40>
    shutdown();
    80200916:	00000097          	auipc	ra,0x0
    8020091a:	bea080e7          	jalr	-1046(ra) # 80200500 <shutdown>

000000008020091e <init_timer>:
#include "sbi.h"

const uint64 interval = 1000000; // 定时器间隔时间，可以根据需要调整

void init_timer(uint64 time)
{
    8020091e:	1101                	addi	sp,sp,-32
    80200920:	ec06                	sd	ra,24(sp)
    80200922:	e822                	sd	s0,16(sp)
    80200924:	e426                	sd	s1,8(sp)
    80200926:	1000                	addi	s0,sp,32
    80200928:	84aa                	mv	s1,a0
    printf("Timer initialized.\n");
    8020092a:	00001517          	auipc	a0,0x1
    8020092e:	9d650513          	addi	a0,a0,-1578 # 80201300 <e_text+0x300>
    80200932:	00000097          	auipc	ra,0x0
    80200936:	a9a080e7          	jalr	-1382(ra) # 802003cc <printf>
    t.time = time;
    8020093a:	00015797          	auipc	a5,0x15
    8020093e:	6c97b323          	sd	s1,1734(a5) # 80216000 <t>

// machine-mode cycle counter
static inline uint64 r_time()
{
    uint64 x;
    asm volatile("csrr %0, time" : "=r"(x));
    80200942:	c0102573          	rdtime	a0
    uint64 now = r_time();
    w_time(now + interval); // 你已经实现的 SBI_SET_TIMER
    80200946:	000f47b7          	lui	a5,0xf4
    8020094a:	24078793          	addi	a5,a5,576 # f4240 <TF_SIZE+0xf4120>
    8020094e:	953e                	add	a0,a0,a5

static inline void w_time(uint64 x)
{
    // 通过 SBI set_timer 调用设置下一次时钟中断，而不是非法写 time CSR
    register uint64 a0 asm("a0") = x; // stime_value
    register uint64 a7 asm("a7") = 0; // SBI legacy set_timer 扩展号为 0
    80200950:	4881                	li	a7,0
    asm volatile("ecall"
    80200952:	00000073          	ecall
}
    80200956:	60e2                	ld	ra,24(sp)
    80200958:	6442                	ld	s0,16(sp)
    8020095a:	64a2                	ld	s1,8(sp)
    8020095c:	6105                	addi	sp,sp,32
    8020095e:	8082                	ret

0000000080200960 <set_timer_value>:

void set_timer_value(uint64 time)
{
    80200960:	1141                	addi	sp,sp,-16
    80200962:	e422                	sd	s0,8(sp)
    80200964:	0800                	addi	s0,sp,16
    t.time = time;
    80200966:	00015797          	auipc	a5,0x15
    8020096a:	68a7bd23          	sd	a0,1690(a5) # 80216000 <t>
    register uint64 a7 asm("a7") = 0; // SBI legacy set_timer 扩展号为 0
    8020096e:	4881                	li	a7,0
    asm volatile("ecall"
    80200970:	00000073          	ecall
    w_time(time); // 你已经实现的 SBI_SET_TIMER
}
    80200974:	6422                	ld	s0,8(sp)
    80200976:	0141                	addi	sp,sp,16
    80200978:	8082                	ret

000000008020097a <get_timer_value>:

uint64 get_timer_value()
{
    8020097a:	1141                	addi	sp,sp,-16
    8020097c:	e422                	sd	s0,8(sp)
    8020097e:	0800                	addi	s0,sp,16
    asm volatile("csrr %0, time" : "=r"(x));
    80200980:	c0102573          	rdtime	a0
    t.time = r_time(); // 读取当前时间（可选，根据需要使用）
    80200984:	00015797          	auipc	a5,0x15
    80200988:	66a7be23          	sd	a0,1660(a5) # 80216000 <t>
    return t.time;
}
    8020098c:	6422                	ld	s0,8(sp)
    8020098e:	0141                	addi	sp,sp,16
    80200990:	8082                	ret

0000000080200992 <timer_trap>:

void timer_trap()
{
    80200992:	1141                	addi	sp,sp,-16
    80200994:	e406                	sd	ra,8(sp)
    80200996:	e022                	sd	s0,0(sp)
    80200998:	0800                	addi	s0,sp,16
    8020099a:	c01025f3          	rdtime	a1
    uint64 now = r_time();
    w_time(now + interval);
    8020099e:	000f4537          	lui	a0,0xf4
    802009a2:	24050513          	addi	a0,a0,576 # f4240 <TF_SIZE+0xf4120>
    802009a6:	952e                	add	a0,a0,a1
    register uint64 a7 asm("a7") = 0; // SBI legacy set_timer 扩展号为 0
    802009a8:	4881                	li	a7,0
    asm volatile("ecall"
    802009aa:	00000073          	ecall

    printf("Timer Interrupt: %d\n", now);
    802009ae:	00001517          	auipc	a0,0x1
    802009b2:	96a50513          	addi	a0,a0,-1686 # 80201318 <e_text+0x318>
    802009b6:	00000097          	auipc	ra,0x0
    802009ba:	a16080e7          	jalr	-1514(ra) # 802003cc <printf>
    802009be:	60a2                	ld	ra,8(sp)
    802009c0:	6402                	ld	s0,0(sp)
    802009c2:	0141                	addi	sp,sp,16
    802009c4:	8082                	ret

00000000802009c6 <trap_init>:
#include "user.h"

extern void user_save(void);

void trap_init()
{
    802009c6:	1141                	addi	sp,sp,-16
    802009c8:	e422                	sd	s0,8(sp)
    802009ca:	0800                	addi	s0,sp,16
    asm volatile("csrw stvec, %0" : : "r"(x));
    802009cc:	00000797          	auipc	a5,0x0
    802009d0:	25878793          	addi	a5,a5,600 # 80200c24 <user_save>
    802009d4:	10579073          	csrw	stvec,a5

    //uart_enable_rx_interrupt();
    //plic_enable_uart0();
    //w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    //w_sstatus(SSTATUS_SIE); // 全局使能中断
}
    802009d8:	6422                	ld	s0,8(sp)
    802009da:	0141                	addi	sp,sp,16
    802009dc:	8082                	ret

00000000802009de <trap_handler>:
    asm volatile("csrr %0, scause" : "=r"(x));
    802009de:	142027f3          	csrr	a5,scause
    // printf("scause=%d\n", scause);

    int is_interrupt = (scause >> 63) & 1;
    uint64 code = scause & 0xfff; // 取低 12 位原因码

    if (is_interrupt)
    802009e2:	0407d463          	bgez	a5,80200a2a <trap_handler+0x4c>
{
    802009e6:	1141                	addi	sp,sp,-16
    802009e8:	e406                	sd	ra,8(sp)
    802009ea:	e022                	sd	s0,0(sp)
    802009ec:	0800                	addi	s0,sp,16
    uint64 code = scause & 0xfff; // 取低 12 位原因码
    802009ee:	17d2                	slli	a5,a5,0x34
    802009f0:	93d1                	srli	a5,a5,0x34
    {
        // 这是“中断”
        switch (code)
    802009f2:	4715                	li	a4,5
    802009f4:	02e78163          	beq	a5,a4,80200a16 <trap_handler+0x38>
    802009f8:	4725                	li	a4,9
    802009fa:	02e78363          	beq	a5,a4,80200a20 <trap_handler+0x42>
    802009fe:	4705                	li	a4,1
    80200a00:	00e78663          	beq	a5,a4,80200a0c <trap_handler+0x2e>
        default:
            // 未知异常，可以打印 scause/stval/sepc 调试
            break;
        }
    }
}
    80200a04:	60a2                	ld	ra,8(sp)
    80200a06:	6402                	ld	s0,0(sp)
    80200a08:	0141                	addi	sp,sp,16
    80200a0a:	8082                	ret
            keyboard_trap();
    80200a0c:	00000097          	auipc	ra,0x0
    80200a10:	a26080e7          	jalr	-1498(ra) # 80200432 <keyboard_trap>
            break;
    80200a14:	bfc5                	j	80200a04 <trap_handler+0x26>
            timer_trap();
    80200a16:	00000097          	auipc	ra,0x0
    80200a1a:	f7c080e7          	jalr	-132(ra) # 80200992 <timer_trap>
            break;
    80200a1e:	b7dd                	j	80200a04 <trap_handler+0x26>
            keyboard_trap();
    80200a20:	00000097          	auipc	ra,0x0
    80200a24:	a12080e7          	jalr	-1518(ra) # 80200432 <keyboard_trap>
}
    80200a28:	bff1                	j	80200a04 <trap_handler+0x26>
    80200a2a:	8082                	ret

0000000080200a2c <usertrapret>:
    printf("ALL DONE\n");
    shutdown();
}

void usertrapret(struct trapframe *trapframe, uint64 kstack)
{
    80200a2c:	1141                	addi	sp,sp,-16
    80200a2e:	e406                	sd	ra,8(sp)
    80200a30:	e022                	sd	s0,0(sp)
    80200a32:	0800                	addi	s0,sp,16
    asm volatile("csrr %0, satp" : "=r"(x));
    80200a34:	18002773          	csrr	a4,satp
    trapframe->kernel_satp = r_satp();      // kernel page table
    80200a38:	e118                	sd	a4,0(a0)
    trapframe->kernel_sp = kstack + PGSIZE; // process's kernel stack
    80200a3a:	6705                	lui	a4,0x1
    80200a3c:	95ba                	add	a1,a1,a4
    80200a3e:	e50c                	sd	a1,8(a0)
    trapframe->kernel_trap = (uint64)usertrap;
    80200a40:	00000717          	auipc	a4,0x0
    80200a44:	03470713          	addi	a4,a4,52 # 80200a74 <usertrap>
    80200a48:	e918                	sd	a4,16(a0)
// read and write tp, the thread pointer, which holds
// this core's hartid (core number), the index into cpus[].
static inline uint64 r_tp()
{
    uint64 x;
    asm volatile("mv %0, tp" : "=r"(x));
    80200a4a:	8712                	mv	a4,tp
    trapframe->kernel_hartid = r_tp(); // hartid for cpuid()
    80200a4c:	f118                	sd	a4,32(a0)
    asm volatile("csrw sepc, %0" : : "r"(x));
    80200a4e:	6d1c                	ld	a5,24(a0)
    80200a50:	14179073          	csrw	sepc,a5
    asm volatile("csrr %0, sstatus" : "=r"(x));
    80200a54:	100027f3          	csrr	a5,sstatus
    // set up the registers that trampoline.S's sret will use
    // to get to user space.

    // set S Previous Privilege mode to User.
    uint64 x = r_sstatus();
    x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80200a58:	eff7f793          	andi	a5,a5,-257
    x |= SSTATUS_SPIE; // enable interrupts in user mode
    80200a5c:	0207e793          	ori	a5,a5,32
    asm volatile("csrw sstatus, %0" : : "r"(x));
    80200a60:	10079073          	csrw	sstatus,a5
    w_sstatus(x);

    // tell trampoline.S the user page table to switch to.
    // uint64 satp = MAKE_SATP(p->pagetable);
    user_load((uint64)trapframe);
    80200a64:	00000097          	auipc	ra,0x0
    80200a68:	250080e7          	jalr	592(ra) # 80200cb4 <user_load>
    80200a6c:	60a2                	ld	ra,8(sp)
    80200a6e:	6402                	ld	s0,0(sp)
    80200a70:	0141                	addi	sp,sp,16
    80200a72:	8082                	ret

0000000080200a74 <usertrap>:
{
    80200a74:	1101                	addi	sp,sp,-32
    80200a76:	ec06                	sd	ra,24(sp)
    80200a78:	e822                	sd	s0,16(sp)
    80200a7a:	e426                	sd	s1,8(sp)
    80200a7c:	1000                	addi	s0,sp,32
    80200a7e:	84aa                	mv	s1,a0
    asm volatile("csrr %0, sstatus" : "=r"(x));
    80200a80:	100027f3          	csrr	a5,sstatus
    if ((r_sstatus() & SSTATUS_SPP) != 0)
    80200a84:	1007f793          	andi	a5,a5,256
    80200a88:	e39d                	bnez	a5,80200aae <usertrap+0x3a>
    asm volatile("csrr %0, scause" : "=r"(x));
    80200a8a:	142025f3          	csrr	a1,scause
    if (cause == UserEnvCall)
    80200a8e:	47a1                	li	a5,8
    80200a90:	02f58863          	beq	a1,a5,80200ac0 <usertrap+0x4c>
    switch (cause)
    80200a94:	47bd                	li	a5,15
    80200a96:	0ab7e863          	bltu	a5,a1,80200b46 <usertrap+0xd2>
    80200a9a:	00259713          	slli	a4,a1,0x2
    80200a9e:	00001697          	auipc	a3,0x1
    80200aa2:	89268693          	addi	a3,a3,-1902 # 80201330 <e_text+0x330>
    80200aa6:	9736                	add	a4,a4,a3
    80200aa8:	431c                	lw	a5,0(a4)
    80200aaa:	97b6                	add	a5,a5,a3
    80200aac:	8782                	jr	a5
        printf("usertrap: not from user mode");
    80200aae:	00001517          	auipc	a0,0x1
    80200ab2:	8c250513          	addi	a0,a0,-1854 # 80201370 <e_text+0x370>
    80200ab6:	00000097          	auipc	ra,0x0
    80200aba:	916080e7          	jalr	-1770(ra) # 802003cc <printf>
    80200abe:	b7f1                	j	80200a8a <usertrap+0x16>
        trapframe->epc += 4;
    80200ac0:	6c9c                	ld	a5,24(s1)
    80200ac2:	0791                	addi	a5,a5,4
    80200ac4:	ec9c                	sd	a5,24(s1)
        syscall();
    80200ac6:	00000097          	auipc	ra,0x0
    80200aca:	d44080e7          	jalr	-700(ra) # 8020080a <syscall>
        usertrapret(trapframe, (uint64)boot_stack_top);
    80200ace:	00013597          	auipc	a1,0x13
    80200ad2:	53258593          	addi	a1,a1,1330 # 80214000 <trap_page>
    80200ad6:	8526                	mv	a0,s1
    80200ad8:	00000097          	auipc	ra,0x0
    80200adc:	f54080e7          	jalr	-172(ra) # 80200a2c <usertrapret>
        return;
    80200ae0:	a0a1                	j	80200b28 <usertrap+0xb4>
    asm volatile("csrr %0, stval" : "=r"(x));
    80200ae2:	14302673          	csrr	a2,stval
        printf("%d in application, bad addr = %p, bad instruction = %p, core "
    80200ae6:	6c94                	ld	a3,24(s1)
    80200ae8:	00001517          	auipc	a0,0x1
    80200aec:	8a850513          	addi	a0,a0,-1880 # 80201390 <e_text+0x390>
    80200af0:	00000097          	auipc	ra,0x0
    80200af4:	8dc080e7          	jalr	-1828(ra) # 802003cc <printf>
    printf("switch to next app");
    80200af8:	00001517          	auipc	a0,0x1
    80200afc:	94850513          	addi	a0,a0,-1720 # 80201440 <e_text+0x440>
    80200b00:	00000097          	auipc	ra,0x0
    80200b04:	8cc080e7          	jalr	-1844(ra) # 802003cc <printf>
    user_app_run();
    80200b08:	00000097          	auipc	ra,0x0
    80200b0c:	0b0080e7          	jalr	176(ra) # 80200bb8 <user_app_run>
    printf("ALL DONE\n");
    80200b10:	00001517          	auipc	a0,0x1
    80200b14:	94850513          	addi	a0,a0,-1720 # 80201458 <e_text+0x458>
    80200b18:	00000097          	auipc	ra,0x0
    80200b1c:	8b4080e7          	jalr	-1868(ra) # 802003cc <printf>
    shutdown();
    80200b20:	00000097          	auipc	ra,0x0
    80200b24:	9e0080e7          	jalr	-1568(ra) # 80200500 <shutdown>
}
    80200b28:	60e2                	ld	ra,24(sp)
    80200b2a:	6442                	ld	s0,16(sp)
    80200b2c:	64a2                	ld	s1,8(sp)
    80200b2e:	6105                	addi	sp,sp,32
    80200b30:	8082                	ret
        printf("IllegalInstruction in application, epc = %p, core dumped.",
    80200b32:	6c8c                	ld	a1,24(s1)
    80200b34:	00001517          	auipc	a0,0x1
    80200b38:	8a450513          	addi	a0,a0,-1884 # 802013d8 <e_text+0x3d8>
    80200b3c:	00000097          	auipc	ra,0x0
    80200b40:	890080e7          	jalr	-1904(ra) # 802003cc <printf>
        break;
    80200b44:	bf55                	j	80200af8 <usertrap+0x84>
    asm volatile("csrr %0, scause" : "=r"(x));
    80200b46:	142025f3          	csrr	a1,scause
    asm volatile("csrr %0, stval" : "=r"(x));
    80200b4a:	14302673          	csrr	a2,stval
    asm volatile("csrr %0, sepc" : "=r"(x));
    80200b4e:	141026f3          	csrr	a3,sepc
        printf("unknown trap: %p, stval = %p sepc = %p", r_scause(),
    80200b52:	00001517          	auipc	a0,0x1
    80200b56:	8c650513          	addi	a0,a0,-1850 # 80201418 <e_text+0x418>
    80200b5a:	00000097          	auipc	ra,0x0
    80200b5e:	872080e7          	jalr	-1934(ra) # 802003cc <printf>
        break;
    80200b62:	bf59                	j	80200af8 <usertrap+0x84>

0000000080200b64 <user_app_load>:
extern char boot_stack_top[];

__attribute__((aligned(4096))) char user_stack[0x1000];
__attribute__((aligned(4096))) char trap_page[0x1000];

int user_app_load(uint64* info){
    80200b64:	7179                	addi	sp,sp,-48
    80200b66:	f406                	sd	ra,40(sp)
    80200b68:	f022                	sd	s0,32(sp)
    80200b6a:	ec26                	sd	s1,24(sp)
    80200b6c:	e84a                	sd	s2,16(sp)
    80200b6e:	e44e                	sd	s3,8(sp)
    80200b70:	e052                	sd	s4,0(sp)
    80200b72:	1800                	addi	s0,sp,48
    uint64 start=info[1];
    80200b74:	00853983          	ld	s3,8(a0)
    uint64 end=info[2];
    
    uint64 length=end-start;
    80200b78:	6904                	ld	s1,16(a0)
    80200b7a:	413484b3          	sub	s1,s1,s3

    memset((void*)BASE_ADDRESS,0,length);
    80200b7e:	00048a1b          	sext.w	s4,s1
    80200b82:	8652                	mv	a2,s4
    80200b84:	4581                	li	a1,0
    80200b86:	20100913          	li	s2,513
    80200b8a:	01691513          	slli	a0,s2,0x16
    80200b8e:	00000097          	auipc	ra,0x0
    80200b92:	a22080e7          	jalr	-1502(ra) # 802005b0 <memset>
    memmove((void*)BASE_ADDRESS,(void*)start,length);
    80200b96:	8652                	mv	a2,s4
    80200b98:	85ce                	mv	a1,s3
    80200b9a:	01691513          	slli	a0,s2,0x16
    80200b9e:	00000097          	auipc	ra,0x0
    80200ba2:	a7e080e7          	jalr	-1410(ra) # 8020061c <memmove>

    return length;
}
    80200ba6:	8552                	mv	a0,s4
    80200ba8:	70a2                	ld	ra,40(sp)
    80200baa:	7402                	ld	s0,32(sp)
    80200bac:	64e2                	ld	s1,24(sp)
    80200bae:	6942                	ld	s2,16(sp)
    80200bb0:	69a2                	ld	s3,8(sp)
    80200bb2:	6a02                	ld	s4,0(sp)
    80200bb4:	6145                	addi	sp,sp,48
    80200bb6:	8082                	ret

0000000080200bb8 <user_app_run>:

void user_app_run(){
    80200bb8:	1141                	addi	sp,sp,-16
    80200bba:	e406                	sd	ra,8(sp)
    80200bbc:	e022                	sd	s0,0(sp)
    80200bbe:	0800                	addi	s0,sp,16
    //app_info_ptr=(uint64*)_app_num;

    //printf("user app start\n");

    struct trapframe *tf = (struct trapframe *)trap_page;
    user_app_load((uint64 *)_app_num);
    80200bc0:	00001517          	auipc	a0,0x1
    80200bc4:	44050513          	addi	a0,a0,1088 # 80202000 <_app_num>
    80200bc8:	00000097          	auipc	ra,0x0
    80200bcc:	f9c080e7          	jalr	-100(ra) # 80200b64 <user_app_load>

    memset(tf,0,4096);
    80200bd0:	6605                	lui	a2,0x1
    80200bd2:	4581                	li	a1,0
    80200bd4:	00013517          	auipc	a0,0x13
    80200bd8:	42c50513          	addi	a0,a0,1068 # 80214000 <trap_page>
    80200bdc:	00000097          	auipc	ra,0x0
    80200be0:	9d4080e7          	jalr	-1580(ra) # 802005b0 <memset>
    tf->epc = BASE_ADDRESS;
    80200be4:	00013517          	auipc	a0,0x13
    80200be8:	41c50513          	addi	a0,a0,1052 # 80214000 <trap_page>
    80200bec:	20100793          	li	a5,513
    80200bf0:	07da                	slli	a5,a5,0x16
    80200bf2:	ed1c                	sd	a5,24(a0)
    tf->sp = (uint64)user_stack + 0x1000;
    80200bf4:	00015797          	auipc	a5,0x15
    80200bf8:	40c78793          	addi	a5,a5,1036 # 80216000 <t>
    80200bfc:	f91c                	sd	a5,48(a0)

    usertrapret(tf, (uint64)boot_stack_top);
    80200bfe:	00013597          	auipc	a1,0x13
    80200c02:	40258593          	addi	a1,a1,1026 # 80214000 <trap_page>
    80200c06:	00000097          	auipc	ra,0x0
    80200c0a:	e26080e7          	jalr	-474(ra) # 80200a2c <usertrapret>
    80200c0e:	60a2                	ld	ra,8(sp)
    80200c10:	6402                	ld	s0,0(sp)
    80200c12:	0141                	addi	sp,sp,16
    80200c14:	8082                	ret
	...

0000000080200c24 <user_save>:
    .equ TF_SIZE,(8*36)

    .globl user_save
    .align 2
user_save:
    csrrw a0, sscratch, a0
    80200c24:	14051573          	csrrw	a0,sscratch,a0

    sd ra, tf_ra(a0)
    80200c28:	02153423          	sd	ra,40(a0)
    sd sp, tf_sp(a0)
    80200c2c:	02253823          	sd	sp,48(a0)
    sd gp, tf_gp(a0)
    80200c30:	02353c23          	sd	gp,56(a0)
    sd tp, tf_tp(a0)
    80200c34:	04453023          	sd	tp,64(a0)
    sd t0, tf_t0(a0)
    80200c38:	04553423          	sd	t0,72(a0)
    sd t1, tf_t1(a0)
    80200c3c:	04653823          	sd	t1,80(a0)
    sd t2, tf_t2(a0)
    80200c40:	04753c23          	sd	t2,88(a0)
    sd s0, tf_s0(a0)
    80200c44:	f120                	sd	s0,96(a0)
    sd s1, tf_s1(a0)
    80200c46:	f524                	sd	s1,104(a0)
    sd a1, tf_a1(a0)
    80200c48:	fd2c                	sd	a1,120(a0)
    sd a2, tf_a2(a0)
    80200c4a:	e150                	sd	a2,128(a0)
    sd a3, tf_a3(a0)
    80200c4c:	e554                	sd	a3,136(a0)
    sd a4, tf_a4(a0)
    80200c4e:	e958                	sd	a4,144(a0)
    sd a5, tf_a5(a0)
    80200c50:	ed5c                	sd	a5,152(a0)
    sd a6, tf_a6(a0)
    80200c52:	0b053023          	sd	a6,160(a0)
    sd a7, tf_a7(a0)
    80200c56:	0b153423          	sd	a7,168(a0)
    sd s2, tf_s2(a0)
    80200c5a:	0b253823          	sd	s2,176(a0)
    sd s3, tf_s3(a0)
    80200c5e:	0b353c23          	sd	s3,184(a0)
    sd s4, tf_s4(a0)
    80200c62:	0d453023          	sd	s4,192(a0)
    sd s5, tf_s5(a0)
    80200c66:	0d553423          	sd	s5,200(a0)
    sd s6, tf_s6(a0)
    80200c6a:	0d653823          	sd	s6,208(a0)
    sd s7, tf_s7(a0)
    80200c6e:	0d753c23          	sd	s7,216(a0)
    sd s8, tf_s8(a0)
    80200c72:	0f853023          	sd	s8,224(a0)
    sd s9, tf_s9(a0)
    80200c76:	0f953423          	sd	s9,232(a0)
    sd s10, tf_s10(a0)
    80200c7a:	0fa53823          	sd	s10,240(a0)
    sd s11, tf_s11(a0)
    80200c7e:	0fb53c23          	sd	s11,248(a0)
    sd t3, tf_t3(a0)
    80200c82:	11c53023          	sd	t3,256(a0)
    sd t4, tf_t4(a0)
    80200c86:	11d53423          	sd	t4,264(a0)
    sd t5, tf_t5(a0)
    80200c8a:	11e53823          	sd	t5,272(a0)
    sd t6, tf_t6(a0)
    80200c8e:	11f53c23          	sd	t6,280(a0)

    csrr t0, sscratch
    80200c92:	140022f3          	csrr	t0,sscratch
    sd t0, tf_a0(a0)
    80200c96:	06553823          	sd	t0,112(a0)

    csrr t1, sepc
    80200c9a:	14102373          	csrr	t1,sepc
    sd t1, tf_epc(a0)
    80200c9e:	00653c23          	sd	t1,24(a0)

    ld sp, tf_kernel_sp(a0)
    80200ca2:	00853103          	ld	sp,8(a0)
    ld tp, tf_kernel_hartid(a0)
    80200ca6:	02053203          	ld	tp,32(a0)
    ld t1, tf_kernel_satp(a0)
    80200caa:	00053303          	ld	t1,0(a0)
    # csrw satp, t1
    # sfence.vma zero, zero
    ld t0, tf_kernel_trap(a0)
    80200cae:	01053283          	ld	t0,16(a0)
    jr t0
    80200cb2:	8282                	jr	t0

0000000080200cb4 <user_load>:
        # csrw satp, a1
        # sfence.vma zero, zero

        # put the saved user a0 in sscratch, so we
        # can swap it with our a0 (TRAPFRAME) in the last step.
        ld t0, 112(a0)
    80200cb4:	07053283          	ld	t0,112(a0)
        csrw sscratch, t0
    80200cb8:	14029073          	csrw	sscratch,t0

        # restore all but a0 from TRAPFRAME
        ld ra, 40(a0)
    80200cbc:	02853083          	ld	ra,40(a0)
        ld sp, 48(a0)
    80200cc0:	03053103          	ld	sp,48(a0)
        ld gp, 56(a0)
    80200cc4:	03853183          	ld	gp,56(a0)
        ld tp, 64(a0)
    80200cc8:	04053203          	ld	tp,64(a0)
        ld t0, 72(a0)
    80200ccc:	04853283          	ld	t0,72(a0)
        ld t1, 80(a0)
    80200cd0:	05053303          	ld	t1,80(a0)
        ld t2, 88(a0)
    80200cd4:	05853383          	ld	t2,88(a0)
        ld s0, 96(a0)
    80200cd8:	7120                	ld	s0,96(a0)
        ld s1, 104(a0)
    80200cda:	7524                	ld	s1,104(a0)
        ld a1, 120(a0)
    80200cdc:	7d2c                	ld	a1,120(a0)
        ld a2, 128(a0)
    80200cde:	6150                	ld	a2,128(a0)
        ld a3, 136(a0)
    80200ce0:	6554                	ld	a3,136(a0)
        ld a4, 144(a0)
    80200ce2:	6958                	ld	a4,144(a0)
        ld a5, 152(a0)
    80200ce4:	6d5c                	ld	a5,152(a0)
        ld a6, 160(a0)
    80200ce6:	0a053803          	ld	a6,160(a0)
        ld a7, 168(a0)
    80200cea:	0a853883          	ld	a7,168(a0)
        ld s2, 176(a0)
    80200cee:	0b053903          	ld	s2,176(a0)
        ld s3, 184(a0)
    80200cf2:	0b853983          	ld	s3,184(a0)
        ld s4, 192(a0)
    80200cf6:	0c053a03          	ld	s4,192(a0)
        ld s5, 200(a0)
    80200cfa:	0c853a83          	ld	s5,200(a0)
        ld s6, 208(a0)
    80200cfe:	0d053b03          	ld	s6,208(a0)
        ld s7, 216(a0)
    80200d02:	0d853b83          	ld	s7,216(a0)
        ld s8, 224(a0)
    80200d06:	0e053c03          	ld	s8,224(a0)
        ld s9, 232(a0)
    80200d0a:	0e853c83          	ld	s9,232(a0)
        ld s10, 240(a0)
    80200d0e:	0f053d03          	ld	s10,240(a0)
        ld s11, 248(a0)
    80200d12:	0f853d83          	ld	s11,248(a0)
        ld t3, 256(a0)
    80200d16:	10053e03          	ld	t3,256(a0)
        ld t4, 264(a0)
    80200d1a:	10853e83          	ld	t4,264(a0)
        ld t5, 272(a0)
    80200d1e:	11053f03          	ld	t5,272(a0)
        ld t6, 280(a0)
    80200d22:	11853f83          	ld	t6,280(a0)

	# restore user a0, and save TRAPFRAME in sscratch
        csrrw a0, sscratch, a0
    80200d26:	14051573          	csrrw	a0,sscratch,a0

        # return to user mode and user pc.
        # usertrapret() set up sstatus and sepc.
    80200d2a:	10200073          	sret
