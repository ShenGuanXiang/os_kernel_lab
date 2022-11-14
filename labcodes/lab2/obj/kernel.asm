
bin/kernel:     file format elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:
.text
.globl kern_entry
kern_entry:
# kern_entry函数的主要任务是为执行kern_init建立一个良好的C语言运行环境（设置堆栈），而且临时建立了一个段映射关系，为之后建立分页机制的过程做一个准备
    # load pa of boot pgdir
    movl $REALLOC(__boot_pgdir), %eax
c0100000:	b8 00 10 12 00       	mov    $0x121000,%eax
    movl %eax, %cr3
c0100005:	0f 22 d8             	mov    %eax,%cr3

    # enable paging
    movl %cr0, %eax
c0100008:	0f 20 c0             	mov    %cr0,%eax
    orl $(CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP), %eax
c010000b:	0d 2f 00 05 80       	or     $0x8005002f,%eax
    andl $~(CR0_TS | CR0_EM), %eax
c0100010:	83 e0 f3             	and    $0xfffffff3,%eax
    movl %eax, %cr0
c0100013:	0f 22 c0             	mov    %eax,%cr0

    # update eip
    # now, eip = 0x1.....
    leal next, %eax
c0100016:	8d 05 1e 00 10 c0    	lea    0xc010001e,%eax
    # set eip = KERNBASE + 0x1.....
    jmp *%eax
c010001c:	ff e0                	jmp    *%eax

c010001e <next>:
next:

    # unmap va 0 ~ 4M, it's temporary mapping
    xorl %eax, %eax
c010001e:	31 c0                	xor    %eax,%eax
    movl %eax, __boot_pgdir
c0100020:	a3 00 10 12 c0       	mov    %eax,0xc0121000

    # set ebp, esp
    movl $0x0, %ebp
c0100025:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
c010002a:	bc 00 00 12 c0       	mov    $0xc0120000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
c010002f:	e8 02 00 00 00       	call   c0100036 <kern_init>

c0100034 <spin>:

# should never get here
spin:
    jmp spin
c0100034:	eb fe                	jmp    c0100034 <spin>

c0100036 <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
c0100036:	f3 0f 1e fb          	endbr32 
c010003a:	55                   	push   %ebp
c010003b:	89 e5                	mov    %esp,%ebp
c010003d:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
c0100040:	b8 44 3f 12 c0       	mov    $0xc0123f44,%eax
c0100045:	2d 00 30 12 c0       	sub    $0xc0123000,%eax
c010004a:	89 44 24 08          	mov    %eax,0x8(%esp)
c010004e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0100055:	00 
c0100056:	c7 04 24 00 30 12 c0 	movl   $0xc0123000,(%esp)
c010005d:	e8 14 98 00 00       	call   c0109876 <memset>

    cons_init();                // init the console
c0100062:	e8 3a 16 00 00       	call   c01016a1 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c0100067:	c7 45 f4 a0 a0 10 c0 	movl   $0xc010a0a0,-0xc(%ebp)
    cprintf("%s\n\n", message);
c010006e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100071:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100075:	c7 04 24 bc a0 10 c0 	movl   $0xc010a0bc,(%esp)
c010007c:	e8 49 02 00 00       	call   c01002ca <cprintf>

    print_kerninfo();
c0100081:	e8 07 09 00 00       	call   c010098d <print_kerninfo>

    grade_backtrace();
c0100086:	e8 9a 00 00 00       	call   c0100125 <grade_backtrace>

    pmm_init();                 // init physical memory management
c010008b:	e8 44 34 00 00       	call   c01034d4 <pmm_init>

    pic_init();                 // init interrupt controller
c0100090:	e8 87 17 00 00       	call   c010181c <pic_init>
    idt_init();                 // init interrupt descriptor table
c0100095:	e8 2c 19 00 00       	call   c01019c6 <idt_init>

    clock_init();               // init clock interrupt
c010009a:	e8 49 0d 00 00       	call   c0100de8 <clock_init>
    intr_enable();              // enable irq interrupt
c010009f:	e8 c4 18 00 00       	call   c0101968 <intr_enable>

    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    lab1_switch_test();
c01000a4:	e8 87 01 00 00       	call   c0100230 <lab1_switch_test>

    /* do nothing */
    while (1);
c01000a9:	eb fe                	jmp    c01000a9 <kern_init+0x73>

c01000ab <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
c01000ab:	f3 0f 1e fb          	endbr32 
c01000af:	55                   	push   %ebp
c01000b0:	89 e5                	mov    %esp,%ebp
c01000b2:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
c01000b5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01000bc:	00 
c01000bd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01000c4:	00 
c01000c5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01000cc:	e8 01 0d 00 00       	call   c0100dd2 <mon_backtrace>
}
c01000d1:	90                   	nop
c01000d2:	c9                   	leave  
c01000d3:	c3                   	ret    

c01000d4 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
c01000d4:	f3 0f 1e fb          	endbr32 
c01000d8:	55                   	push   %ebp
c01000d9:	89 e5                	mov    %esp,%ebp
c01000db:	53                   	push   %ebx
c01000dc:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
c01000df:	8d 4d 0c             	lea    0xc(%ebp),%ecx
c01000e2:	8b 55 0c             	mov    0xc(%ebp),%edx
c01000e5:	8d 5d 08             	lea    0x8(%ebp),%ebx
c01000e8:	8b 45 08             	mov    0x8(%ebp),%eax
c01000eb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c01000ef:	89 54 24 08          	mov    %edx,0x8(%esp)
c01000f3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c01000f7:	89 04 24             	mov    %eax,(%esp)
c01000fa:	e8 ac ff ff ff       	call   c01000ab <grade_backtrace2>
}
c01000ff:	90                   	nop
c0100100:	83 c4 14             	add    $0x14,%esp
c0100103:	5b                   	pop    %ebx
c0100104:	5d                   	pop    %ebp
c0100105:	c3                   	ret    

c0100106 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
c0100106:	f3 0f 1e fb          	endbr32 
c010010a:	55                   	push   %ebp
c010010b:	89 e5                	mov    %esp,%ebp
c010010d:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
c0100110:	8b 45 10             	mov    0x10(%ebp),%eax
c0100113:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100117:	8b 45 08             	mov    0x8(%ebp),%eax
c010011a:	89 04 24             	mov    %eax,(%esp)
c010011d:	e8 b2 ff ff ff       	call   c01000d4 <grade_backtrace1>
}
c0100122:	90                   	nop
c0100123:	c9                   	leave  
c0100124:	c3                   	ret    

c0100125 <grade_backtrace>:

void
grade_backtrace(void) {
c0100125:	f3 0f 1e fb          	endbr32 
c0100129:	55                   	push   %ebp
c010012a:	89 e5                	mov    %esp,%ebp
c010012c:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
c010012f:	b8 36 00 10 c0       	mov    $0xc0100036,%eax
c0100134:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
c010013b:	ff 
c010013c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100140:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100147:	e8 ba ff ff ff       	call   c0100106 <grade_backtrace0>
}
c010014c:	90                   	nop
c010014d:	c9                   	leave  
c010014e:	c3                   	ret    

c010014f <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
c010014f:	f3 0f 1e fb          	endbr32 
c0100153:	55                   	push   %ebp
c0100154:	89 e5                	mov    %esp,%ebp
c0100156:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
c0100159:	8c 4d f6             	mov    %cs,-0xa(%ebp)
c010015c:	8c 5d f4             	mov    %ds,-0xc(%ebp)
c010015f:	8c 45 f2             	mov    %es,-0xe(%ebp)
c0100162:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
c0100165:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100169:	83 e0 03             	and    $0x3,%eax
c010016c:	89 c2                	mov    %eax,%edx
c010016e:	a1 00 30 12 c0       	mov    0xc0123000,%eax
c0100173:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100177:	89 44 24 04          	mov    %eax,0x4(%esp)
c010017b:	c7 04 24 c1 a0 10 c0 	movl   $0xc010a0c1,(%esp)
c0100182:	e8 43 01 00 00       	call   c01002ca <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
c0100187:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010018b:	89 c2                	mov    %eax,%edx
c010018d:	a1 00 30 12 c0       	mov    0xc0123000,%eax
c0100192:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100196:	89 44 24 04          	mov    %eax,0x4(%esp)
c010019a:	c7 04 24 cf a0 10 c0 	movl   $0xc010a0cf,(%esp)
c01001a1:	e8 24 01 00 00       	call   c01002ca <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
c01001a6:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c01001aa:	89 c2                	mov    %eax,%edx
c01001ac:	a1 00 30 12 c0       	mov    0xc0123000,%eax
c01001b1:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001b5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001b9:	c7 04 24 dd a0 10 c0 	movl   $0xc010a0dd,(%esp)
c01001c0:	e8 05 01 00 00       	call   c01002ca <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
c01001c5:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001c9:	89 c2                	mov    %eax,%edx
c01001cb:	a1 00 30 12 c0       	mov    0xc0123000,%eax
c01001d0:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001d4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001d8:	c7 04 24 eb a0 10 c0 	movl   $0xc010a0eb,(%esp)
c01001df:	e8 e6 00 00 00       	call   c01002ca <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
c01001e4:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001e8:	89 c2                	mov    %eax,%edx
c01001ea:	a1 00 30 12 c0       	mov    0xc0123000,%eax
c01001ef:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001f3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001f7:	c7 04 24 f9 a0 10 c0 	movl   $0xc010a0f9,(%esp)
c01001fe:	e8 c7 00 00 00       	call   c01002ca <cprintf>
    round ++;
c0100203:	a1 00 30 12 c0       	mov    0xc0123000,%eax
c0100208:	40                   	inc    %eax
c0100209:	a3 00 30 12 c0       	mov    %eax,0xc0123000
}
c010020e:	90                   	nop
c010020f:	c9                   	leave  
c0100210:	c3                   	ret    

c0100211 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
c0100211:	f3 0f 1e fb          	endbr32 
c0100215:	55                   	push   %ebp
c0100216:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
    asm volatile (
c0100218:	83 ec 08             	sub    $0x8,%esp
c010021b:	cd 78                	int    $0x78
c010021d:	89 ec                	mov    %ebp,%esp
        "int %0 \n"                 // int 指令将 eflag、cs、eip 压栈
        "movl %%ebp, %%esp"
        :
        : "i"(T_SWITCH_TOU)
    );
}
c010021f:	90                   	nop
c0100220:	5d                   	pop    %ebp
c0100221:	c3                   	ret    

c0100222 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
c0100222:	f3 0f 1e fb          	endbr32 
c0100226:	55                   	push   %ebp
c0100227:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
    asm volatile (
c0100229:	cd 79                	int    $0x79
c010022b:	89 ec                	mov    %ebp,%esp
        "int %0 \n"
        "movl %%ebp, %%esp \n"
        :
        : "i"(T_SWITCH_TOK)
    );
}
c010022d:	90                   	nop
c010022e:	5d                   	pop    %ebp
c010022f:	c3                   	ret    

c0100230 <lab1_switch_test>:

static void
lab1_switch_test(void) {
c0100230:	f3 0f 1e fb          	endbr32 
c0100234:	55                   	push   %ebp
c0100235:	89 e5                	mov    %esp,%ebp
c0100237:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
c010023a:	e8 10 ff ff ff       	call   c010014f <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
c010023f:	c7 04 24 08 a1 10 c0 	movl   $0xc010a108,(%esp)
c0100246:	e8 7f 00 00 00       	call   c01002ca <cprintf>
    lab1_switch_to_user();
c010024b:	e8 c1 ff ff ff       	call   c0100211 <lab1_switch_to_user>
    lab1_print_cur_status();
c0100250:	e8 fa fe ff ff       	call   c010014f <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c0100255:	c7 04 24 28 a1 10 c0 	movl   $0xc010a128,(%esp)
c010025c:	e8 69 00 00 00       	call   c01002ca <cprintf>
    lab1_switch_to_kernel();
c0100261:	e8 bc ff ff ff       	call   c0100222 <lab1_switch_to_kernel>
    lab1_print_cur_status();
c0100266:	e8 e4 fe ff ff       	call   c010014f <lab1_print_cur_status>
}
c010026b:	90                   	nop
c010026c:	c9                   	leave  
c010026d:	c3                   	ret    

c010026e <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
c010026e:	f3 0f 1e fb          	endbr32 
c0100272:	55                   	push   %ebp
c0100273:	89 e5                	mov    %esp,%ebp
c0100275:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c0100278:	8b 45 08             	mov    0x8(%ebp),%eax
c010027b:	89 04 24             	mov    %eax,(%esp)
c010027e:	e8 4f 14 00 00       	call   c01016d2 <cons_putc>
    (*cnt) ++;
c0100283:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100286:	8b 00                	mov    (%eax),%eax
c0100288:	8d 50 01             	lea    0x1(%eax),%edx
c010028b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010028e:	89 10                	mov    %edx,(%eax)
}
c0100290:	90                   	nop
c0100291:	c9                   	leave  
c0100292:	c3                   	ret    

c0100293 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
c0100293:	f3 0f 1e fb          	endbr32 
c0100297:	55                   	push   %ebp
c0100298:	89 e5                	mov    %esp,%ebp
c010029a:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c010029d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
c01002a4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01002a7:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01002ab:	8b 45 08             	mov    0x8(%ebp),%eax
c01002ae:	89 44 24 08          	mov    %eax,0x8(%esp)
c01002b2:	8d 45 f4             	lea    -0xc(%ebp),%eax
c01002b5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01002b9:	c7 04 24 6e 02 10 c0 	movl   $0xc010026e,(%esp)
c01002c0:	e8 1d 99 00 00       	call   c0109be2 <vprintfmt>
    return cnt;
c01002c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01002c8:	c9                   	leave  
c01002c9:	c3                   	ret    

c01002ca <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
c01002ca:	f3 0f 1e fb          	endbr32 
c01002ce:	55                   	push   %ebp
c01002cf:	89 e5                	mov    %esp,%ebp
c01002d1:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c01002d4:	8d 45 0c             	lea    0xc(%ebp),%eax
c01002d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
c01002da:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002dd:	89 44 24 04          	mov    %eax,0x4(%esp)
c01002e1:	8b 45 08             	mov    0x8(%ebp),%eax
c01002e4:	89 04 24             	mov    %eax,(%esp)
c01002e7:	e8 a7 ff ff ff       	call   c0100293 <vcprintf>
c01002ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c01002ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01002f2:	c9                   	leave  
c01002f3:	c3                   	ret    

c01002f4 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
c01002f4:	f3 0f 1e fb          	endbr32 
c01002f8:	55                   	push   %ebp
c01002f9:	89 e5                	mov    %esp,%ebp
c01002fb:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c01002fe:	8b 45 08             	mov    0x8(%ebp),%eax
c0100301:	89 04 24             	mov    %eax,(%esp)
c0100304:	e8 c9 13 00 00       	call   c01016d2 <cons_putc>
}
c0100309:	90                   	nop
c010030a:	c9                   	leave  
c010030b:	c3                   	ret    

c010030c <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
c010030c:	f3 0f 1e fb          	endbr32 
c0100310:	55                   	push   %ebp
c0100311:	89 e5                	mov    %esp,%ebp
c0100313:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c0100316:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
c010031d:	eb 13                	jmp    c0100332 <cputs+0x26>
        cputch(c, &cnt);
c010031f:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0100323:	8d 55 f0             	lea    -0x10(%ebp),%edx
c0100326:	89 54 24 04          	mov    %edx,0x4(%esp)
c010032a:	89 04 24             	mov    %eax,(%esp)
c010032d:	e8 3c ff ff ff       	call   c010026e <cputch>
    while ((c = *str ++) != '\0') {
c0100332:	8b 45 08             	mov    0x8(%ebp),%eax
c0100335:	8d 50 01             	lea    0x1(%eax),%edx
c0100338:	89 55 08             	mov    %edx,0x8(%ebp)
c010033b:	0f b6 00             	movzbl (%eax),%eax
c010033e:	88 45 f7             	mov    %al,-0x9(%ebp)
c0100341:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
c0100345:	75 d8                	jne    c010031f <cputs+0x13>
    }
    cputch('\n', &cnt);
c0100347:	8d 45 f0             	lea    -0x10(%ebp),%eax
c010034a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010034e:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
c0100355:	e8 14 ff ff ff       	call   c010026e <cputch>
    return cnt;
c010035a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c010035d:	c9                   	leave  
c010035e:	c3                   	ret    

c010035f <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
c010035f:	f3 0f 1e fb          	endbr32 
c0100363:	55                   	push   %ebp
c0100364:	89 e5                	mov    %esp,%ebp
c0100366:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
c0100369:	90                   	nop
c010036a:	e8 a4 13 00 00       	call   c0101713 <cons_getc>
c010036f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100372:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100376:	74 f2                	je     c010036a <getchar+0xb>
        /* do nothing */;
    return c;
c0100378:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010037b:	c9                   	leave  
c010037c:	c3                   	ret    

c010037d <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
c010037d:	f3 0f 1e fb          	endbr32 
c0100381:	55                   	push   %ebp
c0100382:	89 e5                	mov    %esp,%ebp
c0100384:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
c0100387:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010038b:	74 13                	je     c01003a0 <readline+0x23>
        cprintf("%s", prompt);
c010038d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100390:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100394:	c7 04 24 47 a1 10 c0 	movl   $0xc010a147,(%esp)
c010039b:	e8 2a ff ff ff       	call   c01002ca <cprintf>
    }
    int i = 0, c;
c01003a0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
c01003a7:	e8 b3 ff ff ff       	call   c010035f <getchar>
c01003ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
c01003af:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01003b3:	79 07                	jns    c01003bc <readline+0x3f>
            return NULL;
c01003b5:	b8 00 00 00 00       	mov    $0x0,%eax
c01003ba:	eb 78                	jmp    c0100434 <readline+0xb7>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
c01003bc:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
c01003c0:	7e 28                	jle    c01003ea <readline+0x6d>
c01003c2:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
c01003c9:	7f 1f                	jg     c01003ea <readline+0x6d>
            cputchar(c);
c01003cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01003ce:	89 04 24             	mov    %eax,(%esp)
c01003d1:	e8 1e ff ff ff       	call   c01002f4 <cputchar>
            buf[i ++] = c;
c01003d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01003d9:	8d 50 01             	lea    0x1(%eax),%edx
c01003dc:	89 55 f4             	mov    %edx,-0xc(%ebp)
c01003df:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01003e2:	88 90 20 30 12 c0    	mov    %dl,-0x3fedcfe0(%eax)
c01003e8:	eb 45                	jmp    c010042f <readline+0xb2>
        }
        else if (c == '\b' && i > 0) {
c01003ea:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
c01003ee:	75 16                	jne    c0100406 <readline+0x89>
c01003f0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01003f4:	7e 10                	jle    c0100406 <readline+0x89>
            cputchar(c);
c01003f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01003f9:	89 04 24             	mov    %eax,(%esp)
c01003fc:	e8 f3 fe ff ff       	call   c01002f4 <cputchar>
            i --;
c0100401:	ff 4d f4             	decl   -0xc(%ebp)
c0100404:	eb 29                	jmp    c010042f <readline+0xb2>
        }
        else if (c == '\n' || c == '\r') {
c0100406:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
c010040a:	74 06                	je     c0100412 <readline+0x95>
c010040c:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
c0100410:	75 95                	jne    c01003a7 <readline+0x2a>
            cputchar(c);
c0100412:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100415:	89 04 24             	mov    %eax,(%esp)
c0100418:	e8 d7 fe ff ff       	call   c01002f4 <cputchar>
            buf[i] = '\0';
c010041d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100420:	05 20 30 12 c0       	add    $0xc0123020,%eax
c0100425:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c0100428:	b8 20 30 12 c0       	mov    $0xc0123020,%eax
c010042d:	eb 05                	jmp    c0100434 <readline+0xb7>
        c = getchar();
c010042f:	e9 73 ff ff ff       	jmp    c01003a7 <readline+0x2a>
        }
    }
}
c0100434:	c9                   	leave  
c0100435:	c3                   	ret    

c0100436 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c0100436:	f3 0f 1e fb          	endbr32 
c010043a:	55                   	push   %ebp
c010043b:	89 e5                	mov    %esp,%ebp
c010043d:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
c0100440:	a1 20 34 12 c0       	mov    0xc0123420,%eax
c0100445:	85 c0                	test   %eax,%eax
c0100447:	75 5b                	jne    c01004a4 <__panic+0x6e>
        goto panic_dead;
    }
    is_panic = 1;
c0100449:	c7 05 20 34 12 c0 01 	movl   $0x1,0xc0123420
c0100450:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c0100453:	8d 45 14             	lea    0x14(%ebp),%eax
c0100456:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c0100459:	8b 45 0c             	mov    0xc(%ebp),%eax
c010045c:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100460:	8b 45 08             	mov    0x8(%ebp),%eax
c0100463:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100467:	c7 04 24 4a a1 10 c0 	movl   $0xc010a14a,(%esp)
c010046e:	e8 57 fe ff ff       	call   c01002ca <cprintf>
    vcprintf(fmt, ap);
c0100473:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100476:	89 44 24 04          	mov    %eax,0x4(%esp)
c010047a:	8b 45 10             	mov    0x10(%ebp),%eax
c010047d:	89 04 24             	mov    %eax,(%esp)
c0100480:	e8 0e fe ff ff       	call   c0100293 <vcprintf>
    cprintf("\n");
c0100485:	c7 04 24 66 a1 10 c0 	movl   $0xc010a166,(%esp)
c010048c:	e8 39 fe ff ff       	call   c01002ca <cprintf>
    
    cprintf("stack trackback:\n");
c0100491:	c7 04 24 68 a1 10 c0 	movl   $0xc010a168,(%esp)
c0100498:	e8 2d fe ff ff       	call   c01002ca <cprintf>
    print_stackframe();
c010049d:	e8 3d 06 00 00       	call   c0100adf <print_stackframe>
c01004a2:	eb 01                	jmp    c01004a5 <__panic+0x6f>
        goto panic_dead;
c01004a4:	90                   	nop
    
    va_end(ap);

panic_dead:
    intr_disable();
c01004a5:	e8 ca 14 00 00       	call   c0101974 <intr_disable>
    while (1) {
        kmonitor(NULL);
c01004aa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01004b1:	e8 43 08 00 00       	call   c0100cf9 <kmonitor>
c01004b6:	eb f2                	jmp    c01004aa <__panic+0x74>

c01004b8 <__warn>:
    }
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c01004b8:	f3 0f 1e fb          	endbr32 
c01004bc:	55                   	push   %ebp
c01004bd:	89 e5                	mov    %esp,%ebp
c01004bf:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
c01004c2:	8d 45 14             	lea    0x14(%ebp),%eax
c01004c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c01004c8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004cb:	89 44 24 08          	mov    %eax,0x8(%esp)
c01004cf:	8b 45 08             	mov    0x8(%ebp),%eax
c01004d2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01004d6:	c7 04 24 7a a1 10 c0 	movl   $0xc010a17a,(%esp)
c01004dd:	e8 e8 fd ff ff       	call   c01002ca <cprintf>
    vcprintf(fmt, ap);
c01004e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01004e5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01004e9:	8b 45 10             	mov    0x10(%ebp),%eax
c01004ec:	89 04 24             	mov    %eax,(%esp)
c01004ef:	e8 9f fd ff ff       	call   c0100293 <vcprintf>
    cprintf("\n");
c01004f4:	c7 04 24 66 a1 10 c0 	movl   $0xc010a166,(%esp)
c01004fb:	e8 ca fd ff ff       	call   c01002ca <cprintf>
    va_end(ap);
}
c0100500:	90                   	nop
c0100501:	c9                   	leave  
c0100502:	c3                   	ret    

c0100503 <is_kernel_panic>:

bool
is_kernel_panic(void) {
c0100503:	f3 0f 1e fb          	endbr32 
c0100507:	55                   	push   %ebp
c0100508:	89 e5                	mov    %esp,%ebp
    return is_panic;
c010050a:	a1 20 34 12 c0       	mov    0xc0123420,%eax
}
c010050f:	5d                   	pop    %ebp
c0100510:	c3                   	ret    

c0100511 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
c0100511:	f3 0f 1e fb          	endbr32 
c0100515:	55                   	push   %ebp
c0100516:	89 e5                	mov    %esp,%ebp
c0100518:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
c010051b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010051e:	8b 00                	mov    (%eax),%eax
c0100520:	89 45 fc             	mov    %eax,-0x4(%ebp)
c0100523:	8b 45 10             	mov    0x10(%ebp),%eax
c0100526:	8b 00                	mov    (%eax),%eax
c0100528:	89 45 f8             	mov    %eax,-0x8(%ebp)
c010052b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
c0100532:	e9 ca 00 00 00       	jmp    c0100601 <stab_binsearch+0xf0>
        int true_m = (l + r) / 2, m = true_m;
c0100537:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010053a:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010053d:	01 d0                	add    %edx,%eax
c010053f:	89 c2                	mov    %eax,%edx
c0100541:	c1 ea 1f             	shr    $0x1f,%edx
c0100544:	01 d0                	add    %edx,%eax
c0100546:	d1 f8                	sar    %eax
c0100548:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010054b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010054e:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c0100551:	eb 03                	jmp    c0100556 <stab_binsearch+0x45>
            m --;
c0100553:	ff 4d f0             	decl   -0x10(%ebp)
        while (m >= l && stabs[m].n_type != type) {
c0100556:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100559:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c010055c:	7c 1f                	jl     c010057d <stab_binsearch+0x6c>
c010055e:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100561:	89 d0                	mov    %edx,%eax
c0100563:	01 c0                	add    %eax,%eax
c0100565:	01 d0                	add    %edx,%eax
c0100567:	c1 e0 02             	shl    $0x2,%eax
c010056a:	89 c2                	mov    %eax,%edx
c010056c:	8b 45 08             	mov    0x8(%ebp),%eax
c010056f:	01 d0                	add    %edx,%eax
c0100571:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100575:	0f b6 c0             	movzbl %al,%eax
c0100578:	39 45 14             	cmp    %eax,0x14(%ebp)
c010057b:	75 d6                	jne    c0100553 <stab_binsearch+0x42>
        }
        if (m < l) {    // no match in [l, m]
c010057d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100580:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100583:	7d 09                	jge    c010058e <stab_binsearch+0x7d>
            l = true_m + 1;
c0100585:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100588:	40                   	inc    %eax
c0100589:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
c010058c:	eb 73                	jmp    c0100601 <stab_binsearch+0xf0>
        }

        // actual binary search
        any_matches = 1;
c010058e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
c0100595:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100598:	89 d0                	mov    %edx,%eax
c010059a:	01 c0                	add    %eax,%eax
c010059c:	01 d0                	add    %edx,%eax
c010059e:	c1 e0 02             	shl    $0x2,%eax
c01005a1:	89 c2                	mov    %eax,%edx
c01005a3:	8b 45 08             	mov    0x8(%ebp),%eax
c01005a6:	01 d0                	add    %edx,%eax
c01005a8:	8b 40 08             	mov    0x8(%eax),%eax
c01005ab:	39 45 18             	cmp    %eax,0x18(%ebp)
c01005ae:	76 11                	jbe    c01005c1 <stab_binsearch+0xb0>
            *region_left = m;
c01005b0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005b3:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01005b6:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
c01005b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01005bb:	40                   	inc    %eax
c01005bc:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01005bf:	eb 40                	jmp    c0100601 <stab_binsearch+0xf0>
        } else if (stabs[m].n_value > addr) {
c01005c1:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01005c4:	89 d0                	mov    %edx,%eax
c01005c6:	01 c0                	add    %eax,%eax
c01005c8:	01 d0                	add    %edx,%eax
c01005ca:	c1 e0 02             	shl    $0x2,%eax
c01005cd:	89 c2                	mov    %eax,%edx
c01005cf:	8b 45 08             	mov    0x8(%ebp),%eax
c01005d2:	01 d0                	add    %edx,%eax
c01005d4:	8b 40 08             	mov    0x8(%eax),%eax
c01005d7:	39 45 18             	cmp    %eax,0x18(%ebp)
c01005da:	73 14                	jae    c01005f0 <stab_binsearch+0xdf>
            *region_right = m - 1;
c01005dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01005df:	8d 50 ff             	lea    -0x1(%eax),%edx
c01005e2:	8b 45 10             	mov    0x10(%ebp),%eax
c01005e5:	89 10                	mov    %edx,(%eax)
            r = m - 1;
c01005e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01005ea:	48                   	dec    %eax
c01005eb:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01005ee:	eb 11                	jmp    c0100601 <stab_binsearch+0xf0>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
c01005f0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005f3:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01005f6:	89 10                	mov    %edx,(%eax)
            l = m;
c01005f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01005fb:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
c01005fe:	ff 45 18             	incl   0x18(%ebp)
    while (l <= r) {
c0100601:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100604:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c0100607:	0f 8e 2a ff ff ff    	jle    c0100537 <stab_binsearch+0x26>
        }
    }

    if (!any_matches) {
c010060d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100611:	75 0f                	jne    c0100622 <stab_binsearch+0x111>
        *region_right = *region_left - 1;
c0100613:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100616:	8b 00                	mov    (%eax),%eax
c0100618:	8d 50 ff             	lea    -0x1(%eax),%edx
c010061b:	8b 45 10             	mov    0x10(%ebp),%eax
c010061e:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
c0100620:	eb 3e                	jmp    c0100660 <stab_binsearch+0x14f>
        l = *region_right;
c0100622:	8b 45 10             	mov    0x10(%ebp),%eax
c0100625:	8b 00                	mov    (%eax),%eax
c0100627:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
c010062a:	eb 03                	jmp    c010062f <stab_binsearch+0x11e>
c010062c:	ff 4d fc             	decl   -0x4(%ebp)
c010062f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100632:	8b 00                	mov    (%eax),%eax
c0100634:	39 45 fc             	cmp    %eax,-0x4(%ebp)
c0100637:	7e 1f                	jle    c0100658 <stab_binsearch+0x147>
c0100639:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010063c:	89 d0                	mov    %edx,%eax
c010063e:	01 c0                	add    %eax,%eax
c0100640:	01 d0                	add    %edx,%eax
c0100642:	c1 e0 02             	shl    $0x2,%eax
c0100645:	89 c2                	mov    %eax,%edx
c0100647:	8b 45 08             	mov    0x8(%ebp),%eax
c010064a:	01 d0                	add    %edx,%eax
c010064c:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100650:	0f b6 c0             	movzbl %al,%eax
c0100653:	39 45 14             	cmp    %eax,0x14(%ebp)
c0100656:	75 d4                	jne    c010062c <stab_binsearch+0x11b>
        *region_left = l;
c0100658:	8b 45 0c             	mov    0xc(%ebp),%eax
c010065b:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010065e:	89 10                	mov    %edx,(%eax)
}
c0100660:	90                   	nop
c0100661:	c9                   	leave  
c0100662:	c3                   	ret    

c0100663 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
c0100663:	f3 0f 1e fb          	endbr32 
c0100667:	55                   	push   %ebp
c0100668:	89 e5                	mov    %esp,%ebp
c010066a:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
c010066d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100670:	c7 00 98 a1 10 c0    	movl   $0xc010a198,(%eax)
    info->eip_line = 0;
c0100676:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100679:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c0100680:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100683:	c7 40 08 98 a1 10 c0 	movl   $0xc010a198,0x8(%eax)
    info->eip_fn_namelen = 9;
c010068a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010068d:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
c0100694:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100697:	8b 55 08             	mov    0x8(%ebp),%edx
c010069a:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
c010069d:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006a0:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
c01006a7:	c7 45 f4 90 b8 10 c0 	movl   $0xc010b890,-0xc(%ebp)
    stab_end = __STAB_END__;
c01006ae:	c7 45 f0 90 a5 11 c0 	movl   $0xc011a590,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c01006b5:	c7 45 ec 91 a5 11 c0 	movl   $0xc011a591,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c01006bc:	c7 45 e8 ca d3 11 c0 	movl   $0xc011d3ca,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c01006c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01006c6:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01006c9:	76 0b                	jbe    c01006d6 <debuginfo_eip+0x73>
c01006cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01006ce:	48                   	dec    %eax
c01006cf:	0f b6 00             	movzbl (%eax),%eax
c01006d2:	84 c0                	test   %al,%al
c01006d4:	74 0a                	je     c01006e0 <debuginfo_eip+0x7d>
        return -1;
c01006d6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01006db:	e9 ab 02 00 00       	jmp    c010098b <debuginfo_eip+0x328>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c01006e0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c01006e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01006ea:	2b 45 f4             	sub    -0xc(%ebp),%eax
c01006ed:	c1 f8 02             	sar    $0x2,%eax
c01006f0:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c01006f6:	48                   	dec    %eax
c01006f7:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c01006fa:	8b 45 08             	mov    0x8(%ebp),%eax
c01006fd:	89 44 24 10          	mov    %eax,0x10(%esp)
c0100701:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
c0100708:	00 
c0100709:	8d 45 e0             	lea    -0x20(%ebp),%eax
c010070c:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100710:	8d 45 e4             	lea    -0x1c(%ebp),%eax
c0100713:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100717:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010071a:	89 04 24             	mov    %eax,(%esp)
c010071d:	e8 ef fd ff ff       	call   c0100511 <stab_binsearch>
    if (lfile == 0)
c0100722:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100725:	85 c0                	test   %eax,%eax
c0100727:	75 0a                	jne    c0100733 <debuginfo_eip+0xd0>
        return -1;
c0100729:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010072e:	e9 58 02 00 00       	jmp    c010098b <debuginfo_eip+0x328>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c0100733:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100736:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0100739:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010073c:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c010073f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100742:	89 44 24 10          	mov    %eax,0x10(%esp)
c0100746:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
c010074d:	00 
c010074e:	8d 45 d8             	lea    -0x28(%ebp),%eax
c0100751:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100755:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100758:	89 44 24 04          	mov    %eax,0x4(%esp)
c010075c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010075f:	89 04 24             	mov    %eax,(%esp)
c0100762:	e8 aa fd ff ff       	call   c0100511 <stab_binsearch>

    if (lfun <= rfun) {
c0100767:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010076a:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010076d:	39 c2                	cmp    %eax,%edx
c010076f:	7f 78                	jg     c01007e9 <debuginfo_eip+0x186>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c0100771:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100774:	89 c2                	mov    %eax,%edx
c0100776:	89 d0                	mov    %edx,%eax
c0100778:	01 c0                	add    %eax,%eax
c010077a:	01 d0                	add    %edx,%eax
c010077c:	c1 e0 02             	shl    $0x2,%eax
c010077f:	89 c2                	mov    %eax,%edx
c0100781:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100784:	01 d0                	add    %edx,%eax
c0100786:	8b 10                	mov    (%eax),%edx
c0100788:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010078b:	2b 45 ec             	sub    -0x14(%ebp),%eax
c010078e:	39 c2                	cmp    %eax,%edx
c0100790:	73 22                	jae    c01007b4 <debuginfo_eip+0x151>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c0100792:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100795:	89 c2                	mov    %eax,%edx
c0100797:	89 d0                	mov    %edx,%eax
c0100799:	01 c0                	add    %eax,%eax
c010079b:	01 d0                	add    %edx,%eax
c010079d:	c1 e0 02             	shl    $0x2,%eax
c01007a0:	89 c2                	mov    %eax,%edx
c01007a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007a5:	01 d0                	add    %edx,%eax
c01007a7:	8b 10                	mov    (%eax),%edx
c01007a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01007ac:	01 c2                	add    %eax,%edx
c01007ae:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007b1:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c01007b4:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01007b7:	89 c2                	mov    %eax,%edx
c01007b9:	89 d0                	mov    %edx,%eax
c01007bb:	01 c0                	add    %eax,%eax
c01007bd:	01 d0                	add    %edx,%eax
c01007bf:	c1 e0 02             	shl    $0x2,%eax
c01007c2:	89 c2                	mov    %eax,%edx
c01007c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007c7:	01 d0                	add    %edx,%eax
c01007c9:	8b 50 08             	mov    0x8(%eax),%edx
c01007cc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007cf:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c01007d2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007d5:	8b 40 10             	mov    0x10(%eax),%eax
c01007d8:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c01007db:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01007de:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
c01007e1:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01007e4:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01007e7:	eb 15                	jmp    c01007fe <debuginfo_eip+0x19b>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c01007e9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007ec:	8b 55 08             	mov    0x8(%ebp),%edx
c01007ef:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c01007f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01007f5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
c01007f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01007fb:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c01007fe:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100801:	8b 40 08             	mov    0x8(%eax),%eax
c0100804:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
c010080b:	00 
c010080c:	89 04 24             	mov    %eax,(%esp)
c010080f:	e8 d6 8e 00 00       	call   c01096ea <strfind>
c0100814:	8b 55 0c             	mov    0xc(%ebp),%edx
c0100817:	8b 52 08             	mov    0x8(%edx),%edx
c010081a:	29 d0                	sub    %edx,%eax
c010081c:	89 c2                	mov    %eax,%edx
c010081e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100821:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c0100824:	8b 45 08             	mov    0x8(%ebp),%eax
c0100827:	89 44 24 10          	mov    %eax,0x10(%esp)
c010082b:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
c0100832:	00 
c0100833:	8d 45 d0             	lea    -0x30(%ebp),%eax
c0100836:	89 44 24 08          	mov    %eax,0x8(%esp)
c010083a:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c010083d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100841:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100844:	89 04 24             	mov    %eax,(%esp)
c0100847:	e8 c5 fc ff ff       	call   c0100511 <stab_binsearch>
    if (lline <= rline) {
c010084c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010084f:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100852:	39 c2                	cmp    %eax,%edx
c0100854:	7f 23                	jg     c0100879 <debuginfo_eip+0x216>
        info->eip_line = stabs[rline].n_desc;
c0100856:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100859:	89 c2                	mov    %eax,%edx
c010085b:	89 d0                	mov    %edx,%eax
c010085d:	01 c0                	add    %eax,%eax
c010085f:	01 d0                	add    %edx,%eax
c0100861:	c1 e0 02             	shl    $0x2,%eax
c0100864:	89 c2                	mov    %eax,%edx
c0100866:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100869:	01 d0                	add    %edx,%eax
c010086b:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c010086f:	89 c2                	mov    %eax,%edx
c0100871:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100874:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100877:	eb 11                	jmp    c010088a <debuginfo_eip+0x227>
        return -1;
c0100879:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010087e:	e9 08 01 00 00       	jmp    c010098b <debuginfo_eip+0x328>
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c0100883:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100886:	48                   	dec    %eax
c0100887:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile
c010088a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010088d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100890:	39 c2                	cmp    %eax,%edx
c0100892:	7c 56                	jl     c01008ea <debuginfo_eip+0x287>
           && stabs[lline].n_type != N_SOL
c0100894:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100897:	89 c2                	mov    %eax,%edx
c0100899:	89 d0                	mov    %edx,%eax
c010089b:	01 c0                	add    %eax,%eax
c010089d:	01 d0                	add    %edx,%eax
c010089f:	c1 e0 02             	shl    $0x2,%eax
c01008a2:	89 c2                	mov    %eax,%edx
c01008a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01008a7:	01 d0                	add    %edx,%eax
c01008a9:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01008ad:	3c 84                	cmp    $0x84,%al
c01008af:	74 39                	je     c01008ea <debuginfo_eip+0x287>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c01008b1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01008b4:	89 c2                	mov    %eax,%edx
c01008b6:	89 d0                	mov    %edx,%eax
c01008b8:	01 c0                	add    %eax,%eax
c01008ba:	01 d0                	add    %edx,%eax
c01008bc:	c1 e0 02             	shl    $0x2,%eax
c01008bf:	89 c2                	mov    %eax,%edx
c01008c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01008c4:	01 d0                	add    %edx,%eax
c01008c6:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01008ca:	3c 64                	cmp    $0x64,%al
c01008cc:	75 b5                	jne    c0100883 <debuginfo_eip+0x220>
c01008ce:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01008d1:	89 c2                	mov    %eax,%edx
c01008d3:	89 d0                	mov    %edx,%eax
c01008d5:	01 c0                	add    %eax,%eax
c01008d7:	01 d0                	add    %edx,%eax
c01008d9:	c1 e0 02             	shl    $0x2,%eax
c01008dc:	89 c2                	mov    %eax,%edx
c01008de:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01008e1:	01 d0                	add    %edx,%eax
c01008e3:	8b 40 08             	mov    0x8(%eax),%eax
c01008e6:	85 c0                	test   %eax,%eax
c01008e8:	74 99                	je     c0100883 <debuginfo_eip+0x220>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c01008ea:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01008ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01008f0:	39 c2                	cmp    %eax,%edx
c01008f2:	7c 42                	jl     c0100936 <debuginfo_eip+0x2d3>
c01008f4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01008f7:	89 c2                	mov    %eax,%edx
c01008f9:	89 d0                	mov    %edx,%eax
c01008fb:	01 c0                	add    %eax,%eax
c01008fd:	01 d0                	add    %edx,%eax
c01008ff:	c1 e0 02             	shl    $0x2,%eax
c0100902:	89 c2                	mov    %eax,%edx
c0100904:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100907:	01 d0                	add    %edx,%eax
c0100909:	8b 10                	mov    (%eax),%edx
c010090b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010090e:	2b 45 ec             	sub    -0x14(%ebp),%eax
c0100911:	39 c2                	cmp    %eax,%edx
c0100913:	73 21                	jae    c0100936 <debuginfo_eip+0x2d3>
        info->eip_file = stabstr + stabs[lline].n_strx;
c0100915:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100918:	89 c2                	mov    %eax,%edx
c010091a:	89 d0                	mov    %edx,%eax
c010091c:	01 c0                	add    %eax,%eax
c010091e:	01 d0                	add    %edx,%eax
c0100920:	c1 e0 02             	shl    $0x2,%eax
c0100923:	89 c2                	mov    %eax,%edx
c0100925:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100928:	01 d0                	add    %edx,%eax
c010092a:	8b 10                	mov    (%eax),%edx
c010092c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010092f:	01 c2                	add    %eax,%edx
c0100931:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100934:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c0100936:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100939:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010093c:	39 c2                	cmp    %eax,%edx
c010093e:	7d 46                	jge    c0100986 <debuginfo_eip+0x323>
        for (lline = lfun + 1;
c0100940:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100943:	40                   	inc    %eax
c0100944:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0100947:	eb 16                	jmp    c010095f <debuginfo_eip+0x2fc>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c0100949:	8b 45 0c             	mov    0xc(%ebp),%eax
c010094c:	8b 40 14             	mov    0x14(%eax),%eax
c010094f:	8d 50 01             	lea    0x1(%eax),%edx
c0100952:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100955:	89 50 14             	mov    %edx,0x14(%eax)
             lline ++) {
c0100958:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010095b:	40                   	inc    %eax
c010095c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
c010095f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100962:	8b 45 d8             	mov    -0x28(%ebp),%eax
        for (lline = lfun + 1;
c0100965:	39 c2                	cmp    %eax,%edx
c0100967:	7d 1d                	jge    c0100986 <debuginfo_eip+0x323>
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100969:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010096c:	89 c2                	mov    %eax,%edx
c010096e:	89 d0                	mov    %edx,%eax
c0100970:	01 c0                	add    %eax,%eax
c0100972:	01 d0                	add    %edx,%eax
c0100974:	c1 e0 02             	shl    $0x2,%eax
c0100977:	89 c2                	mov    %eax,%edx
c0100979:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010097c:	01 d0                	add    %edx,%eax
c010097e:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100982:	3c a0                	cmp    $0xa0,%al
c0100984:	74 c3                	je     c0100949 <debuginfo_eip+0x2e6>
        }
    }
    return 0;
c0100986:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010098b:	c9                   	leave  
c010098c:	c3                   	ret    

c010098d <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c010098d:	f3 0f 1e fb          	endbr32 
c0100991:	55                   	push   %ebp
c0100992:	89 e5                	mov    %esp,%ebp
c0100994:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c0100997:	c7 04 24 a2 a1 10 c0 	movl   $0xc010a1a2,(%esp)
c010099e:	e8 27 f9 ff ff       	call   c01002ca <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c01009a3:	c7 44 24 04 36 00 10 	movl   $0xc0100036,0x4(%esp)
c01009aa:	c0 
c01009ab:	c7 04 24 bb a1 10 c0 	movl   $0xc010a1bb,(%esp)
c01009b2:	e8 13 f9 ff ff       	call   c01002ca <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
c01009b7:	c7 44 24 04 9a a0 10 	movl   $0xc010a09a,0x4(%esp)
c01009be:	c0 
c01009bf:	c7 04 24 d3 a1 10 c0 	movl   $0xc010a1d3,(%esp)
c01009c6:	e8 ff f8 ff ff       	call   c01002ca <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
c01009cb:	c7 44 24 04 00 30 12 	movl   $0xc0123000,0x4(%esp)
c01009d2:	c0 
c01009d3:	c7 04 24 eb a1 10 c0 	movl   $0xc010a1eb,(%esp)
c01009da:	e8 eb f8 ff ff       	call   c01002ca <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
c01009df:	c7 44 24 04 44 3f 12 	movl   $0xc0123f44,0x4(%esp)
c01009e6:	c0 
c01009e7:	c7 04 24 03 a2 10 c0 	movl   $0xc010a203,(%esp)
c01009ee:	e8 d7 f8 ff ff       	call   c01002ca <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c01009f3:	b8 44 3f 12 c0       	mov    $0xc0123f44,%eax
c01009f8:	2d 36 00 10 c0       	sub    $0xc0100036,%eax
c01009fd:	05 ff 03 00 00       	add    $0x3ff,%eax
c0100a02:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c0100a08:	85 c0                	test   %eax,%eax
c0100a0a:	0f 48 c2             	cmovs  %edx,%eax
c0100a0d:	c1 f8 0a             	sar    $0xa,%eax
c0100a10:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a14:	c7 04 24 1c a2 10 c0 	movl   $0xc010a21c,(%esp)
c0100a1b:	e8 aa f8 ff ff       	call   c01002ca <cprintf>
}
c0100a20:	90                   	nop
c0100a21:	c9                   	leave  
c0100a22:	c3                   	ret    

c0100a23 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c0100a23:	f3 0f 1e fb          	endbr32 
c0100a27:	55                   	push   %ebp
c0100a28:	89 e5                	mov    %esp,%ebp
c0100a2a:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c0100a30:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100a33:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a37:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a3a:	89 04 24             	mov    %eax,(%esp)
c0100a3d:	e8 21 fc ff ff       	call   c0100663 <debuginfo_eip>
c0100a42:	85 c0                	test   %eax,%eax
c0100a44:	74 15                	je     c0100a5b <print_debuginfo+0x38>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c0100a46:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a49:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a4d:	c7 04 24 46 a2 10 c0 	movl   $0xc010a246,(%esp)
c0100a54:	e8 71 f8 ff ff       	call   c01002ca <cprintf>
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
c0100a59:	eb 6c                	jmp    c0100ac7 <print_debuginfo+0xa4>
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100a5b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100a62:	eb 1b                	jmp    c0100a7f <print_debuginfo+0x5c>
            fnname[j] = info.eip_fn_name[j];
c0100a64:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0100a67:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a6a:	01 d0                	add    %edx,%eax
c0100a6c:	0f b6 10             	movzbl (%eax),%edx
c0100a6f:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100a75:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a78:	01 c8                	add    %ecx,%eax
c0100a7a:	88 10                	mov    %dl,(%eax)
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100a7c:	ff 45 f4             	incl   -0xc(%ebp)
c0100a7f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a82:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0100a85:	7c dd                	jl     c0100a64 <print_debuginfo+0x41>
        fnname[j] = '\0';
c0100a87:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
c0100a8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a90:	01 d0                	add    %edx,%eax
c0100a92:	c6 00 00             	movb   $0x0,(%eax)
                fnname, eip - info.eip_fn_addr);
c0100a95:	8b 45 ec             	mov    -0x14(%ebp),%eax
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c0100a98:	8b 55 08             	mov    0x8(%ebp),%edx
c0100a9b:	89 d1                	mov    %edx,%ecx
c0100a9d:	29 c1                	sub    %eax,%ecx
c0100a9f:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0100aa2:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100aa5:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0100aa9:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100aaf:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0100ab3:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100ab7:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100abb:	c7 04 24 62 a2 10 c0 	movl   $0xc010a262,(%esp)
c0100ac2:	e8 03 f8 ff ff       	call   c01002ca <cprintf>
}
c0100ac7:	90                   	nop
c0100ac8:	c9                   	leave  
c0100ac9:	c3                   	ret    

c0100aca <read_eip>:

// read_eip必须定义为常规函数而不是inline函数，因为这样的话在调用read_eip时会把当前指令的下一条指令的地址（也就是eip寄存器的值）压栈，
// 那么在进入read_eip函数内部后便可以从栈中获取到调用前eip寄存器的值。
static __noinline uint32_t
read_eip(void) {
c0100aca:	f3 0f 1e fb          	endbr32 
c0100ace:	55                   	push   %ebp
c0100acf:	89 e5                	mov    %esp,%ebp
c0100ad1:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c0100ad4:	8b 45 04             	mov    0x4(%ebp),%eax
c0100ad7:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
c0100ada:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0100add:	c9                   	leave  
c0100ade:	c3                   	ret    

c0100adf <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c0100adf:	f3 0f 1e fb          	endbr32 
c0100ae3:	55                   	push   %ebp
c0100ae4:	89 e5                	mov    %esp,%ebp
c0100ae6:	53                   	push   %ebx
c0100ae7:	83 ec 34             	sub    $0x34,%esp

// read_ebp必须定义为inline函数，否则获取的是执行read_ebp函数时的ebp寄存器的值
static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
c0100aea:	89 e8                	mov    %ebp,%eax
c0100aec:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return ebp;
c0100aef:	8b 45 e8             	mov    -0x18(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
     uint32_t ebp = read_ebp(), eip = read_eip();//对应(1)、(2)
c0100af2:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100af5:	e8 d0 ff ff ff       	call   c0100aca <read_eip>
c0100afa:	89 45 f0             	mov    %eax,-0x10(%ebp)
     int i;
     for (i = 0; i < STACKFRAME_DEPTH && ebp; i++)
c0100afd:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0100b04:	eb 6c                	jmp    c0100b72 <print_stackframe+0x93>
     {
        cprintf("ebp:0x%08x eip:0x%08x args:0x%08x 0x%08x 0x%08x 0x%08x\n", ebp, eip, ((uint32_t*)ebp + 2)[0], ((uint32_t*)ebp + 2)[1], ((uint32_t*)ebp + 2)[2], ((uint32_t*)ebp + 2)[3]); //对应(3.1)、(3.2)、(3.3)
c0100b06:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b09:	83 c0 14             	add    $0x14,%eax
c0100b0c:	8b 18                	mov    (%eax),%ebx
c0100b0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b11:	83 c0 10             	add    $0x10,%eax
c0100b14:	8b 08                	mov    (%eax),%ecx
c0100b16:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b19:	83 c0 0c             	add    $0xc,%eax
c0100b1c:	8b 10                	mov    (%eax),%edx
c0100b1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b21:	83 c0 08             	add    $0x8,%eax
c0100b24:	8b 00                	mov    (%eax),%eax
c0100b26:	89 5c 24 18          	mov    %ebx,0x18(%esp)
c0100b2a:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c0100b2e:	89 54 24 10          	mov    %edx,0x10(%esp)
c0100b32:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0100b36:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100b39:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100b3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b40:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b44:	c7 04 24 74 a2 10 c0 	movl   $0xc010a274,(%esp)
c0100b4b:	e8 7a f7 ff ff       	call   c01002ca <cprintf>
        print_debuginfo(eip - 1); //对应(3.4)，由于变量eip存放的是下一条指令的地址，因此将变量eip的值减去1，得到的指令地址就属于当前指令的范围了。由于只要输入的地址属于当前指令的起始和结束位置之间，print_debuginfo都能搜索到当前指令，因此这里减去1即可。
c0100b50:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100b53:	48                   	dec    %eax
c0100b54:	89 04 24             	mov    %eax,(%esp)
c0100b57:	e8 c7 fe ff ff       	call   c0100a23 <print_debuginfo>
        eip = *(uint32_t*)(ebp + 4), ebp = *(uint32_t*)ebp; //对应(3.5)，这里默认ss基址为0
c0100b5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b5f:	83 c0 04             	add    $0x4,%eax
c0100b62:	8b 00                	mov    (%eax),%eax
c0100b64:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0100b67:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b6a:	8b 00                	mov    (%eax),%eax
c0100b6c:	89 45 f4             	mov    %eax,-0xc(%ebp)
     for (i = 0; i < STACKFRAME_DEPTH && ebp; i++)
c0100b6f:	ff 45 ec             	incl   -0x14(%ebp)
c0100b72:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
c0100b76:	7f 06                	jg     c0100b7e <print_stackframe+0x9f>
c0100b78:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100b7c:	75 88                	jne    c0100b06 <print_stackframe+0x27>
     }
}
c0100b7e:	90                   	nop
c0100b7f:	83 c4 34             	add    $0x34,%esp
c0100b82:	5b                   	pop    %ebx
c0100b83:	5d                   	pop    %ebp
c0100b84:	c3                   	ret    

c0100b85 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100b85:	f3 0f 1e fb          	endbr32 
c0100b89:	55                   	push   %ebp
c0100b8a:	89 e5                	mov    %esp,%ebp
c0100b8c:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
c0100b8f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b96:	eb 0c                	jmp    c0100ba4 <parse+0x1f>
            *buf ++ = '\0';
c0100b98:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b9b:	8d 50 01             	lea    0x1(%eax),%edx
c0100b9e:	89 55 08             	mov    %edx,0x8(%ebp)
c0100ba1:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100ba4:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ba7:	0f b6 00             	movzbl (%eax),%eax
c0100baa:	84 c0                	test   %al,%al
c0100bac:	74 1d                	je     c0100bcb <parse+0x46>
c0100bae:	8b 45 08             	mov    0x8(%ebp),%eax
c0100bb1:	0f b6 00             	movzbl (%eax),%eax
c0100bb4:	0f be c0             	movsbl %al,%eax
c0100bb7:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100bbb:	c7 04 24 2c a3 10 c0 	movl   $0xc010a32c,(%esp)
c0100bc2:	e8 ed 8a 00 00       	call   c01096b4 <strchr>
c0100bc7:	85 c0                	test   %eax,%eax
c0100bc9:	75 cd                	jne    c0100b98 <parse+0x13>
        }
        if (*buf == '\0') {
c0100bcb:	8b 45 08             	mov    0x8(%ebp),%eax
c0100bce:	0f b6 00             	movzbl (%eax),%eax
c0100bd1:	84 c0                	test   %al,%al
c0100bd3:	74 65                	je     c0100c3a <parse+0xb5>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100bd5:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100bd9:	75 14                	jne    c0100bef <parse+0x6a>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100bdb:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
c0100be2:	00 
c0100be3:	c7 04 24 31 a3 10 c0 	movl   $0xc010a331,(%esp)
c0100bea:	e8 db f6 ff ff       	call   c01002ca <cprintf>
        }
        argv[argc ++] = buf;
c0100bef:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100bf2:	8d 50 01             	lea    0x1(%eax),%edx
c0100bf5:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100bf8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100bff:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100c02:	01 c2                	add    %eax,%edx
c0100c04:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c07:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100c09:	eb 03                	jmp    c0100c0e <parse+0x89>
            buf ++;
c0100c0b:	ff 45 08             	incl   0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100c0e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c11:	0f b6 00             	movzbl (%eax),%eax
c0100c14:	84 c0                	test   %al,%al
c0100c16:	74 8c                	je     c0100ba4 <parse+0x1f>
c0100c18:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c1b:	0f b6 00             	movzbl (%eax),%eax
c0100c1e:	0f be c0             	movsbl %al,%eax
c0100c21:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c25:	c7 04 24 2c a3 10 c0 	movl   $0xc010a32c,(%esp)
c0100c2c:	e8 83 8a 00 00       	call   c01096b4 <strchr>
c0100c31:	85 c0                	test   %eax,%eax
c0100c33:	74 d6                	je     c0100c0b <parse+0x86>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100c35:	e9 6a ff ff ff       	jmp    c0100ba4 <parse+0x1f>
            break;
c0100c3a:	90                   	nop
        }
    }
    return argc;
c0100c3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100c3e:	c9                   	leave  
c0100c3f:	c3                   	ret    

c0100c40 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100c40:	f3 0f 1e fb          	endbr32 
c0100c44:	55                   	push   %ebp
c0100c45:	89 e5                	mov    %esp,%ebp
c0100c47:	53                   	push   %ebx
c0100c48:	83 ec 64             	sub    $0x64,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100c4b:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100c4e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c52:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c55:	89 04 24             	mov    %eax,(%esp)
c0100c58:	e8 28 ff ff ff       	call   c0100b85 <parse>
c0100c5d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100c60:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100c64:	75 0a                	jne    c0100c70 <runcmd+0x30>
        return 0;
c0100c66:	b8 00 00 00 00       	mov    $0x0,%eax
c0100c6b:	e9 83 00 00 00       	jmp    c0100cf3 <runcmd+0xb3>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c70:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100c77:	eb 5a                	jmp    c0100cd3 <runcmd+0x93>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100c79:	8b 4d b0             	mov    -0x50(%ebp),%ecx
c0100c7c:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c7f:	89 d0                	mov    %edx,%eax
c0100c81:	01 c0                	add    %eax,%eax
c0100c83:	01 d0                	add    %edx,%eax
c0100c85:	c1 e0 02             	shl    $0x2,%eax
c0100c88:	05 00 00 12 c0       	add    $0xc0120000,%eax
c0100c8d:	8b 00                	mov    (%eax),%eax
c0100c8f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0100c93:	89 04 24             	mov    %eax,(%esp)
c0100c96:	e8 75 89 00 00       	call   c0109610 <strcmp>
c0100c9b:	85 c0                	test   %eax,%eax
c0100c9d:	75 31                	jne    c0100cd0 <runcmd+0x90>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100c9f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100ca2:	89 d0                	mov    %edx,%eax
c0100ca4:	01 c0                	add    %eax,%eax
c0100ca6:	01 d0                	add    %edx,%eax
c0100ca8:	c1 e0 02             	shl    $0x2,%eax
c0100cab:	05 08 00 12 c0       	add    $0xc0120008,%eax
c0100cb0:	8b 10                	mov    (%eax),%edx
c0100cb2:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100cb5:	83 c0 04             	add    $0x4,%eax
c0100cb8:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0100cbb:	8d 59 ff             	lea    -0x1(%ecx),%ebx
c0100cbe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
c0100cc1:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100cc5:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100cc9:	89 1c 24             	mov    %ebx,(%esp)
c0100ccc:	ff d2                	call   *%edx
c0100cce:	eb 23                	jmp    c0100cf3 <runcmd+0xb3>
    for (i = 0; i < NCOMMANDS; i ++) {
c0100cd0:	ff 45 f4             	incl   -0xc(%ebp)
c0100cd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100cd6:	83 f8 02             	cmp    $0x2,%eax
c0100cd9:	76 9e                	jbe    c0100c79 <runcmd+0x39>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100cdb:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100cde:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100ce2:	c7 04 24 4f a3 10 c0 	movl   $0xc010a34f,(%esp)
c0100ce9:	e8 dc f5 ff ff       	call   c01002ca <cprintf>
    return 0;
c0100cee:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cf3:	83 c4 64             	add    $0x64,%esp
c0100cf6:	5b                   	pop    %ebx
c0100cf7:	5d                   	pop    %ebp
c0100cf8:	c3                   	ret    

c0100cf9 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100cf9:	f3 0f 1e fb          	endbr32 
c0100cfd:	55                   	push   %ebp
c0100cfe:	89 e5                	mov    %esp,%ebp
c0100d00:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100d03:	c7 04 24 68 a3 10 c0 	movl   $0xc010a368,(%esp)
c0100d0a:	e8 bb f5 ff ff       	call   c01002ca <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
c0100d0f:	c7 04 24 90 a3 10 c0 	movl   $0xc010a390,(%esp)
c0100d16:	e8 af f5 ff ff       	call   c01002ca <cprintf>

    if (tf != NULL) {
c0100d1b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100d1f:	74 0b                	je     c0100d2c <kmonitor+0x33>
        print_trapframe(tf);
c0100d21:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d24:	89 04 24             	mov    %eax,(%esp)
c0100d27:	e8 d9 0e 00 00       	call   c0101c05 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100d2c:	c7 04 24 b5 a3 10 c0 	movl   $0xc010a3b5,(%esp)
c0100d33:	e8 45 f6 ff ff       	call   c010037d <readline>
c0100d38:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100d3b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100d3f:	74 eb                	je     c0100d2c <kmonitor+0x33>
            if (runcmd(buf, tf) < 0) {
c0100d41:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d44:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d48:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d4b:	89 04 24             	mov    %eax,(%esp)
c0100d4e:	e8 ed fe ff ff       	call   c0100c40 <runcmd>
c0100d53:	85 c0                	test   %eax,%eax
c0100d55:	78 02                	js     c0100d59 <kmonitor+0x60>
        if ((buf = readline("K> ")) != NULL) {
c0100d57:	eb d3                	jmp    c0100d2c <kmonitor+0x33>
                break;
c0100d59:	90                   	nop
            }
        }
    }
}
c0100d5a:	90                   	nop
c0100d5b:	c9                   	leave  
c0100d5c:	c3                   	ret    

c0100d5d <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100d5d:	f3 0f 1e fb          	endbr32 
c0100d61:	55                   	push   %ebp
c0100d62:	89 e5                	mov    %esp,%ebp
c0100d64:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100d67:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100d6e:	eb 3d                	jmp    c0100dad <mon_help+0x50>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100d70:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100d73:	89 d0                	mov    %edx,%eax
c0100d75:	01 c0                	add    %eax,%eax
c0100d77:	01 d0                	add    %edx,%eax
c0100d79:	c1 e0 02             	shl    $0x2,%eax
c0100d7c:	05 04 00 12 c0       	add    $0xc0120004,%eax
c0100d81:	8b 08                	mov    (%eax),%ecx
c0100d83:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100d86:	89 d0                	mov    %edx,%eax
c0100d88:	01 c0                	add    %eax,%eax
c0100d8a:	01 d0                	add    %edx,%eax
c0100d8c:	c1 e0 02             	shl    $0x2,%eax
c0100d8f:	05 00 00 12 c0       	add    $0xc0120000,%eax
c0100d94:	8b 00                	mov    (%eax),%eax
c0100d96:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100d9a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d9e:	c7 04 24 b9 a3 10 c0 	movl   $0xc010a3b9,(%esp)
c0100da5:	e8 20 f5 ff ff       	call   c01002ca <cprintf>
    for (i = 0; i < NCOMMANDS; i ++) {
c0100daa:	ff 45 f4             	incl   -0xc(%ebp)
c0100dad:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100db0:	83 f8 02             	cmp    $0x2,%eax
c0100db3:	76 bb                	jbe    c0100d70 <mon_help+0x13>
    }
    return 0;
c0100db5:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100dba:	c9                   	leave  
c0100dbb:	c3                   	ret    

c0100dbc <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100dbc:	f3 0f 1e fb          	endbr32 
c0100dc0:	55                   	push   %ebp
c0100dc1:	89 e5                	mov    %esp,%ebp
c0100dc3:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100dc6:	e8 c2 fb ff ff       	call   c010098d <print_kerninfo>
    return 0;
c0100dcb:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100dd0:	c9                   	leave  
c0100dd1:	c3                   	ret    

c0100dd2 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100dd2:	f3 0f 1e fb          	endbr32 
c0100dd6:	55                   	push   %ebp
c0100dd7:	89 e5                	mov    %esp,%ebp
c0100dd9:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100ddc:	e8 fe fc ff ff       	call   c0100adf <print_stackframe>
    return 0;
c0100de1:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100de6:	c9                   	leave  
c0100de7:	c3                   	ret    

c0100de8 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c0100de8:	f3 0f 1e fb          	endbr32 
c0100dec:	55                   	push   %ebp
c0100ded:	89 e5                	mov    %esp,%ebp
c0100def:	83 ec 28             	sub    $0x28,%esp
c0100df2:	66 c7 45 ee 43 00    	movw   $0x43,-0x12(%ebp)
c0100df8:	c6 45 ed 34          	movb   $0x34,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100dfc:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100e00:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100e04:	ee                   	out    %al,(%dx)
}
c0100e05:	90                   	nop
c0100e06:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0100e0c:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100e10:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100e14:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100e18:	ee                   	out    %al,(%dx)
}
c0100e19:	90                   	nop
c0100e1a:	66 c7 45 f6 40 00    	movw   $0x40,-0xa(%ebp)
c0100e20:	c6 45 f5 2e          	movb   $0x2e,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100e24:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100e28:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100e2c:	ee                   	out    %al,(%dx)
}
c0100e2d:	90                   	nop
    // 设置时钟每秒中断100次
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0100e2e:	c7 05 28 3f 12 c0 00 	movl   $0x0,0xc0123f28
c0100e35:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100e38:	c7 04 24 c2 a3 10 c0 	movl   $0xc010a3c2,(%esp)
c0100e3f:	e8 86 f4 ff ff       	call   c01002ca <cprintf>
    pic_enable(IRQ_TIMER); // 通过中断控制器使能时钟中断
c0100e44:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100e4b:	e8 95 09 00 00       	call   c01017e5 <pic_enable>
}
c0100e50:	90                   	nop
c0100e51:	c9                   	leave  
c0100e52:	c3                   	ret    

c0100e53 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0100e53:	55                   	push   %ebp
c0100e54:	89 e5                	mov    %esp,%ebp
c0100e56:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0100e59:	9c                   	pushf  
c0100e5a:	58                   	pop    %eax
c0100e5b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0100e5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0100e61:	25 00 02 00 00       	and    $0x200,%eax
c0100e66:	85 c0                	test   %eax,%eax
c0100e68:	74 0c                	je     c0100e76 <__intr_save+0x23>
        intr_disable();
c0100e6a:	e8 05 0b 00 00       	call   c0101974 <intr_disable>
        return 1;
c0100e6f:	b8 01 00 00 00       	mov    $0x1,%eax
c0100e74:	eb 05                	jmp    c0100e7b <__intr_save+0x28>
    }
    return 0;
c0100e76:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100e7b:	c9                   	leave  
c0100e7c:	c3                   	ret    

c0100e7d <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0100e7d:	55                   	push   %ebp
c0100e7e:	89 e5                	mov    %esp,%ebp
c0100e80:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0100e83:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100e87:	74 05                	je     c0100e8e <__intr_restore+0x11>
        intr_enable();
c0100e89:	e8 da 0a 00 00       	call   c0101968 <intr_enable>
    }
}
c0100e8e:	90                   	nop
c0100e8f:	c9                   	leave  
c0100e90:	c3                   	ret    

c0100e91 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c0100e91:	f3 0f 1e fb          	endbr32 
c0100e95:	55                   	push   %ebp
c0100e96:	89 e5                	mov    %esp,%ebp
c0100e98:	83 ec 10             	sub    $0x10,%esp
c0100e9b:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100ea1:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100ea5:	89 c2                	mov    %eax,%edx
c0100ea7:	ec                   	in     (%dx),%al
c0100ea8:	88 45 f1             	mov    %al,-0xf(%ebp)
c0100eab:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
c0100eb1:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100eb5:	89 c2                	mov    %eax,%edx
c0100eb7:	ec                   	in     (%dx),%al
c0100eb8:	88 45 f5             	mov    %al,-0xb(%ebp)
c0100ebb:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
c0100ec1:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100ec5:	89 c2                	mov    %eax,%edx
c0100ec7:	ec                   	in     (%dx),%al
c0100ec8:	88 45 f9             	mov    %al,-0x7(%ebp)
c0100ecb:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
c0100ed1:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0100ed5:	89 c2                	mov    %eax,%edx
c0100ed7:	ec                   	in     (%dx),%al
c0100ed8:	88 45 fd             	mov    %al,-0x3(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c0100edb:	90                   	nop
c0100edc:	c9                   	leave  
c0100edd:	c3                   	ret    

c0100ede <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c0100ede:	f3 0f 1e fb          	endbr32 
c0100ee2:	55                   	push   %ebp
c0100ee3:	89 e5                	mov    %esp,%ebp
c0100ee5:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0100ee8:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c0100eef:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100ef2:	0f b7 00             	movzwl (%eax),%eax
c0100ef5:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
c0100ef9:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100efc:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c0100f01:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f04:	0f b7 00             	movzwl (%eax),%eax
c0100f07:	0f b7 c0             	movzwl %ax,%eax
c0100f0a:	3d 5a a5 00 00       	cmp    $0xa55a,%eax
c0100f0f:	74 12                	je     c0100f23 <cga_init+0x45>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c0100f11:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c0100f18:	66 c7 05 46 34 12 c0 	movw   $0x3b4,0xc0123446
c0100f1f:	b4 03 
c0100f21:	eb 13                	jmp    c0100f36 <cga_init+0x58>
    } else {
        *cp = was;
c0100f23:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f26:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0100f2a:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0100f2d:	66 c7 05 46 34 12 c0 	movw   $0x3d4,0xc0123446
c0100f34:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100f36:	0f b7 05 46 34 12 c0 	movzwl 0xc0123446,%eax
c0100f3d:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
c0100f41:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f45:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100f49:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0100f4d:	ee                   	out    %al,(%dx)
}
c0100f4e:	90                   	nop
    pos = inb(addr_6845 + 1) << 8;
c0100f4f:	0f b7 05 46 34 12 c0 	movzwl 0xc0123446,%eax
c0100f56:	40                   	inc    %eax
c0100f57:	0f b7 c0             	movzwl %ax,%eax
c0100f5a:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f5e:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0100f62:	89 c2                	mov    %eax,%edx
c0100f64:	ec                   	in     (%dx),%al
c0100f65:	88 45 e9             	mov    %al,-0x17(%ebp)
    return data;
c0100f68:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100f6c:	0f b6 c0             	movzbl %al,%eax
c0100f6f:	c1 e0 08             	shl    $0x8,%eax
c0100f72:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
c0100f75:	0f b7 05 46 34 12 c0 	movzwl 0xc0123446,%eax
c0100f7c:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0100f80:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f84:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100f88:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100f8c:	ee                   	out    %al,(%dx)
}
c0100f8d:	90                   	nop
    pos |= inb(addr_6845 + 1);
c0100f8e:	0f b7 05 46 34 12 c0 	movzwl 0xc0123446,%eax
c0100f95:	40                   	inc    %eax
c0100f96:	0f b7 c0             	movzwl %ax,%eax
c0100f99:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f9d:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100fa1:	89 c2                	mov    %eax,%edx
c0100fa3:	ec                   	in     (%dx),%al
c0100fa4:	88 45 f1             	mov    %al,-0xf(%ebp)
    return data;
c0100fa7:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100fab:	0f b6 c0             	movzbl %al,%eax
c0100fae:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
c0100fb1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100fb4:	a3 40 34 12 c0       	mov    %eax,0xc0123440
    crt_pos = pos;
c0100fb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100fbc:	0f b7 c0             	movzwl %ax,%eax
c0100fbf:	66 a3 44 34 12 c0    	mov    %ax,0xc0123444
}
c0100fc5:	90                   	nop
c0100fc6:	c9                   	leave  
c0100fc7:	c3                   	ret    

c0100fc8 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c0100fc8:	f3 0f 1e fb          	endbr32 
c0100fcc:	55                   	push   %ebp
c0100fcd:	89 e5                	mov    %esp,%ebp
c0100fcf:	83 ec 48             	sub    $0x48,%esp
c0100fd2:	66 c7 45 d2 fa 03    	movw   $0x3fa,-0x2e(%ebp)
c0100fd8:	c6 45 d1 00          	movb   $0x0,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100fdc:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c0100fe0:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c0100fe4:	ee                   	out    %al,(%dx)
}
c0100fe5:	90                   	nop
c0100fe6:	66 c7 45 d6 fb 03    	movw   $0x3fb,-0x2a(%ebp)
c0100fec:	c6 45 d5 80          	movb   $0x80,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100ff0:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0100ff4:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0100ff8:	ee                   	out    %al,(%dx)
}
c0100ff9:	90                   	nop
c0100ffa:	66 c7 45 da f8 03    	movw   $0x3f8,-0x26(%ebp)
c0101000:	c6 45 d9 0c          	movb   $0xc,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101004:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101008:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c010100c:	ee                   	out    %al,(%dx)
}
c010100d:	90                   	nop
c010100e:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
c0101014:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101018:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c010101c:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0101020:	ee                   	out    %al,(%dx)
}
c0101021:	90                   	nop
c0101022:	66 c7 45 e2 fb 03    	movw   $0x3fb,-0x1e(%ebp)
c0101028:	c6 45 e1 03          	movb   $0x3,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010102c:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0101030:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0101034:	ee                   	out    %al,(%dx)
}
c0101035:	90                   	nop
c0101036:	66 c7 45 e6 fc 03    	movw   $0x3fc,-0x1a(%ebp)
c010103c:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101040:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101044:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101048:	ee                   	out    %al,(%dx)
}
c0101049:	90                   	nop
c010104a:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c0101050:	c6 45 e9 01          	movb   $0x1,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101054:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101058:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c010105c:	ee                   	out    %al,(%dx)
}
c010105d:	90                   	nop
c010105e:	66 c7 45 ee fd 03    	movw   $0x3fd,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101064:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
c0101068:	89 c2                	mov    %eax,%edx
c010106a:	ec                   	in     (%dx),%al
c010106b:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
c010106e:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
    // Enable rcv interrupts，使能串口1接收字符后产生中断
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c0101072:	3c ff                	cmp    $0xff,%al
c0101074:	0f 95 c0             	setne  %al
c0101077:	0f b6 c0             	movzbl %al,%eax
c010107a:	a3 48 34 12 c0       	mov    %eax,0xc0123448
c010107f:	66 c7 45 f2 fa 03    	movw   $0x3fa,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101085:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101089:	89 c2                	mov    %eax,%edx
c010108b:	ec                   	in     (%dx),%al
c010108c:	88 45 f1             	mov    %al,-0xf(%ebp)
c010108f:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c0101095:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101099:	89 c2                	mov    %eax,%edx
c010109b:	ec                   	in     (%dx),%al
c010109c:	88 45 f5             	mov    %al,-0xb(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c010109f:	a1 48 34 12 c0       	mov    0xc0123448,%eax
c01010a4:	85 c0                	test   %eax,%eax
c01010a6:	74 0c                	je     c01010b4 <serial_init+0xec>
        pic_enable(IRQ_COM1); // 通过中断控制器使能串口1中断
c01010a8:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c01010af:	e8 31 07 00 00       	call   c01017e5 <pic_enable>
    }
}
c01010b4:	90                   	nop
c01010b5:	c9                   	leave  
c01010b6:	c3                   	ret    

c01010b7 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c01010b7:	f3 0f 1e fb          	endbr32 
c01010bb:	55                   	push   %ebp
c01010bc:	89 e5                	mov    %esp,%ebp
c01010be:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c01010c1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01010c8:	eb 08                	jmp    c01010d2 <lpt_putc_sub+0x1b>
        delay();
c01010ca:	e8 c2 fd ff ff       	call   c0100e91 <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c01010cf:	ff 45 fc             	incl   -0x4(%ebp)
c01010d2:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
c01010d8:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01010dc:	89 c2                	mov    %eax,%edx
c01010de:	ec                   	in     (%dx),%al
c01010df:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01010e2:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01010e6:	84 c0                	test   %al,%al
c01010e8:	78 09                	js     c01010f3 <lpt_putc_sub+0x3c>
c01010ea:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c01010f1:	7e d7                	jle    c01010ca <lpt_putc_sub+0x13>
    }
    outb(LPTPORT + 0, c);
c01010f3:	8b 45 08             	mov    0x8(%ebp),%eax
c01010f6:	0f b6 c0             	movzbl %al,%eax
c01010f9:	66 c7 45 ee 78 03    	movw   $0x378,-0x12(%ebp)
c01010ff:	88 45 ed             	mov    %al,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101102:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101106:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c010110a:	ee                   	out    %al,(%dx)
}
c010110b:	90                   	nop
c010110c:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
c0101112:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101116:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c010111a:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010111e:	ee                   	out    %al,(%dx)
}
c010111f:	90                   	nop
c0101120:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
c0101126:	c6 45 f5 08          	movb   $0x8,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010112a:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c010112e:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101132:	ee                   	out    %al,(%dx)
}
c0101133:	90                   	nop
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c0101134:	90                   	nop
c0101135:	c9                   	leave  
c0101136:	c3                   	ret    

c0101137 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c0101137:	f3 0f 1e fb          	endbr32 
c010113b:	55                   	push   %ebp
c010113c:	89 e5                	mov    %esp,%ebp
c010113e:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c0101141:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c0101145:	74 0d                	je     c0101154 <lpt_putc+0x1d>
        lpt_putc_sub(c);
c0101147:	8b 45 08             	mov    0x8(%ebp),%eax
c010114a:	89 04 24             	mov    %eax,(%esp)
c010114d:	e8 65 ff ff ff       	call   c01010b7 <lpt_putc_sub>
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
c0101152:	eb 24                	jmp    c0101178 <lpt_putc+0x41>
        lpt_putc_sub('\b');
c0101154:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c010115b:	e8 57 ff ff ff       	call   c01010b7 <lpt_putc_sub>
        lpt_putc_sub(' ');
c0101160:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0101167:	e8 4b ff ff ff       	call   c01010b7 <lpt_putc_sub>
        lpt_putc_sub('\b');
c010116c:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101173:	e8 3f ff ff ff       	call   c01010b7 <lpt_putc_sub>
}
c0101178:	90                   	nop
c0101179:	c9                   	leave  
c010117a:	c3                   	ret    

c010117b <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c010117b:	f3 0f 1e fb          	endbr32 
c010117f:	55                   	push   %ebp
c0101180:	89 e5                	mov    %esp,%ebp
c0101182:	53                   	push   %ebx
c0101183:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
c0101186:	8b 45 08             	mov    0x8(%ebp),%eax
c0101189:	25 00 ff ff ff       	and    $0xffffff00,%eax
c010118e:	85 c0                	test   %eax,%eax
c0101190:	75 07                	jne    c0101199 <cga_putc+0x1e>
        c |= 0x0700;
c0101192:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c0101199:	8b 45 08             	mov    0x8(%ebp),%eax
c010119c:	0f b6 c0             	movzbl %al,%eax
c010119f:	83 f8 0d             	cmp    $0xd,%eax
c01011a2:	74 72                	je     c0101216 <cga_putc+0x9b>
c01011a4:	83 f8 0d             	cmp    $0xd,%eax
c01011a7:	0f 8f a3 00 00 00    	jg     c0101250 <cga_putc+0xd5>
c01011ad:	83 f8 08             	cmp    $0x8,%eax
c01011b0:	74 0a                	je     c01011bc <cga_putc+0x41>
c01011b2:	83 f8 0a             	cmp    $0xa,%eax
c01011b5:	74 4c                	je     c0101203 <cga_putc+0x88>
c01011b7:	e9 94 00 00 00       	jmp    c0101250 <cga_putc+0xd5>
    case '\b':
        if (crt_pos > 0) {
c01011bc:	0f b7 05 44 34 12 c0 	movzwl 0xc0123444,%eax
c01011c3:	85 c0                	test   %eax,%eax
c01011c5:	0f 84 af 00 00 00    	je     c010127a <cga_putc+0xff>
            crt_pos --;
c01011cb:	0f b7 05 44 34 12 c0 	movzwl 0xc0123444,%eax
c01011d2:	48                   	dec    %eax
c01011d3:	0f b7 c0             	movzwl %ax,%eax
c01011d6:	66 a3 44 34 12 c0    	mov    %ax,0xc0123444
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c01011dc:	8b 45 08             	mov    0x8(%ebp),%eax
c01011df:	98                   	cwtl   
c01011e0:	25 00 ff ff ff       	and    $0xffffff00,%eax
c01011e5:	98                   	cwtl   
c01011e6:	83 c8 20             	or     $0x20,%eax
c01011e9:	98                   	cwtl   
c01011ea:	8b 15 40 34 12 c0    	mov    0xc0123440,%edx
c01011f0:	0f b7 0d 44 34 12 c0 	movzwl 0xc0123444,%ecx
c01011f7:	01 c9                	add    %ecx,%ecx
c01011f9:	01 ca                	add    %ecx,%edx
c01011fb:	0f b7 c0             	movzwl %ax,%eax
c01011fe:	66 89 02             	mov    %ax,(%edx)
        }
        break;
c0101201:	eb 77                	jmp    c010127a <cga_putc+0xff>
    case '\n':
        crt_pos += CRT_COLS;
c0101203:	0f b7 05 44 34 12 c0 	movzwl 0xc0123444,%eax
c010120a:	83 c0 50             	add    $0x50,%eax
c010120d:	0f b7 c0             	movzwl %ax,%eax
c0101210:	66 a3 44 34 12 c0    	mov    %ax,0xc0123444
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c0101216:	0f b7 1d 44 34 12 c0 	movzwl 0xc0123444,%ebx
c010121d:	0f b7 0d 44 34 12 c0 	movzwl 0xc0123444,%ecx
c0101224:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
c0101229:	89 c8                	mov    %ecx,%eax
c010122b:	f7 e2                	mul    %edx
c010122d:	c1 ea 06             	shr    $0x6,%edx
c0101230:	89 d0                	mov    %edx,%eax
c0101232:	c1 e0 02             	shl    $0x2,%eax
c0101235:	01 d0                	add    %edx,%eax
c0101237:	c1 e0 04             	shl    $0x4,%eax
c010123a:	29 c1                	sub    %eax,%ecx
c010123c:	89 c8                	mov    %ecx,%eax
c010123e:	0f b7 c0             	movzwl %ax,%eax
c0101241:	29 c3                	sub    %eax,%ebx
c0101243:	89 d8                	mov    %ebx,%eax
c0101245:	0f b7 c0             	movzwl %ax,%eax
c0101248:	66 a3 44 34 12 c0    	mov    %ax,0xc0123444
        break;
c010124e:	eb 2b                	jmp    c010127b <cga_putc+0x100>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c0101250:	8b 0d 40 34 12 c0    	mov    0xc0123440,%ecx
c0101256:	0f b7 05 44 34 12 c0 	movzwl 0xc0123444,%eax
c010125d:	8d 50 01             	lea    0x1(%eax),%edx
c0101260:	0f b7 d2             	movzwl %dx,%edx
c0101263:	66 89 15 44 34 12 c0 	mov    %dx,0xc0123444
c010126a:	01 c0                	add    %eax,%eax
c010126c:	8d 14 01             	lea    (%ecx,%eax,1),%edx
c010126f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101272:	0f b7 c0             	movzwl %ax,%eax
c0101275:	66 89 02             	mov    %ax,(%edx)
        break;
c0101278:	eb 01                	jmp    c010127b <cga_putc+0x100>
        break;
c010127a:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c010127b:	0f b7 05 44 34 12 c0 	movzwl 0xc0123444,%eax
c0101282:	3d cf 07 00 00       	cmp    $0x7cf,%eax
c0101287:	76 5d                	jbe    c01012e6 <cga_putc+0x16b>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c0101289:	a1 40 34 12 c0       	mov    0xc0123440,%eax
c010128e:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c0101294:	a1 40 34 12 c0       	mov    0xc0123440,%eax
c0101299:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
c01012a0:	00 
c01012a1:	89 54 24 04          	mov    %edx,0x4(%esp)
c01012a5:	89 04 24             	mov    %eax,(%esp)
c01012a8:	e8 0c 86 00 00       	call   c01098b9 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c01012ad:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c01012b4:	eb 14                	jmp    c01012ca <cga_putc+0x14f>
            crt_buf[i] = 0x0700 | ' ';
c01012b6:	a1 40 34 12 c0       	mov    0xc0123440,%eax
c01012bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01012be:	01 d2                	add    %edx,%edx
c01012c0:	01 d0                	add    %edx,%eax
c01012c2:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c01012c7:	ff 45 f4             	incl   -0xc(%ebp)
c01012ca:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c01012d1:	7e e3                	jle    c01012b6 <cga_putc+0x13b>
        }
        crt_pos -= CRT_COLS;
c01012d3:	0f b7 05 44 34 12 c0 	movzwl 0xc0123444,%eax
c01012da:	83 e8 50             	sub    $0x50,%eax
c01012dd:	0f b7 c0             	movzwl %ax,%eax
c01012e0:	66 a3 44 34 12 c0    	mov    %ax,0xc0123444
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c01012e6:	0f b7 05 46 34 12 c0 	movzwl 0xc0123446,%eax
c01012ed:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
c01012f1:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01012f5:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01012f9:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01012fd:	ee                   	out    %al,(%dx)
}
c01012fe:	90                   	nop
    outb(addr_6845 + 1, crt_pos >> 8);
c01012ff:	0f b7 05 44 34 12 c0 	movzwl 0xc0123444,%eax
c0101306:	c1 e8 08             	shr    $0x8,%eax
c0101309:	0f b7 c0             	movzwl %ax,%eax
c010130c:	0f b6 c0             	movzbl %al,%eax
c010130f:	0f b7 15 46 34 12 c0 	movzwl 0xc0123446,%edx
c0101316:	42                   	inc    %edx
c0101317:	0f b7 d2             	movzwl %dx,%edx
c010131a:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c010131e:	88 45 e9             	mov    %al,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101321:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101325:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101329:	ee                   	out    %al,(%dx)
}
c010132a:	90                   	nop
    outb(addr_6845, 15);
c010132b:	0f b7 05 46 34 12 c0 	movzwl 0xc0123446,%eax
c0101332:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0101336:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010133a:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c010133e:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101342:	ee                   	out    %al,(%dx)
}
c0101343:	90                   	nop
    outb(addr_6845 + 1, crt_pos);
c0101344:	0f b7 05 44 34 12 c0 	movzwl 0xc0123444,%eax
c010134b:	0f b6 c0             	movzbl %al,%eax
c010134e:	0f b7 15 46 34 12 c0 	movzwl 0xc0123446,%edx
c0101355:	42                   	inc    %edx
c0101356:	0f b7 d2             	movzwl %dx,%edx
c0101359:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
c010135d:	88 45 f1             	mov    %al,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101360:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101364:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101368:	ee                   	out    %al,(%dx)
}
c0101369:	90                   	nop
}
c010136a:	90                   	nop
c010136b:	83 c4 34             	add    $0x34,%esp
c010136e:	5b                   	pop    %ebx
c010136f:	5d                   	pop    %ebp
c0101370:	c3                   	ret    

c0101371 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c0101371:	f3 0f 1e fb          	endbr32 
c0101375:	55                   	push   %ebp
c0101376:	89 e5                	mov    %esp,%ebp
c0101378:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c010137b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101382:	eb 08                	jmp    c010138c <serial_putc_sub+0x1b>
        delay();
c0101384:	e8 08 fb ff ff       	call   c0100e91 <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c0101389:	ff 45 fc             	incl   -0x4(%ebp)
c010138c:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101392:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0101396:	89 c2                	mov    %eax,%edx
c0101398:	ec                   	in     (%dx),%al
c0101399:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c010139c:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01013a0:	0f b6 c0             	movzbl %al,%eax
c01013a3:	83 e0 20             	and    $0x20,%eax
c01013a6:	85 c0                	test   %eax,%eax
c01013a8:	75 09                	jne    c01013b3 <serial_putc_sub+0x42>
c01013aa:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c01013b1:	7e d1                	jle    c0101384 <serial_putc_sub+0x13>
    }
    outb(COM1 + COM_TX, c);
c01013b3:	8b 45 08             	mov    0x8(%ebp),%eax
c01013b6:	0f b6 c0             	movzbl %al,%eax
c01013b9:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c01013bf:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01013c2:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c01013c6:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c01013ca:	ee                   	out    %al,(%dx)
}
c01013cb:	90                   	nop
}
c01013cc:	90                   	nop
c01013cd:	c9                   	leave  
c01013ce:	c3                   	ret    

c01013cf <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c01013cf:	f3 0f 1e fb          	endbr32 
c01013d3:	55                   	push   %ebp
c01013d4:	89 e5                	mov    %esp,%ebp
c01013d6:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c01013d9:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c01013dd:	74 0d                	je     c01013ec <serial_putc+0x1d>
        serial_putc_sub(c);
c01013df:	8b 45 08             	mov    0x8(%ebp),%eax
c01013e2:	89 04 24             	mov    %eax,(%esp)
c01013e5:	e8 87 ff ff ff       	call   c0101371 <serial_putc_sub>
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
c01013ea:	eb 24                	jmp    c0101410 <serial_putc+0x41>
        serial_putc_sub('\b');
c01013ec:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01013f3:	e8 79 ff ff ff       	call   c0101371 <serial_putc_sub>
        serial_putc_sub(' ');
c01013f8:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c01013ff:	e8 6d ff ff ff       	call   c0101371 <serial_putc_sub>
        serial_putc_sub('\b');
c0101404:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c010140b:	e8 61 ff ff ff       	call   c0101371 <serial_putc_sub>
}
c0101410:	90                   	nop
c0101411:	c9                   	leave  
c0101412:	c3                   	ret    

c0101413 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c0101413:	f3 0f 1e fb          	endbr32 
c0101417:	55                   	push   %ebp
c0101418:	89 e5                	mov    %esp,%ebp
c010141a:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c010141d:	eb 33                	jmp    c0101452 <cons_intr+0x3f>
        if (c != 0) {
c010141f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101423:	74 2d                	je     c0101452 <cons_intr+0x3f>
            cons.buf[cons.wpos ++] = c;
c0101425:	a1 64 36 12 c0       	mov    0xc0123664,%eax
c010142a:	8d 50 01             	lea    0x1(%eax),%edx
c010142d:	89 15 64 36 12 c0    	mov    %edx,0xc0123664
c0101433:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101436:	88 90 60 34 12 c0    	mov    %dl,-0x3fedcba0(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c010143c:	a1 64 36 12 c0       	mov    0xc0123664,%eax
c0101441:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101446:	75 0a                	jne    c0101452 <cons_intr+0x3f>
                cons.wpos = 0;
c0101448:	c7 05 64 36 12 c0 00 	movl   $0x0,0xc0123664
c010144f:	00 00 00 
    while ((c = (*proc)()) != -1) {
c0101452:	8b 45 08             	mov    0x8(%ebp),%eax
c0101455:	ff d0                	call   *%eax
c0101457:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010145a:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c010145e:	75 bf                	jne    c010141f <cons_intr+0xc>
            }
        }
    }
}
c0101460:	90                   	nop
c0101461:	90                   	nop
c0101462:	c9                   	leave  
c0101463:	c3                   	ret    

c0101464 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c0101464:	f3 0f 1e fb          	endbr32 
c0101468:	55                   	push   %ebp
c0101469:	89 e5                	mov    %esp,%ebp
c010146b:	83 ec 10             	sub    $0x10,%esp
c010146e:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101474:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0101478:	89 c2                	mov    %eax,%edx
c010147a:	ec                   	in     (%dx),%al
c010147b:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c010147e:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c0101482:	0f b6 c0             	movzbl %al,%eax
c0101485:	83 e0 01             	and    $0x1,%eax
c0101488:	85 c0                	test   %eax,%eax
c010148a:	75 07                	jne    c0101493 <serial_proc_data+0x2f>
        return -1;
c010148c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101491:	eb 2a                	jmp    c01014bd <serial_proc_data+0x59>
c0101493:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101499:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010149d:	89 c2                	mov    %eax,%edx
c010149f:	ec                   	in     (%dx),%al
c01014a0:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
c01014a3:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c01014a7:	0f b6 c0             	movzbl %al,%eax
c01014aa:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
c01014ad:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c01014b1:	75 07                	jne    c01014ba <serial_proc_data+0x56>
        c = '\b';
c01014b3:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
c01014ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01014bd:	c9                   	leave  
c01014be:	c3                   	ret    

c01014bf <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c01014bf:	f3 0f 1e fb          	endbr32 
c01014c3:	55                   	push   %ebp
c01014c4:	89 e5                	mov    %esp,%ebp
c01014c6:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
c01014c9:	a1 48 34 12 c0       	mov    0xc0123448,%eax
c01014ce:	85 c0                	test   %eax,%eax
c01014d0:	74 0c                	je     c01014de <serial_intr+0x1f>
        cons_intr(serial_proc_data);
c01014d2:	c7 04 24 64 14 10 c0 	movl   $0xc0101464,(%esp)
c01014d9:	e8 35 ff ff ff       	call   c0101413 <cons_intr>
    }
}
c01014de:	90                   	nop
c01014df:	c9                   	leave  
c01014e0:	c3                   	ret    

c01014e1 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c01014e1:	f3 0f 1e fb          	endbr32 
c01014e5:	55                   	push   %ebp
c01014e6:	89 e5                	mov    %esp,%ebp
c01014e8:	83 ec 38             	sub    $0x38,%esp
c01014eb:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01014f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01014f4:	89 c2                	mov    %eax,%edx
c01014f6:	ec                   	in     (%dx),%al
c01014f7:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
c01014fa:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c01014fe:	0f b6 c0             	movzbl %al,%eax
c0101501:	83 e0 01             	and    $0x1,%eax
c0101504:	85 c0                	test   %eax,%eax
c0101506:	75 0a                	jne    c0101512 <kbd_proc_data+0x31>
        return -1;
c0101508:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010150d:	e9 56 01 00 00       	jmp    c0101668 <kbd_proc_data+0x187>
c0101512:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101518:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010151b:	89 c2                	mov    %eax,%edx
c010151d:	ec                   	in     (%dx),%al
c010151e:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c0101521:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
c0101525:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c0101528:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c010152c:	75 17                	jne    c0101545 <kbd_proc_data+0x64>
        // E0 escape character
        shift |= E0ESC;
c010152e:	a1 68 36 12 c0       	mov    0xc0123668,%eax
c0101533:	83 c8 40             	or     $0x40,%eax
c0101536:	a3 68 36 12 c0       	mov    %eax,0xc0123668
        return 0;
c010153b:	b8 00 00 00 00       	mov    $0x0,%eax
c0101540:	e9 23 01 00 00       	jmp    c0101668 <kbd_proc_data+0x187>
    } else if (data & 0x80) {
c0101545:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101549:	84 c0                	test   %al,%al
c010154b:	79 45                	jns    c0101592 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c010154d:	a1 68 36 12 c0       	mov    0xc0123668,%eax
c0101552:	83 e0 40             	and    $0x40,%eax
c0101555:	85 c0                	test   %eax,%eax
c0101557:	75 08                	jne    c0101561 <kbd_proc_data+0x80>
c0101559:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010155d:	24 7f                	and    $0x7f,%al
c010155f:	eb 04                	jmp    c0101565 <kbd_proc_data+0x84>
c0101561:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101565:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c0101568:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010156c:	0f b6 80 40 00 12 c0 	movzbl -0x3fedffc0(%eax),%eax
c0101573:	0c 40                	or     $0x40,%al
c0101575:	0f b6 c0             	movzbl %al,%eax
c0101578:	f7 d0                	not    %eax
c010157a:	89 c2                	mov    %eax,%edx
c010157c:	a1 68 36 12 c0       	mov    0xc0123668,%eax
c0101581:	21 d0                	and    %edx,%eax
c0101583:	a3 68 36 12 c0       	mov    %eax,0xc0123668
        return 0;
c0101588:	b8 00 00 00 00       	mov    $0x0,%eax
c010158d:	e9 d6 00 00 00       	jmp    c0101668 <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
c0101592:	a1 68 36 12 c0       	mov    0xc0123668,%eax
c0101597:	83 e0 40             	and    $0x40,%eax
c010159a:	85 c0                	test   %eax,%eax
c010159c:	74 11                	je     c01015af <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c010159e:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c01015a2:	a1 68 36 12 c0       	mov    0xc0123668,%eax
c01015a7:	83 e0 bf             	and    $0xffffffbf,%eax
c01015aa:	a3 68 36 12 c0       	mov    %eax,0xc0123668
    }

    shift |= shiftcode[data];
c01015af:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01015b3:	0f b6 80 40 00 12 c0 	movzbl -0x3fedffc0(%eax),%eax
c01015ba:	0f b6 d0             	movzbl %al,%edx
c01015bd:	a1 68 36 12 c0       	mov    0xc0123668,%eax
c01015c2:	09 d0                	or     %edx,%eax
c01015c4:	a3 68 36 12 c0       	mov    %eax,0xc0123668
    shift ^= togglecode[data];
c01015c9:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01015cd:	0f b6 80 40 01 12 c0 	movzbl -0x3fedfec0(%eax),%eax
c01015d4:	0f b6 d0             	movzbl %al,%edx
c01015d7:	a1 68 36 12 c0       	mov    0xc0123668,%eax
c01015dc:	31 d0                	xor    %edx,%eax
c01015de:	a3 68 36 12 c0       	mov    %eax,0xc0123668

    c = charcode[shift & (CTL | SHIFT)][data];
c01015e3:	a1 68 36 12 c0       	mov    0xc0123668,%eax
c01015e8:	83 e0 03             	and    $0x3,%eax
c01015eb:	8b 14 85 40 05 12 c0 	mov    -0x3fedfac0(,%eax,4),%edx
c01015f2:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01015f6:	01 d0                	add    %edx,%eax
c01015f8:	0f b6 00             	movzbl (%eax),%eax
c01015fb:	0f b6 c0             	movzbl %al,%eax
c01015fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c0101601:	a1 68 36 12 c0       	mov    0xc0123668,%eax
c0101606:	83 e0 08             	and    $0x8,%eax
c0101609:	85 c0                	test   %eax,%eax
c010160b:	74 22                	je     c010162f <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
c010160d:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c0101611:	7e 0c                	jle    c010161f <kbd_proc_data+0x13e>
c0101613:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c0101617:	7f 06                	jg     c010161f <kbd_proc_data+0x13e>
            c += 'A' - 'a';
c0101619:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c010161d:	eb 10                	jmp    c010162f <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
c010161f:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c0101623:	7e 0a                	jle    c010162f <kbd_proc_data+0x14e>
c0101625:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c0101629:	7f 04                	jg     c010162f <kbd_proc_data+0x14e>
            c += 'a' - 'A';
c010162b:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c010162f:	a1 68 36 12 c0       	mov    0xc0123668,%eax
c0101634:	f7 d0                	not    %eax
c0101636:	83 e0 06             	and    $0x6,%eax
c0101639:	85 c0                	test   %eax,%eax
c010163b:	75 28                	jne    c0101665 <kbd_proc_data+0x184>
c010163d:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c0101644:	75 1f                	jne    c0101665 <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
c0101646:	c7 04 24 dd a3 10 c0 	movl   $0xc010a3dd,(%esp)
c010164d:	e8 78 ec ff ff       	call   c01002ca <cprintf>
c0101652:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
c0101658:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010165c:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c0101660:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0101663:	ee                   	out    %al,(%dx)
}
c0101664:	90                   	nop
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c0101665:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101668:	c9                   	leave  
c0101669:	c3                   	ret    

c010166a <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c010166a:	f3 0f 1e fb          	endbr32 
c010166e:	55                   	push   %ebp
c010166f:	89 e5                	mov    %esp,%ebp
c0101671:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
c0101674:	c7 04 24 e1 14 10 c0 	movl   $0xc01014e1,(%esp)
c010167b:	e8 93 fd ff ff       	call   c0101413 <cons_intr>
}
c0101680:	90                   	nop
c0101681:	c9                   	leave  
c0101682:	c3                   	ret    

c0101683 <kbd_init>:

static void
kbd_init(void) {
c0101683:	f3 0f 1e fb          	endbr32 
c0101687:	55                   	push   %ebp
c0101688:	89 e5                	mov    %esp,%ebp
c010168a:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
c010168d:	e8 d8 ff ff ff       	call   c010166a <kbd_intr>
    pic_enable(IRQ_KBD); // 通过中断控制器使能键盘输入中断
c0101692:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0101699:	e8 47 01 00 00       	call   c01017e5 <pic_enable>
}
c010169e:	90                   	nop
c010169f:	c9                   	leave  
c01016a0:	c3                   	ret    

c01016a1 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c01016a1:	f3 0f 1e fb          	endbr32 
c01016a5:	55                   	push   %ebp
c01016a6:	89 e5                	mov    %esp,%ebp
c01016a8:	83 ec 18             	sub    $0x18,%esp
    cga_init();
c01016ab:	e8 2e f8 ff ff       	call   c0100ede <cga_init>
    serial_init();
c01016b0:	e8 13 f9 ff ff       	call   c0100fc8 <serial_init>
    kbd_init();
c01016b5:	e8 c9 ff ff ff       	call   c0101683 <kbd_init>
    if (!serial_exists) {
c01016ba:	a1 48 34 12 c0       	mov    0xc0123448,%eax
c01016bf:	85 c0                	test   %eax,%eax
c01016c1:	75 0c                	jne    c01016cf <cons_init+0x2e>
        cprintf("serial port does not exist!!\n");
c01016c3:	c7 04 24 e9 a3 10 c0 	movl   $0xc010a3e9,(%esp)
c01016ca:	e8 fb eb ff ff       	call   c01002ca <cprintf>
    }
}
c01016cf:	90                   	nop
c01016d0:	c9                   	leave  
c01016d1:	c3                   	ret    

c01016d2 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c01016d2:	f3 0f 1e fb          	endbr32 
c01016d6:	55                   	push   %ebp
c01016d7:	89 e5                	mov    %esp,%ebp
c01016d9:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c01016dc:	e8 72 f7 ff ff       	call   c0100e53 <__intr_save>
c01016e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c01016e4:	8b 45 08             	mov    0x8(%ebp),%eax
c01016e7:	89 04 24             	mov    %eax,(%esp)
c01016ea:	e8 48 fa ff ff       	call   c0101137 <lpt_putc>
        cga_putc(c);
c01016ef:	8b 45 08             	mov    0x8(%ebp),%eax
c01016f2:	89 04 24             	mov    %eax,(%esp)
c01016f5:	e8 81 fa ff ff       	call   c010117b <cga_putc>
        serial_putc(c);
c01016fa:	8b 45 08             	mov    0x8(%ebp),%eax
c01016fd:	89 04 24             	mov    %eax,(%esp)
c0101700:	e8 ca fc ff ff       	call   c01013cf <serial_putc>
    }
    local_intr_restore(intr_flag);
c0101705:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101708:	89 04 24             	mov    %eax,(%esp)
c010170b:	e8 6d f7 ff ff       	call   c0100e7d <__intr_restore>
}
c0101710:	90                   	nop
c0101711:	c9                   	leave  
c0101712:	c3                   	ret    

c0101713 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c0101713:	f3 0f 1e fb          	endbr32 
c0101717:	55                   	push   %ebp
c0101718:	89 e5                	mov    %esp,%ebp
c010171a:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
c010171d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0101724:	e8 2a f7 ff ff       	call   c0100e53 <__intr_save>
c0101729:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c010172c:	e8 8e fd ff ff       	call   c01014bf <serial_intr>
        kbd_intr();
c0101731:	e8 34 ff ff ff       	call   c010166a <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c0101736:	8b 15 60 36 12 c0    	mov    0xc0123660,%edx
c010173c:	a1 64 36 12 c0       	mov    0xc0123664,%eax
c0101741:	39 c2                	cmp    %eax,%edx
c0101743:	74 31                	je     c0101776 <cons_getc+0x63>
            c = cons.buf[cons.rpos ++];
c0101745:	a1 60 36 12 c0       	mov    0xc0123660,%eax
c010174a:	8d 50 01             	lea    0x1(%eax),%edx
c010174d:	89 15 60 36 12 c0    	mov    %edx,0xc0123660
c0101753:	0f b6 80 60 34 12 c0 	movzbl -0x3fedcba0(%eax),%eax
c010175a:	0f b6 c0             	movzbl %al,%eax
c010175d:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c0101760:	a1 60 36 12 c0       	mov    0xc0123660,%eax
c0101765:	3d 00 02 00 00       	cmp    $0x200,%eax
c010176a:	75 0a                	jne    c0101776 <cons_getc+0x63>
                cons.rpos = 0;
c010176c:	c7 05 60 36 12 c0 00 	movl   $0x0,0xc0123660
c0101773:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c0101776:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101779:	89 04 24             	mov    %eax,(%esp)
c010177c:	e8 fc f6 ff ff       	call   c0100e7d <__intr_restore>
    return c;
c0101781:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101784:	c9                   	leave  
c0101785:	c3                   	ret    

c0101786 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c0101786:	f3 0f 1e fb          	endbr32 
c010178a:	55                   	push   %ebp
c010178b:	89 e5                	mov    %esp,%ebp
c010178d:	83 ec 14             	sub    $0x14,%esp
c0101790:	8b 45 08             	mov    0x8(%ebp),%eax
c0101793:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c0101797:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010179a:	66 a3 50 05 12 c0    	mov    %ax,0xc0120550
    if (did_init) {
c01017a0:	a1 6c 36 12 c0       	mov    0xc012366c,%eax
c01017a5:	85 c0                	test   %eax,%eax
c01017a7:	74 39                	je     c01017e2 <pic_setmask+0x5c>
        outb(IO_PIC1 + 1, mask);
c01017a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01017ac:	0f b6 c0             	movzbl %al,%eax
c01017af:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
c01017b5:	88 45 f9             	mov    %al,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01017b8:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01017bc:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c01017c0:	ee                   	out    %al,(%dx)
}
c01017c1:	90                   	nop
        outb(IO_PIC2 + 1, mask >> 8);
c01017c2:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01017c6:	c1 e8 08             	shr    $0x8,%eax
c01017c9:	0f b7 c0             	movzwl %ax,%eax
c01017cc:	0f b6 c0             	movzbl %al,%eax
c01017cf:	66 c7 45 fe a1 00    	movw   $0xa1,-0x2(%ebp)
c01017d5:	88 45 fd             	mov    %al,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01017d8:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c01017dc:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c01017e0:	ee                   	out    %al,(%dx)
}
c01017e1:	90                   	nop
    }
}
c01017e2:	90                   	nop
c01017e3:	c9                   	leave  
c01017e4:	c3                   	ret    

c01017e5 <pic_enable>:

void
pic_enable(unsigned int irq) {
c01017e5:	f3 0f 1e fb          	endbr32 
c01017e9:	55                   	push   %ebp
c01017ea:	89 e5                	mov    %esp,%ebp
c01017ec:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
c01017ef:	8b 45 08             	mov    0x8(%ebp),%eax
c01017f2:	ba 01 00 00 00       	mov    $0x1,%edx
c01017f7:	88 c1                	mov    %al,%cl
c01017f9:	d3 e2                	shl    %cl,%edx
c01017fb:	89 d0                	mov    %edx,%eax
c01017fd:	98                   	cwtl   
c01017fe:	f7 d0                	not    %eax
c0101800:	0f bf d0             	movswl %ax,%edx
c0101803:	0f b7 05 50 05 12 c0 	movzwl 0xc0120550,%eax
c010180a:	98                   	cwtl   
c010180b:	21 d0                	and    %edx,%eax
c010180d:	98                   	cwtl   
c010180e:	0f b7 c0             	movzwl %ax,%eax
c0101811:	89 04 24             	mov    %eax,(%esp)
c0101814:	e8 6d ff ff ff       	call   c0101786 <pic_setmask>
}
c0101819:	90                   	nop
c010181a:	c9                   	leave  
c010181b:	c3                   	ret    

c010181c <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c010181c:	f3 0f 1e fb          	endbr32 
c0101820:	55                   	push   %ebp
c0101821:	89 e5                	mov    %esp,%ebp
c0101823:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
c0101826:	c7 05 6c 36 12 c0 01 	movl   $0x1,0xc012366c
c010182d:	00 00 00 
c0101830:	66 c7 45 ca 21 00    	movw   $0x21,-0x36(%ebp)
c0101836:	c6 45 c9 ff          	movb   $0xff,-0x37(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010183a:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c010183e:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c0101842:	ee                   	out    %al,(%dx)
}
c0101843:	90                   	nop
c0101844:	66 c7 45 ce a1 00    	movw   $0xa1,-0x32(%ebp)
c010184a:	c6 45 cd ff          	movb   $0xff,-0x33(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010184e:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c0101852:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c0101856:	ee                   	out    %al,(%dx)
}
c0101857:	90                   	nop
c0101858:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
c010185e:	c6 45 d1 11          	movb   $0x11,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101862:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c0101866:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c010186a:	ee                   	out    %al,(%dx)
}
c010186b:	90                   	nop
c010186c:	66 c7 45 d6 21 00    	movw   $0x21,-0x2a(%ebp)
c0101872:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101876:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c010187a:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c010187e:	ee                   	out    %al,(%dx)
}
c010187f:	90                   	nop
c0101880:	66 c7 45 da 21 00    	movw   $0x21,-0x26(%ebp)
c0101886:	c6 45 d9 04          	movb   $0x4,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010188a:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c010188e:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101892:	ee                   	out    %al,(%dx)
}
c0101893:	90                   	nop
c0101894:	66 c7 45 de 21 00    	movw   $0x21,-0x22(%ebp)
c010189a:	c6 45 dd 03          	movb   $0x3,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010189e:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c01018a2:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c01018a6:	ee                   	out    %al,(%dx)
}
c01018a7:	90                   	nop
c01018a8:	66 c7 45 e2 a0 00    	movw   $0xa0,-0x1e(%ebp)
c01018ae:	c6 45 e1 11          	movb   $0x11,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01018b2:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c01018b6:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c01018ba:	ee                   	out    %al,(%dx)
}
c01018bb:	90                   	nop
c01018bc:	66 c7 45 e6 a1 00    	movw   $0xa1,-0x1a(%ebp)
c01018c2:	c6 45 e5 28          	movb   $0x28,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01018c6:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01018ca:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01018ce:	ee                   	out    %al,(%dx)
}
c01018cf:	90                   	nop
c01018d0:	66 c7 45 ea a1 00    	movw   $0xa1,-0x16(%ebp)
c01018d6:	c6 45 e9 02          	movb   $0x2,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01018da:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01018de:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01018e2:	ee                   	out    %al,(%dx)
}
c01018e3:	90                   	nop
c01018e4:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
c01018ea:	c6 45 ed 03          	movb   $0x3,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01018ee:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01018f2:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01018f6:	ee                   	out    %al,(%dx)
}
c01018f7:	90                   	nop
c01018f8:	66 c7 45 f2 20 00    	movw   $0x20,-0xe(%ebp)
c01018fe:	c6 45 f1 68          	movb   $0x68,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101902:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101906:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010190a:	ee                   	out    %al,(%dx)
}
c010190b:	90                   	nop
c010190c:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
c0101912:	c6 45 f5 0a          	movb   $0xa,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101916:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c010191a:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c010191e:	ee                   	out    %al,(%dx)
}
c010191f:	90                   	nop
c0101920:	66 c7 45 fa a0 00    	movw   $0xa0,-0x6(%ebp)
c0101926:	c6 45 f9 68          	movb   $0x68,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010192a:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c010192e:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101932:	ee                   	out    %al,(%dx)
}
c0101933:	90                   	nop
c0101934:	66 c7 45 fe a0 00    	movw   $0xa0,-0x2(%ebp)
c010193a:	c6 45 fd 0a          	movb   $0xa,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010193e:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0101942:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101946:	ee                   	out    %al,(%dx)
}
c0101947:	90                   	nop
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c0101948:	0f b7 05 50 05 12 c0 	movzwl 0xc0120550,%eax
c010194f:	3d ff ff 00 00       	cmp    $0xffff,%eax
c0101954:	74 0f                	je     c0101965 <pic_init+0x149>
        pic_setmask(irq_mask);
c0101956:	0f b7 05 50 05 12 c0 	movzwl 0xc0120550,%eax
c010195d:	89 04 24             	mov    %eax,(%esp)
c0101960:	e8 21 fe ff ff       	call   c0101786 <pic_setmask>
    }
}
c0101965:	90                   	nop
c0101966:	c9                   	leave  
c0101967:	c3                   	ret    

c0101968 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c0101968:	f3 0f 1e fb          	endbr32 
c010196c:	55                   	push   %ebp
c010196d:	89 e5                	mov    %esp,%ebp
    asm volatile ("sti");
c010196f:	fb                   	sti    
}
c0101970:	90                   	nop
    sti();
}
c0101971:	90                   	nop
c0101972:	5d                   	pop    %ebp
c0101973:	c3                   	ret    

c0101974 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c0101974:	f3 0f 1e fb          	endbr32 
c0101978:	55                   	push   %ebp
c0101979:	89 e5                	mov    %esp,%ebp
    asm volatile ("cli" ::: "memory");
c010197b:	fa                   	cli    
}
c010197c:	90                   	nop
    cli();
}
c010197d:	90                   	nop
c010197e:	5d                   	pop    %ebp
c010197f:	c3                   	ret    

c0101980 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
c0101980:	f3 0f 1e fb          	endbr32 
c0101984:	55                   	push   %ebp
c0101985:	89 e5                	mov    %esp,%ebp
c0101987:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
c010198a:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c0101991:	00 
c0101992:	c7 04 24 20 a4 10 c0 	movl   $0xc010a420,(%esp)
c0101999:	e8 2c e9 ff ff       	call   c01002ca <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
c010199e:	c7 04 24 2a a4 10 c0 	movl   $0xc010a42a,(%esp)
c01019a5:	e8 20 e9 ff ff       	call   c01002ca <cprintf>
    panic("EOT: kernel seems ok.");
c01019aa:	c7 44 24 08 38 a4 10 	movl   $0xc010a438,0x8(%esp)
c01019b1:	c0 
c01019b2:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
c01019b9:	00 
c01019ba:	c7 04 24 4e a4 10 c0 	movl   $0xc010a44e,(%esp)
c01019c1:	e8 70 ea ff ff       	call   c0100436 <__panic>

c01019c6 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c01019c6:	f3 0f 1e fb          	endbr32 
c01019ca:	55                   	push   %ebp
c01019cb:	89 e5                	mov    %esp,%ebp
c01019cd:	83 ec 10             	sub    $0x10,%esp
      */
    // (1)
    extern uintptr_t __vectors[];
    // (2)
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
c01019d0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01019d7:	e9 c4 00 00 00       	jmp    c0101aa0 <idt_init+0xda>
        SETGATE(idt[i], 0, KERNEL_CS, __vectors[i], DPL_KERNEL); // trapno = i, gd_type = Interrupt-gate descriptor, DPL = 0
c01019dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019df:	8b 04 85 e0 05 12 c0 	mov    -0x3fedfa20(,%eax,4),%eax
c01019e6:	0f b7 d0             	movzwl %ax,%edx
c01019e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019ec:	66 89 14 c5 80 36 12 	mov    %dx,-0x3fedc980(,%eax,8)
c01019f3:	c0 
c01019f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019f7:	66 c7 04 c5 82 36 12 	movw   $0x8,-0x3fedc97e(,%eax,8)
c01019fe:	c0 08 00 
c0101a01:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a04:	0f b6 14 c5 84 36 12 	movzbl -0x3fedc97c(,%eax,8),%edx
c0101a0b:	c0 
c0101a0c:	80 e2 e0             	and    $0xe0,%dl
c0101a0f:	88 14 c5 84 36 12 c0 	mov    %dl,-0x3fedc97c(,%eax,8)
c0101a16:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a19:	0f b6 14 c5 84 36 12 	movzbl -0x3fedc97c(,%eax,8),%edx
c0101a20:	c0 
c0101a21:	80 e2 1f             	and    $0x1f,%dl
c0101a24:	88 14 c5 84 36 12 c0 	mov    %dl,-0x3fedc97c(,%eax,8)
c0101a2b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a2e:	0f b6 14 c5 85 36 12 	movzbl -0x3fedc97b(,%eax,8),%edx
c0101a35:	c0 
c0101a36:	80 e2 f0             	and    $0xf0,%dl
c0101a39:	80 ca 0e             	or     $0xe,%dl
c0101a3c:	88 14 c5 85 36 12 c0 	mov    %dl,-0x3fedc97b(,%eax,8)
c0101a43:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a46:	0f b6 14 c5 85 36 12 	movzbl -0x3fedc97b(,%eax,8),%edx
c0101a4d:	c0 
c0101a4e:	80 e2 ef             	and    $0xef,%dl
c0101a51:	88 14 c5 85 36 12 c0 	mov    %dl,-0x3fedc97b(,%eax,8)
c0101a58:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a5b:	0f b6 14 c5 85 36 12 	movzbl -0x3fedc97b(,%eax,8),%edx
c0101a62:	c0 
c0101a63:	80 e2 9f             	and    $0x9f,%dl
c0101a66:	88 14 c5 85 36 12 c0 	mov    %dl,-0x3fedc97b(,%eax,8)
c0101a6d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a70:	0f b6 14 c5 85 36 12 	movzbl -0x3fedc97b(,%eax,8),%edx
c0101a77:	c0 
c0101a78:	80 ca 80             	or     $0x80,%dl
c0101a7b:	88 14 c5 85 36 12 c0 	mov    %dl,-0x3fedc97b(,%eax,8)
c0101a82:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a85:	8b 04 85 e0 05 12 c0 	mov    -0x3fedfa20(,%eax,4),%eax
c0101a8c:	c1 e8 10             	shr    $0x10,%eax
c0101a8f:	0f b7 d0             	movzwl %ax,%edx
c0101a92:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a95:	66 89 14 c5 86 36 12 	mov    %dx,-0x3fedc97a(,%eax,8)
c0101a9c:	c0 
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
c0101a9d:	ff 45 fc             	incl   -0x4(%ebp)
c0101aa0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101aa3:	3d ff 00 00 00       	cmp    $0xff,%eax
c0101aa8:	0f 86 2e ff ff ff    	jbe    c01019dc <idt_init+0x16>
    }
	// 系统调用中断
    SETGATE(idt[T_SYSCALL], 1, KERNEL_CS, __vectors[T_SYSCALL], DPL_USER); // trapno = T_SYSCALL = 0x80，gd_type = Trap-gate descriptor，DPL = 3
c0101aae:	a1 e0 07 12 c0       	mov    0xc01207e0,%eax
c0101ab3:	0f b7 c0             	movzwl %ax,%eax
c0101ab6:	66 a3 80 3a 12 c0    	mov    %ax,0xc0123a80
c0101abc:	66 c7 05 82 3a 12 c0 	movw   $0x8,0xc0123a82
c0101ac3:	08 00 
c0101ac5:	0f b6 05 84 3a 12 c0 	movzbl 0xc0123a84,%eax
c0101acc:	24 e0                	and    $0xe0,%al
c0101ace:	a2 84 3a 12 c0       	mov    %al,0xc0123a84
c0101ad3:	0f b6 05 84 3a 12 c0 	movzbl 0xc0123a84,%eax
c0101ada:	24 1f                	and    $0x1f,%al
c0101adc:	a2 84 3a 12 c0       	mov    %al,0xc0123a84
c0101ae1:	0f b6 05 85 3a 12 c0 	movzbl 0xc0123a85,%eax
c0101ae8:	0c 0f                	or     $0xf,%al
c0101aea:	a2 85 3a 12 c0       	mov    %al,0xc0123a85
c0101aef:	0f b6 05 85 3a 12 c0 	movzbl 0xc0123a85,%eax
c0101af6:	24 ef                	and    $0xef,%al
c0101af8:	a2 85 3a 12 c0       	mov    %al,0xc0123a85
c0101afd:	0f b6 05 85 3a 12 c0 	movzbl 0xc0123a85,%eax
c0101b04:	0c 60                	or     $0x60,%al
c0101b06:	a2 85 3a 12 c0       	mov    %al,0xc0123a85
c0101b0b:	0f b6 05 85 3a 12 c0 	movzbl 0xc0123a85,%eax
c0101b12:	0c 80                	or     $0x80,%al
c0101b14:	a2 85 3a 12 c0       	mov    %al,0xc0123a85
c0101b19:	a1 e0 07 12 c0       	mov    0xc01207e0,%eax
c0101b1e:	c1 e8 10             	shr    $0x10,%eax
c0101b21:	0f b7 c0             	movzwl %ax,%eax
c0101b24:	66 a3 86 3a 12 c0    	mov    %ax,0xc0123a86
    SETGATE(idt[T_SWITCH_TOK], 1, KERNEL_CS, __vectors[T_SWITCH_TOK], DPL_USER);
c0101b2a:	a1 c4 07 12 c0       	mov    0xc01207c4,%eax
c0101b2f:	0f b7 c0             	movzwl %ax,%eax
c0101b32:	66 a3 48 3a 12 c0    	mov    %ax,0xc0123a48
c0101b38:	66 c7 05 4a 3a 12 c0 	movw   $0x8,0xc0123a4a
c0101b3f:	08 00 
c0101b41:	0f b6 05 4c 3a 12 c0 	movzbl 0xc0123a4c,%eax
c0101b48:	24 e0                	and    $0xe0,%al
c0101b4a:	a2 4c 3a 12 c0       	mov    %al,0xc0123a4c
c0101b4f:	0f b6 05 4c 3a 12 c0 	movzbl 0xc0123a4c,%eax
c0101b56:	24 1f                	and    $0x1f,%al
c0101b58:	a2 4c 3a 12 c0       	mov    %al,0xc0123a4c
c0101b5d:	0f b6 05 4d 3a 12 c0 	movzbl 0xc0123a4d,%eax
c0101b64:	0c 0f                	or     $0xf,%al
c0101b66:	a2 4d 3a 12 c0       	mov    %al,0xc0123a4d
c0101b6b:	0f b6 05 4d 3a 12 c0 	movzbl 0xc0123a4d,%eax
c0101b72:	24 ef                	and    $0xef,%al
c0101b74:	a2 4d 3a 12 c0       	mov    %al,0xc0123a4d
c0101b79:	0f b6 05 4d 3a 12 c0 	movzbl 0xc0123a4d,%eax
c0101b80:	0c 60                	or     $0x60,%al
c0101b82:	a2 4d 3a 12 c0       	mov    %al,0xc0123a4d
c0101b87:	0f b6 05 4d 3a 12 c0 	movzbl 0xc0123a4d,%eax
c0101b8e:	0c 80                	or     $0x80,%al
c0101b90:	a2 4d 3a 12 c0       	mov    %al,0xc0123a4d
c0101b95:	a1 c4 07 12 c0       	mov    0xc01207c4,%eax
c0101b9a:	c1 e8 10             	shr    $0x10,%eax
c0101b9d:	0f b7 c0             	movzwl %ax,%eax
c0101ba0:	66 a3 4e 3a 12 c0    	mov    %ax,0xc0123a4e
c0101ba6:	c7 45 f8 60 05 12 c0 	movl   $0xc0120560,-0x8(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c0101bad:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101bb0:	0f 01 18             	lidtl  (%eax)
}
c0101bb3:	90                   	nop
	// (3)
    lidt(&idt_pd);
}
c0101bb4:	90                   	nop
c0101bb5:	c9                   	leave  
c0101bb6:	c3                   	ret    

c0101bb7 <trapname>:

static const char *
trapname(int trapno) {
c0101bb7:	f3 0f 1e fb          	endbr32 
c0101bbb:	55                   	push   %ebp
c0101bbc:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c0101bbe:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bc1:	83 f8 13             	cmp    $0x13,%eax
c0101bc4:	77 0c                	ja     c0101bd2 <trapname+0x1b>
        return excnames[trapno];
c0101bc6:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bc9:	8b 04 85 00 a8 10 c0 	mov    -0x3fef5800(,%eax,4),%eax
c0101bd0:	eb 18                	jmp    c0101bea <trapname+0x33>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c0101bd2:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c0101bd6:	7e 0d                	jle    c0101be5 <trapname+0x2e>
c0101bd8:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c0101bdc:	7f 07                	jg     c0101be5 <trapname+0x2e>
        return "Hardware Interrupt";
c0101bde:	b8 5f a4 10 c0       	mov    $0xc010a45f,%eax
c0101be3:	eb 05                	jmp    c0101bea <trapname+0x33>
    }
    return "(unknown trap)";
c0101be5:	b8 72 a4 10 c0       	mov    $0xc010a472,%eax
}
c0101bea:	5d                   	pop    %ebp
c0101beb:	c3                   	ret    

c0101bec <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c0101bec:	f3 0f 1e fb          	endbr32 
c0101bf0:	55                   	push   %ebp
c0101bf1:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c0101bf3:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bf6:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101bfa:	83 f8 08             	cmp    $0x8,%eax
c0101bfd:	0f 94 c0             	sete   %al
c0101c00:	0f b6 c0             	movzbl %al,%eax
}
c0101c03:	5d                   	pop    %ebp
c0101c04:	c3                   	ret    

c0101c05 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c0101c05:	f3 0f 1e fb          	endbr32 
c0101c09:	55                   	push   %ebp
c0101c0a:	89 e5                	mov    %esp,%ebp
c0101c0c:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
c0101c0f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c12:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c16:	c7 04 24 b3 a4 10 c0 	movl   $0xc010a4b3,(%esp)
c0101c1d:	e8 a8 e6 ff ff       	call   c01002ca <cprintf>
    print_regs(&tf->tf_regs);
c0101c22:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c25:	89 04 24             	mov    %eax,(%esp)
c0101c28:	e8 8d 01 00 00       	call   c0101dba <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c0101c2d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c30:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0101c34:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c38:	c7 04 24 c4 a4 10 c0 	movl   $0xc010a4c4,(%esp)
c0101c3f:	e8 86 e6 ff ff       	call   c01002ca <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
c0101c44:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c47:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c0101c4b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c4f:	c7 04 24 d7 a4 10 c0 	movl   $0xc010a4d7,(%esp)
c0101c56:	e8 6f e6 ff ff       	call   c01002ca <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c0101c5b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c5e:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c0101c62:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c66:	c7 04 24 ea a4 10 c0 	movl   $0xc010a4ea,(%esp)
c0101c6d:	e8 58 e6 ff ff       	call   c01002ca <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c0101c72:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c75:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c0101c79:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c7d:	c7 04 24 fd a4 10 c0 	movl   $0xc010a4fd,(%esp)
c0101c84:	e8 41 e6 ff ff       	call   c01002ca <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c0101c89:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c8c:	8b 40 30             	mov    0x30(%eax),%eax
c0101c8f:	89 04 24             	mov    %eax,(%esp)
c0101c92:	e8 20 ff ff ff       	call   c0101bb7 <trapname>
c0101c97:	8b 55 08             	mov    0x8(%ebp),%edx
c0101c9a:	8b 52 30             	mov    0x30(%edx),%edx
c0101c9d:	89 44 24 08          	mov    %eax,0x8(%esp)
c0101ca1:	89 54 24 04          	mov    %edx,0x4(%esp)
c0101ca5:	c7 04 24 10 a5 10 c0 	movl   $0xc010a510,(%esp)
c0101cac:	e8 19 e6 ff ff       	call   c01002ca <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
c0101cb1:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cb4:	8b 40 34             	mov    0x34(%eax),%eax
c0101cb7:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cbb:	c7 04 24 22 a5 10 c0 	movl   $0xc010a522,(%esp)
c0101cc2:	e8 03 e6 ff ff       	call   c01002ca <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c0101cc7:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cca:	8b 40 38             	mov    0x38(%eax),%eax
c0101ccd:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cd1:	c7 04 24 31 a5 10 c0 	movl   $0xc010a531,(%esp)
c0101cd8:	e8 ed e5 ff ff       	call   c01002ca <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c0101cdd:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ce0:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101ce4:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ce8:	c7 04 24 40 a5 10 c0 	movl   $0xc010a540,(%esp)
c0101cef:	e8 d6 e5 ff ff       	call   c01002ca <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c0101cf4:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cf7:	8b 40 40             	mov    0x40(%eax),%eax
c0101cfa:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cfe:	c7 04 24 53 a5 10 c0 	movl   $0xc010a553,(%esp)
c0101d05:	e8 c0 e5 ff ff       	call   c01002ca <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101d0a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0101d11:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c0101d18:	eb 3d                	jmp    c0101d57 <print_trapframe+0x152>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c0101d1a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d1d:	8b 50 40             	mov    0x40(%eax),%edx
c0101d20:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101d23:	21 d0                	and    %edx,%eax
c0101d25:	85 c0                	test   %eax,%eax
c0101d27:	74 28                	je     c0101d51 <print_trapframe+0x14c>
c0101d29:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101d2c:	8b 04 85 80 05 12 c0 	mov    -0x3fedfa80(,%eax,4),%eax
c0101d33:	85 c0                	test   %eax,%eax
c0101d35:	74 1a                	je     c0101d51 <print_trapframe+0x14c>
            cprintf("%s,", IA32flags[i]);
c0101d37:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101d3a:	8b 04 85 80 05 12 c0 	mov    -0x3fedfa80(,%eax,4),%eax
c0101d41:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d45:	c7 04 24 62 a5 10 c0 	movl   $0xc010a562,(%esp)
c0101d4c:	e8 79 e5 ff ff       	call   c01002ca <cprintf>
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101d51:	ff 45 f4             	incl   -0xc(%ebp)
c0101d54:	d1 65 f0             	shll   -0x10(%ebp)
c0101d57:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101d5a:	83 f8 17             	cmp    $0x17,%eax
c0101d5d:	76 bb                	jbe    c0101d1a <print_trapframe+0x115>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c0101d5f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d62:	8b 40 40             	mov    0x40(%eax),%eax
c0101d65:	c1 e8 0c             	shr    $0xc,%eax
c0101d68:	83 e0 03             	and    $0x3,%eax
c0101d6b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d6f:	c7 04 24 66 a5 10 c0 	movl   $0xc010a566,(%esp)
c0101d76:	e8 4f e5 ff ff       	call   c01002ca <cprintf>

    if (!trap_in_kernel(tf)) {
c0101d7b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d7e:	89 04 24             	mov    %eax,(%esp)
c0101d81:	e8 66 fe ff ff       	call   c0101bec <trap_in_kernel>
c0101d86:	85 c0                	test   %eax,%eax
c0101d88:	75 2d                	jne    c0101db7 <print_trapframe+0x1b2>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c0101d8a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d8d:	8b 40 44             	mov    0x44(%eax),%eax
c0101d90:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d94:	c7 04 24 6f a5 10 c0 	movl   $0xc010a56f,(%esp)
c0101d9b:	e8 2a e5 ff ff       	call   c01002ca <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c0101da0:	8b 45 08             	mov    0x8(%ebp),%eax
c0101da3:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c0101da7:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101dab:	c7 04 24 7e a5 10 c0 	movl   $0xc010a57e,(%esp)
c0101db2:	e8 13 e5 ff ff       	call   c01002ca <cprintf>
    }
}
c0101db7:	90                   	nop
c0101db8:	c9                   	leave  
c0101db9:	c3                   	ret    

c0101dba <print_regs>:

void
print_regs(struct pushregs *regs) {
c0101dba:	f3 0f 1e fb          	endbr32 
c0101dbe:	55                   	push   %ebp
c0101dbf:	89 e5                	mov    %esp,%ebp
c0101dc1:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c0101dc4:	8b 45 08             	mov    0x8(%ebp),%eax
c0101dc7:	8b 00                	mov    (%eax),%eax
c0101dc9:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101dcd:	c7 04 24 91 a5 10 c0 	movl   $0xc010a591,(%esp)
c0101dd4:	e8 f1 e4 ff ff       	call   c01002ca <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c0101dd9:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ddc:	8b 40 04             	mov    0x4(%eax),%eax
c0101ddf:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101de3:	c7 04 24 a0 a5 10 c0 	movl   $0xc010a5a0,(%esp)
c0101dea:	e8 db e4 ff ff       	call   c01002ca <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c0101def:	8b 45 08             	mov    0x8(%ebp),%eax
c0101df2:	8b 40 08             	mov    0x8(%eax),%eax
c0101df5:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101df9:	c7 04 24 af a5 10 c0 	movl   $0xc010a5af,(%esp)
c0101e00:	e8 c5 e4 ff ff       	call   c01002ca <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c0101e05:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e08:	8b 40 0c             	mov    0xc(%eax),%eax
c0101e0b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101e0f:	c7 04 24 be a5 10 c0 	movl   $0xc010a5be,(%esp)
c0101e16:	e8 af e4 ff ff       	call   c01002ca <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c0101e1b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e1e:	8b 40 10             	mov    0x10(%eax),%eax
c0101e21:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101e25:	c7 04 24 cd a5 10 c0 	movl   $0xc010a5cd,(%esp)
c0101e2c:	e8 99 e4 ff ff       	call   c01002ca <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c0101e31:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e34:	8b 40 14             	mov    0x14(%eax),%eax
c0101e37:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101e3b:	c7 04 24 dc a5 10 c0 	movl   $0xc010a5dc,(%esp)
c0101e42:	e8 83 e4 ff ff       	call   c01002ca <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c0101e47:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e4a:	8b 40 18             	mov    0x18(%eax),%eax
c0101e4d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101e51:	c7 04 24 eb a5 10 c0 	movl   $0xc010a5eb,(%esp)
c0101e58:	e8 6d e4 ff ff       	call   c01002ca <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c0101e5d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e60:	8b 40 1c             	mov    0x1c(%eax),%eax
c0101e63:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101e67:	c7 04 24 fa a5 10 c0 	movl   $0xc010a5fa,(%esp)
c0101e6e:	e8 57 e4 ff ff       	call   c01002ca <cprintf>
}
c0101e73:	90                   	nop
c0101e74:	c9                   	leave  
c0101e75:	c3                   	ret    

c0101e76 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
c0101e76:	f3 0f 1e fb          	endbr32 
c0101e7a:	55                   	push   %ebp
c0101e7b:	89 e5                	mov    %esp,%ebp
c0101e7d:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
c0101e80:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e83:	8b 40 30             	mov    0x30(%eax),%eax
c0101e86:	83 f8 79             	cmp    $0x79,%eax
c0101e89:	0f 84 06 02 00 00    	je     c0102095 <trap_dispatch+0x21f>
c0101e8f:	83 f8 79             	cmp    $0x79,%eax
c0101e92:	0f 87 4e 02 00 00    	ja     c01020e6 <trap_dispatch+0x270>
c0101e98:	83 f8 78             	cmp    $0x78,%eax
c0101e9b:	0f 84 92 01 00 00    	je     c0102033 <trap_dispatch+0x1bd>
c0101ea1:	83 f8 78             	cmp    $0x78,%eax
c0101ea4:	0f 87 3c 02 00 00    	ja     c01020e6 <trap_dispatch+0x270>
c0101eaa:	83 f8 2f             	cmp    $0x2f,%eax
c0101ead:	0f 87 33 02 00 00    	ja     c01020e6 <trap_dispatch+0x270>
c0101eb3:	83 f8 2e             	cmp    $0x2e,%eax
c0101eb6:	0f 83 5f 02 00 00    	jae    c010211b <trap_dispatch+0x2a5>
c0101ebc:	83 f8 24             	cmp    $0x24,%eax
c0101ebf:	74 5e                	je     c0101f1f <trap_dispatch+0xa9>
c0101ec1:	83 f8 24             	cmp    $0x24,%eax
c0101ec4:	0f 87 1c 02 00 00    	ja     c01020e6 <trap_dispatch+0x270>
c0101eca:	83 f8 20             	cmp    $0x20,%eax
c0101ecd:	74 0a                	je     c0101ed9 <trap_dispatch+0x63>
c0101ecf:	83 f8 21             	cmp    $0x21,%eax
c0101ed2:	74 74                	je     c0101f48 <trap_dispatch+0xd2>
c0101ed4:	e9 0d 02 00 00       	jmp    c01020e6 <trap_dispatch+0x270>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a function, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks ++; // (1)
c0101ed9:	a1 28 3f 12 c0       	mov    0xc0123f28,%eax
c0101ede:	40                   	inc    %eax
c0101edf:	a3 28 3f 12 c0       	mov    %eax,0xc0123f28
        if (ticks % TICK_NUM == 0) {
c0101ee4:	8b 0d 28 3f 12 c0    	mov    0xc0123f28,%ecx
c0101eea:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
c0101eef:	89 c8                	mov    %ecx,%eax
c0101ef1:	f7 e2                	mul    %edx
c0101ef3:	c1 ea 05             	shr    $0x5,%edx
c0101ef6:	89 d0                	mov    %edx,%eax
c0101ef8:	c1 e0 02             	shl    $0x2,%eax
c0101efb:	01 d0                	add    %edx,%eax
c0101efd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0101f04:	01 d0                	add    %edx,%eax
c0101f06:	c1 e0 02             	shl    $0x2,%eax
c0101f09:	29 c1                	sub    %eax,%ecx
c0101f0b:	89 ca                	mov    %ecx,%edx
c0101f0d:	85 d2                	test   %edx,%edx
c0101f0f:	0f 85 09 02 00 00    	jne    c010211e <trap_dispatch+0x2a8>
            print_ticks(); // (2)
c0101f15:	e8 66 fa ff ff       	call   c0101980 <print_ticks>
        }
        break;
c0101f1a:	e9 ff 01 00 00       	jmp    c010211e <trap_dispatch+0x2a8>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c0101f1f:	e8 ef f7 ff ff       	call   c0101713 <cons_getc>
c0101f24:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c0101f27:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101f2b:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101f2f:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101f33:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101f37:	c7 04 24 09 a6 10 c0 	movl   $0xc010a609,(%esp)
c0101f3e:	e8 87 e3 ff ff       	call   c01002ca <cprintf>
        break;
c0101f43:	e9 e0 01 00 00       	jmp    c0102128 <trap_dispatch+0x2b2>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c0101f48:	e8 c6 f7 ff ff       	call   c0101713 <cons_getc>
c0101f4d:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c0101f50:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101f54:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101f58:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101f5c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101f60:	c7 04 24 1b a6 10 c0 	movl   $0xc010a61b,(%esp)
c0101f67:	e8 5e e3 ff ff       	call   c01002ca <cprintf>
        if(c == '0' && (tf->tf_cs & 3) != 0)
c0101f6c:	80 7d f7 30          	cmpb   $0x30,-0x9(%ebp)
c0101f70:	75 52                	jne    c0101fc4 <trap_dispatch+0x14e>
c0101f72:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f75:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101f79:	83 e0 03             	and    $0x3,%eax
c0101f7c:	85 c0                	test   %eax,%eax
c0101f7e:	74 44                	je     c0101fc4 <trap_dispatch+0x14e>
        {
                cprintf("Input 0......switch to kernel\n");
c0101f80:	c7 04 24 2c a6 10 c0 	movl   $0xc010a62c,(%esp)
c0101f87:	e8 3e e3 ff ff       	call   c01002ca <cprintf>
                tf->tf_cs = KERNEL_CS;
c0101f8c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f8f:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
                tf->tf_ds = tf->tf_es = KERNEL_DS;
c0101f95:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f98:	66 c7 40 28 10 00    	movw   $0x10,0x28(%eax)
c0101f9e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101fa1:	0f b7 50 28          	movzwl 0x28(%eax),%edx
c0101fa5:	8b 45 08             	mov    0x8(%ebp),%eax
c0101fa8:	66 89 50 2c          	mov    %dx,0x2c(%eax)
                tf->tf_eflags &= ~FL_IOPL_MASK;
c0101fac:	8b 45 08             	mov    0x8(%ebp),%eax
c0101faf:	8b 40 40             	mov    0x40(%eax),%eax
c0101fb2:	25 ff cf ff ff       	and    $0xffffcfff,%eax
c0101fb7:	89 c2                	mov    %eax,%edx
c0101fb9:	8b 45 08             	mov    0x8(%ebp),%eax
c0101fbc:	89 50 40             	mov    %edx,0x40(%eax)
                cprintf("Input 3......switch to user\n");
                tf->tf_cs = USER_CS;
                tf->tf_ds = tf->tf_es = tf->tf_ss = USER_DS;
                tf->tf_eflags |= FL_IOPL_MASK;
        }
        break;
c0101fbf:	e9 5d 01 00 00       	jmp    c0102121 <trap_dispatch+0x2ab>
        else if (c == '3' && (tf->tf_cs & 3) != 3)
c0101fc4:	80 7d f7 33          	cmpb   $0x33,-0x9(%ebp)
c0101fc8:	0f 85 53 01 00 00    	jne    c0102121 <trap_dispatch+0x2ab>
c0101fce:	8b 45 08             	mov    0x8(%ebp),%eax
c0101fd1:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101fd5:	83 e0 03             	and    $0x3,%eax
c0101fd8:	83 f8 03             	cmp    $0x3,%eax
c0101fdb:	0f 84 40 01 00 00    	je     c0102121 <trap_dispatch+0x2ab>
                cprintf("Input 3......switch to user\n");
c0101fe1:	c7 04 24 4b a6 10 c0 	movl   $0xc010a64b,(%esp)
c0101fe8:	e8 dd e2 ff ff       	call   c01002ca <cprintf>
                tf->tf_cs = USER_CS;
c0101fed:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ff0:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
                tf->tf_ds = tf->tf_es = tf->tf_ss = USER_DS;
c0101ff6:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ff9:	66 c7 40 48 23 00    	movw   $0x23,0x48(%eax)
c0101fff:	8b 45 08             	mov    0x8(%ebp),%eax
c0102002:	0f b7 50 48          	movzwl 0x48(%eax),%edx
c0102006:	8b 45 08             	mov    0x8(%ebp),%eax
c0102009:	66 89 50 28          	mov    %dx,0x28(%eax)
c010200d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102010:	0f b7 50 28          	movzwl 0x28(%eax),%edx
c0102014:	8b 45 08             	mov    0x8(%ebp),%eax
c0102017:	66 89 50 2c          	mov    %dx,0x2c(%eax)
                tf->tf_eflags |= FL_IOPL_MASK;
c010201b:	8b 45 08             	mov    0x8(%ebp),%eax
c010201e:	8b 40 40             	mov    0x40(%eax),%eax
c0102021:	0d 00 30 00 00       	or     $0x3000,%eax
c0102026:	89 c2                	mov    %eax,%edx
c0102028:	8b 45 08             	mov    0x8(%ebp),%eax
c010202b:	89 50 40             	mov    %edx,0x40(%eax)
        break;
c010202e:	e9 ee 00 00 00       	jmp    c0102121 <trap_dispatch+0x2ab>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
 	case T_SWITCH_TOU:
        if(tf->tf_cs != USER_CS)	//检查是不是用户态，不是就操作
c0102033:	8b 45 08             	mov    0x8(%ebp),%eax
c0102036:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c010203a:	83 f8 1b             	cmp    $0x1b,%eax
c010203d:	0f 84 e1 00 00 00    	je     c0102124 <trap_dispatch+0x2ae>
        {
                cprintf("Switch to user\n");
c0102043:	c7 04 24 68 a6 10 c0 	movl   $0xc010a668,(%esp)
c010204a:	e8 7b e2 ff ff       	call   c01002ca <cprintf>
                // 设置用户态对应的cs,ds,es,ss四个寄存器
            	tf->tf_cs = USER_CS;
c010204f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102052:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
                tf->tf_ds = tf->tf_es = tf->tf_ss = USER_DS;
c0102058:	8b 45 08             	mov    0x8(%ebp),%eax
c010205b:	66 c7 40 48 23 00    	movw   $0x23,0x48(%eax)
c0102061:	8b 45 08             	mov    0x8(%ebp),%eax
c0102064:	0f b7 50 48          	movzwl 0x48(%eax),%edx
c0102068:	8b 45 08             	mov    0x8(%ebp),%eax
c010206b:	66 89 50 28          	mov    %dx,0x28(%eax)
c010206f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102072:	0f b7 50 28          	movzwl 0x28(%eax),%edx
c0102076:	8b 45 08             	mov    0x8(%ebp),%eax
c0102079:	66 89 50 2c          	mov    %dx,0x2c(%eax)
                // 降低IO权限，使用户态可以使用IO
                tf->tf_eflags |= FL_IOPL_MASK;
c010207d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102080:	8b 40 40             	mov    0x40(%eax),%eax
c0102083:	0d 00 30 00 00       	or     $0x3000,%eax
c0102088:	89 c2                	mov    %eax,%edx
c010208a:	8b 45 08             	mov    0x8(%ebp),%eax
c010208d:	89 50 40             	mov    %edx,0x40(%eax)
        }
        break;
c0102090:	e9 8f 00 00 00       	jmp    c0102124 <trap_dispatch+0x2ae>

	case T_SWITCH_TOK:
        if(tf->tf_cs != KERNEL_CS)	//检查是不是内核态，不是就操作
c0102095:	8b 45 08             	mov    0x8(%ebp),%eax
c0102098:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c010209c:	83 f8 08             	cmp    $0x8,%eax
c010209f:	0f 84 82 00 00 00    	je     c0102127 <trap_dispatch+0x2b1>
        {          
                cprintf("Switch to kernel\n");
c01020a5:	c7 04 24 78 a6 10 c0 	movl   $0xc010a678,(%esp)
c01020ac:	e8 19 e2 ff ff       	call   c01002ca <cprintf>
            	// 设置内核态对应的cs,ds,es三个寄存器
                tf->tf_cs = KERNEL_CS;
c01020b1:	8b 45 08             	mov    0x8(%ebp),%eax
c01020b4:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
                tf->tf_ds = tf->tf_es = KERNEL_DS;
c01020ba:	8b 45 08             	mov    0x8(%ebp),%eax
c01020bd:	66 c7 40 28 10 00    	movw   $0x10,0x28(%eax)
c01020c3:	8b 45 08             	mov    0x8(%ebp),%eax
c01020c6:	0f b7 50 28          	movzwl 0x28(%eax),%edx
c01020ca:	8b 45 08             	mov    0x8(%ebp),%eax
c01020cd:	66 89 50 2c          	mov    %dx,0x2c(%eax)
				// 用户态不再能使用I/O
                tf->tf_eflags &= ~FL_IOPL_MASK;
c01020d1:	8b 45 08             	mov    0x8(%ebp),%eax
c01020d4:	8b 40 40             	mov    0x40(%eax),%eax
c01020d7:	25 ff cf ff ff       	and    $0xffffcfff,%eax
c01020dc:	89 c2                	mov    %eax,%edx
c01020de:	8b 45 08             	mov    0x8(%ebp),%eax
c01020e1:	89 50 40             	mov    %edx,0x40(%eax)
        }
        break;
c01020e4:	eb 41                	jmp    c0102127 <trap_dispatch+0x2b1>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c01020e6:	8b 45 08             	mov    0x8(%ebp),%eax
c01020e9:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c01020ed:	83 e0 03             	and    $0x3,%eax
c01020f0:	85 c0                	test   %eax,%eax
c01020f2:	75 34                	jne    c0102128 <trap_dispatch+0x2b2>
            print_trapframe(tf);
c01020f4:	8b 45 08             	mov    0x8(%ebp),%eax
c01020f7:	89 04 24             	mov    %eax,(%esp)
c01020fa:	e8 06 fb ff ff       	call   c0101c05 <print_trapframe>
            panic("unexpected trap in kernel.\n");
c01020ff:	c7 44 24 08 8a a6 10 	movl   $0xc010a68a,0x8(%esp)
c0102106:	c0 
c0102107:	c7 44 24 04 dd 00 00 	movl   $0xdd,0x4(%esp)
c010210e:	00 
c010210f:	c7 04 24 4e a4 10 c0 	movl   $0xc010a44e,(%esp)
c0102116:	e8 1b e3 ff ff       	call   c0100436 <__panic>
        break;
c010211b:	90                   	nop
c010211c:	eb 0a                	jmp    c0102128 <trap_dispatch+0x2b2>
        break;
c010211e:	90                   	nop
c010211f:	eb 07                	jmp    c0102128 <trap_dispatch+0x2b2>
        break;
c0102121:	90                   	nop
c0102122:	eb 04                	jmp    c0102128 <trap_dispatch+0x2b2>
        break;
c0102124:	90                   	nop
c0102125:	eb 01                	jmp    c0102128 <trap_dispatch+0x2b2>
        break;
c0102127:	90                   	nop
        }
    }
}
c0102128:	90                   	nop
c0102129:	c9                   	leave  
c010212a:	c3                   	ret    

c010212b <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c010212b:	f3 0f 1e fb          	endbr32 
c010212f:	55                   	push   %ebp
c0102130:	89 e5                	mov    %esp,%ebp
c0102132:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c0102135:	8b 45 08             	mov    0x8(%ebp),%eax
c0102138:	89 04 24             	mov    %eax,(%esp)
c010213b:	e8 36 fd ff ff       	call   c0101e76 <trap_dispatch>
}
c0102140:	90                   	nop
c0102141:	c9                   	leave  
c0102142:	c3                   	ret    

c0102143 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c0102143:	6a 00                	push   $0x0
  pushl $0
c0102145:	6a 00                	push   $0x0
  jmp __alltraps
c0102147:	e9 69 0a 00 00       	jmp    c0102bb5 <__alltraps>

c010214c <vector1>:
.globl vector1
vector1:
  pushl $0
c010214c:	6a 00                	push   $0x0
  pushl $1
c010214e:	6a 01                	push   $0x1
  jmp __alltraps
c0102150:	e9 60 0a 00 00       	jmp    c0102bb5 <__alltraps>

c0102155 <vector2>:
.globl vector2
vector2:
  pushl $0
c0102155:	6a 00                	push   $0x0
  pushl $2
c0102157:	6a 02                	push   $0x2
  jmp __alltraps
c0102159:	e9 57 0a 00 00       	jmp    c0102bb5 <__alltraps>

c010215e <vector3>:
.globl vector3
vector3:
  pushl $0
c010215e:	6a 00                	push   $0x0
  pushl $3
c0102160:	6a 03                	push   $0x3
  jmp __alltraps
c0102162:	e9 4e 0a 00 00       	jmp    c0102bb5 <__alltraps>

c0102167 <vector4>:
.globl vector4
vector4:
  pushl $0
c0102167:	6a 00                	push   $0x0
  pushl $4
c0102169:	6a 04                	push   $0x4
  jmp __alltraps
c010216b:	e9 45 0a 00 00       	jmp    c0102bb5 <__alltraps>

c0102170 <vector5>:
.globl vector5
vector5:
  pushl $0
c0102170:	6a 00                	push   $0x0
  pushl $5
c0102172:	6a 05                	push   $0x5
  jmp __alltraps
c0102174:	e9 3c 0a 00 00       	jmp    c0102bb5 <__alltraps>

c0102179 <vector6>:
.globl vector6
vector6:
  pushl $0
c0102179:	6a 00                	push   $0x0
  pushl $6
c010217b:	6a 06                	push   $0x6
  jmp __alltraps
c010217d:	e9 33 0a 00 00       	jmp    c0102bb5 <__alltraps>

c0102182 <vector7>:
.globl vector7
vector7:
  pushl $0
c0102182:	6a 00                	push   $0x0
  pushl $7
c0102184:	6a 07                	push   $0x7
  jmp __alltraps
c0102186:	e9 2a 0a 00 00       	jmp    c0102bb5 <__alltraps>

c010218b <vector8>:
.globl vector8
vector8:
  pushl $8
c010218b:	6a 08                	push   $0x8
  jmp __alltraps
c010218d:	e9 23 0a 00 00       	jmp    c0102bb5 <__alltraps>

c0102192 <vector9>:
.globl vector9
vector9:
  pushl $0
c0102192:	6a 00                	push   $0x0
  pushl $9
c0102194:	6a 09                	push   $0x9
  jmp __alltraps
c0102196:	e9 1a 0a 00 00       	jmp    c0102bb5 <__alltraps>

c010219b <vector10>:
.globl vector10
vector10:
  pushl $10
c010219b:	6a 0a                	push   $0xa
  jmp __alltraps
c010219d:	e9 13 0a 00 00       	jmp    c0102bb5 <__alltraps>

c01021a2 <vector11>:
.globl vector11
vector11:
  pushl $11
c01021a2:	6a 0b                	push   $0xb
  jmp __alltraps
c01021a4:	e9 0c 0a 00 00       	jmp    c0102bb5 <__alltraps>

c01021a9 <vector12>:
.globl vector12
vector12:
  pushl $12
c01021a9:	6a 0c                	push   $0xc
  jmp __alltraps
c01021ab:	e9 05 0a 00 00       	jmp    c0102bb5 <__alltraps>

c01021b0 <vector13>:
.globl vector13
vector13:
  pushl $13
c01021b0:	6a 0d                	push   $0xd
  jmp __alltraps
c01021b2:	e9 fe 09 00 00       	jmp    c0102bb5 <__alltraps>

c01021b7 <vector14>:
.globl vector14
vector14:
  pushl $14
c01021b7:	6a 0e                	push   $0xe
  jmp __alltraps
c01021b9:	e9 f7 09 00 00       	jmp    c0102bb5 <__alltraps>

c01021be <vector15>:
.globl vector15
vector15:
  pushl $0
c01021be:	6a 00                	push   $0x0
  pushl $15
c01021c0:	6a 0f                	push   $0xf
  jmp __alltraps
c01021c2:	e9 ee 09 00 00       	jmp    c0102bb5 <__alltraps>

c01021c7 <vector16>:
.globl vector16
vector16:
  pushl $0
c01021c7:	6a 00                	push   $0x0
  pushl $16
c01021c9:	6a 10                	push   $0x10
  jmp __alltraps
c01021cb:	e9 e5 09 00 00       	jmp    c0102bb5 <__alltraps>

c01021d0 <vector17>:
.globl vector17
vector17:
  pushl $17
c01021d0:	6a 11                	push   $0x11
  jmp __alltraps
c01021d2:	e9 de 09 00 00       	jmp    c0102bb5 <__alltraps>

c01021d7 <vector18>:
.globl vector18
vector18:
  pushl $0
c01021d7:	6a 00                	push   $0x0
  pushl $18
c01021d9:	6a 12                	push   $0x12
  jmp __alltraps
c01021db:	e9 d5 09 00 00       	jmp    c0102bb5 <__alltraps>

c01021e0 <vector19>:
.globl vector19
vector19:
  pushl $0
c01021e0:	6a 00                	push   $0x0
  pushl $19
c01021e2:	6a 13                	push   $0x13
  jmp __alltraps
c01021e4:	e9 cc 09 00 00       	jmp    c0102bb5 <__alltraps>

c01021e9 <vector20>:
.globl vector20
vector20:
  pushl $0
c01021e9:	6a 00                	push   $0x0
  pushl $20
c01021eb:	6a 14                	push   $0x14
  jmp __alltraps
c01021ed:	e9 c3 09 00 00       	jmp    c0102bb5 <__alltraps>

c01021f2 <vector21>:
.globl vector21
vector21:
  pushl $0
c01021f2:	6a 00                	push   $0x0
  pushl $21
c01021f4:	6a 15                	push   $0x15
  jmp __alltraps
c01021f6:	e9 ba 09 00 00       	jmp    c0102bb5 <__alltraps>

c01021fb <vector22>:
.globl vector22
vector22:
  pushl $0
c01021fb:	6a 00                	push   $0x0
  pushl $22
c01021fd:	6a 16                	push   $0x16
  jmp __alltraps
c01021ff:	e9 b1 09 00 00       	jmp    c0102bb5 <__alltraps>

c0102204 <vector23>:
.globl vector23
vector23:
  pushl $0
c0102204:	6a 00                	push   $0x0
  pushl $23
c0102206:	6a 17                	push   $0x17
  jmp __alltraps
c0102208:	e9 a8 09 00 00       	jmp    c0102bb5 <__alltraps>

c010220d <vector24>:
.globl vector24
vector24:
  pushl $0
c010220d:	6a 00                	push   $0x0
  pushl $24
c010220f:	6a 18                	push   $0x18
  jmp __alltraps
c0102211:	e9 9f 09 00 00       	jmp    c0102bb5 <__alltraps>

c0102216 <vector25>:
.globl vector25
vector25:
  pushl $0
c0102216:	6a 00                	push   $0x0
  pushl $25
c0102218:	6a 19                	push   $0x19
  jmp __alltraps
c010221a:	e9 96 09 00 00       	jmp    c0102bb5 <__alltraps>

c010221f <vector26>:
.globl vector26
vector26:
  pushl $0
c010221f:	6a 00                	push   $0x0
  pushl $26
c0102221:	6a 1a                	push   $0x1a
  jmp __alltraps
c0102223:	e9 8d 09 00 00       	jmp    c0102bb5 <__alltraps>

c0102228 <vector27>:
.globl vector27
vector27:
  pushl $0
c0102228:	6a 00                	push   $0x0
  pushl $27
c010222a:	6a 1b                	push   $0x1b
  jmp __alltraps
c010222c:	e9 84 09 00 00       	jmp    c0102bb5 <__alltraps>

c0102231 <vector28>:
.globl vector28
vector28:
  pushl $0
c0102231:	6a 00                	push   $0x0
  pushl $28
c0102233:	6a 1c                	push   $0x1c
  jmp __alltraps
c0102235:	e9 7b 09 00 00       	jmp    c0102bb5 <__alltraps>

c010223a <vector29>:
.globl vector29
vector29:
  pushl $0
c010223a:	6a 00                	push   $0x0
  pushl $29
c010223c:	6a 1d                	push   $0x1d
  jmp __alltraps
c010223e:	e9 72 09 00 00       	jmp    c0102bb5 <__alltraps>

c0102243 <vector30>:
.globl vector30
vector30:
  pushl $0
c0102243:	6a 00                	push   $0x0
  pushl $30
c0102245:	6a 1e                	push   $0x1e
  jmp __alltraps
c0102247:	e9 69 09 00 00       	jmp    c0102bb5 <__alltraps>

c010224c <vector31>:
.globl vector31
vector31:
  pushl $0
c010224c:	6a 00                	push   $0x0
  pushl $31
c010224e:	6a 1f                	push   $0x1f
  jmp __alltraps
c0102250:	e9 60 09 00 00       	jmp    c0102bb5 <__alltraps>

c0102255 <vector32>:
.globl vector32
vector32:
  pushl $0
c0102255:	6a 00                	push   $0x0
  pushl $32
c0102257:	6a 20                	push   $0x20
  jmp __alltraps
c0102259:	e9 57 09 00 00       	jmp    c0102bb5 <__alltraps>

c010225e <vector33>:
.globl vector33
vector33:
  pushl $0
c010225e:	6a 00                	push   $0x0
  pushl $33
c0102260:	6a 21                	push   $0x21
  jmp __alltraps
c0102262:	e9 4e 09 00 00       	jmp    c0102bb5 <__alltraps>

c0102267 <vector34>:
.globl vector34
vector34:
  pushl $0
c0102267:	6a 00                	push   $0x0
  pushl $34
c0102269:	6a 22                	push   $0x22
  jmp __alltraps
c010226b:	e9 45 09 00 00       	jmp    c0102bb5 <__alltraps>

c0102270 <vector35>:
.globl vector35
vector35:
  pushl $0
c0102270:	6a 00                	push   $0x0
  pushl $35
c0102272:	6a 23                	push   $0x23
  jmp __alltraps
c0102274:	e9 3c 09 00 00       	jmp    c0102bb5 <__alltraps>

c0102279 <vector36>:
.globl vector36
vector36:
  pushl $0
c0102279:	6a 00                	push   $0x0
  pushl $36
c010227b:	6a 24                	push   $0x24
  jmp __alltraps
c010227d:	e9 33 09 00 00       	jmp    c0102bb5 <__alltraps>

c0102282 <vector37>:
.globl vector37
vector37:
  pushl $0
c0102282:	6a 00                	push   $0x0
  pushl $37
c0102284:	6a 25                	push   $0x25
  jmp __alltraps
c0102286:	e9 2a 09 00 00       	jmp    c0102bb5 <__alltraps>

c010228b <vector38>:
.globl vector38
vector38:
  pushl $0
c010228b:	6a 00                	push   $0x0
  pushl $38
c010228d:	6a 26                	push   $0x26
  jmp __alltraps
c010228f:	e9 21 09 00 00       	jmp    c0102bb5 <__alltraps>

c0102294 <vector39>:
.globl vector39
vector39:
  pushl $0
c0102294:	6a 00                	push   $0x0
  pushl $39
c0102296:	6a 27                	push   $0x27
  jmp __alltraps
c0102298:	e9 18 09 00 00       	jmp    c0102bb5 <__alltraps>

c010229d <vector40>:
.globl vector40
vector40:
  pushl $0
c010229d:	6a 00                	push   $0x0
  pushl $40
c010229f:	6a 28                	push   $0x28
  jmp __alltraps
c01022a1:	e9 0f 09 00 00       	jmp    c0102bb5 <__alltraps>

c01022a6 <vector41>:
.globl vector41
vector41:
  pushl $0
c01022a6:	6a 00                	push   $0x0
  pushl $41
c01022a8:	6a 29                	push   $0x29
  jmp __alltraps
c01022aa:	e9 06 09 00 00       	jmp    c0102bb5 <__alltraps>

c01022af <vector42>:
.globl vector42
vector42:
  pushl $0
c01022af:	6a 00                	push   $0x0
  pushl $42
c01022b1:	6a 2a                	push   $0x2a
  jmp __alltraps
c01022b3:	e9 fd 08 00 00       	jmp    c0102bb5 <__alltraps>

c01022b8 <vector43>:
.globl vector43
vector43:
  pushl $0
c01022b8:	6a 00                	push   $0x0
  pushl $43
c01022ba:	6a 2b                	push   $0x2b
  jmp __alltraps
c01022bc:	e9 f4 08 00 00       	jmp    c0102bb5 <__alltraps>

c01022c1 <vector44>:
.globl vector44
vector44:
  pushl $0
c01022c1:	6a 00                	push   $0x0
  pushl $44
c01022c3:	6a 2c                	push   $0x2c
  jmp __alltraps
c01022c5:	e9 eb 08 00 00       	jmp    c0102bb5 <__alltraps>

c01022ca <vector45>:
.globl vector45
vector45:
  pushl $0
c01022ca:	6a 00                	push   $0x0
  pushl $45
c01022cc:	6a 2d                	push   $0x2d
  jmp __alltraps
c01022ce:	e9 e2 08 00 00       	jmp    c0102bb5 <__alltraps>

c01022d3 <vector46>:
.globl vector46
vector46:
  pushl $0
c01022d3:	6a 00                	push   $0x0
  pushl $46
c01022d5:	6a 2e                	push   $0x2e
  jmp __alltraps
c01022d7:	e9 d9 08 00 00       	jmp    c0102bb5 <__alltraps>

c01022dc <vector47>:
.globl vector47
vector47:
  pushl $0
c01022dc:	6a 00                	push   $0x0
  pushl $47
c01022de:	6a 2f                	push   $0x2f
  jmp __alltraps
c01022e0:	e9 d0 08 00 00       	jmp    c0102bb5 <__alltraps>

c01022e5 <vector48>:
.globl vector48
vector48:
  pushl $0
c01022e5:	6a 00                	push   $0x0
  pushl $48
c01022e7:	6a 30                	push   $0x30
  jmp __alltraps
c01022e9:	e9 c7 08 00 00       	jmp    c0102bb5 <__alltraps>

c01022ee <vector49>:
.globl vector49
vector49:
  pushl $0
c01022ee:	6a 00                	push   $0x0
  pushl $49
c01022f0:	6a 31                	push   $0x31
  jmp __alltraps
c01022f2:	e9 be 08 00 00       	jmp    c0102bb5 <__alltraps>

c01022f7 <vector50>:
.globl vector50
vector50:
  pushl $0
c01022f7:	6a 00                	push   $0x0
  pushl $50
c01022f9:	6a 32                	push   $0x32
  jmp __alltraps
c01022fb:	e9 b5 08 00 00       	jmp    c0102bb5 <__alltraps>

c0102300 <vector51>:
.globl vector51
vector51:
  pushl $0
c0102300:	6a 00                	push   $0x0
  pushl $51
c0102302:	6a 33                	push   $0x33
  jmp __alltraps
c0102304:	e9 ac 08 00 00       	jmp    c0102bb5 <__alltraps>

c0102309 <vector52>:
.globl vector52
vector52:
  pushl $0
c0102309:	6a 00                	push   $0x0
  pushl $52
c010230b:	6a 34                	push   $0x34
  jmp __alltraps
c010230d:	e9 a3 08 00 00       	jmp    c0102bb5 <__alltraps>

c0102312 <vector53>:
.globl vector53
vector53:
  pushl $0
c0102312:	6a 00                	push   $0x0
  pushl $53
c0102314:	6a 35                	push   $0x35
  jmp __alltraps
c0102316:	e9 9a 08 00 00       	jmp    c0102bb5 <__alltraps>

c010231b <vector54>:
.globl vector54
vector54:
  pushl $0
c010231b:	6a 00                	push   $0x0
  pushl $54
c010231d:	6a 36                	push   $0x36
  jmp __alltraps
c010231f:	e9 91 08 00 00       	jmp    c0102bb5 <__alltraps>

c0102324 <vector55>:
.globl vector55
vector55:
  pushl $0
c0102324:	6a 00                	push   $0x0
  pushl $55
c0102326:	6a 37                	push   $0x37
  jmp __alltraps
c0102328:	e9 88 08 00 00       	jmp    c0102bb5 <__alltraps>

c010232d <vector56>:
.globl vector56
vector56:
  pushl $0
c010232d:	6a 00                	push   $0x0
  pushl $56
c010232f:	6a 38                	push   $0x38
  jmp __alltraps
c0102331:	e9 7f 08 00 00       	jmp    c0102bb5 <__alltraps>

c0102336 <vector57>:
.globl vector57
vector57:
  pushl $0
c0102336:	6a 00                	push   $0x0
  pushl $57
c0102338:	6a 39                	push   $0x39
  jmp __alltraps
c010233a:	e9 76 08 00 00       	jmp    c0102bb5 <__alltraps>

c010233f <vector58>:
.globl vector58
vector58:
  pushl $0
c010233f:	6a 00                	push   $0x0
  pushl $58
c0102341:	6a 3a                	push   $0x3a
  jmp __alltraps
c0102343:	e9 6d 08 00 00       	jmp    c0102bb5 <__alltraps>

c0102348 <vector59>:
.globl vector59
vector59:
  pushl $0
c0102348:	6a 00                	push   $0x0
  pushl $59
c010234a:	6a 3b                	push   $0x3b
  jmp __alltraps
c010234c:	e9 64 08 00 00       	jmp    c0102bb5 <__alltraps>

c0102351 <vector60>:
.globl vector60
vector60:
  pushl $0
c0102351:	6a 00                	push   $0x0
  pushl $60
c0102353:	6a 3c                	push   $0x3c
  jmp __alltraps
c0102355:	e9 5b 08 00 00       	jmp    c0102bb5 <__alltraps>

c010235a <vector61>:
.globl vector61
vector61:
  pushl $0
c010235a:	6a 00                	push   $0x0
  pushl $61
c010235c:	6a 3d                	push   $0x3d
  jmp __alltraps
c010235e:	e9 52 08 00 00       	jmp    c0102bb5 <__alltraps>

c0102363 <vector62>:
.globl vector62
vector62:
  pushl $0
c0102363:	6a 00                	push   $0x0
  pushl $62
c0102365:	6a 3e                	push   $0x3e
  jmp __alltraps
c0102367:	e9 49 08 00 00       	jmp    c0102bb5 <__alltraps>

c010236c <vector63>:
.globl vector63
vector63:
  pushl $0
c010236c:	6a 00                	push   $0x0
  pushl $63
c010236e:	6a 3f                	push   $0x3f
  jmp __alltraps
c0102370:	e9 40 08 00 00       	jmp    c0102bb5 <__alltraps>

c0102375 <vector64>:
.globl vector64
vector64:
  pushl $0
c0102375:	6a 00                	push   $0x0
  pushl $64
c0102377:	6a 40                	push   $0x40
  jmp __alltraps
c0102379:	e9 37 08 00 00       	jmp    c0102bb5 <__alltraps>

c010237e <vector65>:
.globl vector65
vector65:
  pushl $0
c010237e:	6a 00                	push   $0x0
  pushl $65
c0102380:	6a 41                	push   $0x41
  jmp __alltraps
c0102382:	e9 2e 08 00 00       	jmp    c0102bb5 <__alltraps>

c0102387 <vector66>:
.globl vector66
vector66:
  pushl $0
c0102387:	6a 00                	push   $0x0
  pushl $66
c0102389:	6a 42                	push   $0x42
  jmp __alltraps
c010238b:	e9 25 08 00 00       	jmp    c0102bb5 <__alltraps>

c0102390 <vector67>:
.globl vector67
vector67:
  pushl $0
c0102390:	6a 00                	push   $0x0
  pushl $67
c0102392:	6a 43                	push   $0x43
  jmp __alltraps
c0102394:	e9 1c 08 00 00       	jmp    c0102bb5 <__alltraps>

c0102399 <vector68>:
.globl vector68
vector68:
  pushl $0
c0102399:	6a 00                	push   $0x0
  pushl $68
c010239b:	6a 44                	push   $0x44
  jmp __alltraps
c010239d:	e9 13 08 00 00       	jmp    c0102bb5 <__alltraps>

c01023a2 <vector69>:
.globl vector69
vector69:
  pushl $0
c01023a2:	6a 00                	push   $0x0
  pushl $69
c01023a4:	6a 45                	push   $0x45
  jmp __alltraps
c01023a6:	e9 0a 08 00 00       	jmp    c0102bb5 <__alltraps>

c01023ab <vector70>:
.globl vector70
vector70:
  pushl $0
c01023ab:	6a 00                	push   $0x0
  pushl $70
c01023ad:	6a 46                	push   $0x46
  jmp __alltraps
c01023af:	e9 01 08 00 00       	jmp    c0102bb5 <__alltraps>

c01023b4 <vector71>:
.globl vector71
vector71:
  pushl $0
c01023b4:	6a 00                	push   $0x0
  pushl $71
c01023b6:	6a 47                	push   $0x47
  jmp __alltraps
c01023b8:	e9 f8 07 00 00       	jmp    c0102bb5 <__alltraps>

c01023bd <vector72>:
.globl vector72
vector72:
  pushl $0
c01023bd:	6a 00                	push   $0x0
  pushl $72
c01023bf:	6a 48                	push   $0x48
  jmp __alltraps
c01023c1:	e9 ef 07 00 00       	jmp    c0102bb5 <__alltraps>

c01023c6 <vector73>:
.globl vector73
vector73:
  pushl $0
c01023c6:	6a 00                	push   $0x0
  pushl $73
c01023c8:	6a 49                	push   $0x49
  jmp __alltraps
c01023ca:	e9 e6 07 00 00       	jmp    c0102bb5 <__alltraps>

c01023cf <vector74>:
.globl vector74
vector74:
  pushl $0
c01023cf:	6a 00                	push   $0x0
  pushl $74
c01023d1:	6a 4a                	push   $0x4a
  jmp __alltraps
c01023d3:	e9 dd 07 00 00       	jmp    c0102bb5 <__alltraps>

c01023d8 <vector75>:
.globl vector75
vector75:
  pushl $0
c01023d8:	6a 00                	push   $0x0
  pushl $75
c01023da:	6a 4b                	push   $0x4b
  jmp __alltraps
c01023dc:	e9 d4 07 00 00       	jmp    c0102bb5 <__alltraps>

c01023e1 <vector76>:
.globl vector76
vector76:
  pushl $0
c01023e1:	6a 00                	push   $0x0
  pushl $76
c01023e3:	6a 4c                	push   $0x4c
  jmp __alltraps
c01023e5:	e9 cb 07 00 00       	jmp    c0102bb5 <__alltraps>

c01023ea <vector77>:
.globl vector77
vector77:
  pushl $0
c01023ea:	6a 00                	push   $0x0
  pushl $77
c01023ec:	6a 4d                	push   $0x4d
  jmp __alltraps
c01023ee:	e9 c2 07 00 00       	jmp    c0102bb5 <__alltraps>

c01023f3 <vector78>:
.globl vector78
vector78:
  pushl $0
c01023f3:	6a 00                	push   $0x0
  pushl $78
c01023f5:	6a 4e                	push   $0x4e
  jmp __alltraps
c01023f7:	e9 b9 07 00 00       	jmp    c0102bb5 <__alltraps>

c01023fc <vector79>:
.globl vector79
vector79:
  pushl $0
c01023fc:	6a 00                	push   $0x0
  pushl $79
c01023fe:	6a 4f                	push   $0x4f
  jmp __alltraps
c0102400:	e9 b0 07 00 00       	jmp    c0102bb5 <__alltraps>

c0102405 <vector80>:
.globl vector80
vector80:
  pushl $0
c0102405:	6a 00                	push   $0x0
  pushl $80
c0102407:	6a 50                	push   $0x50
  jmp __alltraps
c0102409:	e9 a7 07 00 00       	jmp    c0102bb5 <__alltraps>

c010240e <vector81>:
.globl vector81
vector81:
  pushl $0
c010240e:	6a 00                	push   $0x0
  pushl $81
c0102410:	6a 51                	push   $0x51
  jmp __alltraps
c0102412:	e9 9e 07 00 00       	jmp    c0102bb5 <__alltraps>

c0102417 <vector82>:
.globl vector82
vector82:
  pushl $0
c0102417:	6a 00                	push   $0x0
  pushl $82
c0102419:	6a 52                	push   $0x52
  jmp __alltraps
c010241b:	e9 95 07 00 00       	jmp    c0102bb5 <__alltraps>

c0102420 <vector83>:
.globl vector83
vector83:
  pushl $0
c0102420:	6a 00                	push   $0x0
  pushl $83
c0102422:	6a 53                	push   $0x53
  jmp __alltraps
c0102424:	e9 8c 07 00 00       	jmp    c0102bb5 <__alltraps>

c0102429 <vector84>:
.globl vector84
vector84:
  pushl $0
c0102429:	6a 00                	push   $0x0
  pushl $84
c010242b:	6a 54                	push   $0x54
  jmp __alltraps
c010242d:	e9 83 07 00 00       	jmp    c0102bb5 <__alltraps>

c0102432 <vector85>:
.globl vector85
vector85:
  pushl $0
c0102432:	6a 00                	push   $0x0
  pushl $85
c0102434:	6a 55                	push   $0x55
  jmp __alltraps
c0102436:	e9 7a 07 00 00       	jmp    c0102bb5 <__alltraps>

c010243b <vector86>:
.globl vector86
vector86:
  pushl $0
c010243b:	6a 00                	push   $0x0
  pushl $86
c010243d:	6a 56                	push   $0x56
  jmp __alltraps
c010243f:	e9 71 07 00 00       	jmp    c0102bb5 <__alltraps>

c0102444 <vector87>:
.globl vector87
vector87:
  pushl $0
c0102444:	6a 00                	push   $0x0
  pushl $87
c0102446:	6a 57                	push   $0x57
  jmp __alltraps
c0102448:	e9 68 07 00 00       	jmp    c0102bb5 <__alltraps>

c010244d <vector88>:
.globl vector88
vector88:
  pushl $0
c010244d:	6a 00                	push   $0x0
  pushl $88
c010244f:	6a 58                	push   $0x58
  jmp __alltraps
c0102451:	e9 5f 07 00 00       	jmp    c0102bb5 <__alltraps>

c0102456 <vector89>:
.globl vector89
vector89:
  pushl $0
c0102456:	6a 00                	push   $0x0
  pushl $89
c0102458:	6a 59                	push   $0x59
  jmp __alltraps
c010245a:	e9 56 07 00 00       	jmp    c0102bb5 <__alltraps>

c010245f <vector90>:
.globl vector90
vector90:
  pushl $0
c010245f:	6a 00                	push   $0x0
  pushl $90
c0102461:	6a 5a                	push   $0x5a
  jmp __alltraps
c0102463:	e9 4d 07 00 00       	jmp    c0102bb5 <__alltraps>

c0102468 <vector91>:
.globl vector91
vector91:
  pushl $0
c0102468:	6a 00                	push   $0x0
  pushl $91
c010246a:	6a 5b                	push   $0x5b
  jmp __alltraps
c010246c:	e9 44 07 00 00       	jmp    c0102bb5 <__alltraps>

c0102471 <vector92>:
.globl vector92
vector92:
  pushl $0
c0102471:	6a 00                	push   $0x0
  pushl $92
c0102473:	6a 5c                	push   $0x5c
  jmp __alltraps
c0102475:	e9 3b 07 00 00       	jmp    c0102bb5 <__alltraps>

c010247a <vector93>:
.globl vector93
vector93:
  pushl $0
c010247a:	6a 00                	push   $0x0
  pushl $93
c010247c:	6a 5d                	push   $0x5d
  jmp __alltraps
c010247e:	e9 32 07 00 00       	jmp    c0102bb5 <__alltraps>

c0102483 <vector94>:
.globl vector94
vector94:
  pushl $0
c0102483:	6a 00                	push   $0x0
  pushl $94
c0102485:	6a 5e                	push   $0x5e
  jmp __alltraps
c0102487:	e9 29 07 00 00       	jmp    c0102bb5 <__alltraps>

c010248c <vector95>:
.globl vector95
vector95:
  pushl $0
c010248c:	6a 00                	push   $0x0
  pushl $95
c010248e:	6a 5f                	push   $0x5f
  jmp __alltraps
c0102490:	e9 20 07 00 00       	jmp    c0102bb5 <__alltraps>

c0102495 <vector96>:
.globl vector96
vector96:
  pushl $0
c0102495:	6a 00                	push   $0x0
  pushl $96
c0102497:	6a 60                	push   $0x60
  jmp __alltraps
c0102499:	e9 17 07 00 00       	jmp    c0102bb5 <__alltraps>

c010249e <vector97>:
.globl vector97
vector97:
  pushl $0
c010249e:	6a 00                	push   $0x0
  pushl $97
c01024a0:	6a 61                	push   $0x61
  jmp __alltraps
c01024a2:	e9 0e 07 00 00       	jmp    c0102bb5 <__alltraps>

c01024a7 <vector98>:
.globl vector98
vector98:
  pushl $0
c01024a7:	6a 00                	push   $0x0
  pushl $98
c01024a9:	6a 62                	push   $0x62
  jmp __alltraps
c01024ab:	e9 05 07 00 00       	jmp    c0102bb5 <__alltraps>

c01024b0 <vector99>:
.globl vector99
vector99:
  pushl $0
c01024b0:	6a 00                	push   $0x0
  pushl $99
c01024b2:	6a 63                	push   $0x63
  jmp __alltraps
c01024b4:	e9 fc 06 00 00       	jmp    c0102bb5 <__alltraps>

c01024b9 <vector100>:
.globl vector100
vector100:
  pushl $0
c01024b9:	6a 00                	push   $0x0
  pushl $100
c01024bb:	6a 64                	push   $0x64
  jmp __alltraps
c01024bd:	e9 f3 06 00 00       	jmp    c0102bb5 <__alltraps>

c01024c2 <vector101>:
.globl vector101
vector101:
  pushl $0
c01024c2:	6a 00                	push   $0x0
  pushl $101
c01024c4:	6a 65                	push   $0x65
  jmp __alltraps
c01024c6:	e9 ea 06 00 00       	jmp    c0102bb5 <__alltraps>

c01024cb <vector102>:
.globl vector102
vector102:
  pushl $0
c01024cb:	6a 00                	push   $0x0
  pushl $102
c01024cd:	6a 66                	push   $0x66
  jmp __alltraps
c01024cf:	e9 e1 06 00 00       	jmp    c0102bb5 <__alltraps>

c01024d4 <vector103>:
.globl vector103
vector103:
  pushl $0
c01024d4:	6a 00                	push   $0x0
  pushl $103
c01024d6:	6a 67                	push   $0x67
  jmp __alltraps
c01024d8:	e9 d8 06 00 00       	jmp    c0102bb5 <__alltraps>

c01024dd <vector104>:
.globl vector104
vector104:
  pushl $0
c01024dd:	6a 00                	push   $0x0
  pushl $104
c01024df:	6a 68                	push   $0x68
  jmp __alltraps
c01024e1:	e9 cf 06 00 00       	jmp    c0102bb5 <__alltraps>

c01024e6 <vector105>:
.globl vector105
vector105:
  pushl $0
c01024e6:	6a 00                	push   $0x0
  pushl $105
c01024e8:	6a 69                	push   $0x69
  jmp __alltraps
c01024ea:	e9 c6 06 00 00       	jmp    c0102bb5 <__alltraps>

c01024ef <vector106>:
.globl vector106
vector106:
  pushl $0
c01024ef:	6a 00                	push   $0x0
  pushl $106
c01024f1:	6a 6a                	push   $0x6a
  jmp __alltraps
c01024f3:	e9 bd 06 00 00       	jmp    c0102bb5 <__alltraps>

c01024f8 <vector107>:
.globl vector107
vector107:
  pushl $0
c01024f8:	6a 00                	push   $0x0
  pushl $107
c01024fa:	6a 6b                	push   $0x6b
  jmp __alltraps
c01024fc:	e9 b4 06 00 00       	jmp    c0102bb5 <__alltraps>

c0102501 <vector108>:
.globl vector108
vector108:
  pushl $0
c0102501:	6a 00                	push   $0x0
  pushl $108
c0102503:	6a 6c                	push   $0x6c
  jmp __alltraps
c0102505:	e9 ab 06 00 00       	jmp    c0102bb5 <__alltraps>

c010250a <vector109>:
.globl vector109
vector109:
  pushl $0
c010250a:	6a 00                	push   $0x0
  pushl $109
c010250c:	6a 6d                	push   $0x6d
  jmp __alltraps
c010250e:	e9 a2 06 00 00       	jmp    c0102bb5 <__alltraps>

c0102513 <vector110>:
.globl vector110
vector110:
  pushl $0
c0102513:	6a 00                	push   $0x0
  pushl $110
c0102515:	6a 6e                	push   $0x6e
  jmp __alltraps
c0102517:	e9 99 06 00 00       	jmp    c0102bb5 <__alltraps>

c010251c <vector111>:
.globl vector111
vector111:
  pushl $0
c010251c:	6a 00                	push   $0x0
  pushl $111
c010251e:	6a 6f                	push   $0x6f
  jmp __alltraps
c0102520:	e9 90 06 00 00       	jmp    c0102bb5 <__alltraps>

c0102525 <vector112>:
.globl vector112
vector112:
  pushl $0
c0102525:	6a 00                	push   $0x0
  pushl $112
c0102527:	6a 70                	push   $0x70
  jmp __alltraps
c0102529:	e9 87 06 00 00       	jmp    c0102bb5 <__alltraps>

c010252e <vector113>:
.globl vector113
vector113:
  pushl $0
c010252e:	6a 00                	push   $0x0
  pushl $113
c0102530:	6a 71                	push   $0x71
  jmp __alltraps
c0102532:	e9 7e 06 00 00       	jmp    c0102bb5 <__alltraps>

c0102537 <vector114>:
.globl vector114
vector114:
  pushl $0
c0102537:	6a 00                	push   $0x0
  pushl $114
c0102539:	6a 72                	push   $0x72
  jmp __alltraps
c010253b:	e9 75 06 00 00       	jmp    c0102bb5 <__alltraps>

c0102540 <vector115>:
.globl vector115
vector115:
  pushl $0
c0102540:	6a 00                	push   $0x0
  pushl $115
c0102542:	6a 73                	push   $0x73
  jmp __alltraps
c0102544:	e9 6c 06 00 00       	jmp    c0102bb5 <__alltraps>

c0102549 <vector116>:
.globl vector116
vector116:
  pushl $0
c0102549:	6a 00                	push   $0x0
  pushl $116
c010254b:	6a 74                	push   $0x74
  jmp __alltraps
c010254d:	e9 63 06 00 00       	jmp    c0102bb5 <__alltraps>

c0102552 <vector117>:
.globl vector117
vector117:
  pushl $0
c0102552:	6a 00                	push   $0x0
  pushl $117
c0102554:	6a 75                	push   $0x75
  jmp __alltraps
c0102556:	e9 5a 06 00 00       	jmp    c0102bb5 <__alltraps>

c010255b <vector118>:
.globl vector118
vector118:
  pushl $0
c010255b:	6a 00                	push   $0x0
  pushl $118
c010255d:	6a 76                	push   $0x76
  jmp __alltraps
c010255f:	e9 51 06 00 00       	jmp    c0102bb5 <__alltraps>

c0102564 <vector119>:
.globl vector119
vector119:
  pushl $0
c0102564:	6a 00                	push   $0x0
  pushl $119
c0102566:	6a 77                	push   $0x77
  jmp __alltraps
c0102568:	e9 48 06 00 00       	jmp    c0102bb5 <__alltraps>

c010256d <vector120>:
.globl vector120
vector120:
  pushl $0
c010256d:	6a 00                	push   $0x0
  pushl $120
c010256f:	6a 78                	push   $0x78
  jmp __alltraps
c0102571:	e9 3f 06 00 00       	jmp    c0102bb5 <__alltraps>

c0102576 <vector121>:
.globl vector121
vector121:
  pushl $0
c0102576:	6a 00                	push   $0x0
  pushl $121
c0102578:	6a 79                	push   $0x79
  jmp __alltraps
c010257a:	e9 36 06 00 00       	jmp    c0102bb5 <__alltraps>

c010257f <vector122>:
.globl vector122
vector122:
  pushl $0
c010257f:	6a 00                	push   $0x0
  pushl $122
c0102581:	6a 7a                	push   $0x7a
  jmp __alltraps
c0102583:	e9 2d 06 00 00       	jmp    c0102bb5 <__alltraps>

c0102588 <vector123>:
.globl vector123
vector123:
  pushl $0
c0102588:	6a 00                	push   $0x0
  pushl $123
c010258a:	6a 7b                	push   $0x7b
  jmp __alltraps
c010258c:	e9 24 06 00 00       	jmp    c0102bb5 <__alltraps>

c0102591 <vector124>:
.globl vector124
vector124:
  pushl $0
c0102591:	6a 00                	push   $0x0
  pushl $124
c0102593:	6a 7c                	push   $0x7c
  jmp __alltraps
c0102595:	e9 1b 06 00 00       	jmp    c0102bb5 <__alltraps>

c010259a <vector125>:
.globl vector125
vector125:
  pushl $0
c010259a:	6a 00                	push   $0x0
  pushl $125
c010259c:	6a 7d                	push   $0x7d
  jmp __alltraps
c010259e:	e9 12 06 00 00       	jmp    c0102bb5 <__alltraps>

c01025a3 <vector126>:
.globl vector126
vector126:
  pushl $0
c01025a3:	6a 00                	push   $0x0
  pushl $126
c01025a5:	6a 7e                	push   $0x7e
  jmp __alltraps
c01025a7:	e9 09 06 00 00       	jmp    c0102bb5 <__alltraps>

c01025ac <vector127>:
.globl vector127
vector127:
  pushl $0
c01025ac:	6a 00                	push   $0x0
  pushl $127
c01025ae:	6a 7f                	push   $0x7f
  jmp __alltraps
c01025b0:	e9 00 06 00 00       	jmp    c0102bb5 <__alltraps>

c01025b5 <vector128>:
.globl vector128
vector128:
  pushl $0
c01025b5:	6a 00                	push   $0x0
  pushl $128
c01025b7:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c01025bc:	e9 f4 05 00 00       	jmp    c0102bb5 <__alltraps>

c01025c1 <vector129>:
.globl vector129
vector129:
  pushl $0
c01025c1:	6a 00                	push   $0x0
  pushl $129
c01025c3:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c01025c8:	e9 e8 05 00 00       	jmp    c0102bb5 <__alltraps>

c01025cd <vector130>:
.globl vector130
vector130:
  pushl $0
c01025cd:	6a 00                	push   $0x0
  pushl $130
c01025cf:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c01025d4:	e9 dc 05 00 00       	jmp    c0102bb5 <__alltraps>

c01025d9 <vector131>:
.globl vector131
vector131:
  pushl $0
c01025d9:	6a 00                	push   $0x0
  pushl $131
c01025db:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c01025e0:	e9 d0 05 00 00       	jmp    c0102bb5 <__alltraps>

c01025e5 <vector132>:
.globl vector132
vector132:
  pushl $0
c01025e5:	6a 00                	push   $0x0
  pushl $132
c01025e7:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c01025ec:	e9 c4 05 00 00       	jmp    c0102bb5 <__alltraps>

c01025f1 <vector133>:
.globl vector133
vector133:
  pushl $0
c01025f1:	6a 00                	push   $0x0
  pushl $133
c01025f3:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c01025f8:	e9 b8 05 00 00       	jmp    c0102bb5 <__alltraps>

c01025fd <vector134>:
.globl vector134
vector134:
  pushl $0
c01025fd:	6a 00                	push   $0x0
  pushl $134
c01025ff:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c0102604:	e9 ac 05 00 00       	jmp    c0102bb5 <__alltraps>

c0102609 <vector135>:
.globl vector135
vector135:
  pushl $0
c0102609:	6a 00                	push   $0x0
  pushl $135
c010260b:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c0102610:	e9 a0 05 00 00       	jmp    c0102bb5 <__alltraps>

c0102615 <vector136>:
.globl vector136
vector136:
  pushl $0
c0102615:	6a 00                	push   $0x0
  pushl $136
c0102617:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c010261c:	e9 94 05 00 00       	jmp    c0102bb5 <__alltraps>

c0102621 <vector137>:
.globl vector137
vector137:
  pushl $0
c0102621:	6a 00                	push   $0x0
  pushl $137
c0102623:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c0102628:	e9 88 05 00 00       	jmp    c0102bb5 <__alltraps>

c010262d <vector138>:
.globl vector138
vector138:
  pushl $0
c010262d:	6a 00                	push   $0x0
  pushl $138
c010262f:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c0102634:	e9 7c 05 00 00       	jmp    c0102bb5 <__alltraps>

c0102639 <vector139>:
.globl vector139
vector139:
  pushl $0
c0102639:	6a 00                	push   $0x0
  pushl $139
c010263b:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c0102640:	e9 70 05 00 00       	jmp    c0102bb5 <__alltraps>

c0102645 <vector140>:
.globl vector140
vector140:
  pushl $0
c0102645:	6a 00                	push   $0x0
  pushl $140
c0102647:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c010264c:	e9 64 05 00 00       	jmp    c0102bb5 <__alltraps>

c0102651 <vector141>:
.globl vector141
vector141:
  pushl $0
c0102651:	6a 00                	push   $0x0
  pushl $141
c0102653:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c0102658:	e9 58 05 00 00       	jmp    c0102bb5 <__alltraps>

c010265d <vector142>:
.globl vector142
vector142:
  pushl $0
c010265d:	6a 00                	push   $0x0
  pushl $142
c010265f:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c0102664:	e9 4c 05 00 00       	jmp    c0102bb5 <__alltraps>

c0102669 <vector143>:
.globl vector143
vector143:
  pushl $0
c0102669:	6a 00                	push   $0x0
  pushl $143
c010266b:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c0102670:	e9 40 05 00 00       	jmp    c0102bb5 <__alltraps>

c0102675 <vector144>:
.globl vector144
vector144:
  pushl $0
c0102675:	6a 00                	push   $0x0
  pushl $144
c0102677:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c010267c:	e9 34 05 00 00       	jmp    c0102bb5 <__alltraps>

c0102681 <vector145>:
.globl vector145
vector145:
  pushl $0
c0102681:	6a 00                	push   $0x0
  pushl $145
c0102683:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c0102688:	e9 28 05 00 00       	jmp    c0102bb5 <__alltraps>

c010268d <vector146>:
.globl vector146
vector146:
  pushl $0
c010268d:	6a 00                	push   $0x0
  pushl $146
c010268f:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c0102694:	e9 1c 05 00 00       	jmp    c0102bb5 <__alltraps>

c0102699 <vector147>:
.globl vector147
vector147:
  pushl $0
c0102699:	6a 00                	push   $0x0
  pushl $147
c010269b:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c01026a0:	e9 10 05 00 00       	jmp    c0102bb5 <__alltraps>

c01026a5 <vector148>:
.globl vector148
vector148:
  pushl $0
c01026a5:	6a 00                	push   $0x0
  pushl $148
c01026a7:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c01026ac:	e9 04 05 00 00       	jmp    c0102bb5 <__alltraps>

c01026b1 <vector149>:
.globl vector149
vector149:
  pushl $0
c01026b1:	6a 00                	push   $0x0
  pushl $149
c01026b3:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c01026b8:	e9 f8 04 00 00       	jmp    c0102bb5 <__alltraps>

c01026bd <vector150>:
.globl vector150
vector150:
  pushl $0
c01026bd:	6a 00                	push   $0x0
  pushl $150
c01026bf:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c01026c4:	e9 ec 04 00 00       	jmp    c0102bb5 <__alltraps>

c01026c9 <vector151>:
.globl vector151
vector151:
  pushl $0
c01026c9:	6a 00                	push   $0x0
  pushl $151
c01026cb:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c01026d0:	e9 e0 04 00 00       	jmp    c0102bb5 <__alltraps>

c01026d5 <vector152>:
.globl vector152
vector152:
  pushl $0
c01026d5:	6a 00                	push   $0x0
  pushl $152
c01026d7:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c01026dc:	e9 d4 04 00 00       	jmp    c0102bb5 <__alltraps>

c01026e1 <vector153>:
.globl vector153
vector153:
  pushl $0
c01026e1:	6a 00                	push   $0x0
  pushl $153
c01026e3:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c01026e8:	e9 c8 04 00 00       	jmp    c0102bb5 <__alltraps>

c01026ed <vector154>:
.globl vector154
vector154:
  pushl $0
c01026ed:	6a 00                	push   $0x0
  pushl $154
c01026ef:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c01026f4:	e9 bc 04 00 00       	jmp    c0102bb5 <__alltraps>

c01026f9 <vector155>:
.globl vector155
vector155:
  pushl $0
c01026f9:	6a 00                	push   $0x0
  pushl $155
c01026fb:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c0102700:	e9 b0 04 00 00       	jmp    c0102bb5 <__alltraps>

c0102705 <vector156>:
.globl vector156
vector156:
  pushl $0
c0102705:	6a 00                	push   $0x0
  pushl $156
c0102707:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c010270c:	e9 a4 04 00 00       	jmp    c0102bb5 <__alltraps>

c0102711 <vector157>:
.globl vector157
vector157:
  pushl $0
c0102711:	6a 00                	push   $0x0
  pushl $157
c0102713:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c0102718:	e9 98 04 00 00       	jmp    c0102bb5 <__alltraps>

c010271d <vector158>:
.globl vector158
vector158:
  pushl $0
c010271d:	6a 00                	push   $0x0
  pushl $158
c010271f:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c0102724:	e9 8c 04 00 00       	jmp    c0102bb5 <__alltraps>

c0102729 <vector159>:
.globl vector159
vector159:
  pushl $0
c0102729:	6a 00                	push   $0x0
  pushl $159
c010272b:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c0102730:	e9 80 04 00 00       	jmp    c0102bb5 <__alltraps>

c0102735 <vector160>:
.globl vector160
vector160:
  pushl $0
c0102735:	6a 00                	push   $0x0
  pushl $160
c0102737:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c010273c:	e9 74 04 00 00       	jmp    c0102bb5 <__alltraps>

c0102741 <vector161>:
.globl vector161
vector161:
  pushl $0
c0102741:	6a 00                	push   $0x0
  pushl $161
c0102743:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c0102748:	e9 68 04 00 00       	jmp    c0102bb5 <__alltraps>

c010274d <vector162>:
.globl vector162
vector162:
  pushl $0
c010274d:	6a 00                	push   $0x0
  pushl $162
c010274f:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c0102754:	e9 5c 04 00 00       	jmp    c0102bb5 <__alltraps>

c0102759 <vector163>:
.globl vector163
vector163:
  pushl $0
c0102759:	6a 00                	push   $0x0
  pushl $163
c010275b:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c0102760:	e9 50 04 00 00       	jmp    c0102bb5 <__alltraps>

c0102765 <vector164>:
.globl vector164
vector164:
  pushl $0
c0102765:	6a 00                	push   $0x0
  pushl $164
c0102767:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c010276c:	e9 44 04 00 00       	jmp    c0102bb5 <__alltraps>

c0102771 <vector165>:
.globl vector165
vector165:
  pushl $0
c0102771:	6a 00                	push   $0x0
  pushl $165
c0102773:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c0102778:	e9 38 04 00 00       	jmp    c0102bb5 <__alltraps>

c010277d <vector166>:
.globl vector166
vector166:
  pushl $0
c010277d:	6a 00                	push   $0x0
  pushl $166
c010277f:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c0102784:	e9 2c 04 00 00       	jmp    c0102bb5 <__alltraps>

c0102789 <vector167>:
.globl vector167
vector167:
  pushl $0
c0102789:	6a 00                	push   $0x0
  pushl $167
c010278b:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c0102790:	e9 20 04 00 00       	jmp    c0102bb5 <__alltraps>

c0102795 <vector168>:
.globl vector168
vector168:
  pushl $0
c0102795:	6a 00                	push   $0x0
  pushl $168
c0102797:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c010279c:	e9 14 04 00 00       	jmp    c0102bb5 <__alltraps>

c01027a1 <vector169>:
.globl vector169
vector169:
  pushl $0
c01027a1:	6a 00                	push   $0x0
  pushl $169
c01027a3:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c01027a8:	e9 08 04 00 00       	jmp    c0102bb5 <__alltraps>

c01027ad <vector170>:
.globl vector170
vector170:
  pushl $0
c01027ad:	6a 00                	push   $0x0
  pushl $170
c01027af:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c01027b4:	e9 fc 03 00 00       	jmp    c0102bb5 <__alltraps>

c01027b9 <vector171>:
.globl vector171
vector171:
  pushl $0
c01027b9:	6a 00                	push   $0x0
  pushl $171
c01027bb:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c01027c0:	e9 f0 03 00 00       	jmp    c0102bb5 <__alltraps>

c01027c5 <vector172>:
.globl vector172
vector172:
  pushl $0
c01027c5:	6a 00                	push   $0x0
  pushl $172
c01027c7:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c01027cc:	e9 e4 03 00 00       	jmp    c0102bb5 <__alltraps>

c01027d1 <vector173>:
.globl vector173
vector173:
  pushl $0
c01027d1:	6a 00                	push   $0x0
  pushl $173
c01027d3:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c01027d8:	e9 d8 03 00 00       	jmp    c0102bb5 <__alltraps>

c01027dd <vector174>:
.globl vector174
vector174:
  pushl $0
c01027dd:	6a 00                	push   $0x0
  pushl $174
c01027df:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c01027e4:	e9 cc 03 00 00       	jmp    c0102bb5 <__alltraps>

c01027e9 <vector175>:
.globl vector175
vector175:
  pushl $0
c01027e9:	6a 00                	push   $0x0
  pushl $175
c01027eb:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c01027f0:	e9 c0 03 00 00       	jmp    c0102bb5 <__alltraps>

c01027f5 <vector176>:
.globl vector176
vector176:
  pushl $0
c01027f5:	6a 00                	push   $0x0
  pushl $176
c01027f7:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c01027fc:	e9 b4 03 00 00       	jmp    c0102bb5 <__alltraps>

c0102801 <vector177>:
.globl vector177
vector177:
  pushl $0
c0102801:	6a 00                	push   $0x0
  pushl $177
c0102803:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c0102808:	e9 a8 03 00 00       	jmp    c0102bb5 <__alltraps>

c010280d <vector178>:
.globl vector178
vector178:
  pushl $0
c010280d:	6a 00                	push   $0x0
  pushl $178
c010280f:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c0102814:	e9 9c 03 00 00       	jmp    c0102bb5 <__alltraps>

c0102819 <vector179>:
.globl vector179
vector179:
  pushl $0
c0102819:	6a 00                	push   $0x0
  pushl $179
c010281b:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c0102820:	e9 90 03 00 00       	jmp    c0102bb5 <__alltraps>

c0102825 <vector180>:
.globl vector180
vector180:
  pushl $0
c0102825:	6a 00                	push   $0x0
  pushl $180
c0102827:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c010282c:	e9 84 03 00 00       	jmp    c0102bb5 <__alltraps>

c0102831 <vector181>:
.globl vector181
vector181:
  pushl $0
c0102831:	6a 00                	push   $0x0
  pushl $181
c0102833:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c0102838:	e9 78 03 00 00       	jmp    c0102bb5 <__alltraps>

c010283d <vector182>:
.globl vector182
vector182:
  pushl $0
c010283d:	6a 00                	push   $0x0
  pushl $182
c010283f:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c0102844:	e9 6c 03 00 00       	jmp    c0102bb5 <__alltraps>

c0102849 <vector183>:
.globl vector183
vector183:
  pushl $0
c0102849:	6a 00                	push   $0x0
  pushl $183
c010284b:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c0102850:	e9 60 03 00 00       	jmp    c0102bb5 <__alltraps>

c0102855 <vector184>:
.globl vector184
vector184:
  pushl $0
c0102855:	6a 00                	push   $0x0
  pushl $184
c0102857:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c010285c:	e9 54 03 00 00       	jmp    c0102bb5 <__alltraps>

c0102861 <vector185>:
.globl vector185
vector185:
  pushl $0
c0102861:	6a 00                	push   $0x0
  pushl $185
c0102863:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c0102868:	e9 48 03 00 00       	jmp    c0102bb5 <__alltraps>

c010286d <vector186>:
.globl vector186
vector186:
  pushl $0
c010286d:	6a 00                	push   $0x0
  pushl $186
c010286f:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c0102874:	e9 3c 03 00 00       	jmp    c0102bb5 <__alltraps>

c0102879 <vector187>:
.globl vector187
vector187:
  pushl $0
c0102879:	6a 00                	push   $0x0
  pushl $187
c010287b:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c0102880:	e9 30 03 00 00       	jmp    c0102bb5 <__alltraps>

c0102885 <vector188>:
.globl vector188
vector188:
  pushl $0
c0102885:	6a 00                	push   $0x0
  pushl $188
c0102887:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c010288c:	e9 24 03 00 00       	jmp    c0102bb5 <__alltraps>

c0102891 <vector189>:
.globl vector189
vector189:
  pushl $0
c0102891:	6a 00                	push   $0x0
  pushl $189
c0102893:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c0102898:	e9 18 03 00 00       	jmp    c0102bb5 <__alltraps>

c010289d <vector190>:
.globl vector190
vector190:
  pushl $0
c010289d:	6a 00                	push   $0x0
  pushl $190
c010289f:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c01028a4:	e9 0c 03 00 00       	jmp    c0102bb5 <__alltraps>

c01028a9 <vector191>:
.globl vector191
vector191:
  pushl $0
c01028a9:	6a 00                	push   $0x0
  pushl $191
c01028ab:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c01028b0:	e9 00 03 00 00       	jmp    c0102bb5 <__alltraps>

c01028b5 <vector192>:
.globl vector192
vector192:
  pushl $0
c01028b5:	6a 00                	push   $0x0
  pushl $192
c01028b7:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c01028bc:	e9 f4 02 00 00       	jmp    c0102bb5 <__alltraps>

c01028c1 <vector193>:
.globl vector193
vector193:
  pushl $0
c01028c1:	6a 00                	push   $0x0
  pushl $193
c01028c3:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c01028c8:	e9 e8 02 00 00       	jmp    c0102bb5 <__alltraps>

c01028cd <vector194>:
.globl vector194
vector194:
  pushl $0
c01028cd:	6a 00                	push   $0x0
  pushl $194
c01028cf:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c01028d4:	e9 dc 02 00 00       	jmp    c0102bb5 <__alltraps>

c01028d9 <vector195>:
.globl vector195
vector195:
  pushl $0
c01028d9:	6a 00                	push   $0x0
  pushl $195
c01028db:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c01028e0:	e9 d0 02 00 00       	jmp    c0102bb5 <__alltraps>

c01028e5 <vector196>:
.globl vector196
vector196:
  pushl $0
c01028e5:	6a 00                	push   $0x0
  pushl $196
c01028e7:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c01028ec:	e9 c4 02 00 00       	jmp    c0102bb5 <__alltraps>

c01028f1 <vector197>:
.globl vector197
vector197:
  pushl $0
c01028f1:	6a 00                	push   $0x0
  pushl $197
c01028f3:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c01028f8:	e9 b8 02 00 00       	jmp    c0102bb5 <__alltraps>

c01028fd <vector198>:
.globl vector198
vector198:
  pushl $0
c01028fd:	6a 00                	push   $0x0
  pushl $198
c01028ff:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c0102904:	e9 ac 02 00 00       	jmp    c0102bb5 <__alltraps>

c0102909 <vector199>:
.globl vector199
vector199:
  pushl $0
c0102909:	6a 00                	push   $0x0
  pushl $199
c010290b:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c0102910:	e9 a0 02 00 00       	jmp    c0102bb5 <__alltraps>

c0102915 <vector200>:
.globl vector200
vector200:
  pushl $0
c0102915:	6a 00                	push   $0x0
  pushl $200
c0102917:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c010291c:	e9 94 02 00 00       	jmp    c0102bb5 <__alltraps>

c0102921 <vector201>:
.globl vector201
vector201:
  pushl $0
c0102921:	6a 00                	push   $0x0
  pushl $201
c0102923:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c0102928:	e9 88 02 00 00       	jmp    c0102bb5 <__alltraps>

c010292d <vector202>:
.globl vector202
vector202:
  pushl $0
c010292d:	6a 00                	push   $0x0
  pushl $202
c010292f:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c0102934:	e9 7c 02 00 00       	jmp    c0102bb5 <__alltraps>

c0102939 <vector203>:
.globl vector203
vector203:
  pushl $0
c0102939:	6a 00                	push   $0x0
  pushl $203
c010293b:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c0102940:	e9 70 02 00 00       	jmp    c0102bb5 <__alltraps>

c0102945 <vector204>:
.globl vector204
vector204:
  pushl $0
c0102945:	6a 00                	push   $0x0
  pushl $204
c0102947:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c010294c:	e9 64 02 00 00       	jmp    c0102bb5 <__alltraps>

c0102951 <vector205>:
.globl vector205
vector205:
  pushl $0
c0102951:	6a 00                	push   $0x0
  pushl $205
c0102953:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c0102958:	e9 58 02 00 00       	jmp    c0102bb5 <__alltraps>

c010295d <vector206>:
.globl vector206
vector206:
  pushl $0
c010295d:	6a 00                	push   $0x0
  pushl $206
c010295f:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c0102964:	e9 4c 02 00 00       	jmp    c0102bb5 <__alltraps>

c0102969 <vector207>:
.globl vector207
vector207:
  pushl $0
c0102969:	6a 00                	push   $0x0
  pushl $207
c010296b:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c0102970:	e9 40 02 00 00       	jmp    c0102bb5 <__alltraps>

c0102975 <vector208>:
.globl vector208
vector208:
  pushl $0
c0102975:	6a 00                	push   $0x0
  pushl $208
c0102977:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c010297c:	e9 34 02 00 00       	jmp    c0102bb5 <__alltraps>

c0102981 <vector209>:
.globl vector209
vector209:
  pushl $0
c0102981:	6a 00                	push   $0x0
  pushl $209
c0102983:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c0102988:	e9 28 02 00 00       	jmp    c0102bb5 <__alltraps>

c010298d <vector210>:
.globl vector210
vector210:
  pushl $0
c010298d:	6a 00                	push   $0x0
  pushl $210
c010298f:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c0102994:	e9 1c 02 00 00       	jmp    c0102bb5 <__alltraps>

c0102999 <vector211>:
.globl vector211
vector211:
  pushl $0
c0102999:	6a 00                	push   $0x0
  pushl $211
c010299b:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c01029a0:	e9 10 02 00 00       	jmp    c0102bb5 <__alltraps>

c01029a5 <vector212>:
.globl vector212
vector212:
  pushl $0
c01029a5:	6a 00                	push   $0x0
  pushl $212
c01029a7:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c01029ac:	e9 04 02 00 00       	jmp    c0102bb5 <__alltraps>

c01029b1 <vector213>:
.globl vector213
vector213:
  pushl $0
c01029b1:	6a 00                	push   $0x0
  pushl $213
c01029b3:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c01029b8:	e9 f8 01 00 00       	jmp    c0102bb5 <__alltraps>

c01029bd <vector214>:
.globl vector214
vector214:
  pushl $0
c01029bd:	6a 00                	push   $0x0
  pushl $214
c01029bf:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c01029c4:	e9 ec 01 00 00       	jmp    c0102bb5 <__alltraps>

c01029c9 <vector215>:
.globl vector215
vector215:
  pushl $0
c01029c9:	6a 00                	push   $0x0
  pushl $215
c01029cb:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c01029d0:	e9 e0 01 00 00       	jmp    c0102bb5 <__alltraps>

c01029d5 <vector216>:
.globl vector216
vector216:
  pushl $0
c01029d5:	6a 00                	push   $0x0
  pushl $216
c01029d7:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c01029dc:	e9 d4 01 00 00       	jmp    c0102bb5 <__alltraps>

c01029e1 <vector217>:
.globl vector217
vector217:
  pushl $0
c01029e1:	6a 00                	push   $0x0
  pushl $217
c01029e3:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c01029e8:	e9 c8 01 00 00       	jmp    c0102bb5 <__alltraps>

c01029ed <vector218>:
.globl vector218
vector218:
  pushl $0
c01029ed:	6a 00                	push   $0x0
  pushl $218
c01029ef:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c01029f4:	e9 bc 01 00 00       	jmp    c0102bb5 <__alltraps>

c01029f9 <vector219>:
.globl vector219
vector219:
  pushl $0
c01029f9:	6a 00                	push   $0x0
  pushl $219
c01029fb:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c0102a00:	e9 b0 01 00 00       	jmp    c0102bb5 <__alltraps>

c0102a05 <vector220>:
.globl vector220
vector220:
  pushl $0
c0102a05:	6a 00                	push   $0x0
  pushl $220
c0102a07:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c0102a0c:	e9 a4 01 00 00       	jmp    c0102bb5 <__alltraps>

c0102a11 <vector221>:
.globl vector221
vector221:
  pushl $0
c0102a11:	6a 00                	push   $0x0
  pushl $221
c0102a13:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c0102a18:	e9 98 01 00 00       	jmp    c0102bb5 <__alltraps>

c0102a1d <vector222>:
.globl vector222
vector222:
  pushl $0
c0102a1d:	6a 00                	push   $0x0
  pushl $222
c0102a1f:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c0102a24:	e9 8c 01 00 00       	jmp    c0102bb5 <__alltraps>

c0102a29 <vector223>:
.globl vector223
vector223:
  pushl $0
c0102a29:	6a 00                	push   $0x0
  pushl $223
c0102a2b:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c0102a30:	e9 80 01 00 00       	jmp    c0102bb5 <__alltraps>

c0102a35 <vector224>:
.globl vector224
vector224:
  pushl $0
c0102a35:	6a 00                	push   $0x0
  pushl $224
c0102a37:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c0102a3c:	e9 74 01 00 00       	jmp    c0102bb5 <__alltraps>

c0102a41 <vector225>:
.globl vector225
vector225:
  pushl $0
c0102a41:	6a 00                	push   $0x0
  pushl $225
c0102a43:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c0102a48:	e9 68 01 00 00       	jmp    c0102bb5 <__alltraps>

c0102a4d <vector226>:
.globl vector226
vector226:
  pushl $0
c0102a4d:	6a 00                	push   $0x0
  pushl $226
c0102a4f:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c0102a54:	e9 5c 01 00 00       	jmp    c0102bb5 <__alltraps>

c0102a59 <vector227>:
.globl vector227
vector227:
  pushl $0
c0102a59:	6a 00                	push   $0x0
  pushl $227
c0102a5b:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c0102a60:	e9 50 01 00 00       	jmp    c0102bb5 <__alltraps>

c0102a65 <vector228>:
.globl vector228
vector228:
  pushl $0
c0102a65:	6a 00                	push   $0x0
  pushl $228
c0102a67:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c0102a6c:	e9 44 01 00 00       	jmp    c0102bb5 <__alltraps>

c0102a71 <vector229>:
.globl vector229
vector229:
  pushl $0
c0102a71:	6a 00                	push   $0x0
  pushl $229
c0102a73:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c0102a78:	e9 38 01 00 00       	jmp    c0102bb5 <__alltraps>

c0102a7d <vector230>:
.globl vector230
vector230:
  pushl $0
c0102a7d:	6a 00                	push   $0x0
  pushl $230
c0102a7f:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c0102a84:	e9 2c 01 00 00       	jmp    c0102bb5 <__alltraps>

c0102a89 <vector231>:
.globl vector231
vector231:
  pushl $0
c0102a89:	6a 00                	push   $0x0
  pushl $231
c0102a8b:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c0102a90:	e9 20 01 00 00       	jmp    c0102bb5 <__alltraps>

c0102a95 <vector232>:
.globl vector232
vector232:
  pushl $0
c0102a95:	6a 00                	push   $0x0
  pushl $232
c0102a97:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c0102a9c:	e9 14 01 00 00       	jmp    c0102bb5 <__alltraps>

c0102aa1 <vector233>:
.globl vector233
vector233:
  pushl $0
c0102aa1:	6a 00                	push   $0x0
  pushl $233
c0102aa3:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c0102aa8:	e9 08 01 00 00       	jmp    c0102bb5 <__alltraps>

c0102aad <vector234>:
.globl vector234
vector234:
  pushl $0
c0102aad:	6a 00                	push   $0x0
  pushl $234
c0102aaf:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c0102ab4:	e9 fc 00 00 00       	jmp    c0102bb5 <__alltraps>

c0102ab9 <vector235>:
.globl vector235
vector235:
  pushl $0
c0102ab9:	6a 00                	push   $0x0
  pushl $235
c0102abb:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c0102ac0:	e9 f0 00 00 00       	jmp    c0102bb5 <__alltraps>

c0102ac5 <vector236>:
.globl vector236
vector236:
  pushl $0
c0102ac5:	6a 00                	push   $0x0
  pushl $236
c0102ac7:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c0102acc:	e9 e4 00 00 00       	jmp    c0102bb5 <__alltraps>

c0102ad1 <vector237>:
.globl vector237
vector237:
  pushl $0
c0102ad1:	6a 00                	push   $0x0
  pushl $237
c0102ad3:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c0102ad8:	e9 d8 00 00 00       	jmp    c0102bb5 <__alltraps>

c0102add <vector238>:
.globl vector238
vector238:
  pushl $0
c0102add:	6a 00                	push   $0x0
  pushl $238
c0102adf:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c0102ae4:	e9 cc 00 00 00       	jmp    c0102bb5 <__alltraps>

c0102ae9 <vector239>:
.globl vector239
vector239:
  pushl $0
c0102ae9:	6a 00                	push   $0x0
  pushl $239
c0102aeb:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c0102af0:	e9 c0 00 00 00       	jmp    c0102bb5 <__alltraps>

c0102af5 <vector240>:
.globl vector240
vector240:
  pushl $0
c0102af5:	6a 00                	push   $0x0
  pushl $240
c0102af7:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c0102afc:	e9 b4 00 00 00       	jmp    c0102bb5 <__alltraps>

c0102b01 <vector241>:
.globl vector241
vector241:
  pushl $0
c0102b01:	6a 00                	push   $0x0
  pushl $241
c0102b03:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c0102b08:	e9 a8 00 00 00       	jmp    c0102bb5 <__alltraps>

c0102b0d <vector242>:
.globl vector242
vector242:
  pushl $0
c0102b0d:	6a 00                	push   $0x0
  pushl $242
c0102b0f:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c0102b14:	e9 9c 00 00 00       	jmp    c0102bb5 <__alltraps>

c0102b19 <vector243>:
.globl vector243
vector243:
  pushl $0
c0102b19:	6a 00                	push   $0x0
  pushl $243
c0102b1b:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c0102b20:	e9 90 00 00 00       	jmp    c0102bb5 <__alltraps>

c0102b25 <vector244>:
.globl vector244
vector244:
  pushl $0
c0102b25:	6a 00                	push   $0x0
  pushl $244
c0102b27:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c0102b2c:	e9 84 00 00 00       	jmp    c0102bb5 <__alltraps>

c0102b31 <vector245>:
.globl vector245
vector245:
  pushl $0
c0102b31:	6a 00                	push   $0x0
  pushl $245
c0102b33:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c0102b38:	e9 78 00 00 00       	jmp    c0102bb5 <__alltraps>

c0102b3d <vector246>:
.globl vector246
vector246:
  pushl $0
c0102b3d:	6a 00                	push   $0x0
  pushl $246
c0102b3f:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c0102b44:	e9 6c 00 00 00       	jmp    c0102bb5 <__alltraps>

c0102b49 <vector247>:
.globl vector247
vector247:
  pushl $0
c0102b49:	6a 00                	push   $0x0
  pushl $247
c0102b4b:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c0102b50:	e9 60 00 00 00       	jmp    c0102bb5 <__alltraps>

c0102b55 <vector248>:
.globl vector248
vector248:
  pushl $0
c0102b55:	6a 00                	push   $0x0
  pushl $248
c0102b57:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c0102b5c:	e9 54 00 00 00       	jmp    c0102bb5 <__alltraps>

c0102b61 <vector249>:
.globl vector249
vector249:
  pushl $0
c0102b61:	6a 00                	push   $0x0
  pushl $249
c0102b63:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c0102b68:	e9 48 00 00 00       	jmp    c0102bb5 <__alltraps>

c0102b6d <vector250>:
.globl vector250
vector250:
  pushl $0
c0102b6d:	6a 00                	push   $0x0
  pushl $250
c0102b6f:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c0102b74:	e9 3c 00 00 00       	jmp    c0102bb5 <__alltraps>

c0102b79 <vector251>:
.globl vector251
vector251:
  pushl $0
c0102b79:	6a 00                	push   $0x0
  pushl $251
c0102b7b:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c0102b80:	e9 30 00 00 00       	jmp    c0102bb5 <__alltraps>

c0102b85 <vector252>:
.globl vector252
vector252:
  pushl $0
c0102b85:	6a 00                	push   $0x0
  pushl $252
c0102b87:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c0102b8c:	e9 24 00 00 00       	jmp    c0102bb5 <__alltraps>

c0102b91 <vector253>:
.globl vector253
vector253:
  pushl $0
c0102b91:	6a 00                	push   $0x0
  pushl $253
c0102b93:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c0102b98:	e9 18 00 00 00       	jmp    c0102bb5 <__alltraps>

c0102b9d <vector254>:
.globl vector254
vector254:
  pushl $0
c0102b9d:	6a 00                	push   $0x0
  pushl $254
c0102b9f:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c0102ba4:	e9 0c 00 00 00       	jmp    c0102bb5 <__alltraps>

c0102ba9 <vector255>:
.globl vector255
vector255:
  pushl $0
c0102ba9:	6a 00                	push   $0x0
  pushl $255
c0102bab:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c0102bb0:	e9 00 00 00 00       	jmp    c0102bb5 <__alltraps>

c0102bb5 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c0102bb5:	1e                   	push   %ds
    pushl %es
c0102bb6:	06                   	push   %es
    pushl %fs
c0102bb7:	0f a0                	push   %fs
    pushl %gs
c0102bb9:	0f a8                	push   %gs
    pushal                # Push EAX, ECX, EDX, EBX, original ESP, EBP, ESI, and EDI.
c0102bbb:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c0102bbc:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c0102bc1:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c0102bc3:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c0102bc5:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c0102bc6:	e8 60 f5 ff ff       	call   c010212b <trap>

    # pop the pushed stack pointer
    popl %esp
c0102bcb:	5c                   	pop    %esp

c0102bcc <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c0102bcc:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c0102bcd:	0f a9                	pop    %gs
    popl %fs
c0102bcf:	0f a1                	pop    %fs
    popl %es
c0102bd1:	07                   	pop    %es
    popl %ds
c0102bd2:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c0102bd3:	83 c4 08             	add    $0x8,%esp
    iret                 # 恢复 cs、eflag以及 eip
c0102bd6:	cf                   	iret   

c0102bd7 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0102bd7:	55                   	push   %ebp
c0102bd8:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0102bda:	a1 34 3f 12 c0       	mov    0xc0123f34,%eax
c0102bdf:	8b 55 08             	mov    0x8(%ebp),%edx
c0102be2:	29 c2                	sub    %eax,%edx
c0102be4:	89 d0                	mov    %edx,%eax
c0102be6:	c1 f8 02             	sar    $0x2,%eax
c0102be9:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c0102bef:	5d                   	pop    %ebp
c0102bf0:	c3                   	ret    

c0102bf1 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0102bf1:	55                   	push   %ebp
c0102bf2:	89 e5                	mov    %esp,%ebp
c0102bf4:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0102bf7:	8b 45 08             	mov    0x8(%ebp),%eax
c0102bfa:	89 04 24             	mov    %eax,(%esp)
c0102bfd:	e8 d5 ff ff ff       	call   c0102bd7 <page2ppn>
c0102c02:	c1 e0 0c             	shl    $0xc,%eax
}
c0102c05:	c9                   	leave  
c0102c06:	c3                   	ret    

c0102c07 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c0102c07:	55                   	push   %ebp
c0102c08:	89 e5                	mov    %esp,%ebp
c0102c0a:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0102c0d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c10:	c1 e8 0c             	shr    $0xc,%eax
c0102c13:	89 c2                	mov    %eax,%edx
c0102c15:	a1 80 3e 12 c0       	mov    0xc0123e80,%eax
c0102c1a:	39 c2                	cmp    %eax,%edx
c0102c1c:	72 1c                	jb     c0102c3a <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0102c1e:	c7 44 24 08 50 a8 10 	movl   $0xc010a850,0x8(%esp)
c0102c25:	c0 
c0102c26:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
c0102c2d:	00 
c0102c2e:	c7 04 24 6f a8 10 c0 	movl   $0xc010a86f,(%esp)
c0102c35:	e8 fc d7 ff ff       	call   c0100436 <__panic>
    }
    return &pages[PPN(pa)];
c0102c3a:	8b 0d 34 3f 12 c0    	mov    0xc0123f34,%ecx
c0102c40:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c43:	c1 e8 0c             	shr    $0xc,%eax
c0102c46:	89 c2                	mov    %eax,%edx
c0102c48:	89 d0                	mov    %edx,%eax
c0102c4a:	c1 e0 02             	shl    $0x2,%eax
c0102c4d:	01 d0                	add    %edx,%eax
c0102c4f:	c1 e0 02             	shl    $0x2,%eax
c0102c52:	01 c8                	add    %ecx,%eax
}
c0102c54:	c9                   	leave  
c0102c55:	c3                   	ret    

c0102c56 <page2kva>:

static inline void *
page2kva(struct Page *page) {
c0102c56:	55                   	push   %ebp
c0102c57:	89 e5                	mov    %esp,%ebp
c0102c59:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0102c5c:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c5f:	89 04 24             	mov    %eax,(%esp)
c0102c62:	e8 8a ff ff ff       	call   c0102bf1 <page2pa>
c0102c67:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102c6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c6d:	c1 e8 0c             	shr    $0xc,%eax
c0102c70:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102c73:	a1 80 3e 12 c0       	mov    0xc0123e80,%eax
c0102c78:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0102c7b:	72 23                	jb     c0102ca0 <page2kva+0x4a>
c0102c7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c80:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0102c84:	c7 44 24 08 80 a8 10 	movl   $0xc010a880,0x8(%esp)
c0102c8b:	c0 
c0102c8c:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
c0102c93:	00 
c0102c94:	c7 04 24 6f a8 10 c0 	movl   $0xc010a86f,(%esp)
c0102c9b:	e8 96 d7 ff ff       	call   c0100436 <__panic>
c0102ca0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102ca3:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0102ca8:	c9                   	leave  
c0102ca9:	c3                   	ret    

c0102caa <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c0102caa:	55                   	push   %ebp
c0102cab:	89 e5                	mov    %esp,%ebp
c0102cad:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0102cb0:	8b 45 08             	mov    0x8(%ebp),%eax
c0102cb3:	83 e0 01             	and    $0x1,%eax
c0102cb6:	85 c0                	test   %eax,%eax
c0102cb8:	75 1c                	jne    c0102cd6 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c0102cba:	c7 44 24 08 a4 a8 10 	movl   $0xc010a8a4,0x8(%esp)
c0102cc1:	c0 
c0102cc2:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
c0102cc9:	00 
c0102cca:	c7 04 24 6f a8 10 c0 	movl   $0xc010a86f,(%esp)
c0102cd1:	e8 60 d7 ff ff       	call   c0100436 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0102cd6:	8b 45 08             	mov    0x8(%ebp),%eax
c0102cd9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0102cde:	89 04 24             	mov    %eax,(%esp)
c0102ce1:	e8 21 ff ff ff       	call   c0102c07 <pa2page>
}
c0102ce6:	c9                   	leave  
c0102ce7:	c3                   	ret    

c0102ce8 <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
c0102ce8:	55                   	push   %ebp
c0102ce9:	89 e5                	mov    %esp,%ebp
c0102ceb:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
c0102cee:	8b 45 08             	mov    0x8(%ebp),%eax
c0102cf1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0102cf6:	89 04 24             	mov    %eax,(%esp)
c0102cf9:	e8 09 ff ff ff       	call   c0102c07 <pa2page>
}
c0102cfe:	c9                   	leave  
c0102cff:	c3                   	ret    

c0102d00 <page_ref>:

static inline int
page_ref(struct Page *page) {
c0102d00:	55                   	push   %ebp
c0102d01:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0102d03:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d06:	8b 00                	mov    (%eax),%eax
}
c0102d08:	5d                   	pop    %ebp
c0102d09:	c3                   	ret    

c0102d0a <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0102d0a:	55                   	push   %ebp
c0102d0b:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0102d0d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d10:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102d13:	89 10                	mov    %edx,(%eax)
}
c0102d15:	90                   	nop
c0102d16:	5d                   	pop    %ebp
c0102d17:	c3                   	ret    

c0102d18 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c0102d18:	55                   	push   %ebp
c0102d19:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c0102d1b:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d1e:	8b 00                	mov    (%eax),%eax
c0102d20:	8d 50 01             	lea    0x1(%eax),%edx
c0102d23:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d26:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0102d28:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d2b:	8b 00                	mov    (%eax),%eax
}
c0102d2d:	5d                   	pop    %ebp
c0102d2e:	c3                   	ret    

c0102d2f <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c0102d2f:	55                   	push   %ebp
c0102d30:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c0102d32:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d35:	8b 00                	mov    (%eax),%eax
c0102d37:	8d 50 ff             	lea    -0x1(%eax),%edx
c0102d3a:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d3d:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0102d3f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d42:	8b 00                	mov    (%eax),%eax
}
c0102d44:	5d                   	pop    %ebp
c0102d45:	c3                   	ret    

c0102d46 <__intr_save>:
__intr_save(void) {
c0102d46:	55                   	push   %ebp
c0102d47:	89 e5                	mov    %esp,%ebp
c0102d49:	83 ec 18             	sub    $0x18,%esp
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0102d4c:	9c                   	pushf  
c0102d4d:	58                   	pop    %eax
c0102d4e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0102d51:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0102d54:	25 00 02 00 00       	and    $0x200,%eax
c0102d59:	85 c0                	test   %eax,%eax
c0102d5b:	74 0c                	je     c0102d69 <__intr_save+0x23>
        intr_disable();
c0102d5d:	e8 12 ec ff ff       	call   c0101974 <intr_disable>
        return 1;
c0102d62:	b8 01 00 00 00       	mov    $0x1,%eax
c0102d67:	eb 05                	jmp    c0102d6e <__intr_save+0x28>
    return 0;
c0102d69:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0102d6e:	c9                   	leave  
c0102d6f:	c3                   	ret    

c0102d70 <__intr_restore>:
__intr_restore(bool flag) {
c0102d70:	55                   	push   %ebp
c0102d71:	89 e5                	mov    %esp,%ebp
c0102d73:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0102d76:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0102d7a:	74 05                	je     c0102d81 <__intr_restore+0x11>
        intr_enable();
c0102d7c:	e8 e7 eb ff ff       	call   c0101968 <intr_enable>
}
c0102d81:	90                   	nop
c0102d82:	c9                   	leave  
c0102d83:	c3                   	ret    

c0102d84 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0102d84:	55                   	push   %ebp
c0102d85:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0102d87:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d8a:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c0102d8d:	b8 23 00 00 00       	mov    $0x23,%eax
c0102d92:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c0102d94:	b8 23 00 00 00       	mov    $0x23,%eax
c0102d99:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c0102d9b:	b8 10 00 00 00       	mov    $0x10,%eax
c0102da0:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c0102da2:	b8 10 00 00 00       	mov    $0x10,%eax
c0102da7:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0102da9:	b8 10 00 00 00       	mov    $0x10,%eax
c0102dae:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0102db0:	ea b7 2d 10 c0 08 00 	ljmp   $0x8,$0xc0102db7
}
c0102db7:	90                   	nop
c0102db8:	5d                   	pop    %ebp
c0102db9:	c3                   	ret    

c0102dba <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0102dba:	f3 0f 1e fb          	endbr32 
c0102dbe:	55                   	push   %ebp
c0102dbf:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0102dc1:	8b 45 08             	mov    0x8(%ebp),%eax
c0102dc4:	a3 a4 3e 12 c0       	mov    %eax,0xc0123ea4
}
c0102dc9:	90                   	nop
c0102dca:	5d                   	pop    %ebp
c0102dcb:	c3                   	ret    

c0102dcc <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0102dcc:	f3 0f 1e fb          	endbr32 
c0102dd0:	55                   	push   %ebp
c0102dd1:	89 e5                	mov    %esp,%ebp
c0102dd3:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0102dd6:	b8 00 00 12 c0       	mov    $0xc0120000,%eax
c0102ddb:	89 04 24             	mov    %eax,(%esp)
c0102dde:	e8 d7 ff ff ff       	call   c0102dba <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
c0102de3:	66 c7 05 a8 3e 12 c0 	movw   $0x10,0xc0123ea8
c0102dea:	10 00 

    // initialize the TSS field of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0102dec:	66 c7 05 28 0a 12 c0 	movw   $0x68,0xc0120a28
c0102df3:	68 00 
c0102df5:	b8 a0 3e 12 c0       	mov    $0xc0123ea0,%eax
c0102dfa:	0f b7 c0             	movzwl %ax,%eax
c0102dfd:	66 a3 2a 0a 12 c0    	mov    %ax,0xc0120a2a
c0102e03:	b8 a0 3e 12 c0       	mov    $0xc0123ea0,%eax
c0102e08:	c1 e8 10             	shr    $0x10,%eax
c0102e0b:	a2 2c 0a 12 c0       	mov    %al,0xc0120a2c
c0102e10:	0f b6 05 2d 0a 12 c0 	movzbl 0xc0120a2d,%eax
c0102e17:	24 f0                	and    $0xf0,%al
c0102e19:	0c 09                	or     $0x9,%al
c0102e1b:	a2 2d 0a 12 c0       	mov    %al,0xc0120a2d
c0102e20:	0f b6 05 2d 0a 12 c0 	movzbl 0xc0120a2d,%eax
c0102e27:	24 ef                	and    $0xef,%al
c0102e29:	a2 2d 0a 12 c0       	mov    %al,0xc0120a2d
c0102e2e:	0f b6 05 2d 0a 12 c0 	movzbl 0xc0120a2d,%eax
c0102e35:	24 9f                	and    $0x9f,%al
c0102e37:	a2 2d 0a 12 c0       	mov    %al,0xc0120a2d
c0102e3c:	0f b6 05 2d 0a 12 c0 	movzbl 0xc0120a2d,%eax
c0102e43:	0c 80                	or     $0x80,%al
c0102e45:	a2 2d 0a 12 c0       	mov    %al,0xc0120a2d
c0102e4a:	0f b6 05 2e 0a 12 c0 	movzbl 0xc0120a2e,%eax
c0102e51:	24 f0                	and    $0xf0,%al
c0102e53:	a2 2e 0a 12 c0       	mov    %al,0xc0120a2e
c0102e58:	0f b6 05 2e 0a 12 c0 	movzbl 0xc0120a2e,%eax
c0102e5f:	24 ef                	and    $0xef,%al
c0102e61:	a2 2e 0a 12 c0       	mov    %al,0xc0120a2e
c0102e66:	0f b6 05 2e 0a 12 c0 	movzbl 0xc0120a2e,%eax
c0102e6d:	24 df                	and    $0xdf,%al
c0102e6f:	a2 2e 0a 12 c0       	mov    %al,0xc0120a2e
c0102e74:	0f b6 05 2e 0a 12 c0 	movzbl 0xc0120a2e,%eax
c0102e7b:	0c 40                	or     $0x40,%al
c0102e7d:	a2 2e 0a 12 c0       	mov    %al,0xc0120a2e
c0102e82:	0f b6 05 2e 0a 12 c0 	movzbl 0xc0120a2e,%eax
c0102e89:	24 7f                	and    $0x7f,%al
c0102e8b:	a2 2e 0a 12 c0       	mov    %al,0xc0120a2e
c0102e90:	b8 a0 3e 12 c0       	mov    $0xc0123ea0,%eax
c0102e95:	c1 e8 18             	shr    $0x18,%eax
c0102e98:	a2 2f 0a 12 c0       	mov    %al,0xc0120a2f

    // reload all segment registers
    lgdt(&gdt_pd);
c0102e9d:	c7 04 24 30 0a 12 c0 	movl   $0xc0120a30,(%esp)
c0102ea4:	e8 db fe ff ff       	call   c0102d84 <lgdt>
c0102ea9:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0102eaf:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0102eb3:	0f 00 d8             	ltr    %ax
}
c0102eb6:	90                   	nop

    // load the TSS
    ltr(GD_TSS);
}
c0102eb7:	90                   	nop
c0102eb8:	c9                   	leave  
c0102eb9:	c3                   	ret    

c0102eba <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c0102eba:	f3 0f 1e fb          	endbr32 
c0102ebe:	55                   	push   %ebp
c0102ebf:	89 e5                	mov    %esp,%ebp
c0102ec1:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &buddy_pmm_manager;
c0102ec4:	c7 05 2c 3f 12 c0 78 	movl   $0xc010b678,0xc0123f2c
c0102ecb:	b6 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c0102ece:	a1 2c 3f 12 c0       	mov    0xc0123f2c,%eax
c0102ed3:	8b 00                	mov    (%eax),%eax
c0102ed5:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102ed9:	c7 04 24 d0 a8 10 c0 	movl   $0xc010a8d0,(%esp)
c0102ee0:	e8 e5 d3 ff ff       	call   c01002ca <cprintf>
    pmm_manager->init();
c0102ee5:	a1 2c 3f 12 c0       	mov    0xc0123f2c,%eax
c0102eea:	8b 40 04             	mov    0x4(%eax),%eax
c0102eed:	ff d0                	call   *%eax
}
c0102eef:	90                   	nop
c0102ef0:	c9                   	leave  
c0102ef1:	c3                   	ret    

c0102ef2 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0102ef2:	f3 0f 1e fb          	endbr32 
c0102ef6:	55                   	push   %ebp
c0102ef7:	89 e5                	mov    %esp,%ebp
c0102ef9:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
c0102efc:	a1 2c 3f 12 c0       	mov    0xc0123f2c,%eax
c0102f01:	8b 40 08             	mov    0x8(%eax),%eax
c0102f04:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102f07:	89 54 24 04          	mov    %edx,0x4(%esp)
c0102f0b:	8b 55 08             	mov    0x8(%ebp),%edx
c0102f0e:	89 14 24             	mov    %edx,(%esp)
c0102f11:	ff d0                	call   *%eax
}
c0102f13:	90                   	nop
c0102f14:	c9                   	leave  
c0102f15:	c3                   	ret    

c0102f16 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c0102f16:	f3 0f 1e fb          	endbr32 
c0102f1a:	55                   	push   %ebp
c0102f1b:	89 e5                	mov    %esp,%ebp
c0102f1d:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
c0102f20:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0102f27:	e8 1a fe ff ff       	call   c0102d46 <__intr_save>
c0102f2c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
c0102f2f:	a1 2c 3f 12 c0       	mov    0xc0123f2c,%eax
c0102f34:	8b 40 0c             	mov    0xc(%eax),%eax
c0102f37:	8b 55 08             	mov    0x8(%ebp),%edx
c0102f3a:	89 14 24             	mov    %edx,(%esp)
c0102f3d:	ff d0                	call   *%eax
c0102f3f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
c0102f42:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102f45:	89 04 24             	mov    %eax,(%esp)
c0102f48:	e8 23 fe ff ff       	call   c0102d70 <__intr_restore>
    return page;
c0102f4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0102f50:	c9                   	leave  
c0102f51:	c3                   	ret    

c0102f52 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0102f52:	f3 0f 1e fb          	endbr32 
c0102f56:	55                   	push   %ebp
c0102f57:	89 e5                	mov    %esp,%ebp
c0102f59:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0102f5c:	e8 e5 fd ff ff       	call   c0102d46 <__intr_save>
c0102f61:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0102f64:	a1 2c 3f 12 c0       	mov    0xc0123f2c,%eax
c0102f69:	8b 40 10             	mov    0x10(%eax),%eax
c0102f6c:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102f6f:	89 54 24 04          	mov    %edx,0x4(%esp)
c0102f73:	8b 55 08             	mov    0x8(%ebp),%edx
c0102f76:	89 14 24             	mov    %edx,(%esp)
c0102f79:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
c0102f7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102f7e:	89 04 24             	mov    %eax,(%esp)
c0102f81:	e8 ea fd ff ff       	call   c0102d70 <__intr_restore>
}
c0102f86:	90                   	nop
c0102f87:	c9                   	leave  
c0102f88:	c3                   	ret    

c0102f89 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c0102f89:	f3 0f 1e fb          	endbr32 
c0102f8d:	55                   	push   %ebp
c0102f8e:	89 e5                	mov    %esp,%ebp
c0102f90:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c0102f93:	e8 ae fd ff ff       	call   c0102d46 <__intr_save>
c0102f98:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c0102f9b:	a1 2c 3f 12 c0       	mov    0xc0123f2c,%eax
c0102fa0:	8b 40 14             	mov    0x14(%eax),%eax
c0102fa3:	ff d0                	call   *%eax
c0102fa5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c0102fa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102fab:	89 04 24             	mov    %eax,(%esp)
c0102fae:	e8 bd fd ff ff       	call   c0102d70 <__intr_restore>
    return ret;
c0102fb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0102fb6:	c9                   	leave  
c0102fb7:	c3                   	ret    

c0102fb8 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c0102fb8:	f3 0f 1e fb          	endbr32 
c0102fbc:	55                   	push   %ebp
c0102fbd:	89 e5                	mov    %esp,%ebp
c0102fbf:	57                   	push   %edi
c0102fc0:	56                   	push   %esi
c0102fc1:	53                   	push   %ebx
c0102fc2:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c0102fc8:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c0102fcf:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0102fd6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c0102fdd:	c7 04 24 e7 a8 10 c0 	movl   $0xc010a8e7,(%esp)
c0102fe4:	e8 e1 d2 ff ff       	call   c01002ca <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0102fe9:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0102ff0:	e9 1a 01 00 00       	jmp    c010310f <page_init+0x157>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0102ff5:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102ff8:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102ffb:	89 d0                	mov    %edx,%eax
c0102ffd:	c1 e0 02             	shl    $0x2,%eax
c0103000:	01 d0                	add    %edx,%eax
c0103002:	c1 e0 02             	shl    $0x2,%eax
c0103005:	01 c8                	add    %ecx,%eax
c0103007:	8b 50 08             	mov    0x8(%eax),%edx
c010300a:	8b 40 04             	mov    0x4(%eax),%eax
c010300d:	89 45 a0             	mov    %eax,-0x60(%ebp)
c0103010:	89 55 a4             	mov    %edx,-0x5c(%ebp)
c0103013:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103016:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103019:	89 d0                	mov    %edx,%eax
c010301b:	c1 e0 02             	shl    $0x2,%eax
c010301e:	01 d0                	add    %edx,%eax
c0103020:	c1 e0 02             	shl    $0x2,%eax
c0103023:	01 c8                	add    %ecx,%eax
c0103025:	8b 48 0c             	mov    0xc(%eax),%ecx
c0103028:	8b 58 10             	mov    0x10(%eax),%ebx
c010302b:	8b 45 a0             	mov    -0x60(%ebp),%eax
c010302e:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0103031:	01 c8                	add    %ecx,%eax
c0103033:	11 da                	adc    %ebx,%edx
c0103035:	89 45 98             	mov    %eax,-0x68(%ebp)
c0103038:	89 55 9c             	mov    %edx,-0x64(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c010303b:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010303e:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103041:	89 d0                	mov    %edx,%eax
c0103043:	c1 e0 02             	shl    $0x2,%eax
c0103046:	01 d0                	add    %edx,%eax
c0103048:	c1 e0 02             	shl    $0x2,%eax
c010304b:	01 c8                	add    %ecx,%eax
c010304d:	83 c0 14             	add    $0x14,%eax
c0103050:	8b 00                	mov    (%eax),%eax
c0103052:	89 45 84             	mov    %eax,-0x7c(%ebp)
c0103055:	8b 45 98             	mov    -0x68(%ebp),%eax
c0103058:	8b 55 9c             	mov    -0x64(%ebp),%edx
c010305b:	83 c0 ff             	add    $0xffffffff,%eax
c010305e:	83 d2 ff             	adc    $0xffffffff,%edx
c0103061:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
c0103067:	89 95 7c ff ff ff    	mov    %edx,-0x84(%ebp)
c010306d:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103070:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103073:	89 d0                	mov    %edx,%eax
c0103075:	c1 e0 02             	shl    $0x2,%eax
c0103078:	01 d0                	add    %edx,%eax
c010307a:	c1 e0 02             	shl    $0x2,%eax
c010307d:	01 c8                	add    %ecx,%eax
c010307f:	8b 48 0c             	mov    0xc(%eax),%ecx
c0103082:	8b 58 10             	mov    0x10(%eax),%ebx
c0103085:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0103088:	89 54 24 1c          	mov    %edx,0x1c(%esp)
c010308c:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
c0103092:	8b 95 7c ff ff ff    	mov    -0x84(%ebp),%edx
c0103098:	89 44 24 14          	mov    %eax,0x14(%esp)
c010309c:	89 54 24 18          	mov    %edx,0x18(%esp)
c01030a0:	8b 45 a0             	mov    -0x60(%ebp),%eax
c01030a3:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c01030a6:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01030aa:	89 54 24 10          	mov    %edx,0x10(%esp)
c01030ae:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c01030b2:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c01030b6:	c7 04 24 f4 a8 10 c0 	movl   $0xc010a8f4,(%esp)
c01030bd:	e8 08 d2 ff ff       	call   c01002ca <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c01030c2:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01030c5:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01030c8:	89 d0                	mov    %edx,%eax
c01030ca:	c1 e0 02             	shl    $0x2,%eax
c01030cd:	01 d0                	add    %edx,%eax
c01030cf:	c1 e0 02             	shl    $0x2,%eax
c01030d2:	01 c8                	add    %ecx,%eax
c01030d4:	83 c0 14             	add    $0x14,%eax
c01030d7:	8b 00                	mov    (%eax),%eax
c01030d9:	83 f8 01             	cmp    $0x1,%eax
c01030dc:	75 2e                	jne    c010310c <page_init+0x154>
            if (maxpa < end && begin < KMEMSIZE) {
c01030de:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01030e1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01030e4:	3b 45 98             	cmp    -0x68(%ebp),%eax
c01030e7:	89 d0                	mov    %edx,%eax
c01030e9:	1b 45 9c             	sbb    -0x64(%ebp),%eax
c01030ec:	73 1e                	jae    c010310c <page_init+0x154>
c01030ee:	ba ff ff ff 37       	mov    $0x37ffffff,%edx
c01030f3:	b8 00 00 00 00       	mov    $0x0,%eax
c01030f8:	3b 55 a0             	cmp    -0x60(%ebp),%edx
c01030fb:	1b 45 a4             	sbb    -0x5c(%ebp),%eax
c01030fe:	72 0c                	jb     c010310c <page_init+0x154>
                maxpa = end;
c0103100:	8b 45 98             	mov    -0x68(%ebp),%eax
c0103103:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0103106:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0103109:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    for (i = 0; i < memmap->nr_map; i ++) {
c010310c:	ff 45 dc             	incl   -0x24(%ebp)
c010310f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103112:	8b 00                	mov    (%eax),%eax
c0103114:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0103117:	0f 8c d8 fe ff ff    	jl     c0102ff5 <page_init+0x3d>
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c010311d:	ba 00 00 00 38       	mov    $0x38000000,%edx
c0103122:	b8 00 00 00 00       	mov    $0x0,%eax
c0103127:	3b 55 e0             	cmp    -0x20(%ebp),%edx
c010312a:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
c010312d:	73 0e                	jae    c010313d <page_init+0x185>
        maxpa = KMEMSIZE;
c010312f:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c0103136:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c010313d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103140:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103143:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0103147:	c1 ea 0c             	shr    $0xc,%edx
c010314a:	a3 80 3e 12 c0       	mov    %eax,0xc0123e80
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c010314f:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
c0103156:	b8 44 3f 12 c0       	mov    $0xc0123f44,%eax
c010315b:	8d 50 ff             	lea    -0x1(%eax),%edx
c010315e:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0103161:	01 d0                	add    %edx,%eax
c0103163:	89 45 bc             	mov    %eax,-0x44(%ebp)
c0103166:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0103169:	ba 00 00 00 00       	mov    $0x0,%edx
c010316e:	f7 75 c0             	divl   -0x40(%ebp)
c0103171:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0103174:	29 d0                	sub    %edx,%eax
c0103176:	a3 34 3f 12 c0       	mov    %eax,0xc0123f34

    for (i = 0; i < npage; i ++) {
c010317b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103182:	eb 2f                	jmp    c01031b3 <page_init+0x1fb>
        SetPageReserved(pages + i);
c0103184:	8b 0d 34 3f 12 c0    	mov    0xc0123f34,%ecx
c010318a:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010318d:	89 d0                	mov    %edx,%eax
c010318f:	c1 e0 02             	shl    $0x2,%eax
c0103192:	01 d0                	add    %edx,%eax
c0103194:	c1 e0 02             	shl    $0x2,%eax
c0103197:	01 c8                	add    %ecx,%eax
c0103199:	83 c0 04             	add    $0x4,%eax
c010319c:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
c01031a3:	89 45 90             	mov    %eax,-0x70(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01031a6:	8b 45 90             	mov    -0x70(%ebp),%eax
c01031a9:	8b 55 94             	mov    -0x6c(%ebp),%edx
c01031ac:	0f ab 10             	bts    %edx,(%eax)
}
c01031af:	90                   	nop
    for (i = 0; i < npage; i ++) {
c01031b0:	ff 45 dc             	incl   -0x24(%ebp)
c01031b3:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01031b6:	a1 80 3e 12 c0       	mov    0xc0123e80,%eax
c01031bb:	39 c2                	cmp    %eax,%edx
c01031bd:	72 c5                	jb     c0103184 <page_init+0x1cc>
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c01031bf:	8b 15 80 3e 12 c0    	mov    0xc0123e80,%edx
c01031c5:	89 d0                	mov    %edx,%eax
c01031c7:	c1 e0 02             	shl    $0x2,%eax
c01031ca:	01 d0                	add    %edx,%eax
c01031cc:	c1 e0 02             	shl    $0x2,%eax
c01031cf:	89 c2                	mov    %eax,%edx
c01031d1:	a1 34 3f 12 c0       	mov    0xc0123f34,%eax
c01031d6:	01 d0                	add    %edx,%eax
c01031d8:	89 45 b8             	mov    %eax,-0x48(%ebp)
c01031db:	81 7d b8 ff ff ff bf 	cmpl   $0xbfffffff,-0x48(%ebp)
c01031e2:	77 23                	ja     c0103207 <page_init+0x24f>
c01031e4:	8b 45 b8             	mov    -0x48(%ebp),%eax
c01031e7:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01031eb:	c7 44 24 08 24 a9 10 	movl   $0xc010a924,0x8(%esp)
c01031f2:	c0 
c01031f3:	c7 44 24 04 dd 00 00 	movl   $0xdd,0x4(%esp)
c01031fa:	00 
c01031fb:	c7 04 24 48 a9 10 c0 	movl   $0xc010a948,(%esp)
c0103202:	e8 2f d2 ff ff       	call   c0100436 <__panic>
c0103207:	8b 45 b8             	mov    -0x48(%ebp),%eax
c010320a:	05 00 00 00 40       	add    $0x40000000,%eax
c010320f:	89 45 b4             	mov    %eax,-0x4c(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c0103212:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103219:	e9 4b 01 00 00       	jmp    c0103369 <page_init+0x3b1>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c010321e:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103221:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103224:	89 d0                	mov    %edx,%eax
c0103226:	c1 e0 02             	shl    $0x2,%eax
c0103229:	01 d0                	add    %edx,%eax
c010322b:	c1 e0 02             	shl    $0x2,%eax
c010322e:	01 c8                	add    %ecx,%eax
c0103230:	8b 50 08             	mov    0x8(%eax),%edx
c0103233:	8b 40 04             	mov    0x4(%eax),%eax
c0103236:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103239:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c010323c:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010323f:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103242:	89 d0                	mov    %edx,%eax
c0103244:	c1 e0 02             	shl    $0x2,%eax
c0103247:	01 d0                	add    %edx,%eax
c0103249:	c1 e0 02             	shl    $0x2,%eax
c010324c:	01 c8                	add    %ecx,%eax
c010324e:	8b 48 0c             	mov    0xc(%eax),%ecx
c0103251:	8b 58 10             	mov    0x10(%eax),%ebx
c0103254:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103257:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010325a:	01 c8                	add    %ecx,%eax
c010325c:	11 da                	adc    %ebx,%edx
c010325e:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0103261:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c0103264:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103267:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010326a:	89 d0                	mov    %edx,%eax
c010326c:	c1 e0 02             	shl    $0x2,%eax
c010326f:	01 d0                	add    %edx,%eax
c0103271:	c1 e0 02             	shl    $0x2,%eax
c0103274:	01 c8                	add    %ecx,%eax
c0103276:	83 c0 14             	add    $0x14,%eax
c0103279:	8b 00                	mov    (%eax),%eax
c010327b:	83 f8 01             	cmp    $0x1,%eax
c010327e:	0f 85 e2 00 00 00    	jne    c0103366 <page_init+0x3ae>
            if (begin < freemem) {
c0103284:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103287:	ba 00 00 00 00       	mov    $0x0,%edx
c010328c:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c010328f:	39 45 d0             	cmp    %eax,-0x30(%ebp)
c0103292:	19 d1                	sbb    %edx,%ecx
c0103294:	73 0d                	jae    c01032a3 <page_init+0x2eb>
                begin = freemem;
c0103296:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103299:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010329c:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c01032a3:	ba 00 00 00 38       	mov    $0x38000000,%edx
c01032a8:	b8 00 00 00 00       	mov    $0x0,%eax
c01032ad:	3b 55 c8             	cmp    -0x38(%ebp),%edx
c01032b0:	1b 45 cc             	sbb    -0x34(%ebp),%eax
c01032b3:	73 0e                	jae    c01032c3 <page_init+0x30b>
                end = KMEMSIZE;
c01032b5:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c01032bc:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c01032c3:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01032c6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01032c9:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c01032cc:	89 d0                	mov    %edx,%eax
c01032ce:	1b 45 cc             	sbb    -0x34(%ebp),%eax
c01032d1:	0f 83 8f 00 00 00    	jae    c0103366 <page_init+0x3ae>
                begin = ROUNDUP(begin, PGSIZE);
c01032d7:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
c01032de:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01032e1:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01032e4:	01 d0                	add    %edx,%eax
c01032e6:	48                   	dec    %eax
c01032e7:	89 45 ac             	mov    %eax,-0x54(%ebp)
c01032ea:	8b 45 ac             	mov    -0x54(%ebp),%eax
c01032ed:	ba 00 00 00 00       	mov    $0x0,%edx
c01032f2:	f7 75 b0             	divl   -0x50(%ebp)
c01032f5:	8b 45 ac             	mov    -0x54(%ebp),%eax
c01032f8:	29 d0                	sub    %edx,%eax
c01032fa:	ba 00 00 00 00       	mov    $0x0,%edx
c01032ff:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103302:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c0103305:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0103308:	89 45 a8             	mov    %eax,-0x58(%ebp)
c010330b:	8b 45 a8             	mov    -0x58(%ebp),%eax
c010330e:	ba 00 00 00 00       	mov    $0x0,%edx
c0103313:	89 c3                	mov    %eax,%ebx
c0103315:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
c010331b:	89 de                	mov    %ebx,%esi
c010331d:	89 d0                	mov    %edx,%eax
c010331f:	83 e0 00             	and    $0x0,%eax
c0103322:	89 c7                	mov    %eax,%edi
c0103324:	89 75 c8             	mov    %esi,-0x38(%ebp)
c0103327:	89 7d cc             	mov    %edi,-0x34(%ebp)
                if (begin < end) {
c010332a:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010332d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103330:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0103333:	89 d0                	mov    %edx,%eax
c0103335:	1b 45 cc             	sbb    -0x34(%ebp),%eax
c0103338:	73 2c                	jae    c0103366 <page_init+0x3ae>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c010333a:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010333d:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0103340:	2b 45 d0             	sub    -0x30(%ebp),%eax
c0103343:	1b 55 d4             	sbb    -0x2c(%ebp),%edx
c0103346:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c010334a:	c1 ea 0c             	shr    $0xc,%edx
c010334d:	89 c3                	mov    %eax,%ebx
c010334f:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103352:	89 04 24             	mov    %eax,(%esp)
c0103355:	e8 ad f8 ff ff       	call   c0102c07 <pa2page>
c010335a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c010335e:	89 04 24             	mov    %eax,(%esp)
c0103361:	e8 8c fb ff ff       	call   c0102ef2 <init_memmap>
    for (i = 0; i < memmap->nr_map; i ++) {
c0103366:	ff 45 dc             	incl   -0x24(%ebp)
c0103369:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010336c:	8b 00                	mov    (%eax),%eax
c010336e:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0103371:	0f 8c a7 fe ff ff    	jl     c010321e <page_init+0x266>
                }
            }
        }
    }
}
c0103377:	90                   	nop
c0103378:	90                   	nop
c0103379:	81 c4 9c 00 00 00    	add    $0x9c,%esp
c010337f:	5b                   	pop    %ebx
c0103380:	5e                   	pop    %esi
c0103381:	5f                   	pop    %edi
c0103382:	5d                   	pop    %ebp
c0103383:	c3                   	ret    

c0103384 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c0103384:	f3 0f 1e fb          	endbr32 
c0103388:	55                   	push   %ebp
c0103389:	89 e5                	mov    %esp,%ebp
c010338b:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
c010338e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103391:	33 45 14             	xor    0x14(%ebp),%eax
c0103394:	25 ff 0f 00 00       	and    $0xfff,%eax
c0103399:	85 c0                	test   %eax,%eax
c010339b:	74 24                	je     c01033c1 <boot_map_segment+0x3d>
c010339d:	c7 44 24 0c 56 a9 10 	movl   $0xc010a956,0xc(%esp)
c01033a4:	c0 
c01033a5:	c7 44 24 08 6d a9 10 	movl   $0xc010a96d,0x8(%esp)
c01033ac:	c0 
c01033ad:	c7 44 24 04 fb 00 00 	movl   $0xfb,0x4(%esp)
c01033b4:	00 
c01033b5:	c7 04 24 48 a9 10 c0 	movl   $0xc010a948,(%esp)
c01033bc:	e8 75 d0 ff ff       	call   c0100436 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c01033c1:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c01033c8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01033cb:	25 ff 0f 00 00       	and    $0xfff,%eax
c01033d0:	89 c2                	mov    %eax,%edx
c01033d2:	8b 45 10             	mov    0x10(%ebp),%eax
c01033d5:	01 c2                	add    %eax,%edx
c01033d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01033da:	01 d0                	add    %edx,%eax
c01033dc:	48                   	dec    %eax
c01033dd:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01033e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01033e3:	ba 00 00 00 00       	mov    $0x0,%edx
c01033e8:	f7 75 f0             	divl   -0x10(%ebp)
c01033eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01033ee:	29 d0                	sub    %edx,%eax
c01033f0:	c1 e8 0c             	shr    $0xc,%eax
c01033f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c01033f6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01033f9:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01033fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01033ff:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103404:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c0103407:	8b 45 14             	mov    0x14(%ebp),%eax
c010340a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010340d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103410:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103415:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0103418:	eb 68                	jmp    c0103482 <boot_map_segment+0xfe>
        pte_t *ptep = get_pte(pgdir, la, 1);
c010341a:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0103421:	00 
c0103422:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103425:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103429:	8b 45 08             	mov    0x8(%ebp),%eax
c010342c:	89 04 24             	mov    %eax,(%esp)
c010342f:	e8 8a 01 00 00       	call   c01035be <get_pte>
c0103434:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c0103437:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c010343b:	75 24                	jne    c0103461 <boot_map_segment+0xdd>
c010343d:	c7 44 24 0c 82 a9 10 	movl   $0xc010a982,0xc(%esp)
c0103444:	c0 
c0103445:	c7 44 24 08 6d a9 10 	movl   $0xc010a96d,0x8(%esp)
c010344c:	c0 
c010344d:	c7 44 24 04 01 01 00 	movl   $0x101,0x4(%esp)
c0103454:	00 
c0103455:	c7 04 24 48 a9 10 c0 	movl   $0xc010a948,(%esp)
c010345c:	e8 d5 cf ff ff       	call   c0100436 <__panic>
        *ptep = pa | PTE_P | perm;
c0103461:	8b 45 14             	mov    0x14(%ebp),%eax
c0103464:	0b 45 18             	or     0x18(%ebp),%eax
c0103467:	83 c8 01             	or     $0x1,%eax
c010346a:	89 c2                	mov    %eax,%edx
c010346c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010346f:	89 10                	mov    %edx,(%eax)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0103471:	ff 4d f4             	decl   -0xc(%ebp)
c0103474:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c010347b:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c0103482:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103486:	75 92                	jne    c010341a <boot_map_segment+0x96>
    }
}
c0103488:	90                   	nop
c0103489:	90                   	nop
c010348a:	c9                   	leave  
c010348b:	c3                   	ret    

c010348c <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c010348c:	f3 0f 1e fb          	endbr32 
c0103490:	55                   	push   %ebp
c0103491:	89 e5                	mov    %esp,%ebp
c0103493:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
c0103496:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010349d:	e8 74 fa ff ff       	call   c0102f16 <alloc_pages>
c01034a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c01034a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01034a9:	75 1c                	jne    c01034c7 <boot_alloc_page+0x3b>
        panic("boot_alloc_page failed.\n");
c01034ab:	c7 44 24 08 8f a9 10 	movl   $0xc010a98f,0x8(%esp)
c01034b2:	c0 
c01034b3:	c7 44 24 04 0d 01 00 	movl   $0x10d,0x4(%esp)
c01034ba:	00 
c01034bb:	c7 04 24 48 a9 10 c0 	movl   $0xc010a948,(%esp)
c01034c2:	e8 6f cf ff ff       	call   c0100436 <__panic>
    }
    return page2kva(p);
c01034c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01034ca:	89 04 24             	mov    %eax,(%esp)
c01034cd:	e8 84 f7 ff ff       	call   c0102c56 <page2kva>
}
c01034d2:	c9                   	leave  
c01034d3:	c3                   	ret    

c01034d4 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c01034d4:	f3 0f 1e fb          	endbr32 
c01034d8:	55                   	push   %ebp
c01034d9:	89 e5                	mov    %esp,%ebp
c01034db:	83 ec 38             	sub    $0x38,%esp
    // We've already enabled paging
    boot_cr3 = PADDR(boot_pgdir);
c01034de:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c01034e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01034e6:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c01034ed:	77 23                	ja     c0103512 <pmm_init+0x3e>
c01034ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01034f2:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01034f6:	c7 44 24 08 24 a9 10 	movl   $0xc010a924,0x8(%esp)
c01034fd:	c0 
c01034fe:	c7 44 24 04 17 01 00 	movl   $0x117,0x4(%esp)
c0103505:	00 
c0103506:	c7 04 24 48 a9 10 c0 	movl   $0xc010a948,(%esp)
c010350d:	e8 24 cf ff ff       	call   c0100436 <__panic>
c0103512:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103515:	05 00 00 00 40       	add    $0x40000000,%eax
c010351a:	a3 30 3f 12 c0       	mov    %eax,0xc0123f30
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c010351f:	e8 96 f9 ff ff       	call   c0102eba <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c0103524:	e8 8f fa ff ff       	call   c0102fb8 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c0103529:	e8 1a 04 00 00       	call   c0103948 <check_alloc_page>

    check_pgdir();
c010352e:	e8 38 04 00 00       	call   c010396b <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c0103533:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c0103538:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010353b:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c0103542:	77 23                	ja     c0103567 <pmm_init+0x93>
c0103544:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103547:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010354b:	c7 44 24 08 24 a9 10 	movl   $0xc010a924,0x8(%esp)
c0103552:	c0 
c0103553:	c7 44 24 04 2d 01 00 	movl   $0x12d,0x4(%esp)
c010355a:	00 
c010355b:	c7 04 24 48 a9 10 c0 	movl   $0xc010a948,(%esp)
c0103562:	e8 cf ce ff ff       	call   c0100436 <__panic>
c0103567:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010356a:	8d 90 00 00 00 40    	lea    0x40000000(%eax),%edx
c0103570:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c0103575:	05 ac 0f 00 00       	add    $0xfac,%eax
c010357a:	83 ca 03             	or     $0x3,%edx
c010357d:	89 10                	mov    %edx,(%eax)

    // map all physical memory to linear memory with base linear addr KERNBASE
    // linear_addr KERNBASE ~ KERNBASE + KMEMSIZE = phy_addr 0 ~ KMEMSIZE
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c010357f:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c0103584:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
c010358b:	00 
c010358c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0103593:	00 
c0103594:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
c010359b:	38 
c010359c:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
c01035a3:	c0 
c01035a4:	89 04 24             	mov    %eax,(%esp)
c01035a7:	e8 d8 fd ff ff       	call   c0103384 <boot_map_segment>

    // Since we are using bootloader's GDT,
    // we should reload gdt (second time, the last time) to get user segments and the TSS
    // map virtual_addr 0 ~ 4G = linear_addr 0 ~ 4G
    // then set kernel stack (ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c01035ac:	e8 1b f8 ff ff       	call   c0102dcc <gdt_init>

    //now the basic virtual memory map(see memlayout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c01035b1:	e8 55 0a 00 00       	call   c010400b <check_boot_pgdir>

    print_pgdir();
c01035b6:	e8 da 0e 00 00       	call   c0104495 <print_pgdir>

}
c01035bb:	90                   	nop
c01035bc:	c9                   	leave  
c01035bd:	c3                   	ret    

c01035be <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c01035be:	f3 0f 1e fb          	endbr32 
c01035c2:	55                   	push   %ebp
c01035c3:	89 e5                	mov    %esp,%ebp
c01035c5:	83 ec 38             	sub    $0x38,%esp
     *   PTE_P           0x001                   // page table/directory entry flags bit : Present
     *   PTE_W           0x002                   // page table/directory entry flags bit : Writeable
     *   PTE_U           0x004                   // page table/directory entry flags bit : User can access
     */
// #if 0
    pde_t *pdep = &pgdir[PDX(la)];                      // (1) find page directory entry
c01035c8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01035cb:	c1 e8 16             	shr    $0x16,%eax
c01035ce:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01035d5:	8b 45 08             	mov    0x8(%ebp),%eax
c01035d8:	01 d0                	add    %edx,%eax
c01035da:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (!(*pdep & PTE_P)) {                             // (2) check if entry is not present
c01035dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01035e0:	8b 00                	mov    (%eax),%eax
c01035e2:	83 e0 01             	and    $0x1,%eax
c01035e5:	85 c0                	test   %eax,%eax
c01035e7:	0f 85 d6 00 00 00    	jne    c01036c3 <get_pte+0x105>
        if (create){
c01035ed:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01035f1:	0f 84 c5 00 00 00    	je     c01036bc <get_pte+0xfe>
            struct Page* page =  alloc_page();          // (3) check if creating is needed, then alloc page for page table    
c01035f7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01035fe:	e8 13 f9 ff ff       	call   c0102f16 <alloc_pages>
c0103603:	89 45 f0             	mov    %eax,-0x10(%ebp)
                                                        // CAUTION: this page is used for page table, not for common data page
            assert (page != NULL);
c0103606:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010360a:	75 24                	jne    c0103630 <get_pte+0x72>
c010360c:	c7 44 24 0c a8 a9 10 	movl   $0xc010a9a8,0xc(%esp)
c0103613:	c0 
c0103614:	c7 44 24 08 6d a9 10 	movl   $0xc010a96d,0x8(%esp)
c010361b:	c0 
c010361c:	c7 44 24 04 65 01 00 	movl   $0x165,0x4(%esp)
c0103623:	00 
c0103624:	c7 04 24 48 a9 10 c0 	movl   $0xc010a948,(%esp)
c010362b:	e8 06 ce ff ff       	call   c0100436 <__panic>
            set_page_ref(page, 1);                      // (4) set page reference
c0103630:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103637:	00 
c0103638:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010363b:	89 04 24             	mov    %eax,(%esp)
c010363e:	e8 c7 f6 ff ff       	call   c0102d0a <set_page_ref>
            uintptr_t pa = page2pa(page);               // (5) get physical address of page
c0103643:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103646:	89 04 24             	mov    %eax,(%esp)
c0103649:	e8 a3 f5 ff ff       	call   c0102bf1 <page2pa>
c010364e:	89 45 ec             	mov    %eax,-0x14(%ebp)
            memset(KADDR(pa), 0, PGSIZE);               // (6) clear page content using memset
c0103651:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103654:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0103657:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010365a:	c1 e8 0c             	shr    $0xc,%eax
c010365d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103660:	a1 80 3e 12 c0       	mov    0xc0123e80,%eax
c0103665:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0103668:	72 23                	jb     c010368d <get_pte+0xcf>
c010366a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010366d:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103671:	c7 44 24 08 80 a8 10 	movl   $0xc010a880,0x8(%esp)
c0103678:	c0 
c0103679:	c7 44 24 04 68 01 00 	movl   $0x168,0x4(%esp)
c0103680:	00 
c0103681:	c7 04 24 48 a9 10 c0 	movl   $0xc010a948,(%esp)
c0103688:	e8 a9 cd ff ff       	call   c0100436 <__panic>
c010368d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103690:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0103695:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c010369c:	00 
c010369d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01036a4:	00 
c01036a5:	89 04 24             	mov    %eax,(%esp)
c01036a8:	e8 c9 61 00 00       	call   c0109876 <memset>
            *pdep = pa | PTE_U | PTE_W | PTE_P;         // (7) set page directory entry's permission
c01036ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01036b0:	83 c8 07             	or     $0x7,%eax
c01036b3:	89 c2                	mov    %eax,%edx
c01036b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01036b8:	89 10                	mov    %edx,(%eax)
c01036ba:	eb 07                	jmp    c01036c3 <get_pte+0x105>
        }
        else
            return NULL;
c01036bc:	b8 00 00 00 00       	mov    $0x0,%eax
c01036c1:	eb 5d                	jmp    c0103720 <get_pte+0x162>
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)]; // (8) return page table entry
c01036c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01036c6:	8b 00                	mov    (%eax),%eax
c01036c8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01036cd:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01036d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01036d3:	c1 e8 0c             	shr    $0xc,%eax
c01036d6:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01036d9:	a1 80 3e 12 c0       	mov    0xc0123e80,%eax
c01036de:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c01036e1:	72 23                	jb     c0103706 <get_pte+0x148>
c01036e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01036e6:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01036ea:	c7 44 24 08 80 a8 10 	movl   $0xc010a880,0x8(%esp)
c01036f1:	c0 
c01036f2:	c7 44 24 04 6e 01 00 	movl   $0x16e,0x4(%esp)
c01036f9:	00 
c01036fa:	c7 04 24 48 a9 10 c0 	movl   $0xc010a948,(%esp)
c0103701:	e8 30 cd ff ff       	call   c0100436 <__panic>
c0103706:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103709:	2d 00 00 00 40       	sub    $0x40000000,%eax
c010370e:	89 c2                	mov    %eax,%edx
c0103710:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103713:	c1 e8 0c             	shr    $0xc,%eax
c0103716:	25 ff 03 00 00       	and    $0x3ff,%eax
c010371b:	c1 e0 02             	shl    $0x2,%eax
c010371e:	01 d0                	add    %edx,%eax
// #endif
}
c0103720:	c9                   	leave  
c0103721:	c3                   	ret    

c0103722 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c0103722:	f3 0f 1e fb          	endbr32 
c0103726:	55                   	push   %ebp
c0103727:	89 e5                	mov    %esp,%ebp
c0103729:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c010372c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0103733:	00 
c0103734:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103737:	89 44 24 04          	mov    %eax,0x4(%esp)
c010373b:	8b 45 08             	mov    0x8(%ebp),%eax
c010373e:	89 04 24             	mov    %eax,(%esp)
c0103741:	e8 78 fe ff ff       	call   c01035be <get_pte>
c0103746:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c0103749:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010374d:	74 08                	je     c0103757 <get_page+0x35>
        *ptep_store = ptep;
c010374f:	8b 45 10             	mov    0x10(%ebp),%eax
c0103752:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103755:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c0103757:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010375b:	74 1b                	je     c0103778 <get_page+0x56>
c010375d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103760:	8b 00                	mov    (%eax),%eax
c0103762:	83 e0 01             	and    $0x1,%eax
c0103765:	85 c0                	test   %eax,%eax
c0103767:	74 0f                	je     c0103778 <get_page+0x56>
        return pte2page(*ptep);
c0103769:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010376c:	8b 00                	mov    (%eax),%eax
c010376e:	89 04 24             	mov    %eax,(%esp)
c0103771:	e8 34 f5 ff ff       	call   c0102caa <pte2page>
c0103776:	eb 05                	jmp    c010377d <get_page+0x5b>
    }
    return NULL;
c0103778:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010377d:	c9                   	leave  
c010377e:	c3                   	ret    

c010377f <page_remove_pte>:

//page_remove_pte - free a Page struct which is related to linear address la
//                - and clean(invalidate) pte which is related to linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c010377f:	55                   	push   %ebp
c0103780:	89 e5                	mov    %esp,%ebp
c0103782:	83 ec 28             	sub    $0x28,%esp
     *                        edited are the ones currently in use by the processor.
     * DEFINEs:
     *   PTE_P           0x001                   // page table/directory entry flags bit : Present
     */
// #if 0
     if (*ptep & PTE_P) {                     //(1) check if this page table entry is present
c0103785:	8b 45 10             	mov    0x10(%ebp),%eax
c0103788:	8b 00                	mov    (%eax),%eax
c010378a:	83 e0 01             	and    $0x1,%eax
c010378d:	85 c0                	test   %eax,%eax
c010378f:	74 4d                	je     c01037de <page_remove_pte+0x5f>
        struct Page *page = pte2page(*ptep);  //(2) find corresponding page to pte
c0103791:	8b 45 10             	mov    0x10(%ebp),%eax
c0103794:	8b 00                	mov    (%eax),%eax
c0103796:	89 04 24             	mov    %eax,(%esp)
c0103799:	e8 0c f5 ff ff       	call   c0102caa <pte2page>
c010379e:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (page_ref_dec(page) == 0)          //(3) decrease page reference
c01037a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01037a4:	89 04 24             	mov    %eax,(%esp)
c01037a7:	e8 83 f5 ff ff       	call   c0102d2f <page_ref_dec>
c01037ac:	85 c0                	test   %eax,%eax
c01037ae:	75 13                	jne    c01037c3 <page_remove_pte+0x44>
            free_page(page);                  //(4) and free this page when page reference reaches 0      
c01037b0:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01037b7:	00 
c01037b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01037bb:	89 04 24             	mov    %eax,(%esp)
c01037be:	e8 8f f7 ff ff       	call   c0102f52 <free_pages>
        *ptep = 0;                            //(5) clear second page table entry
c01037c3:	8b 45 10             	mov    0x10(%ebp),%eax
c01037c6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tlb_invalidate(pgdir, la);            //(6) flush tlb
c01037cc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01037cf:	89 44 24 04          	mov    %eax,0x4(%esp)
c01037d3:	8b 45 08             	mov    0x8(%ebp),%eax
c01037d6:	89 04 24             	mov    %eax,(%esp)
c01037d9:	e8 09 01 00 00       	call   c01038e7 <tlb_invalidate>
    }
// #endif
}
c01037de:	90                   	nop
c01037df:	c9                   	leave  
c01037e0:	c3                   	ret    

c01037e1 <page_remove>:

//page_remove - free a Page which is related to linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c01037e1:	f3 0f 1e fb          	endbr32 
c01037e5:	55                   	push   %ebp
c01037e6:	89 e5                	mov    %esp,%ebp
c01037e8:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c01037eb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01037f2:	00 
c01037f3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01037f6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01037fa:	8b 45 08             	mov    0x8(%ebp),%eax
c01037fd:	89 04 24             	mov    %eax,(%esp)
c0103800:	e8 b9 fd ff ff       	call   c01035be <get_pte>
c0103805:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
c0103808:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010380c:	74 19                	je     c0103827 <page_remove+0x46>
        page_remove_pte(pgdir, la, ptep);
c010380e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103811:	89 44 24 08          	mov    %eax,0x8(%esp)
c0103815:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103818:	89 44 24 04          	mov    %eax,0x4(%esp)
c010381c:	8b 45 08             	mov    0x8(%ebp),%eax
c010381f:	89 04 24             	mov    %eax,(%esp)
c0103822:	e8 58 ff ff ff       	call   c010377f <page_remove_pte>
    }
}
c0103827:	90                   	nop
c0103828:	c9                   	leave  
c0103829:	c3                   	ret    

c010382a <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c010382a:	f3 0f 1e fb          	endbr32 
c010382e:	55                   	push   %ebp
c010382f:	89 e5                	mov    %esp,%ebp
c0103831:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c0103834:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c010383b:	00 
c010383c:	8b 45 10             	mov    0x10(%ebp),%eax
c010383f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103843:	8b 45 08             	mov    0x8(%ebp),%eax
c0103846:	89 04 24             	mov    %eax,(%esp)
c0103849:	e8 70 fd ff ff       	call   c01035be <get_pte>
c010384e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c0103851:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103855:	75 0a                	jne    c0103861 <page_insert+0x37>
        return -E_NO_MEM;
c0103857:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c010385c:	e9 84 00 00 00       	jmp    c01038e5 <page_insert+0xbb>
    }
    page_ref_inc(page);
c0103861:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103864:	89 04 24             	mov    %eax,(%esp)
c0103867:	e8 ac f4 ff ff       	call   c0102d18 <page_ref_inc>
    if (*ptep & PTE_P) {
c010386c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010386f:	8b 00                	mov    (%eax),%eax
c0103871:	83 e0 01             	and    $0x1,%eax
c0103874:	85 c0                	test   %eax,%eax
c0103876:	74 3e                	je     c01038b6 <page_insert+0x8c>
        struct Page *p = pte2page(*ptep);
c0103878:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010387b:	8b 00                	mov    (%eax),%eax
c010387d:	89 04 24             	mov    %eax,(%esp)
c0103880:	e8 25 f4 ff ff       	call   c0102caa <pte2page>
c0103885:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c0103888:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010388b:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010388e:	75 0d                	jne    c010389d <page_insert+0x73>
            page_ref_dec(page);
c0103890:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103893:	89 04 24             	mov    %eax,(%esp)
c0103896:	e8 94 f4 ff ff       	call   c0102d2f <page_ref_dec>
c010389b:	eb 19                	jmp    c01038b6 <page_insert+0x8c>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c010389d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01038a0:	89 44 24 08          	mov    %eax,0x8(%esp)
c01038a4:	8b 45 10             	mov    0x10(%ebp),%eax
c01038a7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01038ab:	8b 45 08             	mov    0x8(%ebp),%eax
c01038ae:	89 04 24             	mov    %eax,(%esp)
c01038b1:	e8 c9 fe ff ff       	call   c010377f <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c01038b6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01038b9:	89 04 24             	mov    %eax,(%esp)
c01038bc:	e8 30 f3 ff ff       	call   c0102bf1 <page2pa>
c01038c1:	0b 45 14             	or     0x14(%ebp),%eax
c01038c4:	83 c8 01             	or     $0x1,%eax
c01038c7:	89 c2                	mov    %eax,%edx
c01038c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01038cc:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c01038ce:	8b 45 10             	mov    0x10(%ebp),%eax
c01038d1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01038d5:	8b 45 08             	mov    0x8(%ebp),%eax
c01038d8:	89 04 24             	mov    %eax,(%esp)
c01038db:	e8 07 00 00 00       	call   c01038e7 <tlb_invalidate>
    return 0;
c01038e0:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01038e5:	c9                   	leave  
c01038e6:	c3                   	ret    

c01038e7 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c01038e7:	f3 0f 1e fb          	endbr32 
c01038eb:	55                   	push   %ebp
c01038ec:	89 e5                	mov    %esp,%ebp
c01038ee:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c01038f1:	0f 20 d8             	mov    %cr3,%eax
c01038f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
c01038f7:	8b 55 f0             	mov    -0x10(%ebp),%edx
    if (rcr3() == PADDR(pgdir)) {
c01038fa:	8b 45 08             	mov    0x8(%ebp),%eax
c01038fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103900:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0103907:	77 23                	ja     c010392c <tlb_invalidate+0x45>
c0103909:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010390c:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103910:	c7 44 24 08 24 a9 10 	movl   $0xc010a924,0x8(%esp)
c0103917:	c0 
c0103918:	c7 44 24 04 c9 01 00 	movl   $0x1c9,0x4(%esp)
c010391f:	00 
c0103920:	c7 04 24 48 a9 10 c0 	movl   $0xc010a948,(%esp)
c0103927:	e8 0a cb ff ff       	call   c0100436 <__panic>
c010392c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010392f:	05 00 00 00 40       	add    $0x40000000,%eax
c0103934:	39 d0                	cmp    %edx,%eax
c0103936:	75 0d                	jne    c0103945 <tlb_invalidate+0x5e>
        invlpg((void *)la);
c0103938:	8b 45 0c             	mov    0xc(%ebp),%eax
c010393b:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c010393e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103941:	0f 01 38             	invlpg (%eax)
}
c0103944:	90                   	nop
    }
}
c0103945:	90                   	nop
c0103946:	c9                   	leave  
c0103947:	c3                   	ret    

c0103948 <check_alloc_page>:

static void
check_alloc_page(void) {
c0103948:	f3 0f 1e fb          	endbr32 
c010394c:	55                   	push   %ebp
c010394d:	89 e5                	mov    %esp,%ebp
c010394f:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
c0103952:	a1 2c 3f 12 c0       	mov    0xc0123f2c,%eax
c0103957:	8b 40 18             	mov    0x18(%eax),%eax
c010395a:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c010395c:	c7 04 24 b8 a9 10 c0 	movl   $0xc010a9b8,(%esp)
c0103963:	e8 62 c9 ff ff       	call   c01002ca <cprintf>
}
c0103968:	90                   	nop
c0103969:	c9                   	leave  
c010396a:	c3                   	ret    

c010396b <check_pgdir>:

static void
check_pgdir(void) {
c010396b:	f3 0f 1e fb          	endbr32 
c010396f:	55                   	push   %ebp
c0103970:	89 e5                	mov    %esp,%ebp
c0103972:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c0103975:	a1 80 3e 12 c0       	mov    0xc0123e80,%eax
c010397a:	3d 00 80 03 00       	cmp    $0x38000,%eax
c010397f:	76 24                	jbe    c01039a5 <check_pgdir+0x3a>
c0103981:	c7 44 24 0c d7 a9 10 	movl   $0xc010a9d7,0xc(%esp)
c0103988:	c0 
c0103989:	c7 44 24 08 6d a9 10 	movl   $0xc010a96d,0x8(%esp)
c0103990:	c0 
c0103991:	c7 44 24 04 d6 01 00 	movl   $0x1d6,0x4(%esp)
c0103998:	00 
c0103999:	c7 04 24 48 a9 10 c0 	movl   $0xc010a948,(%esp)
c01039a0:	e8 91 ca ff ff       	call   c0100436 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c01039a5:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c01039aa:	85 c0                	test   %eax,%eax
c01039ac:	74 0e                	je     c01039bc <check_pgdir+0x51>
c01039ae:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c01039b3:	25 ff 0f 00 00       	and    $0xfff,%eax
c01039b8:	85 c0                	test   %eax,%eax
c01039ba:	74 24                	je     c01039e0 <check_pgdir+0x75>
c01039bc:	c7 44 24 0c f4 a9 10 	movl   $0xc010a9f4,0xc(%esp)
c01039c3:	c0 
c01039c4:	c7 44 24 08 6d a9 10 	movl   $0xc010a96d,0x8(%esp)
c01039cb:	c0 
c01039cc:	c7 44 24 04 d7 01 00 	movl   $0x1d7,0x4(%esp)
c01039d3:	00 
c01039d4:	c7 04 24 48 a9 10 c0 	movl   $0xc010a948,(%esp)
c01039db:	e8 56 ca ff ff       	call   c0100436 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c01039e0:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c01039e5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01039ec:	00 
c01039ed:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01039f4:	00 
c01039f5:	89 04 24             	mov    %eax,(%esp)
c01039f8:	e8 25 fd ff ff       	call   c0103722 <get_page>
c01039fd:	85 c0                	test   %eax,%eax
c01039ff:	74 24                	je     c0103a25 <check_pgdir+0xba>
c0103a01:	c7 44 24 0c 2c aa 10 	movl   $0xc010aa2c,0xc(%esp)
c0103a08:	c0 
c0103a09:	c7 44 24 08 6d a9 10 	movl   $0xc010a96d,0x8(%esp)
c0103a10:	c0 
c0103a11:	c7 44 24 04 d8 01 00 	movl   $0x1d8,0x4(%esp)
c0103a18:	00 
c0103a19:	c7 04 24 48 a9 10 c0 	movl   $0xc010a948,(%esp)
c0103a20:	e8 11 ca ff ff       	call   c0100436 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c0103a25:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103a2c:	e8 e5 f4 ff ff       	call   c0102f16 <alloc_pages>
c0103a31:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c0103a34:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c0103a39:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0103a40:	00 
c0103a41:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0103a48:	00 
c0103a49:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103a4c:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103a50:	89 04 24             	mov    %eax,(%esp)
c0103a53:	e8 d2 fd ff ff       	call   c010382a <page_insert>
c0103a58:	85 c0                	test   %eax,%eax
c0103a5a:	74 24                	je     c0103a80 <check_pgdir+0x115>
c0103a5c:	c7 44 24 0c 54 aa 10 	movl   $0xc010aa54,0xc(%esp)
c0103a63:	c0 
c0103a64:	c7 44 24 08 6d a9 10 	movl   $0xc010a96d,0x8(%esp)
c0103a6b:	c0 
c0103a6c:	c7 44 24 04 dc 01 00 	movl   $0x1dc,0x4(%esp)
c0103a73:	00 
c0103a74:	c7 04 24 48 a9 10 c0 	movl   $0xc010a948,(%esp)
c0103a7b:	e8 b6 c9 ff ff       	call   c0100436 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c0103a80:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c0103a85:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0103a8c:	00 
c0103a8d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0103a94:	00 
c0103a95:	89 04 24             	mov    %eax,(%esp)
c0103a98:	e8 21 fb ff ff       	call   c01035be <get_pte>
c0103a9d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103aa0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103aa4:	75 24                	jne    c0103aca <check_pgdir+0x15f>
c0103aa6:	c7 44 24 0c 80 aa 10 	movl   $0xc010aa80,0xc(%esp)
c0103aad:	c0 
c0103aae:	c7 44 24 08 6d a9 10 	movl   $0xc010a96d,0x8(%esp)
c0103ab5:	c0 
c0103ab6:	c7 44 24 04 df 01 00 	movl   $0x1df,0x4(%esp)
c0103abd:	00 
c0103abe:	c7 04 24 48 a9 10 c0 	movl   $0xc010a948,(%esp)
c0103ac5:	e8 6c c9 ff ff       	call   c0100436 <__panic>
    assert(pte2page(*ptep) == p1);
c0103aca:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103acd:	8b 00                	mov    (%eax),%eax
c0103acf:	89 04 24             	mov    %eax,(%esp)
c0103ad2:	e8 d3 f1 ff ff       	call   c0102caa <pte2page>
c0103ad7:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0103ada:	74 24                	je     c0103b00 <check_pgdir+0x195>
c0103adc:	c7 44 24 0c ad aa 10 	movl   $0xc010aaad,0xc(%esp)
c0103ae3:	c0 
c0103ae4:	c7 44 24 08 6d a9 10 	movl   $0xc010a96d,0x8(%esp)
c0103aeb:	c0 
c0103aec:	c7 44 24 04 e0 01 00 	movl   $0x1e0,0x4(%esp)
c0103af3:	00 
c0103af4:	c7 04 24 48 a9 10 c0 	movl   $0xc010a948,(%esp)
c0103afb:	e8 36 c9 ff ff       	call   c0100436 <__panic>
    assert(page_ref(p1) == 1);
c0103b00:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103b03:	89 04 24             	mov    %eax,(%esp)
c0103b06:	e8 f5 f1 ff ff       	call   c0102d00 <page_ref>
c0103b0b:	83 f8 01             	cmp    $0x1,%eax
c0103b0e:	74 24                	je     c0103b34 <check_pgdir+0x1c9>
c0103b10:	c7 44 24 0c c3 aa 10 	movl   $0xc010aac3,0xc(%esp)
c0103b17:	c0 
c0103b18:	c7 44 24 08 6d a9 10 	movl   $0xc010a96d,0x8(%esp)
c0103b1f:	c0 
c0103b20:	c7 44 24 04 e1 01 00 	movl   $0x1e1,0x4(%esp)
c0103b27:	00 
c0103b28:	c7 04 24 48 a9 10 c0 	movl   $0xc010a948,(%esp)
c0103b2f:	e8 02 c9 ff ff       	call   c0100436 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c0103b34:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c0103b39:	8b 00                	mov    (%eax),%eax
c0103b3b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103b40:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103b43:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103b46:	c1 e8 0c             	shr    $0xc,%eax
c0103b49:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0103b4c:	a1 80 3e 12 c0       	mov    0xc0123e80,%eax
c0103b51:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0103b54:	72 23                	jb     c0103b79 <check_pgdir+0x20e>
c0103b56:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103b59:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103b5d:	c7 44 24 08 80 a8 10 	movl   $0xc010a880,0x8(%esp)
c0103b64:	c0 
c0103b65:	c7 44 24 04 e3 01 00 	movl   $0x1e3,0x4(%esp)
c0103b6c:	00 
c0103b6d:	c7 04 24 48 a9 10 c0 	movl   $0xc010a948,(%esp)
c0103b74:	e8 bd c8 ff ff       	call   c0100436 <__panic>
c0103b79:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103b7c:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0103b81:	83 c0 04             	add    $0x4,%eax
c0103b84:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c0103b87:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c0103b8c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0103b93:	00 
c0103b94:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0103b9b:	00 
c0103b9c:	89 04 24             	mov    %eax,(%esp)
c0103b9f:	e8 1a fa ff ff       	call   c01035be <get_pte>
c0103ba4:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0103ba7:	74 24                	je     c0103bcd <check_pgdir+0x262>
c0103ba9:	c7 44 24 0c d8 aa 10 	movl   $0xc010aad8,0xc(%esp)
c0103bb0:	c0 
c0103bb1:	c7 44 24 08 6d a9 10 	movl   $0xc010a96d,0x8(%esp)
c0103bb8:	c0 
c0103bb9:	c7 44 24 04 e4 01 00 	movl   $0x1e4,0x4(%esp)
c0103bc0:	00 
c0103bc1:	c7 04 24 48 a9 10 c0 	movl   $0xc010a948,(%esp)
c0103bc8:	e8 69 c8 ff ff       	call   c0100436 <__panic>

    p2 = alloc_page();
c0103bcd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103bd4:	e8 3d f3 ff ff       	call   c0102f16 <alloc_pages>
c0103bd9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c0103bdc:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c0103be1:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
c0103be8:	00 
c0103be9:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0103bf0:	00 
c0103bf1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103bf4:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103bf8:	89 04 24             	mov    %eax,(%esp)
c0103bfb:	e8 2a fc ff ff       	call   c010382a <page_insert>
c0103c00:	85 c0                	test   %eax,%eax
c0103c02:	74 24                	je     c0103c28 <check_pgdir+0x2bd>
c0103c04:	c7 44 24 0c 00 ab 10 	movl   $0xc010ab00,0xc(%esp)
c0103c0b:	c0 
c0103c0c:	c7 44 24 08 6d a9 10 	movl   $0xc010a96d,0x8(%esp)
c0103c13:	c0 
c0103c14:	c7 44 24 04 e7 01 00 	movl   $0x1e7,0x4(%esp)
c0103c1b:	00 
c0103c1c:	c7 04 24 48 a9 10 c0 	movl   $0xc010a948,(%esp)
c0103c23:	e8 0e c8 ff ff       	call   c0100436 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0103c28:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c0103c2d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0103c34:	00 
c0103c35:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0103c3c:	00 
c0103c3d:	89 04 24             	mov    %eax,(%esp)
c0103c40:	e8 79 f9 ff ff       	call   c01035be <get_pte>
c0103c45:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103c48:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103c4c:	75 24                	jne    c0103c72 <check_pgdir+0x307>
c0103c4e:	c7 44 24 0c 38 ab 10 	movl   $0xc010ab38,0xc(%esp)
c0103c55:	c0 
c0103c56:	c7 44 24 08 6d a9 10 	movl   $0xc010a96d,0x8(%esp)
c0103c5d:	c0 
c0103c5e:	c7 44 24 04 e8 01 00 	movl   $0x1e8,0x4(%esp)
c0103c65:	00 
c0103c66:	c7 04 24 48 a9 10 c0 	movl   $0xc010a948,(%esp)
c0103c6d:	e8 c4 c7 ff ff       	call   c0100436 <__panic>
    assert(*ptep & PTE_U);
c0103c72:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103c75:	8b 00                	mov    (%eax),%eax
c0103c77:	83 e0 04             	and    $0x4,%eax
c0103c7a:	85 c0                	test   %eax,%eax
c0103c7c:	75 24                	jne    c0103ca2 <check_pgdir+0x337>
c0103c7e:	c7 44 24 0c 68 ab 10 	movl   $0xc010ab68,0xc(%esp)
c0103c85:	c0 
c0103c86:	c7 44 24 08 6d a9 10 	movl   $0xc010a96d,0x8(%esp)
c0103c8d:	c0 
c0103c8e:	c7 44 24 04 e9 01 00 	movl   $0x1e9,0x4(%esp)
c0103c95:	00 
c0103c96:	c7 04 24 48 a9 10 c0 	movl   $0xc010a948,(%esp)
c0103c9d:	e8 94 c7 ff ff       	call   c0100436 <__panic>
    assert(*ptep & PTE_W);
c0103ca2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103ca5:	8b 00                	mov    (%eax),%eax
c0103ca7:	83 e0 02             	and    $0x2,%eax
c0103caa:	85 c0                	test   %eax,%eax
c0103cac:	75 24                	jne    c0103cd2 <check_pgdir+0x367>
c0103cae:	c7 44 24 0c 76 ab 10 	movl   $0xc010ab76,0xc(%esp)
c0103cb5:	c0 
c0103cb6:	c7 44 24 08 6d a9 10 	movl   $0xc010a96d,0x8(%esp)
c0103cbd:	c0 
c0103cbe:	c7 44 24 04 ea 01 00 	movl   $0x1ea,0x4(%esp)
c0103cc5:	00 
c0103cc6:	c7 04 24 48 a9 10 c0 	movl   $0xc010a948,(%esp)
c0103ccd:	e8 64 c7 ff ff       	call   c0100436 <__panic>
    assert(boot_pgdir[0] & PTE_U);
c0103cd2:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c0103cd7:	8b 00                	mov    (%eax),%eax
c0103cd9:	83 e0 04             	and    $0x4,%eax
c0103cdc:	85 c0                	test   %eax,%eax
c0103cde:	75 24                	jne    c0103d04 <check_pgdir+0x399>
c0103ce0:	c7 44 24 0c 84 ab 10 	movl   $0xc010ab84,0xc(%esp)
c0103ce7:	c0 
c0103ce8:	c7 44 24 08 6d a9 10 	movl   $0xc010a96d,0x8(%esp)
c0103cef:	c0 
c0103cf0:	c7 44 24 04 eb 01 00 	movl   $0x1eb,0x4(%esp)
c0103cf7:	00 
c0103cf8:	c7 04 24 48 a9 10 c0 	movl   $0xc010a948,(%esp)
c0103cff:	e8 32 c7 ff ff       	call   c0100436 <__panic>
    assert(page_ref(p2) == 1);
c0103d04:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103d07:	89 04 24             	mov    %eax,(%esp)
c0103d0a:	e8 f1 ef ff ff       	call   c0102d00 <page_ref>
c0103d0f:	83 f8 01             	cmp    $0x1,%eax
c0103d12:	74 24                	je     c0103d38 <check_pgdir+0x3cd>
c0103d14:	c7 44 24 0c 9a ab 10 	movl   $0xc010ab9a,0xc(%esp)
c0103d1b:	c0 
c0103d1c:	c7 44 24 08 6d a9 10 	movl   $0xc010a96d,0x8(%esp)
c0103d23:	c0 
c0103d24:	c7 44 24 04 ec 01 00 	movl   $0x1ec,0x4(%esp)
c0103d2b:	00 
c0103d2c:	c7 04 24 48 a9 10 c0 	movl   $0xc010a948,(%esp)
c0103d33:	e8 fe c6 ff ff       	call   c0100436 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c0103d38:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c0103d3d:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0103d44:	00 
c0103d45:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0103d4c:	00 
c0103d4d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103d50:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103d54:	89 04 24             	mov    %eax,(%esp)
c0103d57:	e8 ce fa ff ff       	call   c010382a <page_insert>
c0103d5c:	85 c0                	test   %eax,%eax
c0103d5e:	74 24                	je     c0103d84 <check_pgdir+0x419>
c0103d60:	c7 44 24 0c ac ab 10 	movl   $0xc010abac,0xc(%esp)
c0103d67:	c0 
c0103d68:	c7 44 24 08 6d a9 10 	movl   $0xc010a96d,0x8(%esp)
c0103d6f:	c0 
c0103d70:	c7 44 24 04 ee 01 00 	movl   $0x1ee,0x4(%esp)
c0103d77:	00 
c0103d78:	c7 04 24 48 a9 10 c0 	movl   $0xc010a948,(%esp)
c0103d7f:	e8 b2 c6 ff ff       	call   c0100436 <__panic>
    assert(page_ref(p1) == 2);
c0103d84:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103d87:	89 04 24             	mov    %eax,(%esp)
c0103d8a:	e8 71 ef ff ff       	call   c0102d00 <page_ref>
c0103d8f:	83 f8 02             	cmp    $0x2,%eax
c0103d92:	74 24                	je     c0103db8 <check_pgdir+0x44d>
c0103d94:	c7 44 24 0c d8 ab 10 	movl   $0xc010abd8,0xc(%esp)
c0103d9b:	c0 
c0103d9c:	c7 44 24 08 6d a9 10 	movl   $0xc010a96d,0x8(%esp)
c0103da3:	c0 
c0103da4:	c7 44 24 04 ef 01 00 	movl   $0x1ef,0x4(%esp)
c0103dab:	00 
c0103dac:	c7 04 24 48 a9 10 c0 	movl   $0xc010a948,(%esp)
c0103db3:	e8 7e c6 ff ff       	call   c0100436 <__panic>
    assert(page_ref(p2) == 0);
c0103db8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103dbb:	89 04 24             	mov    %eax,(%esp)
c0103dbe:	e8 3d ef ff ff       	call   c0102d00 <page_ref>
c0103dc3:	85 c0                	test   %eax,%eax
c0103dc5:	74 24                	je     c0103deb <check_pgdir+0x480>
c0103dc7:	c7 44 24 0c ea ab 10 	movl   $0xc010abea,0xc(%esp)
c0103dce:	c0 
c0103dcf:	c7 44 24 08 6d a9 10 	movl   $0xc010a96d,0x8(%esp)
c0103dd6:	c0 
c0103dd7:	c7 44 24 04 f0 01 00 	movl   $0x1f0,0x4(%esp)
c0103dde:	00 
c0103ddf:	c7 04 24 48 a9 10 c0 	movl   $0xc010a948,(%esp)
c0103de6:	e8 4b c6 ff ff       	call   c0100436 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0103deb:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c0103df0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0103df7:	00 
c0103df8:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0103dff:	00 
c0103e00:	89 04 24             	mov    %eax,(%esp)
c0103e03:	e8 b6 f7 ff ff       	call   c01035be <get_pte>
c0103e08:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103e0b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103e0f:	75 24                	jne    c0103e35 <check_pgdir+0x4ca>
c0103e11:	c7 44 24 0c 38 ab 10 	movl   $0xc010ab38,0xc(%esp)
c0103e18:	c0 
c0103e19:	c7 44 24 08 6d a9 10 	movl   $0xc010a96d,0x8(%esp)
c0103e20:	c0 
c0103e21:	c7 44 24 04 f1 01 00 	movl   $0x1f1,0x4(%esp)
c0103e28:	00 
c0103e29:	c7 04 24 48 a9 10 c0 	movl   $0xc010a948,(%esp)
c0103e30:	e8 01 c6 ff ff       	call   c0100436 <__panic>
    assert(pte2page(*ptep) == p1);
c0103e35:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103e38:	8b 00                	mov    (%eax),%eax
c0103e3a:	89 04 24             	mov    %eax,(%esp)
c0103e3d:	e8 68 ee ff ff       	call   c0102caa <pte2page>
c0103e42:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0103e45:	74 24                	je     c0103e6b <check_pgdir+0x500>
c0103e47:	c7 44 24 0c ad aa 10 	movl   $0xc010aaad,0xc(%esp)
c0103e4e:	c0 
c0103e4f:	c7 44 24 08 6d a9 10 	movl   $0xc010a96d,0x8(%esp)
c0103e56:	c0 
c0103e57:	c7 44 24 04 f2 01 00 	movl   $0x1f2,0x4(%esp)
c0103e5e:	00 
c0103e5f:	c7 04 24 48 a9 10 c0 	movl   $0xc010a948,(%esp)
c0103e66:	e8 cb c5 ff ff       	call   c0100436 <__panic>
    assert((*ptep & PTE_U) == 0);
c0103e6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103e6e:	8b 00                	mov    (%eax),%eax
c0103e70:	83 e0 04             	and    $0x4,%eax
c0103e73:	85 c0                	test   %eax,%eax
c0103e75:	74 24                	je     c0103e9b <check_pgdir+0x530>
c0103e77:	c7 44 24 0c fc ab 10 	movl   $0xc010abfc,0xc(%esp)
c0103e7e:	c0 
c0103e7f:	c7 44 24 08 6d a9 10 	movl   $0xc010a96d,0x8(%esp)
c0103e86:	c0 
c0103e87:	c7 44 24 04 f3 01 00 	movl   $0x1f3,0x4(%esp)
c0103e8e:	00 
c0103e8f:	c7 04 24 48 a9 10 c0 	movl   $0xc010a948,(%esp)
c0103e96:	e8 9b c5 ff ff       	call   c0100436 <__panic>

    page_remove(boot_pgdir, 0x0);
c0103e9b:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c0103ea0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0103ea7:	00 
c0103ea8:	89 04 24             	mov    %eax,(%esp)
c0103eab:	e8 31 f9 ff ff       	call   c01037e1 <page_remove>
    assert(page_ref(p1) == 1);
c0103eb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103eb3:	89 04 24             	mov    %eax,(%esp)
c0103eb6:	e8 45 ee ff ff       	call   c0102d00 <page_ref>
c0103ebb:	83 f8 01             	cmp    $0x1,%eax
c0103ebe:	74 24                	je     c0103ee4 <check_pgdir+0x579>
c0103ec0:	c7 44 24 0c c3 aa 10 	movl   $0xc010aac3,0xc(%esp)
c0103ec7:	c0 
c0103ec8:	c7 44 24 08 6d a9 10 	movl   $0xc010a96d,0x8(%esp)
c0103ecf:	c0 
c0103ed0:	c7 44 24 04 f6 01 00 	movl   $0x1f6,0x4(%esp)
c0103ed7:	00 
c0103ed8:	c7 04 24 48 a9 10 c0 	movl   $0xc010a948,(%esp)
c0103edf:	e8 52 c5 ff ff       	call   c0100436 <__panic>
    assert(page_ref(p2) == 0);
c0103ee4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103ee7:	89 04 24             	mov    %eax,(%esp)
c0103eea:	e8 11 ee ff ff       	call   c0102d00 <page_ref>
c0103eef:	85 c0                	test   %eax,%eax
c0103ef1:	74 24                	je     c0103f17 <check_pgdir+0x5ac>
c0103ef3:	c7 44 24 0c ea ab 10 	movl   $0xc010abea,0xc(%esp)
c0103efa:	c0 
c0103efb:	c7 44 24 08 6d a9 10 	movl   $0xc010a96d,0x8(%esp)
c0103f02:	c0 
c0103f03:	c7 44 24 04 f7 01 00 	movl   $0x1f7,0x4(%esp)
c0103f0a:	00 
c0103f0b:	c7 04 24 48 a9 10 c0 	movl   $0xc010a948,(%esp)
c0103f12:	e8 1f c5 ff ff       	call   c0100436 <__panic>

    page_remove(boot_pgdir, PGSIZE);
c0103f17:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c0103f1c:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0103f23:	00 
c0103f24:	89 04 24             	mov    %eax,(%esp)
c0103f27:	e8 b5 f8 ff ff       	call   c01037e1 <page_remove>
    assert(page_ref(p1) == 0);
c0103f2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103f2f:	89 04 24             	mov    %eax,(%esp)
c0103f32:	e8 c9 ed ff ff       	call   c0102d00 <page_ref>
c0103f37:	85 c0                	test   %eax,%eax
c0103f39:	74 24                	je     c0103f5f <check_pgdir+0x5f4>
c0103f3b:	c7 44 24 0c 11 ac 10 	movl   $0xc010ac11,0xc(%esp)
c0103f42:	c0 
c0103f43:	c7 44 24 08 6d a9 10 	movl   $0xc010a96d,0x8(%esp)
c0103f4a:	c0 
c0103f4b:	c7 44 24 04 fa 01 00 	movl   $0x1fa,0x4(%esp)
c0103f52:	00 
c0103f53:	c7 04 24 48 a9 10 c0 	movl   $0xc010a948,(%esp)
c0103f5a:	e8 d7 c4 ff ff       	call   c0100436 <__panic>
    assert(page_ref(p2) == 0);
c0103f5f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103f62:	89 04 24             	mov    %eax,(%esp)
c0103f65:	e8 96 ed ff ff       	call   c0102d00 <page_ref>
c0103f6a:	85 c0                	test   %eax,%eax
c0103f6c:	74 24                	je     c0103f92 <check_pgdir+0x627>
c0103f6e:	c7 44 24 0c ea ab 10 	movl   $0xc010abea,0xc(%esp)
c0103f75:	c0 
c0103f76:	c7 44 24 08 6d a9 10 	movl   $0xc010a96d,0x8(%esp)
c0103f7d:	c0 
c0103f7e:	c7 44 24 04 fb 01 00 	movl   $0x1fb,0x4(%esp)
c0103f85:	00 
c0103f86:	c7 04 24 48 a9 10 c0 	movl   $0xc010a948,(%esp)
c0103f8d:	e8 a4 c4 ff ff       	call   c0100436 <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
c0103f92:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c0103f97:	8b 00                	mov    (%eax),%eax
c0103f99:	89 04 24             	mov    %eax,(%esp)
c0103f9c:	e8 47 ed ff ff       	call   c0102ce8 <pde2page>
c0103fa1:	89 04 24             	mov    %eax,(%esp)
c0103fa4:	e8 57 ed ff ff       	call   c0102d00 <page_ref>
c0103fa9:	83 f8 01             	cmp    $0x1,%eax
c0103fac:	74 24                	je     c0103fd2 <check_pgdir+0x667>
c0103fae:	c7 44 24 0c 24 ac 10 	movl   $0xc010ac24,0xc(%esp)
c0103fb5:	c0 
c0103fb6:	c7 44 24 08 6d a9 10 	movl   $0xc010a96d,0x8(%esp)
c0103fbd:	c0 
c0103fbe:	c7 44 24 04 fd 01 00 	movl   $0x1fd,0x4(%esp)
c0103fc5:	00 
c0103fc6:	c7 04 24 48 a9 10 c0 	movl   $0xc010a948,(%esp)
c0103fcd:	e8 64 c4 ff ff       	call   c0100436 <__panic>
    free_page(pde2page(boot_pgdir[0]));
c0103fd2:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c0103fd7:	8b 00                	mov    (%eax),%eax
c0103fd9:	89 04 24             	mov    %eax,(%esp)
c0103fdc:	e8 07 ed ff ff       	call   c0102ce8 <pde2page>
c0103fe1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103fe8:	00 
c0103fe9:	89 04 24             	mov    %eax,(%esp)
c0103fec:	e8 61 ef ff ff       	call   c0102f52 <free_pages>
    boot_pgdir[0] = 0;
c0103ff1:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c0103ff6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c0103ffc:	c7 04 24 4b ac 10 c0 	movl   $0xc010ac4b,(%esp)
c0104003:	e8 c2 c2 ff ff       	call   c01002ca <cprintf>
}
c0104008:	90                   	nop
c0104009:	c9                   	leave  
c010400a:	c3                   	ret    

c010400b <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c010400b:	f3 0f 1e fb          	endbr32 
c010400f:	55                   	push   %ebp
c0104010:	89 e5                	mov    %esp,%ebp
c0104012:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0104015:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010401c:	e9 ca 00 00 00       	jmp    c01040eb <check_boot_pgdir+0xe0>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c0104021:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104024:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104027:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010402a:	c1 e8 0c             	shr    $0xc,%eax
c010402d:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0104030:	a1 80 3e 12 c0       	mov    0xc0123e80,%eax
c0104035:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c0104038:	72 23                	jb     c010405d <check_boot_pgdir+0x52>
c010403a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010403d:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104041:	c7 44 24 08 80 a8 10 	movl   $0xc010a880,0x8(%esp)
c0104048:	c0 
c0104049:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
c0104050:	00 
c0104051:	c7 04 24 48 a9 10 c0 	movl   $0xc010a948,(%esp)
c0104058:	e8 d9 c3 ff ff       	call   c0100436 <__panic>
c010405d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104060:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104065:	89 c2                	mov    %eax,%edx
c0104067:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c010406c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104073:	00 
c0104074:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104078:	89 04 24             	mov    %eax,(%esp)
c010407b:	e8 3e f5 ff ff       	call   c01035be <get_pte>
c0104080:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0104083:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0104087:	75 24                	jne    c01040ad <check_boot_pgdir+0xa2>
c0104089:	c7 44 24 0c 68 ac 10 	movl   $0xc010ac68,0xc(%esp)
c0104090:	c0 
c0104091:	c7 44 24 08 6d a9 10 	movl   $0xc010a96d,0x8(%esp)
c0104098:	c0 
c0104099:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
c01040a0:	00 
c01040a1:	c7 04 24 48 a9 10 c0 	movl   $0xc010a948,(%esp)
c01040a8:	e8 89 c3 ff ff       	call   c0100436 <__panic>
        assert(PTE_ADDR(*ptep) == i);
c01040ad:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01040b0:	8b 00                	mov    (%eax),%eax
c01040b2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01040b7:	89 c2                	mov    %eax,%edx
c01040b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01040bc:	39 c2                	cmp    %eax,%edx
c01040be:	74 24                	je     c01040e4 <check_boot_pgdir+0xd9>
c01040c0:	c7 44 24 0c a5 ac 10 	movl   $0xc010aca5,0xc(%esp)
c01040c7:	c0 
c01040c8:	c7 44 24 08 6d a9 10 	movl   $0xc010a96d,0x8(%esp)
c01040cf:	c0 
c01040d0:	c7 44 24 04 0a 02 00 	movl   $0x20a,0x4(%esp)
c01040d7:	00 
c01040d8:	c7 04 24 48 a9 10 c0 	movl   $0xc010a948,(%esp)
c01040df:	e8 52 c3 ff ff       	call   c0100436 <__panic>
    for (i = 0; i < npage; i += PGSIZE) {
c01040e4:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c01040eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01040ee:	a1 80 3e 12 c0       	mov    0xc0123e80,%eax
c01040f3:	39 c2                	cmp    %eax,%edx
c01040f5:	0f 82 26 ff ff ff    	jb     c0104021 <check_boot_pgdir+0x16>
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c01040fb:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c0104100:	05 ac 0f 00 00       	add    $0xfac,%eax
c0104105:	8b 00                	mov    (%eax),%eax
c0104107:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010410c:	89 c2                	mov    %eax,%edx
c010410e:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c0104113:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104116:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c010411d:	77 23                	ja     c0104142 <check_boot_pgdir+0x137>
c010411f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104122:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104126:	c7 44 24 08 24 a9 10 	movl   $0xc010a924,0x8(%esp)
c010412d:	c0 
c010412e:	c7 44 24 04 0d 02 00 	movl   $0x20d,0x4(%esp)
c0104135:	00 
c0104136:	c7 04 24 48 a9 10 c0 	movl   $0xc010a948,(%esp)
c010413d:	e8 f4 c2 ff ff       	call   c0100436 <__panic>
c0104142:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104145:	05 00 00 00 40       	add    $0x40000000,%eax
c010414a:	39 d0                	cmp    %edx,%eax
c010414c:	74 24                	je     c0104172 <check_boot_pgdir+0x167>
c010414e:	c7 44 24 0c bc ac 10 	movl   $0xc010acbc,0xc(%esp)
c0104155:	c0 
c0104156:	c7 44 24 08 6d a9 10 	movl   $0xc010a96d,0x8(%esp)
c010415d:	c0 
c010415e:	c7 44 24 04 0d 02 00 	movl   $0x20d,0x4(%esp)
c0104165:	00 
c0104166:	c7 04 24 48 a9 10 c0 	movl   $0xc010a948,(%esp)
c010416d:	e8 c4 c2 ff ff       	call   c0100436 <__panic>

    assert(boot_pgdir[0] == 0);
c0104172:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c0104177:	8b 00                	mov    (%eax),%eax
c0104179:	85 c0                	test   %eax,%eax
c010417b:	74 24                	je     c01041a1 <check_boot_pgdir+0x196>
c010417d:	c7 44 24 0c f0 ac 10 	movl   $0xc010acf0,0xc(%esp)
c0104184:	c0 
c0104185:	c7 44 24 08 6d a9 10 	movl   $0xc010a96d,0x8(%esp)
c010418c:	c0 
c010418d:	c7 44 24 04 0f 02 00 	movl   $0x20f,0x4(%esp)
c0104194:	00 
c0104195:	c7 04 24 48 a9 10 c0 	movl   $0xc010a948,(%esp)
c010419c:	e8 95 c2 ff ff       	call   c0100436 <__panic>

    struct Page *p;
    p = alloc_page();
c01041a1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01041a8:	e8 69 ed ff ff       	call   c0102f16 <alloc_pages>
c01041ad:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c01041b0:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c01041b5:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c01041bc:	00 
c01041bd:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
c01041c4:	00 
c01041c5:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01041c8:	89 54 24 04          	mov    %edx,0x4(%esp)
c01041cc:	89 04 24             	mov    %eax,(%esp)
c01041cf:	e8 56 f6 ff ff       	call   c010382a <page_insert>
c01041d4:	85 c0                	test   %eax,%eax
c01041d6:	74 24                	je     c01041fc <check_boot_pgdir+0x1f1>
c01041d8:	c7 44 24 0c 04 ad 10 	movl   $0xc010ad04,0xc(%esp)
c01041df:	c0 
c01041e0:	c7 44 24 08 6d a9 10 	movl   $0xc010a96d,0x8(%esp)
c01041e7:	c0 
c01041e8:	c7 44 24 04 13 02 00 	movl   $0x213,0x4(%esp)
c01041ef:	00 
c01041f0:	c7 04 24 48 a9 10 c0 	movl   $0xc010a948,(%esp)
c01041f7:	e8 3a c2 ff ff       	call   c0100436 <__panic>
    assert(page_ref(p) == 1);
c01041fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01041ff:	89 04 24             	mov    %eax,(%esp)
c0104202:	e8 f9 ea ff ff       	call   c0102d00 <page_ref>
c0104207:	83 f8 01             	cmp    $0x1,%eax
c010420a:	74 24                	je     c0104230 <check_boot_pgdir+0x225>
c010420c:	c7 44 24 0c 32 ad 10 	movl   $0xc010ad32,0xc(%esp)
c0104213:	c0 
c0104214:	c7 44 24 08 6d a9 10 	movl   $0xc010a96d,0x8(%esp)
c010421b:	c0 
c010421c:	c7 44 24 04 14 02 00 	movl   $0x214,0x4(%esp)
c0104223:	00 
c0104224:	c7 04 24 48 a9 10 c0 	movl   $0xc010a948,(%esp)
c010422b:	e8 06 c2 ff ff       	call   c0100436 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c0104230:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c0104235:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c010423c:	00 
c010423d:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
c0104244:	00 
c0104245:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0104248:	89 54 24 04          	mov    %edx,0x4(%esp)
c010424c:	89 04 24             	mov    %eax,(%esp)
c010424f:	e8 d6 f5 ff ff       	call   c010382a <page_insert>
c0104254:	85 c0                	test   %eax,%eax
c0104256:	74 24                	je     c010427c <check_boot_pgdir+0x271>
c0104258:	c7 44 24 0c 44 ad 10 	movl   $0xc010ad44,0xc(%esp)
c010425f:	c0 
c0104260:	c7 44 24 08 6d a9 10 	movl   $0xc010a96d,0x8(%esp)
c0104267:	c0 
c0104268:	c7 44 24 04 15 02 00 	movl   $0x215,0x4(%esp)
c010426f:	00 
c0104270:	c7 04 24 48 a9 10 c0 	movl   $0xc010a948,(%esp)
c0104277:	e8 ba c1 ff ff       	call   c0100436 <__panic>
    assert(page_ref(p) == 2);
c010427c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010427f:	89 04 24             	mov    %eax,(%esp)
c0104282:	e8 79 ea ff ff       	call   c0102d00 <page_ref>
c0104287:	83 f8 02             	cmp    $0x2,%eax
c010428a:	74 24                	je     c01042b0 <check_boot_pgdir+0x2a5>
c010428c:	c7 44 24 0c 7b ad 10 	movl   $0xc010ad7b,0xc(%esp)
c0104293:	c0 
c0104294:	c7 44 24 08 6d a9 10 	movl   $0xc010a96d,0x8(%esp)
c010429b:	c0 
c010429c:	c7 44 24 04 16 02 00 	movl   $0x216,0x4(%esp)
c01042a3:	00 
c01042a4:	c7 04 24 48 a9 10 c0 	movl   $0xc010a948,(%esp)
c01042ab:	e8 86 c1 ff ff       	call   c0100436 <__panic>

    const char *str = "ucore: Hello world!!";
c01042b0:	c7 45 e8 8c ad 10 c0 	movl   $0xc010ad8c,-0x18(%ebp)
    strcpy((void *)0x100, str);
c01042b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01042ba:	89 44 24 04          	mov    %eax,0x4(%esp)
c01042be:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c01042c5:	e8 c8 52 00 00       	call   c0109592 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c01042ca:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
c01042d1:	00 
c01042d2:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c01042d9:	e8 32 53 00 00       	call   c0109610 <strcmp>
c01042de:	85 c0                	test   %eax,%eax
c01042e0:	74 24                	je     c0104306 <check_boot_pgdir+0x2fb>
c01042e2:	c7 44 24 0c a4 ad 10 	movl   $0xc010ada4,0xc(%esp)
c01042e9:	c0 
c01042ea:	c7 44 24 08 6d a9 10 	movl   $0xc010a96d,0x8(%esp)
c01042f1:	c0 
c01042f2:	c7 44 24 04 1a 02 00 	movl   $0x21a,0x4(%esp)
c01042f9:	00 
c01042fa:	c7 04 24 48 a9 10 c0 	movl   $0xc010a948,(%esp)
c0104301:	e8 30 c1 ff ff       	call   c0100436 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c0104306:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104309:	89 04 24             	mov    %eax,(%esp)
c010430c:	e8 45 e9 ff ff       	call   c0102c56 <page2kva>
c0104311:	05 00 01 00 00       	add    $0x100,%eax
c0104316:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c0104319:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0104320:	e8 0f 52 00 00       	call   c0109534 <strlen>
c0104325:	85 c0                	test   %eax,%eax
c0104327:	74 24                	je     c010434d <check_boot_pgdir+0x342>
c0104329:	c7 44 24 0c dc ad 10 	movl   $0xc010addc,0xc(%esp)
c0104330:	c0 
c0104331:	c7 44 24 08 6d a9 10 	movl   $0xc010a96d,0x8(%esp)
c0104338:	c0 
c0104339:	c7 44 24 04 1d 02 00 	movl   $0x21d,0x4(%esp)
c0104340:	00 
c0104341:	c7 04 24 48 a9 10 c0 	movl   $0xc010a948,(%esp)
c0104348:	e8 e9 c0 ff ff       	call   c0100436 <__panic>

    free_page(p);
c010434d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104354:	00 
c0104355:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104358:	89 04 24             	mov    %eax,(%esp)
c010435b:	e8 f2 eb ff ff       	call   c0102f52 <free_pages>
    free_page(pde2page(boot_pgdir[0]));
c0104360:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c0104365:	8b 00                	mov    (%eax),%eax
c0104367:	89 04 24             	mov    %eax,(%esp)
c010436a:	e8 79 e9 ff ff       	call   c0102ce8 <pde2page>
c010436f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104376:	00 
c0104377:	89 04 24             	mov    %eax,(%esp)
c010437a:	e8 d3 eb ff ff       	call   c0102f52 <free_pages>
    boot_pgdir[0] = 0;
c010437f:	a1 e0 09 12 c0       	mov    0xc01209e0,%eax
c0104384:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c010438a:	c7 04 24 00 ae 10 c0 	movl   $0xc010ae00,(%esp)
c0104391:	e8 34 bf ff ff       	call   c01002ca <cprintf>
}
c0104396:	90                   	nop
c0104397:	c9                   	leave  
c0104398:	c3                   	ret    

c0104399 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c0104399:	f3 0f 1e fb          	endbr32 
c010439d:	55                   	push   %ebp
c010439e:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c01043a0:	8b 45 08             	mov    0x8(%ebp),%eax
c01043a3:	83 e0 04             	and    $0x4,%eax
c01043a6:	85 c0                	test   %eax,%eax
c01043a8:	74 04                	je     c01043ae <perm2str+0x15>
c01043aa:	b0 75                	mov    $0x75,%al
c01043ac:	eb 02                	jmp    c01043b0 <perm2str+0x17>
c01043ae:	b0 2d                	mov    $0x2d,%al
c01043b0:	a2 08 3f 12 c0       	mov    %al,0xc0123f08
    str[1] = 'r';
c01043b5:	c6 05 09 3f 12 c0 72 	movb   $0x72,0xc0123f09
    str[2] = (perm & PTE_W) ? 'w' : '-';
c01043bc:	8b 45 08             	mov    0x8(%ebp),%eax
c01043bf:	83 e0 02             	and    $0x2,%eax
c01043c2:	85 c0                	test   %eax,%eax
c01043c4:	74 04                	je     c01043ca <perm2str+0x31>
c01043c6:	b0 77                	mov    $0x77,%al
c01043c8:	eb 02                	jmp    c01043cc <perm2str+0x33>
c01043ca:	b0 2d                	mov    $0x2d,%al
c01043cc:	a2 0a 3f 12 c0       	mov    %al,0xc0123f0a
    str[3] = '\0';
c01043d1:	c6 05 0b 3f 12 c0 00 	movb   $0x0,0xc0123f0b
    return str;
c01043d8:	b8 08 3f 12 c0       	mov    $0xc0123f08,%eax
}
c01043dd:	5d                   	pop    %ebp
c01043de:	c3                   	ret    

c01043df <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c01043df:	f3 0f 1e fb          	endbr32 
c01043e3:	55                   	push   %ebp
c01043e4:	89 e5                	mov    %esp,%ebp
c01043e6:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c01043e9:	8b 45 10             	mov    0x10(%ebp),%eax
c01043ec:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01043ef:	72 0d                	jb     c01043fe <get_pgtable_items+0x1f>
        return 0;
c01043f1:	b8 00 00 00 00       	mov    $0x0,%eax
c01043f6:	e9 98 00 00 00       	jmp    c0104493 <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
        start ++;
c01043fb:	ff 45 10             	incl   0x10(%ebp)
    while (start < right && !(table[start] & PTE_P)) {
c01043fe:	8b 45 10             	mov    0x10(%ebp),%eax
c0104401:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0104404:	73 18                	jae    c010441e <get_pgtable_items+0x3f>
c0104406:	8b 45 10             	mov    0x10(%ebp),%eax
c0104409:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0104410:	8b 45 14             	mov    0x14(%ebp),%eax
c0104413:	01 d0                	add    %edx,%eax
c0104415:	8b 00                	mov    (%eax),%eax
c0104417:	83 e0 01             	and    $0x1,%eax
c010441a:	85 c0                	test   %eax,%eax
c010441c:	74 dd                	je     c01043fb <get_pgtable_items+0x1c>
    }
    if (start < right) {
c010441e:	8b 45 10             	mov    0x10(%ebp),%eax
c0104421:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0104424:	73 68                	jae    c010448e <get_pgtable_items+0xaf>
        if (left_store != NULL) {
c0104426:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c010442a:	74 08                	je     c0104434 <get_pgtable_items+0x55>
            *left_store = start;
c010442c:	8b 45 18             	mov    0x18(%ebp),%eax
c010442f:	8b 55 10             	mov    0x10(%ebp),%edx
c0104432:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);       while (start < right && (table[start] & PTE_USER) == perm) {
c0104434:	8b 45 10             	mov    0x10(%ebp),%eax
c0104437:	8d 50 01             	lea    0x1(%eax),%edx
c010443a:	89 55 10             	mov    %edx,0x10(%ebp)
c010443d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0104444:	8b 45 14             	mov    0x14(%ebp),%eax
c0104447:	01 d0                	add    %edx,%eax
c0104449:	8b 00                	mov    (%eax),%eax
c010444b:	83 e0 07             	and    $0x7,%eax
c010444e:	89 45 fc             	mov    %eax,-0x4(%ebp)
c0104451:	eb 03                	jmp    c0104456 <get_pgtable_items+0x77>
            start ++;
c0104453:	ff 45 10             	incl   0x10(%ebp)
        int perm = (table[start ++] & PTE_USER);       while (start < right && (table[start] & PTE_USER) == perm) {
c0104456:	8b 45 10             	mov    0x10(%ebp),%eax
c0104459:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010445c:	73 1d                	jae    c010447b <get_pgtable_items+0x9c>
c010445e:	8b 45 10             	mov    0x10(%ebp),%eax
c0104461:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0104468:	8b 45 14             	mov    0x14(%ebp),%eax
c010446b:	01 d0                	add    %edx,%eax
c010446d:	8b 00                	mov    (%eax),%eax
c010446f:	83 e0 07             	and    $0x7,%eax
c0104472:	89 c2                	mov    %eax,%edx
c0104474:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104477:	39 c2                	cmp    %eax,%edx
c0104479:	74 d8                	je     c0104453 <get_pgtable_items+0x74>
        }
        if (right_store != NULL) {
c010447b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c010447f:	74 08                	je     c0104489 <get_pgtable_items+0xaa>
            *right_store = start;
c0104481:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0104484:	8b 55 10             	mov    0x10(%ebp),%edx
c0104487:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c0104489:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010448c:	eb 05                	jmp    c0104493 <get_pgtable_items+0xb4>
    }
    return 0;
c010448e:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104493:	c9                   	leave  
c0104494:	c3                   	ret    

c0104495 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c0104495:	f3 0f 1e fb          	endbr32 
c0104499:	55                   	push   %ebp
c010449a:	89 e5                	mov    %esp,%ebp
c010449c:	57                   	push   %edi
c010449d:	56                   	push   %esi
c010449e:	53                   	push   %ebx
c010449f:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c01044a2:	c7 04 24 20 ae 10 c0 	movl   $0xc010ae20,(%esp)
c01044a9:	e8 1c be ff ff       	call   c01002ca <cprintf>
    size_t left, right = 0, perm;
c01044ae:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c01044b5:	e9 fa 00 00 00       	jmp    c01045b4 <print_pgdir+0x11f>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c01044ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01044bd:	89 04 24             	mov    %eax,(%esp)
c01044c0:	e8 d4 fe ff ff       	call   c0104399 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c01044c5:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c01044c8:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01044cb:	29 d1                	sub    %edx,%ecx
c01044cd:	89 ca                	mov    %ecx,%edx
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c01044cf:	89 d6                	mov    %edx,%esi
c01044d1:	c1 e6 16             	shl    $0x16,%esi
c01044d4:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01044d7:	89 d3                	mov    %edx,%ebx
c01044d9:	c1 e3 16             	shl    $0x16,%ebx
c01044dc:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01044df:	89 d1                	mov    %edx,%ecx
c01044e1:	c1 e1 16             	shl    $0x16,%ecx
c01044e4:	8b 7d dc             	mov    -0x24(%ebp),%edi
c01044e7:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01044ea:	29 d7                	sub    %edx,%edi
c01044ec:	89 fa                	mov    %edi,%edx
c01044ee:	89 44 24 14          	mov    %eax,0x14(%esp)
c01044f2:	89 74 24 10          	mov    %esi,0x10(%esp)
c01044f6:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01044fa:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01044fe:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104502:	c7 04 24 51 ae 10 c0 	movl   $0xc010ae51,(%esp)
c0104509:	e8 bc bd ff ff       	call   c01002ca <cprintf>
        size_t l, r = left * NPTEENTRY;
c010450e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104511:	c1 e0 0a             	shl    $0xa,%eax
c0104514:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0104517:	eb 54                	jmp    c010456d <print_pgdir+0xd8>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0104519:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010451c:	89 04 24             	mov    %eax,(%esp)
c010451f:	e8 75 fe ff ff       	call   c0104399 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c0104524:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c0104527:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010452a:	29 d1                	sub    %edx,%ecx
c010452c:	89 ca                	mov    %ecx,%edx
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c010452e:	89 d6                	mov    %edx,%esi
c0104530:	c1 e6 0c             	shl    $0xc,%esi
c0104533:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104536:	89 d3                	mov    %edx,%ebx
c0104538:	c1 e3 0c             	shl    $0xc,%ebx
c010453b:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010453e:	89 d1                	mov    %edx,%ecx
c0104540:	c1 e1 0c             	shl    $0xc,%ecx
c0104543:	8b 7d d4             	mov    -0x2c(%ebp),%edi
c0104546:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0104549:	29 d7                	sub    %edx,%edi
c010454b:	89 fa                	mov    %edi,%edx
c010454d:	89 44 24 14          	mov    %eax,0x14(%esp)
c0104551:	89 74 24 10          	mov    %esi,0x10(%esp)
c0104555:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0104559:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c010455d:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104561:	c7 04 24 70 ae 10 c0 	movl   $0xc010ae70,(%esp)
c0104568:	e8 5d bd ff ff       	call   c01002ca <cprintf>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c010456d:	be 00 00 c0 fa       	mov    $0xfac00000,%esi
c0104572:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104575:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104578:	89 d3                	mov    %edx,%ebx
c010457a:	c1 e3 0a             	shl    $0xa,%ebx
c010457d:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104580:	89 d1                	mov    %edx,%ecx
c0104582:	c1 e1 0a             	shl    $0xa,%ecx
c0104585:	8d 55 d4             	lea    -0x2c(%ebp),%edx
c0104588:	89 54 24 14          	mov    %edx,0x14(%esp)
c010458c:	8d 55 d8             	lea    -0x28(%ebp),%edx
c010458f:	89 54 24 10          	mov    %edx,0x10(%esp)
c0104593:	89 74 24 0c          	mov    %esi,0xc(%esp)
c0104597:	89 44 24 08          	mov    %eax,0x8(%esp)
c010459b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c010459f:	89 0c 24             	mov    %ecx,(%esp)
c01045a2:	e8 38 fe ff ff       	call   c01043df <get_pgtable_items>
c01045a7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01045aa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01045ae:	0f 85 65 ff ff ff    	jne    c0104519 <print_pgdir+0x84>
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c01045b4:	b9 00 b0 fe fa       	mov    $0xfafeb000,%ecx
c01045b9:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01045bc:	8d 55 dc             	lea    -0x24(%ebp),%edx
c01045bf:	89 54 24 14          	mov    %edx,0x14(%esp)
c01045c3:	8d 55 e0             	lea    -0x20(%ebp),%edx
c01045c6:	89 54 24 10          	mov    %edx,0x10(%esp)
c01045ca:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c01045ce:	89 44 24 08          	mov    %eax,0x8(%esp)
c01045d2:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
c01045d9:	00 
c01045da:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01045e1:	e8 f9 fd ff ff       	call   c01043df <get_pgtable_items>
c01045e6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01045e9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01045ed:	0f 85 c7 fe ff ff    	jne    c01044ba <print_pgdir+0x25>
        }
    }
    cprintf("--------------------- END ---------------------\n");
c01045f3:	c7 04 24 94 ae 10 c0 	movl   $0xc010ae94,(%esp)
c01045fa:	e8 cb bc ff ff       	call   c01002ca <cprintf>
}
c01045ff:	90                   	nop
c0104600:	83 c4 4c             	add    $0x4c,%esp
c0104603:	5b                   	pop    %ebx
c0104604:	5e                   	pop    %esi
c0104605:	5f                   	pop    %edi
c0104606:	5d                   	pop    %ebp
c0104607:	c3                   	ret    

c0104608 <page2ppn>:
page2ppn(struct Page *page) {
c0104608:	55                   	push   %ebp
c0104609:	89 e5                	mov    %esp,%ebp
    return page - pages;
c010460b:	a1 34 3f 12 c0       	mov    0xc0123f34,%eax
c0104610:	8b 55 08             	mov    0x8(%ebp),%edx
c0104613:	29 c2                	sub    %eax,%edx
c0104615:	89 d0                	mov    %edx,%eax
c0104617:	c1 f8 02             	sar    $0x2,%eax
c010461a:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c0104620:	5d                   	pop    %ebp
c0104621:	c3                   	ret    

c0104622 <page2pa>:
page2pa(struct Page *page) {
c0104622:	55                   	push   %ebp
c0104623:	89 e5                	mov    %esp,%ebp
c0104625:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0104628:	8b 45 08             	mov    0x8(%ebp),%eax
c010462b:	89 04 24             	mov    %eax,(%esp)
c010462e:	e8 d5 ff ff ff       	call   c0104608 <page2ppn>
c0104633:	c1 e0 0c             	shl    $0xc,%eax
}
c0104636:	c9                   	leave  
c0104637:	c3                   	ret    

c0104638 <page_ref>:
page_ref(struct Page *page) {
c0104638:	55                   	push   %ebp
c0104639:	89 e5                	mov    %esp,%ebp
    return page->ref;
c010463b:	8b 45 08             	mov    0x8(%ebp),%eax
c010463e:	8b 00                	mov    (%eax),%eax
}
c0104640:	5d                   	pop    %ebp
c0104641:	c3                   	ret    

c0104642 <set_page_ref>:
set_page_ref(struct Page *page, int val) {
c0104642:	55                   	push   %ebp
c0104643:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0104645:	8b 45 08             	mov    0x8(%ebp),%eax
c0104648:	8b 55 0c             	mov    0xc(%ebp),%edx
c010464b:	89 10                	mov    %edx,(%eax)
}
c010464d:	90                   	nop
c010464e:	5d                   	pop    %ebp
c010464f:	c3                   	ret    

c0104650 <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
c0104650:	f3 0f 1e fb          	endbr32 
c0104654:	55                   	push   %ebp
c0104655:	89 e5                	mov    %esp,%ebp
c0104657:	83 ec 10             	sub    $0x10,%esp
c010465a:	c7 45 fc 38 3f 12 c0 	movl   $0xc0123f38,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0104661:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104664:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0104667:	89 50 04             	mov    %edx,0x4(%eax)
c010466a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010466d:	8b 50 04             	mov    0x4(%eax),%edx
c0104670:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104673:	89 10                	mov    %edx,(%eax)
}
c0104675:	90                   	nop
    list_init(&free_list);
    nr_free = 0;
c0104676:	c7 05 40 3f 12 c0 00 	movl   $0x0,0xc0123f40
c010467d:	00 00 00 
}
c0104680:	90                   	nop
c0104681:	c9                   	leave  
c0104682:	c3                   	ret    

c0104683 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
c0104683:	f3 0f 1e fb          	endbr32 
c0104687:	55                   	push   %ebp
c0104688:	89 e5                	mov    %esp,%ebp
c010468a:	83 ec 48             	sub    $0x48,%esp
    assert(n > 0);
c010468d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0104691:	75 24                	jne    c01046b7 <default_init_memmap+0x34>
c0104693:	c7 44 24 0c c8 ae 10 	movl   $0xc010aec8,0xc(%esp)
c010469a:	c0 
c010469b:	c7 44 24 08 ce ae 10 	movl   $0xc010aece,0x8(%esp)
c01046a2:	c0 
c01046a3:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
c01046aa:	00 
c01046ab:	c7 04 24 e3 ae 10 c0 	movl   $0xc010aee3,(%esp)
c01046b2:	e8 7f bd ff ff       	call   c0100436 <__panic>
    struct Page *p = base;
c01046b7:	8b 45 08             	mov    0x8(%ebp),%eax
c01046ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c01046bd:	eb 7d                	jmp    c010473c <default_init_memmap+0xb9>
        assert(PageReserved(p));
c01046bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046c2:	83 c0 04             	add    $0x4,%eax
c01046c5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c01046cc:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01046cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01046d2:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01046d5:	0f a3 10             	bt     %edx,(%eax)
c01046d8:	19 c0                	sbb    %eax,%eax
c01046da:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
c01046dd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01046e1:	0f 95 c0             	setne  %al
c01046e4:	0f b6 c0             	movzbl %al,%eax
c01046e7:	85 c0                	test   %eax,%eax
c01046e9:	75 24                	jne    c010470f <default_init_memmap+0x8c>
c01046eb:	c7 44 24 0c f9 ae 10 	movl   $0xc010aef9,0xc(%esp)
c01046f2:	c0 
c01046f3:	c7 44 24 08 ce ae 10 	movl   $0xc010aece,0x8(%esp)
c01046fa:	c0 
c01046fb:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
c0104702:	00 
c0104703:	c7 04 24 e3 ae 10 c0 	movl   $0xc010aee3,(%esp)
c010470a:	e8 27 bd ff ff       	call   c0100436 <__panic>
        p->flags = p->property = 0;
c010470f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104712:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
c0104719:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010471c:	8b 50 08             	mov    0x8(%eax),%edx
c010471f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104722:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
c0104725:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010472c:	00 
c010472d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104730:	89 04 24             	mov    %eax,(%esp)
c0104733:	e8 0a ff ff ff       	call   c0104642 <set_page_ref>
    for (; p != base + n; p ++) {
c0104738:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c010473c:	8b 55 0c             	mov    0xc(%ebp),%edx
c010473f:	89 d0                	mov    %edx,%eax
c0104741:	c1 e0 02             	shl    $0x2,%eax
c0104744:	01 d0                	add    %edx,%eax
c0104746:	c1 e0 02             	shl    $0x2,%eax
c0104749:	89 c2                	mov    %eax,%edx
c010474b:	8b 45 08             	mov    0x8(%ebp),%eax
c010474e:	01 d0                	add    %edx,%eax
c0104750:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0104753:	0f 85 66 ff ff ff    	jne    c01046bf <default_init_memmap+0x3c>
    }
    base->property = n;
c0104759:	8b 45 08             	mov    0x8(%ebp),%eax
c010475c:	8b 55 0c             	mov    0xc(%ebp),%edx
c010475f:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c0104762:	8b 45 08             	mov    0x8(%ebp),%eax
c0104765:	83 c0 04             	add    $0x4,%eax
c0104768:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c010476f:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0104772:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0104775:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0104778:	0f ab 10             	bts    %edx,(%eax)
}
c010477b:	90                   	nop
    nr_free += n;
c010477c:	8b 15 40 3f 12 c0    	mov    0xc0123f40,%edx
c0104782:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104785:	01 d0                	add    %edx,%eax
c0104787:	a3 40 3f 12 c0       	mov    %eax,0xc0123f40
    // list_add(&free_list, &(base->page_link));
    list_add_before(&free_list, &(base->page_link)); // 需要保证空闲页块起始地址有序
c010478c:	8b 45 08             	mov    0x8(%ebp),%eax
c010478f:	83 c0 0c             	add    $0xc,%eax
c0104792:	c7 45 e4 38 3f 12 c0 	movl   $0xc0123f38,-0x1c(%ebp)
c0104799:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c010479c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010479f:	8b 00                	mov    (%eax),%eax
c01047a1:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01047a4:	89 55 dc             	mov    %edx,-0x24(%ebp)
c01047a7:	89 45 d8             	mov    %eax,-0x28(%ebp)
c01047aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01047ad:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c01047b0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01047b3:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01047b6:	89 10                	mov    %edx,(%eax)
c01047b8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01047bb:	8b 10                	mov    (%eax),%edx
c01047bd:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01047c0:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01047c3:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01047c6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01047c9:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01047cc:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01047cf:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01047d2:	89 10                	mov    %edx,(%eax)
}
c01047d4:	90                   	nop
}
c01047d5:	90                   	nop
}
c01047d6:	90                   	nop
c01047d7:	c9                   	leave  
c01047d8:	c3                   	ret    

c01047d9 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
c01047d9:	f3 0f 1e fb          	endbr32 
c01047dd:	55                   	push   %ebp
c01047de:	89 e5                	mov    %esp,%ebp
c01047e0:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
c01047e3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01047e7:	75 24                	jne    c010480d <default_alloc_pages+0x34>
c01047e9:	c7 44 24 0c c8 ae 10 	movl   $0xc010aec8,0xc(%esp)
c01047f0:	c0 
c01047f1:	c7 44 24 08 ce ae 10 	movl   $0xc010aece,0x8(%esp)
c01047f8:	c0 
c01047f9:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
c0104800:	00 
c0104801:	c7 04 24 e3 ae 10 c0 	movl   $0xc010aee3,(%esp)
c0104808:	e8 29 bc ff ff       	call   c0100436 <__panic>
    if (n > nr_free) {
c010480d:	a1 40 3f 12 c0       	mov    0xc0123f40,%eax
c0104812:	39 45 08             	cmp    %eax,0x8(%ebp)
c0104815:	76 0a                	jbe    c0104821 <default_alloc_pages+0x48>
        return NULL;
c0104817:	b8 00 00 00 00       	mov    $0x0,%eax
c010481c:	e9 43 01 00 00       	jmp    c0104964 <default_alloc_pages+0x18b>
    }
    struct Page *page = NULL;
c0104821:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
c0104828:	c7 45 f0 38 3f 12 c0 	movl   $0xc0123f38,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {
c010482f:	eb 1c                	jmp    c010484d <default_alloc_pages+0x74>
        struct Page *p = le2page(le, page_link);
c0104831:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104834:	83 e8 0c             	sub    $0xc,%eax
c0104837:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p->property >= n) {
c010483a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010483d:	8b 40 08             	mov    0x8(%eax),%eax
c0104840:	39 45 08             	cmp    %eax,0x8(%ebp)
c0104843:	77 08                	ja     c010484d <default_alloc_pages+0x74>
            page = p;
c0104845:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104848:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
c010484b:	eb 18                	jmp    c0104865 <default_alloc_pages+0x8c>
c010484d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104850:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return listelm->next;
c0104853:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104856:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c0104859:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010485c:	81 7d f0 38 3f 12 c0 	cmpl   $0xc0123f38,-0x10(%ebp)
c0104863:	75 cc                	jne    c0104831 <default_alloc_pages+0x58>
        }
    }
    if (page != NULL) {
c0104865:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104869:	0f 84 f2 00 00 00    	je     c0104961 <default_alloc_pages+0x188>
        // list_del(&(page->page_link));
        // 页块分裂
        if (page->property > n) {   
c010486f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104872:	8b 40 08             	mov    0x8(%eax),%eax
c0104875:	39 45 08             	cmp    %eax,0x8(%ebp)
c0104878:	0f 83 8f 00 00 00    	jae    c010490d <default_alloc_pages+0x134>
            struct Page *p = page + n;
c010487e:	8b 55 08             	mov    0x8(%ebp),%edx
c0104881:	89 d0                	mov    %edx,%eax
c0104883:	c1 e0 02             	shl    $0x2,%eax
c0104886:	01 d0                	add    %edx,%eax
c0104888:	c1 e0 02             	shl    $0x2,%eax
c010488b:	89 c2                	mov    %eax,%edx
c010488d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104890:	01 d0                	add    %edx,%eax
c0104892:	89 45 e8             	mov    %eax,-0x18(%ebp)
            p->property = page->property - n;
c0104895:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104898:	8b 40 08             	mov    0x8(%eax),%eax
c010489b:	2b 45 08             	sub    0x8(%ebp),%eax
c010489e:	89 c2                	mov    %eax,%edx
c01048a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01048a3:	89 50 08             	mov    %edx,0x8(%eax)
            SetPageProperty(p); // 这时p指向的页是一个空闲页块的起始页
c01048a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01048a9:	83 c0 04             	add    $0x4,%eax
c01048ac:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
c01048b3:	89 45 c8             	mov    %eax,-0x38(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01048b6:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01048b9:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01048bc:	0f ab 10             	bts    %edx,(%eax)
}
c01048bf:	90                   	nop
            // list_add(&free_list, &(p->page_link));
            list_add_after(&(page->page_link), &(p->page_link));  // p代替page在空闲链表中的位置，保证空闲页块起始地址有序
c01048c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01048c3:	83 c0 0c             	add    $0xc,%eax
c01048c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01048c9:	83 c2 0c             	add    $0xc,%edx
c01048cc:	89 55 e0             	mov    %edx,-0x20(%ebp)
c01048cf:	89 45 dc             	mov    %eax,-0x24(%ebp)
    __list_add(elm, listelm, listelm->next);
c01048d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01048d5:	8b 40 04             	mov    0x4(%eax),%eax
c01048d8:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01048db:	89 55 d8             	mov    %edx,-0x28(%ebp)
c01048de:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01048e1:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c01048e4:	89 45 d0             	mov    %eax,-0x30(%ebp)
    prev->next = next->prev = elm;
c01048e7:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01048ea:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01048ed:	89 10                	mov    %edx,(%eax)
c01048ef:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01048f2:	8b 10                	mov    (%eax),%edx
c01048f4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01048f7:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01048fa:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01048fd:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0104900:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0104903:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104906:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104909:	89 10                	mov    %edx,(%eax)
}
c010490b:	90                   	nop
}
c010490c:	90                   	nop
        }
        list_del(&(page->page_link));
c010490d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104910:	83 c0 0c             	add    $0xc,%eax
c0104913:	89 45 bc             	mov    %eax,-0x44(%ebp)
    __list_del(listelm->prev, listelm->next);
c0104916:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0104919:	8b 40 04             	mov    0x4(%eax),%eax
c010491c:	8b 55 bc             	mov    -0x44(%ebp),%edx
c010491f:	8b 12                	mov    (%edx),%edx
c0104921:	89 55 b8             	mov    %edx,-0x48(%ebp)
c0104924:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0104927:	8b 45 b8             	mov    -0x48(%ebp),%eax
c010492a:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c010492d:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0104930:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0104933:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0104936:	89 10                	mov    %edx,(%eax)
}
c0104938:	90                   	nop
}
c0104939:	90                   	nop
        nr_free -= n;
c010493a:	a1 40 3f 12 c0       	mov    0xc0123f40,%eax
c010493f:	2b 45 08             	sub    0x8(%ebp),%eax
c0104942:	a3 40 3f 12 c0       	mov    %eax,0xc0123f40
        ClearPageProperty(page);
c0104947:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010494a:	83 c0 04             	add    $0x4,%eax
c010494d:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
c0104954:	89 45 c0             	mov    %eax,-0x40(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0104957:	8b 45 c0             	mov    -0x40(%ebp),%eax
c010495a:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c010495d:	0f b3 10             	btr    %edx,(%eax)
}
c0104960:	90                   	nop
    }
    return page;
c0104961:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0104964:	c9                   	leave  
c0104965:	c3                   	ret    

c0104966 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
c0104966:	f3 0f 1e fb          	endbr32 
c010496a:	55                   	push   %ebp
c010496b:	89 e5                	mov    %esp,%ebp
c010496d:	81 ec 88 00 00 00    	sub    $0x88,%esp
    assert(n > 0);
c0104973:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0104977:	75 24                	jne    c010499d <default_free_pages+0x37>
c0104979:	c7 44 24 0c c8 ae 10 	movl   $0xc010aec8,0xc(%esp)
c0104980:	c0 
c0104981:	c7 44 24 08 ce ae 10 	movl   $0xc010aece,0x8(%esp)
c0104988:	c0 
c0104989:	c7 44 24 04 9d 00 00 	movl   $0x9d,0x4(%esp)
c0104990:	00 
c0104991:	c7 04 24 e3 ae 10 c0 	movl   $0xc010aee3,(%esp)
c0104998:	e8 99 ba ff ff       	call   c0100436 <__panic>
    struct Page *p = base;
c010499d:	8b 45 08             	mov    0x8(%ebp),%eax
c01049a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c01049a3:	e9 9d 00 00 00       	jmp    c0104a45 <default_free_pages+0xdf>
        assert(!PageReserved(p) && !PageProperty(p));
c01049a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01049ab:	83 c0 04             	add    $0x4,%eax
c01049ae:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01049b5:	89 45 e8             	mov    %eax,-0x18(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01049b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01049bb:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01049be:	0f a3 10             	bt     %edx,(%eax)
c01049c1:	19 c0                	sbb    %eax,%eax
c01049c3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
c01049c6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01049ca:	0f 95 c0             	setne  %al
c01049cd:	0f b6 c0             	movzbl %al,%eax
c01049d0:	85 c0                	test   %eax,%eax
c01049d2:	75 2c                	jne    c0104a00 <default_free_pages+0x9a>
c01049d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01049d7:	83 c0 04             	add    $0x4,%eax
c01049da:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
c01049e1:	89 45 dc             	mov    %eax,-0x24(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01049e4:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01049e7:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01049ea:	0f a3 10             	bt     %edx,(%eax)
c01049ed:	19 c0                	sbb    %eax,%eax
c01049ef:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return oldbit != 0;
c01049f2:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c01049f6:	0f 95 c0             	setne  %al
c01049f9:	0f b6 c0             	movzbl %al,%eax
c01049fc:	85 c0                	test   %eax,%eax
c01049fe:	74 24                	je     c0104a24 <default_free_pages+0xbe>
c0104a00:	c7 44 24 0c 0c af 10 	movl   $0xc010af0c,0xc(%esp)
c0104a07:	c0 
c0104a08:	c7 44 24 08 ce ae 10 	movl   $0xc010aece,0x8(%esp)
c0104a0f:	c0 
c0104a10:	c7 44 24 04 a0 00 00 	movl   $0xa0,0x4(%esp)
c0104a17:	00 
c0104a18:	c7 04 24 e3 ae 10 c0 	movl   $0xc010aee3,(%esp)
c0104a1f:	e8 12 ba ff ff       	call   c0100436 <__panic>
        p->flags = 0;
c0104a24:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104a27:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
c0104a2e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104a35:	00 
c0104a36:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104a39:	89 04 24             	mov    %eax,(%esp)
c0104a3c:	e8 01 fc ff ff       	call   c0104642 <set_page_ref>
    for (; p != base + n; p ++) {
c0104a41:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0104a45:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104a48:	89 d0                	mov    %edx,%eax
c0104a4a:	c1 e0 02             	shl    $0x2,%eax
c0104a4d:	01 d0                	add    %edx,%eax
c0104a4f:	c1 e0 02             	shl    $0x2,%eax
c0104a52:	89 c2                	mov    %eax,%edx
c0104a54:	8b 45 08             	mov    0x8(%ebp),%eax
c0104a57:	01 d0                	add    %edx,%eax
c0104a59:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0104a5c:	0f 85 46 ff ff ff    	jne    c01049a8 <default_free_pages+0x42>
    }
    base->property = n;
c0104a62:	8b 45 08             	mov    0x8(%ebp),%eax
c0104a65:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104a68:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c0104a6b:	8b 45 08             	mov    0x8(%ebp),%eax
c0104a6e:	83 c0 04             	add    $0x4,%eax
c0104a71:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0104a78:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0104a7b:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0104a7e:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0104a81:	0f ab 10             	bts    %edx,(%eax)
}
c0104a84:	90                   	nop
c0104a85:	c7 45 d4 38 3f 12 c0 	movl   $0xc0123f38,-0x2c(%ebp)
    return listelm->next;
c0104a8c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104a8f:	8b 40 04             	mov    0x4(%eax),%eax
    // 页块合并
    list_entry_t *le = list_next(&free_list);
c0104a92:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c0104a95:	e9 79 01 00 00       	jmp    c0104c13 <default_free_pages+0x2ad>
        p = le2page(le, page_link);
c0104a9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104a9d:	83 e8 0c             	sub    $0xc,%eax
c0104aa0:	89 45 f4             	mov    %eax,-0xc(%ebp)
        assert(!(base < p && p < base + base->property));   // 要释放的页块不能与空闲页块有交叉
c0104aa3:	8b 45 08             	mov    0x8(%ebp),%eax
c0104aa6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104aa9:	73 40                	jae    c0104aeb <default_free_pages+0x185>
c0104aab:	8b 45 08             	mov    0x8(%ebp),%eax
c0104aae:	8b 50 08             	mov    0x8(%eax),%edx
c0104ab1:	89 d0                	mov    %edx,%eax
c0104ab3:	c1 e0 02             	shl    $0x2,%eax
c0104ab6:	01 d0                	add    %edx,%eax
c0104ab8:	c1 e0 02             	shl    $0x2,%eax
c0104abb:	89 c2                	mov    %eax,%edx
c0104abd:	8b 45 08             	mov    0x8(%ebp),%eax
c0104ac0:	01 d0                	add    %edx,%eax
c0104ac2:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0104ac5:	73 24                	jae    c0104aeb <default_free_pages+0x185>
c0104ac7:	c7 44 24 0c 34 af 10 	movl   $0xc010af34,0xc(%esp)
c0104ace:	c0 
c0104acf:	c7 44 24 08 ce ae 10 	movl   $0xc010aece,0x8(%esp)
c0104ad6:	c0 
c0104ad7:	c7 44 24 04 aa 00 00 	movl   $0xaa,0x4(%esp)
c0104ade:	00 
c0104adf:	c7 04 24 e3 ae 10 c0 	movl   $0xc010aee3,(%esp)
c0104ae6:	e8 4b b9 ff ff       	call   c0100436 <__panic>
        if (base + base->property < p)  // 再往后的空闲页块与 base 页块一定不相邻
c0104aeb:	8b 45 08             	mov    0x8(%ebp),%eax
c0104aee:	8b 50 08             	mov    0x8(%eax),%edx
c0104af1:	89 d0                	mov    %edx,%eax
c0104af3:	c1 e0 02             	shl    $0x2,%eax
c0104af6:	01 d0                	add    %edx,%eax
c0104af8:	c1 e0 02             	shl    $0x2,%eax
c0104afb:	89 c2                	mov    %eax,%edx
c0104afd:	8b 45 08             	mov    0x8(%ebp),%eax
c0104b00:	01 d0                	add    %edx,%eax
c0104b02:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0104b05:	0f 87 17 01 00 00    	ja     c0104c22 <default_free_pages+0x2bc>
c0104b0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104b0e:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0104b11:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104b14:	8b 40 04             	mov    0x4(%eax),%eax
            break;
        le = list_next(le); // 必须写在前面，因为后面可能会list_del(old_le)
c0104b17:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (base + base->property == p) {
c0104b1a:	8b 45 08             	mov    0x8(%ebp),%eax
c0104b1d:	8b 50 08             	mov    0x8(%eax),%edx
c0104b20:	89 d0                	mov    %edx,%eax
c0104b22:	c1 e0 02             	shl    $0x2,%eax
c0104b25:	01 d0                	add    %edx,%eax
c0104b27:	c1 e0 02             	shl    $0x2,%eax
c0104b2a:	89 c2                	mov    %eax,%edx
c0104b2c:	8b 45 08             	mov    0x8(%ebp),%eax
c0104b2f:	01 d0                	add    %edx,%eax
c0104b31:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0104b34:	75 60                	jne    c0104b96 <default_free_pages+0x230>
            base->property += p->property;
c0104b36:	8b 45 08             	mov    0x8(%ebp),%eax
c0104b39:	8b 50 08             	mov    0x8(%eax),%edx
c0104b3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104b3f:	8b 40 08             	mov    0x8(%eax),%eax
c0104b42:	01 c2                	add    %eax,%edx
c0104b44:	8b 45 08             	mov    0x8(%ebp),%eax
c0104b47:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(p);
c0104b4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104b4d:	83 c0 04             	add    $0x4,%eax
c0104b50:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
c0104b57:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0104b5a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0104b5d:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0104b60:	0f b3 10             	btr    %edx,(%eax)
}
c0104b63:	90                   	nop
            list_del(&(p->page_link));
c0104b64:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104b67:	83 c0 0c             	add    $0xc,%eax
c0104b6a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    __list_del(listelm->prev, listelm->next);
c0104b6d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104b70:	8b 40 04             	mov    0x4(%eax),%eax
c0104b73:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0104b76:	8b 12                	mov    (%edx),%edx
c0104b78:	89 55 c0             	mov    %edx,-0x40(%ebp)
c0104b7b:	89 45 bc             	mov    %eax,-0x44(%ebp)
    prev->next = next;
c0104b7e:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0104b81:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0104b84:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0104b87:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0104b8a:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0104b8d:	89 10                	mov    %edx,(%eax)
}
c0104b8f:	90                   	nop
}
c0104b90:	90                   	nop
            break;  // 认为空闲链表的页块间维持不相邻的状态，所以最多向后合并一次
c0104b91:	e9 8d 00 00 00       	jmp    c0104c23 <default_free_pages+0x2bd>
        }
        else if (p + p->property == base) {
c0104b96:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104b99:	8b 50 08             	mov    0x8(%eax),%edx
c0104b9c:	89 d0                	mov    %edx,%eax
c0104b9e:	c1 e0 02             	shl    $0x2,%eax
c0104ba1:	01 d0                	add    %edx,%eax
c0104ba3:	c1 e0 02             	shl    $0x2,%eax
c0104ba6:	89 c2                	mov    %eax,%edx
c0104ba8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104bab:	01 d0                	add    %edx,%eax
c0104bad:	39 45 08             	cmp    %eax,0x8(%ebp)
c0104bb0:	75 61                	jne    c0104c13 <default_free_pages+0x2ad>
            p->property += base->property;
c0104bb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104bb5:	8b 50 08             	mov    0x8(%eax),%edx
c0104bb8:	8b 45 08             	mov    0x8(%ebp),%eax
c0104bbb:	8b 40 08             	mov    0x8(%eax),%eax
c0104bbe:	01 c2                	add    %eax,%edx
c0104bc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104bc3:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);
c0104bc6:	8b 45 08             	mov    0x8(%ebp),%eax
c0104bc9:	83 c0 04             	add    $0x4,%eax
c0104bcc:	c7 45 a4 01 00 00 00 	movl   $0x1,-0x5c(%ebp)
c0104bd3:	89 45 a0             	mov    %eax,-0x60(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0104bd6:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0104bd9:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0104bdc:	0f b3 10             	btr    %edx,(%eax)
}
c0104bdf:	90                   	nop
            base = p;
c0104be0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104be3:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
c0104be6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104be9:	83 c0 0c             	add    $0xc,%eax
c0104bec:	89 45 b0             	mov    %eax,-0x50(%ebp)
    __list_del(listelm->prev, listelm->next);
c0104bef:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0104bf2:	8b 40 04             	mov    0x4(%eax),%eax
c0104bf5:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0104bf8:	8b 12                	mov    (%edx),%edx
c0104bfa:	89 55 ac             	mov    %edx,-0x54(%ebp)
c0104bfd:	89 45 a8             	mov    %eax,-0x58(%ebp)
    prev->next = next;
c0104c00:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0104c03:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0104c06:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0104c09:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0104c0c:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0104c0f:	89 10                	mov    %edx,(%eax)
}
c0104c11:	90                   	nop
}
c0104c12:	90                   	nop
    while (le != &free_list) {
c0104c13:	81 7d f0 38 3f 12 c0 	cmpl   $0xc0123f38,-0x10(%ebp)
c0104c1a:	0f 85 7a fe ff ff    	jne    c0104a9a <default_free_pages+0x134>
c0104c20:	eb 01                	jmp    c0104c23 <default_free_pages+0x2bd>
            break;
c0104c22:	90                   	nop
        }
    }
    nr_free += n;
c0104c23:	8b 15 40 3f 12 c0    	mov    0xc0123f40,%edx
c0104c29:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104c2c:	01 d0                	add    %edx,%eax
c0104c2e:	a3 40 3f 12 c0       	mov    %eax,0xc0123f40
    // list_add(&free_list, &(base->page_link));
    list_add_before(le, &(base->page_link));    // 前面 break 时 le 正好对应 base 的下一个页块的起始页
c0104c33:	8b 45 08             	mov    0x8(%ebp),%eax
c0104c36:	8d 50 0c             	lea    0xc(%eax),%edx
c0104c39:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104c3c:	89 45 9c             	mov    %eax,-0x64(%ebp)
c0104c3f:	89 55 98             	mov    %edx,-0x68(%ebp)
    __list_add(elm, listelm->prev, listelm);
c0104c42:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0104c45:	8b 00                	mov    (%eax),%eax
c0104c47:	8b 55 98             	mov    -0x68(%ebp),%edx
c0104c4a:	89 55 94             	mov    %edx,-0x6c(%ebp)
c0104c4d:	89 45 90             	mov    %eax,-0x70(%ebp)
c0104c50:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0104c53:	89 45 8c             	mov    %eax,-0x74(%ebp)
    prev->next = next->prev = elm;
c0104c56:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0104c59:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0104c5c:	89 10                	mov    %edx,(%eax)
c0104c5e:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0104c61:	8b 10                	mov    (%eax),%edx
c0104c63:	8b 45 90             	mov    -0x70(%ebp),%eax
c0104c66:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0104c69:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0104c6c:	8b 55 8c             	mov    -0x74(%ebp),%edx
c0104c6f:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0104c72:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0104c75:	8b 55 90             	mov    -0x70(%ebp),%edx
c0104c78:	89 10                	mov    %edx,(%eax)
}
c0104c7a:	90                   	nop
}
c0104c7b:	90                   	nop
}
c0104c7c:	90                   	nop
c0104c7d:	c9                   	leave  
c0104c7e:	c3                   	ret    

c0104c7f <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c0104c7f:	f3 0f 1e fb          	endbr32 
c0104c83:	55                   	push   %ebp
c0104c84:	89 e5                	mov    %esp,%ebp
    return nr_free;
c0104c86:	a1 40 3f 12 c0       	mov    0xc0123f40,%eax
}
c0104c8b:	5d                   	pop    %ebp
c0104c8c:	c3                   	ret    

c0104c8d <basic_check>:

static void
basic_check(void) {
c0104c8d:	f3 0f 1e fb          	endbr32 
c0104c91:	55                   	push   %ebp
c0104c92:	89 e5                	mov    %esp,%ebp
c0104c94:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c0104c97:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104c9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ca1:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104ca4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104ca7:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c0104caa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104cb1:	e8 60 e2 ff ff       	call   c0102f16 <alloc_pages>
c0104cb6:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104cb9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0104cbd:	75 24                	jne    c0104ce3 <basic_check+0x56>
c0104cbf:	c7 44 24 0c 5d af 10 	movl   $0xc010af5d,0xc(%esp)
c0104cc6:	c0 
c0104cc7:	c7 44 24 08 ce ae 10 	movl   $0xc010aece,0x8(%esp)
c0104cce:	c0 
c0104ccf:	c7 44 24 04 c9 00 00 	movl   $0xc9,0x4(%esp)
c0104cd6:	00 
c0104cd7:	c7 04 24 e3 ae 10 c0 	movl   $0xc010aee3,(%esp)
c0104cde:	e8 53 b7 ff ff       	call   c0100436 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0104ce3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104cea:	e8 27 e2 ff ff       	call   c0102f16 <alloc_pages>
c0104cef:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104cf2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104cf6:	75 24                	jne    c0104d1c <basic_check+0x8f>
c0104cf8:	c7 44 24 0c 79 af 10 	movl   $0xc010af79,0xc(%esp)
c0104cff:	c0 
c0104d00:	c7 44 24 08 ce ae 10 	movl   $0xc010aece,0x8(%esp)
c0104d07:	c0 
c0104d08:	c7 44 24 04 ca 00 00 	movl   $0xca,0x4(%esp)
c0104d0f:	00 
c0104d10:	c7 04 24 e3 ae 10 c0 	movl   $0xc010aee3,(%esp)
c0104d17:	e8 1a b7 ff ff       	call   c0100436 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0104d1c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104d23:	e8 ee e1 ff ff       	call   c0102f16 <alloc_pages>
c0104d28:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104d2b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104d2f:	75 24                	jne    c0104d55 <basic_check+0xc8>
c0104d31:	c7 44 24 0c 95 af 10 	movl   $0xc010af95,0xc(%esp)
c0104d38:	c0 
c0104d39:	c7 44 24 08 ce ae 10 	movl   $0xc010aece,0x8(%esp)
c0104d40:	c0 
c0104d41:	c7 44 24 04 cb 00 00 	movl   $0xcb,0x4(%esp)
c0104d48:	00 
c0104d49:	c7 04 24 e3 ae 10 c0 	movl   $0xc010aee3,(%esp)
c0104d50:	e8 e1 b6 ff ff       	call   c0100436 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c0104d55:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104d58:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0104d5b:	74 10                	je     c0104d6d <basic_check+0xe0>
c0104d5d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104d60:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104d63:	74 08                	je     c0104d6d <basic_check+0xe0>
c0104d65:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104d68:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104d6b:	75 24                	jne    c0104d91 <basic_check+0x104>
c0104d6d:	c7 44 24 0c b4 af 10 	movl   $0xc010afb4,0xc(%esp)
c0104d74:	c0 
c0104d75:	c7 44 24 08 ce ae 10 	movl   $0xc010aece,0x8(%esp)
c0104d7c:	c0 
c0104d7d:	c7 44 24 04 cd 00 00 	movl   $0xcd,0x4(%esp)
c0104d84:	00 
c0104d85:	c7 04 24 e3 ae 10 c0 	movl   $0xc010aee3,(%esp)
c0104d8c:	e8 a5 b6 ff ff       	call   c0100436 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c0104d91:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104d94:	89 04 24             	mov    %eax,(%esp)
c0104d97:	e8 9c f8 ff ff       	call   c0104638 <page_ref>
c0104d9c:	85 c0                	test   %eax,%eax
c0104d9e:	75 1e                	jne    c0104dbe <basic_check+0x131>
c0104da0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104da3:	89 04 24             	mov    %eax,(%esp)
c0104da6:	e8 8d f8 ff ff       	call   c0104638 <page_ref>
c0104dab:	85 c0                	test   %eax,%eax
c0104dad:	75 0f                	jne    c0104dbe <basic_check+0x131>
c0104daf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104db2:	89 04 24             	mov    %eax,(%esp)
c0104db5:	e8 7e f8 ff ff       	call   c0104638 <page_ref>
c0104dba:	85 c0                	test   %eax,%eax
c0104dbc:	74 24                	je     c0104de2 <basic_check+0x155>
c0104dbe:	c7 44 24 0c d8 af 10 	movl   $0xc010afd8,0xc(%esp)
c0104dc5:	c0 
c0104dc6:	c7 44 24 08 ce ae 10 	movl   $0xc010aece,0x8(%esp)
c0104dcd:	c0 
c0104dce:	c7 44 24 04 ce 00 00 	movl   $0xce,0x4(%esp)
c0104dd5:	00 
c0104dd6:	c7 04 24 e3 ae 10 c0 	movl   $0xc010aee3,(%esp)
c0104ddd:	e8 54 b6 ff ff       	call   c0100436 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c0104de2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104de5:	89 04 24             	mov    %eax,(%esp)
c0104de8:	e8 35 f8 ff ff       	call   c0104622 <page2pa>
c0104ded:	8b 15 80 3e 12 c0    	mov    0xc0123e80,%edx
c0104df3:	c1 e2 0c             	shl    $0xc,%edx
c0104df6:	39 d0                	cmp    %edx,%eax
c0104df8:	72 24                	jb     c0104e1e <basic_check+0x191>
c0104dfa:	c7 44 24 0c 14 b0 10 	movl   $0xc010b014,0xc(%esp)
c0104e01:	c0 
c0104e02:	c7 44 24 08 ce ae 10 	movl   $0xc010aece,0x8(%esp)
c0104e09:	c0 
c0104e0a:	c7 44 24 04 d0 00 00 	movl   $0xd0,0x4(%esp)
c0104e11:	00 
c0104e12:	c7 04 24 e3 ae 10 c0 	movl   $0xc010aee3,(%esp)
c0104e19:	e8 18 b6 ff ff       	call   c0100436 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c0104e1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104e21:	89 04 24             	mov    %eax,(%esp)
c0104e24:	e8 f9 f7 ff ff       	call   c0104622 <page2pa>
c0104e29:	8b 15 80 3e 12 c0    	mov    0xc0123e80,%edx
c0104e2f:	c1 e2 0c             	shl    $0xc,%edx
c0104e32:	39 d0                	cmp    %edx,%eax
c0104e34:	72 24                	jb     c0104e5a <basic_check+0x1cd>
c0104e36:	c7 44 24 0c 31 b0 10 	movl   $0xc010b031,0xc(%esp)
c0104e3d:	c0 
c0104e3e:	c7 44 24 08 ce ae 10 	movl   $0xc010aece,0x8(%esp)
c0104e45:	c0 
c0104e46:	c7 44 24 04 d1 00 00 	movl   $0xd1,0x4(%esp)
c0104e4d:	00 
c0104e4e:	c7 04 24 e3 ae 10 c0 	movl   $0xc010aee3,(%esp)
c0104e55:	e8 dc b5 ff ff       	call   c0100436 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c0104e5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104e5d:	89 04 24             	mov    %eax,(%esp)
c0104e60:	e8 bd f7 ff ff       	call   c0104622 <page2pa>
c0104e65:	8b 15 80 3e 12 c0    	mov    0xc0123e80,%edx
c0104e6b:	c1 e2 0c             	shl    $0xc,%edx
c0104e6e:	39 d0                	cmp    %edx,%eax
c0104e70:	72 24                	jb     c0104e96 <basic_check+0x209>
c0104e72:	c7 44 24 0c 4e b0 10 	movl   $0xc010b04e,0xc(%esp)
c0104e79:	c0 
c0104e7a:	c7 44 24 08 ce ae 10 	movl   $0xc010aece,0x8(%esp)
c0104e81:	c0 
c0104e82:	c7 44 24 04 d2 00 00 	movl   $0xd2,0x4(%esp)
c0104e89:	00 
c0104e8a:	c7 04 24 e3 ae 10 c0 	movl   $0xc010aee3,(%esp)
c0104e91:	e8 a0 b5 ff ff       	call   c0100436 <__panic>

    list_entry_t free_list_store = free_list;
c0104e96:	a1 38 3f 12 c0       	mov    0xc0123f38,%eax
c0104e9b:	8b 15 3c 3f 12 c0    	mov    0xc0123f3c,%edx
c0104ea1:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104ea4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0104ea7:	c7 45 dc 38 3f 12 c0 	movl   $0xc0123f38,-0x24(%ebp)
    elm->prev = elm->next = elm;
c0104eae:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104eb1:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104eb4:	89 50 04             	mov    %edx,0x4(%eax)
c0104eb7:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104eba:	8b 50 04             	mov    0x4(%eax),%edx
c0104ebd:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104ec0:	89 10                	mov    %edx,(%eax)
}
c0104ec2:	90                   	nop
c0104ec3:	c7 45 e0 38 3f 12 c0 	movl   $0xc0123f38,-0x20(%ebp)
    return list->next == list;
c0104eca:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104ecd:	8b 40 04             	mov    0x4(%eax),%eax
c0104ed0:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c0104ed3:	0f 94 c0             	sete   %al
c0104ed6:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0104ed9:	85 c0                	test   %eax,%eax
c0104edb:	75 24                	jne    c0104f01 <basic_check+0x274>
c0104edd:	c7 44 24 0c 6b b0 10 	movl   $0xc010b06b,0xc(%esp)
c0104ee4:	c0 
c0104ee5:	c7 44 24 08 ce ae 10 	movl   $0xc010aece,0x8(%esp)
c0104eec:	c0 
c0104eed:	c7 44 24 04 d6 00 00 	movl   $0xd6,0x4(%esp)
c0104ef4:	00 
c0104ef5:	c7 04 24 e3 ae 10 c0 	movl   $0xc010aee3,(%esp)
c0104efc:	e8 35 b5 ff ff       	call   c0100436 <__panic>

    unsigned int nr_free_store = nr_free;
c0104f01:	a1 40 3f 12 c0       	mov    0xc0123f40,%eax
c0104f06:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c0104f09:	c7 05 40 3f 12 c0 00 	movl   $0x0,0xc0123f40
c0104f10:	00 00 00 

    assert(alloc_page() == NULL);
c0104f13:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104f1a:	e8 f7 df ff ff       	call   c0102f16 <alloc_pages>
c0104f1f:	85 c0                	test   %eax,%eax
c0104f21:	74 24                	je     c0104f47 <basic_check+0x2ba>
c0104f23:	c7 44 24 0c 82 b0 10 	movl   $0xc010b082,0xc(%esp)
c0104f2a:	c0 
c0104f2b:	c7 44 24 08 ce ae 10 	movl   $0xc010aece,0x8(%esp)
c0104f32:	c0 
c0104f33:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
c0104f3a:	00 
c0104f3b:	c7 04 24 e3 ae 10 c0 	movl   $0xc010aee3,(%esp)
c0104f42:	e8 ef b4 ff ff       	call   c0100436 <__panic>

    free_page(p0);
c0104f47:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104f4e:	00 
c0104f4f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104f52:	89 04 24             	mov    %eax,(%esp)
c0104f55:	e8 f8 df ff ff       	call   c0102f52 <free_pages>
    free_page(p1);
c0104f5a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104f61:	00 
c0104f62:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104f65:	89 04 24             	mov    %eax,(%esp)
c0104f68:	e8 e5 df ff ff       	call   c0102f52 <free_pages>
    free_page(p2);
c0104f6d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104f74:	00 
c0104f75:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104f78:	89 04 24             	mov    %eax,(%esp)
c0104f7b:	e8 d2 df ff ff       	call   c0102f52 <free_pages>
    assert(nr_free == 3);
c0104f80:	a1 40 3f 12 c0       	mov    0xc0123f40,%eax
c0104f85:	83 f8 03             	cmp    $0x3,%eax
c0104f88:	74 24                	je     c0104fae <basic_check+0x321>
c0104f8a:	c7 44 24 0c 97 b0 10 	movl   $0xc010b097,0xc(%esp)
c0104f91:	c0 
c0104f92:	c7 44 24 08 ce ae 10 	movl   $0xc010aece,0x8(%esp)
c0104f99:	c0 
c0104f9a:	c7 44 24 04 e0 00 00 	movl   $0xe0,0x4(%esp)
c0104fa1:	00 
c0104fa2:	c7 04 24 e3 ae 10 c0 	movl   $0xc010aee3,(%esp)
c0104fa9:	e8 88 b4 ff ff       	call   c0100436 <__panic>

    assert((p0 = alloc_page()) != NULL);
c0104fae:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104fb5:	e8 5c df ff ff       	call   c0102f16 <alloc_pages>
c0104fba:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104fbd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0104fc1:	75 24                	jne    c0104fe7 <basic_check+0x35a>
c0104fc3:	c7 44 24 0c 5d af 10 	movl   $0xc010af5d,0xc(%esp)
c0104fca:	c0 
c0104fcb:	c7 44 24 08 ce ae 10 	movl   $0xc010aece,0x8(%esp)
c0104fd2:	c0 
c0104fd3:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
c0104fda:	00 
c0104fdb:	c7 04 24 e3 ae 10 c0 	movl   $0xc010aee3,(%esp)
c0104fe2:	e8 4f b4 ff ff       	call   c0100436 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0104fe7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104fee:	e8 23 df ff ff       	call   c0102f16 <alloc_pages>
c0104ff3:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104ff6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104ffa:	75 24                	jne    c0105020 <basic_check+0x393>
c0104ffc:	c7 44 24 0c 79 af 10 	movl   $0xc010af79,0xc(%esp)
c0105003:	c0 
c0105004:	c7 44 24 08 ce ae 10 	movl   $0xc010aece,0x8(%esp)
c010500b:	c0 
c010500c:	c7 44 24 04 e3 00 00 	movl   $0xe3,0x4(%esp)
c0105013:	00 
c0105014:	c7 04 24 e3 ae 10 c0 	movl   $0xc010aee3,(%esp)
c010501b:	e8 16 b4 ff ff       	call   c0100436 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0105020:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105027:	e8 ea de ff ff       	call   c0102f16 <alloc_pages>
c010502c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010502f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105033:	75 24                	jne    c0105059 <basic_check+0x3cc>
c0105035:	c7 44 24 0c 95 af 10 	movl   $0xc010af95,0xc(%esp)
c010503c:	c0 
c010503d:	c7 44 24 08 ce ae 10 	movl   $0xc010aece,0x8(%esp)
c0105044:	c0 
c0105045:	c7 44 24 04 e4 00 00 	movl   $0xe4,0x4(%esp)
c010504c:	00 
c010504d:	c7 04 24 e3 ae 10 c0 	movl   $0xc010aee3,(%esp)
c0105054:	e8 dd b3 ff ff       	call   c0100436 <__panic>

    assert(alloc_page() == NULL);
c0105059:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105060:	e8 b1 de ff ff       	call   c0102f16 <alloc_pages>
c0105065:	85 c0                	test   %eax,%eax
c0105067:	74 24                	je     c010508d <basic_check+0x400>
c0105069:	c7 44 24 0c 82 b0 10 	movl   $0xc010b082,0xc(%esp)
c0105070:	c0 
c0105071:	c7 44 24 08 ce ae 10 	movl   $0xc010aece,0x8(%esp)
c0105078:	c0 
c0105079:	c7 44 24 04 e6 00 00 	movl   $0xe6,0x4(%esp)
c0105080:	00 
c0105081:	c7 04 24 e3 ae 10 c0 	movl   $0xc010aee3,(%esp)
c0105088:	e8 a9 b3 ff ff       	call   c0100436 <__panic>

    free_page(p0);
c010508d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105094:	00 
c0105095:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105098:	89 04 24             	mov    %eax,(%esp)
c010509b:	e8 b2 de ff ff       	call   c0102f52 <free_pages>
c01050a0:	c7 45 d8 38 3f 12 c0 	movl   $0xc0123f38,-0x28(%ebp)
c01050a7:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01050aa:	8b 40 04             	mov    0x4(%eax),%eax
c01050ad:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c01050b0:	0f 94 c0             	sete   %al
c01050b3:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c01050b6:	85 c0                	test   %eax,%eax
c01050b8:	74 24                	je     c01050de <basic_check+0x451>
c01050ba:	c7 44 24 0c a4 b0 10 	movl   $0xc010b0a4,0xc(%esp)
c01050c1:	c0 
c01050c2:	c7 44 24 08 ce ae 10 	movl   $0xc010aece,0x8(%esp)
c01050c9:	c0 
c01050ca:	c7 44 24 04 e9 00 00 	movl   $0xe9,0x4(%esp)
c01050d1:	00 
c01050d2:	c7 04 24 e3 ae 10 c0 	movl   $0xc010aee3,(%esp)
c01050d9:	e8 58 b3 ff ff       	call   c0100436 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c01050de:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01050e5:	e8 2c de ff ff       	call   c0102f16 <alloc_pages>
c01050ea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01050ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01050f0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01050f3:	74 24                	je     c0105119 <basic_check+0x48c>
c01050f5:	c7 44 24 0c bc b0 10 	movl   $0xc010b0bc,0xc(%esp)
c01050fc:	c0 
c01050fd:	c7 44 24 08 ce ae 10 	movl   $0xc010aece,0x8(%esp)
c0105104:	c0 
c0105105:	c7 44 24 04 ec 00 00 	movl   $0xec,0x4(%esp)
c010510c:	00 
c010510d:	c7 04 24 e3 ae 10 c0 	movl   $0xc010aee3,(%esp)
c0105114:	e8 1d b3 ff ff       	call   c0100436 <__panic>
    assert(alloc_page() == NULL);
c0105119:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105120:	e8 f1 dd ff ff       	call   c0102f16 <alloc_pages>
c0105125:	85 c0                	test   %eax,%eax
c0105127:	74 24                	je     c010514d <basic_check+0x4c0>
c0105129:	c7 44 24 0c 82 b0 10 	movl   $0xc010b082,0xc(%esp)
c0105130:	c0 
c0105131:	c7 44 24 08 ce ae 10 	movl   $0xc010aece,0x8(%esp)
c0105138:	c0 
c0105139:	c7 44 24 04 ed 00 00 	movl   $0xed,0x4(%esp)
c0105140:	00 
c0105141:	c7 04 24 e3 ae 10 c0 	movl   $0xc010aee3,(%esp)
c0105148:	e8 e9 b2 ff ff       	call   c0100436 <__panic>

    assert(nr_free == 0);
c010514d:	a1 40 3f 12 c0       	mov    0xc0123f40,%eax
c0105152:	85 c0                	test   %eax,%eax
c0105154:	74 24                	je     c010517a <basic_check+0x4ed>
c0105156:	c7 44 24 0c d5 b0 10 	movl   $0xc010b0d5,0xc(%esp)
c010515d:	c0 
c010515e:	c7 44 24 08 ce ae 10 	movl   $0xc010aece,0x8(%esp)
c0105165:	c0 
c0105166:	c7 44 24 04 ef 00 00 	movl   $0xef,0x4(%esp)
c010516d:	00 
c010516e:	c7 04 24 e3 ae 10 c0 	movl   $0xc010aee3,(%esp)
c0105175:	e8 bc b2 ff ff       	call   c0100436 <__panic>
    free_list = free_list_store;
c010517a:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010517d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105180:	a3 38 3f 12 c0       	mov    %eax,0xc0123f38
c0105185:	89 15 3c 3f 12 c0    	mov    %edx,0xc0123f3c
    nr_free = nr_free_store;
c010518b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010518e:	a3 40 3f 12 c0       	mov    %eax,0xc0123f40

    free_page(p);
c0105193:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010519a:	00 
c010519b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010519e:	89 04 24             	mov    %eax,(%esp)
c01051a1:	e8 ac dd ff ff       	call   c0102f52 <free_pages>
    free_page(p1);
c01051a6:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01051ad:	00 
c01051ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01051b1:	89 04 24             	mov    %eax,(%esp)
c01051b4:	e8 99 dd ff ff       	call   c0102f52 <free_pages>
    free_page(p2);
c01051b9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01051c0:	00 
c01051c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01051c4:	89 04 24             	mov    %eax,(%esp)
c01051c7:	e8 86 dd ff ff       	call   c0102f52 <free_pages>
}
c01051cc:	90                   	nop
c01051cd:	c9                   	leave  
c01051ce:	c3                   	ret    

c01051cf <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c01051cf:	f3 0f 1e fb          	endbr32 
c01051d3:	55                   	push   %ebp
c01051d4:	89 e5                	mov    %esp,%ebp
c01051d6:	81 ec 98 00 00 00    	sub    $0x98,%esp
    int count = 0, total = 0;
c01051dc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01051e3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c01051ea:	c7 45 ec 38 3f 12 c0 	movl   $0xc0123f38,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c01051f1:	eb 6a                	jmp    c010525d <default_check+0x8e>
        struct Page *p = le2page(le, page_link);
c01051f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01051f6:	83 e8 0c             	sub    $0xc,%eax
c01051f9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        assert(PageProperty(p));
c01051fc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01051ff:	83 c0 04             	add    $0x4,%eax
c0105202:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0105209:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010520c:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010520f:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0105212:	0f a3 10             	bt     %edx,(%eax)
c0105215:	19 c0                	sbb    %eax,%eax
c0105217:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c010521a:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c010521e:	0f 95 c0             	setne  %al
c0105221:	0f b6 c0             	movzbl %al,%eax
c0105224:	85 c0                	test   %eax,%eax
c0105226:	75 24                	jne    c010524c <default_check+0x7d>
c0105228:	c7 44 24 0c e2 b0 10 	movl   $0xc010b0e2,0xc(%esp)
c010522f:	c0 
c0105230:	c7 44 24 08 ce ae 10 	movl   $0xc010aece,0x8(%esp)
c0105237:	c0 
c0105238:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
c010523f:	00 
c0105240:	c7 04 24 e3 ae 10 c0 	movl   $0xc010aee3,(%esp)
c0105247:	e8 ea b1 ff ff       	call   c0100436 <__panic>
        count ++, total += p->property;
c010524c:	ff 45 f4             	incl   -0xc(%ebp)
c010524f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0105252:	8b 50 08             	mov    0x8(%eax),%edx
c0105255:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105258:	01 d0                	add    %edx,%eax
c010525a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010525d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105260:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return listelm->next;
c0105263:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0105266:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c0105269:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010526c:	81 7d ec 38 3f 12 c0 	cmpl   $0xc0123f38,-0x14(%ebp)
c0105273:	0f 85 7a ff ff ff    	jne    c01051f3 <default_check+0x24>
    }
    assert(total == nr_free_pages());
c0105279:	e8 0b dd ff ff       	call   c0102f89 <nr_free_pages>
c010527e:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105281:	39 d0                	cmp    %edx,%eax
c0105283:	74 24                	je     c01052a9 <default_check+0xda>
c0105285:	c7 44 24 0c f2 b0 10 	movl   $0xc010b0f2,0xc(%esp)
c010528c:	c0 
c010528d:	c7 44 24 08 ce ae 10 	movl   $0xc010aece,0x8(%esp)
c0105294:	c0 
c0105295:	c7 44 24 04 03 01 00 	movl   $0x103,0x4(%esp)
c010529c:	00 
c010529d:	c7 04 24 e3 ae 10 c0 	movl   $0xc010aee3,(%esp)
c01052a4:	e8 8d b1 ff ff       	call   c0100436 <__panic>

    basic_check();
c01052a9:	e8 df f9 ff ff       	call   c0104c8d <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c01052ae:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c01052b5:	e8 5c dc ff ff       	call   c0102f16 <alloc_pages>
c01052ba:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(p0 != NULL);
c01052bd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01052c1:	75 24                	jne    c01052e7 <default_check+0x118>
c01052c3:	c7 44 24 0c 0b b1 10 	movl   $0xc010b10b,0xc(%esp)
c01052ca:	c0 
c01052cb:	c7 44 24 08 ce ae 10 	movl   $0xc010aece,0x8(%esp)
c01052d2:	c0 
c01052d3:	c7 44 24 04 08 01 00 	movl   $0x108,0x4(%esp)
c01052da:	00 
c01052db:	c7 04 24 e3 ae 10 c0 	movl   $0xc010aee3,(%esp)
c01052e2:	e8 4f b1 ff ff       	call   c0100436 <__panic>
    assert(!PageProperty(p0));
c01052e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01052ea:	83 c0 04             	add    $0x4,%eax
c01052ed:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c01052f4:	89 45 bc             	mov    %eax,-0x44(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01052f7:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01052fa:	8b 55 c0             	mov    -0x40(%ebp),%edx
c01052fd:	0f a3 10             	bt     %edx,(%eax)
c0105300:	19 c0                	sbb    %eax,%eax
c0105302:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c0105305:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c0105309:	0f 95 c0             	setne  %al
c010530c:	0f b6 c0             	movzbl %al,%eax
c010530f:	85 c0                	test   %eax,%eax
c0105311:	74 24                	je     c0105337 <default_check+0x168>
c0105313:	c7 44 24 0c 16 b1 10 	movl   $0xc010b116,0xc(%esp)
c010531a:	c0 
c010531b:	c7 44 24 08 ce ae 10 	movl   $0xc010aece,0x8(%esp)
c0105322:	c0 
c0105323:	c7 44 24 04 09 01 00 	movl   $0x109,0x4(%esp)
c010532a:	00 
c010532b:	c7 04 24 e3 ae 10 c0 	movl   $0xc010aee3,(%esp)
c0105332:	e8 ff b0 ff ff       	call   c0100436 <__panic>

    list_entry_t free_list_store = free_list;
c0105337:	a1 38 3f 12 c0       	mov    0xc0123f38,%eax
c010533c:	8b 15 3c 3f 12 c0    	mov    0xc0123f3c,%edx
c0105342:	89 45 80             	mov    %eax,-0x80(%ebp)
c0105345:	89 55 84             	mov    %edx,-0x7c(%ebp)
c0105348:	c7 45 b0 38 3f 12 c0 	movl   $0xc0123f38,-0x50(%ebp)
    elm->prev = elm->next = elm;
c010534f:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0105352:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0105355:	89 50 04             	mov    %edx,0x4(%eax)
c0105358:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010535b:	8b 50 04             	mov    0x4(%eax),%edx
c010535e:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0105361:	89 10                	mov    %edx,(%eax)
}
c0105363:	90                   	nop
c0105364:	c7 45 b4 38 3f 12 c0 	movl   $0xc0123f38,-0x4c(%ebp)
    return list->next == list;
c010536b:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c010536e:	8b 40 04             	mov    0x4(%eax),%eax
c0105371:	39 45 b4             	cmp    %eax,-0x4c(%ebp)
c0105374:	0f 94 c0             	sete   %al
c0105377:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c010537a:	85 c0                	test   %eax,%eax
c010537c:	75 24                	jne    c01053a2 <default_check+0x1d3>
c010537e:	c7 44 24 0c 6b b0 10 	movl   $0xc010b06b,0xc(%esp)
c0105385:	c0 
c0105386:	c7 44 24 08 ce ae 10 	movl   $0xc010aece,0x8(%esp)
c010538d:	c0 
c010538e:	c7 44 24 04 0d 01 00 	movl   $0x10d,0x4(%esp)
c0105395:	00 
c0105396:	c7 04 24 e3 ae 10 c0 	movl   $0xc010aee3,(%esp)
c010539d:	e8 94 b0 ff ff       	call   c0100436 <__panic>
    assert(alloc_page() == NULL);
c01053a2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01053a9:	e8 68 db ff ff       	call   c0102f16 <alloc_pages>
c01053ae:	85 c0                	test   %eax,%eax
c01053b0:	74 24                	je     c01053d6 <default_check+0x207>
c01053b2:	c7 44 24 0c 82 b0 10 	movl   $0xc010b082,0xc(%esp)
c01053b9:	c0 
c01053ba:	c7 44 24 08 ce ae 10 	movl   $0xc010aece,0x8(%esp)
c01053c1:	c0 
c01053c2:	c7 44 24 04 0e 01 00 	movl   $0x10e,0x4(%esp)
c01053c9:	00 
c01053ca:	c7 04 24 e3 ae 10 c0 	movl   $0xc010aee3,(%esp)
c01053d1:	e8 60 b0 ff ff       	call   c0100436 <__panic>

    unsigned int nr_free_store = nr_free;
c01053d6:	a1 40 3f 12 c0       	mov    0xc0123f40,%eax
c01053db:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    nr_free = 0;
c01053de:	c7 05 40 3f 12 c0 00 	movl   $0x0,0xc0123f40
c01053e5:	00 00 00 

    free_pages(p0 + 2, 3);
c01053e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01053eb:	83 c0 28             	add    $0x28,%eax
c01053ee:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c01053f5:	00 
c01053f6:	89 04 24             	mov    %eax,(%esp)
c01053f9:	e8 54 db ff ff       	call   c0102f52 <free_pages>
    assert(alloc_pages(4) == NULL);
c01053fe:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c0105405:	e8 0c db ff ff       	call   c0102f16 <alloc_pages>
c010540a:	85 c0                	test   %eax,%eax
c010540c:	74 24                	je     c0105432 <default_check+0x263>
c010540e:	c7 44 24 0c 28 b1 10 	movl   $0xc010b128,0xc(%esp)
c0105415:	c0 
c0105416:	c7 44 24 08 ce ae 10 	movl   $0xc010aece,0x8(%esp)
c010541d:	c0 
c010541e:	c7 44 24 04 14 01 00 	movl   $0x114,0x4(%esp)
c0105425:	00 
c0105426:	c7 04 24 e3 ae 10 c0 	movl   $0xc010aee3,(%esp)
c010542d:	e8 04 b0 ff ff       	call   c0100436 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c0105432:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105435:	83 c0 28             	add    $0x28,%eax
c0105438:	83 c0 04             	add    $0x4,%eax
c010543b:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c0105442:	89 45 a8             	mov    %eax,-0x58(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0105445:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0105448:	8b 55 ac             	mov    -0x54(%ebp),%edx
c010544b:	0f a3 10             	bt     %edx,(%eax)
c010544e:	19 c0                	sbb    %eax,%eax
c0105450:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c0105453:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c0105457:	0f 95 c0             	setne  %al
c010545a:	0f b6 c0             	movzbl %al,%eax
c010545d:	85 c0                	test   %eax,%eax
c010545f:	74 0e                	je     c010546f <default_check+0x2a0>
c0105461:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105464:	83 c0 28             	add    $0x28,%eax
c0105467:	8b 40 08             	mov    0x8(%eax),%eax
c010546a:	83 f8 03             	cmp    $0x3,%eax
c010546d:	74 24                	je     c0105493 <default_check+0x2c4>
c010546f:	c7 44 24 0c 40 b1 10 	movl   $0xc010b140,0xc(%esp)
c0105476:	c0 
c0105477:	c7 44 24 08 ce ae 10 	movl   $0xc010aece,0x8(%esp)
c010547e:	c0 
c010547f:	c7 44 24 04 15 01 00 	movl   $0x115,0x4(%esp)
c0105486:	00 
c0105487:	c7 04 24 e3 ae 10 c0 	movl   $0xc010aee3,(%esp)
c010548e:	e8 a3 af ff ff       	call   c0100436 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c0105493:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
c010549a:	e8 77 da ff ff       	call   c0102f16 <alloc_pages>
c010549f:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01054a2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c01054a6:	75 24                	jne    c01054cc <default_check+0x2fd>
c01054a8:	c7 44 24 0c 6c b1 10 	movl   $0xc010b16c,0xc(%esp)
c01054af:	c0 
c01054b0:	c7 44 24 08 ce ae 10 	movl   $0xc010aece,0x8(%esp)
c01054b7:	c0 
c01054b8:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
c01054bf:	00 
c01054c0:	c7 04 24 e3 ae 10 c0 	movl   $0xc010aee3,(%esp)
c01054c7:	e8 6a af ff ff       	call   c0100436 <__panic>
    assert(alloc_page() == NULL);
c01054cc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01054d3:	e8 3e da ff ff       	call   c0102f16 <alloc_pages>
c01054d8:	85 c0                	test   %eax,%eax
c01054da:	74 24                	je     c0105500 <default_check+0x331>
c01054dc:	c7 44 24 0c 82 b0 10 	movl   $0xc010b082,0xc(%esp)
c01054e3:	c0 
c01054e4:	c7 44 24 08 ce ae 10 	movl   $0xc010aece,0x8(%esp)
c01054eb:	c0 
c01054ec:	c7 44 24 04 17 01 00 	movl   $0x117,0x4(%esp)
c01054f3:	00 
c01054f4:	c7 04 24 e3 ae 10 c0 	movl   $0xc010aee3,(%esp)
c01054fb:	e8 36 af ff ff       	call   c0100436 <__panic>
    assert(p0 + 2 == p1);
c0105500:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105503:	83 c0 28             	add    $0x28,%eax
c0105506:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c0105509:	74 24                	je     c010552f <default_check+0x360>
c010550b:	c7 44 24 0c 8a b1 10 	movl   $0xc010b18a,0xc(%esp)
c0105512:	c0 
c0105513:	c7 44 24 08 ce ae 10 	movl   $0xc010aece,0x8(%esp)
c010551a:	c0 
c010551b:	c7 44 24 04 18 01 00 	movl   $0x118,0x4(%esp)
c0105522:	00 
c0105523:	c7 04 24 e3 ae 10 c0 	movl   $0xc010aee3,(%esp)
c010552a:	e8 07 af ff ff       	call   c0100436 <__panic>

    p2 = p0 + 1;
c010552f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105532:	83 c0 14             	add    $0x14,%eax
c0105535:	89 45 dc             	mov    %eax,-0x24(%ebp)
    free_page(p0);
c0105538:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010553f:	00 
c0105540:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105543:	89 04 24             	mov    %eax,(%esp)
c0105546:	e8 07 da ff ff       	call   c0102f52 <free_pages>
    free_pages(p1, 3);
c010554b:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0105552:	00 
c0105553:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105556:	89 04 24             	mov    %eax,(%esp)
c0105559:	e8 f4 d9 ff ff       	call   c0102f52 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
c010555e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105561:	83 c0 04             	add    $0x4,%eax
c0105564:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c010556b:	89 45 9c             	mov    %eax,-0x64(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010556e:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0105571:	8b 55 a0             	mov    -0x60(%ebp),%edx
c0105574:	0f a3 10             	bt     %edx,(%eax)
c0105577:	19 c0                	sbb    %eax,%eax
c0105579:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c010557c:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c0105580:	0f 95 c0             	setne  %al
c0105583:	0f b6 c0             	movzbl %al,%eax
c0105586:	85 c0                	test   %eax,%eax
c0105588:	74 0b                	je     c0105595 <default_check+0x3c6>
c010558a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010558d:	8b 40 08             	mov    0x8(%eax),%eax
c0105590:	83 f8 01             	cmp    $0x1,%eax
c0105593:	74 24                	je     c01055b9 <default_check+0x3ea>
c0105595:	c7 44 24 0c 98 b1 10 	movl   $0xc010b198,0xc(%esp)
c010559c:	c0 
c010559d:	c7 44 24 08 ce ae 10 	movl   $0xc010aece,0x8(%esp)
c01055a4:	c0 
c01055a5:	c7 44 24 04 1d 01 00 	movl   $0x11d,0x4(%esp)
c01055ac:	00 
c01055ad:	c7 04 24 e3 ae 10 c0 	movl   $0xc010aee3,(%esp)
c01055b4:	e8 7d ae ff ff       	call   c0100436 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c01055b9:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01055bc:	83 c0 04             	add    $0x4,%eax
c01055bf:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c01055c6:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01055c9:	8b 45 90             	mov    -0x70(%ebp),%eax
c01055cc:	8b 55 94             	mov    -0x6c(%ebp),%edx
c01055cf:	0f a3 10             	bt     %edx,(%eax)
c01055d2:	19 c0                	sbb    %eax,%eax
c01055d4:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c01055d7:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c01055db:	0f 95 c0             	setne  %al
c01055de:	0f b6 c0             	movzbl %al,%eax
c01055e1:	85 c0                	test   %eax,%eax
c01055e3:	74 0b                	je     c01055f0 <default_check+0x421>
c01055e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01055e8:	8b 40 08             	mov    0x8(%eax),%eax
c01055eb:	83 f8 03             	cmp    $0x3,%eax
c01055ee:	74 24                	je     c0105614 <default_check+0x445>
c01055f0:	c7 44 24 0c c0 b1 10 	movl   $0xc010b1c0,0xc(%esp)
c01055f7:	c0 
c01055f8:	c7 44 24 08 ce ae 10 	movl   $0xc010aece,0x8(%esp)
c01055ff:	c0 
c0105600:	c7 44 24 04 1e 01 00 	movl   $0x11e,0x4(%esp)
c0105607:	00 
c0105608:	c7 04 24 e3 ae 10 c0 	movl   $0xc010aee3,(%esp)
c010560f:	e8 22 ae ff ff       	call   c0100436 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c0105614:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010561b:	e8 f6 d8 ff ff       	call   c0102f16 <alloc_pages>
c0105620:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105623:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105626:	83 e8 14             	sub    $0x14,%eax
c0105629:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c010562c:	74 24                	je     c0105652 <default_check+0x483>
c010562e:	c7 44 24 0c e6 b1 10 	movl   $0xc010b1e6,0xc(%esp)
c0105635:	c0 
c0105636:	c7 44 24 08 ce ae 10 	movl   $0xc010aece,0x8(%esp)
c010563d:	c0 
c010563e:	c7 44 24 04 20 01 00 	movl   $0x120,0x4(%esp)
c0105645:	00 
c0105646:	c7 04 24 e3 ae 10 c0 	movl   $0xc010aee3,(%esp)
c010564d:	e8 e4 ad ff ff       	call   c0100436 <__panic>
    free_page(p0);
c0105652:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105659:	00 
c010565a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010565d:	89 04 24             	mov    %eax,(%esp)
c0105660:	e8 ed d8 ff ff       	call   c0102f52 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
c0105665:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c010566c:	e8 a5 d8 ff ff       	call   c0102f16 <alloc_pages>
c0105671:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105674:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105677:	83 c0 14             	add    $0x14,%eax
c010567a:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c010567d:	74 24                	je     c01056a3 <default_check+0x4d4>
c010567f:	c7 44 24 0c 04 b2 10 	movl   $0xc010b204,0xc(%esp)
c0105686:	c0 
c0105687:	c7 44 24 08 ce ae 10 	movl   $0xc010aece,0x8(%esp)
c010568e:	c0 
c010568f:	c7 44 24 04 22 01 00 	movl   $0x122,0x4(%esp)
c0105696:	00 
c0105697:	c7 04 24 e3 ae 10 c0 	movl   $0xc010aee3,(%esp)
c010569e:	e8 93 ad ff ff       	call   c0100436 <__panic>

    free_pages(p0, 2);
c01056a3:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c01056aa:	00 
c01056ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01056ae:	89 04 24             	mov    %eax,(%esp)
c01056b1:	e8 9c d8 ff ff       	call   c0102f52 <free_pages>
    free_page(p2);
c01056b6:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01056bd:	00 
c01056be:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01056c1:	89 04 24             	mov    %eax,(%esp)
c01056c4:	e8 89 d8 ff ff       	call   c0102f52 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
c01056c9:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c01056d0:	e8 41 d8 ff ff       	call   c0102f16 <alloc_pages>
c01056d5:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01056d8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01056dc:	75 24                	jne    c0105702 <default_check+0x533>
c01056de:	c7 44 24 0c 24 b2 10 	movl   $0xc010b224,0xc(%esp)
c01056e5:	c0 
c01056e6:	c7 44 24 08 ce ae 10 	movl   $0xc010aece,0x8(%esp)
c01056ed:	c0 
c01056ee:	c7 44 24 04 27 01 00 	movl   $0x127,0x4(%esp)
c01056f5:	00 
c01056f6:	c7 04 24 e3 ae 10 c0 	movl   $0xc010aee3,(%esp)
c01056fd:	e8 34 ad ff ff       	call   c0100436 <__panic>
    assert(alloc_page() == NULL);
c0105702:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105709:	e8 08 d8 ff ff       	call   c0102f16 <alloc_pages>
c010570e:	85 c0                	test   %eax,%eax
c0105710:	74 24                	je     c0105736 <default_check+0x567>
c0105712:	c7 44 24 0c 82 b0 10 	movl   $0xc010b082,0xc(%esp)
c0105719:	c0 
c010571a:	c7 44 24 08 ce ae 10 	movl   $0xc010aece,0x8(%esp)
c0105721:	c0 
c0105722:	c7 44 24 04 28 01 00 	movl   $0x128,0x4(%esp)
c0105729:	00 
c010572a:	c7 04 24 e3 ae 10 c0 	movl   $0xc010aee3,(%esp)
c0105731:	e8 00 ad ff ff       	call   c0100436 <__panic>

    assert(nr_free == 0);
c0105736:	a1 40 3f 12 c0       	mov    0xc0123f40,%eax
c010573b:	85 c0                	test   %eax,%eax
c010573d:	74 24                	je     c0105763 <default_check+0x594>
c010573f:	c7 44 24 0c d5 b0 10 	movl   $0xc010b0d5,0xc(%esp)
c0105746:	c0 
c0105747:	c7 44 24 08 ce ae 10 	movl   $0xc010aece,0x8(%esp)
c010574e:	c0 
c010574f:	c7 44 24 04 2a 01 00 	movl   $0x12a,0x4(%esp)
c0105756:	00 
c0105757:	c7 04 24 e3 ae 10 c0 	movl   $0xc010aee3,(%esp)
c010575e:	e8 d3 ac ff ff       	call   c0100436 <__panic>
    nr_free = nr_free_store;
c0105763:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105766:	a3 40 3f 12 c0       	mov    %eax,0xc0123f40

    free_list = free_list_store;
c010576b:	8b 45 80             	mov    -0x80(%ebp),%eax
c010576e:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0105771:	a3 38 3f 12 c0       	mov    %eax,0xc0123f38
c0105776:	89 15 3c 3f 12 c0    	mov    %edx,0xc0123f3c
    free_pages(p0, 5);
c010577c:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
c0105783:	00 
c0105784:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105787:	89 04 24             	mov    %eax,(%esp)
c010578a:	e8 c3 d7 ff ff       	call   c0102f52 <free_pages>

    le = &free_list;
c010578f:	c7 45 ec 38 3f 12 c0 	movl   $0xc0123f38,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0105796:	eb 5a                	jmp    c01057f2 <default_check+0x623>
        assert(le->next->prev == le && le->prev->next == le);
c0105798:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010579b:	8b 40 04             	mov    0x4(%eax),%eax
c010579e:	8b 00                	mov    (%eax),%eax
c01057a0:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c01057a3:	75 0d                	jne    c01057b2 <default_check+0x5e3>
c01057a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01057a8:	8b 00                	mov    (%eax),%eax
c01057aa:	8b 40 04             	mov    0x4(%eax),%eax
c01057ad:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c01057b0:	74 24                	je     c01057d6 <default_check+0x607>
c01057b2:	c7 44 24 0c 44 b2 10 	movl   $0xc010b244,0xc(%esp)
c01057b9:	c0 
c01057ba:	c7 44 24 08 ce ae 10 	movl   $0xc010aece,0x8(%esp)
c01057c1:	c0 
c01057c2:	c7 44 24 04 32 01 00 	movl   $0x132,0x4(%esp)
c01057c9:	00 
c01057ca:	c7 04 24 e3 ae 10 c0 	movl   $0xc010aee3,(%esp)
c01057d1:	e8 60 ac ff ff       	call   c0100436 <__panic>
        struct Page *p = le2page(le, page_link);
c01057d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01057d9:	83 e8 0c             	sub    $0xc,%eax
c01057dc:	89 45 d8             	mov    %eax,-0x28(%ebp)
        count --, total -= p->property;
c01057df:	ff 4d f4             	decl   -0xc(%ebp)
c01057e2:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01057e5:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01057e8:	8b 40 08             	mov    0x8(%eax),%eax
c01057eb:	29 c2                	sub    %eax,%edx
c01057ed:	89 d0                	mov    %edx,%eax
c01057ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01057f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01057f5:	89 45 88             	mov    %eax,-0x78(%ebp)
    return listelm->next;
c01057f8:	8b 45 88             	mov    -0x78(%ebp),%eax
c01057fb:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c01057fe:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105801:	81 7d ec 38 3f 12 c0 	cmpl   $0xc0123f38,-0x14(%ebp)
c0105808:	75 8e                	jne    c0105798 <default_check+0x5c9>
    }
    assert(count == 0);
c010580a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010580e:	74 24                	je     c0105834 <default_check+0x665>
c0105810:	c7 44 24 0c 71 b2 10 	movl   $0xc010b271,0xc(%esp)
c0105817:	c0 
c0105818:	c7 44 24 08 ce ae 10 	movl   $0xc010aece,0x8(%esp)
c010581f:	c0 
c0105820:	c7 44 24 04 36 01 00 	movl   $0x136,0x4(%esp)
c0105827:	00 
c0105828:	c7 04 24 e3 ae 10 c0 	movl   $0xc010aee3,(%esp)
c010582f:	e8 02 ac ff ff       	call   c0100436 <__panic>
    assert(total == 0);
c0105834:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105838:	74 24                	je     c010585e <default_check+0x68f>
c010583a:	c7 44 24 0c 7c b2 10 	movl   $0xc010b27c,0xc(%esp)
c0105841:	c0 
c0105842:	c7 44 24 08 ce ae 10 	movl   $0xc010aece,0x8(%esp)
c0105849:	c0 
c010584a:	c7 44 24 04 37 01 00 	movl   $0x137,0x4(%esp)
c0105851:	00 
c0105852:	c7 04 24 e3 ae 10 c0 	movl   $0xc010aee3,(%esp)
c0105859:	e8 d8 ab ff ff       	call   c0100436 <__panic>
}
c010585e:	90                   	nop
c010585f:	c9                   	leave  
c0105860:	c3                   	ret    

c0105861 <page2ppn>:
page2ppn(struct Page *page) {
c0105861:	55                   	push   %ebp
c0105862:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0105864:	a1 34 3f 12 c0       	mov    0xc0123f34,%eax
c0105869:	8b 55 08             	mov    0x8(%ebp),%edx
c010586c:	29 c2                	sub    %eax,%edx
c010586e:	89 d0                	mov    %edx,%eax
c0105870:	c1 f8 02             	sar    $0x2,%eax
c0105873:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c0105879:	5d                   	pop    %ebp
c010587a:	c3                   	ret    

c010587b <page2pa>:
page2pa(struct Page *page) {
c010587b:	55                   	push   %ebp
c010587c:	89 e5                	mov    %esp,%ebp
c010587e:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0105881:	8b 45 08             	mov    0x8(%ebp),%eax
c0105884:	89 04 24             	mov    %eax,(%esp)
c0105887:	e8 d5 ff ff ff       	call   c0105861 <page2ppn>
c010588c:	c1 e0 0c             	shl    $0xc,%eax
}
c010588f:	c9                   	leave  
c0105890:	c3                   	ret    

c0105891 <page_ref>:
page_ref(struct Page *page) {
c0105891:	55                   	push   %ebp
c0105892:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0105894:	8b 45 08             	mov    0x8(%ebp),%eax
c0105897:	8b 00                	mov    (%eax),%eax
}
c0105899:	5d                   	pop    %ebp
c010589a:	c3                   	ret    

c010589b <set_page_ref>:
set_page_ref(struct Page *page, int val) {
c010589b:	55                   	push   %ebp
c010589c:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c010589e:	8b 45 08             	mov    0x8(%ebp),%eax
c01058a1:	8b 55 0c             	mov    0xc(%ebp),%edx
c01058a4:	89 10                	mov    %edx,(%eax)
}
c01058a6:	90                   	nop
c01058a7:	5d                   	pop    %ebp
c01058a8:	c3                   	ret    

c01058a9 <buddy_init_size>:
#define UINT32_REMAINDER(a)     ((a)&(UINT32_MASK(a)>>1))
#define UINT32_ROUND_UP(a)      (UINT32_REMAINDER(a)?(((a)-UINT32_REMAINDER(a))<<1):(a))
#define UINT32_ROUND_DOWN(a)    (UINT32_REMAINDER(a)?((a)-UINT32_REMAINDER(a)):(a))

static void
buddy_init_size(size_t n) {
c01058a9:	f3 0f 1e fb          	endbr32 
c01058ad:	55                   	push   %ebp
c01058ae:	89 e5                	mov    %esp,%ebp
c01058b0:	57                   	push   %edi
c01058b1:	56                   	push   %esi
c01058b2:	53                   	push   %ebx
c01058b3:	83 ec 2c             	sub    $0x2c,%esp
    assert(n > 1);
c01058b6:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
c01058ba:	77 24                	ja     c01058e0 <buddy_init_size+0x37>
c01058bc:	c7 44 24 0c b8 b2 10 	movl   $0xc010b2b8,0xc(%esp)
c01058c3:	c0 
c01058c4:	c7 44 24 08 be b2 10 	movl   $0xc010b2be,0x8(%esp)
c01058cb:	c0 
c01058cc:	c7 44 24 04 2b 00 00 	movl   $0x2b,0x4(%esp)
c01058d3:	00 
c01058d4:	c7 04 24 d3 b2 10 c0 	movl   $0xc010b2d3,(%esp)
c01058db:	e8 56 ab ff ff       	call   c0100436 <__panic>
    buddy_physical_size = n;
c01058e0:	8b 45 08             	mov    0x8(%ebp),%eax
c01058e3:	a3 0c 3f 12 c0       	mov    %eax,0xc0123f0c
    if (n < 512) {
c01058e8:	81 7d 08 ff 01 00 00 	cmpl   $0x1ff,0x8(%ebp)
c01058ef:	0f 87 98 02 00 00    	ja     c0105b8d <buddy_init_size+0x2e4>
        buddy_virtual_size = UINT32_ROUND_UP(n-1);
c01058f5:	8b 45 08             	mov    0x8(%ebp),%eax
c01058f8:	8d 78 ff             	lea    -0x1(%eax),%edi
c01058fb:	8b 45 08             	mov    0x8(%ebp),%eax
c01058fe:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105901:	8b 45 08             	mov    0x8(%ebp),%eax
c0105904:	48                   	dec    %eax
c0105905:	d1 e8                	shr    %eax
c0105907:	09 c2                	or     %eax,%edx
c0105909:	8b 45 08             	mov    0x8(%ebp),%eax
c010590c:	8d 48 ff             	lea    -0x1(%eax),%ecx
c010590f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105912:	48                   	dec    %eax
c0105913:	d1 e8                	shr    %eax
c0105915:	09 c8                	or     %ecx,%eax
c0105917:	c1 e8 02             	shr    $0x2,%eax
c010591a:	09 c2                	or     %eax,%edx
c010591c:	8b 45 08             	mov    0x8(%ebp),%eax
c010591f:	8d 48 ff             	lea    -0x1(%eax),%ecx
c0105922:	8b 45 08             	mov    0x8(%ebp),%eax
c0105925:	48                   	dec    %eax
c0105926:	d1 e8                	shr    %eax
c0105928:	09 c1                	or     %eax,%ecx
c010592a:	8b 45 08             	mov    0x8(%ebp),%eax
c010592d:	8d 58 ff             	lea    -0x1(%eax),%ebx
c0105930:	8b 45 08             	mov    0x8(%ebp),%eax
c0105933:	48                   	dec    %eax
c0105934:	d1 e8                	shr    %eax
c0105936:	09 d8                	or     %ebx,%eax
c0105938:	c1 e8 02             	shr    $0x2,%eax
c010593b:	09 c8                	or     %ecx,%eax
c010593d:	c1 e8 04             	shr    $0x4,%eax
c0105940:	09 c2                	or     %eax,%edx
c0105942:	8b 45 08             	mov    0x8(%ebp),%eax
c0105945:	8d 48 ff             	lea    -0x1(%eax),%ecx
c0105948:	8b 45 08             	mov    0x8(%ebp),%eax
c010594b:	48                   	dec    %eax
c010594c:	d1 e8                	shr    %eax
c010594e:	09 c1                	or     %eax,%ecx
c0105950:	8b 45 08             	mov    0x8(%ebp),%eax
c0105953:	8d 58 ff             	lea    -0x1(%eax),%ebx
c0105956:	8b 45 08             	mov    0x8(%ebp),%eax
c0105959:	48                   	dec    %eax
c010595a:	d1 e8                	shr    %eax
c010595c:	09 d8                	or     %ebx,%eax
c010595e:	c1 e8 02             	shr    $0x2,%eax
c0105961:	09 c1                	or     %eax,%ecx
c0105963:	8b 45 08             	mov    0x8(%ebp),%eax
c0105966:	8d 58 ff             	lea    -0x1(%eax),%ebx
c0105969:	8b 45 08             	mov    0x8(%ebp),%eax
c010596c:	48                   	dec    %eax
c010596d:	d1 e8                	shr    %eax
c010596f:	09 c3                	or     %eax,%ebx
c0105971:	8b 45 08             	mov    0x8(%ebp),%eax
c0105974:	8d 70 ff             	lea    -0x1(%eax),%esi
c0105977:	8b 45 08             	mov    0x8(%ebp),%eax
c010597a:	48                   	dec    %eax
c010597b:	d1 e8                	shr    %eax
c010597d:	09 f0                	or     %esi,%eax
c010597f:	c1 e8 02             	shr    $0x2,%eax
c0105982:	09 d8                	or     %ebx,%eax
c0105984:	c1 e8 04             	shr    $0x4,%eax
c0105987:	09 c8                	or     %ecx,%eax
c0105989:	c1 e8 08             	shr    $0x8,%eax
c010598c:	89 d6                	mov    %edx,%esi
c010598e:	09 c6                	or     %eax,%esi
c0105990:	8b 45 08             	mov    0x8(%ebp),%eax
c0105993:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105996:	8b 45 08             	mov    0x8(%ebp),%eax
c0105999:	48                   	dec    %eax
c010599a:	d1 e8                	shr    %eax
c010599c:	09 c2                	or     %eax,%edx
c010599e:	8b 45 08             	mov    0x8(%ebp),%eax
c01059a1:	8d 48 ff             	lea    -0x1(%eax),%ecx
c01059a4:	8b 45 08             	mov    0x8(%ebp),%eax
c01059a7:	48                   	dec    %eax
c01059a8:	d1 e8                	shr    %eax
c01059aa:	09 c8                	or     %ecx,%eax
c01059ac:	c1 e8 02             	shr    $0x2,%eax
c01059af:	09 c2                	or     %eax,%edx
c01059b1:	8b 45 08             	mov    0x8(%ebp),%eax
c01059b4:	8d 48 ff             	lea    -0x1(%eax),%ecx
c01059b7:	8b 45 08             	mov    0x8(%ebp),%eax
c01059ba:	48                   	dec    %eax
c01059bb:	d1 e8                	shr    %eax
c01059bd:	09 c1                	or     %eax,%ecx
c01059bf:	8b 45 08             	mov    0x8(%ebp),%eax
c01059c2:	8d 58 ff             	lea    -0x1(%eax),%ebx
c01059c5:	8b 45 08             	mov    0x8(%ebp),%eax
c01059c8:	48                   	dec    %eax
c01059c9:	d1 e8                	shr    %eax
c01059cb:	09 d8                	or     %ebx,%eax
c01059cd:	c1 e8 02             	shr    $0x2,%eax
c01059d0:	09 c8                	or     %ecx,%eax
c01059d2:	c1 e8 04             	shr    $0x4,%eax
c01059d5:	89 d3                	mov    %edx,%ebx
c01059d7:	09 c3                	or     %eax,%ebx
c01059d9:	8b 45 08             	mov    0x8(%ebp),%eax
c01059dc:	8d 50 ff             	lea    -0x1(%eax),%edx
c01059df:	8b 45 08             	mov    0x8(%ebp),%eax
c01059e2:	48                   	dec    %eax
c01059e3:	d1 e8                	shr    %eax
c01059e5:	09 c2                	or     %eax,%edx
c01059e7:	8b 45 08             	mov    0x8(%ebp),%eax
c01059ea:	8d 48 ff             	lea    -0x1(%eax),%ecx
c01059ed:	8b 45 08             	mov    0x8(%ebp),%eax
c01059f0:	48                   	dec    %eax
c01059f1:	d1 e8                	shr    %eax
c01059f3:	09 c8                	or     %ecx,%eax
c01059f5:	c1 e8 02             	shr    $0x2,%eax
c01059f8:	89 d1                	mov    %edx,%ecx
c01059fa:	09 c1                	or     %eax,%ecx
c01059fc:	8b 45 08             	mov    0x8(%ebp),%eax
c01059ff:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105a02:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a05:	48                   	dec    %eax
c0105a06:	d1 e8                	shr    %eax
c0105a08:	09 c2                	or     %eax,%edx
c0105a0a:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a0d:	48                   	dec    %eax
c0105a0e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105a11:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a14:	48                   	dec    %eax
c0105a15:	d1 e8                	shr    %eax
c0105a17:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0105a1a:	c1 e8 02             	shr    $0x2,%eax
c0105a1d:	09 d0                	or     %edx,%eax
c0105a1f:	c1 e8 04             	shr    $0x4,%eax
c0105a22:	09 c8                	or     %ecx,%eax
c0105a24:	c1 e8 08             	shr    $0x8,%eax
c0105a27:	09 d8                	or     %ebx,%eax
c0105a29:	c1 e8 10             	shr    $0x10,%eax
c0105a2c:	09 f0                	or     %esi,%eax
c0105a2e:	d1 e8                	shr    %eax
c0105a30:	21 f8                	and    %edi,%eax
c0105a32:	85 c0                	test   %eax,%eax
c0105a34:	0f 84 3b 01 00 00    	je     c0105b75 <buddy_init_size+0x2cc>
c0105a3a:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a3d:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105a40:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a43:	48                   	dec    %eax
c0105a44:	d1 e8                	shr    %eax
c0105a46:	09 c2                	or     %eax,%edx
c0105a48:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a4b:	8d 48 ff             	lea    -0x1(%eax),%ecx
c0105a4e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a51:	48                   	dec    %eax
c0105a52:	d1 e8                	shr    %eax
c0105a54:	09 c8                	or     %ecx,%eax
c0105a56:	c1 e8 02             	shr    $0x2,%eax
c0105a59:	09 c2                	or     %eax,%edx
c0105a5b:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a5e:	8d 48 ff             	lea    -0x1(%eax),%ecx
c0105a61:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a64:	48                   	dec    %eax
c0105a65:	d1 e8                	shr    %eax
c0105a67:	09 c1                	or     %eax,%ecx
c0105a69:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a6c:	8d 58 ff             	lea    -0x1(%eax),%ebx
c0105a6f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a72:	48                   	dec    %eax
c0105a73:	d1 e8                	shr    %eax
c0105a75:	09 d8                	or     %ebx,%eax
c0105a77:	c1 e8 02             	shr    $0x2,%eax
c0105a7a:	09 c8                	or     %ecx,%eax
c0105a7c:	c1 e8 04             	shr    $0x4,%eax
c0105a7f:	09 c2                	or     %eax,%edx
c0105a81:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a84:	8d 48 ff             	lea    -0x1(%eax),%ecx
c0105a87:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a8a:	48                   	dec    %eax
c0105a8b:	d1 e8                	shr    %eax
c0105a8d:	09 c1                	or     %eax,%ecx
c0105a8f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a92:	8d 58 ff             	lea    -0x1(%eax),%ebx
c0105a95:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a98:	48                   	dec    %eax
c0105a99:	d1 e8                	shr    %eax
c0105a9b:	09 d8                	or     %ebx,%eax
c0105a9d:	c1 e8 02             	shr    $0x2,%eax
c0105aa0:	09 c1                	or     %eax,%ecx
c0105aa2:	8b 45 08             	mov    0x8(%ebp),%eax
c0105aa5:	8d 58 ff             	lea    -0x1(%eax),%ebx
c0105aa8:	8b 45 08             	mov    0x8(%ebp),%eax
c0105aab:	48                   	dec    %eax
c0105aac:	d1 e8                	shr    %eax
c0105aae:	09 c3                	or     %eax,%ebx
c0105ab0:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ab3:	8d 70 ff             	lea    -0x1(%eax),%esi
c0105ab6:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ab9:	48                   	dec    %eax
c0105aba:	d1 e8                	shr    %eax
c0105abc:	09 f0                	or     %esi,%eax
c0105abe:	c1 e8 02             	shr    $0x2,%eax
c0105ac1:	09 d8                	or     %ebx,%eax
c0105ac3:	c1 e8 04             	shr    $0x4,%eax
c0105ac6:	09 c8                	or     %ecx,%eax
c0105ac8:	c1 e8 08             	shr    $0x8,%eax
c0105acb:	09 c2                	or     %eax,%edx
c0105acd:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ad0:	8d 48 ff             	lea    -0x1(%eax),%ecx
c0105ad3:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ad6:	48                   	dec    %eax
c0105ad7:	d1 e8                	shr    %eax
c0105ad9:	09 c1                	or     %eax,%ecx
c0105adb:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ade:	8d 58 ff             	lea    -0x1(%eax),%ebx
c0105ae1:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ae4:	48                   	dec    %eax
c0105ae5:	d1 e8                	shr    %eax
c0105ae7:	09 d8                	or     %ebx,%eax
c0105ae9:	c1 e8 02             	shr    $0x2,%eax
c0105aec:	09 c1                	or     %eax,%ecx
c0105aee:	8b 45 08             	mov    0x8(%ebp),%eax
c0105af1:	8d 58 ff             	lea    -0x1(%eax),%ebx
c0105af4:	8b 45 08             	mov    0x8(%ebp),%eax
c0105af7:	48                   	dec    %eax
c0105af8:	d1 e8                	shr    %eax
c0105afa:	09 c3                	or     %eax,%ebx
c0105afc:	8b 45 08             	mov    0x8(%ebp),%eax
c0105aff:	8d 70 ff             	lea    -0x1(%eax),%esi
c0105b02:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b05:	48                   	dec    %eax
c0105b06:	d1 e8                	shr    %eax
c0105b08:	09 f0                	or     %esi,%eax
c0105b0a:	c1 e8 02             	shr    $0x2,%eax
c0105b0d:	09 d8                	or     %ebx,%eax
c0105b0f:	c1 e8 04             	shr    $0x4,%eax
c0105b12:	09 c1                	or     %eax,%ecx
c0105b14:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b17:	8d 58 ff             	lea    -0x1(%eax),%ebx
c0105b1a:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b1d:	48                   	dec    %eax
c0105b1e:	d1 e8                	shr    %eax
c0105b20:	09 c3                	or     %eax,%ebx
c0105b22:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b25:	8d 70 ff             	lea    -0x1(%eax),%esi
c0105b28:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b2b:	48                   	dec    %eax
c0105b2c:	d1 e8                	shr    %eax
c0105b2e:	09 f0                	or     %esi,%eax
c0105b30:	c1 e8 02             	shr    $0x2,%eax
c0105b33:	09 c3                	or     %eax,%ebx
c0105b35:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b38:	8d 70 ff             	lea    -0x1(%eax),%esi
c0105b3b:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b3e:	48                   	dec    %eax
c0105b3f:	d1 e8                	shr    %eax
c0105b41:	09 c6                	or     %eax,%esi
c0105b43:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b46:	8d 78 ff             	lea    -0x1(%eax),%edi
c0105b49:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b4c:	48                   	dec    %eax
c0105b4d:	d1 e8                	shr    %eax
c0105b4f:	09 f8                	or     %edi,%eax
c0105b51:	c1 e8 02             	shr    $0x2,%eax
c0105b54:	09 f0                	or     %esi,%eax
c0105b56:	c1 e8 04             	shr    $0x4,%eax
c0105b59:	09 d8                	or     %ebx,%eax
c0105b5b:	c1 e8 08             	shr    $0x8,%eax
c0105b5e:	09 c8                	or     %ecx,%eax
c0105b60:	c1 e8 10             	shr    $0x10,%eax
c0105b63:	09 d0                	or     %edx,%eax
c0105b65:	d1 e8                	shr    %eax
c0105b67:	f7 d0                	not    %eax
c0105b69:	89 c2                	mov    %eax,%edx
c0105b6b:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b6e:	48                   	dec    %eax
c0105b6f:	21 d0                	and    %edx,%eax
c0105b71:	01 c0                	add    %eax,%eax
c0105b73:	eb 04                	jmp    c0105b79 <buddy_init_size+0x2d0>
c0105b75:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b78:	48                   	dec    %eax
c0105b79:	a3 10 3f 12 c0       	mov    %eax,0xc0123f10
        buddy_segment_size = 1;
c0105b7e:	c7 05 14 3f 12 c0 01 	movl   $0x1,0xc0123f14
c0105b85:	00 00 00 
c0105b88:	e9 00 02 00 00       	jmp    c0105d8d <buddy_init_size+0x4e4>
    } else {
        buddy_virtual_size = UINT32_ROUND_DOWN(n);
c0105b8d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b90:	d1 e8                	shr    %eax
c0105b92:	0b 45 08             	or     0x8(%ebp),%eax
c0105b95:	8b 55 08             	mov    0x8(%ebp),%edx
c0105b98:	d1 ea                	shr    %edx
c0105b9a:	0b 55 08             	or     0x8(%ebp),%edx
c0105b9d:	c1 ea 02             	shr    $0x2,%edx
c0105ba0:	09 d0                	or     %edx,%eax
c0105ba2:	89 c1                	mov    %eax,%ecx
c0105ba4:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ba7:	d1 e8                	shr    %eax
c0105ba9:	0b 45 08             	or     0x8(%ebp),%eax
c0105bac:	8b 55 08             	mov    0x8(%ebp),%edx
c0105baf:	d1 ea                	shr    %edx
c0105bb1:	0b 55 08             	or     0x8(%ebp),%edx
c0105bb4:	c1 ea 02             	shr    $0x2,%edx
c0105bb7:	09 d0                	or     %edx,%eax
c0105bb9:	c1 e8 04             	shr    $0x4,%eax
c0105bbc:	09 c1                	or     %eax,%ecx
c0105bbe:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bc1:	d1 e8                	shr    %eax
c0105bc3:	0b 45 08             	or     0x8(%ebp),%eax
c0105bc6:	8b 55 08             	mov    0x8(%ebp),%edx
c0105bc9:	d1 ea                	shr    %edx
c0105bcb:	0b 55 08             	or     0x8(%ebp),%edx
c0105bce:	c1 ea 02             	shr    $0x2,%edx
c0105bd1:	09 d0                	or     %edx,%eax
c0105bd3:	89 c3                	mov    %eax,%ebx
c0105bd5:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bd8:	d1 e8                	shr    %eax
c0105bda:	0b 45 08             	or     0x8(%ebp),%eax
c0105bdd:	8b 55 08             	mov    0x8(%ebp),%edx
c0105be0:	d1 ea                	shr    %edx
c0105be2:	0b 55 08             	or     0x8(%ebp),%edx
c0105be5:	c1 ea 02             	shr    $0x2,%edx
c0105be8:	09 d0                	or     %edx,%eax
c0105bea:	c1 e8 04             	shr    $0x4,%eax
c0105bed:	09 d8                	or     %ebx,%eax
c0105bef:	c1 e8 08             	shr    $0x8,%eax
c0105bf2:	09 c1                	or     %eax,%ecx
c0105bf4:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bf7:	d1 e8                	shr    %eax
c0105bf9:	0b 45 08             	or     0x8(%ebp),%eax
c0105bfc:	8b 55 08             	mov    0x8(%ebp),%edx
c0105bff:	d1 ea                	shr    %edx
c0105c01:	0b 55 08             	or     0x8(%ebp),%edx
c0105c04:	c1 ea 02             	shr    $0x2,%edx
c0105c07:	09 d0                	or     %edx,%eax
c0105c09:	89 c3                	mov    %eax,%ebx
c0105c0b:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c0e:	d1 e8                	shr    %eax
c0105c10:	0b 45 08             	or     0x8(%ebp),%eax
c0105c13:	8b 55 08             	mov    0x8(%ebp),%edx
c0105c16:	d1 ea                	shr    %edx
c0105c18:	0b 55 08             	or     0x8(%ebp),%edx
c0105c1b:	c1 ea 02             	shr    $0x2,%edx
c0105c1e:	09 d0                	or     %edx,%eax
c0105c20:	c1 e8 04             	shr    $0x4,%eax
c0105c23:	09 c3                	or     %eax,%ebx
c0105c25:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c28:	d1 e8                	shr    %eax
c0105c2a:	0b 45 08             	or     0x8(%ebp),%eax
c0105c2d:	8b 55 08             	mov    0x8(%ebp),%edx
c0105c30:	d1 ea                	shr    %edx
c0105c32:	0b 55 08             	or     0x8(%ebp),%edx
c0105c35:	c1 ea 02             	shr    $0x2,%edx
c0105c38:	09 d0                	or     %edx,%eax
c0105c3a:	89 c6                	mov    %eax,%esi
c0105c3c:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c3f:	d1 e8                	shr    %eax
c0105c41:	0b 45 08             	or     0x8(%ebp),%eax
c0105c44:	8b 55 08             	mov    0x8(%ebp),%edx
c0105c47:	d1 ea                	shr    %edx
c0105c49:	0b 55 08             	or     0x8(%ebp),%edx
c0105c4c:	c1 ea 02             	shr    $0x2,%edx
c0105c4f:	09 d0                	or     %edx,%eax
c0105c51:	c1 e8 04             	shr    $0x4,%eax
c0105c54:	09 f0                	or     %esi,%eax
c0105c56:	c1 e8 08             	shr    $0x8,%eax
c0105c59:	09 d8                	or     %ebx,%eax
c0105c5b:	c1 e8 10             	shr    $0x10,%eax
c0105c5e:	09 c8                	or     %ecx,%eax
c0105c60:	d1 e8                	shr    %eax
c0105c62:	23 45 08             	and    0x8(%ebp),%eax
c0105c65:	85 c0                	test   %eax,%eax
c0105c67:	0f 84 dc 00 00 00    	je     c0105d49 <buddy_init_size+0x4a0>
c0105c6d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c70:	d1 e8                	shr    %eax
c0105c72:	0b 45 08             	or     0x8(%ebp),%eax
c0105c75:	8b 55 08             	mov    0x8(%ebp),%edx
c0105c78:	d1 ea                	shr    %edx
c0105c7a:	0b 55 08             	or     0x8(%ebp),%edx
c0105c7d:	c1 ea 02             	shr    $0x2,%edx
c0105c80:	09 d0                	or     %edx,%eax
c0105c82:	89 c1                	mov    %eax,%ecx
c0105c84:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c87:	d1 e8                	shr    %eax
c0105c89:	0b 45 08             	or     0x8(%ebp),%eax
c0105c8c:	8b 55 08             	mov    0x8(%ebp),%edx
c0105c8f:	d1 ea                	shr    %edx
c0105c91:	0b 55 08             	or     0x8(%ebp),%edx
c0105c94:	c1 ea 02             	shr    $0x2,%edx
c0105c97:	09 d0                	or     %edx,%eax
c0105c99:	c1 e8 04             	shr    $0x4,%eax
c0105c9c:	09 c1                	or     %eax,%ecx
c0105c9e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ca1:	d1 e8                	shr    %eax
c0105ca3:	0b 45 08             	or     0x8(%ebp),%eax
c0105ca6:	8b 55 08             	mov    0x8(%ebp),%edx
c0105ca9:	d1 ea                	shr    %edx
c0105cab:	0b 55 08             	or     0x8(%ebp),%edx
c0105cae:	c1 ea 02             	shr    $0x2,%edx
c0105cb1:	09 d0                	or     %edx,%eax
c0105cb3:	89 c3                	mov    %eax,%ebx
c0105cb5:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cb8:	d1 e8                	shr    %eax
c0105cba:	0b 45 08             	or     0x8(%ebp),%eax
c0105cbd:	8b 55 08             	mov    0x8(%ebp),%edx
c0105cc0:	d1 ea                	shr    %edx
c0105cc2:	0b 55 08             	or     0x8(%ebp),%edx
c0105cc5:	c1 ea 02             	shr    $0x2,%edx
c0105cc8:	09 d0                	or     %edx,%eax
c0105cca:	c1 e8 04             	shr    $0x4,%eax
c0105ccd:	09 d8                	or     %ebx,%eax
c0105ccf:	c1 e8 08             	shr    $0x8,%eax
c0105cd2:	09 c1                	or     %eax,%ecx
c0105cd4:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cd7:	d1 e8                	shr    %eax
c0105cd9:	0b 45 08             	or     0x8(%ebp),%eax
c0105cdc:	8b 55 08             	mov    0x8(%ebp),%edx
c0105cdf:	d1 ea                	shr    %edx
c0105ce1:	0b 55 08             	or     0x8(%ebp),%edx
c0105ce4:	c1 ea 02             	shr    $0x2,%edx
c0105ce7:	09 d0                	or     %edx,%eax
c0105ce9:	89 c3                	mov    %eax,%ebx
c0105ceb:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cee:	d1 e8                	shr    %eax
c0105cf0:	0b 45 08             	or     0x8(%ebp),%eax
c0105cf3:	8b 55 08             	mov    0x8(%ebp),%edx
c0105cf6:	d1 ea                	shr    %edx
c0105cf8:	0b 55 08             	or     0x8(%ebp),%edx
c0105cfb:	c1 ea 02             	shr    $0x2,%edx
c0105cfe:	09 d0                	or     %edx,%eax
c0105d00:	c1 e8 04             	shr    $0x4,%eax
c0105d03:	09 c3                	or     %eax,%ebx
c0105d05:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d08:	d1 e8                	shr    %eax
c0105d0a:	0b 45 08             	or     0x8(%ebp),%eax
c0105d0d:	8b 55 08             	mov    0x8(%ebp),%edx
c0105d10:	d1 ea                	shr    %edx
c0105d12:	0b 55 08             	or     0x8(%ebp),%edx
c0105d15:	c1 ea 02             	shr    $0x2,%edx
c0105d18:	09 d0                	or     %edx,%eax
c0105d1a:	89 c6                	mov    %eax,%esi
c0105d1c:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d1f:	d1 e8                	shr    %eax
c0105d21:	0b 45 08             	or     0x8(%ebp),%eax
c0105d24:	8b 55 08             	mov    0x8(%ebp),%edx
c0105d27:	d1 ea                	shr    %edx
c0105d29:	0b 55 08             	or     0x8(%ebp),%edx
c0105d2c:	c1 ea 02             	shr    $0x2,%edx
c0105d2f:	09 d0                	or     %edx,%eax
c0105d31:	c1 e8 04             	shr    $0x4,%eax
c0105d34:	09 f0                	or     %esi,%eax
c0105d36:	c1 e8 08             	shr    $0x8,%eax
c0105d39:	09 d8                	or     %ebx,%eax
c0105d3b:	c1 e8 10             	shr    $0x10,%eax
c0105d3e:	09 c8                	or     %ecx,%eax
c0105d40:	d1 e8                	shr    %eax
c0105d42:	f7 d0                	not    %eax
c0105d44:	23 45 08             	and    0x8(%ebp),%eax
c0105d47:	eb 03                	jmp    c0105d4c <buddy_init_size+0x4a3>
c0105d49:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d4c:	a3 10 3f 12 c0       	mov    %eax,0xc0123f10
        buddy_segment_size = buddy_virtual_size*sizeof(size_t)*2/PGSIZE;
c0105d51:	a1 10 3f 12 c0       	mov    0xc0123f10,%eax
c0105d56:	c1 e0 03             	shl    $0x3,%eax
c0105d59:	c1 e8 0c             	shr    $0xc,%eax
c0105d5c:	a3 14 3f 12 c0       	mov    %eax,0xc0123f14
        if (n > buddy_virtual_size + (buddy_segment_size<<1)) {
c0105d61:	a1 14 3f 12 c0       	mov    0xc0123f14,%eax
c0105d66:	8d 14 00             	lea    (%eax,%eax,1),%edx
c0105d69:	a1 10 3f 12 c0       	mov    0xc0123f10,%eax
c0105d6e:	01 d0                	add    %edx,%eax
c0105d70:	39 45 08             	cmp    %eax,0x8(%ebp)
c0105d73:	76 18                	jbe    c0105d8d <buddy_init_size+0x4e4>
            buddy_virtual_size <<= 1;
c0105d75:	a1 10 3f 12 c0       	mov    0xc0123f10,%eax
c0105d7a:	01 c0                	add    %eax,%eax
c0105d7c:	a3 10 3f 12 c0       	mov    %eax,0xc0123f10
            buddy_segment_size <<= 1;
c0105d81:	a1 14 3f 12 c0       	mov    0xc0123f14,%eax
c0105d86:	01 c0                	add    %eax,%eax
c0105d88:	a3 14 3f 12 c0       	mov    %eax,0xc0123f14
        }
    }
    buddy_alloc_size = MIN(buddy_virtual_size, buddy_physical_size-buddy_segment_size);
c0105d8d:	8b 15 0c 3f 12 c0    	mov    0xc0123f0c,%edx
c0105d93:	a1 14 3f 12 c0       	mov    0xc0123f14,%eax
c0105d98:	29 c2                	sub    %eax,%edx
c0105d9a:	a1 10 3f 12 c0       	mov    0xc0123f10,%eax
c0105d9f:	39 c2                	cmp    %eax,%edx
c0105da1:	0f 46 c2             	cmovbe %edx,%eax
c0105da4:	a3 18 3f 12 c0       	mov    %eax,0xc0123f18
}
c0105da9:	90                   	nop
c0105daa:	83 c4 2c             	add    $0x2c,%esp
c0105dad:	5b                   	pop    %ebx
c0105dae:	5e                   	pop    %esi
c0105daf:	5f                   	pop    %edi
c0105db0:	5d                   	pop    %ebp
c0105db1:	c3                   	ret    

c0105db2 <buddy_init_segment>:

static void
buddy_init_segment(struct Page *base) {
c0105db2:	f3 0f 1e fb          	endbr32 
c0105db6:	55                   	push   %ebp
c0105db7:	89 e5                	mov    %esp,%ebp
c0105db9:	57                   	push   %edi
c0105dba:	56                   	push   %esi
c0105dbb:	53                   	push   %ebx
c0105dbc:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
    // Init address
    buddy_physical = base;
c0105dc2:	8b 45 08             	mov    0x8(%ebp),%eax
c0105dc5:	a3 20 3f 12 c0       	mov    %eax,0xc0123f20
    buddy_segment = KADDR(page2pa(base));
c0105dca:	8b 45 08             	mov    0x8(%ebp),%eax
c0105dcd:	89 04 24             	mov    %eax,(%esp)
c0105dd0:	e8 a6 fa ff ff       	call   c010587b <page2pa>
c0105dd5:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0105dd8:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0105ddb:	c1 e8 0c             	shr    $0xc,%eax
c0105dde:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0105de1:	a1 80 3e 12 c0       	mov    0xc0123e80,%eax
c0105de6:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
c0105de9:	72 23                	jb     c0105e0e <buddy_init_segment+0x5c>
c0105deb:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0105dee:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105df2:	c7 44 24 08 e8 b2 10 	movl   $0xc010b2e8,0x8(%esp)
c0105df9:	c0 
c0105dfa:	c7 44 24 04 3f 00 00 	movl   $0x3f,0x4(%esp)
c0105e01:	00 
c0105e02:	c7 04 24 d3 b2 10 c0 	movl   $0xc010b2d3,(%esp)
c0105e09:	e8 28 a6 ff ff       	call   c0100436 <__panic>
c0105e0e:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0105e11:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0105e16:	a3 1c 3f 12 c0       	mov    %eax,0xc0123f1c
    buddy_alloc = base + buddy_segment_size;
c0105e1b:	8b 15 14 3f 12 c0    	mov    0xc0123f14,%edx
c0105e21:	89 d0                	mov    %edx,%eax
c0105e23:	c1 e0 02             	shl    $0x2,%eax
c0105e26:	01 d0                	add    %edx,%eax
c0105e28:	c1 e0 02             	shl    $0x2,%eax
c0105e2b:	89 c2                	mov    %eax,%edx
c0105e2d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e30:	01 d0                	add    %edx,%eax
c0105e32:	a3 24 3f 12 c0       	mov    %eax,0xc0123f24
    memset(buddy_segment, 0, buddy_segment_size*PGSIZE);
c0105e37:	a1 14 3f 12 c0       	mov    0xc0123f14,%eax
c0105e3c:	c1 e0 0c             	shl    $0xc,%eax
c0105e3f:	89 c2                	mov    %eax,%edx
c0105e41:	a1 1c 3f 12 c0       	mov    0xc0123f1c,%eax
c0105e46:	89 54 24 08          	mov    %edx,0x8(%esp)
c0105e4a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0105e51:	00 
c0105e52:	89 04 24             	mov    %eax,(%esp)
c0105e55:	e8 1c 3a 00 00       	call   c0109876 <memset>
    // Init segment
    nr_free += buddy_alloc_size;
c0105e5a:	8b 15 40 3f 12 c0    	mov    0xc0123f40,%edx
c0105e60:	a1 18 3f 12 c0       	mov    0xc0123f18,%eax
c0105e65:	01 d0                	add    %edx,%eax
c0105e67:	a3 40 3f 12 c0       	mov    %eax,0xc0123f40
    size_t block = BUDDY_ROOT;
c0105e6c:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
    size_t alloc_size = buddy_alloc_size;
c0105e73:	a1 18 3f 12 c0       	mov    0xc0123f18,%eax
c0105e78:	89 45 e0             	mov    %eax,-0x20(%ebp)
    size_t virtual_size = buddy_virtual_size;
c0105e7b:	a1 10 3f 12 c0       	mov    0xc0123f10,%eax
c0105e80:	89 45 dc             	mov    %eax,-0x24(%ebp)
    buddy_segment[block] = alloc_size;
c0105e83:	a1 1c 3f 12 c0       	mov    0xc0123f1c,%eax
c0105e88:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105e8b:	c1 e2 02             	shl    $0x2,%edx
c0105e8e:	01 c2                	add    %eax,%edx
c0105e90:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105e93:	89 02                	mov    %eax,(%edx)
    while (alloc_size > 0 && alloc_size < virtual_size) {
c0105e95:	e9 b4 03 00 00       	jmp    c010624e <buddy_init_segment+0x49c>
        virtual_size >>= 1;
c0105e9a:	d1 6d dc             	shrl   -0x24(%ebp)
        if (alloc_size > virtual_size) {
c0105e9d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105ea0:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0105ea3:	0f 86 7a 03 00 00    	jbe    c0106223 <buddy_init_segment+0x471>
            // Add left to free list
            struct Page *page = &buddy_alloc[BUDDY_BEGIN(block)];
c0105ea9:	a1 24 3f 12 c0       	mov    0xc0123f24,%eax
c0105eae:	89 45 84             	mov    %eax,-0x7c(%ebp)
c0105eb1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105eb4:	d1 e8                	shr    %eax
c0105eb6:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0105eb9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105ebc:	d1 ea                	shr    %edx
c0105ebe:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0105ec1:	c1 ea 02             	shr    $0x2,%edx
c0105ec4:	09 d0                	or     %edx,%eax
c0105ec6:	89 c1                	mov    %eax,%ecx
c0105ec8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105ecb:	d1 e8                	shr    %eax
c0105ecd:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0105ed0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105ed3:	d1 ea                	shr    %edx
c0105ed5:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0105ed8:	c1 ea 02             	shr    $0x2,%edx
c0105edb:	09 d0                	or     %edx,%eax
c0105edd:	c1 e8 04             	shr    $0x4,%eax
c0105ee0:	09 c1                	or     %eax,%ecx
c0105ee2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105ee5:	d1 e8                	shr    %eax
c0105ee7:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0105eea:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105eed:	d1 ea                	shr    %edx
c0105eef:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0105ef2:	c1 ea 02             	shr    $0x2,%edx
c0105ef5:	09 d0                	or     %edx,%eax
c0105ef7:	89 c3                	mov    %eax,%ebx
c0105ef9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105efc:	d1 e8                	shr    %eax
c0105efe:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0105f01:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105f04:	d1 ea                	shr    %edx
c0105f06:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0105f09:	c1 ea 02             	shr    $0x2,%edx
c0105f0c:	09 d0                	or     %edx,%eax
c0105f0e:	c1 e8 04             	shr    $0x4,%eax
c0105f11:	09 d8                	or     %ebx,%eax
c0105f13:	c1 e8 08             	shr    $0x8,%eax
c0105f16:	09 c1                	or     %eax,%ecx
c0105f18:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105f1b:	d1 e8                	shr    %eax
c0105f1d:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0105f20:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105f23:	d1 ea                	shr    %edx
c0105f25:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0105f28:	c1 ea 02             	shr    $0x2,%edx
c0105f2b:	09 d0                	or     %edx,%eax
c0105f2d:	89 c3                	mov    %eax,%ebx
c0105f2f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105f32:	d1 e8                	shr    %eax
c0105f34:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0105f37:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105f3a:	d1 ea                	shr    %edx
c0105f3c:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0105f3f:	c1 ea 02             	shr    $0x2,%edx
c0105f42:	09 d0                	or     %edx,%eax
c0105f44:	c1 e8 04             	shr    $0x4,%eax
c0105f47:	09 c3                	or     %eax,%ebx
c0105f49:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105f4c:	d1 e8                	shr    %eax
c0105f4e:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0105f51:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105f54:	d1 ea                	shr    %edx
c0105f56:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0105f59:	c1 ea 02             	shr    $0x2,%edx
c0105f5c:	09 d0                	or     %edx,%eax
c0105f5e:	89 c6                	mov    %eax,%esi
c0105f60:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105f63:	d1 e8                	shr    %eax
c0105f65:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0105f68:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105f6b:	d1 ea                	shr    %edx
c0105f6d:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0105f70:	c1 ea 02             	shr    $0x2,%edx
c0105f73:	09 d0                	or     %edx,%eax
c0105f75:	c1 e8 04             	shr    $0x4,%eax
c0105f78:	09 f0                	or     %esi,%eax
c0105f7a:	c1 e8 08             	shr    $0x8,%eax
c0105f7d:	09 d8                	or     %ebx,%eax
c0105f7f:	c1 e8 10             	shr    $0x10,%eax
c0105f82:	09 c8                	or     %ecx,%eax
c0105f84:	d1 e8                	shr    %eax
c0105f86:	23 45 e4             	and    -0x1c(%ebp),%eax
c0105f89:	89 45 80             	mov    %eax,-0x80(%ebp)
c0105f8c:	8b 3d 10 3f 12 c0    	mov    0xc0123f10,%edi
c0105f92:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105f95:	d1 e8                	shr    %eax
c0105f97:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0105f9a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105f9d:	d1 ea                	shr    %edx
c0105f9f:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0105fa2:	c1 ea 02             	shr    $0x2,%edx
c0105fa5:	09 d0                	or     %edx,%eax
c0105fa7:	89 c1                	mov    %eax,%ecx
c0105fa9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105fac:	d1 e8                	shr    %eax
c0105fae:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0105fb1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105fb4:	d1 ea                	shr    %edx
c0105fb6:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0105fb9:	c1 ea 02             	shr    $0x2,%edx
c0105fbc:	09 d0                	or     %edx,%eax
c0105fbe:	c1 e8 04             	shr    $0x4,%eax
c0105fc1:	09 c1                	or     %eax,%ecx
c0105fc3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105fc6:	d1 e8                	shr    %eax
c0105fc8:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0105fcb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105fce:	d1 ea                	shr    %edx
c0105fd0:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0105fd3:	c1 ea 02             	shr    $0x2,%edx
c0105fd6:	09 d0                	or     %edx,%eax
c0105fd8:	89 c3                	mov    %eax,%ebx
c0105fda:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105fdd:	d1 e8                	shr    %eax
c0105fdf:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0105fe2:	89 c2                	mov    %eax,%edx
c0105fe4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105fe7:	d1 e8                	shr    %eax
c0105fe9:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0105fec:	c1 e8 02             	shr    $0x2,%eax
c0105fef:	09 d0                	or     %edx,%eax
c0105ff1:	c1 e8 04             	shr    $0x4,%eax
c0105ff4:	09 d8                	or     %ebx,%eax
c0105ff6:	c1 e8 08             	shr    $0x8,%eax
c0105ff9:	89 ce                	mov    %ecx,%esi
c0105ffb:	09 c6                	or     %eax,%esi
c0105ffd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106000:	d1 e8                	shr    %eax
c0106002:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0106005:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106008:	d1 ea                	shr    %edx
c010600a:	0b 55 e4             	or     -0x1c(%ebp),%edx
c010600d:	c1 ea 02             	shr    $0x2,%edx
c0106010:	09 d0                	or     %edx,%eax
c0106012:	89 c1                	mov    %eax,%ecx
c0106014:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106017:	d1 e8                	shr    %eax
c0106019:	0b 45 e4             	or     -0x1c(%ebp),%eax
c010601c:	89 c2                	mov    %eax,%edx
c010601e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106021:	d1 e8                	shr    %eax
c0106023:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0106026:	c1 e8 02             	shr    $0x2,%eax
c0106029:	09 d0                	or     %edx,%eax
c010602b:	c1 e8 04             	shr    $0x4,%eax
c010602e:	89 cb                	mov    %ecx,%ebx
c0106030:	09 c3                	or     %eax,%ebx
c0106032:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106035:	d1 e8                	shr    %eax
c0106037:	0b 45 e4             	or     -0x1c(%ebp),%eax
c010603a:	89 c2                	mov    %eax,%edx
c010603c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010603f:	d1 e8                	shr    %eax
c0106041:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0106044:	c1 e8 02             	shr    $0x2,%eax
c0106047:	89 d1                	mov    %edx,%ecx
c0106049:	09 c1                	or     %eax,%ecx
c010604b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010604e:	d1 e8                	shr    %eax
c0106050:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0106053:	89 c2                	mov    %eax,%edx
c0106055:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106058:	d1 e8                	shr    %eax
c010605a:	0b 45 e4             	or     -0x1c(%ebp),%eax
c010605d:	c1 e8 02             	shr    $0x2,%eax
c0106060:	09 d0                	or     %edx,%eax
c0106062:	c1 e8 04             	shr    $0x4,%eax
c0106065:	09 c8                	or     %ecx,%eax
c0106067:	c1 e8 08             	shr    $0x8,%eax
c010606a:	09 d8                	or     %ebx,%eax
c010606c:	c1 e8 10             	shr    $0x10,%eax
c010606f:	09 f0                	or     %esi,%eax
c0106071:	d1 e8                	shr    %eax
c0106073:	23 45 e4             	and    -0x1c(%ebp),%eax
c0106076:	85 c0                	test   %eax,%eax
c0106078:	0f 84 ea 00 00 00    	je     c0106168 <buddy_init_segment+0x3b6>
c010607e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106081:	d1 e8                	shr    %eax
c0106083:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0106086:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106089:	d1 ea                	shr    %edx
c010608b:	0b 55 e4             	or     -0x1c(%ebp),%edx
c010608e:	c1 ea 02             	shr    $0x2,%edx
c0106091:	09 d0                	or     %edx,%eax
c0106093:	89 c1                	mov    %eax,%ecx
c0106095:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106098:	d1 e8                	shr    %eax
c010609a:	0b 45 e4             	or     -0x1c(%ebp),%eax
c010609d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01060a0:	d1 ea                	shr    %edx
c01060a2:	0b 55 e4             	or     -0x1c(%ebp),%edx
c01060a5:	c1 ea 02             	shr    $0x2,%edx
c01060a8:	09 d0                	or     %edx,%eax
c01060aa:	c1 e8 04             	shr    $0x4,%eax
c01060ad:	09 c1                	or     %eax,%ecx
c01060af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01060b2:	d1 e8                	shr    %eax
c01060b4:	0b 45 e4             	or     -0x1c(%ebp),%eax
c01060b7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01060ba:	d1 ea                	shr    %edx
c01060bc:	0b 55 e4             	or     -0x1c(%ebp),%edx
c01060bf:	c1 ea 02             	shr    $0x2,%edx
c01060c2:	09 d0                	or     %edx,%eax
c01060c4:	89 c3                	mov    %eax,%ebx
c01060c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01060c9:	d1 e8                	shr    %eax
c01060cb:	0b 45 e4             	or     -0x1c(%ebp),%eax
c01060ce:	89 c2                	mov    %eax,%edx
c01060d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01060d3:	d1 e8                	shr    %eax
c01060d5:	0b 45 e4             	or     -0x1c(%ebp),%eax
c01060d8:	c1 e8 02             	shr    $0x2,%eax
c01060db:	09 d0                	or     %edx,%eax
c01060dd:	c1 e8 04             	shr    $0x4,%eax
c01060e0:	09 d8                	or     %ebx,%eax
c01060e2:	c1 e8 08             	shr    $0x8,%eax
c01060e5:	89 ce                	mov    %ecx,%esi
c01060e7:	09 c6                	or     %eax,%esi
c01060e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01060ec:	d1 e8                	shr    %eax
c01060ee:	0b 45 e4             	or     -0x1c(%ebp),%eax
c01060f1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01060f4:	d1 ea                	shr    %edx
c01060f6:	0b 55 e4             	or     -0x1c(%ebp),%edx
c01060f9:	c1 ea 02             	shr    $0x2,%edx
c01060fc:	09 d0                	or     %edx,%eax
c01060fe:	89 c1                	mov    %eax,%ecx
c0106100:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106103:	d1 e8                	shr    %eax
c0106105:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0106108:	89 c2                	mov    %eax,%edx
c010610a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010610d:	d1 e8                	shr    %eax
c010610f:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0106112:	c1 e8 02             	shr    $0x2,%eax
c0106115:	09 d0                	or     %edx,%eax
c0106117:	c1 e8 04             	shr    $0x4,%eax
c010611a:	89 cb                	mov    %ecx,%ebx
c010611c:	09 c3                	or     %eax,%ebx
c010611e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106121:	d1 e8                	shr    %eax
c0106123:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0106126:	89 c2                	mov    %eax,%edx
c0106128:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010612b:	d1 e8                	shr    %eax
c010612d:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0106130:	c1 e8 02             	shr    $0x2,%eax
c0106133:	89 d1                	mov    %edx,%ecx
c0106135:	09 c1                	or     %eax,%ecx
c0106137:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010613a:	d1 e8                	shr    %eax
c010613c:	0b 45 e4             	or     -0x1c(%ebp),%eax
c010613f:	89 c2                	mov    %eax,%edx
c0106141:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106144:	d1 e8                	shr    %eax
c0106146:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0106149:	c1 e8 02             	shr    $0x2,%eax
c010614c:	09 d0                	or     %edx,%eax
c010614e:	c1 e8 04             	shr    $0x4,%eax
c0106151:	09 c8                	or     %ecx,%eax
c0106153:	c1 e8 08             	shr    $0x8,%eax
c0106156:	09 d8                	or     %ebx,%eax
c0106158:	c1 e8 10             	shr    $0x10,%eax
c010615b:	09 f0                	or     %esi,%eax
c010615d:	d1 e8                	shr    %eax
c010615f:	f7 d0                	not    %eax
c0106161:	23 45 e4             	and    -0x1c(%ebp),%eax
c0106164:	89 c6                	mov    %eax,%esi
c0106166:	eb 03                	jmp    c010616b <buddy_init_segment+0x3b9>
c0106168:	8b 75 e4             	mov    -0x1c(%ebp),%esi
c010616b:	89 f8                	mov    %edi,%eax
c010616d:	ba 00 00 00 00       	mov    $0x0,%edx
c0106172:	f7 f6                	div    %esi
c0106174:	8b 55 80             	mov    -0x80(%ebp),%edx
c0106177:	0f af d0             	imul   %eax,%edx
c010617a:	89 d0                	mov    %edx,%eax
c010617c:	c1 e0 02             	shl    $0x2,%eax
c010617f:	01 d0                	add    %edx,%eax
c0106181:	c1 e0 02             	shl    $0x2,%eax
c0106184:	03 45 84             	add    -0x7c(%ebp),%eax
c0106187:	89 45 d0             	mov    %eax,-0x30(%ebp)
            page->property = virtual_size;
c010618a:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010618d:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0106190:	89 50 08             	mov    %edx,0x8(%eax)
            list_add(&(free_list), &(page->page_link));
c0106193:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0106196:	83 c0 0c             	add    $0xc,%eax
c0106199:	c7 45 c8 38 3f 12 c0 	movl   $0xc0123f38,-0x38(%ebp)
c01061a0:	89 45 c4             	mov    %eax,-0x3c(%ebp)
c01061a3:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01061a6:	89 45 c0             	mov    %eax,-0x40(%ebp)
c01061a9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01061ac:	89 45 bc             	mov    %eax,-0x44(%ebp)
    __list_add(elm, listelm, listelm->next);
c01061af:	8b 45 c0             	mov    -0x40(%ebp),%eax
c01061b2:	8b 40 04             	mov    0x4(%eax),%eax
c01061b5:	8b 55 bc             	mov    -0x44(%ebp),%edx
c01061b8:	89 55 b8             	mov    %edx,-0x48(%ebp)
c01061bb:	8b 55 c0             	mov    -0x40(%ebp),%edx
c01061be:	89 55 b4             	mov    %edx,-0x4c(%ebp)
c01061c1:	89 45 b0             	mov    %eax,-0x50(%ebp)
    prev->next = next->prev = elm;
c01061c4:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01061c7:	8b 55 b8             	mov    -0x48(%ebp),%edx
c01061ca:	89 10                	mov    %edx,(%eax)
c01061cc:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01061cf:	8b 10                	mov    (%eax),%edx
c01061d1:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01061d4:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01061d7:	8b 45 b8             	mov    -0x48(%ebp),%eax
c01061da:	8b 55 b0             	mov    -0x50(%ebp),%edx
c01061dd:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01061e0:	8b 45 b8             	mov    -0x48(%ebp),%eax
c01061e3:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c01061e6:	89 10                	mov    %edx,(%eax)
}
c01061e8:	90                   	nop
}
c01061e9:	90                   	nop
}
c01061ea:	90                   	nop
            buddy_segment[BUDDY_LEFT(block)] = virtual_size;
c01061eb:	a1 1c 3f 12 c0       	mov    0xc0123f1c,%eax
c01061f0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01061f3:	c1 e2 03             	shl    $0x3,%edx
c01061f6:	01 c2                	add    %eax,%edx
c01061f8:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01061fb:	89 02                	mov    %eax,(%edx)
            // Switch to right
            alloc_size -= virtual_size;
c01061fd:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106200:	29 45 e0             	sub    %eax,-0x20(%ebp)
            buddy_segment[BUDDY_RIGHT(block)] = alloc_size;
c0106203:	a1 1c 3f 12 c0       	mov    0xc0123f1c,%eax
c0106208:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010620b:	c1 e2 03             	shl    $0x3,%edx
c010620e:	83 c2 04             	add    $0x4,%edx
c0106211:	01 c2                	add    %eax,%edx
c0106213:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106216:	89 02                	mov    %eax,(%edx)
            block = BUDDY_RIGHT(block);
c0106218:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010621b:	01 c0                	add    %eax,%eax
c010621d:	40                   	inc    %eax
c010621e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0106221:	eb 2b                	jmp    c010624e <buddy_init_segment+0x49c>
        } else {
            // Switch to left
            buddy_segment[BUDDY_LEFT(block)] = alloc_size;
c0106223:	a1 1c 3f 12 c0       	mov    0xc0123f1c,%eax
c0106228:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010622b:	c1 e2 03             	shl    $0x3,%edx
c010622e:	01 c2                	add    %eax,%edx
c0106230:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106233:	89 02                	mov    %eax,(%edx)
            buddy_segment[BUDDY_RIGHT(block)] = 0;
c0106235:	a1 1c 3f 12 c0       	mov    0xc0123f1c,%eax
c010623a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010623d:	c1 e2 03             	shl    $0x3,%edx
c0106240:	83 c2 04             	add    $0x4,%edx
c0106243:	01 d0                	add    %edx,%eax
c0106245:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            block = BUDDY_LEFT(block);
c010624b:	d1 65 e4             	shll   -0x1c(%ebp)
    while (alloc_size > 0 && alloc_size < virtual_size) {
c010624e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0106252:	74 0c                	je     c0106260 <buddy_init_segment+0x4ae>
c0106254:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106257:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c010625a:	0f 82 3a fc ff ff    	jb     c0105e9a <buddy_init_segment+0xe8>
        }
    }
    if (alloc_size > 0) {
c0106260:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0106264:	0f 84 42 03 00 00    	je     c01065ac <buddy_init_segment+0x7fa>
        struct Page *page = &buddy_alloc[BUDDY_BEGIN(block)];
c010626a:	a1 24 3f 12 c0       	mov    0xc0123f24,%eax
c010626f:	89 45 84             	mov    %eax,-0x7c(%ebp)
c0106272:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106275:	d1 e8                	shr    %eax
c0106277:	0b 45 e4             	or     -0x1c(%ebp),%eax
c010627a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010627d:	d1 ea                	shr    %edx
c010627f:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0106282:	c1 ea 02             	shr    $0x2,%edx
c0106285:	09 d0                	or     %edx,%eax
c0106287:	89 c1                	mov    %eax,%ecx
c0106289:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010628c:	d1 e8                	shr    %eax
c010628e:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0106291:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106294:	d1 ea                	shr    %edx
c0106296:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0106299:	c1 ea 02             	shr    $0x2,%edx
c010629c:	09 d0                	or     %edx,%eax
c010629e:	c1 e8 04             	shr    $0x4,%eax
c01062a1:	09 c1                	or     %eax,%ecx
c01062a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01062a6:	d1 e8                	shr    %eax
c01062a8:	0b 45 e4             	or     -0x1c(%ebp),%eax
c01062ab:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01062ae:	d1 ea                	shr    %edx
c01062b0:	0b 55 e4             	or     -0x1c(%ebp),%edx
c01062b3:	c1 ea 02             	shr    $0x2,%edx
c01062b6:	09 d0                	or     %edx,%eax
c01062b8:	89 c3                	mov    %eax,%ebx
c01062ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01062bd:	d1 e8                	shr    %eax
c01062bf:	0b 45 e4             	or     -0x1c(%ebp),%eax
c01062c2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01062c5:	d1 ea                	shr    %edx
c01062c7:	0b 55 e4             	or     -0x1c(%ebp),%edx
c01062ca:	c1 ea 02             	shr    $0x2,%edx
c01062cd:	09 d0                	or     %edx,%eax
c01062cf:	c1 e8 04             	shr    $0x4,%eax
c01062d2:	09 d8                	or     %ebx,%eax
c01062d4:	c1 e8 08             	shr    $0x8,%eax
c01062d7:	09 c1                	or     %eax,%ecx
c01062d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01062dc:	d1 e8                	shr    %eax
c01062de:	0b 45 e4             	or     -0x1c(%ebp),%eax
c01062e1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01062e4:	d1 ea                	shr    %edx
c01062e6:	0b 55 e4             	or     -0x1c(%ebp),%edx
c01062e9:	c1 ea 02             	shr    $0x2,%edx
c01062ec:	09 d0                	or     %edx,%eax
c01062ee:	89 c3                	mov    %eax,%ebx
c01062f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01062f3:	d1 e8                	shr    %eax
c01062f5:	0b 45 e4             	or     -0x1c(%ebp),%eax
c01062f8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01062fb:	d1 ea                	shr    %edx
c01062fd:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0106300:	c1 ea 02             	shr    $0x2,%edx
c0106303:	09 d0                	or     %edx,%eax
c0106305:	c1 e8 04             	shr    $0x4,%eax
c0106308:	09 c3                	or     %eax,%ebx
c010630a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010630d:	d1 e8                	shr    %eax
c010630f:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0106312:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106315:	d1 ea                	shr    %edx
c0106317:	0b 55 e4             	or     -0x1c(%ebp),%edx
c010631a:	c1 ea 02             	shr    $0x2,%edx
c010631d:	09 d0                	or     %edx,%eax
c010631f:	89 c6                	mov    %eax,%esi
c0106321:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106324:	d1 e8                	shr    %eax
c0106326:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0106329:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010632c:	d1 ea                	shr    %edx
c010632e:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0106331:	c1 ea 02             	shr    $0x2,%edx
c0106334:	09 d0                	or     %edx,%eax
c0106336:	c1 e8 04             	shr    $0x4,%eax
c0106339:	09 f0                	or     %esi,%eax
c010633b:	c1 e8 08             	shr    $0x8,%eax
c010633e:	09 d8                	or     %ebx,%eax
c0106340:	c1 e8 10             	shr    $0x10,%eax
c0106343:	09 c8                	or     %ecx,%eax
c0106345:	d1 e8                	shr    %eax
c0106347:	23 45 e4             	and    -0x1c(%ebp),%eax
c010634a:	89 45 80             	mov    %eax,-0x80(%ebp)
c010634d:	8b 3d 10 3f 12 c0    	mov    0xc0123f10,%edi
c0106353:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106356:	d1 e8                	shr    %eax
c0106358:	0b 45 e4             	or     -0x1c(%ebp),%eax
c010635b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010635e:	d1 ea                	shr    %edx
c0106360:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0106363:	c1 ea 02             	shr    $0x2,%edx
c0106366:	09 d0                	or     %edx,%eax
c0106368:	89 c1                	mov    %eax,%ecx
c010636a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010636d:	d1 e8                	shr    %eax
c010636f:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0106372:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106375:	d1 ea                	shr    %edx
c0106377:	0b 55 e4             	or     -0x1c(%ebp),%edx
c010637a:	c1 ea 02             	shr    $0x2,%edx
c010637d:	09 d0                	or     %edx,%eax
c010637f:	c1 e8 04             	shr    $0x4,%eax
c0106382:	09 c1                	or     %eax,%ecx
c0106384:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106387:	d1 e8                	shr    %eax
c0106389:	0b 45 e4             	or     -0x1c(%ebp),%eax
c010638c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010638f:	d1 ea                	shr    %edx
c0106391:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0106394:	c1 ea 02             	shr    $0x2,%edx
c0106397:	09 d0                	or     %edx,%eax
c0106399:	89 c3                	mov    %eax,%ebx
c010639b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010639e:	d1 e8                	shr    %eax
c01063a0:	0b 45 e4             	or     -0x1c(%ebp),%eax
c01063a3:	89 c2                	mov    %eax,%edx
c01063a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01063a8:	d1 e8                	shr    %eax
c01063aa:	0b 45 e4             	or     -0x1c(%ebp),%eax
c01063ad:	c1 e8 02             	shr    $0x2,%eax
c01063b0:	09 d0                	or     %edx,%eax
c01063b2:	c1 e8 04             	shr    $0x4,%eax
c01063b5:	09 d8                	or     %ebx,%eax
c01063b7:	c1 e8 08             	shr    $0x8,%eax
c01063ba:	89 ce                	mov    %ecx,%esi
c01063bc:	09 c6                	or     %eax,%esi
c01063be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01063c1:	d1 e8                	shr    %eax
c01063c3:	0b 45 e4             	or     -0x1c(%ebp),%eax
c01063c6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01063c9:	d1 ea                	shr    %edx
c01063cb:	0b 55 e4             	or     -0x1c(%ebp),%edx
c01063ce:	c1 ea 02             	shr    $0x2,%edx
c01063d1:	09 d0                	or     %edx,%eax
c01063d3:	89 c1                	mov    %eax,%ecx
c01063d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01063d8:	d1 e8                	shr    %eax
c01063da:	0b 45 e4             	or     -0x1c(%ebp),%eax
c01063dd:	89 c2                	mov    %eax,%edx
c01063df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01063e2:	d1 e8                	shr    %eax
c01063e4:	0b 45 e4             	or     -0x1c(%ebp),%eax
c01063e7:	c1 e8 02             	shr    $0x2,%eax
c01063ea:	09 d0                	or     %edx,%eax
c01063ec:	c1 e8 04             	shr    $0x4,%eax
c01063ef:	89 cb                	mov    %ecx,%ebx
c01063f1:	09 c3                	or     %eax,%ebx
c01063f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01063f6:	d1 e8                	shr    %eax
c01063f8:	0b 45 e4             	or     -0x1c(%ebp),%eax
c01063fb:	89 c2                	mov    %eax,%edx
c01063fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106400:	d1 e8                	shr    %eax
c0106402:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0106405:	c1 e8 02             	shr    $0x2,%eax
c0106408:	89 d1                	mov    %edx,%ecx
c010640a:	09 c1                	or     %eax,%ecx
c010640c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010640f:	d1 e8                	shr    %eax
c0106411:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0106414:	89 c2                	mov    %eax,%edx
c0106416:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106419:	d1 e8                	shr    %eax
c010641b:	0b 45 e4             	or     -0x1c(%ebp),%eax
c010641e:	c1 e8 02             	shr    $0x2,%eax
c0106421:	09 d0                	or     %edx,%eax
c0106423:	c1 e8 04             	shr    $0x4,%eax
c0106426:	09 c8                	or     %ecx,%eax
c0106428:	c1 e8 08             	shr    $0x8,%eax
c010642b:	09 d8                	or     %ebx,%eax
c010642d:	c1 e8 10             	shr    $0x10,%eax
c0106430:	09 f0                	or     %esi,%eax
c0106432:	d1 e8                	shr    %eax
c0106434:	23 45 e4             	and    -0x1c(%ebp),%eax
c0106437:	85 c0                	test   %eax,%eax
c0106439:	0f 84 ea 00 00 00    	je     c0106529 <buddy_init_segment+0x777>
c010643f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106442:	d1 e8                	shr    %eax
c0106444:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0106447:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010644a:	d1 ea                	shr    %edx
c010644c:	0b 55 e4             	or     -0x1c(%ebp),%edx
c010644f:	c1 ea 02             	shr    $0x2,%edx
c0106452:	09 d0                	or     %edx,%eax
c0106454:	89 c1                	mov    %eax,%ecx
c0106456:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106459:	d1 e8                	shr    %eax
c010645b:	0b 45 e4             	or     -0x1c(%ebp),%eax
c010645e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106461:	d1 ea                	shr    %edx
c0106463:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0106466:	c1 ea 02             	shr    $0x2,%edx
c0106469:	09 d0                	or     %edx,%eax
c010646b:	c1 e8 04             	shr    $0x4,%eax
c010646e:	09 c1                	or     %eax,%ecx
c0106470:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106473:	d1 e8                	shr    %eax
c0106475:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0106478:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010647b:	d1 ea                	shr    %edx
c010647d:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0106480:	c1 ea 02             	shr    $0x2,%edx
c0106483:	09 d0                	or     %edx,%eax
c0106485:	89 c3                	mov    %eax,%ebx
c0106487:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010648a:	d1 e8                	shr    %eax
c010648c:	0b 45 e4             	or     -0x1c(%ebp),%eax
c010648f:	89 c2                	mov    %eax,%edx
c0106491:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106494:	d1 e8                	shr    %eax
c0106496:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0106499:	c1 e8 02             	shr    $0x2,%eax
c010649c:	09 d0                	or     %edx,%eax
c010649e:	c1 e8 04             	shr    $0x4,%eax
c01064a1:	09 d8                	or     %ebx,%eax
c01064a3:	c1 e8 08             	shr    $0x8,%eax
c01064a6:	89 ce                	mov    %ecx,%esi
c01064a8:	09 c6                	or     %eax,%esi
c01064aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01064ad:	d1 e8                	shr    %eax
c01064af:	0b 45 e4             	or     -0x1c(%ebp),%eax
c01064b2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01064b5:	d1 ea                	shr    %edx
c01064b7:	0b 55 e4             	or     -0x1c(%ebp),%edx
c01064ba:	c1 ea 02             	shr    $0x2,%edx
c01064bd:	09 d0                	or     %edx,%eax
c01064bf:	89 c1                	mov    %eax,%ecx
c01064c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01064c4:	d1 e8                	shr    %eax
c01064c6:	0b 45 e4             	or     -0x1c(%ebp),%eax
c01064c9:	89 c2                	mov    %eax,%edx
c01064cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01064ce:	d1 e8                	shr    %eax
c01064d0:	0b 45 e4             	or     -0x1c(%ebp),%eax
c01064d3:	c1 e8 02             	shr    $0x2,%eax
c01064d6:	09 d0                	or     %edx,%eax
c01064d8:	c1 e8 04             	shr    $0x4,%eax
c01064db:	89 cb                	mov    %ecx,%ebx
c01064dd:	09 c3                	or     %eax,%ebx
c01064df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01064e2:	d1 e8                	shr    %eax
c01064e4:	0b 45 e4             	or     -0x1c(%ebp),%eax
c01064e7:	89 c2                	mov    %eax,%edx
c01064e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01064ec:	d1 e8                	shr    %eax
c01064ee:	0b 45 e4             	or     -0x1c(%ebp),%eax
c01064f1:	c1 e8 02             	shr    $0x2,%eax
c01064f4:	89 d1                	mov    %edx,%ecx
c01064f6:	09 c1                	or     %eax,%ecx
c01064f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01064fb:	d1 e8                	shr    %eax
c01064fd:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0106500:	89 c2                	mov    %eax,%edx
c0106502:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106505:	d1 e8                	shr    %eax
c0106507:	0b 45 e4             	or     -0x1c(%ebp),%eax
c010650a:	c1 e8 02             	shr    $0x2,%eax
c010650d:	09 d0                	or     %edx,%eax
c010650f:	c1 e8 04             	shr    $0x4,%eax
c0106512:	09 c8                	or     %ecx,%eax
c0106514:	c1 e8 08             	shr    $0x8,%eax
c0106517:	09 d8                	or     %ebx,%eax
c0106519:	c1 e8 10             	shr    $0x10,%eax
c010651c:	09 f0                	or     %esi,%eax
c010651e:	d1 e8                	shr    %eax
c0106520:	f7 d0                	not    %eax
c0106522:	23 45 e4             	and    -0x1c(%ebp),%eax
c0106525:	89 c6                	mov    %eax,%esi
c0106527:	eb 03                	jmp    c010652c <buddy_init_segment+0x77a>
c0106529:	8b 75 e4             	mov    -0x1c(%ebp),%esi
c010652c:	89 f8                	mov    %edi,%eax
c010652e:	ba 00 00 00 00       	mov    $0x0,%edx
c0106533:	f7 f6                	div    %esi
c0106535:	8b 55 80             	mov    -0x80(%ebp),%edx
c0106538:	0f af d0             	imul   %eax,%edx
c010653b:	89 d0                	mov    %edx,%eax
c010653d:	c1 e0 02             	shl    $0x2,%eax
c0106540:	01 d0                	add    %edx,%eax
c0106542:	c1 e0 02             	shl    $0x2,%eax
c0106545:	03 45 84             	add    -0x7c(%ebp),%eax
c0106548:	89 45 cc             	mov    %eax,-0x34(%ebp)
        page->property = alloc_size;
c010654b:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010654e:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0106551:	89 50 08             	mov    %edx,0x8(%eax)
        list_add(&(free_list), &(page->page_link));
c0106554:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0106557:	83 c0 0c             	add    $0xc,%eax
c010655a:	c7 45 ac 38 3f 12 c0 	movl   $0xc0123f38,-0x54(%ebp)
c0106561:	89 45 a8             	mov    %eax,-0x58(%ebp)
c0106564:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0106567:	89 45 a4             	mov    %eax,-0x5c(%ebp)
c010656a:	8b 45 a8             	mov    -0x58(%ebp),%eax
c010656d:	89 45 a0             	mov    %eax,-0x60(%ebp)
    __list_add(elm, listelm, listelm->next);
c0106570:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0106573:	8b 40 04             	mov    0x4(%eax),%eax
c0106576:	8b 55 a0             	mov    -0x60(%ebp),%edx
c0106579:	89 55 9c             	mov    %edx,-0x64(%ebp)
c010657c:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c010657f:	89 55 98             	mov    %edx,-0x68(%ebp)
c0106582:	89 45 94             	mov    %eax,-0x6c(%ebp)
    prev->next = next->prev = elm;
c0106585:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0106588:	8b 55 9c             	mov    -0x64(%ebp),%edx
c010658b:	89 10                	mov    %edx,(%eax)
c010658d:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0106590:	8b 10                	mov    (%eax),%edx
c0106592:	8b 45 98             	mov    -0x68(%ebp),%eax
c0106595:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0106598:	8b 45 9c             	mov    -0x64(%ebp),%eax
c010659b:	8b 55 94             	mov    -0x6c(%ebp),%edx
c010659e:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01065a1:	8b 45 9c             	mov    -0x64(%ebp),%eax
c01065a4:	8b 55 98             	mov    -0x68(%ebp),%edx
c01065a7:	89 10                	mov    %edx,(%eax)
}
c01065a9:	90                   	nop
}
c01065aa:	90                   	nop
}
c01065ab:	90                   	nop
    }
}
c01065ac:	90                   	nop
c01065ad:	81 c4 8c 00 00 00    	add    $0x8c,%esp
c01065b3:	5b                   	pop    %ebx
c01065b4:	5e                   	pop    %esi
c01065b5:	5f                   	pop    %edi
c01065b6:	5d                   	pop    %ebp
c01065b7:	c3                   	ret    

c01065b8 <buddy_init>:

static void
buddy_init(void) {
c01065b8:	f3 0f 1e fb          	endbr32 
c01065bc:	55                   	push   %ebp
c01065bd:	89 e5                	mov    %esp,%ebp
c01065bf:	83 ec 10             	sub    $0x10,%esp
c01065c2:	c7 45 fc 38 3f 12 c0 	movl   $0xc0123f38,-0x4(%ebp)
    elm->prev = elm->next = elm;
c01065c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01065cc:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01065cf:	89 50 04             	mov    %edx,0x4(%eax)
c01065d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01065d5:	8b 50 04             	mov    0x4(%eax),%edx
c01065d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01065db:	89 10                	mov    %edx,(%eax)
}
c01065dd:	90                   	nop
    list_init(&free_list);
    nr_free = 0;
c01065de:	c7 05 40 3f 12 c0 00 	movl   $0x0,0xc0123f40
c01065e5:	00 00 00 
}
c01065e8:	90                   	nop
c01065e9:	c9                   	leave  
c01065ea:	c3                   	ret    

c01065eb <buddy_init_memmap>:

static void
buddy_init_memmap(struct Page *base, size_t n) {
c01065eb:	f3 0f 1e fb          	endbr32 
c01065ef:	55                   	push   %ebp
c01065f0:	89 e5                	mov    %esp,%ebp
c01065f2:	83 ec 28             	sub    $0x28,%esp
    assert(n > 0);
c01065f5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01065f9:	75 24                	jne    c010661f <buddy_init_memmap+0x34>
c01065fb:	c7 44 24 0c 0b b3 10 	movl   $0xc010b30b,0xc(%esp)
c0106602:	c0 
c0106603:	c7 44 24 08 be b2 10 	movl   $0xc010b2be,0x8(%esp)
c010660a:	c0 
c010660b:	c7 44 24 04 6a 00 00 	movl   $0x6a,0x4(%esp)
c0106612:	00 
c0106613:	c7 04 24 d3 b2 10 c0 	movl   $0xc010b2d3,(%esp)
c010661a:	e8 17 9e ff ff       	call   c0100436 <__panic>
    // Init pages
    for (struct Page *p = base; p < base + n; p++) {
c010661f:	8b 45 08             	mov    0x8(%ebp),%eax
c0106622:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0106625:	eb 7d                	jmp    c01066a4 <buddy_init_memmap+0xb9>
        assert(PageReserved(p));
c0106627:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010662a:	83 c0 04             	add    $0x4,%eax
c010662d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c0106634:	89 45 ec             	mov    %eax,-0x14(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0106637:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010663a:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010663d:	0f a3 10             	bt     %edx,(%eax)
c0106640:	19 c0                	sbb    %eax,%eax
c0106642:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
c0106645:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0106649:	0f 95 c0             	setne  %al
c010664c:	0f b6 c0             	movzbl %al,%eax
c010664f:	85 c0                	test   %eax,%eax
c0106651:	75 24                	jne    c0106677 <buddy_init_memmap+0x8c>
c0106653:	c7 44 24 0c 11 b3 10 	movl   $0xc010b311,0xc(%esp)
c010665a:	c0 
c010665b:	c7 44 24 08 be b2 10 	movl   $0xc010b2be,0x8(%esp)
c0106662:	c0 
c0106663:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
c010666a:	00 
c010666b:	c7 04 24 d3 b2 10 c0 	movl   $0xc010b2d3,(%esp)
c0106672:	e8 bf 9d ff ff       	call   c0100436 <__panic>
        p->flags = p->property = 0;
c0106677:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010667a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
c0106681:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106684:	8b 50 08             	mov    0x8(%eax),%edx
c0106687:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010668a:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
c010668d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0106694:	00 
c0106695:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106698:	89 04 24             	mov    %eax,(%esp)
c010669b:	e8 fb f1 ff ff       	call   c010589b <set_page_ref>
    for (struct Page *p = base; p < base + n; p++) {
c01066a0:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c01066a4:	8b 55 0c             	mov    0xc(%ebp),%edx
c01066a7:	89 d0                	mov    %edx,%eax
c01066a9:	c1 e0 02             	shl    $0x2,%eax
c01066ac:	01 d0                	add    %edx,%eax
c01066ae:	c1 e0 02             	shl    $0x2,%eax
c01066b1:	89 c2                	mov    %eax,%edx
c01066b3:	8b 45 08             	mov    0x8(%ebp),%eax
c01066b6:	01 d0                	add    %edx,%eax
c01066b8:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c01066bb:	0f 82 66 ff ff ff    	jb     c0106627 <buddy_init_memmap+0x3c>
    }
    // Init size
    buddy_init_size(n);
c01066c1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01066c4:	89 04 24             	mov    %eax,(%esp)
c01066c7:	e8 dd f1 ff ff       	call   c01058a9 <buddy_init_size>
    // Init segment
    buddy_init_segment(base);
c01066cc:	8b 45 08             	mov    0x8(%ebp),%eax
c01066cf:	89 04 24             	mov    %eax,(%esp)
c01066d2:	e8 db f6 ff ff       	call   c0105db2 <buddy_init_segment>
}
c01066d7:	90                   	nop
c01066d8:	c9                   	leave  
c01066d9:	c3                   	ret    

c01066da <buddy_alloc_pages>:

static struct Page *
buddy_alloc_pages(size_t n) {
c01066da:	f3 0f 1e fb          	endbr32 
c01066de:	55                   	push   %ebp
c01066df:	89 e5                	mov    %esp,%ebp
c01066e1:	57                   	push   %edi
c01066e2:	56                   	push   %esi
c01066e3:	53                   	push   %ebx
c01066e4:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    assert(n > 0);
c01066ea:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01066ee:	75 24                	jne    c0106714 <buddy_alloc_pages+0x3a>
c01066f0:	c7 44 24 0c 0b b3 10 	movl   $0xc010b30b,0xc(%esp)
c01066f7:	c0 
c01066f8:	c7 44 24 08 be b2 10 	movl   $0xc010b2be,0x8(%esp)
c01066ff:	c0 
c0106700:	c7 44 24 04 79 00 00 	movl   $0x79,0x4(%esp)
c0106707:	00 
c0106708:	c7 04 24 d3 b2 10 c0 	movl   $0xc010b2d3,(%esp)
c010670f:	e8 22 9d ff ff       	call   c0100436 <__panic>
    struct Page *page;
    size_t block = BUDDY_ROOT;
c0106714:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
    size_t length = UINT32_ROUND_UP(n);
c010671b:	8b 45 08             	mov    0x8(%ebp),%eax
c010671e:	d1 e8                	shr    %eax
c0106720:	0b 45 08             	or     0x8(%ebp),%eax
c0106723:	8b 55 08             	mov    0x8(%ebp),%edx
c0106726:	d1 ea                	shr    %edx
c0106728:	0b 55 08             	or     0x8(%ebp),%edx
c010672b:	c1 ea 02             	shr    $0x2,%edx
c010672e:	09 d0                	or     %edx,%eax
c0106730:	89 c1                	mov    %eax,%ecx
c0106732:	8b 45 08             	mov    0x8(%ebp),%eax
c0106735:	d1 e8                	shr    %eax
c0106737:	0b 45 08             	or     0x8(%ebp),%eax
c010673a:	8b 55 08             	mov    0x8(%ebp),%edx
c010673d:	d1 ea                	shr    %edx
c010673f:	0b 55 08             	or     0x8(%ebp),%edx
c0106742:	c1 ea 02             	shr    $0x2,%edx
c0106745:	09 d0                	or     %edx,%eax
c0106747:	c1 e8 04             	shr    $0x4,%eax
c010674a:	09 c1                	or     %eax,%ecx
c010674c:	8b 45 08             	mov    0x8(%ebp),%eax
c010674f:	d1 e8                	shr    %eax
c0106751:	0b 45 08             	or     0x8(%ebp),%eax
c0106754:	8b 55 08             	mov    0x8(%ebp),%edx
c0106757:	d1 ea                	shr    %edx
c0106759:	0b 55 08             	or     0x8(%ebp),%edx
c010675c:	c1 ea 02             	shr    $0x2,%edx
c010675f:	09 d0                	or     %edx,%eax
c0106761:	89 c3                	mov    %eax,%ebx
c0106763:	8b 45 08             	mov    0x8(%ebp),%eax
c0106766:	d1 e8                	shr    %eax
c0106768:	0b 45 08             	or     0x8(%ebp),%eax
c010676b:	8b 55 08             	mov    0x8(%ebp),%edx
c010676e:	d1 ea                	shr    %edx
c0106770:	0b 55 08             	or     0x8(%ebp),%edx
c0106773:	c1 ea 02             	shr    $0x2,%edx
c0106776:	09 d0                	or     %edx,%eax
c0106778:	c1 e8 04             	shr    $0x4,%eax
c010677b:	09 d8                	or     %ebx,%eax
c010677d:	c1 e8 08             	shr    $0x8,%eax
c0106780:	09 c1                	or     %eax,%ecx
c0106782:	8b 45 08             	mov    0x8(%ebp),%eax
c0106785:	d1 e8                	shr    %eax
c0106787:	0b 45 08             	or     0x8(%ebp),%eax
c010678a:	8b 55 08             	mov    0x8(%ebp),%edx
c010678d:	d1 ea                	shr    %edx
c010678f:	0b 55 08             	or     0x8(%ebp),%edx
c0106792:	c1 ea 02             	shr    $0x2,%edx
c0106795:	09 d0                	or     %edx,%eax
c0106797:	89 c3                	mov    %eax,%ebx
c0106799:	8b 45 08             	mov    0x8(%ebp),%eax
c010679c:	d1 e8                	shr    %eax
c010679e:	0b 45 08             	or     0x8(%ebp),%eax
c01067a1:	8b 55 08             	mov    0x8(%ebp),%edx
c01067a4:	d1 ea                	shr    %edx
c01067a6:	0b 55 08             	or     0x8(%ebp),%edx
c01067a9:	c1 ea 02             	shr    $0x2,%edx
c01067ac:	09 d0                	or     %edx,%eax
c01067ae:	c1 e8 04             	shr    $0x4,%eax
c01067b1:	09 c3                	or     %eax,%ebx
c01067b3:	8b 45 08             	mov    0x8(%ebp),%eax
c01067b6:	d1 e8                	shr    %eax
c01067b8:	0b 45 08             	or     0x8(%ebp),%eax
c01067bb:	8b 55 08             	mov    0x8(%ebp),%edx
c01067be:	d1 ea                	shr    %edx
c01067c0:	0b 55 08             	or     0x8(%ebp),%edx
c01067c3:	c1 ea 02             	shr    $0x2,%edx
c01067c6:	09 d0                	or     %edx,%eax
c01067c8:	89 c6                	mov    %eax,%esi
c01067ca:	8b 45 08             	mov    0x8(%ebp),%eax
c01067cd:	d1 e8                	shr    %eax
c01067cf:	0b 45 08             	or     0x8(%ebp),%eax
c01067d2:	8b 55 08             	mov    0x8(%ebp),%edx
c01067d5:	d1 ea                	shr    %edx
c01067d7:	0b 55 08             	or     0x8(%ebp),%edx
c01067da:	c1 ea 02             	shr    $0x2,%edx
c01067dd:	09 d0                	or     %edx,%eax
c01067df:	c1 e8 04             	shr    $0x4,%eax
c01067e2:	09 f0                	or     %esi,%eax
c01067e4:	c1 e8 08             	shr    $0x8,%eax
c01067e7:	09 d8                	or     %ebx,%eax
c01067e9:	c1 e8 10             	shr    $0x10,%eax
c01067ec:	09 c8                	or     %ecx,%eax
c01067ee:	d1 e8                	shr    %eax
c01067f0:	23 45 08             	and    0x8(%ebp),%eax
c01067f3:	85 c0                	test   %eax,%eax
c01067f5:	0f 84 de 00 00 00    	je     c01068d9 <buddy_alloc_pages+0x1ff>
c01067fb:	8b 45 08             	mov    0x8(%ebp),%eax
c01067fe:	d1 e8                	shr    %eax
c0106800:	0b 45 08             	or     0x8(%ebp),%eax
c0106803:	8b 55 08             	mov    0x8(%ebp),%edx
c0106806:	d1 ea                	shr    %edx
c0106808:	0b 55 08             	or     0x8(%ebp),%edx
c010680b:	c1 ea 02             	shr    $0x2,%edx
c010680e:	09 d0                	or     %edx,%eax
c0106810:	89 c1                	mov    %eax,%ecx
c0106812:	8b 45 08             	mov    0x8(%ebp),%eax
c0106815:	d1 e8                	shr    %eax
c0106817:	0b 45 08             	or     0x8(%ebp),%eax
c010681a:	8b 55 08             	mov    0x8(%ebp),%edx
c010681d:	d1 ea                	shr    %edx
c010681f:	0b 55 08             	or     0x8(%ebp),%edx
c0106822:	c1 ea 02             	shr    $0x2,%edx
c0106825:	09 d0                	or     %edx,%eax
c0106827:	c1 e8 04             	shr    $0x4,%eax
c010682a:	09 c1                	or     %eax,%ecx
c010682c:	8b 45 08             	mov    0x8(%ebp),%eax
c010682f:	d1 e8                	shr    %eax
c0106831:	0b 45 08             	or     0x8(%ebp),%eax
c0106834:	8b 55 08             	mov    0x8(%ebp),%edx
c0106837:	d1 ea                	shr    %edx
c0106839:	0b 55 08             	or     0x8(%ebp),%edx
c010683c:	c1 ea 02             	shr    $0x2,%edx
c010683f:	09 d0                	or     %edx,%eax
c0106841:	89 c3                	mov    %eax,%ebx
c0106843:	8b 45 08             	mov    0x8(%ebp),%eax
c0106846:	d1 e8                	shr    %eax
c0106848:	0b 45 08             	or     0x8(%ebp),%eax
c010684b:	8b 55 08             	mov    0x8(%ebp),%edx
c010684e:	d1 ea                	shr    %edx
c0106850:	0b 55 08             	or     0x8(%ebp),%edx
c0106853:	c1 ea 02             	shr    $0x2,%edx
c0106856:	09 d0                	or     %edx,%eax
c0106858:	c1 e8 04             	shr    $0x4,%eax
c010685b:	09 d8                	or     %ebx,%eax
c010685d:	c1 e8 08             	shr    $0x8,%eax
c0106860:	09 c1                	or     %eax,%ecx
c0106862:	8b 45 08             	mov    0x8(%ebp),%eax
c0106865:	d1 e8                	shr    %eax
c0106867:	0b 45 08             	or     0x8(%ebp),%eax
c010686a:	8b 55 08             	mov    0x8(%ebp),%edx
c010686d:	d1 ea                	shr    %edx
c010686f:	0b 55 08             	or     0x8(%ebp),%edx
c0106872:	c1 ea 02             	shr    $0x2,%edx
c0106875:	09 d0                	or     %edx,%eax
c0106877:	89 c3                	mov    %eax,%ebx
c0106879:	8b 45 08             	mov    0x8(%ebp),%eax
c010687c:	d1 e8                	shr    %eax
c010687e:	0b 45 08             	or     0x8(%ebp),%eax
c0106881:	8b 55 08             	mov    0x8(%ebp),%edx
c0106884:	d1 ea                	shr    %edx
c0106886:	0b 55 08             	or     0x8(%ebp),%edx
c0106889:	c1 ea 02             	shr    $0x2,%edx
c010688c:	09 d0                	or     %edx,%eax
c010688e:	c1 e8 04             	shr    $0x4,%eax
c0106891:	09 c3                	or     %eax,%ebx
c0106893:	8b 45 08             	mov    0x8(%ebp),%eax
c0106896:	d1 e8                	shr    %eax
c0106898:	0b 45 08             	or     0x8(%ebp),%eax
c010689b:	8b 55 08             	mov    0x8(%ebp),%edx
c010689e:	d1 ea                	shr    %edx
c01068a0:	0b 55 08             	or     0x8(%ebp),%edx
c01068a3:	c1 ea 02             	shr    $0x2,%edx
c01068a6:	09 d0                	or     %edx,%eax
c01068a8:	89 c6                	mov    %eax,%esi
c01068aa:	8b 45 08             	mov    0x8(%ebp),%eax
c01068ad:	d1 e8                	shr    %eax
c01068af:	0b 45 08             	or     0x8(%ebp),%eax
c01068b2:	8b 55 08             	mov    0x8(%ebp),%edx
c01068b5:	d1 ea                	shr    %edx
c01068b7:	0b 55 08             	or     0x8(%ebp),%edx
c01068ba:	c1 ea 02             	shr    $0x2,%edx
c01068bd:	09 d0                	or     %edx,%eax
c01068bf:	c1 e8 04             	shr    $0x4,%eax
c01068c2:	09 f0                	or     %esi,%eax
c01068c4:	c1 e8 08             	shr    $0x8,%eax
c01068c7:	09 d8                	or     %ebx,%eax
c01068c9:	c1 e8 10             	shr    $0x10,%eax
c01068cc:	09 c8                	or     %ecx,%eax
c01068ce:	d1 e8                	shr    %eax
c01068d0:	f7 d0                	not    %eax
c01068d2:	23 45 08             	and    0x8(%ebp),%eax
c01068d5:	01 c0                	add    %eax,%eax
c01068d7:	eb 03                	jmp    c01068dc <buddy_alloc_pages+0x202>
c01068d9:	8b 45 08             	mov    0x8(%ebp),%eax
c01068dc:	89 45 e0             	mov    %eax,-0x20(%ebp)
    // Find block
    while (length <= buddy_segment[block] && length < BUDDY_LENGTH(block)) {
c01068df:	e9 f3 09 00 00       	jmp    c01072d7 <buddy_alloc_pages+0xbfd>
        size_t left = BUDDY_LEFT(block);
c01068e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01068e7:	01 c0                	add    %eax,%eax
c01068e9:	89 45 dc             	mov    %eax,-0x24(%ebp)
        size_t right = BUDDY_RIGHT(block);
c01068ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01068ef:	01 c0                	add    %eax,%eax
c01068f1:	40                   	inc    %eax
c01068f2:	89 45 d8             	mov    %eax,-0x28(%ebp)
        if (BUDDY_EMPTY(block)) {                   // Split
c01068f5:	a1 1c 3f 12 c0       	mov    0xc0123f1c,%eax
c01068fa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01068fd:	c1 e2 02             	shl    $0x2,%edx
c0106900:	01 d0                	add    %edx,%eax
c0106902:	8b 00                	mov    (%eax),%eax
c0106904:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
c010690a:	8b 3d 10 3f 12 c0    	mov    0xc0123f10,%edi
c0106910:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106913:	d1 e8                	shr    %eax
c0106915:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0106918:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010691b:	d1 ea                	shr    %edx
c010691d:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0106920:	c1 ea 02             	shr    $0x2,%edx
c0106923:	09 d0                	or     %edx,%eax
c0106925:	89 c1                	mov    %eax,%ecx
c0106927:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010692a:	d1 e8                	shr    %eax
c010692c:	0b 45 e4             	or     -0x1c(%ebp),%eax
c010692f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106932:	d1 ea                	shr    %edx
c0106934:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0106937:	c1 ea 02             	shr    $0x2,%edx
c010693a:	09 d0                	or     %edx,%eax
c010693c:	c1 e8 04             	shr    $0x4,%eax
c010693f:	09 c1                	or     %eax,%ecx
c0106941:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106944:	d1 e8                	shr    %eax
c0106946:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0106949:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010694c:	d1 ea                	shr    %edx
c010694e:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0106951:	c1 ea 02             	shr    $0x2,%edx
c0106954:	09 d0                	or     %edx,%eax
c0106956:	89 c3                	mov    %eax,%ebx
c0106958:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010695b:	d1 e8                	shr    %eax
c010695d:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0106960:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106963:	d1 ea                	shr    %edx
c0106965:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0106968:	c1 ea 02             	shr    $0x2,%edx
c010696b:	09 d0                	or     %edx,%eax
c010696d:	c1 e8 04             	shr    $0x4,%eax
c0106970:	09 d8                	or     %ebx,%eax
c0106972:	c1 e8 08             	shr    $0x8,%eax
c0106975:	89 cb                	mov    %ecx,%ebx
c0106977:	09 c3                	or     %eax,%ebx
c0106979:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010697c:	d1 e8                	shr    %eax
c010697e:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0106981:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106984:	d1 ea                	shr    %edx
c0106986:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0106989:	c1 ea 02             	shr    $0x2,%edx
c010698c:	09 d0                	or     %edx,%eax
c010698e:	89 c1                	mov    %eax,%ecx
c0106990:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106993:	d1 e8                	shr    %eax
c0106995:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0106998:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010699b:	d1 ea                	shr    %edx
c010699d:	0b 55 e4             	or     -0x1c(%ebp),%edx
c01069a0:	c1 ea 02             	shr    $0x2,%edx
c01069a3:	09 d0                	or     %edx,%eax
c01069a5:	c1 e8 04             	shr    $0x4,%eax
c01069a8:	09 c1                	or     %eax,%ecx
c01069aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01069ad:	d1 e8                	shr    %eax
c01069af:	0b 45 e4             	or     -0x1c(%ebp),%eax
c01069b2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01069b5:	d1 ea                	shr    %edx
c01069b7:	0b 55 e4             	or     -0x1c(%ebp),%edx
c01069ba:	c1 ea 02             	shr    $0x2,%edx
c01069bd:	09 d0                	or     %edx,%eax
c01069bf:	89 c6                	mov    %eax,%esi
c01069c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01069c4:	d1 e8                	shr    %eax
c01069c6:	0b 45 e4             	or     -0x1c(%ebp),%eax
c01069c9:	89 c2                	mov    %eax,%edx
c01069cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01069ce:	d1 e8                	shr    %eax
c01069d0:	0b 45 e4             	or     -0x1c(%ebp),%eax
c01069d3:	c1 e8 02             	shr    $0x2,%eax
c01069d6:	09 d0                	or     %edx,%eax
c01069d8:	c1 e8 04             	shr    $0x4,%eax
c01069db:	09 f0                	or     %esi,%eax
c01069dd:	c1 e8 08             	shr    $0x8,%eax
c01069e0:	09 c8                	or     %ecx,%eax
c01069e2:	c1 e8 10             	shr    $0x10,%eax
c01069e5:	09 d8                	or     %ebx,%eax
c01069e7:	d1 e8                	shr    %eax
c01069e9:	23 45 e4             	and    -0x1c(%ebp),%eax
c01069ec:	85 c0                	test   %eax,%eax
c01069ee:	0f 84 e2 00 00 00    	je     c0106ad6 <buddy_alloc_pages+0x3fc>
c01069f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01069f7:	d1 e8                	shr    %eax
c01069f9:	0b 45 e4             	or     -0x1c(%ebp),%eax
c01069fc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01069ff:	d1 ea                	shr    %edx
c0106a01:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0106a04:	c1 ea 02             	shr    $0x2,%edx
c0106a07:	09 d0                	or     %edx,%eax
c0106a09:	89 c1                	mov    %eax,%ecx
c0106a0b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106a0e:	d1 e8                	shr    %eax
c0106a10:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0106a13:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106a16:	d1 ea                	shr    %edx
c0106a18:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0106a1b:	c1 ea 02             	shr    $0x2,%edx
c0106a1e:	09 d0                	or     %edx,%eax
c0106a20:	c1 e8 04             	shr    $0x4,%eax
c0106a23:	09 c1                	or     %eax,%ecx
c0106a25:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106a28:	d1 e8                	shr    %eax
c0106a2a:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0106a2d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106a30:	d1 ea                	shr    %edx
c0106a32:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0106a35:	c1 ea 02             	shr    $0x2,%edx
c0106a38:	09 d0                	or     %edx,%eax
c0106a3a:	89 c3                	mov    %eax,%ebx
c0106a3c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106a3f:	d1 e8                	shr    %eax
c0106a41:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0106a44:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106a47:	d1 ea                	shr    %edx
c0106a49:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0106a4c:	c1 ea 02             	shr    $0x2,%edx
c0106a4f:	09 d0                	or     %edx,%eax
c0106a51:	c1 e8 04             	shr    $0x4,%eax
c0106a54:	09 d8                	or     %ebx,%eax
c0106a56:	c1 e8 08             	shr    $0x8,%eax
c0106a59:	89 cb                	mov    %ecx,%ebx
c0106a5b:	09 c3                	or     %eax,%ebx
c0106a5d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106a60:	d1 e8                	shr    %eax
c0106a62:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0106a65:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106a68:	d1 ea                	shr    %edx
c0106a6a:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0106a6d:	c1 ea 02             	shr    $0x2,%edx
c0106a70:	09 d0                	or     %edx,%eax
c0106a72:	89 c1                	mov    %eax,%ecx
c0106a74:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106a77:	d1 e8                	shr    %eax
c0106a79:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0106a7c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106a7f:	d1 ea                	shr    %edx
c0106a81:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0106a84:	c1 ea 02             	shr    $0x2,%edx
c0106a87:	09 d0                	or     %edx,%eax
c0106a89:	c1 e8 04             	shr    $0x4,%eax
c0106a8c:	09 c1                	or     %eax,%ecx
c0106a8e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106a91:	d1 e8                	shr    %eax
c0106a93:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0106a96:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106a99:	d1 ea                	shr    %edx
c0106a9b:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0106a9e:	c1 ea 02             	shr    $0x2,%edx
c0106aa1:	09 d0                	or     %edx,%eax
c0106aa3:	89 c6                	mov    %eax,%esi
c0106aa5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106aa8:	d1 e8                	shr    %eax
c0106aaa:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0106aad:	89 c2                	mov    %eax,%edx
c0106aaf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106ab2:	d1 e8                	shr    %eax
c0106ab4:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0106ab7:	c1 e8 02             	shr    $0x2,%eax
c0106aba:	09 d0                	or     %edx,%eax
c0106abc:	c1 e8 04             	shr    $0x4,%eax
c0106abf:	09 f0                	or     %esi,%eax
c0106ac1:	c1 e8 08             	shr    $0x8,%eax
c0106ac4:	09 c8                	or     %ecx,%eax
c0106ac6:	c1 e8 10             	shr    $0x10,%eax
c0106ac9:	09 d8                	or     %ebx,%eax
c0106acb:	d1 e8                	shr    %eax
c0106acd:	f7 d0                	not    %eax
c0106acf:	23 45 e4             	and    -0x1c(%ebp),%eax
c0106ad2:	89 c6                	mov    %eax,%esi
c0106ad4:	eb 03                	jmp    c0106ad9 <buddy_alloc_pages+0x3ff>
c0106ad6:	8b 75 e4             	mov    -0x1c(%ebp),%esi
c0106ad9:	89 f8                	mov    %edi,%eax
c0106adb:	ba 00 00 00 00       	mov    $0x0,%edx
c0106ae0:	f7 f6                	div    %esi
c0106ae2:	39 85 74 ff ff ff    	cmp    %eax,-0x8c(%ebp)
c0106ae8:	0f 85 51 07 00 00    	jne    c010723f <buddy_alloc_pages+0xb65>
            size_t begin = BUDDY_BEGIN(block);
c0106aee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106af1:	d1 e8                	shr    %eax
c0106af3:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0106af6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106af9:	d1 ea                	shr    %edx
c0106afb:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0106afe:	c1 ea 02             	shr    $0x2,%edx
c0106b01:	09 d0                	or     %edx,%eax
c0106b03:	89 c1                	mov    %eax,%ecx
c0106b05:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106b08:	d1 e8                	shr    %eax
c0106b0a:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0106b0d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106b10:	d1 ea                	shr    %edx
c0106b12:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0106b15:	c1 ea 02             	shr    $0x2,%edx
c0106b18:	09 d0                	or     %edx,%eax
c0106b1a:	c1 e8 04             	shr    $0x4,%eax
c0106b1d:	09 c1                	or     %eax,%ecx
c0106b1f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106b22:	d1 e8                	shr    %eax
c0106b24:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0106b27:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106b2a:	d1 ea                	shr    %edx
c0106b2c:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0106b2f:	c1 ea 02             	shr    $0x2,%edx
c0106b32:	09 d0                	or     %edx,%eax
c0106b34:	89 c3                	mov    %eax,%ebx
c0106b36:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106b39:	d1 e8                	shr    %eax
c0106b3b:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0106b3e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106b41:	d1 ea                	shr    %edx
c0106b43:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0106b46:	c1 ea 02             	shr    $0x2,%edx
c0106b49:	09 d0                	or     %edx,%eax
c0106b4b:	c1 e8 04             	shr    $0x4,%eax
c0106b4e:	09 d8                	or     %ebx,%eax
c0106b50:	c1 e8 08             	shr    $0x8,%eax
c0106b53:	09 c1                	or     %eax,%ecx
c0106b55:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106b58:	d1 e8                	shr    %eax
c0106b5a:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0106b5d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106b60:	d1 ea                	shr    %edx
c0106b62:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0106b65:	c1 ea 02             	shr    $0x2,%edx
c0106b68:	09 d0                	or     %edx,%eax
c0106b6a:	89 c3                	mov    %eax,%ebx
c0106b6c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106b6f:	d1 e8                	shr    %eax
c0106b71:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0106b74:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106b77:	d1 ea                	shr    %edx
c0106b79:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0106b7c:	c1 ea 02             	shr    $0x2,%edx
c0106b7f:	09 d0                	or     %edx,%eax
c0106b81:	c1 e8 04             	shr    $0x4,%eax
c0106b84:	09 c3                	or     %eax,%ebx
c0106b86:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106b89:	d1 e8                	shr    %eax
c0106b8b:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0106b8e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106b91:	d1 ea                	shr    %edx
c0106b93:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0106b96:	c1 ea 02             	shr    $0x2,%edx
c0106b99:	09 d0                	or     %edx,%eax
c0106b9b:	89 c6                	mov    %eax,%esi
c0106b9d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106ba0:	d1 e8                	shr    %eax
c0106ba2:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0106ba5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106ba8:	d1 ea                	shr    %edx
c0106baa:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0106bad:	c1 ea 02             	shr    $0x2,%edx
c0106bb0:	09 d0                	or     %edx,%eax
c0106bb2:	c1 e8 04             	shr    $0x4,%eax
c0106bb5:	09 f0                	or     %esi,%eax
c0106bb7:	c1 e8 08             	shr    $0x8,%eax
c0106bba:	09 d8                	or     %ebx,%eax
c0106bbc:	c1 e8 10             	shr    $0x10,%eax
c0106bbf:	09 c8                	or     %ecx,%eax
c0106bc1:	d1 e8                	shr    %eax
c0106bc3:	23 45 e4             	and    -0x1c(%ebp),%eax
c0106bc6:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
c0106bcc:	8b 3d 10 3f 12 c0    	mov    0xc0123f10,%edi
c0106bd2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106bd5:	d1 e8                	shr    %eax
c0106bd7:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0106bda:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106bdd:	d1 ea                	shr    %edx
c0106bdf:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0106be2:	c1 ea 02             	shr    $0x2,%edx
c0106be5:	09 d0                	or     %edx,%eax
c0106be7:	89 c1                	mov    %eax,%ecx
c0106be9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106bec:	d1 e8                	shr    %eax
c0106bee:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0106bf1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106bf4:	d1 ea                	shr    %edx
c0106bf6:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0106bf9:	c1 ea 02             	shr    $0x2,%edx
c0106bfc:	09 d0                	or     %edx,%eax
c0106bfe:	c1 e8 04             	shr    $0x4,%eax
c0106c01:	09 c1                	or     %eax,%ecx
c0106c03:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106c06:	d1 e8                	shr    %eax
c0106c08:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0106c0b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106c0e:	d1 ea                	shr    %edx
c0106c10:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0106c13:	c1 ea 02             	shr    $0x2,%edx
c0106c16:	09 d0                	or     %edx,%eax
c0106c18:	89 c3                	mov    %eax,%ebx
c0106c1a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106c1d:	d1 e8                	shr    %eax
c0106c1f:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0106c22:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106c25:	d1 ea                	shr    %edx
c0106c27:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0106c2a:	c1 ea 02             	shr    $0x2,%edx
c0106c2d:	09 d0                	or     %edx,%eax
c0106c2f:	c1 e8 04             	shr    $0x4,%eax
c0106c32:	09 d8                	or     %ebx,%eax
c0106c34:	c1 e8 08             	shr    $0x8,%eax
c0106c37:	89 cb                	mov    %ecx,%ebx
c0106c39:	09 c3                	or     %eax,%ebx
c0106c3b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106c3e:	d1 e8                	shr    %eax
c0106c40:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0106c43:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106c46:	d1 ea                	shr    %edx
c0106c48:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0106c4b:	c1 ea 02             	shr    $0x2,%edx
c0106c4e:	09 d0                	or     %edx,%eax
c0106c50:	89 c1                	mov    %eax,%ecx
c0106c52:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106c55:	d1 e8                	shr    %eax
c0106c57:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0106c5a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106c5d:	d1 ea                	shr    %edx
c0106c5f:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0106c62:	c1 ea 02             	shr    $0x2,%edx
c0106c65:	09 d0                	or     %edx,%eax
c0106c67:	c1 e8 04             	shr    $0x4,%eax
c0106c6a:	09 c1                	or     %eax,%ecx
c0106c6c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106c6f:	d1 e8                	shr    %eax
c0106c71:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0106c74:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106c77:	d1 ea                	shr    %edx
c0106c79:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0106c7c:	c1 ea 02             	shr    $0x2,%edx
c0106c7f:	09 d0                	or     %edx,%eax
c0106c81:	89 c6                	mov    %eax,%esi
c0106c83:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106c86:	d1 e8                	shr    %eax
c0106c88:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0106c8b:	89 c2                	mov    %eax,%edx
c0106c8d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106c90:	d1 e8                	shr    %eax
c0106c92:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0106c95:	c1 e8 02             	shr    $0x2,%eax
c0106c98:	09 d0                	or     %edx,%eax
c0106c9a:	c1 e8 04             	shr    $0x4,%eax
c0106c9d:	09 f0                	or     %esi,%eax
c0106c9f:	c1 e8 08             	shr    $0x8,%eax
c0106ca2:	09 c8                	or     %ecx,%eax
c0106ca4:	c1 e8 10             	shr    $0x10,%eax
c0106ca7:	09 d8                	or     %ebx,%eax
c0106ca9:	d1 e8                	shr    %eax
c0106cab:	23 45 e4             	and    -0x1c(%ebp),%eax
c0106cae:	85 c0                	test   %eax,%eax
c0106cb0:	0f 84 e2 00 00 00    	je     c0106d98 <buddy_alloc_pages+0x6be>
c0106cb6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106cb9:	d1 e8                	shr    %eax
c0106cbb:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0106cbe:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106cc1:	d1 ea                	shr    %edx
c0106cc3:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0106cc6:	c1 ea 02             	shr    $0x2,%edx
c0106cc9:	09 d0                	or     %edx,%eax
c0106ccb:	89 c1                	mov    %eax,%ecx
c0106ccd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106cd0:	d1 e8                	shr    %eax
c0106cd2:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0106cd5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106cd8:	d1 ea                	shr    %edx
c0106cda:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0106cdd:	c1 ea 02             	shr    $0x2,%edx
c0106ce0:	09 d0                	or     %edx,%eax
c0106ce2:	c1 e8 04             	shr    $0x4,%eax
c0106ce5:	09 c1                	or     %eax,%ecx
c0106ce7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106cea:	d1 e8                	shr    %eax
c0106cec:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0106cef:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106cf2:	d1 ea                	shr    %edx
c0106cf4:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0106cf7:	c1 ea 02             	shr    $0x2,%edx
c0106cfa:	09 d0                	or     %edx,%eax
c0106cfc:	89 c3                	mov    %eax,%ebx
c0106cfe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106d01:	d1 e8                	shr    %eax
c0106d03:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0106d06:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106d09:	d1 ea                	shr    %edx
c0106d0b:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0106d0e:	c1 ea 02             	shr    $0x2,%edx
c0106d11:	09 d0                	or     %edx,%eax
c0106d13:	c1 e8 04             	shr    $0x4,%eax
c0106d16:	09 d8                	or     %ebx,%eax
c0106d18:	c1 e8 08             	shr    $0x8,%eax
c0106d1b:	89 cb                	mov    %ecx,%ebx
c0106d1d:	09 c3                	or     %eax,%ebx
c0106d1f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106d22:	d1 e8                	shr    %eax
c0106d24:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0106d27:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106d2a:	d1 ea                	shr    %edx
c0106d2c:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0106d2f:	c1 ea 02             	shr    $0x2,%edx
c0106d32:	09 d0                	or     %edx,%eax
c0106d34:	89 c1                	mov    %eax,%ecx
c0106d36:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106d39:	d1 e8                	shr    %eax
c0106d3b:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0106d3e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106d41:	d1 ea                	shr    %edx
c0106d43:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0106d46:	c1 ea 02             	shr    $0x2,%edx
c0106d49:	09 d0                	or     %edx,%eax
c0106d4b:	c1 e8 04             	shr    $0x4,%eax
c0106d4e:	09 c1                	or     %eax,%ecx
c0106d50:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106d53:	d1 e8                	shr    %eax
c0106d55:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0106d58:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106d5b:	d1 ea                	shr    %edx
c0106d5d:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0106d60:	c1 ea 02             	shr    $0x2,%edx
c0106d63:	09 d0                	or     %edx,%eax
c0106d65:	89 c6                	mov    %eax,%esi
c0106d67:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106d6a:	d1 e8                	shr    %eax
c0106d6c:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0106d6f:	89 c2                	mov    %eax,%edx
c0106d71:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106d74:	d1 e8                	shr    %eax
c0106d76:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0106d79:	c1 e8 02             	shr    $0x2,%eax
c0106d7c:	09 d0                	or     %edx,%eax
c0106d7e:	c1 e8 04             	shr    $0x4,%eax
c0106d81:	09 f0                	or     %esi,%eax
c0106d83:	c1 e8 08             	shr    $0x8,%eax
c0106d86:	09 c8                	or     %ecx,%eax
c0106d88:	c1 e8 10             	shr    $0x10,%eax
c0106d8b:	09 d8                	or     %ebx,%eax
c0106d8d:	d1 e8                	shr    %eax
c0106d8f:	f7 d0                	not    %eax
c0106d91:	23 45 e4             	and    -0x1c(%ebp),%eax
c0106d94:	89 c6                	mov    %eax,%esi
c0106d96:	eb 03                	jmp    c0106d9b <buddy_alloc_pages+0x6c1>
c0106d98:	8b 75 e4             	mov    -0x1c(%ebp),%esi
c0106d9b:	89 f8                	mov    %edi,%eax
c0106d9d:	ba 00 00 00 00       	mov    $0x0,%edx
c0106da2:	f7 f6                	div    %esi
c0106da4:	0f af 85 74 ff ff ff 	imul   -0x8c(%ebp),%eax
c0106dab:	89 45 d4             	mov    %eax,-0x2c(%ebp)
            size_t end = BUDDY_END(block);
c0106dae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106db1:	d1 e8                	shr    %eax
c0106db3:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0106db6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106db9:	d1 ea                	shr    %edx
c0106dbb:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0106dbe:	c1 ea 02             	shr    $0x2,%edx
c0106dc1:	09 d0                	or     %edx,%eax
c0106dc3:	89 c1                	mov    %eax,%ecx
c0106dc5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106dc8:	d1 e8                	shr    %eax
c0106dca:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0106dcd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106dd0:	d1 ea                	shr    %edx
c0106dd2:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0106dd5:	c1 ea 02             	shr    $0x2,%edx
c0106dd8:	09 d0                	or     %edx,%eax
c0106dda:	c1 e8 04             	shr    $0x4,%eax
c0106ddd:	09 c1                	or     %eax,%ecx
c0106ddf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106de2:	d1 e8                	shr    %eax
c0106de4:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0106de7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106dea:	d1 ea                	shr    %edx
c0106dec:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0106def:	c1 ea 02             	shr    $0x2,%edx
c0106df2:	09 d0                	or     %edx,%eax
c0106df4:	89 c3                	mov    %eax,%ebx
c0106df6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106df9:	d1 e8                	shr    %eax
c0106dfb:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0106dfe:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106e01:	d1 ea                	shr    %edx
c0106e03:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0106e06:	c1 ea 02             	shr    $0x2,%edx
c0106e09:	09 d0                	or     %edx,%eax
c0106e0b:	c1 e8 04             	shr    $0x4,%eax
c0106e0e:	09 d8                	or     %ebx,%eax
c0106e10:	c1 e8 08             	shr    $0x8,%eax
c0106e13:	09 c1                	or     %eax,%ecx
c0106e15:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106e18:	d1 e8                	shr    %eax
c0106e1a:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0106e1d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106e20:	d1 ea                	shr    %edx
c0106e22:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0106e25:	c1 ea 02             	shr    $0x2,%edx
c0106e28:	09 d0                	or     %edx,%eax
c0106e2a:	89 c3                	mov    %eax,%ebx
c0106e2c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106e2f:	d1 e8                	shr    %eax
c0106e31:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0106e34:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106e37:	d1 ea                	shr    %edx
c0106e39:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0106e3c:	c1 ea 02             	shr    $0x2,%edx
c0106e3f:	09 d0                	or     %edx,%eax
c0106e41:	c1 e8 04             	shr    $0x4,%eax
c0106e44:	09 c3                	or     %eax,%ebx
c0106e46:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106e49:	d1 e8                	shr    %eax
c0106e4b:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0106e4e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106e51:	d1 ea                	shr    %edx
c0106e53:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0106e56:	c1 ea 02             	shr    $0x2,%edx
c0106e59:	09 d0                	or     %edx,%eax
c0106e5b:	89 c6                	mov    %eax,%esi
c0106e5d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106e60:	d1 e8                	shr    %eax
c0106e62:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0106e65:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106e68:	d1 ea                	shr    %edx
c0106e6a:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0106e6d:	c1 ea 02             	shr    $0x2,%edx
c0106e70:	09 d0                	or     %edx,%eax
c0106e72:	c1 e8 04             	shr    $0x4,%eax
c0106e75:	09 f0                	or     %esi,%eax
c0106e77:	c1 e8 08             	shr    $0x8,%eax
c0106e7a:	09 d8                	or     %ebx,%eax
c0106e7c:	c1 e8 10             	shr    $0x10,%eax
c0106e7f:	09 c8                	or     %ecx,%eax
c0106e81:	d1 e8                	shr    %eax
c0106e83:	23 45 e4             	and    -0x1c(%ebp),%eax
c0106e86:	40                   	inc    %eax
c0106e87:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
c0106e8d:	8b 3d 10 3f 12 c0    	mov    0xc0123f10,%edi
c0106e93:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106e96:	d1 e8                	shr    %eax
c0106e98:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0106e9b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106e9e:	d1 ea                	shr    %edx
c0106ea0:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0106ea3:	c1 ea 02             	shr    $0x2,%edx
c0106ea6:	09 d0                	or     %edx,%eax
c0106ea8:	89 c1                	mov    %eax,%ecx
c0106eaa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106ead:	d1 e8                	shr    %eax
c0106eaf:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0106eb2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106eb5:	d1 ea                	shr    %edx
c0106eb7:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0106eba:	c1 ea 02             	shr    $0x2,%edx
c0106ebd:	09 d0                	or     %edx,%eax
c0106ebf:	c1 e8 04             	shr    $0x4,%eax
c0106ec2:	09 c1                	or     %eax,%ecx
c0106ec4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106ec7:	d1 e8                	shr    %eax
c0106ec9:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0106ecc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106ecf:	d1 ea                	shr    %edx
c0106ed1:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0106ed4:	c1 ea 02             	shr    $0x2,%edx
c0106ed7:	09 d0                	or     %edx,%eax
c0106ed9:	89 c3                	mov    %eax,%ebx
c0106edb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106ede:	d1 e8                	shr    %eax
c0106ee0:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0106ee3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106ee6:	d1 ea                	shr    %edx
c0106ee8:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0106eeb:	c1 ea 02             	shr    $0x2,%edx
c0106eee:	09 d0                	or     %edx,%eax
c0106ef0:	c1 e8 04             	shr    $0x4,%eax
c0106ef3:	09 d8                	or     %ebx,%eax
c0106ef5:	c1 e8 08             	shr    $0x8,%eax
c0106ef8:	89 cb                	mov    %ecx,%ebx
c0106efa:	09 c3                	or     %eax,%ebx
c0106efc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106eff:	d1 e8                	shr    %eax
c0106f01:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0106f04:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106f07:	d1 ea                	shr    %edx
c0106f09:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0106f0c:	c1 ea 02             	shr    $0x2,%edx
c0106f0f:	09 d0                	or     %edx,%eax
c0106f11:	89 c1                	mov    %eax,%ecx
c0106f13:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106f16:	d1 e8                	shr    %eax
c0106f18:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0106f1b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106f1e:	d1 ea                	shr    %edx
c0106f20:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0106f23:	c1 ea 02             	shr    $0x2,%edx
c0106f26:	09 d0                	or     %edx,%eax
c0106f28:	c1 e8 04             	shr    $0x4,%eax
c0106f2b:	09 c1                	or     %eax,%ecx
c0106f2d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106f30:	d1 e8                	shr    %eax
c0106f32:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0106f35:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106f38:	d1 ea                	shr    %edx
c0106f3a:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0106f3d:	c1 ea 02             	shr    $0x2,%edx
c0106f40:	09 d0                	or     %edx,%eax
c0106f42:	89 c6                	mov    %eax,%esi
c0106f44:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106f47:	d1 e8                	shr    %eax
c0106f49:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0106f4c:	89 c2                	mov    %eax,%edx
c0106f4e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106f51:	d1 e8                	shr    %eax
c0106f53:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0106f56:	c1 e8 02             	shr    $0x2,%eax
c0106f59:	09 d0                	or     %edx,%eax
c0106f5b:	c1 e8 04             	shr    $0x4,%eax
c0106f5e:	09 f0                	or     %esi,%eax
c0106f60:	c1 e8 08             	shr    $0x8,%eax
c0106f63:	09 c8                	or     %ecx,%eax
c0106f65:	c1 e8 10             	shr    $0x10,%eax
c0106f68:	09 d8                	or     %ebx,%eax
c0106f6a:	d1 e8                	shr    %eax
c0106f6c:	23 45 e4             	and    -0x1c(%ebp),%eax
c0106f6f:	85 c0                	test   %eax,%eax
c0106f71:	0f 84 e2 00 00 00    	je     c0107059 <buddy_alloc_pages+0x97f>
c0106f77:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106f7a:	d1 e8                	shr    %eax
c0106f7c:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0106f7f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106f82:	d1 ea                	shr    %edx
c0106f84:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0106f87:	c1 ea 02             	shr    $0x2,%edx
c0106f8a:	09 d0                	or     %edx,%eax
c0106f8c:	89 c1                	mov    %eax,%ecx
c0106f8e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106f91:	d1 e8                	shr    %eax
c0106f93:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0106f96:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106f99:	d1 ea                	shr    %edx
c0106f9b:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0106f9e:	c1 ea 02             	shr    $0x2,%edx
c0106fa1:	09 d0                	or     %edx,%eax
c0106fa3:	c1 e8 04             	shr    $0x4,%eax
c0106fa6:	09 c1                	or     %eax,%ecx
c0106fa8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106fab:	d1 e8                	shr    %eax
c0106fad:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0106fb0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106fb3:	d1 ea                	shr    %edx
c0106fb5:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0106fb8:	c1 ea 02             	shr    $0x2,%edx
c0106fbb:	09 d0                	or     %edx,%eax
c0106fbd:	89 c3                	mov    %eax,%ebx
c0106fbf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106fc2:	d1 e8                	shr    %eax
c0106fc4:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0106fc7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106fca:	d1 ea                	shr    %edx
c0106fcc:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0106fcf:	c1 ea 02             	shr    $0x2,%edx
c0106fd2:	09 d0                	or     %edx,%eax
c0106fd4:	c1 e8 04             	shr    $0x4,%eax
c0106fd7:	09 d8                	or     %ebx,%eax
c0106fd9:	c1 e8 08             	shr    $0x8,%eax
c0106fdc:	89 cb                	mov    %ecx,%ebx
c0106fde:	09 c3                	or     %eax,%ebx
c0106fe0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106fe3:	d1 e8                	shr    %eax
c0106fe5:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0106fe8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106feb:	d1 ea                	shr    %edx
c0106fed:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0106ff0:	c1 ea 02             	shr    $0x2,%edx
c0106ff3:	09 d0                	or     %edx,%eax
c0106ff5:	89 c1                	mov    %eax,%ecx
c0106ff7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106ffa:	d1 e8                	shr    %eax
c0106ffc:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0106fff:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0107002:	d1 ea                	shr    %edx
c0107004:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0107007:	c1 ea 02             	shr    $0x2,%edx
c010700a:	09 d0                	or     %edx,%eax
c010700c:	c1 e8 04             	shr    $0x4,%eax
c010700f:	09 c1                	or     %eax,%ecx
c0107011:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107014:	d1 e8                	shr    %eax
c0107016:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0107019:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010701c:	d1 ea                	shr    %edx
c010701e:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0107021:	c1 ea 02             	shr    $0x2,%edx
c0107024:	09 d0                	or     %edx,%eax
c0107026:	89 c6                	mov    %eax,%esi
c0107028:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010702b:	d1 e8                	shr    %eax
c010702d:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0107030:	89 c2                	mov    %eax,%edx
c0107032:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107035:	d1 e8                	shr    %eax
c0107037:	0b 45 e4             	or     -0x1c(%ebp),%eax
c010703a:	c1 e8 02             	shr    $0x2,%eax
c010703d:	09 d0                	or     %edx,%eax
c010703f:	c1 e8 04             	shr    $0x4,%eax
c0107042:	09 f0                	or     %esi,%eax
c0107044:	c1 e8 08             	shr    $0x8,%eax
c0107047:	09 c8                	or     %ecx,%eax
c0107049:	c1 e8 10             	shr    $0x10,%eax
c010704c:	09 d8                	or     %ebx,%eax
c010704e:	d1 e8                	shr    %eax
c0107050:	f7 d0                	not    %eax
c0107052:	23 45 e4             	and    -0x1c(%ebp),%eax
c0107055:	89 c6                	mov    %eax,%esi
c0107057:	eb 03                	jmp    c010705c <buddy_alloc_pages+0x982>
c0107059:	8b 75 e4             	mov    -0x1c(%ebp),%esi
c010705c:	89 f8                	mov    %edi,%eax
c010705e:	ba 00 00 00 00       	mov    $0x0,%edx
c0107063:	f7 f6                	div    %esi
c0107065:	0f af 85 74 ff ff ff 	imul   -0x8c(%ebp),%eax
c010706c:	89 45 d0             	mov    %eax,-0x30(%ebp)
            size_t mid = (begin+end)>>1;
c010706f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0107072:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0107075:	01 d0                	add    %edx,%eax
c0107077:	d1 e8                	shr    %eax
c0107079:	89 45 cc             	mov    %eax,-0x34(%ebp)
            list_del(&(buddy_alloc[begin].page_link));
c010707c:	8b 0d 24 3f 12 c0    	mov    0xc0123f24,%ecx
c0107082:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0107085:	89 d0                	mov    %edx,%eax
c0107087:	c1 e0 02             	shl    $0x2,%eax
c010708a:	01 d0                	add    %edx,%eax
c010708c:	c1 e0 02             	shl    $0x2,%eax
c010708f:	01 c8                	add    %ecx,%eax
c0107091:	83 c0 0c             	add    $0xc,%eax
c0107094:	89 45 8c             	mov    %eax,-0x74(%ebp)
    __list_del(listelm->prev, listelm->next);
c0107097:	8b 45 8c             	mov    -0x74(%ebp),%eax
c010709a:	8b 40 04             	mov    0x4(%eax),%eax
c010709d:	8b 55 8c             	mov    -0x74(%ebp),%edx
c01070a0:	8b 12                	mov    (%edx),%edx
c01070a2:	89 55 88             	mov    %edx,-0x78(%ebp)
c01070a5:	89 45 84             	mov    %eax,-0x7c(%ebp)
    prev->next = next;
c01070a8:	8b 45 88             	mov    -0x78(%ebp),%eax
c01070ab:	8b 55 84             	mov    -0x7c(%ebp),%edx
c01070ae:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c01070b1:	8b 45 84             	mov    -0x7c(%ebp),%eax
c01070b4:	8b 55 88             	mov    -0x78(%ebp),%edx
c01070b7:	89 10                	mov    %edx,(%eax)
}
c01070b9:	90                   	nop
}
c01070ba:	90                   	nop
            buddy_alloc[begin].property >>= 1;
c01070bb:	8b 0d 24 3f 12 c0    	mov    0xc0123f24,%ecx
c01070c1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01070c4:	89 d0                	mov    %edx,%eax
c01070c6:	c1 e0 02             	shl    $0x2,%eax
c01070c9:	01 d0                	add    %edx,%eax
c01070cb:	c1 e0 02             	shl    $0x2,%eax
c01070ce:	01 c8                	add    %ecx,%eax
c01070d0:	8b 48 08             	mov    0x8(%eax),%ecx
c01070d3:	8b 1d 24 3f 12 c0    	mov    0xc0123f24,%ebx
c01070d9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01070dc:	89 d0                	mov    %edx,%eax
c01070de:	c1 e0 02             	shl    $0x2,%eax
c01070e1:	01 d0                	add    %edx,%eax
c01070e3:	c1 e0 02             	shl    $0x2,%eax
c01070e6:	01 d8                	add    %ebx,%eax
c01070e8:	d1 e9                	shr    %ecx
c01070ea:	89 ca                	mov    %ecx,%edx
c01070ec:	89 50 08             	mov    %edx,0x8(%eax)
            buddy_alloc[mid].property = buddy_alloc[begin].property;
c01070ef:	8b 0d 24 3f 12 c0    	mov    0xc0123f24,%ecx
c01070f5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01070f8:	89 d0                	mov    %edx,%eax
c01070fa:	c1 e0 02             	shl    $0x2,%eax
c01070fd:	01 d0                	add    %edx,%eax
c01070ff:	c1 e0 02             	shl    $0x2,%eax
c0107102:	01 c1                	add    %eax,%ecx
c0107104:	8b 1d 24 3f 12 c0    	mov    0xc0123f24,%ebx
c010710a:	8b 55 cc             	mov    -0x34(%ebp),%edx
c010710d:	89 d0                	mov    %edx,%eax
c010710f:	c1 e0 02             	shl    $0x2,%eax
c0107112:	01 d0                	add    %edx,%eax
c0107114:	c1 e0 02             	shl    $0x2,%eax
c0107117:	8d 14 03             	lea    (%ebx,%eax,1),%edx
c010711a:	8b 41 08             	mov    0x8(%ecx),%eax
c010711d:	89 42 08             	mov    %eax,0x8(%edx)
            buddy_segment[left] = buddy_segment[block]>>1;
c0107120:	a1 1c 3f 12 c0       	mov    0xc0123f1c,%eax
c0107125:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0107128:	c1 e2 02             	shl    $0x2,%edx
c010712b:	01 d0                	add    %edx,%eax
c010712d:	8b 10                	mov    (%eax),%edx
c010712f:	a1 1c 3f 12 c0       	mov    0xc0123f1c,%eax
c0107134:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0107137:	c1 e1 02             	shl    $0x2,%ecx
c010713a:	01 c8                	add    %ecx,%eax
c010713c:	d1 ea                	shr    %edx
c010713e:	89 10                	mov    %edx,(%eax)
            buddy_segment[right] = buddy_segment[block]>>1;
c0107140:	a1 1c 3f 12 c0       	mov    0xc0123f1c,%eax
c0107145:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0107148:	c1 e2 02             	shl    $0x2,%edx
c010714b:	01 d0                	add    %edx,%eax
c010714d:	8b 10                	mov    (%eax),%edx
c010714f:	a1 1c 3f 12 c0       	mov    0xc0123f1c,%eax
c0107154:	8b 4d d8             	mov    -0x28(%ebp),%ecx
c0107157:	c1 e1 02             	shl    $0x2,%ecx
c010715a:	01 c8                	add    %ecx,%eax
c010715c:	d1 ea                	shr    %edx
c010715e:	89 10                	mov    %edx,(%eax)
            list_add(&free_list, &(buddy_alloc[begin].page_link));
c0107160:	8b 0d 24 3f 12 c0    	mov    0xc0123f24,%ecx
c0107166:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0107169:	89 d0                	mov    %edx,%eax
c010716b:	c1 e0 02             	shl    $0x2,%eax
c010716e:	01 d0                	add    %edx,%eax
c0107170:	c1 e0 02             	shl    $0x2,%eax
c0107173:	01 c8                	add    %ecx,%eax
c0107175:	83 c0 0c             	add    $0xc,%eax
c0107178:	c7 45 a8 38 3f 12 c0 	movl   $0xc0123f38,-0x58(%ebp)
c010717f:	89 45 a4             	mov    %eax,-0x5c(%ebp)
c0107182:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0107185:	89 45 a0             	mov    %eax,-0x60(%ebp)
c0107188:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c010718b:	89 45 9c             	mov    %eax,-0x64(%ebp)
    __list_add(elm, listelm, listelm->next);
c010718e:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0107191:	8b 40 04             	mov    0x4(%eax),%eax
c0107194:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0107197:	89 55 98             	mov    %edx,-0x68(%ebp)
c010719a:	8b 55 a0             	mov    -0x60(%ebp),%edx
c010719d:	89 55 94             	mov    %edx,-0x6c(%ebp)
c01071a0:	89 45 90             	mov    %eax,-0x70(%ebp)
    prev->next = next->prev = elm;
c01071a3:	8b 45 90             	mov    -0x70(%ebp),%eax
c01071a6:	8b 55 98             	mov    -0x68(%ebp),%edx
c01071a9:	89 10                	mov    %edx,(%eax)
c01071ab:	8b 45 90             	mov    -0x70(%ebp),%eax
c01071ae:	8b 10                	mov    (%eax),%edx
c01071b0:	8b 45 94             	mov    -0x6c(%ebp),%eax
c01071b3:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01071b6:	8b 45 98             	mov    -0x68(%ebp),%eax
c01071b9:	8b 55 90             	mov    -0x70(%ebp),%edx
c01071bc:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01071bf:	8b 45 98             	mov    -0x68(%ebp),%eax
c01071c2:	8b 55 94             	mov    -0x6c(%ebp),%edx
c01071c5:	89 10                	mov    %edx,(%eax)
}
c01071c7:	90                   	nop
}
c01071c8:	90                   	nop
}
c01071c9:	90                   	nop
            list_add(&free_list, &(buddy_alloc[mid].page_link));
c01071ca:	8b 0d 24 3f 12 c0    	mov    0xc0123f24,%ecx
c01071d0:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01071d3:	89 d0                	mov    %edx,%eax
c01071d5:	c1 e0 02             	shl    $0x2,%eax
c01071d8:	01 d0                	add    %edx,%eax
c01071da:	c1 e0 02             	shl    $0x2,%eax
c01071dd:	01 c8                	add    %ecx,%eax
c01071df:	83 c0 0c             	add    $0xc,%eax
c01071e2:	c7 45 c4 38 3f 12 c0 	movl   $0xc0123f38,-0x3c(%ebp)
c01071e9:	89 45 c0             	mov    %eax,-0x40(%ebp)
c01071ec:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01071ef:	89 45 bc             	mov    %eax,-0x44(%ebp)
c01071f2:	8b 45 c0             	mov    -0x40(%ebp),%eax
c01071f5:	89 45 b8             	mov    %eax,-0x48(%ebp)
    __list_add(elm, listelm, listelm->next);
c01071f8:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01071fb:	8b 40 04             	mov    0x4(%eax),%eax
c01071fe:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0107201:	89 55 b4             	mov    %edx,-0x4c(%ebp)
c0107204:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0107207:	89 55 b0             	mov    %edx,-0x50(%ebp)
c010720a:	89 45 ac             	mov    %eax,-0x54(%ebp)
    prev->next = next->prev = elm;
c010720d:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0107210:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0107213:	89 10                	mov    %edx,(%eax)
c0107215:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0107218:	8b 10                	mov    (%eax),%edx
c010721a:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010721d:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0107220:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0107223:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0107226:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0107229:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c010722c:	8b 55 b0             	mov    -0x50(%ebp),%edx
c010722f:	89 10                	mov    %edx,(%eax)
}
c0107231:	90                   	nop
}
c0107232:	90                   	nop
}
c0107233:	90                   	nop
            block = left;
c0107234:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107237:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010723a:	e9 98 00 00 00       	jmp    c01072d7 <buddy_alloc_pages+0xbfd>
        } else if (length & buddy_segment[left]) {  // Find in left (optimize)
c010723f:	a1 1c 3f 12 c0       	mov    0xc0123f1c,%eax
c0107244:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0107247:	c1 e2 02             	shl    $0x2,%edx
c010724a:	01 d0                	add    %edx,%eax
c010724c:	8b 00                	mov    (%eax),%eax
c010724e:	23 45 e0             	and    -0x20(%ebp),%eax
c0107251:	85 c0                	test   %eax,%eax
c0107253:	74 08                	je     c010725d <buddy_alloc_pages+0xb83>
            block = left;
c0107255:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107258:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010725b:	eb 7a                	jmp    c01072d7 <buddy_alloc_pages+0xbfd>
        } else if (length & buddy_segment[right]) { // Find in right (optimize)
c010725d:	a1 1c 3f 12 c0       	mov    0xc0123f1c,%eax
c0107262:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0107265:	c1 e2 02             	shl    $0x2,%edx
c0107268:	01 d0                	add    %edx,%eax
c010726a:	8b 00                	mov    (%eax),%eax
c010726c:	23 45 e0             	and    -0x20(%ebp),%eax
c010726f:	85 c0                	test   %eax,%eax
c0107271:	74 08                	je     c010727b <buddy_alloc_pages+0xba1>
            block = right;
c0107273:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0107276:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0107279:	eb 5c                	jmp    c01072d7 <buddy_alloc_pages+0xbfd>
        } else if (length <= buddy_segment[left]) { // Find in left
c010727b:	a1 1c 3f 12 c0       	mov    0xc0123f1c,%eax
c0107280:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0107283:	c1 e2 02             	shl    $0x2,%edx
c0107286:	01 d0                	add    %edx,%eax
c0107288:	8b 00                	mov    (%eax),%eax
c010728a:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c010728d:	77 08                	ja     c0107297 <buddy_alloc_pages+0xbbd>
            block = left;
c010728f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107292:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0107295:	eb 40                	jmp    c01072d7 <buddy_alloc_pages+0xbfd>
        } else if (length <= buddy_segment[right]) {// Find in right
c0107297:	a1 1c 3f 12 c0       	mov    0xc0123f1c,%eax
c010729c:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010729f:	c1 e2 02             	shl    $0x2,%edx
c01072a2:	01 d0                	add    %edx,%eax
c01072a4:	8b 00                	mov    (%eax),%eax
c01072a6:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c01072a9:	77 08                	ja     c01072b3 <buddy_alloc_pages+0xbd9>
            block = right;
c01072ab:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01072ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01072b1:	eb 24                	jmp    c01072d7 <buddy_alloc_pages+0xbfd>
        } else {                                    // Shouldn't be here
            assert(0);
c01072b3:	c7 44 24 0c 21 b3 10 	movl   $0xc010b321,0xc(%esp)
c01072ba:	c0 
c01072bb:	c7 44 24 08 be b2 10 	movl   $0xc010b2be,0x8(%esp)
c01072c2:	c0 
c01072c3:	c7 44 24 04 96 00 00 	movl   $0x96,0x4(%esp)
c01072ca:	00 
c01072cb:	c7 04 24 d3 b2 10 c0 	movl   $0xc010b2d3,(%esp)
c01072d2:	e8 5f 91 ff ff       	call   c0100436 <__panic>
    while (length <= buddy_segment[block] && length < BUDDY_LENGTH(block)) {
c01072d7:	a1 1c 3f 12 c0       	mov    0xc0123f1c,%eax
c01072dc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01072df:	c1 e2 02             	shl    $0x2,%edx
c01072e2:	01 d0                	add    %edx,%eax
c01072e4:	8b 00                	mov    (%eax),%eax
c01072e6:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c01072e9:	0f 87 d6 01 00 00    	ja     c01074c5 <buddy_alloc_pages+0xdeb>
c01072ef:	a1 10 3f 12 c0       	mov    0xc0123f10,%eax
c01072f4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01072f7:	d1 ea                	shr    %edx
c01072f9:	0b 55 e4             	or     -0x1c(%ebp),%edx
c01072fc:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
c01072ff:	d1 e9                	shr    %ecx
c0107301:	0b 4d e4             	or     -0x1c(%ebp),%ecx
c0107304:	c1 e9 02             	shr    $0x2,%ecx
c0107307:	89 d3                	mov    %edx,%ebx
c0107309:	09 cb                	or     %ecx,%ebx
c010730b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010730e:	d1 ea                	shr    %edx
c0107310:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0107313:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
c0107316:	d1 e9                	shr    %ecx
c0107318:	0b 4d e4             	or     -0x1c(%ebp),%ecx
c010731b:	c1 e9 02             	shr    $0x2,%ecx
c010731e:	09 ca                	or     %ecx,%edx
c0107320:	c1 ea 04             	shr    $0x4,%edx
c0107323:	09 d3                	or     %edx,%ebx
c0107325:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0107328:	d1 ea                	shr    %edx
c010732a:	0b 55 e4             	or     -0x1c(%ebp),%edx
c010732d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
c0107330:	d1 e9                	shr    %ecx
c0107332:	0b 4d e4             	or     -0x1c(%ebp),%ecx
c0107335:	c1 e9 02             	shr    $0x2,%ecx
c0107338:	89 d6                	mov    %edx,%esi
c010733a:	09 ce                	or     %ecx,%esi
c010733c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010733f:	d1 ea                	shr    %edx
c0107341:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0107344:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
c0107347:	d1 e9                	shr    %ecx
c0107349:	0b 4d e4             	or     -0x1c(%ebp),%ecx
c010734c:	c1 e9 02             	shr    $0x2,%ecx
c010734f:	09 ca                	or     %ecx,%edx
c0107351:	c1 ea 04             	shr    $0x4,%edx
c0107354:	09 f2                	or     %esi,%edx
c0107356:	c1 ea 08             	shr    $0x8,%edx
c0107359:	09 d3                	or     %edx,%ebx
c010735b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010735e:	d1 ea                	shr    %edx
c0107360:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0107363:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
c0107366:	d1 e9                	shr    %ecx
c0107368:	0b 4d e4             	or     -0x1c(%ebp),%ecx
c010736b:	c1 e9 02             	shr    $0x2,%ecx
c010736e:	89 d6                	mov    %edx,%esi
c0107370:	09 ce                	or     %ecx,%esi
c0107372:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0107375:	d1 ea                	shr    %edx
c0107377:	0b 55 e4             	or     -0x1c(%ebp),%edx
c010737a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
c010737d:	d1 e9                	shr    %ecx
c010737f:	0b 4d e4             	or     -0x1c(%ebp),%ecx
c0107382:	c1 e9 02             	shr    $0x2,%ecx
c0107385:	09 ca                	or     %ecx,%edx
c0107387:	c1 ea 04             	shr    $0x4,%edx
c010738a:	09 d6                	or     %edx,%esi
c010738c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010738f:	d1 ea                	shr    %edx
c0107391:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0107394:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
c0107397:	d1 e9                	shr    %ecx
c0107399:	0b 4d e4             	or     -0x1c(%ebp),%ecx
c010739c:	c1 e9 02             	shr    $0x2,%ecx
c010739f:	89 d7                	mov    %edx,%edi
c01073a1:	09 cf                	or     %ecx,%edi
c01073a3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01073a6:	d1 ea                	shr    %edx
c01073a8:	0b 55 e4             	or     -0x1c(%ebp),%edx
c01073ab:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
c01073ae:	d1 e9                	shr    %ecx
c01073b0:	0b 4d e4             	or     -0x1c(%ebp),%ecx
c01073b3:	c1 e9 02             	shr    $0x2,%ecx
c01073b6:	09 ca                	or     %ecx,%edx
c01073b8:	c1 ea 04             	shr    $0x4,%edx
c01073bb:	09 fa                	or     %edi,%edx
c01073bd:	c1 ea 08             	shr    $0x8,%edx
c01073c0:	09 f2                	or     %esi,%edx
c01073c2:	c1 ea 10             	shr    $0x10,%edx
c01073c5:	09 da                	or     %ebx,%edx
c01073c7:	d1 ea                	shr    %edx
c01073c9:	23 55 e4             	and    -0x1c(%ebp),%edx
c01073cc:	85 d2                	test   %edx,%edx
c01073ce:	0f 84 de 00 00 00    	je     c01074b2 <buddy_alloc_pages+0xdd8>
c01073d4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01073d7:	d1 ea                	shr    %edx
c01073d9:	0b 55 e4             	or     -0x1c(%ebp),%edx
c01073dc:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
c01073df:	d1 e9                	shr    %ecx
c01073e1:	0b 4d e4             	or     -0x1c(%ebp),%ecx
c01073e4:	c1 e9 02             	shr    $0x2,%ecx
c01073e7:	89 d3                	mov    %edx,%ebx
c01073e9:	09 cb                	or     %ecx,%ebx
c01073eb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01073ee:	d1 ea                	shr    %edx
c01073f0:	0b 55 e4             	or     -0x1c(%ebp),%edx
c01073f3:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
c01073f6:	d1 e9                	shr    %ecx
c01073f8:	0b 4d e4             	or     -0x1c(%ebp),%ecx
c01073fb:	c1 e9 02             	shr    $0x2,%ecx
c01073fe:	09 ca                	or     %ecx,%edx
c0107400:	c1 ea 04             	shr    $0x4,%edx
c0107403:	09 d3                	or     %edx,%ebx
c0107405:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0107408:	d1 ea                	shr    %edx
c010740a:	0b 55 e4             	or     -0x1c(%ebp),%edx
c010740d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
c0107410:	d1 e9                	shr    %ecx
c0107412:	0b 4d e4             	or     -0x1c(%ebp),%ecx
c0107415:	c1 e9 02             	shr    $0x2,%ecx
c0107418:	89 d6                	mov    %edx,%esi
c010741a:	09 ce                	or     %ecx,%esi
c010741c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010741f:	d1 ea                	shr    %edx
c0107421:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0107424:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
c0107427:	d1 e9                	shr    %ecx
c0107429:	0b 4d e4             	or     -0x1c(%ebp),%ecx
c010742c:	c1 e9 02             	shr    $0x2,%ecx
c010742f:	09 ca                	or     %ecx,%edx
c0107431:	c1 ea 04             	shr    $0x4,%edx
c0107434:	09 f2                	or     %esi,%edx
c0107436:	c1 ea 08             	shr    $0x8,%edx
c0107439:	09 d3                	or     %edx,%ebx
c010743b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010743e:	d1 ea                	shr    %edx
c0107440:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0107443:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
c0107446:	d1 e9                	shr    %ecx
c0107448:	0b 4d e4             	or     -0x1c(%ebp),%ecx
c010744b:	c1 e9 02             	shr    $0x2,%ecx
c010744e:	89 d6                	mov    %edx,%esi
c0107450:	09 ce                	or     %ecx,%esi
c0107452:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0107455:	d1 ea                	shr    %edx
c0107457:	0b 55 e4             	or     -0x1c(%ebp),%edx
c010745a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
c010745d:	d1 e9                	shr    %ecx
c010745f:	0b 4d e4             	or     -0x1c(%ebp),%ecx
c0107462:	c1 e9 02             	shr    $0x2,%ecx
c0107465:	09 ca                	or     %ecx,%edx
c0107467:	c1 ea 04             	shr    $0x4,%edx
c010746a:	09 d6                	or     %edx,%esi
c010746c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010746f:	d1 ea                	shr    %edx
c0107471:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0107474:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
c0107477:	d1 e9                	shr    %ecx
c0107479:	0b 4d e4             	or     -0x1c(%ebp),%ecx
c010747c:	c1 e9 02             	shr    $0x2,%ecx
c010747f:	89 d7                	mov    %edx,%edi
c0107481:	09 cf                	or     %ecx,%edi
c0107483:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0107486:	d1 ea                	shr    %edx
c0107488:	0b 55 e4             	or     -0x1c(%ebp),%edx
c010748b:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
c010748e:	d1 e9                	shr    %ecx
c0107490:	0b 4d e4             	or     -0x1c(%ebp),%ecx
c0107493:	c1 e9 02             	shr    $0x2,%ecx
c0107496:	09 ca                	or     %ecx,%edx
c0107498:	c1 ea 04             	shr    $0x4,%edx
c010749b:	09 fa                	or     %edi,%edx
c010749d:	c1 ea 08             	shr    $0x8,%edx
c01074a0:	09 f2                	or     %esi,%edx
c01074a2:	c1 ea 10             	shr    $0x10,%edx
c01074a5:	09 da                	or     %ebx,%edx
c01074a7:	d1 ea                	shr    %edx
c01074a9:	f7 d2                	not    %edx
c01074ab:	89 d7                	mov    %edx,%edi
c01074ad:	23 7d e4             	and    -0x1c(%ebp),%edi
c01074b0:	eb 03                	jmp    c01074b5 <buddy_alloc_pages+0xddb>
c01074b2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
c01074b5:	ba 00 00 00 00       	mov    $0x0,%edx
c01074ba:	f7 f7                	div    %edi
c01074bc:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c01074bf:	0f 82 1f f4 ff ff    	jb     c01068e4 <buddy_alloc_pages+0x20a>
        }
    }
    // Allocate
    if (length > buddy_segment[block])
c01074c5:	a1 1c 3f 12 c0       	mov    0xc0123f1c,%eax
c01074ca:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01074cd:	c1 e2 02             	shl    $0x2,%edx
c01074d0:	01 d0                	add    %edx,%eax
c01074d2:	8b 00                	mov    (%eax),%eax
c01074d4:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c01074d7:	76 0a                	jbe    c01074e3 <buddy_alloc_pages+0xe09>
        return NULL;
c01074d9:	b8 00 00 00 00       	mov    $0x0,%eax
c01074de:	e9 8c 03 00 00       	jmp    c010786f <buddy_alloc_pages+0x1195>
    page = &(buddy_alloc[BUDDY_BEGIN(block)]);
c01074e3:	a1 24 3f 12 c0       	mov    0xc0123f24,%eax
c01074e8:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
c01074ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01074f1:	d1 e8                	shr    %eax
c01074f3:	0b 45 e4             	or     -0x1c(%ebp),%eax
c01074f6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01074f9:	d1 ea                	shr    %edx
c01074fb:	0b 55 e4             	or     -0x1c(%ebp),%edx
c01074fe:	c1 ea 02             	shr    $0x2,%edx
c0107501:	09 d0                	or     %edx,%eax
c0107503:	89 c1                	mov    %eax,%ecx
c0107505:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107508:	d1 e8                	shr    %eax
c010750a:	0b 45 e4             	or     -0x1c(%ebp),%eax
c010750d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0107510:	d1 ea                	shr    %edx
c0107512:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0107515:	c1 ea 02             	shr    $0x2,%edx
c0107518:	09 d0                	or     %edx,%eax
c010751a:	c1 e8 04             	shr    $0x4,%eax
c010751d:	09 c1                	or     %eax,%ecx
c010751f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107522:	d1 e8                	shr    %eax
c0107524:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0107527:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010752a:	d1 ea                	shr    %edx
c010752c:	0b 55 e4             	or     -0x1c(%ebp),%edx
c010752f:	c1 ea 02             	shr    $0x2,%edx
c0107532:	09 d0                	or     %edx,%eax
c0107534:	89 c3                	mov    %eax,%ebx
c0107536:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107539:	d1 e8                	shr    %eax
c010753b:	0b 45 e4             	or     -0x1c(%ebp),%eax
c010753e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0107541:	d1 ea                	shr    %edx
c0107543:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0107546:	c1 ea 02             	shr    $0x2,%edx
c0107549:	09 d0                	or     %edx,%eax
c010754b:	c1 e8 04             	shr    $0x4,%eax
c010754e:	09 d8                	or     %ebx,%eax
c0107550:	c1 e8 08             	shr    $0x8,%eax
c0107553:	09 c1                	or     %eax,%ecx
c0107555:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107558:	d1 e8                	shr    %eax
c010755a:	0b 45 e4             	or     -0x1c(%ebp),%eax
c010755d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0107560:	d1 ea                	shr    %edx
c0107562:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0107565:	c1 ea 02             	shr    $0x2,%edx
c0107568:	09 d0                	or     %edx,%eax
c010756a:	89 c3                	mov    %eax,%ebx
c010756c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010756f:	d1 e8                	shr    %eax
c0107571:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0107574:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0107577:	d1 ea                	shr    %edx
c0107579:	0b 55 e4             	or     -0x1c(%ebp),%edx
c010757c:	c1 ea 02             	shr    $0x2,%edx
c010757f:	09 d0                	or     %edx,%eax
c0107581:	c1 e8 04             	shr    $0x4,%eax
c0107584:	09 c3                	or     %eax,%ebx
c0107586:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107589:	d1 e8                	shr    %eax
c010758b:	0b 45 e4             	or     -0x1c(%ebp),%eax
c010758e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0107591:	d1 ea                	shr    %edx
c0107593:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0107596:	c1 ea 02             	shr    $0x2,%edx
c0107599:	09 d0                	or     %edx,%eax
c010759b:	89 c6                	mov    %eax,%esi
c010759d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01075a0:	d1 e8                	shr    %eax
c01075a2:	0b 45 e4             	or     -0x1c(%ebp),%eax
c01075a5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01075a8:	d1 ea                	shr    %edx
c01075aa:	0b 55 e4             	or     -0x1c(%ebp),%edx
c01075ad:	c1 ea 02             	shr    $0x2,%edx
c01075b0:	09 d0                	or     %edx,%eax
c01075b2:	c1 e8 04             	shr    $0x4,%eax
c01075b5:	09 f0                	or     %esi,%eax
c01075b7:	c1 e8 08             	shr    $0x8,%eax
c01075ba:	09 d8                	or     %ebx,%eax
c01075bc:	c1 e8 10             	shr    $0x10,%eax
c01075bf:	09 c8                	or     %ecx,%eax
c01075c1:	d1 e8                	shr    %eax
c01075c3:	23 45 e4             	and    -0x1c(%ebp),%eax
c01075c6:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
c01075cc:	8b 3d 10 3f 12 c0    	mov    0xc0123f10,%edi
c01075d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01075d5:	d1 e8                	shr    %eax
c01075d7:	0b 45 e4             	or     -0x1c(%ebp),%eax
c01075da:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01075dd:	d1 ea                	shr    %edx
c01075df:	0b 55 e4             	or     -0x1c(%ebp),%edx
c01075e2:	c1 ea 02             	shr    $0x2,%edx
c01075e5:	09 d0                	or     %edx,%eax
c01075e7:	89 c1                	mov    %eax,%ecx
c01075e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01075ec:	d1 e8                	shr    %eax
c01075ee:	0b 45 e4             	or     -0x1c(%ebp),%eax
c01075f1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01075f4:	d1 ea                	shr    %edx
c01075f6:	0b 55 e4             	or     -0x1c(%ebp),%edx
c01075f9:	c1 ea 02             	shr    $0x2,%edx
c01075fc:	09 d0                	or     %edx,%eax
c01075fe:	c1 e8 04             	shr    $0x4,%eax
c0107601:	09 c1                	or     %eax,%ecx
c0107603:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107606:	d1 e8                	shr    %eax
c0107608:	0b 45 e4             	or     -0x1c(%ebp),%eax
c010760b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010760e:	d1 ea                	shr    %edx
c0107610:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0107613:	c1 ea 02             	shr    $0x2,%edx
c0107616:	09 d0                	or     %edx,%eax
c0107618:	89 c3                	mov    %eax,%ebx
c010761a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010761d:	d1 e8                	shr    %eax
c010761f:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0107622:	89 c2                	mov    %eax,%edx
c0107624:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107627:	d1 e8                	shr    %eax
c0107629:	0b 45 e4             	or     -0x1c(%ebp),%eax
c010762c:	c1 e8 02             	shr    $0x2,%eax
c010762f:	09 d0                	or     %edx,%eax
c0107631:	c1 e8 04             	shr    $0x4,%eax
c0107634:	09 d8                	or     %ebx,%eax
c0107636:	c1 e8 08             	shr    $0x8,%eax
c0107639:	89 ce                	mov    %ecx,%esi
c010763b:	09 c6                	or     %eax,%esi
c010763d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107640:	d1 e8                	shr    %eax
c0107642:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0107645:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0107648:	d1 ea                	shr    %edx
c010764a:	0b 55 e4             	or     -0x1c(%ebp),%edx
c010764d:	c1 ea 02             	shr    $0x2,%edx
c0107650:	09 d0                	or     %edx,%eax
c0107652:	89 c1                	mov    %eax,%ecx
c0107654:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107657:	d1 e8                	shr    %eax
c0107659:	0b 45 e4             	or     -0x1c(%ebp),%eax
c010765c:	89 c2                	mov    %eax,%edx
c010765e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107661:	d1 e8                	shr    %eax
c0107663:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0107666:	c1 e8 02             	shr    $0x2,%eax
c0107669:	09 d0                	or     %edx,%eax
c010766b:	c1 e8 04             	shr    $0x4,%eax
c010766e:	89 cb                	mov    %ecx,%ebx
c0107670:	09 c3                	or     %eax,%ebx
c0107672:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107675:	d1 e8                	shr    %eax
c0107677:	0b 45 e4             	or     -0x1c(%ebp),%eax
c010767a:	89 c2                	mov    %eax,%edx
c010767c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010767f:	d1 e8                	shr    %eax
c0107681:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0107684:	c1 e8 02             	shr    $0x2,%eax
c0107687:	89 d1                	mov    %edx,%ecx
c0107689:	09 c1                	or     %eax,%ecx
c010768b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010768e:	d1 e8                	shr    %eax
c0107690:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0107693:	89 c2                	mov    %eax,%edx
c0107695:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107698:	d1 e8                	shr    %eax
c010769a:	0b 45 e4             	or     -0x1c(%ebp),%eax
c010769d:	c1 e8 02             	shr    $0x2,%eax
c01076a0:	09 d0                	or     %edx,%eax
c01076a2:	c1 e8 04             	shr    $0x4,%eax
c01076a5:	09 c8                	or     %ecx,%eax
c01076a7:	c1 e8 08             	shr    $0x8,%eax
c01076aa:	09 d8                	or     %ebx,%eax
c01076ac:	c1 e8 10             	shr    $0x10,%eax
c01076af:	09 f0                	or     %esi,%eax
c01076b1:	d1 e8                	shr    %eax
c01076b3:	23 45 e4             	and    -0x1c(%ebp),%eax
c01076b6:	85 c0                	test   %eax,%eax
c01076b8:	0f 84 ea 00 00 00    	je     c01077a8 <buddy_alloc_pages+0x10ce>
c01076be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01076c1:	d1 e8                	shr    %eax
c01076c3:	0b 45 e4             	or     -0x1c(%ebp),%eax
c01076c6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01076c9:	d1 ea                	shr    %edx
c01076cb:	0b 55 e4             	or     -0x1c(%ebp),%edx
c01076ce:	c1 ea 02             	shr    $0x2,%edx
c01076d1:	09 d0                	or     %edx,%eax
c01076d3:	89 c1                	mov    %eax,%ecx
c01076d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01076d8:	d1 e8                	shr    %eax
c01076da:	0b 45 e4             	or     -0x1c(%ebp),%eax
c01076dd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01076e0:	d1 ea                	shr    %edx
c01076e2:	0b 55 e4             	or     -0x1c(%ebp),%edx
c01076e5:	c1 ea 02             	shr    $0x2,%edx
c01076e8:	09 d0                	or     %edx,%eax
c01076ea:	c1 e8 04             	shr    $0x4,%eax
c01076ed:	09 c1                	or     %eax,%ecx
c01076ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01076f2:	d1 e8                	shr    %eax
c01076f4:	0b 45 e4             	or     -0x1c(%ebp),%eax
c01076f7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01076fa:	d1 ea                	shr    %edx
c01076fc:	0b 55 e4             	or     -0x1c(%ebp),%edx
c01076ff:	c1 ea 02             	shr    $0x2,%edx
c0107702:	09 d0                	or     %edx,%eax
c0107704:	89 c3                	mov    %eax,%ebx
c0107706:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107709:	d1 e8                	shr    %eax
c010770b:	0b 45 e4             	or     -0x1c(%ebp),%eax
c010770e:	89 c2                	mov    %eax,%edx
c0107710:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107713:	d1 e8                	shr    %eax
c0107715:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0107718:	c1 e8 02             	shr    $0x2,%eax
c010771b:	09 d0                	or     %edx,%eax
c010771d:	c1 e8 04             	shr    $0x4,%eax
c0107720:	09 d8                	or     %ebx,%eax
c0107722:	c1 e8 08             	shr    $0x8,%eax
c0107725:	89 ce                	mov    %ecx,%esi
c0107727:	09 c6                	or     %eax,%esi
c0107729:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010772c:	d1 e8                	shr    %eax
c010772e:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0107731:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0107734:	d1 ea                	shr    %edx
c0107736:	0b 55 e4             	or     -0x1c(%ebp),%edx
c0107739:	c1 ea 02             	shr    $0x2,%edx
c010773c:	09 d0                	or     %edx,%eax
c010773e:	89 c1                	mov    %eax,%ecx
c0107740:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107743:	d1 e8                	shr    %eax
c0107745:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0107748:	89 c2                	mov    %eax,%edx
c010774a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010774d:	d1 e8                	shr    %eax
c010774f:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0107752:	c1 e8 02             	shr    $0x2,%eax
c0107755:	09 d0                	or     %edx,%eax
c0107757:	c1 e8 04             	shr    $0x4,%eax
c010775a:	89 cb                	mov    %ecx,%ebx
c010775c:	09 c3                	or     %eax,%ebx
c010775e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107761:	d1 e8                	shr    %eax
c0107763:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0107766:	89 c2                	mov    %eax,%edx
c0107768:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010776b:	d1 e8                	shr    %eax
c010776d:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0107770:	c1 e8 02             	shr    $0x2,%eax
c0107773:	89 d1                	mov    %edx,%ecx
c0107775:	09 c1                	or     %eax,%ecx
c0107777:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010777a:	d1 e8                	shr    %eax
c010777c:	0b 45 e4             	or     -0x1c(%ebp),%eax
c010777f:	89 c2                	mov    %eax,%edx
c0107781:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107784:	d1 e8                	shr    %eax
c0107786:	0b 45 e4             	or     -0x1c(%ebp),%eax
c0107789:	c1 e8 02             	shr    $0x2,%eax
c010778c:	09 d0                	or     %edx,%eax
c010778e:	c1 e8 04             	shr    $0x4,%eax
c0107791:	09 c8                	or     %ecx,%eax
c0107793:	c1 e8 08             	shr    $0x8,%eax
c0107796:	09 d8                	or     %ebx,%eax
c0107798:	c1 e8 10             	shr    $0x10,%eax
c010779b:	09 f0                	or     %esi,%eax
c010779d:	d1 e8                	shr    %eax
c010779f:	f7 d0                	not    %eax
c01077a1:	23 45 e4             	and    -0x1c(%ebp),%eax
c01077a4:	89 c6                	mov    %eax,%esi
c01077a6:	eb 03                	jmp    c01077ab <buddy_alloc_pages+0x10d1>
c01077a8:	8b 75 e4             	mov    -0x1c(%ebp),%esi
c01077ab:	89 f8                	mov    %edi,%eax
c01077ad:	ba 00 00 00 00       	mov    $0x0,%edx
c01077b2:	f7 f6                	div    %esi
c01077b4:	8b 95 70 ff ff ff    	mov    -0x90(%ebp),%edx
c01077ba:	0f af d0             	imul   %eax,%edx
c01077bd:	89 d0                	mov    %edx,%eax
c01077bf:	c1 e0 02             	shl    $0x2,%eax
c01077c2:	01 d0                	add    %edx,%eax
c01077c4:	c1 e0 02             	shl    $0x2,%eax
c01077c7:	03 85 74 ff ff ff    	add    -0x8c(%ebp),%eax
c01077cd:	89 45 c8             	mov    %eax,-0x38(%ebp)
    list_del(&(page->page_link));
c01077d0:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01077d3:	83 c0 0c             	add    $0xc,%eax
c01077d6:	89 45 80             	mov    %eax,-0x80(%ebp)
    __list_del(listelm->prev, listelm->next);
c01077d9:	8b 45 80             	mov    -0x80(%ebp),%eax
c01077dc:	8b 40 04             	mov    0x4(%eax),%eax
c01077df:	8b 55 80             	mov    -0x80(%ebp),%edx
c01077e2:	8b 12                	mov    (%edx),%edx
c01077e4:	89 95 7c ff ff ff    	mov    %edx,-0x84(%ebp)
c01077ea:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
    prev->next = next;
c01077f0:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c01077f6:	8b 95 78 ff ff ff    	mov    -0x88(%ebp),%edx
c01077fc:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c01077ff:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
c0107805:	8b 95 7c ff ff ff    	mov    -0x84(%ebp),%edx
c010780b:	89 10                	mov    %edx,(%eax)
}
c010780d:	90                   	nop
}
c010780e:	90                   	nop
    buddy_segment[block] = 0;
c010780f:	a1 1c 3f 12 c0       	mov    0xc0123f1c,%eax
c0107814:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0107817:	c1 e2 02             	shl    $0x2,%edx
c010781a:	01 d0                	add    %edx,%eax
c010781c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    nr_free -= length;
c0107822:	a1 40 3f 12 c0       	mov    0xc0123f40,%eax
c0107827:	2b 45 e0             	sub    -0x20(%ebp),%eax
c010782a:	a3 40 3f 12 c0       	mov    %eax,0xc0123f40
    // Update buddy segment
    while (block != BUDDY_ROOT) {
c010782f:	eb 35                	jmp    c0107866 <buddy_alloc_pages+0x118c>
        block = BUDDY_PARENT(block);
c0107831:	d1 6d e4             	shrl   -0x1c(%ebp)
        buddy_segment[block] = buddy_segment[BUDDY_LEFT(block)] | buddy_segment[BUDDY_RIGHT(block)];
c0107834:	a1 1c 3f 12 c0       	mov    0xc0123f1c,%eax
c0107839:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010783c:	c1 e2 03             	shl    $0x3,%edx
c010783f:	01 d0                	add    %edx,%eax
c0107841:	8b 08                	mov    (%eax),%ecx
c0107843:	a1 1c 3f 12 c0       	mov    0xc0123f1c,%eax
c0107848:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010784b:	c1 e2 03             	shl    $0x3,%edx
c010784e:	83 c2 04             	add    $0x4,%edx
c0107851:	01 d0                	add    %edx,%eax
c0107853:	8b 10                	mov    (%eax),%edx
c0107855:	a1 1c 3f 12 c0       	mov    0xc0123f1c,%eax
c010785a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
c010785d:	c1 e3 02             	shl    $0x2,%ebx
c0107860:	01 d8                	add    %ebx,%eax
c0107862:	09 ca                	or     %ecx,%edx
c0107864:	89 10                	mov    %edx,(%eax)
    while (block != BUDDY_ROOT) {
c0107866:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
c010786a:	75 c5                	jne    c0107831 <buddy_alloc_pages+0x1157>
    }
    return page;
c010786c:	8b 45 c8             	mov    -0x38(%ebp),%eax
}
c010786f:	81 c4 9c 00 00 00    	add    $0x9c,%esp
c0107875:	5b                   	pop    %ebx
c0107876:	5e                   	pop    %esi
c0107877:	5f                   	pop    %edi
c0107878:	5d                   	pop    %ebp
c0107879:	c3                   	ret    

c010787a <buddy_free_pages>:

static void
buddy_free_pages(struct Page *base, size_t n) {
c010787a:	f3 0f 1e fb          	endbr32 
c010787e:	55                   	push   %ebp
c010787f:	89 e5                	mov    %esp,%ebp
c0107881:	57                   	push   %edi
c0107882:	56                   	push   %esi
c0107883:	53                   	push   %ebx
c0107884:	81 ec ac 00 00 00    	sub    $0xac,%esp
    assert(n > 0);
c010788a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010788e:	75 24                	jne    c01078b4 <buddy_free_pages+0x3a>
c0107890:	c7 44 24 0c 0b b3 10 	movl   $0xc010b30b,0xc(%esp)
c0107897:	c0 
c0107898:	c7 44 24 08 be b2 10 	movl   $0xc010b2be,0x8(%esp)
c010789f:	c0 
c01078a0:	c7 44 24 04 aa 00 00 	movl   $0xaa,0x4(%esp)
c01078a7:	00 
c01078a8:	c7 04 24 d3 b2 10 c0 	movl   $0xc010b2d3,(%esp)
c01078af:	e8 82 8b ff ff       	call   c0100436 <__panic>
    struct Page *p = base;
c01078b4:	8b 45 08             	mov    0x8(%ebp),%eax
c01078b7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    size_t length = UINT32_ROUND_UP(n);
c01078ba:	8b 45 0c             	mov    0xc(%ebp),%eax
c01078bd:	d1 e8                	shr    %eax
c01078bf:	0b 45 0c             	or     0xc(%ebp),%eax
c01078c2:	8b 55 0c             	mov    0xc(%ebp),%edx
c01078c5:	d1 ea                	shr    %edx
c01078c7:	0b 55 0c             	or     0xc(%ebp),%edx
c01078ca:	c1 ea 02             	shr    $0x2,%edx
c01078cd:	09 d0                	or     %edx,%eax
c01078cf:	89 c1                	mov    %eax,%ecx
c01078d1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01078d4:	d1 e8                	shr    %eax
c01078d6:	0b 45 0c             	or     0xc(%ebp),%eax
c01078d9:	8b 55 0c             	mov    0xc(%ebp),%edx
c01078dc:	d1 ea                	shr    %edx
c01078de:	0b 55 0c             	or     0xc(%ebp),%edx
c01078e1:	c1 ea 02             	shr    $0x2,%edx
c01078e4:	09 d0                	or     %edx,%eax
c01078e6:	c1 e8 04             	shr    $0x4,%eax
c01078e9:	09 c1                	or     %eax,%ecx
c01078eb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01078ee:	d1 e8                	shr    %eax
c01078f0:	0b 45 0c             	or     0xc(%ebp),%eax
c01078f3:	8b 55 0c             	mov    0xc(%ebp),%edx
c01078f6:	d1 ea                	shr    %edx
c01078f8:	0b 55 0c             	or     0xc(%ebp),%edx
c01078fb:	c1 ea 02             	shr    $0x2,%edx
c01078fe:	09 d0                	or     %edx,%eax
c0107900:	89 c3                	mov    %eax,%ebx
c0107902:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107905:	d1 e8                	shr    %eax
c0107907:	0b 45 0c             	or     0xc(%ebp),%eax
c010790a:	8b 55 0c             	mov    0xc(%ebp),%edx
c010790d:	d1 ea                	shr    %edx
c010790f:	0b 55 0c             	or     0xc(%ebp),%edx
c0107912:	c1 ea 02             	shr    $0x2,%edx
c0107915:	09 d0                	or     %edx,%eax
c0107917:	c1 e8 04             	shr    $0x4,%eax
c010791a:	09 d8                	or     %ebx,%eax
c010791c:	c1 e8 08             	shr    $0x8,%eax
c010791f:	09 c1                	or     %eax,%ecx
c0107921:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107924:	d1 e8                	shr    %eax
c0107926:	0b 45 0c             	or     0xc(%ebp),%eax
c0107929:	8b 55 0c             	mov    0xc(%ebp),%edx
c010792c:	d1 ea                	shr    %edx
c010792e:	0b 55 0c             	or     0xc(%ebp),%edx
c0107931:	c1 ea 02             	shr    $0x2,%edx
c0107934:	09 d0                	or     %edx,%eax
c0107936:	89 c3                	mov    %eax,%ebx
c0107938:	8b 45 0c             	mov    0xc(%ebp),%eax
c010793b:	d1 e8                	shr    %eax
c010793d:	0b 45 0c             	or     0xc(%ebp),%eax
c0107940:	8b 55 0c             	mov    0xc(%ebp),%edx
c0107943:	d1 ea                	shr    %edx
c0107945:	0b 55 0c             	or     0xc(%ebp),%edx
c0107948:	c1 ea 02             	shr    $0x2,%edx
c010794b:	09 d0                	or     %edx,%eax
c010794d:	c1 e8 04             	shr    $0x4,%eax
c0107950:	09 c3                	or     %eax,%ebx
c0107952:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107955:	d1 e8                	shr    %eax
c0107957:	0b 45 0c             	or     0xc(%ebp),%eax
c010795a:	8b 55 0c             	mov    0xc(%ebp),%edx
c010795d:	d1 ea                	shr    %edx
c010795f:	0b 55 0c             	or     0xc(%ebp),%edx
c0107962:	c1 ea 02             	shr    $0x2,%edx
c0107965:	09 d0                	or     %edx,%eax
c0107967:	89 c6                	mov    %eax,%esi
c0107969:	8b 45 0c             	mov    0xc(%ebp),%eax
c010796c:	d1 e8                	shr    %eax
c010796e:	0b 45 0c             	or     0xc(%ebp),%eax
c0107971:	8b 55 0c             	mov    0xc(%ebp),%edx
c0107974:	d1 ea                	shr    %edx
c0107976:	0b 55 0c             	or     0xc(%ebp),%edx
c0107979:	c1 ea 02             	shr    $0x2,%edx
c010797c:	09 d0                	or     %edx,%eax
c010797e:	c1 e8 04             	shr    $0x4,%eax
c0107981:	09 f0                	or     %esi,%eax
c0107983:	c1 e8 08             	shr    $0x8,%eax
c0107986:	09 d8                	or     %ebx,%eax
c0107988:	c1 e8 10             	shr    $0x10,%eax
c010798b:	09 c8                	or     %ecx,%eax
c010798d:	d1 e8                	shr    %eax
c010798f:	23 45 0c             	and    0xc(%ebp),%eax
c0107992:	85 c0                	test   %eax,%eax
c0107994:	0f 84 de 00 00 00    	je     c0107a78 <buddy_free_pages+0x1fe>
c010799a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010799d:	d1 e8                	shr    %eax
c010799f:	0b 45 0c             	or     0xc(%ebp),%eax
c01079a2:	8b 55 0c             	mov    0xc(%ebp),%edx
c01079a5:	d1 ea                	shr    %edx
c01079a7:	0b 55 0c             	or     0xc(%ebp),%edx
c01079aa:	c1 ea 02             	shr    $0x2,%edx
c01079ad:	09 d0                	or     %edx,%eax
c01079af:	89 c1                	mov    %eax,%ecx
c01079b1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01079b4:	d1 e8                	shr    %eax
c01079b6:	0b 45 0c             	or     0xc(%ebp),%eax
c01079b9:	8b 55 0c             	mov    0xc(%ebp),%edx
c01079bc:	d1 ea                	shr    %edx
c01079be:	0b 55 0c             	or     0xc(%ebp),%edx
c01079c1:	c1 ea 02             	shr    $0x2,%edx
c01079c4:	09 d0                	or     %edx,%eax
c01079c6:	c1 e8 04             	shr    $0x4,%eax
c01079c9:	09 c1                	or     %eax,%ecx
c01079cb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01079ce:	d1 e8                	shr    %eax
c01079d0:	0b 45 0c             	or     0xc(%ebp),%eax
c01079d3:	8b 55 0c             	mov    0xc(%ebp),%edx
c01079d6:	d1 ea                	shr    %edx
c01079d8:	0b 55 0c             	or     0xc(%ebp),%edx
c01079db:	c1 ea 02             	shr    $0x2,%edx
c01079de:	09 d0                	or     %edx,%eax
c01079e0:	89 c3                	mov    %eax,%ebx
c01079e2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01079e5:	d1 e8                	shr    %eax
c01079e7:	0b 45 0c             	or     0xc(%ebp),%eax
c01079ea:	8b 55 0c             	mov    0xc(%ebp),%edx
c01079ed:	d1 ea                	shr    %edx
c01079ef:	0b 55 0c             	or     0xc(%ebp),%edx
c01079f2:	c1 ea 02             	shr    $0x2,%edx
c01079f5:	09 d0                	or     %edx,%eax
c01079f7:	c1 e8 04             	shr    $0x4,%eax
c01079fa:	09 d8                	or     %ebx,%eax
c01079fc:	c1 e8 08             	shr    $0x8,%eax
c01079ff:	09 c1                	or     %eax,%ecx
c0107a01:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107a04:	d1 e8                	shr    %eax
c0107a06:	0b 45 0c             	or     0xc(%ebp),%eax
c0107a09:	8b 55 0c             	mov    0xc(%ebp),%edx
c0107a0c:	d1 ea                	shr    %edx
c0107a0e:	0b 55 0c             	or     0xc(%ebp),%edx
c0107a11:	c1 ea 02             	shr    $0x2,%edx
c0107a14:	09 d0                	or     %edx,%eax
c0107a16:	89 c3                	mov    %eax,%ebx
c0107a18:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107a1b:	d1 e8                	shr    %eax
c0107a1d:	0b 45 0c             	or     0xc(%ebp),%eax
c0107a20:	8b 55 0c             	mov    0xc(%ebp),%edx
c0107a23:	d1 ea                	shr    %edx
c0107a25:	0b 55 0c             	or     0xc(%ebp),%edx
c0107a28:	c1 ea 02             	shr    $0x2,%edx
c0107a2b:	09 d0                	or     %edx,%eax
c0107a2d:	c1 e8 04             	shr    $0x4,%eax
c0107a30:	09 c3                	or     %eax,%ebx
c0107a32:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107a35:	d1 e8                	shr    %eax
c0107a37:	0b 45 0c             	or     0xc(%ebp),%eax
c0107a3a:	8b 55 0c             	mov    0xc(%ebp),%edx
c0107a3d:	d1 ea                	shr    %edx
c0107a3f:	0b 55 0c             	or     0xc(%ebp),%edx
c0107a42:	c1 ea 02             	shr    $0x2,%edx
c0107a45:	09 d0                	or     %edx,%eax
c0107a47:	89 c6                	mov    %eax,%esi
c0107a49:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107a4c:	d1 e8                	shr    %eax
c0107a4e:	0b 45 0c             	or     0xc(%ebp),%eax
c0107a51:	8b 55 0c             	mov    0xc(%ebp),%edx
c0107a54:	d1 ea                	shr    %edx
c0107a56:	0b 55 0c             	or     0xc(%ebp),%edx
c0107a59:	c1 ea 02             	shr    $0x2,%edx
c0107a5c:	09 d0                	or     %edx,%eax
c0107a5e:	c1 e8 04             	shr    $0x4,%eax
c0107a61:	09 f0                	or     %esi,%eax
c0107a63:	c1 e8 08             	shr    $0x8,%eax
c0107a66:	09 d8                	or     %ebx,%eax
c0107a68:	c1 e8 10             	shr    $0x10,%eax
c0107a6b:	09 c8                	or     %ecx,%eax
c0107a6d:	d1 e8                	shr    %eax
c0107a6f:	f7 d0                	not    %eax
c0107a71:	23 45 0c             	and    0xc(%ebp),%eax
c0107a74:	01 c0                	add    %eax,%eax
c0107a76:	eb 03                	jmp    c0107a7b <buddy_free_pages+0x201>
c0107a78:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107a7b:	89 45 dc             	mov    %eax,-0x24(%ebp)
    // Find buddy id 
    size_t begin = (base-buddy_alloc);
c0107a7e:	a1 24 3f 12 c0       	mov    0xc0123f24,%eax
c0107a83:	8b 55 08             	mov    0x8(%ebp),%edx
c0107a86:	29 c2                	sub    %eax,%edx
c0107a88:	89 d0                	mov    %edx,%eax
c0107a8a:	c1 f8 02             	sar    $0x2,%eax
c0107a8d:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
c0107a93:	89 45 d8             	mov    %eax,-0x28(%ebp)
    size_t end = begin + length;
c0107a96:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0107a99:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107a9c:	01 d0                	add    %edx,%eax
c0107a9e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    size_t block = BUDDY_BLOCK(begin, end);
c0107aa1:	a1 10 3f 12 c0       	mov    0xc0123f10,%eax
c0107aa6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0107aa9:	89 d7                	mov    %edx,%edi
c0107aab:	2b 7d d8             	sub    -0x28(%ebp),%edi
c0107aae:	ba 00 00 00 00       	mov    $0x0,%edx
c0107ab3:	f7 f7                	div    %edi
c0107ab5:	89 c1                	mov    %eax,%ecx
c0107ab7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0107aba:	2b 45 d8             	sub    -0x28(%ebp),%eax
c0107abd:	89 c7                	mov    %eax,%edi
c0107abf:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0107ac2:	ba 00 00 00 00       	mov    $0x0,%edx
c0107ac7:	f7 f7                	div    %edi
c0107ac9:	01 c8                	add    %ecx,%eax
c0107acb:	89 45 e0             	mov    %eax,-0x20(%ebp)
    // Release block
    for (; p != base + n; p ++) {
c0107ace:	eb 71                	jmp    c0107b41 <buddy_free_pages+0x2c7>
        assert(!PageReserved(p));
c0107ad0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107ad3:	83 c0 04             	add    $0x4,%eax
c0107ad6:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
c0107add:	89 45 bc             	mov    %eax,-0x44(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0107ae0:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0107ae3:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0107ae6:	0f a3 10             	bt     %edx,(%eax)
c0107ae9:	19 c0                	sbb    %eax,%eax
c0107aeb:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c0107aee:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c0107af2:	0f 95 c0             	setne  %al
c0107af5:	0f b6 c0             	movzbl %al,%eax
c0107af8:	85 c0                	test   %eax,%eax
c0107afa:	74 24                	je     c0107b20 <buddy_free_pages+0x2a6>
c0107afc:	c7 44 24 0c 23 b3 10 	movl   $0xc010b323,0xc(%esp)
c0107b03:	c0 
c0107b04:	c7 44 24 08 be b2 10 	movl   $0xc010b2be,0x8(%esp)
c0107b0b:	c0 
c0107b0c:	c7 44 24 04 b3 00 00 	movl   $0xb3,0x4(%esp)
c0107b13:	00 
c0107b14:	c7 04 24 d3 b2 10 c0 	movl   $0xc010b2d3,(%esp)
c0107b1b:	e8 16 89 ff ff       	call   c0100436 <__panic>
        p->flags = 0;
c0107b20:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107b23:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
c0107b2a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0107b31:	00 
c0107b32:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107b35:	89 04 24             	mov    %eax,(%esp)
c0107b38:	e8 5e dd ff ff       	call   c010589b <set_page_ref>
    for (; p != base + n; p ++) {
c0107b3d:	83 45 e4 14          	addl   $0x14,-0x1c(%ebp)
c0107b41:	8b 55 0c             	mov    0xc(%ebp),%edx
c0107b44:	89 d0                	mov    %edx,%eax
c0107b46:	c1 e0 02             	shl    $0x2,%eax
c0107b49:	01 d0                	add    %edx,%eax
c0107b4b:	c1 e0 02             	shl    $0x2,%eax
c0107b4e:	89 c2                	mov    %eax,%edx
c0107b50:	8b 45 08             	mov    0x8(%ebp),%eax
c0107b53:	01 d0                	add    %edx,%eax
c0107b55:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0107b58:	0f 85 72 ff ff ff    	jne    c0107ad0 <buddy_free_pages+0x256>
    }
    base->property = length;
c0107b5e:	8b 45 08             	mov    0x8(%ebp),%eax
c0107b61:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0107b64:	89 50 08             	mov    %edx,0x8(%eax)
    list_add(&(free_list), &(base->page_link));
c0107b67:	8b 45 08             	mov    0x8(%ebp),%eax
c0107b6a:	83 c0 0c             	add    $0xc,%eax
c0107b6d:	c7 45 b4 38 3f 12 c0 	movl   $0xc0123f38,-0x4c(%ebp)
c0107b74:	89 45 b0             	mov    %eax,-0x50(%ebp)
c0107b77:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0107b7a:	89 45 ac             	mov    %eax,-0x54(%ebp)
c0107b7d:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0107b80:	89 45 a8             	mov    %eax,-0x58(%ebp)
    __list_add(elm, listelm, listelm->next);
c0107b83:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0107b86:	8b 40 04             	mov    0x4(%eax),%eax
c0107b89:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0107b8c:	89 55 a4             	mov    %edx,-0x5c(%ebp)
c0107b8f:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0107b92:	89 55 a0             	mov    %edx,-0x60(%ebp)
c0107b95:	89 45 9c             	mov    %eax,-0x64(%ebp)
    prev->next = next->prev = elm;
c0107b98:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0107b9b:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0107b9e:	89 10                	mov    %edx,(%eax)
c0107ba0:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0107ba3:	8b 10                	mov    (%eax),%edx
c0107ba5:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0107ba8:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0107bab:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0107bae:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0107bb1:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0107bb4:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0107bb7:	8b 55 a0             	mov    -0x60(%ebp),%edx
c0107bba:	89 10                	mov    %edx,(%eax)
}
c0107bbc:	90                   	nop
}
c0107bbd:	90                   	nop
}
c0107bbe:	90                   	nop
    nr_free += length;
c0107bbf:	8b 15 40 3f 12 c0    	mov    0xc0123f40,%edx
c0107bc5:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107bc8:	01 d0                	add    %edx,%eax
c0107bca:	a3 40 3f 12 c0       	mov    %eax,0xc0123f40
    buddy_segment[block] = length;
c0107bcf:	a1 1c 3f 12 c0       	mov    0xc0123f1c,%eax
c0107bd4:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0107bd7:	c1 e2 02             	shl    $0x2,%edx
c0107bda:	01 c2                	add    %eax,%edx
c0107bdc:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107bdf:	89 02                	mov    %eax,(%edx)
    // Upadte & merge
    while (block != BUDDY_ROOT) {
c0107be1:	e9 22 0b 00 00       	jmp    c0108708 <buddy_free_pages+0xe8e>
        block = BUDDY_PARENT(block);
c0107be6:	d1 6d e0             	shrl   -0x20(%ebp)
        size_t left = BUDDY_LEFT(block);
c0107be9:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107bec:	01 c0                	add    %eax,%eax
c0107bee:	89 45 d0             	mov    %eax,-0x30(%ebp)
        size_t right = BUDDY_RIGHT(block);
c0107bf1:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107bf4:	01 c0                	add    %eax,%eax
c0107bf6:	40                   	inc    %eax
c0107bf7:	89 45 cc             	mov    %eax,-0x34(%ebp)
        if (BUDDY_EMPTY(left) && BUDDY_EMPTY(right)) {  // Merge
c0107bfa:	a1 1c 3f 12 c0       	mov    0xc0123f1c,%eax
c0107bff:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0107c02:	c1 e2 02             	shl    $0x2,%edx
c0107c05:	01 d0                	add    %edx,%eax
c0107c07:	8b 00                	mov    (%eax),%eax
c0107c09:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
c0107c0f:	8b 3d 10 3f 12 c0    	mov    0xc0123f10,%edi
c0107c15:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0107c18:	d1 e8                	shr    %eax
c0107c1a:	0b 45 d0             	or     -0x30(%ebp),%eax
c0107c1d:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0107c20:	d1 ea                	shr    %edx
c0107c22:	0b 55 d0             	or     -0x30(%ebp),%edx
c0107c25:	c1 ea 02             	shr    $0x2,%edx
c0107c28:	09 d0                	or     %edx,%eax
c0107c2a:	89 c1                	mov    %eax,%ecx
c0107c2c:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0107c2f:	d1 e8                	shr    %eax
c0107c31:	0b 45 d0             	or     -0x30(%ebp),%eax
c0107c34:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0107c37:	d1 ea                	shr    %edx
c0107c39:	0b 55 d0             	or     -0x30(%ebp),%edx
c0107c3c:	c1 ea 02             	shr    $0x2,%edx
c0107c3f:	09 d0                	or     %edx,%eax
c0107c41:	c1 e8 04             	shr    $0x4,%eax
c0107c44:	09 c1                	or     %eax,%ecx
c0107c46:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0107c49:	d1 e8                	shr    %eax
c0107c4b:	0b 45 d0             	or     -0x30(%ebp),%eax
c0107c4e:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0107c51:	d1 ea                	shr    %edx
c0107c53:	0b 55 d0             	or     -0x30(%ebp),%edx
c0107c56:	c1 ea 02             	shr    $0x2,%edx
c0107c59:	09 d0                	or     %edx,%eax
c0107c5b:	89 c3                	mov    %eax,%ebx
c0107c5d:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0107c60:	d1 e8                	shr    %eax
c0107c62:	0b 45 d0             	or     -0x30(%ebp),%eax
c0107c65:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0107c68:	d1 ea                	shr    %edx
c0107c6a:	0b 55 d0             	or     -0x30(%ebp),%edx
c0107c6d:	c1 ea 02             	shr    $0x2,%edx
c0107c70:	09 d0                	or     %edx,%eax
c0107c72:	c1 e8 04             	shr    $0x4,%eax
c0107c75:	09 d8                	or     %ebx,%eax
c0107c77:	c1 e8 08             	shr    $0x8,%eax
c0107c7a:	89 cb                	mov    %ecx,%ebx
c0107c7c:	09 c3                	or     %eax,%ebx
c0107c7e:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0107c81:	d1 e8                	shr    %eax
c0107c83:	0b 45 d0             	or     -0x30(%ebp),%eax
c0107c86:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0107c89:	d1 ea                	shr    %edx
c0107c8b:	0b 55 d0             	or     -0x30(%ebp),%edx
c0107c8e:	c1 ea 02             	shr    $0x2,%edx
c0107c91:	09 d0                	or     %edx,%eax
c0107c93:	89 c1                	mov    %eax,%ecx
c0107c95:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0107c98:	d1 e8                	shr    %eax
c0107c9a:	0b 45 d0             	or     -0x30(%ebp),%eax
c0107c9d:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0107ca0:	d1 ea                	shr    %edx
c0107ca2:	0b 55 d0             	or     -0x30(%ebp),%edx
c0107ca5:	c1 ea 02             	shr    $0x2,%edx
c0107ca8:	09 d0                	or     %edx,%eax
c0107caa:	c1 e8 04             	shr    $0x4,%eax
c0107cad:	09 c1                	or     %eax,%ecx
c0107caf:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0107cb2:	d1 e8                	shr    %eax
c0107cb4:	0b 45 d0             	or     -0x30(%ebp),%eax
c0107cb7:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0107cba:	d1 ea                	shr    %edx
c0107cbc:	0b 55 d0             	or     -0x30(%ebp),%edx
c0107cbf:	c1 ea 02             	shr    $0x2,%edx
c0107cc2:	09 d0                	or     %edx,%eax
c0107cc4:	89 c6                	mov    %eax,%esi
c0107cc6:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0107cc9:	d1 e8                	shr    %eax
c0107ccb:	0b 45 d0             	or     -0x30(%ebp),%eax
c0107cce:	89 c2                	mov    %eax,%edx
c0107cd0:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0107cd3:	d1 e8                	shr    %eax
c0107cd5:	0b 45 d0             	or     -0x30(%ebp),%eax
c0107cd8:	c1 e8 02             	shr    $0x2,%eax
c0107cdb:	09 d0                	or     %edx,%eax
c0107cdd:	c1 e8 04             	shr    $0x4,%eax
c0107ce0:	09 f0                	or     %esi,%eax
c0107ce2:	c1 e8 08             	shr    $0x8,%eax
c0107ce5:	09 c8                	or     %ecx,%eax
c0107ce7:	c1 e8 10             	shr    $0x10,%eax
c0107cea:	09 d8                	or     %ebx,%eax
c0107cec:	d1 e8                	shr    %eax
c0107cee:	23 45 d0             	and    -0x30(%ebp),%eax
c0107cf1:	85 c0                	test   %eax,%eax
c0107cf3:	0f 84 e2 00 00 00    	je     c0107ddb <buddy_free_pages+0x561>
c0107cf9:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0107cfc:	d1 e8                	shr    %eax
c0107cfe:	0b 45 d0             	or     -0x30(%ebp),%eax
c0107d01:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0107d04:	d1 ea                	shr    %edx
c0107d06:	0b 55 d0             	or     -0x30(%ebp),%edx
c0107d09:	c1 ea 02             	shr    $0x2,%edx
c0107d0c:	09 d0                	or     %edx,%eax
c0107d0e:	89 c1                	mov    %eax,%ecx
c0107d10:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0107d13:	d1 e8                	shr    %eax
c0107d15:	0b 45 d0             	or     -0x30(%ebp),%eax
c0107d18:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0107d1b:	d1 ea                	shr    %edx
c0107d1d:	0b 55 d0             	or     -0x30(%ebp),%edx
c0107d20:	c1 ea 02             	shr    $0x2,%edx
c0107d23:	09 d0                	or     %edx,%eax
c0107d25:	c1 e8 04             	shr    $0x4,%eax
c0107d28:	09 c1                	or     %eax,%ecx
c0107d2a:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0107d2d:	d1 e8                	shr    %eax
c0107d2f:	0b 45 d0             	or     -0x30(%ebp),%eax
c0107d32:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0107d35:	d1 ea                	shr    %edx
c0107d37:	0b 55 d0             	or     -0x30(%ebp),%edx
c0107d3a:	c1 ea 02             	shr    $0x2,%edx
c0107d3d:	09 d0                	or     %edx,%eax
c0107d3f:	89 c3                	mov    %eax,%ebx
c0107d41:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0107d44:	d1 e8                	shr    %eax
c0107d46:	0b 45 d0             	or     -0x30(%ebp),%eax
c0107d49:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0107d4c:	d1 ea                	shr    %edx
c0107d4e:	0b 55 d0             	or     -0x30(%ebp),%edx
c0107d51:	c1 ea 02             	shr    $0x2,%edx
c0107d54:	09 d0                	or     %edx,%eax
c0107d56:	c1 e8 04             	shr    $0x4,%eax
c0107d59:	09 d8                	or     %ebx,%eax
c0107d5b:	c1 e8 08             	shr    $0x8,%eax
c0107d5e:	89 cb                	mov    %ecx,%ebx
c0107d60:	09 c3                	or     %eax,%ebx
c0107d62:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0107d65:	d1 e8                	shr    %eax
c0107d67:	0b 45 d0             	or     -0x30(%ebp),%eax
c0107d6a:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0107d6d:	d1 ea                	shr    %edx
c0107d6f:	0b 55 d0             	or     -0x30(%ebp),%edx
c0107d72:	c1 ea 02             	shr    $0x2,%edx
c0107d75:	09 d0                	or     %edx,%eax
c0107d77:	89 c1                	mov    %eax,%ecx
c0107d79:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0107d7c:	d1 e8                	shr    %eax
c0107d7e:	0b 45 d0             	or     -0x30(%ebp),%eax
c0107d81:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0107d84:	d1 ea                	shr    %edx
c0107d86:	0b 55 d0             	or     -0x30(%ebp),%edx
c0107d89:	c1 ea 02             	shr    $0x2,%edx
c0107d8c:	09 d0                	or     %edx,%eax
c0107d8e:	c1 e8 04             	shr    $0x4,%eax
c0107d91:	09 c1                	or     %eax,%ecx
c0107d93:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0107d96:	d1 e8                	shr    %eax
c0107d98:	0b 45 d0             	or     -0x30(%ebp),%eax
c0107d9b:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0107d9e:	d1 ea                	shr    %edx
c0107da0:	0b 55 d0             	or     -0x30(%ebp),%edx
c0107da3:	c1 ea 02             	shr    $0x2,%edx
c0107da6:	09 d0                	or     %edx,%eax
c0107da8:	89 c6                	mov    %eax,%esi
c0107daa:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0107dad:	d1 e8                	shr    %eax
c0107daf:	0b 45 d0             	or     -0x30(%ebp),%eax
c0107db2:	89 c2                	mov    %eax,%edx
c0107db4:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0107db7:	d1 e8                	shr    %eax
c0107db9:	0b 45 d0             	or     -0x30(%ebp),%eax
c0107dbc:	c1 e8 02             	shr    $0x2,%eax
c0107dbf:	09 d0                	or     %edx,%eax
c0107dc1:	c1 e8 04             	shr    $0x4,%eax
c0107dc4:	09 f0                	or     %esi,%eax
c0107dc6:	c1 e8 08             	shr    $0x8,%eax
c0107dc9:	09 c8                	or     %ecx,%eax
c0107dcb:	c1 e8 10             	shr    $0x10,%eax
c0107dce:	09 d8                	or     %ebx,%eax
c0107dd0:	d1 e8                	shr    %eax
c0107dd2:	f7 d0                	not    %eax
c0107dd4:	23 45 d0             	and    -0x30(%ebp),%eax
c0107dd7:	89 c6                	mov    %eax,%esi
c0107dd9:	eb 03                	jmp    c0107dde <buddy_free_pages+0x564>
c0107ddb:	8b 75 d0             	mov    -0x30(%ebp),%esi
c0107dde:	89 f8                	mov    %edi,%eax
c0107de0:	ba 00 00 00 00       	mov    $0x0,%edx
c0107de5:	f7 f6                	div    %esi
c0107de7:	39 85 64 ff ff ff    	cmp    %eax,-0x9c(%ebp)
c0107ded:	0f 85 e3 08 00 00    	jne    c01086d6 <buddy_free_pages+0xe5c>
c0107df3:	a1 1c 3f 12 c0       	mov    0xc0123f1c,%eax
c0107df8:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0107dfb:	c1 e2 02             	shl    $0x2,%edx
c0107dfe:	01 d0                	add    %edx,%eax
c0107e00:	8b 00                	mov    (%eax),%eax
c0107e02:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
c0107e08:	8b 3d 10 3f 12 c0    	mov    0xc0123f10,%edi
c0107e0e:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0107e11:	d1 e8                	shr    %eax
c0107e13:	0b 45 cc             	or     -0x34(%ebp),%eax
c0107e16:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0107e19:	d1 ea                	shr    %edx
c0107e1b:	0b 55 cc             	or     -0x34(%ebp),%edx
c0107e1e:	c1 ea 02             	shr    $0x2,%edx
c0107e21:	09 d0                	or     %edx,%eax
c0107e23:	89 c1                	mov    %eax,%ecx
c0107e25:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0107e28:	d1 e8                	shr    %eax
c0107e2a:	0b 45 cc             	or     -0x34(%ebp),%eax
c0107e2d:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0107e30:	d1 ea                	shr    %edx
c0107e32:	0b 55 cc             	or     -0x34(%ebp),%edx
c0107e35:	c1 ea 02             	shr    $0x2,%edx
c0107e38:	09 d0                	or     %edx,%eax
c0107e3a:	c1 e8 04             	shr    $0x4,%eax
c0107e3d:	09 c1                	or     %eax,%ecx
c0107e3f:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0107e42:	d1 e8                	shr    %eax
c0107e44:	0b 45 cc             	or     -0x34(%ebp),%eax
c0107e47:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0107e4a:	d1 ea                	shr    %edx
c0107e4c:	0b 55 cc             	or     -0x34(%ebp),%edx
c0107e4f:	c1 ea 02             	shr    $0x2,%edx
c0107e52:	09 d0                	or     %edx,%eax
c0107e54:	89 c3                	mov    %eax,%ebx
c0107e56:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0107e59:	d1 e8                	shr    %eax
c0107e5b:	0b 45 cc             	or     -0x34(%ebp),%eax
c0107e5e:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0107e61:	d1 ea                	shr    %edx
c0107e63:	0b 55 cc             	or     -0x34(%ebp),%edx
c0107e66:	c1 ea 02             	shr    $0x2,%edx
c0107e69:	09 d0                	or     %edx,%eax
c0107e6b:	c1 e8 04             	shr    $0x4,%eax
c0107e6e:	09 d8                	or     %ebx,%eax
c0107e70:	c1 e8 08             	shr    $0x8,%eax
c0107e73:	89 cb                	mov    %ecx,%ebx
c0107e75:	09 c3                	or     %eax,%ebx
c0107e77:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0107e7a:	d1 e8                	shr    %eax
c0107e7c:	0b 45 cc             	or     -0x34(%ebp),%eax
c0107e7f:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0107e82:	d1 ea                	shr    %edx
c0107e84:	0b 55 cc             	or     -0x34(%ebp),%edx
c0107e87:	c1 ea 02             	shr    $0x2,%edx
c0107e8a:	09 d0                	or     %edx,%eax
c0107e8c:	89 c1                	mov    %eax,%ecx
c0107e8e:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0107e91:	d1 e8                	shr    %eax
c0107e93:	0b 45 cc             	or     -0x34(%ebp),%eax
c0107e96:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0107e99:	d1 ea                	shr    %edx
c0107e9b:	0b 55 cc             	or     -0x34(%ebp),%edx
c0107e9e:	c1 ea 02             	shr    $0x2,%edx
c0107ea1:	09 d0                	or     %edx,%eax
c0107ea3:	c1 e8 04             	shr    $0x4,%eax
c0107ea6:	09 c1                	or     %eax,%ecx
c0107ea8:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0107eab:	d1 e8                	shr    %eax
c0107ead:	0b 45 cc             	or     -0x34(%ebp),%eax
c0107eb0:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0107eb3:	d1 ea                	shr    %edx
c0107eb5:	0b 55 cc             	or     -0x34(%ebp),%edx
c0107eb8:	c1 ea 02             	shr    $0x2,%edx
c0107ebb:	09 d0                	or     %edx,%eax
c0107ebd:	89 c6                	mov    %eax,%esi
c0107ebf:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0107ec2:	d1 e8                	shr    %eax
c0107ec4:	0b 45 cc             	or     -0x34(%ebp),%eax
c0107ec7:	89 c2                	mov    %eax,%edx
c0107ec9:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0107ecc:	d1 e8                	shr    %eax
c0107ece:	0b 45 cc             	or     -0x34(%ebp),%eax
c0107ed1:	c1 e8 02             	shr    $0x2,%eax
c0107ed4:	09 d0                	or     %edx,%eax
c0107ed6:	c1 e8 04             	shr    $0x4,%eax
c0107ed9:	09 f0                	or     %esi,%eax
c0107edb:	c1 e8 08             	shr    $0x8,%eax
c0107ede:	09 c8                	or     %ecx,%eax
c0107ee0:	c1 e8 10             	shr    $0x10,%eax
c0107ee3:	09 d8                	or     %ebx,%eax
c0107ee5:	d1 e8                	shr    %eax
c0107ee7:	23 45 cc             	and    -0x34(%ebp),%eax
c0107eea:	85 c0                	test   %eax,%eax
c0107eec:	0f 84 e2 00 00 00    	je     c0107fd4 <buddy_free_pages+0x75a>
c0107ef2:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0107ef5:	d1 e8                	shr    %eax
c0107ef7:	0b 45 cc             	or     -0x34(%ebp),%eax
c0107efa:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0107efd:	d1 ea                	shr    %edx
c0107eff:	0b 55 cc             	or     -0x34(%ebp),%edx
c0107f02:	c1 ea 02             	shr    $0x2,%edx
c0107f05:	09 d0                	or     %edx,%eax
c0107f07:	89 c1                	mov    %eax,%ecx
c0107f09:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0107f0c:	d1 e8                	shr    %eax
c0107f0e:	0b 45 cc             	or     -0x34(%ebp),%eax
c0107f11:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0107f14:	d1 ea                	shr    %edx
c0107f16:	0b 55 cc             	or     -0x34(%ebp),%edx
c0107f19:	c1 ea 02             	shr    $0x2,%edx
c0107f1c:	09 d0                	or     %edx,%eax
c0107f1e:	c1 e8 04             	shr    $0x4,%eax
c0107f21:	09 c1                	or     %eax,%ecx
c0107f23:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0107f26:	d1 e8                	shr    %eax
c0107f28:	0b 45 cc             	or     -0x34(%ebp),%eax
c0107f2b:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0107f2e:	d1 ea                	shr    %edx
c0107f30:	0b 55 cc             	or     -0x34(%ebp),%edx
c0107f33:	c1 ea 02             	shr    $0x2,%edx
c0107f36:	09 d0                	or     %edx,%eax
c0107f38:	89 c3                	mov    %eax,%ebx
c0107f3a:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0107f3d:	d1 e8                	shr    %eax
c0107f3f:	0b 45 cc             	or     -0x34(%ebp),%eax
c0107f42:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0107f45:	d1 ea                	shr    %edx
c0107f47:	0b 55 cc             	or     -0x34(%ebp),%edx
c0107f4a:	c1 ea 02             	shr    $0x2,%edx
c0107f4d:	09 d0                	or     %edx,%eax
c0107f4f:	c1 e8 04             	shr    $0x4,%eax
c0107f52:	09 d8                	or     %ebx,%eax
c0107f54:	c1 e8 08             	shr    $0x8,%eax
c0107f57:	89 cb                	mov    %ecx,%ebx
c0107f59:	09 c3                	or     %eax,%ebx
c0107f5b:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0107f5e:	d1 e8                	shr    %eax
c0107f60:	0b 45 cc             	or     -0x34(%ebp),%eax
c0107f63:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0107f66:	d1 ea                	shr    %edx
c0107f68:	0b 55 cc             	or     -0x34(%ebp),%edx
c0107f6b:	c1 ea 02             	shr    $0x2,%edx
c0107f6e:	09 d0                	or     %edx,%eax
c0107f70:	89 c1                	mov    %eax,%ecx
c0107f72:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0107f75:	d1 e8                	shr    %eax
c0107f77:	0b 45 cc             	or     -0x34(%ebp),%eax
c0107f7a:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0107f7d:	d1 ea                	shr    %edx
c0107f7f:	0b 55 cc             	or     -0x34(%ebp),%edx
c0107f82:	c1 ea 02             	shr    $0x2,%edx
c0107f85:	09 d0                	or     %edx,%eax
c0107f87:	c1 e8 04             	shr    $0x4,%eax
c0107f8a:	09 c1                	or     %eax,%ecx
c0107f8c:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0107f8f:	d1 e8                	shr    %eax
c0107f91:	0b 45 cc             	or     -0x34(%ebp),%eax
c0107f94:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0107f97:	d1 ea                	shr    %edx
c0107f99:	0b 55 cc             	or     -0x34(%ebp),%edx
c0107f9c:	c1 ea 02             	shr    $0x2,%edx
c0107f9f:	09 d0                	or     %edx,%eax
c0107fa1:	89 c6                	mov    %eax,%esi
c0107fa3:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0107fa6:	d1 e8                	shr    %eax
c0107fa8:	0b 45 cc             	or     -0x34(%ebp),%eax
c0107fab:	89 c2                	mov    %eax,%edx
c0107fad:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0107fb0:	d1 e8                	shr    %eax
c0107fb2:	0b 45 cc             	or     -0x34(%ebp),%eax
c0107fb5:	c1 e8 02             	shr    $0x2,%eax
c0107fb8:	09 d0                	or     %edx,%eax
c0107fba:	c1 e8 04             	shr    $0x4,%eax
c0107fbd:	09 f0                	or     %esi,%eax
c0107fbf:	c1 e8 08             	shr    $0x8,%eax
c0107fc2:	09 c8                	or     %ecx,%eax
c0107fc4:	c1 e8 10             	shr    $0x10,%eax
c0107fc7:	09 d8                	or     %ebx,%eax
c0107fc9:	d1 e8                	shr    %eax
c0107fcb:	f7 d0                	not    %eax
c0107fcd:	23 45 cc             	and    -0x34(%ebp),%eax
c0107fd0:	89 c6                	mov    %eax,%esi
c0107fd2:	eb 03                	jmp    c0107fd7 <buddy_free_pages+0x75d>
c0107fd4:	8b 75 cc             	mov    -0x34(%ebp),%esi
c0107fd7:	89 f8                	mov    %edi,%eax
c0107fd9:	ba 00 00 00 00       	mov    $0x0,%edx
c0107fde:	f7 f6                	div    %esi
c0107fe0:	39 85 64 ff ff ff    	cmp    %eax,-0x9c(%ebp)
c0107fe6:	0f 85 ea 06 00 00    	jne    c01086d6 <buddy_free_pages+0xe5c>
            size_t lbegin = BUDDY_BEGIN(left);
c0107fec:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0107fef:	d1 e8                	shr    %eax
c0107ff1:	0b 45 d0             	or     -0x30(%ebp),%eax
c0107ff4:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0107ff7:	d1 ea                	shr    %edx
c0107ff9:	0b 55 d0             	or     -0x30(%ebp),%edx
c0107ffc:	c1 ea 02             	shr    $0x2,%edx
c0107fff:	09 d0                	or     %edx,%eax
c0108001:	89 c1                	mov    %eax,%ecx
c0108003:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0108006:	d1 e8                	shr    %eax
c0108008:	0b 45 d0             	or     -0x30(%ebp),%eax
c010800b:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010800e:	d1 ea                	shr    %edx
c0108010:	0b 55 d0             	or     -0x30(%ebp),%edx
c0108013:	c1 ea 02             	shr    $0x2,%edx
c0108016:	09 d0                	or     %edx,%eax
c0108018:	c1 e8 04             	shr    $0x4,%eax
c010801b:	09 c1                	or     %eax,%ecx
c010801d:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0108020:	d1 e8                	shr    %eax
c0108022:	0b 45 d0             	or     -0x30(%ebp),%eax
c0108025:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0108028:	d1 ea                	shr    %edx
c010802a:	0b 55 d0             	or     -0x30(%ebp),%edx
c010802d:	c1 ea 02             	shr    $0x2,%edx
c0108030:	09 d0                	or     %edx,%eax
c0108032:	89 c3                	mov    %eax,%ebx
c0108034:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0108037:	d1 e8                	shr    %eax
c0108039:	0b 45 d0             	or     -0x30(%ebp),%eax
c010803c:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010803f:	d1 ea                	shr    %edx
c0108041:	0b 55 d0             	or     -0x30(%ebp),%edx
c0108044:	c1 ea 02             	shr    $0x2,%edx
c0108047:	09 d0                	or     %edx,%eax
c0108049:	c1 e8 04             	shr    $0x4,%eax
c010804c:	09 d8                	or     %ebx,%eax
c010804e:	c1 e8 08             	shr    $0x8,%eax
c0108051:	09 c1                	or     %eax,%ecx
c0108053:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0108056:	d1 e8                	shr    %eax
c0108058:	0b 45 d0             	or     -0x30(%ebp),%eax
c010805b:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010805e:	d1 ea                	shr    %edx
c0108060:	0b 55 d0             	or     -0x30(%ebp),%edx
c0108063:	c1 ea 02             	shr    $0x2,%edx
c0108066:	09 d0                	or     %edx,%eax
c0108068:	89 c3                	mov    %eax,%ebx
c010806a:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010806d:	d1 e8                	shr    %eax
c010806f:	0b 45 d0             	or     -0x30(%ebp),%eax
c0108072:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0108075:	d1 ea                	shr    %edx
c0108077:	0b 55 d0             	or     -0x30(%ebp),%edx
c010807a:	c1 ea 02             	shr    $0x2,%edx
c010807d:	09 d0                	or     %edx,%eax
c010807f:	c1 e8 04             	shr    $0x4,%eax
c0108082:	09 c3                	or     %eax,%ebx
c0108084:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0108087:	d1 e8                	shr    %eax
c0108089:	0b 45 d0             	or     -0x30(%ebp),%eax
c010808c:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010808f:	d1 ea                	shr    %edx
c0108091:	0b 55 d0             	or     -0x30(%ebp),%edx
c0108094:	c1 ea 02             	shr    $0x2,%edx
c0108097:	09 d0                	or     %edx,%eax
c0108099:	89 c6                	mov    %eax,%esi
c010809b:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010809e:	d1 e8                	shr    %eax
c01080a0:	0b 45 d0             	or     -0x30(%ebp),%eax
c01080a3:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01080a6:	d1 ea                	shr    %edx
c01080a8:	0b 55 d0             	or     -0x30(%ebp),%edx
c01080ab:	c1 ea 02             	shr    $0x2,%edx
c01080ae:	09 d0                	or     %edx,%eax
c01080b0:	c1 e8 04             	shr    $0x4,%eax
c01080b3:	09 f0                	or     %esi,%eax
c01080b5:	c1 e8 08             	shr    $0x8,%eax
c01080b8:	09 d8                	or     %ebx,%eax
c01080ba:	c1 e8 10             	shr    $0x10,%eax
c01080bd:	09 c8                	or     %ecx,%eax
c01080bf:	d1 e8                	shr    %eax
c01080c1:	23 45 d0             	and    -0x30(%ebp),%eax
c01080c4:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
c01080ca:	8b 3d 10 3f 12 c0    	mov    0xc0123f10,%edi
c01080d0:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01080d3:	d1 e8                	shr    %eax
c01080d5:	0b 45 d0             	or     -0x30(%ebp),%eax
c01080d8:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01080db:	d1 ea                	shr    %edx
c01080dd:	0b 55 d0             	or     -0x30(%ebp),%edx
c01080e0:	c1 ea 02             	shr    $0x2,%edx
c01080e3:	09 d0                	or     %edx,%eax
c01080e5:	89 c1                	mov    %eax,%ecx
c01080e7:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01080ea:	d1 e8                	shr    %eax
c01080ec:	0b 45 d0             	or     -0x30(%ebp),%eax
c01080ef:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01080f2:	d1 ea                	shr    %edx
c01080f4:	0b 55 d0             	or     -0x30(%ebp),%edx
c01080f7:	c1 ea 02             	shr    $0x2,%edx
c01080fa:	09 d0                	or     %edx,%eax
c01080fc:	c1 e8 04             	shr    $0x4,%eax
c01080ff:	09 c1                	or     %eax,%ecx
c0108101:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0108104:	d1 e8                	shr    %eax
c0108106:	0b 45 d0             	or     -0x30(%ebp),%eax
c0108109:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010810c:	d1 ea                	shr    %edx
c010810e:	0b 55 d0             	or     -0x30(%ebp),%edx
c0108111:	c1 ea 02             	shr    $0x2,%edx
c0108114:	09 d0                	or     %edx,%eax
c0108116:	89 c3                	mov    %eax,%ebx
c0108118:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010811b:	d1 e8                	shr    %eax
c010811d:	0b 45 d0             	or     -0x30(%ebp),%eax
c0108120:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0108123:	d1 ea                	shr    %edx
c0108125:	0b 55 d0             	or     -0x30(%ebp),%edx
c0108128:	c1 ea 02             	shr    $0x2,%edx
c010812b:	09 d0                	or     %edx,%eax
c010812d:	c1 e8 04             	shr    $0x4,%eax
c0108130:	09 d8                	or     %ebx,%eax
c0108132:	c1 e8 08             	shr    $0x8,%eax
c0108135:	89 cb                	mov    %ecx,%ebx
c0108137:	09 c3                	or     %eax,%ebx
c0108139:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010813c:	d1 e8                	shr    %eax
c010813e:	0b 45 d0             	or     -0x30(%ebp),%eax
c0108141:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0108144:	d1 ea                	shr    %edx
c0108146:	0b 55 d0             	or     -0x30(%ebp),%edx
c0108149:	c1 ea 02             	shr    $0x2,%edx
c010814c:	09 d0                	or     %edx,%eax
c010814e:	89 c1                	mov    %eax,%ecx
c0108150:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0108153:	d1 e8                	shr    %eax
c0108155:	0b 45 d0             	or     -0x30(%ebp),%eax
c0108158:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010815b:	d1 ea                	shr    %edx
c010815d:	0b 55 d0             	or     -0x30(%ebp),%edx
c0108160:	c1 ea 02             	shr    $0x2,%edx
c0108163:	09 d0                	or     %edx,%eax
c0108165:	c1 e8 04             	shr    $0x4,%eax
c0108168:	09 c1                	or     %eax,%ecx
c010816a:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010816d:	d1 e8                	shr    %eax
c010816f:	0b 45 d0             	or     -0x30(%ebp),%eax
c0108172:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0108175:	d1 ea                	shr    %edx
c0108177:	0b 55 d0             	or     -0x30(%ebp),%edx
c010817a:	c1 ea 02             	shr    $0x2,%edx
c010817d:	09 d0                	or     %edx,%eax
c010817f:	89 c6                	mov    %eax,%esi
c0108181:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0108184:	d1 e8                	shr    %eax
c0108186:	0b 45 d0             	or     -0x30(%ebp),%eax
c0108189:	89 c2                	mov    %eax,%edx
c010818b:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010818e:	d1 e8                	shr    %eax
c0108190:	0b 45 d0             	or     -0x30(%ebp),%eax
c0108193:	c1 e8 02             	shr    $0x2,%eax
c0108196:	09 d0                	or     %edx,%eax
c0108198:	c1 e8 04             	shr    $0x4,%eax
c010819b:	09 f0                	or     %esi,%eax
c010819d:	c1 e8 08             	shr    $0x8,%eax
c01081a0:	09 c8                	or     %ecx,%eax
c01081a2:	c1 e8 10             	shr    $0x10,%eax
c01081a5:	09 d8                	or     %ebx,%eax
c01081a7:	d1 e8                	shr    %eax
c01081a9:	23 45 d0             	and    -0x30(%ebp),%eax
c01081ac:	85 c0                	test   %eax,%eax
c01081ae:	0f 84 e2 00 00 00    	je     c0108296 <buddy_free_pages+0xa1c>
c01081b4:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01081b7:	d1 e8                	shr    %eax
c01081b9:	0b 45 d0             	or     -0x30(%ebp),%eax
c01081bc:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01081bf:	d1 ea                	shr    %edx
c01081c1:	0b 55 d0             	or     -0x30(%ebp),%edx
c01081c4:	c1 ea 02             	shr    $0x2,%edx
c01081c7:	09 d0                	or     %edx,%eax
c01081c9:	89 c1                	mov    %eax,%ecx
c01081cb:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01081ce:	d1 e8                	shr    %eax
c01081d0:	0b 45 d0             	or     -0x30(%ebp),%eax
c01081d3:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01081d6:	d1 ea                	shr    %edx
c01081d8:	0b 55 d0             	or     -0x30(%ebp),%edx
c01081db:	c1 ea 02             	shr    $0x2,%edx
c01081de:	09 d0                	or     %edx,%eax
c01081e0:	c1 e8 04             	shr    $0x4,%eax
c01081e3:	09 c1                	or     %eax,%ecx
c01081e5:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01081e8:	d1 e8                	shr    %eax
c01081ea:	0b 45 d0             	or     -0x30(%ebp),%eax
c01081ed:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01081f0:	d1 ea                	shr    %edx
c01081f2:	0b 55 d0             	or     -0x30(%ebp),%edx
c01081f5:	c1 ea 02             	shr    $0x2,%edx
c01081f8:	09 d0                	or     %edx,%eax
c01081fa:	89 c3                	mov    %eax,%ebx
c01081fc:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01081ff:	d1 e8                	shr    %eax
c0108201:	0b 45 d0             	or     -0x30(%ebp),%eax
c0108204:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0108207:	d1 ea                	shr    %edx
c0108209:	0b 55 d0             	or     -0x30(%ebp),%edx
c010820c:	c1 ea 02             	shr    $0x2,%edx
c010820f:	09 d0                	or     %edx,%eax
c0108211:	c1 e8 04             	shr    $0x4,%eax
c0108214:	09 d8                	or     %ebx,%eax
c0108216:	c1 e8 08             	shr    $0x8,%eax
c0108219:	89 cb                	mov    %ecx,%ebx
c010821b:	09 c3                	or     %eax,%ebx
c010821d:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0108220:	d1 e8                	shr    %eax
c0108222:	0b 45 d0             	or     -0x30(%ebp),%eax
c0108225:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0108228:	d1 ea                	shr    %edx
c010822a:	0b 55 d0             	or     -0x30(%ebp),%edx
c010822d:	c1 ea 02             	shr    $0x2,%edx
c0108230:	09 d0                	or     %edx,%eax
c0108232:	89 c1                	mov    %eax,%ecx
c0108234:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0108237:	d1 e8                	shr    %eax
c0108239:	0b 45 d0             	or     -0x30(%ebp),%eax
c010823c:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010823f:	d1 ea                	shr    %edx
c0108241:	0b 55 d0             	or     -0x30(%ebp),%edx
c0108244:	c1 ea 02             	shr    $0x2,%edx
c0108247:	09 d0                	or     %edx,%eax
c0108249:	c1 e8 04             	shr    $0x4,%eax
c010824c:	09 c1                	or     %eax,%ecx
c010824e:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0108251:	d1 e8                	shr    %eax
c0108253:	0b 45 d0             	or     -0x30(%ebp),%eax
c0108256:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0108259:	d1 ea                	shr    %edx
c010825b:	0b 55 d0             	or     -0x30(%ebp),%edx
c010825e:	c1 ea 02             	shr    $0x2,%edx
c0108261:	09 d0                	or     %edx,%eax
c0108263:	89 c6                	mov    %eax,%esi
c0108265:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0108268:	d1 e8                	shr    %eax
c010826a:	0b 45 d0             	or     -0x30(%ebp),%eax
c010826d:	89 c2                	mov    %eax,%edx
c010826f:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0108272:	d1 e8                	shr    %eax
c0108274:	0b 45 d0             	or     -0x30(%ebp),%eax
c0108277:	c1 e8 02             	shr    $0x2,%eax
c010827a:	09 d0                	or     %edx,%eax
c010827c:	c1 e8 04             	shr    $0x4,%eax
c010827f:	09 f0                	or     %esi,%eax
c0108281:	c1 e8 08             	shr    $0x8,%eax
c0108284:	09 c8                	or     %ecx,%eax
c0108286:	c1 e8 10             	shr    $0x10,%eax
c0108289:	09 d8                	or     %ebx,%eax
c010828b:	d1 e8                	shr    %eax
c010828d:	f7 d0                	not    %eax
c010828f:	23 45 d0             	and    -0x30(%ebp),%eax
c0108292:	89 c6                	mov    %eax,%esi
c0108294:	eb 03                	jmp    c0108299 <buddy_free_pages+0xa1f>
c0108296:	8b 75 d0             	mov    -0x30(%ebp),%esi
c0108299:	89 f8                	mov    %edi,%eax
c010829b:	ba 00 00 00 00       	mov    $0x0,%edx
c01082a0:	f7 f6                	div    %esi
c01082a2:	0f af 85 64 ff ff ff 	imul   -0x9c(%ebp),%eax
c01082a9:	89 45 c8             	mov    %eax,-0x38(%ebp)
            size_t rbegin = BUDDY_BEGIN(right);
c01082ac:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01082af:	d1 e8                	shr    %eax
c01082b1:	0b 45 cc             	or     -0x34(%ebp),%eax
c01082b4:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01082b7:	d1 ea                	shr    %edx
c01082b9:	0b 55 cc             	or     -0x34(%ebp),%edx
c01082bc:	c1 ea 02             	shr    $0x2,%edx
c01082bf:	09 d0                	or     %edx,%eax
c01082c1:	89 c1                	mov    %eax,%ecx
c01082c3:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01082c6:	d1 e8                	shr    %eax
c01082c8:	0b 45 cc             	or     -0x34(%ebp),%eax
c01082cb:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01082ce:	d1 ea                	shr    %edx
c01082d0:	0b 55 cc             	or     -0x34(%ebp),%edx
c01082d3:	c1 ea 02             	shr    $0x2,%edx
c01082d6:	09 d0                	or     %edx,%eax
c01082d8:	c1 e8 04             	shr    $0x4,%eax
c01082db:	09 c1                	or     %eax,%ecx
c01082dd:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01082e0:	d1 e8                	shr    %eax
c01082e2:	0b 45 cc             	or     -0x34(%ebp),%eax
c01082e5:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01082e8:	d1 ea                	shr    %edx
c01082ea:	0b 55 cc             	or     -0x34(%ebp),%edx
c01082ed:	c1 ea 02             	shr    $0x2,%edx
c01082f0:	09 d0                	or     %edx,%eax
c01082f2:	89 c3                	mov    %eax,%ebx
c01082f4:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01082f7:	d1 e8                	shr    %eax
c01082f9:	0b 45 cc             	or     -0x34(%ebp),%eax
c01082fc:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01082ff:	d1 ea                	shr    %edx
c0108301:	0b 55 cc             	or     -0x34(%ebp),%edx
c0108304:	c1 ea 02             	shr    $0x2,%edx
c0108307:	09 d0                	or     %edx,%eax
c0108309:	c1 e8 04             	shr    $0x4,%eax
c010830c:	09 d8                	or     %ebx,%eax
c010830e:	c1 e8 08             	shr    $0x8,%eax
c0108311:	09 c1                	or     %eax,%ecx
c0108313:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0108316:	d1 e8                	shr    %eax
c0108318:	0b 45 cc             	or     -0x34(%ebp),%eax
c010831b:	8b 55 cc             	mov    -0x34(%ebp),%edx
c010831e:	d1 ea                	shr    %edx
c0108320:	0b 55 cc             	or     -0x34(%ebp),%edx
c0108323:	c1 ea 02             	shr    $0x2,%edx
c0108326:	09 d0                	or     %edx,%eax
c0108328:	89 c3                	mov    %eax,%ebx
c010832a:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010832d:	d1 e8                	shr    %eax
c010832f:	0b 45 cc             	or     -0x34(%ebp),%eax
c0108332:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0108335:	d1 ea                	shr    %edx
c0108337:	0b 55 cc             	or     -0x34(%ebp),%edx
c010833a:	c1 ea 02             	shr    $0x2,%edx
c010833d:	09 d0                	or     %edx,%eax
c010833f:	c1 e8 04             	shr    $0x4,%eax
c0108342:	09 c3                	or     %eax,%ebx
c0108344:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0108347:	d1 e8                	shr    %eax
c0108349:	0b 45 cc             	or     -0x34(%ebp),%eax
c010834c:	8b 55 cc             	mov    -0x34(%ebp),%edx
c010834f:	d1 ea                	shr    %edx
c0108351:	0b 55 cc             	or     -0x34(%ebp),%edx
c0108354:	c1 ea 02             	shr    $0x2,%edx
c0108357:	09 d0                	or     %edx,%eax
c0108359:	89 c6                	mov    %eax,%esi
c010835b:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010835e:	d1 e8                	shr    %eax
c0108360:	0b 45 cc             	or     -0x34(%ebp),%eax
c0108363:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0108366:	d1 ea                	shr    %edx
c0108368:	0b 55 cc             	or     -0x34(%ebp),%edx
c010836b:	c1 ea 02             	shr    $0x2,%edx
c010836e:	09 d0                	or     %edx,%eax
c0108370:	c1 e8 04             	shr    $0x4,%eax
c0108373:	09 f0                	or     %esi,%eax
c0108375:	c1 e8 08             	shr    $0x8,%eax
c0108378:	09 d8                	or     %ebx,%eax
c010837a:	c1 e8 10             	shr    $0x10,%eax
c010837d:	09 c8                	or     %ecx,%eax
c010837f:	d1 e8                	shr    %eax
c0108381:	23 45 cc             	and    -0x34(%ebp),%eax
c0108384:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
c010838a:	8b 3d 10 3f 12 c0    	mov    0xc0123f10,%edi
c0108390:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0108393:	d1 e8                	shr    %eax
c0108395:	0b 45 cc             	or     -0x34(%ebp),%eax
c0108398:	8b 55 cc             	mov    -0x34(%ebp),%edx
c010839b:	d1 ea                	shr    %edx
c010839d:	0b 55 cc             	or     -0x34(%ebp),%edx
c01083a0:	c1 ea 02             	shr    $0x2,%edx
c01083a3:	09 d0                	or     %edx,%eax
c01083a5:	89 c1                	mov    %eax,%ecx
c01083a7:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01083aa:	d1 e8                	shr    %eax
c01083ac:	0b 45 cc             	or     -0x34(%ebp),%eax
c01083af:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01083b2:	d1 ea                	shr    %edx
c01083b4:	0b 55 cc             	or     -0x34(%ebp),%edx
c01083b7:	c1 ea 02             	shr    $0x2,%edx
c01083ba:	09 d0                	or     %edx,%eax
c01083bc:	c1 e8 04             	shr    $0x4,%eax
c01083bf:	09 c1                	or     %eax,%ecx
c01083c1:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01083c4:	d1 e8                	shr    %eax
c01083c6:	0b 45 cc             	or     -0x34(%ebp),%eax
c01083c9:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01083cc:	d1 ea                	shr    %edx
c01083ce:	0b 55 cc             	or     -0x34(%ebp),%edx
c01083d1:	c1 ea 02             	shr    $0x2,%edx
c01083d4:	09 d0                	or     %edx,%eax
c01083d6:	89 c3                	mov    %eax,%ebx
c01083d8:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01083db:	d1 e8                	shr    %eax
c01083dd:	0b 45 cc             	or     -0x34(%ebp),%eax
c01083e0:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01083e3:	d1 ea                	shr    %edx
c01083e5:	0b 55 cc             	or     -0x34(%ebp),%edx
c01083e8:	c1 ea 02             	shr    $0x2,%edx
c01083eb:	09 d0                	or     %edx,%eax
c01083ed:	c1 e8 04             	shr    $0x4,%eax
c01083f0:	09 d8                	or     %ebx,%eax
c01083f2:	c1 e8 08             	shr    $0x8,%eax
c01083f5:	89 cb                	mov    %ecx,%ebx
c01083f7:	09 c3                	or     %eax,%ebx
c01083f9:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01083fc:	d1 e8                	shr    %eax
c01083fe:	0b 45 cc             	or     -0x34(%ebp),%eax
c0108401:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0108404:	d1 ea                	shr    %edx
c0108406:	0b 55 cc             	or     -0x34(%ebp),%edx
c0108409:	c1 ea 02             	shr    $0x2,%edx
c010840c:	09 d0                	or     %edx,%eax
c010840e:	89 c1                	mov    %eax,%ecx
c0108410:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0108413:	d1 e8                	shr    %eax
c0108415:	0b 45 cc             	or     -0x34(%ebp),%eax
c0108418:	8b 55 cc             	mov    -0x34(%ebp),%edx
c010841b:	d1 ea                	shr    %edx
c010841d:	0b 55 cc             	or     -0x34(%ebp),%edx
c0108420:	c1 ea 02             	shr    $0x2,%edx
c0108423:	09 d0                	or     %edx,%eax
c0108425:	c1 e8 04             	shr    $0x4,%eax
c0108428:	09 c1                	or     %eax,%ecx
c010842a:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010842d:	d1 e8                	shr    %eax
c010842f:	0b 45 cc             	or     -0x34(%ebp),%eax
c0108432:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0108435:	d1 ea                	shr    %edx
c0108437:	0b 55 cc             	or     -0x34(%ebp),%edx
c010843a:	c1 ea 02             	shr    $0x2,%edx
c010843d:	09 d0                	or     %edx,%eax
c010843f:	89 c6                	mov    %eax,%esi
c0108441:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0108444:	d1 e8                	shr    %eax
c0108446:	0b 45 cc             	or     -0x34(%ebp),%eax
c0108449:	89 c2                	mov    %eax,%edx
c010844b:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010844e:	d1 e8                	shr    %eax
c0108450:	0b 45 cc             	or     -0x34(%ebp),%eax
c0108453:	c1 e8 02             	shr    $0x2,%eax
c0108456:	09 d0                	or     %edx,%eax
c0108458:	c1 e8 04             	shr    $0x4,%eax
c010845b:	09 f0                	or     %esi,%eax
c010845d:	c1 e8 08             	shr    $0x8,%eax
c0108460:	09 c8                	or     %ecx,%eax
c0108462:	c1 e8 10             	shr    $0x10,%eax
c0108465:	09 d8                	or     %ebx,%eax
c0108467:	d1 e8                	shr    %eax
c0108469:	23 45 cc             	and    -0x34(%ebp),%eax
c010846c:	85 c0                	test   %eax,%eax
c010846e:	0f 84 e2 00 00 00    	je     c0108556 <buddy_free_pages+0xcdc>
c0108474:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0108477:	d1 e8                	shr    %eax
c0108479:	0b 45 cc             	or     -0x34(%ebp),%eax
c010847c:	8b 55 cc             	mov    -0x34(%ebp),%edx
c010847f:	d1 ea                	shr    %edx
c0108481:	0b 55 cc             	or     -0x34(%ebp),%edx
c0108484:	c1 ea 02             	shr    $0x2,%edx
c0108487:	09 d0                	or     %edx,%eax
c0108489:	89 c1                	mov    %eax,%ecx
c010848b:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010848e:	d1 e8                	shr    %eax
c0108490:	0b 45 cc             	or     -0x34(%ebp),%eax
c0108493:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0108496:	d1 ea                	shr    %edx
c0108498:	0b 55 cc             	or     -0x34(%ebp),%edx
c010849b:	c1 ea 02             	shr    $0x2,%edx
c010849e:	09 d0                	or     %edx,%eax
c01084a0:	c1 e8 04             	shr    $0x4,%eax
c01084a3:	09 c1                	or     %eax,%ecx
c01084a5:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01084a8:	d1 e8                	shr    %eax
c01084aa:	0b 45 cc             	or     -0x34(%ebp),%eax
c01084ad:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01084b0:	d1 ea                	shr    %edx
c01084b2:	0b 55 cc             	or     -0x34(%ebp),%edx
c01084b5:	c1 ea 02             	shr    $0x2,%edx
c01084b8:	09 d0                	or     %edx,%eax
c01084ba:	89 c3                	mov    %eax,%ebx
c01084bc:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01084bf:	d1 e8                	shr    %eax
c01084c1:	0b 45 cc             	or     -0x34(%ebp),%eax
c01084c4:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01084c7:	d1 ea                	shr    %edx
c01084c9:	0b 55 cc             	or     -0x34(%ebp),%edx
c01084cc:	c1 ea 02             	shr    $0x2,%edx
c01084cf:	09 d0                	or     %edx,%eax
c01084d1:	c1 e8 04             	shr    $0x4,%eax
c01084d4:	09 d8                	or     %ebx,%eax
c01084d6:	c1 e8 08             	shr    $0x8,%eax
c01084d9:	89 cb                	mov    %ecx,%ebx
c01084db:	09 c3                	or     %eax,%ebx
c01084dd:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01084e0:	d1 e8                	shr    %eax
c01084e2:	0b 45 cc             	or     -0x34(%ebp),%eax
c01084e5:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01084e8:	d1 ea                	shr    %edx
c01084ea:	0b 55 cc             	or     -0x34(%ebp),%edx
c01084ed:	c1 ea 02             	shr    $0x2,%edx
c01084f0:	09 d0                	or     %edx,%eax
c01084f2:	89 c1                	mov    %eax,%ecx
c01084f4:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01084f7:	d1 e8                	shr    %eax
c01084f9:	0b 45 cc             	or     -0x34(%ebp),%eax
c01084fc:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01084ff:	d1 ea                	shr    %edx
c0108501:	0b 55 cc             	or     -0x34(%ebp),%edx
c0108504:	c1 ea 02             	shr    $0x2,%edx
c0108507:	09 d0                	or     %edx,%eax
c0108509:	c1 e8 04             	shr    $0x4,%eax
c010850c:	09 c1                	or     %eax,%ecx
c010850e:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0108511:	d1 e8                	shr    %eax
c0108513:	0b 45 cc             	or     -0x34(%ebp),%eax
c0108516:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0108519:	d1 ea                	shr    %edx
c010851b:	0b 55 cc             	or     -0x34(%ebp),%edx
c010851e:	c1 ea 02             	shr    $0x2,%edx
c0108521:	09 d0                	or     %edx,%eax
c0108523:	89 c6                	mov    %eax,%esi
c0108525:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0108528:	d1 e8                	shr    %eax
c010852a:	0b 45 cc             	or     -0x34(%ebp),%eax
c010852d:	89 c2                	mov    %eax,%edx
c010852f:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0108532:	d1 e8                	shr    %eax
c0108534:	0b 45 cc             	or     -0x34(%ebp),%eax
c0108537:	c1 e8 02             	shr    $0x2,%eax
c010853a:	09 d0                	or     %edx,%eax
c010853c:	c1 e8 04             	shr    $0x4,%eax
c010853f:	09 f0                	or     %esi,%eax
c0108541:	c1 e8 08             	shr    $0x8,%eax
c0108544:	09 c8                	or     %ecx,%eax
c0108546:	c1 e8 10             	shr    $0x10,%eax
c0108549:	09 d8                	or     %ebx,%eax
c010854b:	d1 e8                	shr    %eax
c010854d:	f7 d0                	not    %eax
c010854f:	23 45 cc             	and    -0x34(%ebp),%eax
c0108552:	89 c6                	mov    %eax,%esi
c0108554:	eb 03                	jmp    c0108559 <buddy_free_pages+0xcdf>
c0108556:	8b 75 cc             	mov    -0x34(%ebp),%esi
c0108559:	89 f8                	mov    %edi,%eax
c010855b:	ba 00 00 00 00       	mov    $0x0,%edx
c0108560:	f7 f6                	div    %esi
c0108562:	0f af 85 64 ff ff ff 	imul   -0x9c(%ebp),%eax
c0108569:	89 45 c4             	mov    %eax,-0x3c(%ebp)
            list_del(&(buddy_alloc[lbegin].page_link));
c010856c:	8b 0d 24 3f 12 c0    	mov    0xc0123f24,%ecx
c0108572:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0108575:	89 d0                	mov    %edx,%eax
c0108577:	c1 e0 02             	shl    $0x2,%eax
c010857a:	01 d0                	add    %edx,%eax
c010857c:	c1 e0 02             	shl    $0x2,%eax
c010857f:	01 c8                	add    %ecx,%eax
c0108581:	83 c0 0c             	add    $0xc,%eax
c0108584:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
    __list_del(listelm->prev, listelm->next);
c010858a:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
c0108590:	8b 40 04             	mov    0x4(%eax),%eax
c0108593:	8b 95 70 ff ff ff    	mov    -0x90(%ebp),%edx
c0108599:	8b 12                	mov    (%edx),%edx
c010859b:	89 95 6c ff ff ff    	mov    %edx,-0x94(%ebp)
c01085a1:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)
    prev->next = next;
c01085a7:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
c01085ad:	8b 95 68 ff ff ff    	mov    -0x98(%ebp),%edx
c01085b3:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c01085b6:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
c01085bc:	8b 95 6c ff ff ff    	mov    -0x94(%ebp),%edx
c01085c2:	89 10                	mov    %edx,(%eax)
}
c01085c4:	90                   	nop
}
c01085c5:	90                   	nop
            list_del(&(buddy_alloc[rbegin].page_link));
c01085c6:	8b 0d 24 3f 12 c0    	mov    0xc0123f24,%ecx
c01085cc:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c01085cf:	89 d0                	mov    %edx,%eax
c01085d1:	c1 e0 02             	shl    $0x2,%eax
c01085d4:	01 d0                	add    %edx,%eax
c01085d6:	c1 e0 02             	shl    $0x2,%eax
c01085d9:	01 c8                	add    %ecx,%eax
c01085db:	83 c0 0c             	add    $0xc,%eax
c01085de:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
    __list_del(listelm->prev, listelm->next);
c01085e4:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c01085ea:	8b 40 04             	mov    0x4(%eax),%eax
c01085ed:	8b 95 7c ff ff ff    	mov    -0x84(%ebp),%edx
c01085f3:	8b 12                	mov    (%edx),%edx
c01085f5:	89 95 78 ff ff ff    	mov    %edx,-0x88(%ebp)
c01085fb:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
    prev->next = next;
c0108601:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
c0108607:	8b 95 74 ff ff ff    	mov    -0x8c(%ebp),%edx
c010860d:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0108610:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
c0108616:	8b 95 78 ff ff ff    	mov    -0x88(%ebp),%edx
c010861c:	89 10                	mov    %edx,(%eax)
}
c010861e:	90                   	nop
}
c010861f:	90                   	nop
            buddy_segment[block] = buddy_segment[left]<<1;
c0108620:	a1 1c 3f 12 c0       	mov    0xc0123f1c,%eax
c0108625:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0108628:	c1 e2 02             	shl    $0x2,%edx
c010862b:	01 d0                	add    %edx,%eax
c010862d:	8b 10                	mov    (%eax),%edx
c010862f:	a1 1c 3f 12 c0       	mov    0xc0123f1c,%eax
c0108634:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c0108637:	c1 e1 02             	shl    $0x2,%ecx
c010863a:	01 c8                	add    %ecx,%eax
c010863c:	01 d2                	add    %edx,%edx
c010863e:	89 10                	mov    %edx,(%eax)
            buddy_alloc[lbegin].property = buddy_segment[left]<<1;
c0108640:	a1 1c 3f 12 c0       	mov    0xc0123f1c,%eax
c0108645:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0108648:	c1 e2 02             	shl    $0x2,%edx
c010864b:	01 d0                	add    %edx,%eax
c010864d:	8b 08                	mov    (%eax),%ecx
c010864f:	8b 1d 24 3f 12 c0    	mov    0xc0123f24,%ebx
c0108655:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0108658:	89 d0                	mov    %edx,%eax
c010865a:	c1 e0 02             	shl    $0x2,%eax
c010865d:	01 d0                	add    %edx,%eax
c010865f:	c1 e0 02             	shl    $0x2,%eax
c0108662:	01 d8                	add    %ebx,%eax
c0108664:	8d 14 09             	lea    (%ecx,%ecx,1),%edx
c0108667:	89 50 08             	mov    %edx,0x8(%eax)
            list_add(&(free_list), &(buddy_alloc[lbegin].page_link));
c010866a:	8b 0d 24 3f 12 c0    	mov    0xc0123f24,%ecx
c0108670:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0108673:	89 d0                	mov    %edx,%eax
c0108675:	c1 e0 02             	shl    $0x2,%eax
c0108678:	01 d0                	add    %edx,%eax
c010867a:	c1 e0 02             	shl    $0x2,%eax
c010867d:	01 c8                	add    %ecx,%eax
c010867f:	83 c0 0c             	add    $0xc,%eax
c0108682:	c7 45 98 38 3f 12 c0 	movl   $0xc0123f38,-0x68(%ebp)
c0108689:	89 45 94             	mov    %eax,-0x6c(%ebp)
c010868c:	8b 45 98             	mov    -0x68(%ebp),%eax
c010868f:	89 45 90             	mov    %eax,-0x70(%ebp)
c0108692:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0108695:	89 45 8c             	mov    %eax,-0x74(%ebp)
    __list_add(elm, listelm, listelm->next);
c0108698:	8b 45 90             	mov    -0x70(%ebp),%eax
c010869b:	8b 40 04             	mov    0x4(%eax),%eax
c010869e:	8b 55 8c             	mov    -0x74(%ebp),%edx
c01086a1:	89 55 88             	mov    %edx,-0x78(%ebp)
c01086a4:	8b 55 90             	mov    -0x70(%ebp),%edx
c01086a7:	89 55 84             	mov    %edx,-0x7c(%ebp)
c01086aa:	89 45 80             	mov    %eax,-0x80(%ebp)
    prev->next = next->prev = elm;
c01086ad:	8b 45 80             	mov    -0x80(%ebp),%eax
c01086b0:	8b 55 88             	mov    -0x78(%ebp),%edx
c01086b3:	89 10                	mov    %edx,(%eax)
c01086b5:	8b 45 80             	mov    -0x80(%ebp),%eax
c01086b8:	8b 10                	mov    (%eax),%edx
c01086ba:	8b 45 84             	mov    -0x7c(%ebp),%eax
c01086bd:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01086c0:	8b 45 88             	mov    -0x78(%ebp),%eax
c01086c3:	8b 55 80             	mov    -0x80(%ebp),%edx
c01086c6:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01086c9:	8b 45 88             	mov    -0x78(%ebp),%eax
c01086cc:	8b 55 84             	mov    -0x7c(%ebp),%edx
c01086cf:	89 10                	mov    %edx,(%eax)
}
c01086d1:	90                   	nop
}
c01086d2:	90                   	nop
}
c01086d3:	90                   	nop
        if (BUDDY_EMPTY(left) && BUDDY_EMPTY(right)) {  // Merge
c01086d4:	eb 32                	jmp    c0108708 <buddy_free_pages+0xe8e>
        } else {                                        // Update
            buddy_segment[block] = buddy_segment[BUDDY_LEFT(block)] | buddy_segment[BUDDY_RIGHT(block)];
c01086d6:	a1 1c 3f 12 c0       	mov    0xc0123f1c,%eax
c01086db:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01086de:	c1 e2 03             	shl    $0x3,%edx
c01086e1:	01 d0                	add    %edx,%eax
c01086e3:	8b 08                	mov    (%eax),%ecx
c01086e5:	a1 1c 3f 12 c0       	mov    0xc0123f1c,%eax
c01086ea:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01086ed:	c1 e2 03             	shl    $0x3,%edx
c01086f0:	83 c2 04             	add    $0x4,%edx
c01086f3:	01 d0                	add    %edx,%eax
c01086f5:	8b 10                	mov    (%eax),%edx
c01086f7:	a1 1c 3f 12 c0       	mov    0xc0123f1c,%eax
c01086fc:	8b 5d e0             	mov    -0x20(%ebp),%ebx
c01086ff:	c1 e3 02             	shl    $0x2,%ebx
c0108702:	01 d8                	add    %ebx,%eax
c0108704:	09 ca                	or     %ecx,%edx
c0108706:	89 10                	mov    %edx,(%eax)
    while (block != BUDDY_ROOT) {
c0108708:	83 7d e0 01          	cmpl   $0x1,-0x20(%ebp)
c010870c:	0f 85 d4 f4 ff ff    	jne    c0107be6 <buddy_free_pages+0x36c>
        }
    }
}
c0108712:	90                   	nop
c0108713:	90                   	nop
c0108714:	81 c4 ac 00 00 00    	add    $0xac,%esp
c010871a:	5b                   	pop    %ebx
c010871b:	5e                   	pop    %esi
c010871c:	5f                   	pop    %edi
c010871d:	5d                   	pop    %ebp
c010871e:	c3                   	ret    

c010871f <buddy_nr_free_pages>:

static size_t
buddy_nr_free_pages(void) {
c010871f:	f3 0f 1e fb          	endbr32 
c0108723:	55                   	push   %ebp
c0108724:	89 e5                	mov    %esp,%ebp
    return nr_free;
c0108726:	a1 40 3f 12 c0       	mov    0xc0123f40,%eax
}
c010872b:	5d                   	pop    %ebp
c010872c:	c3                   	ret    

c010872d <macro_check>:

static void
macro_check(void) {
c010872d:	f3 0f 1e fb          	endbr32 
c0108731:	55                   	push   %ebp
c0108732:	89 e5                	mov    %esp,%ebp
c0108734:	83 ec 28             	sub    $0x28,%esp
    assert(BUDDY_ROOT == 1);
    assert(BUDDY_LEFT(3) == 6);
    assert(BUDDY_RIGHT(3) == 7);
    assert(BUDDY_PARENT(6) == 3);
    assert(BUDDY_PARENT(7) == 3);
    size_t buddy_virtual_size_store = buddy_virtual_size;
c0108737:	a1 10 3f 12 c0       	mov    0xc0123f10,%eax
c010873c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    size_t buddy_segment_root_store = buddy_segment[BUDDY_ROOT];
c010873f:	a1 1c 3f 12 c0       	mov    0xc0123f1c,%eax
c0108744:	8b 40 04             	mov    0x4(%eax),%eax
c0108747:	89 45 f0             	mov    %eax,-0x10(%ebp)
    buddy_virtual_size = 16;
c010874a:	c7 05 10 3f 12 c0 10 	movl   $0x10,0xc0123f10
c0108751:	00 00 00 
    buddy_segment[BUDDY_ROOT] = 16;
c0108754:	a1 1c 3f 12 c0       	mov    0xc0123f1c,%eax
c0108759:	83 c0 04             	add    $0x4,%eax
c010875c:	c7 00 10 00 00 00    	movl   $0x10,(%eax)
    assert(BUDDY_LENGTH(6) == 4);
c0108762:	a1 10 3f 12 c0       	mov    0xc0123f10,%eax
c0108767:	83 e8 10             	sub    $0x10,%eax
c010876a:	83 f8 03             	cmp    $0x3,%eax
c010876d:	76 24                	jbe    c0108793 <macro_check+0x66>
c010876f:	c7 44 24 0c 34 b3 10 	movl   $0xc010b334,0xc(%esp)
c0108776:	c0 
c0108777:	c7 44 24 08 be b2 10 	movl   $0xc010b2be,0x8(%esp)
c010877e:	c0 
c010877f:	c7 44 24 04 e0 00 00 	movl   $0xe0,0x4(%esp)
c0108786:	00 
c0108787:	c7 04 24 d3 b2 10 c0 	movl   $0xc010b2d3,(%esp)
c010878e:	e8 a3 7c ff ff       	call   c0100436 <__panic>
    assert(BUDDY_BEGIN(6) == 8);
c0108793:	a1 10 3f 12 c0       	mov    0xc0123f10,%eax
c0108798:	c1 e8 02             	shr    $0x2,%eax
c010879b:	01 c0                	add    %eax,%eax
c010879d:	83 f8 08             	cmp    $0x8,%eax
c01087a0:	74 24                	je     c01087c6 <macro_check+0x99>
c01087a2:	c7 44 24 0c 49 b3 10 	movl   $0xc010b349,0xc(%esp)
c01087a9:	c0 
c01087aa:	c7 44 24 08 be b2 10 	movl   $0xc010b2be,0x8(%esp)
c01087b1:	c0 
c01087b2:	c7 44 24 04 e1 00 00 	movl   $0xe1,0x4(%esp)
c01087b9:	00 
c01087ba:	c7 04 24 d3 b2 10 c0 	movl   $0xc010b2d3,(%esp)
c01087c1:	e8 70 7c ff ff       	call   c0100436 <__panic>
    assert(BUDDY_END(6) == 12);
c01087c6:	a1 10 3f 12 c0       	mov    0xc0123f10,%eax
c01087cb:	c1 e8 02             	shr    $0x2,%eax
c01087ce:	89 c2                	mov    %eax,%edx
c01087d0:	89 d0                	mov    %edx,%eax
c01087d2:	01 c0                	add    %eax,%eax
c01087d4:	01 d0                	add    %edx,%eax
c01087d6:	83 f8 0c             	cmp    $0xc,%eax
c01087d9:	74 24                	je     c01087ff <macro_check+0xd2>
c01087db:	c7 44 24 0c 5d b3 10 	movl   $0xc010b35d,0xc(%esp)
c01087e2:	c0 
c01087e3:	c7 44 24 08 be b2 10 	movl   $0xc010b2be,0x8(%esp)
c01087ea:	c0 
c01087eb:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
c01087f2:	00 
c01087f3:	c7 04 24 d3 b2 10 c0 	movl   $0xc010b2d3,(%esp)
c01087fa:	e8 37 7c ff ff       	call   c0100436 <__panic>
    assert(BUDDY_BLOCK(8, 12) == 6);
c01087ff:	a1 10 3f 12 c0       	mov    0xc0123f10,%eax
c0108804:	83 e8 10             	sub    $0x10,%eax
c0108807:	83 f8 03             	cmp    $0x3,%eax
c010880a:	76 24                	jbe    c0108830 <macro_check+0x103>
c010880c:	c7 44 24 0c 70 b3 10 	movl   $0xc010b370,0xc(%esp)
c0108813:	c0 
c0108814:	c7 44 24 08 be b2 10 	movl   $0xc010b2be,0x8(%esp)
c010881b:	c0 
c010881c:	c7 44 24 04 e3 00 00 	movl   $0xe3,0x4(%esp)
c0108823:	00 
c0108824:	c7 04 24 d3 b2 10 c0 	movl   $0xc010b2d3,(%esp)
c010882b:	e8 06 7c ff ff       	call   c0100436 <__panic>
    assert(BUDDY_EMPTY(BUDDY_ROOT));
c0108830:	a1 1c 3f 12 c0       	mov    0xc0123f1c,%eax
c0108835:	83 c0 04             	add    $0x4,%eax
c0108838:	8b 10                	mov    (%eax),%edx
c010883a:	a1 10 3f 12 c0       	mov    0xc0123f10,%eax
c010883f:	39 c2                	cmp    %eax,%edx
c0108841:	74 24                	je     c0108867 <macro_check+0x13a>
c0108843:	c7 44 24 0c 88 b3 10 	movl   $0xc010b388,0xc(%esp)
c010884a:	c0 
c010884b:	c7 44 24 08 be b2 10 	movl   $0xc010b2be,0x8(%esp)
c0108852:	c0 
c0108853:	c7 44 24 04 e4 00 00 	movl   $0xe4,0x4(%esp)
c010885a:	00 
c010885b:	c7 04 24 d3 b2 10 c0 	movl   $0xc010b2d3,(%esp)
c0108862:	e8 cf 7b ff ff       	call   c0100436 <__panic>
    buddy_virtual_size = buddy_virtual_size_store;
c0108867:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010886a:	a3 10 3f 12 c0       	mov    %eax,0xc0123f10
    buddy_segment[BUDDY_ROOT] = buddy_segment_root_store;
c010886f:	a1 1c 3f 12 c0       	mov    0xc0123f1c,%eax
c0108874:	8d 50 04             	lea    0x4(%eax),%edx
c0108877:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010887a:	89 02                	mov    %eax,(%edx)
    assert(UINT32_ROUND_UP(0x2321) == 0x4000);
    assert(UINT32_ROUND_UP(0x2000) == 0x2000);
    assert(UINT32_ROUND_DOWN(0x4321) == 0x4000);
    assert(UINT32_ROUND_DOWN(0x4000) == 0x4000);

}
c010887c:	90                   	nop
c010887d:	c9                   	leave  
c010887e:	c3                   	ret    

c010887f <size_check>:

static void
size_check(void) {
c010887f:	f3 0f 1e fb          	endbr32 
c0108883:	55                   	push   %ebp
c0108884:	89 e5                	mov    %esp,%ebp
c0108886:	83 ec 28             	sub    $0x28,%esp

    size_t buddy_physical_size_store = buddy_physical_size;
c0108889:	a1 0c 3f 12 c0       	mov    0xc0123f0c,%eax
c010888e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    buddy_init_size(200);
c0108891:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
c0108898:	e8 0c d0 ff ff       	call   c01058a9 <buddy_init_size>
    assert(buddy_virtual_size == 256);
c010889d:	a1 10 3f 12 c0       	mov    0xc0123f10,%eax
c01088a2:	3d 00 01 00 00       	cmp    $0x100,%eax
c01088a7:	74 24                	je     c01088cd <size_check+0x4e>
c01088a9:	c7 44 24 0c a0 b3 10 	movl   $0xc010b3a0,0xc(%esp)
c01088b0:	c0 
c01088b1:	c7 44 24 08 be b2 10 	movl   $0xc010b2be,0x8(%esp)
c01088b8:	c0 
c01088b9:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
c01088c0:	00 
c01088c1:	c7 04 24 d3 b2 10 c0 	movl   $0xc010b2d3,(%esp)
c01088c8:	e8 69 7b ff ff       	call   c0100436 <__panic>
    buddy_init_size(1024);
c01088cd:	c7 04 24 00 04 00 00 	movl   $0x400,(%esp)
c01088d4:	e8 d0 cf ff ff       	call   c01058a9 <buddy_init_size>
    assert(buddy_virtual_size == 1024);
c01088d9:	a1 10 3f 12 c0       	mov    0xc0123f10,%eax
c01088de:	3d 00 04 00 00       	cmp    $0x400,%eax
c01088e3:	74 24                	je     c0108909 <size_check+0x8a>
c01088e5:	c7 44 24 0c ba b3 10 	movl   $0xc010b3ba,0xc(%esp)
c01088ec:	c0 
c01088ed:	c7 44 24 08 be b2 10 	movl   $0xc010b2be,0x8(%esp)
c01088f4:	c0 
c01088f5:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
c01088fc:	00 
c01088fd:	c7 04 24 d3 b2 10 c0 	movl   $0xc010b2d3,(%esp)
c0108904:	e8 2d 7b ff ff       	call   c0100436 <__panic>
    buddy_init_size(1026);
c0108909:	c7 04 24 02 04 00 00 	movl   $0x402,(%esp)
c0108910:	e8 94 cf ff ff       	call   c01058a9 <buddy_init_size>
    assert(buddy_virtual_size == 1024);
c0108915:	a1 10 3f 12 c0       	mov    0xc0123f10,%eax
c010891a:	3d 00 04 00 00       	cmp    $0x400,%eax
c010891f:	74 24                	je     c0108945 <size_check+0xc6>
c0108921:	c7 44 24 0c ba b3 10 	movl   $0xc010b3ba,0xc(%esp)
c0108928:	c0 
c0108929:	c7 44 24 08 be b2 10 	movl   $0xc010b2be,0x8(%esp)
c0108930:	c0 
c0108931:	c7 44 24 04 fc 00 00 	movl   $0xfc,0x4(%esp)
c0108938:	00 
c0108939:	c7 04 24 d3 b2 10 c0 	movl   $0xc010b2d3,(%esp)
c0108940:	e8 f1 7a ff ff       	call   c0100436 <__panic>
    buddy_init_size(1028);    
c0108945:	c7 04 24 04 04 00 00 	movl   $0x404,(%esp)
c010894c:	e8 58 cf ff ff       	call   c01058a9 <buddy_init_size>
    assert(buddy_virtual_size == 1024);
c0108951:	a1 10 3f 12 c0       	mov    0xc0123f10,%eax
c0108956:	3d 00 04 00 00       	cmp    $0x400,%eax
c010895b:	74 24                	je     c0108981 <size_check+0x102>
c010895d:	c7 44 24 0c ba b3 10 	movl   $0xc010b3ba,0xc(%esp)
c0108964:	c0 
c0108965:	c7 44 24 08 be b2 10 	movl   $0xc010b2be,0x8(%esp)
c010896c:	c0 
c010896d:	c7 44 24 04 fe 00 00 	movl   $0xfe,0x4(%esp)
c0108974:	00 
c0108975:	c7 04 24 d3 b2 10 c0 	movl   $0xc010b2d3,(%esp)
c010897c:	e8 b5 7a ff ff       	call   c0100436 <__panic>
    buddy_init_size(1030);    
c0108981:	c7 04 24 06 04 00 00 	movl   $0x406,(%esp)
c0108988:	e8 1c cf ff ff       	call   c01058a9 <buddy_init_size>
    assert(buddy_virtual_size == 2048);
c010898d:	a1 10 3f 12 c0       	mov    0xc0123f10,%eax
c0108992:	3d 00 08 00 00       	cmp    $0x800,%eax
c0108997:	74 24                	je     c01089bd <size_check+0x13e>
c0108999:	c7 44 24 0c d5 b3 10 	movl   $0xc010b3d5,0xc(%esp)
c01089a0:	c0 
c01089a1:	c7 44 24 08 be b2 10 	movl   $0xc010b2be,0x8(%esp)
c01089a8:	c0 
c01089a9:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
c01089b0:	00 
c01089b1:	c7 04 24 d3 b2 10 c0 	movl   $0xc010b2d3,(%esp)
c01089b8:	e8 79 7a ff ff       	call   c0100436 <__panic>
    buddy_init_size(buddy_physical_size_store);   
c01089bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01089c0:	89 04 24             	mov    %eax,(%esp)
c01089c3:	e8 e1 ce ff ff       	call   c01058a9 <buddy_init_size>

}
c01089c8:	90                   	nop
c01089c9:	c9                   	leave  
c01089ca:	c3                   	ret    

c01089cb <segment_check>:

static void
segment_check(void) {
c01089cb:	f3 0f 1e fb          	endbr32 
c01089cf:	55                   	push   %ebp
c01089d0:	89 e5                	mov    %esp,%ebp
c01089d2:	57                   	push   %edi
c01089d3:	56                   	push   %esi
c01089d4:	53                   	push   %ebx
c01089d5:	83 ec 4c             	sub    $0x4c,%esp

    // Check buddy segment
    size_t total = 0, count = 0;
c01089d8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c01089df:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
    for (size_t block = BUDDY_ROOT; block < (buddy_virtual_size<<1); block++)
c01089e6:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
c01089ed:	e9 2e 04 00 00       	jmp    c0108e20 <segment_check+0x455>
        if (BUDDY_EMPTY(block))
c01089f2:	a1 1c 3f 12 c0       	mov    0xc0123f1c,%eax
c01089f7:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01089fa:	c1 e2 02             	shl    $0x2,%edx
c01089fd:	01 d0                	add    %edx,%eax
c01089ff:	8b 00                	mov    (%eax),%eax
c0108a01:	89 45 c4             	mov    %eax,-0x3c(%ebp)
c0108a04:	8b 3d 10 3f 12 c0    	mov    0xc0123f10,%edi
c0108a0a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108a0d:	d1 e8                	shr    %eax
c0108a0f:	0b 45 dc             	or     -0x24(%ebp),%eax
c0108a12:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0108a15:	d1 ea                	shr    %edx
c0108a17:	0b 55 dc             	or     -0x24(%ebp),%edx
c0108a1a:	c1 ea 02             	shr    $0x2,%edx
c0108a1d:	09 d0                	or     %edx,%eax
c0108a1f:	89 c1                	mov    %eax,%ecx
c0108a21:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108a24:	d1 e8                	shr    %eax
c0108a26:	0b 45 dc             	or     -0x24(%ebp),%eax
c0108a29:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0108a2c:	d1 ea                	shr    %edx
c0108a2e:	0b 55 dc             	or     -0x24(%ebp),%edx
c0108a31:	c1 ea 02             	shr    $0x2,%edx
c0108a34:	09 d0                	or     %edx,%eax
c0108a36:	c1 e8 04             	shr    $0x4,%eax
c0108a39:	09 c1                	or     %eax,%ecx
c0108a3b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108a3e:	d1 e8                	shr    %eax
c0108a40:	0b 45 dc             	or     -0x24(%ebp),%eax
c0108a43:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0108a46:	d1 ea                	shr    %edx
c0108a48:	0b 55 dc             	or     -0x24(%ebp),%edx
c0108a4b:	c1 ea 02             	shr    $0x2,%edx
c0108a4e:	09 d0                	or     %edx,%eax
c0108a50:	89 c3                	mov    %eax,%ebx
c0108a52:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108a55:	d1 e8                	shr    %eax
c0108a57:	0b 45 dc             	or     -0x24(%ebp),%eax
c0108a5a:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0108a5d:	d1 ea                	shr    %edx
c0108a5f:	0b 55 dc             	or     -0x24(%ebp),%edx
c0108a62:	c1 ea 02             	shr    $0x2,%edx
c0108a65:	09 d0                	or     %edx,%eax
c0108a67:	c1 e8 04             	shr    $0x4,%eax
c0108a6a:	09 d8                	or     %ebx,%eax
c0108a6c:	c1 e8 08             	shr    $0x8,%eax
c0108a6f:	89 cb                	mov    %ecx,%ebx
c0108a71:	09 c3                	or     %eax,%ebx
c0108a73:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108a76:	d1 e8                	shr    %eax
c0108a78:	0b 45 dc             	or     -0x24(%ebp),%eax
c0108a7b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0108a7e:	d1 ea                	shr    %edx
c0108a80:	0b 55 dc             	or     -0x24(%ebp),%edx
c0108a83:	c1 ea 02             	shr    $0x2,%edx
c0108a86:	09 d0                	or     %edx,%eax
c0108a88:	89 c1                	mov    %eax,%ecx
c0108a8a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108a8d:	d1 e8                	shr    %eax
c0108a8f:	0b 45 dc             	or     -0x24(%ebp),%eax
c0108a92:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0108a95:	d1 ea                	shr    %edx
c0108a97:	0b 55 dc             	or     -0x24(%ebp),%edx
c0108a9a:	c1 ea 02             	shr    $0x2,%edx
c0108a9d:	09 d0                	or     %edx,%eax
c0108a9f:	c1 e8 04             	shr    $0x4,%eax
c0108aa2:	09 c1                	or     %eax,%ecx
c0108aa4:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108aa7:	d1 e8                	shr    %eax
c0108aa9:	0b 45 dc             	or     -0x24(%ebp),%eax
c0108aac:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0108aaf:	d1 ea                	shr    %edx
c0108ab1:	0b 55 dc             	or     -0x24(%ebp),%edx
c0108ab4:	c1 ea 02             	shr    $0x2,%edx
c0108ab7:	09 d0                	or     %edx,%eax
c0108ab9:	89 c6                	mov    %eax,%esi
c0108abb:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108abe:	d1 e8                	shr    %eax
c0108ac0:	0b 45 dc             	or     -0x24(%ebp),%eax
c0108ac3:	89 c2                	mov    %eax,%edx
c0108ac5:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108ac8:	d1 e8                	shr    %eax
c0108aca:	0b 45 dc             	or     -0x24(%ebp),%eax
c0108acd:	c1 e8 02             	shr    $0x2,%eax
c0108ad0:	09 d0                	or     %edx,%eax
c0108ad2:	c1 e8 04             	shr    $0x4,%eax
c0108ad5:	09 f0                	or     %esi,%eax
c0108ad7:	c1 e8 08             	shr    $0x8,%eax
c0108ada:	09 c8                	or     %ecx,%eax
c0108adc:	c1 e8 10             	shr    $0x10,%eax
c0108adf:	09 d8                	or     %ebx,%eax
c0108ae1:	d1 e8                	shr    %eax
c0108ae3:	23 45 dc             	and    -0x24(%ebp),%eax
c0108ae6:	85 c0                	test   %eax,%eax
c0108ae8:	0f 84 e2 00 00 00    	je     c0108bd0 <segment_check+0x205>
c0108aee:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108af1:	d1 e8                	shr    %eax
c0108af3:	0b 45 dc             	or     -0x24(%ebp),%eax
c0108af6:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0108af9:	d1 ea                	shr    %edx
c0108afb:	0b 55 dc             	or     -0x24(%ebp),%edx
c0108afe:	c1 ea 02             	shr    $0x2,%edx
c0108b01:	09 d0                	or     %edx,%eax
c0108b03:	89 c1                	mov    %eax,%ecx
c0108b05:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108b08:	d1 e8                	shr    %eax
c0108b0a:	0b 45 dc             	or     -0x24(%ebp),%eax
c0108b0d:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0108b10:	d1 ea                	shr    %edx
c0108b12:	0b 55 dc             	or     -0x24(%ebp),%edx
c0108b15:	c1 ea 02             	shr    $0x2,%edx
c0108b18:	09 d0                	or     %edx,%eax
c0108b1a:	c1 e8 04             	shr    $0x4,%eax
c0108b1d:	09 c1                	or     %eax,%ecx
c0108b1f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108b22:	d1 e8                	shr    %eax
c0108b24:	0b 45 dc             	or     -0x24(%ebp),%eax
c0108b27:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0108b2a:	d1 ea                	shr    %edx
c0108b2c:	0b 55 dc             	or     -0x24(%ebp),%edx
c0108b2f:	c1 ea 02             	shr    $0x2,%edx
c0108b32:	09 d0                	or     %edx,%eax
c0108b34:	89 c3                	mov    %eax,%ebx
c0108b36:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108b39:	d1 e8                	shr    %eax
c0108b3b:	0b 45 dc             	or     -0x24(%ebp),%eax
c0108b3e:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0108b41:	d1 ea                	shr    %edx
c0108b43:	0b 55 dc             	or     -0x24(%ebp),%edx
c0108b46:	c1 ea 02             	shr    $0x2,%edx
c0108b49:	09 d0                	or     %edx,%eax
c0108b4b:	c1 e8 04             	shr    $0x4,%eax
c0108b4e:	09 d8                	or     %ebx,%eax
c0108b50:	c1 e8 08             	shr    $0x8,%eax
c0108b53:	89 cb                	mov    %ecx,%ebx
c0108b55:	09 c3                	or     %eax,%ebx
c0108b57:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108b5a:	d1 e8                	shr    %eax
c0108b5c:	0b 45 dc             	or     -0x24(%ebp),%eax
c0108b5f:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0108b62:	d1 ea                	shr    %edx
c0108b64:	0b 55 dc             	or     -0x24(%ebp),%edx
c0108b67:	c1 ea 02             	shr    $0x2,%edx
c0108b6a:	09 d0                	or     %edx,%eax
c0108b6c:	89 c1                	mov    %eax,%ecx
c0108b6e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108b71:	d1 e8                	shr    %eax
c0108b73:	0b 45 dc             	or     -0x24(%ebp),%eax
c0108b76:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0108b79:	d1 ea                	shr    %edx
c0108b7b:	0b 55 dc             	or     -0x24(%ebp),%edx
c0108b7e:	c1 ea 02             	shr    $0x2,%edx
c0108b81:	09 d0                	or     %edx,%eax
c0108b83:	c1 e8 04             	shr    $0x4,%eax
c0108b86:	09 c1                	or     %eax,%ecx
c0108b88:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108b8b:	d1 e8                	shr    %eax
c0108b8d:	0b 45 dc             	or     -0x24(%ebp),%eax
c0108b90:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0108b93:	d1 ea                	shr    %edx
c0108b95:	0b 55 dc             	or     -0x24(%ebp),%edx
c0108b98:	c1 ea 02             	shr    $0x2,%edx
c0108b9b:	09 d0                	or     %edx,%eax
c0108b9d:	89 c6                	mov    %eax,%esi
c0108b9f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108ba2:	d1 e8                	shr    %eax
c0108ba4:	0b 45 dc             	or     -0x24(%ebp),%eax
c0108ba7:	89 c2                	mov    %eax,%edx
c0108ba9:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108bac:	d1 e8                	shr    %eax
c0108bae:	0b 45 dc             	or     -0x24(%ebp),%eax
c0108bb1:	c1 e8 02             	shr    $0x2,%eax
c0108bb4:	09 d0                	or     %edx,%eax
c0108bb6:	c1 e8 04             	shr    $0x4,%eax
c0108bb9:	09 f0                	or     %esi,%eax
c0108bbb:	c1 e8 08             	shr    $0x8,%eax
c0108bbe:	09 c8                	or     %ecx,%eax
c0108bc0:	c1 e8 10             	shr    $0x10,%eax
c0108bc3:	09 d8                	or     %ebx,%eax
c0108bc5:	d1 e8                	shr    %eax
c0108bc7:	f7 d0                	not    %eax
c0108bc9:	23 45 dc             	and    -0x24(%ebp),%eax
c0108bcc:	89 c6                	mov    %eax,%esi
c0108bce:	eb 03                	jmp    c0108bd3 <segment_check+0x208>
c0108bd0:	8b 75 dc             	mov    -0x24(%ebp),%esi
c0108bd3:	89 f8                	mov    %edi,%eax
c0108bd5:	ba 00 00 00 00       	mov    $0x0,%edx
c0108bda:	f7 f6                	div    %esi
c0108bdc:	39 45 c4             	cmp    %eax,-0x3c(%ebp)
c0108bdf:	0f 85 d2 01 00 00    	jne    c0108db7 <segment_check+0x3ec>
            total += BUDDY_LENGTH(block);
c0108be5:	a1 10 3f 12 c0       	mov    0xc0123f10,%eax
c0108bea:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0108bed:	d1 ea                	shr    %edx
c0108bef:	0b 55 dc             	or     -0x24(%ebp),%edx
c0108bf2:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0108bf5:	d1 e9                	shr    %ecx
c0108bf7:	0b 4d dc             	or     -0x24(%ebp),%ecx
c0108bfa:	c1 e9 02             	shr    $0x2,%ecx
c0108bfd:	89 d3                	mov    %edx,%ebx
c0108bff:	09 cb                	or     %ecx,%ebx
c0108c01:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0108c04:	d1 ea                	shr    %edx
c0108c06:	0b 55 dc             	or     -0x24(%ebp),%edx
c0108c09:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0108c0c:	d1 e9                	shr    %ecx
c0108c0e:	0b 4d dc             	or     -0x24(%ebp),%ecx
c0108c11:	c1 e9 02             	shr    $0x2,%ecx
c0108c14:	09 ca                	or     %ecx,%edx
c0108c16:	c1 ea 04             	shr    $0x4,%edx
c0108c19:	09 d3                	or     %edx,%ebx
c0108c1b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0108c1e:	d1 ea                	shr    %edx
c0108c20:	0b 55 dc             	or     -0x24(%ebp),%edx
c0108c23:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0108c26:	d1 e9                	shr    %ecx
c0108c28:	0b 4d dc             	or     -0x24(%ebp),%ecx
c0108c2b:	c1 e9 02             	shr    $0x2,%ecx
c0108c2e:	89 d6                	mov    %edx,%esi
c0108c30:	09 ce                	or     %ecx,%esi
c0108c32:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0108c35:	d1 ea                	shr    %edx
c0108c37:	0b 55 dc             	or     -0x24(%ebp),%edx
c0108c3a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0108c3d:	d1 e9                	shr    %ecx
c0108c3f:	0b 4d dc             	or     -0x24(%ebp),%ecx
c0108c42:	c1 e9 02             	shr    $0x2,%ecx
c0108c45:	09 ca                	or     %ecx,%edx
c0108c47:	c1 ea 04             	shr    $0x4,%edx
c0108c4a:	09 f2                	or     %esi,%edx
c0108c4c:	c1 ea 08             	shr    $0x8,%edx
c0108c4f:	09 d3                	or     %edx,%ebx
c0108c51:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0108c54:	d1 ea                	shr    %edx
c0108c56:	0b 55 dc             	or     -0x24(%ebp),%edx
c0108c59:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0108c5c:	d1 e9                	shr    %ecx
c0108c5e:	0b 4d dc             	or     -0x24(%ebp),%ecx
c0108c61:	c1 e9 02             	shr    $0x2,%ecx
c0108c64:	89 d6                	mov    %edx,%esi
c0108c66:	09 ce                	or     %ecx,%esi
c0108c68:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0108c6b:	d1 ea                	shr    %edx
c0108c6d:	0b 55 dc             	or     -0x24(%ebp),%edx
c0108c70:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0108c73:	d1 e9                	shr    %ecx
c0108c75:	0b 4d dc             	or     -0x24(%ebp),%ecx
c0108c78:	c1 e9 02             	shr    $0x2,%ecx
c0108c7b:	09 ca                	or     %ecx,%edx
c0108c7d:	c1 ea 04             	shr    $0x4,%edx
c0108c80:	09 d6                	or     %edx,%esi
c0108c82:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0108c85:	d1 ea                	shr    %edx
c0108c87:	0b 55 dc             	or     -0x24(%ebp),%edx
c0108c8a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0108c8d:	d1 e9                	shr    %ecx
c0108c8f:	0b 4d dc             	or     -0x24(%ebp),%ecx
c0108c92:	c1 e9 02             	shr    $0x2,%ecx
c0108c95:	89 d7                	mov    %edx,%edi
c0108c97:	09 cf                	or     %ecx,%edi
c0108c99:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0108c9c:	d1 ea                	shr    %edx
c0108c9e:	0b 55 dc             	or     -0x24(%ebp),%edx
c0108ca1:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0108ca4:	d1 e9                	shr    %ecx
c0108ca6:	0b 4d dc             	or     -0x24(%ebp),%ecx
c0108ca9:	c1 e9 02             	shr    $0x2,%ecx
c0108cac:	09 ca                	or     %ecx,%edx
c0108cae:	c1 ea 04             	shr    $0x4,%edx
c0108cb1:	09 fa                	or     %edi,%edx
c0108cb3:	c1 ea 08             	shr    $0x8,%edx
c0108cb6:	09 f2                	or     %esi,%edx
c0108cb8:	c1 ea 10             	shr    $0x10,%edx
c0108cbb:	09 da                	or     %ebx,%edx
c0108cbd:	d1 ea                	shr    %edx
c0108cbf:	23 55 dc             	and    -0x24(%ebp),%edx
c0108cc2:	85 d2                	test   %edx,%edx
c0108cc4:	0f 84 de 00 00 00    	je     c0108da8 <segment_check+0x3dd>
c0108cca:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0108ccd:	d1 ea                	shr    %edx
c0108ccf:	0b 55 dc             	or     -0x24(%ebp),%edx
c0108cd2:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0108cd5:	d1 e9                	shr    %ecx
c0108cd7:	0b 4d dc             	or     -0x24(%ebp),%ecx
c0108cda:	c1 e9 02             	shr    $0x2,%ecx
c0108cdd:	89 d3                	mov    %edx,%ebx
c0108cdf:	09 cb                	or     %ecx,%ebx
c0108ce1:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0108ce4:	d1 ea                	shr    %edx
c0108ce6:	0b 55 dc             	or     -0x24(%ebp),%edx
c0108ce9:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0108cec:	d1 e9                	shr    %ecx
c0108cee:	0b 4d dc             	or     -0x24(%ebp),%ecx
c0108cf1:	c1 e9 02             	shr    $0x2,%ecx
c0108cf4:	09 ca                	or     %ecx,%edx
c0108cf6:	c1 ea 04             	shr    $0x4,%edx
c0108cf9:	09 d3                	or     %edx,%ebx
c0108cfb:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0108cfe:	d1 ea                	shr    %edx
c0108d00:	0b 55 dc             	or     -0x24(%ebp),%edx
c0108d03:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0108d06:	d1 e9                	shr    %ecx
c0108d08:	0b 4d dc             	or     -0x24(%ebp),%ecx
c0108d0b:	c1 e9 02             	shr    $0x2,%ecx
c0108d0e:	89 d6                	mov    %edx,%esi
c0108d10:	09 ce                	or     %ecx,%esi
c0108d12:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0108d15:	d1 ea                	shr    %edx
c0108d17:	0b 55 dc             	or     -0x24(%ebp),%edx
c0108d1a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0108d1d:	d1 e9                	shr    %ecx
c0108d1f:	0b 4d dc             	or     -0x24(%ebp),%ecx
c0108d22:	c1 e9 02             	shr    $0x2,%ecx
c0108d25:	09 ca                	or     %ecx,%edx
c0108d27:	c1 ea 04             	shr    $0x4,%edx
c0108d2a:	09 f2                	or     %esi,%edx
c0108d2c:	c1 ea 08             	shr    $0x8,%edx
c0108d2f:	09 d3                	or     %edx,%ebx
c0108d31:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0108d34:	d1 ea                	shr    %edx
c0108d36:	0b 55 dc             	or     -0x24(%ebp),%edx
c0108d39:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0108d3c:	d1 e9                	shr    %ecx
c0108d3e:	0b 4d dc             	or     -0x24(%ebp),%ecx
c0108d41:	c1 e9 02             	shr    $0x2,%ecx
c0108d44:	89 d6                	mov    %edx,%esi
c0108d46:	09 ce                	or     %ecx,%esi
c0108d48:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0108d4b:	d1 ea                	shr    %edx
c0108d4d:	0b 55 dc             	or     -0x24(%ebp),%edx
c0108d50:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0108d53:	d1 e9                	shr    %ecx
c0108d55:	0b 4d dc             	or     -0x24(%ebp),%ecx
c0108d58:	c1 e9 02             	shr    $0x2,%ecx
c0108d5b:	09 ca                	or     %ecx,%edx
c0108d5d:	c1 ea 04             	shr    $0x4,%edx
c0108d60:	09 d6                	or     %edx,%esi
c0108d62:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0108d65:	d1 ea                	shr    %edx
c0108d67:	0b 55 dc             	or     -0x24(%ebp),%edx
c0108d6a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0108d6d:	d1 e9                	shr    %ecx
c0108d6f:	0b 4d dc             	or     -0x24(%ebp),%ecx
c0108d72:	c1 e9 02             	shr    $0x2,%ecx
c0108d75:	89 d7                	mov    %edx,%edi
c0108d77:	09 cf                	or     %ecx,%edi
c0108d79:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0108d7c:	d1 ea                	shr    %edx
c0108d7e:	0b 55 dc             	or     -0x24(%ebp),%edx
c0108d81:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0108d84:	d1 e9                	shr    %ecx
c0108d86:	0b 4d dc             	or     -0x24(%ebp),%ecx
c0108d89:	c1 e9 02             	shr    $0x2,%ecx
c0108d8c:	09 ca                	or     %ecx,%edx
c0108d8e:	c1 ea 04             	shr    $0x4,%edx
c0108d91:	09 fa                	or     %edi,%edx
c0108d93:	c1 ea 08             	shr    $0x8,%edx
c0108d96:	09 f2                	or     %esi,%edx
c0108d98:	c1 ea 10             	shr    $0x10,%edx
c0108d9b:	09 da                	or     %ebx,%edx
c0108d9d:	d1 ea                	shr    %edx
c0108d9f:	f7 d2                	not    %edx
c0108da1:	89 d7                	mov    %edx,%edi
c0108da3:	23 7d dc             	and    -0x24(%ebp),%edi
c0108da6:	eb 03                	jmp    c0108dab <segment_check+0x3e0>
c0108da8:	8b 7d dc             	mov    -0x24(%ebp),%edi
c0108dab:	ba 00 00 00 00       	mov    $0x0,%edx
c0108db0:	f7 f7                	div    %edi
c0108db2:	01 45 e4             	add    %eax,-0x1c(%ebp)
c0108db5:	eb 66                	jmp    c0108e1d <segment_check+0x452>
        else if (block < buddy_virtual_size)
c0108db7:	a1 10 3f 12 c0       	mov    0xc0123f10,%eax
c0108dbc:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0108dbf:	73 5c                	jae    c0108e1d <segment_check+0x452>
            assert(buddy_segment[block] == (buddy_segment[BUDDY_LEFT(block)] | buddy_segment[BUDDY_RIGHT(block)]));
c0108dc1:	a1 1c 3f 12 c0       	mov    0xc0123f1c,%eax
c0108dc6:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0108dc9:	c1 e2 02             	shl    $0x2,%edx
c0108dcc:	01 d0                	add    %edx,%eax
c0108dce:	8b 00                	mov    (%eax),%eax
c0108dd0:	8b 15 1c 3f 12 c0    	mov    0xc0123f1c,%edx
c0108dd6:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0108dd9:	c1 e1 03             	shl    $0x3,%ecx
c0108ddc:	01 ca                	add    %ecx,%edx
c0108dde:	8b 0a                	mov    (%edx),%ecx
c0108de0:	8b 15 1c 3f 12 c0    	mov    0xc0123f1c,%edx
c0108de6:	8b 5d dc             	mov    -0x24(%ebp),%ebx
c0108de9:	c1 e3 03             	shl    $0x3,%ebx
c0108dec:	83 c3 04             	add    $0x4,%ebx
c0108def:	01 da                	add    %ebx,%edx
c0108df1:	8b 12                	mov    (%edx),%edx
c0108df3:	09 ca                	or     %ecx,%edx
c0108df5:	39 d0                	cmp    %edx,%eax
c0108df7:	74 24                	je     c0108e1d <segment_check+0x452>
c0108df9:	c7 44 24 0c f0 b3 10 	movl   $0xc010b3f0,0xc(%esp)
c0108e00:	c0 
c0108e01:	c7 44 24 08 be b2 10 	movl   $0xc010b2be,0x8(%esp)
c0108e08:	c0 
c0108e09:	c7 44 24 04 0e 01 00 	movl   $0x10e,0x4(%esp)
c0108e10:	00 
c0108e11:	c7 04 24 d3 b2 10 c0 	movl   $0xc010b2d3,(%esp)
c0108e18:	e8 19 76 ff ff       	call   c0100436 <__panic>
    for (size_t block = BUDDY_ROOT; block < (buddy_virtual_size<<1); block++)
c0108e1d:	ff 45 dc             	incl   -0x24(%ebp)
c0108e20:	a1 10 3f 12 c0       	mov    0xc0123f10,%eax
c0108e25:	01 c0                	add    %eax,%eax
c0108e27:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0108e2a:	0f 82 c2 fb ff ff    	jb     c01089f2 <segment_check+0x27>
    assert(total == nr_free_pages());
c0108e30:	e8 54 a1 ff ff       	call   c0102f89 <nr_free_pages>
c0108e35:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0108e38:	74 24                	je     c0108e5e <segment_check+0x493>
c0108e3a:	c7 44 24 0c 4f b4 10 	movl   $0xc010b44f,0xc(%esp)
c0108e41:	c0 
c0108e42:	c7 44 24 08 be b2 10 	movl   $0xc010b2be,0x8(%esp)
c0108e49:	c0 
c0108e4a:	c7 44 24 04 0f 01 00 	movl   $0x10f,0x4(%esp)
c0108e51:	00 
c0108e52:	c7 04 24 d3 b2 10 c0 	movl   $0xc010b2d3,(%esp)
c0108e59:	e8 d8 75 ff ff       	call   c0100436 <__panic>

    // Check free list 
    total = 0, count = 0;
c0108e5e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c0108e65:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
    list_entry_t *le = &free_list;
c0108e6c:	c7 45 d8 38 3f 12 c0 	movl   $0xc0123f38,-0x28(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0108e73:	eb 15                	jmp    c0108e8a <segment_check+0x4bf>
        struct Page *p = le2page(le, page_link);
c0108e75:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0108e78:	83 e8 0c             	sub    $0xc,%eax
c0108e7b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count ++, total += p->property;
c0108e7e:	ff 45 e0             	incl   -0x20(%ebp)
c0108e81:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0108e84:	8b 40 08             	mov    0x8(%eax),%eax
c0108e87:	01 45 e4             	add    %eax,-0x1c(%ebp)
c0108e8a:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0108e8d:	89 45 d0             	mov    %eax,-0x30(%ebp)
    return listelm->next;
c0108e90:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0108e93:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c0108e96:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0108e99:	81 7d d8 38 3f 12 c0 	cmpl   $0xc0123f38,-0x28(%ebp)
c0108ea0:	75 d3                	jne    c0108e75 <segment_check+0x4aa>
    }
    assert(total == nr_free_pages());
c0108ea2:	e8 e2 a0 ff ff       	call   c0102f89 <nr_free_pages>
c0108ea7:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0108eaa:	74 24                	je     c0108ed0 <segment_check+0x505>
c0108eac:	c7 44 24 0c 4f b4 10 	movl   $0xc010b44f,0xc(%esp)
c0108eb3:	c0 
c0108eb4:	c7 44 24 08 be b2 10 	movl   $0xc010b2be,0x8(%esp)
c0108ebb:	c0 
c0108ebc:	c7 44 24 04 18 01 00 	movl   $0x118,0x4(%esp)
c0108ec3:	00 
c0108ec4:	c7 04 24 d3 b2 10 c0 	movl   $0xc010b2d3,(%esp)
c0108ecb:	e8 66 75 ff ff       	call   c0100436 <__panic>

}
c0108ed0:	90                   	nop
c0108ed1:	83 c4 4c             	add    $0x4c,%esp
c0108ed4:	5b                   	pop    %ebx
c0108ed5:	5e                   	pop    %esi
c0108ed6:	5f                   	pop    %edi
c0108ed7:	5d                   	pop    %ebp
c0108ed8:	c3                   	ret    

c0108ed9 <alloc_check>:

static void
alloc_check(void) {
c0108ed9:	f3 0f 1e fb          	endbr32 
c0108edd:	55                   	push   %ebp
c0108ede:	89 e5                	mov    %esp,%ebp
c0108ee0:	83 ec 58             	sub    $0x58,%esp

    // Build buddy system for test
    size_t buddy_physical_size_store = buddy_physical_size;
c0108ee3:	a1 0c 3f 12 c0       	mov    0xc0123f0c,%eax
c0108ee8:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for (struct Page *p = buddy_physical; p < buddy_physical + 1026; p++)
c0108eeb:	a1 20 3f 12 c0       	mov    0xc0123f20,%eax
c0108ef0:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108ef3:	eb 1e                	jmp    c0108f13 <alloc_check+0x3a>
        SetPageReserved(p);
c0108ef5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108ef8:	83 c0 04             	add    $0x4,%eax
c0108efb:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
c0108f02:	89 45 c8             	mov    %eax,-0x38(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0108f05:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0108f08:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0108f0b:	0f ab 10             	bts    %edx,(%eax)
}
c0108f0e:	90                   	nop
    for (struct Page *p = buddy_physical; p < buddy_physical + 1026; p++)
c0108f0f:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0108f13:	a1 20 3f 12 c0       	mov    0xc0123f20,%eax
c0108f18:	05 28 50 00 00       	add    $0x5028,%eax
c0108f1d:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0108f20:	72 d3                	jb     c0108ef5 <alloc_check+0x1c>
    buddy_init();
c0108f22:	e8 91 d6 ff ff       	call   c01065b8 <buddy_init>
    buddy_init_memmap(buddy_physical, 1026);
c0108f27:	a1 20 3f 12 c0       	mov    0xc0123f20,%eax
c0108f2c:	c7 44 24 04 02 04 00 	movl   $0x402,0x4(%esp)
c0108f33:	00 
c0108f34:	89 04 24             	mov    %eax,(%esp)
c0108f37:	e8 af d6 ff ff       	call   c01065eb <buddy_init_memmap>

    // Check allocation
    struct Page *p0, *p1, *p2, *p3;
    p0 = p1 = p2 = NULL;
c0108f3c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c0108f43:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108f46:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0108f49:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108f4c:	89 45 dc             	mov    %eax,-0x24(%ebp)
    assert((p0 = alloc_page()) != NULL);
c0108f4f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0108f56:	e8 bb 9f ff ff       	call   c0102f16 <alloc_pages>
c0108f5b:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0108f5e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0108f62:	75 24                	jne    c0108f88 <alloc_check+0xaf>
c0108f64:	c7 44 24 0c 68 b4 10 	movl   $0xc010b468,0xc(%esp)
c0108f6b:	c0 
c0108f6c:	c7 44 24 08 be b2 10 	movl   $0xc010b2be,0x8(%esp)
c0108f73:	c0 
c0108f74:	c7 44 24 04 29 01 00 	movl   $0x129,0x4(%esp)
c0108f7b:	00 
c0108f7c:	c7 04 24 d3 b2 10 c0 	movl   $0xc010b2d3,(%esp)
c0108f83:	e8 ae 74 ff ff       	call   c0100436 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0108f88:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0108f8f:	e8 82 9f ff ff       	call   c0102f16 <alloc_pages>
c0108f94:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0108f97:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0108f9b:	75 24                	jne    c0108fc1 <alloc_check+0xe8>
c0108f9d:	c7 44 24 0c 84 b4 10 	movl   $0xc010b484,0xc(%esp)
c0108fa4:	c0 
c0108fa5:	c7 44 24 08 be b2 10 	movl   $0xc010b2be,0x8(%esp)
c0108fac:	c0 
c0108fad:	c7 44 24 04 2a 01 00 	movl   $0x12a,0x4(%esp)
c0108fb4:	00 
c0108fb5:	c7 04 24 d3 b2 10 c0 	movl   $0xc010b2d3,(%esp)
c0108fbc:	e8 75 74 ff ff       	call   c0100436 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0108fc1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0108fc8:	e8 49 9f ff ff       	call   c0102f16 <alloc_pages>
c0108fcd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0108fd0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0108fd4:	75 24                	jne    c0108ffa <alloc_check+0x121>
c0108fd6:	c7 44 24 0c a0 b4 10 	movl   $0xc010b4a0,0xc(%esp)
c0108fdd:	c0 
c0108fde:	c7 44 24 08 be b2 10 	movl   $0xc010b2be,0x8(%esp)
c0108fe5:	c0 
c0108fe6:	c7 44 24 04 2b 01 00 	movl   $0x12b,0x4(%esp)
c0108fed:	00 
c0108fee:	c7 04 24 d3 b2 10 c0 	movl   $0xc010b2d3,(%esp)
c0108ff5:	e8 3c 74 ff ff       	call   c0100436 <__panic>
    assert((p3 = alloc_page()) != NULL);
c0108ffa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0109001:	e8 10 9f ff ff       	call   c0102f16 <alloc_pages>
c0109006:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0109009:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c010900d:	75 24                	jne    c0109033 <alloc_check+0x15a>
c010900f:	c7 44 24 0c bc b4 10 	movl   $0xc010b4bc,0xc(%esp)
c0109016:	c0 
c0109017:	c7 44 24 08 be b2 10 	movl   $0xc010b2be,0x8(%esp)
c010901e:	c0 
c010901f:	c7 44 24 04 2c 01 00 	movl   $0x12c,0x4(%esp)
c0109026:	00 
c0109027:	c7 04 24 d3 b2 10 c0 	movl   $0xc010b2d3,(%esp)
c010902e:	e8 03 74 ff ff       	call   c0100436 <__panic>

    assert(p0 + 1 == p1);
c0109033:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0109036:	83 c0 14             	add    $0x14,%eax
c0109039:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c010903c:	74 24                	je     c0109062 <alloc_check+0x189>
c010903e:	c7 44 24 0c d8 b4 10 	movl   $0xc010b4d8,0xc(%esp)
c0109045:	c0 
c0109046:	c7 44 24 08 be b2 10 	movl   $0xc010b2be,0x8(%esp)
c010904d:	c0 
c010904e:	c7 44 24 04 2e 01 00 	movl   $0x12e,0x4(%esp)
c0109055:	00 
c0109056:	c7 04 24 d3 b2 10 c0 	movl   $0xc010b2d3,(%esp)
c010905d:	e8 d4 73 ff ff       	call   c0100436 <__panic>
    assert(p1 + 1 == p2);
c0109062:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0109065:	83 c0 14             	add    $0x14,%eax
c0109068:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c010906b:	74 24                	je     c0109091 <alloc_check+0x1b8>
c010906d:	c7 44 24 0c e5 b4 10 	movl   $0xc010b4e5,0xc(%esp)
c0109074:	c0 
c0109075:	c7 44 24 08 be b2 10 	movl   $0xc010b2be,0x8(%esp)
c010907c:	c0 
c010907d:	c7 44 24 04 2f 01 00 	movl   $0x12f,0x4(%esp)
c0109084:	00 
c0109085:	c7 04 24 d3 b2 10 c0 	movl   $0xc010b2d3,(%esp)
c010908c:	e8 a5 73 ff ff       	call   c0100436 <__panic>
    assert(p2 + 1 == p3);
c0109091:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0109094:	83 c0 14             	add    $0x14,%eax
c0109097:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c010909a:	74 24                	je     c01090c0 <alloc_check+0x1e7>
c010909c:	c7 44 24 0c f2 b4 10 	movl   $0xc010b4f2,0xc(%esp)
c01090a3:	c0 
c01090a4:	c7 44 24 08 be b2 10 	movl   $0xc010b2be,0x8(%esp)
c01090ab:	c0 
c01090ac:	c7 44 24 04 30 01 00 	movl   $0x130,0x4(%esp)
c01090b3:	00 
c01090b4:	c7 04 24 d3 b2 10 c0 	movl   $0xc010b2d3,(%esp)
c01090bb:	e8 76 73 ff ff       	call   c0100436 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0 && page_ref(p3) == 0);
c01090c0:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01090c3:	89 04 24             	mov    %eax,(%esp)
c01090c6:	e8 c6 c7 ff ff       	call   c0105891 <page_ref>
c01090cb:	85 c0                	test   %eax,%eax
c01090cd:	75 2d                	jne    c01090fc <alloc_check+0x223>
c01090cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01090d2:	89 04 24             	mov    %eax,(%esp)
c01090d5:	e8 b7 c7 ff ff       	call   c0105891 <page_ref>
c01090da:	85 c0                	test   %eax,%eax
c01090dc:	75 1e                	jne    c01090fc <alloc_check+0x223>
c01090de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01090e1:	89 04 24             	mov    %eax,(%esp)
c01090e4:	e8 a8 c7 ff ff       	call   c0105891 <page_ref>
c01090e9:	85 c0                	test   %eax,%eax
c01090eb:	75 0f                	jne    c01090fc <alloc_check+0x223>
c01090ed:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01090f0:	89 04 24             	mov    %eax,(%esp)
c01090f3:	e8 99 c7 ff ff       	call   c0105891 <page_ref>
c01090f8:	85 c0                	test   %eax,%eax
c01090fa:	74 24                	je     c0109120 <alloc_check+0x247>
c01090fc:	c7 44 24 0c 00 b5 10 	movl   $0xc010b500,0xc(%esp)
c0109103:	c0 
c0109104:	c7 44 24 08 be b2 10 	movl   $0xc010b2be,0x8(%esp)
c010910b:	c0 
c010910c:	c7 44 24 04 31 01 00 	movl   $0x131,0x4(%esp)
c0109113:	00 
c0109114:	c7 04 24 d3 b2 10 c0 	movl   $0xc010b2d3,(%esp)
c010911b:	e8 16 73 ff ff       	call   c0100436 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c0109120:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0109123:	89 04 24             	mov    %eax,(%esp)
c0109126:	e8 50 c7 ff ff       	call   c010587b <page2pa>
c010912b:	8b 15 80 3e 12 c0    	mov    0xc0123e80,%edx
c0109131:	c1 e2 0c             	shl    $0xc,%edx
c0109134:	39 d0                	cmp    %edx,%eax
c0109136:	72 24                	jb     c010915c <alloc_check+0x283>
c0109138:	c7 44 24 0c 51 b5 10 	movl   $0xc010b551,0xc(%esp)
c010913f:	c0 
c0109140:	c7 44 24 08 be b2 10 	movl   $0xc010b2be,0x8(%esp)
c0109147:	c0 
c0109148:	c7 44 24 04 33 01 00 	movl   $0x133,0x4(%esp)
c010914f:	00 
c0109150:	c7 04 24 d3 b2 10 c0 	movl   $0xc010b2d3,(%esp)
c0109157:	e8 da 72 ff ff       	call   c0100436 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c010915c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010915f:	89 04 24             	mov    %eax,(%esp)
c0109162:	e8 14 c7 ff ff       	call   c010587b <page2pa>
c0109167:	8b 15 80 3e 12 c0    	mov    0xc0123e80,%edx
c010916d:	c1 e2 0c             	shl    $0xc,%edx
c0109170:	39 d0                	cmp    %edx,%eax
c0109172:	72 24                	jb     c0109198 <alloc_check+0x2bf>
c0109174:	c7 44 24 0c 6e b5 10 	movl   $0xc010b56e,0xc(%esp)
c010917b:	c0 
c010917c:	c7 44 24 08 be b2 10 	movl   $0xc010b2be,0x8(%esp)
c0109183:	c0 
c0109184:	c7 44 24 04 34 01 00 	movl   $0x134,0x4(%esp)
c010918b:	00 
c010918c:	c7 04 24 d3 b2 10 c0 	movl   $0xc010b2d3,(%esp)
c0109193:	e8 9e 72 ff ff       	call   c0100436 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c0109198:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010919b:	89 04 24             	mov    %eax,(%esp)
c010919e:	e8 d8 c6 ff ff       	call   c010587b <page2pa>
c01091a3:	8b 15 80 3e 12 c0    	mov    0xc0123e80,%edx
c01091a9:	c1 e2 0c             	shl    $0xc,%edx
c01091ac:	39 d0                	cmp    %edx,%eax
c01091ae:	72 24                	jb     c01091d4 <alloc_check+0x2fb>
c01091b0:	c7 44 24 0c 8b b5 10 	movl   $0xc010b58b,0xc(%esp)
c01091b7:	c0 
c01091b8:	c7 44 24 08 be b2 10 	movl   $0xc010b2be,0x8(%esp)
c01091bf:	c0 
c01091c0:	c7 44 24 04 35 01 00 	movl   $0x135,0x4(%esp)
c01091c7:	00 
c01091c8:	c7 04 24 d3 b2 10 c0 	movl   $0xc010b2d3,(%esp)
c01091cf:	e8 62 72 ff ff       	call   c0100436 <__panic>
    assert(page2pa(p3) < npage * PGSIZE);
c01091d4:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01091d7:	89 04 24             	mov    %eax,(%esp)
c01091da:	e8 9c c6 ff ff       	call   c010587b <page2pa>
c01091df:	8b 15 80 3e 12 c0    	mov    0xc0123e80,%edx
c01091e5:	c1 e2 0c             	shl    $0xc,%edx
c01091e8:	39 d0                	cmp    %edx,%eax
c01091ea:	72 24                	jb     c0109210 <alloc_check+0x337>
c01091ec:	c7 44 24 0c a8 b5 10 	movl   $0xc010b5a8,0xc(%esp)
c01091f3:	c0 
c01091f4:	c7 44 24 08 be b2 10 	movl   $0xc010b2be,0x8(%esp)
c01091fb:	c0 
c01091fc:	c7 44 24 04 36 01 00 	movl   $0x136,0x4(%esp)
c0109203:	00 
c0109204:	c7 04 24 d3 b2 10 c0 	movl   $0xc010b2d3,(%esp)
c010920b:	e8 26 72 ff ff       	call   c0100436 <__panic>

    list_entry_t *le = &free_list;
c0109210:	c7 45 f0 38 3f 12 c0 	movl   $0xc0123f38,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0109217:	eb 3f                	jmp    c0109258 <alloc_check+0x37f>
        struct Page *p = le2page(le, page_link);
c0109219:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010921c:	83 e8 0c             	sub    $0xc,%eax
c010921f:	89 45 d0             	mov    %eax,-0x30(%ebp)
        assert(buddy_alloc_pages(p->property) != NULL);
c0109222:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0109225:	8b 40 08             	mov    0x8(%eax),%eax
c0109228:	89 04 24             	mov    %eax,(%esp)
c010922b:	e8 aa d4 ff ff       	call   c01066da <buddy_alloc_pages>
c0109230:	85 c0                	test   %eax,%eax
c0109232:	75 24                	jne    c0109258 <alloc_check+0x37f>
c0109234:	c7 44 24 0c c8 b5 10 	movl   $0xc010b5c8,0xc(%esp)
c010923b:	c0 
c010923c:	c7 44 24 08 be b2 10 	movl   $0xc010b2be,0x8(%esp)
c0109243:	c0 
c0109244:	c7 44 24 04 3b 01 00 	movl   $0x13b,0x4(%esp)
c010924b:	00 
c010924c:	c7 04 24 d3 b2 10 c0 	movl   $0xc010b2d3,(%esp)
c0109253:	e8 de 71 ff ff       	call   c0100436 <__panic>
c0109258:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010925b:	89 45 c4             	mov    %eax,-0x3c(%ebp)
c010925e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0109261:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c0109264:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109267:	81 7d f0 38 3f 12 c0 	cmpl   $0xc0123f38,-0x10(%ebp)
c010926e:	75 a9                	jne    c0109219 <alloc_check+0x340>
    }

    assert(alloc_page() == NULL);
c0109270:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0109277:	e8 9a 9c ff ff       	call   c0102f16 <alloc_pages>
c010927c:	85 c0                	test   %eax,%eax
c010927e:	74 24                	je     c01092a4 <alloc_check+0x3cb>
c0109280:	c7 44 24 0c ef b5 10 	movl   $0xc010b5ef,0xc(%esp)
c0109287:	c0 
c0109288:	c7 44 24 08 be b2 10 	movl   $0xc010b2be,0x8(%esp)
c010928f:	c0 
c0109290:	c7 44 24 04 3e 01 00 	movl   $0x13e,0x4(%esp)
c0109297:	00 
c0109298:	c7 04 24 d3 b2 10 c0 	movl   $0xc010b2d3,(%esp)
c010929f:	e8 92 71 ff ff       	call   c0100436 <__panic>

    // Check release
    free_page(p0);
c01092a4:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01092ab:	00 
c01092ac:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01092af:	89 04 24             	mov    %eax,(%esp)
c01092b2:	e8 9b 9c ff ff       	call   c0102f52 <free_pages>
    free_page(p1);
c01092b7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01092be:	00 
c01092bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01092c2:	89 04 24             	mov    %eax,(%esp)
c01092c5:	e8 88 9c ff ff       	call   c0102f52 <free_pages>
    free_page(p2);
c01092ca:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01092d1:	00 
c01092d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01092d5:	89 04 24             	mov    %eax,(%esp)
c01092d8:	e8 75 9c ff ff       	call   c0102f52 <free_pages>
    assert(nr_free == 3);
c01092dd:	a1 40 3f 12 c0       	mov    0xc0123f40,%eax
c01092e2:	83 f8 03             	cmp    $0x3,%eax
c01092e5:	74 24                	je     c010930b <alloc_check+0x432>
c01092e7:	c7 44 24 0c 04 b6 10 	movl   $0xc010b604,0xc(%esp)
c01092ee:	c0 
c01092ef:	c7 44 24 08 be b2 10 	movl   $0xc010b2be,0x8(%esp)
c01092f6:	c0 
c01092f7:	c7 44 24 04 44 01 00 	movl   $0x144,0x4(%esp)
c01092fe:	00 
c01092ff:	c7 04 24 d3 b2 10 c0 	movl   $0xc010b2d3,(%esp)
c0109306:	e8 2b 71 ff ff       	call   c0100436 <__panic>

    assert((p1 = alloc_page()) != NULL);
c010930b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0109312:	e8 ff 9b ff ff       	call   c0102f16 <alloc_pages>
c0109317:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010931a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c010931e:	75 24                	jne    c0109344 <alloc_check+0x46b>
c0109320:	c7 44 24 0c 84 b4 10 	movl   $0xc010b484,0xc(%esp)
c0109327:	c0 
c0109328:	c7 44 24 08 be b2 10 	movl   $0xc010b2be,0x8(%esp)
c010932f:	c0 
c0109330:	c7 44 24 04 46 01 00 	movl   $0x146,0x4(%esp)
c0109337:	00 
c0109338:	c7 04 24 d3 b2 10 c0 	movl   $0xc010b2d3,(%esp)
c010933f:	e8 f2 70 ff ff       	call   c0100436 <__panic>
    assert((p0 = alloc_pages(2)) != NULL);
c0109344:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c010934b:	e8 c6 9b ff ff       	call   c0102f16 <alloc_pages>
c0109350:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0109353:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0109357:	75 24                	jne    c010937d <alloc_check+0x4a4>
c0109359:	c7 44 24 0c 11 b6 10 	movl   $0xc010b611,0xc(%esp)
c0109360:	c0 
c0109361:	c7 44 24 08 be b2 10 	movl   $0xc010b2be,0x8(%esp)
c0109368:	c0 
c0109369:	c7 44 24 04 47 01 00 	movl   $0x147,0x4(%esp)
c0109370:	00 
c0109371:	c7 04 24 d3 b2 10 c0 	movl   $0xc010b2d3,(%esp)
c0109378:	e8 b9 70 ff ff       	call   c0100436 <__panic>
    assert(p0 + 2 == p1);
c010937d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0109380:	83 c0 28             	add    $0x28,%eax
c0109383:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c0109386:	74 24                	je     c01093ac <alloc_check+0x4d3>
c0109388:	c7 44 24 0c 2f b6 10 	movl   $0xc010b62f,0xc(%esp)
c010938f:	c0 
c0109390:	c7 44 24 08 be b2 10 	movl   $0xc010b2be,0x8(%esp)
c0109397:	c0 
c0109398:	c7 44 24 04 48 01 00 	movl   $0x148,0x4(%esp)
c010939f:	00 
c01093a0:	c7 04 24 d3 b2 10 c0 	movl   $0xc010b2d3,(%esp)
c01093a7:	e8 8a 70 ff ff       	call   c0100436 <__panic>

    assert(alloc_page() == NULL);
c01093ac:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01093b3:	e8 5e 9b ff ff       	call   c0102f16 <alloc_pages>
c01093b8:	85 c0                	test   %eax,%eax
c01093ba:	74 24                	je     c01093e0 <alloc_check+0x507>
c01093bc:	c7 44 24 0c ef b5 10 	movl   $0xc010b5ef,0xc(%esp)
c01093c3:	c0 
c01093c4:	c7 44 24 08 be b2 10 	movl   $0xc010b2be,0x8(%esp)
c01093cb:	c0 
c01093cc:	c7 44 24 04 4a 01 00 	movl   $0x14a,0x4(%esp)
c01093d3:	00 
c01093d4:	c7 04 24 d3 b2 10 c0 	movl   $0xc010b2d3,(%esp)
c01093db:	e8 56 70 ff ff       	call   c0100436 <__panic>

    free_pages(p0, 2);
c01093e0:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c01093e7:	00 
c01093e8:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01093eb:	89 04 24             	mov    %eax,(%esp)
c01093ee:	e8 5f 9b ff ff       	call   c0102f52 <free_pages>
    free_page(p1);
c01093f3:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01093fa:	00 
c01093fb:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01093fe:	89 04 24             	mov    %eax,(%esp)
c0109401:	e8 4c 9b ff ff       	call   c0102f52 <free_pages>
    free_page(p3);
c0109406:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010940d:	00 
c010940e:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0109411:	89 04 24             	mov    %eax,(%esp)
c0109414:	e8 39 9b ff ff       	call   c0102f52 <free_pages>

    struct Page *p;
    assert((p = alloc_pages(4)) == p0);
c0109419:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c0109420:	e8 f1 9a ff ff       	call   c0102f16 <alloc_pages>
c0109425:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0109428:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010942b:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c010942e:	74 24                	je     c0109454 <alloc_check+0x57b>
c0109430:	c7 44 24 0c 3c b6 10 	movl   $0xc010b63c,0xc(%esp)
c0109437:	c0 
c0109438:	c7 44 24 08 be b2 10 	movl   $0xc010b2be,0x8(%esp)
c010943f:	c0 
c0109440:	c7 44 24 04 51 01 00 	movl   $0x151,0x4(%esp)
c0109447:	00 
c0109448:	c7 04 24 d3 b2 10 c0 	movl   $0xc010b2d3,(%esp)
c010944f:	e8 e2 6f ff ff       	call   c0100436 <__panic>
    assert(alloc_page() == NULL);
c0109454:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010945b:	e8 b6 9a ff ff       	call   c0102f16 <alloc_pages>
c0109460:	85 c0                	test   %eax,%eax
c0109462:	74 24                	je     c0109488 <alloc_check+0x5af>
c0109464:	c7 44 24 0c ef b5 10 	movl   $0xc010b5ef,0xc(%esp)
c010946b:	c0 
c010946c:	c7 44 24 08 be b2 10 	movl   $0xc010b2be,0x8(%esp)
c0109473:	c0 
c0109474:	c7 44 24 04 52 01 00 	movl   $0x152,0x4(%esp)
c010947b:	00 
c010947c:	c7 04 24 d3 b2 10 c0 	movl   $0xc010b2d3,(%esp)
c0109483:	e8 ae 6f ff ff       	call   c0100436 <__panic>

    assert(nr_free == 0);
c0109488:	a1 40 3f 12 c0       	mov    0xc0123f40,%eax
c010948d:	85 c0                	test   %eax,%eax
c010948f:	74 24                	je     c01094b5 <alloc_check+0x5dc>
c0109491:	c7 44 24 0c 57 b6 10 	movl   $0xc010b657,0xc(%esp)
c0109498:	c0 
c0109499:	c7 44 24 08 be b2 10 	movl   $0xc010b2be,0x8(%esp)
c01094a0:	c0 
c01094a1:	c7 44 24 04 54 01 00 	movl   $0x154,0x4(%esp)
c01094a8:	00 
c01094a9:	c7 04 24 d3 b2 10 c0 	movl   $0xc010b2d3,(%esp)
c01094b0:	e8 81 6f ff ff       	call   c0100436 <__panic>

    // Restore buddy system
    for (struct Page *p = buddy_physical; p < buddy_physical + buddy_physical_size_store; p++)
c01094b5:	a1 20 3f 12 c0       	mov    0xc0123f20,%eax
c01094ba:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01094bd:	eb 1e                	jmp    c01094dd <alloc_check+0x604>
        SetPageReserved(p);
c01094bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01094c2:	83 c0 04             	add    $0x4,%eax
c01094c5:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
c01094cc:	89 45 bc             	mov    %eax,-0x44(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01094cf:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01094d2:	8b 55 c0             	mov    -0x40(%ebp),%edx
c01094d5:	0f ab 10             	bts    %edx,(%eax)
}
c01094d8:	90                   	nop
    for (struct Page *p = buddy_physical; p < buddy_physical + buddy_physical_size_store; p++)
c01094d9:	83 45 ec 14          	addl   $0x14,-0x14(%ebp)
c01094dd:	8b 0d 20 3f 12 c0    	mov    0xc0123f20,%ecx
c01094e3:	8b 55 e8             	mov    -0x18(%ebp),%edx
c01094e6:	89 d0                	mov    %edx,%eax
c01094e8:	c1 e0 02             	shl    $0x2,%eax
c01094eb:	01 d0                	add    %edx,%eax
c01094ed:	c1 e0 02             	shl    $0x2,%eax
c01094f0:	01 c8                	add    %ecx,%eax
c01094f2:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c01094f5:	72 c8                	jb     c01094bf <alloc_check+0x5e6>
    buddy_init();
c01094f7:	e8 bc d0 ff ff       	call   c01065b8 <buddy_init>
    buddy_init_memmap(buddy_physical, buddy_physical_size_store);
c01094fc:	a1 20 3f 12 c0       	mov    0xc0123f20,%eax
c0109501:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0109504:	89 54 24 04          	mov    %edx,0x4(%esp)
c0109508:	89 04 24             	mov    %eax,(%esp)
c010950b:	e8 db d0 ff ff       	call   c01065eb <buddy_init_memmap>

}
c0109510:	90                   	nop
c0109511:	c9                   	leave  
c0109512:	c3                   	ret    

c0109513 <default_check>:

static void
default_check(void) {
c0109513:	f3 0f 1e fb          	endbr32 
c0109517:	55                   	push   %ebp
c0109518:	89 e5                	mov    %esp,%ebp
c010951a:	83 ec 08             	sub    $0x8,%esp

    // Check buddy system
    macro_check();
c010951d:	e8 0b f2 ff ff       	call   c010872d <macro_check>
    size_check();
c0109522:	e8 58 f3 ff ff       	call   c010887f <size_check>
    segment_check();
c0109527:	e8 9f f4 ff ff       	call   c01089cb <segment_check>
    alloc_check();
c010952c:	e8 a8 f9 ff ff       	call   c0108ed9 <alloc_check>
    
}
c0109531:	90                   	nop
c0109532:	c9                   	leave  
c0109533:	c3                   	ret    

c0109534 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c0109534:	f3 0f 1e fb          	endbr32 
c0109538:	55                   	push   %ebp
c0109539:	89 e5                	mov    %esp,%ebp
c010953b:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c010953e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c0109545:	eb 03                	jmp    c010954a <strlen+0x16>
        cnt ++;
c0109547:	ff 45 fc             	incl   -0x4(%ebp)
    while (*s ++ != '\0') {
c010954a:	8b 45 08             	mov    0x8(%ebp),%eax
c010954d:	8d 50 01             	lea    0x1(%eax),%edx
c0109550:	89 55 08             	mov    %edx,0x8(%ebp)
c0109553:	0f b6 00             	movzbl (%eax),%eax
c0109556:	84 c0                	test   %al,%al
c0109558:	75 ed                	jne    c0109547 <strlen+0x13>
    }
    return cnt;
c010955a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c010955d:	c9                   	leave  
c010955e:	c3                   	ret    

c010955f <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c010955f:	f3 0f 1e fb          	endbr32 
c0109563:	55                   	push   %ebp
c0109564:	89 e5                	mov    %esp,%ebp
c0109566:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0109569:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0109570:	eb 03                	jmp    c0109575 <strnlen+0x16>
        cnt ++;
c0109572:	ff 45 fc             	incl   -0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0109575:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0109578:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010957b:	73 10                	jae    c010958d <strnlen+0x2e>
c010957d:	8b 45 08             	mov    0x8(%ebp),%eax
c0109580:	8d 50 01             	lea    0x1(%eax),%edx
c0109583:	89 55 08             	mov    %edx,0x8(%ebp)
c0109586:	0f b6 00             	movzbl (%eax),%eax
c0109589:	84 c0                	test   %al,%al
c010958b:	75 e5                	jne    c0109572 <strnlen+0x13>
    }
    return cnt;
c010958d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0109590:	c9                   	leave  
c0109591:	c3                   	ret    

c0109592 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c0109592:	f3 0f 1e fb          	endbr32 
c0109596:	55                   	push   %ebp
c0109597:	89 e5                	mov    %esp,%ebp
c0109599:	57                   	push   %edi
c010959a:	56                   	push   %esi
c010959b:	83 ec 20             	sub    $0x20,%esp
c010959e:	8b 45 08             	mov    0x8(%ebp),%eax
c01095a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01095a4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01095a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c01095aa:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01095ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01095b0:	89 d1                	mov    %edx,%ecx
c01095b2:	89 c2                	mov    %eax,%edx
c01095b4:	89 ce                	mov    %ecx,%esi
c01095b6:	89 d7                	mov    %edx,%edi
c01095b8:	ac                   	lods   %ds:(%esi),%al
c01095b9:	aa                   	stos   %al,%es:(%edi)
c01095ba:	84 c0                	test   %al,%al
c01095bc:	75 fa                	jne    c01095b8 <strcpy+0x26>
c01095be:	89 fa                	mov    %edi,%edx
c01095c0:	89 f1                	mov    %esi,%ecx
c01095c2:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c01095c5:	89 55 e8             	mov    %edx,-0x18(%ebp)
c01095c8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c01095cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c01095ce:	83 c4 20             	add    $0x20,%esp
c01095d1:	5e                   	pop    %esi
c01095d2:	5f                   	pop    %edi
c01095d3:	5d                   	pop    %ebp
c01095d4:	c3                   	ret    

c01095d5 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c01095d5:	f3 0f 1e fb          	endbr32 
c01095d9:	55                   	push   %ebp
c01095da:	89 e5                	mov    %esp,%ebp
c01095dc:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c01095df:	8b 45 08             	mov    0x8(%ebp),%eax
c01095e2:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c01095e5:	eb 1e                	jmp    c0109605 <strncpy+0x30>
        if ((*p = *src) != '\0') {
c01095e7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01095ea:	0f b6 10             	movzbl (%eax),%edx
c01095ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01095f0:	88 10                	mov    %dl,(%eax)
c01095f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01095f5:	0f b6 00             	movzbl (%eax),%eax
c01095f8:	84 c0                	test   %al,%al
c01095fa:	74 03                	je     c01095ff <strncpy+0x2a>
            src ++;
c01095fc:	ff 45 0c             	incl   0xc(%ebp)
        }
        p ++, len --;
c01095ff:	ff 45 fc             	incl   -0x4(%ebp)
c0109602:	ff 4d 10             	decl   0x10(%ebp)
    while (len > 0) {
c0109605:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0109609:	75 dc                	jne    c01095e7 <strncpy+0x12>
    }
    return dst;
c010960b:	8b 45 08             	mov    0x8(%ebp),%eax
}
c010960e:	c9                   	leave  
c010960f:	c3                   	ret    

c0109610 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c0109610:	f3 0f 1e fb          	endbr32 
c0109614:	55                   	push   %ebp
c0109615:	89 e5                	mov    %esp,%ebp
c0109617:	57                   	push   %edi
c0109618:	56                   	push   %esi
c0109619:	83 ec 20             	sub    $0x20,%esp
c010961c:	8b 45 08             	mov    0x8(%ebp),%eax
c010961f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0109622:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109625:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
c0109628:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010962b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010962e:	89 d1                	mov    %edx,%ecx
c0109630:	89 c2                	mov    %eax,%edx
c0109632:	89 ce                	mov    %ecx,%esi
c0109634:	89 d7                	mov    %edx,%edi
c0109636:	ac                   	lods   %ds:(%esi),%al
c0109637:	ae                   	scas   %es:(%edi),%al
c0109638:	75 08                	jne    c0109642 <strcmp+0x32>
c010963a:	84 c0                	test   %al,%al
c010963c:	75 f8                	jne    c0109636 <strcmp+0x26>
c010963e:	31 c0                	xor    %eax,%eax
c0109640:	eb 04                	jmp    c0109646 <strcmp+0x36>
c0109642:	19 c0                	sbb    %eax,%eax
c0109644:	0c 01                	or     $0x1,%al
c0109646:	89 fa                	mov    %edi,%edx
c0109648:	89 f1                	mov    %esi,%ecx
c010964a:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010964d:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0109650:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
c0109653:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c0109656:	83 c4 20             	add    $0x20,%esp
c0109659:	5e                   	pop    %esi
c010965a:	5f                   	pop    %edi
c010965b:	5d                   	pop    %ebp
c010965c:	c3                   	ret    

c010965d <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c010965d:	f3 0f 1e fb          	endbr32 
c0109661:	55                   	push   %ebp
c0109662:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0109664:	eb 09                	jmp    c010966f <strncmp+0x12>
        n --, s1 ++, s2 ++;
c0109666:	ff 4d 10             	decl   0x10(%ebp)
c0109669:	ff 45 08             	incl   0x8(%ebp)
c010966c:	ff 45 0c             	incl   0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c010966f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0109673:	74 1a                	je     c010968f <strncmp+0x32>
c0109675:	8b 45 08             	mov    0x8(%ebp),%eax
c0109678:	0f b6 00             	movzbl (%eax),%eax
c010967b:	84 c0                	test   %al,%al
c010967d:	74 10                	je     c010968f <strncmp+0x32>
c010967f:	8b 45 08             	mov    0x8(%ebp),%eax
c0109682:	0f b6 10             	movzbl (%eax),%edx
c0109685:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109688:	0f b6 00             	movzbl (%eax),%eax
c010968b:	38 c2                	cmp    %al,%dl
c010968d:	74 d7                	je     c0109666 <strncmp+0x9>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c010968f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0109693:	74 18                	je     c01096ad <strncmp+0x50>
c0109695:	8b 45 08             	mov    0x8(%ebp),%eax
c0109698:	0f b6 00             	movzbl (%eax),%eax
c010969b:	0f b6 d0             	movzbl %al,%edx
c010969e:	8b 45 0c             	mov    0xc(%ebp),%eax
c01096a1:	0f b6 00             	movzbl (%eax),%eax
c01096a4:	0f b6 c0             	movzbl %al,%eax
c01096a7:	29 c2                	sub    %eax,%edx
c01096a9:	89 d0                	mov    %edx,%eax
c01096ab:	eb 05                	jmp    c01096b2 <strncmp+0x55>
c01096ad:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01096b2:	5d                   	pop    %ebp
c01096b3:	c3                   	ret    

c01096b4 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c01096b4:	f3 0f 1e fb          	endbr32 
c01096b8:	55                   	push   %ebp
c01096b9:	89 e5                	mov    %esp,%ebp
c01096bb:	83 ec 04             	sub    $0x4,%esp
c01096be:	8b 45 0c             	mov    0xc(%ebp),%eax
c01096c1:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c01096c4:	eb 13                	jmp    c01096d9 <strchr+0x25>
        if (*s == c) {
c01096c6:	8b 45 08             	mov    0x8(%ebp),%eax
c01096c9:	0f b6 00             	movzbl (%eax),%eax
c01096cc:	38 45 fc             	cmp    %al,-0x4(%ebp)
c01096cf:	75 05                	jne    c01096d6 <strchr+0x22>
            return (char *)s;
c01096d1:	8b 45 08             	mov    0x8(%ebp),%eax
c01096d4:	eb 12                	jmp    c01096e8 <strchr+0x34>
        }
        s ++;
c01096d6:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
c01096d9:	8b 45 08             	mov    0x8(%ebp),%eax
c01096dc:	0f b6 00             	movzbl (%eax),%eax
c01096df:	84 c0                	test   %al,%al
c01096e1:	75 e3                	jne    c01096c6 <strchr+0x12>
    }
    return NULL;
c01096e3:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01096e8:	c9                   	leave  
c01096e9:	c3                   	ret    

c01096ea <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c01096ea:	f3 0f 1e fb          	endbr32 
c01096ee:	55                   	push   %ebp
c01096ef:	89 e5                	mov    %esp,%ebp
c01096f1:	83 ec 04             	sub    $0x4,%esp
c01096f4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01096f7:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c01096fa:	eb 0e                	jmp    c010970a <strfind+0x20>
        if (*s == c) {
c01096fc:	8b 45 08             	mov    0x8(%ebp),%eax
c01096ff:	0f b6 00             	movzbl (%eax),%eax
c0109702:	38 45 fc             	cmp    %al,-0x4(%ebp)
c0109705:	74 0f                	je     c0109716 <strfind+0x2c>
            break;
        }
        s ++;
c0109707:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
c010970a:	8b 45 08             	mov    0x8(%ebp),%eax
c010970d:	0f b6 00             	movzbl (%eax),%eax
c0109710:	84 c0                	test   %al,%al
c0109712:	75 e8                	jne    c01096fc <strfind+0x12>
c0109714:	eb 01                	jmp    c0109717 <strfind+0x2d>
            break;
c0109716:	90                   	nop
    }
    return (char *)s;
c0109717:	8b 45 08             	mov    0x8(%ebp),%eax
}
c010971a:	c9                   	leave  
c010971b:	c3                   	ret    

c010971c <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c010971c:	f3 0f 1e fb          	endbr32 
c0109720:	55                   	push   %ebp
c0109721:	89 e5                	mov    %esp,%ebp
c0109723:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c0109726:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c010972d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0109734:	eb 03                	jmp    c0109739 <strtol+0x1d>
        s ++;
c0109736:	ff 45 08             	incl   0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
c0109739:	8b 45 08             	mov    0x8(%ebp),%eax
c010973c:	0f b6 00             	movzbl (%eax),%eax
c010973f:	3c 20                	cmp    $0x20,%al
c0109741:	74 f3                	je     c0109736 <strtol+0x1a>
c0109743:	8b 45 08             	mov    0x8(%ebp),%eax
c0109746:	0f b6 00             	movzbl (%eax),%eax
c0109749:	3c 09                	cmp    $0x9,%al
c010974b:	74 e9                	je     c0109736 <strtol+0x1a>
    }

    // plus/minus sign
    if (*s == '+') {
c010974d:	8b 45 08             	mov    0x8(%ebp),%eax
c0109750:	0f b6 00             	movzbl (%eax),%eax
c0109753:	3c 2b                	cmp    $0x2b,%al
c0109755:	75 05                	jne    c010975c <strtol+0x40>
        s ++;
c0109757:	ff 45 08             	incl   0x8(%ebp)
c010975a:	eb 14                	jmp    c0109770 <strtol+0x54>
    }
    else if (*s == '-') {
c010975c:	8b 45 08             	mov    0x8(%ebp),%eax
c010975f:	0f b6 00             	movzbl (%eax),%eax
c0109762:	3c 2d                	cmp    $0x2d,%al
c0109764:	75 0a                	jne    c0109770 <strtol+0x54>
        s ++, neg = 1;
c0109766:	ff 45 08             	incl   0x8(%ebp)
c0109769:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c0109770:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0109774:	74 06                	je     c010977c <strtol+0x60>
c0109776:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c010977a:	75 22                	jne    c010979e <strtol+0x82>
c010977c:	8b 45 08             	mov    0x8(%ebp),%eax
c010977f:	0f b6 00             	movzbl (%eax),%eax
c0109782:	3c 30                	cmp    $0x30,%al
c0109784:	75 18                	jne    c010979e <strtol+0x82>
c0109786:	8b 45 08             	mov    0x8(%ebp),%eax
c0109789:	40                   	inc    %eax
c010978a:	0f b6 00             	movzbl (%eax),%eax
c010978d:	3c 78                	cmp    $0x78,%al
c010978f:	75 0d                	jne    c010979e <strtol+0x82>
        s += 2, base = 16;
c0109791:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c0109795:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c010979c:	eb 29                	jmp    c01097c7 <strtol+0xab>
    }
    else if (base == 0 && s[0] == '0') {
c010979e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01097a2:	75 16                	jne    c01097ba <strtol+0x9e>
c01097a4:	8b 45 08             	mov    0x8(%ebp),%eax
c01097a7:	0f b6 00             	movzbl (%eax),%eax
c01097aa:	3c 30                	cmp    $0x30,%al
c01097ac:	75 0c                	jne    c01097ba <strtol+0x9e>
        s ++, base = 8;
c01097ae:	ff 45 08             	incl   0x8(%ebp)
c01097b1:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c01097b8:	eb 0d                	jmp    c01097c7 <strtol+0xab>
    }
    else if (base == 0) {
c01097ba:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01097be:	75 07                	jne    c01097c7 <strtol+0xab>
        base = 10;
c01097c0:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c01097c7:	8b 45 08             	mov    0x8(%ebp),%eax
c01097ca:	0f b6 00             	movzbl (%eax),%eax
c01097cd:	3c 2f                	cmp    $0x2f,%al
c01097cf:	7e 1b                	jle    c01097ec <strtol+0xd0>
c01097d1:	8b 45 08             	mov    0x8(%ebp),%eax
c01097d4:	0f b6 00             	movzbl (%eax),%eax
c01097d7:	3c 39                	cmp    $0x39,%al
c01097d9:	7f 11                	jg     c01097ec <strtol+0xd0>
            dig = *s - '0';
c01097db:	8b 45 08             	mov    0x8(%ebp),%eax
c01097de:	0f b6 00             	movzbl (%eax),%eax
c01097e1:	0f be c0             	movsbl %al,%eax
c01097e4:	83 e8 30             	sub    $0x30,%eax
c01097e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01097ea:	eb 48                	jmp    c0109834 <strtol+0x118>
        }
        else if (*s >= 'a' && *s <= 'z') {
c01097ec:	8b 45 08             	mov    0x8(%ebp),%eax
c01097ef:	0f b6 00             	movzbl (%eax),%eax
c01097f2:	3c 60                	cmp    $0x60,%al
c01097f4:	7e 1b                	jle    c0109811 <strtol+0xf5>
c01097f6:	8b 45 08             	mov    0x8(%ebp),%eax
c01097f9:	0f b6 00             	movzbl (%eax),%eax
c01097fc:	3c 7a                	cmp    $0x7a,%al
c01097fe:	7f 11                	jg     c0109811 <strtol+0xf5>
            dig = *s - 'a' + 10;
c0109800:	8b 45 08             	mov    0x8(%ebp),%eax
c0109803:	0f b6 00             	movzbl (%eax),%eax
c0109806:	0f be c0             	movsbl %al,%eax
c0109809:	83 e8 57             	sub    $0x57,%eax
c010980c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010980f:	eb 23                	jmp    c0109834 <strtol+0x118>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c0109811:	8b 45 08             	mov    0x8(%ebp),%eax
c0109814:	0f b6 00             	movzbl (%eax),%eax
c0109817:	3c 40                	cmp    $0x40,%al
c0109819:	7e 3b                	jle    c0109856 <strtol+0x13a>
c010981b:	8b 45 08             	mov    0x8(%ebp),%eax
c010981e:	0f b6 00             	movzbl (%eax),%eax
c0109821:	3c 5a                	cmp    $0x5a,%al
c0109823:	7f 31                	jg     c0109856 <strtol+0x13a>
            dig = *s - 'A' + 10;
c0109825:	8b 45 08             	mov    0x8(%ebp),%eax
c0109828:	0f b6 00             	movzbl (%eax),%eax
c010982b:	0f be c0             	movsbl %al,%eax
c010982e:	83 e8 37             	sub    $0x37,%eax
c0109831:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c0109834:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109837:	3b 45 10             	cmp    0x10(%ebp),%eax
c010983a:	7d 19                	jge    c0109855 <strtol+0x139>
            break;
        }
        s ++, val = (val * base) + dig;
c010983c:	ff 45 08             	incl   0x8(%ebp)
c010983f:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0109842:	0f af 45 10          	imul   0x10(%ebp),%eax
c0109846:	89 c2                	mov    %eax,%edx
c0109848:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010984b:	01 d0                	add    %edx,%eax
c010984d:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
c0109850:	e9 72 ff ff ff       	jmp    c01097c7 <strtol+0xab>
            break;
c0109855:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
c0109856:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010985a:	74 08                	je     c0109864 <strtol+0x148>
        *endptr = (char *) s;
c010985c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010985f:	8b 55 08             	mov    0x8(%ebp),%edx
c0109862:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c0109864:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0109868:	74 07                	je     c0109871 <strtol+0x155>
c010986a:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010986d:	f7 d8                	neg    %eax
c010986f:	eb 03                	jmp    c0109874 <strtol+0x158>
c0109871:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c0109874:	c9                   	leave  
c0109875:	c3                   	ret    

c0109876 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c0109876:	f3 0f 1e fb          	endbr32 
c010987a:	55                   	push   %ebp
c010987b:	89 e5                	mov    %esp,%ebp
c010987d:	57                   	push   %edi
c010987e:	83 ec 24             	sub    $0x24,%esp
c0109881:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109884:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c0109887:	0f be 55 d8          	movsbl -0x28(%ebp),%edx
c010988b:	8b 45 08             	mov    0x8(%ebp),%eax
c010988e:	89 45 f8             	mov    %eax,-0x8(%ebp)
c0109891:	88 55 f7             	mov    %dl,-0x9(%ebp)
c0109894:	8b 45 10             	mov    0x10(%ebp),%eax
c0109897:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c010989a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c010989d:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c01098a1:	8b 55 f8             	mov    -0x8(%ebp),%edx
c01098a4:	89 d7                	mov    %edx,%edi
c01098a6:	f3 aa                	rep stos %al,%es:(%edi)
c01098a8:	89 fa                	mov    %edi,%edx
c01098aa:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c01098ad:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c01098b0:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c01098b3:	83 c4 24             	add    $0x24,%esp
c01098b6:	5f                   	pop    %edi
c01098b7:	5d                   	pop    %ebp
c01098b8:	c3                   	ret    

c01098b9 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c01098b9:	f3 0f 1e fb          	endbr32 
c01098bd:	55                   	push   %ebp
c01098be:	89 e5                	mov    %esp,%ebp
c01098c0:	57                   	push   %edi
c01098c1:	56                   	push   %esi
c01098c2:	53                   	push   %ebx
c01098c3:	83 ec 30             	sub    $0x30,%esp
c01098c6:	8b 45 08             	mov    0x8(%ebp),%eax
c01098c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01098cc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01098cf:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01098d2:	8b 45 10             	mov    0x10(%ebp),%eax
c01098d5:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c01098d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01098db:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01098de:	73 42                	jae    c0109922 <memmove+0x69>
c01098e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01098e3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01098e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01098e9:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01098ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01098ef:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c01098f2:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01098f5:	c1 e8 02             	shr    $0x2,%eax
c01098f8:	89 c1                	mov    %eax,%ecx
    asm volatile (
c01098fa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01098fd:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0109900:	89 d7                	mov    %edx,%edi
c0109902:	89 c6                	mov    %eax,%esi
c0109904:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0109906:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0109909:	83 e1 03             	and    $0x3,%ecx
c010990c:	74 02                	je     c0109910 <memmove+0x57>
c010990e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0109910:	89 f0                	mov    %esi,%eax
c0109912:	89 fa                	mov    %edi,%edx
c0109914:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c0109917:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c010991a:	89 45 d0             	mov    %eax,-0x30(%ebp)
        : "memory");
    return dst;
c010991d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
        return __memcpy(dst, src, n);
c0109920:	eb 36                	jmp    c0109958 <memmove+0x9f>
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c0109922:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109925:	8d 50 ff             	lea    -0x1(%eax),%edx
c0109928:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010992b:	01 c2                	add    %eax,%edx
c010992d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109930:	8d 48 ff             	lea    -0x1(%eax),%ecx
c0109933:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109936:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
c0109939:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010993c:	89 c1                	mov    %eax,%ecx
c010993e:	89 d8                	mov    %ebx,%eax
c0109940:	89 d6                	mov    %edx,%esi
c0109942:	89 c7                	mov    %eax,%edi
c0109944:	fd                   	std    
c0109945:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0109947:	fc                   	cld    
c0109948:	89 f8                	mov    %edi,%eax
c010994a:	89 f2                	mov    %esi,%edx
c010994c:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c010994f:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0109952:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
c0109955:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c0109958:	83 c4 30             	add    $0x30,%esp
c010995b:	5b                   	pop    %ebx
c010995c:	5e                   	pop    %esi
c010995d:	5f                   	pop    %edi
c010995e:	5d                   	pop    %ebp
c010995f:	c3                   	ret    

c0109960 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c0109960:	f3 0f 1e fb          	endbr32 
c0109964:	55                   	push   %ebp
c0109965:	89 e5                	mov    %esp,%ebp
c0109967:	57                   	push   %edi
c0109968:	56                   	push   %esi
c0109969:	83 ec 20             	sub    $0x20,%esp
c010996c:	8b 45 08             	mov    0x8(%ebp),%eax
c010996f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0109972:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109975:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109978:	8b 45 10             	mov    0x10(%ebp),%eax
c010997b:	89 45 ec             	mov    %eax,-0x14(%ebp)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c010997e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109981:	c1 e8 02             	shr    $0x2,%eax
c0109984:	89 c1                	mov    %eax,%ecx
    asm volatile (
c0109986:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0109989:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010998c:	89 d7                	mov    %edx,%edi
c010998e:	89 c6                	mov    %eax,%esi
c0109990:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0109992:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c0109995:	83 e1 03             	and    $0x3,%ecx
c0109998:	74 02                	je     c010999c <memcpy+0x3c>
c010999a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c010999c:	89 f0                	mov    %esi,%eax
c010999e:	89 fa                	mov    %edi,%edx
c01099a0:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c01099a3:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c01099a6:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
c01099a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c01099ac:	83 c4 20             	add    $0x20,%esp
c01099af:	5e                   	pop    %esi
c01099b0:	5f                   	pop    %edi
c01099b1:	5d                   	pop    %ebp
c01099b2:	c3                   	ret    

c01099b3 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c01099b3:	f3 0f 1e fb          	endbr32 
c01099b7:	55                   	push   %ebp
c01099b8:	89 e5                	mov    %esp,%ebp
c01099ba:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c01099bd:	8b 45 08             	mov    0x8(%ebp),%eax
c01099c0:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c01099c3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01099c6:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c01099c9:	eb 2e                	jmp    c01099f9 <memcmp+0x46>
        if (*s1 != *s2) {
c01099cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01099ce:	0f b6 10             	movzbl (%eax),%edx
c01099d1:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01099d4:	0f b6 00             	movzbl (%eax),%eax
c01099d7:	38 c2                	cmp    %al,%dl
c01099d9:	74 18                	je     c01099f3 <memcmp+0x40>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c01099db:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01099de:	0f b6 00             	movzbl (%eax),%eax
c01099e1:	0f b6 d0             	movzbl %al,%edx
c01099e4:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01099e7:	0f b6 00             	movzbl (%eax),%eax
c01099ea:	0f b6 c0             	movzbl %al,%eax
c01099ed:	29 c2                	sub    %eax,%edx
c01099ef:	89 d0                	mov    %edx,%eax
c01099f1:	eb 18                	jmp    c0109a0b <memcmp+0x58>
        }
        s1 ++, s2 ++;
c01099f3:	ff 45 fc             	incl   -0x4(%ebp)
c01099f6:	ff 45 f8             	incl   -0x8(%ebp)
    while (n -- > 0) {
c01099f9:	8b 45 10             	mov    0x10(%ebp),%eax
c01099fc:	8d 50 ff             	lea    -0x1(%eax),%edx
c01099ff:	89 55 10             	mov    %edx,0x10(%ebp)
c0109a02:	85 c0                	test   %eax,%eax
c0109a04:	75 c5                	jne    c01099cb <memcmp+0x18>
    }
    return 0;
c0109a06:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0109a0b:	c9                   	leave  
c0109a0c:	c3                   	ret    

c0109a0d <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c0109a0d:	f3 0f 1e fb          	endbr32 
c0109a11:	55                   	push   %ebp
c0109a12:	89 e5                	mov    %esp,%ebp
c0109a14:	83 ec 58             	sub    $0x58,%esp
c0109a17:	8b 45 10             	mov    0x10(%ebp),%eax
c0109a1a:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0109a1d:	8b 45 14             	mov    0x14(%ebp),%eax
c0109a20:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c0109a23:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0109a26:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0109a29:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0109a2c:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c0109a2f:	8b 45 18             	mov    0x18(%ebp),%eax
c0109a32:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0109a35:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109a38:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0109a3b:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0109a3e:	89 55 f0             	mov    %edx,-0x10(%ebp)
c0109a41:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109a44:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0109a47:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0109a4b:	74 1c                	je     c0109a69 <printnum+0x5c>
c0109a4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109a50:	ba 00 00 00 00       	mov    $0x0,%edx
c0109a55:	f7 75 e4             	divl   -0x1c(%ebp)
c0109a58:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0109a5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109a5e:	ba 00 00 00 00       	mov    $0x0,%edx
c0109a63:	f7 75 e4             	divl   -0x1c(%ebp)
c0109a66:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109a69:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0109a6c:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0109a6f:	f7 75 e4             	divl   -0x1c(%ebp)
c0109a72:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0109a75:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0109a78:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0109a7b:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0109a7e:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0109a81:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0109a84:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0109a87:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c0109a8a:	8b 45 18             	mov    0x18(%ebp),%eax
c0109a8d:	ba 00 00 00 00       	mov    $0x0,%edx
c0109a92:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c0109a95:	39 45 d0             	cmp    %eax,-0x30(%ebp)
c0109a98:	19 d1                	sbb    %edx,%ecx
c0109a9a:	72 4c                	jb     c0109ae8 <printnum+0xdb>
        printnum(putch, putdat, result, base, width - 1, padc);
c0109a9c:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0109a9f:	8d 50 ff             	lea    -0x1(%eax),%edx
c0109aa2:	8b 45 20             	mov    0x20(%ebp),%eax
c0109aa5:	89 44 24 18          	mov    %eax,0x18(%esp)
c0109aa9:	89 54 24 14          	mov    %edx,0x14(%esp)
c0109aad:	8b 45 18             	mov    0x18(%ebp),%eax
c0109ab0:	89 44 24 10          	mov    %eax,0x10(%esp)
c0109ab4:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109ab7:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0109aba:	89 44 24 08          	mov    %eax,0x8(%esp)
c0109abe:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0109ac2:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109ac5:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109ac9:	8b 45 08             	mov    0x8(%ebp),%eax
c0109acc:	89 04 24             	mov    %eax,(%esp)
c0109acf:	e8 39 ff ff ff       	call   c0109a0d <printnum>
c0109ad4:	eb 1b                	jmp    c0109af1 <printnum+0xe4>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c0109ad6:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109ad9:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109add:	8b 45 20             	mov    0x20(%ebp),%eax
c0109ae0:	89 04 24             	mov    %eax,(%esp)
c0109ae3:	8b 45 08             	mov    0x8(%ebp),%eax
c0109ae6:	ff d0                	call   *%eax
        while (-- width > 0)
c0109ae8:	ff 4d 1c             	decl   0x1c(%ebp)
c0109aeb:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0109aef:	7f e5                	jg     c0109ad6 <printnum+0xc9>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c0109af1:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0109af4:	05 14 b7 10 c0       	add    $0xc010b714,%eax
c0109af9:	0f b6 00             	movzbl (%eax),%eax
c0109afc:	0f be c0             	movsbl %al,%eax
c0109aff:	8b 55 0c             	mov    0xc(%ebp),%edx
c0109b02:	89 54 24 04          	mov    %edx,0x4(%esp)
c0109b06:	89 04 24             	mov    %eax,(%esp)
c0109b09:	8b 45 08             	mov    0x8(%ebp),%eax
c0109b0c:	ff d0                	call   *%eax
}
c0109b0e:	90                   	nop
c0109b0f:	c9                   	leave  
c0109b10:	c3                   	ret    

c0109b11 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c0109b11:	f3 0f 1e fb          	endbr32 
c0109b15:	55                   	push   %ebp
c0109b16:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0109b18:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0109b1c:	7e 14                	jle    c0109b32 <getuint+0x21>
        return va_arg(*ap, unsigned long long);
c0109b1e:	8b 45 08             	mov    0x8(%ebp),%eax
c0109b21:	8b 00                	mov    (%eax),%eax
c0109b23:	8d 48 08             	lea    0x8(%eax),%ecx
c0109b26:	8b 55 08             	mov    0x8(%ebp),%edx
c0109b29:	89 0a                	mov    %ecx,(%edx)
c0109b2b:	8b 50 04             	mov    0x4(%eax),%edx
c0109b2e:	8b 00                	mov    (%eax),%eax
c0109b30:	eb 30                	jmp    c0109b62 <getuint+0x51>
    }
    else if (lflag) {
c0109b32:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0109b36:	74 16                	je     c0109b4e <getuint+0x3d>
        return va_arg(*ap, unsigned long);
c0109b38:	8b 45 08             	mov    0x8(%ebp),%eax
c0109b3b:	8b 00                	mov    (%eax),%eax
c0109b3d:	8d 48 04             	lea    0x4(%eax),%ecx
c0109b40:	8b 55 08             	mov    0x8(%ebp),%edx
c0109b43:	89 0a                	mov    %ecx,(%edx)
c0109b45:	8b 00                	mov    (%eax),%eax
c0109b47:	ba 00 00 00 00       	mov    $0x0,%edx
c0109b4c:	eb 14                	jmp    c0109b62 <getuint+0x51>
    }
    else {
        return va_arg(*ap, unsigned int);
c0109b4e:	8b 45 08             	mov    0x8(%ebp),%eax
c0109b51:	8b 00                	mov    (%eax),%eax
c0109b53:	8d 48 04             	lea    0x4(%eax),%ecx
c0109b56:	8b 55 08             	mov    0x8(%ebp),%edx
c0109b59:	89 0a                	mov    %ecx,(%edx)
c0109b5b:	8b 00                	mov    (%eax),%eax
c0109b5d:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c0109b62:	5d                   	pop    %ebp
c0109b63:	c3                   	ret    

c0109b64 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c0109b64:	f3 0f 1e fb          	endbr32 
c0109b68:	55                   	push   %ebp
c0109b69:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0109b6b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0109b6f:	7e 14                	jle    c0109b85 <getint+0x21>
        return va_arg(*ap, long long);
c0109b71:	8b 45 08             	mov    0x8(%ebp),%eax
c0109b74:	8b 00                	mov    (%eax),%eax
c0109b76:	8d 48 08             	lea    0x8(%eax),%ecx
c0109b79:	8b 55 08             	mov    0x8(%ebp),%edx
c0109b7c:	89 0a                	mov    %ecx,(%edx)
c0109b7e:	8b 50 04             	mov    0x4(%eax),%edx
c0109b81:	8b 00                	mov    (%eax),%eax
c0109b83:	eb 28                	jmp    c0109bad <getint+0x49>
    }
    else if (lflag) {
c0109b85:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0109b89:	74 12                	je     c0109b9d <getint+0x39>
        return va_arg(*ap, long);
c0109b8b:	8b 45 08             	mov    0x8(%ebp),%eax
c0109b8e:	8b 00                	mov    (%eax),%eax
c0109b90:	8d 48 04             	lea    0x4(%eax),%ecx
c0109b93:	8b 55 08             	mov    0x8(%ebp),%edx
c0109b96:	89 0a                	mov    %ecx,(%edx)
c0109b98:	8b 00                	mov    (%eax),%eax
c0109b9a:	99                   	cltd   
c0109b9b:	eb 10                	jmp    c0109bad <getint+0x49>
    }
    else {
        return va_arg(*ap, int);
c0109b9d:	8b 45 08             	mov    0x8(%ebp),%eax
c0109ba0:	8b 00                	mov    (%eax),%eax
c0109ba2:	8d 48 04             	lea    0x4(%eax),%ecx
c0109ba5:	8b 55 08             	mov    0x8(%ebp),%edx
c0109ba8:	89 0a                	mov    %ecx,(%edx)
c0109baa:	8b 00                	mov    (%eax),%eax
c0109bac:	99                   	cltd   
    }
}
c0109bad:	5d                   	pop    %ebp
c0109bae:	c3                   	ret    

c0109baf <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c0109baf:	f3 0f 1e fb          	endbr32 
c0109bb3:	55                   	push   %ebp
c0109bb4:	89 e5                	mov    %esp,%ebp
c0109bb6:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
c0109bb9:	8d 45 14             	lea    0x14(%ebp),%eax
c0109bbc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c0109bbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109bc2:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0109bc6:	8b 45 10             	mov    0x10(%ebp),%eax
c0109bc9:	89 44 24 08          	mov    %eax,0x8(%esp)
c0109bcd:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109bd0:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109bd4:	8b 45 08             	mov    0x8(%ebp),%eax
c0109bd7:	89 04 24             	mov    %eax,(%esp)
c0109bda:	e8 03 00 00 00       	call   c0109be2 <vprintfmt>
    va_end(ap);
}
c0109bdf:	90                   	nop
c0109be0:	c9                   	leave  
c0109be1:	c3                   	ret    

c0109be2 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c0109be2:	f3 0f 1e fb          	endbr32 
c0109be6:	55                   	push   %ebp
c0109be7:	89 e5                	mov    %esp,%ebp
c0109be9:	56                   	push   %esi
c0109bea:	53                   	push   %ebx
c0109beb:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0109bee:	eb 17                	jmp    c0109c07 <vprintfmt+0x25>
            if (ch == '\0') {
c0109bf0:	85 db                	test   %ebx,%ebx
c0109bf2:	0f 84 c0 03 00 00    	je     c0109fb8 <vprintfmt+0x3d6>
                return;
            }
            putch(ch, putdat);
c0109bf8:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109bfb:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109bff:	89 1c 24             	mov    %ebx,(%esp)
c0109c02:	8b 45 08             	mov    0x8(%ebp),%eax
c0109c05:	ff d0                	call   *%eax
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0109c07:	8b 45 10             	mov    0x10(%ebp),%eax
c0109c0a:	8d 50 01             	lea    0x1(%eax),%edx
c0109c0d:	89 55 10             	mov    %edx,0x10(%ebp)
c0109c10:	0f b6 00             	movzbl (%eax),%eax
c0109c13:	0f b6 d8             	movzbl %al,%ebx
c0109c16:	83 fb 25             	cmp    $0x25,%ebx
c0109c19:	75 d5                	jne    c0109bf0 <vprintfmt+0xe>
        }

        // Process a %-escape sequence
        char padc = ' ';
c0109c1b:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c0109c1f:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c0109c26:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0109c29:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c0109c2c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0109c33:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0109c36:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c0109c39:	8b 45 10             	mov    0x10(%ebp),%eax
c0109c3c:	8d 50 01             	lea    0x1(%eax),%edx
c0109c3f:	89 55 10             	mov    %edx,0x10(%ebp)
c0109c42:	0f b6 00             	movzbl (%eax),%eax
c0109c45:	0f b6 d8             	movzbl %al,%ebx
c0109c48:	8d 43 dd             	lea    -0x23(%ebx),%eax
c0109c4b:	83 f8 55             	cmp    $0x55,%eax
c0109c4e:	0f 87 38 03 00 00    	ja     c0109f8c <vprintfmt+0x3aa>
c0109c54:	8b 04 85 38 b7 10 c0 	mov    -0x3fef48c8(,%eax,4),%eax
c0109c5b:	3e ff e0             	notrack jmp *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c0109c5e:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c0109c62:	eb d5                	jmp    c0109c39 <vprintfmt+0x57>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c0109c64:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c0109c68:	eb cf                	jmp    c0109c39 <vprintfmt+0x57>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c0109c6a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c0109c71:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0109c74:	89 d0                	mov    %edx,%eax
c0109c76:	c1 e0 02             	shl    $0x2,%eax
c0109c79:	01 d0                	add    %edx,%eax
c0109c7b:	01 c0                	add    %eax,%eax
c0109c7d:	01 d8                	add    %ebx,%eax
c0109c7f:	83 e8 30             	sub    $0x30,%eax
c0109c82:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c0109c85:	8b 45 10             	mov    0x10(%ebp),%eax
c0109c88:	0f b6 00             	movzbl (%eax),%eax
c0109c8b:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c0109c8e:	83 fb 2f             	cmp    $0x2f,%ebx
c0109c91:	7e 38                	jle    c0109ccb <vprintfmt+0xe9>
c0109c93:	83 fb 39             	cmp    $0x39,%ebx
c0109c96:	7f 33                	jg     c0109ccb <vprintfmt+0xe9>
            for (precision = 0; ; ++ fmt) {
c0109c98:	ff 45 10             	incl   0x10(%ebp)
                precision = precision * 10 + ch - '0';
c0109c9b:	eb d4                	jmp    c0109c71 <vprintfmt+0x8f>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
c0109c9d:	8b 45 14             	mov    0x14(%ebp),%eax
c0109ca0:	8d 50 04             	lea    0x4(%eax),%edx
c0109ca3:	89 55 14             	mov    %edx,0x14(%ebp)
c0109ca6:	8b 00                	mov    (%eax),%eax
c0109ca8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c0109cab:	eb 1f                	jmp    c0109ccc <vprintfmt+0xea>

        case '.':
            if (width < 0)
c0109cad:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0109cb1:	79 86                	jns    c0109c39 <vprintfmt+0x57>
                width = 0;
c0109cb3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c0109cba:	e9 7a ff ff ff       	jmp    c0109c39 <vprintfmt+0x57>

        case '#':
            altflag = 1;
c0109cbf:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c0109cc6:	e9 6e ff ff ff       	jmp    c0109c39 <vprintfmt+0x57>
            goto process_precision;
c0109ccb:	90                   	nop

        process_precision:
            if (width < 0)
c0109ccc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0109cd0:	0f 89 63 ff ff ff    	jns    c0109c39 <vprintfmt+0x57>
                width = precision, precision = -1;
c0109cd6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0109cd9:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0109cdc:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c0109ce3:	e9 51 ff ff ff       	jmp    c0109c39 <vprintfmt+0x57>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c0109ce8:	ff 45 e0             	incl   -0x20(%ebp)
            goto reswitch;
c0109ceb:	e9 49 ff ff ff       	jmp    c0109c39 <vprintfmt+0x57>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c0109cf0:	8b 45 14             	mov    0x14(%ebp),%eax
c0109cf3:	8d 50 04             	lea    0x4(%eax),%edx
c0109cf6:	89 55 14             	mov    %edx,0x14(%ebp)
c0109cf9:	8b 00                	mov    (%eax),%eax
c0109cfb:	8b 55 0c             	mov    0xc(%ebp),%edx
c0109cfe:	89 54 24 04          	mov    %edx,0x4(%esp)
c0109d02:	89 04 24             	mov    %eax,(%esp)
c0109d05:	8b 45 08             	mov    0x8(%ebp),%eax
c0109d08:	ff d0                	call   *%eax
            break;
c0109d0a:	e9 a4 02 00 00       	jmp    c0109fb3 <vprintfmt+0x3d1>

        // error message
        case 'e':
            err = va_arg(ap, int);
c0109d0f:	8b 45 14             	mov    0x14(%ebp),%eax
c0109d12:	8d 50 04             	lea    0x4(%eax),%edx
c0109d15:	89 55 14             	mov    %edx,0x14(%ebp)
c0109d18:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c0109d1a:	85 db                	test   %ebx,%ebx
c0109d1c:	79 02                	jns    c0109d20 <vprintfmt+0x13e>
                err = -err;
c0109d1e:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c0109d20:	83 fb 06             	cmp    $0x6,%ebx
c0109d23:	7f 0b                	jg     c0109d30 <vprintfmt+0x14e>
c0109d25:	8b 34 9d f8 b6 10 c0 	mov    -0x3fef4908(,%ebx,4),%esi
c0109d2c:	85 f6                	test   %esi,%esi
c0109d2e:	75 23                	jne    c0109d53 <vprintfmt+0x171>
                printfmt(putch, putdat, "error %d", err);
c0109d30:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0109d34:	c7 44 24 08 25 b7 10 	movl   $0xc010b725,0x8(%esp)
c0109d3b:	c0 
c0109d3c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109d3f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109d43:	8b 45 08             	mov    0x8(%ebp),%eax
c0109d46:	89 04 24             	mov    %eax,(%esp)
c0109d49:	e8 61 fe ff ff       	call   c0109baf <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c0109d4e:	e9 60 02 00 00       	jmp    c0109fb3 <vprintfmt+0x3d1>
                printfmt(putch, putdat, "%s", p);
c0109d53:	89 74 24 0c          	mov    %esi,0xc(%esp)
c0109d57:	c7 44 24 08 2e b7 10 	movl   $0xc010b72e,0x8(%esp)
c0109d5e:	c0 
c0109d5f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109d62:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109d66:	8b 45 08             	mov    0x8(%ebp),%eax
c0109d69:	89 04 24             	mov    %eax,(%esp)
c0109d6c:	e8 3e fe ff ff       	call   c0109baf <printfmt>
            break;
c0109d71:	e9 3d 02 00 00       	jmp    c0109fb3 <vprintfmt+0x3d1>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c0109d76:	8b 45 14             	mov    0x14(%ebp),%eax
c0109d79:	8d 50 04             	lea    0x4(%eax),%edx
c0109d7c:	89 55 14             	mov    %edx,0x14(%ebp)
c0109d7f:	8b 30                	mov    (%eax),%esi
c0109d81:	85 f6                	test   %esi,%esi
c0109d83:	75 05                	jne    c0109d8a <vprintfmt+0x1a8>
                p = "(null)";
c0109d85:	be 31 b7 10 c0       	mov    $0xc010b731,%esi
            }
            if (width > 0 && padc != '-') {
c0109d8a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0109d8e:	7e 76                	jle    c0109e06 <vprintfmt+0x224>
c0109d90:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c0109d94:	74 70                	je     c0109e06 <vprintfmt+0x224>
                for (width -= strnlen(p, precision); width > 0; width --) {
c0109d96:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0109d99:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109d9d:	89 34 24             	mov    %esi,(%esp)
c0109da0:	e8 ba f7 ff ff       	call   c010955f <strnlen>
c0109da5:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0109da8:	29 c2                	sub    %eax,%edx
c0109daa:	89 d0                	mov    %edx,%eax
c0109dac:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0109daf:	eb 16                	jmp    c0109dc7 <vprintfmt+0x1e5>
                    putch(padc, putdat);
c0109db1:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c0109db5:	8b 55 0c             	mov    0xc(%ebp),%edx
c0109db8:	89 54 24 04          	mov    %edx,0x4(%esp)
c0109dbc:	89 04 24             	mov    %eax,(%esp)
c0109dbf:	8b 45 08             	mov    0x8(%ebp),%eax
c0109dc2:	ff d0                	call   *%eax
                for (width -= strnlen(p, precision); width > 0; width --) {
c0109dc4:	ff 4d e8             	decl   -0x18(%ebp)
c0109dc7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0109dcb:	7f e4                	jg     c0109db1 <vprintfmt+0x1cf>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0109dcd:	eb 37                	jmp    c0109e06 <vprintfmt+0x224>
                if (altflag && (ch < ' ' || ch > '~')) {
c0109dcf:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0109dd3:	74 1f                	je     c0109df4 <vprintfmt+0x212>
c0109dd5:	83 fb 1f             	cmp    $0x1f,%ebx
c0109dd8:	7e 05                	jle    c0109ddf <vprintfmt+0x1fd>
c0109dda:	83 fb 7e             	cmp    $0x7e,%ebx
c0109ddd:	7e 15                	jle    c0109df4 <vprintfmt+0x212>
                    putch('?', putdat);
c0109ddf:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109de2:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109de6:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
c0109ded:	8b 45 08             	mov    0x8(%ebp),%eax
c0109df0:	ff d0                	call   *%eax
c0109df2:	eb 0f                	jmp    c0109e03 <vprintfmt+0x221>
                }
                else {
                    putch(ch, putdat);
c0109df4:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109df7:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109dfb:	89 1c 24             	mov    %ebx,(%esp)
c0109dfe:	8b 45 08             	mov    0x8(%ebp),%eax
c0109e01:	ff d0                	call   *%eax
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0109e03:	ff 4d e8             	decl   -0x18(%ebp)
c0109e06:	89 f0                	mov    %esi,%eax
c0109e08:	8d 70 01             	lea    0x1(%eax),%esi
c0109e0b:	0f b6 00             	movzbl (%eax),%eax
c0109e0e:	0f be d8             	movsbl %al,%ebx
c0109e11:	85 db                	test   %ebx,%ebx
c0109e13:	74 27                	je     c0109e3c <vprintfmt+0x25a>
c0109e15:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0109e19:	78 b4                	js     c0109dcf <vprintfmt+0x1ed>
c0109e1b:	ff 4d e4             	decl   -0x1c(%ebp)
c0109e1e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0109e22:	79 ab                	jns    c0109dcf <vprintfmt+0x1ed>
                }
            }
            for (; width > 0; width --) {
c0109e24:	eb 16                	jmp    c0109e3c <vprintfmt+0x25a>
                putch(' ', putdat);
c0109e26:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109e29:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109e2d:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0109e34:	8b 45 08             	mov    0x8(%ebp),%eax
c0109e37:	ff d0                	call   *%eax
            for (; width > 0; width --) {
c0109e39:	ff 4d e8             	decl   -0x18(%ebp)
c0109e3c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0109e40:	7f e4                	jg     c0109e26 <vprintfmt+0x244>
            }
            break;
c0109e42:	e9 6c 01 00 00       	jmp    c0109fb3 <vprintfmt+0x3d1>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c0109e47:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0109e4a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109e4e:	8d 45 14             	lea    0x14(%ebp),%eax
c0109e51:	89 04 24             	mov    %eax,(%esp)
c0109e54:	e8 0b fd ff ff       	call   c0109b64 <getint>
c0109e59:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109e5c:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c0109e5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109e62:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0109e65:	85 d2                	test   %edx,%edx
c0109e67:	79 26                	jns    c0109e8f <vprintfmt+0x2ad>
                putch('-', putdat);
c0109e69:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109e6c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109e70:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
c0109e77:	8b 45 08             	mov    0x8(%ebp),%eax
c0109e7a:	ff d0                	call   *%eax
                num = -(long long)num;
c0109e7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109e7f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0109e82:	f7 d8                	neg    %eax
c0109e84:	83 d2 00             	adc    $0x0,%edx
c0109e87:	f7 da                	neg    %edx
c0109e89:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109e8c:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c0109e8f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0109e96:	e9 a8 00 00 00       	jmp    c0109f43 <vprintfmt+0x361>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c0109e9b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0109e9e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109ea2:	8d 45 14             	lea    0x14(%ebp),%eax
c0109ea5:	89 04 24             	mov    %eax,(%esp)
c0109ea8:	e8 64 fc ff ff       	call   c0109b11 <getuint>
c0109ead:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109eb0:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c0109eb3:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0109eba:	e9 84 00 00 00       	jmp    c0109f43 <vprintfmt+0x361>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c0109ebf:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0109ec2:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109ec6:	8d 45 14             	lea    0x14(%ebp),%eax
c0109ec9:	89 04 24             	mov    %eax,(%esp)
c0109ecc:	e8 40 fc ff ff       	call   c0109b11 <getuint>
c0109ed1:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109ed4:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c0109ed7:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c0109ede:	eb 63                	jmp    c0109f43 <vprintfmt+0x361>

        // pointer
        case 'p':
            putch('0', putdat);
c0109ee0:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109ee3:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109ee7:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
c0109eee:	8b 45 08             	mov    0x8(%ebp),%eax
c0109ef1:	ff d0                	call   *%eax
            putch('x', putdat);
c0109ef3:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109ef6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109efa:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
c0109f01:	8b 45 08             	mov    0x8(%ebp),%eax
c0109f04:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c0109f06:	8b 45 14             	mov    0x14(%ebp),%eax
c0109f09:	8d 50 04             	lea    0x4(%eax),%edx
c0109f0c:	89 55 14             	mov    %edx,0x14(%ebp)
c0109f0f:	8b 00                	mov    (%eax),%eax
c0109f11:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109f14:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c0109f1b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c0109f22:	eb 1f                	jmp    c0109f43 <vprintfmt+0x361>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c0109f24:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0109f27:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109f2b:	8d 45 14             	lea    0x14(%ebp),%eax
c0109f2e:	89 04 24             	mov    %eax,(%esp)
c0109f31:	e8 db fb ff ff       	call   c0109b11 <getuint>
c0109f36:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109f39:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c0109f3c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c0109f43:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c0109f47:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109f4a:	89 54 24 18          	mov    %edx,0x18(%esp)
c0109f4e:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0109f51:	89 54 24 14          	mov    %edx,0x14(%esp)
c0109f55:	89 44 24 10          	mov    %eax,0x10(%esp)
c0109f59:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109f5c:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0109f5f:	89 44 24 08          	mov    %eax,0x8(%esp)
c0109f63:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0109f67:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109f6a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109f6e:	8b 45 08             	mov    0x8(%ebp),%eax
c0109f71:	89 04 24             	mov    %eax,(%esp)
c0109f74:	e8 94 fa ff ff       	call   c0109a0d <printnum>
            break;
c0109f79:	eb 38                	jmp    c0109fb3 <vprintfmt+0x3d1>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c0109f7b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109f7e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109f82:	89 1c 24             	mov    %ebx,(%esp)
c0109f85:	8b 45 08             	mov    0x8(%ebp),%eax
c0109f88:	ff d0                	call   *%eax
            break;
c0109f8a:	eb 27                	jmp    c0109fb3 <vprintfmt+0x3d1>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c0109f8c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109f8f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109f93:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
c0109f9a:	8b 45 08             	mov    0x8(%ebp),%eax
c0109f9d:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
c0109f9f:	ff 4d 10             	decl   0x10(%ebp)
c0109fa2:	eb 03                	jmp    c0109fa7 <vprintfmt+0x3c5>
c0109fa4:	ff 4d 10             	decl   0x10(%ebp)
c0109fa7:	8b 45 10             	mov    0x10(%ebp),%eax
c0109faa:	48                   	dec    %eax
c0109fab:	0f b6 00             	movzbl (%eax),%eax
c0109fae:	3c 25                	cmp    $0x25,%al
c0109fb0:	75 f2                	jne    c0109fa4 <vprintfmt+0x3c2>
                /* do nothing */;
            break;
c0109fb2:	90                   	nop
    while (1) {
c0109fb3:	e9 36 fc ff ff       	jmp    c0109bee <vprintfmt+0xc>
                return;
c0109fb8:	90                   	nop
        }
    }
}
c0109fb9:	83 c4 40             	add    $0x40,%esp
c0109fbc:	5b                   	pop    %ebx
c0109fbd:	5e                   	pop    %esi
c0109fbe:	5d                   	pop    %ebp
c0109fbf:	c3                   	ret    

c0109fc0 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c0109fc0:	f3 0f 1e fb          	endbr32 
c0109fc4:	55                   	push   %ebp
c0109fc5:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c0109fc7:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109fca:	8b 40 08             	mov    0x8(%eax),%eax
c0109fcd:	8d 50 01             	lea    0x1(%eax),%edx
c0109fd0:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109fd3:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c0109fd6:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109fd9:	8b 10                	mov    (%eax),%edx
c0109fdb:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109fde:	8b 40 04             	mov    0x4(%eax),%eax
c0109fe1:	39 c2                	cmp    %eax,%edx
c0109fe3:	73 12                	jae    c0109ff7 <sprintputch+0x37>
        *b->buf ++ = ch;
c0109fe5:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109fe8:	8b 00                	mov    (%eax),%eax
c0109fea:	8d 48 01             	lea    0x1(%eax),%ecx
c0109fed:	8b 55 0c             	mov    0xc(%ebp),%edx
c0109ff0:	89 0a                	mov    %ecx,(%edx)
c0109ff2:	8b 55 08             	mov    0x8(%ebp),%edx
c0109ff5:	88 10                	mov    %dl,(%eax)
    }
}
c0109ff7:	90                   	nop
c0109ff8:	5d                   	pop    %ebp
c0109ff9:	c3                   	ret    

c0109ffa <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c0109ffa:	f3 0f 1e fb          	endbr32 
c0109ffe:	55                   	push   %ebp
c0109fff:	89 e5                	mov    %esp,%ebp
c010a001:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c010a004:	8d 45 14             	lea    0x14(%ebp),%eax
c010a007:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c010a00a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010a00d:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010a011:	8b 45 10             	mov    0x10(%ebp),%eax
c010a014:	89 44 24 08          	mov    %eax,0x8(%esp)
c010a018:	8b 45 0c             	mov    0xc(%ebp),%eax
c010a01b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010a01f:	8b 45 08             	mov    0x8(%ebp),%eax
c010a022:	89 04 24             	mov    %eax,(%esp)
c010a025:	e8 08 00 00 00       	call   c010a032 <vsnprintf>
c010a02a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c010a02d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010a030:	c9                   	leave  
c010a031:	c3                   	ret    

c010a032 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c010a032:	f3 0f 1e fb          	endbr32 
c010a036:	55                   	push   %ebp
c010a037:	89 e5                	mov    %esp,%ebp
c010a039:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c010a03c:	8b 45 08             	mov    0x8(%ebp),%eax
c010a03f:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010a042:	8b 45 0c             	mov    0xc(%ebp),%eax
c010a045:	8d 50 ff             	lea    -0x1(%eax),%edx
c010a048:	8b 45 08             	mov    0x8(%ebp),%eax
c010a04b:	01 d0                	add    %edx,%eax
c010a04d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010a050:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c010a057:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010a05b:	74 0a                	je     c010a067 <vsnprintf+0x35>
c010a05d:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010a060:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010a063:	39 c2                	cmp    %eax,%edx
c010a065:	76 07                	jbe    c010a06e <vsnprintf+0x3c>
        return -E_INVAL;
c010a067:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c010a06c:	eb 2a                	jmp    c010a098 <vsnprintf+0x66>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c010a06e:	8b 45 14             	mov    0x14(%ebp),%eax
c010a071:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010a075:	8b 45 10             	mov    0x10(%ebp),%eax
c010a078:	89 44 24 08          	mov    %eax,0x8(%esp)
c010a07c:	8d 45 ec             	lea    -0x14(%ebp),%eax
c010a07f:	89 44 24 04          	mov    %eax,0x4(%esp)
c010a083:	c7 04 24 c0 9f 10 c0 	movl   $0xc0109fc0,(%esp)
c010a08a:	e8 53 fb ff ff       	call   c0109be2 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
c010a08f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a092:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c010a095:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010a098:	c9                   	leave  
c010a099:	c3                   	ret    
