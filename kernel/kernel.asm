
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
_entry:
        # set up a stack for C.
        # stack0 is declared in start.c,
        # with a 4096-byte stack per CPU.
        # sp = stack0 + ((hartid + 1) * 4096)
        la sp, stack0
    80000000:	00008117          	auipc	sp,0x8
    80000004:	88010113          	add	sp,sp,-1920 # 80007880 <stack0>
        li a0, 1024*4
    80000008:	6505                	lui	a0,0x1
        csrr a1, mhartid
    8000000a:	f14025f3          	csrr	a1,mhartid
        addi a1, a1, 1
    8000000e:	0585                	add	a1,a1,1
        mul a0, a0, a1
    80000010:	02b50533          	mul	a0,a0,a1
        add sp, sp, a0
    80000014:	912a                	add	sp,sp,a0
        # jump to start() in start.c
        call start
    80000016:	04a000ef          	jal	80000060 <start>

000000008000001a <spin>:
spin:
        j spin
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    8000001c:	1141                	add	sp,sp,-16
    8000001e:	e422                	sd	s0,8(sp)
    80000020:	0800                	add	s0,sp,16
#define MIE_STIE (1L << 5)  // supervisor timer
static inline uint64
r_mie()
{
  uint64 x;
  asm volatile("csrr %0, mie" : "=r" (x) );
    80000022:	304027f3          	csrr	a5,mie
  // enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);
    80000026:	0207e793          	or	a5,a5,32
}

static inline void 
w_mie(uint64 x)
{
  asm volatile("csrw mie, %0" : : "r" (x));
    8000002a:	30479073          	csrw	mie,a5
static inline uint64
r_menvcfg()
{
  uint64 x;
  // asm volatile("csrr %0, menvcfg" : "=r" (x) );
  asm volatile("csrr %0, 0x30a" : "=r" (x) );
    8000002e:	30a027f3          	csrr	a5,0x30a
  
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | (1L << 63)); 
    80000032:	577d                	li	a4,-1
    80000034:	177e                	sll	a4,a4,0x3f
    80000036:	8fd9                	or	a5,a5,a4

static inline void 
w_menvcfg(uint64 x)
{
  // asm volatile("csrw menvcfg, %0" : : "r" (x));
  asm volatile("csrw 0x30a, %0" : : "r" (x));
    80000038:	30a79073          	csrw	0x30a,a5

static inline uint64
r_mcounteren()
{
  uint64 x;
  asm volatile("csrr %0, mcounteren" : "=r" (x) );
    8000003c:	306027f3          	csrr	a5,mcounteren
  
  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    80000040:	0027e793          	or	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r" (x));
    80000044:	30679073          	csrw	mcounteren,a5
// machine-mode cycle counter
static inline uint64
r_time()
{
  uint64 x;
  asm volatile("csrr %0, time" : "=r" (x) );
    80000048:	c01027f3          	rdtime	a5
  
  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    8000004c:	000f4737          	lui	a4,0xf4
    80000050:	24070713          	add	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80000054:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80000056:	14d79073          	csrw	stimecmp,a5
}
    8000005a:	6422                	ld	s0,8(sp)
    8000005c:	0141                	add	sp,sp,16
    8000005e:	8082                	ret

0000000080000060 <start>:
{
    80000060:	1141                	add	sp,sp,-16
    80000062:	e406                	sd	ra,8(sp)
    80000064:	e022                	sd	s0,0(sp)
    80000066:	0800                	add	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000068:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    8000006c:	7779                	lui	a4,0xffffe
    8000006e:	7ff70713          	add	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdda0f>
    80000072:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80000074:	6705                	lui	a4,0x1
    80000076:	80070713          	add	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    8000007a:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    8000007c:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80000080:	00001797          	auipc	a5,0x1
    80000084:	d6878793          	add	a5,a5,-664 # 80000de8 <main>
    80000088:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    8000008c:	4781                	li	a5,0
    8000008e:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80000092:	67c1                	lui	a5,0x10
    80000094:	17fd                	add	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80000096:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    8000009a:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    8000009e:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE);
    800000a2:	2207e793          	or	a5,a5,544
  asm volatile("csrw sie, %0" : : "r" (x));
    800000a6:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800000aa:	57fd                	li	a5,-1
    800000ac:	83a9                	srl	a5,a5,0xa
    800000ae:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800000b2:	47bd                	li	a5,15
    800000b4:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800000b8:	f65ff0ef          	jal	8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800000bc:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000c0:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    800000c2:	823e                	mv	tp,a5
  asm volatile("mret");
    800000c4:	30200073          	mret
}
    800000c8:	60a2                	ld	ra,8(sp)
    800000ca:	6402                	ld	s0,0(sp)
    800000cc:	0141                	add	sp,sp,16
    800000ce:	8082                	ret

00000000800000d0 <consolewrite>:
// user write() system calls to the console go here.
// uses sleep() and UART interrupts.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800000d0:	7119                	add	sp,sp,-128
    800000d2:	fc86                	sd	ra,120(sp)
    800000d4:	f8a2                	sd	s0,112(sp)
    800000d6:	f4a6                	sd	s1,104(sp)
    800000d8:	f0ca                	sd	s2,96(sp)
    800000da:	ecce                	sd	s3,88(sp)
    800000dc:	e8d2                	sd	s4,80(sp)
    800000de:	e4d6                	sd	s5,72(sp)
    800000e0:	e0da                	sd	s6,64(sp)
    800000e2:	fc5e                	sd	s7,56(sp)
    800000e4:	f862                	sd	s8,48(sp)
    800000e6:	f466                	sd	s9,40(sp)
    800000e8:	0100                	add	s0,sp,128
  char buf[32]; // move batches from user space to uart.
  int i = 0;

  while(i < n){
    800000ea:	04c05963          	blez	a2,8000013c <consolewrite+0x6c>
    800000ee:	8aaa                	mv	s5,a0
    800000f0:	8b2e                	mv	s6,a1
    800000f2:	8a32                	mv	s4,a2
  int i = 0;
    800000f4:	4481                	li	s1,0
    int nn = sizeof(buf);
    if(nn > n - i)
    800000f6:	02000c13          	li	s8,32
    800000fa:	02000c93          	li	s9,32
      nn = n - i;
    if(either_copyin(buf, user_src, src+i, nn) == -1)
    800000fe:	5bfd                	li	s7,-1
    80000100:	a035                	j	8000012c <consolewrite+0x5c>
    if(nn > n - i)
    80000102:	0009099b          	sext.w	s3,s2
    if(either_copyin(buf, user_src, src+i, nn) == -1)
    80000106:	86ce                	mv	a3,s3
    80000108:	01648633          	add	a2,s1,s6
    8000010c:	85d6                	mv	a1,s5
    8000010e:	f8040513          	add	a0,s0,-128
    80000112:	134020ef          	jal	80002246 <either_copyin>
    80000116:	03750463          	beq	a0,s7,8000013e <consolewrite+0x6e>
      break;
    uartwrite(buf, nn);
    8000011a:	85ce                	mv	a1,s3
    8000011c:	f8040513          	add	a0,s0,-128
    80000120:	72a000ef          	jal	8000084a <uartwrite>
    i += nn;
    80000124:	009904bb          	addw	s1,s2,s1
  while(i < n){
    80000128:	0144db63          	bge	s1,s4,8000013e <consolewrite+0x6e>
    if(nn > n - i)
    8000012c:	409a093b          	subw	s2,s4,s1
    80000130:	0009079b          	sext.w	a5,s2
    80000134:	fcfc57e3          	bge	s8,a5,80000102 <consolewrite+0x32>
    80000138:	8966                	mv	s2,s9
    8000013a:	b7e1                	j	80000102 <consolewrite+0x32>
  int i = 0;
    8000013c:	4481                	li	s1,0
  }

  return i;
}
    8000013e:	8526                	mv	a0,s1
    80000140:	70e6                	ld	ra,120(sp)
    80000142:	7446                	ld	s0,112(sp)
    80000144:	74a6                	ld	s1,104(sp)
    80000146:	7906                	ld	s2,96(sp)
    80000148:	69e6                	ld	s3,88(sp)
    8000014a:	6a46                	ld	s4,80(sp)
    8000014c:	6aa6                	ld	s5,72(sp)
    8000014e:	6b06                	ld	s6,64(sp)
    80000150:	7be2                	ld	s7,56(sp)
    80000152:	7c42                	ld	s8,48(sp)
    80000154:	7ca2                	ld	s9,40(sp)
    80000156:	6109                	add	sp,sp,128
    80000158:	8082                	ret

000000008000015a <consoleread>:
// user_dst indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    8000015a:	711d                	add	sp,sp,-96
    8000015c:	ec86                	sd	ra,88(sp)
    8000015e:	e8a2                	sd	s0,80(sp)
    80000160:	e4a6                	sd	s1,72(sp)
    80000162:	e0ca                	sd	s2,64(sp)
    80000164:	fc4e                	sd	s3,56(sp)
    80000166:	f852                	sd	s4,48(sp)
    80000168:	f456                	sd	s5,40(sp)
    8000016a:	f05a                	sd	s6,32(sp)
    8000016c:	ec5e                	sd	s7,24(sp)
    8000016e:	1080                	add	s0,sp,96
    80000170:	8aaa                	mv	s5,a0
    80000172:	8a2e                	mv	s4,a1
    80000174:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80000176:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    8000017a:	0000f517          	auipc	a0,0xf
    8000017e:	70650513          	add	a0,a0,1798 # 8000f880 <cons>
    80000182:	1f3000ef          	jal	80000b74 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80000186:	0000f497          	auipc	s1,0xf
    8000018a:	6fa48493          	add	s1,s1,1786 # 8000f880 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    8000018e:	0000f917          	auipc	s2,0xf
    80000192:	78a90913          	add	s2,s2,1930 # 8000f918 <cons+0x98>
  while(n > 0){
    80000196:	07305a63          	blez	s3,8000020a <consoleread+0xb0>
    while(cons.r == cons.w){
    8000019a:	0984a783          	lw	a5,152(s1)
    8000019e:	09c4a703          	lw	a4,156(s1)
    800001a2:	02f71163          	bne	a4,a5,800001c4 <consoleread+0x6a>
      if(killed(myproc())){
    800001a6:	664010ef          	jal	8000180a <myproc>
    800001aa:	72f010ef          	jal	800020d8 <killed>
    800001ae:	e53d                	bnez	a0,8000021c <consoleread+0xc2>
      sleep(&cons.r, &cons.lock);
    800001b0:	85a6                	mv	a1,s1
    800001b2:	854a                	mv	a0,s2
    800001b4:	4ed010ef          	jal	80001ea0 <sleep>
    while(cons.r == cons.w){
    800001b8:	0984a783          	lw	a5,152(s1)
    800001bc:	09c4a703          	lw	a4,156(s1)
    800001c0:	fef703e3          	beq	a4,a5,800001a6 <consoleread+0x4c>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001c4:	0000f717          	auipc	a4,0xf
    800001c8:	6bc70713          	add	a4,a4,1724 # 8000f880 <cons>
    800001cc:	0017869b          	addw	a3,a5,1
    800001d0:	08d72c23          	sw	a3,152(a4)
    800001d4:	07f7f693          	and	a3,a5,127
    800001d8:	9736                	add	a4,a4,a3
    800001da:	01874703          	lbu	a4,24(a4)
    800001de:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    800001e2:	4691                	li	a3,4
    800001e4:	04db8e63          	beq	s7,a3,80000240 <consoleread+0xe6>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    800001e8:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800001ec:	4685                	li	a3,1
    800001ee:	faf40613          	add	a2,s0,-81
    800001f2:	85d2                	mv	a1,s4
    800001f4:	8556                	mv	a0,s5
    800001f6:	006020ef          	jal	800021fc <either_copyout>
    800001fa:	57fd                	li	a5,-1
    800001fc:	00f50763          	beq	a0,a5,8000020a <consoleread+0xb0>
      break;

    dst++;
    80000200:	0a05                	add	s4,s4,1
    --n;
    80000202:	39fd                	addw	s3,s3,-1

    if(c == '\n'){
    80000204:	47a9                	li	a5,10
    80000206:	f8fb98e3          	bne	s7,a5,80000196 <consoleread+0x3c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    8000020a:	0000f517          	auipc	a0,0xf
    8000020e:	67650513          	add	a0,a0,1654 # 8000f880 <cons>
    80000212:	1fb000ef          	jal	80000c0c <release>

  return target - n;
    80000216:	413b053b          	subw	a0,s6,s3
    8000021a:	a801                	j	8000022a <consoleread+0xd0>
        release(&cons.lock);
    8000021c:	0000f517          	auipc	a0,0xf
    80000220:	66450513          	add	a0,a0,1636 # 8000f880 <cons>
    80000224:	1e9000ef          	jal	80000c0c <release>
        return -1;
    80000228:	557d                	li	a0,-1
}
    8000022a:	60e6                	ld	ra,88(sp)
    8000022c:	6446                	ld	s0,80(sp)
    8000022e:	64a6                	ld	s1,72(sp)
    80000230:	6906                	ld	s2,64(sp)
    80000232:	79e2                	ld	s3,56(sp)
    80000234:	7a42                	ld	s4,48(sp)
    80000236:	7aa2                	ld	s5,40(sp)
    80000238:	7b02                	ld	s6,32(sp)
    8000023a:	6be2                	ld	s7,24(sp)
    8000023c:	6125                	add	sp,sp,96
    8000023e:	8082                	ret
      if(n < target){
    80000240:	0009871b          	sext.w	a4,s3
    80000244:	fd6773e3          	bgeu	a4,s6,8000020a <consoleread+0xb0>
        cons.r--;
    80000248:	0000f717          	auipc	a4,0xf
    8000024c:	6cf72823          	sw	a5,1744(a4) # 8000f918 <cons+0x98>
    80000250:	bf6d                	j	8000020a <consoleread+0xb0>

0000000080000252 <consputc>:
{
    80000252:	1141                	add	sp,sp,-16
    80000254:	e406                	sd	ra,8(sp)
    80000256:	e022                	sd	s0,0(sp)
    80000258:	0800                	add	s0,sp,16
  if(c == BACKSPACE){
    8000025a:	10000793          	li	a5,256
    8000025e:	00f50863          	beq	a0,a5,8000026e <consputc+0x1c>
    uartputc_sync(c);
    80000262:	67c000ef          	jal	800008de <uartputc_sync>
}
    80000266:	60a2                	ld	ra,8(sp)
    80000268:	6402                	ld	s0,0(sp)
    8000026a:	0141                	add	sp,sp,16
    8000026c:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    8000026e:	4521                	li	a0,8
    80000270:	66e000ef          	jal	800008de <uartputc_sync>
    80000274:	02000513          	li	a0,32
    80000278:	666000ef          	jal	800008de <uartputc_sync>
    8000027c:	4521                	li	a0,8
    8000027e:	660000ef          	jal	800008de <uartputc_sync>
    80000282:	b7d5                	j	80000266 <consputc+0x14>

0000000080000284 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80000284:	1101                	add	sp,sp,-32
    80000286:	ec06                	sd	ra,24(sp)
    80000288:	e822                	sd	s0,16(sp)
    8000028a:	e426                	sd	s1,8(sp)
    8000028c:	e04a                	sd	s2,0(sp)
    8000028e:	1000                	add	s0,sp,32
    80000290:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80000292:	0000f517          	auipc	a0,0xf
    80000296:	5ee50513          	add	a0,a0,1518 # 8000f880 <cons>
    8000029a:	0db000ef          	jal	80000b74 <acquire>

  switch(c){
    8000029e:	47d5                	li	a5,21
    800002a0:	0af48063          	beq	s1,a5,80000340 <consoleintr+0xbc>
    800002a4:	0297c663          	blt	a5,s1,800002d0 <consoleintr+0x4c>
    800002a8:	47a1                	li	a5,8
    800002aa:	0cf48f63          	beq	s1,a5,80000388 <consoleintr+0x104>
    800002ae:	47c1                	li	a5,16
    800002b0:	10f49063          	bne	s1,a5,800003b0 <consoleintr+0x12c>
  case C('P'):  // Print process list.
    procdump();
    800002b4:	080020ef          	jal	80002334 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800002b8:	0000f517          	auipc	a0,0xf
    800002bc:	5c850513          	add	a0,a0,1480 # 8000f880 <cons>
    800002c0:	14d000ef          	jal	80000c0c <release>
}
    800002c4:	60e2                	ld	ra,24(sp)
    800002c6:	6442                	ld	s0,16(sp)
    800002c8:	64a2                	ld	s1,8(sp)
    800002ca:	6902                	ld	s2,0(sp)
    800002cc:	6105                	add	sp,sp,32
    800002ce:	8082                	ret
  switch(c){
    800002d0:	07f00793          	li	a5,127
    800002d4:	0af48a63          	beq	s1,a5,80000388 <consoleintr+0x104>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800002d8:	0000f717          	auipc	a4,0xf
    800002dc:	5a870713          	add	a4,a4,1448 # 8000f880 <cons>
    800002e0:	0a072783          	lw	a5,160(a4)
    800002e4:	09872703          	lw	a4,152(a4)
    800002e8:	9f99                	subw	a5,a5,a4
    800002ea:	07f00713          	li	a4,127
    800002ee:	fcf765e3          	bltu	a4,a5,800002b8 <consoleintr+0x34>
      c = (c == '\r') ? '\n' : c;
    800002f2:	47b5                	li	a5,13
    800002f4:	0cf48163          	beq	s1,a5,800003b6 <consoleintr+0x132>
      consputc(c);
    800002f8:	8526                	mv	a0,s1
    800002fa:	f59ff0ef          	jal	80000252 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800002fe:	0000f797          	auipc	a5,0xf
    80000302:	58278793          	add	a5,a5,1410 # 8000f880 <cons>
    80000306:	0a07a683          	lw	a3,160(a5)
    8000030a:	0016871b          	addw	a4,a3,1
    8000030e:	0007061b          	sext.w	a2,a4
    80000312:	0ae7a023          	sw	a4,160(a5)
    80000316:	07f6f693          	and	a3,a3,127
    8000031a:	97b6                	add	a5,a5,a3
    8000031c:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80000320:	47a9                	li	a5,10
    80000322:	0af48f63          	beq	s1,a5,800003e0 <consoleintr+0x15c>
    80000326:	4791                	li	a5,4
    80000328:	0af48c63          	beq	s1,a5,800003e0 <consoleintr+0x15c>
    8000032c:	0000f797          	auipc	a5,0xf
    80000330:	5ec7a783          	lw	a5,1516(a5) # 8000f918 <cons+0x98>
    80000334:	9f1d                	subw	a4,a4,a5
    80000336:	08000793          	li	a5,128
    8000033a:	f6f71fe3          	bne	a4,a5,800002b8 <consoleintr+0x34>
    8000033e:	a04d                	j	800003e0 <consoleintr+0x15c>
    while(cons.e != cons.w &&
    80000340:	0000f717          	auipc	a4,0xf
    80000344:	54070713          	add	a4,a4,1344 # 8000f880 <cons>
    80000348:	0a072783          	lw	a5,160(a4)
    8000034c:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80000350:	0000f497          	auipc	s1,0xf
    80000354:	53048493          	add	s1,s1,1328 # 8000f880 <cons>
    while(cons.e != cons.w &&
    80000358:	4929                	li	s2,10
    8000035a:	f4f70fe3          	beq	a4,a5,800002b8 <consoleintr+0x34>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    8000035e:	37fd                	addw	a5,a5,-1
    80000360:	07f7f713          	and	a4,a5,127
    80000364:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80000366:	01874703          	lbu	a4,24(a4)
    8000036a:	f52707e3          	beq	a4,s2,800002b8 <consoleintr+0x34>
      cons.e--;
    8000036e:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80000372:	10000513          	li	a0,256
    80000376:	eddff0ef          	jal	80000252 <consputc>
    while(cons.e != cons.w &&
    8000037a:	0a04a783          	lw	a5,160(s1)
    8000037e:	09c4a703          	lw	a4,156(s1)
    80000382:	fcf71ee3          	bne	a4,a5,8000035e <consoleintr+0xda>
    80000386:	bf0d                	j	800002b8 <consoleintr+0x34>
    if(cons.e != cons.w){
    80000388:	0000f717          	auipc	a4,0xf
    8000038c:	4f870713          	add	a4,a4,1272 # 8000f880 <cons>
    80000390:	0a072783          	lw	a5,160(a4)
    80000394:	09c72703          	lw	a4,156(a4)
    80000398:	f2f700e3          	beq	a4,a5,800002b8 <consoleintr+0x34>
      cons.e--;
    8000039c:	37fd                	addw	a5,a5,-1
    8000039e:	0000f717          	auipc	a4,0xf
    800003a2:	58f72123          	sw	a5,1410(a4) # 8000f920 <cons+0xa0>
      consputc(BACKSPACE);
    800003a6:	10000513          	li	a0,256
    800003aa:	ea9ff0ef          	jal	80000252 <consputc>
    800003ae:	b729                	j	800002b8 <consoleintr+0x34>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800003b0:	f00484e3          	beqz	s1,800002b8 <consoleintr+0x34>
    800003b4:	b715                	j	800002d8 <consoleintr+0x54>
      consputc(c);
    800003b6:	4529                	li	a0,10
    800003b8:	e9bff0ef          	jal	80000252 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800003bc:	0000f797          	auipc	a5,0xf
    800003c0:	4c478793          	add	a5,a5,1220 # 8000f880 <cons>
    800003c4:	0a07a703          	lw	a4,160(a5)
    800003c8:	0017069b          	addw	a3,a4,1
    800003cc:	0006861b          	sext.w	a2,a3
    800003d0:	0ad7a023          	sw	a3,160(a5)
    800003d4:	07f77713          	and	a4,a4,127
    800003d8:	97ba                	add	a5,a5,a4
    800003da:	4729                	li	a4,10
    800003dc:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    800003e0:	0000f797          	auipc	a5,0xf
    800003e4:	52c7ae23          	sw	a2,1340(a5) # 8000f91c <cons+0x9c>
        wakeup(&cons.r);
    800003e8:	0000f517          	auipc	a0,0xf
    800003ec:	53050513          	add	a0,a0,1328 # 8000f918 <cons+0x98>
    800003f0:	2fd010ef          	jal	80001eec <wakeup>
    800003f4:	b5d1                	j	800002b8 <consoleintr+0x34>

00000000800003f6 <consoleinit>:

void
consoleinit(void)
{
    800003f6:	1141                	add	sp,sp,-16
    800003f8:	e406                	sd	ra,8(sp)
    800003fa:	e022                	sd	s0,0(sp)
    800003fc:	0800                	add	s0,sp,16
  initlock(&cons.lock, "cons");
    800003fe:	00007597          	auipc	a1,0x7
    80000402:	c1258593          	add	a1,a1,-1006 # 80007010 <etext+0x10>
    80000406:	0000f517          	auipc	a0,0xf
    8000040a:	47a50513          	add	a0,a0,1146 # 8000f880 <cons>
    8000040e:	6e6000ef          	jal	80000af4 <initlock>

  uartinit();
    80000412:	3ec000ef          	jal	800007fe <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80000416:	00020797          	auipc	a5,0x20
    8000041a:	84278793          	add	a5,a5,-1982 # 8001fc58 <devsw>
    8000041e:	00000717          	auipc	a4,0x0
    80000422:	d3c70713          	add	a4,a4,-708 # 8000015a <consoleread>
    80000426:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80000428:	00000717          	auipc	a4,0x0
    8000042c:	ca870713          	add	a4,a4,-856 # 800000d0 <consolewrite>
    80000430:	ef98                	sd	a4,24(a5)
}
    80000432:	60a2                	ld	ra,8(sp)
    80000434:	6402                	ld	s0,0(sp)
    80000436:	0141                	add	sp,sp,16
    80000438:	8082                	ret

000000008000043a <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    8000043a:	7139                	add	sp,sp,-64
    8000043c:	fc06                	sd	ra,56(sp)
    8000043e:	f822                	sd	s0,48(sp)
    80000440:	f426                	sd	s1,40(sp)
    80000442:	f04a                	sd	s2,32(sp)
    80000444:	0080                	add	s0,sp,64
  char buf[20];
  int i;
  unsigned long long x;

  if(sign && (sign = (xx < 0)))
    80000446:	c219                	beqz	a2,8000044c <printint+0x12>
    80000448:	06054e63          	bltz	a0,800004c4 <printint+0x8a>
    x = -xx;
  else
    x = xx;
    8000044c:	4881                	li	a7,0
    8000044e:	fc840693          	add	a3,s0,-56

  i = 0;
    80000452:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
    80000454:	00007617          	auipc	a2,0x7
    80000458:	be460613          	add	a2,a2,-1052 # 80007038 <digits>
    8000045c:	883e                	mv	a6,a5
    8000045e:	2785                	addw	a5,a5,1
    80000460:	02b57733          	remu	a4,a0,a1
    80000464:	9732                	add	a4,a4,a2
    80000466:	00074703          	lbu	a4,0(a4)
    8000046a:	00e68023          	sb	a4,0(a3)
  } while((x /= base) != 0);
    8000046e:	872a                	mv	a4,a0
    80000470:	02b55533          	divu	a0,a0,a1
    80000474:	0685                	add	a3,a3,1
    80000476:	feb773e3          	bgeu	a4,a1,8000045c <printint+0x22>

  if(sign)
    8000047a:	00088a63          	beqz	a7,8000048e <printint+0x54>
    buf[i++] = '-';
    8000047e:	1781                	add	a5,a5,-32
    80000480:	97a2                	add	a5,a5,s0
    80000482:	02d00713          	li	a4,45
    80000486:	fee78423          	sb	a4,-24(a5)
    8000048a:	0028079b          	addw	a5,a6,2

  while(--i >= 0)
    8000048e:	02f05563          	blez	a5,800004b8 <printint+0x7e>
    80000492:	fc840713          	add	a4,s0,-56
    80000496:	00f704b3          	add	s1,a4,a5
    8000049a:	fff70913          	add	s2,a4,-1
    8000049e:	993e                	add	s2,s2,a5
    800004a0:	37fd                	addw	a5,a5,-1
    800004a2:	1782                	sll	a5,a5,0x20
    800004a4:	9381                	srl	a5,a5,0x20
    800004a6:	40f90933          	sub	s2,s2,a5
    consputc(buf[i]);
    800004aa:	fff4c503          	lbu	a0,-1(s1)
    800004ae:	da5ff0ef          	jal	80000252 <consputc>
  while(--i >= 0)
    800004b2:	14fd                	add	s1,s1,-1
    800004b4:	ff249be3          	bne	s1,s2,800004aa <printint+0x70>
}
    800004b8:	70e2                	ld	ra,56(sp)
    800004ba:	7442                	ld	s0,48(sp)
    800004bc:	74a2                	ld	s1,40(sp)
    800004be:	7902                	ld	s2,32(sp)
    800004c0:	6121                	add	sp,sp,64
    800004c2:	8082                	ret
    x = -xx;
    800004c4:	40a00533          	neg	a0,a0
  if(sign && (sign = (xx < 0)))
    800004c8:	4885                	li	a7,1
    x = -xx;
    800004ca:	b751                	j	8000044e <printint+0x14>

00000000800004cc <printf>:
}

// Print to the console.
int
printf(char *fmt, ...)
{
    800004cc:	7131                	add	sp,sp,-192
    800004ce:	fc86                	sd	ra,120(sp)
    800004d0:	f8a2                	sd	s0,112(sp)
    800004d2:	f4a6                	sd	s1,104(sp)
    800004d4:	f0ca                	sd	s2,96(sp)
    800004d6:	ecce                	sd	s3,88(sp)
    800004d8:	e8d2                	sd	s4,80(sp)
    800004da:	e4d6                	sd	s5,72(sp)
    800004dc:	e0da                	sd	s6,64(sp)
    800004de:	fc5e                	sd	s7,56(sp)
    800004e0:	f862                	sd	s8,48(sp)
    800004e2:	f466                	sd	s9,40(sp)
    800004e4:	f06a                	sd	s10,32(sp)
    800004e6:	ec6e                	sd	s11,24(sp)
    800004e8:	0100                	add	s0,sp,128
    800004ea:	8a2a                	mv	s4,a0
    800004ec:	e40c                	sd	a1,8(s0)
    800004ee:	e810                	sd	a2,16(s0)
    800004f0:	ec14                	sd	a3,24(s0)
    800004f2:	f018                	sd	a4,32(s0)
    800004f4:	f41c                	sd	a5,40(s0)
    800004f6:	03043823          	sd	a6,48(s0)
    800004fa:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2;
  char *s;

  if(panicking == 0)
    800004fe:	00007797          	auipc	a5,0x7
    80000502:	3567a783          	lw	a5,854(a5) # 80007854 <panicking>
    80000506:	c79d                	beqz	a5,80000534 <printf+0x68>
    acquire(&pr.lock);

  va_start(ap, fmt);
    80000508:	00840793          	add	a5,s0,8
    8000050c:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    80000510:	000a4503          	lbu	a0,0(s4)
    80000514:	24050963          	beqz	a0,80000766 <printf+0x29a>
    80000518:	4981                	li	s3,0
    if(cx != '%'){
    8000051a:	02500a93          	li	s5,37
    i++;
    c0 = fmt[i+0] & 0xff;
    c1 = c2 = 0;
    if(c0) c1 = fmt[i+1] & 0xff;
    if(c1) c2 = fmt[i+2] & 0xff;
    if(c0 == 'd'){
    8000051e:	06400b13          	li	s6,100
      printint(va_arg(ap, int), 10, 1);
    } else if(c0 == 'l' && c1 == 'd'){
    80000522:	06c00c13          	li	s8,108
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    80000526:	07500c93          	li	s9,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    8000052a:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
    8000052e:	07000d93          	li	s11,112
    80000532:	a01d                	j	80000558 <printf+0x8c>
    acquire(&pr.lock);
    80000534:	0000f517          	auipc	a0,0xf
    80000538:	3f450513          	add	a0,a0,1012 # 8000f928 <pr>
    8000053c:	638000ef          	jal	80000b74 <acquire>
    80000540:	b7e1                	j	80000508 <printf+0x3c>
      consputc(cx);
    80000542:	d11ff0ef          	jal	80000252 <consputc>
      continue;
    80000546:	84ce                	mv	s1,s3
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    80000548:	0014899b          	addw	s3,s1,1
    8000054c:	013a07b3          	add	a5,s4,s3
    80000550:	0007c503          	lbu	a0,0(a5)
    80000554:	20050963          	beqz	a0,80000766 <printf+0x29a>
    if(cx != '%'){
    80000558:	ff5515e3          	bne	a0,s5,80000542 <printf+0x76>
    i++;
    8000055c:	0019849b          	addw	s1,s3,1
    c0 = fmt[i+0] & 0xff;
    80000560:	009a07b3          	add	a5,s4,s1
    80000564:	0007c903          	lbu	s2,0(a5)
    if(c0) c1 = fmt[i+1] & 0xff;
    80000568:	1e090f63          	beqz	s2,80000766 <printf+0x29a>
    8000056c:	0017c783          	lbu	a5,1(a5)
    c1 = c2 = 0;
    80000570:	86be                	mv	a3,a5
    if(c1) c2 = fmt[i+2] & 0xff;
    80000572:	c789                	beqz	a5,8000057c <printf+0xb0>
    80000574:	009a0733          	add	a4,s4,s1
    80000578:	00274683          	lbu	a3,2(a4)
    if(c0 == 'd'){
    8000057c:	03690963          	beq	s2,s6,800005ae <printf+0xe2>
    } else if(c0 == 'l' && c1 == 'd'){
    80000580:	05890363          	beq	s2,s8,800005c6 <printf+0xfa>
    } else if(c0 == 'u'){
    80000584:	0d990663          	beq	s2,s9,80000650 <printf+0x184>
    } else if(c0 == 'x'){
    80000588:	11a90d63          	beq	s2,s10,800006a2 <printf+0x1d6>
    } else if(c0 == 'p'){
    8000058c:	15b90663          	beq	s2,s11,800006d8 <printf+0x20c>
      printptr(va_arg(ap, uint64));
    } else if(c0 == 'c'){
    80000590:	06300793          	li	a5,99
    80000594:	18f90363          	beq	s2,a5,8000071a <printf+0x24e>
      consputc(va_arg(ap, uint));
    } else if(c0 == 's'){
    80000598:	07300793          	li	a5,115
    8000059c:	18f90963          	beq	s2,a5,8000072e <printf+0x262>
      if((s = va_arg(ap, char*)) == 0)
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
    } else if(c0 == '%'){
    800005a0:	03591b63          	bne	s2,s5,800005d6 <printf+0x10a>
      consputc('%');
    800005a4:	02500513          	li	a0,37
    800005a8:	cabff0ef          	jal	80000252 <consputc>
    800005ac:	bf71                	j	80000548 <printf+0x7c>
      printint(va_arg(ap, int), 10, 1);
    800005ae:	f8843783          	ld	a5,-120(s0)
    800005b2:	00878713          	add	a4,a5,8
    800005b6:	f8e43423          	sd	a4,-120(s0)
    800005ba:	4605                	li	a2,1
    800005bc:	45a9                	li	a1,10
    800005be:	4388                	lw	a0,0(a5)
    800005c0:	e7bff0ef          	jal	8000043a <printint>
    800005c4:	b751                	j	80000548 <printf+0x7c>
    } else if(c0 == 'l' && c1 == 'd'){
    800005c6:	01678f63          	beq	a5,s6,800005e4 <printf+0x118>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    800005ca:	03878b63          	beq	a5,s8,80000600 <printf+0x134>
    } else if(c0 == 'l' && c1 == 'u'){
    800005ce:	09978e63          	beq	a5,s9,8000066a <printf+0x19e>
    } else if(c0 == 'l' && c1 == 'x'){
    800005d2:	0fa78563          	beq	a5,s10,800006bc <printf+0x1f0>
    } else if(c0 == 0){
      break;
    } else {
      // Print unknown % sequence to draw attention.
      consputc('%');
    800005d6:	8556                	mv	a0,s5
    800005d8:	c7bff0ef          	jal	80000252 <consputc>
      consputc(c0);
    800005dc:	854a                	mv	a0,s2
    800005de:	c75ff0ef          	jal	80000252 <consputc>
    800005e2:	b79d                	j	80000548 <printf+0x7c>
      printint(va_arg(ap, uint64), 10, 1);
    800005e4:	f8843783          	ld	a5,-120(s0)
    800005e8:	00878713          	add	a4,a5,8
    800005ec:	f8e43423          	sd	a4,-120(s0)
    800005f0:	4605                	li	a2,1
    800005f2:	45a9                	li	a1,10
    800005f4:	6388                	ld	a0,0(a5)
    800005f6:	e45ff0ef          	jal	8000043a <printint>
      i += 1;
    800005fa:	0029849b          	addw	s1,s3,2
    800005fe:	b7a9                	j	80000548 <printf+0x7c>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    80000600:	06400793          	li	a5,100
    80000604:	02f68863          	beq	a3,a5,80000634 <printf+0x168>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    80000608:	07500793          	li	a5,117
    8000060c:	06f68d63          	beq	a3,a5,80000686 <printf+0x1ba>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    80000610:	07800793          	li	a5,120
    80000614:	fcf691e3          	bne	a3,a5,800005d6 <printf+0x10a>
      printint(va_arg(ap, uint64), 16, 0);
    80000618:	f8843783          	ld	a5,-120(s0)
    8000061c:	00878713          	add	a4,a5,8
    80000620:	f8e43423          	sd	a4,-120(s0)
    80000624:	4601                	li	a2,0
    80000626:	45c1                	li	a1,16
    80000628:	6388                	ld	a0,0(a5)
    8000062a:	e11ff0ef          	jal	8000043a <printint>
      i += 2;
    8000062e:	0039849b          	addw	s1,s3,3
    80000632:	bf19                	j	80000548 <printf+0x7c>
      printint(va_arg(ap, uint64), 10, 1);
    80000634:	f8843783          	ld	a5,-120(s0)
    80000638:	00878713          	add	a4,a5,8
    8000063c:	f8e43423          	sd	a4,-120(s0)
    80000640:	4605                	li	a2,1
    80000642:	45a9                	li	a1,10
    80000644:	6388                	ld	a0,0(a5)
    80000646:	df5ff0ef          	jal	8000043a <printint>
      i += 2;
    8000064a:	0039849b          	addw	s1,s3,3
    8000064e:	bded                	j	80000548 <printf+0x7c>
      printint(va_arg(ap, uint32), 10, 0);
    80000650:	f8843783          	ld	a5,-120(s0)
    80000654:	00878713          	add	a4,a5,8
    80000658:	f8e43423          	sd	a4,-120(s0)
    8000065c:	4601                	li	a2,0
    8000065e:	45a9                	li	a1,10
    80000660:	0007e503          	lwu	a0,0(a5)
    80000664:	dd7ff0ef          	jal	8000043a <printint>
    80000668:	b5c5                	j	80000548 <printf+0x7c>
      printint(va_arg(ap, uint64), 10, 0);
    8000066a:	f8843783          	ld	a5,-120(s0)
    8000066e:	00878713          	add	a4,a5,8
    80000672:	f8e43423          	sd	a4,-120(s0)
    80000676:	4601                	li	a2,0
    80000678:	45a9                	li	a1,10
    8000067a:	6388                	ld	a0,0(a5)
    8000067c:	dbfff0ef          	jal	8000043a <printint>
      i += 1;
    80000680:	0029849b          	addw	s1,s3,2
    80000684:	b5d1                	j	80000548 <printf+0x7c>
      printint(va_arg(ap, uint64), 10, 0);
    80000686:	f8843783          	ld	a5,-120(s0)
    8000068a:	00878713          	add	a4,a5,8
    8000068e:	f8e43423          	sd	a4,-120(s0)
    80000692:	4601                	li	a2,0
    80000694:	45a9                	li	a1,10
    80000696:	6388                	ld	a0,0(a5)
    80000698:	da3ff0ef          	jal	8000043a <printint>
      i += 2;
    8000069c:	0039849b          	addw	s1,s3,3
    800006a0:	b565                	j	80000548 <printf+0x7c>
      printint(va_arg(ap, uint32), 16, 0);
    800006a2:	f8843783          	ld	a5,-120(s0)
    800006a6:	00878713          	add	a4,a5,8
    800006aa:	f8e43423          	sd	a4,-120(s0)
    800006ae:	4601                	li	a2,0
    800006b0:	45c1                	li	a1,16
    800006b2:	0007e503          	lwu	a0,0(a5)
    800006b6:	d85ff0ef          	jal	8000043a <printint>
    800006ba:	b579                	j	80000548 <printf+0x7c>
      printint(va_arg(ap, uint64), 16, 0);
    800006bc:	f8843783          	ld	a5,-120(s0)
    800006c0:	00878713          	add	a4,a5,8
    800006c4:	f8e43423          	sd	a4,-120(s0)
    800006c8:	4601                	li	a2,0
    800006ca:	45c1                	li	a1,16
    800006cc:	6388                	ld	a0,0(a5)
    800006ce:	d6dff0ef          	jal	8000043a <printint>
      i += 1;
    800006d2:	0029849b          	addw	s1,s3,2
    800006d6:	bd8d                	j	80000548 <printf+0x7c>
      printptr(va_arg(ap, uint64));
    800006d8:	f8843783          	ld	a5,-120(s0)
    800006dc:	00878713          	add	a4,a5,8
    800006e0:	f8e43423          	sd	a4,-120(s0)
    800006e4:	0007b983          	ld	s3,0(a5)
  consputc('0');
    800006e8:	03000513          	li	a0,48
    800006ec:	b67ff0ef          	jal	80000252 <consputc>
  consputc('x');
    800006f0:	07800513          	li	a0,120
    800006f4:	b5fff0ef          	jal	80000252 <consputc>
    800006f8:	4941                	li	s2,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800006fa:	00007b97          	auipc	s7,0x7
    800006fe:	93eb8b93          	add	s7,s7,-1730 # 80007038 <digits>
    80000702:	03c9d793          	srl	a5,s3,0x3c
    80000706:	97de                	add	a5,a5,s7
    80000708:	0007c503          	lbu	a0,0(a5)
    8000070c:	b47ff0ef          	jal	80000252 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80000710:	0992                	sll	s3,s3,0x4
    80000712:	397d                	addw	s2,s2,-1
    80000714:	fe0917e3          	bnez	s2,80000702 <printf+0x236>
    80000718:	bd05                	j	80000548 <printf+0x7c>
      consputc(va_arg(ap, uint));
    8000071a:	f8843783          	ld	a5,-120(s0)
    8000071e:	00878713          	add	a4,a5,8
    80000722:	f8e43423          	sd	a4,-120(s0)
    80000726:	4388                	lw	a0,0(a5)
    80000728:	b2bff0ef          	jal	80000252 <consputc>
    8000072c:	bd31                	j	80000548 <printf+0x7c>
      if((s = va_arg(ap, char*)) == 0)
    8000072e:	f8843783          	ld	a5,-120(s0)
    80000732:	00878713          	add	a4,a5,8
    80000736:	f8e43423          	sd	a4,-120(s0)
    8000073a:	0007b903          	ld	s2,0(a5)
    8000073e:	00090d63          	beqz	s2,80000758 <printf+0x28c>
      for(; *s; s++)
    80000742:	00094503          	lbu	a0,0(s2)
    80000746:	e00501e3          	beqz	a0,80000548 <printf+0x7c>
        consputc(*s);
    8000074a:	b09ff0ef          	jal	80000252 <consputc>
      for(; *s; s++)
    8000074e:	0905                	add	s2,s2,1
    80000750:	00094503          	lbu	a0,0(s2)
    80000754:	f97d                	bnez	a0,8000074a <printf+0x27e>
    80000756:	bbcd                	j	80000548 <printf+0x7c>
        s = "(null)";
    80000758:	00007917          	auipc	s2,0x7
    8000075c:	8c090913          	add	s2,s2,-1856 # 80007018 <etext+0x18>
      for(; *s; s++)
    80000760:	02800513          	li	a0,40
    80000764:	b7dd                	j	8000074a <printf+0x27e>
    }

  }
  va_end(ap);

  if(panicking == 0)
    80000766:	00007797          	auipc	a5,0x7
    8000076a:	0ee7a783          	lw	a5,238(a5) # 80007854 <panicking>
    8000076e:	c38d                	beqz	a5,80000790 <printf+0x2c4>
    release(&pr.lock);

  return 0;
}
    80000770:	4501                	li	a0,0
    80000772:	70e6                	ld	ra,120(sp)
    80000774:	7446                	ld	s0,112(sp)
    80000776:	74a6                	ld	s1,104(sp)
    80000778:	7906                	ld	s2,96(sp)
    8000077a:	69e6                	ld	s3,88(sp)
    8000077c:	6a46                	ld	s4,80(sp)
    8000077e:	6aa6                	ld	s5,72(sp)
    80000780:	6b06                	ld	s6,64(sp)
    80000782:	7be2                	ld	s7,56(sp)
    80000784:	7c42                	ld	s8,48(sp)
    80000786:	7ca2                	ld	s9,40(sp)
    80000788:	7d02                	ld	s10,32(sp)
    8000078a:	6de2                	ld	s11,24(sp)
    8000078c:	6129                	add	sp,sp,192
    8000078e:	8082                	ret
    release(&pr.lock);
    80000790:	0000f517          	auipc	a0,0xf
    80000794:	19850513          	add	a0,a0,408 # 8000f928 <pr>
    80000798:	474000ef          	jal	80000c0c <release>
  return 0;
    8000079c:	bfd1                	j	80000770 <printf+0x2a4>

000000008000079e <panic>:

void
panic(char *s)
{
    8000079e:	1101                	add	sp,sp,-32
    800007a0:	ec06                	sd	ra,24(sp)
    800007a2:	e822                	sd	s0,16(sp)
    800007a4:	e426                	sd	s1,8(sp)
    800007a6:	e04a                	sd	s2,0(sp)
    800007a8:	1000                	add	s0,sp,32
    800007aa:	84aa                	mv	s1,a0
  panicking = 1;
    800007ac:	4905                	li	s2,1
    800007ae:	00007797          	auipc	a5,0x7
    800007b2:	0b27a323          	sw	s2,166(a5) # 80007854 <panicking>
  printf("panic: ");
    800007b6:	00007517          	auipc	a0,0x7
    800007ba:	86a50513          	add	a0,a0,-1942 # 80007020 <etext+0x20>
    800007be:	d0fff0ef          	jal	800004cc <printf>
  printf("%s\n", s);
    800007c2:	85a6                	mv	a1,s1
    800007c4:	00007517          	auipc	a0,0x7
    800007c8:	86450513          	add	a0,a0,-1948 # 80007028 <etext+0x28>
    800007cc:	d01ff0ef          	jal	800004cc <printf>
  panicked = 1; // freeze uart output from other CPUs
    800007d0:	00007797          	auipc	a5,0x7
    800007d4:	0927a023          	sw	s2,128(a5) # 80007850 <panicked>
  for(;;)
    800007d8:	a001                	j	800007d8 <panic+0x3a>

00000000800007da <printfinit>:
    ;
}

void
printfinit(void)
{
    800007da:	1141                	add	sp,sp,-16
    800007dc:	e406                	sd	ra,8(sp)
    800007de:	e022                	sd	s0,0(sp)
    800007e0:	0800                	add	s0,sp,16
  initlock(&pr.lock, "pr");
    800007e2:	00007597          	auipc	a1,0x7
    800007e6:	84e58593          	add	a1,a1,-1970 # 80007030 <etext+0x30>
    800007ea:	0000f517          	auipc	a0,0xf
    800007ee:	13e50513          	add	a0,a0,318 # 8000f928 <pr>
    800007f2:	302000ef          	jal	80000af4 <initlock>
}
    800007f6:	60a2                	ld	ra,8(sp)
    800007f8:	6402                	ld	s0,0(sp)
    800007fa:	0141                	add	sp,sp,16
    800007fc:	8082                	ret

00000000800007fe <uartinit>:
extern volatile int panicking; // from printf.c
extern volatile int panicked; // from printf.c

void
uartinit(void)
{
    800007fe:	1141                	add	sp,sp,-16
    80000800:	e406                	sd	ra,8(sp)
    80000802:	e022                	sd	s0,0(sp)
    80000804:	0800                	add	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80000806:	100007b7          	lui	a5,0x10000
    8000080a:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    8000080e:	f8000713          	li	a4,-128
    80000812:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80000816:	470d                	li	a4,3
    80000818:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    8000081c:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80000820:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80000824:	469d                	li	a3,7
    80000826:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    8000082a:	00e780a3          	sb	a4,1(a5)

  initlock(&tx_lock, "uart");
    8000082e:	00007597          	auipc	a1,0x7
    80000832:	82258593          	add	a1,a1,-2014 # 80007050 <digits+0x18>
    80000836:	0000f517          	auipc	a0,0xf
    8000083a:	10a50513          	add	a0,a0,266 # 8000f940 <tx_lock>
    8000083e:	2b6000ef          	jal	80000af4 <initlock>
}
    80000842:	60a2                	ld	ra,8(sp)
    80000844:	6402                	ld	s0,0(sp)
    80000846:	0141                	add	sp,sp,16
    80000848:	8082                	ret

000000008000084a <uartwrite>:
// transmit buf[] to the uart. it blocks if the
// uart is busy, so it cannot be called from
// interrupts, only from write() system calls.
void
uartwrite(char buf[], int n)
{
    8000084a:	715d                	add	sp,sp,-80
    8000084c:	e486                	sd	ra,72(sp)
    8000084e:	e0a2                	sd	s0,64(sp)
    80000850:	fc26                	sd	s1,56(sp)
    80000852:	f84a                	sd	s2,48(sp)
    80000854:	f44e                	sd	s3,40(sp)
    80000856:	f052                	sd	s4,32(sp)
    80000858:	ec56                	sd	s5,24(sp)
    8000085a:	e85a                	sd	s6,16(sp)
    8000085c:	e45e                	sd	s7,8(sp)
    8000085e:	0880                	add	s0,sp,80
    80000860:	8aaa                	mv	s5,a0
    80000862:	84ae                	mv	s1,a1
  acquire(&tx_lock);
    80000864:	0000f517          	auipc	a0,0xf
    80000868:	0dc50513          	add	a0,a0,220 # 8000f940 <tx_lock>
    8000086c:	308000ef          	jal	80000b74 <acquire>

  int i = 0;
  while(i < n){ 
    80000870:	04905663          	blez	s1,800008bc <uartwrite+0x72>
    80000874:	8a56                	mv	s4,s5
    80000876:	9aa6                	add	s5,s5,s1
    while(tx_busy != 0){
    80000878:	00007497          	auipc	s1,0x7
    8000087c:	fe448493          	add	s1,s1,-28 # 8000785c <tx_busy>
      // wait for a UART transmit-complete interrupt
      // to set tx_busy to 0.
      sleep(&tx_chan, &tx_lock);
    80000880:	0000f997          	auipc	s3,0xf
    80000884:	0c098993          	add	s3,s3,192 # 8000f940 <tx_lock>
    80000888:	00007917          	auipc	s2,0x7
    8000088c:	fd090913          	add	s2,s2,-48 # 80007858 <tx_chan>
    }   
      
    WriteReg(THR, buf[i]);
    80000890:	10000bb7          	lui	s7,0x10000
    i += 1;
    tx_busy = 1;
    80000894:	4b05                	li	s6,1
    80000896:	a005                	j	800008b6 <uartwrite+0x6c>
      sleep(&tx_chan, &tx_lock);
    80000898:	85ce                	mv	a1,s3
    8000089a:	854a                	mv	a0,s2
    8000089c:	604010ef          	jal	80001ea0 <sleep>
    while(tx_busy != 0){
    800008a0:	409c                	lw	a5,0(s1)
    800008a2:	fbfd                	bnez	a5,80000898 <uartwrite+0x4e>
    WriteReg(THR, buf[i]);
    800008a4:	000a4783          	lbu	a5,0(s4)
    800008a8:	00fb8023          	sb	a5,0(s7) # 10000000 <_entry-0x70000000>
    tx_busy = 1;
    800008ac:	0164a023          	sw	s6,0(s1)
  while(i < n){ 
    800008b0:	0a05                	add	s4,s4,1
    800008b2:	015a0563          	beq	s4,s5,800008bc <uartwrite+0x72>
    while(tx_busy != 0){
    800008b6:	409c                	lw	a5,0(s1)
    800008b8:	f3e5                	bnez	a5,80000898 <uartwrite+0x4e>
    800008ba:	b7ed                	j	800008a4 <uartwrite+0x5a>
  }

  release(&tx_lock);
    800008bc:	0000f517          	auipc	a0,0xf
    800008c0:	08450513          	add	a0,a0,132 # 8000f940 <tx_lock>
    800008c4:	348000ef          	jal	80000c0c <release>
}
    800008c8:	60a6                	ld	ra,72(sp)
    800008ca:	6406                	ld	s0,64(sp)
    800008cc:	74e2                	ld	s1,56(sp)
    800008ce:	7942                	ld	s2,48(sp)
    800008d0:	79a2                	ld	s3,40(sp)
    800008d2:	7a02                	ld	s4,32(sp)
    800008d4:	6ae2                	ld	s5,24(sp)
    800008d6:	6b42                	ld	s6,16(sp)
    800008d8:	6ba2                	ld	s7,8(sp)
    800008da:	6161                	add	sp,sp,80
    800008dc:	8082                	ret

00000000800008de <uartputc_sync>:
// interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    800008de:	1101                	add	sp,sp,-32
    800008e0:	ec06                	sd	ra,24(sp)
    800008e2:	e822                	sd	s0,16(sp)
    800008e4:	e426                	sd	s1,8(sp)
    800008e6:	1000                	add	s0,sp,32
    800008e8:	84aa                	mv	s1,a0
  if(panicking == 0)
    800008ea:	00007797          	auipc	a5,0x7
    800008ee:	f6a7a783          	lw	a5,-150(a5) # 80007854 <panicking>
    800008f2:	cb89                	beqz	a5,80000904 <uartputc_sync+0x26>
    push_off();

  if(panicked){
    800008f4:	00007797          	auipc	a5,0x7
    800008f8:	f5c7a783          	lw	a5,-164(a5) # 80007850 <panicked>
    for(;;)
      ;
  }

  // wait for UART to set Transmit Holding Empty in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800008fc:	10000737          	lui	a4,0x10000
  if(panicked){
    80000900:	c789                	beqz	a5,8000090a <uartputc_sync+0x2c>
    for(;;)
    80000902:	a001                	j	80000902 <uartputc_sync+0x24>
    push_off();
    80000904:	230000ef          	jal	80000b34 <push_off>
    80000908:	b7f5                	j	800008f4 <uartputc_sync+0x16>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000090a:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    8000090e:	0207f793          	and	a5,a5,32
    80000912:	dfe5                	beqz	a5,8000090a <uartputc_sync+0x2c>
    ;
  WriteReg(THR, c);
    80000914:	0ff4f513          	zext.b	a0,s1
    80000918:	100007b7          	lui	a5,0x10000
    8000091c:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  if(panicking == 0)
    80000920:	00007797          	auipc	a5,0x7
    80000924:	f347a783          	lw	a5,-204(a5) # 80007854 <panicking>
    80000928:	c791                	beqz	a5,80000934 <uartputc_sync+0x56>
    pop_off();
}
    8000092a:	60e2                	ld	ra,24(sp)
    8000092c:	6442                	ld	s0,16(sp)
    8000092e:	64a2                	ld	s1,8(sp)
    80000930:	6105                	add	sp,sp,32
    80000932:	8082                	ret
    pop_off();
    80000934:	284000ef          	jal	80000bb8 <pop_off>
}
    80000938:	bfcd                	j	8000092a <uartputc_sync+0x4c>

000000008000093a <uartgetc>:

// try to read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    8000093a:	1141                	add	sp,sp,-16
    8000093c:	e422                	sd	s0,8(sp)
    8000093e:	0800                	add	s0,sp,16
  if(ReadReg(LSR) & LSR_RX_READY){
    80000940:	100007b7          	lui	a5,0x10000
    80000944:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80000948:	8b85                	and	a5,a5,1
    8000094a:	cb81                	beqz	a5,8000095a <uartgetc+0x20>
    // input data is ready.
    return ReadReg(RHR);
    8000094c:	100007b7          	lui	a5,0x10000
    80000950:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    80000954:	6422                	ld	s0,8(sp)
    80000956:	0141                	add	sp,sp,16
    80000958:	8082                	ret
    return -1;
    8000095a:	557d                	li	a0,-1
    8000095c:	bfe5                	j	80000954 <uartgetc+0x1a>

000000008000095e <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    8000095e:	1101                	add	sp,sp,-32
    80000960:	ec06                	sd	ra,24(sp)
    80000962:	e822                	sd	s0,16(sp)
    80000964:	e426                	sd	s1,8(sp)
    80000966:	1000                	add	s0,sp,32
  ReadReg(ISR); // acknowledge the interrupt
    80000968:	100004b7          	lui	s1,0x10000
    8000096c:	0024c783          	lbu	a5,2(s1) # 10000002 <_entry-0x6ffffffe>

  acquire(&tx_lock);
    80000970:	0000f517          	auipc	a0,0xf
    80000974:	fd050513          	add	a0,a0,-48 # 8000f940 <tx_lock>
    80000978:	1fc000ef          	jal	80000b74 <acquire>
  if(ReadReg(LSR) & LSR_TX_IDLE){
    8000097c:	0054c783          	lbu	a5,5(s1)
    80000980:	0207f793          	and	a5,a5,32
    80000984:	eb89                	bnez	a5,80000996 <uartintr+0x38>
    // UART finished transmitting; wake up sending thread.
    tx_busy = 0;
    wakeup(&tx_chan);
  }
  release(&tx_lock);
    80000986:	0000f517          	auipc	a0,0xf
    8000098a:	fba50513          	add	a0,a0,-70 # 8000f940 <tx_lock>
    8000098e:	27e000ef          	jal	80000c0c <release>

  // read and process incoming characters, if any.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80000992:	54fd                	li	s1,-1
    80000994:	a831                	j	800009b0 <uartintr+0x52>
    tx_busy = 0;
    80000996:	00007797          	auipc	a5,0x7
    8000099a:	ec07a323          	sw	zero,-314(a5) # 8000785c <tx_busy>
    wakeup(&tx_chan);
    8000099e:	00007517          	auipc	a0,0x7
    800009a2:	eba50513          	add	a0,a0,-326 # 80007858 <tx_chan>
    800009a6:	546010ef          	jal	80001eec <wakeup>
    800009aa:	bff1                	j	80000986 <uartintr+0x28>
      break;
    consoleintr(c);
    800009ac:	8d9ff0ef          	jal	80000284 <consoleintr>
    int c = uartgetc();
    800009b0:	f8bff0ef          	jal	8000093a <uartgetc>
    if(c == -1)
    800009b4:	fe951ce3          	bne	a0,s1,800009ac <uartintr+0x4e>
  }
}
    800009b8:	60e2                	ld	ra,24(sp)
    800009ba:	6442                	ld	s0,16(sp)
    800009bc:	64a2                	ld	s1,8(sp)
    800009be:	6105                	add	sp,sp,32
    800009c0:	8082                	ret

00000000800009c2 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    800009c2:	1101                	add	sp,sp,-32
    800009c4:	ec06                	sd	ra,24(sp)
    800009c6:	e822                	sd	s0,16(sp)
    800009c8:	e426                	sd	s1,8(sp)
    800009ca:	e04a                	sd	s2,0(sp)
    800009cc:	1000                	add	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    800009ce:	03451793          	sll	a5,a0,0x34
    800009d2:	e7a9                	bnez	a5,80000a1c <kfree+0x5a>
    800009d4:	84aa                	mv	s1,a0
    800009d6:	00020797          	auipc	a5,0x20
    800009da:	41a78793          	add	a5,a5,1050 # 80020df0 <end>
    800009de:	02f56f63          	bltu	a0,a5,80000a1c <kfree+0x5a>
    800009e2:	47c5                	li	a5,17
    800009e4:	07ee                	sll	a5,a5,0x1b
    800009e6:	02f57b63          	bgeu	a0,a5,80000a1c <kfree+0x5a>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    800009ea:	6605                	lui	a2,0x1
    800009ec:	4585                	li	a1,1
    800009ee:	25a000ef          	jal	80000c48 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    800009f2:	0000f917          	auipc	s2,0xf
    800009f6:	f6690913          	add	s2,s2,-154 # 8000f958 <kmem>
    800009fa:	854a                	mv	a0,s2
    800009fc:	178000ef          	jal	80000b74 <acquire>
  r->next = kmem.freelist;
    80000a00:	01893783          	ld	a5,24(s2)
    80000a04:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000a06:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000a0a:	854a                	mv	a0,s2
    80000a0c:	200000ef          	jal	80000c0c <release>
}
    80000a10:	60e2                	ld	ra,24(sp)
    80000a12:	6442                	ld	s0,16(sp)
    80000a14:	64a2                	ld	s1,8(sp)
    80000a16:	6902                	ld	s2,0(sp)
    80000a18:	6105                	add	sp,sp,32
    80000a1a:	8082                	ret
    panic("kfree");
    80000a1c:	00006517          	auipc	a0,0x6
    80000a20:	63c50513          	add	a0,a0,1596 # 80007058 <digits+0x20>
    80000a24:	d7bff0ef          	jal	8000079e <panic>

0000000080000a28 <freerange>:
{
    80000a28:	7179                	add	sp,sp,-48
    80000a2a:	f406                	sd	ra,40(sp)
    80000a2c:	f022                	sd	s0,32(sp)
    80000a2e:	ec26                	sd	s1,24(sp)
    80000a30:	e84a                	sd	s2,16(sp)
    80000a32:	e44e                	sd	s3,8(sp)
    80000a34:	e052                	sd	s4,0(sp)
    80000a36:	1800                	add	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000a38:	6785                	lui	a5,0x1
    80000a3a:	fff78713          	add	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000a3e:	00e504b3          	add	s1,a0,a4
    80000a42:	777d                	lui	a4,0xfffff
    80000a44:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000a46:	94be                	add	s1,s1,a5
    80000a48:	0095ec63          	bltu	a1,s1,80000a60 <freerange+0x38>
    80000a4c:	892e                	mv	s2,a1
    kfree(p);
    80000a4e:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000a50:	6985                	lui	s3,0x1
    kfree(p);
    80000a52:	01448533          	add	a0,s1,s4
    80000a56:	f6dff0ef          	jal	800009c2 <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000a5a:	94ce                	add	s1,s1,s3
    80000a5c:	fe997be3          	bgeu	s2,s1,80000a52 <freerange+0x2a>
}
    80000a60:	70a2                	ld	ra,40(sp)
    80000a62:	7402                	ld	s0,32(sp)
    80000a64:	64e2                	ld	s1,24(sp)
    80000a66:	6942                	ld	s2,16(sp)
    80000a68:	69a2                	ld	s3,8(sp)
    80000a6a:	6a02                	ld	s4,0(sp)
    80000a6c:	6145                	add	sp,sp,48
    80000a6e:	8082                	ret

0000000080000a70 <kinit>:
{
    80000a70:	1141                	add	sp,sp,-16
    80000a72:	e406                	sd	ra,8(sp)
    80000a74:	e022                	sd	s0,0(sp)
    80000a76:	0800                	add	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000a78:	00006597          	auipc	a1,0x6
    80000a7c:	5e858593          	add	a1,a1,1512 # 80007060 <digits+0x28>
    80000a80:	0000f517          	auipc	a0,0xf
    80000a84:	ed850513          	add	a0,a0,-296 # 8000f958 <kmem>
    80000a88:	06c000ef          	jal	80000af4 <initlock>
  freerange(end, (void*)PHYSTOP);
    80000a8c:	45c5                	li	a1,17
    80000a8e:	05ee                	sll	a1,a1,0x1b
    80000a90:	00020517          	auipc	a0,0x20
    80000a94:	36050513          	add	a0,a0,864 # 80020df0 <end>
    80000a98:	f91ff0ef          	jal	80000a28 <freerange>
}
    80000a9c:	60a2                	ld	ra,8(sp)
    80000a9e:	6402                	ld	s0,0(sp)
    80000aa0:	0141                	add	sp,sp,16
    80000aa2:	8082                	ret

0000000080000aa4 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000aa4:	1101                	add	sp,sp,-32
    80000aa6:	ec06                	sd	ra,24(sp)
    80000aa8:	e822                	sd	s0,16(sp)
    80000aaa:	e426                	sd	s1,8(sp)
    80000aac:	1000                	add	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000aae:	0000f497          	auipc	s1,0xf
    80000ab2:	eaa48493          	add	s1,s1,-342 # 8000f958 <kmem>
    80000ab6:	8526                	mv	a0,s1
    80000ab8:	0bc000ef          	jal	80000b74 <acquire>
  r = kmem.freelist;
    80000abc:	6c84                	ld	s1,24(s1)
  if(r)
    80000abe:	c485                	beqz	s1,80000ae6 <kalloc+0x42>
    kmem.freelist = r->next;
    80000ac0:	609c                	ld	a5,0(s1)
    80000ac2:	0000f517          	auipc	a0,0xf
    80000ac6:	e9650513          	add	a0,a0,-362 # 8000f958 <kmem>
    80000aca:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000acc:	140000ef          	jal	80000c0c <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000ad0:	6605                	lui	a2,0x1
    80000ad2:	4595                	li	a1,5
    80000ad4:	8526                	mv	a0,s1
    80000ad6:	172000ef          	jal	80000c48 <memset>
  return (void*)r;
}
    80000ada:	8526                	mv	a0,s1
    80000adc:	60e2                	ld	ra,24(sp)
    80000ade:	6442                	ld	s0,16(sp)
    80000ae0:	64a2                	ld	s1,8(sp)
    80000ae2:	6105                	add	sp,sp,32
    80000ae4:	8082                	ret
  release(&kmem.lock);
    80000ae6:	0000f517          	auipc	a0,0xf
    80000aea:	e7250513          	add	a0,a0,-398 # 8000f958 <kmem>
    80000aee:	11e000ef          	jal	80000c0c <release>
  if(r)
    80000af2:	b7e5                	j	80000ada <kalloc+0x36>

0000000080000af4 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000af4:	1141                	add	sp,sp,-16
    80000af6:	e422                	sd	s0,8(sp)
    80000af8:	0800                	add	s0,sp,16
  lk->name = name;
    80000afa:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000afc:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000b00:	00053823          	sd	zero,16(a0)
}
    80000b04:	6422                	ld	s0,8(sp)
    80000b06:	0141                	add	sp,sp,16
    80000b08:	8082                	ret

0000000080000b0a <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000b0a:	411c                	lw	a5,0(a0)
    80000b0c:	e399                	bnez	a5,80000b12 <holding+0x8>
    80000b0e:	4501                	li	a0,0
  return r;
}
    80000b10:	8082                	ret
{
    80000b12:	1101                	add	sp,sp,-32
    80000b14:	ec06                	sd	ra,24(sp)
    80000b16:	e822                	sd	s0,16(sp)
    80000b18:	e426                	sd	s1,8(sp)
    80000b1a:	1000                	add	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000b1c:	6904                	ld	s1,16(a0)
    80000b1e:	4d1000ef          	jal	800017ee <mycpu>
    80000b22:	40a48533          	sub	a0,s1,a0
    80000b26:	00153513          	seqz	a0,a0
}
    80000b2a:	60e2                	ld	ra,24(sp)
    80000b2c:	6442                	ld	s0,16(sp)
    80000b2e:	64a2                	ld	s1,8(sp)
    80000b30:	6105                	add	sp,sp,32
    80000b32:	8082                	ret

0000000080000b34 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000b34:	1101                	add	sp,sp,-32
    80000b36:	ec06                	sd	ra,24(sp)
    80000b38:	e822                	sd	s0,16(sp)
    80000b3a:	e426                	sd	s1,8(sp)
    80000b3c:	1000                	add	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000b3e:	100024f3          	csrr	s1,sstatus
    80000b42:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000b46:	9bf5                	and	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000b48:	10079073          	csrw	sstatus,a5

  // disable interrupts to prevent an involuntary context
  // switch while using mycpu().
  intr_off();

  if(mycpu()->noff == 0)
    80000b4c:	4a3000ef          	jal	800017ee <mycpu>
    80000b50:	5d3c                	lw	a5,120(a0)
    80000b52:	cb99                	beqz	a5,80000b68 <push_off+0x34>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000b54:	49b000ef          	jal	800017ee <mycpu>
    80000b58:	5d3c                	lw	a5,120(a0)
    80000b5a:	2785                	addw	a5,a5,1
    80000b5c:	dd3c                	sw	a5,120(a0)
}
    80000b5e:	60e2                	ld	ra,24(sp)
    80000b60:	6442                	ld	s0,16(sp)
    80000b62:	64a2                	ld	s1,8(sp)
    80000b64:	6105                	add	sp,sp,32
    80000b66:	8082                	ret
    mycpu()->intena = old;
    80000b68:	487000ef          	jal	800017ee <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000b6c:	8085                	srl	s1,s1,0x1
    80000b6e:	8885                	and	s1,s1,1
    80000b70:	dd64                	sw	s1,124(a0)
    80000b72:	b7cd                	j	80000b54 <push_off+0x20>

0000000080000b74 <acquire>:
{
    80000b74:	1101                	add	sp,sp,-32
    80000b76:	ec06                	sd	ra,24(sp)
    80000b78:	e822                	sd	s0,16(sp)
    80000b7a:	e426                	sd	s1,8(sp)
    80000b7c:	1000                	add	s0,sp,32
    80000b7e:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000b80:	fb5ff0ef          	jal	80000b34 <push_off>
  if(holding(lk))
    80000b84:	8526                	mv	a0,s1
    80000b86:	f85ff0ef          	jal	80000b0a <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000b8a:	4705                	li	a4,1
  if(holding(lk))
    80000b8c:	e105                	bnez	a0,80000bac <acquire+0x38>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000b8e:	87ba                	mv	a5,a4
    80000b90:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000b94:	2781                	sext.w	a5,a5
    80000b96:	ffe5                	bnez	a5,80000b8e <acquire+0x1a>
  __sync_synchronize();
    80000b98:	0ff0000f          	fence
  lk->cpu = mycpu();
    80000b9c:	453000ef          	jal	800017ee <mycpu>
    80000ba0:	e888                	sd	a0,16(s1)
}
    80000ba2:	60e2                	ld	ra,24(sp)
    80000ba4:	6442                	ld	s0,16(sp)
    80000ba6:	64a2                	ld	s1,8(sp)
    80000ba8:	6105                	add	sp,sp,32
    80000baa:	8082                	ret
    panic("acquire");
    80000bac:	00006517          	auipc	a0,0x6
    80000bb0:	4bc50513          	add	a0,a0,1212 # 80007068 <digits+0x30>
    80000bb4:	bebff0ef          	jal	8000079e <panic>

0000000080000bb8 <pop_off>:

void
pop_off(void)
{
    80000bb8:	1141                	add	sp,sp,-16
    80000bba:	e406                	sd	ra,8(sp)
    80000bbc:	e022                	sd	s0,0(sp)
    80000bbe:	0800                	add	s0,sp,16
  struct cpu *c = mycpu();
    80000bc0:	42f000ef          	jal	800017ee <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000bc4:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000bc8:	8b89                	and	a5,a5,2
  if(intr_get())
    80000bca:	e78d                	bnez	a5,80000bf4 <pop_off+0x3c>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000bcc:	5d3c                	lw	a5,120(a0)
    80000bce:	02f05963          	blez	a5,80000c00 <pop_off+0x48>
    panic("pop_off");
  c->noff -= 1;
    80000bd2:	37fd                	addw	a5,a5,-1
    80000bd4:	0007871b          	sext.w	a4,a5
    80000bd8:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000bda:	eb09                	bnez	a4,80000bec <pop_off+0x34>
    80000bdc:	5d7c                	lw	a5,124(a0)
    80000bde:	c799                	beqz	a5,80000bec <pop_off+0x34>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000be0:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000be4:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000be8:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000bec:	60a2                	ld	ra,8(sp)
    80000bee:	6402                	ld	s0,0(sp)
    80000bf0:	0141                	add	sp,sp,16
    80000bf2:	8082                	ret
    panic("pop_off - interruptible");
    80000bf4:	00006517          	auipc	a0,0x6
    80000bf8:	47c50513          	add	a0,a0,1148 # 80007070 <digits+0x38>
    80000bfc:	ba3ff0ef          	jal	8000079e <panic>
    panic("pop_off");
    80000c00:	00006517          	auipc	a0,0x6
    80000c04:	48850513          	add	a0,a0,1160 # 80007088 <digits+0x50>
    80000c08:	b97ff0ef          	jal	8000079e <panic>

0000000080000c0c <release>:
{
    80000c0c:	1101                	add	sp,sp,-32
    80000c0e:	ec06                	sd	ra,24(sp)
    80000c10:	e822                	sd	s0,16(sp)
    80000c12:	e426                	sd	s1,8(sp)
    80000c14:	1000                	add	s0,sp,32
    80000c16:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000c18:	ef3ff0ef          	jal	80000b0a <holding>
    80000c1c:	c105                	beqz	a0,80000c3c <release+0x30>
  lk->cpu = 0;
    80000c1e:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000c22:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80000c26:	0f50000f          	fence	iorw,ow
    80000c2a:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80000c2e:	f8bff0ef          	jal	80000bb8 <pop_off>
}
    80000c32:	60e2                	ld	ra,24(sp)
    80000c34:	6442                	ld	s0,16(sp)
    80000c36:	64a2                	ld	s1,8(sp)
    80000c38:	6105                	add	sp,sp,32
    80000c3a:	8082                	ret
    panic("release");
    80000c3c:	00006517          	auipc	a0,0x6
    80000c40:	45450513          	add	a0,a0,1108 # 80007090 <digits+0x58>
    80000c44:	b5bff0ef          	jal	8000079e <panic>

0000000080000c48 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000c48:	1141                	add	sp,sp,-16
    80000c4a:	e422                	sd	s0,8(sp)
    80000c4c:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000c4e:	ca19                	beqz	a2,80000c64 <memset+0x1c>
    80000c50:	87aa                	mv	a5,a0
    80000c52:	1602                	sll	a2,a2,0x20
    80000c54:	9201                	srl	a2,a2,0x20
    80000c56:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000c5a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000c5e:	0785                	add	a5,a5,1
    80000c60:	fee79de3          	bne	a5,a4,80000c5a <memset+0x12>
  }
  return dst;
}
    80000c64:	6422                	ld	s0,8(sp)
    80000c66:	0141                	add	sp,sp,16
    80000c68:	8082                	ret

0000000080000c6a <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000c6a:	1141                	add	sp,sp,-16
    80000c6c:	e422                	sd	s0,8(sp)
    80000c6e:	0800                	add	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000c70:	ca05                	beqz	a2,80000ca0 <memcmp+0x36>
    80000c72:	fff6069b          	addw	a3,a2,-1 # fff <_entry-0x7ffff001>
    80000c76:	1682                	sll	a3,a3,0x20
    80000c78:	9281                	srl	a3,a3,0x20
    80000c7a:	0685                	add	a3,a3,1
    80000c7c:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000c7e:	00054783          	lbu	a5,0(a0)
    80000c82:	0005c703          	lbu	a4,0(a1)
    80000c86:	00e79863          	bne	a5,a4,80000c96 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000c8a:	0505                	add	a0,a0,1
    80000c8c:	0585                	add	a1,a1,1
  while(n-- > 0){
    80000c8e:	fed518e3          	bne	a0,a3,80000c7e <memcmp+0x14>
  }

  return 0;
    80000c92:	4501                	li	a0,0
    80000c94:	a019                	j	80000c9a <memcmp+0x30>
      return *s1 - *s2;
    80000c96:	40e7853b          	subw	a0,a5,a4
}
    80000c9a:	6422                	ld	s0,8(sp)
    80000c9c:	0141                	add	sp,sp,16
    80000c9e:	8082                	ret
  return 0;
    80000ca0:	4501                	li	a0,0
    80000ca2:	bfe5                	j	80000c9a <memcmp+0x30>

0000000080000ca4 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000ca4:	1141                	add	sp,sp,-16
    80000ca6:	e422                	sd	s0,8(sp)
    80000ca8:	0800                	add	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000caa:	c205                	beqz	a2,80000cca <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000cac:	02a5e263          	bltu	a1,a0,80000cd0 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000cb0:	1602                	sll	a2,a2,0x20
    80000cb2:	9201                	srl	a2,a2,0x20
    80000cb4:	00c587b3          	add	a5,a1,a2
{
    80000cb8:	872a                	mv	a4,a0
      *d++ = *s++;
    80000cba:	0585                	add	a1,a1,1
    80000cbc:	0705                	add	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffde211>
    80000cbe:	fff5c683          	lbu	a3,-1(a1)
    80000cc2:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000cc6:	fef59ae3          	bne	a1,a5,80000cba <memmove+0x16>

  return dst;
}
    80000cca:	6422                	ld	s0,8(sp)
    80000ccc:	0141                	add	sp,sp,16
    80000cce:	8082                	ret
  if(s < d && s + n > d){
    80000cd0:	02061693          	sll	a3,a2,0x20
    80000cd4:	9281                	srl	a3,a3,0x20
    80000cd6:	00d58733          	add	a4,a1,a3
    80000cda:	fce57be3          	bgeu	a0,a4,80000cb0 <memmove+0xc>
    d += n;
    80000cde:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000ce0:	fff6079b          	addw	a5,a2,-1
    80000ce4:	1782                	sll	a5,a5,0x20
    80000ce6:	9381                	srl	a5,a5,0x20
    80000ce8:	fff7c793          	not	a5,a5
    80000cec:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000cee:	177d                	add	a4,a4,-1
    80000cf0:	16fd                	add	a3,a3,-1
    80000cf2:	00074603          	lbu	a2,0(a4)
    80000cf6:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000cfa:	fee79ae3          	bne	a5,a4,80000cee <memmove+0x4a>
    80000cfe:	b7f1                	j	80000cca <memmove+0x26>

0000000080000d00 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000d00:	1141                	add	sp,sp,-16
    80000d02:	e406                	sd	ra,8(sp)
    80000d04:	e022                	sd	s0,0(sp)
    80000d06:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
    80000d08:	f9dff0ef          	jal	80000ca4 <memmove>
}
    80000d0c:	60a2                	ld	ra,8(sp)
    80000d0e:	6402                	ld	s0,0(sp)
    80000d10:	0141                	add	sp,sp,16
    80000d12:	8082                	ret

0000000080000d14 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000d14:	1141                	add	sp,sp,-16
    80000d16:	e422                	sd	s0,8(sp)
    80000d18:	0800                	add	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000d1a:	ce11                	beqz	a2,80000d36 <strncmp+0x22>
    80000d1c:	00054783          	lbu	a5,0(a0)
    80000d20:	cf89                	beqz	a5,80000d3a <strncmp+0x26>
    80000d22:	0005c703          	lbu	a4,0(a1)
    80000d26:	00f71a63          	bne	a4,a5,80000d3a <strncmp+0x26>
    n--, p++, q++;
    80000d2a:	367d                	addw	a2,a2,-1
    80000d2c:	0505                	add	a0,a0,1
    80000d2e:	0585                	add	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000d30:	f675                	bnez	a2,80000d1c <strncmp+0x8>
  if(n == 0)
    return 0;
    80000d32:	4501                	li	a0,0
    80000d34:	a809                	j	80000d46 <strncmp+0x32>
    80000d36:	4501                	li	a0,0
    80000d38:	a039                	j	80000d46 <strncmp+0x32>
  if(n == 0)
    80000d3a:	ca09                	beqz	a2,80000d4c <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000d3c:	00054503          	lbu	a0,0(a0)
    80000d40:	0005c783          	lbu	a5,0(a1)
    80000d44:	9d1d                	subw	a0,a0,a5
}
    80000d46:	6422                	ld	s0,8(sp)
    80000d48:	0141                	add	sp,sp,16
    80000d4a:	8082                	ret
    return 0;
    80000d4c:	4501                	li	a0,0
    80000d4e:	bfe5                	j	80000d46 <strncmp+0x32>

0000000080000d50 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000d50:	1141                	add	sp,sp,-16
    80000d52:	e422                	sd	s0,8(sp)
    80000d54:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000d56:	87aa                	mv	a5,a0
    80000d58:	86b2                	mv	a3,a2
    80000d5a:	367d                	addw	a2,a2,-1
    80000d5c:	00d05963          	blez	a3,80000d6e <strncpy+0x1e>
    80000d60:	0785                	add	a5,a5,1
    80000d62:	0005c703          	lbu	a4,0(a1)
    80000d66:	fee78fa3          	sb	a4,-1(a5)
    80000d6a:	0585                	add	a1,a1,1
    80000d6c:	f775                	bnez	a4,80000d58 <strncpy+0x8>
    ;
  while(n-- > 0)
    80000d6e:	873e                	mv	a4,a5
    80000d70:	9fb5                	addw	a5,a5,a3
    80000d72:	37fd                	addw	a5,a5,-1
    80000d74:	00c05963          	blez	a2,80000d86 <strncpy+0x36>
    *s++ = 0;
    80000d78:	0705                	add	a4,a4,1
    80000d7a:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    80000d7e:	40e786bb          	subw	a3,a5,a4
    80000d82:	fed04be3          	bgtz	a3,80000d78 <strncpy+0x28>
  return os;
}
    80000d86:	6422                	ld	s0,8(sp)
    80000d88:	0141                	add	sp,sp,16
    80000d8a:	8082                	ret

0000000080000d8c <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000d8c:	1141                	add	sp,sp,-16
    80000d8e:	e422                	sd	s0,8(sp)
    80000d90:	0800                	add	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000d92:	02c05363          	blez	a2,80000db8 <safestrcpy+0x2c>
    80000d96:	fff6069b          	addw	a3,a2,-1
    80000d9a:	1682                	sll	a3,a3,0x20
    80000d9c:	9281                	srl	a3,a3,0x20
    80000d9e:	96ae                	add	a3,a3,a1
    80000da0:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000da2:	00d58963          	beq	a1,a3,80000db4 <safestrcpy+0x28>
    80000da6:	0585                	add	a1,a1,1
    80000da8:	0785                	add	a5,a5,1
    80000daa:	fff5c703          	lbu	a4,-1(a1)
    80000dae:	fee78fa3          	sb	a4,-1(a5)
    80000db2:	fb65                	bnez	a4,80000da2 <safestrcpy+0x16>
    ;
  *s = 0;
    80000db4:	00078023          	sb	zero,0(a5)
  return os;
}
    80000db8:	6422                	ld	s0,8(sp)
    80000dba:	0141                	add	sp,sp,16
    80000dbc:	8082                	ret

0000000080000dbe <strlen>:

int
strlen(const char *s)
{
    80000dbe:	1141                	add	sp,sp,-16
    80000dc0:	e422                	sd	s0,8(sp)
    80000dc2:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000dc4:	00054783          	lbu	a5,0(a0)
    80000dc8:	cf91                	beqz	a5,80000de4 <strlen+0x26>
    80000dca:	0505                	add	a0,a0,1
    80000dcc:	87aa                	mv	a5,a0
    80000dce:	86be                	mv	a3,a5
    80000dd0:	0785                	add	a5,a5,1
    80000dd2:	fff7c703          	lbu	a4,-1(a5)
    80000dd6:	ff65                	bnez	a4,80000dce <strlen+0x10>
    80000dd8:	40a6853b          	subw	a0,a3,a0
    80000ddc:	2505                	addw	a0,a0,1
    ;
  return n;
}
    80000dde:	6422                	ld	s0,8(sp)
    80000de0:	0141                	add	sp,sp,16
    80000de2:	8082                	ret
  for(n = 0; s[n]; n++)
    80000de4:	4501                	li	a0,0
    80000de6:	bfe5                	j	80000dde <strlen+0x20>

0000000080000de8 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000de8:	1141                	add	sp,sp,-16
    80000dea:	e406                	sd	ra,8(sp)
    80000dec:	e022                	sd	s0,0(sp)
    80000dee:	0800                	add	s0,sp,16
  if(cpuid() == 0){
    80000df0:	1ef000ef          	jal	800017de <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000df4:	00007717          	auipc	a4,0x7
    80000df8:	a6c70713          	add	a4,a4,-1428 # 80007860 <started>
  if(cpuid() == 0){
    80000dfc:	c51d                	beqz	a0,80000e2a <main+0x42>
    while(started == 0)
    80000dfe:	431c                	lw	a5,0(a4)
    80000e00:	2781                	sext.w	a5,a5
    80000e02:	dff5                	beqz	a5,80000dfe <main+0x16>
      ;
    __sync_synchronize();
    80000e04:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000e08:	1d7000ef          	jal	800017de <cpuid>
    80000e0c:	85aa                	mv	a1,a0
    80000e0e:	00006517          	auipc	a0,0x6
    80000e12:	2a250513          	add	a0,a0,674 # 800070b0 <digits+0x78>
    80000e16:	eb6ff0ef          	jal	800004cc <printf>
    kvminithart();    // turn on paging
    80000e1a:	080000ef          	jal	80000e9a <kvminithart>
    trapinithart();   // install kernel trap vector
    80000e1e:	648010ef          	jal	80002466 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000e22:	592040ef          	jal	800053b4 <plicinithart>
  }

  scheduler();        
    80000e26:	667000ef          	jal	80001c8c <scheduler>
    consoleinit();
    80000e2a:	dccff0ef          	jal	800003f6 <consoleinit>
    printfinit();
    80000e2e:	9adff0ef          	jal	800007da <printfinit>
    printf("\n");
    80000e32:	00006517          	auipc	a0,0x6
    80000e36:	28e50513          	add	a0,a0,654 # 800070c0 <digits+0x88>
    80000e3a:	e92ff0ef          	jal	800004cc <printf>
    printf("xv6 kernel is booting\n");
    80000e3e:	00006517          	auipc	a0,0x6
    80000e42:	25a50513          	add	a0,a0,602 # 80007098 <digits+0x60>
    80000e46:	e86ff0ef          	jal	800004cc <printf>
    printf("\n");
    80000e4a:	00006517          	auipc	a0,0x6
    80000e4e:	27650513          	add	a0,a0,630 # 800070c0 <digits+0x88>
    80000e52:	e7aff0ef          	jal	800004cc <printf>
    kinit();         // physical page allocator
    80000e56:	c1bff0ef          	jal	80000a70 <kinit>
    kvminit();       // create kernel page table
    80000e5a:	2ca000ef          	jal	80001124 <kvminit>
    kvminithart();   // turn on paging
    80000e5e:	03c000ef          	jal	80000e9a <kvminithart>
    procinit();      // process table
    80000e62:	0d5000ef          	jal	80001736 <procinit>
    trapinit();      // trap vectors
    80000e66:	5dc010ef          	jal	80002442 <trapinit>
    trapinithart();  // install kernel trap vector
    80000e6a:	5fc010ef          	jal	80002466 <trapinithart>
    plicinit();      // set up interrupt controller
    80000e6e:	530040ef          	jal	8000539e <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000e72:	542040ef          	jal	800053b4 <plicinithart>
    binit();         // buffer cache
    80000e76:	53b010ef          	jal	80002bb0 <binit>
    iinit();         // inode table
    80000e7a:	2a8020ef          	jal	80003122 <iinit>
    fileinit();      // file table
    80000e7e:	160030ef          	jal	80003fde <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000e82:	622040ef          	jal	800054a4 <virtio_disk_init>
    userinit();      // first user process
    80000e86:	455000ef          	jal	80001ada <userinit>
    __sync_synchronize();
    80000e8a:	0ff0000f          	fence
    started = 1;
    80000e8e:	4785                	li	a5,1
    80000e90:	00007717          	auipc	a4,0x7
    80000e94:	9cf72823          	sw	a5,-1584(a4) # 80007860 <started>
    80000e98:	b779                	j	80000e26 <main+0x3e>

0000000080000e9a <kvminithart>:

// Switch the current CPU's h/w page table register to
// the kernel's page table, and enable paging.
void
kvminithart()
{
    80000e9a:	1141                	add	sp,sp,-16
    80000e9c:	e422                	sd	s0,8(sp)
    80000e9e:	0800                	add	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000ea0:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000ea4:	00007797          	auipc	a5,0x7
    80000ea8:	9c47b783          	ld	a5,-1596(a5) # 80007868 <kernel_pagetable>
    80000eac:	83b1                	srl	a5,a5,0xc
    80000eae:	577d                	li	a4,-1
    80000eb0:	177e                	sll	a4,a4,0x3f
    80000eb2:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000eb4:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80000eb8:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80000ebc:	6422                	ld	s0,8(sp)
    80000ebe:	0141                	add	sp,sp,16
    80000ec0:	8082                	ret

0000000080000ec2 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000ec2:	7139                	add	sp,sp,-64
    80000ec4:	fc06                	sd	ra,56(sp)
    80000ec6:	f822                	sd	s0,48(sp)
    80000ec8:	f426                	sd	s1,40(sp)
    80000eca:	f04a                	sd	s2,32(sp)
    80000ecc:	ec4e                	sd	s3,24(sp)
    80000ece:	e852                	sd	s4,16(sp)
    80000ed0:	e456                	sd	s5,8(sp)
    80000ed2:	e05a                	sd	s6,0(sp)
    80000ed4:	0080                	add	s0,sp,64
    80000ed6:	84aa                	mv	s1,a0
    80000ed8:	89ae                	mv	s3,a1
    80000eda:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000edc:	57fd                	li	a5,-1
    80000ede:	83e9                	srl	a5,a5,0x1a
    80000ee0:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000ee2:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000ee4:	02b7fc63          	bgeu	a5,a1,80000f1c <walk+0x5a>
    panic("walk");
    80000ee8:	00006517          	auipc	a0,0x6
    80000eec:	1e050513          	add	a0,a0,480 # 800070c8 <digits+0x90>
    80000ef0:	8afff0ef          	jal	8000079e <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000ef4:	060a8263          	beqz	s5,80000f58 <walk+0x96>
    80000ef8:	badff0ef          	jal	80000aa4 <kalloc>
    80000efc:	84aa                	mv	s1,a0
    80000efe:	c139                	beqz	a0,80000f44 <walk+0x82>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80000f00:	6605                	lui	a2,0x1
    80000f02:	4581                	li	a1,0
    80000f04:	d45ff0ef          	jal	80000c48 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80000f08:	00c4d793          	srl	a5,s1,0xc
    80000f0c:	07aa                	sll	a5,a5,0xa
    80000f0e:	0017e793          	or	a5,a5,1
    80000f12:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80000f16:	3a5d                	addw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffde207>
    80000f18:	036a0063          	beq	s4,s6,80000f38 <walk+0x76>
    pte_t *pte = &pagetable[PX(level, va)];
    80000f1c:	0149d933          	srl	s2,s3,s4
    80000f20:	1ff97913          	and	s2,s2,511
    80000f24:	090e                	sll	s2,s2,0x3
    80000f26:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80000f28:	00093483          	ld	s1,0(s2)
    80000f2c:	0014f793          	and	a5,s1,1
    80000f30:	d3f1                	beqz	a5,80000ef4 <walk+0x32>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000f32:	80a9                	srl	s1,s1,0xa
    80000f34:	04b2                	sll	s1,s1,0xc
    80000f36:	b7c5                	j	80000f16 <walk+0x54>
    }
  }
  return &pagetable[PX(0, va)];
    80000f38:	00c9d513          	srl	a0,s3,0xc
    80000f3c:	1ff57513          	and	a0,a0,511
    80000f40:	050e                	sll	a0,a0,0x3
    80000f42:	9526                	add	a0,a0,s1
}
    80000f44:	70e2                	ld	ra,56(sp)
    80000f46:	7442                	ld	s0,48(sp)
    80000f48:	74a2                	ld	s1,40(sp)
    80000f4a:	7902                	ld	s2,32(sp)
    80000f4c:	69e2                	ld	s3,24(sp)
    80000f4e:	6a42                	ld	s4,16(sp)
    80000f50:	6aa2                	ld	s5,8(sp)
    80000f52:	6b02                	ld	s6,0(sp)
    80000f54:	6121                	add	sp,sp,64
    80000f56:	8082                	ret
        return 0;
    80000f58:	4501                	li	a0,0
    80000f5a:	b7ed                	j	80000f44 <walk+0x82>

0000000080000f5c <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000f5c:	57fd                	li	a5,-1
    80000f5e:	83e9                	srl	a5,a5,0x1a
    80000f60:	00b7f463          	bgeu	a5,a1,80000f68 <walkaddr+0xc>
    return 0;
    80000f64:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000f66:	8082                	ret
{
    80000f68:	1141                	add	sp,sp,-16
    80000f6a:	e406                	sd	ra,8(sp)
    80000f6c:	e022                	sd	s0,0(sp)
    80000f6e:	0800                	add	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000f70:	4601                	li	a2,0
    80000f72:	f51ff0ef          	jal	80000ec2 <walk>
  if(pte == 0)
    80000f76:	c105                	beqz	a0,80000f96 <walkaddr+0x3a>
  if((*pte & PTE_V) == 0)
    80000f78:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000f7a:	0117f693          	and	a3,a5,17
    80000f7e:	4745                	li	a4,17
    return 0;
    80000f80:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000f82:	00e68663          	beq	a3,a4,80000f8e <walkaddr+0x32>
}
    80000f86:	60a2                	ld	ra,8(sp)
    80000f88:	6402                	ld	s0,0(sp)
    80000f8a:	0141                	add	sp,sp,16
    80000f8c:	8082                	ret
  pa = PTE2PA(*pte);
    80000f8e:	83a9                	srl	a5,a5,0xa
    80000f90:	00c79513          	sll	a0,a5,0xc
  return pa;
    80000f94:	bfcd                	j	80000f86 <walkaddr+0x2a>
    return 0;
    80000f96:	4501                	li	a0,0
    80000f98:	b7fd                	j	80000f86 <walkaddr+0x2a>

0000000080000f9a <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000f9a:	715d                	add	sp,sp,-80
    80000f9c:	e486                	sd	ra,72(sp)
    80000f9e:	e0a2                	sd	s0,64(sp)
    80000fa0:	fc26                	sd	s1,56(sp)
    80000fa2:	f84a                	sd	s2,48(sp)
    80000fa4:	f44e                	sd	s3,40(sp)
    80000fa6:	f052                	sd	s4,32(sp)
    80000fa8:	ec56                	sd	s5,24(sp)
    80000faa:	e85a                	sd	s6,16(sp)
    80000fac:	e45e                	sd	s7,8(sp)
    80000fae:	0880                	add	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000fb0:	03459793          	sll	a5,a1,0x34
    80000fb4:	e7a9                	bnez	a5,80000ffe <mappages+0x64>
    80000fb6:	8aaa                	mv	s5,a0
    80000fb8:	8b3a                	mv	s6,a4
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    80000fba:	03461793          	sll	a5,a2,0x34
    80000fbe:	e7b1                	bnez	a5,8000100a <mappages+0x70>
    panic("mappages: size not aligned");

  if(size == 0)
    80000fc0:	ca39                	beqz	a2,80001016 <mappages+0x7c>
    panic("mappages: size");
  
  a = va;
  last = va + size - PGSIZE;
    80000fc2:	77fd                	lui	a5,0xfffff
    80000fc4:	963e                	add	a2,a2,a5
    80000fc6:	00b609b3          	add	s3,a2,a1
  a = va;
    80000fca:	892e                	mv	s2,a1
    80000fcc:	40b68a33          	sub	s4,a3,a1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80000fd0:	6b85                	lui	s7,0x1
    80000fd2:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    80000fd6:	4605                	li	a2,1
    80000fd8:	85ca                	mv	a1,s2
    80000fda:	8556                	mv	a0,s5
    80000fdc:	ee7ff0ef          	jal	80000ec2 <walk>
    80000fe0:	c539                	beqz	a0,8000102e <mappages+0x94>
    if(*pte & PTE_V)
    80000fe2:	611c                	ld	a5,0(a0)
    80000fe4:	8b85                	and	a5,a5,1
    80000fe6:	ef95                	bnez	a5,80001022 <mappages+0x88>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80000fe8:	80b1                	srl	s1,s1,0xc
    80000fea:	04aa                	sll	s1,s1,0xa
    80000fec:	0164e4b3          	or	s1,s1,s6
    80000ff0:	0014e493          	or	s1,s1,1
    80000ff4:	e104                	sd	s1,0(a0)
    if(a == last)
    80000ff6:	05390863          	beq	s2,s3,80001046 <mappages+0xac>
    a += PGSIZE;
    80000ffa:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    80000ffc:	bfd9                	j	80000fd2 <mappages+0x38>
    panic("mappages: va not aligned");
    80000ffe:	00006517          	auipc	a0,0x6
    80001002:	0d250513          	add	a0,a0,210 # 800070d0 <digits+0x98>
    80001006:	f98ff0ef          	jal	8000079e <panic>
    panic("mappages: size not aligned");
    8000100a:	00006517          	auipc	a0,0x6
    8000100e:	0e650513          	add	a0,a0,230 # 800070f0 <digits+0xb8>
    80001012:	f8cff0ef          	jal	8000079e <panic>
    panic("mappages: size");
    80001016:	00006517          	auipc	a0,0x6
    8000101a:	0fa50513          	add	a0,a0,250 # 80007110 <digits+0xd8>
    8000101e:	f80ff0ef          	jal	8000079e <panic>
      panic("mappages: remap");
    80001022:	00006517          	auipc	a0,0x6
    80001026:	0fe50513          	add	a0,a0,254 # 80007120 <digits+0xe8>
    8000102a:	f74ff0ef          	jal	8000079e <panic>
      return -1;
    8000102e:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    80001030:	60a6                	ld	ra,72(sp)
    80001032:	6406                	ld	s0,64(sp)
    80001034:	74e2                	ld	s1,56(sp)
    80001036:	7942                	ld	s2,48(sp)
    80001038:	79a2                	ld	s3,40(sp)
    8000103a:	7a02                	ld	s4,32(sp)
    8000103c:	6ae2                	ld	s5,24(sp)
    8000103e:	6b42                	ld	s6,16(sp)
    80001040:	6ba2                	ld	s7,8(sp)
    80001042:	6161                	add	sp,sp,80
    80001044:	8082                	ret
  return 0;
    80001046:	4501                	li	a0,0
    80001048:	b7e5                	j	80001030 <mappages+0x96>

000000008000104a <kvmmap>:
{
    8000104a:	1141                	add	sp,sp,-16
    8000104c:	e406                	sd	ra,8(sp)
    8000104e:	e022                	sd	s0,0(sp)
    80001050:	0800                	add	s0,sp,16
    80001052:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80001054:	86b2                	mv	a3,a2
    80001056:	863e                	mv	a2,a5
    80001058:	f43ff0ef          	jal	80000f9a <mappages>
    8000105c:	e509                	bnez	a0,80001066 <kvmmap+0x1c>
}
    8000105e:	60a2                	ld	ra,8(sp)
    80001060:	6402                	ld	s0,0(sp)
    80001062:	0141                	add	sp,sp,16
    80001064:	8082                	ret
    panic("kvmmap");
    80001066:	00006517          	auipc	a0,0x6
    8000106a:	0ca50513          	add	a0,a0,202 # 80007130 <digits+0xf8>
    8000106e:	f30ff0ef          	jal	8000079e <panic>

0000000080001072 <kvmmake>:
{
    80001072:	1101                	add	sp,sp,-32
    80001074:	ec06                	sd	ra,24(sp)
    80001076:	e822                	sd	s0,16(sp)
    80001078:	e426                	sd	s1,8(sp)
    8000107a:	e04a                	sd	s2,0(sp)
    8000107c:	1000                	add	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    8000107e:	a27ff0ef          	jal	80000aa4 <kalloc>
    80001082:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80001084:	6605                	lui	a2,0x1
    80001086:	4581                	li	a1,0
    80001088:	bc1ff0ef          	jal	80000c48 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000108c:	4719                	li	a4,6
    8000108e:	6685                	lui	a3,0x1
    80001090:	10000637          	lui	a2,0x10000
    80001094:	100005b7          	lui	a1,0x10000
    80001098:	8526                	mv	a0,s1
    8000109a:	fb1ff0ef          	jal	8000104a <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000109e:	4719                	li	a4,6
    800010a0:	6685                	lui	a3,0x1
    800010a2:	10001637          	lui	a2,0x10001
    800010a6:	100015b7          	lui	a1,0x10001
    800010aa:	8526                	mv	a0,s1
    800010ac:	f9fff0ef          	jal	8000104a <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    800010b0:	4719                	li	a4,6
    800010b2:	040006b7          	lui	a3,0x4000
    800010b6:	0c000637          	lui	a2,0xc000
    800010ba:	0c0005b7          	lui	a1,0xc000
    800010be:	8526                	mv	a0,s1
    800010c0:	f8bff0ef          	jal	8000104a <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800010c4:	00006917          	auipc	s2,0x6
    800010c8:	f3c90913          	add	s2,s2,-196 # 80007000 <etext>
    800010cc:	4729                	li	a4,10
    800010ce:	80006697          	auipc	a3,0x80006
    800010d2:	f3268693          	add	a3,a3,-206 # 7000 <_entry-0x7fff9000>
    800010d6:	4605                	li	a2,1
    800010d8:	067e                	sll	a2,a2,0x1f
    800010da:	85b2                	mv	a1,a2
    800010dc:	8526                	mv	a0,s1
    800010de:	f6dff0ef          	jal	8000104a <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800010e2:	4719                	li	a4,6
    800010e4:	46c5                	li	a3,17
    800010e6:	06ee                	sll	a3,a3,0x1b
    800010e8:	412686b3          	sub	a3,a3,s2
    800010ec:	864a                	mv	a2,s2
    800010ee:	85ca                	mv	a1,s2
    800010f0:	8526                	mv	a0,s1
    800010f2:	f59ff0ef          	jal	8000104a <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800010f6:	4729                	li	a4,10
    800010f8:	6685                	lui	a3,0x1
    800010fa:	00005617          	auipc	a2,0x5
    800010fe:	f0660613          	add	a2,a2,-250 # 80006000 <_trampoline>
    80001102:	040005b7          	lui	a1,0x4000
    80001106:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001108:	05b2                	sll	a1,a1,0xc
    8000110a:	8526                	mv	a0,s1
    8000110c:	f3fff0ef          	jal	8000104a <kvmmap>
  proc_mapstacks(kpgtbl);
    80001110:	8526                	mv	a0,s1
    80001112:	59a000ef          	jal	800016ac <proc_mapstacks>
}
    80001116:	8526                	mv	a0,s1
    80001118:	60e2                	ld	ra,24(sp)
    8000111a:	6442                	ld	s0,16(sp)
    8000111c:	64a2                	ld	s1,8(sp)
    8000111e:	6902                	ld	s2,0(sp)
    80001120:	6105                	add	sp,sp,32
    80001122:	8082                	ret

0000000080001124 <kvminit>:
{
    80001124:	1141                	add	sp,sp,-16
    80001126:	e406                	sd	ra,8(sp)
    80001128:	e022                	sd	s0,0(sp)
    8000112a:	0800                	add	s0,sp,16
  kernel_pagetable = kvmmake();
    8000112c:	f47ff0ef          	jal	80001072 <kvmmake>
    80001130:	00006797          	auipc	a5,0x6
    80001134:	72a7bc23          	sd	a0,1848(a5) # 80007868 <kernel_pagetable>
}
    80001138:	60a2                	ld	ra,8(sp)
    8000113a:	6402                	ld	s0,0(sp)
    8000113c:	0141                	add	sp,sp,16
    8000113e:	8082                	ret

0000000080001140 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80001140:	1101                	add	sp,sp,-32
    80001142:	ec06                	sd	ra,24(sp)
    80001144:	e822                	sd	s0,16(sp)
    80001146:	e426                	sd	s1,8(sp)
    80001148:	1000                	add	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    8000114a:	95bff0ef          	jal	80000aa4 <kalloc>
    8000114e:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001150:	c509                	beqz	a0,8000115a <uvmcreate+0x1a>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80001152:	6605                	lui	a2,0x1
    80001154:	4581                	li	a1,0
    80001156:	af3ff0ef          	jal	80000c48 <memset>
  return pagetable;
}
    8000115a:	8526                	mv	a0,s1
    8000115c:	60e2                	ld	ra,24(sp)
    8000115e:	6442                	ld	s0,16(sp)
    80001160:	64a2                	ld	s1,8(sp)
    80001162:	6105                	add	sp,sp,32
    80001164:	8082                	ret

0000000080001166 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. It's OK if the mappings don't exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80001166:	7139                	add	sp,sp,-64
    80001168:	fc06                	sd	ra,56(sp)
    8000116a:	f822                	sd	s0,48(sp)
    8000116c:	f426                	sd	s1,40(sp)
    8000116e:	f04a                	sd	s2,32(sp)
    80001170:	ec4e                	sd	s3,24(sp)
    80001172:	e852                	sd	s4,16(sp)
    80001174:	e456                	sd	s5,8(sp)
    80001176:	e05a                	sd	s6,0(sp)
    80001178:	0080                	add	s0,sp,64
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    8000117a:	03459793          	sll	a5,a1,0x34
    8000117e:	e785                	bnez	a5,800011a6 <uvmunmap+0x40>
    80001180:	8a2a                	mv	s4,a0
    80001182:	892e                	mv	s2,a1
    80001184:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001186:	0632                	sll	a2,a2,0xc
    80001188:	00b609b3          	add	s3,a2,a1
    8000118c:	6b05                	lui	s6,0x1
    8000118e:	0335e763          	bltu	a1,s3,800011bc <uvmunmap+0x56>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    80001192:	70e2                	ld	ra,56(sp)
    80001194:	7442                	ld	s0,48(sp)
    80001196:	74a2                	ld	s1,40(sp)
    80001198:	7902                	ld	s2,32(sp)
    8000119a:	69e2                	ld	s3,24(sp)
    8000119c:	6a42                	ld	s4,16(sp)
    8000119e:	6aa2                	ld	s5,8(sp)
    800011a0:	6b02                	ld	s6,0(sp)
    800011a2:	6121                	add	sp,sp,64
    800011a4:	8082                	ret
    panic("uvmunmap: not aligned");
    800011a6:	00006517          	auipc	a0,0x6
    800011aa:	f9250513          	add	a0,a0,-110 # 80007138 <digits+0x100>
    800011ae:	df0ff0ef          	jal	8000079e <panic>
    *pte = 0;
    800011b2:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800011b6:	995a                	add	s2,s2,s6
    800011b8:	fd397de3          	bgeu	s2,s3,80001192 <uvmunmap+0x2c>
    if((pte = walk(pagetable, a, 0)) == 0) // leaf page table entry allocated?
    800011bc:	4601                	li	a2,0
    800011be:	85ca                	mv	a1,s2
    800011c0:	8552                	mv	a0,s4
    800011c2:	d01ff0ef          	jal	80000ec2 <walk>
    800011c6:	84aa                	mv	s1,a0
    800011c8:	d57d                	beqz	a0,800011b6 <uvmunmap+0x50>
    if((*pte & PTE_V) == 0)  // has physical page been allocated?
    800011ca:	611c                	ld	a5,0(a0)
    800011cc:	0017f713          	and	a4,a5,1
    800011d0:	d37d                	beqz	a4,800011b6 <uvmunmap+0x50>
    if(do_free){
    800011d2:	fe0a80e3          	beqz	s5,800011b2 <uvmunmap+0x4c>
      uint64 pa = PTE2PA(*pte);
    800011d6:	83a9                	srl	a5,a5,0xa
      kfree((void*)pa);
    800011d8:	00c79513          	sll	a0,a5,0xc
    800011dc:	fe6ff0ef          	jal	800009c2 <kfree>
    800011e0:	bfc9                	j	800011b2 <uvmunmap+0x4c>

00000000800011e2 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800011e2:	1101                	add	sp,sp,-32
    800011e4:	ec06                	sd	ra,24(sp)
    800011e6:	e822                	sd	s0,16(sp)
    800011e8:	e426                	sd	s1,8(sp)
    800011ea:	1000                	add	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800011ec:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800011ee:	00b67d63          	bgeu	a2,a1,80001208 <uvmdealloc+0x26>
    800011f2:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800011f4:	6785                	lui	a5,0x1
    800011f6:	17fd                	add	a5,a5,-1 # fff <_entry-0x7ffff001>
    800011f8:	00f60733          	add	a4,a2,a5
    800011fc:	76fd                	lui	a3,0xfffff
    800011fe:	8f75                	and	a4,a4,a3
    80001200:	97ae                	add	a5,a5,a1
    80001202:	8ff5                	and	a5,a5,a3
    80001204:	00f76863          	bltu	a4,a5,80001214 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80001208:	8526                	mv	a0,s1
    8000120a:	60e2                	ld	ra,24(sp)
    8000120c:	6442                	ld	s0,16(sp)
    8000120e:	64a2                	ld	s1,8(sp)
    80001210:	6105                	add	sp,sp,32
    80001212:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80001214:	8f99                	sub	a5,a5,a4
    80001216:	83b1                	srl	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80001218:	4685                	li	a3,1
    8000121a:	0007861b          	sext.w	a2,a5
    8000121e:	85ba                	mv	a1,a4
    80001220:	f47ff0ef          	jal	80001166 <uvmunmap>
    80001224:	b7d5                	j	80001208 <uvmdealloc+0x26>

0000000080001226 <uvmalloc>:
  if(newsz < oldsz)
    80001226:	08b66963          	bltu	a2,a1,800012b8 <uvmalloc+0x92>
{
    8000122a:	7139                	add	sp,sp,-64
    8000122c:	fc06                	sd	ra,56(sp)
    8000122e:	f822                	sd	s0,48(sp)
    80001230:	f426                	sd	s1,40(sp)
    80001232:	f04a                	sd	s2,32(sp)
    80001234:	ec4e                	sd	s3,24(sp)
    80001236:	e852                	sd	s4,16(sp)
    80001238:	e456                	sd	s5,8(sp)
    8000123a:	e05a                	sd	s6,0(sp)
    8000123c:	0080                	add	s0,sp,64
    8000123e:	8aaa                	mv	s5,a0
    80001240:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80001242:	6785                	lui	a5,0x1
    80001244:	17fd                	add	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001246:	95be                	add	a1,a1,a5
    80001248:	77fd                	lui	a5,0xfffff
    8000124a:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000124e:	06c9f763          	bgeu	s3,a2,800012bc <uvmalloc+0x96>
    80001252:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80001254:	0126eb13          	or	s6,a3,18
    mem = kalloc();
    80001258:	84dff0ef          	jal	80000aa4 <kalloc>
    8000125c:	84aa                	mv	s1,a0
    if(mem == 0){
    8000125e:	c11d                	beqz	a0,80001284 <uvmalloc+0x5e>
    memset(mem, 0, PGSIZE);
    80001260:	6605                	lui	a2,0x1
    80001262:	4581                	li	a1,0
    80001264:	9e5ff0ef          	jal	80000c48 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80001268:	875a                	mv	a4,s6
    8000126a:	86a6                	mv	a3,s1
    8000126c:	6605                	lui	a2,0x1
    8000126e:	85ca                	mv	a1,s2
    80001270:	8556                	mv	a0,s5
    80001272:	d29ff0ef          	jal	80000f9a <mappages>
    80001276:	e51d                	bnez	a0,800012a4 <uvmalloc+0x7e>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001278:	6785                	lui	a5,0x1
    8000127a:	993e                	add	s2,s2,a5
    8000127c:	fd496ee3          	bltu	s2,s4,80001258 <uvmalloc+0x32>
  return newsz;
    80001280:	8552                	mv	a0,s4
    80001282:	a039                	j	80001290 <uvmalloc+0x6a>
      uvmdealloc(pagetable, a, oldsz);
    80001284:	864e                	mv	a2,s3
    80001286:	85ca                	mv	a1,s2
    80001288:	8556                	mv	a0,s5
    8000128a:	f59ff0ef          	jal	800011e2 <uvmdealloc>
      return 0;
    8000128e:	4501                	li	a0,0
}
    80001290:	70e2                	ld	ra,56(sp)
    80001292:	7442                	ld	s0,48(sp)
    80001294:	74a2                	ld	s1,40(sp)
    80001296:	7902                	ld	s2,32(sp)
    80001298:	69e2                	ld	s3,24(sp)
    8000129a:	6a42                	ld	s4,16(sp)
    8000129c:	6aa2                	ld	s5,8(sp)
    8000129e:	6b02                	ld	s6,0(sp)
    800012a0:	6121                	add	sp,sp,64
    800012a2:	8082                	ret
      kfree(mem);
    800012a4:	8526                	mv	a0,s1
    800012a6:	f1cff0ef          	jal	800009c2 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    800012aa:	864e                	mv	a2,s3
    800012ac:	85ca                	mv	a1,s2
    800012ae:	8556                	mv	a0,s5
    800012b0:	f33ff0ef          	jal	800011e2 <uvmdealloc>
      return 0;
    800012b4:	4501                	li	a0,0
    800012b6:	bfe9                	j	80001290 <uvmalloc+0x6a>
    return oldsz;
    800012b8:	852e                	mv	a0,a1
}
    800012ba:	8082                	ret
  return newsz;
    800012bc:	8532                	mv	a0,a2
    800012be:	bfc9                	j	80001290 <uvmalloc+0x6a>

00000000800012c0 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    800012c0:	7179                	add	sp,sp,-48
    800012c2:	f406                	sd	ra,40(sp)
    800012c4:	f022                	sd	s0,32(sp)
    800012c6:	ec26                	sd	s1,24(sp)
    800012c8:	e84a                	sd	s2,16(sp)
    800012ca:	e44e                	sd	s3,8(sp)
    800012cc:	e052                	sd	s4,0(sp)
    800012ce:	1800                	add	s0,sp,48
    800012d0:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800012d2:	84aa                	mv	s1,a0
    800012d4:	6905                	lui	s2,0x1
    800012d6:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800012d8:	4985                	li	s3,1
    800012da:	a819                	j	800012f0 <freewalk+0x30>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800012dc:	83a9                	srl	a5,a5,0xa
      freewalk((pagetable_t)child);
    800012de:	00c79513          	sll	a0,a5,0xc
    800012e2:	fdfff0ef          	jal	800012c0 <freewalk>
      pagetable[i] = 0;
    800012e6:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800012ea:	04a1                	add	s1,s1,8
    800012ec:	01248f63          	beq	s1,s2,8000130a <freewalk+0x4a>
    pte_t pte = pagetable[i];
    800012f0:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800012f2:	00f7f713          	and	a4,a5,15
    800012f6:	ff3703e3          	beq	a4,s3,800012dc <freewalk+0x1c>
    } else if(pte & PTE_V){
    800012fa:	8b85                	and	a5,a5,1
    800012fc:	d7fd                	beqz	a5,800012ea <freewalk+0x2a>
      panic("freewalk: leaf");
    800012fe:	00006517          	auipc	a0,0x6
    80001302:	e5250513          	add	a0,a0,-430 # 80007150 <digits+0x118>
    80001306:	c98ff0ef          	jal	8000079e <panic>
    }
  }
  kfree((void*)pagetable);
    8000130a:	8552                	mv	a0,s4
    8000130c:	eb6ff0ef          	jal	800009c2 <kfree>
}
    80001310:	70a2                	ld	ra,40(sp)
    80001312:	7402                	ld	s0,32(sp)
    80001314:	64e2                	ld	s1,24(sp)
    80001316:	6942                	ld	s2,16(sp)
    80001318:	69a2                	ld	s3,8(sp)
    8000131a:	6a02                	ld	s4,0(sp)
    8000131c:	6145                	add	sp,sp,48
    8000131e:	8082                	ret

0000000080001320 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80001320:	1101                	add	sp,sp,-32
    80001322:	ec06                	sd	ra,24(sp)
    80001324:	e822                	sd	s0,16(sp)
    80001326:	e426                	sd	s1,8(sp)
    80001328:	1000                	add	s0,sp,32
    8000132a:	84aa                	mv	s1,a0
  if(sz > 0)
    8000132c:	e989                	bnez	a1,8000133e <uvmfree+0x1e>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    8000132e:	8526                	mv	a0,s1
    80001330:	f91ff0ef          	jal	800012c0 <freewalk>
}
    80001334:	60e2                	ld	ra,24(sp)
    80001336:	6442                	ld	s0,16(sp)
    80001338:	64a2                	ld	s1,8(sp)
    8000133a:	6105                	add	sp,sp,32
    8000133c:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    8000133e:	6785                	lui	a5,0x1
    80001340:	17fd                	add	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001342:	95be                	add	a1,a1,a5
    80001344:	4685                	li	a3,1
    80001346:	00c5d613          	srl	a2,a1,0xc
    8000134a:	4581                	li	a1,0
    8000134c:	e1bff0ef          	jal	80001166 <uvmunmap>
    80001350:	bff9                	j	8000132e <uvmfree+0xe>

0000000080001352 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80001352:	ce49                	beqz	a2,800013ec <uvmcopy+0x9a>
{
    80001354:	715d                	add	sp,sp,-80
    80001356:	e486                	sd	ra,72(sp)
    80001358:	e0a2                	sd	s0,64(sp)
    8000135a:	fc26                	sd	s1,56(sp)
    8000135c:	f84a                	sd	s2,48(sp)
    8000135e:	f44e                	sd	s3,40(sp)
    80001360:	f052                	sd	s4,32(sp)
    80001362:	ec56                	sd	s5,24(sp)
    80001364:	e85a                	sd	s6,16(sp)
    80001366:	e45e                	sd	s7,8(sp)
    80001368:	0880                	add	s0,sp,80
    8000136a:	8aaa                	mv	s5,a0
    8000136c:	8b2e                	mv	s6,a1
    8000136e:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80001370:	4481                	li	s1,0
    80001372:	a029                	j	8000137c <uvmcopy+0x2a>
    80001374:	6785                	lui	a5,0x1
    80001376:	94be                	add	s1,s1,a5
    80001378:	0544fe63          	bgeu	s1,s4,800013d4 <uvmcopy+0x82>
    if((pte = walk(old, i, 0)) == 0)
    8000137c:	4601                	li	a2,0
    8000137e:	85a6                	mv	a1,s1
    80001380:	8556                	mv	a0,s5
    80001382:	b41ff0ef          	jal	80000ec2 <walk>
    80001386:	d57d                	beqz	a0,80001374 <uvmcopy+0x22>
      continue;   // page table entry hasn't been allocated
    if((*pte & PTE_V) == 0)
    80001388:	6118                	ld	a4,0(a0)
    8000138a:	00177793          	and	a5,a4,1
    8000138e:	d3fd                	beqz	a5,80001374 <uvmcopy+0x22>
      continue;   // physical page hasn't been allocated
    pa = PTE2PA(*pte);
    80001390:	00a75593          	srl	a1,a4,0xa
    80001394:	00c59b93          	sll	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80001398:	3ff77913          	and	s2,a4,1023
    if((mem = kalloc()) == 0)
    8000139c:	f08ff0ef          	jal	80000aa4 <kalloc>
    800013a0:	89aa                	mv	s3,a0
    800013a2:	c105                	beqz	a0,800013c2 <uvmcopy+0x70>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    800013a4:	6605                	lui	a2,0x1
    800013a6:	85de                	mv	a1,s7
    800013a8:	8fdff0ef          	jal	80000ca4 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    800013ac:	874a                	mv	a4,s2
    800013ae:	86ce                	mv	a3,s3
    800013b0:	6605                	lui	a2,0x1
    800013b2:	85a6                	mv	a1,s1
    800013b4:	855a                	mv	a0,s6
    800013b6:	be5ff0ef          	jal	80000f9a <mappages>
    800013ba:	dd4d                	beqz	a0,80001374 <uvmcopy+0x22>
      kfree(mem);
    800013bc:	854e                	mv	a0,s3
    800013be:	e04ff0ef          	jal	800009c2 <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    800013c2:	4685                	li	a3,1
    800013c4:	00c4d613          	srl	a2,s1,0xc
    800013c8:	4581                	li	a1,0
    800013ca:	855a                	mv	a0,s6
    800013cc:	d9bff0ef          	jal	80001166 <uvmunmap>
  return -1;
    800013d0:	557d                	li	a0,-1
    800013d2:	a011                	j	800013d6 <uvmcopy+0x84>
  return 0;
    800013d4:	4501                	li	a0,0
}
    800013d6:	60a6                	ld	ra,72(sp)
    800013d8:	6406                	ld	s0,64(sp)
    800013da:	74e2                	ld	s1,56(sp)
    800013dc:	7942                	ld	s2,48(sp)
    800013de:	79a2                	ld	s3,40(sp)
    800013e0:	7a02                	ld	s4,32(sp)
    800013e2:	6ae2                	ld	s5,24(sp)
    800013e4:	6b42                	ld	s6,16(sp)
    800013e6:	6ba2                	ld	s7,8(sp)
    800013e8:	6161                	add	sp,sp,80
    800013ea:	8082                	ret
  return 0;
    800013ec:	4501                	li	a0,0
}
    800013ee:	8082                	ret

00000000800013f0 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    800013f0:	1141                	add	sp,sp,-16
    800013f2:	e406                	sd	ra,8(sp)
    800013f4:	e022                	sd	s0,0(sp)
    800013f6:	0800                	add	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    800013f8:	4601                	li	a2,0
    800013fa:	ac9ff0ef          	jal	80000ec2 <walk>
  if(pte == 0)
    800013fe:	c901                	beqz	a0,8000140e <uvmclear+0x1e>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80001400:	611c                	ld	a5,0(a0)
    80001402:	9bbd                	and	a5,a5,-17
    80001404:	e11c                	sd	a5,0(a0)
}
    80001406:	60a2                	ld	ra,8(sp)
    80001408:	6402                	ld	s0,0(sp)
    8000140a:	0141                	add	sp,sp,16
    8000140c:	8082                	ret
    panic("uvmclear");
    8000140e:	00006517          	auipc	a0,0x6
    80001412:	d5250513          	add	a0,a0,-686 # 80007160 <digits+0x128>
    80001416:	b88ff0ef          	jal	8000079e <panic>

000000008000141a <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    8000141a:	c2cd                	beqz	a3,800014bc <copyinstr+0xa2>
{
    8000141c:	715d                	add	sp,sp,-80
    8000141e:	e486                	sd	ra,72(sp)
    80001420:	e0a2                	sd	s0,64(sp)
    80001422:	fc26                	sd	s1,56(sp)
    80001424:	f84a                	sd	s2,48(sp)
    80001426:	f44e                	sd	s3,40(sp)
    80001428:	f052                	sd	s4,32(sp)
    8000142a:	ec56                	sd	s5,24(sp)
    8000142c:	e85a                	sd	s6,16(sp)
    8000142e:	e45e                	sd	s7,8(sp)
    80001430:	0880                	add	s0,sp,80
    80001432:	8a2a                	mv	s4,a0
    80001434:	8b2e                	mv	s6,a1
    80001436:	8bb2                	mv	s7,a2
    80001438:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    8000143a:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    8000143c:	6985                	lui	s3,0x1
    8000143e:	a02d                	j	80001468 <copyinstr+0x4e>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80001440:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80001444:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80001446:	37fd                	addw	a5,a5,-1
    80001448:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    8000144c:	60a6                	ld	ra,72(sp)
    8000144e:	6406                	ld	s0,64(sp)
    80001450:	74e2                	ld	s1,56(sp)
    80001452:	7942                	ld	s2,48(sp)
    80001454:	79a2                	ld	s3,40(sp)
    80001456:	7a02                	ld	s4,32(sp)
    80001458:	6ae2                	ld	s5,24(sp)
    8000145a:	6b42                	ld	s6,16(sp)
    8000145c:	6ba2                	ld	s7,8(sp)
    8000145e:	6161                	add	sp,sp,80
    80001460:	8082                	ret
    srcva = va0 + PGSIZE;
    80001462:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80001466:	c4b9                	beqz	s1,800014b4 <copyinstr+0x9a>
    va0 = PGROUNDDOWN(srcva);
    80001468:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    8000146c:	85ca                	mv	a1,s2
    8000146e:	8552                	mv	a0,s4
    80001470:	aedff0ef          	jal	80000f5c <walkaddr>
    if(pa0 == 0)
    80001474:	c131                	beqz	a0,800014b8 <copyinstr+0x9e>
    n = PGSIZE - (srcva - va0);
    80001476:	417906b3          	sub	a3,s2,s7
    8000147a:	96ce                	add	a3,a3,s3
    8000147c:	00d4f363          	bgeu	s1,a3,80001482 <copyinstr+0x68>
    80001480:	86a6                	mv	a3,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80001482:	955e                	add	a0,a0,s7
    80001484:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80001488:	dee9                	beqz	a3,80001462 <copyinstr+0x48>
    8000148a:	87da                	mv	a5,s6
    8000148c:	885a                	mv	a6,s6
      if(*p == '\0'){
    8000148e:	41650633          	sub	a2,a0,s6
    while(n > 0){
    80001492:	96da                	add	a3,a3,s6
    80001494:	85be                	mv	a1,a5
      if(*p == '\0'){
    80001496:	00f60733          	add	a4,a2,a5
    8000149a:	00074703          	lbu	a4,0(a4)
    8000149e:	d34d                	beqz	a4,80001440 <copyinstr+0x26>
        *dst = *p;
    800014a0:	00e78023          	sb	a4,0(a5)
      dst++;
    800014a4:	0785                	add	a5,a5,1
    while(n > 0){
    800014a6:	fed797e3          	bne	a5,a3,80001494 <copyinstr+0x7a>
    800014aa:	14fd                	add	s1,s1,-1
    800014ac:	94c2                	add	s1,s1,a6
      --max;
    800014ae:	8c8d                	sub	s1,s1,a1
      dst++;
    800014b0:	8b3e                	mv	s6,a5
    800014b2:	bf45                	j	80001462 <copyinstr+0x48>
    800014b4:	4781                	li	a5,0
    800014b6:	bf41                	j	80001446 <copyinstr+0x2c>
      return -1;
    800014b8:	557d                	li	a0,-1
    800014ba:	bf49                	j	8000144c <copyinstr+0x32>
  int got_null = 0;
    800014bc:	4781                	li	a5,0
  if(got_null){
    800014be:	37fd                	addw	a5,a5,-1
    800014c0:	0007851b          	sext.w	a0,a5
}
    800014c4:	8082                	ret

00000000800014c6 <ismapped>:
  return mem;
}

int
ismapped(pagetable_t pagetable, uint64 va)
{
    800014c6:	1141                	add	sp,sp,-16
    800014c8:	e406                	sd	ra,8(sp)
    800014ca:	e022                	sd	s0,0(sp)
    800014cc:	0800                	add	s0,sp,16
  pte_t *pte = walk(pagetable, va, 0);
    800014ce:	4601                	li	a2,0
    800014d0:	9f3ff0ef          	jal	80000ec2 <walk>
  if (pte == 0) {
    800014d4:	c519                	beqz	a0,800014e2 <ismapped+0x1c>
    return 0;
  }
  if (*pte & PTE_V){
    800014d6:	6108                	ld	a0,0(a0)
    800014d8:	8905                	and	a0,a0,1
    return 1;
  }
  return 0;
}
    800014da:	60a2                	ld	ra,8(sp)
    800014dc:	6402                	ld	s0,0(sp)
    800014de:	0141                	add	sp,sp,16
    800014e0:	8082                	ret
    return 0;
    800014e2:	4501                	li	a0,0
    800014e4:	bfdd                	j	800014da <ismapped+0x14>

00000000800014e6 <vmfault>:
{
    800014e6:	7179                	add	sp,sp,-48
    800014e8:	f406                	sd	ra,40(sp)
    800014ea:	f022                	sd	s0,32(sp)
    800014ec:	ec26                	sd	s1,24(sp)
    800014ee:	e84a                	sd	s2,16(sp)
    800014f0:	e44e                	sd	s3,8(sp)
    800014f2:	e052                	sd	s4,0(sp)
    800014f4:	1800                	add	s0,sp,48
    800014f6:	89aa                	mv	s3,a0
    800014f8:	84ae                	mv	s1,a1
  struct proc *p = myproc();
    800014fa:	310000ef          	jal	8000180a <myproc>
  if (va >= p->sz)
    800014fe:	653c                	ld	a5,72(a0)
    80001500:	00f4ec63          	bltu	s1,a5,80001518 <vmfault+0x32>
    return 0;
    80001504:	4981                	li	s3,0
}
    80001506:	854e                	mv	a0,s3
    80001508:	70a2                	ld	ra,40(sp)
    8000150a:	7402                	ld	s0,32(sp)
    8000150c:	64e2                	ld	s1,24(sp)
    8000150e:	6942                	ld	s2,16(sp)
    80001510:	69a2                	ld	s3,8(sp)
    80001512:	6a02                	ld	s4,0(sp)
    80001514:	6145                	add	sp,sp,48
    80001516:	8082                	ret
    80001518:	892a                	mv	s2,a0
  va = PGROUNDDOWN(va);
    8000151a:	77fd                	lui	a5,0xfffff
    8000151c:	8cfd                	and	s1,s1,a5
  if(ismapped(pagetable, va)) {
    8000151e:	85a6                	mv	a1,s1
    80001520:	854e                	mv	a0,s3
    80001522:	fa5ff0ef          	jal	800014c6 <ismapped>
    return 0;
    80001526:	4981                	li	s3,0
  if(ismapped(pagetable, va)) {
    80001528:	fd79                	bnez	a0,80001506 <vmfault+0x20>
  mem = (uint64) kalloc();
    8000152a:	d7aff0ef          	jal	80000aa4 <kalloc>
    8000152e:	8a2a                	mv	s4,a0
  if(mem == 0)
    80001530:	d979                	beqz	a0,80001506 <vmfault+0x20>
  mem = (uint64) kalloc();
    80001532:	89aa                	mv	s3,a0
  memset((void *) mem, 0, PGSIZE);
    80001534:	6605                	lui	a2,0x1
    80001536:	4581                	li	a1,0
    80001538:	f10ff0ef          	jal	80000c48 <memset>
  if (mappages(p->pagetable, va, PGSIZE, mem, PTE_W|PTE_U|PTE_R) != 0) {
    8000153c:	4759                	li	a4,22
    8000153e:	86d2                	mv	a3,s4
    80001540:	6605                	lui	a2,0x1
    80001542:	85a6                	mv	a1,s1
    80001544:	05093503          	ld	a0,80(s2) # 1050 <_entry-0x7fffefb0>
    80001548:	a53ff0ef          	jal	80000f9a <mappages>
    8000154c:	dd4d                	beqz	a0,80001506 <vmfault+0x20>
    kfree((void *)mem);
    8000154e:	8552                	mv	a0,s4
    80001550:	c72ff0ef          	jal	800009c2 <kfree>
    return 0;
    80001554:	4981                	li	s3,0
    80001556:	bf45                	j	80001506 <vmfault+0x20>

0000000080001558 <copyout>:
  while(len > 0){
    80001558:	cec1                	beqz	a3,800015f0 <copyout+0x98>
{
    8000155a:	711d                	add	sp,sp,-96
    8000155c:	ec86                	sd	ra,88(sp)
    8000155e:	e8a2                	sd	s0,80(sp)
    80001560:	e4a6                	sd	s1,72(sp)
    80001562:	e0ca                	sd	s2,64(sp)
    80001564:	fc4e                	sd	s3,56(sp)
    80001566:	f852                	sd	s4,48(sp)
    80001568:	f456                	sd	s5,40(sp)
    8000156a:	f05a                	sd	s6,32(sp)
    8000156c:	ec5e                	sd	s7,24(sp)
    8000156e:	e862                	sd	s8,16(sp)
    80001570:	e466                	sd	s9,8(sp)
    80001572:	e06a                	sd	s10,0(sp)
    80001574:	1080                	add	s0,sp,96
    80001576:	8c2a                	mv	s8,a0
    80001578:	8b2e                	mv	s6,a1
    8000157a:	8bb2                	mv	s7,a2
    8000157c:	8a36                	mv	s4,a3
    va0 = PGROUNDDOWN(dstva);
    8000157e:	74fd                	lui	s1,0xfffff
    80001580:	8ced                	and	s1,s1,a1
    if(va0 >= MAXVA)
    80001582:	57fd                	li	a5,-1
    80001584:	83e9                	srl	a5,a5,0x1a
    80001586:	0697e763          	bltu	a5,s1,800015f4 <copyout+0x9c>
    8000158a:	6d05                	lui	s10,0x1
    8000158c:	8cbe                	mv	s9,a5
    8000158e:	a015                	j	800015b2 <copyout+0x5a>
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80001590:	409b0533          	sub	a0,s6,s1
    80001594:	0009861b          	sext.w	a2,s3
    80001598:	85de                	mv	a1,s7
    8000159a:	954a                	add	a0,a0,s2
    8000159c:	f08ff0ef          	jal	80000ca4 <memmove>
    len -= n;
    800015a0:	413a0a33          	sub	s4,s4,s3
    src += n;
    800015a4:	9bce                	add	s7,s7,s3
  while(len > 0){
    800015a6:	040a0363          	beqz	s4,800015ec <copyout+0x94>
    if(va0 >= MAXVA)
    800015aa:	055ce763          	bltu	s9,s5,800015f8 <copyout+0xa0>
    va0 = PGROUNDDOWN(dstva);
    800015ae:	84d6                	mv	s1,s5
    dstva = va0 + PGSIZE;
    800015b0:	8b56                	mv	s6,s5
    pa0 = walkaddr(pagetable, va0);
    800015b2:	85a6                	mv	a1,s1
    800015b4:	8562                	mv	a0,s8
    800015b6:	9a7ff0ef          	jal	80000f5c <walkaddr>
    800015ba:	892a                	mv	s2,a0
    if(pa0 == 0) {
    800015bc:	e901                	bnez	a0,800015cc <copyout+0x74>
      if((pa0 = vmfault(pagetable, va0, 0)) == 0) {
    800015be:	4601                	li	a2,0
    800015c0:	85a6                	mv	a1,s1
    800015c2:	8562                	mv	a0,s8
    800015c4:	f23ff0ef          	jal	800014e6 <vmfault>
    800015c8:	892a                	mv	s2,a0
    800015ca:	c90d                	beqz	a0,800015fc <copyout+0xa4>
    pte = walk(pagetable, va0, 0);
    800015cc:	4601                	li	a2,0
    800015ce:	85a6                	mv	a1,s1
    800015d0:	8562                	mv	a0,s8
    800015d2:	8f1ff0ef          	jal	80000ec2 <walk>
    if((*pte & PTE_W) == 0)
    800015d6:	611c                	ld	a5,0(a0)
    800015d8:	8b91                	and	a5,a5,4
    800015da:	c39d                	beqz	a5,80001600 <copyout+0xa8>
    n = PGSIZE - (dstva - va0);
    800015dc:	01a48ab3          	add	s5,s1,s10
    800015e0:	416a89b3          	sub	s3,s5,s6
    800015e4:	fb3a76e3          	bgeu	s4,s3,80001590 <copyout+0x38>
    800015e8:	89d2                	mv	s3,s4
    800015ea:	b75d                	j	80001590 <copyout+0x38>
  return 0;
    800015ec:	4501                	li	a0,0
    800015ee:	a811                	j	80001602 <copyout+0xaa>
    800015f0:	4501                	li	a0,0
}
    800015f2:	8082                	ret
      return -1;
    800015f4:	557d                	li	a0,-1
    800015f6:	a031                	j	80001602 <copyout+0xaa>
    800015f8:	557d                	li	a0,-1
    800015fa:	a021                	j	80001602 <copyout+0xaa>
        return -1;
    800015fc:	557d                	li	a0,-1
    800015fe:	a011                	j	80001602 <copyout+0xaa>
      return -1;
    80001600:	557d                	li	a0,-1
}
    80001602:	60e6                	ld	ra,88(sp)
    80001604:	6446                	ld	s0,80(sp)
    80001606:	64a6                	ld	s1,72(sp)
    80001608:	6906                	ld	s2,64(sp)
    8000160a:	79e2                	ld	s3,56(sp)
    8000160c:	7a42                	ld	s4,48(sp)
    8000160e:	7aa2                	ld	s5,40(sp)
    80001610:	7b02                	ld	s6,32(sp)
    80001612:	6be2                	ld	s7,24(sp)
    80001614:	6c42                	ld	s8,16(sp)
    80001616:	6ca2                	ld	s9,8(sp)
    80001618:	6d02                	ld	s10,0(sp)
    8000161a:	6125                	add	sp,sp,96
    8000161c:	8082                	ret

000000008000161e <copyin>:
  while(len > 0){
    8000161e:	c6c9                	beqz	a3,800016a8 <copyin+0x8a>
{
    80001620:	715d                	add	sp,sp,-80
    80001622:	e486                	sd	ra,72(sp)
    80001624:	e0a2                	sd	s0,64(sp)
    80001626:	fc26                	sd	s1,56(sp)
    80001628:	f84a                	sd	s2,48(sp)
    8000162a:	f44e                	sd	s3,40(sp)
    8000162c:	f052                	sd	s4,32(sp)
    8000162e:	ec56                	sd	s5,24(sp)
    80001630:	e85a                	sd	s6,16(sp)
    80001632:	e45e                	sd	s7,8(sp)
    80001634:	e062                	sd	s8,0(sp)
    80001636:	0880                	add	s0,sp,80
    80001638:	8baa                	mv	s7,a0
    8000163a:	8aae                	mv	s5,a1
    8000163c:	8932                	mv	s2,a2
    8000163e:	8a36                	mv	s4,a3
    va0 = PGROUNDDOWN(srcva);
    80001640:	7c7d                	lui	s8,0xfffff
    n = PGSIZE - (srcva - va0);
    80001642:	6b05                	lui	s6,0x1
    80001644:	a035                	j	80001670 <copyin+0x52>
    80001646:	412984b3          	sub	s1,s3,s2
    8000164a:	94da                	add	s1,s1,s6
    8000164c:	009a7363          	bgeu	s4,s1,80001652 <copyin+0x34>
    80001650:	84d2                	mv	s1,s4
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80001652:	413905b3          	sub	a1,s2,s3
    80001656:	0004861b          	sext.w	a2,s1
    8000165a:	95aa                	add	a1,a1,a0
    8000165c:	8556                	mv	a0,s5
    8000165e:	e46ff0ef          	jal	80000ca4 <memmove>
    len -= n;
    80001662:	409a0a33          	sub	s4,s4,s1
    dst += n;
    80001666:	9aa6                	add	s5,s5,s1
    srcva = va0 + PGSIZE;
    80001668:	01698933          	add	s2,s3,s6
  while(len > 0){
    8000166c:	020a0163          	beqz	s4,8000168e <copyin+0x70>
    va0 = PGROUNDDOWN(srcva);
    80001670:	018979b3          	and	s3,s2,s8
    pa0 = walkaddr(pagetable, va0);
    80001674:	85ce                	mv	a1,s3
    80001676:	855e                	mv	a0,s7
    80001678:	8e5ff0ef          	jal	80000f5c <walkaddr>
    if(pa0 == 0) {
    8000167c:	f569                	bnez	a0,80001646 <copyin+0x28>
      if((pa0 = vmfault(pagetable, va0, 0)) == 0) {
    8000167e:	4601                	li	a2,0
    80001680:	85ce                	mv	a1,s3
    80001682:	855e                	mv	a0,s7
    80001684:	e63ff0ef          	jal	800014e6 <vmfault>
    80001688:	fd5d                	bnez	a0,80001646 <copyin+0x28>
        return -1;
    8000168a:	557d                	li	a0,-1
    8000168c:	a011                	j	80001690 <copyin+0x72>
  return 0;
    8000168e:	4501                	li	a0,0
}
    80001690:	60a6                	ld	ra,72(sp)
    80001692:	6406                	ld	s0,64(sp)
    80001694:	74e2                	ld	s1,56(sp)
    80001696:	7942                	ld	s2,48(sp)
    80001698:	79a2                	ld	s3,40(sp)
    8000169a:	7a02                	ld	s4,32(sp)
    8000169c:	6ae2                	ld	s5,24(sp)
    8000169e:	6b42                	ld	s6,16(sp)
    800016a0:	6ba2                	ld	s7,8(sp)
    800016a2:	6c02                	ld	s8,0(sp)
    800016a4:	6161                	add	sp,sp,80
    800016a6:	8082                	ret
  return 0;
    800016a8:	4501                	li	a0,0
}
    800016aa:	8082                	ret

00000000800016ac <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    800016ac:	7139                	add	sp,sp,-64
    800016ae:	fc06                	sd	ra,56(sp)
    800016b0:	f822                	sd	s0,48(sp)
    800016b2:	f426                	sd	s1,40(sp)
    800016b4:	f04a                	sd	s2,32(sp)
    800016b6:	ec4e                	sd	s3,24(sp)
    800016b8:	e852                	sd	s4,16(sp)
    800016ba:	e456                	sd	s5,8(sp)
    800016bc:	e05a                	sd	s6,0(sp)
    800016be:	0080                	add	s0,sp,64
    800016c0:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    800016c2:	0000e497          	auipc	s1,0xe
    800016c6:	6e648493          	add	s1,s1,1766 # 8000fda8 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    800016ca:	8b26                	mv	s6,s1
    800016cc:	00006a97          	auipc	s5,0x6
    800016d0:	934a8a93          	add	s5,s5,-1740 # 80007000 <etext>
    800016d4:	04000937          	lui	s2,0x4000
    800016d8:	197d                	add	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    800016da:	0932                	sll	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    800016dc:	00014a17          	auipc	s4,0x14
    800016e0:	2cca0a13          	add	s4,s4,716 # 800159a8 <tickslock>
    char *pa = kalloc();
    800016e4:	bc0ff0ef          	jal	80000aa4 <kalloc>
    800016e8:	862a                	mv	a2,a0
    if(pa == 0)
    800016ea:	c121                	beqz	a0,8000172a <proc_mapstacks+0x7e>
    uint64 va = KSTACK((int) (p - proc));
    800016ec:	416485b3          	sub	a1,s1,s6
    800016f0:	8591                	sra	a1,a1,0x4
    800016f2:	000ab783          	ld	a5,0(s5)
    800016f6:	02f585b3          	mul	a1,a1,a5
    800016fa:	2585                	addw	a1,a1,1
    800016fc:	00d5959b          	sllw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80001700:	4719                	li	a4,6
    80001702:	6685                	lui	a3,0x1
    80001704:	40b905b3          	sub	a1,s2,a1
    80001708:	854e                	mv	a0,s3
    8000170a:	941ff0ef          	jal	8000104a <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000170e:	17048493          	add	s1,s1,368
    80001712:	fd4499e3          	bne	s1,s4,800016e4 <proc_mapstacks+0x38>
  }
}
    80001716:	70e2                	ld	ra,56(sp)
    80001718:	7442                	ld	s0,48(sp)
    8000171a:	74a2                	ld	s1,40(sp)
    8000171c:	7902                	ld	s2,32(sp)
    8000171e:	69e2                	ld	s3,24(sp)
    80001720:	6a42                	ld	s4,16(sp)
    80001722:	6aa2                	ld	s5,8(sp)
    80001724:	6b02                	ld	s6,0(sp)
    80001726:	6121                	add	sp,sp,64
    80001728:	8082                	ret
      panic("kalloc");
    8000172a:	00006517          	auipc	a0,0x6
    8000172e:	a4650513          	add	a0,a0,-1466 # 80007170 <digits+0x138>
    80001732:	86cff0ef          	jal	8000079e <panic>

0000000080001736 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80001736:	7139                	add	sp,sp,-64
    80001738:	fc06                	sd	ra,56(sp)
    8000173a:	f822                	sd	s0,48(sp)
    8000173c:	f426                	sd	s1,40(sp)
    8000173e:	f04a                	sd	s2,32(sp)
    80001740:	ec4e                	sd	s3,24(sp)
    80001742:	e852                	sd	s4,16(sp)
    80001744:	e456                	sd	s5,8(sp)
    80001746:	e05a                	sd	s6,0(sp)
    80001748:	0080                	add	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    8000174a:	00006597          	auipc	a1,0x6
    8000174e:	a2e58593          	add	a1,a1,-1490 # 80007178 <digits+0x140>
    80001752:	0000e517          	auipc	a0,0xe
    80001756:	22650513          	add	a0,a0,550 # 8000f978 <pid_lock>
    8000175a:	b9aff0ef          	jal	80000af4 <initlock>
  initlock(&wait_lock, "wait_lock");
    8000175e:	00006597          	auipc	a1,0x6
    80001762:	a2258593          	add	a1,a1,-1502 # 80007180 <digits+0x148>
    80001766:	0000e517          	auipc	a0,0xe
    8000176a:	22a50513          	add	a0,a0,554 # 8000f990 <wait_lock>
    8000176e:	b86ff0ef          	jal	80000af4 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001772:	0000e497          	auipc	s1,0xe
    80001776:	63648493          	add	s1,s1,1590 # 8000fda8 <proc>
      initlock(&p->lock, "proc");
    8000177a:	00006b17          	auipc	s6,0x6
    8000177e:	a16b0b13          	add	s6,s6,-1514 # 80007190 <digits+0x158>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80001782:	8aa6                	mv	s5,s1
    80001784:	00006a17          	auipc	s4,0x6
    80001788:	87ca0a13          	add	s4,s4,-1924 # 80007000 <etext>
    8000178c:	04000937          	lui	s2,0x4000
    80001790:	197d                	add	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80001792:	0932                	sll	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80001794:	00014997          	auipc	s3,0x14
    80001798:	21498993          	add	s3,s3,532 # 800159a8 <tickslock>
      initlock(&p->lock, "proc");
    8000179c:	85da                	mv	a1,s6
    8000179e:	8526                	mv	a0,s1
    800017a0:	b54ff0ef          	jal	80000af4 <initlock>
      p->state = UNUSED;
    800017a4:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    800017a8:	415487b3          	sub	a5,s1,s5
    800017ac:	8791                	sra	a5,a5,0x4
    800017ae:	000a3703          	ld	a4,0(s4)
    800017b2:	02e787b3          	mul	a5,a5,a4
    800017b6:	2785                	addw	a5,a5,1 # fffffffffffff001 <end+0xffffffff7ffde211>
    800017b8:	00d7979b          	sllw	a5,a5,0xd
    800017bc:	40f907b3          	sub	a5,s2,a5
    800017c0:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    800017c2:	17048493          	add	s1,s1,368
    800017c6:	fd349be3          	bne	s1,s3,8000179c <procinit+0x66>
  }
}
    800017ca:	70e2                	ld	ra,56(sp)
    800017cc:	7442                	ld	s0,48(sp)
    800017ce:	74a2                	ld	s1,40(sp)
    800017d0:	7902                	ld	s2,32(sp)
    800017d2:	69e2                	ld	s3,24(sp)
    800017d4:	6a42                	ld	s4,16(sp)
    800017d6:	6aa2                	ld	s5,8(sp)
    800017d8:	6b02                	ld	s6,0(sp)
    800017da:	6121                	add	sp,sp,64
    800017dc:	8082                	ret

00000000800017de <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    800017de:	1141                	add	sp,sp,-16
    800017e0:	e422                	sd	s0,8(sp)
    800017e2:	0800                	add	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    800017e4:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    800017e6:	2501                	sext.w	a0,a0
    800017e8:	6422                	ld	s0,8(sp)
    800017ea:	0141                	add	sp,sp,16
    800017ec:	8082                	ret

00000000800017ee <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    800017ee:	1141                	add	sp,sp,-16
    800017f0:	e422                	sd	s0,8(sp)
    800017f2:	0800                	add	s0,sp,16
    800017f4:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    800017f6:	2781                	sext.w	a5,a5
    800017f8:	079e                	sll	a5,a5,0x7
  return c;
}
    800017fa:	0000e517          	auipc	a0,0xe
    800017fe:	1ae50513          	add	a0,a0,430 # 8000f9a8 <cpus>
    80001802:	953e                	add	a0,a0,a5
    80001804:	6422                	ld	s0,8(sp)
    80001806:	0141                	add	sp,sp,16
    80001808:	8082                	ret

000000008000180a <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    8000180a:	1101                	add	sp,sp,-32
    8000180c:	ec06                	sd	ra,24(sp)
    8000180e:	e822                	sd	s0,16(sp)
    80001810:	e426                	sd	s1,8(sp)
    80001812:	1000                	add	s0,sp,32
  push_off();
    80001814:	b20ff0ef          	jal	80000b34 <push_off>
    80001818:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    8000181a:	2781                	sext.w	a5,a5
    8000181c:	079e                	sll	a5,a5,0x7
    8000181e:	0000e717          	auipc	a4,0xe
    80001822:	15a70713          	add	a4,a4,346 # 8000f978 <pid_lock>
    80001826:	97ba                	add	a5,a5,a4
    80001828:	7b84                	ld	s1,48(a5)
  pop_off();
    8000182a:	b8eff0ef          	jal	80000bb8 <pop_off>
  return p;
}
    8000182e:	8526                	mv	a0,s1
    80001830:	60e2                	ld	ra,24(sp)
    80001832:	6442                	ld	s0,16(sp)
    80001834:	64a2                	ld	s1,8(sp)
    80001836:	6105                	add	sp,sp,32
    80001838:	8082                	ret

000000008000183a <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    8000183a:	7179                	add	sp,sp,-48
    8000183c:	f406                	sd	ra,40(sp)
    8000183e:	f022                	sd	s0,32(sp)
    80001840:	ec26                	sd	s1,24(sp)
    80001842:	1800                	add	s0,sp,48
  extern char userret[];
  static int first = 1;
  struct proc *p = myproc();
    80001844:	fc7ff0ef          	jal	8000180a <myproc>
    80001848:	84aa                	mv	s1,a0

  // Still holding p->lock from scheduler.
  release(&p->lock);
    8000184a:	bc2ff0ef          	jal	80000c0c <release>

  if (first) {
    8000184e:	00006797          	auipc	a5,0x6
    80001852:	ff27a783          	lw	a5,-14(a5) # 80007840 <first.1>
    80001856:	cf8d                	beqz	a5,80001890 <forkret+0x56>
    // File system initialization must be run in the context of a
    // regular process (e.g., because it calls sleep), and thus cannot
    // be run from main().
    fsinit(ROOTDEV);
    80001858:	4505                	li	a0,1
    8000185a:	575010ef          	jal	800035ce <fsinit>

    first = 0;
    8000185e:	00006797          	auipc	a5,0x6
    80001862:	fe07a123          	sw	zero,-30(a5) # 80007840 <first.1>
    // ensure other cores see first=0.
    __sync_synchronize();
    80001866:	0ff0000f          	fence

    // We can invoke kexec() now that file system is initialized.
    // Put the return value (argc) of kexec into a0.
    p->trapframe->a0 = kexec("/init", (char *[]){ "/init", 0 });
    8000186a:	00006517          	auipc	a0,0x6
    8000186e:	92e50513          	add	a0,a0,-1746 # 80007198 <digits+0x160>
    80001872:	fca43823          	sd	a0,-48(s0)
    80001876:	fc043c23          	sd	zero,-40(s0)
    8000187a:	fd040593          	add	a1,s0,-48
    8000187e:	5d1020ef          	jal	8000464e <kexec>
    80001882:	6cbc                	ld	a5,88(s1)
    80001884:	fba8                	sd	a0,112(a5)
    if (p->trapframe->a0 == -1) {
    80001886:	6cbc                	ld	a5,88(s1)
    80001888:	7bb8                	ld	a4,112(a5)
    8000188a:	57fd                	li	a5,-1
    8000188c:	02f70d63          	beq	a4,a5,800018c6 <forkret+0x8c>
      panic("exec");
    }
  }

  // return to user space, mimicing usertrap()'s return.
  prepare_return();
    80001890:	3ef000ef          	jal	8000247e <prepare_return>
  uint64 satp = MAKE_SATP(p->pagetable);
    80001894:	68a8                	ld	a0,80(s1)
    80001896:	8131                	srl	a0,a0,0xc
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001898:	04000737          	lui	a4,0x4000
    8000189c:	00005797          	auipc	a5,0x5
    800018a0:	80078793          	add	a5,a5,-2048 # 8000609c <userret>
    800018a4:	00004697          	auipc	a3,0x4
    800018a8:	75c68693          	add	a3,a3,1884 # 80006000 <_trampoline>
    800018ac:	8f95                	sub	a5,a5,a3
    800018ae:	177d                	add	a4,a4,-1 # 3ffffff <_entry-0x7c000001>
    800018b0:	0732                	sll	a4,a4,0xc
    800018b2:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    800018b4:	577d                	li	a4,-1
    800018b6:	177e                	sll	a4,a4,0x3f
    800018b8:	8d59                	or	a0,a0,a4
    800018ba:	9782                	jalr	a5
}
    800018bc:	70a2                	ld	ra,40(sp)
    800018be:	7402                	ld	s0,32(sp)
    800018c0:	64e2                	ld	s1,24(sp)
    800018c2:	6145                	add	sp,sp,48
    800018c4:	8082                	ret
      panic("exec");
    800018c6:	00006517          	auipc	a0,0x6
    800018ca:	8da50513          	add	a0,a0,-1830 # 800071a0 <digits+0x168>
    800018ce:	ed1fe0ef          	jal	8000079e <panic>

00000000800018d2 <allocpid>:
{
    800018d2:	1101                	add	sp,sp,-32
    800018d4:	ec06                	sd	ra,24(sp)
    800018d6:	e822                	sd	s0,16(sp)
    800018d8:	e426                	sd	s1,8(sp)
    800018da:	e04a                	sd	s2,0(sp)
    800018dc:	1000                	add	s0,sp,32
  acquire(&pid_lock);
    800018de:	0000e917          	auipc	s2,0xe
    800018e2:	09a90913          	add	s2,s2,154 # 8000f978 <pid_lock>
    800018e6:	854a                	mv	a0,s2
    800018e8:	a8cff0ef          	jal	80000b74 <acquire>
  pid = nextpid;
    800018ec:	00006797          	auipc	a5,0x6
    800018f0:	f5c78793          	add	a5,a5,-164 # 80007848 <nextpid>
    800018f4:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    800018f6:	0014871b          	addw	a4,s1,1
    800018fa:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    800018fc:	854a                	mv	a0,s2
    800018fe:	b0eff0ef          	jal	80000c0c <release>
}
    80001902:	8526                	mv	a0,s1
    80001904:	60e2                	ld	ra,24(sp)
    80001906:	6442                	ld	s0,16(sp)
    80001908:	64a2                	ld	s1,8(sp)
    8000190a:	6902                	ld	s2,0(sp)
    8000190c:	6105                	add	sp,sp,32
    8000190e:	8082                	ret

0000000080001910 <proc_pagetable>:
{
    80001910:	1101                	add	sp,sp,-32
    80001912:	ec06                	sd	ra,24(sp)
    80001914:	e822                	sd	s0,16(sp)
    80001916:	e426                	sd	s1,8(sp)
    80001918:	e04a                	sd	s2,0(sp)
    8000191a:	1000                	add	s0,sp,32
    8000191c:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    8000191e:	823ff0ef          	jal	80001140 <uvmcreate>
    80001922:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001924:	cd05                	beqz	a0,8000195c <proc_pagetable+0x4c>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001926:	4729                	li	a4,10
    80001928:	00004697          	auipc	a3,0x4
    8000192c:	6d868693          	add	a3,a3,1752 # 80006000 <_trampoline>
    80001930:	6605                	lui	a2,0x1
    80001932:	040005b7          	lui	a1,0x4000
    80001936:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001938:	05b2                	sll	a1,a1,0xc
    8000193a:	e60ff0ef          	jal	80000f9a <mappages>
    8000193e:	02054663          	bltz	a0,8000196a <proc_pagetable+0x5a>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001942:	4719                	li	a4,6
    80001944:	05893683          	ld	a3,88(s2)
    80001948:	6605                	lui	a2,0x1
    8000194a:	020005b7          	lui	a1,0x2000
    8000194e:	15fd                	add	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001950:	05b6                	sll	a1,a1,0xd
    80001952:	8526                	mv	a0,s1
    80001954:	e46ff0ef          	jal	80000f9a <mappages>
    80001958:	00054f63          	bltz	a0,80001976 <proc_pagetable+0x66>
}
    8000195c:	8526                	mv	a0,s1
    8000195e:	60e2                	ld	ra,24(sp)
    80001960:	6442                	ld	s0,16(sp)
    80001962:	64a2                	ld	s1,8(sp)
    80001964:	6902                	ld	s2,0(sp)
    80001966:	6105                	add	sp,sp,32
    80001968:	8082                	ret
    uvmfree(pagetable, 0);
    8000196a:	4581                	li	a1,0
    8000196c:	8526                	mv	a0,s1
    8000196e:	9b3ff0ef          	jal	80001320 <uvmfree>
    return 0;
    80001972:	4481                	li	s1,0
    80001974:	b7e5                	j	8000195c <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001976:	4681                	li	a3,0
    80001978:	4605                	li	a2,1
    8000197a:	040005b7          	lui	a1,0x4000
    8000197e:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001980:	05b2                	sll	a1,a1,0xc
    80001982:	8526                	mv	a0,s1
    80001984:	fe2ff0ef          	jal	80001166 <uvmunmap>
    uvmfree(pagetable, 0);
    80001988:	4581                	li	a1,0
    8000198a:	8526                	mv	a0,s1
    8000198c:	995ff0ef          	jal	80001320 <uvmfree>
    return 0;
    80001990:	4481                	li	s1,0
    80001992:	b7e9                	j	8000195c <proc_pagetable+0x4c>

0000000080001994 <proc_freepagetable>:
{
    80001994:	1101                	add	sp,sp,-32
    80001996:	ec06                	sd	ra,24(sp)
    80001998:	e822                	sd	s0,16(sp)
    8000199a:	e426                	sd	s1,8(sp)
    8000199c:	e04a                	sd	s2,0(sp)
    8000199e:	1000                	add	s0,sp,32
    800019a0:	84aa                	mv	s1,a0
    800019a2:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800019a4:	4681                	li	a3,0
    800019a6:	4605                	li	a2,1
    800019a8:	040005b7          	lui	a1,0x4000
    800019ac:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800019ae:	05b2                	sll	a1,a1,0xc
    800019b0:	fb6ff0ef          	jal	80001166 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    800019b4:	4681                	li	a3,0
    800019b6:	4605                	li	a2,1
    800019b8:	020005b7          	lui	a1,0x2000
    800019bc:	15fd                	add	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    800019be:	05b6                	sll	a1,a1,0xd
    800019c0:	8526                	mv	a0,s1
    800019c2:	fa4ff0ef          	jal	80001166 <uvmunmap>
  uvmfree(pagetable, sz);
    800019c6:	85ca                	mv	a1,s2
    800019c8:	8526                	mv	a0,s1
    800019ca:	957ff0ef          	jal	80001320 <uvmfree>
}
    800019ce:	60e2                	ld	ra,24(sp)
    800019d0:	6442                	ld	s0,16(sp)
    800019d2:	64a2                	ld	s1,8(sp)
    800019d4:	6902                	ld	s2,0(sp)
    800019d6:	6105                	add	sp,sp,32
    800019d8:	8082                	ret

00000000800019da <freeproc>:
{
    800019da:	1101                	add	sp,sp,-32
    800019dc:	ec06                	sd	ra,24(sp)
    800019de:	e822                	sd	s0,16(sp)
    800019e0:	e426                	sd	s1,8(sp)
    800019e2:	1000                	add	s0,sp,32
    800019e4:	84aa                	mv	s1,a0
  if(p->trapframe)
    800019e6:	6d28                	ld	a0,88(a0)
    800019e8:	c119                	beqz	a0,800019ee <freeproc+0x14>
    kfree((void*)p->trapframe);
    800019ea:	fd9fe0ef          	jal	800009c2 <kfree>
  p->trapframe = 0;
    800019ee:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    800019f2:	68a8                	ld	a0,80(s1)
    800019f4:	c501                	beqz	a0,800019fc <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    800019f6:	64ac                	ld	a1,72(s1)
    800019f8:	f9dff0ef          	jal	80001994 <proc_freepagetable>
  p->pagetable = 0;
    800019fc:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001a00:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001a04:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001a08:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001a0c:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001a10:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001a14:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001a18:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001a1c:	0004ac23          	sw	zero,24(s1)
}
    80001a20:	60e2                	ld	ra,24(sp)
    80001a22:	6442                	ld	s0,16(sp)
    80001a24:	64a2                	ld	s1,8(sp)
    80001a26:	6105                	add	sp,sp,32
    80001a28:	8082                	ret

0000000080001a2a <allocproc>:
{
    80001a2a:	1101                	add	sp,sp,-32
    80001a2c:	ec06                	sd	ra,24(sp)
    80001a2e:	e822                	sd	s0,16(sp)
    80001a30:	e426                	sd	s1,8(sp)
    80001a32:	e04a                	sd	s2,0(sp)
    80001a34:	1000                	add	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001a36:	0000e497          	auipc	s1,0xe
    80001a3a:	37248493          	add	s1,s1,882 # 8000fda8 <proc>
    80001a3e:	00014917          	auipc	s2,0x14
    80001a42:	f6a90913          	add	s2,s2,-150 # 800159a8 <tickslock>
    acquire(&p->lock);
    80001a46:	8526                	mv	a0,s1
    80001a48:	92cff0ef          	jal	80000b74 <acquire>
    if(p->state == UNUSED) {
    80001a4c:	4c9c                	lw	a5,24(s1)
    80001a4e:	cb91                	beqz	a5,80001a62 <allocproc+0x38>
      release(&p->lock);
    80001a50:	8526                	mv	a0,s1
    80001a52:	9baff0ef          	jal	80000c0c <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001a56:	17048493          	add	s1,s1,368
    80001a5a:	ff2496e3          	bne	s1,s2,80001a46 <allocproc+0x1c>
  return 0;
    80001a5e:	4481                	li	s1,0
    80001a60:	a0b1                	j	80001aac <allocproc+0x82>
  p->pid = allocpid();
    80001a62:	e71ff0ef          	jal	800018d2 <allocpid>
    80001a66:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001a68:	4785                	li	a5,1
    80001a6a:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001a6c:	838ff0ef          	jal	80000aa4 <kalloc>
    80001a70:	892a                	mv	s2,a0
    80001a72:	eca8                	sd	a0,88(s1)
    80001a74:	c139                	beqz	a0,80001aba <allocproc+0x90>
  p->pagetable = proc_pagetable(p);
    80001a76:	8526                	mv	a0,s1
    80001a78:	e99ff0ef          	jal	80001910 <proc_pagetable>
    80001a7c:	892a                	mv	s2,a0
    80001a7e:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001a80:	c529                	beqz	a0,80001aca <allocproc+0xa0>
  memset(&p->context, 0, sizeof(p->context));
    80001a82:	07000613          	li	a2,112
    80001a86:	4581                	li	a1,0
    80001a88:	06048513          	add	a0,s1,96
    80001a8c:	9bcff0ef          	jal	80000c48 <memset>
  p->context.ra = (uint64)forkret;
    80001a90:	00000797          	auipc	a5,0x0
    80001a94:	daa78793          	add	a5,a5,-598 # 8000183a <forkret>
    80001a98:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001a9a:	60bc                	ld	a5,64(s1)
    80001a9c:	6705                	lui	a4,0x1
    80001a9e:	97ba                	add	a5,a5,a4
    80001aa0:	f4bc                	sd	a5,104(s1)
  p->tickets = 1;
    80001aa2:	4785                	li	a5,1
    80001aa4:	16f4a423          	sw	a5,360(s1)
  p->ticks = 0;
    80001aa8:	1604a623          	sw	zero,364(s1)
}
    80001aac:	8526                	mv	a0,s1
    80001aae:	60e2                	ld	ra,24(sp)
    80001ab0:	6442                	ld	s0,16(sp)
    80001ab2:	64a2                	ld	s1,8(sp)
    80001ab4:	6902                	ld	s2,0(sp)
    80001ab6:	6105                	add	sp,sp,32
    80001ab8:	8082                	ret
    freeproc(p);
    80001aba:	8526                	mv	a0,s1
    80001abc:	f1fff0ef          	jal	800019da <freeproc>
    release(&p->lock);
    80001ac0:	8526                	mv	a0,s1
    80001ac2:	94aff0ef          	jal	80000c0c <release>
    return 0;
    80001ac6:	84ca                	mv	s1,s2
    80001ac8:	b7d5                	j	80001aac <allocproc+0x82>
    freeproc(p);
    80001aca:	8526                	mv	a0,s1
    80001acc:	f0fff0ef          	jal	800019da <freeproc>
    release(&p->lock);
    80001ad0:	8526                	mv	a0,s1
    80001ad2:	93aff0ef          	jal	80000c0c <release>
    return 0;
    80001ad6:	84ca                	mv	s1,s2
    80001ad8:	bfd1                	j	80001aac <allocproc+0x82>

0000000080001ada <userinit>:
{
    80001ada:	1101                	add	sp,sp,-32
    80001adc:	ec06                	sd	ra,24(sp)
    80001ade:	e822                	sd	s0,16(sp)
    80001ae0:	e426                	sd	s1,8(sp)
    80001ae2:	1000                	add	s0,sp,32
  p = allocproc();
    80001ae4:	f47ff0ef          	jal	80001a2a <allocproc>
    80001ae8:	84aa                	mv	s1,a0
  initproc = p;
    80001aea:	00006797          	auipc	a5,0x6
    80001aee:	d8a7b323          	sd	a0,-634(a5) # 80007870 <initproc>
  p->cwd = namei("/");
    80001af2:	00005517          	auipc	a0,0x5
    80001af6:	6b650513          	add	a0,a0,1718 # 800071a8 <digits+0x170>
    80001afa:	7d3010ef          	jal	80003acc <namei>
    80001afe:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001b02:	478d                	li	a5,3
    80001b04:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001b06:	8526                	mv	a0,s1
    80001b08:	904ff0ef          	jal	80000c0c <release>
}
    80001b0c:	60e2                	ld	ra,24(sp)
    80001b0e:	6442                	ld	s0,16(sp)
    80001b10:	64a2                	ld	s1,8(sp)
    80001b12:	6105                	add	sp,sp,32
    80001b14:	8082                	ret

0000000080001b16 <growproc>:
{
    80001b16:	1101                	add	sp,sp,-32
    80001b18:	ec06                	sd	ra,24(sp)
    80001b1a:	e822                	sd	s0,16(sp)
    80001b1c:	e426                	sd	s1,8(sp)
    80001b1e:	e04a                	sd	s2,0(sp)
    80001b20:	1000                	add	s0,sp,32
    80001b22:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001b24:	ce7ff0ef          	jal	8000180a <myproc>
    80001b28:	892a                	mv	s2,a0
  sz = p->sz;
    80001b2a:	652c                	ld	a1,72(a0)
  if(n > 0){
    80001b2c:	02905963          	blez	s1,80001b5e <growproc+0x48>
    if(sz + n > TRAPFRAME) {
    80001b30:	00b48633          	add	a2,s1,a1
    80001b34:	020007b7          	lui	a5,0x2000
    80001b38:	17fd                	add	a5,a5,-1 # 1ffffff <_entry-0x7e000001>
    80001b3a:	07b6                	sll	a5,a5,0xd
    80001b3c:	02c7ea63          	bltu	a5,a2,80001b70 <growproc+0x5a>
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001b40:	4691                	li	a3,4
    80001b42:	6928                	ld	a0,80(a0)
    80001b44:	ee2ff0ef          	jal	80001226 <uvmalloc>
    80001b48:	85aa                	mv	a1,a0
    80001b4a:	c50d                	beqz	a0,80001b74 <growproc+0x5e>
  p->sz = sz;
    80001b4c:	04b93423          	sd	a1,72(s2)
  return 0;
    80001b50:	4501                	li	a0,0
}
    80001b52:	60e2                	ld	ra,24(sp)
    80001b54:	6442                	ld	s0,16(sp)
    80001b56:	64a2                	ld	s1,8(sp)
    80001b58:	6902                	ld	s2,0(sp)
    80001b5a:	6105                	add	sp,sp,32
    80001b5c:	8082                	ret
  } else if(n < 0){
    80001b5e:	fe04d7e3          	bgez	s1,80001b4c <growproc+0x36>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001b62:	00b48633          	add	a2,s1,a1
    80001b66:	6928                	ld	a0,80(a0)
    80001b68:	e7aff0ef          	jal	800011e2 <uvmdealloc>
    80001b6c:	85aa                	mv	a1,a0
    80001b6e:	bff9                	j	80001b4c <growproc+0x36>
      return -1;
    80001b70:	557d                	li	a0,-1
    80001b72:	b7c5                	j	80001b52 <growproc+0x3c>
      return -1;
    80001b74:	557d                	li	a0,-1
    80001b76:	bff1                	j	80001b52 <growproc+0x3c>

0000000080001b78 <kfork>:
{
    80001b78:	7139                	add	sp,sp,-64
    80001b7a:	fc06                	sd	ra,56(sp)
    80001b7c:	f822                	sd	s0,48(sp)
    80001b7e:	f426                	sd	s1,40(sp)
    80001b80:	f04a                	sd	s2,32(sp)
    80001b82:	ec4e                	sd	s3,24(sp)
    80001b84:	e852                	sd	s4,16(sp)
    80001b86:	e456                	sd	s5,8(sp)
    80001b88:	0080                	add	s0,sp,64
  struct proc *p = myproc();
    80001b8a:	c81ff0ef          	jal	8000180a <myproc>
    80001b8e:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001b90:	e9bff0ef          	jal	80001a2a <allocproc>
    80001b94:	0e050a63          	beqz	a0,80001c88 <kfork+0x110>
    80001b98:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001b9a:	048ab603          	ld	a2,72(s5)
    80001b9e:	692c                	ld	a1,80(a0)
    80001ba0:	050ab503          	ld	a0,80(s5)
    80001ba4:	faeff0ef          	jal	80001352 <uvmcopy>
    80001ba8:	04054863          	bltz	a0,80001bf8 <kfork+0x80>
  np->sz = p->sz;
    80001bac:	048ab783          	ld	a5,72(s5)
    80001bb0:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    80001bb4:	058ab683          	ld	a3,88(s5)
    80001bb8:	87b6                	mv	a5,a3
    80001bba:	0589b703          	ld	a4,88(s3)
    80001bbe:	12068693          	add	a3,a3,288
    80001bc2:	0007b803          	ld	a6,0(a5)
    80001bc6:	6788                	ld	a0,8(a5)
    80001bc8:	6b8c                	ld	a1,16(a5)
    80001bca:	6f90                	ld	a2,24(a5)
    80001bcc:	01073023          	sd	a6,0(a4) # 1000 <_entry-0x7ffff000>
    80001bd0:	e708                	sd	a0,8(a4)
    80001bd2:	eb0c                	sd	a1,16(a4)
    80001bd4:	ef10                	sd	a2,24(a4)
    80001bd6:	02078793          	add	a5,a5,32
    80001bda:	02070713          	add	a4,a4,32
    80001bde:	fed792e3          	bne	a5,a3,80001bc2 <kfork+0x4a>
  np->trapframe->a0 = 0;
    80001be2:	0589b783          	ld	a5,88(s3)
    80001be6:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001bea:	0d0a8493          	add	s1,s5,208
    80001bee:	0d098913          	add	s2,s3,208
    80001bf2:	150a8a13          	add	s4,s5,336
    80001bf6:	a829                	j	80001c10 <kfork+0x98>
    freeproc(np);
    80001bf8:	854e                	mv	a0,s3
    80001bfa:	de1ff0ef          	jal	800019da <freeproc>
    release(&np->lock);
    80001bfe:	854e                	mv	a0,s3
    80001c00:	80cff0ef          	jal	80000c0c <release>
    return -1;
    80001c04:	597d                	li	s2,-1
    80001c06:	a0bd                	j	80001c74 <kfork+0xfc>
  for(i = 0; i < NOFILE; i++)
    80001c08:	04a1                	add	s1,s1,8
    80001c0a:	0921                	add	s2,s2,8
    80001c0c:	01448963          	beq	s1,s4,80001c1e <kfork+0xa6>
    if(p->ofile[i])
    80001c10:	6088                	ld	a0,0(s1)
    80001c12:	d97d                	beqz	a0,80001c08 <kfork+0x90>
      np->ofile[i] = filedup(p->ofile[i]);
    80001c14:	44c020ef          	jal	80004060 <filedup>
    80001c18:	00a93023          	sd	a0,0(s2)
    80001c1c:	b7f5                	j	80001c08 <kfork+0x90>
  np->cwd = idup(p->cwd);
    80001c1e:	150ab503          	ld	a0,336(s5)
    80001c22:	686010ef          	jal	800032a8 <idup>
    80001c26:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001c2a:	4641                	li	a2,16
    80001c2c:	158a8593          	add	a1,s5,344
    80001c30:	15898513          	add	a0,s3,344
    80001c34:	958ff0ef          	jal	80000d8c <safestrcpy>
  np->tickets = p->tickets;
    80001c38:	168aa783          	lw	a5,360(s5)
    80001c3c:	16f9a423          	sw	a5,360(s3)
  pid = np->pid;
    80001c40:	0309a903          	lw	s2,48(s3)
  release(&np->lock);
    80001c44:	854e                	mv	a0,s3
    80001c46:	fc7fe0ef          	jal	80000c0c <release>
  acquire(&wait_lock);
    80001c4a:	0000e497          	auipc	s1,0xe
    80001c4e:	d4648493          	add	s1,s1,-698 # 8000f990 <wait_lock>
    80001c52:	8526                	mv	a0,s1
    80001c54:	f21fe0ef          	jal	80000b74 <acquire>
  np->parent = p;
    80001c58:	0359bc23          	sd	s5,56(s3)
  release(&wait_lock);
    80001c5c:	8526                	mv	a0,s1
    80001c5e:	faffe0ef          	jal	80000c0c <release>
  acquire(&np->lock);
    80001c62:	854e                	mv	a0,s3
    80001c64:	f11fe0ef          	jal	80000b74 <acquire>
  np->state = RUNNABLE;
    80001c68:	478d                	li	a5,3
    80001c6a:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80001c6e:	854e                	mv	a0,s3
    80001c70:	f9dfe0ef          	jal	80000c0c <release>
}
    80001c74:	854a                	mv	a0,s2
    80001c76:	70e2                	ld	ra,56(sp)
    80001c78:	7442                	ld	s0,48(sp)
    80001c7a:	74a2                	ld	s1,40(sp)
    80001c7c:	7902                	ld	s2,32(sp)
    80001c7e:	69e2                	ld	s3,24(sp)
    80001c80:	6a42                	ld	s4,16(sp)
    80001c82:	6aa2                	ld	s5,8(sp)
    80001c84:	6121                	add	sp,sp,64
    80001c86:	8082                	ret
    return -1;
    80001c88:	597d                	li	s2,-1
    80001c8a:	b7ed                	j	80001c74 <kfork+0xfc>

0000000080001c8c <scheduler>:
{
    80001c8c:	711d                	add	sp,sp,-96
    80001c8e:	ec86                	sd	ra,88(sp)
    80001c90:	e8a2                	sd	s0,80(sp)
    80001c92:	e4a6                	sd	s1,72(sp)
    80001c94:	e0ca                	sd	s2,64(sp)
    80001c96:	fc4e                	sd	s3,56(sp)
    80001c98:	f852                	sd	s4,48(sp)
    80001c9a:	f456                	sd	s5,40(sp)
    80001c9c:	f05a                	sd	s6,32(sp)
    80001c9e:	ec5e                	sd	s7,24(sp)
    80001ca0:	e862                	sd	s8,16(sp)
    80001ca2:	e466                	sd	s9,8(sp)
    80001ca4:	1080                	add	s0,sp,96
    80001ca6:	8792                	mv	a5,tp
  int id = r_tp();
    80001ca8:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001caa:	00779693          	sll	a3,a5,0x7
    80001cae:	0000e717          	auipc	a4,0xe
    80001cb2:	cca70713          	add	a4,a4,-822 # 8000f978 <pid_lock>
    80001cb6:	9736                	add	a4,a4,a3
    80001cb8:	02073823          	sd	zero,48(a4)
          swtch(&c->context, &p->context);
    80001cbc:	0000e717          	auipc	a4,0xe
    80001cc0:	cf470713          	add	a4,a4,-780 # 8000f9b0 <cpus+0x8>
    80001cc4:	00e68cb3          	add	s9,a3,a4
    for(p = proc; p < &proc[NPROC]; p++) {
    80001cc8:	00014917          	auipc	s2,0x14
    80001ccc:	ce090913          	add	s2,s2,-800 # 800159a8 <tickslock>
  rand_state = rand_state * 1664525 + 1013904223;
    80001cd0:	00196bb7          	lui	s7,0x196
    80001cd4:	60db8b9b          	addw	s7,s7,1549 # 19660d <_entry-0x7fe699f3>
    80001cd8:	3c6efb37          	lui	s6,0x3c6ef
    80001cdc:	35fb0b1b          	addw	s6,s6,863 # 3c6ef35f <_entry-0x43910ca1>
          c->proc = p;
    80001ce0:	0000ea97          	auipc	s5,0xe
    80001ce4:	c98a8a93          	add	s5,s5,-872 # 8000f978 <pid_lock>
    80001ce8:	9ab6                	add	s5,s5,a3
    80001cea:	a03d                	j	80001d18 <scheduler+0x8c>
      release(&p->lock);
    80001cec:	8526                	mv	a0,s1
    80001cee:	f1ffe0ef          	jal	80000c0c <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001cf2:	17048493          	add	s1,s1,368
    80001cf6:	01248d63          	beq	s1,s2,80001d10 <scheduler+0x84>
      acquire(&p->lock);
    80001cfa:	8526                	mv	a0,s1
    80001cfc:	e79fe0ef          	jal	80000b74 <acquire>
      if(p->state == RUNNABLE)
    80001d00:	4c9c                	lw	a5,24(s1)
    80001d02:	ff3795e3          	bne	a5,s3,80001cec <scheduler+0x60>
        total += p->tickets;
    80001d06:	1684a783          	lw	a5,360(s1)
    80001d0a:	01478a3b          	addw	s4,a5,s4
    80001d0e:	bff9                	j	80001cec <scheduler+0x60>
    if(total == 0) {
    80001d10:	020a1663          	bnez	s4,80001d3c <scheduler+0xb0>
      asm volatile("wfi");
    80001d14:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d18:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001d1c:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d20:	10079073          	csrw	sstatus,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d24:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001d28:	9bf5                	and	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d2a:	10079073          	csrw	sstatus,a5
    int total = 0;
    80001d2e:	4a01                	li	s4,0
    for(p = proc; p < &proc[NPROC]; p++) {
    80001d30:	0000e497          	auipc	s1,0xe
    80001d34:	07848493          	add	s1,s1,120 # 8000fda8 <proc>
      if(p->state == RUNNABLE)
    80001d38:	498d                	li	s3,3
    80001d3a:	b7c1                	j	80001cfa <scheduler+0x6e>
  rand_state = rand_state * 1664525 + 1013904223;
    80001d3c:	00006797          	auipc	a5,0x6
    80001d40:	b0878793          	add	a5,a5,-1272 # 80007844 <rand_state>
    80001d44:	0007ac03          	lw	s8,0(a5)
    80001d48:	038b8c3b          	mulw	s8,s7,s8
    80001d4c:	016c0c3b          	addw	s8,s8,s6
    80001d50:	0187a023          	sw	s8,0(a5)
    int winner = rand_next() % total;
    80001d54:	034c7c3b          	remuw	s8,s8,s4
    int counter = 0;
    80001d58:	4981                	li	s3,0
    for(p = proc; p < &proc[NPROC]; p++) {
    80001d5a:	0000e497          	auipc	s1,0xe
    80001d5e:	04e48493          	add	s1,s1,78 # 8000fda8 <proc>
      if(p->state == RUNNABLE) {
    80001d62:	4a0d                	li	s4,3
    80001d64:	a801                	j	80001d74 <scheduler+0xe8>
      release(&p->lock);
    80001d66:	8526                	mv	a0,s1
    80001d68:	ea5fe0ef          	jal	80000c0c <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001d6c:	17048493          	add	s1,s1,368
    80001d70:	05248263          	beq	s1,s2,80001db4 <scheduler+0x128>
      acquire(&p->lock);
    80001d74:	8526                	mv	a0,s1
    80001d76:	dfffe0ef          	jal	80000b74 <acquire>
      if(p->state == RUNNABLE) {
    80001d7a:	4c9c                	lw	a5,24(s1)
    80001d7c:	ff4795e3          	bne	a5,s4,80001d66 <scheduler+0xda>
        counter += p->tickets;
    80001d80:	1684a783          	lw	a5,360(s1)
    80001d84:	013789bb          	addw	s3,a5,s3
        if(counter > winner) {
    80001d88:	fd3c5fe3          	bge	s8,s3,80001d66 <scheduler+0xda>
          p->state = RUNNING;
    80001d8c:	4791                	li	a5,4
    80001d8e:	cc9c                	sw	a5,24(s1)
          p->ticks++;
    80001d90:	16c4a783          	lw	a5,364(s1)
    80001d94:	2785                	addw	a5,a5,1
    80001d96:	16f4a623          	sw	a5,364(s1)
          c->proc = p;
    80001d9a:	029ab823          	sd	s1,48(s5)
          swtch(&c->context, &p->context);
    80001d9e:	06048593          	add	a1,s1,96
    80001da2:	8566                	mv	a0,s9
    80001da4:	634000ef          	jal	800023d8 <swtch>
          c->proc = 0;
    80001da8:	020ab823          	sd	zero,48(s5)
          release(&p->lock);
    80001dac:	8526                	mv	a0,s1
    80001dae:	e5ffe0ef          	jal	80000c0c <release>
    if(!found) {
    80001db2:	b79d                	j	80001d18 <scheduler+0x8c>
      asm volatile("wfi");
    80001db4:	10500073          	wfi
    80001db8:	b785                	j	80001d18 <scheduler+0x8c>

0000000080001dba <sched>:
{
    80001dba:	7179                	add	sp,sp,-48
    80001dbc:	f406                	sd	ra,40(sp)
    80001dbe:	f022                	sd	s0,32(sp)
    80001dc0:	ec26                	sd	s1,24(sp)
    80001dc2:	e84a                	sd	s2,16(sp)
    80001dc4:	e44e                	sd	s3,8(sp)
    80001dc6:	1800                	add	s0,sp,48
  struct proc *p = myproc();
    80001dc8:	a43ff0ef          	jal	8000180a <myproc>
    80001dcc:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001dce:	d3dfe0ef          	jal	80000b0a <holding>
    80001dd2:	c92d                	beqz	a0,80001e44 <sched+0x8a>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001dd4:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001dd6:	2781                	sext.w	a5,a5
    80001dd8:	079e                	sll	a5,a5,0x7
    80001dda:	0000e717          	auipc	a4,0xe
    80001dde:	b9e70713          	add	a4,a4,-1122 # 8000f978 <pid_lock>
    80001de2:	97ba                	add	a5,a5,a4
    80001de4:	0a87a703          	lw	a4,168(a5)
    80001de8:	4785                	li	a5,1
    80001dea:	06f71363          	bne	a4,a5,80001e50 <sched+0x96>
  if(p->state == RUNNING)
    80001dee:	4c98                	lw	a4,24(s1)
    80001df0:	4791                	li	a5,4
    80001df2:	06f70563          	beq	a4,a5,80001e5c <sched+0xa2>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001df6:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001dfa:	8b89                	and	a5,a5,2
  if(intr_get())
    80001dfc:	e7b5                	bnez	a5,80001e68 <sched+0xae>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001dfe:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001e00:	0000e917          	auipc	s2,0xe
    80001e04:	b7890913          	add	s2,s2,-1160 # 8000f978 <pid_lock>
    80001e08:	2781                	sext.w	a5,a5
    80001e0a:	079e                	sll	a5,a5,0x7
    80001e0c:	97ca                	add	a5,a5,s2
    80001e0e:	0ac7a983          	lw	s3,172(a5)
    80001e12:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001e14:	2781                	sext.w	a5,a5
    80001e16:	079e                	sll	a5,a5,0x7
    80001e18:	0000e597          	auipc	a1,0xe
    80001e1c:	b9858593          	add	a1,a1,-1128 # 8000f9b0 <cpus+0x8>
    80001e20:	95be                	add	a1,a1,a5
    80001e22:	06048513          	add	a0,s1,96
    80001e26:	5b2000ef          	jal	800023d8 <swtch>
    80001e2a:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001e2c:	2781                	sext.w	a5,a5
    80001e2e:	079e                	sll	a5,a5,0x7
    80001e30:	993e                	add	s2,s2,a5
    80001e32:	0b392623          	sw	s3,172(s2)
}
    80001e36:	70a2                	ld	ra,40(sp)
    80001e38:	7402                	ld	s0,32(sp)
    80001e3a:	64e2                	ld	s1,24(sp)
    80001e3c:	6942                	ld	s2,16(sp)
    80001e3e:	69a2                	ld	s3,8(sp)
    80001e40:	6145                	add	sp,sp,48
    80001e42:	8082                	ret
    panic("sched p->lock");
    80001e44:	00005517          	auipc	a0,0x5
    80001e48:	36c50513          	add	a0,a0,876 # 800071b0 <digits+0x178>
    80001e4c:	953fe0ef          	jal	8000079e <panic>
    panic("sched locks");
    80001e50:	00005517          	auipc	a0,0x5
    80001e54:	37050513          	add	a0,a0,880 # 800071c0 <digits+0x188>
    80001e58:	947fe0ef          	jal	8000079e <panic>
    panic("sched RUNNING");
    80001e5c:	00005517          	auipc	a0,0x5
    80001e60:	37450513          	add	a0,a0,884 # 800071d0 <digits+0x198>
    80001e64:	93bfe0ef          	jal	8000079e <panic>
    panic("sched interruptible");
    80001e68:	00005517          	auipc	a0,0x5
    80001e6c:	37850513          	add	a0,a0,888 # 800071e0 <digits+0x1a8>
    80001e70:	92ffe0ef          	jal	8000079e <panic>

0000000080001e74 <yield>:
{
    80001e74:	1101                	add	sp,sp,-32
    80001e76:	ec06                	sd	ra,24(sp)
    80001e78:	e822                	sd	s0,16(sp)
    80001e7a:	e426                	sd	s1,8(sp)
    80001e7c:	1000                	add	s0,sp,32
  struct proc *p = myproc();
    80001e7e:	98dff0ef          	jal	8000180a <myproc>
    80001e82:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001e84:	cf1fe0ef          	jal	80000b74 <acquire>
  p->state = RUNNABLE;
    80001e88:	478d                	li	a5,3
    80001e8a:	cc9c                	sw	a5,24(s1)
  sched();
    80001e8c:	f2fff0ef          	jal	80001dba <sched>
  release(&p->lock);
    80001e90:	8526                	mv	a0,s1
    80001e92:	d7bfe0ef          	jal	80000c0c <release>
}
    80001e96:	60e2                	ld	ra,24(sp)
    80001e98:	6442                	ld	s0,16(sp)
    80001e9a:	64a2                	ld	s1,8(sp)
    80001e9c:	6105                	add	sp,sp,32
    80001e9e:	8082                	ret

0000000080001ea0 <sleep>:

// Sleep on channel chan, releasing condition lock lk.
// Re-acquires lk when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001ea0:	7179                	add	sp,sp,-48
    80001ea2:	f406                	sd	ra,40(sp)
    80001ea4:	f022                	sd	s0,32(sp)
    80001ea6:	ec26                	sd	s1,24(sp)
    80001ea8:	e84a                	sd	s2,16(sp)
    80001eaa:	e44e                	sd	s3,8(sp)
    80001eac:	1800                	add	s0,sp,48
    80001eae:	89aa                	mv	s3,a0
    80001eb0:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001eb2:	959ff0ef          	jal	8000180a <myproc>
    80001eb6:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001eb8:	cbdfe0ef          	jal	80000b74 <acquire>
  release(lk);
    80001ebc:	854a                	mv	a0,s2
    80001ebe:	d4ffe0ef          	jal	80000c0c <release>

  // Go to sleep.
  p->chan = chan;
    80001ec2:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001ec6:	4789                	li	a5,2
    80001ec8:	cc9c                	sw	a5,24(s1)

  sched();
    80001eca:	ef1ff0ef          	jal	80001dba <sched>

  // Tidy up.
  p->chan = 0;
    80001ece:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001ed2:	8526                	mv	a0,s1
    80001ed4:	d39fe0ef          	jal	80000c0c <release>
  acquire(lk);
    80001ed8:	854a                	mv	a0,s2
    80001eda:	c9bfe0ef          	jal	80000b74 <acquire>
}
    80001ede:	70a2                	ld	ra,40(sp)
    80001ee0:	7402                	ld	s0,32(sp)
    80001ee2:	64e2                	ld	s1,24(sp)
    80001ee4:	6942                	ld	s2,16(sp)
    80001ee6:	69a2                	ld	s3,8(sp)
    80001ee8:	6145                	add	sp,sp,48
    80001eea:	8082                	ret

0000000080001eec <wakeup>:

// Wake up all processes sleeping on channel chan.
// Caller should hold the condition lock.
void
wakeup(void *chan)
{
    80001eec:	7139                	add	sp,sp,-64
    80001eee:	fc06                	sd	ra,56(sp)
    80001ef0:	f822                	sd	s0,48(sp)
    80001ef2:	f426                	sd	s1,40(sp)
    80001ef4:	f04a                	sd	s2,32(sp)
    80001ef6:	ec4e                	sd	s3,24(sp)
    80001ef8:	e852                	sd	s4,16(sp)
    80001efa:	e456                	sd	s5,8(sp)
    80001efc:	0080                	add	s0,sp,64
    80001efe:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001f00:	0000e497          	auipc	s1,0xe
    80001f04:	ea848493          	add	s1,s1,-344 # 8000fda8 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001f08:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001f0a:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001f0c:	00014917          	auipc	s2,0x14
    80001f10:	a9c90913          	add	s2,s2,-1380 # 800159a8 <tickslock>
    80001f14:	a801                	j	80001f24 <wakeup+0x38>
      }
      release(&p->lock);
    80001f16:	8526                	mv	a0,s1
    80001f18:	cf5fe0ef          	jal	80000c0c <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001f1c:	17048493          	add	s1,s1,368
    80001f20:	03248263          	beq	s1,s2,80001f44 <wakeup+0x58>
    if(p != myproc()){
    80001f24:	8e7ff0ef          	jal	8000180a <myproc>
    80001f28:	fea48ae3          	beq	s1,a0,80001f1c <wakeup+0x30>
      acquire(&p->lock);
    80001f2c:	8526                	mv	a0,s1
    80001f2e:	c47fe0ef          	jal	80000b74 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001f32:	4c9c                	lw	a5,24(s1)
    80001f34:	ff3791e3          	bne	a5,s3,80001f16 <wakeup+0x2a>
    80001f38:	709c                	ld	a5,32(s1)
    80001f3a:	fd479ee3          	bne	a5,s4,80001f16 <wakeup+0x2a>
        p->state = RUNNABLE;
    80001f3e:	0154ac23          	sw	s5,24(s1)
    80001f42:	bfd1                	j	80001f16 <wakeup+0x2a>
    }
  }
}
    80001f44:	70e2                	ld	ra,56(sp)
    80001f46:	7442                	ld	s0,48(sp)
    80001f48:	74a2                	ld	s1,40(sp)
    80001f4a:	7902                	ld	s2,32(sp)
    80001f4c:	69e2                	ld	s3,24(sp)
    80001f4e:	6a42                	ld	s4,16(sp)
    80001f50:	6aa2                	ld	s5,8(sp)
    80001f52:	6121                	add	sp,sp,64
    80001f54:	8082                	ret

0000000080001f56 <reparent>:
{
    80001f56:	7179                	add	sp,sp,-48
    80001f58:	f406                	sd	ra,40(sp)
    80001f5a:	f022                	sd	s0,32(sp)
    80001f5c:	ec26                	sd	s1,24(sp)
    80001f5e:	e84a                	sd	s2,16(sp)
    80001f60:	e44e                	sd	s3,8(sp)
    80001f62:	e052                	sd	s4,0(sp)
    80001f64:	1800                	add	s0,sp,48
    80001f66:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001f68:	0000e497          	auipc	s1,0xe
    80001f6c:	e4048493          	add	s1,s1,-448 # 8000fda8 <proc>
      pp->parent = initproc;
    80001f70:	00006a17          	auipc	s4,0x6
    80001f74:	900a0a13          	add	s4,s4,-1792 # 80007870 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001f78:	00014997          	auipc	s3,0x14
    80001f7c:	a3098993          	add	s3,s3,-1488 # 800159a8 <tickslock>
    80001f80:	a029                	j	80001f8a <reparent+0x34>
    80001f82:	17048493          	add	s1,s1,368
    80001f86:	01348b63          	beq	s1,s3,80001f9c <reparent+0x46>
    if(pp->parent == p){
    80001f8a:	7c9c                	ld	a5,56(s1)
    80001f8c:	ff279be3          	bne	a5,s2,80001f82 <reparent+0x2c>
      pp->parent = initproc;
    80001f90:	000a3503          	ld	a0,0(s4)
    80001f94:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001f96:	f57ff0ef          	jal	80001eec <wakeup>
    80001f9a:	b7e5                	j	80001f82 <reparent+0x2c>
}
    80001f9c:	70a2                	ld	ra,40(sp)
    80001f9e:	7402                	ld	s0,32(sp)
    80001fa0:	64e2                	ld	s1,24(sp)
    80001fa2:	6942                	ld	s2,16(sp)
    80001fa4:	69a2                	ld	s3,8(sp)
    80001fa6:	6a02                	ld	s4,0(sp)
    80001fa8:	6145                	add	sp,sp,48
    80001faa:	8082                	ret

0000000080001fac <kexit>:
{
    80001fac:	7179                	add	sp,sp,-48
    80001fae:	f406                	sd	ra,40(sp)
    80001fb0:	f022                	sd	s0,32(sp)
    80001fb2:	ec26                	sd	s1,24(sp)
    80001fb4:	e84a                	sd	s2,16(sp)
    80001fb6:	e44e                	sd	s3,8(sp)
    80001fb8:	e052                	sd	s4,0(sp)
    80001fba:	1800                	add	s0,sp,48
    80001fbc:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001fbe:	84dff0ef          	jal	8000180a <myproc>
    80001fc2:	89aa                	mv	s3,a0
  if(p == initproc)
    80001fc4:	00006797          	auipc	a5,0x6
    80001fc8:	8ac7b783          	ld	a5,-1876(a5) # 80007870 <initproc>
    80001fcc:	0d050493          	add	s1,a0,208
    80001fd0:	15050913          	add	s2,a0,336
    80001fd4:	00a79f63          	bne	a5,a0,80001ff2 <kexit+0x46>
    panic("init exiting");
    80001fd8:	00005517          	auipc	a0,0x5
    80001fdc:	22050513          	add	a0,a0,544 # 800071f8 <digits+0x1c0>
    80001fe0:	fbefe0ef          	jal	8000079e <panic>
      fileclose(f);
    80001fe4:	0c2020ef          	jal	800040a6 <fileclose>
      p->ofile[fd] = 0;
    80001fe8:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001fec:	04a1                	add	s1,s1,8
    80001fee:	01248563          	beq	s1,s2,80001ff8 <kexit+0x4c>
    if(p->ofile[fd]){
    80001ff2:	6088                	ld	a0,0(s1)
    80001ff4:	f965                	bnez	a0,80001fe4 <kexit+0x38>
    80001ff6:	bfdd                	j	80001fec <kexit+0x40>
  begin_op();
    80001ff8:	4a9010ef          	jal	80003ca0 <begin_op>
  iput(p->cwd);
    80001ffc:	1509b503          	ld	a0,336(s3)
    80002000:	45c010ef          	jal	8000345c <iput>
  end_op();
    80002004:	507010ef          	jal	80003d0a <end_op>
  p->cwd = 0;
    80002008:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    8000200c:	0000e497          	auipc	s1,0xe
    80002010:	98448493          	add	s1,s1,-1660 # 8000f990 <wait_lock>
    80002014:	8526                	mv	a0,s1
    80002016:	b5ffe0ef          	jal	80000b74 <acquire>
  reparent(p);
    8000201a:	854e                	mv	a0,s3
    8000201c:	f3bff0ef          	jal	80001f56 <reparent>
  wakeup(p->parent);
    80002020:	0389b503          	ld	a0,56(s3)
    80002024:	ec9ff0ef          	jal	80001eec <wakeup>
  acquire(&p->lock);
    80002028:	854e                	mv	a0,s3
    8000202a:	b4bfe0ef          	jal	80000b74 <acquire>
  p->xstate = status;
    8000202e:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80002032:	4795                	li	a5,5
    80002034:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80002038:	8526                	mv	a0,s1
    8000203a:	bd3fe0ef          	jal	80000c0c <release>
  sched();
    8000203e:	d7dff0ef          	jal	80001dba <sched>
  panic("zombie exit");
    80002042:	00005517          	auipc	a0,0x5
    80002046:	1c650513          	add	a0,a0,454 # 80007208 <digits+0x1d0>
    8000204a:	f54fe0ef          	jal	8000079e <panic>

000000008000204e <kkill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kkill(int pid)
{
    8000204e:	7179                	add	sp,sp,-48
    80002050:	f406                	sd	ra,40(sp)
    80002052:	f022                	sd	s0,32(sp)
    80002054:	ec26                	sd	s1,24(sp)
    80002056:	e84a                	sd	s2,16(sp)
    80002058:	e44e                	sd	s3,8(sp)
    8000205a:	1800                	add	s0,sp,48
    8000205c:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    8000205e:	0000e497          	auipc	s1,0xe
    80002062:	d4a48493          	add	s1,s1,-694 # 8000fda8 <proc>
    80002066:	00014997          	auipc	s3,0x14
    8000206a:	94298993          	add	s3,s3,-1726 # 800159a8 <tickslock>
    acquire(&p->lock);
    8000206e:	8526                	mv	a0,s1
    80002070:	b05fe0ef          	jal	80000b74 <acquire>
    if(p->pid == pid){
    80002074:	589c                	lw	a5,48(s1)
    80002076:	01278b63          	beq	a5,s2,8000208c <kkill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    8000207a:	8526                	mv	a0,s1
    8000207c:	b91fe0ef          	jal	80000c0c <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80002080:	17048493          	add	s1,s1,368
    80002084:	ff3495e3          	bne	s1,s3,8000206e <kkill+0x20>
  }
  return -1;
    80002088:	557d                	li	a0,-1
    8000208a:	a819                	j	800020a0 <kkill+0x52>
      p->killed = 1;
    8000208c:	4785                	li	a5,1
    8000208e:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80002090:	4c98                	lw	a4,24(s1)
    80002092:	4789                	li	a5,2
    80002094:	00f70d63          	beq	a4,a5,800020ae <kkill+0x60>
      release(&p->lock);
    80002098:	8526                	mv	a0,s1
    8000209a:	b73fe0ef          	jal	80000c0c <release>
      return 0;
    8000209e:	4501                	li	a0,0
}
    800020a0:	70a2                	ld	ra,40(sp)
    800020a2:	7402                	ld	s0,32(sp)
    800020a4:	64e2                	ld	s1,24(sp)
    800020a6:	6942                	ld	s2,16(sp)
    800020a8:	69a2                	ld	s3,8(sp)
    800020aa:	6145                	add	sp,sp,48
    800020ac:	8082                	ret
        p->state = RUNNABLE;
    800020ae:	478d                	li	a5,3
    800020b0:	cc9c                	sw	a5,24(s1)
    800020b2:	b7dd                	j	80002098 <kkill+0x4a>

00000000800020b4 <setkilled>:

void
setkilled(struct proc *p)
{
    800020b4:	1101                	add	sp,sp,-32
    800020b6:	ec06                	sd	ra,24(sp)
    800020b8:	e822                	sd	s0,16(sp)
    800020ba:	e426                	sd	s1,8(sp)
    800020bc:	1000                	add	s0,sp,32
    800020be:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800020c0:	ab5fe0ef          	jal	80000b74 <acquire>
  p->killed = 1;
    800020c4:	4785                	li	a5,1
    800020c6:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    800020c8:	8526                	mv	a0,s1
    800020ca:	b43fe0ef          	jal	80000c0c <release>
}
    800020ce:	60e2                	ld	ra,24(sp)
    800020d0:	6442                	ld	s0,16(sp)
    800020d2:	64a2                	ld	s1,8(sp)
    800020d4:	6105                	add	sp,sp,32
    800020d6:	8082                	ret

00000000800020d8 <killed>:

int
killed(struct proc *p)
{
    800020d8:	1101                	add	sp,sp,-32
    800020da:	ec06                	sd	ra,24(sp)
    800020dc:	e822                	sd	s0,16(sp)
    800020de:	e426                	sd	s1,8(sp)
    800020e0:	e04a                	sd	s2,0(sp)
    800020e2:	1000                	add	s0,sp,32
    800020e4:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    800020e6:	a8ffe0ef          	jal	80000b74 <acquire>
  k = p->killed;
    800020ea:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    800020ee:	8526                	mv	a0,s1
    800020f0:	b1dfe0ef          	jal	80000c0c <release>
  return k;
}
    800020f4:	854a                	mv	a0,s2
    800020f6:	60e2                	ld	ra,24(sp)
    800020f8:	6442                	ld	s0,16(sp)
    800020fa:	64a2                	ld	s1,8(sp)
    800020fc:	6902                	ld	s2,0(sp)
    800020fe:	6105                	add	sp,sp,32
    80002100:	8082                	ret

0000000080002102 <kwait>:
{
    80002102:	715d                	add	sp,sp,-80
    80002104:	e486                	sd	ra,72(sp)
    80002106:	e0a2                	sd	s0,64(sp)
    80002108:	fc26                	sd	s1,56(sp)
    8000210a:	f84a                	sd	s2,48(sp)
    8000210c:	f44e                	sd	s3,40(sp)
    8000210e:	f052                	sd	s4,32(sp)
    80002110:	ec56                	sd	s5,24(sp)
    80002112:	e85a                	sd	s6,16(sp)
    80002114:	e45e                	sd	s7,8(sp)
    80002116:	e062                	sd	s8,0(sp)
    80002118:	0880                	add	s0,sp,80
    8000211a:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    8000211c:	eeeff0ef          	jal	8000180a <myproc>
    80002120:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80002122:	0000e517          	auipc	a0,0xe
    80002126:	86e50513          	add	a0,a0,-1938 # 8000f990 <wait_lock>
    8000212a:	a4bfe0ef          	jal	80000b74 <acquire>
    havekids = 0;
    8000212e:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    80002130:	4a15                	li	s4,5
        havekids = 1;
    80002132:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002134:	00014997          	auipc	s3,0x14
    80002138:	87498993          	add	s3,s3,-1932 # 800159a8 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000213c:	0000ec17          	auipc	s8,0xe
    80002140:	854c0c13          	add	s8,s8,-1964 # 8000f990 <wait_lock>
    80002144:	a871                	j	800021e0 <kwait+0xde>
          pid = pp->pid;
    80002146:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    8000214a:	000b0c63          	beqz	s6,80002162 <kwait+0x60>
    8000214e:	4691                	li	a3,4
    80002150:	02c48613          	add	a2,s1,44
    80002154:	85da                	mv	a1,s6
    80002156:	05093503          	ld	a0,80(s2)
    8000215a:	bfeff0ef          	jal	80001558 <copyout>
    8000215e:	02054b63          	bltz	a0,80002194 <kwait+0x92>
          freeproc(pp);
    80002162:	8526                	mv	a0,s1
    80002164:	877ff0ef          	jal	800019da <freeproc>
          release(&pp->lock);
    80002168:	8526                	mv	a0,s1
    8000216a:	aa3fe0ef          	jal	80000c0c <release>
          release(&wait_lock);
    8000216e:	0000e517          	auipc	a0,0xe
    80002172:	82250513          	add	a0,a0,-2014 # 8000f990 <wait_lock>
    80002176:	a97fe0ef          	jal	80000c0c <release>
}
    8000217a:	854e                	mv	a0,s3
    8000217c:	60a6                	ld	ra,72(sp)
    8000217e:	6406                	ld	s0,64(sp)
    80002180:	74e2                	ld	s1,56(sp)
    80002182:	7942                	ld	s2,48(sp)
    80002184:	79a2                	ld	s3,40(sp)
    80002186:	7a02                	ld	s4,32(sp)
    80002188:	6ae2                	ld	s5,24(sp)
    8000218a:	6b42                	ld	s6,16(sp)
    8000218c:	6ba2                	ld	s7,8(sp)
    8000218e:	6c02                	ld	s8,0(sp)
    80002190:	6161                	add	sp,sp,80
    80002192:	8082                	ret
            release(&pp->lock);
    80002194:	8526                	mv	a0,s1
    80002196:	a77fe0ef          	jal	80000c0c <release>
            release(&wait_lock);
    8000219a:	0000d517          	auipc	a0,0xd
    8000219e:	7f650513          	add	a0,a0,2038 # 8000f990 <wait_lock>
    800021a2:	a6bfe0ef          	jal	80000c0c <release>
            return -1;
    800021a6:	59fd                	li	s3,-1
    800021a8:	bfc9                	j	8000217a <kwait+0x78>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800021aa:	17048493          	add	s1,s1,368
    800021ae:	03348063          	beq	s1,s3,800021ce <kwait+0xcc>
      if(pp->parent == p){
    800021b2:	7c9c                	ld	a5,56(s1)
    800021b4:	ff279be3          	bne	a5,s2,800021aa <kwait+0xa8>
        acquire(&pp->lock);
    800021b8:	8526                	mv	a0,s1
    800021ba:	9bbfe0ef          	jal	80000b74 <acquire>
        if(pp->state == ZOMBIE){
    800021be:	4c9c                	lw	a5,24(s1)
    800021c0:	f94783e3          	beq	a5,s4,80002146 <kwait+0x44>
        release(&pp->lock);
    800021c4:	8526                	mv	a0,s1
    800021c6:	a47fe0ef          	jal	80000c0c <release>
        havekids = 1;
    800021ca:	8756                	mv	a4,s5
    800021cc:	bff9                	j	800021aa <kwait+0xa8>
    if(!havekids || killed(p)){
    800021ce:	cf19                	beqz	a4,800021ec <kwait+0xea>
    800021d0:	854a                	mv	a0,s2
    800021d2:	f07ff0ef          	jal	800020d8 <killed>
    800021d6:	e919                	bnez	a0,800021ec <kwait+0xea>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800021d8:	85e2                	mv	a1,s8
    800021da:	854a                	mv	a0,s2
    800021dc:	cc5ff0ef          	jal	80001ea0 <sleep>
    havekids = 0;
    800021e0:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800021e2:	0000e497          	auipc	s1,0xe
    800021e6:	bc648493          	add	s1,s1,-1082 # 8000fda8 <proc>
    800021ea:	b7e1                	j	800021b2 <kwait+0xb0>
      release(&wait_lock);
    800021ec:	0000d517          	auipc	a0,0xd
    800021f0:	7a450513          	add	a0,a0,1956 # 8000f990 <wait_lock>
    800021f4:	a19fe0ef          	jal	80000c0c <release>
      return -1;
    800021f8:	59fd                	li	s3,-1
    800021fa:	b741                	j	8000217a <kwait+0x78>

00000000800021fc <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800021fc:	7179                	add	sp,sp,-48
    800021fe:	f406                	sd	ra,40(sp)
    80002200:	f022                	sd	s0,32(sp)
    80002202:	ec26                	sd	s1,24(sp)
    80002204:	e84a                	sd	s2,16(sp)
    80002206:	e44e                	sd	s3,8(sp)
    80002208:	e052                	sd	s4,0(sp)
    8000220a:	1800                	add	s0,sp,48
    8000220c:	84aa                	mv	s1,a0
    8000220e:	892e                	mv	s2,a1
    80002210:	89b2                	mv	s3,a2
    80002212:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002214:	df6ff0ef          	jal	8000180a <myproc>
  if(user_dst){
    80002218:	cc99                	beqz	s1,80002236 <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    8000221a:	86d2                	mv	a3,s4
    8000221c:	864e                	mv	a2,s3
    8000221e:	85ca                	mv	a1,s2
    80002220:	6928                	ld	a0,80(a0)
    80002222:	b36ff0ef          	jal	80001558 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80002226:	70a2                	ld	ra,40(sp)
    80002228:	7402                	ld	s0,32(sp)
    8000222a:	64e2                	ld	s1,24(sp)
    8000222c:	6942                	ld	s2,16(sp)
    8000222e:	69a2                	ld	s3,8(sp)
    80002230:	6a02                	ld	s4,0(sp)
    80002232:	6145                	add	sp,sp,48
    80002234:	8082                	ret
    memmove((char *)dst, src, len);
    80002236:	000a061b          	sext.w	a2,s4
    8000223a:	85ce                	mv	a1,s3
    8000223c:	854a                	mv	a0,s2
    8000223e:	a67fe0ef          	jal	80000ca4 <memmove>
    return 0;
    80002242:	8526                	mv	a0,s1
    80002244:	b7cd                	j	80002226 <either_copyout+0x2a>

0000000080002246 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80002246:	7179                	add	sp,sp,-48
    80002248:	f406                	sd	ra,40(sp)
    8000224a:	f022                	sd	s0,32(sp)
    8000224c:	ec26                	sd	s1,24(sp)
    8000224e:	e84a                	sd	s2,16(sp)
    80002250:	e44e                	sd	s3,8(sp)
    80002252:	e052                	sd	s4,0(sp)
    80002254:	1800                	add	s0,sp,48
    80002256:	892a                	mv	s2,a0
    80002258:	84ae                	mv	s1,a1
    8000225a:	89b2                	mv	s3,a2
    8000225c:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000225e:	dacff0ef          	jal	8000180a <myproc>
  if(user_src){
    80002262:	cc99                	beqz	s1,80002280 <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    80002264:	86d2                	mv	a3,s4
    80002266:	864e                	mv	a2,s3
    80002268:	85ca                	mv	a1,s2
    8000226a:	6928                	ld	a0,80(a0)
    8000226c:	bb2ff0ef          	jal	8000161e <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80002270:	70a2                	ld	ra,40(sp)
    80002272:	7402                	ld	s0,32(sp)
    80002274:	64e2                	ld	s1,24(sp)
    80002276:	6942                	ld	s2,16(sp)
    80002278:	69a2                	ld	s3,8(sp)
    8000227a:	6a02                	ld	s4,0(sp)
    8000227c:	6145                	add	sp,sp,48
    8000227e:	8082                	ret
    memmove(dst, (char*)src, len);
    80002280:	000a061b          	sext.w	a2,s4
    80002284:	85ce                	mv	a1,s3
    80002286:	854a                	mv	a0,s2
    80002288:	a1dfe0ef          	jal	80000ca4 <memmove>
    return 0;
    8000228c:	8526                	mv	a0,s1
    8000228e:	b7cd                	j	80002270 <either_copyin+0x2a>

0000000080002290 <kgetpinfo>:
// Fill in pstat with information about all processes.
// Returns 0 on success, -1 if st is null.
int
kgetpinfo(struct pstat *st)
{
  if(st == 0)
    80002290:	c525                	beqz	a0,800022f8 <kgetpinfo+0x68>
{
    80002292:	7179                	add	sp,sp,-48
    80002294:	f406                	sd	ra,40(sp)
    80002296:	f022                	sd	s0,32(sp)
    80002298:	ec26                	sd	s1,24(sp)
    8000229a:	e84a                	sd	s2,16(sp)
    8000229c:	e44e                	sd	s3,8(sp)
    8000229e:	1800                	add	s0,sp,48
    800022a0:	892a                	mv	s2,a0
    return -1;

  struct proc *p;
  int i = 0;
  for(p = proc; p < &proc[NPROC]; p++, i++) {
    800022a2:	0000e497          	auipc	s1,0xe
    800022a6:	b0648493          	add	s1,s1,-1274 # 8000fda8 <proc>
    800022aa:	00013997          	auipc	s3,0x13
    800022ae:	6fe98993          	add	s3,s3,1790 # 800159a8 <tickslock>
    acquire(&p->lock);
    800022b2:	8526                	mv	a0,s1
    800022b4:	8c1fe0ef          	jal	80000b74 <acquire>
    st->inuse[i]   = (p->state != UNUSED);
    800022b8:	4c9c                	lw	a5,24(s1)
    800022ba:	00f037b3          	snez	a5,a5
    800022be:	00f92023          	sw	a5,0(s2)
    st->tickets[i] = p->tickets;
    800022c2:	1684a783          	lw	a5,360(s1)
    800022c6:	10f92023          	sw	a5,256(s2)
    st->pid[i]     = p->pid;
    800022ca:	589c                	lw	a5,48(s1)
    800022cc:	20f92023          	sw	a5,512(s2)
    st->ticks[i]   = p->ticks;
    800022d0:	16c4a783          	lw	a5,364(s1)
    800022d4:	30f92023          	sw	a5,768(s2)
    release(&p->lock);
    800022d8:	8526                	mv	a0,s1
    800022da:	933fe0ef          	jal	80000c0c <release>
  for(p = proc; p < &proc[NPROC]; p++, i++) {
    800022de:	17048493          	add	s1,s1,368
    800022e2:	0911                	add	s2,s2,4
    800022e4:	fd3497e3          	bne	s1,s3,800022b2 <kgetpinfo+0x22>
  }
  return 0;
    800022e8:	4501                	li	a0,0
}
    800022ea:	70a2                	ld	ra,40(sp)
    800022ec:	7402                	ld	s0,32(sp)
    800022ee:	64e2                	ld	s1,24(sp)
    800022f0:	6942                	ld	s2,16(sp)
    800022f2:	69a2                	ld	s3,8(sp)
    800022f4:	6145                	add	sp,sp,48
    800022f6:	8082                	ret
    return -1;
    800022f8:	557d                	li	a0,-1
}
    800022fa:	8082                	ret

00000000800022fc <ksettickets>:
// Set the number of tickets for the calling process.
// Returns 0 on success, -1 if number < 1.
int
ksettickets(int number)
{
  if(number < 1)
    800022fc:	02a05a63          	blez	a0,80002330 <ksettickets+0x34>
{
    80002300:	1101                	add	sp,sp,-32
    80002302:	ec06                	sd	ra,24(sp)
    80002304:	e822                	sd	s0,16(sp)
    80002306:	e426                	sd	s1,8(sp)
    80002308:	e04a                	sd	s2,0(sp)
    8000230a:	1000                	add	s0,sp,32
    8000230c:	84aa                	mv	s1,a0
    return -1;
  struct proc *p = myproc();
    8000230e:	cfcff0ef          	jal	8000180a <myproc>
    80002312:	892a                	mv	s2,a0
  acquire(&p->lock);
    80002314:	861fe0ef          	jal	80000b74 <acquire>
  p->tickets = number;
    80002318:	16992423          	sw	s1,360(s2)
  release(&p->lock);
    8000231c:	854a                	mv	a0,s2
    8000231e:	8effe0ef          	jal	80000c0c <release>
  return 0;
    80002322:	4501                	li	a0,0
}
    80002324:	60e2                	ld	ra,24(sp)
    80002326:	6442                	ld	s0,16(sp)
    80002328:	64a2                	ld	s1,8(sp)
    8000232a:	6902                	ld	s2,0(sp)
    8000232c:	6105                	add	sp,sp,32
    8000232e:	8082                	ret
    return -1;
    80002330:	557d                	li	a0,-1
}
    80002332:	8082                	ret

0000000080002334 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80002334:	715d                	add	sp,sp,-80
    80002336:	e486                	sd	ra,72(sp)
    80002338:	e0a2                	sd	s0,64(sp)
    8000233a:	fc26                	sd	s1,56(sp)
    8000233c:	f84a                	sd	s2,48(sp)
    8000233e:	f44e                	sd	s3,40(sp)
    80002340:	f052                	sd	s4,32(sp)
    80002342:	ec56                	sd	s5,24(sp)
    80002344:	e85a                	sd	s6,16(sp)
    80002346:	e45e                	sd	s7,8(sp)
    80002348:	0880                	add	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    8000234a:	00005517          	auipc	a0,0x5
    8000234e:	d7650513          	add	a0,a0,-650 # 800070c0 <digits+0x88>
    80002352:	97afe0ef          	jal	800004cc <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002356:	0000e497          	auipc	s1,0xe
    8000235a:	baa48493          	add	s1,s1,-1110 # 8000ff00 <proc+0x158>
    8000235e:	00013917          	auipc	s2,0x13
    80002362:	7a290913          	add	s2,s2,1954 # 80015b00 <bcache+0xd8>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002366:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80002368:	00005997          	auipc	s3,0x5
    8000236c:	eb098993          	add	s3,s3,-336 # 80007218 <digits+0x1e0>
    printf("%d %s %s", p->pid, state, p->name);
    80002370:	00005a97          	auipc	s5,0x5
    80002374:	eb0a8a93          	add	s5,s5,-336 # 80007220 <digits+0x1e8>
    printf("\n");
    80002378:	00005a17          	auipc	s4,0x5
    8000237c:	d48a0a13          	add	s4,s4,-696 # 800070c0 <digits+0x88>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002380:	00005b97          	auipc	s7,0x5
    80002384:	ee0b8b93          	add	s7,s7,-288 # 80007260 <states.0>
    80002388:	a829                	j	800023a2 <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    8000238a:	ed86a583          	lw	a1,-296(a3)
    8000238e:	8556                	mv	a0,s5
    80002390:	93cfe0ef          	jal	800004cc <printf>
    printf("\n");
    80002394:	8552                	mv	a0,s4
    80002396:	936fe0ef          	jal	800004cc <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    8000239a:	17048493          	add	s1,s1,368
    8000239e:	03248263          	beq	s1,s2,800023c2 <procdump+0x8e>
    if(p->state == UNUSED)
    800023a2:	86a6                	mv	a3,s1
    800023a4:	ec04a783          	lw	a5,-320(s1)
    800023a8:	dbed                	beqz	a5,8000239a <procdump+0x66>
      state = "???";
    800023aa:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800023ac:	fcfb6fe3          	bltu	s6,a5,8000238a <procdump+0x56>
    800023b0:	02079713          	sll	a4,a5,0x20
    800023b4:	01d75793          	srl	a5,a4,0x1d
    800023b8:	97de                	add	a5,a5,s7
    800023ba:	6390                	ld	a2,0(a5)
    800023bc:	f679                	bnez	a2,8000238a <procdump+0x56>
      state = "???";
    800023be:	864e                	mv	a2,s3
    800023c0:	b7e9                	j	8000238a <procdump+0x56>
  }
}
    800023c2:	60a6                	ld	ra,72(sp)
    800023c4:	6406                	ld	s0,64(sp)
    800023c6:	74e2                	ld	s1,56(sp)
    800023c8:	7942                	ld	s2,48(sp)
    800023ca:	79a2                	ld	s3,40(sp)
    800023cc:	7a02                	ld	s4,32(sp)
    800023ce:	6ae2                	ld	s5,24(sp)
    800023d0:	6b42                	ld	s6,16(sp)
    800023d2:	6ba2                	ld	s7,8(sp)
    800023d4:	6161                	add	sp,sp,80
    800023d6:	8082                	ret

00000000800023d8 <swtch>:
# Save current registers in old. Load from new.	


.globl swtch
swtch:
        sd ra, 0(a0)
    800023d8:	00153023          	sd	ra,0(a0)
        sd sp, 8(a0)
    800023dc:	00253423          	sd	sp,8(a0)
        sd s0, 16(a0)
    800023e0:	e900                	sd	s0,16(a0)
        sd s1, 24(a0)
    800023e2:	ed04                	sd	s1,24(a0)
        sd s2, 32(a0)
    800023e4:	03253023          	sd	s2,32(a0)
        sd s3, 40(a0)
    800023e8:	03353423          	sd	s3,40(a0)
        sd s4, 48(a0)
    800023ec:	03453823          	sd	s4,48(a0)
        sd s5, 56(a0)
    800023f0:	03553c23          	sd	s5,56(a0)
        sd s6, 64(a0)
    800023f4:	05653023          	sd	s6,64(a0)
        sd s7, 72(a0)
    800023f8:	05753423          	sd	s7,72(a0)
        sd s8, 80(a0)
    800023fc:	05853823          	sd	s8,80(a0)
        sd s9, 88(a0)
    80002400:	05953c23          	sd	s9,88(a0)
        sd s10, 96(a0)
    80002404:	07a53023          	sd	s10,96(a0)
        sd s11, 104(a0)
    80002408:	07b53423          	sd	s11,104(a0)

        ld ra, 0(a1)
    8000240c:	0005b083          	ld	ra,0(a1)
        ld sp, 8(a1)
    80002410:	0085b103          	ld	sp,8(a1)
        ld s0, 16(a1)
    80002414:	6980                	ld	s0,16(a1)
        ld s1, 24(a1)
    80002416:	6d84                	ld	s1,24(a1)
        ld s2, 32(a1)
    80002418:	0205b903          	ld	s2,32(a1)
        ld s3, 40(a1)
    8000241c:	0285b983          	ld	s3,40(a1)
        ld s4, 48(a1)
    80002420:	0305ba03          	ld	s4,48(a1)
        ld s5, 56(a1)
    80002424:	0385ba83          	ld	s5,56(a1)
        ld s6, 64(a1)
    80002428:	0405bb03          	ld	s6,64(a1)
        ld s7, 72(a1)
    8000242c:	0485bb83          	ld	s7,72(a1)
        ld s8, 80(a1)
    80002430:	0505bc03          	ld	s8,80(a1)
        ld s9, 88(a1)
    80002434:	0585bc83          	ld	s9,88(a1)
        ld s10, 96(a1)
    80002438:	0605bd03          	ld	s10,96(a1)
        ld s11, 104(a1)
    8000243c:	0685bd83          	ld	s11,104(a1)
        
        ret
    80002440:	8082                	ret

0000000080002442 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80002442:	1141                	add	sp,sp,-16
    80002444:	e406                	sd	ra,8(sp)
    80002446:	e022                	sd	s0,0(sp)
    80002448:	0800                	add	s0,sp,16
  initlock(&tickslock, "time");
    8000244a:	00005597          	auipc	a1,0x5
    8000244e:	e4658593          	add	a1,a1,-442 # 80007290 <states.0+0x30>
    80002452:	00013517          	auipc	a0,0x13
    80002456:	55650513          	add	a0,a0,1366 # 800159a8 <tickslock>
    8000245a:	e9afe0ef          	jal	80000af4 <initlock>
}
    8000245e:	60a2                	ld	ra,8(sp)
    80002460:	6402                	ld	s0,0(sp)
    80002462:	0141                	add	sp,sp,16
    80002464:	8082                	ret

0000000080002466 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80002466:	1141                	add	sp,sp,-16
    80002468:	e422                	sd	s0,8(sp)
    8000246a:	0800                	add	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000246c:	00003797          	auipc	a5,0x3
    80002470:	ed478793          	add	a5,a5,-300 # 80005340 <kernelvec>
    80002474:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80002478:	6422                	ld	s0,8(sp)
    8000247a:	0141                	add	sp,sp,16
    8000247c:	8082                	ret

000000008000247e <prepare_return>:
//
// set up trapframe and control registers for a return to user space
//
void
prepare_return(void)
{
    8000247e:	1141                	add	sp,sp,-16
    80002480:	e406                	sd	ra,8(sp)
    80002482:	e022                	sd	s0,0(sp)
    80002484:	0800                	add	s0,sp,16
  struct proc *p = myproc();
    80002486:	b84ff0ef          	jal	8000180a <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000248a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8000248e:	9bf5                	and	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002490:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(). because a trap from kernel
  // code to usertrap would be a disaster, turn off interrupts.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80002494:	04000737          	lui	a4,0x4000
    80002498:	00004797          	auipc	a5,0x4
    8000249c:	b6878793          	add	a5,a5,-1176 # 80006000 <_trampoline>
    800024a0:	00004697          	auipc	a3,0x4
    800024a4:	b6068693          	add	a3,a3,-1184 # 80006000 <_trampoline>
    800024a8:	8f95                	sub	a5,a5,a3
    800024aa:	177d                	add	a4,a4,-1 # 3ffffff <_entry-0x7c000001>
    800024ac:	0732                	sll	a4,a4,0xc
    800024ae:	97ba                	add	a5,a5,a4
  asm volatile("csrw stvec, %0" : : "r" (x));
    800024b0:	10579073          	csrw	stvec,a5
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    800024b4:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    800024b6:	18002773          	csrr	a4,satp
    800024ba:	e398                	sd	a4,0(a5)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    800024bc:	6d38                	ld	a4,88(a0)
    800024be:	613c                	ld	a5,64(a0)
    800024c0:	6685                	lui	a3,0x1
    800024c2:	97b6                	add	a5,a5,a3
    800024c4:	e71c                	sd	a5,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    800024c6:	6d3c                	ld	a5,88(a0)
    800024c8:	00000717          	auipc	a4,0x0
    800024cc:	0f470713          	add	a4,a4,244 # 800025bc <usertrap>
    800024d0:	eb98                	sd	a4,16(a5)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    800024d2:	6d3c                	ld	a5,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    800024d4:	8712                	mv	a4,tp
    800024d6:	f398                	sd	a4,32(a5)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800024d8:	100027f3          	csrr	a5,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    800024dc:	eff7f793          	and	a5,a5,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    800024e0:	0207e793          	or	a5,a5,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800024e4:	10079073          	csrw	sstatus,a5
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    800024e8:	6d3c                	ld	a5,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    800024ea:	6f9c                	ld	a5,24(a5)
    800024ec:	14179073          	csrw	sepc,a5
}
    800024f0:	60a2                	ld	ra,8(sp)
    800024f2:	6402                	ld	s0,0(sp)
    800024f4:	0141                	add	sp,sp,16
    800024f6:	8082                	ret

00000000800024f8 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    800024f8:	1101                	add	sp,sp,-32
    800024fa:	ec06                	sd	ra,24(sp)
    800024fc:	e822                	sd	s0,16(sp)
    800024fe:	e426                	sd	s1,8(sp)
    80002500:	1000                	add	s0,sp,32
  if(cpuid() == 0){
    80002502:	adcff0ef          	jal	800017de <cpuid>
    80002506:	cd19                	beqz	a0,80002524 <clockintr+0x2c>
  asm volatile("csrr %0, time" : "=r" (x) );
    80002508:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    8000250c:	000f4737          	lui	a4,0xf4
    80002510:	24070713          	add	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80002514:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80002516:	14d79073          	csrw	stimecmp,a5
}
    8000251a:	60e2                	ld	ra,24(sp)
    8000251c:	6442                	ld	s0,16(sp)
    8000251e:	64a2                	ld	s1,8(sp)
    80002520:	6105                	add	sp,sp,32
    80002522:	8082                	ret
    acquire(&tickslock);
    80002524:	00013497          	auipc	s1,0x13
    80002528:	48448493          	add	s1,s1,1156 # 800159a8 <tickslock>
    8000252c:	8526                	mv	a0,s1
    8000252e:	e46fe0ef          	jal	80000b74 <acquire>
    ticks++;
    80002532:	00005517          	auipc	a0,0x5
    80002536:	34650513          	add	a0,a0,838 # 80007878 <ticks>
    8000253a:	411c                	lw	a5,0(a0)
    8000253c:	2785                	addw	a5,a5,1
    8000253e:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    80002540:	9adff0ef          	jal	80001eec <wakeup>
    release(&tickslock);
    80002544:	8526                	mv	a0,s1
    80002546:	ec6fe0ef          	jal	80000c0c <release>
    8000254a:	bf7d                	j	80002508 <clockintr+0x10>

000000008000254c <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    8000254c:	1101                	add	sp,sp,-32
    8000254e:	ec06                	sd	ra,24(sp)
    80002550:	e822                	sd	s0,16(sp)
    80002552:	e426                	sd	s1,8(sp)
    80002554:	1000                	add	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002556:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    8000255a:	57fd                	li	a5,-1
    8000255c:	17fe                	sll	a5,a5,0x3f
    8000255e:	07a5                	add	a5,a5,9
    80002560:	00f70d63          	beq	a4,a5,8000257a <devintr+0x2e>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    80002564:	57fd                	li	a5,-1
    80002566:	17fe                	sll	a5,a5,0x3f
    80002568:	0795                	add	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    8000256a:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    8000256c:	04f70463          	beq	a4,a5,800025b4 <devintr+0x68>
  }
}
    80002570:	60e2                	ld	ra,24(sp)
    80002572:	6442                	ld	s0,16(sp)
    80002574:	64a2                	ld	s1,8(sp)
    80002576:	6105                	add	sp,sp,32
    80002578:	8082                	ret
    int irq = plic_claim();
    8000257a:	66f020ef          	jal	800053e8 <plic_claim>
    8000257e:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80002580:	47a9                	li	a5,10
    80002582:	02f50363          	beq	a0,a5,800025a8 <devintr+0x5c>
    } else if(irq == VIRTIO0_IRQ){
    80002586:	4785                	li	a5,1
    80002588:	02f50363          	beq	a0,a5,800025ae <devintr+0x62>
    return 1;
    8000258c:	4505                	li	a0,1
    } else if(irq){
    8000258e:	d0ed                	beqz	s1,80002570 <devintr+0x24>
      printf("unexpected interrupt irq=%d\n", irq);
    80002590:	85a6                	mv	a1,s1
    80002592:	00005517          	auipc	a0,0x5
    80002596:	d0650513          	add	a0,a0,-762 # 80007298 <states.0+0x38>
    8000259a:	f33fd0ef          	jal	800004cc <printf>
      plic_complete(irq);
    8000259e:	8526                	mv	a0,s1
    800025a0:	669020ef          	jal	80005408 <plic_complete>
    return 1;
    800025a4:	4505                	li	a0,1
    800025a6:	b7e9                	j	80002570 <devintr+0x24>
      uartintr();
    800025a8:	bb6fe0ef          	jal	8000095e <uartintr>
    if(irq)
    800025ac:	bfcd                	j	8000259e <devintr+0x52>
      virtio_disk_intr();
    800025ae:	2c4030ef          	jal	80005872 <virtio_disk_intr>
    if(irq)
    800025b2:	b7f5                	j	8000259e <devintr+0x52>
    clockintr();
    800025b4:	f45ff0ef          	jal	800024f8 <clockintr>
    return 2;
    800025b8:	4509                	li	a0,2
    800025ba:	bf5d                	j	80002570 <devintr+0x24>

00000000800025bc <usertrap>:
{
    800025bc:	1101                	add	sp,sp,-32
    800025be:	ec06                	sd	ra,24(sp)
    800025c0:	e822                	sd	s0,16(sp)
    800025c2:	e426                	sd	s1,8(sp)
    800025c4:	e04a                	sd	s2,0(sp)
    800025c6:	1000                	add	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800025c8:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    800025cc:	1007f793          	and	a5,a5,256
    800025d0:	eba5                	bnez	a5,80002640 <usertrap+0x84>
  asm volatile("csrw stvec, %0" : : "r" (x));
    800025d2:	00003797          	auipc	a5,0x3
    800025d6:	d6e78793          	add	a5,a5,-658 # 80005340 <kernelvec>
    800025da:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    800025de:	a2cff0ef          	jal	8000180a <myproc>
    800025e2:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    800025e4:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800025e6:	14102773          	csrr	a4,sepc
    800025ea:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    800025ec:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    800025f0:	47a1                	li	a5,8
    800025f2:	04f70d63          	beq	a4,a5,8000264c <usertrap+0x90>
  } else if((which_dev = devintr()) != 0){
    800025f6:	f57ff0ef          	jal	8000254c <devintr>
    800025fa:	892a                	mv	s2,a0
    800025fc:	e945                	bnez	a0,800026ac <usertrap+0xf0>
    800025fe:	14202773          	csrr	a4,scause
  } else if((r_scause() == 15 || r_scause() == 13) &&
    80002602:	47bd                	li	a5,15
    80002604:	08f70863          	beq	a4,a5,80002694 <usertrap+0xd8>
    80002608:	14202773          	csrr	a4,scause
    8000260c:	47b5                	li	a5,13
    8000260e:	08f70363          	beq	a4,a5,80002694 <usertrap+0xd8>
    80002612:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    80002616:	5890                	lw	a2,48(s1)
    80002618:	00005517          	auipc	a0,0x5
    8000261c:	cc050513          	add	a0,a0,-832 # 800072d8 <states.0+0x78>
    80002620:	eadfd0ef          	jal	800004cc <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002624:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002628:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    8000262c:	00005517          	auipc	a0,0x5
    80002630:	cdc50513          	add	a0,a0,-804 # 80007308 <states.0+0xa8>
    80002634:	e99fd0ef          	jal	800004cc <printf>
    setkilled(p);
    80002638:	8526                	mv	a0,s1
    8000263a:	a7bff0ef          	jal	800020b4 <setkilled>
    8000263e:	a035                	j	8000266a <usertrap+0xae>
    panic("usertrap: not from user mode");
    80002640:	00005517          	auipc	a0,0x5
    80002644:	c7850513          	add	a0,a0,-904 # 800072b8 <states.0+0x58>
    80002648:	956fe0ef          	jal	8000079e <panic>
    if(killed(p))
    8000264c:	a8dff0ef          	jal	800020d8 <killed>
    80002650:	ed15                	bnez	a0,8000268c <usertrap+0xd0>
    p->trapframe->epc += 4;
    80002652:	6cb8                	ld	a4,88(s1)
    80002654:	6f1c                	ld	a5,24(a4)
    80002656:	0791                	add	a5,a5,4
    80002658:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000265a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000265e:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002662:	10079073          	csrw	sstatus,a5
    syscall();
    80002666:	27e000ef          	jal	800028e4 <syscall>
  if(killed(p))
    8000266a:	8526                	mv	a0,s1
    8000266c:	a6dff0ef          	jal	800020d8 <killed>
    80002670:	e139                	bnez	a0,800026b6 <usertrap+0xfa>
  prepare_return();
    80002672:	e0dff0ef          	jal	8000247e <prepare_return>
  uint64 satp = MAKE_SATP(p->pagetable);
    80002676:	68a8                	ld	a0,80(s1)
    80002678:	8131                	srl	a0,a0,0xc
    8000267a:	57fd                	li	a5,-1
    8000267c:	17fe                	sll	a5,a5,0x3f
    8000267e:	8d5d                	or	a0,a0,a5
}
    80002680:	60e2                	ld	ra,24(sp)
    80002682:	6442                	ld	s0,16(sp)
    80002684:	64a2                	ld	s1,8(sp)
    80002686:	6902                	ld	s2,0(sp)
    80002688:	6105                	add	sp,sp,32
    8000268a:	8082                	ret
      kexit(-1);
    8000268c:	557d                	li	a0,-1
    8000268e:	91fff0ef          	jal	80001fac <kexit>
    80002692:	b7c1                	j	80002652 <usertrap+0x96>
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002694:	143025f3          	csrr	a1,stval
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002698:	14202673          	csrr	a2,scause
            vmfault(p->pagetable, r_stval(), (r_scause() == 13)? 1 : 0) != 0) {
    8000269c:	164d                	add	a2,a2,-13 # ff3 <_entry-0x7ffff00d>
    8000269e:	00163613          	seqz	a2,a2
    800026a2:	68a8                	ld	a0,80(s1)
    800026a4:	e43fe0ef          	jal	800014e6 <vmfault>
  } else if((r_scause() == 15 || r_scause() == 13) &&
    800026a8:	f169                	bnez	a0,8000266a <usertrap+0xae>
    800026aa:	b7a5                	j	80002612 <usertrap+0x56>
  if(killed(p))
    800026ac:	8526                	mv	a0,s1
    800026ae:	a2bff0ef          	jal	800020d8 <killed>
    800026b2:	c511                	beqz	a0,800026be <usertrap+0x102>
    800026b4:	a011                	j	800026b8 <usertrap+0xfc>
    800026b6:	4901                	li	s2,0
    kexit(-1);
    800026b8:	557d                	li	a0,-1
    800026ba:	8f3ff0ef          	jal	80001fac <kexit>
  if(which_dev == 2)
    800026be:	4789                	li	a5,2
    800026c0:	faf919e3          	bne	s2,a5,80002672 <usertrap+0xb6>
    yield();
    800026c4:	fb0ff0ef          	jal	80001e74 <yield>
    800026c8:	b76d                	j	80002672 <usertrap+0xb6>

00000000800026ca <kerneltrap>:
{
    800026ca:	7179                	add	sp,sp,-48
    800026cc:	f406                	sd	ra,40(sp)
    800026ce:	f022                	sd	s0,32(sp)
    800026d0:	ec26                	sd	s1,24(sp)
    800026d2:	e84a                	sd	s2,16(sp)
    800026d4:	e44e                	sd	s3,8(sp)
    800026d6:	1800                	add	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800026d8:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800026dc:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    800026e0:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    800026e4:	1004f793          	and	a5,s1,256
    800026e8:	c795                	beqz	a5,80002714 <kerneltrap+0x4a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800026ea:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800026ee:	8b89                	and	a5,a5,2
  if(intr_get() != 0)
    800026f0:	eb85                	bnez	a5,80002720 <kerneltrap+0x56>
  if((which_dev = devintr()) == 0){
    800026f2:	e5bff0ef          	jal	8000254c <devintr>
    800026f6:	c91d                	beqz	a0,8000272c <kerneltrap+0x62>
  if(which_dev == 2 && myproc() != 0)
    800026f8:	4789                	li	a5,2
    800026fa:	04f50a63          	beq	a0,a5,8000274e <kerneltrap+0x84>
  asm volatile("csrw sepc, %0" : : "r" (x));
    800026fe:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002702:	10049073          	csrw	sstatus,s1
}
    80002706:	70a2                	ld	ra,40(sp)
    80002708:	7402                	ld	s0,32(sp)
    8000270a:	64e2                	ld	s1,24(sp)
    8000270c:	6942                	ld	s2,16(sp)
    8000270e:	69a2                	ld	s3,8(sp)
    80002710:	6145                	add	sp,sp,48
    80002712:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002714:	00005517          	auipc	a0,0x5
    80002718:	c1c50513          	add	a0,a0,-996 # 80007330 <states.0+0xd0>
    8000271c:	882fe0ef          	jal	8000079e <panic>
    panic("kerneltrap: interrupts enabled");
    80002720:	00005517          	auipc	a0,0x5
    80002724:	c3850513          	add	a0,a0,-968 # 80007358 <states.0+0xf8>
    80002728:	876fe0ef          	jal	8000079e <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000272c:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002730:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    80002734:	85ce                	mv	a1,s3
    80002736:	00005517          	auipc	a0,0x5
    8000273a:	c4250513          	add	a0,a0,-958 # 80007378 <states.0+0x118>
    8000273e:	d8ffd0ef          	jal	800004cc <printf>
    panic("kerneltrap");
    80002742:	00005517          	auipc	a0,0x5
    80002746:	c5e50513          	add	a0,a0,-930 # 800073a0 <states.0+0x140>
    8000274a:	854fe0ef          	jal	8000079e <panic>
  if(which_dev == 2 && myproc() != 0)
    8000274e:	8bcff0ef          	jal	8000180a <myproc>
    80002752:	d555                	beqz	a0,800026fe <kerneltrap+0x34>
    yield();
    80002754:	f20ff0ef          	jal	80001e74 <yield>
    80002758:	b75d                	j	800026fe <kerneltrap+0x34>

000000008000275a <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    8000275a:	1101                	add	sp,sp,-32
    8000275c:	ec06                	sd	ra,24(sp)
    8000275e:	e822                	sd	s0,16(sp)
    80002760:	e426                	sd	s1,8(sp)
    80002762:	1000                	add	s0,sp,32
    80002764:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002766:	8a4ff0ef          	jal	8000180a <myproc>
  switch (n) {
    8000276a:	4795                	li	a5,5
    8000276c:	0497e163          	bltu	a5,s1,800027ae <argraw+0x54>
    80002770:	048a                	sll	s1,s1,0x2
    80002772:	00005717          	auipc	a4,0x5
    80002776:	c6670713          	add	a4,a4,-922 # 800073d8 <states.0+0x178>
    8000277a:	94ba                	add	s1,s1,a4
    8000277c:	409c                	lw	a5,0(s1)
    8000277e:	97ba                	add	a5,a5,a4
    80002780:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002782:	6d3c                	ld	a5,88(a0)
    80002784:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002786:	60e2                	ld	ra,24(sp)
    80002788:	6442                	ld	s0,16(sp)
    8000278a:	64a2                	ld	s1,8(sp)
    8000278c:	6105                	add	sp,sp,32
    8000278e:	8082                	ret
    return p->trapframe->a1;
    80002790:	6d3c                	ld	a5,88(a0)
    80002792:	7fa8                	ld	a0,120(a5)
    80002794:	bfcd                	j	80002786 <argraw+0x2c>
    return p->trapframe->a2;
    80002796:	6d3c                	ld	a5,88(a0)
    80002798:	63c8                	ld	a0,128(a5)
    8000279a:	b7f5                	j	80002786 <argraw+0x2c>
    return p->trapframe->a3;
    8000279c:	6d3c                	ld	a5,88(a0)
    8000279e:	67c8                	ld	a0,136(a5)
    800027a0:	b7dd                	j	80002786 <argraw+0x2c>
    return p->trapframe->a4;
    800027a2:	6d3c                	ld	a5,88(a0)
    800027a4:	6bc8                	ld	a0,144(a5)
    800027a6:	b7c5                	j	80002786 <argraw+0x2c>
    return p->trapframe->a5;
    800027a8:	6d3c                	ld	a5,88(a0)
    800027aa:	6fc8                	ld	a0,152(a5)
    800027ac:	bfe9                	j	80002786 <argraw+0x2c>
  panic("argraw");
    800027ae:	00005517          	auipc	a0,0x5
    800027b2:	c0250513          	add	a0,a0,-1022 # 800073b0 <states.0+0x150>
    800027b6:	fe9fd0ef          	jal	8000079e <panic>

00000000800027ba <fetchaddr>:
{
    800027ba:	1101                	add	sp,sp,-32
    800027bc:	ec06                	sd	ra,24(sp)
    800027be:	e822                	sd	s0,16(sp)
    800027c0:	e426                	sd	s1,8(sp)
    800027c2:	e04a                	sd	s2,0(sp)
    800027c4:	1000                	add	s0,sp,32
    800027c6:	84aa                	mv	s1,a0
    800027c8:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800027ca:	840ff0ef          	jal	8000180a <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    800027ce:	653c                	ld	a5,72(a0)
    800027d0:	02f4f663          	bgeu	s1,a5,800027fc <fetchaddr+0x42>
    800027d4:	00848713          	add	a4,s1,8
    800027d8:	02e7e463          	bltu	a5,a4,80002800 <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    800027dc:	46a1                	li	a3,8
    800027de:	8626                	mv	a2,s1
    800027e0:	85ca                	mv	a1,s2
    800027e2:	6928                	ld	a0,80(a0)
    800027e4:	e3bfe0ef          	jal	8000161e <copyin>
    800027e8:	00a03533          	snez	a0,a0
    800027ec:	40a00533          	neg	a0,a0
}
    800027f0:	60e2                	ld	ra,24(sp)
    800027f2:	6442                	ld	s0,16(sp)
    800027f4:	64a2                	ld	s1,8(sp)
    800027f6:	6902                	ld	s2,0(sp)
    800027f8:	6105                	add	sp,sp,32
    800027fa:	8082                	ret
    return -1;
    800027fc:	557d                	li	a0,-1
    800027fe:	bfcd                	j	800027f0 <fetchaddr+0x36>
    80002800:	557d                	li	a0,-1
    80002802:	b7fd                	j	800027f0 <fetchaddr+0x36>

0000000080002804 <fetchstr>:
{
    80002804:	7179                	add	sp,sp,-48
    80002806:	f406                	sd	ra,40(sp)
    80002808:	f022                	sd	s0,32(sp)
    8000280a:	ec26                	sd	s1,24(sp)
    8000280c:	e84a                	sd	s2,16(sp)
    8000280e:	e44e                	sd	s3,8(sp)
    80002810:	1800                	add	s0,sp,48
    80002812:	892a                	mv	s2,a0
    80002814:	84ae                	mv	s1,a1
    80002816:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002818:	ff3fe0ef          	jal	8000180a <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    8000281c:	86ce                	mv	a3,s3
    8000281e:	864a                	mv	a2,s2
    80002820:	85a6                	mv	a1,s1
    80002822:	6928                	ld	a0,80(a0)
    80002824:	bf7fe0ef          	jal	8000141a <copyinstr>
    80002828:	00054c63          	bltz	a0,80002840 <fetchstr+0x3c>
  return strlen(buf);
    8000282c:	8526                	mv	a0,s1
    8000282e:	d90fe0ef          	jal	80000dbe <strlen>
}
    80002832:	70a2                	ld	ra,40(sp)
    80002834:	7402                	ld	s0,32(sp)
    80002836:	64e2                	ld	s1,24(sp)
    80002838:	6942                	ld	s2,16(sp)
    8000283a:	69a2                	ld	s3,8(sp)
    8000283c:	6145                	add	sp,sp,48
    8000283e:	8082                	ret
    return -1;
    80002840:	557d                	li	a0,-1
    80002842:	bfc5                	j	80002832 <fetchstr+0x2e>

0000000080002844 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80002844:	1101                	add	sp,sp,-32
    80002846:	ec06                	sd	ra,24(sp)
    80002848:	e822                	sd	s0,16(sp)
    8000284a:	e426                	sd	s1,8(sp)
    8000284c:	1000                	add	s0,sp,32
    8000284e:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002850:	f0bff0ef          	jal	8000275a <argraw>
    80002854:	c088                	sw	a0,0(s1)
}
    80002856:	60e2                	ld	ra,24(sp)
    80002858:	6442                	ld	s0,16(sp)
    8000285a:	64a2                	ld	s1,8(sp)
    8000285c:	6105                	add	sp,sp,32
    8000285e:	8082                	ret

0000000080002860 <sys_getcnt>:
}


uint64
sys_getcnt(void)
{
    80002860:	1101                	add	sp,sp,-32
    80002862:	ec06                	sd	ra,24(sp)
    80002864:	e822                	sd	s0,16(sp)
    80002866:	1000                	add	s0,sp,32
  int n;
  argint(0, &n);
    80002868:	fec40593          	add	a1,s0,-20
    8000286c:	4501                	li	a0,0
    8000286e:	fd7ff0ef          	jal	80002844 <argint>

  if(n <= 0 || n >= NELEM(syscalls))
    80002872:	fec42783          	lw	a5,-20(s0)
    80002876:	fff7869b          	addw	a3,a5,-1
    8000287a:	475d                	li	a4,23
    return -1;
    8000287c:	557d                	li	a0,-1
  if(n <= 0 || n >= NELEM(syscalls))
    8000287e:	00d76963          	bltu	a4,a3,80002890 <sys_getcnt+0x30>

  return syscall_counts[n];
    80002882:	078a                	sll	a5,a5,0x2
    80002884:	00013717          	auipc	a4,0x13
    80002888:	13c70713          	add	a4,a4,316 # 800159c0 <syscall_counts>
    8000288c:	97ba                	add	a5,a5,a4
    8000288e:	4388                	lw	a0,0(a5)
}
    80002890:	60e2                	ld	ra,24(sp)
    80002892:	6442                	ld	s0,16(sp)
    80002894:	6105                	add	sp,sp,32
    80002896:	8082                	ret

0000000080002898 <argaddr>:
{
    80002898:	1101                	add	sp,sp,-32
    8000289a:	ec06                	sd	ra,24(sp)
    8000289c:	e822                	sd	s0,16(sp)
    8000289e:	e426                	sd	s1,8(sp)
    800028a0:	1000                	add	s0,sp,32
    800028a2:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800028a4:	eb7ff0ef          	jal	8000275a <argraw>
    800028a8:	e088                	sd	a0,0(s1)
}
    800028aa:	60e2                	ld	ra,24(sp)
    800028ac:	6442                	ld	s0,16(sp)
    800028ae:	64a2                	ld	s1,8(sp)
    800028b0:	6105                	add	sp,sp,32
    800028b2:	8082                	ret

00000000800028b4 <argstr>:
{
    800028b4:	7179                	add	sp,sp,-48
    800028b6:	f406                	sd	ra,40(sp)
    800028b8:	f022                	sd	s0,32(sp)
    800028ba:	ec26                	sd	s1,24(sp)
    800028bc:	e84a                	sd	s2,16(sp)
    800028be:	1800                	add	s0,sp,48
    800028c0:	84ae                	mv	s1,a1
    800028c2:	8932                	mv	s2,a2
  argaddr(n, &addr);
    800028c4:	fd840593          	add	a1,s0,-40
    800028c8:	fd1ff0ef          	jal	80002898 <argaddr>
  return fetchstr(addr, buf, max);
    800028cc:	864a                	mv	a2,s2
    800028ce:	85a6                	mv	a1,s1
    800028d0:	fd843503          	ld	a0,-40(s0)
    800028d4:	f31ff0ef          	jal	80002804 <fetchstr>
}
    800028d8:	70a2                	ld	ra,40(sp)
    800028da:	7402                	ld	s0,32(sp)
    800028dc:	64e2                	ld	s1,24(sp)
    800028de:	6942                	ld	s2,16(sp)
    800028e0:	6145                	add	sp,sp,48
    800028e2:	8082                	ret

00000000800028e4 <syscall>:
{
    800028e4:	1101                	add	sp,sp,-32
    800028e6:	ec06                	sd	ra,24(sp)
    800028e8:	e822                	sd	s0,16(sp)
    800028ea:	e426                	sd	s1,8(sp)
    800028ec:	1000                	add	s0,sp,32
  struct proc *p = myproc();
    800028ee:	f1dfe0ef          	jal	8000180a <myproc>
    800028f2:	84aa                	mv	s1,a0
  num = p->trapframe->a7;
    800028f4:	6d3c                	ld	a5,88(a0)
    800028f6:	77dc                	ld	a5,168(a5)
    800028f8:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    800028fc:	37fd                	addw	a5,a5,-1
    800028fe:	475d                	li	a4,23
    80002900:	02f76863          	bltu	a4,a5,80002930 <syscall+0x4c>
    80002904:	00369713          	sll	a4,a3,0x3
    80002908:	00005797          	auipc	a5,0x5
    8000290c:	ae878793          	add	a5,a5,-1304 # 800073f0 <syscalls>
    80002910:	97ba                	add	a5,a5,a4
    80002912:	6390                	ld	a2,0(a5)
    80002914:	ce11                	beqz	a2,80002930 <syscall+0x4c>
    syscall_counts[num]++;
    80002916:	068a                	sll	a3,a3,0x2
    80002918:	00013797          	auipc	a5,0x13
    8000291c:	0a878793          	add	a5,a5,168 # 800159c0 <syscall_counts>
    80002920:	97b6                	add	a5,a5,a3
    80002922:	4398                	lw	a4,0(a5)
    80002924:	2705                	addw	a4,a4,1
    80002926:	c398                	sw	a4,0(a5)
    p->trapframe->a0 = syscalls[num]();
    80002928:	6d24                	ld	s1,88(a0)
    8000292a:	9602                	jalr	a2
    8000292c:	f8a8                	sd	a0,112(s1)
    8000292e:	a829                	j	80002948 <syscall+0x64>
    printf("%d %s: unknown sys call %d\n",
    80002930:	15848613          	add	a2,s1,344
    80002934:	588c                	lw	a1,48(s1)
    80002936:	00005517          	auipc	a0,0x5
    8000293a:	a8250513          	add	a0,a0,-1406 # 800073b8 <states.0+0x158>
    8000293e:	b8ffd0ef          	jal	800004cc <printf>
    p->trapframe->a0 = -1;
    80002942:	6cbc                	ld	a5,88(s1)
    80002944:	577d                	li	a4,-1
    80002946:	fbb8                	sd	a4,112(a5)
}
    80002948:	60e2                	ld	ra,24(sp)
    8000294a:	6442                	ld	s0,16(sp)
    8000294c:	64a2                	ld	s1,8(sp)
    8000294e:	6105                	add	sp,sp,32
    80002950:	8082                	ret

0000000080002952 <sys_exit>:
#include "vm.h"
#include "pstat.h"

uint64
sys_exit(void)
{
    80002952:	1101                	add	sp,sp,-32
    80002954:	ec06                	sd	ra,24(sp)
    80002956:	e822                	sd	s0,16(sp)
    80002958:	1000                	add	s0,sp,32
  int n;
  argint(0, &n);
    8000295a:	fec40593          	add	a1,s0,-20
    8000295e:	4501                	li	a0,0
    80002960:	ee5ff0ef          	jal	80002844 <argint>
  kexit(n);
    80002964:	fec42503          	lw	a0,-20(s0)
    80002968:	e44ff0ef          	jal	80001fac <kexit>
  return 0;  // not reached
}
    8000296c:	4501                	li	a0,0
    8000296e:	60e2                	ld	ra,24(sp)
    80002970:	6442                	ld	s0,16(sp)
    80002972:	6105                	add	sp,sp,32
    80002974:	8082                	ret

0000000080002976 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002976:	1141                	add	sp,sp,-16
    80002978:	e406                	sd	ra,8(sp)
    8000297a:	e022                	sd	s0,0(sp)
    8000297c:	0800                	add	s0,sp,16
  return myproc()->pid;
    8000297e:	e8dfe0ef          	jal	8000180a <myproc>
}
    80002982:	5908                	lw	a0,48(a0)
    80002984:	60a2                	ld	ra,8(sp)
    80002986:	6402                	ld	s0,0(sp)
    80002988:	0141                	add	sp,sp,16
    8000298a:	8082                	ret

000000008000298c <sys_fork>:

uint64
sys_fork(void)
{
    8000298c:	1141                	add	sp,sp,-16
    8000298e:	e406                	sd	ra,8(sp)
    80002990:	e022                	sd	s0,0(sp)
    80002992:	0800                	add	s0,sp,16
  return kfork();
    80002994:	9e4ff0ef          	jal	80001b78 <kfork>
}
    80002998:	60a2                	ld	ra,8(sp)
    8000299a:	6402                	ld	s0,0(sp)
    8000299c:	0141                	add	sp,sp,16
    8000299e:	8082                	ret

00000000800029a0 <sys_wait>:

uint64
sys_wait(void)
{
    800029a0:	1101                	add	sp,sp,-32
    800029a2:	ec06                	sd	ra,24(sp)
    800029a4:	e822                	sd	s0,16(sp)
    800029a6:	1000                	add	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    800029a8:	fe840593          	add	a1,s0,-24
    800029ac:	4501                	li	a0,0
    800029ae:	eebff0ef          	jal	80002898 <argaddr>
  return kwait(p);
    800029b2:	fe843503          	ld	a0,-24(s0)
    800029b6:	f4cff0ef          	jal	80002102 <kwait>
}
    800029ba:	60e2                	ld	ra,24(sp)
    800029bc:	6442                	ld	s0,16(sp)
    800029be:	6105                	add	sp,sp,32
    800029c0:	8082                	ret

00000000800029c2 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800029c2:	7179                	add	sp,sp,-48
    800029c4:	f406                	sd	ra,40(sp)
    800029c6:	f022                	sd	s0,32(sp)
    800029c8:	ec26                	sd	s1,24(sp)
    800029ca:	1800                	add	s0,sp,48
  uint64 addr;
  int t;
  int n;

  argint(0, &n);
    800029cc:	fd840593          	add	a1,s0,-40
    800029d0:	4501                	li	a0,0
    800029d2:	e73ff0ef          	jal	80002844 <argint>
  argint(1, &t);
    800029d6:	fdc40593          	add	a1,s0,-36
    800029da:	4505                	li	a0,1
    800029dc:	e69ff0ef          	jal	80002844 <argint>
  addr = myproc()->sz;
    800029e0:	e2bfe0ef          	jal	8000180a <myproc>
    800029e4:	6524                	ld	s1,72(a0)

  if(t == SBRK_EAGER || n < 0) {
    800029e6:	fdc42703          	lw	a4,-36(s0)
    800029ea:	4785                	li	a5,1
    800029ec:	02f70763          	beq	a4,a5,80002a1a <sys_sbrk+0x58>
    800029f0:	fd842783          	lw	a5,-40(s0)
    800029f4:	0207c363          	bltz	a5,80002a1a <sys_sbrk+0x58>
    }
  } else {
    // Lazily allocate memory for this process: increase its memory
    // size but don't allocate memory. If the processes uses the
    // memory, vmfault() will allocate it.
    if(addr + n < addr)
    800029f8:	97a6                	add	a5,a5,s1
    800029fa:	0297ee63          	bltu	a5,s1,80002a36 <sys_sbrk+0x74>
      return -1;
    if(addr + n > TRAPFRAME)
    800029fe:	02000737          	lui	a4,0x2000
    80002a02:	177d                	add	a4,a4,-1 # 1ffffff <_entry-0x7e000001>
    80002a04:	0736                	sll	a4,a4,0xd
    80002a06:	02f76a63          	bltu	a4,a5,80002a3a <sys_sbrk+0x78>
      return -1;
    myproc()->sz += n;
    80002a0a:	e01fe0ef          	jal	8000180a <myproc>
    80002a0e:	fd842703          	lw	a4,-40(s0)
    80002a12:	653c                	ld	a5,72(a0)
    80002a14:	97ba                	add	a5,a5,a4
    80002a16:	e53c                	sd	a5,72(a0)
    80002a18:	a039                	j	80002a26 <sys_sbrk+0x64>
    if(growproc(n) < 0) {
    80002a1a:	fd842503          	lw	a0,-40(s0)
    80002a1e:	8f8ff0ef          	jal	80001b16 <growproc>
    80002a22:	00054863          	bltz	a0,80002a32 <sys_sbrk+0x70>
  }
  return addr;
}
    80002a26:	8526                	mv	a0,s1
    80002a28:	70a2                	ld	ra,40(sp)
    80002a2a:	7402                	ld	s0,32(sp)
    80002a2c:	64e2                	ld	s1,24(sp)
    80002a2e:	6145                	add	sp,sp,48
    80002a30:	8082                	ret
      return -1;
    80002a32:	54fd                	li	s1,-1
    80002a34:	bfcd                	j	80002a26 <sys_sbrk+0x64>
      return -1;
    80002a36:	54fd                	li	s1,-1
    80002a38:	b7fd                	j	80002a26 <sys_sbrk+0x64>
      return -1;
    80002a3a:	54fd                	li	s1,-1
    80002a3c:	b7ed                	j	80002a26 <sys_sbrk+0x64>

0000000080002a3e <sys_pause>:

uint64
sys_pause(void)
{
    80002a3e:	7139                	add	sp,sp,-64
    80002a40:	fc06                	sd	ra,56(sp)
    80002a42:	f822                	sd	s0,48(sp)
    80002a44:	f426                	sd	s1,40(sp)
    80002a46:	f04a                	sd	s2,32(sp)
    80002a48:	ec4e                	sd	s3,24(sp)
    80002a4a:	0080                	add	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80002a4c:	fcc40593          	add	a1,s0,-52
    80002a50:	4501                	li	a0,0
    80002a52:	df3ff0ef          	jal	80002844 <argint>
  if(n < 0)
    80002a56:	fcc42783          	lw	a5,-52(s0)
    80002a5a:	0607c563          	bltz	a5,80002ac4 <sys_pause+0x86>
    n = 0;
  acquire(&tickslock);
    80002a5e:	00013517          	auipc	a0,0x13
    80002a62:	f4a50513          	add	a0,a0,-182 # 800159a8 <tickslock>
    80002a66:	90efe0ef          	jal	80000b74 <acquire>
  ticks0 = ticks;
    80002a6a:	00005917          	auipc	s2,0x5
    80002a6e:	e0e92903          	lw	s2,-498(s2) # 80007878 <ticks>
  while(ticks - ticks0 < n){
    80002a72:	fcc42783          	lw	a5,-52(s0)
    80002a76:	cb8d                	beqz	a5,80002aa8 <sys_pause+0x6a>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002a78:	00013997          	auipc	s3,0x13
    80002a7c:	f3098993          	add	s3,s3,-208 # 800159a8 <tickslock>
    80002a80:	00005497          	auipc	s1,0x5
    80002a84:	df848493          	add	s1,s1,-520 # 80007878 <ticks>
    if(killed(myproc())){
    80002a88:	d83fe0ef          	jal	8000180a <myproc>
    80002a8c:	e4cff0ef          	jal	800020d8 <killed>
    80002a90:	ed0d                	bnez	a0,80002aca <sys_pause+0x8c>
    sleep(&ticks, &tickslock);
    80002a92:	85ce                	mv	a1,s3
    80002a94:	8526                	mv	a0,s1
    80002a96:	c0aff0ef          	jal	80001ea0 <sleep>
  while(ticks - ticks0 < n){
    80002a9a:	409c                	lw	a5,0(s1)
    80002a9c:	412787bb          	subw	a5,a5,s2
    80002aa0:	fcc42703          	lw	a4,-52(s0)
    80002aa4:	fee7e2e3          	bltu	a5,a4,80002a88 <sys_pause+0x4a>
  }
  release(&tickslock);
    80002aa8:	00013517          	auipc	a0,0x13
    80002aac:	f0050513          	add	a0,a0,-256 # 800159a8 <tickslock>
    80002ab0:	95cfe0ef          	jal	80000c0c <release>
  return 0;
    80002ab4:	4501                	li	a0,0
}
    80002ab6:	70e2                	ld	ra,56(sp)
    80002ab8:	7442                	ld	s0,48(sp)
    80002aba:	74a2                	ld	s1,40(sp)
    80002abc:	7902                	ld	s2,32(sp)
    80002abe:	69e2                	ld	s3,24(sp)
    80002ac0:	6121                	add	sp,sp,64
    80002ac2:	8082                	ret
    n = 0;
    80002ac4:	fc042623          	sw	zero,-52(s0)
    80002ac8:	bf59                	j	80002a5e <sys_pause+0x20>
      release(&tickslock);
    80002aca:	00013517          	auipc	a0,0x13
    80002ace:	ede50513          	add	a0,a0,-290 # 800159a8 <tickslock>
    80002ad2:	93afe0ef          	jal	80000c0c <release>
      return -1;
    80002ad6:	557d                	li	a0,-1
    80002ad8:	bff9                	j	80002ab6 <sys_pause+0x78>

0000000080002ada <sys_kill>:

uint64
sys_kill(void)
{
    80002ada:	1101                	add	sp,sp,-32
    80002adc:	ec06                	sd	ra,24(sp)
    80002ade:	e822                	sd	s0,16(sp)
    80002ae0:	1000                	add	s0,sp,32
  int pid;

  argint(0, &pid);
    80002ae2:	fec40593          	add	a1,s0,-20
    80002ae6:	4501                	li	a0,0
    80002ae8:	d5dff0ef          	jal	80002844 <argint>
  return kkill(pid);
    80002aec:	fec42503          	lw	a0,-20(s0)
    80002af0:	d5eff0ef          	jal	8000204e <kkill>
}
    80002af4:	60e2                	ld	ra,24(sp)
    80002af6:	6442                	ld	s0,16(sp)
    80002af8:	6105                	add	sp,sp,32
    80002afa:	8082                	ret

0000000080002afc <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002afc:	1101                	add	sp,sp,-32
    80002afe:	ec06                	sd	ra,24(sp)
    80002b00:	e822                	sd	s0,16(sp)
    80002b02:	e426                	sd	s1,8(sp)
    80002b04:	1000                	add	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002b06:	00013517          	auipc	a0,0x13
    80002b0a:	ea250513          	add	a0,a0,-350 # 800159a8 <tickslock>
    80002b0e:	866fe0ef          	jal	80000b74 <acquire>
  xticks = ticks;
    80002b12:	00005497          	auipc	s1,0x5
    80002b16:	d664a483          	lw	s1,-666(s1) # 80007878 <ticks>
  release(&tickslock);
    80002b1a:	00013517          	auipc	a0,0x13
    80002b1e:	e8e50513          	add	a0,a0,-370 # 800159a8 <tickslock>
    80002b22:	8eafe0ef          	jal	80000c0c <release>
  return xticks;
}
    80002b26:	02049513          	sll	a0,s1,0x20
    80002b2a:	9101                	srl	a0,a0,0x20
    80002b2c:	60e2                	ld	ra,24(sp)
    80002b2e:	6442                	ld	s0,16(sp)
    80002b30:	64a2                	ld	s1,8(sp)
    80002b32:	6105                	add	sp,sp,32
    80002b34:	8082                	ret

0000000080002b36 <sys_settickets>:

uint64
sys_settickets(void)
{
    80002b36:	1101                	add	sp,sp,-32
    80002b38:	ec06                	sd	ra,24(sp)
    80002b3a:	e822                	sd	s0,16(sp)
    80002b3c:	1000                	add	s0,sp,32
  int n;
  argint(0, &n);
    80002b3e:	fec40593          	add	a1,s0,-20
    80002b42:	4501                	li	a0,0
    80002b44:	d01ff0ef          	jal	80002844 <argint>
  return ksettickets(n);
    80002b48:	fec42503          	lw	a0,-20(s0)
    80002b4c:	fb0ff0ef          	jal	800022fc <ksettickets>
}
    80002b50:	60e2                	ld	ra,24(sp)
    80002b52:	6442                	ld	s0,16(sp)
    80002b54:	6105                	add	sp,sp,32
    80002b56:	8082                	ret

0000000080002b58 <sys_getpinfo>:

uint64
sys_getpinfo(void)
{
    80002b58:	be010113          	add	sp,sp,-1056
    80002b5c:	40113c23          	sd	ra,1048(sp)
    80002b60:	40813823          	sd	s0,1040(sp)
    80002b64:	42010413          	add	s0,sp,1056
  uint64 addr;
  struct pstat st;

  argaddr(0, &addr);
    80002b68:	fe840593          	add	a1,s0,-24
    80002b6c:	4501                	li	a0,0
    80002b6e:	d2bff0ef          	jal	80002898 <argaddr>
  if(addr == 0)
    80002b72:	fe843783          	ld	a5,-24(s0)
    return -1;
    80002b76:	557d                	li	a0,-1
  if(addr == 0)
    80002b78:	c78d                	beqz	a5,80002ba2 <sys_getpinfo+0x4a>

  if(kgetpinfo(&st) < 0)
    80002b7a:	be840513          	add	a0,s0,-1048
    80002b7e:	f12ff0ef          	jal	80002290 <kgetpinfo>
    80002b82:	87aa                	mv	a5,a0
    return -1;
    80002b84:	557d                	li	a0,-1
  if(kgetpinfo(&st) < 0)
    80002b86:	0007ce63          	bltz	a5,80002ba2 <sys_getpinfo+0x4a>

  if(copyout(myproc()->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80002b8a:	c81fe0ef          	jal	8000180a <myproc>
    80002b8e:	40000693          	li	a3,1024
    80002b92:	be840613          	add	a2,s0,-1048
    80002b96:	fe843583          	ld	a1,-24(s0)
    80002b9a:	6928                	ld	a0,80(a0)
    80002b9c:	9bdfe0ef          	jal	80001558 <copyout>
    80002ba0:	957d                	sra	a0,a0,0x3f
    return -1;

  return 0;
}
    80002ba2:	41813083          	ld	ra,1048(sp)
    80002ba6:	41013403          	ld	s0,1040(sp)
    80002baa:	42010113          	add	sp,sp,1056
    80002bae:	8082                	ret

0000000080002bb0 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002bb0:	7179                	add	sp,sp,-48
    80002bb2:	f406                	sd	ra,40(sp)
    80002bb4:	f022                	sd	s0,32(sp)
    80002bb6:	ec26                	sd	s1,24(sp)
    80002bb8:	e84a                	sd	s2,16(sp)
    80002bba:	e44e                	sd	s3,8(sp)
    80002bbc:	e052                	sd	s4,0(sp)
    80002bbe:	1800                	add	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002bc0:	00005597          	auipc	a1,0x5
    80002bc4:	8f858593          	add	a1,a1,-1800 # 800074b8 <syscalls+0xc8>
    80002bc8:	00013517          	auipc	a0,0x13
    80002bcc:	e6050513          	add	a0,a0,-416 # 80015a28 <bcache>
    80002bd0:	f25fd0ef          	jal	80000af4 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002bd4:	0001b797          	auipc	a5,0x1b
    80002bd8:	e5478793          	add	a5,a5,-428 # 8001da28 <bcache+0x8000>
    80002bdc:	0001b717          	auipc	a4,0x1b
    80002be0:	0b470713          	add	a4,a4,180 # 8001dc90 <bcache+0x8268>
    80002be4:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002be8:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002bec:	00013497          	auipc	s1,0x13
    80002bf0:	e5448493          	add	s1,s1,-428 # 80015a40 <bcache+0x18>
    b->next = bcache.head.next;
    80002bf4:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002bf6:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002bf8:	00005a17          	auipc	s4,0x5
    80002bfc:	8c8a0a13          	add	s4,s4,-1848 # 800074c0 <syscalls+0xd0>
    b->next = bcache.head.next;
    80002c00:	2b893783          	ld	a5,696(s2)
    80002c04:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002c06:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002c0a:	85d2                	mv	a1,s4
    80002c0c:	01048513          	add	a0,s1,16
    80002c10:	2d0010ef          	jal	80003ee0 <initsleeplock>
    bcache.head.next->prev = b;
    80002c14:	2b893783          	ld	a5,696(s2)
    80002c18:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002c1a:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002c1e:	45848493          	add	s1,s1,1112
    80002c22:	fd349fe3          	bne	s1,s3,80002c00 <binit+0x50>
  }
}
    80002c26:	70a2                	ld	ra,40(sp)
    80002c28:	7402                	ld	s0,32(sp)
    80002c2a:	64e2                	ld	s1,24(sp)
    80002c2c:	6942                	ld	s2,16(sp)
    80002c2e:	69a2                	ld	s3,8(sp)
    80002c30:	6a02                	ld	s4,0(sp)
    80002c32:	6145                	add	sp,sp,48
    80002c34:	8082                	ret

0000000080002c36 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002c36:	7179                	add	sp,sp,-48
    80002c38:	f406                	sd	ra,40(sp)
    80002c3a:	f022                	sd	s0,32(sp)
    80002c3c:	ec26                	sd	s1,24(sp)
    80002c3e:	e84a                	sd	s2,16(sp)
    80002c40:	e44e                	sd	s3,8(sp)
    80002c42:	1800                	add	s0,sp,48
    80002c44:	892a                	mv	s2,a0
    80002c46:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002c48:	00013517          	auipc	a0,0x13
    80002c4c:	de050513          	add	a0,a0,-544 # 80015a28 <bcache>
    80002c50:	f25fd0ef          	jal	80000b74 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002c54:	0001b497          	auipc	s1,0x1b
    80002c58:	08c4b483          	ld	s1,140(s1) # 8001dce0 <bcache+0x82b8>
    80002c5c:	0001b797          	auipc	a5,0x1b
    80002c60:	03478793          	add	a5,a5,52 # 8001dc90 <bcache+0x8268>
    80002c64:	02f48b63          	beq	s1,a5,80002c9a <bread+0x64>
    80002c68:	873e                	mv	a4,a5
    80002c6a:	a021                	j	80002c72 <bread+0x3c>
    80002c6c:	68a4                	ld	s1,80(s1)
    80002c6e:	02e48663          	beq	s1,a4,80002c9a <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    80002c72:	449c                	lw	a5,8(s1)
    80002c74:	ff279ce3          	bne	a5,s2,80002c6c <bread+0x36>
    80002c78:	44dc                	lw	a5,12(s1)
    80002c7a:	ff3799e3          	bne	a5,s3,80002c6c <bread+0x36>
      b->refcnt++;
    80002c7e:	40bc                	lw	a5,64(s1)
    80002c80:	2785                	addw	a5,a5,1
    80002c82:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002c84:	00013517          	auipc	a0,0x13
    80002c88:	da450513          	add	a0,a0,-604 # 80015a28 <bcache>
    80002c8c:	f81fd0ef          	jal	80000c0c <release>
      acquiresleep(&b->lock);
    80002c90:	01048513          	add	a0,s1,16
    80002c94:	282010ef          	jal	80003f16 <acquiresleep>
      return b;
    80002c98:	a889                	j	80002cea <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002c9a:	0001b497          	auipc	s1,0x1b
    80002c9e:	03e4b483          	ld	s1,62(s1) # 8001dcd8 <bcache+0x82b0>
    80002ca2:	0001b797          	auipc	a5,0x1b
    80002ca6:	fee78793          	add	a5,a5,-18 # 8001dc90 <bcache+0x8268>
    80002caa:	00f48863          	beq	s1,a5,80002cba <bread+0x84>
    80002cae:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002cb0:	40bc                	lw	a5,64(s1)
    80002cb2:	cb91                	beqz	a5,80002cc6 <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002cb4:	64a4                	ld	s1,72(s1)
    80002cb6:	fee49de3          	bne	s1,a4,80002cb0 <bread+0x7a>
  panic("bget: no buffers");
    80002cba:	00005517          	auipc	a0,0x5
    80002cbe:	80e50513          	add	a0,a0,-2034 # 800074c8 <syscalls+0xd8>
    80002cc2:	addfd0ef          	jal	8000079e <panic>
      b->dev = dev;
    80002cc6:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002cca:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002cce:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002cd2:	4785                	li	a5,1
    80002cd4:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002cd6:	00013517          	auipc	a0,0x13
    80002cda:	d5250513          	add	a0,a0,-686 # 80015a28 <bcache>
    80002cde:	f2ffd0ef          	jal	80000c0c <release>
      acquiresleep(&b->lock);
    80002ce2:	01048513          	add	a0,s1,16
    80002ce6:	230010ef          	jal	80003f16 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002cea:	409c                	lw	a5,0(s1)
    80002cec:	cb89                	beqz	a5,80002cfe <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002cee:	8526                	mv	a0,s1
    80002cf0:	70a2                	ld	ra,40(sp)
    80002cf2:	7402                	ld	s0,32(sp)
    80002cf4:	64e2                	ld	s1,24(sp)
    80002cf6:	6942                	ld	s2,16(sp)
    80002cf8:	69a2                	ld	s3,8(sp)
    80002cfa:	6145                	add	sp,sp,48
    80002cfc:	8082                	ret
    virtio_disk_rw(b, 0);
    80002cfe:	4581                	li	a1,0
    80002d00:	8526                	mv	a0,s1
    80002d02:	159020ef          	jal	8000565a <virtio_disk_rw>
    b->valid = 1;
    80002d06:	4785                	li	a5,1
    80002d08:	c09c                	sw	a5,0(s1)
  return b;
    80002d0a:	b7d5                	j	80002cee <bread+0xb8>

0000000080002d0c <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002d0c:	1101                	add	sp,sp,-32
    80002d0e:	ec06                	sd	ra,24(sp)
    80002d10:	e822                	sd	s0,16(sp)
    80002d12:	e426                	sd	s1,8(sp)
    80002d14:	1000                	add	s0,sp,32
    80002d16:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002d18:	0541                	add	a0,a0,16
    80002d1a:	27a010ef          	jal	80003f94 <holdingsleep>
    80002d1e:	c911                	beqz	a0,80002d32 <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002d20:	4585                	li	a1,1
    80002d22:	8526                	mv	a0,s1
    80002d24:	137020ef          	jal	8000565a <virtio_disk_rw>
}
    80002d28:	60e2                	ld	ra,24(sp)
    80002d2a:	6442                	ld	s0,16(sp)
    80002d2c:	64a2                	ld	s1,8(sp)
    80002d2e:	6105                	add	sp,sp,32
    80002d30:	8082                	ret
    panic("bwrite");
    80002d32:	00004517          	auipc	a0,0x4
    80002d36:	7ae50513          	add	a0,a0,1966 # 800074e0 <syscalls+0xf0>
    80002d3a:	a65fd0ef          	jal	8000079e <panic>

0000000080002d3e <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002d3e:	1101                	add	sp,sp,-32
    80002d40:	ec06                	sd	ra,24(sp)
    80002d42:	e822                	sd	s0,16(sp)
    80002d44:	e426                	sd	s1,8(sp)
    80002d46:	e04a                	sd	s2,0(sp)
    80002d48:	1000                	add	s0,sp,32
    80002d4a:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002d4c:	01050913          	add	s2,a0,16
    80002d50:	854a                	mv	a0,s2
    80002d52:	242010ef          	jal	80003f94 <holdingsleep>
    80002d56:	c135                	beqz	a0,80002dba <brelse+0x7c>
    panic("brelse");

  releasesleep(&b->lock);
    80002d58:	854a                	mv	a0,s2
    80002d5a:	202010ef          	jal	80003f5c <releasesleep>

  acquire(&bcache.lock);
    80002d5e:	00013517          	auipc	a0,0x13
    80002d62:	cca50513          	add	a0,a0,-822 # 80015a28 <bcache>
    80002d66:	e0ffd0ef          	jal	80000b74 <acquire>
  b->refcnt--;
    80002d6a:	40bc                	lw	a5,64(s1)
    80002d6c:	37fd                	addw	a5,a5,-1
    80002d6e:	0007871b          	sext.w	a4,a5
    80002d72:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002d74:	e71d                	bnez	a4,80002da2 <brelse+0x64>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002d76:	68b8                	ld	a4,80(s1)
    80002d78:	64bc                	ld	a5,72(s1)
    80002d7a:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002d7c:	68b8                	ld	a4,80(s1)
    80002d7e:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002d80:	0001b797          	auipc	a5,0x1b
    80002d84:	ca878793          	add	a5,a5,-856 # 8001da28 <bcache+0x8000>
    80002d88:	2b87b703          	ld	a4,696(a5)
    80002d8c:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002d8e:	0001b717          	auipc	a4,0x1b
    80002d92:	f0270713          	add	a4,a4,-254 # 8001dc90 <bcache+0x8268>
    80002d96:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002d98:	2b87b703          	ld	a4,696(a5)
    80002d9c:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002d9e:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002da2:	00013517          	auipc	a0,0x13
    80002da6:	c8650513          	add	a0,a0,-890 # 80015a28 <bcache>
    80002daa:	e63fd0ef          	jal	80000c0c <release>
}
    80002dae:	60e2                	ld	ra,24(sp)
    80002db0:	6442                	ld	s0,16(sp)
    80002db2:	64a2                	ld	s1,8(sp)
    80002db4:	6902                	ld	s2,0(sp)
    80002db6:	6105                	add	sp,sp,32
    80002db8:	8082                	ret
    panic("brelse");
    80002dba:	00004517          	auipc	a0,0x4
    80002dbe:	72e50513          	add	a0,a0,1838 # 800074e8 <syscalls+0xf8>
    80002dc2:	9ddfd0ef          	jal	8000079e <panic>

0000000080002dc6 <bpin>:

void
bpin(struct buf *b) {
    80002dc6:	1101                	add	sp,sp,-32
    80002dc8:	ec06                	sd	ra,24(sp)
    80002dca:	e822                	sd	s0,16(sp)
    80002dcc:	e426                	sd	s1,8(sp)
    80002dce:	1000                	add	s0,sp,32
    80002dd0:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002dd2:	00013517          	auipc	a0,0x13
    80002dd6:	c5650513          	add	a0,a0,-938 # 80015a28 <bcache>
    80002dda:	d9bfd0ef          	jal	80000b74 <acquire>
  b->refcnt++;
    80002dde:	40bc                	lw	a5,64(s1)
    80002de0:	2785                	addw	a5,a5,1
    80002de2:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002de4:	00013517          	auipc	a0,0x13
    80002de8:	c4450513          	add	a0,a0,-956 # 80015a28 <bcache>
    80002dec:	e21fd0ef          	jal	80000c0c <release>
}
    80002df0:	60e2                	ld	ra,24(sp)
    80002df2:	6442                	ld	s0,16(sp)
    80002df4:	64a2                	ld	s1,8(sp)
    80002df6:	6105                	add	sp,sp,32
    80002df8:	8082                	ret

0000000080002dfa <bunpin>:

void
bunpin(struct buf *b) {
    80002dfa:	1101                	add	sp,sp,-32
    80002dfc:	ec06                	sd	ra,24(sp)
    80002dfe:	e822                	sd	s0,16(sp)
    80002e00:	e426                	sd	s1,8(sp)
    80002e02:	1000                	add	s0,sp,32
    80002e04:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002e06:	00013517          	auipc	a0,0x13
    80002e0a:	c2250513          	add	a0,a0,-990 # 80015a28 <bcache>
    80002e0e:	d67fd0ef          	jal	80000b74 <acquire>
  b->refcnt--;
    80002e12:	40bc                	lw	a5,64(s1)
    80002e14:	37fd                	addw	a5,a5,-1
    80002e16:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002e18:	00013517          	auipc	a0,0x13
    80002e1c:	c1050513          	add	a0,a0,-1008 # 80015a28 <bcache>
    80002e20:	dedfd0ef          	jal	80000c0c <release>
}
    80002e24:	60e2                	ld	ra,24(sp)
    80002e26:	6442                	ld	s0,16(sp)
    80002e28:	64a2                	ld	s1,8(sp)
    80002e2a:	6105                	add	sp,sp,32
    80002e2c:	8082                	ret

0000000080002e2e <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002e2e:	1101                	add	sp,sp,-32
    80002e30:	ec06                	sd	ra,24(sp)
    80002e32:	e822                	sd	s0,16(sp)
    80002e34:	e426                	sd	s1,8(sp)
    80002e36:	e04a                	sd	s2,0(sp)
    80002e38:	1000                	add	s0,sp,32
    80002e3a:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002e3c:	00d5d59b          	srlw	a1,a1,0xd
    80002e40:	0001b797          	auipc	a5,0x1b
    80002e44:	2c47a783          	lw	a5,708(a5) # 8001e104 <sb+0x1c>
    80002e48:	9dbd                	addw	a1,a1,a5
    80002e4a:	dedff0ef          	jal	80002c36 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002e4e:	0074f713          	and	a4,s1,7
    80002e52:	4785                	li	a5,1
    80002e54:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002e58:	14ce                	sll	s1,s1,0x33
    80002e5a:	90d9                	srl	s1,s1,0x36
    80002e5c:	00950733          	add	a4,a0,s1
    80002e60:	05874703          	lbu	a4,88(a4)
    80002e64:	00e7f6b3          	and	a3,a5,a4
    80002e68:	c29d                	beqz	a3,80002e8e <bfree+0x60>
    80002e6a:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002e6c:	94aa                	add	s1,s1,a0
    80002e6e:	fff7c793          	not	a5,a5
    80002e72:	8f7d                	and	a4,a4,a5
    80002e74:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80002e78:	7a7000ef          	jal	80003e1e <log_write>
  brelse(bp);
    80002e7c:	854a                	mv	a0,s2
    80002e7e:	ec1ff0ef          	jal	80002d3e <brelse>
}
    80002e82:	60e2                	ld	ra,24(sp)
    80002e84:	6442                	ld	s0,16(sp)
    80002e86:	64a2                	ld	s1,8(sp)
    80002e88:	6902                	ld	s2,0(sp)
    80002e8a:	6105                	add	sp,sp,32
    80002e8c:	8082                	ret
    panic("freeing free block");
    80002e8e:	00004517          	auipc	a0,0x4
    80002e92:	66250513          	add	a0,a0,1634 # 800074f0 <syscalls+0x100>
    80002e96:	909fd0ef          	jal	8000079e <panic>

0000000080002e9a <balloc>:
{
    80002e9a:	711d                	add	sp,sp,-96
    80002e9c:	ec86                	sd	ra,88(sp)
    80002e9e:	e8a2                	sd	s0,80(sp)
    80002ea0:	e4a6                	sd	s1,72(sp)
    80002ea2:	e0ca                	sd	s2,64(sp)
    80002ea4:	fc4e                	sd	s3,56(sp)
    80002ea6:	f852                	sd	s4,48(sp)
    80002ea8:	f456                	sd	s5,40(sp)
    80002eaa:	f05a                	sd	s6,32(sp)
    80002eac:	ec5e                	sd	s7,24(sp)
    80002eae:	e862                	sd	s8,16(sp)
    80002eb0:	e466                	sd	s9,8(sp)
    80002eb2:	1080                	add	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002eb4:	0001b797          	auipc	a5,0x1b
    80002eb8:	2387a783          	lw	a5,568(a5) # 8001e0ec <sb+0x4>
    80002ebc:	cff1                	beqz	a5,80002f98 <balloc+0xfe>
    80002ebe:	8baa                	mv	s7,a0
    80002ec0:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002ec2:	0001bb17          	auipc	s6,0x1b
    80002ec6:	226b0b13          	add	s6,s6,550 # 8001e0e8 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002eca:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002ecc:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002ece:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002ed0:	6c89                	lui	s9,0x2
    80002ed2:	a0b5                	j	80002f3e <balloc+0xa4>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002ed4:	97ca                	add	a5,a5,s2
    80002ed6:	8e55                	or	a2,a2,a3
    80002ed8:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80002edc:	854a                	mv	a0,s2
    80002ede:	741000ef          	jal	80003e1e <log_write>
        brelse(bp);
    80002ee2:	854a                	mv	a0,s2
    80002ee4:	e5bff0ef          	jal	80002d3e <brelse>
  bp = bread(dev, bno);
    80002ee8:	85a6                	mv	a1,s1
    80002eea:	855e                	mv	a0,s7
    80002eec:	d4bff0ef          	jal	80002c36 <bread>
    80002ef0:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002ef2:	40000613          	li	a2,1024
    80002ef6:	4581                	li	a1,0
    80002ef8:	05850513          	add	a0,a0,88
    80002efc:	d4dfd0ef          	jal	80000c48 <memset>
  log_write(bp);
    80002f00:	854a                	mv	a0,s2
    80002f02:	71d000ef          	jal	80003e1e <log_write>
  brelse(bp);
    80002f06:	854a                	mv	a0,s2
    80002f08:	e37ff0ef          	jal	80002d3e <brelse>
}
    80002f0c:	8526                	mv	a0,s1
    80002f0e:	60e6                	ld	ra,88(sp)
    80002f10:	6446                	ld	s0,80(sp)
    80002f12:	64a6                	ld	s1,72(sp)
    80002f14:	6906                	ld	s2,64(sp)
    80002f16:	79e2                	ld	s3,56(sp)
    80002f18:	7a42                	ld	s4,48(sp)
    80002f1a:	7aa2                	ld	s5,40(sp)
    80002f1c:	7b02                	ld	s6,32(sp)
    80002f1e:	6be2                	ld	s7,24(sp)
    80002f20:	6c42                	ld	s8,16(sp)
    80002f22:	6ca2                	ld	s9,8(sp)
    80002f24:	6125                	add	sp,sp,96
    80002f26:	8082                	ret
    brelse(bp);
    80002f28:	854a                	mv	a0,s2
    80002f2a:	e15ff0ef          	jal	80002d3e <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002f2e:	015c87bb          	addw	a5,s9,s5
    80002f32:	00078a9b          	sext.w	s5,a5
    80002f36:	004b2703          	lw	a4,4(s6)
    80002f3a:	04eaff63          	bgeu	s5,a4,80002f98 <balloc+0xfe>
    bp = bread(dev, BBLOCK(b, sb));
    80002f3e:	41fad79b          	sraw	a5,s5,0x1f
    80002f42:	0137d79b          	srlw	a5,a5,0x13
    80002f46:	015787bb          	addw	a5,a5,s5
    80002f4a:	40d7d79b          	sraw	a5,a5,0xd
    80002f4e:	01cb2583          	lw	a1,28(s6)
    80002f52:	9dbd                	addw	a1,a1,a5
    80002f54:	855e                	mv	a0,s7
    80002f56:	ce1ff0ef          	jal	80002c36 <bread>
    80002f5a:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002f5c:	004b2503          	lw	a0,4(s6)
    80002f60:	000a849b          	sext.w	s1,s5
    80002f64:	8762                	mv	a4,s8
    80002f66:	fca4f1e3          	bgeu	s1,a0,80002f28 <balloc+0x8e>
      m = 1 << (bi % 8);
    80002f6a:	00777693          	and	a3,a4,7
    80002f6e:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002f72:	41f7579b          	sraw	a5,a4,0x1f
    80002f76:	01d7d79b          	srlw	a5,a5,0x1d
    80002f7a:	9fb9                	addw	a5,a5,a4
    80002f7c:	4037d79b          	sraw	a5,a5,0x3
    80002f80:	00f90633          	add	a2,s2,a5
    80002f84:	05864603          	lbu	a2,88(a2)
    80002f88:	00c6f5b3          	and	a1,a3,a2
    80002f8c:	d5a1                	beqz	a1,80002ed4 <balloc+0x3a>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002f8e:	2705                	addw	a4,a4,1
    80002f90:	2485                	addw	s1,s1,1
    80002f92:	fd471ae3          	bne	a4,s4,80002f66 <balloc+0xcc>
    80002f96:	bf49                	j	80002f28 <balloc+0x8e>
  printf("balloc: out of blocks\n");
    80002f98:	00004517          	auipc	a0,0x4
    80002f9c:	57050513          	add	a0,a0,1392 # 80007508 <syscalls+0x118>
    80002fa0:	d2cfd0ef          	jal	800004cc <printf>
  return 0;
    80002fa4:	4481                	li	s1,0
    80002fa6:	b79d                	j	80002f0c <balloc+0x72>

0000000080002fa8 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80002fa8:	7179                	add	sp,sp,-48
    80002faa:	f406                	sd	ra,40(sp)
    80002fac:	f022                	sd	s0,32(sp)
    80002fae:	ec26                	sd	s1,24(sp)
    80002fb0:	e84a                	sd	s2,16(sp)
    80002fb2:	e44e                	sd	s3,8(sp)
    80002fb4:	e052                	sd	s4,0(sp)
    80002fb6:	1800                	add	s0,sp,48
    80002fb8:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002fba:	47ad                	li	a5,11
    80002fbc:	02b7e663          	bltu	a5,a1,80002fe8 <bmap+0x40>
    if((addr = ip->addrs[bn]) == 0){
    80002fc0:	02059793          	sll	a5,a1,0x20
    80002fc4:	01e7d593          	srl	a1,a5,0x1e
    80002fc8:	00b504b3          	add	s1,a0,a1
    80002fcc:	0504a903          	lw	s2,80(s1)
    80002fd0:	06091663          	bnez	s2,8000303c <bmap+0x94>
      addr = balloc(ip->dev);
    80002fd4:	4108                	lw	a0,0(a0)
    80002fd6:	ec5ff0ef          	jal	80002e9a <balloc>
    80002fda:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002fde:	04090f63          	beqz	s2,8000303c <bmap+0x94>
        return 0;
      ip->addrs[bn] = addr;
    80002fe2:	0524a823          	sw	s2,80(s1)
    80002fe6:	a899                	j	8000303c <bmap+0x94>
    }
    return addr;
  }
  bn -= NDIRECT;
    80002fe8:	ff45849b          	addw	s1,a1,-12
    80002fec:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002ff0:	0ff00793          	li	a5,255
    80002ff4:	06e7eb63          	bltu	a5,a4,8000306a <bmap+0xc2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80002ff8:	08052903          	lw	s2,128(a0)
    80002ffc:	00091b63          	bnez	s2,80003012 <bmap+0x6a>
      addr = balloc(ip->dev);
    80003000:	4108                	lw	a0,0(a0)
    80003002:	e99ff0ef          	jal	80002e9a <balloc>
    80003006:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    8000300a:	02090963          	beqz	s2,8000303c <bmap+0x94>
        return 0;
      ip->addrs[NDIRECT] = addr;
    8000300e:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    80003012:	85ca                	mv	a1,s2
    80003014:	0009a503          	lw	a0,0(s3)
    80003018:	c1fff0ef          	jal	80002c36 <bread>
    8000301c:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    8000301e:	05850793          	add	a5,a0,88
    if((addr = a[bn]) == 0){
    80003022:	02049713          	sll	a4,s1,0x20
    80003026:	01e75593          	srl	a1,a4,0x1e
    8000302a:	00b784b3          	add	s1,a5,a1
    8000302e:	0004a903          	lw	s2,0(s1)
    80003032:	00090e63          	beqz	s2,8000304e <bmap+0xa6>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80003036:	8552                	mv	a0,s4
    80003038:	d07ff0ef          	jal	80002d3e <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    8000303c:	854a                	mv	a0,s2
    8000303e:	70a2                	ld	ra,40(sp)
    80003040:	7402                	ld	s0,32(sp)
    80003042:	64e2                	ld	s1,24(sp)
    80003044:	6942                	ld	s2,16(sp)
    80003046:	69a2                	ld	s3,8(sp)
    80003048:	6a02                	ld	s4,0(sp)
    8000304a:	6145                	add	sp,sp,48
    8000304c:	8082                	ret
      addr = balloc(ip->dev);
    8000304e:	0009a503          	lw	a0,0(s3)
    80003052:	e49ff0ef          	jal	80002e9a <balloc>
    80003056:	0005091b          	sext.w	s2,a0
      if(addr){
    8000305a:	fc090ee3          	beqz	s2,80003036 <bmap+0x8e>
        a[bn] = addr;
    8000305e:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80003062:	8552                	mv	a0,s4
    80003064:	5bb000ef          	jal	80003e1e <log_write>
    80003068:	b7f9                	j	80003036 <bmap+0x8e>
  panic("bmap: out of range");
    8000306a:	00004517          	auipc	a0,0x4
    8000306e:	4b650513          	add	a0,a0,1206 # 80007520 <syscalls+0x130>
    80003072:	f2cfd0ef          	jal	8000079e <panic>

0000000080003076 <iget>:
{
    80003076:	7179                	add	sp,sp,-48
    80003078:	f406                	sd	ra,40(sp)
    8000307a:	f022                	sd	s0,32(sp)
    8000307c:	ec26                	sd	s1,24(sp)
    8000307e:	e84a                	sd	s2,16(sp)
    80003080:	e44e                	sd	s3,8(sp)
    80003082:	e052                	sd	s4,0(sp)
    80003084:	1800                	add	s0,sp,48
    80003086:	89aa                	mv	s3,a0
    80003088:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    8000308a:	0001b517          	auipc	a0,0x1b
    8000308e:	07e50513          	add	a0,a0,126 # 8001e108 <itable>
    80003092:	ae3fd0ef          	jal	80000b74 <acquire>
  empty = 0;
    80003096:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003098:	0001b497          	auipc	s1,0x1b
    8000309c:	08848493          	add	s1,s1,136 # 8001e120 <itable+0x18>
    800030a0:	0001d697          	auipc	a3,0x1d
    800030a4:	b1068693          	add	a3,a3,-1264 # 8001fbb0 <log>
    800030a8:	a039                	j	800030b6 <iget+0x40>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800030aa:	02090963          	beqz	s2,800030dc <iget+0x66>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800030ae:	08848493          	add	s1,s1,136
    800030b2:	02d48863          	beq	s1,a3,800030e2 <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800030b6:	449c                	lw	a5,8(s1)
    800030b8:	fef059e3          	blez	a5,800030aa <iget+0x34>
    800030bc:	4098                	lw	a4,0(s1)
    800030be:	ff3716e3          	bne	a4,s3,800030aa <iget+0x34>
    800030c2:	40d8                	lw	a4,4(s1)
    800030c4:	ff4713e3          	bne	a4,s4,800030aa <iget+0x34>
      ip->ref++;
    800030c8:	2785                	addw	a5,a5,1
    800030ca:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800030cc:	0001b517          	auipc	a0,0x1b
    800030d0:	03c50513          	add	a0,a0,60 # 8001e108 <itable>
    800030d4:	b39fd0ef          	jal	80000c0c <release>
      return ip;
    800030d8:	8926                	mv	s2,s1
    800030da:	a02d                	j	80003104 <iget+0x8e>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800030dc:	fbe9                	bnez	a5,800030ae <iget+0x38>
    800030de:	8926                	mv	s2,s1
    800030e0:	b7f9                	j	800030ae <iget+0x38>
  if(empty == 0)
    800030e2:	02090a63          	beqz	s2,80003116 <iget+0xa0>
  ip->dev = dev;
    800030e6:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800030ea:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800030ee:	4785                	li	a5,1
    800030f0:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800030f4:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800030f8:	0001b517          	auipc	a0,0x1b
    800030fc:	01050513          	add	a0,a0,16 # 8001e108 <itable>
    80003100:	b0dfd0ef          	jal	80000c0c <release>
}
    80003104:	854a                	mv	a0,s2
    80003106:	70a2                	ld	ra,40(sp)
    80003108:	7402                	ld	s0,32(sp)
    8000310a:	64e2                	ld	s1,24(sp)
    8000310c:	6942                	ld	s2,16(sp)
    8000310e:	69a2                	ld	s3,8(sp)
    80003110:	6a02                	ld	s4,0(sp)
    80003112:	6145                	add	sp,sp,48
    80003114:	8082                	ret
    panic("iget: no inodes");
    80003116:	00004517          	auipc	a0,0x4
    8000311a:	42250513          	add	a0,a0,1058 # 80007538 <syscalls+0x148>
    8000311e:	e80fd0ef          	jal	8000079e <panic>

0000000080003122 <iinit>:
{
    80003122:	7179                	add	sp,sp,-48
    80003124:	f406                	sd	ra,40(sp)
    80003126:	f022                	sd	s0,32(sp)
    80003128:	ec26                	sd	s1,24(sp)
    8000312a:	e84a                	sd	s2,16(sp)
    8000312c:	e44e                	sd	s3,8(sp)
    8000312e:	1800                	add	s0,sp,48
  initlock(&itable.lock, "itable");
    80003130:	00004597          	auipc	a1,0x4
    80003134:	41858593          	add	a1,a1,1048 # 80007548 <syscalls+0x158>
    80003138:	0001b517          	auipc	a0,0x1b
    8000313c:	fd050513          	add	a0,a0,-48 # 8001e108 <itable>
    80003140:	9b5fd0ef          	jal	80000af4 <initlock>
  for(i = 0; i < NINODE; i++) {
    80003144:	0001b497          	auipc	s1,0x1b
    80003148:	fec48493          	add	s1,s1,-20 # 8001e130 <itable+0x28>
    8000314c:	0001d997          	auipc	s3,0x1d
    80003150:	a7498993          	add	s3,s3,-1420 # 8001fbc0 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80003154:	00004917          	auipc	s2,0x4
    80003158:	3fc90913          	add	s2,s2,1020 # 80007550 <syscalls+0x160>
    8000315c:	85ca                	mv	a1,s2
    8000315e:	8526                	mv	a0,s1
    80003160:	581000ef          	jal	80003ee0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80003164:	08848493          	add	s1,s1,136
    80003168:	ff349ae3          	bne	s1,s3,8000315c <iinit+0x3a>
}
    8000316c:	70a2                	ld	ra,40(sp)
    8000316e:	7402                	ld	s0,32(sp)
    80003170:	64e2                	ld	s1,24(sp)
    80003172:	6942                	ld	s2,16(sp)
    80003174:	69a2                	ld	s3,8(sp)
    80003176:	6145                	add	sp,sp,48
    80003178:	8082                	ret

000000008000317a <ialloc>:
{
    8000317a:	7139                	add	sp,sp,-64
    8000317c:	fc06                	sd	ra,56(sp)
    8000317e:	f822                	sd	s0,48(sp)
    80003180:	f426                	sd	s1,40(sp)
    80003182:	f04a                	sd	s2,32(sp)
    80003184:	ec4e                	sd	s3,24(sp)
    80003186:	e852                	sd	s4,16(sp)
    80003188:	e456                	sd	s5,8(sp)
    8000318a:	e05a                	sd	s6,0(sp)
    8000318c:	0080                	add	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    8000318e:	0001b717          	auipc	a4,0x1b
    80003192:	f6672703          	lw	a4,-154(a4) # 8001e0f4 <sb+0xc>
    80003196:	4785                	li	a5,1
    80003198:	04e7f463          	bgeu	a5,a4,800031e0 <ialloc+0x66>
    8000319c:	8aaa                	mv	s5,a0
    8000319e:	8b2e                	mv	s6,a1
    800031a0:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    800031a2:	0001ba17          	auipc	s4,0x1b
    800031a6:	f46a0a13          	add	s4,s4,-186 # 8001e0e8 <sb>
    800031aa:	00495593          	srl	a1,s2,0x4
    800031ae:	018a2783          	lw	a5,24(s4)
    800031b2:	9dbd                	addw	a1,a1,a5
    800031b4:	8556                	mv	a0,s5
    800031b6:	a81ff0ef          	jal	80002c36 <bread>
    800031ba:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    800031bc:	05850993          	add	s3,a0,88
    800031c0:	00f97793          	and	a5,s2,15
    800031c4:	079a                	sll	a5,a5,0x6
    800031c6:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    800031c8:	00099783          	lh	a5,0(s3)
    800031cc:	cb9d                	beqz	a5,80003202 <ialloc+0x88>
    brelse(bp);
    800031ce:	b71ff0ef          	jal	80002d3e <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    800031d2:	0905                	add	s2,s2,1
    800031d4:	00ca2703          	lw	a4,12(s4)
    800031d8:	0009079b          	sext.w	a5,s2
    800031dc:	fce7e7e3          	bltu	a5,a4,800031aa <ialloc+0x30>
  printf("ialloc: no inodes\n");
    800031e0:	00004517          	auipc	a0,0x4
    800031e4:	37850513          	add	a0,a0,888 # 80007558 <syscalls+0x168>
    800031e8:	ae4fd0ef          	jal	800004cc <printf>
  return 0;
    800031ec:	4501                	li	a0,0
}
    800031ee:	70e2                	ld	ra,56(sp)
    800031f0:	7442                	ld	s0,48(sp)
    800031f2:	74a2                	ld	s1,40(sp)
    800031f4:	7902                	ld	s2,32(sp)
    800031f6:	69e2                	ld	s3,24(sp)
    800031f8:	6a42                	ld	s4,16(sp)
    800031fa:	6aa2                	ld	s5,8(sp)
    800031fc:	6b02                	ld	s6,0(sp)
    800031fe:	6121                	add	sp,sp,64
    80003200:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80003202:	04000613          	li	a2,64
    80003206:	4581                	li	a1,0
    80003208:	854e                	mv	a0,s3
    8000320a:	a3ffd0ef          	jal	80000c48 <memset>
      dip->type = type;
    8000320e:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80003212:	8526                	mv	a0,s1
    80003214:	40b000ef          	jal	80003e1e <log_write>
      brelse(bp);
    80003218:	8526                	mv	a0,s1
    8000321a:	b25ff0ef          	jal	80002d3e <brelse>
      return iget(dev, inum);
    8000321e:	0009059b          	sext.w	a1,s2
    80003222:	8556                	mv	a0,s5
    80003224:	e53ff0ef          	jal	80003076 <iget>
    80003228:	b7d9                	j	800031ee <ialloc+0x74>

000000008000322a <iupdate>:
{
    8000322a:	1101                	add	sp,sp,-32
    8000322c:	ec06                	sd	ra,24(sp)
    8000322e:	e822                	sd	s0,16(sp)
    80003230:	e426                	sd	s1,8(sp)
    80003232:	e04a                	sd	s2,0(sp)
    80003234:	1000                	add	s0,sp,32
    80003236:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003238:	415c                	lw	a5,4(a0)
    8000323a:	0047d79b          	srlw	a5,a5,0x4
    8000323e:	0001b597          	auipc	a1,0x1b
    80003242:	ec25a583          	lw	a1,-318(a1) # 8001e100 <sb+0x18>
    80003246:	9dbd                	addw	a1,a1,a5
    80003248:	4108                	lw	a0,0(a0)
    8000324a:	9edff0ef          	jal	80002c36 <bread>
    8000324e:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003250:	05850793          	add	a5,a0,88
    80003254:	40d8                	lw	a4,4(s1)
    80003256:	8b3d                	and	a4,a4,15
    80003258:	071a                	sll	a4,a4,0x6
    8000325a:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    8000325c:	04449703          	lh	a4,68(s1)
    80003260:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80003264:	04649703          	lh	a4,70(s1)
    80003268:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    8000326c:	04849703          	lh	a4,72(s1)
    80003270:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80003274:	04a49703          	lh	a4,74(s1)
    80003278:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    8000327c:	44f8                	lw	a4,76(s1)
    8000327e:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80003280:	03400613          	li	a2,52
    80003284:	05048593          	add	a1,s1,80
    80003288:	00c78513          	add	a0,a5,12
    8000328c:	a19fd0ef          	jal	80000ca4 <memmove>
  log_write(bp);
    80003290:	854a                	mv	a0,s2
    80003292:	38d000ef          	jal	80003e1e <log_write>
  brelse(bp);
    80003296:	854a                	mv	a0,s2
    80003298:	aa7ff0ef          	jal	80002d3e <brelse>
}
    8000329c:	60e2                	ld	ra,24(sp)
    8000329e:	6442                	ld	s0,16(sp)
    800032a0:	64a2                	ld	s1,8(sp)
    800032a2:	6902                	ld	s2,0(sp)
    800032a4:	6105                	add	sp,sp,32
    800032a6:	8082                	ret

00000000800032a8 <idup>:
{
    800032a8:	1101                	add	sp,sp,-32
    800032aa:	ec06                	sd	ra,24(sp)
    800032ac:	e822                	sd	s0,16(sp)
    800032ae:	e426                	sd	s1,8(sp)
    800032b0:	1000                	add	s0,sp,32
    800032b2:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800032b4:	0001b517          	auipc	a0,0x1b
    800032b8:	e5450513          	add	a0,a0,-428 # 8001e108 <itable>
    800032bc:	8b9fd0ef          	jal	80000b74 <acquire>
  ip->ref++;
    800032c0:	449c                	lw	a5,8(s1)
    800032c2:	2785                	addw	a5,a5,1
    800032c4:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800032c6:	0001b517          	auipc	a0,0x1b
    800032ca:	e4250513          	add	a0,a0,-446 # 8001e108 <itable>
    800032ce:	93ffd0ef          	jal	80000c0c <release>
}
    800032d2:	8526                	mv	a0,s1
    800032d4:	60e2                	ld	ra,24(sp)
    800032d6:	6442                	ld	s0,16(sp)
    800032d8:	64a2                	ld	s1,8(sp)
    800032da:	6105                	add	sp,sp,32
    800032dc:	8082                	ret

00000000800032de <ilock>:
{
    800032de:	1101                	add	sp,sp,-32
    800032e0:	ec06                	sd	ra,24(sp)
    800032e2:	e822                	sd	s0,16(sp)
    800032e4:	e426                	sd	s1,8(sp)
    800032e6:	e04a                	sd	s2,0(sp)
    800032e8:	1000                	add	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    800032ea:	c105                	beqz	a0,8000330a <ilock+0x2c>
    800032ec:	84aa                	mv	s1,a0
    800032ee:	451c                	lw	a5,8(a0)
    800032f0:	00f05d63          	blez	a5,8000330a <ilock+0x2c>
  acquiresleep(&ip->lock);
    800032f4:	0541                	add	a0,a0,16
    800032f6:	421000ef          	jal	80003f16 <acquiresleep>
  if(ip->valid == 0){
    800032fa:	40bc                	lw	a5,64(s1)
    800032fc:	cf89                	beqz	a5,80003316 <ilock+0x38>
}
    800032fe:	60e2                	ld	ra,24(sp)
    80003300:	6442                	ld	s0,16(sp)
    80003302:	64a2                	ld	s1,8(sp)
    80003304:	6902                	ld	s2,0(sp)
    80003306:	6105                	add	sp,sp,32
    80003308:	8082                	ret
    panic("ilock");
    8000330a:	00004517          	auipc	a0,0x4
    8000330e:	26650513          	add	a0,a0,614 # 80007570 <syscalls+0x180>
    80003312:	c8cfd0ef          	jal	8000079e <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003316:	40dc                	lw	a5,4(s1)
    80003318:	0047d79b          	srlw	a5,a5,0x4
    8000331c:	0001b597          	auipc	a1,0x1b
    80003320:	de45a583          	lw	a1,-540(a1) # 8001e100 <sb+0x18>
    80003324:	9dbd                	addw	a1,a1,a5
    80003326:	4088                	lw	a0,0(s1)
    80003328:	90fff0ef          	jal	80002c36 <bread>
    8000332c:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    8000332e:	05850593          	add	a1,a0,88
    80003332:	40dc                	lw	a5,4(s1)
    80003334:	8bbd                	and	a5,a5,15
    80003336:	079a                	sll	a5,a5,0x6
    80003338:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    8000333a:	00059783          	lh	a5,0(a1)
    8000333e:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80003342:	00259783          	lh	a5,2(a1)
    80003346:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    8000334a:	00459783          	lh	a5,4(a1)
    8000334e:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003352:	00659783          	lh	a5,6(a1)
    80003356:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    8000335a:	459c                	lw	a5,8(a1)
    8000335c:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    8000335e:	03400613          	li	a2,52
    80003362:	05b1                	add	a1,a1,12
    80003364:	05048513          	add	a0,s1,80
    80003368:	93dfd0ef          	jal	80000ca4 <memmove>
    brelse(bp);
    8000336c:	854a                	mv	a0,s2
    8000336e:	9d1ff0ef          	jal	80002d3e <brelse>
    ip->valid = 1;
    80003372:	4785                	li	a5,1
    80003374:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80003376:	04449783          	lh	a5,68(s1)
    8000337a:	f3d1                	bnez	a5,800032fe <ilock+0x20>
      panic("ilock: no type");
    8000337c:	00004517          	auipc	a0,0x4
    80003380:	1fc50513          	add	a0,a0,508 # 80007578 <syscalls+0x188>
    80003384:	c1afd0ef          	jal	8000079e <panic>

0000000080003388 <iunlock>:
{
    80003388:	1101                	add	sp,sp,-32
    8000338a:	ec06                	sd	ra,24(sp)
    8000338c:	e822                	sd	s0,16(sp)
    8000338e:	e426                	sd	s1,8(sp)
    80003390:	e04a                	sd	s2,0(sp)
    80003392:	1000                	add	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80003394:	c505                	beqz	a0,800033bc <iunlock+0x34>
    80003396:	84aa                	mv	s1,a0
    80003398:	01050913          	add	s2,a0,16
    8000339c:	854a                	mv	a0,s2
    8000339e:	3f7000ef          	jal	80003f94 <holdingsleep>
    800033a2:	cd09                	beqz	a0,800033bc <iunlock+0x34>
    800033a4:	449c                	lw	a5,8(s1)
    800033a6:	00f05b63          	blez	a5,800033bc <iunlock+0x34>
  releasesleep(&ip->lock);
    800033aa:	854a                	mv	a0,s2
    800033ac:	3b1000ef          	jal	80003f5c <releasesleep>
}
    800033b0:	60e2                	ld	ra,24(sp)
    800033b2:	6442                	ld	s0,16(sp)
    800033b4:	64a2                	ld	s1,8(sp)
    800033b6:	6902                	ld	s2,0(sp)
    800033b8:	6105                	add	sp,sp,32
    800033ba:	8082                	ret
    panic("iunlock");
    800033bc:	00004517          	auipc	a0,0x4
    800033c0:	1cc50513          	add	a0,a0,460 # 80007588 <syscalls+0x198>
    800033c4:	bdafd0ef          	jal	8000079e <panic>

00000000800033c8 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    800033c8:	7179                	add	sp,sp,-48
    800033ca:	f406                	sd	ra,40(sp)
    800033cc:	f022                	sd	s0,32(sp)
    800033ce:	ec26                	sd	s1,24(sp)
    800033d0:	e84a                	sd	s2,16(sp)
    800033d2:	e44e                	sd	s3,8(sp)
    800033d4:	e052                	sd	s4,0(sp)
    800033d6:	1800                	add	s0,sp,48
    800033d8:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    800033da:	05050493          	add	s1,a0,80
    800033de:	08050913          	add	s2,a0,128
    800033e2:	a021                	j	800033ea <itrunc+0x22>
    800033e4:	0491                	add	s1,s1,4
    800033e6:	01248b63          	beq	s1,s2,800033fc <itrunc+0x34>
    if(ip->addrs[i]){
    800033ea:	408c                	lw	a1,0(s1)
    800033ec:	dde5                	beqz	a1,800033e4 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    800033ee:	0009a503          	lw	a0,0(s3)
    800033f2:	a3dff0ef          	jal	80002e2e <bfree>
      ip->addrs[i] = 0;
    800033f6:	0004a023          	sw	zero,0(s1)
    800033fa:	b7ed                	j	800033e4 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    800033fc:	0809a583          	lw	a1,128(s3)
    80003400:	ed91                	bnez	a1,8000341c <itrunc+0x54>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80003402:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80003406:	854e                	mv	a0,s3
    80003408:	e23ff0ef          	jal	8000322a <iupdate>
}
    8000340c:	70a2                	ld	ra,40(sp)
    8000340e:	7402                	ld	s0,32(sp)
    80003410:	64e2                	ld	s1,24(sp)
    80003412:	6942                	ld	s2,16(sp)
    80003414:	69a2                	ld	s3,8(sp)
    80003416:	6a02                	ld	s4,0(sp)
    80003418:	6145                	add	sp,sp,48
    8000341a:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    8000341c:	0009a503          	lw	a0,0(s3)
    80003420:	817ff0ef          	jal	80002c36 <bread>
    80003424:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80003426:	05850493          	add	s1,a0,88
    8000342a:	45850913          	add	s2,a0,1112
    8000342e:	a021                	j	80003436 <itrunc+0x6e>
    80003430:	0491                	add	s1,s1,4
    80003432:	01248963          	beq	s1,s2,80003444 <itrunc+0x7c>
      if(a[j])
    80003436:	408c                	lw	a1,0(s1)
    80003438:	dde5                	beqz	a1,80003430 <itrunc+0x68>
        bfree(ip->dev, a[j]);
    8000343a:	0009a503          	lw	a0,0(s3)
    8000343e:	9f1ff0ef          	jal	80002e2e <bfree>
    80003442:	b7fd                	j	80003430 <itrunc+0x68>
    brelse(bp);
    80003444:	8552                	mv	a0,s4
    80003446:	8f9ff0ef          	jal	80002d3e <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    8000344a:	0809a583          	lw	a1,128(s3)
    8000344e:	0009a503          	lw	a0,0(s3)
    80003452:	9ddff0ef          	jal	80002e2e <bfree>
    ip->addrs[NDIRECT] = 0;
    80003456:	0809a023          	sw	zero,128(s3)
    8000345a:	b765                	j	80003402 <itrunc+0x3a>

000000008000345c <iput>:
{
    8000345c:	1101                	add	sp,sp,-32
    8000345e:	ec06                	sd	ra,24(sp)
    80003460:	e822                	sd	s0,16(sp)
    80003462:	e426                	sd	s1,8(sp)
    80003464:	e04a                	sd	s2,0(sp)
    80003466:	1000                	add	s0,sp,32
    80003468:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    8000346a:	0001b517          	auipc	a0,0x1b
    8000346e:	c9e50513          	add	a0,a0,-866 # 8001e108 <itable>
    80003472:	f02fd0ef          	jal	80000b74 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003476:	4498                	lw	a4,8(s1)
    80003478:	4785                	li	a5,1
    8000347a:	02f70163          	beq	a4,a5,8000349c <iput+0x40>
  ip->ref--;
    8000347e:	449c                	lw	a5,8(s1)
    80003480:	37fd                	addw	a5,a5,-1
    80003482:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003484:	0001b517          	auipc	a0,0x1b
    80003488:	c8450513          	add	a0,a0,-892 # 8001e108 <itable>
    8000348c:	f80fd0ef          	jal	80000c0c <release>
}
    80003490:	60e2                	ld	ra,24(sp)
    80003492:	6442                	ld	s0,16(sp)
    80003494:	64a2                	ld	s1,8(sp)
    80003496:	6902                	ld	s2,0(sp)
    80003498:	6105                	add	sp,sp,32
    8000349a:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    8000349c:	40bc                	lw	a5,64(s1)
    8000349e:	d3e5                	beqz	a5,8000347e <iput+0x22>
    800034a0:	04a49783          	lh	a5,74(s1)
    800034a4:	ffe9                	bnez	a5,8000347e <iput+0x22>
    acquiresleep(&ip->lock);
    800034a6:	01048913          	add	s2,s1,16
    800034aa:	854a                	mv	a0,s2
    800034ac:	26b000ef          	jal	80003f16 <acquiresleep>
    release(&itable.lock);
    800034b0:	0001b517          	auipc	a0,0x1b
    800034b4:	c5850513          	add	a0,a0,-936 # 8001e108 <itable>
    800034b8:	f54fd0ef          	jal	80000c0c <release>
    itrunc(ip);
    800034bc:	8526                	mv	a0,s1
    800034be:	f0bff0ef          	jal	800033c8 <itrunc>
    ip->type = 0;
    800034c2:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    800034c6:	8526                	mv	a0,s1
    800034c8:	d63ff0ef          	jal	8000322a <iupdate>
    ip->valid = 0;
    800034cc:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    800034d0:	854a                	mv	a0,s2
    800034d2:	28b000ef          	jal	80003f5c <releasesleep>
    acquire(&itable.lock);
    800034d6:	0001b517          	auipc	a0,0x1b
    800034da:	c3250513          	add	a0,a0,-974 # 8001e108 <itable>
    800034de:	e96fd0ef          	jal	80000b74 <acquire>
    800034e2:	bf71                	j	8000347e <iput+0x22>

00000000800034e4 <iunlockput>:
{
    800034e4:	1101                	add	sp,sp,-32
    800034e6:	ec06                	sd	ra,24(sp)
    800034e8:	e822                	sd	s0,16(sp)
    800034ea:	e426                	sd	s1,8(sp)
    800034ec:	1000                	add	s0,sp,32
    800034ee:	84aa                	mv	s1,a0
  iunlock(ip);
    800034f0:	e99ff0ef          	jal	80003388 <iunlock>
  iput(ip);
    800034f4:	8526                	mv	a0,s1
    800034f6:	f67ff0ef          	jal	8000345c <iput>
}
    800034fa:	60e2                	ld	ra,24(sp)
    800034fc:	6442                	ld	s0,16(sp)
    800034fe:	64a2                	ld	s1,8(sp)
    80003500:	6105                	add	sp,sp,32
    80003502:	8082                	ret

0000000080003504 <ireclaim>:
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80003504:	0001b717          	auipc	a4,0x1b
    80003508:	bf072703          	lw	a4,-1040(a4) # 8001e0f4 <sb+0xc>
    8000350c:	4785                	li	a5,1
    8000350e:	0ae7ff63          	bgeu	a5,a4,800035cc <ireclaim+0xc8>
{
    80003512:	7139                	add	sp,sp,-64
    80003514:	fc06                	sd	ra,56(sp)
    80003516:	f822                	sd	s0,48(sp)
    80003518:	f426                	sd	s1,40(sp)
    8000351a:	f04a                	sd	s2,32(sp)
    8000351c:	ec4e                	sd	s3,24(sp)
    8000351e:	e852                	sd	s4,16(sp)
    80003520:	e456                	sd	s5,8(sp)
    80003522:	e05a                	sd	s6,0(sp)
    80003524:	0080                	add	s0,sp,64
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80003526:	4485                	li	s1,1
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    80003528:	00050a1b          	sext.w	s4,a0
    8000352c:	0001ba97          	auipc	s5,0x1b
    80003530:	bbca8a93          	add	s5,s5,-1092 # 8001e0e8 <sb>
      printf("ireclaim: orphaned inode %d\n", inum);
    80003534:	00004b17          	auipc	s6,0x4
    80003538:	05cb0b13          	add	s6,s6,92 # 80007590 <syscalls+0x1a0>
    8000353c:	a099                	j	80003582 <ireclaim+0x7e>
    8000353e:	85ce                	mv	a1,s3
    80003540:	855a                	mv	a0,s6
    80003542:	f8bfc0ef          	jal	800004cc <printf>
      ip = iget(dev, inum);
    80003546:	85ce                	mv	a1,s3
    80003548:	8552                	mv	a0,s4
    8000354a:	b2dff0ef          	jal	80003076 <iget>
    8000354e:	89aa                	mv	s3,a0
    brelse(bp);
    80003550:	854a                	mv	a0,s2
    80003552:	fecff0ef          	jal	80002d3e <brelse>
    if (ip) {
    80003556:	00098f63          	beqz	s3,80003574 <ireclaim+0x70>
      begin_op();
    8000355a:	746000ef          	jal	80003ca0 <begin_op>
      ilock(ip);
    8000355e:	854e                	mv	a0,s3
    80003560:	d7fff0ef          	jal	800032de <ilock>
      iunlock(ip);
    80003564:	854e                	mv	a0,s3
    80003566:	e23ff0ef          	jal	80003388 <iunlock>
      iput(ip);
    8000356a:	854e                	mv	a0,s3
    8000356c:	ef1ff0ef          	jal	8000345c <iput>
      end_op();
    80003570:	79a000ef          	jal	80003d0a <end_op>
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80003574:	0485                	add	s1,s1,1
    80003576:	00caa703          	lw	a4,12(s5)
    8000357a:	0004879b          	sext.w	a5,s1
    8000357e:	02e7fd63          	bgeu	a5,a4,800035b8 <ireclaim+0xb4>
    80003582:	0004899b          	sext.w	s3,s1
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    80003586:	0044d593          	srl	a1,s1,0x4
    8000358a:	018aa783          	lw	a5,24(s5)
    8000358e:	9dbd                	addw	a1,a1,a5
    80003590:	8552                	mv	a0,s4
    80003592:	ea4ff0ef          	jal	80002c36 <bread>
    80003596:	892a                	mv	s2,a0
    struct dinode *dip = (struct dinode *)bp->data + inum % IPB;
    80003598:	05850793          	add	a5,a0,88
    8000359c:	00f9f713          	and	a4,s3,15
    800035a0:	071a                	sll	a4,a4,0x6
    800035a2:	97ba                	add	a5,a5,a4
    if (dip->type != 0 && dip->nlink == 0) {  // is an orphaned inode
    800035a4:	00079703          	lh	a4,0(a5)
    800035a8:	c701                	beqz	a4,800035b0 <ireclaim+0xac>
    800035aa:	00679783          	lh	a5,6(a5)
    800035ae:	dbc1                	beqz	a5,8000353e <ireclaim+0x3a>
    brelse(bp);
    800035b0:	854a                	mv	a0,s2
    800035b2:	f8cff0ef          	jal	80002d3e <brelse>
    if (ip) {
    800035b6:	bf7d                	j	80003574 <ireclaim+0x70>
}
    800035b8:	70e2                	ld	ra,56(sp)
    800035ba:	7442                	ld	s0,48(sp)
    800035bc:	74a2                	ld	s1,40(sp)
    800035be:	7902                	ld	s2,32(sp)
    800035c0:	69e2                	ld	s3,24(sp)
    800035c2:	6a42                	ld	s4,16(sp)
    800035c4:	6aa2                	ld	s5,8(sp)
    800035c6:	6b02                	ld	s6,0(sp)
    800035c8:	6121                	add	sp,sp,64
    800035ca:	8082                	ret
    800035cc:	8082                	ret

00000000800035ce <fsinit>:
fsinit(int dev) {
    800035ce:	7179                	add	sp,sp,-48
    800035d0:	f406                	sd	ra,40(sp)
    800035d2:	f022                	sd	s0,32(sp)
    800035d4:	ec26                	sd	s1,24(sp)
    800035d6:	e84a                	sd	s2,16(sp)
    800035d8:	e44e                	sd	s3,8(sp)
    800035da:	1800                	add	s0,sp,48
    800035dc:	84aa                	mv	s1,a0
  bp = bread(dev, 1);
    800035de:	4585                	li	a1,1
    800035e0:	e56ff0ef          	jal	80002c36 <bread>
    800035e4:	892a                	mv	s2,a0
  memmove(sb, bp->data, sizeof(*sb));
    800035e6:	0001b997          	auipc	s3,0x1b
    800035ea:	b0298993          	add	s3,s3,-1278 # 8001e0e8 <sb>
    800035ee:	02000613          	li	a2,32
    800035f2:	05850593          	add	a1,a0,88
    800035f6:	854e                	mv	a0,s3
    800035f8:	eacfd0ef          	jal	80000ca4 <memmove>
  brelse(bp);
    800035fc:	854a                	mv	a0,s2
    800035fe:	f40ff0ef          	jal	80002d3e <brelse>
  if(sb.magic != FSMAGIC)
    80003602:	0009a703          	lw	a4,0(s3)
    80003606:	102037b7          	lui	a5,0x10203
    8000360a:	04078793          	add	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    8000360e:	02f71363          	bne	a4,a5,80003634 <fsinit+0x66>
  initlog(dev, &sb);
    80003612:	0001b597          	auipc	a1,0x1b
    80003616:	ad658593          	add	a1,a1,-1322 # 8001e0e8 <sb>
    8000361a:	8526                	mv	a0,s1
    8000361c:	606000ef          	jal	80003c22 <initlog>
  ireclaim(dev);
    80003620:	8526                	mv	a0,s1
    80003622:	ee3ff0ef          	jal	80003504 <ireclaim>
}
    80003626:	70a2                	ld	ra,40(sp)
    80003628:	7402                	ld	s0,32(sp)
    8000362a:	64e2                	ld	s1,24(sp)
    8000362c:	6942                	ld	s2,16(sp)
    8000362e:	69a2                	ld	s3,8(sp)
    80003630:	6145                	add	sp,sp,48
    80003632:	8082                	ret
    panic("invalid file system");
    80003634:	00004517          	auipc	a0,0x4
    80003638:	f7c50513          	add	a0,a0,-132 # 800075b0 <syscalls+0x1c0>
    8000363c:	962fd0ef          	jal	8000079e <panic>

0000000080003640 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003640:	1141                	add	sp,sp,-16
    80003642:	e422                	sd	s0,8(sp)
    80003644:	0800                	add	s0,sp,16
  st->dev = ip->dev;
    80003646:	411c                	lw	a5,0(a0)
    80003648:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    8000364a:	415c                	lw	a5,4(a0)
    8000364c:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    8000364e:	04451783          	lh	a5,68(a0)
    80003652:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003656:	04a51783          	lh	a5,74(a0)
    8000365a:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    8000365e:	04c56783          	lwu	a5,76(a0)
    80003662:	e99c                	sd	a5,16(a1)
}
    80003664:	6422                	ld	s0,8(sp)
    80003666:	0141                	add	sp,sp,16
    80003668:	8082                	ret

000000008000366a <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    8000366a:	457c                	lw	a5,76(a0)
    8000366c:	0cd7ef63          	bltu	a5,a3,8000374a <readi+0xe0>
{
    80003670:	7159                	add	sp,sp,-112
    80003672:	f486                	sd	ra,104(sp)
    80003674:	f0a2                	sd	s0,96(sp)
    80003676:	eca6                	sd	s1,88(sp)
    80003678:	e8ca                	sd	s2,80(sp)
    8000367a:	e4ce                	sd	s3,72(sp)
    8000367c:	e0d2                	sd	s4,64(sp)
    8000367e:	fc56                	sd	s5,56(sp)
    80003680:	f85a                	sd	s6,48(sp)
    80003682:	f45e                	sd	s7,40(sp)
    80003684:	f062                	sd	s8,32(sp)
    80003686:	ec66                	sd	s9,24(sp)
    80003688:	e86a                	sd	s10,16(sp)
    8000368a:	e46e                	sd	s11,8(sp)
    8000368c:	1880                	add	s0,sp,112
    8000368e:	8b2a                	mv	s6,a0
    80003690:	8bae                	mv	s7,a1
    80003692:	8a32                	mv	s4,a2
    80003694:	84b6                	mv	s1,a3
    80003696:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80003698:	9f35                	addw	a4,a4,a3
    return 0;
    8000369a:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    8000369c:	08d76663          	bltu	a4,a3,80003728 <readi+0xbe>
  if(off + n > ip->size)
    800036a0:	00e7f463          	bgeu	a5,a4,800036a8 <readi+0x3e>
    n = ip->size - off;
    800036a4:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800036a8:	080a8f63          	beqz	s5,80003746 <readi+0xdc>
    800036ac:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    800036ae:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    800036b2:	5c7d                	li	s8,-1
    800036b4:	a80d                	j	800036e6 <readi+0x7c>
    800036b6:	020d1d93          	sll	s11,s10,0x20
    800036ba:	020ddd93          	srl	s11,s11,0x20
    800036be:	05890613          	add	a2,s2,88
    800036c2:	86ee                	mv	a3,s11
    800036c4:	963a                	add	a2,a2,a4
    800036c6:	85d2                	mv	a1,s4
    800036c8:	855e                	mv	a0,s7
    800036ca:	b33fe0ef          	jal	800021fc <either_copyout>
    800036ce:	05850763          	beq	a0,s8,8000371c <readi+0xb2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    800036d2:	854a                	mv	a0,s2
    800036d4:	e6aff0ef          	jal	80002d3e <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800036d8:	013d09bb          	addw	s3,s10,s3
    800036dc:	009d04bb          	addw	s1,s10,s1
    800036e0:	9a6e                	add	s4,s4,s11
    800036e2:	0559f163          	bgeu	s3,s5,80003724 <readi+0xba>
    uint addr = bmap(ip, off/BSIZE);
    800036e6:	00a4d59b          	srlw	a1,s1,0xa
    800036ea:	855a                	mv	a0,s6
    800036ec:	8bdff0ef          	jal	80002fa8 <bmap>
    800036f0:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    800036f4:	c985                	beqz	a1,80003724 <readi+0xba>
    bp = bread(ip->dev, addr);
    800036f6:	000b2503          	lw	a0,0(s6)
    800036fa:	d3cff0ef          	jal	80002c36 <bread>
    800036fe:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003700:	3ff4f713          	and	a4,s1,1023
    80003704:	40ec87bb          	subw	a5,s9,a4
    80003708:	413a86bb          	subw	a3,s5,s3
    8000370c:	8d3e                	mv	s10,a5
    8000370e:	2781                	sext.w	a5,a5
    80003710:	0006861b          	sext.w	a2,a3
    80003714:	faf671e3          	bgeu	a2,a5,800036b6 <readi+0x4c>
    80003718:	8d36                	mv	s10,a3
    8000371a:	bf71                	j	800036b6 <readi+0x4c>
      brelse(bp);
    8000371c:	854a                	mv	a0,s2
    8000371e:	e20ff0ef          	jal	80002d3e <brelse>
      tot = -1;
    80003722:	59fd                	li	s3,-1
  }
  return tot;
    80003724:	0009851b          	sext.w	a0,s3
}
    80003728:	70a6                	ld	ra,104(sp)
    8000372a:	7406                	ld	s0,96(sp)
    8000372c:	64e6                	ld	s1,88(sp)
    8000372e:	6946                	ld	s2,80(sp)
    80003730:	69a6                	ld	s3,72(sp)
    80003732:	6a06                	ld	s4,64(sp)
    80003734:	7ae2                	ld	s5,56(sp)
    80003736:	7b42                	ld	s6,48(sp)
    80003738:	7ba2                	ld	s7,40(sp)
    8000373a:	7c02                	ld	s8,32(sp)
    8000373c:	6ce2                	ld	s9,24(sp)
    8000373e:	6d42                	ld	s10,16(sp)
    80003740:	6da2                	ld	s11,8(sp)
    80003742:	6165                	add	sp,sp,112
    80003744:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003746:	89d6                	mv	s3,s5
    80003748:	bff1                	j	80003724 <readi+0xba>
    return 0;
    8000374a:	4501                	li	a0,0
}
    8000374c:	8082                	ret

000000008000374e <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    8000374e:	457c                	lw	a5,76(a0)
    80003750:	0ed7ea63          	bltu	a5,a3,80003844 <writei+0xf6>
{
    80003754:	7159                	add	sp,sp,-112
    80003756:	f486                	sd	ra,104(sp)
    80003758:	f0a2                	sd	s0,96(sp)
    8000375a:	eca6                	sd	s1,88(sp)
    8000375c:	e8ca                	sd	s2,80(sp)
    8000375e:	e4ce                	sd	s3,72(sp)
    80003760:	e0d2                	sd	s4,64(sp)
    80003762:	fc56                	sd	s5,56(sp)
    80003764:	f85a                	sd	s6,48(sp)
    80003766:	f45e                	sd	s7,40(sp)
    80003768:	f062                	sd	s8,32(sp)
    8000376a:	ec66                	sd	s9,24(sp)
    8000376c:	e86a                	sd	s10,16(sp)
    8000376e:	e46e                	sd	s11,8(sp)
    80003770:	1880                	add	s0,sp,112
    80003772:	8aaa                	mv	s5,a0
    80003774:	8bae                	mv	s7,a1
    80003776:	8a32                	mv	s4,a2
    80003778:	8936                	mv	s2,a3
    8000377a:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    8000377c:	00e687bb          	addw	a5,a3,a4
    80003780:	0cd7e463          	bltu	a5,a3,80003848 <writei+0xfa>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003784:	00043737          	lui	a4,0x43
    80003788:	0cf76263          	bltu	a4,a5,8000384c <writei+0xfe>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000378c:	0a0b0a63          	beqz	s6,80003840 <writei+0xf2>
    80003790:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003792:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003796:	5c7d                	li	s8,-1
    80003798:	a825                	j	800037d0 <writei+0x82>
    8000379a:	020d1d93          	sll	s11,s10,0x20
    8000379e:	020ddd93          	srl	s11,s11,0x20
    800037a2:	05848513          	add	a0,s1,88
    800037a6:	86ee                	mv	a3,s11
    800037a8:	8652                	mv	a2,s4
    800037aa:	85de                	mv	a1,s7
    800037ac:	953a                	add	a0,a0,a4
    800037ae:	a99fe0ef          	jal	80002246 <either_copyin>
    800037b2:	05850a63          	beq	a0,s8,80003806 <writei+0xb8>
      brelse(bp);
      break;
    }
    log_write(bp);
    800037b6:	8526                	mv	a0,s1
    800037b8:	666000ef          	jal	80003e1e <log_write>
    brelse(bp);
    800037bc:	8526                	mv	a0,s1
    800037be:	d80ff0ef          	jal	80002d3e <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800037c2:	013d09bb          	addw	s3,s10,s3
    800037c6:	012d093b          	addw	s2,s10,s2
    800037ca:	9a6e                	add	s4,s4,s11
    800037cc:	0569f063          	bgeu	s3,s6,8000380c <writei+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    800037d0:	00a9559b          	srlw	a1,s2,0xa
    800037d4:	8556                	mv	a0,s5
    800037d6:	fd2ff0ef          	jal	80002fa8 <bmap>
    800037da:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    800037de:	c59d                	beqz	a1,8000380c <writei+0xbe>
    bp = bread(ip->dev, addr);
    800037e0:	000aa503          	lw	a0,0(s5)
    800037e4:	c52ff0ef          	jal	80002c36 <bread>
    800037e8:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800037ea:	3ff97713          	and	a4,s2,1023
    800037ee:	40ec87bb          	subw	a5,s9,a4
    800037f2:	413b06bb          	subw	a3,s6,s3
    800037f6:	8d3e                	mv	s10,a5
    800037f8:	2781                	sext.w	a5,a5
    800037fa:	0006861b          	sext.w	a2,a3
    800037fe:	f8f67ee3          	bgeu	a2,a5,8000379a <writei+0x4c>
    80003802:	8d36                	mv	s10,a3
    80003804:	bf59                	j	8000379a <writei+0x4c>
      brelse(bp);
    80003806:	8526                	mv	a0,s1
    80003808:	d36ff0ef          	jal	80002d3e <brelse>
  }

  if(off > ip->size)
    8000380c:	04caa783          	lw	a5,76(s5)
    80003810:	0127f463          	bgeu	a5,s2,80003818 <writei+0xca>
    ip->size = off;
    80003814:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003818:	8556                	mv	a0,s5
    8000381a:	a11ff0ef          	jal	8000322a <iupdate>

  return tot;
    8000381e:	0009851b          	sext.w	a0,s3
}
    80003822:	70a6                	ld	ra,104(sp)
    80003824:	7406                	ld	s0,96(sp)
    80003826:	64e6                	ld	s1,88(sp)
    80003828:	6946                	ld	s2,80(sp)
    8000382a:	69a6                	ld	s3,72(sp)
    8000382c:	6a06                	ld	s4,64(sp)
    8000382e:	7ae2                	ld	s5,56(sp)
    80003830:	7b42                	ld	s6,48(sp)
    80003832:	7ba2                	ld	s7,40(sp)
    80003834:	7c02                	ld	s8,32(sp)
    80003836:	6ce2                	ld	s9,24(sp)
    80003838:	6d42                	ld	s10,16(sp)
    8000383a:	6da2                	ld	s11,8(sp)
    8000383c:	6165                	add	sp,sp,112
    8000383e:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003840:	89da                	mv	s3,s6
    80003842:	bfd9                	j	80003818 <writei+0xca>
    return -1;
    80003844:	557d                	li	a0,-1
}
    80003846:	8082                	ret
    return -1;
    80003848:	557d                	li	a0,-1
    8000384a:	bfe1                	j	80003822 <writei+0xd4>
    return -1;
    8000384c:	557d                	li	a0,-1
    8000384e:	bfd1                	j	80003822 <writei+0xd4>

0000000080003850 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003850:	1141                	add	sp,sp,-16
    80003852:	e406                	sd	ra,8(sp)
    80003854:	e022                	sd	s0,0(sp)
    80003856:	0800                	add	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003858:	4639                	li	a2,14
    8000385a:	cbafd0ef          	jal	80000d14 <strncmp>
}
    8000385e:	60a2                	ld	ra,8(sp)
    80003860:	6402                	ld	s0,0(sp)
    80003862:	0141                	add	sp,sp,16
    80003864:	8082                	ret

0000000080003866 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003866:	7139                	add	sp,sp,-64
    80003868:	fc06                	sd	ra,56(sp)
    8000386a:	f822                	sd	s0,48(sp)
    8000386c:	f426                	sd	s1,40(sp)
    8000386e:	f04a                	sd	s2,32(sp)
    80003870:	ec4e                	sd	s3,24(sp)
    80003872:	e852                	sd	s4,16(sp)
    80003874:	0080                	add	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003876:	04451703          	lh	a4,68(a0)
    8000387a:	4785                	li	a5,1
    8000387c:	00f71a63          	bne	a4,a5,80003890 <dirlookup+0x2a>
    80003880:	892a                	mv	s2,a0
    80003882:	89ae                	mv	s3,a1
    80003884:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003886:	457c                	lw	a5,76(a0)
    80003888:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    8000388a:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000388c:	e39d                	bnez	a5,800038b2 <dirlookup+0x4c>
    8000388e:	a095                	j	800038f2 <dirlookup+0x8c>
    panic("dirlookup not DIR");
    80003890:	00004517          	auipc	a0,0x4
    80003894:	d3850513          	add	a0,a0,-712 # 800075c8 <syscalls+0x1d8>
    80003898:	f07fc0ef          	jal	8000079e <panic>
      panic("dirlookup read");
    8000389c:	00004517          	auipc	a0,0x4
    800038a0:	d4450513          	add	a0,a0,-700 # 800075e0 <syscalls+0x1f0>
    800038a4:	efbfc0ef          	jal	8000079e <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800038a8:	24c1                	addw	s1,s1,16
    800038aa:	04c92783          	lw	a5,76(s2)
    800038ae:	04f4f163          	bgeu	s1,a5,800038f0 <dirlookup+0x8a>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800038b2:	4741                	li	a4,16
    800038b4:	86a6                	mv	a3,s1
    800038b6:	fc040613          	add	a2,s0,-64
    800038ba:	4581                	li	a1,0
    800038bc:	854a                	mv	a0,s2
    800038be:	dadff0ef          	jal	8000366a <readi>
    800038c2:	47c1                	li	a5,16
    800038c4:	fcf51ce3          	bne	a0,a5,8000389c <dirlookup+0x36>
    if(de.inum == 0)
    800038c8:	fc045783          	lhu	a5,-64(s0)
    800038cc:	dff1                	beqz	a5,800038a8 <dirlookup+0x42>
    if(namecmp(name, de.name) == 0){
    800038ce:	fc240593          	add	a1,s0,-62
    800038d2:	854e                	mv	a0,s3
    800038d4:	f7dff0ef          	jal	80003850 <namecmp>
    800038d8:	f961                	bnez	a0,800038a8 <dirlookup+0x42>
      if(poff)
    800038da:	000a0463          	beqz	s4,800038e2 <dirlookup+0x7c>
        *poff = off;
    800038de:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800038e2:	fc045583          	lhu	a1,-64(s0)
    800038e6:	00092503          	lw	a0,0(s2)
    800038ea:	f8cff0ef          	jal	80003076 <iget>
    800038ee:	a011                	j	800038f2 <dirlookup+0x8c>
  return 0;
    800038f0:	4501                	li	a0,0
}
    800038f2:	70e2                	ld	ra,56(sp)
    800038f4:	7442                	ld	s0,48(sp)
    800038f6:	74a2                	ld	s1,40(sp)
    800038f8:	7902                	ld	s2,32(sp)
    800038fa:	69e2                	ld	s3,24(sp)
    800038fc:	6a42                	ld	s4,16(sp)
    800038fe:	6121                	add	sp,sp,64
    80003900:	8082                	ret

0000000080003902 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003902:	711d                	add	sp,sp,-96
    80003904:	ec86                	sd	ra,88(sp)
    80003906:	e8a2                	sd	s0,80(sp)
    80003908:	e4a6                	sd	s1,72(sp)
    8000390a:	e0ca                	sd	s2,64(sp)
    8000390c:	fc4e                	sd	s3,56(sp)
    8000390e:	f852                	sd	s4,48(sp)
    80003910:	f456                	sd	s5,40(sp)
    80003912:	f05a                	sd	s6,32(sp)
    80003914:	ec5e                	sd	s7,24(sp)
    80003916:	e862                	sd	s8,16(sp)
    80003918:	e466                	sd	s9,8(sp)
    8000391a:	1080                	add	s0,sp,96
    8000391c:	84aa                	mv	s1,a0
    8000391e:	8b2e                	mv	s6,a1
    80003920:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003922:	00054703          	lbu	a4,0(a0)
    80003926:	02f00793          	li	a5,47
    8000392a:	00f70e63          	beq	a4,a5,80003946 <namex+0x44>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    8000392e:	eddfd0ef          	jal	8000180a <myproc>
    80003932:	15053503          	ld	a0,336(a0)
    80003936:	973ff0ef          	jal	800032a8 <idup>
    8000393a:	8a2a                	mv	s4,a0
  while(*path == '/')
    8000393c:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80003940:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003942:	4b85                	li	s7,1
    80003944:	a871                	j	800039e0 <namex+0xde>
    ip = iget(ROOTDEV, ROOTINO);
    80003946:	4585                	li	a1,1
    80003948:	4505                	li	a0,1
    8000394a:	f2cff0ef          	jal	80003076 <iget>
    8000394e:	8a2a                	mv	s4,a0
    80003950:	b7f5                	j	8000393c <namex+0x3a>
      iunlockput(ip);
    80003952:	8552                	mv	a0,s4
    80003954:	b91ff0ef          	jal	800034e4 <iunlockput>
      return 0;
    80003958:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    8000395a:	8552                	mv	a0,s4
    8000395c:	60e6                	ld	ra,88(sp)
    8000395e:	6446                	ld	s0,80(sp)
    80003960:	64a6                	ld	s1,72(sp)
    80003962:	6906                	ld	s2,64(sp)
    80003964:	79e2                	ld	s3,56(sp)
    80003966:	7a42                	ld	s4,48(sp)
    80003968:	7aa2                	ld	s5,40(sp)
    8000396a:	7b02                	ld	s6,32(sp)
    8000396c:	6be2                	ld	s7,24(sp)
    8000396e:	6c42                	ld	s8,16(sp)
    80003970:	6ca2                	ld	s9,8(sp)
    80003972:	6125                	add	sp,sp,96
    80003974:	8082                	ret
      iunlock(ip);
    80003976:	8552                	mv	a0,s4
    80003978:	a11ff0ef          	jal	80003388 <iunlock>
      return ip;
    8000397c:	bff9                	j	8000395a <namex+0x58>
      iunlockput(ip);
    8000397e:	8552                	mv	a0,s4
    80003980:	b65ff0ef          	jal	800034e4 <iunlockput>
      return 0;
    80003984:	8a4e                	mv	s4,s3
    80003986:	bfd1                	j	8000395a <namex+0x58>
  len = path - s;
    80003988:	40998633          	sub	a2,s3,s1
    8000398c:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80003990:	099c5063          	bge	s8,s9,80003a10 <namex+0x10e>
    memmove(name, s, DIRSIZ);
    80003994:	4639                	li	a2,14
    80003996:	85a6                	mv	a1,s1
    80003998:	8556                	mv	a0,s5
    8000399a:	b0afd0ef          	jal	80000ca4 <memmove>
    8000399e:	84ce                	mv	s1,s3
  while(*path == '/')
    800039a0:	0004c783          	lbu	a5,0(s1)
    800039a4:	01279763          	bne	a5,s2,800039b2 <namex+0xb0>
    path++;
    800039a8:	0485                	add	s1,s1,1
  while(*path == '/')
    800039aa:	0004c783          	lbu	a5,0(s1)
    800039ae:	ff278de3          	beq	a5,s2,800039a8 <namex+0xa6>
    ilock(ip);
    800039b2:	8552                	mv	a0,s4
    800039b4:	92bff0ef          	jal	800032de <ilock>
    if(ip->type != T_DIR){
    800039b8:	044a1783          	lh	a5,68(s4)
    800039bc:	f9779be3          	bne	a5,s7,80003952 <namex+0x50>
    if(nameiparent && *path == '\0'){
    800039c0:	000b0563          	beqz	s6,800039ca <namex+0xc8>
    800039c4:	0004c783          	lbu	a5,0(s1)
    800039c8:	d7dd                	beqz	a5,80003976 <namex+0x74>
    if((next = dirlookup(ip, name, 0)) == 0){
    800039ca:	4601                	li	a2,0
    800039cc:	85d6                	mv	a1,s5
    800039ce:	8552                	mv	a0,s4
    800039d0:	e97ff0ef          	jal	80003866 <dirlookup>
    800039d4:	89aa                	mv	s3,a0
    800039d6:	d545                	beqz	a0,8000397e <namex+0x7c>
    iunlockput(ip);
    800039d8:	8552                	mv	a0,s4
    800039da:	b0bff0ef          	jal	800034e4 <iunlockput>
    ip = next;
    800039de:	8a4e                	mv	s4,s3
  while(*path == '/')
    800039e0:	0004c783          	lbu	a5,0(s1)
    800039e4:	01279763          	bne	a5,s2,800039f2 <namex+0xf0>
    path++;
    800039e8:	0485                	add	s1,s1,1
  while(*path == '/')
    800039ea:	0004c783          	lbu	a5,0(s1)
    800039ee:	ff278de3          	beq	a5,s2,800039e8 <namex+0xe6>
  if(*path == 0)
    800039f2:	cb8d                	beqz	a5,80003a24 <namex+0x122>
  while(*path != '/' && *path != 0)
    800039f4:	0004c783          	lbu	a5,0(s1)
    800039f8:	89a6                	mv	s3,s1
  len = path - s;
    800039fa:	4c81                	li	s9,0
    800039fc:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    800039fe:	01278963          	beq	a5,s2,80003a10 <namex+0x10e>
    80003a02:	d3d9                	beqz	a5,80003988 <namex+0x86>
    path++;
    80003a04:	0985                	add	s3,s3,1
  while(*path != '/' && *path != 0)
    80003a06:	0009c783          	lbu	a5,0(s3)
    80003a0a:	ff279ce3          	bne	a5,s2,80003a02 <namex+0x100>
    80003a0e:	bfad                	j	80003988 <namex+0x86>
    memmove(name, s, len);
    80003a10:	2601                	sext.w	a2,a2
    80003a12:	85a6                	mv	a1,s1
    80003a14:	8556                	mv	a0,s5
    80003a16:	a8efd0ef          	jal	80000ca4 <memmove>
    name[len] = 0;
    80003a1a:	9cd6                	add	s9,s9,s5
    80003a1c:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80003a20:	84ce                	mv	s1,s3
    80003a22:	bfbd                	j	800039a0 <namex+0x9e>
  if(nameiparent){
    80003a24:	f20b0be3          	beqz	s6,8000395a <namex+0x58>
    iput(ip);
    80003a28:	8552                	mv	a0,s4
    80003a2a:	a33ff0ef          	jal	8000345c <iput>
    return 0;
    80003a2e:	4a01                	li	s4,0
    80003a30:	b72d                	j	8000395a <namex+0x58>

0000000080003a32 <dirlink>:
{
    80003a32:	7139                	add	sp,sp,-64
    80003a34:	fc06                	sd	ra,56(sp)
    80003a36:	f822                	sd	s0,48(sp)
    80003a38:	f426                	sd	s1,40(sp)
    80003a3a:	f04a                	sd	s2,32(sp)
    80003a3c:	ec4e                	sd	s3,24(sp)
    80003a3e:	e852                	sd	s4,16(sp)
    80003a40:	0080                	add	s0,sp,64
    80003a42:	892a                	mv	s2,a0
    80003a44:	8a2e                	mv	s4,a1
    80003a46:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003a48:	4601                	li	a2,0
    80003a4a:	e1dff0ef          	jal	80003866 <dirlookup>
    80003a4e:	e52d                	bnez	a0,80003ab8 <dirlink+0x86>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003a50:	04c92483          	lw	s1,76(s2)
    80003a54:	c48d                	beqz	s1,80003a7e <dirlink+0x4c>
    80003a56:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003a58:	4741                	li	a4,16
    80003a5a:	86a6                	mv	a3,s1
    80003a5c:	fc040613          	add	a2,s0,-64
    80003a60:	4581                	li	a1,0
    80003a62:	854a                	mv	a0,s2
    80003a64:	c07ff0ef          	jal	8000366a <readi>
    80003a68:	47c1                	li	a5,16
    80003a6a:	04f51b63          	bne	a0,a5,80003ac0 <dirlink+0x8e>
    if(de.inum == 0)
    80003a6e:	fc045783          	lhu	a5,-64(s0)
    80003a72:	c791                	beqz	a5,80003a7e <dirlink+0x4c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003a74:	24c1                	addw	s1,s1,16
    80003a76:	04c92783          	lw	a5,76(s2)
    80003a7a:	fcf4efe3          	bltu	s1,a5,80003a58 <dirlink+0x26>
  strncpy(de.name, name, DIRSIZ);
    80003a7e:	4639                	li	a2,14
    80003a80:	85d2                	mv	a1,s4
    80003a82:	fc240513          	add	a0,s0,-62
    80003a86:	acafd0ef          	jal	80000d50 <strncpy>
  de.inum = inum;
    80003a8a:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003a8e:	4741                	li	a4,16
    80003a90:	86a6                	mv	a3,s1
    80003a92:	fc040613          	add	a2,s0,-64
    80003a96:	4581                	li	a1,0
    80003a98:	854a                	mv	a0,s2
    80003a9a:	cb5ff0ef          	jal	8000374e <writei>
    80003a9e:	1541                	add	a0,a0,-16
    80003aa0:	00a03533          	snez	a0,a0
    80003aa4:	40a00533          	neg	a0,a0
}
    80003aa8:	70e2                	ld	ra,56(sp)
    80003aaa:	7442                	ld	s0,48(sp)
    80003aac:	74a2                	ld	s1,40(sp)
    80003aae:	7902                	ld	s2,32(sp)
    80003ab0:	69e2                	ld	s3,24(sp)
    80003ab2:	6a42                	ld	s4,16(sp)
    80003ab4:	6121                	add	sp,sp,64
    80003ab6:	8082                	ret
    iput(ip);
    80003ab8:	9a5ff0ef          	jal	8000345c <iput>
    return -1;
    80003abc:	557d                	li	a0,-1
    80003abe:	b7ed                	j	80003aa8 <dirlink+0x76>
      panic("dirlink read");
    80003ac0:	00004517          	auipc	a0,0x4
    80003ac4:	b3050513          	add	a0,a0,-1232 # 800075f0 <syscalls+0x200>
    80003ac8:	cd7fc0ef          	jal	8000079e <panic>

0000000080003acc <namei>:

struct inode*
namei(char *path)
{
    80003acc:	1101                	add	sp,sp,-32
    80003ace:	ec06                	sd	ra,24(sp)
    80003ad0:	e822                	sd	s0,16(sp)
    80003ad2:	1000                	add	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003ad4:	fe040613          	add	a2,s0,-32
    80003ad8:	4581                	li	a1,0
    80003ada:	e29ff0ef          	jal	80003902 <namex>
}
    80003ade:	60e2                	ld	ra,24(sp)
    80003ae0:	6442                	ld	s0,16(sp)
    80003ae2:	6105                	add	sp,sp,32
    80003ae4:	8082                	ret

0000000080003ae6 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003ae6:	1141                	add	sp,sp,-16
    80003ae8:	e406                	sd	ra,8(sp)
    80003aea:	e022                	sd	s0,0(sp)
    80003aec:	0800                	add	s0,sp,16
    80003aee:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003af0:	4585                	li	a1,1
    80003af2:	e11ff0ef          	jal	80003902 <namex>
}
    80003af6:	60a2                	ld	ra,8(sp)
    80003af8:	6402                	ld	s0,0(sp)
    80003afa:	0141                	add	sp,sp,16
    80003afc:	8082                	ret

0000000080003afe <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003afe:	1101                	add	sp,sp,-32
    80003b00:	ec06                	sd	ra,24(sp)
    80003b02:	e822                	sd	s0,16(sp)
    80003b04:	e426                	sd	s1,8(sp)
    80003b06:	e04a                	sd	s2,0(sp)
    80003b08:	1000                	add	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003b0a:	0001c917          	auipc	s2,0x1c
    80003b0e:	0a690913          	add	s2,s2,166 # 8001fbb0 <log>
    80003b12:	01892583          	lw	a1,24(s2)
    80003b16:	02492503          	lw	a0,36(s2)
    80003b1a:	91cff0ef          	jal	80002c36 <bread>
    80003b1e:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003b20:	02892603          	lw	a2,40(s2)
    80003b24:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003b26:	00c05f63          	blez	a2,80003b44 <write_head+0x46>
    80003b2a:	0001c717          	auipc	a4,0x1c
    80003b2e:	0b270713          	add	a4,a4,178 # 8001fbdc <log+0x2c>
    80003b32:	87aa                	mv	a5,a0
    80003b34:	060a                	sll	a2,a2,0x2
    80003b36:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80003b38:	4314                	lw	a3,0(a4)
    80003b3a:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80003b3c:	0711                	add	a4,a4,4
    80003b3e:	0791                	add	a5,a5,4
    80003b40:	fec79ce3          	bne	a5,a2,80003b38 <write_head+0x3a>
  }
  bwrite(buf);
    80003b44:	8526                	mv	a0,s1
    80003b46:	9c6ff0ef          	jal	80002d0c <bwrite>
  brelse(buf);
    80003b4a:	8526                	mv	a0,s1
    80003b4c:	9f2ff0ef          	jal	80002d3e <brelse>
}
    80003b50:	60e2                	ld	ra,24(sp)
    80003b52:	6442                	ld	s0,16(sp)
    80003b54:	64a2                	ld	s1,8(sp)
    80003b56:	6902                	ld	s2,0(sp)
    80003b58:	6105                	add	sp,sp,32
    80003b5a:	8082                	ret

0000000080003b5c <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003b5c:	0001c797          	auipc	a5,0x1c
    80003b60:	07c7a783          	lw	a5,124(a5) # 8001fbd8 <log+0x28>
    80003b64:	0af05e63          	blez	a5,80003c20 <install_trans+0xc4>
{
    80003b68:	715d                	add	sp,sp,-80
    80003b6a:	e486                	sd	ra,72(sp)
    80003b6c:	e0a2                	sd	s0,64(sp)
    80003b6e:	fc26                	sd	s1,56(sp)
    80003b70:	f84a                	sd	s2,48(sp)
    80003b72:	f44e                	sd	s3,40(sp)
    80003b74:	f052                	sd	s4,32(sp)
    80003b76:	ec56                	sd	s5,24(sp)
    80003b78:	e85a                	sd	s6,16(sp)
    80003b7a:	e45e                	sd	s7,8(sp)
    80003b7c:	0880                	add	s0,sp,80
    80003b7e:	8b2a                	mv	s6,a0
    80003b80:	0001ca97          	auipc	s5,0x1c
    80003b84:	05ca8a93          	add	s5,s5,92 # 8001fbdc <log+0x2c>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003b88:	4981                	li	s3,0
      printf("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    80003b8a:	00004b97          	auipc	s7,0x4
    80003b8e:	a76b8b93          	add	s7,s7,-1418 # 80007600 <syscalls+0x210>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003b92:	0001ca17          	auipc	s4,0x1c
    80003b96:	01ea0a13          	add	s4,s4,30 # 8001fbb0 <log>
    80003b9a:	a025                	j	80003bc2 <install_trans+0x66>
      printf("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    80003b9c:	000aa603          	lw	a2,0(s5)
    80003ba0:	85ce                	mv	a1,s3
    80003ba2:	855e                	mv	a0,s7
    80003ba4:	929fc0ef          	jal	800004cc <printf>
    80003ba8:	a839                	j	80003bc6 <install_trans+0x6a>
    brelse(lbuf);
    80003baa:	854a                	mv	a0,s2
    80003bac:	992ff0ef          	jal	80002d3e <brelse>
    brelse(dbuf);
    80003bb0:	8526                	mv	a0,s1
    80003bb2:	98cff0ef          	jal	80002d3e <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003bb6:	2985                	addw	s3,s3,1
    80003bb8:	0a91                	add	s5,s5,4
    80003bba:	028a2783          	lw	a5,40(s4)
    80003bbe:	04f9d663          	bge	s3,a5,80003c0a <install_trans+0xae>
    if(recovering) {
    80003bc2:	fc0b1de3          	bnez	s6,80003b9c <install_trans+0x40>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003bc6:	018a2583          	lw	a1,24(s4)
    80003bca:	013585bb          	addw	a1,a1,s3
    80003bce:	2585                	addw	a1,a1,1
    80003bd0:	024a2503          	lw	a0,36(s4)
    80003bd4:	862ff0ef          	jal	80002c36 <bread>
    80003bd8:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003bda:	000aa583          	lw	a1,0(s5)
    80003bde:	024a2503          	lw	a0,36(s4)
    80003be2:	854ff0ef          	jal	80002c36 <bread>
    80003be6:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003be8:	40000613          	li	a2,1024
    80003bec:	05890593          	add	a1,s2,88
    80003bf0:	05850513          	add	a0,a0,88
    80003bf4:	8b0fd0ef          	jal	80000ca4 <memmove>
    bwrite(dbuf);  // write dst to disk
    80003bf8:	8526                	mv	a0,s1
    80003bfa:	912ff0ef          	jal	80002d0c <bwrite>
    if(recovering == 0)
    80003bfe:	fa0b16e3          	bnez	s6,80003baa <install_trans+0x4e>
      bunpin(dbuf);
    80003c02:	8526                	mv	a0,s1
    80003c04:	9f6ff0ef          	jal	80002dfa <bunpin>
    80003c08:	b74d                	j	80003baa <install_trans+0x4e>
}
    80003c0a:	60a6                	ld	ra,72(sp)
    80003c0c:	6406                	ld	s0,64(sp)
    80003c0e:	74e2                	ld	s1,56(sp)
    80003c10:	7942                	ld	s2,48(sp)
    80003c12:	79a2                	ld	s3,40(sp)
    80003c14:	7a02                	ld	s4,32(sp)
    80003c16:	6ae2                	ld	s5,24(sp)
    80003c18:	6b42                	ld	s6,16(sp)
    80003c1a:	6ba2                	ld	s7,8(sp)
    80003c1c:	6161                	add	sp,sp,80
    80003c1e:	8082                	ret
    80003c20:	8082                	ret

0000000080003c22 <initlog>:
{
    80003c22:	7179                	add	sp,sp,-48
    80003c24:	f406                	sd	ra,40(sp)
    80003c26:	f022                	sd	s0,32(sp)
    80003c28:	ec26                	sd	s1,24(sp)
    80003c2a:	e84a                	sd	s2,16(sp)
    80003c2c:	e44e                	sd	s3,8(sp)
    80003c2e:	1800                	add	s0,sp,48
    80003c30:	892a                	mv	s2,a0
    80003c32:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003c34:	0001c497          	auipc	s1,0x1c
    80003c38:	f7c48493          	add	s1,s1,-132 # 8001fbb0 <log>
    80003c3c:	00004597          	auipc	a1,0x4
    80003c40:	9e458593          	add	a1,a1,-1564 # 80007620 <syscalls+0x230>
    80003c44:	8526                	mv	a0,s1
    80003c46:	eaffc0ef          	jal	80000af4 <initlock>
  log.start = sb->logstart;
    80003c4a:	0149a583          	lw	a1,20(s3)
    80003c4e:	cc8c                	sw	a1,24(s1)
  log.dev = dev;
    80003c50:	0324a223          	sw	s2,36(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003c54:	854a                	mv	a0,s2
    80003c56:	fe1fe0ef          	jal	80002c36 <bread>
  log.lh.n = lh->n;
    80003c5a:	4d30                	lw	a2,88(a0)
    80003c5c:	d490                	sw	a2,40(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003c5e:	00c05f63          	blez	a2,80003c7c <initlog+0x5a>
    80003c62:	87aa                	mv	a5,a0
    80003c64:	0001c717          	auipc	a4,0x1c
    80003c68:	f7870713          	add	a4,a4,-136 # 8001fbdc <log+0x2c>
    80003c6c:	060a                	sll	a2,a2,0x2
    80003c6e:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80003c70:	4ff4                	lw	a3,92(a5)
    80003c72:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003c74:	0791                	add	a5,a5,4
    80003c76:	0711                	add	a4,a4,4
    80003c78:	fec79ce3          	bne	a5,a2,80003c70 <initlog+0x4e>
  brelse(buf);
    80003c7c:	8c2ff0ef          	jal	80002d3e <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003c80:	4505                	li	a0,1
    80003c82:	edbff0ef          	jal	80003b5c <install_trans>
  log.lh.n = 0;
    80003c86:	0001c797          	auipc	a5,0x1c
    80003c8a:	f407a923          	sw	zero,-174(a5) # 8001fbd8 <log+0x28>
  write_head(); // clear the log
    80003c8e:	e71ff0ef          	jal	80003afe <write_head>
}
    80003c92:	70a2                	ld	ra,40(sp)
    80003c94:	7402                	ld	s0,32(sp)
    80003c96:	64e2                	ld	s1,24(sp)
    80003c98:	6942                	ld	s2,16(sp)
    80003c9a:	69a2                	ld	s3,8(sp)
    80003c9c:	6145                	add	sp,sp,48
    80003c9e:	8082                	ret

0000000080003ca0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003ca0:	1101                	add	sp,sp,-32
    80003ca2:	ec06                	sd	ra,24(sp)
    80003ca4:	e822                	sd	s0,16(sp)
    80003ca6:	e426                	sd	s1,8(sp)
    80003ca8:	e04a                	sd	s2,0(sp)
    80003caa:	1000                	add	s0,sp,32
  acquire(&log.lock);
    80003cac:	0001c517          	auipc	a0,0x1c
    80003cb0:	f0450513          	add	a0,a0,-252 # 8001fbb0 <log>
    80003cb4:	ec1fc0ef          	jal	80000b74 <acquire>
  while(1){
    if(log.committing){
    80003cb8:	0001c497          	auipc	s1,0x1c
    80003cbc:	ef848493          	add	s1,s1,-264 # 8001fbb0 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGBLOCKS){
    80003cc0:	4979                	li	s2,30
    80003cc2:	a029                	j	80003ccc <begin_op+0x2c>
      sleep(&log, &log.lock);
    80003cc4:	85a6                	mv	a1,s1
    80003cc6:	8526                	mv	a0,s1
    80003cc8:	9d8fe0ef          	jal	80001ea0 <sleep>
    if(log.committing){
    80003ccc:	509c                	lw	a5,32(s1)
    80003cce:	fbfd                	bnez	a5,80003cc4 <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGBLOCKS){
    80003cd0:	4cd8                	lw	a4,28(s1)
    80003cd2:	2705                	addw	a4,a4,1
    80003cd4:	0027179b          	sllw	a5,a4,0x2
    80003cd8:	9fb9                	addw	a5,a5,a4
    80003cda:	0017979b          	sllw	a5,a5,0x1
    80003cde:	5494                	lw	a3,40(s1)
    80003ce0:	9fb5                	addw	a5,a5,a3
    80003ce2:	00f95763          	bge	s2,a5,80003cf0 <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003ce6:	85a6                	mv	a1,s1
    80003ce8:	8526                	mv	a0,s1
    80003cea:	9b6fe0ef          	jal	80001ea0 <sleep>
    80003cee:	bff9                	j	80003ccc <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    80003cf0:	0001c517          	auipc	a0,0x1c
    80003cf4:	ec050513          	add	a0,a0,-320 # 8001fbb0 <log>
    80003cf8:	cd58                	sw	a4,28(a0)
      release(&log.lock);
    80003cfa:	f13fc0ef          	jal	80000c0c <release>
      break;
    }
  }
}
    80003cfe:	60e2                	ld	ra,24(sp)
    80003d00:	6442                	ld	s0,16(sp)
    80003d02:	64a2                	ld	s1,8(sp)
    80003d04:	6902                	ld	s2,0(sp)
    80003d06:	6105                	add	sp,sp,32
    80003d08:	8082                	ret

0000000080003d0a <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003d0a:	7139                	add	sp,sp,-64
    80003d0c:	fc06                	sd	ra,56(sp)
    80003d0e:	f822                	sd	s0,48(sp)
    80003d10:	f426                	sd	s1,40(sp)
    80003d12:	f04a                	sd	s2,32(sp)
    80003d14:	ec4e                	sd	s3,24(sp)
    80003d16:	e852                	sd	s4,16(sp)
    80003d18:	e456                	sd	s5,8(sp)
    80003d1a:	0080                	add	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003d1c:	0001c497          	auipc	s1,0x1c
    80003d20:	e9448493          	add	s1,s1,-364 # 8001fbb0 <log>
    80003d24:	8526                	mv	a0,s1
    80003d26:	e4ffc0ef          	jal	80000b74 <acquire>
  log.outstanding -= 1;
    80003d2a:	4cdc                	lw	a5,28(s1)
    80003d2c:	37fd                	addw	a5,a5,-1
    80003d2e:	0007891b          	sext.w	s2,a5
    80003d32:	ccdc                	sw	a5,28(s1)
  if(log.committing)
    80003d34:	509c                	lw	a5,32(s1)
    80003d36:	ef9d                	bnez	a5,80003d74 <end_op+0x6a>
    panic("log.committing");
  if(log.outstanding == 0){
    80003d38:	04091463          	bnez	s2,80003d80 <end_op+0x76>
    do_commit = 1;
    log.committing = 1;
    80003d3c:	0001c497          	auipc	s1,0x1c
    80003d40:	e7448493          	add	s1,s1,-396 # 8001fbb0 <log>
    80003d44:	4785                	li	a5,1
    80003d46:	d09c                	sw	a5,32(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003d48:	8526                	mv	a0,s1
    80003d4a:	ec3fc0ef          	jal	80000c0c <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003d4e:	549c                	lw	a5,40(s1)
    80003d50:	04f04b63          	bgtz	a5,80003da6 <end_op+0x9c>
    acquire(&log.lock);
    80003d54:	0001c497          	auipc	s1,0x1c
    80003d58:	e5c48493          	add	s1,s1,-420 # 8001fbb0 <log>
    80003d5c:	8526                	mv	a0,s1
    80003d5e:	e17fc0ef          	jal	80000b74 <acquire>
    log.committing = 0;
    80003d62:	0204a023          	sw	zero,32(s1)
    wakeup(&log);
    80003d66:	8526                	mv	a0,s1
    80003d68:	984fe0ef          	jal	80001eec <wakeup>
    release(&log.lock);
    80003d6c:	8526                	mv	a0,s1
    80003d6e:	e9ffc0ef          	jal	80000c0c <release>
}
    80003d72:	a00d                	j	80003d94 <end_op+0x8a>
    panic("log.committing");
    80003d74:	00004517          	auipc	a0,0x4
    80003d78:	8b450513          	add	a0,a0,-1868 # 80007628 <syscalls+0x238>
    80003d7c:	a23fc0ef          	jal	8000079e <panic>
    wakeup(&log);
    80003d80:	0001c497          	auipc	s1,0x1c
    80003d84:	e3048493          	add	s1,s1,-464 # 8001fbb0 <log>
    80003d88:	8526                	mv	a0,s1
    80003d8a:	962fe0ef          	jal	80001eec <wakeup>
  release(&log.lock);
    80003d8e:	8526                	mv	a0,s1
    80003d90:	e7dfc0ef          	jal	80000c0c <release>
}
    80003d94:	70e2                	ld	ra,56(sp)
    80003d96:	7442                	ld	s0,48(sp)
    80003d98:	74a2                	ld	s1,40(sp)
    80003d9a:	7902                	ld	s2,32(sp)
    80003d9c:	69e2                	ld	s3,24(sp)
    80003d9e:	6a42                	ld	s4,16(sp)
    80003da0:	6aa2                	ld	s5,8(sp)
    80003da2:	6121                	add	sp,sp,64
    80003da4:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    80003da6:	0001ca97          	auipc	s5,0x1c
    80003daa:	e36a8a93          	add	s5,s5,-458 # 8001fbdc <log+0x2c>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003dae:	0001ca17          	auipc	s4,0x1c
    80003db2:	e02a0a13          	add	s4,s4,-510 # 8001fbb0 <log>
    80003db6:	018a2583          	lw	a1,24(s4)
    80003dba:	012585bb          	addw	a1,a1,s2
    80003dbe:	2585                	addw	a1,a1,1
    80003dc0:	024a2503          	lw	a0,36(s4)
    80003dc4:	e73fe0ef          	jal	80002c36 <bread>
    80003dc8:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003dca:	000aa583          	lw	a1,0(s5)
    80003dce:	024a2503          	lw	a0,36(s4)
    80003dd2:	e65fe0ef          	jal	80002c36 <bread>
    80003dd6:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003dd8:	40000613          	li	a2,1024
    80003ddc:	05850593          	add	a1,a0,88
    80003de0:	05848513          	add	a0,s1,88
    80003de4:	ec1fc0ef          	jal	80000ca4 <memmove>
    bwrite(to);  // write the log
    80003de8:	8526                	mv	a0,s1
    80003dea:	f23fe0ef          	jal	80002d0c <bwrite>
    brelse(from);
    80003dee:	854e                	mv	a0,s3
    80003df0:	f4ffe0ef          	jal	80002d3e <brelse>
    brelse(to);
    80003df4:	8526                	mv	a0,s1
    80003df6:	f49fe0ef          	jal	80002d3e <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003dfa:	2905                	addw	s2,s2,1
    80003dfc:	0a91                	add	s5,s5,4
    80003dfe:	028a2783          	lw	a5,40(s4)
    80003e02:	faf94ae3          	blt	s2,a5,80003db6 <end_op+0xac>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003e06:	cf9ff0ef          	jal	80003afe <write_head>
    install_trans(0); // Now install writes to home locations
    80003e0a:	4501                	li	a0,0
    80003e0c:	d51ff0ef          	jal	80003b5c <install_trans>
    log.lh.n = 0;
    80003e10:	0001c797          	auipc	a5,0x1c
    80003e14:	dc07a423          	sw	zero,-568(a5) # 8001fbd8 <log+0x28>
    write_head();    // Erase the transaction from the log
    80003e18:	ce7ff0ef          	jal	80003afe <write_head>
    80003e1c:	bf25                	j	80003d54 <end_op+0x4a>

0000000080003e1e <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003e1e:	1101                	add	sp,sp,-32
    80003e20:	ec06                	sd	ra,24(sp)
    80003e22:	e822                	sd	s0,16(sp)
    80003e24:	e426                	sd	s1,8(sp)
    80003e26:	e04a                	sd	s2,0(sp)
    80003e28:	1000                	add	s0,sp,32
    80003e2a:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003e2c:	0001c917          	auipc	s2,0x1c
    80003e30:	d8490913          	add	s2,s2,-636 # 8001fbb0 <log>
    80003e34:	854a                	mv	a0,s2
    80003e36:	d3ffc0ef          	jal	80000b74 <acquire>
  if (log.lh.n >= LOGBLOCKS)
    80003e3a:	02892603          	lw	a2,40(s2)
    80003e3e:	47f5                	li	a5,29
    80003e40:	04c7cc63          	blt	a5,a2,80003e98 <log_write+0x7a>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003e44:	0001c797          	auipc	a5,0x1c
    80003e48:	d887a783          	lw	a5,-632(a5) # 8001fbcc <log+0x1c>
    80003e4c:	04f05c63          	blez	a5,80003ea4 <log_write+0x86>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003e50:	4781                	li	a5,0
    80003e52:	04c05f63          	blez	a2,80003eb0 <log_write+0x92>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003e56:	44cc                	lw	a1,12(s1)
    80003e58:	0001c717          	auipc	a4,0x1c
    80003e5c:	d8470713          	add	a4,a4,-636 # 8001fbdc <log+0x2c>
  for (i = 0; i < log.lh.n; i++) {
    80003e60:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003e62:	4314                	lw	a3,0(a4)
    80003e64:	04b68663          	beq	a3,a1,80003eb0 <log_write+0x92>
  for (i = 0; i < log.lh.n; i++) {
    80003e68:	2785                	addw	a5,a5,1
    80003e6a:	0711                	add	a4,a4,4
    80003e6c:	fef61be3          	bne	a2,a5,80003e62 <log_write+0x44>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003e70:	0621                	add	a2,a2,8
    80003e72:	060a                	sll	a2,a2,0x2
    80003e74:	0001c797          	auipc	a5,0x1c
    80003e78:	d3c78793          	add	a5,a5,-708 # 8001fbb0 <log>
    80003e7c:	97b2                	add	a5,a5,a2
    80003e7e:	44d8                	lw	a4,12(s1)
    80003e80:	c7d8                	sw	a4,12(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003e82:	8526                	mv	a0,s1
    80003e84:	f43fe0ef          	jal	80002dc6 <bpin>
    log.lh.n++;
    80003e88:	0001c717          	auipc	a4,0x1c
    80003e8c:	d2870713          	add	a4,a4,-728 # 8001fbb0 <log>
    80003e90:	571c                	lw	a5,40(a4)
    80003e92:	2785                	addw	a5,a5,1
    80003e94:	d71c                	sw	a5,40(a4)
    80003e96:	a80d                	j	80003ec8 <log_write+0xaa>
    panic("too big a transaction");
    80003e98:	00003517          	auipc	a0,0x3
    80003e9c:	7a050513          	add	a0,a0,1952 # 80007638 <syscalls+0x248>
    80003ea0:	8fffc0ef          	jal	8000079e <panic>
    panic("log_write outside of trans");
    80003ea4:	00003517          	auipc	a0,0x3
    80003ea8:	7ac50513          	add	a0,a0,1964 # 80007650 <syscalls+0x260>
    80003eac:	8f3fc0ef          	jal	8000079e <panic>
  log.lh.block[i] = b->blockno;
    80003eb0:	00878693          	add	a3,a5,8
    80003eb4:	068a                	sll	a3,a3,0x2
    80003eb6:	0001c717          	auipc	a4,0x1c
    80003eba:	cfa70713          	add	a4,a4,-774 # 8001fbb0 <log>
    80003ebe:	9736                	add	a4,a4,a3
    80003ec0:	44d4                	lw	a3,12(s1)
    80003ec2:	c754                	sw	a3,12(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003ec4:	faf60fe3          	beq	a2,a5,80003e82 <log_write+0x64>
  }
  release(&log.lock);
    80003ec8:	0001c517          	auipc	a0,0x1c
    80003ecc:	ce850513          	add	a0,a0,-792 # 8001fbb0 <log>
    80003ed0:	d3dfc0ef          	jal	80000c0c <release>
}
    80003ed4:	60e2                	ld	ra,24(sp)
    80003ed6:	6442                	ld	s0,16(sp)
    80003ed8:	64a2                	ld	s1,8(sp)
    80003eda:	6902                	ld	s2,0(sp)
    80003edc:	6105                	add	sp,sp,32
    80003ede:	8082                	ret

0000000080003ee0 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003ee0:	1101                	add	sp,sp,-32
    80003ee2:	ec06                	sd	ra,24(sp)
    80003ee4:	e822                	sd	s0,16(sp)
    80003ee6:	e426                	sd	s1,8(sp)
    80003ee8:	e04a                	sd	s2,0(sp)
    80003eea:	1000                	add	s0,sp,32
    80003eec:	84aa                	mv	s1,a0
    80003eee:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003ef0:	00003597          	auipc	a1,0x3
    80003ef4:	78058593          	add	a1,a1,1920 # 80007670 <syscalls+0x280>
    80003ef8:	0521                	add	a0,a0,8
    80003efa:	bfbfc0ef          	jal	80000af4 <initlock>
  lk->name = name;
    80003efe:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003f02:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003f06:	0204a423          	sw	zero,40(s1)
}
    80003f0a:	60e2                	ld	ra,24(sp)
    80003f0c:	6442                	ld	s0,16(sp)
    80003f0e:	64a2                	ld	s1,8(sp)
    80003f10:	6902                	ld	s2,0(sp)
    80003f12:	6105                	add	sp,sp,32
    80003f14:	8082                	ret

0000000080003f16 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003f16:	1101                	add	sp,sp,-32
    80003f18:	ec06                	sd	ra,24(sp)
    80003f1a:	e822                	sd	s0,16(sp)
    80003f1c:	e426                	sd	s1,8(sp)
    80003f1e:	e04a                	sd	s2,0(sp)
    80003f20:	1000                	add	s0,sp,32
    80003f22:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003f24:	00850913          	add	s2,a0,8
    80003f28:	854a                	mv	a0,s2
    80003f2a:	c4bfc0ef          	jal	80000b74 <acquire>
  while (lk->locked) {
    80003f2e:	409c                	lw	a5,0(s1)
    80003f30:	c799                	beqz	a5,80003f3e <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    80003f32:	85ca                	mv	a1,s2
    80003f34:	8526                	mv	a0,s1
    80003f36:	f6bfd0ef          	jal	80001ea0 <sleep>
  while (lk->locked) {
    80003f3a:	409c                	lw	a5,0(s1)
    80003f3c:	fbfd                	bnez	a5,80003f32 <acquiresleep+0x1c>
  }
  lk->locked = 1;
    80003f3e:	4785                	li	a5,1
    80003f40:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003f42:	8c9fd0ef          	jal	8000180a <myproc>
    80003f46:	591c                	lw	a5,48(a0)
    80003f48:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003f4a:	854a                	mv	a0,s2
    80003f4c:	cc1fc0ef          	jal	80000c0c <release>
}
    80003f50:	60e2                	ld	ra,24(sp)
    80003f52:	6442                	ld	s0,16(sp)
    80003f54:	64a2                	ld	s1,8(sp)
    80003f56:	6902                	ld	s2,0(sp)
    80003f58:	6105                	add	sp,sp,32
    80003f5a:	8082                	ret

0000000080003f5c <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003f5c:	1101                	add	sp,sp,-32
    80003f5e:	ec06                	sd	ra,24(sp)
    80003f60:	e822                	sd	s0,16(sp)
    80003f62:	e426                	sd	s1,8(sp)
    80003f64:	e04a                	sd	s2,0(sp)
    80003f66:	1000                	add	s0,sp,32
    80003f68:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003f6a:	00850913          	add	s2,a0,8
    80003f6e:	854a                	mv	a0,s2
    80003f70:	c05fc0ef          	jal	80000b74 <acquire>
  lk->locked = 0;
    80003f74:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003f78:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003f7c:	8526                	mv	a0,s1
    80003f7e:	f6ffd0ef          	jal	80001eec <wakeup>
  release(&lk->lk);
    80003f82:	854a                	mv	a0,s2
    80003f84:	c89fc0ef          	jal	80000c0c <release>
}
    80003f88:	60e2                	ld	ra,24(sp)
    80003f8a:	6442                	ld	s0,16(sp)
    80003f8c:	64a2                	ld	s1,8(sp)
    80003f8e:	6902                	ld	s2,0(sp)
    80003f90:	6105                	add	sp,sp,32
    80003f92:	8082                	ret

0000000080003f94 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003f94:	7179                	add	sp,sp,-48
    80003f96:	f406                	sd	ra,40(sp)
    80003f98:	f022                	sd	s0,32(sp)
    80003f9a:	ec26                	sd	s1,24(sp)
    80003f9c:	e84a                	sd	s2,16(sp)
    80003f9e:	e44e                	sd	s3,8(sp)
    80003fa0:	1800                	add	s0,sp,48
    80003fa2:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003fa4:	00850913          	add	s2,a0,8
    80003fa8:	854a                	mv	a0,s2
    80003faa:	bcbfc0ef          	jal	80000b74 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003fae:	409c                	lw	a5,0(s1)
    80003fb0:	ef89                	bnez	a5,80003fca <holdingsleep+0x36>
    80003fb2:	4481                	li	s1,0
  release(&lk->lk);
    80003fb4:	854a                	mv	a0,s2
    80003fb6:	c57fc0ef          	jal	80000c0c <release>
  return r;
}
    80003fba:	8526                	mv	a0,s1
    80003fbc:	70a2                	ld	ra,40(sp)
    80003fbe:	7402                	ld	s0,32(sp)
    80003fc0:	64e2                	ld	s1,24(sp)
    80003fc2:	6942                	ld	s2,16(sp)
    80003fc4:	69a2                	ld	s3,8(sp)
    80003fc6:	6145                	add	sp,sp,48
    80003fc8:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003fca:	0284a983          	lw	s3,40(s1)
    80003fce:	83dfd0ef          	jal	8000180a <myproc>
    80003fd2:	5904                	lw	s1,48(a0)
    80003fd4:	413484b3          	sub	s1,s1,s3
    80003fd8:	0014b493          	seqz	s1,s1
    80003fdc:	bfe1                	j	80003fb4 <holdingsleep+0x20>

0000000080003fde <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003fde:	1141                	add	sp,sp,-16
    80003fe0:	e406                	sd	ra,8(sp)
    80003fe2:	e022                	sd	s0,0(sp)
    80003fe4:	0800                	add	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003fe6:	00003597          	auipc	a1,0x3
    80003fea:	69a58593          	add	a1,a1,1690 # 80007680 <syscalls+0x290>
    80003fee:	0001c517          	auipc	a0,0x1c
    80003ff2:	d0a50513          	add	a0,a0,-758 # 8001fcf8 <ftable>
    80003ff6:	afffc0ef          	jal	80000af4 <initlock>
}
    80003ffa:	60a2                	ld	ra,8(sp)
    80003ffc:	6402                	ld	s0,0(sp)
    80003ffe:	0141                	add	sp,sp,16
    80004000:	8082                	ret

0000000080004002 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80004002:	1101                	add	sp,sp,-32
    80004004:	ec06                	sd	ra,24(sp)
    80004006:	e822                	sd	s0,16(sp)
    80004008:	e426                	sd	s1,8(sp)
    8000400a:	1000                	add	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    8000400c:	0001c517          	auipc	a0,0x1c
    80004010:	cec50513          	add	a0,a0,-788 # 8001fcf8 <ftable>
    80004014:	b61fc0ef          	jal	80000b74 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004018:	0001c497          	auipc	s1,0x1c
    8000401c:	cf848493          	add	s1,s1,-776 # 8001fd10 <ftable+0x18>
    80004020:	0001d717          	auipc	a4,0x1d
    80004024:	c9070713          	add	a4,a4,-880 # 80020cb0 <disk>
    if(f->ref == 0){
    80004028:	40dc                	lw	a5,4(s1)
    8000402a:	cf89                	beqz	a5,80004044 <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000402c:	02848493          	add	s1,s1,40
    80004030:	fee49ce3          	bne	s1,a4,80004028 <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80004034:	0001c517          	auipc	a0,0x1c
    80004038:	cc450513          	add	a0,a0,-828 # 8001fcf8 <ftable>
    8000403c:	bd1fc0ef          	jal	80000c0c <release>
  return 0;
    80004040:	4481                	li	s1,0
    80004042:	a809                	j	80004054 <filealloc+0x52>
      f->ref = 1;
    80004044:	4785                	li	a5,1
    80004046:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80004048:	0001c517          	auipc	a0,0x1c
    8000404c:	cb050513          	add	a0,a0,-848 # 8001fcf8 <ftable>
    80004050:	bbdfc0ef          	jal	80000c0c <release>
}
    80004054:	8526                	mv	a0,s1
    80004056:	60e2                	ld	ra,24(sp)
    80004058:	6442                	ld	s0,16(sp)
    8000405a:	64a2                	ld	s1,8(sp)
    8000405c:	6105                	add	sp,sp,32
    8000405e:	8082                	ret

0000000080004060 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80004060:	1101                	add	sp,sp,-32
    80004062:	ec06                	sd	ra,24(sp)
    80004064:	e822                	sd	s0,16(sp)
    80004066:	e426                	sd	s1,8(sp)
    80004068:	1000                	add	s0,sp,32
    8000406a:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    8000406c:	0001c517          	auipc	a0,0x1c
    80004070:	c8c50513          	add	a0,a0,-884 # 8001fcf8 <ftable>
    80004074:	b01fc0ef          	jal	80000b74 <acquire>
  if(f->ref < 1)
    80004078:	40dc                	lw	a5,4(s1)
    8000407a:	02f05063          	blez	a5,8000409a <filedup+0x3a>
    panic("filedup");
  f->ref++;
    8000407e:	2785                	addw	a5,a5,1
    80004080:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80004082:	0001c517          	auipc	a0,0x1c
    80004086:	c7650513          	add	a0,a0,-906 # 8001fcf8 <ftable>
    8000408a:	b83fc0ef          	jal	80000c0c <release>
  return f;
}
    8000408e:	8526                	mv	a0,s1
    80004090:	60e2                	ld	ra,24(sp)
    80004092:	6442                	ld	s0,16(sp)
    80004094:	64a2                	ld	s1,8(sp)
    80004096:	6105                	add	sp,sp,32
    80004098:	8082                	ret
    panic("filedup");
    8000409a:	00003517          	auipc	a0,0x3
    8000409e:	5ee50513          	add	a0,a0,1518 # 80007688 <syscalls+0x298>
    800040a2:	efcfc0ef          	jal	8000079e <panic>

00000000800040a6 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    800040a6:	7139                	add	sp,sp,-64
    800040a8:	fc06                	sd	ra,56(sp)
    800040aa:	f822                	sd	s0,48(sp)
    800040ac:	f426                	sd	s1,40(sp)
    800040ae:	f04a                	sd	s2,32(sp)
    800040b0:	ec4e                	sd	s3,24(sp)
    800040b2:	e852                	sd	s4,16(sp)
    800040b4:	e456                	sd	s5,8(sp)
    800040b6:	0080                	add	s0,sp,64
    800040b8:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    800040ba:	0001c517          	auipc	a0,0x1c
    800040be:	c3e50513          	add	a0,a0,-962 # 8001fcf8 <ftable>
    800040c2:	ab3fc0ef          	jal	80000b74 <acquire>
  if(f->ref < 1)
    800040c6:	40dc                	lw	a5,4(s1)
    800040c8:	04f05963          	blez	a5,8000411a <fileclose+0x74>
    panic("fileclose");
  if(--f->ref > 0){
    800040cc:	37fd                	addw	a5,a5,-1
    800040ce:	0007871b          	sext.w	a4,a5
    800040d2:	c0dc                	sw	a5,4(s1)
    800040d4:	04e04963          	bgtz	a4,80004126 <fileclose+0x80>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    800040d8:	0004a903          	lw	s2,0(s1)
    800040dc:	0094ca83          	lbu	s5,9(s1)
    800040e0:	0104ba03          	ld	s4,16(s1)
    800040e4:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    800040e8:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    800040ec:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    800040f0:	0001c517          	auipc	a0,0x1c
    800040f4:	c0850513          	add	a0,a0,-1016 # 8001fcf8 <ftable>
    800040f8:	b15fc0ef          	jal	80000c0c <release>

  if(ff.type == FD_PIPE){
    800040fc:	4785                	li	a5,1
    800040fe:	04f90363          	beq	s2,a5,80004144 <fileclose+0x9e>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80004102:	3979                	addw	s2,s2,-2
    80004104:	4785                	li	a5,1
    80004106:	0327e663          	bltu	a5,s2,80004132 <fileclose+0x8c>
    begin_op();
    8000410a:	b97ff0ef          	jal	80003ca0 <begin_op>
    iput(ff.ip);
    8000410e:	854e                	mv	a0,s3
    80004110:	b4cff0ef          	jal	8000345c <iput>
    end_op();
    80004114:	bf7ff0ef          	jal	80003d0a <end_op>
    80004118:	a829                	j	80004132 <fileclose+0x8c>
    panic("fileclose");
    8000411a:	00003517          	auipc	a0,0x3
    8000411e:	57650513          	add	a0,a0,1398 # 80007690 <syscalls+0x2a0>
    80004122:	e7cfc0ef          	jal	8000079e <panic>
    release(&ftable.lock);
    80004126:	0001c517          	auipc	a0,0x1c
    8000412a:	bd250513          	add	a0,a0,-1070 # 8001fcf8 <ftable>
    8000412e:	adffc0ef          	jal	80000c0c <release>
  }
}
    80004132:	70e2                	ld	ra,56(sp)
    80004134:	7442                	ld	s0,48(sp)
    80004136:	74a2                	ld	s1,40(sp)
    80004138:	7902                	ld	s2,32(sp)
    8000413a:	69e2                	ld	s3,24(sp)
    8000413c:	6a42                	ld	s4,16(sp)
    8000413e:	6aa2                	ld	s5,8(sp)
    80004140:	6121                	add	sp,sp,64
    80004142:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80004144:	85d6                	mv	a1,s5
    80004146:	8552                	mv	a0,s4
    80004148:	2e8000ef          	jal	80004430 <pipeclose>
    8000414c:	b7dd                	j	80004132 <fileclose+0x8c>

000000008000414e <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    8000414e:	715d                	add	sp,sp,-80
    80004150:	e486                	sd	ra,72(sp)
    80004152:	e0a2                	sd	s0,64(sp)
    80004154:	fc26                	sd	s1,56(sp)
    80004156:	f84a                	sd	s2,48(sp)
    80004158:	f44e                	sd	s3,40(sp)
    8000415a:	0880                	add	s0,sp,80
    8000415c:	84aa                	mv	s1,a0
    8000415e:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80004160:	eaafd0ef          	jal	8000180a <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80004164:	409c                	lw	a5,0(s1)
    80004166:	37f9                	addw	a5,a5,-2
    80004168:	4705                	li	a4,1
    8000416a:	02f76f63          	bltu	a4,a5,800041a8 <filestat+0x5a>
    8000416e:	892a                	mv	s2,a0
    ilock(f->ip);
    80004170:	6c88                	ld	a0,24(s1)
    80004172:	96cff0ef          	jal	800032de <ilock>
    stati(f->ip, &st);
    80004176:	fb840593          	add	a1,s0,-72
    8000417a:	6c88                	ld	a0,24(s1)
    8000417c:	cc4ff0ef          	jal	80003640 <stati>
    iunlock(f->ip);
    80004180:	6c88                	ld	a0,24(s1)
    80004182:	a06ff0ef          	jal	80003388 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80004186:	46e1                	li	a3,24
    80004188:	fb840613          	add	a2,s0,-72
    8000418c:	85ce                	mv	a1,s3
    8000418e:	05093503          	ld	a0,80(s2)
    80004192:	bc6fd0ef          	jal	80001558 <copyout>
    80004196:	41f5551b          	sraw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    8000419a:	60a6                	ld	ra,72(sp)
    8000419c:	6406                	ld	s0,64(sp)
    8000419e:	74e2                	ld	s1,56(sp)
    800041a0:	7942                	ld	s2,48(sp)
    800041a2:	79a2                	ld	s3,40(sp)
    800041a4:	6161                	add	sp,sp,80
    800041a6:	8082                	ret
  return -1;
    800041a8:	557d                	li	a0,-1
    800041aa:	bfc5                	j	8000419a <filestat+0x4c>

00000000800041ac <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    800041ac:	7179                	add	sp,sp,-48
    800041ae:	f406                	sd	ra,40(sp)
    800041b0:	f022                	sd	s0,32(sp)
    800041b2:	ec26                	sd	s1,24(sp)
    800041b4:	e84a                	sd	s2,16(sp)
    800041b6:	e44e                	sd	s3,8(sp)
    800041b8:	1800                	add	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    800041ba:	00854783          	lbu	a5,8(a0)
    800041be:	cbc1                	beqz	a5,8000424e <fileread+0xa2>
    800041c0:	84aa                	mv	s1,a0
    800041c2:	89ae                	mv	s3,a1
    800041c4:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    800041c6:	411c                	lw	a5,0(a0)
    800041c8:	4705                	li	a4,1
    800041ca:	04e78363          	beq	a5,a4,80004210 <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800041ce:	470d                	li	a4,3
    800041d0:	04e78563          	beq	a5,a4,8000421a <fileread+0x6e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    800041d4:	4709                	li	a4,2
    800041d6:	06e79663          	bne	a5,a4,80004242 <fileread+0x96>
    ilock(f->ip);
    800041da:	6d08                	ld	a0,24(a0)
    800041dc:	902ff0ef          	jal	800032de <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    800041e0:	874a                	mv	a4,s2
    800041e2:	5094                	lw	a3,32(s1)
    800041e4:	864e                	mv	a2,s3
    800041e6:	4585                	li	a1,1
    800041e8:	6c88                	ld	a0,24(s1)
    800041ea:	c80ff0ef          	jal	8000366a <readi>
    800041ee:	892a                	mv	s2,a0
    800041f0:	00a05563          	blez	a0,800041fa <fileread+0x4e>
      f->off += r;
    800041f4:	509c                	lw	a5,32(s1)
    800041f6:	9fa9                	addw	a5,a5,a0
    800041f8:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    800041fa:	6c88                	ld	a0,24(s1)
    800041fc:	98cff0ef          	jal	80003388 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80004200:	854a                	mv	a0,s2
    80004202:	70a2                	ld	ra,40(sp)
    80004204:	7402                	ld	s0,32(sp)
    80004206:	64e2                	ld	s1,24(sp)
    80004208:	6942                	ld	s2,16(sp)
    8000420a:	69a2                	ld	s3,8(sp)
    8000420c:	6145                	add	sp,sp,48
    8000420e:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004210:	6908                	ld	a0,16(a0)
    80004212:	34a000ef          	jal	8000455c <piperead>
    80004216:	892a                	mv	s2,a0
    80004218:	b7e5                	j	80004200 <fileread+0x54>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    8000421a:	02451783          	lh	a5,36(a0)
    8000421e:	03079693          	sll	a3,a5,0x30
    80004222:	92c1                	srl	a3,a3,0x30
    80004224:	4725                	li	a4,9
    80004226:	02d76663          	bltu	a4,a3,80004252 <fileread+0xa6>
    8000422a:	0792                	sll	a5,a5,0x4
    8000422c:	0001c717          	auipc	a4,0x1c
    80004230:	a2c70713          	add	a4,a4,-1492 # 8001fc58 <devsw>
    80004234:	97ba                	add	a5,a5,a4
    80004236:	639c                	ld	a5,0(a5)
    80004238:	cf99                	beqz	a5,80004256 <fileread+0xaa>
    r = devsw[f->major].read(1, addr, n);
    8000423a:	4505                	li	a0,1
    8000423c:	9782                	jalr	a5
    8000423e:	892a                	mv	s2,a0
    80004240:	b7c1                	j	80004200 <fileread+0x54>
    panic("fileread");
    80004242:	00003517          	auipc	a0,0x3
    80004246:	45e50513          	add	a0,a0,1118 # 800076a0 <syscalls+0x2b0>
    8000424a:	d54fc0ef          	jal	8000079e <panic>
    return -1;
    8000424e:	597d                	li	s2,-1
    80004250:	bf45                	j	80004200 <fileread+0x54>
      return -1;
    80004252:	597d                	li	s2,-1
    80004254:	b775                	j	80004200 <fileread+0x54>
    80004256:	597d                	li	s2,-1
    80004258:	b765                	j	80004200 <fileread+0x54>

000000008000425a <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    8000425a:	00954783          	lbu	a5,9(a0)
    8000425e:	10078063          	beqz	a5,8000435e <filewrite+0x104>
{
    80004262:	715d                	add	sp,sp,-80
    80004264:	e486                	sd	ra,72(sp)
    80004266:	e0a2                	sd	s0,64(sp)
    80004268:	fc26                	sd	s1,56(sp)
    8000426a:	f84a                	sd	s2,48(sp)
    8000426c:	f44e                	sd	s3,40(sp)
    8000426e:	f052                	sd	s4,32(sp)
    80004270:	ec56                	sd	s5,24(sp)
    80004272:	e85a                	sd	s6,16(sp)
    80004274:	e45e                	sd	s7,8(sp)
    80004276:	e062                	sd	s8,0(sp)
    80004278:	0880                	add	s0,sp,80
    8000427a:	892a                	mv	s2,a0
    8000427c:	8b2e                	mv	s6,a1
    8000427e:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80004280:	411c                	lw	a5,0(a0)
    80004282:	4705                	li	a4,1
    80004284:	02e78263          	beq	a5,a4,800042a8 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004288:	470d                	li	a4,3
    8000428a:	02e78363          	beq	a5,a4,800042b0 <filewrite+0x56>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    8000428e:	4709                	li	a4,2
    80004290:	0ce79163          	bne	a5,a4,80004352 <filewrite+0xf8>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80004294:	08c05f63          	blez	a2,80004332 <filewrite+0xd8>
    int i = 0;
    80004298:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    8000429a:	6b85                	lui	s7,0x1
    8000429c:	c00b8b93          	add	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    800042a0:	6c05                	lui	s8,0x1
    800042a2:	c00c0c1b          	addw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    800042a6:	a8b5                	j	80004322 <filewrite+0xc8>
    ret = pipewrite(f->pipe, addr, n);
    800042a8:	6908                	ld	a0,16(a0)
    800042aa:	1de000ef          	jal	80004488 <pipewrite>
    800042ae:	a071                	j	8000433a <filewrite+0xe0>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    800042b0:	02451783          	lh	a5,36(a0)
    800042b4:	03079693          	sll	a3,a5,0x30
    800042b8:	92c1                	srl	a3,a3,0x30
    800042ba:	4725                	li	a4,9
    800042bc:	0ad76363          	bltu	a4,a3,80004362 <filewrite+0x108>
    800042c0:	0792                	sll	a5,a5,0x4
    800042c2:	0001c717          	auipc	a4,0x1c
    800042c6:	99670713          	add	a4,a4,-1642 # 8001fc58 <devsw>
    800042ca:	97ba                	add	a5,a5,a4
    800042cc:	679c                	ld	a5,8(a5)
    800042ce:	cfc1                	beqz	a5,80004366 <filewrite+0x10c>
    ret = devsw[f->major].write(1, addr, n);
    800042d0:	4505                	li	a0,1
    800042d2:	9782                	jalr	a5
    800042d4:	a09d                	j	8000433a <filewrite+0xe0>
      if(n1 > max)
    800042d6:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    800042da:	9c7ff0ef          	jal	80003ca0 <begin_op>
      ilock(f->ip);
    800042de:	01893503          	ld	a0,24(s2)
    800042e2:	ffdfe0ef          	jal	800032de <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    800042e6:	8756                	mv	a4,s5
    800042e8:	02092683          	lw	a3,32(s2)
    800042ec:	01698633          	add	a2,s3,s6
    800042f0:	4585                	li	a1,1
    800042f2:	01893503          	ld	a0,24(s2)
    800042f6:	c58ff0ef          	jal	8000374e <writei>
    800042fa:	84aa                	mv	s1,a0
    800042fc:	00a05763          	blez	a0,8000430a <filewrite+0xb0>
        f->off += r;
    80004300:	02092783          	lw	a5,32(s2)
    80004304:	9fa9                	addw	a5,a5,a0
    80004306:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    8000430a:	01893503          	ld	a0,24(s2)
    8000430e:	87aff0ef          	jal	80003388 <iunlock>
      end_op();
    80004312:	9f9ff0ef          	jal	80003d0a <end_op>

      if(r != n1){
    80004316:	009a9f63          	bne	s5,s1,80004334 <filewrite+0xda>
        // error from writei
        break;
      }
      i += r;
    8000431a:	013489bb          	addw	s3,s1,s3
    while(i < n){
    8000431e:	0149db63          	bge	s3,s4,80004334 <filewrite+0xda>
      int n1 = n - i;
    80004322:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    80004326:	0004879b          	sext.w	a5,s1
    8000432a:	fafbd6e3          	bge	s7,a5,800042d6 <filewrite+0x7c>
    8000432e:	84e2                	mv	s1,s8
    80004330:	b75d                	j	800042d6 <filewrite+0x7c>
    int i = 0;
    80004332:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80004334:	033a1b63          	bne	s4,s3,8000436a <filewrite+0x110>
    80004338:	8552                	mv	a0,s4
  } else {
    panic("filewrite");
  }

  return ret;
}
    8000433a:	60a6                	ld	ra,72(sp)
    8000433c:	6406                	ld	s0,64(sp)
    8000433e:	74e2                	ld	s1,56(sp)
    80004340:	7942                	ld	s2,48(sp)
    80004342:	79a2                	ld	s3,40(sp)
    80004344:	7a02                	ld	s4,32(sp)
    80004346:	6ae2                	ld	s5,24(sp)
    80004348:	6b42                	ld	s6,16(sp)
    8000434a:	6ba2                	ld	s7,8(sp)
    8000434c:	6c02                	ld	s8,0(sp)
    8000434e:	6161                	add	sp,sp,80
    80004350:	8082                	ret
    panic("filewrite");
    80004352:	00003517          	auipc	a0,0x3
    80004356:	35e50513          	add	a0,a0,862 # 800076b0 <syscalls+0x2c0>
    8000435a:	c44fc0ef          	jal	8000079e <panic>
    return -1;
    8000435e:	557d                	li	a0,-1
}
    80004360:	8082                	ret
      return -1;
    80004362:	557d                	li	a0,-1
    80004364:	bfd9                	j	8000433a <filewrite+0xe0>
    80004366:	557d                	li	a0,-1
    80004368:	bfc9                	j	8000433a <filewrite+0xe0>
    ret = (i == n ? n : -1);
    8000436a:	557d                	li	a0,-1
    8000436c:	b7f9                	j	8000433a <filewrite+0xe0>

000000008000436e <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    8000436e:	7179                	add	sp,sp,-48
    80004370:	f406                	sd	ra,40(sp)
    80004372:	f022                	sd	s0,32(sp)
    80004374:	ec26                	sd	s1,24(sp)
    80004376:	e84a                	sd	s2,16(sp)
    80004378:	e44e                	sd	s3,8(sp)
    8000437a:	e052                	sd	s4,0(sp)
    8000437c:	1800                	add	s0,sp,48
    8000437e:	84aa                	mv	s1,a0
    80004380:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80004382:	0005b023          	sd	zero,0(a1)
    80004386:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    8000438a:	c79ff0ef          	jal	80004002 <filealloc>
    8000438e:	e088                	sd	a0,0(s1)
    80004390:	cd35                	beqz	a0,8000440c <pipealloc+0x9e>
    80004392:	c71ff0ef          	jal	80004002 <filealloc>
    80004396:	00aa3023          	sd	a0,0(s4)
    8000439a:	c52d                	beqz	a0,80004404 <pipealloc+0x96>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    8000439c:	f08fc0ef          	jal	80000aa4 <kalloc>
    800043a0:	892a                	mv	s2,a0
    800043a2:	cd31                	beqz	a0,800043fe <pipealloc+0x90>
    goto bad;
  pi->readopen = 1;
    800043a4:	4985                	li	s3,1
    800043a6:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    800043aa:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    800043ae:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    800043b2:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    800043b6:	00003597          	auipc	a1,0x3
    800043ba:	30a58593          	add	a1,a1,778 # 800076c0 <syscalls+0x2d0>
    800043be:	f36fc0ef          	jal	80000af4 <initlock>
  (*f0)->type = FD_PIPE;
    800043c2:	609c                	ld	a5,0(s1)
    800043c4:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    800043c8:	609c                	ld	a5,0(s1)
    800043ca:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    800043ce:	609c                	ld	a5,0(s1)
    800043d0:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    800043d4:	609c                	ld	a5,0(s1)
    800043d6:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    800043da:	000a3783          	ld	a5,0(s4)
    800043de:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    800043e2:	000a3783          	ld	a5,0(s4)
    800043e6:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    800043ea:	000a3783          	ld	a5,0(s4)
    800043ee:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    800043f2:	000a3783          	ld	a5,0(s4)
    800043f6:	0127b823          	sd	s2,16(a5)
  return 0;
    800043fa:	4501                	li	a0,0
    800043fc:	a005                	j	8000441c <pipealloc+0xae>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    800043fe:	6088                	ld	a0,0(s1)
    80004400:	e501                	bnez	a0,80004408 <pipealloc+0x9a>
    80004402:	a029                	j	8000440c <pipealloc+0x9e>
    80004404:	6088                	ld	a0,0(s1)
    80004406:	c11d                	beqz	a0,8000442c <pipealloc+0xbe>
    fileclose(*f0);
    80004408:	c9fff0ef          	jal	800040a6 <fileclose>
  if(*f1)
    8000440c:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004410:	557d                	li	a0,-1
  if(*f1)
    80004412:	c789                	beqz	a5,8000441c <pipealloc+0xae>
    fileclose(*f1);
    80004414:	853e                	mv	a0,a5
    80004416:	c91ff0ef          	jal	800040a6 <fileclose>
  return -1;
    8000441a:	557d                	li	a0,-1
}
    8000441c:	70a2                	ld	ra,40(sp)
    8000441e:	7402                	ld	s0,32(sp)
    80004420:	64e2                	ld	s1,24(sp)
    80004422:	6942                	ld	s2,16(sp)
    80004424:	69a2                	ld	s3,8(sp)
    80004426:	6a02                	ld	s4,0(sp)
    80004428:	6145                	add	sp,sp,48
    8000442a:	8082                	ret
  return -1;
    8000442c:	557d                	li	a0,-1
    8000442e:	b7fd                	j	8000441c <pipealloc+0xae>

0000000080004430 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004430:	1101                	add	sp,sp,-32
    80004432:	ec06                	sd	ra,24(sp)
    80004434:	e822                	sd	s0,16(sp)
    80004436:	e426                	sd	s1,8(sp)
    80004438:	e04a                	sd	s2,0(sp)
    8000443a:	1000                	add	s0,sp,32
    8000443c:	84aa                	mv	s1,a0
    8000443e:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004440:	f34fc0ef          	jal	80000b74 <acquire>
  if(writable){
    80004444:	02090763          	beqz	s2,80004472 <pipeclose+0x42>
    pi->writeopen = 0;
    80004448:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    8000444c:	21848513          	add	a0,s1,536
    80004450:	a9dfd0ef          	jal	80001eec <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004454:	2204b783          	ld	a5,544(s1)
    80004458:	e785                	bnez	a5,80004480 <pipeclose+0x50>
    release(&pi->lock);
    8000445a:	8526                	mv	a0,s1
    8000445c:	fb0fc0ef          	jal	80000c0c <release>
    kfree((char*)pi);
    80004460:	8526                	mv	a0,s1
    80004462:	d60fc0ef          	jal	800009c2 <kfree>
  } else
    release(&pi->lock);
}
    80004466:	60e2                	ld	ra,24(sp)
    80004468:	6442                	ld	s0,16(sp)
    8000446a:	64a2                	ld	s1,8(sp)
    8000446c:	6902                	ld	s2,0(sp)
    8000446e:	6105                	add	sp,sp,32
    80004470:	8082                	ret
    pi->readopen = 0;
    80004472:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004476:	21c48513          	add	a0,s1,540
    8000447a:	a73fd0ef          	jal	80001eec <wakeup>
    8000447e:	bfd9                	j	80004454 <pipeclose+0x24>
    release(&pi->lock);
    80004480:	8526                	mv	a0,s1
    80004482:	f8afc0ef          	jal	80000c0c <release>
}
    80004486:	b7c5                	j	80004466 <pipeclose+0x36>

0000000080004488 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004488:	711d                	add	sp,sp,-96
    8000448a:	ec86                	sd	ra,88(sp)
    8000448c:	e8a2                	sd	s0,80(sp)
    8000448e:	e4a6                	sd	s1,72(sp)
    80004490:	e0ca                	sd	s2,64(sp)
    80004492:	fc4e                	sd	s3,56(sp)
    80004494:	f852                	sd	s4,48(sp)
    80004496:	f456                	sd	s5,40(sp)
    80004498:	f05a                	sd	s6,32(sp)
    8000449a:	ec5e                	sd	s7,24(sp)
    8000449c:	e862                	sd	s8,16(sp)
    8000449e:	1080                	add	s0,sp,96
    800044a0:	84aa                	mv	s1,a0
    800044a2:	8aae                	mv	s5,a1
    800044a4:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    800044a6:	b64fd0ef          	jal	8000180a <myproc>
    800044aa:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    800044ac:	8526                	mv	a0,s1
    800044ae:	ec6fc0ef          	jal	80000b74 <acquire>
  while(i < n){
    800044b2:	09405c63          	blez	s4,8000454a <pipewrite+0xc2>
  int i = 0;
    800044b6:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800044b8:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    800044ba:	21848c13          	add	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    800044be:	21c48b93          	add	s7,s1,540
    800044c2:	a81d                	j	800044f8 <pipewrite+0x70>
      release(&pi->lock);
    800044c4:	8526                	mv	a0,s1
    800044c6:	f46fc0ef          	jal	80000c0c <release>
      return -1;
    800044ca:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    800044cc:	854a                	mv	a0,s2
    800044ce:	60e6                	ld	ra,88(sp)
    800044d0:	6446                	ld	s0,80(sp)
    800044d2:	64a6                	ld	s1,72(sp)
    800044d4:	6906                	ld	s2,64(sp)
    800044d6:	79e2                	ld	s3,56(sp)
    800044d8:	7a42                	ld	s4,48(sp)
    800044da:	7aa2                	ld	s5,40(sp)
    800044dc:	7b02                	ld	s6,32(sp)
    800044de:	6be2                	ld	s7,24(sp)
    800044e0:	6c42                	ld	s8,16(sp)
    800044e2:	6125                	add	sp,sp,96
    800044e4:	8082                	ret
      wakeup(&pi->nread);
    800044e6:	8562                	mv	a0,s8
    800044e8:	a05fd0ef          	jal	80001eec <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    800044ec:	85a6                	mv	a1,s1
    800044ee:	855e                	mv	a0,s7
    800044f0:	9b1fd0ef          	jal	80001ea0 <sleep>
  while(i < n){
    800044f4:	05495c63          	bge	s2,s4,8000454c <pipewrite+0xc4>
    if(pi->readopen == 0 || killed(pr)){
    800044f8:	2204a783          	lw	a5,544(s1)
    800044fc:	d7e1                	beqz	a5,800044c4 <pipewrite+0x3c>
    800044fe:	854e                	mv	a0,s3
    80004500:	bd9fd0ef          	jal	800020d8 <killed>
    80004504:	f161                	bnez	a0,800044c4 <pipewrite+0x3c>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004506:	2184a783          	lw	a5,536(s1)
    8000450a:	21c4a703          	lw	a4,540(s1)
    8000450e:	2007879b          	addw	a5,a5,512
    80004512:	fcf70ae3          	beq	a4,a5,800044e6 <pipewrite+0x5e>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004516:	4685                	li	a3,1
    80004518:	01590633          	add	a2,s2,s5
    8000451c:	faf40593          	add	a1,s0,-81
    80004520:	0509b503          	ld	a0,80(s3)
    80004524:	8fafd0ef          	jal	8000161e <copyin>
    80004528:	03650263          	beq	a0,s6,8000454c <pipewrite+0xc4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    8000452c:	21c4a783          	lw	a5,540(s1)
    80004530:	0017871b          	addw	a4,a5,1
    80004534:	20e4ae23          	sw	a4,540(s1)
    80004538:	1ff7f793          	and	a5,a5,511
    8000453c:	97a6                	add	a5,a5,s1
    8000453e:	faf44703          	lbu	a4,-81(s0)
    80004542:	00e78c23          	sb	a4,24(a5)
      i++;
    80004546:	2905                	addw	s2,s2,1
    80004548:	b775                	j	800044f4 <pipewrite+0x6c>
  int i = 0;
    8000454a:	4901                	li	s2,0
  wakeup(&pi->nread);
    8000454c:	21848513          	add	a0,s1,536
    80004550:	99dfd0ef          	jal	80001eec <wakeup>
  release(&pi->lock);
    80004554:	8526                	mv	a0,s1
    80004556:	eb6fc0ef          	jal	80000c0c <release>
  return i;
    8000455a:	bf8d                	j	800044cc <pipewrite+0x44>

000000008000455c <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    8000455c:	715d                	add	sp,sp,-80
    8000455e:	e486                	sd	ra,72(sp)
    80004560:	e0a2                	sd	s0,64(sp)
    80004562:	fc26                	sd	s1,56(sp)
    80004564:	f84a                	sd	s2,48(sp)
    80004566:	f44e                	sd	s3,40(sp)
    80004568:	f052                	sd	s4,32(sp)
    8000456a:	ec56                	sd	s5,24(sp)
    8000456c:	e85a                	sd	s6,16(sp)
    8000456e:	0880                	add	s0,sp,80
    80004570:	84aa                	mv	s1,a0
    80004572:	892e                	mv	s2,a1
    80004574:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004576:	a94fd0ef          	jal	8000180a <myproc>
    8000457a:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    8000457c:	8526                	mv	a0,s1
    8000457e:	df6fc0ef          	jal	80000b74 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004582:	2184a703          	lw	a4,536(s1)
    80004586:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000458a:	21848993          	add	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000458e:	02f71363          	bne	a4,a5,800045b4 <piperead+0x58>
    80004592:	2244a783          	lw	a5,548(s1)
    80004596:	cf99                	beqz	a5,800045b4 <piperead+0x58>
    if(killed(pr)){
    80004598:	8552                	mv	a0,s4
    8000459a:	b3ffd0ef          	jal	800020d8 <killed>
    8000459e:	e151                	bnez	a0,80004622 <piperead+0xc6>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800045a0:	85a6                	mv	a1,s1
    800045a2:	854e                	mv	a0,s3
    800045a4:	8fdfd0ef          	jal	80001ea0 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800045a8:	2184a703          	lw	a4,536(s1)
    800045ac:	21c4a783          	lw	a5,540(s1)
    800045b0:	fef701e3          	beq	a4,a5,80004592 <piperead+0x36>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800045b4:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1) {
    800045b6:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800045b8:	05505363          	blez	s5,800045fe <piperead+0xa2>
    if(pi->nread == pi->nwrite)
    800045bc:	2184a783          	lw	a5,536(s1)
    800045c0:	21c4a703          	lw	a4,540(s1)
    800045c4:	02f70d63          	beq	a4,a5,800045fe <piperead+0xa2>
    ch = pi->data[pi->nread % PIPESIZE];
    800045c8:	1ff7f793          	and	a5,a5,511
    800045cc:	97a6                	add	a5,a5,s1
    800045ce:	0187c783          	lbu	a5,24(a5)
    800045d2:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1) {
    800045d6:	4685                	li	a3,1
    800045d8:	fbf40613          	add	a2,s0,-65
    800045dc:	85ca                	mv	a1,s2
    800045de:	050a3503          	ld	a0,80(s4)
    800045e2:	f77fc0ef          	jal	80001558 <copyout>
    800045e6:	05650363          	beq	a0,s6,8000462c <piperead+0xd0>
      if(i == 0)
        i = -1;
      break;
    }
    pi->nread++;
    800045ea:	2184a783          	lw	a5,536(s1)
    800045ee:	2785                	addw	a5,a5,1
    800045f0:	20f4ac23          	sw	a5,536(s1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800045f4:	2985                	addw	s3,s3,1
    800045f6:	0905                	add	s2,s2,1
    800045f8:	fd3a92e3          	bne	s5,s3,800045bc <piperead+0x60>
    800045fc:	89d6                	mv	s3,s5
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800045fe:	21c48513          	add	a0,s1,540
    80004602:	8ebfd0ef          	jal	80001eec <wakeup>
  release(&pi->lock);
    80004606:	8526                	mv	a0,s1
    80004608:	e04fc0ef          	jal	80000c0c <release>
  return i;
}
    8000460c:	854e                	mv	a0,s3
    8000460e:	60a6                	ld	ra,72(sp)
    80004610:	6406                	ld	s0,64(sp)
    80004612:	74e2                	ld	s1,56(sp)
    80004614:	7942                	ld	s2,48(sp)
    80004616:	79a2                	ld	s3,40(sp)
    80004618:	7a02                	ld	s4,32(sp)
    8000461a:	6ae2                	ld	s5,24(sp)
    8000461c:	6b42                	ld	s6,16(sp)
    8000461e:	6161                	add	sp,sp,80
    80004620:	8082                	ret
      release(&pi->lock);
    80004622:	8526                	mv	a0,s1
    80004624:	de8fc0ef          	jal	80000c0c <release>
      return -1;
    80004628:	59fd                	li	s3,-1
    8000462a:	b7cd                	j	8000460c <piperead+0xb0>
      if(i == 0)
    8000462c:	fc0999e3          	bnez	s3,800045fe <piperead+0xa2>
        i = -1;
    80004630:	89aa                	mv	s3,a0
    80004632:	b7f1                	j	800045fe <piperead+0xa2>

0000000080004634 <flags2perm>:

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

// map ELF permissions to PTE permission bits.
int flags2perm(int flags)
{
    80004634:	1141                	add	sp,sp,-16
    80004636:	e422                	sd	s0,8(sp)
    80004638:	0800                	add	s0,sp,16
    8000463a:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    8000463c:	8905                	and	a0,a0,1
    8000463e:	050e                	sll	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    80004640:	8b89                	and	a5,a5,2
    80004642:	c399                	beqz	a5,80004648 <flags2perm+0x14>
      perm |= PTE_W;
    80004644:	00456513          	or	a0,a0,4
    return perm;
}
    80004648:	6422                	ld	s0,8(sp)
    8000464a:	0141                	add	sp,sp,16
    8000464c:	8082                	ret

000000008000464e <kexec>:
//
// the implementation of the exec() system call
//
int
kexec(char *path, char **argv)
{
    8000464e:	df010113          	add	sp,sp,-528
    80004652:	20113423          	sd	ra,520(sp)
    80004656:	20813023          	sd	s0,512(sp)
    8000465a:	ffa6                	sd	s1,504(sp)
    8000465c:	fbca                	sd	s2,496(sp)
    8000465e:	f7ce                	sd	s3,488(sp)
    80004660:	f3d2                	sd	s4,480(sp)
    80004662:	efd6                	sd	s5,472(sp)
    80004664:	ebda                	sd	s6,464(sp)
    80004666:	e7de                	sd	s7,456(sp)
    80004668:	e3e2                	sd	s8,448(sp)
    8000466a:	ff66                	sd	s9,440(sp)
    8000466c:	fb6a                	sd	s10,432(sp)
    8000466e:	f76e                	sd	s11,424(sp)
    80004670:	0c00                	add	s0,sp,528
    80004672:	892a                	mv	s2,a0
    80004674:	dea43c23          	sd	a0,-520(s0)
    80004678:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    8000467c:	98efd0ef          	jal	8000180a <myproc>
    80004680:	84aa                	mv	s1,a0

  begin_op();
    80004682:	e1eff0ef          	jal	80003ca0 <begin_op>

  // Open the executable file.
  if((ip = namei(path)) == 0){
    80004686:	854a                	mv	a0,s2
    80004688:	c44ff0ef          	jal	80003acc <namei>
    8000468c:	c12d                	beqz	a0,800046ee <kexec+0xa0>
    8000468e:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004690:	c4ffe0ef          	jal	800032de <ilock>

  // Read the ELF header.
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004694:	04000713          	li	a4,64
    80004698:	4681                	li	a3,0
    8000469a:	e5040613          	add	a2,s0,-432
    8000469e:	4581                	li	a1,0
    800046a0:	8552                	mv	a0,s4
    800046a2:	fc9fe0ef          	jal	8000366a <readi>
    800046a6:	04000793          	li	a5,64
    800046aa:	00f51a63          	bne	a0,a5,800046be <kexec+0x70>
    goto bad;

  // Is this really an ELF file?
  if(elf.magic != ELF_MAGIC)
    800046ae:	e5042703          	lw	a4,-432(s0)
    800046b2:	464c47b7          	lui	a5,0x464c4
    800046b6:	57f78793          	add	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800046ba:	02f70e63          	beq	a4,a5,800046f6 <kexec+0xa8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800046be:	8552                	mv	a0,s4
    800046c0:	e25fe0ef          	jal	800034e4 <iunlockput>
    end_op();
    800046c4:	e46ff0ef          	jal	80003d0a <end_op>
  }
  return -1;
    800046c8:	557d                	li	a0,-1
}
    800046ca:	20813083          	ld	ra,520(sp)
    800046ce:	20013403          	ld	s0,512(sp)
    800046d2:	74fe                	ld	s1,504(sp)
    800046d4:	795e                	ld	s2,496(sp)
    800046d6:	79be                	ld	s3,488(sp)
    800046d8:	7a1e                	ld	s4,480(sp)
    800046da:	6afe                	ld	s5,472(sp)
    800046dc:	6b5e                	ld	s6,464(sp)
    800046de:	6bbe                	ld	s7,456(sp)
    800046e0:	6c1e                	ld	s8,448(sp)
    800046e2:	7cfa                	ld	s9,440(sp)
    800046e4:	7d5a                	ld	s10,432(sp)
    800046e6:	7dba                	ld	s11,424(sp)
    800046e8:	21010113          	add	sp,sp,528
    800046ec:	8082                	ret
    end_op();
    800046ee:	e1cff0ef          	jal	80003d0a <end_op>
    return -1;
    800046f2:	557d                	li	a0,-1
    800046f4:	bfd9                	j	800046ca <kexec+0x7c>
  if((pagetable = proc_pagetable(p)) == 0)
    800046f6:	8526                	mv	a0,s1
    800046f8:	a18fd0ef          	jal	80001910 <proc_pagetable>
    800046fc:	8b2a                	mv	s6,a0
    800046fe:	d161                	beqz	a0,800046be <kexec+0x70>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004700:	e7042d03          	lw	s10,-400(s0)
    80004704:	e8845783          	lhu	a5,-376(s0)
    80004708:	0e078863          	beqz	a5,800047f8 <kexec+0x1aa>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000470c:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000470e:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    80004710:	6c85                	lui	s9,0x1
    80004712:	fffc8793          	add	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004716:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    8000471a:	6a85                	lui	s5,0x1
    8000471c:	a085                	j	8000477c <kexec+0x12e>
      panic("loadseg: address should exist");
    8000471e:	00003517          	auipc	a0,0x3
    80004722:	faa50513          	add	a0,a0,-86 # 800076c8 <syscalls+0x2d8>
    80004726:	878fc0ef          	jal	8000079e <panic>
    if(sz - i < PGSIZE)
    8000472a:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    8000472c:	8726                	mv	a4,s1
    8000472e:	012c06bb          	addw	a3,s8,s2
    80004732:	4581                	li	a1,0
    80004734:	8552                	mv	a0,s4
    80004736:	f35fe0ef          	jal	8000366a <readi>
    8000473a:	2501                	sext.w	a0,a0
    8000473c:	20a49a63          	bne	s1,a0,80004950 <kexec+0x302>
  for(i = 0; i < sz; i += PGSIZE){
    80004740:	012a893b          	addw	s2,s5,s2
    80004744:	03397363          	bgeu	s2,s3,8000476a <kexec+0x11c>
    pa = walkaddr(pagetable, va + i);
    80004748:	02091593          	sll	a1,s2,0x20
    8000474c:	9181                	srl	a1,a1,0x20
    8000474e:	95de                	add	a1,a1,s7
    80004750:	855a                	mv	a0,s6
    80004752:	80bfc0ef          	jal	80000f5c <walkaddr>
    80004756:	862a                	mv	a2,a0
    if(pa == 0)
    80004758:	d179                	beqz	a0,8000471e <kexec+0xd0>
    if(sz - i < PGSIZE)
    8000475a:	412984bb          	subw	s1,s3,s2
    8000475e:	0004879b          	sext.w	a5,s1
    80004762:	fcfcf4e3          	bgeu	s9,a5,8000472a <kexec+0xdc>
    80004766:	84d6                	mv	s1,s5
    80004768:	b7c9                	j	8000472a <kexec+0xdc>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    8000476a:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000476e:	2d85                	addw	s11,s11,1
    80004770:	038d0d1b          	addw	s10,s10,56 # 1038 <_entry-0x7fffefc8>
    80004774:	e8845783          	lhu	a5,-376(s0)
    80004778:	08fdd163          	bge	s11,a5,800047fa <kexec+0x1ac>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    8000477c:	2d01                	sext.w	s10,s10
    8000477e:	03800713          	li	a4,56
    80004782:	86ea                	mv	a3,s10
    80004784:	e1840613          	add	a2,s0,-488
    80004788:	4581                	li	a1,0
    8000478a:	8552                	mv	a0,s4
    8000478c:	edffe0ef          	jal	8000366a <readi>
    80004790:	03800793          	li	a5,56
    80004794:	1af51c63          	bne	a0,a5,8000494c <kexec+0x2fe>
    if(ph.type != ELF_PROG_LOAD)
    80004798:	e1842783          	lw	a5,-488(s0)
    8000479c:	4705                	li	a4,1
    8000479e:	fce798e3          	bne	a5,a4,8000476e <kexec+0x120>
    if(ph.memsz < ph.filesz)
    800047a2:	e4043483          	ld	s1,-448(s0)
    800047a6:	e3843783          	ld	a5,-456(s0)
    800047aa:	1af4ec63          	bltu	s1,a5,80004962 <kexec+0x314>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800047ae:	e2843783          	ld	a5,-472(s0)
    800047b2:	94be                	add	s1,s1,a5
    800047b4:	1af4ea63          	bltu	s1,a5,80004968 <kexec+0x31a>
    if(ph.vaddr % PGSIZE != 0)
    800047b8:	df043703          	ld	a4,-528(s0)
    800047bc:	8ff9                	and	a5,a5,a4
    800047be:	1a079863          	bnez	a5,8000496e <kexec+0x320>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800047c2:	e1c42503          	lw	a0,-484(s0)
    800047c6:	e6fff0ef          	jal	80004634 <flags2perm>
    800047ca:	86aa                	mv	a3,a0
    800047cc:	8626                	mv	a2,s1
    800047ce:	85ca                	mv	a1,s2
    800047d0:	855a                	mv	a0,s6
    800047d2:	a55fc0ef          	jal	80001226 <uvmalloc>
    800047d6:	e0a43423          	sd	a0,-504(s0)
    800047da:	18050d63          	beqz	a0,80004974 <kexec+0x326>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800047de:	e2843b83          	ld	s7,-472(s0)
    800047e2:	e2042c03          	lw	s8,-480(s0)
    800047e6:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    800047ea:	00098463          	beqz	s3,800047f2 <kexec+0x1a4>
    800047ee:	4901                	li	s2,0
    800047f0:	bfa1                	j	80004748 <kexec+0xfa>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800047f2:	e0843903          	ld	s2,-504(s0)
    800047f6:	bfa5                	j	8000476e <kexec+0x120>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800047f8:	4901                	li	s2,0
  iunlockput(ip);
    800047fa:	8552                	mv	a0,s4
    800047fc:	ce9fe0ef          	jal	800034e4 <iunlockput>
  end_op();
    80004800:	d0aff0ef          	jal	80003d0a <end_op>
  p = myproc();
    80004804:	806fd0ef          	jal	8000180a <myproc>
    80004808:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    8000480a:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    8000480e:	6985                	lui	s3,0x1
    80004810:	19fd                	add	s3,s3,-1 # fff <_entry-0x7ffff001>
    80004812:	99ca                	add	s3,s3,s2
    80004814:	77fd                	lui	a5,0xfffff
    80004816:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    8000481a:	4691                	li	a3,4
    8000481c:	6609                	lui	a2,0x2
    8000481e:	964e                	add	a2,a2,s3
    80004820:	85ce                	mv	a1,s3
    80004822:	855a                	mv	a0,s6
    80004824:	a03fc0ef          	jal	80001226 <uvmalloc>
    80004828:	892a                	mv	s2,a0
    8000482a:	e0a43423          	sd	a0,-504(s0)
    8000482e:	e509                	bnez	a0,80004838 <kexec+0x1ea>
  if(pagetable)
    80004830:	e1343423          	sd	s3,-504(s0)
    80004834:	4a01                	li	s4,0
    80004836:	aa29                	j	80004950 <kexec+0x302>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    80004838:	75f9                	lui	a1,0xffffe
    8000483a:	95aa                	add	a1,a1,a0
    8000483c:	855a                	mv	a0,s6
    8000483e:	bb3fc0ef          	jal	800013f0 <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    80004842:	7bfd                	lui	s7,0xfffff
    80004844:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    80004846:	e0043783          	ld	a5,-512(s0)
    8000484a:	6388                	ld	a0,0(a5)
    8000484c:	cd39                	beqz	a0,800048aa <kexec+0x25c>
    8000484e:	e9040993          	add	s3,s0,-368
    80004852:	f9040c13          	add	s8,s0,-112
    80004856:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80004858:	d66fc0ef          	jal	80000dbe <strlen>
    8000485c:	0015079b          	addw	a5,a0,1
    80004860:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004864:	ff07f913          	and	s2,a5,-16
    if(sp < stackbase)
    80004868:	11796963          	bltu	s2,s7,8000497a <kexec+0x32c>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    8000486c:	e0043d03          	ld	s10,-512(s0)
    80004870:	000d3a03          	ld	s4,0(s10)
    80004874:	8552                	mv	a0,s4
    80004876:	d48fc0ef          	jal	80000dbe <strlen>
    8000487a:	0015069b          	addw	a3,a0,1
    8000487e:	8652                	mv	a2,s4
    80004880:	85ca                	mv	a1,s2
    80004882:	855a                	mv	a0,s6
    80004884:	cd5fc0ef          	jal	80001558 <copyout>
    80004888:	0e054b63          	bltz	a0,8000497e <kexec+0x330>
    ustack[argc] = sp;
    8000488c:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004890:	0485                	add	s1,s1,1
    80004892:	008d0793          	add	a5,s10,8
    80004896:	e0f43023          	sd	a5,-512(s0)
    8000489a:	008d3503          	ld	a0,8(s10)
    8000489e:	c909                	beqz	a0,800048b0 <kexec+0x262>
    if(argc >= MAXARG)
    800048a0:	09a1                	add	s3,s3,8
    800048a2:	fb899be3          	bne	s3,s8,80004858 <kexec+0x20a>
  ip = 0;
    800048a6:	4a01                	li	s4,0
    800048a8:	a065                	j	80004950 <kexec+0x302>
  sp = sz;
    800048aa:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    800048ae:	4481                	li	s1,0
  ustack[argc] = 0;
    800048b0:	00349793          	sll	a5,s1,0x3
    800048b4:	f9078793          	add	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffde1a0>
    800048b8:	97a2                	add	a5,a5,s0
    800048ba:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    800048be:	00148693          	add	a3,s1,1
    800048c2:	068e                	sll	a3,a3,0x3
    800048c4:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800048c8:	ff097913          	and	s2,s2,-16
  sz = sz1;
    800048cc:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    800048d0:	f77960e3          	bltu	s2,s7,80004830 <kexec+0x1e2>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800048d4:	e9040613          	add	a2,s0,-368
    800048d8:	85ca                	mv	a1,s2
    800048da:	855a                	mv	a0,s6
    800048dc:	c7dfc0ef          	jal	80001558 <copyout>
    800048e0:	0a054163          	bltz	a0,80004982 <kexec+0x334>
  p->trapframe->a1 = sp;
    800048e4:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    800048e8:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800048ec:	df843783          	ld	a5,-520(s0)
    800048f0:	0007c703          	lbu	a4,0(a5)
    800048f4:	cf11                	beqz	a4,80004910 <kexec+0x2c2>
    800048f6:	0785                	add	a5,a5,1
    if(*s == '/')
    800048f8:	02f00693          	li	a3,47
    800048fc:	a039                	j	8000490a <kexec+0x2bc>
      last = s+1;
    800048fe:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80004902:	0785                	add	a5,a5,1
    80004904:	fff7c703          	lbu	a4,-1(a5)
    80004908:	c701                	beqz	a4,80004910 <kexec+0x2c2>
    if(*s == '/')
    8000490a:	fed71ce3          	bne	a4,a3,80004902 <kexec+0x2b4>
    8000490e:	bfc5                	j	800048fe <kexec+0x2b0>
  safestrcpy(p->name, last, sizeof(p->name));
    80004910:	4641                	li	a2,16
    80004912:	df843583          	ld	a1,-520(s0)
    80004916:	158a8513          	add	a0,s5,344
    8000491a:	c72fc0ef          	jal	80000d8c <safestrcpy>
  oldpagetable = p->pagetable;
    8000491e:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80004922:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80004926:	e0843783          	ld	a5,-504(s0)
    8000492a:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = ulib.c:start()
    8000492e:	058ab783          	ld	a5,88(s5)
    80004932:	e6843703          	ld	a4,-408(s0)
    80004936:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004938:	058ab783          	ld	a5,88(s5)
    8000493c:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004940:	85e6                	mv	a1,s9
    80004942:	852fd0ef          	jal	80001994 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004946:	0004851b          	sext.w	a0,s1
    8000494a:	b341                	j	800046ca <kexec+0x7c>
    8000494c:	e1243423          	sd	s2,-504(s0)
    proc_freepagetable(pagetable, sz);
    80004950:	e0843583          	ld	a1,-504(s0)
    80004954:	855a                	mv	a0,s6
    80004956:	83efd0ef          	jal	80001994 <proc_freepagetable>
  return -1;
    8000495a:	557d                	li	a0,-1
  if(ip){
    8000495c:	d60a07e3          	beqz	s4,800046ca <kexec+0x7c>
    80004960:	bbb9                	j	800046be <kexec+0x70>
    80004962:	e1243423          	sd	s2,-504(s0)
    80004966:	b7ed                	j	80004950 <kexec+0x302>
    80004968:	e1243423          	sd	s2,-504(s0)
    8000496c:	b7d5                	j	80004950 <kexec+0x302>
    8000496e:	e1243423          	sd	s2,-504(s0)
    80004972:	bff9                	j	80004950 <kexec+0x302>
    80004974:	e1243423          	sd	s2,-504(s0)
    80004978:	bfe1                	j	80004950 <kexec+0x302>
  ip = 0;
    8000497a:	4a01                	li	s4,0
    8000497c:	bfd1                	j	80004950 <kexec+0x302>
    8000497e:	4a01                	li	s4,0
  if(pagetable)
    80004980:	bfc1                	j	80004950 <kexec+0x302>
  sz = sz1;
    80004982:	e0843983          	ld	s3,-504(s0)
    80004986:	b56d                	j	80004830 <kexec+0x1e2>

0000000080004988 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004988:	7179                	add	sp,sp,-48
    8000498a:	f406                	sd	ra,40(sp)
    8000498c:	f022                	sd	s0,32(sp)
    8000498e:	ec26                	sd	s1,24(sp)
    80004990:	e84a                	sd	s2,16(sp)
    80004992:	1800                	add	s0,sp,48
    80004994:	892e                	mv	s2,a1
    80004996:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80004998:	fdc40593          	add	a1,s0,-36
    8000499c:	ea9fd0ef          	jal	80002844 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800049a0:	fdc42703          	lw	a4,-36(s0)
    800049a4:	47bd                	li	a5,15
    800049a6:	02e7e963          	bltu	a5,a4,800049d8 <argfd+0x50>
    800049aa:	e61fc0ef          	jal	8000180a <myproc>
    800049ae:	fdc42703          	lw	a4,-36(s0)
    800049b2:	01a70793          	add	a5,a4,26
    800049b6:	078e                	sll	a5,a5,0x3
    800049b8:	953e                	add	a0,a0,a5
    800049ba:	611c                	ld	a5,0(a0)
    800049bc:	c385                	beqz	a5,800049dc <argfd+0x54>
    return -1;
  if(pfd)
    800049be:	00090463          	beqz	s2,800049c6 <argfd+0x3e>
    *pfd = fd;
    800049c2:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800049c6:	4501                	li	a0,0
  if(pf)
    800049c8:	c091                	beqz	s1,800049cc <argfd+0x44>
    *pf = f;
    800049ca:	e09c                	sd	a5,0(s1)
}
    800049cc:	70a2                	ld	ra,40(sp)
    800049ce:	7402                	ld	s0,32(sp)
    800049d0:	64e2                	ld	s1,24(sp)
    800049d2:	6942                	ld	s2,16(sp)
    800049d4:	6145                	add	sp,sp,48
    800049d6:	8082                	ret
    return -1;
    800049d8:	557d                	li	a0,-1
    800049da:	bfcd                	j	800049cc <argfd+0x44>
    800049dc:	557d                	li	a0,-1
    800049de:	b7fd                	j	800049cc <argfd+0x44>

00000000800049e0 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800049e0:	1101                	add	sp,sp,-32
    800049e2:	ec06                	sd	ra,24(sp)
    800049e4:	e822                	sd	s0,16(sp)
    800049e6:	e426                	sd	s1,8(sp)
    800049e8:	1000                	add	s0,sp,32
    800049ea:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800049ec:	e1ffc0ef          	jal	8000180a <myproc>
    800049f0:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800049f2:	0d050793          	add	a5,a0,208
    800049f6:	4501                	li	a0,0
    800049f8:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800049fa:	6398                	ld	a4,0(a5)
    800049fc:	cb19                	beqz	a4,80004a12 <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    800049fe:	2505                	addw	a0,a0,1
    80004a00:	07a1                	add	a5,a5,8
    80004a02:	fed51ce3          	bne	a0,a3,800049fa <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004a06:	557d                	li	a0,-1
}
    80004a08:	60e2                	ld	ra,24(sp)
    80004a0a:	6442                	ld	s0,16(sp)
    80004a0c:	64a2                	ld	s1,8(sp)
    80004a0e:	6105                	add	sp,sp,32
    80004a10:	8082                	ret
      p->ofile[fd] = f;
    80004a12:	01a50793          	add	a5,a0,26
    80004a16:	078e                	sll	a5,a5,0x3
    80004a18:	963e                	add	a2,a2,a5
    80004a1a:	e204                	sd	s1,0(a2)
      return fd;
    80004a1c:	b7f5                	j	80004a08 <fdalloc+0x28>

0000000080004a1e <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004a1e:	715d                	add	sp,sp,-80
    80004a20:	e486                	sd	ra,72(sp)
    80004a22:	e0a2                	sd	s0,64(sp)
    80004a24:	fc26                	sd	s1,56(sp)
    80004a26:	f84a                	sd	s2,48(sp)
    80004a28:	f44e                	sd	s3,40(sp)
    80004a2a:	f052                	sd	s4,32(sp)
    80004a2c:	ec56                	sd	s5,24(sp)
    80004a2e:	e85a                	sd	s6,16(sp)
    80004a30:	0880                	add	s0,sp,80
    80004a32:	8b2e                	mv	s6,a1
    80004a34:	89b2                	mv	s3,a2
    80004a36:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004a38:	fb040593          	add	a1,s0,-80
    80004a3c:	8aaff0ef          	jal	80003ae6 <nameiparent>
    80004a40:	84aa                	mv	s1,a0
    80004a42:	10050763          	beqz	a0,80004b50 <create+0x132>
    return 0;

  ilock(dp);
    80004a46:	899fe0ef          	jal	800032de <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004a4a:	4601                	li	a2,0
    80004a4c:	fb040593          	add	a1,s0,-80
    80004a50:	8526                	mv	a0,s1
    80004a52:	e15fe0ef          	jal	80003866 <dirlookup>
    80004a56:	8aaa                	mv	s5,a0
    80004a58:	c131                	beqz	a0,80004a9c <create+0x7e>
    iunlockput(dp);
    80004a5a:	8526                	mv	a0,s1
    80004a5c:	a89fe0ef          	jal	800034e4 <iunlockput>
    ilock(ip);
    80004a60:	8556                	mv	a0,s5
    80004a62:	87dfe0ef          	jal	800032de <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004a66:	4789                	li	a5,2
    80004a68:	02fb1563          	bne	s6,a5,80004a92 <create+0x74>
    80004a6c:	044ad783          	lhu	a5,68(s5)
    80004a70:	37f9                	addw	a5,a5,-2
    80004a72:	17c2                	sll	a5,a5,0x30
    80004a74:	93c1                	srl	a5,a5,0x30
    80004a76:	4705                	li	a4,1
    80004a78:	00f76d63          	bltu	a4,a5,80004a92 <create+0x74>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80004a7c:	8556                	mv	a0,s5
    80004a7e:	60a6                	ld	ra,72(sp)
    80004a80:	6406                	ld	s0,64(sp)
    80004a82:	74e2                	ld	s1,56(sp)
    80004a84:	7942                	ld	s2,48(sp)
    80004a86:	79a2                	ld	s3,40(sp)
    80004a88:	7a02                	ld	s4,32(sp)
    80004a8a:	6ae2                	ld	s5,24(sp)
    80004a8c:	6b42                	ld	s6,16(sp)
    80004a8e:	6161                	add	sp,sp,80
    80004a90:	8082                	ret
    iunlockput(ip);
    80004a92:	8556                	mv	a0,s5
    80004a94:	a51fe0ef          	jal	800034e4 <iunlockput>
    return 0;
    80004a98:	4a81                	li	s5,0
    80004a9a:	b7cd                	j	80004a7c <create+0x5e>
  if((ip = ialloc(dp->dev, type)) == 0){
    80004a9c:	85da                	mv	a1,s6
    80004a9e:	4088                	lw	a0,0(s1)
    80004aa0:	edafe0ef          	jal	8000317a <ialloc>
    80004aa4:	8a2a                	mv	s4,a0
    80004aa6:	cd0d                	beqz	a0,80004ae0 <create+0xc2>
  ilock(ip);
    80004aa8:	837fe0ef          	jal	800032de <ilock>
  ip->major = major;
    80004aac:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80004ab0:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80004ab4:	4905                	li	s2,1
    80004ab6:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80004aba:	8552                	mv	a0,s4
    80004abc:	f6efe0ef          	jal	8000322a <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004ac0:	032b0563          	beq	s6,s2,80004aea <create+0xcc>
  if(dirlink(dp, name, ip->inum) < 0)
    80004ac4:	004a2603          	lw	a2,4(s4)
    80004ac8:	fb040593          	add	a1,s0,-80
    80004acc:	8526                	mv	a0,s1
    80004ace:	f65fe0ef          	jal	80003a32 <dirlink>
    80004ad2:	06054363          	bltz	a0,80004b38 <create+0x11a>
  iunlockput(dp);
    80004ad6:	8526                	mv	a0,s1
    80004ad8:	a0dfe0ef          	jal	800034e4 <iunlockput>
  return ip;
    80004adc:	8ad2                	mv	s5,s4
    80004ade:	bf79                	j	80004a7c <create+0x5e>
    iunlockput(dp);
    80004ae0:	8526                	mv	a0,s1
    80004ae2:	a03fe0ef          	jal	800034e4 <iunlockput>
    return 0;
    80004ae6:	8ad2                	mv	s5,s4
    80004ae8:	bf51                	j	80004a7c <create+0x5e>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004aea:	004a2603          	lw	a2,4(s4)
    80004aee:	00003597          	auipc	a1,0x3
    80004af2:	bfa58593          	add	a1,a1,-1030 # 800076e8 <syscalls+0x2f8>
    80004af6:	8552                	mv	a0,s4
    80004af8:	f3bfe0ef          	jal	80003a32 <dirlink>
    80004afc:	02054e63          	bltz	a0,80004b38 <create+0x11a>
    80004b00:	40d0                	lw	a2,4(s1)
    80004b02:	00003597          	auipc	a1,0x3
    80004b06:	bee58593          	add	a1,a1,-1042 # 800076f0 <syscalls+0x300>
    80004b0a:	8552                	mv	a0,s4
    80004b0c:	f27fe0ef          	jal	80003a32 <dirlink>
    80004b10:	02054463          	bltz	a0,80004b38 <create+0x11a>
  if(dirlink(dp, name, ip->inum) < 0)
    80004b14:	004a2603          	lw	a2,4(s4)
    80004b18:	fb040593          	add	a1,s0,-80
    80004b1c:	8526                	mv	a0,s1
    80004b1e:	f15fe0ef          	jal	80003a32 <dirlink>
    80004b22:	00054b63          	bltz	a0,80004b38 <create+0x11a>
    dp->nlink++;  // for ".."
    80004b26:	04a4d783          	lhu	a5,74(s1)
    80004b2a:	2785                	addw	a5,a5,1
    80004b2c:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004b30:	8526                	mv	a0,s1
    80004b32:	ef8fe0ef          	jal	8000322a <iupdate>
    80004b36:	b745                	j	80004ad6 <create+0xb8>
  ip->nlink = 0;
    80004b38:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80004b3c:	8552                	mv	a0,s4
    80004b3e:	eecfe0ef          	jal	8000322a <iupdate>
  iunlockput(ip);
    80004b42:	8552                	mv	a0,s4
    80004b44:	9a1fe0ef          	jal	800034e4 <iunlockput>
  iunlockput(dp);
    80004b48:	8526                	mv	a0,s1
    80004b4a:	99bfe0ef          	jal	800034e4 <iunlockput>
  return 0;
    80004b4e:	b73d                	j	80004a7c <create+0x5e>
    return 0;
    80004b50:	8aaa                	mv	s5,a0
    80004b52:	b72d                	j	80004a7c <create+0x5e>

0000000080004b54 <sys_dup>:
{
    80004b54:	7179                	add	sp,sp,-48
    80004b56:	f406                	sd	ra,40(sp)
    80004b58:	f022                	sd	s0,32(sp)
    80004b5a:	ec26                	sd	s1,24(sp)
    80004b5c:	e84a                	sd	s2,16(sp)
    80004b5e:	1800                	add	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004b60:	fd840613          	add	a2,s0,-40
    80004b64:	4581                	li	a1,0
    80004b66:	4501                	li	a0,0
    80004b68:	e21ff0ef          	jal	80004988 <argfd>
    return -1;
    80004b6c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004b6e:	00054f63          	bltz	a0,80004b8c <sys_dup+0x38>
  if((fd=fdalloc(f)) < 0)
    80004b72:	fd843903          	ld	s2,-40(s0)
    80004b76:	854a                	mv	a0,s2
    80004b78:	e69ff0ef          	jal	800049e0 <fdalloc>
    80004b7c:	84aa                	mv	s1,a0
    return -1;
    80004b7e:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004b80:	00054663          	bltz	a0,80004b8c <sys_dup+0x38>
  filedup(f);
    80004b84:	854a                	mv	a0,s2
    80004b86:	cdaff0ef          	jal	80004060 <filedup>
  return fd;
    80004b8a:	87a6                	mv	a5,s1
}
    80004b8c:	853e                	mv	a0,a5
    80004b8e:	70a2                	ld	ra,40(sp)
    80004b90:	7402                	ld	s0,32(sp)
    80004b92:	64e2                	ld	s1,24(sp)
    80004b94:	6942                	ld	s2,16(sp)
    80004b96:	6145                	add	sp,sp,48
    80004b98:	8082                	ret

0000000080004b9a <sys_read>:
{
    80004b9a:	7179                	add	sp,sp,-48
    80004b9c:	f406                	sd	ra,40(sp)
    80004b9e:	f022                	sd	s0,32(sp)
    80004ba0:	1800                	add	s0,sp,48
  argaddr(1, &p);
    80004ba2:	fd840593          	add	a1,s0,-40
    80004ba6:	4505                	li	a0,1
    80004ba8:	cf1fd0ef          	jal	80002898 <argaddr>
  argint(2, &n);
    80004bac:	fe440593          	add	a1,s0,-28
    80004bb0:	4509                	li	a0,2
    80004bb2:	c93fd0ef          	jal	80002844 <argint>
  if(argfd(0, 0, &f) < 0)
    80004bb6:	fe840613          	add	a2,s0,-24
    80004bba:	4581                	li	a1,0
    80004bbc:	4501                	li	a0,0
    80004bbe:	dcbff0ef          	jal	80004988 <argfd>
    80004bc2:	87aa                	mv	a5,a0
    return -1;
    80004bc4:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004bc6:	0007ca63          	bltz	a5,80004bda <sys_read+0x40>
  return fileread(f, p, n);
    80004bca:	fe442603          	lw	a2,-28(s0)
    80004bce:	fd843583          	ld	a1,-40(s0)
    80004bd2:	fe843503          	ld	a0,-24(s0)
    80004bd6:	dd6ff0ef          	jal	800041ac <fileread>
}
    80004bda:	70a2                	ld	ra,40(sp)
    80004bdc:	7402                	ld	s0,32(sp)
    80004bde:	6145                	add	sp,sp,48
    80004be0:	8082                	ret

0000000080004be2 <sys_write>:
{
    80004be2:	7179                	add	sp,sp,-48
    80004be4:	f406                	sd	ra,40(sp)
    80004be6:	f022                	sd	s0,32(sp)
    80004be8:	1800                	add	s0,sp,48
  argaddr(1, &p);
    80004bea:	fd840593          	add	a1,s0,-40
    80004bee:	4505                	li	a0,1
    80004bf0:	ca9fd0ef          	jal	80002898 <argaddr>
  argint(2, &n);
    80004bf4:	fe440593          	add	a1,s0,-28
    80004bf8:	4509                	li	a0,2
    80004bfa:	c4bfd0ef          	jal	80002844 <argint>
  if(argfd(0, 0, &f) < 0)
    80004bfe:	fe840613          	add	a2,s0,-24
    80004c02:	4581                	li	a1,0
    80004c04:	4501                	li	a0,0
    80004c06:	d83ff0ef          	jal	80004988 <argfd>
    80004c0a:	87aa                	mv	a5,a0
    return -1;
    80004c0c:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004c0e:	0007ca63          	bltz	a5,80004c22 <sys_write+0x40>
  return filewrite(f, p, n);
    80004c12:	fe442603          	lw	a2,-28(s0)
    80004c16:	fd843583          	ld	a1,-40(s0)
    80004c1a:	fe843503          	ld	a0,-24(s0)
    80004c1e:	e3cff0ef          	jal	8000425a <filewrite>
}
    80004c22:	70a2                	ld	ra,40(sp)
    80004c24:	7402                	ld	s0,32(sp)
    80004c26:	6145                	add	sp,sp,48
    80004c28:	8082                	ret

0000000080004c2a <sys_close>:
{
    80004c2a:	1101                	add	sp,sp,-32
    80004c2c:	ec06                	sd	ra,24(sp)
    80004c2e:	e822                	sd	s0,16(sp)
    80004c30:	1000                	add	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004c32:	fe040613          	add	a2,s0,-32
    80004c36:	fec40593          	add	a1,s0,-20
    80004c3a:	4501                	li	a0,0
    80004c3c:	d4dff0ef          	jal	80004988 <argfd>
    return -1;
    80004c40:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004c42:	02054063          	bltz	a0,80004c62 <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    80004c46:	bc5fc0ef          	jal	8000180a <myproc>
    80004c4a:	fec42783          	lw	a5,-20(s0)
    80004c4e:	07e9                	add	a5,a5,26
    80004c50:	078e                	sll	a5,a5,0x3
    80004c52:	953e                	add	a0,a0,a5
    80004c54:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80004c58:	fe043503          	ld	a0,-32(s0)
    80004c5c:	c4aff0ef          	jal	800040a6 <fileclose>
  return 0;
    80004c60:	4781                	li	a5,0
}
    80004c62:	853e                	mv	a0,a5
    80004c64:	60e2                	ld	ra,24(sp)
    80004c66:	6442                	ld	s0,16(sp)
    80004c68:	6105                	add	sp,sp,32
    80004c6a:	8082                	ret

0000000080004c6c <sys_fstat>:
{
    80004c6c:	1101                	add	sp,sp,-32
    80004c6e:	ec06                	sd	ra,24(sp)
    80004c70:	e822                	sd	s0,16(sp)
    80004c72:	1000                	add	s0,sp,32
  argaddr(1, &st);
    80004c74:	fe040593          	add	a1,s0,-32
    80004c78:	4505                	li	a0,1
    80004c7a:	c1ffd0ef          	jal	80002898 <argaddr>
  if(argfd(0, 0, &f) < 0)
    80004c7e:	fe840613          	add	a2,s0,-24
    80004c82:	4581                	li	a1,0
    80004c84:	4501                	li	a0,0
    80004c86:	d03ff0ef          	jal	80004988 <argfd>
    80004c8a:	87aa                	mv	a5,a0
    return -1;
    80004c8c:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004c8e:	0007c863          	bltz	a5,80004c9e <sys_fstat+0x32>
  return filestat(f, st);
    80004c92:	fe043583          	ld	a1,-32(s0)
    80004c96:	fe843503          	ld	a0,-24(s0)
    80004c9a:	cb4ff0ef          	jal	8000414e <filestat>
}
    80004c9e:	60e2                	ld	ra,24(sp)
    80004ca0:	6442                	ld	s0,16(sp)
    80004ca2:	6105                	add	sp,sp,32
    80004ca4:	8082                	ret

0000000080004ca6 <sys_link>:
{
    80004ca6:	7169                	add	sp,sp,-304
    80004ca8:	f606                	sd	ra,296(sp)
    80004caa:	f222                	sd	s0,288(sp)
    80004cac:	ee26                	sd	s1,280(sp)
    80004cae:	ea4a                	sd	s2,272(sp)
    80004cb0:	1a00                	add	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004cb2:	08000613          	li	a2,128
    80004cb6:	ed040593          	add	a1,s0,-304
    80004cba:	4501                	li	a0,0
    80004cbc:	bf9fd0ef          	jal	800028b4 <argstr>
    return -1;
    80004cc0:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004cc2:	0c054663          	bltz	a0,80004d8e <sys_link+0xe8>
    80004cc6:	08000613          	li	a2,128
    80004cca:	f5040593          	add	a1,s0,-176
    80004cce:	4505                	li	a0,1
    80004cd0:	be5fd0ef          	jal	800028b4 <argstr>
    return -1;
    80004cd4:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004cd6:	0a054c63          	bltz	a0,80004d8e <sys_link+0xe8>
  begin_op();
    80004cda:	fc7fe0ef          	jal	80003ca0 <begin_op>
  if((ip = namei(old)) == 0){
    80004cde:	ed040513          	add	a0,s0,-304
    80004ce2:	debfe0ef          	jal	80003acc <namei>
    80004ce6:	84aa                	mv	s1,a0
    80004ce8:	c525                	beqz	a0,80004d50 <sys_link+0xaa>
  ilock(ip);
    80004cea:	df4fe0ef          	jal	800032de <ilock>
  if(ip->type == T_DIR){
    80004cee:	04449703          	lh	a4,68(s1)
    80004cf2:	4785                	li	a5,1
    80004cf4:	06f70263          	beq	a4,a5,80004d58 <sys_link+0xb2>
  ip->nlink++;
    80004cf8:	04a4d783          	lhu	a5,74(s1)
    80004cfc:	2785                	addw	a5,a5,1
    80004cfe:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004d02:	8526                	mv	a0,s1
    80004d04:	d26fe0ef          	jal	8000322a <iupdate>
  iunlock(ip);
    80004d08:	8526                	mv	a0,s1
    80004d0a:	e7efe0ef          	jal	80003388 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004d0e:	fd040593          	add	a1,s0,-48
    80004d12:	f5040513          	add	a0,s0,-176
    80004d16:	dd1fe0ef          	jal	80003ae6 <nameiparent>
    80004d1a:	892a                	mv	s2,a0
    80004d1c:	c921                	beqz	a0,80004d6c <sys_link+0xc6>
  ilock(dp);
    80004d1e:	dc0fe0ef          	jal	800032de <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004d22:	00092703          	lw	a4,0(s2)
    80004d26:	409c                	lw	a5,0(s1)
    80004d28:	02f71f63          	bne	a4,a5,80004d66 <sys_link+0xc0>
    80004d2c:	40d0                	lw	a2,4(s1)
    80004d2e:	fd040593          	add	a1,s0,-48
    80004d32:	854a                	mv	a0,s2
    80004d34:	cfffe0ef          	jal	80003a32 <dirlink>
    80004d38:	02054763          	bltz	a0,80004d66 <sys_link+0xc0>
  iunlockput(dp);
    80004d3c:	854a                	mv	a0,s2
    80004d3e:	fa6fe0ef          	jal	800034e4 <iunlockput>
  iput(ip);
    80004d42:	8526                	mv	a0,s1
    80004d44:	f18fe0ef          	jal	8000345c <iput>
  end_op();
    80004d48:	fc3fe0ef          	jal	80003d0a <end_op>
  return 0;
    80004d4c:	4781                	li	a5,0
    80004d4e:	a081                	j	80004d8e <sys_link+0xe8>
    end_op();
    80004d50:	fbbfe0ef          	jal	80003d0a <end_op>
    return -1;
    80004d54:	57fd                	li	a5,-1
    80004d56:	a825                	j	80004d8e <sys_link+0xe8>
    iunlockput(ip);
    80004d58:	8526                	mv	a0,s1
    80004d5a:	f8afe0ef          	jal	800034e4 <iunlockput>
    end_op();
    80004d5e:	fadfe0ef          	jal	80003d0a <end_op>
    return -1;
    80004d62:	57fd                	li	a5,-1
    80004d64:	a02d                	j	80004d8e <sys_link+0xe8>
    iunlockput(dp);
    80004d66:	854a                	mv	a0,s2
    80004d68:	f7cfe0ef          	jal	800034e4 <iunlockput>
  ilock(ip);
    80004d6c:	8526                	mv	a0,s1
    80004d6e:	d70fe0ef          	jal	800032de <ilock>
  ip->nlink--;
    80004d72:	04a4d783          	lhu	a5,74(s1)
    80004d76:	37fd                	addw	a5,a5,-1
    80004d78:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004d7c:	8526                	mv	a0,s1
    80004d7e:	cacfe0ef          	jal	8000322a <iupdate>
  iunlockput(ip);
    80004d82:	8526                	mv	a0,s1
    80004d84:	f60fe0ef          	jal	800034e4 <iunlockput>
  end_op();
    80004d88:	f83fe0ef          	jal	80003d0a <end_op>
  return -1;
    80004d8c:	57fd                	li	a5,-1
}
    80004d8e:	853e                	mv	a0,a5
    80004d90:	70b2                	ld	ra,296(sp)
    80004d92:	7412                	ld	s0,288(sp)
    80004d94:	64f2                	ld	s1,280(sp)
    80004d96:	6952                	ld	s2,272(sp)
    80004d98:	6155                	add	sp,sp,304
    80004d9a:	8082                	ret

0000000080004d9c <sys_unlink>:
{
    80004d9c:	7151                	add	sp,sp,-240
    80004d9e:	f586                	sd	ra,232(sp)
    80004da0:	f1a2                	sd	s0,224(sp)
    80004da2:	eda6                	sd	s1,216(sp)
    80004da4:	e9ca                	sd	s2,208(sp)
    80004da6:	e5ce                	sd	s3,200(sp)
    80004da8:	1980                	add	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004daa:	08000613          	li	a2,128
    80004dae:	f3040593          	add	a1,s0,-208
    80004db2:	4501                	li	a0,0
    80004db4:	b01fd0ef          	jal	800028b4 <argstr>
    80004db8:	12054b63          	bltz	a0,80004eee <sys_unlink+0x152>
  begin_op();
    80004dbc:	ee5fe0ef          	jal	80003ca0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004dc0:	fb040593          	add	a1,s0,-80
    80004dc4:	f3040513          	add	a0,s0,-208
    80004dc8:	d1ffe0ef          	jal	80003ae6 <nameiparent>
    80004dcc:	84aa                	mv	s1,a0
    80004dce:	c54d                	beqz	a0,80004e78 <sys_unlink+0xdc>
  ilock(dp);
    80004dd0:	d0efe0ef          	jal	800032de <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004dd4:	00003597          	auipc	a1,0x3
    80004dd8:	91458593          	add	a1,a1,-1772 # 800076e8 <syscalls+0x2f8>
    80004ddc:	fb040513          	add	a0,s0,-80
    80004de0:	a71fe0ef          	jal	80003850 <namecmp>
    80004de4:	10050a63          	beqz	a0,80004ef8 <sys_unlink+0x15c>
    80004de8:	00003597          	auipc	a1,0x3
    80004dec:	90858593          	add	a1,a1,-1784 # 800076f0 <syscalls+0x300>
    80004df0:	fb040513          	add	a0,s0,-80
    80004df4:	a5dfe0ef          	jal	80003850 <namecmp>
    80004df8:	10050063          	beqz	a0,80004ef8 <sys_unlink+0x15c>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004dfc:	f2c40613          	add	a2,s0,-212
    80004e00:	fb040593          	add	a1,s0,-80
    80004e04:	8526                	mv	a0,s1
    80004e06:	a61fe0ef          	jal	80003866 <dirlookup>
    80004e0a:	892a                	mv	s2,a0
    80004e0c:	0e050663          	beqz	a0,80004ef8 <sys_unlink+0x15c>
  ilock(ip);
    80004e10:	ccefe0ef          	jal	800032de <ilock>
  if(ip->nlink < 1)
    80004e14:	04a91783          	lh	a5,74(s2)
    80004e18:	06f05463          	blez	a5,80004e80 <sys_unlink+0xe4>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004e1c:	04491703          	lh	a4,68(s2)
    80004e20:	4785                	li	a5,1
    80004e22:	06f70563          	beq	a4,a5,80004e8c <sys_unlink+0xf0>
  memset(&de, 0, sizeof(de));
    80004e26:	4641                	li	a2,16
    80004e28:	4581                	li	a1,0
    80004e2a:	fc040513          	add	a0,s0,-64
    80004e2e:	e1bfb0ef          	jal	80000c48 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004e32:	4741                	li	a4,16
    80004e34:	f2c42683          	lw	a3,-212(s0)
    80004e38:	fc040613          	add	a2,s0,-64
    80004e3c:	4581                	li	a1,0
    80004e3e:	8526                	mv	a0,s1
    80004e40:	90ffe0ef          	jal	8000374e <writei>
    80004e44:	47c1                	li	a5,16
    80004e46:	08f51563          	bne	a0,a5,80004ed0 <sys_unlink+0x134>
  if(ip->type == T_DIR){
    80004e4a:	04491703          	lh	a4,68(s2)
    80004e4e:	4785                	li	a5,1
    80004e50:	08f70663          	beq	a4,a5,80004edc <sys_unlink+0x140>
  iunlockput(dp);
    80004e54:	8526                	mv	a0,s1
    80004e56:	e8efe0ef          	jal	800034e4 <iunlockput>
  ip->nlink--;
    80004e5a:	04a95783          	lhu	a5,74(s2)
    80004e5e:	37fd                	addw	a5,a5,-1
    80004e60:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004e64:	854a                	mv	a0,s2
    80004e66:	bc4fe0ef          	jal	8000322a <iupdate>
  iunlockput(ip);
    80004e6a:	854a                	mv	a0,s2
    80004e6c:	e78fe0ef          	jal	800034e4 <iunlockput>
  end_op();
    80004e70:	e9bfe0ef          	jal	80003d0a <end_op>
  return 0;
    80004e74:	4501                	li	a0,0
    80004e76:	a079                	j	80004f04 <sys_unlink+0x168>
    end_op();
    80004e78:	e93fe0ef          	jal	80003d0a <end_op>
    return -1;
    80004e7c:	557d                	li	a0,-1
    80004e7e:	a059                	j	80004f04 <sys_unlink+0x168>
    panic("unlink: nlink < 1");
    80004e80:	00003517          	auipc	a0,0x3
    80004e84:	87850513          	add	a0,a0,-1928 # 800076f8 <syscalls+0x308>
    80004e88:	917fb0ef          	jal	8000079e <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004e8c:	04c92703          	lw	a4,76(s2)
    80004e90:	02000793          	li	a5,32
    80004e94:	f8e7f9e3          	bgeu	a5,a4,80004e26 <sys_unlink+0x8a>
    80004e98:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004e9c:	4741                	li	a4,16
    80004e9e:	86ce                	mv	a3,s3
    80004ea0:	f1840613          	add	a2,s0,-232
    80004ea4:	4581                	li	a1,0
    80004ea6:	854a                	mv	a0,s2
    80004ea8:	fc2fe0ef          	jal	8000366a <readi>
    80004eac:	47c1                	li	a5,16
    80004eae:	00f51b63          	bne	a0,a5,80004ec4 <sys_unlink+0x128>
    if(de.inum != 0)
    80004eb2:	f1845783          	lhu	a5,-232(s0)
    80004eb6:	ef95                	bnez	a5,80004ef2 <sys_unlink+0x156>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004eb8:	29c1                	addw	s3,s3,16
    80004eba:	04c92783          	lw	a5,76(s2)
    80004ebe:	fcf9efe3          	bltu	s3,a5,80004e9c <sys_unlink+0x100>
    80004ec2:	b795                	j	80004e26 <sys_unlink+0x8a>
      panic("isdirempty: readi");
    80004ec4:	00003517          	auipc	a0,0x3
    80004ec8:	84c50513          	add	a0,a0,-1972 # 80007710 <syscalls+0x320>
    80004ecc:	8d3fb0ef          	jal	8000079e <panic>
    panic("unlink: writei");
    80004ed0:	00003517          	auipc	a0,0x3
    80004ed4:	85850513          	add	a0,a0,-1960 # 80007728 <syscalls+0x338>
    80004ed8:	8c7fb0ef          	jal	8000079e <panic>
    dp->nlink--;
    80004edc:	04a4d783          	lhu	a5,74(s1)
    80004ee0:	37fd                	addw	a5,a5,-1
    80004ee2:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004ee6:	8526                	mv	a0,s1
    80004ee8:	b42fe0ef          	jal	8000322a <iupdate>
    80004eec:	b7a5                	j	80004e54 <sys_unlink+0xb8>
    return -1;
    80004eee:	557d                	li	a0,-1
    80004ef0:	a811                	j	80004f04 <sys_unlink+0x168>
    iunlockput(ip);
    80004ef2:	854a                	mv	a0,s2
    80004ef4:	df0fe0ef          	jal	800034e4 <iunlockput>
  iunlockput(dp);
    80004ef8:	8526                	mv	a0,s1
    80004efa:	deafe0ef          	jal	800034e4 <iunlockput>
  end_op();
    80004efe:	e0dfe0ef          	jal	80003d0a <end_op>
  return -1;
    80004f02:	557d                	li	a0,-1
}
    80004f04:	70ae                	ld	ra,232(sp)
    80004f06:	740e                	ld	s0,224(sp)
    80004f08:	64ee                	ld	s1,216(sp)
    80004f0a:	694e                	ld	s2,208(sp)
    80004f0c:	69ae                	ld	s3,200(sp)
    80004f0e:	616d                	add	sp,sp,240
    80004f10:	8082                	ret

0000000080004f12 <sys_open>:

uint64
sys_open(void)
{
    80004f12:	7131                	add	sp,sp,-192
    80004f14:	fd06                	sd	ra,184(sp)
    80004f16:	f922                	sd	s0,176(sp)
    80004f18:	f526                	sd	s1,168(sp)
    80004f1a:	f14a                	sd	s2,160(sp)
    80004f1c:	ed4e                	sd	s3,152(sp)
    80004f1e:	0180                	add	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004f20:	f4c40593          	add	a1,s0,-180
    80004f24:	4505                	li	a0,1
    80004f26:	91ffd0ef          	jal	80002844 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004f2a:	08000613          	li	a2,128
    80004f2e:	f5040593          	add	a1,s0,-176
    80004f32:	4501                	li	a0,0
    80004f34:	981fd0ef          	jal	800028b4 <argstr>
    80004f38:	87aa                	mv	a5,a0
    return -1;
    80004f3a:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004f3c:	0807cc63          	bltz	a5,80004fd4 <sys_open+0xc2>

  begin_op();
    80004f40:	d61fe0ef          	jal	80003ca0 <begin_op>

  if(omode & O_CREATE){
    80004f44:	f4c42783          	lw	a5,-180(s0)
    80004f48:	2007f793          	and	a5,a5,512
    80004f4c:	cfd9                	beqz	a5,80004fea <sys_open+0xd8>
    ip = create(path, T_FILE, 0, 0);
    80004f4e:	4681                	li	a3,0
    80004f50:	4601                	li	a2,0
    80004f52:	4589                	li	a1,2
    80004f54:	f5040513          	add	a0,s0,-176
    80004f58:	ac7ff0ef          	jal	80004a1e <create>
    80004f5c:	84aa                	mv	s1,a0
    if(ip == 0){
    80004f5e:	c151                	beqz	a0,80004fe2 <sys_open+0xd0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004f60:	04449703          	lh	a4,68(s1)
    80004f64:	478d                	li	a5,3
    80004f66:	00f71763          	bne	a4,a5,80004f74 <sys_open+0x62>
    80004f6a:	0464d703          	lhu	a4,70(s1)
    80004f6e:	47a5                	li	a5,9
    80004f70:	0ae7e863          	bltu	a5,a4,80005020 <sys_open+0x10e>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004f74:	88eff0ef          	jal	80004002 <filealloc>
    80004f78:	892a                	mv	s2,a0
    80004f7a:	cd4d                	beqz	a0,80005034 <sys_open+0x122>
    80004f7c:	a65ff0ef          	jal	800049e0 <fdalloc>
    80004f80:	89aa                	mv	s3,a0
    80004f82:	0a054663          	bltz	a0,8000502e <sys_open+0x11c>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004f86:	04449703          	lh	a4,68(s1)
    80004f8a:	478d                	li	a5,3
    80004f8c:	0af70b63          	beq	a4,a5,80005042 <sys_open+0x130>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004f90:	4789                	li	a5,2
    80004f92:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80004f96:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80004f9a:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80004f9e:	f4c42783          	lw	a5,-180(s0)
    80004fa2:	0017c713          	xor	a4,a5,1
    80004fa6:	8b05                	and	a4,a4,1
    80004fa8:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004fac:	0037f713          	and	a4,a5,3
    80004fb0:	00e03733          	snez	a4,a4
    80004fb4:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004fb8:	4007f793          	and	a5,a5,1024
    80004fbc:	c791                	beqz	a5,80004fc8 <sys_open+0xb6>
    80004fbe:	04449703          	lh	a4,68(s1)
    80004fc2:	4789                	li	a5,2
    80004fc4:	08f70663          	beq	a4,a5,80005050 <sys_open+0x13e>
    itrunc(ip);
  }

  iunlock(ip);
    80004fc8:	8526                	mv	a0,s1
    80004fca:	bbefe0ef          	jal	80003388 <iunlock>
  end_op();
    80004fce:	d3dfe0ef          	jal	80003d0a <end_op>

  return fd;
    80004fd2:	854e                	mv	a0,s3
}
    80004fd4:	70ea                	ld	ra,184(sp)
    80004fd6:	744a                	ld	s0,176(sp)
    80004fd8:	74aa                	ld	s1,168(sp)
    80004fda:	790a                	ld	s2,160(sp)
    80004fdc:	69ea                	ld	s3,152(sp)
    80004fde:	6129                	add	sp,sp,192
    80004fe0:	8082                	ret
      end_op();
    80004fe2:	d29fe0ef          	jal	80003d0a <end_op>
      return -1;
    80004fe6:	557d                	li	a0,-1
    80004fe8:	b7f5                	j	80004fd4 <sys_open+0xc2>
    if((ip = namei(path)) == 0){
    80004fea:	f5040513          	add	a0,s0,-176
    80004fee:	adffe0ef          	jal	80003acc <namei>
    80004ff2:	84aa                	mv	s1,a0
    80004ff4:	c115                	beqz	a0,80005018 <sys_open+0x106>
    ilock(ip);
    80004ff6:	ae8fe0ef          	jal	800032de <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004ffa:	04449703          	lh	a4,68(s1)
    80004ffe:	4785                	li	a5,1
    80005000:	f6f710e3          	bne	a4,a5,80004f60 <sys_open+0x4e>
    80005004:	f4c42783          	lw	a5,-180(s0)
    80005008:	d7b5                	beqz	a5,80004f74 <sys_open+0x62>
      iunlockput(ip);
    8000500a:	8526                	mv	a0,s1
    8000500c:	cd8fe0ef          	jal	800034e4 <iunlockput>
      end_op();
    80005010:	cfbfe0ef          	jal	80003d0a <end_op>
      return -1;
    80005014:	557d                	li	a0,-1
    80005016:	bf7d                	j	80004fd4 <sys_open+0xc2>
      end_op();
    80005018:	cf3fe0ef          	jal	80003d0a <end_op>
      return -1;
    8000501c:	557d                	li	a0,-1
    8000501e:	bf5d                	j	80004fd4 <sys_open+0xc2>
    iunlockput(ip);
    80005020:	8526                	mv	a0,s1
    80005022:	cc2fe0ef          	jal	800034e4 <iunlockput>
    end_op();
    80005026:	ce5fe0ef          	jal	80003d0a <end_op>
    return -1;
    8000502a:	557d                	li	a0,-1
    8000502c:	b765                	j	80004fd4 <sys_open+0xc2>
      fileclose(f);
    8000502e:	854a                	mv	a0,s2
    80005030:	876ff0ef          	jal	800040a6 <fileclose>
    iunlockput(ip);
    80005034:	8526                	mv	a0,s1
    80005036:	caefe0ef          	jal	800034e4 <iunlockput>
    end_op();
    8000503a:	cd1fe0ef          	jal	80003d0a <end_op>
    return -1;
    8000503e:	557d                	li	a0,-1
    80005040:	bf51                	j	80004fd4 <sys_open+0xc2>
    f->type = FD_DEVICE;
    80005042:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80005046:	04649783          	lh	a5,70(s1)
    8000504a:	02f91223          	sh	a5,36(s2)
    8000504e:	b7b1                	j	80004f9a <sys_open+0x88>
    itrunc(ip);
    80005050:	8526                	mv	a0,s1
    80005052:	b76fe0ef          	jal	800033c8 <itrunc>
    80005056:	bf8d                	j	80004fc8 <sys_open+0xb6>

0000000080005058 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005058:	7175                	add	sp,sp,-144
    8000505a:	e506                	sd	ra,136(sp)
    8000505c:	e122                	sd	s0,128(sp)
    8000505e:	0900                	add	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005060:	c41fe0ef          	jal	80003ca0 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80005064:	08000613          	li	a2,128
    80005068:	f7040593          	add	a1,s0,-144
    8000506c:	4501                	li	a0,0
    8000506e:	847fd0ef          	jal	800028b4 <argstr>
    80005072:	02054363          	bltz	a0,80005098 <sys_mkdir+0x40>
    80005076:	4681                	li	a3,0
    80005078:	4601                	li	a2,0
    8000507a:	4585                	li	a1,1
    8000507c:	f7040513          	add	a0,s0,-144
    80005080:	99fff0ef          	jal	80004a1e <create>
    80005084:	c911                	beqz	a0,80005098 <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005086:	c5efe0ef          	jal	800034e4 <iunlockput>
  end_op();
    8000508a:	c81fe0ef          	jal	80003d0a <end_op>
  return 0;
    8000508e:	4501                	li	a0,0
}
    80005090:	60aa                	ld	ra,136(sp)
    80005092:	640a                	ld	s0,128(sp)
    80005094:	6149                	add	sp,sp,144
    80005096:	8082                	ret
    end_op();
    80005098:	c73fe0ef          	jal	80003d0a <end_op>
    return -1;
    8000509c:	557d                	li	a0,-1
    8000509e:	bfcd                	j	80005090 <sys_mkdir+0x38>

00000000800050a0 <sys_mknod>:

uint64
sys_mknod(void)
{
    800050a0:	7135                	add	sp,sp,-160
    800050a2:	ed06                	sd	ra,152(sp)
    800050a4:	e922                	sd	s0,144(sp)
    800050a6:	1100                	add	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    800050a8:	bf9fe0ef          	jal	80003ca0 <begin_op>
  argint(1, &major);
    800050ac:	f6c40593          	add	a1,s0,-148
    800050b0:	4505                	li	a0,1
    800050b2:	f92fd0ef          	jal	80002844 <argint>
  argint(2, &minor);
    800050b6:	f6840593          	add	a1,s0,-152
    800050ba:	4509                	li	a0,2
    800050bc:	f88fd0ef          	jal	80002844 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800050c0:	08000613          	li	a2,128
    800050c4:	f7040593          	add	a1,s0,-144
    800050c8:	4501                	li	a0,0
    800050ca:	feafd0ef          	jal	800028b4 <argstr>
    800050ce:	02054563          	bltz	a0,800050f8 <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    800050d2:	f6841683          	lh	a3,-152(s0)
    800050d6:	f6c41603          	lh	a2,-148(s0)
    800050da:	458d                	li	a1,3
    800050dc:	f7040513          	add	a0,s0,-144
    800050e0:	93fff0ef          	jal	80004a1e <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800050e4:	c911                	beqz	a0,800050f8 <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800050e6:	bfefe0ef          	jal	800034e4 <iunlockput>
  end_op();
    800050ea:	c21fe0ef          	jal	80003d0a <end_op>
  return 0;
    800050ee:	4501                	li	a0,0
}
    800050f0:	60ea                	ld	ra,152(sp)
    800050f2:	644a                	ld	s0,144(sp)
    800050f4:	610d                	add	sp,sp,160
    800050f6:	8082                	ret
    end_op();
    800050f8:	c13fe0ef          	jal	80003d0a <end_op>
    return -1;
    800050fc:	557d                	li	a0,-1
    800050fe:	bfcd                	j	800050f0 <sys_mknod+0x50>

0000000080005100 <sys_chdir>:

uint64
sys_chdir(void)
{
    80005100:	7135                	add	sp,sp,-160
    80005102:	ed06                	sd	ra,152(sp)
    80005104:	e922                	sd	s0,144(sp)
    80005106:	e526                	sd	s1,136(sp)
    80005108:	e14a                	sd	s2,128(sp)
    8000510a:	1100                	add	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    8000510c:	efefc0ef          	jal	8000180a <myproc>
    80005110:	892a                	mv	s2,a0
  
  begin_op();
    80005112:	b8ffe0ef          	jal	80003ca0 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80005116:	08000613          	li	a2,128
    8000511a:	f6040593          	add	a1,s0,-160
    8000511e:	4501                	li	a0,0
    80005120:	f94fd0ef          	jal	800028b4 <argstr>
    80005124:	04054163          	bltz	a0,80005166 <sys_chdir+0x66>
    80005128:	f6040513          	add	a0,s0,-160
    8000512c:	9a1fe0ef          	jal	80003acc <namei>
    80005130:	84aa                	mv	s1,a0
    80005132:	c915                	beqz	a0,80005166 <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    80005134:	9aafe0ef          	jal	800032de <ilock>
  if(ip->type != T_DIR){
    80005138:	04449703          	lh	a4,68(s1)
    8000513c:	4785                	li	a5,1
    8000513e:	02f71863          	bne	a4,a5,8000516e <sys_chdir+0x6e>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005142:	8526                	mv	a0,s1
    80005144:	a44fe0ef          	jal	80003388 <iunlock>
  iput(p->cwd);
    80005148:	15093503          	ld	a0,336(s2)
    8000514c:	b10fe0ef          	jal	8000345c <iput>
  end_op();
    80005150:	bbbfe0ef          	jal	80003d0a <end_op>
  p->cwd = ip;
    80005154:	14993823          	sd	s1,336(s2)
  return 0;
    80005158:	4501                	li	a0,0
}
    8000515a:	60ea                	ld	ra,152(sp)
    8000515c:	644a                	ld	s0,144(sp)
    8000515e:	64aa                	ld	s1,136(sp)
    80005160:	690a                	ld	s2,128(sp)
    80005162:	610d                	add	sp,sp,160
    80005164:	8082                	ret
    end_op();
    80005166:	ba5fe0ef          	jal	80003d0a <end_op>
    return -1;
    8000516a:	557d                	li	a0,-1
    8000516c:	b7fd                	j	8000515a <sys_chdir+0x5a>
    iunlockput(ip);
    8000516e:	8526                	mv	a0,s1
    80005170:	b74fe0ef          	jal	800034e4 <iunlockput>
    end_op();
    80005174:	b97fe0ef          	jal	80003d0a <end_op>
    return -1;
    80005178:	557d                	li	a0,-1
    8000517a:	b7c5                	j	8000515a <sys_chdir+0x5a>

000000008000517c <sys_exec>:

uint64
sys_exec(void)
{
    8000517c:	7121                	add	sp,sp,-448
    8000517e:	ff06                	sd	ra,440(sp)
    80005180:	fb22                	sd	s0,432(sp)
    80005182:	f726                	sd	s1,424(sp)
    80005184:	f34a                	sd	s2,416(sp)
    80005186:	ef4e                	sd	s3,408(sp)
    80005188:	eb52                	sd	s4,400(sp)
    8000518a:	0380                	add	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    8000518c:	e4840593          	add	a1,s0,-440
    80005190:	4505                	li	a0,1
    80005192:	f06fd0ef          	jal	80002898 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80005196:	08000613          	li	a2,128
    8000519a:	f5040593          	add	a1,s0,-176
    8000519e:	4501                	li	a0,0
    800051a0:	f14fd0ef          	jal	800028b4 <argstr>
    800051a4:	87aa                	mv	a5,a0
    return -1;
    800051a6:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    800051a8:	0a07c463          	bltz	a5,80005250 <sys_exec+0xd4>
  }
  memset(argv, 0, sizeof(argv));
    800051ac:	10000613          	li	a2,256
    800051b0:	4581                	li	a1,0
    800051b2:	e5040513          	add	a0,s0,-432
    800051b6:	a93fb0ef          	jal	80000c48 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    800051ba:	e5040493          	add	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    800051be:	89a6                	mv	s3,s1
    800051c0:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    800051c2:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800051c6:	00391513          	sll	a0,s2,0x3
    800051ca:	e4040593          	add	a1,s0,-448
    800051ce:	e4843783          	ld	a5,-440(s0)
    800051d2:	953e                	add	a0,a0,a5
    800051d4:	de6fd0ef          	jal	800027ba <fetchaddr>
    800051d8:	02054663          	bltz	a0,80005204 <sys_exec+0x88>
      goto bad;
    }
    if(uarg == 0){
    800051dc:	e4043783          	ld	a5,-448(s0)
    800051e0:	cf8d                	beqz	a5,8000521a <sys_exec+0x9e>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    800051e2:	8c3fb0ef          	jal	80000aa4 <kalloc>
    800051e6:	85aa                	mv	a1,a0
    800051e8:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    800051ec:	cd01                	beqz	a0,80005204 <sys_exec+0x88>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800051ee:	6605                	lui	a2,0x1
    800051f0:	e4043503          	ld	a0,-448(s0)
    800051f4:	e10fd0ef          	jal	80002804 <fetchstr>
    800051f8:	00054663          	bltz	a0,80005204 <sys_exec+0x88>
    if(i >= NELEM(argv)){
    800051fc:	0905                	add	s2,s2,1
    800051fe:	09a1                	add	s3,s3,8
    80005200:	fd4913e3          	bne	s2,s4,800051c6 <sys_exec+0x4a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005204:	f5040913          	add	s2,s0,-176
    80005208:	6088                	ld	a0,0(s1)
    8000520a:	c131                	beqz	a0,8000524e <sys_exec+0xd2>
    kfree(argv[i]);
    8000520c:	fb6fb0ef          	jal	800009c2 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005210:	04a1                	add	s1,s1,8
    80005212:	ff249be3          	bne	s1,s2,80005208 <sys_exec+0x8c>
  return -1;
    80005216:	557d                	li	a0,-1
    80005218:	a825                	j	80005250 <sys_exec+0xd4>
      argv[i] = 0;
    8000521a:	0009079b          	sext.w	a5,s2
    8000521e:	078e                	sll	a5,a5,0x3
    80005220:	fd078793          	add	a5,a5,-48
    80005224:	97a2                	add	a5,a5,s0
    80005226:	e807b023          	sd	zero,-384(a5)
  int ret = kexec(path, argv);
    8000522a:	e5040593          	add	a1,s0,-432
    8000522e:	f5040513          	add	a0,s0,-176
    80005232:	c1cff0ef          	jal	8000464e <kexec>
    80005236:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005238:	f5040993          	add	s3,s0,-176
    8000523c:	6088                	ld	a0,0(s1)
    8000523e:	c511                	beqz	a0,8000524a <sys_exec+0xce>
    kfree(argv[i]);
    80005240:	f82fb0ef          	jal	800009c2 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005244:	04a1                	add	s1,s1,8
    80005246:	ff349be3          	bne	s1,s3,8000523c <sys_exec+0xc0>
  return ret;
    8000524a:	854a                	mv	a0,s2
    8000524c:	a011                	j	80005250 <sys_exec+0xd4>
  return -1;
    8000524e:	557d                	li	a0,-1
}
    80005250:	70fa                	ld	ra,440(sp)
    80005252:	745a                	ld	s0,432(sp)
    80005254:	74ba                	ld	s1,424(sp)
    80005256:	791a                	ld	s2,416(sp)
    80005258:	69fa                	ld	s3,408(sp)
    8000525a:	6a5a                	ld	s4,400(sp)
    8000525c:	6139                	add	sp,sp,448
    8000525e:	8082                	ret

0000000080005260 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005260:	7139                	add	sp,sp,-64
    80005262:	fc06                	sd	ra,56(sp)
    80005264:	f822                	sd	s0,48(sp)
    80005266:	f426                	sd	s1,40(sp)
    80005268:	0080                	add	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    8000526a:	da0fc0ef          	jal	8000180a <myproc>
    8000526e:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80005270:	fd840593          	add	a1,s0,-40
    80005274:	4501                	li	a0,0
    80005276:	e22fd0ef          	jal	80002898 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    8000527a:	fc840593          	add	a1,s0,-56
    8000527e:	fd040513          	add	a0,s0,-48
    80005282:	8ecff0ef          	jal	8000436e <pipealloc>
    return -1;
    80005286:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005288:	0a054463          	bltz	a0,80005330 <sys_pipe+0xd0>
  fd0 = -1;
    8000528c:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005290:	fd043503          	ld	a0,-48(s0)
    80005294:	f4cff0ef          	jal	800049e0 <fdalloc>
    80005298:	fca42223          	sw	a0,-60(s0)
    8000529c:	08054163          	bltz	a0,8000531e <sys_pipe+0xbe>
    800052a0:	fc843503          	ld	a0,-56(s0)
    800052a4:	f3cff0ef          	jal	800049e0 <fdalloc>
    800052a8:	fca42023          	sw	a0,-64(s0)
    800052ac:	06054063          	bltz	a0,8000530c <sys_pipe+0xac>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800052b0:	4691                	li	a3,4
    800052b2:	fc440613          	add	a2,s0,-60
    800052b6:	fd843583          	ld	a1,-40(s0)
    800052ba:	68a8                	ld	a0,80(s1)
    800052bc:	a9cfc0ef          	jal	80001558 <copyout>
    800052c0:	00054e63          	bltz	a0,800052dc <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800052c4:	4691                	li	a3,4
    800052c6:	fc040613          	add	a2,s0,-64
    800052ca:	fd843583          	ld	a1,-40(s0)
    800052ce:	0591                	add	a1,a1,4
    800052d0:	68a8                	ld	a0,80(s1)
    800052d2:	a86fc0ef          	jal	80001558 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800052d6:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800052d8:	04055c63          	bgez	a0,80005330 <sys_pipe+0xd0>
    p->ofile[fd0] = 0;
    800052dc:	fc442783          	lw	a5,-60(s0)
    800052e0:	07e9                	add	a5,a5,26
    800052e2:	078e                	sll	a5,a5,0x3
    800052e4:	97a6                	add	a5,a5,s1
    800052e6:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    800052ea:	fc042783          	lw	a5,-64(s0)
    800052ee:	07e9                	add	a5,a5,26
    800052f0:	078e                	sll	a5,a5,0x3
    800052f2:	94be                	add	s1,s1,a5
    800052f4:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    800052f8:	fd043503          	ld	a0,-48(s0)
    800052fc:	dabfe0ef          	jal	800040a6 <fileclose>
    fileclose(wf);
    80005300:	fc843503          	ld	a0,-56(s0)
    80005304:	da3fe0ef          	jal	800040a6 <fileclose>
    return -1;
    80005308:	57fd                	li	a5,-1
    8000530a:	a01d                	j	80005330 <sys_pipe+0xd0>
    if(fd0 >= 0)
    8000530c:	fc442783          	lw	a5,-60(s0)
    80005310:	0007c763          	bltz	a5,8000531e <sys_pipe+0xbe>
      p->ofile[fd0] = 0;
    80005314:	07e9                	add	a5,a5,26
    80005316:	078e                	sll	a5,a5,0x3
    80005318:	97a6                	add	a5,a5,s1
    8000531a:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    8000531e:	fd043503          	ld	a0,-48(s0)
    80005322:	d85fe0ef          	jal	800040a6 <fileclose>
    fileclose(wf);
    80005326:	fc843503          	ld	a0,-56(s0)
    8000532a:	d7dfe0ef          	jal	800040a6 <fileclose>
    return -1;
    8000532e:	57fd                	li	a5,-1
}
    80005330:	853e                	mv	a0,a5
    80005332:	70e2                	ld	ra,56(sp)
    80005334:	7442                	ld	s0,48(sp)
    80005336:	74a2                	ld	s1,40(sp)
    80005338:	6121                	add	sp,sp,64
    8000533a:	8082                	ret
    8000533c:	0000                	unimp
	...

0000000080005340 <kernelvec>:
.globl kerneltrap
.globl kernelvec
.align 4
kernelvec:
        # make room to save registers.
        addi sp, sp, -256
    80005340:	7111                	add	sp,sp,-256

        # save caller-saved registers.
        sd ra, 0(sp)
    80005342:	e006                	sd	ra,0(sp)
        # sd sp, 8(sp)
        sd gp, 16(sp)
    80005344:	e80e                	sd	gp,16(sp)
        sd tp, 24(sp)
    80005346:	ec12                	sd	tp,24(sp)
        sd t0, 32(sp)
    80005348:	f016                	sd	t0,32(sp)
        sd t1, 40(sp)
    8000534a:	f41a                	sd	t1,40(sp)
        sd t2, 48(sp)
    8000534c:	f81e                	sd	t2,48(sp)
        sd a0, 72(sp)
    8000534e:	e4aa                	sd	a0,72(sp)
        sd a1, 80(sp)
    80005350:	e8ae                	sd	a1,80(sp)
        sd a2, 88(sp)
    80005352:	ecb2                	sd	a2,88(sp)
        sd a3, 96(sp)
    80005354:	f0b6                	sd	a3,96(sp)
        sd a4, 104(sp)
    80005356:	f4ba                	sd	a4,104(sp)
        sd a5, 112(sp)
    80005358:	f8be                	sd	a5,112(sp)
        sd a6, 120(sp)
    8000535a:	fcc2                	sd	a6,120(sp)
        sd a7, 128(sp)
    8000535c:	e146                	sd	a7,128(sp)
        sd t3, 216(sp)
    8000535e:	edf2                	sd	t3,216(sp)
        sd t4, 224(sp)
    80005360:	f1f6                	sd	t4,224(sp)
        sd t5, 232(sp)
    80005362:	f5fa                	sd	t5,232(sp)
        sd t6, 240(sp)
    80005364:	f9fe                	sd	t6,240(sp)

        # call the C trap handler in trap.c
        call kerneltrap
    80005366:	b64fd0ef          	jal	800026ca <kerneltrap>

        # restore registers.
        ld ra, 0(sp)
    8000536a:	6082                	ld	ra,0(sp)
        # ld sp, 8(sp)
        ld gp, 16(sp)
    8000536c:	61c2                	ld	gp,16(sp)
        # not tp (contains hartid), in case we moved CPUs
        ld t0, 32(sp)
    8000536e:	7282                	ld	t0,32(sp)
        ld t1, 40(sp)
    80005370:	7322                	ld	t1,40(sp)
        ld t2, 48(sp)
    80005372:	73c2                	ld	t2,48(sp)
        ld a0, 72(sp)
    80005374:	6526                	ld	a0,72(sp)
        ld a1, 80(sp)
    80005376:	65c6                	ld	a1,80(sp)
        ld a2, 88(sp)
    80005378:	6666                	ld	a2,88(sp)
        ld a3, 96(sp)
    8000537a:	7686                	ld	a3,96(sp)
        ld a4, 104(sp)
    8000537c:	7726                	ld	a4,104(sp)
        ld a5, 112(sp)
    8000537e:	77c6                	ld	a5,112(sp)
        ld a6, 120(sp)
    80005380:	7866                	ld	a6,120(sp)
        ld a7, 128(sp)
    80005382:	688a                	ld	a7,128(sp)
        ld t3, 216(sp)
    80005384:	6e6e                	ld	t3,216(sp)
        ld t4, 224(sp)
    80005386:	7e8e                	ld	t4,224(sp)
        ld t5, 232(sp)
    80005388:	7f2e                	ld	t5,232(sp)
        ld t6, 240(sp)
    8000538a:	7fce                	ld	t6,240(sp)

        addi sp, sp, 256
    8000538c:	6111                	add	sp,sp,256

        # return to whatever we were doing in the kernel.
        sret
    8000538e:	10200073          	sret
	...

000000008000539e <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000539e:	1141                	add	sp,sp,-16
    800053a0:	e422                	sd	s0,8(sp)
    800053a2:	0800                	add	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800053a4:	0c0007b7          	lui	a5,0xc000
    800053a8:	4705                	li	a4,1
    800053aa:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800053ac:	c3d8                	sw	a4,4(a5)
}
    800053ae:	6422                	ld	s0,8(sp)
    800053b0:	0141                	add	sp,sp,16
    800053b2:	8082                	ret

00000000800053b4 <plicinithart>:

void
plicinithart(void)
{
    800053b4:	1141                	add	sp,sp,-16
    800053b6:	e406                	sd	ra,8(sp)
    800053b8:	e022                	sd	s0,0(sp)
    800053ba:	0800                	add	s0,sp,16
  int hart = cpuid();
    800053bc:	c22fc0ef          	jal	800017de <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800053c0:	0085171b          	sllw	a4,a0,0x8
    800053c4:	0c0027b7          	lui	a5,0xc002
    800053c8:	97ba                	add	a5,a5,a4
    800053ca:	40200713          	li	a4,1026
    800053ce:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800053d2:	00d5151b          	sllw	a0,a0,0xd
    800053d6:	0c2017b7          	lui	a5,0xc201
    800053da:	97aa                	add	a5,a5,a0
    800053dc:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800053e0:	60a2                	ld	ra,8(sp)
    800053e2:	6402                	ld	s0,0(sp)
    800053e4:	0141                	add	sp,sp,16
    800053e6:	8082                	ret

00000000800053e8 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800053e8:	1141                	add	sp,sp,-16
    800053ea:	e406                	sd	ra,8(sp)
    800053ec:	e022                	sd	s0,0(sp)
    800053ee:	0800                	add	s0,sp,16
  int hart = cpuid();
    800053f0:	beefc0ef          	jal	800017de <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800053f4:	00d5151b          	sllw	a0,a0,0xd
    800053f8:	0c2017b7          	lui	a5,0xc201
    800053fc:	97aa                	add	a5,a5,a0
  return irq;
}
    800053fe:	43c8                	lw	a0,4(a5)
    80005400:	60a2                	ld	ra,8(sp)
    80005402:	6402                	ld	s0,0(sp)
    80005404:	0141                	add	sp,sp,16
    80005406:	8082                	ret

0000000080005408 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80005408:	1101                	add	sp,sp,-32
    8000540a:	ec06                	sd	ra,24(sp)
    8000540c:	e822                	sd	s0,16(sp)
    8000540e:	e426                	sd	s1,8(sp)
    80005410:	1000                	add	s0,sp,32
    80005412:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005414:	bcafc0ef          	jal	800017de <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005418:	00d5151b          	sllw	a0,a0,0xd
    8000541c:	0c2017b7          	lui	a5,0xc201
    80005420:	97aa                	add	a5,a5,a0
    80005422:	c3c4                	sw	s1,4(a5)
}
    80005424:	60e2                	ld	ra,24(sp)
    80005426:	6442                	ld	s0,16(sp)
    80005428:	64a2                	ld	s1,8(sp)
    8000542a:	6105                	add	sp,sp,32
    8000542c:	8082                	ret

000000008000542e <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    8000542e:	1141                	add	sp,sp,-16
    80005430:	e406                	sd	ra,8(sp)
    80005432:	e022                	sd	s0,0(sp)
    80005434:	0800                	add	s0,sp,16
  if(i >= NUM)
    80005436:	479d                	li	a5,7
    80005438:	04a7ca63          	blt	a5,a0,8000548c <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    8000543c:	0001c797          	auipc	a5,0x1c
    80005440:	87478793          	add	a5,a5,-1932 # 80020cb0 <disk>
    80005444:	97aa                	add	a5,a5,a0
    80005446:	0187c783          	lbu	a5,24(a5)
    8000544a:	e7b9                	bnez	a5,80005498 <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    8000544c:	00451693          	sll	a3,a0,0x4
    80005450:	0001c797          	auipc	a5,0x1c
    80005454:	86078793          	add	a5,a5,-1952 # 80020cb0 <disk>
    80005458:	6398                	ld	a4,0(a5)
    8000545a:	9736                	add	a4,a4,a3
    8000545c:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    80005460:	6398                	ld	a4,0(a5)
    80005462:	9736                	add	a4,a4,a3
    80005464:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80005468:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    8000546c:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005470:	97aa                	add	a5,a5,a0
    80005472:	4705                	li	a4,1
    80005474:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80005478:	0001c517          	auipc	a0,0x1c
    8000547c:	85050513          	add	a0,a0,-1968 # 80020cc8 <disk+0x18>
    80005480:	a6dfc0ef          	jal	80001eec <wakeup>
}
    80005484:	60a2                	ld	ra,8(sp)
    80005486:	6402                	ld	s0,0(sp)
    80005488:	0141                	add	sp,sp,16
    8000548a:	8082                	ret
    panic("free_desc 1");
    8000548c:	00002517          	auipc	a0,0x2
    80005490:	2ac50513          	add	a0,a0,684 # 80007738 <syscalls+0x348>
    80005494:	b0afb0ef          	jal	8000079e <panic>
    panic("free_desc 2");
    80005498:	00002517          	auipc	a0,0x2
    8000549c:	2b050513          	add	a0,a0,688 # 80007748 <syscalls+0x358>
    800054a0:	afefb0ef          	jal	8000079e <panic>

00000000800054a4 <virtio_disk_init>:
{
    800054a4:	1101                	add	sp,sp,-32
    800054a6:	ec06                	sd	ra,24(sp)
    800054a8:	e822                	sd	s0,16(sp)
    800054aa:	e426                	sd	s1,8(sp)
    800054ac:	e04a                	sd	s2,0(sp)
    800054ae:	1000                	add	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800054b0:	00002597          	auipc	a1,0x2
    800054b4:	2a858593          	add	a1,a1,680 # 80007758 <syscalls+0x368>
    800054b8:	0001c517          	auipc	a0,0x1c
    800054bc:	92050513          	add	a0,a0,-1760 # 80020dd8 <disk+0x128>
    800054c0:	e34fb0ef          	jal	80000af4 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800054c4:	100017b7          	lui	a5,0x10001
    800054c8:	4398                	lw	a4,0(a5)
    800054ca:	2701                	sext.w	a4,a4
    800054cc:	747277b7          	lui	a5,0x74727
    800054d0:	97678793          	add	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800054d4:	12f71f63          	bne	a4,a5,80005612 <virtio_disk_init+0x16e>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800054d8:	100017b7          	lui	a5,0x10001
    800054dc:	43dc                	lw	a5,4(a5)
    800054de:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800054e0:	4709                	li	a4,2
    800054e2:	12e79863          	bne	a5,a4,80005612 <virtio_disk_init+0x16e>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800054e6:	100017b7          	lui	a5,0x10001
    800054ea:	479c                	lw	a5,8(a5)
    800054ec:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800054ee:	12e79263          	bne	a5,a4,80005612 <virtio_disk_init+0x16e>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800054f2:	100017b7          	lui	a5,0x10001
    800054f6:	47d8                	lw	a4,12(a5)
    800054f8:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800054fa:	554d47b7          	lui	a5,0x554d4
    800054fe:	55178793          	add	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005502:	10f71863          	bne	a4,a5,80005612 <virtio_disk_init+0x16e>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005506:	100017b7          	lui	a5,0x10001
    8000550a:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000550e:	4705                	li	a4,1
    80005510:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005512:	470d                	li	a4,3
    80005514:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005516:	4b98                	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005518:	c7ffe6b7          	lui	a3,0xc7ffe
    8000551c:	75f68693          	add	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fdd96f>
    80005520:	8f75                	and	a4,a4,a3
    80005522:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005524:	472d                	li	a4,11
    80005526:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    80005528:	5bbc                	lw	a5,112(a5)
    8000552a:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    8000552e:	8ba1                	and	a5,a5,8
    80005530:	0e078763          	beqz	a5,8000561e <virtio_disk_init+0x17a>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005534:	100017b7          	lui	a5,0x10001
    80005538:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    8000553c:	43fc                	lw	a5,68(a5)
    8000553e:	2781                	sext.w	a5,a5
    80005540:	0e079563          	bnez	a5,8000562a <virtio_disk_init+0x186>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005544:	100017b7          	lui	a5,0x10001
    80005548:	5bdc                	lw	a5,52(a5)
    8000554a:	2781                	sext.w	a5,a5
  if(max == 0)
    8000554c:	0e078563          	beqz	a5,80005636 <virtio_disk_init+0x192>
  if(max < NUM)
    80005550:	471d                	li	a4,7
    80005552:	0ef77863          	bgeu	a4,a5,80005642 <virtio_disk_init+0x19e>
  disk.desc = kalloc();
    80005556:	d4efb0ef          	jal	80000aa4 <kalloc>
    8000555a:	0001b497          	auipc	s1,0x1b
    8000555e:	75648493          	add	s1,s1,1878 # 80020cb0 <disk>
    80005562:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005564:	d40fb0ef          	jal	80000aa4 <kalloc>
    80005568:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000556a:	d3afb0ef          	jal	80000aa4 <kalloc>
    8000556e:	87aa                	mv	a5,a0
    80005570:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80005572:	6088                	ld	a0,0(s1)
    80005574:	cd69                	beqz	a0,8000564e <virtio_disk_init+0x1aa>
    80005576:	0001b717          	auipc	a4,0x1b
    8000557a:	74273703          	ld	a4,1858(a4) # 80020cb8 <disk+0x8>
    8000557e:	cb61                	beqz	a4,8000564e <virtio_disk_init+0x1aa>
    80005580:	c7f9                	beqz	a5,8000564e <virtio_disk_init+0x1aa>
  memset(disk.desc, 0, PGSIZE);
    80005582:	6605                	lui	a2,0x1
    80005584:	4581                	li	a1,0
    80005586:	ec2fb0ef          	jal	80000c48 <memset>
  memset(disk.avail, 0, PGSIZE);
    8000558a:	0001b497          	auipc	s1,0x1b
    8000558e:	72648493          	add	s1,s1,1830 # 80020cb0 <disk>
    80005592:	6605                	lui	a2,0x1
    80005594:	4581                	li	a1,0
    80005596:	6488                	ld	a0,8(s1)
    80005598:	eb0fb0ef          	jal	80000c48 <memset>
  memset(disk.used, 0, PGSIZE);
    8000559c:	6605                	lui	a2,0x1
    8000559e:	4581                	li	a1,0
    800055a0:	6888                	ld	a0,16(s1)
    800055a2:	ea6fb0ef          	jal	80000c48 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800055a6:	100017b7          	lui	a5,0x10001
    800055aa:	4721                	li	a4,8
    800055ac:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    800055ae:	4098                	lw	a4,0(s1)
    800055b0:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    800055b4:	40d8                	lw	a4,4(s1)
    800055b6:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    800055ba:	6498                	ld	a4,8(s1)
    800055bc:	0007069b          	sext.w	a3,a4
    800055c0:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    800055c4:	9701                	sra	a4,a4,0x20
    800055c6:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    800055ca:	6898                	ld	a4,16(s1)
    800055cc:	0007069b          	sext.w	a3,a4
    800055d0:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    800055d4:	9701                	sra	a4,a4,0x20
    800055d6:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    800055da:	4705                	li	a4,1
    800055dc:	c3f8                	sw	a4,68(a5)
    disk.free[i] = 1;
    800055de:	00e48c23          	sb	a4,24(s1)
    800055e2:	00e48ca3          	sb	a4,25(s1)
    800055e6:	00e48d23          	sb	a4,26(s1)
    800055ea:	00e48da3          	sb	a4,27(s1)
    800055ee:	00e48e23          	sb	a4,28(s1)
    800055f2:	00e48ea3          	sb	a4,29(s1)
    800055f6:	00e48f23          	sb	a4,30(s1)
    800055fa:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    800055fe:	00496913          	or	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005602:	0727a823          	sw	s2,112(a5)
}
    80005606:	60e2                	ld	ra,24(sp)
    80005608:	6442                	ld	s0,16(sp)
    8000560a:	64a2                	ld	s1,8(sp)
    8000560c:	6902                	ld	s2,0(sp)
    8000560e:	6105                	add	sp,sp,32
    80005610:	8082                	ret
    panic("could not find virtio disk");
    80005612:	00002517          	auipc	a0,0x2
    80005616:	15650513          	add	a0,a0,342 # 80007768 <syscalls+0x378>
    8000561a:	984fb0ef          	jal	8000079e <panic>
    panic("virtio disk FEATURES_OK unset");
    8000561e:	00002517          	auipc	a0,0x2
    80005622:	16a50513          	add	a0,a0,362 # 80007788 <syscalls+0x398>
    80005626:	978fb0ef          	jal	8000079e <panic>
    panic("virtio disk should not be ready");
    8000562a:	00002517          	auipc	a0,0x2
    8000562e:	17e50513          	add	a0,a0,382 # 800077a8 <syscalls+0x3b8>
    80005632:	96cfb0ef          	jal	8000079e <panic>
    panic("virtio disk has no queue 0");
    80005636:	00002517          	auipc	a0,0x2
    8000563a:	19250513          	add	a0,a0,402 # 800077c8 <syscalls+0x3d8>
    8000563e:	960fb0ef          	jal	8000079e <panic>
    panic("virtio disk max queue too short");
    80005642:	00002517          	auipc	a0,0x2
    80005646:	1a650513          	add	a0,a0,422 # 800077e8 <syscalls+0x3f8>
    8000564a:	954fb0ef          	jal	8000079e <panic>
    panic("virtio disk kalloc");
    8000564e:	00002517          	auipc	a0,0x2
    80005652:	1ba50513          	add	a0,a0,442 # 80007808 <syscalls+0x418>
    80005656:	948fb0ef          	jal	8000079e <panic>

000000008000565a <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    8000565a:	7159                	add	sp,sp,-112
    8000565c:	f486                	sd	ra,104(sp)
    8000565e:	f0a2                	sd	s0,96(sp)
    80005660:	eca6                	sd	s1,88(sp)
    80005662:	e8ca                	sd	s2,80(sp)
    80005664:	e4ce                	sd	s3,72(sp)
    80005666:	e0d2                	sd	s4,64(sp)
    80005668:	fc56                	sd	s5,56(sp)
    8000566a:	f85a                	sd	s6,48(sp)
    8000566c:	f45e                	sd	s7,40(sp)
    8000566e:	f062                	sd	s8,32(sp)
    80005670:	ec66                	sd	s9,24(sp)
    80005672:	e86a                	sd	s10,16(sp)
    80005674:	1880                	add	s0,sp,112
    80005676:	8a2a                	mv	s4,a0
    80005678:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    8000567a:	00c52c83          	lw	s9,12(a0)
    8000567e:	001c9c9b          	sllw	s9,s9,0x1
    80005682:	1c82                	sll	s9,s9,0x20
    80005684:	020cdc93          	srl	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005688:	0001b517          	auipc	a0,0x1b
    8000568c:	75050513          	add	a0,a0,1872 # 80020dd8 <disk+0x128>
    80005690:	ce4fb0ef          	jal	80000b74 <acquire>
  for(int i = 0; i < 3; i++){
    80005694:	4901                	li	s2,0
  for(int i = 0; i < NUM; i++){
    80005696:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005698:	0001bb17          	auipc	s6,0x1b
    8000569c:	618b0b13          	add	s6,s6,1560 # 80020cb0 <disk>
  for(int i = 0; i < 3; i++){
    800056a0:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800056a2:	0001bc17          	auipc	s8,0x1b
    800056a6:	736c0c13          	add	s8,s8,1846 # 80020dd8 <disk+0x128>
    800056aa:	a8b1                	j	80005706 <virtio_disk_rw+0xac>
      disk.free[i] = 0;
    800056ac:	00fb0733          	add	a4,s6,a5
    800056b0:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    800056b4:	c11c                	sw	a5,0(a0)
    if(idx[i] < 0){
    800056b6:	0207c563          	bltz	a5,800056e0 <virtio_disk_rw+0x86>
  for(int i = 0; i < 3; i++){
    800056ba:	2605                	addw	a2,a2,1 # 1001 <_entry-0x7fffefff>
    800056bc:	0591                	add	a1,a1,4
    800056be:	05560963          	beq	a2,s5,80005710 <virtio_disk_rw+0xb6>
    idx[i] = alloc_desc();
    800056c2:	852e                	mv	a0,a1
  for(int i = 0; i < NUM; i++){
    800056c4:	0001b717          	auipc	a4,0x1b
    800056c8:	5ec70713          	add	a4,a4,1516 # 80020cb0 <disk>
    800056cc:	87ca                	mv	a5,s2
    if(disk.free[i]){
    800056ce:	01874683          	lbu	a3,24(a4)
    800056d2:	fee9                	bnez	a3,800056ac <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    800056d4:	2785                	addw	a5,a5,1
    800056d6:	0705                	add	a4,a4,1
    800056d8:	fe979be3          	bne	a5,s1,800056ce <virtio_disk_rw+0x74>
    idx[i] = alloc_desc();
    800056dc:	57fd                	li	a5,-1
    800056de:	c11c                	sw	a5,0(a0)
      for(int j = 0; j < i; j++)
    800056e0:	00c05c63          	blez	a2,800056f8 <virtio_disk_rw+0x9e>
    800056e4:	060a                	sll	a2,a2,0x2
    800056e6:	01360d33          	add	s10,a2,s3
        free_desc(idx[j]);
    800056ea:	0009a503          	lw	a0,0(s3)
    800056ee:	d41ff0ef          	jal	8000542e <free_desc>
      for(int j = 0; j < i; j++)
    800056f2:	0991                	add	s3,s3,4
    800056f4:	ffa99be3          	bne	s3,s10,800056ea <virtio_disk_rw+0x90>
    sleep(&disk.free[0], &disk.vdisk_lock);
    800056f8:	85e2                	mv	a1,s8
    800056fa:	0001b517          	auipc	a0,0x1b
    800056fe:	5ce50513          	add	a0,a0,1486 # 80020cc8 <disk+0x18>
    80005702:	f9efc0ef          	jal	80001ea0 <sleep>
  for(int i = 0; i < 3; i++){
    80005706:	f9040993          	add	s3,s0,-112
{
    8000570a:	85ce                	mv	a1,s3
  for(int i = 0; i < 3; i++){
    8000570c:	864a                	mv	a2,s2
    8000570e:	bf55                	j	800056c2 <virtio_disk_rw+0x68>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005710:	f9042503          	lw	a0,-112(s0)
    80005714:	00a50713          	add	a4,a0,10
    80005718:	0712                	sll	a4,a4,0x4

  if(write)
    8000571a:	0001b797          	auipc	a5,0x1b
    8000571e:	59678793          	add	a5,a5,1430 # 80020cb0 <disk>
    80005722:	00e786b3          	add	a3,a5,a4
    80005726:	01703633          	snez	a2,s7
    8000572a:	c690                	sw	a2,8(a3)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    8000572c:	0006a623          	sw	zero,12(a3)
  buf0->sector = sector;
    80005730:	0196b823          	sd	s9,16(a3)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005734:	f6070613          	add	a2,a4,-160
    80005738:	6394                	ld	a3,0(a5)
    8000573a:	96b2                	add	a3,a3,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000573c:	00870593          	add	a1,a4,8
    80005740:	95be                	add	a1,a1,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005742:	e28c                	sd	a1,0(a3)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005744:	0007b803          	ld	a6,0(a5)
    80005748:	9642                	add	a2,a2,a6
    8000574a:	46c1                	li	a3,16
    8000574c:	c614                	sw	a3,8(a2)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    8000574e:	4585                	li	a1,1
    80005750:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[0]].next = idx[1];
    80005754:	f9442683          	lw	a3,-108(s0)
    80005758:	00d61723          	sh	a3,14(a2)

  disk.desc[idx[1]].addr = (uint64) b->data;
    8000575c:	0692                	sll	a3,a3,0x4
    8000575e:	9836                	add	a6,a6,a3
    80005760:	058a0613          	add	a2,s4,88
    80005764:	00c83023          	sd	a2,0(a6)
  disk.desc[idx[1]].len = BSIZE;
    80005768:	0007b803          	ld	a6,0(a5)
    8000576c:	96c2                	add	a3,a3,a6
    8000576e:	40000613          	li	a2,1024
    80005772:	c690                	sw	a2,8(a3)
  if(write)
    80005774:	001bb613          	seqz	a2,s7
    80005778:	0016161b          	sllw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000577c:	00166613          	or	a2,a2,1
    80005780:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    80005784:	f9842603          	lw	a2,-104(s0)
    80005788:	00c69723          	sh	a2,14(a3)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    8000578c:	00250693          	add	a3,a0,2
    80005790:	0692                	sll	a3,a3,0x4
    80005792:	96be                	add	a3,a3,a5
    80005794:	58fd                	li	a7,-1
    80005796:	01168823          	sb	a7,16(a3)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    8000579a:	0612                	sll	a2,a2,0x4
    8000579c:	9832                	add	a6,a6,a2
    8000579e:	f9070713          	add	a4,a4,-112
    800057a2:	973e                	add	a4,a4,a5
    800057a4:	00e83023          	sd	a4,0(a6)
  disk.desc[idx[2]].len = 1;
    800057a8:	6398                	ld	a4,0(a5)
    800057aa:	9732                	add	a4,a4,a2
    800057ac:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800057ae:	4609                	li	a2,2
    800057b0:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[2]].next = 0;
    800057b4:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800057b8:	00ba2223          	sw	a1,4(s4)
  disk.info[idx[0]].b = b;
    800057bc:	0146b423          	sd	s4,8(a3)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800057c0:	6794                	ld	a3,8(a5)
    800057c2:	0026d703          	lhu	a4,2(a3)
    800057c6:	8b1d                	and	a4,a4,7
    800057c8:	0706                	sll	a4,a4,0x1
    800057ca:	96ba                	add	a3,a3,a4
    800057cc:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    800057d0:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800057d4:	6798                	ld	a4,8(a5)
    800057d6:	00275783          	lhu	a5,2(a4)
    800057da:	2785                	addw	a5,a5,1
    800057dc:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800057e0:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800057e4:	100017b7          	lui	a5,0x10001
    800057e8:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800057ec:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    800057f0:	0001b917          	auipc	s2,0x1b
    800057f4:	5e890913          	add	s2,s2,1512 # 80020dd8 <disk+0x128>
  while(b->disk == 1) {
    800057f8:	4485                	li	s1,1
    800057fa:	00b79a63          	bne	a5,a1,8000580e <virtio_disk_rw+0x1b4>
    sleep(b, &disk.vdisk_lock);
    800057fe:	85ca                	mv	a1,s2
    80005800:	8552                	mv	a0,s4
    80005802:	e9efc0ef          	jal	80001ea0 <sleep>
  while(b->disk == 1) {
    80005806:	004a2783          	lw	a5,4(s4)
    8000580a:	fe978ae3          	beq	a5,s1,800057fe <virtio_disk_rw+0x1a4>
  }

  disk.info[idx[0]].b = 0;
    8000580e:	f9042903          	lw	s2,-112(s0)
    80005812:	00290713          	add	a4,s2,2
    80005816:	0712                	sll	a4,a4,0x4
    80005818:	0001b797          	auipc	a5,0x1b
    8000581c:	49878793          	add	a5,a5,1176 # 80020cb0 <disk>
    80005820:	97ba                	add	a5,a5,a4
    80005822:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80005826:	0001b997          	auipc	s3,0x1b
    8000582a:	48a98993          	add	s3,s3,1162 # 80020cb0 <disk>
    8000582e:	00491713          	sll	a4,s2,0x4
    80005832:	0009b783          	ld	a5,0(s3)
    80005836:	97ba                	add	a5,a5,a4
    80005838:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    8000583c:	854a                	mv	a0,s2
    8000583e:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005842:	bedff0ef          	jal	8000542e <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005846:	8885                	and	s1,s1,1
    80005848:	f0fd                	bnez	s1,8000582e <virtio_disk_rw+0x1d4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000584a:	0001b517          	auipc	a0,0x1b
    8000584e:	58e50513          	add	a0,a0,1422 # 80020dd8 <disk+0x128>
    80005852:	bbafb0ef          	jal	80000c0c <release>
}
    80005856:	70a6                	ld	ra,104(sp)
    80005858:	7406                	ld	s0,96(sp)
    8000585a:	64e6                	ld	s1,88(sp)
    8000585c:	6946                	ld	s2,80(sp)
    8000585e:	69a6                	ld	s3,72(sp)
    80005860:	6a06                	ld	s4,64(sp)
    80005862:	7ae2                	ld	s5,56(sp)
    80005864:	7b42                	ld	s6,48(sp)
    80005866:	7ba2                	ld	s7,40(sp)
    80005868:	7c02                	ld	s8,32(sp)
    8000586a:	6ce2                	ld	s9,24(sp)
    8000586c:	6d42                	ld	s10,16(sp)
    8000586e:	6165                	add	sp,sp,112
    80005870:	8082                	ret

0000000080005872 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005872:	1101                	add	sp,sp,-32
    80005874:	ec06                	sd	ra,24(sp)
    80005876:	e822                	sd	s0,16(sp)
    80005878:	e426                	sd	s1,8(sp)
    8000587a:	1000                	add	s0,sp,32
  acquire(&disk.vdisk_lock);
    8000587c:	0001b497          	auipc	s1,0x1b
    80005880:	43448493          	add	s1,s1,1076 # 80020cb0 <disk>
    80005884:	0001b517          	auipc	a0,0x1b
    80005888:	55450513          	add	a0,a0,1364 # 80020dd8 <disk+0x128>
    8000588c:	ae8fb0ef          	jal	80000b74 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005890:	10001737          	lui	a4,0x10001
    80005894:	533c                	lw	a5,96(a4)
    80005896:	8b8d                	and	a5,a5,3
    80005898:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    8000589a:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    8000589e:	689c                	ld	a5,16(s1)
    800058a0:	0204d703          	lhu	a4,32(s1)
    800058a4:	0027d783          	lhu	a5,2(a5)
    800058a8:	04f70663          	beq	a4,a5,800058f4 <virtio_disk_intr+0x82>
    __sync_synchronize();
    800058ac:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800058b0:	6898                	ld	a4,16(s1)
    800058b2:	0204d783          	lhu	a5,32(s1)
    800058b6:	8b9d                	and	a5,a5,7
    800058b8:	078e                	sll	a5,a5,0x3
    800058ba:	97ba                	add	a5,a5,a4
    800058bc:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800058be:	00278713          	add	a4,a5,2
    800058c2:	0712                	sll	a4,a4,0x4
    800058c4:	9726                	add	a4,a4,s1
    800058c6:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    800058ca:	e321                	bnez	a4,8000590a <virtio_disk_intr+0x98>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800058cc:	0789                	add	a5,a5,2
    800058ce:	0792                	sll	a5,a5,0x4
    800058d0:	97a6                	add	a5,a5,s1
    800058d2:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    800058d4:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800058d8:	e14fc0ef          	jal	80001eec <wakeup>

    disk.used_idx += 1;
    800058dc:	0204d783          	lhu	a5,32(s1)
    800058e0:	2785                	addw	a5,a5,1
    800058e2:	17c2                	sll	a5,a5,0x30
    800058e4:	93c1                	srl	a5,a5,0x30
    800058e6:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800058ea:	6898                	ld	a4,16(s1)
    800058ec:	00275703          	lhu	a4,2(a4)
    800058f0:	faf71ee3          	bne	a4,a5,800058ac <virtio_disk_intr+0x3a>
  }

  release(&disk.vdisk_lock);
    800058f4:	0001b517          	auipc	a0,0x1b
    800058f8:	4e450513          	add	a0,a0,1252 # 80020dd8 <disk+0x128>
    800058fc:	b10fb0ef          	jal	80000c0c <release>
}
    80005900:	60e2                	ld	ra,24(sp)
    80005902:	6442                	ld	s0,16(sp)
    80005904:	64a2                	ld	s1,8(sp)
    80005906:	6105                	add	sp,sp,32
    80005908:	8082                	ret
      panic("virtio_disk_intr status");
    8000590a:	00002517          	auipc	a0,0x2
    8000590e:	f1650513          	add	a0,a0,-234 # 80007820 <syscalls+0x430>
    80005912:	e8dfa0ef          	jal	8000079e <panic>
	...

0000000080006000 <_trampoline>:
    80006000:	14051073          	csrw	sscratch,a0
    80006004:	02000537          	lui	a0,0x2000
    80006008:	357d                	addw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000600a:	0536                	sll	a0,a0,0xd
    8000600c:	02153423          	sd	ra,40(a0)
    80006010:	02253823          	sd	sp,48(a0)
    80006014:	02353c23          	sd	gp,56(a0)
    80006018:	04453023          	sd	tp,64(a0)
    8000601c:	04553423          	sd	t0,72(a0)
    80006020:	04653823          	sd	t1,80(a0)
    80006024:	04753c23          	sd	t2,88(a0)
    80006028:	f120                	sd	s0,96(a0)
    8000602a:	f524                	sd	s1,104(a0)
    8000602c:	fd2c                	sd	a1,120(a0)
    8000602e:	e150                	sd	a2,128(a0)
    80006030:	e554                	sd	a3,136(a0)
    80006032:	e958                	sd	a4,144(a0)
    80006034:	ed5c                	sd	a5,152(a0)
    80006036:	0b053023          	sd	a6,160(a0)
    8000603a:	0b153423          	sd	a7,168(a0)
    8000603e:	0b253823          	sd	s2,176(a0)
    80006042:	0b353c23          	sd	s3,184(a0)
    80006046:	0d453023          	sd	s4,192(a0)
    8000604a:	0d553423          	sd	s5,200(a0)
    8000604e:	0d653823          	sd	s6,208(a0)
    80006052:	0d753c23          	sd	s7,216(a0)
    80006056:	0f853023          	sd	s8,224(a0)
    8000605a:	0f953423          	sd	s9,232(a0)
    8000605e:	0fa53823          	sd	s10,240(a0)
    80006062:	0fb53c23          	sd	s11,248(a0)
    80006066:	11c53023          	sd	t3,256(a0)
    8000606a:	11d53423          	sd	t4,264(a0)
    8000606e:	11e53823          	sd	t5,272(a0)
    80006072:	11f53c23          	sd	t6,280(a0)
    80006076:	140022f3          	csrr	t0,sscratch
    8000607a:	06553823          	sd	t0,112(a0)
    8000607e:	00853103          	ld	sp,8(a0)
    80006082:	02053203          	ld	tp,32(a0)
    80006086:	01053283          	ld	t0,16(a0)
    8000608a:	00053303          	ld	t1,0(a0)
    8000608e:	12000073          	sfence.vma
    80006092:	18031073          	csrw	satp,t1
    80006096:	12000073          	sfence.vma
    8000609a:	9282                	jalr	t0

000000008000609c <userret>:
    8000609c:	12000073          	sfence.vma
    800060a0:	18051073          	csrw	satp,a0
    800060a4:	12000073          	sfence.vma
    800060a8:	02000537          	lui	a0,0x2000
    800060ac:	357d                	addw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800060ae:	0536                	sll	a0,a0,0xd
    800060b0:	02853083          	ld	ra,40(a0)
    800060b4:	03053103          	ld	sp,48(a0)
    800060b8:	03853183          	ld	gp,56(a0)
    800060bc:	04053203          	ld	tp,64(a0)
    800060c0:	04853283          	ld	t0,72(a0)
    800060c4:	05053303          	ld	t1,80(a0)
    800060c8:	05853383          	ld	t2,88(a0)
    800060cc:	7120                	ld	s0,96(a0)
    800060ce:	7524                	ld	s1,104(a0)
    800060d0:	7d2c                	ld	a1,120(a0)
    800060d2:	6150                	ld	a2,128(a0)
    800060d4:	6554                	ld	a3,136(a0)
    800060d6:	6958                	ld	a4,144(a0)
    800060d8:	6d5c                	ld	a5,152(a0)
    800060da:	0a053803          	ld	a6,160(a0)
    800060de:	0a853883          	ld	a7,168(a0)
    800060e2:	0b053903          	ld	s2,176(a0)
    800060e6:	0b853983          	ld	s3,184(a0)
    800060ea:	0c053a03          	ld	s4,192(a0)
    800060ee:	0c853a83          	ld	s5,200(a0)
    800060f2:	0d053b03          	ld	s6,208(a0)
    800060f6:	0d853b83          	ld	s7,216(a0)
    800060fa:	0e053c03          	ld	s8,224(a0)
    800060fe:	0e853c83          	ld	s9,232(a0)
    80006102:	0f053d03          	ld	s10,240(a0)
    80006106:	0f853d83          	ld	s11,248(a0)
    8000610a:	10053e03          	ld	t3,256(a0)
    8000610e:	10853e83          	ld	t4,264(a0)
    80006112:	11053f03          	ld	t5,272(a0)
    80006116:	11853f83          	ld	t6,280(a0)
    8000611a:	7928                	ld	a0,112(a0)
    8000611c:	10200073          	sret
	...
