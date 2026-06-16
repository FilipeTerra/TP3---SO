
user/_wc:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
   0:	7119                	add	sp,sp,-128
   2:	fc86                	sd	ra,120(sp)
   4:	f8a2                	sd	s0,112(sp)
   6:	f4a6                	sd	s1,104(sp)
   8:	f0ca                	sd	s2,96(sp)
   a:	ecce                	sd	s3,88(sp)
   c:	e8d2                	sd	s4,80(sp)
   e:	e4d6                	sd	s5,72(sp)
  10:	e0da                	sd	s6,64(sp)
  12:	fc5e                	sd	s7,56(sp)
  14:	f862                	sd	s8,48(sp)
  16:	f466                	sd	s9,40(sp)
  18:	f06a                	sd	s10,32(sp)
  1a:	ec6e                	sd	s11,24(sp)
  1c:	0100                	add	s0,sp,128
  1e:	f8a43423          	sd	a0,-120(s0)
  22:	f8b43023          	sd	a1,-128(s0)
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  26:	4901                	li	s2,0
  l = w = c = 0;
  28:	4d01                	li	s10,0
  2a:	4c81                	li	s9,0
  2c:	4c01                	li	s8,0
  while((n = read(fd, buf, sizeof(buf))) > 0){
  2e:	00001d97          	auipc	s11,0x1
  32:	fe2d8d93          	add	s11,s11,-30 # 1010 <buf>
    for(i=0; i<n; i++){
      c++;
      if(buf[i] == '\n')
  36:	4aa9                	li	s5,10
        l++;
      if(strchr(" \r\t\n\v", buf[i]))
  38:	00001a17          	auipc	s4,0x1
  3c:	988a0a13          	add	s4,s4,-1656 # 9c0 <malloc+0xe0>
        inword = 0;
  40:	4b81                	li	s7,0
  while((n = read(fd, buf, sizeof(buf))) > 0){
  42:	a035                	j	6e <wc+0x6e>
      if(strchr(" \r\t\n\v", buf[i]))
  44:	8552                	mv	a0,s4
  46:	1b4000ef          	jal	1fa <strchr>
  4a:	c919                	beqz	a0,60 <wc+0x60>
        inword = 0;
  4c:	895e                	mv	s2,s7
    for(i=0; i<n; i++){
  4e:	0485                	add	s1,s1,1
  50:	00998d63          	beq	s3,s1,6a <wc+0x6a>
      if(buf[i] == '\n')
  54:	0004c583          	lbu	a1,0(s1)
  58:	ff5596e3          	bne	a1,s5,44 <wc+0x44>
        l++;
  5c:	2c05                	addw	s8,s8,1
  5e:	b7dd                	j	44 <wc+0x44>
      else if(!inword){
  60:	fe0917e3          	bnez	s2,4e <wc+0x4e>
        w++;
  64:	2c85                	addw	s9,s9,1
        inword = 1;
  66:	4905                	li	s2,1
  68:	b7dd                	j	4e <wc+0x4e>
      c++;
  6a:	01ab0d3b          	addw	s10,s6,s10
  while((n = read(fd, buf, sizeof(buf))) > 0){
  6e:	20000613          	li	a2,512
  72:	85ee                	mv	a1,s11
  74:	f8843503          	ld	a0,-120(s0)
  78:	38a000ef          	jal	402 <read>
  7c:	8b2a                	mv	s6,a0
  7e:	00a05963          	blez	a0,90 <wc+0x90>
    for(i=0; i<n; i++){
  82:	00001497          	auipc	s1,0x1
  86:	f8e48493          	add	s1,s1,-114 # 1010 <buf>
  8a:	009509b3          	add	s3,a0,s1
  8e:	b7d9                	j	54 <wc+0x54>
      }
    }
  }
  if(n < 0){
  90:	02054c63          	bltz	a0,c8 <wc+0xc8>
    printf("wc: read error\n");
    exit(1);
  }
  printf("%d %d %d %s\n", l, w, c, name);
  94:	f8043703          	ld	a4,-128(s0)
  98:	86ea                	mv	a3,s10
  9a:	8666                	mv	a2,s9
  9c:	85e2                	mv	a1,s8
  9e:	00001517          	auipc	a0,0x1
  a2:	93a50513          	add	a0,a0,-1734 # 9d8 <malloc+0xf8>
  a6:	786000ef          	jal	82c <printf>
}
  aa:	70e6                	ld	ra,120(sp)
  ac:	7446                	ld	s0,112(sp)
  ae:	74a6                	ld	s1,104(sp)
  b0:	7906                	ld	s2,96(sp)
  b2:	69e6                	ld	s3,88(sp)
  b4:	6a46                	ld	s4,80(sp)
  b6:	6aa6                	ld	s5,72(sp)
  b8:	6b06                	ld	s6,64(sp)
  ba:	7be2                	ld	s7,56(sp)
  bc:	7c42                	ld	s8,48(sp)
  be:	7ca2                	ld	s9,40(sp)
  c0:	7d02                	ld	s10,32(sp)
  c2:	6de2                	ld	s11,24(sp)
  c4:	6109                	add	sp,sp,128
  c6:	8082                	ret
    printf("wc: read error\n");
  c8:	00001517          	auipc	a0,0x1
  cc:	90050513          	add	a0,a0,-1792 # 9c8 <malloc+0xe8>
  d0:	75c000ef          	jal	82c <printf>
    exit(1);
  d4:	4505                	li	a0,1
  d6:	314000ef          	jal	3ea <exit>

00000000000000da <main>:

int
main(int argc, char *argv[])
{
  da:	7179                	add	sp,sp,-48
  dc:	f406                	sd	ra,40(sp)
  de:	f022                	sd	s0,32(sp)
  e0:	ec26                	sd	s1,24(sp)
  e2:	e84a                	sd	s2,16(sp)
  e4:	e44e                	sd	s3,8(sp)
  e6:	1800                	add	s0,sp,48
  int fd, i;

  if(argc <= 1){
  e8:	4785                	li	a5,1
  ea:	04a7d163          	bge	a5,a0,12c <main+0x52>
  ee:	00858913          	add	s2,a1,8
  f2:	ffe5099b          	addw	s3,a0,-2
  f6:	02099793          	sll	a5,s3,0x20
  fa:	01d7d993          	srl	s3,a5,0x1d
  fe:	05c1                	add	a1,a1,16
 100:	99ae                	add	s3,s3,a1
    wc(0, "");
    exit(0);
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], O_RDONLY)) < 0){
 102:	4581                	li	a1,0
 104:	00093503          	ld	a0,0(s2)
 108:	322000ef          	jal	42a <open>
 10c:	84aa                	mv	s1,a0
 10e:	02054963          	bltz	a0,140 <main+0x66>
      printf("wc: cannot open %s\n", argv[i]);
      exit(1);
    }
    wc(fd, argv[i]);
 112:	00093583          	ld	a1,0(s2)
 116:	eebff0ef          	jal	0 <wc>
    close(fd);
 11a:	8526                	mv	a0,s1
 11c:	2f6000ef          	jal	412 <close>
  for(i = 1; i < argc; i++){
 120:	0921                	add	s2,s2,8
 122:	ff3910e3          	bne	s2,s3,102 <main+0x28>
  }
  exit(0);
 126:	4501                	li	a0,0
 128:	2c2000ef          	jal	3ea <exit>
    wc(0, "");
 12c:	00001597          	auipc	a1,0x1
 130:	8bc58593          	add	a1,a1,-1860 # 9e8 <malloc+0x108>
 134:	4501                	li	a0,0
 136:	ecbff0ef          	jal	0 <wc>
    exit(0);
 13a:	4501                	li	a0,0
 13c:	2ae000ef          	jal	3ea <exit>
      printf("wc: cannot open %s\n", argv[i]);
 140:	00093583          	ld	a1,0(s2)
 144:	00001517          	auipc	a0,0x1
 148:	8ac50513          	add	a0,a0,-1876 # 9f0 <malloc+0x110>
 14c:	6e0000ef          	jal	82c <printf>
      exit(1);
 150:	4505                	li	a0,1
 152:	298000ef          	jal	3ea <exit>

0000000000000156 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
 156:	1141                	add	sp,sp,-16
 158:	e406                	sd	ra,8(sp)
 15a:	e022                	sd	s0,0(sp)
 15c:	0800                	add	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
 15e:	f7dff0ef          	jal	da <main>
  exit(r);
 162:	288000ef          	jal	3ea <exit>

0000000000000166 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 166:	1141                	add	sp,sp,-16
 168:	e422                	sd	s0,8(sp)
 16a:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 16c:	87aa                	mv	a5,a0
 16e:	0585                	add	a1,a1,1
 170:	0785                	add	a5,a5,1
 172:	fff5c703          	lbu	a4,-1(a1)
 176:	fee78fa3          	sb	a4,-1(a5)
 17a:	fb75                	bnez	a4,16e <strcpy+0x8>
    ;
  return os;
}
 17c:	6422                	ld	s0,8(sp)
 17e:	0141                	add	sp,sp,16
 180:	8082                	ret

0000000000000182 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 182:	1141                	add	sp,sp,-16
 184:	e422                	sd	s0,8(sp)
 186:	0800                	add	s0,sp,16
  while(*p && *p == *q)
 188:	00054783          	lbu	a5,0(a0)
 18c:	cb91                	beqz	a5,1a0 <strcmp+0x1e>
 18e:	0005c703          	lbu	a4,0(a1)
 192:	00f71763          	bne	a4,a5,1a0 <strcmp+0x1e>
    p++, q++;
 196:	0505                	add	a0,a0,1
 198:	0585                	add	a1,a1,1
  while(*p && *p == *q)
 19a:	00054783          	lbu	a5,0(a0)
 19e:	fbe5                	bnez	a5,18e <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 1a0:	0005c503          	lbu	a0,0(a1)
}
 1a4:	40a7853b          	subw	a0,a5,a0
 1a8:	6422                	ld	s0,8(sp)
 1aa:	0141                	add	sp,sp,16
 1ac:	8082                	ret

00000000000001ae <strlen>:

uint
strlen(const char *s)
{
 1ae:	1141                	add	sp,sp,-16
 1b0:	e422                	sd	s0,8(sp)
 1b2:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1b4:	00054783          	lbu	a5,0(a0)
 1b8:	cf91                	beqz	a5,1d4 <strlen+0x26>
 1ba:	0505                	add	a0,a0,1
 1bc:	87aa                	mv	a5,a0
 1be:	86be                	mv	a3,a5
 1c0:	0785                	add	a5,a5,1
 1c2:	fff7c703          	lbu	a4,-1(a5)
 1c6:	ff65                	bnez	a4,1be <strlen+0x10>
 1c8:	40a6853b          	subw	a0,a3,a0
 1cc:	2505                	addw	a0,a0,1
    ;
  return n;
}
 1ce:	6422                	ld	s0,8(sp)
 1d0:	0141                	add	sp,sp,16
 1d2:	8082                	ret
  for(n = 0; s[n]; n++)
 1d4:	4501                	li	a0,0
 1d6:	bfe5                	j	1ce <strlen+0x20>

00000000000001d8 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1d8:	1141                	add	sp,sp,-16
 1da:	e422                	sd	s0,8(sp)
 1dc:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1de:	ca19                	beqz	a2,1f4 <memset+0x1c>
 1e0:	87aa                	mv	a5,a0
 1e2:	1602                	sll	a2,a2,0x20
 1e4:	9201                	srl	a2,a2,0x20
 1e6:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1ea:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1ee:	0785                	add	a5,a5,1
 1f0:	fee79de3          	bne	a5,a4,1ea <memset+0x12>
  }
  return dst;
}
 1f4:	6422                	ld	s0,8(sp)
 1f6:	0141                	add	sp,sp,16
 1f8:	8082                	ret

00000000000001fa <strchr>:

char*
strchr(const char *s, char c)
{
 1fa:	1141                	add	sp,sp,-16
 1fc:	e422                	sd	s0,8(sp)
 1fe:	0800                	add	s0,sp,16
  for(; *s; s++)
 200:	00054783          	lbu	a5,0(a0)
 204:	cb99                	beqz	a5,21a <strchr+0x20>
    if(*s == c)
 206:	00f58763          	beq	a1,a5,214 <strchr+0x1a>
  for(; *s; s++)
 20a:	0505                	add	a0,a0,1
 20c:	00054783          	lbu	a5,0(a0)
 210:	fbfd                	bnez	a5,206 <strchr+0xc>
      return (char*)s;
  return 0;
 212:	4501                	li	a0,0
}
 214:	6422                	ld	s0,8(sp)
 216:	0141                	add	sp,sp,16
 218:	8082                	ret
  return 0;
 21a:	4501                	li	a0,0
 21c:	bfe5                	j	214 <strchr+0x1a>

000000000000021e <gets>:

char*
gets(char *buf, int max)
{
 21e:	711d                	add	sp,sp,-96
 220:	ec86                	sd	ra,88(sp)
 222:	e8a2                	sd	s0,80(sp)
 224:	e4a6                	sd	s1,72(sp)
 226:	e0ca                	sd	s2,64(sp)
 228:	fc4e                	sd	s3,56(sp)
 22a:	f852                	sd	s4,48(sp)
 22c:	f456                	sd	s5,40(sp)
 22e:	f05a                	sd	s6,32(sp)
 230:	ec5e                	sd	s7,24(sp)
 232:	1080                	add	s0,sp,96
 234:	8baa                	mv	s7,a0
 236:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 238:	892a                	mv	s2,a0
 23a:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 23c:	4aa9                	li	s5,10
 23e:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 240:	89a6                	mv	s3,s1
 242:	2485                	addw	s1,s1,1
 244:	0344d663          	bge	s1,s4,270 <gets+0x52>
    cc = read(0, &c, 1);
 248:	4605                	li	a2,1
 24a:	faf40593          	add	a1,s0,-81
 24e:	4501                	li	a0,0
 250:	1b2000ef          	jal	402 <read>
    if(cc < 1)
 254:	00a05e63          	blez	a0,270 <gets+0x52>
    buf[i++] = c;
 258:	faf44783          	lbu	a5,-81(s0)
 25c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 260:	01578763          	beq	a5,s5,26e <gets+0x50>
 264:	0905                	add	s2,s2,1
 266:	fd679de3          	bne	a5,s6,240 <gets+0x22>
  for(i=0; i+1 < max; ){
 26a:	89a6                	mv	s3,s1
 26c:	a011                	j	270 <gets+0x52>
 26e:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 270:	99de                	add	s3,s3,s7
 272:	00098023          	sb	zero,0(s3)
  return buf;
}
 276:	855e                	mv	a0,s7
 278:	60e6                	ld	ra,88(sp)
 27a:	6446                	ld	s0,80(sp)
 27c:	64a6                	ld	s1,72(sp)
 27e:	6906                	ld	s2,64(sp)
 280:	79e2                	ld	s3,56(sp)
 282:	7a42                	ld	s4,48(sp)
 284:	7aa2                	ld	s5,40(sp)
 286:	7b02                	ld	s6,32(sp)
 288:	6be2                	ld	s7,24(sp)
 28a:	6125                	add	sp,sp,96
 28c:	8082                	ret

000000000000028e <stat>:

int
stat(const char *n, struct stat *st)
{
 28e:	1101                	add	sp,sp,-32
 290:	ec06                	sd	ra,24(sp)
 292:	e822                	sd	s0,16(sp)
 294:	e426                	sd	s1,8(sp)
 296:	e04a                	sd	s2,0(sp)
 298:	1000                	add	s0,sp,32
 29a:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 29c:	4581                	li	a1,0
 29e:	18c000ef          	jal	42a <open>
  if(fd < 0)
 2a2:	02054163          	bltz	a0,2c4 <stat+0x36>
 2a6:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2a8:	85ca                	mv	a1,s2
 2aa:	198000ef          	jal	442 <fstat>
 2ae:	892a                	mv	s2,a0
  close(fd);
 2b0:	8526                	mv	a0,s1
 2b2:	160000ef          	jal	412 <close>
  return r;
}
 2b6:	854a                	mv	a0,s2
 2b8:	60e2                	ld	ra,24(sp)
 2ba:	6442                	ld	s0,16(sp)
 2bc:	64a2                	ld	s1,8(sp)
 2be:	6902                	ld	s2,0(sp)
 2c0:	6105                	add	sp,sp,32
 2c2:	8082                	ret
    return -1;
 2c4:	597d                	li	s2,-1
 2c6:	bfc5                	j	2b6 <stat+0x28>

00000000000002c8 <atoi>:

int
atoi(const char *s)
{
 2c8:	1141                	add	sp,sp,-16
 2ca:	e422                	sd	s0,8(sp)
 2cc:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2ce:	00054683          	lbu	a3,0(a0)
 2d2:	fd06879b          	addw	a5,a3,-48
 2d6:	0ff7f793          	zext.b	a5,a5
 2da:	4625                	li	a2,9
 2dc:	02f66863          	bltu	a2,a5,30c <atoi+0x44>
 2e0:	872a                	mv	a4,a0
  n = 0;
 2e2:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2e4:	0705                	add	a4,a4,1
 2e6:	0025179b          	sllw	a5,a0,0x2
 2ea:	9fa9                	addw	a5,a5,a0
 2ec:	0017979b          	sllw	a5,a5,0x1
 2f0:	9fb5                	addw	a5,a5,a3
 2f2:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2f6:	00074683          	lbu	a3,0(a4)
 2fa:	fd06879b          	addw	a5,a3,-48
 2fe:	0ff7f793          	zext.b	a5,a5
 302:	fef671e3          	bgeu	a2,a5,2e4 <atoi+0x1c>
  return n;
}
 306:	6422                	ld	s0,8(sp)
 308:	0141                	add	sp,sp,16
 30a:	8082                	ret
  n = 0;
 30c:	4501                	li	a0,0
 30e:	bfe5                	j	306 <atoi+0x3e>

0000000000000310 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 310:	1141                	add	sp,sp,-16
 312:	e422                	sd	s0,8(sp)
 314:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 316:	02b57463          	bgeu	a0,a1,33e <memmove+0x2e>
    while(n-- > 0)
 31a:	00c05f63          	blez	a2,338 <memmove+0x28>
 31e:	1602                	sll	a2,a2,0x20
 320:	9201                	srl	a2,a2,0x20
 322:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 326:	872a                	mv	a4,a0
      *dst++ = *src++;
 328:	0585                	add	a1,a1,1
 32a:	0705                	add	a4,a4,1
 32c:	fff5c683          	lbu	a3,-1(a1)
 330:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 334:	fee79ae3          	bne	a5,a4,328 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 338:	6422                	ld	s0,8(sp)
 33a:	0141                	add	sp,sp,16
 33c:	8082                	ret
    dst += n;
 33e:	00c50733          	add	a4,a0,a2
    src += n;
 342:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 344:	fec05ae3          	blez	a2,338 <memmove+0x28>
 348:	fff6079b          	addw	a5,a2,-1
 34c:	1782                	sll	a5,a5,0x20
 34e:	9381                	srl	a5,a5,0x20
 350:	fff7c793          	not	a5,a5
 354:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 356:	15fd                	add	a1,a1,-1
 358:	177d                	add	a4,a4,-1
 35a:	0005c683          	lbu	a3,0(a1)
 35e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 362:	fee79ae3          	bne	a5,a4,356 <memmove+0x46>
 366:	bfc9                	j	338 <memmove+0x28>

0000000000000368 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 368:	1141                	add	sp,sp,-16
 36a:	e422                	sd	s0,8(sp)
 36c:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 36e:	ca05                	beqz	a2,39e <memcmp+0x36>
 370:	fff6069b          	addw	a3,a2,-1
 374:	1682                	sll	a3,a3,0x20
 376:	9281                	srl	a3,a3,0x20
 378:	0685                	add	a3,a3,1
 37a:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 37c:	00054783          	lbu	a5,0(a0)
 380:	0005c703          	lbu	a4,0(a1)
 384:	00e79863          	bne	a5,a4,394 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 388:	0505                	add	a0,a0,1
    p2++;
 38a:	0585                	add	a1,a1,1
  while (n-- > 0) {
 38c:	fed518e3          	bne	a0,a3,37c <memcmp+0x14>
  }
  return 0;
 390:	4501                	li	a0,0
 392:	a019                	j	398 <memcmp+0x30>
      return *p1 - *p2;
 394:	40e7853b          	subw	a0,a5,a4
}
 398:	6422                	ld	s0,8(sp)
 39a:	0141                	add	sp,sp,16
 39c:	8082                	ret
  return 0;
 39e:	4501                	li	a0,0
 3a0:	bfe5                	j	398 <memcmp+0x30>

00000000000003a2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3a2:	1141                	add	sp,sp,-16
 3a4:	e406                	sd	ra,8(sp)
 3a6:	e022                	sd	s0,0(sp)
 3a8:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 3aa:	f67ff0ef          	jal	310 <memmove>
}
 3ae:	60a2                	ld	ra,8(sp)
 3b0:	6402                	ld	s0,0(sp)
 3b2:	0141                	add	sp,sp,16
 3b4:	8082                	ret

00000000000003b6 <sbrk>:

char *
sbrk(int n) {
 3b6:	1141                	add	sp,sp,-16
 3b8:	e406                	sd	ra,8(sp)
 3ba:	e022                	sd	s0,0(sp)
 3bc:	0800                	add	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 3be:	4585                	li	a1,1
 3c0:	0b2000ef          	jal	472 <sys_sbrk>
}
 3c4:	60a2                	ld	ra,8(sp)
 3c6:	6402                	ld	s0,0(sp)
 3c8:	0141                	add	sp,sp,16
 3ca:	8082                	ret

00000000000003cc <sbrklazy>:

char *
sbrklazy(int n) {
 3cc:	1141                	add	sp,sp,-16
 3ce:	e406                	sd	ra,8(sp)
 3d0:	e022                	sd	s0,0(sp)
 3d2:	0800                	add	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 3d4:	4589                	li	a1,2
 3d6:	09c000ef          	jal	472 <sys_sbrk>
}
 3da:	60a2                	ld	ra,8(sp)
 3dc:	6402                	ld	s0,0(sp)
 3de:	0141                	add	sp,sp,16
 3e0:	8082                	ret

00000000000003e2 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3e2:	4885                	li	a7,1
 ecall
 3e4:	00000073          	ecall
 ret
 3e8:	8082                	ret

00000000000003ea <exit>:
.global exit
exit:
 li a7, SYS_exit
 3ea:	4889                	li	a7,2
 ecall
 3ec:	00000073          	ecall
 ret
 3f0:	8082                	ret

00000000000003f2 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3f2:	488d                	li	a7,3
 ecall
 3f4:	00000073          	ecall
 ret
 3f8:	8082                	ret

00000000000003fa <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3fa:	4891                	li	a7,4
 ecall
 3fc:	00000073          	ecall
 ret
 400:	8082                	ret

0000000000000402 <read>:
.global read
read:
 li a7, SYS_read
 402:	4895                	li	a7,5
 ecall
 404:	00000073          	ecall
 ret
 408:	8082                	ret

000000000000040a <write>:
.global write
write:
 li a7, SYS_write
 40a:	48c1                	li	a7,16
 ecall
 40c:	00000073          	ecall
 ret
 410:	8082                	ret

0000000000000412 <close>:
.global close
close:
 li a7, SYS_close
 412:	48d5                	li	a7,21
 ecall
 414:	00000073          	ecall
 ret
 418:	8082                	ret

000000000000041a <kill>:
.global kill
kill:
 li a7, SYS_kill
 41a:	4899                	li	a7,6
 ecall
 41c:	00000073          	ecall
 ret
 420:	8082                	ret

0000000000000422 <exec>:
.global exec
exec:
 li a7, SYS_exec
 422:	489d                	li	a7,7
 ecall
 424:	00000073          	ecall
 ret
 428:	8082                	ret

000000000000042a <open>:
.global open
open:
 li a7, SYS_open
 42a:	48bd                	li	a7,15
 ecall
 42c:	00000073          	ecall
 ret
 430:	8082                	ret

0000000000000432 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 432:	48c5                	li	a7,17
 ecall
 434:	00000073          	ecall
 ret
 438:	8082                	ret

000000000000043a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 43a:	48c9                	li	a7,18
 ecall
 43c:	00000073          	ecall
 ret
 440:	8082                	ret

0000000000000442 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 442:	48a1                	li	a7,8
 ecall
 444:	00000073          	ecall
 ret
 448:	8082                	ret

000000000000044a <link>:
.global link
link:
 li a7, SYS_link
 44a:	48cd                	li	a7,19
 ecall
 44c:	00000073          	ecall
 ret
 450:	8082                	ret

0000000000000452 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 452:	48d1                	li	a7,20
 ecall
 454:	00000073          	ecall
 ret
 458:	8082                	ret

000000000000045a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 45a:	48a5                	li	a7,9
 ecall
 45c:	00000073          	ecall
 ret
 460:	8082                	ret

0000000000000462 <dup>:
.global dup
dup:
 li a7, SYS_dup
 462:	48a9                	li	a7,10
 ecall
 464:	00000073          	ecall
 ret
 468:	8082                	ret

000000000000046a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 46a:	48ad                	li	a7,11
 ecall
 46c:	00000073          	ecall
 ret
 470:	8082                	ret

0000000000000472 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 472:	48b1                	li	a7,12
 ecall
 474:	00000073          	ecall
 ret
 478:	8082                	ret

000000000000047a <pause>:
.global pause
pause:
 li a7, SYS_pause
 47a:	48b5                	li	a7,13
 ecall
 47c:	00000073          	ecall
 ret
 480:	8082                	ret

0000000000000482 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 482:	48b9                	li	a7,14
 ecall
 484:	00000073          	ecall
 ret
 488:	8082                	ret

000000000000048a <getcnt>:
.global getcnt
getcnt:
 li a7, SYS_getcnt
 48a:	48d9                	li	a7,22
 ecall
 48c:	00000073          	ecall
 ret
 490:	8082                	ret

0000000000000492 <settickets>:
.global settickets
settickets:
 li a7, SYS_settickets
 492:	48dd                	li	a7,23
 ecall
 494:	00000073          	ecall
 ret
 498:	8082                	ret

000000000000049a <getpinfo>:
.global getpinfo
getpinfo:
 li a7, SYS_getpinfo
 49a:	48e1                	li	a7,24
 ecall
 49c:	00000073          	ecall
 ret
 4a0:	8082                	ret

00000000000004a2 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4a2:	1101                	add	sp,sp,-32
 4a4:	ec06                	sd	ra,24(sp)
 4a6:	e822                	sd	s0,16(sp)
 4a8:	1000                	add	s0,sp,32
 4aa:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4ae:	4605                	li	a2,1
 4b0:	fef40593          	add	a1,s0,-17
 4b4:	f57ff0ef          	jal	40a <write>
}
 4b8:	60e2                	ld	ra,24(sp)
 4ba:	6442                	ld	s0,16(sp)
 4bc:	6105                	add	sp,sp,32
 4be:	8082                	ret

00000000000004c0 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 4c0:	715d                	add	sp,sp,-80
 4c2:	e486                	sd	ra,72(sp)
 4c4:	e0a2                	sd	s0,64(sp)
 4c6:	fc26                	sd	s1,56(sp)
 4c8:	f84a                	sd	s2,48(sp)
 4ca:	f44e                	sd	s3,40(sp)
 4cc:	0880                	add	s0,sp,80
 4ce:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 4d0:	c299                	beqz	a3,4d6 <printint+0x16>
 4d2:	0805c163          	bltz	a1,554 <printint+0x94>
  neg = 0;
 4d6:	4881                	li	a7,0
 4d8:	fb840693          	add	a3,s0,-72
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 4dc:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 4de:	00000517          	auipc	a0,0x0
 4e2:	53250513          	add	a0,a0,1330 # a10 <digits>
 4e6:	883e                	mv	a6,a5
 4e8:	2785                	addw	a5,a5,1
 4ea:	02c5f733          	remu	a4,a1,a2
 4ee:	972a                	add	a4,a4,a0
 4f0:	00074703          	lbu	a4,0(a4)
 4f4:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 4f8:	872e                	mv	a4,a1
 4fa:	02c5d5b3          	divu	a1,a1,a2
 4fe:	0685                	add	a3,a3,1
 500:	fec773e3          	bgeu	a4,a2,4e6 <printint+0x26>
  if(neg)
 504:	00088b63          	beqz	a7,51a <printint+0x5a>
    buf[i++] = '-';
 508:	fd078793          	add	a5,a5,-48
 50c:	97a2                	add	a5,a5,s0
 50e:	02d00713          	li	a4,45
 512:	fee78423          	sb	a4,-24(a5)
 516:	0028079b          	addw	a5,a6,2

  while(--i >= 0)
 51a:	02f05663          	blez	a5,546 <printint+0x86>
 51e:	fb840713          	add	a4,s0,-72
 522:	00f704b3          	add	s1,a4,a5
 526:	fff70993          	add	s3,a4,-1
 52a:	99be                	add	s3,s3,a5
 52c:	37fd                	addw	a5,a5,-1
 52e:	1782                	sll	a5,a5,0x20
 530:	9381                	srl	a5,a5,0x20
 532:	40f989b3          	sub	s3,s3,a5
    putc(fd, buf[i]);
 536:	fff4c583          	lbu	a1,-1(s1)
 53a:	854a                	mv	a0,s2
 53c:	f67ff0ef          	jal	4a2 <putc>
  while(--i >= 0)
 540:	14fd                	add	s1,s1,-1
 542:	ff349ae3          	bne	s1,s3,536 <printint+0x76>
}
 546:	60a6                	ld	ra,72(sp)
 548:	6406                	ld	s0,64(sp)
 54a:	74e2                	ld	s1,56(sp)
 54c:	7942                	ld	s2,48(sp)
 54e:	79a2                	ld	s3,40(sp)
 550:	6161                	add	sp,sp,80
 552:	8082                	ret
    x = -xx;
 554:	40b005b3          	neg	a1,a1
    neg = 1;
 558:	4885                	li	a7,1
    x = -xx;
 55a:	bfbd                	j	4d8 <printint+0x18>

000000000000055c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 55c:	711d                	add	sp,sp,-96
 55e:	ec86                	sd	ra,88(sp)
 560:	e8a2                	sd	s0,80(sp)
 562:	e4a6                	sd	s1,72(sp)
 564:	e0ca                	sd	s2,64(sp)
 566:	fc4e                	sd	s3,56(sp)
 568:	f852                	sd	s4,48(sp)
 56a:	f456                	sd	s5,40(sp)
 56c:	f05a                	sd	s6,32(sp)
 56e:	ec5e                	sd	s7,24(sp)
 570:	e862                	sd	s8,16(sp)
 572:	e466                	sd	s9,8(sp)
 574:	e06a                	sd	s10,0(sp)
 576:	1080                	add	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 578:	0005c903          	lbu	s2,0(a1)
 57c:	26090563          	beqz	s2,7e6 <vprintf+0x28a>
 580:	8b2a                	mv	s6,a0
 582:	8a2e                	mv	s4,a1
 584:	8bb2                	mv	s7,a2
  state = 0;
 586:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 588:	4481                	li	s1,0
 58a:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 58c:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 590:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 594:	06c00c93          	li	s9,108
 598:	a005                	j	5b8 <vprintf+0x5c>
        putc(fd, c0);
 59a:	85ca                	mv	a1,s2
 59c:	855a                	mv	a0,s6
 59e:	f05ff0ef          	jal	4a2 <putc>
 5a2:	a019                	j	5a8 <vprintf+0x4c>
    } else if(state == '%'){
 5a4:	03598263          	beq	s3,s5,5c8 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 5a8:	2485                	addw	s1,s1,1
 5aa:	8726                	mv	a4,s1
 5ac:	009a07b3          	add	a5,s4,s1
 5b0:	0007c903          	lbu	s2,0(a5)
 5b4:	22090963          	beqz	s2,7e6 <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
 5b8:	0009079b          	sext.w	a5,s2
    if(state == 0){
 5bc:	fe0994e3          	bnez	s3,5a4 <vprintf+0x48>
      if(c0 == '%'){
 5c0:	fd579de3          	bne	a5,s5,59a <vprintf+0x3e>
        state = '%';
 5c4:	89be                	mv	s3,a5
 5c6:	b7cd                	j	5a8 <vprintf+0x4c>
      if(c0) c1 = fmt[i+1] & 0xff;
 5c8:	cbc9                	beqz	a5,65a <vprintf+0xfe>
 5ca:	00ea06b3          	add	a3,s4,a4
 5ce:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 5d2:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 5d4:	c681                	beqz	a3,5dc <vprintf+0x80>
 5d6:	9752                	add	a4,a4,s4
 5d8:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 5dc:	05878363          	beq	a5,s8,622 <vprintf+0xc6>
      } else if(c0 == 'l' && c1 == 'd'){
 5e0:	05978d63          	beq	a5,s9,63a <vprintf+0xde>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 5e4:	07500713          	li	a4,117
 5e8:	0ee78763          	beq	a5,a4,6d6 <vprintf+0x17a>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 5ec:	07800713          	li	a4,120
 5f0:	12e78963          	beq	a5,a4,722 <vprintf+0x1c6>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 5f4:	07000713          	li	a4,112
 5f8:	14e78e63          	beq	a5,a4,754 <vprintf+0x1f8>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 5fc:	06300713          	li	a4,99
 600:	18e78c63          	beq	a5,a4,798 <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 604:	07300713          	li	a4,115
 608:	1ae78263          	beq	a5,a4,7ac <vprintf+0x250>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 60c:	02500713          	li	a4,37
 610:	04e79563          	bne	a5,a4,65a <vprintf+0xfe>
        putc(fd, '%');
 614:	02500593          	li	a1,37
 618:	855a                	mv	a0,s6
 61a:	e89ff0ef          	jal	4a2 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 61e:	4981                	li	s3,0
 620:	b761                	j	5a8 <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 10, 1);
 622:	008b8913          	add	s2,s7,8
 626:	4685                	li	a3,1
 628:	4629                	li	a2,10
 62a:	000ba583          	lw	a1,0(s7)
 62e:	855a                	mv	a0,s6
 630:	e91ff0ef          	jal	4c0 <printint>
 634:	8bca                	mv	s7,s2
      state = 0;
 636:	4981                	li	s3,0
 638:	bf85                	j	5a8 <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'd'){
 63a:	06400793          	li	a5,100
 63e:	02f68963          	beq	a3,a5,670 <vprintf+0x114>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 642:	06c00793          	li	a5,108
 646:	04f68263          	beq	a3,a5,68a <vprintf+0x12e>
      } else if(c0 == 'l' && c1 == 'u'){
 64a:	07500793          	li	a5,117
 64e:	0af68063          	beq	a3,a5,6ee <vprintf+0x192>
      } else if(c0 == 'l' && c1 == 'x'){
 652:	07800793          	li	a5,120
 656:	0ef68263          	beq	a3,a5,73a <vprintf+0x1de>
        putc(fd, '%');
 65a:	02500593          	li	a1,37
 65e:	855a                	mv	a0,s6
 660:	e43ff0ef          	jal	4a2 <putc>
        putc(fd, c0);
 664:	85ca                	mv	a1,s2
 666:	855a                	mv	a0,s6
 668:	e3bff0ef          	jal	4a2 <putc>
      state = 0;
 66c:	4981                	li	s3,0
 66e:	bf2d                	j	5a8 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 670:	008b8913          	add	s2,s7,8
 674:	4685                	li	a3,1
 676:	4629                	li	a2,10
 678:	000bb583          	ld	a1,0(s7)
 67c:	855a                	mv	a0,s6
 67e:	e43ff0ef          	jal	4c0 <printint>
        i += 1;
 682:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 684:	8bca                	mv	s7,s2
      state = 0;
 686:	4981                	li	s3,0
        i += 1;
 688:	b705                	j	5a8 <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 68a:	06400793          	li	a5,100
 68e:	02f60763          	beq	a2,a5,6bc <vprintf+0x160>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 692:	07500793          	li	a5,117
 696:	06f60963          	beq	a2,a5,708 <vprintf+0x1ac>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 69a:	07800793          	li	a5,120
 69e:	faf61ee3          	bne	a2,a5,65a <vprintf+0xfe>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6a2:	008b8913          	add	s2,s7,8
 6a6:	4681                	li	a3,0
 6a8:	4641                	li	a2,16
 6aa:	000bb583          	ld	a1,0(s7)
 6ae:	855a                	mv	a0,s6
 6b0:	e11ff0ef          	jal	4c0 <printint>
        i += 2;
 6b4:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 6b6:	8bca                	mv	s7,s2
      state = 0;
 6b8:	4981                	li	s3,0
        i += 2;
 6ba:	b5fd                	j	5a8 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6bc:	008b8913          	add	s2,s7,8
 6c0:	4685                	li	a3,1
 6c2:	4629                	li	a2,10
 6c4:	000bb583          	ld	a1,0(s7)
 6c8:	855a                	mv	a0,s6
 6ca:	df7ff0ef          	jal	4c0 <printint>
        i += 2;
 6ce:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 6d0:	8bca                	mv	s7,s2
      state = 0;
 6d2:	4981                	li	s3,0
        i += 2;
 6d4:	bdd1                	j	5a8 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint32), 10, 0);
 6d6:	008b8913          	add	s2,s7,8
 6da:	4681                	li	a3,0
 6dc:	4629                	li	a2,10
 6de:	000be583          	lwu	a1,0(s7)
 6e2:	855a                	mv	a0,s6
 6e4:	dddff0ef          	jal	4c0 <printint>
 6e8:	8bca                	mv	s7,s2
      state = 0;
 6ea:	4981                	li	s3,0
 6ec:	bd75                	j	5a8 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6ee:	008b8913          	add	s2,s7,8
 6f2:	4681                	li	a3,0
 6f4:	4629                	li	a2,10
 6f6:	000bb583          	ld	a1,0(s7)
 6fa:	855a                	mv	a0,s6
 6fc:	dc5ff0ef          	jal	4c0 <printint>
        i += 1;
 700:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 702:	8bca                	mv	s7,s2
      state = 0;
 704:	4981                	li	s3,0
        i += 1;
 706:	b54d                	j	5a8 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 708:	008b8913          	add	s2,s7,8
 70c:	4681                	li	a3,0
 70e:	4629                	li	a2,10
 710:	000bb583          	ld	a1,0(s7)
 714:	855a                	mv	a0,s6
 716:	dabff0ef          	jal	4c0 <printint>
        i += 2;
 71a:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 71c:	8bca                	mv	s7,s2
      state = 0;
 71e:	4981                	li	s3,0
        i += 2;
 720:	b561                	j	5a8 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint32), 16, 0);
 722:	008b8913          	add	s2,s7,8
 726:	4681                	li	a3,0
 728:	4641                	li	a2,16
 72a:	000be583          	lwu	a1,0(s7)
 72e:	855a                	mv	a0,s6
 730:	d91ff0ef          	jal	4c0 <printint>
 734:	8bca                	mv	s7,s2
      state = 0;
 736:	4981                	li	s3,0
 738:	bd85                	j	5a8 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 16, 0);
 73a:	008b8913          	add	s2,s7,8
 73e:	4681                	li	a3,0
 740:	4641                	li	a2,16
 742:	000bb583          	ld	a1,0(s7)
 746:	855a                	mv	a0,s6
 748:	d79ff0ef          	jal	4c0 <printint>
        i += 1;
 74c:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 74e:	8bca                	mv	s7,s2
      state = 0;
 750:	4981                	li	s3,0
        i += 1;
 752:	bd99                	j	5a8 <vprintf+0x4c>
        printptr(fd, va_arg(ap, uint64));
 754:	008b8d13          	add	s10,s7,8
 758:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 75c:	03000593          	li	a1,48
 760:	855a                	mv	a0,s6
 762:	d41ff0ef          	jal	4a2 <putc>
  putc(fd, 'x');
 766:	07800593          	li	a1,120
 76a:	855a                	mv	a0,s6
 76c:	d37ff0ef          	jal	4a2 <putc>
 770:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 772:	00000b97          	auipc	s7,0x0
 776:	29eb8b93          	add	s7,s7,670 # a10 <digits>
 77a:	03c9d793          	srl	a5,s3,0x3c
 77e:	97de                	add	a5,a5,s7
 780:	0007c583          	lbu	a1,0(a5)
 784:	855a                	mv	a0,s6
 786:	d1dff0ef          	jal	4a2 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 78a:	0992                	sll	s3,s3,0x4
 78c:	397d                	addw	s2,s2,-1
 78e:	fe0916e3          	bnez	s2,77a <vprintf+0x21e>
        printptr(fd, va_arg(ap, uint64));
 792:	8bea                	mv	s7,s10
      state = 0;
 794:	4981                	li	s3,0
 796:	bd09                	j	5a8 <vprintf+0x4c>
        putc(fd, va_arg(ap, uint32));
 798:	008b8913          	add	s2,s7,8
 79c:	000bc583          	lbu	a1,0(s7)
 7a0:	855a                	mv	a0,s6
 7a2:	d01ff0ef          	jal	4a2 <putc>
 7a6:	8bca                	mv	s7,s2
      state = 0;
 7a8:	4981                	li	s3,0
 7aa:	bbfd                	j	5a8 <vprintf+0x4c>
        if((s = va_arg(ap, char*)) == 0)
 7ac:	008b8993          	add	s3,s7,8
 7b0:	000bb903          	ld	s2,0(s7)
 7b4:	00090f63          	beqz	s2,7d2 <vprintf+0x276>
        for(; *s; s++)
 7b8:	00094583          	lbu	a1,0(s2)
 7bc:	c195                	beqz	a1,7e0 <vprintf+0x284>
          putc(fd, *s);
 7be:	855a                	mv	a0,s6
 7c0:	ce3ff0ef          	jal	4a2 <putc>
        for(; *s; s++)
 7c4:	0905                	add	s2,s2,1
 7c6:	00094583          	lbu	a1,0(s2)
 7ca:	f9f5                	bnez	a1,7be <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 7cc:	8bce                	mv	s7,s3
      state = 0;
 7ce:	4981                	li	s3,0
 7d0:	bbe1                	j	5a8 <vprintf+0x4c>
          s = "(null)";
 7d2:	00000917          	auipc	s2,0x0
 7d6:	23690913          	add	s2,s2,566 # a08 <malloc+0x128>
        for(; *s; s++)
 7da:	02800593          	li	a1,40
 7de:	b7c5                	j	7be <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 7e0:	8bce                	mv	s7,s3
      state = 0;
 7e2:	4981                	li	s3,0
 7e4:	b3d1                	j	5a8 <vprintf+0x4c>
    }
  }
}
 7e6:	60e6                	ld	ra,88(sp)
 7e8:	6446                	ld	s0,80(sp)
 7ea:	64a6                	ld	s1,72(sp)
 7ec:	6906                	ld	s2,64(sp)
 7ee:	79e2                	ld	s3,56(sp)
 7f0:	7a42                	ld	s4,48(sp)
 7f2:	7aa2                	ld	s5,40(sp)
 7f4:	7b02                	ld	s6,32(sp)
 7f6:	6be2                	ld	s7,24(sp)
 7f8:	6c42                	ld	s8,16(sp)
 7fa:	6ca2                	ld	s9,8(sp)
 7fc:	6d02                	ld	s10,0(sp)
 7fe:	6125                	add	sp,sp,96
 800:	8082                	ret

0000000000000802 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 802:	715d                	add	sp,sp,-80
 804:	ec06                	sd	ra,24(sp)
 806:	e822                	sd	s0,16(sp)
 808:	1000                	add	s0,sp,32
 80a:	e010                	sd	a2,0(s0)
 80c:	e414                	sd	a3,8(s0)
 80e:	e818                	sd	a4,16(s0)
 810:	ec1c                	sd	a5,24(s0)
 812:	03043023          	sd	a6,32(s0)
 816:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 81a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 81e:	8622                	mv	a2,s0
 820:	d3dff0ef          	jal	55c <vprintf>
}
 824:	60e2                	ld	ra,24(sp)
 826:	6442                	ld	s0,16(sp)
 828:	6161                	add	sp,sp,80
 82a:	8082                	ret

000000000000082c <printf>:

void
printf(const char *fmt, ...)
{
 82c:	711d                	add	sp,sp,-96
 82e:	ec06                	sd	ra,24(sp)
 830:	e822                	sd	s0,16(sp)
 832:	1000                	add	s0,sp,32
 834:	e40c                	sd	a1,8(s0)
 836:	e810                	sd	a2,16(s0)
 838:	ec14                	sd	a3,24(s0)
 83a:	f018                	sd	a4,32(s0)
 83c:	f41c                	sd	a5,40(s0)
 83e:	03043823          	sd	a6,48(s0)
 842:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 846:	00840613          	add	a2,s0,8
 84a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 84e:	85aa                	mv	a1,a0
 850:	4505                	li	a0,1
 852:	d0bff0ef          	jal	55c <vprintf>
}
 856:	60e2                	ld	ra,24(sp)
 858:	6442                	ld	s0,16(sp)
 85a:	6125                	add	sp,sp,96
 85c:	8082                	ret

000000000000085e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 85e:	1141                	add	sp,sp,-16
 860:	e422                	sd	s0,8(sp)
 862:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 864:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 868:	00000797          	auipc	a5,0x0
 86c:	7987b783          	ld	a5,1944(a5) # 1000 <freep>
 870:	a02d                	j	89a <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 872:	4618                	lw	a4,8(a2)
 874:	9f2d                	addw	a4,a4,a1
 876:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 87a:	6398                	ld	a4,0(a5)
 87c:	6310                	ld	a2,0(a4)
 87e:	a83d                	j	8bc <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 880:	ff852703          	lw	a4,-8(a0)
 884:	9f31                	addw	a4,a4,a2
 886:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 888:	ff053683          	ld	a3,-16(a0)
 88c:	a091                	j	8d0 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 88e:	6398                	ld	a4,0(a5)
 890:	00e7e463          	bltu	a5,a4,898 <free+0x3a>
 894:	00e6ea63          	bltu	a3,a4,8a8 <free+0x4a>
{
 898:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 89a:	fed7fae3          	bgeu	a5,a3,88e <free+0x30>
 89e:	6398                	ld	a4,0(a5)
 8a0:	00e6e463          	bltu	a3,a4,8a8 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8a4:	fee7eae3          	bltu	a5,a4,898 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 8a8:	ff852583          	lw	a1,-8(a0)
 8ac:	6390                	ld	a2,0(a5)
 8ae:	02059813          	sll	a6,a1,0x20
 8b2:	01c85713          	srl	a4,a6,0x1c
 8b6:	9736                	add	a4,a4,a3
 8b8:	fae60de3          	beq	a2,a4,872 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 8bc:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 8c0:	4790                	lw	a2,8(a5)
 8c2:	02061593          	sll	a1,a2,0x20
 8c6:	01c5d713          	srl	a4,a1,0x1c
 8ca:	973e                	add	a4,a4,a5
 8cc:	fae68ae3          	beq	a3,a4,880 <free+0x22>
    p->s.ptr = bp->s.ptr;
 8d0:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 8d2:	00000717          	auipc	a4,0x0
 8d6:	72f73723          	sd	a5,1838(a4) # 1000 <freep>
}
 8da:	6422                	ld	s0,8(sp)
 8dc:	0141                	add	sp,sp,16
 8de:	8082                	ret

00000000000008e0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8e0:	7139                	add	sp,sp,-64
 8e2:	fc06                	sd	ra,56(sp)
 8e4:	f822                	sd	s0,48(sp)
 8e6:	f426                	sd	s1,40(sp)
 8e8:	f04a                	sd	s2,32(sp)
 8ea:	ec4e                	sd	s3,24(sp)
 8ec:	e852                	sd	s4,16(sp)
 8ee:	e456                	sd	s5,8(sp)
 8f0:	e05a                	sd	s6,0(sp)
 8f2:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8f4:	02051493          	sll	s1,a0,0x20
 8f8:	9081                	srl	s1,s1,0x20
 8fa:	04bd                	add	s1,s1,15
 8fc:	8091                	srl	s1,s1,0x4
 8fe:	0014899b          	addw	s3,s1,1
 902:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 904:	00000517          	auipc	a0,0x0
 908:	6fc53503          	ld	a0,1788(a0) # 1000 <freep>
 90c:	c515                	beqz	a0,938 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 90e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 910:	4798                	lw	a4,8(a5)
 912:	02977f63          	bgeu	a4,s1,950 <malloc+0x70>
  if(nu < 4096)
 916:	8a4e                	mv	s4,s3
 918:	0009871b          	sext.w	a4,s3
 91c:	6685                	lui	a3,0x1
 91e:	00d77363          	bgeu	a4,a3,924 <malloc+0x44>
 922:	6a05                	lui	s4,0x1
 924:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 928:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 92c:	00000917          	auipc	s2,0x0
 930:	6d490913          	add	s2,s2,1748 # 1000 <freep>
  if(p == SBRK_ERROR)
 934:	5afd                	li	s5,-1
 936:	a885                	j	9a6 <malloc+0xc6>
    base.s.ptr = freep = prevp = &base;
 938:	00001797          	auipc	a5,0x1
 93c:	8d878793          	add	a5,a5,-1832 # 1210 <base>
 940:	00000717          	auipc	a4,0x0
 944:	6cf73023          	sd	a5,1728(a4) # 1000 <freep>
 948:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 94a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 94e:	b7e1                	j	916 <malloc+0x36>
      if(p->s.size == nunits)
 950:	02e48c63          	beq	s1,a4,988 <malloc+0xa8>
        p->s.size -= nunits;
 954:	4137073b          	subw	a4,a4,s3
 958:	c798                	sw	a4,8(a5)
        p += p->s.size;
 95a:	02071693          	sll	a3,a4,0x20
 95e:	01c6d713          	srl	a4,a3,0x1c
 962:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 964:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 968:	00000717          	auipc	a4,0x0
 96c:	68a73c23          	sd	a0,1688(a4) # 1000 <freep>
      return (void*)(p + 1);
 970:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 974:	70e2                	ld	ra,56(sp)
 976:	7442                	ld	s0,48(sp)
 978:	74a2                	ld	s1,40(sp)
 97a:	7902                	ld	s2,32(sp)
 97c:	69e2                	ld	s3,24(sp)
 97e:	6a42                	ld	s4,16(sp)
 980:	6aa2                	ld	s5,8(sp)
 982:	6b02                	ld	s6,0(sp)
 984:	6121                	add	sp,sp,64
 986:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 988:	6398                	ld	a4,0(a5)
 98a:	e118                	sd	a4,0(a0)
 98c:	bff1                	j	968 <malloc+0x88>
  hp->s.size = nu;
 98e:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 992:	0541                	add	a0,a0,16
 994:	ecbff0ef          	jal	85e <free>
  return freep;
 998:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 99c:	dd61                	beqz	a0,974 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 99e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9a0:	4798                	lw	a4,8(a5)
 9a2:	fa9777e3          	bgeu	a4,s1,950 <malloc+0x70>
    if(p == freep)
 9a6:	00093703          	ld	a4,0(s2)
 9aa:	853e                	mv	a0,a5
 9ac:	fef719e3          	bne	a4,a5,99e <malloc+0xbe>
  p = sbrk(nu * sizeof(Header));
 9b0:	8552                	mv	a0,s4
 9b2:	a05ff0ef          	jal	3b6 <sbrk>
  if(p == SBRK_ERROR)
 9b6:	fd551ce3          	bne	a0,s5,98e <malloc+0xae>
        return 0;
 9ba:	4501                	li	a0,0
 9bc:	bf65                	j	974 <malloc+0x94>
