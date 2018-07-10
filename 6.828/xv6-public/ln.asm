
_ln:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	53                   	push   %ebx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	83 ec 10             	sub    $0x10,%esp
   a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  if(argc != 3){
   d:	83 7d 08 03          	cmpl   $0x3,0x8(%ebp)
  11:	74 19                	je     2c <main+0x2c>
    printf(2, "Usage: ln old new\n");
  13:	c7 44 24 04 56 07 00 	movl   $0x756,0x4(%esp)
  1a:	00 
  1b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  22:	e8 c9 03 00 00       	call   3f0 <printf>
    exit();
  27:	e8 68 02 00 00       	call   294 <exit>
  }
  if(link(argv[1], argv[2]) < 0)
  2c:	8b 43 08             	mov    0x8(%ebx),%eax
  2f:	89 44 24 04          	mov    %eax,0x4(%esp)
  33:	8b 43 04             	mov    0x4(%ebx),%eax
  36:	89 04 24             	mov    %eax,(%esp)
  39:	e8 b6 02 00 00       	call   2f4 <link>
  3e:	85 c0                	test   %eax,%eax
  40:	78 05                	js     47 <main+0x47>
    printf(2, "link %s %s: failed\n", argv[1], argv[2]);
  exit();
  42:	e8 4d 02 00 00       	call   294 <exit>
  if(argc != 3){
    printf(2, "Usage: ln old new\n");
    exit();
  }
  if(link(argv[1], argv[2]) < 0)
    printf(2, "link %s %s: failed\n", argv[1], argv[2]);
  47:	8b 43 08             	mov    0x8(%ebx),%eax
  4a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  4e:	8b 43 04             	mov    0x4(%ebx),%eax
  51:	c7 44 24 04 69 07 00 	movl   $0x769,0x4(%esp)
  58:	00 
  59:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  60:	89 44 24 08          	mov    %eax,0x8(%esp)
  64:	e8 87 03 00 00       	call   3f0 <printf>
  69:	eb d7                	jmp    42 <main+0x42>
  6b:	90                   	nop
  6c:	90                   	nop
  6d:	90                   	nop
  6e:	90                   	nop
  6f:	90                   	nop

00000070 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  70:	55                   	push   %ebp
  71:	89 e5                	mov    %esp,%ebp
  73:	8b 45 08             	mov    0x8(%ebp),%eax
  76:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  79:	53                   	push   %ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  7a:	89 c2                	mov    %eax,%edx
  7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  80:	83 c1 01             	add    $0x1,%ecx
  83:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  87:	83 c2 01             	add    $0x1,%edx
  8a:	84 db                	test   %bl,%bl
  8c:	88 5a ff             	mov    %bl,-0x1(%edx)
  8f:	75 ef                	jne    80 <strcpy+0x10>
    ;
  return os;
}
  91:	5b                   	pop    %ebx
  92:	5d                   	pop    %ebp
  93:	c3                   	ret    
  94:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  9a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000000a0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  a0:	55                   	push   %ebp
  a1:	89 e5                	mov    %esp,%ebp
  a3:	8b 55 08             	mov    0x8(%ebp),%edx
  a6:	53                   	push   %ebx
  a7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
  aa:	0f b6 02             	movzbl (%edx),%eax
  ad:	84 c0                	test   %al,%al
  af:	74 2d                	je     de <strcmp+0x3e>
  b1:	0f b6 19             	movzbl (%ecx),%ebx
  b4:	38 d8                	cmp    %bl,%al
  b6:	74 0e                	je     c6 <strcmp+0x26>
  b8:	eb 2b                	jmp    e5 <strcmp+0x45>
  ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  c0:	38 c8                	cmp    %cl,%al
  c2:	75 15                	jne    d9 <strcmp+0x39>
    p++, q++;
  c4:	89 d9                	mov    %ebx,%ecx
  c6:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  c9:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
  cc:	8d 59 01             	lea    0x1(%ecx),%ebx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  cf:	0f b6 49 01          	movzbl 0x1(%ecx),%ecx
  d3:	84 c0                	test   %al,%al
  d5:	75 e9                	jne    c0 <strcmp+0x20>
  d7:	31 c0                	xor    %eax,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
  d9:	29 c8                	sub    %ecx,%eax
}
  db:	5b                   	pop    %ebx
  dc:	5d                   	pop    %ebp
  dd:	c3                   	ret    
  de:	0f b6 09             	movzbl (%ecx),%ecx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  e1:	31 c0                	xor    %eax,%eax
  e3:	eb f4                	jmp    d9 <strcmp+0x39>
  e5:	0f b6 cb             	movzbl %bl,%ecx
  e8:	eb ef                	jmp    d9 <strcmp+0x39>
  ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000000f0 <strlen>:
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
  f0:	55                   	push   %ebp
  f1:	89 e5                	mov    %esp,%ebp
  f3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  f6:	80 39 00             	cmpb   $0x0,(%ecx)
  f9:	74 12                	je     10d <strlen+0x1d>
  fb:	31 d2                	xor    %edx,%edx
  fd:	8d 76 00             	lea    0x0(%esi),%esi
 100:	83 c2 01             	add    $0x1,%edx
 103:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 107:	89 d0                	mov    %edx,%eax
 109:	75 f5                	jne    100 <strlen+0x10>
    ;
  return n;
}
 10b:	5d                   	pop    %ebp
 10c:	c3                   	ret    
uint
strlen(char *s)
{
  int n;

  for(n = 0; s[n]; n++)
 10d:	31 c0                	xor    %eax,%eax
    ;
  return n;
}
 10f:	5d                   	pop    %ebp
 110:	c3                   	ret    
 111:	eb 0d                	jmp    120 <memset>
 113:	90                   	nop
 114:	90                   	nop
 115:	90                   	nop
 116:	90                   	nop
 117:	90                   	nop
 118:	90                   	nop
 119:	90                   	nop
 11a:	90                   	nop
 11b:	90                   	nop
 11c:	90                   	nop
 11d:	90                   	nop
 11e:	90                   	nop
 11f:	90                   	nop

00000120 <memset>:

void*
memset(void *dst, int c, uint n)
{
 120:	55                   	push   %ebp
 121:	89 e5                	mov    %esp,%ebp
 123:	8b 55 08             	mov    0x8(%ebp),%edx
 126:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 127:	8b 4d 10             	mov    0x10(%ebp),%ecx
 12a:	8b 45 0c             	mov    0xc(%ebp),%eax
 12d:	89 d7                	mov    %edx,%edi
 12f:	fc                   	cld    
 130:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 132:	89 d0                	mov    %edx,%eax
 134:	5f                   	pop    %edi
 135:	5d                   	pop    %ebp
 136:	c3                   	ret    
 137:	89 f6                	mov    %esi,%esi
 139:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000140 <strchr>:

char*
strchr(const char *s, char c)
{
 140:	55                   	push   %ebp
 141:	89 e5                	mov    %esp,%ebp
 143:	8b 45 08             	mov    0x8(%ebp),%eax
 146:	53                   	push   %ebx
 147:	8b 55 0c             	mov    0xc(%ebp),%edx
  for(; *s; s++)
 14a:	0f b6 18             	movzbl (%eax),%ebx
 14d:	84 db                	test   %bl,%bl
 14f:	74 1d                	je     16e <strchr+0x2e>
    if(*s == c)
 151:	38 d3                	cmp    %dl,%bl
 153:	89 d1                	mov    %edx,%ecx
 155:	75 0d                	jne    164 <strchr+0x24>
 157:	eb 17                	jmp    170 <strchr+0x30>
 159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 160:	38 ca                	cmp    %cl,%dl
 162:	74 0c                	je     170 <strchr+0x30>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 164:	83 c0 01             	add    $0x1,%eax
 167:	0f b6 10             	movzbl (%eax),%edx
 16a:	84 d2                	test   %dl,%dl
 16c:	75 f2                	jne    160 <strchr+0x20>
    if(*s == c)
      return (char*)s;
  return 0;
 16e:	31 c0                	xor    %eax,%eax
}
 170:	5b                   	pop    %ebx
 171:	5d                   	pop    %ebp
 172:	c3                   	ret    
 173:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 179:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000180 <gets>:

char*
gets(char *buf, int max)
{
 180:	55                   	push   %ebp
 181:	89 e5                	mov    %esp,%ebp
 183:	57                   	push   %edi
 184:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 185:	31 f6                	xor    %esi,%esi
  return 0;
}

char*
gets(char *buf, int max)
{
 187:	53                   	push   %ebx
 188:	83 ec 2c             	sub    $0x2c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 18b:	8d 7d e7             	lea    -0x19(%ebp),%edi
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 18e:	eb 31                	jmp    1c1 <gets+0x41>
    cc = read(0, &c, 1);
 190:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 197:	00 
 198:	89 7c 24 04          	mov    %edi,0x4(%esp)
 19c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1a3:	e8 04 01 00 00       	call   2ac <read>
    if(cc < 1)
 1a8:	85 c0                	test   %eax,%eax
 1aa:	7e 1d                	jle    1c9 <gets+0x49>
      break;
    buf[i++] = c;
 1ac:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1b0:	89 de                	mov    %ebx,%esi
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
 1b2:	8b 55 08             	mov    0x8(%ebp),%edx
    if(c == '\n' || c == '\r')
 1b5:	3c 0d                	cmp    $0xd,%al

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
 1b7:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 1bb:	74 0c                	je     1c9 <gets+0x49>
 1bd:	3c 0a                	cmp    $0xa,%al
 1bf:	74 08                	je     1c9 <gets+0x49>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1c1:	8d 5e 01             	lea    0x1(%esi),%ebx
 1c4:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 1c7:	7c c7                	jl     190 <gets+0x10>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1c9:	8b 45 08             	mov    0x8(%ebp),%eax
 1cc:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 1d0:	83 c4 2c             	add    $0x2c,%esp
 1d3:	5b                   	pop    %ebx
 1d4:	5e                   	pop    %esi
 1d5:	5f                   	pop    %edi
 1d6:	5d                   	pop    %ebp
 1d7:	c3                   	ret    
 1d8:	90                   	nop
 1d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000001e0 <stat>:

int
stat(char *n, struct stat *st)
{
 1e0:	55                   	push   %ebp
 1e1:	89 e5                	mov    %esp,%ebp
 1e3:	56                   	push   %esi
 1e4:	53                   	push   %ebx
 1e5:	83 ec 10             	sub    $0x10,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1e8:	8b 45 08             	mov    0x8(%ebp),%eax
 1eb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 1f2:	00 
 1f3:	89 04 24             	mov    %eax,(%esp)
 1f6:	e8 d9 00 00 00       	call   2d4 <open>
  if(fd < 0)
 1fb:	85 c0                	test   %eax,%eax
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1fd:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
 1ff:	78 27                	js     228 <stat+0x48>
    return -1;
  r = fstat(fd, st);
 201:	8b 45 0c             	mov    0xc(%ebp),%eax
 204:	89 1c 24             	mov    %ebx,(%esp)
 207:	89 44 24 04          	mov    %eax,0x4(%esp)
 20b:	e8 dc 00 00 00       	call   2ec <fstat>
  close(fd);
 210:	89 1c 24             	mov    %ebx,(%esp)
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
 213:	89 c6                	mov    %eax,%esi
  close(fd);
 215:	e8 a2 00 00 00       	call   2bc <close>
  return r;
 21a:	89 f0                	mov    %esi,%eax
}
 21c:	83 c4 10             	add    $0x10,%esp
 21f:	5b                   	pop    %ebx
 220:	5e                   	pop    %esi
 221:	5d                   	pop    %ebp
 222:	c3                   	ret    
 223:	90                   	nop
 224:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
 228:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 22d:	eb ed                	jmp    21c <stat+0x3c>
 22f:	90                   	nop

00000230 <atoi>:
  return r;
}

int
atoi(const char *s)
{
 230:	55                   	push   %ebp
 231:	89 e5                	mov    %esp,%ebp
 233:	8b 4d 08             	mov    0x8(%ebp),%ecx
 236:	53                   	push   %ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 237:	0f be 11             	movsbl (%ecx),%edx
 23a:	8d 42 d0             	lea    -0x30(%edx),%eax
 23d:	3c 09                	cmp    $0x9,%al
int
atoi(const char *s)
{
  int n;

  n = 0;
 23f:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 244:	77 17                	ja     25d <atoi+0x2d>
 246:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 248:	83 c1 01             	add    $0x1,%ecx
 24b:	8d 04 80             	lea    (%eax,%eax,4),%eax
 24e:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 252:	0f be 11             	movsbl (%ecx),%edx
 255:	8d 5a d0             	lea    -0x30(%edx),%ebx
 258:	80 fb 09             	cmp    $0x9,%bl
 25b:	76 eb                	jbe    248 <atoi+0x18>
    n = n*10 + *s++ - '0';
  return n;
}
 25d:	5b                   	pop    %ebx
 25e:	5d                   	pop    %ebp
 25f:	c3                   	ret    

00000260 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 260:	55                   	push   %ebp
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 261:	31 d2                	xor    %edx,%edx
  return n;
}

void*
memmove(void *vdst, void *vsrc, int n)
{
 263:	89 e5                	mov    %esp,%ebp
 265:	56                   	push   %esi
 266:	8b 45 08             	mov    0x8(%ebp),%eax
 269:	53                   	push   %ebx
 26a:	8b 5d 10             	mov    0x10(%ebp),%ebx
 26d:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 270:	85 db                	test   %ebx,%ebx
 272:	7e 12                	jle    286 <memmove+0x26>
 274:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 278:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 27c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 27f:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 282:	39 da                	cmp    %ebx,%edx
 284:	75 f2                	jne    278 <memmove+0x18>
    *dst++ = *src++;
  return vdst;
}
 286:	5b                   	pop    %ebx
 287:	5e                   	pop    %esi
 288:	5d                   	pop    %ebp
 289:	c3                   	ret    
 28a:	90                   	nop
 28b:	90                   	nop

0000028c <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 28c:	b8 01 00 00 00       	mov    $0x1,%eax
 291:	cd 40                	int    $0x40
 293:	c3                   	ret    

00000294 <exit>:
SYSCALL(exit)
 294:	b8 02 00 00 00       	mov    $0x2,%eax
 299:	cd 40                	int    $0x40
 29b:	c3                   	ret    

0000029c <wait>:
SYSCALL(wait)
 29c:	b8 03 00 00 00       	mov    $0x3,%eax
 2a1:	cd 40                	int    $0x40
 2a3:	c3                   	ret    

000002a4 <pipe>:
SYSCALL(pipe)
 2a4:	b8 04 00 00 00       	mov    $0x4,%eax
 2a9:	cd 40                	int    $0x40
 2ab:	c3                   	ret    

000002ac <read>:
SYSCALL(read)
 2ac:	b8 05 00 00 00       	mov    $0x5,%eax
 2b1:	cd 40                	int    $0x40
 2b3:	c3                   	ret    

000002b4 <write>:
SYSCALL(write)
 2b4:	b8 10 00 00 00       	mov    $0x10,%eax
 2b9:	cd 40                	int    $0x40
 2bb:	c3                   	ret    

000002bc <close>:
SYSCALL(close)
 2bc:	b8 15 00 00 00       	mov    $0x15,%eax
 2c1:	cd 40                	int    $0x40
 2c3:	c3                   	ret    

000002c4 <kill>:
SYSCALL(kill)
 2c4:	b8 06 00 00 00       	mov    $0x6,%eax
 2c9:	cd 40                	int    $0x40
 2cb:	c3                   	ret    

000002cc <exec>:
SYSCALL(exec)
 2cc:	b8 07 00 00 00       	mov    $0x7,%eax
 2d1:	cd 40                	int    $0x40
 2d3:	c3                   	ret    

000002d4 <open>:
SYSCALL(open)
 2d4:	b8 0f 00 00 00       	mov    $0xf,%eax
 2d9:	cd 40                	int    $0x40
 2db:	c3                   	ret    

000002dc <mknod>:
SYSCALL(mknod)
 2dc:	b8 11 00 00 00       	mov    $0x11,%eax
 2e1:	cd 40                	int    $0x40
 2e3:	c3                   	ret    

000002e4 <unlink>:
SYSCALL(unlink)
 2e4:	b8 12 00 00 00       	mov    $0x12,%eax
 2e9:	cd 40                	int    $0x40
 2eb:	c3                   	ret    

000002ec <fstat>:
SYSCALL(fstat)
 2ec:	b8 08 00 00 00       	mov    $0x8,%eax
 2f1:	cd 40                	int    $0x40
 2f3:	c3                   	ret    

000002f4 <link>:
SYSCALL(link)
 2f4:	b8 13 00 00 00       	mov    $0x13,%eax
 2f9:	cd 40                	int    $0x40
 2fb:	c3                   	ret    

000002fc <mkdir>:
SYSCALL(mkdir)
 2fc:	b8 14 00 00 00       	mov    $0x14,%eax
 301:	cd 40                	int    $0x40
 303:	c3                   	ret    

00000304 <chdir>:
SYSCALL(chdir)
 304:	b8 09 00 00 00       	mov    $0x9,%eax
 309:	cd 40                	int    $0x40
 30b:	c3                   	ret    

0000030c <dup>:
SYSCALL(dup)
 30c:	b8 0a 00 00 00       	mov    $0xa,%eax
 311:	cd 40                	int    $0x40
 313:	c3                   	ret    

00000314 <getpid>:
SYSCALL(getpid)
 314:	b8 0b 00 00 00       	mov    $0xb,%eax
 319:	cd 40                	int    $0x40
 31b:	c3                   	ret    

0000031c <sbrk>:
SYSCALL(sbrk)
 31c:	b8 0c 00 00 00       	mov    $0xc,%eax
 321:	cd 40                	int    $0x40
 323:	c3                   	ret    

00000324 <sleep>:
SYSCALL(sleep)
 324:	b8 0d 00 00 00       	mov    $0xd,%eax
 329:	cd 40                	int    $0x40
 32b:	c3                   	ret    

0000032c <uptime>:
SYSCALL(uptime)
 32c:	b8 0e 00 00 00       	mov    $0xe,%eax
 331:	cd 40                	int    $0x40
 333:	c3                   	ret    

00000334 <date>:
SYSCALL(date)
 334:	b8 16 00 00 00       	mov    $0x16,%eax
 339:	cd 40                	int    $0x40
 33b:	c3                   	ret    

0000033c <dup2>:
SYSCALL(dup2)
 33c:	b8 17 00 00 00       	mov    $0x17,%eax
 341:	cd 40                	int    $0x40
 343:	c3                   	ret    
 344:	90                   	nop
 345:	90                   	nop
 346:	90                   	nop
 347:	90                   	nop
 348:	90                   	nop
 349:	90                   	nop
 34a:	90                   	nop
 34b:	90                   	nop
 34c:	90                   	nop
 34d:	90                   	nop
 34e:	90                   	nop
 34f:	90                   	nop

00000350 <printint>:
 350:	55                   	push   %ebp
 351:	89 e5                	mov    %esp,%ebp
 353:	57                   	push   %edi
 354:	56                   	push   %esi
 355:	89 c6                	mov    %eax,%esi
 357:	53                   	push   %ebx
 358:	83 ec 4c             	sub    $0x4c,%esp
 35b:	8b 5d 08             	mov    0x8(%ebp),%ebx
 35e:	85 db                	test   %ebx,%ebx
 360:	74 09                	je     36b <printint+0x1b>
 362:	89 d0                	mov    %edx,%eax
 364:	c1 e8 1f             	shr    $0x1f,%eax
 367:	84 c0                	test   %al,%al
 369:	75 75                	jne    3e0 <printint+0x90>
 36b:	89 d0                	mov    %edx,%eax
 36d:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 374:	89 75 c0             	mov    %esi,-0x40(%ebp)
 377:	31 ff                	xor    %edi,%edi
 379:	89 ce                	mov    %ecx,%esi
 37b:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 37e:	eb 02                	jmp    382 <printint+0x32>
 380:	89 cf                	mov    %ecx,%edi
 382:	31 d2                	xor    %edx,%edx
 384:	f7 f6                	div    %esi
 386:	8d 4f 01             	lea    0x1(%edi),%ecx
 389:	0f b6 92 84 07 00 00 	movzbl 0x784(%edx),%edx
 390:	85 c0                	test   %eax,%eax
 392:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
 395:	75 e9                	jne    380 <printint+0x30>
 397:	8b 55 c4             	mov    -0x3c(%ebp),%edx
 39a:	89 c8                	mov    %ecx,%eax
 39c:	8b 75 c0             	mov    -0x40(%ebp),%esi
 39f:	85 d2                	test   %edx,%edx
 3a1:	74 08                	je     3ab <printint+0x5b>
 3a3:	8d 4f 02             	lea    0x2(%edi),%ecx
 3a6:	c6 44 05 d8 2d       	movb   $0x2d,-0x28(%ebp,%eax,1)
 3ab:	8d 79 ff             	lea    -0x1(%ecx),%edi
 3ae:	66 90                	xchg   %ax,%ax
 3b0:	0f b6 44 3d d8       	movzbl -0x28(%ebp,%edi,1),%eax
 3b5:	83 ef 01             	sub    $0x1,%edi
 3b8:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 3bf:	00 
 3c0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
 3c4:	89 34 24             	mov    %esi,(%esp)
 3c7:	88 45 d7             	mov    %al,-0x29(%ebp)
 3ca:	e8 e5 fe ff ff       	call   2b4 <write>
 3cf:	83 ff ff             	cmp    $0xffffffff,%edi
 3d2:	75 dc                	jne    3b0 <printint+0x60>
 3d4:	83 c4 4c             	add    $0x4c,%esp
 3d7:	5b                   	pop    %ebx
 3d8:	5e                   	pop    %esi
 3d9:	5f                   	pop    %edi
 3da:	5d                   	pop    %ebp
 3db:	c3                   	ret    
 3dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 3e0:	89 d0                	mov    %edx,%eax
 3e2:	f7 d8                	neg    %eax
 3e4:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
 3eb:	eb 87                	jmp    374 <printint+0x24>
 3ed:	8d 76 00             	lea    0x0(%esi),%esi

000003f0 <printf>:
 3f0:	55                   	push   %ebp
 3f1:	89 e5                	mov    %esp,%ebp
 3f3:	57                   	push   %edi
 3f4:	31 ff                	xor    %edi,%edi
 3f6:	56                   	push   %esi
 3f7:	53                   	push   %ebx
 3f8:	83 ec 3c             	sub    $0x3c,%esp
 3fb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 3fe:	8d 45 10             	lea    0x10(%ebp),%eax
 401:	8b 75 08             	mov    0x8(%ebp),%esi
 404:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 407:	0f b6 13             	movzbl (%ebx),%edx
 40a:	83 c3 01             	add    $0x1,%ebx
 40d:	84 d2                	test   %dl,%dl
 40f:	75 39                	jne    44a <printf+0x5a>
 411:	e9 c2 00 00 00       	jmp    4d8 <printf+0xe8>
 416:	66 90                	xchg   %ax,%ax
 418:	83 fa 25             	cmp    $0x25,%edx
 41b:	0f 84 bf 00 00 00    	je     4e0 <printf+0xf0>
 421:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 424:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 42b:	00 
 42c:	89 44 24 04          	mov    %eax,0x4(%esp)
 430:	89 34 24             	mov    %esi,(%esp)
 433:	88 55 e2             	mov    %dl,-0x1e(%ebp)
 436:	e8 79 fe ff ff       	call   2b4 <write>
 43b:	83 c3 01             	add    $0x1,%ebx
 43e:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
 442:	84 d2                	test   %dl,%dl
 444:	0f 84 8e 00 00 00    	je     4d8 <printf+0xe8>
 44a:	85 ff                	test   %edi,%edi
 44c:	0f be c2             	movsbl %dl,%eax
 44f:	74 c7                	je     418 <printf+0x28>
 451:	83 ff 25             	cmp    $0x25,%edi
 454:	75 e5                	jne    43b <printf+0x4b>
 456:	83 fa 64             	cmp    $0x64,%edx
 459:	0f 84 31 01 00 00    	je     590 <printf+0x1a0>
 45f:	25 f7 00 00 00       	and    $0xf7,%eax
 464:	83 f8 70             	cmp    $0x70,%eax
 467:	0f 84 83 00 00 00    	je     4f0 <printf+0x100>
 46d:	83 fa 73             	cmp    $0x73,%edx
 470:	0f 84 a2 00 00 00    	je     518 <printf+0x128>
 476:	83 fa 63             	cmp    $0x63,%edx
 479:	0f 84 35 01 00 00    	je     5b4 <printf+0x1c4>
 47f:	83 fa 25             	cmp    $0x25,%edx
 482:	0f 84 e0 00 00 00    	je     568 <printf+0x178>
 488:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 48b:	83 c3 01             	add    $0x1,%ebx
 48e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 495:	00 
 496:	31 ff                	xor    %edi,%edi
 498:	89 44 24 04          	mov    %eax,0x4(%esp)
 49c:	89 34 24             	mov    %esi,(%esp)
 49f:	89 55 d0             	mov    %edx,-0x30(%ebp)
 4a2:	c6 45 e6 25          	movb   $0x25,-0x1a(%ebp)
 4a6:	e8 09 fe ff ff       	call   2b4 <write>
 4ab:	8b 55 d0             	mov    -0x30(%ebp),%edx
 4ae:	8d 45 e7             	lea    -0x19(%ebp),%eax
 4b1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4b8:	00 
 4b9:	89 44 24 04          	mov    %eax,0x4(%esp)
 4bd:	89 34 24             	mov    %esi,(%esp)
 4c0:	88 55 e7             	mov    %dl,-0x19(%ebp)
 4c3:	e8 ec fd ff ff       	call   2b4 <write>
 4c8:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
 4cc:	84 d2                	test   %dl,%dl
 4ce:	0f 85 76 ff ff ff    	jne    44a <printf+0x5a>
 4d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 4d8:	83 c4 3c             	add    $0x3c,%esp
 4db:	5b                   	pop    %ebx
 4dc:	5e                   	pop    %esi
 4dd:	5f                   	pop    %edi
 4de:	5d                   	pop    %ebp
 4df:	c3                   	ret    
 4e0:	bf 25 00 00 00       	mov    $0x25,%edi
 4e5:	e9 51 ff ff ff       	jmp    43b <printf+0x4b>
 4ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 4f0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 4f3:	b9 10 00 00 00       	mov    $0x10,%ecx
 4f8:	31 ff                	xor    %edi,%edi
 4fa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 501:	8b 10                	mov    (%eax),%edx
 503:	89 f0                	mov    %esi,%eax
 505:	e8 46 fe ff ff       	call   350 <printint>
 50a:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 50e:	e9 28 ff ff ff       	jmp    43b <printf+0x4b>
 513:	90                   	nop
 514:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 518:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 51b:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 51f:	8b 38                	mov    (%eax),%edi
 521:	b8 7d 07 00 00       	mov    $0x77d,%eax
 526:	85 ff                	test   %edi,%edi
 528:	0f 44 f8             	cmove  %eax,%edi
 52b:	0f b6 07             	movzbl (%edi),%eax
 52e:	84 c0                	test   %al,%al
 530:	74 2a                	je     55c <printf+0x16c>
 532:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 538:	88 45 e3             	mov    %al,-0x1d(%ebp)
 53b:	8d 45 e3             	lea    -0x1d(%ebp),%eax
 53e:	83 c7 01             	add    $0x1,%edi
 541:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 548:	00 
 549:	89 44 24 04          	mov    %eax,0x4(%esp)
 54d:	89 34 24             	mov    %esi,(%esp)
 550:	e8 5f fd ff ff       	call   2b4 <write>
 555:	0f b6 07             	movzbl (%edi),%eax
 558:	84 c0                	test   %al,%al
 55a:	75 dc                	jne    538 <printf+0x148>
 55c:	31 ff                	xor    %edi,%edi
 55e:	e9 d8 fe ff ff       	jmp    43b <printf+0x4b>
 563:	90                   	nop
 564:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 568:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 56b:	31 ff                	xor    %edi,%edi
 56d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 574:	00 
 575:	89 44 24 04          	mov    %eax,0x4(%esp)
 579:	89 34 24             	mov    %esi,(%esp)
 57c:	c6 45 e5 25          	movb   $0x25,-0x1b(%ebp)
 580:	e8 2f fd ff ff       	call   2b4 <write>
 585:	e9 b1 fe ff ff       	jmp    43b <printf+0x4b>
 58a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 590:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 593:	b9 0a 00 00 00       	mov    $0xa,%ecx
 598:	66 31 ff             	xor    %di,%di
 59b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 5a2:	8b 10                	mov    (%eax),%edx
 5a4:	89 f0                	mov    %esi,%eax
 5a6:	e8 a5 fd ff ff       	call   350 <printint>
 5ab:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 5af:	e9 87 fe ff ff       	jmp    43b <printf+0x4b>
 5b4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 5b7:	31 ff                	xor    %edi,%edi
 5b9:	8b 00                	mov    (%eax),%eax
 5bb:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 5c2:	00 
 5c3:	89 34 24             	mov    %esi,(%esp)
 5c6:	88 45 e4             	mov    %al,-0x1c(%ebp)
 5c9:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 5cc:	89 44 24 04          	mov    %eax,0x4(%esp)
 5d0:	e8 df fc ff ff       	call   2b4 <write>
 5d5:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 5d9:	e9 5d fe ff ff       	jmp    43b <printf+0x4b>
 5de:	90                   	nop
 5df:	90                   	nop

000005e0 <free>:
 5e0:	55                   	push   %ebp
 5e1:	a1 fc 09 00 00       	mov    0x9fc,%eax
 5e6:	89 e5                	mov    %esp,%ebp
 5e8:	57                   	push   %edi
 5e9:	56                   	push   %esi
 5ea:	53                   	push   %ebx
 5eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
 5ee:	8b 08                	mov    (%eax),%ecx
 5f0:	8d 53 f8             	lea    -0x8(%ebx),%edx
 5f3:	39 d0                	cmp    %edx,%eax
 5f5:	72 11                	jb     608 <free+0x28>
 5f7:	90                   	nop
 5f8:	39 c8                	cmp    %ecx,%eax
 5fa:	72 04                	jb     600 <free+0x20>
 5fc:	39 ca                	cmp    %ecx,%edx
 5fe:	72 10                	jb     610 <free+0x30>
 600:	89 c8                	mov    %ecx,%eax
 602:	39 d0                	cmp    %edx,%eax
 604:	8b 08                	mov    (%eax),%ecx
 606:	73 f0                	jae    5f8 <free+0x18>
 608:	39 ca                	cmp    %ecx,%edx
 60a:	72 04                	jb     610 <free+0x30>
 60c:	39 c8                	cmp    %ecx,%eax
 60e:	72 f0                	jb     600 <free+0x20>
 610:	8b 73 fc             	mov    -0x4(%ebx),%esi
 613:	8d 3c f2             	lea    (%edx,%esi,8),%edi
 616:	39 cf                	cmp    %ecx,%edi
 618:	74 1e                	je     638 <free+0x58>
 61a:	89 4b f8             	mov    %ecx,-0x8(%ebx)
 61d:	8b 48 04             	mov    0x4(%eax),%ecx
 620:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
 623:	39 f2                	cmp    %esi,%edx
 625:	74 28                	je     64f <free+0x6f>
 627:	89 10                	mov    %edx,(%eax)
 629:	a3 fc 09 00 00       	mov    %eax,0x9fc
 62e:	5b                   	pop    %ebx
 62f:	5e                   	pop    %esi
 630:	5f                   	pop    %edi
 631:	5d                   	pop    %ebp
 632:	c3                   	ret    
 633:	90                   	nop
 634:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 638:	03 71 04             	add    0x4(%ecx),%esi
 63b:	89 73 fc             	mov    %esi,-0x4(%ebx)
 63e:	8b 08                	mov    (%eax),%ecx
 640:	8b 09                	mov    (%ecx),%ecx
 642:	89 4b f8             	mov    %ecx,-0x8(%ebx)
 645:	8b 48 04             	mov    0x4(%eax),%ecx
 648:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
 64b:	39 f2                	cmp    %esi,%edx
 64d:	75 d8                	jne    627 <free+0x47>
 64f:	03 4b fc             	add    -0x4(%ebx),%ecx
 652:	a3 fc 09 00 00       	mov    %eax,0x9fc
 657:	89 48 04             	mov    %ecx,0x4(%eax)
 65a:	8b 53 f8             	mov    -0x8(%ebx),%edx
 65d:	89 10                	mov    %edx,(%eax)
 65f:	5b                   	pop    %ebx
 660:	5e                   	pop    %esi
 661:	5f                   	pop    %edi
 662:	5d                   	pop    %ebp
 663:	c3                   	ret    
 664:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 66a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000670 <malloc>:
 670:	55                   	push   %ebp
 671:	89 e5                	mov    %esp,%ebp
 673:	57                   	push   %edi
 674:	56                   	push   %esi
 675:	53                   	push   %ebx
 676:	83 ec 1c             	sub    $0x1c,%esp
 679:	8b 45 08             	mov    0x8(%ebp),%eax
 67c:	8b 1d fc 09 00 00    	mov    0x9fc,%ebx
 682:	8d 48 07             	lea    0x7(%eax),%ecx
 685:	c1 e9 03             	shr    $0x3,%ecx
 688:	85 db                	test   %ebx,%ebx
 68a:	8d 71 01             	lea    0x1(%ecx),%esi
 68d:	0f 84 9b 00 00 00    	je     72e <malloc+0xbe>
 693:	8b 13                	mov    (%ebx),%edx
 695:	8b 7a 04             	mov    0x4(%edx),%edi
 698:	39 fe                	cmp    %edi,%esi
 69a:	76 64                	jbe    700 <malloc+0x90>
 69c:	8d 04 f5 00 00 00 00 	lea    0x0(,%esi,8),%eax
 6a3:	bb 00 80 00 00       	mov    $0x8000,%ebx
 6a8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 6ab:	eb 0e                	jmp    6bb <malloc+0x4b>
 6ad:	8d 76 00             	lea    0x0(%esi),%esi
 6b0:	8b 02                	mov    (%edx),%eax
 6b2:	8b 78 04             	mov    0x4(%eax),%edi
 6b5:	39 fe                	cmp    %edi,%esi
 6b7:	76 4f                	jbe    708 <malloc+0x98>
 6b9:	89 c2                	mov    %eax,%edx
 6bb:	3b 15 fc 09 00 00    	cmp    0x9fc,%edx
 6c1:	75 ed                	jne    6b0 <malloc+0x40>
 6c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6c6:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 6cc:	bf 00 10 00 00       	mov    $0x1000,%edi
 6d1:	0f 43 fe             	cmovae %esi,%edi
 6d4:	0f 42 c3             	cmovb  %ebx,%eax
 6d7:	89 04 24             	mov    %eax,(%esp)
 6da:	e8 3d fc ff ff       	call   31c <sbrk>
 6df:	83 f8 ff             	cmp    $0xffffffff,%eax
 6e2:	74 18                	je     6fc <malloc+0x8c>
 6e4:	89 78 04             	mov    %edi,0x4(%eax)
 6e7:	83 c0 08             	add    $0x8,%eax
 6ea:	89 04 24             	mov    %eax,(%esp)
 6ed:	e8 ee fe ff ff       	call   5e0 <free>
 6f2:	8b 15 fc 09 00 00    	mov    0x9fc,%edx
 6f8:	85 d2                	test   %edx,%edx
 6fa:	75 b4                	jne    6b0 <malloc+0x40>
 6fc:	31 c0                	xor    %eax,%eax
 6fe:	eb 20                	jmp    720 <malloc+0xb0>
 700:	89 d0                	mov    %edx,%eax
 702:	89 da                	mov    %ebx,%edx
 704:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 708:	39 fe                	cmp    %edi,%esi
 70a:	74 1c                	je     728 <malloc+0xb8>
 70c:	29 f7                	sub    %esi,%edi
 70e:	89 78 04             	mov    %edi,0x4(%eax)
 711:	8d 04 f8             	lea    (%eax,%edi,8),%eax
 714:	89 70 04             	mov    %esi,0x4(%eax)
 717:	89 15 fc 09 00 00    	mov    %edx,0x9fc
 71d:	83 c0 08             	add    $0x8,%eax
 720:	83 c4 1c             	add    $0x1c,%esp
 723:	5b                   	pop    %ebx
 724:	5e                   	pop    %esi
 725:	5f                   	pop    %edi
 726:	5d                   	pop    %ebp
 727:	c3                   	ret    
 728:	8b 08                	mov    (%eax),%ecx
 72a:	89 0a                	mov    %ecx,(%edx)
 72c:	eb e9                	jmp    717 <malloc+0xa7>
 72e:	c7 05 fc 09 00 00 00 	movl   $0xa00,0x9fc
 735:	0a 00 00 
 738:	ba 00 0a 00 00       	mov    $0xa00,%edx
 73d:	c7 05 00 0a 00 00 00 	movl   $0xa00,0xa00
 744:	0a 00 00 
 747:	c7 05 04 0a 00 00 00 	movl   $0x0,0xa04
 74e:	00 00 00 
 751:	e9 46 ff ff ff       	jmp    69c <malloc+0x2c>
