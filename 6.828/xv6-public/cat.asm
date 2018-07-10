
_cat:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
  }
}

int
main(int argc, char *argv[])
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	57                   	push   %edi
   4:	56                   	push   %esi
  int fd, i;

  if(argc <= 1){
   5:	be 01 00 00 00       	mov    $0x1,%esi
  }
}

int
main(int argc, char *argv[])
{
   a:	53                   	push   %ebx
   b:	83 e4 f0             	and    $0xfffffff0,%esp
   e:	83 ec 10             	sub    $0x10,%esp
  11:	8b 45 0c             	mov    0xc(%ebp),%eax
  int fd, i;

  if(argc <= 1){
  14:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  18:	8d 58 04             	lea    0x4(%eax),%ebx
  1b:	7e 5a                	jle    77 <main+0x77>
  1d:	8d 76 00             	lea    0x0(%esi),%esi
    cat(0);
    exit();
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], 0)) < 0){
  20:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  27:	00 
  28:	8b 03                	mov    (%ebx),%eax
  2a:	89 04 24             	mov    %eax,(%esp)
  2d:	e8 52 03 00 00       	call   384 <open>
  32:	85 c0                	test   %eax,%eax
  34:	89 c7                	mov    %eax,%edi
  36:	78 20                	js     58 <main+0x58>
      printf(1, "cat: cannot open %s\n", argv[i]);
      exit();
    }
    cat(fd);
  38:	89 04 24             	mov    %eax,(%esp)
  if(argc <= 1){
    cat(0);
    exit();
  }

  for(i = 1; i < argc; i++){
  3b:	83 c6 01             	add    $0x1,%esi
  3e:	83 c3 04             	add    $0x4,%ebx
    if((fd = open(argv[i], 0)) < 0){
      printf(1, "cat: cannot open %s\n", argv[i]);
      exit();
    }
    cat(fd);
  41:	e8 4a 00 00 00       	call   90 <cat>
    close(fd);
  46:	89 3c 24             	mov    %edi,(%esp)
  49:	e8 1e 03 00 00       	call   36c <close>
  if(argc <= 1){
    cat(0);
    exit();
  }

  for(i = 1; i < argc; i++){
  4e:	3b 75 08             	cmp    0x8(%ebp),%esi
  51:	75 cd                	jne    20 <main+0x20>
      exit();
    }
    cat(fd);
    close(fd);
  }
  exit();
  53:	e8 ec 02 00 00       	call   344 <exit>
    exit();
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], 0)) < 0){
      printf(1, "cat: cannot open %s\n", argv[i]);
  58:	8b 03                	mov    (%ebx),%eax
  5a:	c7 44 24 04 29 08 00 	movl   $0x829,0x4(%esp)
  61:	00 
  62:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  69:	89 44 24 08          	mov    %eax,0x8(%esp)
  6d:	e8 2e 04 00 00       	call   4a0 <printf>
      exit();
  72:	e8 cd 02 00 00       	call   344 <exit>
main(int argc, char *argv[])
{
  int fd, i;

  if(argc <= 1){
    cat(0);
  77:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  7e:	e8 0d 00 00 00       	call   90 <cat>
    exit();
  83:	e8 bc 02 00 00       	call   344 <exit>
  88:	90                   	nop
  89:	90                   	nop
  8a:	90                   	nop
  8b:	90                   	nop
  8c:	90                   	nop
  8d:	90                   	nop
  8e:	90                   	nop
  8f:	90                   	nop

00000090 <cat>:

char buf[512];

void
cat(int fd)
{
  90:	55                   	push   %ebp
  91:	89 e5                	mov    %esp,%ebp
  93:	56                   	push   %esi
  94:	53                   	push   %ebx
  95:	83 ec 10             	sub    $0x10,%esp
  98:	8b 75 08             	mov    0x8(%ebp),%esi
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0) {
  9b:	eb 1f                	jmp    bc <cat+0x2c>
  9d:	8d 76 00             	lea    0x0(%esi),%esi
    if (write(1, buf, n) != n) {
  a0:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  a4:	c7 44 24 04 20 0b 00 	movl   $0xb20,0x4(%esp)
  ab:	00 
  ac:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  b3:	e8 ac 02 00 00       	call   364 <write>
  b8:	39 d8                	cmp    %ebx,%eax
  ba:	75 28                	jne    e4 <cat+0x54>
void
cat(int fd)
{
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0) {
  bc:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  c3:	00 
  c4:	c7 44 24 04 20 0b 00 	movl   $0xb20,0x4(%esp)
  cb:	00 
  cc:	89 34 24             	mov    %esi,(%esp)
  cf:	e8 88 02 00 00       	call   35c <read>
  d4:	83 f8 00             	cmp    $0x0,%eax
  d7:	89 c3                	mov    %eax,%ebx
  d9:	7f c5                	jg     a0 <cat+0x10>
    if (write(1, buf, n) != n) {
      printf(1, "cat: write error\n");
      exit();
    }
  }
  if(n < 0){
  db:	75 20                	jne    fd <cat+0x6d>
    printf(1, "cat: read error\n");
    exit();
  }
}
  dd:	83 c4 10             	add    $0x10,%esp
  e0:	5b                   	pop    %ebx
  e1:	5e                   	pop    %esi
  e2:	5d                   	pop    %ebp
  e3:	c3                   	ret    
{
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0) {
    if (write(1, buf, n) != n) {
      printf(1, "cat: write error\n");
  e4:	c7 44 24 04 06 08 00 	movl   $0x806,0x4(%esp)
  eb:	00 
  ec:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  f3:	e8 a8 03 00 00       	call   4a0 <printf>
      exit();
  f8:	e8 47 02 00 00       	call   344 <exit>
    }
  }
  if(n < 0){
    printf(1, "cat: read error\n");
  fd:	c7 44 24 04 18 08 00 	movl   $0x818,0x4(%esp)
 104:	00 
 105:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 10c:	e8 8f 03 00 00       	call   4a0 <printf>
    exit();
 111:	e8 2e 02 00 00       	call   344 <exit>
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

00000120 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 120:	55                   	push   %ebp
 121:	89 e5                	mov    %esp,%ebp
 123:	8b 45 08             	mov    0x8(%ebp),%eax
 126:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 129:	53                   	push   %ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 12a:	89 c2                	mov    %eax,%edx
 12c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 130:	83 c1 01             	add    $0x1,%ecx
 133:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 137:	83 c2 01             	add    $0x1,%edx
 13a:	84 db                	test   %bl,%bl
 13c:	88 5a ff             	mov    %bl,-0x1(%edx)
 13f:	75 ef                	jne    130 <strcpy+0x10>
    ;
  return os;
}
 141:	5b                   	pop    %ebx
 142:	5d                   	pop    %ebp
 143:	c3                   	ret    
 144:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 14a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000150 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 150:	55                   	push   %ebp
 151:	89 e5                	mov    %esp,%ebp
 153:	8b 55 08             	mov    0x8(%ebp),%edx
 156:	53                   	push   %ebx
 157:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 15a:	0f b6 02             	movzbl (%edx),%eax
 15d:	84 c0                	test   %al,%al
 15f:	74 2d                	je     18e <strcmp+0x3e>
 161:	0f b6 19             	movzbl (%ecx),%ebx
 164:	38 d8                	cmp    %bl,%al
 166:	74 0e                	je     176 <strcmp+0x26>
 168:	eb 2b                	jmp    195 <strcmp+0x45>
 16a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 170:	38 c8                	cmp    %cl,%al
 172:	75 15                	jne    189 <strcmp+0x39>
    p++, q++;
 174:	89 d9                	mov    %ebx,%ecx
 176:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 179:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 17c:	8d 59 01             	lea    0x1(%ecx),%ebx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 17f:	0f b6 49 01          	movzbl 0x1(%ecx),%ecx
 183:	84 c0                	test   %al,%al
 185:	75 e9                	jne    170 <strcmp+0x20>
 187:	31 c0                	xor    %eax,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
 189:	29 c8                	sub    %ecx,%eax
}
 18b:	5b                   	pop    %ebx
 18c:	5d                   	pop    %ebp
 18d:	c3                   	ret    
 18e:	0f b6 09             	movzbl (%ecx),%ecx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 191:	31 c0                	xor    %eax,%eax
 193:	eb f4                	jmp    189 <strcmp+0x39>
 195:	0f b6 cb             	movzbl %bl,%ecx
 198:	eb ef                	jmp    189 <strcmp+0x39>
 19a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000001a0 <strlen>:
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
 1a0:	55                   	push   %ebp
 1a1:	89 e5                	mov    %esp,%ebp
 1a3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 1a6:	80 39 00             	cmpb   $0x0,(%ecx)
 1a9:	74 12                	je     1bd <strlen+0x1d>
 1ab:	31 d2                	xor    %edx,%edx
 1ad:	8d 76 00             	lea    0x0(%esi),%esi
 1b0:	83 c2 01             	add    $0x1,%edx
 1b3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 1b7:	89 d0                	mov    %edx,%eax
 1b9:	75 f5                	jne    1b0 <strlen+0x10>
    ;
  return n;
}
 1bb:	5d                   	pop    %ebp
 1bc:	c3                   	ret    
uint
strlen(char *s)
{
  int n;

  for(n = 0; s[n]; n++)
 1bd:	31 c0                	xor    %eax,%eax
    ;
  return n;
}
 1bf:	5d                   	pop    %ebp
 1c0:	c3                   	ret    
 1c1:	eb 0d                	jmp    1d0 <memset>
 1c3:	90                   	nop
 1c4:	90                   	nop
 1c5:	90                   	nop
 1c6:	90                   	nop
 1c7:	90                   	nop
 1c8:	90                   	nop
 1c9:	90                   	nop
 1ca:	90                   	nop
 1cb:	90                   	nop
 1cc:	90                   	nop
 1cd:	90                   	nop
 1ce:	90                   	nop
 1cf:	90                   	nop

000001d0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1d0:	55                   	push   %ebp
 1d1:	89 e5                	mov    %esp,%ebp
 1d3:	8b 55 08             	mov    0x8(%ebp),%edx
 1d6:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 1d7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 1da:	8b 45 0c             	mov    0xc(%ebp),%eax
 1dd:	89 d7                	mov    %edx,%edi
 1df:	fc                   	cld    
 1e0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 1e2:	89 d0                	mov    %edx,%eax
 1e4:	5f                   	pop    %edi
 1e5:	5d                   	pop    %ebp
 1e6:	c3                   	ret    
 1e7:	89 f6                	mov    %esi,%esi
 1e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000001f0 <strchr>:

char*
strchr(const char *s, char c)
{
 1f0:	55                   	push   %ebp
 1f1:	89 e5                	mov    %esp,%ebp
 1f3:	8b 45 08             	mov    0x8(%ebp),%eax
 1f6:	53                   	push   %ebx
 1f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  for(; *s; s++)
 1fa:	0f b6 18             	movzbl (%eax),%ebx
 1fd:	84 db                	test   %bl,%bl
 1ff:	74 1d                	je     21e <strchr+0x2e>
    if(*s == c)
 201:	38 d3                	cmp    %dl,%bl
 203:	89 d1                	mov    %edx,%ecx
 205:	75 0d                	jne    214 <strchr+0x24>
 207:	eb 17                	jmp    220 <strchr+0x30>
 209:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 210:	38 ca                	cmp    %cl,%dl
 212:	74 0c                	je     220 <strchr+0x30>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 214:	83 c0 01             	add    $0x1,%eax
 217:	0f b6 10             	movzbl (%eax),%edx
 21a:	84 d2                	test   %dl,%dl
 21c:	75 f2                	jne    210 <strchr+0x20>
    if(*s == c)
      return (char*)s;
  return 0;
 21e:	31 c0                	xor    %eax,%eax
}
 220:	5b                   	pop    %ebx
 221:	5d                   	pop    %ebp
 222:	c3                   	ret    
 223:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 229:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000230 <gets>:

char*
gets(char *buf, int max)
{
 230:	55                   	push   %ebp
 231:	89 e5                	mov    %esp,%ebp
 233:	57                   	push   %edi
 234:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 235:	31 f6                	xor    %esi,%esi
  return 0;
}

char*
gets(char *buf, int max)
{
 237:	53                   	push   %ebx
 238:	83 ec 2c             	sub    $0x2c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 23b:	8d 7d e7             	lea    -0x19(%ebp),%edi
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 23e:	eb 31                	jmp    271 <gets+0x41>
    cc = read(0, &c, 1);
 240:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 247:	00 
 248:	89 7c 24 04          	mov    %edi,0x4(%esp)
 24c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 253:	e8 04 01 00 00       	call   35c <read>
    if(cc < 1)
 258:	85 c0                	test   %eax,%eax
 25a:	7e 1d                	jle    279 <gets+0x49>
      break;
    buf[i++] = c;
 25c:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 260:	89 de                	mov    %ebx,%esi
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
 262:	8b 55 08             	mov    0x8(%ebp),%edx
    if(c == '\n' || c == '\r')
 265:	3c 0d                	cmp    $0xd,%al

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
 267:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 26b:	74 0c                	je     279 <gets+0x49>
 26d:	3c 0a                	cmp    $0xa,%al
 26f:	74 08                	je     279 <gets+0x49>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 271:	8d 5e 01             	lea    0x1(%esi),%ebx
 274:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 277:	7c c7                	jl     240 <gets+0x10>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 279:	8b 45 08             	mov    0x8(%ebp),%eax
 27c:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 280:	83 c4 2c             	add    $0x2c,%esp
 283:	5b                   	pop    %ebx
 284:	5e                   	pop    %esi
 285:	5f                   	pop    %edi
 286:	5d                   	pop    %ebp
 287:	c3                   	ret    
 288:	90                   	nop
 289:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000290 <stat>:

int
stat(char *n, struct stat *st)
{
 290:	55                   	push   %ebp
 291:	89 e5                	mov    %esp,%ebp
 293:	56                   	push   %esi
 294:	53                   	push   %ebx
 295:	83 ec 10             	sub    $0x10,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 298:	8b 45 08             	mov    0x8(%ebp),%eax
 29b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 2a2:	00 
 2a3:	89 04 24             	mov    %eax,(%esp)
 2a6:	e8 d9 00 00 00       	call   384 <open>
  if(fd < 0)
 2ab:	85 c0                	test   %eax,%eax
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2ad:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
 2af:	78 27                	js     2d8 <stat+0x48>
    return -1;
  r = fstat(fd, st);
 2b1:	8b 45 0c             	mov    0xc(%ebp),%eax
 2b4:	89 1c 24             	mov    %ebx,(%esp)
 2b7:	89 44 24 04          	mov    %eax,0x4(%esp)
 2bb:	e8 dc 00 00 00       	call   39c <fstat>
  close(fd);
 2c0:	89 1c 24             	mov    %ebx,(%esp)
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
 2c3:	89 c6                	mov    %eax,%esi
  close(fd);
 2c5:	e8 a2 00 00 00       	call   36c <close>
  return r;
 2ca:	89 f0                	mov    %esi,%eax
}
 2cc:	83 c4 10             	add    $0x10,%esp
 2cf:	5b                   	pop    %ebx
 2d0:	5e                   	pop    %esi
 2d1:	5d                   	pop    %ebp
 2d2:	c3                   	ret    
 2d3:	90                   	nop
 2d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
 2d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2dd:	eb ed                	jmp    2cc <stat+0x3c>
 2df:	90                   	nop

000002e0 <atoi>:
  return r;
}

int
atoi(const char *s)
{
 2e0:	55                   	push   %ebp
 2e1:	89 e5                	mov    %esp,%ebp
 2e3:	8b 4d 08             	mov    0x8(%ebp),%ecx
 2e6:	53                   	push   %ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2e7:	0f be 11             	movsbl (%ecx),%edx
 2ea:	8d 42 d0             	lea    -0x30(%edx),%eax
 2ed:	3c 09                	cmp    $0x9,%al
int
atoi(const char *s)
{
  int n;

  n = 0;
 2ef:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 2f4:	77 17                	ja     30d <atoi+0x2d>
 2f6:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 2f8:	83 c1 01             	add    $0x1,%ecx
 2fb:	8d 04 80             	lea    (%eax,%eax,4),%eax
 2fe:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 302:	0f be 11             	movsbl (%ecx),%edx
 305:	8d 5a d0             	lea    -0x30(%edx),%ebx
 308:	80 fb 09             	cmp    $0x9,%bl
 30b:	76 eb                	jbe    2f8 <atoi+0x18>
    n = n*10 + *s++ - '0';
  return n;
}
 30d:	5b                   	pop    %ebx
 30e:	5d                   	pop    %ebp
 30f:	c3                   	ret    

00000310 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 310:	55                   	push   %ebp
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 311:	31 d2                	xor    %edx,%edx
  return n;
}

void*
memmove(void *vdst, void *vsrc, int n)
{
 313:	89 e5                	mov    %esp,%ebp
 315:	56                   	push   %esi
 316:	8b 45 08             	mov    0x8(%ebp),%eax
 319:	53                   	push   %ebx
 31a:	8b 5d 10             	mov    0x10(%ebp),%ebx
 31d:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 320:	85 db                	test   %ebx,%ebx
 322:	7e 12                	jle    336 <memmove+0x26>
 324:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 328:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 32c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 32f:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 332:	39 da                	cmp    %ebx,%edx
 334:	75 f2                	jne    328 <memmove+0x18>
    *dst++ = *src++;
  return vdst;
}
 336:	5b                   	pop    %ebx
 337:	5e                   	pop    %esi
 338:	5d                   	pop    %ebp
 339:	c3                   	ret    
 33a:	90                   	nop
 33b:	90                   	nop

0000033c <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 33c:	b8 01 00 00 00       	mov    $0x1,%eax
 341:	cd 40                	int    $0x40
 343:	c3                   	ret    

00000344 <exit>:
SYSCALL(exit)
 344:	b8 02 00 00 00       	mov    $0x2,%eax
 349:	cd 40                	int    $0x40
 34b:	c3                   	ret    

0000034c <wait>:
SYSCALL(wait)
 34c:	b8 03 00 00 00       	mov    $0x3,%eax
 351:	cd 40                	int    $0x40
 353:	c3                   	ret    

00000354 <pipe>:
SYSCALL(pipe)
 354:	b8 04 00 00 00       	mov    $0x4,%eax
 359:	cd 40                	int    $0x40
 35b:	c3                   	ret    

0000035c <read>:
SYSCALL(read)
 35c:	b8 05 00 00 00       	mov    $0x5,%eax
 361:	cd 40                	int    $0x40
 363:	c3                   	ret    

00000364 <write>:
SYSCALL(write)
 364:	b8 10 00 00 00       	mov    $0x10,%eax
 369:	cd 40                	int    $0x40
 36b:	c3                   	ret    

0000036c <close>:
SYSCALL(close)
 36c:	b8 15 00 00 00       	mov    $0x15,%eax
 371:	cd 40                	int    $0x40
 373:	c3                   	ret    

00000374 <kill>:
SYSCALL(kill)
 374:	b8 06 00 00 00       	mov    $0x6,%eax
 379:	cd 40                	int    $0x40
 37b:	c3                   	ret    

0000037c <exec>:
SYSCALL(exec)
 37c:	b8 07 00 00 00       	mov    $0x7,%eax
 381:	cd 40                	int    $0x40
 383:	c3                   	ret    

00000384 <open>:
SYSCALL(open)
 384:	b8 0f 00 00 00       	mov    $0xf,%eax
 389:	cd 40                	int    $0x40
 38b:	c3                   	ret    

0000038c <mknod>:
SYSCALL(mknod)
 38c:	b8 11 00 00 00       	mov    $0x11,%eax
 391:	cd 40                	int    $0x40
 393:	c3                   	ret    

00000394 <unlink>:
SYSCALL(unlink)
 394:	b8 12 00 00 00       	mov    $0x12,%eax
 399:	cd 40                	int    $0x40
 39b:	c3                   	ret    

0000039c <fstat>:
SYSCALL(fstat)
 39c:	b8 08 00 00 00       	mov    $0x8,%eax
 3a1:	cd 40                	int    $0x40
 3a3:	c3                   	ret    

000003a4 <link>:
SYSCALL(link)
 3a4:	b8 13 00 00 00       	mov    $0x13,%eax
 3a9:	cd 40                	int    $0x40
 3ab:	c3                   	ret    

000003ac <mkdir>:
SYSCALL(mkdir)
 3ac:	b8 14 00 00 00       	mov    $0x14,%eax
 3b1:	cd 40                	int    $0x40
 3b3:	c3                   	ret    

000003b4 <chdir>:
SYSCALL(chdir)
 3b4:	b8 09 00 00 00       	mov    $0x9,%eax
 3b9:	cd 40                	int    $0x40
 3bb:	c3                   	ret    

000003bc <dup>:
SYSCALL(dup)
 3bc:	b8 0a 00 00 00       	mov    $0xa,%eax
 3c1:	cd 40                	int    $0x40
 3c3:	c3                   	ret    

000003c4 <getpid>:
SYSCALL(getpid)
 3c4:	b8 0b 00 00 00       	mov    $0xb,%eax
 3c9:	cd 40                	int    $0x40
 3cb:	c3                   	ret    

000003cc <sbrk>:
SYSCALL(sbrk)
 3cc:	b8 0c 00 00 00       	mov    $0xc,%eax
 3d1:	cd 40                	int    $0x40
 3d3:	c3                   	ret    

000003d4 <sleep>:
SYSCALL(sleep)
 3d4:	b8 0d 00 00 00       	mov    $0xd,%eax
 3d9:	cd 40                	int    $0x40
 3db:	c3                   	ret    

000003dc <uptime>:
SYSCALL(uptime)
 3dc:	b8 0e 00 00 00       	mov    $0xe,%eax
 3e1:	cd 40                	int    $0x40
 3e3:	c3                   	ret    

000003e4 <date>:
SYSCALL(date)
 3e4:	b8 16 00 00 00       	mov    $0x16,%eax
 3e9:	cd 40                	int    $0x40
 3eb:	c3                   	ret    

000003ec <dup2>:
SYSCALL(dup2)
 3ec:	b8 17 00 00 00       	mov    $0x17,%eax
 3f1:	cd 40                	int    $0x40
 3f3:	c3                   	ret    
 3f4:	90                   	nop
 3f5:	90                   	nop
 3f6:	90                   	nop
 3f7:	90                   	nop
 3f8:	90                   	nop
 3f9:	90                   	nop
 3fa:	90                   	nop
 3fb:	90                   	nop
 3fc:	90                   	nop
 3fd:	90                   	nop
 3fe:	90                   	nop
 3ff:	90                   	nop

00000400 <printint>:
 400:	55                   	push   %ebp
 401:	89 e5                	mov    %esp,%ebp
 403:	57                   	push   %edi
 404:	56                   	push   %esi
 405:	89 c6                	mov    %eax,%esi
 407:	53                   	push   %ebx
 408:	83 ec 4c             	sub    $0x4c,%esp
 40b:	8b 5d 08             	mov    0x8(%ebp),%ebx
 40e:	85 db                	test   %ebx,%ebx
 410:	74 09                	je     41b <printint+0x1b>
 412:	89 d0                	mov    %edx,%eax
 414:	c1 e8 1f             	shr    $0x1f,%eax
 417:	84 c0                	test   %al,%al
 419:	75 75                	jne    490 <printint+0x90>
 41b:	89 d0                	mov    %edx,%eax
 41d:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 424:	89 75 c0             	mov    %esi,-0x40(%ebp)
 427:	31 ff                	xor    %edi,%edi
 429:	89 ce                	mov    %ecx,%esi
 42b:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 42e:	eb 02                	jmp    432 <printint+0x32>
 430:	89 cf                	mov    %ecx,%edi
 432:	31 d2                	xor    %edx,%edx
 434:	f7 f6                	div    %esi
 436:	8d 4f 01             	lea    0x1(%edi),%ecx
 439:	0f b6 92 45 08 00 00 	movzbl 0x845(%edx),%edx
 440:	85 c0                	test   %eax,%eax
 442:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
 445:	75 e9                	jne    430 <printint+0x30>
 447:	8b 55 c4             	mov    -0x3c(%ebp),%edx
 44a:	89 c8                	mov    %ecx,%eax
 44c:	8b 75 c0             	mov    -0x40(%ebp),%esi
 44f:	85 d2                	test   %edx,%edx
 451:	74 08                	je     45b <printint+0x5b>
 453:	8d 4f 02             	lea    0x2(%edi),%ecx
 456:	c6 44 05 d8 2d       	movb   $0x2d,-0x28(%ebp,%eax,1)
 45b:	8d 79 ff             	lea    -0x1(%ecx),%edi
 45e:	66 90                	xchg   %ax,%ax
 460:	0f b6 44 3d d8       	movzbl -0x28(%ebp,%edi,1),%eax
 465:	83 ef 01             	sub    $0x1,%edi
 468:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 46f:	00 
 470:	89 5c 24 04          	mov    %ebx,0x4(%esp)
 474:	89 34 24             	mov    %esi,(%esp)
 477:	88 45 d7             	mov    %al,-0x29(%ebp)
 47a:	e8 e5 fe ff ff       	call   364 <write>
 47f:	83 ff ff             	cmp    $0xffffffff,%edi
 482:	75 dc                	jne    460 <printint+0x60>
 484:	83 c4 4c             	add    $0x4c,%esp
 487:	5b                   	pop    %ebx
 488:	5e                   	pop    %esi
 489:	5f                   	pop    %edi
 48a:	5d                   	pop    %ebp
 48b:	c3                   	ret    
 48c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 490:	89 d0                	mov    %edx,%eax
 492:	f7 d8                	neg    %eax
 494:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
 49b:	eb 87                	jmp    424 <printint+0x24>
 49d:	8d 76 00             	lea    0x0(%esi),%esi

000004a0 <printf>:
 4a0:	55                   	push   %ebp
 4a1:	89 e5                	mov    %esp,%ebp
 4a3:	57                   	push   %edi
 4a4:	31 ff                	xor    %edi,%edi
 4a6:	56                   	push   %esi
 4a7:	53                   	push   %ebx
 4a8:	83 ec 3c             	sub    $0x3c,%esp
 4ab:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 4ae:	8d 45 10             	lea    0x10(%ebp),%eax
 4b1:	8b 75 08             	mov    0x8(%ebp),%esi
 4b4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 4b7:	0f b6 13             	movzbl (%ebx),%edx
 4ba:	83 c3 01             	add    $0x1,%ebx
 4bd:	84 d2                	test   %dl,%dl
 4bf:	75 39                	jne    4fa <printf+0x5a>
 4c1:	e9 c2 00 00 00       	jmp    588 <printf+0xe8>
 4c6:	66 90                	xchg   %ax,%ax
 4c8:	83 fa 25             	cmp    $0x25,%edx
 4cb:	0f 84 bf 00 00 00    	je     590 <printf+0xf0>
 4d1:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 4d4:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4db:	00 
 4dc:	89 44 24 04          	mov    %eax,0x4(%esp)
 4e0:	89 34 24             	mov    %esi,(%esp)
 4e3:	88 55 e2             	mov    %dl,-0x1e(%ebp)
 4e6:	e8 79 fe ff ff       	call   364 <write>
 4eb:	83 c3 01             	add    $0x1,%ebx
 4ee:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
 4f2:	84 d2                	test   %dl,%dl
 4f4:	0f 84 8e 00 00 00    	je     588 <printf+0xe8>
 4fa:	85 ff                	test   %edi,%edi
 4fc:	0f be c2             	movsbl %dl,%eax
 4ff:	74 c7                	je     4c8 <printf+0x28>
 501:	83 ff 25             	cmp    $0x25,%edi
 504:	75 e5                	jne    4eb <printf+0x4b>
 506:	83 fa 64             	cmp    $0x64,%edx
 509:	0f 84 31 01 00 00    	je     640 <printf+0x1a0>
 50f:	25 f7 00 00 00       	and    $0xf7,%eax
 514:	83 f8 70             	cmp    $0x70,%eax
 517:	0f 84 83 00 00 00    	je     5a0 <printf+0x100>
 51d:	83 fa 73             	cmp    $0x73,%edx
 520:	0f 84 a2 00 00 00    	je     5c8 <printf+0x128>
 526:	83 fa 63             	cmp    $0x63,%edx
 529:	0f 84 35 01 00 00    	je     664 <printf+0x1c4>
 52f:	83 fa 25             	cmp    $0x25,%edx
 532:	0f 84 e0 00 00 00    	je     618 <printf+0x178>
 538:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 53b:	83 c3 01             	add    $0x1,%ebx
 53e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 545:	00 
 546:	31 ff                	xor    %edi,%edi
 548:	89 44 24 04          	mov    %eax,0x4(%esp)
 54c:	89 34 24             	mov    %esi,(%esp)
 54f:	89 55 d0             	mov    %edx,-0x30(%ebp)
 552:	c6 45 e6 25          	movb   $0x25,-0x1a(%ebp)
 556:	e8 09 fe ff ff       	call   364 <write>
 55b:	8b 55 d0             	mov    -0x30(%ebp),%edx
 55e:	8d 45 e7             	lea    -0x19(%ebp),%eax
 561:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 568:	00 
 569:	89 44 24 04          	mov    %eax,0x4(%esp)
 56d:	89 34 24             	mov    %esi,(%esp)
 570:	88 55 e7             	mov    %dl,-0x19(%ebp)
 573:	e8 ec fd ff ff       	call   364 <write>
 578:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
 57c:	84 d2                	test   %dl,%dl
 57e:	0f 85 76 ff ff ff    	jne    4fa <printf+0x5a>
 584:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 588:	83 c4 3c             	add    $0x3c,%esp
 58b:	5b                   	pop    %ebx
 58c:	5e                   	pop    %esi
 58d:	5f                   	pop    %edi
 58e:	5d                   	pop    %ebp
 58f:	c3                   	ret    
 590:	bf 25 00 00 00       	mov    $0x25,%edi
 595:	e9 51 ff ff ff       	jmp    4eb <printf+0x4b>
 59a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 5a0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 5a3:	b9 10 00 00 00       	mov    $0x10,%ecx
 5a8:	31 ff                	xor    %edi,%edi
 5aa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 5b1:	8b 10                	mov    (%eax),%edx
 5b3:	89 f0                	mov    %esi,%eax
 5b5:	e8 46 fe ff ff       	call   400 <printint>
 5ba:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 5be:	e9 28 ff ff ff       	jmp    4eb <printf+0x4b>
 5c3:	90                   	nop
 5c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 5c8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 5cb:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 5cf:	8b 38                	mov    (%eax),%edi
 5d1:	b8 3e 08 00 00       	mov    $0x83e,%eax
 5d6:	85 ff                	test   %edi,%edi
 5d8:	0f 44 f8             	cmove  %eax,%edi
 5db:	0f b6 07             	movzbl (%edi),%eax
 5de:	84 c0                	test   %al,%al
 5e0:	74 2a                	je     60c <printf+0x16c>
 5e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 5e8:	88 45 e3             	mov    %al,-0x1d(%ebp)
 5eb:	8d 45 e3             	lea    -0x1d(%ebp),%eax
 5ee:	83 c7 01             	add    $0x1,%edi
 5f1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 5f8:	00 
 5f9:	89 44 24 04          	mov    %eax,0x4(%esp)
 5fd:	89 34 24             	mov    %esi,(%esp)
 600:	e8 5f fd ff ff       	call   364 <write>
 605:	0f b6 07             	movzbl (%edi),%eax
 608:	84 c0                	test   %al,%al
 60a:	75 dc                	jne    5e8 <printf+0x148>
 60c:	31 ff                	xor    %edi,%edi
 60e:	e9 d8 fe ff ff       	jmp    4eb <printf+0x4b>
 613:	90                   	nop
 614:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 618:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 61b:	31 ff                	xor    %edi,%edi
 61d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 624:	00 
 625:	89 44 24 04          	mov    %eax,0x4(%esp)
 629:	89 34 24             	mov    %esi,(%esp)
 62c:	c6 45 e5 25          	movb   $0x25,-0x1b(%ebp)
 630:	e8 2f fd ff ff       	call   364 <write>
 635:	e9 b1 fe ff ff       	jmp    4eb <printf+0x4b>
 63a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 640:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 643:	b9 0a 00 00 00       	mov    $0xa,%ecx
 648:	66 31 ff             	xor    %di,%di
 64b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 652:	8b 10                	mov    (%eax),%edx
 654:	89 f0                	mov    %esi,%eax
 656:	e8 a5 fd ff ff       	call   400 <printint>
 65b:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 65f:	e9 87 fe ff ff       	jmp    4eb <printf+0x4b>
 664:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 667:	31 ff                	xor    %edi,%edi
 669:	8b 00                	mov    (%eax),%eax
 66b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 672:	00 
 673:	89 34 24             	mov    %esi,(%esp)
 676:	88 45 e4             	mov    %al,-0x1c(%ebp)
 679:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 67c:	89 44 24 04          	mov    %eax,0x4(%esp)
 680:	e8 df fc ff ff       	call   364 <write>
 685:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 689:	e9 5d fe ff ff       	jmp    4eb <printf+0x4b>
 68e:	90                   	nop
 68f:	90                   	nop

00000690 <free>:
 690:	55                   	push   %ebp
 691:	a1 00 0b 00 00       	mov    0xb00,%eax
 696:	89 e5                	mov    %esp,%ebp
 698:	57                   	push   %edi
 699:	56                   	push   %esi
 69a:	53                   	push   %ebx
 69b:	8b 5d 08             	mov    0x8(%ebp),%ebx
 69e:	8b 08                	mov    (%eax),%ecx
 6a0:	8d 53 f8             	lea    -0x8(%ebx),%edx
 6a3:	39 d0                	cmp    %edx,%eax
 6a5:	72 11                	jb     6b8 <free+0x28>
 6a7:	90                   	nop
 6a8:	39 c8                	cmp    %ecx,%eax
 6aa:	72 04                	jb     6b0 <free+0x20>
 6ac:	39 ca                	cmp    %ecx,%edx
 6ae:	72 10                	jb     6c0 <free+0x30>
 6b0:	89 c8                	mov    %ecx,%eax
 6b2:	39 d0                	cmp    %edx,%eax
 6b4:	8b 08                	mov    (%eax),%ecx
 6b6:	73 f0                	jae    6a8 <free+0x18>
 6b8:	39 ca                	cmp    %ecx,%edx
 6ba:	72 04                	jb     6c0 <free+0x30>
 6bc:	39 c8                	cmp    %ecx,%eax
 6be:	72 f0                	jb     6b0 <free+0x20>
 6c0:	8b 73 fc             	mov    -0x4(%ebx),%esi
 6c3:	8d 3c f2             	lea    (%edx,%esi,8),%edi
 6c6:	39 cf                	cmp    %ecx,%edi
 6c8:	74 1e                	je     6e8 <free+0x58>
 6ca:	89 4b f8             	mov    %ecx,-0x8(%ebx)
 6cd:	8b 48 04             	mov    0x4(%eax),%ecx
 6d0:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
 6d3:	39 f2                	cmp    %esi,%edx
 6d5:	74 28                	je     6ff <free+0x6f>
 6d7:	89 10                	mov    %edx,(%eax)
 6d9:	a3 00 0b 00 00       	mov    %eax,0xb00
 6de:	5b                   	pop    %ebx
 6df:	5e                   	pop    %esi
 6e0:	5f                   	pop    %edi
 6e1:	5d                   	pop    %ebp
 6e2:	c3                   	ret    
 6e3:	90                   	nop
 6e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 6e8:	03 71 04             	add    0x4(%ecx),%esi
 6eb:	89 73 fc             	mov    %esi,-0x4(%ebx)
 6ee:	8b 08                	mov    (%eax),%ecx
 6f0:	8b 09                	mov    (%ecx),%ecx
 6f2:	89 4b f8             	mov    %ecx,-0x8(%ebx)
 6f5:	8b 48 04             	mov    0x4(%eax),%ecx
 6f8:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
 6fb:	39 f2                	cmp    %esi,%edx
 6fd:	75 d8                	jne    6d7 <free+0x47>
 6ff:	03 4b fc             	add    -0x4(%ebx),%ecx
 702:	a3 00 0b 00 00       	mov    %eax,0xb00
 707:	89 48 04             	mov    %ecx,0x4(%eax)
 70a:	8b 53 f8             	mov    -0x8(%ebx),%edx
 70d:	89 10                	mov    %edx,(%eax)
 70f:	5b                   	pop    %ebx
 710:	5e                   	pop    %esi
 711:	5f                   	pop    %edi
 712:	5d                   	pop    %ebp
 713:	c3                   	ret    
 714:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 71a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000720 <malloc>:
 720:	55                   	push   %ebp
 721:	89 e5                	mov    %esp,%ebp
 723:	57                   	push   %edi
 724:	56                   	push   %esi
 725:	53                   	push   %ebx
 726:	83 ec 1c             	sub    $0x1c,%esp
 729:	8b 45 08             	mov    0x8(%ebp),%eax
 72c:	8b 1d 00 0b 00 00    	mov    0xb00,%ebx
 732:	8d 48 07             	lea    0x7(%eax),%ecx
 735:	c1 e9 03             	shr    $0x3,%ecx
 738:	85 db                	test   %ebx,%ebx
 73a:	8d 71 01             	lea    0x1(%ecx),%esi
 73d:	0f 84 9b 00 00 00    	je     7de <malloc+0xbe>
 743:	8b 13                	mov    (%ebx),%edx
 745:	8b 7a 04             	mov    0x4(%edx),%edi
 748:	39 fe                	cmp    %edi,%esi
 74a:	76 64                	jbe    7b0 <malloc+0x90>
 74c:	8d 04 f5 00 00 00 00 	lea    0x0(,%esi,8),%eax
 753:	bb 00 80 00 00       	mov    $0x8000,%ebx
 758:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 75b:	eb 0e                	jmp    76b <malloc+0x4b>
 75d:	8d 76 00             	lea    0x0(%esi),%esi
 760:	8b 02                	mov    (%edx),%eax
 762:	8b 78 04             	mov    0x4(%eax),%edi
 765:	39 fe                	cmp    %edi,%esi
 767:	76 4f                	jbe    7b8 <malloc+0x98>
 769:	89 c2                	mov    %eax,%edx
 76b:	3b 15 00 0b 00 00    	cmp    0xb00,%edx
 771:	75 ed                	jne    760 <malloc+0x40>
 773:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 776:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 77c:	bf 00 10 00 00       	mov    $0x1000,%edi
 781:	0f 43 fe             	cmovae %esi,%edi
 784:	0f 42 c3             	cmovb  %ebx,%eax
 787:	89 04 24             	mov    %eax,(%esp)
 78a:	e8 3d fc ff ff       	call   3cc <sbrk>
 78f:	83 f8 ff             	cmp    $0xffffffff,%eax
 792:	74 18                	je     7ac <malloc+0x8c>
 794:	89 78 04             	mov    %edi,0x4(%eax)
 797:	83 c0 08             	add    $0x8,%eax
 79a:	89 04 24             	mov    %eax,(%esp)
 79d:	e8 ee fe ff ff       	call   690 <free>
 7a2:	8b 15 00 0b 00 00    	mov    0xb00,%edx
 7a8:	85 d2                	test   %edx,%edx
 7aa:	75 b4                	jne    760 <malloc+0x40>
 7ac:	31 c0                	xor    %eax,%eax
 7ae:	eb 20                	jmp    7d0 <malloc+0xb0>
 7b0:	89 d0                	mov    %edx,%eax
 7b2:	89 da                	mov    %ebx,%edx
 7b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 7b8:	39 fe                	cmp    %edi,%esi
 7ba:	74 1c                	je     7d8 <malloc+0xb8>
 7bc:	29 f7                	sub    %esi,%edi
 7be:	89 78 04             	mov    %edi,0x4(%eax)
 7c1:	8d 04 f8             	lea    (%eax,%edi,8),%eax
 7c4:	89 70 04             	mov    %esi,0x4(%eax)
 7c7:	89 15 00 0b 00 00    	mov    %edx,0xb00
 7cd:	83 c0 08             	add    $0x8,%eax
 7d0:	83 c4 1c             	add    $0x1c,%esp
 7d3:	5b                   	pop    %ebx
 7d4:	5e                   	pop    %esi
 7d5:	5f                   	pop    %edi
 7d6:	5d                   	pop    %ebp
 7d7:	c3                   	ret    
 7d8:	8b 08                	mov    (%eax),%ecx
 7da:	89 0a                	mov    %ecx,(%edx)
 7dc:	eb e9                	jmp    7c7 <malloc+0xa7>
 7de:	c7 05 00 0b 00 00 04 	movl   $0xb04,0xb00
 7e5:	0b 00 00 
 7e8:	ba 04 0b 00 00       	mov    $0xb04,%edx
 7ed:	c7 05 04 0b 00 00 04 	movl   $0xb04,0xb04
 7f4:	0b 00 00 
 7f7:	c7 05 08 0b 00 00 00 	movl   $0x0,0xb08
 7fe:	00 00 00 
 801:	e9 46 ff ff ff       	jmp    74c <malloc+0x2c>
