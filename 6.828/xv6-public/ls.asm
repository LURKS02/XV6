
_ls:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
  close(fd);
}

int
main(int argc, char *argv[])
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	57                   	push   %edi
   4:	56                   	push   %esi
   5:	53                   	push   %ebx
  int i;

  if(argc < 2){
   6:	bb 01 00 00 00       	mov    $0x1,%ebx
  close(fd);
}

int
main(int argc, char *argv[])
{
   b:	83 e4 f0             	and    $0xfffffff0,%esp
   e:	83 ec 10             	sub    $0x10,%esp
  11:	8b 75 08             	mov    0x8(%ebp),%esi
  14:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  if(argc < 2){
  17:	83 fe 01             	cmp    $0x1,%esi
  1a:	7e 1b                	jle    37 <main+0x37>
  1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ls(".");
    exit();
  }
  for(i=1; i<argc; i++)
    ls(argv[i]);
  20:	8b 04 9f             	mov    (%edi,%ebx,4),%eax

  if(argc < 2){
    ls(".");
    exit();
  }
  for(i=1; i<argc; i++)
  23:	83 c3 01             	add    $0x1,%ebx
    ls(argv[i]);
  26:	89 04 24             	mov    %eax,(%esp)
  29:	e8 c2 00 00 00       	call   f0 <ls>

  if(argc < 2){
    ls(".");
    exit();
  }
  for(i=1; i<argc; i++)
  2e:	39 f3                	cmp    %esi,%ebx
  30:	75 ee                	jne    20 <main+0x20>
    ls(argv[i]);
  exit();
  32:	e8 6d 05 00 00       	call   5a4 <exit>
main(int argc, char *argv[])
{
  int i;

  if(argc < 2){
    ls(".");
  37:	c7 04 24 ae 0a 00 00 	movl   $0xaae,(%esp)
  3e:	e8 ad 00 00 00       	call   f0 <ls>
    exit();
  43:	e8 5c 05 00 00       	call   5a4 <exit>
  48:	90                   	nop
  49:	90                   	nop
  4a:	90                   	nop
  4b:	90                   	nop
  4c:	90                   	nop
  4d:	90                   	nop
  4e:	90                   	nop
  4f:	90                   	nop

00000050 <fmtname>:
#include "user.h"
#include "fs.h"

char*
fmtname(char *path)
{
  50:	55                   	push   %ebp
  51:	89 e5                	mov    %esp,%ebp
  53:	56                   	push   %esi
  54:	53                   	push   %ebx
  55:	83 ec 10             	sub    $0x10,%esp
  58:	8b 5d 08             	mov    0x8(%ebp),%ebx
  static char buf[DIRSIZ+1];
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
  5b:	89 1c 24             	mov    %ebx,(%esp)
  5e:	e8 9d 03 00 00       	call   400 <strlen>
  63:	01 d8                	add    %ebx,%eax
  65:	73 10                	jae    77 <fmtname+0x27>
  67:	eb 13                	jmp    7c <fmtname+0x2c>
  69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  70:	83 e8 01             	sub    $0x1,%eax
  73:	39 c3                	cmp    %eax,%ebx
  75:	77 05                	ja     7c <fmtname+0x2c>
  77:	80 38 2f             	cmpb   $0x2f,(%eax)
  7a:	75 f4                	jne    70 <fmtname+0x20>
    ;
  p++;
  7c:	8d 58 01             	lea    0x1(%eax),%ebx

  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
  7f:	89 1c 24             	mov    %ebx,(%esp)
  82:	e8 79 03 00 00       	call   400 <strlen>
  87:	83 f8 0d             	cmp    $0xd,%eax
  8a:	77 53                	ja     df <fmtname+0x8f>
    return p;
  memmove(buf, p, strlen(p));
  8c:	89 1c 24             	mov    %ebx,(%esp)
  8f:	e8 6c 03 00 00       	call   400 <strlen>
  94:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  98:	c7 04 24 98 0d 00 00 	movl   $0xd98,(%esp)
  9f:	89 44 24 08          	mov    %eax,0x8(%esp)
  a3:	e8 c8 04 00 00       	call   570 <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  a8:	89 1c 24             	mov    %ebx,(%esp)
  ab:	e8 50 03 00 00       	call   400 <strlen>
  b0:	89 1c 24             	mov    %ebx,(%esp)
  return buf;
  b3:	bb 98 0d 00 00       	mov    $0xd98,%ebx

  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
    return p;
  memmove(buf, p, strlen(p));
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  b8:	89 c6                	mov    %eax,%esi
  ba:	e8 41 03 00 00       	call   400 <strlen>
  bf:	ba 0e 00 00 00       	mov    $0xe,%edx
  c4:	29 f2                	sub    %esi,%edx
  c6:	89 54 24 08          	mov    %edx,0x8(%esp)
  ca:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
  d1:	00 
  d2:	05 98 0d 00 00       	add    $0xd98,%eax
  d7:	89 04 24             	mov    %eax,(%esp)
  da:	e8 51 03 00 00       	call   430 <memset>
  return buf;
}
  df:	83 c4 10             	add    $0x10,%esp
  e2:	89 d8                	mov    %ebx,%eax
  e4:	5b                   	pop    %ebx
  e5:	5e                   	pop    %esi
  e6:	5d                   	pop    %ebp
  e7:	c3                   	ret    
  e8:	90                   	nop
  e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000000f0 <ls>:

void
ls(char *path)
{
  f0:	55                   	push   %ebp
  f1:	89 e5                	mov    %esp,%ebp
  f3:	57                   	push   %edi
  f4:	56                   	push   %esi
  f5:	53                   	push   %ebx
  f6:	81 ec 6c 02 00 00    	sub    $0x26c,%esp
  fc:	8b 7d 08             	mov    0x8(%ebp),%edi
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, 0)) < 0){
  ff:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 106:	00 
 107:	89 3c 24             	mov    %edi,(%esp)
 10a:	e8 d5 04 00 00       	call   5e4 <open>
 10f:	85 c0                	test   %eax,%eax
 111:	89 c3                	mov    %eax,%ebx
 113:	0f 88 c7 01 00 00    	js     2e0 <ls+0x1f0>
    printf(2, "ls: cannot open %s\n", path);
    return;
  }

  if(fstat(fd, &st) < 0){
 119:	8d b5 d4 fd ff ff    	lea    -0x22c(%ebp),%esi
 11f:	89 74 24 04          	mov    %esi,0x4(%esp)
 123:	89 04 24             	mov    %eax,(%esp)
 126:	e8 d1 04 00 00       	call   5fc <fstat>
 12b:	85 c0                	test   %eax,%eax
 12d:	0f 88 f5 01 00 00    	js     328 <ls+0x238>
    printf(2, "ls: cannot stat %s\n", path);
    close(fd);
    return;
  }

  switch(st.type){
 133:	0f b7 85 d4 fd ff ff 	movzwl -0x22c(%ebp),%eax
 13a:	66 83 f8 01          	cmp    $0x1,%ax
 13e:	74 68                	je     1a8 <ls+0xb8>
 140:	66 83 f8 02          	cmp    $0x2,%ax
 144:	75 48                	jne    18e <ls+0x9e>
  case T_FILE:
    printf(1, "%s %d %d %d\n", fmtname(path), st.type, st.ino, st.size);
 146:	8b 95 e4 fd ff ff    	mov    -0x21c(%ebp),%edx
 14c:	89 3c 24             	mov    %edi,(%esp)
 14f:	8b b5 dc fd ff ff    	mov    -0x224(%ebp),%esi
 155:	89 95 b4 fd ff ff    	mov    %edx,-0x24c(%ebp)
 15b:	e8 f0 fe ff ff       	call   50 <fmtname>
 160:	8b 95 b4 fd ff ff    	mov    -0x24c(%ebp),%edx
 166:	89 74 24 10          	mov    %esi,0x10(%esp)
 16a:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
 171:	00 
 172:	c7 44 24 04 8e 0a 00 	movl   $0xa8e,0x4(%esp)
 179:	00 
 17a:	89 54 24 14          	mov    %edx,0x14(%esp)
 17e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 185:	89 44 24 08          	mov    %eax,0x8(%esp)
 189:	e8 72 05 00 00       	call   700 <printf>
      }
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
    }
    break;
  }
  close(fd);
 18e:	89 1c 24             	mov    %ebx,(%esp)
 191:	e8 36 04 00 00       	call   5cc <close>
}
 196:	81 c4 6c 02 00 00    	add    $0x26c,%esp
 19c:	5b                   	pop    %ebx
 19d:	5e                   	pop    %esi
 19e:	5f                   	pop    %edi
 19f:	5d                   	pop    %ebp
 1a0:	c3                   	ret    
 1a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  case T_FILE:
    printf(1, "%s %d %d %d\n", fmtname(path), st.type, st.ino, st.size);
    break;

  case T_DIR:
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 1a8:	89 3c 24             	mov    %edi,(%esp)
 1ab:	e8 50 02 00 00       	call   400 <strlen>
 1b0:	83 c0 10             	add    $0x10,%eax
 1b3:	3d 00 02 00 00       	cmp    $0x200,%eax
 1b8:	0f 87 4a 01 00 00    	ja     308 <ls+0x218>
      printf(1, "ls: path too long\n");
      break;
    }
    strcpy(buf, path);
 1be:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
 1c4:	89 7c 24 04          	mov    %edi,0x4(%esp)
 1c8:	8d bd c4 fd ff ff    	lea    -0x23c(%ebp),%edi
 1ce:	89 04 24             	mov    %eax,(%esp)
 1d1:	e8 aa 01 00 00       	call   380 <strcpy>
    p = buf+strlen(buf);
 1d6:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
 1dc:	89 04 24             	mov    %eax,(%esp)
 1df:	e8 1c 02 00 00       	call   400 <strlen>
 1e4:	8d 8d e8 fd ff ff    	lea    -0x218(%ebp),%ecx
 1ea:	01 c8                	add    %ecx,%eax
    *p++ = '/';
 1ec:	8d 48 01             	lea    0x1(%eax),%ecx
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
      printf(1, "ls: path too long\n");
      break;
    }
    strcpy(buf, path);
    p = buf+strlen(buf);
 1ef:	89 85 a8 fd ff ff    	mov    %eax,-0x258(%ebp)
    *p++ = '/';
 1f5:	89 8d a4 fd ff ff    	mov    %ecx,-0x25c(%ebp)
 1fb:	c6 00 2f             	movb   $0x2f,(%eax)
 1fe:	66 90                	xchg   %ax,%ax
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 200:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 207:	00 
 208:	89 7c 24 04          	mov    %edi,0x4(%esp)
 20c:	89 1c 24             	mov    %ebx,(%esp)
 20f:	e8 a8 03 00 00       	call   5bc <read>
 214:	83 f8 10             	cmp    $0x10,%eax
 217:	0f 85 71 ff ff ff    	jne    18e <ls+0x9e>
      if(de.inum == 0)
 21d:	66 83 bd c4 fd ff ff 	cmpw   $0x0,-0x23c(%ebp)
 224:	00 
 225:	74 d9                	je     200 <ls+0x110>
        continue;
      memmove(p, de.name, DIRSIZ);
 227:	8d 85 c6 fd ff ff    	lea    -0x23a(%ebp),%eax
 22d:	89 44 24 04          	mov    %eax,0x4(%esp)
 231:	8b 85 a4 fd ff ff    	mov    -0x25c(%ebp),%eax
 237:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
 23e:	00 
 23f:	89 04 24             	mov    %eax,(%esp)
 242:	e8 29 03 00 00       	call   570 <memmove>
      p[DIRSIZ] = 0;
 247:	8b 85 a8 fd ff ff    	mov    -0x258(%ebp),%eax
 24d:	c6 40 0f 00          	movb   $0x0,0xf(%eax)
      if(stat(buf, &st) < 0){
 251:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
 257:	89 74 24 04          	mov    %esi,0x4(%esp)
 25b:	89 04 24             	mov    %eax,(%esp)
 25e:	e8 8d 02 00 00       	call   4f0 <stat>
 263:	85 c0                	test   %eax,%eax
 265:	0f 88 e5 00 00 00    	js     350 <ls+0x260>
        printf(1, "ls: cannot stat %s\n", buf);
        continue;
      }
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 26b:	0f bf 95 d4 fd ff ff 	movswl -0x22c(%ebp),%edx
 272:	8b 8d e4 fd ff ff    	mov    -0x21c(%ebp),%ecx
 278:	8b 85 dc fd ff ff    	mov    -0x224(%ebp),%eax
 27e:	89 95 b0 fd ff ff    	mov    %edx,-0x250(%ebp)
 284:	8d 95 e8 fd ff ff    	lea    -0x218(%ebp),%edx
 28a:	89 14 24             	mov    %edx,(%esp)
 28d:	89 8d ac fd ff ff    	mov    %ecx,-0x254(%ebp)
 293:	89 85 b4 fd ff ff    	mov    %eax,-0x24c(%ebp)
 299:	e8 b2 fd ff ff       	call   50 <fmtname>
 29e:	8b 8d ac fd ff ff    	mov    -0x254(%ebp),%ecx
 2a4:	8b 95 b0 fd ff ff    	mov    -0x250(%ebp),%edx
 2aa:	c7 44 24 04 8e 0a 00 	movl   $0xa8e,0x4(%esp)
 2b1:	00 
 2b2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 2b9:	89 4c 24 14          	mov    %ecx,0x14(%esp)
 2bd:	8b 8d b4 fd ff ff    	mov    -0x24c(%ebp),%ecx
 2c3:	89 54 24 0c          	mov    %edx,0xc(%esp)
 2c7:	89 44 24 08          	mov    %eax,0x8(%esp)
 2cb:	89 4c 24 10          	mov    %ecx,0x10(%esp)
 2cf:	e8 2c 04 00 00       	call   700 <printf>
 2d4:	e9 27 ff ff ff       	jmp    200 <ls+0x110>
 2d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, 0)) < 0){
    printf(2, "ls: cannot open %s\n", path);
 2e0:	89 7c 24 08          	mov    %edi,0x8(%esp)
 2e4:	c7 44 24 04 66 0a 00 	movl   $0xa66,0x4(%esp)
 2eb:	00 
 2ec:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 2f3:	e8 08 04 00 00       	call   700 <printf>
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
    }
    break;
  }
  close(fd);
}
 2f8:	81 c4 6c 02 00 00    	add    $0x26c,%esp
 2fe:	5b                   	pop    %ebx
 2ff:	5e                   	pop    %esi
 300:	5f                   	pop    %edi
 301:	5d                   	pop    %ebp
 302:	c3                   	ret    
 303:	90                   	nop
 304:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    printf(1, "%s %d %d %d\n", fmtname(path), st.type, st.ino, st.size);
    break;

  case T_DIR:
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
      printf(1, "ls: path too long\n");
 308:	c7 44 24 04 9b 0a 00 	movl   $0xa9b,0x4(%esp)
 30f:	00 
 310:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 317:	e8 e4 03 00 00       	call   700 <printf>
      break;
 31c:	e9 6d fe ff ff       	jmp    18e <ls+0x9e>
 321:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    printf(2, "ls: cannot open %s\n", path);
    return;
  }

  if(fstat(fd, &st) < 0){
    printf(2, "ls: cannot stat %s\n", path);
 328:	89 7c 24 08          	mov    %edi,0x8(%esp)
 32c:	c7 44 24 04 7a 0a 00 	movl   $0xa7a,0x4(%esp)
 333:	00 
 334:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 33b:	e8 c0 03 00 00       	call   700 <printf>
    close(fd);
 340:	89 1c 24             	mov    %ebx,(%esp)
 343:	e8 84 02 00 00       	call   5cc <close>
    return;
 348:	e9 49 fe ff ff       	jmp    196 <ls+0xa6>
 34d:	8d 76 00             	lea    0x0(%esi),%esi
      if(de.inum == 0)
        continue;
      memmove(p, de.name, DIRSIZ);
      p[DIRSIZ] = 0;
      if(stat(buf, &st) < 0){
        printf(1, "ls: cannot stat %s\n", buf);
 350:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
 356:	89 44 24 08          	mov    %eax,0x8(%esp)
 35a:	c7 44 24 04 7a 0a 00 	movl   $0xa7a,0x4(%esp)
 361:	00 
 362:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 369:	e8 92 03 00 00       	call   700 <printf>
        continue;
 36e:	e9 8d fe ff ff       	jmp    200 <ls+0x110>
 373:	90                   	nop
 374:	90                   	nop
 375:	90                   	nop
 376:	90                   	nop
 377:	90                   	nop
 378:	90                   	nop
 379:	90                   	nop
 37a:	90                   	nop
 37b:	90                   	nop
 37c:	90                   	nop
 37d:	90                   	nop
 37e:	90                   	nop
 37f:	90                   	nop

00000380 <strcpy>:
 380:	55                   	push   %ebp
 381:	89 e5                	mov    %esp,%ebp
 383:	8b 45 08             	mov    0x8(%ebp),%eax
 386:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 389:	53                   	push   %ebx
 38a:	89 c2                	mov    %eax,%edx
 38c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 390:	83 c1 01             	add    $0x1,%ecx
 393:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 397:	83 c2 01             	add    $0x1,%edx
 39a:	84 db                	test   %bl,%bl
 39c:	88 5a ff             	mov    %bl,-0x1(%edx)
 39f:	75 ef                	jne    390 <strcpy+0x10>
 3a1:	5b                   	pop    %ebx
 3a2:	5d                   	pop    %ebp
 3a3:	c3                   	ret    
 3a4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 3aa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000003b0 <strcmp>:
 3b0:	55                   	push   %ebp
 3b1:	89 e5                	mov    %esp,%ebp
 3b3:	8b 55 08             	mov    0x8(%ebp),%edx
 3b6:	53                   	push   %ebx
 3b7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 3ba:	0f b6 02             	movzbl (%edx),%eax
 3bd:	84 c0                	test   %al,%al
 3bf:	74 2d                	je     3ee <strcmp+0x3e>
 3c1:	0f b6 19             	movzbl (%ecx),%ebx
 3c4:	38 d8                	cmp    %bl,%al
 3c6:	74 0e                	je     3d6 <strcmp+0x26>
 3c8:	eb 2b                	jmp    3f5 <strcmp+0x45>
 3ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 3d0:	38 c8                	cmp    %cl,%al
 3d2:	75 15                	jne    3e9 <strcmp+0x39>
 3d4:	89 d9                	mov    %ebx,%ecx
 3d6:	83 c2 01             	add    $0x1,%edx
 3d9:	0f b6 02             	movzbl (%edx),%eax
 3dc:	8d 59 01             	lea    0x1(%ecx),%ebx
 3df:	0f b6 49 01          	movzbl 0x1(%ecx),%ecx
 3e3:	84 c0                	test   %al,%al
 3e5:	75 e9                	jne    3d0 <strcmp+0x20>
 3e7:	31 c0                	xor    %eax,%eax
 3e9:	29 c8                	sub    %ecx,%eax
 3eb:	5b                   	pop    %ebx
 3ec:	5d                   	pop    %ebp
 3ed:	c3                   	ret    
 3ee:	0f b6 09             	movzbl (%ecx),%ecx
 3f1:	31 c0                	xor    %eax,%eax
 3f3:	eb f4                	jmp    3e9 <strcmp+0x39>
 3f5:	0f b6 cb             	movzbl %bl,%ecx
 3f8:	eb ef                	jmp    3e9 <strcmp+0x39>
 3fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000400 <strlen>:
 400:	55                   	push   %ebp
 401:	89 e5                	mov    %esp,%ebp
 403:	8b 4d 08             	mov    0x8(%ebp),%ecx
 406:	80 39 00             	cmpb   $0x0,(%ecx)
 409:	74 12                	je     41d <strlen+0x1d>
 40b:	31 d2                	xor    %edx,%edx
 40d:	8d 76 00             	lea    0x0(%esi),%esi
 410:	83 c2 01             	add    $0x1,%edx
 413:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 417:	89 d0                	mov    %edx,%eax
 419:	75 f5                	jne    410 <strlen+0x10>
 41b:	5d                   	pop    %ebp
 41c:	c3                   	ret    
 41d:	31 c0                	xor    %eax,%eax
 41f:	5d                   	pop    %ebp
 420:	c3                   	ret    
 421:	eb 0d                	jmp    430 <memset>
 423:	90                   	nop
 424:	90                   	nop
 425:	90                   	nop
 426:	90                   	nop
 427:	90                   	nop
 428:	90                   	nop
 429:	90                   	nop
 42a:	90                   	nop
 42b:	90                   	nop
 42c:	90                   	nop
 42d:	90                   	nop
 42e:	90                   	nop
 42f:	90                   	nop

00000430 <memset>:
 430:	55                   	push   %ebp
 431:	89 e5                	mov    %esp,%ebp
 433:	8b 55 08             	mov    0x8(%ebp),%edx
 436:	57                   	push   %edi
 437:	8b 4d 10             	mov    0x10(%ebp),%ecx
 43a:	8b 45 0c             	mov    0xc(%ebp),%eax
 43d:	89 d7                	mov    %edx,%edi
 43f:	fc                   	cld    
 440:	f3 aa                	rep stos %al,%es:(%edi)
 442:	89 d0                	mov    %edx,%eax
 444:	5f                   	pop    %edi
 445:	5d                   	pop    %ebp
 446:	c3                   	ret    
 447:	89 f6                	mov    %esi,%esi
 449:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000450 <strchr>:
 450:	55                   	push   %ebp
 451:	89 e5                	mov    %esp,%ebp
 453:	8b 45 08             	mov    0x8(%ebp),%eax
 456:	53                   	push   %ebx
 457:	8b 55 0c             	mov    0xc(%ebp),%edx
 45a:	0f b6 18             	movzbl (%eax),%ebx
 45d:	84 db                	test   %bl,%bl
 45f:	74 1d                	je     47e <strchr+0x2e>
 461:	38 d3                	cmp    %dl,%bl
 463:	89 d1                	mov    %edx,%ecx
 465:	75 0d                	jne    474 <strchr+0x24>
 467:	eb 17                	jmp    480 <strchr+0x30>
 469:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 470:	38 ca                	cmp    %cl,%dl
 472:	74 0c                	je     480 <strchr+0x30>
 474:	83 c0 01             	add    $0x1,%eax
 477:	0f b6 10             	movzbl (%eax),%edx
 47a:	84 d2                	test   %dl,%dl
 47c:	75 f2                	jne    470 <strchr+0x20>
 47e:	31 c0                	xor    %eax,%eax
 480:	5b                   	pop    %ebx
 481:	5d                   	pop    %ebp
 482:	c3                   	ret    
 483:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 489:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000490 <gets>:
 490:	55                   	push   %ebp
 491:	89 e5                	mov    %esp,%ebp
 493:	57                   	push   %edi
 494:	56                   	push   %esi
 495:	31 f6                	xor    %esi,%esi
 497:	53                   	push   %ebx
 498:	83 ec 2c             	sub    $0x2c,%esp
 49b:	8d 7d e7             	lea    -0x19(%ebp),%edi
 49e:	eb 31                	jmp    4d1 <gets+0x41>
 4a0:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4a7:	00 
 4a8:	89 7c 24 04          	mov    %edi,0x4(%esp)
 4ac:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 4b3:	e8 04 01 00 00       	call   5bc <read>
 4b8:	85 c0                	test   %eax,%eax
 4ba:	7e 1d                	jle    4d9 <gets+0x49>
 4bc:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 4c0:	89 de                	mov    %ebx,%esi
 4c2:	8b 55 08             	mov    0x8(%ebp),%edx
 4c5:	3c 0d                	cmp    $0xd,%al
 4c7:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
 4cb:	74 0c                	je     4d9 <gets+0x49>
 4cd:	3c 0a                	cmp    $0xa,%al
 4cf:	74 08                	je     4d9 <gets+0x49>
 4d1:	8d 5e 01             	lea    0x1(%esi),%ebx
 4d4:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 4d7:	7c c7                	jl     4a0 <gets+0x10>
 4d9:	8b 45 08             	mov    0x8(%ebp),%eax
 4dc:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
 4e0:	83 c4 2c             	add    $0x2c,%esp
 4e3:	5b                   	pop    %ebx
 4e4:	5e                   	pop    %esi
 4e5:	5f                   	pop    %edi
 4e6:	5d                   	pop    %ebp
 4e7:	c3                   	ret    
 4e8:	90                   	nop
 4e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000004f0 <stat>:
 4f0:	55                   	push   %ebp
 4f1:	89 e5                	mov    %esp,%ebp
 4f3:	56                   	push   %esi
 4f4:	53                   	push   %ebx
 4f5:	83 ec 10             	sub    $0x10,%esp
 4f8:	8b 45 08             	mov    0x8(%ebp),%eax
 4fb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 502:	00 
 503:	89 04 24             	mov    %eax,(%esp)
 506:	e8 d9 00 00 00       	call   5e4 <open>
 50b:	85 c0                	test   %eax,%eax
 50d:	89 c3                	mov    %eax,%ebx
 50f:	78 27                	js     538 <stat+0x48>
 511:	8b 45 0c             	mov    0xc(%ebp),%eax
 514:	89 1c 24             	mov    %ebx,(%esp)
 517:	89 44 24 04          	mov    %eax,0x4(%esp)
 51b:	e8 dc 00 00 00       	call   5fc <fstat>
 520:	89 1c 24             	mov    %ebx,(%esp)
 523:	89 c6                	mov    %eax,%esi
 525:	e8 a2 00 00 00       	call   5cc <close>
 52a:	89 f0                	mov    %esi,%eax
 52c:	83 c4 10             	add    $0x10,%esp
 52f:	5b                   	pop    %ebx
 530:	5e                   	pop    %esi
 531:	5d                   	pop    %ebp
 532:	c3                   	ret    
 533:	90                   	nop
 534:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 538:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 53d:	eb ed                	jmp    52c <stat+0x3c>
 53f:	90                   	nop

00000540 <atoi>:
 540:	55                   	push   %ebp
 541:	89 e5                	mov    %esp,%ebp
 543:	8b 4d 08             	mov    0x8(%ebp),%ecx
 546:	53                   	push   %ebx
 547:	0f be 11             	movsbl (%ecx),%edx
 54a:	8d 42 d0             	lea    -0x30(%edx),%eax
 54d:	3c 09                	cmp    $0x9,%al
 54f:	b8 00 00 00 00       	mov    $0x0,%eax
 554:	77 17                	ja     56d <atoi+0x2d>
 556:	66 90                	xchg   %ax,%ax
 558:	83 c1 01             	add    $0x1,%ecx
 55b:	8d 04 80             	lea    (%eax,%eax,4),%eax
 55e:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
 562:	0f be 11             	movsbl (%ecx),%edx
 565:	8d 5a d0             	lea    -0x30(%edx),%ebx
 568:	80 fb 09             	cmp    $0x9,%bl
 56b:	76 eb                	jbe    558 <atoi+0x18>
 56d:	5b                   	pop    %ebx
 56e:	5d                   	pop    %ebp
 56f:	c3                   	ret    

00000570 <memmove>:
 570:	55                   	push   %ebp
 571:	31 d2                	xor    %edx,%edx
 573:	89 e5                	mov    %esp,%ebp
 575:	56                   	push   %esi
 576:	8b 45 08             	mov    0x8(%ebp),%eax
 579:	53                   	push   %ebx
 57a:	8b 5d 10             	mov    0x10(%ebp),%ebx
 57d:	8b 75 0c             	mov    0xc(%ebp),%esi
 580:	85 db                	test   %ebx,%ebx
 582:	7e 12                	jle    596 <memmove+0x26>
 584:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 588:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 58c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 58f:	83 c2 01             	add    $0x1,%edx
 592:	39 da                	cmp    %ebx,%edx
 594:	75 f2                	jne    588 <memmove+0x18>
 596:	5b                   	pop    %ebx
 597:	5e                   	pop    %esi
 598:	5d                   	pop    %ebp
 599:	c3                   	ret    
 59a:	90                   	nop
 59b:	90                   	nop

0000059c <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 59c:	b8 01 00 00 00       	mov    $0x1,%eax
 5a1:	cd 40                	int    $0x40
 5a3:	c3                   	ret    

000005a4 <exit>:
SYSCALL(exit)
 5a4:	b8 02 00 00 00       	mov    $0x2,%eax
 5a9:	cd 40                	int    $0x40
 5ab:	c3                   	ret    

000005ac <wait>:
SYSCALL(wait)
 5ac:	b8 03 00 00 00       	mov    $0x3,%eax
 5b1:	cd 40                	int    $0x40
 5b3:	c3                   	ret    

000005b4 <pipe>:
SYSCALL(pipe)
 5b4:	b8 04 00 00 00       	mov    $0x4,%eax
 5b9:	cd 40                	int    $0x40
 5bb:	c3                   	ret    

000005bc <read>:
SYSCALL(read)
 5bc:	b8 05 00 00 00       	mov    $0x5,%eax
 5c1:	cd 40                	int    $0x40
 5c3:	c3                   	ret    

000005c4 <write>:
SYSCALL(write)
 5c4:	b8 10 00 00 00       	mov    $0x10,%eax
 5c9:	cd 40                	int    $0x40
 5cb:	c3                   	ret    

000005cc <close>:
SYSCALL(close)
 5cc:	b8 15 00 00 00       	mov    $0x15,%eax
 5d1:	cd 40                	int    $0x40
 5d3:	c3                   	ret    

000005d4 <kill>:
SYSCALL(kill)
 5d4:	b8 06 00 00 00       	mov    $0x6,%eax
 5d9:	cd 40                	int    $0x40
 5db:	c3                   	ret    

000005dc <exec>:
SYSCALL(exec)
 5dc:	b8 07 00 00 00       	mov    $0x7,%eax
 5e1:	cd 40                	int    $0x40
 5e3:	c3                   	ret    

000005e4 <open>:
SYSCALL(open)
 5e4:	b8 0f 00 00 00       	mov    $0xf,%eax
 5e9:	cd 40                	int    $0x40
 5eb:	c3                   	ret    

000005ec <mknod>:
SYSCALL(mknod)
 5ec:	b8 11 00 00 00       	mov    $0x11,%eax
 5f1:	cd 40                	int    $0x40
 5f3:	c3                   	ret    

000005f4 <unlink>:
SYSCALL(unlink)
 5f4:	b8 12 00 00 00       	mov    $0x12,%eax
 5f9:	cd 40                	int    $0x40
 5fb:	c3                   	ret    

000005fc <fstat>:
SYSCALL(fstat)
 5fc:	b8 08 00 00 00       	mov    $0x8,%eax
 601:	cd 40                	int    $0x40
 603:	c3                   	ret    

00000604 <link>:
SYSCALL(link)
 604:	b8 13 00 00 00       	mov    $0x13,%eax
 609:	cd 40                	int    $0x40
 60b:	c3                   	ret    

0000060c <mkdir>:
SYSCALL(mkdir)
 60c:	b8 14 00 00 00       	mov    $0x14,%eax
 611:	cd 40                	int    $0x40
 613:	c3                   	ret    

00000614 <chdir>:
SYSCALL(chdir)
 614:	b8 09 00 00 00       	mov    $0x9,%eax
 619:	cd 40                	int    $0x40
 61b:	c3                   	ret    

0000061c <dup>:
SYSCALL(dup)
 61c:	b8 0a 00 00 00       	mov    $0xa,%eax
 621:	cd 40                	int    $0x40
 623:	c3                   	ret    

00000624 <getpid>:
SYSCALL(getpid)
 624:	b8 0b 00 00 00       	mov    $0xb,%eax
 629:	cd 40                	int    $0x40
 62b:	c3                   	ret    

0000062c <sbrk>:
SYSCALL(sbrk)
 62c:	b8 0c 00 00 00       	mov    $0xc,%eax
 631:	cd 40                	int    $0x40
 633:	c3                   	ret    

00000634 <sleep>:
SYSCALL(sleep)
 634:	b8 0d 00 00 00       	mov    $0xd,%eax
 639:	cd 40                	int    $0x40
 63b:	c3                   	ret    

0000063c <uptime>:
SYSCALL(uptime)
 63c:	b8 0e 00 00 00       	mov    $0xe,%eax
 641:	cd 40                	int    $0x40
 643:	c3                   	ret    

00000644 <date>:
SYSCALL(date)
 644:	b8 16 00 00 00       	mov    $0x16,%eax
 649:	cd 40                	int    $0x40
 64b:	c3                   	ret    

0000064c <dup2>:
SYSCALL(dup2)
 64c:	b8 17 00 00 00       	mov    $0x17,%eax
 651:	cd 40                	int    $0x40
 653:	c3                   	ret    
 654:	90                   	nop
 655:	90                   	nop
 656:	90                   	nop
 657:	90                   	nop
 658:	90                   	nop
 659:	90                   	nop
 65a:	90                   	nop
 65b:	90                   	nop
 65c:	90                   	nop
 65d:	90                   	nop
 65e:	90                   	nop
 65f:	90                   	nop

00000660 <printint>:
 660:	55                   	push   %ebp
 661:	89 e5                	mov    %esp,%ebp
 663:	57                   	push   %edi
 664:	56                   	push   %esi
 665:	89 c6                	mov    %eax,%esi
 667:	53                   	push   %ebx
 668:	83 ec 4c             	sub    $0x4c,%esp
 66b:	8b 5d 08             	mov    0x8(%ebp),%ebx
 66e:	85 db                	test   %ebx,%ebx
 670:	74 09                	je     67b <printint+0x1b>
 672:	89 d0                	mov    %edx,%eax
 674:	c1 e8 1f             	shr    $0x1f,%eax
 677:	84 c0                	test   %al,%al
 679:	75 75                	jne    6f0 <printint+0x90>
 67b:	89 d0                	mov    %edx,%eax
 67d:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 684:	89 75 c0             	mov    %esi,-0x40(%ebp)
 687:	31 ff                	xor    %edi,%edi
 689:	89 ce                	mov    %ecx,%esi
 68b:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 68e:	eb 02                	jmp    692 <printint+0x32>
 690:	89 cf                	mov    %ecx,%edi
 692:	31 d2                	xor    %edx,%edx
 694:	f7 f6                	div    %esi
 696:	8d 4f 01             	lea    0x1(%edi),%ecx
 699:	0f b6 92 b7 0a 00 00 	movzbl 0xab7(%edx),%edx
 6a0:	85 c0                	test   %eax,%eax
 6a2:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
 6a5:	75 e9                	jne    690 <printint+0x30>
 6a7:	8b 55 c4             	mov    -0x3c(%ebp),%edx
 6aa:	89 c8                	mov    %ecx,%eax
 6ac:	8b 75 c0             	mov    -0x40(%ebp),%esi
 6af:	85 d2                	test   %edx,%edx
 6b1:	74 08                	je     6bb <printint+0x5b>
 6b3:	8d 4f 02             	lea    0x2(%edi),%ecx
 6b6:	c6 44 05 d8 2d       	movb   $0x2d,-0x28(%ebp,%eax,1)
 6bb:	8d 79 ff             	lea    -0x1(%ecx),%edi
 6be:	66 90                	xchg   %ax,%ax
 6c0:	0f b6 44 3d d8       	movzbl -0x28(%ebp,%edi,1),%eax
 6c5:	83 ef 01             	sub    $0x1,%edi
 6c8:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 6cf:	00 
 6d0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
 6d4:	89 34 24             	mov    %esi,(%esp)
 6d7:	88 45 d7             	mov    %al,-0x29(%ebp)
 6da:	e8 e5 fe ff ff       	call   5c4 <write>
 6df:	83 ff ff             	cmp    $0xffffffff,%edi
 6e2:	75 dc                	jne    6c0 <printint+0x60>
 6e4:	83 c4 4c             	add    $0x4c,%esp
 6e7:	5b                   	pop    %ebx
 6e8:	5e                   	pop    %esi
 6e9:	5f                   	pop    %edi
 6ea:	5d                   	pop    %ebp
 6eb:	c3                   	ret    
 6ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 6f0:	89 d0                	mov    %edx,%eax
 6f2:	f7 d8                	neg    %eax
 6f4:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
 6fb:	eb 87                	jmp    684 <printint+0x24>
 6fd:	8d 76 00             	lea    0x0(%esi),%esi

00000700 <printf>:
 700:	55                   	push   %ebp
 701:	89 e5                	mov    %esp,%ebp
 703:	57                   	push   %edi
 704:	31 ff                	xor    %edi,%edi
 706:	56                   	push   %esi
 707:	53                   	push   %ebx
 708:	83 ec 3c             	sub    $0x3c,%esp
 70b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 70e:	8d 45 10             	lea    0x10(%ebp),%eax
 711:	8b 75 08             	mov    0x8(%ebp),%esi
 714:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 717:	0f b6 13             	movzbl (%ebx),%edx
 71a:	83 c3 01             	add    $0x1,%ebx
 71d:	84 d2                	test   %dl,%dl
 71f:	75 39                	jne    75a <printf+0x5a>
 721:	e9 c2 00 00 00       	jmp    7e8 <printf+0xe8>
 726:	66 90                	xchg   %ax,%ax
 728:	83 fa 25             	cmp    $0x25,%edx
 72b:	0f 84 bf 00 00 00    	je     7f0 <printf+0xf0>
 731:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 734:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 73b:	00 
 73c:	89 44 24 04          	mov    %eax,0x4(%esp)
 740:	89 34 24             	mov    %esi,(%esp)
 743:	88 55 e2             	mov    %dl,-0x1e(%ebp)
 746:	e8 79 fe ff ff       	call   5c4 <write>
 74b:	83 c3 01             	add    $0x1,%ebx
 74e:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
 752:	84 d2                	test   %dl,%dl
 754:	0f 84 8e 00 00 00    	je     7e8 <printf+0xe8>
 75a:	85 ff                	test   %edi,%edi
 75c:	0f be c2             	movsbl %dl,%eax
 75f:	74 c7                	je     728 <printf+0x28>
 761:	83 ff 25             	cmp    $0x25,%edi
 764:	75 e5                	jne    74b <printf+0x4b>
 766:	83 fa 64             	cmp    $0x64,%edx
 769:	0f 84 31 01 00 00    	je     8a0 <printf+0x1a0>
 76f:	25 f7 00 00 00       	and    $0xf7,%eax
 774:	83 f8 70             	cmp    $0x70,%eax
 777:	0f 84 83 00 00 00    	je     800 <printf+0x100>
 77d:	83 fa 73             	cmp    $0x73,%edx
 780:	0f 84 a2 00 00 00    	je     828 <printf+0x128>
 786:	83 fa 63             	cmp    $0x63,%edx
 789:	0f 84 35 01 00 00    	je     8c4 <printf+0x1c4>
 78f:	83 fa 25             	cmp    $0x25,%edx
 792:	0f 84 e0 00 00 00    	je     878 <printf+0x178>
 798:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 79b:	83 c3 01             	add    $0x1,%ebx
 79e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 7a5:	00 
 7a6:	31 ff                	xor    %edi,%edi
 7a8:	89 44 24 04          	mov    %eax,0x4(%esp)
 7ac:	89 34 24             	mov    %esi,(%esp)
 7af:	89 55 d0             	mov    %edx,-0x30(%ebp)
 7b2:	c6 45 e6 25          	movb   $0x25,-0x1a(%ebp)
 7b6:	e8 09 fe ff ff       	call   5c4 <write>
 7bb:	8b 55 d0             	mov    -0x30(%ebp),%edx
 7be:	8d 45 e7             	lea    -0x19(%ebp),%eax
 7c1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 7c8:	00 
 7c9:	89 44 24 04          	mov    %eax,0x4(%esp)
 7cd:	89 34 24             	mov    %esi,(%esp)
 7d0:	88 55 e7             	mov    %dl,-0x19(%ebp)
 7d3:	e8 ec fd ff ff       	call   5c4 <write>
 7d8:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
 7dc:	84 d2                	test   %dl,%dl
 7de:	0f 85 76 ff ff ff    	jne    75a <printf+0x5a>
 7e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 7e8:	83 c4 3c             	add    $0x3c,%esp
 7eb:	5b                   	pop    %ebx
 7ec:	5e                   	pop    %esi
 7ed:	5f                   	pop    %edi
 7ee:	5d                   	pop    %ebp
 7ef:	c3                   	ret    
 7f0:	bf 25 00 00 00       	mov    $0x25,%edi
 7f5:	e9 51 ff ff ff       	jmp    74b <printf+0x4b>
 7fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 800:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 803:	b9 10 00 00 00       	mov    $0x10,%ecx
 808:	31 ff                	xor    %edi,%edi
 80a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 811:	8b 10                	mov    (%eax),%edx
 813:	89 f0                	mov    %esi,%eax
 815:	e8 46 fe ff ff       	call   660 <printint>
 81a:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 81e:	e9 28 ff ff ff       	jmp    74b <printf+0x4b>
 823:	90                   	nop
 824:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 828:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 82b:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 82f:	8b 38                	mov    (%eax),%edi
 831:	b8 b0 0a 00 00       	mov    $0xab0,%eax
 836:	85 ff                	test   %edi,%edi
 838:	0f 44 f8             	cmove  %eax,%edi
 83b:	0f b6 07             	movzbl (%edi),%eax
 83e:	84 c0                	test   %al,%al
 840:	74 2a                	je     86c <printf+0x16c>
 842:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 848:	88 45 e3             	mov    %al,-0x1d(%ebp)
 84b:	8d 45 e3             	lea    -0x1d(%ebp),%eax
 84e:	83 c7 01             	add    $0x1,%edi
 851:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 858:	00 
 859:	89 44 24 04          	mov    %eax,0x4(%esp)
 85d:	89 34 24             	mov    %esi,(%esp)
 860:	e8 5f fd ff ff       	call   5c4 <write>
 865:	0f b6 07             	movzbl (%edi),%eax
 868:	84 c0                	test   %al,%al
 86a:	75 dc                	jne    848 <printf+0x148>
 86c:	31 ff                	xor    %edi,%edi
 86e:	e9 d8 fe ff ff       	jmp    74b <printf+0x4b>
 873:	90                   	nop
 874:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 878:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 87b:	31 ff                	xor    %edi,%edi
 87d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 884:	00 
 885:	89 44 24 04          	mov    %eax,0x4(%esp)
 889:	89 34 24             	mov    %esi,(%esp)
 88c:	c6 45 e5 25          	movb   $0x25,-0x1b(%ebp)
 890:	e8 2f fd ff ff       	call   5c4 <write>
 895:	e9 b1 fe ff ff       	jmp    74b <printf+0x4b>
 89a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 8a0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 8a3:	b9 0a 00 00 00       	mov    $0xa,%ecx
 8a8:	66 31 ff             	xor    %di,%di
 8ab:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 8b2:	8b 10                	mov    (%eax),%edx
 8b4:	89 f0                	mov    %esi,%eax
 8b6:	e8 a5 fd ff ff       	call   660 <printint>
 8bb:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 8bf:	e9 87 fe ff ff       	jmp    74b <printf+0x4b>
 8c4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 8c7:	31 ff                	xor    %edi,%edi
 8c9:	8b 00                	mov    (%eax),%eax
 8cb:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 8d2:	00 
 8d3:	89 34 24             	mov    %esi,(%esp)
 8d6:	88 45 e4             	mov    %al,-0x1c(%ebp)
 8d9:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 8dc:	89 44 24 04          	mov    %eax,0x4(%esp)
 8e0:	e8 df fc ff ff       	call   5c4 <write>
 8e5:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 8e9:	e9 5d fe ff ff       	jmp    74b <printf+0x4b>
 8ee:	90                   	nop
 8ef:	90                   	nop

000008f0 <free>:
 8f0:	55                   	push   %ebp
 8f1:	a1 a8 0d 00 00       	mov    0xda8,%eax
 8f6:	89 e5                	mov    %esp,%ebp
 8f8:	57                   	push   %edi
 8f9:	56                   	push   %esi
 8fa:	53                   	push   %ebx
 8fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
 8fe:	8b 08                	mov    (%eax),%ecx
 900:	8d 53 f8             	lea    -0x8(%ebx),%edx
 903:	39 d0                	cmp    %edx,%eax
 905:	72 11                	jb     918 <free+0x28>
 907:	90                   	nop
 908:	39 c8                	cmp    %ecx,%eax
 90a:	72 04                	jb     910 <free+0x20>
 90c:	39 ca                	cmp    %ecx,%edx
 90e:	72 10                	jb     920 <free+0x30>
 910:	89 c8                	mov    %ecx,%eax
 912:	39 d0                	cmp    %edx,%eax
 914:	8b 08                	mov    (%eax),%ecx
 916:	73 f0                	jae    908 <free+0x18>
 918:	39 ca                	cmp    %ecx,%edx
 91a:	72 04                	jb     920 <free+0x30>
 91c:	39 c8                	cmp    %ecx,%eax
 91e:	72 f0                	jb     910 <free+0x20>
 920:	8b 73 fc             	mov    -0x4(%ebx),%esi
 923:	8d 3c f2             	lea    (%edx,%esi,8),%edi
 926:	39 cf                	cmp    %ecx,%edi
 928:	74 1e                	je     948 <free+0x58>
 92a:	89 4b f8             	mov    %ecx,-0x8(%ebx)
 92d:	8b 48 04             	mov    0x4(%eax),%ecx
 930:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
 933:	39 f2                	cmp    %esi,%edx
 935:	74 28                	je     95f <free+0x6f>
 937:	89 10                	mov    %edx,(%eax)
 939:	a3 a8 0d 00 00       	mov    %eax,0xda8
 93e:	5b                   	pop    %ebx
 93f:	5e                   	pop    %esi
 940:	5f                   	pop    %edi
 941:	5d                   	pop    %ebp
 942:	c3                   	ret    
 943:	90                   	nop
 944:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 948:	03 71 04             	add    0x4(%ecx),%esi
 94b:	89 73 fc             	mov    %esi,-0x4(%ebx)
 94e:	8b 08                	mov    (%eax),%ecx
 950:	8b 09                	mov    (%ecx),%ecx
 952:	89 4b f8             	mov    %ecx,-0x8(%ebx)
 955:	8b 48 04             	mov    0x4(%eax),%ecx
 958:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
 95b:	39 f2                	cmp    %esi,%edx
 95d:	75 d8                	jne    937 <free+0x47>
 95f:	03 4b fc             	add    -0x4(%ebx),%ecx
 962:	a3 a8 0d 00 00       	mov    %eax,0xda8
 967:	89 48 04             	mov    %ecx,0x4(%eax)
 96a:	8b 53 f8             	mov    -0x8(%ebx),%edx
 96d:	89 10                	mov    %edx,(%eax)
 96f:	5b                   	pop    %ebx
 970:	5e                   	pop    %esi
 971:	5f                   	pop    %edi
 972:	5d                   	pop    %ebp
 973:	c3                   	ret    
 974:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 97a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000980 <malloc>:
 980:	55                   	push   %ebp
 981:	89 e5                	mov    %esp,%ebp
 983:	57                   	push   %edi
 984:	56                   	push   %esi
 985:	53                   	push   %ebx
 986:	83 ec 1c             	sub    $0x1c,%esp
 989:	8b 45 08             	mov    0x8(%ebp),%eax
 98c:	8b 1d a8 0d 00 00    	mov    0xda8,%ebx
 992:	8d 48 07             	lea    0x7(%eax),%ecx
 995:	c1 e9 03             	shr    $0x3,%ecx
 998:	85 db                	test   %ebx,%ebx
 99a:	8d 71 01             	lea    0x1(%ecx),%esi
 99d:	0f 84 9b 00 00 00    	je     a3e <malloc+0xbe>
 9a3:	8b 13                	mov    (%ebx),%edx
 9a5:	8b 7a 04             	mov    0x4(%edx),%edi
 9a8:	39 fe                	cmp    %edi,%esi
 9aa:	76 64                	jbe    a10 <malloc+0x90>
 9ac:	8d 04 f5 00 00 00 00 	lea    0x0(,%esi,8),%eax
 9b3:	bb 00 80 00 00       	mov    $0x8000,%ebx
 9b8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 9bb:	eb 0e                	jmp    9cb <malloc+0x4b>
 9bd:	8d 76 00             	lea    0x0(%esi),%esi
 9c0:	8b 02                	mov    (%edx),%eax
 9c2:	8b 78 04             	mov    0x4(%eax),%edi
 9c5:	39 fe                	cmp    %edi,%esi
 9c7:	76 4f                	jbe    a18 <malloc+0x98>
 9c9:	89 c2                	mov    %eax,%edx
 9cb:	3b 15 a8 0d 00 00    	cmp    0xda8,%edx
 9d1:	75 ed                	jne    9c0 <malloc+0x40>
 9d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 9d6:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 9dc:	bf 00 10 00 00       	mov    $0x1000,%edi
 9e1:	0f 43 fe             	cmovae %esi,%edi
 9e4:	0f 42 c3             	cmovb  %ebx,%eax
 9e7:	89 04 24             	mov    %eax,(%esp)
 9ea:	e8 3d fc ff ff       	call   62c <sbrk>
 9ef:	83 f8 ff             	cmp    $0xffffffff,%eax
 9f2:	74 18                	je     a0c <malloc+0x8c>
 9f4:	89 78 04             	mov    %edi,0x4(%eax)
 9f7:	83 c0 08             	add    $0x8,%eax
 9fa:	89 04 24             	mov    %eax,(%esp)
 9fd:	e8 ee fe ff ff       	call   8f0 <free>
 a02:	8b 15 a8 0d 00 00    	mov    0xda8,%edx
 a08:	85 d2                	test   %edx,%edx
 a0a:	75 b4                	jne    9c0 <malloc+0x40>
 a0c:	31 c0                	xor    %eax,%eax
 a0e:	eb 20                	jmp    a30 <malloc+0xb0>
 a10:	89 d0                	mov    %edx,%eax
 a12:	89 da                	mov    %ebx,%edx
 a14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 a18:	39 fe                	cmp    %edi,%esi
 a1a:	74 1c                	je     a38 <malloc+0xb8>
 a1c:	29 f7                	sub    %esi,%edi
 a1e:	89 78 04             	mov    %edi,0x4(%eax)
 a21:	8d 04 f8             	lea    (%eax,%edi,8),%eax
 a24:	89 70 04             	mov    %esi,0x4(%eax)
 a27:	89 15 a8 0d 00 00    	mov    %edx,0xda8
 a2d:	83 c0 08             	add    $0x8,%eax
 a30:	83 c4 1c             	add    $0x1c,%esp
 a33:	5b                   	pop    %ebx
 a34:	5e                   	pop    %esi
 a35:	5f                   	pop    %edi
 a36:	5d                   	pop    %ebp
 a37:	c3                   	ret    
 a38:	8b 08                	mov    (%eax),%ecx
 a3a:	89 0a                	mov    %ecx,(%edx)
 a3c:	eb e9                	jmp    a27 <malloc+0xa7>
 a3e:	c7 05 a8 0d 00 00 ac 	movl   $0xdac,0xda8
 a45:	0d 00 00 
 a48:	ba ac 0d 00 00       	mov    $0xdac,%edx
 a4d:	c7 05 ac 0d 00 00 ac 	movl   $0xdac,0xdac
 a54:	0d 00 00 
 a57:	c7 05 b0 0d 00 00 00 	movl   $0x0,0xdb0
 a5e:	00 00 00 
 a61:	e9 46 ff ff ff       	jmp    9ac <malloc+0x2c>
