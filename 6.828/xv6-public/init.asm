
_init:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	53                   	push   %ebx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	83 ec 10             	sub    $0x10,%esp
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
   a:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  11:	00 
  12:	c7 04 24 f6 07 00 00 	movl   $0x7f6,(%esp)
  19:	e8 56 03 00 00       	call   374 <open>
  1e:	85 c0                	test   %eax,%eax
  20:	0f 88 ac 00 00 00    	js     d2 <main+0xd2>
    mknod("console", 1, 1);
    open("console", O_RDWR);
  }
  dup(0);  // stdout
  26:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  2d:	e8 7a 03 00 00       	call   3ac <dup>
  dup(0);  // stderr
  32:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  39:	e8 6e 03 00 00       	call   3ac <dup>
  3e:	66 90                	xchg   %ax,%ax

  for(;;){
    printf(1, "init: starting sh\n");
  40:	c7 44 24 04 fe 07 00 	movl   $0x7fe,0x4(%esp)
  47:	00 
  48:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  4f:	e8 3c 04 00 00       	call   490 <printf>
    pid = fork();
  54:	e8 d3 02 00 00       	call   32c <fork>
    if(pid < 0){
  59:	85 c0                	test   %eax,%eax
  dup(0);  // stdout
  dup(0);  // stderr

  for(;;){
    printf(1, "init: starting sh\n");
    pid = fork();
  5b:	89 c3                	mov    %eax,%ebx
    if(pid < 0){
  5d:	78 2d                	js     8c <main+0x8c>
  5f:	90                   	nop
      printf(1, "init: fork failed\n");
      exit();
    }
    if(pid == 0){
  60:	74 43                	je     a5 <main+0xa5>
  62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exec("sh", argv);
      printf(1, "init: exec sh failed\n");
      exit();
    }
    while((wpid=wait()) >= 0 && wpid != pid)
  68:	e8 cf 02 00 00       	call   33c <wait>
  6d:	85 c0                	test   %eax,%eax
  6f:	90                   	nop
  70:	78 ce                	js     40 <main+0x40>
  72:	39 d8                	cmp    %ebx,%eax
  74:	74 ca                	je     40 <main+0x40>
      printf(1, "zombie!\n");
  76:	c7 44 24 04 3d 08 00 	movl   $0x83d,0x4(%esp)
  7d:	00 
  7e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  85:	e8 06 04 00 00       	call   490 <printf>
  8a:	eb dc                	jmp    68 <main+0x68>

  for(;;){
    printf(1, "init: starting sh\n");
    pid = fork();
    if(pid < 0){
      printf(1, "init: fork failed\n");
  8c:	c7 44 24 04 11 08 00 	movl   $0x811,0x4(%esp)
  93:	00 
  94:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  9b:	e8 f0 03 00 00       	call   490 <printf>
      exit();
  a0:	e8 8f 02 00 00       	call   334 <exit>
    }
    if(pid == 0){
      exec("sh", argv);
  a5:	c7 44 24 04 c4 0a 00 	movl   $0xac4,0x4(%esp)
  ac:	00 
  ad:	c7 04 24 24 08 00 00 	movl   $0x824,(%esp)
  b4:	e8 b3 02 00 00       	call   36c <exec>
      printf(1, "init: exec sh failed\n");
  b9:	c7 44 24 04 27 08 00 	movl   $0x827,0x4(%esp)
  c0:	00 
  c1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  c8:	e8 c3 03 00 00       	call   490 <printf>
      exit();
  cd:	e8 62 02 00 00       	call   334 <exit>
main(void)
{
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
    mknod("console", 1, 1);
  d2:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  d9:	00 
  da:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  e1:	00 
  e2:	c7 04 24 f6 07 00 00 	movl   $0x7f6,(%esp)
  e9:	e8 8e 02 00 00       	call   37c <mknod>
    open("console", O_RDWR);
  ee:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  f5:	00 
  f6:	c7 04 24 f6 07 00 00 	movl   $0x7f6,(%esp)
  fd:	e8 72 02 00 00       	call   374 <open>
 102:	e9 1f ff ff ff       	jmp    26 <main+0x26>
 107:	90                   	nop
 108:	90                   	nop
 109:	90                   	nop
 10a:	90                   	nop
 10b:	90                   	nop
 10c:	90                   	nop
 10d:	90                   	nop
 10e:	90                   	nop
 10f:	90                   	nop

00000110 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 110:	55                   	push   %ebp
 111:	89 e5                	mov    %esp,%ebp
 113:	8b 45 08             	mov    0x8(%ebp),%eax
 116:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 119:	53                   	push   %ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 11a:	89 c2                	mov    %eax,%edx
 11c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 120:	83 c1 01             	add    $0x1,%ecx
 123:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 127:	83 c2 01             	add    $0x1,%edx
 12a:	84 db                	test   %bl,%bl
 12c:	88 5a ff             	mov    %bl,-0x1(%edx)
 12f:	75 ef                	jne    120 <strcpy+0x10>
    ;
  return os;
}
 131:	5b                   	pop    %ebx
 132:	5d                   	pop    %ebp
 133:	c3                   	ret    
 134:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 13a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000140 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 140:	55                   	push   %ebp
 141:	89 e5                	mov    %esp,%ebp
 143:	8b 55 08             	mov    0x8(%ebp),%edx
 146:	53                   	push   %ebx
 147:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 14a:	0f b6 02             	movzbl (%edx),%eax
 14d:	84 c0                	test   %al,%al
 14f:	74 2d                	je     17e <strcmp+0x3e>
 151:	0f b6 19             	movzbl (%ecx),%ebx
 154:	38 d8                	cmp    %bl,%al
 156:	74 0e                	je     166 <strcmp+0x26>
 158:	eb 2b                	jmp    185 <strcmp+0x45>
 15a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 160:	38 c8                	cmp    %cl,%al
 162:	75 15                	jne    179 <strcmp+0x39>
    p++, q++;
 164:	89 d9                	mov    %ebx,%ecx
 166:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 169:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 16c:	8d 59 01             	lea    0x1(%ecx),%ebx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 16f:	0f b6 49 01          	movzbl 0x1(%ecx),%ecx
 173:	84 c0                	test   %al,%al
 175:	75 e9                	jne    160 <strcmp+0x20>
 177:	31 c0                	xor    %eax,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
 179:	29 c8                	sub    %ecx,%eax
}
 17b:	5b                   	pop    %ebx
 17c:	5d                   	pop    %ebp
 17d:	c3                   	ret    
 17e:	0f b6 09             	movzbl (%ecx),%ecx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 181:	31 c0                	xor    %eax,%eax
 183:	eb f4                	jmp    179 <strcmp+0x39>
 185:	0f b6 cb             	movzbl %bl,%ecx
 188:	eb ef                	jmp    179 <strcmp+0x39>
 18a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000190 <strlen>:
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
 190:	55                   	push   %ebp
 191:	89 e5                	mov    %esp,%ebp
 193:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 196:	80 39 00             	cmpb   $0x0,(%ecx)
 199:	74 12                	je     1ad <strlen+0x1d>
 19b:	31 d2                	xor    %edx,%edx
 19d:	8d 76 00             	lea    0x0(%esi),%esi
 1a0:	83 c2 01             	add    $0x1,%edx
 1a3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 1a7:	89 d0                	mov    %edx,%eax
 1a9:	75 f5                	jne    1a0 <strlen+0x10>
    ;
  return n;
}
 1ab:	5d                   	pop    %ebp
 1ac:	c3                   	ret    
uint
strlen(char *s)
{
  int n;

  for(n = 0; s[n]; n++)
 1ad:	31 c0                	xor    %eax,%eax
    ;
  return n;
}
 1af:	5d                   	pop    %ebp
 1b0:	c3                   	ret    
 1b1:	eb 0d                	jmp    1c0 <memset>
 1b3:	90                   	nop
 1b4:	90                   	nop
 1b5:	90                   	nop
 1b6:	90                   	nop
 1b7:	90                   	nop
 1b8:	90                   	nop
 1b9:	90                   	nop
 1ba:	90                   	nop
 1bb:	90                   	nop
 1bc:	90                   	nop
 1bd:	90                   	nop
 1be:	90                   	nop
 1bf:	90                   	nop

000001c0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1c0:	55                   	push   %ebp
 1c1:	89 e5                	mov    %esp,%ebp
 1c3:	8b 55 08             	mov    0x8(%ebp),%edx
 1c6:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 1c7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 1ca:	8b 45 0c             	mov    0xc(%ebp),%eax
 1cd:	89 d7                	mov    %edx,%edi
 1cf:	fc                   	cld    
 1d0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 1d2:	89 d0                	mov    %edx,%eax
 1d4:	5f                   	pop    %edi
 1d5:	5d                   	pop    %ebp
 1d6:	c3                   	ret    
 1d7:	89 f6                	mov    %esi,%esi
 1d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000001e0 <strchr>:

char*
strchr(const char *s, char c)
{
 1e0:	55                   	push   %ebp
 1e1:	89 e5                	mov    %esp,%ebp
 1e3:	8b 45 08             	mov    0x8(%ebp),%eax
 1e6:	53                   	push   %ebx
 1e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  for(; *s; s++)
 1ea:	0f b6 18             	movzbl (%eax),%ebx
 1ed:	84 db                	test   %bl,%bl
 1ef:	74 1d                	je     20e <strchr+0x2e>
    if(*s == c)
 1f1:	38 d3                	cmp    %dl,%bl
 1f3:	89 d1                	mov    %edx,%ecx
 1f5:	75 0d                	jne    204 <strchr+0x24>
 1f7:	eb 17                	jmp    210 <strchr+0x30>
 1f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 200:	38 ca                	cmp    %cl,%dl
 202:	74 0c                	je     210 <strchr+0x30>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 204:	83 c0 01             	add    $0x1,%eax
 207:	0f b6 10             	movzbl (%eax),%edx
 20a:	84 d2                	test   %dl,%dl
 20c:	75 f2                	jne    200 <strchr+0x20>
    if(*s == c)
      return (char*)s;
  return 0;
 20e:	31 c0                	xor    %eax,%eax
}
 210:	5b                   	pop    %ebx
 211:	5d                   	pop    %ebp
 212:	c3                   	ret    
 213:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 219:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000220 <gets>:

char*
gets(char *buf, int max)
{
 220:	55                   	push   %ebp
 221:	89 e5                	mov    %esp,%ebp
 223:	57                   	push   %edi
 224:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 225:	31 f6                	xor    %esi,%esi
  return 0;
}

char*
gets(char *buf, int max)
{
 227:	53                   	push   %ebx
 228:	83 ec 2c             	sub    $0x2c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 22b:	8d 7d e7             	lea    -0x19(%ebp),%edi
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 22e:	eb 31                	jmp    261 <gets+0x41>
    cc = read(0, &c, 1);
 230:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 237:	00 
 238:	89 7c 24 04          	mov    %edi,0x4(%esp)
 23c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 243:	e8 04 01 00 00       	call   34c <read>
    if(cc < 1)
 248:	85 c0                	test   %eax,%eax
 24a:	7e 1d                	jle    269 <gets+0x49>
      break;
    buf[i++] = c;
 24c:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 250:	89 de                	mov    %ebx,%esi
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
 252:	8b 55 08             	mov    0x8(%ebp),%edx
    if(c == '\n' || c == '\r')
 255:	3c 0d                	cmp    $0xd,%al

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
 257:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 25b:	74 0c                	je     269 <gets+0x49>
 25d:	3c 0a                	cmp    $0xa,%al
 25f:	74 08                	je     269 <gets+0x49>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 261:	8d 5e 01             	lea    0x1(%esi),%ebx
 264:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 267:	7c c7                	jl     230 <gets+0x10>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 269:	8b 45 08             	mov    0x8(%ebp),%eax
 26c:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 270:	83 c4 2c             	add    $0x2c,%esp
 273:	5b                   	pop    %ebx
 274:	5e                   	pop    %esi
 275:	5f                   	pop    %edi
 276:	5d                   	pop    %ebp
 277:	c3                   	ret    
 278:	90                   	nop
 279:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000280 <stat>:

int
stat(char *n, struct stat *st)
{
 280:	55                   	push   %ebp
 281:	89 e5                	mov    %esp,%ebp
 283:	56                   	push   %esi
 284:	53                   	push   %ebx
 285:	83 ec 10             	sub    $0x10,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 288:	8b 45 08             	mov    0x8(%ebp),%eax
 28b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 292:	00 
 293:	89 04 24             	mov    %eax,(%esp)
 296:	e8 d9 00 00 00       	call   374 <open>
  if(fd < 0)
 29b:	85 c0                	test   %eax,%eax
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 29d:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
 29f:	78 27                	js     2c8 <stat+0x48>
    return -1;
  r = fstat(fd, st);
 2a1:	8b 45 0c             	mov    0xc(%ebp),%eax
 2a4:	89 1c 24             	mov    %ebx,(%esp)
 2a7:	89 44 24 04          	mov    %eax,0x4(%esp)
 2ab:	e8 dc 00 00 00       	call   38c <fstat>
  close(fd);
 2b0:	89 1c 24             	mov    %ebx,(%esp)
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
 2b3:	89 c6                	mov    %eax,%esi
  close(fd);
 2b5:	e8 a2 00 00 00       	call   35c <close>
  return r;
 2ba:	89 f0                	mov    %esi,%eax
}
 2bc:	83 c4 10             	add    $0x10,%esp
 2bf:	5b                   	pop    %ebx
 2c0:	5e                   	pop    %esi
 2c1:	5d                   	pop    %ebp
 2c2:	c3                   	ret    
 2c3:	90                   	nop
 2c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
 2c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2cd:	eb ed                	jmp    2bc <stat+0x3c>
 2cf:	90                   	nop

000002d0 <atoi>:
  return r;
}

int
atoi(const char *s)
{
 2d0:	55                   	push   %ebp
 2d1:	89 e5                	mov    %esp,%ebp
 2d3:	8b 4d 08             	mov    0x8(%ebp),%ecx
 2d6:	53                   	push   %ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2d7:	0f be 11             	movsbl (%ecx),%edx
 2da:	8d 42 d0             	lea    -0x30(%edx),%eax
 2dd:	3c 09                	cmp    $0x9,%al
int
atoi(const char *s)
{
  int n;

  n = 0;
 2df:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 2e4:	77 17                	ja     2fd <atoi+0x2d>
 2e6:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 2e8:	83 c1 01             	add    $0x1,%ecx
 2eb:	8d 04 80             	lea    (%eax,%eax,4),%eax
 2ee:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2f2:	0f be 11             	movsbl (%ecx),%edx
 2f5:	8d 5a d0             	lea    -0x30(%edx),%ebx
 2f8:	80 fb 09             	cmp    $0x9,%bl
 2fb:	76 eb                	jbe    2e8 <atoi+0x18>
    n = n*10 + *s++ - '0';
  return n;
}
 2fd:	5b                   	pop    %ebx
 2fe:	5d                   	pop    %ebp
 2ff:	c3                   	ret    

00000300 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 300:	55                   	push   %ebp
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 301:	31 d2                	xor    %edx,%edx
  return n;
}

void*
memmove(void *vdst, void *vsrc, int n)
{
 303:	89 e5                	mov    %esp,%ebp
 305:	56                   	push   %esi
 306:	8b 45 08             	mov    0x8(%ebp),%eax
 309:	53                   	push   %ebx
 30a:	8b 5d 10             	mov    0x10(%ebp),%ebx
 30d:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 310:	85 db                	test   %ebx,%ebx
 312:	7e 12                	jle    326 <memmove+0x26>
 314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 318:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 31c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 31f:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 322:	39 da                	cmp    %ebx,%edx
 324:	75 f2                	jne    318 <memmove+0x18>
    *dst++ = *src++;
  return vdst;
}
 326:	5b                   	pop    %ebx
 327:	5e                   	pop    %esi
 328:	5d                   	pop    %ebp
 329:	c3                   	ret    
 32a:	90                   	nop
 32b:	90                   	nop

0000032c <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 32c:	b8 01 00 00 00       	mov    $0x1,%eax
 331:	cd 40                	int    $0x40
 333:	c3                   	ret    

00000334 <exit>:
SYSCALL(exit)
 334:	b8 02 00 00 00       	mov    $0x2,%eax
 339:	cd 40                	int    $0x40
 33b:	c3                   	ret    

0000033c <wait>:
SYSCALL(wait)
 33c:	b8 03 00 00 00       	mov    $0x3,%eax
 341:	cd 40                	int    $0x40
 343:	c3                   	ret    

00000344 <pipe>:
SYSCALL(pipe)
 344:	b8 04 00 00 00       	mov    $0x4,%eax
 349:	cd 40                	int    $0x40
 34b:	c3                   	ret    

0000034c <read>:
SYSCALL(read)
 34c:	b8 05 00 00 00       	mov    $0x5,%eax
 351:	cd 40                	int    $0x40
 353:	c3                   	ret    

00000354 <write>:
SYSCALL(write)
 354:	b8 10 00 00 00       	mov    $0x10,%eax
 359:	cd 40                	int    $0x40
 35b:	c3                   	ret    

0000035c <close>:
SYSCALL(close)
 35c:	b8 15 00 00 00       	mov    $0x15,%eax
 361:	cd 40                	int    $0x40
 363:	c3                   	ret    

00000364 <kill>:
SYSCALL(kill)
 364:	b8 06 00 00 00       	mov    $0x6,%eax
 369:	cd 40                	int    $0x40
 36b:	c3                   	ret    

0000036c <exec>:
SYSCALL(exec)
 36c:	b8 07 00 00 00       	mov    $0x7,%eax
 371:	cd 40                	int    $0x40
 373:	c3                   	ret    

00000374 <open>:
SYSCALL(open)
 374:	b8 0f 00 00 00       	mov    $0xf,%eax
 379:	cd 40                	int    $0x40
 37b:	c3                   	ret    

0000037c <mknod>:
SYSCALL(mknod)
 37c:	b8 11 00 00 00       	mov    $0x11,%eax
 381:	cd 40                	int    $0x40
 383:	c3                   	ret    

00000384 <unlink>:
SYSCALL(unlink)
 384:	b8 12 00 00 00       	mov    $0x12,%eax
 389:	cd 40                	int    $0x40
 38b:	c3                   	ret    

0000038c <fstat>:
SYSCALL(fstat)
 38c:	b8 08 00 00 00       	mov    $0x8,%eax
 391:	cd 40                	int    $0x40
 393:	c3                   	ret    

00000394 <link>:
SYSCALL(link)
 394:	b8 13 00 00 00       	mov    $0x13,%eax
 399:	cd 40                	int    $0x40
 39b:	c3                   	ret    

0000039c <mkdir>:
SYSCALL(mkdir)
 39c:	b8 14 00 00 00       	mov    $0x14,%eax
 3a1:	cd 40                	int    $0x40
 3a3:	c3                   	ret    

000003a4 <chdir>:
SYSCALL(chdir)
 3a4:	b8 09 00 00 00       	mov    $0x9,%eax
 3a9:	cd 40                	int    $0x40
 3ab:	c3                   	ret    

000003ac <dup>:
SYSCALL(dup)
 3ac:	b8 0a 00 00 00       	mov    $0xa,%eax
 3b1:	cd 40                	int    $0x40
 3b3:	c3                   	ret    

000003b4 <getpid>:
SYSCALL(getpid)
 3b4:	b8 0b 00 00 00       	mov    $0xb,%eax
 3b9:	cd 40                	int    $0x40
 3bb:	c3                   	ret    

000003bc <sbrk>:
SYSCALL(sbrk)
 3bc:	b8 0c 00 00 00       	mov    $0xc,%eax
 3c1:	cd 40                	int    $0x40
 3c3:	c3                   	ret    

000003c4 <sleep>:
SYSCALL(sleep)
 3c4:	b8 0d 00 00 00       	mov    $0xd,%eax
 3c9:	cd 40                	int    $0x40
 3cb:	c3                   	ret    

000003cc <uptime>:
SYSCALL(uptime)
 3cc:	b8 0e 00 00 00       	mov    $0xe,%eax
 3d1:	cd 40                	int    $0x40
 3d3:	c3                   	ret    

000003d4 <date>:
SYSCALL(date)
 3d4:	b8 16 00 00 00       	mov    $0x16,%eax
 3d9:	cd 40                	int    $0x40
 3db:	c3                   	ret    

000003dc <dup2>:
SYSCALL(dup2)
 3dc:	b8 17 00 00 00       	mov    $0x17,%eax
 3e1:	cd 40                	int    $0x40
 3e3:	c3                   	ret    

000003e4 <alarm>:
SYSCALL(alarm)
 3e4:	b8 18 00 00 00       	mov    $0x18,%eax
 3e9:	cd 40                	int    $0x40
 3eb:	c3                   	ret    
 3ec:	90                   	nop
 3ed:	90                   	nop
 3ee:	90                   	nop
 3ef:	90                   	nop

000003f0 <printint>:
 3f0:	55                   	push   %ebp
 3f1:	89 e5                	mov    %esp,%ebp
 3f3:	57                   	push   %edi
 3f4:	56                   	push   %esi
 3f5:	89 c6                	mov    %eax,%esi
 3f7:	53                   	push   %ebx
 3f8:	83 ec 4c             	sub    $0x4c,%esp
 3fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
 3fe:	85 db                	test   %ebx,%ebx
 400:	74 09                	je     40b <printint+0x1b>
 402:	89 d0                	mov    %edx,%eax
 404:	c1 e8 1f             	shr    $0x1f,%eax
 407:	84 c0                	test   %al,%al
 409:	75 75                	jne    480 <printint+0x90>
 40b:	89 d0                	mov    %edx,%eax
 40d:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 414:	89 75 c0             	mov    %esi,-0x40(%ebp)
 417:	31 ff                	xor    %edi,%edi
 419:	89 ce                	mov    %ecx,%esi
 41b:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 41e:	eb 02                	jmp    422 <printint+0x32>
 420:	89 cf                	mov    %ecx,%edi
 422:	31 d2                	xor    %edx,%edx
 424:	f7 f6                	div    %esi
 426:	8d 4f 01             	lea    0x1(%edi),%ecx
 429:	0f b6 92 4d 08 00 00 	movzbl 0x84d(%edx),%edx
 430:	85 c0                	test   %eax,%eax
 432:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
 435:	75 e9                	jne    420 <printint+0x30>
 437:	8b 55 c4             	mov    -0x3c(%ebp),%edx
 43a:	89 c8                	mov    %ecx,%eax
 43c:	8b 75 c0             	mov    -0x40(%ebp),%esi
 43f:	85 d2                	test   %edx,%edx
 441:	74 08                	je     44b <printint+0x5b>
 443:	8d 4f 02             	lea    0x2(%edi),%ecx
 446:	c6 44 05 d8 2d       	movb   $0x2d,-0x28(%ebp,%eax,1)
 44b:	8d 79 ff             	lea    -0x1(%ecx),%edi
 44e:	66 90                	xchg   %ax,%ax
 450:	0f b6 44 3d d8       	movzbl -0x28(%ebp,%edi,1),%eax
 455:	83 ef 01             	sub    $0x1,%edi
 458:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 45f:	00 
 460:	89 5c 24 04          	mov    %ebx,0x4(%esp)
 464:	89 34 24             	mov    %esi,(%esp)
 467:	88 45 d7             	mov    %al,-0x29(%ebp)
 46a:	e8 e5 fe ff ff       	call   354 <write>
 46f:	83 ff ff             	cmp    $0xffffffff,%edi
 472:	75 dc                	jne    450 <printint+0x60>
 474:	83 c4 4c             	add    $0x4c,%esp
 477:	5b                   	pop    %ebx
 478:	5e                   	pop    %esi
 479:	5f                   	pop    %edi
 47a:	5d                   	pop    %ebp
 47b:	c3                   	ret    
 47c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 480:	89 d0                	mov    %edx,%eax
 482:	f7 d8                	neg    %eax
 484:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
 48b:	eb 87                	jmp    414 <printint+0x24>
 48d:	8d 76 00             	lea    0x0(%esi),%esi

00000490 <printf>:
 490:	55                   	push   %ebp
 491:	89 e5                	mov    %esp,%ebp
 493:	57                   	push   %edi
 494:	31 ff                	xor    %edi,%edi
 496:	56                   	push   %esi
 497:	53                   	push   %ebx
 498:	83 ec 3c             	sub    $0x3c,%esp
 49b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 49e:	8d 45 10             	lea    0x10(%ebp),%eax
 4a1:	8b 75 08             	mov    0x8(%ebp),%esi
 4a4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 4a7:	0f b6 13             	movzbl (%ebx),%edx
 4aa:	83 c3 01             	add    $0x1,%ebx
 4ad:	84 d2                	test   %dl,%dl
 4af:	75 39                	jne    4ea <printf+0x5a>
 4b1:	e9 c2 00 00 00       	jmp    578 <printf+0xe8>
 4b6:	66 90                	xchg   %ax,%ax
 4b8:	83 fa 25             	cmp    $0x25,%edx
 4bb:	0f 84 bf 00 00 00    	je     580 <printf+0xf0>
 4c1:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 4c4:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4cb:	00 
 4cc:	89 44 24 04          	mov    %eax,0x4(%esp)
 4d0:	89 34 24             	mov    %esi,(%esp)
 4d3:	88 55 e2             	mov    %dl,-0x1e(%ebp)
 4d6:	e8 79 fe ff ff       	call   354 <write>
 4db:	83 c3 01             	add    $0x1,%ebx
 4de:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
 4e2:	84 d2                	test   %dl,%dl
 4e4:	0f 84 8e 00 00 00    	je     578 <printf+0xe8>
 4ea:	85 ff                	test   %edi,%edi
 4ec:	0f be c2             	movsbl %dl,%eax
 4ef:	74 c7                	je     4b8 <printf+0x28>
 4f1:	83 ff 25             	cmp    $0x25,%edi
 4f4:	75 e5                	jne    4db <printf+0x4b>
 4f6:	83 fa 64             	cmp    $0x64,%edx
 4f9:	0f 84 31 01 00 00    	je     630 <printf+0x1a0>
 4ff:	25 f7 00 00 00       	and    $0xf7,%eax
 504:	83 f8 70             	cmp    $0x70,%eax
 507:	0f 84 83 00 00 00    	je     590 <printf+0x100>
 50d:	83 fa 73             	cmp    $0x73,%edx
 510:	0f 84 a2 00 00 00    	je     5b8 <printf+0x128>
 516:	83 fa 63             	cmp    $0x63,%edx
 519:	0f 84 35 01 00 00    	je     654 <printf+0x1c4>
 51f:	83 fa 25             	cmp    $0x25,%edx
 522:	0f 84 e0 00 00 00    	je     608 <printf+0x178>
 528:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 52b:	83 c3 01             	add    $0x1,%ebx
 52e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 535:	00 
 536:	31 ff                	xor    %edi,%edi
 538:	89 44 24 04          	mov    %eax,0x4(%esp)
 53c:	89 34 24             	mov    %esi,(%esp)
 53f:	89 55 d0             	mov    %edx,-0x30(%ebp)
 542:	c6 45 e6 25          	movb   $0x25,-0x1a(%ebp)
 546:	e8 09 fe ff ff       	call   354 <write>
 54b:	8b 55 d0             	mov    -0x30(%ebp),%edx
 54e:	8d 45 e7             	lea    -0x19(%ebp),%eax
 551:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 558:	00 
 559:	89 44 24 04          	mov    %eax,0x4(%esp)
 55d:	89 34 24             	mov    %esi,(%esp)
 560:	88 55 e7             	mov    %dl,-0x19(%ebp)
 563:	e8 ec fd ff ff       	call   354 <write>
 568:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
 56c:	84 d2                	test   %dl,%dl
 56e:	0f 85 76 ff ff ff    	jne    4ea <printf+0x5a>
 574:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 578:	83 c4 3c             	add    $0x3c,%esp
 57b:	5b                   	pop    %ebx
 57c:	5e                   	pop    %esi
 57d:	5f                   	pop    %edi
 57e:	5d                   	pop    %ebp
 57f:	c3                   	ret    
 580:	bf 25 00 00 00       	mov    $0x25,%edi
 585:	e9 51 ff ff ff       	jmp    4db <printf+0x4b>
 58a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 590:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 593:	b9 10 00 00 00       	mov    $0x10,%ecx
 598:	31 ff                	xor    %edi,%edi
 59a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 5a1:	8b 10                	mov    (%eax),%edx
 5a3:	89 f0                	mov    %esi,%eax
 5a5:	e8 46 fe ff ff       	call   3f0 <printint>
 5aa:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 5ae:	e9 28 ff ff ff       	jmp    4db <printf+0x4b>
 5b3:	90                   	nop
 5b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 5b8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 5bb:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 5bf:	8b 38                	mov    (%eax),%edi
 5c1:	b8 46 08 00 00       	mov    $0x846,%eax
 5c6:	85 ff                	test   %edi,%edi
 5c8:	0f 44 f8             	cmove  %eax,%edi
 5cb:	0f b6 07             	movzbl (%edi),%eax
 5ce:	84 c0                	test   %al,%al
 5d0:	74 2a                	je     5fc <printf+0x16c>
 5d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 5d8:	88 45 e3             	mov    %al,-0x1d(%ebp)
 5db:	8d 45 e3             	lea    -0x1d(%ebp),%eax
 5de:	83 c7 01             	add    $0x1,%edi
 5e1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 5e8:	00 
 5e9:	89 44 24 04          	mov    %eax,0x4(%esp)
 5ed:	89 34 24             	mov    %esi,(%esp)
 5f0:	e8 5f fd ff ff       	call   354 <write>
 5f5:	0f b6 07             	movzbl (%edi),%eax
 5f8:	84 c0                	test   %al,%al
 5fa:	75 dc                	jne    5d8 <printf+0x148>
 5fc:	31 ff                	xor    %edi,%edi
 5fe:	e9 d8 fe ff ff       	jmp    4db <printf+0x4b>
 603:	90                   	nop
 604:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 608:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 60b:	31 ff                	xor    %edi,%edi
 60d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 614:	00 
 615:	89 44 24 04          	mov    %eax,0x4(%esp)
 619:	89 34 24             	mov    %esi,(%esp)
 61c:	c6 45 e5 25          	movb   $0x25,-0x1b(%ebp)
 620:	e8 2f fd ff ff       	call   354 <write>
 625:	e9 b1 fe ff ff       	jmp    4db <printf+0x4b>
 62a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 630:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 633:	b9 0a 00 00 00       	mov    $0xa,%ecx
 638:	66 31 ff             	xor    %di,%di
 63b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 642:	8b 10                	mov    (%eax),%edx
 644:	89 f0                	mov    %esi,%eax
 646:	e8 a5 fd ff ff       	call   3f0 <printint>
 64b:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 64f:	e9 87 fe ff ff       	jmp    4db <printf+0x4b>
 654:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 657:	31 ff                	xor    %edi,%edi
 659:	8b 00                	mov    (%eax),%eax
 65b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 662:	00 
 663:	89 34 24             	mov    %esi,(%esp)
 666:	88 45 e4             	mov    %al,-0x1c(%ebp)
 669:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 66c:	89 44 24 04          	mov    %eax,0x4(%esp)
 670:	e8 df fc ff ff       	call   354 <write>
 675:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 679:	e9 5d fe ff ff       	jmp    4db <printf+0x4b>
 67e:	90                   	nop
 67f:	90                   	nop

00000680 <free>:
 680:	55                   	push   %ebp
 681:	a1 cc 0a 00 00       	mov    0xacc,%eax
 686:	89 e5                	mov    %esp,%ebp
 688:	57                   	push   %edi
 689:	56                   	push   %esi
 68a:	53                   	push   %ebx
 68b:	8b 5d 08             	mov    0x8(%ebp),%ebx
 68e:	8b 08                	mov    (%eax),%ecx
 690:	8d 53 f8             	lea    -0x8(%ebx),%edx
 693:	39 d0                	cmp    %edx,%eax
 695:	72 11                	jb     6a8 <free+0x28>
 697:	90                   	nop
 698:	39 c8                	cmp    %ecx,%eax
 69a:	72 04                	jb     6a0 <free+0x20>
 69c:	39 ca                	cmp    %ecx,%edx
 69e:	72 10                	jb     6b0 <free+0x30>
 6a0:	89 c8                	mov    %ecx,%eax
 6a2:	39 d0                	cmp    %edx,%eax
 6a4:	8b 08                	mov    (%eax),%ecx
 6a6:	73 f0                	jae    698 <free+0x18>
 6a8:	39 ca                	cmp    %ecx,%edx
 6aa:	72 04                	jb     6b0 <free+0x30>
 6ac:	39 c8                	cmp    %ecx,%eax
 6ae:	72 f0                	jb     6a0 <free+0x20>
 6b0:	8b 73 fc             	mov    -0x4(%ebx),%esi
 6b3:	8d 3c f2             	lea    (%edx,%esi,8),%edi
 6b6:	39 cf                	cmp    %ecx,%edi
 6b8:	74 1e                	je     6d8 <free+0x58>
 6ba:	89 4b f8             	mov    %ecx,-0x8(%ebx)
 6bd:	8b 48 04             	mov    0x4(%eax),%ecx
 6c0:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
 6c3:	39 f2                	cmp    %esi,%edx
 6c5:	74 28                	je     6ef <free+0x6f>
 6c7:	89 10                	mov    %edx,(%eax)
 6c9:	a3 cc 0a 00 00       	mov    %eax,0xacc
 6ce:	5b                   	pop    %ebx
 6cf:	5e                   	pop    %esi
 6d0:	5f                   	pop    %edi
 6d1:	5d                   	pop    %ebp
 6d2:	c3                   	ret    
 6d3:	90                   	nop
 6d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 6d8:	03 71 04             	add    0x4(%ecx),%esi
 6db:	89 73 fc             	mov    %esi,-0x4(%ebx)
 6de:	8b 08                	mov    (%eax),%ecx
 6e0:	8b 09                	mov    (%ecx),%ecx
 6e2:	89 4b f8             	mov    %ecx,-0x8(%ebx)
 6e5:	8b 48 04             	mov    0x4(%eax),%ecx
 6e8:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
 6eb:	39 f2                	cmp    %esi,%edx
 6ed:	75 d8                	jne    6c7 <free+0x47>
 6ef:	03 4b fc             	add    -0x4(%ebx),%ecx
 6f2:	a3 cc 0a 00 00       	mov    %eax,0xacc
 6f7:	89 48 04             	mov    %ecx,0x4(%eax)
 6fa:	8b 53 f8             	mov    -0x8(%ebx),%edx
 6fd:	89 10                	mov    %edx,(%eax)
 6ff:	5b                   	pop    %ebx
 700:	5e                   	pop    %esi
 701:	5f                   	pop    %edi
 702:	5d                   	pop    %ebp
 703:	c3                   	ret    
 704:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 70a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000710 <malloc>:
 710:	55                   	push   %ebp
 711:	89 e5                	mov    %esp,%ebp
 713:	57                   	push   %edi
 714:	56                   	push   %esi
 715:	53                   	push   %ebx
 716:	83 ec 1c             	sub    $0x1c,%esp
 719:	8b 45 08             	mov    0x8(%ebp),%eax
 71c:	8b 1d cc 0a 00 00    	mov    0xacc,%ebx
 722:	8d 48 07             	lea    0x7(%eax),%ecx
 725:	c1 e9 03             	shr    $0x3,%ecx
 728:	85 db                	test   %ebx,%ebx
 72a:	8d 71 01             	lea    0x1(%ecx),%esi
 72d:	0f 84 9b 00 00 00    	je     7ce <malloc+0xbe>
 733:	8b 13                	mov    (%ebx),%edx
 735:	8b 7a 04             	mov    0x4(%edx),%edi
 738:	39 fe                	cmp    %edi,%esi
 73a:	76 64                	jbe    7a0 <malloc+0x90>
 73c:	8d 04 f5 00 00 00 00 	lea    0x0(,%esi,8),%eax
 743:	bb 00 80 00 00       	mov    $0x8000,%ebx
 748:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 74b:	eb 0e                	jmp    75b <malloc+0x4b>
 74d:	8d 76 00             	lea    0x0(%esi),%esi
 750:	8b 02                	mov    (%edx),%eax
 752:	8b 78 04             	mov    0x4(%eax),%edi
 755:	39 fe                	cmp    %edi,%esi
 757:	76 4f                	jbe    7a8 <malloc+0x98>
 759:	89 c2                	mov    %eax,%edx
 75b:	3b 15 cc 0a 00 00    	cmp    0xacc,%edx
 761:	75 ed                	jne    750 <malloc+0x40>
 763:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 766:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 76c:	bf 00 10 00 00       	mov    $0x1000,%edi
 771:	0f 43 fe             	cmovae %esi,%edi
 774:	0f 42 c3             	cmovb  %ebx,%eax
 777:	89 04 24             	mov    %eax,(%esp)
 77a:	e8 3d fc ff ff       	call   3bc <sbrk>
 77f:	83 f8 ff             	cmp    $0xffffffff,%eax
 782:	74 18                	je     79c <malloc+0x8c>
 784:	89 78 04             	mov    %edi,0x4(%eax)
 787:	83 c0 08             	add    $0x8,%eax
 78a:	89 04 24             	mov    %eax,(%esp)
 78d:	e8 ee fe ff ff       	call   680 <free>
 792:	8b 15 cc 0a 00 00    	mov    0xacc,%edx
 798:	85 d2                	test   %edx,%edx
 79a:	75 b4                	jne    750 <malloc+0x40>
 79c:	31 c0                	xor    %eax,%eax
 79e:	eb 20                	jmp    7c0 <malloc+0xb0>
 7a0:	89 d0                	mov    %edx,%eax
 7a2:	89 da                	mov    %ebx,%edx
 7a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 7a8:	39 fe                	cmp    %edi,%esi
 7aa:	74 1c                	je     7c8 <malloc+0xb8>
 7ac:	29 f7                	sub    %esi,%edi
 7ae:	89 78 04             	mov    %edi,0x4(%eax)
 7b1:	8d 04 f8             	lea    (%eax,%edi,8),%eax
 7b4:	89 70 04             	mov    %esi,0x4(%eax)
 7b7:	89 15 cc 0a 00 00    	mov    %edx,0xacc
 7bd:	83 c0 08             	add    $0x8,%eax
 7c0:	83 c4 1c             	add    $0x1c,%esp
 7c3:	5b                   	pop    %ebx
 7c4:	5e                   	pop    %esi
 7c5:	5f                   	pop    %edi
 7c6:	5d                   	pop    %ebp
 7c7:	c3                   	ret    
 7c8:	8b 08                	mov    (%eax),%ecx
 7ca:	89 0a                	mov    %ecx,(%edx)
 7cc:	eb e9                	jmp    7b7 <malloc+0xa7>
 7ce:	c7 05 cc 0a 00 00 d0 	movl   $0xad0,0xacc
 7d5:	0a 00 00 
 7d8:	ba d0 0a 00 00       	mov    $0xad0,%edx
 7dd:	c7 05 d0 0a 00 00 d0 	movl   $0xad0,0xad0
 7e4:	0a 00 00 
 7e7:	c7 05 d4 0a 00 00 00 	movl   $0x0,0xad4
 7ee:	00 00 00 
 7f1:	e9 46 ff ff ff       	jmp    73c <malloc+0x2c>
