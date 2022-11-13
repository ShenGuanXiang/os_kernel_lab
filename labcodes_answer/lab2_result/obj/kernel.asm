
bin/kernel:     file format elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:

.text
.globl kern_entry
kern_entry:
    # load pa of boot pgdir
    movl $REALLOC(__boot_pgdir), %eax
c0100000:	b8 00 a0 11 00       	mov    $0x11a000,%eax
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
c0100020:	a3 00 a0 11 c0       	mov    %eax,0xc011a000

    # set ebp, esp
    movl $0x0, %ebp
c0100025:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
c010002a:	bc 00 90 11 c0       	mov    $0xc0119000,%esp
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

static void lab1_switch_test(void);

int
kern_init(void) {
c0100036:	f3 0f 1e fb          	endbr32 
c010003a:	55                   	push   %ebp
c010003b:	89 e5                	mov    %esp,%ebp
c010003d:	83 ec 18             	sub    $0x18,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
c0100040:	b8 28 cf 11 c0       	mov    $0xc011cf28,%eax
c0100045:	2d 00 c0 11 c0       	sub    $0xc011c000,%eax
c010004a:	83 ec 04             	sub    $0x4,%esp
c010004d:	50                   	push   %eax
c010004e:	6a 00                	push   $0x0
c0100050:	68 00 c0 11 c0       	push   $0xc011c000
c0100055:	e8 45 54 00 00       	call   c010549f <memset>
c010005a:	83 c4 10             	add    $0x10,%esp

    cons_init();                // init the console
c010005d:	e8 37 16 00 00       	call   c0101699 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c0100062:	c7 45 f4 60 5c 10 c0 	movl   $0xc0105c60,-0xc(%ebp)
    cprintf("%s\n\n", message);
c0100069:	83 ec 08             	sub    $0x8,%esp
c010006c:	ff 75 f4             	pushl  -0xc(%ebp)
c010006f:	68 7c 5c 10 c0       	push   $0xc0105c7c
c0100074:	e8 22 02 00 00       	call   c010029b <cprintf>
c0100079:	83 c4 10             	add    $0x10,%esp

    print_kerninfo();
c010007c:	e8 d6 08 00 00       	call   c0100957 <print_kerninfo>

    grade_backtrace();
c0100081:	e8 80 00 00 00       	call   c0100106 <grade_backtrace>

    pmm_init();                 // init physical memory management
c0100086:	e8 aa 31 00 00       	call   c0103235 <pmm_init>

    pic_init();                 // init interrupt controller
c010008b:	e8 91 17 00 00       	call   c0101821 <pic_init>
    idt_init();                 // init interrupt descriptor table
c0100090:	e8 33 19 00 00       	call   c01019c8 <idt_init>

    clock_init();               // init clock interrupt
c0100095:	e8 46 0d 00 00       	call   c0100de0 <clock_init>
    intr_enable();              // enable irq interrupt
c010009a:	e8 d1 18 00 00       	call   c0101970 <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
c010009f:	eb fe                	jmp    c010009f <kern_init+0x69>

c01000a1 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
c01000a1:	f3 0f 1e fb          	endbr32 
c01000a5:	55                   	push   %ebp
c01000a6:	89 e5                	mov    %esp,%ebp
c01000a8:	83 ec 08             	sub    $0x8,%esp
    mon_backtrace(0, NULL, NULL);
c01000ab:	83 ec 04             	sub    $0x4,%esp
c01000ae:	6a 00                	push   $0x0
c01000b0:	6a 00                	push   $0x0
c01000b2:	6a 00                	push   $0x0
c01000b4:	e8 11 0d 00 00       	call   c0100dca <mon_backtrace>
c01000b9:	83 c4 10             	add    $0x10,%esp
}
c01000bc:	90                   	nop
c01000bd:	c9                   	leave  
c01000be:	c3                   	ret    

c01000bf <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
c01000bf:	f3 0f 1e fb          	endbr32 
c01000c3:	55                   	push   %ebp
c01000c4:	89 e5                	mov    %esp,%ebp
c01000c6:	53                   	push   %ebx
c01000c7:	83 ec 04             	sub    $0x4,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
c01000ca:	8d 4d 0c             	lea    0xc(%ebp),%ecx
c01000cd:	8b 55 0c             	mov    0xc(%ebp),%edx
c01000d0:	8d 5d 08             	lea    0x8(%ebp),%ebx
c01000d3:	8b 45 08             	mov    0x8(%ebp),%eax
c01000d6:	51                   	push   %ecx
c01000d7:	52                   	push   %edx
c01000d8:	53                   	push   %ebx
c01000d9:	50                   	push   %eax
c01000da:	e8 c2 ff ff ff       	call   c01000a1 <grade_backtrace2>
c01000df:	83 c4 10             	add    $0x10,%esp
}
c01000e2:	90                   	nop
c01000e3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c01000e6:	c9                   	leave  
c01000e7:	c3                   	ret    

c01000e8 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
c01000e8:	f3 0f 1e fb          	endbr32 
c01000ec:	55                   	push   %ebp
c01000ed:	89 e5                	mov    %esp,%ebp
c01000ef:	83 ec 08             	sub    $0x8,%esp
    grade_backtrace1(arg0, arg2);
c01000f2:	83 ec 08             	sub    $0x8,%esp
c01000f5:	ff 75 10             	pushl  0x10(%ebp)
c01000f8:	ff 75 08             	pushl  0x8(%ebp)
c01000fb:	e8 bf ff ff ff       	call   c01000bf <grade_backtrace1>
c0100100:	83 c4 10             	add    $0x10,%esp
}
c0100103:	90                   	nop
c0100104:	c9                   	leave  
c0100105:	c3                   	ret    

c0100106 <grade_backtrace>:

void
grade_backtrace(void) {
c0100106:	f3 0f 1e fb          	endbr32 
c010010a:	55                   	push   %ebp
c010010b:	89 e5                	mov    %esp,%ebp
c010010d:	83 ec 08             	sub    $0x8,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
c0100110:	b8 36 00 10 c0       	mov    $0xc0100036,%eax
c0100115:	83 ec 04             	sub    $0x4,%esp
c0100118:	68 00 00 ff ff       	push   $0xffff0000
c010011d:	50                   	push   %eax
c010011e:	6a 00                	push   $0x0
c0100120:	e8 c3 ff ff ff       	call   c01000e8 <grade_backtrace0>
c0100125:	83 c4 10             	add    $0x10,%esp
}
c0100128:	90                   	nop
c0100129:	c9                   	leave  
c010012a:	c3                   	ret    

c010012b <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
c010012b:	f3 0f 1e fb          	endbr32 
c010012f:	55                   	push   %ebp
c0100130:	89 e5                	mov    %esp,%ebp
c0100132:	83 ec 18             	sub    $0x18,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
c0100135:	8c 4d f6             	mov    %cs,-0xa(%ebp)
c0100138:	8c 5d f4             	mov    %ds,-0xc(%ebp)
c010013b:	8c 45 f2             	mov    %es,-0xe(%ebp)
c010013e:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
c0100141:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100145:	0f b7 c0             	movzwl %ax,%eax
c0100148:	83 e0 03             	and    $0x3,%eax
c010014b:	89 c2                	mov    %eax,%edx
c010014d:	a1 00 c0 11 c0       	mov    0xc011c000,%eax
c0100152:	83 ec 04             	sub    $0x4,%esp
c0100155:	52                   	push   %edx
c0100156:	50                   	push   %eax
c0100157:	68 81 5c 10 c0       	push   $0xc0105c81
c010015c:	e8 3a 01 00 00       	call   c010029b <cprintf>
c0100161:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  cs = %x\n", round, reg1);
c0100164:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100168:	0f b7 d0             	movzwl %ax,%edx
c010016b:	a1 00 c0 11 c0       	mov    0xc011c000,%eax
c0100170:	83 ec 04             	sub    $0x4,%esp
c0100173:	52                   	push   %edx
c0100174:	50                   	push   %eax
c0100175:	68 8f 5c 10 c0       	push   $0xc0105c8f
c010017a:	e8 1c 01 00 00       	call   c010029b <cprintf>
c010017f:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ds = %x\n", round, reg2);
c0100182:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c0100186:	0f b7 d0             	movzwl %ax,%edx
c0100189:	a1 00 c0 11 c0       	mov    0xc011c000,%eax
c010018e:	83 ec 04             	sub    $0x4,%esp
c0100191:	52                   	push   %edx
c0100192:	50                   	push   %eax
c0100193:	68 9d 5c 10 c0       	push   $0xc0105c9d
c0100198:	e8 fe 00 00 00       	call   c010029b <cprintf>
c010019d:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  es = %x\n", round, reg3);
c01001a0:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001a4:	0f b7 d0             	movzwl %ax,%edx
c01001a7:	a1 00 c0 11 c0       	mov    0xc011c000,%eax
c01001ac:	83 ec 04             	sub    $0x4,%esp
c01001af:	52                   	push   %edx
c01001b0:	50                   	push   %eax
c01001b1:	68 ab 5c 10 c0       	push   $0xc0105cab
c01001b6:	e8 e0 00 00 00       	call   c010029b <cprintf>
c01001bb:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ss = %x\n", round, reg4);
c01001be:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001c2:	0f b7 d0             	movzwl %ax,%edx
c01001c5:	a1 00 c0 11 c0       	mov    0xc011c000,%eax
c01001ca:	83 ec 04             	sub    $0x4,%esp
c01001cd:	52                   	push   %edx
c01001ce:	50                   	push   %eax
c01001cf:	68 b9 5c 10 c0       	push   $0xc0105cb9
c01001d4:	e8 c2 00 00 00       	call   c010029b <cprintf>
c01001d9:	83 c4 10             	add    $0x10,%esp
    round ++;
c01001dc:	a1 00 c0 11 c0       	mov    0xc011c000,%eax
c01001e1:	83 c0 01             	add    $0x1,%eax
c01001e4:	a3 00 c0 11 c0       	mov    %eax,0xc011c000
}
c01001e9:	90                   	nop
c01001ea:	c9                   	leave  
c01001eb:	c3                   	ret    

c01001ec <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
c01001ec:	f3 0f 1e fb          	endbr32 
c01001f0:	55                   	push   %ebp
c01001f1:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
c01001f3:	90                   	nop
c01001f4:	5d                   	pop    %ebp
c01001f5:	c3                   	ret    

c01001f6 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
c01001f6:	f3 0f 1e fb          	endbr32 
c01001fa:	55                   	push   %ebp
c01001fb:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
c01001fd:	90                   	nop
c01001fe:	5d                   	pop    %ebp
c01001ff:	c3                   	ret    

c0100200 <lab1_switch_test>:

static void
lab1_switch_test(void) {
c0100200:	f3 0f 1e fb          	endbr32 
c0100204:	55                   	push   %ebp
c0100205:	89 e5                	mov    %esp,%ebp
c0100207:	83 ec 08             	sub    $0x8,%esp
    lab1_print_cur_status();
c010020a:	e8 1c ff ff ff       	call   c010012b <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
c010020f:	83 ec 0c             	sub    $0xc,%esp
c0100212:	68 c8 5c 10 c0       	push   $0xc0105cc8
c0100217:	e8 7f 00 00 00       	call   c010029b <cprintf>
c010021c:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_user();
c010021f:	e8 c8 ff ff ff       	call   c01001ec <lab1_switch_to_user>
    lab1_print_cur_status();
c0100224:	e8 02 ff ff ff       	call   c010012b <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c0100229:	83 ec 0c             	sub    $0xc,%esp
c010022c:	68 e8 5c 10 c0       	push   $0xc0105ce8
c0100231:	e8 65 00 00 00       	call   c010029b <cprintf>
c0100236:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_kernel();
c0100239:	e8 b8 ff ff ff       	call   c01001f6 <lab1_switch_to_kernel>
    lab1_print_cur_status();
c010023e:	e8 e8 fe ff ff       	call   c010012b <lab1_print_cur_status>
}
c0100243:	90                   	nop
c0100244:	c9                   	leave  
c0100245:	c3                   	ret    

c0100246 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
c0100246:	f3 0f 1e fb          	endbr32 
c010024a:	55                   	push   %ebp
c010024b:	89 e5                	mov    %esp,%ebp
c010024d:	83 ec 08             	sub    $0x8,%esp
    cons_putc(c);
c0100250:	83 ec 0c             	sub    $0xc,%esp
c0100253:	ff 75 08             	pushl  0x8(%ebp)
c0100256:	e8 73 14 00 00       	call   c01016ce <cons_putc>
c010025b:	83 c4 10             	add    $0x10,%esp
    (*cnt) ++;
c010025e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100261:	8b 00                	mov    (%eax),%eax
c0100263:	8d 50 01             	lea    0x1(%eax),%edx
c0100266:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100269:	89 10                	mov    %edx,(%eax)
}
c010026b:	90                   	nop
c010026c:	c9                   	leave  
c010026d:	c3                   	ret    

c010026e <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
c010026e:	f3 0f 1e fb          	endbr32 
c0100272:	55                   	push   %ebp
c0100273:	89 e5                	mov    %esp,%ebp
c0100275:	83 ec 18             	sub    $0x18,%esp
    int cnt = 0;
c0100278:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
c010027f:	ff 75 0c             	pushl  0xc(%ebp)
c0100282:	ff 75 08             	pushl  0x8(%ebp)
c0100285:	8d 45 f4             	lea    -0xc(%ebp),%eax
c0100288:	50                   	push   %eax
c0100289:	68 46 02 10 c0       	push   $0xc0100246
c010028e:	e8 5b 55 00 00       	call   c01057ee <vprintfmt>
c0100293:	83 c4 10             	add    $0x10,%esp
    return cnt;
c0100296:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100299:	c9                   	leave  
c010029a:	c3                   	ret    

c010029b <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
c010029b:	f3 0f 1e fb          	endbr32 
c010029f:	55                   	push   %ebp
c01002a0:	89 e5                	mov    %esp,%ebp
c01002a2:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c01002a5:	8d 45 0c             	lea    0xc(%ebp),%eax
c01002a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
c01002ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002ae:	83 ec 08             	sub    $0x8,%esp
c01002b1:	50                   	push   %eax
c01002b2:	ff 75 08             	pushl  0x8(%ebp)
c01002b5:	e8 b4 ff ff ff       	call   c010026e <vcprintf>
c01002ba:	83 c4 10             	add    $0x10,%esp
c01002bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c01002c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01002c3:	c9                   	leave  
c01002c4:	c3                   	ret    

c01002c5 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
c01002c5:	f3 0f 1e fb          	endbr32 
c01002c9:	55                   	push   %ebp
c01002ca:	89 e5                	mov    %esp,%ebp
c01002cc:	83 ec 08             	sub    $0x8,%esp
    cons_putc(c);
c01002cf:	83 ec 0c             	sub    $0xc,%esp
c01002d2:	ff 75 08             	pushl  0x8(%ebp)
c01002d5:	e8 f4 13 00 00       	call   c01016ce <cons_putc>
c01002da:	83 c4 10             	add    $0x10,%esp
}
c01002dd:	90                   	nop
c01002de:	c9                   	leave  
c01002df:	c3                   	ret    

c01002e0 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
c01002e0:	f3 0f 1e fb          	endbr32 
c01002e4:	55                   	push   %ebp
c01002e5:	89 e5                	mov    %esp,%ebp
c01002e7:	83 ec 18             	sub    $0x18,%esp
    int cnt = 0;
c01002ea:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
c01002f1:	eb 14                	jmp    c0100307 <cputs+0x27>
        cputch(c, &cnt);
c01002f3:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c01002f7:	83 ec 08             	sub    $0x8,%esp
c01002fa:	8d 55 f0             	lea    -0x10(%ebp),%edx
c01002fd:	52                   	push   %edx
c01002fe:	50                   	push   %eax
c01002ff:	e8 42 ff ff ff       	call   c0100246 <cputch>
c0100304:	83 c4 10             	add    $0x10,%esp
    while ((c = *str ++) != '\0') {
c0100307:	8b 45 08             	mov    0x8(%ebp),%eax
c010030a:	8d 50 01             	lea    0x1(%eax),%edx
c010030d:	89 55 08             	mov    %edx,0x8(%ebp)
c0100310:	0f b6 00             	movzbl (%eax),%eax
c0100313:	88 45 f7             	mov    %al,-0x9(%ebp)
c0100316:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
c010031a:	75 d7                	jne    c01002f3 <cputs+0x13>
    }
    cputch('\n', &cnt);
c010031c:	83 ec 08             	sub    $0x8,%esp
c010031f:	8d 45 f0             	lea    -0x10(%ebp),%eax
c0100322:	50                   	push   %eax
c0100323:	6a 0a                	push   $0xa
c0100325:	e8 1c ff ff ff       	call   c0100246 <cputch>
c010032a:	83 c4 10             	add    $0x10,%esp
    return cnt;
c010032d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0100330:	c9                   	leave  
c0100331:	c3                   	ret    

c0100332 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
c0100332:	f3 0f 1e fb          	endbr32 
c0100336:	55                   	push   %ebp
c0100337:	89 e5                	mov    %esp,%ebp
c0100339:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
c010033c:	90                   	nop
c010033d:	e8 d9 13 00 00       	call   c010171b <cons_getc>
c0100342:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100345:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100349:	74 f2                	je     c010033d <getchar+0xb>
        /* do nothing */;
    return c;
c010034b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010034e:	c9                   	leave  
c010034f:	c3                   	ret    

c0100350 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
c0100350:	f3 0f 1e fb          	endbr32 
c0100354:	55                   	push   %ebp
c0100355:	89 e5                	mov    %esp,%ebp
c0100357:	83 ec 18             	sub    $0x18,%esp
    if (prompt != NULL) {
c010035a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010035e:	74 13                	je     c0100373 <readline+0x23>
        cprintf("%s", prompt);
c0100360:	83 ec 08             	sub    $0x8,%esp
c0100363:	ff 75 08             	pushl  0x8(%ebp)
c0100366:	68 07 5d 10 c0       	push   $0xc0105d07
c010036b:	e8 2b ff ff ff       	call   c010029b <cprintf>
c0100370:	83 c4 10             	add    $0x10,%esp
    }
    int i = 0, c;
c0100373:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
c010037a:	e8 b3 ff ff ff       	call   c0100332 <getchar>
c010037f:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
c0100382:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100386:	79 0a                	jns    c0100392 <readline+0x42>
            return NULL;
c0100388:	b8 00 00 00 00       	mov    $0x0,%eax
c010038d:	e9 82 00 00 00       	jmp    c0100414 <readline+0xc4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
c0100392:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
c0100396:	7e 2b                	jle    c01003c3 <readline+0x73>
c0100398:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
c010039f:	7f 22                	jg     c01003c3 <readline+0x73>
            cputchar(c);
c01003a1:	83 ec 0c             	sub    $0xc,%esp
c01003a4:	ff 75 f0             	pushl  -0x10(%ebp)
c01003a7:	e8 19 ff ff ff       	call   c01002c5 <cputchar>
c01003ac:	83 c4 10             	add    $0x10,%esp
            buf[i ++] = c;
c01003af:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01003b2:	8d 50 01             	lea    0x1(%eax),%edx
c01003b5:	89 55 f4             	mov    %edx,-0xc(%ebp)
c01003b8:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01003bb:	88 90 20 c0 11 c0    	mov    %dl,-0x3fee3fe0(%eax)
c01003c1:	eb 4c                	jmp    c010040f <readline+0xbf>
        }
        else if (c == '\b' && i > 0) {
c01003c3:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
c01003c7:	75 1a                	jne    c01003e3 <readline+0x93>
c01003c9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01003cd:	7e 14                	jle    c01003e3 <readline+0x93>
            cputchar(c);
c01003cf:	83 ec 0c             	sub    $0xc,%esp
c01003d2:	ff 75 f0             	pushl  -0x10(%ebp)
c01003d5:	e8 eb fe ff ff       	call   c01002c5 <cputchar>
c01003da:	83 c4 10             	add    $0x10,%esp
            i --;
c01003dd:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01003e1:	eb 2c                	jmp    c010040f <readline+0xbf>
        }
        else if (c == '\n' || c == '\r') {
c01003e3:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
c01003e7:	74 06                	je     c01003ef <readline+0x9f>
c01003e9:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
c01003ed:	75 8b                	jne    c010037a <readline+0x2a>
            cputchar(c);
c01003ef:	83 ec 0c             	sub    $0xc,%esp
c01003f2:	ff 75 f0             	pushl  -0x10(%ebp)
c01003f5:	e8 cb fe ff ff       	call   c01002c5 <cputchar>
c01003fa:	83 c4 10             	add    $0x10,%esp
            buf[i] = '\0';
c01003fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100400:	05 20 c0 11 c0       	add    $0xc011c020,%eax
c0100405:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c0100408:	b8 20 c0 11 c0       	mov    $0xc011c020,%eax
c010040d:	eb 05                	jmp    c0100414 <readline+0xc4>
        c = getchar();
c010040f:	e9 66 ff ff ff       	jmp    c010037a <readline+0x2a>
        }
    }
}
c0100414:	c9                   	leave  
c0100415:	c3                   	ret    

c0100416 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c0100416:	f3 0f 1e fb          	endbr32 
c010041a:	55                   	push   %ebp
c010041b:	89 e5                	mov    %esp,%ebp
c010041d:	83 ec 18             	sub    $0x18,%esp
    if (is_panic) {
c0100420:	a1 20 c4 11 c0       	mov    0xc011c420,%eax
c0100425:	85 c0                	test   %eax,%eax
c0100427:	75 5f                	jne    c0100488 <__panic+0x72>
        goto panic_dead;
    }
    is_panic = 1;
c0100429:	c7 05 20 c4 11 c0 01 	movl   $0x1,0xc011c420
c0100430:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c0100433:	8d 45 14             	lea    0x14(%ebp),%eax
c0100436:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c0100439:	83 ec 04             	sub    $0x4,%esp
c010043c:	ff 75 0c             	pushl  0xc(%ebp)
c010043f:	ff 75 08             	pushl  0x8(%ebp)
c0100442:	68 0a 5d 10 c0       	push   $0xc0105d0a
c0100447:	e8 4f fe ff ff       	call   c010029b <cprintf>
c010044c:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
c010044f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100452:	83 ec 08             	sub    $0x8,%esp
c0100455:	50                   	push   %eax
c0100456:	ff 75 10             	pushl  0x10(%ebp)
c0100459:	e8 10 fe ff ff       	call   c010026e <vcprintf>
c010045e:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
c0100461:	83 ec 0c             	sub    $0xc,%esp
c0100464:	68 26 5d 10 c0       	push   $0xc0105d26
c0100469:	e8 2d fe ff ff       	call   c010029b <cprintf>
c010046e:	83 c4 10             	add    $0x10,%esp
    
    cprintf("stack trackback:\n");
c0100471:	83 ec 0c             	sub    $0xc,%esp
c0100474:	68 28 5d 10 c0       	push   $0xc0105d28
c0100479:	e8 1d fe ff ff       	call   c010029b <cprintf>
c010047e:	83 c4 10             	add    $0x10,%esp
    print_stackframe();
c0100481:	e8 25 06 00 00       	call   c0100aab <print_stackframe>
c0100486:	eb 01                	jmp    c0100489 <__panic+0x73>
        goto panic_dead;
c0100488:	90                   	nop
    
    va_end(ap);

panic_dead:
    intr_disable();
c0100489:	e8 ee 14 00 00       	call   c010197c <intr_disable>
    while (1) {
        kmonitor(NULL);
c010048e:	83 ec 0c             	sub    $0xc,%esp
c0100491:	6a 00                	push   $0x0
c0100493:	e8 4c 08 00 00       	call   c0100ce4 <kmonitor>
c0100498:	83 c4 10             	add    $0x10,%esp
c010049b:	eb f1                	jmp    c010048e <__panic+0x78>

c010049d <__warn>:
    }
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c010049d:	f3 0f 1e fb          	endbr32 
c01004a1:	55                   	push   %ebp
c01004a2:	89 e5                	mov    %esp,%ebp
c01004a4:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    va_start(ap, fmt);
c01004a7:	8d 45 14             	lea    0x14(%ebp),%eax
c01004aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c01004ad:	83 ec 04             	sub    $0x4,%esp
c01004b0:	ff 75 0c             	pushl  0xc(%ebp)
c01004b3:	ff 75 08             	pushl  0x8(%ebp)
c01004b6:	68 3a 5d 10 c0       	push   $0xc0105d3a
c01004bb:	e8 db fd ff ff       	call   c010029b <cprintf>
c01004c0:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
c01004c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01004c6:	83 ec 08             	sub    $0x8,%esp
c01004c9:	50                   	push   %eax
c01004ca:	ff 75 10             	pushl  0x10(%ebp)
c01004cd:	e8 9c fd ff ff       	call   c010026e <vcprintf>
c01004d2:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
c01004d5:	83 ec 0c             	sub    $0xc,%esp
c01004d8:	68 26 5d 10 c0       	push   $0xc0105d26
c01004dd:	e8 b9 fd ff ff       	call   c010029b <cprintf>
c01004e2:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
c01004e5:	90                   	nop
c01004e6:	c9                   	leave  
c01004e7:	c3                   	ret    

c01004e8 <is_kernel_panic>:

bool
is_kernel_panic(void) {
c01004e8:	f3 0f 1e fb          	endbr32 
c01004ec:	55                   	push   %ebp
c01004ed:	89 e5                	mov    %esp,%ebp
    return is_panic;
c01004ef:	a1 20 c4 11 c0       	mov    0xc011c420,%eax
}
c01004f4:	5d                   	pop    %ebp
c01004f5:	c3                   	ret    

c01004f6 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
c01004f6:	f3 0f 1e fb          	endbr32 
c01004fa:	55                   	push   %ebp
c01004fb:	89 e5                	mov    %esp,%ebp
c01004fd:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
c0100500:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100503:	8b 00                	mov    (%eax),%eax
c0100505:	89 45 fc             	mov    %eax,-0x4(%ebp)
c0100508:	8b 45 10             	mov    0x10(%ebp),%eax
c010050b:	8b 00                	mov    (%eax),%eax
c010050d:	89 45 f8             	mov    %eax,-0x8(%ebp)
c0100510:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
c0100517:	e9 d2 00 00 00       	jmp    c01005ee <stab_binsearch+0xf8>
        int true_m = (l + r) / 2, m = true_m;
c010051c:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010051f:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0100522:	01 d0                	add    %edx,%eax
c0100524:	89 c2                	mov    %eax,%edx
c0100526:	c1 ea 1f             	shr    $0x1f,%edx
c0100529:	01 d0                	add    %edx,%eax
c010052b:	d1 f8                	sar    %eax
c010052d:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0100530:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100533:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c0100536:	eb 04                	jmp    c010053c <stab_binsearch+0x46>
            m --;
c0100538:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
        while (m >= l && stabs[m].n_type != type) {
c010053c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010053f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100542:	7c 1f                	jl     c0100563 <stab_binsearch+0x6d>
c0100544:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100547:	89 d0                	mov    %edx,%eax
c0100549:	01 c0                	add    %eax,%eax
c010054b:	01 d0                	add    %edx,%eax
c010054d:	c1 e0 02             	shl    $0x2,%eax
c0100550:	89 c2                	mov    %eax,%edx
c0100552:	8b 45 08             	mov    0x8(%ebp),%eax
c0100555:	01 d0                	add    %edx,%eax
c0100557:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010055b:	0f b6 c0             	movzbl %al,%eax
c010055e:	39 45 14             	cmp    %eax,0x14(%ebp)
c0100561:	75 d5                	jne    c0100538 <stab_binsearch+0x42>
        }
        if (m < l) {    // no match in [l, m]
c0100563:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100566:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100569:	7d 0b                	jge    c0100576 <stab_binsearch+0x80>
            l = true_m + 1;
c010056b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010056e:	83 c0 01             	add    $0x1,%eax
c0100571:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
c0100574:	eb 78                	jmp    c01005ee <stab_binsearch+0xf8>
        }

        // actual binary search
        any_matches = 1;
c0100576:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
c010057d:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100580:	89 d0                	mov    %edx,%eax
c0100582:	01 c0                	add    %eax,%eax
c0100584:	01 d0                	add    %edx,%eax
c0100586:	c1 e0 02             	shl    $0x2,%eax
c0100589:	89 c2                	mov    %eax,%edx
c010058b:	8b 45 08             	mov    0x8(%ebp),%eax
c010058e:	01 d0                	add    %edx,%eax
c0100590:	8b 40 08             	mov    0x8(%eax),%eax
c0100593:	39 45 18             	cmp    %eax,0x18(%ebp)
c0100596:	76 13                	jbe    c01005ab <stab_binsearch+0xb5>
            *region_left = m;
c0100598:	8b 45 0c             	mov    0xc(%ebp),%eax
c010059b:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010059e:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
c01005a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01005a3:	83 c0 01             	add    $0x1,%eax
c01005a6:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01005a9:	eb 43                	jmp    c01005ee <stab_binsearch+0xf8>
        } else if (stabs[m].n_value > addr) {
c01005ab:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01005ae:	89 d0                	mov    %edx,%eax
c01005b0:	01 c0                	add    %eax,%eax
c01005b2:	01 d0                	add    %edx,%eax
c01005b4:	c1 e0 02             	shl    $0x2,%eax
c01005b7:	89 c2                	mov    %eax,%edx
c01005b9:	8b 45 08             	mov    0x8(%ebp),%eax
c01005bc:	01 d0                	add    %edx,%eax
c01005be:	8b 40 08             	mov    0x8(%eax),%eax
c01005c1:	39 45 18             	cmp    %eax,0x18(%ebp)
c01005c4:	73 16                	jae    c01005dc <stab_binsearch+0xe6>
            *region_right = m - 1;
c01005c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01005c9:	8d 50 ff             	lea    -0x1(%eax),%edx
c01005cc:	8b 45 10             	mov    0x10(%ebp),%eax
c01005cf:	89 10                	mov    %edx,(%eax)
            r = m - 1;
c01005d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01005d4:	83 e8 01             	sub    $0x1,%eax
c01005d7:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01005da:	eb 12                	jmp    c01005ee <stab_binsearch+0xf8>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
c01005dc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005df:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01005e2:	89 10                	mov    %edx,(%eax)
            l = m;
c01005e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01005e7:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
c01005ea:	83 45 18 01          	addl   $0x1,0x18(%ebp)
    while (l <= r) {
c01005ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01005f1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c01005f4:	0f 8e 22 ff ff ff    	jle    c010051c <stab_binsearch+0x26>
        }
    }

    if (!any_matches) {
c01005fa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01005fe:	75 0f                	jne    c010060f <stab_binsearch+0x119>
        *region_right = *region_left - 1;
c0100600:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100603:	8b 00                	mov    (%eax),%eax
c0100605:	8d 50 ff             	lea    -0x1(%eax),%edx
c0100608:	8b 45 10             	mov    0x10(%ebp),%eax
c010060b:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
c010060d:	eb 3f                	jmp    c010064e <stab_binsearch+0x158>
        l = *region_right;
c010060f:	8b 45 10             	mov    0x10(%ebp),%eax
c0100612:	8b 00                	mov    (%eax),%eax
c0100614:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
c0100617:	eb 04                	jmp    c010061d <stab_binsearch+0x127>
c0100619:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
c010061d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100620:	8b 00                	mov    (%eax),%eax
c0100622:	39 45 fc             	cmp    %eax,-0x4(%ebp)
c0100625:	7e 1f                	jle    c0100646 <stab_binsearch+0x150>
c0100627:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010062a:	89 d0                	mov    %edx,%eax
c010062c:	01 c0                	add    %eax,%eax
c010062e:	01 d0                	add    %edx,%eax
c0100630:	c1 e0 02             	shl    $0x2,%eax
c0100633:	89 c2                	mov    %eax,%edx
c0100635:	8b 45 08             	mov    0x8(%ebp),%eax
c0100638:	01 d0                	add    %edx,%eax
c010063a:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010063e:	0f b6 c0             	movzbl %al,%eax
c0100641:	39 45 14             	cmp    %eax,0x14(%ebp)
c0100644:	75 d3                	jne    c0100619 <stab_binsearch+0x123>
        *region_left = l;
c0100646:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100649:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010064c:	89 10                	mov    %edx,(%eax)
}
c010064e:	90                   	nop
c010064f:	c9                   	leave  
c0100650:	c3                   	ret    

c0100651 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
c0100651:	f3 0f 1e fb          	endbr32 
c0100655:	55                   	push   %ebp
c0100656:	89 e5                	mov    %esp,%ebp
c0100658:	83 ec 38             	sub    $0x38,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
c010065b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010065e:	c7 00 58 5d 10 c0    	movl   $0xc0105d58,(%eax)
    info->eip_line = 0;
c0100664:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100667:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c010066e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100671:	c7 40 08 58 5d 10 c0 	movl   $0xc0105d58,0x8(%eax)
    info->eip_fn_namelen = 9;
c0100678:	8b 45 0c             	mov    0xc(%ebp),%eax
c010067b:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
c0100682:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100685:	8b 55 08             	mov    0x8(%ebp),%edx
c0100688:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
c010068b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010068e:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
c0100695:	c7 45 f4 a0 6f 10 c0 	movl   $0xc0106fa0,-0xc(%ebp)
    stab_end = __STAB_END__;
c010069c:	c7 45 f0 e8 38 11 c0 	movl   $0xc01138e8,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c01006a3:	c7 45 ec e9 38 11 c0 	movl   $0xc01138e9,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c01006aa:	c7 45 e8 02 64 11 c0 	movl   $0xc0116402,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c01006b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01006b4:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01006b7:	76 0d                	jbe    c01006c6 <debuginfo_eip+0x75>
c01006b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01006bc:	83 e8 01             	sub    $0x1,%eax
c01006bf:	0f b6 00             	movzbl (%eax),%eax
c01006c2:	84 c0                	test   %al,%al
c01006c4:	74 0a                	je     c01006d0 <debuginfo_eip+0x7f>
        return -1;
c01006c6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01006cb:	e9 85 02 00 00       	jmp    c0100955 <debuginfo_eip+0x304>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c01006d0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c01006d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01006da:	2b 45 f4             	sub    -0xc(%ebp),%eax
c01006dd:	c1 f8 02             	sar    $0x2,%eax
c01006e0:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c01006e6:	83 e8 01             	sub    $0x1,%eax
c01006e9:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c01006ec:	ff 75 08             	pushl  0x8(%ebp)
c01006ef:	6a 64                	push   $0x64
c01006f1:	8d 45 e0             	lea    -0x20(%ebp),%eax
c01006f4:	50                   	push   %eax
c01006f5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
c01006f8:	50                   	push   %eax
c01006f9:	ff 75 f4             	pushl  -0xc(%ebp)
c01006fc:	e8 f5 fd ff ff       	call   c01004f6 <stab_binsearch>
c0100701:	83 c4 14             	add    $0x14,%esp
    if (lfile == 0)
c0100704:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100707:	85 c0                	test   %eax,%eax
c0100709:	75 0a                	jne    c0100715 <debuginfo_eip+0xc4>
        return -1;
c010070b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100710:	e9 40 02 00 00       	jmp    c0100955 <debuginfo_eip+0x304>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c0100715:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100718:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010071b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010071e:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c0100721:	ff 75 08             	pushl  0x8(%ebp)
c0100724:	6a 24                	push   $0x24
c0100726:	8d 45 d8             	lea    -0x28(%ebp),%eax
c0100729:	50                   	push   %eax
c010072a:	8d 45 dc             	lea    -0x24(%ebp),%eax
c010072d:	50                   	push   %eax
c010072e:	ff 75 f4             	pushl  -0xc(%ebp)
c0100731:	e8 c0 fd ff ff       	call   c01004f6 <stab_binsearch>
c0100736:	83 c4 14             	add    $0x14,%esp

    if (lfun <= rfun) {
c0100739:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010073c:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010073f:	39 c2                	cmp    %eax,%edx
c0100741:	7f 78                	jg     c01007bb <debuginfo_eip+0x16a>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c0100743:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100746:	89 c2                	mov    %eax,%edx
c0100748:	89 d0                	mov    %edx,%eax
c010074a:	01 c0                	add    %eax,%eax
c010074c:	01 d0                	add    %edx,%eax
c010074e:	c1 e0 02             	shl    $0x2,%eax
c0100751:	89 c2                	mov    %eax,%edx
c0100753:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100756:	01 d0                	add    %edx,%eax
c0100758:	8b 10                	mov    (%eax),%edx
c010075a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010075d:	2b 45 ec             	sub    -0x14(%ebp),%eax
c0100760:	39 c2                	cmp    %eax,%edx
c0100762:	73 22                	jae    c0100786 <debuginfo_eip+0x135>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c0100764:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100767:	89 c2                	mov    %eax,%edx
c0100769:	89 d0                	mov    %edx,%eax
c010076b:	01 c0                	add    %eax,%eax
c010076d:	01 d0                	add    %edx,%eax
c010076f:	c1 e0 02             	shl    $0x2,%eax
c0100772:	89 c2                	mov    %eax,%edx
c0100774:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100777:	01 d0                	add    %edx,%eax
c0100779:	8b 10                	mov    (%eax),%edx
c010077b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010077e:	01 c2                	add    %eax,%edx
c0100780:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100783:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c0100786:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100789:	89 c2                	mov    %eax,%edx
c010078b:	89 d0                	mov    %edx,%eax
c010078d:	01 c0                	add    %eax,%eax
c010078f:	01 d0                	add    %edx,%eax
c0100791:	c1 e0 02             	shl    $0x2,%eax
c0100794:	89 c2                	mov    %eax,%edx
c0100796:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100799:	01 d0                	add    %edx,%eax
c010079b:	8b 50 08             	mov    0x8(%eax),%edx
c010079e:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007a1:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c01007a4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007a7:	8b 40 10             	mov    0x10(%eax),%eax
c01007aa:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c01007ad:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01007b0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
c01007b3:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01007b6:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01007b9:	eb 15                	jmp    c01007d0 <debuginfo_eip+0x17f>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c01007bb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007be:	8b 55 08             	mov    0x8(%ebp),%edx
c01007c1:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c01007c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01007c7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
c01007ca:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01007cd:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c01007d0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007d3:	8b 40 08             	mov    0x8(%eax),%eax
c01007d6:	83 ec 08             	sub    $0x8,%esp
c01007d9:	6a 3a                	push   $0x3a
c01007db:	50                   	push   %eax
c01007dc:	e8 2a 4b 00 00       	call   c010530b <strfind>
c01007e1:	83 c4 10             	add    $0x10,%esp
c01007e4:	8b 55 0c             	mov    0xc(%ebp),%edx
c01007e7:	8b 52 08             	mov    0x8(%edx),%edx
c01007ea:	29 d0                	sub    %edx,%eax
c01007ec:	89 c2                	mov    %eax,%edx
c01007ee:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007f1:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c01007f4:	83 ec 0c             	sub    $0xc,%esp
c01007f7:	ff 75 08             	pushl  0x8(%ebp)
c01007fa:	6a 44                	push   $0x44
c01007fc:	8d 45 d0             	lea    -0x30(%ebp),%eax
c01007ff:	50                   	push   %eax
c0100800:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c0100803:	50                   	push   %eax
c0100804:	ff 75 f4             	pushl  -0xc(%ebp)
c0100807:	e8 ea fc ff ff       	call   c01004f6 <stab_binsearch>
c010080c:	83 c4 20             	add    $0x20,%esp
    if (lline <= rline) {
c010080f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100812:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100815:	39 c2                	cmp    %eax,%edx
c0100817:	7f 24                	jg     c010083d <debuginfo_eip+0x1ec>
        info->eip_line = stabs[rline].n_desc;
c0100819:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010081c:	89 c2                	mov    %eax,%edx
c010081e:	89 d0                	mov    %edx,%eax
c0100820:	01 c0                	add    %eax,%eax
c0100822:	01 d0                	add    %edx,%eax
c0100824:	c1 e0 02             	shl    $0x2,%eax
c0100827:	89 c2                	mov    %eax,%edx
c0100829:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010082c:	01 d0                	add    %edx,%eax
c010082e:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c0100832:	0f b7 d0             	movzwl %ax,%edx
c0100835:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100838:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c010083b:	eb 13                	jmp    c0100850 <debuginfo_eip+0x1ff>
        return -1;
c010083d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100842:	e9 0e 01 00 00       	jmp    c0100955 <debuginfo_eip+0x304>
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c0100847:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010084a:	83 e8 01             	sub    $0x1,%eax
c010084d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile
c0100850:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100853:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100856:	39 c2                	cmp    %eax,%edx
c0100858:	7c 56                	jl     c01008b0 <debuginfo_eip+0x25f>
           && stabs[lline].n_type != N_SOL
c010085a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010085d:	89 c2                	mov    %eax,%edx
c010085f:	89 d0                	mov    %edx,%eax
c0100861:	01 c0                	add    %eax,%eax
c0100863:	01 d0                	add    %edx,%eax
c0100865:	c1 e0 02             	shl    $0x2,%eax
c0100868:	89 c2                	mov    %eax,%edx
c010086a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010086d:	01 d0                	add    %edx,%eax
c010086f:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100873:	3c 84                	cmp    $0x84,%al
c0100875:	74 39                	je     c01008b0 <debuginfo_eip+0x25f>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c0100877:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010087a:	89 c2                	mov    %eax,%edx
c010087c:	89 d0                	mov    %edx,%eax
c010087e:	01 c0                	add    %eax,%eax
c0100880:	01 d0                	add    %edx,%eax
c0100882:	c1 e0 02             	shl    $0x2,%eax
c0100885:	89 c2                	mov    %eax,%edx
c0100887:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010088a:	01 d0                	add    %edx,%eax
c010088c:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100890:	3c 64                	cmp    $0x64,%al
c0100892:	75 b3                	jne    c0100847 <debuginfo_eip+0x1f6>
c0100894:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100897:	89 c2                	mov    %eax,%edx
c0100899:	89 d0                	mov    %edx,%eax
c010089b:	01 c0                	add    %eax,%eax
c010089d:	01 d0                	add    %edx,%eax
c010089f:	c1 e0 02             	shl    $0x2,%eax
c01008a2:	89 c2                	mov    %eax,%edx
c01008a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01008a7:	01 d0                	add    %edx,%eax
c01008a9:	8b 40 08             	mov    0x8(%eax),%eax
c01008ac:	85 c0                	test   %eax,%eax
c01008ae:	74 97                	je     c0100847 <debuginfo_eip+0x1f6>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c01008b0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01008b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01008b6:	39 c2                	cmp    %eax,%edx
c01008b8:	7c 42                	jl     c01008fc <debuginfo_eip+0x2ab>
c01008ba:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01008bd:	89 c2                	mov    %eax,%edx
c01008bf:	89 d0                	mov    %edx,%eax
c01008c1:	01 c0                	add    %eax,%eax
c01008c3:	01 d0                	add    %edx,%eax
c01008c5:	c1 e0 02             	shl    $0x2,%eax
c01008c8:	89 c2                	mov    %eax,%edx
c01008ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01008cd:	01 d0                	add    %edx,%eax
c01008cf:	8b 10                	mov    (%eax),%edx
c01008d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01008d4:	2b 45 ec             	sub    -0x14(%ebp),%eax
c01008d7:	39 c2                	cmp    %eax,%edx
c01008d9:	73 21                	jae    c01008fc <debuginfo_eip+0x2ab>
        info->eip_file = stabstr + stabs[lline].n_strx;
c01008db:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01008de:	89 c2                	mov    %eax,%edx
c01008e0:	89 d0                	mov    %edx,%eax
c01008e2:	01 c0                	add    %eax,%eax
c01008e4:	01 d0                	add    %edx,%eax
c01008e6:	c1 e0 02             	shl    $0x2,%eax
c01008e9:	89 c2                	mov    %eax,%edx
c01008eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01008ee:	01 d0                	add    %edx,%eax
c01008f0:	8b 10                	mov    (%eax),%edx
c01008f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01008f5:	01 c2                	add    %eax,%edx
c01008f7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01008fa:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c01008fc:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01008ff:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100902:	39 c2                	cmp    %eax,%edx
c0100904:	7d 4a                	jge    c0100950 <debuginfo_eip+0x2ff>
        for (lline = lfun + 1;
c0100906:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100909:	83 c0 01             	add    $0x1,%eax
c010090c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c010090f:	eb 18                	jmp    c0100929 <debuginfo_eip+0x2d8>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c0100911:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100914:	8b 40 14             	mov    0x14(%eax),%eax
c0100917:	8d 50 01             	lea    0x1(%eax),%edx
c010091a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010091d:	89 50 14             	mov    %edx,0x14(%eax)
             lline ++) {
c0100920:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100923:	83 c0 01             	add    $0x1,%eax
c0100926:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100929:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010092c:	8b 45 d8             	mov    -0x28(%ebp),%eax
        for (lline = lfun + 1;
c010092f:	39 c2                	cmp    %eax,%edx
c0100931:	7d 1d                	jge    c0100950 <debuginfo_eip+0x2ff>
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100933:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100936:	89 c2                	mov    %eax,%edx
c0100938:	89 d0                	mov    %edx,%eax
c010093a:	01 c0                	add    %eax,%eax
c010093c:	01 d0                	add    %edx,%eax
c010093e:	c1 e0 02             	shl    $0x2,%eax
c0100941:	89 c2                	mov    %eax,%edx
c0100943:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100946:	01 d0                	add    %edx,%eax
c0100948:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010094c:	3c a0                	cmp    $0xa0,%al
c010094e:	74 c1                	je     c0100911 <debuginfo_eip+0x2c0>
        }
    }
    return 0;
c0100950:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100955:	c9                   	leave  
c0100956:	c3                   	ret    

c0100957 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c0100957:	f3 0f 1e fb          	endbr32 
c010095b:	55                   	push   %ebp
c010095c:	89 e5                	mov    %esp,%ebp
c010095e:	83 ec 08             	sub    $0x8,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c0100961:	83 ec 0c             	sub    $0xc,%esp
c0100964:	68 62 5d 10 c0       	push   $0xc0105d62
c0100969:	e8 2d f9 ff ff       	call   c010029b <cprintf>
c010096e:	83 c4 10             	add    $0x10,%esp
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c0100971:	83 ec 08             	sub    $0x8,%esp
c0100974:	68 36 00 10 c0       	push   $0xc0100036
c0100979:	68 7b 5d 10 c0       	push   $0xc0105d7b
c010097e:	e8 18 f9 ff ff       	call   c010029b <cprintf>
c0100983:	83 c4 10             	add    $0x10,%esp
    cprintf("  etext  0x%08x (phys)\n", etext);
c0100986:	83 ec 08             	sub    $0x8,%esp
c0100989:	68 60 5c 10 c0       	push   $0xc0105c60
c010098e:	68 93 5d 10 c0       	push   $0xc0105d93
c0100993:	e8 03 f9 ff ff       	call   c010029b <cprintf>
c0100998:	83 c4 10             	add    $0x10,%esp
    cprintf("  edata  0x%08x (phys)\n", edata);
c010099b:	83 ec 08             	sub    $0x8,%esp
c010099e:	68 00 c0 11 c0       	push   $0xc011c000
c01009a3:	68 ab 5d 10 c0       	push   $0xc0105dab
c01009a8:	e8 ee f8 ff ff       	call   c010029b <cprintf>
c01009ad:	83 c4 10             	add    $0x10,%esp
    cprintf("  end    0x%08x (phys)\n", end);
c01009b0:	83 ec 08             	sub    $0x8,%esp
c01009b3:	68 28 cf 11 c0       	push   $0xc011cf28
c01009b8:	68 c3 5d 10 c0       	push   $0xc0105dc3
c01009bd:	e8 d9 f8 ff ff       	call   c010029b <cprintf>
c01009c2:	83 c4 10             	add    $0x10,%esp
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c01009c5:	b8 28 cf 11 c0       	mov    $0xc011cf28,%eax
c01009ca:	2d 36 00 10 c0       	sub    $0xc0100036,%eax
c01009cf:	05 ff 03 00 00       	add    $0x3ff,%eax
c01009d4:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01009da:	85 c0                	test   %eax,%eax
c01009dc:	0f 48 c2             	cmovs  %edx,%eax
c01009df:	c1 f8 0a             	sar    $0xa,%eax
c01009e2:	83 ec 08             	sub    $0x8,%esp
c01009e5:	50                   	push   %eax
c01009e6:	68 dc 5d 10 c0       	push   $0xc0105ddc
c01009eb:	e8 ab f8 ff ff       	call   c010029b <cprintf>
c01009f0:	83 c4 10             	add    $0x10,%esp
}
c01009f3:	90                   	nop
c01009f4:	c9                   	leave  
c01009f5:	c3                   	ret    

c01009f6 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c01009f6:	f3 0f 1e fb          	endbr32 
c01009fa:	55                   	push   %ebp
c01009fb:	89 e5                	mov    %esp,%ebp
c01009fd:	81 ec 28 01 00 00    	sub    $0x128,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c0100a03:	83 ec 08             	sub    $0x8,%esp
c0100a06:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100a09:	50                   	push   %eax
c0100a0a:	ff 75 08             	pushl  0x8(%ebp)
c0100a0d:	e8 3f fc ff ff       	call   c0100651 <debuginfo_eip>
c0100a12:	83 c4 10             	add    $0x10,%esp
c0100a15:	85 c0                	test   %eax,%eax
c0100a17:	74 15                	je     c0100a2e <print_debuginfo+0x38>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c0100a19:	83 ec 08             	sub    $0x8,%esp
c0100a1c:	ff 75 08             	pushl  0x8(%ebp)
c0100a1f:	68 06 5e 10 c0       	push   $0xc0105e06
c0100a24:	e8 72 f8 ff ff       	call   c010029b <cprintf>
c0100a29:	83 c4 10             	add    $0x10,%esp
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
c0100a2c:	eb 65                	jmp    c0100a93 <print_debuginfo+0x9d>
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100a2e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100a35:	eb 1c                	jmp    c0100a53 <print_debuginfo+0x5d>
            fnname[j] = info.eip_fn_name[j];
c0100a37:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0100a3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a3d:	01 d0                	add    %edx,%eax
c0100a3f:	0f b6 00             	movzbl (%eax),%eax
c0100a42:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100a48:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100a4b:	01 ca                	add    %ecx,%edx
c0100a4d:	88 02                	mov    %al,(%edx)
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100a4f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100a53:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a56:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0100a59:	7c dc                	jl     c0100a37 <print_debuginfo+0x41>
        fnname[j] = '\0';
c0100a5b:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
c0100a61:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a64:	01 d0                	add    %edx,%eax
c0100a66:	c6 00 00             	movb   $0x0,(%eax)
                fnname, eip - info.eip_fn_addr);
c0100a69:	8b 45 ec             	mov    -0x14(%ebp),%eax
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c0100a6c:	8b 55 08             	mov    0x8(%ebp),%edx
c0100a6f:	89 d1                	mov    %edx,%ecx
c0100a71:	29 c1                	sub    %eax,%ecx
c0100a73:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0100a76:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100a79:	83 ec 0c             	sub    $0xc,%esp
c0100a7c:	51                   	push   %ecx
c0100a7d:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100a83:	51                   	push   %ecx
c0100a84:	52                   	push   %edx
c0100a85:	50                   	push   %eax
c0100a86:	68 22 5e 10 c0       	push   $0xc0105e22
c0100a8b:	e8 0b f8 ff ff       	call   c010029b <cprintf>
c0100a90:	83 c4 20             	add    $0x20,%esp
}
c0100a93:	90                   	nop
c0100a94:	c9                   	leave  
c0100a95:	c3                   	ret    

c0100a96 <read_eip>:

static __noinline uint32_t
read_eip(void) {
c0100a96:	f3 0f 1e fb          	endbr32 
c0100a9a:	55                   	push   %ebp
c0100a9b:	89 e5                	mov    %esp,%ebp
c0100a9d:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c0100aa0:	8b 45 04             	mov    0x4(%ebp),%eax
c0100aa3:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
c0100aa6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0100aa9:	c9                   	leave  
c0100aaa:	c3                   	ret    

c0100aab <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c0100aab:	f3 0f 1e fb          	endbr32 
c0100aaf:	55                   	push   %ebp
c0100ab0:	89 e5                	mov    %esp,%ebp
c0100ab2:	83 ec 28             	sub    $0x28,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
c0100ab5:	89 e8                	mov    %ebp,%eax
c0100ab7:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
c0100aba:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp = read_ebp(), eip = read_eip();
c0100abd:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100ac0:	e8 d1 ff ff ff       	call   c0100a96 <read_eip>
c0100ac5:	89 45 f0             	mov    %eax,-0x10(%ebp)

    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
c0100ac8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0100acf:	e9 8d 00 00 00       	jmp    c0100b61 <print_stackframe+0xb6>
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
c0100ad4:	83 ec 04             	sub    $0x4,%esp
c0100ad7:	ff 75 f0             	pushl  -0x10(%ebp)
c0100ada:	ff 75 f4             	pushl  -0xc(%ebp)
c0100add:	68 34 5e 10 c0       	push   $0xc0105e34
c0100ae2:	e8 b4 f7 ff ff       	call   c010029b <cprintf>
c0100ae7:	83 c4 10             	add    $0x10,%esp
        uint32_t *args = (uint32_t *)ebp + 2;
c0100aea:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100aed:	83 c0 08             	add    $0x8,%eax
c0100af0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        for (j = 0; j < 4; j ++) {
c0100af3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0100afa:	eb 26                	jmp    c0100b22 <print_stackframe+0x77>
            cprintf("0x%08x ", args[j]);
c0100afc:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100aff:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100b06:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100b09:	01 d0                	add    %edx,%eax
c0100b0b:	8b 00                	mov    (%eax),%eax
c0100b0d:	83 ec 08             	sub    $0x8,%esp
c0100b10:	50                   	push   %eax
c0100b11:	68 50 5e 10 c0       	push   $0xc0105e50
c0100b16:	e8 80 f7 ff ff       	call   c010029b <cprintf>
c0100b1b:	83 c4 10             	add    $0x10,%esp
        for (j = 0; j < 4; j ++) {
c0100b1e:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
c0100b22:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
c0100b26:	7e d4                	jle    c0100afc <print_stackframe+0x51>
        }
        cprintf("\n");
c0100b28:	83 ec 0c             	sub    $0xc,%esp
c0100b2b:	68 58 5e 10 c0       	push   $0xc0105e58
c0100b30:	e8 66 f7 ff ff       	call   c010029b <cprintf>
c0100b35:	83 c4 10             	add    $0x10,%esp
        print_debuginfo(eip - 1);
c0100b38:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100b3b:	83 e8 01             	sub    $0x1,%eax
c0100b3e:	83 ec 0c             	sub    $0xc,%esp
c0100b41:	50                   	push   %eax
c0100b42:	e8 af fe ff ff       	call   c01009f6 <print_debuginfo>
c0100b47:	83 c4 10             	add    $0x10,%esp
        eip = ((uint32_t *)ebp)[1];
c0100b4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b4d:	83 c0 04             	add    $0x4,%eax
c0100b50:	8b 00                	mov    (%eax),%eax
c0100b52:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = ((uint32_t *)ebp)[0];
c0100b55:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b58:	8b 00                	mov    (%eax),%eax
c0100b5a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
c0100b5d:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0100b61:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100b65:	74 0a                	je     c0100b71 <print_stackframe+0xc6>
c0100b67:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
c0100b6b:	0f 8e 63 ff ff ff    	jle    c0100ad4 <print_stackframe+0x29>
    }
}
c0100b71:	90                   	nop
c0100b72:	c9                   	leave  
c0100b73:	c3                   	ret    

c0100b74 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100b74:	f3 0f 1e fb          	endbr32 
c0100b78:	55                   	push   %ebp
c0100b79:	89 e5                	mov    %esp,%ebp
c0100b7b:	83 ec 18             	sub    $0x18,%esp
    int argc = 0;
c0100b7e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b85:	eb 0c                	jmp    c0100b93 <parse+0x1f>
            *buf ++ = '\0';
c0100b87:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b8a:	8d 50 01             	lea    0x1(%eax),%edx
c0100b8d:	89 55 08             	mov    %edx,0x8(%ebp)
c0100b90:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b93:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b96:	0f b6 00             	movzbl (%eax),%eax
c0100b99:	84 c0                	test   %al,%al
c0100b9b:	74 1e                	je     c0100bbb <parse+0x47>
c0100b9d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ba0:	0f b6 00             	movzbl (%eax),%eax
c0100ba3:	0f be c0             	movsbl %al,%eax
c0100ba6:	83 ec 08             	sub    $0x8,%esp
c0100ba9:	50                   	push   %eax
c0100baa:	68 dc 5e 10 c0       	push   $0xc0105edc
c0100baf:	e8 20 47 00 00       	call   c01052d4 <strchr>
c0100bb4:	83 c4 10             	add    $0x10,%esp
c0100bb7:	85 c0                	test   %eax,%eax
c0100bb9:	75 cc                	jne    c0100b87 <parse+0x13>
        }
        if (*buf == '\0') {
c0100bbb:	8b 45 08             	mov    0x8(%ebp),%eax
c0100bbe:	0f b6 00             	movzbl (%eax),%eax
c0100bc1:	84 c0                	test   %al,%al
c0100bc3:	74 65                	je     c0100c2a <parse+0xb6>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100bc5:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100bc9:	75 12                	jne    c0100bdd <parse+0x69>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100bcb:	83 ec 08             	sub    $0x8,%esp
c0100bce:	6a 10                	push   $0x10
c0100bd0:	68 e1 5e 10 c0       	push   $0xc0105ee1
c0100bd5:	e8 c1 f6 ff ff       	call   c010029b <cprintf>
c0100bda:	83 c4 10             	add    $0x10,%esp
        }
        argv[argc ++] = buf;
c0100bdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100be0:	8d 50 01             	lea    0x1(%eax),%edx
c0100be3:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100be6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100bed:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100bf0:	01 c2                	add    %eax,%edx
c0100bf2:	8b 45 08             	mov    0x8(%ebp),%eax
c0100bf5:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100bf7:	eb 04                	jmp    c0100bfd <parse+0x89>
            buf ++;
c0100bf9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100bfd:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c00:	0f b6 00             	movzbl (%eax),%eax
c0100c03:	84 c0                	test   %al,%al
c0100c05:	74 8c                	je     c0100b93 <parse+0x1f>
c0100c07:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c0a:	0f b6 00             	movzbl (%eax),%eax
c0100c0d:	0f be c0             	movsbl %al,%eax
c0100c10:	83 ec 08             	sub    $0x8,%esp
c0100c13:	50                   	push   %eax
c0100c14:	68 dc 5e 10 c0       	push   $0xc0105edc
c0100c19:	e8 b6 46 00 00       	call   c01052d4 <strchr>
c0100c1e:	83 c4 10             	add    $0x10,%esp
c0100c21:	85 c0                	test   %eax,%eax
c0100c23:	74 d4                	je     c0100bf9 <parse+0x85>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100c25:	e9 69 ff ff ff       	jmp    c0100b93 <parse+0x1f>
            break;
c0100c2a:	90                   	nop
        }
    }
    return argc;
c0100c2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100c2e:	c9                   	leave  
c0100c2f:	c3                   	ret    

c0100c30 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100c30:	f3 0f 1e fb          	endbr32 
c0100c34:	55                   	push   %ebp
c0100c35:	89 e5                	mov    %esp,%ebp
c0100c37:	83 ec 58             	sub    $0x58,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100c3a:	83 ec 08             	sub    $0x8,%esp
c0100c3d:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100c40:	50                   	push   %eax
c0100c41:	ff 75 08             	pushl  0x8(%ebp)
c0100c44:	e8 2b ff ff ff       	call   c0100b74 <parse>
c0100c49:	83 c4 10             	add    $0x10,%esp
c0100c4c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100c4f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100c53:	75 0a                	jne    c0100c5f <runcmd+0x2f>
        return 0;
c0100c55:	b8 00 00 00 00       	mov    $0x0,%eax
c0100c5a:	e9 83 00 00 00       	jmp    c0100ce2 <runcmd+0xb2>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c5f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100c66:	eb 59                	jmp    c0100cc1 <runcmd+0x91>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100c68:	8b 4d b0             	mov    -0x50(%ebp),%ecx
c0100c6b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c6e:	89 d0                	mov    %edx,%eax
c0100c70:	01 c0                	add    %eax,%eax
c0100c72:	01 d0                	add    %edx,%eax
c0100c74:	c1 e0 02             	shl    $0x2,%eax
c0100c77:	05 00 90 11 c0       	add    $0xc0119000,%eax
c0100c7c:	8b 00                	mov    (%eax),%eax
c0100c7e:	83 ec 08             	sub    $0x8,%esp
c0100c81:	51                   	push   %ecx
c0100c82:	50                   	push   %eax
c0100c83:	e8 a5 45 00 00       	call   c010522d <strcmp>
c0100c88:	83 c4 10             	add    $0x10,%esp
c0100c8b:	85 c0                	test   %eax,%eax
c0100c8d:	75 2e                	jne    c0100cbd <runcmd+0x8d>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100c8f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c92:	89 d0                	mov    %edx,%eax
c0100c94:	01 c0                	add    %eax,%eax
c0100c96:	01 d0                	add    %edx,%eax
c0100c98:	c1 e0 02             	shl    $0x2,%eax
c0100c9b:	05 08 90 11 c0       	add    $0xc0119008,%eax
c0100ca0:	8b 10                	mov    (%eax),%edx
c0100ca2:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100ca5:	83 c0 04             	add    $0x4,%eax
c0100ca8:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0100cab:	83 e9 01             	sub    $0x1,%ecx
c0100cae:	83 ec 04             	sub    $0x4,%esp
c0100cb1:	ff 75 0c             	pushl  0xc(%ebp)
c0100cb4:	50                   	push   %eax
c0100cb5:	51                   	push   %ecx
c0100cb6:	ff d2                	call   *%edx
c0100cb8:	83 c4 10             	add    $0x10,%esp
c0100cbb:	eb 25                	jmp    c0100ce2 <runcmd+0xb2>
    for (i = 0; i < NCOMMANDS; i ++) {
c0100cbd:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100cc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100cc4:	83 f8 02             	cmp    $0x2,%eax
c0100cc7:	76 9f                	jbe    c0100c68 <runcmd+0x38>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100cc9:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100ccc:	83 ec 08             	sub    $0x8,%esp
c0100ccf:	50                   	push   %eax
c0100cd0:	68 ff 5e 10 c0       	push   $0xc0105eff
c0100cd5:	e8 c1 f5 ff ff       	call   c010029b <cprintf>
c0100cda:	83 c4 10             	add    $0x10,%esp
    return 0;
c0100cdd:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100ce2:	c9                   	leave  
c0100ce3:	c3                   	ret    

c0100ce4 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100ce4:	f3 0f 1e fb          	endbr32 
c0100ce8:	55                   	push   %ebp
c0100ce9:	89 e5                	mov    %esp,%ebp
c0100ceb:	83 ec 18             	sub    $0x18,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100cee:	83 ec 0c             	sub    $0xc,%esp
c0100cf1:	68 18 5f 10 c0       	push   $0xc0105f18
c0100cf6:	e8 a0 f5 ff ff       	call   c010029b <cprintf>
c0100cfb:	83 c4 10             	add    $0x10,%esp
    cprintf("Type 'help' for a list of commands.\n");
c0100cfe:	83 ec 0c             	sub    $0xc,%esp
c0100d01:	68 40 5f 10 c0       	push   $0xc0105f40
c0100d06:	e8 90 f5 ff ff       	call   c010029b <cprintf>
c0100d0b:	83 c4 10             	add    $0x10,%esp

    if (tf != NULL) {
c0100d0e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100d12:	74 0e                	je     c0100d22 <kmonitor+0x3e>
        print_trapframe(tf);
c0100d14:	83 ec 0c             	sub    $0xc,%esp
c0100d17:	ff 75 08             	pushl  0x8(%ebp)
c0100d1a:	e8 f0 0d 00 00       	call   c0101b0f <print_trapframe>
c0100d1f:	83 c4 10             	add    $0x10,%esp
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100d22:	83 ec 0c             	sub    $0xc,%esp
c0100d25:	68 65 5f 10 c0       	push   $0xc0105f65
c0100d2a:	e8 21 f6 ff ff       	call   c0100350 <readline>
c0100d2f:	83 c4 10             	add    $0x10,%esp
c0100d32:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100d35:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100d39:	74 e7                	je     c0100d22 <kmonitor+0x3e>
            if (runcmd(buf, tf) < 0) {
c0100d3b:	83 ec 08             	sub    $0x8,%esp
c0100d3e:	ff 75 08             	pushl  0x8(%ebp)
c0100d41:	ff 75 f4             	pushl  -0xc(%ebp)
c0100d44:	e8 e7 fe ff ff       	call   c0100c30 <runcmd>
c0100d49:	83 c4 10             	add    $0x10,%esp
c0100d4c:	85 c0                	test   %eax,%eax
c0100d4e:	78 02                	js     c0100d52 <kmonitor+0x6e>
        if ((buf = readline("K> ")) != NULL) {
c0100d50:	eb d0                	jmp    c0100d22 <kmonitor+0x3e>
                break;
c0100d52:	90                   	nop
            }
        }
    }
}
c0100d53:	90                   	nop
c0100d54:	c9                   	leave  
c0100d55:	c3                   	ret    

c0100d56 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100d56:	f3 0f 1e fb          	endbr32 
c0100d5a:	55                   	push   %ebp
c0100d5b:	89 e5                	mov    %esp,%ebp
c0100d5d:	83 ec 18             	sub    $0x18,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100d60:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100d67:	eb 3c                	jmp    c0100da5 <mon_help+0x4f>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100d69:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100d6c:	89 d0                	mov    %edx,%eax
c0100d6e:	01 c0                	add    %eax,%eax
c0100d70:	01 d0                	add    %edx,%eax
c0100d72:	c1 e0 02             	shl    $0x2,%eax
c0100d75:	05 04 90 11 c0       	add    $0xc0119004,%eax
c0100d7a:	8b 08                	mov    (%eax),%ecx
c0100d7c:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100d7f:	89 d0                	mov    %edx,%eax
c0100d81:	01 c0                	add    %eax,%eax
c0100d83:	01 d0                	add    %edx,%eax
c0100d85:	c1 e0 02             	shl    $0x2,%eax
c0100d88:	05 00 90 11 c0       	add    $0xc0119000,%eax
c0100d8d:	8b 00                	mov    (%eax),%eax
c0100d8f:	83 ec 04             	sub    $0x4,%esp
c0100d92:	51                   	push   %ecx
c0100d93:	50                   	push   %eax
c0100d94:	68 69 5f 10 c0       	push   $0xc0105f69
c0100d99:	e8 fd f4 ff ff       	call   c010029b <cprintf>
c0100d9e:	83 c4 10             	add    $0x10,%esp
    for (i = 0; i < NCOMMANDS; i ++) {
c0100da1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100da5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100da8:	83 f8 02             	cmp    $0x2,%eax
c0100dab:	76 bc                	jbe    c0100d69 <mon_help+0x13>
    }
    return 0;
c0100dad:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100db2:	c9                   	leave  
c0100db3:	c3                   	ret    

c0100db4 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100db4:	f3 0f 1e fb          	endbr32 
c0100db8:	55                   	push   %ebp
c0100db9:	89 e5                	mov    %esp,%ebp
c0100dbb:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100dbe:	e8 94 fb ff ff       	call   c0100957 <print_kerninfo>
    return 0;
c0100dc3:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100dc8:	c9                   	leave  
c0100dc9:	c3                   	ret    

c0100dca <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100dca:	f3 0f 1e fb          	endbr32 
c0100dce:	55                   	push   %ebp
c0100dcf:	89 e5                	mov    %esp,%ebp
c0100dd1:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100dd4:	e8 d2 fc ff ff       	call   c0100aab <print_stackframe>
    return 0;
c0100dd9:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100dde:	c9                   	leave  
c0100ddf:	c3                   	ret    

c0100de0 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c0100de0:	f3 0f 1e fb          	endbr32 
c0100de4:	55                   	push   %ebp
c0100de5:	89 e5                	mov    %esp,%ebp
c0100de7:	83 ec 18             	sub    $0x18,%esp
c0100dea:	66 c7 45 ee 43 00    	movw   $0x43,-0x12(%ebp)
c0100df0:	c6 45 ed 34          	movb   $0x34,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100df4:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100df8:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100dfc:	ee                   	out    %al,(%dx)
}
c0100dfd:	90                   	nop
c0100dfe:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0100e04:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100e08:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100e0c:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100e10:	ee                   	out    %al,(%dx)
}
c0100e11:	90                   	nop
c0100e12:	66 c7 45 f6 40 00    	movw   $0x40,-0xa(%ebp)
c0100e18:	c6 45 f5 2e          	movb   $0x2e,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100e1c:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100e20:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100e24:	ee                   	out    %al,(%dx)
}
c0100e25:	90                   	nop
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0100e26:	c7 05 0c cf 11 c0 00 	movl   $0x0,0xc011cf0c
c0100e2d:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100e30:	83 ec 0c             	sub    $0xc,%esp
c0100e33:	68 72 5f 10 c0       	push   $0xc0105f72
c0100e38:	e8 5e f4 ff ff       	call   c010029b <cprintf>
c0100e3d:	83 c4 10             	add    $0x10,%esp
    pic_enable(IRQ_TIMER);
c0100e40:	83 ec 0c             	sub    $0xc,%esp
c0100e43:	6a 00                	push   $0x0
c0100e45:	e8 a6 09 00 00       	call   c01017f0 <pic_enable>
c0100e4a:	83 c4 10             	add    $0x10,%esp
}
c0100e4d:	90                   	nop
c0100e4e:	c9                   	leave  
c0100e4f:	c3                   	ret    

c0100e50 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0100e50:	55                   	push   %ebp
c0100e51:	89 e5                	mov    %esp,%ebp
c0100e53:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0100e56:	9c                   	pushf  
c0100e57:	58                   	pop    %eax
c0100e58:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0100e5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0100e5e:	25 00 02 00 00       	and    $0x200,%eax
c0100e63:	85 c0                	test   %eax,%eax
c0100e65:	74 0c                	je     c0100e73 <__intr_save+0x23>
        intr_disable();
c0100e67:	e8 10 0b 00 00       	call   c010197c <intr_disable>
        return 1;
c0100e6c:	b8 01 00 00 00       	mov    $0x1,%eax
c0100e71:	eb 05                	jmp    c0100e78 <__intr_save+0x28>
    }
    return 0;
c0100e73:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100e78:	c9                   	leave  
c0100e79:	c3                   	ret    

c0100e7a <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0100e7a:	55                   	push   %ebp
c0100e7b:	89 e5                	mov    %esp,%ebp
c0100e7d:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0100e80:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100e84:	74 05                	je     c0100e8b <__intr_restore+0x11>
        intr_enable();
c0100e86:	e8 e5 0a 00 00       	call   c0101970 <intr_enable>
    }
}
c0100e8b:	90                   	nop
c0100e8c:	c9                   	leave  
c0100e8d:	c3                   	ret    

c0100e8e <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c0100e8e:	f3 0f 1e fb          	endbr32 
c0100e92:	55                   	push   %ebp
c0100e93:	89 e5                	mov    %esp,%ebp
c0100e95:	83 ec 10             	sub    $0x10,%esp
c0100e98:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e9e:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100ea2:	89 c2                	mov    %eax,%edx
c0100ea4:	ec                   	in     (%dx),%al
c0100ea5:	88 45 f1             	mov    %al,-0xf(%ebp)
c0100ea8:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
c0100eae:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100eb2:	89 c2                	mov    %eax,%edx
c0100eb4:	ec                   	in     (%dx),%al
c0100eb5:	88 45 f5             	mov    %al,-0xb(%ebp)
c0100eb8:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
c0100ebe:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100ec2:	89 c2                	mov    %eax,%edx
c0100ec4:	ec                   	in     (%dx),%al
c0100ec5:	88 45 f9             	mov    %al,-0x7(%ebp)
c0100ec8:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
c0100ece:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0100ed2:	89 c2                	mov    %eax,%edx
c0100ed4:	ec                   	in     (%dx),%al
c0100ed5:	88 45 fd             	mov    %al,-0x3(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c0100ed8:	90                   	nop
c0100ed9:	c9                   	leave  
c0100eda:	c3                   	ret    

c0100edb <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c0100edb:	f3 0f 1e fb          	endbr32 
c0100edf:	55                   	push   %ebp
c0100ee0:	89 e5                	mov    %esp,%ebp
c0100ee2:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0100ee5:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c0100eec:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100eef:	0f b7 00             	movzwl (%eax),%eax
c0100ef2:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
c0100ef6:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100ef9:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c0100efe:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f01:	0f b7 00             	movzwl (%eax),%eax
c0100f04:	66 3d 5a a5          	cmp    $0xa55a,%ax
c0100f08:	74 12                	je     c0100f1c <cga_init+0x41>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c0100f0a:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c0100f11:	66 c7 05 46 c4 11 c0 	movw   $0x3b4,0xc011c446
c0100f18:	b4 03 
c0100f1a:	eb 13                	jmp    c0100f2f <cga_init+0x54>
    } else {
        *cp = was;
c0100f1c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f1f:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0100f23:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0100f26:	66 c7 05 46 c4 11 c0 	movw   $0x3d4,0xc011c446
c0100f2d:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100f2f:	0f b7 05 46 c4 11 c0 	movzwl 0xc011c446,%eax
c0100f36:	0f b7 c0             	movzwl %ax,%eax
c0100f39:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
c0100f3d:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f41:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100f45:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0100f49:	ee                   	out    %al,(%dx)
}
c0100f4a:	90                   	nop
    pos = inb(addr_6845 + 1) << 8;
c0100f4b:	0f b7 05 46 c4 11 c0 	movzwl 0xc011c446,%eax
c0100f52:	83 c0 01             	add    $0x1,%eax
c0100f55:	0f b7 c0             	movzwl %ax,%eax
c0100f58:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f5c:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0100f60:	89 c2                	mov    %eax,%edx
c0100f62:	ec                   	in     (%dx),%al
c0100f63:	88 45 e9             	mov    %al,-0x17(%ebp)
    return data;
c0100f66:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100f6a:	0f b6 c0             	movzbl %al,%eax
c0100f6d:	c1 e0 08             	shl    $0x8,%eax
c0100f70:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
c0100f73:	0f b7 05 46 c4 11 c0 	movzwl 0xc011c446,%eax
c0100f7a:	0f b7 c0             	movzwl %ax,%eax
c0100f7d:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0100f81:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f85:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100f89:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100f8d:	ee                   	out    %al,(%dx)
}
c0100f8e:	90                   	nop
    pos |= inb(addr_6845 + 1);
c0100f8f:	0f b7 05 46 c4 11 c0 	movzwl 0xc011c446,%eax
c0100f96:	83 c0 01             	add    $0x1,%eax
c0100f99:	0f b7 c0             	movzwl %ax,%eax
c0100f9c:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100fa0:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100fa4:	89 c2                	mov    %eax,%edx
c0100fa6:	ec                   	in     (%dx),%al
c0100fa7:	88 45 f1             	mov    %al,-0xf(%ebp)
    return data;
c0100faa:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100fae:	0f b6 c0             	movzbl %al,%eax
c0100fb1:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
c0100fb4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100fb7:	a3 40 c4 11 c0       	mov    %eax,0xc011c440
    crt_pos = pos;
c0100fbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100fbf:	66 a3 44 c4 11 c0    	mov    %ax,0xc011c444
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
c0100fcf:	83 ec 38             	sub    $0x38,%esp
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
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c0101072:	3c ff                	cmp    $0xff,%al
c0101074:	0f 95 c0             	setne  %al
c0101077:	0f b6 c0             	movzbl %al,%eax
c010107a:	a3 48 c4 11 c0       	mov    %eax,0xc011c448
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
c010109f:	a1 48 c4 11 c0       	mov    0xc011c448,%eax
c01010a4:	85 c0                	test   %eax,%eax
c01010a6:	74 0d                	je     c01010b5 <serial_init+0xed>
        pic_enable(IRQ_COM1);
c01010a8:	83 ec 0c             	sub    $0xc,%esp
c01010ab:	6a 04                	push   $0x4
c01010ad:	e8 3e 07 00 00       	call   c01017f0 <pic_enable>
c01010b2:	83 c4 10             	add    $0x10,%esp
    }
}
c01010b5:	90                   	nop
c01010b6:	c9                   	leave  
c01010b7:	c3                   	ret    

c01010b8 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c01010b8:	f3 0f 1e fb          	endbr32 
c01010bc:	55                   	push   %ebp
c01010bd:	89 e5                	mov    %esp,%ebp
c01010bf:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c01010c2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01010c9:	eb 09                	jmp    c01010d4 <lpt_putc_sub+0x1c>
        delay();
c01010cb:	e8 be fd ff ff       	call   c0100e8e <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c01010d0:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01010d4:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
c01010da:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01010de:	89 c2                	mov    %eax,%edx
c01010e0:	ec                   	in     (%dx),%al
c01010e1:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01010e4:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01010e8:	84 c0                	test   %al,%al
c01010ea:	78 09                	js     c01010f5 <lpt_putc_sub+0x3d>
c01010ec:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c01010f3:	7e d6                	jle    c01010cb <lpt_putc_sub+0x13>
    }
    outb(LPTPORT + 0, c);
c01010f5:	8b 45 08             	mov    0x8(%ebp),%eax
c01010f8:	0f b6 c0             	movzbl %al,%eax
c01010fb:	66 c7 45 ee 78 03    	movw   $0x378,-0x12(%ebp)
c0101101:	88 45 ed             	mov    %al,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101104:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101108:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c010110c:	ee                   	out    %al,(%dx)
}
c010110d:	90                   	nop
c010110e:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
c0101114:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101118:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c010111c:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101120:	ee                   	out    %al,(%dx)
}
c0101121:	90                   	nop
c0101122:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
c0101128:	c6 45 f5 08          	movb   $0x8,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010112c:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101130:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101134:	ee                   	out    %al,(%dx)
}
c0101135:	90                   	nop
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c0101136:	90                   	nop
c0101137:	c9                   	leave  
c0101138:	c3                   	ret    

c0101139 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c0101139:	f3 0f 1e fb          	endbr32 
c010113d:	55                   	push   %ebp
c010113e:	89 e5                	mov    %esp,%ebp
    if (c != '\b') {
c0101140:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c0101144:	74 0d                	je     c0101153 <lpt_putc+0x1a>
        lpt_putc_sub(c);
c0101146:	ff 75 08             	pushl  0x8(%ebp)
c0101149:	e8 6a ff ff ff       	call   c01010b8 <lpt_putc_sub>
c010114e:	83 c4 04             	add    $0x4,%esp
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
c0101151:	eb 1e                	jmp    c0101171 <lpt_putc+0x38>
        lpt_putc_sub('\b');
c0101153:	6a 08                	push   $0x8
c0101155:	e8 5e ff ff ff       	call   c01010b8 <lpt_putc_sub>
c010115a:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub(' ');
c010115d:	6a 20                	push   $0x20
c010115f:	e8 54 ff ff ff       	call   c01010b8 <lpt_putc_sub>
c0101164:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub('\b');
c0101167:	6a 08                	push   $0x8
c0101169:	e8 4a ff ff ff       	call   c01010b8 <lpt_putc_sub>
c010116e:	83 c4 04             	add    $0x4,%esp
}
c0101171:	90                   	nop
c0101172:	c9                   	leave  
c0101173:	c3                   	ret    

c0101174 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c0101174:	f3 0f 1e fb          	endbr32 
c0101178:	55                   	push   %ebp
c0101179:	89 e5                	mov    %esp,%ebp
c010117b:	53                   	push   %ebx
c010117c:	83 ec 24             	sub    $0x24,%esp
    // set black on white
    if (!(c & ~0xFF)) {
c010117f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101182:	b0 00                	mov    $0x0,%al
c0101184:	85 c0                	test   %eax,%eax
c0101186:	75 07                	jne    c010118f <cga_putc+0x1b>
        c |= 0x0700;
c0101188:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c010118f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101192:	0f b6 c0             	movzbl %al,%eax
c0101195:	83 f8 0d             	cmp    $0xd,%eax
c0101198:	74 6c                	je     c0101206 <cga_putc+0x92>
c010119a:	83 f8 0d             	cmp    $0xd,%eax
c010119d:	0f 8f 9d 00 00 00    	jg     c0101240 <cga_putc+0xcc>
c01011a3:	83 f8 08             	cmp    $0x8,%eax
c01011a6:	74 0a                	je     c01011b2 <cga_putc+0x3e>
c01011a8:	83 f8 0a             	cmp    $0xa,%eax
c01011ab:	74 49                	je     c01011f6 <cga_putc+0x82>
c01011ad:	e9 8e 00 00 00       	jmp    c0101240 <cga_putc+0xcc>
    case '\b':
        if (crt_pos > 0) {
c01011b2:	0f b7 05 44 c4 11 c0 	movzwl 0xc011c444,%eax
c01011b9:	66 85 c0             	test   %ax,%ax
c01011bc:	0f 84 a4 00 00 00    	je     c0101266 <cga_putc+0xf2>
            crt_pos --;
c01011c2:	0f b7 05 44 c4 11 c0 	movzwl 0xc011c444,%eax
c01011c9:	83 e8 01             	sub    $0x1,%eax
c01011cc:	66 a3 44 c4 11 c0    	mov    %ax,0xc011c444
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c01011d2:	8b 45 08             	mov    0x8(%ebp),%eax
c01011d5:	b0 00                	mov    $0x0,%al
c01011d7:	83 c8 20             	or     $0x20,%eax
c01011da:	89 c1                	mov    %eax,%ecx
c01011dc:	a1 40 c4 11 c0       	mov    0xc011c440,%eax
c01011e1:	0f b7 15 44 c4 11 c0 	movzwl 0xc011c444,%edx
c01011e8:	0f b7 d2             	movzwl %dx,%edx
c01011eb:	01 d2                	add    %edx,%edx
c01011ed:	01 d0                	add    %edx,%eax
c01011ef:	89 ca                	mov    %ecx,%edx
c01011f1:	66 89 10             	mov    %dx,(%eax)
        }
        break;
c01011f4:	eb 70                	jmp    c0101266 <cga_putc+0xf2>
    case '\n':
        crt_pos += CRT_COLS;
c01011f6:	0f b7 05 44 c4 11 c0 	movzwl 0xc011c444,%eax
c01011fd:	83 c0 50             	add    $0x50,%eax
c0101200:	66 a3 44 c4 11 c0    	mov    %ax,0xc011c444
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c0101206:	0f b7 1d 44 c4 11 c0 	movzwl 0xc011c444,%ebx
c010120d:	0f b7 0d 44 c4 11 c0 	movzwl 0xc011c444,%ecx
c0101214:	0f b7 c1             	movzwl %cx,%eax
c0101217:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
c010121d:	c1 e8 10             	shr    $0x10,%eax
c0101220:	89 c2                	mov    %eax,%edx
c0101222:	66 c1 ea 06          	shr    $0x6,%dx
c0101226:	89 d0                	mov    %edx,%eax
c0101228:	c1 e0 02             	shl    $0x2,%eax
c010122b:	01 d0                	add    %edx,%eax
c010122d:	c1 e0 04             	shl    $0x4,%eax
c0101230:	29 c1                	sub    %eax,%ecx
c0101232:	89 ca                	mov    %ecx,%edx
c0101234:	89 d8                	mov    %ebx,%eax
c0101236:	29 d0                	sub    %edx,%eax
c0101238:	66 a3 44 c4 11 c0    	mov    %ax,0xc011c444
        break;
c010123e:	eb 27                	jmp    c0101267 <cga_putc+0xf3>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c0101240:	8b 0d 40 c4 11 c0    	mov    0xc011c440,%ecx
c0101246:	0f b7 05 44 c4 11 c0 	movzwl 0xc011c444,%eax
c010124d:	8d 50 01             	lea    0x1(%eax),%edx
c0101250:	66 89 15 44 c4 11 c0 	mov    %dx,0xc011c444
c0101257:	0f b7 c0             	movzwl %ax,%eax
c010125a:	01 c0                	add    %eax,%eax
c010125c:	01 c8                	add    %ecx,%eax
c010125e:	8b 55 08             	mov    0x8(%ebp),%edx
c0101261:	66 89 10             	mov    %dx,(%eax)
        break;
c0101264:	eb 01                	jmp    c0101267 <cga_putc+0xf3>
        break;
c0101266:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c0101267:	0f b7 05 44 c4 11 c0 	movzwl 0xc011c444,%eax
c010126e:	66 3d cf 07          	cmp    $0x7cf,%ax
c0101272:	76 59                	jbe    c01012cd <cga_putc+0x159>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c0101274:	a1 40 c4 11 c0       	mov    0xc011c440,%eax
c0101279:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c010127f:	a1 40 c4 11 c0       	mov    0xc011c440,%eax
c0101284:	83 ec 04             	sub    $0x4,%esp
c0101287:	68 00 0f 00 00       	push   $0xf00
c010128c:	52                   	push   %edx
c010128d:	50                   	push   %eax
c010128e:	e8 4f 42 00 00       	call   c01054e2 <memmove>
c0101293:	83 c4 10             	add    $0x10,%esp
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101296:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c010129d:	eb 15                	jmp    c01012b4 <cga_putc+0x140>
            crt_buf[i] = 0x0700 | ' ';
c010129f:	a1 40 c4 11 c0       	mov    0xc011c440,%eax
c01012a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01012a7:	01 d2                	add    %edx,%edx
c01012a9:	01 d0                	add    %edx,%eax
c01012ab:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c01012b0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01012b4:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c01012bb:	7e e2                	jle    c010129f <cga_putc+0x12b>
        }
        crt_pos -= CRT_COLS;
c01012bd:	0f b7 05 44 c4 11 c0 	movzwl 0xc011c444,%eax
c01012c4:	83 e8 50             	sub    $0x50,%eax
c01012c7:	66 a3 44 c4 11 c0    	mov    %ax,0xc011c444
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c01012cd:	0f b7 05 46 c4 11 c0 	movzwl 0xc011c446,%eax
c01012d4:	0f b7 c0             	movzwl %ax,%eax
c01012d7:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
c01012db:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01012df:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01012e3:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01012e7:	ee                   	out    %al,(%dx)
}
c01012e8:	90                   	nop
    outb(addr_6845 + 1, crt_pos >> 8);
c01012e9:	0f b7 05 44 c4 11 c0 	movzwl 0xc011c444,%eax
c01012f0:	66 c1 e8 08          	shr    $0x8,%ax
c01012f4:	0f b6 c0             	movzbl %al,%eax
c01012f7:	0f b7 15 46 c4 11 c0 	movzwl 0xc011c446,%edx
c01012fe:	83 c2 01             	add    $0x1,%edx
c0101301:	0f b7 d2             	movzwl %dx,%edx
c0101304:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0101308:	88 45 e9             	mov    %al,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010130b:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c010130f:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101313:	ee                   	out    %al,(%dx)
}
c0101314:	90                   	nop
    outb(addr_6845, 15);
c0101315:	0f b7 05 46 c4 11 c0 	movzwl 0xc011c446,%eax
c010131c:	0f b7 c0             	movzwl %ax,%eax
c010131f:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0101323:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101327:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c010132b:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c010132f:	ee                   	out    %al,(%dx)
}
c0101330:	90                   	nop
    outb(addr_6845 + 1, crt_pos);
c0101331:	0f b7 05 44 c4 11 c0 	movzwl 0xc011c444,%eax
c0101338:	0f b6 c0             	movzbl %al,%eax
c010133b:	0f b7 15 46 c4 11 c0 	movzwl 0xc011c446,%edx
c0101342:	83 c2 01             	add    $0x1,%edx
c0101345:	0f b7 d2             	movzwl %dx,%edx
c0101348:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
c010134c:	88 45 f1             	mov    %al,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010134f:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101353:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101357:	ee                   	out    %al,(%dx)
}
c0101358:	90                   	nop
}
c0101359:	90                   	nop
c010135a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c010135d:	c9                   	leave  
c010135e:	c3                   	ret    

c010135f <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c010135f:	f3 0f 1e fb          	endbr32 
c0101363:	55                   	push   %ebp
c0101364:	89 e5                	mov    %esp,%ebp
c0101366:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c0101369:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101370:	eb 09                	jmp    c010137b <serial_putc_sub+0x1c>
        delay();
c0101372:	e8 17 fb ff ff       	call   c0100e8e <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c0101377:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c010137b:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101381:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0101385:	89 c2                	mov    %eax,%edx
c0101387:	ec                   	in     (%dx),%al
c0101388:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c010138b:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c010138f:	0f b6 c0             	movzbl %al,%eax
c0101392:	83 e0 20             	and    $0x20,%eax
c0101395:	85 c0                	test   %eax,%eax
c0101397:	75 09                	jne    c01013a2 <serial_putc_sub+0x43>
c0101399:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c01013a0:	7e d0                	jle    c0101372 <serial_putc_sub+0x13>
    }
    outb(COM1 + COM_TX, c);
c01013a2:	8b 45 08             	mov    0x8(%ebp),%eax
c01013a5:	0f b6 c0             	movzbl %al,%eax
c01013a8:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c01013ae:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01013b1:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c01013b5:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c01013b9:	ee                   	out    %al,(%dx)
}
c01013ba:	90                   	nop
}
c01013bb:	90                   	nop
c01013bc:	c9                   	leave  
c01013bd:	c3                   	ret    

c01013be <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c01013be:	f3 0f 1e fb          	endbr32 
c01013c2:	55                   	push   %ebp
c01013c3:	89 e5                	mov    %esp,%ebp
    if (c != '\b') {
c01013c5:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c01013c9:	74 0d                	je     c01013d8 <serial_putc+0x1a>
        serial_putc_sub(c);
c01013cb:	ff 75 08             	pushl  0x8(%ebp)
c01013ce:	e8 8c ff ff ff       	call   c010135f <serial_putc_sub>
c01013d3:	83 c4 04             	add    $0x4,%esp
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
c01013d6:	eb 1e                	jmp    c01013f6 <serial_putc+0x38>
        serial_putc_sub('\b');
c01013d8:	6a 08                	push   $0x8
c01013da:	e8 80 ff ff ff       	call   c010135f <serial_putc_sub>
c01013df:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub(' ');
c01013e2:	6a 20                	push   $0x20
c01013e4:	e8 76 ff ff ff       	call   c010135f <serial_putc_sub>
c01013e9:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub('\b');
c01013ec:	6a 08                	push   $0x8
c01013ee:	e8 6c ff ff ff       	call   c010135f <serial_putc_sub>
c01013f3:	83 c4 04             	add    $0x4,%esp
}
c01013f6:	90                   	nop
c01013f7:	c9                   	leave  
c01013f8:	c3                   	ret    

c01013f9 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c01013f9:	f3 0f 1e fb          	endbr32 
c01013fd:	55                   	push   %ebp
c01013fe:	89 e5                	mov    %esp,%ebp
c0101400:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c0101403:	eb 33                	jmp    c0101438 <cons_intr+0x3f>
        if (c != 0) {
c0101405:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101409:	74 2d                	je     c0101438 <cons_intr+0x3f>
            cons.buf[cons.wpos ++] = c;
c010140b:	a1 64 c6 11 c0       	mov    0xc011c664,%eax
c0101410:	8d 50 01             	lea    0x1(%eax),%edx
c0101413:	89 15 64 c6 11 c0    	mov    %edx,0xc011c664
c0101419:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010141c:	88 90 60 c4 11 c0    	mov    %dl,-0x3fee3ba0(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c0101422:	a1 64 c6 11 c0       	mov    0xc011c664,%eax
c0101427:	3d 00 02 00 00       	cmp    $0x200,%eax
c010142c:	75 0a                	jne    c0101438 <cons_intr+0x3f>
                cons.wpos = 0;
c010142e:	c7 05 64 c6 11 c0 00 	movl   $0x0,0xc011c664
c0101435:	00 00 00 
    while ((c = (*proc)()) != -1) {
c0101438:	8b 45 08             	mov    0x8(%ebp),%eax
c010143b:	ff d0                	call   *%eax
c010143d:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0101440:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c0101444:	75 bf                	jne    c0101405 <cons_intr+0xc>
            }
        }
    }
}
c0101446:	90                   	nop
c0101447:	90                   	nop
c0101448:	c9                   	leave  
c0101449:	c3                   	ret    

c010144a <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c010144a:	f3 0f 1e fb          	endbr32 
c010144e:	55                   	push   %ebp
c010144f:	89 e5                	mov    %esp,%ebp
c0101451:	83 ec 10             	sub    $0x10,%esp
c0101454:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010145a:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c010145e:	89 c2                	mov    %eax,%edx
c0101460:	ec                   	in     (%dx),%al
c0101461:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c0101464:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c0101468:	0f b6 c0             	movzbl %al,%eax
c010146b:	83 e0 01             	and    $0x1,%eax
c010146e:	85 c0                	test   %eax,%eax
c0101470:	75 07                	jne    c0101479 <serial_proc_data+0x2f>
        return -1;
c0101472:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101477:	eb 2a                	jmp    c01014a3 <serial_proc_data+0x59>
c0101479:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010147f:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101483:	89 c2                	mov    %eax,%edx
c0101485:	ec                   	in     (%dx),%al
c0101486:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
c0101489:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c010148d:	0f b6 c0             	movzbl %al,%eax
c0101490:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
c0101493:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c0101497:	75 07                	jne    c01014a0 <serial_proc_data+0x56>
        c = '\b';
c0101499:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
c01014a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01014a3:	c9                   	leave  
c01014a4:	c3                   	ret    

c01014a5 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c01014a5:	f3 0f 1e fb          	endbr32 
c01014a9:	55                   	push   %ebp
c01014aa:	89 e5                	mov    %esp,%ebp
c01014ac:	83 ec 08             	sub    $0x8,%esp
    if (serial_exists) {
c01014af:	a1 48 c4 11 c0       	mov    0xc011c448,%eax
c01014b4:	85 c0                	test   %eax,%eax
c01014b6:	74 10                	je     c01014c8 <serial_intr+0x23>
        cons_intr(serial_proc_data);
c01014b8:	83 ec 0c             	sub    $0xc,%esp
c01014bb:	68 4a 14 10 c0       	push   $0xc010144a
c01014c0:	e8 34 ff ff ff       	call   c01013f9 <cons_intr>
c01014c5:	83 c4 10             	add    $0x10,%esp
    }
}
c01014c8:	90                   	nop
c01014c9:	c9                   	leave  
c01014ca:	c3                   	ret    

c01014cb <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c01014cb:	f3 0f 1e fb          	endbr32 
c01014cf:	55                   	push   %ebp
c01014d0:	89 e5                	mov    %esp,%ebp
c01014d2:	83 ec 28             	sub    $0x28,%esp
c01014d5:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01014db:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01014df:	89 c2                	mov    %eax,%edx
c01014e1:	ec                   	in     (%dx),%al
c01014e2:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
c01014e5:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c01014e9:	0f b6 c0             	movzbl %al,%eax
c01014ec:	83 e0 01             	and    $0x1,%eax
c01014ef:	85 c0                	test   %eax,%eax
c01014f1:	75 0a                	jne    c01014fd <kbd_proc_data+0x32>
        return -1;
c01014f3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01014f8:	e9 5e 01 00 00       	jmp    c010165b <kbd_proc_data+0x190>
c01014fd:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101503:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101507:	89 c2                	mov    %eax,%edx
c0101509:	ec                   	in     (%dx),%al
c010150a:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c010150d:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
c0101511:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c0101514:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c0101518:	75 17                	jne    c0101531 <kbd_proc_data+0x66>
        // E0 escape character
        shift |= E0ESC;
c010151a:	a1 68 c6 11 c0       	mov    0xc011c668,%eax
c010151f:	83 c8 40             	or     $0x40,%eax
c0101522:	a3 68 c6 11 c0       	mov    %eax,0xc011c668
        return 0;
c0101527:	b8 00 00 00 00       	mov    $0x0,%eax
c010152c:	e9 2a 01 00 00       	jmp    c010165b <kbd_proc_data+0x190>
    } else if (data & 0x80) {
c0101531:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101535:	84 c0                	test   %al,%al
c0101537:	79 47                	jns    c0101580 <kbd_proc_data+0xb5>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c0101539:	a1 68 c6 11 c0       	mov    0xc011c668,%eax
c010153e:	83 e0 40             	and    $0x40,%eax
c0101541:	85 c0                	test   %eax,%eax
c0101543:	75 09                	jne    c010154e <kbd_proc_data+0x83>
c0101545:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101549:	83 e0 7f             	and    $0x7f,%eax
c010154c:	eb 04                	jmp    c0101552 <kbd_proc_data+0x87>
c010154e:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101552:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c0101555:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101559:	0f b6 80 40 90 11 c0 	movzbl -0x3fee6fc0(%eax),%eax
c0101560:	83 c8 40             	or     $0x40,%eax
c0101563:	0f b6 c0             	movzbl %al,%eax
c0101566:	f7 d0                	not    %eax
c0101568:	89 c2                	mov    %eax,%edx
c010156a:	a1 68 c6 11 c0       	mov    0xc011c668,%eax
c010156f:	21 d0                	and    %edx,%eax
c0101571:	a3 68 c6 11 c0       	mov    %eax,0xc011c668
        return 0;
c0101576:	b8 00 00 00 00       	mov    $0x0,%eax
c010157b:	e9 db 00 00 00       	jmp    c010165b <kbd_proc_data+0x190>
    } else if (shift & E0ESC) {
c0101580:	a1 68 c6 11 c0       	mov    0xc011c668,%eax
c0101585:	83 e0 40             	and    $0x40,%eax
c0101588:	85 c0                	test   %eax,%eax
c010158a:	74 11                	je     c010159d <kbd_proc_data+0xd2>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c010158c:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c0101590:	a1 68 c6 11 c0       	mov    0xc011c668,%eax
c0101595:	83 e0 bf             	and    $0xffffffbf,%eax
c0101598:	a3 68 c6 11 c0       	mov    %eax,0xc011c668
    }

    shift |= shiftcode[data];
c010159d:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01015a1:	0f b6 80 40 90 11 c0 	movzbl -0x3fee6fc0(%eax),%eax
c01015a8:	0f b6 d0             	movzbl %al,%edx
c01015ab:	a1 68 c6 11 c0       	mov    0xc011c668,%eax
c01015b0:	09 d0                	or     %edx,%eax
c01015b2:	a3 68 c6 11 c0       	mov    %eax,0xc011c668
    shift ^= togglecode[data];
c01015b7:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01015bb:	0f b6 80 40 91 11 c0 	movzbl -0x3fee6ec0(%eax),%eax
c01015c2:	0f b6 d0             	movzbl %al,%edx
c01015c5:	a1 68 c6 11 c0       	mov    0xc011c668,%eax
c01015ca:	31 d0                	xor    %edx,%eax
c01015cc:	a3 68 c6 11 c0       	mov    %eax,0xc011c668

    c = charcode[shift & (CTL | SHIFT)][data];
c01015d1:	a1 68 c6 11 c0       	mov    0xc011c668,%eax
c01015d6:	83 e0 03             	and    $0x3,%eax
c01015d9:	8b 14 85 40 95 11 c0 	mov    -0x3fee6ac0(,%eax,4),%edx
c01015e0:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01015e4:	01 d0                	add    %edx,%eax
c01015e6:	0f b6 00             	movzbl (%eax),%eax
c01015e9:	0f b6 c0             	movzbl %al,%eax
c01015ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c01015ef:	a1 68 c6 11 c0       	mov    0xc011c668,%eax
c01015f4:	83 e0 08             	and    $0x8,%eax
c01015f7:	85 c0                	test   %eax,%eax
c01015f9:	74 22                	je     c010161d <kbd_proc_data+0x152>
        if ('a' <= c && c <= 'z')
c01015fb:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c01015ff:	7e 0c                	jle    c010160d <kbd_proc_data+0x142>
c0101601:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c0101605:	7f 06                	jg     c010160d <kbd_proc_data+0x142>
            c += 'A' - 'a';
c0101607:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c010160b:	eb 10                	jmp    c010161d <kbd_proc_data+0x152>
        else if ('A' <= c && c <= 'Z')
c010160d:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c0101611:	7e 0a                	jle    c010161d <kbd_proc_data+0x152>
c0101613:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c0101617:	7f 04                	jg     c010161d <kbd_proc_data+0x152>
            c += 'a' - 'A';
c0101619:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c010161d:	a1 68 c6 11 c0       	mov    0xc011c668,%eax
c0101622:	f7 d0                	not    %eax
c0101624:	83 e0 06             	and    $0x6,%eax
c0101627:	85 c0                	test   %eax,%eax
c0101629:	75 2d                	jne    c0101658 <kbd_proc_data+0x18d>
c010162b:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c0101632:	75 24                	jne    c0101658 <kbd_proc_data+0x18d>
        cprintf("Rebooting!\n");
c0101634:	83 ec 0c             	sub    $0xc,%esp
c0101637:	68 8d 5f 10 c0       	push   $0xc0105f8d
c010163c:	e8 5a ec ff ff       	call   c010029b <cprintf>
c0101641:	83 c4 10             	add    $0x10,%esp
c0101644:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
c010164a:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010164e:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c0101652:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
c0101656:	ee                   	out    %al,(%dx)
}
c0101657:	90                   	nop
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c0101658:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010165b:	c9                   	leave  
c010165c:	c3                   	ret    

c010165d <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c010165d:	f3 0f 1e fb          	endbr32 
c0101661:	55                   	push   %ebp
c0101662:	89 e5                	mov    %esp,%ebp
c0101664:	83 ec 08             	sub    $0x8,%esp
    cons_intr(kbd_proc_data);
c0101667:	83 ec 0c             	sub    $0xc,%esp
c010166a:	68 cb 14 10 c0       	push   $0xc01014cb
c010166f:	e8 85 fd ff ff       	call   c01013f9 <cons_intr>
c0101674:	83 c4 10             	add    $0x10,%esp
}
c0101677:	90                   	nop
c0101678:	c9                   	leave  
c0101679:	c3                   	ret    

c010167a <kbd_init>:

static void
kbd_init(void) {
c010167a:	f3 0f 1e fb          	endbr32 
c010167e:	55                   	push   %ebp
c010167f:	89 e5                	mov    %esp,%ebp
c0101681:	83 ec 08             	sub    $0x8,%esp
    // drain the kbd buffer
    kbd_intr();
c0101684:	e8 d4 ff ff ff       	call   c010165d <kbd_intr>
    pic_enable(IRQ_KBD);
c0101689:	83 ec 0c             	sub    $0xc,%esp
c010168c:	6a 01                	push   $0x1
c010168e:	e8 5d 01 00 00       	call   c01017f0 <pic_enable>
c0101693:	83 c4 10             	add    $0x10,%esp
}
c0101696:	90                   	nop
c0101697:	c9                   	leave  
c0101698:	c3                   	ret    

c0101699 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c0101699:	f3 0f 1e fb          	endbr32 
c010169d:	55                   	push   %ebp
c010169e:	89 e5                	mov    %esp,%ebp
c01016a0:	83 ec 08             	sub    $0x8,%esp
    cga_init();
c01016a3:	e8 33 f8 ff ff       	call   c0100edb <cga_init>
    serial_init();
c01016a8:	e8 1b f9 ff ff       	call   c0100fc8 <serial_init>
    kbd_init();
c01016ad:	e8 c8 ff ff ff       	call   c010167a <kbd_init>
    if (!serial_exists) {
c01016b2:	a1 48 c4 11 c0       	mov    0xc011c448,%eax
c01016b7:	85 c0                	test   %eax,%eax
c01016b9:	75 10                	jne    c01016cb <cons_init+0x32>
        cprintf("serial port does not exist!!\n");
c01016bb:	83 ec 0c             	sub    $0xc,%esp
c01016be:	68 99 5f 10 c0       	push   $0xc0105f99
c01016c3:	e8 d3 eb ff ff       	call   c010029b <cprintf>
c01016c8:	83 c4 10             	add    $0x10,%esp
    }
}
c01016cb:	90                   	nop
c01016cc:	c9                   	leave  
c01016cd:	c3                   	ret    

c01016ce <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c01016ce:	f3 0f 1e fb          	endbr32 
c01016d2:	55                   	push   %ebp
c01016d3:	89 e5                	mov    %esp,%ebp
c01016d5:	83 ec 18             	sub    $0x18,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c01016d8:	e8 73 f7 ff ff       	call   c0100e50 <__intr_save>
c01016dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c01016e0:	83 ec 0c             	sub    $0xc,%esp
c01016e3:	ff 75 08             	pushl  0x8(%ebp)
c01016e6:	e8 4e fa ff ff       	call   c0101139 <lpt_putc>
c01016eb:	83 c4 10             	add    $0x10,%esp
        cga_putc(c);
c01016ee:	83 ec 0c             	sub    $0xc,%esp
c01016f1:	ff 75 08             	pushl  0x8(%ebp)
c01016f4:	e8 7b fa ff ff       	call   c0101174 <cga_putc>
c01016f9:	83 c4 10             	add    $0x10,%esp
        serial_putc(c);
c01016fc:	83 ec 0c             	sub    $0xc,%esp
c01016ff:	ff 75 08             	pushl  0x8(%ebp)
c0101702:	e8 b7 fc ff ff       	call   c01013be <serial_putc>
c0101707:	83 c4 10             	add    $0x10,%esp
    }
    local_intr_restore(intr_flag);
c010170a:	83 ec 0c             	sub    $0xc,%esp
c010170d:	ff 75 f4             	pushl  -0xc(%ebp)
c0101710:	e8 65 f7 ff ff       	call   c0100e7a <__intr_restore>
c0101715:	83 c4 10             	add    $0x10,%esp
}
c0101718:	90                   	nop
c0101719:	c9                   	leave  
c010171a:	c3                   	ret    

c010171b <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c010171b:	f3 0f 1e fb          	endbr32 
c010171f:	55                   	push   %ebp
c0101720:	89 e5                	mov    %esp,%ebp
c0101722:	83 ec 18             	sub    $0x18,%esp
    int c = 0;
c0101725:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c010172c:	e8 1f f7 ff ff       	call   c0100e50 <__intr_save>
c0101731:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c0101734:	e8 6c fd ff ff       	call   c01014a5 <serial_intr>
        kbd_intr();
c0101739:	e8 1f ff ff ff       	call   c010165d <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c010173e:	8b 15 60 c6 11 c0    	mov    0xc011c660,%edx
c0101744:	a1 64 c6 11 c0       	mov    0xc011c664,%eax
c0101749:	39 c2                	cmp    %eax,%edx
c010174b:	74 31                	je     c010177e <cons_getc+0x63>
            c = cons.buf[cons.rpos ++];
c010174d:	a1 60 c6 11 c0       	mov    0xc011c660,%eax
c0101752:	8d 50 01             	lea    0x1(%eax),%edx
c0101755:	89 15 60 c6 11 c0    	mov    %edx,0xc011c660
c010175b:	0f b6 80 60 c4 11 c0 	movzbl -0x3fee3ba0(%eax),%eax
c0101762:	0f b6 c0             	movzbl %al,%eax
c0101765:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c0101768:	a1 60 c6 11 c0       	mov    0xc011c660,%eax
c010176d:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101772:	75 0a                	jne    c010177e <cons_getc+0x63>
                cons.rpos = 0;
c0101774:	c7 05 60 c6 11 c0 00 	movl   $0x0,0xc011c660
c010177b:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c010177e:	83 ec 0c             	sub    $0xc,%esp
c0101781:	ff 75 f0             	pushl  -0x10(%ebp)
c0101784:	e8 f1 f6 ff ff       	call   c0100e7a <__intr_restore>
c0101789:	83 c4 10             	add    $0x10,%esp
    return c;
c010178c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010178f:	c9                   	leave  
c0101790:	c3                   	ret    

c0101791 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c0101791:	f3 0f 1e fb          	endbr32 
c0101795:	55                   	push   %ebp
c0101796:	89 e5                	mov    %esp,%ebp
c0101798:	83 ec 14             	sub    $0x14,%esp
c010179b:	8b 45 08             	mov    0x8(%ebp),%eax
c010179e:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c01017a2:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01017a6:	66 a3 50 95 11 c0    	mov    %ax,0xc0119550
    if (did_init) {
c01017ac:	a1 6c c6 11 c0       	mov    0xc011c66c,%eax
c01017b1:	85 c0                	test   %eax,%eax
c01017b3:	74 38                	je     c01017ed <pic_setmask+0x5c>
        outb(IO_PIC1 + 1, mask);
c01017b5:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01017b9:	0f b6 c0             	movzbl %al,%eax
c01017bc:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
c01017c2:	88 45 f9             	mov    %al,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01017c5:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01017c9:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c01017cd:	ee                   	out    %al,(%dx)
}
c01017ce:	90                   	nop
        outb(IO_PIC2 + 1, mask >> 8);
c01017cf:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01017d3:	66 c1 e8 08          	shr    $0x8,%ax
c01017d7:	0f b6 c0             	movzbl %al,%eax
c01017da:	66 c7 45 fe a1 00    	movw   $0xa1,-0x2(%ebp)
c01017e0:	88 45 fd             	mov    %al,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01017e3:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c01017e7:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c01017eb:	ee                   	out    %al,(%dx)
}
c01017ec:	90                   	nop
    }
}
c01017ed:	90                   	nop
c01017ee:	c9                   	leave  
c01017ef:	c3                   	ret    

c01017f0 <pic_enable>:

void
pic_enable(unsigned int irq) {
c01017f0:	f3 0f 1e fb          	endbr32 
c01017f4:	55                   	push   %ebp
c01017f5:	89 e5                	mov    %esp,%ebp
    pic_setmask(irq_mask & ~(1 << irq));
c01017f7:	8b 45 08             	mov    0x8(%ebp),%eax
c01017fa:	ba 01 00 00 00       	mov    $0x1,%edx
c01017ff:	89 c1                	mov    %eax,%ecx
c0101801:	d3 e2                	shl    %cl,%edx
c0101803:	89 d0                	mov    %edx,%eax
c0101805:	f7 d0                	not    %eax
c0101807:	89 c2                	mov    %eax,%edx
c0101809:	0f b7 05 50 95 11 c0 	movzwl 0xc0119550,%eax
c0101810:	21 d0                	and    %edx,%eax
c0101812:	0f b7 c0             	movzwl %ax,%eax
c0101815:	50                   	push   %eax
c0101816:	e8 76 ff ff ff       	call   c0101791 <pic_setmask>
c010181b:	83 c4 04             	add    $0x4,%esp
}
c010181e:	90                   	nop
c010181f:	c9                   	leave  
c0101820:	c3                   	ret    

c0101821 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c0101821:	f3 0f 1e fb          	endbr32 
c0101825:	55                   	push   %ebp
c0101826:	89 e5                	mov    %esp,%ebp
c0101828:	83 ec 40             	sub    $0x40,%esp
    did_init = 1;
c010182b:	c7 05 6c c6 11 c0 01 	movl   $0x1,0xc011c66c
c0101832:	00 00 00 
c0101835:	66 c7 45 ca 21 00    	movw   $0x21,-0x36(%ebp)
c010183b:	c6 45 c9 ff          	movb   $0xff,-0x37(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010183f:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c0101843:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c0101847:	ee                   	out    %al,(%dx)
}
c0101848:	90                   	nop
c0101849:	66 c7 45 ce a1 00    	movw   $0xa1,-0x32(%ebp)
c010184f:	c6 45 cd ff          	movb   $0xff,-0x33(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101853:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c0101857:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c010185b:	ee                   	out    %al,(%dx)
}
c010185c:	90                   	nop
c010185d:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
c0101863:	c6 45 d1 11          	movb   $0x11,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101867:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c010186b:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c010186f:	ee                   	out    %al,(%dx)
}
c0101870:	90                   	nop
c0101871:	66 c7 45 d6 21 00    	movw   $0x21,-0x2a(%ebp)
c0101877:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010187b:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c010187f:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0101883:	ee                   	out    %al,(%dx)
}
c0101884:	90                   	nop
c0101885:	66 c7 45 da 21 00    	movw   $0x21,-0x26(%ebp)
c010188b:	c6 45 d9 04          	movb   $0x4,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010188f:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101893:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101897:	ee                   	out    %al,(%dx)
}
c0101898:	90                   	nop
c0101899:	66 c7 45 de 21 00    	movw   $0x21,-0x22(%ebp)
c010189f:	c6 45 dd 03          	movb   $0x3,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01018a3:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c01018a7:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c01018ab:	ee                   	out    %al,(%dx)
}
c01018ac:	90                   	nop
c01018ad:	66 c7 45 e2 a0 00    	movw   $0xa0,-0x1e(%ebp)
c01018b3:	c6 45 e1 11          	movb   $0x11,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01018b7:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c01018bb:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c01018bf:	ee                   	out    %al,(%dx)
}
c01018c0:	90                   	nop
c01018c1:	66 c7 45 e6 a1 00    	movw   $0xa1,-0x1a(%ebp)
c01018c7:	c6 45 e5 28          	movb   $0x28,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01018cb:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01018cf:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01018d3:	ee                   	out    %al,(%dx)
}
c01018d4:	90                   	nop
c01018d5:	66 c7 45 ea a1 00    	movw   $0xa1,-0x16(%ebp)
c01018db:	c6 45 e9 02          	movb   $0x2,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01018df:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01018e3:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01018e7:	ee                   	out    %al,(%dx)
}
c01018e8:	90                   	nop
c01018e9:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
c01018ef:	c6 45 ed 03          	movb   $0x3,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01018f3:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01018f7:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01018fb:	ee                   	out    %al,(%dx)
}
c01018fc:	90                   	nop
c01018fd:	66 c7 45 f2 20 00    	movw   $0x20,-0xe(%ebp)
c0101903:	c6 45 f1 68          	movb   $0x68,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101907:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c010190b:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010190f:	ee                   	out    %al,(%dx)
}
c0101910:	90                   	nop
c0101911:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
c0101917:	c6 45 f5 0a          	movb   $0xa,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010191b:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c010191f:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101923:	ee                   	out    %al,(%dx)
}
c0101924:	90                   	nop
c0101925:	66 c7 45 fa a0 00    	movw   $0xa0,-0x6(%ebp)
c010192b:	c6 45 f9 68          	movb   $0x68,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010192f:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101933:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101937:	ee                   	out    %al,(%dx)
}
c0101938:	90                   	nop
c0101939:	66 c7 45 fe a0 00    	movw   $0xa0,-0x2(%ebp)
c010193f:	c6 45 fd 0a          	movb   $0xa,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101943:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0101947:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c010194b:	ee                   	out    %al,(%dx)
}
c010194c:	90                   	nop
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c010194d:	0f b7 05 50 95 11 c0 	movzwl 0xc0119550,%eax
c0101954:	66 83 f8 ff          	cmp    $0xffff,%ax
c0101958:	74 13                	je     c010196d <pic_init+0x14c>
        pic_setmask(irq_mask);
c010195a:	0f b7 05 50 95 11 c0 	movzwl 0xc0119550,%eax
c0101961:	0f b7 c0             	movzwl %ax,%eax
c0101964:	50                   	push   %eax
c0101965:	e8 27 fe ff ff       	call   c0101791 <pic_setmask>
c010196a:	83 c4 04             	add    $0x4,%esp
    }
}
c010196d:	90                   	nop
c010196e:	c9                   	leave  
c010196f:	c3                   	ret    

c0101970 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c0101970:	f3 0f 1e fb          	endbr32 
c0101974:	55                   	push   %ebp
c0101975:	89 e5                	mov    %esp,%ebp
    asm volatile ("sti");
c0101977:	fb                   	sti    
}
c0101978:	90                   	nop
    sti();
}
c0101979:	90                   	nop
c010197a:	5d                   	pop    %ebp
c010197b:	c3                   	ret    

c010197c <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c010197c:	f3 0f 1e fb          	endbr32 
c0101980:	55                   	push   %ebp
c0101981:	89 e5                	mov    %esp,%ebp
    asm volatile ("cli" ::: "memory");
c0101983:	fa                   	cli    
}
c0101984:	90                   	nop
    cli();
}
c0101985:	90                   	nop
c0101986:	5d                   	pop    %ebp
c0101987:	c3                   	ret    

c0101988 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
c0101988:	f3 0f 1e fb          	endbr32 
c010198c:	55                   	push   %ebp
c010198d:	89 e5                	mov    %esp,%ebp
c010198f:	83 ec 08             	sub    $0x8,%esp
    cprintf("%d ticks\n",TICK_NUM);
c0101992:	83 ec 08             	sub    $0x8,%esp
c0101995:	6a 64                	push   $0x64
c0101997:	68 c0 5f 10 c0       	push   $0xc0105fc0
c010199c:	e8 fa e8 ff ff       	call   c010029b <cprintf>
c01019a1:	83 c4 10             	add    $0x10,%esp
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
c01019a4:	83 ec 0c             	sub    $0xc,%esp
c01019a7:	68 ca 5f 10 c0       	push   $0xc0105fca
c01019ac:	e8 ea e8 ff ff       	call   c010029b <cprintf>
c01019b1:	83 c4 10             	add    $0x10,%esp
    panic("EOT: kernel seems ok.");
c01019b4:	83 ec 04             	sub    $0x4,%esp
c01019b7:	68 d8 5f 10 c0       	push   $0xc0105fd8
c01019bc:	6a 12                	push   $0x12
c01019be:	68 ee 5f 10 c0       	push   $0xc0105fee
c01019c3:	e8 4e ea ff ff       	call   c0100416 <__panic>

c01019c8 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c01019c8:	f3 0f 1e fb          	endbr32 
c01019cc:	55                   	push   %ebp
c01019cd:	89 e5                	mov    %esp,%ebp
c01019cf:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
c01019d2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01019d9:	e9 c3 00 00 00       	jmp    c0101aa1 <idt_init+0xd9>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
c01019de:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019e1:	8b 04 85 e0 95 11 c0 	mov    -0x3fee6a20(,%eax,4),%eax
c01019e8:	89 c2                	mov    %eax,%edx
c01019ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019ed:	66 89 14 c5 80 c6 11 	mov    %dx,-0x3fee3980(,%eax,8)
c01019f4:	c0 
c01019f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019f8:	66 c7 04 c5 82 c6 11 	movw   $0x8,-0x3fee397e(,%eax,8)
c01019ff:	c0 08 00 
c0101a02:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a05:	0f b6 14 c5 84 c6 11 	movzbl -0x3fee397c(,%eax,8),%edx
c0101a0c:	c0 
c0101a0d:	83 e2 e0             	and    $0xffffffe0,%edx
c0101a10:	88 14 c5 84 c6 11 c0 	mov    %dl,-0x3fee397c(,%eax,8)
c0101a17:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a1a:	0f b6 14 c5 84 c6 11 	movzbl -0x3fee397c(,%eax,8),%edx
c0101a21:	c0 
c0101a22:	83 e2 1f             	and    $0x1f,%edx
c0101a25:	88 14 c5 84 c6 11 c0 	mov    %dl,-0x3fee397c(,%eax,8)
c0101a2c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a2f:	0f b6 14 c5 85 c6 11 	movzbl -0x3fee397b(,%eax,8),%edx
c0101a36:	c0 
c0101a37:	83 e2 f0             	and    $0xfffffff0,%edx
c0101a3a:	83 ca 0e             	or     $0xe,%edx
c0101a3d:	88 14 c5 85 c6 11 c0 	mov    %dl,-0x3fee397b(,%eax,8)
c0101a44:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a47:	0f b6 14 c5 85 c6 11 	movzbl -0x3fee397b(,%eax,8),%edx
c0101a4e:	c0 
c0101a4f:	83 e2 ef             	and    $0xffffffef,%edx
c0101a52:	88 14 c5 85 c6 11 c0 	mov    %dl,-0x3fee397b(,%eax,8)
c0101a59:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a5c:	0f b6 14 c5 85 c6 11 	movzbl -0x3fee397b(,%eax,8),%edx
c0101a63:	c0 
c0101a64:	83 e2 9f             	and    $0xffffff9f,%edx
c0101a67:	88 14 c5 85 c6 11 c0 	mov    %dl,-0x3fee397b(,%eax,8)
c0101a6e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a71:	0f b6 14 c5 85 c6 11 	movzbl -0x3fee397b(,%eax,8),%edx
c0101a78:	c0 
c0101a79:	83 ca 80             	or     $0xffffff80,%edx
c0101a7c:	88 14 c5 85 c6 11 c0 	mov    %dl,-0x3fee397b(,%eax,8)
c0101a83:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a86:	8b 04 85 e0 95 11 c0 	mov    -0x3fee6a20(,%eax,4),%eax
c0101a8d:	c1 e8 10             	shr    $0x10,%eax
c0101a90:	89 c2                	mov    %eax,%edx
c0101a92:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a95:	66 89 14 c5 86 c6 11 	mov    %dx,-0x3fee397a(,%eax,8)
c0101a9c:	c0 
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
c0101a9d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101aa1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101aa4:	3d ff 00 00 00       	cmp    $0xff,%eax
c0101aa9:	0f 86 2f ff ff ff    	jbe    c01019de <idt_init+0x16>
c0101aaf:	c7 45 f8 60 95 11 c0 	movl   $0xc0119560,-0x8(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c0101ab6:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101ab9:	0f 01 18             	lidtl  (%eax)
}
c0101abc:	90                   	nop
    }
    lidt(&idt_pd);
}
c0101abd:	90                   	nop
c0101abe:	c9                   	leave  
c0101abf:	c3                   	ret    

c0101ac0 <trapname>:

static const char *
trapname(int trapno) {
c0101ac0:	f3 0f 1e fb          	endbr32 
c0101ac4:	55                   	push   %ebp
c0101ac5:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c0101ac7:	8b 45 08             	mov    0x8(%ebp),%eax
c0101aca:	83 f8 13             	cmp    $0x13,%eax
c0101acd:	77 0c                	ja     c0101adb <trapname+0x1b>
        return excnames[trapno];
c0101acf:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ad2:	8b 04 85 40 63 10 c0 	mov    -0x3fef9cc0(,%eax,4),%eax
c0101ad9:	eb 18                	jmp    c0101af3 <trapname+0x33>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c0101adb:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c0101adf:	7e 0d                	jle    c0101aee <trapname+0x2e>
c0101ae1:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c0101ae5:	7f 07                	jg     c0101aee <trapname+0x2e>
        return "Hardware Interrupt";
c0101ae7:	b8 ff 5f 10 c0       	mov    $0xc0105fff,%eax
c0101aec:	eb 05                	jmp    c0101af3 <trapname+0x33>
    }
    return "(unknown trap)";
c0101aee:	b8 12 60 10 c0       	mov    $0xc0106012,%eax
}
c0101af3:	5d                   	pop    %ebp
c0101af4:	c3                   	ret    

c0101af5 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c0101af5:	f3 0f 1e fb          	endbr32 
c0101af9:	55                   	push   %ebp
c0101afa:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c0101afc:	8b 45 08             	mov    0x8(%ebp),%eax
c0101aff:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101b03:	66 83 f8 08          	cmp    $0x8,%ax
c0101b07:	0f 94 c0             	sete   %al
c0101b0a:	0f b6 c0             	movzbl %al,%eax
}
c0101b0d:	5d                   	pop    %ebp
c0101b0e:	c3                   	ret    

c0101b0f <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c0101b0f:	f3 0f 1e fb          	endbr32 
c0101b13:	55                   	push   %ebp
c0101b14:	89 e5                	mov    %esp,%ebp
c0101b16:	83 ec 18             	sub    $0x18,%esp
    cprintf("trapframe at %p\n", tf);
c0101b19:	83 ec 08             	sub    $0x8,%esp
c0101b1c:	ff 75 08             	pushl  0x8(%ebp)
c0101b1f:	68 53 60 10 c0       	push   $0xc0106053
c0101b24:	e8 72 e7 ff ff       	call   c010029b <cprintf>
c0101b29:	83 c4 10             	add    $0x10,%esp
    print_regs(&tf->tf_regs);
c0101b2c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b2f:	83 ec 0c             	sub    $0xc,%esp
c0101b32:	50                   	push   %eax
c0101b33:	e8 b4 01 00 00       	call   c0101cec <print_regs>
c0101b38:	83 c4 10             	add    $0x10,%esp
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c0101b3b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b3e:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0101b42:	0f b7 c0             	movzwl %ax,%eax
c0101b45:	83 ec 08             	sub    $0x8,%esp
c0101b48:	50                   	push   %eax
c0101b49:	68 64 60 10 c0       	push   $0xc0106064
c0101b4e:	e8 48 e7 ff ff       	call   c010029b <cprintf>
c0101b53:	83 c4 10             	add    $0x10,%esp
    cprintf("  es   0x----%04x\n", tf->tf_es);
c0101b56:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b59:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c0101b5d:	0f b7 c0             	movzwl %ax,%eax
c0101b60:	83 ec 08             	sub    $0x8,%esp
c0101b63:	50                   	push   %eax
c0101b64:	68 77 60 10 c0       	push   $0xc0106077
c0101b69:	e8 2d e7 ff ff       	call   c010029b <cprintf>
c0101b6e:	83 c4 10             	add    $0x10,%esp
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c0101b71:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b74:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c0101b78:	0f b7 c0             	movzwl %ax,%eax
c0101b7b:	83 ec 08             	sub    $0x8,%esp
c0101b7e:	50                   	push   %eax
c0101b7f:	68 8a 60 10 c0       	push   $0xc010608a
c0101b84:	e8 12 e7 ff ff       	call   c010029b <cprintf>
c0101b89:	83 c4 10             	add    $0x10,%esp
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c0101b8c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b8f:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c0101b93:	0f b7 c0             	movzwl %ax,%eax
c0101b96:	83 ec 08             	sub    $0x8,%esp
c0101b99:	50                   	push   %eax
c0101b9a:	68 9d 60 10 c0       	push   $0xc010609d
c0101b9f:	e8 f7 e6 ff ff       	call   c010029b <cprintf>
c0101ba4:	83 c4 10             	add    $0x10,%esp
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c0101ba7:	8b 45 08             	mov    0x8(%ebp),%eax
c0101baa:	8b 40 30             	mov    0x30(%eax),%eax
c0101bad:	83 ec 0c             	sub    $0xc,%esp
c0101bb0:	50                   	push   %eax
c0101bb1:	e8 0a ff ff ff       	call   c0101ac0 <trapname>
c0101bb6:	83 c4 10             	add    $0x10,%esp
c0101bb9:	8b 55 08             	mov    0x8(%ebp),%edx
c0101bbc:	8b 52 30             	mov    0x30(%edx),%edx
c0101bbf:	83 ec 04             	sub    $0x4,%esp
c0101bc2:	50                   	push   %eax
c0101bc3:	52                   	push   %edx
c0101bc4:	68 b0 60 10 c0       	push   $0xc01060b0
c0101bc9:	e8 cd e6 ff ff       	call   c010029b <cprintf>
c0101bce:	83 c4 10             	add    $0x10,%esp
    cprintf("  err  0x%08x\n", tf->tf_err);
c0101bd1:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bd4:	8b 40 34             	mov    0x34(%eax),%eax
c0101bd7:	83 ec 08             	sub    $0x8,%esp
c0101bda:	50                   	push   %eax
c0101bdb:	68 c2 60 10 c0       	push   $0xc01060c2
c0101be0:	e8 b6 e6 ff ff       	call   c010029b <cprintf>
c0101be5:	83 c4 10             	add    $0x10,%esp
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c0101be8:	8b 45 08             	mov    0x8(%ebp),%eax
c0101beb:	8b 40 38             	mov    0x38(%eax),%eax
c0101bee:	83 ec 08             	sub    $0x8,%esp
c0101bf1:	50                   	push   %eax
c0101bf2:	68 d1 60 10 c0       	push   $0xc01060d1
c0101bf7:	e8 9f e6 ff ff       	call   c010029b <cprintf>
c0101bfc:	83 c4 10             	add    $0x10,%esp
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c0101bff:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c02:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101c06:	0f b7 c0             	movzwl %ax,%eax
c0101c09:	83 ec 08             	sub    $0x8,%esp
c0101c0c:	50                   	push   %eax
c0101c0d:	68 e0 60 10 c0       	push   $0xc01060e0
c0101c12:	e8 84 e6 ff ff       	call   c010029b <cprintf>
c0101c17:	83 c4 10             	add    $0x10,%esp
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c0101c1a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c1d:	8b 40 40             	mov    0x40(%eax),%eax
c0101c20:	83 ec 08             	sub    $0x8,%esp
c0101c23:	50                   	push   %eax
c0101c24:	68 f3 60 10 c0       	push   $0xc01060f3
c0101c29:	e8 6d e6 ff ff       	call   c010029b <cprintf>
c0101c2e:	83 c4 10             	add    $0x10,%esp

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101c31:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0101c38:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c0101c3f:	eb 3f                	jmp    c0101c80 <print_trapframe+0x171>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c0101c41:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c44:	8b 50 40             	mov    0x40(%eax),%edx
c0101c47:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101c4a:	21 d0                	and    %edx,%eax
c0101c4c:	85 c0                	test   %eax,%eax
c0101c4e:	74 29                	je     c0101c79 <print_trapframe+0x16a>
c0101c50:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101c53:	8b 04 85 80 95 11 c0 	mov    -0x3fee6a80(,%eax,4),%eax
c0101c5a:	85 c0                	test   %eax,%eax
c0101c5c:	74 1b                	je     c0101c79 <print_trapframe+0x16a>
            cprintf("%s,", IA32flags[i]);
c0101c5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101c61:	8b 04 85 80 95 11 c0 	mov    -0x3fee6a80(,%eax,4),%eax
c0101c68:	83 ec 08             	sub    $0x8,%esp
c0101c6b:	50                   	push   %eax
c0101c6c:	68 02 61 10 c0       	push   $0xc0106102
c0101c71:	e8 25 e6 ff ff       	call   c010029b <cprintf>
c0101c76:	83 c4 10             	add    $0x10,%esp
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101c79:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101c7d:	d1 65 f0             	shll   -0x10(%ebp)
c0101c80:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101c83:	83 f8 17             	cmp    $0x17,%eax
c0101c86:	76 b9                	jbe    c0101c41 <print_trapframe+0x132>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c0101c88:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c8b:	8b 40 40             	mov    0x40(%eax),%eax
c0101c8e:	c1 e8 0c             	shr    $0xc,%eax
c0101c91:	83 e0 03             	and    $0x3,%eax
c0101c94:	83 ec 08             	sub    $0x8,%esp
c0101c97:	50                   	push   %eax
c0101c98:	68 06 61 10 c0       	push   $0xc0106106
c0101c9d:	e8 f9 e5 ff ff       	call   c010029b <cprintf>
c0101ca2:	83 c4 10             	add    $0x10,%esp

    if (!trap_in_kernel(tf)) {
c0101ca5:	83 ec 0c             	sub    $0xc,%esp
c0101ca8:	ff 75 08             	pushl  0x8(%ebp)
c0101cab:	e8 45 fe ff ff       	call   c0101af5 <trap_in_kernel>
c0101cb0:	83 c4 10             	add    $0x10,%esp
c0101cb3:	85 c0                	test   %eax,%eax
c0101cb5:	75 32                	jne    c0101ce9 <print_trapframe+0x1da>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c0101cb7:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cba:	8b 40 44             	mov    0x44(%eax),%eax
c0101cbd:	83 ec 08             	sub    $0x8,%esp
c0101cc0:	50                   	push   %eax
c0101cc1:	68 0f 61 10 c0       	push   $0xc010610f
c0101cc6:	e8 d0 e5 ff ff       	call   c010029b <cprintf>
c0101ccb:	83 c4 10             	add    $0x10,%esp
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c0101cce:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cd1:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c0101cd5:	0f b7 c0             	movzwl %ax,%eax
c0101cd8:	83 ec 08             	sub    $0x8,%esp
c0101cdb:	50                   	push   %eax
c0101cdc:	68 1e 61 10 c0       	push   $0xc010611e
c0101ce1:	e8 b5 e5 ff ff       	call   c010029b <cprintf>
c0101ce6:	83 c4 10             	add    $0x10,%esp
    }
}
c0101ce9:	90                   	nop
c0101cea:	c9                   	leave  
c0101ceb:	c3                   	ret    

c0101cec <print_regs>:

void
print_regs(struct pushregs *regs) {
c0101cec:	f3 0f 1e fb          	endbr32 
c0101cf0:	55                   	push   %ebp
c0101cf1:	89 e5                	mov    %esp,%ebp
c0101cf3:	83 ec 08             	sub    $0x8,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c0101cf6:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cf9:	8b 00                	mov    (%eax),%eax
c0101cfb:	83 ec 08             	sub    $0x8,%esp
c0101cfe:	50                   	push   %eax
c0101cff:	68 31 61 10 c0       	push   $0xc0106131
c0101d04:	e8 92 e5 ff ff       	call   c010029b <cprintf>
c0101d09:	83 c4 10             	add    $0x10,%esp
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c0101d0c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d0f:	8b 40 04             	mov    0x4(%eax),%eax
c0101d12:	83 ec 08             	sub    $0x8,%esp
c0101d15:	50                   	push   %eax
c0101d16:	68 40 61 10 c0       	push   $0xc0106140
c0101d1b:	e8 7b e5 ff ff       	call   c010029b <cprintf>
c0101d20:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c0101d23:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d26:	8b 40 08             	mov    0x8(%eax),%eax
c0101d29:	83 ec 08             	sub    $0x8,%esp
c0101d2c:	50                   	push   %eax
c0101d2d:	68 4f 61 10 c0       	push   $0xc010614f
c0101d32:	e8 64 e5 ff ff       	call   c010029b <cprintf>
c0101d37:	83 c4 10             	add    $0x10,%esp
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c0101d3a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d3d:	8b 40 0c             	mov    0xc(%eax),%eax
c0101d40:	83 ec 08             	sub    $0x8,%esp
c0101d43:	50                   	push   %eax
c0101d44:	68 5e 61 10 c0       	push   $0xc010615e
c0101d49:	e8 4d e5 ff ff       	call   c010029b <cprintf>
c0101d4e:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c0101d51:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d54:	8b 40 10             	mov    0x10(%eax),%eax
c0101d57:	83 ec 08             	sub    $0x8,%esp
c0101d5a:	50                   	push   %eax
c0101d5b:	68 6d 61 10 c0       	push   $0xc010616d
c0101d60:	e8 36 e5 ff ff       	call   c010029b <cprintf>
c0101d65:	83 c4 10             	add    $0x10,%esp
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c0101d68:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d6b:	8b 40 14             	mov    0x14(%eax),%eax
c0101d6e:	83 ec 08             	sub    $0x8,%esp
c0101d71:	50                   	push   %eax
c0101d72:	68 7c 61 10 c0       	push   $0xc010617c
c0101d77:	e8 1f e5 ff ff       	call   c010029b <cprintf>
c0101d7c:	83 c4 10             	add    $0x10,%esp
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c0101d7f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d82:	8b 40 18             	mov    0x18(%eax),%eax
c0101d85:	83 ec 08             	sub    $0x8,%esp
c0101d88:	50                   	push   %eax
c0101d89:	68 8b 61 10 c0       	push   $0xc010618b
c0101d8e:	e8 08 e5 ff ff       	call   c010029b <cprintf>
c0101d93:	83 c4 10             	add    $0x10,%esp
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c0101d96:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d99:	8b 40 1c             	mov    0x1c(%eax),%eax
c0101d9c:	83 ec 08             	sub    $0x8,%esp
c0101d9f:	50                   	push   %eax
c0101da0:	68 9a 61 10 c0       	push   $0xc010619a
c0101da5:	e8 f1 e4 ff ff       	call   c010029b <cprintf>
c0101daa:	83 c4 10             	add    $0x10,%esp
}
c0101dad:	90                   	nop
c0101dae:	c9                   	leave  
c0101daf:	c3                   	ret    

c0101db0 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
c0101db0:	f3 0f 1e fb          	endbr32 
c0101db4:	55                   	push   %ebp
c0101db5:	89 e5                	mov    %esp,%ebp
c0101db7:	83 ec 18             	sub    $0x18,%esp
    char c;

    switch (tf->tf_trapno) {
c0101dba:	8b 45 08             	mov    0x8(%ebp),%eax
c0101dbd:	8b 40 30             	mov    0x30(%eax),%eax
c0101dc0:	83 f8 79             	cmp    $0x79,%eax
c0101dc3:	0f 87 d1 00 00 00    	ja     c0101e9a <trap_dispatch+0xea>
c0101dc9:	83 f8 78             	cmp    $0x78,%eax
c0101dcc:	0f 83 b1 00 00 00    	jae    c0101e83 <trap_dispatch+0xd3>
c0101dd2:	83 f8 2f             	cmp    $0x2f,%eax
c0101dd5:	0f 87 bf 00 00 00    	ja     c0101e9a <trap_dispatch+0xea>
c0101ddb:	83 f8 2e             	cmp    $0x2e,%eax
c0101dde:	0f 83 ec 00 00 00    	jae    c0101ed0 <trap_dispatch+0x120>
c0101de4:	83 f8 24             	cmp    $0x24,%eax
c0101de7:	74 52                	je     c0101e3b <trap_dispatch+0x8b>
c0101de9:	83 f8 24             	cmp    $0x24,%eax
c0101dec:	0f 87 a8 00 00 00    	ja     c0101e9a <trap_dispatch+0xea>
c0101df2:	83 f8 20             	cmp    $0x20,%eax
c0101df5:	74 0a                	je     c0101e01 <trap_dispatch+0x51>
c0101df7:	83 f8 21             	cmp    $0x21,%eax
c0101dfa:	74 63                	je     c0101e5f <trap_dispatch+0xaf>
c0101dfc:	e9 99 00 00 00       	jmp    c0101e9a <trap_dispatch+0xea>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks ++;
c0101e01:	a1 0c cf 11 c0       	mov    0xc011cf0c,%eax
c0101e06:	83 c0 01             	add    $0x1,%eax
c0101e09:	a3 0c cf 11 c0       	mov    %eax,0xc011cf0c
        if (ticks % TICK_NUM == 0) {
c0101e0e:	8b 0d 0c cf 11 c0    	mov    0xc011cf0c,%ecx
c0101e14:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
c0101e19:	89 c8                	mov    %ecx,%eax
c0101e1b:	f7 e2                	mul    %edx
c0101e1d:	89 d0                	mov    %edx,%eax
c0101e1f:	c1 e8 05             	shr    $0x5,%eax
c0101e22:	6b c0 64             	imul   $0x64,%eax,%eax
c0101e25:	29 c1                	sub    %eax,%ecx
c0101e27:	89 c8                	mov    %ecx,%eax
c0101e29:	85 c0                	test   %eax,%eax
c0101e2b:	0f 85 a2 00 00 00    	jne    c0101ed3 <trap_dispatch+0x123>
            print_ticks();
c0101e31:	e8 52 fb ff ff       	call   c0101988 <print_ticks>
        }
        break;
c0101e36:	e9 98 00 00 00       	jmp    c0101ed3 <trap_dispatch+0x123>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c0101e3b:	e8 db f8 ff ff       	call   c010171b <cons_getc>
c0101e40:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c0101e43:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101e47:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101e4b:	83 ec 04             	sub    $0x4,%esp
c0101e4e:	52                   	push   %edx
c0101e4f:	50                   	push   %eax
c0101e50:	68 a9 61 10 c0       	push   $0xc01061a9
c0101e55:	e8 41 e4 ff ff       	call   c010029b <cprintf>
c0101e5a:	83 c4 10             	add    $0x10,%esp
        break;
c0101e5d:	eb 75                	jmp    c0101ed4 <trap_dispatch+0x124>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c0101e5f:	e8 b7 f8 ff ff       	call   c010171b <cons_getc>
c0101e64:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c0101e67:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101e6b:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101e6f:	83 ec 04             	sub    $0x4,%esp
c0101e72:	52                   	push   %edx
c0101e73:	50                   	push   %eax
c0101e74:	68 bb 61 10 c0       	push   $0xc01061bb
c0101e79:	e8 1d e4 ff ff       	call   c010029b <cprintf>
c0101e7e:	83 c4 10             	add    $0x10,%esp
        break;
c0101e81:	eb 51                	jmp    c0101ed4 <trap_dispatch+0x124>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
c0101e83:	83 ec 04             	sub    $0x4,%esp
c0101e86:	68 ca 61 10 c0       	push   $0xc01061ca
c0101e8b:	68 ac 00 00 00       	push   $0xac
c0101e90:	68 ee 5f 10 c0       	push   $0xc0105fee
c0101e95:	e8 7c e5 ff ff       	call   c0100416 <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c0101e9a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e9d:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101ea1:	0f b7 c0             	movzwl %ax,%eax
c0101ea4:	83 e0 03             	and    $0x3,%eax
c0101ea7:	85 c0                	test   %eax,%eax
c0101ea9:	75 29                	jne    c0101ed4 <trap_dispatch+0x124>
            print_trapframe(tf);
c0101eab:	83 ec 0c             	sub    $0xc,%esp
c0101eae:	ff 75 08             	pushl  0x8(%ebp)
c0101eb1:	e8 59 fc ff ff       	call   c0101b0f <print_trapframe>
c0101eb6:	83 c4 10             	add    $0x10,%esp
            panic("unexpected trap in kernel.\n");
c0101eb9:	83 ec 04             	sub    $0x4,%esp
c0101ebc:	68 da 61 10 c0       	push   $0xc01061da
c0101ec1:	68 b6 00 00 00       	push   $0xb6
c0101ec6:	68 ee 5f 10 c0       	push   $0xc0105fee
c0101ecb:	e8 46 e5 ff ff       	call   c0100416 <__panic>
        break;
c0101ed0:	90                   	nop
c0101ed1:	eb 01                	jmp    c0101ed4 <trap_dispatch+0x124>
        break;
c0101ed3:	90                   	nop
        }
    }
}
c0101ed4:	90                   	nop
c0101ed5:	c9                   	leave  
c0101ed6:	c3                   	ret    

c0101ed7 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c0101ed7:	f3 0f 1e fb          	endbr32 
c0101edb:	55                   	push   %ebp
c0101edc:	89 e5                	mov    %esp,%ebp
c0101ede:	83 ec 08             	sub    $0x8,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c0101ee1:	83 ec 0c             	sub    $0xc,%esp
c0101ee4:	ff 75 08             	pushl  0x8(%ebp)
c0101ee7:	e8 c4 fe ff ff       	call   c0101db0 <trap_dispatch>
c0101eec:	83 c4 10             	add    $0x10,%esp
}
c0101eef:	90                   	nop
c0101ef0:	c9                   	leave  
c0101ef1:	c3                   	ret    

c0101ef2 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c0101ef2:	6a 00                	push   $0x0
  pushl $0
c0101ef4:	6a 00                	push   $0x0
  jmp __alltraps
c0101ef6:	e9 67 0a 00 00       	jmp    c0102962 <__alltraps>

c0101efb <vector1>:
.globl vector1
vector1:
  pushl $0
c0101efb:	6a 00                	push   $0x0
  pushl $1
c0101efd:	6a 01                	push   $0x1
  jmp __alltraps
c0101eff:	e9 5e 0a 00 00       	jmp    c0102962 <__alltraps>

c0101f04 <vector2>:
.globl vector2
vector2:
  pushl $0
c0101f04:	6a 00                	push   $0x0
  pushl $2
c0101f06:	6a 02                	push   $0x2
  jmp __alltraps
c0101f08:	e9 55 0a 00 00       	jmp    c0102962 <__alltraps>

c0101f0d <vector3>:
.globl vector3
vector3:
  pushl $0
c0101f0d:	6a 00                	push   $0x0
  pushl $3
c0101f0f:	6a 03                	push   $0x3
  jmp __alltraps
c0101f11:	e9 4c 0a 00 00       	jmp    c0102962 <__alltraps>

c0101f16 <vector4>:
.globl vector4
vector4:
  pushl $0
c0101f16:	6a 00                	push   $0x0
  pushl $4
c0101f18:	6a 04                	push   $0x4
  jmp __alltraps
c0101f1a:	e9 43 0a 00 00       	jmp    c0102962 <__alltraps>

c0101f1f <vector5>:
.globl vector5
vector5:
  pushl $0
c0101f1f:	6a 00                	push   $0x0
  pushl $5
c0101f21:	6a 05                	push   $0x5
  jmp __alltraps
c0101f23:	e9 3a 0a 00 00       	jmp    c0102962 <__alltraps>

c0101f28 <vector6>:
.globl vector6
vector6:
  pushl $0
c0101f28:	6a 00                	push   $0x0
  pushl $6
c0101f2a:	6a 06                	push   $0x6
  jmp __alltraps
c0101f2c:	e9 31 0a 00 00       	jmp    c0102962 <__alltraps>

c0101f31 <vector7>:
.globl vector7
vector7:
  pushl $0
c0101f31:	6a 00                	push   $0x0
  pushl $7
c0101f33:	6a 07                	push   $0x7
  jmp __alltraps
c0101f35:	e9 28 0a 00 00       	jmp    c0102962 <__alltraps>

c0101f3a <vector8>:
.globl vector8
vector8:
  pushl $8
c0101f3a:	6a 08                	push   $0x8
  jmp __alltraps
c0101f3c:	e9 21 0a 00 00       	jmp    c0102962 <__alltraps>

c0101f41 <vector9>:
.globl vector9
vector9:
  pushl $9
c0101f41:	6a 09                	push   $0x9
  jmp __alltraps
c0101f43:	e9 1a 0a 00 00       	jmp    c0102962 <__alltraps>

c0101f48 <vector10>:
.globl vector10
vector10:
  pushl $10
c0101f48:	6a 0a                	push   $0xa
  jmp __alltraps
c0101f4a:	e9 13 0a 00 00       	jmp    c0102962 <__alltraps>

c0101f4f <vector11>:
.globl vector11
vector11:
  pushl $11
c0101f4f:	6a 0b                	push   $0xb
  jmp __alltraps
c0101f51:	e9 0c 0a 00 00       	jmp    c0102962 <__alltraps>

c0101f56 <vector12>:
.globl vector12
vector12:
  pushl $12
c0101f56:	6a 0c                	push   $0xc
  jmp __alltraps
c0101f58:	e9 05 0a 00 00       	jmp    c0102962 <__alltraps>

c0101f5d <vector13>:
.globl vector13
vector13:
  pushl $13
c0101f5d:	6a 0d                	push   $0xd
  jmp __alltraps
c0101f5f:	e9 fe 09 00 00       	jmp    c0102962 <__alltraps>

c0101f64 <vector14>:
.globl vector14
vector14:
  pushl $14
c0101f64:	6a 0e                	push   $0xe
  jmp __alltraps
c0101f66:	e9 f7 09 00 00       	jmp    c0102962 <__alltraps>

c0101f6b <vector15>:
.globl vector15
vector15:
  pushl $0
c0101f6b:	6a 00                	push   $0x0
  pushl $15
c0101f6d:	6a 0f                	push   $0xf
  jmp __alltraps
c0101f6f:	e9 ee 09 00 00       	jmp    c0102962 <__alltraps>

c0101f74 <vector16>:
.globl vector16
vector16:
  pushl $0
c0101f74:	6a 00                	push   $0x0
  pushl $16
c0101f76:	6a 10                	push   $0x10
  jmp __alltraps
c0101f78:	e9 e5 09 00 00       	jmp    c0102962 <__alltraps>

c0101f7d <vector17>:
.globl vector17
vector17:
  pushl $17
c0101f7d:	6a 11                	push   $0x11
  jmp __alltraps
c0101f7f:	e9 de 09 00 00       	jmp    c0102962 <__alltraps>

c0101f84 <vector18>:
.globl vector18
vector18:
  pushl $0
c0101f84:	6a 00                	push   $0x0
  pushl $18
c0101f86:	6a 12                	push   $0x12
  jmp __alltraps
c0101f88:	e9 d5 09 00 00       	jmp    c0102962 <__alltraps>

c0101f8d <vector19>:
.globl vector19
vector19:
  pushl $0
c0101f8d:	6a 00                	push   $0x0
  pushl $19
c0101f8f:	6a 13                	push   $0x13
  jmp __alltraps
c0101f91:	e9 cc 09 00 00       	jmp    c0102962 <__alltraps>

c0101f96 <vector20>:
.globl vector20
vector20:
  pushl $0
c0101f96:	6a 00                	push   $0x0
  pushl $20
c0101f98:	6a 14                	push   $0x14
  jmp __alltraps
c0101f9a:	e9 c3 09 00 00       	jmp    c0102962 <__alltraps>

c0101f9f <vector21>:
.globl vector21
vector21:
  pushl $0
c0101f9f:	6a 00                	push   $0x0
  pushl $21
c0101fa1:	6a 15                	push   $0x15
  jmp __alltraps
c0101fa3:	e9 ba 09 00 00       	jmp    c0102962 <__alltraps>

c0101fa8 <vector22>:
.globl vector22
vector22:
  pushl $0
c0101fa8:	6a 00                	push   $0x0
  pushl $22
c0101faa:	6a 16                	push   $0x16
  jmp __alltraps
c0101fac:	e9 b1 09 00 00       	jmp    c0102962 <__alltraps>

c0101fb1 <vector23>:
.globl vector23
vector23:
  pushl $0
c0101fb1:	6a 00                	push   $0x0
  pushl $23
c0101fb3:	6a 17                	push   $0x17
  jmp __alltraps
c0101fb5:	e9 a8 09 00 00       	jmp    c0102962 <__alltraps>

c0101fba <vector24>:
.globl vector24
vector24:
  pushl $0
c0101fba:	6a 00                	push   $0x0
  pushl $24
c0101fbc:	6a 18                	push   $0x18
  jmp __alltraps
c0101fbe:	e9 9f 09 00 00       	jmp    c0102962 <__alltraps>

c0101fc3 <vector25>:
.globl vector25
vector25:
  pushl $0
c0101fc3:	6a 00                	push   $0x0
  pushl $25
c0101fc5:	6a 19                	push   $0x19
  jmp __alltraps
c0101fc7:	e9 96 09 00 00       	jmp    c0102962 <__alltraps>

c0101fcc <vector26>:
.globl vector26
vector26:
  pushl $0
c0101fcc:	6a 00                	push   $0x0
  pushl $26
c0101fce:	6a 1a                	push   $0x1a
  jmp __alltraps
c0101fd0:	e9 8d 09 00 00       	jmp    c0102962 <__alltraps>

c0101fd5 <vector27>:
.globl vector27
vector27:
  pushl $0
c0101fd5:	6a 00                	push   $0x0
  pushl $27
c0101fd7:	6a 1b                	push   $0x1b
  jmp __alltraps
c0101fd9:	e9 84 09 00 00       	jmp    c0102962 <__alltraps>

c0101fde <vector28>:
.globl vector28
vector28:
  pushl $0
c0101fde:	6a 00                	push   $0x0
  pushl $28
c0101fe0:	6a 1c                	push   $0x1c
  jmp __alltraps
c0101fe2:	e9 7b 09 00 00       	jmp    c0102962 <__alltraps>

c0101fe7 <vector29>:
.globl vector29
vector29:
  pushl $0
c0101fe7:	6a 00                	push   $0x0
  pushl $29
c0101fe9:	6a 1d                	push   $0x1d
  jmp __alltraps
c0101feb:	e9 72 09 00 00       	jmp    c0102962 <__alltraps>

c0101ff0 <vector30>:
.globl vector30
vector30:
  pushl $0
c0101ff0:	6a 00                	push   $0x0
  pushl $30
c0101ff2:	6a 1e                	push   $0x1e
  jmp __alltraps
c0101ff4:	e9 69 09 00 00       	jmp    c0102962 <__alltraps>

c0101ff9 <vector31>:
.globl vector31
vector31:
  pushl $0
c0101ff9:	6a 00                	push   $0x0
  pushl $31
c0101ffb:	6a 1f                	push   $0x1f
  jmp __alltraps
c0101ffd:	e9 60 09 00 00       	jmp    c0102962 <__alltraps>

c0102002 <vector32>:
.globl vector32
vector32:
  pushl $0
c0102002:	6a 00                	push   $0x0
  pushl $32
c0102004:	6a 20                	push   $0x20
  jmp __alltraps
c0102006:	e9 57 09 00 00       	jmp    c0102962 <__alltraps>

c010200b <vector33>:
.globl vector33
vector33:
  pushl $0
c010200b:	6a 00                	push   $0x0
  pushl $33
c010200d:	6a 21                	push   $0x21
  jmp __alltraps
c010200f:	e9 4e 09 00 00       	jmp    c0102962 <__alltraps>

c0102014 <vector34>:
.globl vector34
vector34:
  pushl $0
c0102014:	6a 00                	push   $0x0
  pushl $34
c0102016:	6a 22                	push   $0x22
  jmp __alltraps
c0102018:	e9 45 09 00 00       	jmp    c0102962 <__alltraps>

c010201d <vector35>:
.globl vector35
vector35:
  pushl $0
c010201d:	6a 00                	push   $0x0
  pushl $35
c010201f:	6a 23                	push   $0x23
  jmp __alltraps
c0102021:	e9 3c 09 00 00       	jmp    c0102962 <__alltraps>

c0102026 <vector36>:
.globl vector36
vector36:
  pushl $0
c0102026:	6a 00                	push   $0x0
  pushl $36
c0102028:	6a 24                	push   $0x24
  jmp __alltraps
c010202a:	e9 33 09 00 00       	jmp    c0102962 <__alltraps>

c010202f <vector37>:
.globl vector37
vector37:
  pushl $0
c010202f:	6a 00                	push   $0x0
  pushl $37
c0102031:	6a 25                	push   $0x25
  jmp __alltraps
c0102033:	e9 2a 09 00 00       	jmp    c0102962 <__alltraps>

c0102038 <vector38>:
.globl vector38
vector38:
  pushl $0
c0102038:	6a 00                	push   $0x0
  pushl $38
c010203a:	6a 26                	push   $0x26
  jmp __alltraps
c010203c:	e9 21 09 00 00       	jmp    c0102962 <__alltraps>

c0102041 <vector39>:
.globl vector39
vector39:
  pushl $0
c0102041:	6a 00                	push   $0x0
  pushl $39
c0102043:	6a 27                	push   $0x27
  jmp __alltraps
c0102045:	e9 18 09 00 00       	jmp    c0102962 <__alltraps>

c010204a <vector40>:
.globl vector40
vector40:
  pushl $0
c010204a:	6a 00                	push   $0x0
  pushl $40
c010204c:	6a 28                	push   $0x28
  jmp __alltraps
c010204e:	e9 0f 09 00 00       	jmp    c0102962 <__alltraps>

c0102053 <vector41>:
.globl vector41
vector41:
  pushl $0
c0102053:	6a 00                	push   $0x0
  pushl $41
c0102055:	6a 29                	push   $0x29
  jmp __alltraps
c0102057:	e9 06 09 00 00       	jmp    c0102962 <__alltraps>

c010205c <vector42>:
.globl vector42
vector42:
  pushl $0
c010205c:	6a 00                	push   $0x0
  pushl $42
c010205e:	6a 2a                	push   $0x2a
  jmp __alltraps
c0102060:	e9 fd 08 00 00       	jmp    c0102962 <__alltraps>

c0102065 <vector43>:
.globl vector43
vector43:
  pushl $0
c0102065:	6a 00                	push   $0x0
  pushl $43
c0102067:	6a 2b                	push   $0x2b
  jmp __alltraps
c0102069:	e9 f4 08 00 00       	jmp    c0102962 <__alltraps>

c010206e <vector44>:
.globl vector44
vector44:
  pushl $0
c010206e:	6a 00                	push   $0x0
  pushl $44
c0102070:	6a 2c                	push   $0x2c
  jmp __alltraps
c0102072:	e9 eb 08 00 00       	jmp    c0102962 <__alltraps>

c0102077 <vector45>:
.globl vector45
vector45:
  pushl $0
c0102077:	6a 00                	push   $0x0
  pushl $45
c0102079:	6a 2d                	push   $0x2d
  jmp __alltraps
c010207b:	e9 e2 08 00 00       	jmp    c0102962 <__alltraps>

c0102080 <vector46>:
.globl vector46
vector46:
  pushl $0
c0102080:	6a 00                	push   $0x0
  pushl $46
c0102082:	6a 2e                	push   $0x2e
  jmp __alltraps
c0102084:	e9 d9 08 00 00       	jmp    c0102962 <__alltraps>

c0102089 <vector47>:
.globl vector47
vector47:
  pushl $0
c0102089:	6a 00                	push   $0x0
  pushl $47
c010208b:	6a 2f                	push   $0x2f
  jmp __alltraps
c010208d:	e9 d0 08 00 00       	jmp    c0102962 <__alltraps>

c0102092 <vector48>:
.globl vector48
vector48:
  pushl $0
c0102092:	6a 00                	push   $0x0
  pushl $48
c0102094:	6a 30                	push   $0x30
  jmp __alltraps
c0102096:	e9 c7 08 00 00       	jmp    c0102962 <__alltraps>

c010209b <vector49>:
.globl vector49
vector49:
  pushl $0
c010209b:	6a 00                	push   $0x0
  pushl $49
c010209d:	6a 31                	push   $0x31
  jmp __alltraps
c010209f:	e9 be 08 00 00       	jmp    c0102962 <__alltraps>

c01020a4 <vector50>:
.globl vector50
vector50:
  pushl $0
c01020a4:	6a 00                	push   $0x0
  pushl $50
c01020a6:	6a 32                	push   $0x32
  jmp __alltraps
c01020a8:	e9 b5 08 00 00       	jmp    c0102962 <__alltraps>

c01020ad <vector51>:
.globl vector51
vector51:
  pushl $0
c01020ad:	6a 00                	push   $0x0
  pushl $51
c01020af:	6a 33                	push   $0x33
  jmp __alltraps
c01020b1:	e9 ac 08 00 00       	jmp    c0102962 <__alltraps>

c01020b6 <vector52>:
.globl vector52
vector52:
  pushl $0
c01020b6:	6a 00                	push   $0x0
  pushl $52
c01020b8:	6a 34                	push   $0x34
  jmp __alltraps
c01020ba:	e9 a3 08 00 00       	jmp    c0102962 <__alltraps>

c01020bf <vector53>:
.globl vector53
vector53:
  pushl $0
c01020bf:	6a 00                	push   $0x0
  pushl $53
c01020c1:	6a 35                	push   $0x35
  jmp __alltraps
c01020c3:	e9 9a 08 00 00       	jmp    c0102962 <__alltraps>

c01020c8 <vector54>:
.globl vector54
vector54:
  pushl $0
c01020c8:	6a 00                	push   $0x0
  pushl $54
c01020ca:	6a 36                	push   $0x36
  jmp __alltraps
c01020cc:	e9 91 08 00 00       	jmp    c0102962 <__alltraps>

c01020d1 <vector55>:
.globl vector55
vector55:
  pushl $0
c01020d1:	6a 00                	push   $0x0
  pushl $55
c01020d3:	6a 37                	push   $0x37
  jmp __alltraps
c01020d5:	e9 88 08 00 00       	jmp    c0102962 <__alltraps>

c01020da <vector56>:
.globl vector56
vector56:
  pushl $0
c01020da:	6a 00                	push   $0x0
  pushl $56
c01020dc:	6a 38                	push   $0x38
  jmp __alltraps
c01020de:	e9 7f 08 00 00       	jmp    c0102962 <__alltraps>

c01020e3 <vector57>:
.globl vector57
vector57:
  pushl $0
c01020e3:	6a 00                	push   $0x0
  pushl $57
c01020e5:	6a 39                	push   $0x39
  jmp __alltraps
c01020e7:	e9 76 08 00 00       	jmp    c0102962 <__alltraps>

c01020ec <vector58>:
.globl vector58
vector58:
  pushl $0
c01020ec:	6a 00                	push   $0x0
  pushl $58
c01020ee:	6a 3a                	push   $0x3a
  jmp __alltraps
c01020f0:	e9 6d 08 00 00       	jmp    c0102962 <__alltraps>

c01020f5 <vector59>:
.globl vector59
vector59:
  pushl $0
c01020f5:	6a 00                	push   $0x0
  pushl $59
c01020f7:	6a 3b                	push   $0x3b
  jmp __alltraps
c01020f9:	e9 64 08 00 00       	jmp    c0102962 <__alltraps>

c01020fe <vector60>:
.globl vector60
vector60:
  pushl $0
c01020fe:	6a 00                	push   $0x0
  pushl $60
c0102100:	6a 3c                	push   $0x3c
  jmp __alltraps
c0102102:	e9 5b 08 00 00       	jmp    c0102962 <__alltraps>

c0102107 <vector61>:
.globl vector61
vector61:
  pushl $0
c0102107:	6a 00                	push   $0x0
  pushl $61
c0102109:	6a 3d                	push   $0x3d
  jmp __alltraps
c010210b:	e9 52 08 00 00       	jmp    c0102962 <__alltraps>

c0102110 <vector62>:
.globl vector62
vector62:
  pushl $0
c0102110:	6a 00                	push   $0x0
  pushl $62
c0102112:	6a 3e                	push   $0x3e
  jmp __alltraps
c0102114:	e9 49 08 00 00       	jmp    c0102962 <__alltraps>

c0102119 <vector63>:
.globl vector63
vector63:
  pushl $0
c0102119:	6a 00                	push   $0x0
  pushl $63
c010211b:	6a 3f                	push   $0x3f
  jmp __alltraps
c010211d:	e9 40 08 00 00       	jmp    c0102962 <__alltraps>

c0102122 <vector64>:
.globl vector64
vector64:
  pushl $0
c0102122:	6a 00                	push   $0x0
  pushl $64
c0102124:	6a 40                	push   $0x40
  jmp __alltraps
c0102126:	e9 37 08 00 00       	jmp    c0102962 <__alltraps>

c010212b <vector65>:
.globl vector65
vector65:
  pushl $0
c010212b:	6a 00                	push   $0x0
  pushl $65
c010212d:	6a 41                	push   $0x41
  jmp __alltraps
c010212f:	e9 2e 08 00 00       	jmp    c0102962 <__alltraps>

c0102134 <vector66>:
.globl vector66
vector66:
  pushl $0
c0102134:	6a 00                	push   $0x0
  pushl $66
c0102136:	6a 42                	push   $0x42
  jmp __alltraps
c0102138:	e9 25 08 00 00       	jmp    c0102962 <__alltraps>

c010213d <vector67>:
.globl vector67
vector67:
  pushl $0
c010213d:	6a 00                	push   $0x0
  pushl $67
c010213f:	6a 43                	push   $0x43
  jmp __alltraps
c0102141:	e9 1c 08 00 00       	jmp    c0102962 <__alltraps>

c0102146 <vector68>:
.globl vector68
vector68:
  pushl $0
c0102146:	6a 00                	push   $0x0
  pushl $68
c0102148:	6a 44                	push   $0x44
  jmp __alltraps
c010214a:	e9 13 08 00 00       	jmp    c0102962 <__alltraps>

c010214f <vector69>:
.globl vector69
vector69:
  pushl $0
c010214f:	6a 00                	push   $0x0
  pushl $69
c0102151:	6a 45                	push   $0x45
  jmp __alltraps
c0102153:	e9 0a 08 00 00       	jmp    c0102962 <__alltraps>

c0102158 <vector70>:
.globl vector70
vector70:
  pushl $0
c0102158:	6a 00                	push   $0x0
  pushl $70
c010215a:	6a 46                	push   $0x46
  jmp __alltraps
c010215c:	e9 01 08 00 00       	jmp    c0102962 <__alltraps>

c0102161 <vector71>:
.globl vector71
vector71:
  pushl $0
c0102161:	6a 00                	push   $0x0
  pushl $71
c0102163:	6a 47                	push   $0x47
  jmp __alltraps
c0102165:	e9 f8 07 00 00       	jmp    c0102962 <__alltraps>

c010216a <vector72>:
.globl vector72
vector72:
  pushl $0
c010216a:	6a 00                	push   $0x0
  pushl $72
c010216c:	6a 48                	push   $0x48
  jmp __alltraps
c010216e:	e9 ef 07 00 00       	jmp    c0102962 <__alltraps>

c0102173 <vector73>:
.globl vector73
vector73:
  pushl $0
c0102173:	6a 00                	push   $0x0
  pushl $73
c0102175:	6a 49                	push   $0x49
  jmp __alltraps
c0102177:	e9 e6 07 00 00       	jmp    c0102962 <__alltraps>

c010217c <vector74>:
.globl vector74
vector74:
  pushl $0
c010217c:	6a 00                	push   $0x0
  pushl $74
c010217e:	6a 4a                	push   $0x4a
  jmp __alltraps
c0102180:	e9 dd 07 00 00       	jmp    c0102962 <__alltraps>

c0102185 <vector75>:
.globl vector75
vector75:
  pushl $0
c0102185:	6a 00                	push   $0x0
  pushl $75
c0102187:	6a 4b                	push   $0x4b
  jmp __alltraps
c0102189:	e9 d4 07 00 00       	jmp    c0102962 <__alltraps>

c010218e <vector76>:
.globl vector76
vector76:
  pushl $0
c010218e:	6a 00                	push   $0x0
  pushl $76
c0102190:	6a 4c                	push   $0x4c
  jmp __alltraps
c0102192:	e9 cb 07 00 00       	jmp    c0102962 <__alltraps>

c0102197 <vector77>:
.globl vector77
vector77:
  pushl $0
c0102197:	6a 00                	push   $0x0
  pushl $77
c0102199:	6a 4d                	push   $0x4d
  jmp __alltraps
c010219b:	e9 c2 07 00 00       	jmp    c0102962 <__alltraps>

c01021a0 <vector78>:
.globl vector78
vector78:
  pushl $0
c01021a0:	6a 00                	push   $0x0
  pushl $78
c01021a2:	6a 4e                	push   $0x4e
  jmp __alltraps
c01021a4:	e9 b9 07 00 00       	jmp    c0102962 <__alltraps>

c01021a9 <vector79>:
.globl vector79
vector79:
  pushl $0
c01021a9:	6a 00                	push   $0x0
  pushl $79
c01021ab:	6a 4f                	push   $0x4f
  jmp __alltraps
c01021ad:	e9 b0 07 00 00       	jmp    c0102962 <__alltraps>

c01021b2 <vector80>:
.globl vector80
vector80:
  pushl $0
c01021b2:	6a 00                	push   $0x0
  pushl $80
c01021b4:	6a 50                	push   $0x50
  jmp __alltraps
c01021b6:	e9 a7 07 00 00       	jmp    c0102962 <__alltraps>

c01021bb <vector81>:
.globl vector81
vector81:
  pushl $0
c01021bb:	6a 00                	push   $0x0
  pushl $81
c01021bd:	6a 51                	push   $0x51
  jmp __alltraps
c01021bf:	e9 9e 07 00 00       	jmp    c0102962 <__alltraps>

c01021c4 <vector82>:
.globl vector82
vector82:
  pushl $0
c01021c4:	6a 00                	push   $0x0
  pushl $82
c01021c6:	6a 52                	push   $0x52
  jmp __alltraps
c01021c8:	e9 95 07 00 00       	jmp    c0102962 <__alltraps>

c01021cd <vector83>:
.globl vector83
vector83:
  pushl $0
c01021cd:	6a 00                	push   $0x0
  pushl $83
c01021cf:	6a 53                	push   $0x53
  jmp __alltraps
c01021d1:	e9 8c 07 00 00       	jmp    c0102962 <__alltraps>

c01021d6 <vector84>:
.globl vector84
vector84:
  pushl $0
c01021d6:	6a 00                	push   $0x0
  pushl $84
c01021d8:	6a 54                	push   $0x54
  jmp __alltraps
c01021da:	e9 83 07 00 00       	jmp    c0102962 <__alltraps>

c01021df <vector85>:
.globl vector85
vector85:
  pushl $0
c01021df:	6a 00                	push   $0x0
  pushl $85
c01021e1:	6a 55                	push   $0x55
  jmp __alltraps
c01021e3:	e9 7a 07 00 00       	jmp    c0102962 <__alltraps>

c01021e8 <vector86>:
.globl vector86
vector86:
  pushl $0
c01021e8:	6a 00                	push   $0x0
  pushl $86
c01021ea:	6a 56                	push   $0x56
  jmp __alltraps
c01021ec:	e9 71 07 00 00       	jmp    c0102962 <__alltraps>

c01021f1 <vector87>:
.globl vector87
vector87:
  pushl $0
c01021f1:	6a 00                	push   $0x0
  pushl $87
c01021f3:	6a 57                	push   $0x57
  jmp __alltraps
c01021f5:	e9 68 07 00 00       	jmp    c0102962 <__alltraps>

c01021fa <vector88>:
.globl vector88
vector88:
  pushl $0
c01021fa:	6a 00                	push   $0x0
  pushl $88
c01021fc:	6a 58                	push   $0x58
  jmp __alltraps
c01021fe:	e9 5f 07 00 00       	jmp    c0102962 <__alltraps>

c0102203 <vector89>:
.globl vector89
vector89:
  pushl $0
c0102203:	6a 00                	push   $0x0
  pushl $89
c0102205:	6a 59                	push   $0x59
  jmp __alltraps
c0102207:	e9 56 07 00 00       	jmp    c0102962 <__alltraps>

c010220c <vector90>:
.globl vector90
vector90:
  pushl $0
c010220c:	6a 00                	push   $0x0
  pushl $90
c010220e:	6a 5a                	push   $0x5a
  jmp __alltraps
c0102210:	e9 4d 07 00 00       	jmp    c0102962 <__alltraps>

c0102215 <vector91>:
.globl vector91
vector91:
  pushl $0
c0102215:	6a 00                	push   $0x0
  pushl $91
c0102217:	6a 5b                	push   $0x5b
  jmp __alltraps
c0102219:	e9 44 07 00 00       	jmp    c0102962 <__alltraps>

c010221e <vector92>:
.globl vector92
vector92:
  pushl $0
c010221e:	6a 00                	push   $0x0
  pushl $92
c0102220:	6a 5c                	push   $0x5c
  jmp __alltraps
c0102222:	e9 3b 07 00 00       	jmp    c0102962 <__alltraps>

c0102227 <vector93>:
.globl vector93
vector93:
  pushl $0
c0102227:	6a 00                	push   $0x0
  pushl $93
c0102229:	6a 5d                	push   $0x5d
  jmp __alltraps
c010222b:	e9 32 07 00 00       	jmp    c0102962 <__alltraps>

c0102230 <vector94>:
.globl vector94
vector94:
  pushl $0
c0102230:	6a 00                	push   $0x0
  pushl $94
c0102232:	6a 5e                	push   $0x5e
  jmp __alltraps
c0102234:	e9 29 07 00 00       	jmp    c0102962 <__alltraps>

c0102239 <vector95>:
.globl vector95
vector95:
  pushl $0
c0102239:	6a 00                	push   $0x0
  pushl $95
c010223b:	6a 5f                	push   $0x5f
  jmp __alltraps
c010223d:	e9 20 07 00 00       	jmp    c0102962 <__alltraps>

c0102242 <vector96>:
.globl vector96
vector96:
  pushl $0
c0102242:	6a 00                	push   $0x0
  pushl $96
c0102244:	6a 60                	push   $0x60
  jmp __alltraps
c0102246:	e9 17 07 00 00       	jmp    c0102962 <__alltraps>

c010224b <vector97>:
.globl vector97
vector97:
  pushl $0
c010224b:	6a 00                	push   $0x0
  pushl $97
c010224d:	6a 61                	push   $0x61
  jmp __alltraps
c010224f:	e9 0e 07 00 00       	jmp    c0102962 <__alltraps>

c0102254 <vector98>:
.globl vector98
vector98:
  pushl $0
c0102254:	6a 00                	push   $0x0
  pushl $98
c0102256:	6a 62                	push   $0x62
  jmp __alltraps
c0102258:	e9 05 07 00 00       	jmp    c0102962 <__alltraps>

c010225d <vector99>:
.globl vector99
vector99:
  pushl $0
c010225d:	6a 00                	push   $0x0
  pushl $99
c010225f:	6a 63                	push   $0x63
  jmp __alltraps
c0102261:	e9 fc 06 00 00       	jmp    c0102962 <__alltraps>

c0102266 <vector100>:
.globl vector100
vector100:
  pushl $0
c0102266:	6a 00                	push   $0x0
  pushl $100
c0102268:	6a 64                	push   $0x64
  jmp __alltraps
c010226a:	e9 f3 06 00 00       	jmp    c0102962 <__alltraps>

c010226f <vector101>:
.globl vector101
vector101:
  pushl $0
c010226f:	6a 00                	push   $0x0
  pushl $101
c0102271:	6a 65                	push   $0x65
  jmp __alltraps
c0102273:	e9 ea 06 00 00       	jmp    c0102962 <__alltraps>

c0102278 <vector102>:
.globl vector102
vector102:
  pushl $0
c0102278:	6a 00                	push   $0x0
  pushl $102
c010227a:	6a 66                	push   $0x66
  jmp __alltraps
c010227c:	e9 e1 06 00 00       	jmp    c0102962 <__alltraps>

c0102281 <vector103>:
.globl vector103
vector103:
  pushl $0
c0102281:	6a 00                	push   $0x0
  pushl $103
c0102283:	6a 67                	push   $0x67
  jmp __alltraps
c0102285:	e9 d8 06 00 00       	jmp    c0102962 <__alltraps>

c010228a <vector104>:
.globl vector104
vector104:
  pushl $0
c010228a:	6a 00                	push   $0x0
  pushl $104
c010228c:	6a 68                	push   $0x68
  jmp __alltraps
c010228e:	e9 cf 06 00 00       	jmp    c0102962 <__alltraps>

c0102293 <vector105>:
.globl vector105
vector105:
  pushl $0
c0102293:	6a 00                	push   $0x0
  pushl $105
c0102295:	6a 69                	push   $0x69
  jmp __alltraps
c0102297:	e9 c6 06 00 00       	jmp    c0102962 <__alltraps>

c010229c <vector106>:
.globl vector106
vector106:
  pushl $0
c010229c:	6a 00                	push   $0x0
  pushl $106
c010229e:	6a 6a                	push   $0x6a
  jmp __alltraps
c01022a0:	e9 bd 06 00 00       	jmp    c0102962 <__alltraps>

c01022a5 <vector107>:
.globl vector107
vector107:
  pushl $0
c01022a5:	6a 00                	push   $0x0
  pushl $107
c01022a7:	6a 6b                	push   $0x6b
  jmp __alltraps
c01022a9:	e9 b4 06 00 00       	jmp    c0102962 <__alltraps>

c01022ae <vector108>:
.globl vector108
vector108:
  pushl $0
c01022ae:	6a 00                	push   $0x0
  pushl $108
c01022b0:	6a 6c                	push   $0x6c
  jmp __alltraps
c01022b2:	e9 ab 06 00 00       	jmp    c0102962 <__alltraps>

c01022b7 <vector109>:
.globl vector109
vector109:
  pushl $0
c01022b7:	6a 00                	push   $0x0
  pushl $109
c01022b9:	6a 6d                	push   $0x6d
  jmp __alltraps
c01022bb:	e9 a2 06 00 00       	jmp    c0102962 <__alltraps>

c01022c0 <vector110>:
.globl vector110
vector110:
  pushl $0
c01022c0:	6a 00                	push   $0x0
  pushl $110
c01022c2:	6a 6e                	push   $0x6e
  jmp __alltraps
c01022c4:	e9 99 06 00 00       	jmp    c0102962 <__alltraps>

c01022c9 <vector111>:
.globl vector111
vector111:
  pushl $0
c01022c9:	6a 00                	push   $0x0
  pushl $111
c01022cb:	6a 6f                	push   $0x6f
  jmp __alltraps
c01022cd:	e9 90 06 00 00       	jmp    c0102962 <__alltraps>

c01022d2 <vector112>:
.globl vector112
vector112:
  pushl $0
c01022d2:	6a 00                	push   $0x0
  pushl $112
c01022d4:	6a 70                	push   $0x70
  jmp __alltraps
c01022d6:	e9 87 06 00 00       	jmp    c0102962 <__alltraps>

c01022db <vector113>:
.globl vector113
vector113:
  pushl $0
c01022db:	6a 00                	push   $0x0
  pushl $113
c01022dd:	6a 71                	push   $0x71
  jmp __alltraps
c01022df:	e9 7e 06 00 00       	jmp    c0102962 <__alltraps>

c01022e4 <vector114>:
.globl vector114
vector114:
  pushl $0
c01022e4:	6a 00                	push   $0x0
  pushl $114
c01022e6:	6a 72                	push   $0x72
  jmp __alltraps
c01022e8:	e9 75 06 00 00       	jmp    c0102962 <__alltraps>

c01022ed <vector115>:
.globl vector115
vector115:
  pushl $0
c01022ed:	6a 00                	push   $0x0
  pushl $115
c01022ef:	6a 73                	push   $0x73
  jmp __alltraps
c01022f1:	e9 6c 06 00 00       	jmp    c0102962 <__alltraps>

c01022f6 <vector116>:
.globl vector116
vector116:
  pushl $0
c01022f6:	6a 00                	push   $0x0
  pushl $116
c01022f8:	6a 74                	push   $0x74
  jmp __alltraps
c01022fa:	e9 63 06 00 00       	jmp    c0102962 <__alltraps>

c01022ff <vector117>:
.globl vector117
vector117:
  pushl $0
c01022ff:	6a 00                	push   $0x0
  pushl $117
c0102301:	6a 75                	push   $0x75
  jmp __alltraps
c0102303:	e9 5a 06 00 00       	jmp    c0102962 <__alltraps>

c0102308 <vector118>:
.globl vector118
vector118:
  pushl $0
c0102308:	6a 00                	push   $0x0
  pushl $118
c010230a:	6a 76                	push   $0x76
  jmp __alltraps
c010230c:	e9 51 06 00 00       	jmp    c0102962 <__alltraps>

c0102311 <vector119>:
.globl vector119
vector119:
  pushl $0
c0102311:	6a 00                	push   $0x0
  pushl $119
c0102313:	6a 77                	push   $0x77
  jmp __alltraps
c0102315:	e9 48 06 00 00       	jmp    c0102962 <__alltraps>

c010231a <vector120>:
.globl vector120
vector120:
  pushl $0
c010231a:	6a 00                	push   $0x0
  pushl $120
c010231c:	6a 78                	push   $0x78
  jmp __alltraps
c010231e:	e9 3f 06 00 00       	jmp    c0102962 <__alltraps>

c0102323 <vector121>:
.globl vector121
vector121:
  pushl $0
c0102323:	6a 00                	push   $0x0
  pushl $121
c0102325:	6a 79                	push   $0x79
  jmp __alltraps
c0102327:	e9 36 06 00 00       	jmp    c0102962 <__alltraps>

c010232c <vector122>:
.globl vector122
vector122:
  pushl $0
c010232c:	6a 00                	push   $0x0
  pushl $122
c010232e:	6a 7a                	push   $0x7a
  jmp __alltraps
c0102330:	e9 2d 06 00 00       	jmp    c0102962 <__alltraps>

c0102335 <vector123>:
.globl vector123
vector123:
  pushl $0
c0102335:	6a 00                	push   $0x0
  pushl $123
c0102337:	6a 7b                	push   $0x7b
  jmp __alltraps
c0102339:	e9 24 06 00 00       	jmp    c0102962 <__alltraps>

c010233e <vector124>:
.globl vector124
vector124:
  pushl $0
c010233e:	6a 00                	push   $0x0
  pushl $124
c0102340:	6a 7c                	push   $0x7c
  jmp __alltraps
c0102342:	e9 1b 06 00 00       	jmp    c0102962 <__alltraps>

c0102347 <vector125>:
.globl vector125
vector125:
  pushl $0
c0102347:	6a 00                	push   $0x0
  pushl $125
c0102349:	6a 7d                	push   $0x7d
  jmp __alltraps
c010234b:	e9 12 06 00 00       	jmp    c0102962 <__alltraps>

c0102350 <vector126>:
.globl vector126
vector126:
  pushl $0
c0102350:	6a 00                	push   $0x0
  pushl $126
c0102352:	6a 7e                	push   $0x7e
  jmp __alltraps
c0102354:	e9 09 06 00 00       	jmp    c0102962 <__alltraps>

c0102359 <vector127>:
.globl vector127
vector127:
  pushl $0
c0102359:	6a 00                	push   $0x0
  pushl $127
c010235b:	6a 7f                	push   $0x7f
  jmp __alltraps
c010235d:	e9 00 06 00 00       	jmp    c0102962 <__alltraps>

c0102362 <vector128>:
.globl vector128
vector128:
  pushl $0
c0102362:	6a 00                	push   $0x0
  pushl $128
c0102364:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c0102369:	e9 f4 05 00 00       	jmp    c0102962 <__alltraps>

c010236e <vector129>:
.globl vector129
vector129:
  pushl $0
c010236e:	6a 00                	push   $0x0
  pushl $129
c0102370:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c0102375:	e9 e8 05 00 00       	jmp    c0102962 <__alltraps>

c010237a <vector130>:
.globl vector130
vector130:
  pushl $0
c010237a:	6a 00                	push   $0x0
  pushl $130
c010237c:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c0102381:	e9 dc 05 00 00       	jmp    c0102962 <__alltraps>

c0102386 <vector131>:
.globl vector131
vector131:
  pushl $0
c0102386:	6a 00                	push   $0x0
  pushl $131
c0102388:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c010238d:	e9 d0 05 00 00       	jmp    c0102962 <__alltraps>

c0102392 <vector132>:
.globl vector132
vector132:
  pushl $0
c0102392:	6a 00                	push   $0x0
  pushl $132
c0102394:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c0102399:	e9 c4 05 00 00       	jmp    c0102962 <__alltraps>

c010239e <vector133>:
.globl vector133
vector133:
  pushl $0
c010239e:	6a 00                	push   $0x0
  pushl $133
c01023a0:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c01023a5:	e9 b8 05 00 00       	jmp    c0102962 <__alltraps>

c01023aa <vector134>:
.globl vector134
vector134:
  pushl $0
c01023aa:	6a 00                	push   $0x0
  pushl $134
c01023ac:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c01023b1:	e9 ac 05 00 00       	jmp    c0102962 <__alltraps>

c01023b6 <vector135>:
.globl vector135
vector135:
  pushl $0
c01023b6:	6a 00                	push   $0x0
  pushl $135
c01023b8:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c01023bd:	e9 a0 05 00 00       	jmp    c0102962 <__alltraps>

c01023c2 <vector136>:
.globl vector136
vector136:
  pushl $0
c01023c2:	6a 00                	push   $0x0
  pushl $136
c01023c4:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c01023c9:	e9 94 05 00 00       	jmp    c0102962 <__alltraps>

c01023ce <vector137>:
.globl vector137
vector137:
  pushl $0
c01023ce:	6a 00                	push   $0x0
  pushl $137
c01023d0:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c01023d5:	e9 88 05 00 00       	jmp    c0102962 <__alltraps>

c01023da <vector138>:
.globl vector138
vector138:
  pushl $0
c01023da:	6a 00                	push   $0x0
  pushl $138
c01023dc:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c01023e1:	e9 7c 05 00 00       	jmp    c0102962 <__alltraps>

c01023e6 <vector139>:
.globl vector139
vector139:
  pushl $0
c01023e6:	6a 00                	push   $0x0
  pushl $139
c01023e8:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c01023ed:	e9 70 05 00 00       	jmp    c0102962 <__alltraps>

c01023f2 <vector140>:
.globl vector140
vector140:
  pushl $0
c01023f2:	6a 00                	push   $0x0
  pushl $140
c01023f4:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c01023f9:	e9 64 05 00 00       	jmp    c0102962 <__alltraps>

c01023fe <vector141>:
.globl vector141
vector141:
  pushl $0
c01023fe:	6a 00                	push   $0x0
  pushl $141
c0102400:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c0102405:	e9 58 05 00 00       	jmp    c0102962 <__alltraps>

c010240a <vector142>:
.globl vector142
vector142:
  pushl $0
c010240a:	6a 00                	push   $0x0
  pushl $142
c010240c:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c0102411:	e9 4c 05 00 00       	jmp    c0102962 <__alltraps>

c0102416 <vector143>:
.globl vector143
vector143:
  pushl $0
c0102416:	6a 00                	push   $0x0
  pushl $143
c0102418:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c010241d:	e9 40 05 00 00       	jmp    c0102962 <__alltraps>

c0102422 <vector144>:
.globl vector144
vector144:
  pushl $0
c0102422:	6a 00                	push   $0x0
  pushl $144
c0102424:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c0102429:	e9 34 05 00 00       	jmp    c0102962 <__alltraps>

c010242e <vector145>:
.globl vector145
vector145:
  pushl $0
c010242e:	6a 00                	push   $0x0
  pushl $145
c0102430:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c0102435:	e9 28 05 00 00       	jmp    c0102962 <__alltraps>

c010243a <vector146>:
.globl vector146
vector146:
  pushl $0
c010243a:	6a 00                	push   $0x0
  pushl $146
c010243c:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c0102441:	e9 1c 05 00 00       	jmp    c0102962 <__alltraps>

c0102446 <vector147>:
.globl vector147
vector147:
  pushl $0
c0102446:	6a 00                	push   $0x0
  pushl $147
c0102448:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c010244d:	e9 10 05 00 00       	jmp    c0102962 <__alltraps>

c0102452 <vector148>:
.globl vector148
vector148:
  pushl $0
c0102452:	6a 00                	push   $0x0
  pushl $148
c0102454:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c0102459:	e9 04 05 00 00       	jmp    c0102962 <__alltraps>

c010245e <vector149>:
.globl vector149
vector149:
  pushl $0
c010245e:	6a 00                	push   $0x0
  pushl $149
c0102460:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c0102465:	e9 f8 04 00 00       	jmp    c0102962 <__alltraps>

c010246a <vector150>:
.globl vector150
vector150:
  pushl $0
c010246a:	6a 00                	push   $0x0
  pushl $150
c010246c:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c0102471:	e9 ec 04 00 00       	jmp    c0102962 <__alltraps>

c0102476 <vector151>:
.globl vector151
vector151:
  pushl $0
c0102476:	6a 00                	push   $0x0
  pushl $151
c0102478:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c010247d:	e9 e0 04 00 00       	jmp    c0102962 <__alltraps>

c0102482 <vector152>:
.globl vector152
vector152:
  pushl $0
c0102482:	6a 00                	push   $0x0
  pushl $152
c0102484:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c0102489:	e9 d4 04 00 00       	jmp    c0102962 <__alltraps>

c010248e <vector153>:
.globl vector153
vector153:
  pushl $0
c010248e:	6a 00                	push   $0x0
  pushl $153
c0102490:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c0102495:	e9 c8 04 00 00       	jmp    c0102962 <__alltraps>

c010249a <vector154>:
.globl vector154
vector154:
  pushl $0
c010249a:	6a 00                	push   $0x0
  pushl $154
c010249c:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c01024a1:	e9 bc 04 00 00       	jmp    c0102962 <__alltraps>

c01024a6 <vector155>:
.globl vector155
vector155:
  pushl $0
c01024a6:	6a 00                	push   $0x0
  pushl $155
c01024a8:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c01024ad:	e9 b0 04 00 00       	jmp    c0102962 <__alltraps>

c01024b2 <vector156>:
.globl vector156
vector156:
  pushl $0
c01024b2:	6a 00                	push   $0x0
  pushl $156
c01024b4:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c01024b9:	e9 a4 04 00 00       	jmp    c0102962 <__alltraps>

c01024be <vector157>:
.globl vector157
vector157:
  pushl $0
c01024be:	6a 00                	push   $0x0
  pushl $157
c01024c0:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c01024c5:	e9 98 04 00 00       	jmp    c0102962 <__alltraps>

c01024ca <vector158>:
.globl vector158
vector158:
  pushl $0
c01024ca:	6a 00                	push   $0x0
  pushl $158
c01024cc:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c01024d1:	e9 8c 04 00 00       	jmp    c0102962 <__alltraps>

c01024d6 <vector159>:
.globl vector159
vector159:
  pushl $0
c01024d6:	6a 00                	push   $0x0
  pushl $159
c01024d8:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c01024dd:	e9 80 04 00 00       	jmp    c0102962 <__alltraps>

c01024e2 <vector160>:
.globl vector160
vector160:
  pushl $0
c01024e2:	6a 00                	push   $0x0
  pushl $160
c01024e4:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c01024e9:	e9 74 04 00 00       	jmp    c0102962 <__alltraps>

c01024ee <vector161>:
.globl vector161
vector161:
  pushl $0
c01024ee:	6a 00                	push   $0x0
  pushl $161
c01024f0:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c01024f5:	e9 68 04 00 00       	jmp    c0102962 <__alltraps>

c01024fa <vector162>:
.globl vector162
vector162:
  pushl $0
c01024fa:	6a 00                	push   $0x0
  pushl $162
c01024fc:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c0102501:	e9 5c 04 00 00       	jmp    c0102962 <__alltraps>

c0102506 <vector163>:
.globl vector163
vector163:
  pushl $0
c0102506:	6a 00                	push   $0x0
  pushl $163
c0102508:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c010250d:	e9 50 04 00 00       	jmp    c0102962 <__alltraps>

c0102512 <vector164>:
.globl vector164
vector164:
  pushl $0
c0102512:	6a 00                	push   $0x0
  pushl $164
c0102514:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c0102519:	e9 44 04 00 00       	jmp    c0102962 <__alltraps>

c010251e <vector165>:
.globl vector165
vector165:
  pushl $0
c010251e:	6a 00                	push   $0x0
  pushl $165
c0102520:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c0102525:	e9 38 04 00 00       	jmp    c0102962 <__alltraps>

c010252a <vector166>:
.globl vector166
vector166:
  pushl $0
c010252a:	6a 00                	push   $0x0
  pushl $166
c010252c:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c0102531:	e9 2c 04 00 00       	jmp    c0102962 <__alltraps>

c0102536 <vector167>:
.globl vector167
vector167:
  pushl $0
c0102536:	6a 00                	push   $0x0
  pushl $167
c0102538:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c010253d:	e9 20 04 00 00       	jmp    c0102962 <__alltraps>

c0102542 <vector168>:
.globl vector168
vector168:
  pushl $0
c0102542:	6a 00                	push   $0x0
  pushl $168
c0102544:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c0102549:	e9 14 04 00 00       	jmp    c0102962 <__alltraps>

c010254e <vector169>:
.globl vector169
vector169:
  pushl $0
c010254e:	6a 00                	push   $0x0
  pushl $169
c0102550:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c0102555:	e9 08 04 00 00       	jmp    c0102962 <__alltraps>

c010255a <vector170>:
.globl vector170
vector170:
  pushl $0
c010255a:	6a 00                	push   $0x0
  pushl $170
c010255c:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c0102561:	e9 fc 03 00 00       	jmp    c0102962 <__alltraps>

c0102566 <vector171>:
.globl vector171
vector171:
  pushl $0
c0102566:	6a 00                	push   $0x0
  pushl $171
c0102568:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c010256d:	e9 f0 03 00 00       	jmp    c0102962 <__alltraps>

c0102572 <vector172>:
.globl vector172
vector172:
  pushl $0
c0102572:	6a 00                	push   $0x0
  pushl $172
c0102574:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c0102579:	e9 e4 03 00 00       	jmp    c0102962 <__alltraps>

c010257e <vector173>:
.globl vector173
vector173:
  pushl $0
c010257e:	6a 00                	push   $0x0
  pushl $173
c0102580:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c0102585:	e9 d8 03 00 00       	jmp    c0102962 <__alltraps>

c010258a <vector174>:
.globl vector174
vector174:
  pushl $0
c010258a:	6a 00                	push   $0x0
  pushl $174
c010258c:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c0102591:	e9 cc 03 00 00       	jmp    c0102962 <__alltraps>

c0102596 <vector175>:
.globl vector175
vector175:
  pushl $0
c0102596:	6a 00                	push   $0x0
  pushl $175
c0102598:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c010259d:	e9 c0 03 00 00       	jmp    c0102962 <__alltraps>

c01025a2 <vector176>:
.globl vector176
vector176:
  pushl $0
c01025a2:	6a 00                	push   $0x0
  pushl $176
c01025a4:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c01025a9:	e9 b4 03 00 00       	jmp    c0102962 <__alltraps>

c01025ae <vector177>:
.globl vector177
vector177:
  pushl $0
c01025ae:	6a 00                	push   $0x0
  pushl $177
c01025b0:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c01025b5:	e9 a8 03 00 00       	jmp    c0102962 <__alltraps>

c01025ba <vector178>:
.globl vector178
vector178:
  pushl $0
c01025ba:	6a 00                	push   $0x0
  pushl $178
c01025bc:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c01025c1:	e9 9c 03 00 00       	jmp    c0102962 <__alltraps>

c01025c6 <vector179>:
.globl vector179
vector179:
  pushl $0
c01025c6:	6a 00                	push   $0x0
  pushl $179
c01025c8:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c01025cd:	e9 90 03 00 00       	jmp    c0102962 <__alltraps>

c01025d2 <vector180>:
.globl vector180
vector180:
  pushl $0
c01025d2:	6a 00                	push   $0x0
  pushl $180
c01025d4:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c01025d9:	e9 84 03 00 00       	jmp    c0102962 <__alltraps>

c01025de <vector181>:
.globl vector181
vector181:
  pushl $0
c01025de:	6a 00                	push   $0x0
  pushl $181
c01025e0:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c01025e5:	e9 78 03 00 00       	jmp    c0102962 <__alltraps>

c01025ea <vector182>:
.globl vector182
vector182:
  pushl $0
c01025ea:	6a 00                	push   $0x0
  pushl $182
c01025ec:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c01025f1:	e9 6c 03 00 00       	jmp    c0102962 <__alltraps>

c01025f6 <vector183>:
.globl vector183
vector183:
  pushl $0
c01025f6:	6a 00                	push   $0x0
  pushl $183
c01025f8:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c01025fd:	e9 60 03 00 00       	jmp    c0102962 <__alltraps>

c0102602 <vector184>:
.globl vector184
vector184:
  pushl $0
c0102602:	6a 00                	push   $0x0
  pushl $184
c0102604:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c0102609:	e9 54 03 00 00       	jmp    c0102962 <__alltraps>

c010260e <vector185>:
.globl vector185
vector185:
  pushl $0
c010260e:	6a 00                	push   $0x0
  pushl $185
c0102610:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c0102615:	e9 48 03 00 00       	jmp    c0102962 <__alltraps>

c010261a <vector186>:
.globl vector186
vector186:
  pushl $0
c010261a:	6a 00                	push   $0x0
  pushl $186
c010261c:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c0102621:	e9 3c 03 00 00       	jmp    c0102962 <__alltraps>

c0102626 <vector187>:
.globl vector187
vector187:
  pushl $0
c0102626:	6a 00                	push   $0x0
  pushl $187
c0102628:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c010262d:	e9 30 03 00 00       	jmp    c0102962 <__alltraps>

c0102632 <vector188>:
.globl vector188
vector188:
  pushl $0
c0102632:	6a 00                	push   $0x0
  pushl $188
c0102634:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c0102639:	e9 24 03 00 00       	jmp    c0102962 <__alltraps>

c010263e <vector189>:
.globl vector189
vector189:
  pushl $0
c010263e:	6a 00                	push   $0x0
  pushl $189
c0102640:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c0102645:	e9 18 03 00 00       	jmp    c0102962 <__alltraps>

c010264a <vector190>:
.globl vector190
vector190:
  pushl $0
c010264a:	6a 00                	push   $0x0
  pushl $190
c010264c:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c0102651:	e9 0c 03 00 00       	jmp    c0102962 <__alltraps>

c0102656 <vector191>:
.globl vector191
vector191:
  pushl $0
c0102656:	6a 00                	push   $0x0
  pushl $191
c0102658:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c010265d:	e9 00 03 00 00       	jmp    c0102962 <__alltraps>

c0102662 <vector192>:
.globl vector192
vector192:
  pushl $0
c0102662:	6a 00                	push   $0x0
  pushl $192
c0102664:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c0102669:	e9 f4 02 00 00       	jmp    c0102962 <__alltraps>

c010266e <vector193>:
.globl vector193
vector193:
  pushl $0
c010266e:	6a 00                	push   $0x0
  pushl $193
c0102670:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c0102675:	e9 e8 02 00 00       	jmp    c0102962 <__alltraps>

c010267a <vector194>:
.globl vector194
vector194:
  pushl $0
c010267a:	6a 00                	push   $0x0
  pushl $194
c010267c:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c0102681:	e9 dc 02 00 00       	jmp    c0102962 <__alltraps>

c0102686 <vector195>:
.globl vector195
vector195:
  pushl $0
c0102686:	6a 00                	push   $0x0
  pushl $195
c0102688:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c010268d:	e9 d0 02 00 00       	jmp    c0102962 <__alltraps>

c0102692 <vector196>:
.globl vector196
vector196:
  pushl $0
c0102692:	6a 00                	push   $0x0
  pushl $196
c0102694:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c0102699:	e9 c4 02 00 00       	jmp    c0102962 <__alltraps>

c010269e <vector197>:
.globl vector197
vector197:
  pushl $0
c010269e:	6a 00                	push   $0x0
  pushl $197
c01026a0:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c01026a5:	e9 b8 02 00 00       	jmp    c0102962 <__alltraps>

c01026aa <vector198>:
.globl vector198
vector198:
  pushl $0
c01026aa:	6a 00                	push   $0x0
  pushl $198
c01026ac:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c01026b1:	e9 ac 02 00 00       	jmp    c0102962 <__alltraps>

c01026b6 <vector199>:
.globl vector199
vector199:
  pushl $0
c01026b6:	6a 00                	push   $0x0
  pushl $199
c01026b8:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c01026bd:	e9 a0 02 00 00       	jmp    c0102962 <__alltraps>

c01026c2 <vector200>:
.globl vector200
vector200:
  pushl $0
c01026c2:	6a 00                	push   $0x0
  pushl $200
c01026c4:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c01026c9:	e9 94 02 00 00       	jmp    c0102962 <__alltraps>

c01026ce <vector201>:
.globl vector201
vector201:
  pushl $0
c01026ce:	6a 00                	push   $0x0
  pushl $201
c01026d0:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c01026d5:	e9 88 02 00 00       	jmp    c0102962 <__alltraps>

c01026da <vector202>:
.globl vector202
vector202:
  pushl $0
c01026da:	6a 00                	push   $0x0
  pushl $202
c01026dc:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c01026e1:	e9 7c 02 00 00       	jmp    c0102962 <__alltraps>

c01026e6 <vector203>:
.globl vector203
vector203:
  pushl $0
c01026e6:	6a 00                	push   $0x0
  pushl $203
c01026e8:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c01026ed:	e9 70 02 00 00       	jmp    c0102962 <__alltraps>

c01026f2 <vector204>:
.globl vector204
vector204:
  pushl $0
c01026f2:	6a 00                	push   $0x0
  pushl $204
c01026f4:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c01026f9:	e9 64 02 00 00       	jmp    c0102962 <__alltraps>

c01026fe <vector205>:
.globl vector205
vector205:
  pushl $0
c01026fe:	6a 00                	push   $0x0
  pushl $205
c0102700:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c0102705:	e9 58 02 00 00       	jmp    c0102962 <__alltraps>

c010270a <vector206>:
.globl vector206
vector206:
  pushl $0
c010270a:	6a 00                	push   $0x0
  pushl $206
c010270c:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c0102711:	e9 4c 02 00 00       	jmp    c0102962 <__alltraps>

c0102716 <vector207>:
.globl vector207
vector207:
  pushl $0
c0102716:	6a 00                	push   $0x0
  pushl $207
c0102718:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c010271d:	e9 40 02 00 00       	jmp    c0102962 <__alltraps>

c0102722 <vector208>:
.globl vector208
vector208:
  pushl $0
c0102722:	6a 00                	push   $0x0
  pushl $208
c0102724:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c0102729:	e9 34 02 00 00       	jmp    c0102962 <__alltraps>

c010272e <vector209>:
.globl vector209
vector209:
  pushl $0
c010272e:	6a 00                	push   $0x0
  pushl $209
c0102730:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c0102735:	e9 28 02 00 00       	jmp    c0102962 <__alltraps>

c010273a <vector210>:
.globl vector210
vector210:
  pushl $0
c010273a:	6a 00                	push   $0x0
  pushl $210
c010273c:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c0102741:	e9 1c 02 00 00       	jmp    c0102962 <__alltraps>

c0102746 <vector211>:
.globl vector211
vector211:
  pushl $0
c0102746:	6a 00                	push   $0x0
  pushl $211
c0102748:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c010274d:	e9 10 02 00 00       	jmp    c0102962 <__alltraps>

c0102752 <vector212>:
.globl vector212
vector212:
  pushl $0
c0102752:	6a 00                	push   $0x0
  pushl $212
c0102754:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c0102759:	e9 04 02 00 00       	jmp    c0102962 <__alltraps>

c010275e <vector213>:
.globl vector213
vector213:
  pushl $0
c010275e:	6a 00                	push   $0x0
  pushl $213
c0102760:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c0102765:	e9 f8 01 00 00       	jmp    c0102962 <__alltraps>

c010276a <vector214>:
.globl vector214
vector214:
  pushl $0
c010276a:	6a 00                	push   $0x0
  pushl $214
c010276c:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c0102771:	e9 ec 01 00 00       	jmp    c0102962 <__alltraps>

c0102776 <vector215>:
.globl vector215
vector215:
  pushl $0
c0102776:	6a 00                	push   $0x0
  pushl $215
c0102778:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c010277d:	e9 e0 01 00 00       	jmp    c0102962 <__alltraps>

c0102782 <vector216>:
.globl vector216
vector216:
  pushl $0
c0102782:	6a 00                	push   $0x0
  pushl $216
c0102784:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c0102789:	e9 d4 01 00 00       	jmp    c0102962 <__alltraps>

c010278e <vector217>:
.globl vector217
vector217:
  pushl $0
c010278e:	6a 00                	push   $0x0
  pushl $217
c0102790:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c0102795:	e9 c8 01 00 00       	jmp    c0102962 <__alltraps>

c010279a <vector218>:
.globl vector218
vector218:
  pushl $0
c010279a:	6a 00                	push   $0x0
  pushl $218
c010279c:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c01027a1:	e9 bc 01 00 00       	jmp    c0102962 <__alltraps>

c01027a6 <vector219>:
.globl vector219
vector219:
  pushl $0
c01027a6:	6a 00                	push   $0x0
  pushl $219
c01027a8:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c01027ad:	e9 b0 01 00 00       	jmp    c0102962 <__alltraps>

c01027b2 <vector220>:
.globl vector220
vector220:
  pushl $0
c01027b2:	6a 00                	push   $0x0
  pushl $220
c01027b4:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c01027b9:	e9 a4 01 00 00       	jmp    c0102962 <__alltraps>

c01027be <vector221>:
.globl vector221
vector221:
  pushl $0
c01027be:	6a 00                	push   $0x0
  pushl $221
c01027c0:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c01027c5:	e9 98 01 00 00       	jmp    c0102962 <__alltraps>

c01027ca <vector222>:
.globl vector222
vector222:
  pushl $0
c01027ca:	6a 00                	push   $0x0
  pushl $222
c01027cc:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c01027d1:	e9 8c 01 00 00       	jmp    c0102962 <__alltraps>

c01027d6 <vector223>:
.globl vector223
vector223:
  pushl $0
c01027d6:	6a 00                	push   $0x0
  pushl $223
c01027d8:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c01027dd:	e9 80 01 00 00       	jmp    c0102962 <__alltraps>

c01027e2 <vector224>:
.globl vector224
vector224:
  pushl $0
c01027e2:	6a 00                	push   $0x0
  pushl $224
c01027e4:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c01027e9:	e9 74 01 00 00       	jmp    c0102962 <__alltraps>

c01027ee <vector225>:
.globl vector225
vector225:
  pushl $0
c01027ee:	6a 00                	push   $0x0
  pushl $225
c01027f0:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c01027f5:	e9 68 01 00 00       	jmp    c0102962 <__alltraps>

c01027fa <vector226>:
.globl vector226
vector226:
  pushl $0
c01027fa:	6a 00                	push   $0x0
  pushl $226
c01027fc:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c0102801:	e9 5c 01 00 00       	jmp    c0102962 <__alltraps>

c0102806 <vector227>:
.globl vector227
vector227:
  pushl $0
c0102806:	6a 00                	push   $0x0
  pushl $227
c0102808:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c010280d:	e9 50 01 00 00       	jmp    c0102962 <__alltraps>

c0102812 <vector228>:
.globl vector228
vector228:
  pushl $0
c0102812:	6a 00                	push   $0x0
  pushl $228
c0102814:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c0102819:	e9 44 01 00 00       	jmp    c0102962 <__alltraps>

c010281e <vector229>:
.globl vector229
vector229:
  pushl $0
c010281e:	6a 00                	push   $0x0
  pushl $229
c0102820:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c0102825:	e9 38 01 00 00       	jmp    c0102962 <__alltraps>

c010282a <vector230>:
.globl vector230
vector230:
  pushl $0
c010282a:	6a 00                	push   $0x0
  pushl $230
c010282c:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c0102831:	e9 2c 01 00 00       	jmp    c0102962 <__alltraps>

c0102836 <vector231>:
.globl vector231
vector231:
  pushl $0
c0102836:	6a 00                	push   $0x0
  pushl $231
c0102838:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c010283d:	e9 20 01 00 00       	jmp    c0102962 <__alltraps>

c0102842 <vector232>:
.globl vector232
vector232:
  pushl $0
c0102842:	6a 00                	push   $0x0
  pushl $232
c0102844:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c0102849:	e9 14 01 00 00       	jmp    c0102962 <__alltraps>

c010284e <vector233>:
.globl vector233
vector233:
  pushl $0
c010284e:	6a 00                	push   $0x0
  pushl $233
c0102850:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c0102855:	e9 08 01 00 00       	jmp    c0102962 <__alltraps>

c010285a <vector234>:
.globl vector234
vector234:
  pushl $0
c010285a:	6a 00                	push   $0x0
  pushl $234
c010285c:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c0102861:	e9 fc 00 00 00       	jmp    c0102962 <__alltraps>

c0102866 <vector235>:
.globl vector235
vector235:
  pushl $0
c0102866:	6a 00                	push   $0x0
  pushl $235
c0102868:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c010286d:	e9 f0 00 00 00       	jmp    c0102962 <__alltraps>

c0102872 <vector236>:
.globl vector236
vector236:
  pushl $0
c0102872:	6a 00                	push   $0x0
  pushl $236
c0102874:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c0102879:	e9 e4 00 00 00       	jmp    c0102962 <__alltraps>

c010287e <vector237>:
.globl vector237
vector237:
  pushl $0
c010287e:	6a 00                	push   $0x0
  pushl $237
c0102880:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c0102885:	e9 d8 00 00 00       	jmp    c0102962 <__alltraps>

c010288a <vector238>:
.globl vector238
vector238:
  pushl $0
c010288a:	6a 00                	push   $0x0
  pushl $238
c010288c:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c0102891:	e9 cc 00 00 00       	jmp    c0102962 <__alltraps>

c0102896 <vector239>:
.globl vector239
vector239:
  pushl $0
c0102896:	6a 00                	push   $0x0
  pushl $239
c0102898:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c010289d:	e9 c0 00 00 00       	jmp    c0102962 <__alltraps>

c01028a2 <vector240>:
.globl vector240
vector240:
  pushl $0
c01028a2:	6a 00                	push   $0x0
  pushl $240
c01028a4:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c01028a9:	e9 b4 00 00 00       	jmp    c0102962 <__alltraps>

c01028ae <vector241>:
.globl vector241
vector241:
  pushl $0
c01028ae:	6a 00                	push   $0x0
  pushl $241
c01028b0:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c01028b5:	e9 a8 00 00 00       	jmp    c0102962 <__alltraps>

c01028ba <vector242>:
.globl vector242
vector242:
  pushl $0
c01028ba:	6a 00                	push   $0x0
  pushl $242
c01028bc:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c01028c1:	e9 9c 00 00 00       	jmp    c0102962 <__alltraps>

c01028c6 <vector243>:
.globl vector243
vector243:
  pushl $0
c01028c6:	6a 00                	push   $0x0
  pushl $243
c01028c8:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c01028cd:	e9 90 00 00 00       	jmp    c0102962 <__alltraps>

c01028d2 <vector244>:
.globl vector244
vector244:
  pushl $0
c01028d2:	6a 00                	push   $0x0
  pushl $244
c01028d4:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c01028d9:	e9 84 00 00 00       	jmp    c0102962 <__alltraps>

c01028de <vector245>:
.globl vector245
vector245:
  pushl $0
c01028de:	6a 00                	push   $0x0
  pushl $245
c01028e0:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c01028e5:	e9 78 00 00 00       	jmp    c0102962 <__alltraps>

c01028ea <vector246>:
.globl vector246
vector246:
  pushl $0
c01028ea:	6a 00                	push   $0x0
  pushl $246
c01028ec:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c01028f1:	e9 6c 00 00 00       	jmp    c0102962 <__alltraps>

c01028f6 <vector247>:
.globl vector247
vector247:
  pushl $0
c01028f6:	6a 00                	push   $0x0
  pushl $247
c01028f8:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c01028fd:	e9 60 00 00 00       	jmp    c0102962 <__alltraps>

c0102902 <vector248>:
.globl vector248
vector248:
  pushl $0
c0102902:	6a 00                	push   $0x0
  pushl $248
c0102904:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c0102909:	e9 54 00 00 00       	jmp    c0102962 <__alltraps>

c010290e <vector249>:
.globl vector249
vector249:
  pushl $0
c010290e:	6a 00                	push   $0x0
  pushl $249
c0102910:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c0102915:	e9 48 00 00 00       	jmp    c0102962 <__alltraps>

c010291a <vector250>:
.globl vector250
vector250:
  pushl $0
c010291a:	6a 00                	push   $0x0
  pushl $250
c010291c:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c0102921:	e9 3c 00 00 00       	jmp    c0102962 <__alltraps>

c0102926 <vector251>:
.globl vector251
vector251:
  pushl $0
c0102926:	6a 00                	push   $0x0
  pushl $251
c0102928:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c010292d:	e9 30 00 00 00       	jmp    c0102962 <__alltraps>

c0102932 <vector252>:
.globl vector252
vector252:
  pushl $0
c0102932:	6a 00                	push   $0x0
  pushl $252
c0102934:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c0102939:	e9 24 00 00 00       	jmp    c0102962 <__alltraps>

c010293e <vector253>:
.globl vector253
vector253:
  pushl $0
c010293e:	6a 00                	push   $0x0
  pushl $253
c0102940:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c0102945:	e9 18 00 00 00       	jmp    c0102962 <__alltraps>

c010294a <vector254>:
.globl vector254
vector254:
  pushl $0
c010294a:	6a 00                	push   $0x0
  pushl $254
c010294c:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c0102951:	e9 0c 00 00 00       	jmp    c0102962 <__alltraps>

c0102956 <vector255>:
.globl vector255
vector255:
  pushl $0
c0102956:	6a 00                	push   $0x0
  pushl $255
c0102958:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c010295d:	e9 00 00 00 00       	jmp    c0102962 <__alltraps>

c0102962 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c0102962:	1e                   	push   %ds
    pushl %es
c0102963:	06                   	push   %es
    pushl %fs
c0102964:	0f a0                	push   %fs
    pushl %gs
c0102966:	0f a8                	push   %gs
    pushal
c0102968:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c0102969:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c010296e:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c0102970:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c0102972:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c0102973:	e8 5f f5 ff ff       	call   c0101ed7 <trap>

    # pop the pushed stack pointer
    popl %esp
c0102978:	5c                   	pop    %esp

c0102979 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c0102979:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c010297a:	0f a9                	pop    %gs
    popl %fs
c010297c:	0f a1                	pop    %fs
    popl %es
c010297e:	07                   	pop    %es
    popl %ds
c010297f:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c0102980:	83 c4 08             	add    $0x8,%esp
    iret
c0102983:	cf                   	iret   

c0102984 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0102984:	55                   	push   %ebp
c0102985:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0102987:	a1 18 cf 11 c0       	mov    0xc011cf18,%eax
c010298c:	8b 55 08             	mov    0x8(%ebp),%edx
c010298f:	29 c2                	sub    %eax,%edx
c0102991:	89 d0                	mov    %edx,%eax
c0102993:	c1 f8 02             	sar    $0x2,%eax
c0102996:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c010299c:	5d                   	pop    %ebp
c010299d:	c3                   	ret    

c010299e <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c010299e:	55                   	push   %ebp
c010299f:	89 e5                	mov    %esp,%ebp
    return page2ppn(page) << PGSHIFT;
c01029a1:	ff 75 08             	pushl  0x8(%ebp)
c01029a4:	e8 db ff ff ff       	call   c0102984 <page2ppn>
c01029a9:	83 c4 04             	add    $0x4,%esp
c01029ac:	c1 e0 0c             	shl    $0xc,%eax
}
c01029af:	c9                   	leave  
c01029b0:	c3                   	ret    

c01029b1 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c01029b1:	55                   	push   %ebp
c01029b2:	89 e5                	mov    %esp,%ebp
c01029b4:	83 ec 08             	sub    $0x8,%esp
    if (PPN(pa) >= npage) {
c01029b7:	8b 45 08             	mov    0x8(%ebp),%eax
c01029ba:	c1 e8 0c             	shr    $0xc,%eax
c01029bd:	89 c2                	mov    %eax,%edx
c01029bf:	a1 80 ce 11 c0       	mov    0xc011ce80,%eax
c01029c4:	39 c2                	cmp    %eax,%edx
c01029c6:	72 14                	jb     c01029dc <pa2page+0x2b>
        panic("pa2page called with invalid pa");
c01029c8:	83 ec 04             	sub    $0x4,%esp
c01029cb:	68 90 63 10 c0       	push   $0xc0106390
c01029d0:	6a 5a                	push   $0x5a
c01029d2:	68 af 63 10 c0       	push   $0xc01063af
c01029d7:	e8 3a da ff ff       	call   c0100416 <__panic>
    }
    return &pages[PPN(pa)];
c01029dc:	8b 0d 18 cf 11 c0    	mov    0xc011cf18,%ecx
c01029e2:	8b 45 08             	mov    0x8(%ebp),%eax
c01029e5:	c1 e8 0c             	shr    $0xc,%eax
c01029e8:	89 c2                	mov    %eax,%edx
c01029ea:	89 d0                	mov    %edx,%eax
c01029ec:	c1 e0 02             	shl    $0x2,%eax
c01029ef:	01 d0                	add    %edx,%eax
c01029f1:	c1 e0 02             	shl    $0x2,%eax
c01029f4:	01 c8                	add    %ecx,%eax
}
c01029f6:	c9                   	leave  
c01029f7:	c3                   	ret    

c01029f8 <page2kva>:

static inline void *
page2kva(struct Page *page) {
c01029f8:	55                   	push   %ebp
c01029f9:	89 e5                	mov    %esp,%ebp
c01029fb:	83 ec 18             	sub    $0x18,%esp
    return KADDR(page2pa(page));
c01029fe:	ff 75 08             	pushl  0x8(%ebp)
c0102a01:	e8 98 ff ff ff       	call   c010299e <page2pa>
c0102a06:	83 c4 04             	add    $0x4,%esp
c0102a09:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102a0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102a0f:	c1 e8 0c             	shr    $0xc,%eax
c0102a12:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102a15:	a1 80 ce 11 c0       	mov    0xc011ce80,%eax
c0102a1a:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0102a1d:	72 14                	jb     c0102a33 <page2kva+0x3b>
c0102a1f:	ff 75 f4             	pushl  -0xc(%ebp)
c0102a22:	68 c0 63 10 c0       	push   $0xc01063c0
c0102a27:	6a 61                	push   $0x61
c0102a29:	68 af 63 10 c0       	push   $0xc01063af
c0102a2e:	e8 e3 d9 ff ff       	call   c0100416 <__panic>
c0102a33:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102a36:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0102a3b:	c9                   	leave  
c0102a3c:	c3                   	ret    

c0102a3d <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c0102a3d:	55                   	push   %ebp
c0102a3e:	89 e5                	mov    %esp,%ebp
c0102a40:	83 ec 08             	sub    $0x8,%esp
    if (!(pte & PTE_P)) {
c0102a43:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a46:	83 e0 01             	and    $0x1,%eax
c0102a49:	85 c0                	test   %eax,%eax
c0102a4b:	75 14                	jne    c0102a61 <pte2page+0x24>
        panic("pte2page called with invalid pte");
c0102a4d:	83 ec 04             	sub    $0x4,%esp
c0102a50:	68 e4 63 10 c0       	push   $0xc01063e4
c0102a55:	6a 6c                	push   $0x6c
c0102a57:	68 af 63 10 c0       	push   $0xc01063af
c0102a5c:	e8 b5 d9 ff ff       	call   c0100416 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0102a61:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a64:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0102a69:	83 ec 0c             	sub    $0xc,%esp
c0102a6c:	50                   	push   %eax
c0102a6d:	e8 3f ff ff ff       	call   c01029b1 <pa2page>
c0102a72:	83 c4 10             	add    $0x10,%esp
}
c0102a75:	c9                   	leave  
c0102a76:	c3                   	ret    

c0102a77 <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
c0102a77:	55                   	push   %ebp
c0102a78:	89 e5                	mov    %esp,%ebp
c0102a7a:	83 ec 08             	sub    $0x8,%esp
    return pa2page(PDE_ADDR(pde));
c0102a7d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a80:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0102a85:	83 ec 0c             	sub    $0xc,%esp
c0102a88:	50                   	push   %eax
c0102a89:	e8 23 ff ff ff       	call   c01029b1 <pa2page>
c0102a8e:	83 c4 10             	add    $0x10,%esp
}
c0102a91:	c9                   	leave  
c0102a92:	c3                   	ret    

c0102a93 <page_ref>:

static inline int
page_ref(struct Page *page) {
c0102a93:	55                   	push   %ebp
c0102a94:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0102a96:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a99:	8b 00                	mov    (%eax),%eax
}
c0102a9b:	5d                   	pop    %ebp
c0102a9c:	c3                   	ret    

c0102a9d <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0102a9d:	55                   	push   %ebp
c0102a9e:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0102aa0:	8b 45 08             	mov    0x8(%ebp),%eax
c0102aa3:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102aa6:	89 10                	mov    %edx,(%eax)
}
c0102aa8:	90                   	nop
c0102aa9:	5d                   	pop    %ebp
c0102aaa:	c3                   	ret    

c0102aab <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c0102aab:	55                   	push   %ebp
c0102aac:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c0102aae:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ab1:	8b 00                	mov    (%eax),%eax
c0102ab3:	8d 50 01             	lea    0x1(%eax),%edx
c0102ab6:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ab9:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0102abb:	8b 45 08             	mov    0x8(%ebp),%eax
c0102abe:	8b 00                	mov    (%eax),%eax
}
c0102ac0:	5d                   	pop    %ebp
c0102ac1:	c3                   	ret    

c0102ac2 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c0102ac2:	55                   	push   %ebp
c0102ac3:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c0102ac5:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ac8:	8b 00                	mov    (%eax),%eax
c0102aca:	8d 50 ff             	lea    -0x1(%eax),%edx
c0102acd:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ad0:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0102ad2:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ad5:	8b 00                	mov    (%eax),%eax
}
c0102ad7:	5d                   	pop    %ebp
c0102ad8:	c3                   	ret    

c0102ad9 <__intr_save>:
__intr_save(void) {
c0102ad9:	55                   	push   %ebp
c0102ada:	89 e5                	mov    %esp,%ebp
c0102adc:	83 ec 18             	sub    $0x18,%esp
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0102adf:	9c                   	pushf  
c0102ae0:	58                   	pop    %eax
c0102ae1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0102ae4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0102ae7:	25 00 02 00 00       	and    $0x200,%eax
c0102aec:	85 c0                	test   %eax,%eax
c0102aee:	74 0c                	je     c0102afc <__intr_save+0x23>
        intr_disable();
c0102af0:	e8 87 ee ff ff       	call   c010197c <intr_disable>
        return 1;
c0102af5:	b8 01 00 00 00       	mov    $0x1,%eax
c0102afa:	eb 05                	jmp    c0102b01 <__intr_save+0x28>
    return 0;
c0102afc:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0102b01:	c9                   	leave  
c0102b02:	c3                   	ret    

c0102b03 <__intr_restore>:
__intr_restore(bool flag) {
c0102b03:	55                   	push   %ebp
c0102b04:	89 e5                	mov    %esp,%ebp
c0102b06:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0102b09:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0102b0d:	74 05                	je     c0102b14 <__intr_restore+0x11>
        intr_enable();
c0102b0f:	e8 5c ee ff ff       	call   c0101970 <intr_enable>
}
c0102b14:	90                   	nop
c0102b15:	c9                   	leave  
c0102b16:	c3                   	ret    

c0102b17 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0102b17:	55                   	push   %ebp
c0102b18:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0102b1a:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b1d:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c0102b20:	b8 23 00 00 00       	mov    $0x23,%eax
c0102b25:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c0102b27:	b8 23 00 00 00       	mov    $0x23,%eax
c0102b2c:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c0102b2e:	b8 10 00 00 00       	mov    $0x10,%eax
c0102b33:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c0102b35:	b8 10 00 00 00       	mov    $0x10,%eax
c0102b3a:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0102b3c:	b8 10 00 00 00       	mov    $0x10,%eax
c0102b41:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0102b43:	ea 4a 2b 10 c0 08 00 	ljmp   $0x8,$0xc0102b4a
}
c0102b4a:	90                   	nop
c0102b4b:	5d                   	pop    %ebp
c0102b4c:	c3                   	ret    

c0102b4d <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0102b4d:	f3 0f 1e fb          	endbr32 
c0102b51:	55                   	push   %ebp
c0102b52:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0102b54:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b57:	a3 a4 ce 11 c0       	mov    %eax,0xc011cea4
}
c0102b5c:	90                   	nop
c0102b5d:	5d                   	pop    %ebp
c0102b5e:	c3                   	ret    

c0102b5f <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0102b5f:	f3 0f 1e fb          	endbr32 
c0102b63:	55                   	push   %ebp
c0102b64:	89 e5                	mov    %esp,%ebp
c0102b66:	83 ec 10             	sub    $0x10,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0102b69:	b8 00 90 11 c0       	mov    $0xc0119000,%eax
c0102b6e:	50                   	push   %eax
c0102b6f:	e8 d9 ff ff ff       	call   c0102b4d <load_esp0>
c0102b74:	83 c4 04             	add    $0x4,%esp
    ts.ts_ss0 = KERNEL_DS;
c0102b77:	66 c7 05 a8 ce 11 c0 	movw   $0x10,0xc011cea8
c0102b7e:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0102b80:	66 c7 05 28 9a 11 c0 	movw   $0x68,0xc0119a28
c0102b87:	68 00 
c0102b89:	b8 a0 ce 11 c0       	mov    $0xc011cea0,%eax
c0102b8e:	66 a3 2a 9a 11 c0    	mov    %ax,0xc0119a2a
c0102b94:	b8 a0 ce 11 c0       	mov    $0xc011cea0,%eax
c0102b99:	c1 e8 10             	shr    $0x10,%eax
c0102b9c:	a2 2c 9a 11 c0       	mov    %al,0xc0119a2c
c0102ba1:	0f b6 05 2d 9a 11 c0 	movzbl 0xc0119a2d,%eax
c0102ba8:	83 e0 f0             	and    $0xfffffff0,%eax
c0102bab:	83 c8 09             	or     $0x9,%eax
c0102bae:	a2 2d 9a 11 c0       	mov    %al,0xc0119a2d
c0102bb3:	0f b6 05 2d 9a 11 c0 	movzbl 0xc0119a2d,%eax
c0102bba:	83 e0 ef             	and    $0xffffffef,%eax
c0102bbd:	a2 2d 9a 11 c0       	mov    %al,0xc0119a2d
c0102bc2:	0f b6 05 2d 9a 11 c0 	movzbl 0xc0119a2d,%eax
c0102bc9:	83 e0 9f             	and    $0xffffff9f,%eax
c0102bcc:	a2 2d 9a 11 c0       	mov    %al,0xc0119a2d
c0102bd1:	0f b6 05 2d 9a 11 c0 	movzbl 0xc0119a2d,%eax
c0102bd8:	83 c8 80             	or     $0xffffff80,%eax
c0102bdb:	a2 2d 9a 11 c0       	mov    %al,0xc0119a2d
c0102be0:	0f b6 05 2e 9a 11 c0 	movzbl 0xc0119a2e,%eax
c0102be7:	83 e0 f0             	and    $0xfffffff0,%eax
c0102bea:	a2 2e 9a 11 c0       	mov    %al,0xc0119a2e
c0102bef:	0f b6 05 2e 9a 11 c0 	movzbl 0xc0119a2e,%eax
c0102bf6:	83 e0 ef             	and    $0xffffffef,%eax
c0102bf9:	a2 2e 9a 11 c0       	mov    %al,0xc0119a2e
c0102bfe:	0f b6 05 2e 9a 11 c0 	movzbl 0xc0119a2e,%eax
c0102c05:	83 e0 df             	and    $0xffffffdf,%eax
c0102c08:	a2 2e 9a 11 c0       	mov    %al,0xc0119a2e
c0102c0d:	0f b6 05 2e 9a 11 c0 	movzbl 0xc0119a2e,%eax
c0102c14:	83 c8 40             	or     $0x40,%eax
c0102c17:	a2 2e 9a 11 c0       	mov    %al,0xc0119a2e
c0102c1c:	0f b6 05 2e 9a 11 c0 	movzbl 0xc0119a2e,%eax
c0102c23:	83 e0 7f             	and    $0x7f,%eax
c0102c26:	a2 2e 9a 11 c0       	mov    %al,0xc0119a2e
c0102c2b:	b8 a0 ce 11 c0       	mov    $0xc011cea0,%eax
c0102c30:	c1 e8 18             	shr    $0x18,%eax
c0102c33:	a2 2f 9a 11 c0       	mov    %al,0xc0119a2f

    // reload all segment registers
    lgdt(&gdt_pd);
c0102c38:	68 30 9a 11 c0       	push   $0xc0119a30
c0102c3d:	e8 d5 fe ff ff       	call   c0102b17 <lgdt>
c0102c42:	83 c4 04             	add    $0x4,%esp
c0102c45:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0102c4b:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0102c4f:	0f 00 d8             	ltr    %ax
}
c0102c52:	90                   	nop

    // load the TSS
    ltr(GD_TSS);
}
c0102c53:	90                   	nop
c0102c54:	c9                   	leave  
c0102c55:	c3                   	ret    

c0102c56 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c0102c56:	f3 0f 1e fb          	endbr32 
c0102c5a:	55                   	push   %ebp
c0102c5b:	89 e5                	mov    %esp,%ebp
c0102c5d:	83 ec 08             	sub    $0x8,%esp
    pmm_manager = &default_pmm_manager;
c0102c60:	c7 05 10 cf 11 c0 88 	movl   $0xc0106d88,0xc011cf10
c0102c67:	6d 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c0102c6a:	a1 10 cf 11 c0       	mov    0xc011cf10,%eax
c0102c6f:	8b 00                	mov    (%eax),%eax
c0102c71:	83 ec 08             	sub    $0x8,%esp
c0102c74:	50                   	push   %eax
c0102c75:	68 10 64 10 c0       	push   $0xc0106410
c0102c7a:	e8 1c d6 ff ff       	call   c010029b <cprintf>
c0102c7f:	83 c4 10             	add    $0x10,%esp
    pmm_manager->init();
c0102c82:	a1 10 cf 11 c0       	mov    0xc011cf10,%eax
c0102c87:	8b 40 04             	mov    0x4(%eax),%eax
c0102c8a:	ff d0                	call   *%eax
}
c0102c8c:	90                   	nop
c0102c8d:	c9                   	leave  
c0102c8e:	c3                   	ret    

c0102c8f <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0102c8f:	f3 0f 1e fb          	endbr32 
c0102c93:	55                   	push   %ebp
c0102c94:	89 e5                	mov    %esp,%ebp
c0102c96:	83 ec 08             	sub    $0x8,%esp
    pmm_manager->init_memmap(base, n);
c0102c99:	a1 10 cf 11 c0       	mov    0xc011cf10,%eax
c0102c9e:	8b 40 08             	mov    0x8(%eax),%eax
c0102ca1:	83 ec 08             	sub    $0x8,%esp
c0102ca4:	ff 75 0c             	pushl  0xc(%ebp)
c0102ca7:	ff 75 08             	pushl  0x8(%ebp)
c0102caa:	ff d0                	call   *%eax
c0102cac:	83 c4 10             	add    $0x10,%esp
}
c0102caf:	90                   	nop
c0102cb0:	c9                   	leave  
c0102cb1:	c3                   	ret    

c0102cb2 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c0102cb2:	f3 0f 1e fb          	endbr32 
c0102cb6:	55                   	push   %ebp
c0102cb7:	89 e5                	mov    %esp,%ebp
c0102cb9:	83 ec 18             	sub    $0x18,%esp
    struct Page *page=NULL;
c0102cbc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0102cc3:	e8 11 fe ff ff       	call   c0102ad9 <__intr_save>
c0102cc8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
c0102ccb:	a1 10 cf 11 c0       	mov    0xc011cf10,%eax
c0102cd0:	8b 40 0c             	mov    0xc(%eax),%eax
c0102cd3:	83 ec 0c             	sub    $0xc,%esp
c0102cd6:	ff 75 08             	pushl  0x8(%ebp)
c0102cd9:	ff d0                	call   *%eax
c0102cdb:	83 c4 10             	add    $0x10,%esp
c0102cde:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
c0102ce1:	83 ec 0c             	sub    $0xc,%esp
c0102ce4:	ff 75 f0             	pushl  -0x10(%ebp)
c0102ce7:	e8 17 fe ff ff       	call   c0102b03 <__intr_restore>
c0102cec:	83 c4 10             	add    $0x10,%esp
    return page;
c0102cef:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0102cf2:	c9                   	leave  
c0102cf3:	c3                   	ret    

c0102cf4 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0102cf4:	f3 0f 1e fb          	endbr32 
c0102cf8:	55                   	push   %ebp
c0102cf9:	89 e5                	mov    %esp,%ebp
c0102cfb:	83 ec 18             	sub    $0x18,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0102cfe:	e8 d6 fd ff ff       	call   c0102ad9 <__intr_save>
c0102d03:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0102d06:	a1 10 cf 11 c0       	mov    0xc011cf10,%eax
c0102d0b:	8b 40 10             	mov    0x10(%eax),%eax
c0102d0e:	83 ec 08             	sub    $0x8,%esp
c0102d11:	ff 75 0c             	pushl  0xc(%ebp)
c0102d14:	ff 75 08             	pushl  0x8(%ebp)
c0102d17:	ff d0                	call   *%eax
c0102d19:	83 c4 10             	add    $0x10,%esp
    }
    local_intr_restore(intr_flag);
c0102d1c:	83 ec 0c             	sub    $0xc,%esp
c0102d1f:	ff 75 f4             	pushl  -0xc(%ebp)
c0102d22:	e8 dc fd ff ff       	call   c0102b03 <__intr_restore>
c0102d27:	83 c4 10             	add    $0x10,%esp
}
c0102d2a:	90                   	nop
c0102d2b:	c9                   	leave  
c0102d2c:	c3                   	ret    

c0102d2d <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c0102d2d:	f3 0f 1e fb          	endbr32 
c0102d31:	55                   	push   %ebp
c0102d32:	89 e5                	mov    %esp,%ebp
c0102d34:	83 ec 18             	sub    $0x18,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c0102d37:	e8 9d fd ff ff       	call   c0102ad9 <__intr_save>
c0102d3c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c0102d3f:	a1 10 cf 11 c0       	mov    0xc011cf10,%eax
c0102d44:	8b 40 14             	mov    0x14(%eax),%eax
c0102d47:	ff d0                	call   *%eax
c0102d49:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c0102d4c:	83 ec 0c             	sub    $0xc,%esp
c0102d4f:	ff 75 f4             	pushl  -0xc(%ebp)
c0102d52:	e8 ac fd ff ff       	call   c0102b03 <__intr_restore>
c0102d57:	83 c4 10             	add    $0x10,%esp
    return ret;
c0102d5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0102d5d:	c9                   	leave  
c0102d5e:	c3                   	ret    

c0102d5f <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c0102d5f:	f3 0f 1e fb          	endbr32 
c0102d63:	55                   	push   %ebp
c0102d64:	89 e5                	mov    %esp,%ebp
c0102d66:	57                   	push   %edi
c0102d67:	56                   	push   %esi
c0102d68:	53                   	push   %ebx
c0102d69:	83 ec 7c             	sub    $0x7c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c0102d6c:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c0102d73:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0102d7a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c0102d81:	83 ec 0c             	sub    $0xc,%esp
c0102d84:	68 27 64 10 c0       	push   $0xc0106427
c0102d89:	e8 0d d5 ff ff       	call   c010029b <cprintf>
c0102d8e:	83 c4 10             	add    $0x10,%esp
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0102d91:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0102d98:	e9 f4 00 00 00       	jmp    c0102e91 <page_init+0x132>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0102d9d:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102da0:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102da3:	89 d0                	mov    %edx,%eax
c0102da5:	c1 e0 02             	shl    $0x2,%eax
c0102da8:	01 d0                	add    %edx,%eax
c0102daa:	c1 e0 02             	shl    $0x2,%eax
c0102dad:	01 c8                	add    %ecx,%eax
c0102daf:	8b 50 08             	mov    0x8(%eax),%edx
c0102db2:	8b 40 04             	mov    0x4(%eax),%eax
c0102db5:	89 45 a0             	mov    %eax,-0x60(%ebp)
c0102db8:	89 55 a4             	mov    %edx,-0x5c(%ebp)
c0102dbb:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102dbe:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102dc1:	89 d0                	mov    %edx,%eax
c0102dc3:	c1 e0 02             	shl    $0x2,%eax
c0102dc6:	01 d0                	add    %edx,%eax
c0102dc8:	c1 e0 02             	shl    $0x2,%eax
c0102dcb:	01 c8                	add    %ecx,%eax
c0102dcd:	8b 48 0c             	mov    0xc(%eax),%ecx
c0102dd0:	8b 58 10             	mov    0x10(%eax),%ebx
c0102dd3:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0102dd6:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0102dd9:	01 c8                	add    %ecx,%eax
c0102ddb:	11 da                	adc    %ebx,%edx
c0102ddd:	89 45 98             	mov    %eax,-0x68(%ebp)
c0102de0:	89 55 9c             	mov    %edx,-0x64(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0102de3:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102de6:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102de9:	89 d0                	mov    %edx,%eax
c0102deb:	c1 e0 02             	shl    $0x2,%eax
c0102dee:	01 d0                	add    %edx,%eax
c0102df0:	c1 e0 02             	shl    $0x2,%eax
c0102df3:	01 c8                	add    %ecx,%eax
c0102df5:	83 c0 14             	add    $0x14,%eax
c0102df8:	8b 00                	mov    (%eax),%eax
c0102dfa:	89 45 84             	mov    %eax,-0x7c(%ebp)
c0102dfd:	8b 45 98             	mov    -0x68(%ebp),%eax
c0102e00:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0102e03:	83 c0 ff             	add    $0xffffffff,%eax
c0102e06:	83 d2 ff             	adc    $0xffffffff,%edx
c0102e09:	89 c1                	mov    %eax,%ecx
c0102e0b:	89 d3                	mov    %edx,%ebx
c0102e0d:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0102e10:	89 55 80             	mov    %edx,-0x80(%ebp)
c0102e13:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102e16:	89 d0                	mov    %edx,%eax
c0102e18:	c1 e0 02             	shl    $0x2,%eax
c0102e1b:	01 d0                	add    %edx,%eax
c0102e1d:	c1 e0 02             	shl    $0x2,%eax
c0102e20:	03 45 80             	add    -0x80(%ebp),%eax
c0102e23:	8b 50 10             	mov    0x10(%eax),%edx
c0102e26:	8b 40 0c             	mov    0xc(%eax),%eax
c0102e29:	ff 75 84             	pushl  -0x7c(%ebp)
c0102e2c:	53                   	push   %ebx
c0102e2d:	51                   	push   %ecx
c0102e2e:	ff 75 a4             	pushl  -0x5c(%ebp)
c0102e31:	ff 75 a0             	pushl  -0x60(%ebp)
c0102e34:	52                   	push   %edx
c0102e35:	50                   	push   %eax
c0102e36:	68 34 64 10 c0       	push   $0xc0106434
c0102e3b:	e8 5b d4 ff ff       	call   c010029b <cprintf>
c0102e40:	83 c4 20             	add    $0x20,%esp
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c0102e43:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102e46:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102e49:	89 d0                	mov    %edx,%eax
c0102e4b:	c1 e0 02             	shl    $0x2,%eax
c0102e4e:	01 d0                	add    %edx,%eax
c0102e50:	c1 e0 02             	shl    $0x2,%eax
c0102e53:	01 c8                	add    %ecx,%eax
c0102e55:	83 c0 14             	add    $0x14,%eax
c0102e58:	8b 00                	mov    (%eax),%eax
c0102e5a:	83 f8 01             	cmp    $0x1,%eax
c0102e5d:	75 2e                	jne    c0102e8d <page_init+0x12e>
            if (maxpa < end && begin < KMEMSIZE) {
c0102e5f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102e62:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0102e65:	3b 45 98             	cmp    -0x68(%ebp),%eax
c0102e68:	89 d0                	mov    %edx,%eax
c0102e6a:	1b 45 9c             	sbb    -0x64(%ebp),%eax
c0102e6d:	73 1e                	jae    c0102e8d <page_init+0x12e>
c0102e6f:	ba ff ff ff 37       	mov    $0x37ffffff,%edx
c0102e74:	b8 00 00 00 00       	mov    $0x0,%eax
c0102e79:	3b 55 a0             	cmp    -0x60(%ebp),%edx
c0102e7c:	1b 45 a4             	sbb    -0x5c(%ebp),%eax
c0102e7f:	72 0c                	jb     c0102e8d <page_init+0x12e>
                maxpa = end;
c0102e81:	8b 45 98             	mov    -0x68(%ebp),%eax
c0102e84:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0102e87:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0102e8a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    for (i = 0; i < memmap->nr_map; i ++) {
c0102e8d:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0102e91:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102e94:	8b 00                	mov    (%eax),%eax
c0102e96:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0102e99:	0f 8c fe fe ff ff    	jl     c0102d9d <page_init+0x3e>
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c0102e9f:	ba 00 00 00 38       	mov    $0x38000000,%edx
c0102ea4:	b8 00 00 00 00       	mov    $0x0,%eax
c0102ea9:	3b 55 e0             	cmp    -0x20(%ebp),%edx
c0102eac:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
c0102eaf:	73 0e                	jae    c0102ebf <page_init+0x160>
        maxpa = KMEMSIZE;
c0102eb1:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c0102eb8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c0102ebf:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102ec2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0102ec5:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0102ec9:	c1 ea 0c             	shr    $0xc,%edx
c0102ecc:	a3 80 ce 11 c0       	mov    %eax,0xc011ce80
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c0102ed1:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
c0102ed8:	b8 28 cf 11 c0       	mov    $0xc011cf28,%eax
c0102edd:	8d 50 ff             	lea    -0x1(%eax),%edx
c0102ee0:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0102ee3:	01 d0                	add    %edx,%eax
c0102ee5:	89 45 bc             	mov    %eax,-0x44(%ebp)
c0102ee8:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102eeb:	ba 00 00 00 00       	mov    $0x0,%edx
c0102ef0:	f7 75 c0             	divl   -0x40(%ebp)
c0102ef3:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102ef6:	29 d0                	sub    %edx,%eax
c0102ef8:	a3 18 cf 11 c0       	mov    %eax,0xc011cf18

    for (i = 0; i < npage; i ++) {
c0102efd:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0102f04:	eb 30                	jmp    c0102f36 <page_init+0x1d7>
        SetPageReserved(pages + i);
c0102f06:	8b 0d 18 cf 11 c0    	mov    0xc011cf18,%ecx
c0102f0c:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102f0f:	89 d0                	mov    %edx,%eax
c0102f11:	c1 e0 02             	shl    $0x2,%eax
c0102f14:	01 d0                	add    %edx,%eax
c0102f16:	c1 e0 02             	shl    $0x2,%eax
c0102f19:	01 c8                	add    %ecx,%eax
c0102f1b:	83 c0 04             	add    $0x4,%eax
c0102f1e:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
c0102f25:	89 45 90             	mov    %eax,-0x70(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102f28:	8b 45 90             	mov    -0x70(%ebp),%eax
c0102f2b:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0102f2e:	0f ab 10             	bts    %edx,(%eax)
}
c0102f31:	90                   	nop
    for (i = 0; i < npage; i ++) {
c0102f32:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0102f36:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102f39:	a1 80 ce 11 c0       	mov    0xc011ce80,%eax
c0102f3e:	39 c2                	cmp    %eax,%edx
c0102f40:	72 c4                	jb     c0102f06 <page_init+0x1a7>
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c0102f42:	8b 15 80 ce 11 c0    	mov    0xc011ce80,%edx
c0102f48:	89 d0                	mov    %edx,%eax
c0102f4a:	c1 e0 02             	shl    $0x2,%eax
c0102f4d:	01 d0                	add    %edx,%eax
c0102f4f:	c1 e0 02             	shl    $0x2,%eax
c0102f52:	89 c2                	mov    %eax,%edx
c0102f54:	a1 18 cf 11 c0       	mov    0xc011cf18,%eax
c0102f59:	01 d0                	add    %edx,%eax
c0102f5b:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0102f5e:	81 7d b8 ff ff ff bf 	cmpl   $0xbfffffff,-0x48(%ebp)
c0102f65:	77 17                	ja     c0102f7e <page_init+0x21f>
c0102f67:	ff 75 b8             	pushl  -0x48(%ebp)
c0102f6a:	68 64 64 10 c0       	push   $0xc0106464
c0102f6f:	68 dc 00 00 00       	push   $0xdc
c0102f74:	68 88 64 10 c0       	push   $0xc0106488
c0102f79:	e8 98 d4 ff ff       	call   c0100416 <__panic>
c0102f7e:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0102f81:	05 00 00 00 40       	add    $0x40000000,%eax
c0102f86:	89 45 b4             	mov    %eax,-0x4c(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c0102f89:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0102f90:	e9 53 01 00 00       	jmp    c01030e8 <page_init+0x389>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0102f95:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102f98:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102f9b:	89 d0                	mov    %edx,%eax
c0102f9d:	c1 e0 02             	shl    $0x2,%eax
c0102fa0:	01 d0                	add    %edx,%eax
c0102fa2:	c1 e0 02             	shl    $0x2,%eax
c0102fa5:	01 c8                	add    %ecx,%eax
c0102fa7:	8b 50 08             	mov    0x8(%eax),%edx
c0102faa:	8b 40 04             	mov    0x4(%eax),%eax
c0102fad:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0102fb0:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0102fb3:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102fb6:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102fb9:	89 d0                	mov    %edx,%eax
c0102fbb:	c1 e0 02             	shl    $0x2,%eax
c0102fbe:	01 d0                	add    %edx,%eax
c0102fc0:	c1 e0 02             	shl    $0x2,%eax
c0102fc3:	01 c8                	add    %ecx,%eax
c0102fc5:	8b 48 0c             	mov    0xc(%eax),%ecx
c0102fc8:	8b 58 10             	mov    0x10(%eax),%ebx
c0102fcb:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102fce:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102fd1:	01 c8                	add    %ecx,%eax
c0102fd3:	11 da                	adc    %ebx,%edx
c0102fd5:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0102fd8:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c0102fdb:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102fde:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102fe1:	89 d0                	mov    %edx,%eax
c0102fe3:	c1 e0 02             	shl    $0x2,%eax
c0102fe6:	01 d0                	add    %edx,%eax
c0102fe8:	c1 e0 02             	shl    $0x2,%eax
c0102feb:	01 c8                	add    %ecx,%eax
c0102fed:	83 c0 14             	add    $0x14,%eax
c0102ff0:	8b 00                	mov    (%eax),%eax
c0102ff2:	83 f8 01             	cmp    $0x1,%eax
c0102ff5:	0f 85 e9 00 00 00    	jne    c01030e4 <page_init+0x385>
            if (begin < freemem) {
c0102ffb:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0102ffe:	ba 00 00 00 00       	mov    $0x0,%edx
c0103003:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c0103006:	39 45 d0             	cmp    %eax,-0x30(%ebp)
c0103009:	19 d1                	sbb    %edx,%ecx
c010300b:	73 0d                	jae    c010301a <page_init+0x2bb>
                begin = freemem;
c010300d:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103010:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103013:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c010301a:	ba 00 00 00 38       	mov    $0x38000000,%edx
c010301f:	b8 00 00 00 00       	mov    $0x0,%eax
c0103024:	3b 55 c8             	cmp    -0x38(%ebp),%edx
c0103027:	1b 45 cc             	sbb    -0x34(%ebp),%eax
c010302a:	73 0e                	jae    c010303a <page_init+0x2db>
                end = KMEMSIZE;
c010302c:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c0103033:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c010303a:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010303d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103040:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0103043:	89 d0                	mov    %edx,%eax
c0103045:	1b 45 cc             	sbb    -0x34(%ebp),%eax
c0103048:	0f 83 96 00 00 00    	jae    c01030e4 <page_init+0x385>
                begin = ROUNDUP(begin, PGSIZE);
c010304e:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
c0103055:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0103058:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010305b:	01 d0                	add    %edx,%eax
c010305d:	83 e8 01             	sub    $0x1,%eax
c0103060:	89 45 ac             	mov    %eax,-0x54(%ebp)
c0103063:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0103066:	ba 00 00 00 00       	mov    $0x0,%edx
c010306b:	f7 75 b0             	divl   -0x50(%ebp)
c010306e:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0103071:	29 d0                	sub    %edx,%eax
c0103073:	ba 00 00 00 00       	mov    $0x0,%edx
c0103078:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010307b:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c010307e:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0103081:	89 45 a8             	mov    %eax,-0x58(%ebp)
c0103084:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0103087:	ba 00 00 00 00       	mov    $0x0,%edx
c010308c:	89 c3                	mov    %eax,%ebx
c010308e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
c0103094:	89 de                	mov    %ebx,%esi
c0103096:	89 d0                	mov    %edx,%eax
c0103098:	83 e0 00             	and    $0x0,%eax
c010309b:	89 c7                	mov    %eax,%edi
c010309d:	89 75 c8             	mov    %esi,-0x38(%ebp)
c01030a0:	89 7d cc             	mov    %edi,-0x34(%ebp)
                if (begin < end) {
c01030a3:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01030a6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01030a9:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c01030ac:	89 d0                	mov    %edx,%eax
c01030ae:	1b 45 cc             	sbb    -0x34(%ebp),%eax
c01030b1:	73 31                	jae    c01030e4 <page_init+0x385>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c01030b3:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01030b6:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01030b9:	2b 45 d0             	sub    -0x30(%ebp),%eax
c01030bc:	1b 55 d4             	sbb    -0x2c(%ebp),%edx
c01030bf:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c01030c3:	c1 ea 0c             	shr    $0xc,%edx
c01030c6:	89 c3                	mov    %eax,%ebx
c01030c8:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01030cb:	83 ec 0c             	sub    $0xc,%esp
c01030ce:	50                   	push   %eax
c01030cf:	e8 dd f8 ff ff       	call   c01029b1 <pa2page>
c01030d4:	83 c4 10             	add    $0x10,%esp
c01030d7:	83 ec 08             	sub    $0x8,%esp
c01030da:	53                   	push   %ebx
c01030db:	50                   	push   %eax
c01030dc:	e8 ae fb ff ff       	call   c0102c8f <init_memmap>
c01030e1:	83 c4 10             	add    $0x10,%esp
    for (i = 0; i < memmap->nr_map; i ++) {
c01030e4:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c01030e8:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01030eb:	8b 00                	mov    (%eax),%eax
c01030ed:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c01030f0:	0f 8c 9f fe ff ff    	jl     c0102f95 <page_init+0x236>
                }
            }
        }
    }
}
c01030f6:	90                   	nop
c01030f7:	90                   	nop
c01030f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
c01030fb:	5b                   	pop    %ebx
c01030fc:	5e                   	pop    %esi
c01030fd:	5f                   	pop    %edi
c01030fe:	5d                   	pop    %ebp
c01030ff:	c3                   	ret    

c0103100 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c0103100:	f3 0f 1e fb          	endbr32 
c0103104:	55                   	push   %ebp
c0103105:	89 e5                	mov    %esp,%ebp
c0103107:	83 ec 28             	sub    $0x28,%esp
    assert(PGOFF(la) == PGOFF(pa));
c010310a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010310d:	33 45 14             	xor    0x14(%ebp),%eax
c0103110:	25 ff 0f 00 00       	and    $0xfff,%eax
c0103115:	85 c0                	test   %eax,%eax
c0103117:	74 19                	je     c0103132 <boot_map_segment+0x32>
c0103119:	68 96 64 10 c0       	push   $0xc0106496
c010311e:	68 ad 64 10 c0       	push   $0xc01064ad
c0103123:	68 fa 00 00 00       	push   $0xfa
c0103128:	68 88 64 10 c0       	push   $0xc0106488
c010312d:	e8 e4 d2 ff ff       	call   c0100416 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c0103132:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c0103139:	8b 45 0c             	mov    0xc(%ebp),%eax
c010313c:	25 ff 0f 00 00       	and    $0xfff,%eax
c0103141:	89 c2                	mov    %eax,%edx
c0103143:	8b 45 10             	mov    0x10(%ebp),%eax
c0103146:	01 c2                	add    %eax,%edx
c0103148:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010314b:	01 d0                	add    %edx,%eax
c010314d:	83 e8 01             	sub    $0x1,%eax
c0103150:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103153:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103156:	ba 00 00 00 00       	mov    $0x0,%edx
c010315b:	f7 75 f0             	divl   -0x10(%ebp)
c010315e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103161:	29 d0                	sub    %edx,%eax
c0103163:	c1 e8 0c             	shr    $0xc,%eax
c0103166:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c0103169:	8b 45 0c             	mov    0xc(%ebp),%eax
c010316c:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010316f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103172:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103177:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c010317a:	8b 45 14             	mov    0x14(%ebp),%eax
c010317d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103180:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103183:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103188:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c010318b:	eb 57                	jmp    c01031e4 <boot_map_segment+0xe4>
        pte_t *ptep = get_pte(pgdir, la, 1);
c010318d:	83 ec 04             	sub    $0x4,%esp
c0103190:	6a 01                	push   $0x1
c0103192:	ff 75 0c             	pushl  0xc(%ebp)
c0103195:	ff 75 08             	pushl  0x8(%ebp)
c0103198:	e8 5c 01 00 00       	call   c01032f9 <get_pte>
c010319d:	83 c4 10             	add    $0x10,%esp
c01031a0:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c01031a3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c01031a7:	75 19                	jne    c01031c2 <boot_map_segment+0xc2>
c01031a9:	68 c2 64 10 c0       	push   $0xc01064c2
c01031ae:	68 ad 64 10 c0       	push   $0xc01064ad
c01031b3:	68 00 01 00 00       	push   $0x100
c01031b8:	68 88 64 10 c0       	push   $0xc0106488
c01031bd:	e8 54 d2 ff ff       	call   c0100416 <__panic>
        *ptep = pa | PTE_P | perm;
c01031c2:	8b 45 14             	mov    0x14(%ebp),%eax
c01031c5:	0b 45 18             	or     0x18(%ebp),%eax
c01031c8:	83 c8 01             	or     $0x1,%eax
c01031cb:	89 c2                	mov    %eax,%edx
c01031cd:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01031d0:	89 10                	mov    %edx,(%eax)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c01031d2:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01031d6:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c01031dd:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c01031e4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01031e8:	75 a3                	jne    c010318d <boot_map_segment+0x8d>
    }
}
c01031ea:	90                   	nop
c01031eb:	90                   	nop
c01031ec:	c9                   	leave  
c01031ed:	c3                   	ret    

c01031ee <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c01031ee:	f3 0f 1e fb          	endbr32 
c01031f2:	55                   	push   %ebp
c01031f3:	89 e5                	mov    %esp,%ebp
c01031f5:	83 ec 18             	sub    $0x18,%esp
    struct Page *p = alloc_page();
c01031f8:	83 ec 0c             	sub    $0xc,%esp
c01031fb:	6a 01                	push   $0x1
c01031fd:	e8 b0 fa ff ff       	call   c0102cb2 <alloc_pages>
c0103202:	83 c4 10             	add    $0x10,%esp
c0103205:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c0103208:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010320c:	75 17                	jne    c0103225 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
c010320e:	83 ec 04             	sub    $0x4,%esp
c0103211:	68 cf 64 10 c0       	push   $0xc01064cf
c0103216:	68 0c 01 00 00       	push   $0x10c
c010321b:	68 88 64 10 c0       	push   $0xc0106488
c0103220:	e8 f1 d1 ff ff       	call   c0100416 <__panic>
    }
    return page2kva(p);
c0103225:	83 ec 0c             	sub    $0xc,%esp
c0103228:	ff 75 f4             	pushl  -0xc(%ebp)
c010322b:	e8 c8 f7 ff ff       	call   c01029f8 <page2kva>
c0103230:	83 c4 10             	add    $0x10,%esp
}
c0103233:	c9                   	leave  
c0103234:	c3                   	ret    

c0103235 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c0103235:	f3 0f 1e fb          	endbr32 
c0103239:	55                   	push   %ebp
c010323a:	89 e5                	mov    %esp,%ebp
c010323c:	83 ec 18             	sub    $0x18,%esp
    // We've already enabled paging
    boot_cr3 = PADDR(boot_pgdir);
c010323f:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103244:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103247:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c010324e:	77 17                	ja     c0103267 <pmm_init+0x32>
c0103250:	ff 75 f4             	pushl  -0xc(%ebp)
c0103253:	68 64 64 10 c0       	push   $0xc0106464
c0103258:	68 16 01 00 00       	push   $0x116
c010325d:	68 88 64 10 c0       	push   $0xc0106488
c0103262:	e8 af d1 ff ff       	call   c0100416 <__panic>
c0103267:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010326a:	05 00 00 00 40       	add    $0x40000000,%eax
c010326f:	a3 14 cf 11 c0       	mov    %eax,0xc011cf14
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c0103274:	e8 dd f9 ff ff       	call   c0102c56 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c0103279:	e8 e1 fa ff ff       	call   c0102d5f <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c010327e:	e8 a5 03 00 00       	call   c0103628 <check_alloc_page>

    check_pgdir();
c0103283:	e8 c7 03 00 00       	call   c010364f <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c0103288:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c010328d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103290:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c0103297:	77 17                	ja     c01032b0 <pmm_init+0x7b>
c0103299:	ff 75 f0             	pushl  -0x10(%ebp)
c010329c:	68 64 64 10 c0       	push   $0xc0106464
c01032a1:	68 2c 01 00 00       	push   $0x12c
c01032a6:	68 88 64 10 c0       	push   $0xc0106488
c01032ab:	e8 66 d1 ff ff       	call   c0100416 <__panic>
c01032b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01032b3:	8d 90 00 00 00 40    	lea    0x40000000(%eax),%edx
c01032b9:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c01032be:	05 ac 0f 00 00       	add    $0xfac,%eax
c01032c3:	83 ca 03             	or     $0x3,%edx
c01032c6:	89 10                	mov    %edx,(%eax)

    // map all physical memory to linear memory with base linear addr KERNBASE
    // linear_addr KERNBASE ~ KERNBASE + KMEMSIZE = phy_addr 0 ~ KMEMSIZE
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c01032c8:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c01032cd:	83 ec 0c             	sub    $0xc,%esp
c01032d0:	6a 02                	push   $0x2
c01032d2:	6a 00                	push   $0x0
c01032d4:	68 00 00 00 38       	push   $0x38000000
c01032d9:	68 00 00 00 c0       	push   $0xc0000000
c01032de:	50                   	push   %eax
c01032df:	e8 1c fe ff ff       	call   c0103100 <boot_map_segment>
c01032e4:	83 c4 20             	add    $0x20,%esp

    // Since we are using bootloader's GDT,
    // we should reload gdt (second time, the last time) to get user segments and the TSS
    // map virtual_addr 0 ~ 4G = linear_addr 0 ~ 4G
    // then set kernel stack (ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c01032e7:	e8 73 f8 ff ff       	call   c0102b5f <gdt_init>

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c01032ec:	e8 c8 08 00 00       	call   c0103bb9 <check_boot_pgdir>

    print_pgdir();
c01032f1:	e8 ca 0c 00 00       	call   c0103fc0 <print_pgdir>

}
c01032f6:	90                   	nop
c01032f7:	c9                   	leave  
c01032f8:	c3                   	ret    

c01032f9 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c01032f9:	f3 0f 1e fb          	endbr32 
c01032fd:	55                   	push   %ebp
c01032fe:	89 e5                	mov    %esp,%ebp
c0103300:	83 ec 28             	sub    $0x28,%esp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
    pde_t *pdep = &pgdir[PDX(la)];
c0103303:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103306:	c1 e8 16             	shr    $0x16,%eax
c0103309:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0103310:	8b 45 08             	mov    0x8(%ebp),%eax
c0103313:	01 d0                	add    %edx,%eax
c0103315:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (!(*pdep & PTE_P)) {
c0103318:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010331b:	8b 00                	mov    (%eax),%eax
c010331d:	83 e0 01             	and    $0x1,%eax
c0103320:	85 c0                	test   %eax,%eax
c0103322:	0f 85 9f 00 00 00    	jne    c01033c7 <get_pte+0xce>
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL) {
c0103328:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010332c:	74 16                	je     c0103344 <get_pte+0x4b>
c010332e:	83 ec 0c             	sub    $0xc,%esp
c0103331:	6a 01                	push   $0x1
c0103333:	e8 7a f9 ff ff       	call   c0102cb2 <alloc_pages>
c0103338:	83 c4 10             	add    $0x10,%esp
c010333b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010333e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103342:	75 0a                	jne    c010334e <get_pte+0x55>
            return NULL;
c0103344:	b8 00 00 00 00       	mov    $0x0,%eax
c0103349:	e9 ca 00 00 00       	jmp    c0103418 <get_pte+0x11f>
        }
        set_page_ref(page, 1);
c010334e:	83 ec 08             	sub    $0x8,%esp
c0103351:	6a 01                	push   $0x1
c0103353:	ff 75 f0             	pushl  -0x10(%ebp)
c0103356:	e8 42 f7 ff ff       	call   c0102a9d <set_page_ref>
c010335b:	83 c4 10             	add    $0x10,%esp
        uintptr_t pa = page2pa(page);
c010335e:	83 ec 0c             	sub    $0xc,%esp
c0103361:	ff 75 f0             	pushl  -0x10(%ebp)
c0103364:	e8 35 f6 ff ff       	call   c010299e <page2pa>
c0103369:	83 c4 10             	add    $0x10,%esp
c010336c:	89 45 ec             	mov    %eax,-0x14(%ebp)
        memset(KADDR(pa), 0, PGSIZE);
c010336f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103372:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0103375:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103378:	c1 e8 0c             	shr    $0xc,%eax
c010337b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010337e:	a1 80 ce 11 c0       	mov    0xc011ce80,%eax
c0103383:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0103386:	72 17                	jb     c010339f <get_pte+0xa6>
c0103388:	ff 75 e8             	pushl  -0x18(%ebp)
c010338b:	68 c0 63 10 c0       	push   $0xc01063c0
c0103390:	68 72 01 00 00       	push   $0x172
c0103395:	68 88 64 10 c0       	push   $0xc0106488
c010339a:	e8 77 d0 ff ff       	call   c0100416 <__panic>
c010339f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01033a2:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01033a7:	83 ec 04             	sub    $0x4,%esp
c01033aa:	68 00 10 00 00       	push   $0x1000
c01033af:	6a 00                	push   $0x0
c01033b1:	50                   	push   %eax
c01033b2:	e8 e8 20 00 00       	call   c010549f <memset>
c01033b7:	83 c4 10             	add    $0x10,%esp
        *pdep = pa | PTE_U | PTE_W | PTE_P;
c01033ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01033bd:	83 c8 07             	or     $0x7,%eax
c01033c0:	89 c2                	mov    %eax,%edx
c01033c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01033c5:	89 10                	mov    %edx,(%eax)
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)];
c01033c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01033ca:	8b 00                	mov    (%eax),%eax
c01033cc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01033d1:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01033d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01033d7:	c1 e8 0c             	shr    $0xc,%eax
c01033da:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01033dd:	a1 80 ce 11 c0       	mov    0xc011ce80,%eax
c01033e2:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c01033e5:	72 17                	jb     c01033fe <get_pte+0x105>
c01033e7:	ff 75 e0             	pushl  -0x20(%ebp)
c01033ea:	68 c0 63 10 c0       	push   $0xc01063c0
c01033ef:	68 75 01 00 00       	push   $0x175
c01033f4:	68 88 64 10 c0       	push   $0xc0106488
c01033f9:	e8 18 d0 ff ff       	call   c0100416 <__panic>
c01033fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103401:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0103406:	89 c2                	mov    %eax,%edx
c0103408:	8b 45 0c             	mov    0xc(%ebp),%eax
c010340b:	c1 e8 0c             	shr    $0xc,%eax
c010340e:	25 ff 03 00 00       	and    $0x3ff,%eax
c0103413:	c1 e0 02             	shl    $0x2,%eax
c0103416:	01 d0                	add    %edx,%eax
}
c0103418:	c9                   	leave  
c0103419:	c3                   	ret    

c010341a <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c010341a:	f3 0f 1e fb          	endbr32 
c010341e:	55                   	push   %ebp
c010341f:	89 e5                	mov    %esp,%ebp
c0103421:	83 ec 18             	sub    $0x18,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0103424:	83 ec 04             	sub    $0x4,%esp
c0103427:	6a 00                	push   $0x0
c0103429:	ff 75 0c             	pushl  0xc(%ebp)
c010342c:	ff 75 08             	pushl  0x8(%ebp)
c010342f:	e8 c5 fe ff ff       	call   c01032f9 <get_pte>
c0103434:	83 c4 10             	add    $0x10,%esp
c0103437:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c010343a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010343e:	74 08                	je     c0103448 <get_page+0x2e>
        *ptep_store = ptep;
c0103440:	8b 45 10             	mov    0x10(%ebp),%eax
c0103443:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103446:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c0103448:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010344c:	74 1f                	je     c010346d <get_page+0x53>
c010344e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103451:	8b 00                	mov    (%eax),%eax
c0103453:	83 e0 01             	and    $0x1,%eax
c0103456:	85 c0                	test   %eax,%eax
c0103458:	74 13                	je     c010346d <get_page+0x53>
        return pte2page(*ptep);
c010345a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010345d:	8b 00                	mov    (%eax),%eax
c010345f:	83 ec 0c             	sub    $0xc,%esp
c0103462:	50                   	push   %eax
c0103463:	e8 d5 f5 ff ff       	call   c0102a3d <pte2page>
c0103468:	83 c4 10             	add    $0x10,%esp
c010346b:	eb 05                	jmp    c0103472 <get_page+0x58>
    }
    return NULL;
c010346d:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103472:	c9                   	leave  
c0103473:	c3                   	ret    

c0103474 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c0103474:	55                   	push   %ebp
c0103475:	89 e5                	mov    %esp,%ebp
c0103477:	83 ec 18             	sub    $0x18,%esp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
    if (*ptep & PTE_P) {
c010347a:	8b 45 10             	mov    0x10(%ebp),%eax
c010347d:	8b 00                	mov    (%eax),%eax
c010347f:	83 e0 01             	and    $0x1,%eax
c0103482:	85 c0                	test   %eax,%eax
c0103484:	74 50                	je     c01034d6 <page_remove_pte+0x62>
        struct Page *page = pte2page(*ptep);
c0103486:	8b 45 10             	mov    0x10(%ebp),%eax
c0103489:	8b 00                	mov    (%eax),%eax
c010348b:	83 ec 0c             	sub    $0xc,%esp
c010348e:	50                   	push   %eax
c010348f:	e8 a9 f5 ff ff       	call   c0102a3d <pte2page>
c0103494:	83 c4 10             	add    $0x10,%esp
c0103497:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (page_ref_dec(page) == 0) {
c010349a:	83 ec 0c             	sub    $0xc,%esp
c010349d:	ff 75 f4             	pushl  -0xc(%ebp)
c01034a0:	e8 1d f6 ff ff       	call   c0102ac2 <page_ref_dec>
c01034a5:	83 c4 10             	add    $0x10,%esp
c01034a8:	85 c0                	test   %eax,%eax
c01034aa:	75 10                	jne    c01034bc <page_remove_pte+0x48>
            free_page(page);
c01034ac:	83 ec 08             	sub    $0x8,%esp
c01034af:	6a 01                	push   $0x1
c01034b1:	ff 75 f4             	pushl  -0xc(%ebp)
c01034b4:	e8 3b f8 ff ff       	call   c0102cf4 <free_pages>
c01034b9:	83 c4 10             	add    $0x10,%esp
        }
        *ptep = 0;
c01034bc:	8b 45 10             	mov    0x10(%ebp),%eax
c01034bf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tlb_invalidate(pgdir, la);
c01034c5:	83 ec 08             	sub    $0x8,%esp
c01034c8:	ff 75 0c             	pushl  0xc(%ebp)
c01034cb:	ff 75 08             	pushl  0x8(%ebp)
c01034ce:	e8 00 01 00 00       	call   c01035d3 <tlb_invalidate>
c01034d3:	83 c4 10             	add    $0x10,%esp
    }
}
c01034d6:	90                   	nop
c01034d7:	c9                   	leave  
c01034d8:	c3                   	ret    

c01034d9 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c01034d9:	f3 0f 1e fb          	endbr32 
c01034dd:	55                   	push   %ebp
c01034de:	89 e5                	mov    %esp,%ebp
c01034e0:	83 ec 18             	sub    $0x18,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c01034e3:	83 ec 04             	sub    $0x4,%esp
c01034e6:	6a 00                	push   $0x0
c01034e8:	ff 75 0c             	pushl  0xc(%ebp)
c01034eb:	ff 75 08             	pushl  0x8(%ebp)
c01034ee:	e8 06 fe ff ff       	call   c01032f9 <get_pte>
c01034f3:	83 c4 10             	add    $0x10,%esp
c01034f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
c01034f9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01034fd:	74 14                	je     c0103513 <page_remove+0x3a>
        page_remove_pte(pgdir, la, ptep);
c01034ff:	83 ec 04             	sub    $0x4,%esp
c0103502:	ff 75 f4             	pushl  -0xc(%ebp)
c0103505:	ff 75 0c             	pushl  0xc(%ebp)
c0103508:	ff 75 08             	pushl  0x8(%ebp)
c010350b:	e8 64 ff ff ff       	call   c0103474 <page_remove_pte>
c0103510:	83 c4 10             	add    $0x10,%esp
    }
}
c0103513:	90                   	nop
c0103514:	c9                   	leave  
c0103515:	c3                   	ret    

c0103516 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c0103516:	f3 0f 1e fb          	endbr32 
c010351a:	55                   	push   %ebp
c010351b:	89 e5                	mov    %esp,%ebp
c010351d:	83 ec 18             	sub    $0x18,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c0103520:	83 ec 04             	sub    $0x4,%esp
c0103523:	6a 01                	push   $0x1
c0103525:	ff 75 10             	pushl  0x10(%ebp)
c0103528:	ff 75 08             	pushl  0x8(%ebp)
c010352b:	e8 c9 fd ff ff       	call   c01032f9 <get_pte>
c0103530:	83 c4 10             	add    $0x10,%esp
c0103533:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c0103536:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010353a:	75 0a                	jne    c0103546 <page_insert+0x30>
        return -E_NO_MEM;
c010353c:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c0103541:	e9 8b 00 00 00       	jmp    c01035d1 <page_insert+0xbb>
    }
    page_ref_inc(page);
c0103546:	83 ec 0c             	sub    $0xc,%esp
c0103549:	ff 75 0c             	pushl  0xc(%ebp)
c010354c:	e8 5a f5 ff ff       	call   c0102aab <page_ref_inc>
c0103551:	83 c4 10             	add    $0x10,%esp
    if (*ptep & PTE_P) {
c0103554:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103557:	8b 00                	mov    (%eax),%eax
c0103559:	83 e0 01             	and    $0x1,%eax
c010355c:	85 c0                	test   %eax,%eax
c010355e:	74 40                	je     c01035a0 <page_insert+0x8a>
        struct Page *p = pte2page(*ptep);
c0103560:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103563:	8b 00                	mov    (%eax),%eax
c0103565:	83 ec 0c             	sub    $0xc,%esp
c0103568:	50                   	push   %eax
c0103569:	e8 cf f4 ff ff       	call   c0102a3d <pte2page>
c010356e:	83 c4 10             	add    $0x10,%esp
c0103571:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c0103574:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103577:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010357a:	75 10                	jne    c010358c <page_insert+0x76>
            page_ref_dec(page);
c010357c:	83 ec 0c             	sub    $0xc,%esp
c010357f:	ff 75 0c             	pushl  0xc(%ebp)
c0103582:	e8 3b f5 ff ff       	call   c0102ac2 <page_ref_dec>
c0103587:	83 c4 10             	add    $0x10,%esp
c010358a:	eb 14                	jmp    c01035a0 <page_insert+0x8a>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c010358c:	83 ec 04             	sub    $0x4,%esp
c010358f:	ff 75 f4             	pushl  -0xc(%ebp)
c0103592:	ff 75 10             	pushl  0x10(%ebp)
c0103595:	ff 75 08             	pushl  0x8(%ebp)
c0103598:	e8 d7 fe ff ff       	call   c0103474 <page_remove_pte>
c010359d:	83 c4 10             	add    $0x10,%esp
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c01035a0:	83 ec 0c             	sub    $0xc,%esp
c01035a3:	ff 75 0c             	pushl  0xc(%ebp)
c01035a6:	e8 f3 f3 ff ff       	call   c010299e <page2pa>
c01035ab:	83 c4 10             	add    $0x10,%esp
c01035ae:	0b 45 14             	or     0x14(%ebp),%eax
c01035b1:	83 c8 01             	or     $0x1,%eax
c01035b4:	89 c2                	mov    %eax,%edx
c01035b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01035b9:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c01035bb:	83 ec 08             	sub    $0x8,%esp
c01035be:	ff 75 10             	pushl  0x10(%ebp)
c01035c1:	ff 75 08             	pushl  0x8(%ebp)
c01035c4:	e8 0a 00 00 00       	call   c01035d3 <tlb_invalidate>
c01035c9:	83 c4 10             	add    $0x10,%esp
    return 0;
c01035cc:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01035d1:	c9                   	leave  
c01035d2:	c3                   	ret    

c01035d3 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c01035d3:	f3 0f 1e fb          	endbr32 
c01035d7:	55                   	push   %ebp
c01035d8:	89 e5                	mov    %esp,%ebp
c01035da:	83 ec 18             	sub    $0x18,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c01035dd:	0f 20 d8             	mov    %cr3,%eax
c01035e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
c01035e3:	8b 55 f0             	mov    -0x10(%ebp),%edx
    if (rcr3() == PADDR(pgdir)) {
c01035e6:	8b 45 08             	mov    0x8(%ebp),%eax
c01035e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01035ec:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c01035f3:	77 17                	ja     c010360c <tlb_invalidate+0x39>
c01035f5:	ff 75 f4             	pushl  -0xc(%ebp)
c01035f8:	68 64 64 10 c0       	push   $0xc0106464
c01035fd:	68 d7 01 00 00       	push   $0x1d7
c0103602:	68 88 64 10 c0       	push   $0xc0106488
c0103607:	e8 0a ce ff ff       	call   c0100416 <__panic>
c010360c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010360f:	05 00 00 00 40       	add    $0x40000000,%eax
c0103614:	39 d0                	cmp    %edx,%eax
c0103616:	75 0d                	jne    c0103625 <tlb_invalidate+0x52>
        invlpg((void *)la);
c0103618:	8b 45 0c             	mov    0xc(%ebp),%eax
c010361b:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c010361e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103621:	0f 01 38             	invlpg (%eax)
}
c0103624:	90                   	nop
    }
}
c0103625:	90                   	nop
c0103626:	c9                   	leave  
c0103627:	c3                   	ret    

c0103628 <check_alloc_page>:

static void
check_alloc_page(void) {
c0103628:	f3 0f 1e fb          	endbr32 
c010362c:	55                   	push   %ebp
c010362d:	89 e5                	mov    %esp,%ebp
c010362f:	83 ec 08             	sub    $0x8,%esp
    pmm_manager->check();
c0103632:	a1 10 cf 11 c0       	mov    0xc011cf10,%eax
c0103637:	8b 40 18             	mov    0x18(%eax),%eax
c010363a:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c010363c:	83 ec 0c             	sub    $0xc,%esp
c010363f:	68 e8 64 10 c0       	push   $0xc01064e8
c0103644:	e8 52 cc ff ff       	call   c010029b <cprintf>
c0103649:	83 c4 10             	add    $0x10,%esp
}
c010364c:	90                   	nop
c010364d:	c9                   	leave  
c010364e:	c3                   	ret    

c010364f <check_pgdir>:

static void
check_pgdir(void) {
c010364f:	f3 0f 1e fb          	endbr32 
c0103653:	55                   	push   %ebp
c0103654:	89 e5                	mov    %esp,%ebp
c0103656:	83 ec 28             	sub    $0x28,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c0103659:	a1 80 ce 11 c0       	mov    0xc011ce80,%eax
c010365e:	3d 00 80 03 00       	cmp    $0x38000,%eax
c0103663:	76 19                	jbe    c010367e <check_pgdir+0x2f>
c0103665:	68 07 65 10 c0       	push   $0xc0106507
c010366a:	68 ad 64 10 c0       	push   $0xc01064ad
c010366f:	68 e4 01 00 00       	push   $0x1e4
c0103674:	68 88 64 10 c0       	push   $0xc0106488
c0103679:	e8 98 cd ff ff       	call   c0100416 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c010367e:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103683:	85 c0                	test   %eax,%eax
c0103685:	74 0e                	je     c0103695 <check_pgdir+0x46>
c0103687:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c010368c:	25 ff 0f 00 00       	and    $0xfff,%eax
c0103691:	85 c0                	test   %eax,%eax
c0103693:	74 19                	je     c01036ae <check_pgdir+0x5f>
c0103695:	68 24 65 10 c0       	push   $0xc0106524
c010369a:	68 ad 64 10 c0       	push   $0xc01064ad
c010369f:	68 e5 01 00 00       	push   $0x1e5
c01036a4:	68 88 64 10 c0       	push   $0xc0106488
c01036a9:	e8 68 cd ff ff       	call   c0100416 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c01036ae:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c01036b3:	83 ec 04             	sub    $0x4,%esp
c01036b6:	6a 00                	push   $0x0
c01036b8:	6a 00                	push   $0x0
c01036ba:	50                   	push   %eax
c01036bb:	e8 5a fd ff ff       	call   c010341a <get_page>
c01036c0:	83 c4 10             	add    $0x10,%esp
c01036c3:	85 c0                	test   %eax,%eax
c01036c5:	74 19                	je     c01036e0 <check_pgdir+0x91>
c01036c7:	68 5c 65 10 c0       	push   $0xc010655c
c01036cc:	68 ad 64 10 c0       	push   $0xc01064ad
c01036d1:	68 e6 01 00 00       	push   $0x1e6
c01036d6:	68 88 64 10 c0       	push   $0xc0106488
c01036db:	e8 36 cd ff ff       	call   c0100416 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c01036e0:	83 ec 0c             	sub    $0xc,%esp
c01036e3:	6a 01                	push   $0x1
c01036e5:	e8 c8 f5 ff ff       	call   c0102cb2 <alloc_pages>
c01036ea:	83 c4 10             	add    $0x10,%esp
c01036ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c01036f0:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c01036f5:	6a 00                	push   $0x0
c01036f7:	6a 00                	push   $0x0
c01036f9:	ff 75 f4             	pushl  -0xc(%ebp)
c01036fc:	50                   	push   %eax
c01036fd:	e8 14 fe ff ff       	call   c0103516 <page_insert>
c0103702:	83 c4 10             	add    $0x10,%esp
c0103705:	85 c0                	test   %eax,%eax
c0103707:	74 19                	je     c0103722 <check_pgdir+0xd3>
c0103709:	68 84 65 10 c0       	push   $0xc0106584
c010370e:	68 ad 64 10 c0       	push   $0xc01064ad
c0103713:	68 ea 01 00 00       	push   $0x1ea
c0103718:	68 88 64 10 c0       	push   $0xc0106488
c010371d:	e8 f4 cc ff ff       	call   c0100416 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c0103722:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103727:	83 ec 04             	sub    $0x4,%esp
c010372a:	6a 00                	push   $0x0
c010372c:	6a 00                	push   $0x0
c010372e:	50                   	push   %eax
c010372f:	e8 c5 fb ff ff       	call   c01032f9 <get_pte>
c0103734:	83 c4 10             	add    $0x10,%esp
c0103737:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010373a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010373e:	75 19                	jne    c0103759 <check_pgdir+0x10a>
c0103740:	68 b0 65 10 c0       	push   $0xc01065b0
c0103745:	68 ad 64 10 c0       	push   $0xc01064ad
c010374a:	68 ed 01 00 00       	push   $0x1ed
c010374f:	68 88 64 10 c0       	push   $0xc0106488
c0103754:	e8 bd cc ff ff       	call   c0100416 <__panic>
    assert(pte2page(*ptep) == p1);
c0103759:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010375c:	8b 00                	mov    (%eax),%eax
c010375e:	83 ec 0c             	sub    $0xc,%esp
c0103761:	50                   	push   %eax
c0103762:	e8 d6 f2 ff ff       	call   c0102a3d <pte2page>
c0103767:	83 c4 10             	add    $0x10,%esp
c010376a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c010376d:	74 19                	je     c0103788 <check_pgdir+0x139>
c010376f:	68 dd 65 10 c0       	push   $0xc01065dd
c0103774:	68 ad 64 10 c0       	push   $0xc01064ad
c0103779:	68 ee 01 00 00       	push   $0x1ee
c010377e:	68 88 64 10 c0       	push   $0xc0106488
c0103783:	e8 8e cc ff ff       	call   c0100416 <__panic>
    assert(page_ref(p1) == 1);
c0103788:	83 ec 0c             	sub    $0xc,%esp
c010378b:	ff 75 f4             	pushl  -0xc(%ebp)
c010378e:	e8 00 f3 ff ff       	call   c0102a93 <page_ref>
c0103793:	83 c4 10             	add    $0x10,%esp
c0103796:	83 f8 01             	cmp    $0x1,%eax
c0103799:	74 19                	je     c01037b4 <check_pgdir+0x165>
c010379b:	68 f3 65 10 c0       	push   $0xc01065f3
c01037a0:	68 ad 64 10 c0       	push   $0xc01064ad
c01037a5:	68 ef 01 00 00       	push   $0x1ef
c01037aa:	68 88 64 10 c0       	push   $0xc0106488
c01037af:	e8 62 cc ff ff       	call   c0100416 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c01037b4:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c01037b9:	8b 00                	mov    (%eax),%eax
c01037bb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01037c0:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01037c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01037c6:	c1 e8 0c             	shr    $0xc,%eax
c01037c9:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01037cc:	a1 80 ce 11 c0       	mov    0xc011ce80,%eax
c01037d1:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c01037d4:	72 17                	jb     c01037ed <check_pgdir+0x19e>
c01037d6:	ff 75 ec             	pushl  -0x14(%ebp)
c01037d9:	68 c0 63 10 c0       	push   $0xc01063c0
c01037de:	68 f1 01 00 00       	push   $0x1f1
c01037e3:	68 88 64 10 c0       	push   $0xc0106488
c01037e8:	e8 29 cc ff ff       	call   c0100416 <__panic>
c01037ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01037f0:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01037f5:	83 c0 04             	add    $0x4,%eax
c01037f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c01037fb:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103800:	83 ec 04             	sub    $0x4,%esp
c0103803:	6a 00                	push   $0x0
c0103805:	68 00 10 00 00       	push   $0x1000
c010380a:	50                   	push   %eax
c010380b:	e8 e9 fa ff ff       	call   c01032f9 <get_pte>
c0103810:	83 c4 10             	add    $0x10,%esp
c0103813:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0103816:	74 19                	je     c0103831 <check_pgdir+0x1e2>
c0103818:	68 08 66 10 c0       	push   $0xc0106608
c010381d:	68 ad 64 10 c0       	push   $0xc01064ad
c0103822:	68 f2 01 00 00       	push   $0x1f2
c0103827:	68 88 64 10 c0       	push   $0xc0106488
c010382c:	e8 e5 cb ff ff       	call   c0100416 <__panic>

    p2 = alloc_page();
c0103831:	83 ec 0c             	sub    $0xc,%esp
c0103834:	6a 01                	push   $0x1
c0103836:	e8 77 f4 ff ff       	call   c0102cb2 <alloc_pages>
c010383b:	83 c4 10             	add    $0x10,%esp
c010383e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c0103841:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103846:	6a 06                	push   $0x6
c0103848:	68 00 10 00 00       	push   $0x1000
c010384d:	ff 75 e4             	pushl  -0x1c(%ebp)
c0103850:	50                   	push   %eax
c0103851:	e8 c0 fc ff ff       	call   c0103516 <page_insert>
c0103856:	83 c4 10             	add    $0x10,%esp
c0103859:	85 c0                	test   %eax,%eax
c010385b:	74 19                	je     c0103876 <check_pgdir+0x227>
c010385d:	68 30 66 10 c0       	push   $0xc0106630
c0103862:	68 ad 64 10 c0       	push   $0xc01064ad
c0103867:	68 f5 01 00 00       	push   $0x1f5
c010386c:	68 88 64 10 c0       	push   $0xc0106488
c0103871:	e8 a0 cb ff ff       	call   c0100416 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0103876:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c010387b:	83 ec 04             	sub    $0x4,%esp
c010387e:	6a 00                	push   $0x0
c0103880:	68 00 10 00 00       	push   $0x1000
c0103885:	50                   	push   %eax
c0103886:	e8 6e fa ff ff       	call   c01032f9 <get_pte>
c010388b:	83 c4 10             	add    $0x10,%esp
c010388e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103891:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103895:	75 19                	jne    c01038b0 <check_pgdir+0x261>
c0103897:	68 68 66 10 c0       	push   $0xc0106668
c010389c:	68 ad 64 10 c0       	push   $0xc01064ad
c01038a1:	68 f6 01 00 00       	push   $0x1f6
c01038a6:	68 88 64 10 c0       	push   $0xc0106488
c01038ab:	e8 66 cb ff ff       	call   c0100416 <__panic>
    assert(*ptep & PTE_U);
c01038b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01038b3:	8b 00                	mov    (%eax),%eax
c01038b5:	83 e0 04             	and    $0x4,%eax
c01038b8:	85 c0                	test   %eax,%eax
c01038ba:	75 19                	jne    c01038d5 <check_pgdir+0x286>
c01038bc:	68 98 66 10 c0       	push   $0xc0106698
c01038c1:	68 ad 64 10 c0       	push   $0xc01064ad
c01038c6:	68 f7 01 00 00       	push   $0x1f7
c01038cb:	68 88 64 10 c0       	push   $0xc0106488
c01038d0:	e8 41 cb ff ff       	call   c0100416 <__panic>
    assert(*ptep & PTE_W);
c01038d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01038d8:	8b 00                	mov    (%eax),%eax
c01038da:	83 e0 02             	and    $0x2,%eax
c01038dd:	85 c0                	test   %eax,%eax
c01038df:	75 19                	jne    c01038fa <check_pgdir+0x2ab>
c01038e1:	68 a6 66 10 c0       	push   $0xc01066a6
c01038e6:	68 ad 64 10 c0       	push   $0xc01064ad
c01038eb:	68 f8 01 00 00       	push   $0x1f8
c01038f0:	68 88 64 10 c0       	push   $0xc0106488
c01038f5:	e8 1c cb ff ff       	call   c0100416 <__panic>
    assert(boot_pgdir[0] & PTE_U);
c01038fa:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c01038ff:	8b 00                	mov    (%eax),%eax
c0103901:	83 e0 04             	and    $0x4,%eax
c0103904:	85 c0                	test   %eax,%eax
c0103906:	75 19                	jne    c0103921 <check_pgdir+0x2d2>
c0103908:	68 b4 66 10 c0       	push   $0xc01066b4
c010390d:	68 ad 64 10 c0       	push   $0xc01064ad
c0103912:	68 f9 01 00 00       	push   $0x1f9
c0103917:	68 88 64 10 c0       	push   $0xc0106488
c010391c:	e8 f5 ca ff ff       	call   c0100416 <__panic>
    assert(page_ref(p2) == 1);
c0103921:	83 ec 0c             	sub    $0xc,%esp
c0103924:	ff 75 e4             	pushl  -0x1c(%ebp)
c0103927:	e8 67 f1 ff ff       	call   c0102a93 <page_ref>
c010392c:	83 c4 10             	add    $0x10,%esp
c010392f:	83 f8 01             	cmp    $0x1,%eax
c0103932:	74 19                	je     c010394d <check_pgdir+0x2fe>
c0103934:	68 ca 66 10 c0       	push   $0xc01066ca
c0103939:	68 ad 64 10 c0       	push   $0xc01064ad
c010393e:	68 fa 01 00 00       	push   $0x1fa
c0103943:	68 88 64 10 c0       	push   $0xc0106488
c0103948:	e8 c9 ca ff ff       	call   c0100416 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c010394d:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103952:	6a 00                	push   $0x0
c0103954:	68 00 10 00 00       	push   $0x1000
c0103959:	ff 75 f4             	pushl  -0xc(%ebp)
c010395c:	50                   	push   %eax
c010395d:	e8 b4 fb ff ff       	call   c0103516 <page_insert>
c0103962:	83 c4 10             	add    $0x10,%esp
c0103965:	85 c0                	test   %eax,%eax
c0103967:	74 19                	je     c0103982 <check_pgdir+0x333>
c0103969:	68 dc 66 10 c0       	push   $0xc01066dc
c010396e:	68 ad 64 10 c0       	push   $0xc01064ad
c0103973:	68 fc 01 00 00       	push   $0x1fc
c0103978:	68 88 64 10 c0       	push   $0xc0106488
c010397d:	e8 94 ca ff ff       	call   c0100416 <__panic>
    assert(page_ref(p1) == 2);
c0103982:	83 ec 0c             	sub    $0xc,%esp
c0103985:	ff 75 f4             	pushl  -0xc(%ebp)
c0103988:	e8 06 f1 ff ff       	call   c0102a93 <page_ref>
c010398d:	83 c4 10             	add    $0x10,%esp
c0103990:	83 f8 02             	cmp    $0x2,%eax
c0103993:	74 19                	je     c01039ae <check_pgdir+0x35f>
c0103995:	68 08 67 10 c0       	push   $0xc0106708
c010399a:	68 ad 64 10 c0       	push   $0xc01064ad
c010399f:	68 fd 01 00 00       	push   $0x1fd
c01039a4:	68 88 64 10 c0       	push   $0xc0106488
c01039a9:	e8 68 ca ff ff       	call   c0100416 <__panic>
    assert(page_ref(p2) == 0);
c01039ae:	83 ec 0c             	sub    $0xc,%esp
c01039b1:	ff 75 e4             	pushl  -0x1c(%ebp)
c01039b4:	e8 da f0 ff ff       	call   c0102a93 <page_ref>
c01039b9:	83 c4 10             	add    $0x10,%esp
c01039bc:	85 c0                	test   %eax,%eax
c01039be:	74 19                	je     c01039d9 <check_pgdir+0x38a>
c01039c0:	68 1a 67 10 c0       	push   $0xc010671a
c01039c5:	68 ad 64 10 c0       	push   $0xc01064ad
c01039ca:	68 fe 01 00 00       	push   $0x1fe
c01039cf:	68 88 64 10 c0       	push   $0xc0106488
c01039d4:	e8 3d ca ff ff       	call   c0100416 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c01039d9:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c01039de:	83 ec 04             	sub    $0x4,%esp
c01039e1:	6a 00                	push   $0x0
c01039e3:	68 00 10 00 00       	push   $0x1000
c01039e8:	50                   	push   %eax
c01039e9:	e8 0b f9 ff ff       	call   c01032f9 <get_pte>
c01039ee:	83 c4 10             	add    $0x10,%esp
c01039f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01039f4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01039f8:	75 19                	jne    c0103a13 <check_pgdir+0x3c4>
c01039fa:	68 68 66 10 c0       	push   $0xc0106668
c01039ff:	68 ad 64 10 c0       	push   $0xc01064ad
c0103a04:	68 ff 01 00 00       	push   $0x1ff
c0103a09:	68 88 64 10 c0       	push   $0xc0106488
c0103a0e:	e8 03 ca ff ff       	call   c0100416 <__panic>
    assert(pte2page(*ptep) == p1);
c0103a13:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103a16:	8b 00                	mov    (%eax),%eax
c0103a18:	83 ec 0c             	sub    $0xc,%esp
c0103a1b:	50                   	push   %eax
c0103a1c:	e8 1c f0 ff ff       	call   c0102a3d <pte2page>
c0103a21:	83 c4 10             	add    $0x10,%esp
c0103a24:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0103a27:	74 19                	je     c0103a42 <check_pgdir+0x3f3>
c0103a29:	68 dd 65 10 c0       	push   $0xc01065dd
c0103a2e:	68 ad 64 10 c0       	push   $0xc01064ad
c0103a33:	68 00 02 00 00       	push   $0x200
c0103a38:	68 88 64 10 c0       	push   $0xc0106488
c0103a3d:	e8 d4 c9 ff ff       	call   c0100416 <__panic>
    assert((*ptep & PTE_U) == 0);
c0103a42:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103a45:	8b 00                	mov    (%eax),%eax
c0103a47:	83 e0 04             	and    $0x4,%eax
c0103a4a:	85 c0                	test   %eax,%eax
c0103a4c:	74 19                	je     c0103a67 <check_pgdir+0x418>
c0103a4e:	68 2c 67 10 c0       	push   $0xc010672c
c0103a53:	68 ad 64 10 c0       	push   $0xc01064ad
c0103a58:	68 01 02 00 00       	push   $0x201
c0103a5d:	68 88 64 10 c0       	push   $0xc0106488
c0103a62:	e8 af c9 ff ff       	call   c0100416 <__panic>

    page_remove(boot_pgdir, 0x0);
c0103a67:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103a6c:	83 ec 08             	sub    $0x8,%esp
c0103a6f:	6a 00                	push   $0x0
c0103a71:	50                   	push   %eax
c0103a72:	e8 62 fa ff ff       	call   c01034d9 <page_remove>
c0103a77:	83 c4 10             	add    $0x10,%esp
    assert(page_ref(p1) == 1);
c0103a7a:	83 ec 0c             	sub    $0xc,%esp
c0103a7d:	ff 75 f4             	pushl  -0xc(%ebp)
c0103a80:	e8 0e f0 ff ff       	call   c0102a93 <page_ref>
c0103a85:	83 c4 10             	add    $0x10,%esp
c0103a88:	83 f8 01             	cmp    $0x1,%eax
c0103a8b:	74 19                	je     c0103aa6 <check_pgdir+0x457>
c0103a8d:	68 f3 65 10 c0       	push   $0xc01065f3
c0103a92:	68 ad 64 10 c0       	push   $0xc01064ad
c0103a97:	68 04 02 00 00       	push   $0x204
c0103a9c:	68 88 64 10 c0       	push   $0xc0106488
c0103aa1:	e8 70 c9 ff ff       	call   c0100416 <__panic>
    assert(page_ref(p2) == 0);
c0103aa6:	83 ec 0c             	sub    $0xc,%esp
c0103aa9:	ff 75 e4             	pushl  -0x1c(%ebp)
c0103aac:	e8 e2 ef ff ff       	call   c0102a93 <page_ref>
c0103ab1:	83 c4 10             	add    $0x10,%esp
c0103ab4:	85 c0                	test   %eax,%eax
c0103ab6:	74 19                	je     c0103ad1 <check_pgdir+0x482>
c0103ab8:	68 1a 67 10 c0       	push   $0xc010671a
c0103abd:	68 ad 64 10 c0       	push   $0xc01064ad
c0103ac2:	68 05 02 00 00       	push   $0x205
c0103ac7:	68 88 64 10 c0       	push   $0xc0106488
c0103acc:	e8 45 c9 ff ff       	call   c0100416 <__panic>

    page_remove(boot_pgdir, PGSIZE);
c0103ad1:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103ad6:	83 ec 08             	sub    $0x8,%esp
c0103ad9:	68 00 10 00 00       	push   $0x1000
c0103ade:	50                   	push   %eax
c0103adf:	e8 f5 f9 ff ff       	call   c01034d9 <page_remove>
c0103ae4:	83 c4 10             	add    $0x10,%esp
    assert(page_ref(p1) == 0);
c0103ae7:	83 ec 0c             	sub    $0xc,%esp
c0103aea:	ff 75 f4             	pushl  -0xc(%ebp)
c0103aed:	e8 a1 ef ff ff       	call   c0102a93 <page_ref>
c0103af2:	83 c4 10             	add    $0x10,%esp
c0103af5:	85 c0                	test   %eax,%eax
c0103af7:	74 19                	je     c0103b12 <check_pgdir+0x4c3>
c0103af9:	68 41 67 10 c0       	push   $0xc0106741
c0103afe:	68 ad 64 10 c0       	push   $0xc01064ad
c0103b03:	68 08 02 00 00       	push   $0x208
c0103b08:	68 88 64 10 c0       	push   $0xc0106488
c0103b0d:	e8 04 c9 ff ff       	call   c0100416 <__panic>
    assert(page_ref(p2) == 0);
c0103b12:	83 ec 0c             	sub    $0xc,%esp
c0103b15:	ff 75 e4             	pushl  -0x1c(%ebp)
c0103b18:	e8 76 ef ff ff       	call   c0102a93 <page_ref>
c0103b1d:	83 c4 10             	add    $0x10,%esp
c0103b20:	85 c0                	test   %eax,%eax
c0103b22:	74 19                	je     c0103b3d <check_pgdir+0x4ee>
c0103b24:	68 1a 67 10 c0       	push   $0xc010671a
c0103b29:	68 ad 64 10 c0       	push   $0xc01064ad
c0103b2e:	68 09 02 00 00       	push   $0x209
c0103b33:	68 88 64 10 c0       	push   $0xc0106488
c0103b38:	e8 d9 c8 ff ff       	call   c0100416 <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
c0103b3d:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103b42:	8b 00                	mov    (%eax),%eax
c0103b44:	83 ec 0c             	sub    $0xc,%esp
c0103b47:	50                   	push   %eax
c0103b48:	e8 2a ef ff ff       	call   c0102a77 <pde2page>
c0103b4d:	83 c4 10             	add    $0x10,%esp
c0103b50:	83 ec 0c             	sub    $0xc,%esp
c0103b53:	50                   	push   %eax
c0103b54:	e8 3a ef ff ff       	call   c0102a93 <page_ref>
c0103b59:	83 c4 10             	add    $0x10,%esp
c0103b5c:	83 f8 01             	cmp    $0x1,%eax
c0103b5f:	74 19                	je     c0103b7a <check_pgdir+0x52b>
c0103b61:	68 54 67 10 c0       	push   $0xc0106754
c0103b66:	68 ad 64 10 c0       	push   $0xc01064ad
c0103b6b:	68 0b 02 00 00       	push   $0x20b
c0103b70:	68 88 64 10 c0       	push   $0xc0106488
c0103b75:	e8 9c c8 ff ff       	call   c0100416 <__panic>
    free_page(pde2page(boot_pgdir[0]));
c0103b7a:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103b7f:	8b 00                	mov    (%eax),%eax
c0103b81:	83 ec 0c             	sub    $0xc,%esp
c0103b84:	50                   	push   %eax
c0103b85:	e8 ed ee ff ff       	call   c0102a77 <pde2page>
c0103b8a:	83 c4 10             	add    $0x10,%esp
c0103b8d:	83 ec 08             	sub    $0x8,%esp
c0103b90:	6a 01                	push   $0x1
c0103b92:	50                   	push   %eax
c0103b93:	e8 5c f1 ff ff       	call   c0102cf4 <free_pages>
c0103b98:	83 c4 10             	add    $0x10,%esp
    boot_pgdir[0] = 0;
c0103b9b:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103ba0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c0103ba6:	83 ec 0c             	sub    $0xc,%esp
c0103ba9:	68 7b 67 10 c0       	push   $0xc010677b
c0103bae:	e8 e8 c6 ff ff       	call   c010029b <cprintf>
c0103bb3:	83 c4 10             	add    $0x10,%esp
}
c0103bb6:	90                   	nop
c0103bb7:	c9                   	leave  
c0103bb8:	c3                   	ret    

c0103bb9 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c0103bb9:	f3 0f 1e fb          	endbr32 
c0103bbd:	55                   	push   %ebp
c0103bbe:	89 e5                	mov    %esp,%ebp
c0103bc0:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0103bc3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103bca:	e9 a3 00 00 00       	jmp    c0103c72 <check_boot_pgdir+0xb9>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c0103bcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103bd2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103bd5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103bd8:	c1 e8 0c             	shr    $0xc,%eax
c0103bdb:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0103bde:	a1 80 ce 11 c0       	mov    0xc011ce80,%eax
c0103be3:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c0103be6:	72 17                	jb     c0103bff <check_boot_pgdir+0x46>
c0103be8:	ff 75 e4             	pushl  -0x1c(%ebp)
c0103beb:	68 c0 63 10 c0       	push   $0xc01063c0
c0103bf0:	68 17 02 00 00       	push   $0x217
c0103bf5:	68 88 64 10 c0       	push   $0xc0106488
c0103bfa:	e8 17 c8 ff ff       	call   c0100416 <__panic>
c0103bff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103c02:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0103c07:	89 c2                	mov    %eax,%edx
c0103c09:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103c0e:	83 ec 04             	sub    $0x4,%esp
c0103c11:	6a 00                	push   $0x0
c0103c13:	52                   	push   %edx
c0103c14:	50                   	push   %eax
c0103c15:	e8 df f6 ff ff       	call   c01032f9 <get_pte>
c0103c1a:	83 c4 10             	add    $0x10,%esp
c0103c1d:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0103c20:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0103c24:	75 19                	jne    c0103c3f <check_boot_pgdir+0x86>
c0103c26:	68 98 67 10 c0       	push   $0xc0106798
c0103c2b:	68 ad 64 10 c0       	push   $0xc01064ad
c0103c30:	68 17 02 00 00       	push   $0x217
c0103c35:	68 88 64 10 c0       	push   $0xc0106488
c0103c3a:	e8 d7 c7 ff ff       	call   c0100416 <__panic>
        assert(PTE_ADDR(*ptep) == i);
c0103c3f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103c42:	8b 00                	mov    (%eax),%eax
c0103c44:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103c49:	89 c2                	mov    %eax,%edx
c0103c4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103c4e:	39 c2                	cmp    %eax,%edx
c0103c50:	74 19                	je     c0103c6b <check_boot_pgdir+0xb2>
c0103c52:	68 d5 67 10 c0       	push   $0xc01067d5
c0103c57:	68 ad 64 10 c0       	push   $0xc01064ad
c0103c5c:	68 18 02 00 00       	push   $0x218
c0103c61:	68 88 64 10 c0       	push   $0xc0106488
c0103c66:	e8 ab c7 ff ff       	call   c0100416 <__panic>
    for (i = 0; i < npage; i += PGSIZE) {
c0103c6b:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c0103c72:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103c75:	a1 80 ce 11 c0       	mov    0xc011ce80,%eax
c0103c7a:	39 c2                	cmp    %eax,%edx
c0103c7c:	0f 82 4d ff ff ff    	jb     c0103bcf <check_boot_pgdir+0x16>
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c0103c82:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103c87:	05 ac 0f 00 00       	add    $0xfac,%eax
c0103c8c:	8b 00                	mov    (%eax),%eax
c0103c8e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103c93:	89 c2                	mov    %eax,%edx
c0103c95:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103c9a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103c9d:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c0103ca4:	77 17                	ja     c0103cbd <check_boot_pgdir+0x104>
c0103ca6:	ff 75 f0             	pushl  -0x10(%ebp)
c0103ca9:	68 64 64 10 c0       	push   $0xc0106464
c0103cae:	68 1b 02 00 00       	push   $0x21b
c0103cb3:	68 88 64 10 c0       	push   $0xc0106488
c0103cb8:	e8 59 c7 ff ff       	call   c0100416 <__panic>
c0103cbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103cc0:	05 00 00 00 40       	add    $0x40000000,%eax
c0103cc5:	39 d0                	cmp    %edx,%eax
c0103cc7:	74 19                	je     c0103ce2 <check_boot_pgdir+0x129>
c0103cc9:	68 ec 67 10 c0       	push   $0xc01067ec
c0103cce:	68 ad 64 10 c0       	push   $0xc01064ad
c0103cd3:	68 1b 02 00 00       	push   $0x21b
c0103cd8:	68 88 64 10 c0       	push   $0xc0106488
c0103cdd:	e8 34 c7 ff ff       	call   c0100416 <__panic>

    assert(boot_pgdir[0] == 0);
c0103ce2:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103ce7:	8b 00                	mov    (%eax),%eax
c0103ce9:	85 c0                	test   %eax,%eax
c0103ceb:	74 19                	je     c0103d06 <check_boot_pgdir+0x14d>
c0103ced:	68 20 68 10 c0       	push   $0xc0106820
c0103cf2:	68 ad 64 10 c0       	push   $0xc01064ad
c0103cf7:	68 1d 02 00 00       	push   $0x21d
c0103cfc:	68 88 64 10 c0       	push   $0xc0106488
c0103d01:	e8 10 c7 ff ff       	call   c0100416 <__panic>

    struct Page *p;
    p = alloc_page();
c0103d06:	83 ec 0c             	sub    $0xc,%esp
c0103d09:	6a 01                	push   $0x1
c0103d0b:	e8 a2 ef ff ff       	call   c0102cb2 <alloc_pages>
c0103d10:	83 c4 10             	add    $0x10,%esp
c0103d13:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c0103d16:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103d1b:	6a 02                	push   $0x2
c0103d1d:	68 00 01 00 00       	push   $0x100
c0103d22:	ff 75 ec             	pushl  -0x14(%ebp)
c0103d25:	50                   	push   %eax
c0103d26:	e8 eb f7 ff ff       	call   c0103516 <page_insert>
c0103d2b:	83 c4 10             	add    $0x10,%esp
c0103d2e:	85 c0                	test   %eax,%eax
c0103d30:	74 19                	je     c0103d4b <check_boot_pgdir+0x192>
c0103d32:	68 34 68 10 c0       	push   $0xc0106834
c0103d37:	68 ad 64 10 c0       	push   $0xc01064ad
c0103d3c:	68 21 02 00 00       	push   $0x221
c0103d41:	68 88 64 10 c0       	push   $0xc0106488
c0103d46:	e8 cb c6 ff ff       	call   c0100416 <__panic>
    assert(page_ref(p) == 1);
c0103d4b:	83 ec 0c             	sub    $0xc,%esp
c0103d4e:	ff 75 ec             	pushl  -0x14(%ebp)
c0103d51:	e8 3d ed ff ff       	call   c0102a93 <page_ref>
c0103d56:	83 c4 10             	add    $0x10,%esp
c0103d59:	83 f8 01             	cmp    $0x1,%eax
c0103d5c:	74 19                	je     c0103d77 <check_boot_pgdir+0x1be>
c0103d5e:	68 62 68 10 c0       	push   $0xc0106862
c0103d63:	68 ad 64 10 c0       	push   $0xc01064ad
c0103d68:	68 22 02 00 00       	push   $0x222
c0103d6d:	68 88 64 10 c0       	push   $0xc0106488
c0103d72:	e8 9f c6 ff ff       	call   c0100416 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c0103d77:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103d7c:	6a 02                	push   $0x2
c0103d7e:	68 00 11 00 00       	push   $0x1100
c0103d83:	ff 75 ec             	pushl  -0x14(%ebp)
c0103d86:	50                   	push   %eax
c0103d87:	e8 8a f7 ff ff       	call   c0103516 <page_insert>
c0103d8c:	83 c4 10             	add    $0x10,%esp
c0103d8f:	85 c0                	test   %eax,%eax
c0103d91:	74 19                	je     c0103dac <check_boot_pgdir+0x1f3>
c0103d93:	68 74 68 10 c0       	push   $0xc0106874
c0103d98:	68 ad 64 10 c0       	push   $0xc01064ad
c0103d9d:	68 23 02 00 00       	push   $0x223
c0103da2:	68 88 64 10 c0       	push   $0xc0106488
c0103da7:	e8 6a c6 ff ff       	call   c0100416 <__panic>
    assert(page_ref(p) == 2);
c0103dac:	83 ec 0c             	sub    $0xc,%esp
c0103daf:	ff 75 ec             	pushl  -0x14(%ebp)
c0103db2:	e8 dc ec ff ff       	call   c0102a93 <page_ref>
c0103db7:	83 c4 10             	add    $0x10,%esp
c0103dba:	83 f8 02             	cmp    $0x2,%eax
c0103dbd:	74 19                	je     c0103dd8 <check_boot_pgdir+0x21f>
c0103dbf:	68 ab 68 10 c0       	push   $0xc01068ab
c0103dc4:	68 ad 64 10 c0       	push   $0xc01064ad
c0103dc9:	68 24 02 00 00       	push   $0x224
c0103dce:	68 88 64 10 c0       	push   $0xc0106488
c0103dd3:	e8 3e c6 ff ff       	call   c0100416 <__panic>

    const char *str = "ucore: Hello world!!";
c0103dd8:	c7 45 e8 bc 68 10 c0 	movl   $0xc01068bc,-0x18(%ebp)
    strcpy((void *)0x100, str);
c0103ddf:	83 ec 08             	sub    $0x8,%esp
c0103de2:	ff 75 e8             	pushl  -0x18(%ebp)
c0103de5:	68 00 01 00 00       	push   $0x100
c0103dea:	e8 bd 13 00 00       	call   c01051ac <strcpy>
c0103def:	83 c4 10             	add    $0x10,%esp
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c0103df2:	83 ec 08             	sub    $0x8,%esp
c0103df5:	68 00 11 00 00       	push   $0x1100
c0103dfa:	68 00 01 00 00       	push   $0x100
c0103dff:	e8 29 14 00 00       	call   c010522d <strcmp>
c0103e04:	83 c4 10             	add    $0x10,%esp
c0103e07:	85 c0                	test   %eax,%eax
c0103e09:	74 19                	je     c0103e24 <check_boot_pgdir+0x26b>
c0103e0b:	68 d4 68 10 c0       	push   $0xc01068d4
c0103e10:	68 ad 64 10 c0       	push   $0xc01064ad
c0103e15:	68 28 02 00 00       	push   $0x228
c0103e1a:	68 88 64 10 c0       	push   $0xc0106488
c0103e1f:	e8 f2 c5 ff ff       	call   c0100416 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c0103e24:	83 ec 0c             	sub    $0xc,%esp
c0103e27:	ff 75 ec             	pushl  -0x14(%ebp)
c0103e2a:	e8 c9 eb ff ff       	call   c01029f8 <page2kva>
c0103e2f:	83 c4 10             	add    $0x10,%esp
c0103e32:	05 00 01 00 00       	add    $0x100,%eax
c0103e37:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c0103e3a:	83 ec 0c             	sub    $0xc,%esp
c0103e3d:	68 00 01 00 00       	push   $0x100
c0103e42:	e8 05 13 00 00       	call   c010514c <strlen>
c0103e47:	83 c4 10             	add    $0x10,%esp
c0103e4a:	85 c0                	test   %eax,%eax
c0103e4c:	74 19                	je     c0103e67 <check_boot_pgdir+0x2ae>
c0103e4e:	68 0c 69 10 c0       	push   $0xc010690c
c0103e53:	68 ad 64 10 c0       	push   $0xc01064ad
c0103e58:	68 2b 02 00 00       	push   $0x22b
c0103e5d:	68 88 64 10 c0       	push   $0xc0106488
c0103e62:	e8 af c5 ff ff       	call   c0100416 <__panic>

    free_page(p);
c0103e67:	83 ec 08             	sub    $0x8,%esp
c0103e6a:	6a 01                	push   $0x1
c0103e6c:	ff 75 ec             	pushl  -0x14(%ebp)
c0103e6f:	e8 80 ee ff ff       	call   c0102cf4 <free_pages>
c0103e74:	83 c4 10             	add    $0x10,%esp
    free_page(pde2page(boot_pgdir[0]));
c0103e77:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103e7c:	8b 00                	mov    (%eax),%eax
c0103e7e:	83 ec 0c             	sub    $0xc,%esp
c0103e81:	50                   	push   %eax
c0103e82:	e8 f0 eb ff ff       	call   c0102a77 <pde2page>
c0103e87:	83 c4 10             	add    $0x10,%esp
c0103e8a:	83 ec 08             	sub    $0x8,%esp
c0103e8d:	6a 01                	push   $0x1
c0103e8f:	50                   	push   %eax
c0103e90:	e8 5f ee ff ff       	call   c0102cf4 <free_pages>
c0103e95:	83 c4 10             	add    $0x10,%esp
    boot_pgdir[0] = 0;
c0103e98:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103e9d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c0103ea3:	83 ec 0c             	sub    $0xc,%esp
c0103ea6:	68 30 69 10 c0       	push   $0xc0106930
c0103eab:	e8 eb c3 ff ff       	call   c010029b <cprintf>
c0103eb0:	83 c4 10             	add    $0x10,%esp
}
c0103eb3:	90                   	nop
c0103eb4:	c9                   	leave  
c0103eb5:	c3                   	ret    

c0103eb6 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c0103eb6:	f3 0f 1e fb          	endbr32 
c0103eba:	55                   	push   %ebp
c0103ebb:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c0103ebd:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ec0:	83 e0 04             	and    $0x4,%eax
c0103ec3:	85 c0                	test   %eax,%eax
c0103ec5:	74 07                	je     c0103ece <perm2str+0x18>
c0103ec7:	b8 75 00 00 00       	mov    $0x75,%eax
c0103ecc:	eb 05                	jmp    c0103ed3 <perm2str+0x1d>
c0103ece:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0103ed3:	a2 08 cf 11 c0       	mov    %al,0xc011cf08
    str[1] = 'r';
c0103ed8:	c6 05 09 cf 11 c0 72 	movb   $0x72,0xc011cf09
    str[2] = (perm & PTE_W) ? 'w' : '-';
c0103edf:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ee2:	83 e0 02             	and    $0x2,%eax
c0103ee5:	85 c0                	test   %eax,%eax
c0103ee7:	74 07                	je     c0103ef0 <perm2str+0x3a>
c0103ee9:	b8 77 00 00 00       	mov    $0x77,%eax
c0103eee:	eb 05                	jmp    c0103ef5 <perm2str+0x3f>
c0103ef0:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0103ef5:	a2 0a cf 11 c0       	mov    %al,0xc011cf0a
    str[3] = '\0';
c0103efa:	c6 05 0b cf 11 c0 00 	movb   $0x0,0xc011cf0b
    return str;
c0103f01:	b8 08 cf 11 c0       	mov    $0xc011cf08,%eax
}
c0103f06:	5d                   	pop    %ebp
c0103f07:	c3                   	ret    

c0103f08 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c0103f08:	f3 0f 1e fb          	endbr32 
c0103f0c:	55                   	push   %ebp
c0103f0d:	89 e5                	mov    %esp,%ebp
c0103f0f:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c0103f12:	8b 45 10             	mov    0x10(%ebp),%eax
c0103f15:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0103f18:	72 0e                	jb     c0103f28 <get_pgtable_items+0x20>
        return 0;
c0103f1a:	b8 00 00 00 00       	mov    $0x0,%eax
c0103f1f:	e9 9a 00 00 00       	jmp    c0103fbe <get_pgtable_items+0xb6>
    }
    while (start < right && !(table[start] & PTE_P)) {
        start ++;
c0103f24:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    while (start < right && !(table[start] & PTE_P)) {
c0103f28:	8b 45 10             	mov    0x10(%ebp),%eax
c0103f2b:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0103f2e:	73 18                	jae    c0103f48 <get_pgtable_items+0x40>
c0103f30:	8b 45 10             	mov    0x10(%ebp),%eax
c0103f33:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0103f3a:	8b 45 14             	mov    0x14(%ebp),%eax
c0103f3d:	01 d0                	add    %edx,%eax
c0103f3f:	8b 00                	mov    (%eax),%eax
c0103f41:	83 e0 01             	and    $0x1,%eax
c0103f44:	85 c0                	test   %eax,%eax
c0103f46:	74 dc                	je     c0103f24 <get_pgtable_items+0x1c>
    }
    if (start < right) {
c0103f48:	8b 45 10             	mov    0x10(%ebp),%eax
c0103f4b:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0103f4e:	73 69                	jae    c0103fb9 <get_pgtable_items+0xb1>
        if (left_store != NULL) {
c0103f50:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c0103f54:	74 08                	je     c0103f5e <get_pgtable_items+0x56>
            *left_store = start;
c0103f56:	8b 45 18             	mov    0x18(%ebp),%eax
c0103f59:	8b 55 10             	mov    0x10(%ebp),%edx
c0103f5c:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c0103f5e:	8b 45 10             	mov    0x10(%ebp),%eax
c0103f61:	8d 50 01             	lea    0x1(%eax),%edx
c0103f64:	89 55 10             	mov    %edx,0x10(%ebp)
c0103f67:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0103f6e:	8b 45 14             	mov    0x14(%ebp),%eax
c0103f71:	01 d0                	add    %edx,%eax
c0103f73:	8b 00                	mov    (%eax),%eax
c0103f75:	83 e0 07             	and    $0x7,%eax
c0103f78:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c0103f7b:	eb 04                	jmp    c0103f81 <get_pgtable_items+0x79>
            start ++;
c0103f7d:	83 45 10 01          	addl   $0x1,0x10(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c0103f81:	8b 45 10             	mov    0x10(%ebp),%eax
c0103f84:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0103f87:	73 1d                	jae    c0103fa6 <get_pgtable_items+0x9e>
c0103f89:	8b 45 10             	mov    0x10(%ebp),%eax
c0103f8c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0103f93:	8b 45 14             	mov    0x14(%ebp),%eax
c0103f96:	01 d0                	add    %edx,%eax
c0103f98:	8b 00                	mov    (%eax),%eax
c0103f9a:	83 e0 07             	and    $0x7,%eax
c0103f9d:	89 c2                	mov    %eax,%edx
c0103f9f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103fa2:	39 c2                	cmp    %eax,%edx
c0103fa4:	74 d7                	je     c0103f7d <get_pgtable_items+0x75>
        }
        if (right_store != NULL) {
c0103fa6:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0103faa:	74 08                	je     c0103fb4 <get_pgtable_items+0xac>
            *right_store = start;
c0103fac:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0103faf:	8b 55 10             	mov    0x10(%ebp),%edx
c0103fb2:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c0103fb4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103fb7:	eb 05                	jmp    c0103fbe <get_pgtable_items+0xb6>
    }
    return 0;
c0103fb9:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103fbe:	c9                   	leave  
c0103fbf:	c3                   	ret    

c0103fc0 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c0103fc0:	f3 0f 1e fb          	endbr32 
c0103fc4:	55                   	push   %ebp
c0103fc5:	89 e5                	mov    %esp,%ebp
c0103fc7:	57                   	push   %edi
c0103fc8:	56                   	push   %esi
c0103fc9:	53                   	push   %ebx
c0103fca:	83 ec 2c             	sub    $0x2c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c0103fcd:	83 ec 0c             	sub    $0xc,%esp
c0103fd0:	68 50 69 10 c0       	push   $0xc0106950
c0103fd5:	e8 c1 c2 ff ff       	call   c010029b <cprintf>
c0103fda:	83 c4 10             	add    $0x10,%esp
    size_t left, right = 0, perm;
c0103fdd:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0103fe4:	e9 e1 00 00 00       	jmp    c01040ca <print_pgdir+0x10a>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0103fe9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103fec:	83 ec 0c             	sub    $0xc,%esp
c0103fef:	50                   	push   %eax
c0103ff0:	e8 c1 fe ff ff       	call   c0103eb6 <perm2str>
c0103ff5:	83 c4 10             	add    $0x10,%esp
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c0103ff8:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0103ffb:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0103ffe:	29 d1                	sub    %edx,%ecx
c0104000:	89 ca                	mov    %ecx,%edx
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0104002:	89 d6                	mov    %edx,%esi
c0104004:	c1 e6 16             	shl    $0x16,%esi
c0104007:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010400a:	89 d3                	mov    %edx,%ebx
c010400c:	c1 e3 16             	shl    $0x16,%ebx
c010400f:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104012:	89 d1                	mov    %edx,%ecx
c0104014:	c1 e1 16             	shl    $0x16,%ecx
c0104017:	8b 7d dc             	mov    -0x24(%ebp),%edi
c010401a:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010401d:	29 d7                	sub    %edx,%edi
c010401f:	89 fa                	mov    %edi,%edx
c0104021:	83 ec 08             	sub    $0x8,%esp
c0104024:	50                   	push   %eax
c0104025:	56                   	push   %esi
c0104026:	53                   	push   %ebx
c0104027:	51                   	push   %ecx
c0104028:	52                   	push   %edx
c0104029:	68 81 69 10 c0       	push   $0xc0106981
c010402e:	e8 68 c2 ff ff       	call   c010029b <cprintf>
c0104033:	83 c4 20             	add    $0x20,%esp
        size_t l, r = left * NPTEENTRY;
c0104036:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104039:	c1 e0 0a             	shl    $0xa,%eax
c010403c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c010403f:	eb 4d                	jmp    c010408e <print_pgdir+0xce>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0104041:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104044:	83 ec 0c             	sub    $0xc,%esp
c0104047:	50                   	push   %eax
c0104048:	e8 69 fe ff ff       	call   c0103eb6 <perm2str>
c010404d:	83 c4 10             	add    $0x10,%esp
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c0104050:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c0104053:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0104056:	29 d1                	sub    %edx,%ecx
c0104058:	89 ca                	mov    %ecx,%edx
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c010405a:	89 d6                	mov    %edx,%esi
c010405c:	c1 e6 0c             	shl    $0xc,%esi
c010405f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104062:	89 d3                	mov    %edx,%ebx
c0104064:	c1 e3 0c             	shl    $0xc,%ebx
c0104067:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010406a:	89 d1                	mov    %edx,%ecx
c010406c:	c1 e1 0c             	shl    $0xc,%ecx
c010406f:	8b 7d d4             	mov    -0x2c(%ebp),%edi
c0104072:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0104075:	29 d7                	sub    %edx,%edi
c0104077:	89 fa                	mov    %edi,%edx
c0104079:	83 ec 08             	sub    $0x8,%esp
c010407c:	50                   	push   %eax
c010407d:	56                   	push   %esi
c010407e:	53                   	push   %ebx
c010407f:	51                   	push   %ecx
c0104080:	52                   	push   %edx
c0104081:	68 a0 69 10 c0       	push   $0xc01069a0
c0104086:	e8 10 c2 ff ff       	call   c010029b <cprintf>
c010408b:	83 c4 20             	add    $0x20,%esp
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c010408e:	be 00 00 c0 fa       	mov    $0xfac00000,%esi
c0104093:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104096:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104099:	89 d3                	mov    %edx,%ebx
c010409b:	c1 e3 0a             	shl    $0xa,%ebx
c010409e:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01040a1:	89 d1                	mov    %edx,%ecx
c01040a3:	c1 e1 0a             	shl    $0xa,%ecx
c01040a6:	83 ec 08             	sub    $0x8,%esp
c01040a9:	8d 55 d4             	lea    -0x2c(%ebp),%edx
c01040ac:	52                   	push   %edx
c01040ad:	8d 55 d8             	lea    -0x28(%ebp),%edx
c01040b0:	52                   	push   %edx
c01040b1:	56                   	push   %esi
c01040b2:	50                   	push   %eax
c01040b3:	53                   	push   %ebx
c01040b4:	51                   	push   %ecx
c01040b5:	e8 4e fe ff ff       	call   c0103f08 <get_pgtable_items>
c01040ba:	83 c4 20             	add    $0x20,%esp
c01040bd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01040c0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01040c4:	0f 85 77 ff ff ff    	jne    c0104041 <print_pgdir+0x81>
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c01040ca:	b9 00 b0 fe fa       	mov    $0xfafeb000,%ecx
c01040cf:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01040d2:	83 ec 08             	sub    $0x8,%esp
c01040d5:	8d 55 dc             	lea    -0x24(%ebp),%edx
c01040d8:	52                   	push   %edx
c01040d9:	8d 55 e0             	lea    -0x20(%ebp),%edx
c01040dc:	52                   	push   %edx
c01040dd:	51                   	push   %ecx
c01040de:	50                   	push   %eax
c01040df:	68 00 04 00 00       	push   $0x400
c01040e4:	6a 00                	push   $0x0
c01040e6:	e8 1d fe ff ff       	call   c0103f08 <get_pgtable_items>
c01040eb:	83 c4 20             	add    $0x20,%esp
c01040ee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01040f1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01040f5:	0f 85 ee fe ff ff    	jne    c0103fe9 <print_pgdir+0x29>
        }
    }
    cprintf("--------------------- END ---------------------\n");
c01040fb:	83 ec 0c             	sub    $0xc,%esp
c01040fe:	68 c4 69 10 c0       	push   $0xc01069c4
c0104103:	e8 93 c1 ff ff       	call   c010029b <cprintf>
c0104108:	83 c4 10             	add    $0x10,%esp
}
c010410b:	90                   	nop
c010410c:	8d 65 f4             	lea    -0xc(%ebp),%esp
c010410f:	5b                   	pop    %ebx
c0104110:	5e                   	pop    %esi
c0104111:	5f                   	pop    %edi
c0104112:	5d                   	pop    %ebp
c0104113:	c3                   	ret    

c0104114 <page2ppn>:
page2ppn(struct Page *page) {
c0104114:	55                   	push   %ebp
c0104115:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0104117:	a1 18 cf 11 c0       	mov    0xc011cf18,%eax
c010411c:	8b 55 08             	mov    0x8(%ebp),%edx
c010411f:	29 c2                	sub    %eax,%edx
c0104121:	89 d0                	mov    %edx,%eax
c0104123:	c1 f8 02             	sar    $0x2,%eax
c0104126:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c010412c:	5d                   	pop    %ebp
c010412d:	c3                   	ret    

c010412e <page2pa>:
page2pa(struct Page *page) {
c010412e:	55                   	push   %ebp
c010412f:	89 e5                	mov    %esp,%ebp
    return page2ppn(page) << PGSHIFT;
c0104131:	ff 75 08             	pushl  0x8(%ebp)
c0104134:	e8 db ff ff ff       	call   c0104114 <page2ppn>
c0104139:	83 c4 04             	add    $0x4,%esp
c010413c:	c1 e0 0c             	shl    $0xc,%eax
}
c010413f:	c9                   	leave  
c0104140:	c3                   	ret    

c0104141 <page_ref>:
page_ref(struct Page *page) {
c0104141:	55                   	push   %ebp
c0104142:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0104144:	8b 45 08             	mov    0x8(%ebp),%eax
c0104147:	8b 00                	mov    (%eax),%eax
}
c0104149:	5d                   	pop    %ebp
c010414a:	c3                   	ret    

c010414b <set_page_ref>:
set_page_ref(struct Page *page, int val) {
c010414b:	55                   	push   %ebp
c010414c:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c010414e:	8b 45 08             	mov    0x8(%ebp),%eax
c0104151:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104154:	89 10                	mov    %edx,(%eax)
}
c0104156:	90                   	nop
c0104157:	5d                   	pop    %ebp
c0104158:	c3                   	ret    

c0104159 <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
c0104159:	f3 0f 1e fb          	endbr32 
c010415d:	55                   	push   %ebp
c010415e:	89 e5                	mov    %esp,%ebp
c0104160:	83 ec 10             	sub    $0x10,%esp
c0104163:	c7 45 fc 1c cf 11 c0 	movl   $0xc011cf1c,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c010416a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010416d:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0104170:	89 50 04             	mov    %edx,0x4(%eax)
c0104173:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104176:	8b 50 04             	mov    0x4(%eax),%edx
c0104179:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010417c:	89 10                	mov    %edx,(%eax)
}
c010417e:	90                   	nop
    list_init(&free_list);
    nr_free = 0;
c010417f:	c7 05 24 cf 11 c0 00 	movl   $0x0,0xc011cf24
c0104186:	00 00 00 
}
c0104189:	90                   	nop
c010418a:	c9                   	leave  
c010418b:	c3                   	ret    

c010418c <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
c010418c:	f3 0f 1e fb          	endbr32 
c0104190:	55                   	push   %ebp
c0104191:	89 e5                	mov    %esp,%ebp
c0104193:	83 ec 38             	sub    $0x38,%esp
    assert(n > 0);
c0104196:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010419a:	75 16                	jne    c01041b2 <default_init_memmap+0x26>
c010419c:	68 f8 69 10 c0       	push   $0xc01069f8
c01041a1:	68 fe 69 10 c0       	push   $0xc01069fe
c01041a6:	6a 6d                	push   $0x6d
c01041a8:	68 13 6a 10 c0       	push   $0xc0106a13
c01041ad:	e8 64 c2 ff ff       	call   c0100416 <__panic>
    struct Page *p = base;
c01041b2:	8b 45 08             	mov    0x8(%ebp),%eax
c01041b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c01041b8:	eb 6c                	jmp    c0104226 <default_init_memmap+0x9a>
        assert(PageReserved(p));
c01041ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01041bd:	83 c0 04             	add    $0x4,%eax
c01041c0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c01041c7:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01041ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01041cd:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01041d0:	0f a3 10             	bt     %edx,(%eax)
c01041d3:	19 c0                	sbb    %eax,%eax
c01041d5:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
c01041d8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01041dc:	0f 95 c0             	setne  %al
c01041df:	0f b6 c0             	movzbl %al,%eax
c01041e2:	85 c0                	test   %eax,%eax
c01041e4:	75 16                	jne    c01041fc <default_init_memmap+0x70>
c01041e6:	68 29 6a 10 c0       	push   $0xc0106a29
c01041eb:	68 fe 69 10 c0       	push   $0xc01069fe
c01041f0:	6a 70                	push   $0x70
c01041f2:	68 13 6a 10 c0       	push   $0xc0106a13
c01041f7:	e8 1a c2 ff ff       	call   c0100416 <__panic>
        p->flags = p->property = 0;
c01041fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01041ff:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
c0104206:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104209:	8b 50 08             	mov    0x8(%eax),%edx
c010420c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010420f:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
c0104212:	83 ec 08             	sub    $0x8,%esp
c0104215:	6a 00                	push   $0x0
c0104217:	ff 75 f4             	pushl  -0xc(%ebp)
c010421a:	e8 2c ff ff ff       	call   c010414b <set_page_ref>
c010421f:	83 c4 10             	add    $0x10,%esp
    for (; p != base + n; p ++) {
c0104222:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0104226:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104229:	89 d0                	mov    %edx,%eax
c010422b:	c1 e0 02             	shl    $0x2,%eax
c010422e:	01 d0                	add    %edx,%eax
c0104230:	c1 e0 02             	shl    $0x2,%eax
c0104233:	89 c2                	mov    %eax,%edx
c0104235:	8b 45 08             	mov    0x8(%ebp),%eax
c0104238:	01 d0                	add    %edx,%eax
c010423a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c010423d:	0f 85 77 ff ff ff    	jne    c01041ba <default_init_memmap+0x2e>
    }
    base->property = n;
c0104243:	8b 45 08             	mov    0x8(%ebp),%eax
c0104246:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104249:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c010424c:	8b 45 08             	mov    0x8(%ebp),%eax
c010424f:	83 c0 04             	add    $0x4,%eax
c0104252:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0104259:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c010425c:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010425f:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0104262:	0f ab 10             	bts    %edx,(%eax)
}
c0104265:	90                   	nop
    nr_free += n;
c0104266:	8b 15 24 cf 11 c0    	mov    0xc011cf24,%edx
c010426c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010426f:	01 d0                	add    %edx,%eax
c0104271:	a3 24 cf 11 c0       	mov    %eax,0xc011cf24
    list_add_before(&free_list, &(base->page_link));
c0104276:	8b 45 08             	mov    0x8(%ebp),%eax
c0104279:	83 c0 0c             	add    $0xc,%eax
c010427c:	c7 45 e4 1c cf 11 c0 	movl   $0xc011cf1c,-0x1c(%ebp)
c0104283:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0104286:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104289:	8b 00                	mov    (%eax),%eax
c010428b:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010428e:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0104291:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0104294:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104297:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c010429a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010429d:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01042a0:	89 10                	mov    %edx,(%eax)
c01042a2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01042a5:	8b 10                	mov    (%eax),%edx
c01042a7:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01042aa:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01042ad:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01042b0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01042b3:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01042b6:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01042b9:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01042bc:	89 10                	mov    %edx,(%eax)
}
c01042be:	90                   	nop
}
c01042bf:	90                   	nop
}
c01042c0:	90                   	nop
c01042c1:	c9                   	leave  
c01042c2:	c3                   	ret    

c01042c3 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
c01042c3:	f3 0f 1e fb          	endbr32 
c01042c7:	55                   	push   %ebp
c01042c8:	89 e5                	mov    %esp,%ebp
c01042ca:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
c01042cd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01042d1:	75 16                	jne    c01042e9 <default_alloc_pages+0x26>
c01042d3:	68 f8 69 10 c0       	push   $0xc01069f8
c01042d8:	68 fe 69 10 c0       	push   $0xc01069fe
c01042dd:	6a 7c                	push   $0x7c
c01042df:	68 13 6a 10 c0       	push   $0xc0106a13
c01042e4:	e8 2d c1 ff ff       	call   c0100416 <__panic>
    if (n > nr_free) {
c01042e9:	a1 24 cf 11 c0       	mov    0xc011cf24,%eax
c01042ee:	39 45 08             	cmp    %eax,0x8(%ebp)
c01042f1:	76 0a                	jbe    c01042fd <default_alloc_pages+0x3a>
        return NULL;
c01042f3:	b8 00 00 00 00       	mov    $0x0,%eax
c01042f8:	e9 43 01 00 00       	jmp    c0104440 <default_alloc_pages+0x17d>
    }
    struct Page *page = NULL;
c01042fd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
c0104304:	c7 45 f0 1c cf 11 c0 	movl   $0xc011cf1c,-0x10(%ebp)
    // TODO: optimize (next-fit)
    while ((le = list_next(le)) != &free_list) {
c010430b:	eb 1c                	jmp    c0104329 <default_alloc_pages+0x66>
        struct Page *p = le2page(le, page_link);
c010430d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104310:	83 e8 0c             	sub    $0xc,%eax
c0104313:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p->property >= n) {
c0104316:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104319:	8b 40 08             	mov    0x8(%eax),%eax
c010431c:	39 45 08             	cmp    %eax,0x8(%ebp)
c010431f:	77 08                	ja     c0104329 <default_alloc_pages+0x66>
            page = p;
c0104321:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104324:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
c0104327:	eb 18                	jmp    c0104341 <default_alloc_pages+0x7e>
c0104329:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010432c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return listelm->next;
c010432f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104332:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c0104335:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104338:	81 7d f0 1c cf 11 c0 	cmpl   $0xc011cf1c,-0x10(%ebp)
c010433f:	75 cc                	jne    c010430d <default_alloc_pages+0x4a>
        }
    }
    if (page != NULL) {
c0104341:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104345:	0f 84 f2 00 00 00    	je     c010443d <default_alloc_pages+0x17a>
        if (page->property > n) {
c010434b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010434e:	8b 40 08             	mov    0x8(%eax),%eax
c0104351:	39 45 08             	cmp    %eax,0x8(%ebp)
c0104354:	0f 83 8f 00 00 00    	jae    c01043e9 <default_alloc_pages+0x126>
            struct Page *p = page + n;
c010435a:	8b 55 08             	mov    0x8(%ebp),%edx
c010435d:	89 d0                	mov    %edx,%eax
c010435f:	c1 e0 02             	shl    $0x2,%eax
c0104362:	01 d0                	add    %edx,%eax
c0104364:	c1 e0 02             	shl    $0x2,%eax
c0104367:	89 c2                	mov    %eax,%edx
c0104369:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010436c:	01 d0                	add    %edx,%eax
c010436e:	89 45 e8             	mov    %eax,-0x18(%ebp)
            p->property = page->property - n;
c0104371:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104374:	8b 40 08             	mov    0x8(%eax),%eax
c0104377:	2b 45 08             	sub    0x8(%ebp),%eax
c010437a:	89 c2                	mov    %eax,%edx
c010437c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010437f:	89 50 08             	mov    %edx,0x8(%eax)
            SetPageProperty(p);
c0104382:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104385:	83 c0 04             	add    $0x4,%eax
c0104388:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
c010438f:	89 45 c8             	mov    %eax,-0x38(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0104392:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104395:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0104398:	0f ab 10             	bts    %edx,(%eax)
}
c010439b:	90                   	nop
            list_add_after(&(page->page_link), &(p->page_link));
c010439c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010439f:	83 c0 0c             	add    $0xc,%eax
c01043a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01043a5:	83 c2 0c             	add    $0xc,%edx
c01043a8:	89 55 e0             	mov    %edx,-0x20(%ebp)
c01043ab:	89 45 dc             	mov    %eax,-0x24(%ebp)
    __list_add(elm, listelm, listelm->next);
c01043ae:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01043b1:	8b 40 04             	mov    0x4(%eax),%eax
c01043b4:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01043b7:	89 55 d8             	mov    %edx,-0x28(%ebp)
c01043ba:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01043bd:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c01043c0:	89 45 d0             	mov    %eax,-0x30(%ebp)
    prev->next = next->prev = elm;
c01043c3:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01043c6:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01043c9:	89 10                	mov    %edx,(%eax)
c01043cb:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01043ce:	8b 10                	mov    (%eax),%edx
c01043d0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01043d3:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01043d6:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01043d9:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01043dc:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01043df:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01043e2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01043e5:	89 10                	mov    %edx,(%eax)
}
c01043e7:	90                   	nop
}
c01043e8:	90                   	nop
        }
        list_del(&(page->page_link));
c01043e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01043ec:	83 c0 0c             	add    $0xc,%eax
c01043ef:	89 45 bc             	mov    %eax,-0x44(%ebp)
    __list_del(listelm->prev, listelm->next);
c01043f2:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01043f5:	8b 40 04             	mov    0x4(%eax),%eax
c01043f8:	8b 55 bc             	mov    -0x44(%ebp),%edx
c01043fb:	8b 12                	mov    (%edx),%edx
c01043fd:	89 55 b8             	mov    %edx,-0x48(%ebp)
c0104400:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0104403:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0104406:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0104409:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c010440c:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c010440f:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0104412:	89 10                	mov    %edx,(%eax)
}
c0104414:	90                   	nop
}
c0104415:	90                   	nop
        nr_free -= n;
c0104416:	a1 24 cf 11 c0       	mov    0xc011cf24,%eax
c010441b:	2b 45 08             	sub    0x8(%ebp),%eax
c010441e:	a3 24 cf 11 c0       	mov    %eax,0xc011cf24
        ClearPageProperty(page);
c0104423:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104426:	83 c0 04             	add    $0x4,%eax
c0104429:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
c0104430:	89 45 c0             	mov    %eax,-0x40(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0104433:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0104436:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0104439:	0f b3 10             	btr    %edx,(%eax)
}
c010443c:	90                   	nop
    }
    return page;
c010443d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0104440:	c9                   	leave  
c0104441:	c3                   	ret    

c0104442 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
c0104442:	f3 0f 1e fb          	endbr32 
c0104446:	55                   	push   %ebp
c0104447:	89 e5                	mov    %esp,%ebp
c0104449:	81 ec 88 00 00 00    	sub    $0x88,%esp
    assert(n > 0);
c010444f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0104453:	75 19                	jne    c010446e <default_free_pages+0x2c>
c0104455:	68 f8 69 10 c0       	push   $0xc01069f8
c010445a:	68 fe 69 10 c0       	push   $0xc01069fe
c010445f:	68 9a 00 00 00       	push   $0x9a
c0104464:	68 13 6a 10 c0       	push   $0xc0106a13
c0104469:	e8 a8 bf ff ff       	call   c0100416 <__panic>
    struct Page *p = base;
c010446e:	8b 45 08             	mov    0x8(%ebp),%eax
c0104471:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c0104474:	e9 8f 00 00 00       	jmp    c0104508 <default_free_pages+0xc6>
        assert(!PageReserved(p) && !PageProperty(p));
c0104479:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010447c:	83 c0 04             	add    $0x4,%eax
c010447f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0104486:	89 45 e8             	mov    %eax,-0x18(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104489:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010448c:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010448f:	0f a3 10             	bt     %edx,(%eax)
c0104492:	19 c0                	sbb    %eax,%eax
c0104494:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
c0104497:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010449b:	0f 95 c0             	setne  %al
c010449e:	0f b6 c0             	movzbl %al,%eax
c01044a1:	85 c0                	test   %eax,%eax
c01044a3:	75 2c                	jne    c01044d1 <default_free_pages+0x8f>
c01044a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01044a8:	83 c0 04             	add    $0x4,%eax
c01044ab:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
c01044b2:	89 45 dc             	mov    %eax,-0x24(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01044b5:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01044b8:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01044bb:	0f a3 10             	bt     %edx,(%eax)
c01044be:	19 c0                	sbb    %eax,%eax
c01044c0:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return oldbit != 0;
c01044c3:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c01044c7:	0f 95 c0             	setne  %al
c01044ca:	0f b6 c0             	movzbl %al,%eax
c01044cd:	85 c0                	test   %eax,%eax
c01044cf:	74 19                	je     c01044ea <default_free_pages+0xa8>
c01044d1:	68 3c 6a 10 c0       	push   $0xc0106a3c
c01044d6:	68 fe 69 10 c0       	push   $0xc01069fe
c01044db:	68 9d 00 00 00       	push   $0x9d
c01044e0:	68 13 6a 10 c0       	push   $0xc0106a13
c01044e5:	e8 2c bf ff ff       	call   c0100416 <__panic>
        p->flags = 0;
c01044ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01044ed:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
c01044f4:	83 ec 08             	sub    $0x8,%esp
c01044f7:	6a 00                	push   $0x0
c01044f9:	ff 75 f4             	pushl  -0xc(%ebp)
c01044fc:	e8 4a fc ff ff       	call   c010414b <set_page_ref>
c0104501:	83 c4 10             	add    $0x10,%esp
    for (; p != base + n; p ++) {
c0104504:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0104508:	8b 55 0c             	mov    0xc(%ebp),%edx
c010450b:	89 d0                	mov    %edx,%eax
c010450d:	c1 e0 02             	shl    $0x2,%eax
c0104510:	01 d0                	add    %edx,%eax
c0104512:	c1 e0 02             	shl    $0x2,%eax
c0104515:	89 c2                	mov    %eax,%edx
c0104517:	8b 45 08             	mov    0x8(%ebp),%eax
c010451a:	01 d0                	add    %edx,%eax
c010451c:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c010451f:	0f 85 54 ff ff ff    	jne    c0104479 <default_free_pages+0x37>
    }
    base->property = n;
c0104525:	8b 45 08             	mov    0x8(%ebp),%eax
c0104528:	8b 55 0c             	mov    0xc(%ebp),%edx
c010452b:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c010452e:	8b 45 08             	mov    0x8(%ebp),%eax
c0104531:	83 c0 04             	add    $0x4,%eax
c0104534:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c010453b:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c010453e:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0104541:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0104544:	0f ab 10             	bts    %edx,(%eax)
}
c0104547:	90                   	nop
c0104548:	c7 45 d4 1c cf 11 c0 	movl   $0xc011cf1c,-0x2c(%ebp)
    return listelm->next;
c010454f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104552:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
c0104555:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c0104558:	e9 0e 01 00 00       	jmp    c010466b <default_free_pages+0x229>
        p = le2page(le, page_link);
c010455d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104560:	83 e8 0c             	sub    $0xc,%eax
c0104563:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104566:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104569:	89 45 c8             	mov    %eax,-0x38(%ebp)
c010456c:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010456f:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c0104572:	89 45 f0             	mov    %eax,-0x10(%ebp)
        // TODO: optimize
        if (base + base->property == p) {
c0104575:	8b 45 08             	mov    0x8(%ebp),%eax
c0104578:	8b 50 08             	mov    0x8(%eax),%edx
c010457b:	89 d0                	mov    %edx,%eax
c010457d:	c1 e0 02             	shl    $0x2,%eax
c0104580:	01 d0                	add    %edx,%eax
c0104582:	c1 e0 02             	shl    $0x2,%eax
c0104585:	89 c2                	mov    %eax,%edx
c0104587:	8b 45 08             	mov    0x8(%ebp),%eax
c010458a:	01 d0                	add    %edx,%eax
c010458c:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c010458f:	75 5d                	jne    c01045ee <default_free_pages+0x1ac>
            base->property += p->property;
c0104591:	8b 45 08             	mov    0x8(%ebp),%eax
c0104594:	8b 50 08             	mov    0x8(%eax),%edx
c0104597:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010459a:	8b 40 08             	mov    0x8(%eax),%eax
c010459d:	01 c2                	add    %eax,%edx
c010459f:	8b 45 08             	mov    0x8(%ebp),%eax
c01045a2:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(p);
c01045a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045a8:	83 c0 04             	add    $0x4,%eax
c01045ab:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
c01045b2:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01045b5:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01045b8:	8b 55 b8             	mov    -0x48(%ebp),%edx
c01045bb:	0f b3 10             	btr    %edx,(%eax)
}
c01045be:	90                   	nop
            list_del(&(p->page_link));
c01045bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045c2:	83 c0 0c             	add    $0xc,%eax
c01045c5:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    __list_del(listelm->prev, listelm->next);
c01045c8:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01045cb:	8b 40 04             	mov    0x4(%eax),%eax
c01045ce:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c01045d1:	8b 12                	mov    (%edx),%edx
c01045d3:	89 55 c0             	mov    %edx,-0x40(%ebp)
c01045d6:	89 45 bc             	mov    %eax,-0x44(%ebp)
    prev->next = next;
c01045d9:	8b 45 c0             	mov    -0x40(%ebp),%eax
c01045dc:	8b 55 bc             	mov    -0x44(%ebp),%edx
c01045df:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c01045e2:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01045e5:	8b 55 c0             	mov    -0x40(%ebp),%edx
c01045e8:	89 10                	mov    %edx,(%eax)
}
c01045ea:	90                   	nop
}
c01045eb:	90                   	nop
c01045ec:	eb 7d                	jmp    c010466b <default_free_pages+0x229>
        }
        else if (p + p->property == base) {
c01045ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045f1:	8b 50 08             	mov    0x8(%eax),%edx
c01045f4:	89 d0                	mov    %edx,%eax
c01045f6:	c1 e0 02             	shl    $0x2,%eax
c01045f9:	01 d0                	add    %edx,%eax
c01045fb:	c1 e0 02             	shl    $0x2,%eax
c01045fe:	89 c2                	mov    %eax,%edx
c0104600:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104603:	01 d0                	add    %edx,%eax
c0104605:	39 45 08             	cmp    %eax,0x8(%ebp)
c0104608:	75 61                	jne    c010466b <default_free_pages+0x229>
            p->property += base->property;
c010460a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010460d:	8b 50 08             	mov    0x8(%eax),%edx
c0104610:	8b 45 08             	mov    0x8(%ebp),%eax
c0104613:	8b 40 08             	mov    0x8(%eax),%eax
c0104616:	01 c2                	add    %eax,%edx
c0104618:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010461b:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);
c010461e:	8b 45 08             	mov    0x8(%ebp),%eax
c0104621:	83 c0 04             	add    $0x4,%eax
c0104624:	c7 45 a4 01 00 00 00 	movl   $0x1,-0x5c(%ebp)
c010462b:	89 45 a0             	mov    %eax,-0x60(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c010462e:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0104631:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0104634:	0f b3 10             	btr    %edx,(%eax)
}
c0104637:	90                   	nop
            base = p;
c0104638:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010463b:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
c010463e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104641:	83 c0 0c             	add    $0xc,%eax
c0104644:	89 45 b0             	mov    %eax,-0x50(%ebp)
    __list_del(listelm->prev, listelm->next);
c0104647:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010464a:	8b 40 04             	mov    0x4(%eax),%eax
c010464d:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0104650:	8b 12                	mov    (%edx),%edx
c0104652:	89 55 ac             	mov    %edx,-0x54(%ebp)
c0104655:	89 45 a8             	mov    %eax,-0x58(%ebp)
    prev->next = next;
c0104658:	8b 45 ac             	mov    -0x54(%ebp),%eax
c010465b:	8b 55 a8             	mov    -0x58(%ebp),%edx
c010465e:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0104661:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0104664:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0104667:	89 10                	mov    %edx,(%eax)
}
c0104669:	90                   	nop
}
c010466a:	90                   	nop
    while (le != &free_list) {
c010466b:	81 7d f0 1c cf 11 c0 	cmpl   $0xc011cf1c,-0x10(%ebp)
c0104672:	0f 85 e5 fe ff ff    	jne    c010455d <default_free_pages+0x11b>
        }
    }
    nr_free += n;
c0104678:	8b 15 24 cf 11 c0    	mov    0xc011cf24,%edx
c010467e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104681:	01 d0                	add    %edx,%eax
c0104683:	a3 24 cf 11 c0       	mov    %eax,0xc011cf24
c0104688:	c7 45 9c 1c cf 11 c0 	movl   $0xc011cf1c,-0x64(%ebp)
    return listelm->next;
c010468f:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0104692:	8b 40 04             	mov    0x4(%eax),%eax
    le = list_next(&free_list);
c0104695:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c0104698:	eb 69                	jmp    c0104703 <default_free_pages+0x2c1>
        p = le2page(le, page_link);
c010469a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010469d:	83 e8 0c             	sub    $0xc,%eax
c01046a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (base + base->property <= p) {
c01046a3:	8b 45 08             	mov    0x8(%ebp),%eax
c01046a6:	8b 50 08             	mov    0x8(%eax),%edx
c01046a9:	89 d0                	mov    %edx,%eax
c01046ab:	c1 e0 02             	shl    $0x2,%eax
c01046ae:	01 d0                	add    %edx,%eax
c01046b0:	c1 e0 02             	shl    $0x2,%eax
c01046b3:	89 c2                	mov    %eax,%edx
c01046b5:	8b 45 08             	mov    0x8(%ebp),%eax
c01046b8:	01 d0                	add    %edx,%eax
c01046ba:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c01046bd:	72 35                	jb     c01046f4 <default_free_pages+0x2b2>
            assert(base + base->property != p);
c01046bf:	8b 45 08             	mov    0x8(%ebp),%eax
c01046c2:	8b 50 08             	mov    0x8(%eax),%edx
c01046c5:	89 d0                	mov    %edx,%eax
c01046c7:	c1 e0 02             	shl    $0x2,%eax
c01046ca:	01 d0                	add    %edx,%eax
c01046cc:	c1 e0 02             	shl    $0x2,%eax
c01046cf:	89 c2                	mov    %eax,%edx
c01046d1:	8b 45 08             	mov    0x8(%ebp),%eax
c01046d4:	01 d0                	add    %edx,%eax
c01046d6:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c01046d9:	75 33                	jne    c010470e <default_free_pages+0x2cc>
c01046db:	68 61 6a 10 c0       	push   $0xc0106a61
c01046e0:	68 fe 69 10 c0       	push   $0xc01069fe
c01046e5:	68 b9 00 00 00       	push   $0xb9
c01046ea:	68 13 6a 10 c0       	push   $0xc0106a13
c01046ef:	e8 22 bd ff ff       	call   c0100416 <__panic>
c01046f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01046f7:	89 45 98             	mov    %eax,-0x68(%ebp)
c01046fa:	8b 45 98             	mov    -0x68(%ebp),%eax
c01046fd:	8b 40 04             	mov    0x4(%eax),%eax
            break;
        }
        le = list_next(le);
c0104700:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c0104703:	81 7d f0 1c cf 11 c0 	cmpl   $0xc011cf1c,-0x10(%ebp)
c010470a:	75 8e                	jne    c010469a <default_free_pages+0x258>
c010470c:	eb 01                	jmp    c010470f <default_free_pages+0x2cd>
            break;
c010470e:	90                   	nop
    }
    list_add_before(le, &(base->page_link));
c010470f:	8b 45 08             	mov    0x8(%ebp),%eax
c0104712:	8d 50 0c             	lea    0xc(%eax),%edx
c0104715:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104718:	89 45 94             	mov    %eax,-0x6c(%ebp)
c010471b:	89 55 90             	mov    %edx,-0x70(%ebp)
    __list_add(elm, listelm->prev, listelm);
c010471e:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0104721:	8b 00                	mov    (%eax),%eax
c0104723:	8b 55 90             	mov    -0x70(%ebp),%edx
c0104726:	89 55 8c             	mov    %edx,-0x74(%ebp)
c0104729:	89 45 88             	mov    %eax,-0x78(%ebp)
c010472c:	8b 45 94             	mov    -0x6c(%ebp),%eax
c010472f:	89 45 84             	mov    %eax,-0x7c(%ebp)
    prev->next = next->prev = elm;
c0104732:	8b 45 84             	mov    -0x7c(%ebp),%eax
c0104735:	8b 55 8c             	mov    -0x74(%ebp),%edx
c0104738:	89 10                	mov    %edx,(%eax)
c010473a:	8b 45 84             	mov    -0x7c(%ebp),%eax
c010473d:	8b 10                	mov    (%eax),%edx
c010473f:	8b 45 88             	mov    -0x78(%ebp),%eax
c0104742:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0104745:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0104748:	8b 55 84             	mov    -0x7c(%ebp),%edx
c010474b:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c010474e:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0104751:	8b 55 88             	mov    -0x78(%ebp),%edx
c0104754:	89 10                	mov    %edx,(%eax)
}
c0104756:	90                   	nop
}
c0104757:	90                   	nop
}
c0104758:	90                   	nop
c0104759:	c9                   	leave  
c010475a:	c3                   	ret    

c010475b <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c010475b:	f3 0f 1e fb          	endbr32 
c010475f:	55                   	push   %ebp
c0104760:	89 e5                	mov    %esp,%ebp
    return nr_free;
c0104762:	a1 24 cf 11 c0       	mov    0xc011cf24,%eax
}
c0104767:	5d                   	pop    %ebp
c0104768:	c3                   	ret    

c0104769 <basic_check>:

static void
basic_check(void) {
c0104769:	f3 0f 1e fb          	endbr32 
c010476d:	55                   	push   %ebp
c010476e:	89 e5                	mov    %esp,%ebp
c0104770:	83 ec 38             	sub    $0x38,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c0104773:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010477a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010477d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104780:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104783:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c0104786:	83 ec 0c             	sub    $0xc,%esp
c0104789:	6a 01                	push   $0x1
c010478b:	e8 22 e5 ff ff       	call   c0102cb2 <alloc_pages>
c0104790:	83 c4 10             	add    $0x10,%esp
c0104793:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104796:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c010479a:	75 19                	jne    c01047b5 <basic_check+0x4c>
c010479c:	68 7c 6a 10 c0       	push   $0xc0106a7c
c01047a1:	68 fe 69 10 c0       	push   $0xc01069fe
c01047a6:	68 ca 00 00 00       	push   $0xca
c01047ab:	68 13 6a 10 c0       	push   $0xc0106a13
c01047b0:	e8 61 bc ff ff       	call   c0100416 <__panic>
    assert((p1 = alloc_page()) != NULL);
c01047b5:	83 ec 0c             	sub    $0xc,%esp
c01047b8:	6a 01                	push   $0x1
c01047ba:	e8 f3 e4 ff ff       	call   c0102cb2 <alloc_pages>
c01047bf:	83 c4 10             	add    $0x10,%esp
c01047c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01047c5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01047c9:	75 19                	jne    c01047e4 <basic_check+0x7b>
c01047cb:	68 98 6a 10 c0       	push   $0xc0106a98
c01047d0:	68 fe 69 10 c0       	push   $0xc01069fe
c01047d5:	68 cb 00 00 00       	push   $0xcb
c01047da:	68 13 6a 10 c0       	push   $0xc0106a13
c01047df:	e8 32 bc ff ff       	call   c0100416 <__panic>
    assert((p2 = alloc_page()) != NULL);
c01047e4:	83 ec 0c             	sub    $0xc,%esp
c01047e7:	6a 01                	push   $0x1
c01047e9:	e8 c4 e4 ff ff       	call   c0102cb2 <alloc_pages>
c01047ee:	83 c4 10             	add    $0x10,%esp
c01047f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01047f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01047f8:	75 19                	jne    c0104813 <basic_check+0xaa>
c01047fa:	68 b4 6a 10 c0       	push   $0xc0106ab4
c01047ff:	68 fe 69 10 c0       	push   $0xc01069fe
c0104804:	68 cc 00 00 00       	push   $0xcc
c0104809:	68 13 6a 10 c0       	push   $0xc0106a13
c010480e:	e8 03 bc ff ff       	call   c0100416 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c0104813:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104816:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0104819:	74 10                	je     c010482b <basic_check+0xc2>
c010481b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010481e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104821:	74 08                	je     c010482b <basic_check+0xc2>
c0104823:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104826:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104829:	75 19                	jne    c0104844 <basic_check+0xdb>
c010482b:	68 d0 6a 10 c0       	push   $0xc0106ad0
c0104830:	68 fe 69 10 c0       	push   $0xc01069fe
c0104835:	68 ce 00 00 00       	push   $0xce
c010483a:	68 13 6a 10 c0       	push   $0xc0106a13
c010483f:	e8 d2 bb ff ff       	call   c0100416 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c0104844:	83 ec 0c             	sub    $0xc,%esp
c0104847:	ff 75 ec             	pushl  -0x14(%ebp)
c010484a:	e8 f2 f8 ff ff       	call   c0104141 <page_ref>
c010484f:	83 c4 10             	add    $0x10,%esp
c0104852:	85 c0                	test   %eax,%eax
c0104854:	75 24                	jne    c010487a <basic_check+0x111>
c0104856:	83 ec 0c             	sub    $0xc,%esp
c0104859:	ff 75 f0             	pushl  -0x10(%ebp)
c010485c:	e8 e0 f8 ff ff       	call   c0104141 <page_ref>
c0104861:	83 c4 10             	add    $0x10,%esp
c0104864:	85 c0                	test   %eax,%eax
c0104866:	75 12                	jne    c010487a <basic_check+0x111>
c0104868:	83 ec 0c             	sub    $0xc,%esp
c010486b:	ff 75 f4             	pushl  -0xc(%ebp)
c010486e:	e8 ce f8 ff ff       	call   c0104141 <page_ref>
c0104873:	83 c4 10             	add    $0x10,%esp
c0104876:	85 c0                	test   %eax,%eax
c0104878:	74 19                	je     c0104893 <basic_check+0x12a>
c010487a:	68 f4 6a 10 c0       	push   $0xc0106af4
c010487f:	68 fe 69 10 c0       	push   $0xc01069fe
c0104884:	68 cf 00 00 00       	push   $0xcf
c0104889:	68 13 6a 10 c0       	push   $0xc0106a13
c010488e:	e8 83 bb ff ff       	call   c0100416 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c0104893:	83 ec 0c             	sub    $0xc,%esp
c0104896:	ff 75 ec             	pushl  -0x14(%ebp)
c0104899:	e8 90 f8 ff ff       	call   c010412e <page2pa>
c010489e:	83 c4 10             	add    $0x10,%esp
c01048a1:	8b 15 80 ce 11 c0    	mov    0xc011ce80,%edx
c01048a7:	c1 e2 0c             	shl    $0xc,%edx
c01048aa:	39 d0                	cmp    %edx,%eax
c01048ac:	72 19                	jb     c01048c7 <basic_check+0x15e>
c01048ae:	68 30 6b 10 c0       	push   $0xc0106b30
c01048b3:	68 fe 69 10 c0       	push   $0xc01069fe
c01048b8:	68 d1 00 00 00       	push   $0xd1
c01048bd:	68 13 6a 10 c0       	push   $0xc0106a13
c01048c2:	e8 4f bb ff ff       	call   c0100416 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c01048c7:	83 ec 0c             	sub    $0xc,%esp
c01048ca:	ff 75 f0             	pushl  -0x10(%ebp)
c01048cd:	e8 5c f8 ff ff       	call   c010412e <page2pa>
c01048d2:	83 c4 10             	add    $0x10,%esp
c01048d5:	8b 15 80 ce 11 c0    	mov    0xc011ce80,%edx
c01048db:	c1 e2 0c             	shl    $0xc,%edx
c01048de:	39 d0                	cmp    %edx,%eax
c01048e0:	72 19                	jb     c01048fb <basic_check+0x192>
c01048e2:	68 4d 6b 10 c0       	push   $0xc0106b4d
c01048e7:	68 fe 69 10 c0       	push   $0xc01069fe
c01048ec:	68 d2 00 00 00       	push   $0xd2
c01048f1:	68 13 6a 10 c0       	push   $0xc0106a13
c01048f6:	e8 1b bb ff ff       	call   c0100416 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c01048fb:	83 ec 0c             	sub    $0xc,%esp
c01048fe:	ff 75 f4             	pushl  -0xc(%ebp)
c0104901:	e8 28 f8 ff ff       	call   c010412e <page2pa>
c0104906:	83 c4 10             	add    $0x10,%esp
c0104909:	8b 15 80 ce 11 c0    	mov    0xc011ce80,%edx
c010490f:	c1 e2 0c             	shl    $0xc,%edx
c0104912:	39 d0                	cmp    %edx,%eax
c0104914:	72 19                	jb     c010492f <basic_check+0x1c6>
c0104916:	68 6a 6b 10 c0       	push   $0xc0106b6a
c010491b:	68 fe 69 10 c0       	push   $0xc01069fe
c0104920:	68 d3 00 00 00       	push   $0xd3
c0104925:	68 13 6a 10 c0       	push   $0xc0106a13
c010492a:	e8 e7 ba ff ff       	call   c0100416 <__panic>

    list_entry_t free_list_store = free_list;
c010492f:	a1 1c cf 11 c0       	mov    0xc011cf1c,%eax
c0104934:	8b 15 20 cf 11 c0    	mov    0xc011cf20,%edx
c010493a:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010493d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0104940:	c7 45 dc 1c cf 11 c0 	movl   $0xc011cf1c,-0x24(%ebp)
    elm->prev = elm->next = elm;
c0104947:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010494a:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010494d:	89 50 04             	mov    %edx,0x4(%eax)
c0104950:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104953:	8b 50 04             	mov    0x4(%eax),%edx
c0104956:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104959:	89 10                	mov    %edx,(%eax)
}
c010495b:	90                   	nop
c010495c:	c7 45 e0 1c cf 11 c0 	movl   $0xc011cf1c,-0x20(%ebp)
    return list->next == list;
c0104963:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104966:	8b 40 04             	mov    0x4(%eax),%eax
c0104969:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c010496c:	0f 94 c0             	sete   %al
c010496f:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0104972:	85 c0                	test   %eax,%eax
c0104974:	75 19                	jne    c010498f <basic_check+0x226>
c0104976:	68 87 6b 10 c0       	push   $0xc0106b87
c010497b:	68 fe 69 10 c0       	push   $0xc01069fe
c0104980:	68 d7 00 00 00       	push   $0xd7
c0104985:	68 13 6a 10 c0       	push   $0xc0106a13
c010498a:	e8 87 ba ff ff       	call   c0100416 <__panic>

    unsigned int nr_free_store = nr_free;
c010498f:	a1 24 cf 11 c0       	mov    0xc011cf24,%eax
c0104994:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c0104997:	c7 05 24 cf 11 c0 00 	movl   $0x0,0xc011cf24
c010499e:	00 00 00 

    assert(alloc_page() == NULL);
c01049a1:	83 ec 0c             	sub    $0xc,%esp
c01049a4:	6a 01                	push   $0x1
c01049a6:	e8 07 e3 ff ff       	call   c0102cb2 <alloc_pages>
c01049ab:	83 c4 10             	add    $0x10,%esp
c01049ae:	85 c0                	test   %eax,%eax
c01049b0:	74 19                	je     c01049cb <basic_check+0x262>
c01049b2:	68 9e 6b 10 c0       	push   $0xc0106b9e
c01049b7:	68 fe 69 10 c0       	push   $0xc01069fe
c01049bc:	68 dc 00 00 00       	push   $0xdc
c01049c1:	68 13 6a 10 c0       	push   $0xc0106a13
c01049c6:	e8 4b ba ff ff       	call   c0100416 <__panic>

    free_page(p0);
c01049cb:	83 ec 08             	sub    $0x8,%esp
c01049ce:	6a 01                	push   $0x1
c01049d0:	ff 75 ec             	pushl  -0x14(%ebp)
c01049d3:	e8 1c e3 ff ff       	call   c0102cf4 <free_pages>
c01049d8:	83 c4 10             	add    $0x10,%esp
    free_page(p1);
c01049db:	83 ec 08             	sub    $0x8,%esp
c01049de:	6a 01                	push   $0x1
c01049e0:	ff 75 f0             	pushl  -0x10(%ebp)
c01049e3:	e8 0c e3 ff ff       	call   c0102cf4 <free_pages>
c01049e8:	83 c4 10             	add    $0x10,%esp
    free_page(p2);
c01049eb:	83 ec 08             	sub    $0x8,%esp
c01049ee:	6a 01                	push   $0x1
c01049f0:	ff 75 f4             	pushl  -0xc(%ebp)
c01049f3:	e8 fc e2 ff ff       	call   c0102cf4 <free_pages>
c01049f8:	83 c4 10             	add    $0x10,%esp
    assert(nr_free == 3);
c01049fb:	a1 24 cf 11 c0       	mov    0xc011cf24,%eax
c0104a00:	83 f8 03             	cmp    $0x3,%eax
c0104a03:	74 19                	je     c0104a1e <basic_check+0x2b5>
c0104a05:	68 b3 6b 10 c0       	push   $0xc0106bb3
c0104a0a:	68 fe 69 10 c0       	push   $0xc01069fe
c0104a0f:	68 e1 00 00 00       	push   $0xe1
c0104a14:	68 13 6a 10 c0       	push   $0xc0106a13
c0104a19:	e8 f8 b9 ff ff       	call   c0100416 <__panic>

    assert((p0 = alloc_page()) != NULL);
c0104a1e:	83 ec 0c             	sub    $0xc,%esp
c0104a21:	6a 01                	push   $0x1
c0104a23:	e8 8a e2 ff ff       	call   c0102cb2 <alloc_pages>
c0104a28:	83 c4 10             	add    $0x10,%esp
c0104a2b:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104a2e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0104a32:	75 19                	jne    c0104a4d <basic_check+0x2e4>
c0104a34:	68 7c 6a 10 c0       	push   $0xc0106a7c
c0104a39:	68 fe 69 10 c0       	push   $0xc01069fe
c0104a3e:	68 e3 00 00 00       	push   $0xe3
c0104a43:	68 13 6a 10 c0       	push   $0xc0106a13
c0104a48:	e8 c9 b9 ff ff       	call   c0100416 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0104a4d:	83 ec 0c             	sub    $0xc,%esp
c0104a50:	6a 01                	push   $0x1
c0104a52:	e8 5b e2 ff ff       	call   c0102cb2 <alloc_pages>
c0104a57:	83 c4 10             	add    $0x10,%esp
c0104a5a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104a5d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104a61:	75 19                	jne    c0104a7c <basic_check+0x313>
c0104a63:	68 98 6a 10 c0       	push   $0xc0106a98
c0104a68:	68 fe 69 10 c0       	push   $0xc01069fe
c0104a6d:	68 e4 00 00 00       	push   $0xe4
c0104a72:	68 13 6a 10 c0       	push   $0xc0106a13
c0104a77:	e8 9a b9 ff ff       	call   c0100416 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0104a7c:	83 ec 0c             	sub    $0xc,%esp
c0104a7f:	6a 01                	push   $0x1
c0104a81:	e8 2c e2 ff ff       	call   c0102cb2 <alloc_pages>
c0104a86:	83 c4 10             	add    $0x10,%esp
c0104a89:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104a8c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104a90:	75 19                	jne    c0104aab <basic_check+0x342>
c0104a92:	68 b4 6a 10 c0       	push   $0xc0106ab4
c0104a97:	68 fe 69 10 c0       	push   $0xc01069fe
c0104a9c:	68 e5 00 00 00       	push   $0xe5
c0104aa1:	68 13 6a 10 c0       	push   $0xc0106a13
c0104aa6:	e8 6b b9 ff ff       	call   c0100416 <__panic>

    assert(alloc_page() == NULL);
c0104aab:	83 ec 0c             	sub    $0xc,%esp
c0104aae:	6a 01                	push   $0x1
c0104ab0:	e8 fd e1 ff ff       	call   c0102cb2 <alloc_pages>
c0104ab5:	83 c4 10             	add    $0x10,%esp
c0104ab8:	85 c0                	test   %eax,%eax
c0104aba:	74 19                	je     c0104ad5 <basic_check+0x36c>
c0104abc:	68 9e 6b 10 c0       	push   $0xc0106b9e
c0104ac1:	68 fe 69 10 c0       	push   $0xc01069fe
c0104ac6:	68 e7 00 00 00       	push   $0xe7
c0104acb:	68 13 6a 10 c0       	push   $0xc0106a13
c0104ad0:	e8 41 b9 ff ff       	call   c0100416 <__panic>

    free_page(p0);
c0104ad5:	83 ec 08             	sub    $0x8,%esp
c0104ad8:	6a 01                	push   $0x1
c0104ada:	ff 75 ec             	pushl  -0x14(%ebp)
c0104add:	e8 12 e2 ff ff       	call   c0102cf4 <free_pages>
c0104ae2:	83 c4 10             	add    $0x10,%esp
c0104ae5:	c7 45 d8 1c cf 11 c0 	movl   $0xc011cf1c,-0x28(%ebp)
c0104aec:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104aef:	8b 40 04             	mov    0x4(%eax),%eax
c0104af2:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c0104af5:	0f 94 c0             	sete   %al
c0104af8:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c0104afb:	85 c0                	test   %eax,%eax
c0104afd:	74 19                	je     c0104b18 <basic_check+0x3af>
c0104aff:	68 c0 6b 10 c0       	push   $0xc0106bc0
c0104b04:	68 fe 69 10 c0       	push   $0xc01069fe
c0104b09:	68 ea 00 00 00       	push   $0xea
c0104b0e:	68 13 6a 10 c0       	push   $0xc0106a13
c0104b13:	e8 fe b8 ff ff       	call   c0100416 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c0104b18:	83 ec 0c             	sub    $0xc,%esp
c0104b1b:	6a 01                	push   $0x1
c0104b1d:	e8 90 e1 ff ff       	call   c0102cb2 <alloc_pages>
c0104b22:	83 c4 10             	add    $0x10,%esp
c0104b25:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104b28:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104b2b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0104b2e:	74 19                	je     c0104b49 <basic_check+0x3e0>
c0104b30:	68 d8 6b 10 c0       	push   $0xc0106bd8
c0104b35:	68 fe 69 10 c0       	push   $0xc01069fe
c0104b3a:	68 ed 00 00 00       	push   $0xed
c0104b3f:	68 13 6a 10 c0       	push   $0xc0106a13
c0104b44:	e8 cd b8 ff ff       	call   c0100416 <__panic>
    assert(alloc_page() == NULL);
c0104b49:	83 ec 0c             	sub    $0xc,%esp
c0104b4c:	6a 01                	push   $0x1
c0104b4e:	e8 5f e1 ff ff       	call   c0102cb2 <alloc_pages>
c0104b53:	83 c4 10             	add    $0x10,%esp
c0104b56:	85 c0                	test   %eax,%eax
c0104b58:	74 19                	je     c0104b73 <basic_check+0x40a>
c0104b5a:	68 9e 6b 10 c0       	push   $0xc0106b9e
c0104b5f:	68 fe 69 10 c0       	push   $0xc01069fe
c0104b64:	68 ee 00 00 00       	push   $0xee
c0104b69:	68 13 6a 10 c0       	push   $0xc0106a13
c0104b6e:	e8 a3 b8 ff ff       	call   c0100416 <__panic>

    assert(nr_free == 0);
c0104b73:	a1 24 cf 11 c0       	mov    0xc011cf24,%eax
c0104b78:	85 c0                	test   %eax,%eax
c0104b7a:	74 19                	je     c0104b95 <basic_check+0x42c>
c0104b7c:	68 f1 6b 10 c0       	push   $0xc0106bf1
c0104b81:	68 fe 69 10 c0       	push   $0xc01069fe
c0104b86:	68 f0 00 00 00       	push   $0xf0
c0104b8b:	68 13 6a 10 c0       	push   $0xc0106a13
c0104b90:	e8 81 b8 ff ff       	call   c0100416 <__panic>
    free_list = free_list_store;
c0104b95:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104b98:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104b9b:	a3 1c cf 11 c0       	mov    %eax,0xc011cf1c
c0104ba0:	89 15 20 cf 11 c0    	mov    %edx,0xc011cf20
    nr_free = nr_free_store;
c0104ba6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104ba9:	a3 24 cf 11 c0       	mov    %eax,0xc011cf24

    free_page(p);
c0104bae:	83 ec 08             	sub    $0x8,%esp
c0104bb1:	6a 01                	push   $0x1
c0104bb3:	ff 75 e4             	pushl  -0x1c(%ebp)
c0104bb6:	e8 39 e1 ff ff       	call   c0102cf4 <free_pages>
c0104bbb:	83 c4 10             	add    $0x10,%esp
    free_page(p1);
c0104bbe:	83 ec 08             	sub    $0x8,%esp
c0104bc1:	6a 01                	push   $0x1
c0104bc3:	ff 75 f0             	pushl  -0x10(%ebp)
c0104bc6:	e8 29 e1 ff ff       	call   c0102cf4 <free_pages>
c0104bcb:	83 c4 10             	add    $0x10,%esp
    free_page(p2);
c0104bce:	83 ec 08             	sub    $0x8,%esp
c0104bd1:	6a 01                	push   $0x1
c0104bd3:	ff 75 f4             	pushl  -0xc(%ebp)
c0104bd6:	e8 19 e1 ff ff       	call   c0102cf4 <free_pages>
c0104bdb:	83 c4 10             	add    $0x10,%esp
}
c0104bde:	90                   	nop
c0104bdf:	c9                   	leave  
c0104be0:	c3                   	ret    

c0104be1 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c0104be1:	f3 0f 1e fb          	endbr32 
c0104be5:	55                   	push   %ebp
c0104be6:	89 e5                	mov    %esp,%ebp
c0104be8:	81 ec 88 00 00 00    	sub    $0x88,%esp
    int count = 0, total = 0;
c0104bee:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104bf5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c0104bfc:	c7 45 ec 1c cf 11 c0 	movl   $0xc011cf1c,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0104c03:	eb 60                	jmp    c0104c65 <default_check+0x84>
        struct Page *p = le2page(le, page_link);
c0104c05:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104c08:	83 e8 0c             	sub    $0xc,%eax
c0104c0b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        assert(PageProperty(p));
c0104c0e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104c11:	83 c0 04             	add    $0x4,%eax
c0104c14:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0104c1b:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104c1e:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0104c21:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0104c24:	0f a3 10             	bt     %edx,(%eax)
c0104c27:	19 c0                	sbb    %eax,%eax
c0104c29:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c0104c2c:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c0104c30:	0f 95 c0             	setne  %al
c0104c33:	0f b6 c0             	movzbl %al,%eax
c0104c36:	85 c0                	test   %eax,%eax
c0104c38:	75 19                	jne    c0104c53 <default_check+0x72>
c0104c3a:	68 fe 6b 10 c0       	push   $0xc0106bfe
c0104c3f:	68 fe 69 10 c0       	push   $0xc01069fe
c0104c44:	68 01 01 00 00       	push   $0x101
c0104c49:	68 13 6a 10 c0       	push   $0xc0106a13
c0104c4e:	e8 c3 b7 ff ff       	call   c0100416 <__panic>
        count ++, total += p->property;
c0104c53:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0104c57:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104c5a:	8b 50 08             	mov    0x8(%eax),%edx
c0104c5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104c60:	01 d0                	add    %edx,%eax
c0104c62:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104c65:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104c68:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return listelm->next;
c0104c6b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104c6e:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c0104c71:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104c74:	81 7d ec 1c cf 11 c0 	cmpl   $0xc011cf1c,-0x14(%ebp)
c0104c7b:	75 88                	jne    c0104c05 <default_check+0x24>
    }
    assert(total == nr_free_pages());
c0104c7d:	e8 ab e0 ff ff       	call   c0102d2d <nr_free_pages>
c0104c82:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104c85:	39 d0                	cmp    %edx,%eax
c0104c87:	74 19                	je     c0104ca2 <default_check+0xc1>
c0104c89:	68 0e 6c 10 c0       	push   $0xc0106c0e
c0104c8e:	68 fe 69 10 c0       	push   $0xc01069fe
c0104c93:	68 04 01 00 00       	push   $0x104
c0104c98:	68 13 6a 10 c0       	push   $0xc0106a13
c0104c9d:	e8 74 b7 ff ff       	call   c0100416 <__panic>

    basic_check();
c0104ca2:	e8 c2 fa ff ff       	call   c0104769 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c0104ca7:	83 ec 0c             	sub    $0xc,%esp
c0104caa:	6a 05                	push   $0x5
c0104cac:	e8 01 e0 ff ff       	call   c0102cb2 <alloc_pages>
c0104cb1:	83 c4 10             	add    $0x10,%esp
c0104cb4:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(p0 != NULL);
c0104cb7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0104cbb:	75 19                	jne    c0104cd6 <default_check+0xf5>
c0104cbd:	68 27 6c 10 c0       	push   $0xc0106c27
c0104cc2:	68 fe 69 10 c0       	push   $0xc01069fe
c0104cc7:	68 09 01 00 00       	push   $0x109
c0104ccc:	68 13 6a 10 c0       	push   $0xc0106a13
c0104cd1:	e8 40 b7 ff ff       	call   c0100416 <__panic>
    assert(!PageProperty(p0));
c0104cd6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104cd9:	83 c0 04             	add    $0x4,%eax
c0104cdc:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c0104ce3:	89 45 bc             	mov    %eax,-0x44(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104ce6:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0104ce9:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0104cec:	0f a3 10             	bt     %edx,(%eax)
c0104cef:	19 c0                	sbb    %eax,%eax
c0104cf1:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c0104cf4:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c0104cf8:	0f 95 c0             	setne  %al
c0104cfb:	0f b6 c0             	movzbl %al,%eax
c0104cfe:	85 c0                	test   %eax,%eax
c0104d00:	74 19                	je     c0104d1b <default_check+0x13a>
c0104d02:	68 32 6c 10 c0       	push   $0xc0106c32
c0104d07:	68 fe 69 10 c0       	push   $0xc01069fe
c0104d0c:	68 0a 01 00 00       	push   $0x10a
c0104d11:	68 13 6a 10 c0       	push   $0xc0106a13
c0104d16:	e8 fb b6 ff ff       	call   c0100416 <__panic>

    list_entry_t free_list_store = free_list;
c0104d1b:	a1 1c cf 11 c0       	mov    0xc011cf1c,%eax
c0104d20:	8b 15 20 cf 11 c0    	mov    0xc011cf20,%edx
c0104d26:	89 45 80             	mov    %eax,-0x80(%ebp)
c0104d29:	89 55 84             	mov    %edx,-0x7c(%ebp)
c0104d2c:	c7 45 b0 1c cf 11 c0 	movl   $0xc011cf1c,-0x50(%ebp)
    elm->prev = elm->next = elm;
c0104d33:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0104d36:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0104d39:	89 50 04             	mov    %edx,0x4(%eax)
c0104d3c:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0104d3f:	8b 50 04             	mov    0x4(%eax),%edx
c0104d42:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0104d45:	89 10                	mov    %edx,(%eax)
}
c0104d47:	90                   	nop
c0104d48:	c7 45 b4 1c cf 11 c0 	movl   $0xc011cf1c,-0x4c(%ebp)
    return list->next == list;
c0104d4f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0104d52:	8b 40 04             	mov    0x4(%eax),%eax
c0104d55:	39 45 b4             	cmp    %eax,-0x4c(%ebp)
c0104d58:	0f 94 c0             	sete   %al
c0104d5b:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0104d5e:	85 c0                	test   %eax,%eax
c0104d60:	75 19                	jne    c0104d7b <default_check+0x19a>
c0104d62:	68 87 6b 10 c0       	push   $0xc0106b87
c0104d67:	68 fe 69 10 c0       	push   $0xc01069fe
c0104d6c:	68 0e 01 00 00       	push   $0x10e
c0104d71:	68 13 6a 10 c0       	push   $0xc0106a13
c0104d76:	e8 9b b6 ff ff       	call   c0100416 <__panic>
    assert(alloc_page() == NULL);
c0104d7b:	83 ec 0c             	sub    $0xc,%esp
c0104d7e:	6a 01                	push   $0x1
c0104d80:	e8 2d df ff ff       	call   c0102cb2 <alloc_pages>
c0104d85:	83 c4 10             	add    $0x10,%esp
c0104d88:	85 c0                	test   %eax,%eax
c0104d8a:	74 19                	je     c0104da5 <default_check+0x1c4>
c0104d8c:	68 9e 6b 10 c0       	push   $0xc0106b9e
c0104d91:	68 fe 69 10 c0       	push   $0xc01069fe
c0104d96:	68 0f 01 00 00       	push   $0x10f
c0104d9b:	68 13 6a 10 c0       	push   $0xc0106a13
c0104da0:	e8 71 b6 ff ff       	call   c0100416 <__panic>

    unsigned int nr_free_store = nr_free;
c0104da5:	a1 24 cf 11 c0       	mov    0xc011cf24,%eax
c0104daa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    nr_free = 0;
c0104dad:	c7 05 24 cf 11 c0 00 	movl   $0x0,0xc011cf24
c0104db4:	00 00 00 

    free_pages(p0 + 2, 3);
c0104db7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104dba:	83 c0 28             	add    $0x28,%eax
c0104dbd:	83 ec 08             	sub    $0x8,%esp
c0104dc0:	6a 03                	push   $0x3
c0104dc2:	50                   	push   %eax
c0104dc3:	e8 2c df ff ff       	call   c0102cf4 <free_pages>
c0104dc8:	83 c4 10             	add    $0x10,%esp
    assert(alloc_pages(4) == NULL);
c0104dcb:	83 ec 0c             	sub    $0xc,%esp
c0104dce:	6a 04                	push   $0x4
c0104dd0:	e8 dd de ff ff       	call   c0102cb2 <alloc_pages>
c0104dd5:	83 c4 10             	add    $0x10,%esp
c0104dd8:	85 c0                	test   %eax,%eax
c0104dda:	74 19                	je     c0104df5 <default_check+0x214>
c0104ddc:	68 44 6c 10 c0       	push   $0xc0106c44
c0104de1:	68 fe 69 10 c0       	push   $0xc01069fe
c0104de6:	68 15 01 00 00       	push   $0x115
c0104deb:	68 13 6a 10 c0       	push   $0xc0106a13
c0104df0:	e8 21 b6 ff ff       	call   c0100416 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c0104df5:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104df8:	83 c0 28             	add    $0x28,%eax
c0104dfb:	83 c0 04             	add    $0x4,%eax
c0104dfe:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c0104e05:	89 45 a8             	mov    %eax,-0x58(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104e08:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0104e0b:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0104e0e:	0f a3 10             	bt     %edx,(%eax)
c0104e11:	19 c0                	sbb    %eax,%eax
c0104e13:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c0104e16:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c0104e1a:	0f 95 c0             	setne  %al
c0104e1d:	0f b6 c0             	movzbl %al,%eax
c0104e20:	85 c0                	test   %eax,%eax
c0104e22:	74 0e                	je     c0104e32 <default_check+0x251>
c0104e24:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104e27:	83 c0 28             	add    $0x28,%eax
c0104e2a:	8b 40 08             	mov    0x8(%eax),%eax
c0104e2d:	83 f8 03             	cmp    $0x3,%eax
c0104e30:	74 19                	je     c0104e4b <default_check+0x26a>
c0104e32:	68 5c 6c 10 c0       	push   $0xc0106c5c
c0104e37:	68 fe 69 10 c0       	push   $0xc01069fe
c0104e3c:	68 16 01 00 00       	push   $0x116
c0104e41:	68 13 6a 10 c0       	push   $0xc0106a13
c0104e46:	e8 cb b5 ff ff       	call   c0100416 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c0104e4b:	83 ec 0c             	sub    $0xc,%esp
c0104e4e:	6a 03                	push   $0x3
c0104e50:	e8 5d de ff ff       	call   c0102cb2 <alloc_pages>
c0104e55:	83 c4 10             	add    $0x10,%esp
c0104e58:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0104e5b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0104e5f:	75 19                	jne    c0104e7a <default_check+0x299>
c0104e61:	68 88 6c 10 c0       	push   $0xc0106c88
c0104e66:	68 fe 69 10 c0       	push   $0xc01069fe
c0104e6b:	68 17 01 00 00       	push   $0x117
c0104e70:	68 13 6a 10 c0       	push   $0xc0106a13
c0104e75:	e8 9c b5 ff ff       	call   c0100416 <__panic>
    assert(alloc_page() == NULL);
c0104e7a:	83 ec 0c             	sub    $0xc,%esp
c0104e7d:	6a 01                	push   $0x1
c0104e7f:	e8 2e de ff ff       	call   c0102cb2 <alloc_pages>
c0104e84:	83 c4 10             	add    $0x10,%esp
c0104e87:	85 c0                	test   %eax,%eax
c0104e89:	74 19                	je     c0104ea4 <default_check+0x2c3>
c0104e8b:	68 9e 6b 10 c0       	push   $0xc0106b9e
c0104e90:	68 fe 69 10 c0       	push   $0xc01069fe
c0104e95:	68 18 01 00 00       	push   $0x118
c0104e9a:	68 13 6a 10 c0       	push   $0xc0106a13
c0104e9f:	e8 72 b5 ff ff       	call   c0100416 <__panic>
    assert(p0 + 2 == p1);
c0104ea4:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104ea7:	83 c0 28             	add    $0x28,%eax
c0104eaa:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c0104ead:	74 19                	je     c0104ec8 <default_check+0x2e7>
c0104eaf:	68 a6 6c 10 c0       	push   $0xc0106ca6
c0104eb4:	68 fe 69 10 c0       	push   $0xc01069fe
c0104eb9:	68 19 01 00 00       	push   $0x119
c0104ebe:	68 13 6a 10 c0       	push   $0xc0106a13
c0104ec3:	e8 4e b5 ff ff       	call   c0100416 <__panic>

    p2 = p0 + 1;
c0104ec8:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104ecb:	83 c0 14             	add    $0x14,%eax
c0104ece:	89 45 dc             	mov    %eax,-0x24(%ebp)
    free_page(p0);
c0104ed1:	83 ec 08             	sub    $0x8,%esp
c0104ed4:	6a 01                	push   $0x1
c0104ed6:	ff 75 e8             	pushl  -0x18(%ebp)
c0104ed9:	e8 16 de ff ff       	call   c0102cf4 <free_pages>
c0104ede:	83 c4 10             	add    $0x10,%esp
    free_pages(p1, 3);
c0104ee1:	83 ec 08             	sub    $0x8,%esp
c0104ee4:	6a 03                	push   $0x3
c0104ee6:	ff 75 e0             	pushl  -0x20(%ebp)
c0104ee9:	e8 06 de ff ff       	call   c0102cf4 <free_pages>
c0104eee:	83 c4 10             	add    $0x10,%esp
    assert(PageProperty(p0) && p0->property == 1);
c0104ef1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104ef4:	83 c0 04             	add    $0x4,%eax
c0104ef7:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c0104efe:	89 45 9c             	mov    %eax,-0x64(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104f01:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0104f04:	8b 55 a0             	mov    -0x60(%ebp),%edx
c0104f07:	0f a3 10             	bt     %edx,(%eax)
c0104f0a:	19 c0                	sbb    %eax,%eax
c0104f0c:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c0104f0f:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c0104f13:	0f 95 c0             	setne  %al
c0104f16:	0f b6 c0             	movzbl %al,%eax
c0104f19:	85 c0                	test   %eax,%eax
c0104f1b:	74 0b                	je     c0104f28 <default_check+0x347>
c0104f1d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104f20:	8b 40 08             	mov    0x8(%eax),%eax
c0104f23:	83 f8 01             	cmp    $0x1,%eax
c0104f26:	74 19                	je     c0104f41 <default_check+0x360>
c0104f28:	68 b4 6c 10 c0       	push   $0xc0106cb4
c0104f2d:	68 fe 69 10 c0       	push   $0xc01069fe
c0104f32:	68 1e 01 00 00       	push   $0x11e
c0104f37:	68 13 6a 10 c0       	push   $0xc0106a13
c0104f3c:	e8 d5 b4 ff ff       	call   c0100416 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c0104f41:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104f44:	83 c0 04             	add    $0x4,%eax
c0104f47:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c0104f4e:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104f51:	8b 45 90             	mov    -0x70(%ebp),%eax
c0104f54:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0104f57:	0f a3 10             	bt     %edx,(%eax)
c0104f5a:	19 c0                	sbb    %eax,%eax
c0104f5c:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c0104f5f:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c0104f63:	0f 95 c0             	setne  %al
c0104f66:	0f b6 c0             	movzbl %al,%eax
c0104f69:	85 c0                	test   %eax,%eax
c0104f6b:	74 0b                	je     c0104f78 <default_check+0x397>
c0104f6d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104f70:	8b 40 08             	mov    0x8(%eax),%eax
c0104f73:	83 f8 03             	cmp    $0x3,%eax
c0104f76:	74 19                	je     c0104f91 <default_check+0x3b0>
c0104f78:	68 dc 6c 10 c0       	push   $0xc0106cdc
c0104f7d:	68 fe 69 10 c0       	push   $0xc01069fe
c0104f82:	68 1f 01 00 00       	push   $0x11f
c0104f87:	68 13 6a 10 c0       	push   $0xc0106a13
c0104f8c:	e8 85 b4 ff ff       	call   c0100416 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c0104f91:	83 ec 0c             	sub    $0xc,%esp
c0104f94:	6a 01                	push   $0x1
c0104f96:	e8 17 dd ff ff       	call   c0102cb2 <alloc_pages>
c0104f9b:	83 c4 10             	add    $0x10,%esp
c0104f9e:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104fa1:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104fa4:	83 e8 14             	sub    $0x14,%eax
c0104fa7:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0104faa:	74 19                	je     c0104fc5 <default_check+0x3e4>
c0104fac:	68 02 6d 10 c0       	push   $0xc0106d02
c0104fb1:	68 fe 69 10 c0       	push   $0xc01069fe
c0104fb6:	68 21 01 00 00       	push   $0x121
c0104fbb:	68 13 6a 10 c0       	push   $0xc0106a13
c0104fc0:	e8 51 b4 ff ff       	call   c0100416 <__panic>
    free_page(p0);
c0104fc5:	83 ec 08             	sub    $0x8,%esp
c0104fc8:	6a 01                	push   $0x1
c0104fca:	ff 75 e8             	pushl  -0x18(%ebp)
c0104fcd:	e8 22 dd ff ff       	call   c0102cf4 <free_pages>
c0104fd2:	83 c4 10             	add    $0x10,%esp
    assert((p0 = alloc_pages(2)) == p2 + 1);
c0104fd5:	83 ec 0c             	sub    $0xc,%esp
c0104fd8:	6a 02                	push   $0x2
c0104fda:	e8 d3 dc ff ff       	call   c0102cb2 <alloc_pages>
c0104fdf:	83 c4 10             	add    $0x10,%esp
c0104fe2:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104fe5:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104fe8:	83 c0 14             	add    $0x14,%eax
c0104feb:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0104fee:	74 19                	je     c0105009 <default_check+0x428>
c0104ff0:	68 20 6d 10 c0       	push   $0xc0106d20
c0104ff5:	68 fe 69 10 c0       	push   $0xc01069fe
c0104ffa:	68 23 01 00 00       	push   $0x123
c0104fff:	68 13 6a 10 c0       	push   $0xc0106a13
c0105004:	e8 0d b4 ff ff       	call   c0100416 <__panic>

    free_pages(p0, 2);
c0105009:	83 ec 08             	sub    $0x8,%esp
c010500c:	6a 02                	push   $0x2
c010500e:	ff 75 e8             	pushl  -0x18(%ebp)
c0105011:	e8 de dc ff ff       	call   c0102cf4 <free_pages>
c0105016:	83 c4 10             	add    $0x10,%esp
    free_page(p2);
c0105019:	83 ec 08             	sub    $0x8,%esp
c010501c:	6a 01                	push   $0x1
c010501e:	ff 75 dc             	pushl  -0x24(%ebp)
c0105021:	e8 ce dc ff ff       	call   c0102cf4 <free_pages>
c0105026:	83 c4 10             	add    $0x10,%esp

    assert((p0 = alloc_pages(5)) != NULL);
c0105029:	83 ec 0c             	sub    $0xc,%esp
c010502c:	6a 05                	push   $0x5
c010502e:	e8 7f dc ff ff       	call   c0102cb2 <alloc_pages>
c0105033:	83 c4 10             	add    $0x10,%esp
c0105036:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105039:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010503d:	75 19                	jne    c0105058 <default_check+0x477>
c010503f:	68 40 6d 10 c0       	push   $0xc0106d40
c0105044:	68 fe 69 10 c0       	push   $0xc01069fe
c0105049:	68 28 01 00 00       	push   $0x128
c010504e:	68 13 6a 10 c0       	push   $0xc0106a13
c0105053:	e8 be b3 ff ff       	call   c0100416 <__panic>
    assert(alloc_page() == NULL);
c0105058:	83 ec 0c             	sub    $0xc,%esp
c010505b:	6a 01                	push   $0x1
c010505d:	e8 50 dc ff ff       	call   c0102cb2 <alloc_pages>
c0105062:	83 c4 10             	add    $0x10,%esp
c0105065:	85 c0                	test   %eax,%eax
c0105067:	74 19                	je     c0105082 <default_check+0x4a1>
c0105069:	68 9e 6b 10 c0       	push   $0xc0106b9e
c010506e:	68 fe 69 10 c0       	push   $0xc01069fe
c0105073:	68 29 01 00 00       	push   $0x129
c0105078:	68 13 6a 10 c0       	push   $0xc0106a13
c010507d:	e8 94 b3 ff ff       	call   c0100416 <__panic>

    assert(nr_free == 0);
c0105082:	a1 24 cf 11 c0       	mov    0xc011cf24,%eax
c0105087:	85 c0                	test   %eax,%eax
c0105089:	74 19                	je     c01050a4 <default_check+0x4c3>
c010508b:	68 f1 6b 10 c0       	push   $0xc0106bf1
c0105090:	68 fe 69 10 c0       	push   $0xc01069fe
c0105095:	68 2b 01 00 00       	push   $0x12b
c010509a:	68 13 6a 10 c0       	push   $0xc0106a13
c010509f:	e8 72 b3 ff ff       	call   c0100416 <__panic>
    nr_free = nr_free_store;
c01050a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01050a7:	a3 24 cf 11 c0       	mov    %eax,0xc011cf24

    free_list = free_list_store;
c01050ac:	8b 45 80             	mov    -0x80(%ebp),%eax
c01050af:	8b 55 84             	mov    -0x7c(%ebp),%edx
c01050b2:	a3 1c cf 11 c0       	mov    %eax,0xc011cf1c
c01050b7:	89 15 20 cf 11 c0    	mov    %edx,0xc011cf20
    free_pages(p0, 5);
c01050bd:	83 ec 08             	sub    $0x8,%esp
c01050c0:	6a 05                	push   $0x5
c01050c2:	ff 75 e8             	pushl  -0x18(%ebp)
c01050c5:	e8 2a dc ff ff       	call   c0102cf4 <free_pages>
c01050ca:	83 c4 10             	add    $0x10,%esp

    le = &free_list;
c01050cd:	c7 45 ec 1c cf 11 c0 	movl   $0xc011cf1c,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c01050d4:	eb 1d                	jmp    c01050f3 <default_check+0x512>
        struct Page *p = le2page(le, page_link);
c01050d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01050d9:	83 e8 0c             	sub    $0xc,%eax
c01050dc:	89 45 d8             	mov    %eax,-0x28(%ebp)
        count --, total -= p->property;
c01050df:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01050e3:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01050e6:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01050e9:	8b 40 08             	mov    0x8(%eax),%eax
c01050ec:	29 c2                	sub    %eax,%edx
c01050ee:	89 d0                	mov    %edx,%eax
c01050f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01050f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01050f6:	89 45 88             	mov    %eax,-0x78(%ebp)
    return listelm->next;
c01050f9:	8b 45 88             	mov    -0x78(%ebp),%eax
c01050fc:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c01050ff:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105102:	81 7d ec 1c cf 11 c0 	cmpl   $0xc011cf1c,-0x14(%ebp)
c0105109:	75 cb                	jne    c01050d6 <default_check+0x4f5>
    }
    assert(count == 0);
c010510b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010510f:	74 19                	je     c010512a <default_check+0x549>
c0105111:	68 5e 6d 10 c0       	push   $0xc0106d5e
c0105116:	68 fe 69 10 c0       	push   $0xc01069fe
c010511b:	68 36 01 00 00       	push   $0x136
c0105120:	68 13 6a 10 c0       	push   $0xc0106a13
c0105125:	e8 ec b2 ff ff       	call   c0100416 <__panic>
    assert(total == 0);
c010512a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010512e:	74 19                	je     c0105149 <default_check+0x568>
c0105130:	68 69 6d 10 c0       	push   $0xc0106d69
c0105135:	68 fe 69 10 c0       	push   $0xc01069fe
c010513a:	68 37 01 00 00       	push   $0x137
c010513f:	68 13 6a 10 c0       	push   $0xc0106a13
c0105144:	e8 cd b2 ff ff       	call   c0100416 <__panic>
}
c0105149:	90                   	nop
c010514a:	c9                   	leave  
c010514b:	c3                   	ret    

c010514c <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c010514c:	f3 0f 1e fb          	endbr32 
c0105150:	55                   	push   %ebp
c0105151:	89 e5                	mov    %esp,%ebp
c0105153:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105156:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c010515d:	eb 04                	jmp    c0105163 <strlen+0x17>
        cnt ++;
c010515f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    while (*s ++ != '\0') {
c0105163:	8b 45 08             	mov    0x8(%ebp),%eax
c0105166:	8d 50 01             	lea    0x1(%eax),%edx
c0105169:	89 55 08             	mov    %edx,0x8(%ebp)
c010516c:	0f b6 00             	movzbl (%eax),%eax
c010516f:	84 c0                	test   %al,%al
c0105171:	75 ec                	jne    c010515f <strlen+0x13>
    }
    return cnt;
c0105173:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105176:	c9                   	leave  
c0105177:	c3                   	ret    

c0105178 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c0105178:	f3 0f 1e fb          	endbr32 
c010517c:	55                   	push   %ebp
c010517d:	89 e5                	mov    %esp,%ebp
c010517f:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105182:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0105189:	eb 04                	jmp    c010518f <strnlen+0x17>
        cnt ++;
c010518b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c010518f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105192:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105195:	73 10                	jae    c01051a7 <strnlen+0x2f>
c0105197:	8b 45 08             	mov    0x8(%ebp),%eax
c010519a:	8d 50 01             	lea    0x1(%eax),%edx
c010519d:	89 55 08             	mov    %edx,0x8(%ebp)
c01051a0:	0f b6 00             	movzbl (%eax),%eax
c01051a3:	84 c0                	test   %al,%al
c01051a5:	75 e4                	jne    c010518b <strnlen+0x13>
    }
    return cnt;
c01051a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01051aa:	c9                   	leave  
c01051ab:	c3                   	ret    

c01051ac <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c01051ac:	f3 0f 1e fb          	endbr32 
c01051b0:	55                   	push   %ebp
c01051b1:	89 e5                	mov    %esp,%ebp
c01051b3:	57                   	push   %edi
c01051b4:	56                   	push   %esi
c01051b5:	83 ec 20             	sub    $0x20,%esp
c01051b8:	8b 45 08             	mov    0x8(%ebp),%eax
c01051bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01051be:	8b 45 0c             	mov    0xc(%ebp),%eax
c01051c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c01051c4:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01051c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01051ca:	89 d1                	mov    %edx,%ecx
c01051cc:	89 c2                	mov    %eax,%edx
c01051ce:	89 ce                	mov    %ecx,%esi
c01051d0:	89 d7                	mov    %edx,%edi
c01051d2:	ac                   	lods   %ds:(%esi),%al
c01051d3:	aa                   	stos   %al,%es:(%edi)
c01051d4:	84 c0                	test   %al,%al
c01051d6:	75 fa                	jne    c01051d2 <strcpy+0x26>
c01051d8:	89 fa                	mov    %edi,%edx
c01051da:	89 f1                	mov    %esi,%ecx
c01051dc:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c01051df:	89 55 e8             	mov    %edx,-0x18(%ebp)
c01051e2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c01051e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c01051e8:	83 c4 20             	add    $0x20,%esp
c01051eb:	5e                   	pop    %esi
c01051ec:	5f                   	pop    %edi
c01051ed:	5d                   	pop    %ebp
c01051ee:	c3                   	ret    

c01051ef <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c01051ef:	f3 0f 1e fb          	endbr32 
c01051f3:	55                   	push   %ebp
c01051f4:	89 e5                	mov    %esp,%ebp
c01051f6:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c01051f9:	8b 45 08             	mov    0x8(%ebp),%eax
c01051fc:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c01051ff:	eb 21                	jmp    c0105222 <strncpy+0x33>
        if ((*p = *src) != '\0') {
c0105201:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105204:	0f b6 10             	movzbl (%eax),%edx
c0105207:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010520a:	88 10                	mov    %dl,(%eax)
c010520c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010520f:	0f b6 00             	movzbl (%eax),%eax
c0105212:	84 c0                	test   %al,%al
c0105214:	74 04                	je     c010521a <strncpy+0x2b>
            src ++;
c0105216:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
c010521a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c010521e:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    while (len > 0) {
c0105222:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105226:	75 d9                	jne    c0105201 <strncpy+0x12>
    }
    return dst;
c0105228:	8b 45 08             	mov    0x8(%ebp),%eax
}
c010522b:	c9                   	leave  
c010522c:	c3                   	ret    

c010522d <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c010522d:	f3 0f 1e fb          	endbr32 
c0105231:	55                   	push   %ebp
c0105232:	89 e5                	mov    %esp,%ebp
c0105234:	57                   	push   %edi
c0105235:	56                   	push   %esi
c0105236:	83 ec 20             	sub    $0x20,%esp
c0105239:	8b 45 08             	mov    0x8(%ebp),%eax
c010523c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010523f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105242:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
c0105245:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105248:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010524b:	89 d1                	mov    %edx,%ecx
c010524d:	89 c2                	mov    %eax,%edx
c010524f:	89 ce                	mov    %ecx,%esi
c0105251:	89 d7                	mov    %edx,%edi
c0105253:	ac                   	lods   %ds:(%esi),%al
c0105254:	ae                   	scas   %es:(%edi),%al
c0105255:	75 08                	jne    c010525f <strcmp+0x32>
c0105257:	84 c0                	test   %al,%al
c0105259:	75 f8                	jne    c0105253 <strcmp+0x26>
c010525b:	31 c0                	xor    %eax,%eax
c010525d:	eb 04                	jmp    c0105263 <strcmp+0x36>
c010525f:	19 c0                	sbb    %eax,%eax
c0105261:	0c 01                	or     $0x1,%al
c0105263:	89 fa                	mov    %edi,%edx
c0105265:	89 f1                	mov    %esi,%ecx
c0105267:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010526a:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c010526d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
c0105270:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c0105273:	83 c4 20             	add    $0x20,%esp
c0105276:	5e                   	pop    %esi
c0105277:	5f                   	pop    %edi
c0105278:	5d                   	pop    %ebp
c0105279:	c3                   	ret    

c010527a <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c010527a:	f3 0f 1e fb          	endbr32 
c010527e:	55                   	push   %ebp
c010527f:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105281:	eb 0c                	jmp    c010528f <strncmp+0x15>
        n --, s1 ++, s2 ++;
c0105283:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0105287:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c010528b:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c010528f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105293:	74 1a                	je     c01052af <strncmp+0x35>
c0105295:	8b 45 08             	mov    0x8(%ebp),%eax
c0105298:	0f b6 00             	movzbl (%eax),%eax
c010529b:	84 c0                	test   %al,%al
c010529d:	74 10                	je     c01052af <strncmp+0x35>
c010529f:	8b 45 08             	mov    0x8(%ebp),%eax
c01052a2:	0f b6 10             	movzbl (%eax),%edx
c01052a5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01052a8:	0f b6 00             	movzbl (%eax),%eax
c01052ab:	38 c2                	cmp    %al,%dl
c01052ad:	74 d4                	je     c0105283 <strncmp+0x9>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c01052af:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01052b3:	74 18                	je     c01052cd <strncmp+0x53>
c01052b5:	8b 45 08             	mov    0x8(%ebp),%eax
c01052b8:	0f b6 00             	movzbl (%eax),%eax
c01052bb:	0f b6 d0             	movzbl %al,%edx
c01052be:	8b 45 0c             	mov    0xc(%ebp),%eax
c01052c1:	0f b6 00             	movzbl (%eax),%eax
c01052c4:	0f b6 c0             	movzbl %al,%eax
c01052c7:	29 c2                	sub    %eax,%edx
c01052c9:	89 d0                	mov    %edx,%eax
c01052cb:	eb 05                	jmp    c01052d2 <strncmp+0x58>
c01052cd:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01052d2:	5d                   	pop    %ebp
c01052d3:	c3                   	ret    

c01052d4 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c01052d4:	f3 0f 1e fb          	endbr32 
c01052d8:	55                   	push   %ebp
c01052d9:	89 e5                	mov    %esp,%ebp
c01052db:	83 ec 04             	sub    $0x4,%esp
c01052de:	8b 45 0c             	mov    0xc(%ebp),%eax
c01052e1:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c01052e4:	eb 14                	jmp    c01052fa <strchr+0x26>
        if (*s == c) {
c01052e6:	8b 45 08             	mov    0x8(%ebp),%eax
c01052e9:	0f b6 00             	movzbl (%eax),%eax
c01052ec:	38 45 fc             	cmp    %al,-0x4(%ebp)
c01052ef:	75 05                	jne    c01052f6 <strchr+0x22>
            return (char *)s;
c01052f1:	8b 45 08             	mov    0x8(%ebp),%eax
c01052f4:	eb 13                	jmp    c0105309 <strchr+0x35>
        }
        s ++;
c01052f6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s != '\0') {
c01052fa:	8b 45 08             	mov    0x8(%ebp),%eax
c01052fd:	0f b6 00             	movzbl (%eax),%eax
c0105300:	84 c0                	test   %al,%al
c0105302:	75 e2                	jne    c01052e6 <strchr+0x12>
    }
    return NULL;
c0105304:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105309:	c9                   	leave  
c010530a:	c3                   	ret    

c010530b <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c010530b:	f3 0f 1e fb          	endbr32 
c010530f:	55                   	push   %ebp
c0105310:	89 e5                	mov    %esp,%ebp
c0105312:	83 ec 04             	sub    $0x4,%esp
c0105315:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105318:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c010531b:	eb 0f                	jmp    c010532c <strfind+0x21>
        if (*s == c) {
c010531d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105320:	0f b6 00             	movzbl (%eax),%eax
c0105323:	38 45 fc             	cmp    %al,-0x4(%ebp)
c0105326:	74 10                	je     c0105338 <strfind+0x2d>
            break;
        }
        s ++;
c0105328:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s != '\0') {
c010532c:	8b 45 08             	mov    0x8(%ebp),%eax
c010532f:	0f b6 00             	movzbl (%eax),%eax
c0105332:	84 c0                	test   %al,%al
c0105334:	75 e7                	jne    c010531d <strfind+0x12>
c0105336:	eb 01                	jmp    c0105339 <strfind+0x2e>
            break;
c0105338:	90                   	nop
    }
    return (char *)s;
c0105339:	8b 45 08             	mov    0x8(%ebp),%eax
}
c010533c:	c9                   	leave  
c010533d:	c3                   	ret    

c010533e <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c010533e:	f3 0f 1e fb          	endbr32 
c0105342:	55                   	push   %ebp
c0105343:	89 e5                	mov    %esp,%ebp
c0105345:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c0105348:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c010534f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0105356:	eb 04                	jmp    c010535c <strtol+0x1e>
        s ++;
c0105358:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
c010535c:	8b 45 08             	mov    0x8(%ebp),%eax
c010535f:	0f b6 00             	movzbl (%eax),%eax
c0105362:	3c 20                	cmp    $0x20,%al
c0105364:	74 f2                	je     c0105358 <strtol+0x1a>
c0105366:	8b 45 08             	mov    0x8(%ebp),%eax
c0105369:	0f b6 00             	movzbl (%eax),%eax
c010536c:	3c 09                	cmp    $0x9,%al
c010536e:	74 e8                	je     c0105358 <strtol+0x1a>
    }

    // plus/minus sign
    if (*s == '+') {
c0105370:	8b 45 08             	mov    0x8(%ebp),%eax
c0105373:	0f b6 00             	movzbl (%eax),%eax
c0105376:	3c 2b                	cmp    $0x2b,%al
c0105378:	75 06                	jne    c0105380 <strtol+0x42>
        s ++;
c010537a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c010537e:	eb 15                	jmp    c0105395 <strtol+0x57>
    }
    else if (*s == '-') {
c0105380:	8b 45 08             	mov    0x8(%ebp),%eax
c0105383:	0f b6 00             	movzbl (%eax),%eax
c0105386:	3c 2d                	cmp    $0x2d,%al
c0105388:	75 0b                	jne    c0105395 <strtol+0x57>
        s ++, neg = 1;
c010538a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c010538e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c0105395:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105399:	74 06                	je     c01053a1 <strtol+0x63>
c010539b:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c010539f:	75 24                	jne    c01053c5 <strtol+0x87>
c01053a1:	8b 45 08             	mov    0x8(%ebp),%eax
c01053a4:	0f b6 00             	movzbl (%eax),%eax
c01053a7:	3c 30                	cmp    $0x30,%al
c01053a9:	75 1a                	jne    c01053c5 <strtol+0x87>
c01053ab:	8b 45 08             	mov    0x8(%ebp),%eax
c01053ae:	83 c0 01             	add    $0x1,%eax
c01053b1:	0f b6 00             	movzbl (%eax),%eax
c01053b4:	3c 78                	cmp    $0x78,%al
c01053b6:	75 0d                	jne    c01053c5 <strtol+0x87>
        s += 2, base = 16;
c01053b8:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c01053bc:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c01053c3:	eb 2a                	jmp    c01053ef <strtol+0xb1>
    }
    else if (base == 0 && s[0] == '0') {
c01053c5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01053c9:	75 17                	jne    c01053e2 <strtol+0xa4>
c01053cb:	8b 45 08             	mov    0x8(%ebp),%eax
c01053ce:	0f b6 00             	movzbl (%eax),%eax
c01053d1:	3c 30                	cmp    $0x30,%al
c01053d3:	75 0d                	jne    c01053e2 <strtol+0xa4>
        s ++, base = 8;
c01053d5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c01053d9:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c01053e0:	eb 0d                	jmp    c01053ef <strtol+0xb1>
    }
    else if (base == 0) {
c01053e2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01053e6:	75 07                	jne    c01053ef <strtol+0xb1>
        base = 10;
c01053e8:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c01053ef:	8b 45 08             	mov    0x8(%ebp),%eax
c01053f2:	0f b6 00             	movzbl (%eax),%eax
c01053f5:	3c 2f                	cmp    $0x2f,%al
c01053f7:	7e 1b                	jle    c0105414 <strtol+0xd6>
c01053f9:	8b 45 08             	mov    0x8(%ebp),%eax
c01053fc:	0f b6 00             	movzbl (%eax),%eax
c01053ff:	3c 39                	cmp    $0x39,%al
c0105401:	7f 11                	jg     c0105414 <strtol+0xd6>
            dig = *s - '0';
c0105403:	8b 45 08             	mov    0x8(%ebp),%eax
c0105406:	0f b6 00             	movzbl (%eax),%eax
c0105409:	0f be c0             	movsbl %al,%eax
c010540c:	83 e8 30             	sub    $0x30,%eax
c010540f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105412:	eb 48                	jmp    c010545c <strtol+0x11e>
        }
        else if (*s >= 'a' && *s <= 'z') {
c0105414:	8b 45 08             	mov    0x8(%ebp),%eax
c0105417:	0f b6 00             	movzbl (%eax),%eax
c010541a:	3c 60                	cmp    $0x60,%al
c010541c:	7e 1b                	jle    c0105439 <strtol+0xfb>
c010541e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105421:	0f b6 00             	movzbl (%eax),%eax
c0105424:	3c 7a                	cmp    $0x7a,%al
c0105426:	7f 11                	jg     c0105439 <strtol+0xfb>
            dig = *s - 'a' + 10;
c0105428:	8b 45 08             	mov    0x8(%ebp),%eax
c010542b:	0f b6 00             	movzbl (%eax),%eax
c010542e:	0f be c0             	movsbl %al,%eax
c0105431:	83 e8 57             	sub    $0x57,%eax
c0105434:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105437:	eb 23                	jmp    c010545c <strtol+0x11e>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c0105439:	8b 45 08             	mov    0x8(%ebp),%eax
c010543c:	0f b6 00             	movzbl (%eax),%eax
c010543f:	3c 40                	cmp    $0x40,%al
c0105441:	7e 3c                	jle    c010547f <strtol+0x141>
c0105443:	8b 45 08             	mov    0x8(%ebp),%eax
c0105446:	0f b6 00             	movzbl (%eax),%eax
c0105449:	3c 5a                	cmp    $0x5a,%al
c010544b:	7f 32                	jg     c010547f <strtol+0x141>
            dig = *s - 'A' + 10;
c010544d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105450:	0f b6 00             	movzbl (%eax),%eax
c0105453:	0f be c0             	movsbl %al,%eax
c0105456:	83 e8 37             	sub    $0x37,%eax
c0105459:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c010545c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010545f:	3b 45 10             	cmp    0x10(%ebp),%eax
c0105462:	7d 1a                	jge    c010547e <strtol+0x140>
            break;
        }
        s ++, val = (val * base) + dig;
c0105464:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105468:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010546b:	0f af 45 10          	imul   0x10(%ebp),%eax
c010546f:	89 c2                	mov    %eax,%edx
c0105471:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105474:	01 d0                	add    %edx,%eax
c0105476:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
c0105479:	e9 71 ff ff ff       	jmp    c01053ef <strtol+0xb1>
            break;
c010547e:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
c010547f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105483:	74 08                	je     c010548d <strtol+0x14f>
        *endptr = (char *) s;
c0105485:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105488:	8b 55 08             	mov    0x8(%ebp),%edx
c010548b:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c010548d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0105491:	74 07                	je     c010549a <strtol+0x15c>
c0105493:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105496:	f7 d8                	neg    %eax
c0105498:	eb 03                	jmp    c010549d <strtol+0x15f>
c010549a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c010549d:	c9                   	leave  
c010549e:	c3                   	ret    

c010549f <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c010549f:	f3 0f 1e fb          	endbr32 
c01054a3:	55                   	push   %ebp
c01054a4:	89 e5                	mov    %esp,%ebp
c01054a6:	57                   	push   %edi
c01054a7:	83 ec 24             	sub    $0x24,%esp
c01054aa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01054ad:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c01054b0:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
c01054b4:	8b 55 08             	mov    0x8(%ebp),%edx
c01054b7:	89 55 f8             	mov    %edx,-0x8(%ebp)
c01054ba:	88 45 f7             	mov    %al,-0x9(%ebp)
c01054bd:	8b 45 10             	mov    0x10(%ebp),%eax
c01054c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c01054c3:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c01054c6:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c01054ca:	8b 55 f8             	mov    -0x8(%ebp),%edx
c01054cd:	89 d7                	mov    %edx,%edi
c01054cf:	f3 aa                	rep stos %al,%es:(%edi)
c01054d1:	89 fa                	mov    %edi,%edx
c01054d3:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c01054d6:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c01054d9:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c01054dc:	83 c4 24             	add    $0x24,%esp
c01054df:	5f                   	pop    %edi
c01054e0:	5d                   	pop    %ebp
c01054e1:	c3                   	ret    

c01054e2 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c01054e2:	f3 0f 1e fb          	endbr32 
c01054e6:	55                   	push   %ebp
c01054e7:	89 e5                	mov    %esp,%ebp
c01054e9:	57                   	push   %edi
c01054ea:	56                   	push   %esi
c01054eb:	53                   	push   %ebx
c01054ec:	83 ec 30             	sub    $0x30,%esp
c01054ef:	8b 45 08             	mov    0x8(%ebp),%eax
c01054f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01054f5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01054f8:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01054fb:	8b 45 10             	mov    0x10(%ebp),%eax
c01054fe:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c0105501:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105504:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0105507:	73 42                	jae    c010554b <memmove+0x69>
c0105509:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010550c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010550f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105512:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105515:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105518:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c010551b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010551e:	c1 e8 02             	shr    $0x2,%eax
c0105521:	89 c1                	mov    %eax,%ecx
    asm volatile (
c0105523:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105526:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105529:	89 d7                	mov    %edx,%edi
c010552b:	89 c6                	mov    %eax,%esi
c010552d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c010552f:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0105532:	83 e1 03             	and    $0x3,%ecx
c0105535:	74 02                	je     c0105539 <memmove+0x57>
c0105537:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105539:	89 f0                	mov    %esi,%eax
c010553b:	89 fa                	mov    %edi,%edx
c010553d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c0105540:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0105543:	89 45 d0             	mov    %eax,-0x30(%ebp)
        : "memory");
    return dst;
c0105546:	8b 45 e4             	mov    -0x1c(%ebp),%eax
        return __memcpy(dst, src, n);
c0105549:	eb 36                	jmp    c0105581 <memmove+0x9f>
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c010554b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010554e:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105551:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105554:	01 c2                	add    %eax,%edx
c0105556:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105559:	8d 48 ff             	lea    -0x1(%eax),%ecx
c010555c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010555f:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
c0105562:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105565:	89 c1                	mov    %eax,%ecx
c0105567:	89 d8                	mov    %ebx,%eax
c0105569:	89 d6                	mov    %edx,%esi
c010556b:	89 c7                	mov    %eax,%edi
c010556d:	fd                   	std    
c010556e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105570:	fc                   	cld    
c0105571:	89 f8                	mov    %edi,%eax
c0105573:	89 f2                	mov    %esi,%edx
c0105575:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c0105578:	89 55 c8             	mov    %edx,-0x38(%ebp)
c010557b:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
c010557e:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c0105581:	83 c4 30             	add    $0x30,%esp
c0105584:	5b                   	pop    %ebx
c0105585:	5e                   	pop    %esi
c0105586:	5f                   	pop    %edi
c0105587:	5d                   	pop    %ebp
c0105588:	c3                   	ret    

c0105589 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c0105589:	f3 0f 1e fb          	endbr32 
c010558d:	55                   	push   %ebp
c010558e:	89 e5                	mov    %esp,%ebp
c0105590:	57                   	push   %edi
c0105591:	56                   	push   %esi
c0105592:	83 ec 20             	sub    $0x20,%esp
c0105595:	8b 45 08             	mov    0x8(%ebp),%eax
c0105598:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010559b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010559e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01055a1:	8b 45 10             	mov    0x10(%ebp),%eax
c01055a4:	89 45 ec             	mov    %eax,-0x14(%ebp)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c01055a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01055aa:	c1 e8 02             	shr    $0x2,%eax
c01055ad:	89 c1                	mov    %eax,%ecx
    asm volatile (
c01055af:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01055b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01055b5:	89 d7                	mov    %edx,%edi
c01055b7:	89 c6                	mov    %eax,%esi
c01055b9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c01055bb:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c01055be:	83 e1 03             	and    $0x3,%ecx
c01055c1:	74 02                	je     c01055c5 <memcpy+0x3c>
c01055c3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c01055c5:	89 f0                	mov    %esi,%eax
c01055c7:	89 fa                	mov    %edi,%edx
c01055c9:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c01055cc:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c01055cf:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
c01055d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c01055d5:	83 c4 20             	add    $0x20,%esp
c01055d8:	5e                   	pop    %esi
c01055d9:	5f                   	pop    %edi
c01055da:	5d                   	pop    %ebp
c01055db:	c3                   	ret    

c01055dc <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c01055dc:	f3 0f 1e fb          	endbr32 
c01055e0:	55                   	push   %ebp
c01055e1:	89 e5                	mov    %esp,%ebp
c01055e3:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c01055e6:	8b 45 08             	mov    0x8(%ebp),%eax
c01055e9:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c01055ec:	8b 45 0c             	mov    0xc(%ebp),%eax
c01055ef:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c01055f2:	eb 30                	jmp    c0105624 <memcmp+0x48>
        if (*s1 != *s2) {
c01055f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01055f7:	0f b6 10             	movzbl (%eax),%edx
c01055fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01055fd:	0f b6 00             	movzbl (%eax),%eax
c0105600:	38 c2                	cmp    %al,%dl
c0105602:	74 18                	je     c010561c <memcmp+0x40>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105604:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105607:	0f b6 00             	movzbl (%eax),%eax
c010560a:	0f b6 d0             	movzbl %al,%edx
c010560d:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105610:	0f b6 00             	movzbl (%eax),%eax
c0105613:	0f b6 c0             	movzbl %al,%eax
c0105616:	29 c2                	sub    %eax,%edx
c0105618:	89 d0                	mov    %edx,%eax
c010561a:	eb 1a                	jmp    c0105636 <memcmp+0x5a>
        }
        s1 ++, s2 ++;
c010561c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0105620:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
    while (n -- > 0) {
c0105624:	8b 45 10             	mov    0x10(%ebp),%eax
c0105627:	8d 50 ff             	lea    -0x1(%eax),%edx
c010562a:	89 55 10             	mov    %edx,0x10(%ebp)
c010562d:	85 c0                	test   %eax,%eax
c010562f:	75 c3                	jne    c01055f4 <memcmp+0x18>
    }
    return 0;
c0105631:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105636:	c9                   	leave  
c0105637:	c3                   	ret    

c0105638 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c0105638:	f3 0f 1e fb          	endbr32 
c010563c:	55                   	push   %ebp
c010563d:	89 e5                	mov    %esp,%ebp
c010563f:	83 ec 38             	sub    $0x38,%esp
c0105642:	8b 45 10             	mov    0x10(%ebp),%eax
c0105645:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0105648:	8b 45 14             	mov    0x14(%ebp),%eax
c010564b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c010564e:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0105651:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105654:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105657:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c010565a:	8b 45 18             	mov    0x18(%ebp),%eax
c010565d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105660:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105663:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105666:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105669:	89 55 f0             	mov    %edx,-0x10(%ebp)
c010566c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010566f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105672:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105676:	74 1c                	je     c0105694 <printnum+0x5c>
c0105678:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010567b:	ba 00 00 00 00       	mov    $0x0,%edx
c0105680:	f7 75 e4             	divl   -0x1c(%ebp)
c0105683:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0105686:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105689:	ba 00 00 00 00       	mov    $0x0,%edx
c010568e:	f7 75 e4             	divl   -0x1c(%ebp)
c0105691:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105694:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105697:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010569a:	f7 75 e4             	divl   -0x1c(%ebp)
c010569d:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01056a0:	89 55 dc             	mov    %edx,-0x24(%ebp)
c01056a3:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01056a6:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01056a9:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01056ac:	89 55 ec             	mov    %edx,-0x14(%ebp)
c01056af:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01056b2:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c01056b5:	8b 45 18             	mov    0x18(%ebp),%eax
c01056b8:	ba 00 00 00 00       	mov    $0x0,%edx
c01056bd:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c01056c0:	39 45 d0             	cmp    %eax,-0x30(%ebp)
c01056c3:	19 d1                	sbb    %edx,%ecx
c01056c5:	72 37                	jb     c01056fe <printnum+0xc6>
        printnum(putch, putdat, result, base, width - 1, padc);
c01056c7:	8b 45 1c             	mov    0x1c(%ebp),%eax
c01056ca:	83 e8 01             	sub    $0x1,%eax
c01056cd:	83 ec 04             	sub    $0x4,%esp
c01056d0:	ff 75 20             	pushl  0x20(%ebp)
c01056d3:	50                   	push   %eax
c01056d4:	ff 75 18             	pushl  0x18(%ebp)
c01056d7:	ff 75 ec             	pushl  -0x14(%ebp)
c01056da:	ff 75 e8             	pushl  -0x18(%ebp)
c01056dd:	ff 75 0c             	pushl  0xc(%ebp)
c01056e0:	ff 75 08             	pushl  0x8(%ebp)
c01056e3:	e8 50 ff ff ff       	call   c0105638 <printnum>
c01056e8:	83 c4 20             	add    $0x20,%esp
c01056eb:	eb 1b                	jmp    c0105708 <printnum+0xd0>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c01056ed:	83 ec 08             	sub    $0x8,%esp
c01056f0:	ff 75 0c             	pushl  0xc(%ebp)
c01056f3:	ff 75 20             	pushl  0x20(%ebp)
c01056f6:	8b 45 08             	mov    0x8(%ebp),%eax
c01056f9:	ff d0                	call   *%eax
c01056fb:	83 c4 10             	add    $0x10,%esp
        while (-- width > 0)
c01056fe:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
c0105702:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0105706:	7f e5                	jg     c01056ed <printnum+0xb5>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c0105708:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010570b:	05 24 6e 10 c0       	add    $0xc0106e24,%eax
c0105710:	0f b6 00             	movzbl (%eax),%eax
c0105713:	0f be c0             	movsbl %al,%eax
c0105716:	83 ec 08             	sub    $0x8,%esp
c0105719:	ff 75 0c             	pushl  0xc(%ebp)
c010571c:	50                   	push   %eax
c010571d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105720:	ff d0                	call   *%eax
c0105722:	83 c4 10             	add    $0x10,%esp
}
c0105725:	90                   	nop
c0105726:	c9                   	leave  
c0105727:	c3                   	ret    

c0105728 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c0105728:	f3 0f 1e fb          	endbr32 
c010572c:	55                   	push   %ebp
c010572d:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c010572f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0105733:	7e 14                	jle    c0105749 <getuint+0x21>
        return va_arg(*ap, unsigned long long);
c0105735:	8b 45 08             	mov    0x8(%ebp),%eax
c0105738:	8b 00                	mov    (%eax),%eax
c010573a:	8d 48 08             	lea    0x8(%eax),%ecx
c010573d:	8b 55 08             	mov    0x8(%ebp),%edx
c0105740:	89 0a                	mov    %ecx,(%edx)
c0105742:	8b 50 04             	mov    0x4(%eax),%edx
c0105745:	8b 00                	mov    (%eax),%eax
c0105747:	eb 30                	jmp    c0105779 <getuint+0x51>
    }
    else if (lflag) {
c0105749:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010574d:	74 16                	je     c0105765 <getuint+0x3d>
        return va_arg(*ap, unsigned long);
c010574f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105752:	8b 00                	mov    (%eax),%eax
c0105754:	8d 48 04             	lea    0x4(%eax),%ecx
c0105757:	8b 55 08             	mov    0x8(%ebp),%edx
c010575a:	89 0a                	mov    %ecx,(%edx)
c010575c:	8b 00                	mov    (%eax),%eax
c010575e:	ba 00 00 00 00       	mov    $0x0,%edx
c0105763:	eb 14                	jmp    c0105779 <getuint+0x51>
    }
    else {
        return va_arg(*ap, unsigned int);
c0105765:	8b 45 08             	mov    0x8(%ebp),%eax
c0105768:	8b 00                	mov    (%eax),%eax
c010576a:	8d 48 04             	lea    0x4(%eax),%ecx
c010576d:	8b 55 08             	mov    0x8(%ebp),%edx
c0105770:	89 0a                	mov    %ecx,(%edx)
c0105772:	8b 00                	mov    (%eax),%eax
c0105774:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c0105779:	5d                   	pop    %ebp
c010577a:	c3                   	ret    

c010577b <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c010577b:	f3 0f 1e fb          	endbr32 
c010577f:	55                   	push   %ebp
c0105780:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0105782:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0105786:	7e 14                	jle    c010579c <getint+0x21>
        return va_arg(*ap, long long);
c0105788:	8b 45 08             	mov    0x8(%ebp),%eax
c010578b:	8b 00                	mov    (%eax),%eax
c010578d:	8d 48 08             	lea    0x8(%eax),%ecx
c0105790:	8b 55 08             	mov    0x8(%ebp),%edx
c0105793:	89 0a                	mov    %ecx,(%edx)
c0105795:	8b 50 04             	mov    0x4(%eax),%edx
c0105798:	8b 00                	mov    (%eax),%eax
c010579a:	eb 28                	jmp    c01057c4 <getint+0x49>
    }
    else if (lflag) {
c010579c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01057a0:	74 12                	je     c01057b4 <getint+0x39>
        return va_arg(*ap, long);
c01057a2:	8b 45 08             	mov    0x8(%ebp),%eax
c01057a5:	8b 00                	mov    (%eax),%eax
c01057a7:	8d 48 04             	lea    0x4(%eax),%ecx
c01057aa:	8b 55 08             	mov    0x8(%ebp),%edx
c01057ad:	89 0a                	mov    %ecx,(%edx)
c01057af:	8b 00                	mov    (%eax),%eax
c01057b1:	99                   	cltd   
c01057b2:	eb 10                	jmp    c01057c4 <getint+0x49>
    }
    else {
        return va_arg(*ap, int);
c01057b4:	8b 45 08             	mov    0x8(%ebp),%eax
c01057b7:	8b 00                	mov    (%eax),%eax
c01057b9:	8d 48 04             	lea    0x4(%eax),%ecx
c01057bc:	8b 55 08             	mov    0x8(%ebp),%edx
c01057bf:	89 0a                	mov    %ecx,(%edx)
c01057c1:	8b 00                	mov    (%eax),%eax
c01057c3:	99                   	cltd   
    }
}
c01057c4:	5d                   	pop    %ebp
c01057c5:	c3                   	ret    

c01057c6 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c01057c6:	f3 0f 1e fb          	endbr32 
c01057ca:	55                   	push   %ebp
c01057cb:	89 e5                	mov    %esp,%ebp
c01057cd:	83 ec 18             	sub    $0x18,%esp
    va_list ap;

    va_start(ap, fmt);
c01057d0:	8d 45 14             	lea    0x14(%ebp),%eax
c01057d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c01057d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01057d9:	50                   	push   %eax
c01057da:	ff 75 10             	pushl  0x10(%ebp)
c01057dd:	ff 75 0c             	pushl  0xc(%ebp)
c01057e0:	ff 75 08             	pushl  0x8(%ebp)
c01057e3:	e8 06 00 00 00       	call   c01057ee <vprintfmt>
c01057e8:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
c01057eb:	90                   	nop
c01057ec:	c9                   	leave  
c01057ed:	c3                   	ret    

c01057ee <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c01057ee:	f3 0f 1e fb          	endbr32 
c01057f2:	55                   	push   %ebp
c01057f3:	89 e5                	mov    %esp,%ebp
c01057f5:	56                   	push   %esi
c01057f6:	53                   	push   %ebx
c01057f7:	83 ec 20             	sub    $0x20,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c01057fa:	eb 17                	jmp    c0105813 <vprintfmt+0x25>
            if (ch == '\0') {
c01057fc:	85 db                	test   %ebx,%ebx
c01057fe:	0f 84 8f 03 00 00    	je     c0105b93 <vprintfmt+0x3a5>
                return;
            }
            putch(ch, putdat);
c0105804:	83 ec 08             	sub    $0x8,%esp
c0105807:	ff 75 0c             	pushl  0xc(%ebp)
c010580a:	53                   	push   %ebx
c010580b:	8b 45 08             	mov    0x8(%ebp),%eax
c010580e:	ff d0                	call   *%eax
c0105810:	83 c4 10             	add    $0x10,%esp
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0105813:	8b 45 10             	mov    0x10(%ebp),%eax
c0105816:	8d 50 01             	lea    0x1(%eax),%edx
c0105819:	89 55 10             	mov    %edx,0x10(%ebp)
c010581c:	0f b6 00             	movzbl (%eax),%eax
c010581f:	0f b6 d8             	movzbl %al,%ebx
c0105822:	83 fb 25             	cmp    $0x25,%ebx
c0105825:	75 d5                	jne    c01057fc <vprintfmt+0xe>
        }

        // Process a %-escape sequence
        char padc = ' ';
c0105827:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c010582b:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c0105832:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105835:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c0105838:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c010583f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105842:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c0105845:	8b 45 10             	mov    0x10(%ebp),%eax
c0105848:	8d 50 01             	lea    0x1(%eax),%edx
c010584b:	89 55 10             	mov    %edx,0x10(%ebp)
c010584e:	0f b6 00             	movzbl (%eax),%eax
c0105851:	0f b6 d8             	movzbl %al,%ebx
c0105854:	8d 43 dd             	lea    -0x23(%ebx),%eax
c0105857:	83 f8 55             	cmp    $0x55,%eax
c010585a:	0f 87 06 03 00 00    	ja     c0105b66 <vprintfmt+0x378>
c0105860:	8b 04 85 48 6e 10 c0 	mov    -0x3fef91b8(,%eax,4),%eax
c0105867:	3e ff e0             	notrack jmp *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c010586a:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c010586e:	eb d5                	jmp    c0105845 <vprintfmt+0x57>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c0105870:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c0105874:	eb cf                	jmp    c0105845 <vprintfmt+0x57>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c0105876:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c010587d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105880:	89 d0                	mov    %edx,%eax
c0105882:	c1 e0 02             	shl    $0x2,%eax
c0105885:	01 d0                	add    %edx,%eax
c0105887:	01 c0                	add    %eax,%eax
c0105889:	01 d8                	add    %ebx,%eax
c010588b:	83 e8 30             	sub    $0x30,%eax
c010588e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c0105891:	8b 45 10             	mov    0x10(%ebp),%eax
c0105894:	0f b6 00             	movzbl (%eax),%eax
c0105897:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c010589a:	83 fb 2f             	cmp    $0x2f,%ebx
c010589d:	7e 39                	jle    c01058d8 <vprintfmt+0xea>
c010589f:	83 fb 39             	cmp    $0x39,%ebx
c01058a2:	7f 34                	jg     c01058d8 <vprintfmt+0xea>
            for (precision = 0; ; ++ fmt) {
c01058a4:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
c01058a8:	eb d3                	jmp    c010587d <vprintfmt+0x8f>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
c01058aa:	8b 45 14             	mov    0x14(%ebp),%eax
c01058ad:	8d 50 04             	lea    0x4(%eax),%edx
c01058b0:	89 55 14             	mov    %edx,0x14(%ebp)
c01058b3:	8b 00                	mov    (%eax),%eax
c01058b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c01058b8:	eb 1f                	jmp    c01058d9 <vprintfmt+0xeb>

        case '.':
            if (width < 0)
c01058ba:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01058be:	79 85                	jns    c0105845 <vprintfmt+0x57>
                width = 0;
c01058c0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c01058c7:	e9 79 ff ff ff       	jmp    c0105845 <vprintfmt+0x57>

        case '#':
            altflag = 1;
c01058cc:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c01058d3:	e9 6d ff ff ff       	jmp    c0105845 <vprintfmt+0x57>
            goto process_precision;
c01058d8:	90                   	nop

        process_precision:
            if (width < 0)
c01058d9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01058dd:	0f 89 62 ff ff ff    	jns    c0105845 <vprintfmt+0x57>
                width = precision, precision = -1;
c01058e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01058e6:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01058e9:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c01058f0:	e9 50 ff ff ff       	jmp    c0105845 <vprintfmt+0x57>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c01058f5:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
c01058f9:	e9 47 ff ff ff       	jmp    c0105845 <vprintfmt+0x57>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c01058fe:	8b 45 14             	mov    0x14(%ebp),%eax
c0105901:	8d 50 04             	lea    0x4(%eax),%edx
c0105904:	89 55 14             	mov    %edx,0x14(%ebp)
c0105907:	8b 00                	mov    (%eax),%eax
c0105909:	83 ec 08             	sub    $0x8,%esp
c010590c:	ff 75 0c             	pushl  0xc(%ebp)
c010590f:	50                   	push   %eax
c0105910:	8b 45 08             	mov    0x8(%ebp),%eax
c0105913:	ff d0                	call   *%eax
c0105915:	83 c4 10             	add    $0x10,%esp
            break;
c0105918:	e9 71 02 00 00       	jmp    c0105b8e <vprintfmt+0x3a0>

        // error message
        case 'e':
            err = va_arg(ap, int);
c010591d:	8b 45 14             	mov    0x14(%ebp),%eax
c0105920:	8d 50 04             	lea    0x4(%eax),%edx
c0105923:	89 55 14             	mov    %edx,0x14(%ebp)
c0105926:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c0105928:	85 db                	test   %ebx,%ebx
c010592a:	79 02                	jns    c010592e <vprintfmt+0x140>
                err = -err;
c010592c:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c010592e:	83 fb 06             	cmp    $0x6,%ebx
c0105931:	7f 0b                	jg     c010593e <vprintfmt+0x150>
c0105933:	8b 34 9d 08 6e 10 c0 	mov    -0x3fef91f8(,%ebx,4),%esi
c010593a:	85 f6                	test   %esi,%esi
c010593c:	75 19                	jne    c0105957 <vprintfmt+0x169>
                printfmt(putch, putdat, "error %d", err);
c010593e:	53                   	push   %ebx
c010593f:	68 35 6e 10 c0       	push   $0xc0106e35
c0105944:	ff 75 0c             	pushl  0xc(%ebp)
c0105947:	ff 75 08             	pushl  0x8(%ebp)
c010594a:	e8 77 fe ff ff       	call   c01057c6 <printfmt>
c010594f:	83 c4 10             	add    $0x10,%esp
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c0105952:	e9 37 02 00 00       	jmp    c0105b8e <vprintfmt+0x3a0>
                printfmt(putch, putdat, "%s", p);
c0105957:	56                   	push   %esi
c0105958:	68 3e 6e 10 c0       	push   $0xc0106e3e
c010595d:	ff 75 0c             	pushl  0xc(%ebp)
c0105960:	ff 75 08             	pushl  0x8(%ebp)
c0105963:	e8 5e fe ff ff       	call   c01057c6 <printfmt>
c0105968:	83 c4 10             	add    $0x10,%esp
            break;
c010596b:	e9 1e 02 00 00       	jmp    c0105b8e <vprintfmt+0x3a0>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c0105970:	8b 45 14             	mov    0x14(%ebp),%eax
c0105973:	8d 50 04             	lea    0x4(%eax),%edx
c0105976:	89 55 14             	mov    %edx,0x14(%ebp)
c0105979:	8b 30                	mov    (%eax),%esi
c010597b:	85 f6                	test   %esi,%esi
c010597d:	75 05                	jne    c0105984 <vprintfmt+0x196>
                p = "(null)";
c010597f:	be 41 6e 10 c0       	mov    $0xc0106e41,%esi
            }
            if (width > 0 && padc != '-') {
c0105984:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105988:	7e 76                	jle    c0105a00 <vprintfmt+0x212>
c010598a:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c010598e:	74 70                	je     c0105a00 <vprintfmt+0x212>
                for (width -= strnlen(p, precision); width > 0; width --) {
c0105990:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105993:	83 ec 08             	sub    $0x8,%esp
c0105996:	50                   	push   %eax
c0105997:	56                   	push   %esi
c0105998:	e8 db f7 ff ff       	call   c0105178 <strnlen>
c010599d:	83 c4 10             	add    $0x10,%esp
c01059a0:	8b 55 e8             	mov    -0x18(%ebp),%edx
c01059a3:	29 c2                	sub    %eax,%edx
c01059a5:	89 d0                	mov    %edx,%eax
c01059a7:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01059aa:	eb 17                	jmp    c01059c3 <vprintfmt+0x1d5>
                    putch(padc, putdat);
c01059ac:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c01059b0:	83 ec 08             	sub    $0x8,%esp
c01059b3:	ff 75 0c             	pushl  0xc(%ebp)
c01059b6:	50                   	push   %eax
c01059b7:	8b 45 08             	mov    0x8(%ebp),%eax
c01059ba:	ff d0                	call   *%eax
c01059bc:	83 c4 10             	add    $0x10,%esp
                for (width -= strnlen(p, precision); width > 0; width --) {
c01059bf:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c01059c3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01059c7:	7f e3                	jg     c01059ac <vprintfmt+0x1be>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c01059c9:	eb 35                	jmp    c0105a00 <vprintfmt+0x212>
                if (altflag && (ch < ' ' || ch > '~')) {
c01059cb:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c01059cf:	74 1c                	je     c01059ed <vprintfmt+0x1ff>
c01059d1:	83 fb 1f             	cmp    $0x1f,%ebx
c01059d4:	7e 05                	jle    c01059db <vprintfmt+0x1ed>
c01059d6:	83 fb 7e             	cmp    $0x7e,%ebx
c01059d9:	7e 12                	jle    c01059ed <vprintfmt+0x1ff>
                    putch('?', putdat);
c01059db:	83 ec 08             	sub    $0x8,%esp
c01059de:	ff 75 0c             	pushl  0xc(%ebp)
c01059e1:	6a 3f                	push   $0x3f
c01059e3:	8b 45 08             	mov    0x8(%ebp),%eax
c01059e6:	ff d0                	call   *%eax
c01059e8:	83 c4 10             	add    $0x10,%esp
c01059eb:	eb 0f                	jmp    c01059fc <vprintfmt+0x20e>
                }
                else {
                    putch(ch, putdat);
c01059ed:	83 ec 08             	sub    $0x8,%esp
c01059f0:	ff 75 0c             	pushl  0xc(%ebp)
c01059f3:	53                   	push   %ebx
c01059f4:	8b 45 08             	mov    0x8(%ebp),%eax
c01059f7:	ff d0                	call   *%eax
c01059f9:	83 c4 10             	add    $0x10,%esp
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c01059fc:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0105a00:	89 f0                	mov    %esi,%eax
c0105a02:	8d 70 01             	lea    0x1(%eax),%esi
c0105a05:	0f b6 00             	movzbl (%eax),%eax
c0105a08:	0f be d8             	movsbl %al,%ebx
c0105a0b:	85 db                	test   %ebx,%ebx
c0105a0d:	74 26                	je     c0105a35 <vprintfmt+0x247>
c0105a0f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105a13:	78 b6                	js     c01059cb <vprintfmt+0x1dd>
c0105a15:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
c0105a19:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105a1d:	79 ac                	jns    c01059cb <vprintfmt+0x1dd>
                }
            }
            for (; width > 0; width --) {
c0105a1f:	eb 14                	jmp    c0105a35 <vprintfmt+0x247>
                putch(' ', putdat);
c0105a21:	83 ec 08             	sub    $0x8,%esp
c0105a24:	ff 75 0c             	pushl  0xc(%ebp)
c0105a27:	6a 20                	push   $0x20
c0105a29:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a2c:	ff d0                	call   *%eax
c0105a2e:	83 c4 10             	add    $0x10,%esp
            for (; width > 0; width --) {
c0105a31:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0105a35:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105a39:	7f e6                	jg     c0105a21 <vprintfmt+0x233>
            }
            break;
c0105a3b:	e9 4e 01 00 00       	jmp    c0105b8e <vprintfmt+0x3a0>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c0105a40:	83 ec 08             	sub    $0x8,%esp
c0105a43:	ff 75 e0             	pushl  -0x20(%ebp)
c0105a46:	8d 45 14             	lea    0x14(%ebp),%eax
c0105a49:	50                   	push   %eax
c0105a4a:	e8 2c fd ff ff       	call   c010577b <getint>
c0105a4f:	83 c4 10             	add    $0x10,%esp
c0105a52:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105a55:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c0105a58:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105a5b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105a5e:	85 d2                	test   %edx,%edx
c0105a60:	79 23                	jns    c0105a85 <vprintfmt+0x297>
                putch('-', putdat);
c0105a62:	83 ec 08             	sub    $0x8,%esp
c0105a65:	ff 75 0c             	pushl  0xc(%ebp)
c0105a68:	6a 2d                	push   $0x2d
c0105a6a:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a6d:	ff d0                	call   *%eax
c0105a6f:	83 c4 10             	add    $0x10,%esp
                num = -(long long)num;
c0105a72:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105a75:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105a78:	f7 d8                	neg    %eax
c0105a7a:	83 d2 00             	adc    $0x0,%edx
c0105a7d:	f7 da                	neg    %edx
c0105a7f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105a82:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c0105a85:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0105a8c:	e9 9f 00 00 00       	jmp    c0105b30 <vprintfmt+0x342>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c0105a91:	83 ec 08             	sub    $0x8,%esp
c0105a94:	ff 75 e0             	pushl  -0x20(%ebp)
c0105a97:	8d 45 14             	lea    0x14(%ebp),%eax
c0105a9a:	50                   	push   %eax
c0105a9b:	e8 88 fc ff ff       	call   c0105728 <getuint>
c0105aa0:	83 c4 10             	add    $0x10,%esp
c0105aa3:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105aa6:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c0105aa9:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0105ab0:	eb 7e                	jmp    c0105b30 <vprintfmt+0x342>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c0105ab2:	83 ec 08             	sub    $0x8,%esp
c0105ab5:	ff 75 e0             	pushl  -0x20(%ebp)
c0105ab8:	8d 45 14             	lea    0x14(%ebp),%eax
c0105abb:	50                   	push   %eax
c0105abc:	e8 67 fc ff ff       	call   c0105728 <getuint>
c0105ac1:	83 c4 10             	add    $0x10,%esp
c0105ac4:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105ac7:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c0105aca:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c0105ad1:	eb 5d                	jmp    c0105b30 <vprintfmt+0x342>

        // pointer
        case 'p':
            putch('0', putdat);
c0105ad3:	83 ec 08             	sub    $0x8,%esp
c0105ad6:	ff 75 0c             	pushl  0xc(%ebp)
c0105ad9:	6a 30                	push   $0x30
c0105adb:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ade:	ff d0                	call   *%eax
c0105ae0:	83 c4 10             	add    $0x10,%esp
            putch('x', putdat);
c0105ae3:	83 ec 08             	sub    $0x8,%esp
c0105ae6:	ff 75 0c             	pushl  0xc(%ebp)
c0105ae9:	6a 78                	push   $0x78
c0105aeb:	8b 45 08             	mov    0x8(%ebp),%eax
c0105aee:	ff d0                	call   *%eax
c0105af0:	83 c4 10             	add    $0x10,%esp
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c0105af3:	8b 45 14             	mov    0x14(%ebp),%eax
c0105af6:	8d 50 04             	lea    0x4(%eax),%edx
c0105af9:	89 55 14             	mov    %edx,0x14(%ebp)
c0105afc:	8b 00                	mov    (%eax),%eax
c0105afe:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105b01:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c0105b08:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c0105b0f:	eb 1f                	jmp    c0105b30 <vprintfmt+0x342>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c0105b11:	83 ec 08             	sub    $0x8,%esp
c0105b14:	ff 75 e0             	pushl  -0x20(%ebp)
c0105b17:	8d 45 14             	lea    0x14(%ebp),%eax
c0105b1a:	50                   	push   %eax
c0105b1b:	e8 08 fc ff ff       	call   c0105728 <getuint>
c0105b20:	83 c4 10             	add    $0x10,%esp
c0105b23:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105b26:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c0105b29:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c0105b30:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c0105b34:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105b37:	83 ec 04             	sub    $0x4,%esp
c0105b3a:	52                   	push   %edx
c0105b3b:	ff 75 e8             	pushl  -0x18(%ebp)
c0105b3e:	50                   	push   %eax
c0105b3f:	ff 75 f4             	pushl  -0xc(%ebp)
c0105b42:	ff 75 f0             	pushl  -0x10(%ebp)
c0105b45:	ff 75 0c             	pushl  0xc(%ebp)
c0105b48:	ff 75 08             	pushl  0x8(%ebp)
c0105b4b:	e8 e8 fa ff ff       	call   c0105638 <printnum>
c0105b50:	83 c4 20             	add    $0x20,%esp
            break;
c0105b53:	eb 39                	jmp    c0105b8e <vprintfmt+0x3a0>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c0105b55:	83 ec 08             	sub    $0x8,%esp
c0105b58:	ff 75 0c             	pushl  0xc(%ebp)
c0105b5b:	53                   	push   %ebx
c0105b5c:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b5f:	ff d0                	call   *%eax
c0105b61:	83 c4 10             	add    $0x10,%esp
            break;
c0105b64:	eb 28                	jmp    c0105b8e <vprintfmt+0x3a0>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c0105b66:	83 ec 08             	sub    $0x8,%esp
c0105b69:	ff 75 0c             	pushl  0xc(%ebp)
c0105b6c:	6a 25                	push   $0x25
c0105b6e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b71:	ff d0                	call   *%eax
c0105b73:	83 c4 10             	add    $0x10,%esp
            for (fmt --; fmt[-1] != '%'; fmt --)
c0105b76:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0105b7a:	eb 04                	jmp    c0105b80 <vprintfmt+0x392>
c0105b7c:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0105b80:	8b 45 10             	mov    0x10(%ebp),%eax
c0105b83:	83 e8 01             	sub    $0x1,%eax
c0105b86:	0f b6 00             	movzbl (%eax),%eax
c0105b89:	3c 25                	cmp    $0x25,%al
c0105b8b:	75 ef                	jne    c0105b7c <vprintfmt+0x38e>
                /* do nothing */;
            break;
c0105b8d:	90                   	nop
    while (1) {
c0105b8e:	e9 67 fc ff ff       	jmp    c01057fa <vprintfmt+0xc>
                return;
c0105b93:	90                   	nop
        }
    }
}
c0105b94:	8d 65 f8             	lea    -0x8(%ebp),%esp
c0105b97:	5b                   	pop    %ebx
c0105b98:	5e                   	pop    %esi
c0105b99:	5d                   	pop    %ebp
c0105b9a:	c3                   	ret    

c0105b9b <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c0105b9b:	f3 0f 1e fb          	endbr32 
c0105b9f:	55                   	push   %ebp
c0105ba0:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c0105ba2:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105ba5:	8b 40 08             	mov    0x8(%eax),%eax
c0105ba8:	8d 50 01             	lea    0x1(%eax),%edx
c0105bab:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105bae:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c0105bb1:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105bb4:	8b 10                	mov    (%eax),%edx
c0105bb6:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105bb9:	8b 40 04             	mov    0x4(%eax),%eax
c0105bbc:	39 c2                	cmp    %eax,%edx
c0105bbe:	73 12                	jae    c0105bd2 <sprintputch+0x37>
        *b->buf ++ = ch;
c0105bc0:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105bc3:	8b 00                	mov    (%eax),%eax
c0105bc5:	8d 48 01             	lea    0x1(%eax),%ecx
c0105bc8:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105bcb:	89 0a                	mov    %ecx,(%edx)
c0105bcd:	8b 55 08             	mov    0x8(%ebp),%edx
c0105bd0:	88 10                	mov    %dl,(%eax)
    }
}
c0105bd2:	90                   	nop
c0105bd3:	5d                   	pop    %ebp
c0105bd4:	c3                   	ret    

c0105bd5 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c0105bd5:	f3 0f 1e fb          	endbr32 
c0105bd9:	55                   	push   %ebp
c0105bda:	89 e5                	mov    %esp,%ebp
c0105bdc:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0105bdf:	8d 45 14             	lea    0x14(%ebp),%eax
c0105be2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c0105be5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105be8:	50                   	push   %eax
c0105be9:	ff 75 10             	pushl  0x10(%ebp)
c0105bec:	ff 75 0c             	pushl  0xc(%ebp)
c0105bef:	ff 75 08             	pushl  0x8(%ebp)
c0105bf2:	e8 0b 00 00 00       	call   c0105c02 <vsnprintf>
c0105bf7:	83 c4 10             	add    $0x10,%esp
c0105bfa:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0105bfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105c00:	c9                   	leave  
c0105c01:	c3                   	ret    

c0105c02 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c0105c02:	f3 0f 1e fb          	endbr32 
c0105c06:	55                   	push   %ebp
c0105c07:	89 e5                	mov    %esp,%ebp
c0105c09:	83 ec 18             	sub    $0x18,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c0105c0c:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c0f:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105c12:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c15:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105c18:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c1b:	01 d0                	add    %edx,%eax
c0105c1d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105c20:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c0105c27:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0105c2b:	74 0a                	je     c0105c37 <vsnprintf+0x35>
c0105c2d:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105c30:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105c33:	39 c2                	cmp    %eax,%edx
c0105c35:	76 07                	jbe    c0105c3e <vsnprintf+0x3c>
        return -E_INVAL;
c0105c37:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c0105c3c:	eb 20                	jmp    c0105c5e <vsnprintf+0x5c>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c0105c3e:	ff 75 14             	pushl  0x14(%ebp)
c0105c41:	ff 75 10             	pushl  0x10(%ebp)
c0105c44:	8d 45 ec             	lea    -0x14(%ebp),%eax
c0105c47:	50                   	push   %eax
c0105c48:	68 9b 5b 10 c0       	push   $0xc0105b9b
c0105c4d:	e8 9c fb ff ff       	call   c01057ee <vprintfmt>
c0105c52:	83 c4 10             	add    $0x10,%esp
    // null terminate the buffer
    *b.buf = '\0';
c0105c55:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105c58:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c0105c5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105c5e:	c9                   	leave  
c0105c5f:	c3                   	ret    
