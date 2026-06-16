
user/_cat:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <cat>:

char buf[512];

void
cat(int fd)
{
   0:	7179                	add	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	add	s0,sp,48
   e:	89aa                	mv	s3,a0
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0) {
  10:	00001917          	auipc	s2,0x1
  14:	00090913          	mv	s2,s2
  18:	20000613          	li	a2,512
  1c:	85ca                	mv	a1,s2
  1e:	854e                	mv	a0,s3
  20:	370000ef          	jal	390 <read>
  24:	84aa                	mv	s1,a0
  26:	02a05363          	blez	a0,4c <cat+0x4c>
    if (write(1, buf, n) != n) {
  2a:	8626                	mv	a2,s1
  2c:	85ca                	mv	a1,s2
  2e:	4505                	li	a0,1
  30:	368000ef          	jal	398 <write>
  34:	fe9502e3          	beq	a0,s1,18 <cat+0x18>
      fprintf(2, "cat: write error\n");
  38:	00001597          	auipc	a1,0x1
  3c:	91858593          	add	a1,a1,-1768 # 950 <malloc+0xe2>
  40:	4509                	li	a0,2
  42:	74e000ef          	jal	790 <fprintf>
      exit(1);
  46:	4505                	li	a0,1
  48:	330000ef          	jal	378 <exit>
    }
  }
  if(n < 0){
  4c:	00054963          	bltz	a0,5e <cat+0x5e>
    fprintf(2, "cat: read error\n");
    exit(1);
  }
}
  50:	70a2                	ld	ra,40(sp)
  52:	7402                	ld	s0,32(sp)
  54:	64e2                	ld	s1,24(sp)
  56:	6942                	ld	s2,16(sp)
  58:	69a2                	ld	s3,8(sp)
  5a:	6145                	add	sp,sp,48
  5c:	8082                	ret
    fprintf(2, "cat: read error\n");
  5e:	00001597          	auipc	a1,0x1
  62:	90a58593          	add	a1,a1,-1782 # 968 <malloc+0xfa>
  66:	4509                	li	a0,2
  68:	728000ef          	jal	790 <fprintf>
    exit(1);
  6c:	4505                	li	a0,1
  6e:	30a000ef          	jal	378 <exit>

0000000000000072 <main>:

int
main(int argc, char *argv[])
{
  72:	7179                	add	sp,sp,-48
  74:	f406                	sd	ra,40(sp)
  76:	f022                	sd	s0,32(sp)
  78:	ec26                	sd	s1,24(sp)
  7a:	e84a                	sd	s2,16(sp)
  7c:	e44e                	sd	s3,8(sp)
  7e:	1800                	add	s0,sp,48
  int fd, i;

  if(argc <= 1){
  80:	4785                	li	a5,1
  82:	02a7df63          	bge	a5,a0,c0 <main+0x4e>
  86:	00858913          	add	s2,a1,8
  8a:	ffe5099b          	addw	s3,a0,-2
  8e:	02099793          	sll	a5,s3,0x20
  92:	01d7d993          	srl	s3,a5,0x1d
  96:	05c1                	add	a1,a1,16
  98:	99ae                	add	s3,s3,a1
    cat(0);
    exit(0);
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], O_RDONLY)) < 0){
  9a:	4581                	li	a1,0
  9c:	00093503          	ld	a0,0(s2) # 1010 <buf>
  a0:	318000ef          	jal	3b8 <open>
  a4:	84aa                	mv	s1,a0
  a6:	02054363          	bltz	a0,cc <main+0x5a>
      fprintf(2, "cat: cannot open %s\n", argv[i]);
      exit(1);
    }
    cat(fd);
  aa:	f57ff0ef          	jal	0 <cat>
    close(fd);
  ae:	8526                	mv	a0,s1
  b0:	2f0000ef          	jal	3a0 <close>
  for(i = 1; i < argc; i++){
  b4:	0921                	add	s2,s2,8
  b6:	ff3912e3          	bne	s2,s3,9a <main+0x28>
  }
  exit(0);
  ba:	4501                	li	a0,0
  bc:	2bc000ef          	jal	378 <exit>
    cat(0);
  c0:	4501                	li	a0,0
  c2:	f3fff0ef          	jal	0 <cat>
    exit(0);
  c6:	4501                	li	a0,0
  c8:	2b0000ef          	jal	378 <exit>
      fprintf(2, "cat: cannot open %s\n", argv[i]);
  cc:	00093603          	ld	a2,0(s2)
  d0:	00001597          	auipc	a1,0x1
  d4:	8b058593          	add	a1,a1,-1872 # 980 <malloc+0x112>
  d8:	4509                	li	a0,2
  da:	6b6000ef          	jal	790 <fprintf>
      exit(1);
  de:	4505                	li	a0,1
  e0:	298000ef          	jal	378 <exit>

00000000000000e4 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  e4:	1141                	add	sp,sp,-16
  e6:	e406                	sd	ra,8(sp)
  e8:	e022                	sd	s0,0(sp)
  ea:	0800                	add	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  ec:	f87ff0ef          	jal	72 <main>
  exit(r);
  f0:	288000ef          	jal	378 <exit>

00000000000000f4 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  f4:	1141                	add	sp,sp,-16
  f6:	e422                	sd	s0,8(sp)
  f8:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  fa:	87aa                	mv	a5,a0
  fc:	0585                	add	a1,a1,1
  fe:	0785                	add	a5,a5,1
 100:	fff5c703          	lbu	a4,-1(a1)
 104:	fee78fa3          	sb	a4,-1(a5)
 108:	fb75                	bnez	a4,fc <strcpy+0x8>
    ;
  return os;
}
 10a:	6422                	ld	s0,8(sp)
 10c:	0141                	add	sp,sp,16
 10e:	8082                	ret

0000000000000110 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 110:	1141                	add	sp,sp,-16
 112:	e422                	sd	s0,8(sp)
 114:	0800                	add	s0,sp,16
  while(*p && *p == *q)
 116:	00054783          	lbu	a5,0(a0)
 11a:	cb91                	beqz	a5,12e <strcmp+0x1e>
 11c:	0005c703          	lbu	a4,0(a1)
 120:	00f71763          	bne	a4,a5,12e <strcmp+0x1e>
    p++, q++;
 124:	0505                	add	a0,a0,1
 126:	0585                	add	a1,a1,1
  while(*p && *p == *q)
 128:	00054783          	lbu	a5,0(a0)
 12c:	fbe5                	bnez	a5,11c <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 12e:	0005c503          	lbu	a0,0(a1)
}
 132:	40a7853b          	subw	a0,a5,a0
 136:	6422                	ld	s0,8(sp)
 138:	0141                	add	sp,sp,16
 13a:	8082                	ret

000000000000013c <strlen>:

uint
strlen(const char *s)
{
 13c:	1141                	add	sp,sp,-16
 13e:	e422                	sd	s0,8(sp)
 140:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 142:	00054783          	lbu	a5,0(a0)
 146:	cf91                	beqz	a5,162 <strlen+0x26>
 148:	0505                	add	a0,a0,1
 14a:	87aa                	mv	a5,a0
 14c:	86be                	mv	a3,a5
 14e:	0785                	add	a5,a5,1
 150:	fff7c703          	lbu	a4,-1(a5)
 154:	ff65                	bnez	a4,14c <strlen+0x10>
 156:	40a6853b          	subw	a0,a3,a0
 15a:	2505                	addw	a0,a0,1
    ;
  return n;
}
 15c:	6422                	ld	s0,8(sp)
 15e:	0141                	add	sp,sp,16
 160:	8082                	ret
  for(n = 0; s[n]; n++)
 162:	4501                	li	a0,0
 164:	bfe5                	j	15c <strlen+0x20>

0000000000000166 <memset>:

void*
memset(void *dst, int c, uint n)
{
 166:	1141                	add	sp,sp,-16
 168:	e422                	sd	s0,8(sp)
 16a:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 16c:	ca19                	beqz	a2,182 <memset+0x1c>
 16e:	87aa                	mv	a5,a0
 170:	1602                	sll	a2,a2,0x20
 172:	9201                	srl	a2,a2,0x20
 174:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 178:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 17c:	0785                	add	a5,a5,1
 17e:	fee79de3          	bne	a5,a4,178 <memset+0x12>
  }
  return dst;
}
 182:	6422                	ld	s0,8(sp)
 184:	0141                	add	sp,sp,16
 186:	8082                	ret

0000000000000188 <strchr>:

char*
strchr(const char *s, char c)
{
 188:	1141                	add	sp,sp,-16
 18a:	e422                	sd	s0,8(sp)
 18c:	0800                	add	s0,sp,16
  for(; *s; s++)
 18e:	00054783          	lbu	a5,0(a0)
 192:	cb99                	beqz	a5,1a8 <strchr+0x20>
    if(*s == c)
 194:	00f58763          	beq	a1,a5,1a2 <strchr+0x1a>
  for(; *s; s++)
 198:	0505                	add	a0,a0,1
 19a:	00054783          	lbu	a5,0(a0)
 19e:	fbfd                	bnez	a5,194 <strchr+0xc>
      return (char*)s;
  return 0;
 1a0:	4501                	li	a0,0
}
 1a2:	6422                	ld	s0,8(sp)
 1a4:	0141                	add	sp,sp,16
 1a6:	8082                	ret
  return 0;
 1a8:	4501                	li	a0,0
 1aa:	bfe5                	j	1a2 <strchr+0x1a>

00000000000001ac <gets>:

char*
gets(char *buf, int max)
{
 1ac:	711d                	add	sp,sp,-96
 1ae:	ec86                	sd	ra,88(sp)
 1b0:	e8a2                	sd	s0,80(sp)
 1b2:	e4a6                	sd	s1,72(sp)
 1b4:	e0ca                	sd	s2,64(sp)
 1b6:	fc4e                	sd	s3,56(sp)
 1b8:	f852                	sd	s4,48(sp)
 1ba:	f456                	sd	s5,40(sp)
 1bc:	f05a                	sd	s6,32(sp)
 1be:	ec5e                	sd	s7,24(sp)
 1c0:	1080                	add	s0,sp,96
 1c2:	8baa                	mv	s7,a0
 1c4:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1c6:	892a                	mv	s2,a0
 1c8:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1ca:	4aa9                	li	s5,10
 1cc:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1ce:	89a6                	mv	s3,s1
 1d0:	2485                	addw	s1,s1,1
 1d2:	0344d663          	bge	s1,s4,1fe <gets+0x52>
    cc = read(0, &c, 1);
 1d6:	4605                	li	a2,1
 1d8:	faf40593          	add	a1,s0,-81
 1dc:	4501                	li	a0,0
 1de:	1b2000ef          	jal	390 <read>
    if(cc < 1)
 1e2:	00a05e63          	blez	a0,1fe <gets+0x52>
    buf[i++] = c;
 1e6:	faf44783          	lbu	a5,-81(s0)
 1ea:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1ee:	01578763          	beq	a5,s5,1fc <gets+0x50>
 1f2:	0905                	add	s2,s2,1
 1f4:	fd679de3          	bne	a5,s6,1ce <gets+0x22>
  for(i=0; i+1 < max; ){
 1f8:	89a6                	mv	s3,s1
 1fa:	a011                	j	1fe <gets+0x52>
 1fc:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 1fe:	99de                	add	s3,s3,s7
 200:	00098023          	sb	zero,0(s3)
  return buf;
}
 204:	855e                	mv	a0,s7
 206:	60e6                	ld	ra,88(sp)
 208:	6446                	ld	s0,80(sp)
 20a:	64a6                	ld	s1,72(sp)
 20c:	6906                	ld	s2,64(sp)
 20e:	79e2                	ld	s3,56(sp)
 210:	7a42                	ld	s4,48(sp)
 212:	7aa2                	ld	s5,40(sp)
 214:	7b02                	ld	s6,32(sp)
 216:	6be2                	ld	s7,24(sp)
 218:	6125                	add	sp,sp,96
 21a:	8082                	ret

000000000000021c <stat>:

int
stat(const char *n, struct stat *st)
{
 21c:	1101                	add	sp,sp,-32
 21e:	ec06                	sd	ra,24(sp)
 220:	e822                	sd	s0,16(sp)
 222:	e426                	sd	s1,8(sp)
 224:	e04a                	sd	s2,0(sp)
 226:	1000                	add	s0,sp,32
 228:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 22a:	4581                	li	a1,0
 22c:	18c000ef          	jal	3b8 <open>
  if(fd < 0)
 230:	02054163          	bltz	a0,252 <stat+0x36>
 234:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 236:	85ca                	mv	a1,s2
 238:	198000ef          	jal	3d0 <fstat>
 23c:	892a                	mv	s2,a0
  close(fd);
 23e:	8526                	mv	a0,s1
 240:	160000ef          	jal	3a0 <close>
  return r;
}
 244:	854a                	mv	a0,s2
 246:	60e2                	ld	ra,24(sp)
 248:	6442                	ld	s0,16(sp)
 24a:	64a2                	ld	s1,8(sp)
 24c:	6902                	ld	s2,0(sp)
 24e:	6105                	add	sp,sp,32
 250:	8082                	ret
    return -1;
 252:	597d                	li	s2,-1
 254:	bfc5                	j	244 <stat+0x28>

0000000000000256 <atoi>:

int
atoi(const char *s)
{
 256:	1141                	add	sp,sp,-16
 258:	e422                	sd	s0,8(sp)
 25a:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 25c:	00054683          	lbu	a3,0(a0)
 260:	fd06879b          	addw	a5,a3,-48
 264:	0ff7f793          	zext.b	a5,a5
 268:	4625                	li	a2,9
 26a:	02f66863          	bltu	a2,a5,29a <atoi+0x44>
 26e:	872a                	mv	a4,a0
  n = 0;
 270:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 272:	0705                	add	a4,a4,1
 274:	0025179b          	sllw	a5,a0,0x2
 278:	9fa9                	addw	a5,a5,a0
 27a:	0017979b          	sllw	a5,a5,0x1
 27e:	9fb5                	addw	a5,a5,a3
 280:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 284:	00074683          	lbu	a3,0(a4)
 288:	fd06879b          	addw	a5,a3,-48
 28c:	0ff7f793          	zext.b	a5,a5
 290:	fef671e3          	bgeu	a2,a5,272 <atoi+0x1c>
  return n;
}
 294:	6422                	ld	s0,8(sp)
 296:	0141                	add	sp,sp,16
 298:	8082                	ret
  n = 0;
 29a:	4501                	li	a0,0
 29c:	bfe5                	j	294 <atoi+0x3e>

000000000000029e <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 29e:	1141                	add	sp,sp,-16
 2a0:	e422                	sd	s0,8(sp)
 2a2:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2a4:	02b57463          	bgeu	a0,a1,2cc <memmove+0x2e>
    while(n-- > 0)
 2a8:	00c05f63          	blez	a2,2c6 <memmove+0x28>
 2ac:	1602                	sll	a2,a2,0x20
 2ae:	9201                	srl	a2,a2,0x20
 2b0:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2b4:	872a                	mv	a4,a0
      *dst++ = *src++;
 2b6:	0585                	add	a1,a1,1
 2b8:	0705                	add	a4,a4,1
 2ba:	fff5c683          	lbu	a3,-1(a1)
 2be:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2c2:	fee79ae3          	bne	a5,a4,2b6 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2c6:	6422                	ld	s0,8(sp)
 2c8:	0141                	add	sp,sp,16
 2ca:	8082                	ret
    dst += n;
 2cc:	00c50733          	add	a4,a0,a2
    src += n;
 2d0:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2d2:	fec05ae3          	blez	a2,2c6 <memmove+0x28>
 2d6:	fff6079b          	addw	a5,a2,-1
 2da:	1782                	sll	a5,a5,0x20
 2dc:	9381                	srl	a5,a5,0x20
 2de:	fff7c793          	not	a5,a5
 2e2:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2e4:	15fd                	add	a1,a1,-1
 2e6:	177d                	add	a4,a4,-1
 2e8:	0005c683          	lbu	a3,0(a1)
 2ec:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2f0:	fee79ae3          	bne	a5,a4,2e4 <memmove+0x46>
 2f4:	bfc9                	j	2c6 <memmove+0x28>

00000000000002f6 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2f6:	1141                	add	sp,sp,-16
 2f8:	e422                	sd	s0,8(sp)
 2fa:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2fc:	ca05                	beqz	a2,32c <memcmp+0x36>
 2fe:	fff6069b          	addw	a3,a2,-1
 302:	1682                	sll	a3,a3,0x20
 304:	9281                	srl	a3,a3,0x20
 306:	0685                	add	a3,a3,1
 308:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 30a:	00054783          	lbu	a5,0(a0)
 30e:	0005c703          	lbu	a4,0(a1)
 312:	00e79863          	bne	a5,a4,322 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 316:	0505                	add	a0,a0,1
    p2++;
 318:	0585                	add	a1,a1,1
  while (n-- > 0) {
 31a:	fed518e3          	bne	a0,a3,30a <memcmp+0x14>
  }
  return 0;
 31e:	4501                	li	a0,0
 320:	a019                	j	326 <memcmp+0x30>
      return *p1 - *p2;
 322:	40e7853b          	subw	a0,a5,a4
}
 326:	6422                	ld	s0,8(sp)
 328:	0141                	add	sp,sp,16
 32a:	8082                	ret
  return 0;
 32c:	4501                	li	a0,0
 32e:	bfe5                	j	326 <memcmp+0x30>

0000000000000330 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 330:	1141                	add	sp,sp,-16
 332:	e406                	sd	ra,8(sp)
 334:	e022                	sd	s0,0(sp)
 336:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 338:	f67ff0ef          	jal	29e <memmove>
}
 33c:	60a2                	ld	ra,8(sp)
 33e:	6402                	ld	s0,0(sp)
 340:	0141                	add	sp,sp,16
 342:	8082                	ret

0000000000000344 <sbrk>:

char *
sbrk(int n) {
 344:	1141                	add	sp,sp,-16
 346:	e406                	sd	ra,8(sp)
 348:	e022                	sd	s0,0(sp)
 34a:	0800                	add	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 34c:	4585                	li	a1,1
 34e:	0b2000ef          	jal	400 <sys_sbrk>
}
 352:	60a2                	ld	ra,8(sp)
 354:	6402                	ld	s0,0(sp)
 356:	0141                	add	sp,sp,16
 358:	8082                	ret

000000000000035a <sbrklazy>:

char *
sbrklazy(int n) {
 35a:	1141                	add	sp,sp,-16
 35c:	e406                	sd	ra,8(sp)
 35e:	e022                	sd	s0,0(sp)
 360:	0800                	add	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 362:	4589                	li	a1,2
 364:	09c000ef          	jal	400 <sys_sbrk>
}
 368:	60a2                	ld	ra,8(sp)
 36a:	6402                	ld	s0,0(sp)
 36c:	0141                	add	sp,sp,16
 36e:	8082                	ret

0000000000000370 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 370:	4885                	li	a7,1
 ecall
 372:	00000073          	ecall
 ret
 376:	8082                	ret

0000000000000378 <exit>:
.global exit
exit:
 li a7, SYS_exit
 378:	4889                	li	a7,2
 ecall
 37a:	00000073          	ecall
 ret
 37e:	8082                	ret

0000000000000380 <wait>:
.global wait
wait:
 li a7, SYS_wait
 380:	488d                	li	a7,3
 ecall
 382:	00000073          	ecall
 ret
 386:	8082                	ret

0000000000000388 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 388:	4891                	li	a7,4
 ecall
 38a:	00000073          	ecall
 ret
 38e:	8082                	ret

0000000000000390 <read>:
.global read
read:
 li a7, SYS_read
 390:	4895                	li	a7,5
 ecall
 392:	00000073          	ecall
 ret
 396:	8082                	ret

0000000000000398 <write>:
.global write
write:
 li a7, SYS_write
 398:	48c1                	li	a7,16
 ecall
 39a:	00000073          	ecall
 ret
 39e:	8082                	ret

00000000000003a0 <close>:
.global close
close:
 li a7, SYS_close
 3a0:	48d5                	li	a7,21
 ecall
 3a2:	00000073          	ecall
 ret
 3a6:	8082                	ret

00000000000003a8 <kill>:
.global kill
kill:
 li a7, SYS_kill
 3a8:	4899                	li	a7,6
 ecall
 3aa:	00000073          	ecall
 ret
 3ae:	8082                	ret

00000000000003b0 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3b0:	489d                	li	a7,7
 ecall
 3b2:	00000073          	ecall
 ret
 3b6:	8082                	ret

00000000000003b8 <open>:
.global open
open:
 li a7, SYS_open
 3b8:	48bd                	li	a7,15
 ecall
 3ba:	00000073          	ecall
 ret
 3be:	8082                	ret

00000000000003c0 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3c0:	48c5                	li	a7,17
 ecall
 3c2:	00000073          	ecall
 ret
 3c6:	8082                	ret

00000000000003c8 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3c8:	48c9                	li	a7,18
 ecall
 3ca:	00000073          	ecall
 ret
 3ce:	8082                	ret

00000000000003d0 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3d0:	48a1                	li	a7,8
 ecall
 3d2:	00000073          	ecall
 ret
 3d6:	8082                	ret

00000000000003d8 <link>:
.global link
link:
 li a7, SYS_link
 3d8:	48cd                	li	a7,19
 ecall
 3da:	00000073          	ecall
 ret
 3de:	8082                	ret

00000000000003e0 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3e0:	48d1                	li	a7,20
 ecall
 3e2:	00000073          	ecall
 ret
 3e6:	8082                	ret

00000000000003e8 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3e8:	48a5                	li	a7,9
 ecall
 3ea:	00000073          	ecall
 ret
 3ee:	8082                	ret

00000000000003f0 <dup>:
.global dup
dup:
 li a7, SYS_dup
 3f0:	48a9                	li	a7,10
 ecall
 3f2:	00000073          	ecall
 ret
 3f6:	8082                	ret

00000000000003f8 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3f8:	48ad                	li	a7,11
 ecall
 3fa:	00000073          	ecall
 ret
 3fe:	8082                	ret

0000000000000400 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 400:	48b1                	li	a7,12
 ecall
 402:	00000073          	ecall
 ret
 406:	8082                	ret

0000000000000408 <pause>:
.global pause
pause:
 li a7, SYS_pause
 408:	48b5                	li	a7,13
 ecall
 40a:	00000073          	ecall
 ret
 40e:	8082                	ret

0000000000000410 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 410:	48b9                	li	a7,14
 ecall
 412:	00000073          	ecall
 ret
 416:	8082                	ret

0000000000000418 <getcnt>:
.global getcnt
getcnt:
 li a7, SYS_getcnt
 418:	48d9                	li	a7,22
 ecall
 41a:	00000073          	ecall
 ret
 41e:	8082                	ret

0000000000000420 <settickets>:
.global settickets
settickets:
 li a7, SYS_settickets
 420:	48dd                	li	a7,23
 ecall
 422:	00000073          	ecall
 ret
 426:	8082                	ret

0000000000000428 <getpinfo>:
.global getpinfo
getpinfo:
 li a7, SYS_getpinfo
 428:	48e1                	li	a7,24
 ecall
 42a:	00000073          	ecall
 ret
 42e:	8082                	ret

0000000000000430 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 430:	1101                	add	sp,sp,-32
 432:	ec06                	sd	ra,24(sp)
 434:	e822                	sd	s0,16(sp)
 436:	1000                	add	s0,sp,32
 438:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 43c:	4605                	li	a2,1
 43e:	fef40593          	add	a1,s0,-17
 442:	f57ff0ef          	jal	398 <write>
}
 446:	60e2                	ld	ra,24(sp)
 448:	6442                	ld	s0,16(sp)
 44a:	6105                	add	sp,sp,32
 44c:	8082                	ret

000000000000044e <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 44e:	715d                	add	sp,sp,-80
 450:	e486                	sd	ra,72(sp)
 452:	e0a2                	sd	s0,64(sp)
 454:	fc26                	sd	s1,56(sp)
 456:	f84a                	sd	s2,48(sp)
 458:	f44e                	sd	s3,40(sp)
 45a:	0880                	add	s0,sp,80
 45c:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 45e:	c299                	beqz	a3,464 <printint+0x16>
 460:	0805c163          	bltz	a1,4e2 <printint+0x94>
  neg = 0;
 464:	4881                	li	a7,0
 466:	fb840693          	add	a3,s0,-72
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 46a:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 46c:	00000517          	auipc	a0,0x0
 470:	53450513          	add	a0,a0,1332 # 9a0 <digits>
 474:	883e                	mv	a6,a5
 476:	2785                	addw	a5,a5,1
 478:	02c5f733          	remu	a4,a1,a2
 47c:	972a                	add	a4,a4,a0
 47e:	00074703          	lbu	a4,0(a4)
 482:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 486:	872e                	mv	a4,a1
 488:	02c5d5b3          	divu	a1,a1,a2
 48c:	0685                	add	a3,a3,1
 48e:	fec773e3          	bgeu	a4,a2,474 <printint+0x26>
  if(neg)
 492:	00088b63          	beqz	a7,4a8 <printint+0x5a>
    buf[i++] = '-';
 496:	fd078793          	add	a5,a5,-48
 49a:	97a2                	add	a5,a5,s0
 49c:	02d00713          	li	a4,45
 4a0:	fee78423          	sb	a4,-24(a5)
 4a4:	0028079b          	addw	a5,a6,2

  while(--i >= 0)
 4a8:	02f05663          	blez	a5,4d4 <printint+0x86>
 4ac:	fb840713          	add	a4,s0,-72
 4b0:	00f704b3          	add	s1,a4,a5
 4b4:	fff70993          	add	s3,a4,-1
 4b8:	99be                	add	s3,s3,a5
 4ba:	37fd                	addw	a5,a5,-1
 4bc:	1782                	sll	a5,a5,0x20
 4be:	9381                	srl	a5,a5,0x20
 4c0:	40f989b3          	sub	s3,s3,a5
    putc(fd, buf[i]);
 4c4:	fff4c583          	lbu	a1,-1(s1)
 4c8:	854a                	mv	a0,s2
 4ca:	f67ff0ef          	jal	430 <putc>
  while(--i >= 0)
 4ce:	14fd                	add	s1,s1,-1
 4d0:	ff349ae3          	bne	s1,s3,4c4 <printint+0x76>
}
 4d4:	60a6                	ld	ra,72(sp)
 4d6:	6406                	ld	s0,64(sp)
 4d8:	74e2                	ld	s1,56(sp)
 4da:	7942                	ld	s2,48(sp)
 4dc:	79a2                	ld	s3,40(sp)
 4de:	6161                	add	sp,sp,80
 4e0:	8082                	ret
    x = -xx;
 4e2:	40b005b3          	neg	a1,a1
    neg = 1;
 4e6:	4885                	li	a7,1
    x = -xx;
 4e8:	bfbd                	j	466 <printint+0x18>

00000000000004ea <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4ea:	711d                	add	sp,sp,-96
 4ec:	ec86                	sd	ra,88(sp)
 4ee:	e8a2                	sd	s0,80(sp)
 4f0:	e4a6                	sd	s1,72(sp)
 4f2:	e0ca                	sd	s2,64(sp)
 4f4:	fc4e                	sd	s3,56(sp)
 4f6:	f852                	sd	s4,48(sp)
 4f8:	f456                	sd	s5,40(sp)
 4fa:	f05a                	sd	s6,32(sp)
 4fc:	ec5e                	sd	s7,24(sp)
 4fe:	e862                	sd	s8,16(sp)
 500:	e466                	sd	s9,8(sp)
 502:	e06a                	sd	s10,0(sp)
 504:	1080                	add	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 506:	0005c903          	lbu	s2,0(a1)
 50a:	26090563          	beqz	s2,774 <vprintf+0x28a>
 50e:	8b2a                	mv	s6,a0
 510:	8a2e                	mv	s4,a1
 512:	8bb2                	mv	s7,a2
  state = 0;
 514:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 516:	4481                	li	s1,0
 518:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 51a:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 51e:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 522:	06c00c93          	li	s9,108
 526:	a005                	j	546 <vprintf+0x5c>
        putc(fd, c0);
 528:	85ca                	mv	a1,s2
 52a:	855a                	mv	a0,s6
 52c:	f05ff0ef          	jal	430 <putc>
 530:	a019                	j	536 <vprintf+0x4c>
    } else if(state == '%'){
 532:	03598263          	beq	s3,s5,556 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 536:	2485                	addw	s1,s1,1
 538:	8726                	mv	a4,s1
 53a:	009a07b3          	add	a5,s4,s1
 53e:	0007c903          	lbu	s2,0(a5)
 542:	22090963          	beqz	s2,774 <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
 546:	0009079b          	sext.w	a5,s2
    if(state == 0){
 54a:	fe0994e3          	bnez	s3,532 <vprintf+0x48>
      if(c0 == '%'){
 54e:	fd579de3          	bne	a5,s5,528 <vprintf+0x3e>
        state = '%';
 552:	89be                	mv	s3,a5
 554:	b7cd                	j	536 <vprintf+0x4c>
      if(c0) c1 = fmt[i+1] & 0xff;
 556:	cbc9                	beqz	a5,5e8 <vprintf+0xfe>
 558:	00ea06b3          	add	a3,s4,a4
 55c:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 560:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 562:	c681                	beqz	a3,56a <vprintf+0x80>
 564:	9752                	add	a4,a4,s4
 566:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 56a:	05878363          	beq	a5,s8,5b0 <vprintf+0xc6>
      } else if(c0 == 'l' && c1 == 'd'){
 56e:	05978d63          	beq	a5,s9,5c8 <vprintf+0xde>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 572:	07500713          	li	a4,117
 576:	0ee78763          	beq	a5,a4,664 <vprintf+0x17a>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 57a:	07800713          	li	a4,120
 57e:	12e78963          	beq	a5,a4,6b0 <vprintf+0x1c6>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 582:	07000713          	li	a4,112
 586:	14e78e63          	beq	a5,a4,6e2 <vprintf+0x1f8>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 58a:	06300713          	li	a4,99
 58e:	18e78c63          	beq	a5,a4,726 <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 592:	07300713          	li	a4,115
 596:	1ae78263          	beq	a5,a4,73a <vprintf+0x250>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 59a:	02500713          	li	a4,37
 59e:	04e79563          	bne	a5,a4,5e8 <vprintf+0xfe>
        putc(fd, '%');
 5a2:	02500593          	li	a1,37
 5a6:	855a                	mv	a0,s6
 5a8:	e89ff0ef          	jal	430 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 5ac:	4981                	li	s3,0
 5ae:	b761                	j	536 <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 10, 1);
 5b0:	008b8913          	add	s2,s7,8
 5b4:	4685                	li	a3,1
 5b6:	4629                	li	a2,10
 5b8:	000ba583          	lw	a1,0(s7)
 5bc:	855a                	mv	a0,s6
 5be:	e91ff0ef          	jal	44e <printint>
 5c2:	8bca                	mv	s7,s2
      state = 0;
 5c4:	4981                	li	s3,0
 5c6:	bf85                	j	536 <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'd'){
 5c8:	06400793          	li	a5,100
 5cc:	02f68963          	beq	a3,a5,5fe <vprintf+0x114>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5d0:	06c00793          	li	a5,108
 5d4:	04f68263          	beq	a3,a5,618 <vprintf+0x12e>
      } else if(c0 == 'l' && c1 == 'u'){
 5d8:	07500793          	li	a5,117
 5dc:	0af68063          	beq	a3,a5,67c <vprintf+0x192>
      } else if(c0 == 'l' && c1 == 'x'){
 5e0:	07800793          	li	a5,120
 5e4:	0ef68263          	beq	a3,a5,6c8 <vprintf+0x1de>
        putc(fd, '%');
 5e8:	02500593          	li	a1,37
 5ec:	855a                	mv	a0,s6
 5ee:	e43ff0ef          	jal	430 <putc>
        putc(fd, c0);
 5f2:	85ca                	mv	a1,s2
 5f4:	855a                	mv	a0,s6
 5f6:	e3bff0ef          	jal	430 <putc>
      state = 0;
 5fa:	4981                	li	s3,0
 5fc:	bf2d                	j	536 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5fe:	008b8913          	add	s2,s7,8
 602:	4685                	li	a3,1
 604:	4629                	li	a2,10
 606:	000bb583          	ld	a1,0(s7)
 60a:	855a                	mv	a0,s6
 60c:	e43ff0ef          	jal	44e <printint>
        i += 1;
 610:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 612:	8bca                	mv	s7,s2
      state = 0;
 614:	4981                	li	s3,0
        i += 1;
 616:	b705                	j	536 <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 618:	06400793          	li	a5,100
 61c:	02f60763          	beq	a2,a5,64a <vprintf+0x160>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 620:	07500793          	li	a5,117
 624:	06f60963          	beq	a2,a5,696 <vprintf+0x1ac>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 628:	07800793          	li	a5,120
 62c:	faf61ee3          	bne	a2,a5,5e8 <vprintf+0xfe>
        printint(fd, va_arg(ap, uint64), 16, 0);
 630:	008b8913          	add	s2,s7,8
 634:	4681                	li	a3,0
 636:	4641                	li	a2,16
 638:	000bb583          	ld	a1,0(s7)
 63c:	855a                	mv	a0,s6
 63e:	e11ff0ef          	jal	44e <printint>
        i += 2;
 642:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 644:	8bca                	mv	s7,s2
      state = 0;
 646:	4981                	li	s3,0
        i += 2;
 648:	b5fd                	j	536 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 64a:	008b8913          	add	s2,s7,8
 64e:	4685                	li	a3,1
 650:	4629                	li	a2,10
 652:	000bb583          	ld	a1,0(s7)
 656:	855a                	mv	a0,s6
 658:	df7ff0ef          	jal	44e <printint>
        i += 2;
 65c:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 65e:	8bca                	mv	s7,s2
      state = 0;
 660:	4981                	li	s3,0
        i += 2;
 662:	bdd1                	j	536 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint32), 10, 0);
 664:	008b8913          	add	s2,s7,8
 668:	4681                	li	a3,0
 66a:	4629                	li	a2,10
 66c:	000be583          	lwu	a1,0(s7)
 670:	855a                	mv	a0,s6
 672:	dddff0ef          	jal	44e <printint>
 676:	8bca                	mv	s7,s2
      state = 0;
 678:	4981                	li	s3,0
 67a:	bd75                	j	536 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 67c:	008b8913          	add	s2,s7,8
 680:	4681                	li	a3,0
 682:	4629                	li	a2,10
 684:	000bb583          	ld	a1,0(s7)
 688:	855a                	mv	a0,s6
 68a:	dc5ff0ef          	jal	44e <printint>
        i += 1;
 68e:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 690:	8bca                	mv	s7,s2
      state = 0;
 692:	4981                	li	s3,0
        i += 1;
 694:	b54d                	j	536 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 696:	008b8913          	add	s2,s7,8
 69a:	4681                	li	a3,0
 69c:	4629                	li	a2,10
 69e:	000bb583          	ld	a1,0(s7)
 6a2:	855a                	mv	a0,s6
 6a4:	dabff0ef          	jal	44e <printint>
        i += 2;
 6a8:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 6aa:	8bca                	mv	s7,s2
      state = 0;
 6ac:	4981                	li	s3,0
        i += 2;
 6ae:	b561                	j	536 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint32), 16, 0);
 6b0:	008b8913          	add	s2,s7,8
 6b4:	4681                	li	a3,0
 6b6:	4641                	li	a2,16
 6b8:	000be583          	lwu	a1,0(s7)
 6bc:	855a                	mv	a0,s6
 6be:	d91ff0ef          	jal	44e <printint>
 6c2:	8bca                	mv	s7,s2
      state = 0;
 6c4:	4981                	li	s3,0
 6c6:	bd85                	j	536 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6c8:	008b8913          	add	s2,s7,8
 6cc:	4681                	li	a3,0
 6ce:	4641                	li	a2,16
 6d0:	000bb583          	ld	a1,0(s7)
 6d4:	855a                	mv	a0,s6
 6d6:	d79ff0ef          	jal	44e <printint>
        i += 1;
 6da:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 6dc:	8bca                	mv	s7,s2
      state = 0;
 6de:	4981                	li	s3,0
        i += 1;
 6e0:	bd99                	j	536 <vprintf+0x4c>
        printptr(fd, va_arg(ap, uint64));
 6e2:	008b8d13          	add	s10,s7,8
 6e6:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6ea:	03000593          	li	a1,48
 6ee:	855a                	mv	a0,s6
 6f0:	d41ff0ef          	jal	430 <putc>
  putc(fd, 'x');
 6f4:	07800593          	li	a1,120
 6f8:	855a                	mv	a0,s6
 6fa:	d37ff0ef          	jal	430 <putc>
 6fe:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 700:	00000b97          	auipc	s7,0x0
 704:	2a0b8b93          	add	s7,s7,672 # 9a0 <digits>
 708:	03c9d793          	srl	a5,s3,0x3c
 70c:	97de                	add	a5,a5,s7
 70e:	0007c583          	lbu	a1,0(a5)
 712:	855a                	mv	a0,s6
 714:	d1dff0ef          	jal	430 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 718:	0992                	sll	s3,s3,0x4
 71a:	397d                	addw	s2,s2,-1
 71c:	fe0916e3          	bnez	s2,708 <vprintf+0x21e>
        printptr(fd, va_arg(ap, uint64));
 720:	8bea                	mv	s7,s10
      state = 0;
 722:	4981                	li	s3,0
 724:	bd09                	j	536 <vprintf+0x4c>
        putc(fd, va_arg(ap, uint32));
 726:	008b8913          	add	s2,s7,8
 72a:	000bc583          	lbu	a1,0(s7)
 72e:	855a                	mv	a0,s6
 730:	d01ff0ef          	jal	430 <putc>
 734:	8bca                	mv	s7,s2
      state = 0;
 736:	4981                	li	s3,0
 738:	bbfd                	j	536 <vprintf+0x4c>
        if((s = va_arg(ap, char*)) == 0)
 73a:	008b8993          	add	s3,s7,8
 73e:	000bb903          	ld	s2,0(s7)
 742:	00090f63          	beqz	s2,760 <vprintf+0x276>
        for(; *s; s++)
 746:	00094583          	lbu	a1,0(s2)
 74a:	c195                	beqz	a1,76e <vprintf+0x284>
          putc(fd, *s);
 74c:	855a                	mv	a0,s6
 74e:	ce3ff0ef          	jal	430 <putc>
        for(; *s; s++)
 752:	0905                	add	s2,s2,1
 754:	00094583          	lbu	a1,0(s2)
 758:	f9f5                	bnez	a1,74c <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 75a:	8bce                	mv	s7,s3
      state = 0;
 75c:	4981                	li	s3,0
 75e:	bbe1                	j	536 <vprintf+0x4c>
          s = "(null)";
 760:	00000917          	auipc	s2,0x0
 764:	23890913          	add	s2,s2,568 # 998 <malloc+0x12a>
        for(; *s; s++)
 768:	02800593          	li	a1,40
 76c:	b7c5                	j	74c <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 76e:	8bce                	mv	s7,s3
      state = 0;
 770:	4981                	li	s3,0
 772:	b3d1                	j	536 <vprintf+0x4c>
    }
  }
}
 774:	60e6                	ld	ra,88(sp)
 776:	6446                	ld	s0,80(sp)
 778:	64a6                	ld	s1,72(sp)
 77a:	6906                	ld	s2,64(sp)
 77c:	79e2                	ld	s3,56(sp)
 77e:	7a42                	ld	s4,48(sp)
 780:	7aa2                	ld	s5,40(sp)
 782:	7b02                	ld	s6,32(sp)
 784:	6be2                	ld	s7,24(sp)
 786:	6c42                	ld	s8,16(sp)
 788:	6ca2                	ld	s9,8(sp)
 78a:	6d02                	ld	s10,0(sp)
 78c:	6125                	add	sp,sp,96
 78e:	8082                	ret

0000000000000790 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 790:	715d                	add	sp,sp,-80
 792:	ec06                	sd	ra,24(sp)
 794:	e822                	sd	s0,16(sp)
 796:	1000                	add	s0,sp,32
 798:	e010                	sd	a2,0(s0)
 79a:	e414                	sd	a3,8(s0)
 79c:	e818                	sd	a4,16(s0)
 79e:	ec1c                	sd	a5,24(s0)
 7a0:	03043023          	sd	a6,32(s0)
 7a4:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7a8:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7ac:	8622                	mv	a2,s0
 7ae:	d3dff0ef          	jal	4ea <vprintf>
}
 7b2:	60e2                	ld	ra,24(sp)
 7b4:	6442                	ld	s0,16(sp)
 7b6:	6161                	add	sp,sp,80
 7b8:	8082                	ret

00000000000007ba <printf>:

void
printf(const char *fmt, ...)
{
 7ba:	711d                	add	sp,sp,-96
 7bc:	ec06                	sd	ra,24(sp)
 7be:	e822                	sd	s0,16(sp)
 7c0:	1000                	add	s0,sp,32
 7c2:	e40c                	sd	a1,8(s0)
 7c4:	e810                	sd	a2,16(s0)
 7c6:	ec14                	sd	a3,24(s0)
 7c8:	f018                	sd	a4,32(s0)
 7ca:	f41c                	sd	a5,40(s0)
 7cc:	03043823          	sd	a6,48(s0)
 7d0:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7d4:	00840613          	add	a2,s0,8
 7d8:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7dc:	85aa                	mv	a1,a0
 7de:	4505                	li	a0,1
 7e0:	d0bff0ef          	jal	4ea <vprintf>
}
 7e4:	60e2                	ld	ra,24(sp)
 7e6:	6442                	ld	s0,16(sp)
 7e8:	6125                	add	sp,sp,96
 7ea:	8082                	ret

00000000000007ec <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7ec:	1141                	add	sp,sp,-16
 7ee:	e422                	sd	s0,8(sp)
 7f0:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7f2:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7f6:	00001797          	auipc	a5,0x1
 7fa:	80a7b783          	ld	a5,-2038(a5) # 1000 <freep>
 7fe:	a02d                	j	828 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 800:	4618                	lw	a4,8(a2)
 802:	9f2d                	addw	a4,a4,a1
 804:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 808:	6398                	ld	a4,0(a5)
 80a:	6310                	ld	a2,0(a4)
 80c:	a83d                	j	84a <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 80e:	ff852703          	lw	a4,-8(a0)
 812:	9f31                	addw	a4,a4,a2
 814:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 816:	ff053683          	ld	a3,-16(a0)
 81a:	a091                	j	85e <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 81c:	6398                	ld	a4,0(a5)
 81e:	00e7e463          	bltu	a5,a4,826 <free+0x3a>
 822:	00e6ea63          	bltu	a3,a4,836 <free+0x4a>
{
 826:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 828:	fed7fae3          	bgeu	a5,a3,81c <free+0x30>
 82c:	6398                	ld	a4,0(a5)
 82e:	00e6e463          	bltu	a3,a4,836 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 832:	fee7eae3          	bltu	a5,a4,826 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 836:	ff852583          	lw	a1,-8(a0)
 83a:	6390                	ld	a2,0(a5)
 83c:	02059813          	sll	a6,a1,0x20
 840:	01c85713          	srl	a4,a6,0x1c
 844:	9736                	add	a4,a4,a3
 846:	fae60de3          	beq	a2,a4,800 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 84a:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 84e:	4790                	lw	a2,8(a5)
 850:	02061593          	sll	a1,a2,0x20
 854:	01c5d713          	srl	a4,a1,0x1c
 858:	973e                	add	a4,a4,a5
 85a:	fae68ae3          	beq	a3,a4,80e <free+0x22>
    p->s.ptr = bp->s.ptr;
 85e:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 860:	00000717          	auipc	a4,0x0
 864:	7af73023          	sd	a5,1952(a4) # 1000 <freep>
}
 868:	6422                	ld	s0,8(sp)
 86a:	0141                	add	sp,sp,16
 86c:	8082                	ret

000000000000086e <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 86e:	7139                	add	sp,sp,-64
 870:	fc06                	sd	ra,56(sp)
 872:	f822                	sd	s0,48(sp)
 874:	f426                	sd	s1,40(sp)
 876:	f04a                	sd	s2,32(sp)
 878:	ec4e                	sd	s3,24(sp)
 87a:	e852                	sd	s4,16(sp)
 87c:	e456                	sd	s5,8(sp)
 87e:	e05a                	sd	s6,0(sp)
 880:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 882:	02051493          	sll	s1,a0,0x20
 886:	9081                	srl	s1,s1,0x20
 888:	04bd                	add	s1,s1,15
 88a:	8091                	srl	s1,s1,0x4
 88c:	0014899b          	addw	s3,s1,1
 890:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 892:	00000517          	auipc	a0,0x0
 896:	76e53503          	ld	a0,1902(a0) # 1000 <freep>
 89a:	c515                	beqz	a0,8c6 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 89c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 89e:	4798                	lw	a4,8(a5)
 8a0:	02977f63          	bgeu	a4,s1,8de <malloc+0x70>
  if(nu < 4096)
 8a4:	8a4e                	mv	s4,s3
 8a6:	0009871b          	sext.w	a4,s3
 8aa:	6685                	lui	a3,0x1
 8ac:	00d77363          	bgeu	a4,a3,8b2 <malloc+0x44>
 8b0:	6a05                	lui	s4,0x1
 8b2:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8b6:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8ba:	00000917          	auipc	s2,0x0
 8be:	74690913          	add	s2,s2,1862 # 1000 <freep>
  if(p == SBRK_ERROR)
 8c2:	5afd                	li	s5,-1
 8c4:	a885                	j	934 <malloc+0xc6>
    base.s.ptr = freep = prevp = &base;
 8c6:	00001797          	auipc	a5,0x1
 8ca:	94a78793          	add	a5,a5,-1718 # 1210 <base>
 8ce:	00000717          	auipc	a4,0x0
 8d2:	72f73923          	sd	a5,1842(a4) # 1000 <freep>
 8d6:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8d8:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8dc:	b7e1                	j	8a4 <malloc+0x36>
      if(p->s.size == nunits)
 8de:	02e48c63          	beq	s1,a4,916 <malloc+0xa8>
        p->s.size -= nunits;
 8e2:	4137073b          	subw	a4,a4,s3
 8e6:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8e8:	02071693          	sll	a3,a4,0x20
 8ec:	01c6d713          	srl	a4,a3,0x1c
 8f0:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8f2:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8f6:	00000717          	auipc	a4,0x0
 8fa:	70a73523          	sd	a0,1802(a4) # 1000 <freep>
      return (void*)(p + 1);
 8fe:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 902:	70e2                	ld	ra,56(sp)
 904:	7442                	ld	s0,48(sp)
 906:	74a2                	ld	s1,40(sp)
 908:	7902                	ld	s2,32(sp)
 90a:	69e2                	ld	s3,24(sp)
 90c:	6a42                	ld	s4,16(sp)
 90e:	6aa2                	ld	s5,8(sp)
 910:	6b02                	ld	s6,0(sp)
 912:	6121                	add	sp,sp,64
 914:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 916:	6398                	ld	a4,0(a5)
 918:	e118                	sd	a4,0(a0)
 91a:	bff1                	j	8f6 <malloc+0x88>
  hp->s.size = nu;
 91c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 920:	0541                	add	a0,a0,16
 922:	ecbff0ef          	jal	7ec <free>
  return freep;
 926:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 92a:	dd61                	beqz	a0,902 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 92c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 92e:	4798                	lw	a4,8(a5)
 930:	fa9777e3          	bgeu	a4,s1,8de <malloc+0x70>
    if(p == freep)
 934:	00093703          	ld	a4,0(s2)
 938:	853e                	mv	a0,a5
 93a:	fef719e3          	bne	a4,a5,92c <malloc+0xbe>
  p = sbrk(nu * sizeof(Header));
 93e:	8552                	mv	a0,s4
 940:	a05ff0ef          	jal	344 <sbrk>
  if(p == SBRK_ERROR)
 944:	fd551ce3          	bne	a0,s5,91c <malloc+0xae>
        return 0;
 948:	4501                	li	a0,0
 94a:	bf65                	j	902 <malloc+0x94>
