
user/_zombie:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(void)
{
   0:	1141                	add	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	add	s0,sp,16
  if(fork() > 0)
   8:	2a2000ef          	jal	2aa <fork>
   c:	00a04563          	bgtz	a0,16 <main+0x16>
    pause(5);  // Let child exit before parent.
  exit(0);
  10:	4501                	li	a0,0
  12:	2a0000ef          	jal	2b2 <exit>
    pause(5);  // Let child exit before parent.
  16:	4515                	li	a0,5
  18:	32a000ef          	jal	342 <pause>
  1c:	bfd5                	j	10 <main+0x10>

000000000000001e <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  1e:	1141                	add	sp,sp,-16
  20:	e406                	sd	ra,8(sp)
  22:	e022                	sd	s0,0(sp)
  24:	0800                	add	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  26:	fdbff0ef          	jal	0 <main>
  exit(r);
  2a:	288000ef          	jal	2b2 <exit>

000000000000002e <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  2e:	1141                	add	sp,sp,-16
  30:	e422                	sd	s0,8(sp)
  32:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  34:	87aa                	mv	a5,a0
  36:	0585                	add	a1,a1,1
  38:	0785                	add	a5,a5,1
  3a:	fff5c703          	lbu	a4,-1(a1)
  3e:	fee78fa3          	sb	a4,-1(a5)
  42:	fb75                	bnez	a4,36 <strcpy+0x8>
    ;
  return os;
}
  44:	6422                	ld	s0,8(sp)
  46:	0141                	add	sp,sp,16
  48:	8082                	ret

000000000000004a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  4a:	1141                	add	sp,sp,-16
  4c:	e422                	sd	s0,8(sp)
  4e:	0800                	add	s0,sp,16
  while(*p && *p == *q)
  50:	00054783          	lbu	a5,0(a0)
  54:	cb91                	beqz	a5,68 <strcmp+0x1e>
  56:	0005c703          	lbu	a4,0(a1)
  5a:	00f71763          	bne	a4,a5,68 <strcmp+0x1e>
    p++, q++;
  5e:	0505                	add	a0,a0,1
  60:	0585                	add	a1,a1,1
  while(*p && *p == *q)
  62:	00054783          	lbu	a5,0(a0)
  66:	fbe5                	bnez	a5,56 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  68:	0005c503          	lbu	a0,0(a1)
}
  6c:	40a7853b          	subw	a0,a5,a0
  70:	6422                	ld	s0,8(sp)
  72:	0141                	add	sp,sp,16
  74:	8082                	ret

0000000000000076 <strlen>:

uint
strlen(const char *s)
{
  76:	1141                	add	sp,sp,-16
  78:	e422                	sd	s0,8(sp)
  7a:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  7c:	00054783          	lbu	a5,0(a0)
  80:	cf91                	beqz	a5,9c <strlen+0x26>
  82:	0505                	add	a0,a0,1
  84:	87aa                	mv	a5,a0
  86:	86be                	mv	a3,a5
  88:	0785                	add	a5,a5,1
  8a:	fff7c703          	lbu	a4,-1(a5)
  8e:	ff65                	bnez	a4,86 <strlen+0x10>
  90:	40a6853b          	subw	a0,a3,a0
  94:	2505                	addw	a0,a0,1
    ;
  return n;
}
  96:	6422                	ld	s0,8(sp)
  98:	0141                	add	sp,sp,16
  9a:	8082                	ret
  for(n = 0; s[n]; n++)
  9c:	4501                	li	a0,0
  9e:	bfe5                	j	96 <strlen+0x20>

00000000000000a0 <memset>:

void*
memset(void *dst, int c, uint n)
{
  a0:	1141                	add	sp,sp,-16
  a2:	e422                	sd	s0,8(sp)
  a4:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  a6:	ca19                	beqz	a2,bc <memset+0x1c>
  a8:	87aa                	mv	a5,a0
  aa:	1602                	sll	a2,a2,0x20
  ac:	9201                	srl	a2,a2,0x20
  ae:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  b2:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  b6:	0785                	add	a5,a5,1
  b8:	fee79de3          	bne	a5,a4,b2 <memset+0x12>
  }
  return dst;
}
  bc:	6422                	ld	s0,8(sp)
  be:	0141                	add	sp,sp,16
  c0:	8082                	ret

00000000000000c2 <strchr>:

char*
strchr(const char *s, char c)
{
  c2:	1141                	add	sp,sp,-16
  c4:	e422                	sd	s0,8(sp)
  c6:	0800                	add	s0,sp,16
  for(; *s; s++)
  c8:	00054783          	lbu	a5,0(a0)
  cc:	cb99                	beqz	a5,e2 <strchr+0x20>
    if(*s == c)
  ce:	00f58763          	beq	a1,a5,dc <strchr+0x1a>
  for(; *s; s++)
  d2:	0505                	add	a0,a0,1
  d4:	00054783          	lbu	a5,0(a0)
  d8:	fbfd                	bnez	a5,ce <strchr+0xc>
      return (char*)s;
  return 0;
  da:	4501                	li	a0,0
}
  dc:	6422                	ld	s0,8(sp)
  de:	0141                	add	sp,sp,16
  e0:	8082                	ret
  return 0;
  e2:	4501                	li	a0,0
  e4:	bfe5                	j	dc <strchr+0x1a>

00000000000000e6 <gets>:

char*
gets(char *buf, int max)
{
  e6:	711d                	add	sp,sp,-96
  e8:	ec86                	sd	ra,88(sp)
  ea:	e8a2                	sd	s0,80(sp)
  ec:	e4a6                	sd	s1,72(sp)
  ee:	e0ca                	sd	s2,64(sp)
  f0:	fc4e                	sd	s3,56(sp)
  f2:	f852                	sd	s4,48(sp)
  f4:	f456                	sd	s5,40(sp)
  f6:	f05a                	sd	s6,32(sp)
  f8:	ec5e                	sd	s7,24(sp)
  fa:	1080                	add	s0,sp,96
  fc:	8baa                	mv	s7,a0
  fe:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 100:	892a                	mv	s2,a0
 102:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 104:	4aa9                	li	s5,10
 106:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 108:	89a6                	mv	s3,s1
 10a:	2485                	addw	s1,s1,1
 10c:	0344d663          	bge	s1,s4,138 <gets+0x52>
    cc = read(0, &c, 1);
 110:	4605                	li	a2,1
 112:	faf40593          	add	a1,s0,-81
 116:	4501                	li	a0,0
 118:	1b2000ef          	jal	2ca <read>
    if(cc < 1)
 11c:	00a05e63          	blez	a0,138 <gets+0x52>
    buf[i++] = c;
 120:	faf44783          	lbu	a5,-81(s0)
 124:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 128:	01578763          	beq	a5,s5,136 <gets+0x50>
 12c:	0905                	add	s2,s2,1
 12e:	fd679de3          	bne	a5,s6,108 <gets+0x22>
  for(i=0; i+1 < max; ){
 132:	89a6                	mv	s3,s1
 134:	a011                	j	138 <gets+0x52>
 136:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 138:	99de                	add	s3,s3,s7
 13a:	00098023          	sb	zero,0(s3)
  return buf;
}
 13e:	855e                	mv	a0,s7
 140:	60e6                	ld	ra,88(sp)
 142:	6446                	ld	s0,80(sp)
 144:	64a6                	ld	s1,72(sp)
 146:	6906                	ld	s2,64(sp)
 148:	79e2                	ld	s3,56(sp)
 14a:	7a42                	ld	s4,48(sp)
 14c:	7aa2                	ld	s5,40(sp)
 14e:	7b02                	ld	s6,32(sp)
 150:	6be2                	ld	s7,24(sp)
 152:	6125                	add	sp,sp,96
 154:	8082                	ret

0000000000000156 <stat>:

int
stat(const char *n, struct stat *st)
{
 156:	1101                	add	sp,sp,-32
 158:	ec06                	sd	ra,24(sp)
 15a:	e822                	sd	s0,16(sp)
 15c:	e426                	sd	s1,8(sp)
 15e:	e04a                	sd	s2,0(sp)
 160:	1000                	add	s0,sp,32
 162:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 164:	4581                	li	a1,0
 166:	18c000ef          	jal	2f2 <open>
  if(fd < 0)
 16a:	02054163          	bltz	a0,18c <stat+0x36>
 16e:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 170:	85ca                	mv	a1,s2
 172:	198000ef          	jal	30a <fstat>
 176:	892a                	mv	s2,a0
  close(fd);
 178:	8526                	mv	a0,s1
 17a:	160000ef          	jal	2da <close>
  return r;
}
 17e:	854a                	mv	a0,s2
 180:	60e2                	ld	ra,24(sp)
 182:	6442                	ld	s0,16(sp)
 184:	64a2                	ld	s1,8(sp)
 186:	6902                	ld	s2,0(sp)
 188:	6105                	add	sp,sp,32
 18a:	8082                	ret
    return -1;
 18c:	597d                	li	s2,-1
 18e:	bfc5                	j	17e <stat+0x28>

0000000000000190 <atoi>:

int
atoi(const char *s)
{
 190:	1141                	add	sp,sp,-16
 192:	e422                	sd	s0,8(sp)
 194:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 196:	00054683          	lbu	a3,0(a0)
 19a:	fd06879b          	addw	a5,a3,-48
 19e:	0ff7f793          	zext.b	a5,a5
 1a2:	4625                	li	a2,9
 1a4:	02f66863          	bltu	a2,a5,1d4 <atoi+0x44>
 1a8:	872a                	mv	a4,a0
  n = 0;
 1aa:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1ac:	0705                	add	a4,a4,1
 1ae:	0025179b          	sllw	a5,a0,0x2
 1b2:	9fa9                	addw	a5,a5,a0
 1b4:	0017979b          	sllw	a5,a5,0x1
 1b8:	9fb5                	addw	a5,a5,a3
 1ba:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1be:	00074683          	lbu	a3,0(a4)
 1c2:	fd06879b          	addw	a5,a3,-48
 1c6:	0ff7f793          	zext.b	a5,a5
 1ca:	fef671e3          	bgeu	a2,a5,1ac <atoi+0x1c>
  return n;
}
 1ce:	6422                	ld	s0,8(sp)
 1d0:	0141                	add	sp,sp,16
 1d2:	8082                	ret
  n = 0;
 1d4:	4501                	li	a0,0
 1d6:	bfe5                	j	1ce <atoi+0x3e>

00000000000001d8 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1d8:	1141                	add	sp,sp,-16
 1da:	e422                	sd	s0,8(sp)
 1dc:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 1de:	02b57463          	bgeu	a0,a1,206 <memmove+0x2e>
    while(n-- > 0)
 1e2:	00c05f63          	blez	a2,200 <memmove+0x28>
 1e6:	1602                	sll	a2,a2,0x20
 1e8:	9201                	srl	a2,a2,0x20
 1ea:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 1ee:	872a                	mv	a4,a0
      *dst++ = *src++;
 1f0:	0585                	add	a1,a1,1
 1f2:	0705                	add	a4,a4,1
 1f4:	fff5c683          	lbu	a3,-1(a1)
 1f8:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 1fc:	fee79ae3          	bne	a5,a4,1f0 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 200:	6422                	ld	s0,8(sp)
 202:	0141                	add	sp,sp,16
 204:	8082                	ret
    dst += n;
 206:	00c50733          	add	a4,a0,a2
    src += n;
 20a:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 20c:	fec05ae3          	blez	a2,200 <memmove+0x28>
 210:	fff6079b          	addw	a5,a2,-1
 214:	1782                	sll	a5,a5,0x20
 216:	9381                	srl	a5,a5,0x20
 218:	fff7c793          	not	a5,a5
 21c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 21e:	15fd                	add	a1,a1,-1
 220:	177d                	add	a4,a4,-1
 222:	0005c683          	lbu	a3,0(a1)
 226:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 22a:	fee79ae3          	bne	a5,a4,21e <memmove+0x46>
 22e:	bfc9                	j	200 <memmove+0x28>

0000000000000230 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 230:	1141                	add	sp,sp,-16
 232:	e422                	sd	s0,8(sp)
 234:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 236:	ca05                	beqz	a2,266 <memcmp+0x36>
 238:	fff6069b          	addw	a3,a2,-1
 23c:	1682                	sll	a3,a3,0x20
 23e:	9281                	srl	a3,a3,0x20
 240:	0685                	add	a3,a3,1
 242:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 244:	00054783          	lbu	a5,0(a0)
 248:	0005c703          	lbu	a4,0(a1)
 24c:	00e79863          	bne	a5,a4,25c <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 250:	0505                	add	a0,a0,1
    p2++;
 252:	0585                	add	a1,a1,1
  while (n-- > 0) {
 254:	fed518e3          	bne	a0,a3,244 <memcmp+0x14>
  }
  return 0;
 258:	4501                	li	a0,0
 25a:	a019                	j	260 <memcmp+0x30>
      return *p1 - *p2;
 25c:	40e7853b          	subw	a0,a5,a4
}
 260:	6422                	ld	s0,8(sp)
 262:	0141                	add	sp,sp,16
 264:	8082                	ret
  return 0;
 266:	4501                	li	a0,0
 268:	bfe5                	j	260 <memcmp+0x30>

000000000000026a <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 26a:	1141                	add	sp,sp,-16
 26c:	e406                	sd	ra,8(sp)
 26e:	e022                	sd	s0,0(sp)
 270:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 272:	f67ff0ef          	jal	1d8 <memmove>
}
 276:	60a2                	ld	ra,8(sp)
 278:	6402                	ld	s0,0(sp)
 27a:	0141                	add	sp,sp,16
 27c:	8082                	ret

000000000000027e <sbrk>:

char *
sbrk(int n) {
 27e:	1141                	add	sp,sp,-16
 280:	e406                	sd	ra,8(sp)
 282:	e022                	sd	s0,0(sp)
 284:	0800                	add	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 286:	4585                	li	a1,1
 288:	0b2000ef          	jal	33a <sys_sbrk>
}
 28c:	60a2                	ld	ra,8(sp)
 28e:	6402                	ld	s0,0(sp)
 290:	0141                	add	sp,sp,16
 292:	8082                	ret

0000000000000294 <sbrklazy>:

char *
sbrklazy(int n) {
 294:	1141                	add	sp,sp,-16
 296:	e406                	sd	ra,8(sp)
 298:	e022                	sd	s0,0(sp)
 29a:	0800                	add	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 29c:	4589                	li	a1,2
 29e:	09c000ef          	jal	33a <sys_sbrk>
}
 2a2:	60a2                	ld	ra,8(sp)
 2a4:	6402                	ld	s0,0(sp)
 2a6:	0141                	add	sp,sp,16
 2a8:	8082                	ret

00000000000002aa <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2aa:	4885                	li	a7,1
 ecall
 2ac:	00000073          	ecall
 ret
 2b0:	8082                	ret

00000000000002b2 <exit>:
.global exit
exit:
 li a7, SYS_exit
 2b2:	4889                	li	a7,2
 ecall
 2b4:	00000073          	ecall
 ret
 2b8:	8082                	ret

00000000000002ba <wait>:
.global wait
wait:
 li a7, SYS_wait
 2ba:	488d                	li	a7,3
 ecall
 2bc:	00000073          	ecall
 ret
 2c0:	8082                	ret

00000000000002c2 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2c2:	4891                	li	a7,4
 ecall
 2c4:	00000073          	ecall
 ret
 2c8:	8082                	ret

00000000000002ca <read>:
.global read
read:
 li a7, SYS_read
 2ca:	4895                	li	a7,5
 ecall
 2cc:	00000073          	ecall
 ret
 2d0:	8082                	ret

00000000000002d2 <write>:
.global write
write:
 li a7, SYS_write
 2d2:	48c1                	li	a7,16
 ecall
 2d4:	00000073          	ecall
 ret
 2d8:	8082                	ret

00000000000002da <close>:
.global close
close:
 li a7, SYS_close
 2da:	48d5                	li	a7,21
 ecall
 2dc:	00000073          	ecall
 ret
 2e0:	8082                	ret

00000000000002e2 <kill>:
.global kill
kill:
 li a7, SYS_kill
 2e2:	4899                	li	a7,6
 ecall
 2e4:	00000073          	ecall
 ret
 2e8:	8082                	ret

00000000000002ea <exec>:
.global exec
exec:
 li a7, SYS_exec
 2ea:	489d                	li	a7,7
 ecall
 2ec:	00000073          	ecall
 ret
 2f0:	8082                	ret

00000000000002f2 <open>:
.global open
open:
 li a7, SYS_open
 2f2:	48bd                	li	a7,15
 ecall
 2f4:	00000073          	ecall
 ret
 2f8:	8082                	ret

00000000000002fa <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 2fa:	48c5                	li	a7,17
 ecall
 2fc:	00000073          	ecall
 ret
 300:	8082                	ret

0000000000000302 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 302:	48c9                	li	a7,18
 ecall
 304:	00000073          	ecall
 ret
 308:	8082                	ret

000000000000030a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 30a:	48a1                	li	a7,8
 ecall
 30c:	00000073          	ecall
 ret
 310:	8082                	ret

0000000000000312 <link>:
.global link
link:
 li a7, SYS_link
 312:	48cd                	li	a7,19
 ecall
 314:	00000073          	ecall
 ret
 318:	8082                	ret

000000000000031a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 31a:	48d1                	li	a7,20
 ecall
 31c:	00000073          	ecall
 ret
 320:	8082                	ret

0000000000000322 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 322:	48a5                	li	a7,9
 ecall
 324:	00000073          	ecall
 ret
 328:	8082                	ret

000000000000032a <dup>:
.global dup
dup:
 li a7, SYS_dup
 32a:	48a9                	li	a7,10
 ecall
 32c:	00000073          	ecall
 ret
 330:	8082                	ret

0000000000000332 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 332:	48ad                	li	a7,11
 ecall
 334:	00000073          	ecall
 ret
 338:	8082                	ret

000000000000033a <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 33a:	48b1                	li	a7,12
 ecall
 33c:	00000073          	ecall
 ret
 340:	8082                	ret

0000000000000342 <pause>:
.global pause
pause:
 li a7, SYS_pause
 342:	48b5                	li	a7,13
 ecall
 344:	00000073          	ecall
 ret
 348:	8082                	ret

000000000000034a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 34a:	48b9                	li	a7,14
 ecall
 34c:	00000073          	ecall
 ret
 350:	8082                	ret

0000000000000352 <getcnt>:
.global getcnt
getcnt:
 li a7, SYS_getcnt
 352:	48d9                	li	a7,22
 ecall
 354:	00000073          	ecall
 ret
 358:	8082                	ret

000000000000035a <settickets>:
.global settickets
settickets:
 li a7, SYS_settickets
 35a:	48dd                	li	a7,23
 ecall
 35c:	00000073          	ecall
 ret
 360:	8082                	ret

0000000000000362 <getpinfo>:
.global getpinfo
getpinfo:
 li a7, SYS_getpinfo
 362:	48e1                	li	a7,24
 ecall
 364:	00000073          	ecall
 ret
 368:	8082                	ret

000000000000036a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 36a:	1101                	add	sp,sp,-32
 36c:	ec06                	sd	ra,24(sp)
 36e:	e822                	sd	s0,16(sp)
 370:	1000                	add	s0,sp,32
 372:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 376:	4605                	li	a2,1
 378:	fef40593          	add	a1,s0,-17
 37c:	f57ff0ef          	jal	2d2 <write>
}
 380:	60e2                	ld	ra,24(sp)
 382:	6442                	ld	s0,16(sp)
 384:	6105                	add	sp,sp,32
 386:	8082                	ret

0000000000000388 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 388:	715d                	add	sp,sp,-80
 38a:	e486                	sd	ra,72(sp)
 38c:	e0a2                	sd	s0,64(sp)
 38e:	fc26                	sd	s1,56(sp)
 390:	f84a                	sd	s2,48(sp)
 392:	f44e                	sd	s3,40(sp)
 394:	0880                	add	s0,sp,80
 396:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 398:	c299                	beqz	a3,39e <printint+0x16>
 39a:	0805c163          	bltz	a1,41c <printint+0x94>
  neg = 0;
 39e:	4881                	li	a7,0
 3a0:	fb840693          	add	a3,s0,-72
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 3a4:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 3a6:	00000517          	auipc	a0,0x0
 3aa:	4f250513          	add	a0,a0,1266 # 898 <digits>
 3ae:	883e                	mv	a6,a5
 3b0:	2785                	addw	a5,a5,1
 3b2:	02c5f733          	remu	a4,a1,a2
 3b6:	972a                	add	a4,a4,a0
 3b8:	00074703          	lbu	a4,0(a4)
 3bc:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 3c0:	872e                	mv	a4,a1
 3c2:	02c5d5b3          	divu	a1,a1,a2
 3c6:	0685                	add	a3,a3,1
 3c8:	fec773e3          	bgeu	a4,a2,3ae <printint+0x26>
  if(neg)
 3cc:	00088b63          	beqz	a7,3e2 <printint+0x5a>
    buf[i++] = '-';
 3d0:	fd078793          	add	a5,a5,-48
 3d4:	97a2                	add	a5,a5,s0
 3d6:	02d00713          	li	a4,45
 3da:	fee78423          	sb	a4,-24(a5)
 3de:	0028079b          	addw	a5,a6,2

  while(--i >= 0)
 3e2:	02f05663          	blez	a5,40e <printint+0x86>
 3e6:	fb840713          	add	a4,s0,-72
 3ea:	00f704b3          	add	s1,a4,a5
 3ee:	fff70993          	add	s3,a4,-1
 3f2:	99be                	add	s3,s3,a5
 3f4:	37fd                	addw	a5,a5,-1
 3f6:	1782                	sll	a5,a5,0x20
 3f8:	9381                	srl	a5,a5,0x20
 3fa:	40f989b3          	sub	s3,s3,a5
    putc(fd, buf[i]);
 3fe:	fff4c583          	lbu	a1,-1(s1)
 402:	854a                	mv	a0,s2
 404:	f67ff0ef          	jal	36a <putc>
  while(--i >= 0)
 408:	14fd                	add	s1,s1,-1
 40a:	ff349ae3          	bne	s1,s3,3fe <printint+0x76>
}
 40e:	60a6                	ld	ra,72(sp)
 410:	6406                	ld	s0,64(sp)
 412:	74e2                	ld	s1,56(sp)
 414:	7942                	ld	s2,48(sp)
 416:	79a2                	ld	s3,40(sp)
 418:	6161                	add	sp,sp,80
 41a:	8082                	ret
    x = -xx;
 41c:	40b005b3          	neg	a1,a1
    neg = 1;
 420:	4885                	li	a7,1
    x = -xx;
 422:	bfbd                	j	3a0 <printint+0x18>

0000000000000424 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 424:	711d                	add	sp,sp,-96
 426:	ec86                	sd	ra,88(sp)
 428:	e8a2                	sd	s0,80(sp)
 42a:	e4a6                	sd	s1,72(sp)
 42c:	e0ca                	sd	s2,64(sp)
 42e:	fc4e                	sd	s3,56(sp)
 430:	f852                	sd	s4,48(sp)
 432:	f456                	sd	s5,40(sp)
 434:	f05a                	sd	s6,32(sp)
 436:	ec5e                	sd	s7,24(sp)
 438:	e862                	sd	s8,16(sp)
 43a:	e466                	sd	s9,8(sp)
 43c:	e06a                	sd	s10,0(sp)
 43e:	1080                	add	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 440:	0005c903          	lbu	s2,0(a1)
 444:	26090563          	beqz	s2,6ae <vprintf+0x28a>
 448:	8b2a                	mv	s6,a0
 44a:	8a2e                	mv	s4,a1
 44c:	8bb2                	mv	s7,a2
  state = 0;
 44e:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 450:	4481                	li	s1,0
 452:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 454:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 458:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 45c:	06c00c93          	li	s9,108
 460:	a005                	j	480 <vprintf+0x5c>
        putc(fd, c0);
 462:	85ca                	mv	a1,s2
 464:	855a                	mv	a0,s6
 466:	f05ff0ef          	jal	36a <putc>
 46a:	a019                	j	470 <vprintf+0x4c>
    } else if(state == '%'){
 46c:	03598263          	beq	s3,s5,490 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 470:	2485                	addw	s1,s1,1
 472:	8726                	mv	a4,s1
 474:	009a07b3          	add	a5,s4,s1
 478:	0007c903          	lbu	s2,0(a5)
 47c:	22090963          	beqz	s2,6ae <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
 480:	0009079b          	sext.w	a5,s2
    if(state == 0){
 484:	fe0994e3          	bnez	s3,46c <vprintf+0x48>
      if(c0 == '%'){
 488:	fd579de3          	bne	a5,s5,462 <vprintf+0x3e>
        state = '%';
 48c:	89be                	mv	s3,a5
 48e:	b7cd                	j	470 <vprintf+0x4c>
      if(c0) c1 = fmt[i+1] & 0xff;
 490:	cbc9                	beqz	a5,522 <vprintf+0xfe>
 492:	00ea06b3          	add	a3,s4,a4
 496:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 49a:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 49c:	c681                	beqz	a3,4a4 <vprintf+0x80>
 49e:	9752                	add	a4,a4,s4
 4a0:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 4a4:	05878363          	beq	a5,s8,4ea <vprintf+0xc6>
      } else if(c0 == 'l' && c1 == 'd'){
 4a8:	05978d63          	beq	a5,s9,502 <vprintf+0xde>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 4ac:	07500713          	li	a4,117
 4b0:	0ee78763          	beq	a5,a4,59e <vprintf+0x17a>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 4b4:	07800713          	li	a4,120
 4b8:	12e78963          	beq	a5,a4,5ea <vprintf+0x1c6>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 4bc:	07000713          	li	a4,112
 4c0:	14e78e63          	beq	a5,a4,61c <vprintf+0x1f8>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 4c4:	06300713          	li	a4,99
 4c8:	18e78c63          	beq	a5,a4,660 <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 4cc:	07300713          	li	a4,115
 4d0:	1ae78263          	beq	a5,a4,674 <vprintf+0x250>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 4d4:	02500713          	li	a4,37
 4d8:	04e79563          	bne	a5,a4,522 <vprintf+0xfe>
        putc(fd, '%');
 4dc:	02500593          	li	a1,37
 4e0:	855a                	mv	a0,s6
 4e2:	e89ff0ef          	jal	36a <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 4e6:	4981                	li	s3,0
 4e8:	b761                	j	470 <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 10, 1);
 4ea:	008b8913          	add	s2,s7,8
 4ee:	4685                	li	a3,1
 4f0:	4629                	li	a2,10
 4f2:	000ba583          	lw	a1,0(s7)
 4f6:	855a                	mv	a0,s6
 4f8:	e91ff0ef          	jal	388 <printint>
 4fc:	8bca                	mv	s7,s2
      state = 0;
 4fe:	4981                	li	s3,0
 500:	bf85                	j	470 <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'd'){
 502:	06400793          	li	a5,100
 506:	02f68963          	beq	a3,a5,538 <vprintf+0x114>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 50a:	06c00793          	li	a5,108
 50e:	04f68263          	beq	a3,a5,552 <vprintf+0x12e>
      } else if(c0 == 'l' && c1 == 'u'){
 512:	07500793          	li	a5,117
 516:	0af68063          	beq	a3,a5,5b6 <vprintf+0x192>
      } else if(c0 == 'l' && c1 == 'x'){
 51a:	07800793          	li	a5,120
 51e:	0ef68263          	beq	a3,a5,602 <vprintf+0x1de>
        putc(fd, '%');
 522:	02500593          	li	a1,37
 526:	855a                	mv	a0,s6
 528:	e43ff0ef          	jal	36a <putc>
        putc(fd, c0);
 52c:	85ca                	mv	a1,s2
 52e:	855a                	mv	a0,s6
 530:	e3bff0ef          	jal	36a <putc>
      state = 0;
 534:	4981                	li	s3,0
 536:	bf2d                	j	470 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 538:	008b8913          	add	s2,s7,8
 53c:	4685                	li	a3,1
 53e:	4629                	li	a2,10
 540:	000bb583          	ld	a1,0(s7)
 544:	855a                	mv	a0,s6
 546:	e43ff0ef          	jal	388 <printint>
        i += 1;
 54a:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 54c:	8bca                	mv	s7,s2
      state = 0;
 54e:	4981                	li	s3,0
        i += 1;
 550:	b705                	j	470 <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 552:	06400793          	li	a5,100
 556:	02f60763          	beq	a2,a5,584 <vprintf+0x160>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 55a:	07500793          	li	a5,117
 55e:	06f60963          	beq	a2,a5,5d0 <vprintf+0x1ac>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 562:	07800793          	li	a5,120
 566:	faf61ee3          	bne	a2,a5,522 <vprintf+0xfe>
        printint(fd, va_arg(ap, uint64), 16, 0);
 56a:	008b8913          	add	s2,s7,8
 56e:	4681                	li	a3,0
 570:	4641                	li	a2,16
 572:	000bb583          	ld	a1,0(s7)
 576:	855a                	mv	a0,s6
 578:	e11ff0ef          	jal	388 <printint>
        i += 2;
 57c:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 57e:	8bca                	mv	s7,s2
      state = 0;
 580:	4981                	li	s3,0
        i += 2;
 582:	b5fd                	j	470 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 584:	008b8913          	add	s2,s7,8
 588:	4685                	li	a3,1
 58a:	4629                	li	a2,10
 58c:	000bb583          	ld	a1,0(s7)
 590:	855a                	mv	a0,s6
 592:	df7ff0ef          	jal	388 <printint>
        i += 2;
 596:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 598:	8bca                	mv	s7,s2
      state = 0;
 59a:	4981                	li	s3,0
        i += 2;
 59c:	bdd1                	j	470 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint32), 10, 0);
 59e:	008b8913          	add	s2,s7,8
 5a2:	4681                	li	a3,0
 5a4:	4629                	li	a2,10
 5a6:	000be583          	lwu	a1,0(s7)
 5aa:	855a                	mv	a0,s6
 5ac:	dddff0ef          	jal	388 <printint>
 5b0:	8bca                	mv	s7,s2
      state = 0;
 5b2:	4981                	li	s3,0
 5b4:	bd75                	j	470 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5b6:	008b8913          	add	s2,s7,8
 5ba:	4681                	li	a3,0
 5bc:	4629                	li	a2,10
 5be:	000bb583          	ld	a1,0(s7)
 5c2:	855a                	mv	a0,s6
 5c4:	dc5ff0ef          	jal	388 <printint>
        i += 1;
 5c8:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 5ca:	8bca                	mv	s7,s2
      state = 0;
 5cc:	4981                	li	s3,0
        i += 1;
 5ce:	b54d                	j	470 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5d0:	008b8913          	add	s2,s7,8
 5d4:	4681                	li	a3,0
 5d6:	4629                	li	a2,10
 5d8:	000bb583          	ld	a1,0(s7)
 5dc:	855a                	mv	a0,s6
 5de:	dabff0ef          	jal	388 <printint>
        i += 2;
 5e2:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 5e4:	8bca                	mv	s7,s2
      state = 0;
 5e6:	4981                	li	s3,0
        i += 2;
 5e8:	b561                	j	470 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint32), 16, 0);
 5ea:	008b8913          	add	s2,s7,8
 5ee:	4681                	li	a3,0
 5f0:	4641                	li	a2,16
 5f2:	000be583          	lwu	a1,0(s7)
 5f6:	855a                	mv	a0,s6
 5f8:	d91ff0ef          	jal	388 <printint>
 5fc:	8bca                	mv	s7,s2
      state = 0;
 5fe:	4981                	li	s3,0
 600:	bd85                	j	470 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 16, 0);
 602:	008b8913          	add	s2,s7,8
 606:	4681                	li	a3,0
 608:	4641                	li	a2,16
 60a:	000bb583          	ld	a1,0(s7)
 60e:	855a                	mv	a0,s6
 610:	d79ff0ef          	jal	388 <printint>
        i += 1;
 614:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 616:	8bca                	mv	s7,s2
      state = 0;
 618:	4981                	li	s3,0
        i += 1;
 61a:	bd99                	j	470 <vprintf+0x4c>
        printptr(fd, va_arg(ap, uint64));
 61c:	008b8d13          	add	s10,s7,8
 620:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 624:	03000593          	li	a1,48
 628:	855a                	mv	a0,s6
 62a:	d41ff0ef          	jal	36a <putc>
  putc(fd, 'x');
 62e:	07800593          	li	a1,120
 632:	855a                	mv	a0,s6
 634:	d37ff0ef          	jal	36a <putc>
 638:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 63a:	00000b97          	auipc	s7,0x0
 63e:	25eb8b93          	add	s7,s7,606 # 898 <digits>
 642:	03c9d793          	srl	a5,s3,0x3c
 646:	97de                	add	a5,a5,s7
 648:	0007c583          	lbu	a1,0(a5)
 64c:	855a                	mv	a0,s6
 64e:	d1dff0ef          	jal	36a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 652:	0992                	sll	s3,s3,0x4
 654:	397d                	addw	s2,s2,-1
 656:	fe0916e3          	bnez	s2,642 <vprintf+0x21e>
        printptr(fd, va_arg(ap, uint64));
 65a:	8bea                	mv	s7,s10
      state = 0;
 65c:	4981                	li	s3,0
 65e:	bd09                	j	470 <vprintf+0x4c>
        putc(fd, va_arg(ap, uint32));
 660:	008b8913          	add	s2,s7,8
 664:	000bc583          	lbu	a1,0(s7)
 668:	855a                	mv	a0,s6
 66a:	d01ff0ef          	jal	36a <putc>
 66e:	8bca                	mv	s7,s2
      state = 0;
 670:	4981                	li	s3,0
 672:	bbfd                	j	470 <vprintf+0x4c>
        if((s = va_arg(ap, char*)) == 0)
 674:	008b8993          	add	s3,s7,8
 678:	000bb903          	ld	s2,0(s7)
 67c:	00090f63          	beqz	s2,69a <vprintf+0x276>
        for(; *s; s++)
 680:	00094583          	lbu	a1,0(s2)
 684:	c195                	beqz	a1,6a8 <vprintf+0x284>
          putc(fd, *s);
 686:	855a                	mv	a0,s6
 688:	ce3ff0ef          	jal	36a <putc>
        for(; *s; s++)
 68c:	0905                	add	s2,s2,1
 68e:	00094583          	lbu	a1,0(s2)
 692:	f9f5                	bnez	a1,686 <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 694:	8bce                	mv	s7,s3
      state = 0;
 696:	4981                	li	s3,0
 698:	bbe1                	j	470 <vprintf+0x4c>
          s = "(null)";
 69a:	00000917          	auipc	s2,0x0
 69e:	1f690913          	add	s2,s2,502 # 890 <malloc+0xe8>
        for(; *s; s++)
 6a2:	02800593          	li	a1,40
 6a6:	b7c5                	j	686 <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 6a8:	8bce                	mv	s7,s3
      state = 0;
 6aa:	4981                	li	s3,0
 6ac:	b3d1                	j	470 <vprintf+0x4c>
    }
  }
}
 6ae:	60e6                	ld	ra,88(sp)
 6b0:	6446                	ld	s0,80(sp)
 6b2:	64a6                	ld	s1,72(sp)
 6b4:	6906                	ld	s2,64(sp)
 6b6:	79e2                	ld	s3,56(sp)
 6b8:	7a42                	ld	s4,48(sp)
 6ba:	7aa2                	ld	s5,40(sp)
 6bc:	7b02                	ld	s6,32(sp)
 6be:	6be2                	ld	s7,24(sp)
 6c0:	6c42                	ld	s8,16(sp)
 6c2:	6ca2                	ld	s9,8(sp)
 6c4:	6d02                	ld	s10,0(sp)
 6c6:	6125                	add	sp,sp,96
 6c8:	8082                	ret

00000000000006ca <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6ca:	715d                	add	sp,sp,-80
 6cc:	ec06                	sd	ra,24(sp)
 6ce:	e822                	sd	s0,16(sp)
 6d0:	1000                	add	s0,sp,32
 6d2:	e010                	sd	a2,0(s0)
 6d4:	e414                	sd	a3,8(s0)
 6d6:	e818                	sd	a4,16(s0)
 6d8:	ec1c                	sd	a5,24(s0)
 6da:	03043023          	sd	a6,32(s0)
 6de:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6e2:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6e6:	8622                	mv	a2,s0
 6e8:	d3dff0ef          	jal	424 <vprintf>
}
 6ec:	60e2                	ld	ra,24(sp)
 6ee:	6442                	ld	s0,16(sp)
 6f0:	6161                	add	sp,sp,80
 6f2:	8082                	ret

00000000000006f4 <printf>:

void
printf(const char *fmt, ...)
{
 6f4:	711d                	add	sp,sp,-96
 6f6:	ec06                	sd	ra,24(sp)
 6f8:	e822                	sd	s0,16(sp)
 6fa:	1000                	add	s0,sp,32
 6fc:	e40c                	sd	a1,8(s0)
 6fe:	e810                	sd	a2,16(s0)
 700:	ec14                	sd	a3,24(s0)
 702:	f018                	sd	a4,32(s0)
 704:	f41c                	sd	a5,40(s0)
 706:	03043823          	sd	a6,48(s0)
 70a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 70e:	00840613          	add	a2,s0,8
 712:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 716:	85aa                	mv	a1,a0
 718:	4505                	li	a0,1
 71a:	d0bff0ef          	jal	424 <vprintf>
}
 71e:	60e2                	ld	ra,24(sp)
 720:	6442                	ld	s0,16(sp)
 722:	6125                	add	sp,sp,96
 724:	8082                	ret

0000000000000726 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 726:	1141                	add	sp,sp,-16
 728:	e422                	sd	s0,8(sp)
 72a:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 72c:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 730:	00001797          	auipc	a5,0x1
 734:	8d07b783          	ld	a5,-1840(a5) # 1000 <freep>
 738:	a02d                	j	762 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 73a:	4618                	lw	a4,8(a2)
 73c:	9f2d                	addw	a4,a4,a1
 73e:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 742:	6398                	ld	a4,0(a5)
 744:	6310                	ld	a2,0(a4)
 746:	a83d                	j	784 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 748:	ff852703          	lw	a4,-8(a0)
 74c:	9f31                	addw	a4,a4,a2
 74e:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 750:	ff053683          	ld	a3,-16(a0)
 754:	a091                	j	798 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 756:	6398                	ld	a4,0(a5)
 758:	00e7e463          	bltu	a5,a4,760 <free+0x3a>
 75c:	00e6ea63          	bltu	a3,a4,770 <free+0x4a>
{
 760:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 762:	fed7fae3          	bgeu	a5,a3,756 <free+0x30>
 766:	6398                	ld	a4,0(a5)
 768:	00e6e463          	bltu	a3,a4,770 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 76c:	fee7eae3          	bltu	a5,a4,760 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 770:	ff852583          	lw	a1,-8(a0)
 774:	6390                	ld	a2,0(a5)
 776:	02059813          	sll	a6,a1,0x20
 77a:	01c85713          	srl	a4,a6,0x1c
 77e:	9736                	add	a4,a4,a3
 780:	fae60de3          	beq	a2,a4,73a <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 784:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 788:	4790                	lw	a2,8(a5)
 78a:	02061593          	sll	a1,a2,0x20
 78e:	01c5d713          	srl	a4,a1,0x1c
 792:	973e                	add	a4,a4,a5
 794:	fae68ae3          	beq	a3,a4,748 <free+0x22>
    p->s.ptr = bp->s.ptr;
 798:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 79a:	00001717          	auipc	a4,0x1
 79e:	86f73323          	sd	a5,-1946(a4) # 1000 <freep>
}
 7a2:	6422                	ld	s0,8(sp)
 7a4:	0141                	add	sp,sp,16
 7a6:	8082                	ret

00000000000007a8 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7a8:	7139                	add	sp,sp,-64
 7aa:	fc06                	sd	ra,56(sp)
 7ac:	f822                	sd	s0,48(sp)
 7ae:	f426                	sd	s1,40(sp)
 7b0:	f04a                	sd	s2,32(sp)
 7b2:	ec4e                	sd	s3,24(sp)
 7b4:	e852                	sd	s4,16(sp)
 7b6:	e456                	sd	s5,8(sp)
 7b8:	e05a                	sd	s6,0(sp)
 7ba:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7bc:	02051493          	sll	s1,a0,0x20
 7c0:	9081                	srl	s1,s1,0x20
 7c2:	04bd                	add	s1,s1,15
 7c4:	8091                	srl	s1,s1,0x4
 7c6:	0014899b          	addw	s3,s1,1
 7ca:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 7cc:	00001517          	auipc	a0,0x1
 7d0:	83453503          	ld	a0,-1996(a0) # 1000 <freep>
 7d4:	c515                	beqz	a0,800 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7d6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7d8:	4798                	lw	a4,8(a5)
 7da:	02977f63          	bgeu	a4,s1,818 <malloc+0x70>
  if(nu < 4096)
 7de:	8a4e                	mv	s4,s3
 7e0:	0009871b          	sext.w	a4,s3
 7e4:	6685                	lui	a3,0x1
 7e6:	00d77363          	bgeu	a4,a3,7ec <malloc+0x44>
 7ea:	6a05                	lui	s4,0x1
 7ec:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7f0:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7f4:	00001917          	auipc	s2,0x1
 7f8:	80c90913          	add	s2,s2,-2036 # 1000 <freep>
  if(p == SBRK_ERROR)
 7fc:	5afd                	li	s5,-1
 7fe:	a885                	j	86e <malloc+0xc6>
    base.s.ptr = freep = prevp = &base;
 800:	00001797          	auipc	a5,0x1
 804:	81078793          	add	a5,a5,-2032 # 1010 <base>
 808:	00000717          	auipc	a4,0x0
 80c:	7ef73c23          	sd	a5,2040(a4) # 1000 <freep>
 810:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 812:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 816:	b7e1                	j	7de <malloc+0x36>
      if(p->s.size == nunits)
 818:	02e48c63          	beq	s1,a4,850 <malloc+0xa8>
        p->s.size -= nunits;
 81c:	4137073b          	subw	a4,a4,s3
 820:	c798                	sw	a4,8(a5)
        p += p->s.size;
 822:	02071693          	sll	a3,a4,0x20
 826:	01c6d713          	srl	a4,a3,0x1c
 82a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 82c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 830:	00000717          	auipc	a4,0x0
 834:	7ca73823          	sd	a0,2000(a4) # 1000 <freep>
      return (void*)(p + 1);
 838:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 83c:	70e2                	ld	ra,56(sp)
 83e:	7442                	ld	s0,48(sp)
 840:	74a2                	ld	s1,40(sp)
 842:	7902                	ld	s2,32(sp)
 844:	69e2                	ld	s3,24(sp)
 846:	6a42                	ld	s4,16(sp)
 848:	6aa2                	ld	s5,8(sp)
 84a:	6b02                	ld	s6,0(sp)
 84c:	6121                	add	sp,sp,64
 84e:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 850:	6398                	ld	a4,0(a5)
 852:	e118                	sd	a4,0(a0)
 854:	bff1                	j	830 <malloc+0x88>
  hp->s.size = nu;
 856:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 85a:	0541                	add	a0,a0,16
 85c:	ecbff0ef          	jal	726 <free>
  return freep;
 860:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 864:	dd61                	beqz	a0,83c <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 866:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 868:	4798                	lw	a4,8(a5)
 86a:	fa9777e3          	bgeu	a4,s1,818 <malloc+0x70>
    if(p == freep)
 86e:	00093703          	ld	a4,0(s2)
 872:	853e                	mv	a0,a5
 874:	fef719e3          	bne	a4,a5,866 <malloc+0xbe>
  p = sbrk(nu * sizeof(Header));
 878:	8552                	mv	a0,s4
 87a:	a05ff0ef          	jal	27e <sbrk>
  if(p == SBRK_ERROR)
 87e:	fd551ce3          	bne	a0,s5,856 <malloc+0xae>
        return 0;
 882:	4501                	li	a0,0
 884:	bf65                	j	83c <malloc+0x94>
