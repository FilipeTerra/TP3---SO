
user/_sh:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <getcmd>:
  exit(0);
}

int
getcmd(char *buf, int nbuf)
{
       0:	1101                	add	sp,sp,-32
       2:	ec06                	sd	ra,24(sp)
       4:	e822                	sd	s0,16(sp)
       6:	e426                	sd	s1,8(sp)
       8:	e04a                	sd	s2,0(sp)
       a:	1000                	add	s0,sp,32
       c:	84aa                	mv	s1,a0
       e:	892e                	mv	s2,a1
  write(2, "$ ", 2);
      10:	4609                	li	a2,2
      12:	00001597          	auipc	a1,0x1
      16:	1fe58593          	add	a1,a1,510 # 1210 <malloc+0xe6>
      1a:	4509                	li	a0,2
      1c:	439000ef          	jal	c54 <write>
  memset(buf, 0, nbuf);
      20:	864a                	mv	a2,s2
      22:	4581                	li	a1,0
      24:	8526                	mv	a0,s1
      26:	1fd000ef          	jal	a22 <memset>
  gets(buf, nbuf);
      2a:	85ca                	mv	a1,s2
      2c:	8526                	mv	a0,s1
      2e:	23b000ef          	jal	a68 <gets>
  if(buf[0] == 0) // EOF
      32:	0004c503          	lbu	a0,0(s1)
      36:	00153513          	seqz	a0,a0
    return -1;
  return 0;
}
      3a:	40a00533          	neg	a0,a0
      3e:	60e2                	ld	ra,24(sp)
      40:	6442                	ld	s0,16(sp)
      42:	64a2                	ld	s1,8(sp)
      44:	6902                	ld	s2,0(sp)
      46:	6105                	add	sp,sp,32
      48:	8082                	ret

000000000000004a <panic>:
  exit(0);
}

void
panic(char *s)
{
      4a:	1141                	add	sp,sp,-16
      4c:	e406                	sd	ra,8(sp)
      4e:	e022                	sd	s0,0(sp)
      50:	0800                	add	s0,sp,16
      52:	862a                	mv	a2,a0
  fprintf(2, "%s\n", s);
      54:	00001597          	auipc	a1,0x1
      58:	1c458593          	add	a1,a1,452 # 1218 <malloc+0xee>
      5c:	4509                	li	a0,2
      5e:	7ef000ef          	jal	104c <fprintf>
  exit(1);
      62:	4505                	li	a0,1
      64:	3d1000ef          	jal	c34 <exit>

0000000000000068 <fork1>:
}

int
fork1(void)
{
      68:	1141                	add	sp,sp,-16
      6a:	e406                	sd	ra,8(sp)
      6c:	e022                	sd	s0,0(sp)
      6e:	0800                	add	s0,sp,16
  int pid;

  pid = fork();
      70:	3bd000ef          	jal	c2c <fork>
  if(pid == -1)
      74:	57fd                	li	a5,-1
      76:	00f50663          	beq	a0,a5,82 <fork1+0x1a>
    panic("fork");
  return pid;
}
      7a:	60a2                	ld	ra,8(sp)
      7c:	6402                	ld	s0,0(sp)
      7e:	0141                	add	sp,sp,16
      80:	8082                	ret
    panic("fork");
      82:	00001517          	auipc	a0,0x1
      86:	19e50513          	add	a0,a0,414 # 1220 <malloc+0xf6>
      8a:	fc1ff0ef          	jal	4a <panic>

000000000000008e <runcmd>:
{
      8e:	7179                	add	sp,sp,-48
      90:	f406                	sd	ra,40(sp)
      92:	f022                	sd	s0,32(sp)
      94:	ec26                	sd	s1,24(sp)
      96:	1800                	add	s0,sp,48
  if(cmd == 0)
      98:	c10d                	beqz	a0,ba <runcmd+0x2c>
      9a:	84aa                	mv	s1,a0
  switch(cmd->type){
      9c:	4118                	lw	a4,0(a0)
      9e:	4795                	li	a5,5
      a0:	02e7e063          	bltu	a5,a4,c0 <runcmd+0x32>
      a4:	00056783          	lwu	a5,0(a0)
      a8:	078a                	sll	a5,a5,0x2
      aa:	00001717          	auipc	a4,0x1
      ae:	27670713          	add	a4,a4,630 # 1320 <malloc+0x1f6>
      b2:	97ba                	add	a5,a5,a4
      b4:	439c                	lw	a5,0(a5)
      b6:	97ba                	add	a5,a5,a4
      b8:	8782                	jr	a5
    exit(1);
      ba:	4505                	li	a0,1
      bc:	379000ef          	jal	c34 <exit>
    panic("runcmd");
      c0:	00001517          	auipc	a0,0x1
      c4:	16850513          	add	a0,a0,360 # 1228 <malloc+0xfe>
      c8:	f83ff0ef          	jal	4a <panic>
    if(ecmd->argv[0] == 0)
      cc:	6508                	ld	a0,8(a0)
      ce:	c105                	beqz	a0,ee <runcmd+0x60>
    exec(ecmd->argv[0], ecmd->argv);
      d0:	00848593          	add	a1,s1,8
      d4:	399000ef          	jal	c6c <exec>
    fprintf(2, "exec %s failed\n", ecmd->argv[0]);
      d8:	6490                	ld	a2,8(s1)
      da:	00001597          	auipc	a1,0x1
      de:	15658593          	add	a1,a1,342 # 1230 <malloc+0x106>
      e2:	4509                	li	a0,2
      e4:	769000ef          	jal	104c <fprintf>
  exit(0);
      e8:	4501                	li	a0,0
      ea:	34b000ef          	jal	c34 <exit>
      exit(1);
      ee:	4505                	li	a0,1
      f0:	345000ef          	jal	c34 <exit>
    close(rcmd->fd);
      f4:	5148                	lw	a0,36(a0)
      f6:	367000ef          	jal	c5c <close>
    if(open(rcmd->file, rcmd->mode) < 0){
      fa:	508c                	lw	a1,32(s1)
      fc:	6888                	ld	a0,16(s1)
      fe:	377000ef          	jal	c74 <open>
     102:	00054563          	bltz	a0,10c <runcmd+0x7e>
    runcmd(rcmd->cmd);
     106:	6488                	ld	a0,8(s1)
     108:	f87ff0ef          	jal	8e <runcmd>
      fprintf(2, "open %s failed\n", rcmd->file);
     10c:	6890                	ld	a2,16(s1)
     10e:	00001597          	auipc	a1,0x1
     112:	13258593          	add	a1,a1,306 # 1240 <malloc+0x116>
     116:	4509                	li	a0,2
     118:	735000ef          	jal	104c <fprintf>
      exit(1);
     11c:	4505                	li	a0,1
     11e:	317000ef          	jal	c34 <exit>
    if(fork1() == 0)
     122:	f47ff0ef          	jal	68 <fork1>
     126:	e501                	bnez	a0,12e <runcmd+0xa0>
      runcmd(lcmd->left);
     128:	6488                	ld	a0,8(s1)
     12a:	f65ff0ef          	jal	8e <runcmd>
    wait(0);
     12e:	4501                	li	a0,0
     130:	30d000ef          	jal	c3c <wait>
    runcmd(lcmd->right);
     134:	6888                	ld	a0,16(s1)
     136:	f59ff0ef          	jal	8e <runcmd>
    if(pipe(p) < 0)
     13a:	fd840513          	add	a0,s0,-40
     13e:	307000ef          	jal	c44 <pipe>
     142:	02054763          	bltz	a0,170 <runcmd+0xe2>
    if(fork1() == 0){
     146:	f23ff0ef          	jal	68 <fork1>
     14a:	e90d                	bnez	a0,17c <runcmd+0xee>
      close(1);
     14c:	4505                	li	a0,1
     14e:	30f000ef          	jal	c5c <close>
      dup(p[1]);
     152:	fdc42503          	lw	a0,-36(s0)
     156:	357000ef          	jal	cac <dup>
      close(p[0]);
     15a:	fd842503          	lw	a0,-40(s0)
     15e:	2ff000ef          	jal	c5c <close>
      close(p[1]);
     162:	fdc42503          	lw	a0,-36(s0)
     166:	2f7000ef          	jal	c5c <close>
      runcmd(pcmd->left);
     16a:	6488                	ld	a0,8(s1)
     16c:	f23ff0ef          	jal	8e <runcmd>
      panic("pipe");
     170:	00001517          	auipc	a0,0x1
     174:	0e050513          	add	a0,a0,224 # 1250 <malloc+0x126>
     178:	ed3ff0ef          	jal	4a <panic>
    if(fork1() == 0){
     17c:	eedff0ef          	jal	68 <fork1>
     180:	e115                	bnez	a0,1a4 <runcmd+0x116>
      close(0);
     182:	2db000ef          	jal	c5c <close>
      dup(p[0]);
     186:	fd842503          	lw	a0,-40(s0)
     18a:	323000ef          	jal	cac <dup>
      close(p[0]);
     18e:	fd842503          	lw	a0,-40(s0)
     192:	2cb000ef          	jal	c5c <close>
      close(p[1]);
     196:	fdc42503          	lw	a0,-36(s0)
     19a:	2c3000ef          	jal	c5c <close>
      runcmd(pcmd->right);
     19e:	6888                	ld	a0,16(s1)
     1a0:	eefff0ef          	jal	8e <runcmd>
    close(p[0]);
     1a4:	fd842503          	lw	a0,-40(s0)
     1a8:	2b5000ef          	jal	c5c <close>
    close(p[1]);
     1ac:	fdc42503          	lw	a0,-36(s0)
     1b0:	2ad000ef          	jal	c5c <close>
    wait(0);
     1b4:	4501                	li	a0,0
     1b6:	287000ef          	jal	c3c <wait>
    wait(0);
     1ba:	4501                	li	a0,0
     1bc:	281000ef          	jal	c3c <wait>
    break;
     1c0:	b725                	j	e8 <runcmd+0x5a>
    if(fork1() == 0)
     1c2:	ea7ff0ef          	jal	68 <fork1>
     1c6:	f20511e3          	bnez	a0,e8 <runcmd+0x5a>
      runcmd(bcmd->cmd);
     1ca:	6488                	ld	a0,8(s1)
     1cc:	ec3ff0ef          	jal	8e <runcmd>

00000000000001d0 <execcmd>:
//PAGEBREAK!
// Constructors

struct cmd*
execcmd(void)
{
     1d0:	1101                	add	sp,sp,-32
     1d2:	ec06                	sd	ra,24(sp)
     1d4:	e822                	sd	s0,16(sp)
     1d6:	e426                	sd	s1,8(sp)
     1d8:	1000                	add	s0,sp,32
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     1da:	0a800513          	li	a0,168
     1de:	74d000ef          	jal	112a <malloc>
     1e2:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     1e4:	0a800613          	li	a2,168
     1e8:	4581                	li	a1,0
     1ea:	039000ef          	jal	a22 <memset>
  cmd->type = EXEC;
     1ee:	4785                	li	a5,1
     1f0:	c09c                	sw	a5,0(s1)
  return (struct cmd*)cmd;
}
     1f2:	8526                	mv	a0,s1
     1f4:	60e2                	ld	ra,24(sp)
     1f6:	6442                	ld	s0,16(sp)
     1f8:	64a2                	ld	s1,8(sp)
     1fa:	6105                	add	sp,sp,32
     1fc:	8082                	ret

00000000000001fe <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     1fe:	7139                	add	sp,sp,-64
     200:	fc06                	sd	ra,56(sp)
     202:	f822                	sd	s0,48(sp)
     204:	f426                	sd	s1,40(sp)
     206:	f04a                	sd	s2,32(sp)
     208:	ec4e                	sd	s3,24(sp)
     20a:	e852                	sd	s4,16(sp)
     20c:	e456                	sd	s5,8(sp)
     20e:	e05a                	sd	s6,0(sp)
     210:	0080                	add	s0,sp,64
     212:	8b2a                	mv	s6,a0
     214:	8aae                	mv	s5,a1
     216:	8a32                	mv	s4,a2
     218:	89b6                	mv	s3,a3
     21a:	893a                	mv	s2,a4
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     21c:	02800513          	li	a0,40
     220:	70b000ef          	jal	112a <malloc>
     224:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     226:	02800613          	li	a2,40
     22a:	4581                	li	a1,0
     22c:	7f6000ef          	jal	a22 <memset>
  cmd->type = REDIR;
     230:	4789                	li	a5,2
     232:	c09c                	sw	a5,0(s1)
  cmd->cmd = subcmd;
     234:	0164b423          	sd	s6,8(s1)
  cmd->file = file;
     238:	0154b823          	sd	s5,16(s1)
  cmd->efile = efile;
     23c:	0144bc23          	sd	s4,24(s1)
  cmd->mode = mode;
     240:	0334a023          	sw	s3,32(s1)
  cmd->fd = fd;
     244:	0324a223          	sw	s2,36(s1)
  return (struct cmd*)cmd;
}
     248:	8526                	mv	a0,s1
     24a:	70e2                	ld	ra,56(sp)
     24c:	7442                	ld	s0,48(sp)
     24e:	74a2                	ld	s1,40(sp)
     250:	7902                	ld	s2,32(sp)
     252:	69e2                	ld	s3,24(sp)
     254:	6a42                	ld	s4,16(sp)
     256:	6aa2                	ld	s5,8(sp)
     258:	6b02                	ld	s6,0(sp)
     25a:	6121                	add	sp,sp,64
     25c:	8082                	ret

000000000000025e <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
     25e:	7179                	add	sp,sp,-48
     260:	f406                	sd	ra,40(sp)
     262:	f022                	sd	s0,32(sp)
     264:	ec26                	sd	s1,24(sp)
     266:	e84a                	sd	s2,16(sp)
     268:	e44e                	sd	s3,8(sp)
     26a:	1800                	add	s0,sp,48
     26c:	89aa                	mv	s3,a0
     26e:	892e                	mv	s2,a1
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     270:	4561                	li	a0,24
     272:	6b9000ef          	jal	112a <malloc>
     276:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     278:	4661                	li	a2,24
     27a:	4581                	li	a1,0
     27c:	7a6000ef          	jal	a22 <memset>
  cmd->type = PIPE;
     280:	478d                	li	a5,3
     282:	c09c                	sw	a5,0(s1)
  cmd->left = left;
     284:	0134b423          	sd	s3,8(s1)
  cmd->right = right;
     288:	0124b823          	sd	s2,16(s1)
  return (struct cmd*)cmd;
}
     28c:	8526                	mv	a0,s1
     28e:	70a2                	ld	ra,40(sp)
     290:	7402                	ld	s0,32(sp)
     292:	64e2                	ld	s1,24(sp)
     294:	6942                	ld	s2,16(sp)
     296:	69a2                	ld	s3,8(sp)
     298:	6145                	add	sp,sp,48
     29a:	8082                	ret

000000000000029c <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
     29c:	7179                	add	sp,sp,-48
     29e:	f406                	sd	ra,40(sp)
     2a0:	f022                	sd	s0,32(sp)
     2a2:	ec26                	sd	s1,24(sp)
     2a4:	e84a                	sd	s2,16(sp)
     2a6:	e44e                	sd	s3,8(sp)
     2a8:	1800                	add	s0,sp,48
     2aa:	89aa                	mv	s3,a0
     2ac:	892e                	mv	s2,a1
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     2ae:	4561                	li	a0,24
     2b0:	67b000ef          	jal	112a <malloc>
     2b4:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     2b6:	4661                	li	a2,24
     2b8:	4581                	li	a1,0
     2ba:	768000ef          	jal	a22 <memset>
  cmd->type = LIST;
     2be:	4791                	li	a5,4
     2c0:	c09c                	sw	a5,0(s1)
  cmd->left = left;
     2c2:	0134b423          	sd	s3,8(s1)
  cmd->right = right;
     2c6:	0124b823          	sd	s2,16(s1)
  return (struct cmd*)cmd;
}
     2ca:	8526                	mv	a0,s1
     2cc:	70a2                	ld	ra,40(sp)
     2ce:	7402                	ld	s0,32(sp)
     2d0:	64e2                	ld	s1,24(sp)
     2d2:	6942                	ld	s2,16(sp)
     2d4:	69a2                	ld	s3,8(sp)
     2d6:	6145                	add	sp,sp,48
     2d8:	8082                	ret

00000000000002da <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
     2da:	1101                	add	sp,sp,-32
     2dc:	ec06                	sd	ra,24(sp)
     2de:	e822                	sd	s0,16(sp)
     2e0:	e426                	sd	s1,8(sp)
     2e2:	e04a                	sd	s2,0(sp)
     2e4:	1000                	add	s0,sp,32
     2e6:	892a                	mv	s2,a0
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     2e8:	4541                	li	a0,16
     2ea:	641000ef          	jal	112a <malloc>
     2ee:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     2f0:	4641                	li	a2,16
     2f2:	4581                	li	a1,0
     2f4:	72e000ef          	jal	a22 <memset>
  cmd->type = BACK;
     2f8:	4795                	li	a5,5
     2fa:	c09c                	sw	a5,0(s1)
  cmd->cmd = subcmd;
     2fc:	0124b423          	sd	s2,8(s1)
  return (struct cmd*)cmd;
}
     300:	8526                	mv	a0,s1
     302:	60e2                	ld	ra,24(sp)
     304:	6442                	ld	s0,16(sp)
     306:	64a2                	ld	s1,8(sp)
     308:	6902                	ld	s2,0(sp)
     30a:	6105                	add	sp,sp,32
     30c:	8082                	ret

000000000000030e <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
     30e:	7139                	add	sp,sp,-64
     310:	fc06                	sd	ra,56(sp)
     312:	f822                	sd	s0,48(sp)
     314:	f426                	sd	s1,40(sp)
     316:	f04a                	sd	s2,32(sp)
     318:	ec4e                	sd	s3,24(sp)
     31a:	e852                	sd	s4,16(sp)
     31c:	e456                	sd	s5,8(sp)
     31e:	e05a                	sd	s6,0(sp)
     320:	0080                	add	s0,sp,64
     322:	8a2a                	mv	s4,a0
     324:	892e                	mv	s2,a1
     326:	8ab2                	mv	s5,a2
     328:	8b36                	mv	s6,a3
  char *s;
  int ret;

  s = *ps;
     32a:	6104                	ld	s1,0(a0)
  while(s < es && strchr(whitespace, *s))
     32c:	00002997          	auipc	s3,0x2
     330:	cdc98993          	add	s3,s3,-804 # 2008 <whitespace>
     334:	00b4fc63          	bgeu	s1,a1,34c <gettoken+0x3e>
     338:	0004c583          	lbu	a1,0(s1)
     33c:	854e                	mv	a0,s3
     33e:	706000ef          	jal	a44 <strchr>
     342:	c509                	beqz	a0,34c <gettoken+0x3e>
    s++;
     344:	0485                	add	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     346:	fe9919e3          	bne	s2,s1,338 <gettoken+0x2a>
    s++;
     34a:	84ca                	mv	s1,s2
  if(q)
     34c:	000a8463          	beqz	s5,354 <gettoken+0x46>
    *q = s;
     350:	009ab023          	sd	s1,0(s5)
  ret = *s;
     354:	0004c783          	lbu	a5,0(s1)
     358:	00078a9b          	sext.w	s5,a5
  switch(*s){
     35c:	03c00713          	li	a4,60
     360:	06f76463          	bltu	a4,a5,3c8 <gettoken+0xba>
     364:	03a00713          	li	a4,58
     368:	00f76e63          	bltu	a4,a5,384 <gettoken+0x76>
     36c:	cf89                	beqz	a5,386 <gettoken+0x78>
     36e:	02600713          	li	a4,38
     372:	00e78963          	beq	a5,a4,384 <gettoken+0x76>
     376:	fd87879b          	addw	a5,a5,-40
     37a:	0ff7f793          	zext.b	a5,a5
     37e:	4705                	li	a4,1
     380:	06f76b63          	bltu	a4,a5,3f6 <gettoken+0xe8>
  case '(':
  case ')':
  case ';':
  case '&':
  case '<':
    s++;
     384:	0485                	add	s1,s1,1
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if(eq)
     386:	000b0463          	beqz	s6,38e <gettoken+0x80>
    *eq = s;
     38a:	009b3023          	sd	s1,0(s6)

  while(s < es && strchr(whitespace, *s))
     38e:	00002997          	auipc	s3,0x2
     392:	c7a98993          	add	s3,s3,-902 # 2008 <whitespace>
     396:	0124fc63          	bgeu	s1,s2,3ae <gettoken+0xa0>
     39a:	0004c583          	lbu	a1,0(s1)
     39e:	854e                	mv	a0,s3
     3a0:	6a4000ef          	jal	a44 <strchr>
     3a4:	c509                	beqz	a0,3ae <gettoken+0xa0>
    s++;
     3a6:	0485                	add	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     3a8:	fe9919e3          	bne	s2,s1,39a <gettoken+0x8c>
    s++;
     3ac:	84ca                	mv	s1,s2
  *ps = s;
     3ae:	009a3023          	sd	s1,0(s4)
  return ret;
}
     3b2:	8556                	mv	a0,s5
     3b4:	70e2                	ld	ra,56(sp)
     3b6:	7442                	ld	s0,48(sp)
     3b8:	74a2                	ld	s1,40(sp)
     3ba:	7902                	ld	s2,32(sp)
     3bc:	69e2                	ld	s3,24(sp)
     3be:	6a42                	ld	s4,16(sp)
     3c0:	6aa2                	ld	s5,8(sp)
     3c2:	6b02                	ld	s6,0(sp)
     3c4:	6121                	add	sp,sp,64
     3c6:	8082                	ret
  switch(*s){
     3c8:	03e00713          	li	a4,62
     3cc:	02e79163          	bne	a5,a4,3ee <gettoken+0xe0>
    s++;
     3d0:	00148693          	add	a3,s1,1
    if(*s == '>'){
     3d4:	0014c703          	lbu	a4,1(s1)
     3d8:	03e00793          	li	a5,62
      s++;
     3dc:	0489                	add	s1,s1,2
      ret = '+';
     3de:	02b00a93          	li	s5,43
    if(*s == '>'){
     3e2:	faf702e3          	beq	a4,a5,386 <gettoken+0x78>
    s++;
     3e6:	84b6                	mv	s1,a3
  ret = *s;
     3e8:	03e00a93          	li	s5,62
     3ec:	bf69                	j	386 <gettoken+0x78>
  switch(*s){
     3ee:	07c00713          	li	a4,124
     3f2:	f8e789e3          	beq	a5,a4,384 <gettoken+0x76>
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     3f6:	00002997          	auipc	s3,0x2
     3fa:	c1298993          	add	s3,s3,-1006 # 2008 <whitespace>
     3fe:	00002a97          	auipc	s5,0x2
     402:	c02a8a93          	add	s5,s5,-1022 # 2000 <symbols>
     406:	0324fd63          	bgeu	s1,s2,440 <gettoken+0x132>
     40a:	0004c583          	lbu	a1,0(s1)
     40e:	854e                	mv	a0,s3
     410:	634000ef          	jal	a44 <strchr>
     414:	e11d                	bnez	a0,43a <gettoken+0x12c>
     416:	0004c583          	lbu	a1,0(s1)
     41a:	8556                	mv	a0,s5
     41c:	628000ef          	jal	a44 <strchr>
     420:	e911                	bnez	a0,434 <gettoken+0x126>
      s++;
     422:	0485                	add	s1,s1,1
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     424:	fe9913e3          	bne	s2,s1,40a <gettoken+0xfc>
      s++;
     428:	84ca                	mv	s1,s2
    ret = 'a';
     42a:	06100a93          	li	s5,97
  if(eq)
     42e:	f40b1ee3          	bnez	s6,38a <gettoken+0x7c>
     432:	bfb5                	j	3ae <gettoken+0xa0>
    ret = 'a';
     434:	06100a93          	li	s5,97
     438:	b7b9                	j	386 <gettoken+0x78>
     43a:	06100a93          	li	s5,97
     43e:	b7a1                	j	386 <gettoken+0x78>
     440:	06100a93          	li	s5,97
  if(eq)
     444:	f40b13e3          	bnez	s6,38a <gettoken+0x7c>
     448:	b79d                	j	3ae <gettoken+0xa0>

000000000000044a <peek>:

int
peek(char **ps, char *es, char *toks)
{
     44a:	7139                	add	sp,sp,-64
     44c:	fc06                	sd	ra,56(sp)
     44e:	f822                	sd	s0,48(sp)
     450:	f426                	sd	s1,40(sp)
     452:	f04a                	sd	s2,32(sp)
     454:	ec4e                	sd	s3,24(sp)
     456:	e852                	sd	s4,16(sp)
     458:	e456                	sd	s5,8(sp)
     45a:	0080                	add	s0,sp,64
     45c:	8a2a                	mv	s4,a0
     45e:	892e                	mv	s2,a1
     460:	8ab2                	mv	s5,a2
  char *s;

  s = *ps;
     462:	6104                	ld	s1,0(a0)
  while(s < es && strchr(whitespace, *s))
     464:	00002997          	auipc	s3,0x2
     468:	ba498993          	add	s3,s3,-1116 # 2008 <whitespace>
     46c:	00b4fc63          	bgeu	s1,a1,484 <peek+0x3a>
     470:	0004c583          	lbu	a1,0(s1)
     474:	854e                	mv	a0,s3
     476:	5ce000ef          	jal	a44 <strchr>
     47a:	c509                	beqz	a0,484 <peek+0x3a>
    s++;
     47c:	0485                	add	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     47e:	fe9919e3          	bne	s2,s1,470 <peek+0x26>
    s++;
     482:	84ca                	mv	s1,s2
  *ps = s;
     484:	009a3023          	sd	s1,0(s4)
  return *s && strchr(toks, *s);
     488:	0004c583          	lbu	a1,0(s1)
     48c:	4501                	li	a0,0
     48e:	e991                	bnez	a1,4a2 <peek+0x58>
}
     490:	70e2                	ld	ra,56(sp)
     492:	7442                	ld	s0,48(sp)
     494:	74a2                	ld	s1,40(sp)
     496:	7902                	ld	s2,32(sp)
     498:	69e2                	ld	s3,24(sp)
     49a:	6a42                	ld	s4,16(sp)
     49c:	6aa2                	ld	s5,8(sp)
     49e:	6121                	add	sp,sp,64
     4a0:	8082                	ret
  return *s && strchr(toks, *s);
     4a2:	8556                	mv	a0,s5
     4a4:	5a0000ef          	jal	a44 <strchr>
     4a8:	00a03533          	snez	a0,a0
     4ac:	b7d5                	j	490 <peek+0x46>

00000000000004ae <parseredirs>:
  return cmd;
}

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     4ae:	7159                	add	sp,sp,-112
     4b0:	f486                	sd	ra,104(sp)
     4b2:	f0a2                	sd	s0,96(sp)
     4b4:	eca6                	sd	s1,88(sp)
     4b6:	e8ca                	sd	s2,80(sp)
     4b8:	e4ce                	sd	s3,72(sp)
     4ba:	e0d2                	sd	s4,64(sp)
     4bc:	fc56                	sd	s5,56(sp)
     4be:	f85a                	sd	s6,48(sp)
     4c0:	f45e                	sd	s7,40(sp)
     4c2:	f062                	sd	s8,32(sp)
     4c4:	ec66                	sd	s9,24(sp)
     4c6:	1880                	add	s0,sp,112
     4c8:	8a2a                	mv	s4,a0
     4ca:	89ae                	mv	s3,a1
     4cc:	8932                	mv	s2,a2
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     4ce:	00001b97          	auipc	s7,0x1
     4d2:	daab8b93          	add	s7,s7,-598 # 1278 <malloc+0x14e>
    tok = gettoken(ps, es, 0, 0);
    if(gettoken(ps, es, &q, &eq) != 'a')
     4d6:	06100c13          	li	s8,97
      panic("missing file for redirection");
    switch(tok){
     4da:	03c00c93          	li	s9,60
  while(peek(ps, es, "<>")){
     4de:	a00d                	j	500 <parseredirs+0x52>
      panic("missing file for redirection");
     4e0:	00001517          	auipc	a0,0x1
     4e4:	d7850513          	add	a0,a0,-648 # 1258 <malloc+0x12e>
     4e8:	b63ff0ef          	jal	4a <panic>
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     4ec:	4701                	li	a4,0
     4ee:	4681                	li	a3,0
     4f0:	f9043603          	ld	a2,-112(s0)
     4f4:	f9843583          	ld	a1,-104(s0)
     4f8:	8552                	mv	a0,s4
     4fa:	d05ff0ef          	jal	1fe <redircmd>
     4fe:	8a2a                	mv	s4,a0
    switch(tok){
     500:	03e00b13          	li	s6,62
     504:	02b00a93          	li	s5,43
  while(peek(ps, es, "<>")){
     508:	865e                	mv	a2,s7
     50a:	85ca                	mv	a1,s2
     50c:	854e                	mv	a0,s3
     50e:	f3dff0ef          	jal	44a <peek>
     512:	c125                	beqz	a0,572 <parseredirs+0xc4>
    tok = gettoken(ps, es, 0, 0);
     514:	4681                	li	a3,0
     516:	4601                	li	a2,0
     518:	85ca                	mv	a1,s2
     51a:	854e                	mv	a0,s3
     51c:	df3ff0ef          	jal	30e <gettoken>
     520:	84aa                	mv	s1,a0
    if(gettoken(ps, es, &q, &eq) != 'a')
     522:	f9040693          	add	a3,s0,-112
     526:	f9840613          	add	a2,s0,-104
     52a:	85ca                	mv	a1,s2
     52c:	854e                	mv	a0,s3
     52e:	de1ff0ef          	jal	30e <gettoken>
     532:	fb8517e3          	bne	a0,s8,4e0 <parseredirs+0x32>
    switch(tok){
     536:	fb948be3          	beq	s1,s9,4ec <parseredirs+0x3e>
     53a:	03648063          	beq	s1,s6,55a <parseredirs+0xac>
     53e:	fd5495e3          	bne	s1,s5,508 <parseredirs+0x5a>
      break;
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE|O_TRUNC, 1);
      break;
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     542:	4705                	li	a4,1
     544:	20100693          	li	a3,513
     548:	f9043603          	ld	a2,-112(s0)
     54c:	f9843583          	ld	a1,-104(s0)
     550:	8552                	mv	a0,s4
     552:	cadff0ef          	jal	1fe <redircmd>
     556:	8a2a                	mv	s4,a0
      break;
     558:	b765                	j	500 <parseredirs+0x52>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE|O_TRUNC, 1);
     55a:	4705                	li	a4,1
     55c:	60100693          	li	a3,1537
     560:	f9043603          	ld	a2,-112(s0)
     564:	f9843583          	ld	a1,-104(s0)
     568:	8552                	mv	a0,s4
     56a:	c95ff0ef          	jal	1fe <redircmd>
     56e:	8a2a                	mv	s4,a0
      break;
     570:	bf41                	j	500 <parseredirs+0x52>
    }
  }
  return cmd;
}
     572:	8552                	mv	a0,s4
     574:	70a6                	ld	ra,104(sp)
     576:	7406                	ld	s0,96(sp)
     578:	64e6                	ld	s1,88(sp)
     57a:	6946                	ld	s2,80(sp)
     57c:	69a6                	ld	s3,72(sp)
     57e:	6a06                	ld	s4,64(sp)
     580:	7ae2                	ld	s5,56(sp)
     582:	7b42                	ld	s6,48(sp)
     584:	7ba2                	ld	s7,40(sp)
     586:	7c02                	ld	s8,32(sp)
     588:	6ce2                	ld	s9,24(sp)
     58a:	6165                	add	sp,sp,112
     58c:	8082                	ret

000000000000058e <parseexec>:
  return cmd;
}

struct cmd*
parseexec(char **ps, char *es)
{
     58e:	7159                	add	sp,sp,-112
     590:	f486                	sd	ra,104(sp)
     592:	f0a2                	sd	s0,96(sp)
     594:	eca6                	sd	s1,88(sp)
     596:	e8ca                	sd	s2,80(sp)
     598:	e4ce                	sd	s3,72(sp)
     59a:	e0d2                	sd	s4,64(sp)
     59c:	fc56                	sd	s5,56(sp)
     59e:	f85a                	sd	s6,48(sp)
     5a0:	f45e                	sd	s7,40(sp)
     5a2:	f062                	sd	s8,32(sp)
     5a4:	ec66                	sd	s9,24(sp)
     5a6:	1880                	add	s0,sp,112
     5a8:	8a2a                	mv	s4,a0
     5aa:	8aae                	mv	s5,a1
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;

  if(peek(ps, es, "("))
     5ac:	00001617          	auipc	a2,0x1
     5b0:	cd460613          	add	a2,a2,-812 # 1280 <malloc+0x156>
     5b4:	e97ff0ef          	jal	44a <peek>
     5b8:	e505                	bnez	a0,5e0 <parseexec+0x52>
     5ba:	89aa                	mv	s3,a0
    return parseblock(ps, es);

  ret = execcmd();
     5bc:	c15ff0ef          	jal	1d0 <execcmd>
     5c0:	8c2a                	mv	s8,a0
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
     5c2:	8656                	mv	a2,s5
     5c4:	85d2                	mv	a1,s4
     5c6:	ee9ff0ef          	jal	4ae <parseredirs>
     5ca:	84aa                	mv	s1,a0
  while(!peek(ps, es, "|)&;")){
     5cc:	008c0913          	add	s2,s8,8
     5d0:	00001b17          	auipc	s6,0x1
     5d4:	cd0b0b13          	add	s6,s6,-816 # 12a0 <malloc+0x176>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
      break;
    if(tok != 'a')
     5d8:	06100c93          	li	s9,97
      panic("syntax");
    cmd->argv[argc] = q;
    cmd->eargv[argc] = eq;
    argc++;
    if(argc >= MAXARGS)
     5dc:	4ba9                	li	s7,10
  while(!peek(ps, es, "|)&;")){
     5de:	a081                	j	61e <parseexec+0x90>
    return parseblock(ps, es);
     5e0:	85d6                	mv	a1,s5
     5e2:	8552                	mv	a0,s4
     5e4:	170000ef          	jal	754 <parseblock>
     5e8:	84aa                	mv	s1,a0
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
  cmd->eargv[argc] = 0;
  return ret;
}
     5ea:	8526                	mv	a0,s1
     5ec:	70a6                	ld	ra,104(sp)
     5ee:	7406                	ld	s0,96(sp)
     5f0:	64e6                	ld	s1,88(sp)
     5f2:	6946                	ld	s2,80(sp)
     5f4:	69a6                	ld	s3,72(sp)
     5f6:	6a06                	ld	s4,64(sp)
     5f8:	7ae2                	ld	s5,56(sp)
     5fa:	7b42                	ld	s6,48(sp)
     5fc:	7ba2                	ld	s7,40(sp)
     5fe:	7c02                	ld	s8,32(sp)
     600:	6ce2                	ld	s9,24(sp)
     602:	6165                	add	sp,sp,112
     604:	8082                	ret
      panic("syntax");
     606:	00001517          	auipc	a0,0x1
     60a:	c8250513          	add	a0,a0,-894 # 1288 <malloc+0x15e>
     60e:	a3dff0ef          	jal	4a <panic>
    ret = parseredirs(ret, ps, es);
     612:	8656                	mv	a2,s5
     614:	85d2                	mv	a1,s4
     616:	8526                	mv	a0,s1
     618:	e97ff0ef          	jal	4ae <parseredirs>
     61c:	84aa                	mv	s1,a0
  while(!peek(ps, es, "|)&;")){
     61e:	865a                	mv	a2,s6
     620:	85d6                	mv	a1,s5
     622:	8552                	mv	a0,s4
     624:	e27ff0ef          	jal	44a <peek>
     628:	ed15                	bnez	a0,664 <parseexec+0xd6>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
     62a:	f9040693          	add	a3,s0,-112
     62e:	f9840613          	add	a2,s0,-104
     632:	85d6                	mv	a1,s5
     634:	8552                	mv	a0,s4
     636:	cd9ff0ef          	jal	30e <gettoken>
     63a:	c50d                	beqz	a0,664 <parseexec+0xd6>
    if(tok != 'a')
     63c:	fd9515e3          	bne	a0,s9,606 <parseexec+0x78>
    cmd->argv[argc] = q;
     640:	f9843783          	ld	a5,-104(s0)
     644:	00f93023          	sd	a5,0(s2)
    cmd->eargv[argc] = eq;
     648:	f9043783          	ld	a5,-112(s0)
     64c:	04f93823          	sd	a5,80(s2)
    argc++;
     650:	2985                	addw	s3,s3,1
    if(argc >= MAXARGS)
     652:	0921                	add	s2,s2,8
     654:	fb799fe3          	bne	s3,s7,612 <parseexec+0x84>
      panic("too many args");
     658:	00001517          	auipc	a0,0x1
     65c:	c3850513          	add	a0,a0,-968 # 1290 <malloc+0x166>
     660:	9ebff0ef          	jal	4a <panic>
  cmd->argv[argc] = 0;
     664:	098e                	sll	s3,s3,0x3
     666:	9c4e                	add	s8,s8,s3
     668:	000c3423          	sd	zero,8(s8)
  cmd->eargv[argc] = 0;
     66c:	040c3c23          	sd	zero,88(s8)
  return ret;
     670:	bfad                	j	5ea <parseexec+0x5c>

0000000000000672 <parsepipe>:
{
     672:	7179                	add	sp,sp,-48
     674:	f406                	sd	ra,40(sp)
     676:	f022                	sd	s0,32(sp)
     678:	ec26                	sd	s1,24(sp)
     67a:	e84a                	sd	s2,16(sp)
     67c:	e44e                	sd	s3,8(sp)
     67e:	1800                	add	s0,sp,48
     680:	892a                	mv	s2,a0
     682:	89ae                	mv	s3,a1
  cmd = parseexec(ps, es);
     684:	f0bff0ef          	jal	58e <parseexec>
     688:	84aa                	mv	s1,a0
  if(peek(ps, es, "|")){
     68a:	00001617          	auipc	a2,0x1
     68e:	c1e60613          	add	a2,a2,-994 # 12a8 <malloc+0x17e>
     692:	85ce                	mv	a1,s3
     694:	854a                	mv	a0,s2
     696:	db5ff0ef          	jal	44a <peek>
     69a:	e909                	bnez	a0,6ac <parsepipe+0x3a>
}
     69c:	8526                	mv	a0,s1
     69e:	70a2                	ld	ra,40(sp)
     6a0:	7402                	ld	s0,32(sp)
     6a2:	64e2                	ld	s1,24(sp)
     6a4:	6942                	ld	s2,16(sp)
     6a6:	69a2                	ld	s3,8(sp)
     6a8:	6145                	add	sp,sp,48
     6aa:	8082                	ret
    gettoken(ps, es, 0, 0);
     6ac:	4681                	li	a3,0
     6ae:	4601                	li	a2,0
     6b0:	85ce                	mv	a1,s3
     6b2:	854a                	mv	a0,s2
     6b4:	c5bff0ef          	jal	30e <gettoken>
    cmd = pipecmd(cmd, parsepipe(ps, es));
     6b8:	85ce                	mv	a1,s3
     6ba:	854a                	mv	a0,s2
     6bc:	fb7ff0ef          	jal	672 <parsepipe>
     6c0:	85aa                	mv	a1,a0
     6c2:	8526                	mv	a0,s1
     6c4:	b9bff0ef          	jal	25e <pipecmd>
     6c8:	84aa                	mv	s1,a0
  return cmd;
     6ca:	bfc9                	j	69c <parsepipe+0x2a>

00000000000006cc <parseline>:
{
     6cc:	7179                	add	sp,sp,-48
     6ce:	f406                	sd	ra,40(sp)
     6d0:	f022                	sd	s0,32(sp)
     6d2:	ec26                	sd	s1,24(sp)
     6d4:	e84a                	sd	s2,16(sp)
     6d6:	e44e                	sd	s3,8(sp)
     6d8:	e052                	sd	s4,0(sp)
     6da:	1800                	add	s0,sp,48
     6dc:	892a                	mv	s2,a0
     6de:	89ae                	mv	s3,a1
  cmd = parsepipe(ps, es);
     6e0:	f93ff0ef          	jal	672 <parsepipe>
     6e4:	84aa                	mv	s1,a0
  while(peek(ps, es, "&")){
     6e6:	00001a17          	auipc	s4,0x1
     6ea:	bcaa0a13          	add	s4,s4,-1078 # 12b0 <malloc+0x186>
     6ee:	a819                	j	704 <parseline+0x38>
    gettoken(ps, es, 0, 0);
     6f0:	4681                	li	a3,0
     6f2:	4601                	li	a2,0
     6f4:	85ce                	mv	a1,s3
     6f6:	854a                	mv	a0,s2
     6f8:	c17ff0ef          	jal	30e <gettoken>
    cmd = backcmd(cmd);
     6fc:	8526                	mv	a0,s1
     6fe:	bddff0ef          	jal	2da <backcmd>
     702:	84aa                	mv	s1,a0
  while(peek(ps, es, "&")){
     704:	8652                	mv	a2,s4
     706:	85ce                	mv	a1,s3
     708:	854a                	mv	a0,s2
     70a:	d41ff0ef          	jal	44a <peek>
     70e:	f16d                	bnez	a0,6f0 <parseline+0x24>
  if(peek(ps, es, ";")){
     710:	00001617          	auipc	a2,0x1
     714:	ba860613          	add	a2,a2,-1112 # 12b8 <malloc+0x18e>
     718:	85ce                	mv	a1,s3
     71a:	854a                	mv	a0,s2
     71c:	d2fff0ef          	jal	44a <peek>
     720:	e911                	bnez	a0,734 <parseline+0x68>
}
     722:	8526                	mv	a0,s1
     724:	70a2                	ld	ra,40(sp)
     726:	7402                	ld	s0,32(sp)
     728:	64e2                	ld	s1,24(sp)
     72a:	6942                	ld	s2,16(sp)
     72c:	69a2                	ld	s3,8(sp)
     72e:	6a02                	ld	s4,0(sp)
     730:	6145                	add	sp,sp,48
     732:	8082                	ret
    gettoken(ps, es, 0, 0);
     734:	4681                	li	a3,0
     736:	4601                	li	a2,0
     738:	85ce                	mv	a1,s3
     73a:	854a                	mv	a0,s2
     73c:	bd3ff0ef          	jal	30e <gettoken>
    cmd = listcmd(cmd, parseline(ps, es));
     740:	85ce                	mv	a1,s3
     742:	854a                	mv	a0,s2
     744:	f89ff0ef          	jal	6cc <parseline>
     748:	85aa                	mv	a1,a0
     74a:	8526                	mv	a0,s1
     74c:	b51ff0ef          	jal	29c <listcmd>
     750:	84aa                	mv	s1,a0
  return cmd;
     752:	bfc1                	j	722 <parseline+0x56>

0000000000000754 <parseblock>:
{
     754:	7179                	add	sp,sp,-48
     756:	f406                	sd	ra,40(sp)
     758:	f022                	sd	s0,32(sp)
     75a:	ec26                	sd	s1,24(sp)
     75c:	e84a                	sd	s2,16(sp)
     75e:	e44e                	sd	s3,8(sp)
     760:	1800                	add	s0,sp,48
     762:	84aa                	mv	s1,a0
     764:	892e                	mv	s2,a1
  if(!peek(ps, es, "("))
     766:	00001617          	auipc	a2,0x1
     76a:	b1a60613          	add	a2,a2,-1254 # 1280 <malloc+0x156>
     76e:	cddff0ef          	jal	44a <peek>
     772:	c539                	beqz	a0,7c0 <parseblock+0x6c>
  gettoken(ps, es, 0, 0);
     774:	4681                	li	a3,0
     776:	4601                	li	a2,0
     778:	85ca                	mv	a1,s2
     77a:	8526                	mv	a0,s1
     77c:	b93ff0ef          	jal	30e <gettoken>
  cmd = parseline(ps, es);
     780:	85ca                	mv	a1,s2
     782:	8526                	mv	a0,s1
     784:	f49ff0ef          	jal	6cc <parseline>
     788:	89aa                	mv	s3,a0
  if(!peek(ps, es, ")"))
     78a:	00001617          	auipc	a2,0x1
     78e:	b4660613          	add	a2,a2,-1210 # 12d0 <malloc+0x1a6>
     792:	85ca                	mv	a1,s2
     794:	8526                	mv	a0,s1
     796:	cb5ff0ef          	jal	44a <peek>
     79a:	c90d                	beqz	a0,7cc <parseblock+0x78>
  gettoken(ps, es, 0, 0);
     79c:	4681                	li	a3,0
     79e:	4601                	li	a2,0
     7a0:	85ca                	mv	a1,s2
     7a2:	8526                	mv	a0,s1
     7a4:	b6bff0ef          	jal	30e <gettoken>
  cmd = parseredirs(cmd, ps, es);
     7a8:	864a                	mv	a2,s2
     7aa:	85a6                	mv	a1,s1
     7ac:	854e                	mv	a0,s3
     7ae:	d01ff0ef          	jal	4ae <parseredirs>
}
     7b2:	70a2                	ld	ra,40(sp)
     7b4:	7402                	ld	s0,32(sp)
     7b6:	64e2                	ld	s1,24(sp)
     7b8:	6942                	ld	s2,16(sp)
     7ba:	69a2                	ld	s3,8(sp)
     7bc:	6145                	add	sp,sp,48
     7be:	8082                	ret
    panic("parseblock");
     7c0:	00001517          	auipc	a0,0x1
     7c4:	b0050513          	add	a0,a0,-1280 # 12c0 <malloc+0x196>
     7c8:	883ff0ef          	jal	4a <panic>
    panic("syntax - missing )");
     7cc:	00001517          	auipc	a0,0x1
     7d0:	b0c50513          	add	a0,a0,-1268 # 12d8 <malloc+0x1ae>
     7d4:	877ff0ef          	jal	4a <panic>

00000000000007d8 <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
     7d8:	1101                	add	sp,sp,-32
     7da:	ec06                	sd	ra,24(sp)
     7dc:	e822                	sd	s0,16(sp)
     7de:	e426                	sd	s1,8(sp)
     7e0:	1000                	add	s0,sp,32
     7e2:	84aa                	mv	s1,a0
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
     7e4:	c131                	beqz	a0,828 <nulterminate+0x50>
    return 0;

  switch(cmd->type){
     7e6:	4118                	lw	a4,0(a0)
     7e8:	4795                	li	a5,5
     7ea:	02e7ef63          	bltu	a5,a4,828 <nulterminate+0x50>
     7ee:	00056783          	lwu	a5,0(a0)
     7f2:	078a                	sll	a5,a5,0x2
     7f4:	00001717          	auipc	a4,0x1
     7f8:	b4470713          	add	a4,a4,-1212 # 1338 <malloc+0x20e>
     7fc:	97ba                	add	a5,a5,a4
     7fe:	439c                	lw	a5,0(a5)
     800:	97ba                	add	a5,a5,a4
     802:	8782                	jr	a5
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    for(i=0; ecmd->argv[i]; i++)
     804:	651c                	ld	a5,8(a0)
     806:	c38d                	beqz	a5,828 <nulterminate+0x50>
     808:	01050793          	add	a5,a0,16
      *ecmd->eargv[i] = 0;
     80c:	67b8                	ld	a4,72(a5)
     80e:	00070023          	sb	zero,0(a4)
    for(i=0; ecmd->argv[i]; i++)
     812:	07a1                	add	a5,a5,8
     814:	ff87b703          	ld	a4,-8(a5)
     818:	fb75                	bnez	a4,80c <nulterminate+0x34>
     81a:	a039                	j	828 <nulterminate+0x50>
    break;

  case REDIR:
    rcmd = (struct redircmd*)cmd;
    nulterminate(rcmd->cmd);
     81c:	6508                	ld	a0,8(a0)
     81e:	fbbff0ef          	jal	7d8 <nulterminate>
    *rcmd->efile = 0;
     822:	6c9c                	ld	a5,24(s1)
     824:	00078023          	sb	zero,0(a5)
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
     828:	8526                	mv	a0,s1
     82a:	60e2                	ld	ra,24(sp)
     82c:	6442                	ld	s0,16(sp)
     82e:	64a2                	ld	s1,8(sp)
     830:	6105                	add	sp,sp,32
     832:	8082                	ret
    nulterminate(pcmd->left);
     834:	6508                	ld	a0,8(a0)
     836:	fa3ff0ef          	jal	7d8 <nulterminate>
    nulterminate(pcmd->right);
     83a:	6888                	ld	a0,16(s1)
     83c:	f9dff0ef          	jal	7d8 <nulterminate>
    break;
     840:	b7e5                	j	828 <nulterminate+0x50>
    nulterminate(lcmd->left);
     842:	6508                	ld	a0,8(a0)
     844:	f95ff0ef          	jal	7d8 <nulterminate>
    nulterminate(lcmd->right);
     848:	6888                	ld	a0,16(s1)
     84a:	f8fff0ef          	jal	7d8 <nulterminate>
    break;
     84e:	bfe9                	j	828 <nulterminate+0x50>
    nulterminate(bcmd->cmd);
     850:	6508                	ld	a0,8(a0)
     852:	f87ff0ef          	jal	7d8 <nulterminate>
    break;
     856:	bfc9                	j	828 <nulterminate+0x50>

0000000000000858 <parsecmd>:
{
     858:	7179                	add	sp,sp,-48
     85a:	f406                	sd	ra,40(sp)
     85c:	f022                	sd	s0,32(sp)
     85e:	ec26                	sd	s1,24(sp)
     860:	e84a                	sd	s2,16(sp)
     862:	1800                	add	s0,sp,48
     864:	fca43c23          	sd	a0,-40(s0)
  es = s + strlen(s);
     868:	84aa                	mv	s1,a0
     86a:	18e000ef          	jal	9f8 <strlen>
     86e:	1502                	sll	a0,a0,0x20
     870:	9101                	srl	a0,a0,0x20
     872:	94aa                	add	s1,s1,a0
  cmd = parseline(&s, es);
     874:	85a6                	mv	a1,s1
     876:	fd840513          	add	a0,s0,-40
     87a:	e53ff0ef          	jal	6cc <parseline>
     87e:	892a                	mv	s2,a0
  peek(&s, es, "");
     880:	00001617          	auipc	a2,0x1
     884:	a7060613          	add	a2,a2,-1424 # 12f0 <malloc+0x1c6>
     888:	85a6                	mv	a1,s1
     88a:	fd840513          	add	a0,s0,-40
     88e:	bbdff0ef          	jal	44a <peek>
  if(s != es){
     892:	fd843603          	ld	a2,-40(s0)
     896:	00961c63          	bne	a2,s1,8ae <parsecmd+0x56>
  nulterminate(cmd);
     89a:	854a                	mv	a0,s2
     89c:	f3dff0ef          	jal	7d8 <nulterminate>
}
     8a0:	854a                	mv	a0,s2
     8a2:	70a2                	ld	ra,40(sp)
     8a4:	7402                	ld	s0,32(sp)
     8a6:	64e2                	ld	s1,24(sp)
     8a8:	6942                	ld	s2,16(sp)
     8aa:	6145                	add	sp,sp,48
     8ac:	8082                	ret
    fprintf(2, "leftovers: %s\n", s);
     8ae:	00001597          	auipc	a1,0x1
     8b2:	a4a58593          	add	a1,a1,-1462 # 12f8 <malloc+0x1ce>
     8b6:	4509                	li	a0,2
     8b8:	794000ef          	jal	104c <fprintf>
    panic("syntax");
     8bc:	00001517          	auipc	a0,0x1
     8c0:	9cc50513          	add	a0,a0,-1588 # 1288 <malloc+0x15e>
     8c4:	f86ff0ef          	jal	4a <panic>

00000000000008c8 <main>:
{
     8c8:	7139                	add	sp,sp,-64
     8ca:	fc06                	sd	ra,56(sp)
     8cc:	f822                	sd	s0,48(sp)
     8ce:	f426                	sd	s1,40(sp)
     8d0:	f04a                	sd	s2,32(sp)
     8d2:	ec4e                	sd	s3,24(sp)
     8d4:	e852                	sd	s4,16(sp)
     8d6:	e456                	sd	s5,8(sp)
     8d8:	e05a                	sd	s6,0(sp)
     8da:	0080                	add	s0,sp,64
  while((fd = open("console", O_RDWR)) >= 0){
     8dc:	00001497          	auipc	s1,0x1
     8e0:	a2c48493          	add	s1,s1,-1492 # 1308 <malloc+0x1de>
     8e4:	4589                	li	a1,2
     8e6:	8526                	mv	a0,s1
     8e8:	38c000ef          	jal	c74 <open>
     8ec:	00054763          	bltz	a0,8fa <main+0x32>
    if(fd >= 3){
     8f0:	4789                	li	a5,2
     8f2:	fea7d9e3          	bge	a5,a0,8e4 <main+0x1c>
      close(fd);
     8f6:	366000ef          	jal	c5c <close>
  while(getcmd(buf, sizeof(buf)) >= 0){
     8fa:	00001a17          	auipc	s4,0x1
     8fe:	726a0a13          	add	s4,s4,1830 # 2020 <buf.0>
    while (*cmd == ' ' || *cmd == '\t')
     902:	02000913          	li	s2,32
     906:	49a5                	li	s3,9
    if (*cmd == '\n') // is a blank command
     908:	4aa9                	li	s5,10
    if(cmd[0] == 'c' && cmd[1] == 'd' && cmd[2] == ' '){
     90a:	06300b13          	li	s6,99
     90e:	a805                	j	93e <main+0x76>
      cmd++;
     910:	0485                	add	s1,s1,1
    while (*cmd == ' ' || *cmd == '\t')
     912:	0004c783          	lbu	a5,0(s1)
     916:	ff278de3          	beq	a5,s2,910 <main+0x48>
     91a:	ff378be3          	beq	a5,s3,910 <main+0x48>
    if (*cmd == '\n') // is a blank command
     91e:	03578063          	beq	a5,s5,93e <main+0x76>
    if(cmd[0] == 'c' && cmd[1] == 'd' && cmd[2] == ' '){
     922:	01679863          	bne	a5,s6,932 <main+0x6a>
     926:	0014c703          	lbu	a4,1(s1)
     92a:	06400793          	li	a5,100
     92e:	02f70463          	beq	a4,a5,956 <main+0x8e>
      if(fork1() == 0)
     932:	f36ff0ef          	jal	68 <fork1>
     936:	cd29                	beqz	a0,990 <main+0xc8>
      wait(0);
     938:	4501                	li	a0,0
     93a:	302000ef          	jal	c3c <wait>
  while(getcmd(buf, sizeof(buf)) >= 0){
     93e:	06400593          	li	a1,100
     942:	8552                	mv	a0,s4
     944:	ebcff0ef          	jal	0 <getcmd>
     948:	04054963          	bltz	a0,99a <main+0xd2>
    char *cmd = buf;
     94c:	00001497          	auipc	s1,0x1
     950:	6d448493          	add	s1,s1,1748 # 2020 <buf.0>
     954:	bf7d                	j	912 <main+0x4a>
    if(cmd[0] == 'c' && cmd[1] == 'd' && cmd[2] == ' '){
     956:	0024c783          	lbu	a5,2(s1)
     95a:	fd279ce3          	bne	a5,s2,932 <main+0x6a>
      cmd[strlen(cmd)-1] = 0;  // chop \n
     95e:	8526                	mv	a0,s1
     960:	098000ef          	jal	9f8 <strlen>
     964:	fff5079b          	addw	a5,a0,-1
     968:	1782                	sll	a5,a5,0x20
     96a:	9381                	srl	a5,a5,0x20
     96c:	97a6                	add	a5,a5,s1
     96e:	00078023          	sb	zero,0(a5)
      if(chdir(cmd+3) < 0)
     972:	048d                	add	s1,s1,3
     974:	8526                	mv	a0,s1
     976:	32e000ef          	jal	ca4 <chdir>
     97a:	fc0552e3          	bgez	a0,93e <main+0x76>
        fprintf(2, "cannot cd %s\n", cmd+3);
     97e:	8626                	mv	a2,s1
     980:	00001597          	auipc	a1,0x1
     984:	99058593          	add	a1,a1,-1648 # 1310 <malloc+0x1e6>
     988:	4509                	li	a0,2
     98a:	6c2000ef          	jal	104c <fprintf>
     98e:	bf45                	j	93e <main+0x76>
        runcmd(parsecmd(cmd));
     990:	8526                	mv	a0,s1
     992:	ec7ff0ef          	jal	858 <parsecmd>
     996:	ef8ff0ef          	jal	8e <runcmd>
  exit(0);
     99a:	4501                	li	a0,0
     99c:	298000ef          	jal	c34 <exit>

00000000000009a0 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
     9a0:	1141                	add	sp,sp,-16
     9a2:	e406                	sd	ra,8(sp)
     9a4:	e022                	sd	s0,0(sp)
     9a6:	0800                	add	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
     9a8:	f21ff0ef          	jal	8c8 <main>
  exit(r);
     9ac:	288000ef          	jal	c34 <exit>

00000000000009b0 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
     9b0:	1141                	add	sp,sp,-16
     9b2:	e422                	sd	s0,8(sp)
     9b4:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     9b6:	87aa                	mv	a5,a0
     9b8:	0585                	add	a1,a1,1
     9ba:	0785                	add	a5,a5,1
     9bc:	fff5c703          	lbu	a4,-1(a1)
     9c0:	fee78fa3          	sb	a4,-1(a5)
     9c4:	fb75                	bnez	a4,9b8 <strcpy+0x8>
    ;
  return os;
}
     9c6:	6422                	ld	s0,8(sp)
     9c8:	0141                	add	sp,sp,16
     9ca:	8082                	ret

00000000000009cc <strcmp>:

int
strcmp(const char *p, const char *q)
{
     9cc:	1141                	add	sp,sp,-16
     9ce:	e422                	sd	s0,8(sp)
     9d0:	0800                	add	s0,sp,16
  while(*p && *p == *q)
     9d2:	00054783          	lbu	a5,0(a0)
     9d6:	cb91                	beqz	a5,9ea <strcmp+0x1e>
     9d8:	0005c703          	lbu	a4,0(a1)
     9dc:	00f71763          	bne	a4,a5,9ea <strcmp+0x1e>
    p++, q++;
     9e0:	0505                	add	a0,a0,1
     9e2:	0585                	add	a1,a1,1
  while(*p && *p == *q)
     9e4:	00054783          	lbu	a5,0(a0)
     9e8:	fbe5                	bnez	a5,9d8 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
     9ea:	0005c503          	lbu	a0,0(a1)
}
     9ee:	40a7853b          	subw	a0,a5,a0
     9f2:	6422                	ld	s0,8(sp)
     9f4:	0141                	add	sp,sp,16
     9f6:	8082                	ret

00000000000009f8 <strlen>:

uint
strlen(const char *s)
{
     9f8:	1141                	add	sp,sp,-16
     9fa:	e422                	sd	s0,8(sp)
     9fc:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     9fe:	00054783          	lbu	a5,0(a0)
     a02:	cf91                	beqz	a5,a1e <strlen+0x26>
     a04:	0505                	add	a0,a0,1
     a06:	87aa                	mv	a5,a0
     a08:	86be                	mv	a3,a5
     a0a:	0785                	add	a5,a5,1
     a0c:	fff7c703          	lbu	a4,-1(a5)
     a10:	ff65                	bnez	a4,a08 <strlen+0x10>
     a12:	40a6853b          	subw	a0,a3,a0
     a16:	2505                	addw	a0,a0,1
    ;
  return n;
}
     a18:	6422                	ld	s0,8(sp)
     a1a:	0141                	add	sp,sp,16
     a1c:	8082                	ret
  for(n = 0; s[n]; n++)
     a1e:	4501                	li	a0,0
     a20:	bfe5                	j	a18 <strlen+0x20>

0000000000000a22 <memset>:

void*
memset(void *dst, int c, uint n)
{
     a22:	1141                	add	sp,sp,-16
     a24:	e422                	sd	s0,8(sp)
     a26:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     a28:	ca19                	beqz	a2,a3e <memset+0x1c>
     a2a:	87aa                	mv	a5,a0
     a2c:	1602                	sll	a2,a2,0x20
     a2e:	9201                	srl	a2,a2,0x20
     a30:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     a34:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     a38:	0785                	add	a5,a5,1
     a3a:	fee79de3          	bne	a5,a4,a34 <memset+0x12>
  }
  return dst;
}
     a3e:	6422                	ld	s0,8(sp)
     a40:	0141                	add	sp,sp,16
     a42:	8082                	ret

0000000000000a44 <strchr>:

char*
strchr(const char *s, char c)
{
     a44:	1141                	add	sp,sp,-16
     a46:	e422                	sd	s0,8(sp)
     a48:	0800                	add	s0,sp,16
  for(; *s; s++)
     a4a:	00054783          	lbu	a5,0(a0)
     a4e:	cb99                	beqz	a5,a64 <strchr+0x20>
    if(*s == c)
     a50:	00f58763          	beq	a1,a5,a5e <strchr+0x1a>
  for(; *s; s++)
     a54:	0505                	add	a0,a0,1
     a56:	00054783          	lbu	a5,0(a0)
     a5a:	fbfd                	bnez	a5,a50 <strchr+0xc>
      return (char*)s;
  return 0;
     a5c:	4501                	li	a0,0
}
     a5e:	6422                	ld	s0,8(sp)
     a60:	0141                	add	sp,sp,16
     a62:	8082                	ret
  return 0;
     a64:	4501                	li	a0,0
     a66:	bfe5                	j	a5e <strchr+0x1a>

0000000000000a68 <gets>:

char*
gets(char *buf, int max)
{
     a68:	711d                	add	sp,sp,-96
     a6a:	ec86                	sd	ra,88(sp)
     a6c:	e8a2                	sd	s0,80(sp)
     a6e:	e4a6                	sd	s1,72(sp)
     a70:	e0ca                	sd	s2,64(sp)
     a72:	fc4e                	sd	s3,56(sp)
     a74:	f852                	sd	s4,48(sp)
     a76:	f456                	sd	s5,40(sp)
     a78:	f05a                	sd	s6,32(sp)
     a7a:	ec5e                	sd	s7,24(sp)
     a7c:	1080                	add	s0,sp,96
     a7e:	8baa                	mv	s7,a0
     a80:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     a82:	892a                	mv	s2,a0
     a84:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     a86:	4aa9                	li	s5,10
     a88:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
     a8a:	89a6                	mv	s3,s1
     a8c:	2485                	addw	s1,s1,1
     a8e:	0344d663          	bge	s1,s4,aba <gets+0x52>
    cc = read(0, &c, 1);
     a92:	4605                	li	a2,1
     a94:	faf40593          	add	a1,s0,-81
     a98:	4501                	li	a0,0
     a9a:	1b2000ef          	jal	c4c <read>
    if(cc < 1)
     a9e:	00a05e63          	blez	a0,aba <gets+0x52>
    buf[i++] = c;
     aa2:	faf44783          	lbu	a5,-81(s0)
     aa6:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     aaa:	01578763          	beq	a5,s5,ab8 <gets+0x50>
     aae:	0905                	add	s2,s2,1
     ab0:	fd679de3          	bne	a5,s6,a8a <gets+0x22>
  for(i=0; i+1 < max; ){
     ab4:	89a6                	mv	s3,s1
     ab6:	a011                	j	aba <gets+0x52>
     ab8:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
     aba:	99de                	add	s3,s3,s7
     abc:	00098023          	sb	zero,0(s3)
  return buf;
}
     ac0:	855e                	mv	a0,s7
     ac2:	60e6                	ld	ra,88(sp)
     ac4:	6446                	ld	s0,80(sp)
     ac6:	64a6                	ld	s1,72(sp)
     ac8:	6906                	ld	s2,64(sp)
     aca:	79e2                	ld	s3,56(sp)
     acc:	7a42                	ld	s4,48(sp)
     ace:	7aa2                	ld	s5,40(sp)
     ad0:	7b02                	ld	s6,32(sp)
     ad2:	6be2                	ld	s7,24(sp)
     ad4:	6125                	add	sp,sp,96
     ad6:	8082                	ret

0000000000000ad8 <stat>:

int
stat(const char *n, struct stat *st)
{
     ad8:	1101                	add	sp,sp,-32
     ada:	ec06                	sd	ra,24(sp)
     adc:	e822                	sd	s0,16(sp)
     ade:	e426                	sd	s1,8(sp)
     ae0:	e04a                	sd	s2,0(sp)
     ae2:	1000                	add	s0,sp,32
     ae4:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     ae6:	4581                	li	a1,0
     ae8:	18c000ef          	jal	c74 <open>
  if(fd < 0)
     aec:	02054163          	bltz	a0,b0e <stat+0x36>
     af0:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     af2:	85ca                	mv	a1,s2
     af4:	198000ef          	jal	c8c <fstat>
     af8:	892a                	mv	s2,a0
  close(fd);
     afa:	8526                	mv	a0,s1
     afc:	160000ef          	jal	c5c <close>
  return r;
}
     b00:	854a                	mv	a0,s2
     b02:	60e2                	ld	ra,24(sp)
     b04:	6442                	ld	s0,16(sp)
     b06:	64a2                	ld	s1,8(sp)
     b08:	6902                	ld	s2,0(sp)
     b0a:	6105                	add	sp,sp,32
     b0c:	8082                	ret
    return -1;
     b0e:	597d                	li	s2,-1
     b10:	bfc5                	j	b00 <stat+0x28>

0000000000000b12 <atoi>:

int
atoi(const char *s)
{
     b12:	1141                	add	sp,sp,-16
     b14:	e422                	sd	s0,8(sp)
     b16:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     b18:	00054683          	lbu	a3,0(a0)
     b1c:	fd06879b          	addw	a5,a3,-48
     b20:	0ff7f793          	zext.b	a5,a5
     b24:	4625                	li	a2,9
     b26:	02f66863          	bltu	a2,a5,b56 <atoi+0x44>
     b2a:	872a                	mv	a4,a0
  n = 0;
     b2c:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
     b2e:	0705                	add	a4,a4,1
     b30:	0025179b          	sllw	a5,a0,0x2
     b34:	9fa9                	addw	a5,a5,a0
     b36:	0017979b          	sllw	a5,a5,0x1
     b3a:	9fb5                	addw	a5,a5,a3
     b3c:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     b40:	00074683          	lbu	a3,0(a4)
     b44:	fd06879b          	addw	a5,a3,-48
     b48:	0ff7f793          	zext.b	a5,a5
     b4c:	fef671e3          	bgeu	a2,a5,b2e <atoi+0x1c>
  return n;
}
     b50:	6422                	ld	s0,8(sp)
     b52:	0141                	add	sp,sp,16
     b54:	8082                	ret
  n = 0;
     b56:	4501                	li	a0,0
     b58:	bfe5                	j	b50 <atoi+0x3e>

0000000000000b5a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     b5a:	1141                	add	sp,sp,-16
     b5c:	e422                	sd	s0,8(sp)
     b5e:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     b60:	02b57463          	bgeu	a0,a1,b88 <memmove+0x2e>
    while(n-- > 0)
     b64:	00c05f63          	blez	a2,b82 <memmove+0x28>
     b68:	1602                	sll	a2,a2,0x20
     b6a:	9201                	srl	a2,a2,0x20
     b6c:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     b70:	872a                	mv	a4,a0
      *dst++ = *src++;
     b72:	0585                	add	a1,a1,1
     b74:	0705                	add	a4,a4,1
     b76:	fff5c683          	lbu	a3,-1(a1)
     b7a:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     b7e:	fee79ae3          	bne	a5,a4,b72 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     b82:	6422                	ld	s0,8(sp)
     b84:	0141                	add	sp,sp,16
     b86:	8082                	ret
    dst += n;
     b88:	00c50733          	add	a4,a0,a2
    src += n;
     b8c:	95b2                	add	a1,a1,a2
    while(n-- > 0)
     b8e:	fec05ae3          	blez	a2,b82 <memmove+0x28>
     b92:	fff6079b          	addw	a5,a2,-1
     b96:	1782                	sll	a5,a5,0x20
     b98:	9381                	srl	a5,a5,0x20
     b9a:	fff7c793          	not	a5,a5
     b9e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     ba0:	15fd                	add	a1,a1,-1
     ba2:	177d                	add	a4,a4,-1
     ba4:	0005c683          	lbu	a3,0(a1)
     ba8:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     bac:	fee79ae3          	bne	a5,a4,ba0 <memmove+0x46>
     bb0:	bfc9                	j	b82 <memmove+0x28>

0000000000000bb2 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     bb2:	1141                	add	sp,sp,-16
     bb4:	e422                	sd	s0,8(sp)
     bb6:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     bb8:	ca05                	beqz	a2,be8 <memcmp+0x36>
     bba:	fff6069b          	addw	a3,a2,-1
     bbe:	1682                	sll	a3,a3,0x20
     bc0:	9281                	srl	a3,a3,0x20
     bc2:	0685                	add	a3,a3,1
     bc4:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
     bc6:	00054783          	lbu	a5,0(a0)
     bca:	0005c703          	lbu	a4,0(a1)
     bce:	00e79863          	bne	a5,a4,bde <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
     bd2:	0505                	add	a0,a0,1
    p2++;
     bd4:	0585                	add	a1,a1,1
  while (n-- > 0) {
     bd6:	fed518e3          	bne	a0,a3,bc6 <memcmp+0x14>
  }
  return 0;
     bda:	4501                	li	a0,0
     bdc:	a019                	j	be2 <memcmp+0x30>
      return *p1 - *p2;
     bde:	40e7853b          	subw	a0,a5,a4
}
     be2:	6422                	ld	s0,8(sp)
     be4:	0141                	add	sp,sp,16
     be6:	8082                	ret
  return 0;
     be8:	4501                	li	a0,0
     bea:	bfe5                	j	be2 <memcmp+0x30>

0000000000000bec <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     bec:	1141                	add	sp,sp,-16
     bee:	e406                	sd	ra,8(sp)
     bf0:	e022                	sd	s0,0(sp)
     bf2:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
     bf4:	f67ff0ef          	jal	b5a <memmove>
}
     bf8:	60a2                	ld	ra,8(sp)
     bfa:	6402                	ld	s0,0(sp)
     bfc:	0141                	add	sp,sp,16
     bfe:	8082                	ret

0000000000000c00 <sbrk>:

char *
sbrk(int n) {
     c00:	1141                	add	sp,sp,-16
     c02:	e406                	sd	ra,8(sp)
     c04:	e022                	sd	s0,0(sp)
     c06:	0800                	add	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
     c08:	4585                	li	a1,1
     c0a:	0b2000ef          	jal	cbc <sys_sbrk>
}
     c0e:	60a2                	ld	ra,8(sp)
     c10:	6402                	ld	s0,0(sp)
     c12:	0141                	add	sp,sp,16
     c14:	8082                	ret

0000000000000c16 <sbrklazy>:

char *
sbrklazy(int n) {
     c16:	1141                	add	sp,sp,-16
     c18:	e406                	sd	ra,8(sp)
     c1a:	e022                	sd	s0,0(sp)
     c1c:	0800                	add	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
     c1e:	4589                	li	a1,2
     c20:	09c000ef          	jal	cbc <sys_sbrk>
}
     c24:	60a2                	ld	ra,8(sp)
     c26:	6402                	ld	s0,0(sp)
     c28:	0141                	add	sp,sp,16
     c2a:	8082                	ret

0000000000000c2c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     c2c:	4885                	li	a7,1
 ecall
     c2e:	00000073          	ecall
 ret
     c32:	8082                	ret

0000000000000c34 <exit>:
.global exit
exit:
 li a7, SYS_exit
     c34:	4889                	li	a7,2
 ecall
     c36:	00000073          	ecall
 ret
     c3a:	8082                	ret

0000000000000c3c <wait>:
.global wait
wait:
 li a7, SYS_wait
     c3c:	488d                	li	a7,3
 ecall
     c3e:	00000073          	ecall
 ret
     c42:	8082                	ret

0000000000000c44 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     c44:	4891                	li	a7,4
 ecall
     c46:	00000073          	ecall
 ret
     c4a:	8082                	ret

0000000000000c4c <read>:
.global read
read:
 li a7, SYS_read
     c4c:	4895                	li	a7,5
 ecall
     c4e:	00000073          	ecall
 ret
     c52:	8082                	ret

0000000000000c54 <write>:
.global write
write:
 li a7, SYS_write
     c54:	48c1                	li	a7,16
 ecall
     c56:	00000073          	ecall
 ret
     c5a:	8082                	ret

0000000000000c5c <close>:
.global close
close:
 li a7, SYS_close
     c5c:	48d5                	li	a7,21
 ecall
     c5e:	00000073          	ecall
 ret
     c62:	8082                	ret

0000000000000c64 <kill>:
.global kill
kill:
 li a7, SYS_kill
     c64:	4899                	li	a7,6
 ecall
     c66:	00000073          	ecall
 ret
     c6a:	8082                	ret

0000000000000c6c <exec>:
.global exec
exec:
 li a7, SYS_exec
     c6c:	489d                	li	a7,7
 ecall
     c6e:	00000073          	ecall
 ret
     c72:	8082                	ret

0000000000000c74 <open>:
.global open
open:
 li a7, SYS_open
     c74:	48bd                	li	a7,15
 ecall
     c76:	00000073          	ecall
 ret
     c7a:	8082                	ret

0000000000000c7c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     c7c:	48c5                	li	a7,17
 ecall
     c7e:	00000073          	ecall
 ret
     c82:	8082                	ret

0000000000000c84 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     c84:	48c9                	li	a7,18
 ecall
     c86:	00000073          	ecall
 ret
     c8a:	8082                	ret

0000000000000c8c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     c8c:	48a1                	li	a7,8
 ecall
     c8e:	00000073          	ecall
 ret
     c92:	8082                	ret

0000000000000c94 <link>:
.global link
link:
 li a7, SYS_link
     c94:	48cd                	li	a7,19
 ecall
     c96:	00000073          	ecall
 ret
     c9a:	8082                	ret

0000000000000c9c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     c9c:	48d1                	li	a7,20
 ecall
     c9e:	00000073          	ecall
 ret
     ca2:	8082                	ret

0000000000000ca4 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     ca4:	48a5                	li	a7,9
 ecall
     ca6:	00000073          	ecall
 ret
     caa:	8082                	ret

0000000000000cac <dup>:
.global dup
dup:
 li a7, SYS_dup
     cac:	48a9                	li	a7,10
 ecall
     cae:	00000073          	ecall
 ret
     cb2:	8082                	ret

0000000000000cb4 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     cb4:	48ad                	li	a7,11
 ecall
     cb6:	00000073          	ecall
 ret
     cba:	8082                	ret

0000000000000cbc <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
     cbc:	48b1                	li	a7,12
 ecall
     cbe:	00000073          	ecall
 ret
     cc2:	8082                	ret

0000000000000cc4 <pause>:
.global pause
pause:
 li a7, SYS_pause
     cc4:	48b5                	li	a7,13
 ecall
     cc6:	00000073          	ecall
 ret
     cca:	8082                	ret

0000000000000ccc <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     ccc:	48b9                	li	a7,14
 ecall
     cce:	00000073          	ecall
 ret
     cd2:	8082                	ret

0000000000000cd4 <getcnt>:
.global getcnt
getcnt:
 li a7, SYS_getcnt
     cd4:	48d9                	li	a7,22
 ecall
     cd6:	00000073          	ecall
 ret
     cda:	8082                	ret

0000000000000cdc <settickets>:
.global settickets
settickets:
 li a7, SYS_settickets
     cdc:	48dd                	li	a7,23
 ecall
     cde:	00000073          	ecall
 ret
     ce2:	8082                	ret

0000000000000ce4 <getpinfo>:
.global getpinfo
getpinfo:
 li a7, SYS_getpinfo
     ce4:	48e1                	li	a7,24
 ecall
     ce6:	00000073          	ecall
 ret
     cea:	8082                	ret

0000000000000cec <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     cec:	1101                	add	sp,sp,-32
     cee:	ec06                	sd	ra,24(sp)
     cf0:	e822                	sd	s0,16(sp)
     cf2:	1000                	add	s0,sp,32
     cf4:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     cf8:	4605                	li	a2,1
     cfa:	fef40593          	add	a1,s0,-17
     cfe:	f57ff0ef          	jal	c54 <write>
}
     d02:	60e2                	ld	ra,24(sp)
     d04:	6442                	ld	s0,16(sp)
     d06:	6105                	add	sp,sp,32
     d08:	8082                	ret

0000000000000d0a <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
     d0a:	715d                	add	sp,sp,-80
     d0c:	e486                	sd	ra,72(sp)
     d0e:	e0a2                	sd	s0,64(sp)
     d10:	fc26                	sd	s1,56(sp)
     d12:	f84a                	sd	s2,48(sp)
     d14:	f44e                	sd	s3,40(sp)
     d16:	0880                	add	s0,sp,80
     d18:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
     d1a:	c299                	beqz	a3,d20 <printint+0x16>
     d1c:	0805c163          	bltz	a1,d9e <printint+0x94>
  neg = 0;
     d20:	4881                	li	a7,0
     d22:	fb840693          	add	a3,s0,-72
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
     d26:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
     d28:	00000517          	auipc	a0,0x0
     d2c:	63050513          	add	a0,a0,1584 # 1358 <digits>
     d30:	883e                	mv	a6,a5
     d32:	2785                	addw	a5,a5,1
     d34:	02c5f733          	remu	a4,a1,a2
     d38:	972a                	add	a4,a4,a0
     d3a:	00074703          	lbu	a4,0(a4)
     d3e:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
     d42:	872e                	mv	a4,a1
     d44:	02c5d5b3          	divu	a1,a1,a2
     d48:	0685                	add	a3,a3,1
     d4a:	fec773e3          	bgeu	a4,a2,d30 <printint+0x26>
  if(neg)
     d4e:	00088b63          	beqz	a7,d64 <printint+0x5a>
    buf[i++] = '-';
     d52:	fd078793          	add	a5,a5,-48
     d56:	97a2                	add	a5,a5,s0
     d58:	02d00713          	li	a4,45
     d5c:	fee78423          	sb	a4,-24(a5)
     d60:	0028079b          	addw	a5,a6,2

  while(--i >= 0)
     d64:	02f05663          	blez	a5,d90 <printint+0x86>
     d68:	fb840713          	add	a4,s0,-72
     d6c:	00f704b3          	add	s1,a4,a5
     d70:	fff70993          	add	s3,a4,-1
     d74:	99be                	add	s3,s3,a5
     d76:	37fd                	addw	a5,a5,-1
     d78:	1782                	sll	a5,a5,0x20
     d7a:	9381                	srl	a5,a5,0x20
     d7c:	40f989b3          	sub	s3,s3,a5
    putc(fd, buf[i]);
     d80:	fff4c583          	lbu	a1,-1(s1)
     d84:	854a                	mv	a0,s2
     d86:	f67ff0ef          	jal	cec <putc>
  while(--i >= 0)
     d8a:	14fd                	add	s1,s1,-1
     d8c:	ff349ae3          	bne	s1,s3,d80 <printint+0x76>
}
     d90:	60a6                	ld	ra,72(sp)
     d92:	6406                	ld	s0,64(sp)
     d94:	74e2                	ld	s1,56(sp)
     d96:	7942                	ld	s2,48(sp)
     d98:	79a2                	ld	s3,40(sp)
     d9a:	6161                	add	sp,sp,80
     d9c:	8082                	ret
    x = -xx;
     d9e:	40b005b3          	neg	a1,a1
    neg = 1;
     da2:	4885                	li	a7,1
    x = -xx;
     da4:	bfbd                	j	d22 <printint+0x18>

0000000000000da6 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     da6:	711d                	add	sp,sp,-96
     da8:	ec86                	sd	ra,88(sp)
     daa:	e8a2                	sd	s0,80(sp)
     dac:	e4a6                	sd	s1,72(sp)
     dae:	e0ca                	sd	s2,64(sp)
     db0:	fc4e                	sd	s3,56(sp)
     db2:	f852                	sd	s4,48(sp)
     db4:	f456                	sd	s5,40(sp)
     db6:	f05a                	sd	s6,32(sp)
     db8:	ec5e                	sd	s7,24(sp)
     dba:	e862                	sd	s8,16(sp)
     dbc:	e466                	sd	s9,8(sp)
     dbe:	e06a                	sd	s10,0(sp)
     dc0:	1080                	add	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     dc2:	0005c903          	lbu	s2,0(a1)
     dc6:	26090563          	beqz	s2,1030 <vprintf+0x28a>
     dca:	8b2a                	mv	s6,a0
     dcc:	8a2e                	mv	s4,a1
     dce:	8bb2                	mv	s7,a2
  state = 0;
     dd0:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
     dd2:	4481                	li	s1,0
     dd4:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
     dd6:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
     dda:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
     dde:	06c00c93          	li	s9,108
     de2:	a005                	j	e02 <vprintf+0x5c>
        putc(fd, c0);
     de4:	85ca                	mv	a1,s2
     de6:	855a                	mv	a0,s6
     de8:	f05ff0ef          	jal	cec <putc>
     dec:	a019                	j	df2 <vprintf+0x4c>
    } else if(state == '%'){
     dee:	03598263          	beq	s3,s5,e12 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
     df2:	2485                	addw	s1,s1,1
     df4:	8726                	mv	a4,s1
     df6:	009a07b3          	add	a5,s4,s1
     dfa:	0007c903          	lbu	s2,0(a5)
     dfe:	22090963          	beqz	s2,1030 <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
     e02:	0009079b          	sext.w	a5,s2
    if(state == 0){
     e06:	fe0994e3          	bnez	s3,dee <vprintf+0x48>
      if(c0 == '%'){
     e0a:	fd579de3          	bne	a5,s5,de4 <vprintf+0x3e>
        state = '%';
     e0e:	89be                	mv	s3,a5
     e10:	b7cd                	j	df2 <vprintf+0x4c>
      if(c0) c1 = fmt[i+1] & 0xff;
     e12:	cbc9                	beqz	a5,ea4 <vprintf+0xfe>
     e14:	00ea06b3          	add	a3,s4,a4
     e18:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
     e1c:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
     e1e:	c681                	beqz	a3,e26 <vprintf+0x80>
     e20:	9752                	add	a4,a4,s4
     e22:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
     e26:	05878363          	beq	a5,s8,e6c <vprintf+0xc6>
      } else if(c0 == 'l' && c1 == 'd'){
     e2a:	05978d63          	beq	a5,s9,e84 <vprintf+0xde>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
     e2e:	07500713          	li	a4,117
     e32:	0ee78763          	beq	a5,a4,f20 <vprintf+0x17a>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
     e36:	07800713          	li	a4,120
     e3a:	12e78963          	beq	a5,a4,f6c <vprintf+0x1c6>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
     e3e:	07000713          	li	a4,112
     e42:	14e78e63          	beq	a5,a4,f9e <vprintf+0x1f8>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
     e46:	06300713          	li	a4,99
     e4a:	18e78c63          	beq	a5,a4,fe2 <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
     e4e:	07300713          	li	a4,115
     e52:	1ae78263          	beq	a5,a4,ff6 <vprintf+0x250>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
     e56:	02500713          	li	a4,37
     e5a:	04e79563          	bne	a5,a4,ea4 <vprintf+0xfe>
        putc(fd, '%');
     e5e:	02500593          	li	a1,37
     e62:	855a                	mv	a0,s6
     e64:	e89ff0ef          	jal	cec <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
     e68:	4981                	li	s3,0
     e6a:	b761                	j	df2 <vprintf+0x4c>
        printint(fd, va_arg(ap, int), 10, 1);
     e6c:	008b8913          	add	s2,s7,8
     e70:	4685                	li	a3,1
     e72:	4629                	li	a2,10
     e74:	000ba583          	lw	a1,0(s7)
     e78:	855a                	mv	a0,s6
     e7a:	e91ff0ef          	jal	d0a <printint>
     e7e:	8bca                	mv	s7,s2
      state = 0;
     e80:	4981                	li	s3,0
     e82:	bf85                	j	df2 <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'd'){
     e84:	06400793          	li	a5,100
     e88:	02f68963          	beq	a3,a5,eba <vprintf+0x114>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
     e8c:	06c00793          	li	a5,108
     e90:	04f68263          	beq	a3,a5,ed4 <vprintf+0x12e>
      } else if(c0 == 'l' && c1 == 'u'){
     e94:	07500793          	li	a5,117
     e98:	0af68063          	beq	a3,a5,f38 <vprintf+0x192>
      } else if(c0 == 'l' && c1 == 'x'){
     e9c:	07800793          	li	a5,120
     ea0:	0ef68263          	beq	a3,a5,f84 <vprintf+0x1de>
        putc(fd, '%');
     ea4:	02500593          	li	a1,37
     ea8:	855a                	mv	a0,s6
     eaa:	e43ff0ef          	jal	cec <putc>
        putc(fd, c0);
     eae:	85ca                	mv	a1,s2
     eb0:	855a                	mv	a0,s6
     eb2:	e3bff0ef          	jal	cec <putc>
      state = 0;
     eb6:	4981                	li	s3,0
     eb8:	bf2d                	j	df2 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
     eba:	008b8913          	add	s2,s7,8
     ebe:	4685                	li	a3,1
     ec0:	4629                	li	a2,10
     ec2:	000bb583          	ld	a1,0(s7)
     ec6:	855a                	mv	a0,s6
     ec8:	e43ff0ef          	jal	d0a <printint>
        i += 1;
     ecc:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
     ece:	8bca                	mv	s7,s2
      state = 0;
     ed0:	4981                	li	s3,0
        i += 1;
     ed2:	b705                	j	df2 <vprintf+0x4c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
     ed4:	06400793          	li	a5,100
     ed8:	02f60763          	beq	a2,a5,f06 <vprintf+0x160>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
     edc:	07500793          	li	a5,117
     ee0:	06f60963          	beq	a2,a5,f52 <vprintf+0x1ac>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
     ee4:	07800793          	li	a5,120
     ee8:	faf61ee3          	bne	a2,a5,ea4 <vprintf+0xfe>
        printint(fd, va_arg(ap, uint64), 16, 0);
     eec:	008b8913          	add	s2,s7,8
     ef0:	4681                	li	a3,0
     ef2:	4641                	li	a2,16
     ef4:	000bb583          	ld	a1,0(s7)
     ef8:	855a                	mv	a0,s6
     efa:	e11ff0ef          	jal	d0a <printint>
        i += 2;
     efe:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
     f00:	8bca                	mv	s7,s2
      state = 0;
     f02:	4981                	li	s3,0
        i += 2;
     f04:	b5fd                	j	df2 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 1);
     f06:	008b8913          	add	s2,s7,8
     f0a:	4685                	li	a3,1
     f0c:	4629                	li	a2,10
     f0e:	000bb583          	ld	a1,0(s7)
     f12:	855a                	mv	a0,s6
     f14:	df7ff0ef          	jal	d0a <printint>
        i += 2;
     f18:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
     f1a:	8bca                	mv	s7,s2
      state = 0;
     f1c:	4981                	li	s3,0
        i += 2;
     f1e:	bdd1                	j	df2 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint32), 10, 0);
     f20:	008b8913          	add	s2,s7,8
     f24:	4681                	li	a3,0
     f26:	4629                	li	a2,10
     f28:	000be583          	lwu	a1,0(s7)
     f2c:	855a                	mv	a0,s6
     f2e:	dddff0ef          	jal	d0a <printint>
     f32:	8bca                	mv	s7,s2
      state = 0;
     f34:	4981                	li	s3,0
     f36:	bd75                	j	df2 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
     f38:	008b8913          	add	s2,s7,8
     f3c:	4681                	li	a3,0
     f3e:	4629                	li	a2,10
     f40:	000bb583          	ld	a1,0(s7)
     f44:	855a                	mv	a0,s6
     f46:	dc5ff0ef          	jal	d0a <printint>
        i += 1;
     f4a:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
     f4c:	8bca                	mv	s7,s2
      state = 0;
     f4e:	4981                	li	s3,0
        i += 1;
     f50:	b54d                	j	df2 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 10, 0);
     f52:	008b8913          	add	s2,s7,8
     f56:	4681                	li	a3,0
     f58:	4629                	li	a2,10
     f5a:	000bb583          	ld	a1,0(s7)
     f5e:	855a                	mv	a0,s6
     f60:	dabff0ef          	jal	d0a <printint>
        i += 2;
     f64:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
     f66:	8bca                	mv	s7,s2
      state = 0;
     f68:	4981                	li	s3,0
        i += 2;
     f6a:	b561                	j	df2 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint32), 16, 0);
     f6c:	008b8913          	add	s2,s7,8
     f70:	4681                	li	a3,0
     f72:	4641                	li	a2,16
     f74:	000be583          	lwu	a1,0(s7)
     f78:	855a                	mv	a0,s6
     f7a:	d91ff0ef          	jal	d0a <printint>
     f7e:	8bca                	mv	s7,s2
      state = 0;
     f80:	4981                	li	s3,0
     f82:	bd85                	j	df2 <vprintf+0x4c>
        printint(fd, va_arg(ap, uint64), 16, 0);
     f84:	008b8913          	add	s2,s7,8
     f88:	4681                	li	a3,0
     f8a:	4641                	li	a2,16
     f8c:	000bb583          	ld	a1,0(s7)
     f90:	855a                	mv	a0,s6
     f92:	d79ff0ef          	jal	d0a <printint>
        i += 1;
     f96:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
     f98:	8bca                	mv	s7,s2
      state = 0;
     f9a:	4981                	li	s3,0
        i += 1;
     f9c:	bd99                	j	df2 <vprintf+0x4c>
        printptr(fd, va_arg(ap, uint64));
     f9e:	008b8d13          	add	s10,s7,8
     fa2:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
     fa6:	03000593          	li	a1,48
     faa:	855a                	mv	a0,s6
     fac:	d41ff0ef          	jal	cec <putc>
  putc(fd, 'x');
     fb0:	07800593          	li	a1,120
     fb4:	855a                	mv	a0,s6
     fb6:	d37ff0ef          	jal	cec <putc>
     fba:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     fbc:	00000b97          	auipc	s7,0x0
     fc0:	39cb8b93          	add	s7,s7,924 # 1358 <digits>
     fc4:	03c9d793          	srl	a5,s3,0x3c
     fc8:	97de                	add	a5,a5,s7
     fca:	0007c583          	lbu	a1,0(a5)
     fce:	855a                	mv	a0,s6
     fd0:	d1dff0ef          	jal	cec <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
     fd4:	0992                	sll	s3,s3,0x4
     fd6:	397d                	addw	s2,s2,-1
     fd8:	fe0916e3          	bnez	s2,fc4 <vprintf+0x21e>
        printptr(fd, va_arg(ap, uint64));
     fdc:	8bea                	mv	s7,s10
      state = 0;
     fde:	4981                	li	s3,0
     fe0:	bd09                	j	df2 <vprintf+0x4c>
        putc(fd, va_arg(ap, uint32));
     fe2:	008b8913          	add	s2,s7,8
     fe6:	000bc583          	lbu	a1,0(s7)
     fea:	855a                	mv	a0,s6
     fec:	d01ff0ef          	jal	cec <putc>
     ff0:	8bca                	mv	s7,s2
      state = 0;
     ff2:	4981                	li	s3,0
     ff4:	bbfd                	j	df2 <vprintf+0x4c>
        if((s = va_arg(ap, char*)) == 0)
     ff6:	008b8993          	add	s3,s7,8
     ffa:	000bb903          	ld	s2,0(s7)
     ffe:	00090f63          	beqz	s2,101c <vprintf+0x276>
        for(; *s; s++)
    1002:	00094583          	lbu	a1,0(s2)
    1006:	c195                	beqz	a1,102a <vprintf+0x284>
          putc(fd, *s);
    1008:	855a                	mv	a0,s6
    100a:	ce3ff0ef          	jal	cec <putc>
        for(; *s; s++)
    100e:	0905                	add	s2,s2,1
    1010:	00094583          	lbu	a1,0(s2)
    1014:	f9f5                	bnez	a1,1008 <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
    1016:	8bce                	mv	s7,s3
      state = 0;
    1018:	4981                	li	s3,0
    101a:	bbe1                	j	df2 <vprintf+0x4c>
          s = "(null)";
    101c:	00000917          	auipc	s2,0x0
    1020:	33490913          	add	s2,s2,820 # 1350 <malloc+0x226>
        for(; *s; s++)
    1024:	02800593          	li	a1,40
    1028:	b7c5                	j	1008 <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
    102a:	8bce                	mv	s7,s3
      state = 0;
    102c:	4981                	li	s3,0
    102e:	b3d1                	j	df2 <vprintf+0x4c>
    }
  }
}
    1030:	60e6                	ld	ra,88(sp)
    1032:	6446                	ld	s0,80(sp)
    1034:	64a6                	ld	s1,72(sp)
    1036:	6906                	ld	s2,64(sp)
    1038:	79e2                	ld	s3,56(sp)
    103a:	7a42                	ld	s4,48(sp)
    103c:	7aa2                	ld	s5,40(sp)
    103e:	7b02                	ld	s6,32(sp)
    1040:	6be2                	ld	s7,24(sp)
    1042:	6c42                	ld	s8,16(sp)
    1044:	6ca2                	ld	s9,8(sp)
    1046:	6d02                	ld	s10,0(sp)
    1048:	6125                	add	sp,sp,96
    104a:	8082                	ret

000000000000104c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    104c:	715d                	add	sp,sp,-80
    104e:	ec06                	sd	ra,24(sp)
    1050:	e822                	sd	s0,16(sp)
    1052:	1000                	add	s0,sp,32
    1054:	e010                	sd	a2,0(s0)
    1056:	e414                	sd	a3,8(s0)
    1058:	e818                	sd	a4,16(s0)
    105a:	ec1c                	sd	a5,24(s0)
    105c:	03043023          	sd	a6,32(s0)
    1060:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    1064:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    1068:	8622                	mv	a2,s0
    106a:	d3dff0ef          	jal	da6 <vprintf>
}
    106e:	60e2                	ld	ra,24(sp)
    1070:	6442                	ld	s0,16(sp)
    1072:	6161                	add	sp,sp,80
    1074:	8082                	ret

0000000000001076 <printf>:

void
printf(const char *fmt, ...)
{
    1076:	711d                	add	sp,sp,-96
    1078:	ec06                	sd	ra,24(sp)
    107a:	e822                	sd	s0,16(sp)
    107c:	1000                	add	s0,sp,32
    107e:	e40c                	sd	a1,8(s0)
    1080:	e810                	sd	a2,16(s0)
    1082:	ec14                	sd	a3,24(s0)
    1084:	f018                	sd	a4,32(s0)
    1086:	f41c                	sd	a5,40(s0)
    1088:	03043823          	sd	a6,48(s0)
    108c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    1090:	00840613          	add	a2,s0,8
    1094:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    1098:	85aa                	mv	a1,a0
    109a:	4505                	li	a0,1
    109c:	d0bff0ef          	jal	da6 <vprintf>
}
    10a0:	60e2                	ld	ra,24(sp)
    10a2:	6442                	ld	s0,16(sp)
    10a4:	6125                	add	sp,sp,96
    10a6:	8082                	ret

00000000000010a8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    10a8:	1141                	add	sp,sp,-16
    10aa:	e422                	sd	s0,8(sp)
    10ac:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    10ae:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    10b2:	00001797          	auipc	a5,0x1
    10b6:	f5e7b783          	ld	a5,-162(a5) # 2010 <freep>
    10ba:	a02d                	j	10e4 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    10bc:	4618                	lw	a4,8(a2)
    10be:	9f2d                	addw	a4,a4,a1
    10c0:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    10c4:	6398                	ld	a4,0(a5)
    10c6:	6310                	ld	a2,0(a4)
    10c8:	a83d                	j	1106 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    10ca:	ff852703          	lw	a4,-8(a0)
    10ce:	9f31                	addw	a4,a4,a2
    10d0:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    10d2:	ff053683          	ld	a3,-16(a0)
    10d6:	a091                	j	111a <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    10d8:	6398                	ld	a4,0(a5)
    10da:	00e7e463          	bltu	a5,a4,10e2 <free+0x3a>
    10de:	00e6ea63          	bltu	a3,a4,10f2 <free+0x4a>
{
    10e2:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    10e4:	fed7fae3          	bgeu	a5,a3,10d8 <free+0x30>
    10e8:	6398                	ld	a4,0(a5)
    10ea:	00e6e463          	bltu	a3,a4,10f2 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    10ee:	fee7eae3          	bltu	a5,a4,10e2 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
    10f2:	ff852583          	lw	a1,-8(a0)
    10f6:	6390                	ld	a2,0(a5)
    10f8:	02059813          	sll	a6,a1,0x20
    10fc:	01c85713          	srl	a4,a6,0x1c
    1100:	9736                	add	a4,a4,a3
    1102:	fae60de3          	beq	a2,a4,10bc <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
    1106:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    110a:	4790                	lw	a2,8(a5)
    110c:	02061593          	sll	a1,a2,0x20
    1110:	01c5d713          	srl	a4,a1,0x1c
    1114:	973e                	add	a4,a4,a5
    1116:	fae68ae3          	beq	a3,a4,10ca <free+0x22>
    p->s.ptr = bp->s.ptr;
    111a:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    111c:	00001717          	auipc	a4,0x1
    1120:	eef73a23          	sd	a5,-268(a4) # 2010 <freep>
}
    1124:	6422                	ld	s0,8(sp)
    1126:	0141                	add	sp,sp,16
    1128:	8082                	ret

000000000000112a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    112a:	7139                	add	sp,sp,-64
    112c:	fc06                	sd	ra,56(sp)
    112e:	f822                	sd	s0,48(sp)
    1130:	f426                	sd	s1,40(sp)
    1132:	f04a                	sd	s2,32(sp)
    1134:	ec4e                	sd	s3,24(sp)
    1136:	e852                	sd	s4,16(sp)
    1138:	e456                	sd	s5,8(sp)
    113a:	e05a                	sd	s6,0(sp)
    113c:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    113e:	02051493          	sll	s1,a0,0x20
    1142:	9081                	srl	s1,s1,0x20
    1144:	04bd                	add	s1,s1,15
    1146:	8091                	srl	s1,s1,0x4
    1148:	0014899b          	addw	s3,s1,1
    114c:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
    114e:	00001517          	auipc	a0,0x1
    1152:	ec253503          	ld	a0,-318(a0) # 2010 <freep>
    1156:	c515                	beqz	a0,1182 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1158:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    115a:	4798                	lw	a4,8(a5)
    115c:	02977f63          	bgeu	a4,s1,119a <malloc+0x70>
  if(nu < 4096)
    1160:	8a4e                	mv	s4,s3
    1162:	0009871b          	sext.w	a4,s3
    1166:	6685                	lui	a3,0x1
    1168:	00d77363          	bgeu	a4,a3,116e <malloc+0x44>
    116c:	6a05                	lui	s4,0x1
    116e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    1172:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    1176:	00001917          	auipc	s2,0x1
    117a:	e9a90913          	add	s2,s2,-358 # 2010 <freep>
  if(p == SBRK_ERROR)
    117e:	5afd                	li	s5,-1
    1180:	a885                	j	11f0 <malloc+0xc6>
    base.s.ptr = freep = prevp = &base;
    1182:	00001797          	auipc	a5,0x1
    1186:	f0678793          	add	a5,a5,-250 # 2088 <base>
    118a:	00001717          	auipc	a4,0x1
    118e:	e8f73323          	sd	a5,-378(a4) # 2010 <freep>
    1192:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    1194:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    1198:	b7e1                	j	1160 <malloc+0x36>
      if(p->s.size == nunits)
    119a:	02e48c63          	beq	s1,a4,11d2 <malloc+0xa8>
        p->s.size -= nunits;
    119e:	4137073b          	subw	a4,a4,s3
    11a2:	c798                	sw	a4,8(a5)
        p += p->s.size;
    11a4:	02071693          	sll	a3,a4,0x20
    11a8:	01c6d713          	srl	a4,a3,0x1c
    11ac:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    11ae:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    11b2:	00001717          	auipc	a4,0x1
    11b6:	e4a73f23          	sd	a0,-418(a4) # 2010 <freep>
      return (void*)(p + 1);
    11ba:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    11be:	70e2                	ld	ra,56(sp)
    11c0:	7442                	ld	s0,48(sp)
    11c2:	74a2                	ld	s1,40(sp)
    11c4:	7902                	ld	s2,32(sp)
    11c6:	69e2                	ld	s3,24(sp)
    11c8:	6a42                	ld	s4,16(sp)
    11ca:	6aa2                	ld	s5,8(sp)
    11cc:	6b02                	ld	s6,0(sp)
    11ce:	6121                	add	sp,sp,64
    11d0:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    11d2:	6398                	ld	a4,0(a5)
    11d4:	e118                	sd	a4,0(a0)
    11d6:	bff1                	j	11b2 <malloc+0x88>
  hp->s.size = nu;
    11d8:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    11dc:	0541                	add	a0,a0,16
    11de:	ecbff0ef          	jal	10a8 <free>
  return freep;
    11e2:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    11e6:	dd61                	beqz	a0,11be <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    11e8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    11ea:	4798                	lw	a4,8(a5)
    11ec:	fa9777e3          	bgeu	a4,s1,119a <malloc+0x70>
    if(p == freep)
    11f0:	00093703          	ld	a4,0(s2)
    11f4:	853e                	mv	a0,a5
    11f6:	fef719e3          	bne	a4,a5,11e8 <malloc+0xbe>
  p = sbrk(nu * sizeof(Header));
    11fa:	8552                	mv	a0,s4
    11fc:	a05ff0ef          	jal	c00 <sbrk>
  if(p == SBRK_ERROR)
    1200:	fd551ce3          	bne	a0,s5,11d8 <malloc+0xae>
        return 0;
    1204:	4501                	li	a0,0
    1206:	bf65                	j	11be <malloc+0x94>
