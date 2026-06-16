
user/_rm:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
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
   e:	02a7d563          	bge	a5,a0,38 <main+0x38>
  12:	00858493          	add	s1,a1,8
  16:	ffe5091b          	addw	s2,a0,-2
  1a:	02091793          	sll	a5,s2,0x20
  1e:	01d7d913          	srl	s2,a5,0x1d
  22:	05c1                	add	a1,a1,16
  24:	992e                	add	s2,s2,a1
    fprintf(2, "Usage: rm files...\n");
    exit(1);
  }

  for(i = 1; i < argc; i++){
    if(unlink(argv[i]) < 0){
  26:	6088                	ld	a0,0(s1)
  28:	31e000ef          	jal	346 <unlink>
  2c:	02054063          	bltz	a0,4c <main+0x4c>
  for(i = 1; i < argc; i++){
  30:	04a1                	add	s1,s1,8
  32:	ff249ae3          	bne	s1,s2,26 <main+0x26>
  36:	a01d                	j	5c <main+0x5c>
    fprintf(2, "Usage: rm files...\n");
  38:	00001597          	auipc	a1,0x1
  3c:	89858593          	add	a1,a1,-1896 # 8d0 <malloc+0xe4>
  40:	4509                	li	a0,2
  42:	6cc000ef          	jal	70e <fprintf>
    exit(1);
  46:	4505                	li	a0,1
  48:	2ae000ef          	jal	2f6 <exit>
      fprintf(2, "rm: %s failed to delete\n", argv[i]);
  4c:	6090                	ld	a2,0(s1)
  4e:	00001597          	auipc	a1,0x1
  52:	89a58593          	add	a1,a1,-1894 # 8e8 <malloc+0xfc>
  56:	4509                	li	a0,2
  58:	6b6000ef          	jal	70e <fprintf>
      break;
    }
  }

  exit(0);
  5c:	4501                	li	a0,0
  5e:	298000ef          	jal	2f6 <exit>

0000000000000062 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  62:	1141                	add	sp,sp,-16
  64:	e406                	sd	ra,8(sp)
  66:	e022                	sd	s0,0(sp)
  68:	0800                	add	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  6a:	f97ff0ef          	jal	0 <main>
  exit(r);
  6e:	288000ef          	jal	2f6 <exit>

0000000000000072 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  72:	1141                	add	sp,sp,-16
  74:	e422                	sd	s0,8(sp)
  76:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  78:	87aa                	mv	a5,a0
  7a:	0585                	add	a1,a1,1
  7c:	0785                	add	a5,a5,1
  7e:	fff5c703          	lbu	a4,-1(a1)
  82:	fee78fa3          	sb	a4,-1(a5)
  86:	fb75                	bnez	a4,7a <strcpy+0x8>
    ;
  return os;
}
  88:	6422                	ld	s0,8(sp)
  8a:	0141                	add	sp,sp,16
  8c:	8082                	ret

000000000000008e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8e:	1141                	add	sp,sp,-16
  90:	e422                	sd	s0,8(sp)
  92:	0800                	add	s0,sp,16
  while(*p && *p == *q)
  94:	00054783          	lbu	a5,0(a0)
  98:	cb91                	beqz	a5,ac <strcmp+0x1e>
  9a:	0005c703          	lbu	a4,0(a1)
  9e:	00f71763          	bne	a4,a5,ac <strcmp+0x1e>
    p++, q++;
  a2:	0505                	add	a0,a0,1
  a4:	0585                	add	a1,a1,1
  while(*p && *p == *q)
  a6:	00054783          	lbu	a5,0(a0)
  aa:	fbe5                	bnez	a5,9a <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  ac:	0005c503          	lbu	a0,0(a1)
}
  b0:	40a7853b          	subw	a0,a5,a0
  b4:	6422                	ld	s0,8(sp)
  b6:	0141                	add	sp,sp,16
  b8:	8082                	ret

00000000000000ba <strlen>:

uint
strlen(const char *s)
{
  ba:	1141                	add	sp,sp,-16
  bc:	e422                	sd	s0,8(sp)
  be:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  c0:	00054783          	lbu	a5,0(a0)
  c4:	cf91                	beqz	a5,e0 <strlen+0x26>
  c6:	0505                	add	a0,a0,1
  c8:	87aa                	mv	a5,a0
  ca:	86be                	mv	a3,a5
  cc:	0785                	add	a5,a5,1
  ce:	fff7c703          	lbu	a4,-1(a5)
  d2:	ff65                	bnez	a4,ca <strlen+0x10>
  d4:	40a6853b          	subw	a0,a3,a0
  d8:	2505                	addw	a0,a0,1
    ;
  return n;
}
  da:	6422                	ld	s0,8(sp)
  dc:	0141                	add	sp,sp,16
  de:	8082                	ret
  for(n = 0; s[n]; n++)
  e0:	4501                	li	a0,0
  e2:	bfe5                	j	da <strlen+0x20>

00000000000000e4 <memset>:

void*
memset(void *dst, int c, uint n)
{
  e4:	1141                	add	sp,sp,-16
  e6:	e422                	sd	s0,8(sp)
  e8:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  ea:	ca19                	beqz	a2,100 <memset+0x1c>
  ec:	87aa                	mv	a5,a0
  ee:	1602                	sll	a2,a2,0x20
  f0:	9201                	srl	a2,a2,0x20
  f2:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  f6:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  fa:	0785                	add	a5,a5,1
  fc:	fee79de3          	bne	a5,a4,f6 <memset+0x12>
  }
  return dst;
}
 100:	6422                	ld	s0,8(sp)
 102:	0141                	add	sp,sp,16
 104:	8082                	ret

0000000000000106 <strchr>:

char*
strchr(const char *s, char c)
{
 106:	1141                	add	sp,sp,-16
 108:	e422                	sd	s0,8(sp)
 10a:	0800                	add	s0,sp,16
  for(; *s; s++)
 10c:	00054783          	lbu	a5,0(a0)
 110:	cb99                	beqz	a5,126 <strchr+0x20>
    if(*s == c)
 112:	00f58763          	beq	a1,a5,120 <strchr+0x1a>
  for(; *s; s++)
 116:	0505                	add	a0,a0,1
 118:	00054783          	lbu	a5,0(a0)
 11c:	fbfd                	bnez	a5,112 <strchr+0xc>
      return (char*)s;
  return 0;
 11e:	4501                	li	a0,0
}
 120:	6422                	ld	s0,8(sp)
 122:	0141                	add	sp,sp,16
 124:	8082                	ret
  return 0;
 126:	4501                	li	a0,0
 128:	bfe5                	j	120 <strchr+0x1a>

000000000000012a <gets>:

char*
gets(char *buf, int max)
{
 12a:	711d                	add	sp,sp,-96
 12c:	ec86                	sd	ra,88(sp)
 12e:	e8a2                	sd	s0,80(sp)
 130:	e4a6                	sd	s1,72(sp)
 132:	e0ca                	sd	s2,64(sp)
 134:	fc4e                	sd	s3,56(sp)
 136:	f852                	sd	s4,48(sp)
 138:	f456                	sd	s5,40(sp)
 13a:	f05a                	sd	s6,32(sp)
 13c:	ec5e                	sd	s7,24(sp)
 13e:	1080                	add	s0,sp,96
 140:	8baa                	mv	s7,a0
 142:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 144:	892a                	mv	s2,a0
 146:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 148:	4aa9                	li	s5,10
 14a:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 14c:	89a6                	mv	s3,s1
 14e:	2485                	addw	s1,s1,1
 150:	0344d663          	bge	s1,s4,17c <gets+0x52>
    cc = read(0, &c, 1);
 154:	4605                	li	a2,1
 156:	faf40593          	add	a1,s0,-81
 15a:	4501                	li	a0,0
 15c:	1b2000ef          	jal	30e <read>
    if(cc < 1)
 160:	00a05e63          	blez	a0,17c <gets+0x52>
    buf[i++] = c;
 164:	faf44783          	lbu	a5,-81(s0)
 168:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 16c:	01578763          	beq	a5,s5,17a <gets+0x50>
 170:	0905                	add	s2,s2,1
 172:	fd679de3          	bne	a5,s6,14c <gets+0x22>
  for(i=0; i+1 < max; ){
 176:	89a6                	mv	s3,s1
 178:	a011                	j	17c <gets+0x52>
 17a:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 17c:	99de                	add	s3,s3,s7
 17e:	00098023          	sb	zero,0(s3)
  return buf;
}
 182:	855e                	mv	a0,s7
 184:	60e6                	ld	ra,88(sp)
 186:	6446                	ld	s0,80(sp)
 188:	64a6                	ld	s1,72(sp)
 18a:	6906                	ld	s2,64(sp)
 18c:	79e2                	ld	s3,56(sp)
 18e:	7a42                	ld	s4,48(sp)
 190:	7aa2                	ld	s5,40(sp)
 192:	7b02                	ld	s6,32(sp)
 194:	6be2                	ld	s7,24(sp)
 196:	6125                	add	sp,sp,96
 198:	8082                	ret

000000000000019a <stat>:

int
stat(const char *n, struct stat *st)
{
 19a:	1101                	add	sp,sp,-32
 19c:	ec06                	sd	ra,24(sp)
 19e:	e822                	sd	s0,16(sp)
 1a0:	e426                	sd	s1,8(sp)
 1a2:	e04a                	sd	s2,0(sp)
 1a4:	1000                	add	s0,sp,32
 1a6:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1a8:	4581                	li	a1,0
 1aa:	18c000ef          	jal	336 <open>
  if(fd < 0)
 1ae:	02054163          	bltz	a0,1d0 <stat+0x36>
 1b2:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1b4:	85ca                	mv	a1,s2
 1b6:	198000ef          	jal	34e <fstat>
 1ba:	892a                	mv	s2,a0
  close(fd);
 1bc:	8526                	mv	a0,s1
 1be:	160000ef          	jal	31e <close>
  return r;
}
 1c2:	854a                	mv	a0,s2
 1c4:	60e2                	ld	ra,24(sp)
 1c6:	6442                	ld	s0,16(sp)
 1c8:	64a2                	ld	s1,8(sp)
 1ca:	6902                	ld	s2,0(sp)
 1cc:	6105                	add	sp,sp,32
 1ce:	8082                	ret
    return -1;
 1d0:	597d                	li	s2,-1
 1d2:	bfc5                	j	1c2 <stat+0x28>

00000000000001d4 <atoi>:

int
atoi(const char *s)
{
 1d4:	1141                	add	sp,sp,-16
 1d6:	e422                	sd	s0,8(sp)
 1d8:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1da:	00054683          	lbu	a3,0(a0)
 1de:	fd06879b          	addw	a5,a3,-48
 1e2:	0ff7f793          	zext.b	a5,a5
 1e6:	4625                	li	a2,9
 1e8:	02f66863          	bltu	a2,a5,218 <atoi+0x44>
 1ec:	872a                	mv	a4,a0
  n = 0;
 1ee:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1f0:	0705                	add	a4,a4,1
 1f2:	0025179b          	sllw	a5,a0,0x2
 1f6:	9fa9                	addw	a5,a5,a0
 1f8:	0017979b          	sllw	a5,a5,0x1
 1fc:	9fb5                	addw	a5,a5,a3
 1fe:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 202:	00074683          	lbu	a3,0(a4)
 206:	fd06879b          	addw	a5,a3,-48
 20a:	0ff7f793          	zext.b	a5,a5
 20e:	fef671e3          	bgeu	a2,a5,1f0 <atoi+0x1c>
  return n;
}
 212:	6422                	ld	s0,8(sp)
 214:	0141                	add	sp,sp,16
 216:	8082                	ret
  n = 0;
 218:	4501                	li	a0,0
 21a:	bfe5                	j	212 <atoi+0x3e>

000000000000021c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 21c:	1141                	add	sp,sp,-16
 21e:	e422                	sd	s0,8(sp)
 220:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 222:	02b57463          	bgeu	a0,a1,24a <memmove+0x2e>
    while(n-- > 0)
 226:	00c05f63          	blez	a2,244 <memmove+0x28>
 22a:	1602                	sll	a2,a2,0x20
 22c:	9201                	srl	a2,a2,0x20
 22e:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 232:	872a                	mv	a4,a0
      *dst++ = *src++;
 234:	0585                	add	a1,a1,1
 236:	0705                	add	a4,a4,1
 238:	fff5c683          	lbu	a3,-1(a1)
 23c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 240:	fee79ae3          	bne	a5,a4,234 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 244:	6422                	ld	s0,8(sp)
 246:	0141                	add	sp,sp,16
 248:	8082                	ret
    dst += n;
 24a:	00c50733          	add	a4,a0,a2
    src += n;
 24e:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 250:	fec05ae3          	blez	a2,244 <memmove+0x28>
 254:	fff6079b          	addw	a5,a2,-1
 258:	1782                	sll	a5,a5,0x20
 25a:	9381                	srl	a5,a5,0x20
 25c:	fff7c793          	not	a5,a5
 260:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 262:	15fd                	add	a1,a1,-1
 264:	177d                	add	a4,a4,-1
 266:	0005c683          	lbu	a3,0(a1)
 26a:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 26e:	fee79ae3          	bne	a5,a4,262 <memmove+0x46>
 272:	bfc9                	j	244 <memmove+0x28>

0000000000000274 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 274:	1141                	add	sp,sp,-16
 276:	e422                	sd	s0,8(sp)
 278:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 27a:	ca05                	beqz	a2,2aa <memcmp+0x36>
 27c:	fff6069b          	addw	a3,a2,-1
 280:	1682                	sll	a3,a3,0x20
 282:	9281                	srl	a3,a3,0x20
 284:	0685                	add	a3,a3,1
 286:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 288:	00054783          	lbu	a5,0(a0)
 28c:	0005c703          	lbu	a4,0(a1)
 290:	00e79863          	bne	a5,a4,2a0 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 294:	0505                	add	a0,a0,1
    p2++;
 296:	0585                	add	a1,a1,1
  while (n-- > 0) {
 298:	fed518e3          	bne	a0,a3,288 <memcmp+0x14>
  }
  return 0;
 29c:	4501                	li	a0,0
 29e:	a019                	j	2a4 <memcmp+0x30>
      return *p1 - *p2;
 2a0:	40e7853b          	subw	a0,a5,a4
}
 2a4:	6422                	ld	s0,8(sp)
 2a6:	0141                	add	sp,sp,16
 2a8:	8082                	ret
  return 0;
 2aa:	4501                	li	a0,0
 2ac:	bfe5                	j	2a4 <memcmp+0x30>

00000000000002ae <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2ae:	1141                	add	sp,sp,-16
 2b0:	e406                	sd	ra,8(sp)
 2b2:	e022                	sd	s0,0(sp)
 2b4:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 2b6:	f67ff0ef          	jal	21c <memmove>
}
 2ba:	60a2                	ld	ra,8(sp)
 2bc:	6402                	ld	s0,0(sp)
 2be:	0141                	add	sp,sp,16
 2c0:	8082                	ret

00000000000002c2 <sbrk>:

char *
sbrk(int n) {
 2c2:	1141                	add	sp,sp,-16
 2c4:	e406                	sd	ra,8(sp)
 2c6:	e022                	sd	s0,0(sp)
 2c8:	0800                	add	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 2ca:	4585                	li	a1,1
 2cc:	0b2000ef          	jal	37e <sys_sbrk>
}
 2d0:	60a2                	ld	ra,8(sp)
 2d2:	6402                	ld	s0,0(sp)
 2d4:	0141                	add	sp,sp,16
 2d6:	8082                	ret

00000000000002d8 <sbrklazy>:

char *
sbrklazy(int n) {
 2d8:	1141                	add	sp,sp,-16
 2da:	e406                	sd	ra,8(sp)
 2dc:	e022                	sd	s0,0(sp)
 2de:	0800                	add	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 2e0:	4589                	li	a1,2
 2e2:	09c000ef          	jal	37e <sys_sbrk>
}
 2e6:	60a2                	ld	ra,8(sp)
 2e8:	6402                	ld	s0,0(sp)
 2ea:	0141                	add	sp,sp,16
 2ec:	8082                	ret

00000000000002ee <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2ee:	4885                	li	a7,1
 ecall
 2f0:	00000073          	ecall
 ret
 2f4:	8082                	ret

00000000000002f6 <exit>:
.global exit
exit:
 li a7, SYS_exit
 2f6:	4889                	li	a7,2
 ecall
 2f8:	00000073          	ecall
 ret
 2fc:	8082                	ret

00000000000002fe <wait>:
.global wait
wait:
 li a7, SYS_wait
 2fe:	488d                	li	a7,3
 ecall
 300:	00000073          	ecall
 ret
 304:	8082                	ret

0000000000000306 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 306:	4891                	li	a7,4
 ecall
 308:	00000073          	ecall
 ret
 30c:	8082                	ret

000000000000030e <read>:
.global read
read:
 li a7, SYS_read
 30e:	4895                	li	a7,5
 ecall
 310:	00000073          	ecall
 ret
 314:	8082                	ret

0000000000000316 <write>:
.global write
write:
 li a7, SYS_write
 316:	48c1                	li	a7,16
 ecall
 318:	00000073          	ecall
 ret
 31c:	8082                	ret

000000000000031e <close>:
.global close
close:
 li a7, SYS_close
 31e:	48d5                	li	a7,21
 ecall
 320:	00000073          	ecall
 ret
 324:	8082                	ret

0000000000000326 <kill>:
.global kill
kill:
 li a7, SYS_kill
 326:	4899                	li	a7,6
 ecall
 328:	00000073          	ecall
 ret
 32c:	8082                	ret

000000000000032e <exec>:
.global exec
exec:
 li a7, SYS_exec
 32e:	489d                	li	a7,7
 ecall
 330:	00000073          	ecall
 ret
 334:	8082                	ret

0000000000000336 <open>:
.global open
open:
 li a7, SYS_open
 336:	48bd                	li	a7,15
 ecall
 338:	00000073          	ecall
 ret
 33c:	8082                	ret

000000000000033e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 33e:	48c5                	li	a7,17
 ecall
 340:	00000073          	ecall
 ret
 344:	8082                	ret

0000000000000346 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 346:	48c9                	li	a7,18
 ecall
 348:	00000073          	ecall
 ret
 34c:	8082                	ret

000000000000034e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 34e:	48a1                	li	a7,8
 ecall
 350:	00000073          	ecall
 ret
 354:	8082                	ret

0000000000000356 <link>:
.global link
link:
 li a7, SYS_link
 356:	48cd                	li	a7,19
 ecall
 358:	00000073          	ecall
 ret
 35c:	8082                	ret

000000000000035e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 35e:	48d1                	li	a7,20
 ecall
 360:	00000073          	ecall
 ret
 364:	8082                	ret

0000000000000366 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 366:	48a5                	li	a7,9
 ecall
 368:	00000073          	ecall
 ret
 36c:	8082                	ret

000000000000036e <dup>:
.global dup
dup:
 li a7, SYS_dup
 36e:	48a9                	li	a7,10
 ecall
 370:	00000073          	ecall
 ret
 374:	8082                	ret

0000000000000376 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 376:	48ad                	li	a7,11
 ecall
 378:	00000073          	ecall
 ret
 37c:	8082                	ret

000000000000037e <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 37e:	48b1                	li	a7,12
 ecall
 380:	00000073          	ecall
 ret
 384:	8082                	ret

0000000000000386 <pause>:
.global pause
pause:
 li a7, SYS_pause
 386:	48b5                	li	a7,13
 ecall
 388:	00000073          	ecall
 ret
 38c:	8082                	ret

000000000000038e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 38e:	48b9                	li	a7,14
 ecall
 390:	00000073          	ecall
 ret
 394:	8082                	ret

0000000000000396 <getcnt>:
.global getcnt
getcnt:
 li a7, SYS_getcnt
 396:	48d9                	li	a7,22
 ecall
 398:	00000073          	ecall
 ret
 39c:	8082                	ret

000000000000039e <settickets>:
.global settickets
settickets:
 li a7, SYS_settickets
 39e:	48dd                	li	a7,23
 ecall
 3a0:	00000073          	ecall
 ret
 3a4:	8082                	ret

00000000000003a6 <getpinfo>:
.global getpinfo
getpinfo:
 li a7, SYS_getpinfo
 3a6:	48e1                	li	a7,24
 ecall
 3a8:	00000073          	ecall
 ret
 3ac:	8082                	ret

00000000000003ae <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3ae:	1101                	add	sp,sp,-32
 3b0:	ec06                	sd	ra,24(sp)
 3b2:	e822                	sd	s0,16(sp)
 3b4:	1000                	add	s0,sp,32
 3b6:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3ba:	4605                	li	a2,1
 3bc:	fef40593          	add	a1,s0,-17
 3c0:	f57ff0ef          	jal	316 <write>
}
 3c4:	60e2                	ld	ra,24(sp)
 3c6:	6442                	ld	s0,16(sp)
 3c8:	6105                	add	sp,sp,32
 3ca:	8082                	ret

00000000000003cc <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 3cc:	715d                	add	sp,sp,-80
 3ce:	e486                	sd	ra,72(sp)
 3d0:	e0a2                	sd	s0,64(sp)
 3d2:	fc26                	sd	s1,56(sp)
 3d4:	f84a                	sd	s2,48(sp)
 3d6:	f44e                	sd	s3,40(sp)
 3d8:	0880                	add	s0,sp,80
 3da:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 3dc:	c299                	beqz	a3,3e2 <printint+0x16>
 3de:	0805c163          	bltz	a1,460 <printint+0x94>
  neg = 0;
 3e2:	4881                	li	a7,0
 3e4:	fb840693          	add	a3,s0,-72
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 3e8:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 3ea:	00000517          	auipc	a0,0x0
 3ee:	52650513          	add	a0,a0,1318 # 910 <digits>
 3f2:	883e                	mv	a6,a5
 3f4:	2785                	addw	a5,a5,1
 3f6:	02c5f733          	remu	a4,a1,a2
 3fa:	972a                	add	a4,a4,a0
 3fc:	00074703          	lbu	a4,0(a4)
 400:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 404:	872e                	mv	a4,a1
 406:	02c5d5b3          	divu	a1,a1,a2
 40a:	0685                	add	a3,a3,1
 40c:	fec773e3          	bgeu	a4,a2,3f2 <printint+0x26>
  if(neg)
 410:	00088b63          	beqz	a7,426 <printint+0x5a>
    buf[i++] = '-';
 414:	fd078793          	add	a5,a5,-48
 418:	97a2                	add	a5,a5,s0
 41a:	02d00713          	li	a4,45
 41e:	fee78423          	sb	a4,-24(a5)
 422:	0028079b          	addw	a5,a6,2

  while(--i >= 0)
 426:	02f05663          	blez	a5,452 <printint+0x86>
 42a:	fb840713          	add	a4,s0,-72
 42e:	00f704b3          	add	s1,a4,a5
 432:	fff70993          	add	s3,a4,-1
 436:	99be                	add	s3,s3,a5
 438:	37fd                	addw	a5,a5,-1
 43a:	1782                	sll	a5,a5,0x20
 43c:	9381                	srl	a5,a5,0x20
 43e:	40f989b3          	sub	s3,s3,a5
    putc(fd, buf[i]);
 442:	fff4c583          	lbu	a1,-1(s1)
 446:	854a                	mv	a0,s2
 448:	f67ff0ef          	jal	3ae <putc>
  while(--i >= 0)
 44c:	14fd                	add	s1,s1,-1
 44e:	ff349ae3          	bne	s1,s3,442 <printint+0x76>
}
 452:	60a6                	ld	ra,72(sp)
 454:	6406                	ld	s0,64(sp)
 456:	74e2                	ld	s1,56(sp)
 458:	7942                	ld	s2,48(sp)
 45a:	79a2                	ld	s3,40(sp)
 45c:	6161                	add	sp,sp,80
 45e:	8082                	ret
    x = -xx;
 460:	40b005b3          	neg	a1,a1
    neg = 1;
 464:	4885                	li	a7,1
    x = -xx;
 466:	bfbd                	j	3e4 <printint+0x18>

0000000000000468 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 468:	711d                	add	sp,sp,-96
 46a:	ec86                	sd	ra,88(sp)
 46c:	e8a2                	sd	s0,80(sp)
 46e:	e4a6                	sd	s1,72(sp)
 470:	e0ca                	sd	s2,64(sp)
 472:	fc4e                	sd	s3,56(sp)
 474:	f852                	sd	s4,48(sp)
 476:	f456                	sd	s5,40(sp)
 478:	f05a                	sd	s6,32(sp)
 47a:	ec5e                	sd	s7,24(sp)
 47c:	e862                	sd	s8,16(sp)
 47e:	e466                	sd	s9,8(sp)
 480:	e06a                	sd	s10,0(sp)
 482:	1080                	add	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 484:	0005c903          	lbu	s2,0(a1)
 488:	26090563          	beqz	s2,6f2 <vprintf+0x28a>
 48c:	8b2a                	mv	s6,a0
 48e:	8a2e                	mv	s4,a1
 490:	8bb2                	mv	s7,a2
  state = 0;
 492:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 494:	4481                	li	s1,0
 496:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 498:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 49c:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 4a0:	06c00c93          	li	s9,108
 4a4:	a005                	j	4c4 <vprintf+0x5c>
        putc(fd, c0);
 4a6:	85ca                	mv	a1,s2
 4a8:	855a                	mv	a0,s6
 4aa:	f05ff0ef          	jal	3ae <putc>
 4ae:	a019                	j	4b4 <vprintf+0x4c>
    } else if(state == '%'){
 4b0:	03598263          	beq	s3,s5,4d4 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 4b4:	2485                	addw	s1,s1,1
 4b6:	8726                	mv	a4,s1
 4b8:	009a07b3          	add	a5,s4,s1
 4bc:	0007c903          	lbu	s2,0(a5)
 4c0:	22090963          	beqz	s2,6f2 <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
 4c4:	0009079b          	sext.w	a5,s2
    if(state == 0){
 4c8:	fe0994e3          	bnez	s3,4b0 <vprintf+0x48>
      if(c0 == '%'){
 4cc:	fd579de3          	bne	a5,s5,4a6 <vprintf+0x3e>
        state = '%';
 4d0:	89be                	mv	s3,a5
 4d2:	b7cd                	j	4b4 <vprintf+0x4c>
      if(c0) c1 = fmt[i+1] & 0xff;
 4d4:	cbc9                	beqz	a5,566 <vprintf+0xfe>
 4d6:	00ea06b3          	add	a3,s4,a4
 4da:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 4de:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 4e0:	c681                	beqz	a3,4e8 <vprintf+0x80>
 4e2:	9752                	add	a4,a4,s4
 4e4:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 4e8:	05878363          	beq	a5,s8,52e <vprintf+0xc6>
      } else if(c0 == 'l' && c1 == 'd'){
 4ec:	05978d63          	beq	a5,s9,546 <vprintf+0xde>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 4f0:	07500713          	li	a4,117
 4f4:	0ee78763          	beq	a5,a4,5e2 <vprintf+0x17a>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 4f8:	07800713          	li	a4,120
 4fc:	12e78963          	beq	a5,a4,62e <vprintf+0x1c6>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 500:	07000713          	li	a4,112
 504:	14e78e63          	beq	a5,a4,660 <vprintf+0x1f8>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 508:	06300713          	li	a4,99
 50c:	18e78c63          	beq	a5,a4,6a4 <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 510:	07300713          	li	a4,115
 514:	1ae78263          	beq	a5,a4,6b8 <vprintf+0x250>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 518:	02500713          	li	a4,37
 51c:	04e79563          	bne	a5,a4,566 <vprintf+0xfe>
        putc(fd, '%');
 520:	02500593          	li	a1,37
 524:	855a                	mv	a0,s6
 526:	e89ff0ef          	jal	3ae <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 52a:	4981                	li	s3,0
 52c:	b761                	j	4b4 <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 10, 1);
 52e:	008b8913          	add	s2,s7,8
 532:	4685                	li	a3,1
 534:	4629                	li	a2,10
 536:	000ba583          	lw	a1,0(s7)
 53a:	855a                	mv	a0,s6
 53c:	e91ff0ef          	jal	3cc <printint>
 540:	8bca                	mv	s7,s2
      state = 0;
 542:	4981                	li	s3,0
 544:	bf85                	j	4b4 <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'd'){
 546:	06400793          	li	a5,100
 54a:	02f68963          	beq	a3,a5,57c <vprintf+0x114>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 54e:	06c00793          	li	a5,108
 552:	04f68263          	beq	a3,a5,596 <vprintf+0x12e>
      } else if(c0 == 'l' && c1 == 'u'){
 556:	07500793          	li	a5,117
 55a:	0af68063          	beq	a3,a5,5fa <vprintf+0x192>
      } else if(c0 == 'l' && c1 == 'x'){
 55e:	07800793          	li	a5,120
 562:	0ef68263          	beq	a3,a5,646 <vprintf+0x1de>
        putc(fd, '%');
 566:	02500593          	li	a1,37
 56a:	855a                	mv	a0,s6
 56c:	e43ff0ef          	jal	3ae <putc>
        putc(fd, c0);
 570:	85ca                	mv	a1,s2
 572:	855a                	mv	a0,s6
 574:	e3bff0ef          	jal	3ae <putc>
      state = 0;
 578:	4981                	li	s3,0
 57a:	bf2d                	j	4b4 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 57c:	008b8913          	add	s2,s7,8
 580:	4685                	li	a3,1
 582:	4629                	li	a2,10
 584:	000bb583          	ld	a1,0(s7)
 588:	855a                	mv	a0,s6
 58a:	e43ff0ef          	jal	3cc <printint>
        i += 1;
 58e:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 590:	8bca                	mv	s7,s2
      state = 0;
 592:	4981                	li	s3,0
        i += 1;
 594:	b705                	j	4b4 <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 596:	06400793          	li	a5,100
 59a:	02f60763          	beq	a2,a5,5c8 <vprintf+0x160>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 59e:	07500793          	li	a5,117
 5a2:	06f60963          	beq	a2,a5,614 <vprintf+0x1ac>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 5a6:	07800793          	li	a5,120
 5aa:	faf61ee3          	bne	a2,a5,566 <vprintf+0xfe>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5ae:	008b8913          	add	s2,s7,8
 5b2:	4681                	li	a3,0
 5b4:	4641                	li	a2,16
 5b6:	000bb583          	ld	a1,0(s7)
 5ba:	855a                	mv	a0,s6
 5bc:	e11ff0ef          	jal	3cc <printint>
        i += 2;
 5c0:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 5c2:	8bca                	mv	s7,s2
      state = 0;
 5c4:	4981                	li	s3,0
        i += 2;
 5c6:	b5fd                	j	4b4 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5c8:	008b8913          	add	s2,s7,8
 5cc:	4685                	li	a3,1
 5ce:	4629                	li	a2,10
 5d0:	000bb583          	ld	a1,0(s7)
 5d4:	855a                	mv	a0,s6
 5d6:	df7ff0ef          	jal	3cc <printint>
        i += 2;
 5da:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 5dc:	8bca                	mv	s7,s2
      state = 0;
 5de:	4981                	li	s3,0
        i += 2;
 5e0:	bdd1                	j	4b4 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint32), 10, 0);
 5e2:	008b8913          	add	s2,s7,8
 5e6:	4681                	li	a3,0
 5e8:	4629                	li	a2,10
 5ea:	000be583          	lwu	a1,0(s7)
 5ee:	855a                	mv	a0,s6
 5f0:	dddff0ef          	jal	3cc <printint>
 5f4:	8bca                	mv	s7,s2
      state = 0;
 5f6:	4981                	li	s3,0
 5f8:	bd75                	j	4b4 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5fa:	008b8913          	add	s2,s7,8
 5fe:	4681                	li	a3,0
 600:	4629                	li	a2,10
 602:	000bb583          	ld	a1,0(s7)
 606:	855a                	mv	a0,s6
 608:	dc5ff0ef          	jal	3cc <printint>
        i += 1;
 60c:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 60e:	8bca                	mv	s7,s2
      state = 0;
 610:	4981                	li	s3,0
        i += 1;
 612:	b54d                	j	4b4 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 614:	008b8913          	add	s2,s7,8
 618:	4681                	li	a3,0
 61a:	4629                	li	a2,10
 61c:	000bb583          	ld	a1,0(s7)
 620:	855a                	mv	a0,s6
 622:	dabff0ef          	jal	3cc <printint>
        i += 2;
 626:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 628:	8bca                	mv	s7,s2
      state = 0;
 62a:	4981                	li	s3,0
        i += 2;
 62c:	b561                	j	4b4 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint32), 16, 0);
 62e:	008b8913          	add	s2,s7,8
 632:	4681                	li	a3,0
 634:	4641                	li	a2,16
 636:	000be583          	lwu	a1,0(s7)
 63a:	855a                	mv	a0,s6
 63c:	d91ff0ef          	jal	3cc <printint>
 640:	8bca                	mv	s7,s2
      state = 0;
 642:	4981                	li	s3,0
 644:	bd85                	j	4b4 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 16, 0);
 646:	008b8913          	add	s2,s7,8
 64a:	4681                	li	a3,0
 64c:	4641                	li	a2,16
 64e:	000bb583          	ld	a1,0(s7)
 652:	855a                	mv	a0,s6
 654:	d79ff0ef          	jal	3cc <printint>
        i += 1;
 658:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 65a:	8bca                	mv	s7,s2
      state = 0;
 65c:	4981                	li	s3,0
        i += 1;
 65e:	bd99                	j	4b4 <vprintf+0x4c>
        printptr(fd, va_arg(ap, uint64));
 660:	008b8d13          	add	s10,s7,8
 664:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 668:	03000593          	li	a1,48
 66c:	855a                	mv	a0,s6
 66e:	d41ff0ef          	jal	3ae <putc>
  putc(fd, 'x');
 672:	07800593          	li	a1,120
 676:	855a                	mv	a0,s6
 678:	d37ff0ef          	jal	3ae <putc>
 67c:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 67e:	00000b97          	auipc	s7,0x0
 682:	292b8b93          	add	s7,s7,658 # 910 <digits>
 686:	03c9d793          	srl	a5,s3,0x3c
 68a:	97de                	add	a5,a5,s7
 68c:	0007c583          	lbu	a1,0(a5)
 690:	855a                	mv	a0,s6
 692:	d1dff0ef          	jal	3ae <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 696:	0992                	sll	s3,s3,0x4
 698:	397d                	addw	s2,s2,-1
 69a:	fe0916e3          	bnez	s2,686 <vprintf+0x21e>
        printptr(fd, va_arg(ap, uint64));
 69e:	8bea                	mv	s7,s10
      state = 0;
 6a0:	4981                	li	s3,0
 6a2:	bd09                	j	4b4 <vprintf+0x4c>
        putc(fd, va_arg(ap, uint32));
 6a4:	008b8913          	add	s2,s7,8
 6a8:	000bc583          	lbu	a1,0(s7)
 6ac:	855a                	mv	a0,s6
 6ae:	d01ff0ef          	jal	3ae <putc>
 6b2:	8bca                	mv	s7,s2
      state = 0;
 6b4:	4981                	li	s3,0
 6b6:	bbfd                	j	4b4 <vprintf+0x4c>
        if((s = va_arg(ap, char*)) == 0)
 6b8:	008b8993          	add	s3,s7,8
 6bc:	000bb903          	ld	s2,0(s7)
 6c0:	00090f63          	beqz	s2,6de <vprintf+0x276>
        for(; *s; s++)
 6c4:	00094583          	lbu	a1,0(s2)
 6c8:	c195                	beqz	a1,6ec <vprintf+0x284>
          putc(fd, *s);
 6ca:	855a                	mv	a0,s6
 6cc:	ce3ff0ef          	jal	3ae <putc>
        for(; *s; s++)
 6d0:	0905                	add	s2,s2,1
 6d2:	00094583          	lbu	a1,0(s2)
 6d6:	f9f5                	bnez	a1,6ca <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 6d8:	8bce                	mv	s7,s3
      state = 0;
 6da:	4981                	li	s3,0
 6dc:	bbe1                	j	4b4 <vprintf+0x4c>
          s = "(null)";
 6de:	00000917          	auipc	s2,0x0
 6e2:	22a90913          	add	s2,s2,554 # 908 <malloc+0x11c>
        for(; *s; s++)
 6e6:	02800593          	li	a1,40
 6ea:	b7c5                	j	6ca <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 6ec:	8bce                	mv	s7,s3
      state = 0;
 6ee:	4981                	li	s3,0
 6f0:	b3d1                	j	4b4 <vprintf+0x4c>
    }
  }
}
 6f2:	60e6                	ld	ra,88(sp)
 6f4:	6446                	ld	s0,80(sp)
 6f6:	64a6                	ld	s1,72(sp)
 6f8:	6906                	ld	s2,64(sp)
 6fa:	79e2                	ld	s3,56(sp)
 6fc:	7a42                	ld	s4,48(sp)
 6fe:	7aa2                	ld	s5,40(sp)
 700:	7b02                	ld	s6,32(sp)
 702:	6be2                	ld	s7,24(sp)
 704:	6c42                	ld	s8,16(sp)
 706:	6ca2                	ld	s9,8(sp)
 708:	6d02                	ld	s10,0(sp)
 70a:	6125                	add	sp,sp,96
 70c:	8082                	ret

000000000000070e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 70e:	715d                	add	sp,sp,-80
 710:	ec06                	sd	ra,24(sp)
 712:	e822                	sd	s0,16(sp)
 714:	1000                	add	s0,sp,32
 716:	e010                	sd	a2,0(s0)
 718:	e414                	sd	a3,8(s0)
 71a:	e818                	sd	a4,16(s0)
 71c:	ec1c                	sd	a5,24(s0)
 71e:	03043023          	sd	a6,32(s0)
 722:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 726:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 72a:	8622                	mv	a2,s0
 72c:	d3dff0ef          	jal	468 <vprintf>
}
 730:	60e2                	ld	ra,24(sp)
 732:	6442                	ld	s0,16(sp)
 734:	6161                	add	sp,sp,80
 736:	8082                	ret

0000000000000738 <printf>:

void
printf(const char *fmt, ...)
{
 738:	711d                	add	sp,sp,-96
 73a:	ec06                	sd	ra,24(sp)
 73c:	e822                	sd	s0,16(sp)
 73e:	1000                	add	s0,sp,32
 740:	e40c                	sd	a1,8(s0)
 742:	e810                	sd	a2,16(s0)
 744:	ec14                	sd	a3,24(s0)
 746:	f018                	sd	a4,32(s0)
 748:	f41c                	sd	a5,40(s0)
 74a:	03043823          	sd	a6,48(s0)
 74e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 752:	00840613          	add	a2,s0,8
 756:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 75a:	85aa                	mv	a1,a0
 75c:	4505                	li	a0,1
 75e:	d0bff0ef          	jal	468 <vprintf>
}
 762:	60e2                	ld	ra,24(sp)
 764:	6442                	ld	s0,16(sp)
 766:	6125                	add	sp,sp,96
 768:	8082                	ret

000000000000076a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 76a:	1141                	add	sp,sp,-16
 76c:	e422                	sd	s0,8(sp)
 76e:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 770:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 774:	00001797          	auipc	a5,0x1
 778:	88c7b783          	ld	a5,-1908(a5) # 1000 <freep>
 77c:	a02d                	j	7a6 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 77e:	4618                	lw	a4,8(a2)
 780:	9f2d                	addw	a4,a4,a1
 782:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 786:	6398                	ld	a4,0(a5)
 788:	6310                	ld	a2,0(a4)
 78a:	a83d                	j	7c8 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 78c:	ff852703          	lw	a4,-8(a0)
 790:	9f31                	addw	a4,a4,a2
 792:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 794:	ff053683          	ld	a3,-16(a0)
 798:	a091                	j	7dc <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 79a:	6398                	ld	a4,0(a5)
 79c:	00e7e463          	bltu	a5,a4,7a4 <free+0x3a>
 7a0:	00e6ea63          	bltu	a3,a4,7b4 <free+0x4a>
{
 7a4:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7a6:	fed7fae3          	bgeu	a5,a3,79a <free+0x30>
 7aa:	6398                	ld	a4,0(a5)
 7ac:	00e6e463          	bltu	a3,a4,7b4 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7b0:	fee7eae3          	bltu	a5,a4,7a4 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 7b4:	ff852583          	lw	a1,-8(a0)
 7b8:	6390                	ld	a2,0(a5)
 7ba:	02059813          	sll	a6,a1,0x20
 7be:	01c85713          	srl	a4,a6,0x1c
 7c2:	9736                	add	a4,a4,a3
 7c4:	fae60de3          	beq	a2,a4,77e <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 7c8:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7cc:	4790                	lw	a2,8(a5)
 7ce:	02061593          	sll	a1,a2,0x20
 7d2:	01c5d713          	srl	a4,a1,0x1c
 7d6:	973e                	add	a4,a4,a5
 7d8:	fae68ae3          	beq	a3,a4,78c <free+0x22>
    p->s.ptr = bp->s.ptr;
 7dc:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7de:	00001717          	auipc	a4,0x1
 7e2:	82f73123          	sd	a5,-2014(a4) # 1000 <freep>
}
 7e6:	6422                	ld	s0,8(sp)
 7e8:	0141                	add	sp,sp,16
 7ea:	8082                	ret

00000000000007ec <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7ec:	7139                	add	sp,sp,-64
 7ee:	fc06                	sd	ra,56(sp)
 7f0:	f822                	sd	s0,48(sp)
 7f2:	f426                	sd	s1,40(sp)
 7f4:	f04a                	sd	s2,32(sp)
 7f6:	ec4e                	sd	s3,24(sp)
 7f8:	e852                	sd	s4,16(sp)
 7fa:	e456                	sd	s5,8(sp)
 7fc:	e05a                	sd	s6,0(sp)
 7fe:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 800:	02051493          	sll	s1,a0,0x20
 804:	9081                	srl	s1,s1,0x20
 806:	04bd                	add	s1,s1,15
 808:	8091                	srl	s1,s1,0x4
 80a:	0014899b          	addw	s3,s1,1
 80e:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 810:	00000517          	auipc	a0,0x0
 814:	7f053503          	ld	a0,2032(a0) # 1000 <freep>
 818:	c515                	beqz	a0,844 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 81a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 81c:	4798                	lw	a4,8(a5)
 81e:	02977f63          	bgeu	a4,s1,85c <malloc+0x70>
  if(nu < 4096)
 822:	8a4e                	mv	s4,s3
 824:	0009871b          	sext.w	a4,s3
 828:	6685                	lui	a3,0x1
 82a:	00d77363          	bgeu	a4,a3,830 <malloc+0x44>
 82e:	6a05                	lui	s4,0x1
 830:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 834:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 838:	00000917          	auipc	s2,0x0
 83c:	7c890913          	add	s2,s2,1992 # 1000 <freep>
  if(p == SBRK_ERROR)
 840:	5afd                	li	s5,-1
 842:	a885                	j	8b2 <malloc+0xc6>
    base.s.ptr = freep = prevp = &base;
 844:	00000797          	auipc	a5,0x0
 848:	7cc78793          	add	a5,a5,1996 # 1010 <base>
 84c:	00000717          	auipc	a4,0x0
 850:	7af73a23          	sd	a5,1972(a4) # 1000 <freep>
 854:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 856:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 85a:	b7e1                	j	822 <malloc+0x36>
      if(p->s.size == nunits)
 85c:	02e48c63          	beq	s1,a4,894 <malloc+0xa8>
        p->s.size -= nunits;
 860:	4137073b          	subw	a4,a4,s3
 864:	c798                	sw	a4,8(a5)
        p += p->s.size;
 866:	02071693          	sll	a3,a4,0x20
 86a:	01c6d713          	srl	a4,a3,0x1c
 86e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 870:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 874:	00000717          	auipc	a4,0x0
 878:	78a73623          	sd	a0,1932(a4) # 1000 <freep>
      return (void*)(p + 1);
 87c:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 880:	70e2                	ld	ra,56(sp)
 882:	7442                	ld	s0,48(sp)
 884:	74a2                	ld	s1,40(sp)
 886:	7902                	ld	s2,32(sp)
 888:	69e2                	ld	s3,24(sp)
 88a:	6a42                	ld	s4,16(sp)
 88c:	6aa2                	ld	s5,8(sp)
 88e:	6b02                	ld	s6,0(sp)
 890:	6121                	add	sp,sp,64
 892:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 894:	6398                	ld	a4,0(a5)
 896:	e118                	sd	a4,0(a0)
 898:	bff1                	j	874 <malloc+0x88>
  hp->s.size = nu;
 89a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 89e:	0541                	add	a0,a0,16
 8a0:	ecbff0ef          	jal	76a <free>
  return freep;
 8a4:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 8a8:	dd61                	beqz	a0,880 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8aa:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8ac:	4798                	lw	a4,8(a5)
 8ae:	fa9777e3          	bgeu	a4,s1,85c <malloc+0x70>
    if(p == freep)
 8b2:	00093703          	ld	a4,0(s2)
 8b6:	853e                	mv	a0,a5
 8b8:	fef719e3          	bne	a4,a5,8aa <malloc+0xbe>
  p = sbrk(nu * sizeof(Header));
 8bc:	8552                	mv	a0,s4
 8be:	a05ff0ef          	jal	2c2 <sbrk>
  if(p == SBRK_ERROR)
 8c2:	fd551ce3          	bne	a0,s5,89a <malloc+0xae>
        return 0;
 8c6:	4501                	li	a0,0
 8c8:	bf65                	j	880 <malloc+0x94>
