
user/_logstress:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
main(int argc, char **argv)
{
  int fd, n;
  enum { N = 250, SZ=2000 };
  
  for (int i = 1; i < argc; i++){
   0:	4785                	li	a5,1
   2:	0ea7de63          	bge	a5,a0,fe <main+0xfe>
{
   6:	7139                	add	sp,sp,-64
   8:	fc06                	sd	ra,56(sp)
   a:	f822                	sd	s0,48(sp)
   c:	f426                	sd	s1,40(sp)
   e:	f04a                	sd	s2,32(sp)
  10:	ec4e                	sd	s3,24(sp)
  12:	e852                	sd	s4,16(sp)
  14:	0080                	add	s0,sp,64
  16:	892a                	mv	s2,a0
  18:	89ae                	mv	s3,a1
  for (int i = 1; i < argc; i++){
  1a:	4485                	li	s1,1
  1c:	a011                	j	20 <main+0x20>
  1e:	84be                	mv	s1,a5
    int pid1 = fork();
  20:	36e000ef          	jal	38e <fork>
    if(pid1 < 0){
  24:	00054963          	bltz	a0,36 <main+0x36>
      printf("%s: fork failed\n", argv[0]);
      exit(1);
    }
    if(pid1 == 0) {
  28:	c115                	beqz	a0,4c <main+0x4c>
  for (int i = 1; i < argc; i++){
  2a:	0014879b          	addw	a5,s1,1
  2e:	fef918e3          	bne	s2,a5,1e <main+0x1e>
      }
      exit(0);
    }
  }
  int xstatus;
  for(int i = 1; i < argc; i++){
  32:	4905                	li	s2,1
  34:	a879                	j	d2 <main+0xd2>
      printf("%s: fork failed\n", argv[0]);
  36:	0009b583          	ld	a1,0(s3)
  3a:	00001517          	auipc	a0,0x1
  3e:	93650513          	add	a0,a0,-1738 # 970 <malloc+0xe4>
  42:	796000ef          	jal	7d8 <printf>
      exit(1);
  46:	4505                	li	a0,1
  48:	34e000ef          	jal	396 <exit>
      fd = open(argv[i], O_CREATE | O_RDWR);
  4c:	00349a13          	sll	s4,s1,0x3
  50:	9a4e                	add	s4,s4,s3
  52:	20200593          	li	a1,514
  56:	000a3503          	ld	a0,0(s4)
  5a:	37c000ef          	jal	3d6 <open>
  5e:	892a                	mv	s2,a0
      if(fd < 0){
  60:	04054163          	bltz	a0,a2 <main+0xa2>
      memset(buf, '0'+i, SZ);
  64:	7d000613          	li	a2,2000
  68:	0304859b          	addw	a1,s1,48
  6c:	00001517          	auipc	a0,0x1
  70:	fa450513          	add	a0,a0,-92 # 1010 <buf>
  74:	110000ef          	jal	184 <memset>
  78:	0fa00493          	li	s1,250
        if((n = write(fd, buf, SZ)) != SZ){
  7c:	00001997          	auipc	s3,0x1
  80:	f9498993          	add	s3,s3,-108 # 1010 <buf>
  84:	7d000613          	li	a2,2000
  88:	85ce                	mv	a1,s3
  8a:	854a                	mv	a0,s2
  8c:	32a000ef          	jal	3b6 <write>
  90:	7d000793          	li	a5,2000
  94:	02f51463          	bne	a0,a5,bc <main+0xbc>
      for(i = 0; i < N; i++){
  98:	34fd                	addw	s1,s1,-1
  9a:	f4ed                	bnez	s1,84 <main+0x84>
      exit(0);
  9c:	4501                	li	a0,0
  9e:	2f8000ef          	jal	396 <exit>
        printf("%s: create %s failed\n", argv[0], argv[i]);
  a2:	000a3603          	ld	a2,0(s4)
  a6:	0009b583          	ld	a1,0(s3)
  aa:	00001517          	auipc	a0,0x1
  ae:	8de50513          	add	a0,a0,-1826 # 988 <malloc+0xfc>
  b2:	726000ef          	jal	7d8 <printf>
        exit(1);
  b6:	4505                	li	a0,1
  b8:	2de000ef          	jal	396 <exit>
          printf("write failed %d\n", n);
  bc:	85aa                	mv	a1,a0
  be:	00001517          	auipc	a0,0x1
  c2:	8e250513          	add	a0,a0,-1822 # 9a0 <malloc+0x114>
  c6:	712000ef          	jal	7d8 <printf>
          exit(1);
  ca:	4505                	li	a0,1
  cc:	2ca000ef          	jal	396 <exit>
  for(int i = 1; i < argc; i++){
  d0:	893e                	mv	s2,a5
    wait(&xstatus);
  d2:	fcc40513          	add	a0,s0,-52
  d6:	2c8000ef          	jal	39e <wait>
    if(xstatus != 0)
  da:	fcc42503          	lw	a0,-52(s0)
  de:	ed11                	bnez	a0,fa <main+0xfa>
  for(int i = 1; i < argc; i++){
  e0:	0019079b          	addw	a5,s2,1
  e4:	ff2496e3          	bne	s1,s2,d0 <main+0xd0>
      exit(xstatus);
  }
  return 0;
}
  e8:	4501                	li	a0,0
  ea:	70e2                	ld	ra,56(sp)
  ec:	7442                	ld	s0,48(sp)
  ee:	74a2                	ld	s1,40(sp)
  f0:	7902                	ld	s2,32(sp)
  f2:	69e2                	ld	s3,24(sp)
  f4:	6a42                	ld	s4,16(sp)
  f6:	6121                	add	sp,sp,64
  f8:	8082                	ret
      exit(xstatus);
  fa:	29c000ef          	jal	396 <exit>
}
  fe:	4501                	li	a0,0
 100:	8082                	ret

0000000000000102 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
 102:	1141                	add	sp,sp,-16
 104:	e406                	sd	ra,8(sp)
 106:	e022                	sd	s0,0(sp)
 108:	0800                	add	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
 10a:	ef7ff0ef          	jal	0 <main>
  exit(r);
 10e:	288000ef          	jal	396 <exit>

0000000000000112 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 112:	1141                	add	sp,sp,-16
 114:	e422                	sd	s0,8(sp)
 116:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 118:	87aa                	mv	a5,a0
 11a:	0585                	add	a1,a1,1
 11c:	0785                	add	a5,a5,1
 11e:	fff5c703          	lbu	a4,-1(a1)
 122:	fee78fa3          	sb	a4,-1(a5)
 126:	fb75                	bnez	a4,11a <strcpy+0x8>
    ;
  return os;
}
 128:	6422                	ld	s0,8(sp)
 12a:	0141                	add	sp,sp,16
 12c:	8082                	ret

000000000000012e <strcmp>:

int
strcmp(const char *p, const char *q)
{
 12e:	1141                	add	sp,sp,-16
 130:	e422                	sd	s0,8(sp)
 132:	0800                	add	s0,sp,16
  while(*p && *p == *q)
 134:	00054783          	lbu	a5,0(a0)
 138:	cb91                	beqz	a5,14c <strcmp+0x1e>
 13a:	0005c703          	lbu	a4,0(a1)
 13e:	00f71763          	bne	a4,a5,14c <strcmp+0x1e>
    p++, q++;
 142:	0505                	add	a0,a0,1
 144:	0585                	add	a1,a1,1
  while(*p && *p == *q)
 146:	00054783          	lbu	a5,0(a0)
 14a:	fbe5                	bnez	a5,13a <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 14c:	0005c503          	lbu	a0,0(a1)
}
 150:	40a7853b          	subw	a0,a5,a0
 154:	6422                	ld	s0,8(sp)
 156:	0141                	add	sp,sp,16
 158:	8082                	ret

000000000000015a <strlen>:

uint
strlen(const char *s)
{
 15a:	1141                	add	sp,sp,-16
 15c:	e422                	sd	s0,8(sp)
 15e:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 160:	00054783          	lbu	a5,0(a0)
 164:	cf91                	beqz	a5,180 <strlen+0x26>
 166:	0505                	add	a0,a0,1
 168:	87aa                	mv	a5,a0
 16a:	86be                	mv	a3,a5
 16c:	0785                	add	a5,a5,1
 16e:	fff7c703          	lbu	a4,-1(a5)
 172:	ff65                	bnez	a4,16a <strlen+0x10>
 174:	40a6853b          	subw	a0,a3,a0
 178:	2505                	addw	a0,a0,1
    ;
  return n;
}
 17a:	6422                	ld	s0,8(sp)
 17c:	0141                	add	sp,sp,16
 17e:	8082                	ret
  for(n = 0; s[n]; n++)
 180:	4501                	li	a0,0
 182:	bfe5                	j	17a <strlen+0x20>

0000000000000184 <memset>:

void*
memset(void *dst, int c, uint n)
{
 184:	1141                	add	sp,sp,-16
 186:	e422                	sd	s0,8(sp)
 188:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 18a:	ca19                	beqz	a2,1a0 <memset+0x1c>
 18c:	87aa                	mv	a5,a0
 18e:	1602                	sll	a2,a2,0x20
 190:	9201                	srl	a2,a2,0x20
 192:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 196:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 19a:	0785                	add	a5,a5,1
 19c:	fee79de3          	bne	a5,a4,196 <memset+0x12>
  }
  return dst;
}
 1a0:	6422                	ld	s0,8(sp)
 1a2:	0141                	add	sp,sp,16
 1a4:	8082                	ret

00000000000001a6 <strchr>:

char*
strchr(const char *s, char c)
{
 1a6:	1141                	add	sp,sp,-16
 1a8:	e422                	sd	s0,8(sp)
 1aa:	0800                	add	s0,sp,16
  for(; *s; s++)
 1ac:	00054783          	lbu	a5,0(a0)
 1b0:	cb99                	beqz	a5,1c6 <strchr+0x20>
    if(*s == c)
 1b2:	00f58763          	beq	a1,a5,1c0 <strchr+0x1a>
  for(; *s; s++)
 1b6:	0505                	add	a0,a0,1
 1b8:	00054783          	lbu	a5,0(a0)
 1bc:	fbfd                	bnez	a5,1b2 <strchr+0xc>
      return (char*)s;
  return 0;
 1be:	4501                	li	a0,0
}
 1c0:	6422                	ld	s0,8(sp)
 1c2:	0141                	add	sp,sp,16
 1c4:	8082                	ret
  return 0;
 1c6:	4501                	li	a0,0
 1c8:	bfe5                	j	1c0 <strchr+0x1a>

00000000000001ca <gets>:

char*
gets(char *buf, int max)
{
 1ca:	711d                	add	sp,sp,-96
 1cc:	ec86                	sd	ra,88(sp)
 1ce:	e8a2                	sd	s0,80(sp)
 1d0:	e4a6                	sd	s1,72(sp)
 1d2:	e0ca                	sd	s2,64(sp)
 1d4:	fc4e                	sd	s3,56(sp)
 1d6:	f852                	sd	s4,48(sp)
 1d8:	f456                	sd	s5,40(sp)
 1da:	f05a                	sd	s6,32(sp)
 1dc:	ec5e                	sd	s7,24(sp)
 1de:	1080                	add	s0,sp,96
 1e0:	8baa                	mv	s7,a0
 1e2:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1e4:	892a                	mv	s2,a0
 1e6:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1e8:	4aa9                	li	s5,10
 1ea:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1ec:	89a6                	mv	s3,s1
 1ee:	2485                	addw	s1,s1,1
 1f0:	0344d663          	bge	s1,s4,21c <gets+0x52>
    cc = read(0, &c, 1);
 1f4:	4605                	li	a2,1
 1f6:	faf40593          	add	a1,s0,-81
 1fa:	4501                	li	a0,0
 1fc:	1b2000ef          	jal	3ae <read>
    if(cc < 1)
 200:	00a05e63          	blez	a0,21c <gets+0x52>
    buf[i++] = c;
 204:	faf44783          	lbu	a5,-81(s0)
 208:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 20c:	01578763          	beq	a5,s5,21a <gets+0x50>
 210:	0905                	add	s2,s2,1
 212:	fd679de3          	bne	a5,s6,1ec <gets+0x22>
  for(i=0; i+1 < max; ){
 216:	89a6                	mv	s3,s1
 218:	a011                	j	21c <gets+0x52>
 21a:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 21c:	99de                	add	s3,s3,s7
 21e:	00098023          	sb	zero,0(s3)
  return buf;
}
 222:	855e                	mv	a0,s7
 224:	60e6                	ld	ra,88(sp)
 226:	6446                	ld	s0,80(sp)
 228:	64a6                	ld	s1,72(sp)
 22a:	6906                	ld	s2,64(sp)
 22c:	79e2                	ld	s3,56(sp)
 22e:	7a42                	ld	s4,48(sp)
 230:	7aa2                	ld	s5,40(sp)
 232:	7b02                	ld	s6,32(sp)
 234:	6be2                	ld	s7,24(sp)
 236:	6125                	add	sp,sp,96
 238:	8082                	ret

000000000000023a <stat>:

int
stat(const char *n, struct stat *st)
{
 23a:	1101                	add	sp,sp,-32
 23c:	ec06                	sd	ra,24(sp)
 23e:	e822                	sd	s0,16(sp)
 240:	e426                	sd	s1,8(sp)
 242:	e04a                	sd	s2,0(sp)
 244:	1000                	add	s0,sp,32
 246:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 248:	4581                	li	a1,0
 24a:	18c000ef          	jal	3d6 <open>
  if(fd < 0)
 24e:	02054163          	bltz	a0,270 <stat+0x36>
 252:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 254:	85ca                	mv	a1,s2
 256:	198000ef          	jal	3ee <fstat>
 25a:	892a                	mv	s2,a0
  close(fd);
 25c:	8526                	mv	a0,s1
 25e:	160000ef          	jal	3be <close>
  return r;
}
 262:	854a                	mv	a0,s2
 264:	60e2                	ld	ra,24(sp)
 266:	6442                	ld	s0,16(sp)
 268:	64a2                	ld	s1,8(sp)
 26a:	6902                	ld	s2,0(sp)
 26c:	6105                	add	sp,sp,32
 26e:	8082                	ret
    return -1;
 270:	597d                	li	s2,-1
 272:	bfc5                	j	262 <stat+0x28>

0000000000000274 <atoi>:

int
atoi(const char *s)
{
 274:	1141                	add	sp,sp,-16
 276:	e422                	sd	s0,8(sp)
 278:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 27a:	00054683          	lbu	a3,0(a0)
 27e:	fd06879b          	addw	a5,a3,-48
 282:	0ff7f793          	zext.b	a5,a5
 286:	4625                	li	a2,9
 288:	02f66863          	bltu	a2,a5,2b8 <atoi+0x44>
 28c:	872a                	mv	a4,a0
  n = 0;
 28e:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 290:	0705                	add	a4,a4,1
 292:	0025179b          	sllw	a5,a0,0x2
 296:	9fa9                	addw	a5,a5,a0
 298:	0017979b          	sllw	a5,a5,0x1
 29c:	9fb5                	addw	a5,a5,a3
 29e:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2a2:	00074683          	lbu	a3,0(a4)
 2a6:	fd06879b          	addw	a5,a3,-48
 2aa:	0ff7f793          	zext.b	a5,a5
 2ae:	fef671e3          	bgeu	a2,a5,290 <atoi+0x1c>
  return n;
}
 2b2:	6422                	ld	s0,8(sp)
 2b4:	0141                	add	sp,sp,16
 2b6:	8082                	ret
  n = 0;
 2b8:	4501                	li	a0,0
 2ba:	bfe5                	j	2b2 <atoi+0x3e>

00000000000002bc <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2bc:	1141                	add	sp,sp,-16
 2be:	e422                	sd	s0,8(sp)
 2c0:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2c2:	02b57463          	bgeu	a0,a1,2ea <memmove+0x2e>
    while(n-- > 0)
 2c6:	00c05f63          	blez	a2,2e4 <memmove+0x28>
 2ca:	1602                	sll	a2,a2,0x20
 2cc:	9201                	srl	a2,a2,0x20
 2ce:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2d2:	872a                	mv	a4,a0
      *dst++ = *src++;
 2d4:	0585                	add	a1,a1,1
 2d6:	0705                	add	a4,a4,1
 2d8:	fff5c683          	lbu	a3,-1(a1)
 2dc:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2e0:	fee79ae3          	bne	a5,a4,2d4 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2e4:	6422                	ld	s0,8(sp)
 2e6:	0141                	add	sp,sp,16
 2e8:	8082                	ret
    dst += n;
 2ea:	00c50733          	add	a4,a0,a2
    src += n;
 2ee:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2f0:	fec05ae3          	blez	a2,2e4 <memmove+0x28>
 2f4:	fff6079b          	addw	a5,a2,-1
 2f8:	1782                	sll	a5,a5,0x20
 2fa:	9381                	srl	a5,a5,0x20
 2fc:	fff7c793          	not	a5,a5
 300:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 302:	15fd                	add	a1,a1,-1
 304:	177d                	add	a4,a4,-1
 306:	0005c683          	lbu	a3,0(a1)
 30a:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 30e:	fee79ae3          	bne	a5,a4,302 <memmove+0x46>
 312:	bfc9                	j	2e4 <memmove+0x28>

0000000000000314 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 314:	1141                	add	sp,sp,-16
 316:	e422                	sd	s0,8(sp)
 318:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 31a:	ca05                	beqz	a2,34a <memcmp+0x36>
 31c:	fff6069b          	addw	a3,a2,-1
 320:	1682                	sll	a3,a3,0x20
 322:	9281                	srl	a3,a3,0x20
 324:	0685                	add	a3,a3,1
 326:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 328:	00054783          	lbu	a5,0(a0)
 32c:	0005c703          	lbu	a4,0(a1)
 330:	00e79863          	bne	a5,a4,340 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 334:	0505                	add	a0,a0,1
    p2++;
 336:	0585                	add	a1,a1,1
  while (n-- > 0) {
 338:	fed518e3          	bne	a0,a3,328 <memcmp+0x14>
  }
  return 0;
 33c:	4501                	li	a0,0
 33e:	a019                	j	344 <memcmp+0x30>
      return *p1 - *p2;
 340:	40e7853b          	subw	a0,a5,a4
}
 344:	6422                	ld	s0,8(sp)
 346:	0141                	add	sp,sp,16
 348:	8082                	ret
  return 0;
 34a:	4501                	li	a0,0
 34c:	bfe5                	j	344 <memcmp+0x30>

000000000000034e <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 34e:	1141                	add	sp,sp,-16
 350:	e406                	sd	ra,8(sp)
 352:	e022                	sd	s0,0(sp)
 354:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 356:	f67ff0ef          	jal	2bc <memmove>
}
 35a:	60a2                	ld	ra,8(sp)
 35c:	6402                	ld	s0,0(sp)
 35e:	0141                	add	sp,sp,16
 360:	8082                	ret

0000000000000362 <sbrk>:

char *
sbrk(int n) {
 362:	1141                	add	sp,sp,-16
 364:	e406                	sd	ra,8(sp)
 366:	e022                	sd	s0,0(sp)
 368:	0800                	add	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 36a:	4585                	li	a1,1
 36c:	0b2000ef          	jal	41e <sys_sbrk>
}
 370:	60a2                	ld	ra,8(sp)
 372:	6402                	ld	s0,0(sp)
 374:	0141                	add	sp,sp,16
 376:	8082                	ret

0000000000000378 <sbrklazy>:

char *
sbrklazy(int n) {
 378:	1141                	add	sp,sp,-16
 37a:	e406                	sd	ra,8(sp)
 37c:	e022                	sd	s0,0(sp)
 37e:	0800                	add	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 380:	4589                	li	a1,2
 382:	09c000ef          	jal	41e <sys_sbrk>
}
 386:	60a2                	ld	ra,8(sp)
 388:	6402                	ld	s0,0(sp)
 38a:	0141                	add	sp,sp,16
 38c:	8082                	ret

000000000000038e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 38e:	4885                	li	a7,1
 ecall
 390:	00000073          	ecall
 ret
 394:	8082                	ret

0000000000000396 <exit>:
.global exit
exit:
 li a7, SYS_exit
 396:	4889                	li	a7,2
 ecall
 398:	00000073          	ecall
 ret
 39c:	8082                	ret

000000000000039e <wait>:
.global wait
wait:
 li a7, SYS_wait
 39e:	488d                	li	a7,3
 ecall
 3a0:	00000073          	ecall
 ret
 3a4:	8082                	ret

00000000000003a6 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3a6:	4891                	li	a7,4
 ecall
 3a8:	00000073          	ecall
 ret
 3ac:	8082                	ret

00000000000003ae <read>:
.global read
read:
 li a7, SYS_read
 3ae:	4895                	li	a7,5
 ecall
 3b0:	00000073          	ecall
 ret
 3b4:	8082                	ret

00000000000003b6 <write>:
.global write
write:
 li a7, SYS_write
 3b6:	48c1                	li	a7,16
 ecall
 3b8:	00000073          	ecall
 ret
 3bc:	8082                	ret

00000000000003be <close>:
.global close
close:
 li a7, SYS_close
 3be:	48d5                	li	a7,21
 ecall
 3c0:	00000073          	ecall
 ret
 3c4:	8082                	ret

00000000000003c6 <kill>:
.global kill
kill:
 li a7, SYS_kill
 3c6:	4899                	li	a7,6
 ecall
 3c8:	00000073          	ecall
 ret
 3cc:	8082                	ret

00000000000003ce <exec>:
.global exec
exec:
 li a7, SYS_exec
 3ce:	489d                	li	a7,7
 ecall
 3d0:	00000073          	ecall
 ret
 3d4:	8082                	ret

00000000000003d6 <open>:
.global open
open:
 li a7, SYS_open
 3d6:	48bd                	li	a7,15
 ecall
 3d8:	00000073          	ecall
 ret
 3dc:	8082                	ret

00000000000003de <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3de:	48c5                	li	a7,17
 ecall
 3e0:	00000073          	ecall
 ret
 3e4:	8082                	ret

00000000000003e6 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3e6:	48c9                	li	a7,18
 ecall
 3e8:	00000073          	ecall
 ret
 3ec:	8082                	ret

00000000000003ee <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3ee:	48a1                	li	a7,8
 ecall
 3f0:	00000073          	ecall
 ret
 3f4:	8082                	ret

00000000000003f6 <link>:
.global link
link:
 li a7, SYS_link
 3f6:	48cd                	li	a7,19
 ecall
 3f8:	00000073          	ecall
 ret
 3fc:	8082                	ret

00000000000003fe <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3fe:	48d1                	li	a7,20
 ecall
 400:	00000073          	ecall
 ret
 404:	8082                	ret

0000000000000406 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 406:	48a5                	li	a7,9
 ecall
 408:	00000073          	ecall
 ret
 40c:	8082                	ret

000000000000040e <dup>:
.global dup
dup:
 li a7, SYS_dup
 40e:	48a9                	li	a7,10
 ecall
 410:	00000073          	ecall
 ret
 414:	8082                	ret

0000000000000416 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 416:	48ad                	li	a7,11
 ecall
 418:	00000073          	ecall
 ret
 41c:	8082                	ret

000000000000041e <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 41e:	48b1                	li	a7,12
 ecall
 420:	00000073          	ecall
 ret
 424:	8082                	ret

0000000000000426 <pause>:
.global pause
pause:
 li a7, SYS_pause
 426:	48b5                	li	a7,13
 ecall
 428:	00000073          	ecall
 ret
 42c:	8082                	ret

000000000000042e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 42e:	48b9                	li	a7,14
 ecall
 430:	00000073          	ecall
 ret
 434:	8082                	ret

0000000000000436 <getcnt>:
.global getcnt
getcnt:
 li a7, SYS_getcnt
 436:	48d9                	li	a7,22
 ecall
 438:	00000073          	ecall
 ret
 43c:	8082                	ret

000000000000043e <settickets>:
.global settickets
settickets:
 li a7, SYS_settickets
 43e:	48dd                	li	a7,23
 ecall
 440:	00000073          	ecall
 ret
 444:	8082                	ret

0000000000000446 <getpinfo>:
.global getpinfo
getpinfo:
 li a7, SYS_getpinfo
 446:	48e1                	li	a7,24
 ecall
 448:	00000073          	ecall
 ret
 44c:	8082                	ret

000000000000044e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 44e:	1101                	add	sp,sp,-32
 450:	ec06                	sd	ra,24(sp)
 452:	e822                	sd	s0,16(sp)
 454:	1000                	add	s0,sp,32
 456:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 45a:	4605                	li	a2,1
 45c:	fef40593          	add	a1,s0,-17
 460:	f57ff0ef          	jal	3b6 <write>
}
 464:	60e2                	ld	ra,24(sp)
 466:	6442                	ld	s0,16(sp)
 468:	6105                	add	sp,sp,32
 46a:	8082                	ret

000000000000046c <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 46c:	715d                	add	sp,sp,-80
 46e:	e486                	sd	ra,72(sp)
 470:	e0a2                	sd	s0,64(sp)
 472:	fc26                	sd	s1,56(sp)
 474:	f84a                	sd	s2,48(sp)
 476:	f44e                	sd	s3,40(sp)
 478:	0880                	add	s0,sp,80
 47a:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 47c:	c299                	beqz	a3,482 <printint+0x16>
 47e:	0805c163          	bltz	a1,500 <printint+0x94>
  neg = 0;
 482:	4881                	li	a7,0
 484:	fb840693          	add	a3,s0,-72
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 488:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 48a:	00000517          	auipc	a0,0x0
 48e:	53650513          	add	a0,a0,1334 # 9c0 <digits>
 492:	883e                	mv	a6,a5
 494:	2785                	addw	a5,a5,1
 496:	02c5f733          	remu	a4,a1,a2
 49a:	972a                	add	a4,a4,a0
 49c:	00074703          	lbu	a4,0(a4)
 4a0:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 4a4:	872e                	mv	a4,a1
 4a6:	02c5d5b3          	divu	a1,a1,a2
 4aa:	0685                	add	a3,a3,1
 4ac:	fec773e3          	bgeu	a4,a2,492 <printint+0x26>
  if(neg)
 4b0:	00088b63          	beqz	a7,4c6 <printint+0x5a>
    buf[i++] = '-';
 4b4:	fd078793          	add	a5,a5,-48
 4b8:	97a2                	add	a5,a5,s0
 4ba:	02d00713          	li	a4,45
 4be:	fee78423          	sb	a4,-24(a5)
 4c2:	0028079b          	addw	a5,a6,2

  while(--i >= 0)
 4c6:	02f05663          	blez	a5,4f2 <printint+0x86>
 4ca:	fb840713          	add	a4,s0,-72
 4ce:	00f704b3          	add	s1,a4,a5
 4d2:	fff70993          	add	s3,a4,-1
 4d6:	99be                	add	s3,s3,a5
 4d8:	37fd                	addw	a5,a5,-1
 4da:	1782                	sll	a5,a5,0x20
 4dc:	9381                	srl	a5,a5,0x20
 4de:	40f989b3          	sub	s3,s3,a5
    putc(fd, buf[i]);
 4e2:	fff4c583          	lbu	a1,-1(s1)
 4e6:	854a                	mv	a0,s2
 4e8:	f67ff0ef          	jal	44e <putc>
  while(--i >= 0)
 4ec:	14fd                	add	s1,s1,-1
 4ee:	ff349ae3          	bne	s1,s3,4e2 <printint+0x76>
}
 4f2:	60a6                	ld	ra,72(sp)
 4f4:	6406                	ld	s0,64(sp)
 4f6:	74e2                	ld	s1,56(sp)
 4f8:	7942                	ld	s2,48(sp)
 4fa:	79a2                	ld	s3,40(sp)
 4fc:	6161                	add	sp,sp,80
 4fe:	8082                	ret
    x = -xx;
 500:	40b005b3          	neg	a1,a1
    neg = 1;
 504:	4885                	li	a7,1
    x = -xx;
 506:	bfbd                	j	484 <printint+0x18>

0000000000000508 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 508:	711d                	add	sp,sp,-96
 50a:	ec86                	sd	ra,88(sp)
 50c:	e8a2                	sd	s0,80(sp)
 50e:	e4a6                	sd	s1,72(sp)
 510:	e0ca                	sd	s2,64(sp)
 512:	fc4e                	sd	s3,56(sp)
 514:	f852                	sd	s4,48(sp)
 516:	f456                	sd	s5,40(sp)
 518:	f05a                	sd	s6,32(sp)
 51a:	ec5e                	sd	s7,24(sp)
 51c:	e862                	sd	s8,16(sp)
 51e:	e466                	sd	s9,8(sp)
 520:	e06a                	sd	s10,0(sp)
 522:	1080                	add	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 524:	0005c903          	lbu	s2,0(a1)
 528:	26090563          	beqz	s2,792 <vprintf+0x28a>
 52c:	8b2a                	mv	s6,a0
 52e:	8a2e                	mv	s4,a1
 530:	8bb2                	mv	s7,a2
  state = 0;
 532:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 534:	4481                	li	s1,0
 536:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 538:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 53c:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 540:	06c00c93          	li	s9,108
 544:	a005                	j	564 <vprintf+0x5c>
        putc(fd, c0);
 546:	85ca                	mv	a1,s2
 548:	855a                	mv	a0,s6
 54a:	f05ff0ef          	jal	44e <putc>
 54e:	a019                	j	554 <vprintf+0x4c>
    } else if(state == '%'){
 550:	03598263          	beq	s3,s5,574 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 554:	2485                	addw	s1,s1,1
 556:	8726                	mv	a4,s1
 558:	009a07b3          	add	a5,s4,s1
 55c:	0007c903          	lbu	s2,0(a5)
 560:	22090963          	beqz	s2,792 <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
 564:	0009079b          	sext.w	a5,s2
    if(state == 0){
 568:	fe0994e3          	bnez	s3,550 <vprintf+0x48>
      if(c0 == '%'){
 56c:	fd579de3          	bne	a5,s5,546 <vprintf+0x3e>
        state = '%';
 570:	89be                	mv	s3,a5
 572:	b7cd                	j	554 <vprintf+0x4c>
      if(c0) c1 = fmt[i+1] & 0xff;
 574:	cbc9                	beqz	a5,606 <vprintf+0xfe>
 576:	00ea06b3          	add	a3,s4,a4
 57a:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 57e:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 580:	c681                	beqz	a3,588 <vprintf+0x80>
 582:	9752                	add	a4,a4,s4
 584:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 588:	05878363          	beq	a5,s8,5ce <vprintf+0xc6>
      } else if(c0 == 'l' && c1 == 'd'){
 58c:	05978d63          	beq	a5,s9,5e6 <vprintf+0xde>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 590:	07500713          	li	a4,117
 594:	0ee78763          	beq	a5,a4,682 <vprintf+0x17a>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 598:	07800713          	li	a4,120
 59c:	12e78963          	beq	a5,a4,6ce <vprintf+0x1c6>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 5a0:	07000713          	li	a4,112
 5a4:	14e78e63          	beq	a5,a4,700 <vprintf+0x1f8>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 5a8:	06300713          	li	a4,99
 5ac:	18e78c63          	beq	a5,a4,744 <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 5b0:	07300713          	li	a4,115
 5b4:	1ae78263          	beq	a5,a4,758 <vprintf+0x250>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 5b8:	02500713          	li	a4,37
 5bc:	04e79563          	bne	a5,a4,606 <vprintf+0xfe>
        putc(fd, '%');
 5c0:	02500593          	li	a1,37
 5c4:	855a                	mv	a0,s6
 5c6:	e89ff0ef          	jal	44e <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 5ca:	4981                	li	s3,0
 5cc:	b761                	j	554 <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 10, 1);
 5ce:	008b8913          	add	s2,s7,8
 5d2:	4685                	li	a3,1
 5d4:	4629                	li	a2,10
 5d6:	000ba583          	lw	a1,0(s7)
 5da:	855a                	mv	a0,s6
 5dc:	e91ff0ef          	jal	46c <printint>
 5e0:	8bca                	mv	s7,s2
      state = 0;
 5e2:	4981                	li	s3,0
 5e4:	bf85                	j	554 <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'd'){
 5e6:	06400793          	li	a5,100
 5ea:	02f68963          	beq	a3,a5,61c <vprintf+0x114>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5ee:	06c00793          	li	a5,108
 5f2:	04f68263          	beq	a3,a5,636 <vprintf+0x12e>
      } else if(c0 == 'l' && c1 == 'u'){
 5f6:	07500793          	li	a5,117
 5fa:	0af68063          	beq	a3,a5,69a <vprintf+0x192>
      } else if(c0 == 'l' && c1 == 'x'){
 5fe:	07800793          	li	a5,120
 602:	0ef68263          	beq	a3,a5,6e6 <vprintf+0x1de>
        putc(fd, '%');
 606:	02500593          	li	a1,37
 60a:	855a                	mv	a0,s6
 60c:	e43ff0ef          	jal	44e <putc>
        putc(fd, c0);
 610:	85ca                	mv	a1,s2
 612:	855a                	mv	a0,s6
 614:	e3bff0ef          	jal	44e <putc>
      state = 0;
 618:	4981                	li	s3,0
 61a:	bf2d                	j	554 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 61c:	008b8913          	add	s2,s7,8
 620:	4685                	li	a3,1
 622:	4629                	li	a2,10
 624:	000bb583          	ld	a1,0(s7)
 628:	855a                	mv	a0,s6
 62a:	e43ff0ef          	jal	46c <printint>
        i += 1;
 62e:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 630:	8bca                	mv	s7,s2
      state = 0;
 632:	4981                	li	s3,0
        i += 1;
 634:	b705                	j	554 <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 636:	06400793          	li	a5,100
 63a:	02f60763          	beq	a2,a5,668 <vprintf+0x160>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 63e:	07500793          	li	a5,117
 642:	06f60963          	beq	a2,a5,6b4 <vprintf+0x1ac>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 646:	07800793          	li	a5,120
 64a:	faf61ee3          	bne	a2,a5,606 <vprintf+0xfe>
        printint(fd, va_arg(ap, uint64), 16, 0);
 64e:	008b8913          	add	s2,s7,8
 652:	4681                	li	a3,0
 654:	4641                	li	a2,16
 656:	000bb583          	ld	a1,0(s7)
 65a:	855a                	mv	a0,s6
 65c:	e11ff0ef          	jal	46c <printint>
        i += 2;
 660:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 662:	8bca                	mv	s7,s2
      state = 0;
 664:	4981                	li	s3,0
        i += 2;
 666:	b5fd                	j	554 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 668:	008b8913          	add	s2,s7,8
 66c:	4685                	li	a3,1
 66e:	4629                	li	a2,10
 670:	000bb583          	ld	a1,0(s7)
 674:	855a                	mv	a0,s6
 676:	df7ff0ef          	jal	46c <printint>
        i += 2;
 67a:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 67c:	8bca                	mv	s7,s2
      state = 0;
 67e:	4981                	li	s3,0
        i += 2;
 680:	bdd1                	j	554 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint32), 10, 0);
 682:	008b8913          	add	s2,s7,8
 686:	4681                	li	a3,0
 688:	4629                	li	a2,10
 68a:	000be583          	lwu	a1,0(s7)
 68e:	855a                	mv	a0,s6
 690:	dddff0ef          	jal	46c <printint>
 694:	8bca                	mv	s7,s2
      state = 0;
 696:	4981                	li	s3,0
 698:	bd75                	j	554 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 69a:	008b8913          	add	s2,s7,8
 69e:	4681                	li	a3,0
 6a0:	4629                	li	a2,10
 6a2:	000bb583          	ld	a1,0(s7)
 6a6:	855a                	mv	a0,s6
 6a8:	dc5ff0ef          	jal	46c <printint>
        i += 1;
 6ac:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 6ae:	8bca                	mv	s7,s2
      state = 0;
 6b0:	4981                	li	s3,0
        i += 1;
 6b2:	b54d                	j	554 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6b4:	008b8913          	add	s2,s7,8
 6b8:	4681                	li	a3,0
 6ba:	4629                	li	a2,10
 6bc:	000bb583          	ld	a1,0(s7)
 6c0:	855a                	mv	a0,s6
 6c2:	dabff0ef          	jal	46c <printint>
        i += 2;
 6c6:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 6c8:	8bca                	mv	s7,s2
      state = 0;
 6ca:	4981                	li	s3,0
        i += 2;
 6cc:	b561                	j	554 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint32), 16, 0);
 6ce:	008b8913          	add	s2,s7,8
 6d2:	4681                	li	a3,0
 6d4:	4641                	li	a2,16
 6d6:	000be583          	lwu	a1,0(s7)
 6da:	855a                	mv	a0,s6
 6dc:	d91ff0ef          	jal	46c <printint>
 6e0:	8bca                	mv	s7,s2
      state = 0;
 6e2:	4981                	li	s3,0
 6e4:	bd85                	j	554 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6e6:	008b8913          	add	s2,s7,8
 6ea:	4681                	li	a3,0
 6ec:	4641                	li	a2,16
 6ee:	000bb583          	ld	a1,0(s7)
 6f2:	855a                	mv	a0,s6
 6f4:	d79ff0ef          	jal	46c <printint>
        i += 1;
 6f8:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 6fa:	8bca                	mv	s7,s2
      state = 0;
 6fc:	4981                	li	s3,0
        i += 1;
 6fe:	bd99                	j	554 <vprintf+0x4c>
        printptr(fd, va_arg(ap, uint64));
 700:	008b8d13          	add	s10,s7,8
 704:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 708:	03000593          	li	a1,48
 70c:	855a                	mv	a0,s6
 70e:	d41ff0ef          	jal	44e <putc>
  putc(fd, 'x');
 712:	07800593          	li	a1,120
 716:	855a                	mv	a0,s6
 718:	d37ff0ef          	jal	44e <putc>
 71c:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 71e:	00000b97          	auipc	s7,0x0
 722:	2a2b8b93          	add	s7,s7,674 # 9c0 <digits>
 726:	03c9d793          	srl	a5,s3,0x3c
 72a:	97de                	add	a5,a5,s7
 72c:	0007c583          	lbu	a1,0(a5)
 730:	855a                	mv	a0,s6
 732:	d1dff0ef          	jal	44e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 736:	0992                	sll	s3,s3,0x4
 738:	397d                	addw	s2,s2,-1
 73a:	fe0916e3          	bnez	s2,726 <vprintf+0x21e>
        printptr(fd, va_arg(ap, uint64));
 73e:	8bea                	mv	s7,s10
      state = 0;
 740:	4981                	li	s3,0
 742:	bd09                	j	554 <vprintf+0x4c>
        putc(fd, va_arg(ap, uint32));
 744:	008b8913          	add	s2,s7,8
 748:	000bc583          	lbu	a1,0(s7)
 74c:	855a                	mv	a0,s6
 74e:	d01ff0ef          	jal	44e <putc>
 752:	8bca                	mv	s7,s2
      state = 0;
 754:	4981                	li	s3,0
 756:	bbfd                	j	554 <vprintf+0x4c>
        if((s = va_arg(ap, char*)) == 0)
 758:	008b8993          	add	s3,s7,8
 75c:	000bb903          	ld	s2,0(s7)
 760:	00090f63          	beqz	s2,77e <vprintf+0x276>
        for(; *s; s++)
 764:	00094583          	lbu	a1,0(s2)
 768:	c195                	beqz	a1,78c <vprintf+0x284>
          putc(fd, *s);
 76a:	855a                	mv	a0,s6
 76c:	ce3ff0ef          	jal	44e <putc>
        for(; *s; s++)
 770:	0905                	add	s2,s2,1
 772:	00094583          	lbu	a1,0(s2)
 776:	f9f5                	bnez	a1,76a <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 778:	8bce                	mv	s7,s3
      state = 0;
 77a:	4981                	li	s3,0
 77c:	bbe1                	j	554 <vprintf+0x4c>
          s = "(null)";
 77e:	00000917          	auipc	s2,0x0
 782:	23a90913          	add	s2,s2,570 # 9b8 <malloc+0x12c>
        for(; *s; s++)
 786:	02800593          	li	a1,40
 78a:	b7c5                	j	76a <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 78c:	8bce                	mv	s7,s3
      state = 0;
 78e:	4981                	li	s3,0
 790:	b3d1                	j	554 <vprintf+0x4c>
    }
  }
}
 792:	60e6                	ld	ra,88(sp)
 794:	6446                	ld	s0,80(sp)
 796:	64a6                	ld	s1,72(sp)
 798:	6906                	ld	s2,64(sp)
 79a:	79e2                	ld	s3,56(sp)
 79c:	7a42                	ld	s4,48(sp)
 79e:	7aa2                	ld	s5,40(sp)
 7a0:	7b02                	ld	s6,32(sp)
 7a2:	6be2                	ld	s7,24(sp)
 7a4:	6c42                	ld	s8,16(sp)
 7a6:	6ca2                	ld	s9,8(sp)
 7a8:	6d02                	ld	s10,0(sp)
 7aa:	6125                	add	sp,sp,96
 7ac:	8082                	ret

00000000000007ae <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7ae:	715d                	add	sp,sp,-80
 7b0:	ec06                	sd	ra,24(sp)
 7b2:	e822                	sd	s0,16(sp)
 7b4:	1000                	add	s0,sp,32
 7b6:	e010                	sd	a2,0(s0)
 7b8:	e414                	sd	a3,8(s0)
 7ba:	e818                	sd	a4,16(s0)
 7bc:	ec1c                	sd	a5,24(s0)
 7be:	03043023          	sd	a6,32(s0)
 7c2:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7c6:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7ca:	8622                	mv	a2,s0
 7cc:	d3dff0ef          	jal	508 <vprintf>
}
 7d0:	60e2                	ld	ra,24(sp)
 7d2:	6442                	ld	s0,16(sp)
 7d4:	6161                	add	sp,sp,80
 7d6:	8082                	ret

00000000000007d8 <printf>:

void
printf(const char *fmt, ...)
{
 7d8:	711d                	add	sp,sp,-96
 7da:	ec06                	sd	ra,24(sp)
 7dc:	e822                	sd	s0,16(sp)
 7de:	1000                	add	s0,sp,32
 7e0:	e40c                	sd	a1,8(s0)
 7e2:	e810                	sd	a2,16(s0)
 7e4:	ec14                	sd	a3,24(s0)
 7e6:	f018                	sd	a4,32(s0)
 7e8:	f41c                	sd	a5,40(s0)
 7ea:	03043823          	sd	a6,48(s0)
 7ee:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7f2:	00840613          	add	a2,s0,8
 7f6:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7fa:	85aa                	mv	a1,a0
 7fc:	4505                	li	a0,1
 7fe:	d0bff0ef          	jal	508 <vprintf>
}
 802:	60e2                	ld	ra,24(sp)
 804:	6442                	ld	s0,16(sp)
 806:	6125                	add	sp,sp,96
 808:	8082                	ret

000000000000080a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 80a:	1141                	add	sp,sp,-16
 80c:	e422                	sd	s0,8(sp)
 80e:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 810:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 814:	00000797          	auipc	a5,0x0
 818:	7ec7b783          	ld	a5,2028(a5) # 1000 <freep>
 81c:	a02d                	j	846 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 81e:	4618                	lw	a4,8(a2)
 820:	9f2d                	addw	a4,a4,a1
 822:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 826:	6398                	ld	a4,0(a5)
 828:	6310                	ld	a2,0(a4)
 82a:	a83d                	j	868 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 82c:	ff852703          	lw	a4,-8(a0)
 830:	9f31                	addw	a4,a4,a2
 832:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 834:	ff053683          	ld	a3,-16(a0)
 838:	a091                	j	87c <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 83a:	6398                	ld	a4,0(a5)
 83c:	00e7e463          	bltu	a5,a4,844 <free+0x3a>
 840:	00e6ea63          	bltu	a3,a4,854 <free+0x4a>
{
 844:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 846:	fed7fae3          	bgeu	a5,a3,83a <free+0x30>
 84a:	6398                	ld	a4,0(a5)
 84c:	00e6e463          	bltu	a3,a4,854 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 850:	fee7eae3          	bltu	a5,a4,844 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 854:	ff852583          	lw	a1,-8(a0)
 858:	6390                	ld	a2,0(a5)
 85a:	02059813          	sll	a6,a1,0x20
 85e:	01c85713          	srl	a4,a6,0x1c
 862:	9736                	add	a4,a4,a3
 864:	fae60de3          	beq	a2,a4,81e <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 868:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 86c:	4790                	lw	a2,8(a5)
 86e:	02061593          	sll	a1,a2,0x20
 872:	01c5d713          	srl	a4,a1,0x1c
 876:	973e                	add	a4,a4,a5
 878:	fae68ae3          	beq	a3,a4,82c <free+0x22>
    p->s.ptr = bp->s.ptr;
 87c:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 87e:	00000717          	auipc	a4,0x0
 882:	78f73123          	sd	a5,1922(a4) # 1000 <freep>
}
 886:	6422                	ld	s0,8(sp)
 888:	0141                	add	sp,sp,16
 88a:	8082                	ret

000000000000088c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 88c:	7139                	add	sp,sp,-64
 88e:	fc06                	sd	ra,56(sp)
 890:	f822                	sd	s0,48(sp)
 892:	f426                	sd	s1,40(sp)
 894:	f04a                	sd	s2,32(sp)
 896:	ec4e                	sd	s3,24(sp)
 898:	e852                	sd	s4,16(sp)
 89a:	e456                	sd	s5,8(sp)
 89c:	e05a                	sd	s6,0(sp)
 89e:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8a0:	02051493          	sll	s1,a0,0x20
 8a4:	9081                	srl	s1,s1,0x20
 8a6:	04bd                	add	s1,s1,15
 8a8:	8091                	srl	s1,s1,0x4
 8aa:	0014899b          	addw	s3,s1,1
 8ae:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 8b0:	00000517          	auipc	a0,0x0
 8b4:	75053503          	ld	a0,1872(a0) # 1000 <freep>
 8b8:	c515                	beqz	a0,8e4 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8ba:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8bc:	4798                	lw	a4,8(a5)
 8be:	02977f63          	bgeu	a4,s1,8fc <malloc+0x70>
  if(nu < 4096)
 8c2:	8a4e                	mv	s4,s3
 8c4:	0009871b          	sext.w	a4,s3
 8c8:	6685                	lui	a3,0x1
 8ca:	00d77363          	bgeu	a4,a3,8d0 <malloc+0x44>
 8ce:	6a05                	lui	s4,0x1
 8d0:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8d4:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8d8:	00000917          	auipc	s2,0x0
 8dc:	72890913          	add	s2,s2,1832 # 1000 <freep>
  if(p == SBRK_ERROR)
 8e0:	5afd                	li	s5,-1
 8e2:	a885                	j	952 <malloc+0xc6>
    base.s.ptr = freep = prevp = &base;
 8e4:	00001797          	auipc	a5,0x1
 8e8:	92478793          	add	a5,a5,-1756 # 1208 <base>
 8ec:	00000717          	auipc	a4,0x0
 8f0:	70f73a23          	sd	a5,1812(a4) # 1000 <freep>
 8f4:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8f6:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8fa:	b7e1                	j	8c2 <malloc+0x36>
      if(p->s.size == nunits)
 8fc:	02e48c63          	beq	s1,a4,934 <malloc+0xa8>
        p->s.size -= nunits;
 900:	4137073b          	subw	a4,a4,s3
 904:	c798                	sw	a4,8(a5)
        p += p->s.size;
 906:	02071693          	sll	a3,a4,0x20
 90a:	01c6d713          	srl	a4,a3,0x1c
 90e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 910:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 914:	00000717          	auipc	a4,0x0
 918:	6ea73623          	sd	a0,1772(a4) # 1000 <freep>
      return (void*)(p + 1);
 91c:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 920:	70e2                	ld	ra,56(sp)
 922:	7442                	ld	s0,48(sp)
 924:	74a2                	ld	s1,40(sp)
 926:	7902                	ld	s2,32(sp)
 928:	69e2                	ld	s3,24(sp)
 92a:	6a42                	ld	s4,16(sp)
 92c:	6aa2                	ld	s5,8(sp)
 92e:	6b02                	ld	s6,0(sp)
 930:	6121                	add	sp,sp,64
 932:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 934:	6398                	ld	a4,0(a5)
 936:	e118                	sd	a4,0(a0)
 938:	bff1                	j	914 <malloc+0x88>
  hp->s.size = nu;
 93a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 93e:	0541                	add	a0,a0,16
 940:	ecbff0ef          	jal	80a <free>
  return freep;
 944:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 948:	dd61                	beqz	a0,920 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 94a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 94c:	4798                	lw	a4,8(a5)
 94e:	fa9777e3          	bgeu	a4,s1,8fc <malloc+0x70>
    if(p == freep)
 952:	00093703          	ld	a4,0(s2)
 956:	853e                	mv	a0,a5
 958:	fef719e3          	bne	a4,a5,94a <malloc+0xbe>
  p = sbrk(nu * sizeof(Header));
 95c:	8552                	mv	a0,s4
 95e:	a05ff0ef          	jal	362 <sbrk>
  if(p == SBRK_ERROR)
 962:	fd551ce3          	bne	a0,s5,93a <malloc+0xae>
        return 0;
 966:	4501                	li	a0,0
 968:	bf65                	j	920 <malloc+0x94>
