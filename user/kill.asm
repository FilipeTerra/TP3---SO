
user/_kill:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char **argv)
{
   0:	1101                	add	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	add	s0,sp,32
  int i;

  if(argc < 2){
   c:	4785                	li	a5,1
   e:	02a7d763          	bge	a5,a0,3c <main+0x3c>
  12:	00858493          	add	s1,a1,8
  16:	ffe5091b          	addw	s2,a0,-2
  1a:	02091793          	sll	a5,s2,0x20
  1e:	01d7d913          	srl	s2,a5,0x1d
  22:	05c1                	add	a1,a1,16
  24:	992e                	add	s2,s2,a1
    fprintf(2, "usage: kill pid...\n");
    exit(1);
  }
  for(i=1; i<argc; i++)
    kill(atoi(argv[i]));
  26:	6088                	ld	a0,0(s1)
  28:	19a000ef          	jal	1c2 <atoi>
  2c:	2e8000ef          	jal	314 <kill>
  for(i=1; i<argc; i++)
  30:	04a1                	add	s1,s1,8
  32:	ff249ae3          	bne	s1,s2,26 <main+0x26>
  exit(0);
  36:	4501                	li	a0,0
  38:	2ac000ef          	jal	2e4 <exit>
    fprintf(2, "usage: kill pid...\n");
  3c:	00001597          	auipc	a1,0x1
  40:	88458593          	add	a1,a1,-1916 # 8c0 <malloc+0xe6>
  44:	4509                	li	a0,2
  46:	6b6000ef          	jal	6fc <fprintf>
    exit(1);
  4a:	4505                	li	a0,1
  4c:	298000ef          	jal	2e4 <exit>

0000000000000050 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  50:	1141                	add	sp,sp,-16
  52:	e406                	sd	ra,8(sp)
  54:	e022                	sd	s0,0(sp)
  56:	0800                	add	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  58:	fa9ff0ef          	jal	0 <main>
  exit(r);
  5c:	288000ef          	jal	2e4 <exit>

0000000000000060 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  60:	1141                	add	sp,sp,-16
  62:	e422                	sd	s0,8(sp)
  64:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  66:	87aa                	mv	a5,a0
  68:	0585                	add	a1,a1,1
  6a:	0785                	add	a5,a5,1
  6c:	fff5c703          	lbu	a4,-1(a1)
  70:	fee78fa3          	sb	a4,-1(a5)
  74:	fb75                	bnez	a4,68 <strcpy+0x8>
    ;
  return os;
}
  76:	6422                	ld	s0,8(sp)
  78:	0141                	add	sp,sp,16
  7a:	8082                	ret

000000000000007c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  7c:	1141                	add	sp,sp,-16
  7e:	e422                	sd	s0,8(sp)
  80:	0800                	add	s0,sp,16
  while(*p && *p == *q)
  82:	00054783          	lbu	a5,0(a0)
  86:	cb91                	beqz	a5,9a <strcmp+0x1e>
  88:	0005c703          	lbu	a4,0(a1)
  8c:	00f71763          	bne	a4,a5,9a <strcmp+0x1e>
    p++, q++;
  90:	0505                	add	a0,a0,1
  92:	0585                	add	a1,a1,1
  while(*p && *p == *q)
  94:	00054783          	lbu	a5,0(a0)
  98:	fbe5                	bnez	a5,88 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  9a:	0005c503          	lbu	a0,0(a1)
}
  9e:	40a7853b          	subw	a0,a5,a0
  a2:	6422                	ld	s0,8(sp)
  a4:	0141                	add	sp,sp,16
  a6:	8082                	ret

00000000000000a8 <strlen>:

uint
strlen(const char *s)
{
  a8:	1141                	add	sp,sp,-16
  aa:	e422                	sd	s0,8(sp)
  ac:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  ae:	00054783          	lbu	a5,0(a0)
  b2:	cf91                	beqz	a5,ce <strlen+0x26>
  b4:	0505                	add	a0,a0,1
  b6:	87aa                	mv	a5,a0
  b8:	86be                	mv	a3,a5
  ba:	0785                	add	a5,a5,1
  bc:	fff7c703          	lbu	a4,-1(a5)
  c0:	ff65                	bnez	a4,b8 <strlen+0x10>
  c2:	40a6853b          	subw	a0,a3,a0
  c6:	2505                	addw	a0,a0,1
    ;
  return n;
}
  c8:	6422                	ld	s0,8(sp)
  ca:	0141                	add	sp,sp,16
  cc:	8082                	ret
  for(n = 0; s[n]; n++)
  ce:	4501                	li	a0,0
  d0:	bfe5                	j	c8 <strlen+0x20>

00000000000000d2 <memset>:

void*
memset(void *dst, int c, uint n)
{
  d2:	1141                	add	sp,sp,-16
  d4:	e422                	sd	s0,8(sp)
  d6:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  d8:	ca19                	beqz	a2,ee <memset+0x1c>
  da:	87aa                	mv	a5,a0
  dc:	1602                	sll	a2,a2,0x20
  de:	9201                	srl	a2,a2,0x20
  e0:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  e4:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  e8:	0785                	add	a5,a5,1
  ea:	fee79de3          	bne	a5,a4,e4 <memset+0x12>
  }
  return dst;
}
  ee:	6422                	ld	s0,8(sp)
  f0:	0141                	add	sp,sp,16
  f2:	8082                	ret

00000000000000f4 <strchr>:

char*
strchr(const char *s, char c)
{
  f4:	1141                	add	sp,sp,-16
  f6:	e422                	sd	s0,8(sp)
  f8:	0800                	add	s0,sp,16
  for(; *s; s++)
  fa:	00054783          	lbu	a5,0(a0)
  fe:	cb99                	beqz	a5,114 <strchr+0x20>
    if(*s == c)
 100:	00f58763          	beq	a1,a5,10e <strchr+0x1a>
  for(; *s; s++)
 104:	0505                	add	a0,a0,1
 106:	00054783          	lbu	a5,0(a0)
 10a:	fbfd                	bnez	a5,100 <strchr+0xc>
      return (char*)s;
  return 0;
 10c:	4501                	li	a0,0
}
 10e:	6422                	ld	s0,8(sp)
 110:	0141                	add	sp,sp,16
 112:	8082                	ret
  return 0;
 114:	4501                	li	a0,0
 116:	bfe5                	j	10e <strchr+0x1a>

0000000000000118 <gets>:

char*
gets(char *buf, int max)
{
 118:	711d                	add	sp,sp,-96
 11a:	ec86                	sd	ra,88(sp)
 11c:	e8a2                	sd	s0,80(sp)
 11e:	e4a6                	sd	s1,72(sp)
 120:	e0ca                	sd	s2,64(sp)
 122:	fc4e                	sd	s3,56(sp)
 124:	f852                	sd	s4,48(sp)
 126:	f456                	sd	s5,40(sp)
 128:	f05a                	sd	s6,32(sp)
 12a:	ec5e                	sd	s7,24(sp)
 12c:	1080                	add	s0,sp,96
 12e:	8baa                	mv	s7,a0
 130:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 132:	892a                	mv	s2,a0
 134:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 136:	4aa9                	li	s5,10
 138:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 13a:	89a6                	mv	s3,s1
 13c:	2485                	addw	s1,s1,1
 13e:	0344d663          	bge	s1,s4,16a <gets+0x52>
    cc = read(0, &c, 1);
 142:	4605                	li	a2,1
 144:	faf40593          	add	a1,s0,-81
 148:	4501                	li	a0,0
 14a:	1b2000ef          	jal	2fc <read>
    if(cc < 1)
 14e:	00a05e63          	blez	a0,16a <gets+0x52>
    buf[i++] = c;
 152:	faf44783          	lbu	a5,-81(s0)
 156:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 15a:	01578763          	beq	a5,s5,168 <gets+0x50>
 15e:	0905                	add	s2,s2,1
 160:	fd679de3          	bne	a5,s6,13a <gets+0x22>
  for(i=0; i+1 < max; ){
 164:	89a6                	mv	s3,s1
 166:	a011                	j	16a <gets+0x52>
 168:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 16a:	99de                	add	s3,s3,s7
 16c:	00098023          	sb	zero,0(s3)
  return buf;
}
 170:	855e                	mv	a0,s7
 172:	60e6                	ld	ra,88(sp)
 174:	6446                	ld	s0,80(sp)
 176:	64a6                	ld	s1,72(sp)
 178:	6906                	ld	s2,64(sp)
 17a:	79e2                	ld	s3,56(sp)
 17c:	7a42                	ld	s4,48(sp)
 17e:	7aa2                	ld	s5,40(sp)
 180:	7b02                	ld	s6,32(sp)
 182:	6be2                	ld	s7,24(sp)
 184:	6125                	add	sp,sp,96
 186:	8082                	ret

0000000000000188 <stat>:

int
stat(const char *n, struct stat *st)
{
 188:	1101                	add	sp,sp,-32
 18a:	ec06                	sd	ra,24(sp)
 18c:	e822                	sd	s0,16(sp)
 18e:	e426                	sd	s1,8(sp)
 190:	e04a                	sd	s2,0(sp)
 192:	1000                	add	s0,sp,32
 194:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 196:	4581                	li	a1,0
 198:	18c000ef          	jal	324 <open>
  if(fd < 0)
 19c:	02054163          	bltz	a0,1be <stat+0x36>
 1a0:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1a2:	85ca                	mv	a1,s2
 1a4:	198000ef          	jal	33c <fstat>
 1a8:	892a                	mv	s2,a0
  close(fd);
 1aa:	8526                	mv	a0,s1
 1ac:	160000ef          	jal	30c <close>
  return r;
}
 1b0:	854a                	mv	a0,s2
 1b2:	60e2                	ld	ra,24(sp)
 1b4:	6442                	ld	s0,16(sp)
 1b6:	64a2                	ld	s1,8(sp)
 1b8:	6902                	ld	s2,0(sp)
 1ba:	6105                	add	sp,sp,32
 1bc:	8082                	ret
    return -1;
 1be:	597d                	li	s2,-1
 1c0:	bfc5                	j	1b0 <stat+0x28>

00000000000001c2 <atoi>:

int
atoi(const char *s)
{
 1c2:	1141                	add	sp,sp,-16
 1c4:	e422                	sd	s0,8(sp)
 1c6:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1c8:	00054683          	lbu	a3,0(a0)
 1cc:	fd06879b          	addw	a5,a3,-48
 1d0:	0ff7f793          	zext.b	a5,a5
 1d4:	4625                	li	a2,9
 1d6:	02f66863          	bltu	a2,a5,206 <atoi+0x44>
 1da:	872a                	mv	a4,a0
  n = 0;
 1dc:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1de:	0705                	add	a4,a4,1
 1e0:	0025179b          	sllw	a5,a0,0x2
 1e4:	9fa9                	addw	a5,a5,a0
 1e6:	0017979b          	sllw	a5,a5,0x1
 1ea:	9fb5                	addw	a5,a5,a3
 1ec:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1f0:	00074683          	lbu	a3,0(a4)
 1f4:	fd06879b          	addw	a5,a3,-48
 1f8:	0ff7f793          	zext.b	a5,a5
 1fc:	fef671e3          	bgeu	a2,a5,1de <atoi+0x1c>
  return n;
}
 200:	6422                	ld	s0,8(sp)
 202:	0141                	add	sp,sp,16
 204:	8082                	ret
  n = 0;
 206:	4501                	li	a0,0
 208:	bfe5                	j	200 <atoi+0x3e>

000000000000020a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 20a:	1141                	add	sp,sp,-16
 20c:	e422                	sd	s0,8(sp)
 20e:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 210:	02b57463          	bgeu	a0,a1,238 <memmove+0x2e>
    while(n-- > 0)
 214:	00c05f63          	blez	a2,232 <memmove+0x28>
 218:	1602                	sll	a2,a2,0x20
 21a:	9201                	srl	a2,a2,0x20
 21c:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 220:	872a                	mv	a4,a0
      *dst++ = *src++;
 222:	0585                	add	a1,a1,1
 224:	0705                	add	a4,a4,1
 226:	fff5c683          	lbu	a3,-1(a1)
 22a:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 22e:	fee79ae3          	bne	a5,a4,222 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 232:	6422                	ld	s0,8(sp)
 234:	0141                	add	sp,sp,16
 236:	8082                	ret
    dst += n;
 238:	00c50733          	add	a4,a0,a2
    src += n;
 23c:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 23e:	fec05ae3          	blez	a2,232 <memmove+0x28>
 242:	fff6079b          	addw	a5,a2,-1
 246:	1782                	sll	a5,a5,0x20
 248:	9381                	srl	a5,a5,0x20
 24a:	fff7c793          	not	a5,a5
 24e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 250:	15fd                	add	a1,a1,-1
 252:	177d                	add	a4,a4,-1
 254:	0005c683          	lbu	a3,0(a1)
 258:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 25c:	fee79ae3          	bne	a5,a4,250 <memmove+0x46>
 260:	bfc9                	j	232 <memmove+0x28>

0000000000000262 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 262:	1141                	add	sp,sp,-16
 264:	e422                	sd	s0,8(sp)
 266:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 268:	ca05                	beqz	a2,298 <memcmp+0x36>
 26a:	fff6069b          	addw	a3,a2,-1
 26e:	1682                	sll	a3,a3,0x20
 270:	9281                	srl	a3,a3,0x20
 272:	0685                	add	a3,a3,1
 274:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 276:	00054783          	lbu	a5,0(a0)
 27a:	0005c703          	lbu	a4,0(a1)
 27e:	00e79863          	bne	a5,a4,28e <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 282:	0505                	add	a0,a0,1
    p2++;
 284:	0585                	add	a1,a1,1
  while (n-- > 0) {
 286:	fed518e3          	bne	a0,a3,276 <memcmp+0x14>
  }
  return 0;
 28a:	4501                	li	a0,0
 28c:	a019                	j	292 <memcmp+0x30>
      return *p1 - *p2;
 28e:	40e7853b          	subw	a0,a5,a4
}
 292:	6422                	ld	s0,8(sp)
 294:	0141                	add	sp,sp,16
 296:	8082                	ret
  return 0;
 298:	4501                	li	a0,0
 29a:	bfe5                	j	292 <memcmp+0x30>

000000000000029c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 29c:	1141                	add	sp,sp,-16
 29e:	e406                	sd	ra,8(sp)
 2a0:	e022                	sd	s0,0(sp)
 2a2:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 2a4:	f67ff0ef          	jal	20a <memmove>
}
 2a8:	60a2                	ld	ra,8(sp)
 2aa:	6402                	ld	s0,0(sp)
 2ac:	0141                	add	sp,sp,16
 2ae:	8082                	ret

00000000000002b0 <sbrk>:

char *
sbrk(int n) {
 2b0:	1141                	add	sp,sp,-16
 2b2:	e406                	sd	ra,8(sp)
 2b4:	e022                	sd	s0,0(sp)
 2b6:	0800                	add	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 2b8:	4585                	li	a1,1
 2ba:	0b2000ef          	jal	36c <sys_sbrk>
}
 2be:	60a2                	ld	ra,8(sp)
 2c0:	6402                	ld	s0,0(sp)
 2c2:	0141                	add	sp,sp,16
 2c4:	8082                	ret

00000000000002c6 <sbrklazy>:

char *
sbrklazy(int n) {
 2c6:	1141                	add	sp,sp,-16
 2c8:	e406                	sd	ra,8(sp)
 2ca:	e022                	sd	s0,0(sp)
 2cc:	0800                	add	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 2ce:	4589                	li	a1,2
 2d0:	09c000ef          	jal	36c <sys_sbrk>
}
 2d4:	60a2                	ld	ra,8(sp)
 2d6:	6402                	ld	s0,0(sp)
 2d8:	0141                	add	sp,sp,16
 2da:	8082                	ret

00000000000002dc <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2dc:	4885                	li	a7,1
 ecall
 2de:	00000073          	ecall
 ret
 2e2:	8082                	ret

00000000000002e4 <exit>:
.global exit
exit:
 li a7, SYS_exit
 2e4:	4889                	li	a7,2
 ecall
 2e6:	00000073          	ecall
 ret
 2ea:	8082                	ret

00000000000002ec <wait>:
.global wait
wait:
 li a7, SYS_wait
 2ec:	488d                	li	a7,3
 ecall
 2ee:	00000073          	ecall
 ret
 2f2:	8082                	ret

00000000000002f4 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2f4:	4891                	li	a7,4
 ecall
 2f6:	00000073          	ecall
 ret
 2fa:	8082                	ret

00000000000002fc <read>:
.global read
read:
 li a7, SYS_read
 2fc:	4895                	li	a7,5
 ecall
 2fe:	00000073          	ecall
 ret
 302:	8082                	ret

0000000000000304 <write>:
.global write
write:
 li a7, SYS_write
 304:	48c1                	li	a7,16
 ecall
 306:	00000073          	ecall
 ret
 30a:	8082                	ret

000000000000030c <close>:
.global close
close:
 li a7, SYS_close
 30c:	48d5                	li	a7,21
 ecall
 30e:	00000073          	ecall
 ret
 312:	8082                	ret

0000000000000314 <kill>:
.global kill
kill:
 li a7, SYS_kill
 314:	4899                	li	a7,6
 ecall
 316:	00000073          	ecall
 ret
 31a:	8082                	ret

000000000000031c <exec>:
.global exec
exec:
 li a7, SYS_exec
 31c:	489d                	li	a7,7
 ecall
 31e:	00000073          	ecall
 ret
 322:	8082                	ret

0000000000000324 <open>:
.global open
open:
 li a7, SYS_open
 324:	48bd                	li	a7,15
 ecall
 326:	00000073          	ecall
 ret
 32a:	8082                	ret

000000000000032c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 32c:	48c5                	li	a7,17
 ecall
 32e:	00000073          	ecall
 ret
 332:	8082                	ret

0000000000000334 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 334:	48c9                	li	a7,18
 ecall
 336:	00000073          	ecall
 ret
 33a:	8082                	ret

000000000000033c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 33c:	48a1                	li	a7,8
 ecall
 33e:	00000073          	ecall
 ret
 342:	8082                	ret

0000000000000344 <link>:
.global link
link:
 li a7, SYS_link
 344:	48cd                	li	a7,19
 ecall
 346:	00000073          	ecall
 ret
 34a:	8082                	ret

000000000000034c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 34c:	48d1                	li	a7,20
 ecall
 34e:	00000073          	ecall
 ret
 352:	8082                	ret

0000000000000354 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 354:	48a5                	li	a7,9
 ecall
 356:	00000073          	ecall
 ret
 35a:	8082                	ret

000000000000035c <dup>:
.global dup
dup:
 li a7, SYS_dup
 35c:	48a9                	li	a7,10
 ecall
 35e:	00000073          	ecall
 ret
 362:	8082                	ret

0000000000000364 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 364:	48ad                	li	a7,11
 ecall
 366:	00000073          	ecall
 ret
 36a:	8082                	ret

000000000000036c <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 36c:	48b1                	li	a7,12
 ecall
 36e:	00000073          	ecall
 ret
 372:	8082                	ret

0000000000000374 <pause>:
.global pause
pause:
 li a7, SYS_pause
 374:	48b5                	li	a7,13
 ecall
 376:	00000073          	ecall
 ret
 37a:	8082                	ret

000000000000037c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 37c:	48b9                	li	a7,14
 ecall
 37e:	00000073          	ecall
 ret
 382:	8082                	ret

0000000000000384 <getcnt>:
.global getcnt
getcnt:
 li a7, SYS_getcnt
 384:	48d9                	li	a7,22
 ecall
 386:	00000073          	ecall
 ret
 38a:	8082                	ret

000000000000038c <settickets>:
.global settickets
settickets:
 li a7, SYS_settickets
 38c:	48dd                	li	a7,23
 ecall
 38e:	00000073          	ecall
 ret
 392:	8082                	ret

0000000000000394 <getpinfo>:
.global getpinfo
getpinfo:
 li a7, SYS_getpinfo
 394:	48e1                	li	a7,24
 ecall
 396:	00000073          	ecall
 ret
 39a:	8082                	ret

000000000000039c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 39c:	1101                	add	sp,sp,-32
 39e:	ec06                	sd	ra,24(sp)
 3a0:	e822                	sd	s0,16(sp)
 3a2:	1000                	add	s0,sp,32
 3a4:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3a8:	4605                	li	a2,1
 3aa:	fef40593          	add	a1,s0,-17
 3ae:	f57ff0ef          	jal	304 <write>
}
 3b2:	60e2                	ld	ra,24(sp)
 3b4:	6442                	ld	s0,16(sp)
 3b6:	6105                	add	sp,sp,32
 3b8:	8082                	ret

00000000000003ba <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 3ba:	715d                	add	sp,sp,-80
 3bc:	e486                	sd	ra,72(sp)
 3be:	e0a2                	sd	s0,64(sp)
 3c0:	fc26                	sd	s1,56(sp)
 3c2:	f84a                	sd	s2,48(sp)
 3c4:	f44e                	sd	s3,40(sp)
 3c6:	0880                	add	s0,sp,80
 3c8:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 3ca:	c299                	beqz	a3,3d0 <printint+0x16>
 3cc:	0805c163          	bltz	a1,44e <printint+0x94>
  neg = 0;
 3d0:	4881                	li	a7,0
 3d2:	fb840693          	add	a3,s0,-72
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 3d6:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 3d8:	00000517          	auipc	a0,0x0
 3dc:	50850513          	add	a0,a0,1288 # 8e0 <digits>
 3e0:	883e                	mv	a6,a5
 3e2:	2785                	addw	a5,a5,1
 3e4:	02c5f733          	remu	a4,a1,a2
 3e8:	972a                	add	a4,a4,a0
 3ea:	00074703          	lbu	a4,0(a4)
 3ee:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 3f2:	872e                	mv	a4,a1
 3f4:	02c5d5b3          	divu	a1,a1,a2
 3f8:	0685                	add	a3,a3,1
 3fa:	fec773e3          	bgeu	a4,a2,3e0 <printint+0x26>
  if(neg)
 3fe:	00088b63          	beqz	a7,414 <printint+0x5a>
    buf[i++] = '-';
 402:	fd078793          	add	a5,a5,-48
 406:	97a2                	add	a5,a5,s0
 408:	02d00713          	li	a4,45
 40c:	fee78423          	sb	a4,-24(a5)
 410:	0028079b          	addw	a5,a6,2

  while(--i >= 0)
 414:	02f05663          	blez	a5,440 <printint+0x86>
 418:	fb840713          	add	a4,s0,-72
 41c:	00f704b3          	add	s1,a4,a5
 420:	fff70993          	add	s3,a4,-1
 424:	99be                	add	s3,s3,a5
 426:	37fd                	addw	a5,a5,-1
 428:	1782                	sll	a5,a5,0x20
 42a:	9381                	srl	a5,a5,0x20
 42c:	40f989b3          	sub	s3,s3,a5
    putc(fd, buf[i]);
 430:	fff4c583          	lbu	a1,-1(s1)
 434:	854a                	mv	a0,s2
 436:	f67ff0ef          	jal	39c <putc>
  while(--i >= 0)
 43a:	14fd                	add	s1,s1,-1
 43c:	ff349ae3          	bne	s1,s3,430 <printint+0x76>
}
 440:	60a6                	ld	ra,72(sp)
 442:	6406                	ld	s0,64(sp)
 444:	74e2                	ld	s1,56(sp)
 446:	7942                	ld	s2,48(sp)
 448:	79a2                	ld	s3,40(sp)
 44a:	6161                	add	sp,sp,80
 44c:	8082                	ret
    x = -xx;
 44e:	40b005b3          	neg	a1,a1
    neg = 1;
 452:	4885                	li	a7,1
    x = -xx;
 454:	bfbd                	j	3d2 <printint+0x18>

0000000000000456 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 456:	711d                	add	sp,sp,-96
 458:	ec86                	sd	ra,88(sp)
 45a:	e8a2                	sd	s0,80(sp)
 45c:	e4a6                	sd	s1,72(sp)
 45e:	e0ca                	sd	s2,64(sp)
 460:	fc4e                	sd	s3,56(sp)
 462:	f852                	sd	s4,48(sp)
 464:	f456                	sd	s5,40(sp)
 466:	f05a                	sd	s6,32(sp)
 468:	ec5e                	sd	s7,24(sp)
 46a:	e862                	sd	s8,16(sp)
 46c:	e466                	sd	s9,8(sp)
 46e:	e06a                	sd	s10,0(sp)
 470:	1080                	add	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 472:	0005c903          	lbu	s2,0(a1)
 476:	26090563          	beqz	s2,6e0 <vprintf+0x28a>
 47a:	8b2a                	mv	s6,a0
 47c:	8a2e                	mv	s4,a1
 47e:	8bb2                	mv	s7,a2
  state = 0;
 480:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 482:	4481                	li	s1,0
 484:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 486:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 48a:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 48e:	06c00c93          	li	s9,108
 492:	a005                	j	4b2 <vprintf+0x5c>
        putc(fd, c0);
 494:	85ca                	mv	a1,s2
 496:	855a                	mv	a0,s6
 498:	f05ff0ef          	jal	39c <putc>
 49c:	a019                	j	4a2 <vprintf+0x4c>
    } else if(state == '%'){
 49e:	03598263          	beq	s3,s5,4c2 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 4a2:	2485                	addw	s1,s1,1
 4a4:	8726                	mv	a4,s1
 4a6:	009a07b3          	add	a5,s4,s1
 4aa:	0007c903          	lbu	s2,0(a5)
 4ae:	22090963          	beqz	s2,6e0 <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
 4b2:	0009079b          	sext.w	a5,s2
    if(state == 0){
 4b6:	fe0994e3          	bnez	s3,49e <vprintf+0x48>
      if(c0 == '%'){
 4ba:	fd579de3          	bne	a5,s5,494 <vprintf+0x3e>
        state = '%';
 4be:	89be                	mv	s3,a5
 4c0:	b7cd                	j	4a2 <vprintf+0x4c>
      if(c0) c1 = fmt[i+1] & 0xff;
 4c2:	cbc9                	beqz	a5,554 <vprintf+0xfe>
 4c4:	00ea06b3          	add	a3,s4,a4
 4c8:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 4cc:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 4ce:	c681                	beqz	a3,4d6 <vprintf+0x80>
 4d0:	9752                	add	a4,a4,s4
 4d2:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 4d6:	05878363          	beq	a5,s8,51c <vprintf+0xc6>
      } else if(c0 == 'l' && c1 == 'd'){
 4da:	05978d63          	beq	a5,s9,534 <vprintf+0xde>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 4de:	07500713          	li	a4,117
 4e2:	0ee78763          	beq	a5,a4,5d0 <vprintf+0x17a>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 4e6:	07800713          	li	a4,120
 4ea:	12e78963          	beq	a5,a4,61c <vprintf+0x1c6>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 4ee:	07000713          	li	a4,112
 4f2:	14e78e63          	beq	a5,a4,64e <vprintf+0x1f8>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 4f6:	06300713          	li	a4,99
 4fa:	18e78c63          	beq	a5,a4,692 <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 4fe:	07300713          	li	a4,115
 502:	1ae78263          	beq	a5,a4,6a6 <vprintf+0x250>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 506:	02500713          	li	a4,37
 50a:	04e79563          	bne	a5,a4,554 <vprintf+0xfe>
        putc(fd, '%');
 50e:	02500593          	li	a1,37
 512:	855a                	mv	a0,s6
 514:	e89ff0ef          	jal	39c <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 518:	4981                	li	s3,0
 51a:	b761                	j	4a2 <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 10, 1);
 51c:	008b8913          	add	s2,s7,8
 520:	4685                	li	a3,1
 522:	4629                	li	a2,10
 524:	000ba583          	lw	a1,0(s7)
 528:	855a                	mv	a0,s6
 52a:	e91ff0ef          	jal	3ba <printint>
 52e:	8bca                	mv	s7,s2
      state = 0;
 530:	4981                	li	s3,0
 532:	bf85                	j	4a2 <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'd'){
 534:	06400793          	li	a5,100
 538:	02f68963          	beq	a3,a5,56a <vprintf+0x114>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 53c:	06c00793          	li	a5,108
 540:	04f68263          	beq	a3,a5,584 <vprintf+0x12e>
      } else if(c0 == 'l' && c1 == 'u'){
 544:	07500793          	li	a5,117
 548:	0af68063          	beq	a3,a5,5e8 <vprintf+0x192>
      } else if(c0 == 'l' && c1 == 'x'){
 54c:	07800793          	li	a5,120
 550:	0ef68263          	beq	a3,a5,634 <vprintf+0x1de>
        putc(fd, '%');
 554:	02500593          	li	a1,37
 558:	855a                	mv	a0,s6
 55a:	e43ff0ef          	jal	39c <putc>
        putc(fd, c0);
 55e:	85ca                	mv	a1,s2
 560:	855a                	mv	a0,s6
 562:	e3bff0ef          	jal	39c <putc>
      state = 0;
 566:	4981                	li	s3,0
 568:	bf2d                	j	4a2 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 56a:	008b8913          	add	s2,s7,8
 56e:	4685                	li	a3,1
 570:	4629                	li	a2,10
 572:	000bb583          	ld	a1,0(s7)
 576:	855a                	mv	a0,s6
 578:	e43ff0ef          	jal	3ba <printint>
        i += 1;
 57c:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 57e:	8bca                	mv	s7,s2
      state = 0;
 580:	4981                	li	s3,0
        i += 1;
 582:	b705                	j	4a2 <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 584:	06400793          	li	a5,100
 588:	02f60763          	beq	a2,a5,5b6 <vprintf+0x160>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 58c:	07500793          	li	a5,117
 590:	06f60963          	beq	a2,a5,602 <vprintf+0x1ac>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 594:	07800793          	li	a5,120
 598:	faf61ee3          	bne	a2,a5,554 <vprintf+0xfe>
        printint(fd, va_arg(ap, uint64), 16, 0);
 59c:	008b8913          	add	s2,s7,8
 5a0:	4681                	li	a3,0
 5a2:	4641                	li	a2,16
 5a4:	000bb583          	ld	a1,0(s7)
 5a8:	855a                	mv	a0,s6
 5aa:	e11ff0ef          	jal	3ba <printint>
        i += 2;
 5ae:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 5b0:	8bca                	mv	s7,s2
      state = 0;
 5b2:	4981                	li	s3,0
        i += 2;
 5b4:	b5fd                	j	4a2 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5b6:	008b8913          	add	s2,s7,8
 5ba:	4685                	li	a3,1
 5bc:	4629                	li	a2,10
 5be:	000bb583          	ld	a1,0(s7)
 5c2:	855a                	mv	a0,s6
 5c4:	df7ff0ef          	jal	3ba <printint>
        i += 2;
 5c8:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 5ca:	8bca                	mv	s7,s2
      state = 0;
 5cc:	4981                	li	s3,0
        i += 2;
 5ce:	bdd1                	j	4a2 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint32), 10, 0);
 5d0:	008b8913          	add	s2,s7,8
 5d4:	4681                	li	a3,0
 5d6:	4629                	li	a2,10
 5d8:	000be583          	lwu	a1,0(s7)
 5dc:	855a                	mv	a0,s6
 5de:	dddff0ef          	jal	3ba <printint>
 5e2:	8bca                	mv	s7,s2
      state = 0;
 5e4:	4981                	li	s3,0
 5e6:	bd75                	j	4a2 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5e8:	008b8913          	add	s2,s7,8
 5ec:	4681                	li	a3,0
 5ee:	4629                	li	a2,10
 5f0:	000bb583          	ld	a1,0(s7)
 5f4:	855a                	mv	a0,s6
 5f6:	dc5ff0ef          	jal	3ba <printint>
        i += 1;
 5fa:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 5fc:	8bca                	mv	s7,s2
      state = 0;
 5fe:	4981                	li	s3,0
        i += 1;
 600:	b54d                	j	4a2 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 602:	008b8913          	add	s2,s7,8
 606:	4681                	li	a3,0
 608:	4629                	li	a2,10
 60a:	000bb583          	ld	a1,0(s7)
 60e:	855a                	mv	a0,s6
 610:	dabff0ef          	jal	3ba <printint>
        i += 2;
 614:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 616:	8bca                	mv	s7,s2
      state = 0;
 618:	4981                	li	s3,0
        i += 2;
 61a:	b561                	j	4a2 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint32), 16, 0);
 61c:	008b8913          	add	s2,s7,8
 620:	4681                	li	a3,0
 622:	4641                	li	a2,16
 624:	000be583          	lwu	a1,0(s7)
 628:	855a                	mv	a0,s6
 62a:	d91ff0ef          	jal	3ba <printint>
 62e:	8bca                	mv	s7,s2
      state = 0;
 630:	4981                	li	s3,0
 632:	bd85                	j	4a2 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 16, 0);
 634:	008b8913          	add	s2,s7,8
 638:	4681                	li	a3,0
 63a:	4641                	li	a2,16
 63c:	000bb583          	ld	a1,0(s7)
 640:	855a                	mv	a0,s6
 642:	d79ff0ef          	jal	3ba <printint>
        i += 1;
 646:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 648:	8bca                	mv	s7,s2
      state = 0;
 64a:	4981                	li	s3,0
        i += 1;
 64c:	bd99                	j	4a2 <vprintf+0x4c>
        printptr(fd, va_arg(ap, uint64));
 64e:	008b8d13          	add	s10,s7,8
 652:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 656:	03000593          	li	a1,48
 65a:	855a                	mv	a0,s6
 65c:	d41ff0ef          	jal	39c <putc>
  putc(fd, 'x');
 660:	07800593          	li	a1,120
 664:	855a                	mv	a0,s6
 666:	d37ff0ef          	jal	39c <putc>
 66a:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 66c:	00000b97          	auipc	s7,0x0
 670:	274b8b93          	add	s7,s7,628 # 8e0 <digits>
 674:	03c9d793          	srl	a5,s3,0x3c
 678:	97de                	add	a5,a5,s7
 67a:	0007c583          	lbu	a1,0(a5)
 67e:	855a                	mv	a0,s6
 680:	d1dff0ef          	jal	39c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 684:	0992                	sll	s3,s3,0x4
 686:	397d                	addw	s2,s2,-1
 688:	fe0916e3          	bnez	s2,674 <vprintf+0x21e>
        printptr(fd, va_arg(ap, uint64));
 68c:	8bea                	mv	s7,s10
      state = 0;
 68e:	4981                	li	s3,0
 690:	bd09                	j	4a2 <vprintf+0x4c>
        putc(fd, va_arg(ap, uint32));
 692:	008b8913          	add	s2,s7,8
 696:	000bc583          	lbu	a1,0(s7)
 69a:	855a                	mv	a0,s6
 69c:	d01ff0ef          	jal	39c <putc>
 6a0:	8bca                	mv	s7,s2
      state = 0;
 6a2:	4981                	li	s3,0
 6a4:	bbfd                	j	4a2 <vprintf+0x4c>
        if((s = va_arg(ap, char*)) == 0)
 6a6:	008b8993          	add	s3,s7,8
 6aa:	000bb903          	ld	s2,0(s7)
 6ae:	00090f63          	beqz	s2,6cc <vprintf+0x276>
        for(; *s; s++)
 6b2:	00094583          	lbu	a1,0(s2)
 6b6:	c195                	beqz	a1,6da <vprintf+0x284>
          putc(fd, *s);
 6b8:	855a                	mv	a0,s6
 6ba:	ce3ff0ef          	jal	39c <putc>
        for(; *s; s++)
 6be:	0905                	add	s2,s2,1
 6c0:	00094583          	lbu	a1,0(s2)
 6c4:	f9f5                	bnez	a1,6b8 <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 6c6:	8bce                	mv	s7,s3
      state = 0;
 6c8:	4981                	li	s3,0
 6ca:	bbe1                	j	4a2 <vprintf+0x4c>
          s = "(null)";
 6cc:	00000917          	auipc	s2,0x0
 6d0:	20c90913          	add	s2,s2,524 # 8d8 <malloc+0xfe>
        for(; *s; s++)
 6d4:	02800593          	li	a1,40
 6d8:	b7c5                	j	6b8 <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 6da:	8bce                	mv	s7,s3
      state = 0;
 6dc:	4981                	li	s3,0
 6de:	b3d1                	j	4a2 <vprintf+0x4c>
    }
  }
}
 6e0:	60e6                	ld	ra,88(sp)
 6e2:	6446                	ld	s0,80(sp)
 6e4:	64a6                	ld	s1,72(sp)
 6e6:	6906                	ld	s2,64(sp)
 6e8:	79e2                	ld	s3,56(sp)
 6ea:	7a42                	ld	s4,48(sp)
 6ec:	7aa2                	ld	s5,40(sp)
 6ee:	7b02                	ld	s6,32(sp)
 6f0:	6be2                	ld	s7,24(sp)
 6f2:	6c42                	ld	s8,16(sp)
 6f4:	6ca2                	ld	s9,8(sp)
 6f6:	6d02                	ld	s10,0(sp)
 6f8:	6125                	add	sp,sp,96
 6fa:	8082                	ret

00000000000006fc <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6fc:	715d                	add	sp,sp,-80
 6fe:	ec06                	sd	ra,24(sp)
 700:	e822                	sd	s0,16(sp)
 702:	1000                	add	s0,sp,32
 704:	e010                	sd	a2,0(s0)
 706:	e414                	sd	a3,8(s0)
 708:	e818                	sd	a4,16(s0)
 70a:	ec1c                	sd	a5,24(s0)
 70c:	03043023          	sd	a6,32(s0)
 710:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 714:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 718:	8622                	mv	a2,s0
 71a:	d3dff0ef          	jal	456 <vprintf>
}
 71e:	60e2                	ld	ra,24(sp)
 720:	6442                	ld	s0,16(sp)
 722:	6161                	add	sp,sp,80
 724:	8082                	ret

0000000000000726 <printf>:

void
printf(const char *fmt, ...)
{
 726:	711d                	add	sp,sp,-96
 728:	ec06                	sd	ra,24(sp)
 72a:	e822                	sd	s0,16(sp)
 72c:	1000                	add	s0,sp,32
 72e:	e40c                	sd	a1,8(s0)
 730:	e810                	sd	a2,16(s0)
 732:	ec14                	sd	a3,24(s0)
 734:	f018                	sd	a4,32(s0)
 736:	f41c                	sd	a5,40(s0)
 738:	03043823          	sd	a6,48(s0)
 73c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 740:	00840613          	add	a2,s0,8
 744:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 748:	85aa                	mv	a1,a0
 74a:	4505                	li	a0,1
 74c:	d0bff0ef          	jal	456 <vprintf>
}
 750:	60e2                	ld	ra,24(sp)
 752:	6442                	ld	s0,16(sp)
 754:	6125                	add	sp,sp,96
 756:	8082                	ret

0000000000000758 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 758:	1141                	add	sp,sp,-16
 75a:	e422                	sd	s0,8(sp)
 75c:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 75e:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 762:	00001797          	auipc	a5,0x1
 766:	89e7b783          	ld	a5,-1890(a5) # 1000 <freep>
 76a:	a02d                	j	794 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 76c:	4618                	lw	a4,8(a2)
 76e:	9f2d                	addw	a4,a4,a1
 770:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 774:	6398                	ld	a4,0(a5)
 776:	6310                	ld	a2,0(a4)
 778:	a83d                	j	7b6 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 77a:	ff852703          	lw	a4,-8(a0)
 77e:	9f31                	addw	a4,a4,a2
 780:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 782:	ff053683          	ld	a3,-16(a0)
 786:	a091                	j	7ca <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 788:	6398                	ld	a4,0(a5)
 78a:	00e7e463          	bltu	a5,a4,792 <free+0x3a>
 78e:	00e6ea63          	bltu	a3,a4,7a2 <free+0x4a>
{
 792:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 794:	fed7fae3          	bgeu	a5,a3,788 <free+0x30>
 798:	6398                	ld	a4,0(a5)
 79a:	00e6e463          	bltu	a3,a4,7a2 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 79e:	fee7eae3          	bltu	a5,a4,792 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 7a2:	ff852583          	lw	a1,-8(a0)
 7a6:	6390                	ld	a2,0(a5)
 7a8:	02059813          	sll	a6,a1,0x20
 7ac:	01c85713          	srl	a4,a6,0x1c
 7b0:	9736                	add	a4,a4,a3
 7b2:	fae60de3          	beq	a2,a4,76c <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 7b6:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7ba:	4790                	lw	a2,8(a5)
 7bc:	02061593          	sll	a1,a2,0x20
 7c0:	01c5d713          	srl	a4,a1,0x1c
 7c4:	973e                	add	a4,a4,a5
 7c6:	fae68ae3          	beq	a3,a4,77a <free+0x22>
    p->s.ptr = bp->s.ptr;
 7ca:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7cc:	00001717          	auipc	a4,0x1
 7d0:	82f73a23          	sd	a5,-1996(a4) # 1000 <freep>
}
 7d4:	6422                	ld	s0,8(sp)
 7d6:	0141                	add	sp,sp,16
 7d8:	8082                	ret

00000000000007da <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7da:	7139                	add	sp,sp,-64
 7dc:	fc06                	sd	ra,56(sp)
 7de:	f822                	sd	s0,48(sp)
 7e0:	f426                	sd	s1,40(sp)
 7e2:	f04a                	sd	s2,32(sp)
 7e4:	ec4e                	sd	s3,24(sp)
 7e6:	e852                	sd	s4,16(sp)
 7e8:	e456                	sd	s5,8(sp)
 7ea:	e05a                	sd	s6,0(sp)
 7ec:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7ee:	02051493          	sll	s1,a0,0x20
 7f2:	9081                	srl	s1,s1,0x20
 7f4:	04bd                	add	s1,s1,15
 7f6:	8091                	srl	s1,s1,0x4
 7f8:	0014899b          	addw	s3,s1,1
 7fc:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 7fe:	00001517          	auipc	a0,0x1
 802:	80253503          	ld	a0,-2046(a0) # 1000 <freep>
 806:	c515                	beqz	a0,832 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 808:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 80a:	4798                	lw	a4,8(a5)
 80c:	02977f63          	bgeu	a4,s1,84a <malloc+0x70>
  if(nu < 4096)
 810:	8a4e                	mv	s4,s3
 812:	0009871b          	sext.w	a4,s3
 816:	6685                	lui	a3,0x1
 818:	00d77363          	bgeu	a4,a3,81e <malloc+0x44>
 81c:	6a05                	lui	s4,0x1
 81e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 822:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 826:	00000917          	auipc	s2,0x0
 82a:	7da90913          	add	s2,s2,2010 # 1000 <freep>
  if(p == SBRK_ERROR)
 82e:	5afd                	li	s5,-1
 830:	a885                	j	8a0 <malloc+0xc6>
    base.s.ptr = freep = prevp = &base;
 832:	00000797          	auipc	a5,0x0
 836:	7de78793          	add	a5,a5,2014 # 1010 <base>
 83a:	00000717          	auipc	a4,0x0
 83e:	7cf73323          	sd	a5,1990(a4) # 1000 <freep>
 842:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 844:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 848:	b7e1                	j	810 <malloc+0x36>
      if(p->s.size == nunits)
 84a:	02e48c63          	beq	s1,a4,882 <malloc+0xa8>
        p->s.size -= nunits;
 84e:	4137073b          	subw	a4,a4,s3
 852:	c798                	sw	a4,8(a5)
        p += p->s.size;
 854:	02071693          	sll	a3,a4,0x20
 858:	01c6d713          	srl	a4,a3,0x1c
 85c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 85e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 862:	00000717          	auipc	a4,0x0
 866:	78a73f23          	sd	a0,1950(a4) # 1000 <freep>
      return (void*)(p + 1);
 86a:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 86e:	70e2                	ld	ra,56(sp)
 870:	7442                	ld	s0,48(sp)
 872:	74a2                	ld	s1,40(sp)
 874:	7902                	ld	s2,32(sp)
 876:	69e2                	ld	s3,24(sp)
 878:	6a42                	ld	s4,16(sp)
 87a:	6aa2                	ld	s5,8(sp)
 87c:	6b02                	ld	s6,0(sp)
 87e:	6121                	add	sp,sp,64
 880:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 882:	6398                	ld	a4,0(a5)
 884:	e118                	sd	a4,0(a0)
 886:	bff1                	j	862 <malloc+0x88>
  hp->s.size = nu;
 888:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 88c:	0541                	add	a0,a0,16
 88e:	ecbff0ef          	jal	758 <free>
  return freep;
 892:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 896:	dd61                	beqz	a0,86e <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 898:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 89a:	4798                	lw	a4,8(a5)
 89c:	fa9777e3          	bgeu	a4,s1,84a <malloc+0x70>
    if(p == freep)
 8a0:	00093703          	ld	a4,0(s2)
 8a4:	853e                	mv	a0,a5
 8a6:	fef719e3          	bne	a4,a5,898 <malloc+0xbe>
  p = sbrk(nu * sizeof(Header));
 8aa:	8552                	mv	a0,s4
 8ac:	a05ff0ef          	jal	2b0 <sbrk>
  if(p == SBRK_ERROR)
 8b0:	fd551ce3          	bne	a0,s5,888 <malloc+0xae>
        return 0;
 8b4:	4501                	li	a0,0
 8b6:	bf65                	j	86e <malloc+0x94>
