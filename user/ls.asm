
user/_ls:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <fmtname>:
#include "kernel/fs.h"
#include "kernel/fcntl.h"

char*
fmtname(char *path)
{
   0:	7179                	add	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	add	s0,sp,48
   e:	84aa                	mv	s1,a0
  static char buf[DIRSIZ+1];
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
  10:	2aa000ef          	jal	2ba <strlen>
  14:	02051793          	sll	a5,a0,0x20
  18:	9381                	srl	a5,a5,0x20
  1a:	97a6                	add	a5,a5,s1
  1c:	02f00693          	li	a3,47
  20:	0097e963          	bltu	a5,s1,32 <fmtname+0x32>
  24:	0007c703          	lbu	a4,0(a5)
  28:	00d70563          	beq	a4,a3,32 <fmtname+0x32>
  2c:	17fd                	add	a5,a5,-1
  2e:	fe97fbe3          	bgeu	a5,s1,24 <fmtname+0x24>
    ;
  p++;
  32:	00178493          	add	s1,a5,1

  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
  36:	8526                	mv	a0,s1
  38:	282000ef          	jal	2ba <strlen>
  3c:	2501                	sext.w	a0,a0
  3e:	47b5                	li	a5,13
  40:	00a7fa63          	bgeu	a5,a0,54 <fmtname+0x54>
    return p;
  memmove(buf, p, strlen(p));
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  buf[sizeof(buf)-1] = '\0';
  return buf;
}
  44:	8526                	mv	a0,s1
  46:	70a2                	ld	ra,40(sp)
  48:	7402                	ld	s0,32(sp)
  4a:	64e2                	ld	s1,24(sp)
  4c:	6942                	ld	s2,16(sp)
  4e:	69a2                	ld	s3,8(sp)
  50:	6145                	add	sp,sp,48
  52:	8082                	ret
  memmove(buf, p, strlen(p));
  54:	8526                	mv	a0,s1
  56:	264000ef          	jal	2ba <strlen>
  5a:	00001997          	auipc	s3,0x1
  5e:	fb698993          	add	s3,s3,-74 # 1010 <buf.0>
  62:	0005061b          	sext.w	a2,a0
  66:	85a6                	mv	a1,s1
  68:	854e                	mv	a0,s3
  6a:	3b2000ef          	jal	41c <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  6e:	8526                	mv	a0,s1
  70:	24a000ef          	jal	2ba <strlen>
  74:	0005091b          	sext.w	s2,a0
  78:	8526                	mv	a0,s1
  7a:	240000ef          	jal	2ba <strlen>
  7e:	1902                	sll	s2,s2,0x20
  80:	02095913          	srl	s2,s2,0x20
  84:	4639                	li	a2,14
  86:	9e09                	subw	a2,a2,a0
  88:	02000593          	li	a1,32
  8c:	01298533          	add	a0,s3,s2
  90:	254000ef          	jal	2e4 <memset>
  buf[sizeof(buf)-1] = '\0';
  94:	00098723          	sb	zero,14(s3)
  return buf;
  98:	84ce                	mv	s1,s3
  9a:	b76d                	j	44 <fmtname+0x44>

000000000000009c <ls>:

void
ls(char *path)
{
  9c:	d9010113          	add	sp,sp,-624
  a0:	26113423          	sd	ra,616(sp)
  a4:	26813023          	sd	s0,608(sp)
  a8:	24913c23          	sd	s1,600(sp)
  ac:	25213823          	sd	s2,592(sp)
  b0:	25313423          	sd	s3,584(sp)
  b4:	25413023          	sd	s4,576(sp)
  b8:	23513c23          	sd	s5,568(sp)
  bc:	1c80                	add	s0,sp,624
  be:	892a                	mv	s2,a0
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, O_RDONLY)) < 0){
  c0:	4581                	li	a1,0
  c2:	474000ef          	jal	536 <open>
  c6:	06054763          	bltz	a0,134 <ls+0x98>
  ca:	84aa                	mv	s1,a0
    fprintf(2, "ls: cannot open %s\n", path);
    return;
  }

  if(fstat(fd, &st) < 0){
  cc:	d9840593          	add	a1,s0,-616
  d0:	47e000ef          	jal	54e <fstat>
  d4:	06054963          	bltz	a0,146 <ls+0xaa>
    fprintf(2, "ls: cannot stat %s\n", path);
    close(fd);
    return;
  }

  switch(st.type){
  d8:	da041783          	lh	a5,-608(s0)
  dc:	4705                	li	a4,1
  de:	08e78063          	beq	a5,a4,15e <ls+0xc2>
  e2:	37f9                	addw	a5,a5,-2
  e4:	17c2                	sll	a5,a5,0x30
  e6:	93c1                	srl	a5,a5,0x30
  e8:	02f76263          	bltu	a4,a5,10c <ls+0x70>
  case T_DEVICE:
  case T_FILE:
    printf("%s %d %d %d\n", fmtname(path), st.type, st.ino, (int) st.size);
  ec:	854a                	mv	a0,s2
  ee:	f13ff0ef          	jal	0 <fmtname>
  f2:	85aa                	mv	a1,a0
  f4:	da842703          	lw	a4,-600(s0)
  f8:	d9c42683          	lw	a3,-612(s0)
  fc:	da041603          	lh	a2,-608(s0)
 100:	00001517          	auipc	a0,0x1
 104:	a0050513          	add	a0,a0,-1536 # b00 <malloc+0x114>
 108:	031000ef          	jal	938 <printf>
      }
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, (int) st.size);
    }
    break;
  }
  close(fd);
 10c:	8526                	mv	a0,s1
 10e:	410000ef          	jal	51e <close>
}
 112:	26813083          	ld	ra,616(sp)
 116:	26013403          	ld	s0,608(sp)
 11a:	25813483          	ld	s1,600(sp)
 11e:	25013903          	ld	s2,592(sp)
 122:	24813983          	ld	s3,584(sp)
 126:	24013a03          	ld	s4,576(sp)
 12a:	23813a83          	ld	s5,568(sp)
 12e:	27010113          	add	sp,sp,624
 132:	8082                	ret
    fprintf(2, "ls: cannot open %s\n", path);
 134:	864a                	mv	a2,s2
 136:	00001597          	auipc	a1,0x1
 13a:	99a58593          	add	a1,a1,-1638 # ad0 <malloc+0xe4>
 13e:	4509                	li	a0,2
 140:	7ce000ef          	jal	90e <fprintf>
    return;
 144:	b7f9                	j	112 <ls+0x76>
    fprintf(2, "ls: cannot stat %s\n", path);
 146:	864a                	mv	a2,s2
 148:	00001597          	auipc	a1,0x1
 14c:	9a058593          	add	a1,a1,-1632 # ae8 <malloc+0xfc>
 150:	4509                	li	a0,2
 152:	7bc000ef          	jal	90e <fprintf>
    close(fd);
 156:	8526                	mv	a0,s1
 158:	3c6000ef          	jal	51e <close>
    return;
 15c:	bf5d                	j	112 <ls+0x76>
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 15e:	854a                	mv	a0,s2
 160:	15a000ef          	jal	2ba <strlen>
 164:	2541                	addw	a0,a0,16
 166:	20000793          	li	a5,512
 16a:	00a7f963          	bgeu	a5,a0,17c <ls+0xe0>
      printf("ls: path too long\n");
 16e:	00001517          	auipc	a0,0x1
 172:	9a250513          	add	a0,a0,-1630 # b10 <malloc+0x124>
 176:	7c2000ef          	jal	938 <printf>
      break;
 17a:	bf49                	j	10c <ls+0x70>
    strcpy(buf, path);
 17c:	85ca                	mv	a1,s2
 17e:	dc040513          	add	a0,s0,-576
 182:	0f0000ef          	jal	272 <strcpy>
    p = buf+strlen(buf);
 186:	dc040513          	add	a0,s0,-576
 18a:	130000ef          	jal	2ba <strlen>
 18e:	1502                	sll	a0,a0,0x20
 190:	9101                	srl	a0,a0,0x20
 192:	dc040793          	add	a5,s0,-576
 196:	00a78933          	add	s2,a5,a0
    *p++ = '/';
 19a:	00190993          	add	s3,s2,1
 19e:	02f00793          	li	a5,47
 1a2:	00f90023          	sb	a5,0(s2)
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, (int) st.size);
 1a6:	00001a17          	auipc	s4,0x1
 1aa:	95aa0a13          	add	s4,s4,-1702 # b00 <malloc+0x114>
        printf("ls: cannot stat %s\n", buf);
 1ae:	00001a97          	auipc	s5,0x1
 1b2:	93aa8a93          	add	s5,s5,-1734 # ae8 <malloc+0xfc>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1b6:	a031                	j	1c2 <ls+0x126>
        printf("ls: cannot stat %s\n", buf);
 1b8:	dc040593          	add	a1,s0,-576
 1bc:	8556                	mv	a0,s5
 1be:	77a000ef          	jal	938 <printf>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1c2:	4641                	li	a2,16
 1c4:	db040593          	add	a1,s0,-592
 1c8:	8526                	mv	a0,s1
 1ca:	344000ef          	jal	50e <read>
 1ce:	47c1                	li	a5,16
 1d0:	f2f51ee3          	bne	a0,a5,10c <ls+0x70>
      if(de.inum == 0)
 1d4:	db045783          	lhu	a5,-592(s0)
 1d8:	d7ed                	beqz	a5,1c2 <ls+0x126>
      memmove(p, de.name, DIRSIZ);
 1da:	4639                	li	a2,14
 1dc:	db240593          	add	a1,s0,-590
 1e0:	854e                	mv	a0,s3
 1e2:	23a000ef          	jal	41c <memmove>
      p[DIRSIZ] = 0;
 1e6:	000907a3          	sb	zero,15(s2)
      if(stat(buf, &st) < 0){
 1ea:	d9840593          	add	a1,s0,-616
 1ee:	dc040513          	add	a0,s0,-576
 1f2:	1a8000ef          	jal	39a <stat>
 1f6:	fc0541e3          	bltz	a0,1b8 <ls+0x11c>
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, (int) st.size);
 1fa:	dc040513          	add	a0,s0,-576
 1fe:	e03ff0ef          	jal	0 <fmtname>
 202:	85aa                	mv	a1,a0
 204:	da842703          	lw	a4,-600(s0)
 208:	d9c42683          	lw	a3,-612(s0)
 20c:	da041603          	lh	a2,-608(s0)
 210:	8552                	mv	a0,s4
 212:	726000ef          	jal	938 <printf>
 216:	b775                	j	1c2 <ls+0x126>

0000000000000218 <main>:

int
main(int argc, char *argv[])
{
 218:	1101                	add	sp,sp,-32
 21a:	ec06                	sd	ra,24(sp)
 21c:	e822                	sd	s0,16(sp)
 21e:	e426                	sd	s1,8(sp)
 220:	e04a                	sd	s2,0(sp)
 222:	1000                	add	s0,sp,32
  int i;

  if(argc < 2){
 224:	4785                	li	a5,1
 226:	02a7d563          	bge	a5,a0,250 <main+0x38>
 22a:	00858493          	add	s1,a1,8
 22e:	ffe5091b          	addw	s2,a0,-2
 232:	02091793          	sll	a5,s2,0x20
 236:	01d7d913          	srl	s2,a5,0x1d
 23a:	05c1                	add	a1,a1,16
 23c:	992e                	add	s2,s2,a1
    ls(".");
    exit(0);
  }
  for(i=1; i<argc; i++)
    ls(argv[i]);
 23e:	6088                	ld	a0,0(s1)
 240:	e5dff0ef          	jal	9c <ls>
  for(i=1; i<argc; i++)
 244:	04a1                	add	s1,s1,8
 246:	ff249ce3          	bne	s1,s2,23e <main+0x26>
  exit(0);
 24a:	4501                	li	a0,0
 24c:	2aa000ef          	jal	4f6 <exit>
    ls(".");
 250:	00001517          	auipc	a0,0x1
 254:	8d850513          	add	a0,a0,-1832 # b28 <malloc+0x13c>
 258:	e45ff0ef          	jal	9c <ls>
    exit(0);
 25c:	4501                	li	a0,0
 25e:	298000ef          	jal	4f6 <exit>

0000000000000262 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
 262:	1141                	add	sp,sp,-16
 264:	e406                	sd	ra,8(sp)
 266:	e022                	sd	s0,0(sp)
 268:	0800                	add	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
 26a:	fafff0ef          	jal	218 <main>
  exit(r);
 26e:	288000ef          	jal	4f6 <exit>

0000000000000272 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 272:	1141                	add	sp,sp,-16
 274:	e422                	sd	s0,8(sp)
 276:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 278:	87aa                	mv	a5,a0
 27a:	0585                	add	a1,a1,1
 27c:	0785                	add	a5,a5,1
 27e:	fff5c703          	lbu	a4,-1(a1)
 282:	fee78fa3          	sb	a4,-1(a5)
 286:	fb75                	bnez	a4,27a <strcpy+0x8>
    ;
  return os;
}
 288:	6422                	ld	s0,8(sp)
 28a:	0141                	add	sp,sp,16
 28c:	8082                	ret

000000000000028e <strcmp>:

int
strcmp(const char *p, const char *q)
{
 28e:	1141                	add	sp,sp,-16
 290:	e422                	sd	s0,8(sp)
 292:	0800                	add	s0,sp,16
  while(*p && *p == *q)
 294:	00054783          	lbu	a5,0(a0)
 298:	cb91                	beqz	a5,2ac <strcmp+0x1e>
 29a:	0005c703          	lbu	a4,0(a1)
 29e:	00f71763          	bne	a4,a5,2ac <strcmp+0x1e>
    p++, q++;
 2a2:	0505                	add	a0,a0,1
 2a4:	0585                	add	a1,a1,1
  while(*p && *p == *q)
 2a6:	00054783          	lbu	a5,0(a0)
 2aa:	fbe5                	bnez	a5,29a <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 2ac:	0005c503          	lbu	a0,0(a1)
}
 2b0:	40a7853b          	subw	a0,a5,a0
 2b4:	6422                	ld	s0,8(sp)
 2b6:	0141                	add	sp,sp,16
 2b8:	8082                	ret

00000000000002ba <strlen>:

uint
strlen(const char *s)
{
 2ba:	1141                	add	sp,sp,-16
 2bc:	e422                	sd	s0,8(sp)
 2be:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 2c0:	00054783          	lbu	a5,0(a0)
 2c4:	cf91                	beqz	a5,2e0 <strlen+0x26>
 2c6:	0505                	add	a0,a0,1
 2c8:	87aa                	mv	a5,a0
 2ca:	86be                	mv	a3,a5
 2cc:	0785                	add	a5,a5,1
 2ce:	fff7c703          	lbu	a4,-1(a5)
 2d2:	ff65                	bnez	a4,2ca <strlen+0x10>
 2d4:	40a6853b          	subw	a0,a3,a0
 2d8:	2505                	addw	a0,a0,1
    ;
  return n;
}
 2da:	6422                	ld	s0,8(sp)
 2dc:	0141                	add	sp,sp,16
 2de:	8082                	ret
  for(n = 0; s[n]; n++)
 2e0:	4501                	li	a0,0
 2e2:	bfe5                	j	2da <strlen+0x20>

00000000000002e4 <memset>:

void*
memset(void *dst, int c, uint n)
{
 2e4:	1141                	add	sp,sp,-16
 2e6:	e422                	sd	s0,8(sp)
 2e8:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 2ea:	ca19                	beqz	a2,300 <memset+0x1c>
 2ec:	87aa                	mv	a5,a0
 2ee:	1602                	sll	a2,a2,0x20
 2f0:	9201                	srl	a2,a2,0x20
 2f2:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 2f6:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 2fa:	0785                	add	a5,a5,1
 2fc:	fee79de3          	bne	a5,a4,2f6 <memset+0x12>
  }
  return dst;
}
 300:	6422                	ld	s0,8(sp)
 302:	0141                	add	sp,sp,16
 304:	8082                	ret

0000000000000306 <strchr>:

char*
strchr(const char *s, char c)
{
 306:	1141                	add	sp,sp,-16
 308:	e422                	sd	s0,8(sp)
 30a:	0800                	add	s0,sp,16
  for(; *s; s++)
 30c:	00054783          	lbu	a5,0(a0)
 310:	cb99                	beqz	a5,326 <strchr+0x20>
    if(*s == c)
 312:	00f58763          	beq	a1,a5,320 <strchr+0x1a>
  for(; *s; s++)
 316:	0505                	add	a0,a0,1
 318:	00054783          	lbu	a5,0(a0)
 31c:	fbfd                	bnez	a5,312 <strchr+0xc>
      return (char*)s;
  return 0;
 31e:	4501                	li	a0,0
}
 320:	6422                	ld	s0,8(sp)
 322:	0141                	add	sp,sp,16
 324:	8082                	ret
  return 0;
 326:	4501                	li	a0,0
 328:	bfe5                	j	320 <strchr+0x1a>

000000000000032a <gets>:

char*
gets(char *buf, int max)
{
 32a:	711d                	add	sp,sp,-96
 32c:	ec86                	sd	ra,88(sp)
 32e:	e8a2                	sd	s0,80(sp)
 330:	e4a6                	sd	s1,72(sp)
 332:	e0ca                	sd	s2,64(sp)
 334:	fc4e                	sd	s3,56(sp)
 336:	f852                	sd	s4,48(sp)
 338:	f456                	sd	s5,40(sp)
 33a:	f05a                	sd	s6,32(sp)
 33c:	ec5e                	sd	s7,24(sp)
 33e:	1080                	add	s0,sp,96
 340:	8baa                	mv	s7,a0
 342:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 344:	892a                	mv	s2,a0
 346:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 348:	4aa9                	li	s5,10
 34a:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 34c:	89a6                	mv	s3,s1
 34e:	2485                	addw	s1,s1,1
 350:	0344d663          	bge	s1,s4,37c <gets+0x52>
    cc = read(0, &c, 1);
 354:	4605                	li	a2,1
 356:	faf40593          	add	a1,s0,-81
 35a:	4501                	li	a0,0
 35c:	1b2000ef          	jal	50e <read>
    if(cc < 1)
 360:	00a05e63          	blez	a0,37c <gets+0x52>
    buf[i++] = c;
 364:	faf44783          	lbu	a5,-81(s0)
 368:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 36c:	01578763          	beq	a5,s5,37a <gets+0x50>
 370:	0905                	add	s2,s2,1
 372:	fd679de3          	bne	a5,s6,34c <gets+0x22>
  for(i=0; i+1 < max; ){
 376:	89a6                	mv	s3,s1
 378:	a011                	j	37c <gets+0x52>
 37a:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 37c:	99de                	add	s3,s3,s7
 37e:	00098023          	sb	zero,0(s3)
  return buf;
}
 382:	855e                	mv	a0,s7
 384:	60e6                	ld	ra,88(sp)
 386:	6446                	ld	s0,80(sp)
 388:	64a6                	ld	s1,72(sp)
 38a:	6906                	ld	s2,64(sp)
 38c:	79e2                	ld	s3,56(sp)
 38e:	7a42                	ld	s4,48(sp)
 390:	7aa2                	ld	s5,40(sp)
 392:	7b02                	ld	s6,32(sp)
 394:	6be2                	ld	s7,24(sp)
 396:	6125                	add	sp,sp,96
 398:	8082                	ret

000000000000039a <stat>:

int
stat(const char *n, struct stat *st)
{
 39a:	1101                	add	sp,sp,-32
 39c:	ec06                	sd	ra,24(sp)
 39e:	e822                	sd	s0,16(sp)
 3a0:	e426                	sd	s1,8(sp)
 3a2:	e04a                	sd	s2,0(sp)
 3a4:	1000                	add	s0,sp,32
 3a6:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3a8:	4581                	li	a1,0
 3aa:	18c000ef          	jal	536 <open>
  if(fd < 0)
 3ae:	02054163          	bltz	a0,3d0 <stat+0x36>
 3b2:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 3b4:	85ca                	mv	a1,s2
 3b6:	198000ef          	jal	54e <fstat>
 3ba:	892a                	mv	s2,a0
  close(fd);
 3bc:	8526                	mv	a0,s1
 3be:	160000ef          	jal	51e <close>
  return r;
}
 3c2:	854a                	mv	a0,s2
 3c4:	60e2                	ld	ra,24(sp)
 3c6:	6442                	ld	s0,16(sp)
 3c8:	64a2                	ld	s1,8(sp)
 3ca:	6902                	ld	s2,0(sp)
 3cc:	6105                	add	sp,sp,32
 3ce:	8082                	ret
    return -1;
 3d0:	597d                	li	s2,-1
 3d2:	bfc5                	j	3c2 <stat+0x28>

00000000000003d4 <atoi>:

int
atoi(const char *s)
{
 3d4:	1141                	add	sp,sp,-16
 3d6:	e422                	sd	s0,8(sp)
 3d8:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3da:	00054683          	lbu	a3,0(a0)
 3de:	fd06879b          	addw	a5,a3,-48
 3e2:	0ff7f793          	zext.b	a5,a5
 3e6:	4625                	li	a2,9
 3e8:	02f66863          	bltu	a2,a5,418 <atoi+0x44>
 3ec:	872a                	mv	a4,a0
  n = 0;
 3ee:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 3f0:	0705                	add	a4,a4,1
 3f2:	0025179b          	sllw	a5,a0,0x2
 3f6:	9fa9                	addw	a5,a5,a0
 3f8:	0017979b          	sllw	a5,a5,0x1
 3fc:	9fb5                	addw	a5,a5,a3
 3fe:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 402:	00074683          	lbu	a3,0(a4)
 406:	fd06879b          	addw	a5,a3,-48
 40a:	0ff7f793          	zext.b	a5,a5
 40e:	fef671e3          	bgeu	a2,a5,3f0 <atoi+0x1c>
  return n;
}
 412:	6422                	ld	s0,8(sp)
 414:	0141                	add	sp,sp,16
 416:	8082                	ret
  n = 0;
 418:	4501                	li	a0,0
 41a:	bfe5                	j	412 <atoi+0x3e>

000000000000041c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 41c:	1141                	add	sp,sp,-16
 41e:	e422                	sd	s0,8(sp)
 420:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 422:	02b57463          	bgeu	a0,a1,44a <memmove+0x2e>
    while(n-- > 0)
 426:	00c05f63          	blez	a2,444 <memmove+0x28>
 42a:	1602                	sll	a2,a2,0x20
 42c:	9201                	srl	a2,a2,0x20
 42e:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 432:	872a                	mv	a4,a0
      *dst++ = *src++;
 434:	0585                	add	a1,a1,1
 436:	0705                	add	a4,a4,1
 438:	fff5c683          	lbu	a3,-1(a1)
 43c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 440:	fee79ae3          	bne	a5,a4,434 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 444:	6422                	ld	s0,8(sp)
 446:	0141                	add	sp,sp,16
 448:	8082                	ret
    dst += n;
 44a:	00c50733          	add	a4,a0,a2
    src += n;
 44e:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 450:	fec05ae3          	blez	a2,444 <memmove+0x28>
 454:	fff6079b          	addw	a5,a2,-1
 458:	1782                	sll	a5,a5,0x20
 45a:	9381                	srl	a5,a5,0x20
 45c:	fff7c793          	not	a5,a5
 460:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 462:	15fd                	add	a1,a1,-1
 464:	177d                	add	a4,a4,-1
 466:	0005c683          	lbu	a3,0(a1)
 46a:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 46e:	fee79ae3          	bne	a5,a4,462 <memmove+0x46>
 472:	bfc9                	j	444 <memmove+0x28>

0000000000000474 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 474:	1141                	add	sp,sp,-16
 476:	e422                	sd	s0,8(sp)
 478:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 47a:	ca05                	beqz	a2,4aa <memcmp+0x36>
 47c:	fff6069b          	addw	a3,a2,-1
 480:	1682                	sll	a3,a3,0x20
 482:	9281                	srl	a3,a3,0x20
 484:	0685                	add	a3,a3,1
 486:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 488:	00054783          	lbu	a5,0(a0)
 48c:	0005c703          	lbu	a4,0(a1)
 490:	00e79863          	bne	a5,a4,4a0 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 494:	0505                	add	a0,a0,1
    p2++;
 496:	0585                	add	a1,a1,1
  while (n-- > 0) {
 498:	fed518e3          	bne	a0,a3,488 <memcmp+0x14>
  }
  return 0;
 49c:	4501                	li	a0,0
 49e:	a019                	j	4a4 <memcmp+0x30>
      return *p1 - *p2;
 4a0:	40e7853b          	subw	a0,a5,a4
}
 4a4:	6422                	ld	s0,8(sp)
 4a6:	0141                	add	sp,sp,16
 4a8:	8082                	ret
  return 0;
 4aa:	4501                	li	a0,0
 4ac:	bfe5                	j	4a4 <memcmp+0x30>

00000000000004ae <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 4ae:	1141                	add	sp,sp,-16
 4b0:	e406                	sd	ra,8(sp)
 4b2:	e022                	sd	s0,0(sp)
 4b4:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 4b6:	f67ff0ef          	jal	41c <memmove>
}
 4ba:	60a2                	ld	ra,8(sp)
 4bc:	6402                	ld	s0,0(sp)
 4be:	0141                	add	sp,sp,16
 4c0:	8082                	ret

00000000000004c2 <sbrk>:

char *
sbrk(int n) {
 4c2:	1141                	add	sp,sp,-16
 4c4:	e406                	sd	ra,8(sp)
 4c6:	e022                	sd	s0,0(sp)
 4c8:	0800                	add	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 4ca:	4585                	li	a1,1
 4cc:	0b2000ef          	jal	57e <sys_sbrk>
}
 4d0:	60a2                	ld	ra,8(sp)
 4d2:	6402                	ld	s0,0(sp)
 4d4:	0141                	add	sp,sp,16
 4d6:	8082                	ret

00000000000004d8 <sbrklazy>:

char *
sbrklazy(int n) {
 4d8:	1141                	add	sp,sp,-16
 4da:	e406                	sd	ra,8(sp)
 4dc:	e022                	sd	s0,0(sp)
 4de:	0800                	add	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 4e0:	4589                	li	a1,2
 4e2:	09c000ef          	jal	57e <sys_sbrk>
}
 4e6:	60a2                	ld	ra,8(sp)
 4e8:	6402                	ld	s0,0(sp)
 4ea:	0141                	add	sp,sp,16
 4ec:	8082                	ret

00000000000004ee <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 4ee:	4885                	li	a7,1
 ecall
 4f0:	00000073          	ecall
 ret
 4f4:	8082                	ret

00000000000004f6 <exit>:
.global exit
exit:
 li a7, SYS_exit
 4f6:	4889                	li	a7,2
 ecall
 4f8:	00000073          	ecall
 ret
 4fc:	8082                	ret

00000000000004fe <wait>:
.global wait
wait:
 li a7, SYS_wait
 4fe:	488d                	li	a7,3
 ecall
 500:	00000073          	ecall
 ret
 504:	8082                	ret

0000000000000506 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 506:	4891                	li	a7,4
 ecall
 508:	00000073          	ecall
 ret
 50c:	8082                	ret

000000000000050e <read>:
.global read
read:
 li a7, SYS_read
 50e:	4895                	li	a7,5
 ecall
 510:	00000073          	ecall
 ret
 514:	8082                	ret

0000000000000516 <write>:
.global write
write:
 li a7, SYS_write
 516:	48c1                	li	a7,16
 ecall
 518:	00000073          	ecall
 ret
 51c:	8082                	ret

000000000000051e <close>:
.global close
close:
 li a7, SYS_close
 51e:	48d5                	li	a7,21
 ecall
 520:	00000073          	ecall
 ret
 524:	8082                	ret

0000000000000526 <kill>:
.global kill
kill:
 li a7, SYS_kill
 526:	4899                	li	a7,6
 ecall
 528:	00000073          	ecall
 ret
 52c:	8082                	ret

000000000000052e <exec>:
.global exec
exec:
 li a7, SYS_exec
 52e:	489d                	li	a7,7
 ecall
 530:	00000073          	ecall
 ret
 534:	8082                	ret

0000000000000536 <open>:
.global open
open:
 li a7, SYS_open
 536:	48bd                	li	a7,15
 ecall
 538:	00000073          	ecall
 ret
 53c:	8082                	ret

000000000000053e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 53e:	48c5                	li	a7,17
 ecall
 540:	00000073          	ecall
 ret
 544:	8082                	ret

0000000000000546 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 546:	48c9                	li	a7,18
 ecall
 548:	00000073          	ecall
 ret
 54c:	8082                	ret

000000000000054e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 54e:	48a1                	li	a7,8
 ecall
 550:	00000073          	ecall
 ret
 554:	8082                	ret

0000000000000556 <link>:
.global link
link:
 li a7, SYS_link
 556:	48cd                	li	a7,19
 ecall
 558:	00000073          	ecall
 ret
 55c:	8082                	ret

000000000000055e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 55e:	48d1                	li	a7,20
 ecall
 560:	00000073          	ecall
 ret
 564:	8082                	ret

0000000000000566 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 566:	48a5                	li	a7,9
 ecall
 568:	00000073          	ecall
 ret
 56c:	8082                	ret

000000000000056e <dup>:
.global dup
dup:
 li a7, SYS_dup
 56e:	48a9                	li	a7,10
 ecall
 570:	00000073          	ecall
 ret
 574:	8082                	ret

0000000000000576 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 576:	48ad                	li	a7,11
 ecall
 578:	00000073          	ecall
 ret
 57c:	8082                	ret

000000000000057e <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 57e:	48b1                	li	a7,12
 ecall
 580:	00000073          	ecall
 ret
 584:	8082                	ret

0000000000000586 <pause>:
.global pause
pause:
 li a7, SYS_pause
 586:	48b5                	li	a7,13
 ecall
 588:	00000073          	ecall
 ret
 58c:	8082                	ret

000000000000058e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 58e:	48b9                	li	a7,14
 ecall
 590:	00000073          	ecall
 ret
 594:	8082                	ret

0000000000000596 <getcnt>:
.global getcnt
getcnt:
 li a7, SYS_getcnt
 596:	48d9                	li	a7,22
 ecall
 598:	00000073          	ecall
 ret
 59c:	8082                	ret

000000000000059e <settickets>:
.global settickets
settickets:
 li a7, SYS_settickets
 59e:	48dd                	li	a7,23
 ecall
 5a0:	00000073          	ecall
 ret
 5a4:	8082                	ret

00000000000005a6 <getpinfo>:
.global getpinfo
getpinfo:
 li a7, SYS_getpinfo
 5a6:	48e1                	li	a7,24
 ecall
 5a8:	00000073          	ecall
 ret
 5ac:	8082                	ret

00000000000005ae <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5ae:	1101                	add	sp,sp,-32
 5b0:	ec06                	sd	ra,24(sp)
 5b2:	e822                	sd	s0,16(sp)
 5b4:	1000                	add	s0,sp,32
 5b6:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 5ba:	4605                	li	a2,1
 5bc:	fef40593          	add	a1,s0,-17
 5c0:	f57ff0ef          	jal	516 <write>
}
 5c4:	60e2                	ld	ra,24(sp)
 5c6:	6442                	ld	s0,16(sp)
 5c8:	6105                	add	sp,sp,32
 5ca:	8082                	ret

00000000000005cc <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 5cc:	715d                	add	sp,sp,-80
 5ce:	e486                	sd	ra,72(sp)
 5d0:	e0a2                	sd	s0,64(sp)
 5d2:	fc26                	sd	s1,56(sp)
 5d4:	f84a                	sd	s2,48(sp)
 5d6:	f44e                	sd	s3,40(sp)
 5d8:	0880                	add	s0,sp,80
 5da:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 5dc:	c299                	beqz	a3,5e2 <printint+0x16>
 5de:	0805c163          	bltz	a1,660 <printint+0x94>
  neg = 0;
 5e2:	4881                	li	a7,0
 5e4:	fb840693          	add	a3,s0,-72
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 5e8:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 5ea:	00000517          	auipc	a0,0x0
 5ee:	54e50513          	add	a0,a0,1358 # b38 <digits>
 5f2:	883e                	mv	a6,a5
 5f4:	2785                	addw	a5,a5,1
 5f6:	02c5f733          	remu	a4,a1,a2
 5fa:	972a                	add	a4,a4,a0
 5fc:	00074703          	lbu	a4,0(a4)
 600:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 604:	872e                	mv	a4,a1
 606:	02c5d5b3          	divu	a1,a1,a2
 60a:	0685                	add	a3,a3,1
 60c:	fec773e3          	bgeu	a4,a2,5f2 <printint+0x26>
  if(neg)
 610:	00088b63          	beqz	a7,626 <printint+0x5a>
    buf[i++] = '-';
 614:	fd078793          	add	a5,a5,-48
 618:	97a2                	add	a5,a5,s0
 61a:	02d00713          	li	a4,45
 61e:	fee78423          	sb	a4,-24(a5)
 622:	0028079b          	addw	a5,a6,2

  while(--i >= 0)
 626:	02f05663          	blez	a5,652 <printint+0x86>
 62a:	fb840713          	add	a4,s0,-72
 62e:	00f704b3          	add	s1,a4,a5
 632:	fff70993          	add	s3,a4,-1
 636:	99be                	add	s3,s3,a5
 638:	37fd                	addw	a5,a5,-1
 63a:	1782                	sll	a5,a5,0x20
 63c:	9381                	srl	a5,a5,0x20
 63e:	40f989b3          	sub	s3,s3,a5
    putc(fd, buf[i]);
 642:	fff4c583          	lbu	a1,-1(s1)
 646:	854a                	mv	a0,s2
 648:	f67ff0ef          	jal	5ae <putc>
  while(--i >= 0)
 64c:	14fd                	add	s1,s1,-1
 64e:	ff349ae3          	bne	s1,s3,642 <printint+0x76>
}
 652:	60a6                	ld	ra,72(sp)
 654:	6406                	ld	s0,64(sp)
 656:	74e2                	ld	s1,56(sp)
 658:	7942                	ld	s2,48(sp)
 65a:	79a2                	ld	s3,40(sp)
 65c:	6161                	add	sp,sp,80
 65e:	8082                	ret
    x = -xx;
 660:	40b005b3          	neg	a1,a1
    neg = 1;
 664:	4885                	li	a7,1
    x = -xx;
 666:	bfbd                	j	5e4 <printint+0x18>

0000000000000668 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 668:	711d                	add	sp,sp,-96
 66a:	ec86                	sd	ra,88(sp)
 66c:	e8a2                	sd	s0,80(sp)
 66e:	e4a6                	sd	s1,72(sp)
 670:	e0ca                	sd	s2,64(sp)
 672:	fc4e                	sd	s3,56(sp)
 674:	f852                	sd	s4,48(sp)
 676:	f456                	sd	s5,40(sp)
 678:	f05a                	sd	s6,32(sp)
 67a:	ec5e                	sd	s7,24(sp)
 67c:	e862                	sd	s8,16(sp)
 67e:	e466                	sd	s9,8(sp)
 680:	e06a                	sd	s10,0(sp)
 682:	1080                	add	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 684:	0005c903          	lbu	s2,0(a1)
 688:	26090563          	beqz	s2,8f2 <vprintf+0x28a>
 68c:	8b2a                	mv	s6,a0
 68e:	8a2e                	mv	s4,a1
 690:	8bb2                	mv	s7,a2
  state = 0;
 692:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 694:	4481                	li	s1,0
 696:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 698:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 69c:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 6a0:	06c00c93          	li	s9,108
 6a4:	a005                	j	6c4 <vprintf+0x5c>
        putc(fd, c0);
 6a6:	85ca                	mv	a1,s2
 6a8:	855a                	mv	a0,s6
 6aa:	f05ff0ef          	jal	5ae <putc>
 6ae:	a019                	j	6b4 <vprintf+0x4c>
    } else if(state == '%'){
 6b0:	03598263          	beq	s3,s5,6d4 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 6b4:	2485                	addw	s1,s1,1
 6b6:	8726                	mv	a4,s1
 6b8:	009a07b3          	add	a5,s4,s1
 6bc:	0007c903          	lbu	s2,0(a5)
 6c0:	22090963          	beqz	s2,8f2 <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
 6c4:	0009079b          	sext.w	a5,s2
    if(state == 0){
 6c8:	fe0994e3          	bnez	s3,6b0 <vprintf+0x48>
      if(c0 == '%'){
 6cc:	fd579de3          	bne	a5,s5,6a6 <vprintf+0x3e>
        state = '%';
 6d0:	89be                	mv	s3,a5
 6d2:	b7cd                	j	6b4 <vprintf+0x4c>
      if(c0) c1 = fmt[i+1] & 0xff;
 6d4:	cbc9                	beqz	a5,766 <vprintf+0xfe>
 6d6:	00ea06b3          	add	a3,s4,a4
 6da:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 6de:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 6e0:	c681                	beqz	a3,6e8 <vprintf+0x80>
 6e2:	9752                	add	a4,a4,s4
 6e4:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 6e8:	05878363          	beq	a5,s8,72e <vprintf+0xc6>
      } else if(c0 == 'l' && c1 == 'd'){
 6ec:	05978d63          	beq	a5,s9,746 <vprintf+0xde>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 6f0:	07500713          	li	a4,117
 6f4:	0ee78763          	beq	a5,a4,7e2 <vprintf+0x17a>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 6f8:	07800713          	li	a4,120
 6fc:	12e78963          	beq	a5,a4,82e <vprintf+0x1c6>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 700:	07000713          	li	a4,112
 704:	14e78e63          	beq	a5,a4,860 <vprintf+0x1f8>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 708:	06300713          	li	a4,99
 70c:	18e78c63          	beq	a5,a4,8a4 <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 710:	07300713          	li	a4,115
 714:	1ae78263          	beq	a5,a4,8b8 <vprintf+0x250>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 718:	02500713          	li	a4,37
 71c:	04e79563          	bne	a5,a4,766 <vprintf+0xfe>
        putc(fd, '%');
 720:	02500593          	li	a1,37
 724:	855a                	mv	a0,s6
 726:	e89ff0ef          	jal	5ae <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 72a:	4981                	li	s3,0
 72c:	b761                	j	6b4 <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 10, 1);
 72e:	008b8913          	add	s2,s7,8
 732:	4685                	li	a3,1
 734:	4629                	li	a2,10
 736:	000ba583          	lw	a1,0(s7)
 73a:	855a                	mv	a0,s6
 73c:	e91ff0ef          	jal	5cc <printint>
 740:	8bca                	mv	s7,s2
      state = 0;
 742:	4981                	li	s3,0
 744:	bf85                	j	6b4 <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'd'){
 746:	06400793          	li	a5,100
 74a:	02f68963          	beq	a3,a5,77c <vprintf+0x114>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 74e:	06c00793          	li	a5,108
 752:	04f68263          	beq	a3,a5,796 <vprintf+0x12e>
      } else if(c0 == 'l' && c1 == 'u'){
 756:	07500793          	li	a5,117
 75a:	0af68063          	beq	a3,a5,7fa <vprintf+0x192>
      } else if(c0 == 'l' && c1 == 'x'){
 75e:	07800793          	li	a5,120
 762:	0ef68263          	beq	a3,a5,846 <vprintf+0x1de>
        putc(fd, '%');
 766:	02500593          	li	a1,37
 76a:	855a                	mv	a0,s6
 76c:	e43ff0ef          	jal	5ae <putc>
        putc(fd, c0);
 770:	85ca                	mv	a1,s2
 772:	855a                	mv	a0,s6
 774:	e3bff0ef          	jal	5ae <putc>
      state = 0;
 778:	4981                	li	s3,0
 77a:	bf2d                	j	6b4 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 77c:	008b8913          	add	s2,s7,8
 780:	4685                	li	a3,1
 782:	4629                	li	a2,10
 784:	000bb583          	ld	a1,0(s7)
 788:	855a                	mv	a0,s6
 78a:	e43ff0ef          	jal	5cc <printint>
        i += 1;
 78e:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 790:	8bca                	mv	s7,s2
      state = 0;
 792:	4981                	li	s3,0
        i += 1;
 794:	b705                	j	6b4 <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 796:	06400793          	li	a5,100
 79a:	02f60763          	beq	a2,a5,7c8 <vprintf+0x160>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 79e:	07500793          	li	a5,117
 7a2:	06f60963          	beq	a2,a5,814 <vprintf+0x1ac>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 7a6:	07800793          	li	a5,120
 7aa:	faf61ee3          	bne	a2,a5,766 <vprintf+0xfe>
        printint(fd, va_arg(ap, uint64), 16, 0);
 7ae:	008b8913          	add	s2,s7,8
 7b2:	4681                	li	a3,0
 7b4:	4641                	li	a2,16
 7b6:	000bb583          	ld	a1,0(s7)
 7ba:	855a                	mv	a0,s6
 7bc:	e11ff0ef          	jal	5cc <printint>
        i += 2;
 7c0:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 7c2:	8bca                	mv	s7,s2
      state = 0;
 7c4:	4981                	li	s3,0
        i += 2;
 7c6:	b5fd                	j	6b4 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
 7c8:	008b8913          	add	s2,s7,8
 7cc:	4685                	li	a3,1
 7ce:	4629                	li	a2,10
 7d0:	000bb583          	ld	a1,0(s7)
 7d4:	855a                	mv	a0,s6
 7d6:	df7ff0ef          	jal	5cc <printint>
        i += 2;
 7da:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 7dc:	8bca                	mv	s7,s2
      state = 0;
 7de:	4981                	li	s3,0
        i += 2;
 7e0:	bdd1                	j	6b4 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint32), 10, 0);
 7e2:	008b8913          	add	s2,s7,8
 7e6:	4681                	li	a3,0
 7e8:	4629                	li	a2,10
 7ea:	000be583          	lwu	a1,0(s7)
 7ee:	855a                	mv	a0,s6
 7f0:	dddff0ef          	jal	5cc <printint>
 7f4:	8bca                	mv	s7,s2
      state = 0;
 7f6:	4981                	li	s3,0
 7f8:	bd75                	j	6b4 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7fa:	008b8913          	add	s2,s7,8
 7fe:	4681                	li	a3,0
 800:	4629                	li	a2,10
 802:	000bb583          	ld	a1,0(s7)
 806:	855a                	mv	a0,s6
 808:	dc5ff0ef          	jal	5cc <printint>
        i += 1;
 80c:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 80e:	8bca                	mv	s7,s2
      state = 0;
 810:	4981                	li	s3,0
        i += 1;
 812:	b54d                	j	6b4 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
 814:	008b8913          	add	s2,s7,8
 818:	4681                	li	a3,0
 81a:	4629                	li	a2,10
 81c:	000bb583          	ld	a1,0(s7)
 820:	855a                	mv	a0,s6
 822:	dabff0ef          	jal	5cc <printint>
        i += 2;
 826:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 828:	8bca                	mv	s7,s2
      state = 0;
 82a:	4981                	li	s3,0
        i += 2;
 82c:	b561                	j	6b4 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint32), 16, 0);
 82e:	008b8913          	add	s2,s7,8
 832:	4681                	li	a3,0
 834:	4641                	li	a2,16
 836:	000be583          	lwu	a1,0(s7)
 83a:	855a                	mv	a0,s6
 83c:	d91ff0ef          	jal	5cc <printint>
 840:	8bca                	mv	s7,s2
      state = 0;
 842:	4981                	li	s3,0
 844:	bd85                	j	6b4 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 16, 0);
 846:	008b8913          	add	s2,s7,8
 84a:	4681                	li	a3,0
 84c:	4641                	li	a2,16
 84e:	000bb583          	ld	a1,0(s7)
 852:	855a                	mv	a0,s6
 854:	d79ff0ef          	jal	5cc <printint>
        i += 1;
 858:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 85a:	8bca                	mv	s7,s2
      state = 0;
 85c:	4981                	li	s3,0
        i += 1;
 85e:	bd99                	j	6b4 <vprintf+0x4c>
        printptr(fd, va_arg(ap, uint64));
 860:	008b8d13          	add	s10,s7,8
 864:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 868:	03000593          	li	a1,48
 86c:	855a                	mv	a0,s6
 86e:	d41ff0ef          	jal	5ae <putc>
  putc(fd, 'x');
 872:	07800593          	li	a1,120
 876:	855a                	mv	a0,s6
 878:	d37ff0ef          	jal	5ae <putc>
 87c:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 87e:	00000b97          	auipc	s7,0x0
 882:	2bab8b93          	add	s7,s7,698 # b38 <digits>
 886:	03c9d793          	srl	a5,s3,0x3c
 88a:	97de                	add	a5,a5,s7
 88c:	0007c583          	lbu	a1,0(a5)
 890:	855a                	mv	a0,s6
 892:	d1dff0ef          	jal	5ae <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 896:	0992                	sll	s3,s3,0x4
 898:	397d                	addw	s2,s2,-1
 89a:	fe0916e3          	bnez	s2,886 <vprintf+0x21e>
        printptr(fd, va_arg(ap, uint64));
 89e:	8bea                	mv	s7,s10
      state = 0;
 8a0:	4981                	li	s3,0
 8a2:	bd09                	j	6b4 <vprintf+0x4c>
        putc(fd, va_arg(ap, uint32));
 8a4:	008b8913          	add	s2,s7,8
 8a8:	000bc583          	lbu	a1,0(s7)
 8ac:	855a                	mv	a0,s6
 8ae:	d01ff0ef          	jal	5ae <putc>
 8b2:	8bca                	mv	s7,s2
      state = 0;
 8b4:	4981                	li	s3,0
 8b6:	bbfd                	j	6b4 <vprintf+0x4c>
        if((s = va_arg(ap, char*)) == 0)
 8b8:	008b8993          	add	s3,s7,8
 8bc:	000bb903          	ld	s2,0(s7)
 8c0:	00090f63          	beqz	s2,8de <vprintf+0x276>
        for(; *s; s++)
 8c4:	00094583          	lbu	a1,0(s2)
 8c8:	c195                	beqz	a1,8ec <vprintf+0x284>
          putc(fd, *s);
 8ca:	855a                	mv	a0,s6
 8cc:	ce3ff0ef          	jal	5ae <putc>
        for(; *s; s++)
 8d0:	0905                	add	s2,s2,1
 8d2:	00094583          	lbu	a1,0(s2)
 8d6:	f9f5                	bnez	a1,8ca <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 8d8:	8bce                	mv	s7,s3
      state = 0;
 8da:	4981                	li	s3,0
 8dc:	bbe1                	j	6b4 <vprintf+0x4c>
          s = "(null)";
 8de:	00000917          	auipc	s2,0x0
 8e2:	25290913          	add	s2,s2,594 # b30 <malloc+0x144>
        for(; *s; s++)
 8e6:	02800593          	li	a1,40
 8ea:	b7c5                	j	8ca <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 8ec:	8bce                	mv	s7,s3
      state = 0;
 8ee:	4981                	li	s3,0
 8f0:	b3d1                	j	6b4 <vprintf+0x4c>
    }
  }
}
 8f2:	60e6                	ld	ra,88(sp)
 8f4:	6446                	ld	s0,80(sp)
 8f6:	64a6                	ld	s1,72(sp)
 8f8:	6906                	ld	s2,64(sp)
 8fa:	79e2                	ld	s3,56(sp)
 8fc:	7a42                	ld	s4,48(sp)
 8fe:	7aa2                	ld	s5,40(sp)
 900:	7b02                	ld	s6,32(sp)
 902:	6be2                	ld	s7,24(sp)
 904:	6c42                	ld	s8,16(sp)
 906:	6ca2                	ld	s9,8(sp)
 908:	6d02                	ld	s10,0(sp)
 90a:	6125                	add	sp,sp,96
 90c:	8082                	ret

000000000000090e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 90e:	715d                	add	sp,sp,-80
 910:	ec06                	sd	ra,24(sp)
 912:	e822                	sd	s0,16(sp)
 914:	1000                	add	s0,sp,32
 916:	e010                	sd	a2,0(s0)
 918:	e414                	sd	a3,8(s0)
 91a:	e818                	sd	a4,16(s0)
 91c:	ec1c                	sd	a5,24(s0)
 91e:	03043023          	sd	a6,32(s0)
 922:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 926:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 92a:	8622                	mv	a2,s0
 92c:	d3dff0ef          	jal	668 <vprintf>
}
 930:	60e2                	ld	ra,24(sp)
 932:	6442                	ld	s0,16(sp)
 934:	6161                	add	sp,sp,80
 936:	8082                	ret

0000000000000938 <printf>:

void
printf(const char *fmt, ...)
{
 938:	711d                	add	sp,sp,-96
 93a:	ec06                	sd	ra,24(sp)
 93c:	e822                	sd	s0,16(sp)
 93e:	1000                	add	s0,sp,32
 940:	e40c                	sd	a1,8(s0)
 942:	e810                	sd	a2,16(s0)
 944:	ec14                	sd	a3,24(s0)
 946:	f018                	sd	a4,32(s0)
 948:	f41c                	sd	a5,40(s0)
 94a:	03043823          	sd	a6,48(s0)
 94e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 952:	00840613          	add	a2,s0,8
 956:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 95a:	85aa                	mv	a1,a0
 95c:	4505                	li	a0,1
 95e:	d0bff0ef          	jal	668 <vprintf>
}
 962:	60e2                	ld	ra,24(sp)
 964:	6442                	ld	s0,16(sp)
 966:	6125                	add	sp,sp,96
 968:	8082                	ret

000000000000096a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 96a:	1141                	add	sp,sp,-16
 96c:	e422                	sd	s0,8(sp)
 96e:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 970:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 974:	00000797          	auipc	a5,0x0
 978:	68c7b783          	ld	a5,1676(a5) # 1000 <freep>
 97c:	a02d                	j	9a6 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 97e:	4618                	lw	a4,8(a2)
 980:	9f2d                	addw	a4,a4,a1
 982:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 986:	6398                	ld	a4,0(a5)
 988:	6310                	ld	a2,0(a4)
 98a:	a83d                	j	9c8 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 98c:	ff852703          	lw	a4,-8(a0)
 990:	9f31                	addw	a4,a4,a2
 992:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 994:	ff053683          	ld	a3,-16(a0)
 998:	a091                	j	9dc <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 99a:	6398                	ld	a4,0(a5)
 99c:	00e7e463          	bltu	a5,a4,9a4 <free+0x3a>
 9a0:	00e6ea63          	bltu	a3,a4,9b4 <free+0x4a>
{
 9a4:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9a6:	fed7fae3          	bgeu	a5,a3,99a <free+0x30>
 9aa:	6398                	ld	a4,0(a5)
 9ac:	00e6e463          	bltu	a3,a4,9b4 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9b0:	fee7eae3          	bltu	a5,a4,9a4 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 9b4:	ff852583          	lw	a1,-8(a0)
 9b8:	6390                	ld	a2,0(a5)
 9ba:	02059813          	sll	a6,a1,0x20
 9be:	01c85713          	srl	a4,a6,0x1c
 9c2:	9736                	add	a4,a4,a3
 9c4:	fae60de3          	beq	a2,a4,97e <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 9c8:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 9cc:	4790                	lw	a2,8(a5)
 9ce:	02061593          	sll	a1,a2,0x20
 9d2:	01c5d713          	srl	a4,a1,0x1c
 9d6:	973e                	add	a4,a4,a5
 9d8:	fae68ae3          	beq	a3,a4,98c <free+0x22>
    p->s.ptr = bp->s.ptr;
 9dc:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 9de:	00000717          	auipc	a4,0x0
 9e2:	62f73123          	sd	a5,1570(a4) # 1000 <freep>
}
 9e6:	6422                	ld	s0,8(sp)
 9e8:	0141                	add	sp,sp,16
 9ea:	8082                	ret

00000000000009ec <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 9ec:	7139                	add	sp,sp,-64
 9ee:	fc06                	sd	ra,56(sp)
 9f0:	f822                	sd	s0,48(sp)
 9f2:	f426                	sd	s1,40(sp)
 9f4:	f04a                	sd	s2,32(sp)
 9f6:	ec4e                	sd	s3,24(sp)
 9f8:	e852                	sd	s4,16(sp)
 9fa:	e456                	sd	s5,8(sp)
 9fc:	e05a                	sd	s6,0(sp)
 9fe:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a00:	02051493          	sll	s1,a0,0x20
 a04:	9081                	srl	s1,s1,0x20
 a06:	04bd                	add	s1,s1,15
 a08:	8091                	srl	s1,s1,0x4
 a0a:	0014899b          	addw	s3,s1,1
 a0e:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 a10:	00000517          	auipc	a0,0x0
 a14:	5f053503          	ld	a0,1520(a0) # 1000 <freep>
 a18:	c515                	beqz	a0,a44 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a1a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a1c:	4798                	lw	a4,8(a5)
 a1e:	02977f63          	bgeu	a4,s1,a5c <malloc+0x70>
  if(nu < 4096)
 a22:	8a4e                	mv	s4,s3
 a24:	0009871b          	sext.w	a4,s3
 a28:	6685                	lui	a3,0x1
 a2a:	00d77363          	bgeu	a4,a3,a30 <malloc+0x44>
 a2e:	6a05                	lui	s4,0x1
 a30:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a34:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a38:	00000917          	auipc	s2,0x0
 a3c:	5c890913          	add	s2,s2,1480 # 1000 <freep>
  if(p == SBRK_ERROR)
 a40:	5afd                	li	s5,-1
 a42:	a885                	j	ab2 <malloc+0xc6>
    base.s.ptr = freep = prevp = &base;
 a44:	00000797          	auipc	a5,0x0
 a48:	5dc78793          	add	a5,a5,1500 # 1020 <base>
 a4c:	00000717          	auipc	a4,0x0
 a50:	5af73a23          	sd	a5,1460(a4) # 1000 <freep>
 a54:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a56:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a5a:	b7e1                	j	a22 <malloc+0x36>
      if(p->s.size == nunits)
 a5c:	02e48c63          	beq	s1,a4,a94 <malloc+0xa8>
        p->s.size -= nunits;
 a60:	4137073b          	subw	a4,a4,s3
 a64:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a66:	02071693          	sll	a3,a4,0x20
 a6a:	01c6d713          	srl	a4,a3,0x1c
 a6e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a70:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a74:	00000717          	auipc	a4,0x0
 a78:	58a73623          	sd	a0,1420(a4) # 1000 <freep>
      return (void*)(p + 1);
 a7c:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 a80:	70e2                	ld	ra,56(sp)
 a82:	7442                	ld	s0,48(sp)
 a84:	74a2                	ld	s1,40(sp)
 a86:	7902                	ld	s2,32(sp)
 a88:	69e2                	ld	s3,24(sp)
 a8a:	6a42                	ld	s4,16(sp)
 a8c:	6aa2                	ld	s5,8(sp)
 a8e:	6b02                	ld	s6,0(sp)
 a90:	6121                	add	sp,sp,64
 a92:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 a94:	6398                	ld	a4,0(a5)
 a96:	e118                	sd	a4,0(a0)
 a98:	bff1                	j	a74 <malloc+0x88>
  hp->s.size = nu;
 a9a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a9e:	0541                	add	a0,a0,16
 aa0:	ecbff0ef          	jal	96a <free>
  return freep;
 aa4:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 aa8:	dd61                	beqz	a0,a80 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 aaa:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 aac:	4798                	lw	a4,8(a5)
 aae:	fa9777e3          	bgeu	a4,s1,a5c <malloc+0x70>
    if(p == freep)
 ab2:	00093703          	ld	a4,0(s2)
 ab6:	853e                	mv	a0,a5
 ab8:	fef719e3          	bne	a4,a5,aaa <malloc+0xbe>
  p = sbrk(nu * sizeof(Header));
 abc:	8552                	mv	a0,s4
 abe:	a05ff0ef          	jal	4c2 <sbrk>
  if(p == SBRK_ERROR)
 ac2:	fd551ce3          	bne	a0,s5,a9a <malloc+0xae>
        return 0;
 ac6:	4501                	li	a0,0
 ac8:	bf65                	j	a80 <malloc+0x94>
