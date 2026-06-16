
user/_dorphan:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:

char buf[BUFSZ];

int
main(int argc, char **argv)
{
   0:	1101                	add	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	1000                	add	s0,sp,32
  char *s = argv[0];
   a:	6184                	ld	s1,0(a1)

  if(mkdir("dd") != 0){
   c:	00001517          	auipc	a0,0x1
  10:	8f450513          	add	a0,a0,-1804 # 900 <malloc+0xec>
  14:	372000ef          	jal	386 <mkdir>
  18:	c919                	beqz	a0,2e <main+0x2e>
    printf("%s: mkdir dd failed\n", s);
  1a:	85a6                	mv	a1,s1
  1c:	00001517          	auipc	a0,0x1
  20:	8ec50513          	add	a0,a0,-1812 # 908 <malloc+0xf4>
  24:	73c000ef          	jal	760 <printf>
    exit(1);
  28:	4505                	li	a0,1
  2a:	2f4000ef          	jal	31e <exit>
  }

  if(chdir("dd") != 0){
  2e:	00001517          	auipc	a0,0x1
  32:	8d250513          	add	a0,a0,-1838 # 900 <malloc+0xec>
  36:	358000ef          	jal	38e <chdir>
  3a:	c919                	beqz	a0,50 <main+0x50>
    printf("%s: chdir dd failed\n", s);
  3c:	85a6                	mv	a1,s1
  3e:	00001517          	auipc	a0,0x1
  42:	8e250513          	add	a0,a0,-1822 # 920 <malloc+0x10c>
  46:	71a000ef          	jal	760 <printf>
    exit(1);
  4a:	4505                	li	a0,1
  4c:	2d2000ef          	jal	31e <exit>
  }

  if (unlink("../dd") < 0) {
  50:	00001517          	auipc	a0,0x1
  54:	8e850513          	add	a0,a0,-1816 # 938 <malloc+0x124>
  58:	316000ef          	jal	36e <unlink>
  5c:	00054d63          	bltz	a0,76 <main+0x76>
    printf("%s: unlink failed\n", s);
    exit(1);
  }
  printf("wait for kill and reclaim\n");
  60:	00001517          	auipc	a0,0x1
  64:	8f850513          	add	a0,a0,-1800 # 958 <malloc+0x144>
  68:	6f8000ef          	jal	760 <printf>
  // sit around until killed
  for(;;) pause(1000);
  6c:	3e800513          	li	a0,1000
  70:	33e000ef          	jal	3ae <pause>
  74:	bfe5                	j	6c <main+0x6c>
    printf("%s: unlink failed\n", s);
  76:	85a6                	mv	a1,s1
  78:	00001517          	auipc	a0,0x1
  7c:	8c850513          	add	a0,a0,-1848 # 940 <malloc+0x12c>
  80:	6e0000ef          	jal	760 <printf>
    exit(1);
  84:	4505                	li	a0,1
  86:	298000ef          	jal	31e <exit>

000000000000008a <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  8a:	1141                	add	sp,sp,-16
  8c:	e406                	sd	ra,8(sp)
  8e:	e022                	sd	s0,0(sp)
  90:	0800                	add	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  92:	f6fff0ef          	jal	0 <main>
  exit(r);
  96:	288000ef          	jal	31e <exit>

000000000000009a <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  9a:	1141                	add	sp,sp,-16
  9c:	e422                	sd	s0,8(sp)
  9e:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  a0:	87aa                	mv	a5,a0
  a2:	0585                	add	a1,a1,1
  a4:	0785                	add	a5,a5,1
  a6:	fff5c703          	lbu	a4,-1(a1)
  aa:	fee78fa3          	sb	a4,-1(a5)
  ae:	fb75                	bnez	a4,a2 <strcpy+0x8>
    ;
  return os;
}
  b0:	6422                	ld	s0,8(sp)
  b2:	0141                	add	sp,sp,16
  b4:	8082                	ret

00000000000000b6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  b6:	1141                	add	sp,sp,-16
  b8:	e422                	sd	s0,8(sp)
  ba:	0800                	add	s0,sp,16
  while(*p && *p == *q)
  bc:	00054783          	lbu	a5,0(a0)
  c0:	cb91                	beqz	a5,d4 <strcmp+0x1e>
  c2:	0005c703          	lbu	a4,0(a1)
  c6:	00f71763          	bne	a4,a5,d4 <strcmp+0x1e>
    p++, q++;
  ca:	0505                	add	a0,a0,1
  cc:	0585                	add	a1,a1,1
  while(*p && *p == *q)
  ce:	00054783          	lbu	a5,0(a0)
  d2:	fbe5                	bnez	a5,c2 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  d4:	0005c503          	lbu	a0,0(a1)
}
  d8:	40a7853b          	subw	a0,a5,a0
  dc:	6422                	ld	s0,8(sp)
  de:	0141                	add	sp,sp,16
  e0:	8082                	ret

00000000000000e2 <strlen>:

uint
strlen(const char *s)
{
  e2:	1141                	add	sp,sp,-16
  e4:	e422                	sd	s0,8(sp)
  e6:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  e8:	00054783          	lbu	a5,0(a0)
  ec:	cf91                	beqz	a5,108 <strlen+0x26>
  ee:	0505                	add	a0,a0,1
  f0:	87aa                	mv	a5,a0
  f2:	86be                	mv	a3,a5
  f4:	0785                	add	a5,a5,1
  f6:	fff7c703          	lbu	a4,-1(a5)
  fa:	ff65                	bnez	a4,f2 <strlen+0x10>
  fc:	40a6853b          	subw	a0,a3,a0
 100:	2505                	addw	a0,a0,1
    ;
  return n;
}
 102:	6422                	ld	s0,8(sp)
 104:	0141                	add	sp,sp,16
 106:	8082                	ret
  for(n = 0; s[n]; n++)
 108:	4501                	li	a0,0
 10a:	bfe5                	j	102 <strlen+0x20>

000000000000010c <memset>:

void*
memset(void *dst, int c, uint n)
{
 10c:	1141                	add	sp,sp,-16
 10e:	e422                	sd	s0,8(sp)
 110:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 112:	ca19                	beqz	a2,128 <memset+0x1c>
 114:	87aa                	mv	a5,a0
 116:	1602                	sll	a2,a2,0x20
 118:	9201                	srl	a2,a2,0x20
 11a:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 11e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 122:	0785                	add	a5,a5,1
 124:	fee79de3          	bne	a5,a4,11e <memset+0x12>
  }
  return dst;
}
 128:	6422                	ld	s0,8(sp)
 12a:	0141                	add	sp,sp,16
 12c:	8082                	ret

000000000000012e <strchr>:

char*
strchr(const char *s, char c)
{
 12e:	1141                	add	sp,sp,-16
 130:	e422                	sd	s0,8(sp)
 132:	0800                	add	s0,sp,16
  for(; *s; s++)
 134:	00054783          	lbu	a5,0(a0)
 138:	cb99                	beqz	a5,14e <strchr+0x20>
    if(*s == c)
 13a:	00f58763          	beq	a1,a5,148 <strchr+0x1a>
  for(; *s; s++)
 13e:	0505                	add	a0,a0,1
 140:	00054783          	lbu	a5,0(a0)
 144:	fbfd                	bnez	a5,13a <strchr+0xc>
      return (char*)s;
  return 0;
 146:	4501                	li	a0,0
}
 148:	6422                	ld	s0,8(sp)
 14a:	0141                	add	sp,sp,16
 14c:	8082                	ret
  return 0;
 14e:	4501                	li	a0,0
 150:	bfe5                	j	148 <strchr+0x1a>

0000000000000152 <gets>:

char*
gets(char *buf, int max)
{
 152:	711d                	add	sp,sp,-96
 154:	ec86                	sd	ra,88(sp)
 156:	e8a2                	sd	s0,80(sp)
 158:	e4a6                	sd	s1,72(sp)
 15a:	e0ca                	sd	s2,64(sp)
 15c:	fc4e                	sd	s3,56(sp)
 15e:	f852                	sd	s4,48(sp)
 160:	f456                	sd	s5,40(sp)
 162:	f05a                	sd	s6,32(sp)
 164:	ec5e                	sd	s7,24(sp)
 166:	1080                	add	s0,sp,96
 168:	8baa                	mv	s7,a0
 16a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 16c:	892a                	mv	s2,a0
 16e:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 170:	4aa9                	li	s5,10
 172:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 174:	89a6                	mv	s3,s1
 176:	2485                	addw	s1,s1,1
 178:	0344d663          	bge	s1,s4,1a4 <gets+0x52>
    cc = read(0, &c, 1);
 17c:	4605                	li	a2,1
 17e:	faf40593          	add	a1,s0,-81
 182:	4501                	li	a0,0
 184:	1b2000ef          	jal	336 <read>
    if(cc < 1)
 188:	00a05e63          	blez	a0,1a4 <gets+0x52>
    buf[i++] = c;
 18c:	faf44783          	lbu	a5,-81(s0)
 190:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 194:	01578763          	beq	a5,s5,1a2 <gets+0x50>
 198:	0905                	add	s2,s2,1
 19a:	fd679de3          	bne	a5,s6,174 <gets+0x22>
  for(i=0; i+1 < max; ){
 19e:	89a6                	mv	s3,s1
 1a0:	a011                	j	1a4 <gets+0x52>
 1a2:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 1a4:	99de                	add	s3,s3,s7
 1a6:	00098023          	sb	zero,0(s3)
  return buf;
}
 1aa:	855e                	mv	a0,s7
 1ac:	60e6                	ld	ra,88(sp)
 1ae:	6446                	ld	s0,80(sp)
 1b0:	64a6                	ld	s1,72(sp)
 1b2:	6906                	ld	s2,64(sp)
 1b4:	79e2                	ld	s3,56(sp)
 1b6:	7a42                	ld	s4,48(sp)
 1b8:	7aa2                	ld	s5,40(sp)
 1ba:	7b02                	ld	s6,32(sp)
 1bc:	6be2                	ld	s7,24(sp)
 1be:	6125                	add	sp,sp,96
 1c0:	8082                	ret

00000000000001c2 <stat>:

int
stat(const char *n, struct stat *st)
{
 1c2:	1101                	add	sp,sp,-32
 1c4:	ec06                	sd	ra,24(sp)
 1c6:	e822                	sd	s0,16(sp)
 1c8:	e426                	sd	s1,8(sp)
 1ca:	e04a                	sd	s2,0(sp)
 1cc:	1000                	add	s0,sp,32
 1ce:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1d0:	4581                	li	a1,0
 1d2:	18c000ef          	jal	35e <open>
  if(fd < 0)
 1d6:	02054163          	bltz	a0,1f8 <stat+0x36>
 1da:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1dc:	85ca                	mv	a1,s2
 1de:	198000ef          	jal	376 <fstat>
 1e2:	892a                	mv	s2,a0
  close(fd);
 1e4:	8526                	mv	a0,s1
 1e6:	160000ef          	jal	346 <close>
  return r;
}
 1ea:	854a                	mv	a0,s2
 1ec:	60e2                	ld	ra,24(sp)
 1ee:	6442                	ld	s0,16(sp)
 1f0:	64a2                	ld	s1,8(sp)
 1f2:	6902                	ld	s2,0(sp)
 1f4:	6105                	add	sp,sp,32
 1f6:	8082                	ret
    return -1;
 1f8:	597d                	li	s2,-1
 1fa:	bfc5                	j	1ea <stat+0x28>

00000000000001fc <atoi>:

int
atoi(const char *s)
{
 1fc:	1141                	add	sp,sp,-16
 1fe:	e422                	sd	s0,8(sp)
 200:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 202:	00054683          	lbu	a3,0(a0)
 206:	fd06879b          	addw	a5,a3,-48
 20a:	0ff7f793          	zext.b	a5,a5
 20e:	4625                	li	a2,9
 210:	02f66863          	bltu	a2,a5,240 <atoi+0x44>
 214:	872a                	mv	a4,a0
  n = 0;
 216:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 218:	0705                	add	a4,a4,1
 21a:	0025179b          	sllw	a5,a0,0x2
 21e:	9fa9                	addw	a5,a5,a0
 220:	0017979b          	sllw	a5,a5,0x1
 224:	9fb5                	addw	a5,a5,a3
 226:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 22a:	00074683          	lbu	a3,0(a4)
 22e:	fd06879b          	addw	a5,a3,-48
 232:	0ff7f793          	zext.b	a5,a5
 236:	fef671e3          	bgeu	a2,a5,218 <atoi+0x1c>
  return n;
}
 23a:	6422                	ld	s0,8(sp)
 23c:	0141                	add	sp,sp,16
 23e:	8082                	ret
  n = 0;
 240:	4501                	li	a0,0
 242:	bfe5                	j	23a <atoi+0x3e>

0000000000000244 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 244:	1141                	add	sp,sp,-16
 246:	e422                	sd	s0,8(sp)
 248:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 24a:	02b57463          	bgeu	a0,a1,272 <memmove+0x2e>
    while(n-- > 0)
 24e:	00c05f63          	blez	a2,26c <memmove+0x28>
 252:	1602                	sll	a2,a2,0x20
 254:	9201                	srl	a2,a2,0x20
 256:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 25a:	872a                	mv	a4,a0
      *dst++ = *src++;
 25c:	0585                	add	a1,a1,1
 25e:	0705                	add	a4,a4,1
 260:	fff5c683          	lbu	a3,-1(a1)
 264:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 268:	fee79ae3          	bne	a5,a4,25c <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 26c:	6422                	ld	s0,8(sp)
 26e:	0141                	add	sp,sp,16
 270:	8082                	ret
    dst += n;
 272:	00c50733          	add	a4,a0,a2
    src += n;
 276:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 278:	fec05ae3          	blez	a2,26c <memmove+0x28>
 27c:	fff6079b          	addw	a5,a2,-1
 280:	1782                	sll	a5,a5,0x20
 282:	9381                	srl	a5,a5,0x20
 284:	fff7c793          	not	a5,a5
 288:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 28a:	15fd                	add	a1,a1,-1
 28c:	177d                	add	a4,a4,-1
 28e:	0005c683          	lbu	a3,0(a1)
 292:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 296:	fee79ae3          	bne	a5,a4,28a <memmove+0x46>
 29a:	bfc9                	j	26c <memmove+0x28>

000000000000029c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 29c:	1141                	add	sp,sp,-16
 29e:	e422                	sd	s0,8(sp)
 2a0:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2a2:	ca05                	beqz	a2,2d2 <memcmp+0x36>
 2a4:	fff6069b          	addw	a3,a2,-1
 2a8:	1682                	sll	a3,a3,0x20
 2aa:	9281                	srl	a3,a3,0x20
 2ac:	0685                	add	a3,a3,1
 2ae:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2b0:	00054783          	lbu	a5,0(a0)
 2b4:	0005c703          	lbu	a4,0(a1)
 2b8:	00e79863          	bne	a5,a4,2c8 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 2bc:	0505                	add	a0,a0,1
    p2++;
 2be:	0585                	add	a1,a1,1
  while (n-- > 0) {
 2c0:	fed518e3          	bne	a0,a3,2b0 <memcmp+0x14>
  }
  return 0;
 2c4:	4501                	li	a0,0
 2c6:	a019                	j	2cc <memcmp+0x30>
      return *p1 - *p2;
 2c8:	40e7853b          	subw	a0,a5,a4
}
 2cc:	6422                	ld	s0,8(sp)
 2ce:	0141                	add	sp,sp,16
 2d0:	8082                	ret
  return 0;
 2d2:	4501                	li	a0,0
 2d4:	bfe5                	j	2cc <memcmp+0x30>

00000000000002d6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2d6:	1141                	add	sp,sp,-16
 2d8:	e406                	sd	ra,8(sp)
 2da:	e022                	sd	s0,0(sp)
 2dc:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 2de:	f67ff0ef          	jal	244 <memmove>
}
 2e2:	60a2                	ld	ra,8(sp)
 2e4:	6402                	ld	s0,0(sp)
 2e6:	0141                	add	sp,sp,16
 2e8:	8082                	ret

00000000000002ea <sbrk>:

char *
sbrk(int n) {
 2ea:	1141                	add	sp,sp,-16
 2ec:	e406                	sd	ra,8(sp)
 2ee:	e022                	sd	s0,0(sp)
 2f0:	0800                	add	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 2f2:	4585                	li	a1,1
 2f4:	0b2000ef          	jal	3a6 <sys_sbrk>
}
 2f8:	60a2                	ld	ra,8(sp)
 2fa:	6402                	ld	s0,0(sp)
 2fc:	0141                	add	sp,sp,16
 2fe:	8082                	ret

0000000000000300 <sbrklazy>:

char *
sbrklazy(int n) {
 300:	1141                	add	sp,sp,-16
 302:	e406                	sd	ra,8(sp)
 304:	e022                	sd	s0,0(sp)
 306:	0800                	add	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 308:	4589                	li	a1,2
 30a:	09c000ef          	jal	3a6 <sys_sbrk>
}
 30e:	60a2                	ld	ra,8(sp)
 310:	6402                	ld	s0,0(sp)
 312:	0141                	add	sp,sp,16
 314:	8082                	ret

0000000000000316 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 316:	4885                	li	a7,1
 ecall
 318:	00000073          	ecall
 ret
 31c:	8082                	ret

000000000000031e <exit>:
.global exit
exit:
 li a7, SYS_exit
 31e:	4889                	li	a7,2
 ecall
 320:	00000073          	ecall
 ret
 324:	8082                	ret

0000000000000326 <wait>:
.global wait
wait:
 li a7, SYS_wait
 326:	488d                	li	a7,3
 ecall
 328:	00000073          	ecall
 ret
 32c:	8082                	ret

000000000000032e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 32e:	4891                	li	a7,4
 ecall
 330:	00000073          	ecall
 ret
 334:	8082                	ret

0000000000000336 <read>:
.global read
read:
 li a7, SYS_read
 336:	4895                	li	a7,5
 ecall
 338:	00000073          	ecall
 ret
 33c:	8082                	ret

000000000000033e <write>:
.global write
write:
 li a7, SYS_write
 33e:	48c1                	li	a7,16
 ecall
 340:	00000073          	ecall
 ret
 344:	8082                	ret

0000000000000346 <close>:
.global close
close:
 li a7, SYS_close
 346:	48d5                	li	a7,21
 ecall
 348:	00000073          	ecall
 ret
 34c:	8082                	ret

000000000000034e <kill>:
.global kill
kill:
 li a7, SYS_kill
 34e:	4899                	li	a7,6
 ecall
 350:	00000073          	ecall
 ret
 354:	8082                	ret

0000000000000356 <exec>:
.global exec
exec:
 li a7, SYS_exec
 356:	489d                	li	a7,7
 ecall
 358:	00000073          	ecall
 ret
 35c:	8082                	ret

000000000000035e <open>:
.global open
open:
 li a7, SYS_open
 35e:	48bd                	li	a7,15
 ecall
 360:	00000073          	ecall
 ret
 364:	8082                	ret

0000000000000366 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 366:	48c5                	li	a7,17
 ecall
 368:	00000073          	ecall
 ret
 36c:	8082                	ret

000000000000036e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 36e:	48c9                	li	a7,18
 ecall
 370:	00000073          	ecall
 ret
 374:	8082                	ret

0000000000000376 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 376:	48a1                	li	a7,8
 ecall
 378:	00000073          	ecall
 ret
 37c:	8082                	ret

000000000000037e <link>:
.global link
link:
 li a7, SYS_link
 37e:	48cd                	li	a7,19
 ecall
 380:	00000073          	ecall
 ret
 384:	8082                	ret

0000000000000386 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 386:	48d1                	li	a7,20
 ecall
 388:	00000073          	ecall
 ret
 38c:	8082                	ret

000000000000038e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 38e:	48a5                	li	a7,9
 ecall
 390:	00000073          	ecall
 ret
 394:	8082                	ret

0000000000000396 <dup>:
.global dup
dup:
 li a7, SYS_dup
 396:	48a9                	li	a7,10
 ecall
 398:	00000073          	ecall
 ret
 39c:	8082                	ret

000000000000039e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 39e:	48ad                	li	a7,11
 ecall
 3a0:	00000073          	ecall
 ret
 3a4:	8082                	ret

00000000000003a6 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 3a6:	48b1                	li	a7,12
 ecall
 3a8:	00000073          	ecall
 ret
 3ac:	8082                	ret

00000000000003ae <pause>:
.global pause
pause:
 li a7, SYS_pause
 3ae:	48b5                	li	a7,13
 ecall
 3b0:	00000073          	ecall
 ret
 3b4:	8082                	ret

00000000000003b6 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3b6:	48b9                	li	a7,14
 ecall
 3b8:	00000073          	ecall
 ret
 3bc:	8082                	ret

00000000000003be <getcnt>:
.global getcnt
getcnt:
 li a7, SYS_getcnt
 3be:	48d9                	li	a7,22
 ecall
 3c0:	00000073          	ecall
 ret
 3c4:	8082                	ret

00000000000003c6 <settickets>:
.global settickets
settickets:
 li a7, SYS_settickets
 3c6:	48dd                	li	a7,23
 ecall
 3c8:	00000073          	ecall
 ret
 3cc:	8082                	ret

00000000000003ce <getpinfo>:
.global getpinfo
getpinfo:
 li a7, SYS_getpinfo
 3ce:	48e1                	li	a7,24
 ecall
 3d0:	00000073          	ecall
 ret
 3d4:	8082                	ret

00000000000003d6 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3d6:	1101                	add	sp,sp,-32
 3d8:	ec06                	sd	ra,24(sp)
 3da:	e822                	sd	s0,16(sp)
 3dc:	1000                	add	s0,sp,32
 3de:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3e2:	4605                	li	a2,1
 3e4:	fef40593          	add	a1,s0,-17
 3e8:	f57ff0ef          	jal	33e <write>
}
 3ec:	60e2                	ld	ra,24(sp)
 3ee:	6442                	ld	s0,16(sp)
 3f0:	6105                	add	sp,sp,32
 3f2:	8082                	ret

00000000000003f4 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 3f4:	715d                	add	sp,sp,-80
 3f6:	e486                	sd	ra,72(sp)
 3f8:	e0a2                	sd	s0,64(sp)
 3fa:	fc26                	sd	s1,56(sp)
 3fc:	f84a                	sd	s2,48(sp)
 3fe:	f44e                	sd	s3,40(sp)
 400:	0880                	add	s0,sp,80
 402:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 404:	c299                	beqz	a3,40a <printint+0x16>
 406:	0805c163          	bltz	a1,488 <printint+0x94>
  neg = 0;
 40a:	4881                	li	a7,0
 40c:	fb840693          	add	a3,s0,-72
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 410:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 412:	00000517          	auipc	a0,0x0
 416:	56e50513          	add	a0,a0,1390 # 980 <digits>
 41a:	883e                	mv	a6,a5
 41c:	2785                	addw	a5,a5,1
 41e:	02c5f733          	remu	a4,a1,a2
 422:	972a                	add	a4,a4,a0
 424:	00074703          	lbu	a4,0(a4)
 428:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 42c:	872e                	mv	a4,a1
 42e:	02c5d5b3          	divu	a1,a1,a2
 432:	0685                	add	a3,a3,1
 434:	fec773e3          	bgeu	a4,a2,41a <printint+0x26>
  if(neg)
 438:	00088b63          	beqz	a7,44e <printint+0x5a>
    buf[i++] = '-';
 43c:	fd078793          	add	a5,a5,-48
 440:	97a2                	add	a5,a5,s0
 442:	02d00713          	li	a4,45
 446:	fee78423          	sb	a4,-24(a5)
 44a:	0028079b          	addw	a5,a6,2

  while(--i >= 0)
 44e:	02f05663          	blez	a5,47a <printint+0x86>
 452:	fb840713          	add	a4,s0,-72
 456:	00f704b3          	add	s1,a4,a5
 45a:	fff70993          	add	s3,a4,-1
 45e:	99be                	add	s3,s3,a5
 460:	37fd                	addw	a5,a5,-1
 462:	1782                	sll	a5,a5,0x20
 464:	9381                	srl	a5,a5,0x20
 466:	40f989b3          	sub	s3,s3,a5
    putc(fd, buf[i]);
 46a:	fff4c583          	lbu	a1,-1(s1)
 46e:	854a                	mv	a0,s2
 470:	f67ff0ef          	jal	3d6 <putc>
  while(--i >= 0)
 474:	14fd                	add	s1,s1,-1
 476:	ff349ae3          	bne	s1,s3,46a <printint+0x76>
}
 47a:	60a6                	ld	ra,72(sp)
 47c:	6406                	ld	s0,64(sp)
 47e:	74e2                	ld	s1,56(sp)
 480:	7942                	ld	s2,48(sp)
 482:	79a2                	ld	s3,40(sp)
 484:	6161                	add	sp,sp,80
 486:	8082                	ret
    x = -xx;
 488:	40b005b3          	neg	a1,a1
    neg = 1;
 48c:	4885                	li	a7,1
    x = -xx;
 48e:	bfbd                	j	40c <printint+0x18>

0000000000000490 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 490:	711d                	add	sp,sp,-96
 492:	ec86                	sd	ra,88(sp)
 494:	e8a2                	sd	s0,80(sp)
 496:	e4a6                	sd	s1,72(sp)
 498:	e0ca                	sd	s2,64(sp)
 49a:	fc4e                	sd	s3,56(sp)
 49c:	f852                	sd	s4,48(sp)
 49e:	f456                	sd	s5,40(sp)
 4a0:	f05a                	sd	s6,32(sp)
 4a2:	ec5e                	sd	s7,24(sp)
 4a4:	e862                	sd	s8,16(sp)
 4a6:	e466                	sd	s9,8(sp)
 4a8:	e06a                	sd	s10,0(sp)
 4aa:	1080                	add	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4ac:	0005c903          	lbu	s2,0(a1)
 4b0:	26090563          	beqz	s2,71a <vprintf+0x28a>
 4b4:	8b2a                	mv	s6,a0
 4b6:	8a2e                	mv	s4,a1
 4b8:	8bb2                	mv	s7,a2
  state = 0;
 4ba:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 4bc:	4481                	li	s1,0
 4be:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 4c0:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 4c4:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 4c8:	06c00c93          	li	s9,108
 4cc:	a005                	j	4ec <vprintf+0x5c>
        putc(fd, c0);
 4ce:	85ca                	mv	a1,s2
 4d0:	855a                	mv	a0,s6
 4d2:	f05ff0ef          	jal	3d6 <putc>
 4d6:	a019                	j	4dc <vprintf+0x4c>
    } else if(state == '%'){
 4d8:	03598263          	beq	s3,s5,4fc <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 4dc:	2485                	addw	s1,s1,1
 4de:	8726                	mv	a4,s1
 4e0:	009a07b3          	add	a5,s4,s1
 4e4:	0007c903          	lbu	s2,0(a5)
 4e8:	22090963          	beqz	s2,71a <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
 4ec:	0009079b          	sext.w	a5,s2
    if(state == 0){
 4f0:	fe0994e3          	bnez	s3,4d8 <vprintf+0x48>
      if(c0 == '%'){
 4f4:	fd579de3          	bne	a5,s5,4ce <vprintf+0x3e>
        state = '%';
 4f8:	89be                	mv	s3,a5
 4fa:	b7cd                	j	4dc <vprintf+0x4c>
      if(c0) c1 = fmt[i+1] & 0xff;
 4fc:	cbc9                	beqz	a5,58e <vprintf+0xfe>
 4fe:	00ea06b3          	add	a3,s4,a4
 502:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 506:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 508:	c681                	beqz	a3,510 <vprintf+0x80>
 50a:	9752                	add	a4,a4,s4
 50c:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 510:	05878363          	beq	a5,s8,556 <vprintf+0xc6>
      } else if(c0 == 'l' && c1 == 'd'){
 514:	05978d63          	beq	a5,s9,56e <vprintf+0xde>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 518:	07500713          	li	a4,117
 51c:	0ee78763          	beq	a5,a4,60a <vprintf+0x17a>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 520:	07800713          	li	a4,120
 524:	12e78963          	beq	a5,a4,656 <vprintf+0x1c6>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 528:	07000713          	li	a4,112
 52c:	14e78e63          	beq	a5,a4,688 <vprintf+0x1f8>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 530:	06300713          	li	a4,99
 534:	18e78c63          	beq	a5,a4,6cc <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 538:	07300713          	li	a4,115
 53c:	1ae78263          	beq	a5,a4,6e0 <vprintf+0x250>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 540:	02500713          	li	a4,37
 544:	04e79563          	bne	a5,a4,58e <vprintf+0xfe>
        putc(fd, '%');
 548:	02500593          	li	a1,37
 54c:	855a                	mv	a0,s6
 54e:	e89ff0ef          	jal	3d6 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 552:	4981                	li	s3,0
 554:	b761                	j	4dc <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 10, 1);
 556:	008b8913          	add	s2,s7,8
 55a:	4685                	li	a3,1
 55c:	4629                	li	a2,10
 55e:	000ba583          	lw	a1,0(s7)
 562:	855a                	mv	a0,s6
 564:	e91ff0ef          	jal	3f4 <printint>
 568:	8bca                	mv	s7,s2
      state = 0;
 56a:	4981                	li	s3,0
 56c:	bf85                	j	4dc <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'd'){
 56e:	06400793          	li	a5,100
 572:	02f68963          	beq	a3,a5,5a4 <vprintf+0x114>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 576:	06c00793          	li	a5,108
 57a:	04f68263          	beq	a3,a5,5be <vprintf+0x12e>
      } else if(c0 == 'l' && c1 == 'u'){
 57e:	07500793          	li	a5,117
 582:	0af68063          	beq	a3,a5,622 <vprintf+0x192>
      } else if(c0 == 'l' && c1 == 'x'){
 586:	07800793          	li	a5,120
 58a:	0ef68263          	beq	a3,a5,66e <vprintf+0x1de>
        putc(fd, '%');
 58e:	02500593          	li	a1,37
 592:	855a                	mv	a0,s6
 594:	e43ff0ef          	jal	3d6 <putc>
        putc(fd, c0);
 598:	85ca                	mv	a1,s2
 59a:	855a                	mv	a0,s6
 59c:	e3bff0ef          	jal	3d6 <putc>
      state = 0;
 5a0:	4981                	li	s3,0
 5a2:	bf2d                	j	4dc <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5a4:	008b8913          	add	s2,s7,8
 5a8:	4685                	li	a3,1
 5aa:	4629                	li	a2,10
 5ac:	000bb583          	ld	a1,0(s7)
 5b0:	855a                	mv	a0,s6
 5b2:	e43ff0ef          	jal	3f4 <printint>
        i += 1;
 5b6:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 5b8:	8bca                	mv	s7,s2
      state = 0;
 5ba:	4981                	li	s3,0
        i += 1;
 5bc:	b705                	j	4dc <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5be:	06400793          	li	a5,100
 5c2:	02f60763          	beq	a2,a5,5f0 <vprintf+0x160>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 5c6:	07500793          	li	a5,117
 5ca:	06f60963          	beq	a2,a5,63c <vprintf+0x1ac>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 5ce:	07800793          	li	a5,120
 5d2:	faf61ee3          	bne	a2,a5,58e <vprintf+0xfe>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5d6:	008b8913          	add	s2,s7,8
 5da:	4681                	li	a3,0
 5dc:	4641                	li	a2,16
 5de:	000bb583          	ld	a1,0(s7)
 5e2:	855a                	mv	a0,s6
 5e4:	e11ff0ef          	jal	3f4 <printint>
        i += 2;
 5e8:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 5ea:	8bca                	mv	s7,s2
      state = 0;
 5ec:	4981                	li	s3,0
        i += 2;
 5ee:	b5fd                	j	4dc <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5f0:	008b8913          	add	s2,s7,8
 5f4:	4685                	li	a3,1
 5f6:	4629                	li	a2,10
 5f8:	000bb583          	ld	a1,0(s7)
 5fc:	855a                	mv	a0,s6
 5fe:	df7ff0ef          	jal	3f4 <printint>
        i += 2;
 602:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 604:	8bca                	mv	s7,s2
      state = 0;
 606:	4981                	li	s3,0
        i += 2;
 608:	bdd1                	j	4dc <vprintf+0x4c>
        printint(fd, va_arg(ap, uint32), 10, 0);
 60a:	008b8913          	add	s2,s7,8
 60e:	4681                	li	a3,0
 610:	4629                	li	a2,10
 612:	000be583          	lwu	a1,0(s7)
 616:	855a                	mv	a0,s6
 618:	dddff0ef          	jal	3f4 <printint>
 61c:	8bca                	mv	s7,s2
      state = 0;
 61e:	4981                	li	s3,0
 620:	bd75                	j	4dc <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 622:	008b8913          	add	s2,s7,8
 626:	4681                	li	a3,0
 628:	4629                	li	a2,10
 62a:	000bb583          	ld	a1,0(s7)
 62e:	855a                	mv	a0,s6
 630:	dc5ff0ef          	jal	3f4 <printint>
        i += 1;
 634:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 636:	8bca                	mv	s7,s2
      state = 0;
 638:	4981                	li	s3,0
        i += 1;
 63a:	b54d                	j	4dc <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 63c:	008b8913          	add	s2,s7,8
 640:	4681                	li	a3,0
 642:	4629                	li	a2,10
 644:	000bb583          	ld	a1,0(s7)
 648:	855a                	mv	a0,s6
 64a:	dabff0ef          	jal	3f4 <printint>
        i += 2;
 64e:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 650:	8bca                	mv	s7,s2
      state = 0;
 652:	4981                	li	s3,0
        i += 2;
 654:	b561                	j	4dc <vprintf+0x4c>
        printint(fd, va_arg(ap, uint32), 16, 0);
 656:	008b8913          	add	s2,s7,8
 65a:	4681                	li	a3,0
 65c:	4641                	li	a2,16
 65e:	000be583          	lwu	a1,0(s7)
 662:	855a                	mv	a0,s6
 664:	d91ff0ef          	jal	3f4 <printint>
 668:	8bca                	mv	s7,s2
      state = 0;
 66a:	4981                	li	s3,0
 66c:	bd85                	j	4dc <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 16, 0);
 66e:	008b8913          	add	s2,s7,8
 672:	4681                	li	a3,0
 674:	4641                	li	a2,16
 676:	000bb583          	ld	a1,0(s7)
 67a:	855a                	mv	a0,s6
 67c:	d79ff0ef          	jal	3f4 <printint>
        i += 1;
 680:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 682:	8bca                	mv	s7,s2
      state = 0;
 684:	4981                	li	s3,0
        i += 1;
 686:	bd99                	j	4dc <vprintf+0x4c>
        printptr(fd, va_arg(ap, uint64));
 688:	008b8d13          	add	s10,s7,8
 68c:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 690:	03000593          	li	a1,48
 694:	855a                	mv	a0,s6
 696:	d41ff0ef          	jal	3d6 <putc>
  putc(fd, 'x');
 69a:	07800593          	li	a1,120
 69e:	855a                	mv	a0,s6
 6a0:	d37ff0ef          	jal	3d6 <putc>
 6a4:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6a6:	00000b97          	auipc	s7,0x0
 6aa:	2dab8b93          	add	s7,s7,730 # 980 <digits>
 6ae:	03c9d793          	srl	a5,s3,0x3c
 6b2:	97de                	add	a5,a5,s7
 6b4:	0007c583          	lbu	a1,0(a5)
 6b8:	855a                	mv	a0,s6
 6ba:	d1dff0ef          	jal	3d6 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6be:	0992                	sll	s3,s3,0x4
 6c0:	397d                	addw	s2,s2,-1
 6c2:	fe0916e3          	bnez	s2,6ae <vprintf+0x21e>
        printptr(fd, va_arg(ap, uint64));
 6c6:	8bea                	mv	s7,s10
      state = 0;
 6c8:	4981                	li	s3,0
 6ca:	bd09                	j	4dc <vprintf+0x4c>
        putc(fd, va_arg(ap, uint32));
 6cc:	008b8913          	add	s2,s7,8
 6d0:	000bc583          	lbu	a1,0(s7)
 6d4:	855a                	mv	a0,s6
 6d6:	d01ff0ef          	jal	3d6 <putc>
 6da:	8bca                	mv	s7,s2
      state = 0;
 6dc:	4981                	li	s3,0
 6de:	bbfd                	j	4dc <vprintf+0x4c>
        if((s = va_arg(ap, char*)) == 0)
 6e0:	008b8993          	add	s3,s7,8
 6e4:	000bb903          	ld	s2,0(s7)
 6e8:	00090f63          	beqz	s2,706 <vprintf+0x276>
        for(; *s; s++)
 6ec:	00094583          	lbu	a1,0(s2)
 6f0:	c195                	beqz	a1,714 <vprintf+0x284>
          putc(fd, *s);
 6f2:	855a                	mv	a0,s6
 6f4:	ce3ff0ef          	jal	3d6 <putc>
        for(; *s; s++)
 6f8:	0905                	add	s2,s2,1
 6fa:	00094583          	lbu	a1,0(s2)
 6fe:	f9f5                	bnez	a1,6f2 <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 700:	8bce                	mv	s7,s3
      state = 0;
 702:	4981                	li	s3,0
 704:	bbe1                	j	4dc <vprintf+0x4c>
          s = "(null)";
 706:	00000917          	auipc	s2,0x0
 70a:	27290913          	add	s2,s2,626 # 978 <malloc+0x164>
        for(; *s; s++)
 70e:	02800593          	li	a1,40
 712:	b7c5                	j	6f2 <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 714:	8bce                	mv	s7,s3
      state = 0;
 716:	4981                	li	s3,0
 718:	b3d1                	j	4dc <vprintf+0x4c>
    }
  }
}
 71a:	60e6                	ld	ra,88(sp)
 71c:	6446                	ld	s0,80(sp)
 71e:	64a6                	ld	s1,72(sp)
 720:	6906                	ld	s2,64(sp)
 722:	79e2                	ld	s3,56(sp)
 724:	7a42                	ld	s4,48(sp)
 726:	7aa2                	ld	s5,40(sp)
 728:	7b02                	ld	s6,32(sp)
 72a:	6be2                	ld	s7,24(sp)
 72c:	6c42                	ld	s8,16(sp)
 72e:	6ca2                	ld	s9,8(sp)
 730:	6d02                	ld	s10,0(sp)
 732:	6125                	add	sp,sp,96
 734:	8082                	ret

0000000000000736 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 736:	715d                	add	sp,sp,-80
 738:	ec06                	sd	ra,24(sp)
 73a:	e822                	sd	s0,16(sp)
 73c:	1000                	add	s0,sp,32
 73e:	e010                	sd	a2,0(s0)
 740:	e414                	sd	a3,8(s0)
 742:	e818                	sd	a4,16(s0)
 744:	ec1c                	sd	a5,24(s0)
 746:	03043023          	sd	a6,32(s0)
 74a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 74e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 752:	8622                	mv	a2,s0
 754:	d3dff0ef          	jal	490 <vprintf>
}
 758:	60e2                	ld	ra,24(sp)
 75a:	6442                	ld	s0,16(sp)
 75c:	6161                	add	sp,sp,80
 75e:	8082                	ret

0000000000000760 <printf>:

void
printf(const char *fmt, ...)
{
 760:	711d                	add	sp,sp,-96
 762:	ec06                	sd	ra,24(sp)
 764:	e822                	sd	s0,16(sp)
 766:	1000                	add	s0,sp,32
 768:	e40c                	sd	a1,8(s0)
 76a:	e810                	sd	a2,16(s0)
 76c:	ec14                	sd	a3,24(s0)
 76e:	f018                	sd	a4,32(s0)
 770:	f41c                	sd	a5,40(s0)
 772:	03043823          	sd	a6,48(s0)
 776:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 77a:	00840613          	add	a2,s0,8
 77e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 782:	85aa                	mv	a1,a0
 784:	4505                	li	a0,1
 786:	d0bff0ef          	jal	490 <vprintf>
}
 78a:	60e2                	ld	ra,24(sp)
 78c:	6442                	ld	s0,16(sp)
 78e:	6125                	add	sp,sp,96
 790:	8082                	ret

0000000000000792 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 792:	1141                	add	sp,sp,-16
 794:	e422                	sd	s0,8(sp)
 796:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 798:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 79c:	00001797          	auipc	a5,0x1
 7a0:	8647b783          	ld	a5,-1948(a5) # 1000 <freep>
 7a4:	a02d                	j	7ce <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7a6:	4618                	lw	a4,8(a2)
 7a8:	9f2d                	addw	a4,a4,a1
 7aa:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7ae:	6398                	ld	a4,0(a5)
 7b0:	6310                	ld	a2,0(a4)
 7b2:	a83d                	j	7f0 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7b4:	ff852703          	lw	a4,-8(a0)
 7b8:	9f31                	addw	a4,a4,a2
 7ba:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7bc:	ff053683          	ld	a3,-16(a0)
 7c0:	a091                	j	804 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7c2:	6398                	ld	a4,0(a5)
 7c4:	00e7e463          	bltu	a5,a4,7cc <free+0x3a>
 7c8:	00e6ea63          	bltu	a3,a4,7dc <free+0x4a>
{
 7cc:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7ce:	fed7fae3          	bgeu	a5,a3,7c2 <free+0x30>
 7d2:	6398                	ld	a4,0(a5)
 7d4:	00e6e463          	bltu	a3,a4,7dc <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7d8:	fee7eae3          	bltu	a5,a4,7cc <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 7dc:	ff852583          	lw	a1,-8(a0)
 7e0:	6390                	ld	a2,0(a5)
 7e2:	02059813          	sll	a6,a1,0x20
 7e6:	01c85713          	srl	a4,a6,0x1c
 7ea:	9736                	add	a4,a4,a3
 7ec:	fae60de3          	beq	a2,a4,7a6 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 7f0:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7f4:	4790                	lw	a2,8(a5)
 7f6:	02061593          	sll	a1,a2,0x20
 7fa:	01c5d713          	srl	a4,a1,0x1c
 7fe:	973e                	add	a4,a4,a5
 800:	fae68ae3          	beq	a3,a4,7b4 <free+0x22>
    p->s.ptr = bp->s.ptr;
 804:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 806:	00000717          	auipc	a4,0x0
 80a:	7ef73d23          	sd	a5,2042(a4) # 1000 <freep>
}
 80e:	6422                	ld	s0,8(sp)
 810:	0141                	add	sp,sp,16
 812:	8082                	ret

0000000000000814 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 814:	7139                	add	sp,sp,-64
 816:	fc06                	sd	ra,56(sp)
 818:	f822                	sd	s0,48(sp)
 81a:	f426                	sd	s1,40(sp)
 81c:	f04a                	sd	s2,32(sp)
 81e:	ec4e                	sd	s3,24(sp)
 820:	e852                	sd	s4,16(sp)
 822:	e456                	sd	s5,8(sp)
 824:	e05a                	sd	s6,0(sp)
 826:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 828:	02051493          	sll	s1,a0,0x20
 82c:	9081                	srl	s1,s1,0x20
 82e:	04bd                	add	s1,s1,15
 830:	8091                	srl	s1,s1,0x4
 832:	0014899b          	addw	s3,s1,1
 836:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 838:	00000517          	auipc	a0,0x0
 83c:	7c853503          	ld	a0,1992(a0) # 1000 <freep>
 840:	c515                	beqz	a0,86c <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 842:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 844:	4798                	lw	a4,8(a5)
 846:	02977f63          	bgeu	a4,s1,884 <malloc+0x70>
  if(nu < 4096)
 84a:	8a4e                	mv	s4,s3
 84c:	0009871b          	sext.w	a4,s3
 850:	6685                	lui	a3,0x1
 852:	00d77363          	bgeu	a4,a3,858 <malloc+0x44>
 856:	6a05                	lui	s4,0x1
 858:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 85c:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 860:	00000917          	auipc	s2,0x0
 864:	7a090913          	add	s2,s2,1952 # 1000 <freep>
  if(p == SBRK_ERROR)
 868:	5afd                	li	s5,-1
 86a:	a885                	j	8da <malloc+0xc6>
    base.s.ptr = freep = prevp = &base;
 86c:	00001797          	auipc	a5,0x1
 870:	99c78793          	add	a5,a5,-1636 # 1208 <base>
 874:	00000717          	auipc	a4,0x0
 878:	78f73623          	sd	a5,1932(a4) # 1000 <freep>
 87c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 87e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 882:	b7e1                	j	84a <malloc+0x36>
      if(p->s.size == nunits)
 884:	02e48c63          	beq	s1,a4,8bc <malloc+0xa8>
        p->s.size -= nunits;
 888:	4137073b          	subw	a4,a4,s3
 88c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 88e:	02071693          	sll	a3,a4,0x20
 892:	01c6d713          	srl	a4,a3,0x1c
 896:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 898:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 89c:	00000717          	auipc	a4,0x0
 8a0:	76a73223          	sd	a0,1892(a4) # 1000 <freep>
      return (void*)(p + 1);
 8a4:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 8a8:	70e2                	ld	ra,56(sp)
 8aa:	7442                	ld	s0,48(sp)
 8ac:	74a2                	ld	s1,40(sp)
 8ae:	7902                	ld	s2,32(sp)
 8b0:	69e2                	ld	s3,24(sp)
 8b2:	6a42                	ld	s4,16(sp)
 8b4:	6aa2                	ld	s5,8(sp)
 8b6:	6b02                	ld	s6,0(sp)
 8b8:	6121                	add	sp,sp,64
 8ba:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 8bc:	6398                	ld	a4,0(a5)
 8be:	e118                	sd	a4,0(a0)
 8c0:	bff1                	j	89c <malloc+0x88>
  hp->s.size = nu;
 8c2:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8c6:	0541                	add	a0,a0,16
 8c8:	ecbff0ef          	jal	792 <free>
  return freep;
 8cc:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 8d0:	dd61                	beqz	a0,8a8 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8d2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8d4:	4798                	lw	a4,8(a5)
 8d6:	fa9777e3          	bgeu	a4,s1,884 <malloc+0x70>
    if(p == freep)
 8da:	00093703          	ld	a4,0(s2)
 8de:	853e                	mv	a0,a5
 8e0:	fef719e3          	bne	a4,a5,8d2 <malloc+0xbe>
  p = sbrk(nu * sizeof(Header));
 8e4:	8552                	mv	a0,s4
 8e6:	a05ff0ef          	jal	2ea <sbrk>
  if(p == SBRK_ERROR)
 8ea:	fd551ce3          	bne	a0,s5,8c2 <malloc+0xae>
        return 0;
 8ee:	4501                	li	a0,0
 8f0:	bf65                	j	8a8 <malloc+0x94>
