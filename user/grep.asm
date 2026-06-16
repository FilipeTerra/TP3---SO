
user/_grep:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <matchstar>:
  return 0;
}

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
   0:	7179                	add	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	e052                	sd	s4,0(sp)
   e:	1800                	add	s0,sp,48
  10:	892a                	mv	s2,a0
  12:	89ae                	mv	s3,a1
  14:	84b2                	mv	s1,a2
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
      return 1;
  }while(*text!='\0' && (*text++==c || c=='.'));
  16:	02e00a13          	li	s4,46
    if(matchhere(re, text))
  1a:	85a6                	mv	a1,s1
  1c:	854e                	mv	a0,s3
  1e:	02c000ef          	jal	4a <matchhere>
  22:	e919                	bnez	a0,38 <matchstar+0x38>
  }while(*text!='\0' && (*text++==c || c=='.'));
  24:	0004c783          	lbu	a5,0(s1)
  28:	cb89                	beqz	a5,3a <matchstar+0x3a>
  2a:	0485                	add	s1,s1,1
  2c:	2781                	sext.w	a5,a5
  2e:	ff2786e3          	beq	a5,s2,1a <matchstar+0x1a>
  32:	ff4904e3          	beq	s2,s4,1a <matchstar+0x1a>
  36:	a011                	j	3a <matchstar+0x3a>
      return 1;
  38:	4505                	li	a0,1
  return 0;
}
  3a:	70a2                	ld	ra,40(sp)
  3c:	7402                	ld	s0,32(sp)
  3e:	64e2                	ld	s1,24(sp)
  40:	6942                	ld	s2,16(sp)
  42:	69a2                	ld	s3,8(sp)
  44:	6a02                	ld	s4,0(sp)
  46:	6145                	add	sp,sp,48
  48:	8082                	ret

000000000000004a <matchhere>:
  if(re[0] == '\0')
  4a:	00054703          	lbu	a4,0(a0)
  4e:	c73d                	beqz	a4,bc <matchhere+0x72>
{
  50:	1141                	add	sp,sp,-16
  52:	e406                	sd	ra,8(sp)
  54:	e022                	sd	s0,0(sp)
  56:	0800                	add	s0,sp,16
  58:	87aa                	mv	a5,a0
  if(re[1] == '*')
  5a:	00154683          	lbu	a3,1(a0)
  5e:	02a00613          	li	a2,42
  62:	02c68563          	beq	a3,a2,8c <matchhere+0x42>
  if(re[0] == '$' && re[1] == '\0')
  66:	02400613          	li	a2,36
  6a:	02c70863          	beq	a4,a2,9a <matchhere+0x50>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  6e:	0005c683          	lbu	a3,0(a1)
  return 0;
  72:	4501                	li	a0,0
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  74:	ca81                	beqz	a3,84 <matchhere+0x3a>
  76:	02e00613          	li	a2,46
  7a:	02c70b63          	beq	a4,a2,b0 <matchhere+0x66>
  return 0;
  7e:	4501                	li	a0,0
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  80:	02d70863          	beq	a4,a3,b0 <matchhere+0x66>
}
  84:	60a2                	ld	ra,8(sp)
  86:	6402                	ld	s0,0(sp)
  88:	0141                	add	sp,sp,16
  8a:	8082                	ret
    return matchstar(re[0], re+2, text);
  8c:	862e                	mv	a2,a1
  8e:	00250593          	add	a1,a0,2
  92:	853a                	mv	a0,a4
  94:	f6dff0ef          	jal	0 <matchstar>
  98:	b7f5                	j	84 <matchhere+0x3a>
  if(re[0] == '$' && re[1] == '\0')
  9a:	c691                	beqz	a3,a6 <matchhere+0x5c>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  9c:	0005c683          	lbu	a3,0(a1)
  a0:	fef9                	bnez	a3,7e <matchhere+0x34>
  return 0;
  a2:	4501                	li	a0,0
  a4:	b7c5                	j	84 <matchhere+0x3a>
    return *text == '\0';
  a6:	0005c503          	lbu	a0,0(a1)
  aa:	00153513          	seqz	a0,a0
  ae:	bfd9                	j	84 <matchhere+0x3a>
    return matchhere(re+1, text+1);
  b0:	0585                	add	a1,a1,1
  b2:	00178513          	add	a0,a5,1
  b6:	f95ff0ef          	jal	4a <matchhere>
  ba:	b7e9                	j	84 <matchhere+0x3a>
    return 1;
  bc:	4505                	li	a0,1
}
  be:	8082                	ret

00000000000000c0 <match>:
{
  c0:	1101                	add	sp,sp,-32
  c2:	ec06                	sd	ra,24(sp)
  c4:	e822                	sd	s0,16(sp)
  c6:	e426                	sd	s1,8(sp)
  c8:	e04a                	sd	s2,0(sp)
  ca:	1000                	add	s0,sp,32
  cc:	892a                	mv	s2,a0
  ce:	84ae                	mv	s1,a1
  if(re[0] == '^')
  d0:	00054703          	lbu	a4,0(a0)
  d4:	05e00793          	li	a5,94
  d8:	00f70c63          	beq	a4,a5,f0 <match+0x30>
    if(matchhere(re, text))
  dc:	85a6                	mv	a1,s1
  de:	854a                	mv	a0,s2
  e0:	f6bff0ef          	jal	4a <matchhere>
  e4:	e911                	bnez	a0,f8 <match+0x38>
  }while(*text++ != '\0');
  e6:	0485                	add	s1,s1,1
  e8:	fff4c783          	lbu	a5,-1(s1)
  ec:	fbe5                	bnez	a5,dc <match+0x1c>
  ee:	a031                	j	fa <match+0x3a>
    return matchhere(re+1, text);
  f0:	0505                	add	a0,a0,1
  f2:	f59ff0ef          	jal	4a <matchhere>
  f6:	a011                	j	fa <match+0x3a>
      return 1;
  f8:	4505                	li	a0,1
}
  fa:	60e2                	ld	ra,24(sp)
  fc:	6442                	ld	s0,16(sp)
  fe:	64a2                	ld	s1,8(sp)
 100:	6902                	ld	s2,0(sp)
 102:	6105                	add	sp,sp,32
 104:	8082                	ret

0000000000000106 <grep>:
{
 106:	715d                	add	sp,sp,-80
 108:	e486                	sd	ra,72(sp)
 10a:	e0a2                	sd	s0,64(sp)
 10c:	fc26                	sd	s1,56(sp)
 10e:	f84a                	sd	s2,48(sp)
 110:	f44e                	sd	s3,40(sp)
 112:	f052                	sd	s4,32(sp)
 114:	ec56                	sd	s5,24(sp)
 116:	e85a                	sd	s6,16(sp)
 118:	e45e                	sd	s7,8(sp)
 11a:	e062                	sd	s8,0(sp)
 11c:	0880                	add	s0,sp,80
 11e:	89aa                	mv	s3,a0
 120:	8b2e                	mv	s6,a1
  m = 0;
 122:	4a01                	li	s4,0
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 124:	3ff00b93          	li	s7,1023
 128:	00001a97          	auipc	s5,0x1
 12c:	ee8a8a93          	add	s5,s5,-280 # 1010 <buf>
 130:	a835                	j	16c <grep+0x66>
      p = q+1;
 132:	00148913          	add	s2,s1,1
    while((q = strchr(p, '\n')) != 0){
 136:	45a9                	li	a1,10
 138:	854a                	mv	a0,s2
 13a:	1c4000ef          	jal	2fe <strchr>
 13e:	84aa                	mv	s1,a0
 140:	c505                	beqz	a0,168 <grep+0x62>
      *q = 0;
 142:	00048023          	sb	zero,0(s1)
      if(match(pattern, p)){
 146:	85ca                	mv	a1,s2
 148:	854e                	mv	a0,s3
 14a:	f77ff0ef          	jal	c0 <match>
 14e:	d175                	beqz	a0,132 <grep+0x2c>
        *q = '\n';
 150:	47a9                	li	a5,10
 152:	00f48023          	sb	a5,0(s1)
        write(1, p, q+1 - p);
 156:	00148613          	add	a2,s1,1
 15a:	4126063b          	subw	a2,a2,s2
 15e:	85ca                	mv	a1,s2
 160:	4505                	li	a0,1
 162:	3ac000ef          	jal	50e <write>
 166:	b7f1                	j	132 <grep+0x2c>
    if(m > 0){
 168:	03404563          	bgtz	s4,192 <grep+0x8c>
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 16c:	414b863b          	subw	a2,s7,s4
 170:	014a85b3          	add	a1,s5,s4
 174:	855a                	mv	a0,s6
 176:	390000ef          	jal	506 <read>
 17a:	02a05963          	blez	a0,1ac <grep+0xa6>
    m += n;
 17e:	00aa0c3b          	addw	s8,s4,a0
 182:	000c0a1b          	sext.w	s4,s8
    buf[m] = '\0';
 186:	014a87b3          	add	a5,s5,s4
 18a:	00078023          	sb	zero,0(a5)
    p = buf;
 18e:	8956                	mv	s2,s5
    while((q = strchr(p, '\n')) != 0){
 190:	b75d                	j	136 <grep+0x30>
      m -= p - buf;
 192:	00001517          	auipc	a0,0x1
 196:	e7e50513          	add	a0,a0,-386 # 1010 <buf>
 19a:	40a90a33          	sub	s4,s2,a0
 19e:	414c0a3b          	subw	s4,s8,s4
      memmove(buf, p, m);
 1a2:	8652                	mv	a2,s4
 1a4:	85ca                	mv	a1,s2
 1a6:	26e000ef          	jal	414 <memmove>
 1aa:	b7c9                	j	16c <grep+0x66>
}
 1ac:	60a6                	ld	ra,72(sp)
 1ae:	6406                	ld	s0,64(sp)
 1b0:	74e2                	ld	s1,56(sp)
 1b2:	7942                	ld	s2,48(sp)
 1b4:	79a2                	ld	s3,40(sp)
 1b6:	7a02                	ld	s4,32(sp)
 1b8:	6ae2                	ld	s5,24(sp)
 1ba:	6b42                	ld	s6,16(sp)
 1bc:	6ba2                	ld	s7,8(sp)
 1be:	6c02                	ld	s8,0(sp)
 1c0:	6161                	add	sp,sp,80
 1c2:	8082                	ret

00000000000001c4 <main>:
{
 1c4:	7179                	add	sp,sp,-48
 1c6:	f406                	sd	ra,40(sp)
 1c8:	f022                	sd	s0,32(sp)
 1ca:	ec26                	sd	s1,24(sp)
 1cc:	e84a                	sd	s2,16(sp)
 1ce:	e44e                	sd	s3,8(sp)
 1d0:	e052                	sd	s4,0(sp)
 1d2:	1800                	add	s0,sp,48
  if(argc <= 1){
 1d4:	4785                	li	a5,1
 1d6:	04a7d663          	bge	a5,a0,222 <main+0x5e>
  pattern = argv[1];
 1da:	0085ba03          	ld	s4,8(a1)
  if(argc <= 2){
 1de:	4789                	li	a5,2
 1e0:	04a7db63          	bge	a5,a0,236 <main+0x72>
 1e4:	01058913          	add	s2,a1,16
 1e8:	ffd5099b          	addw	s3,a0,-3
 1ec:	02099793          	sll	a5,s3,0x20
 1f0:	01d7d993          	srl	s3,a5,0x1d
 1f4:	05e1                	add	a1,a1,24
 1f6:	99ae                	add	s3,s3,a1
    if((fd = open(argv[i], O_RDONLY)) < 0){
 1f8:	4581                	li	a1,0
 1fa:	00093503          	ld	a0,0(s2)
 1fe:	330000ef          	jal	52e <open>
 202:	84aa                	mv	s1,a0
 204:	04054063          	bltz	a0,244 <main+0x80>
    grep(pattern, fd);
 208:	85aa                	mv	a1,a0
 20a:	8552                	mv	a0,s4
 20c:	efbff0ef          	jal	106 <grep>
    close(fd);
 210:	8526                	mv	a0,s1
 212:	304000ef          	jal	516 <close>
  for(i = 2; i < argc; i++){
 216:	0921                	add	s2,s2,8
 218:	ff3910e3          	bne	s2,s3,1f8 <main+0x34>
  exit(0);
 21c:	4501                	li	a0,0
 21e:	2d0000ef          	jal	4ee <exit>
    fprintf(2, "usage: grep pattern [file ...]\n");
 222:	00001597          	auipc	a1,0x1
 226:	8ae58593          	add	a1,a1,-1874 # ad0 <malloc+0xec>
 22a:	4509                	li	a0,2
 22c:	6da000ef          	jal	906 <fprintf>
    exit(1);
 230:	4505                	li	a0,1
 232:	2bc000ef          	jal	4ee <exit>
    grep(pattern, 0);
 236:	4581                	li	a1,0
 238:	8552                	mv	a0,s4
 23a:	ecdff0ef          	jal	106 <grep>
    exit(0);
 23e:	4501                	li	a0,0
 240:	2ae000ef          	jal	4ee <exit>
      printf("grep: cannot open %s\n", argv[i]);
 244:	00093583          	ld	a1,0(s2)
 248:	00001517          	auipc	a0,0x1
 24c:	8a850513          	add	a0,a0,-1880 # af0 <malloc+0x10c>
 250:	6e0000ef          	jal	930 <printf>
      exit(1);
 254:	4505                	li	a0,1
 256:	298000ef          	jal	4ee <exit>

000000000000025a <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
 25a:	1141                	add	sp,sp,-16
 25c:	e406                	sd	ra,8(sp)
 25e:	e022                	sd	s0,0(sp)
 260:	0800                	add	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
 262:	f63ff0ef          	jal	1c4 <main>
  exit(r);
 266:	288000ef          	jal	4ee <exit>

000000000000026a <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 26a:	1141                	add	sp,sp,-16
 26c:	e422                	sd	s0,8(sp)
 26e:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 270:	87aa                	mv	a5,a0
 272:	0585                	add	a1,a1,1
 274:	0785                	add	a5,a5,1
 276:	fff5c703          	lbu	a4,-1(a1)
 27a:	fee78fa3          	sb	a4,-1(a5)
 27e:	fb75                	bnez	a4,272 <strcpy+0x8>
    ;
  return os;
}
 280:	6422                	ld	s0,8(sp)
 282:	0141                	add	sp,sp,16
 284:	8082                	ret

0000000000000286 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 286:	1141                	add	sp,sp,-16
 288:	e422                	sd	s0,8(sp)
 28a:	0800                	add	s0,sp,16
  while(*p && *p == *q)
 28c:	00054783          	lbu	a5,0(a0)
 290:	cb91                	beqz	a5,2a4 <strcmp+0x1e>
 292:	0005c703          	lbu	a4,0(a1)
 296:	00f71763          	bne	a4,a5,2a4 <strcmp+0x1e>
    p++, q++;
 29a:	0505                	add	a0,a0,1
 29c:	0585                	add	a1,a1,1
  while(*p && *p == *q)
 29e:	00054783          	lbu	a5,0(a0)
 2a2:	fbe5                	bnez	a5,292 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 2a4:	0005c503          	lbu	a0,0(a1)
}
 2a8:	40a7853b          	subw	a0,a5,a0
 2ac:	6422                	ld	s0,8(sp)
 2ae:	0141                	add	sp,sp,16
 2b0:	8082                	ret

00000000000002b2 <strlen>:

uint
strlen(const char *s)
{
 2b2:	1141                	add	sp,sp,-16
 2b4:	e422                	sd	s0,8(sp)
 2b6:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 2b8:	00054783          	lbu	a5,0(a0)
 2bc:	cf91                	beqz	a5,2d8 <strlen+0x26>
 2be:	0505                	add	a0,a0,1
 2c0:	87aa                	mv	a5,a0
 2c2:	86be                	mv	a3,a5
 2c4:	0785                	add	a5,a5,1
 2c6:	fff7c703          	lbu	a4,-1(a5)
 2ca:	ff65                	bnez	a4,2c2 <strlen+0x10>
 2cc:	40a6853b          	subw	a0,a3,a0
 2d0:	2505                	addw	a0,a0,1
    ;
  return n;
}
 2d2:	6422                	ld	s0,8(sp)
 2d4:	0141                	add	sp,sp,16
 2d6:	8082                	ret
  for(n = 0; s[n]; n++)
 2d8:	4501                	li	a0,0
 2da:	bfe5                	j	2d2 <strlen+0x20>

00000000000002dc <memset>:

void*
memset(void *dst, int c, uint n)
{
 2dc:	1141                	add	sp,sp,-16
 2de:	e422                	sd	s0,8(sp)
 2e0:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 2e2:	ca19                	beqz	a2,2f8 <memset+0x1c>
 2e4:	87aa                	mv	a5,a0
 2e6:	1602                	sll	a2,a2,0x20
 2e8:	9201                	srl	a2,a2,0x20
 2ea:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 2ee:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 2f2:	0785                	add	a5,a5,1
 2f4:	fee79de3          	bne	a5,a4,2ee <memset+0x12>
  }
  return dst;
}
 2f8:	6422                	ld	s0,8(sp)
 2fa:	0141                	add	sp,sp,16
 2fc:	8082                	ret

00000000000002fe <strchr>:

char*
strchr(const char *s, char c)
{
 2fe:	1141                	add	sp,sp,-16
 300:	e422                	sd	s0,8(sp)
 302:	0800                	add	s0,sp,16
  for(; *s; s++)
 304:	00054783          	lbu	a5,0(a0)
 308:	cb99                	beqz	a5,31e <strchr+0x20>
    if(*s == c)
 30a:	00f58763          	beq	a1,a5,318 <strchr+0x1a>
  for(; *s; s++)
 30e:	0505                	add	a0,a0,1
 310:	00054783          	lbu	a5,0(a0)
 314:	fbfd                	bnez	a5,30a <strchr+0xc>
      return (char*)s;
  return 0;
 316:	4501                	li	a0,0
}
 318:	6422                	ld	s0,8(sp)
 31a:	0141                	add	sp,sp,16
 31c:	8082                	ret
  return 0;
 31e:	4501                	li	a0,0
 320:	bfe5                	j	318 <strchr+0x1a>

0000000000000322 <gets>:

char*
gets(char *buf, int max)
{
 322:	711d                	add	sp,sp,-96
 324:	ec86                	sd	ra,88(sp)
 326:	e8a2                	sd	s0,80(sp)
 328:	e4a6                	sd	s1,72(sp)
 32a:	e0ca                	sd	s2,64(sp)
 32c:	fc4e                	sd	s3,56(sp)
 32e:	f852                	sd	s4,48(sp)
 330:	f456                	sd	s5,40(sp)
 332:	f05a                	sd	s6,32(sp)
 334:	ec5e                	sd	s7,24(sp)
 336:	1080                	add	s0,sp,96
 338:	8baa                	mv	s7,a0
 33a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 33c:	892a                	mv	s2,a0
 33e:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 340:	4aa9                	li	s5,10
 342:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 344:	89a6                	mv	s3,s1
 346:	2485                	addw	s1,s1,1
 348:	0344d663          	bge	s1,s4,374 <gets+0x52>
    cc = read(0, &c, 1);
 34c:	4605                	li	a2,1
 34e:	faf40593          	add	a1,s0,-81
 352:	4501                	li	a0,0
 354:	1b2000ef          	jal	506 <read>
    if(cc < 1)
 358:	00a05e63          	blez	a0,374 <gets+0x52>
    buf[i++] = c;
 35c:	faf44783          	lbu	a5,-81(s0)
 360:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 364:	01578763          	beq	a5,s5,372 <gets+0x50>
 368:	0905                	add	s2,s2,1
 36a:	fd679de3          	bne	a5,s6,344 <gets+0x22>
  for(i=0; i+1 < max; ){
 36e:	89a6                	mv	s3,s1
 370:	a011                	j	374 <gets+0x52>
 372:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 374:	99de                	add	s3,s3,s7
 376:	00098023          	sb	zero,0(s3)
  return buf;
}
 37a:	855e                	mv	a0,s7
 37c:	60e6                	ld	ra,88(sp)
 37e:	6446                	ld	s0,80(sp)
 380:	64a6                	ld	s1,72(sp)
 382:	6906                	ld	s2,64(sp)
 384:	79e2                	ld	s3,56(sp)
 386:	7a42                	ld	s4,48(sp)
 388:	7aa2                	ld	s5,40(sp)
 38a:	7b02                	ld	s6,32(sp)
 38c:	6be2                	ld	s7,24(sp)
 38e:	6125                	add	sp,sp,96
 390:	8082                	ret

0000000000000392 <stat>:

int
stat(const char *n, struct stat *st)
{
 392:	1101                	add	sp,sp,-32
 394:	ec06                	sd	ra,24(sp)
 396:	e822                	sd	s0,16(sp)
 398:	e426                	sd	s1,8(sp)
 39a:	e04a                	sd	s2,0(sp)
 39c:	1000                	add	s0,sp,32
 39e:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3a0:	4581                	li	a1,0
 3a2:	18c000ef          	jal	52e <open>
  if(fd < 0)
 3a6:	02054163          	bltz	a0,3c8 <stat+0x36>
 3aa:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 3ac:	85ca                	mv	a1,s2
 3ae:	198000ef          	jal	546 <fstat>
 3b2:	892a                	mv	s2,a0
  close(fd);
 3b4:	8526                	mv	a0,s1
 3b6:	160000ef          	jal	516 <close>
  return r;
}
 3ba:	854a                	mv	a0,s2
 3bc:	60e2                	ld	ra,24(sp)
 3be:	6442                	ld	s0,16(sp)
 3c0:	64a2                	ld	s1,8(sp)
 3c2:	6902                	ld	s2,0(sp)
 3c4:	6105                	add	sp,sp,32
 3c6:	8082                	ret
    return -1;
 3c8:	597d                	li	s2,-1
 3ca:	bfc5                	j	3ba <stat+0x28>

00000000000003cc <atoi>:

int
atoi(const char *s)
{
 3cc:	1141                	add	sp,sp,-16
 3ce:	e422                	sd	s0,8(sp)
 3d0:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3d2:	00054683          	lbu	a3,0(a0)
 3d6:	fd06879b          	addw	a5,a3,-48
 3da:	0ff7f793          	zext.b	a5,a5
 3de:	4625                	li	a2,9
 3e0:	02f66863          	bltu	a2,a5,410 <atoi+0x44>
 3e4:	872a                	mv	a4,a0
  n = 0;
 3e6:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 3e8:	0705                	add	a4,a4,1
 3ea:	0025179b          	sllw	a5,a0,0x2
 3ee:	9fa9                	addw	a5,a5,a0
 3f0:	0017979b          	sllw	a5,a5,0x1
 3f4:	9fb5                	addw	a5,a5,a3
 3f6:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 3fa:	00074683          	lbu	a3,0(a4)
 3fe:	fd06879b          	addw	a5,a3,-48
 402:	0ff7f793          	zext.b	a5,a5
 406:	fef671e3          	bgeu	a2,a5,3e8 <atoi+0x1c>
  return n;
}
 40a:	6422                	ld	s0,8(sp)
 40c:	0141                	add	sp,sp,16
 40e:	8082                	ret
  n = 0;
 410:	4501                	li	a0,0
 412:	bfe5                	j	40a <atoi+0x3e>

0000000000000414 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 414:	1141                	add	sp,sp,-16
 416:	e422                	sd	s0,8(sp)
 418:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 41a:	02b57463          	bgeu	a0,a1,442 <memmove+0x2e>
    while(n-- > 0)
 41e:	00c05f63          	blez	a2,43c <memmove+0x28>
 422:	1602                	sll	a2,a2,0x20
 424:	9201                	srl	a2,a2,0x20
 426:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 42a:	872a                	mv	a4,a0
      *dst++ = *src++;
 42c:	0585                	add	a1,a1,1
 42e:	0705                	add	a4,a4,1
 430:	fff5c683          	lbu	a3,-1(a1)
 434:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 438:	fee79ae3          	bne	a5,a4,42c <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 43c:	6422                	ld	s0,8(sp)
 43e:	0141                	add	sp,sp,16
 440:	8082                	ret
    dst += n;
 442:	00c50733          	add	a4,a0,a2
    src += n;
 446:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 448:	fec05ae3          	blez	a2,43c <memmove+0x28>
 44c:	fff6079b          	addw	a5,a2,-1
 450:	1782                	sll	a5,a5,0x20
 452:	9381                	srl	a5,a5,0x20
 454:	fff7c793          	not	a5,a5
 458:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 45a:	15fd                	add	a1,a1,-1
 45c:	177d                	add	a4,a4,-1
 45e:	0005c683          	lbu	a3,0(a1)
 462:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 466:	fee79ae3          	bne	a5,a4,45a <memmove+0x46>
 46a:	bfc9                	j	43c <memmove+0x28>

000000000000046c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 46c:	1141                	add	sp,sp,-16
 46e:	e422                	sd	s0,8(sp)
 470:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 472:	ca05                	beqz	a2,4a2 <memcmp+0x36>
 474:	fff6069b          	addw	a3,a2,-1
 478:	1682                	sll	a3,a3,0x20
 47a:	9281                	srl	a3,a3,0x20
 47c:	0685                	add	a3,a3,1
 47e:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 480:	00054783          	lbu	a5,0(a0)
 484:	0005c703          	lbu	a4,0(a1)
 488:	00e79863          	bne	a5,a4,498 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 48c:	0505                	add	a0,a0,1
    p2++;
 48e:	0585                	add	a1,a1,1
  while (n-- > 0) {
 490:	fed518e3          	bne	a0,a3,480 <memcmp+0x14>
  }
  return 0;
 494:	4501                	li	a0,0
 496:	a019                	j	49c <memcmp+0x30>
      return *p1 - *p2;
 498:	40e7853b          	subw	a0,a5,a4
}
 49c:	6422                	ld	s0,8(sp)
 49e:	0141                	add	sp,sp,16
 4a0:	8082                	ret
  return 0;
 4a2:	4501                	li	a0,0
 4a4:	bfe5                	j	49c <memcmp+0x30>

00000000000004a6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 4a6:	1141                	add	sp,sp,-16
 4a8:	e406                	sd	ra,8(sp)
 4aa:	e022                	sd	s0,0(sp)
 4ac:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 4ae:	f67ff0ef          	jal	414 <memmove>
}
 4b2:	60a2                	ld	ra,8(sp)
 4b4:	6402                	ld	s0,0(sp)
 4b6:	0141                	add	sp,sp,16
 4b8:	8082                	ret

00000000000004ba <sbrk>:

char *
sbrk(int n) {
 4ba:	1141                	add	sp,sp,-16
 4bc:	e406                	sd	ra,8(sp)
 4be:	e022                	sd	s0,0(sp)
 4c0:	0800                	add	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 4c2:	4585                	li	a1,1
 4c4:	0b2000ef          	jal	576 <sys_sbrk>
}
 4c8:	60a2                	ld	ra,8(sp)
 4ca:	6402                	ld	s0,0(sp)
 4cc:	0141                	add	sp,sp,16
 4ce:	8082                	ret

00000000000004d0 <sbrklazy>:

char *
sbrklazy(int n) {
 4d0:	1141                	add	sp,sp,-16
 4d2:	e406                	sd	ra,8(sp)
 4d4:	e022                	sd	s0,0(sp)
 4d6:	0800                	add	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 4d8:	4589                	li	a1,2
 4da:	09c000ef          	jal	576 <sys_sbrk>
}
 4de:	60a2                	ld	ra,8(sp)
 4e0:	6402                	ld	s0,0(sp)
 4e2:	0141                	add	sp,sp,16
 4e4:	8082                	ret

00000000000004e6 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 4e6:	4885                	li	a7,1
 ecall
 4e8:	00000073          	ecall
 ret
 4ec:	8082                	ret

00000000000004ee <exit>:
.global exit
exit:
 li a7, SYS_exit
 4ee:	4889                	li	a7,2
 ecall
 4f0:	00000073          	ecall
 ret
 4f4:	8082                	ret

00000000000004f6 <wait>:
.global wait
wait:
 li a7, SYS_wait
 4f6:	488d                	li	a7,3
 ecall
 4f8:	00000073          	ecall
 ret
 4fc:	8082                	ret

00000000000004fe <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 4fe:	4891                	li	a7,4
 ecall
 500:	00000073          	ecall
 ret
 504:	8082                	ret

0000000000000506 <read>:
.global read
read:
 li a7, SYS_read
 506:	4895                	li	a7,5
 ecall
 508:	00000073          	ecall
 ret
 50c:	8082                	ret

000000000000050e <write>:
.global write
write:
 li a7, SYS_write
 50e:	48c1                	li	a7,16
 ecall
 510:	00000073          	ecall
 ret
 514:	8082                	ret

0000000000000516 <close>:
.global close
close:
 li a7, SYS_close
 516:	48d5                	li	a7,21
 ecall
 518:	00000073          	ecall
 ret
 51c:	8082                	ret

000000000000051e <kill>:
.global kill
kill:
 li a7, SYS_kill
 51e:	4899                	li	a7,6
 ecall
 520:	00000073          	ecall
 ret
 524:	8082                	ret

0000000000000526 <exec>:
.global exec
exec:
 li a7, SYS_exec
 526:	489d                	li	a7,7
 ecall
 528:	00000073          	ecall
 ret
 52c:	8082                	ret

000000000000052e <open>:
.global open
open:
 li a7, SYS_open
 52e:	48bd                	li	a7,15
 ecall
 530:	00000073          	ecall
 ret
 534:	8082                	ret

0000000000000536 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 536:	48c5                	li	a7,17
 ecall
 538:	00000073          	ecall
 ret
 53c:	8082                	ret

000000000000053e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 53e:	48c9                	li	a7,18
 ecall
 540:	00000073          	ecall
 ret
 544:	8082                	ret

0000000000000546 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 546:	48a1                	li	a7,8
 ecall
 548:	00000073          	ecall
 ret
 54c:	8082                	ret

000000000000054e <link>:
.global link
link:
 li a7, SYS_link
 54e:	48cd                	li	a7,19
 ecall
 550:	00000073          	ecall
 ret
 554:	8082                	ret

0000000000000556 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 556:	48d1                	li	a7,20
 ecall
 558:	00000073          	ecall
 ret
 55c:	8082                	ret

000000000000055e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 55e:	48a5                	li	a7,9
 ecall
 560:	00000073          	ecall
 ret
 564:	8082                	ret

0000000000000566 <dup>:
.global dup
dup:
 li a7, SYS_dup
 566:	48a9                	li	a7,10
 ecall
 568:	00000073          	ecall
 ret
 56c:	8082                	ret

000000000000056e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 56e:	48ad                	li	a7,11
 ecall
 570:	00000073          	ecall
 ret
 574:	8082                	ret

0000000000000576 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 576:	48b1                	li	a7,12
 ecall
 578:	00000073          	ecall
 ret
 57c:	8082                	ret

000000000000057e <pause>:
.global pause
pause:
 li a7, SYS_pause
 57e:	48b5                	li	a7,13
 ecall
 580:	00000073          	ecall
 ret
 584:	8082                	ret

0000000000000586 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 586:	48b9                	li	a7,14
 ecall
 588:	00000073          	ecall
 ret
 58c:	8082                	ret

000000000000058e <getcnt>:
.global getcnt
getcnt:
 li a7, SYS_getcnt
 58e:	48d9                	li	a7,22
 ecall
 590:	00000073          	ecall
 ret
 594:	8082                	ret

0000000000000596 <settickets>:
.global settickets
settickets:
 li a7, SYS_settickets
 596:	48dd                	li	a7,23
 ecall
 598:	00000073          	ecall
 ret
 59c:	8082                	ret

000000000000059e <getpinfo>:
.global getpinfo
getpinfo:
 li a7, SYS_getpinfo
 59e:	48e1                	li	a7,24
 ecall
 5a0:	00000073          	ecall
 ret
 5a4:	8082                	ret

00000000000005a6 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5a6:	1101                	add	sp,sp,-32
 5a8:	ec06                	sd	ra,24(sp)
 5aa:	e822                	sd	s0,16(sp)
 5ac:	1000                	add	s0,sp,32
 5ae:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 5b2:	4605                	li	a2,1
 5b4:	fef40593          	add	a1,s0,-17
 5b8:	f57ff0ef          	jal	50e <write>
}
 5bc:	60e2                	ld	ra,24(sp)
 5be:	6442                	ld	s0,16(sp)
 5c0:	6105                	add	sp,sp,32
 5c2:	8082                	ret

00000000000005c4 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 5c4:	715d                	add	sp,sp,-80
 5c6:	e486                	sd	ra,72(sp)
 5c8:	e0a2                	sd	s0,64(sp)
 5ca:	fc26                	sd	s1,56(sp)
 5cc:	f84a                	sd	s2,48(sp)
 5ce:	f44e                	sd	s3,40(sp)
 5d0:	0880                	add	s0,sp,80
 5d2:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 5d4:	c299                	beqz	a3,5da <printint+0x16>
 5d6:	0805c163          	bltz	a1,658 <printint+0x94>
  neg = 0;
 5da:	4881                	li	a7,0
 5dc:	fb840693          	add	a3,s0,-72
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 5e0:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 5e2:	00000517          	auipc	a0,0x0
 5e6:	52e50513          	add	a0,a0,1326 # b10 <digits>
 5ea:	883e                	mv	a6,a5
 5ec:	2785                	addw	a5,a5,1
 5ee:	02c5f733          	remu	a4,a1,a2
 5f2:	972a                	add	a4,a4,a0
 5f4:	00074703          	lbu	a4,0(a4)
 5f8:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 5fc:	872e                	mv	a4,a1
 5fe:	02c5d5b3          	divu	a1,a1,a2
 602:	0685                	add	a3,a3,1
 604:	fec773e3          	bgeu	a4,a2,5ea <printint+0x26>
  if(neg)
 608:	00088b63          	beqz	a7,61e <printint+0x5a>
    buf[i++] = '-';
 60c:	fd078793          	add	a5,a5,-48
 610:	97a2                	add	a5,a5,s0
 612:	02d00713          	li	a4,45
 616:	fee78423          	sb	a4,-24(a5)
 61a:	0028079b          	addw	a5,a6,2

  while(--i >= 0)
 61e:	02f05663          	blez	a5,64a <printint+0x86>
 622:	fb840713          	add	a4,s0,-72
 626:	00f704b3          	add	s1,a4,a5
 62a:	fff70993          	add	s3,a4,-1
 62e:	99be                	add	s3,s3,a5
 630:	37fd                	addw	a5,a5,-1
 632:	1782                	sll	a5,a5,0x20
 634:	9381                	srl	a5,a5,0x20
 636:	40f989b3          	sub	s3,s3,a5
    putc(fd, buf[i]);
 63a:	fff4c583          	lbu	a1,-1(s1)
 63e:	854a                	mv	a0,s2
 640:	f67ff0ef          	jal	5a6 <putc>
  while(--i >= 0)
 644:	14fd                	add	s1,s1,-1
 646:	ff349ae3          	bne	s1,s3,63a <printint+0x76>
}
 64a:	60a6                	ld	ra,72(sp)
 64c:	6406                	ld	s0,64(sp)
 64e:	74e2                	ld	s1,56(sp)
 650:	7942                	ld	s2,48(sp)
 652:	79a2                	ld	s3,40(sp)
 654:	6161                	add	sp,sp,80
 656:	8082                	ret
    x = -xx;
 658:	40b005b3          	neg	a1,a1
    neg = 1;
 65c:	4885                	li	a7,1
    x = -xx;
 65e:	bfbd                	j	5dc <printint+0x18>

0000000000000660 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 660:	711d                	add	sp,sp,-96
 662:	ec86                	sd	ra,88(sp)
 664:	e8a2                	sd	s0,80(sp)
 666:	e4a6                	sd	s1,72(sp)
 668:	e0ca                	sd	s2,64(sp)
 66a:	fc4e                	sd	s3,56(sp)
 66c:	f852                	sd	s4,48(sp)
 66e:	f456                	sd	s5,40(sp)
 670:	f05a                	sd	s6,32(sp)
 672:	ec5e                	sd	s7,24(sp)
 674:	e862                	sd	s8,16(sp)
 676:	e466                	sd	s9,8(sp)
 678:	e06a                	sd	s10,0(sp)
 67a:	1080                	add	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 67c:	0005c903          	lbu	s2,0(a1)
 680:	26090563          	beqz	s2,8ea <vprintf+0x28a>
 684:	8b2a                	mv	s6,a0
 686:	8a2e                	mv	s4,a1
 688:	8bb2                	mv	s7,a2
  state = 0;
 68a:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 68c:	4481                	li	s1,0
 68e:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 690:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 694:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 698:	06c00c93          	li	s9,108
 69c:	a005                	j	6bc <vprintf+0x5c>
        putc(fd, c0);
 69e:	85ca                	mv	a1,s2
 6a0:	855a                	mv	a0,s6
 6a2:	f05ff0ef          	jal	5a6 <putc>
 6a6:	a019                	j	6ac <vprintf+0x4c>
    } else if(state == '%'){
 6a8:	03598263          	beq	s3,s5,6cc <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 6ac:	2485                	addw	s1,s1,1
 6ae:	8726                	mv	a4,s1
 6b0:	009a07b3          	add	a5,s4,s1
 6b4:	0007c903          	lbu	s2,0(a5)
 6b8:	22090963          	beqz	s2,8ea <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
 6bc:	0009079b          	sext.w	a5,s2
    if(state == 0){
 6c0:	fe0994e3          	bnez	s3,6a8 <vprintf+0x48>
      if(c0 == '%'){
 6c4:	fd579de3          	bne	a5,s5,69e <vprintf+0x3e>
        state = '%';
 6c8:	89be                	mv	s3,a5
 6ca:	b7cd                	j	6ac <vprintf+0x4c>
      if(c0) c1 = fmt[i+1] & 0xff;
 6cc:	cbc9                	beqz	a5,75e <vprintf+0xfe>
 6ce:	00ea06b3          	add	a3,s4,a4
 6d2:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 6d6:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 6d8:	c681                	beqz	a3,6e0 <vprintf+0x80>
 6da:	9752                	add	a4,a4,s4
 6dc:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 6e0:	05878363          	beq	a5,s8,726 <vprintf+0xc6>
      } else if(c0 == 'l' && c1 == 'd'){
 6e4:	05978d63          	beq	a5,s9,73e <vprintf+0xde>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 6e8:	07500713          	li	a4,117
 6ec:	0ee78763          	beq	a5,a4,7da <vprintf+0x17a>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 6f0:	07800713          	li	a4,120
 6f4:	12e78963          	beq	a5,a4,826 <vprintf+0x1c6>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 6f8:	07000713          	li	a4,112
 6fc:	14e78e63          	beq	a5,a4,858 <vprintf+0x1f8>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 700:	06300713          	li	a4,99
 704:	18e78c63          	beq	a5,a4,89c <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 708:	07300713          	li	a4,115
 70c:	1ae78263          	beq	a5,a4,8b0 <vprintf+0x250>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 710:	02500713          	li	a4,37
 714:	04e79563          	bne	a5,a4,75e <vprintf+0xfe>
        putc(fd, '%');
 718:	02500593          	li	a1,37
 71c:	855a                	mv	a0,s6
 71e:	e89ff0ef          	jal	5a6 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 722:	4981                	li	s3,0
 724:	b761                	j	6ac <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 10, 1);
 726:	008b8913          	add	s2,s7,8
 72a:	4685                	li	a3,1
 72c:	4629                	li	a2,10
 72e:	000ba583          	lw	a1,0(s7)
 732:	855a                	mv	a0,s6
 734:	e91ff0ef          	jal	5c4 <printint>
 738:	8bca                	mv	s7,s2
      state = 0;
 73a:	4981                	li	s3,0
 73c:	bf85                	j	6ac <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'd'){
 73e:	06400793          	li	a5,100
 742:	02f68963          	beq	a3,a5,774 <vprintf+0x114>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 746:	06c00793          	li	a5,108
 74a:	04f68263          	beq	a3,a5,78e <vprintf+0x12e>
      } else if(c0 == 'l' && c1 == 'u'){
 74e:	07500793          	li	a5,117
 752:	0af68063          	beq	a3,a5,7f2 <vprintf+0x192>
      } else if(c0 == 'l' && c1 == 'x'){
 756:	07800793          	li	a5,120
 75a:	0ef68263          	beq	a3,a5,83e <vprintf+0x1de>
        putc(fd, '%');
 75e:	02500593          	li	a1,37
 762:	855a                	mv	a0,s6
 764:	e43ff0ef          	jal	5a6 <putc>
        putc(fd, c0);
 768:	85ca                	mv	a1,s2
 76a:	855a                	mv	a0,s6
 76c:	e3bff0ef          	jal	5a6 <putc>
      state = 0;
 770:	4981                	li	s3,0
 772:	bf2d                	j	6ac <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 774:	008b8913          	add	s2,s7,8
 778:	4685                	li	a3,1
 77a:	4629                	li	a2,10
 77c:	000bb583          	ld	a1,0(s7)
 780:	855a                	mv	a0,s6
 782:	e43ff0ef          	jal	5c4 <printint>
        i += 1;
 786:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 788:	8bca                	mv	s7,s2
      state = 0;
 78a:	4981                	li	s3,0
        i += 1;
 78c:	b705                	j	6ac <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 78e:	06400793          	li	a5,100
 792:	02f60763          	beq	a2,a5,7c0 <vprintf+0x160>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 796:	07500793          	li	a5,117
 79a:	06f60963          	beq	a2,a5,80c <vprintf+0x1ac>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 79e:	07800793          	li	a5,120
 7a2:	faf61ee3          	bne	a2,a5,75e <vprintf+0xfe>
        printint(fd, va_arg(ap, uint64), 16, 0);
 7a6:	008b8913          	add	s2,s7,8
 7aa:	4681                	li	a3,0
 7ac:	4641                	li	a2,16
 7ae:	000bb583          	ld	a1,0(s7)
 7b2:	855a                	mv	a0,s6
 7b4:	e11ff0ef          	jal	5c4 <printint>
        i += 2;
 7b8:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 7ba:	8bca                	mv	s7,s2
      state = 0;
 7bc:	4981                	li	s3,0
        i += 2;
 7be:	b5fd                	j	6ac <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 7c0:	008b8913          	add	s2,s7,8
 7c4:	4685                	li	a3,1
 7c6:	4629                	li	a2,10
 7c8:	000bb583          	ld	a1,0(s7)
 7cc:	855a                	mv	a0,s6
 7ce:	df7ff0ef          	jal	5c4 <printint>
        i += 2;
 7d2:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 7d4:	8bca                	mv	s7,s2
      state = 0;
 7d6:	4981                	li	s3,0
        i += 2;
 7d8:	bdd1                	j	6ac <vprintf+0x4c>
        printint(fd, va_arg(ap, uint32), 10, 0);
 7da:	008b8913          	add	s2,s7,8
 7de:	4681                	li	a3,0
 7e0:	4629                	li	a2,10
 7e2:	000be583          	lwu	a1,0(s7)
 7e6:	855a                	mv	a0,s6
 7e8:	dddff0ef          	jal	5c4 <printint>
 7ec:	8bca                	mv	s7,s2
      state = 0;
 7ee:	4981                	li	s3,0
 7f0:	bd75                	j	6ac <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7f2:	008b8913          	add	s2,s7,8
 7f6:	4681                	li	a3,0
 7f8:	4629                	li	a2,10
 7fa:	000bb583          	ld	a1,0(s7)
 7fe:	855a                	mv	a0,s6
 800:	dc5ff0ef          	jal	5c4 <printint>
        i += 1;
 804:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 806:	8bca                	mv	s7,s2
      state = 0;
 808:	4981                	li	s3,0
        i += 1;
 80a:	b54d                	j	6ac <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 80c:	008b8913          	add	s2,s7,8
 810:	4681                	li	a3,0
 812:	4629                	li	a2,10
 814:	000bb583          	ld	a1,0(s7)
 818:	855a                	mv	a0,s6
 81a:	dabff0ef          	jal	5c4 <printint>
        i += 2;
 81e:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 820:	8bca                	mv	s7,s2
      state = 0;
 822:	4981                	li	s3,0
        i += 2;
 824:	b561                	j	6ac <vprintf+0x4c>
        printint(fd, va_arg(ap, uint32), 16, 0);
 826:	008b8913          	add	s2,s7,8
 82a:	4681                	li	a3,0
 82c:	4641                	li	a2,16
 82e:	000be583          	lwu	a1,0(s7)
 832:	855a                	mv	a0,s6
 834:	d91ff0ef          	jal	5c4 <printint>
 838:	8bca                	mv	s7,s2
      state = 0;
 83a:	4981                	li	s3,0
 83c:	bd85                	j	6ac <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 16, 0);
 83e:	008b8913          	add	s2,s7,8
 842:	4681                	li	a3,0
 844:	4641                	li	a2,16
 846:	000bb583          	ld	a1,0(s7)
 84a:	855a                	mv	a0,s6
 84c:	d79ff0ef          	jal	5c4 <printint>
        i += 1;
 850:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 852:	8bca                	mv	s7,s2
      state = 0;
 854:	4981                	li	s3,0
        i += 1;
 856:	bd99                	j	6ac <vprintf+0x4c>
        printptr(fd, va_arg(ap, uint64));
 858:	008b8d13          	add	s10,s7,8
 85c:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 860:	03000593          	li	a1,48
 864:	855a                	mv	a0,s6
 866:	d41ff0ef          	jal	5a6 <putc>
  putc(fd, 'x');
 86a:	07800593          	li	a1,120
 86e:	855a                	mv	a0,s6
 870:	d37ff0ef          	jal	5a6 <putc>
 874:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 876:	00000b97          	auipc	s7,0x0
 87a:	29ab8b93          	add	s7,s7,666 # b10 <digits>
 87e:	03c9d793          	srl	a5,s3,0x3c
 882:	97de                	add	a5,a5,s7
 884:	0007c583          	lbu	a1,0(a5)
 888:	855a                	mv	a0,s6
 88a:	d1dff0ef          	jal	5a6 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 88e:	0992                	sll	s3,s3,0x4
 890:	397d                	addw	s2,s2,-1
 892:	fe0916e3          	bnez	s2,87e <vprintf+0x21e>
        printptr(fd, va_arg(ap, uint64));
 896:	8bea                	mv	s7,s10
      state = 0;
 898:	4981                	li	s3,0
 89a:	bd09                	j	6ac <vprintf+0x4c>
        putc(fd, va_arg(ap, uint32));
 89c:	008b8913          	add	s2,s7,8
 8a0:	000bc583          	lbu	a1,0(s7)
 8a4:	855a                	mv	a0,s6
 8a6:	d01ff0ef          	jal	5a6 <putc>
 8aa:	8bca                	mv	s7,s2
      state = 0;
 8ac:	4981                	li	s3,0
 8ae:	bbfd                	j	6ac <vprintf+0x4c>
        if((s = va_arg(ap, char*)) == 0)
 8b0:	008b8993          	add	s3,s7,8
 8b4:	000bb903          	ld	s2,0(s7)
 8b8:	00090f63          	beqz	s2,8d6 <vprintf+0x276>
        for(; *s; s++)
 8bc:	00094583          	lbu	a1,0(s2)
 8c0:	c195                	beqz	a1,8e4 <vprintf+0x284>
          putc(fd, *s);
 8c2:	855a                	mv	a0,s6
 8c4:	ce3ff0ef          	jal	5a6 <putc>
        for(; *s; s++)
 8c8:	0905                	add	s2,s2,1
 8ca:	00094583          	lbu	a1,0(s2)
 8ce:	f9f5                	bnez	a1,8c2 <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 8d0:	8bce                	mv	s7,s3
      state = 0;
 8d2:	4981                	li	s3,0
 8d4:	bbe1                	j	6ac <vprintf+0x4c>
          s = "(null)";
 8d6:	00000917          	auipc	s2,0x0
 8da:	23290913          	add	s2,s2,562 # b08 <malloc+0x124>
        for(; *s; s++)
 8de:	02800593          	li	a1,40
 8e2:	b7c5                	j	8c2 <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 8e4:	8bce                	mv	s7,s3
      state = 0;
 8e6:	4981                	li	s3,0
 8e8:	b3d1                	j	6ac <vprintf+0x4c>
    }
  }
}
 8ea:	60e6                	ld	ra,88(sp)
 8ec:	6446                	ld	s0,80(sp)
 8ee:	64a6                	ld	s1,72(sp)
 8f0:	6906                	ld	s2,64(sp)
 8f2:	79e2                	ld	s3,56(sp)
 8f4:	7a42                	ld	s4,48(sp)
 8f6:	7aa2                	ld	s5,40(sp)
 8f8:	7b02                	ld	s6,32(sp)
 8fa:	6be2                	ld	s7,24(sp)
 8fc:	6c42                	ld	s8,16(sp)
 8fe:	6ca2                	ld	s9,8(sp)
 900:	6d02                	ld	s10,0(sp)
 902:	6125                	add	sp,sp,96
 904:	8082                	ret

0000000000000906 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 906:	715d                	add	sp,sp,-80
 908:	ec06                	sd	ra,24(sp)
 90a:	e822                	sd	s0,16(sp)
 90c:	1000                	add	s0,sp,32
 90e:	e010                	sd	a2,0(s0)
 910:	e414                	sd	a3,8(s0)
 912:	e818                	sd	a4,16(s0)
 914:	ec1c                	sd	a5,24(s0)
 916:	03043023          	sd	a6,32(s0)
 91a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 91e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 922:	8622                	mv	a2,s0
 924:	d3dff0ef          	jal	660 <vprintf>
}
 928:	60e2                	ld	ra,24(sp)
 92a:	6442                	ld	s0,16(sp)
 92c:	6161                	add	sp,sp,80
 92e:	8082                	ret

0000000000000930 <printf>:

void
printf(const char *fmt, ...)
{
 930:	711d                	add	sp,sp,-96
 932:	ec06                	sd	ra,24(sp)
 934:	e822                	sd	s0,16(sp)
 936:	1000                	add	s0,sp,32
 938:	e40c                	sd	a1,8(s0)
 93a:	e810                	sd	a2,16(s0)
 93c:	ec14                	sd	a3,24(s0)
 93e:	f018                	sd	a4,32(s0)
 940:	f41c                	sd	a5,40(s0)
 942:	03043823          	sd	a6,48(s0)
 946:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 94a:	00840613          	add	a2,s0,8
 94e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 952:	85aa                	mv	a1,a0
 954:	4505                	li	a0,1
 956:	d0bff0ef          	jal	660 <vprintf>
}
 95a:	60e2                	ld	ra,24(sp)
 95c:	6442                	ld	s0,16(sp)
 95e:	6125                	add	sp,sp,96
 960:	8082                	ret

0000000000000962 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 962:	1141                	add	sp,sp,-16
 964:	e422                	sd	s0,8(sp)
 966:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 968:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 96c:	00000797          	auipc	a5,0x0
 970:	6947b783          	ld	a5,1684(a5) # 1000 <freep>
 974:	a02d                	j	99e <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 976:	4618                	lw	a4,8(a2)
 978:	9f2d                	addw	a4,a4,a1
 97a:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 97e:	6398                	ld	a4,0(a5)
 980:	6310                	ld	a2,0(a4)
 982:	a83d                	j	9c0 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 984:	ff852703          	lw	a4,-8(a0)
 988:	9f31                	addw	a4,a4,a2
 98a:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 98c:	ff053683          	ld	a3,-16(a0)
 990:	a091                	j	9d4 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 992:	6398                	ld	a4,0(a5)
 994:	00e7e463          	bltu	a5,a4,99c <free+0x3a>
 998:	00e6ea63          	bltu	a3,a4,9ac <free+0x4a>
{
 99c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 99e:	fed7fae3          	bgeu	a5,a3,992 <free+0x30>
 9a2:	6398                	ld	a4,0(a5)
 9a4:	00e6e463          	bltu	a3,a4,9ac <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9a8:	fee7eae3          	bltu	a5,a4,99c <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 9ac:	ff852583          	lw	a1,-8(a0)
 9b0:	6390                	ld	a2,0(a5)
 9b2:	02059813          	sll	a6,a1,0x20
 9b6:	01c85713          	srl	a4,a6,0x1c
 9ba:	9736                	add	a4,a4,a3
 9bc:	fae60de3          	beq	a2,a4,976 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 9c0:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 9c4:	4790                	lw	a2,8(a5)
 9c6:	02061593          	sll	a1,a2,0x20
 9ca:	01c5d713          	srl	a4,a1,0x1c
 9ce:	973e                	add	a4,a4,a5
 9d0:	fae68ae3          	beq	a3,a4,984 <free+0x22>
    p->s.ptr = bp->s.ptr;
 9d4:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 9d6:	00000717          	auipc	a4,0x0
 9da:	62f73523          	sd	a5,1578(a4) # 1000 <freep>
}
 9de:	6422                	ld	s0,8(sp)
 9e0:	0141                	add	sp,sp,16
 9e2:	8082                	ret

00000000000009e4 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 9e4:	7139                	add	sp,sp,-64
 9e6:	fc06                	sd	ra,56(sp)
 9e8:	f822                	sd	s0,48(sp)
 9ea:	f426                	sd	s1,40(sp)
 9ec:	f04a                	sd	s2,32(sp)
 9ee:	ec4e                	sd	s3,24(sp)
 9f0:	e852                	sd	s4,16(sp)
 9f2:	e456                	sd	s5,8(sp)
 9f4:	e05a                	sd	s6,0(sp)
 9f6:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9f8:	02051493          	sll	s1,a0,0x20
 9fc:	9081                	srl	s1,s1,0x20
 9fe:	04bd                	add	s1,s1,15
 a00:	8091                	srl	s1,s1,0x4
 a02:	0014899b          	addw	s3,s1,1
 a06:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 a08:	00000517          	auipc	a0,0x0
 a0c:	5f853503          	ld	a0,1528(a0) # 1000 <freep>
 a10:	c515                	beqz	a0,a3c <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a12:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a14:	4798                	lw	a4,8(a5)
 a16:	02977f63          	bgeu	a4,s1,a54 <malloc+0x70>
  if(nu < 4096)
 a1a:	8a4e                	mv	s4,s3
 a1c:	0009871b          	sext.w	a4,s3
 a20:	6685                	lui	a3,0x1
 a22:	00d77363          	bgeu	a4,a3,a28 <malloc+0x44>
 a26:	6a05                	lui	s4,0x1
 a28:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a2c:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a30:	00000917          	auipc	s2,0x0
 a34:	5d090913          	add	s2,s2,1488 # 1000 <freep>
  if(p == SBRK_ERROR)
 a38:	5afd                	li	s5,-1
 a3a:	a885                	j	aaa <malloc+0xc6>
    base.s.ptr = freep = prevp = &base;
 a3c:	00001797          	auipc	a5,0x1
 a40:	9d478793          	add	a5,a5,-1580 # 1410 <base>
 a44:	00000717          	auipc	a4,0x0
 a48:	5af73e23          	sd	a5,1468(a4) # 1000 <freep>
 a4c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a4e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a52:	b7e1                	j	a1a <malloc+0x36>
      if(p->s.size == nunits)
 a54:	02e48c63          	beq	s1,a4,a8c <malloc+0xa8>
        p->s.size -= nunits;
 a58:	4137073b          	subw	a4,a4,s3
 a5c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a5e:	02071693          	sll	a3,a4,0x20
 a62:	01c6d713          	srl	a4,a3,0x1c
 a66:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a68:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a6c:	00000717          	auipc	a4,0x0
 a70:	58a73a23          	sd	a0,1428(a4) # 1000 <freep>
      return (void*)(p + 1);
 a74:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 a78:	70e2                	ld	ra,56(sp)
 a7a:	7442                	ld	s0,48(sp)
 a7c:	74a2                	ld	s1,40(sp)
 a7e:	7902                	ld	s2,32(sp)
 a80:	69e2                	ld	s3,24(sp)
 a82:	6a42                	ld	s4,16(sp)
 a84:	6aa2                	ld	s5,8(sp)
 a86:	6b02                	ld	s6,0(sp)
 a88:	6121                	add	sp,sp,64
 a8a:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 a8c:	6398                	ld	a4,0(a5)
 a8e:	e118                	sd	a4,0(a0)
 a90:	bff1                	j	a6c <malloc+0x88>
  hp->s.size = nu;
 a92:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a96:	0541                	add	a0,a0,16
 a98:	ecbff0ef          	jal	962 <free>
  return freep;
 a9c:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 aa0:	dd61                	beqz	a0,a78 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 aa2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 aa4:	4798                	lw	a4,8(a5)
 aa6:	fa9777e3          	bgeu	a4,s1,a54 <malloc+0x70>
    if(p == freep)
 aaa:	00093703          	ld	a4,0(s2)
 aae:	853e                	mv	a0,a5
 ab0:	fef719e3          	bne	a4,a5,aa2 <malloc+0xbe>
  p = sbrk(nu * sizeof(Header));
 ab4:	8552                	mv	a0,s4
 ab6:	a05ff0ef          	jal	4ba <sbrk>
  if(p == SBRK_ERROR)
 aba:	fd551ce3          	bne	a0,s5,a92 <malloc+0xae>
        return 0;
 abe:	4501                	li	a0,0
 ac0:	bf65                	j	a78 <malloc+0x94>
