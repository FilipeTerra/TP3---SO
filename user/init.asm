
user/_init:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
   0:	1101                	add	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	add	s0,sp,32
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
   c:	4589                	li	a1,2
   e:	00001517          	auipc	a0,0x1
  12:	92250513          	add	a0,a0,-1758 # 930 <malloc+0xea>
  16:	37a000ef          	jal	390 <open>
  1a:	04054563          	bltz	a0,64 <main+0x64>
    mknod("console", CONSOLE, 0);
    open("console", O_RDWR);
  }
  dup(0);  // stdout
  1e:	4501                	li	a0,0
  20:	3a8000ef          	jal	3c8 <dup>
  dup(0);  // stderr
  24:	4501                	li	a0,0
  26:	3a2000ef          	jal	3c8 <dup>

  for(;;){
    printf("init: starting sh\n");
  2a:	00001917          	auipc	s2,0x1
  2e:	90e90913          	add	s2,s2,-1778 # 938 <malloc+0xf2>
  32:	854a                	mv	a0,s2
  34:	75e000ef          	jal	792 <printf>
    pid = fork();
  38:	310000ef          	jal	348 <fork>
  3c:	84aa                	mv	s1,a0
    if(pid < 0){
  3e:	04054363          	bltz	a0,84 <main+0x84>
      printf("init: fork failed\n");
      exit(1);
    }
    if(pid == 0){
  42:	c931                	beqz	a0,96 <main+0x96>
    }

    for(;;){
      // this call to wait() returns if the shell exits,
      // or if a parentless process exits.
      wpid = wait((int *) 0);
  44:	4501                	li	a0,0
  46:	312000ef          	jal	358 <wait>
      if(wpid == pid){
  4a:	fea484e3          	beq	s1,a0,32 <main+0x32>
        // the shell exited; restart it.
        break;
      } else if(wpid < 0){
  4e:	fe055be3          	bgez	a0,44 <main+0x44>
        printf("init: wait returned an error\n");
  52:	00001517          	auipc	a0,0x1
  56:	93650513          	add	a0,a0,-1738 # 988 <malloc+0x142>
  5a:	738000ef          	jal	792 <printf>
        exit(1);
  5e:	4505                	li	a0,1
  60:	2f0000ef          	jal	350 <exit>
    mknod("console", CONSOLE, 0);
  64:	4601                	li	a2,0
  66:	4585                	li	a1,1
  68:	00001517          	auipc	a0,0x1
  6c:	8c850513          	add	a0,a0,-1848 # 930 <malloc+0xea>
  70:	328000ef          	jal	398 <mknod>
    open("console", O_RDWR);
  74:	4589                	li	a1,2
  76:	00001517          	auipc	a0,0x1
  7a:	8ba50513          	add	a0,a0,-1862 # 930 <malloc+0xea>
  7e:	312000ef          	jal	390 <open>
  82:	bf71                	j	1e <main+0x1e>
      printf("init: fork failed\n");
  84:	00001517          	auipc	a0,0x1
  88:	8cc50513          	add	a0,a0,-1844 # 950 <malloc+0x10a>
  8c:	706000ef          	jal	792 <printf>
      exit(1);
  90:	4505                	li	a0,1
  92:	2be000ef          	jal	350 <exit>
      exec("sh", argv);
  96:	00001597          	auipc	a1,0x1
  9a:	f6a58593          	add	a1,a1,-150 # 1000 <argv>
  9e:	00001517          	auipc	a0,0x1
  a2:	8ca50513          	add	a0,a0,-1846 # 968 <malloc+0x122>
  a6:	2e2000ef          	jal	388 <exec>
      printf("init: exec sh failed\n");
  aa:	00001517          	auipc	a0,0x1
  ae:	8c650513          	add	a0,a0,-1850 # 970 <malloc+0x12a>
  b2:	6e0000ef          	jal	792 <printf>
      exit(1);
  b6:	4505                	li	a0,1
  b8:	298000ef          	jal	350 <exit>

00000000000000bc <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  bc:	1141                	add	sp,sp,-16
  be:	e406                	sd	ra,8(sp)
  c0:	e022                	sd	s0,0(sp)
  c2:	0800                	add	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  c4:	f3dff0ef          	jal	0 <main>
  exit(r);
  c8:	288000ef          	jal	350 <exit>

00000000000000cc <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  cc:	1141                	add	sp,sp,-16
  ce:	e422                	sd	s0,8(sp)
  d0:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  d2:	87aa                	mv	a5,a0
  d4:	0585                	add	a1,a1,1
  d6:	0785                	add	a5,a5,1
  d8:	fff5c703          	lbu	a4,-1(a1)
  dc:	fee78fa3          	sb	a4,-1(a5)
  e0:	fb75                	bnez	a4,d4 <strcpy+0x8>
    ;
  return os;
}
  e2:	6422                	ld	s0,8(sp)
  e4:	0141                	add	sp,sp,16
  e6:	8082                	ret

00000000000000e8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  e8:	1141                	add	sp,sp,-16
  ea:	e422                	sd	s0,8(sp)
  ec:	0800                	add	s0,sp,16
  while(*p && *p == *q)
  ee:	00054783          	lbu	a5,0(a0)
  f2:	cb91                	beqz	a5,106 <strcmp+0x1e>
  f4:	0005c703          	lbu	a4,0(a1)
  f8:	00f71763          	bne	a4,a5,106 <strcmp+0x1e>
    p++, q++;
  fc:	0505                	add	a0,a0,1
  fe:	0585                	add	a1,a1,1
  while(*p && *p == *q)
 100:	00054783          	lbu	a5,0(a0)
 104:	fbe5                	bnez	a5,f4 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 106:	0005c503          	lbu	a0,0(a1)
}
 10a:	40a7853b          	subw	a0,a5,a0
 10e:	6422                	ld	s0,8(sp)
 110:	0141                	add	sp,sp,16
 112:	8082                	ret

0000000000000114 <strlen>:

uint
strlen(const char *s)
{
 114:	1141                	add	sp,sp,-16
 116:	e422                	sd	s0,8(sp)
 118:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 11a:	00054783          	lbu	a5,0(a0)
 11e:	cf91                	beqz	a5,13a <strlen+0x26>
 120:	0505                	add	a0,a0,1
 122:	87aa                	mv	a5,a0
 124:	86be                	mv	a3,a5
 126:	0785                	add	a5,a5,1
 128:	fff7c703          	lbu	a4,-1(a5)
 12c:	ff65                	bnez	a4,124 <strlen+0x10>
 12e:	40a6853b          	subw	a0,a3,a0
 132:	2505                	addw	a0,a0,1
    ;
  return n;
}
 134:	6422                	ld	s0,8(sp)
 136:	0141                	add	sp,sp,16
 138:	8082                	ret
  for(n = 0; s[n]; n++)
 13a:	4501                	li	a0,0
 13c:	bfe5                	j	134 <strlen+0x20>

000000000000013e <memset>:

void*
memset(void *dst, int c, uint n)
{
 13e:	1141                	add	sp,sp,-16
 140:	e422                	sd	s0,8(sp)
 142:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 144:	ca19                	beqz	a2,15a <memset+0x1c>
 146:	87aa                	mv	a5,a0
 148:	1602                	sll	a2,a2,0x20
 14a:	9201                	srl	a2,a2,0x20
 14c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 150:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 154:	0785                	add	a5,a5,1
 156:	fee79de3          	bne	a5,a4,150 <memset+0x12>
  }
  return dst;
}
 15a:	6422                	ld	s0,8(sp)
 15c:	0141                	add	sp,sp,16
 15e:	8082                	ret

0000000000000160 <strchr>:

char*
strchr(const char *s, char c)
{
 160:	1141                	add	sp,sp,-16
 162:	e422                	sd	s0,8(sp)
 164:	0800                	add	s0,sp,16
  for(; *s; s++)
 166:	00054783          	lbu	a5,0(a0)
 16a:	cb99                	beqz	a5,180 <strchr+0x20>
    if(*s == c)
 16c:	00f58763          	beq	a1,a5,17a <strchr+0x1a>
  for(; *s; s++)
 170:	0505                	add	a0,a0,1
 172:	00054783          	lbu	a5,0(a0)
 176:	fbfd                	bnez	a5,16c <strchr+0xc>
      return (char*)s;
  return 0;
 178:	4501                	li	a0,0
}
 17a:	6422                	ld	s0,8(sp)
 17c:	0141                	add	sp,sp,16
 17e:	8082                	ret
  return 0;
 180:	4501                	li	a0,0
 182:	bfe5                	j	17a <strchr+0x1a>

0000000000000184 <gets>:

char*
gets(char *buf, int max)
{
 184:	711d                	add	sp,sp,-96
 186:	ec86                	sd	ra,88(sp)
 188:	e8a2                	sd	s0,80(sp)
 18a:	e4a6                	sd	s1,72(sp)
 18c:	e0ca                	sd	s2,64(sp)
 18e:	fc4e                	sd	s3,56(sp)
 190:	f852                	sd	s4,48(sp)
 192:	f456                	sd	s5,40(sp)
 194:	f05a                	sd	s6,32(sp)
 196:	ec5e                	sd	s7,24(sp)
 198:	1080                	add	s0,sp,96
 19a:	8baa                	mv	s7,a0
 19c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 19e:	892a                	mv	s2,a0
 1a0:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1a2:	4aa9                	li	s5,10
 1a4:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1a6:	89a6                	mv	s3,s1
 1a8:	2485                	addw	s1,s1,1
 1aa:	0344d663          	bge	s1,s4,1d6 <gets+0x52>
    cc = read(0, &c, 1);
 1ae:	4605                	li	a2,1
 1b0:	faf40593          	add	a1,s0,-81
 1b4:	4501                	li	a0,0
 1b6:	1b2000ef          	jal	368 <read>
    if(cc < 1)
 1ba:	00a05e63          	blez	a0,1d6 <gets+0x52>
    buf[i++] = c;
 1be:	faf44783          	lbu	a5,-81(s0)
 1c2:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1c6:	01578763          	beq	a5,s5,1d4 <gets+0x50>
 1ca:	0905                	add	s2,s2,1
 1cc:	fd679de3          	bne	a5,s6,1a6 <gets+0x22>
  for(i=0; i+1 < max; ){
 1d0:	89a6                	mv	s3,s1
 1d2:	a011                	j	1d6 <gets+0x52>
 1d4:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 1d6:	99de                	add	s3,s3,s7
 1d8:	00098023          	sb	zero,0(s3)
  return buf;
}
 1dc:	855e                	mv	a0,s7
 1de:	60e6                	ld	ra,88(sp)
 1e0:	6446                	ld	s0,80(sp)
 1e2:	64a6                	ld	s1,72(sp)
 1e4:	6906                	ld	s2,64(sp)
 1e6:	79e2                	ld	s3,56(sp)
 1e8:	7a42                	ld	s4,48(sp)
 1ea:	7aa2                	ld	s5,40(sp)
 1ec:	7b02                	ld	s6,32(sp)
 1ee:	6be2                	ld	s7,24(sp)
 1f0:	6125                	add	sp,sp,96
 1f2:	8082                	ret

00000000000001f4 <stat>:

int
stat(const char *n, struct stat *st)
{
 1f4:	1101                	add	sp,sp,-32
 1f6:	ec06                	sd	ra,24(sp)
 1f8:	e822                	sd	s0,16(sp)
 1fa:	e426                	sd	s1,8(sp)
 1fc:	e04a                	sd	s2,0(sp)
 1fe:	1000                	add	s0,sp,32
 200:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 202:	4581                	li	a1,0
 204:	18c000ef          	jal	390 <open>
  if(fd < 0)
 208:	02054163          	bltz	a0,22a <stat+0x36>
 20c:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 20e:	85ca                	mv	a1,s2
 210:	198000ef          	jal	3a8 <fstat>
 214:	892a                	mv	s2,a0
  close(fd);
 216:	8526                	mv	a0,s1
 218:	160000ef          	jal	378 <close>
  return r;
}
 21c:	854a                	mv	a0,s2
 21e:	60e2                	ld	ra,24(sp)
 220:	6442                	ld	s0,16(sp)
 222:	64a2                	ld	s1,8(sp)
 224:	6902                	ld	s2,0(sp)
 226:	6105                	add	sp,sp,32
 228:	8082                	ret
    return -1;
 22a:	597d                	li	s2,-1
 22c:	bfc5                	j	21c <stat+0x28>

000000000000022e <atoi>:

int
atoi(const char *s)
{
 22e:	1141                	add	sp,sp,-16
 230:	e422                	sd	s0,8(sp)
 232:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 234:	00054683          	lbu	a3,0(a0)
 238:	fd06879b          	addw	a5,a3,-48
 23c:	0ff7f793          	zext.b	a5,a5
 240:	4625                	li	a2,9
 242:	02f66863          	bltu	a2,a5,272 <atoi+0x44>
 246:	872a                	mv	a4,a0
  n = 0;
 248:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 24a:	0705                	add	a4,a4,1
 24c:	0025179b          	sllw	a5,a0,0x2
 250:	9fa9                	addw	a5,a5,a0
 252:	0017979b          	sllw	a5,a5,0x1
 256:	9fb5                	addw	a5,a5,a3
 258:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 25c:	00074683          	lbu	a3,0(a4)
 260:	fd06879b          	addw	a5,a3,-48
 264:	0ff7f793          	zext.b	a5,a5
 268:	fef671e3          	bgeu	a2,a5,24a <atoi+0x1c>
  return n;
}
 26c:	6422                	ld	s0,8(sp)
 26e:	0141                	add	sp,sp,16
 270:	8082                	ret
  n = 0;
 272:	4501                	li	a0,0
 274:	bfe5                	j	26c <atoi+0x3e>

0000000000000276 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 276:	1141                	add	sp,sp,-16
 278:	e422                	sd	s0,8(sp)
 27a:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 27c:	02b57463          	bgeu	a0,a1,2a4 <memmove+0x2e>
    while(n-- > 0)
 280:	00c05f63          	blez	a2,29e <memmove+0x28>
 284:	1602                	sll	a2,a2,0x20
 286:	9201                	srl	a2,a2,0x20
 288:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 28c:	872a                	mv	a4,a0
      *dst++ = *src++;
 28e:	0585                	add	a1,a1,1
 290:	0705                	add	a4,a4,1
 292:	fff5c683          	lbu	a3,-1(a1)
 296:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 29a:	fee79ae3          	bne	a5,a4,28e <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 29e:	6422                	ld	s0,8(sp)
 2a0:	0141                	add	sp,sp,16
 2a2:	8082                	ret
    dst += n;
 2a4:	00c50733          	add	a4,a0,a2
    src += n;
 2a8:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2aa:	fec05ae3          	blez	a2,29e <memmove+0x28>
 2ae:	fff6079b          	addw	a5,a2,-1
 2b2:	1782                	sll	a5,a5,0x20
 2b4:	9381                	srl	a5,a5,0x20
 2b6:	fff7c793          	not	a5,a5
 2ba:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2bc:	15fd                	add	a1,a1,-1
 2be:	177d                	add	a4,a4,-1
 2c0:	0005c683          	lbu	a3,0(a1)
 2c4:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2c8:	fee79ae3          	bne	a5,a4,2bc <memmove+0x46>
 2cc:	bfc9                	j	29e <memmove+0x28>

00000000000002ce <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2ce:	1141                	add	sp,sp,-16
 2d0:	e422                	sd	s0,8(sp)
 2d2:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2d4:	ca05                	beqz	a2,304 <memcmp+0x36>
 2d6:	fff6069b          	addw	a3,a2,-1
 2da:	1682                	sll	a3,a3,0x20
 2dc:	9281                	srl	a3,a3,0x20
 2de:	0685                	add	a3,a3,1
 2e0:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2e2:	00054783          	lbu	a5,0(a0)
 2e6:	0005c703          	lbu	a4,0(a1)
 2ea:	00e79863          	bne	a5,a4,2fa <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 2ee:	0505                	add	a0,a0,1
    p2++;
 2f0:	0585                	add	a1,a1,1
  while (n-- > 0) {
 2f2:	fed518e3          	bne	a0,a3,2e2 <memcmp+0x14>
  }
  return 0;
 2f6:	4501                	li	a0,0
 2f8:	a019                	j	2fe <memcmp+0x30>
      return *p1 - *p2;
 2fa:	40e7853b          	subw	a0,a5,a4
}
 2fe:	6422                	ld	s0,8(sp)
 300:	0141                	add	sp,sp,16
 302:	8082                	ret
  return 0;
 304:	4501                	li	a0,0
 306:	bfe5                	j	2fe <memcmp+0x30>

0000000000000308 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 308:	1141                	add	sp,sp,-16
 30a:	e406                	sd	ra,8(sp)
 30c:	e022                	sd	s0,0(sp)
 30e:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 310:	f67ff0ef          	jal	276 <memmove>
}
 314:	60a2                	ld	ra,8(sp)
 316:	6402                	ld	s0,0(sp)
 318:	0141                	add	sp,sp,16
 31a:	8082                	ret

000000000000031c <sbrk>:

char *
sbrk(int n) {
 31c:	1141                	add	sp,sp,-16
 31e:	e406                	sd	ra,8(sp)
 320:	e022                	sd	s0,0(sp)
 322:	0800                	add	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 324:	4585                	li	a1,1
 326:	0b2000ef          	jal	3d8 <sys_sbrk>
}
 32a:	60a2                	ld	ra,8(sp)
 32c:	6402                	ld	s0,0(sp)
 32e:	0141                	add	sp,sp,16
 330:	8082                	ret

0000000000000332 <sbrklazy>:

char *
sbrklazy(int n) {
 332:	1141                	add	sp,sp,-16
 334:	e406                	sd	ra,8(sp)
 336:	e022                	sd	s0,0(sp)
 338:	0800                	add	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 33a:	4589                	li	a1,2
 33c:	09c000ef          	jal	3d8 <sys_sbrk>
}
 340:	60a2                	ld	ra,8(sp)
 342:	6402                	ld	s0,0(sp)
 344:	0141                	add	sp,sp,16
 346:	8082                	ret

0000000000000348 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 348:	4885                	li	a7,1
 ecall
 34a:	00000073          	ecall
 ret
 34e:	8082                	ret

0000000000000350 <exit>:
.global exit
exit:
 li a7, SYS_exit
 350:	4889                	li	a7,2
 ecall
 352:	00000073          	ecall
 ret
 356:	8082                	ret

0000000000000358 <wait>:
.global wait
wait:
 li a7, SYS_wait
 358:	488d                	li	a7,3
 ecall
 35a:	00000073          	ecall
 ret
 35e:	8082                	ret

0000000000000360 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 360:	4891                	li	a7,4
 ecall
 362:	00000073          	ecall
 ret
 366:	8082                	ret

0000000000000368 <read>:
.global read
read:
 li a7, SYS_read
 368:	4895                	li	a7,5
 ecall
 36a:	00000073          	ecall
 ret
 36e:	8082                	ret

0000000000000370 <write>:
.global write
write:
 li a7, SYS_write
 370:	48c1                	li	a7,16
 ecall
 372:	00000073          	ecall
 ret
 376:	8082                	ret

0000000000000378 <close>:
.global close
close:
 li a7, SYS_close
 378:	48d5                	li	a7,21
 ecall
 37a:	00000073          	ecall
 ret
 37e:	8082                	ret

0000000000000380 <kill>:
.global kill
kill:
 li a7, SYS_kill
 380:	4899                	li	a7,6
 ecall
 382:	00000073          	ecall
 ret
 386:	8082                	ret

0000000000000388 <exec>:
.global exec
exec:
 li a7, SYS_exec
 388:	489d                	li	a7,7
 ecall
 38a:	00000073          	ecall
 ret
 38e:	8082                	ret

0000000000000390 <open>:
.global open
open:
 li a7, SYS_open
 390:	48bd                	li	a7,15
 ecall
 392:	00000073          	ecall
 ret
 396:	8082                	ret

0000000000000398 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 398:	48c5                	li	a7,17
 ecall
 39a:	00000073          	ecall
 ret
 39e:	8082                	ret

00000000000003a0 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3a0:	48c9                	li	a7,18
 ecall
 3a2:	00000073          	ecall
 ret
 3a6:	8082                	ret

00000000000003a8 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3a8:	48a1                	li	a7,8
 ecall
 3aa:	00000073          	ecall
 ret
 3ae:	8082                	ret

00000000000003b0 <link>:
.global link
link:
 li a7, SYS_link
 3b0:	48cd                	li	a7,19
 ecall
 3b2:	00000073          	ecall
 ret
 3b6:	8082                	ret

00000000000003b8 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3b8:	48d1                	li	a7,20
 ecall
 3ba:	00000073          	ecall
 ret
 3be:	8082                	ret

00000000000003c0 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3c0:	48a5                	li	a7,9
 ecall
 3c2:	00000073          	ecall
 ret
 3c6:	8082                	ret

00000000000003c8 <dup>:
.global dup
dup:
 li a7, SYS_dup
 3c8:	48a9                	li	a7,10
 ecall
 3ca:	00000073          	ecall
 ret
 3ce:	8082                	ret

00000000000003d0 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3d0:	48ad                	li	a7,11
 ecall
 3d2:	00000073          	ecall
 ret
 3d6:	8082                	ret

00000000000003d8 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 3d8:	48b1                	li	a7,12
 ecall
 3da:	00000073          	ecall
 ret
 3de:	8082                	ret

00000000000003e0 <pause>:
.global pause
pause:
 li a7, SYS_pause
 3e0:	48b5                	li	a7,13
 ecall
 3e2:	00000073          	ecall
 ret
 3e6:	8082                	ret

00000000000003e8 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3e8:	48b9                	li	a7,14
 ecall
 3ea:	00000073          	ecall
 ret
 3ee:	8082                	ret

00000000000003f0 <getcnt>:
.global getcnt
getcnt:
 li a7, SYS_getcnt
 3f0:	48d9                	li	a7,22
 ecall
 3f2:	00000073          	ecall
 ret
 3f6:	8082                	ret

00000000000003f8 <settickets>:
.global settickets
settickets:
 li a7, SYS_settickets
 3f8:	48dd                	li	a7,23
 ecall
 3fa:	00000073          	ecall
 ret
 3fe:	8082                	ret

0000000000000400 <getpinfo>:
.global getpinfo
getpinfo:
 li a7, SYS_getpinfo
 400:	48e1                	li	a7,24
 ecall
 402:	00000073          	ecall
 ret
 406:	8082                	ret

0000000000000408 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 408:	1101                	add	sp,sp,-32
 40a:	ec06                	sd	ra,24(sp)
 40c:	e822                	sd	s0,16(sp)
 40e:	1000                	add	s0,sp,32
 410:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 414:	4605                	li	a2,1
 416:	fef40593          	add	a1,s0,-17
 41a:	f57ff0ef          	jal	370 <write>
}
 41e:	60e2                	ld	ra,24(sp)
 420:	6442                	ld	s0,16(sp)
 422:	6105                	add	sp,sp,32
 424:	8082                	ret

0000000000000426 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 426:	715d                	add	sp,sp,-80
 428:	e486                	sd	ra,72(sp)
 42a:	e0a2                	sd	s0,64(sp)
 42c:	fc26                	sd	s1,56(sp)
 42e:	f84a                	sd	s2,48(sp)
 430:	f44e                	sd	s3,40(sp)
 432:	0880                	add	s0,sp,80
 434:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 436:	c299                	beqz	a3,43c <printint+0x16>
 438:	0805c163          	bltz	a1,4ba <printint+0x94>
  neg = 0;
 43c:	4881                	li	a7,0
 43e:	fb840693          	add	a3,s0,-72
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 442:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 444:	00000517          	auipc	a0,0x0
 448:	56c50513          	add	a0,a0,1388 # 9b0 <digits>
 44c:	883e                	mv	a6,a5
 44e:	2785                	addw	a5,a5,1
 450:	02c5f733          	remu	a4,a1,a2
 454:	972a                	add	a4,a4,a0
 456:	00074703          	lbu	a4,0(a4)
 45a:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 45e:	872e                	mv	a4,a1
 460:	02c5d5b3          	divu	a1,a1,a2
 464:	0685                	add	a3,a3,1
 466:	fec773e3          	bgeu	a4,a2,44c <printint+0x26>
  if(neg)
 46a:	00088b63          	beqz	a7,480 <printint+0x5a>
    buf[i++] = '-';
 46e:	fd078793          	add	a5,a5,-48
 472:	97a2                	add	a5,a5,s0
 474:	02d00713          	li	a4,45
 478:	fee78423          	sb	a4,-24(a5)
 47c:	0028079b          	addw	a5,a6,2

  while(--i >= 0)
 480:	02f05663          	blez	a5,4ac <printint+0x86>
 484:	fb840713          	add	a4,s0,-72
 488:	00f704b3          	add	s1,a4,a5
 48c:	fff70993          	add	s3,a4,-1
 490:	99be                	add	s3,s3,a5
 492:	37fd                	addw	a5,a5,-1
 494:	1782                	sll	a5,a5,0x20
 496:	9381                	srl	a5,a5,0x20
 498:	40f989b3          	sub	s3,s3,a5
    putc(fd, buf[i]);
 49c:	fff4c583          	lbu	a1,-1(s1)
 4a0:	854a                	mv	a0,s2
 4a2:	f67ff0ef          	jal	408 <putc>
  while(--i >= 0)
 4a6:	14fd                	add	s1,s1,-1
 4a8:	ff349ae3          	bne	s1,s3,49c <printint+0x76>
}
 4ac:	60a6                	ld	ra,72(sp)
 4ae:	6406                	ld	s0,64(sp)
 4b0:	74e2                	ld	s1,56(sp)
 4b2:	7942                	ld	s2,48(sp)
 4b4:	79a2                	ld	s3,40(sp)
 4b6:	6161                	add	sp,sp,80
 4b8:	8082                	ret
    x = -xx;
 4ba:	40b005b3          	neg	a1,a1
    neg = 1;
 4be:	4885                	li	a7,1
    x = -xx;
 4c0:	bfbd                	j	43e <printint+0x18>

00000000000004c2 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4c2:	711d                	add	sp,sp,-96
 4c4:	ec86                	sd	ra,88(sp)
 4c6:	e8a2                	sd	s0,80(sp)
 4c8:	e4a6                	sd	s1,72(sp)
 4ca:	e0ca                	sd	s2,64(sp)
 4cc:	fc4e                	sd	s3,56(sp)
 4ce:	f852                	sd	s4,48(sp)
 4d0:	f456                	sd	s5,40(sp)
 4d2:	f05a                	sd	s6,32(sp)
 4d4:	ec5e                	sd	s7,24(sp)
 4d6:	e862                	sd	s8,16(sp)
 4d8:	e466                	sd	s9,8(sp)
 4da:	e06a                	sd	s10,0(sp)
 4dc:	1080                	add	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4de:	0005c903          	lbu	s2,0(a1)
 4e2:	26090563          	beqz	s2,74c <vprintf+0x28a>
 4e6:	8b2a                	mv	s6,a0
 4e8:	8a2e                	mv	s4,a1
 4ea:	8bb2                	mv	s7,a2
  state = 0;
 4ec:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 4ee:	4481                	li	s1,0
 4f0:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 4f2:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 4f6:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 4fa:	06c00c93          	li	s9,108
 4fe:	a005                	j	51e <vprintf+0x5c>
        putc(fd, c0);
 500:	85ca                	mv	a1,s2
 502:	855a                	mv	a0,s6
 504:	f05ff0ef          	jal	408 <putc>
 508:	a019                	j	50e <vprintf+0x4c>
    } else if(state == '%'){
 50a:	03598263          	beq	s3,s5,52e <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 50e:	2485                	addw	s1,s1,1
 510:	8726                	mv	a4,s1
 512:	009a07b3          	add	a5,s4,s1
 516:	0007c903          	lbu	s2,0(a5)
 51a:	22090963          	beqz	s2,74c <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
 51e:	0009079b          	sext.w	a5,s2
    if(state == 0){
 522:	fe0994e3          	bnez	s3,50a <vprintf+0x48>
      if(c0 == '%'){
 526:	fd579de3          	bne	a5,s5,500 <vprintf+0x3e>
        state = '%';
 52a:	89be                	mv	s3,a5
 52c:	b7cd                	j	50e <vprintf+0x4c>
      if(c0) c1 = fmt[i+1] & 0xff;
 52e:	cbc9                	beqz	a5,5c0 <vprintf+0xfe>
 530:	00ea06b3          	add	a3,s4,a4
 534:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 538:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 53a:	c681                	beqz	a3,542 <vprintf+0x80>
 53c:	9752                	add	a4,a4,s4
 53e:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 542:	05878363          	beq	a5,s8,588 <vprintf+0xc6>
      } else if(c0 == 'l' && c1 == 'd'){
 546:	05978d63          	beq	a5,s9,5a0 <vprintf+0xde>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 54a:	07500713          	li	a4,117
 54e:	0ee78763          	beq	a5,a4,63c <vprintf+0x17a>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 552:	07800713          	li	a4,120
 556:	12e78963          	beq	a5,a4,688 <vprintf+0x1c6>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 55a:	07000713          	li	a4,112
 55e:	14e78e63          	beq	a5,a4,6ba <vprintf+0x1f8>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 562:	06300713          	li	a4,99
 566:	18e78c63          	beq	a5,a4,6fe <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 56a:	07300713          	li	a4,115
 56e:	1ae78263          	beq	a5,a4,712 <vprintf+0x250>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 572:	02500713          	li	a4,37
 576:	04e79563          	bne	a5,a4,5c0 <vprintf+0xfe>
        putc(fd, '%');
 57a:	02500593          	li	a1,37
 57e:	855a                	mv	a0,s6
 580:	e89ff0ef          	jal	408 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 584:	4981                	li	s3,0
 586:	b761                	j	50e <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 10, 1);
 588:	008b8913          	add	s2,s7,8
 58c:	4685                	li	a3,1
 58e:	4629                	li	a2,10
 590:	000ba583          	lw	a1,0(s7)
 594:	855a                	mv	a0,s6
 596:	e91ff0ef          	jal	426 <printint>
 59a:	8bca                	mv	s7,s2
      state = 0;
 59c:	4981                	li	s3,0
 59e:	bf85                	j	50e <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'd'){
 5a0:	06400793          	li	a5,100
 5a4:	02f68963          	beq	a3,a5,5d6 <vprintf+0x114>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5a8:	06c00793          	li	a5,108
 5ac:	04f68263          	beq	a3,a5,5f0 <vprintf+0x12e>
      } else if(c0 == 'l' && c1 == 'u'){
 5b0:	07500793          	li	a5,117
 5b4:	0af68063          	beq	a3,a5,654 <vprintf+0x192>
      } else if(c0 == 'l' && c1 == 'x'){
 5b8:	07800793          	li	a5,120
 5bc:	0ef68263          	beq	a3,a5,6a0 <vprintf+0x1de>
        putc(fd, '%');
 5c0:	02500593          	li	a1,37
 5c4:	855a                	mv	a0,s6
 5c6:	e43ff0ef          	jal	408 <putc>
        putc(fd, c0);
 5ca:	85ca                	mv	a1,s2
 5cc:	855a                	mv	a0,s6
 5ce:	e3bff0ef          	jal	408 <putc>
      state = 0;
 5d2:	4981                	li	s3,0
 5d4:	bf2d                	j	50e <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5d6:	008b8913          	add	s2,s7,8
 5da:	4685                	li	a3,1
 5dc:	4629                	li	a2,10
 5de:	000bb583          	ld	a1,0(s7)
 5e2:	855a                	mv	a0,s6
 5e4:	e43ff0ef          	jal	426 <printint>
        i += 1;
 5e8:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 5ea:	8bca                	mv	s7,s2
      state = 0;
 5ec:	4981                	li	s3,0
        i += 1;
 5ee:	b705                	j	50e <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5f0:	06400793          	li	a5,100
 5f4:	02f60763          	beq	a2,a5,622 <vprintf+0x160>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 5f8:	07500793          	li	a5,117
 5fc:	06f60963          	beq	a2,a5,66e <vprintf+0x1ac>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 600:	07800793          	li	a5,120
 604:	faf61ee3          	bne	a2,a5,5c0 <vprintf+0xfe>
        printint(fd, va_arg(ap, uint64), 16, 0);
 608:	008b8913          	add	s2,s7,8
 60c:	4681                	li	a3,0
 60e:	4641                	li	a2,16
 610:	000bb583          	ld	a1,0(s7)
 614:	855a                	mv	a0,s6
 616:	e11ff0ef          	jal	426 <printint>
        i += 2;
 61a:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 61c:	8bca                	mv	s7,s2
      state = 0;
 61e:	4981                	li	s3,0
        i += 2;
 620:	b5fd                	j	50e <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 622:	008b8913          	add	s2,s7,8
 626:	4685                	li	a3,1
 628:	4629                	li	a2,10
 62a:	000bb583          	ld	a1,0(s7)
 62e:	855a                	mv	a0,s6
 630:	df7ff0ef          	jal	426 <printint>
        i += 2;
 634:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 636:	8bca                	mv	s7,s2
      state = 0;
 638:	4981                	li	s3,0
        i += 2;
 63a:	bdd1                	j	50e <vprintf+0x4c>
        printint(fd, va_arg(ap, uint32), 10, 0);
 63c:	008b8913          	add	s2,s7,8
 640:	4681                	li	a3,0
 642:	4629                	li	a2,10
 644:	000be583          	lwu	a1,0(s7)
 648:	855a                	mv	a0,s6
 64a:	dddff0ef          	jal	426 <printint>
 64e:	8bca                	mv	s7,s2
      state = 0;
 650:	4981                	li	s3,0
 652:	bd75                	j	50e <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 654:	008b8913          	add	s2,s7,8
 658:	4681                	li	a3,0
 65a:	4629                	li	a2,10
 65c:	000bb583          	ld	a1,0(s7)
 660:	855a                	mv	a0,s6
 662:	dc5ff0ef          	jal	426 <printint>
        i += 1;
 666:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 668:	8bca                	mv	s7,s2
      state = 0;
 66a:	4981                	li	s3,0
        i += 1;
 66c:	b54d                	j	50e <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 66e:	008b8913          	add	s2,s7,8
 672:	4681                	li	a3,0
 674:	4629                	li	a2,10
 676:	000bb583          	ld	a1,0(s7)
 67a:	855a                	mv	a0,s6
 67c:	dabff0ef          	jal	426 <printint>
        i += 2;
 680:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 682:	8bca                	mv	s7,s2
      state = 0;
 684:	4981                	li	s3,0
        i += 2;
 686:	b561                	j	50e <vprintf+0x4c>
        printint(fd, va_arg(ap, uint32), 16, 0);
 688:	008b8913          	add	s2,s7,8
 68c:	4681                	li	a3,0
 68e:	4641                	li	a2,16
 690:	000be583          	lwu	a1,0(s7)
 694:	855a                	mv	a0,s6
 696:	d91ff0ef          	jal	426 <printint>
 69a:	8bca                	mv	s7,s2
      state = 0;
 69c:	4981                	li	s3,0
 69e:	bd85                	j	50e <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6a0:	008b8913          	add	s2,s7,8
 6a4:	4681                	li	a3,0
 6a6:	4641                	li	a2,16
 6a8:	000bb583          	ld	a1,0(s7)
 6ac:	855a                	mv	a0,s6
 6ae:	d79ff0ef          	jal	426 <printint>
        i += 1;
 6b2:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 6b4:	8bca                	mv	s7,s2
      state = 0;
 6b6:	4981                	li	s3,0
        i += 1;
 6b8:	bd99                	j	50e <vprintf+0x4c>
        printptr(fd, va_arg(ap, uint64));
 6ba:	008b8d13          	add	s10,s7,8
 6be:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6c2:	03000593          	li	a1,48
 6c6:	855a                	mv	a0,s6
 6c8:	d41ff0ef          	jal	408 <putc>
  putc(fd, 'x');
 6cc:	07800593          	li	a1,120
 6d0:	855a                	mv	a0,s6
 6d2:	d37ff0ef          	jal	408 <putc>
 6d6:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6d8:	00000b97          	auipc	s7,0x0
 6dc:	2d8b8b93          	add	s7,s7,728 # 9b0 <digits>
 6e0:	03c9d793          	srl	a5,s3,0x3c
 6e4:	97de                	add	a5,a5,s7
 6e6:	0007c583          	lbu	a1,0(a5)
 6ea:	855a                	mv	a0,s6
 6ec:	d1dff0ef          	jal	408 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6f0:	0992                	sll	s3,s3,0x4
 6f2:	397d                	addw	s2,s2,-1
 6f4:	fe0916e3          	bnez	s2,6e0 <vprintf+0x21e>
        printptr(fd, va_arg(ap, uint64));
 6f8:	8bea                	mv	s7,s10
      state = 0;
 6fa:	4981                	li	s3,0
 6fc:	bd09                	j	50e <vprintf+0x4c>
        putc(fd, va_arg(ap, uint32));
 6fe:	008b8913          	add	s2,s7,8
 702:	000bc583          	lbu	a1,0(s7)
 706:	855a                	mv	a0,s6
 708:	d01ff0ef          	jal	408 <putc>
 70c:	8bca                	mv	s7,s2
      state = 0;
 70e:	4981                	li	s3,0
 710:	bbfd                	j	50e <vprintf+0x4c>
        if((s = va_arg(ap, char*)) == 0)
 712:	008b8993          	add	s3,s7,8
 716:	000bb903          	ld	s2,0(s7)
 71a:	00090f63          	beqz	s2,738 <vprintf+0x276>
        for(; *s; s++)
 71e:	00094583          	lbu	a1,0(s2)
 722:	c195                	beqz	a1,746 <vprintf+0x284>
          putc(fd, *s);
 724:	855a                	mv	a0,s6
 726:	ce3ff0ef          	jal	408 <putc>
        for(; *s; s++)
 72a:	0905                	add	s2,s2,1
 72c:	00094583          	lbu	a1,0(s2)
 730:	f9f5                	bnez	a1,724 <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 732:	8bce                	mv	s7,s3
      state = 0;
 734:	4981                	li	s3,0
 736:	bbe1                	j	50e <vprintf+0x4c>
          s = "(null)";
 738:	00000917          	auipc	s2,0x0
 73c:	27090913          	add	s2,s2,624 # 9a8 <malloc+0x162>
        for(; *s; s++)
 740:	02800593          	li	a1,40
 744:	b7c5                	j	724 <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 746:	8bce                	mv	s7,s3
      state = 0;
 748:	4981                	li	s3,0
 74a:	b3d1                	j	50e <vprintf+0x4c>
    }
  }
}
 74c:	60e6                	ld	ra,88(sp)
 74e:	6446                	ld	s0,80(sp)
 750:	64a6                	ld	s1,72(sp)
 752:	6906                	ld	s2,64(sp)
 754:	79e2                	ld	s3,56(sp)
 756:	7a42                	ld	s4,48(sp)
 758:	7aa2                	ld	s5,40(sp)
 75a:	7b02                	ld	s6,32(sp)
 75c:	6be2                	ld	s7,24(sp)
 75e:	6c42                	ld	s8,16(sp)
 760:	6ca2                	ld	s9,8(sp)
 762:	6d02                	ld	s10,0(sp)
 764:	6125                	add	sp,sp,96
 766:	8082                	ret

0000000000000768 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 768:	715d                	add	sp,sp,-80
 76a:	ec06                	sd	ra,24(sp)
 76c:	e822                	sd	s0,16(sp)
 76e:	1000                	add	s0,sp,32
 770:	e010                	sd	a2,0(s0)
 772:	e414                	sd	a3,8(s0)
 774:	e818                	sd	a4,16(s0)
 776:	ec1c                	sd	a5,24(s0)
 778:	03043023          	sd	a6,32(s0)
 77c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 780:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 784:	8622                	mv	a2,s0
 786:	d3dff0ef          	jal	4c2 <vprintf>
}
 78a:	60e2                	ld	ra,24(sp)
 78c:	6442                	ld	s0,16(sp)
 78e:	6161                	add	sp,sp,80
 790:	8082                	ret

0000000000000792 <printf>:

void
printf(const char *fmt, ...)
{
 792:	711d                	add	sp,sp,-96
 794:	ec06                	sd	ra,24(sp)
 796:	e822                	sd	s0,16(sp)
 798:	1000                	add	s0,sp,32
 79a:	e40c                	sd	a1,8(s0)
 79c:	e810                	sd	a2,16(s0)
 79e:	ec14                	sd	a3,24(s0)
 7a0:	f018                	sd	a4,32(s0)
 7a2:	f41c                	sd	a5,40(s0)
 7a4:	03043823          	sd	a6,48(s0)
 7a8:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7ac:	00840613          	add	a2,s0,8
 7b0:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7b4:	85aa                	mv	a1,a0
 7b6:	4505                	li	a0,1
 7b8:	d0bff0ef          	jal	4c2 <vprintf>
}
 7bc:	60e2                	ld	ra,24(sp)
 7be:	6442                	ld	s0,16(sp)
 7c0:	6125                	add	sp,sp,96
 7c2:	8082                	ret

00000000000007c4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7c4:	1141                	add	sp,sp,-16
 7c6:	e422                	sd	s0,8(sp)
 7c8:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7ca:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7ce:	00001797          	auipc	a5,0x1
 7d2:	8427b783          	ld	a5,-1982(a5) # 1010 <freep>
 7d6:	a02d                	j	800 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7d8:	4618                	lw	a4,8(a2)
 7da:	9f2d                	addw	a4,a4,a1
 7dc:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7e0:	6398                	ld	a4,0(a5)
 7e2:	6310                	ld	a2,0(a4)
 7e4:	a83d                	j	822 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7e6:	ff852703          	lw	a4,-8(a0)
 7ea:	9f31                	addw	a4,a4,a2
 7ec:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7ee:	ff053683          	ld	a3,-16(a0)
 7f2:	a091                	j	836 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7f4:	6398                	ld	a4,0(a5)
 7f6:	00e7e463          	bltu	a5,a4,7fe <free+0x3a>
 7fa:	00e6ea63          	bltu	a3,a4,80e <free+0x4a>
{
 7fe:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 800:	fed7fae3          	bgeu	a5,a3,7f4 <free+0x30>
 804:	6398                	ld	a4,0(a5)
 806:	00e6e463          	bltu	a3,a4,80e <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 80a:	fee7eae3          	bltu	a5,a4,7fe <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 80e:	ff852583          	lw	a1,-8(a0)
 812:	6390                	ld	a2,0(a5)
 814:	02059813          	sll	a6,a1,0x20
 818:	01c85713          	srl	a4,a6,0x1c
 81c:	9736                	add	a4,a4,a3
 81e:	fae60de3          	beq	a2,a4,7d8 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 822:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 826:	4790                	lw	a2,8(a5)
 828:	02061593          	sll	a1,a2,0x20
 82c:	01c5d713          	srl	a4,a1,0x1c
 830:	973e                	add	a4,a4,a5
 832:	fae68ae3          	beq	a3,a4,7e6 <free+0x22>
    p->s.ptr = bp->s.ptr;
 836:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 838:	00000717          	auipc	a4,0x0
 83c:	7cf73c23          	sd	a5,2008(a4) # 1010 <freep>
}
 840:	6422                	ld	s0,8(sp)
 842:	0141                	add	sp,sp,16
 844:	8082                	ret

0000000000000846 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 846:	7139                	add	sp,sp,-64
 848:	fc06                	sd	ra,56(sp)
 84a:	f822                	sd	s0,48(sp)
 84c:	f426                	sd	s1,40(sp)
 84e:	f04a                	sd	s2,32(sp)
 850:	ec4e                	sd	s3,24(sp)
 852:	e852                	sd	s4,16(sp)
 854:	e456                	sd	s5,8(sp)
 856:	e05a                	sd	s6,0(sp)
 858:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 85a:	02051493          	sll	s1,a0,0x20
 85e:	9081                	srl	s1,s1,0x20
 860:	04bd                	add	s1,s1,15
 862:	8091                	srl	s1,s1,0x4
 864:	0014899b          	addw	s3,s1,1
 868:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 86a:	00000517          	auipc	a0,0x0
 86e:	7a653503          	ld	a0,1958(a0) # 1010 <freep>
 872:	c515                	beqz	a0,89e <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 874:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 876:	4798                	lw	a4,8(a5)
 878:	02977f63          	bgeu	a4,s1,8b6 <malloc+0x70>
  if(nu < 4096)
 87c:	8a4e                	mv	s4,s3
 87e:	0009871b          	sext.w	a4,s3
 882:	6685                	lui	a3,0x1
 884:	00d77363          	bgeu	a4,a3,88a <malloc+0x44>
 888:	6a05                	lui	s4,0x1
 88a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 88e:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 892:	00000917          	auipc	s2,0x0
 896:	77e90913          	add	s2,s2,1918 # 1010 <freep>
  if(p == SBRK_ERROR)
 89a:	5afd                	li	s5,-1
 89c:	a885                	j	90c <malloc+0xc6>
    base.s.ptr = freep = prevp = &base;
 89e:	00000797          	auipc	a5,0x0
 8a2:	78278793          	add	a5,a5,1922 # 1020 <base>
 8a6:	00000717          	auipc	a4,0x0
 8aa:	76f73523          	sd	a5,1898(a4) # 1010 <freep>
 8ae:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8b0:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8b4:	b7e1                	j	87c <malloc+0x36>
      if(p->s.size == nunits)
 8b6:	02e48c63          	beq	s1,a4,8ee <malloc+0xa8>
        p->s.size -= nunits;
 8ba:	4137073b          	subw	a4,a4,s3
 8be:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8c0:	02071693          	sll	a3,a4,0x20
 8c4:	01c6d713          	srl	a4,a3,0x1c
 8c8:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8ca:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8ce:	00000717          	auipc	a4,0x0
 8d2:	74a73123          	sd	a0,1858(a4) # 1010 <freep>
      return (void*)(p + 1);
 8d6:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 8da:	70e2                	ld	ra,56(sp)
 8dc:	7442                	ld	s0,48(sp)
 8de:	74a2                	ld	s1,40(sp)
 8e0:	7902                	ld	s2,32(sp)
 8e2:	69e2                	ld	s3,24(sp)
 8e4:	6a42                	ld	s4,16(sp)
 8e6:	6aa2                	ld	s5,8(sp)
 8e8:	6b02                	ld	s6,0(sp)
 8ea:	6121                	add	sp,sp,64
 8ec:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 8ee:	6398                	ld	a4,0(a5)
 8f0:	e118                	sd	a4,0(a0)
 8f2:	bff1                	j	8ce <malloc+0x88>
  hp->s.size = nu;
 8f4:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8f8:	0541                	add	a0,a0,16
 8fa:	ecbff0ef          	jal	7c4 <free>
  return freep;
 8fe:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 902:	dd61                	beqz	a0,8da <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 904:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 906:	4798                	lw	a4,8(a5)
 908:	fa9777e3          	bgeu	a4,s1,8b6 <malloc+0x70>
    if(p == freep)
 90c:	00093703          	ld	a4,0(s2)
 910:	853e                	mv	a0,a5
 912:	fef719e3          	bne	a4,a5,904 <malloc+0xbe>
  p = sbrk(nu * sizeof(Header));
 916:	8552                	mv	a0,s4
 918:	a05ff0ef          	jal	31c <sbrk>
  if(p == SBRK_ERROR)
 91c:	fd551ce3          	bne	a0,s5,8f4 <malloc+0xae>
        return 0;
 920:	4501                	li	a0,0
 922:	bf65                	j	8da <malloc+0x94>
