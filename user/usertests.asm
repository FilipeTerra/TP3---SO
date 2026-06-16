
user/_usertests:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <copyinstr1>:
}

// what if you pass ridiculous string pointers to system calls?
void
copyinstr1(char *s)
{
       0:	711d                	add	sp,sp,-96
       2:	ec86                	sd	ra,88(sp)
       4:	e8a2                	sd	s0,80(sp)
       6:	e4a6                	sd	s1,72(sp)
       8:	e0ca                	sd	s2,64(sp)
       a:	fc4e                	sd	s3,56(sp)
       c:	1080                	add	s0,sp,96
  uint64 addrs[] = { 0x80000000LL, 0x3fffffe000, 0x3ffffff000, 0x4000000000,
       e:	00008797          	auipc	a5,0x8
      12:	84a78793          	add	a5,a5,-1974 # 7858 <malloc+0x265c>
      16:	638c                	ld	a1,0(a5)
      18:	6790                	ld	a2,8(a5)
      1a:	6b94                	ld	a3,16(a5)
      1c:	6f98                	ld	a4,24(a5)
      1e:	739c                	ld	a5,32(a5)
      20:	fab43423          	sd	a1,-88(s0)
      24:	fac43823          	sd	a2,-80(s0)
      28:	fad43c23          	sd	a3,-72(s0)
      2c:	fce43023          	sd	a4,-64(s0)
      30:	fcf43423          	sd	a5,-56(s0)
                     0xffffffffffffffff };

  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
      34:	fa840493          	add	s1,s0,-88
      38:	fd040993          	add	s3,s0,-48
    uint64 addr = addrs[ai];

    int fd = open((char *)addr, O_CREATE|O_WRONLY);
      3c:	0004b903          	ld	s2,0(s1)
      40:	20100593          	li	a1,513
      44:	854a                	mv	a0,s2
      46:	501040ef          	jal	4d46 <open>
    if(fd >= 0){
      4a:	00055c63          	bgez	a0,62 <copyinstr1+0x62>
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
      4e:	04a1                	add	s1,s1,8
      50:	ff3496e3          	bne	s1,s3,3c <copyinstr1+0x3c>
      printf("open(%p) returned %d, not -1\n", (void*)addr, fd);
      exit(1);
    }
  }
}
      54:	60e6                	ld	ra,88(sp)
      56:	6446                	ld	s0,80(sp)
      58:	64a6                	ld	s1,72(sp)
      5a:	6906                	ld	s2,64(sp)
      5c:	79e2                	ld	s3,56(sp)
      5e:	6125                	add	sp,sp,96
      60:	8082                	ret
      printf("open(%p) returned %d, not -1\n", (void*)addr, fd);
      62:	862a                	mv	a2,a0
      64:	85ca                	mv	a1,s2
      66:	00005517          	auipc	a0,0x5
      6a:	27a50513          	add	a0,a0,634 # 52e0 <malloc+0xe4>
      6e:	0da050ef          	jal	5148 <printf>
      exit(1);
      72:	4505                	li	a0,1
      74:	493040ef          	jal	4d06 <exit>

0000000000000078 <bsstest>:
void
bsstest(char *s)
{
  int i;

  for(i = 0; i < sizeof(uninit); i++){
      78:	00009797          	auipc	a5,0x9
      7c:	53078793          	add	a5,a5,1328 # 95a8 <uninit>
      80:	0000c697          	auipc	a3,0xc
      84:	c3868693          	add	a3,a3,-968 # bcb8 <buf>
    if(uninit[i] != '\0'){
      88:	0007c703          	lbu	a4,0(a5)
      8c:	e709                	bnez	a4,96 <bsstest+0x1e>
  for(i = 0; i < sizeof(uninit); i++){
      8e:	0785                	add	a5,a5,1
      90:	fed79ce3          	bne	a5,a3,88 <bsstest+0x10>
      94:	8082                	ret
{
      96:	1141                	add	sp,sp,-16
      98:	e406                	sd	ra,8(sp)
      9a:	e022                	sd	s0,0(sp)
      9c:	0800                	add	s0,sp,16
      printf("%s: bss test failed\n", s);
      9e:	85aa                	mv	a1,a0
      a0:	00005517          	auipc	a0,0x5
      a4:	26050513          	add	a0,a0,608 # 5300 <malloc+0x104>
      a8:	0a0050ef          	jal	5148 <printf>
      exit(1);
      ac:	4505                	li	a0,1
      ae:	459040ef          	jal	4d06 <exit>

00000000000000b2 <opentest>:
{
      b2:	1101                	add	sp,sp,-32
      b4:	ec06                	sd	ra,24(sp)
      b6:	e822                	sd	s0,16(sp)
      b8:	e426                	sd	s1,8(sp)
      ba:	1000                	add	s0,sp,32
      bc:	84aa                	mv	s1,a0
  fd = open("echo", 0);
      be:	4581                	li	a1,0
      c0:	00005517          	auipc	a0,0x5
      c4:	25850513          	add	a0,a0,600 # 5318 <malloc+0x11c>
      c8:	47f040ef          	jal	4d46 <open>
  if(fd < 0){
      cc:	02054263          	bltz	a0,f0 <opentest+0x3e>
  close(fd);
      d0:	45f040ef          	jal	4d2e <close>
  fd = open("doesnotexist", 0);
      d4:	4581                	li	a1,0
      d6:	00005517          	auipc	a0,0x5
      da:	26250513          	add	a0,a0,610 # 5338 <malloc+0x13c>
      de:	469040ef          	jal	4d46 <open>
  if(fd >= 0){
      e2:	02055163          	bgez	a0,104 <opentest+0x52>
}
      e6:	60e2                	ld	ra,24(sp)
      e8:	6442                	ld	s0,16(sp)
      ea:	64a2                	ld	s1,8(sp)
      ec:	6105                	add	sp,sp,32
      ee:	8082                	ret
    printf("%s: open echo failed!\n", s);
      f0:	85a6                	mv	a1,s1
      f2:	00005517          	auipc	a0,0x5
      f6:	22e50513          	add	a0,a0,558 # 5320 <malloc+0x124>
      fa:	04e050ef          	jal	5148 <printf>
    exit(1);
      fe:	4505                	li	a0,1
     100:	407040ef          	jal	4d06 <exit>
    printf("%s: open doesnotexist succeeded!\n", s);
     104:	85a6                	mv	a1,s1
     106:	00005517          	auipc	a0,0x5
     10a:	24250513          	add	a0,a0,578 # 5348 <malloc+0x14c>
     10e:	03a050ef          	jal	5148 <printf>
    exit(1);
     112:	4505                	li	a0,1
     114:	3f3040ef          	jal	4d06 <exit>

0000000000000118 <truncate2>:
{
     118:	7179                	add	sp,sp,-48
     11a:	f406                	sd	ra,40(sp)
     11c:	f022                	sd	s0,32(sp)
     11e:	ec26                	sd	s1,24(sp)
     120:	e84a                	sd	s2,16(sp)
     122:	e44e                	sd	s3,8(sp)
     124:	1800                	add	s0,sp,48
     126:	89aa                	mv	s3,a0
  unlink("truncfile");
     128:	00005517          	auipc	a0,0x5
     12c:	24850513          	add	a0,a0,584 # 5370 <malloc+0x174>
     130:	427040ef          	jal	4d56 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_TRUNC|O_WRONLY);
     134:	60100593          	li	a1,1537
     138:	00005517          	auipc	a0,0x5
     13c:	23850513          	add	a0,a0,568 # 5370 <malloc+0x174>
     140:	407040ef          	jal	4d46 <open>
     144:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     146:	4611                	li	a2,4
     148:	00005597          	auipc	a1,0x5
     14c:	23858593          	add	a1,a1,568 # 5380 <malloc+0x184>
     150:	3d7040ef          	jal	4d26 <write>
  int fd2 = open("truncfile", O_TRUNC|O_WRONLY);
     154:	40100593          	li	a1,1025
     158:	00005517          	auipc	a0,0x5
     15c:	21850513          	add	a0,a0,536 # 5370 <malloc+0x174>
     160:	3e7040ef          	jal	4d46 <open>
     164:	892a                	mv	s2,a0
  int n = write(fd1, "x", 1);
     166:	4605                	li	a2,1
     168:	00005597          	auipc	a1,0x5
     16c:	22058593          	add	a1,a1,544 # 5388 <malloc+0x18c>
     170:	8526                	mv	a0,s1
     172:	3b5040ef          	jal	4d26 <write>
  if(n != -1){
     176:	57fd                	li	a5,-1
     178:	02f51563          	bne	a0,a5,1a2 <truncate2+0x8a>
  unlink("truncfile");
     17c:	00005517          	auipc	a0,0x5
     180:	1f450513          	add	a0,a0,500 # 5370 <malloc+0x174>
     184:	3d3040ef          	jal	4d56 <unlink>
  close(fd1);
     188:	8526                	mv	a0,s1
     18a:	3a5040ef          	jal	4d2e <close>
  close(fd2);
     18e:	854a                	mv	a0,s2
     190:	39f040ef          	jal	4d2e <close>
}
     194:	70a2                	ld	ra,40(sp)
     196:	7402                	ld	s0,32(sp)
     198:	64e2                	ld	s1,24(sp)
     19a:	6942                	ld	s2,16(sp)
     19c:	69a2                	ld	s3,8(sp)
     19e:	6145                	add	sp,sp,48
     1a0:	8082                	ret
    printf("%s: write returned %d, expected -1\n", s, n);
     1a2:	862a                	mv	a2,a0
     1a4:	85ce                	mv	a1,s3
     1a6:	00005517          	auipc	a0,0x5
     1aa:	1ea50513          	add	a0,a0,490 # 5390 <malloc+0x194>
     1ae:	79b040ef          	jal	5148 <printf>
    exit(1);
     1b2:	4505                	li	a0,1
     1b4:	353040ef          	jal	4d06 <exit>

00000000000001b8 <createtest>:
{
     1b8:	7179                	add	sp,sp,-48
     1ba:	f406                	sd	ra,40(sp)
     1bc:	f022                	sd	s0,32(sp)
     1be:	ec26                	sd	s1,24(sp)
     1c0:	e84a                	sd	s2,16(sp)
     1c2:	1800                	add	s0,sp,48
  name[0] = 'a';
     1c4:	06100793          	li	a5,97
     1c8:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     1cc:	fc040d23          	sb	zero,-38(s0)
     1d0:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
     1d4:	06400913          	li	s2,100
    name[1] = '0' + i;
     1d8:	fc940ca3          	sb	s1,-39(s0)
    fd = open(name, O_CREATE|O_RDWR);
     1dc:	20200593          	li	a1,514
     1e0:	fd840513          	add	a0,s0,-40
     1e4:	363040ef          	jal	4d46 <open>
    close(fd);
     1e8:	347040ef          	jal	4d2e <close>
  for(i = 0; i < N; i++){
     1ec:	2485                	addw	s1,s1,1
     1ee:	0ff4f493          	zext.b	s1,s1
     1f2:	ff2493e3          	bne	s1,s2,1d8 <createtest+0x20>
  name[0] = 'a';
     1f6:	06100793          	li	a5,97
     1fa:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     1fe:	fc040d23          	sb	zero,-38(s0)
     202:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
     206:	06400913          	li	s2,100
    name[1] = '0' + i;
     20a:	fc940ca3          	sb	s1,-39(s0)
    unlink(name);
     20e:	fd840513          	add	a0,s0,-40
     212:	345040ef          	jal	4d56 <unlink>
  for(i = 0; i < N; i++){
     216:	2485                	addw	s1,s1,1
     218:	0ff4f493          	zext.b	s1,s1
     21c:	ff2497e3          	bne	s1,s2,20a <createtest+0x52>
}
     220:	70a2                	ld	ra,40(sp)
     222:	7402                	ld	s0,32(sp)
     224:	64e2                	ld	s1,24(sp)
     226:	6942                	ld	s2,16(sp)
     228:	6145                	add	sp,sp,48
     22a:	8082                	ret

000000000000022c <bigwrite>:
{
     22c:	715d                	add	sp,sp,-80
     22e:	e486                	sd	ra,72(sp)
     230:	e0a2                	sd	s0,64(sp)
     232:	fc26                	sd	s1,56(sp)
     234:	f84a                	sd	s2,48(sp)
     236:	f44e                	sd	s3,40(sp)
     238:	f052                	sd	s4,32(sp)
     23a:	ec56                	sd	s5,24(sp)
     23c:	e85a                	sd	s6,16(sp)
     23e:	e45e                	sd	s7,8(sp)
     240:	0880                	add	s0,sp,80
     242:	8baa                	mv	s7,a0
  unlink("bigwrite");
     244:	00005517          	auipc	a0,0x5
     248:	17450513          	add	a0,a0,372 # 53b8 <malloc+0x1bc>
     24c:	30b040ef          	jal	4d56 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     250:	1f300493          	li	s1,499
    fd = open("bigwrite", O_CREATE | O_RDWR);
     254:	00005a97          	auipc	s5,0x5
     258:	164a8a93          	add	s5,s5,356 # 53b8 <malloc+0x1bc>
      int cc = write(fd, buf, sz);
     25c:	0000ca17          	auipc	s4,0xc
     260:	a5ca0a13          	add	s4,s4,-1444 # bcb8 <buf>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     264:	6b0d                	lui	s6,0x3
     266:	1c9b0b13          	add	s6,s6,457 # 31c9 <rmdot+0x6d>
    fd = open("bigwrite", O_CREATE | O_RDWR);
     26a:	20200593          	li	a1,514
     26e:	8556                	mv	a0,s5
     270:	2d7040ef          	jal	4d46 <open>
     274:	892a                	mv	s2,a0
    if(fd < 0){
     276:	04054563          	bltz	a0,2c0 <bigwrite+0x94>
      int cc = write(fd, buf, sz);
     27a:	8626                	mv	a2,s1
     27c:	85d2                	mv	a1,s4
     27e:	2a9040ef          	jal	4d26 <write>
     282:	89aa                	mv	s3,a0
      if(cc != sz){
     284:	04a49863          	bne	s1,a0,2d4 <bigwrite+0xa8>
      int cc = write(fd, buf, sz);
     288:	8626                	mv	a2,s1
     28a:	85d2                	mv	a1,s4
     28c:	854a                	mv	a0,s2
     28e:	299040ef          	jal	4d26 <write>
      if(cc != sz){
     292:	04951263          	bne	a0,s1,2d6 <bigwrite+0xaa>
    close(fd);
     296:	854a                	mv	a0,s2
     298:	297040ef          	jal	4d2e <close>
    unlink("bigwrite");
     29c:	8556                	mv	a0,s5
     29e:	2b9040ef          	jal	4d56 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2a2:	1d74849b          	addw	s1,s1,471
     2a6:	fd6492e3          	bne	s1,s6,26a <bigwrite+0x3e>
}
     2aa:	60a6                	ld	ra,72(sp)
     2ac:	6406                	ld	s0,64(sp)
     2ae:	74e2                	ld	s1,56(sp)
     2b0:	7942                	ld	s2,48(sp)
     2b2:	79a2                	ld	s3,40(sp)
     2b4:	7a02                	ld	s4,32(sp)
     2b6:	6ae2                	ld	s5,24(sp)
     2b8:	6b42                	ld	s6,16(sp)
     2ba:	6ba2                	ld	s7,8(sp)
     2bc:	6161                	add	sp,sp,80
     2be:	8082                	ret
      printf("%s: cannot create bigwrite\n", s);
     2c0:	85de                	mv	a1,s7
     2c2:	00005517          	auipc	a0,0x5
     2c6:	10650513          	add	a0,a0,262 # 53c8 <malloc+0x1cc>
     2ca:	67f040ef          	jal	5148 <printf>
      exit(1);
     2ce:	4505                	li	a0,1
     2d0:	237040ef          	jal	4d06 <exit>
      if(cc != sz){
     2d4:	89a6                	mv	s3,s1
        printf("%s: write(%d) ret %d\n", s, sz, cc);
     2d6:	86aa                	mv	a3,a0
     2d8:	864e                	mv	a2,s3
     2da:	85de                	mv	a1,s7
     2dc:	00005517          	auipc	a0,0x5
     2e0:	10c50513          	add	a0,a0,268 # 53e8 <malloc+0x1ec>
     2e4:	665040ef          	jal	5148 <printf>
        exit(1);
     2e8:	4505                	li	a0,1
     2ea:	21d040ef          	jal	4d06 <exit>

00000000000002ee <badwrite>:
// file is deleted? if the kernel has this bug, it will panic: balloc:
// out of blocks. assumed_free may need to be raised to be more than
// the number of free blocks. this test takes a long time.
void
badwrite(char *s)
{
     2ee:	7179                	add	sp,sp,-48
     2f0:	f406                	sd	ra,40(sp)
     2f2:	f022                	sd	s0,32(sp)
     2f4:	ec26                	sd	s1,24(sp)
     2f6:	e84a                	sd	s2,16(sp)
     2f8:	e44e                	sd	s3,8(sp)
     2fa:	e052                	sd	s4,0(sp)
     2fc:	1800                	add	s0,sp,48
  int assumed_free = 600;
  
  unlink("junk");
     2fe:	00005517          	auipc	a0,0x5
     302:	10250513          	add	a0,a0,258 # 5400 <malloc+0x204>
     306:	251040ef          	jal	4d56 <unlink>
     30a:	25800913          	li	s2,600
  for(int i = 0; i < assumed_free; i++){
    int fd = open("junk", O_CREATE|O_WRONLY);
     30e:	00005997          	auipc	s3,0x5
     312:	0f298993          	add	s3,s3,242 # 5400 <malloc+0x204>
    if(fd < 0){
      printf("open junk failed\n");
      exit(1);
    }
    write(fd, (char*)0xffffffffffL, 1);
     316:	5a7d                	li	s4,-1
     318:	018a5a13          	srl	s4,s4,0x18
    int fd = open("junk", O_CREATE|O_WRONLY);
     31c:	20100593          	li	a1,513
     320:	854e                	mv	a0,s3
     322:	225040ef          	jal	4d46 <open>
     326:	84aa                	mv	s1,a0
    if(fd < 0){
     328:	04054d63          	bltz	a0,382 <badwrite+0x94>
    write(fd, (char*)0xffffffffffL, 1);
     32c:	4605                	li	a2,1
     32e:	85d2                	mv	a1,s4
     330:	1f7040ef          	jal	4d26 <write>
    close(fd);
     334:	8526                	mv	a0,s1
     336:	1f9040ef          	jal	4d2e <close>
    unlink("junk");
     33a:	854e                	mv	a0,s3
     33c:	21b040ef          	jal	4d56 <unlink>
  for(int i = 0; i < assumed_free; i++){
     340:	397d                	addw	s2,s2,-1
     342:	fc091de3          	bnez	s2,31c <badwrite+0x2e>
  }

  int fd = open("junk", O_CREATE|O_WRONLY);
     346:	20100593          	li	a1,513
     34a:	00005517          	auipc	a0,0x5
     34e:	0b650513          	add	a0,a0,182 # 5400 <malloc+0x204>
     352:	1f5040ef          	jal	4d46 <open>
     356:	84aa                	mv	s1,a0
  if(fd < 0){
     358:	02054e63          	bltz	a0,394 <badwrite+0xa6>
    printf("open junk failed\n");
    exit(1);
  }
  if(write(fd, "x", 1) != 1){
     35c:	4605                	li	a2,1
     35e:	00005597          	auipc	a1,0x5
     362:	02a58593          	add	a1,a1,42 # 5388 <malloc+0x18c>
     366:	1c1040ef          	jal	4d26 <write>
     36a:	4785                	li	a5,1
     36c:	02f50d63          	beq	a0,a5,3a6 <badwrite+0xb8>
    printf("write failed\n");
     370:	00005517          	auipc	a0,0x5
     374:	0b050513          	add	a0,a0,176 # 5420 <malloc+0x224>
     378:	5d1040ef          	jal	5148 <printf>
    exit(1);
     37c:	4505                	li	a0,1
     37e:	189040ef          	jal	4d06 <exit>
      printf("open junk failed\n");
     382:	00005517          	auipc	a0,0x5
     386:	08650513          	add	a0,a0,134 # 5408 <malloc+0x20c>
     38a:	5bf040ef          	jal	5148 <printf>
      exit(1);
     38e:	4505                	li	a0,1
     390:	177040ef          	jal	4d06 <exit>
    printf("open junk failed\n");
     394:	00005517          	auipc	a0,0x5
     398:	07450513          	add	a0,a0,116 # 5408 <malloc+0x20c>
     39c:	5ad040ef          	jal	5148 <printf>
    exit(1);
     3a0:	4505                	li	a0,1
     3a2:	165040ef          	jal	4d06 <exit>
  }
  close(fd);
     3a6:	8526                	mv	a0,s1
     3a8:	187040ef          	jal	4d2e <close>
  unlink("junk");
     3ac:	00005517          	auipc	a0,0x5
     3b0:	05450513          	add	a0,a0,84 # 5400 <malloc+0x204>
     3b4:	1a3040ef          	jal	4d56 <unlink>

  exit(0);
     3b8:	4501                	li	a0,0
     3ba:	14d040ef          	jal	4d06 <exit>

00000000000003be <outofinodes>:
  }
}

void
outofinodes(char *s)
{
     3be:	715d                	add	sp,sp,-80
     3c0:	e486                	sd	ra,72(sp)
     3c2:	e0a2                	sd	s0,64(sp)
     3c4:	fc26                	sd	s1,56(sp)
     3c6:	f84a                	sd	s2,48(sp)
     3c8:	f44e                	sd	s3,40(sp)
     3ca:	0880                	add	s0,sp,80
  int nzz = 32*32;
  for(int i = 0; i < nzz; i++){
     3cc:	4481                	li	s1,0
    char name[32];
    name[0] = 'z';
     3ce:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
     3d2:	40000993          	li	s3,1024
    name[0] = 'z';
     3d6:	fb240823          	sb	s2,-80(s0)
    name[1] = 'z';
     3da:	fb2408a3          	sb	s2,-79(s0)
    name[2] = '0' + (i / 32);
     3de:	41f4d71b          	sraw	a4,s1,0x1f
     3e2:	01b7571b          	srlw	a4,a4,0x1b
     3e6:	009707bb          	addw	a5,a4,s1
     3ea:	4057d69b          	sraw	a3,a5,0x5
     3ee:	0306869b          	addw	a3,a3,48
     3f2:	fad40923          	sb	a3,-78(s0)
    name[3] = '0' + (i % 32);
     3f6:	8bfd                	and	a5,a5,31
     3f8:	9f99                	subw	a5,a5,a4
     3fa:	0307879b          	addw	a5,a5,48
     3fe:	faf409a3          	sb	a5,-77(s0)
    name[4] = '\0';
     402:	fa040a23          	sb	zero,-76(s0)
    unlink(name);
     406:	fb040513          	add	a0,s0,-80
     40a:	14d040ef          	jal	4d56 <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
     40e:	60200593          	li	a1,1538
     412:	fb040513          	add	a0,s0,-80
     416:	131040ef          	jal	4d46 <open>
    if(fd < 0){
     41a:	00054763          	bltz	a0,428 <outofinodes+0x6a>
      // failure is eventually expected.
      break;
    }
    close(fd);
     41e:	111040ef          	jal	4d2e <close>
  for(int i = 0; i < nzz; i++){
     422:	2485                	addw	s1,s1,1
     424:	fb3499e3          	bne	s1,s3,3d6 <outofinodes+0x18>
     428:	4481                	li	s1,0
  }

  for(int i = 0; i < nzz; i++){
    char name[32];
    name[0] = 'z';
     42a:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
     42e:	40000993          	li	s3,1024
    name[0] = 'z';
     432:	fb240823          	sb	s2,-80(s0)
    name[1] = 'z';
     436:	fb2408a3          	sb	s2,-79(s0)
    name[2] = '0' + (i / 32);
     43a:	41f4d71b          	sraw	a4,s1,0x1f
     43e:	01b7571b          	srlw	a4,a4,0x1b
     442:	009707bb          	addw	a5,a4,s1
     446:	4057d69b          	sraw	a3,a5,0x5
     44a:	0306869b          	addw	a3,a3,48
     44e:	fad40923          	sb	a3,-78(s0)
    name[3] = '0' + (i % 32);
     452:	8bfd                	and	a5,a5,31
     454:	9f99                	subw	a5,a5,a4
     456:	0307879b          	addw	a5,a5,48
     45a:	faf409a3          	sb	a5,-77(s0)
    name[4] = '\0';
     45e:	fa040a23          	sb	zero,-76(s0)
    unlink(name);
     462:	fb040513          	add	a0,s0,-80
     466:	0f1040ef          	jal	4d56 <unlink>
  for(int i = 0; i < nzz; i++){
     46a:	2485                	addw	s1,s1,1
     46c:	fd3493e3          	bne	s1,s3,432 <outofinodes+0x74>
  }
}
     470:	60a6                	ld	ra,72(sp)
     472:	6406                	ld	s0,64(sp)
     474:	74e2                	ld	s1,56(sp)
     476:	7942                	ld	s2,48(sp)
     478:	79a2                	ld	s3,40(sp)
     47a:	6161                	add	sp,sp,80
     47c:	8082                	ret

000000000000047e <copyin>:
{
     47e:	7159                	add	sp,sp,-112
     480:	f486                	sd	ra,104(sp)
     482:	f0a2                	sd	s0,96(sp)
     484:	eca6                	sd	s1,88(sp)
     486:	e8ca                	sd	s2,80(sp)
     488:	e4ce                	sd	s3,72(sp)
     48a:	e0d2                	sd	s4,64(sp)
     48c:	fc56                	sd	s5,56(sp)
     48e:	1880                	add	s0,sp,112
  uint64 addrs[] = { 0x80000000LL, 0x3fffffe000, 0x3ffffff000, 0x4000000000,
     490:	00007797          	auipc	a5,0x7
     494:	3c878793          	add	a5,a5,968 # 7858 <malloc+0x265c>
     498:	638c                	ld	a1,0(a5)
     49a:	6790                	ld	a2,8(a5)
     49c:	6b94                	ld	a3,16(a5)
     49e:	6f98                	ld	a4,24(a5)
     4a0:	739c                	ld	a5,32(a5)
     4a2:	f8b43c23          	sd	a1,-104(s0)
     4a6:	fac43023          	sd	a2,-96(s0)
     4aa:	fad43423          	sd	a3,-88(s0)
     4ae:	fae43823          	sd	a4,-80(s0)
     4b2:	faf43c23          	sd	a5,-72(s0)
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
     4b6:	f9840913          	add	s2,s0,-104
     4ba:	fc040a93          	add	s5,s0,-64
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     4be:	00005a17          	auipc	s4,0x5
     4c2:	f72a0a13          	add	s4,s4,-142 # 5430 <malloc+0x234>
    uint64 addr = addrs[ai];
     4c6:	00093983          	ld	s3,0(s2)
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     4ca:	20100593          	li	a1,513
     4ce:	8552                	mv	a0,s4
     4d0:	077040ef          	jal	4d46 <open>
     4d4:	84aa                	mv	s1,a0
    if(fd < 0){
     4d6:	06054763          	bltz	a0,544 <copyin+0xc6>
    int n = write(fd, (void*)addr, 8192);
     4da:	6609                	lui	a2,0x2
     4dc:	85ce                	mv	a1,s3
     4de:	049040ef          	jal	4d26 <write>
    if(n >= 0){
     4e2:	06055a63          	bgez	a0,556 <copyin+0xd8>
    close(fd);
     4e6:	8526                	mv	a0,s1
     4e8:	047040ef          	jal	4d2e <close>
    unlink("copyin1");
     4ec:	8552                	mv	a0,s4
     4ee:	069040ef          	jal	4d56 <unlink>
    n = write(1, (char*)addr, 8192);
     4f2:	6609                	lui	a2,0x2
     4f4:	85ce                	mv	a1,s3
     4f6:	4505                	li	a0,1
     4f8:	02f040ef          	jal	4d26 <write>
    if(n > 0){
     4fc:	06a04863          	bgtz	a0,56c <copyin+0xee>
    if(pipe(fds) < 0){
     500:	f9040513          	add	a0,s0,-112
     504:	013040ef          	jal	4d16 <pipe>
     508:	06054d63          	bltz	a0,582 <copyin+0x104>
    n = write(fds[1], (char*)addr, 8192);
     50c:	6609                	lui	a2,0x2
     50e:	85ce                	mv	a1,s3
     510:	f9442503          	lw	a0,-108(s0)
     514:	013040ef          	jal	4d26 <write>
    if(n > 0){
     518:	06a04e63          	bgtz	a0,594 <copyin+0x116>
    close(fds[0]);
     51c:	f9042503          	lw	a0,-112(s0)
     520:	00f040ef          	jal	4d2e <close>
    close(fds[1]);
     524:	f9442503          	lw	a0,-108(s0)
     528:	007040ef          	jal	4d2e <close>
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
     52c:	0921                	add	s2,s2,8
     52e:	f9591ce3          	bne	s2,s5,4c6 <copyin+0x48>
}
     532:	70a6                	ld	ra,104(sp)
     534:	7406                	ld	s0,96(sp)
     536:	64e6                	ld	s1,88(sp)
     538:	6946                	ld	s2,80(sp)
     53a:	69a6                	ld	s3,72(sp)
     53c:	6a06                	ld	s4,64(sp)
     53e:	7ae2                	ld	s5,56(sp)
     540:	6165                	add	sp,sp,112
     542:	8082                	ret
      printf("open(copyin1) failed\n");
     544:	00005517          	auipc	a0,0x5
     548:	ef450513          	add	a0,a0,-268 # 5438 <malloc+0x23c>
     54c:	3fd040ef          	jal	5148 <printf>
      exit(1);
     550:	4505                	li	a0,1
     552:	7b4040ef          	jal	4d06 <exit>
      printf("write(fd, %p, 8192) returned %d, not -1\n", (void*)addr, n);
     556:	862a                	mv	a2,a0
     558:	85ce                	mv	a1,s3
     55a:	00005517          	auipc	a0,0x5
     55e:	ef650513          	add	a0,a0,-266 # 5450 <malloc+0x254>
     562:	3e7040ef          	jal	5148 <printf>
      exit(1);
     566:	4505                	li	a0,1
     568:	79e040ef          	jal	4d06 <exit>
      printf("write(1, %p, 8192) returned %d, not -1 or 0\n", (void*)addr, n);
     56c:	862a                	mv	a2,a0
     56e:	85ce                	mv	a1,s3
     570:	00005517          	auipc	a0,0x5
     574:	f1050513          	add	a0,a0,-240 # 5480 <malloc+0x284>
     578:	3d1040ef          	jal	5148 <printf>
      exit(1);
     57c:	4505                	li	a0,1
     57e:	788040ef          	jal	4d06 <exit>
      printf("pipe() failed\n");
     582:	00005517          	auipc	a0,0x5
     586:	f2e50513          	add	a0,a0,-210 # 54b0 <malloc+0x2b4>
     58a:	3bf040ef          	jal	5148 <printf>
      exit(1);
     58e:	4505                	li	a0,1
     590:	776040ef          	jal	4d06 <exit>
      printf("write(pipe, %p, 8192) returned %d, not -1 or 0\n", (void*)addr, n);
     594:	862a                	mv	a2,a0
     596:	85ce                	mv	a1,s3
     598:	00005517          	auipc	a0,0x5
     59c:	f2850513          	add	a0,a0,-216 # 54c0 <malloc+0x2c4>
     5a0:	3a9040ef          	jal	5148 <printf>
      exit(1);
     5a4:	4505                	li	a0,1
     5a6:	760040ef          	jal	4d06 <exit>

00000000000005aa <copyout>:
{
     5aa:	7119                	add	sp,sp,-128
     5ac:	fc86                	sd	ra,120(sp)
     5ae:	f8a2                	sd	s0,112(sp)
     5b0:	f4a6                	sd	s1,104(sp)
     5b2:	f0ca                	sd	s2,96(sp)
     5b4:	ecce                	sd	s3,88(sp)
     5b6:	e8d2                	sd	s4,80(sp)
     5b8:	e4d6                	sd	s5,72(sp)
     5ba:	e0da                	sd	s6,64(sp)
     5bc:	0100                	add	s0,sp,128
  uint64 addrs[] = { 0LL, 0x80000000LL, 0x3fffffe000, 0x3ffffff000, 0x4000000000,
     5be:	00007797          	auipc	a5,0x7
     5c2:	29a78793          	add	a5,a5,666 # 7858 <malloc+0x265c>
     5c6:	7788                	ld	a0,40(a5)
     5c8:	7b8c                	ld	a1,48(a5)
     5ca:	7f90                	ld	a2,56(a5)
     5cc:	63b4                	ld	a3,64(a5)
     5ce:	67b8                	ld	a4,72(a5)
     5d0:	6bbc                	ld	a5,80(a5)
     5d2:	f8a43823          	sd	a0,-112(s0)
     5d6:	f8b43c23          	sd	a1,-104(s0)
     5da:	fac43023          	sd	a2,-96(s0)
     5de:	fad43423          	sd	a3,-88(s0)
     5e2:	fae43823          	sd	a4,-80(s0)
     5e6:	faf43c23          	sd	a5,-72(s0)
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
     5ea:	f9040913          	add	s2,s0,-112
     5ee:	fc040b13          	add	s6,s0,-64
    int fd = open("README", 0);
     5f2:	00005a17          	auipc	s4,0x5
     5f6:	efea0a13          	add	s4,s4,-258 # 54f0 <malloc+0x2f4>
    n = write(fds[1], "x", 1);
     5fa:	00005a97          	auipc	s5,0x5
     5fe:	d8ea8a93          	add	s5,s5,-626 # 5388 <malloc+0x18c>
    uint64 addr = addrs[ai];
     602:	00093983          	ld	s3,0(s2)
    int fd = open("README", 0);
     606:	4581                	li	a1,0
     608:	8552                	mv	a0,s4
     60a:	73c040ef          	jal	4d46 <open>
     60e:	84aa                	mv	s1,a0
    if(fd < 0){
     610:	06054763          	bltz	a0,67e <copyout+0xd4>
    int n = read(fd, (void*)addr, 8192);
     614:	6609                	lui	a2,0x2
     616:	85ce                	mv	a1,s3
     618:	706040ef          	jal	4d1e <read>
    if(n > 0){
     61c:	06a04a63          	bgtz	a0,690 <copyout+0xe6>
    close(fd);
     620:	8526                	mv	a0,s1
     622:	70c040ef          	jal	4d2e <close>
    if(pipe(fds) < 0){
     626:	f8840513          	add	a0,s0,-120
     62a:	6ec040ef          	jal	4d16 <pipe>
     62e:	06054c63          	bltz	a0,6a6 <copyout+0xfc>
    n = write(fds[1], "x", 1);
     632:	4605                	li	a2,1
     634:	85d6                	mv	a1,s5
     636:	f8c42503          	lw	a0,-116(s0)
     63a:	6ec040ef          	jal	4d26 <write>
    if(n != 1){
     63e:	4785                	li	a5,1
     640:	06f51c63          	bne	a0,a5,6b8 <copyout+0x10e>
    n = read(fds[0], (void*)addr, 8192);
     644:	6609                	lui	a2,0x2
     646:	85ce                	mv	a1,s3
     648:	f8842503          	lw	a0,-120(s0)
     64c:	6d2040ef          	jal	4d1e <read>
    if(n > 0){
     650:	06a04d63          	bgtz	a0,6ca <copyout+0x120>
    close(fds[0]);
     654:	f8842503          	lw	a0,-120(s0)
     658:	6d6040ef          	jal	4d2e <close>
    close(fds[1]);
     65c:	f8c42503          	lw	a0,-116(s0)
     660:	6ce040ef          	jal	4d2e <close>
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
     664:	0921                	add	s2,s2,8
     666:	f9691ee3          	bne	s2,s6,602 <copyout+0x58>
}
     66a:	70e6                	ld	ra,120(sp)
     66c:	7446                	ld	s0,112(sp)
     66e:	74a6                	ld	s1,104(sp)
     670:	7906                	ld	s2,96(sp)
     672:	69e6                	ld	s3,88(sp)
     674:	6a46                	ld	s4,80(sp)
     676:	6aa6                	ld	s5,72(sp)
     678:	6b06                	ld	s6,64(sp)
     67a:	6109                	add	sp,sp,128
     67c:	8082                	ret
      printf("open(README) failed\n");
     67e:	00005517          	auipc	a0,0x5
     682:	e7a50513          	add	a0,a0,-390 # 54f8 <malloc+0x2fc>
     686:	2c3040ef          	jal	5148 <printf>
      exit(1);
     68a:	4505                	li	a0,1
     68c:	67a040ef          	jal	4d06 <exit>
      printf("read(fd, %p, 8192) returned %d, not -1 or 0\n", (void*)addr, n);
     690:	862a                	mv	a2,a0
     692:	85ce                	mv	a1,s3
     694:	00005517          	auipc	a0,0x5
     698:	e7c50513          	add	a0,a0,-388 # 5510 <malloc+0x314>
     69c:	2ad040ef          	jal	5148 <printf>
      exit(1);
     6a0:	4505                	li	a0,1
     6a2:	664040ef          	jal	4d06 <exit>
      printf("pipe() failed\n");
     6a6:	00005517          	auipc	a0,0x5
     6aa:	e0a50513          	add	a0,a0,-502 # 54b0 <malloc+0x2b4>
     6ae:	29b040ef          	jal	5148 <printf>
      exit(1);
     6b2:	4505                	li	a0,1
     6b4:	652040ef          	jal	4d06 <exit>
      printf("pipe write failed\n");
     6b8:	00005517          	auipc	a0,0x5
     6bc:	e8850513          	add	a0,a0,-376 # 5540 <malloc+0x344>
     6c0:	289040ef          	jal	5148 <printf>
      exit(1);
     6c4:	4505                	li	a0,1
     6c6:	640040ef          	jal	4d06 <exit>
      printf("read(pipe, %p, 8192) returned %d, not -1 or 0\n", (void*)addr, n);
     6ca:	862a                	mv	a2,a0
     6cc:	85ce                	mv	a1,s3
     6ce:	00005517          	auipc	a0,0x5
     6d2:	e8a50513          	add	a0,a0,-374 # 5558 <malloc+0x35c>
     6d6:	273040ef          	jal	5148 <printf>
      exit(1);
     6da:	4505                	li	a0,1
     6dc:	62a040ef          	jal	4d06 <exit>

00000000000006e0 <truncate1>:
{
     6e0:	711d                	add	sp,sp,-96
     6e2:	ec86                	sd	ra,88(sp)
     6e4:	e8a2                	sd	s0,80(sp)
     6e6:	e4a6                	sd	s1,72(sp)
     6e8:	e0ca                	sd	s2,64(sp)
     6ea:	fc4e                	sd	s3,56(sp)
     6ec:	f852                	sd	s4,48(sp)
     6ee:	f456                	sd	s5,40(sp)
     6f0:	1080                	add	s0,sp,96
     6f2:	8aaa                	mv	s5,a0
  unlink("truncfile");
     6f4:	00005517          	auipc	a0,0x5
     6f8:	c7c50513          	add	a0,a0,-900 # 5370 <malloc+0x174>
     6fc:	65a040ef          	jal	4d56 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
     700:	60100593          	li	a1,1537
     704:	00005517          	auipc	a0,0x5
     708:	c6c50513          	add	a0,a0,-916 # 5370 <malloc+0x174>
     70c:	63a040ef          	jal	4d46 <open>
     710:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     712:	4611                	li	a2,4
     714:	00005597          	auipc	a1,0x5
     718:	c6c58593          	add	a1,a1,-916 # 5380 <malloc+0x184>
     71c:	60a040ef          	jal	4d26 <write>
  close(fd1);
     720:	8526                	mv	a0,s1
     722:	60c040ef          	jal	4d2e <close>
  int fd2 = open("truncfile", O_RDONLY);
     726:	4581                	li	a1,0
     728:	00005517          	auipc	a0,0x5
     72c:	c4850513          	add	a0,a0,-952 # 5370 <malloc+0x174>
     730:	616040ef          	jal	4d46 <open>
     734:	84aa                	mv	s1,a0
  int n = read(fd2, buf, sizeof(buf));
     736:	02000613          	li	a2,32
     73a:	fa040593          	add	a1,s0,-96
     73e:	5e0040ef          	jal	4d1e <read>
  if(n != 4){
     742:	4791                	li	a5,4
     744:	0af51863          	bne	a0,a5,7f4 <truncate1+0x114>
  fd1 = open("truncfile", O_WRONLY|O_TRUNC);
     748:	40100593          	li	a1,1025
     74c:	00005517          	auipc	a0,0x5
     750:	c2450513          	add	a0,a0,-988 # 5370 <malloc+0x174>
     754:	5f2040ef          	jal	4d46 <open>
     758:	89aa                	mv	s3,a0
  int fd3 = open("truncfile", O_RDONLY);
     75a:	4581                	li	a1,0
     75c:	00005517          	auipc	a0,0x5
     760:	c1450513          	add	a0,a0,-1004 # 5370 <malloc+0x174>
     764:	5e2040ef          	jal	4d46 <open>
     768:	892a                	mv	s2,a0
  n = read(fd3, buf, sizeof(buf));
     76a:	02000613          	li	a2,32
     76e:	fa040593          	add	a1,s0,-96
     772:	5ac040ef          	jal	4d1e <read>
     776:	8a2a                	mv	s4,a0
  if(n != 0){
     778:	e949                	bnez	a0,80a <truncate1+0x12a>
  n = read(fd2, buf, sizeof(buf));
     77a:	02000613          	li	a2,32
     77e:	fa040593          	add	a1,s0,-96
     782:	8526                	mv	a0,s1
     784:	59a040ef          	jal	4d1e <read>
     788:	8a2a                	mv	s4,a0
  if(n != 0){
     78a:	e155                	bnez	a0,82e <truncate1+0x14e>
  write(fd1, "abcdef", 6);
     78c:	4619                	li	a2,6
     78e:	00005597          	auipc	a1,0x5
     792:	e5a58593          	add	a1,a1,-422 # 55e8 <malloc+0x3ec>
     796:	854e                	mv	a0,s3
     798:	58e040ef          	jal	4d26 <write>
  n = read(fd3, buf, sizeof(buf));
     79c:	02000613          	li	a2,32
     7a0:	fa040593          	add	a1,s0,-96
     7a4:	854a                	mv	a0,s2
     7a6:	578040ef          	jal	4d1e <read>
  if(n != 6){
     7aa:	4799                	li	a5,6
     7ac:	0af51363          	bne	a0,a5,852 <truncate1+0x172>
  n = read(fd2, buf, sizeof(buf));
     7b0:	02000613          	li	a2,32
     7b4:	fa040593          	add	a1,s0,-96
     7b8:	8526                	mv	a0,s1
     7ba:	564040ef          	jal	4d1e <read>
  if(n != 2){
     7be:	4789                	li	a5,2
     7c0:	0af51463          	bne	a0,a5,868 <truncate1+0x188>
  unlink("truncfile");
     7c4:	00005517          	auipc	a0,0x5
     7c8:	bac50513          	add	a0,a0,-1108 # 5370 <malloc+0x174>
     7cc:	58a040ef          	jal	4d56 <unlink>
  close(fd1);
     7d0:	854e                	mv	a0,s3
     7d2:	55c040ef          	jal	4d2e <close>
  close(fd2);
     7d6:	8526                	mv	a0,s1
     7d8:	556040ef          	jal	4d2e <close>
  close(fd3);
     7dc:	854a                	mv	a0,s2
     7de:	550040ef          	jal	4d2e <close>
}
     7e2:	60e6                	ld	ra,88(sp)
     7e4:	6446                	ld	s0,80(sp)
     7e6:	64a6                	ld	s1,72(sp)
     7e8:	6906                	ld	s2,64(sp)
     7ea:	79e2                	ld	s3,56(sp)
     7ec:	7a42                	ld	s4,48(sp)
     7ee:	7aa2                	ld	s5,40(sp)
     7f0:	6125                	add	sp,sp,96
     7f2:	8082                	ret
    printf("%s: read %d bytes, wanted 4\n", s, n);
     7f4:	862a                	mv	a2,a0
     7f6:	85d6                	mv	a1,s5
     7f8:	00005517          	auipc	a0,0x5
     7fc:	d9050513          	add	a0,a0,-624 # 5588 <malloc+0x38c>
     800:	149040ef          	jal	5148 <printf>
    exit(1);
     804:	4505                	li	a0,1
     806:	500040ef          	jal	4d06 <exit>
    printf("aaa fd3=%d\n", fd3);
     80a:	85ca                	mv	a1,s2
     80c:	00005517          	auipc	a0,0x5
     810:	d9c50513          	add	a0,a0,-612 # 55a8 <malloc+0x3ac>
     814:	135040ef          	jal	5148 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     818:	8652                	mv	a2,s4
     81a:	85d6                	mv	a1,s5
     81c:	00005517          	auipc	a0,0x5
     820:	d9c50513          	add	a0,a0,-612 # 55b8 <malloc+0x3bc>
     824:	125040ef          	jal	5148 <printf>
    exit(1);
     828:	4505                	li	a0,1
     82a:	4dc040ef          	jal	4d06 <exit>
    printf("bbb fd2=%d\n", fd2);
     82e:	85a6                	mv	a1,s1
     830:	00005517          	auipc	a0,0x5
     834:	da850513          	add	a0,a0,-600 # 55d8 <malloc+0x3dc>
     838:	111040ef          	jal	5148 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     83c:	8652                	mv	a2,s4
     83e:	85d6                	mv	a1,s5
     840:	00005517          	auipc	a0,0x5
     844:	d7850513          	add	a0,a0,-648 # 55b8 <malloc+0x3bc>
     848:	101040ef          	jal	5148 <printf>
    exit(1);
     84c:	4505                	li	a0,1
     84e:	4b8040ef          	jal	4d06 <exit>
    printf("%s: read %d bytes, wanted 6\n", s, n);
     852:	862a                	mv	a2,a0
     854:	85d6                	mv	a1,s5
     856:	00005517          	auipc	a0,0x5
     85a:	d9a50513          	add	a0,a0,-614 # 55f0 <malloc+0x3f4>
     85e:	0eb040ef          	jal	5148 <printf>
    exit(1);
     862:	4505                	li	a0,1
     864:	4a2040ef          	jal	4d06 <exit>
    printf("%s: read %d bytes, wanted 2\n", s, n);
     868:	862a                	mv	a2,a0
     86a:	85d6                	mv	a1,s5
     86c:	00005517          	auipc	a0,0x5
     870:	da450513          	add	a0,a0,-604 # 5610 <malloc+0x414>
     874:	0d5040ef          	jal	5148 <printf>
    exit(1);
     878:	4505                	li	a0,1
     87a:	48c040ef          	jal	4d06 <exit>

000000000000087e <writetest>:
{
     87e:	7139                	add	sp,sp,-64
     880:	fc06                	sd	ra,56(sp)
     882:	f822                	sd	s0,48(sp)
     884:	f426                	sd	s1,40(sp)
     886:	f04a                	sd	s2,32(sp)
     888:	ec4e                	sd	s3,24(sp)
     88a:	e852                	sd	s4,16(sp)
     88c:	e456                	sd	s5,8(sp)
     88e:	e05a                	sd	s6,0(sp)
     890:	0080                	add	s0,sp,64
     892:	8b2a                	mv	s6,a0
  fd = open("small", O_CREATE|O_RDWR);
     894:	20200593          	li	a1,514
     898:	00005517          	auipc	a0,0x5
     89c:	d9850513          	add	a0,a0,-616 # 5630 <malloc+0x434>
     8a0:	4a6040ef          	jal	4d46 <open>
  if(fd < 0){
     8a4:	08054f63          	bltz	a0,942 <writetest+0xc4>
     8a8:	892a                	mv	s2,a0
     8aa:	4481                	li	s1,0
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     8ac:	00005997          	auipc	s3,0x5
     8b0:	dac98993          	add	s3,s3,-596 # 5658 <malloc+0x45c>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     8b4:	00005a97          	auipc	s5,0x5
     8b8:	ddca8a93          	add	s5,s5,-548 # 5690 <malloc+0x494>
  for(i = 0; i < N; i++){
     8bc:	06400a13          	li	s4,100
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     8c0:	4629                	li	a2,10
     8c2:	85ce                	mv	a1,s3
     8c4:	854a                	mv	a0,s2
     8c6:	460040ef          	jal	4d26 <write>
     8ca:	47a9                	li	a5,10
     8cc:	08f51563          	bne	a0,a5,956 <writetest+0xd8>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     8d0:	4629                	li	a2,10
     8d2:	85d6                	mv	a1,s5
     8d4:	854a                	mv	a0,s2
     8d6:	450040ef          	jal	4d26 <write>
     8da:	47a9                	li	a5,10
     8dc:	08f51863          	bne	a0,a5,96c <writetest+0xee>
  for(i = 0; i < N; i++){
     8e0:	2485                	addw	s1,s1,1
     8e2:	fd449fe3          	bne	s1,s4,8c0 <writetest+0x42>
  close(fd);
     8e6:	854a                	mv	a0,s2
     8e8:	446040ef          	jal	4d2e <close>
  fd = open("small", O_RDONLY);
     8ec:	4581                	li	a1,0
     8ee:	00005517          	auipc	a0,0x5
     8f2:	d4250513          	add	a0,a0,-702 # 5630 <malloc+0x434>
     8f6:	450040ef          	jal	4d46 <open>
     8fa:	84aa                	mv	s1,a0
  if(fd < 0){
     8fc:	08054363          	bltz	a0,982 <writetest+0x104>
  i = read(fd, buf, N*SZ*2);
     900:	7d000613          	li	a2,2000
     904:	0000b597          	auipc	a1,0xb
     908:	3b458593          	add	a1,a1,948 # bcb8 <buf>
     90c:	412040ef          	jal	4d1e <read>
  if(i != N*SZ*2){
     910:	7d000793          	li	a5,2000
     914:	08f51163          	bne	a0,a5,996 <writetest+0x118>
  close(fd);
     918:	8526                	mv	a0,s1
     91a:	414040ef          	jal	4d2e <close>
  if(unlink("small") < 0){
     91e:	00005517          	auipc	a0,0x5
     922:	d1250513          	add	a0,a0,-750 # 5630 <malloc+0x434>
     926:	430040ef          	jal	4d56 <unlink>
     92a:	08054063          	bltz	a0,9aa <writetest+0x12c>
}
     92e:	70e2                	ld	ra,56(sp)
     930:	7442                	ld	s0,48(sp)
     932:	74a2                	ld	s1,40(sp)
     934:	7902                	ld	s2,32(sp)
     936:	69e2                	ld	s3,24(sp)
     938:	6a42                	ld	s4,16(sp)
     93a:	6aa2                	ld	s5,8(sp)
     93c:	6b02                	ld	s6,0(sp)
     93e:	6121                	add	sp,sp,64
     940:	8082                	ret
    printf("%s: error: creat small failed!\n", s);
     942:	85da                	mv	a1,s6
     944:	00005517          	auipc	a0,0x5
     948:	cf450513          	add	a0,a0,-780 # 5638 <malloc+0x43c>
     94c:	7fc040ef          	jal	5148 <printf>
    exit(1);
     950:	4505                	li	a0,1
     952:	3b4040ef          	jal	4d06 <exit>
      printf("%s: error: write aa %d new file failed\n", s, i);
     956:	8626                	mv	a2,s1
     958:	85da                	mv	a1,s6
     95a:	00005517          	auipc	a0,0x5
     95e:	d0e50513          	add	a0,a0,-754 # 5668 <malloc+0x46c>
     962:	7e6040ef          	jal	5148 <printf>
      exit(1);
     966:	4505                	li	a0,1
     968:	39e040ef          	jal	4d06 <exit>
      printf("%s: error: write bb %d new file failed\n", s, i);
     96c:	8626                	mv	a2,s1
     96e:	85da                	mv	a1,s6
     970:	00005517          	auipc	a0,0x5
     974:	d3050513          	add	a0,a0,-720 # 56a0 <malloc+0x4a4>
     978:	7d0040ef          	jal	5148 <printf>
      exit(1);
     97c:	4505                	li	a0,1
     97e:	388040ef          	jal	4d06 <exit>
    printf("%s: error: open small failed!\n", s);
     982:	85da                	mv	a1,s6
     984:	00005517          	auipc	a0,0x5
     988:	d4450513          	add	a0,a0,-700 # 56c8 <malloc+0x4cc>
     98c:	7bc040ef          	jal	5148 <printf>
    exit(1);
     990:	4505                	li	a0,1
     992:	374040ef          	jal	4d06 <exit>
    printf("%s: read failed\n", s);
     996:	85da                	mv	a1,s6
     998:	00005517          	auipc	a0,0x5
     99c:	d5050513          	add	a0,a0,-688 # 56e8 <malloc+0x4ec>
     9a0:	7a8040ef          	jal	5148 <printf>
    exit(1);
     9a4:	4505                	li	a0,1
     9a6:	360040ef          	jal	4d06 <exit>
    printf("%s: unlink small failed\n", s);
     9aa:	85da                	mv	a1,s6
     9ac:	00005517          	auipc	a0,0x5
     9b0:	d5450513          	add	a0,a0,-684 # 5700 <malloc+0x504>
     9b4:	794040ef          	jal	5148 <printf>
    exit(1);
     9b8:	4505                	li	a0,1
     9ba:	34c040ef          	jal	4d06 <exit>

00000000000009be <writebig>:
{
     9be:	7139                	add	sp,sp,-64
     9c0:	fc06                	sd	ra,56(sp)
     9c2:	f822                	sd	s0,48(sp)
     9c4:	f426                	sd	s1,40(sp)
     9c6:	f04a                	sd	s2,32(sp)
     9c8:	ec4e                	sd	s3,24(sp)
     9ca:	e852                	sd	s4,16(sp)
     9cc:	e456                	sd	s5,8(sp)
     9ce:	0080                	add	s0,sp,64
     9d0:	8aaa                	mv	s5,a0
  fd = open("big", O_CREATE|O_RDWR);
     9d2:	20200593          	li	a1,514
     9d6:	00005517          	auipc	a0,0x5
     9da:	d4a50513          	add	a0,a0,-694 # 5720 <malloc+0x524>
     9de:	368040ef          	jal	4d46 <open>
     9e2:	89aa                	mv	s3,a0
  for(i = 0; i < MAXFILE; i++){
     9e4:	4481                	li	s1,0
    ((int*)buf)[0] = i;
     9e6:	0000b917          	auipc	s2,0xb
     9ea:	2d290913          	add	s2,s2,722 # bcb8 <buf>
  for(i = 0; i < MAXFILE; i++){
     9ee:	10c00a13          	li	s4,268
  if(fd < 0){
     9f2:	06054463          	bltz	a0,a5a <writebig+0x9c>
    ((int*)buf)[0] = i;
     9f6:	00992023          	sw	s1,0(s2)
    if(write(fd, buf, BSIZE) != BSIZE){
     9fa:	40000613          	li	a2,1024
     9fe:	85ca                	mv	a1,s2
     a00:	854e                	mv	a0,s3
     a02:	324040ef          	jal	4d26 <write>
     a06:	40000793          	li	a5,1024
     a0a:	06f51263          	bne	a0,a5,a6e <writebig+0xb0>
  for(i = 0; i < MAXFILE; i++){
     a0e:	2485                	addw	s1,s1,1
     a10:	ff4493e3          	bne	s1,s4,9f6 <writebig+0x38>
  close(fd);
     a14:	854e                	mv	a0,s3
     a16:	318040ef          	jal	4d2e <close>
  fd = open("big", O_RDONLY);
     a1a:	4581                	li	a1,0
     a1c:	00005517          	auipc	a0,0x5
     a20:	d0450513          	add	a0,a0,-764 # 5720 <malloc+0x524>
     a24:	322040ef          	jal	4d46 <open>
     a28:	89aa                	mv	s3,a0
  n = 0;
     a2a:	4481                	li	s1,0
    i = read(fd, buf, BSIZE);
     a2c:	0000b917          	auipc	s2,0xb
     a30:	28c90913          	add	s2,s2,652 # bcb8 <buf>
  if(fd < 0){
     a34:	04054863          	bltz	a0,a84 <writebig+0xc6>
    i = read(fd, buf, BSIZE);
     a38:	40000613          	li	a2,1024
     a3c:	85ca                	mv	a1,s2
     a3e:	854e                	mv	a0,s3
     a40:	2de040ef          	jal	4d1e <read>
    if(i == 0){
     a44:	c931                	beqz	a0,a98 <writebig+0xda>
    } else if(i != BSIZE){
     a46:	40000793          	li	a5,1024
     a4a:	08f51a63          	bne	a0,a5,ade <writebig+0x120>
    if(((int*)buf)[0] != n){
     a4e:	00092683          	lw	a3,0(s2)
     a52:	0a969163          	bne	a3,s1,af4 <writebig+0x136>
    n++;
     a56:	2485                	addw	s1,s1,1
    i = read(fd, buf, BSIZE);
     a58:	b7c5                	j	a38 <writebig+0x7a>
    printf("%s: error: creat big failed!\n", s);
     a5a:	85d6                	mv	a1,s5
     a5c:	00005517          	auipc	a0,0x5
     a60:	ccc50513          	add	a0,a0,-820 # 5728 <malloc+0x52c>
     a64:	6e4040ef          	jal	5148 <printf>
    exit(1);
     a68:	4505                	li	a0,1
     a6a:	29c040ef          	jal	4d06 <exit>
      printf("%s: error: write big file failed i=%d\n", s, i);
     a6e:	8626                	mv	a2,s1
     a70:	85d6                	mv	a1,s5
     a72:	00005517          	auipc	a0,0x5
     a76:	cd650513          	add	a0,a0,-810 # 5748 <malloc+0x54c>
     a7a:	6ce040ef          	jal	5148 <printf>
      exit(1);
     a7e:	4505                	li	a0,1
     a80:	286040ef          	jal	4d06 <exit>
    printf("%s: error: open big failed!\n", s);
     a84:	85d6                	mv	a1,s5
     a86:	00005517          	auipc	a0,0x5
     a8a:	cea50513          	add	a0,a0,-790 # 5770 <malloc+0x574>
     a8e:	6ba040ef          	jal	5148 <printf>
    exit(1);
     a92:	4505                	li	a0,1
     a94:	272040ef          	jal	4d06 <exit>
      if(n != MAXFILE){
     a98:	10c00793          	li	a5,268
     a9c:	02f49663          	bne	s1,a5,ac8 <writebig+0x10a>
  close(fd);
     aa0:	854e                	mv	a0,s3
     aa2:	28c040ef          	jal	4d2e <close>
  if(unlink("big") < 0){
     aa6:	00005517          	auipc	a0,0x5
     aaa:	c7a50513          	add	a0,a0,-902 # 5720 <malloc+0x524>
     aae:	2a8040ef          	jal	4d56 <unlink>
     ab2:	04054c63          	bltz	a0,b0a <writebig+0x14c>
}
     ab6:	70e2                	ld	ra,56(sp)
     ab8:	7442                	ld	s0,48(sp)
     aba:	74a2                	ld	s1,40(sp)
     abc:	7902                	ld	s2,32(sp)
     abe:	69e2                	ld	s3,24(sp)
     ac0:	6a42                	ld	s4,16(sp)
     ac2:	6aa2                	ld	s5,8(sp)
     ac4:	6121                	add	sp,sp,64
     ac6:	8082                	ret
        printf("%s: read only %d blocks from big", s, n);
     ac8:	8626                	mv	a2,s1
     aca:	85d6                	mv	a1,s5
     acc:	00005517          	auipc	a0,0x5
     ad0:	cc450513          	add	a0,a0,-828 # 5790 <malloc+0x594>
     ad4:	674040ef          	jal	5148 <printf>
        exit(1);
     ad8:	4505                	li	a0,1
     ada:	22c040ef          	jal	4d06 <exit>
      printf("%s: read failed %d\n", s, i);
     ade:	862a                	mv	a2,a0
     ae0:	85d6                	mv	a1,s5
     ae2:	00005517          	auipc	a0,0x5
     ae6:	cd650513          	add	a0,a0,-810 # 57b8 <malloc+0x5bc>
     aea:	65e040ef          	jal	5148 <printf>
      exit(1);
     aee:	4505                	li	a0,1
     af0:	216040ef          	jal	4d06 <exit>
      printf("%s: read content of block %d is %d\n", s,
     af4:	8626                	mv	a2,s1
     af6:	85d6                	mv	a1,s5
     af8:	00005517          	auipc	a0,0x5
     afc:	cd850513          	add	a0,a0,-808 # 57d0 <malloc+0x5d4>
     b00:	648040ef          	jal	5148 <printf>
      exit(1);
     b04:	4505                	li	a0,1
     b06:	200040ef          	jal	4d06 <exit>
    printf("%s: unlink big failed\n", s);
     b0a:	85d6                	mv	a1,s5
     b0c:	00005517          	auipc	a0,0x5
     b10:	cec50513          	add	a0,a0,-788 # 57f8 <malloc+0x5fc>
     b14:	634040ef          	jal	5148 <printf>
    exit(1);
     b18:	4505                	li	a0,1
     b1a:	1ec040ef          	jal	4d06 <exit>

0000000000000b1e <unlinkread>:
{
     b1e:	7179                	add	sp,sp,-48
     b20:	f406                	sd	ra,40(sp)
     b22:	f022                	sd	s0,32(sp)
     b24:	ec26                	sd	s1,24(sp)
     b26:	e84a                	sd	s2,16(sp)
     b28:	e44e                	sd	s3,8(sp)
     b2a:	1800                	add	s0,sp,48
     b2c:	89aa                	mv	s3,a0
  fd = open("unlinkread", O_CREATE | O_RDWR);
     b2e:	20200593          	li	a1,514
     b32:	00005517          	auipc	a0,0x5
     b36:	cde50513          	add	a0,a0,-802 # 5810 <malloc+0x614>
     b3a:	20c040ef          	jal	4d46 <open>
  if(fd < 0){
     b3e:	0a054f63          	bltz	a0,bfc <unlinkread+0xde>
     b42:	84aa                	mv	s1,a0
  write(fd, "hello", SZ);
     b44:	4615                	li	a2,5
     b46:	00005597          	auipc	a1,0x5
     b4a:	cfa58593          	add	a1,a1,-774 # 5840 <malloc+0x644>
     b4e:	1d8040ef          	jal	4d26 <write>
  close(fd);
     b52:	8526                	mv	a0,s1
     b54:	1da040ef          	jal	4d2e <close>
  fd = open("unlinkread", O_RDWR);
     b58:	4589                	li	a1,2
     b5a:	00005517          	auipc	a0,0x5
     b5e:	cb650513          	add	a0,a0,-842 # 5810 <malloc+0x614>
     b62:	1e4040ef          	jal	4d46 <open>
     b66:	84aa                	mv	s1,a0
  if(fd < 0){
     b68:	0a054463          	bltz	a0,c10 <unlinkread+0xf2>
  if(unlink("unlinkread") != 0){
     b6c:	00005517          	auipc	a0,0x5
     b70:	ca450513          	add	a0,a0,-860 # 5810 <malloc+0x614>
     b74:	1e2040ef          	jal	4d56 <unlink>
     b78:	e555                	bnez	a0,c24 <unlinkread+0x106>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
     b7a:	20200593          	li	a1,514
     b7e:	00005517          	auipc	a0,0x5
     b82:	c9250513          	add	a0,a0,-878 # 5810 <malloc+0x614>
     b86:	1c0040ef          	jal	4d46 <open>
     b8a:	892a                	mv	s2,a0
  write(fd1, "yyy", 3);
     b8c:	460d                	li	a2,3
     b8e:	00005597          	auipc	a1,0x5
     b92:	cfa58593          	add	a1,a1,-774 # 5888 <malloc+0x68c>
     b96:	190040ef          	jal	4d26 <write>
  close(fd1);
     b9a:	854a                	mv	a0,s2
     b9c:	192040ef          	jal	4d2e <close>
  if(read(fd, buf, sizeof(buf)) != SZ){
     ba0:	660d                	lui	a2,0x3
     ba2:	0000b597          	auipc	a1,0xb
     ba6:	11658593          	add	a1,a1,278 # bcb8 <buf>
     baa:	8526                	mv	a0,s1
     bac:	172040ef          	jal	4d1e <read>
     bb0:	4795                	li	a5,5
     bb2:	08f51363          	bne	a0,a5,c38 <unlinkread+0x11a>
  if(buf[0] != 'h'){
     bb6:	0000b717          	auipc	a4,0xb
     bba:	10274703          	lbu	a4,258(a4) # bcb8 <buf>
     bbe:	06800793          	li	a5,104
     bc2:	08f71563          	bne	a4,a5,c4c <unlinkread+0x12e>
  if(write(fd, buf, 10) != 10){
     bc6:	4629                	li	a2,10
     bc8:	0000b597          	auipc	a1,0xb
     bcc:	0f058593          	add	a1,a1,240 # bcb8 <buf>
     bd0:	8526                	mv	a0,s1
     bd2:	154040ef          	jal	4d26 <write>
     bd6:	47a9                	li	a5,10
     bd8:	08f51463          	bne	a0,a5,c60 <unlinkread+0x142>
  close(fd);
     bdc:	8526                	mv	a0,s1
     bde:	150040ef          	jal	4d2e <close>
  unlink("unlinkread");
     be2:	00005517          	auipc	a0,0x5
     be6:	c2e50513          	add	a0,a0,-978 # 5810 <malloc+0x614>
     bea:	16c040ef          	jal	4d56 <unlink>
}
     bee:	70a2                	ld	ra,40(sp)
     bf0:	7402                	ld	s0,32(sp)
     bf2:	64e2                	ld	s1,24(sp)
     bf4:	6942                	ld	s2,16(sp)
     bf6:	69a2                	ld	s3,8(sp)
     bf8:	6145                	add	sp,sp,48
     bfa:	8082                	ret
    printf("%s: create unlinkread failed\n", s);
     bfc:	85ce                	mv	a1,s3
     bfe:	00005517          	auipc	a0,0x5
     c02:	c2250513          	add	a0,a0,-990 # 5820 <malloc+0x624>
     c06:	542040ef          	jal	5148 <printf>
    exit(1);
     c0a:	4505                	li	a0,1
     c0c:	0fa040ef          	jal	4d06 <exit>
    printf("%s: open unlinkread failed\n", s);
     c10:	85ce                	mv	a1,s3
     c12:	00005517          	auipc	a0,0x5
     c16:	c3650513          	add	a0,a0,-970 # 5848 <malloc+0x64c>
     c1a:	52e040ef          	jal	5148 <printf>
    exit(1);
     c1e:	4505                	li	a0,1
     c20:	0e6040ef          	jal	4d06 <exit>
    printf("%s: unlink unlinkread failed\n", s);
     c24:	85ce                	mv	a1,s3
     c26:	00005517          	auipc	a0,0x5
     c2a:	c4250513          	add	a0,a0,-958 # 5868 <malloc+0x66c>
     c2e:	51a040ef          	jal	5148 <printf>
    exit(1);
     c32:	4505                	li	a0,1
     c34:	0d2040ef          	jal	4d06 <exit>
    printf("%s: unlinkread read failed", s);
     c38:	85ce                	mv	a1,s3
     c3a:	00005517          	auipc	a0,0x5
     c3e:	c5650513          	add	a0,a0,-938 # 5890 <malloc+0x694>
     c42:	506040ef          	jal	5148 <printf>
    exit(1);
     c46:	4505                	li	a0,1
     c48:	0be040ef          	jal	4d06 <exit>
    printf("%s: unlinkread wrong data\n", s);
     c4c:	85ce                	mv	a1,s3
     c4e:	00005517          	auipc	a0,0x5
     c52:	c6250513          	add	a0,a0,-926 # 58b0 <malloc+0x6b4>
     c56:	4f2040ef          	jal	5148 <printf>
    exit(1);
     c5a:	4505                	li	a0,1
     c5c:	0aa040ef          	jal	4d06 <exit>
    printf("%s: unlinkread write failed\n", s);
     c60:	85ce                	mv	a1,s3
     c62:	00005517          	auipc	a0,0x5
     c66:	c6e50513          	add	a0,a0,-914 # 58d0 <malloc+0x6d4>
     c6a:	4de040ef          	jal	5148 <printf>
    exit(1);
     c6e:	4505                	li	a0,1
     c70:	096040ef          	jal	4d06 <exit>

0000000000000c74 <linktest>:
{
     c74:	1101                	add	sp,sp,-32
     c76:	ec06                	sd	ra,24(sp)
     c78:	e822                	sd	s0,16(sp)
     c7a:	e426                	sd	s1,8(sp)
     c7c:	e04a                	sd	s2,0(sp)
     c7e:	1000                	add	s0,sp,32
     c80:	892a                	mv	s2,a0
  unlink("lf1");
     c82:	00005517          	auipc	a0,0x5
     c86:	c6e50513          	add	a0,a0,-914 # 58f0 <malloc+0x6f4>
     c8a:	0cc040ef          	jal	4d56 <unlink>
  unlink("lf2");
     c8e:	00005517          	auipc	a0,0x5
     c92:	c6a50513          	add	a0,a0,-918 # 58f8 <malloc+0x6fc>
     c96:	0c0040ef          	jal	4d56 <unlink>
  fd = open("lf1", O_CREATE|O_RDWR);
     c9a:	20200593          	li	a1,514
     c9e:	00005517          	auipc	a0,0x5
     ca2:	c5250513          	add	a0,a0,-942 # 58f0 <malloc+0x6f4>
     ca6:	0a0040ef          	jal	4d46 <open>
  if(fd < 0){
     caa:	0c054f63          	bltz	a0,d88 <linktest+0x114>
     cae:	84aa                	mv	s1,a0
  if(write(fd, "hello", SZ) != SZ){
     cb0:	4615                	li	a2,5
     cb2:	00005597          	auipc	a1,0x5
     cb6:	b8e58593          	add	a1,a1,-1138 # 5840 <malloc+0x644>
     cba:	06c040ef          	jal	4d26 <write>
     cbe:	4795                	li	a5,5
     cc0:	0cf51e63          	bne	a0,a5,d9c <linktest+0x128>
  close(fd);
     cc4:	8526                	mv	a0,s1
     cc6:	068040ef          	jal	4d2e <close>
  if(link("lf1", "lf2") < 0){
     cca:	00005597          	auipc	a1,0x5
     cce:	c2e58593          	add	a1,a1,-978 # 58f8 <malloc+0x6fc>
     cd2:	00005517          	auipc	a0,0x5
     cd6:	c1e50513          	add	a0,a0,-994 # 58f0 <malloc+0x6f4>
     cda:	08c040ef          	jal	4d66 <link>
     cde:	0c054963          	bltz	a0,db0 <linktest+0x13c>
  unlink("lf1");
     ce2:	00005517          	auipc	a0,0x5
     ce6:	c0e50513          	add	a0,a0,-1010 # 58f0 <malloc+0x6f4>
     cea:	06c040ef          	jal	4d56 <unlink>
  if(open("lf1", 0) >= 0){
     cee:	4581                	li	a1,0
     cf0:	00005517          	auipc	a0,0x5
     cf4:	c0050513          	add	a0,a0,-1024 # 58f0 <malloc+0x6f4>
     cf8:	04e040ef          	jal	4d46 <open>
     cfc:	0c055463          	bgez	a0,dc4 <linktest+0x150>
  fd = open("lf2", 0);
     d00:	4581                	li	a1,0
     d02:	00005517          	auipc	a0,0x5
     d06:	bf650513          	add	a0,a0,-1034 # 58f8 <malloc+0x6fc>
     d0a:	03c040ef          	jal	4d46 <open>
     d0e:	84aa                	mv	s1,a0
  if(fd < 0){
     d10:	0c054463          	bltz	a0,dd8 <linktest+0x164>
  if(read(fd, buf, sizeof(buf)) != SZ){
     d14:	660d                	lui	a2,0x3
     d16:	0000b597          	auipc	a1,0xb
     d1a:	fa258593          	add	a1,a1,-94 # bcb8 <buf>
     d1e:	000040ef          	jal	4d1e <read>
     d22:	4795                	li	a5,5
     d24:	0cf51463          	bne	a0,a5,dec <linktest+0x178>
  close(fd);
     d28:	8526                	mv	a0,s1
     d2a:	004040ef          	jal	4d2e <close>
  if(link("lf2", "lf2") >= 0){
     d2e:	00005597          	auipc	a1,0x5
     d32:	bca58593          	add	a1,a1,-1078 # 58f8 <malloc+0x6fc>
     d36:	852e                	mv	a0,a1
     d38:	02e040ef          	jal	4d66 <link>
     d3c:	0c055263          	bgez	a0,e00 <linktest+0x18c>
  unlink("lf2");
     d40:	00005517          	auipc	a0,0x5
     d44:	bb850513          	add	a0,a0,-1096 # 58f8 <malloc+0x6fc>
     d48:	00e040ef          	jal	4d56 <unlink>
  if(link("lf2", "lf1") >= 0){
     d4c:	00005597          	auipc	a1,0x5
     d50:	ba458593          	add	a1,a1,-1116 # 58f0 <malloc+0x6f4>
     d54:	00005517          	auipc	a0,0x5
     d58:	ba450513          	add	a0,a0,-1116 # 58f8 <malloc+0x6fc>
     d5c:	00a040ef          	jal	4d66 <link>
     d60:	0a055a63          	bgez	a0,e14 <linktest+0x1a0>
  if(link(".", "lf1") >= 0){
     d64:	00005597          	auipc	a1,0x5
     d68:	b8c58593          	add	a1,a1,-1140 # 58f0 <malloc+0x6f4>
     d6c:	00005517          	auipc	a0,0x5
     d70:	c9450513          	add	a0,a0,-876 # 5a00 <malloc+0x804>
     d74:	7f3030ef          	jal	4d66 <link>
     d78:	0a055863          	bgez	a0,e28 <linktest+0x1b4>
}
     d7c:	60e2                	ld	ra,24(sp)
     d7e:	6442                	ld	s0,16(sp)
     d80:	64a2                	ld	s1,8(sp)
     d82:	6902                	ld	s2,0(sp)
     d84:	6105                	add	sp,sp,32
     d86:	8082                	ret
    printf("%s: create lf1 failed\n", s);
     d88:	85ca                	mv	a1,s2
     d8a:	00005517          	auipc	a0,0x5
     d8e:	b7650513          	add	a0,a0,-1162 # 5900 <malloc+0x704>
     d92:	3b6040ef          	jal	5148 <printf>
    exit(1);
     d96:	4505                	li	a0,1
     d98:	76f030ef          	jal	4d06 <exit>
    printf("%s: write lf1 failed\n", s);
     d9c:	85ca                	mv	a1,s2
     d9e:	00005517          	auipc	a0,0x5
     da2:	b7a50513          	add	a0,a0,-1158 # 5918 <malloc+0x71c>
     da6:	3a2040ef          	jal	5148 <printf>
    exit(1);
     daa:	4505                	li	a0,1
     dac:	75b030ef          	jal	4d06 <exit>
    printf("%s: link lf1 lf2 failed\n", s);
     db0:	85ca                	mv	a1,s2
     db2:	00005517          	auipc	a0,0x5
     db6:	b7e50513          	add	a0,a0,-1154 # 5930 <malloc+0x734>
     dba:	38e040ef          	jal	5148 <printf>
    exit(1);
     dbe:	4505                	li	a0,1
     dc0:	747030ef          	jal	4d06 <exit>
    printf("%s: unlinked lf1 but it is still there!\n", s);
     dc4:	85ca                	mv	a1,s2
     dc6:	00005517          	auipc	a0,0x5
     dca:	b8a50513          	add	a0,a0,-1142 # 5950 <malloc+0x754>
     dce:	37a040ef          	jal	5148 <printf>
    exit(1);
     dd2:	4505                	li	a0,1
     dd4:	733030ef          	jal	4d06 <exit>
    printf("%s: open lf2 failed\n", s);
     dd8:	85ca                	mv	a1,s2
     dda:	00005517          	auipc	a0,0x5
     dde:	ba650513          	add	a0,a0,-1114 # 5980 <malloc+0x784>
     de2:	366040ef          	jal	5148 <printf>
    exit(1);
     de6:	4505                	li	a0,1
     de8:	71f030ef          	jal	4d06 <exit>
    printf("%s: read lf2 failed\n", s);
     dec:	85ca                	mv	a1,s2
     dee:	00005517          	auipc	a0,0x5
     df2:	baa50513          	add	a0,a0,-1110 # 5998 <malloc+0x79c>
     df6:	352040ef          	jal	5148 <printf>
    exit(1);
     dfa:	4505                	li	a0,1
     dfc:	70b030ef          	jal	4d06 <exit>
    printf("%s: link lf2 lf2 succeeded! oops\n", s);
     e00:	85ca                	mv	a1,s2
     e02:	00005517          	auipc	a0,0x5
     e06:	bae50513          	add	a0,a0,-1106 # 59b0 <malloc+0x7b4>
     e0a:	33e040ef          	jal	5148 <printf>
    exit(1);
     e0e:	4505                	li	a0,1
     e10:	6f7030ef          	jal	4d06 <exit>
    printf("%s: link non-existent succeeded! oops\n", s);
     e14:	85ca                	mv	a1,s2
     e16:	00005517          	auipc	a0,0x5
     e1a:	bc250513          	add	a0,a0,-1086 # 59d8 <malloc+0x7dc>
     e1e:	32a040ef          	jal	5148 <printf>
    exit(1);
     e22:	4505                	li	a0,1
     e24:	6e3030ef          	jal	4d06 <exit>
    printf("%s: link . lf1 succeeded! oops\n", s);
     e28:	85ca                	mv	a1,s2
     e2a:	00005517          	auipc	a0,0x5
     e2e:	bde50513          	add	a0,a0,-1058 # 5a08 <malloc+0x80c>
     e32:	316040ef          	jal	5148 <printf>
    exit(1);
     e36:	4505                	li	a0,1
     e38:	6cf030ef          	jal	4d06 <exit>

0000000000000e3c <validatetest>:
{
     e3c:	7139                	add	sp,sp,-64
     e3e:	fc06                	sd	ra,56(sp)
     e40:	f822                	sd	s0,48(sp)
     e42:	f426                	sd	s1,40(sp)
     e44:	f04a                	sd	s2,32(sp)
     e46:	ec4e                	sd	s3,24(sp)
     e48:	e852                	sd	s4,16(sp)
     e4a:	e456                	sd	s5,8(sp)
     e4c:	e05a                	sd	s6,0(sp)
     e4e:	0080                	add	s0,sp,64
     e50:	8b2a                	mv	s6,a0
  for(p = 0; p <= (uint)hi; p += PGSIZE){
     e52:	4481                	li	s1,0
    if(link("nosuchfile", (char*)p) != -1){
     e54:	00005997          	auipc	s3,0x5
     e58:	bd498993          	add	s3,s3,-1068 # 5a28 <malloc+0x82c>
     e5c:	597d                	li	s2,-1
  for(p = 0; p <= (uint)hi; p += PGSIZE){
     e5e:	6a85                	lui	s5,0x1
     e60:	00114a37          	lui	s4,0x114
    if(link("nosuchfile", (char*)p) != -1){
     e64:	85a6                	mv	a1,s1
     e66:	854e                	mv	a0,s3
     e68:	6ff030ef          	jal	4d66 <link>
     e6c:	01251f63          	bne	a0,s2,e8a <validatetest+0x4e>
  for(p = 0; p <= (uint)hi; p += PGSIZE){
     e70:	94d6                	add	s1,s1,s5
     e72:	ff4499e3          	bne	s1,s4,e64 <validatetest+0x28>
}
     e76:	70e2                	ld	ra,56(sp)
     e78:	7442                	ld	s0,48(sp)
     e7a:	74a2                	ld	s1,40(sp)
     e7c:	7902                	ld	s2,32(sp)
     e7e:	69e2                	ld	s3,24(sp)
     e80:	6a42                	ld	s4,16(sp)
     e82:	6aa2                	ld	s5,8(sp)
     e84:	6b02                	ld	s6,0(sp)
     e86:	6121                	add	sp,sp,64
     e88:	8082                	ret
      printf("%s: link should not succeed\n", s);
     e8a:	85da                	mv	a1,s6
     e8c:	00005517          	auipc	a0,0x5
     e90:	bac50513          	add	a0,a0,-1108 # 5a38 <malloc+0x83c>
     e94:	2b4040ef          	jal	5148 <printf>
      exit(1);
     e98:	4505                	li	a0,1
     e9a:	66d030ef          	jal	4d06 <exit>

0000000000000e9e <bigdir>:
{
     e9e:	715d                	add	sp,sp,-80
     ea0:	e486                	sd	ra,72(sp)
     ea2:	e0a2                	sd	s0,64(sp)
     ea4:	fc26                	sd	s1,56(sp)
     ea6:	f84a                	sd	s2,48(sp)
     ea8:	f44e                	sd	s3,40(sp)
     eaa:	f052                	sd	s4,32(sp)
     eac:	ec56                	sd	s5,24(sp)
     eae:	e85a                	sd	s6,16(sp)
     eb0:	0880                	add	s0,sp,80
     eb2:	89aa                	mv	s3,a0
  unlink("bd");
     eb4:	00005517          	auipc	a0,0x5
     eb8:	ba450513          	add	a0,a0,-1116 # 5a58 <malloc+0x85c>
     ebc:	69b030ef          	jal	4d56 <unlink>
  fd = open("bd", O_CREATE);
     ec0:	20000593          	li	a1,512
     ec4:	00005517          	auipc	a0,0x5
     ec8:	b9450513          	add	a0,a0,-1132 # 5a58 <malloc+0x85c>
     ecc:	67b030ef          	jal	4d46 <open>
  if(fd < 0){
     ed0:	0c054163          	bltz	a0,f92 <bigdir+0xf4>
  close(fd);
     ed4:	65b030ef          	jal	4d2e <close>
  for(i = 0; i < N; i++){
     ed8:	4901                	li	s2,0
    name[0] = 'x';
     eda:	07800a93          	li	s5,120
    if(link("bd", name) != 0){
     ede:	00005a17          	auipc	s4,0x5
     ee2:	b7aa0a13          	add	s4,s4,-1158 # 5a58 <malloc+0x85c>
  for(i = 0; i < N; i++){
     ee6:	1f400b13          	li	s6,500
    name[0] = 'x';
     eea:	fb540823          	sb	s5,-80(s0)
    name[1] = '0' + (i / 64);
     eee:	41f9571b          	sraw	a4,s2,0x1f
     ef2:	01a7571b          	srlw	a4,a4,0x1a
     ef6:	012707bb          	addw	a5,a4,s2
     efa:	4067d69b          	sraw	a3,a5,0x6
     efe:	0306869b          	addw	a3,a3,48
     f02:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
     f06:	03f7f793          	and	a5,a5,63
     f0a:	9f99                	subw	a5,a5,a4
     f0c:	0307879b          	addw	a5,a5,48
     f10:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
     f14:	fa0409a3          	sb	zero,-77(s0)
    if(link("bd", name) != 0){
     f18:	fb040593          	add	a1,s0,-80
     f1c:	8552                	mv	a0,s4
     f1e:	649030ef          	jal	4d66 <link>
     f22:	84aa                	mv	s1,a0
     f24:	e149                	bnez	a0,fa6 <bigdir+0x108>
  for(i = 0; i < N; i++){
     f26:	2905                	addw	s2,s2,1
     f28:	fd6911e3          	bne	s2,s6,eea <bigdir+0x4c>
  unlink("bd");
     f2c:	00005517          	auipc	a0,0x5
     f30:	b2c50513          	add	a0,a0,-1236 # 5a58 <malloc+0x85c>
     f34:	623030ef          	jal	4d56 <unlink>
    name[0] = 'x';
     f38:	07800913          	li	s2,120
  for(i = 0; i < N; i++){
     f3c:	1f400a13          	li	s4,500
    name[0] = 'x';
     f40:	fb240823          	sb	s2,-80(s0)
    name[1] = '0' + (i / 64);
     f44:	41f4d71b          	sraw	a4,s1,0x1f
     f48:	01a7571b          	srlw	a4,a4,0x1a
     f4c:	009707bb          	addw	a5,a4,s1
     f50:	4067d69b          	sraw	a3,a5,0x6
     f54:	0306869b          	addw	a3,a3,48
     f58:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
     f5c:	03f7f793          	and	a5,a5,63
     f60:	9f99                	subw	a5,a5,a4
     f62:	0307879b          	addw	a5,a5,48
     f66:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
     f6a:	fa0409a3          	sb	zero,-77(s0)
    if(unlink(name) != 0){
     f6e:	fb040513          	add	a0,s0,-80
     f72:	5e5030ef          	jal	4d56 <unlink>
     f76:	e529                	bnez	a0,fc0 <bigdir+0x122>
  for(i = 0; i < N; i++){
     f78:	2485                	addw	s1,s1,1
     f7a:	fd4493e3          	bne	s1,s4,f40 <bigdir+0xa2>
}
     f7e:	60a6                	ld	ra,72(sp)
     f80:	6406                	ld	s0,64(sp)
     f82:	74e2                	ld	s1,56(sp)
     f84:	7942                	ld	s2,48(sp)
     f86:	79a2                	ld	s3,40(sp)
     f88:	7a02                	ld	s4,32(sp)
     f8a:	6ae2                	ld	s5,24(sp)
     f8c:	6b42                	ld	s6,16(sp)
     f8e:	6161                	add	sp,sp,80
     f90:	8082                	ret
    printf("%s: bigdir create failed\n", s);
     f92:	85ce                	mv	a1,s3
     f94:	00005517          	auipc	a0,0x5
     f98:	acc50513          	add	a0,a0,-1332 # 5a60 <malloc+0x864>
     f9c:	1ac040ef          	jal	5148 <printf>
    exit(1);
     fa0:	4505                	li	a0,1
     fa2:	565030ef          	jal	4d06 <exit>
      printf("%s: bigdir i=%d link(bd, %s) failed\n", s, i, name);
     fa6:	fb040693          	add	a3,s0,-80
     faa:	864a                	mv	a2,s2
     fac:	85ce                	mv	a1,s3
     fae:	00005517          	auipc	a0,0x5
     fb2:	ad250513          	add	a0,a0,-1326 # 5a80 <malloc+0x884>
     fb6:	192040ef          	jal	5148 <printf>
      exit(1);
     fba:	4505                	li	a0,1
     fbc:	54b030ef          	jal	4d06 <exit>
      printf("%s: bigdir unlink failed", s);
     fc0:	85ce                	mv	a1,s3
     fc2:	00005517          	auipc	a0,0x5
     fc6:	ae650513          	add	a0,a0,-1306 # 5aa8 <malloc+0x8ac>
     fca:	17e040ef          	jal	5148 <printf>
      exit(1);
     fce:	4505                	li	a0,1
     fd0:	537030ef          	jal	4d06 <exit>

0000000000000fd4 <pgbug>:
{
     fd4:	7179                	add	sp,sp,-48
     fd6:	f406                	sd	ra,40(sp)
     fd8:	f022                	sd	s0,32(sp)
     fda:	ec26                	sd	s1,24(sp)
     fdc:	1800                	add	s0,sp,48
  argv[0] = 0;
     fde:	fc043c23          	sd	zero,-40(s0)
  exec(big, argv);
     fe2:	00007497          	auipc	s1,0x7
     fe6:	01e48493          	add	s1,s1,30 # 8000 <big>
     fea:	fd840593          	add	a1,s0,-40
     fee:	6088                	ld	a0,0(s1)
     ff0:	54f030ef          	jal	4d3e <exec>
  pipe(big);
     ff4:	6088                	ld	a0,0(s1)
     ff6:	521030ef          	jal	4d16 <pipe>
  exit(0);
     ffa:	4501                	li	a0,0
     ffc:	50b030ef          	jal	4d06 <exit>

0000000000001000 <badarg>:
{
    1000:	7139                	add	sp,sp,-64
    1002:	fc06                	sd	ra,56(sp)
    1004:	f822                	sd	s0,48(sp)
    1006:	f426                	sd	s1,40(sp)
    1008:	f04a                	sd	s2,32(sp)
    100a:	ec4e                	sd	s3,24(sp)
    100c:	0080                	add	s0,sp,64
    100e:	64b1                	lui	s1,0xc
    1010:	35048493          	add	s1,s1,848 # c350 <buf+0x698>
    argv[0] = (char*)0xffffffff;
    1014:	597d                	li	s2,-1
    1016:	02095913          	srl	s2,s2,0x20
    exec("echo", argv);
    101a:	00004997          	auipc	s3,0x4
    101e:	2fe98993          	add	s3,s3,766 # 5318 <malloc+0x11c>
    argv[0] = (char*)0xffffffff;
    1022:	fd243023          	sd	s2,-64(s0)
    argv[1] = 0;
    1026:	fc043423          	sd	zero,-56(s0)
    exec("echo", argv);
    102a:	fc040593          	add	a1,s0,-64
    102e:	854e                	mv	a0,s3
    1030:	50f030ef          	jal	4d3e <exec>
  for(int i = 0; i < 50000; i++){
    1034:	34fd                	addw	s1,s1,-1
    1036:	f4f5                	bnez	s1,1022 <badarg+0x22>
  exit(0);
    1038:	4501                	li	a0,0
    103a:	4cd030ef          	jal	4d06 <exit>

000000000000103e <copyinstr2>:
{
    103e:	7155                	add	sp,sp,-208
    1040:	e586                	sd	ra,200(sp)
    1042:	e1a2                	sd	s0,192(sp)
    1044:	0980                	add	s0,sp,208
  for(int i = 0; i < MAXPATH; i++)
    1046:	f6840793          	add	a5,s0,-152
    104a:	fe840693          	add	a3,s0,-24
    b[i] = 'x';
    104e:	07800713          	li	a4,120
    1052:	00e78023          	sb	a4,0(a5)
  for(int i = 0; i < MAXPATH; i++)
    1056:	0785                	add	a5,a5,1
    1058:	fed79de3          	bne	a5,a3,1052 <copyinstr2+0x14>
  b[MAXPATH] = '\0';
    105c:	fe040423          	sb	zero,-24(s0)
  int ret = unlink(b);
    1060:	f6840513          	add	a0,s0,-152
    1064:	4f3030ef          	jal	4d56 <unlink>
  if(ret != -1){
    1068:	57fd                	li	a5,-1
    106a:	0cf51263          	bne	a0,a5,112e <copyinstr2+0xf0>
  int fd = open(b, O_CREATE | O_WRONLY);
    106e:	20100593          	li	a1,513
    1072:	f6840513          	add	a0,s0,-152
    1076:	4d1030ef          	jal	4d46 <open>
  if(fd != -1){
    107a:	57fd                	li	a5,-1
    107c:	0cf51563          	bne	a0,a5,1146 <copyinstr2+0x108>
  ret = link(b, b);
    1080:	f6840593          	add	a1,s0,-152
    1084:	852e                	mv	a0,a1
    1086:	4e1030ef          	jal	4d66 <link>
  if(ret != -1){
    108a:	57fd                	li	a5,-1
    108c:	0cf51963          	bne	a0,a5,115e <copyinstr2+0x120>
  char *args[] = { "xx", 0 };
    1090:	00006797          	auipc	a5,0x6
    1094:	b6878793          	add	a5,a5,-1176 # 6bf8 <malloc+0x19fc>
    1098:	f4f43c23          	sd	a5,-168(s0)
    109c:	f6043023          	sd	zero,-160(s0)
  ret = exec(b, args);
    10a0:	f5840593          	add	a1,s0,-168
    10a4:	f6840513          	add	a0,s0,-152
    10a8:	497030ef          	jal	4d3e <exec>
  if(ret != -1){
    10ac:	57fd                	li	a5,-1
    10ae:	0cf51563          	bne	a0,a5,1178 <copyinstr2+0x13a>
  int pid = fork();
    10b2:	44d030ef          	jal	4cfe <fork>
  if(pid < 0){
    10b6:	0c054d63          	bltz	a0,1190 <copyinstr2+0x152>
  if(pid == 0){
    10ba:	0e051863          	bnez	a0,11aa <copyinstr2+0x16c>
    10be:	00007797          	auipc	a5,0x7
    10c2:	4e278793          	add	a5,a5,1250 # 85a0 <big.0>
    10c6:	00008697          	auipc	a3,0x8
    10ca:	4da68693          	add	a3,a3,1242 # 95a0 <big.0+0x1000>
      big[i] = 'x';
    10ce:	07800713          	li	a4,120
    10d2:	00e78023          	sb	a4,0(a5)
    for(int i = 0; i < PGSIZE; i++)
    10d6:	0785                	add	a5,a5,1
    10d8:	fed79de3          	bne	a5,a3,10d2 <copyinstr2+0x94>
    big[PGSIZE] = '\0';
    10dc:	00008797          	auipc	a5,0x8
    10e0:	4c078223          	sb	zero,1220(a5) # 95a0 <big.0+0x1000>
    char *args2[] = { big, big, big, 0 };
    10e4:	00006797          	auipc	a5,0x6
    10e8:	77478793          	add	a5,a5,1908 # 7858 <malloc+0x265c>
    10ec:	6fb0                	ld	a2,88(a5)
    10ee:	73b4                	ld	a3,96(a5)
    10f0:	77b8                	ld	a4,104(a5)
    10f2:	7bbc                	ld	a5,112(a5)
    10f4:	f2c43823          	sd	a2,-208(s0)
    10f8:	f2d43c23          	sd	a3,-200(s0)
    10fc:	f4e43023          	sd	a4,-192(s0)
    1100:	f4f43423          	sd	a5,-184(s0)
    ret = exec("echo", args2);
    1104:	f3040593          	add	a1,s0,-208
    1108:	00004517          	auipc	a0,0x4
    110c:	21050513          	add	a0,a0,528 # 5318 <malloc+0x11c>
    1110:	42f030ef          	jal	4d3e <exec>
    if(ret != -1){
    1114:	57fd                	li	a5,-1
    1116:	08f50663          	beq	a0,a5,11a2 <copyinstr2+0x164>
      printf("exec(echo, BIG) returned %d, not -1\n", fd);
    111a:	55fd                	li	a1,-1
    111c:	00005517          	auipc	a0,0x5
    1120:	a3450513          	add	a0,a0,-1484 # 5b50 <malloc+0x954>
    1124:	024040ef          	jal	5148 <printf>
      exit(1);
    1128:	4505                	li	a0,1
    112a:	3dd030ef          	jal	4d06 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    112e:	862a                	mv	a2,a0
    1130:	f6840593          	add	a1,s0,-152
    1134:	00005517          	auipc	a0,0x5
    1138:	99450513          	add	a0,a0,-1644 # 5ac8 <malloc+0x8cc>
    113c:	00c040ef          	jal	5148 <printf>
    exit(1);
    1140:	4505                	li	a0,1
    1142:	3c5030ef          	jal	4d06 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    1146:	862a                	mv	a2,a0
    1148:	f6840593          	add	a1,s0,-152
    114c:	00005517          	auipc	a0,0x5
    1150:	99c50513          	add	a0,a0,-1636 # 5ae8 <malloc+0x8ec>
    1154:	7f5030ef          	jal	5148 <printf>
    exit(1);
    1158:	4505                	li	a0,1
    115a:	3ad030ef          	jal	4d06 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    115e:	86aa                	mv	a3,a0
    1160:	f6840613          	add	a2,s0,-152
    1164:	85b2                	mv	a1,a2
    1166:	00005517          	auipc	a0,0x5
    116a:	9a250513          	add	a0,a0,-1630 # 5b08 <malloc+0x90c>
    116e:	7db030ef          	jal	5148 <printf>
    exit(1);
    1172:	4505                	li	a0,1
    1174:	393030ef          	jal	4d06 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    1178:	567d                	li	a2,-1
    117a:	f6840593          	add	a1,s0,-152
    117e:	00005517          	auipc	a0,0x5
    1182:	9b250513          	add	a0,a0,-1614 # 5b30 <malloc+0x934>
    1186:	7c3030ef          	jal	5148 <printf>
    exit(1);
    118a:	4505                	li	a0,1
    118c:	37b030ef          	jal	4d06 <exit>
    printf("fork failed\n");
    1190:	00006517          	auipc	a0,0x6
    1194:	fc050513          	add	a0,a0,-64 # 7150 <malloc+0x1f54>
    1198:	7b1030ef          	jal	5148 <printf>
    exit(1);
    119c:	4505                	li	a0,1
    119e:	369030ef          	jal	4d06 <exit>
    exit(747); // OK
    11a2:	2eb00513          	li	a0,747
    11a6:	361030ef          	jal	4d06 <exit>
  int st = 0;
    11aa:	f4042a23          	sw	zero,-172(s0)
  wait(&st);
    11ae:	f5440513          	add	a0,s0,-172
    11b2:	35d030ef          	jal	4d0e <wait>
  if(st != 747){
    11b6:	f5442703          	lw	a4,-172(s0)
    11ba:	2eb00793          	li	a5,747
    11be:	00f71663          	bne	a4,a5,11ca <copyinstr2+0x18c>
}
    11c2:	60ae                	ld	ra,200(sp)
    11c4:	640e                	ld	s0,192(sp)
    11c6:	6169                	add	sp,sp,208
    11c8:	8082                	ret
    printf("exec(echo, BIG) succeeded, should have failed\n");
    11ca:	00005517          	auipc	a0,0x5
    11ce:	9ae50513          	add	a0,a0,-1618 # 5b78 <malloc+0x97c>
    11d2:	777030ef          	jal	5148 <printf>
    exit(1);
    11d6:	4505                	li	a0,1
    11d8:	32f030ef          	jal	4d06 <exit>

00000000000011dc <truncate3>:
{
    11dc:	7159                	add	sp,sp,-112
    11de:	f486                	sd	ra,104(sp)
    11e0:	f0a2                	sd	s0,96(sp)
    11e2:	eca6                	sd	s1,88(sp)
    11e4:	e8ca                	sd	s2,80(sp)
    11e6:	e4ce                	sd	s3,72(sp)
    11e8:	e0d2                	sd	s4,64(sp)
    11ea:	fc56                	sd	s5,56(sp)
    11ec:	1880                	add	s0,sp,112
    11ee:	892a                	mv	s2,a0
  close(open("truncfile", O_CREATE|O_TRUNC|O_WRONLY));
    11f0:	60100593          	li	a1,1537
    11f4:	00004517          	auipc	a0,0x4
    11f8:	17c50513          	add	a0,a0,380 # 5370 <malloc+0x174>
    11fc:	34b030ef          	jal	4d46 <open>
    1200:	32f030ef          	jal	4d2e <close>
  pid = fork();
    1204:	2fb030ef          	jal	4cfe <fork>
  if(pid < 0){
    1208:	06054263          	bltz	a0,126c <truncate3+0x90>
  if(pid == 0){
    120c:	ed59                	bnez	a0,12aa <truncate3+0xce>
    120e:	06400993          	li	s3,100
      int fd = open("truncfile", O_WRONLY);
    1212:	00004a17          	auipc	s4,0x4
    1216:	15ea0a13          	add	s4,s4,350 # 5370 <malloc+0x174>
      int n = write(fd, "1234567890", 10);
    121a:	00005a97          	auipc	s5,0x5
    121e:	9bea8a93          	add	s5,s5,-1602 # 5bd8 <malloc+0x9dc>
      int fd = open("truncfile", O_WRONLY);
    1222:	4585                	li	a1,1
    1224:	8552                	mv	a0,s4
    1226:	321030ef          	jal	4d46 <open>
    122a:	84aa                	mv	s1,a0
      if(fd < 0){
    122c:	04054a63          	bltz	a0,1280 <truncate3+0xa4>
      int n = write(fd, "1234567890", 10);
    1230:	4629                	li	a2,10
    1232:	85d6                	mv	a1,s5
    1234:	2f3030ef          	jal	4d26 <write>
      if(n != 10){
    1238:	47a9                	li	a5,10
    123a:	04f51d63          	bne	a0,a5,1294 <truncate3+0xb8>
      close(fd);
    123e:	8526                	mv	a0,s1
    1240:	2ef030ef          	jal	4d2e <close>
      fd = open("truncfile", O_RDONLY);
    1244:	4581                	li	a1,0
    1246:	8552                	mv	a0,s4
    1248:	2ff030ef          	jal	4d46 <open>
    124c:	84aa                	mv	s1,a0
      read(fd, buf, sizeof(buf));
    124e:	02000613          	li	a2,32
    1252:	f9840593          	add	a1,s0,-104
    1256:	2c9030ef          	jal	4d1e <read>
      close(fd);
    125a:	8526                	mv	a0,s1
    125c:	2d3030ef          	jal	4d2e <close>
    for(int i = 0; i < 100; i++){
    1260:	39fd                	addw	s3,s3,-1
    1262:	fc0990e3          	bnez	s3,1222 <truncate3+0x46>
    exit(0);
    1266:	4501                	li	a0,0
    1268:	29f030ef          	jal	4d06 <exit>
    printf("%s: fork failed\n", s);
    126c:	85ca                	mv	a1,s2
    126e:	00005517          	auipc	a0,0x5
    1272:	93a50513          	add	a0,a0,-1734 # 5ba8 <malloc+0x9ac>
    1276:	6d3030ef          	jal	5148 <printf>
    exit(1);
    127a:	4505                	li	a0,1
    127c:	28b030ef          	jal	4d06 <exit>
        printf("%s: open failed\n", s);
    1280:	85ca                	mv	a1,s2
    1282:	00005517          	auipc	a0,0x5
    1286:	93e50513          	add	a0,a0,-1730 # 5bc0 <malloc+0x9c4>
    128a:	6bf030ef          	jal	5148 <printf>
        exit(1);
    128e:	4505                	li	a0,1
    1290:	277030ef          	jal	4d06 <exit>
        printf("%s: write got %d, expected 10\n", s, n);
    1294:	862a                	mv	a2,a0
    1296:	85ca                	mv	a1,s2
    1298:	00005517          	auipc	a0,0x5
    129c:	95050513          	add	a0,a0,-1712 # 5be8 <malloc+0x9ec>
    12a0:	6a9030ef          	jal	5148 <printf>
        exit(1);
    12a4:	4505                	li	a0,1
    12a6:	261030ef          	jal	4d06 <exit>
    12aa:	09600993          	li	s3,150
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    12ae:	00004a17          	auipc	s4,0x4
    12b2:	0c2a0a13          	add	s4,s4,194 # 5370 <malloc+0x174>
    int n = write(fd, "xxx", 3);
    12b6:	00005a97          	auipc	s5,0x5
    12ba:	952a8a93          	add	s5,s5,-1710 # 5c08 <malloc+0xa0c>
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    12be:	60100593          	li	a1,1537
    12c2:	8552                	mv	a0,s4
    12c4:	283030ef          	jal	4d46 <open>
    12c8:	84aa                	mv	s1,a0
    if(fd < 0){
    12ca:	02054d63          	bltz	a0,1304 <truncate3+0x128>
    int n = write(fd, "xxx", 3);
    12ce:	460d                	li	a2,3
    12d0:	85d6                	mv	a1,s5
    12d2:	255030ef          	jal	4d26 <write>
    if(n != 3){
    12d6:	478d                	li	a5,3
    12d8:	04f51063          	bne	a0,a5,1318 <truncate3+0x13c>
    close(fd);
    12dc:	8526                	mv	a0,s1
    12de:	251030ef          	jal	4d2e <close>
  for(int i = 0; i < 150; i++){
    12e2:	39fd                	addw	s3,s3,-1
    12e4:	fc099de3          	bnez	s3,12be <truncate3+0xe2>
  wait(&xstatus);
    12e8:	fbc40513          	add	a0,s0,-68
    12ec:	223030ef          	jal	4d0e <wait>
  unlink("truncfile");
    12f0:	00004517          	auipc	a0,0x4
    12f4:	08050513          	add	a0,a0,128 # 5370 <malloc+0x174>
    12f8:	25f030ef          	jal	4d56 <unlink>
  exit(xstatus);
    12fc:	fbc42503          	lw	a0,-68(s0)
    1300:	207030ef          	jal	4d06 <exit>
      printf("%s: open failed\n", s);
    1304:	85ca                	mv	a1,s2
    1306:	00005517          	auipc	a0,0x5
    130a:	8ba50513          	add	a0,a0,-1862 # 5bc0 <malloc+0x9c4>
    130e:	63b030ef          	jal	5148 <printf>
      exit(1);
    1312:	4505                	li	a0,1
    1314:	1f3030ef          	jal	4d06 <exit>
      printf("%s: write got %d, expected 3\n", s, n);
    1318:	862a                	mv	a2,a0
    131a:	85ca                	mv	a1,s2
    131c:	00005517          	auipc	a0,0x5
    1320:	8f450513          	add	a0,a0,-1804 # 5c10 <malloc+0xa14>
    1324:	625030ef          	jal	5148 <printf>
      exit(1);
    1328:	4505                	li	a0,1
    132a:	1dd030ef          	jal	4d06 <exit>

000000000000132e <exectest>:
{
    132e:	715d                	add	sp,sp,-80
    1330:	e486                	sd	ra,72(sp)
    1332:	e0a2                	sd	s0,64(sp)
    1334:	fc26                	sd	s1,56(sp)
    1336:	f84a                	sd	s2,48(sp)
    1338:	0880                	add	s0,sp,80
    133a:	892a                	mv	s2,a0
  char *echoargv[] = { "echo", "OK", 0 };
    133c:	00004797          	auipc	a5,0x4
    1340:	fdc78793          	add	a5,a5,-36 # 5318 <malloc+0x11c>
    1344:	fcf43023          	sd	a5,-64(s0)
    1348:	00005797          	auipc	a5,0x5
    134c:	8e878793          	add	a5,a5,-1816 # 5c30 <malloc+0xa34>
    1350:	fcf43423          	sd	a5,-56(s0)
    1354:	fc043823          	sd	zero,-48(s0)
  unlink("echo-ok");
    1358:	00005517          	auipc	a0,0x5
    135c:	8e050513          	add	a0,a0,-1824 # 5c38 <malloc+0xa3c>
    1360:	1f7030ef          	jal	4d56 <unlink>
  pid = fork();
    1364:	19b030ef          	jal	4cfe <fork>
  if(pid < 0) {
    1368:	02054e63          	bltz	a0,13a4 <exectest+0x76>
    136c:	84aa                	mv	s1,a0
  if(pid == 0) {
    136e:	e92d                	bnez	a0,13e0 <exectest+0xb2>
    close(1);
    1370:	4505                	li	a0,1
    1372:	1bd030ef          	jal	4d2e <close>
    fd = open("echo-ok", O_CREATE|O_WRONLY);
    1376:	20100593          	li	a1,513
    137a:	00005517          	auipc	a0,0x5
    137e:	8be50513          	add	a0,a0,-1858 # 5c38 <malloc+0xa3c>
    1382:	1c5030ef          	jal	4d46 <open>
    if(fd < 0) {
    1386:	02054963          	bltz	a0,13b8 <exectest+0x8a>
    if(fd != 1) {
    138a:	4785                	li	a5,1
    138c:	04f50063          	beq	a0,a5,13cc <exectest+0x9e>
      printf("%s: wrong fd\n", s);
    1390:	85ca                	mv	a1,s2
    1392:	00005517          	auipc	a0,0x5
    1396:	8c650513          	add	a0,a0,-1850 # 5c58 <malloc+0xa5c>
    139a:	5af030ef          	jal	5148 <printf>
      exit(1);
    139e:	4505                	li	a0,1
    13a0:	167030ef          	jal	4d06 <exit>
     printf("%s: fork failed\n", s);
    13a4:	85ca                	mv	a1,s2
    13a6:	00005517          	auipc	a0,0x5
    13aa:	80250513          	add	a0,a0,-2046 # 5ba8 <malloc+0x9ac>
    13ae:	59b030ef          	jal	5148 <printf>
     exit(1);
    13b2:	4505                	li	a0,1
    13b4:	153030ef          	jal	4d06 <exit>
      printf("%s: create failed\n", s);
    13b8:	85ca                	mv	a1,s2
    13ba:	00005517          	auipc	a0,0x5
    13be:	88650513          	add	a0,a0,-1914 # 5c40 <malloc+0xa44>
    13c2:	587030ef          	jal	5148 <printf>
      exit(1);
    13c6:	4505                	li	a0,1
    13c8:	13f030ef          	jal	4d06 <exit>
    if(exec("echo", echoargv) < 0){
    13cc:	fc040593          	add	a1,s0,-64
    13d0:	00004517          	auipc	a0,0x4
    13d4:	f4850513          	add	a0,a0,-184 # 5318 <malloc+0x11c>
    13d8:	167030ef          	jal	4d3e <exec>
    13dc:	00054d63          	bltz	a0,13f6 <exectest+0xc8>
  if (wait(&xstatus) != pid) {
    13e0:	fdc40513          	add	a0,s0,-36
    13e4:	12b030ef          	jal	4d0e <wait>
    13e8:	02951163          	bne	a0,s1,140a <exectest+0xdc>
  if(xstatus != 0)
    13ec:	fdc42503          	lw	a0,-36(s0)
    13f0:	c50d                	beqz	a0,141a <exectest+0xec>
    exit(xstatus);
    13f2:	115030ef          	jal	4d06 <exit>
      printf("%s: exec echo failed\n", s);
    13f6:	85ca                	mv	a1,s2
    13f8:	00005517          	auipc	a0,0x5
    13fc:	87050513          	add	a0,a0,-1936 # 5c68 <malloc+0xa6c>
    1400:	549030ef          	jal	5148 <printf>
      exit(1);
    1404:	4505                	li	a0,1
    1406:	101030ef          	jal	4d06 <exit>
    printf("%s: wait failed!\n", s);
    140a:	85ca                	mv	a1,s2
    140c:	00005517          	auipc	a0,0x5
    1410:	87450513          	add	a0,a0,-1932 # 5c80 <malloc+0xa84>
    1414:	535030ef          	jal	5148 <printf>
    1418:	bfd1                	j	13ec <exectest+0xbe>
  fd = open("echo-ok", O_RDONLY);
    141a:	4581                	li	a1,0
    141c:	00005517          	auipc	a0,0x5
    1420:	81c50513          	add	a0,a0,-2020 # 5c38 <malloc+0xa3c>
    1424:	123030ef          	jal	4d46 <open>
  if(fd < 0) {
    1428:	02054463          	bltz	a0,1450 <exectest+0x122>
  if (read(fd, buf, 2) != 2) {
    142c:	4609                	li	a2,2
    142e:	fb840593          	add	a1,s0,-72
    1432:	0ed030ef          	jal	4d1e <read>
    1436:	4789                	li	a5,2
    1438:	02f50663          	beq	a0,a5,1464 <exectest+0x136>
    printf("%s: read failed\n", s);
    143c:	85ca                	mv	a1,s2
    143e:	00004517          	auipc	a0,0x4
    1442:	2aa50513          	add	a0,a0,682 # 56e8 <malloc+0x4ec>
    1446:	503030ef          	jal	5148 <printf>
    exit(1);
    144a:	4505                	li	a0,1
    144c:	0bb030ef          	jal	4d06 <exit>
    printf("%s: open failed\n", s);
    1450:	85ca                	mv	a1,s2
    1452:	00004517          	auipc	a0,0x4
    1456:	76e50513          	add	a0,a0,1902 # 5bc0 <malloc+0x9c4>
    145a:	4ef030ef          	jal	5148 <printf>
    exit(1);
    145e:	4505                	li	a0,1
    1460:	0a7030ef          	jal	4d06 <exit>
  unlink("echo-ok");
    1464:	00004517          	auipc	a0,0x4
    1468:	7d450513          	add	a0,a0,2004 # 5c38 <malloc+0xa3c>
    146c:	0eb030ef          	jal	4d56 <unlink>
  if(buf[0] == 'O' && buf[1] == 'K')
    1470:	fb844703          	lbu	a4,-72(s0)
    1474:	04f00793          	li	a5,79
    1478:	00f71863          	bne	a4,a5,1488 <exectest+0x15a>
    147c:	fb944703          	lbu	a4,-71(s0)
    1480:	04b00793          	li	a5,75
    1484:	00f70c63          	beq	a4,a5,149c <exectest+0x16e>
    printf("%s: wrong output\n", s);
    1488:	85ca                	mv	a1,s2
    148a:	00005517          	auipc	a0,0x5
    148e:	80e50513          	add	a0,a0,-2034 # 5c98 <malloc+0xa9c>
    1492:	4b7030ef          	jal	5148 <printf>
    exit(1);
    1496:	4505                	li	a0,1
    1498:	06f030ef          	jal	4d06 <exit>
    exit(0);
    149c:	4501                	li	a0,0
    149e:	069030ef          	jal	4d06 <exit>

00000000000014a2 <pipe1>:
{
    14a2:	711d                	add	sp,sp,-96
    14a4:	ec86                	sd	ra,88(sp)
    14a6:	e8a2                	sd	s0,80(sp)
    14a8:	e4a6                	sd	s1,72(sp)
    14aa:	e0ca                	sd	s2,64(sp)
    14ac:	fc4e                	sd	s3,56(sp)
    14ae:	f852                	sd	s4,48(sp)
    14b0:	f456                	sd	s5,40(sp)
    14b2:	f05a                	sd	s6,32(sp)
    14b4:	ec5e                	sd	s7,24(sp)
    14b6:	1080                	add	s0,sp,96
    14b8:	892a                	mv	s2,a0
  if(pipe(fds) != 0){
    14ba:	fa840513          	add	a0,s0,-88
    14be:	059030ef          	jal	4d16 <pipe>
    14c2:	e52d                	bnez	a0,152c <pipe1+0x8a>
    14c4:	84aa                	mv	s1,a0
  pid = fork();
    14c6:	039030ef          	jal	4cfe <fork>
    14ca:	8a2a                	mv	s4,a0
  if(pid == 0){
    14cc:	c935                	beqz	a0,1540 <pipe1+0x9e>
  } else if(pid > 0){
    14ce:	14a05063          	blez	a0,160e <pipe1+0x16c>
    close(fds[1]);
    14d2:	fac42503          	lw	a0,-84(s0)
    14d6:	059030ef          	jal	4d2e <close>
    total = 0;
    14da:	8a26                	mv	s4,s1
    cc = 1;
    14dc:	4985                	li	s3,1
    while((n = read(fds[0], buf, cc)) > 0){
    14de:	0000aa97          	auipc	s5,0xa
    14e2:	7daa8a93          	add	s5,s5,2010 # bcb8 <buf>
    14e6:	864e                	mv	a2,s3
    14e8:	85d6                	mv	a1,s5
    14ea:	fa842503          	lw	a0,-88(s0)
    14ee:	031030ef          	jal	4d1e <read>
    14f2:	0ea05263          	blez	a0,15d6 <pipe1+0x134>
      for(i = 0; i < n; i++){
    14f6:	0000a717          	auipc	a4,0xa
    14fa:	7c270713          	add	a4,a4,1986 # bcb8 <buf>
    14fe:	00a4863b          	addw	a2,s1,a0
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    1502:	00074683          	lbu	a3,0(a4)
    1506:	0ff4f793          	zext.b	a5,s1
    150a:	2485                	addw	s1,s1,1
    150c:	0af69363          	bne	a3,a5,15b2 <pipe1+0x110>
      for(i = 0; i < n; i++){
    1510:	0705                	add	a4,a4,1
    1512:	fec498e3          	bne	s1,a2,1502 <pipe1+0x60>
      total += n;
    1516:	00aa0a3b          	addw	s4,s4,a0
      cc = cc * 2;
    151a:	0019979b          	sllw	a5,s3,0x1
    151e:	0007899b          	sext.w	s3,a5
      if(cc > sizeof(buf))
    1522:	670d                	lui	a4,0x3
    1524:	fd3771e3          	bgeu	a4,s3,14e6 <pipe1+0x44>
        cc = sizeof(buf);
    1528:	698d                	lui	s3,0x3
    152a:	bf75                	j	14e6 <pipe1+0x44>
    printf("%s: pipe() failed\n", s);
    152c:	85ca                	mv	a1,s2
    152e:	00004517          	auipc	a0,0x4
    1532:	78250513          	add	a0,a0,1922 # 5cb0 <malloc+0xab4>
    1536:	413030ef          	jal	5148 <printf>
    exit(1);
    153a:	4505                	li	a0,1
    153c:	7ca030ef          	jal	4d06 <exit>
    close(fds[0]);
    1540:	fa842503          	lw	a0,-88(s0)
    1544:	7ea030ef          	jal	4d2e <close>
    for(n = 0; n < N; n++){
    1548:	0000ab17          	auipc	s6,0xa
    154c:	770b0b13          	add	s6,s6,1904 # bcb8 <buf>
    1550:	416004bb          	negw	s1,s6
    1554:	0ff4f493          	zext.b	s1,s1
    1558:	409b0993          	add	s3,s6,1033
      if(write(fds[1], buf, SZ) != SZ){
    155c:	8bda                	mv	s7,s6
    for(n = 0; n < N; n++){
    155e:	6a85                	lui	s5,0x1
    1560:	42da8a93          	add	s5,s5,1069 # 142d <exectest+0xff>
{
    1564:	87da                	mv	a5,s6
        buf[i] = seq++;
    1566:	0097873b          	addw	a4,a5,s1
    156a:	00e78023          	sb	a4,0(a5)
      for(i = 0; i < SZ; i++)
    156e:	0785                	add	a5,a5,1
    1570:	fef99be3          	bne	s3,a5,1566 <pipe1+0xc4>
        buf[i] = seq++;
    1574:	409a0a1b          	addw	s4,s4,1033
      if(write(fds[1], buf, SZ) != SZ){
    1578:	40900613          	li	a2,1033
    157c:	85de                	mv	a1,s7
    157e:	fac42503          	lw	a0,-84(s0)
    1582:	7a4030ef          	jal	4d26 <write>
    1586:	40900793          	li	a5,1033
    158a:	00f51a63          	bne	a0,a5,159e <pipe1+0xfc>
    for(n = 0; n < N; n++){
    158e:	24a5                	addw	s1,s1,9
    1590:	0ff4f493          	zext.b	s1,s1
    1594:	fd5a18e3          	bne	s4,s5,1564 <pipe1+0xc2>
    exit(0);
    1598:	4501                	li	a0,0
    159a:	76c030ef          	jal	4d06 <exit>
        printf("%s: pipe1 oops 1\n", s);
    159e:	85ca                	mv	a1,s2
    15a0:	00004517          	auipc	a0,0x4
    15a4:	72850513          	add	a0,a0,1832 # 5cc8 <malloc+0xacc>
    15a8:	3a1030ef          	jal	5148 <printf>
        exit(1);
    15ac:	4505                	li	a0,1
    15ae:	758030ef          	jal	4d06 <exit>
          printf("%s: pipe1 oops 2\n", s);
    15b2:	85ca                	mv	a1,s2
    15b4:	00004517          	auipc	a0,0x4
    15b8:	72c50513          	add	a0,a0,1836 # 5ce0 <malloc+0xae4>
    15bc:	38d030ef          	jal	5148 <printf>
}
    15c0:	60e6                	ld	ra,88(sp)
    15c2:	6446                	ld	s0,80(sp)
    15c4:	64a6                	ld	s1,72(sp)
    15c6:	6906                	ld	s2,64(sp)
    15c8:	79e2                	ld	s3,56(sp)
    15ca:	7a42                	ld	s4,48(sp)
    15cc:	7aa2                	ld	s5,40(sp)
    15ce:	7b02                	ld	s6,32(sp)
    15d0:	6be2                	ld	s7,24(sp)
    15d2:	6125                	add	sp,sp,96
    15d4:	8082                	ret
    if(total != N * SZ){
    15d6:	6785                	lui	a5,0x1
    15d8:	42d78793          	add	a5,a5,1069 # 142d <exectest+0xff>
    15dc:	00fa0d63          	beq	s4,a5,15f6 <pipe1+0x154>
      printf("%s: pipe1 oops 3 total %d\n", s, total);
    15e0:	8652                	mv	a2,s4
    15e2:	85ca                	mv	a1,s2
    15e4:	00004517          	auipc	a0,0x4
    15e8:	71450513          	add	a0,a0,1812 # 5cf8 <malloc+0xafc>
    15ec:	35d030ef          	jal	5148 <printf>
      exit(1);
    15f0:	4505                	li	a0,1
    15f2:	714030ef          	jal	4d06 <exit>
    close(fds[0]);
    15f6:	fa842503          	lw	a0,-88(s0)
    15fa:	734030ef          	jal	4d2e <close>
    wait(&xstatus);
    15fe:	fa440513          	add	a0,s0,-92
    1602:	70c030ef          	jal	4d0e <wait>
    exit(xstatus);
    1606:	fa442503          	lw	a0,-92(s0)
    160a:	6fc030ef          	jal	4d06 <exit>
    printf("%s: fork() failed\n", s);
    160e:	85ca                	mv	a1,s2
    1610:	00004517          	auipc	a0,0x4
    1614:	70850513          	add	a0,a0,1800 # 5d18 <malloc+0xb1c>
    1618:	331030ef          	jal	5148 <printf>
    exit(1);
    161c:	4505                	li	a0,1
    161e:	6e8030ef          	jal	4d06 <exit>

0000000000001622 <exitwait>:
{
    1622:	7139                	add	sp,sp,-64
    1624:	fc06                	sd	ra,56(sp)
    1626:	f822                	sd	s0,48(sp)
    1628:	f426                	sd	s1,40(sp)
    162a:	f04a                	sd	s2,32(sp)
    162c:	ec4e                	sd	s3,24(sp)
    162e:	e852                	sd	s4,16(sp)
    1630:	0080                	add	s0,sp,64
    1632:	8a2a                	mv	s4,a0
  for(i = 0; i < 100; i++){
    1634:	4901                	li	s2,0
    1636:	06400993          	li	s3,100
    pid = fork();
    163a:	6c4030ef          	jal	4cfe <fork>
    163e:	84aa                	mv	s1,a0
    if(pid < 0){
    1640:	02054863          	bltz	a0,1670 <exitwait+0x4e>
    if(pid){
    1644:	c525                	beqz	a0,16ac <exitwait+0x8a>
      if(wait(&xstate) != pid){
    1646:	fcc40513          	add	a0,s0,-52
    164a:	6c4030ef          	jal	4d0e <wait>
    164e:	02951b63          	bne	a0,s1,1684 <exitwait+0x62>
      if(i != xstate) {
    1652:	fcc42783          	lw	a5,-52(s0)
    1656:	05279163          	bne	a5,s2,1698 <exitwait+0x76>
  for(i = 0; i < 100; i++){
    165a:	2905                	addw	s2,s2,1
    165c:	fd391fe3          	bne	s2,s3,163a <exitwait+0x18>
}
    1660:	70e2                	ld	ra,56(sp)
    1662:	7442                	ld	s0,48(sp)
    1664:	74a2                	ld	s1,40(sp)
    1666:	7902                	ld	s2,32(sp)
    1668:	69e2                	ld	s3,24(sp)
    166a:	6a42                	ld	s4,16(sp)
    166c:	6121                	add	sp,sp,64
    166e:	8082                	ret
      printf("%s: fork failed\n", s);
    1670:	85d2                	mv	a1,s4
    1672:	00004517          	auipc	a0,0x4
    1676:	53650513          	add	a0,a0,1334 # 5ba8 <malloc+0x9ac>
    167a:	2cf030ef          	jal	5148 <printf>
      exit(1);
    167e:	4505                	li	a0,1
    1680:	686030ef          	jal	4d06 <exit>
        printf("%s: wait wrong pid\n", s);
    1684:	85d2                	mv	a1,s4
    1686:	00004517          	auipc	a0,0x4
    168a:	6aa50513          	add	a0,a0,1706 # 5d30 <malloc+0xb34>
    168e:	2bb030ef          	jal	5148 <printf>
        exit(1);
    1692:	4505                	li	a0,1
    1694:	672030ef          	jal	4d06 <exit>
        printf("%s: wait wrong exit status\n", s);
    1698:	85d2                	mv	a1,s4
    169a:	00004517          	auipc	a0,0x4
    169e:	6ae50513          	add	a0,a0,1710 # 5d48 <malloc+0xb4c>
    16a2:	2a7030ef          	jal	5148 <printf>
        exit(1);
    16a6:	4505                	li	a0,1
    16a8:	65e030ef          	jal	4d06 <exit>
      exit(i);
    16ac:	854a                	mv	a0,s2
    16ae:	658030ef          	jal	4d06 <exit>

00000000000016b2 <twochildren>:
{
    16b2:	1101                	add	sp,sp,-32
    16b4:	ec06                	sd	ra,24(sp)
    16b6:	e822                	sd	s0,16(sp)
    16b8:	e426                	sd	s1,8(sp)
    16ba:	e04a                	sd	s2,0(sp)
    16bc:	1000                	add	s0,sp,32
    16be:	892a                	mv	s2,a0
    16c0:	3e800493          	li	s1,1000
    int pid1 = fork();
    16c4:	63a030ef          	jal	4cfe <fork>
    if(pid1 < 0){
    16c8:	02054663          	bltz	a0,16f4 <twochildren+0x42>
    if(pid1 == 0){
    16cc:	cd15                	beqz	a0,1708 <twochildren+0x56>
      int pid2 = fork();
    16ce:	630030ef          	jal	4cfe <fork>
      if(pid2 < 0){
    16d2:	02054d63          	bltz	a0,170c <twochildren+0x5a>
      if(pid2 == 0){
    16d6:	c529                	beqz	a0,1720 <twochildren+0x6e>
        wait(0);
    16d8:	4501                	li	a0,0
    16da:	634030ef          	jal	4d0e <wait>
        wait(0);
    16de:	4501                	li	a0,0
    16e0:	62e030ef          	jal	4d0e <wait>
  for(int i = 0; i < 1000; i++){
    16e4:	34fd                	addw	s1,s1,-1
    16e6:	fcf9                	bnez	s1,16c4 <twochildren+0x12>
}
    16e8:	60e2                	ld	ra,24(sp)
    16ea:	6442                	ld	s0,16(sp)
    16ec:	64a2                	ld	s1,8(sp)
    16ee:	6902                	ld	s2,0(sp)
    16f0:	6105                	add	sp,sp,32
    16f2:	8082                	ret
      printf("%s: fork failed\n", s);
    16f4:	85ca                	mv	a1,s2
    16f6:	00004517          	auipc	a0,0x4
    16fa:	4b250513          	add	a0,a0,1202 # 5ba8 <malloc+0x9ac>
    16fe:	24b030ef          	jal	5148 <printf>
      exit(1);
    1702:	4505                	li	a0,1
    1704:	602030ef          	jal	4d06 <exit>
      exit(0);
    1708:	5fe030ef          	jal	4d06 <exit>
        printf("%s: fork failed\n", s);
    170c:	85ca                	mv	a1,s2
    170e:	00004517          	auipc	a0,0x4
    1712:	49a50513          	add	a0,a0,1178 # 5ba8 <malloc+0x9ac>
    1716:	233030ef          	jal	5148 <printf>
        exit(1);
    171a:	4505                	li	a0,1
    171c:	5ea030ef          	jal	4d06 <exit>
        exit(0);
    1720:	5e6030ef          	jal	4d06 <exit>

0000000000001724 <forkfork>:
{
    1724:	7179                	add	sp,sp,-48
    1726:	f406                	sd	ra,40(sp)
    1728:	f022                	sd	s0,32(sp)
    172a:	ec26                	sd	s1,24(sp)
    172c:	1800                	add	s0,sp,48
    172e:	84aa                	mv	s1,a0
    int pid = fork();
    1730:	5ce030ef          	jal	4cfe <fork>
    if(pid < 0){
    1734:	02054b63          	bltz	a0,176a <forkfork+0x46>
    if(pid == 0){
    1738:	c139                	beqz	a0,177e <forkfork+0x5a>
    int pid = fork();
    173a:	5c4030ef          	jal	4cfe <fork>
    if(pid < 0){
    173e:	02054663          	bltz	a0,176a <forkfork+0x46>
    if(pid == 0){
    1742:	cd15                	beqz	a0,177e <forkfork+0x5a>
    wait(&xstatus);
    1744:	fdc40513          	add	a0,s0,-36
    1748:	5c6030ef          	jal	4d0e <wait>
    if(xstatus != 0) {
    174c:	fdc42783          	lw	a5,-36(s0)
    1750:	ebb9                	bnez	a5,17a6 <forkfork+0x82>
    wait(&xstatus);
    1752:	fdc40513          	add	a0,s0,-36
    1756:	5b8030ef          	jal	4d0e <wait>
    if(xstatus != 0) {
    175a:	fdc42783          	lw	a5,-36(s0)
    175e:	e7a1                	bnez	a5,17a6 <forkfork+0x82>
}
    1760:	70a2                	ld	ra,40(sp)
    1762:	7402                	ld	s0,32(sp)
    1764:	64e2                	ld	s1,24(sp)
    1766:	6145                	add	sp,sp,48
    1768:	8082                	ret
      printf("%s: fork failed", s);
    176a:	85a6                	mv	a1,s1
    176c:	00004517          	auipc	a0,0x4
    1770:	5fc50513          	add	a0,a0,1532 # 5d68 <malloc+0xb6c>
    1774:	1d5030ef          	jal	5148 <printf>
      exit(1);
    1778:	4505                	li	a0,1
    177a:	58c030ef          	jal	4d06 <exit>
{
    177e:	0c800493          	li	s1,200
        int pid1 = fork();
    1782:	57c030ef          	jal	4cfe <fork>
        if(pid1 < 0){
    1786:	00054b63          	bltz	a0,179c <forkfork+0x78>
        if(pid1 == 0){
    178a:	cd01                	beqz	a0,17a2 <forkfork+0x7e>
        wait(0);
    178c:	4501                	li	a0,0
    178e:	580030ef          	jal	4d0e <wait>
      for(int j = 0; j < 200; j++){
    1792:	34fd                	addw	s1,s1,-1
    1794:	f4fd                	bnez	s1,1782 <forkfork+0x5e>
      exit(0);
    1796:	4501                	li	a0,0
    1798:	56e030ef          	jal	4d06 <exit>
          exit(1);
    179c:	4505                	li	a0,1
    179e:	568030ef          	jal	4d06 <exit>
          exit(0);
    17a2:	564030ef          	jal	4d06 <exit>
      printf("%s: fork in child failed", s);
    17a6:	85a6                	mv	a1,s1
    17a8:	00004517          	auipc	a0,0x4
    17ac:	5d050513          	add	a0,a0,1488 # 5d78 <malloc+0xb7c>
    17b0:	199030ef          	jal	5148 <printf>
      exit(1);
    17b4:	4505                	li	a0,1
    17b6:	550030ef          	jal	4d06 <exit>

00000000000017ba <reparent2>:
{
    17ba:	1101                	add	sp,sp,-32
    17bc:	ec06                	sd	ra,24(sp)
    17be:	e822                	sd	s0,16(sp)
    17c0:	e426                	sd	s1,8(sp)
    17c2:	1000                	add	s0,sp,32
    17c4:	32000493          	li	s1,800
    int pid1 = fork();
    17c8:	536030ef          	jal	4cfe <fork>
    if(pid1 < 0){
    17cc:	00054b63          	bltz	a0,17e2 <reparent2+0x28>
    if(pid1 == 0){
    17d0:	c115                	beqz	a0,17f4 <reparent2+0x3a>
    wait(0);
    17d2:	4501                	li	a0,0
    17d4:	53a030ef          	jal	4d0e <wait>
  for(int i = 0; i < 800; i++){
    17d8:	34fd                	addw	s1,s1,-1
    17da:	f4fd                	bnez	s1,17c8 <reparent2+0xe>
  exit(0);
    17dc:	4501                	li	a0,0
    17de:	528030ef          	jal	4d06 <exit>
      printf("fork failed\n");
    17e2:	00006517          	auipc	a0,0x6
    17e6:	96e50513          	add	a0,a0,-1682 # 7150 <malloc+0x1f54>
    17ea:	15f030ef          	jal	5148 <printf>
      exit(1);
    17ee:	4505                	li	a0,1
    17f0:	516030ef          	jal	4d06 <exit>
      fork();
    17f4:	50a030ef          	jal	4cfe <fork>
      fork();
    17f8:	506030ef          	jal	4cfe <fork>
      exit(0);
    17fc:	4501                	li	a0,0
    17fe:	508030ef          	jal	4d06 <exit>

0000000000001802 <createdelete>:
{
    1802:	7175                	add	sp,sp,-144
    1804:	e506                	sd	ra,136(sp)
    1806:	e122                	sd	s0,128(sp)
    1808:	fca6                	sd	s1,120(sp)
    180a:	f8ca                	sd	s2,112(sp)
    180c:	f4ce                	sd	s3,104(sp)
    180e:	f0d2                	sd	s4,96(sp)
    1810:	ecd6                	sd	s5,88(sp)
    1812:	e8da                	sd	s6,80(sp)
    1814:	e4de                	sd	s7,72(sp)
    1816:	e0e2                	sd	s8,64(sp)
    1818:	fc66                	sd	s9,56(sp)
    181a:	0900                	add	s0,sp,144
    181c:	8caa                	mv	s9,a0
  for(pi = 0; pi < NCHILD; pi++){
    181e:	4901                	li	s2,0
    1820:	4991                	li	s3,4
    pid = fork();
    1822:	4dc030ef          	jal	4cfe <fork>
    1826:	84aa                	mv	s1,a0
    if(pid < 0){
    1828:	02054d63          	bltz	a0,1862 <createdelete+0x60>
    if(pid == 0){
    182c:	c529                	beqz	a0,1876 <createdelete+0x74>
  for(pi = 0; pi < NCHILD; pi++){
    182e:	2905                	addw	s2,s2,1
    1830:	ff3919e3          	bne	s2,s3,1822 <createdelete+0x20>
    1834:	4491                	li	s1,4
    wait(&xstatus);
    1836:	f7c40513          	add	a0,s0,-132
    183a:	4d4030ef          	jal	4d0e <wait>
    if(xstatus != 0)
    183e:	f7c42903          	lw	s2,-132(s0)
    1842:	0a091e63          	bnez	s2,18fe <createdelete+0xfc>
  for(pi = 0; pi < NCHILD; pi++){
    1846:	34fd                	addw	s1,s1,-1
    1848:	f4fd                	bnez	s1,1836 <createdelete+0x34>
  name[0] = name[1] = name[2] = 0;
    184a:	f8040123          	sb	zero,-126(s0)
    184e:	03000993          	li	s3,48
    1852:	5a7d                	li	s4,-1
    1854:	07000c13          	li	s8,112
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1858:	4b21                	li	s6,8
      if((i == 0 || i >= N/2) && fd < 0){
    185a:	4ba5                	li	s7,9
    for(pi = 0; pi < NCHILD; pi++){
    185c:	07400a93          	li	s5,116
    1860:	a20d                	j	1982 <createdelete+0x180>
      printf("%s: fork failed\n", s);
    1862:	85e6                	mv	a1,s9
    1864:	00004517          	auipc	a0,0x4
    1868:	34450513          	add	a0,a0,836 # 5ba8 <malloc+0x9ac>
    186c:	0dd030ef          	jal	5148 <printf>
      exit(1);
    1870:	4505                	li	a0,1
    1872:	494030ef          	jal	4d06 <exit>
      name[0] = 'p' + pi;
    1876:	0709091b          	addw	s2,s2,112
    187a:	f9240023          	sb	s2,-128(s0)
      name[2] = '\0';
    187e:	f8040123          	sb	zero,-126(s0)
      for(i = 0; i < N; i++){
    1882:	4951                	li	s2,20
    1884:	a831                	j	18a0 <createdelete+0x9e>
          printf("%s: create failed\n", s);
    1886:	85e6                	mv	a1,s9
    1888:	00004517          	auipc	a0,0x4
    188c:	3b850513          	add	a0,a0,952 # 5c40 <malloc+0xa44>
    1890:	0b9030ef          	jal	5148 <printf>
          exit(1);
    1894:	4505                	li	a0,1
    1896:	470030ef          	jal	4d06 <exit>
      for(i = 0; i < N; i++){
    189a:	2485                	addw	s1,s1,1
    189c:	05248e63          	beq	s1,s2,18f8 <createdelete+0xf6>
        name[1] = '0' + i;
    18a0:	0304879b          	addw	a5,s1,48
    18a4:	f8f400a3          	sb	a5,-127(s0)
        fd = open(name, O_CREATE | O_RDWR);
    18a8:	20200593          	li	a1,514
    18ac:	f8040513          	add	a0,s0,-128
    18b0:	496030ef          	jal	4d46 <open>
        if(fd < 0){
    18b4:	fc0549e3          	bltz	a0,1886 <createdelete+0x84>
        close(fd);
    18b8:	476030ef          	jal	4d2e <close>
        if(i > 0 && (i % 2 ) == 0){
    18bc:	fc905fe3          	blez	s1,189a <createdelete+0x98>
    18c0:	0014f793          	and	a5,s1,1
    18c4:	fbf9                	bnez	a5,189a <createdelete+0x98>
          name[1] = '0' + (i / 2);
    18c6:	01f4d79b          	srlw	a5,s1,0x1f
    18ca:	9fa5                	addw	a5,a5,s1
    18cc:	4017d79b          	sraw	a5,a5,0x1
    18d0:	0307879b          	addw	a5,a5,48
    18d4:	f8f400a3          	sb	a5,-127(s0)
          if(unlink(name) < 0){
    18d8:	f8040513          	add	a0,s0,-128
    18dc:	47a030ef          	jal	4d56 <unlink>
    18e0:	fa055de3          	bgez	a0,189a <createdelete+0x98>
            printf("%s: unlink failed\n", s);
    18e4:	85e6                	mv	a1,s9
    18e6:	00004517          	auipc	a0,0x4
    18ea:	4b250513          	add	a0,a0,1202 # 5d98 <malloc+0xb9c>
    18ee:	05b030ef          	jal	5148 <printf>
            exit(1);
    18f2:	4505                	li	a0,1
    18f4:	412030ef          	jal	4d06 <exit>
      exit(0);
    18f8:	4501                	li	a0,0
    18fa:	40c030ef          	jal	4d06 <exit>
      exit(1);
    18fe:	4505                	li	a0,1
    1900:	406030ef          	jal	4d06 <exit>
        printf("%s: oops createdelete %s didn't exist\n", s, name);
    1904:	f8040613          	add	a2,s0,-128
    1908:	85e6                	mv	a1,s9
    190a:	00004517          	auipc	a0,0x4
    190e:	4a650513          	add	a0,a0,1190 # 5db0 <malloc+0xbb4>
    1912:	037030ef          	jal	5148 <printf>
        exit(1);
    1916:	4505                	li	a0,1
    1918:	3ee030ef          	jal	4d06 <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    191c:	034b7d63          	bgeu	s6,s4,1956 <createdelete+0x154>
      if(fd >= 0)
    1920:	02055863          	bgez	a0,1950 <createdelete+0x14e>
    for(pi = 0; pi < NCHILD; pi++){
    1924:	2485                	addw	s1,s1,1
    1926:	0ff4f493          	zext.b	s1,s1
    192a:	05548463          	beq	s1,s5,1972 <createdelete+0x170>
      name[0] = 'p' + pi;
    192e:	f8940023          	sb	s1,-128(s0)
      name[1] = '0' + i;
    1932:	f93400a3          	sb	s3,-127(s0)
      fd = open(name, 0);
    1936:	4581                	li	a1,0
    1938:	f8040513          	add	a0,s0,-128
    193c:	40a030ef          	jal	4d46 <open>
      if((i == 0 || i >= N/2) && fd < 0){
    1940:	00090463          	beqz	s2,1948 <createdelete+0x146>
    1944:	fd2bdce3          	bge	s7,s2,191c <createdelete+0x11a>
    1948:	fa054ee3          	bltz	a0,1904 <createdelete+0x102>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    194c:	014b7763          	bgeu	s6,s4,195a <createdelete+0x158>
        close(fd);
    1950:	3de030ef          	jal	4d2e <close>
    1954:	bfc1                	j	1924 <createdelete+0x122>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1956:	fc0547e3          	bltz	a0,1924 <createdelete+0x122>
        printf("%s: oops createdelete %s did exist\n", s, name);
    195a:	f8040613          	add	a2,s0,-128
    195e:	85e6                	mv	a1,s9
    1960:	00004517          	auipc	a0,0x4
    1964:	47850513          	add	a0,a0,1144 # 5dd8 <malloc+0xbdc>
    1968:	7e0030ef          	jal	5148 <printf>
        exit(1);
    196c:	4505                	li	a0,1
    196e:	398030ef          	jal	4d06 <exit>
  for(i = 0; i < N; i++){
    1972:	2905                	addw	s2,s2,1
    1974:	2a05                	addw	s4,s4,1
    1976:	2985                	addw	s3,s3,1 # 3001 <subdir+0x493>
    1978:	0ff9f993          	zext.b	s3,s3
    197c:	47d1                	li	a5,20
    197e:	02f90863          	beq	s2,a5,19ae <createdelete+0x1ac>
    for(pi = 0; pi < NCHILD; pi++){
    1982:	84e2                	mv	s1,s8
    1984:	b76d                	j	192e <createdelete+0x12c>
  for(i = 0; i < N; i++){
    1986:	2905                	addw	s2,s2,1
    1988:	0ff97913          	zext.b	s2,s2
    198c:	03490a63          	beq	s2,s4,19c0 <createdelete+0x1be>
  name[0] = name[1] = name[2] = 0;
    1990:	84d6                	mv	s1,s5
      name[0] = 'p' + pi;
    1992:	f8940023          	sb	s1,-128(s0)
      name[1] = '0' + i;
    1996:	f92400a3          	sb	s2,-127(s0)
      unlink(name);
    199a:	f8040513          	add	a0,s0,-128
    199e:	3b8030ef          	jal	4d56 <unlink>
    for(pi = 0; pi < NCHILD; pi++){
    19a2:	2485                	addw	s1,s1,1
    19a4:	0ff4f493          	zext.b	s1,s1
    19a8:	ff3495e3          	bne	s1,s3,1992 <createdelete+0x190>
    19ac:	bfe9                	j	1986 <createdelete+0x184>
    19ae:	03000913          	li	s2,48
  name[0] = name[1] = name[2] = 0;
    19b2:	07000a93          	li	s5,112
    for(pi = 0; pi < NCHILD; pi++){
    19b6:	07400993          	li	s3,116
  for(i = 0; i < N; i++){
    19ba:	04400a13          	li	s4,68
    19be:	bfc9                	j	1990 <createdelete+0x18e>
}
    19c0:	60aa                	ld	ra,136(sp)
    19c2:	640a                	ld	s0,128(sp)
    19c4:	74e6                	ld	s1,120(sp)
    19c6:	7946                	ld	s2,112(sp)
    19c8:	79a6                	ld	s3,104(sp)
    19ca:	7a06                	ld	s4,96(sp)
    19cc:	6ae6                	ld	s5,88(sp)
    19ce:	6b46                	ld	s6,80(sp)
    19d0:	6ba6                	ld	s7,72(sp)
    19d2:	6c06                	ld	s8,64(sp)
    19d4:	7ce2                	ld	s9,56(sp)
    19d6:	6149                	add	sp,sp,144
    19d8:	8082                	ret

00000000000019da <linkunlink>:
{
    19da:	711d                	add	sp,sp,-96
    19dc:	ec86                	sd	ra,88(sp)
    19de:	e8a2                	sd	s0,80(sp)
    19e0:	e4a6                	sd	s1,72(sp)
    19e2:	e0ca                	sd	s2,64(sp)
    19e4:	fc4e                	sd	s3,56(sp)
    19e6:	f852                	sd	s4,48(sp)
    19e8:	f456                	sd	s5,40(sp)
    19ea:	f05a                	sd	s6,32(sp)
    19ec:	ec5e                	sd	s7,24(sp)
    19ee:	e862                	sd	s8,16(sp)
    19f0:	e466                	sd	s9,8(sp)
    19f2:	1080                	add	s0,sp,96
    19f4:	84aa                	mv	s1,a0
  unlink("x");
    19f6:	00004517          	auipc	a0,0x4
    19fa:	99250513          	add	a0,a0,-1646 # 5388 <malloc+0x18c>
    19fe:	358030ef          	jal	4d56 <unlink>
  pid = fork();
    1a02:	2fc030ef          	jal	4cfe <fork>
  if(pid < 0){
    1a06:	02054b63          	bltz	a0,1a3c <linkunlink+0x62>
    1a0a:	8c2a                	mv	s8,a0
  unsigned int x = (pid ? 1 : 97);
    1a0c:	06100c93          	li	s9,97
    1a10:	c111                	beqz	a0,1a14 <linkunlink+0x3a>
    1a12:	4c85                	li	s9,1
    1a14:	06400493          	li	s1,100
    x = x * 1103515245 + 12345;
    1a18:	41c659b7          	lui	s3,0x41c65
    1a1c:	e6d9899b          	addw	s3,s3,-403 # 41c64e6d <base+0x41c561b5>
    1a20:	690d                	lui	s2,0x3
    1a22:	0399091b          	addw	s2,s2,57 # 3039 <subdir+0x4cb>
    if((x % 3) == 0){
    1a26:	4a0d                	li	s4,3
    } else if((x % 3) == 1){
    1a28:	4b05                	li	s6,1
      unlink("x");
    1a2a:	00004a97          	auipc	s5,0x4
    1a2e:	95ea8a93          	add	s5,s5,-1698 # 5388 <malloc+0x18c>
      link("cat", "x");
    1a32:	00004b97          	auipc	s7,0x4
    1a36:	3ceb8b93          	add	s7,s7,974 # 5e00 <malloc+0xc04>
    1a3a:	a025                	j	1a62 <linkunlink+0x88>
    printf("%s: fork failed\n", s);
    1a3c:	85a6                	mv	a1,s1
    1a3e:	00004517          	auipc	a0,0x4
    1a42:	16a50513          	add	a0,a0,362 # 5ba8 <malloc+0x9ac>
    1a46:	702030ef          	jal	5148 <printf>
    exit(1);
    1a4a:	4505                	li	a0,1
    1a4c:	2ba030ef          	jal	4d06 <exit>
      close(open("x", O_RDWR | O_CREATE));
    1a50:	20200593          	li	a1,514
    1a54:	8556                	mv	a0,s5
    1a56:	2f0030ef          	jal	4d46 <open>
    1a5a:	2d4030ef          	jal	4d2e <close>
  for(i = 0; i < 100; i++){
    1a5e:	34fd                	addw	s1,s1,-1
    1a60:	c48d                	beqz	s1,1a8a <linkunlink+0xb0>
    x = x * 1103515245 + 12345;
    1a62:	033c87bb          	mulw	a5,s9,s3
    1a66:	012787bb          	addw	a5,a5,s2
    1a6a:	00078c9b          	sext.w	s9,a5
    if((x % 3) == 0){
    1a6e:	0347f7bb          	remuw	a5,a5,s4
    1a72:	dff9                	beqz	a5,1a50 <linkunlink+0x76>
    } else if((x % 3) == 1){
    1a74:	01678663          	beq	a5,s6,1a80 <linkunlink+0xa6>
      unlink("x");
    1a78:	8556                	mv	a0,s5
    1a7a:	2dc030ef          	jal	4d56 <unlink>
    1a7e:	b7c5                	j	1a5e <linkunlink+0x84>
      link("cat", "x");
    1a80:	85d6                	mv	a1,s5
    1a82:	855e                	mv	a0,s7
    1a84:	2e2030ef          	jal	4d66 <link>
    1a88:	bfd9                	j	1a5e <linkunlink+0x84>
  if(pid)
    1a8a:	020c0263          	beqz	s8,1aae <linkunlink+0xd4>
    wait(0);
    1a8e:	4501                	li	a0,0
    1a90:	27e030ef          	jal	4d0e <wait>
}
    1a94:	60e6                	ld	ra,88(sp)
    1a96:	6446                	ld	s0,80(sp)
    1a98:	64a6                	ld	s1,72(sp)
    1a9a:	6906                	ld	s2,64(sp)
    1a9c:	79e2                	ld	s3,56(sp)
    1a9e:	7a42                	ld	s4,48(sp)
    1aa0:	7aa2                	ld	s5,40(sp)
    1aa2:	7b02                	ld	s6,32(sp)
    1aa4:	6be2                	ld	s7,24(sp)
    1aa6:	6c42                	ld	s8,16(sp)
    1aa8:	6ca2                	ld	s9,8(sp)
    1aaa:	6125                	add	sp,sp,96
    1aac:	8082                	ret
    exit(0);
    1aae:	4501                	li	a0,0
    1ab0:	256030ef          	jal	4d06 <exit>

0000000000001ab4 <forktest>:
{
    1ab4:	7179                	add	sp,sp,-48
    1ab6:	f406                	sd	ra,40(sp)
    1ab8:	f022                	sd	s0,32(sp)
    1aba:	ec26                	sd	s1,24(sp)
    1abc:	e84a                	sd	s2,16(sp)
    1abe:	e44e                	sd	s3,8(sp)
    1ac0:	1800                	add	s0,sp,48
    1ac2:	89aa                	mv	s3,a0
  for(n=0; n<N; n++){
    1ac4:	4481                	li	s1,0
    1ac6:	3e800913          	li	s2,1000
    pid = fork();
    1aca:	234030ef          	jal	4cfe <fork>
    if(pid < 0)
    1ace:	02054263          	bltz	a0,1af2 <forktest+0x3e>
    if(pid == 0)
    1ad2:	cd11                	beqz	a0,1aee <forktest+0x3a>
  for(n=0; n<N; n++){
    1ad4:	2485                	addw	s1,s1,1
    1ad6:	ff249ae3          	bne	s1,s2,1aca <forktest+0x16>
    printf("%s: fork claimed to work 1000 times!\n", s);
    1ada:	85ce                	mv	a1,s3
    1adc:	00004517          	auipc	a0,0x4
    1ae0:	34450513          	add	a0,a0,836 # 5e20 <malloc+0xc24>
    1ae4:	664030ef          	jal	5148 <printf>
    exit(1);
    1ae8:	4505                	li	a0,1
    1aea:	21c030ef          	jal	4d06 <exit>
      exit(0);
    1aee:	218030ef          	jal	4d06 <exit>
  if (n == 0) {
    1af2:	c89d                	beqz	s1,1b28 <forktest+0x74>
  if(n == N){
    1af4:	3e800793          	li	a5,1000
    1af8:	fef481e3          	beq	s1,a5,1ada <forktest+0x26>
  for(; n > 0; n--){
    1afc:	00905963          	blez	s1,1b0e <forktest+0x5a>
    if(wait(0) < 0){
    1b00:	4501                	li	a0,0
    1b02:	20c030ef          	jal	4d0e <wait>
    1b06:	02054b63          	bltz	a0,1b3c <forktest+0x88>
  for(; n > 0; n--){
    1b0a:	34fd                	addw	s1,s1,-1
    1b0c:	f8f5                	bnez	s1,1b00 <forktest+0x4c>
  if(wait(0) != -1){
    1b0e:	4501                	li	a0,0
    1b10:	1fe030ef          	jal	4d0e <wait>
    1b14:	57fd                	li	a5,-1
    1b16:	02f51d63          	bne	a0,a5,1b50 <forktest+0x9c>
}
    1b1a:	70a2                	ld	ra,40(sp)
    1b1c:	7402                	ld	s0,32(sp)
    1b1e:	64e2                	ld	s1,24(sp)
    1b20:	6942                	ld	s2,16(sp)
    1b22:	69a2                	ld	s3,8(sp)
    1b24:	6145                	add	sp,sp,48
    1b26:	8082                	ret
    printf("%s: no fork at all!\n", s);
    1b28:	85ce                	mv	a1,s3
    1b2a:	00004517          	auipc	a0,0x4
    1b2e:	2de50513          	add	a0,a0,734 # 5e08 <malloc+0xc0c>
    1b32:	616030ef          	jal	5148 <printf>
    exit(1);
    1b36:	4505                	li	a0,1
    1b38:	1ce030ef          	jal	4d06 <exit>
      printf("%s: wait stopped early\n", s);
    1b3c:	85ce                	mv	a1,s3
    1b3e:	00004517          	auipc	a0,0x4
    1b42:	30a50513          	add	a0,a0,778 # 5e48 <malloc+0xc4c>
    1b46:	602030ef          	jal	5148 <printf>
      exit(1);
    1b4a:	4505                	li	a0,1
    1b4c:	1ba030ef          	jal	4d06 <exit>
    printf("%s: wait got too many\n", s);
    1b50:	85ce                	mv	a1,s3
    1b52:	00004517          	auipc	a0,0x4
    1b56:	30e50513          	add	a0,a0,782 # 5e60 <malloc+0xc64>
    1b5a:	5ee030ef          	jal	5148 <printf>
    exit(1);
    1b5e:	4505                	li	a0,1
    1b60:	1a6030ef          	jal	4d06 <exit>

0000000000001b64 <kernmem>:
{
    1b64:	715d                	add	sp,sp,-80
    1b66:	e486                	sd	ra,72(sp)
    1b68:	e0a2                	sd	s0,64(sp)
    1b6a:	fc26                	sd	s1,56(sp)
    1b6c:	f84a                	sd	s2,48(sp)
    1b6e:	f44e                	sd	s3,40(sp)
    1b70:	f052                	sd	s4,32(sp)
    1b72:	ec56                	sd	s5,24(sp)
    1b74:	0880                	add	s0,sp,80
    1b76:	8a2a                	mv	s4,a0
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    1b78:	4485                	li	s1,1
    1b7a:	04fe                	sll	s1,s1,0x1f
    if(xstatus != -1)  // did kernel kill child?
    1b7c:	5afd                	li	s5,-1
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    1b7e:	69b1                	lui	s3,0xc
    1b80:	35098993          	add	s3,s3,848 # c350 <buf+0x698>
    1b84:	1003d937          	lui	s2,0x1003d
    1b88:	090e                	sll	s2,s2,0x3
    1b8a:	48090913          	add	s2,s2,1152 # 1003d480 <base+0x1002e7c8>
    pid = fork();
    1b8e:	170030ef          	jal	4cfe <fork>
    if(pid < 0){
    1b92:	02054763          	bltz	a0,1bc0 <kernmem+0x5c>
    if(pid == 0){
    1b96:	cd1d                	beqz	a0,1bd4 <kernmem+0x70>
    wait(&xstatus);
    1b98:	fbc40513          	add	a0,s0,-68
    1b9c:	172030ef          	jal	4d0e <wait>
    if(xstatus != -1)  // did kernel kill child?
    1ba0:	fbc42783          	lw	a5,-68(s0)
    1ba4:	05579563          	bne	a5,s5,1bee <kernmem+0x8a>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    1ba8:	94ce                	add	s1,s1,s3
    1baa:	ff2492e3          	bne	s1,s2,1b8e <kernmem+0x2a>
}
    1bae:	60a6                	ld	ra,72(sp)
    1bb0:	6406                	ld	s0,64(sp)
    1bb2:	74e2                	ld	s1,56(sp)
    1bb4:	7942                	ld	s2,48(sp)
    1bb6:	79a2                	ld	s3,40(sp)
    1bb8:	7a02                	ld	s4,32(sp)
    1bba:	6ae2                	ld	s5,24(sp)
    1bbc:	6161                	add	sp,sp,80
    1bbe:	8082                	ret
      printf("%s: fork failed\n", s);
    1bc0:	85d2                	mv	a1,s4
    1bc2:	00004517          	auipc	a0,0x4
    1bc6:	fe650513          	add	a0,a0,-26 # 5ba8 <malloc+0x9ac>
    1bca:	57e030ef          	jal	5148 <printf>
      exit(1);
    1bce:	4505                	li	a0,1
    1bd0:	136030ef          	jal	4d06 <exit>
      printf("%s: oops could read %p = %x\n", s, a, *a);
    1bd4:	0004c683          	lbu	a3,0(s1)
    1bd8:	8626                	mv	a2,s1
    1bda:	85d2                	mv	a1,s4
    1bdc:	00004517          	auipc	a0,0x4
    1be0:	29c50513          	add	a0,a0,668 # 5e78 <malloc+0xc7c>
    1be4:	564030ef          	jal	5148 <printf>
      exit(1);
    1be8:	4505                	li	a0,1
    1bea:	11c030ef          	jal	4d06 <exit>
      exit(1);
    1bee:	4505                	li	a0,1
    1bf0:	116030ef          	jal	4d06 <exit>

0000000000001bf4 <MAXVAplus>:
{
    1bf4:	7179                	add	sp,sp,-48
    1bf6:	f406                	sd	ra,40(sp)
    1bf8:	f022                	sd	s0,32(sp)
    1bfa:	ec26                	sd	s1,24(sp)
    1bfc:	e84a                	sd	s2,16(sp)
    1bfe:	1800                	add	s0,sp,48
  volatile uint64 a = MAXVA;
    1c00:	4785                	li	a5,1
    1c02:	179a                	sll	a5,a5,0x26
    1c04:	fcf43c23          	sd	a5,-40(s0)
  for( ; a != 0; a <<= 1){
    1c08:	fd843783          	ld	a5,-40(s0)
    1c0c:	cb85                	beqz	a5,1c3c <MAXVAplus+0x48>
    1c0e:	892a                	mv	s2,a0
    if(xstatus != -1)  // did kernel kill child?
    1c10:	54fd                	li	s1,-1
    pid = fork();
    1c12:	0ec030ef          	jal	4cfe <fork>
    if(pid < 0){
    1c16:	02054963          	bltz	a0,1c48 <MAXVAplus+0x54>
    if(pid == 0){
    1c1a:	c129                	beqz	a0,1c5c <MAXVAplus+0x68>
    wait(&xstatus);
    1c1c:	fd440513          	add	a0,s0,-44
    1c20:	0ee030ef          	jal	4d0e <wait>
    if(xstatus != -1)  // did kernel kill child?
    1c24:	fd442783          	lw	a5,-44(s0)
    1c28:	04979c63          	bne	a5,s1,1c80 <MAXVAplus+0x8c>
  for( ; a != 0; a <<= 1){
    1c2c:	fd843783          	ld	a5,-40(s0)
    1c30:	0786                	sll	a5,a5,0x1
    1c32:	fcf43c23          	sd	a5,-40(s0)
    1c36:	fd843783          	ld	a5,-40(s0)
    1c3a:	ffe1                	bnez	a5,1c12 <MAXVAplus+0x1e>
}
    1c3c:	70a2                	ld	ra,40(sp)
    1c3e:	7402                	ld	s0,32(sp)
    1c40:	64e2                	ld	s1,24(sp)
    1c42:	6942                	ld	s2,16(sp)
    1c44:	6145                	add	sp,sp,48
    1c46:	8082                	ret
      printf("%s: fork failed\n", s);
    1c48:	85ca                	mv	a1,s2
    1c4a:	00004517          	auipc	a0,0x4
    1c4e:	f5e50513          	add	a0,a0,-162 # 5ba8 <malloc+0x9ac>
    1c52:	4f6030ef          	jal	5148 <printf>
      exit(1);
    1c56:	4505                	li	a0,1
    1c58:	0ae030ef          	jal	4d06 <exit>
      *(char*)a = 99;
    1c5c:	fd843783          	ld	a5,-40(s0)
    1c60:	06300713          	li	a4,99
    1c64:	00e78023          	sb	a4,0(a5)
      printf("%s: oops wrote %p\n", s, (void*)a);
    1c68:	fd843603          	ld	a2,-40(s0)
    1c6c:	85ca                	mv	a1,s2
    1c6e:	00004517          	auipc	a0,0x4
    1c72:	22a50513          	add	a0,a0,554 # 5e98 <malloc+0xc9c>
    1c76:	4d2030ef          	jal	5148 <printf>
      exit(1);
    1c7a:	4505                	li	a0,1
    1c7c:	08a030ef          	jal	4d06 <exit>
      exit(1);
    1c80:	4505                	li	a0,1
    1c82:	084030ef          	jal	4d06 <exit>

0000000000001c86 <stacktest>:
{
    1c86:	7179                	add	sp,sp,-48
    1c88:	f406                	sd	ra,40(sp)
    1c8a:	f022                	sd	s0,32(sp)
    1c8c:	ec26                	sd	s1,24(sp)
    1c8e:	1800                	add	s0,sp,48
    1c90:	84aa                	mv	s1,a0
  pid = fork();
    1c92:	06c030ef          	jal	4cfe <fork>
  if(pid == 0) {
    1c96:	cd11                	beqz	a0,1cb2 <stacktest+0x2c>
  } else if(pid < 0){
    1c98:	02054c63          	bltz	a0,1cd0 <stacktest+0x4a>
  wait(&xstatus);
    1c9c:	fdc40513          	add	a0,s0,-36
    1ca0:	06e030ef          	jal	4d0e <wait>
  if(xstatus == -1)  // kernel killed child?
    1ca4:	fdc42503          	lw	a0,-36(s0)
    1ca8:	57fd                	li	a5,-1
    1caa:	02f50d63          	beq	a0,a5,1ce4 <stacktest+0x5e>
    exit(xstatus);
    1cae:	058030ef          	jal	4d06 <exit>

static inline uint64
r_sp()
{
  uint64 x;
  asm volatile("mv %0, sp" : "=r" (x) );
    1cb2:	870a                	mv	a4,sp
    printf("%s: stacktest: read below stack %d\n", s, *sp);
    1cb4:	77fd                	lui	a5,0xfffff
    1cb6:	97ba                	add	a5,a5,a4
    1cb8:	0007c603          	lbu	a2,0(a5) # fffffffffffff000 <base+0xffffffffffff0348>
    1cbc:	85a6                	mv	a1,s1
    1cbe:	00004517          	auipc	a0,0x4
    1cc2:	1f250513          	add	a0,a0,498 # 5eb0 <malloc+0xcb4>
    1cc6:	482030ef          	jal	5148 <printf>
    exit(1);
    1cca:	4505                	li	a0,1
    1ccc:	03a030ef          	jal	4d06 <exit>
    printf("%s: fork failed\n", s);
    1cd0:	85a6                	mv	a1,s1
    1cd2:	00004517          	auipc	a0,0x4
    1cd6:	ed650513          	add	a0,a0,-298 # 5ba8 <malloc+0x9ac>
    1cda:	46e030ef          	jal	5148 <printf>
    exit(1);
    1cde:	4505                	li	a0,1
    1ce0:	026030ef          	jal	4d06 <exit>
    exit(0);
    1ce4:	4501                	li	a0,0
    1ce6:	020030ef          	jal	4d06 <exit>

0000000000001cea <nowrite>:
{
    1cea:	7159                	add	sp,sp,-112
    1cec:	f486                	sd	ra,104(sp)
    1cee:	f0a2                	sd	s0,96(sp)
    1cf0:	eca6                	sd	s1,88(sp)
    1cf2:	e8ca                	sd	s2,80(sp)
    1cf4:	e4ce                	sd	s3,72(sp)
    1cf6:	1880                	add	s0,sp,112
    1cf8:	89aa                	mv	s3,a0
  uint64 addrs[] = { 0, 0x80000000LL, 0x3fffffe000, 0x3ffffff000, 0x4000000000,
    1cfa:	00006797          	auipc	a5,0x6
    1cfe:	b5e78793          	add	a5,a5,-1186 # 7858 <malloc+0x265c>
    1d02:	7788                	ld	a0,40(a5)
    1d04:	7b8c                	ld	a1,48(a5)
    1d06:	7f90                	ld	a2,56(a5)
    1d08:	63b4                	ld	a3,64(a5)
    1d0a:	67b8                	ld	a4,72(a5)
    1d0c:	6bbc                	ld	a5,80(a5)
    1d0e:	f8a43c23          	sd	a0,-104(s0)
    1d12:	fab43023          	sd	a1,-96(s0)
    1d16:	fac43423          	sd	a2,-88(s0)
    1d1a:	fad43823          	sd	a3,-80(s0)
    1d1e:	fae43c23          	sd	a4,-72(s0)
    1d22:	fcf43023          	sd	a5,-64(s0)
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
    1d26:	4481                	li	s1,0
    1d28:	4919                	li	s2,6
    pid = fork();
    1d2a:	7d5020ef          	jal	4cfe <fork>
    if(pid == 0) {
    1d2e:	c105                	beqz	a0,1d4e <nowrite+0x64>
    } else if(pid < 0){
    1d30:	04054263          	bltz	a0,1d74 <nowrite+0x8a>
    wait(&xstatus);
    1d34:	fcc40513          	add	a0,s0,-52
    1d38:	7d7020ef          	jal	4d0e <wait>
    if(xstatus == 0){
    1d3c:	fcc42783          	lw	a5,-52(s0)
    1d40:	c7a1                	beqz	a5,1d88 <nowrite+0x9e>
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
    1d42:	2485                	addw	s1,s1,1
    1d44:	ff2493e3          	bne	s1,s2,1d2a <nowrite+0x40>
  exit(0);
    1d48:	4501                	li	a0,0
    1d4a:	7bd020ef          	jal	4d06 <exit>
      volatile int *addr = (int *) addrs[ai];
    1d4e:	048e                	sll	s1,s1,0x3
    1d50:	fd048793          	add	a5,s1,-48
    1d54:	008784b3          	add	s1,a5,s0
    1d58:	fc84b603          	ld	a2,-56(s1)
      *addr = 10;
    1d5c:	47a9                	li	a5,10
    1d5e:	c21c                	sw	a5,0(a2)
      printf("%s: write to %p did not fail!\n", s, addr);
    1d60:	85ce                	mv	a1,s3
    1d62:	00004517          	auipc	a0,0x4
    1d66:	17650513          	add	a0,a0,374 # 5ed8 <malloc+0xcdc>
    1d6a:	3de030ef          	jal	5148 <printf>
      exit(0);
    1d6e:	4501                	li	a0,0
    1d70:	797020ef          	jal	4d06 <exit>
      printf("%s: fork failed\n", s);
    1d74:	85ce                	mv	a1,s3
    1d76:	00004517          	auipc	a0,0x4
    1d7a:	e3250513          	add	a0,a0,-462 # 5ba8 <malloc+0x9ac>
    1d7e:	3ca030ef          	jal	5148 <printf>
      exit(1);
    1d82:	4505                	li	a0,1
    1d84:	783020ef          	jal	4d06 <exit>
      exit(1);
    1d88:	4505                	li	a0,1
    1d8a:	77d020ef          	jal	4d06 <exit>

0000000000001d8e <manywrites>:
{
    1d8e:	711d                	add	sp,sp,-96
    1d90:	ec86                	sd	ra,88(sp)
    1d92:	e8a2                	sd	s0,80(sp)
    1d94:	e4a6                	sd	s1,72(sp)
    1d96:	e0ca                	sd	s2,64(sp)
    1d98:	fc4e                	sd	s3,56(sp)
    1d9a:	f852                	sd	s4,48(sp)
    1d9c:	f456                	sd	s5,40(sp)
    1d9e:	f05a                	sd	s6,32(sp)
    1da0:	ec5e                	sd	s7,24(sp)
    1da2:	1080                	add	s0,sp,96
    1da4:	8aaa                	mv	s5,a0
  for(int ci = 0; ci < nchildren; ci++){
    1da6:	4981                	li	s3,0
    1da8:	4911                	li	s2,4
    int pid = fork();
    1daa:	755020ef          	jal	4cfe <fork>
    1dae:	84aa                	mv	s1,a0
    if(pid < 0){
    1db0:	02054563          	bltz	a0,1dda <manywrites+0x4c>
    if(pid == 0){
    1db4:	cd05                	beqz	a0,1dec <manywrites+0x5e>
  for(int ci = 0; ci < nchildren; ci++){
    1db6:	2985                	addw	s3,s3,1
    1db8:	ff2999e3          	bne	s3,s2,1daa <manywrites+0x1c>
    1dbc:	4491                	li	s1,4
    int st = 0;
    1dbe:	fa042423          	sw	zero,-88(s0)
    wait(&st);
    1dc2:	fa840513          	add	a0,s0,-88
    1dc6:	749020ef          	jal	4d0e <wait>
    if(st != 0)
    1dca:	fa842503          	lw	a0,-88(s0)
    1dce:	e169                	bnez	a0,1e90 <manywrites+0x102>
  for(int ci = 0; ci < nchildren; ci++){
    1dd0:	34fd                	addw	s1,s1,-1
    1dd2:	f4f5                	bnez	s1,1dbe <manywrites+0x30>
  exit(0);
    1dd4:	4501                	li	a0,0
    1dd6:	731020ef          	jal	4d06 <exit>
      printf("fork failed\n");
    1dda:	00005517          	auipc	a0,0x5
    1dde:	37650513          	add	a0,a0,886 # 7150 <malloc+0x1f54>
    1de2:	366030ef          	jal	5148 <printf>
      exit(1);
    1de6:	4505                	li	a0,1
    1de8:	71f020ef          	jal	4d06 <exit>
      name[0] = 'b';
    1dec:	06200793          	li	a5,98
    1df0:	faf40423          	sb	a5,-88(s0)
      name[1] = 'a' + ci;
    1df4:	0619879b          	addw	a5,s3,97
    1df8:	faf404a3          	sb	a5,-87(s0)
      name[2] = '\0';
    1dfc:	fa040523          	sb	zero,-86(s0)
      unlink(name);
    1e00:	fa840513          	add	a0,s0,-88
    1e04:	753020ef          	jal	4d56 <unlink>
    1e08:	4bf9                	li	s7,30
          int cc = write(fd, buf, sz);
    1e0a:	0000ab17          	auipc	s6,0xa
    1e0e:	eaeb0b13          	add	s6,s6,-338 # bcb8 <buf>
        for(int i = 0; i < ci+1; i++){
    1e12:	8a26                	mv	s4,s1
    1e14:	0209c863          	bltz	s3,1e44 <manywrites+0xb6>
          int fd = open(name, O_CREATE | O_RDWR);
    1e18:	20200593          	li	a1,514
    1e1c:	fa840513          	add	a0,s0,-88
    1e20:	727020ef          	jal	4d46 <open>
    1e24:	892a                	mv	s2,a0
          if(fd < 0){
    1e26:	02054d63          	bltz	a0,1e60 <manywrites+0xd2>
          int cc = write(fd, buf, sz);
    1e2a:	660d                	lui	a2,0x3
    1e2c:	85da                	mv	a1,s6
    1e2e:	6f9020ef          	jal	4d26 <write>
          if(cc != sz){
    1e32:	678d                	lui	a5,0x3
    1e34:	04f51263          	bne	a0,a5,1e78 <manywrites+0xea>
          close(fd);
    1e38:	854a                	mv	a0,s2
    1e3a:	6f5020ef          	jal	4d2e <close>
        for(int i = 0; i < ci+1; i++){
    1e3e:	2a05                	addw	s4,s4,1
    1e40:	fd49dce3          	bge	s3,s4,1e18 <manywrites+0x8a>
        unlink(name);
    1e44:	fa840513          	add	a0,s0,-88
    1e48:	70f020ef          	jal	4d56 <unlink>
      for(int iters = 0; iters < howmany; iters++){
    1e4c:	3bfd                	addw	s7,s7,-1
    1e4e:	fc0b92e3          	bnez	s7,1e12 <manywrites+0x84>
      unlink(name);
    1e52:	fa840513          	add	a0,s0,-88
    1e56:	701020ef          	jal	4d56 <unlink>
      exit(0);
    1e5a:	4501                	li	a0,0
    1e5c:	6ab020ef          	jal	4d06 <exit>
            printf("%s: cannot create %s\n", s, name);
    1e60:	fa840613          	add	a2,s0,-88
    1e64:	85d6                	mv	a1,s5
    1e66:	00004517          	auipc	a0,0x4
    1e6a:	09250513          	add	a0,a0,146 # 5ef8 <malloc+0xcfc>
    1e6e:	2da030ef          	jal	5148 <printf>
            exit(1);
    1e72:	4505                	li	a0,1
    1e74:	693020ef          	jal	4d06 <exit>
            printf("%s: write(%d) ret %d\n", s, sz, cc);
    1e78:	86aa                	mv	a3,a0
    1e7a:	660d                	lui	a2,0x3
    1e7c:	85d6                	mv	a1,s5
    1e7e:	00003517          	auipc	a0,0x3
    1e82:	56a50513          	add	a0,a0,1386 # 53e8 <malloc+0x1ec>
    1e86:	2c2030ef          	jal	5148 <printf>
            exit(1);
    1e8a:	4505                	li	a0,1
    1e8c:	67b020ef          	jal	4d06 <exit>
      exit(st);
    1e90:	677020ef          	jal	4d06 <exit>

0000000000001e94 <copyinstr3>:
{
    1e94:	7179                	add	sp,sp,-48
    1e96:	f406                	sd	ra,40(sp)
    1e98:	f022                	sd	s0,32(sp)
    1e9a:	ec26                	sd	s1,24(sp)
    1e9c:	1800                	add	s0,sp,48
  sbrk(8192);
    1e9e:	6509                	lui	a0,0x2
    1ea0:	633020ef          	jal	4cd2 <sbrk>
  uint64 top = (uint64) sbrk(0);
    1ea4:	4501                	li	a0,0
    1ea6:	62d020ef          	jal	4cd2 <sbrk>
  if((top % PGSIZE) != 0){
    1eaa:	03451793          	sll	a5,a0,0x34
    1eae:	e7bd                	bnez	a5,1f1c <copyinstr3+0x88>
  top = (uint64) sbrk(0);
    1eb0:	4501                	li	a0,0
    1eb2:	621020ef          	jal	4cd2 <sbrk>
  if(top % PGSIZE){
    1eb6:	03451793          	sll	a5,a0,0x34
    1eba:	ebad                	bnez	a5,1f2c <copyinstr3+0x98>
  char *b = (char *) (top - 1);
    1ebc:	fff50493          	add	s1,a0,-1 # 1fff <rwsbrk+0x67>
  *b = 'x';
    1ec0:	07800793          	li	a5,120
    1ec4:	fef50fa3          	sb	a5,-1(a0)
  int ret = unlink(b);
    1ec8:	8526                	mv	a0,s1
    1eca:	68d020ef          	jal	4d56 <unlink>
  if(ret != -1){
    1ece:	57fd                	li	a5,-1
    1ed0:	06f51763          	bne	a0,a5,1f3e <copyinstr3+0xaa>
  int fd = open(b, O_CREATE | O_WRONLY);
    1ed4:	20100593          	li	a1,513
    1ed8:	8526                	mv	a0,s1
    1eda:	66d020ef          	jal	4d46 <open>
  if(fd != -1){
    1ede:	57fd                	li	a5,-1
    1ee0:	06f51a63          	bne	a0,a5,1f54 <copyinstr3+0xc0>
  ret = link(b, b);
    1ee4:	85a6                	mv	a1,s1
    1ee6:	8526                	mv	a0,s1
    1ee8:	67f020ef          	jal	4d66 <link>
  if(ret != -1){
    1eec:	57fd                	li	a5,-1
    1eee:	06f51e63          	bne	a0,a5,1f6a <copyinstr3+0xd6>
  char *args[] = { "xx", 0 };
    1ef2:	00005797          	auipc	a5,0x5
    1ef6:	d0678793          	add	a5,a5,-762 # 6bf8 <malloc+0x19fc>
    1efa:	fcf43823          	sd	a5,-48(s0)
    1efe:	fc043c23          	sd	zero,-40(s0)
  ret = exec(b, args);
    1f02:	fd040593          	add	a1,s0,-48
    1f06:	8526                	mv	a0,s1
    1f08:	637020ef          	jal	4d3e <exec>
  if(ret != -1){
    1f0c:	57fd                	li	a5,-1
    1f0e:	06f51a63          	bne	a0,a5,1f82 <copyinstr3+0xee>
}
    1f12:	70a2                	ld	ra,40(sp)
    1f14:	7402                	ld	s0,32(sp)
    1f16:	64e2                	ld	s1,24(sp)
    1f18:	6145                	add	sp,sp,48
    1f1a:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    1f1c:	0347d513          	srl	a0,a5,0x34
    1f20:	6785                	lui	a5,0x1
    1f22:	40a7853b          	subw	a0,a5,a0
    1f26:	5ad020ef          	jal	4cd2 <sbrk>
    1f2a:	b759                	j	1eb0 <copyinstr3+0x1c>
    printf("oops\n");
    1f2c:	00004517          	auipc	a0,0x4
    1f30:	fe450513          	add	a0,a0,-28 # 5f10 <malloc+0xd14>
    1f34:	214030ef          	jal	5148 <printf>
    exit(1);
    1f38:	4505                	li	a0,1
    1f3a:	5cd020ef          	jal	4d06 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    1f3e:	862a                	mv	a2,a0
    1f40:	85a6                	mv	a1,s1
    1f42:	00004517          	auipc	a0,0x4
    1f46:	b8650513          	add	a0,a0,-1146 # 5ac8 <malloc+0x8cc>
    1f4a:	1fe030ef          	jal	5148 <printf>
    exit(1);
    1f4e:	4505                	li	a0,1
    1f50:	5b7020ef          	jal	4d06 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    1f54:	862a                	mv	a2,a0
    1f56:	85a6                	mv	a1,s1
    1f58:	00004517          	auipc	a0,0x4
    1f5c:	b9050513          	add	a0,a0,-1136 # 5ae8 <malloc+0x8ec>
    1f60:	1e8030ef          	jal	5148 <printf>
    exit(1);
    1f64:	4505                	li	a0,1
    1f66:	5a1020ef          	jal	4d06 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    1f6a:	86aa                	mv	a3,a0
    1f6c:	8626                	mv	a2,s1
    1f6e:	85a6                	mv	a1,s1
    1f70:	00004517          	auipc	a0,0x4
    1f74:	b9850513          	add	a0,a0,-1128 # 5b08 <malloc+0x90c>
    1f78:	1d0030ef          	jal	5148 <printf>
    exit(1);
    1f7c:	4505                	li	a0,1
    1f7e:	589020ef          	jal	4d06 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    1f82:	567d                	li	a2,-1
    1f84:	85a6                	mv	a1,s1
    1f86:	00004517          	auipc	a0,0x4
    1f8a:	baa50513          	add	a0,a0,-1110 # 5b30 <malloc+0x934>
    1f8e:	1ba030ef          	jal	5148 <printf>
    exit(1);
    1f92:	4505                	li	a0,1
    1f94:	573020ef          	jal	4d06 <exit>

0000000000001f98 <rwsbrk>:
{
    1f98:	1101                	add	sp,sp,-32
    1f9a:	ec06                	sd	ra,24(sp)
    1f9c:	e822                	sd	s0,16(sp)
    1f9e:	e426                	sd	s1,8(sp)
    1fa0:	e04a                	sd	s2,0(sp)
    1fa2:	1000                	add	s0,sp,32
  uint64 a = (uint64) sbrk(8192);
    1fa4:	6509                	lui	a0,0x2
    1fa6:	52d020ef          	jal	4cd2 <sbrk>
  if(a == (uint64) SBRK_ERROR) {
    1faa:	57fd                	li	a5,-1
    1fac:	04f50863          	beq	a0,a5,1ffc <rwsbrk+0x64>
    1fb0:	84aa                	mv	s1,a0
  if (sbrk(-8192) == SBRK_ERROR) {
    1fb2:	7579                	lui	a0,0xffffe
    1fb4:	51f020ef          	jal	4cd2 <sbrk>
    1fb8:	57fd                	li	a5,-1
    1fba:	04f50a63          	beq	a0,a5,200e <rwsbrk+0x76>
  fd = open("rwsbrk", O_CREATE|O_WRONLY);
    1fbe:	20100593          	li	a1,513
    1fc2:	00004517          	auipc	a0,0x4
    1fc6:	f8e50513          	add	a0,a0,-114 # 5f50 <malloc+0xd54>
    1fca:	57d020ef          	jal	4d46 <open>
    1fce:	892a                	mv	s2,a0
  if(fd < 0){
    1fd0:	04054863          	bltz	a0,2020 <rwsbrk+0x88>
  n = write(fd, (void*)(a+PGSIZE), 1024);
    1fd4:	6785                	lui	a5,0x1
    1fd6:	94be                	add	s1,s1,a5
    1fd8:	40000613          	li	a2,1024
    1fdc:	85a6                	mv	a1,s1
    1fde:	549020ef          	jal	4d26 <write>
    1fe2:	862a                	mv	a2,a0
  if(n >= 0){
    1fe4:	04054763          	bltz	a0,2032 <rwsbrk+0x9a>
    printf("write(fd, %p, 1024) returned %d, not -1\n", (void*)a+PGSIZE, n);
    1fe8:	85a6                	mv	a1,s1
    1fea:	00004517          	auipc	a0,0x4
    1fee:	f8650513          	add	a0,a0,-122 # 5f70 <malloc+0xd74>
    1ff2:	156030ef          	jal	5148 <printf>
    exit(1);
    1ff6:	4505                	li	a0,1
    1ff8:	50f020ef          	jal	4d06 <exit>
    printf("sbrk(rwsbrk) failed\n");
    1ffc:	00004517          	auipc	a0,0x4
    2000:	f1c50513          	add	a0,a0,-228 # 5f18 <malloc+0xd1c>
    2004:	144030ef          	jal	5148 <printf>
    exit(1);
    2008:	4505                	li	a0,1
    200a:	4fd020ef          	jal	4d06 <exit>
    printf("sbrk(rwsbrk) shrink failed\n");
    200e:	00004517          	auipc	a0,0x4
    2012:	f2250513          	add	a0,a0,-222 # 5f30 <malloc+0xd34>
    2016:	132030ef          	jal	5148 <printf>
    exit(1);
    201a:	4505                	li	a0,1
    201c:	4eb020ef          	jal	4d06 <exit>
    printf("open(rwsbrk) failed\n");
    2020:	00004517          	auipc	a0,0x4
    2024:	f3850513          	add	a0,a0,-200 # 5f58 <malloc+0xd5c>
    2028:	120030ef          	jal	5148 <printf>
    exit(1);
    202c:	4505                	li	a0,1
    202e:	4d9020ef          	jal	4d06 <exit>
  close(fd);
    2032:	854a                	mv	a0,s2
    2034:	4fb020ef          	jal	4d2e <close>
  unlink("rwsbrk");
    2038:	00004517          	auipc	a0,0x4
    203c:	f1850513          	add	a0,a0,-232 # 5f50 <malloc+0xd54>
    2040:	517020ef          	jal	4d56 <unlink>
  fd = open("README", O_RDONLY);
    2044:	4581                	li	a1,0
    2046:	00003517          	auipc	a0,0x3
    204a:	4aa50513          	add	a0,a0,1194 # 54f0 <malloc+0x2f4>
    204e:	4f9020ef          	jal	4d46 <open>
    2052:	892a                	mv	s2,a0
  if(fd < 0){
    2054:	02054363          	bltz	a0,207a <rwsbrk+0xe2>
  n = read(fd, (void*)(a+PGSIZE), 10);
    2058:	4629                	li	a2,10
    205a:	85a6                	mv	a1,s1
    205c:	4c3020ef          	jal	4d1e <read>
    2060:	862a                	mv	a2,a0
  if(n >= 0){
    2062:	02054563          	bltz	a0,208c <rwsbrk+0xf4>
    printf("read(fd, %p, 10) returned %d, not -1\n", (void*)a+PGSIZE, n);
    2066:	85a6                	mv	a1,s1
    2068:	00004517          	auipc	a0,0x4
    206c:	f3850513          	add	a0,a0,-200 # 5fa0 <malloc+0xda4>
    2070:	0d8030ef          	jal	5148 <printf>
    exit(1);
    2074:	4505                	li	a0,1
    2076:	491020ef          	jal	4d06 <exit>
    printf("open(README) failed\n");
    207a:	00003517          	auipc	a0,0x3
    207e:	47e50513          	add	a0,a0,1150 # 54f8 <malloc+0x2fc>
    2082:	0c6030ef          	jal	5148 <printf>
    exit(1);
    2086:	4505                	li	a0,1
    2088:	47f020ef          	jal	4d06 <exit>
  close(fd);
    208c:	854a                	mv	a0,s2
    208e:	4a1020ef          	jal	4d2e <close>
  exit(0);
    2092:	4501                	li	a0,0
    2094:	473020ef          	jal	4d06 <exit>

0000000000002098 <sbrkbasic>:
{
    2098:	7139                	add	sp,sp,-64
    209a:	fc06                	sd	ra,56(sp)
    209c:	f822                	sd	s0,48(sp)
    209e:	f426                	sd	s1,40(sp)
    20a0:	f04a                	sd	s2,32(sp)
    20a2:	ec4e                	sd	s3,24(sp)
    20a4:	e852                	sd	s4,16(sp)
    20a6:	0080                	add	s0,sp,64
    20a8:	8a2a                	mv	s4,a0
  pid = fork();
    20aa:	455020ef          	jal	4cfe <fork>
  if(pid < 0){
    20ae:	02054863          	bltz	a0,20de <sbrkbasic+0x46>
  if(pid == 0){
    20b2:	e131                	bnez	a0,20f6 <sbrkbasic+0x5e>
    a = sbrk(TOOMUCH);
    20b4:	40000537          	lui	a0,0x40000
    20b8:	41b020ef          	jal	4cd2 <sbrk>
    if(a == (char*)SBRK_ERROR){
    20bc:	57fd                	li	a5,-1
    20be:	02f50963          	beq	a0,a5,20f0 <sbrkbasic+0x58>
    for(b = a; b < a+TOOMUCH; b += PGSIZE){
    20c2:	400007b7          	lui	a5,0x40000
    20c6:	97aa                	add	a5,a5,a0
      *b = 99;
    20c8:	06300693          	li	a3,99
    for(b = a; b < a+TOOMUCH; b += PGSIZE){
    20cc:	6705                	lui	a4,0x1
      *b = 99;
    20ce:	00d50023          	sb	a3,0(a0) # 40000000 <base+0x3fff1348>
    for(b = a; b < a+TOOMUCH; b += PGSIZE){
    20d2:	953a                	add	a0,a0,a4
    20d4:	fef51de3          	bne	a0,a5,20ce <sbrkbasic+0x36>
    exit(1);
    20d8:	4505                	li	a0,1
    20da:	42d020ef          	jal	4d06 <exit>
    printf("fork failed in sbrkbasic\n");
    20de:	00004517          	auipc	a0,0x4
    20e2:	eea50513          	add	a0,a0,-278 # 5fc8 <malloc+0xdcc>
    20e6:	062030ef          	jal	5148 <printf>
    exit(1);
    20ea:	4505                	li	a0,1
    20ec:	41b020ef          	jal	4d06 <exit>
      exit(0);
    20f0:	4501                	li	a0,0
    20f2:	415020ef          	jal	4d06 <exit>
  wait(&xstatus);
    20f6:	fcc40513          	add	a0,s0,-52
    20fa:	415020ef          	jal	4d0e <wait>
  if(xstatus == 1){
    20fe:	fcc42703          	lw	a4,-52(s0)
    2102:	4785                	li	a5,1
    2104:	00f70b63          	beq	a4,a5,211a <sbrkbasic+0x82>
  a = sbrk(0);
    2108:	4501                	li	a0,0
    210a:	3c9020ef          	jal	4cd2 <sbrk>
    210e:	84aa                	mv	s1,a0
  for(i = 0; i < 5000; i++){
    2110:	4901                	li	s2,0
    2112:	6985                	lui	s3,0x1
    2114:	38898993          	add	s3,s3,904 # 1388 <exectest+0x5a>
    2118:	a821                	j	2130 <sbrkbasic+0x98>
    printf("%s: too much memory allocated!\n", s);
    211a:	85d2                	mv	a1,s4
    211c:	00004517          	auipc	a0,0x4
    2120:	ecc50513          	add	a0,a0,-308 # 5fe8 <malloc+0xdec>
    2124:	024030ef          	jal	5148 <printf>
    exit(1);
    2128:	4505                	li	a0,1
    212a:	3dd020ef          	jal	4d06 <exit>
    a = b + 1;
    212e:	84be                	mv	s1,a5
    b = sbrk(1);
    2130:	4505                	li	a0,1
    2132:	3a1020ef          	jal	4cd2 <sbrk>
    if(b != a){
    2136:	04951263          	bne	a0,s1,217a <sbrkbasic+0xe2>
    *b = 1;
    213a:	4785                	li	a5,1
    213c:	00f48023          	sb	a5,0(s1)
    a = b + 1;
    2140:	00148793          	add	a5,s1,1
  for(i = 0; i < 5000; i++){
    2144:	2905                	addw	s2,s2,1
    2146:	ff3914e3          	bne	s2,s3,212e <sbrkbasic+0x96>
  pid = fork();
    214a:	3b5020ef          	jal	4cfe <fork>
    214e:	892a                	mv	s2,a0
  if(pid < 0){
    2150:	04054263          	bltz	a0,2194 <sbrkbasic+0xfc>
  c = sbrk(1);
    2154:	4505                	li	a0,1
    2156:	37d020ef          	jal	4cd2 <sbrk>
  c = sbrk(1);
    215a:	4505                	li	a0,1
    215c:	377020ef          	jal	4cd2 <sbrk>
  if(c != a + 1){
    2160:	0489                	add	s1,s1,2
    2162:	04a48363          	beq	s1,a0,21a8 <sbrkbasic+0x110>
    printf("%s: sbrk test failed post-fork\n", s);
    2166:	85d2                	mv	a1,s4
    2168:	00004517          	auipc	a0,0x4
    216c:	ee050513          	add	a0,a0,-288 # 6048 <malloc+0xe4c>
    2170:	7d9020ef          	jal	5148 <printf>
    exit(1);
    2174:	4505                	li	a0,1
    2176:	391020ef          	jal	4d06 <exit>
      printf("%s: sbrk test failed %d %p %p\n", s, i, a, b);
    217a:	872a                	mv	a4,a0
    217c:	86a6                	mv	a3,s1
    217e:	864a                	mv	a2,s2
    2180:	85d2                	mv	a1,s4
    2182:	00004517          	auipc	a0,0x4
    2186:	e8650513          	add	a0,a0,-378 # 6008 <malloc+0xe0c>
    218a:	7bf020ef          	jal	5148 <printf>
      exit(1);
    218e:	4505                	li	a0,1
    2190:	377020ef          	jal	4d06 <exit>
    printf("%s: sbrk test fork failed\n", s);
    2194:	85d2                	mv	a1,s4
    2196:	00004517          	auipc	a0,0x4
    219a:	e9250513          	add	a0,a0,-366 # 6028 <malloc+0xe2c>
    219e:	7ab020ef          	jal	5148 <printf>
    exit(1);
    21a2:	4505                	li	a0,1
    21a4:	363020ef          	jal	4d06 <exit>
  if(pid == 0)
    21a8:	00091563          	bnez	s2,21b2 <sbrkbasic+0x11a>
    exit(0);
    21ac:	4501                	li	a0,0
    21ae:	359020ef          	jal	4d06 <exit>
  wait(&xstatus);
    21b2:	fcc40513          	add	a0,s0,-52
    21b6:	359020ef          	jal	4d0e <wait>
  exit(xstatus);
    21ba:	fcc42503          	lw	a0,-52(s0)
    21be:	349020ef          	jal	4d06 <exit>

00000000000021c2 <sbrkmuch>:
{
    21c2:	7179                	add	sp,sp,-48
    21c4:	f406                	sd	ra,40(sp)
    21c6:	f022                	sd	s0,32(sp)
    21c8:	ec26                	sd	s1,24(sp)
    21ca:	e84a                	sd	s2,16(sp)
    21cc:	e44e                	sd	s3,8(sp)
    21ce:	e052                	sd	s4,0(sp)
    21d0:	1800                	add	s0,sp,48
    21d2:	89aa                	mv	s3,a0
  oldbrk = sbrk(0);
    21d4:	4501                	li	a0,0
    21d6:	2fd020ef          	jal	4cd2 <sbrk>
    21da:	892a                	mv	s2,a0
  a = sbrk(0);
    21dc:	4501                	li	a0,0
    21de:	2f5020ef          	jal	4cd2 <sbrk>
    21e2:	84aa                	mv	s1,a0
  p = sbrk(amt);
    21e4:	06400537          	lui	a0,0x6400
    21e8:	9d05                	subw	a0,a0,s1
    21ea:	2e9020ef          	jal	4cd2 <sbrk>
  if (p != a) {
    21ee:	08a49763          	bne	s1,a0,227c <sbrkmuch+0xba>
  *lastaddr = 99;
    21f2:	064007b7          	lui	a5,0x6400
    21f6:	06300713          	li	a4,99
    21fa:	fee78fa3          	sb	a4,-1(a5) # 63fffff <base+0x63f1347>
  a = sbrk(0);
    21fe:	4501                	li	a0,0
    2200:	2d3020ef          	jal	4cd2 <sbrk>
    2204:	84aa                	mv	s1,a0
  c = sbrk(-PGSIZE);
    2206:	757d                	lui	a0,0xfffff
    2208:	2cb020ef          	jal	4cd2 <sbrk>
  if(c == (char*)SBRK_ERROR){
    220c:	57fd                	li	a5,-1
    220e:	08f50163          	beq	a0,a5,2290 <sbrkmuch+0xce>
  c = sbrk(0);
    2212:	4501                	li	a0,0
    2214:	2bf020ef          	jal	4cd2 <sbrk>
  if(c != a - PGSIZE){
    2218:	77fd                	lui	a5,0xfffff
    221a:	97a6                	add	a5,a5,s1
    221c:	08f51463          	bne	a0,a5,22a4 <sbrkmuch+0xe2>
  a = sbrk(0);
    2220:	4501                	li	a0,0
    2222:	2b1020ef          	jal	4cd2 <sbrk>
    2226:	84aa                	mv	s1,a0
  c = sbrk(PGSIZE);
    2228:	6505                	lui	a0,0x1
    222a:	2a9020ef          	jal	4cd2 <sbrk>
    222e:	8a2a                	mv	s4,a0
  if(c != a || sbrk(0) != a + PGSIZE){
    2230:	08a49663          	bne	s1,a0,22bc <sbrkmuch+0xfa>
    2234:	4501                	li	a0,0
    2236:	29d020ef          	jal	4cd2 <sbrk>
    223a:	6785                	lui	a5,0x1
    223c:	97a6                	add	a5,a5,s1
    223e:	06f51f63          	bne	a0,a5,22bc <sbrkmuch+0xfa>
  if(*lastaddr == 99){
    2242:	064007b7          	lui	a5,0x6400
    2246:	fff7c703          	lbu	a4,-1(a5) # 63fffff <base+0x63f1347>
    224a:	06300793          	li	a5,99
    224e:	08f70363          	beq	a4,a5,22d4 <sbrkmuch+0x112>
  a = sbrk(0);
    2252:	4501                	li	a0,0
    2254:	27f020ef          	jal	4cd2 <sbrk>
    2258:	84aa                	mv	s1,a0
  c = sbrk(-(sbrk(0) - oldbrk));
    225a:	4501                	li	a0,0
    225c:	277020ef          	jal	4cd2 <sbrk>
    2260:	40a9053b          	subw	a0,s2,a0
    2264:	26f020ef          	jal	4cd2 <sbrk>
  if(c != a){
    2268:	08a49063          	bne	s1,a0,22e8 <sbrkmuch+0x126>
}
    226c:	70a2                	ld	ra,40(sp)
    226e:	7402                	ld	s0,32(sp)
    2270:	64e2                	ld	s1,24(sp)
    2272:	6942                	ld	s2,16(sp)
    2274:	69a2                	ld	s3,8(sp)
    2276:	6a02                	ld	s4,0(sp)
    2278:	6145                	add	sp,sp,48
    227a:	8082                	ret
    printf("%s: sbrk test failed to grow big address space; enough phys mem?\n", s);
    227c:	85ce                	mv	a1,s3
    227e:	00004517          	auipc	a0,0x4
    2282:	dea50513          	add	a0,a0,-534 # 6068 <malloc+0xe6c>
    2286:	6c3020ef          	jal	5148 <printf>
    exit(1);
    228a:	4505                	li	a0,1
    228c:	27b020ef          	jal	4d06 <exit>
    printf("%s: sbrk could not deallocate\n", s);
    2290:	85ce                	mv	a1,s3
    2292:	00004517          	auipc	a0,0x4
    2296:	e1e50513          	add	a0,a0,-482 # 60b0 <malloc+0xeb4>
    229a:	6af020ef          	jal	5148 <printf>
    exit(1);
    229e:	4505                	li	a0,1
    22a0:	267020ef          	jal	4d06 <exit>
    printf("%s: sbrk deallocation produced wrong address, a %p c %p\n", s, a, c);
    22a4:	86aa                	mv	a3,a0
    22a6:	8626                	mv	a2,s1
    22a8:	85ce                	mv	a1,s3
    22aa:	00004517          	auipc	a0,0x4
    22ae:	e2650513          	add	a0,a0,-474 # 60d0 <malloc+0xed4>
    22b2:	697020ef          	jal	5148 <printf>
    exit(1);
    22b6:	4505                	li	a0,1
    22b8:	24f020ef          	jal	4d06 <exit>
    printf("%s: sbrk re-allocation failed, a %p c %p\n", s, a, c);
    22bc:	86d2                	mv	a3,s4
    22be:	8626                	mv	a2,s1
    22c0:	85ce                	mv	a1,s3
    22c2:	00004517          	auipc	a0,0x4
    22c6:	e4e50513          	add	a0,a0,-434 # 6110 <malloc+0xf14>
    22ca:	67f020ef          	jal	5148 <printf>
    exit(1);
    22ce:	4505                	li	a0,1
    22d0:	237020ef          	jal	4d06 <exit>
    printf("%s: sbrk de-allocation didn't really deallocate\n", s);
    22d4:	85ce                	mv	a1,s3
    22d6:	00004517          	auipc	a0,0x4
    22da:	e6a50513          	add	a0,a0,-406 # 6140 <malloc+0xf44>
    22de:	66b020ef          	jal	5148 <printf>
    exit(1);
    22e2:	4505                	li	a0,1
    22e4:	223020ef          	jal	4d06 <exit>
    printf("%s: sbrk downsize failed, a %p c %p\n", s, a, c);
    22e8:	86aa                	mv	a3,a0
    22ea:	8626                	mv	a2,s1
    22ec:	85ce                	mv	a1,s3
    22ee:	00004517          	auipc	a0,0x4
    22f2:	e8a50513          	add	a0,a0,-374 # 6178 <malloc+0xf7c>
    22f6:	653020ef          	jal	5148 <printf>
    exit(1);
    22fa:	4505                	li	a0,1
    22fc:	20b020ef          	jal	4d06 <exit>

0000000000002300 <sbrkarg>:
{
    2300:	7179                	add	sp,sp,-48
    2302:	f406                	sd	ra,40(sp)
    2304:	f022                	sd	s0,32(sp)
    2306:	ec26                	sd	s1,24(sp)
    2308:	e84a                	sd	s2,16(sp)
    230a:	e44e                	sd	s3,8(sp)
    230c:	1800                	add	s0,sp,48
    230e:	89aa                	mv	s3,a0
  a = sbrk(PGSIZE);
    2310:	6505                	lui	a0,0x1
    2312:	1c1020ef          	jal	4cd2 <sbrk>
    2316:	892a                	mv	s2,a0
  fd = open("sbrk", O_CREATE|O_WRONLY);
    2318:	20100593          	li	a1,513
    231c:	00004517          	auipc	a0,0x4
    2320:	e8450513          	add	a0,a0,-380 # 61a0 <malloc+0xfa4>
    2324:	223020ef          	jal	4d46 <open>
    2328:	84aa                	mv	s1,a0
  unlink("sbrk");
    232a:	00004517          	auipc	a0,0x4
    232e:	e7650513          	add	a0,a0,-394 # 61a0 <malloc+0xfa4>
    2332:	225020ef          	jal	4d56 <unlink>
  if(fd < 0)  {
    2336:	0204c963          	bltz	s1,2368 <sbrkarg+0x68>
  if ((n = write(fd, a, PGSIZE)) < 0) {
    233a:	6605                	lui	a2,0x1
    233c:	85ca                	mv	a1,s2
    233e:	8526                	mv	a0,s1
    2340:	1e7020ef          	jal	4d26 <write>
    2344:	02054c63          	bltz	a0,237c <sbrkarg+0x7c>
  close(fd);
    2348:	8526                	mv	a0,s1
    234a:	1e5020ef          	jal	4d2e <close>
  a = sbrk(PGSIZE);
    234e:	6505                	lui	a0,0x1
    2350:	183020ef          	jal	4cd2 <sbrk>
  if(pipe((int *) a) != 0){
    2354:	1c3020ef          	jal	4d16 <pipe>
    2358:	ed05                	bnez	a0,2390 <sbrkarg+0x90>
}
    235a:	70a2                	ld	ra,40(sp)
    235c:	7402                	ld	s0,32(sp)
    235e:	64e2                	ld	s1,24(sp)
    2360:	6942                	ld	s2,16(sp)
    2362:	69a2                	ld	s3,8(sp)
    2364:	6145                	add	sp,sp,48
    2366:	8082                	ret
    printf("%s: open sbrk failed\n", s);
    2368:	85ce                	mv	a1,s3
    236a:	00004517          	auipc	a0,0x4
    236e:	e3e50513          	add	a0,a0,-450 # 61a8 <malloc+0xfac>
    2372:	5d7020ef          	jal	5148 <printf>
    exit(1);
    2376:	4505                	li	a0,1
    2378:	18f020ef          	jal	4d06 <exit>
    printf("%s: write sbrk failed\n", s);
    237c:	85ce                	mv	a1,s3
    237e:	00004517          	auipc	a0,0x4
    2382:	e4250513          	add	a0,a0,-446 # 61c0 <malloc+0xfc4>
    2386:	5c3020ef          	jal	5148 <printf>
    exit(1);
    238a:	4505                	li	a0,1
    238c:	17b020ef          	jal	4d06 <exit>
    printf("%s: pipe() failed\n", s);
    2390:	85ce                	mv	a1,s3
    2392:	00004517          	auipc	a0,0x4
    2396:	91e50513          	add	a0,a0,-1762 # 5cb0 <malloc+0xab4>
    239a:	5af020ef          	jal	5148 <printf>
    exit(1);
    239e:	4505                	li	a0,1
    23a0:	167020ef          	jal	4d06 <exit>

00000000000023a4 <argptest>:
{
    23a4:	1101                	add	sp,sp,-32
    23a6:	ec06                	sd	ra,24(sp)
    23a8:	e822                	sd	s0,16(sp)
    23aa:	e426                	sd	s1,8(sp)
    23ac:	e04a                	sd	s2,0(sp)
    23ae:	1000                	add	s0,sp,32
    23b0:	892a                	mv	s2,a0
  fd = open("init", O_RDONLY);
    23b2:	4581                	li	a1,0
    23b4:	00004517          	auipc	a0,0x4
    23b8:	e2450513          	add	a0,a0,-476 # 61d8 <malloc+0xfdc>
    23bc:	18b020ef          	jal	4d46 <open>
  if (fd < 0) {
    23c0:	02054563          	bltz	a0,23ea <argptest+0x46>
    23c4:	84aa                	mv	s1,a0
  read(fd, sbrk(0) - 1, -1);
    23c6:	4501                	li	a0,0
    23c8:	10b020ef          	jal	4cd2 <sbrk>
    23cc:	567d                	li	a2,-1
    23ce:	fff50593          	add	a1,a0,-1
    23d2:	8526                	mv	a0,s1
    23d4:	14b020ef          	jal	4d1e <read>
  close(fd);
    23d8:	8526                	mv	a0,s1
    23da:	155020ef          	jal	4d2e <close>
}
    23de:	60e2                	ld	ra,24(sp)
    23e0:	6442                	ld	s0,16(sp)
    23e2:	64a2                	ld	s1,8(sp)
    23e4:	6902                	ld	s2,0(sp)
    23e6:	6105                	add	sp,sp,32
    23e8:	8082                	ret
    printf("%s: open failed\n", s);
    23ea:	85ca                	mv	a1,s2
    23ec:	00003517          	auipc	a0,0x3
    23f0:	7d450513          	add	a0,a0,2004 # 5bc0 <malloc+0x9c4>
    23f4:	555020ef          	jal	5148 <printf>
    exit(1);
    23f8:	4505                	li	a0,1
    23fa:	10d020ef          	jal	4d06 <exit>

00000000000023fe <sbrkbugs>:
{
    23fe:	1141                	add	sp,sp,-16
    2400:	e406                	sd	ra,8(sp)
    2402:	e022                	sd	s0,0(sp)
    2404:	0800                	add	s0,sp,16
  int pid = fork();
    2406:	0f9020ef          	jal	4cfe <fork>
  if(pid < 0){
    240a:	00054c63          	bltz	a0,2422 <sbrkbugs+0x24>
  if(pid == 0){
    240e:	e11d                	bnez	a0,2434 <sbrkbugs+0x36>
    int sz = (uint64) sbrk(0);
    2410:	0c3020ef          	jal	4cd2 <sbrk>
    sbrk(-sz);
    2414:	40a0053b          	negw	a0,a0
    2418:	0bb020ef          	jal	4cd2 <sbrk>
    exit(0);
    241c:	4501                	li	a0,0
    241e:	0e9020ef          	jal	4d06 <exit>
    printf("fork failed\n");
    2422:	00005517          	auipc	a0,0x5
    2426:	d2e50513          	add	a0,a0,-722 # 7150 <malloc+0x1f54>
    242a:	51f020ef          	jal	5148 <printf>
    exit(1);
    242e:	4505                	li	a0,1
    2430:	0d7020ef          	jal	4d06 <exit>
  wait(0);
    2434:	4501                	li	a0,0
    2436:	0d9020ef          	jal	4d0e <wait>
  pid = fork();
    243a:	0c5020ef          	jal	4cfe <fork>
  if(pid < 0){
    243e:	00054f63          	bltz	a0,245c <sbrkbugs+0x5e>
  if(pid == 0){
    2442:	e515                	bnez	a0,246e <sbrkbugs+0x70>
    int sz = (uint64) sbrk(0);
    2444:	08f020ef          	jal	4cd2 <sbrk>
    sbrk(-(sz - 3500));
    2448:	6785                	lui	a5,0x1
    244a:	dac7879b          	addw	a5,a5,-596 # dac <linktest+0x138>
    244e:	40a7853b          	subw	a0,a5,a0
    2452:	081020ef          	jal	4cd2 <sbrk>
    exit(0);
    2456:	4501                	li	a0,0
    2458:	0af020ef          	jal	4d06 <exit>
    printf("fork failed\n");
    245c:	00005517          	auipc	a0,0x5
    2460:	cf450513          	add	a0,a0,-780 # 7150 <malloc+0x1f54>
    2464:	4e5020ef          	jal	5148 <printf>
    exit(1);
    2468:	4505                	li	a0,1
    246a:	09d020ef          	jal	4d06 <exit>
  wait(0);
    246e:	4501                	li	a0,0
    2470:	09f020ef          	jal	4d0e <wait>
  pid = fork();
    2474:	08b020ef          	jal	4cfe <fork>
  if(pid < 0){
    2478:	02054263          	bltz	a0,249c <sbrkbugs+0x9e>
  if(pid == 0){
    247c:	e90d                	bnez	a0,24ae <sbrkbugs+0xb0>
    sbrk((10*PGSIZE + 2048) - (uint64)sbrk(0));
    247e:	055020ef          	jal	4cd2 <sbrk>
    2482:	67ad                	lui	a5,0xb
    2484:	8007879b          	addw	a5,a5,-2048 # a800 <uninit+0x1258>
    2488:	40a7853b          	subw	a0,a5,a0
    248c:	047020ef          	jal	4cd2 <sbrk>
    sbrk(-10);
    2490:	5559                	li	a0,-10
    2492:	041020ef          	jal	4cd2 <sbrk>
    exit(0);
    2496:	4501                	li	a0,0
    2498:	06f020ef          	jal	4d06 <exit>
    printf("fork failed\n");
    249c:	00005517          	auipc	a0,0x5
    24a0:	cb450513          	add	a0,a0,-844 # 7150 <malloc+0x1f54>
    24a4:	4a5020ef          	jal	5148 <printf>
    exit(1);
    24a8:	4505                	li	a0,1
    24aa:	05d020ef          	jal	4d06 <exit>
  wait(0);
    24ae:	4501                	li	a0,0
    24b0:	05f020ef          	jal	4d0e <wait>
  exit(0);
    24b4:	4501                	li	a0,0
    24b6:	051020ef          	jal	4d06 <exit>

00000000000024ba <sbrklast>:
{
    24ba:	7179                	add	sp,sp,-48
    24bc:	f406                	sd	ra,40(sp)
    24be:	f022                	sd	s0,32(sp)
    24c0:	ec26                	sd	s1,24(sp)
    24c2:	e84a                	sd	s2,16(sp)
    24c4:	e44e                	sd	s3,8(sp)
    24c6:	e052                	sd	s4,0(sp)
    24c8:	1800                	add	s0,sp,48
  uint64 top = (uint64) sbrk(0);
    24ca:	4501                	li	a0,0
    24cc:	007020ef          	jal	4cd2 <sbrk>
  if((top % PGSIZE) != 0)
    24d0:	03451793          	sll	a5,a0,0x34
    24d4:	ebad                	bnez	a5,2546 <sbrklast+0x8c>
  sbrk(PGSIZE);
    24d6:	6505                	lui	a0,0x1
    24d8:	7fa020ef          	jal	4cd2 <sbrk>
  sbrk(10);
    24dc:	4529                	li	a0,10
    24de:	7f4020ef          	jal	4cd2 <sbrk>
  sbrk(-20);
    24e2:	5531                	li	a0,-20
    24e4:	7ee020ef          	jal	4cd2 <sbrk>
  top = (uint64) sbrk(0);
    24e8:	4501                	li	a0,0
    24ea:	7e8020ef          	jal	4cd2 <sbrk>
    24ee:	84aa                	mv	s1,a0
  char *p = (char *) (top - 64);
    24f0:	fc050913          	add	s2,a0,-64 # fc0 <bigdir+0x122>
  p[0] = 'x';
    24f4:	07800a13          	li	s4,120
    24f8:	fd450023          	sb	s4,-64(a0)
  p[1] = '\0';
    24fc:	fc0500a3          	sb	zero,-63(a0)
  int fd = open(p, O_RDWR|O_CREATE);
    2500:	20200593          	li	a1,514
    2504:	854a                	mv	a0,s2
    2506:	041020ef          	jal	4d46 <open>
    250a:	89aa                	mv	s3,a0
  write(fd, p, 1);
    250c:	4605                	li	a2,1
    250e:	85ca                	mv	a1,s2
    2510:	017020ef          	jal	4d26 <write>
  close(fd);
    2514:	854e                	mv	a0,s3
    2516:	019020ef          	jal	4d2e <close>
  fd = open(p, O_RDWR);
    251a:	4589                	li	a1,2
    251c:	854a                	mv	a0,s2
    251e:	029020ef          	jal	4d46 <open>
  p[0] = '\0';
    2522:	fc048023          	sb	zero,-64(s1)
  read(fd, p, 1);
    2526:	4605                	li	a2,1
    2528:	85ca                	mv	a1,s2
    252a:	7f4020ef          	jal	4d1e <read>
  if(p[0] != 'x')
    252e:	fc04c783          	lbu	a5,-64(s1)
    2532:	03479263          	bne	a5,s4,2556 <sbrklast+0x9c>
}
    2536:	70a2                	ld	ra,40(sp)
    2538:	7402                	ld	s0,32(sp)
    253a:	64e2                	ld	s1,24(sp)
    253c:	6942                	ld	s2,16(sp)
    253e:	69a2                	ld	s3,8(sp)
    2540:	6a02                	ld	s4,0(sp)
    2542:	6145                	add	sp,sp,48
    2544:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    2546:	0347d513          	srl	a0,a5,0x34
    254a:	6785                	lui	a5,0x1
    254c:	40a7853b          	subw	a0,a5,a0
    2550:	782020ef          	jal	4cd2 <sbrk>
    2554:	b749                	j	24d6 <sbrklast+0x1c>
    exit(1);
    2556:	4505                	li	a0,1
    2558:	7ae020ef          	jal	4d06 <exit>

000000000000255c <sbrk8000>:
{
    255c:	1141                	add	sp,sp,-16
    255e:	e406                	sd	ra,8(sp)
    2560:	e022                	sd	s0,0(sp)
    2562:	0800                	add	s0,sp,16
  sbrk(0x80000004);
    2564:	80000537          	lui	a0,0x80000
    2568:	0511                	add	a0,a0,4 # ffffffff80000004 <base+0xffffffff7fff134c>
    256a:	768020ef          	jal	4cd2 <sbrk>
  volatile char *top = sbrk(0);
    256e:	4501                	li	a0,0
    2570:	762020ef          	jal	4cd2 <sbrk>
  *(top-1) = *(top-1) + 1;
    2574:	fff54783          	lbu	a5,-1(a0)
    2578:	2785                	addw	a5,a5,1 # 1001 <badarg+0x1>
    257a:	0ff7f793          	zext.b	a5,a5
    257e:	fef50fa3          	sb	a5,-1(a0)
}
    2582:	60a2                	ld	ra,8(sp)
    2584:	6402                	ld	s0,0(sp)
    2586:	0141                	add	sp,sp,16
    2588:	8082                	ret

000000000000258a <execout>:
{
    258a:	715d                	add	sp,sp,-80
    258c:	e486                	sd	ra,72(sp)
    258e:	e0a2                	sd	s0,64(sp)
    2590:	fc26                	sd	s1,56(sp)
    2592:	f84a                	sd	s2,48(sp)
    2594:	f44e                	sd	s3,40(sp)
    2596:	f052                	sd	s4,32(sp)
    2598:	0880                	add	s0,sp,80
  for(int avail = 0; avail < 15; avail++){
    259a:	4901                	li	s2,0
    259c:	49bd                	li	s3,15
    int pid = fork();
    259e:	760020ef          	jal	4cfe <fork>
    25a2:	84aa                	mv	s1,a0
    if(pid < 0){
    25a4:	00054c63          	bltz	a0,25bc <execout+0x32>
    } else if(pid == 0){
    25a8:	c11d                	beqz	a0,25ce <execout+0x44>
      wait((int*)0);
    25aa:	4501                	li	a0,0
    25ac:	762020ef          	jal	4d0e <wait>
  for(int avail = 0; avail < 15; avail++){
    25b0:	2905                	addw	s2,s2,1
    25b2:	ff3916e3          	bne	s2,s3,259e <execout+0x14>
  exit(0);
    25b6:	4501                	li	a0,0
    25b8:	74e020ef          	jal	4d06 <exit>
      printf("fork failed\n");
    25bc:	00005517          	auipc	a0,0x5
    25c0:	b9450513          	add	a0,a0,-1132 # 7150 <malloc+0x1f54>
    25c4:	385020ef          	jal	5148 <printf>
      exit(1);
    25c8:	4505                	li	a0,1
    25ca:	73c020ef          	jal	4d06 <exit>
        if(a == SBRK_ERROR)
    25ce:	59fd                	li	s3,-1
        *(a + PGSIZE - 1) = 1;
    25d0:	4a05                	li	s4,1
        char *a = sbrk(PGSIZE);
    25d2:	6505                	lui	a0,0x1
    25d4:	6fe020ef          	jal	4cd2 <sbrk>
        if(a == SBRK_ERROR)
    25d8:	01350763          	beq	a0,s3,25e6 <execout+0x5c>
        *(a + PGSIZE - 1) = 1;
    25dc:	6785                	lui	a5,0x1
    25de:	953e                	add	a0,a0,a5
    25e0:	ff450fa3          	sb	s4,-1(a0) # fff <pgbug+0x2b>
      while(1){
    25e4:	b7fd                	j	25d2 <execout+0x48>
      for(int i = 0; i < avail; i++)
    25e6:	01205863          	blez	s2,25f6 <execout+0x6c>
        sbrk(-PGSIZE);
    25ea:	757d                	lui	a0,0xfffff
    25ec:	6e6020ef          	jal	4cd2 <sbrk>
      for(int i = 0; i < avail; i++)
    25f0:	2485                	addw	s1,s1,1
    25f2:	ff249ce3          	bne	s1,s2,25ea <execout+0x60>
      close(1);
    25f6:	4505                	li	a0,1
    25f8:	736020ef          	jal	4d2e <close>
      char *args[] = { "echo", "x", 0 };
    25fc:	00003517          	auipc	a0,0x3
    2600:	d1c50513          	add	a0,a0,-740 # 5318 <malloc+0x11c>
    2604:	faa43c23          	sd	a0,-72(s0)
    2608:	00003797          	auipc	a5,0x3
    260c:	d8078793          	add	a5,a5,-640 # 5388 <malloc+0x18c>
    2610:	fcf43023          	sd	a5,-64(s0)
    2614:	fc043423          	sd	zero,-56(s0)
      exec("echo", args);
    2618:	fb840593          	add	a1,s0,-72
    261c:	722020ef          	jal	4d3e <exec>
      exit(0);
    2620:	4501                	li	a0,0
    2622:	6e4020ef          	jal	4d06 <exit>

0000000000002626 <fourteen>:
{
    2626:	1101                	add	sp,sp,-32
    2628:	ec06                	sd	ra,24(sp)
    262a:	e822                	sd	s0,16(sp)
    262c:	e426                	sd	s1,8(sp)
    262e:	1000                	add	s0,sp,32
    2630:	84aa                	mv	s1,a0
  if(mkdir("12345678901234") != 0){
    2632:	00004517          	auipc	a0,0x4
    2636:	d7e50513          	add	a0,a0,-642 # 63b0 <malloc+0x11b4>
    263a:	734020ef          	jal	4d6e <mkdir>
    263e:	e555                	bnez	a0,26ea <fourteen+0xc4>
  if(mkdir("12345678901234/123456789012345") != 0){
    2640:	00004517          	auipc	a0,0x4
    2644:	bc850513          	add	a0,a0,-1080 # 6208 <malloc+0x100c>
    2648:	726020ef          	jal	4d6e <mkdir>
    264c:	e94d                	bnez	a0,26fe <fourteen+0xd8>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    264e:	20000593          	li	a1,512
    2652:	00004517          	auipc	a0,0x4
    2656:	c0e50513          	add	a0,a0,-1010 # 6260 <malloc+0x1064>
    265a:	6ec020ef          	jal	4d46 <open>
  if(fd < 0){
    265e:	0a054a63          	bltz	a0,2712 <fourteen+0xec>
  close(fd);
    2662:	6cc020ef          	jal	4d2e <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    2666:	4581                	li	a1,0
    2668:	00004517          	auipc	a0,0x4
    266c:	c7050513          	add	a0,a0,-912 # 62d8 <malloc+0x10dc>
    2670:	6d6020ef          	jal	4d46 <open>
  if(fd < 0){
    2674:	0a054963          	bltz	a0,2726 <fourteen+0x100>
  close(fd);
    2678:	6b6020ef          	jal	4d2e <close>
  if(mkdir("12345678901234/12345678901234") == 0){
    267c:	00004517          	auipc	a0,0x4
    2680:	ccc50513          	add	a0,a0,-820 # 6348 <malloc+0x114c>
    2684:	6ea020ef          	jal	4d6e <mkdir>
    2688:	c94d                	beqz	a0,273a <fourteen+0x114>
  if(mkdir("123456789012345/12345678901234") == 0){
    268a:	00004517          	auipc	a0,0x4
    268e:	d1650513          	add	a0,a0,-746 # 63a0 <malloc+0x11a4>
    2692:	6dc020ef          	jal	4d6e <mkdir>
    2696:	cd45                	beqz	a0,274e <fourteen+0x128>
  unlink("123456789012345/12345678901234");
    2698:	00004517          	auipc	a0,0x4
    269c:	d0850513          	add	a0,a0,-760 # 63a0 <malloc+0x11a4>
    26a0:	6b6020ef          	jal	4d56 <unlink>
  unlink("12345678901234/12345678901234");
    26a4:	00004517          	auipc	a0,0x4
    26a8:	ca450513          	add	a0,a0,-860 # 6348 <malloc+0x114c>
    26ac:	6aa020ef          	jal	4d56 <unlink>
  unlink("12345678901234/12345678901234/12345678901234");
    26b0:	00004517          	auipc	a0,0x4
    26b4:	c2850513          	add	a0,a0,-984 # 62d8 <malloc+0x10dc>
    26b8:	69e020ef          	jal	4d56 <unlink>
  unlink("123456789012345/123456789012345/123456789012345");
    26bc:	00004517          	auipc	a0,0x4
    26c0:	ba450513          	add	a0,a0,-1116 # 6260 <malloc+0x1064>
    26c4:	692020ef          	jal	4d56 <unlink>
  unlink("12345678901234/123456789012345");
    26c8:	00004517          	auipc	a0,0x4
    26cc:	b4050513          	add	a0,a0,-1216 # 6208 <malloc+0x100c>
    26d0:	686020ef          	jal	4d56 <unlink>
  unlink("12345678901234");
    26d4:	00004517          	auipc	a0,0x4
    26d8:	cdc50513          	add	a0,a0,-804 # 63b0 <malloc+0x11b4>
    26dc:	67a020ef          	jal	4d56 <unlink>
}
    26e0:	60e2                	ld	ra,24(sp)
    26e2:	6442                	ld	s0,16(sp)
    26e4:	64a2                	ld	s1,8(sp)
    26e6:	6105                	add	sp,sp,32
    26e8:	8082                	ret
    printf("%s: mkdir 12345678901234 failed\n", s);
    26ea:	85a6                	mv	a1,s1
    26ec:	00004517          	auipc	a0,0x4
    26f0:	af450513          	add	a0,a0,-1292 # 61e0 <malloc+0xfe4>
    26f4:	255020ef          	jal	5148 <printf>
    exit(1);
    26f8:	4505                	li	a0,1
    26fa:	60c020ef          	jal	4d06 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 failed\n", s);
    26fe:	85a6                	mv	a1,s1
    2700:	00004517          	auipc	a0,0x4
    2704:	b2850513          	add	a0,a0,-1240 # 6228 <malloc+0x102c>
    2708:	241020ef          	jal	5148 <printf>
    exit(1);
    270c:	4505                	li	a0,1
    270e:	5f8020ef          	jal	4d06 <exit>
    printf("%s: create 123456789012345/123456789012345/123456789012345 failed\n", s);
    2712:	85a6                	mv	a1,s1
    2714:	00004517          	auipc	a0,0x4
    2718:	b7c50513          	add	a0,a0,-1156 # 6290 <malloc+0x1094>
    271c:	22d020ef          	jal	5148 <printf>
    exit(1);
    2720:	4505                	li	a0,1
    2722:	5e4020ef          	jal	4d06 <exit>
    printf("%s: open 12345678901234/12345678901234/12345678901234 failed\n", s);
    2726:	85a6                	mv	a1,s1
    2728:	00004517          	auipc	a0,0x4
    272c:	be050513          	add	a0,a0,-1056 # 6308 <malloc+0x110c>
    2730:	219020ef          	jal	5148 <printf>
    exit(1);
    2734:	4505                	li	a0,1
    2736:	5d0020ef          	jal	4d06 <exit>
    printf("%s: mkdir 12345678901234/12345678901234 succeeded!\n", s);
    273a:	85a6                	mv	a1,s1
    273c:	00004517          	auipc	a0,0x4
    2740:	c2c50513          	add	a0,a0,-980 # 6368 <malloc+0x116c>
    2744:	205020ef          	jal	5148 <printf>
    exit(1);
    2748:	4505                	li	a0,1
    274a:	5bc020ef          	jal	4d06 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 succeeded!\n", s);
    274e:	85a6                	mv	a1,s1
    2750:	00004517          	auipc	a0,0x4
    2754:	c7050513          	add	a0,a0,-912 # 63c0 <malloc+0x11c4>
    2758:	1f1020ef          	jal	5148 <printf>
    exit(1);
    275c:	4505                	li	a0,1
    275e:	5a8020ef          	jal	4d06 <exit>

0000000000002762 <diskfull>:
{
    2762:	b8010113          	add	sp,sp,-1152
    2766:	46113c23          	sd	ra,1144(sp)
    276a:	46813823          	sd	s0,1136(sp)
    276e:	46913423          	sd	s1,1128(sp)
    2772:	47213023          	sd	s2,1120(sp)
    2776:	45313c23          	sd	s3,1112(sp)
    277a:	45413823          	sd	s4,1104(sp)
    277e:	45513423          	sd	s5,1096(sp)
    2782:	45613023          	sd	s6,1088(sp)
    2786:	43713c23          	sd	s7,1080(sp)
    278a:	43813823          	sd	s8,1072(sp)
    278e:	43913423          	sd	s9,1064(sp)
    2792:	48010413          	add	s0,sp,1152
    2796:	8caa                	mv	s9,a0
  unlink("diskfulldir");
    2798:	00004517          	auipc	a0,0x4
    279c:	c6050513          	add	a0,a0,-928 # 63f8 <malloc+0x11fc>
    27a0:	5b6020ef          	jal	4d56 <unlink>
    27a4:	03000993          	li	s3,48
    name[0] = 'b';
    27a8:	06200b13          	li	s6,98
    name[1] = 'i';
    27ac:	06900a93          	li	s5,105
    name[2] = 'g';
    27b0:	06700a13          	li	s4,103
    27b4:	10c00b93          	li	s7,268
  for(fi = 0; done == 0 && '0' + fi < 0177; fi++){
    27b8:	07f00c13          	li	s8,127
    27bc:	aab9                	j	291a <diskfull+0x1b8>
      printf("%s: could not create file %s\n", s, name);
    27be:	b8040613          	add	a2,s0,-1152
    27c2:	85e6                	mv	a1,s9
    27c4:	00004517          	auipc	a0,0x4
    27c8:	c4450513          	add	a0,a0,-956 # 6408 <malloc+0x120c>
    27cc:	17d020ef          	jal	5148 <printf>
      break;
    27d0:	a039                	j	27de <diskfull+0x7c>
        close(fd);
    27d2:	854a                	mv	a0,s2
    27d4:	55a020ef          	jal	4d2e <close>
    close(fd);
    27d8:	854a                	mv	a0,s2
    27da:	554020ef          	jal	4d2e <close>
  for(int i = 0; i < nzz; i++){
    27de:	4481                	li	s1,0
    name[0] = 'z';
    27e0:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
    27e4:	08000993          	li	s3,128
    name[0] = 'z';
    27e8:	bb240023          	sb	s2,-1120(s0)
    name[1] = 'z';
    27ec:	bb2400a3          	sb	s2,-1119(s0)
    name[2] = '0' + (i / 32);
    27f0:	41f4d71b          	sraw	a4,s1,0x1f
    27f4:	01b7571b          	srlw	a4,a4,0x1b
    27f8:	009707bb          	addw	a5,a4,s1
    27fc:	4057d69b          	sraw	a3,a5,0x5
    2800:	0306869b          	addw	a3,a3,48
    2804:	bad40123          	sb	a3,-1118(s0)
    name[3] = '0' + (i % 32);
    2808:	8bfd                	and	a5,a5,31
    280a:	9f99                	subw	a5,a5,a4
    280c:	0307879b          	addw	a5,a5,48
    2810:	baf401a3          	sb	a5,-1117(s0)
    name[4] = '\0';
    2814:	ba040223          	sb	zero,-1116(s0)
    unlink(name);
    2818:	ba040513          	add	a0,s0,-1120
    281c:	53a020ef          	jal	4d56 <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    2820:	60200593          	li	a1,1538
    2824:	ba040513          	add	a0,s0,-1120
    2828:	51e020ef          	jal	4d46 <open>
    if(fd < 0)
    282c:	00054763          	bltz	a0,283a <diskfull+0xd8>
    close(fd);
    2830:	4fe020ef          	jal	4d2e <close>
  for(int i = 0; i < nzz; i++){
    2834:	2485                	addw	s1,s1,1
    2836:	fb3499e3          	bne	s1,s3,27e8 <diskfull+0x86>
  if(mkdir("diskfulldir") == 0)
    283a:	00004517          	auipc	a0,0x4
    283e:	bbe50513          	add	a0,a0,-1090 # 63f8 <malloc+0x11fc>
    2842:	52c020ef          	jal	4d6e <mkdir>
    2846:	12050063          	beqz	a0,2966 <diskfull+0x204>
  unlink("diskfulldir");
    284a:	00004517          	auipc	a0,0x4
    284e:	bae50513          	add	a0,a0,-1106 # 63f8 <malloc+0x11fc>
    2852:	504020ef          	jal	4d56 <unlink>
  for(int i = 0; i < nzz; i++){
    2856:	4481                	li	s1,0
    name[0] = 'z';
    2858:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
    285c:	08000993          	li	s3,128
    name[0] = 'z';
    2860:	bb240023          	sb	s2,-1120(s0)
    name[1] = 'z';
    2864:	bb2400a3          	sb	s2,-1119(s0)
    name[2] = '0' + (i / 32);
    2868:	41f4d71b          	sraw	a4,s1,0x1f
    286c:	01b7571b          	srlw	a4,a4,0x1b
    2870:	009707bb          	addw	a5,a4,s1
    2874:	4057d69b          	sraw	a3,a5,0x5
    2878:	0306869b          	addw	a3,a3,48
    287c:	bad40123          	sb	a3,-1118(s0)
    name[3] = '0' + (i % 32);
    2880:	8bfd                	and	a5,a5,31
    2882:	9f99                	subw	a5,a5,a4
    2884:	0307879b          	addw	a5,a5,48
    2888:	baf401a3          	sb	a5,-1117(s0)
    name[4] = '\0';
    288c:	ba040223          	sb	zero,-1116(s0)
    unlink(name);
    2890:	ba040513          	add	a0,s0,-1120
    2894:	4c2020ef          	jal	4d56 <unlink>
  for(int i = 0; i < nzz; i++){
    2898:	2485                	addw	s1,s1,1
    289a:	fd3493e3          	bne	s1,s3,2860 <diskfull+0xfe>
    289e:	03000493          	li	s1,48
    name[0] = 'b';
    28a2:	06200a93          	li	s5,98
    name[1] = 'i';
    28a6:	06900a13          	li	s4,105
    name[2] = 'g';
    28aa:	06700993          	li	s3,103
  for(int i = 0; '0' + i < 0177; i++){
    28ae:	07f00913          	li	s2,127
    name[0] = 'b';
    28b2:	bb540023          	sb	s5,-1120(s0)
    name[1] = 'i';
    28b6:	bb4400a3          	sb	s4,-1119(s0)
    name[2] = 'g';
    28ba:	bb340123          	sb	s3,-1118(s0)
    name[3] = '0' + i;
    28be:	ba9401a3          	sb	s1,-1117(s0)
    name[4] = '\0';
    28c2:	ba040223          	sb	zero,-1116(s0)
    unlink(name);
    28c6:	ba040513          	add	a0,s0,-1120
    28ca:	48c020ef          	jal	4d56 <unlink>
  for(int i = 0; '0' + i < 0177; i++){
    28ce:	2485                	addw	s1,s1,1
    28d0:	0ff4f493          	zext.b	s1,s1
    28d4:	fd249fe3          	bne	s1,s2,28b2 <diskfull+0x150>
}
    28d8:	47813083          	ld	ra,1144(sp)
    28dc:	47013403          	ld	s0,1136(sp)
    28e0:	46813483          	ld	s1,1128(sp)
    28e4:	46013903          	ld	s2,1120(sp)
    28e8:	45813983          	ld	s3,1112(sp)
    28ec:	45013a03          	ld	s4,1104(sp)
    28f0:	44813a83          	ld	s5,1096(sp)
    28f4:	44013b03          	ld	s6,1088(sp)
    28f8:	43813b83          	ld	s7,1080(sp)
    28fc:	43013c03          	ld	s8,1072(sp)
    2900:	42813c83          	ld	s9,1064(sp)
    2904:	48010113          	add	sp,sp,1152
    2908:	8082                	ret
    close(fd);
    290a:	854a                	mv	a0,s2
    290c:	422020ef          	jal	4d2e <close>
  for(fi = 0; done == 0 && '0' + fi < 0177; fi++){
    2910:	2985                	addw	s3,s3,1
    2912:	0ff9f993          	zext.b	s3,s3
    2916:	ed8984e3          	beq	s3,s8,27de <diskfull+0x7c>
    name[0] = 'b';
    291a:	b9640023          	sb	s6,-1152(s0)
    name[1] = 'i';
    291e:	b95400a3          	sb	s5,-1151(s0)
    name[2] = 'g';
    2922:	b9440123          	sb	s4,-1150(s0)
    name[3] = '0' + fi;
    2926:	b93401a3          	sb	s3,-1149(s0)
    name[4] = '\0';
    292a:	b8040223          	sb	zero,-1148(s0)
    unlink(name);
    292e:	b8040513          	add	a0,s0,-1152
    2932:	424020ef          	jal	4d56 <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    2936:	60200593          	li	a1,1538
    293a:	b8040513          	add	a0,s0,-1152
    293e:	408020ef          	jal	4d46 <open>
    2942:	892a                	mv	s2,a0
    if(fd < 0){
    2944:	e6054de3          	bltz	a0,27be <diskfull+0x5c>
    2948:	84de                	mv	s1,s7
      if(write(fd, buf, BSIZE) != BSIZE){
    294a:	40000613          	li	a2,1024
    294e:	ba040593          	add	a1,s0,-1120
    2952:	854a                	mv	a0,s2
    2954:	3d2020ef          	jal	4d26 <write>
    2958:	40000793          	li	a5,1024
    295c:	e6f51be3          	bne	a0,a5,27d2 <diskfull+0x70>
    for(int i = 0; i < MAXFILE; i++){
    2960:	34fd                	addw	s1,s1,-1
    2962:	f4e5                	bnez	s1,294a <diskfull+0x1e8>
    2964:	b75d                	j	290a <diskfull+0x1a8>
    printf("%s: mkdir(diskfulldir) unexpectedly succeeded!\n", s);
    2966:	85e6                	mv	a1,s9
    2968:	00004517          	auipc	a0,0x4
    296c:	ac050513          	add	a0,a0,-1344 # 6428 <malloc+0x122c>
    2970:	7d8020ef          	jal	5148 <printf>
    2974:	bdd9                	j	284a <diskfull+0xe8>

0000000000002976 <iputtest>:
{
    2976:	1101                	add	sp,sp,-32
    2978:	ec06                	sd	ra,24(sp)
    297a:	e822                	sd	s0,16(sp)
    297c:	e426                	sd	s1,8(sp)
    297e:	1000                	add	s0,sp,32
    2980:	84aa                	mv	s1,a0
  if(mkdir("iputdir") < 0){
    2982:	00004517          	auipc	a0,0x4
    2986:	ad650513          	add	a0,a0,-1322 # 6458 <malloc+0x125c>
    298a:	3e4020ef          	jal	4d6e <mkdir>
    298e:	02054f63          	bltz	a0,29cc <iputtest+0x56>
  if(chdir("iputdir") < 0){
    2992:	00004517          	auipc	a0,0x4
    2996:	ac650513          	add	a0,a0,-1338 # 6458 <malloc+0x125c>
    299a:	3dc020ef          	jal	4d76 <chdir>
    299e:	04054163          	bltz	a0,29e0 <iputtest+0x6a>
  if(unlink("../iputdir") < 0){
    29a2:	00004517          	auipc	a0,0x4
    29a6:	af650513          	add	a0,a0,-1290 # 6498 <malloc+0x129c>
    29aa:	3ac020ef          	jal	4d56 <unlink>
    29ae:	04054363          	bltz	a0,29f4 <iputtest+0x7e>
  if(chdir("/") < 0){
    29b2:	00004517          	auipc	a0,0x4
    29b6:	b1650513          	add	a0,a0,-1258 # 64c8 <malloc+0x12cc>
    29ba:	3bc020ef          	jal	4d76 <chdir>
    29be:	04054563          	bltz	a0,2a08 <iputtest+0x92>
}
    29c2:	60e2                	ld	ra,24(sp)
    29c4:	6442                	ld	s0,16(sp)
    29c6:	64a2                	ld	s1,8(sp)
    29c8:	6105                	add	sp,sp,32
    29ca:	8082                	ret
    printf("%s: mkdir failed\n", s);
    29cc:	85a6                	mv	a1,s1
    29ce:	00004517          	auipc	a0,0x4
    29d2:	a9250513          	add	a0,a0,-1390 # 6460 <malloc+0x1264>
    29d6:	772020ef          	jal	5148 <printf>
    exit(1);
    29da:	4505                	li	a0,1
    29dc:	32a020ef          	jal	4d06 <exit>
    printf("%s: chdir iputdir failed\n", s);
    29e0:	85a6                	mv	a1,s1
    29e2:	00004517          	auipc	a0,0x4
    29e6:	a9650513          	add	a0,a0,-1386 # 6478 <malloc+0x127c>
    29ea:	75e020ef          	jal	5148 <printf>
    exit(1);
    29ee:	4505                	li	a0,1
    29f0:	316020ef          	jal	4d06 <exit>
    printf("%s: unlink ../iputdir failed\n", s);
    29f4:	85a6                	mv	a1,s1
    29f6:	00004517          	auipc	a0,0x4
    29fa:	ab250513          	add	a0,a0,-1358 # 64a8 <malloc+0x12ac>
    29fe:	74a020ef          	jal	5148 <printf>
    exit(1);
    2a02:	4505                	li	a0,1
    2a04:	302020ef          	jal	4d06 <exit>
    printf("%s: chdir / failed\n", s);
    2a08:	85a6                	mv	a1,s1
    2a0a:	00004517          	auipc	a0,0x4
    2a0e:	ac650513          	add	a0,a0,-1338 # 64d0 <malloc+0x12d4>
    2a12:	736020ef          	jal	5148 <printf>
    exit(1);
    2a16:	4505                	li	a0,1
    2a18:	2ee020ef          	jal	4d06 <exit>

0000000000002a1c <exitiputtest>:
{
    2a1c:	7179                	add	sp,sp,-48
    2a1e:	f406                	sd	ra,40(sp)
    2a20:	f022                	sd	s0,32(sp)
    2a22:	ec26                	sd	s1,24(sp)
    2a24:	1800                	add	s0,sp,48
    2a26:	84aa                	mv	s1,a0
  pid = fork();
    2a28:	2d6020ef          	jal	4cfe <fork>
  if(pid < 0){
    2a2c:	02054e63          	bltz	a0,2a68 <exitiputtest+0x4c>
  if(pid == 0){
    2a30:	e541                	bnez	a0,2ab8 <exitiputtest+0x9c>
    if(mkdir("iputdir") < 0){
    2a32:	00004517          	auipc	a0,0x4
    2a36:	a2650513          	add	a0,a0,-1498 # 6458 <malloc+0x125c>
    2a3a:	334020ef          	jal	4d6e <mkdir>
    2a3e:	02054f63          	bltz	a0,2a7c <exitiputtest+0x60>
    if(chdir("iputdir") < 0){
    2a42:	00004517          	auipc	a0,0x4
    2a46:	a1650513          	add	a0,a0,-1514 # 6458 <malloc+0x125c>
    2a4a:	32c020ef          	jal	4d76 <chdir>
    2a4e:	04054163          	bltz	a0,2a90 <exitiputtest+0x74>
    if(unlink("../iputdir") < 0){
    2a52:	00004517          	auipc	a0,0x4
    2a56:	a4650513          	add	a0,a0,-1466 # 6498 <malloc+0x129c>
    2a5a:	2fc020ef          	jal	4d56 <unlink>
    2a5e:	04054363          	bltz	a0,2aa4 <exitiputtest+0x88>
    exit(0);
    2a62:	4501                	li	a0,0
    2a64:	2a2020ef          	jal	4d06 <exit>
    printf("%s: fork failed\n", s);
    2a68:	85a6                	mv	a1,s1
    2a6a:	00003517          	auipc	a0,0x3
    2a6e:	13e50513          	add	a0,a0,318 # 5ba8 <malloc+0x9ac>
    2a72:	6d6020ef          	jal	5148 <printf>
    exit(1);
    2a76:	4505                	li	a0,1
    2a78:	28e020ef          	jal	4d06 <exit>
      printf("%s: mkdir failed\n", s);
    2a7c:	85a6                	mv	a1,s1
    2a7e:	00004517          	auipc	a0,0x4
    2a82:	9e250513          	add	a0,a0,-1566 # 6460 <malloc+0x1264>
    2a86:	6c2020ef          	jal	5148 <printf>
      exit(1);
    2a8a:	4505                	li	a0,1
    2a8c:	27a020ef          	jal	4d06 <exit>
      printf("%s: child chdir failed\n", s);
    2a90:	85a6                	mv	a1,s1
    2a92:	00004517          	auipc	a0,0x4
    2a96:	a5650513          	add	a0,a0,-1450 # 64e8 <malloc+0x12ec>
    2a9a:	6ae020ef          	jal	5148 <printf>
      exit(1);
    2a9e:	4505                	li	a0,1
    2aa0:	266020ef          	jal	4d06 <exit>
      printf("%s: unlink ../iputdir failed\n", s);
    2aa4:	85a6                	mv	a1,s1
    2aa6:	00004517          	auipc	a0,0x4
    2aaa:	a0250513          	add	a0,a0,-1534 # 64a8 <malloc+0x12ac>
    2aae:	69a020ef          	jal	5148 <printf>
      exit(1);
    2ab2:	4505                	li	a0,1
    2ab4:	252020ef          	jal	4d06 <exit>
  wait(&xstatus);
    2ab8:	fdc40513          	add	a0,s0,-36
    2abc:	252020ef          	jal	4d0e <wait>
  exit(xstatus);
    2ac0:	fdc42503          	lw	a0,-36(s0)
    2ac4:	242020ef          	jal	4d06 <exit>

0000000000002ac8 <dirtest>:
{
    2ac8:	1101                	add	sp,sp,-32
    2aca:	ec06                	sd	ra,24(sp)
    2acc:	e822                	sd	s0,16(sp)
    2ace:	e426                	sd	s1,8(sp)
    2ad0:	1000                	add	s0,sp,32
    2ad2:	84aa                	mv	s1,a0
  if(mkdir("dir0") < 0){
    2ad4:	00004517          	auipc	a0,0x4
    2ad8:	a2c50513          	add	a0,a0,-1492 # 6500 <malloc+0x1304>
    2adc:	292020ef          	jal	4d6e <mkdir>
    2ae0:	02054f63          	bltz	a0,2b1e <dirtest+0x56>
  if(chdir("dir0") < 0){
    2ae4:	00004517          	auipc	a0,0x4
    2ae8:	a1c50513          	add	a0,a0,-1508 # 6500 <malloc+0x1304>
    2aec:	28a020ef          	jal	4d76 <chdir>
    2af0:	04054163          	bltz	a0,2b32 <dirtest+0x6a>
  if(chdir("..") < 0){
    2af4:	00004517          	auipc	a0,0x4
    2af8:	a2c50513          	add	a0,a0,-1492 # 6520 <malloc+0x1324>
    2afc:	27a020ef          	jal	4d76 <chdir>
    2b00:	04054363          	bltz	a0,2b46 <dirtest+0x7e>
  if(unlink("dir0") < 0){
    2b04:	00004517          	auipc	a0,0x4
    2b08:	9fc50513          	add	a0,a0,-1540 # 6500 <malloc+0x1304>
    2b0c:	24a020ef          	jal	4d56 <unlink>
    2b10:	04054563          	bltz	a0,2b5a <dirtest+0x92>
}
    2b14:	60e2                	ld	ra,24(sp)
    2b16:	6442                	ld	s0,16(sp)
    2b18:	64a2                	ld	s1,8(sp)
    2b1a:	6105                	add	sp,sp,32
    2b1c:	8082                	ret
    printf("%s: mkdir failed\n", s);
    2b1e:	85a6                	mv	a1,s1
    2b20:	00004517          	auipc	a0,0x4
    2b24:	94050513          	add	a0,a0,-1728 # 6460 <malloc+0x1264>
    2b28:	620020ef          	jal	5148 <printf>
    exit(1);
    2b2c:	4505                	li	a0,1
    2b2e:	1d8020ef          	jal	4d06 <exit>
    printf("%s: chdir dir0 failed\n", s);
    2b32:	85a6                	mv	a1,s1
    2b34:	00004517          	auipc	a0,0x4
    2b38:	9d450513          	add	a0,a0,-1580 # 6508 <malloc+0x130c>
    2b3c:	60c020ef          	jal	5148 <printf>
    exit(1);
    2b40:	4505                	li	a0,1
    2b42:	1c4020ef          	jal	4d06 <exit>
    printf("%s: chdir .. failed\n", s);
    2b46:	85a6                	mv	a1,s1
    2b48:	00004517          	auipc	a0,0x4
    2b4c:	9e050513          	add	a0,a0,-1568 # 6528 <malloc+0x132c>
    2b50:	5f8020ef          	jal	5148 <printf>
    exit(1);
    2b54:	4505                	li	a0,1
    2b56:	1b0020ef          	jal	4d06 <exit>
    printf("%s: unlink dir0 failed\n", s);
    2b5a:	85a6                	mv	a1,s1
    2b5c:	00004517          	auipc	a0,0x4
    2b60:	9e450513          	add	a0,a0,-1564 # 6540 <malloc+0x1344>
    2b64:	5e4020ef          	jal	5148 <printf>
    exit(1);
    2b68:	4505                	li	a0,1
    2b6a:	19c020ef          	jal	4d06 <exit>

0000000000002b6e <subdir>:
{
    2b6e:	1101                	add	sp,sp,-32
    2b70:	ec06                	sd	ra,24(sp)
    2b72:	e822                	sd	s0,16(sp)
    2b74:	e426                	sd	s1,8(sp)
    2b76:	e04a                	sd	s2,0(sp)
    2b78:	1000                	add	s0,sp,32
    2b7a:	892a                	mv	s2,a0
  unlink("ff");
    2b7c:	00004517          	auipc	a0,0x4
    2b80:	b0c50513          	add	a0,a0,-1268 # 6688 <malloc+0x148c>
    2b84:	1d2020ef          	jal	4d56 <unlink>
  if(mkdir("dd") != 0){
    2b88:	00004517          	auipc	a0,0x4
    2b8c:	9d050513          	add	a0,a0,-1584 # 6558 <malloc+0x135c>
    2b90:	1de020ef          	jal	4d6e <mkdir>
    2b94:	2e051263          	bnez	a0,2e78 <subdir+0x30a>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    2b98:	20200593          	li	a1,514
    2b9c:	00004517          	auipc	a0,0x4
    2ba0:	9dc50513          	add	a0,a0,-1572 # 6578 <malloc+0x137c>
    2ba4:	1a2020ef          	jal	4d46 <open>
    2ba8:	84aa                	mv	s1,a0
  if(fd < 0){
    2baa:	2e054163          	bltz	a0,2e8c <subdir+0x31e>
  write(fd, "ff", 2);
    2bae:	4609                	li	a2,2
    2bb0:	00004597          	auipc	a1,0x4
    2bb4:	ad858593          	add	a1,a1,-1320 # 6688 <malloc+0x148c>
    2bb8:	16e020ef          	jal	4d26 <write>
  close(fd);
    2bbc:	8526                	mv	a0,s1
    2bbe:	170020ef          	jal	4d2e <close>
  if(unlink("dd") >= 0){
    2bc2:	00004517          	auipc	a0,0x4
    2bc6:	99650513          	add	a0,a0,-1642 # 6558 <malloc+0x135c>
    2bca:	18c020ef          	jal	4d56 <unlink>
    2bce:	2c055963          	bgez	a0,2ea0 <subdir+0x332>
  if(mkdir("/dd/dd") != 0){
    2bd2:	00004517          	auipc	a0,0x4
    2bd6:	9fe50513          	add	a0,a0,-1538 # 65d0 <malloc+0x13d4>
    2bda:	194020ef          	jal	4d6e <mkdir>
    2bde:	2c051b63          	bnez	a0,2eb4 <subdir+0x346>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    2be2:	20200593          	li	a1,514
    2be6:	00004517          	auipc	a0,0x4
    2bea:	a1250513          	add	a0,a0,-1518 # 65f8 <malloc+0x13fc>
    2bee:	158020ef          	jal	4d46 <open>
    2bf2:	84aa                	mv	s1,a0
  if(fd < 0){
    2bf4:	2c054a63          	bltz	a0,2ec8 <subdir+0x35a>
  write(fd, "FF", 2);
    2bf8:	4609                	li	a2,2
    2bfa:	00004597          	auipc	a1,0x4
    2bfe:	a2e58593          	add	a1,a1,-1490 # 6628 <malloc+0x142c>
    2c02:	124020ef          	jal	4d26 <write>
  close(fd);
    2c06:	8526                	mv	a0,s1
    2c08:	126020ef          	jal	4d2e <close>
  fd = open("dd/dd/../ff", 0);
    2c0c:	4581                	li	a1,0
    2c0e:	00004517          	auipc	a0,0x4
    2c12:	a2250513          	add	a0,a0,-1502 # 6630 <malloc+0x1434>
    2c16:	130020ef          	jal	4d46 <open>
    2c1a:	84aa                	mv	s1,a0
  if(fd < 0){
    2c1c:	2c054063          	bltz	a0,2edc <subdir+0x36e>
  cc = read(fd, buf, sizeof(buf));
    2c20:	660d                	lui	a2,0x3
    2c22:	00009597          	auipc	a1,0x9
    2c26:	09658593          	add	a1,a1,150 # bcb8 <buf>
    2c2a:	0f4020ef          	jal	4d1e <read>
  if(cc != 2 || buf[0] != 'f'){
    2c2e:	4789                	li	a5,2
    2c30:	2cf51063          	bne	a0,a5,2ef0 <subdir+0x382>
    2c34:	00009717          	auipc	a4,0x9
    2c38:	08474703          	lbu	a4,132(a4) # bcb8 <buf>
    2c3c:	06600793          	li	a5,102
    2c40:	2af71863          	bne	a4,a5,2ef0 <subdir+0x382>
  close(fd);
    2c44:	8526                	mv	a0,s1
    2c46:	0e8020ef          	jal	4d2e <close>
  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    2c4a:	00004597          	auipc	a1,0x4
    2c4e:	a3658593          	add	a1,a1,-1482 # 6680 <malloc+0x1484>
    2c52:	00004517          	auipc	a0,0x4
    2c56:	9a650513          	add	a0,a0,-1626 # 65f8 <malloc+0x13fc>
    2c5a:	10c020ef          	jal	4d66 <link>
    2c5e:	2a051363          	bnez	a0,2f04 <subdir+0x396>
  if(unlink("dd/dd/ff") != 0){
    2c62:	00004517          	auipc	a0,0x4
    2c66:	99650513          	add	a0,a0,-1642 # 65f8 <malloc+0x13fc>
    2c6a:	0ec020ef          	jal	4d56 <unlink>
    2c6e:	2a051563          	bnez	a0,2f18 <subdir+0x3aa>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    2c72:	4581                	li	a1,0
    2c74:	00004517          	auipc	a0,0x4
    2c78:	98450513          	add	a0,a0,-1660 # 65f8 <malloc+0x13fc>
    2c7c:	0ca020ef          	jal	4d46 <open>
    2c80:	2a055663          	bgez	a0,2f2c <subdir+0x3be>
  if(chdir("dd") != 0){
    2c84:	00004517          	auipc	a0,0x4
    2c88:	8d450513          	add	a0,a0,-1836 # 6558 <malloc+0x135c>
    2c8c:	0ea020ef          	jal	4d76 <chdir>
    2c90:	2a051863          	bnez	a0,2f40 <subdir+0x3d2>
  if(chdir("dd/../../dd") != 0){
    2c94:	00004517          	auipc	a0,0x4
    2c98:	a8450513          	add	a0,a0,-1404 # 6718 <malloc+0x151c>
    2c9c:	0da020ef          	jal	4d76 <chdir>
    2ca0:	2a051a63          	bnez	a0,2f54 <subdir+0x3e6>
  if(chdir("dd/../../../dd") != 0){
    2ca4:	00004517          	auipc	a0,0x4
    2ca8:	aa450513          	add	a0,a0,-1372 # 6748 <malloc+0x154c>
    2cac:	0ca020ef          	jal	4d76 <chdir>
    2cb0:	2a051c63          	bnez	a0,2f68 <subdir+0x3fa>
  if(chdir("./..") != 0){
    2cb4:	00004517          	auipc	a0,0x4
    2cb8:	acc50513          	add	a0,a0,-1332 # 6780 <malloc+0x1584>
    2cbc:	0ba020ef          	jal	4d76 <chdir>
    2cc0:	2a051e63          	bnez	a0,2f7c <subdir+0x40e>
  fd = open("dd/dd/ffff", 0);
    2cc4:	4581                	li	a1,0
    2cc6:	00004517          	auipc	a0,0x4
    2cca:	9ba50513          	add	a0,a0,-1606 # 6680 <malloc+0x1484>
    2cce:	078020ef          	jal	4d46 <open>
    2cd2:	84aa                	mv	s1,a0
  if(fd < 0){
    2cd4:	2a054e63          	bltz	a0,2f90 <subdir+0x422>
  if(read(fd, buf, sizeof(buf)) != 2){
    2cd8:	660d                	lui	a2,0x3
    2cda:	00009597          	auipc	a1,0x9
    2cde:	fde58593          	add	a1,a1,-34 # bcb8 <buf>
    2ce2:	03c020ef          	jal	4d1e <read>
    2ce6:	4789                	li	a5,2
    2ce8:	2af51e63          	bne	a0,a5,2fa4 <subdir+0x436>
  close(fd);
    2cec:	8526                	mv	a0,s1
    2cee:	040020ef          	jal	4d2e <close>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    2cf2:	4581                	li	a1,0
    2cf4:	00004517          	auipc	a0,0x4
    2cf8:	90450513          	add	a0,a0,-1788 # 65f8 <malloc+0x13fc>
    2cfc:	04a020ef          	jal	4d46 <open>
    2d00:	2a055c63          	bgez	a0,2fb8 <subdir+0x44a>
  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    2d04:	20200593          	li	a1,514
    2d08:	00004517          	auipc	a0,0x4
    2d0c:	b0850513          	add	a0,a0,-1272 # 6810 <malloc+0x1614>
    2d10:	036020ef          	jal	4d46 <open>
    2d14:	2a055c63          	bgez	a0,2fcc <subdir+0x45e>
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    2d18:	20200593          	li	a1,514
    2d1c:	00004517          	auipc	a0,0x4
    2d20:	b2450513          	add	a0,a0,-1244 # 6840 <malloc+0x1644>
    2d24:	022020ef          	jal	4d46 <open>
    2d28:	2a055c63          	bgez	a0,2fe0 <subdir+0x472>
  if(open("dd", O_CREATE) >= 0){
    2d2c:	20000593          	li	a1,512
    2d30:	00004517          	auipc	a0,0x4
    2d34:	82850513          	add	a0,a0,-2008 # 6558 <malloc+0x135c>
    2d38:	00e020ef          	jal	4d46 <open>
    2d3c:	2a055c63          	bgez	a0,2ff4 <subdir+0x486>
  if(open("dd", O_RDWR) >= 0){
    2d40:	4589                	li	a1,2
    2d42:	00004517          	auipc	a0,0x4
    2d46:	81650513          	add	a0,a0,-2026 # 6558 <malloc+0x135c>
    2d4a:	7fd010ef          	jal	4d46 <open>
    2d4e:	2a055d63          	bgez	a0,3008 <subdir+0x49a>
  if(open("dd", O_WRONLY) >= 0){
    2d52:	4585                	li	a1,1
    2d54:	00004517          	auipc	a0,0x4
    2d58:	80450513          	add	a0,a0,-2044 # 6558 <malloc+0x135c>
    2d5c:	7eb010ef          	jal	4d46 <open>
    2d60:	2a055e63          	bgez	a0,301c <subdir+0x4ae>
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    2d64:	00004597          	auipc	a1,0x4
    2d68:	b6c58593          	add	a1,a1,-1172 # 68d0 <malloc+0x16d4>
    2d6c:	00004517          	auipc	a0,0x4
    2d70:	aa450513          	add	a0,a0,-1372 # 6810 <malloc+0x1614>
    2d74:	7f3010ef          	jal	4d66 <link>
    2d78:	2a050c63          	beqz	a0,3030 <subdir+0x4c2>
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    2d7c:	00004597          	auipc	a1,0x4
    2d80:	b5458593          	add	a1,a1,-1196 # 68d0 <malloc+0x16d4>
    2d84:	00004517          	auipc	a0,0x4
    2d88:	abc50513          	add	a0,a0,-1348 # 6840 <malloc+0x1644>
    2d8c:	7db010ef          	jal	4d66 <link>
    2d90:	2a050a63          	beqz	a0,3044 <subdir+0x4d6>
  if(link("dd/ff", "dd/dd/ffff") == 0){
    2d94:	00004597          	auipc	a1,0x4
    2d98:	8ec58593          	add	a1,a1,-1812 # 6680 <malloc+0x1484>
    2d9c:	00003517          	auipc	a0,0x3
    2da0:	7dc50513          	add	a0,a0,2012 # 6578 <malloc+0x137c>
    2da4:	7c3010ef          	jal	4d66 <link>
    2da8:	2a050863          	beqz	a0,3058 <subdir+0x4ea>
  if(mkdir("dd/ff/ff") == 0){
    2dac:	00004517          	auipc	a0,0x4
    2db0:	a6450513          	add	a0,a0,-1436 # 6810 <malloc+0x1614>
    2db4:	7bb010ef          	jal	4d6e <mkdir>
    2db8:	2a050a63          	beqz	a0,306c <subdir+0x4fe>
  if(mkdir("dd/xx/ff") == 0){
    2dbc:	00004517          	auipc	a0,0x4
    2dc0:	a8450513          	add	a0,a0,-1404 # 6840 <malloc+0x1644>
    2dc4:	7ab010ef          	jal	4d6e <mkdir>
    2dc8:	2a050c63          	beqz	a0,3080 <subdir+0x512>
  if(mkdir("dd/dd/ffff") == 0){
    2dcc:	00004517          	auipc	a0,0x4
    2dd0:	8b450513          	add	a0,a0,-1868 # 6680 <malloc+0x1484>
    2dd4:	79b010ef          	jal	4d6e <mkdir>
    2dd8:	2a050e63          	beqz	a0,3094 <subdir+0x526>
  if(unlink("dd/xx/ff") == 0){
    2ddc:	00004517          	auipc	a0,0x4
    2de0:	a6450513          	add	a0,a0,-1436 # 6840 <malloc+0x1644>
    2de4:	773010ef          	jal	4d56 <unlink>
    2de8:	2c050063          	beqz	a0,30a8 <subdir+0x53a>
  if(unlink("dd/ff/ff") == 0){
    2dec:	00004517          	auipc	a0,0x4
    2df0:	a2450513          	add	a0,a0,-1500 # 6810 <malloc+0x1614>
    2df4:	763010ef          	jal	4d56 <unlink>
    2df8:	2c050263          	beqz	a0,30bc <subdir+0x54e>
  if(chdir("dd/ff") == 0){
    2dfc:	00003517          	auipc	a0,0x3
    2e00:	77c50513          	add	a0,a0,1916 # 6578 <malloc+0x137c>
    2e04:	773010ef          	jal	4d76 <chdir>
    2e08:	2c050463          	beqz	a0,30d0 <subdir+0x562>
  if(chdir("dd/xx") == 0){
    2e0c:	00004517          	auipc	a0,0x4
    2e10:	c1450513          	add	a0,a0,-1004 # 6a20 <malloc+0x1824>
    2e14:	763010ef          	jal	4d76 <chdir>
    2e18:	2c050663          	beqz	a0,30e4 <subdir+0x576>
  if(unlink("dd/dd/ffff") != 0){
    2e1c:	00004517          	auipc	a0,0x4
    2e20:	86450513          	add	a0,a0,-1948 # 6680 <malloc+0x1484>
    2e24:	733010ef          	jal	4d56 <unlink>
    2e28:	2c051863          	bnez	a0,30f8 <subdir+0x58a>
  if(unlink("dd/ff") != 0){
    2e2c:	00003517          	auipc	a0,0x3
    2e30:	74c50513          	add	a0,a0,1868 # 6578 <malloc+0x137c>
    2e34:	723010ef          	jal	4d56 <unlink>
    2e38:	2c051a63          	bnez	a0,310c <subdir+0x59e>
  if(unlink("dd") == 0){
    2e3c:	00003517          	auipc	a0,0x3
    2e40:	71c50513          	add	a0,a0,1820 # 6558 <malloc+0x135c>
    2e44:	713010ef          	jal	4d56 <unlink>
    2e48:	2c050c63          	beqz	a0,3120 <subdir+0x5b2>
  if(unlink("dd/dd") < 0){
    2e4c:	00004517          	auipc	a0,0x4
    2e50:	c4450513          	add	a0,a0,-956 # 6a90 <malloc+0x1894>
    2e54:	703010ef          	jal	4d56 <unlink>
    2e58:	2c054e63          	bltz	a0,3134 <subdir+0x5c6>
  if(unlink("dd") < 0){
    2e5c:	00003517          	auipc	a0,0x3
    2e60:	6fc50513          	add	a0,a0,1788 # 6558 <malloc+0x135c>
    2e64:	6f3010ef          	jal	4d56 <unlink>
    2e68:	2e054063          	bltz	a0,3148 <subdir+0x5da>
}
    2e6c:	60e2                	ld	ra,24(sp)
    2e6e:	6442                	ld	s0,16(sp)
    2e70:	64a2                	ld	s1,8(sp)
    2e72:	6902                	ld	s2,0(sp)
    2e74:	6105                	add	sp,sp,32
    2e76:	8082                	ret
    printf("%s: mkdir dd failed\n", s);
    2e78:	85ca                	mv	a1,s2
    2e7a:	00003517          	auipc	a0,0x3
    2e7e:	6e650513          	add	a0,a0,1766 # 6560 <malloc+0x1364>
    2e82:	2c6020ef          	jal	5148 <printf>
    exit(1);
    2e86:	4505                	li	a0,1
    2e88:	67f010ef          	jal	4d06 <exit>
    printf("%s: create dd/ff failed\n", s);
    2e8c:	85ca                	mv	a1,s2
    2e8e:	00003517          	auipc	a0,0x3
    2e92:	6f250513          	add	a0,a0,1778 # 6580 <malloc+0x1384>
    2e96:	2b2020ef          	jal	5148 <printf>
    exit(1);
    2e9a:	4505                	li	a0,1
    2e9c:	66b010ef          	jal	4d06 <exit>
    printf("%s: unlink dd (non-empty dir) succeeded!\n", s);
    2ea0:	85ca                	mv	a1,s2
    2ea2:	00003517          	auipc	a0,0x3
    2ea6:	6fe50513          	add	a0,a0,1790 # 65a0 <malloc+0x13a4>
    2eaa:	29e020ef          	jal	5148 <printf>
    exit(1);
    2eae:	4505                	li	a0,1
    2eb0:	657010ef          	jal	4d06 <exit>
    printf("%s: subdir mkdir dd/dd failed\n", s);
    2eb4:	85ca                	mv	a1,s2
    2eb6:	00003517          	auipc	a0,0x3
    2eba:	72250513          	add	a0,a0,1826 # 65d8 <malloc+0x13dc>
    2ebe:	28a020ef          	jal	5148 <printf>
    exit(1);
    2ec2:	4505                	li	a0,1
    2ec4:	643010ef          	jal	4d06 <exit>
    printf("%s: create dd/dd/ff failed\n", s);
    2ec8:	85ca                	mv	a1,s2
    2eca:	00003517          	auipc	a0,0x3
    2ece:	73e50513          	add	a0,a0,1854 # 6608 <malloc+0x140c>
    2ed2:	276020ef          	jal	5148 <printf>
    exit(1);
    2ed6:	4505                	li	a0,1
    2ed8:	62f010ef          	jal	4d06 <exit>
    printf("%s: open dd/dd/../ff failed\n", s);
    2edc:	85ca                	mv	a1,s2
    2ede:	00003517          	auipc	a0,0x3
    2ee2:	76250513          	add	a0,a0,1890 # 6640 <malloc+0x1444>
    2ee6:	262020ef          	jal	5148 <printf>
    exit(1);
    2eea:	4505                	li	a0,1
    2eec:	61b010ef          	jal	4d06 <exit>
    printf("%s: dd/dd/../ff wrong content\n", s);
    2ef0:	85ca                	mv	a1,s2
    2ef2:	00003517          	auipc	a0,0x3
    2ef6:	76e50513          	add	a0,a0,1902 # 6660 <malloc+0x1464>
    2efa:	24e020ef          	jal	5148 <printf>
    exit(1);
    2efe:	4505                	li	a0,1
    2f00:	607010ef          	jal	4d06 <exit>
    printf("%s: link dd/dd/ff dd/dd/ffff failed\n", s);
    2f04:	85ca                	mv	a1,s2
    2f06:	00003517          	auipc	a0,0x3
    2f0a:	78a50513          	add	a0,a0,1930 # 6690 <malloc+0x1494>
    2f0e:	23a020ef          	jal	5148 <printf>
    exit(1);
    2f12:	4505                	li	a0,1
    2f14:	5f3010ef          	jal	4d06 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    2f18:	85ca                	mv	a1,s2
    2f1a:	00003517          	auipc	a0,0x3
    2f1e:	79e50513          	add	a0,a0,1950 # 66b8 <malloc+0x14bc>
    2f22:	226020ef          	jal	5148 <printf>
    exit(1);
    2f26:	4505                	li	a0,1
    2f28:	5df010ef          	jal	4d06 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded\n", s);
    2f2c:	85ca                	mv	a1,s2
    2f2e:	00003517          	auipc	a0,0x3
    2f32:	7aa50513          	add	a0,a0,1962 # 66d8 <malloc+0x14dc>
    2f36:	212020ef          	jal	5148 <printf>
    exit(1);
    2f3a:	4505                	li	a0,1
    2f3c:	5cb010ef          	jal	4d06 <exit>
    printf("%s: chdir dd failed\n", s);
    2f40:	85ca                	mv	a1,s2
    2f42:	00003517          	auipc	a0,0x3
    2f46:	7be50513          	add	a0,a0,1982 # 6700 <malloc+0x1504>
    2f4a:	1fe020ef          	jal	5148 <printf>
    exit(1);
    2f4e:	4505                	li	a0,1
    2f50:	5b7010ef          	jal	4d06 <exit>
    printf("%s: chdir dd/../../dd failed\n", s);
    2f54:	85ca                	mv	a1,s2
    2f56:	00003517          	auipc	a0,0x3
    2f5a:	7d250513          	add	a0,a0,2002 # 6728 <malloc+0x152c>
    2f5e:	1ea020ef          	jal	5148 <printf>
    exit(1);
    2f62:	4505                	li	a0,1
    2f64:	5a3010ef          	jal	4d06 <exit>
    printf("%s: chdir dd/../../../dd failed\n", s);
    2f68:	85ca                	mv	a1,s2
    2f6a:	00003517          	auipc	a0,0x3
    2f6e:	7ee50513          	add	a0,a0,2030 # 6758 <malloc+0x155c>
    2f72:	1d6020ef          	jal	5148 <printf>
    exit(1);
    2f76:	4505                	li	a0,1
    2f78:	58f010ef          	jal	4d06 <exit>
    printf("%s: chdir ./.. failed\n", s);
    2f7c:	85ca                	mv	a1,s2
    2f7e:	00004517          	auipc	a0,0x4
    2f82:	80a50513          	add	a0,a0,-2038 # 6788 <malloc+0x158c>
    2f86:	1c2020ef          	jal	5148 <printf>
    exit(1);
    2f8a:	4505                	li	a0,1
    2f8c:	57b010ef          	jal	4d06 <exit>
    printf("%s: open dd/dd/ffff failed\n", s);
    2f90:	85ca                	mv	a1,s2
    2f92:	00004517          	auipc	a0,0x4
    2f96:	80e50513          	add	a0,a0,-2034 # 67a0 <malloc+0x15a4>
    2f9a:	1ae020ef          	jal	5148 <printf>
    exit(1);
    2f9e:	4505                	li	a0,1
    2fa0:	567010ef          	jal	4d06 <exit>
    printf("%s: read dd/dd/ffff wrong len\n", s);
    2fa4:	85ca                	mv	a1,s2
    2fa6:	00004517          	auipc	a0,0x4
    2faa:	81a50513          	add	a0,a0,-2022 # 67c0 <malloc+0x15c4>
    2fae:	19a020ef          	jal	5148 <printf>
    exit(1);
    2fb2:	4505                	li	a0,1
    2fb4:	553010ef          	jal	4d06 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded!\n", s);
    2fb8:	85ca                	mv	a1,s2
    2fba:	00004517          	auipc	a0,0x4
    2fbe:	82650513          	add	a0,a0,-2010 # 67e0 <malloc+0x15e4>
    2fc2:	186020ef          	jal	5148 <printf>
    exit(1);
    2fc6:	4505                	li	a0,1
    2fc8:	53f010ef          	jal	4d06 <exit>
    printf("%s: create dd/ff/ff succeeded!\n", s);
    2fcc:	85ca                	mv	a1,s2
    2fce:	00004517          	auipc	a0,0x4
    2fd2:	85250513          	add	a0,a0,-1966 # 6820 <malloc+0x1624>
    2fd6:	172020ef          	jal	5148 <printf>
    exit(1);
    2fda:	4505                	li	a0,1
    2fdc:	52b010ef          	jal	4d06 <exit>
    printf("%s: create dd/xx/ff succeeded!\n", s);
    2fe0:	85ca                	mv	a1,s2
    2fe2:	00004517          	auipc	a0,0x4
    2fe6:	86e50513          	add	a0,a0,-1938 # 6850 <malloc+0x1654>
    2fea:	15e020ef          	jal	5148 <printf>
    exit(1);
    2fee:	4505                	li	a0,1
    2ff0:	517010ef          	jal	4d06 <exit>
    printf("%s: create dd succeeded!\n", s);
    2ff4:	85ca                	mv	a1,s2
    2ff6:	00004517          	auipc	a0,0x4
    2ffa:	87a50513          	add	a0,a0,-1926 # 6870 <malloc+0x1674>
    2ffe:	14a020ef          	jal	5148 <printf>
    exit(1);
    3002:	4505                	li	a0,1
    3004:	503010ef          	jal	4d06 <exit>
    printf("%s: open dd rdwr succeeded!\n", s);
    3008:	85ca                	mv	a1,s2
    300a:	00004517          	auipc	a0,0x4
    300e:	88650513          	add	a0,a0,-1914 # 6890 <malloc+0x1694>
    3012:	136020ef          	jal	5148 <printf>
    exit(1);
    3016:	4505                	li	a0,1
    3018:	4ef010ef          	jal	4d06 <exit>
    printf("%s: open dd wronly succeeded!\n", s);
    301c:	85ca                	mv	a1,s2
    301e:	00004517          	auipc	a0,0x4
    3022:	89250513          	add	a0,a0,-1902 # 68b0 <malloc+0x16b4>
    3026:	122020ef          	jal	5148 <printf>
    exit(1);
    302a:	4505                	li	a0,1
    302c:	4db010ef          	jal	4d06 <exit>
    printf("%s: link dd/ff/ff dd/dd/xx succeeded!\n", s);
    3030:	85ca                	mv	a1,s2
    3032:	00004517          	auipc	a0,0x4
    3036:	8ae50513          	add	a0,a0,-1874 # 68e0 <malloc+0x16e4>
    303a:	10e020ef          	jal	5148 <printf>
    exit(1);
    303e:	4505                	li	a0,1
    3040:	4c7010ef          	jal	4d06 <exit>
    printf("%s: link dd/xx/ff dd/dd/xx succeeded!\n", s);
    3044:	85ca                	mv	a1,s2
    3046:	00004517          	auipc	a0,0x4
    304a:	8c250513          	add	a0,a0,-1854 # 6908 <malloc+0x170c>
    304e:	0fa020ef          	jal	5148 <printf>
    exit(1);
    3052:	4505                	li	a0,1
    3054:	4b3010ef          	jal	4d06 <exit>
    printf("%s: link dd/ff dd/dd/ffff succeeded!\n", s);
    3058:	85ca                	mv	a1,s2
    305a:	00004517          	auipc	a0,0x4
    305e:	8d650513          	add	a0,a0,-1834 # 6930 <malloc+0x1734>
    3062:	0e6020ef          	jal	5148 <printf>
    exit(1);
    3066:	4505                	li	a0,1
    3068:	49f010ef          	jal	4d06 <exit>
    printf("%s: mkdir dd/ff/ff succeeded!\n", s);
    306c:	85ca                	mv	a1,s2
    306e:	00004517          	auipc	a0,0x4
    3072:	8ea50513          	add	a0,a0,-1814 # 6958 <malloc+0x175c>
    3076:	0d2020ef          	jal	5148 <printf>
    exit(1);
    307a:	4505                	li	a0,1
    307c:	48b010ef          	jal	4d06 <exit>
    printf("%s: mkdir dd/xx/ff succeeded!\n", s);
    3080:	85ca                	mv	a1,s2
    3082:	00004517          	auipc	a0,0x4
    3086:	8f650513          	add	a0,a0,-1802 # 6978 <malloc+0x177c>
    308a:	0be020ef          	jal	5148 <printf>
    exit(1);
    308e:	4505                	li	a0,1
    3090:	477010ef          	jal	4d06 <exit>
    printf("%s: mkdir dd/dd/ffff succeeded!\n", s);
    3094:	85ca                	mv	a1,s2
    3096:	00004517          	auipc	a0,0x4
    309a:	90250513          	add	a0,a0,-1790 # 6998 <malloc+0x179c>
    309e:	0aa020ef          	jal	5148 <printf>
    exit(1);
    30a2:	4505                	li	a0,1
    30a4:	463010ef          	jal	4d06 <exit>
    printf("%s: unlink dd/xx/ff succeeded!\n", s);
    30a8:	85ca                	mv	a1,s2
    30aa:	00004517          	auipc	a0,0x4
    30ae:	91650513          	add	a0,a0,-1770 # 69c0 <malloc+0x17c4>
    30b2:	096020ef          	jal	5148 <printf>
    exit(1);
    30b6:	4505                	li	a0,1
    30b8:	44f010ef          	jal	4d06 <exit>
    printf("%s: unlink dd/ff/ff succeeded!\n", s);
    30bc:	85ca                	mv	a1,s2
    30be:	00004517          	auipc	a0,0x4
    30c2:	92250513          	add	a0,a0,-1758 # 69e0 <malloc+0x17e4>
    30c6:	082020ef          	jal	5148 <printf>
    exit(1);
    30ca:	4505                	li	a0,1
    30cc:	43b010ef          	jal	4d06 <exit>
    printf("%s: chdir dd/ff succeeded!\n", s);
    30d0:	85ca                	mv	a1,s2
    30d2:	00004517          	auipc	a0,0x4
    30d6:	92e50513          	add	a0,a0,-1746 # 6a00 <malloc+0x1804>
    30da:	06e020ef          	jal	5148 <printf>
    exit(1);
    30de:	4505                	li	a0,1
    30e0:	427010ef          	jal	4d06 <exit>
    printf("%s: chdir dd/xx succeeded!\n", s);
    30e4:	85ca                	mv	a1,s2
    30e6:	00004517          	auipc	a0,0x4
    30ea:	94250513          	add	a0,a0,-1726 # 6a28 <malloc+0x182c>
    30ee:	05a020ef          	jal	5148 <printf>
    exit(1);
    30f2:	4505                	li	a0,1
    30f4:	413010ef          	jal	4d06 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    30f8:	85ca                	mv	a1,s2
    30fa:	00003517          	auipc	a0,0x3
    30fe:	5be50513          	add	a0,a0,1470 # 66b8 <malloc+0x14bc>
    3102:	046020ef          	jal	5148 <printf>
    exit(1);
    3106:	4505                	li	a0,1
    3108:	3ff010ef          	jal	4d06 <exit>
    printf("%s: unlink dd/ff failed\n", s);
    310c:	85ca                	mv	a1,s2
    310e:	00004517          	auipc	a0,0x4
    3112:	93a50513          	add	a0,a0,-1734 # 6a48 <malloc+0x184c>
    3116:	032020ef          	jal	5148 <printf>
    exit(1);
    311a:	4505                	li	a0,1
    311c:	3eb010ef          	jal	4d06 <exit>
    printf("%s: unlink non-empty dd succeeded!\n", s);
    3120:	85ca                	mv	a1,s2
    3122:	00004517          	auipc	a0,0x4
    3126:	94650513          	add	a0,a0,-1722 # 6a68 <malloc+0x186c>
    312a:	01e020ef          	jal	5148 <printf>
    exit(1);
    312e:	4505                	li	a0,1
    3130:	3d7010ef          	jal	4d06 <exit>
    printf("%s: unlink dd/dd failed\n", s);
    3134:	85ca                	mv	a1,s2
    3136:	00004517          	auipc	a0,0x4
    313a:	96250513          	add	a0,a0,-1694 # 6a98 <malloc+0x189c>
    313e:	00a020ef          	jal	5148 <printf>
    exit(1);
    3142:	4505                	li	a0,1
    3144:	3c3010ef          	jal	4d06 <exit>
    printf("%s: unlink dd failed\n", s);
    3148:	85ca                	mv	a1,s2
    314a:	00004517          	auipc	a0,0x4
    314e:	96e50513          	add	a0,a0,-1682 # 6ab8 <malloc+0x18bc>
    3152:	7f7010ef          	jal	5148 <printf>
    exit(1);
    3156:	4505                	li	a0,1
    3158:	3af010ef          	jal	4d06 <exit>

000000000000315c <rmdot>:
{
    315c:	1101                	add	sp,sp,-32
    315e:	ec06                	sd	ra,24(sp)
    3160:	e822                	sd	s0,16(sp)
    3162:	e426                	sd	s1,8(sp)
    3164:	1000                	add	s0,sp,32
    3166:	84aa                	mv	s1,a0
  if(mkdir("dots") != 0){
    3168:	00004517          	auipc	a0,0x4
    316c:	96850513          	add	a0,a0,-1688 # 6ad0 <malloc+0x18d4>
    3170:	3ff010ef          	jal	4d6e <mkdir>
    3174:	e53d                	bnez	a0,31e2 <rmdot+0x86>
  if(chdir("dots") != 0){
    3176:	00004517          	auipc	a0,0x4
    317a:	95a50513          	add	a0,a0,-1702 # 6ad0 <malloc+0x18d4>
    317e:	3f9010ef          	jal	4d76 <chdir>
    3182:	e935                	bnez	a0,31f6 <rmdot+0x9a>
  if(unlink(".") == 0){
    3184:	00003517          	auipc	a0,0x3
    3188:	87c50513          	add	a0,a0,-1924 # 5a00 <malloc+0x804>
    318c:	3cb010ef          	jal	4d56 <unlink>
    3190:	cd2d                	beqz	a0,320a <rmdot+0xae>
  if(unlink("..") == 0){
    3192:	00003517          	auipc	a0,0x3
    3196:	38e50513          	add	a0,a0,910 # 6520 <malloc+0x1324>
    319a:	3bd010ef          	jal	4d56 <unlink>
    319e:	c141                	beqz	a0,321e <rmdot+0xc2>
  if(chdir("/") != 0){
    31a0:	00003517          	auipc	a0,0x3
    31a4:	32850513          	add	a0,a0,808 # 64c8 <malloc+0x12cc>
    31a8:	3cf010ef          	jal	4d76 <chdir>
    31ac:	e159                	bnez	a0,3232 <rmdot+0xd6>
  if(unlink("dots/.") == 0){
    31ae:	00004517          	auipc	a0,0x4
    31b2:	98a50513          	add	a0,a0,-1654 # 6b38 <malloc+0x193c>
    31b6:	3a1010ef          	jal	4d56 <unlink>
    31ba:	c551                	beqz	a0,3246 <rmdot+0xea>
  if(unlink("dots/..") == 0){
    31bc:	00004517          	auipc	a0,0x4
    31c0:	9a450513          	add	a0,a0,-1628 # 6b60 <malloc+0x1964>
    31c4:	393010ef          	jal	4d56 <unlink>
    31c8:	c949                	beqz	a0,325a <rmdot+0xfe>
  if(unlink("dots") != 0){
    31ca:	00004517          	auipc	a0,0x4
    31ce:	90650513          	add	a0,a0,-1786 # 6ad0 <malloc+0x18d4>
    31d2:	385010ef          	jal	4d56 <unlink>
    31d6:	ed41                	bnez	a0,326e <rmdot+0x112>
}
    31d8:	60e2                	ld	ra,24(sp)
    31da:	6442                	ld	s0,16(sp)
    31dc:	64a2                	ld	s1,8(sp)
    31de:	6105                	add	sp,sp,32
    31e0:	8082                	ret
    printf("%s: mkdir dots failed\n", s);
    31e2:	85a6                	mv	a1,s1
    31e4:	00004517          	auipc	a0,0x4
    31e8:	8f450513          	add	a0,a0,-1804 # 6ad8 <malloc+0x18dc>
    31ec:	75d010ef          	jal	5148 <printf>
    exit(1);
    31f0:	4505                	li	a0,1
    31f2:	315010ef          	jal	4d06 <exit>
    printf("%s: chdir dots failed\n", s);
    31f6:	85a6                	mv	a1,s1
    31f8:	00004517          	auipc	a0,0x4
    31fc:	8f850513          	add	a0,a0,-1800 # 6af0 <malloc+0x18f4>
    3200:	749010ef          	jal	5148 <printf>
    exit(1);
    3204:	4505                	li	a0,1
    3206:	301010ef          	jal	4d06 <exit>
    printf("%s: rm . worked!\n", s);
    320a:	85a6                	mv	a1,s1
    320c:	00004517          	auipc	a0,0x4
    3210:	8fc50513          	add	a0,a0,-1796 # 6b08 <malloc+0x190c>
    3214:	735010ef          	jal	5148 <printf>
    exit(1);
    3218:	4505                	li	a0,1
    321a:	2ed010ef          	jal	4d06 <exit>
    printf("%s: rm .. worked!\n", s);
    321e:	85a6                	mv	a1,s1
    3220:	00004517          	auipc	a0,0x4
    3224:	90050513          	add	a0,a0,-1792 # 6b20 <malloc+0x1924>
    3228:	721010ef          	jal	5148 <printf>
    exit(1);
    322c:	4505                	li	a0,1
    322e:	2d9010ef          	jal	4d06 <exit>
    printf("%s: chdir / failed\n", s);
    3232:	85a6                	mv	a1,s1
    3234:	00003517          	auipc	a0,0x3
    3238:	29c50513          	add	a0,a0,668 # 64d0 <malloc+0x12d4>
    323c:	70d010ef          	jal	5148 <printf>
    exit(1);
    3240:	4505                	li	a0,1
    3242:	2c5010ef          	jal	4d06 <exit>
    printf("%s: unlink dots/. worked!\n", s);
    3246:	85a6                	mv	a1,s1
    3248:	00004517          	auipc	a0,0x4
    324c:	8f850513          	add	a0,a0,-1800 # 6b40 <malloc+0x1944>
    3250:	6f9010ef          	jal	5148 <printf>
    exit(1);
    3254:	4505                	li	a0,1
    3256:	2b1010ef          	jal	4d06 <exit>
    printf("%s: unlink dots/.. worked!\n", s);
    325a:	85a6                	mv	a1,s1
    325c:	00004517          	auipc	a0,0x4
    3260:	90c50513          	add	a0,a0,-1780 # 6b68 <malloc+0x196c>
    3264:	6e5010ef          	jal	5148 <printf>
    exit(1);
    3268:	4505                	li	a0,1
    326a:	29d010ef          	jal	4d06 <exit>
    printf("%s: unlink dots failed!\n", s);
    326e:	85a6                	mv	a1,s1
    3270:	00004517          	auipc	a0,0x4
    3274:	91850513          	add	a0,a0,-1768 # 6b88 <malloc+0x198c>
    3278:	6d1010ef          	jal	5148 <printf>
    exit(1);
    327c:	4505                	li	a0,1
    327e:	289010ef          	jal	4d06 <exit>

0000000000003282 <dirfile>:
{
    3282:	1101                	add	sp,sp,-32
    3284:	ec06                	sd	ra,24(sp)
    3286:	e822                	sd	s0,16(sp)
    3288:	e426                	sd	s1,8(sp)
    328a:	e04a                	sd	s2,0(sp)
    328c:	1000                	add	s0,sp,32
    328e:	892a                	mv	s2,a0
  fd = open("dirfile", O_CREATE);
    3290:	20000593          	li	a1,512
    3294:	00004517          	auipc	a0,0x4
    3298:	91450513          	add	a0,a0,-1772 # 6ba8 <malloc+0x19ac>
    329c:	2ab010ef          	jal	4d46 <open>
  if(fd < 0){
    32a0:	0c054563          	bltz	a0,336a <dirfile+0xe8>
  close(fd);
    32a4:	28b010ef          	jal	4d2e <close>
  if(chdir("dirfile") == 0){
    32a8:	00004517          	auipc	a0,0x4
    32ac:	90050513          	add	a0,a0,-1792 # 6ba8 <malloc+0x19ac>
    32b0:	2c7010ef          	jal	4d76 <chdir>
    32b4:	c569                	beqz	a0,337e <dirfile+0xfc>
  fd = open("dirfile/xx", 0);
    32b6:	4581                	li	a1,0
    32b8:	00004517          	auipc	a0,0x4
    32bc:	93850513          	add	a0,a0,-1736 # 6bf0 <malloc+0x19f4>
    32c0:	287010ef          	jal	4d46 <open>
  if(fd >= 0){
    32c4:	0c055763          	bgez	a0,3392 <dirfile+0x110>
  fd = open("dirfile/xx", O_CREATE);
    32c8:	20000593          	li	a1,512
    32cc:	00004517          	auipc	a0,0x4
    32d0:	92450513          	add	a0,a0,-1756 # 6bf0 <malloc+0x19f4>
    32d4:	273010ef          	jal	4d46 <open>
  if(fd >= 0){
    32d8:	0c055763          	bgez	a0,33a6 <dirfile+0x124>
  if(mkdir("dirfile/xx") == 0){
    32dc:	00004517          	auipc	a0,0x4
    32e0:	91450513          	add	a0,a0,-1772 # 6bf0 <malloc+0x19f4>
    32e4:	28b010ef          	jal	4d6e <mkdir>
    32e8:	0c050963          	beqz	a0,33ba <dirfile+0x138>
  if(unlink("dirfile/xx") == 0){
    32ec:	00004517          	auipc	a0,0x4
    32f0:	90450513          	add	a0,a0,-1788 # 6bf0 <malloc+0x19f4>
    32f4:	263010ef          	jal	4d56 <unlink>
    32f8:	0c050b63          	beqz	a0,33ce <dirfile+0x14c>
  if(link("README", "dirfile/xx") == 0){
    32fc:	00004597          	auipc	a1,0x4
    3300:	8f458593          	add	a1,a1,-1804 # 6bf0 <malloc+0x19f4>
    3304:	00002517          	auipc	a0,0x2
    3308:	1ec50513          	add	a0,a0,492 # 54f0 <malloc+0x2f4>
    330c:	25b010ef          	jal	4d66 <link>
    3310:	0c050963          	beqz	a0,33e2 <dirfile+0x160>
  if(unlink("dirfile") != 0){
    3314:	00004517          	auipc	a0,0x4
    3318:	89450513          	add	a0,a0,-1900 # 6ba8 <malloc+0x19ac>
    331c:	23b010ef          	jal	4d56 <unlink>
    3320:	0c051b63          	bnez	a0,33f6 <dirfile+0x174>
  fd = open(".", O_RDWR);
    3324:	4589                	li	a1,2
    3326:	00002517          	auipc	a0,0x2
    332a:	6da50513          	add	a0,a0,1754 # 5a00 <malloc+0x804>
    332e:	219010ef          	jal	4d46 <open>
  if(fd >= 0){
    3332:	0c055c63          	bgez	a0,340a <dirfile+0x188>
  fd = open(".", 0);
    3336:	4581                	li	a1,0
    3338:	00002517          	auipc	a0,0x2
    333c:	6c850513          	add	a0,a0,1736 # 5a00 <malloc+0x804>
    3340:	207010ef          	jal	4d46 <open>
    3344:	84aa                	mv	s1,a0
  if(write(fd, "x", 1) > 0){
    3346:	4605                	li	a2,1
    3348:	00002597          	auipc	a1,0x2
    334c:	04058593          	add	a1,a1,64 # 5388 <malloc+0x18c>
    3350:	1d7010ef          	jal	4d26 <write>
    3354:	0ca04563          	bgtz	a0,341e <dirfile+0x19c>
  close(fd);
    3358:	8526                	mv	a0,s1
    335a:	1d5010ef          	jal	4d2e <close>
}
    335e:	60e2                	ld	ra,24(sp)
    3360:	6442                	ld	s0,16(sp)
    3362:	64a2                	ld	s1,8(sp)
    3364:	6902                	ld	s2,0(sp)
    3366:	6105                	add	sp,sp,32
    3368:	8082                	ret
    printf("%s: create dirfile failed\n", s);
    336a:	85ca                	mv	a1,s2
    336c:	00004517          	auipc	a0,0x4
    3370:	84450513          	add	a0,a0,-1980 # 6bb0 <malloc+0x19b4>
    3374:	5d5010ef          	jal	5148 <printf>
    exit(1);
    3378:	4505                	li	a0,1
    337a:	18d010ef          	jal	4d06 <exit>
    printf("%s: chdir dirfile succeeded!\n", s);
    337e:	85ca                	mv	a1,s2
    3380:	00004517          	auipc	a0,0x4
    3384:	85050513          	add	a0,a0,-1968 # 6bd0 <malloc+0x19d4>
    3388:	5c1010ef          	jal	5148 <printf>
    exit(1);
    338c:	4505                	li	a0,1
    338e:	179010ef          	jal	4d06 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    3392:	85ca                	mv	a1,s2
    3394:	00004517          	auipc	a0,0x4
    3398:	86c50513          	add	a0,a0,-1940 # 6c00 <malloc+0x1a04>
    339c:	5ad010ef          	jal	5148 <printf>
    exit(1);
    33a0:	4505                	li	a0,1
    33a2:	165010ef          	jal	4d06 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    33a6:	85ca                	mv	a1,s2
    33a8:	00004517          	auipc	a0,0x4
    33ac:	85850513          	add	a0,a0,-1960 # 6c00 <malloc+0x1a04>
    33b0:	599010ef          	jal	5148 <printf>
    exit(1);
    33b4:	4505                	li	a0,1
    33b6:	151010ef          	jal	4d06 <exit>
    printf("%s: mkdir dirfile/xx succeeded!\n", s);
    33ba:	85ca                	mv	a1,s2
    33bc:	00004517          	auipc	a0,0x4
    33c0:	86c50513          	add	a0,a0,-1940 # 6c28 <malloc+0x1a2c>
    33c4:	585010ef          	jal	5148 <printf>
    exit(1);
    33c8:	4505                	li	a0,1
    33ca:	13d010ef          	jal	4d06 <exit>
    printf("%s: unlink dirfile/xx succeeded!\n", s);
    33ce:	85ca                	mv	a1,s2
    33d0:	00004517          	auipc	a0,0x4
    33d4:	88050513          	add	a0,a0,-1920 # 6c50 <malloc+0x1a54>
    33d8:	571010ef          	jal	5148 <printf>
    exit(1);
    33dc:	4505                	li	a0,1
    33de:	129010ef          	jal	4d06 <exit>
    printf("%s: link to dirfile/xx succeeded!\n", s);
    33e2:	85ca                	mv	a1,s2
    33e4:	00004517          	auipc	a0,0x4
    33e8:	89450513          	add	a0,a0,-1900 # 6c78 <malloc+0x1a7c>
    33ec:	55d010ef          	jal	5148 <printf>
    exit(1);
    33f0:	4505                	li	a0,1
    33f2:	115010ef          	jal	4d06 <exit>
    printf("%s: unlink dirfile failed!\n", s);
    33f6:	85ca                	mv	a1,s2
    33f8:	00004517          	auipc	a0,0x4
    33fc:	8a850513          	add	a0,a0,-1880 # 6ca0 <malloc+0x1aa4>
    3400:	549010ef          	jal	5148 <printf>
    exit(1);
    3404:	4505                	li	a0,1
    3406:	101010ef          	jal	4d06 <exit>
    printf("%s: open . for writing succeeded!\n", s);
    340a:	85ca                	mv	a1,s2
    340c:	00004517          	auipc	a0,0x4
    3410:	8b450513          	add	a0,a0,-1868 # 6cc0 <malloc+0x1ac4>
    3414:	535010ef          	jal	5148 <printf>
    exit(1);
    3418:	4505                	li	a0,1
    341a:	0ed010ef          	jal	4d06 <exit>
    printf("%s: write . succeeded!\n", s);
    341e:	85ca                	mv	a1,s2
    3420:	00004517          	auipc	a0,0x4
    3424:	8c850513          	add	a0,a0,-1848 # 6ce8 <malloc+0x1aec>
    3428:	521010ef          	jal	5148 <printf>
    exit(1);
    342c:	4505                	li	a0,1
    342e:	0d9010ef          	jal	4d06 <exit>

0000000000003432 <iref>:
{
    3432:	7139                	add	sp,sp,-64
    3434:	fc06                	sd	ra,56(sp)
    3436:	f822                	sd	s0,48(sp)
    3438:	f426                	sd	s1,40(sp)
    343a:	f04a                	sd	s2,32(sp)
    343c:	ec4e                	sd	s3,24(sp)
    343e:	e852                	sd	s4,16(sp)
    3440:	e456                	sd	s5,8(sp)
    3442:	e05a                	sd	s6,0(sp)
    3444:	0080                	add	s0,sp,64
    3446:	8b2a                	mv	s6,a0
    3448:	03300913          	li	s2,51
    if(mkdir("irefd") != 0){
    344c:	00004a17          	auipc	s4,0x4
    3450:	8b4a0a13          	add	s4,s4,-1868 # 6d00 <malloc+0x1b04>
    mkdir("");
    3454:	00003497          	auipc	s1,0x3
    3458:	3b448493          	add	s1,s1,948 # 6808 <malloc+0x160c>
    link("README", "");
    345c:	00002a97          	auipc	s5,0x2
    3460:	094a8a93          	add	s5,s5,148 # 54f0 <malloc+0x2f4>
    fd = open("xx", O_CREATE);
    3464:	00003997          	auipc	s3,0x3
    3468:	79498993          	add	s3,s3,1940 # 6bf8 <malloc+0x19fc>
    346c:	a835                	j	34a8 <iref+0x76>
      printf("%s: mkdir irefd failed\n", s);
    346e:	85da                	mv	a1,s6
    3470:	00004517          	auipc	a0,0x4
    3474:	89850513          	add	a0,a0,-1896 # 6d08 <malloc+0x1b0c>
    3478:	4d1010ef          	jal	5148 <printf>
      exit(1);
    347c:	4505                	li	a0,1
    347e:	089010ef          	jal	4d06 <exit>
      printf("%s: chdir irefd failed\n", s);
    3482:	85da                	mv	a1,s6
    3484:	00004517          	auipc	a0,0x4
    3488:	89c50513          	add	a0,a0,-1892 # 6d20 <malloc+0x1b24>
    348c:	4bd010ef          	jal	5148 <printf>
      exit(1);
    3490:	4505                	li	a0,1
    3492:	075010ef          	jal	4d06 <exit>
      close(fd);
    3496:	099010ef          	jal	4d2e <close>
    349a:	a82d                	j	34d4 <iref+0xa2>
    unlink("xx");
    349c:	854e                	mv	a0,s3
    349e:	0b9010ef          	jal	4d56 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    34a2:	397d                	addw	s2,s2,-1
    34a4:	04090263          	beqz	s2,34e8 <iref+0xb6>
    if(mkdir("irefd") != 0){
    34a8:	8552                	mv	a0,s4
    34aa:	0c5010ef          	jal	4d6e <mkdir>
    34ae:	f161                	bnez	a0,346e <iref+0x3c>
    if(chdir("irefd") != 0){
    34b0:	8552                	mv	a0,s4
    34b2:	0c5010ef          	jal	4d76 <chdir>
    34b6:	f571                	bnez	a0,3482 <iref+0x50>
    mkdir("");
    34b8:	8526                	mv	a0,s1
    34ba:	0b5010ef          	jal	4d6e <mkdir>
    link("README", "");
    34be:	85a6                	mv	a1,s1
    34c0:	8556                	mv	a0,s5
    34c2:	0a5010ef          	jal	4d66 <link>
    fd = open("", O_CREATE);
    34c6:	20000593          	li	a1,512
    34ca:	8526                	mv	a0,s1
    34cc:	07b010ef          	jal	4d46 <open>
    if(fd >= 0)
    34d0:	fc0553e3          	bgez	a0,3496 <iref+0x64>
    fd = open("xx", O_CREATE);
    34d4:	20000593          	li	a1,512
    34d8:	854e                	mv	a0,s3
    34da:	06d010ef          	jal	4d46 <open>
    if(fd >= 0)
    34de:	fa054fe3          	bltz	a0,349c <iref+0x6a>
      close(fd);
    34e2:	04d010ef          	jal	4d2e <close>
    34e6:	bf5d                	j	349c <iref+0x6a>
    34e8:	03300493          	li	s1,51
    chdir("..");
    34ec:	00003997          	auipc	s3,0x3
    34f0:	03498993          	add	s3,s3,52 # 6520 <malloc+0x1324>
    unlink("irefd");
    34f4:	00004917          	auipc	s2,0x4
    34f8:	80c90913          	add	s2,s2,-2036 # 6d00 <malloc+0x1b04>
    chdir("..");
    34fc:	854e                	mv	a0,s3
    34fe:	079010ef          	jal	4d76 <chdir>
    unlink("irefd");
    3502:	854a                	mv	a0,s2
    3504:	053010ef          	jal	4d56 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    3508:	34fd                	addw	s1,s1,-1
    350a:	f8ed                	bnez	s1,34fc <iref+0xca>
  chdir("/");
    350c:	00003517          	auipc	a0,0x3
    3510:	fbc50513          	add	a0,a0,-68 # 64c8 <malloc+0x12cc>
    3514:	063010ef          	jal	4d76 <chdir>
}
    3518:	70e2                	ld	ra,56(sp)
    351a:	7442                	ld	s0,48(sp)
    351c:	74a2                	ld	s1,40(sp)
    351e:	7902                	ld	s2,32(sp)
    3520:	69e2                	ld	s3,24(sp)
    3522:	6a42                	ld	s4,16(sp)
    3524:	6aa2                	ld	s5,8(sp)
    3526:	6b02                	ld	s6,0(sp)
    3528:	6121                	add	sp,sp,64
    352a:	8082                	ret

000000000000352c <openiputtest>:
{
    352c:	7179                	add	sp,sp,-48
    352e:	f406                	sd	ra,40(sp)
    3530:	f022                	sd	s0,32(sp)
    3532:	ec26                	sd	s1,24(sp)
    3534:	1800                	add	s0,sp,48
    3536:	84aa                	mv	s1,a0
  if(mkdir("oidir") < 0){
    3538:	00004517          	auipc	a0,0x4
    353c:	80050513          	add	a0,a0,-2048 # 6d38 <malloc+0x1b3c>
    3540:	02f010ef          	jal	4d6e <mkdir>
    3544:	02054a63          	bltz	a0,3578 <openiputtest+0x4c>
  pid = fork();
    3548:	7b6010ef          	jal	4cfe <fork>
  if(pid < 0){
    354c:	04054063          	bltz	a0,358c <openiputtest+0x60>
  if(pid == 0){
    3550:	e939                	bnez	a0,35a6 <openiputtest+0x7a>
    int fd = open("oidir", O_RDWR);
    3552:	4589                	li	a1,2
    3554:	00003517          	auipc	a0,0x3
    3558:	7e450513          	add	a0,a0,2020 # 6d38 <malloc+0x1b3c>
    355c:	7ea010ef          	jal	4d46 <open>
    if(fd >= 0){
    3560:	04054063          	bltz	a0,35a0 <openiputtest+0x74>
      printf("%s: open directory for write succeeded\n", s);
    3564:	85a6                	mv	a1,s1
    3566:	00003517          	auipc	a0,0x3
    356a:	7f250513          	add	a0,a0,2034 # 6d58 <malloc+0x1b5c>
    356e:	3db010ef          	jal	5148 <printf>
      exit(1);
    3572:	4505                	li	a0,1
    3574:	792010ef          	jal	4d06 <exit>
    printf("%s: mkdir oidir failed\n", s);
    3578:	85a6                	mv	a1,s1
    357a:	00003517          	auipc	a0,0x3
    357e:	7c650513          	add	a0,a0,1990 # 6d40 <malloc+0x1b44>
    3582:	3c7010ef          	jal	5148 <printf>
    exit(1);
    3586:	4505                	li	a0,1
    3588:	77e010ef          	jal	4d06 <exit>
    printf("%s: fork failed\n", s);
    358c:	85a6                	mv	a1,s1
    358e:	00002517          	auipc	a0,0x2
    3592:	61a50513          	add	a0,a0,1562 # 5ba8 <malloc+0x9ac>
    3596:	3b3010ef          	jal	5148 <printf>
    exit(1);
    359a:	4505                	li	a0,1
    359c:	76a010ef          	jal	4d06 <exit>
    exit(0);
    35a0:	4501                	li	a0,0
    35a2:	764010ef          	jal	4d06 <exit>
  pause(1);
    35a6:	4505                	li	a0,1
    35a8:	7ee010ef          	jal	4d96 <pause>
  if(unlink("oidir") != 0){
    35ac:	00003517          	auipc	a0,0x3
    35b0:	78c50513          	add	a0,a0,1932 # 6d38 <malloc+0x1b3c>
    35b4:	7a2010ef          	jal	4d56 <unlink>
    35b8:	c919                	beqz	a0,35ce <openiputtest+0xa2>
    printf("%s: unlink failed\n", s);
    35ba:	85a6                	mv	a1,s1
    35bc:	00002517          	auipc	a0,0x2
    35c0:	7dc50513          	add	a0,a0,2012 # 5d98 <malloc+0xb9c>
    35c4:	385010ef          	jal	5148 <printf>
    exit(1);
    35c8:	4505                	li	a0,1
    35ca:	73c010ef          	jal	4d06 <exit>
  wait(&xstatus);
    35ce:	fdc40513          	add	a0,s0,-36
    35d2:	73c010ef          	jal	4d0e <wait>
  exit(xstatus);
    35d6:	fdc42503          	lw	a0,-36(s0)
    35da:	72c010ef          	jal	4d06 <exit>

00000000000035de <forkforkfork>:
{
    35de:	1101                	add	sp,sp,-32
    35e0:	ec06                	sd	ra,24(sp)
    35e2:	e822                	sd	s0,16(sp)
    35e4:	e426                	sd	s1,8(sp)
    35e6:	1000                	add	s0,sp,32
    35e8:	84aa                	mv	s1,a0
  unlink("stopforking");
    35ea:	00003517          	auipc	a0,0x3
    35ee:	79650513          	add	a0,a0,1942 # 6d80 <malloc+0x1b84>
    35f2:	764010ef          	jal	4d56 <unlink>
  int pid = fork();
    35f6:	708010ef          	jal	4cfe <fork>
  if(pid < 0){
    35fa:	02054b63          	bltz	a0,3630 <forkforkfork+0x52>
  if(pid == 0){
    35fe:	c139                	beqz	a0,3644 <forkforkfork+0x66>
  pause(20); // two seconds
    3600:	4551                	li	a0,20
    3602:	794010ef          	jal	4d96 <pause>
  close(open("stopforking", O_CREATE|O_RDWR));
    3606:	20200593          	li	a1,514
    360a:	00003517          	auipc	a0,0x3
    360e:	77650513          	add	a0,a0,1910 # 6d80 <malloc+0x1b84>
    3612:	734010ef          	jal	4d46 <open>
    3616:	718010ef          	jal	4d2e <close>
  wait(0);
    361a:	4501                	li	a0,0
    361c:	6f2010ef          	jal	4d0e <wait>
  pause(10); // one second
    3620:	4529                	li	a0,10
    3622:	774010ef          	jal	4d96 <pause>
}
    3626:	60e2                	ld	ra,24(sp)
    3628:	6442                	ld	s0,16(sp)
    362a:	64a2                	ld	s1,8(sp)
    362c:	6105                	add	sp,sp,32
    362e:	8082                	ret
    printf("%s: fork failed", s);
    3630:	85a6                	mv	a1,s1
    3632:	00002517          	auipc	a0,0x2
    3636:	73650513          	add	a0,a0,1846 # 5d68 <malloc+0xb6c>
    363a:	30f010ef          	jal	5148 <printf>
    exit(1);
    363e:	4505                	li	a0,1
    3640:	6c6010ef          	jal	4d06 <exit>
      int fd = open("stopforking", 0);
    3644:	00003497          	auipc	s1,0x3
    3648:	73c48493          	add	s1,s1,1852 # 6d80 <malloc+0x1b84>
    364c:	4581                	li	a1,0
    364e:	8526                	mv	a0,s1
    3650:	6f6010ef          	jal	4d46 <open>
      if(fd >= 0){
    3654:	02055163          	bgez	a0,3676 <forkforkfork+0x98>
      if(fork() < 0){
    3658:	6a6010ef          	jal	4cfe <fork>
    365c:	fe0558e3          	bgez	a0,364c <forkforkfork+0x6e>
        close(open("stopforking", O_CREATE|O_RDWR));
    3660:	20200593          	li	a1,514
    3664:	00003517          	auipc	a0,0x3
    3668:	71c50513          	add	a0,a0,1820 # 6d80 <malloc+0x1b84>
    366c:	6da010ef          	jal	4d46 <open>
    3670:	6be010ef          	jal	4d2e <close>
    3674:	bfe1                	j	364c <forkforkfork+0x6e>
        exit(0);
    3676:	4501                	li	a0,0
    3678:	68e010ef          	jal	4d06 <exit>

000000000000367c <killstatus>:
{
    367c:	7139                	add	sp,sp,-64
    367e:	fc06                	sd	ra,56(sp)
    3680:	f822                	sd	s0,48(sp)
    3682:	f426                	sd	s1,40(sp)
    3684:	f04a                	sd	s2,32(sp)
    3686:	ec4e                	sd	s3,24(sp)
    3688:	e852                	sd	s4,16(sp)
    368a:	0080                	add	s0,sp,64
    368c:	8a2a                	mv	s4,a0
    368e:	06400913          	li	s2,100
    if(xst != -1) {
    3692:	59fd                	li	s3,-1
    int pid1 = fork();
    3694:	66a010ef          	jal	4cfe <fork>
    3698:	84aa                	mv	s1,a0
    if(pid1 < 0){
    369a:	02054763          	bltz	a0,36c8 <killstatus+0x4c>
    if(pid1 == 0){
    369e:	cd1d                	beqz	a0,36dc <killstatus+0x60>
    pause(1);
    36a0:	4505                	li	a0,1
    36a2:	6f4010ef          	jal	4d96 <pause>
    kill(pid1);
    36a6:	8526                	mv	a0,s1
    36a8:	68e010ef          	jal	4d36 <kill>
    wait(&xst);
    36ac:	fcc40513          	add	a0,s0,-52
    36b0:	65e010ef          	jal	4d0e <wait>
    if(xst != -1) {
    36b4:	fcc42783          	lw	a5,-52(s0)
    36b8:	03379563          	bne	a5,s3,36e2 <killstatus+0x66>
  for(int i = 0; i < 100; i++){
    36bc:	397d                	addw	s2,s2,-1
    36be:	fc091be3          	bnez	s2,3694 <killstatus+0x18>
  exit(0);
    36c2:	4501                	li	a0,0
    36c4:	642010ef          	jal	4d06 <exit>
      printf("%s: fork failed\n", s);
    36c8:	85d2                	mv	a1,s4
    36ca:	00002517          	auipc	a0,0x2
    36ce:	4de50513          	add	a0,a0,1246 # 5ba8 <malloc+0x9ac>
    36d2:	277010ef          	jal	5148 <printf>
      exit(1);
    36d6:	4505                	li	a0,1
    36d8:	62e010ef          	jal	4d06 <exit>
        getpid();
    36dc:	6aa010ef          	jal	4d86 <getpid>
      while(1) {
    36e0:	bff5                	j	36dc <killstatus+0x60>
       printf("%s: status should be -1\n", s);
    36e2:	85d2                	mv	a1,s4
    36e4:	00003517          	auipc	a0,0x3
    36e8:	6ac50513          	add	a0,a0,1708 # 6d90 <malloc+0x1b94>
    36ec:	25d010ef          	jal	5148 <printf>
       exit(1);
    36f0:	4505                	li	a0,1
    36f2:	614010ef          	jal	4d06 <exit>

00000000000036f6 <preempt>:
{
    36f6:	7139                	add	sp,sp,-64
    36f8:	fc06                	sd	ra,56(sp)
    36fa:	f822                	sd	s0,48(sp)
    36fc:	f426                	sd	s1,40(sp)
    36fe:	f04a                	sd	s2,32(sp)
    3700:	ec4e                	sd	s3,24(sp)
    3702:	e852                	sd	s4,16(sp)
    3704:	0080                	add	s0,sp,64
    3706:	892a                	mv	s2,a0
  pid1 = fork();
    3708:	5f6010ef          	jal	4cfe <fork>
  if(pid1 < 0) {
    370c:	00054563          	bltz	a0,3716 <preempt+0x20>
    3710:	84aa                	mv	s1,a0
  if(pid1 == 0)
    3712:	ed01                	bnez	a0,372a <preempt+0x34>
    for(;;)
    3714:	a001                	j	3714 <preempt+0x1e>
    printf("%s: fork failed", s);
    3716:	85ca                	mv	a1,s2
    3718:	00002517          	auipc	a0,0x2
    371c:	65050513          	add	a0,a0,1616 # 5d68 <malloc+0xb6c>
    3720:	229010ef          	jal	5148 <printf>
    exit(1);
    3724:	4505                	li	a0,1
    3726:	5e0010ef          	jal	4d06 <exit>
  pid2 = fork();
    372a:	5d4010ef          	jal	4cfe <fork>
    372e:	89aa                	mv	s3,a0
  if(pid2 < 0) {
    3730:	00054463          	bltz	a0,3738 <preempt+0x42>
  if(pid2 == 0)
    3734:	ed01                	bnez	a0,374c <preempt+0x56>
    for(;;)
    3736:	a001                	j	3736 <preempt+0x40>
    printf("%s: fork failed\n", s);
    3738:	85ca                	mv	a1,s2
    373a:	00002517          	auipc	a0,0x2
    373e:	46e50513          	add	a0,a0,1134 # 5ba8 <malloc+0x9ac>
    3742:	207010ef          	jal	5148 <printf>
    exit(1);
    3746:	4505                	li	a0,1
    3748:	5be010ef          	jal	4d06 <exit>
  pipe(pfds);
    374c:	fc840513          	add	a0,s0,-56
    3750:	5c6010ef          	jal	4d16 <pipe>
  pid3 = fork();
    3754:	5aa010ef          	jal	4cfe <fork>
    3758:	8a2a                	mv	s4,a0
  if(pid3 < 0) {
    375a:	02054863          	bltz	a0,378a <preempt+0x94>
  if(pid3 == 0){
    375e:	e921                	bnez	a0,37ae <preempt+0xb8>
    close(pfds[0]);
    3760:	fc842503          	lw	a0,-56(s0)
    3764:	5ca010ef          	jal	4d2e <close>
    if(write(pfds[1], "x", 1) != 1)
    3768:	4605                	li	a2,1
    376a:	00002597          	auipc	a1,0x2
    376e:	c1e58593          	add	a1,a1,-994 # 5388 <malloc+0x18c>
    3772:	fcc42503          	lw	a0,-52(s0)
    3776:	5b0010ef          	jal	4d26 <write>
    377a:	4785                	li	a5,1
    377c:	02f51163          	bne	a0,a5,379e <preempt+0xa8>
    close(pfds[1]);
    3780:	fcc42503          	lw	a0,-52(s0)
    3784:	5aa010ef          	jal	4d2e <close>
    for(;;)
    3788:	a001                	j	3788 <preempt+0x92>
     printf("%s: fork failed\n", s);
    378a:	85ca                	mv	a1,s2
    378c:	00002517          	auipc	a0,0x2
    3790:	41c50513          	add	a0,a0,1052 # 5ba8 <malloc+0x9ac>
    3794:	1b5010ef          	jal	5148 <printf>
     exit(1);
    3798:	4505                	li	a0,1
    379a:	56c010ef          	jal	4d06 <exit>
      printf("%s: preempt write error", s);
    379e:	85ca                	mv	a1,s2
    37a0:	00003517          	auipc	a0,0x3
    37a4:	61050513          	add	a0,a0,1552 # 6db0 <malloc+0x1bb4>
    37a8:	1a1010ef          	jal	5148 <printf>
    37ac:	bfd1                	j	3780 <preempt+0x8a>
  close(pfds[1]);
    37ae:	fcc42503          	lw	a0,-52(s0)
    37b2:	57c010ef          	jal	4d2e <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
    37b6:	660d                	lui	a2,0x3
    37b8:	00008597          	auipc	a1,0x8
    37bc:	50058593          	add	a1,a1,1280 # bcb8 <buf>
    37c0:	fc842503          	lw	a0,-56(s0)
    37c4:	55a010ef          	jal	4d1e <read>
    37c8:	4785                	li	a5,1
    37ca:	02f50163          	beq	a0,a5,37ec <preempt+0xf6>
    printf("%s: preempt read error", s);
    37ce:	85ca                	mv	a1,s2
    37d0:	00003517          	auipc	a0,0x3
    37d4:	5f850513          	add	a0,a0,1528 # 6dc8 <malloc+0x1bcc>
    37d8:	171010ef          	jal	5148 <printf>
}
    37dc:	70e2                	ld	ra,56(sp)
    37de:	7442                	ld	s0,48(sp)
    37e0:	74a2                	ld	s1,40(sp)
    37e2:	7902                	ld	s2,32(sp)
    37e4:	69e2                	ld	s3,24(sp)
    37e6:	6a42                	ld	s4,16(sp)
    37e8:	6121                	add	sp,sp,64
    37ea:	8082                	ret
  close(pfds[0]);
    37ec:	fc842503          	lw	a0,-56(s0)
    37f0:	53e010ef          	jal	4d2e <close>
  printf("kill... ");
    37f4:	00003517          	auipc	a0,0x3
    37f8:	5ec50513          	add	a0,a0,1516 # 6de0 <malloc+0x1be4>
    37fc:	14d010ef          	jal	5148 <printf>
  kill(pid1);
    3800:	8526                	mv	a0,s1
    3802:	534010ef          	jal	4d36 <kill>
  kill(pid2);
    3806:	854e                	mv	a0,s3
    3808:	52e010ef          	jal	4d36 <kill>
  kill(pid3);
    380c:	8552                	mv	a0,s4
    380e:	528010ef          	jal	4d36 <kill>
  printf("wait... ");
    3812:	00003517          	auipc	a0,0x3
    3816:	5de50513          	add	a0,a0,1502 # 6df0 <malloc+0x1bf4>
    381a:	12f010ef          	jal	5148 <printf>
  wait(0);
    381e:	4501                	li	a0,0
    3820:	4ee010ef          	jal	4d0e <wait>
  wait(0);
    3824:	4501                	li	a0,0
    3826:	4e8010ef          	jal	4d0e <wait>
  wait(0);
    382a:	4501                	li	a0,0
    382c:	4e2010ef          	jal	4d0e <wait>
    3830:	b775                	j	37dc <preempt+0xe6>

0000000000003832 <reparent>:
{
    3832:	7179                	add	sp,sp,-48
    3834:	f406                	sd	ra,40(sp)
    3836:	f022                	sd	s0,32(sp)
    3838:	ec26                	sd	s1,24(sp)
    383a:	e84a                	sd	s2,16(sp)
    383c:	e44e                	sd	s3,8(sp)
    383e:	e052                	sd	s4,0(sp)
    3840:	1800                	add	s0,sp,48
    3842:	89aa                	mv	s3,a0
  int master_pid = getpid();
    3844:	542010ef          	jal	4d86 <getpid>
    3848:	8a2a                	mv	s4,a0
    384a:	0c800913          	li	s2,200
    int pid = fork();
    384e:	4b0010ef          	jal	4cfe <fork>
    3852:	84aa                	mv	s1,a0
    if(pid < 0){
    3854:	00054e63          	bltz	a0,3870 <reparent+0x3e>
    if(pid){
    3858:	c121                	beqz	a0,3898 <reparent+0x66>
      if(wait(0) != pid){
    385a:	4501                	li	a0,0
    385c:	4b2010ef          	jal	4d0e <wait>
    3860:	02951263          	bne	a0,s1,3884 <reparent+0x52>
  for(int i = 0; i < 200; i++){
    3864:	397d                	addw	s2,s2,-1
    3866:	fe0914e3          	bnez	s2,384e <reparent+0x1c>
  exit(0);
    386a:	4501                	li	a0,0
    386c:	49a010ef          	jal	4d06 <exit>
      printf("%s: fork failed\n", s);
    3870:	85ce                	mv	a1,s3
    3872:	00002517          	auipc	a0,0x2
    3876:	33650513          	add	a0,a0,822 # 5ba8 <malloc+0x9ac>
    387a:	0cf010ef          	jal	5148 <printf>
      exit(1);
    387e:	4505                	li	a0,1
    3880:	486010ef          	jal	4d06 <exit>
        printf("%s: wait wrong pid\n", s);
    3884:	85ce                	mv	a1,s3
    3886:	00002517          	auipc	a0,0x2
    388a:	4aa50513          	add	a0,a0,1194 # 5d30 <malloc+0xb34>
    388e:	0bb010ef          	jal	5148 <printf>
        exit(1);
    3892:	4505                	li	a0,1
    3894:	472010ef          	jal	4d06 <exit>
      int pid2 = fork();
    3898:	466010ef          	jal	4cfe <fork>
      if(pid2 < 0){
    389c:	00054563          	bltz	a0,38a6 <reparent+0x74>
      exit(0);
    38a0:	4501                	li	a0,0
    38a2:	464010ef          	jal	4d06 <exit>
        kill(master_pid);
    38a6:	8552                	mv	a0,s4
    38a8:	48e010ef          	jal	4d36 <kill>
        exit(1);
    38ac:	4505                	li	a0,1
    38ae:	458010ef          	jal	4d06 <exit>

00000000000038b2 <sbrkfail>:
{
    38b2:	7175                	add	sp,sp,-144
    38b4:	e506                	sd	ra,136(sp)
    38b6:	e122                	sd	s0,128(sp)
    38b8:	fca6                	sd	s1,120(sp)
    38ba:	f8ca                	sd	s2,112(sp)
    38bc:	f4ce                	sd	s3,104(sp)
    38be:	f0d2                	sd	s4,96(sp)
    38c0:	ecd6                	sd	s5,88(sp)
    38c2:	e8da                	sd	s6,80(sp)
    38c4:	e4de                	sd	s7,72(sp)
    38c6:	0900                	add	s0,sp,144
    38c8:	8b2a                	mv	s6,a0
  if(pipe(fds) != 0){
    38ca:	fa040513          	add	a0,s0,-96
    38ce:	448010ef          	jal	4d16 <pipe>
    38d2:	e919                	bnez	a0,38e8 <sbrkfail+0x36>
    38d4:	8aaa                	mv	s5,a0
    38d6:	f7040493          	add	s1,s0,-144
    38da:	f9840993          	add	s3,s0,-104
    38de:	8926                	mv	s2,s1
    if(pids[i] != -1) {
    38e0:	5a7d                	li	s4,-1
      if(scratch == '0')
    38e2:	03000b93          	li	s7,48
    38e6:	a08d                	j	3948 <sbrkfail+0x96>
    printf("%s: pipe() failed\n", s);
    38e8:	85da                	mv	a1,s6
    38ea:	00002517          	auipc	a0,0x2
    38ee:	3c650513          	add	a0,a0,966 # 5cb0 <malloc+0xab4>
    38f2:	057010ef          	jal	5148 <printf>
    exit(1);
    38f6:	4505                	li	a0,1
    38f8:	40e010ef          	jal	4d06 <exit>
      if (sbrk(BIG - (uint64)sbrk(0)) ==  (char*)SBRK_ERROR)
    38fc:	3d6010ef          	jal	4cd2 <sbrk>
    3900:	064007b7          	lui	a5,0x6400
    3904:	40a7853b          	subw	a0,a5,a0
    3908:	3ca010ef          	jal	4cd2 <sbrk>
    390c:	57fd                	li	a5,-1
    390e:	02f50063          	beq	a0,a5,392e <sbrkfail+0x7c>
        write(fds[1], "1", 1);
    3912:	4605                	li	a2,1
    3914:	00004597          	auipc	a1,0x4
    3918:	c6458593          	add	a1,a1,-924 # 7578 <malloc+0x237c>
    391c:	fa442503          	lw	a0,-92(s0)
    3920:	406010ef          	jal	4d26 <write>
      for(;;) pause(1000);
    3924:	3e800513          	li	a0,1000
    3928:	46e010ef          	jal	4d96 <pause>
    392c:	bfe5                	j	3924 <sbrkfail+0x72>
        write(fds[1], "0", 1);
    392e:	4605                	li	a2,1
    3930:	00003597          	auipc	a1,0x3
    3934:	4d058593          	add	a1,a1,1232 # 6e00 <malloc+0x1c04>
    3938:	fa442503          	lw	a0,-92(s0)
    393c:	3ea010ef          	jal	4d26 <write>
    3940:	b7d5                	j	3924 <sbrkfail+0x72>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    3942:	0911                	add	s2,s2,4
    3944:	03390663          	beq	s2,s3,3970 <sbrkfail+0xbe>
    if((pids[i] = fork()) == 0){
    3948:	3b6010ef          	jal	4cfe <fork>
    394c:	00a92023          	sw	a0,0(s2)
    3950:	d555                	beqz	a0,38fc <sbrkfail+0x4a>
    if(pids[i] != -1) {
    3952:	ff4508e3          	beq	a0,s4,3942 <sbrkfail+0x90>
      read(fds[0], &scratch, 1);
    3956:	4605                	li	a2,1
    3958:	f9f40593          	add	a1,s0,-97
    395c:	fa042503          	lw	a0,-96(s0)
    3960:	3be010ef          	jal	4d1e <read>
      if(scratch == '0')
    3964:	f9f44783          	lbu	a5,-97(s0)
    3968:	fd779de3          	bne	a5,s7,3942 <sbrkfail+0x90>
        failed = 1;
    396c:	4a85                	li	s5,1
    396e:	bfd1                	j	3942 <sbrkfail+0x90>
  if(!failed) {
    3970:	000a8863          	beqz	s5,3980 <sbrkfail+0xce>
  c = sbrk(PGSIZE);
    3974:	6505                	lui	a0,0x1
    3976:	35c010ef          	jal	4cd2 <sbrk>
    397a:	8a2a                	mv	s4,a0
    if(pids[i] == -1)
    397c:	597d                	li	s2,-1
    397e:	a821                	j	3996 <sbrkfail+0xe4>
    printf("%s: no allocation failed; allocate more?\n", s);
    3980:	85da                	mv	a1,s6
    3982:	00003517          	auipc	a0,0x3
    3986:	48650513          	add	a0,a0,1158 # 6e08 <malloc+0x1c0c>
    398a:	7be010ef          	jal	5148 <printf>
    398e:	b7dd                	j	3974 <sbrkfail+0xc2>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    3990:	0491                	add	s1,s1,4
    3992:	01348b63          	beq	s1,s3,39a8 <sbrkfail+0xf6>
    if(pids[i] == -1)
    3996:	4088                	lw	a0,0(s1)
    3998:	ff250ce3          	beq	a0,s2,3990 <sbrkfail+0xde>
    kill(pids[i]);
    399c:	39a010ef          	jal	4d36 <kill>
    wait(0);
    39a0:	4501                	li	a0,0
    39a2:	36c010ef          	jal	4d0e <wait>
    39a6:	b7ed                	j	3990 <sbrkfail+0xde>
  if(c == (char*)SBRK_ERROR){
    39a8:	57fd                	li	a5,-1
    39aa:	02fa0a63          	beq	s4,a5,39de <sbrkfail+0x12c>
  pid = fork();
    39ae:	350010ef          	jal	4cfe <fork>
  if(pid < 0){
    39b2:	04054063          	bltz	a0,39f2 <sbrkfail+0x140>
  if(pid == 0){
    39b6:	e939                	bnez	a0,3a0c <sbrkfail+0x15a>
    a = sbrk(10*BIG);
    39b8:	3e800537          	lui	a0,0x3e800
    39bc:	316010ef          	jal	4cd2 <sbrk>
    if(a == (char*)SBRK_ERROR){
    39c0:	57fd                	li	a5,-1
    39c2:	04f50263          	beq	a0,a5,3a06 <sbrkfail+0x154>
    printf("%s: allocate a lot of memory succeeded %d\n", s, 10*BIG);
    39c6:	3e800637          	lui	a2,0x3e800
    39ca:	85da                	mv	a1,s6
    39cc:	00003517          	auipc	a0,0x3
    39d0:	48c50513          	add	a0,a0,1164 # 6e58 <malloc+0x1c5c>
    39d4:	774010ef          	jal	5148 <printf>
    exit(1);
    39d8:	4505                	li	a0,1
    39da:	32c010ef          	jal	4d06 <exit>
    printf("%s: failed sbrk leaked memory\n", s);
    39de:	85da                	mv	a1,s6
    39e0:	00003517          	auipc	a0,0x3
    39e4:	45850513          	add	a0,a0,1112 # 6e38 <malloc+0x1c3c>
    39e8:	760010ef          	jal	5148 <printf>
    exit(1);
    39ec:	4505                	li	a0,1
    39ee:	318010ef          	jal	4d06 <exit>
    printf("%s: fork failed\n", s);
    39f2:	85da                	mv	a1,s6
    39f4:	00002517          	auipc	a0,0x2
    39f8:	1b450513          	add	a0,a0,436 # 5ba8 <malloc+0x9ac>
    39fc:	74c010ef          	jal	5148 <printf>
    exit(1);
    3a00:	4505                	li	a0,1
    3a02:	304010ef          	jal	4d06 <exit>
      exit(0);
    3a06:	4501                	li	a0,0
    3a08:	2fe010ef          	jal	4d06 <exit>
  wait(&xstatus);
    3a0c:	fac40513          	add	a0,s0,-84
    3a10:	2fe010ef          	jal	4d0e <wait>
  if(xstatus != 0)
    3a14:	fac42783          	lw	a5,-84(s0)
    3a18:	ef81                	bnez	a5,3a30 <sbrkfail+0x17e>
}
    3a1a:	60aa                	ld	ra,136(sp)
    3a1c:	640a                	ld	s0,128(sp)
    3a1e:	74e6                	ld	s1,120(sp)
    3a20:	7946                	ld	s2,112(sp)
    3a22:	79a6                	ld	s3,104(sp)
    3a24:	7a06                	ld	s4,96(sp)
    3a26:	6ae6                	ld	s5,88(sp)
    3a28:	6b46                	ld	s6,80(sp)
    3a2a:	6ba6                	ld	s7,72(sp)
    3a2c:	6149                	add	sp,sp,144
    3a2e:	8082                	ret
    exit(1);
    3a30:	4505                	li	a0,1
    3a32:	2d4010ef          	jal	4d06 <exit>

0000000000003a36 <mem>:
{
    3a36:	7139                	add	sp,sp,-64
    3a38:	fc06                	sd	ra,56(sp)
    3a3a:	f822                	sd	s0,48(sp)
    3a3c:	f426                	sd	s1,40(sp)
    3a3e:	f04a                	sd	s2,32(sp)
    3a40:	ec4e                	sd	s3,24(sp)
    3a42:	0080                	add	s0,sp,64
    3a44:	89aa                	mv	s3,a0
  if((pid = fork()) == 0){
    3a46:	2b8010ef          	jal	4cfe <fork>
    m1 = 0;
    3a4a:	4481                	li	s1,0
    while((m2 = malloc(10001)) != 0){
    3a4c:	6909                	lui	s2,0x2
    3a4e:	71190913          	add	s2,s2,1809 # 2711 <fourteen+0xeb>
  if((pid = fork()) == 0){
    3a52:	cd11                	beqz	a0,3a6e <mem+0x38>
    wait(&xstatus);
    3a54:	fcc40513          	add	a0,s0,-52
    3a58:	2b6010ef          	jal	4d0e <wait>
    if(xstatus == -1){
    3a5c:	fcc42503          	lw	a0,-52(s0)
    3a60:	57fd                	li	a5,-1
    3a62:	04f50363          	beq	a0,a5,3aa8 <mem+0x72>
    exit(xstatus);
    3a66:	2a0010ef          	jal	4d06 <exit>
      *(char**)m2 = m1;
    3a6a:	e104                	sd	s1,0(a0)
      m1 = m2;
    3a6c:	84aa                	mv	s1,a0
    while((m2 = malloc(10001)) != 0){
    3a6e:	854a                	mv	a0,s2
    3a70:	78c010ef          	jal	51fc <malloc>
    3a74:	f97d                	bnez	a0,3a6a <mem+0x34>
    while(m1){
    3a76:	c491                	beqz	s1,3a82 <mem+0x4c>
      m2 = *(char**)m1;
    3a78:	8526                	mv	a0,s1
    3a7a:	6084                	ld	s1,0(s1)
      free(m1);
    3a7c:	6fe010ef          	jal	517a <free>
    while(m1){
    3a80:	fce5                	bnez	s1,3a78 <mem+0x42>
    m1 = malloc(1024*20);
    3a82:	6515                	lui	a0,0x5
    3a84:	778010ef          	jal	51fc <malloc>
    if(m1 == 0){
    3a88:	c511                	beqz	a0,3a94 <mem+0x5e>
    free(m1);
    3a8a:	6f0010ef          	jal	517a <free>
    exit(0);
    3a8e:	4501                	li	a0,0
    3a90:	276010ef          	jal	4d06 <exit>
      printf("%s: couldn't allocate mem?!!\n", s);
    3a94:	85ce                	mv	a1,s3
    3a96:	00003517          	auipc	a0,0x3
    3a9a:	3f250513          	add	a0,a0,1010 # 6e88 <malloc+0x1c8c>
    3a9e:	6aa010ef          	jal	5148 <printf>
      exit(1);
    3aa2:	4505                	li	a0,1
    3aa4:	262010ef          	jal	4d06 <exit>
      exit(0);
    3aa8:	4501                	li	a0,0
    3aaa:	25c010ef          	jal	4d06 <exit>

0000000000003aae <sharedfd>:
{
    3aae:	7159                	add	sp,sp,-112
    3ab0:	f486                	sd	ra,104(sp)
    3ab2:	f0a2                	sd	s0,96(sp)
    3ab4:	eca6                	sd	s1,88(sp)
    3ab6:	e8ca                	sd	s2,80(sp)
    3ab8:	e4ce                	sd	s3,72(sp)
    3aba:	e0d2                	sd	s4,64(sp)
    3abc:	fc56                	sd	s5,56(sp)
    3abe:	f85a                	sd	s6,48(sp)
    3ac0:	f45e                	sd	s7,40(sp)
    3ac2:	1880                	add	s0,sp,112
    3ac4:	8a2a                	mv	s4,a0
  unlink("sharedfd");
    3ac6:	00003517          	auipc	a0,0x3
    3aca:	3e250513          	add	a0,a0,994 # 6ea8 <malloc+0x1cac>
    3ace:	288010ef          	jal	4d56 <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
    3ad2:	20200593          	li	a1,514
    3ad6:	00003517          	auipc	a0,0x3
    3ada:	3d250513          	add	a0,a0,978 # 6ea8 <malloc+0x1cac>
    3ade:	268010ef          	jal	4d46 <open>
  if(fd < 0){
    3ae2:	04054263          	bltz	a0,3b26 <sharedfd+0x78>
    3ae6:	892a                	mv	s2,a0
  pid = fork();
    3ae8:	216010ef          	jal	4cfe <fork>
    3aec:	89aa                	mv	s3,a0
  memset(buf, pid==0?'c':'p', sizeof(buf));
    3aee:	07000593          	li	a1,112
    3af2:	e119                	bnez	a0,3af8 <sharedfd+0x4a>
    3af4:	06300593          	li	a1,99
    3af8:	4629                	li	a2,10
    3afa:	fa040513          	add	a0,s0,-96
    3afe:	7f7000ef          	jal	4af4 <memset>
    3b02:	3e800493          	li	s1,1000
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
    3b06:	4629                	li	a2,10
    3b08:	fa040593          	add	a1,s0,-96
    3b0c:	854a                	mv	a0,s2
    3b0e:	218010ef          	jal	4d26 <write>
    3b12:	47a9                	li	a5,10
    3b14:	02f51363          	bne	a0,a5,3b3a <sharedfd+0x8c>
  for(i = 0; i < N; i++){
    3b18:	34fd                	addw	s1,s1,-1
    3b1a:	f4f5                	bnez	s1,3b06 <sharedfd+0x58>
  if(pid == 0) {
    3b1c:	02099963          	bnez	s3,3b4e <sharedfd+0xa0>
    exit(0);
    3b20:	4501                	li	a0,0
    3b22:	1e4010ef          	jal	4d06 <exit>
    printf("%s: cannot open sharedfd for writing", s);
    3b26:	85d2                	mv	a1,s4
    3b28:	00003517          	auipc	a0,0x3
    3b2c:	39050513          	add	a0,a0,912 # 6eb8 <malloc+0x1cbc>
    3b30:	618010ef          	jal	5148 <printf>
    exit(1);
    3b34:	4505                	li	a0,1
    3b36:	1d0010ef          	jal	4d06 <exit>
      printf("%s: write sharedfd failed\n", s);
    3b3a:	85d2                	mv	a1,s4
    3b3c:	00003517          	auipc	a0,0x3
    3b40:	3a450513          	add	a0,a0,932 # 6ee0 <malloc+0x1ce4>
    3b44:	604010ef          	jal	5148 <printf>
      exit(1);
    3b48:	4505                	li	a0,1
    3b4a:	1bc010ef          	jal	4d06 <exit>
    wait(&xstatus);
    3b4e:	f9c40513          	add	a0,s0,-100
    3b52:	1bc010ef          	jal	4d0e <wait>
    if(xstatus != 0)
    3b56:	f9c42983          	lw	s3,-100(s0)
    3b5a:	00098563          	beqz	s3,3b64 <sharedfd+0xb6>
      exit(xstatus);
    3b5e:	854e                	mv	a0,s3
    3b60:	1a6010ef          	jal	4d06 <exit>
  close(fd);
    3b64:	854a                	mv	a0,s2
    3b66:	1c8010ef          	jal	4d2e <close>
  fd = open("sharedfd", 0);
    3b6a:	4581                	li	a1,0
    3b6c:	00003517          	auipc	a0,0x3
    3b70:	33c50513          	add	a0,a0,828 # 6ea8 <malloc+0x1cac>
    3b74:	1d2010ef          	jal	4d46 <open>
    3b78:	8baa                	mv	s7,a0
  nc = np = 0;
    3b7a:	8ace                	mv	s5,s3
  if(fd < 0){
    3b7c:	02054363          	bltz	a0,3ba2 <sharedfd+0xf4>
    3b80:	faa40913          	add	s2,s0,-86
      if(buf[i] == 'c')
    3b84:	06300493          	li	s1,99
      if(buf[i] == 'p')
    3b88:	07000b13          	li	s6,112
  while((n = read(fd, buf, sizeof(buf))) > 0){
    3b8c:	4629                	li	a2,10
    3b8e:	fa040593          	add	a1,s0,-96
    3b92:	855e                	mv	a0,s7
    3b94:	18a010ef          	jal	4d1e <read>
    3b98:	02a05b63          	blez	a0,3bce <sharedfd+0x120>
    3b9c:	fa040793          	add	a5,s0,-96
    3ba0:	a839                	j	3bbe <sharedfd+0x110>
    printf("%s: cannot open sharedfd for reading\n", s);
    3ba2:	85d2                	mv	a1,s4
    3ba4:	00003517          	auipc	a0,0x3
    3ba8:	35c50513          	add	a0,a0,860 # 6f00 <malloc+0x1d04>
    3bac:	59c010ef          	jal	5148 <printf>
    exit(1);
    3bb0:	4505                	li	a0,1
    3bb2:	154010ef          	jal	4d06 <exit>
        nc++;
    3bb6:	2985                	addw	s3,s3,1
    for(i = 0; i < sizeof(buf); i++){
    3bb8:	0785                	add	a5,a5,1 # 6400001 <base+0x63f1349>
    3bba:	fd2789e3          	beq	a5,s2,3b8c <sharedfd+0xde>
      if(buf[i] == 'c')
    3bbe:	0007c703          	lbu	a4,0(a5)
    3bc2:	fe970ae3          	beq	a4,s1,3bb6 <sharedfd+0x108>
      if(buf[i] == 'p')
    3bc6:	ff6719e3          	bne	a4,s6,3bb8 <sharedfd+0x10a>
        np++;
    3bca:	2a85                	addw	s5,s5,1
    3bcc:	b7f5                	j	3bb8 <sharedfd+0x10a>
  close(fd);
    3bce:	855e                	mv	a0,s7
    3bd0:	15e010ef          	jal	4d2e <close>
  unlink("sharedfd");
    3bd4:	00003517          	auipc	a0,0x3
    3bd8:	2d450513          	add	a0,a0,724 # 6ea8 <malloc+0x1cac>
    3bdc:	17a010ef          	jal	4d56 <unlink>
  if(nc == N*SZ && np == N*SZ){
    3be0:	6789                	lui	a5,0x2
    3be2:	71078793          	add	a5,a5,1808 # 2710 <fourteen+0xea>
    3be6:	00f99763          	bne	s3,a5,3bf4 <sharedfd+0x146>
    3bea:	6789                	lui	a5,0x2
    3bec:	71078793          	add	a5,a5,1808 # 2710 <fourteen+0xea>
    3bf0:	00fa8c63          	beq	s5,a5,3c08 <sharedfd+0x15a>
    printf("%s: nc/np test fails\n", s);
    3bf4:	85d2                	mv	a1,s4
    3bf6:	00003517          	auipc	a0,0x3
    3bfa:	33250513          	add	a0,a0,818 # 6f28 <malloc+0x1d2c>
    3bfe:	54a010ef          	jal	5148 <printf>
    exit(1);
    3c02:	4505                	li	a0,1
    3c04:	102010ef          	jal	4d06 <exit>
    exit(0);
    3c08:	4501                	li	a0,0
    3c0a:	0fc010ef          	jal	4d06 <exit>

0000000000003c0e <fourfiles>:
{
    3c0e:	7135                	add	sp,sp,-160
    3c10:	ed06                	sd	ra,152(sp)
    3c12:	e922                	sd	s0,144(sp)
    3c14:	e526                	sd	s1,136(sp)
    3c16:	e14a                	sd	s2,128(sp)
    3c18:	fcce                	sd	s3,120(sp)
    3c1a:	f8d2                	sd	s4,112(sp)
    3c1c:	f4d6                	sd	s5,104(sp)
    3c1e:	f0da                	sd	s6,96(sp)
    3c20:	ecde                	sd	s7,88(sp)
    3c22:	e8e2                	sd	s8,80(sp)
    3c24:	e4e6                	sd	s9,72(sp)
    3c26:	e0ea                	sd	s10,64(sp)
    3c28:	fc6e                	sd	s11,56(sp)
    3c2a:	1100                	add	s0,sp,160
    3c2c:	8caa                	mv	s9,a0
  char *names[] = { "f0", "f1", "f2", "f3" };
    3c2e:	00003797          	auipc	a5,0x3
    3c32:	31278793          	add	a5,a5,786 # 6f40 <malloc+0x1d44>
    3c36:	f6f43823          	sd	a5,-144(s0)
    3c3a:	00003797          	auipc	a5,0x3
    3c3e:	30e78793          	add	a5,a5,782 # 6f48 <malloc+0x1d4c>
    3c42:	f6f43c23          	sd	a5,-136(s0)
    3c46:	00003797          	auipc	a5,0x3
    3c4a:	30a78793          	add	a5,a5,778 # 6f50 <malloc+0x1d54>
    3c4e:	f8f43023          	sd	a5,-128(s0)
    3c52:	00003797          	auipc	a5,0x3
    3c56:	30678793          	add	a5,a5,774 # 6f58 <malloc+0x1d5c>
    3c5a:	f8f43423          	sd	a5,-120(s0)
  for(pi = 0; pi < NCHILD; pi++){
    3c5e:	f7040b93          	add	s7,s0,-144
  char *names[] = { "f0", "f1", "f2", "f3" };
    3c62:	895e                	mv	s2,s7
  for(pi = 0; pi < NCHILD; pi++){
    3c64:	4481                	li	s1,0
    3c66:	4a11                	li	s4,4
    fname = names[pi];
    3c68:	00093983          	ld	s3,0(s2)
    unlink(fname);
    3c6c:	854e                	mv	a0,s3
    3c6e:	0e8010ef          	jal	4d56 <unlink>
    pid = fork();
    3c72:	08c010ef          	jal	4cfe <fork>
    if(pid < 0){
    3c76:	02054e63          	bltz	a0,3cb2 <fourfiles+0xa4>
    if(pid == 0){
    3c7a:	c531                	beqz	a0,3cc6 <fourfiles+0xb8>
  for(pi = 0; pi < NCHILD; pi++){
    3c7c:	2485                	addw	s1,s1,1
    3c7e:	0921                	add	s2,s2,8
    3c80:	ff4494e3          	bne	s1,s4,3c68 <fourfiles+0x5a>
    3c84:	4491                	li	s1,4
    wait(&xstatus);
    3c86:	f6c40513          	add	a0,s0,-148
    3c8a:	084010ef          	jal	4d0e <wait>
    if(xstatus != 0)
    3c8e:	f6c42a83          	lw	s5,-148(s0)
    3c92:	0a0a9463          	bnez	s5,3d3a <fourfiles+0x12c>
  for(pi = 0; pi < NCHILD; pi++){
    3c96:	34fd                	addw	s1,s1,-1
    3c98:	f4fd                	bnez	s1,3c86 <fourfiles+0x78>
    3c9a:	03000b13          	li	s6,48
    while((n = read(fd, buf, sizeof(buf))) > 0){
    3c9e:	00008a17          	auipc	s4,0x8
    3ca2:	01aa0a13          	add	s4,s4,26 # bcb8 <buf>
    if(total != N*SZ){
    3ca6:	6d05                	lui	s10,0x1
    3ca8:	770d0d13          	add	s10,s10,1904 # 1770 <forkfork+0x4c>
  for(i = 0; i < NCHILD; i++){
    3cac:	03400d93          	li	s11,52
    3cb0:	a0ed                	j	3d9a <fourfiles+0x18c>
      printf("%s: fork failed\n", s);
    3cb2:	85e6                	mv	a1,s9
    3cb4:	00002517          	auipc	a0,0x2
    3cb8:	ef450513          	add	a0,a0,-268 # 5ba8 <malloc+0x9ac>
    3cbc:	48c010ef          	jal	5148 <printf>
      exit(1);
    3cc0:	4505                	li	a0,1
    3cc2:	044010ef          	jal	4d06 <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    3cc6:	20200593          	li	a1,514
    3cca:	854e                	mv	a0,s3
    3ccc:	07a010ef          	jal	4d46 <open>
    3cd0:	892a                	mv	s2,a0
      if(fd < 0){
    3cd2:	04054163          	bltz	a0,3d14 <fourfiles+0x106>
      memset(buf, '0'+pi, SZ);
    3cd6:	1f400613          	li	a2,500
    3cda:	0304859b          	addw	a1,s1,48
    3cde:	00008517          	auipc	a0,0x8
    3ce2:	fda50513          	add	a0,a0,-38 # bcb8 <buf>
    3ce6:	60f000ef          	jal	4af4 <memset>
    3cea:	44b1                	li	s1,12
        if((n = write(fd, buf, SZ)) != SZ){
    3cec:	00008997          	auipc	s3,0x8
    3cf0:	fcc98993          	add	s3,s3,-52 # bcb8 <buf>
    3cf4:	1f400613          	li	a2,500
    3cf8:	85ce                	mv	a1,s3
    3cfa:	854a                	mv	a0,s2
    3cfc:	02a010ef          	jal	4d26 <write>
    3d00:	85aa                	mv	a1,a0
    3d02:	1f400793          	li	a5,500
    3d06:	02f51163          	bne	a0,a5,3d28 <fourfiles+0x11a>
      for(i = 0; i < N; i++){
    3d0a:	34fd                	addw	s1,s1,-1
    3d0c:	f4e5                	bnez	s1,3cf4 <fourfiles+0xe6>
      exit(0);
    3d0e:	4501                	li	a0,0
    3d10:	7f7000ef          	jal	4d06 <exit>
        printf("%s: create failed\n", s);
    3d14:	85e6                	mv	a1,s9
    3d16:	00002517          	auipc	a0,0x2
    3d1a:	f2a50513          	add	a0,a0,-214 # 5c40 <malloc+0xa44>
    3d1e:	42a010ef          	jal	5148 <printf>
        exit(1);
    3d22:	4505                	li	a0,1
    3d24:	7e3000ef          	jal	4d06 <exit>
          printf("write failed %d\n", n);
    3d28:	00003517          	auipc	a0,0x3
    3d2c:	23850513          	add	a0,a0,568 # 6f60 <malloc+0x1d64>
    3d30:	418010ef          	jal	5148 <printf>
          exit(1);
    3d34:	4505                	li	a0,1
    3d36:	7d1000ef          	jal	4d06 <exit>
      exit(xstatus);
    3d3a:	8556                	mv	a0,s5
    3d3c:	7cb000ef          	jal	4d06 <exit>
          printf("%s: wrong char\n", s);
    3d40:	85e6                	mv	a1,s9
    3d42:	00003517          	auipc	a0,0x3
    3d46:	23650513          	add	a0,a0,566 # 6f78 <malloc+0x1d7c>
    3d4a:	3fe010ef          	jal	5148 <printf>
          exit(1);
    3d4e:	4505                	li	a0,1
    3d50:	7b7000ef          	jal	4d06 <exit>
      total += n;
    3d54:	00a9093b          	addw	s2,s2,a0
    while((n = read(fd, buf, sizeof(buf))) > 0){
    3d58:	660d                	lui	a2,0x3
    3d5a:	85d2                	mv	a1,s4
    3d5c:	854e                	mv	a0,s3
    3d5e:	7c1000ef          	jal	4d1e <read>
    3d62:	02a05063          	blez	a0,3d82 <fourfiles+0x174>
    3d66:	00008797          	auipc	a5,0x8
    3d6a:	f5278793          	add	a5,a5,-174 # bcb8 <buf>
    3d6e:	00f506b3          	add	a3,a0,a5
        if(buf[j] != '0'+i){
    3d72:	0007c703          	lbu	a4,0(a5)
    3d76:	fc9715e3          	bne	a4,s1,3d40 <fourfiles+0x132>
      for(j = 0; j < n; j++){
    3d7a:	0785                	add	a5,a5,1
    3d7c:	fed79be3          	bne	a5,a3,3d72 <fourfiles+0x164>
    3d80:	bfd1                	j	3d54 <fourfiles+0x146>
    close(fd);
    3d82:	854e                	mv	a0,s3
    3d84:	7ab000ef          	jal	4d2e <close>
    if(total != N*SZ){
    3d88:	03a91463          	bne	s2,s10,3db0 <fourfiles+0x1a2>
    unlink(fname);
    3d8c:	8562                	mv	a0,s8
    3d8e:	7c9000ef          	jal	4d56 <unlink>
  for(i = 0; i < NCHILD; i++){
    3d92:	0ba1                	add	s7,s7,8
    3d94:	2b05                	addw	s6,s6,1
    3d96:	03bb0763          	beq	s6,s11,3dc4 <fourfiles+0x1b6>
    fname = names[i];
    3d9a:	000bbc03          	ld	s8,0(s7)
    fd = open(fname, 0);
    3d9e:	4581                	li	a1,0
    3da0:	8562                	mv	a0,s8
    3da2:	7a5000ef          	jal	4d46 <open>
    3da6:	89aa                	mv	s3,a0
    total = 0;
    3da8:	8956                	mv	s2,s5
        if(buf[j] != '0'+i){
    3daa:	000b049b          	sext.w	s1,s6
    while((n = read(fd, buf, sizeof(buf))) > 0){
    3dae:	b76d                	j	3d58 <fourfiles+0x14a>
      printf("wrong length %d\n", total);
    3db0:	85ca                	mv	a1,s2
    3db2:	00003517          	auipc	a0,0x3
    3db6:	1d650513          	add	a0,a0,470 # 6f88 <malloc+0x1d8c>
    3dba:	38e010ef          	jal	5148 <printf>
      exit(1);
    3dbe:	4505                	li	a0,1
    3dc0:	747000ef          	jal	4d06 <exit>
}
    3dc4:	60ea                	ld	ra,152(sp)
    3dc6:	644a                	ld	s0,144(sp)
    3dc8:	64aa                	ld	s1,136(sp)
    3dca:	690a                	ld	s2,128(sp)
    3dcc:	79e6                	ld	s3,120(sp)
    3dce:	7a46                	ld	s4,112(sp)
    3dd0:	7aa6                	ld	s5,104(sp)
    3dd2:	7b06                	ld	s6,96(sp)
    3dd4:	6be6                	ld	s7,88(sp)
    3dd6:	6c46                	ld	s8,80(sp)
    3dd8:	6ca6                	ld	s9,72(sp)
    3dda:	6d06                	ld	s10,64(sp)
    3ddc:	7de2                	ld	s11,56(sp)
    3dde:	610d                	add	sp,sp,160
    3de0:	8082                	ret

0000000000003de2 <concreate>:
{
    3de2:	7135                	add	sp,sp,-160
    3de4:	ed06                	sd	ra,152(sp)
    3de6:	e922                	sd	s0,144(sp)
    3de8:	e526                	sd	s1,136(sp)
    3dea:	e14a                	sd	s2,128(sp)
    3dec:	fcce                	sd	s3,120(sp)
    3dee:	f8d2                	sd	s4,112(sp)
    3df0:	f4d6                	sd	s5,104(sp)
    3df2:	f0da                	sd	s6,96(sp)
    3df4:	ecde                	sd	s7,88(sp)
    3df6:	1100                	add	s0,sp,160
    3df8:	89aa                	mv	s3,a0
  file[0] = 'C';
    3dfa:	04300793          	li	a5,67
    3dfe:	faf40423          	sb	a5,-88(s0)
  file[2] = '\0';
    3e02:	fa040523          	sb	zero,-86(s0)
  for(i = 0; i < N; i++){
    3e06:	4901                	li	s2,0
    if(pid && (i % 3) == 1){
    3e08:	4b0d                	li	s6,3
    3e0a:	4a85                	li	s5,1
      link("C0", file);
    3e0c:	00003b97          	auipc	s7,0x3
    3e10:	194b8b93          	add	s7,s7,404 # 6fa0 <malloc+0x1da4>
  for(i = 0; i < N; i++){
    3e14:	02800a13          	li	s4,40
    3e18:	a41d                	j	403e <concreate+0x25c>
      link("C0", file);
    3e1a:	fa840593          	add	a1,s0,-88
    3e1e:	855e                	mv	a0,s7
    3e20:	747000ef          	jal	4d66 <link>
    if(pid == 0) {
    3e24:	a411                	j	4028 <concreate+0x246>
    } else if(pid == 0 && (i % 5) == 1){
    3e26:	4795                	li	a5,5
    3e28:	02f9693b          	remw	s2,s2,a5
    3e2c:	4785                	li	a5,1
    3e2e:	02f90563          	beq	s2,a5,3e58 <concreate+0x76>
      fd = open(file, O_CREATE | O_RDWR);
    3e32:	20200593          	li	a1,514
    3e36:	fa840513          	add	a0,s0,-88
    3e3a:	70d000ef          	jal	4d46 <open>
      if(fd < 0){
    3e3e:	1e055063          	bgez	a0,401e <concreate+0x23c>
        printf("concreate create %s failed\n", file);
    3e42:	fa840593          	add	a1,s0,-88
    3e46:	00003517          	auipc	a0,0x3
    3e4a:	16250513          	add	a0,a0,354 # 6fa8 <malloc+0x1dac>
    3e4e:	2fa010ef          	jal	5148 <printf>
        exit(1);
    3e52:	4505                	li	a0,1
    3e54:	6b3000ef          	jal	4d06 <exit>
      link("C0", file);
    3e58:	fa840593          	add	a1,s0,-88
    3e5c:	00003517          	auipc	a0,0x3
    3e60:	14450513          	add	a0,a0,324 # 6fa0 <malloc+0x1da4>
    3e64:	703000ef          	jal	4d66 <link>
      exit(0);
    3e68:	4501                	li	a0,0
    3e6a:	69d000ef          	jal	4d06 <exit>
        exit(1);
    3e6e:	4505                	li	a0,1
    3e70:	697000ef          	jal	4d06 <exit>
  memset(fa, 0, sizeof(fa));
    3e74:	02800613          	li	a2,40
    3e78:	4581                	li	a1,0
    3e7a:	f8040513          	add	a0,s0,-128
    3e7e:	477000ef          	jal	4af4 <memset>
  fd = open(".", 0);
    3e82:	4581                	li	a1,0
    3e84:	00002517          	auipc	a0,0x2
    3e88:	b7c50513          	add	a0,a0,-1156 # 5a00 <malloc+0x804>
    3e8c:	6bb000ef          	jal	4d46 <open>
    3e90:	892a                	mv	s2,a0
  n = 0;
    3e92:	8aa6                	mv	s5,s1
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    3e94:	04300a13          	li	s4,67
      if(i < 0 || i >= sizeof(fa)){
    3e98:	02700b13          	li	s6,39
      fa[i] = 1;
    3e9c:	4b85                	li	s7,1
  while(read(fd, &de, sizeof(de)) > 0){
    3e9e:	4641                	li	a2,16
    3ea0:	f7040593          	add	a1,s0,-144
    3ea4:	854a                	mv	a0,s2
    3ea6:	679000ef          	jal	4d1e <read>
    3eaa:	06a05a63          	blez	a0,3f1e <concreate+0x13c>
    if(de.inum == 0)
    3eae:	f7045783          	lhu	a5,-144(s0)
    3eb2:	d7f5                	beqz	a5,3e9e <concreate+0xbc>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    3eb4:	f7244783          	lbu	a5,-142(s0)
    3eb8:	ff4793e3          	bne	a5,s4,3e9e <concreate+0xbc>
    3ebc:	f7444783          	lbu	a5,-140(s0)
    3ec0:	fff9                	bnez	a5,3e9e <concreate+0xbc>
      i = de.name[1] - '0';
    3ec2:	f7344783          	lbu	a5,-141(s0)
    3ec6:	fd07879b          	addw	a5,a5,-48
    3eca:	0007871b          	sext.w	a4,a5
      if(i < 0 || i >= sizeof(fa)){
    3ece:	02eb6063          	bltu	s6,a4,3eee <concreate+0x10c>
      if(fa[i]){
    3ed2:	fb070793          	add	a5,a4,-80
    3ed6:	97a2                	add	a5,a5,s0
    3ed8:	fd07c783          	lbu	a5,-48(a5)
    3edc:	e78d                	bnez	a5,3f06 <concreate+0x124>
      fa[i] = 1;
    3ede:	fb070793          	add	a5,a4,-80
    3ee2:	00878733          	add	a4,a5,s0
    3ee6:	fd770823          	sb	s7,-48(a4)
      n++;
    3eea:	2a85                	addw	s5,s5,1
    3eec:	bf4d                	j	3e9e <concreate+0xbc>
        printf("%s: concreate weird file %s\n", s, de.name);
    3eee:	f7240613          	add	a2,s0,-142
    3ef2:	85ce                	mv	a1,s3
    3ef4:	00003517          	auipc	a0,0x3
    3ef8:	0d450513          	add	a0,a0,212 # 6fc8 <malloc+0x1dcc>
    3efc:	24c010ef          	jal	5148 <printf>
        exit(1);
    3f00:	4505                	li	a0,1
    3f02:	605000ef          	jal	4d06 <exit>
        printf("%s: concreate duplicate file %s\n", s, de.name);
    3f06:	f7240613          	add	a2,s0,-142
    3f0a:	85ce                	mv	a1,s3
    3f0c:	00003517          	auipc	a0,0x3
    3f10:	0dc50513          	add	a0,a0,220 # 6fe8 <malloc+0x1dec>
    3f14:	234010ef          	jal	5148 <printf>
        exit(1);
    3f18:	4505                	li	a0,1
    3f1a:	5ed000ef          	jal	4d06 <exit>
  close(fd);
    3f1e:	854a                	mv	a0,s2
    3f20:	60f000ef          	jal	4d2e <close>
  if(n != N){
    3f24:	02800793          	li	a5,40
    3f28:	00fa9763          	bne	s5,a5,3f36 <concreate+0x154>
    if(((i % 3) == 0 && pid == 0) ||
    3f2c:	4a8d                	li	s5,3
    3f2e:	4b05                	li	s6,1
  for(i = 0; i < N; i++){
    3f30:	02800a13          	li	s4,40
    3f34:	a079                	j	3fc2 <concreate+0x1e0>
    printf("%s: concreate not enough files in directory listing\n", s);
    3f36:	85ce                	mv	a1,s3
    3f38:	00003517          	auipc	a0,0x3
    3f3c:	0d850513          	add	a0,a0,216 # 7010 <malloc+0x1e14>
    3f40:	208010ef          	jal	5148 <printf>
    exit(1);
    3f44:	4505                	li	a0,1
    3f46:	5c1000ef          	jal	4d06 <exit>
      printf("%s: fork failed\n", s);
    3f4a:	85ce                	mv	a1,s3
    3f4c:	00002517          	auipc	a0,0x2
    3f50:	c5c50513          	add	a0,a0,-932 # 5ba8 <malloc+0x9ac>
    3f54:	1f4010ef          	jal	5148 <printf>
      exit(1);
    3f58:	4505                	li	a0,1
    3f5a:	5ad000ef          	jal	4d06 <exit>
      close(open(file, 0));
    3f5e:	4581                	li	a1,0
    3f60:	fa840513          	add	a0,s0,-88
    3f64:	5e3000ef          	jal	4d46 <open>
    3f68:	5c7000ef          	jal	4d2e <close>
      close(open(file, 0));
    3f6c:	4581                	li	a1,0
    3f6e:	fa840513          	add	a0,s0,-88
    3f72:	5d5000ef          	jal	4d46 <open>
    3f76:	5b9000ef          	jal	4d2e <close>
      close(open(file, 0));
    3f7a:	4581                	li	a1,0
    3f7c:	fa840513          	add	a0,s0,-88
    3f80:	5c7000ef          	jal	4d46 <open>
    3f84:	5ab000ef          	jal	4d2e <close>
      close(open(file, 0));
    3f88:	4581                	li	a1,0
    3f8a:	fa840513          	add	a0,s0,-88
    3f8e:	5b9000ef          	jal	4d46 <open>
    3f92:	59d000ef          	jal	4d2e <close>
      close(open(file, 0));
    3f96:	4581                	li	a1,0
    3f98:	fa840513          	add	a0,s0,-88
    3f9c:	5ab000ef          	jal	4d46 <open>
    3fa0:	58f000ef          	jal	4d2e <close>
      close(open(file, 0));
    3fa4:	4581                	li	a1,0
    3fa6:	fa840513          	add	a0,s0,-88
    3faa:	59d000ef          	jal	4d46 <open>
    3fae:	581000ef          	jal	4d2e <close>
    if(pid == 0)
    3fb2:	06090363          	beqz	s2,4018 <concreate+0x236>
      wait(0);
    3fb6:	4501                	li	a0,0
    3fb8:	557000ef          	jal	4d0e <wait>
  for(i = 0; i < N; i++){
    3fbc:	2485                	addw	s1,s1,1
    3fbe:	0b448963          	beq	s1,s4,4070 <concreate+0x28e>
    file[1] = '0' + i;
    3fc2:	0304879b          	addw	a5,s1,48
    3fc6:	faf404a3          	sb	a5,-87(s0)
    pid = fork();
    3fca:	535000ef          	jal	4cfe <fork>
    3fce:	892a                	mv	s2,a0
    if(pid < 0){
    3fd0:	f6054de3          	bltz	a0,3f4a <concreate+0x168>
    if(((i % 3) == 0 && pid == 0) ||
    3fd4:	0354e73b          	remw	a4,s1,s5
    3fd8:	00a767b3          	or	a5,a4,a0
    3fdc:	2781                	sext.w	a5,a5
    3fde:	d3c1                	beqz	a5,3f5e <concreate+0x17c>
    3fe0:	01671363          	bne	a4,s6,3fe6 <concreate+0x204>
       ((i % 3) == 1 && pid != 0)){
    3fe4:	fd2d                	bnez	a0,3f5e <concreate+0x17c>
      unlink(file);
    3fe6:	fa840513          	add	a0,s0,-88
    3fea:	56d000ef          	jal	4d56 <unlink>
      unlink(file);
    3fee:	fa840513          	add	a0,s0,-88
    3ff2:	565000ef          	jal	4d56 <unlink>
      unlink(file);
    3ff6:	fa840513          	add	a0,s0,-88
    3ffa:	55d000ef          	jal	4d56 <unlink>
      unlink(file);
    3ffe:	fa840513          	add	a0,s0,-88
    4002:	555000ef          	jal	4d56 <unlink>
      unlink(file);
    4006:	fa840513          	add	a0,s0,-88
    400a:	54d000ef          	jal	4d56 <unlink>
      unlink(file);
    400e:	fa840513          	add	a0,s0,-88
    4012:	545000ef          	jal	4d56 <unlink>
    4016:	bf71                	j	3fb2 <concreate+0x1d0>
      exit(0);
    4018:	4501                	li	a0,0
    401a:	4ed000ef          	jal	4d06 <exit>
      close(fd);
    401e:	511000ef          	jal	4d2e <close>
    if(pid == 0) {
    4022:	b599                	j	3e68 <concreate+0x86>
      close(fd);
    4024:	50b000ef          	jal	4d2e <close>
      wait(&xstatus);
    4028:	f6c40513          	add	a0,s0,-148
    402c:	4e3000ef          	jal	4d0e <wait>
      if(xstatus != 0)
    4030:	f6c42483          	lw	s1,-148(s0)
    4034:	e2049de3          	bnez	s1,3e6e <concreate+0x8c>
  for(i = 0; i < N; i++){
    4038:	2905                	addw	s2,s2,1
    403a:	e3490de3          	beq	s2,s4,3e74 <concreate+0x92>
    file[1] = '0' + i;
    403e:	0309079b          	addw	a5,s2,48
    4042:	faf404a3          	sb	a5,-87(s0)
    unlink(file);
    4046:	fa840513          	add	a0,s0,-88
    404a:	50d000ef          	jal	4d56 <unlink>
    pid = fork();
    404e:	4b1000ef          	jal	4cfe <fork>
    if(pid && (i % 3) == 1){
    4052:	dc050ae3          	beqz	a0,3e26 <concreate+0x44>
    4056:	036967bb          	remw	a5,s2,s6
    405a:	dd5780e3          	beq	a5,s5,3e1a <concreate+0x38>
      fd = open(file, O_CREATE | O_RDWR);
    405e:	20200593          	li	a1,514
    4062:	fa840513          	add	a0,s0,-88
    4066:	4e1000ef          	jal	4d46 <open>
      if(fd < 0){
    406a:	fa055de3          	bgez	a0,4024 <concreate+0x242>
    406e:	bbd1                	j	3e42 <concreate+0x60>
}
    4070:	60ea                	ld	ra,152(sp)
    4072:	644a                	ld	s0,144(sp)
    4074:	64aa                	ld	s1,136(sp)
    4076:	690a                	ld	s2,128(sp)
    4078:	79e6                	ld	s3,120(sp)
    407a:	7a46                	ld	s4,112(sp)
    407c:	7aa6                	ld	s5,104(sp)
    407e:	7b06                	ld	s6,96(sp)
    4080:	6be6                	ld	s7,88(sp)
    4082:	610d                	add	sp,sp,160
    4084:	8082                	ret

0000000000004086 <bigfile>:
{
    4086:	7139                	add	sp,sp,-64
    4088:	fc06                	sd	ra,56(sp)
    408a:	f822                	sd	s0,48(sp)
    408c:	f426                	sd	s1,40(sp)
    408e:	f04a                	sd	s2,32(sp)
    4090:	ec4e                	sd	s3,24(sp)
    4092:	e852                	sd	s4,16(sp)
    4094:	e456                	sd	s5,8(sp)
    4096:	0080                	add	s0,sp,64
    4098:	8aaa                	mv	s5,a0
  unlink("bigfile.dat");
    409a:	00003517          	auipc	a0,0x3
    409e:	fae50513          	add	a0,a0,-82 # 7048 <malloc+0x1e4c>
    40a2:	4b5000ef          	jal	4d56 <unlink>
  fd = open("bigfile.dat", O_CREATE | O_RDWR);
    40a6:	20200593          	li	a1,514
    40aa:	00003517          	auipc	a0,0x3
    40ae:	f9e50513          	add	a0,a0,-98 # 7048 <malloc+0x1e4c>
    40b2:	495000ef          	jal	4d46 <open>
    40b6:	89aa                	mv	s3,a0
  for(i = 0; i < N; i++){
    40b8:	4481                	li	s1,0
    memset(buf, i, SZ);
    40ba:	00008917          	auipc	s2,0x8
    40be:	bfe90913          	add	s2,s2,-1026 # bcb8 <buf>
  for(i = 0; i < N; i++){
    40c2:	4a51                	li	s4,20
  if(fd < 0){
    40c4:	08054663          	bltz	a0,4150 <bigfile+0xca>
    memset(buf, i, SZ);
    40c8:	25800613          	li	a2,600
    40cc:	85a6                	mv	a1,s1
    40ce:	854a                	mv	a0,s2
    40d0:	225000ef          	jal	4af4 <memset>
    if(write(fd, buf, SZ) != SZ){
    40d4:	25800613          	li	a2,600
    40d8:	85ca                	mv	a1,s2
    40da:	854e                	mv	a0,s3
    40dc:	44b000ef          	jal	4d26 <write>
    40e0:	25800793          	li	a5,600
    40e4:	08f51063          	bne	a0,a5,4164 <bigfile+0xde>
  for(i = 0; i < N; i++){
    40e8:	2485                	addw	s1,s1,1
    40ea:	fd449fe3          	bne	s1,s4,40c8 <bigfile+0x42>
  close(fd);
    40ee:	854e                	mv	a0,s3
    40f0:	43f000ef          	jal	4d2e <close>
  fd = open("bigfile.dat", 0);
    40f4:	4581                	li	a1,0
    40f6:	00003517          	auipc	a0,0x3
    40fa:	f5250513          	add	a0,a0,-174 # 7048 <malloc+0x1e4c>
    40fe:	449000ef          	jal	4d46 <open>
    4102:	8a2a                	mv	s4,a0
  total = 0;
    4104:	4981                	li	s3,0
  for(i = 0; ; i++){
    4106:	4481                	li	s1,0
    cc = read(fd, buf, SZ/2);
    4108:	00008917          	auipc	s2,0x8
    410c:	bb090913          	add	s2,s2,-1104 # bcb8 <buf>
  if(fd < 0){
    4110:	06054463          	bltz	a0,4178 <bigfile+0xf2>
    cc = read(fd, buf, SZ/2);
    4114:	12c00613          	li	a2,300
    4118:	85ca                	mv	a1,s2
    411a:	8552                	mv	a0,s4
    411c:	403000ef          	jal	4d1e <read>
    if(cc < 0){
    4120:	06054663          	bltz	a0,418c <bigfile+0x106>
    if(cc == 0)
    4124:	c155                	beqz	a0,41c8 <bigfile+0x142>
    if(cc != SZ/2){
    4126:	12c00793          	li	a5,300
    412a:	06f51b63          	bne	a0,a5,41a0 <bigfile+0x11a>
    if(buf[0] != i/2 || buf[SZ/2-1] != i/2){
    412e:	01f4d79b          	srlw	a5,s1,0x1f
    4132:	9fa5                	addw	a5,a5,s1
    4134:	4017d79b          	sraw	a5,a5,0x1
    4138:	00094703          	lbu	a4,0(s2)
    413c:	06f71c63          	bne	a4,a5,41b4 <bigfile+0x12e>
    4140:	12b94703          	lbu	a4,299(s2)
    4144:	06f71863          	bne	a4,a5,41b4 <bigfile+0x12e>
    total += cc;
    4148:	12c9899b          	addw	s3,s3,300
  for(i = 0; ; i++){
    414c:	2485                	addw	s1,s1,1
    cc = read(fd, buf, SZ/2);
    414e:	b7d9                	j	4114 <bigfile+0x8e>
    printf("%s: cannot create bigfile", s);
    4150:	85d6                	mv	a1,s5
    4152:	00003517          	auipc	a0,0x3
    4156:	f0650513          	add	a0,a0,-250 # 7058 <malloc+0x1e5c>
    415a:	7ef000ef          	jal	5148 <printf>
    exit(1);
    415e:	4505                	li	a0,1
    4160:	3a7000ef          	jal	4d06 <exit>
      printf("%s: write bigfile failed\n", s);
    4164:	85d6                	mv	a1,s5
    4166:	00003517          	auipc	a0,0x3
    416a:	f1250513          	add	a0,a0,-238 # 7078 <malloc+0x1e7c>
    416e:	7db000ef          	jal	5148 <printf>
      exit(1);
    4172:	4505                	li	a0,1
    4174:	393000ef          	jal	4d06 <exit>
    printf("%s: cannot open bigfile\n", s);
    4178:	85d6                	mv	a1,s5
    417a:	00003517          	auipc	a0,0x3
    417e:	f1e50513          	add	a0,a0,-226 # 7098 <malloc+0x1e9c>
    4182:	7c7000ef          	jal	5148 <printf>
    exit(1);
    4186:	4505                	li	a0,1
    4188:	37f000ef          	jal	4d06 <exit>
      printf("%s: read bigfile failed\n", s);
    418c:	85d6                	mv	a1,s5
    418e:	00003517          	auipc	a0,0x3
    4192:	f2a50513          	add	a0,a0,-214 # 70b8 <malloc+0x1ebc>
    4196:	7b3000ef          	jal	5148 <printf>
      exit(1);
    419a:	4505                	li	a0,1
    419c:	36b000ef          	jal	4d06 <exit>
      printf("%s: short read bigfile\n", s);
    41a0:	85d6                	mv	a1,s5
    41a2:	00003517          	auipc	a0,0x3
    41a6:	f3650513          	add	a0,a0,-202 # 70d8 <malloc+0x1edc>
    41aa:	79f000ef          	jal	5148 <printf>
      exit(1);
    41ae:	4505                	li	a0,1
    41b0:	357000ef          	jal	4d06 <exit>
      printf("%s: read bigfile wrong data\n", s);
    41b4:	85d6                	mv	a1,s5
    41b6:	00003517          	auipc	a0,0x3
    41ba:	f3a50513          	add	a0,a0,-198 # 70f0 <malloc+0x1ef4>
    41be:	78b000ef          	jal	5148 <printf>
      exit(1);
    41c2:	4505                	li	a0,1
    41c4:	343000ef          	jal	4d06 <exit>
  close(fd);
    41c8:	8552                	mv	a0,s4
    41ca:	365000ef          	jal	4d2e <close>
  if(total != N*SZ){
    41ce:	678d                	lui	a5,0x3
    41d0:	ee078793          	add	a5,a5,-288 # 2ee0 <subdir+0x372>
    41d4:	02f99163          	bne	s3,a5,41f6 <bigfile+0x170>
  unlink("bigfile.dat");
    41d8:	00003517          	auipc	a0,0x3
    41dc:	e7050513          	add	a0,a0,-400 # 7048 <malloc+0x1e4c>
    41e0:	377000ef          	jal	4d56 <unlink>
}
    41e4:	70e2                	ld	ra,56(sp)
    41e6:	7442                	ld	s0,48(sp)
    41e8:	74a2                	ld	s1,40(sp)
    41ea:	7902                	ld	s2,32(sp)
    41ec:	69e2                	ld	s3,24(sp)
    41ee:	6a42                	ld	s4,16(sp)
    41f0:	6aa2                	ld	s5,8(sp)
    41f2:	6121                	add	sp,sp,64
    41f4:	8082                	ret
    printf("%s: read bigfile wrong total\n", s);
    41f6:	85d6                	mv	a1,s5
    41f8:	00003517          	auipc	a0,0x3
    41fc:	f1850513          	add	a0,a0,-232 # 7110 <malloc+0x1f14>
    4200:	749000ef          	jal	5148 <printf>
    exit(1);
    4204:	4505                	li	a0,1
    4206:	301000ef          	jal	4d06 <exit>

000000000000420a <bigargtest>:
{
    420a:	7121                	add	sp,sp,-448
    420c:	ff06                	sd	ra,440(sp)
    420e:	fb22                	sd	s0,432(sp)
    4210:	f726                	sd	s1,424(sp)
    4212:	0380                	add	s0,sp,448
    4214:	84aa                	mv	s1,a0
  unlink("bigarg-ok");
    4216:	00003517          	auipc	a0,0x3
    421a:	f1a50513          	add	a0,a0,-230 # 7130 <malloc+0x1f34>
    421e:	339000ef          	jal	4d56 <unlink>
  pid = fork();
    4222:	2dd000ef          	jal	4cfe <fork>
  if(pid == 0){
    4226:	c915                	beqz	a0,425a <bigargtest+0x50>
  } else if(pid < 0){
    4228:	08054a63          	bltz	a0,42bc <bigargtest+0xb2>
  wait(&xstatus);
    422c:	fdc40513          	add	a0,s0,-36
    4230:	2df000ef          	jal	4d0e <wait>
  if(xstatus != 0)
    4234:	fdc42503          	lw	a0,-36(s0)
    4238:	ed41                	bnez	a0,42d0 <bigargtest+0xc6>
  fd = open("bigarg-ok", 0);
    423a:	4581                	li	a1,0
    423c:	00003517          	auipc	a0,0x3
    4240:	ef450513          	add	a0,a0,-268 # 7130 <malloc+0x1f34>
    4244:	303000ef          	jal	4d46 <open>
  if(fd < 0){
    4248:	08054663          	bltz	a0,42d4 <bigargtest+0xca>
  close(fd);
    424c:	2e3000ef          	jal	4d2e <close>
}
    4250:	70fa                	ld	ra,440(sp)
    4252:	745a                	ld	s0,432(sp)
    4254:	74ba                	ld	s1,424(sp)
    4256:	6139                	add	sp,sp,448
    4258:	8082                	ret
    memset(big, ' ', sizeof(big));
    425a:	19000613          	li	a2,400
    425e:	02000593          	li	a1,32
    4262:	e4840513          	add	a0,s0,-440
    4266:	08f000ef          	jal	4af4 <memset>
    big[sizeof(big)-1] = '\0';
    426a:	fc040ba3          	sb	zero,-41(s0)
    for(i = 0; i < MAXARG-1; i++)
    426e:	00004797          	auipc	a5,0x4
    4272:	23278793          	add	a5,a5,562 # 84a0 <args.1>
    4276:	00004697          	auipc	a3,0x4
    427a:	32268693          	add	a3,a3,802 # 8598 <args.1+0xf8>
      args[i] = big;
    427e:	e4840713          	add	a4,s0,-440
    4282:	e398                	sd	a4,0(a5)
    for(i = 0; i < MAXARG-1; i++)
    4284:	07a1                	add	a5,a5,8
    4286:	fed79ee3          	bne	a5,a3,4282 <bigargtest+0x78>
    args[MAXARG-1] = 0;
    428a:	00004597          	auipc	a1,0x4
    428e:	21658593          	add	a1,a1,534 # 84a0 <args.1>
    4292:	0e05bc23          	sd	zero,248(a1)
    exec("echo", args);
    4296:	00001517          	auipc	a0,0x1
    429a:	08250513          	add	a0,a0,130 # 5318 <malloc+0x11c>
    429e:	2a1000ef          	jal	4d3e <exec>
    fd = open("bigarg-ok", O_CREATE);
    42a2:	20000593          	li	a1,512
    42a6:	00003517          	auipc	a0,0x3
    42aa:	e8a50513          	add	a0,a0,-374 # 7130 <malloc+0x1f34>
    42ae:	299000ef          	jal	4d46 <open>
    close(fd);
    42b2:	27d000ef          	jal	4d2e <close>
    exit(0);
    42b6:	4501                	li	a0,0
    42b8:	24f000ef          	jal	4d06 <exit>
    printf("%s: bigargtest: fork failed\n", s);
    42bc:	85a6                	mv	a1,s1
    42be:	00003517          	auipc	a0,0x3
    42c2:	e8250513          	add	a0,a0,-382 # 7140 <malloc+0x1f44>
    42c6:	683000ef          	jal	5148 <printf>
    exit(1);
    42ca:	4505                	li	a0,1
    42cc:	23b000ef          	jal	4d06 <exit>
    exit(xstatus);
    42d0:	237000ef          	jal	4d06 <exit>
    printf("%s: bigarg test failed!\n", s);
    42d4:	85a6                	mv	a1,s1
    42d6:	00003517          	auipc	a0,0x3
    42da:	e8a50513          	add	a0,a0,-374 # 7160 <malloc+0x1f64>
    42de:	66b000ef          	jal	5148 <printf>
    exit(1);
    42e2:	4505                	li	a0,1
    42e4:	223000ef          	jal	4d06 <exit>

00000000000042e8 <lazy_alloc>:
{
    42e8:	1141                	add	sp,sp,-16
    42ea:	e406                	sd	ra,8(sp)
    42ec:	e022                	sd	s0,0(sp)
    42ee:	0800                	add	s0,sp,16
  prev_end = sbrklazy(REGION_SZ);
    42f0:	40000537          	lui	a0,0x40000
    42f4:	1f5000ef          	jal	4ce8 <sbrklazy>
  if (prev_end == (char *) SBRK_ERROR) {
    42f8:	57fd                	li	a5,-1
    42fa:	02f50a63          	beq	a0,a5,432e <lazy_alloc+0x46>
  for (i = prev_end + PGSIZE; i < new_end; i += 64 * PGSIZE)
    42fe:	6605                	lui	a2,0x1
    4300:	962a                	add	a2,a2,a0
    4302:	400017b7          	lui	a5,0x40001
    4306:	00f50733          	add	a4,a0,a5
    430a:	87b2                	mv	a5,a2
    430c:	000406b7          	lui	a3,0x40
    *(char **)i = i;
    4310:	e39c                	sd	a5,0(a5)
  for (i = prev_end + PGSIZE; i < new_end; i += 64 * PGSIZE)
    4312:	97b6                	add	a5,a5,a3
    4314:	fee79ee3          	bne	a5,a4,4310 <lazy_alloc+0x28>
  for (i = prev_end + PGSIZE; i < new_end; i += 64 * PGSIZE) {
    4318:	000406b7          	lui	a3,0x40
    if (*(char **)i != i) {
    431c:	621c                	ld	a5,0(a2)
    431e:	02c79163          	bne	a5,a2,4340 <lazy_alloc+0x58>
  for (i = prev_end + PGSIZE; i < new_end; i += 64 * PGSIZE) {
    4322:	9636                	add	a2,a2,a3
    4324:	fee61ce3          	bne	a2,a4,431c <lazy_alloc+0x34>
  exit(0);
    4328:	4501                	li	a0,0
    432a:	1dd000ef          	jal	4d06 <exit>
    printf("sbrklazy() failed\n");
    432e:	00003517          	auipc	a0,0x3
    4332:	e5250513          	add	a0,a0,-430 # 7180 <malloc+0x1f84>
    4336:	613000ef          	jal	5148 <printf>
    exit(1);
    433a:	4505                	li	a0,1
    433c:	1cb000ef          	jal	4d06 <exit>
      printf("failed to read value from memory\n");
    4340:	00003517          	auipc	a0,0x3
    4344:	e5850513          	add	a0,a0,-424 # 7198 <malloc+0x1f9c>
    4348:	601000ef          	jal	5148 <printf>
      exit(1);
    434c:	4505                	li	a0,1
    434e:	1b9000ef          	jal	4d06 <exit>

0000000000004352 <lazy_unmap>:
{
    4352:	7139                	add	sp,sp,-64
    4354:	fc06                	sd	ra,56(sp)
    4356:	f822                	sd	s0,48(sp)
    4358:	f426                	sd	s1,40(sp)
    435a:	f04a                	sd	s2,32(sp)
    435c:	ec4e                	sd	s3,24(sp)
    435e:	0080                	add	s0,sp,64
  prev_end = sbrklazy(REGION_SZ);
    4360:	40000537          	lui	a0,0x40000
    4364:	185000ef          	jal	4ce8 <sbrklazy>
  if (prev_end == (char*)SBRK_ERROR) {
    4368:	57fd                	li	a5,-1
    436a:	04f50363          	beq	a0,a5,43b0 <lazy_unmap+0x5e>
  for (i = prev_end + PGSIZE; i < new_end; i += PGSIZE * PGSIZE)
    436e:	6905                	lui	s2,0x1
    4370:	992a                	add	s2,s2,a0
    4372:	400017b7          	lui	a5,0x40001
    4376:	00f504b3          	add	s1,a0,a5
    437a:	87ca                	mv	a5,s2
    437c:	01000737          	lui	a4,0x1000
    *(char **)i = i;
    4380:	e39c                	sd	a5,0(a5)
  for (i = prev_end + PGSIZE; i < new_end; i += PGSIZE * PGSIZE)
    4382:	97ba                	add	a5,a5,a4
    4384:	fef49ee3          	bne	s1,a5,4380 <lazy_unmap+0x2e>
  for (i = prev_end + PGSIZE; i < new_end; i += PGSIZE * PGSIZE) {
    4388:	010009b7          	lui	s3,0x1000
    pid = fork();
    438c:	173000ef          	jal	4cfe <fork>
    if (pid < 0) {
    4390:	02054963          	bltz	a0,43c2 <lazy_unmap+0x70>
    } else if (pid == 0) {
    4394:	c121                	beqz	a0,43d4 <lazy_unmap+0x82>
      wait(&status);
    4396:	fcc40513          	add	a0,s0,-52
    439a:	175000ef          	jal	4d0e <wait>
      if (status == 0) {
    439e:	fcc42783          	lw	a5,-52(s0)
    43a2:	c3b1                	beqz	a5,43e6 <lazy_unmap+0x94>
  for (i = prev_end + PGSIZE; i < new_end; i += PGSIZE * PGSIZE) {
    43a4:	994e                	add	s2,s2,s3
    43a6:	ff2493e3          	bne	s1,s2,438c <lazy_unmap+0x3a>
  exit(0);
    43aa:	4501                	li	a0,0
    43ac:	15b000ef          	jal	4d06 <exit>
    printf("sbrklazy() failed\n");
    43b0:	00003517          	auipc	a0,0x3
    43b4:	dd050513          	add	a0,a0,-560 # 7180 <malloc+0x1f84>
    43b8:	591000ef          	jal	5148 <printf>
    exit(1);
    43bc:	4505                	li	a0,1
    43be:	149000ef          	jal	4d06 <exit>
      printf("error forking\n");
    43c2:	00003517          	auipc	a0,0x3
    43c6:	dfe50513          	add	a0,a0,-514 # 71c0 <malloc+0x1fc4>
    43ca:	57f000ef          	jal	5148 <printf>
      exit(1);
    43ce:	4505                	li	a0,1
    43d0:	137000ef          	jal	4d06 <exit>
      sbrklazy(-1L * REGION_SZ);
    43d4:	c0000537          	lui	a0,0xc0000
    43d8:	111000ef          	jal	4ce8 <sbrklazy>
      *(char **)i = i;
    43dc:	01293023          	sd	s2,0(s2) # 1000 <badarg>
      exit(0);
    43e0:	4501                	li	a0,0
    43e2:	125000ef          	jal	4d06 <exit>
        printf("memory not unmapped\n");
    43e6:	00003517          	auipc	a0,0x3
    43ea:	dea50513          	add	a0,a0,-534 # 71d0 <malloc+0x1fd4>
    43ee:	55b000ef          	jal	5148 <printf>
        exit(1);
    43f2:	4505                	li	a0,1
    43f4:	113000ef          	jal	4d06 <exit>

00000000000043f8 <lazy_copy>:
{
    43f8:	7159                	add	sp,sp,-112
    43fa:	f486                	sd	ra,104(sp)
    43fc:	f0a2                	sd	s0,96(sp)
    43fe:	eca6                	sd	s1,88(sp)
    4400:	e8ca                	sd	s2,80(sp)
    4402:	e4ce                	sd	s3,72(sp)
    4404:	e0d2                	sd	s4,64(sp)
    4406:	fc56                	sd	s5,56(sp)
    4408:	f85a                	sd	s6,48(sp)
    440a:	1880                	add	s0,sp,112
    char *p = sbrk(0);
    440c:	4501                	li	a0,0
    440e:	0c5000ef          	jal	4cd2 <sbrk>
    4412:	84aa                	mv	s1,a0
    sbrklazy(4*PGSIZE);
    4414:	6511                	lui	a0,0x4
    4416:	0d3000ef          	jal	4ce8 <sbrklazy>
    open(p + 8192, 0);
    441a:	4581                	li	a1,0
    441c:	6509                	lui	a0,0x2
    441e:	9526                	add	a0,a0,s1
    4420:	127000ef          	jal	4d46 <open>
    void *xx = sbrk(0);
    4424:	4501                	li	a0,0
    4426:	0ad000ef          	jal	4cd2 <sbrk>
    442a:	84aa                	mv	s1,a0
    void *ret = sbrk(-(((uint64) xx)+1));
    442c:	fff54513          	not	a0,a0
    4430:	2501                	sext.w	a0,a0
    4432:	0a1000ef          	jal	4cd2 <sbrk>
    if(ret != xx){
    4436:	00a48c63          	beq	s1,a0,444e <lazy_copy+0x56>
    443a:	85aa                	mv	a1,a0
      printf("sbrk(sbrk(0)+1) returned %p, not old sz\n", ret);
    443c:	00003517          	auipc	a0,0x3
    4440:	dac50513          	add	a0,a0,-596 # 71e8 <malloc+0x1fec>
    4444:	505000ef          	jal	5148 <printf>
      exit(1);
    4448:	4505                	li	a0,1
    444a:	0bd000ef          	jal	4d06 <exit>
  unsigned long bad[] = {
    444e:	00003797          	auipc	a5,0x3
    4452:	40a78793          	add	a5,a5,1034 # 7858 <malloc+0x265c>
    4456:	7fa8                	ld	a0,120(a5)
    4458:	63cc                	ld	a1,128(a5)
    445a:	67d0                	ld	a2,136(a5)
    445c:	6bd4                	ld	a3,144(a5)
    445e:	6fd8                	ld	a4,152(a5)
    4460:	73dc                	ld	a5,160(a5)
    4462:	f8a43823          	sd	a0,-112(s0)
    4466:	f8b43c23          	sd	a1,-104(s0)
    446a:	fac43023          	sd	a2,-96(s0)
    446e:	fad43423          	sd	a3,-88(s0)
    4472:	fae43823          	sd	a4,-80(s0)
    4476:	faf43c23          	sd	a5,-72(s0)
  for(int i = 0; i < sizeof(bad)/sizeof(bad[0]); i++){
    447a:	f9040913          	add	s2,s0,-112
    447e:	fc040b13          	add	s6,s0,-64
    int fd = open("README", 0);
    4482:	00001a17          	auipc	s4,0x1
    4486:	06ea0a13          	add	s4,s4,110 # 54f0 <malloc+0x2f4>
    fd = open("junk", O_CREATE|O_RDWR|O_TRUNC);
    448a:	00001a97          	auipc	s5,0x1
    448e:	f76a8a93          	add	s5,s5,-138 # 5400 <malloc+0x204>
    int fd = open("README", 0);
    4492:	4581                	li	a1,0
    4494:	8552                	mv	a0,s4
    4496:	0b1000ef          	jal	4d46 <open>
    449a:	84aa                	mv	s1,a0
    if(fd < 0) { printf("cannot open README\n"); exit(1); }
    449c:	04054663          	bltz	a0,44e8 <lazy_copy+0xf0>
    if(read(fd, (char*)bad[i], 512) >= 0) { printf("read succeeded\n");  exit(1); }
    44a0:	00093983          	ld	s3,0(s2)
    44a4:	20000613          	li	a2,512
    44a8:	85ce                	mv	a1,s3
    44aa:	075000ef          	jal	4d1e <read>
    44ae:	04055663          	bgez	a0,44fa <lazy_copy+0x102>
    close(fd);
    44b2:	8526                	mv	a0,s1
    44b4:	07b000ef          	jal	4d2e <close>
    fd = open("junk", O_CREATE|O_RDWR|O_TRUNC);
    44b8:	60200593          	li	a1,1538
    44bc:	8556                	mv	a0,s5
    44be:	089000ef          	jal	4d46 <open>
    44c2:	84aa                	mv	s1,a0
    if(fd < 0) { printf("cannot open junk\n"); exit(1); }
    44c4:	04054463          	bltz	a0,450c <lazy_copy+0x114>
    if(write(fd, (char*)bad[i], 512) >= 0) { printf("write succeeded\n"); exit(1); }
    44c8:	20000613          	li	a2,512
    44cc:	85ce                	mv	a1,s3
    44ce:	059000ef          	jal	4d26 <write>
    44d2:	04055663          	bgez	a0,451e <lazy_copy+0x126>
    close(fd);
    44d6:	8526                	mv	a0,s1
    44d8:	057000ef          	jal	4d2e <close>
  for(int i = 0; i < sizeof(bad)/sizeof(bad[0]); i++){
    44dc:	0921                	add	s2,s2,8
    44de:	fb691ae3          	bne	s2,s6,4492 <lazy_copy+0x9a>
  exit(0);
    44e2:	4501                	li	a0,0
    44e4:	023000ef          	jal	4d06 <exit>
    if(fd < 0) { printf("cannot open README\n"); exit(1); }
    44e8:	00003517          	auipc	a0,0x3
    44ec:	d3050513          	add	a0,a0,-720 # 7218 <malloc+0x201c>
    44f0:	459000ef          	jal	5148 <printf>
    44f4:	4505                	li	a0,1
    44f6:	011000ef          	jal	4d06 <exit>
    if(read(fd, (char*)bad[i], 512) >= 0) { printf("read succeeded\n");  exit(1); }
    44fa:	00003517          	auipc	a0,0x3
    44fe:	d3650513          	add	a0,a0,-714 # 7230 <malloc+0x2034>
    4502:	447000ef          	jal	5148 <printf>
    4506:	4505                	li	a0,1
    4508:	7fe000ef          	jal	4d06 <exit>
    if(fd < 0) { printf("cannot open junk\n"); exit(1); }
    450c:	00003517          	auipc	a0,0x3
    4510:	d3450513          	add	a0,a0,-716 # 7240 <malloc+0x2044>
    4514:	435000ef          	jal	5148 <printf>
    4518:	4505                	li	a0,1
    451a:	7ec000ef          	jal	4d06 <exit>
    if(write(fd, (char*)bad[i], 512) >= 0) { printf("write succeeded\n"); exit(1); }
    451e:	00003517          	auipc	a0,0x3
    4522:	d3a50513          	add	a0,a0,-710 # 7258 <malloc+0x205c>
    4526:	423000ef          	jal	5148 <printf>
    452a:	4505                	li	a0,1
    452c:	7da000ef          	jal	4d06 <exit>

0000000000004530 <lazy_sbrk>:
{
    4530:	1101                	add	sp,sp,-32
    4532:	ec06                	sd	ra,24(sp)
    4534:	e822                	sd	s0,16(sp)
    4536:	e426                	sd	s1,8(sp)
    4538:	e04a                	sd	s2,0(sp)
    453a:	1000                	add	s0,sp,32
  char *p = sbrk(0);
    453c:	4501                	li	a0,0
    453e:	794000ef          	jal	4cd2 <sbrk>
    4542:	84aa                	mv	s1,a0
  while ((uint64)p < MAXVA-(1<<30)) {
    4544:	0ff00793          	li	a5,255
    4548:	07fa                	sll	a5,a5,0x1e
    454a:	00f57d63          	bgeu	a0,a5,4564 <lazy_sbrk+0x34>
    454e:	893e                	mv	s2,a5
    p = sbrklazy(1<<30);
    4550:	40000537          	lui	a0,0x40000
    4554:	794000ef          	jal	4ce8 <sbrklazy>
    p = sbrklazy(0);
    4558:	4501                	li	a0,0
    455a:	78e000ef          	jal	4ce8 <sbrklazy>
    455e:	84aa                	mv	s1,a0
  while ((uint64)p < MAXVA-(1<<30)) {
    4560:	ff2568e3          	bltu	a0,s2,4550 <lazy_sbrk+0x20>
  int n = TRAPFRAME-PGSIZE-(uint64)p;
    4564:	7975                	lui	s2,0xffffd
    4566:	4099093b          	subw	s2,s2,s1
  char *p1 = sbrklazy(n);
    456a:	854a                	mv	a0,s2
    456c:	77c000ef          	jal	4ce8 <sbrklazy>
    4570:	862a                	mv	a2,a0
  if (p1 < 0 || p1 != p) {
    4572:	00950d63          	beq	a0,s1,458c <lazy_sbrk+0x5c>
    printf("sbrklazy(%d) returned %p, not expected %p\n", n, p1, p);
    4576:	86a6                	mv	a3,s1
    4578:	85ca                	mv	a1,s2
    457a:	00003517          	auipc	a0,0x3
    457e:	cf650513          	add	a0,a0,-778 # 7270 <malloc+0x2074>
    4582:	3c7000ef          	jal	5148 <printf>
    exit(1);
    4586:	4505                	li	a0,1
    4588:	77e000ef          	jal	4d06 <exit>
  p = sbrk(PGSIZE);
    458c:	6505                	lui	a0,0x1
    458e:	744000ef          	jal	4cd2 <sbrk>
    4592:	862a                	mv	a2,a0
  if (p < 0 || (uint64)p != TRAPFRAME-PGSIZE) {
    4594:	040007b7          	lui	a5,0x4000
    4598:	17f5                	add	a5,a5,-3 # 3fffffd <base+0x3ff1345>
    459a:	07b2                	sll	a5,a5,0xc
    459c:	00f50c63          	beq	a0,a5,45b4 <lazy_sbrk+0x84>
    printf("sbrk(%d) returned %p, not expected TRAPFRAME-PGSIZE\n", PGSIZE, p);
    45a0:	6585                	lui	a1,0x1
    45a2:	00003517          	auipc	a0,0x3
    45a6:	cfe50513          	add	a0,a0,-770 # 72a0 <malloc+0x20a4>
    45aa:	39f000ef          	jal	5148 <printf>
    exit(1);
    45ae:	4505                	li	a0,1
    45b0:	756000ef          	jal	4d06 <exit>
  p[0] = 1;
    45b4:	040007b7          	lui	a5,0x4000
    45b8:	17f5                	add	a5,a5,-3 # 3fffffd <base+0x3ff1345>
    45ba:	07b2                	sll	a5,a5,0xc
    45bc:	4705                	li	a4,1
    45be:	00e78023          	sb	a4,0(a5)
  if (p[1] != 0) {
    45c2:	0017c783          	lbu	a5,1(a5)
    45c6:	cb91                	beqz	a5,45da <lazy_sbrk+0xaa>
    printf("sbrk() returned non-zero-filled memory\n");
    45c8:	00003517          	auipc	a0,0x3
    45cc:	d1050513          	add	a0,a0,-752 # 72d8 <malloc+0x20dc>
    45d0:	379000ef          	jal	5148 <printf>
    exit(1);
    45d4:	4505                	li	a0,1
    45d6:	730000ef          	jal	4d06 <exit>
  p = sbrk(1);
    45da:	4505                	li	a0,1
    45dc:	6f6000ef          	jal	4cd2 <sbrk>
    45e0:	85aa                	mv	a1,a0
  if ((uint64)p != -1) {
    45e2:	57fd                	li	a5,-1
    45e4:	00f50b63          	beq	a0,a5,45fa <lazy_sbrk+0xca>
    printf("sbrk(1) returned %p, expected error\n", p);
    45e8:	00003517          	auipc	a0,0x3
    45ec:	d1850513          	add	a0,a0,-744 # 7300 <malloc+0x2104>
    45f0:	359000ef          	jal	5148 <printf>
    exit(1);
    45f4:	4505                	li	a0,1
    45f6:	710000ef          	jal	4d06 <exit>
  p = sbrklazy(1);
    45fa:	4505                	li	a0,1
    45fc:	6ec000ef          	jal	4ce8 <sbrklazy>
    4600:	85aa                	mv	a1,a0
  if ((uint64)p != -1) {
    4602:	57fd                	li	a5,-1
    4604:	00f50b63          	beq	a0,a5,461a <lazy_sbrk+0xea>
    printf("sbrklazy(1) returned %p, expected error\n", p);
    4608:	00003517          	auipc	a0,0x3
    460c:	d2050513          	add	a0,a0,-736 # 7328 <malloc+0x212c>
    4610:	339000ef          	jal	5148 <printf>
    exit(1);
    4614:	4505                	li	a0,1
    4616:	6f0000ef          	jal	4d06 <exit>
  exit(0);
    461a:	4501                	li	a0,0
    461c:	6ea000ef          	jal	4d06 <exit>

0000000000004620 <fsfull>:
{
    4620:	7135                	add	sp,sp,-160
    4622:	ed06                	sd	ra,152(sp)
    4624:	e922                	sd	s0,144(sp)
    4626:	e526                	sd	s1,136(sp)
    4628:	e14a                	sd	s2,128(sp)
    462a:	fcce                	sd	s3,120(sp)
    462c:	f8d2                	sd	s4,112(sp)
    462e:	f4d6                	sd	s5,104(sp)
    4630:	f0da                	sd	s6,96(sp)
    4632:	ecde                	sd	s7,88(sp)
    4634:	e8e2                	sd	s8,80(sp)
    4636:	e4e6                	sd	s9,72(sp)
    4638:	e0ea                	sd	s10,64(sp)
    463a:	1100                	add	s0,sp,160
  printf("fsfull test\n");
    463c:	00003517          	auipc	a0,0x3
    4640:	d1c50513          	add	a0,a0,-740 # 7358 <malloc+0x215c>
    4644:	305000ef          	jal	5148 <printf>
  for(nfiles = 0; ; nfiles++){
    4648:	4481                	li	s1,0
    name[0] = 'f';
    464a:	06600d13          	li	s10,102
    name[1] = '0' + nfiles / 1000;
    464e:	3e800c13          	li	s8,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    4652:	06400b93          	li	s7,100
    name[3] = '0' + (nfiles % 100) / 10;
    4656:	4b29                	li	s6,10
    printf("writing %s\n", name);
    4658:	00003c97          	auipc	s9,0x3
    465c:	d10c8c93          	add	s9,s9,-752 # 7368 <malloc+0x216c>
    name[0] = 'f';
    4660:	f7a40023          	sb	s10,-160(s0)
    name[1] = '0' + nfiles / 1000;
    4664:	0384c7bb          	divw	a5,s1,s8
    4668:	0307879b          	addw	a5,a5,48
    466c:	f6f400a3          	sb	a5,-159(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    4670:	0384e7bb          	remw	a5,s1,s8
    4674:	0377c7bb          	divw	a5,a5,s7
    4678:	0307879b          	addw	a5,a5,48
    467c:	f6f40123          	sb	a5,-158(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    4680:	0374e7bb          	remw	a5,s1,s7
    4684:	0367c7bb          	divw	a5,a5,s6
    4688:	0307879b          	addw	a5,a5,48
    468c:	f6f401a3          	sb	a5,-157(s0)
    name[4] = '0' + (nfiles % 10);
    4690:	0364e7bb          	remw	a5,s1,s6
    4694:	0307879b          	addw	a5,a5,48
    4698:	f6f40223          	sb	a5,-156(s0)
    name[5] = '\0';
    469c:	f60402a3          	sb	zero,-155(s0)
    printf("writing %s\n", name);
    46a0:	f6040593          	add	a1,s0,-160
    46a4:	8566                	mv	a0,s9
    46a6:	2a3000ef          	jal	5148 <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    46aa:	20200593          	li	a1,514
    46ae:	f6040513          	add	a0,s0,-160
    46b2:	694000ef          	jal	4d46 <open>
    46b6:	892a                	mv	s2,a0
    if(fd < 0){
    46b8:	08055f63          	bgez	a0,4756 <fsfull+0x136>
      printf("open %s failed\n", name);
    46bc:	f6040593          	add	a1,s0,-160
    46c0:	00003517          	auipc	a0,0x3
    46c4:	cb850513          	add	a0,a0,-840 # 7378 <malloc+0x217c>
    46c8:	281000ef          	jal	5148 <printf>
  while(nfiles >= 0){
    46cc:	0604c163          	bltz	s1,472e <fsfull+0x10e>
    name[0] = 'f';
    46d0:	06600b13          	li	s6,102
    name[1] = '0' + nfiles / 1000;
    46d4:	3e800a13          	li	s4,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    46d8:	06400993          	li	s3,100
    name[3] = '0' + (nfiles % 100) / 10;
    46dc:	4929                	li	s2,10
  while(nfiles >= 0){
    46de:	5afd                	li	s5,-1
    name[0] = 'f';
    46e0:	f7640023          	sb	s6,-160(s0)
    name[1] = '0' + nfiles / 1000;
    46e4:	0344c7bb          	divw	a5,s1,s4
    46e8:	0307879b          	addw	a5,a5,48
    46ec:	f6f400a3          	sb	a5,-159(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    46f0:	0344e7bb          	remw	a5,s1,s4
    46f4:	0337c7bb          	divw	a5,a5,s3
    46f8:	0307879b          	addw	a5,a5,48
    46fc:	f6f40123          	sb	a5,-158(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    4700:	0334e7bb          	remw	a5,s1,s3
    4704:	0327c7bb          	divw	a5,a5,s2
    4708:	0307879b          	addw	a5,a5,48
    470c:	f6f401a3          	sb	a5,-157(s0)
    name[4] = '0' + (nfiles % 10);
    4710:	0324e7bb          	remw	a5,s1,s2
    4714:	0307879b          	addw	a5,a5,48
    4718:	f6f40223          	sb	a5,-156(s0)
    name[5] = '\0';
    471c:	f60402a3          	sb	zero,-155(s0)
    unlink(name);
    4720:	f6040513          	add	a0,s0,-160
    4724:	632000ef          	jal	4d56 <unlink>
    nfiles--;
    4728:	34fd                	addw	s1,s1,-1
  while(nfiles >= 0){
    472a:	fb549be3          	bne	s1,s5,46e0 <fsfull+0xc0>
  printf("fsfull test finished\n");
    472e:	00003517          	auipc	a0,0x3
    4732:	c6a50513          	add	a0,a0,-918 # 7398 <malloc+0x219c>
    4736:	213000ef          	jal	5148 <printf>
}
    473a:	60ea                	ld	ra,152(sp)
    473c:	644a                	ld	s0,144(sp)
    473e:	64aa                	ld	s1,136(sp)
    4740:	690a                	ld	s2,128(sp)
    4742:	79e6                	ld	s3,120(sp)
    4744:	7a46                	ld	s4,112(sp)
    4746:	7aa6                	ld	s5,104(sp)
    4748:	7b06                	ld	s6,96(sp)
    474a:	6be6                	ld	s7,88(sp)
    474c:	6c46                	ld	s8,80(sp)
    474e:	6ca6                	ld	s9,72(sp)
    4750:	6d06                	ld	s10,64(sp)
    4752:	610d                	add	sp,sp,160
    4754:	8082                	ret
    int total = 0;
    4756:	4981                	li	s3,0
      int cc = write(fd, buf, BSIZE);
    4758:	00007a97          	auipc	s5,0x7
    475c:	560a8a93          	add	s5,s5,1376 # bcb8 <buf>
      if(cc < BSIZE)
    4760:	3ff00a13          	li	s4,1023
      int cc = write(fd, buf, BSIZE);
    4764:	40000613          	li	a2,1024
    4768:	85d6                	mv	a1,s5
    476a:	854a                	mv	a0,s2
    476c:	5ba000ef          	jal	4d26 <write>
      if(cc < BSIZE)
    4770:	00aa5563          	bge	s4,a0,477a <fsfull+0x15a>
      total += cc;
    4774:	00a989bb          	addw	s3,s3,a0
    while(1){
    4778:	b7f5                	j	4764 <fsfull+0x144>
    printf("wrote %d bytes\n", total);
    477a:	85ce                	mv	a1,s3
    477c:	00003517          	auipc	a0,0x3
    4780:	c0c50513          	add	a0,a0,-1012 # 7388 <malloc+0x218c>
    4784:	1c5000ef          	jal	5148 <printf>
    close(fd);
    4788:	854a                	mv	a0,s2
    478a:	5a4000ef          	jal	4d2e <close>
    if(total == 0)
    478e:	f2098fe3          	beqz	s3,46cc <fsfull+0xac>
  for(nfiles = 0; ; nfiles++){
    4792:	2485                	addw	s1,s1,1
    4794:	b5f1                	j	4660 <fsfull+0x40>

0000000000004796 <run>:
//

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int
run(void f(char *), char *s) {
    4796:	7179                	add	sp,sp,-48
    4798:	f406                	sd	ra,40(sp)
    479a:	f022                	sd	s0,32(sp)
    479c:	ec26                	sd	s1,24(sp)
    479e:	e84a                	sd	s2,16(sp)
    47a0:	1800                	add	s0,sp,48
    47a2:	84aa                	mv	s1,a0
    47a4:	892e                	mv	s2,a1
  int pid;
  int xstatus;

  printf("test %s: ", s);
    47a6:	00003517          	auipc	a0,0x3
    47aa:	c0a50513          	add	a0,a0,-1014 # 73b0 <malloc+0x21b4>
    47ae:	19b000ef          	jal	5148 <printf>
  if((pid = fork()) < 0) {
    47b2:	54c000ef          	jal	4cfe <fork>
    47b6:	02054a63          	bltz	a0,47ea <run+0x54>
    printf("runtest: fork error\n");
    exit(1);
  }
  if(pid == 0) {
    47ba:	c129                	beqz	a0,47fc <run+0x66>
    f(s);
    exit(0);
  } else {
    wait(&xstatus);
    47bc:	fdc40513          	add	a0,s0,-36
    47c0:	54e000ef          	jal	4d0e <wait>
    if(xstatus != 0) 
    47c4:	fdc42783          	lw	a5,-36(s0)
    47c8:	cf9d                	beqz	a5,4806 <run+0x70>
      printf("FAILED\n");
    47ca:	00003517          	auipc	a0,0x3
    47ce:	c0e50513          	add	a0,a0,-1010 # 73d8 <malloc+0x21dc>
    47d2:	177000ef          	jal	5148 <printf>
    else
      printf("OK\n");
    return xstatus == 0;
    47d6:	fdc42503          	lw	a0,-36(s0)
  }
}
    47da:	00153513          	seqz	a0,a0
    47de:	70a2                	ld	ra,40(sp)
    47e0:	7402                	ld	s0,32(sp)
    47e2:	64e2                	ld	s1,24(sp)
    47e4:	6942                	ld	s2,16(sp)
    47e6:	6145                	add	sp,sp,48
    47e8:	8082                	ret
    printf("runtest: fork error\n");
    47ea:	00003517          	auipc	a0,0x3
    47ee:	bd650513          	add	a0,a0,-1066 # 73c0 <malloc+0x21c4>
    47f2:	157000ef          	jal	5148 <printf>
    exit(1);
    47f6:	4505                	li	a0,1
    47f8:	50e000ef          	jal	4d06 <exit>
    f(s);
    47fc:	854a                	mv	a0,s2
    47fe:	9482                	jalr	s1
    exit(0);
    4800:	4501                	li	a0,0
    4802:	504000ef          	jal	4d06 <exit>
      printf("OK\n");
    4806:	00003517          	auipc	a0,0x3
    480a:	bda50513          	add	a0,a0,-1062 # 73e0 <malloc+0x21e4>
    480e:	13b000ef          	jal	5148 <printf>
    4812:	b7d1                	j	47d6 <run+0x40>

0000000000004814 <runtests>:

int
runtests(struct test *tests, char *justone, int continuous) {
    4814:	7139                	add	sp,sp,-64
    4816:	fc06                	sd	ra,56(sp)
    4818:	f822                	sd	s0,48(sp)
    481a:	f426                	sd	s1,40(sp)
    481c:	f04a                	sd	s2,32(sp)
    481e:	ec4e                	sd	s3,24(sp)
    4820:	e852                	sd	s4,16(sp)
    4822:	e456                	sd	s5,8(sp)
    4824:	0080                	add	s0,sp,64
    4826:	84aa                	mv	s1,a0
  int ntests = 0;
  for (struct test *t = tests; t->s != 0; t++) {
    4828:	6508                	ld	a0,8(a0)
    482a:	c921                	beqz	a0,487a <runtests+0x66>
    482c:	892e                	mv	s2,a1
    482e:	8a32                	mv	s4,a2
  int ntests = 0;
    4830:	4981                	li	s3,0
    if((justone == 0) || strcmp(t->s, justone) == 0) {
      ntests++;
      if(!run(t->f, t->s)){
        if(continuous != 2){
    4832:	4a89                	li	s5,2
    4834:	a021                	j	483c <runtests+0x28>
  for (struct test *t = tests; t->s != 0; t++) {
    4836:	04c1                	add	s1,s1,16
    4838:	6488                	ld	a0,8(s1)
    483a:	c515                	beqz	a0,4866 <runtests+0x52>
    if((justone == 0) || strcmp(t->s, justone) == 0) {
    483c:	00090663          	beqz	s2,4848 <runtests+0x34>
    4840:	85ca                	mv	a1,s2
    4842:	25c000ef          	jal	4a9e <strcmp>
    4846:	f965                	bnez	a0,4836 <runtests+0x22>
      ntests++;
    4848:	2985                	addw	s3,s3,1 # 1000001 <base+0xff1349>
      if(!run(t->f, t->s)){
    484a:	648c                	ld	a1,8(s1)
    484c:	6088                	ld	a0,0(s1)
    484e:	f49ff0ef          	jal	4796 <run>
    4852:	f175                	bnez	a0,4836 <runtests+0x22>
        if(continuous != 2){
    4854:	ff5a01e3          	beq	s4,s5,4836 <runtests+0x22>
          printf("SOME TESTS FAILED\n");
    4858:	00003517          	auipc	a0,0x3
    485c:	b9050513          	add	a0,a0,-1136 # 73e8 <malloc+0x21ec>
    4860:	0e9000ef          	jal	5148 <printf>
          return -1;
    4864:	59fd                	li	s3,-1
        }
      }
    }
  }
  return ntests;
}
    4866:	854e                	mv	a0,s3
    4868:	70e2                	ld	ra,56(sp)
    486a:	7442                	ld	s0,48(sp)
    486c:	74a2                	ld	s1,40(sp)
    486e:	7902                	ld	s2,32(sp)
    4870:	69e2                	ld	s3,24(sp)
    4872:	6a42                	ld	s4,16(sp)
    4874:	6aa2                	ld	s5,8(sp)
    4876:	6121                	add	sp,sp,64
    4878:	8082                	ret
  int ntests = 0;
    487a:	4981                	li	s3,0
    487c:	b7ed                	j	4866 <runtests+0x52>

000000000000487e <countfree>:


// use sbrk() to count how many free physical memory pages there are.
int
countfree()
{
    487e:	7179                	add	sp,sp,-48
    4880:	f406                	sd	ra,40(sp)
    4882:	f022                	sd	s0,32(sp)
    4884:	ec26                	sd	s1,24(sp)
    4886:	e84a                	sd	s2,16(sp)
    4888:	e44e                	sd	s3,8(sp)
    488a:	1800                	add	s0,sp,48
  int n = 0;
  uint64 sz0 = (uint64)sbrk(0);
    488c:	4501                	li	a0,0
    488e:	444000ef          	jal	4cd2 <sbrk>
    4892:	89aa                	mv	s3,a0
  int n = 0;
    4894:	4481                	li	s1,0
  while(1){
    char *a = sbrk(PGSIZE);
    if(a == SBRK_ERROR){
    4896:	597d                	li	s2,-1
    4898:	a011                	j	489c <countfree+0x1e>
      break;
    }
    n += 1;
    489a:	2485                	addw	s1,s1,1
    char *a = sbrk(PGSIZE);
    489c:	6505                	lui	a0,0x1
    489e:	434000ef          	jal	4cd2 <sbrk>
    if(a == SBRK_ERROR){
    48a2:	ff251ce3          	bne	a0,s2,489a <countfree+0x1c>
  }
  sbrk(-((uint64)sbrk(0) - sz0));  
    48a6:	4501                	li	a0,0
    48a8:	42a000ef          	jal	4cd2 <sbrk>
    48ac:	40a9853b          	subw	a0,s3,a0
    48b0:	422000ef          	jal	4cd2 <sbrk>
  return n;
}
    48b4:	8526                	mv	a0,s1
    48b6:	70a2                	ld	ra,40(sp)
    48b8:	7402                	ld	s0,32(sp)
    48ba:	64e2                	ld	s1,24(sp)
    48bc:	6942                	ld	s2,16(sp)
    48be:	69a2                	ld	s3,8(sp)
    48c0:	6145                	add	sp,sp,48
    48c2:	8082                	ret

00000000000048c4 <drivetests>:

int
drivetests(int quick, int continuous, char *justone) {
    48c4:	7159                	add	sp,sp,-112
    48c6:	f486                	sd	ra,104(sp)
    48c8:	f0a2                	sd	s0,96(sp)
    48ca:	eca6                	sd	s1,88(sp)
    48cc:	e8ca                	sd	s2,80(sp)
    48ce:	e4ce                	sd	s3,72(sp)
    48d0:	e0d2                	sd	s4,64(sp)
    48d2:	fc56                	sd	s5,56(sp)
    48d4:	f85a                	sd	s6,48(sp)
    48d6:	f45e                	sd	s7,40(sp)
    48d8:	f062                	sd	s8,32(sp)
    48da:	ec66                	sd	s9,24(sp)
    48dc:	e86a                	sd	s10,16(sp)
    48de:	e46e                	sd	s11,8(sp)
    48e0:	1880                	add	s0,sp,112
    48e2:	8aaa                	mv	s5,a0
    48e4:	89ae                	mv	s3,a1
    48e6:	8a32                	mv	s4,a2
  do {
    printf("usertests starting\n");
    48e8:	00003c17          	auipc	s8,0x3
    48ec:	b18c0c13          	add	s8,s8,-1256 # 7400 <malloc+0x2204>
    int free0 = countfree();
    int free1 = 0;
    int ntests = 0;
    int n;
    n = runtests(quicktests, justone, continuous);
    48f0:	00003b97          	auipc	s7,0x3
    48f4:	720b8b93          	add	s7,s7,1824 # 8010 <quicktests>
    if (n < 0) {
      if(continuous != 2) {
    48f8:	4b09                	li	s6,2
      ntests += n;
    }
    if(!quick) {
      if (justone == 0)
        printf("usertests slow tests starting\n");
      n = runtests(slowtests, justone, continuous);
    48fa:	00004c97          	auipc	s9,0x4
    48fe:	b26c8c93          	add	s9,s9,-1242 # 8420 <slowtests>
        printf("usertests slow tests starting\n");
    4902:	00003d97          	auipc	s11,0x3
    4906:	b16d8d93          	add	s11,s11,-1258 # 7418 <malloc+0x221c>
      } else {
        ntests += n;
      }
    }
    if((free1 = countfree()) < free0) {
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    490a:	00003d17          	auipc	s10,0x3
    490e:	b2ed0d13          	add	s10,s10,-1234 # 7438 <malloc+0x223c>
    4912:	a025                	j	493a <drivetests+0x76>
      if(continuous != 2) {
    4914:	09699063          	bne	s3,s6,4994 <drivetests+0xd0>
    int ntests = 0;
    4918:	4481                	li	s1,0
    491a:	a835                	j	4956 <drivetests+0x92>
        printf("usertests slow tests starting\n");
    491c:	856e                	mv	a0,s11
    491e:	02b000ef          	jal	5148 <printf>
    4922:	a835                	j	495e <drivetests+0x9a>
        if(continuous != 2) {
    4924:	07699a63          	bne	s3,s6,4998 <drivetests+0xd4>
    if((free1 = countfree()) < free0) {
    4928:	f57ff0ef          	jal	487e <countfree>
    492c:	05254263          	blt	a0,s2,4970 <drivetests+0xac>
      if(continuous != 2) {
        return 1;
      }
    }
    if (justone != 0 && ntests == 0) {
    4930:	000a0363          	beqz	s4,4936 <drivetests+0x72>
    4934:	c8a1                	beqz	s1,4984 <drivetests+0xc0>
      printf("NO TESTS EXECUTED\n");
      return 1;
    }
  } while(continuous);
    4936:	06098563          	beqz	s3,49a0 <drivetests+0xdc>
    printf("usertests starting\n");
    493a:	8562                	mv	a0,s8
    493c:	00d000ef          	jal	5148 <printf>
    int free0 = countfree();
    4940:	f3fff0ef          	jal	487e <countfree>
    4944:	892a                	mv	s2,a0
    n = runtests(quicktests, justone, continuous);
    4946:	864e                	mv	a2,s3
    4948:	85d2                	mv	a1,s4
    494a:	855e                	mv	a0,s7
    494c:	ec9ff0ef          	jal	4814 <runtests>
    4950:	84aa                	mv	s1,a0
    if (n < 0) {
    4952:	fc0541e3          	bltz	a0,4914 <drivetests+0x50>
    if(!quick) {
    4956:	fc0a99e3          	bnez	s5,4928 <drivetests+0x64>
      if (justone == 0)
    495a:	fc0a01e3          	beqz	s4,491c <drivetests+0x58>
      n = runtests(slowtests, justone, continuous);
    495e:	864e                	mv	a2,s3
    4960:	85d2                	mv	a1,s4
    4962:	8566                	mv	a0,s9
    4964:	eb1ff0ef          	jal	4814 <runtests>
      if (n < 0) {
    4968:	fa054ee3          	bltz	a0,4924 <drivetests+0x60>
        ntests += n;
    496c:	9ca9                	addw	s1,s1,a0
    496e:	bf6d                	j	4928 <drivetests+0x64>
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    4970:	864a                	mv	a2,s2
    4972:	85aa                	mv	a1,a0
    4974:	856a                	mv	a0,s10
    4976:	7d2000ef          	jal	5148 <printf>
      if(continuous != 2) {
    497a:	03699163          	bne	s3,s6,499c <drivetests+0xd8>
    if (justone != 0 && ntests == 0) {
    497e:	fa0a1be3          	bnez	s4,4934 <drivetests+0x70>
    4982:	bf65                	j	493a <drivetests+0x76>
      printf("NO TESTS EXECUTED\n");
    4984:	00003517          	auipc	a0,0x3
    4988:	ae450513          	add	a0,a0,-1308 # 7468 <malloc+0x226c>
    498c:	7bc000ef          	jal	5148 <printf>
      return 1;
    4990:	4505                	li	a0,1
    4992:	a801                	j	49a2 <drivetests+0xde>
        return 1;
    4994:	4505                	li	a0,1
    4996:	a031                	j	49a2 <drivetests+0xde>
          return 1;
    4998:	4505                	li	a0,1
    499a:	a021                	j	49a2 <drivetests+0xde>
        return 1;
    499c:	4505                	li	a0,1
    499e:	a011                	j	49a2 <drivetests+0xde>
  return 0;
    49a0:	854e                	mv	a0,s3
}
    49a2:	70a6                	ld	ra,104(sp)
    49a4:	7406                	ld	s0,96(sp)
    49a6:	64e6                	ld	s1,88(sp)
    49a8:	6946                	ld	s2,80(sp)
    49aa:	69a6                	ld	s3,72(sp)
    49ac:	6a06                	ld	s4,64(sp)
    49ae:	7ae2                	ld	s5,56(sp)
    49b0:	7b42                	ld	s6,48(sp)
    49b2:	7ba2                	ld	s7,40(sp)
    49b4:	7c02                	ld	s8,32(sp)
    49b6:	6ce2                	ld	s9,24(sp)
    49b8:	6d42                	ld	s10,16(sp)
    49ba:	6da2                	ld	s11,8(sp)
    49bc:	6165                	add	sp,sp,112
    49be:	8082                	ret

00000000000049c0 <main>:

int
main(int argc, char *argv[])
{
    49c0:	1101                	add	sp,sp,-32
    49c2:	ec06                	sd	ra,24(sp)
    49c4:	e822                	sd	s0,16(sp)
    49c6:	e426                	sd	s1,8(sp)
    49c8:	e04a                	sd	s2,0(sp)
    49ca:	1000                	add	s0,sp,32
    49cc:	84aa                	mv	s1,a0
  int continuous = 0;
  int quick = 0;
  char *justone = 0;

  if(argc == 2 && strcmp(argv[1], "-q") == 0){
    49ce:	4789                	li	a5,2
    49d0:	00f50e63          	beq	a0,a5,49ec <main+0x2c>
    continuous = 1;
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    continuous = 2;
  } else if(argc == 2 && argv[1][0] != '-'){
    justone = argv[1];
  } else if(argc > 1){
    49d4:	4785                	li	a5,1
    49d6:	06a7c663          	blt	a5,a0,4a42 <main+0x82>
  char *justone = 0;
    49da:	4601                	li	a2,0
  int quick = 0;
    49dc:	4501                	li	a0,0
  int continuous = 0;
    49de:	4581                	li	a1,0
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    exit(1);
  }
  if (drivetests(quick, continuous, justone)) {
    49e0:	ee5ff0ef          	jal	48c4 <drivetests>
    49e4:	cd35                	beqz	a0,4a60 <main+0xa0>
    exit(1);
    49e6:	4505                	li	a0,1
    49e8:	31e000ef          	jal	4d06 <exit>
    49ec:	892e                	mv	s2,a1
  if(argc == 2 && strcmp(argv[1], "-q") == 0){
    49ee:	00003597          	auipc	a1,0x3
    49f2:	a9258593          	add	a1,a1,-1390 # 7480 <malloc+0x2284>
    49f6:	00893503          	ld	a0,8(s2) # ffffffffffffd008 <base+0xfffffffffffee350>
    49fa:	0a4000ef          	jal	4a9e <strcmp>
    49fe:	85aa                	mv	a1,a0
    4a00:	e501                	bnez	a0,4a08 <main+0x48>
  char *justone = 0;
    4a02:	4601                	li	a2,0
    quick = 1;
    4a04:	4505                	li	a0,1
    4a06:	bfe9                	j	49e0 <main+0x20>
  } else if(argc == 2 && strcmp(argv[1], "-c") == 0){
    4a08:	00003597          	auipc	a1,0x3
    4a0c:	a8058593          	add	a1,a1,-1408 # 7488 <malloc+0x228c>
    4a10:	00893503          	ld	a0,8(s2)
    4a14:	08a000ef          	jal	4a9e <strcmp>
    4a18:	cd15                	beqz	a0,4a54 <main+0x94>
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    4a1a:	00003597          	auipc	a1,0x3
    4a1e:	abe58593          	add	a1,a1,-1346 # 74d8 <malloc+0x22dc>
    4a22:	00893503          	ld	a0,8(s2)
    4a26:	078000ef          	jal	4a9e <strcmp>
    4a2a:	c905                	beqz	a0,4a5a <main+0x9a>
  } else if(argc == 2 && argv[1][0] != '-'){
    4a2c:	00893603          	ld	a2,8(s2)
    4a30:	00064703          	lbu	a4,0(a2) # 1000 <badarg>
    4a34:	02d00793          	li	a5,45
    4a38:	00f70563          	beq	a4,a5,4a42 <main+0x82>
  int quick = 0;
    4a3c:	4501                	li	a0,0
  int continuous = 0;
    4a3e:	4581                	li	a1,0
    4a40:	b745                	j	49e0 <main+0x20>
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    4a42:	00003517          	auipc	a0,0x3
    4a46:	a4e50513          	add	a0,a0,-1458 # 7490 <malloc+0x2294>
    4a4a:	6fe000ef          	jal	5148 <printf>
    exit(1);
    4a4e:	4505                	li	a0,1
    4a50:	2b6000ef          	jal	4d06 <exit>
  char *justone = 0;
    4a54:	4601                	li	a2,0
    continuous = 1;
    4a56:	4585                	li	a1,1
    4a58:	b761                	j	49e0 <main+0x20>
    continuous = 2;
    4a5a:	85a6                	mv	a1,s1
  char *justone = 0;
    4a5c:	4601                	li	a2,0
    4a5e:	b749                	j	49e0 <main+0x20>
  }
  printf("ALL TESTS PASSED\n");
    4a60:	00003517          	auipc	a0,0x3
    4a64:	a6050513          	add	a0,a0,-1440 # 74c0 <malloc+0x22c4>
    4a68:	6e0000ef          	jal	5148 <printf>
  exit(0);
    4a6c:	4501                	li	a0,0
    4a6e:	298000ef          	jal	4d06 <exit>

0000000000004a72 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
    4a72:	1141                	add	sp,sp,-16
    4a74:	e406                	sd	ra,8(sp)
    4a76:	e022                	sd	s0,0(sp)
    4a78:	0800                	add	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
    4a7a:	f47ff0ef          	jal	49c0 <main>
  exit(r);
    4a7e:	288000ef          	jal	4d06 <exit>

0000000000004a82 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
    4a82:	1141                	add	sp,sp,-16
    4a84:	e422                	sd	s0,8(sp)
    4a86:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    4a88:	87aa                	mv	a5,a0
    4a8a:	0585                	add	a1,a1,1
    4a8c:	0785                	add	a5,a5,1
    4a8e:	fff5c703          	lbu	a4,-1(a1)
    4a92:	fee78fa3          	sb	a4,-1(a5)
    4a96:	fb75                	bnez	a4,4a8a <strcpy+0x8>
    ;
  return os;
}
    4a98:	6422                	ld	s0,8(sp)
    4a9a:	0141                	add	sp,sp,16
    4a9c:	8082                	ret

0000000000004a9e <strcmp>:

int
strcmp(const char *p, const char *q)
{
    4a9e:	1141                	add	sp,sp,-16
    4aa0:	e422                	sd	s0,8(sp)
    4aa2:	0800                	add	s0,sp,16
  while(*p && *p == *q)
    4aa4:	00054783          	lbu	a5,0(a0)
    4aa8:	cb91                	beqz	a5,4abc <strcmp+0x1e>
    4aaa:	0005c703          	lbu	a4,0(a1)
    4aae:	00f71763          	bne	a4,a5,4abc <strcmp+0x1e>
    p++, q++;
    4ab2:	0505                	add	a0,a0,1
    4ab4:	0585                	add	a1,a1,1
  while(*p && *p == *q)
    4ab6:	00054783          	lbu	a5,0(a0)
    4aba:	fbe5                	bnez	a5,4aaa <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    4abc:	0005c503          	lbu	a0,0(a1)
}
    4ac0:	40a7853b          	subw	a0,a5,a0
    4ac4:	6422                	ld	s0,8(sp)
    4ac6:	0141                	add	sp,sp,16
    4ac8:	8082                	ret

0000000000004aca <strlen>:

uint
strlen(const char *s)
{
    4aca:	1141                	add	sp,sp,-16
    4acc:	e422                	sd	s0,8(sp)
    4ace:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    4ad0:	00054783          	lbu	a5,0(a0)
    4ad4:	cf91                	beqz	a5,4af0 <strlen+0x26>
    4ad6:	0505                	add	a0,a0,1
    4ad8:	87aa                	mv	a5,a0
    4ada:	86be                	mv	a3,a5
    4adc:	0785                	add	a5,a5,1
    4ade:	fff7c703          	lbu	a4,-1(a5)
    4ae2:	ff65                	bnez	a4,4ada <strlen+0x10>
    4ae4:	40a6853b          	subw	a0,a3,a0
    4ae8:	2505                	addw	a0,a0,1
    ;
  return n;
}
    4aea:	6422                	ld	s0,8(sp)
    4aec:	0141                	add	sp,sp,16
    4aee:	8082                	ret
  for(n = 0; s[n]; n++)
    4af0:	4501                	li	a0,0
    4af2:	bfe5                	j	4aea <strlen+0x20>

0000000000004af4 <memset>:

void*
memset(void *dst, int c, uint n)
{
    4af4:	1141                	add	sp,sp,-16
    4af6:	e422                	sd	s0,8(sp)
    4af8:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    4afa:	ca19                	beqz	a2,4b10 <memset+0x1c>
    4afc:	87aa                	mv	a5,a0
    4afe:	1602                	sll	a2,a2,0x20
    4b00:	9201                	srl	a2,a2,0x20
    4b02:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    4b06:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    4b0a:	0785                	add	a5,a5,1
    4b0c:	fee79de3          	bne	a5,a4,4b06 <memset+0x12>
  }
  return dst;
}
    4b10:	6422                	ld	s0,8(sp)
    4b12:	0141                	add	sp,sp,16
    4b14:	8082                	ret

0000000000004b16 <strchr>:

char*
strchr(const char *s, char c)
{
    4b16:	1141                	add	sp,sp,-16
    4b18:	e422                	sd	s0,8(sp)
    4b1a:	0800                	add	s0,sp,16
  for(; *s; s++)
    4b1c:	00054783          	lbu	a5,0(a0)
    4b20:	cb99                	beqz	a5,4b36 <strchr+0x20>
    if(*s == c)
    4b22:	00f58763          	beq	a1,a5,4b30 <strchr+0x1a>
  for(; *s; s++)
    4b26:	0505                	add	a0,a0,1
    4b28:	00054783          	lbu	a5,0(a0)
    4b2c:	fbfd                	bnez	a5,4b22 <strchr+0xc>
      return (char*)s;
  return 0;
    4b2e:	4501                	li	a0,0
}
    4b30:	6422                	ld	s0,8(sp)
    4b32:	0141                	add	sp,sp,16
    4b34:	8082                	ret
  return 0;
    4b36:	4501                	li	a0,0
    4b38:	bfe5                	j	4b30 <strchr+0x1a>

0000000000004b3a <gets>:

char*
gets(char *buf, int max)
{
    4b3a:	711d                	add	sp,sp,-96
    4b3c:	ec86                	sd	ra,88(sp)
    4b3e:	e8a2                	sd	s0,80(sp)
    4b40:	e4a6                	sd	s1,72(sp)
    4b42:	e0ca                	sd	s2,64(sp)
    4b44:	fc4e                	sd	s3,56(sp)
    4b46:	f852                	sd	s4,48(sp)
    4b48:	f456                	sd	s5,40(sp)
    4b4a:	f05a                	sd	s6,32(sp)
    4b4c:	ec5e                	sd	s7,24(sp)
    4b4e:	1080                	add	s0,sp,96
    4b50:	8baa                	mv	s7,a0
    4b52:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    4b54:	892a                	mv	s2,a0
    4b56:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    4b58:	4aa9                	li	s5,10
    4b5a:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    4b5c:	89a6                	mv	s3,s1
    4b5e:	2485                	addw	s1,s1,1
    4b60:	0344d663          	bge	s1,s4,4b8c <gets+0x52>
    cc = read(0, &c, 1);
    4b64:	4605                	li	a2,1
    4b66:	faf40593          	add	a1,s0,-81
    4b6a:	4501                	li	a0,0
    4b6c:	1b2000ef          	jal	4d1e <read>
    if(cc < 1)
    4b70:	00a05e63          	blez	a0,4b8c <gets+0x52>
    buf[i++] = c;
    4b74:	faf44783          	lbu	a5,-81(s0)
    4b78:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    4b7c:	01578763          	beq	a5,s5,4b8a <gets+0x50>
    4b80:	0905                	add	s2,s2,1
    4b82:	fd679de3          	bne	a5,s6,4b5c <gets+0x22>
  for(i=0; i+1 < max; ){
    4b86:	89a6                	mv	s3,s1
    4b88:	a011                	j	4b8c <gets+0x52>
    4b8a:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    4b8c:	99de                	add	s3,s3,s7
    4b8e:	00098023          	sb	zero,0(s3)
  return buf;
}
    4b92:	855e                	mv	a0,s7
    4b94:	60e6                	ld	ra,88(sp)
    4b96:	6446                	ld	s0,80(sp)
    4b98:	64a6                	ld	s1,72(sp)
    4b9a:	6906                	ld	s2,64(sp)
    4b9c:	79e2                	ld	s3,56(sp)
    4b9e:	7a42                	ld	s4,48(sp)
    4ba0:	7aa2                	ld	s5,40(sp)
    4ba2:	7b02                	ld	s6,32(sp)
    4ba4:	6be2                	ld	s7,24(sp)
    4ba6:	6125                	add	sp,sp,96
    4ba8:	8082                	ret

0000000000004baa <stat>:

int
stat(const char *n, struct stat *st)
{
    4baa:	1101                	add	sp,sp,-32
    4bac:	ec06                	sd	ra,24(sp)
    4bae:	e822                	sd	s0,16(sp)
    4bb0:	e426                	sd	s1,8(sp)
    4bb2:	e04a                	sd	s2,0(sp)
    4bb4:	1000                	add	s0,sp,32
    4bb6:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    4bb8:	4581                	li	a1,0
    4bba:	18c000ef          	jal	4d46 <open>
  if(fd < 0)
    4bbe:	02054163          	bltz	a0,4be0 <stat+0x36>
    4bc2:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    4bc4:	85ca                	mv	a1,s2
    4bc6:	198000ef          	jal	4d5e <fstat>
    4bca:	892a                	mv	s2,a0
  close(fd);
    4bcc:	8526                	mv	a0,s1
    4bce:	160000ef          	jal	4d2e <close>
  return r;
}
    4bd2:	854a                	mv	a0,s2
    4bd4:	60e2                	ld	ra,24(sp)
    4bd6:	6442                	ld	s0,16(sp)
    4bd8:	64a2                	ld	s1,8(sp)
    4bda:	6902                	ld	s2,0(sp)
    4bdc:	6105                	add	sp,sp,32
    4bde:	8082                	ret
    return -1;
    4be0:	597d                	li	s2,-1
    4be2:	bfc5                	j	4bd2 <stat+0x28>

0000000000004be4 <atoi>:

int
atoi(const char *s)
{
    4be4:	1141                	add	sp,sp,-16
    4be6:	e422                	sd	s0,8(sp)
    4be8:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    4bea:	00054683          	lbu	a3,0(a0)
    4bee:	fd06879b          	addw	a5,a3,-48 # 3ffd0 <base+0x31318>
    4bf2:	0ff7f793          	zext.b	a5,a5
    4bf6:	4625                	li	a2,9
    4bf8:	02f66863          	bltu	a2,a5,4c28 <atoi+0x44>
    4bfc:	872a                	mv	a4,a0
  n = 0;
    4bfe:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
    4c00:	0705                	add	a4,a4,1 # 1000001 <base+0xff1349>
    4c02:	0025179b          	sllw	a5,a0,0x2
    4c06:	9fa9                	addw	a5,a5,a0
    4c08:	0017979b          	sllw	a5,a5,0x1
    4c0c:	9fb5                	addw	a5,a5,a3
    4c0e:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    4c12:	00074683          	lbu	a3,0(a4)
    4c16:	fd06879b          	addw	a5,a3,-48
    4c1a:	0ff7f793          	zext.b	a5,a5
    4c1e:	fef671e3          	bgeu	a2,a5,4c00 <atoi+0x1c>
  return n;
}
    4c22:	6422                	ld	s0,8(sp)
    4c24:	0141                	add	sp,sp,16
    4c26:	8082                	ret
  n = 0;
    4c28:	4501                	li	a0,0
    4c2a:	bfe5                	j	4c22 <atoi+0x3e>

0000000000004c2c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    4c2c:	1141                	add	sp,sp,-16
    4c2e:	e422                	sd	s0,8(sp)
    4c30:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    4c32:	02b57463          	bgeu	a0,a1,4c5a <memmove+0x2e>
    while(n-- > 0)
    4c36:	00c05f63          	blez	a2,4c54 <memmove+0x28>
    4c3a:	1602                	sll	a2,a2,0x20
    4c3c:	9201                	srl	a2,a2,0x20
    4c3e:	00c507b3          	add	a5,a0,a2
  dst = vdst;
    4c42:	872a                	mv	a4,a0
      *dst++ = *src++;
    4c44:	0585                	add	a1,a1,1
    4c46:	0705                	add	a4,a4,1
    4c48:	fff5c683          	lbu	a3,-1(a1)
    4c4c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    4c50:	fee79ae3          	bne	a5,a4,4c44 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    4c54:	6422                	ld	s0,8(sp)
    4c56:	0141                	add	sp,sp,16
    4c58:	8082                	ret
    dst += n;
    4c5a:	00c50733          	add	a4,a0,a2
    src += n;
    4c5e:	95b2                	add	a1,a1,a2
    while(n-- > 0)
    4c60:	fec05ae3          	blez	a2,4c54 <memmove+0x28>
    4c64:	fff6079b          	addw	a5,a2,-1
    4c68:	1782                	sll	a5,a5,0x20
    4c6a:	9381                	srl	a5,a5,0x20
    4c6c:	fff7c793          	not	a5,a5
    4c70:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    4c72:	15fd                	add	a1,a1,-1
    4c74:	177d                	add	a4,a4,-1
    4c76:	0005c683          	lbu	a3,0(a1)
    4c7a:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    4c7e:	fee79ae3          	bne	a5,a4,4c72 <memmove+0x46>
    4c82:	bfc9                	j	4c54 <memmove+0x28>

0000000000004c84 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    4c84:	1141                	add	sp,sp,-16
    4c86:	e422                	sd	s0,8(sp)
    4c88:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    4c8a:	ca05                	beqz	a2,4cba <memcmp+0x36>
    4c8c:	fff6069b          	addw	a3,a2,-1
    4c90:	1682                	sll	a3,a3,0x20
    4c92:	9281                	srl	a3,a3,0x20
    4c94:	0685                	add	a3,a3,1
    4c96:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
    4c98:	00054783          	lbu	a5,0(a0)
    4c9c:	0005c703          	lbu	a4,0(a1)
    4ca0:	00e79863          	bne	a5,a4,4cb0 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
    4ca4:	0505                	add	a0,a0,1
    p2++;
    4ca6:	0585                	add	a1,a1,1
  while (n-- > 0) {
    4ca8:	fed518e3          	bne	a0,a3,4c98 <memcmp+0x14>
  }
  return 0;
    4cac:	4501                	li	a0,0
    4cae:	a019                	j	4cb4 <memcmp+0x30>
      return *p1 - *p2;
    4cb0:	40e7853b          	subw	a0,a5,a4
}
    4cb4:	6422                	ld	s0,8(sp)
    4cb6:	0141                	add	sp,sp,16
    4cb8:	8082                	ret
  return 0;
    4cba:	4501                	li	a0,0
    4cbc:	bfe5                	j	4cb4 <memcmp+0x30>

0000000000004cbe <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    4cbe:	1141                	add	sp,sp,-16
    4cc0:	e406                	sd	ra,8(sp)
    4cc2:	e022                	sd	s0,0(sp)
    4cc4:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
    4cc6:	f67ff0ef          	jal	4c2c <memmove>
}
    4cca:	60a2                	ld	ra,8(sp)
    4ccc:	6402                	ld	s0,0(sp)
    4cce:	0141                	add	sp,sp,16
    4cd0:	8082                	ret

0000000000004cd2 <sbrk>:

char *
sbrk(int n) {
    4cd2:	1141                	add	sp,sp,-16
    4cd4:	e406                	sd	ra,8(sp)
    4cd6:	e022                	sd	s0,0(sp)
    4cd8:	0800                	add	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
    4cda:	4585                	li	a1,1
    4cdc:	0b2000ef          	jal	4d8e <sys_sbrk>
}
    4ce0:	60a2                	ld	ra,8(sp)
    4ce2:	6402                	ld	s0,0(sp)
    4ce4:	0141                	add	sp,sp,16
    4ce6:	8082                	ret

0000000000004ce8 <sbrklazy>:

char *
sbrklazy(int n) {
    4ce8:	1141                	add	sp,sp,-16
    4cea:	e406                	sd	ra,8(sp)
    4cec:	e022                	sd	s0,0(sp)
    4cee:	0800                	add	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
    4cf0:	4589                	li	a1,2
    4cf2:	09c000ef          	jal	4d8e <sys_sbrk>
}
    4cf6:	60a2                	ld	ra,8(sp)
    4cf8:	6402                	ld	s0,0(sp)
    4cfa:	0141                	add	sp,sp,16
    4cfc:	8082                	ret

0000000000004cfe <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    4cfe:	4885                	li	a7,1
 ecall
    4d00:	00000073          	ecall
 ret
    4d04:	8082                	ret

0000000000004d06 <exit>:
.global exit
exit:
 li a7, SYS_exit
    4d06:	4889                	li	a7,2
 ecall
    4d08:	00000073          	ecall
 ret
    4d0c:	8082                	ret

0000000000004d0e <wait>:
.global wait
wait:
 li a7, SYS_wait
    4d0e:	488d                	li	a7,3
 ecall
    4d10:	00000073          	ecall
 ret
    4d14:	8082                	ret

0000000000004d16 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    4d16:	4891                	li	a7,4
 ecall
    4d18:	00000073          	ecall
 ret
    4d1c:	8082                	ret

0000000000004d1e <read>:
.global read
read:
 li a7, SYS_read
    4d1e:	4895                	li	a7,5
 ecall
    4d20:	00000073          	ecall
 ret
    4d24:	8082                	ret

0000000000004d26 <write>:
.global write
write:
 li a7, SYS_write
    4d26:	48c1                	li	a7,16
 ecall
    4d28:	00000073          	ecall
 ret
    4d2c:	8082                	ret

0000000000004d2e <close>:
.global close
close:
 li a7, SYS_close
    4d2e:	48d5                	li	a7,21
 ecall
    4d30:	00000073          	ecall
 ret
    4d34:	8082                	ret

0000000000004d36 <kill>:
.global kill
kill:
 li a7, SYS_kill
    4d36:	4899                	li	a7,6
 ecall
    4d38:	00000073          	ecall
 ret
    4d3c:	8082                	ret

0000000000004d3e <exec>:
.global exec
exec:
 li a7, SYS_exec
    4d3e:	489d                	li	a7,7
 ecall
    4d40:	00000073          	ecall
 ret
    4d44:	8082                	ret

0000000000004d46 <open>:
.global open
open:
 li a7, SYS_open
    4d46:	48bd                	li	a7,15
 ecall
    4d48:	00000073          	ecall
 ret
    4d4c:	8082                	ret

0000000000004d4e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    4d4e:	48c5                	li	a7,17
 ecall
    4d50:	00000073          	ecall
 ret
    4d54:	8082                	ret

0000000000004d56 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    4d56:	48c9                	li	a7,18
 ecall
    4d58:	00000073          	ecall
 ret
    4d5c:	8082                	ret

0000000000004d5e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    4d5e:	48a1                	li	a7,8
 ecall
    4d60:	00000073          	ecall
 ret
    4d64:	8082                	ret

0000000000004d66 <link>:
.global link
link:
 li a7, SYS_link
    4d66:	48cd                	li	a7,19
 ecall
    4d68:	00000073          	ecall
 ret
    4d6c:	8082                	ret

0000000000004d6e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    4d6e:	48d1                	li	a7,20
 ecall
    4d70:	00000073          	ecall
 ret
    4d74:	8082                	ret

0000000000004d76 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    4d76:	48a5                	li	a7,9
 ecall
    4d78:	00000073          	ecall
 ret
    4d7c:	8082                	ret

0000000000004d7e <dup>:
.global dup
dup:
 li a7, SYS_dup
    4d7e:	48a9                	li	a7,10
 ecall
    4d80:	00000073          	ecall
 ret
    4d84:	8082                	ret

0000000000004d86 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    4d86:	48ad                	li	a7,11
 ecall
    4d88:	00000073          	ecall
 ret
    4d8c:	8082                	ret

0000000000004d8e <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
    4d8e:	48b1                	li	a7,12
 ecall
    4d90:	00000073          	ecall
 ret
    4d94:	8082                	ret

0000000000004d96 <pause>:
.global pause
pause:
 li a7, SYS_pause
    4d96:	48b5                	li	a7,13
 ecall
    4d98:	00000073          	ecall
 ret
    4d9c:	8082                	ret

0000000000004d9e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    4d9e:	48b9                	li	a7,14
 ecall
    4da0:	00000073          	ecall
 ret
    4da4:	8082                	ret

0000000000004da6 <getcnt>:
.global getcnt
getcnt:
 li a7, SYS_getcnt
    4da6:	48d9                	li	a7,22
 ecall
    4da8:	00000073          	ecall
 ret
    4dac:	8082                	ret

0000000000004dae <settickets>:
.global settickets
settickets:
 li a7, SYS_settickets
    4dae:	48dd                	li	a7,23
 ecall
    4db0:	00000073          	ecall
 ret
    4db4:	8082                	ret

0000000000004db6 <getpinfo>:
.global getpinfo
getpinfo:
 li a7, SYS_getpinfo
    4db6:	48e1                	li	a7,24
 ecall
    4db8:	00000073          	ecall
 ret
    4dbc:	8082                	ret

0000000000004dbe <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    4dbe:	1101                	add	sp,sp,-32
    4dc0:	ec06                	sd	ra,24(sp)
    4dc2:	e822                	sd	s0,16(sp)
    4dc4:	1000                	add	s0,sp,32
    4dc6:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    4dca:	4605                	li	a2,1
    4dcc:	fef40593          	add	a1,s0,-17
    4dd0:	f57ff0ef          	jal	4d26 <write>
}
    4dd4:	60e2                	ld	ra,24(sp)
    4dd6:	6442                	ld	s0,16(sp)
    4dd8:	6105                	add	sp,sp,32
    4dda:	8082                	ret

0000000000004ddc <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
    4ddc:	715d                	add	sp,sp,-80
    4dde:	e486                	sd	ra,72(sp)
    4de0:	e0a2                	sd	s0,64(sp)
    4de2:	fc26                	sd	s1,56(sp)
    4de4:	f84a                	sd	s2,48(sp)
    4de6:	f44e                	sd	s3,40(sp)
    4de8:	0880                	add	s0,sp,80
    4dea:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
    4dec:	c299                	beqz	a3,4df2 <printint+0x16>
    4dee:	0805c163          	bltz	a1,4e70 <printint+0x94>
  neg = 0;
    4df2:	4881                	li	a7,0
    4df4:	fb840693          	add	a3,s0,-72
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
    4df8:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
    4dfa:	00003517          	auipc	a0,0x3
    4dfe:	b0e50513          	add	a0,a0,-1266 # 7908 <digits>
    4e02:	883e                	mv	a6,a5
    4e04:	2785                	addw	a5,a5,1
    4e06:	02c5f733          	remu	a4,a1,a2
    4e0a:	972a                	add	a4,a4,a0
    4e0c:	00074703          	lbu	a4,0(a4)
    4e10:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
    4e14:	872e                	mv	a4,a1
    4e16:	02c5d5b3          	divu	a1,a1,a2
    4e1a:	0685                	add	a3,a3,1
    4e1c:	fec773e3          	bgeu	a4,a2,4e02 <printint+0x26>
  if(neg)
    4e20:	00088b63          	beqz	a7,4e36 <printint+0x5a>
    buf[i++] = '-';
    4e24:	fd078793          	add	a5,a5,-48
    4e28:	97a2                	add	a5,a5,s0
    4e2a:	02d00713          	li	a4,45
    4e2e:	fee78423          	sb	a4,-24(a5)
    4e32:	0028079b          	addw	a5,a6,2

  while(--i >= 0)
    4e36:	02f05663          	blez	a5,4e62 <printint+0x86>
    4e3a:	fb840713          	add	a4,s0,-72
    4e3e:	00f704b3          	add	s1,a4,a5
    4e42:	fff70993          	add	s3,a4,-1
    4e46:	99be                	add	s3,s3,a5
    4e48:	37fd                	addw	a5,a5,-1
    4e4a:	1782                	sll	a5,a5,0x20
    4e4c:	9381                	srl	a5,a5,0x20
    4e4e:	40f989b3          	sub	s3,s3,a5
    putc(fd, buf[i]);
    4e52:	fff4c583          	lbu	a1,-1(s1)
    4e56:	854a                	mv	a0,s2
    4e58:	f67ff0ef          	jal	4dbe <putc>
  while(--i >= 0)
    4e5c:	14fd                	add	s1,s1,-1
    4e5e:	ff349ae3          	bne	s1,s3,4e52 <printint+0x76>
}
    4e62:	60a6                	ld	ra,72(sp)
    4e64:	6406                	ld	s0,64(sp)
    4e66:	74e2                	ld	s1,56(sp)
    4e68:	7942                	ld	s2,48(sp)
    4e6a:	79a2                	ld	s3,40(sp)
    4e6c:	6161                	add	sp,sp,80
    4e6e:	8082                	ret
    x = -xx;
    4e70:	40b005b3          	neg	a1,a1
    neg = 1;
    4e74:	4885                	li	a7,1
    x = -xx;
    4e76:	bfbd                	j	4df4 <printint+0x18>

0000000000004e78 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    4e78:	711d                	add	sp,sp,-96
    4e7a:	ec86                	sd	ra,88(sp)
    4e7c:	e8a2                	sd	s0,80(sp)
    4e7e:	e4a6                	sd	s1,72(sp)
    4e80:	e0ca                	sd	s2,64(sp)
    4e82:	fc4e                	sd	s3,56(sp)
    4e84:	f852                	sd	s4,48(sp)
    4e86:	f456                	sd	s5,40(sp)
    4e88:	f05a                	sd	s6,32(sp)
    4e8a:	ec5e                	sd	s7,24(sp)
    4e8c:	e862                	sd	s8,16(sp)
    4e8e:	e466                	sd	s9,8(sp)
    4e90:	e06a                	sd	s10,0(sp)
    4e92:	1080                	add	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    4e94:	0005c903          	lbu	s2,0(a1)
    4e98:	26090563          	beqz	s2,5102 <vprintf+0x28a>
    4e9c:	8b2a                	mv	s6,a0
    4e9e:	8a2e                	mv	s4,a1
    4ea0:	8bb2                	mv	s7,a2
  state = 0;
    4ea2:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
    4ea4:	4481                	li	s1,0
    4ea6:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
    4ea8:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
    4eac:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
    4eb0:	06c00c93          	li	s9,108
    4eb4:	a005                	j	4ed4 <vprintf+0x5c>
        putc(fd, c0);
    4eb6:	85ca                	mv	a1,s2
    4eb8:	855a                	mv	a0,s6
    4eba:	f05ff0ef          	jal	4dbe <putc>
    4ebe:	a019                	j	4ec4 <vprintf+0x4c>
    } else if(state == '%'){
    4ec0:	03598263          	beq	s3,s5,4ee4 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
    4ec4:	2485                	addw	s1,s1,1
    4ec6:	8726                	mv	a4,s1
    4ec8:	009a07b3          	add	a5,s4,s1
    4ecc:	0007c903          	lbu	s2,0(a5)
    4ed0:	22090963          	beqz	s2,5102 <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
    4ed4:	0009079b          	sext.w	a5,s2
    if(state == 0){
    4ed8:	fe0994e3          	bnez	s3,4ec0 <vprintf+0x48>
      if(c0 == '%'){
    4edc:	fd579de3          	bne	a5,s5,4eb6 <vprintf+0x3e>
        state = '%';
    4ee0:	89be                	mv	s3,a5
    4ee2:	b7cd                	j	4ec4 <vprintf+0x4c>
      if(c0) c1 = fmt[i+1] & 0xff;
    4ee4:	cbc9                	beqz	a5,4f76 <vprintf+0xfe>
    4ee6:	00ea06b3          	add	a3,s4,a4
    4eea:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
    4eee:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
    4ef0:	c681                	beqz	a3,4ef8 <vprintf+0x80>
    4ef2:	9752                	add	a4,a4,s4
    4ef4:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
    4ef8:	05878363          	beq	a5,s8,4f3e <vprintf+0xc6>
      } else if(c0 == 'l' && c1 == 'd'){
    4efc:	05978d63          	beq	a5,s9,4f56 <vprintf+0xde>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
    4f00:	07500713          	li	a4,117
    4f04:	0ee78763          	beq	a5,a4,4ff2 <vprintf+0x17a>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
    4f08:	07800713          	li	a4,120
    4f0c:	12e78963          	beq	a5,a4,503e <vprintf+0x1c6>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
    4f10:	07000713          	li	a4,112
    4f14:	14e78e63          	beq	a5,a4,5070 <vprintf+0x1f8>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
    4f18:	06300713          	li	a4,99
    4f1c:	18e78c63          	beq	a5,a4,50b4 <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
    4f20:	07300713          	li	a4,115
    4f24:	1ae78263          	beq	a5,a4,50c8 <vprintf+0x250>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
    4f28:	02500713          	li	a4,37
    4f2c:	04e79563          	bne	a5,a4,4f76 <vprintf+0xfe>
        putc(fd, '%');
    4f30:	02500593          	li	a1,37
    4f34:	855a                	mv	a0,s6
    4f36:	e89ff0ef          	jal	4dbe <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
    4f3a:	4981                	li	s3,0
    4f3c:	b761                	j	4ec4 <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 10, 1);
    4f3e:	008b8913          	add	s2,s7,8
    4f42:	4685                	li	a3,1
    4f44:	4629                	li	a2,10
    4f46:	000ba583          	lw	a1,0(s7)
    4f4a:	855a                	mv	a0,s6
    4f4c:	e91ff0ef          	jal	4ddc <printint>
    4f50:	8bca                	mv	s7,s2
      state = 0;
    4f52:	4981                	li	s3,0
    4f54:	bf85                	j	4ec4 <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'd'){
    4f56:	06400793          	li	a5,100
    4f5a:	02f68963          	beq	a3,a5,4f8c <vprintf+0x114>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    4f5e:	06c00793          	li	a5,108
    4f62:	04f68263          	beq	a3,a5,4fa6 <vprintf+0x12e>
      } else if(c0 == 'l' && c1 == 'u'){
    4f66:	07500793          	li	a5,117
    4f6a:	0af68063          	beq	a3,a5,500a <vprintf+0x192>
      } else if(c0 == 'l' && c1 == 'x'){
    4f6e:	07800793          	li	a5,120
    4f72:	0ef68263          	beq	a3,a5,5056 <vprintf+0x1de>
        putc(fd, '%');
    4f76:	02500593          	li	a1,37
    4f7a:	855a                	mv	a0,s6
    4f7c:	e43ff0ef          	jal	4dbe <putc>
        putc(fd, c0);
    4f80:	85ca                	mv	a1,s2
    4f82:	855a                	mv	a0,s6
    4f84:	e3bff0ef          	jal	4dbe <putc>
      state = 0;
    4f88:	4981                	li	s3,0
    4f8a:	bf2d                	j	4ec4 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
    4f8c:	008b8913          	add	s2,s7,8
    4f90:	4685                	li	a3,1
    4f92:	4629                	li	a2,10
    4f94:	000bb583          	ld	a1,0(s7)
    4f98:	855a                	mv	a0,s6
    4f9a:	e43ff0ef          	jal	4ddc <printint>
        i += 1;
    4f9e:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
    4fa0:	8bca                	mv	s7,s2
      state = 0;
    4fa2:	4981                	li	s3,0
        i += 1;
    4fa4:	b705                	j	4ec4 <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    4fa6:	06400793          	li	a5,100
    4faa:	02f60763          	beq	a2,a5,4fd8 <vprintf+0x160>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    4fae:	07500793          	li	a5,117
    4fb2:	06f60963          	beq	a2,a5,5024 <vprintf+0x1ac>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    4fb6:	07800793          	li	a5,120
    4fba:	faf61ee3          	bne	a2,a5,4f76 <vprintf+0xfe>
        printint(fd, va_arg(ap, uint64), 16, 0);
    4fbe:	008b8913          	add	s2,s7,8
    4fc2:	4681                	li	a3,0
    4fc4:	4641                	li	a2,16
    4fc6:	000bb583          	ld	a1,0(s7)
    4fca:	855a                	mv	a0,s6
    4fcc:	e11ff0ef          	jal	4ddc <printint>
        i += 2;
    4fd0:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
    4fd2:	8bca                	mv	s7,s2
      state = 0;
    4fd4:	4981                	li	s3,0
        i += 2;
    4fd6:	b5fd                	j	4ec4 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
    4fd8:	008b8913          	add	s2,s7,8
    4fdc:	4685                	li	a3,1
    4fde:	4629                	li	a2,10
    4fe0:	000bb583          	ld	a1,0(s7)
    4fe4:	855a                	mv	a0,s6
    4fe6:	df7ff0ef          	jal	4ddc <printint>
        i += 2;
    4fea:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
    4fec:	8bca                	mv	s7,s2
      state = 0;
    4fee:	4981                	li	s3,0
        i += 2;
    4ff0:	bdd1                	j	4ec4 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint32), 10, 0);
    4ff2:	008b8913          	add	s2,s7,8
    4ff6:	4681                	li	a3,0
    4ff8:	4629                	li	a2,10
    4ffa:	000be583          	lwu	a1,0(s7)
    4ffe:	855a                	mv	a0,s6
    5000:	dddff0ef          	jal	4ddc <printint>
    5004:	8bca                	mv	s7,s2
      state = 0;
    5006:	4981                	li	s3,0
    5008:	bd75                	j	4ec4 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
    500a:	008b8913          	add	s2,s7,8
    500e:	4681                	li	a3,0
    5010:	4629                	li	a2,10
    5012:	000bb583          	ld	a1,0(s7)
    5016:	855a                	mv	a0,s6
    5018:	dc5ff0ef          	jal	4ddc <printint>
        i += 1;
    501c:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
    501e:	8bca                	mv	s7,s2
      state = 0;
    5020:	4981                	li	s3,0
        i += 1;
    5022:	b54d                	j	4ec4 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
    5024:	008b8913          	add	s2,s7,8
    5028:	4681                	li	a3,0
    502a:	4629                	li	a2,10
    502c:	000bb583          	ld	a1,0(s7)
    5030:	855a                	mv	a0,s6
    5032:	dabff0ef          	jal	4ddc <printint>
        i += 2;
    5036:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
    5038:	8bca                	mv	s7,s2
      state = 0;
    503a:	4981                	li	s3,0
        i += 2;
    503c:	b561                	j	4ec4 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint32), 16, 0);
    503e:	008b8913          	add	s2,s7,8
    5042:	4681                	li	a3,0
    5044:	4641                	li	a2,16
    5046:	000be583          	lwu	a1,0(s7)
    504a:	855a                	mv	a0,s6
    504c:	d91ff0ef          	jal	4ddc <printint>
    5050:	8bca                	mv	s7,s2
      state = 0;
    5052:	4981                	li	s3,0
    5054:	bd85                	j	4ec4 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 16, 0);
    5056:	008b8913          	add	s2,s7,8
    505a:	4681                	li	a3,0
    505c:	4641                	li	a2,16
    505e:	000bb583          	ld	a1,0(s7)
    5062:	855a                	mv	a0,s6
    5064:	d79ff0ef          	jal	4ddc <printint>
        i += 1;
    5068:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
    506a:	8bca                	mv	s7,s2
      state = 0;
    506c:	4981                	li	s3,0
        i += 1;
    506e:	bd99                	j	4ec4 <vprintf+0x4c>
        printptr(fd, va_arg(ap, uint64));
    5070:	008b8d13          	add	s10,s7,8
    5074:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    5078:	03000593          	li	a1,48
    507c:	855a                	mv	a0,s6
    507e:	d41ff0ef          	jal	4dbe <putc>
  putc(fd, 'x');
    5082:	07800593          	li	a1,120
    5086:	855a                	mv	a0,s6
    5088:	d37ff0ef          	jal	4dbe <putc>
    508c:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    508e:	00003b97          	auipc	s7,0x3
    5092:	87ab8b93          	add	s7,s7,-1926 # 7908 <digits>
    5096:	03c9d793          	srl	a5,s3,0x3c
    509a:	97de                	add	a5,a5,s7
    509c:	0007c583          	lbu	a1,0(a5)
    50a0:	855a                	mv	a0,s6
    50a2:	d1dff0ef          	jal	4dbe <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    50a6:	0992                	sll	s3,s3,0x4
    50a8:	397d                	addw	s2,s2,-1
    50aa:	fe0916e3          	bnez	s2,5096 <vprintf+0x21e>
        printptr(fd, va_arg(ap, uint64));
    50ae:	8bea                	mv	s7,s10
      state = 0;
    50b0:	4981                	li	s3,0
    50b2:	bd09                	j	4ec4 <vprintf+0x4c>
        putc(fd, va_arg(ap, uint32));
    50b4:	008b8913          	add	s2,s7,8
    50b8:	000bc583          	lbu	a1,0(s7)
    50bc:	855a                	mv	a0,s6
    50be:	d01ff0ef          	jal	4dbe <putc>
    50c2:	8bca                	mv	s7,s2
      state = 0;
    50c4:	4981                	li	s3,0
    50c6:	bbfd                	j	4ec4 <vprintf+0x4c>
        if((s = va_arg(ap, char*)) == 0)
    50c8:	008b8993          	add	s3,s7,8
    50cc:	000bb903          	ld	s2,0(s7)
    50d0:	00090f63          	beqz	s2,50ee <vprintf+0x276>
        for(; *s; s++)
    50d4:	00094583          	lbu	a1,0(s2)
    50d8:	c195                	beqz	a1,50fc <vprintf+0x284>
          putc(fd, *s);
    50da:	855a                	mv	a0,s6
    50dc:	ce3ff0ef          	jal	4dbe <putc>
        for(; *s; s++)
    50e0:	0905                	add	s2,s2,1
    50e2:	00094583          	lbu	a1,0(s2)
    50e6:	f9f5                	bnez	a1,50da <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
    50e8:	8bce                	mv	s7,s3
      state = 0;
    50ea:	4981                	li	s3,0
    50ec:	bbe1                	j	4ec4 <vprintf+0x4c>
          s = "(null)";
    50ee:	00003917          	auipc	s2,0x3
    50f2:	81290913          	add	s2,s2,-2030 # 7900 <malloc+0x2704>
        for(; *s; s++)
    50f6:	02800593          	li	a1,40
    50fa:	b7c5                	j	50da <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
    50fc:	8bce                	mv	s7,s3
      state = 0;
    50fe:	4981                	li	s3,0
    5100:	b3d1                	j	4ec4 <vprintf+0x4c>
    }
  }
}
    5102:	60e6                	ld	ra,88(sp)
    5104:	6446                	ld	s0,80(sp)
    5106:	64a6                	ld	s1,72(sp)
    5108:	6906                	ld	s2,64(sp)
    510a:	79e2                	ld	s3,56(sp)
    510c:	7a42                	ld	s4,48(sp)
    510e:	7aa2                	ld	s5,40(sp)
    5110:	7b02                	ld	s6,32(sp)
    5112:	6be2                	ld	s7,24(sp)
    5114:	6c42                	ld	s8,16(sp)
    5116:	6ca2                	ld	s9,8(sp)
    5118:	6d02                	ld	s10,0(sp)
    511a:	6125                	add	sp,sp,96
    511c:	8082                	ret

000000000000511e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    511e:	715d                	add	sp,sp,-80
    5120:	ec06                	sd	ra,24(sp)
    5122:	e822                	sd	s0,16(sp)
    5124:	1000                	add	s0,sp,32
    5126:	e010                	sd	a2,0(s0)
    5128:	e414                	sd	a3,8(s0)
    512a:	e818                	sd	a4,16(s0)
    512c:	ec1c                	sd	a5,24(s0)
    512e:	03043023          	sd	a6,32(s0)
    5132:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    5136:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    513a:	8622                	mv	a2,s0
    513c:	d3dff0ef          	jal	4e78 <vprintf>
}
    5140:	60e2                	ld	ra,24(sp)
    5142:	6442                	ld	s0,16(sp)
    5144:	6161                	add	sp,sp,80
    5146:	8082                	ret

0000000000005148 <printf>:

void
printf(const char *fmt, ...)
{
    5148:	711d                	add	sp,sp,-96
    514a:	ec06                	sd	ra,24(sp)
    514c:	e822                	sd	s0,16(sp)
    514e:	1000                	add	s0,sp,32
    5150:	e40c                	sd	a1,8(s0)
    5152:	e810                	sd	a2,16(s0)
    5154:	ec14                	sd	a3,24(s0)
    5156:	f018                	sd	a4,32(s0)
    5158:	f41c                	sd	a5,40(s0)
    515a:	03043823          	sd	a6,48(s0)
    515e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    5162:	00840613          	add	a2,s0,8
    5166:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    516a:	85aa                	mv	a1,a0
    516c:	4505                	li	a0,1
    516e:	d0bff0ef          	jal	4e78 <vprintf>
}
    5172:	60e2                	ld	ra,24(sp)
    5174:	6442                	ld	s0,16(sp)
    5176:	6125                	add	sp,sp,96
    5178:	8082                	ret

000000000000517a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    517a:	1141                	add	sp,sp,-16
    517c:	e422                	sd	s0,8(sp)
    517e:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    5180:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5184:	00003797          	auipc	a5,0x3
    5188:	30c7b783          	ld	a5,780(a5) # 8490 <freep>
    518c:	a02d                	j	51b6 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    518e:	4618                	lw	a4,8(a2)
    5190:	9f2d                	addw	a4,a4,a1
    5192:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    5196:	6398                	ld	a4,0(a5)
    5198:	6310                	ld	a2,0(a4)
    519a:	a83d                	j	51d8 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    519c:	ff852703          	lw	a4,-8(a0)
    51a0:	9f31                	addw	a4,a4,a2
    51a2:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    51a4:	ff053683          	ld	a3,-16(a0)
    51a8:	a091                	j	51ec <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    51aa:	6398                	ld	a4,0(a5)
    51ac:	00e7e463          	bltu	a5,a4,51b4 <free+0x3a>
    51b0:	00e6ea63          	bltu	a3,a4,51c4 <free+0x4a>
{
    51b4:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    51b6:	fed7fae3          	bgeu	a5,a3,51aa <free+0x30>
    51ba:	6398                	ld	a4,0(a5)
    51bc:	00e6e463          	bltu	a3,a4,51c4 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    51c0:	fee7eae3          	bltu	a5,a4,51b4 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
    51c4:	ff852583          	lw	a1,-8(a0)
    51c8:	6390                	ld	a2,0(a5)
    51ca:	02059813          	sll	a6,a1,0x20
    51ce:	01c85713          	srl	a4,a6,0x1c
    51d2:	9736                	add	a4,a4,a3
    51d4:	fae60de3          	beq	a2,a4,518e <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
    51d8:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    51dc:	4790                	lw	a2,8(a5)
    51de:	02061593          	sll	a1,a2,0x20
    51e2:	01c5d713          	srl	a4,a1,0x1c
    51e6:	973e                	add	a4,a4,a5
    51e8:	fae68ae3          	beq	a3,a4,519c <free+0x22>
    p->s.ptr = bp->s.ptr;
    51ec:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    51ee:	00003717          	auipc	a4,0x3
    51f2:	2af73123          	sd	a5,674(a4) # 8490 <freep>
}
    51f6:	6422                	ld	s0,8(sp)
    51f8:	0141                	add	sp,sp,16
    51fa:	8082                	ret

00000000000051fc <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    51fc:	7139                	add	sp,sp,-64
    51fe:	fc06                	sd	ra,56(sp)
    5200:	f822                	sd	s0,48(sp)
    5202:	f426                	sd	s1,40(sp)
    5204:	f04a                	sd	s2,32(sp)
    5206:	ec4e                	sd	s3,24(sp)
    5208:	e852                	sd	s4,16(sp)
    520a:	e456                	sd	s5,8(sp)
    520c:	e05a                	sd	s6,0(sp)
    520e:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    5210:	02051493          	sll	s1,a0,0x20
    5214:	9081                	srl	s1,s1,0x20
    5216:	04bd                	add	s1,s1,15
    5218:	8091                	srl	s1,s1,0x4
    521a:	0014899b          	addw	s3,s1,1
    521e:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
    5220:	00003517          	auipc	a0,0x3
    5224:	27053503          	ld	a0,624(a0) # 8490 <freep>
    5228:	c515                	beqz	a0,5254 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    522a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    522c:	4798                	lw	a4,8(a5)
    522e:	02977f63          	bgeu	a4,s1,526c <malloc+0x70>
  if(nu < 4096)
    5232:	8a4e                	mv	s4,s3
    5234:	0009871b          	sext.w	a4,s3
    5238:	6685                	lui	a3,0x1
    523a:	00d77363          	bgeu	a4,a3,5240 <malloc+0x44>
    523e:	6a05                	lui	s4,0x1
    5240:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    5244:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    5248:	00003917          	auipc	s2,0x3
    524c:	24890913          	add	s2,s2,584 # 8490 <freep>
  if(p == SBRK_ERROR)
    5250:	5afd                	li	s5,-1
    5252:	a885                	j	52c2 <malloc+0xc6>
    base.s.ptr = freep = prevp = &base;
    5254:	0000a797          	auipc	a5,0xa
    5258:	a6478793          	add	a5,a5,-1436 # ecb8 <base>
    525c:	00003717          	auipc	a4,0x3
    5260:	22f73a23          	sd	a5,564(a4) # 8490 <freep>
    5264:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    5266:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    526a:	b7e1                	j	5232 <malloc+0x36>
      if(p->s.size == nunits)
    526c:	02e48c63          	beq	s1,a4,52a4 <malloc+0xa8>
        p->s.size -= nunits;
    5270:	4137073b          	subw	a4,a4,s3
    5274:	c798                	sw	a4,8(a5)
        p += p->s.size;
    5276:	02071693          	sll	a3,a4,0x20
    527a:	01c6d713          	srl	a4,a3,0x1c
    527e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    5280:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    5284:	00003717          	auipc	a4,0x3
    5288:	20a73623          	sd	a0,524(a4) # 8490 <freep>
      return (void*)(p + 1);
    528c:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    5290:	70e2                	ld	ra,56(sp)
    5292:	7442                	ld	s0,48(sp)
    5294:	74a2                	ld	s1,40(sp)
    5296:	7902                	ld	s2,32(sp)
    5298:	69e2                	ld	s3,24(sp)
    529a:	6a42                	ld	s4,16(sp)
    529c:	6aa2                	ld	s5,8(sp)
    529e:	6b02                	ld	s6,0(sp)
    52a0:	6121                	add	sp,sp,64
    52a2:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    52a4:	6398                	ld	a4,0(a5)
    52a6:	e118                	sd	a4,0(a0)
    52a8:	bff1                	j	5284 <malloc+0x88>
  hp->s.size = nu;
    52aa:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    52ae:	0541                	add	a0,a0,16
    52b0:	ecbff0ef          	jal	517a <free>
  return freep;
    52b4:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    52b8:	dd61                	beqz	a0,5290 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    52ba:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    52bc:	4798                	lw	a4,8(a5)
    52be:	fa9777e3          	bgeu	a4,s1,526c <malloc+0x70>
    if(p == freep)
    52c2:	00093703          	ld	a4,0(s2)
    52c6:	853e                	mv	a0,a5
    52c8:	fef719e3          	bne	a4,a5,52ba <malloc+0xbe>
  p = sbrk(nu * sizeof(Header));
    52cc:	8552                	mv	a0,s4
    52ce:	a05ff0ef          	jal	4cd2 <sbrk>
  if(p == SBRK_ERROR)
    52d2:	fd551ce3          	bne	a0,s5,52aa <malloc+0xae>
        return 0;
    52d6:	4501                	li	a0,0
    52d8:	bf65                	j	5290 <malloc+0x94>
