
user/_testlottery:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#define NSAMPLES  5
#define INTERVAL  200  // ticks between samples

int
main(void)
{
   0:	b8010113          	add	sp,sp,-1152
   4:	46113c23          	sd	ra,1144(sp)
   8:	46813823          	sd	s0,1136(sp)
   c:	46913423          	sd	s1,1128(sp)
  10:	47213023          	sd	s2,1120(sp)
  14:	45313c23          	sd	s3,1112(sp)
  18:	45413823          	sd	s4,1104(sp)
  1c:	45513423          	sd	s5,1096(sp)
  20:	45613023          	sd	s6,1088(sp)
  24:	43713c23          	sd	s7,1080(sp)
  28:	43813823          	sd	s8,1072(sp)
  2c:	48010413          	add	s0,sp,1152
  int pids[3];
  int tickets[3] = {TICKETS_A, TICKETS_B, TICKETS_C};
  30:	47f9                	li	a5,30
  32:	f8f42823          	sw	a5,-112(s0)
  36:	47d1                	li	a5,20
  38:	f8f42a23          	sw	a5,-108(s0)
  3c:	47a9                	li	a5,10
  3e:	f8f42c23          	sw	a5,-104(s0)

  // Fork three children, each inheriting the ticket count set before fork.
  for(int i = 0; i < 3; i++){
  42:	f9040493          	add	s1,s0,-112
  46:	f9c40993          	add	s3,s0,-100
  int tickets[3] = {TICKETS_A, TICKETS_B, TICKETS_C};
  4a:	fa040913          	add	s2,s0,-96
    settickets(tickets[i]);
  4e:	4088                	lw	a0,0(s1)
  50:	432000ef          	jal	482 <settickets>
    pids[i] = fork();
  54:	37e000ef          	jal	3d2 <fork>
  58:	00a92023          	sw	a0,0(s2)
    if(pids[i] == 0){
  5c:	c129                	beqz	a0,9e <main+0x9e>
  for(int i = 0; i < 3; i++){
  5e:	0491                	add	s1,s1,4
  60:	0911                	add	s2,s2,4
  62:	ff3496e3          	bne	s1,s3,4e <main+0x4e>
      for(;;) x++;
    }
  }

  // Parent: reset to 1 ticket so it does not skew the lottery.
  settickets(1);
  66:	4505                	li	a0,1
  68:	41a000ef          	jal	482 <settickets>

  struct pstat st;

  printf("sample\tpid_A\tticks_A\tpid_B\tticks_B\tpid_C\tticks_C\n");
  6c:	00001517          	auipc	a0,0x1
  70:	94450513          	add	a0,a0,-1724 # 9b0 <malloc+0xe0>
  74:	7a8000ef          	jal	81c <printf>

  for(int s = 0; s < NSAMPLES; s++){
  78:	4981                	li	s3,0
    pause(INTERVAL);
    getpinfo(&st);

    printf("%d", s + 1);
  7a:	00001c17          	auipc	s8,0x1
  7e:	96ec0c13          	add	s8,s8,-1682 # 9e8 <malloc+0x118>
  82:	fac40a93          	add	s5,s0,-84
    for(int i = 0; i < 3; i++){
      for(int j = 0; j < NPROC; j++){
  86:	4a01                	li	s4,0
  88:	04000493          	li	s1,64
        if(st.inuse[j] && st.pid[j] == pids[i]){
          printf("\t%d\t%d", st.pid[j], st.ticks[j]);
  8c:	00001b17          	auipc	s6,0x1
  90:	964b0b13          	add	s6,s6,-1692 # 9f0 <malloc+0x120>
          break;
        }
      }
    }
    printf("\n");
  94:	00001b97          	auipc	s7,0x1
  98:	94cb8b93          	add	s7,s7,-1716 # 9e0 <malloc+0x110>
  9c:	a8a9                	j	f6 <main+0xf6>
      volatile long x = 0;
  9e:	b8043423          	sd	zero,-1144(s0)
      for(;;) x++;
  a2:	b8843783          	ld	a5,-1144(s0)
  a6:	0785                	add	a5,a5,1
  a8:	b8f43423          	sd	a5,-1144(s0)
  ac:	bfdd                	j	a2 <main+0xa2>
      for(int j = 0; j < NPROC; j++){
  ae:	2705                	addw	a4,a4,1
  b0:	0791                	add	a5,a5,4
  b2:	02970563          	beq	a4,s1,dc <main+0xdc>
        if(st.inuse[j] && st.pid[j] == pids[i]){
  b6:	4394                	lw	a3,0(a5)
  b8:	dafd                	beqz	a3,ae <main+0xae>
  ba:	2007a583          	lw	a1,512(a5)
  be:	00092683          	lw	a3,0(s2)
  c2:	feb696e3          	bne	a3,a1,ae <main+0xae>
          printf("\t%d\t%d", st.pid[j], st.ticks[j]);
  c6:	0c070793          	add	a5,a4,192
  ca:	078a                	sll	a5,a5,0x2
  cc:	fb078793          	add	a5,a5,-80
  d0:	97a2                	add	a5,a5,s0
  d2:	be07a603          	lw	a2,-1056(a5)
  d6:	855a                	mv	a0,s6
  d8:	744000ef          	jal	81c <printf>
    for(int i = 0; i < 3; i++){
  dc:	0911                	add	s2,s2,4
  de:	01590663          	beq	s2,s5,ea <main+0xea>
      for(int j = 0; j < NPROC; j++){
  e2:	b9040793          	add	a5,s0,-1136
  e6:	8752                	mv	a4,s4
  e8:	b7f9                	j	b6 <main+0xb6>
    printf("\n");
  ea:	855e                	mv	a0,s7
  ec:	730000ef          	jal	81c <printf>
  for(int s = 0; s < NSAMPLES; s++){
  f0:	4795                	li	a5,5
  f2:	02f98263          	beq	s3,a5,116 <main+0x116>
    pause(INTERVAL);
  f6:	0c800513          	li	a0,200
  fa:	370000ef          	jal	46a <pause>
    getpinfo(&st);
  fe:	b9040513          	add	a0,s0,-1136
 102:	388000ef          	jal	48a <getpinfo>
    printf("%d", s + 1);
 106:	2985                	addw	s3,s3,1
 108:	85ce                	mv	a1,s3
 10a:	8562                	mv	a0,s8
 10c:	710000ef          	jal	81c <printf>
 110:	fa040913          	add	s2,s0,-96
 114:	b7f9                	j	e2 <main+0xe2>
  }

  // Kill and reap children.
  for(int i = 0; i < 3; i++)
    kill(pids[i]);
 116:	fa042503          	lw	a0,-96(s0)
 11a:	2f0000ef          	jal	40a <kill>
 11e:	fa442503          	lw	a0,-92(s0)
 122:	2e8000ef          	jal	40a <kill>
 126:	fa842503          	lw	a0,-88(s0)
 12a:	2e0000ef          	jal	40a <kill>
  for(int i = 0; i < 3; i++)
    wait(0);
 12e:	4501                	li	a0,0
 130:	2b2000ef          	jal	3e2 <wait>
 134:	4501                	li	a0,0
 136:	2ac000ef          	jal	3e2 <wait>
 13a:	4501                	li	a0,0
 13c:	2a6000ef          	jal	3e2 <wait>

  exit(0);
 140:	4501                	li	a0,0
 142:	298000ef          	jal	3da <exit>

0000000000000146 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
 146:	1141                	add	sp,sp,-16
 148:	e406                	sd	ra,8(sp)
 14a:	e022                	sd	s0,0(sp)
 14c:	0800                	add	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
 14e:	eb3ff0ef          	jal	0 <main>
  exit(r);
 152:	288000ef          	jal	3da <exit>

0000000000000156 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 156:	1141                	add	sp,sp,-16
 158:	e422                	sd	s0,8(sp)
 15a:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 15c:	87aa                	mv	a5,a0
 15e:	0585                	add	a1,a1,1
 160:	0785                	add	a5,a5,1
 162:	fff5c703          	lbu	a4,-1(a1)
 166:	fee78fa3          	sb	a4,-1(a5)
 16a:	fb75                	bnez	a4,15e <strcpy+0x8>
    ;
  return os;
}
 16c:	6422                	ld	s0,8(sp)
 16e:	0141                	add	sp,sp,16
 170:	8082                	ret

0000000000000172 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 172:	1141                	add	sp,sp,-16
 174:	e422                	sd	s0,8(sp)
 176:	0800                	add	s0,sp,16
  while(*p && *p == *q)
 178:	00054783          	lbu	a5,0(a0)
 17c:	cb91                	beqz	a5,190 <strcmp+0x1e>
 17e:	0005c703          	lbu	a4,0(a1)
 182:	00f71763          	bne	a4,a5,190 <strcmp+0x1e>
    p++, q++;
 186:	0505                	add	a0,a0,1
 188:	0585                	add	a1,a1,1
  while(*p && *p == *q)
 18a:	00054783          	lbu	a5,0(a0)
 18e:	fbe5                	bnez	a5,17e <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 190:	0005c503          	lbu	a0,0(a1)
}
 194:	40a7853b          	subw	a0,a5,a0
 198:	6422                	ld	s0,8(sp)
 19a:	0141                	add	sp,sp,16
 19c:	8082                	ret

000000000000019e <strlen>:

uint
strlen(const char *s)
{
 19e:	1141                	add	sp,sp,-16
 1a0:	e422                	sd	s0,8(sp)
 1a2:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1a4:	00054783          	lbu	a5,0(a0)
 1a8:	cf91                	beqz	a5,1c4 <strlen+0x26>
 1aa:	0505                	add	a0,a0,1
 1ac:	87aa                	mv	a5,a0
 1ae:	86be                	mv	a3,a5
 1b0:	0785                	add	a5,a5,1
 1b2:	fff7c703          	lbu	a4,-1(a5)
 1b6:	ff65                	bnez	a4,1ae <strlen+0x10>
 1b8:	40a6853b          	subw	a0,a3,a0
 1bc:	2505                	addw	a0,a0,1
    ;
  return n;
}
 1be:	6422                	ld	s0,8(sp)
 1c0:	0141                	add	sp,sp,16
 1c2:	8082                	ret
  for(n = 0; s[n]; n++)
 1c4:	4501                	li	a0,0
 1c6:	bfe5                	j	1be <strlen+0x20>

00000000000001c8 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1c8:	1141                	add	sp,sp,-16
 1ca:	e422                	sd	s0,8(sp)
 1cc:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1ce:	ca19                	beqz	a2,1e4 <memset+0x1c>
 1d0:	87aa                	mv	a5,a0
 1d2:	1602                	sll	a2,a2,0x20
 1d4:	9201                	srl	a2,a2,0x20
 1d6:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1da:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1de:	0785                	add	a5,a5,1
 1e0:	fee79de3          	bne	a5,a4,1da <memset+0x12>
  }
  return dst;
}
 1e4:	6422                	ld	s0,8(sp)
 1e6:	0141                	add	sp,sp,16
 1e8:	8082                	ret

00000000000001ea <strchr>:

char*
strchr(const char *s, char c)
{
 1ea:	1141                	add	sp,sp,-16
 1ec:	e422                	sd	s0,8(sp)
 1ee:	0800                	add	s0,sp,16
  for(; *s; s++)
 1f0:	00054783          	lbu	a5,0(a0)
 1f4:	cb99                	beqz	a5,20a <strchr+0x20>
    if(*s == c)
 1f6:	00f58763          	beq	a1,a5,204 <strchr+0x1a>
  for(; *s; s++)
 1fa:	0505                	add	a0,a0,1
 1fc:	00054783          	lbu	a5,0(a0)
 200:	fbfd                	bnez	a5,1f6 <strchr+0xc>
      return (char*)s;
  return 0;
 202:	4501                	li	a0,0
}
 204:	6422                	ld	s0,8(sp)
 206:	0141                	add	sp,sp,16
 208:	8082                	ret
  return 0;
 20a:	4501                	li	a0,0
 20c:	bfe5                	j	204 <strchr+0x1a>

000000000000020e <gets>:

char*
gets(char *buf, int max)
{
 20e:	711d                	add	sp,sp,-96
 210:	ec86                	sd	ra,88(sp)
 212:	e8a2                	sd	s0,80(sp)
 214:	e4a6                	sd	s1,72(sp)
 216:	e0ca                	sd	s2,64(sp)
 218:	fc4e                	sd	s3,56(sp)
 21a:	f852                	sd	s4,48(sp)
 21c:	f456                	sd	s5,40(sp)
 21e:	f05a                	sd	s6,32(sp)
 220:	ec5e                	sd	s7,24(sp)
 222:	1080                	add	s0,sp,96
 224:	8baa                	mv	s7,a0
 226:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 228:	892a                	mv	s2,a0
 22a:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 22c:	4aa9                	li	s5,10
 22e:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 230:	89a6                	mv	s3,s1
 232:	2485                	addw	s1,s1,1
 234:	0344d663          	bge	s1,s4,260 <gets+0x52>
    cc = read(0, &c, 1);
 238:	4605                	li	a2,1
 23a:	faf40593          	add	a1,s0,-81
 23e:	4501                	li	a0,0
 240:	1b2000ef          	jal	3f2 <read>
    if(cc < 1)
 244:	00a05e63          	blez	a0,260 <gets+0x52>
    buf[i++] = c;
 248:	faf44783          	lbu	a5,-81(s0)
 24c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 250:	01578763          	beq	a5,s5,25e <gets+0x50>
 254:	0905                	add	s2,s2,1
 256:	fd679de3          	bne	a5,s6,230 <gets+0x22>
  for(i=0; i+1 < max; ){
 25a:	89a6                	mv	s3,s1
 25c:	a011                	j	260 <gets+0x52>
 25e:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 260:	99de                	add	s3,s3,s7
 262:	00098023          	sb	zero,0(s3)
  return buf;
}
 266:	855e                	mv	a0,s7
 268:	60e6                	ld	ra,88(sp)
 26a:	6446                	ld	s0,80(sp)
 26c:	64a6                	ld	s1,72(sp)
 26e:	6906                	ld	s2,64(sp)
 270:	79e2                	ld	s3,56(sp)
 272:	7a42                	ld	s4,48(sp)
 274:	7aa2                	ld	s5,40(sp)
 276:	7b02                	ld	s6,32(sp)
 278:	6be2                	ld	s7,24(sp)
 27a:	6125                	add	sp,sp,96
 27c:	8082                	ret

000000000000027e <stat>:

int
stat(const char *n, struct stat *st)
{
 27e:	1101                	add	sp,sp,-32
 280:	ec06                	sd	ra,24(sp)
 282:	e822                	sd	s0,16(sp)
 284:	e426                	sd	s1,8(sp)
 286:	e04a                	sd	s2,0(sp)
 288:	1000                	add	s0,sp,32
 28a:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 28c:	4581                	li	a1,0
 28e:	18c000ef          	jal	41a <open>
  if(fd < 0)
 292:	02054163          	bltz	a0,2b4 <stat+0x36>
 296:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 298:	85ca                	mv	a1,s2
 29a:	198000ef          	jal	432 <fstat>
 29e:	892a                	mv	s2,a0
  close(fd);
 2a0:	8526                	mv	a0,s1
 2a2:	160000ef          	jal	402 <close>
  return r;
}
 2a6:	854a                	mv	a0,s2
 2a8:	60e2                	ld	ra,24(sp)
 2aa:	6442                	ld	s0,16(sp)
 2ac:	64a2                	ld	s1,8(sp)
 2ae:	6902                	ld	s2,0(sp)
 2b0:	6105                	add	sp,sp,32
 2b2:	8082                	ret
    return -1;
 2b4:	597d                	li	s2,-1
 2b6:	bfc5                	j	2a6 <stat+0x28>

00000000000002b8 <atoi>:

int
atoi(const char *s)
{
 2b8:	1141                	add	sp,sp,-16
 2ba:	e422                	sd	s0,8(sp)
 2bc:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2be:	00054683          	lbu	a3,0(a0)
 2c2:	fd06879b          	addw	a5,a3,-48
 2c6:	0ff7f793          	zext.b	a5,a5
 2ca:	4625                	li	a2,9
 2cc:	02f66863          	bltu	a2,a5,2fc <atoi+0x44>
 2d0:	872a                	mv	a4,a0
  n = 0;
 2d2:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2d4:	0705                	add	a4,a4,1
 2d6:	0025179b          	sllw	a5,a0,0x2
 2da:	9fa9                	addw	a5,a5,a0
 2dc:	0017979b          	sllw	a5,a5,0x1
 2e0:	9fb5                	addw	a5,a5,a3
 2e2:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2e6:	00074683          	lbu	a3,0(a4)
 2ea:	fd06879b          	addw	a5,a3,-48
 2ee:	0ff7f793          	zext.b	a5,a5
 2f2:	fef671e3          	bgeu	a2,a5,2d4 <atoi+0x1c>
  return n;
}
 2f6:	6422                	ld	s0,8(sp)
 2f8:	0141                	add	sp,sp,16
 2fa:	8082                	ret
  n = 0;
 2fc:	4501                	li	a0,0
 2fe:	bfe5                	j	2f6 <atoi+0x3e>

0000000000000300 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 300:	1141                	add	sp,sp,-16
 302:	e422                	sd	s0,8(sp)
 304:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 306:	02b57463          	bgeu	a0,a1,32e <memmove+0x2e>
    while(n-- > 0)
 30a:	00c05f63          	blez	a2,328 <memmove+0x28>
 30e:	1602                	sll	a2,a2,0x20
 310:	9201                	srl	a2,a2,0x20
 312:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 316:	872a                	mv	a4,a0
      *dst++ = *src++;
 318:	0585                	add	a1,a1,1
 31a:	0705                	add	a4,a4,1
 31c:	fff5c683          	lbu	a3,-1(a1)
 320:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 324:	fee79ae3          	bne	a5,a4,318 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 328:	6422                	ld	s0,8(sp)
 32a:	0141                	add	sp,sp,16
 32c:	8082                	ret
    dst += n;
 32e:	00c50733          	add	a4,a0,a2
    src += n;
 332:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 334:	fec05ae3          	blez	a2,328 <memmove+0x28>
 338:	fff6079b          	addw	a5,a2,-1
 33c:	1782                	sll	a5,a5,0x20
 33e:	9381                	srl	a5,a5,0x20
 340:	fff7c793          	not	a5,a5
 344:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 346:	15fd                	add	a1,a1,-1
 348:	177d                	add	a4,a4,-1
 34a:	0005c683          	lbu	a3,0(a1)
 34e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 352:	fee79ae3          	bne	a5,a4,346 <memmove+0x46>
 356:	bfc9                	j	328 <memmove+0x28>

0000000000000358 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 358:	1141                	add	sp,sp,-16
 35a:	e422                	sd	s0,8(sp)
 35c:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 35e:	ca05                	beqz	a2,38e <memcmp+0x36>
 360:	fff6069b          	addw	a3,a2,-1
 364:	1682                	sll	a3,a3,0x20
 366:	9281                	srl	a3,a3,0x20
 368:	0685                	add	a3,a3,1
 36a:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 36c:	00054783          	lbu	a5,0(a0)
 370:	0005c703          	lbu	a4,0(a1)
 374:	00e79863          	bne	a5,a4,384 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 378:	0505                	add	a0,a0,1
    p2++;
 37a:	0585                	add	a1,a1,1
  while (n-- > 0) {
 37c:	fed518e3          	bne	a0,a3,36c <memcmp+0x14>
  }
  return 0;
 380:	4501                	li	a0,0
 382:	a019                	j	388 <memcmp+0x30>
      return *p1 - *p2;
 384:	40e7853b          	subw	a0,a5,a4
}
 388:	6422                	ld	s0,8(sp)
 38a:	0141                	add	sp,sp,16
 38c:	8082                	ret
  return 0;
 38e:	4501                	li	a0,0
 390:	bfe5                	j	388 <memcmp+0x30>

0000000000000392 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 392:	1141                	add	sp,sp,-16
 394:	e406                	sd	ra,8(sp)
 396:	e022                	sd	s0,0(sp)
 398:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 39a:	f67ff0ef          	jal	300 <memmove>
}
 39e:	60a2                	ld	ra,8(sp)
 3a0:	6402                	ld	s0,0(sp)
 3a2:	0141                	add	sp,sp,16
 3a4:	8082                	ret

00000000000003a6 <sbrk>:

char *
sbrk(int n) {
 3a6:	1141                	add	sp,sp,-16
 3a8:	e406                	sd	ra,8(sp)
 3aa:	e022                	sd	s0,0(sp)
 3ac:	0800                	add	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 3ae:	4585                	li	a1,1
 3b0:	0b2000ef          	jal	462 <sys_sbrk>
}
 3b4:	60a2                	ld	ra,8(sp)
 3b6:	6402                	ld	s0,0(sp)
 3b8:	0141                	add	sp,sp,16
 3ba:	8082                	ret

00000000000003bc <sbrklazy>:

char *
sbrklazy(int n) {
 3bc:	1141                	add	sp,sp,-16
 3be:	e406                	sd	ra,8(sp)
 3c0:	e022                	sd	s0,0(sp)
 3c2:	0800                	add	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 3c4:	4589                	li	a1,2
 3c6:	09c000ef          	jal	462 <sys_sbrk>
}
 3ca:	60a2                	ld	ra,8(sp)
 3cc:	6402                	ld	s0,0(sp)
 3ce:	0141                	add	sp,sp,16
 3d0:	8082                	ret

00000000000003d2 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3d2:	4885                	li	a7,1
 ecall
 3d4:	00000073          	ecall
 ret
 3d8:	8082                	ret

00000000000003da <exit>:
.global exit
exit:
 li a7, SYS_exit
 3da:	4889                	li	a7,2
 ecall
 3dc:	00000073          	ecall
 ret
 3e0:	8082                	ret

00000000000003e2 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3e2:	488d                	li	a7,3
 ecall
 3e4:	00000073          	ecall
 ret
 3e8:	8082                	ret

00000000000003ea <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3ea:	4891                	li	a7,4
 ecall
 3ec:	00000073          	ecall
 ret
 3f0:	8082                	ret

00000000000003f2 <read>:
.global read
read:
 li a7, SYS_read
 3f2:	4895                	li	a7,5
 ecall
 3f4:	00000073          	ecall
 ret
 3f8:	8082                	ret

00000000000003fa <write>:
.global write
write:
 li a7, SYS_write
 3fa:	48c1                	li	a7,16
 ecall
 3fc:	00000073          	ecall
 ret
 400:	8082                	ret

0000000000000402 <close>:
.global close
close:
 li a7, SYS_close
 402:	48d5                	li	a7,21
 ecall
 404:	00000073          	ecall
 ret
 408:	8082                	ret

000000000000040a <kill>:
.global kill
kill:
 li a7, SYS_kill
 40a:	4899                	li	a7,6
 ecall
 40c:	00000073          	ecall
 ret
 410:	8082                	ret

0000000000000412 <exec>:
.global exec
exec:
 li a7, SYS_exec
 412:	489d                	li	a7,7
 ecall
 414:	00000073          	ecall
 ret
 418:	8082                	ret

000000000000041a <open>:
.global open
open:
 li a7, SYS_open
 41a:	48bd                	li	a7,15
 ecall
 41c:	00000073          	ecall
 ret
 420:	8082                	ret

0000000000000422 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 422:	48c5                	li	a7,17
 ecall
 424:	00000073          	ecall
 ret
 428:	8082                	ret

000000000000042a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 42a:	48c9                	li	a7,18
 ecall
 42c:	00000073          	ecall
 ret
 430:	8082                	ret

0000000000000432 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 432:	48a1                	li	a7,8
 ecall
 434:	00000073          	ecall
 ret
 438:	8082                	ret

000000000000043a <link>:
.global link
link:
 li a7, SYS_link
 43a:	48cd                	li	a7,19
 ecall
 43c:	00000073          	ecall
 ret
 440:	8082                	ret

0000000000000442 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 442:	48d1                	li	a7,20
 ecall
 444:	00000073          	ecall
 ret
 448:	8082                	ret

000000000000044a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 44a:	48a5                	li	a7,9
 ecall
 44c:	00000073          	ecall
 ret
 450:	8082                	ret

0000000000000452 <dup>:
.global dup
dup:
 li a7, SYS_dup
 452:	48a9                	li	a7,10
 ecall
 454:	00000073          	ecall
 ret
 458:	8082                	ret

000000000000045a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 45a:	48ad                	li	a7,11
 ecall
 45c:	00000073          	ecall
 ret
 460:	8082                	ret

0000000000000462 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 462:	48b1                	li	a7,12
 ecall
 464:	00000073          	ecall
 ret
 468:	8082                	ret

000000000000046a <pause>:
.global pause
pause:
 li a7, SYS_pause
 46a:	48b5                	li	a7,13
 ecall
 46c:	00000073          	ecall
 ret
 470:	8082                	ret

0000000000000472 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 472:	48b9                	li	a7,14
 ecall
 474:	00000073          	ecall
 ret
 478:	8082                	ret

000000000000047a <getcnt>:
.global getcnt
getcnt:
 li a7, SYS_getcnt
 47a:	48d9                	li	a7,22
 ecall
 47c:	00000073          	ecall
 ret
 480:	8082                	ret

0000000000000482 <settickets>:
.global settickets
settickets:
 li a7, SYS_settickets
 482:	48dd                	li	a7,23
 ecall
 484:	00000073          	ecall
 ret
 488:	8082                	ret

000000000000048a <getpinfo>:
.global getpinfo
getpinfo:
 li a7, SYS_getpinfo
 48a:	48e1                	li	a7,24
 ecall
 48c:	00000073          	ecall
 ret
 490:	8082                	ret

0000000000000492 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 492:	1101                	add	sp,sp,-32
 494:	ec06                	sd	ra,24(sp)
 496:	e822                	sd	s0,16(sp)
 498:	1000                	add	s0,sp,32
 49a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 49e:	4605                	li	a2,1
 4a0:	fef40593          	add	a1,s0,-17
 4a4:	f57ff0ef          	jal	3fa <write>
}
 4a8:	60e2                	ld	ra,24(sp)
 4aa:	6442                	ld	s0,16(sp)
 4ac:	6105                	add	sp,sp,32
 4ae:	8082                	ret

00000000000004b0 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 4b0:	715d                	add	sp,sp,-80
 4b2:	e486                	sd	ra,72(sp)
 4b4:	e0a2                	sd	s0,64(sp)
 4b6:	fc26                	sd	s1,56(sp)
 4b8:	f84a                	sd	s2,48(sp)
 4ba:	f44e                	sd	s3,40(sp)
 4bc:	0880                	add	s0,sp,80
 4be:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 4c0:	c299                	beqz	a3,4c6 <printint+0x16>
 4c2:	0805c163          	bltz	a1,544 <printint+0x94>
  neg = 0;
 4c6:	4881                	li	a7,0
 4c8:	fb840693          	add	a3,s0,-72
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 4cc:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 4ce:	00000517          	auipc	a0,0x0
 4d2:	53250513          	add	a0,a0,1330 # a00 <digits>
 4d6:	883e                	mv	a6,a5
 4d8:	2785                	addw	a5,a5,1
 4da:	02c5f733          	remu	a4,a1,a2
 4de:	972a                	add	a4,a4,a0
 4e0:	00074703          	lbu	a4,0(a4)
 4e4:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 4e8:	872e                	mv	a4,a1
 4ea:	02c5d5b3          	divu	a1,a1,a2
 4ee:	0685                	add	a3,a3,1
 4f0:	fec773e3          	bgeu	a4,a2,4d6 <printint+0x26>
  if(neg)
 4f4:	00088b63          	beqz	a7,50a <printint+0x5a>
    buf[i++] = '-';
 4f8:	fd078793          	add	a5,a5,-48
 4fc:	97a2                	add	a5,a5,s0
 4fe:	02d00713          	li	a4,45
 502:	fee78423          	sb	a4,-24(a5)
 506:	0028079b          	addw	a5,a6,2

  while(--i >= 0)
 50a:	02f05663          	blez	a5,536 <printint+0x86>
 50e:	fb840713          	add	a4,s0,-72
 512:	00f704b3          	add	s1,a4,a5
 516:	fff70993          	add	s3,a4,-1
 51a:	99be                	add	s3,s3,a5
 51c:	37fd                	addw	a5,a5,-1
 51e:	1782                	sll	a5,a5,0x20
 520:	9381                	srl	a5,a5,0x20
 522:	40f989b3          	sub	s3,s3,a5
    putc(fd, buf[i]);
 526:	fff4c583          	lbu	a1,-1(s1)
 52a:	854a                	mv	a0,s2
 52c:	f67ff0ef          	jal	492 <putc>
  while(--i >= 0)
 530:	14fd                	add	s1,s1,-1
 532:	ff349ae3          	bne	s1,s3,526 <printint+0x76>
}
 536:	60a6                	ld	ra,72(sp)
 538:	6406                	ld	s0,64(sp)
 53a:	74e2                	ld	s1,56(sp)
 53c:	7942                	ld	s2,48(sp)
 53e:	79a2                	ld	s3,40(sp)
 540:	6161                	add	sp,sp,80
 542:	8082                	ret
    x = -xx;
 544:	40b005b3          	neg	a1,a1
    neg = 1;
 548:	4885                	li	a7,1
    x = -xx;
 54a:	bfbd                	j	4c8 <printint+0x18>

000000000000054c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 54c:	711d                	add	sp,sp,-96
 54e:	ec86                	sd	ra,88(sp)
 550:	e8a2                	sd	s0,80(sp)
 552:	e4a6                	sd	s1,72(sp)
 554:	e0ca                	sd	s2,64(sp)
 556:	fc4e                	sd	s3,56(sp)
 558:	f852                	sd	s4,48(sp)
 55a:	f456                	sd	s5,40(sp)
 55c:	f05a                	sd	s6,32(sp)
 55e:	ec5e                	sd	s7,24(sp)
 560:	e862                	sd	s8,16(sp)
 562:	e466                	sd	s9,8(sp)
 564:	e06a                	sd	s10,0(sp)
 566:	1080                	add	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 568:	0005c903          	lbu	s2,0(a1)
 56c:	26090563          	beqz	s2,7d6 <vprintf+0x28a>
 570:	8b2a                	mv	s6,a0
 572:	8a2e                	mv	s4,a1
 574:	8bb2                	mv	s7,a2
  state = 0;
 576:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 578:	4481                	li	s1,0
 57a:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 57c:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 580:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 584:	06c00c93          	li	s9,108
 588:	a005                	j	5a8 <vprintf+0x5c>
        putc(fd, c0);
 58a:	85ca                	mv	a1,s2
 58c:	855a                	mv	a0,s6
 58e:	f05ff0ef          	jal	492 <putc>
 592:	a019                	j	598 <vprintf+0x4c>
    } else if(state == '%'){
 594:	03598263          	beq	s3,s5,5b8 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 598:	2485                	addw	s1,s1,1
 59a:	8726                	mv	a4,s1
 59c:	009a07b3          	add	a5,s4,s1
 5a0:	0007c903          	lbu	s2,0(a5)
 5a4:	22090963          	beqz	s2,7d6 <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
 5a8:	0009079b          	sext.w	a5,s2
    if(state == 0){
 5ac:	fe0994e3          	bnez	s3,594 <vprintf+0x48>
      if(c0 == '%'){
 5b0:	fd579de3          	bne	a5,s5,58a <vprintf+0x3e>
        state = '%';
 5b4:	89be                	mv	s3,a5
 5b6:	b7cd                	j	598 <vprintf+0x4c>
      if(c0) c1 = fmt[i+1] & 0xff;
 5b8:	cbc9                	beqz	a5,64a <vprintf+0xfe>
 5ba:	00ea06b3          	add	a3,s4,a4
 5be:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 5c2:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 5c4:	c681                	beqz	a3,5cc <vprintf+0x80>
 5c6:	9752                	add	a4,a4,s4
 5c8:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 5cc:	05878363          	beq	a5,s8,612 <vprintf+0xc6>
      } else if(c0 == 'l' && c1 == 'd'){
 5d0:	05978d63          	beq	a5,s9,62a <vprintf+0xde>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 5d4:	07500713          	li	a4,117
 5d8:	0ee78763          	beq	a5,a4,6c6 <vprintf+0x17a>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 5dc:	07800713          	li	a4,120
 5e0:	12e78963          	beq	a5,a4,712 <vprintf+0x1c6>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 5e4:	07000713          	li	a4,112
 5e8:	14e78e63          	beq	a5,a4,744 <vprintf+0x1f8>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 5ec:	06300713          	li	a4,99
 5f0:	18e78c63          	beq	a5,a4,788 <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 5f4:	07300713          	li	a4,115
 5f8:	1ae78263          	beq	a5,a4,79c <vprintf+0x250>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 5fc:	02500713          	li	a4,37
 600:	04e79563          	bne	a5,a4,64a <vprintf+0xfe>
        putc(fd, '%');
 604:	02500593          	li	a1,37
 608:	855a                	mv	a0,s6
 60a:	e89ff0ef          	jal	492 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 60e:	4981                	li	s3,0
 610:	b761                	j	598 <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 10, 1);
 612:	008b8913          	add	s2,s7,8
 616:	4685                	li	a3,1
 618:	4629                	li	a2,10
 61a:	000ba583          	lw	a1,0(s7)
 61e:	855a                	mv	a0,s6
 620:	e91ff0ef          	jal	4b0 <printint>
 624:	8bca                	mv	s7,s2
      state = 0;
 626:	4981                	li	s3,0
 628:	bf85                	j	598 <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'd'){
 62a:	06400793          	li	a5,100
 62e:	02f68963          	beq	a3,a5,660 <vprintf+0x114>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 632:	06c00793          	li	a5,108
 636:	04f68263          	beq	a3,a5,67a <vprintf+0x12e>
      } else if(c0 == 'l' && c1 == 'u'){
 63a:	07500793          	li	a5,117
 63e:	0af68063          	beq	a3,a5,6de <vprintf+0x192>
      } else if(c0 == 'l' && c1 == 'x'){
 642:	07800793          	li	a5,120
 646:	0ef68263          	beq	a3,a5,72a <vprintf+0x1de>
        putc(fd, '%');
 64a:	02500593          	li	a1,37
 64e:	855a                	mv	a0,s6
 650:	e43ff0ef          	jal	492 <putc>
        putc(fd, c0);
 654:	85ca                	mv	a1,s2
 656:	855a                	mv	a0,s6
 658:	e3bff0ef          	jal	492 <putc>
      state = 0;
 65c:	4981                	li	s3,0
 65e:	bf2d                	j	598 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 660:	008b8913          	add	s2,s7,8
 664:	4685                	li	a3,1
 666:	4629                	li	a2,10
 668:	000bb583          	ld	a1,0(s7)
 66c:	855a                	mv	a0,s6
 66e:	e43ff0ef          	jal	4b0 <printint>
        i += 1;
 672:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 674:	8bca                	mv	s7,s2
      state = 0;
 676:	4981                	li	s3,0
        i += 1;
 678:	b705                	j	598 <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 67a:	06400793          	li	a5,100
 67e:	02f60763          	beq	a2,a5,6ac <vprintf+0x160>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 682:	07500793          	li	a5,117
 686:	06f60963          	beq	a2,a5,6f8 <vprintf+0x1ac>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 68a:	07800793          	li	a5,120
 68e:	faf61ee3          	bne	a2,a5,64a <vprintf+0xfe>
        printint(fd, va_arg(ap, uint64), 16, 0);
 692:	008b8913          	add	s2,s7,8
 696:	4681                	li	a3,0
 698:	4641                	li	a2,16
 69a:	000bb583          	ld	a1,0(s7)
 69e:	855a                	mv	a0,s6
 6a0:	e11ff0ef          	jal	4b0 <printint>
        i += 2;
 6a4:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 6a6:	8bca                	mv	s7,s2
      state = 0;
 6a8:	4981                	li	s3,0
        i += 2;
 6aa:	b5fd                	j	598 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6ac:	008b8913          	add	s2,s7,8
 6b0:	4685                	li	a3,1
 6b2:	4629                	li	a2,10
 6b4:	000bb583          	ld	a1,0(s7)
 6b8:	855a                	mv	a0,s6
 6ba:	df7ff0ef          	jal	4b0 <printint>
        i += 2;
 6be:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 6c0:	8bca                	mv	s7,s2
      state = 0;
 6c2:	4981                	li	s3,0
        i += 2;
 6c4:	bdd1                	j	598 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint32), 10, 0);
 6c6:	008b8913          	add	s2,s7,8
 6ca:	4681                	li	a3,0
 6cc:	4629                	li	a2,10
 6ce:	000be583          	lwu	a1,0(s7)
 6d2:	855a                	mv	a0,s6
 6d4:	dddff0ef          	jal	4b0 <printint>
 6d8:	8bca                	mv	s7,s2
      state = 0;
 6da:	4981                	li	s3,0
 6dc:	bd75                	j	598 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6de:	008b8913          	add	s2,s7,8
 6e2:	4681                	li	a3,0
 6e4:	4629                	li	a2,10
 6e6:	000bb583          	ld	a1,0(s7)
 6ea:	855a                	mv	a0,s6
 6ec:	dc5ff0ef          	jal	4b0 <printint>
        i += 1;
 6f0:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 6f2:	8bca                	mv	s7,s2
      state = 0;
 6f4:	4981                	li	s3,0
        i += 1;
 6f6:	b54d                	j	598 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6f8:	008b8913          	add	s2,s7,8
 6fc:	4681                	li	a3,0
 6fe:	4629                	li	a2,10
 700:	000bb583          	ld	a1,0(s7)
 704:	855a                	mv	a0,s6
 706:	dabff0ef          	jal	4b0 <printint>
        i += 2;
 70a:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 70c:	8bca                	mv	s7,s2
      state = 0;
 70e:	4981                	li	s3,0
        i += 2;
 710:	b561                	j	598 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint32), 16, 0);
 712:	008b8913          	add	s2,s7,8
 716:	4681                	li	a3,0
 718:	4641                	li	a2,16
 71a:	000be583          	lwu	a1,0(s7)
 71e:	855a                	mv	a0,s6
 720:	d91ff0ef          	jal	4b0 <printint>
 724:	8bca                	mv	s7,s2
      state = 0;
 726:	4981                	li	s3,0
 728:	bd85                	j	598 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 16, 0);
 72a:	008b8913          	add	s2,s7,8
 72e:	4681                	li	a3,0
 730:	4641                	li	a2,16
 732:	000bb583          	ld	a1,0(s7)
 736:	855a                	mv	a0,s6
 738:	d79ff0ef          	jal	4b0 <printint>
        i += 1;
 73c:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 73e:	8bca                	mv	s7,s2
      state = 0;
 740:	4981                	li	s3,0
        i += 1;
 742:	bd99                	j	598 <vprintf+0x4c>
        printptr(fd, va_arg(ap, uint64));
 744:	008b8d13          	add	s10,s7,8
 748:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 74c:	03000593          	li	a1,48
 750:	855a                	mv	a0,s6
 752:	d41ff0ef          	jal	492 <putc>
  putc(fd, 'x');
 756:	07800593          	li	a1,120
 75a:	855a                	mv	a0,s6
 75c:	d37ff0ef          	jal	492 <putc>
 760:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 762:	00000b97          	auipc	s7,0x0
 766:	29eb8b93          	add	s7,s7,670 # a00 <digits>
 76a:	03c9d793          	srl	a5,s3,0x3c
 76e:	97de                	add	a5,a5,s7
 770:	0007c583          	lbu	a1,0(a5)
 774:	855a                	mv	a0,s6
 776:	d1dff0ef          	jal	492 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 77a:	0992                	sll	s3,s3,0x4
 77c:	397d                	addw	s2,s2,-1
 77e:	fe0916e3          	bnez	s2,76a <vprintf+0x21e>
        printptr(fd, va_arg(ap, uint64));
 782:	8bea                	mv	s7,s10
      state = 0;
 784:	4981                	li	s3,0
 786:	bd09                	j	598 <vprintf+0x4c>
        putc(fd, va_arg(ap, uint32));
 788:	008b8913          	add	s2,s7,8
 78c:	000bc583          	lbu	a1,0(s7)
 790:	855a                	mv	a0,s6
 792:	d01ff0ef          	jal	492 <putc>
 796:	8bca                	mv	s7,s2
      state = 0;
 798:	4981                	li	s3,0
 79a:	bbfd                	j	598 <vprintf+0x4c>
        if((s = va_arg(ap, char*)) == 0)
 79c:	008b8993          	add	s3,s7,8
 7a0:	000bb903          	ld	s2,0(s7)
 7a4:	00090f63          	beqz	s2,7c2 <vprintf+0x276>
        for(; *s; s++)
 7a8:	00094583          	lbu	a1,0(s2)
 7ac:	c195                	beqz	a1,7d0 <vprintf+0x284>
          putc(fd, *s);
 7ae:	855a                	mv	a0,s6
 7b0:	ce3ff0ef          	jal	492 <putc>
        for(; *s; s++)
 7b4:	0905                	add	s2,s2,1
 7b6:	00094583          	lbu	a1,0(s2)
 7ba:	f9f5                	bnez	a1,7ae <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 7bc:	8bce                	mv	s7,s3
      state = 0;
 7be:	4981                	li	s3,0
 7c0:	bbe1                	j	598 <vprintf+0x4c>
          s = "(null)";
 7c2:	00000917          	auipc	s2,0x0
 7c6:	23690913          	add	s2,s2,566 # 9f8 <malloc+0x128>
        for(; *s; s++)
 7ca:	02800593          	li	a1,40
 7ce:	b7c5                	j	7ae <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 7d0:	8bce                	mv	s7,s3
      state = 0;
 7d2:	4981                	li	s3,0
 7d4:	b3d1                	j	598 <vprintf+0x4c>
    }
  }
}
 7d6:	60e6                	ld	ra,88(sp)
 7d8:	6446                	ld	s0,80(sp)
 7da:	64a6                	ld	s1,72(sp)
 7dc:	6906                	ld	s2,64(sp)
 7de:	79e2                	ld	s3,56(sp)
 7e0:	7a42                	ld	s4,48(sp)
 7e2:	7aa2                	ld	s5,40(sp)
 7e4:	7b02                	ld	s6,32(sp)
 7e6:	6be2                	ld	s7,24(sp)
 7e8:	6c42                	ld	s8,16(sp)
 7ea:	6ca2                	ld	s9,8(sp)
 7ec:	6d02                	ld	s10,0(sp)
 7ee:	6125                	add	sp,sp,96
 7f0:	8082                	ret

00000000000007f2 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7f2:	715d                	add	sp,sp,-80
 7f4:	ec06                	sd	ra,24(sp)
 7f6:	e822                	sd	s0,16(sp)
 7f8:	1000                	add	s0,sp,32
 7fa:	e010                	sd	a2,0(s0)
 7fc:	e414                	sd	a3,8(s0)
 7fe:	e818                	sd	a4,16(s0)
 800:	ec1c                	sd	a5,24(s0)
 802:	03043023          	sd	a6,32(s0)
 806:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 80a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 80e:	8622                	mv	a2,s0
 810:	d3dff0ef          	jal	54c <vprintf>
}
 814:	60e2                	ld	ra,24(sp)
 816:	6442                	ld	s0,16(sp)
 818:	6161                	add	sp,sp,80
 81a:	8082                	ret

000000000000081c <printf>:

void
printf(const char *fmt, ...)
{
 81c:	711d                	add	sp,sp,-96
 81e:	ec06                	sd	ra,24(sp)
 820:	e822                	sd	s0,16(sp)
 822:	1000                	add	s0,sp,32
 824:	e40c                	sd	a1,8(s0)
 826:	e810                	sd	a2,16(s0)
 828:	ec14                	sd	a3,24(s0)
 82a:	f018                	sd	a4,32(s0)
 82c:	f41c                	sd	a5,40(s0)
 82e:	03043823          	sd	a6,48(s0)
 832:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 836:	00840613          	add	a2,s0,8
 83a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 83e:	85aa                	mv	a1,a0
 840:	4505                	li	a0,1
 842:	d0bff0ef          	jal	54c <vprintf>
}
 846:	60e2                	ld	ra,24(sp)
 848:	6442                	ld	s0,16(sp)
 84a:	6125                	add	sp,sp,96
 84c:	8082                	ret

000000000000084e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 84e:	1141                	add	sp,sp,-16
 850:	e422                	sd	s0,8(sp)
 852:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 854:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 858:	00000797          	auipc	a5,0x0
 85c:	7a87b783          	ld	a5,1960(a5) # 1000 <freep>
 860:	a02d                	j	88a <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 862:	4618                	lw	a4,8(a2)
 864:	9f2d                	addw	a4,a4,a1
 866:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 86a:	6398                	ld	a4,0(a5)
 86c:	6310                	ld	a2,0(a4)
 86e:	a83d                	j	8ac <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 870:	ff852703          	lw	a4,-8(a0)
 874:	9f31                	addw	a4,a4,a2
 876:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 878:	ff053683          	ld	a3,-16(a0)
 87c:	a091                	j	8c0 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 87e:	6398                	ld	a4,0(a5)
 880:	00e7e463          	bltu	a5,a4,888 <free+0x3a>
 884:	00e6ea63          	bltu	a3,a4,898 <free+0x4a>
{
 888:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 88a:	fed7fae3          	bgeu	a5,a3,87e <free+0x30>
 88e:	6398                	ld	a4,0(a5)
 890:	00e6e463          	bltu	a3,a4,898 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 894:	fee7eae3          	bltu	a5,a4,888 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 898:	ff852583          	lw	a1,-8(a0)
 89c:	6390                	ld	a2,0(a5)
 89e:	02059813          	sll	a6,a1,0x20
 8a2:	01c85713          	srl	a4,a6,0x1c
 8a6:	9736                	add	a4,a4,a3
 8a8:	fae60de3          	beq	a2,a4,862 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 8ac:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 8b0:	4790                	lw	a2,8(a5)
 8b2:	02061593          	sll	a1,a2,0x20
 8b6:	01c5d713          	srl	a4,a1,0x1c
 8ba:	973e                	add	a4,a4,a5
 8bc:	fae68ae3          	beq	a3,a4,870 <free+0x22>
    p->s.ptr = bp->s.ptr;
 8c0:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 8c2:	00000717          	auipc	a4,0x0
 8c6:	72f73f23          	sd	a5,1854(a4) # 1000 <freep>
}
 8ca:	6422                	ld	s0,8(sp)
 8cc:	0141                	add	sp,sp,16
 8ce:	8082                	ret

00000000000008d0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8d0:	7139                	add	sp,sp,-64
 8d2:	fc06                	sd	ra,56(sp)
 8d4:	f822                	sd	s0,48(sp)
 8d6:	f426                	sd	s1,40(sp)
 8d8:	f04a                	sd	s2,32(sp)
 8da:	ec4e                	sd	s3,24(sp)
 8dc:	e852                	sd	s4,16(sp)
 8de:	e456                	sd	s5,8(sp)
 8e0:	e05a                	sd	s6,0(sp)
 8e2:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8e4:	02051493          	sll	s1,a0,0x20
 8e8:	9081                	srl	s1,s1,0x20
 8ea:	04bd                	add	s1,s1,15
 8ec:	8091                	srl	s1,s1,0x4
 8ee:	0014899b          	addw	s3,s1,1
 8f2:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 8f4:	00000517          	auipc	a0,0x0
 8f8:	70c53503          	ld	a0,1804(a0) # 1000 <freep>
 8fc:	c515                	beqz	a0,928 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8fe:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 900:	4798                	lw	a4,8(a5)
 902:	02977f63          	bgeu	a4,s1,940 <malloc+0x70>
  if(nu < 4096)
 906:	8a4e                	mv	s4,s3
 908:	0009871b          	sext.w	a4,s3
 90c:	6685                	lui	a3,0x1
 90e:	00d77363          	bgeu	a4,a3,914 <malloc+0x44>
 912:	6a05                	lui	s4,0x1
 914:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 918:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 91c:	00000917          	auipc	s2,0x0
 920:	6e490913          	add	s2,s2,1764 # 1000 <freep>
  if(p == SBRK_ERROR)
 924:	5afd                	li	s5,-1
 926:	a885                	j	996 <malloc+0xc6>
    base.s.ptr = freep = prevp = &base;
 928:	00000797          	auipc	a5,0x0
 92c:	6e878793          	add	a5,a5,1768 # 1010 <base>
 930:	00000717          	auipc	a4,0x0
 934:	6cf73823          	sd	a5,1744(a4) # 1000 <freep>
 938:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 93a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 93e:	b7e1                	j	906 <malloc+0x36>
      if(p->s.size == nunits)
 940:	02e48c63          	beq	s1,a4,978 <malloc+0xa8>
        p->s.size -= nunits;
 944:	4137073b          	subw	a4,a4,s3
 948:	c798                	sw	a4,8(a5)
        p += p->s.size;
 94a:	02071693          	sll	a3,a4,0x20
 94e:	01c6d713          	srl	a4,a3,0x1c
 952:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 954:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 958:	00000717          	auipc	a4,0x0
 95c:	6aa73423          	sd	a0,1704(a4) # 1000 <freep>
      return (void*)(p + 1);
 960:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 964:	70e2                	ld	ra,56(sp)
 966:	7442                	ld	s0,48(sp)
 968:	74a2                	ld	s1,40(sp)
 96a:	7902                	ld	s2,32(sp)
 96c:	69e2                	ld	s3,24(sp)
 96e:	6a42                	ld	s4,16(sp)
 970:	6aa2                	ld	s5,8(sp)
 972:	6b02                	ld	s6,0(sp)
 974:	6121                	add	sp,sp,64
 976:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 978:	6398                	ld	a4,0(a5)
 97a:	e118                	sd	a4,0(a0)
 97c:	bff1                	j	958 <malloc+0x88>
  hp->s.size = nu;
 97e:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 982:	0541                	add	a0,a0,16
 984:	ecbff0ef          	jal	84e <free>
  return freep;
 988:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 98c:	dd61                	beqz	a0,964 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 98e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 990:	4798                	lw	a4,8(a5)
 992:	fa9777e3          	bgeu	a4,s1,940 <malloc+0x70>
    if(p == freep)
 996:	00093703          	ld	a4,0(s2)
 99a:	853e                	mv	a0,a5
 99c:	fef719e3          	bne	a4,a5,98e <malloc+0xbe>
  p = sbrk(nu * sizeof(Header));
 9a0:	8552                	mv	a0,s4
 9a2:	a05ff0ef          	jal	3a6 <sbrk>
  if(p == SBRK_ERROR)
 9a6:	fd551ce3          	bne	a0,s5,97e <malloc+0xae>
        return 0;
 9aa:	4501                	li	a0,0
 9ac:	bf65                	j	964 <malloc+0x94>
