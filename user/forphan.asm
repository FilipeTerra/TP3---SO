
user/_forphan:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:

char buf[BUFSZ];

int
main(int argc, char **argv)
{
   0:	7139                	add	sp,sp,-64
   2:	fc06                	sd	ra,56(sp)
   4:	f822                	sd	s0,48(sp)
   6:	f426                	sd	s1,40(sp)
   8:	0080                	add	s0,sp,64
  int fd = 0;
  char *s = argv[0];
   a:	6184                	ld	s1,0(a1)
  struct stat st;
  char *ff = "file0";
  
  if ((fd = open(ff, O_CREATE|O_WRONLY)) < 0) {
   c:	20100593          	li	a1,513
  10:	00001517          	auipc	a0,0x1
  14:	92050513          	add	a0,a0,-1760 # 930 <malloc+0xe2>
  18:	380000ef          	jal	398 <open>
  1c:	04054463          	bltz	a0,64 <main+0x64>
    printf("%s: open failed\n", s);
    exit(1);
  }
  if(fstat(fd, &st) < 0){
  20:	fc840593          	add	a1,s0,-56
  24:	38c000ef          	jal	3b0 <fstat>
  28:	04054863          	bltz	a0,78 <main+0x78>
    fprintf(2, "%s: cannot stat %s\n", s, "ff");
    exit(1);
  }
  if (unlink(ff) < 0) {
  2c:	00001517          	auipc	a0,0x1
  30:	90450513          	add	a0,a0,-1788 # 930 <malloc+0xe2>
  34:	374000ef          	jal	3a8 <unlink>
  38:	04054f63          	bltz	a0,96 <main+0x96>
    printf("%s: unlink failed\n", s);
    exit(1);
  }
  if (open(ff, O_RDONLY) != -1) {
  3c:	4581                	li	a1,0
  3e:	00001517          	auipc	a0,0x1
  42:	8f250513          	add	a0,a0,-1806 # 930 <malloc+0xe2>
  46:	352000ef          	jal	398 <open>
  4a:	57fd                	li	a5,-1
  4c:	04f50f63          	beq	a0,a5,aa <main+0xaa>
    printf("%s: open successed\n", s);
  50:	85a6                	mv	a1,s1
  52:	00001517          	auipc	a0,0x1
  56:	93650513          	add	a0,a0,-1738 # 988 <malloc+0x13a>
  5a:	740000ef          	jal	79a <printf>
    exit(1);
  5e:	4505                	li	a0,1
  60:	2f8000ef          	jal	358 <exit>
    printf("%s: open failed\n", s);
  64:	85a6                	mv	a1,s1
  66:	00001517          	auipc	a0,0x1
  6a:	8d250513          	add	a0,a0,-1838 # 938 <malloc+0xea>
  6e:	72c000ef          	jal	79a <printf>
    exit(1);
  72:	4505                	li	a0,1
  74:	2e4000ef          	jal	358 <exit>
    fprintf(2, "%s: cannot stat %s\n", s, "ff");
  78:	00001697          	auipc	a3,0x1
  7c:	8d868693          	add	a3,a3,-1832 # 950 <malloc+0x102>
  80:	8626                	mv	a2,s1
  82:	00001597          	auipc	a1,0x1
  86:	8d658593          	add	a1,a1,-1834 # 958 <malloc+0x10a>
  8a:	4509                	li	a0,2
  8c:	6e4000ef          	jal	770 <fprintf>
    exit(1);
  90:	4505                	li	a0,1
  92:	2c6000ef          	jal	358 <exit>
    printf("%s: unlink failed\n", s);
  96:	85a6                	mv	a1,s1
  98:	00001517          	auipc	a0,0x1
  9c:	8d850513          	add	a0,a0,-1832 # 970 <malloc+0x122>
  a0:	6fa000ef          	jal	79a <printf>
    exit(1);
  a4:	4505                	li	a0,1
  a6:	2b2000ef          	jal	358 <exit>
  }
  printf("wait for kill and reclaim %d\n", st.ino);
  aa:	fcc42583          	lw	a1,-52(s0)
  ae:	00001517          	auipc	a0,0x1
  b2:	8f250513          	add	a0,a0,-1806 # 9a0 <malloc+0x152>
  b6:	6e4000ef          	jal	79a <printf>
  // sit around until killed
  for(;;) pause(1000);
  ba:	3e800513          	li	a0,1000
  be:	32a000ef          	jal	3e8 <pause>
  c2:	bfe5                	j	ba <main+0xba>

00000000000000c4 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  c4:	1141                	add	sp,sp,-16
  c6:	e406                	sd	ra,8(sp)
  c8:	e022                	sd	s0,0(sp)
  ca:	0800                	add	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  cc:	f35ff0ef          	jal	0 <main>
  exit(r);
  d0:	288000ef          	jal	358 <exit>

00000000000000d4 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  d4:	1141                	add	sp,sp,-16
  d6:	e422                	sd	s0,8(sp)
  d8:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  da:	87aa                	mv	a5,a0
  dc:	0585                	add	a1,a1,1
  de:	0785                	add	a5,a5,1
  e0:	fff5c703          	lbu	a4,-1(a1)
  e4:	fee78fa3          	sb	a4,-1(a5)
  e8:	fb75                	bnez	a4,dc <strcpy+0x8>
    ;
  return os;
}
  ea:	6422                	ld	s0,8(sp)
  ec:	0141                	add	sp,sp,16
  ee:	8082                	ret

00000000000000f0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  f0:	1141                	add	sp,sp,-16
  f2:	e422                	sd	s0,8(sp)
  f4:	0800                	add	s0,sp,16
  while(*p && *p == *q)
  f6:	00054783          	lbu	a5,0(a0)
  fa:	cb91                	beqz	a5,10e <strcmp+0x1e>
  fc:	0005c703          	lbu	a4,0(a1)
 100:	00f71763          	bne	a4,a5,10e <strcmp+0x1e>
    p++, q++;
 104:	0505                	add	a0,a0,1
 106:	0585                	add	a1,a1,1
  while(*p && *p == *q)
 108:	00054783          	lbu	a5,0(a0)
 10c:	fbe5                	bnez	a5,fc <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 10e:	0005c503          	lbu	a0,0(a1)
}
 112:	40a7853b          	subw	a0,a5,a0
 116:	6422                	ld	s0,8(sp)
 118:	0141                	add	sp,sp,16
 11a:	8082                	ret

000000000000011c <strlen>:

uint
strlen(const char *s)
{
 11c:	1141                	add	sp,sp,-16
 11e:	e422                	sd	s0,8(sp)
 120:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 122:	00054783          	lbu	a5,0(a0)
 126:	cf91                	beqz	a5,142 <strlen+0x26>
 128:	0505                	add	a0,a0,1
 12a:	87aa                	mv	a5,a0
 12c:	86be                	mv	a3,a5
 12e:	0785                	add	a5,a5,1
 130:	fff7c703          	lbu	a4,-1(a5)
 134:	ff65                	bnez	a4,12c <strlen+0x10>
 136:	40a6853b          	subw	a0,a3,a0
 13a:	2505                	addw	a0,a0,1
    ;
  return n;
}
 13c:	6422                	ld	s0,8(sp)
 13e:	0141                	add	sp,sp,16
 140:	8082                	ret
  for(n = 0; s[n]; n++)
 142:	4501                	li	a0,0
 144:	bfe5                	j	13c <strlen+0x20>

0000000000000146 <memset>:

void*
memset(void *dst, int c, uint n)
{
 146:	1141                	add	sp,sp,-16
 148:	e422                	sd	s0,8(sp)
 14a:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 14c:	ca19                	beqz	a2,162 <memset+0x1c>
 14e:	87aa                	mv	a5,a0
 150:	1602                	sll	a2,a2,0x20
 152:	9201                	srl	a2,a2,0x20
 154:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 158:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 15c:	0785                	add	a5,a5,1
 15e:	fee79de3          	bne	a5,a4,158 <memset+0x12>
  }
  return dst;
}
 162:	6422                	ld	s0,8(sp)
 164:	0141                	add	sp,sp,16
 166:	8082                	ret

0000000000000168 <strchr>:

char*
strchr(const char *s, char c)
{
 168:	1141                	add	sp,sp,-16
 16a:	e422                	sd	s0,8(sp)
 16c:	0800                	add	s0,sp,16
  for(; *s; s++)
 16e:	00054783          	lbu	a5,0(a0)
 172:	cb99                	beqz	a5,188 <strchr+0x20>
    if(*s == c)
 174:	00f58763          	beq	a1,a5,182 <strchr+0x1a>
  for(; *s; s++)
 178:	0505                	add	a0,a0,1
 17a:	00054783          	lbu	a5,0(a0)
 17e:	fbfd                	bnez	a5,174 <strchr+0xc>
      return (char*)s;
  return 0;
 180:	4501                	li	a0,0
}
 182:	6422                	ld	s0,8(sp)
 184:	0141                	add	sp,sp,16
 186:	8082                	ret
  return 0;
 188:	4501                	li	a0,0
 18a:	bfe5                	j	182 <strchr+0x1a>

000000000000018c <gets>:

char*
gets(char *buf, int max)
{
 18c:	711d                	add	sp,sp,-96
 18e:	ec86                	sd	ra,88(sp)
 190:	e8a2                	sd	s0,80(sp)
 192:	e4a6                	sd	s1,72(sp)
 194:	e0ca                	sd	s2,64(sp)
 196:	fc4e                	sd	s3,56(sp)
 198:	f852                	sd	s4,48(sp)
 19a:	f456                	sd	s5,40(sp)
 19c:	f05a                	sd	s6,32(sp)
 19e:	ec5e                	sd	s7,24(sp)
 1a0:	1080                	add	s0,sp,96
 1a2:	8baa                	mv	s7,a0
 1a4:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1a6:	892a                	mv	s2,a0
 1a8:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1aa:	4aa9                	li	s5,10
 1ac:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1ae:	89a6                	mv	s3,s1
 1b0:	2485                	addw	s1,s1,1
 1b2:	0344d663          	bge	s1,s4,1de <gets+0x52>
    cc = read(0, &c, 1);
 1b6:	4605                	li	a2,1
 1b8:	faf40593          	add	a1,s0,-81
 1bc:	4501                	li	a0,0
 1be:	1b2000ef          	jal	370 <read>
    if(cc < 1)
 1c2:	00a05e63          	blez	a0,1de <gets+0x52>
    buf[i++] = c;
 1c6:	faf44783          	lbu	a5,-81(s0)
 1ca:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1ce:	01578763          	beq	a5,s5,1dc <gets+0x50>
 1d2:	0905                	add	s2,s2,1
 1d4:	fd679de3          	bne	a5,s6,1ae <gets+0x22>
  for(i=0; i+1 < max; ){
 1d8:	89a6                	mv	s3,s1
 1da:	a011                	j	1de <gets+0x52>
 1dc:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 1de:	99de                	add	s3,s3,s7
 1e0:	00098023          	sb	zero,0(s3)
  return buf;
}
 1e4:	855e                	mv	a0,s7
 1e6:	60e6                	ld	ra,88(sp)
 1e8:	6446                	ld	s0,80(sp)
 1ea:	64a6                	ld	s1,72(sp)
 1ec:	6906                	ld	s2,64(sp)
 1ee:	79e2                	ld	s3,56(sp)
 1f0:	7a42                	ld	s4,48(sp)
 1f2:	7aa2                	ld	s5,40(sp)
 1f4:	7b02                	ld	s6,32(sp)
 1f6:	6be2                	ld	s7,24(sp)
 1f8:	6125                	add	sp,sp,96
 1fa:	8082                	ret

00000000000001fc <stat>:

int
stat(const char *n, struct stat *st)
{
 1fc:	1101                	add	sp,sp,-32
 1fe:	ec06                	sd	ra,24(sp)
 200:	e822                	sd	s0,16(sp)
 202:	e426                	sd	s1,8(sp)
 204:	e04a                	sd	s2,0(sp)
 206:	1000                	add	s0,sp,32
 208:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 20a:	4581                	li	a1,0
 20c:	18c000ef          	jal	398 <open>
  if(fd < 0)
 210:	02054163          	bltz	a0,232 <stat+0x36>
 214:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 216:	85ca                	mv	a1,s2
 218:	198000ef          	jal	3b0 <fstat>
 21c:	892a                	mv	s2,a0
  close(fd);
 21e:	8526                	mv	a0,s1
 220:	160000ef          	jal	380 <close>
  return r;
}
 224:	854a                	mv	a0,s2
 226:	60e2                	ld	ra,24(sp)
 228:	6442                	ld	s0,16(sp)
 22a:	64a2                	ld	s1,8(sp)
 22c:	6902                	ld	s2,0(sp)
 22e:	6105                	add	sp,sp,32
 230:	8082                	ret
    return -1;
 232:	597d                	li	s2,-1
 234:	bfc5                	j	224 <stat+0x28>

0000000000000236 <atoi>:

int
atoi(const char *s)
{
 236:	1141                	add	sp,sp,-16
 238:	e422                	sd	s0,8(sp)
 23a:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 23c:	00054683          	lbu	a3,0(a0)
 240:	fd06879b          	addw	a5,a3,-48
 244:	0ff7f793          	zext.b	a5,a5
 248:	4625                	li	a2,9
 24a:	02f66863          	bltu	a2,a5,27a <atoi+0x44>
 24e:	872a                	mv	a4,a0
  n = 0;
 250:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 252:	0705                	add	a4,a4,1
 254:	0025179b          	sllw	a5,a0,0x2
 258:	9fa9                	addw	a5,a5,a0
 25a:	0017979b          	sllw	a5,a5,0x1
 25e:	9fb5                	addw	a5,a5,a3
 260:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 264:	00074683          	lbu	a3,0(a4)
 268:	fd06879b          	addw	a5,a3,-48
 26c:	0ff7f793          	zext.b	a5,a5
 270:	fef671e3          	bgeu	a2,a5,252 <atoi+0x1c>
  return n;
}
 274:	6422                	ld	s0,8(sp)
 276:	0141                	add	sp,sp,16
 278:	8082                	ret
  n = 0;
 27a:	4501                	li	a0,0
 27c:	bfe5                	j	274 <atoi+0x3e>

000000000000027e <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 27e:	1141                	add	sp,sp,-16
 280:	e422                	sd	s0,8(sp)
 282:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 284:	02b57463          	bgeu	a0,a1,2ac <memmove+0x2e>
    while(n-- > 0)
 288:	00c05f63          	blez	a2,2a6 <memmove+0x28>
 28c:	1602                	sll	a2,a2,0x20
 28e:	9201                	srl	a2,a2,0x20
 290:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 294:	872a                	mv	a4,a0
      *dst++ = *src++;
 296:	0585                	add	a1,a1,1
 298:	0705                	add	a4,a4,1
 29a:	fff5c683          	lbu	a3,-1(a1)
 29e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2a2:	fee79ae3          	bne	a5,a4,296 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2a6:	6422                	ld	s0,8(sp)
 2a8:	0141                	add	sp,sp,16
 2aa:	8082                	ret
    dst += n;
 2ac:	00c50733          	add	a4,a0,a2
    src += n;
 2b0:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2b2:	fec05ae3          	blez	a2,2a6 <memmove+0x28>
 2b6:	fff6079b          	addw	a5,a2,-1
 2ba:	1782                	sll	a5,a5,0x20
 2bc:	9381                	srl	a5,a5,0x20
 2be:	fff7c793          	not	a5,a5
 2c2:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2c4:	15fd                	add	a1,a1,-1
 2c6:	177d                	add	a4,a4,-1
 2c8:	0005c683          	lbu	a3,0(a1)
 2cc:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2d0:	fee79ae3          	bne	a5,a4,2c4 <memmove+0x46>
 2d4:	bfc9                	j	2a6 <memmove+0x28>

00000000000002d6 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2d6:	1141                	add	sp,sp,-16
 2d8:	e422                	sd	s0,8(sp)
 2da:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2dc:	ca05                	beqz	a2,30c <memcmp+0x36>
 2de:	fff6069b          	addw	a3,a2,-1
 2e2:	1682                	sll	a3,a3,0x20
 2e4:	9281                	srl	a3,a3,0x20
 2e6:	0685                	add	a3,a3,1
 2e8:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2ea:	00054783          	lbu	a5,0(a0)
 2ee:	0005c703          	lbu	a4,0(a1)
 2f2:	00e79863          	bne	a5,a4,302 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 2f6:	0505                	add	a0,a0,1
    p2++;
 2f8:	0585                	add	a1,a1,1
  while (n-- > 0) {
 2fa:	fed518e3          	bne	a0,a3,2ea <memcmp+0x14>
  }
  return 0;
 2fe:	4501                	li	a0,0
 300:	a019                	j	306 <memcmp+0x30>
      return *p1 - *p2;
 302:	40e7853b          	subw	a0,a5,a4
}
 306:	6422                	ld	s0,8(sp)
 308:	0141                	add	sp,sp,16
 30a:	8082                	ret
  return 0;
 30c:	4501                	li	a0,0
 30e:	bfe5                	j	306 <memcmp+0x30>

0000000000000310 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 310:	1141                	add	sp,sp,-16
 312:	e406                	sd	ra,8(sp)
 314:	e022                	sd	s0,0(sp)
 316:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 318:	f67ff0ef          	jal	27e <memmove>
}
 31c:	60a2                	ld	ra,8(sp)
 31e:	6402                	ld	s0,0(sp)
 320:	0141                	add	sp,sp,16
 322:	8082                	ret

0000000000000324 <sbrk>:

char *
sbrk(int n) {
 324:	1141                	add	sp,sp,-16
 326:	e406                	sd	ra,8(sp)
 328:	e022                	sd	s0,0(sp)
 32a:	0800                	add	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 32c:	4585                	li	a1,1
 32e:	0b2000ef          	jal	3e0 <sys_sbrk>
}
 332:	60a2                	ld	ra,8(sp)
 334:	6402                	ld	s0,0(sp)
 336:	0141                	add	sp,sp,16
 338:	8082                	ret

000000000000033a <sbrklazy>:

char *
sbrklazy(int n) {
 33a:	1141                	add	sp,sp,-16
 33c:	e406                	sd	ra,8(sp)
 33e:	e022                	sd	s0,0(sp)
 340:	0800                	add	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 342:	4589                	li	a1,2
 344:	09c000ef          	jal	3e0 <sys_sbrk>
}
 348:	60a2                	ld	ra,8(sp)
 34a:	6402                	ld	s0,0(sp)
 34c:	0141                	add	sp,sp,16
 34e:	8082                	ret

0000000000000350 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 350:	4885                	li	a7,1
 ecall
 352:	00000073          	ecall
 ret
 356:	8082                	ret

0000000000000358 <exit>:
.global exit
exit:
 li a7, SYS_exit
 358:	4889                	li	a7,2
 ecall
 35a:	00000073          	ecall
 ret
 35e:	8082                	ret

0000000000000360 <wait>:
.global wait
wait:
 li a7, SYS_wait
 360:	488d                	li	a7,3
 ecall
 362:	00000073          	ecall
 ret
 366:	8082                	ret

0000000000000368 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 368:	4891                	li	a7,4
 ecall
 36a:	00000073          	ecall
 ret
 36e:	8082                	ret

0000000000000370 <read>:
.global read
read:
 li a7, SYS_read
 370:	4895                	li	a7,5
 ecall
 372:	00000073          	ecall
 ret
 376:	8082                	ret

0000000000000378 <write>:
.global write
write:
 li a7, SYS_write
 378:	48c1                	li	a7,16
 ecall
 37a:	00000073          	ecall
 ret
 37e:	8082                	ret

0000000000000380 <close>:
.global close
close:
 li a7, SYS_close
 380:	48d5                	li	a7,21
 ecall
 382:	00000073          	ecall
 ret
 386:	8082                	ret

0000000000000388 <kill>:
.global kill
kill:
 li a7, SYS_kill
 388:	4899                	li	a7,6
 ecall
 38a:	00000073          	ecall
 ret
 38e:	8082                	ret

0000000000000390 <exec>:
.global exec
exec:
 li a7, SYS_exec
 390:	489d                	li	a7,7
 ecall
 392:	00000073          	ecall
 ret
 396:	8082                	ret

0000000000000398 <open>:
.global open
open:
 li a7, SYS_open
 398:	48bd                	li	a7,15
 ecall
 39a:	00000073          	ecall
 ret
 39e:	8082                	ret

00000000000003a0 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3a0:	48c5                	li	a7,17
 ecall
 3a2:	00000073          	ecall
 ret
 3a6:	8082                	ret

00000000000003a8 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3a8:	48c9                	li	a7,18
 ecall
 3aa:	00000073          	ecall
 ret
 3ae:	8082                	ret

00000000000003b0 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3b0:	48a1                	li	a7,8
 ecall
 3b2:	00000073          	ecall
 ret
 3b6:	8082                	ret

00000000000003b8 <link>:
.global link
link:
 li a7, SYS_link
 3b8:	48cd                	li	a7,19
 ecall
 3ba:	00000073          	ecall
 ret
 3be:	8082                	ret

00000000000003c0 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3c0:	48d1                	li	a7,20
 ecall
 3c2:	00000073          	ecall
 ret
 3c6:	8082                	ret

00000000000003c8 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3c8:	48a5                	li	a7,9
 ecall
 3ca:	00000073          	ecall
 ret
 3ce:	8082                	ret

00000000000003d0 <dup>:
.global dup
dup:
 li a7, SYS_dup
 3d0:	48a9                	li	a7,10
 ecall
 3d2:	00000073          	ecall
 ret
 3d6:	8082                	ret

00000000000003d8 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3d8:	48ad                	li	a7,11
 ecall
 3da:	00000073          	ecall
 ret
 3de:	8082                	ret

00000000000003e0 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 3e0:	48b1                	li	a7,12
 ecall
 3e2:	00000073          	ecall
 ret
 3e6:	8082                	ret

00000000000003e8 <pause>:
.global pause
pause:
 li a7, SYS_pause
 3e8:	48b5                	li	a7,13
 ecall
 3ea:	00000073          	ecall
 ret
 3ee:	8082                	ret

00000000000003f0 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3f0:	48b9                	li	a7,14
 ecall
 3f2:	00000073          	ecall
 ret
 3f6:	8082                	ret

00000000000003f8 <getcnt>:
.global getcnt
getcnt:
 li a7, SYS_getcnt
 3f8:	48d9                	li	a7,22
 ecall
 3fa:	00000073          	ecall
 ret
 3fe:	8082                	ret

0000000000000400 <settickets>:
.global settickets
settickets:
 li a7, SYS_settickets
 400:	48dd                	li	a7,23
 ecall
 402:	00000073          	ecall
 ret
 406:	8082                	ret

0000000000000408 <getpinfo>:
.global getpinfo
getpinfo:
 li a7, SYS_getpinfo
 408:	48e1                	li	a7,24
 ecall
 40a:	00000073          	ecall
 ret
 40e:	8082                	ret

0000000000000410 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 410:	1101                	add	sp,sp,-32
 412:	ec06                	sd	ra,24(sp)
 414:	e822                	sd	s0,16(sp)
 416:	1000                	add	s0,sp,32
 418:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 41c:	4605                	li	a2,1
 41e:	fef40593          	add	a1,s0,-17
 422:	f57ff0ef          	jal	378 <write>
}
 426:	60e2                	ld	ra,24(sp)
 428:	6442                	ld	s0,16(sp)
 42a:	6105                	add	sp,sp,32
 42c:	8082                	ret

000000000000042e <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 42e:	715d                	add	sp,sp,-80
 430:	e486                	sd	ra,72(sp)
 432:	e0a2                	sd	s0,64(sp)
 434:	fc26                	sd	s1,56(sp)
 436:	f84a                	sd	s2,48(sp)
 438:	f44e                	sd	s3,40(sp)
 43a:	0880                	add	s0,sp,80
 43c:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 43e:	c299                	beqz	a3,444 <printint+0x16>
 440:	0805c163          	bltz	a1,4c2 <printint+0x94>
  neg = 0;
 444:	4881                	li	a7,0
 446:	fb840693          	add	a3,s0,-72
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 44a:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 44c:	00000517          	auipc	a0,0x0
 450:	57c50513          	add	a0,a0,1404 # 9c8 <digits>
 454:	883e                	mv	a6,a5
 456:	2785                	addw	a5,a5,1
 458:	02c5f733          	remu	a4,a1,a2
 45c:	972a                	add	a4,a4,a0
 45e:	00074703          	lbu	a4,0(a4)
 462:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 466:	872e                	mv	a4,a1
 468:	02c5d5b3          	divu	a1,a1,a2
 46c:	0685                	add	a3,a3,1
 46e:	fec773e3          	bgeu	a4,a2,454 <printint+0x26>
  if(neg)
 472:	00088b63          	beqz	a7,488 <printint+0x5a>
    buf[i++] = '-';
 476:	fd078793          	add	a5,a5,-48
 47a:	97a2                	add	a5,a5,s0
 47c:	02d00713          	li	a4,45
 480:	fee78423          	sb	a4,-24(a5)
 484:	0028079b          	addw	a5,a6,2

  while(--i >= 0)
 488:	02f05663          	blez	a5,4b4 <printint+0x86>
 48c:	fb840713          	add	a4,s0,-72
 490:	00f704b3          	add	s1,a4,a5
 494:	fff70993          	add	s3,a4,-1
 498:	99be                	add	s3,s3,a5
 49a:	37fd                	addw	a5,a5,-1
 49c:	1782                	sll	a5,a5,0x20
 49e:	9381                	srl	a5,a5,0x20
 4a0:	40f989b3          	sub	s3,s3,a5
    putc(fd, buf[i]);
 4a4:	fff4c583          	lbu	a1,-1(s1)
 4a8:	854a                	mv	a0,s2
 4aa:	f67ff0ef          	jal	410 <putc>
  while(--i >= 0)
 4ae:	14fd                	add	s1,s1,-1
 4b0:	ff349ae3          	bne	s1,s3,4a4 <printint+0x76>
}
 4b4:	60a6                	ld	ra,72(sp)
 4b6:	6406                	ld	s0,64(sp)
 4b8:	74e2                	ld	s1,56(sp)
 4ba:	7942                	ld	s2,48(sp)
 4bc:	79a2                	ld	s3,40(sp)
 4be:	6161                	add	sp,sp,80
 4c0:	8082                	ret
    x = -xx;
 4c2:	40b005b3          	neg	a1,a1
    neg = 1;
 4c6:	4885                	li	a7,1
    x = -xx;
 4c8:	bfbd                	j	446 <printint+0x18>

00000000000004ca <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4ca:	711d                	add	sp,sp,-96
 4cc:	ec86                	sd	ra,88(sp)
 4ce:	e8a2                	sd	s0,80(sp)
 4d0:	e4a6                	sd	s1,72(sp)
 4d2:	e0ca                	sd	s2,64(sp)
 4d4:	fc4e                	sd	s3,56(sp)
 4d6:	f852                	sd	s4,48(sp)
 4d8:	f456                	sd	s5,40(sp)
 4da:	f05a                	sd	s6,32(sp)
 4dc:	ec5e                	sd	s7,24(sp)
 4de:	e862                	sd	s8,16(sp)
 4e0:	e466                	sd	s9,8(sp)
 4e2:	e06a                	sd	s10,0(sp)
 4e4:	1080                	add	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4e6:	0005c903          	lbu	s2,0(a1)
 4ea:	26090563          	beqz	s2,754 <vprintf+0x28a>
 4ee:	8b2a                	mv	s6,a0
 4f0:	8a2e                	mv	s4,a1
 4f2:	8bb2                	mv	s7,a2
  state = 0;
 4f4:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 4f6:	4481                	li	s1,0
 4f8:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 4fa:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 4fe:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 502:	06c00c93          	li	s9,108
 506:	a005                	j	526 <vprintf+0x5c>
        putc(fd, c0);
 508:	85ca                	mv	a1,s2
 50a:	855a                	mv	a0,s6
 50c:	f05ff0ef          	jal	410 <putc>
 510:	a019                	j	516 <vprintf+0x4c>
    } else if(state == '%'){
 512:	03598263          	beq	s3,s5,536 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 516:	2485                	addw	s1,s1,1
 518:	8726                	mv	a4,s1
 51a:	009a07b3          	add	a5,s4,s1
 51e:	0007c903          	lbu	s2,0(a5)
 522:	22090963          	beqz	s2,754 <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
 526:	0009079b          	sext.w	a5,s2
    if(state == 0){
 52a:	fe0994e3          	bnez	s3,512 <vprintf+0x48>
      if(c0 == '%'){
 52e:	fd579de3          	bne	a5,s5,508 <vprintf+0x3e>
        state = '%';
 532:	89be                	mv	s3,a5
 534:	b7cd                	j	516 <vprintf+0x4c>
      if(c0) c1 = fmt[i+1] & 0xff;
 536:	cbc9                	beqz	a5,5c8 <vprintf+0xfe>
 538:	00ea06b3          	add	a3,s4,a4
 53c:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 540:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 542:	c681                	beqz	a3,54a <vprintf+0x80>
 544:	9752                	add	a4,a4,s4
 546:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 54a:	05878363          	beq	a5,s8,590 <vprintf+0xc6>
      } else if(c0 == 'l' && c1 == 'd'){
 54e:	05978d63          	beq	a5,s9,5a8 <vprintf+0xde>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 552:	07500713          	li	a4,117
 556:	0ee78763          	beq	a5,a4,644 <vprintf+0x17a>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 55a:	07800713          	li	a4,120
 55e:	12e78963          	beq	a5,a4,690 <vprintf+0x1c6>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 562:	07000713          	li	a4,112
 566:	14e78e63          	beq	a5,a4,6c2 <vprintf+0x1f8>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 56a:	06300713          	li	a4,99
 56e:	18e78c63          	beq	a5,a4,706 <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 572:	07300713          	li	a4,115
 576:	1ae78263          	beq	a5,a4,71a <vprintf+0x250>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 57a:	02500713          	li	a4,37
 57e:	04e79563          	bne	a5,a4,5c8 <vprintf+0xfe>
        putc(fd, '%');
 582:	02500593          	li	a1,37
 586:	855a                	mv	a0,s6
 588:	e89ff0ef          	jal	410 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 58c:	4981                	li	s3,0
 58e:	b761                	j	516 <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 10, 1);
 590:	008b8913          	add	s2,s7,8
 594:	4685                	li	a3,1
 596:	4629                	li	a2,10
 598:	000ba583          	lw	a1,0(s7)
 59c:	855a                	mv	a0,s6
 59e:	e91ff0ef          	jal	42e <printint>
 5a2:	8bca                	mv	s7,s2
      state = 0;
 5a4:	4981                	li	s3,0
 5a6:	bf85                	j	516 <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'd'){
 5a8:	06400793          	li	a5,100
 5ac:	02f68963          	beq	a3,a5,5de <vprintf+0x114>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5b0:	06c00793          	li	a5,108
 5b4:	04f68263          	beq	a3,a5,5f8 <vprintf+0x12e>
      } else if(c0 == 'l' && c1 == 'u'){
 5b8:	07500793          	li	a5,117
 5bc:	0af68063          	beq	a3,a5,65c <vprintf+0x192>
      } else if(c0 == 'l' && c1 == 'x'){
 5c0:	07800793          	li	a5,120
 5c4:	0ef68263          	beq	a3,a5,6a8 <vprintf+0x1de>
        putc(fd, '%');
 5c8:	02500593          	li	a1,37
 5cc:	855a                	mv	a0,s6
 5ce:	e43ff0ef          	jal	410 <putc>
        putc(fd, c0);
 5d2:	85ca                	mv	a1,s2
 5d4:	855a                	mv	a0,s6
 5d6:	e3bff0ef          	jal	410 <putc>
      state = 0;
 5da:	4981                	li	s3,0
 5dc:	bf2d                	j	516 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5de:	008b8913          	add	s2,s7,8
 5e2:	4685                	li	a3,1
 5e4:	4629                	li	a2,10
 5e6:	000bb583          	ld	a1,0(s7)
 5ea:	855a                	mv	a0,s6
 5ec:	e43ff0ef          	jal	42e <printint>
        i += 1;
 5f0:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 5f2:	8bca                	mv	s7,s2
      state = 0;
 5f4:	4981                	li	s3,0
        i += 1;
 5f6:	b705                	j	516 <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5f8:	06400793          	li	a5,100
 5fc:	02f60763          	beq	a2,a5,62a <vprintf+0x160>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 600:	07500793          	li	a5,117
 604:	06f60963          	beq	a2,a5,676 <vprintf+0x1ac>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 608:	07800793          	li	a5,120
 60c:	faf61ee3          	bne	a2,a5,5c8 <vprintf+0xfe>
        printint(fd, va_arg(ap, uint64), 16, 0);
 610:	008b8913          	add	s2,s7,8
 614:	4681                	li	a3,0
 616:	4641                	li	a2,16
 618:	000bb583          	ld	a1,0(s7)
 61c:	855a                	mv	a0,s6
 61e:	e11ff0ef          	jal	42e <printint>
        i += 2;
 622:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 624:	8bca                	mv	s7,s2
      state = 0;
 626:	4981                	li	s3,0
        i += 2;
 628:	b5fd                	j	516 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 62a:	008b8913          	add	s2,s7,8
 62e:	4685                	li	a3,1
 630:	4629                	li	a2,10
 632:	000bb583          	ld	a1,0(s7)
 636:	855a                	mv	a0,s6
 638:	df7ff0ef          	jal	42e <printint>
        i += 2;
 63c:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 63e:	8bca                	mv	s7,s2
      state = 0;
 640:	4981                	li	s3,0
        i += 2;
 642:	bdd1                	j	516 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint32), 10, 0);
 644:	008b8913          	add	s2,s7,8
 648:	4681                	li	a3,0
 64a:	4629                	li	a2,10
 64c:	000be583          	lwu	a1,0(s7)
 650:	855a                	mv	a0,s6
 652:	dddff0ef          	jal	42e <printint>
 656:	8bca                	mv	s7,s2
      state = 0;
 658:	4981                	li	s3,0
 65a:	bd75                	j	516 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 65c:	008b8913          	add	s2,s7,8
 660:	4681                	li	a3,0
 662:	4629                	li	a2,10
 664:	000bb583          	ld	a1,0(s7)
 668:	855a                	mv	a0,s6
 66a:	dc5ff0ef          	jal	42e <printint>
        i += 1;
 66e:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 670:	8bca                	mv	s7,s2
      state = 0;
 672:	4981                	li	s3,0
        i += 1;
 674:	b54d                	j	516 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 676:	008b8913          	add	s2,s7,8
 67a:	4681                	li	a3,0
 67c:	4629                	li	a2,10
 67e:	000bb583          	ld	a1,0(s7)
 682:	855a                	mv	a0,s6
 684:	dabff0ef          	jal	42e <printint>
        i += 2;
 688:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 68a:	8bca                	mv	s7,s2
      state = 0;
 68c:	4981                	li	s3,0
        i += 2;
 68e:	b561                	j	516 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint32), 16, 0);
 690:	008b8913          	add	s2,s7,8
 694:	4681                	li	a3,0
 696:	4641                	li	a2,16
 698:	000be583          	lwu	a1,0(s7)
 69c:	855a                	mv	a0,s6
 69e:	d91ff0ef          	jal	42e <printint>
 6a2:	8bca                	mv	s7,s2
      state = 0;
 6a4:	4981                	li	s3,0
 6a6:	bd85                	j	516 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6a8:	008b8913          	add	s2,s7,8
 6ac:	4681                	li	a3,0
 6ae:	4641                	li	a2,16
 6b0:	000bb583          	ld	a1,0(s7)
 6b4:	855a                	mv	a0,s6
 6b6:	d79ff0ef          	jal	42e <printint>
        i += 1;
 6ba:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 6bc:	8bca                	mv	s7,s2
      state = 0;
 6be:	4981                	li	s3,0
        i += 1;
 6c0:	bd99                	j	516 <vprintf+0x4c>
        printptr(fd, va_arg(ap, uint64));
 6c2:	008b8d13          	add	s10,s7,8
 6c6:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6ca:	03000593          	li	a1,48
 6ce:	855a                	mv	a0,s6
 6d0:	d41ff0ef          	jal	410 <putc>
  putc(fd, 'x');
 6d4:	07800593          	li	a1,120
 6d8:	855a                	mv	a0,s6
 6da:	d37ff0ef          	jal	410 <putc>
 6de:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6e0:	00000b97          	auipc	s7,0x0
 6e4:	2e8b8b93          	add	s7,s7,744 # 9c8 <digits>
 6e8:	03c9d793          	srl	a5,s3,0x3c
 6ec:	97de                	add	a5,a5,s7
 6ee:	0007c583          	lbu	a1,0(a5)
 6f2:	855a                	mv	a0,s6
 6f4:	d1dff0ef          	jal	410 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6f8:	0992                	sll	s3,s3,0x4
 6fa:	397d                	addw	s2,s2,-1
 6fc:	fe0916e3          	bnez	s2,6e8 <vprintf+0x21e>
        printptr(fd, va_arg(ap, uint64));
 700:	8bea                	mv	s7,s10
      state = 0;
 702:	4981                	li	s3,0
 704:	bd09                	j	516 <vprintf+0x4c>
        putc(fd, va_arg(ap, uint32));
 706:	008b8913          	add	s2,s7,8
 70a:	000bc583          	lbu	a1,0(s7)
 70e:	855a                	mv	a0,s6
 710:	d01ff0ef          	jal	410 <putc>
 714:	8bca                	mv	s7,s2
      state = 0;
 716:	4981                	li	s3,0
 718:	bbfd                	j	516 <vprintf+0x4c>
        if((s = va_arg(ap, char*)) == 0)
 71a:	008b8993          	add	s3,s7,8
 71e:	000bb903          	ld	s2,0(s7)
 722:	00090f63          	beqz	s2,740 <vprintf+0x276>
        for(; *s; s++)
 726:	00094583          	lbu	a1,0(s2)
 72a:	c195                	beqz	a1,74e <vprintf+0x284>
          putc(fd, *s);
 72c:	855a                	mv	a0,s6
 72e:	ce3ff0ef          	jal	410 <putc>
        for(; *s; s++)
 732:	0905                	add	s2,s2,1
 734:	00094583          	lbu	a1,0(s2)
 738:	f9f5                	bnez	a1,72c <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 73a:	8bce                	mv	s7,s3
      state = 0;
 73c:	4981                	li	s3,0
 73e:	bbe1                	j	516 <vprintf+0x4c>
          s = "(null)";
 740:	00000917          	auipc	s2,0x0
 744:	28090913          	add	s2,s2,640 # 9c0 <malloc+0x172>
        for(; *s; s++)
 748:	02800593          	li	a1,40
 74c:	b7c5                	j	72c <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 74e:	8bce                	mv	s7,s3
      state = 0;
 750:	4981                	li	s3,0
 752:	b3d1                	j	516 <vprintf+0x4c>
    }
  }
}
 754:	60e6                	ld	ra,88(sp)
 756:	6446                	ld	s0,80(sp)
 758:	64a6                	ld	s1,72(sp)
 75a:	6906                	ld	s2,64(sp)
 75c:	79e2                	ld	s3,56(sp)
 75e:	7a42                	ld	s4,48(sp)
 760:	7aa2                	ld	s5,40(sp)
 762:	7b02                	ld	s6,32(sp)
 764:	6be2                	ld	s7,24(sp)
 766:	6c42                	ld	s8,16(sp)
 768:	6ca2                	ld	s9,8(sp)
 76a:	6d02                	ld	s10,0(sp)
 76c:	6125                	add	sp,sp,96
 76e:	8082                	ret

0000000000000770 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 770:	715d                	add	sp,sp,-80
 772:	ec06                	sd	ra,24(sp)
 774:	e822                	sd	s0,16(sp)
 776:	1000                	add	s0,sp,32
 778:	e010                	sd	a2,0(s0)
 77a:	e414                	sd	a3,8(s0)
 77c:	e818                	sd	a4,16(s0)
 77e:	ec1c                	sd	a5,24(s0)
 780:	03043023          	sd	a6,32(s0)
 784:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 788:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 78c:	8622                	mv	a2,s0
 78e:	d3dff0ef          	jal	4ca <vprintf>
}
 792:	60e2                	ld	ra,24(sp)
 794:	6442                	ld	s0,16(sp)
 796:	6161                	add	sp,sp,80
 798:	8082                	ret

000000000000079a <printf>:

void
printf(const char *fmt, ...)
{
 79a:	711d                	add	sp,sp,-96
 79c:	ec06                	sd	ra,24(sp)
 79e:	e822                	sd	s0,16(sp)
 7a0:	1000                	add	s0,sp,32
 7a2:	e40c                	sd	a1,8(s0)
 7a4:	e810                	sd	a2,16(s0)
 7a6:	ec14                	sd	a3,24(s0)
 7a8:	f018                	sd	a4,32(s0)
 7aa:	f41c                	sd	a5,40(s0)
 7ac:	03043823          	sd	a6,48(s0)
 7b0:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7b4:	00840613          	add	a2,s0,8
 7b8:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7bc:	85aa                	mv	a1,a0
 7be:	4505                	li	a0,1
 7c0:	d0bff0ef          	jal	4ca <vprintf>
}
 7c4:	60e2                	ld	ra,24(sp)
 7c6:	6442                	ld	s0,16(sp)
 7c8:	6125                	add	sp,sp,96
 7ca:	8082                	ret

00000000000007cc <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7cc:	1141                	add	sp,sp,-16
 7ce:	e422                	sd	s0,8(sp)
 7d0:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7d2:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7d6:	00001797          	auipc	a5,0x1
 7da:	82a7b783          	ld	a5,-2006(a5) # 1000 <freep>
 7de:	a02d                	j	808 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7e0:	4618                	lw	a4,8(a2)
 7e2:	9f2d                	addw	a4,a4,a1
 7e4:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7e8:	6398                	ld	a4,0(a5)
 7ea:	6310                	ld	a2,0(a4)
 7ec:	a83d                	j	82a <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7ee:	ff852703          	lw	a4,-8(a0)
 7f2:	9f31                	addw	a4,a4,a2
 7f4:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7f6:	ff053683          	ld	a3,-16(a0)
 7fa:	a091                	j	83e <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7fc:	6398                	ld	a4,0(a5)
 7fe:	00e7e463          	bltu	a5,a4,806 <free+0x3a>
 802:	00e6ea63          	bltu	a3,a4,816 <free+0x4a>
{
 806:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 808:	fed7fae3          	bgeu	a5,a3,7fc <free+0x30>
 80c:	6398                	ld	a4,0(a5)
 80e:	00e6e463          	bltu	a3,a4,816 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 812:	fee7eae3          	bltu	a5,a4,806 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 816:	ff852583          	lw	a1,-8(a0)
 81a:	6390                	ld	a2,0(a5)
 81c:	02059813          	sll	a6,a1,0x20
 820:	01c85713          	srl	a4,a6,0x1c
 824:	9736                	add	a4,a4,a3
 826:	fae60de3          	beq	a2,a4,7e0 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 82a:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 82e:	4790                	lw	a2,8(a5)
 830:	02061593          	sll	a1,a2,0x20
 834:	01c5d713          	srl	a4,a1,0x1c
 838:	973e                	add	a4,a4,a5
 83a:	fae68ae3          	beq	a3,a4,7ee <free+0x22>
    p->s.ptr = bp->s.ptr;
 83e:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 840:	00000717          	auipc	a4,0x0
 844:	7cf73023          	sd	a5,1984(a4) # 1000 <freep>
}
 848:	6422                	ld	s0,8(sp)
 84a:	0141                	add	sp,sp,16
 84c:	8082                	ret

000000000000084e <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 84e:	7139                	add	sp,sp,-64
 850:	fc06                	sd	ra,56(sp)
 852:	f822                	sd	s0,48(sp)
 854:	f426                	sd	s1,40(sp)
 856:	f04a                	sd	s2,32(sp)
 858:	ec4e                	sd	s3,24(sp)
 85a:	e852                	sd	s4,16(sp)
 85c:	e456                	sd	s5,8(sp)
 85e:	e05a                	sd	s6,0(sp)
 860:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 862:	02051493          	sll	s1,a0,0x20
 866:	9081                	srl	s1,s1,0x20
 868:	04bd                	add	s1,s1,15
 86a:	8091                	srl	s1,s1,0x4
 86c:	0014899b          	addw	s3,s1,1
 870:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 872:	00000517          	auipc	a0,0x0
 876:	78e53503          	ld	a0,1934(a0) # 1000 <freep>
 87a:	c515                	beqz	a0,8a6 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 87c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 87e:	4798                	lw	a4,8(a5)
 880:	02977f63          	bgeu	a4,s1,8be <malloc+0x70>
  if(nu < 4096)
 884:	8a4e                	mv	s4,s3
 886:	0009871b          	sext.w	a4,s3
 88a:	6685                	lui	a3,0x1
 88c:	00d77363          	bgeu	a4,a3,892 <malloc+0x44>
 890:	6a05                	lui	s4,0x1
 892:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 896:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 89a:	00000917          	auipc	s2,0x0
 89e:	76690913          	add	s2,s2,1894 # 1000 <freep>
  if(p == SBRK_ERROR)
 8a2:	5afd                	li	s5,-1
 8a4:	a885                	j	914 <malloc+0xc6>
    base.s.ptr = freep = prevp = &base;
 8a6:	00001797          	auipc	a5,0x1
 8aa:	96278793          	add	a5,a5,-1694 # 1208 <base>
 8ae:	00000717          	auipc	a4,0x0
 8b2:	74f73923          	sd	a5,1874(a4) # 1000 <freep>
 8b6:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8b8:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8bc:	b7e1                	j	884 <malloc+0x36>
      if(p->s.size == nunits)
 8be:	02e48c63          	beq	s1,a4,8f6 <malloc+0xa8>
        p->s.size -= nunits;
 8c2:	4137073b          	subw	a4,a4,s3
 8c6:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8c8:	02071693          	sll	a3,a4,0x20
 8cc:	01c6d713          	srl	a4,a3,0x1c
 8d0:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8d2:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8d6:	00000717          	auipc	a4,0x0
 8da:	72a73523          	sd	a0,1834(a4) # 1000 <freep>
      return (void*)(p + 1);
 8de:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 8e2:	70e2                	ld	ra,56(sp)
 8e4:	7442                	ld	s0,48(sp)
 8e6:	74a2                	ld	s1,40(sp)
 8e8:	7902                	ld	s2,32(sp)
 8ea:	69e2                	ld	s3,24(sp)
 8ec:	6a42                	ld	s4,16(sp)
 8ee:	6aa2                	ld	s5,8(sp)
 8f0:	6b02                	ld	s6,0(sp)
 8f2:	6121                	add	sp,sp,64
 8f4:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 8f6:	6398                	ld	a4,0(a5)
 8f8:	e118                	sd	a4,0(a0)
 8fa:	bff1                	j	8d6 <malloc+0x88>
  hp->s.size = nu;
 8fc:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 900:	0541                	add	a0,a0,16
 902:	ecbff0ef          	jal	7cc <free>
  return freep;
 906:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 90a:	dd61                	beqz	a0,8e2 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 90c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 90e:	4798                	lw	a4,8(a5)
 910:	fa9777e3          	bgeu	a4,s1,8be <malloc+0x70>
    if(p == freep)
 914:	00093703          	ld	a4,0(s2)
 918:	853e                	mv	a0,a5
 91a:	fef719e3          	bne	a4,a5,90c <malloc+0xbe>
  p = sbrk(nu * sizeof(Header));
 91e:	8552                	mv	a0,s4
 920:	a05ff0ef          	jal	324 <sbrk>
  if(p == SBRK_ERROR)
 924:	fd551ce3          	bne	a0,s5,8fc <malloc+0xae>
        return 0;
 928:	4501                	li	a0,0
 92a:	bf65                	j	8e2 <malloc+0x94>
