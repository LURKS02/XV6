
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4 0f                	in     $0xf,%al

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc b0 b5 10 80       	mov    $0x8010b5b0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 70 2e 10 80       	mov    $0x80102e70,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
	...

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb f4 b5 10 80       	mov    $0x8010b5f4,%ebx
  struct buf head;
} bcache;

void
binit(void)
{
80100049:	83 ec 14             	sub    $0x14,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010004c:	c7 44 24 04 20 6d 10 	movl   $0x80106d20,0x4(%esp)
80100053:	80 
80100054:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
8010005b:	e8 b0 40 00 00       	call   80104110 <initlock>

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
80100060:	ba bc fc 10 80       	mov    $0x8010fcbc,%edx

  initlock(&bcache.lock, "bcache");

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
80100065:	c7 05 0c fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd0c
8010006c:	fc 10 80 
  bcache.head.next = &bcache.head;
8010006f:	c7 05 10 fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd10
80100076:	fc 10 80 
80100079:	eb 09                	jmp    80100084 <binit+0x44>
8010007b:	90                   	nop
8010007c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100080:	89 da                	mov    %ebx,%edx
80100082:	89 c3                	mov    %eax,%ebx
    b->next = bcache.head.next;
80100084:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100087:	8d 43 0c             	lea    0xc(%ebx),%eax
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    b->next = bcache.head.next;
    b->prev = &bcache.head;
8010008a:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100091:	89 04 24             	mov    %eax,(%esp)
80100094:	c7 44 24 04 27 6d 10 	movl   $0x80106d27,0x4(%esp)
8010009b:	80 
8010009c:	e8 5f 3f 00 00       	call   80104000 <initsleeplock>
    bcache.head.next->prev = b;
801000a1:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
801000a6:	89 58 50             	mov    %ebx,0x50(%eax)

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a9:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
801000af:	3d bc fc 10 80       	cmp    $0x8010fcbc,%eax
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
801000b4:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000ba:	72 c4                	jb     80100080 <binit+0x40>
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}
801000bc:	83 c4 14             	add    $0x14,%esp
801000bf:	5b                   	pop    %ebx
801000c0:	5d                   	pop    %ebp
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 1c             	sub    $0x1c,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
static struct buf*
bget(uint dev, uint blockno)
{
  struct buf *b;

  acquire(&bcache.lock);
801000df:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
801000e6:	e8 15 41 00 00       	call   80104200 <acquire>

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000eb:	8b 1d 10 fd 10 80    	mov    0x8010fd10,%ebx
801000f1:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
801000f7:	75 12                	jne    8010010b <bread+0x3b>
801000f9:	eb 25                	jmp    80100120 <bread+0x50>
801000fb:	90                   	nop
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }

  // Not cached; recycle an unused buffer.
  // Even if refcnt==0, B_DIRTY indicates a buffer is in use
  // because log.c has modified it but not yet committed it.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 0c fd 10 80    	mov    0x8010fd0c,%ebx
80100126:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 58                	jmp    80100188 <bread+0xb8>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100139:	74 4d                	je     80100188 <bread+0xb8>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100161:	e8 7a 41 00 00       	call   801042e0 <release>
      acquiresleep(&b->lock);
80100166:	8d 43 0c             	lea    0xc(%ebx),%eax
80100169:	89 04 24             	mov    %eax,(%esp)
8010016c:	e8 cf 3e 00 00       	call   80104040 <acquiresleep>
bread(uint dev, uint blockno)
{
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100171:	f6 03 02             	testb  $0x2,(%ebx)
80100174:	75 08                	jne    8010017e <bread+0xae>
    iderw(b);
80100176:	89 1c 24             	mov    %ebx,(%esp)
80100179:	e8 32 20 00 00       	call   801021b0 <iderw>
  }
  return b;
}
8010017e:	83 c4 1c             	add    $0x1c,%esp
80100181:	89 d8                	mov    %ebx,%eax
80100183:	5b                   	pop    %ebx
80100184:	5e                   	pop    %esi
80100185:	5f                   	pop    %edi
80100186:	5d                   	pop    %ebp
80100187:	c3                   	ret    
      release(&bcache.lock);
      acquiresleep(&b->lock);
      return b;
    }
  }
  panic("bget: no buffers");
80100188:	c7 04 24 2e 6d 10 80 	movl   $0x80106d2e,(%esp)
8010018f:	e8 dc 01 00 00       	call   80100370 <panic>
80100194:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010019a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801001a0 <bwrite>:
}

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 14             	sub    $0x14,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	89 04 24             	mov    %eax,(%esp)
801001b0:	e8 2b 3f 00 00       	call   801040e0 <holdingsleep>
801001b5:	85 c0                	test   %eax,%eax
801001b7:	74 10                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001b9:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bc:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001bf:	83 c4 14             	add    $0x14,%esp
801001c2:	5b                   	pop    %ebx
801001c3:	5d                   	pop    %ebp
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
  b->flags |= B_DIRTY;
  iderw(b);
801001c4:	e9 e7 1f 00 00       	jmp    801021b0 <iderw>
// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
801001c9:	c7 04 24 3f 6d 10 80 	movl   $0x80106d3f,(%esp)
801001d0:	e8 9b 01 00 00       	call   80100370 <panic>
801001d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	83 ec 10             	sub    $0x10,%esp
801001e8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	89 34 24             	mov    %esi,(%esp)
801001f1:	e8 ea 3e 00 00       	call   801040e0 <holdingsleep>
801001f6:	85 c0                	test   %eax,%eax
801001f8:	74 62                	je     8010025c <brelse+0x7c>
    panic("brelse");

  releasesleep(&b->lock);
801001fa:	89 34 24             	mov    %esi,(%esp)
801001fd:	e8 9e 3e 00 00       	call   801040a0 <releasesleep>

  acquire(&bcache.lock);
80100202:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100209:	e8 f2 3f 00 00       	call   80104200 <acquire>
  b->refcnt--;
8010020e:	8b 43 4c             	mov    0x4c(%ebx),%eax
80100211:	83 e8 01             	sub    $0x1,%eax
  if (b->refcnt == 0) {
80100214:	85 c0                	test   %eax,%eax
    panic("brelse");

  releasesleep(&b->lock);

  acquire(&bcache.lock);
  b->refcnt--;
80100216:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
80100219:	75 2f                	jne    8010024a <brelse+0x6a>
    // no one is waiting for it.
    b->next->prev = b->prev;
8010021b:	8b 43 54             	mov    0x54(%ebx),%eax
8010021e:	8b 53 50             	mov    0x50(%ebx),%edx
80100221:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100224:	8b 43 50             	mov    0x50(%ebx),%eax
80100227:	8b 53 54             	mov    0x54(%ebx),%edx
8010022a:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
8010022d:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
    b->prev = &bcache.head;
80100232:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
  b->refcnt--;
  if (b->refcnt == 0) {
    // no one is waiting for it.
    b->next->prev = b->prev;
    b->prev->next = b->next;
    b->next = bcache.head.next;
80100239:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    bcache.head.next->prev = b;
8010023c:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
80100241:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100244:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  }
  
  release(&bcache.lock);
8010024a:	c7 45 08 c0 b5 10 80 	movl   $0x8010b5c0,0x8(%ebp)
}
80100251:	83 c4 10             	add    $0x10,%esp
80100254:	5b                   	pop    %ebx
80100255:	5e                   	pop    %esi
80100256:	5d                   	pop    %ebp
    b->prev = &bcache.head;
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
  
  release(&bcache.lock);
80100257:	e9 84 40 00 00       	jmp    801042e0 <release>
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("brelse");
8010025c:	c7 04 24 46 6d 10 80 	movl   $0x80106d46,(%esp)
80100263:	e8 08 01 00 00       	call   80100370 <panic>
	...

80100270 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 2c             	sub    $0x2c,%esp
80100279:	8b 5d 10             	mov    0x10(%ebp),%ebx
8010027c:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027f:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
80100282:	89 3c 24             	mov    %edi,(%esp)
80100285:	e8 16 15 00 00       	call   801017a0 <iunlock>
  target = n;
8010028a:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  acquire(&cons.lock);
8010028d:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100294:	e8 67 3f 00 00       	call   80104200 <acquire>
  while(n > 0){
80100299:	31 c0                	xor    %eax,%eax
8010029b:	85 db                	test   %ebx,%ebx
8010029d:	7f 29                	jg     801002c8 <consoleread+0x58>
8010029f:	eb 6a                	jmp    8010030b <consoleread+0x9b>
801002a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    while(input.r == input.w){
      if(myproc()->killed){
801002a8:	e8 a3 34 00 00       	call   80103750 <myproc>
801002ad:	8b 40 24             	mov    0x24(%eax),%eax
801002b0:	85 c0                	test   %eax,%eax
801002b2:	75 7c                	jne    80100330 <consoleread+0xc0>
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b4:	c7 44 24 04 20 a5 10 	movl   $0x8010a520,0x4(%esp)
801002bb:	80 
801002bc:	c7 04 24 a0 ff 10 80 	movl   $0x8010ffa0,(%esp)
801002c3:	e8 e8 39 00 00       	call   80103cb0 <sleep>

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
801002c8:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801002cd:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801002d3:	74 d3                	je     801002a8 <consoleread+0x38>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
801002d5:	89 c2                	mov    %eax,%edx
801002d7:	83 e2 7f             	and    $0x7f,%edx
801002da:	0f b6 8a 20 ff 10 80 	movzbl -0x7fef00e0(%edx),%ecx
801002e1:	0f be d1             	movsbl %cl,%edx
801002e4:	89 55 dc             	mov    %edx,-0x24(%ebp)
801002e7:	8d 50 01             	lea    0x1(%eax),%edx
    if(c == C('D')){  // EOF
801002ea:	83 7d dc 04          	cmpl   $0x4,-0x24(%ebp)
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
801002ee:	89 15 a0 ff 10 80    	mov    %edx,0x8010ffa0
    if(c == C('D')){  // EOF
801002f4:	74 5b                	je     80100351 <consoleread+0xe1>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
801002f6:	88 0e                	mov    %cl,(%esi)
    --n;
801002f8:	83 eb 01             	sub    $0x1,%ebx
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
801002fb:	83 c6 01             	add    $0x1,%esi
    --n;
    if(c == '\n')
801002fe:	83 7d dc 0a          	cmpl   $0xa,-0x24(%ebp)
80100302:	74 57                	je     8010035b <consoleread+0xeb>
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
80100304:	85 db                	test   %ebx,%ebx
80100306:	75 c0                	jne    801002c8 <consoleread+0x58>
80100308:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
  }
  release(&cons.lock);
8010030b:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010030e:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100315:	e8 c6 3f 00 00       	call   801042e0 <release>
  ilock(ip);
8010031a:	89 3c 24             	mov    %edi,(%esp)
8010031d:	e8 9e 13 00 00       	call   801016c0 <ilock>
80100322:	8b 45 e0             	mov    -0x20(%ebp),%eax

  return target - n;
}
80100325:	83 c4 2c             	add    $0x2c,%esp
80100328:	5b                   	pop    %ebx
80100329:	5e                   	pop    %esi
8010032a:	5f                   	pop    %edi
8010032b:	5d                   	pop    %ebp
8010032c:	c3                   	ret    
8010032d:	8d 76 00             	lea    0x0(%esi),%esi
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
      if(myproc()->killed){
        release(&cons.lock);
80100330:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100337:	e8 a4 3f 00 00       	call   801042e0 <release>
        ilock(ip);
8010033c:	89 3c 24             	mov    %edi,(%esp)
8010033f:	e8 7c 13 00 00       	call   801016c0 <ilock>
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
80100344:	83 c4 2c             	add    $0x2c,%esp
  while(n > 0){
    while(input.r == input.w){
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
80100347:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
8010034c:	5b                   	pop    %ebx
8010034d:	5e                   	pop    %esi
8010034e:	5f                   	pop    %edi
8010034f:	5d                   	pop    %ebp
80100350:	c3                   	ret    
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
    if(c == C('D')){  // EOF
      if(n < target){
80100351:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
80100354:	76 05                	jbe    8010035b <consoleread+0xeb>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
80100356:	a3 a0 ff 10 80       	mov    %eax,0x8010ffa0
8010035b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010035e:	29 d8                	sub    %ebx,%eax
80100360:	eb a9                	jmp    8010030b <consoleread+0x9b>
80100362:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100369:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100370 <panic>:
    release(&cons.lock);
}

void
panic(char *s)
{
80100370:	55                   	push   %ebp
80100371:	89 e5                	mov    %esp,%ebp
80100373:	56                   	push   %esi
80100374:	53                   	push   %ebx
80100375:	83 ec 40             	sub    $0x40,%esp
  int i;
  uint pcs[10];

  cli();
  cons.locking = 0;
80100378:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
8010037f:	00 00 00 
}

static inline void
cli(void)
{
  asm volatile("cli");
80100382:	fa                   	cli    
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
80100383:	e8 88 23 00 00       	call   80102710 <lapicid>
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
80100388:	8d 5d d0             	lea    -0x30(%ebp),%ebx
  uint pcs[10];

  cli();
  cons.locking = 0;
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
8010038b:	c7 04 24 4d 6d 10 80 	movl   $0x80106d4d,(%esp)
  if(locking)
    release(&cons.lock);
}

void
panic(char *s)
80100392:	8d 75 f8             	lea    -0x8(%ebp),%esi
  uint pcs[10];

  cli();
  cons.locking = 0;
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
80100395:	89 44 24 04          	mov    %eax,0x4(%esp)
80100399:	e8 b2 02 00 00       	call   80100650 <cprintf>
  cprintf(s);
8010039e:	8b 45 08             	mov    0x8(%ebp),%eax
801003a1:	89 04 24             	mov    %eax,(%esp)
801003a4:	e8 a7 02 00 00       	call   80100650 <cprintf>
  cprintf("\n");
801003a9:	c7 04 24 77 76 10 80 	movl   $0x80107677,(%esp)
801003b0:	e8 9b 02 00 00       	call   80100650 <cprintf>
  getcallerpcs(&s, pcs);
801003b5:	8d 45 08             	lea    0x8(%ebp),%eax
801003b8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801003bc:	89 04 24             	mov    %eax,(%esp)
801003bf:	e8 6c 3d 00 00       	call   80104130 <getcallerpcs>
801003c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(i=0; i<10; i++)
    cprintf(" %p", pcs[i]);
801003c8:	8b 03                	mov    (%ebx),%eax
801003ca:	83 c3 04             	add    $0x4,%ebx
801003cd:	c7 04 24 61 6d 10 80 	movl   $0x80106d61,(%esp)
801003d4:	89 44 24 04          	mov    %eax,0x4(%esp)
801003d8:	e8 73 02 00 00       	call   80100650 <cprintf>
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
801003dd:	39 f3                	cmp    %esi,%ebx
801003df:	75 e7                	jne    801003c8 <panic+0x58>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
801003e1:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
801003e8:	00 00 00 
801003eb:	eb fe                	jmp    801003eb <panic+0x7b>
801003ed:	8d 76 00             	lea    0x0(%esi),%esi

801003f0 <consputc>:
  crt[pos] = ' ' | 0x0700;
}

void
consputc(int c)
{
801003f0:	55                   	push   %ebp
801003f1:	89 e5                	mov    %esp,%ebp
801003f3:	57                   	push   %edi
801003f4:	56                   	push   %esi
801003f5:	89 c6                	mov    %eax,%esi
801003f7:	53                   	push   %ebx
801003f8:	83 ec 1c             	sub    $0x1c,%esp
  if(panicked){
801003fb:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
80100401:	85 d2                	test   %edx,%edx
80100403:	74 03                	je     80100408 <consputc+0x18>
80100405:	fa                   	cli    
80100406:	eb fe                	jmp    80100406 <consputc+0x16>
    cli();
    for(;;)
      ;
  }

  if(c == BACKSPACE){
80100408:	3d 00 01 00 00       	cmp    $0x100,%eax
8010040d:	0f 84 ac 00 00 00    	je     801004bf <consputc+0xcf>
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else
    uartputc(c);
80100413:	89 04 24             	mov    %eax,(%esp)
80100416:	e8 65 54 00 00       	call   80105880 <uartputc>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010041b:	b9 d4 03 00 00       	mov    $0x3d4,%ecx
80100420:	b8 0e 00 00 00       	mov    $0xe,%eax
80100425:	89 ca                	mov    %ecx,%edx
80100427:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100428:	bf d5 03 00 00       	mov    $0x3d5,%edi
8010042d:	89 fa                	mov    %edi,%edx
8010042f:	ec                   	in     (%dx),%al
{
  int pos;

  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
  pos = inb(CRTPORT+1) << 8;
80100430:	0f b6 d8             	movzbl %al,%ebx
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100433:	89 ca                	mov    %ecx,%edx
80100435:	c1 e3 08             	shl    $0x8,%ebx
80100438:	b8 0f 00 00 00       	mov    $0xf,%eax
8010043d:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010043e:	89 fa                	mov    %edi,%edx
80100440:	ec                   	in     (%dx),%al
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);
80100441:	0f b6 c0             	movzbl %al,%eax
80100444:	09 c3                	or     %eax,%ebx

  if(c == '\n')
80100446:	83 fe 0a             	cmp    $0xa,%esi
80100449:	0f 84 fd 00 00 00    	je     8010054c <consputc+0x15c>
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
8010044f:	81 fe 00 01 00 00    	cmp    $0x100,%esi
80100455:	0f 84 e3 00 00 00    	je     8010053e <consputc+0x14e>
    if(pos > 0) --pos;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010045b:	66 81 e6 ff 00       	and    $0xff,%si
80100460:	66 81 ce 00 07       	or     $0x700,%si
80100465:	66 89 b4 1b 00 80 0b 	mov    %si,-0x7ff48000(%ebx,%ebx,1)
8010046c:	80 
8010046d:	83 c3 01             	add    $0x1,%ebx

  if(pos < 0 || pos > 25*80)
80100470:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
80100476:	0f 87 b6 00 00 00    	ja     80100532 <consputc+0x142>
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
8010047c:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
80100482:	8d b4 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%esi
80100489:	7f 5d                	jg     801004e8 <consputc+0xf8>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010048b:	b9 d4 03 00 00       	mov    $0x3d4,%ecx
80100490:	b8 0e 00 00 00       	mov    $0xe,%eax
80100495:	89 ca                	mov    %ecx,%edx
80100497:	ee                   	out    %al,(%dx)
80100498:	bf d5 03 00 00       	mov    $0x3d5,%edi
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
  }

  outb(CRTPORT, 14);
  outb(CRTPORT+1, pos>>8);
8010049d:	89 d8                	mov    %ebx,%eax
8010049f:	c1 f8 08             	sar    $0x8,%eax
801004a2:	89 fa                	mov    %edi,%edx
801004a4:	ee                   	out    %al,(%dx)
801004a5:	b8 0f 00 00 00       	mov    $0xf,%eax
801004aa:	89 ca                	mov    %ecx,%edx
801004ac:	ee                   	out    %al,(%dx)
801004ad:	89 d8                	mov    %ebx,%eax
801004af:	89 fa                	mov    %edi,%edx
801004b1:	ee                   	out    %al,(%dx)
  outb(CRTPORT, 15);
  outb(CRTPORT+1, pos);
  crt[pos] = ' ' | 0x0700;
801004b2:	66 c7 06 20 07       	movw   $0x720,(%esi)
  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else
    uartputc(c);
  cgaputc(c);
}
801004b7:	83 c4 1c             	add    $0x1c,%esp
801004ba:	5b                   	pop    %ebx
801004bb:	5e                   	pop    %esi
801004bc:	5f                   	pop    %edi
801004bd:	5d                   	pop    %ebp
801004be:	c3                   	ret    
    for(;;)
      ;
  }

  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004bf:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004c6:	e8 b5 53 00 00       	call   80105880 <uartputc>
801004cb:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004d2:	e8 a9 53 00 00       	call   80105880 <uartputc>
801004d7:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004de:	e8 9d 53 00 00       	call   80105880 <uartputc>
801004e3:	e9 33 ff ff ff       	jmp    8010041b <consputc+0x2b>

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004e8:	c7 44 24 08 60 0e 00 	movl   $0xe60,0x8(%esp)
801004ef:	00 
    pos -= 80;
801004f0:	8d 7b b0             	lea    -0x50(%ebx),%edi

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004f3:	c7 44 24 04 a0 80 0b 	movl   $0x800b80a0,0x4(%esp)
801004fa:	80 
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801004fb:	8d b4 3f 00 80 0b 80 	lea    -0x7ff48000(%edi,%edi,1),%esi

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100502:	c7 04 24 00 80 0b 80 	movl   $0x800b8000,(%esp)
80100509:	e8 e2 3e 00 00       	call   801043f0 <memmove>
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
8010050e:	b8 d0 07 00 00       	mov    $0x7d0,%eax
80100513:	29 d8                	sub    %ebx,%eax
  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
    pos -= 80;
80100515:	89 fb                	mov    %edi,%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100517:	01 c0                	add    %eax,%eax
80100519:	89 44 24 08          	mov    %eax,0x8(%esp)
8010051d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100524:	00 
80100525:	89 34 24             	mov    %esi,(%esp)
80100528:	e8 03 3e 00 00       	call   80104330 <memset>
8010052d:	e9 59 ff ff ff       	jmp    8010048b <consputc+0x9b>
    if(pos > 0) --pos;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");
80100532:	c7 04 24 65 6d 10 80 	movl   $0x80106d65,(%esp)
80100539:	e8 32 fe ff ff       	call   80100370 <panic>
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
    if(pos > 0) --pos;
8010053e:	31 c0                	xor    %eax,%eax
80100540:	85 db                	test   %ebx,%ebx
80100542:	0f 9f c0             	setg   %al
80100545:	29 c3                	sub    %eax,%ebx
80100547:	e9 24 ff ff ff       	jmp    80100470 <consputc+0x80>
  pos = inb(CRTPORT+1) << 8;
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
8010054c:	89 d8                	mov    %ebx,%eax
8010054e:	ba 67 66 66 66       	mov    $0x66666667,%edx
80100553:	f7 ea                	imul   %edx
80100555:	c1 ea 05             	shr    $0x5,%edx
80100558:	8d 04 92             	lea    (%edx,%edx,4),%eax
8010055b:	c1 e0 04             	shl    $0x4,%eax
8010055e:	8d 58 50             	lea    0x50(%eax),%ebx
80100561:	e9 0a ff ff ff       	jmp    80100470 <consputc+0x80>
80100566:	8d 76 00             	lea    0x0(%esi),%esi
80100569:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100570 <consolewrite>:
  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100570:	55                   	push   %ebp
80100571:	89 e5                	mov    %esp,%ebp
80100573:	57                   	push   %edi
80100574:	56                   	push   %esi
80100575:	53                   	push   %ebx
80100576:	83 ec 1c             	sub    $0x1c,%esp
  int i;

  iunlock(ip);
80100579:	8b 45 08             	mov    0x8(%ebp),%eax
  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
8010057c:	8b 75 10             	mov    0x10(%ebp),%esi
8010057f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  iunlock(ip);
80100582:	89 04 24             	mov    %eax,(%esp)
80100585:	e8 16 12 00 00       	call   801017a0 <iunlock>
  acquire(&cons.lock);
8010058a:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100591:	e8 6a 3c 00 00       	call   80104200 <acquire>
  for(i = 0; i < n; i++)
80100596:	85 f6                	test   %esi,%esi
80100598:	7e 16                	jle    801005b0 <consolewrite+0x40>
8010059a:	31 db                	xor    %ebx,%ebx
8010059c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    consputc(buf[i] & 0xff);
801005a0:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
801005a4:	83 c3 01             	add    $0x1,%ebx
    consputc(buf[i] & 0xff);
801005a7:	e8 44 fe ff ff       	call   801003f0 <consputc>
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
801005ac:	39 f3                	cmp    %esi,%ebx
801005ae:	75 f0                	jne    801005a0 <consolewrite+0x30>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
801005b0:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801005b7:	e8 24 3d 00 00       	call   801042e0 <release>
  ilock(ip);
801005bc:	8b 45 08             	mov    0x8(%ebp),%eax
801005bf:	89 04 24             	mov    %eax,(%esp)
801005c2:	e8 f9 10 00 00       	call   801016c0 <ilock>

  return n;
}
801005c7:	83 c4 1c             	add    $0x1c,%esp
801005ca:	89 f0                	mov    %esi,%eax
801005cc:	5b                   	pop    %ebx
801005cd:	5e                   	pop    %esi
801005ce:	5f                   	pop    %edi
801005cf:	5d                   	pop    %ebp
801005d0:	c3                   	ret    
801005d1:	eb 0d                	jmp    801005e0 <printint>
801005d3:	90                   	nop
801005d4:	90                   	nop
801005d5:	90                   	nop
801005d6:	90                   	nop
801005d7:	90                   	nop
801005d8:	90                   	nop
801005d9:	90                   	nop
801005da:	90                   	nop
801005db:	90                   	nop
801005dc:	90                   	nop
801005dd:	90                   	nop
801005de:	90                   	nop
801005df:	90                   	nop

801005e0 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
801005e0:	55                   	push   %ebp
801005e1:	89 e5                	mov    %esp,%ebp
801005e3:	56                   	push   %esi
801005e4:	53                   	push   %ebx
801005e5:	89 d3                	mov    %edx,%ebx
801005e7:	83 ec 10             	sub    $0x10,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
801005ea:	85 c9                	test   %ecx,%ecx
801005ec:	74 5a                	je     80100648 <printint+0x68>
801005ee:	85 c0                	test   %eax,%eax
801005f0:	79 56                	jns    80100648 <printint+0x68>
    x = -xx;
801005f2:	f7 d8                	neg    %eax
801005f4:	be 01 00 00 00       	mov    $0x1,%esi
  else
    x = xx;

  i = 0;
801005f9:	31 c9                	xor    %ecx,%ecx
801005fb:	eb 05                	jmp    80100602 <printint+0x22>
801005fd:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
80100600:	89 d1                	mov    %edx,%ecx
80100602:	31 d2                	xor    %edx,%edx
80100604:	f7 f3                	div    %ebx
80100606:	0f b6 92 90 6d 10 80 	movzbl -0x7fef9270(%edx),%edx
  }while((x /= base) != 0);
8010060d:	85 c0                	test   %eax,%eax
  else
    x = xx;

  i = 0;
  do{
    buf[i++] = digits[x % base];
8010060f:	88 54 0d e8          	mov    %dl,-0x18(%ebp,%ecx,1)
80100613:	8d 51 01             	lea    0x1(%ecx),%edx
  }while((x /= base) != 0);
80100616:	75 e8                	jne    80100600 <printint+0x20>

  if(sign)
80100618:	85 f6                	test   %esi,%esi
8010061a:	74 08                	je     80100624 <printint+0x44>
    buf[i++] = '-';
8010061c:	c6 44 15 e8 2d       	movb   $0x2d,-0x18(%ebp,%edx,1)
80100621:	8d 51 02             	lea    0x2(%ecx),%edx

  while(--i >= 0)
80100624:	8d 5a ff             	lea    -0x1(%edx),%ebx
80100627:	90                   	nop
    consputc(buf[i]);
80100628:	0f be 44 1d e8       	movsbl -0x18(%ebp,%ebx,1),%eax
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
8010062d:	83 eb 01             	sub    $0x1,%ebx
    consputc(buf[i]);
80100630:	e8 bb fd ff ff       	call   801003f0 <consputc>
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
80100635:	83 fb ff             	cmp    $0xffffffff,%ebx
80100638:	75 ee                	jne    80100628 <printint+0x48>
    consputc(buf[i]);
}
8010063a:	83 c4 10             	add    $0x10,%esp
8010063d:	5b                   	pop    %ebx
8010063e:	5e                   	pop    %esi
8010063f:	5d                   	pop    %ebp
80100640:	c3                   	ret    
80100641:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  uint x;

  if(sign && (sign = xx < 0))
    x = -xx;
  else
    x = xx;
80100648:	31 f6                	xor    %esi,%esi
8010064a:	eb ad                	jmp    801005f9 <printint+0x19>
8010064c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100650 <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
80100650:	55                   	push   %ebp
80100651:	89 e5                	mov    %esp,%ebp
80100653:	57                   	push   %edi
80100654:	56                   	push   %esi
80100655:	53                   	push   %ebx
80100656:	83 ec 2c             	sub    $0x2c,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
80100659:	8b 3d 54 a5 10 80    	mov    0x8010a554,%edi
  if(locking)
8010065f:	85 ff                	test   %edi,%edi
80100661:	0f 85 39 01 00 00    	jne    801007a0 <cprintf+0x150>
    acquire(&cons.lock);

  if (fmt == 0)
80100667:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010066a:	85 c9                	test   %ecx,%ecx
8010066c:	0f 84 3f 01 00 00    	je     801007b1 <cprintf+0x161>
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100672:	0f b6 01             	movzbl (%ecx),%eax
80100675:	31 db                	xor    %ebx,%ebx
80100677:	8d 75 0c             	lea    0xc(%ebp),%esi
8010067a:	85 c0                	test   %eax,%eax
8010067c:	0f 84 89 00 00 00    	je     8010070b <cprintf+0xbb>
80100682:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80100685:	eb 3c                	jmp    801006c3 <cprintf+0x73>
80100687:	90                   	nop
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
    switch(c){
80100688:	83 fa 25             	cmp    $0x25,%edx
8010068b:	0f 84 f7 00 00 00    	je     80100788 <cprintf+0x138>
80100691:	83 fa 64             	cmp    $0x64,%edx
80100694:	0f 84 ce 00 00 00    	je     80100768 <cprintf+0x118>
    case '%':
      consputc('%');
      break;
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
8010069a:	b8 25 00 00 00       	mov    $0x25,%eax
8010069f:	89 55 e0             	mov    %edx,-0x20(%ebp)
801006a2:	e8 49 fd ff ff       	call   801003f0 <consputc>
      consputc(c);
801006a7:	8b 55 e0             	mov    -0x20(%ebp),%edx
801006aa:	89 d0                	mov    %edx,%eax
801006ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801006b0:	e8 3b fd ff ff       	call   801003f0 <consputc>
801006b5:	8b 4d 08             	mov    0x8(%ebp),%ecx

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006b8:	83 c3 01             	add    $0x1,%ebx
801006bb:	0f b6 04 19          	movzbl (%ecx,%ebx,1),%eax
801006bf:	85 c0                	test   %eax,%eax
801006c1:	74 45                	je     80100708 <cprintf+0xb8>
    if(c != '%'){
801006c3:	83 f8 25             	cmp    $0x25,%eax
801006c6:	75 e8                	jne    801006b0 <cprintf+0x60>
      consputc(c);
      continue;
    }
    c = fmt[++i] & 0xff;
801006c8:	83 c3 01             	add    $0x1,%ebx
801006cb:	0f b6 14 19          	movzbl (%ecx,%ebx,1),%edx
    if(c == 0)
801006cf:	85 d2                	test   %edx,%edx
801006d1:	74 35                	je     80100708 <cprintf+0xb8>
      break;
    switch(c){
801006d3:	83 fa 70             	cmp    $0x70,%edx
801006d6:	74 0f                	je     801006e7 <cprintf+0x97>
801006d8:	7e ae                	jle    80100688 <cprintf+0x38>
801006da:	83 fa 73             	cmp    $0x73,%edx
801006dd:	8d 76 00             	lea    0x0(%esi),%esi
801006e0:	74 46                	je     80100728 <cprintf+0xd8>
801006e2:	83 fa 78             	cmp    $0x78,%edx
801006e5:	75 b3                	jne    8010069a <cprintf+0x4a>
    case 'd':
      printint(*argp++, 10, 1);
      break;
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
801006e7:	8b 06                	mov    (%esi),%eax
801006e9:	31 c9                	xor    %ecx,%ecx
801006eb:	ba 10 00 00 00       	mov    $0x10,%edx

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006f0:	83 c3 01             	add    $0x1,%ebx
    case 'd':
      printint(*argp++, 10, 1);
      break;
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
801006f3:	83 c6 04             	add    $0x4,%esi
801006f6:	e8 e5 fe ff ff       	call   801005e0 <printint>
801006fb:	8b 4d 08             	mov    0x8(%ebp),%ecx

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006fe:	0f b6 04 19          	movzbl (%ecx,%ebx,1),%eax
80100702:	85 c0                	test   %eax,%eax
80100704:	75 bd                	jne    801006c3 <cprintf+0x73>
80100706:	66 90                	xchg   %ax,%ax
80100708:	8b 7d e4             	mov    -0x1c(%ebp),%edi
      consputc(c);
      break;
    }
  }

  if(locking)
8010070b:	85 ff                	test   %edi,%edi
8010070d:	74 0c                	je     8010071b <cprintf+0xcb>
    release(&cons.lock);
8010070f:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100716:	e8 c5 3b 00 00       	call   801042e0 <release>
}
8010071b:	83 c4 2c             	add    $0x2c,%esp
8010071e:	5b                   	pop    %ebx
8010071f:	5e                   	pop    %esi
80100720:	5f                   	pop    %edi
80100721:	5d                   	pop    %ebp
80100722:	c3                   	ret    
80100723:	90                   	nop
80100724:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
80100728:	8b 16                	mov    (%esi),%edx
        s = "(null)";
8010072a:	b8 78 6d 10 80       	mov    $0x80106d78,%eax
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
8010072f:	83 c6 04             	add    $0x4,%esi
        s = "(null)";
80100732:	85 d2                	test   %edx,%edx
80100734:	0f 44 d0             	cmove  %eax,%edx
      for(; *s; s++)
80100737:	0f b6 02             	movzbl (%edx),%eax
8010073a:	84 c0                	test   %al,%al
8010073c:	0f 84 76 ff ff ff    	je     801006b8 <cprintf+0x68>
80100742:	89 f7                	mov    %esi,%edi
80100744:	89 de                	mov    %ebx,%esi
80100746:	89 d3                	mov    %edx,%ebx
        consputc(*s);
80100748:	0f be c0             	movsbl %al,%eax
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
8010074b:	83 c3 01             	add    $0x1,%ebx
        consputc(*s);
8010074e:	e8 9d fc ff ff       	call   801003f0 <consputc>
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
80100753:	0f b6 03             	movzbl (%ebx),%eax
80100756:	84 c0                	test   %al,%al
80100758:	75 ee                	jne    80100748 <cprintf+0xf8>
8010075a:	89 f3                	mov    %esi,%ebx
8010075c:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010075f:	89 fe                	mov    %edi,%esi
80100761:	e9 52 ff ff ff       	jmp    801006b8 <cprintf+0x68>
80100766:	66 90                	xchg   %ax,%ax
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
    switch(c){
    case 'd':
      printint(*argp++, 10, 1);
80100768:	8b 06                	mov    (%esi),%eax
8010076a:	b9 01 00 00 00       	mov    $0x1,%ecx
8010076f:	ba 0a 00 00 00       	mov    $0xa,%edx
80100774:	83 c6 04             	add    $0x4,%esi
80100777:	e8 64 fe ff ff       	call   801005e0 <printint>
8010077c:	8b 4d 08             	mov    0x8(%ebp),%ecx
      break;
8010077f:	e9 34 ff ff ff       	jmp    801006b8 <cprintf+0x68>
80100784:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
      break;
    case '%':
      consputc('%');
80100788:	b8 25 00 00 00       	mov    $0x25,%eax
8010078d:	e8 5e fc ff ff       	call   801003f0 <consputc>
80100792:	8b 4d 08             	mov    0x8(%ebp),%ecx
      break;
80100795:	e9 1e ff ff ff       	jmp    801006b8 <cprintf+0x68>
8010079a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  uint *argp;
  char *s;

  locking = cons.locking;
  if(locking)
    acquire(&cons.lock);
801007a0:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801007a7:	e8 54 3a 00 00       	call   80104200 <acquire>
801007ac:	e9 b6 fe ff ff       	jmp    80100667 <cprintf+0x17>

  if (fmt == 0)
    panic("null fmt");
801007b1:	c7 04 24 7f 6d 10 80 	movl   $0x80106d7f,(%esp)
801007b8:	e8 b3 fb ff ff       	call   80100370 <panic>
801007bd:	8d 76 00             	lea    0x0(%esi),%esi

801007c0 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007c0:	55                   	push   %ebp
801007c1:	89 e5                	mov    %esp,%ebp
801007c3:	57                   	push   %edi
  int c, doprocdump = 0;
801007c4:	31 ff                	xor    %edi,%edi

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007c6:	56                   	push   %esi
801007c7:	53                   	push   %ebx
801007c8:	83 ec 1c             	sub    $0x1c,%esp
801007cb:	8b 75 08             	mov    0x8(%ebp),%esi
  int c, doprocdump = 0;

  acquire(&cons.lock);
801007ce:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801007d5:	e8 26 3a 00 00       	call   80104200 <acquire>
801007da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  while((c = getc()) >= 0){
801007e0:	ff d6                	call   *%esi
801007e2:	85 c0                	test   %eax,%eax
801007e4:	89 c3                	mov    %eax,%ebx
801007e6:	0f 88 8c 00 00 00    	js     80100878 <consoleintr+0xb8>
    switch(c){
801007ec:	83 fb 10             	cmp    $0x10,%ebx
801007ef:	90                   	nop
801007f0:	0f 84 da 00 00 00    	je     801008d0 <consoleintr+0x110>
801007f6:	0f 8f 9c 00 00 00    	jg     80100898 <consoleintr+0xd8>
801007fc:	83 fb 08             	cmp    $0x8,%ebx
801007ff:	90                   	nop
80100800:	0f 84 a0 00 00 00    	je     801008a6 <consoleintr+0xe6>
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100806:	85 db                	test   %ebx,%ebx
80100808:	74 d6                	je     801007e0 <consoleintr+0x20>
8010080a:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010080f:	89 c2                	mov    %eax,%edx
80100811:	2b 15 a0 ff 10 80    	sub    0x8010ffa0,%edx
80100817:	83 fa 7f             	cmp    $0x7f,%edx
8010081a:	77 c4                	ja     801007e0 <consoleintr+0x20>
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
8010081c:	89 c2                	mov    %eax,%edx
8010081e:	83 e2 7f             	and    $0x7f,%edx
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
80100821:	83 fb 0d             	cmp    $0xd,%ebx
80100824:	0f 84 12 01 00 00    	je     8010093c <consoleintr+0x17c>
        input.buf[input.e++ % INPUT_BUF] = c;
8010082a:	83 c0 01             	add    $0x1,%eax
8010082d:	88 9a 20 ff 10 80    	mov    %bl,-0x7fef00e0(%edx)
80100833:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(c);
80100838:	89 d8                	mov    %ebx,%eax
8010083a:	e8 b1 fb ff ff       	call   801003f0 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
8010083f:	83 fb 04             	cmp    $0x4,%ebx
80100842:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100847:	74 12                	je     8010085b <consoleintr+0x9b>
80100849:	83 fb 0a             	cmp    $0xa,%ebx
8010084c:	74 0d                	je     8010085b <consoleintr+0x9b>
8010084e:	8b 15 a0 ff 10 80    	mov    0x8010ffa0,%edx
80100854:	83 ea 80             	sub    $0xffffff80,%edx
80100857:	39 d0                	cmp    %edx,%eax
80100859:	75 85                	jne    801007e0 <consoleintr+0x20>
          input.w = input.e;
8010085b:	a3 a4 ff 10 80       	mov    %eax,0x8010ffa4
          wakeup(&input.r);
80100860:	c7 04 24 a0 ff 10 80 	movl   $0x8010ffa0,(%esp)
80100867:	e8 e4 35 00 00       	call   80103e50 <wakeup>
consoleintr(int (*getc)(void))
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
8010086c:	ff d6                	call   *%esi
8010086e:	85 c0                	test   %eax,%eax
80100870:	89 c3                	mov    %eax,%ebx
80100872:	0f 89 74 ff ff ff    	jns    801007ec <consoleintr+0x2c>
        }
      }
      break;
    }
  }
  release(&cons.lock);
80100878:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010087f:	e8 5c 3a 00 00       	call   801042e0 <release>
  if(doprocdump) {
80100884:	85 ff                	test   %edi,%edi
80100886:	0f 85 a4 00 00 00    	jne    80100930 <consoleintr+0x170>
    procdump();  // now call procdump() wo. cons.lock held
  }
}
8010088c:	83 c4 1c             	add    $0x1c,%esp
8010088f:	5b                   	pop    %ebx
80100890:	5e                   	pop    %esi
80100891:	5f                   	pop    %edi
80100892:	5d                   	pop    %ebp
80100893:	c3                   	ret    
80100894:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
    switch(c){
80100898:	83 fb 15             	cmp    $0x15,%ebx
8010089b:	74 43                	je     801008e0 <consoleintr+0x120>
8010089d:	83 fb 7f             	cmp    $0x7f,%ebx
801008a0:	0f 85 60 ff ff ff    	jne    80100806 <consoleintr+0x46>
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
801008a6:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801008ab:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801008b1:	0f 84 29 ff ff ff    	je     801007e0 <consoleintr+0x20>
        input.e--;
801008b7:	83 e8 01             	sub    $0x1,%eax
801008ba:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
801008bf:	b8 00 01 00 00       	mov    $0x100,%eax
801008c4:	e8 27 fb ff ff       	call   801003f0 <consputc>
801008c9:	e9 12 ff ff ff       	jmp    801007e0 <consoleintr+0x20>
801008ce:	66 90                	xchg   %ax,%ax
  acquire(&cons.lock);
  while((c = getc()) >= 0){
    switch(c){
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
801008d0:	bf 01 00 00 00       	mov    $0x1,%edi
801008d5:	e9 06 ff ff ff       	jmp    801007e0 <consoleintr+0x20>
801008da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
801008e0:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801008e5:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801008eb:	75 2b                	jne    80100918 <consoleintr+0x158>
801008ed:	e9 ee fe ff ff       	jmp    801007e0 <consoleintr+0x20>
801008f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
801008f8:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
801008fd:	b8 00 01 00 00       	mov    $0x100,%eax
80100902:	e8 e9 fa ff ff       	call   801003f0 <consputc>
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100907:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010090c:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
80100912:	0f 84 c8 fe ff ff    	je     801007e0 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100918:	83 e8 01             	sub    $0x1,%eax
8010091b:	89 c2                	mov    %eax,%edx
8010091d:	83 e2 7f             	and    $0x7f,%edx
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100920:	80 ba 20 ff 10 80 0a 	cmpb   $0xa,-0x7fef00e0(%edx)
80100927:	75 cf                	jne    801008f8 <consoleintr+0x138>
80100929:	e9 b2 fe ff ff       	jmp    801007e0 <consoleintr+0x20>
8010092e:	66 90                	xchg   %ax,%ax
  }
  release(&cons.lock);
  if(doprocdump) {
    procdump();  // now call procdump() wo. cons.lock held
  }
}
80100930:	83 c4 1c             	add    $0x1c,%esp
80100933:	5b                   	pop    %ebx
80100934:	5e                   	pop    %esi
80100935:	5f                   	pop    %edi
80100936:	5d                   	pop    %ebp
      break;
    }
  }
  release(&cons.lock);
  if(doprocdump) {
    procdump();  // now call procdump() wo. cons.lock held
80100937:	e9 f4 35 00 00       	jmp    80103f30 <procdump>
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
8010093c:	83 c0 01             	add    $0x1,%eax
8010093f:	c6 82 20 ff 10 80 0a 	movb   $0xa,-0x7fef00e0(%edx)
80100946:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(c);
8010094b:	b8 0a 00 00 00       	mov    $0xa,%eax
80100950:	e8 9b fa ff ff       	call   801003f0 <consputc>
80100955:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010095a:	e9 fc fe ff ff       	jmp    8010085b <consoleintr+0x9b>
8010095f:	90                   	nop

80100960 <consoleinit>:
  return n;
}

void
consoleinit(void)
{
80100960:	55                   	push   %ebp
80100961:	89 e5                	mov    %esp,%ebp
80100963:	83 ec 18             	sub    $0x18,%esp
  initlock(&cons.lock, "console");
80100966:	c7 44 24 04 88 6d 10 	movl   $0x80106d88,0x4(%esp)
8010096d:	80 
8010096e:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100975:	e8 96 37 00 00       	call   80104110 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
8010097a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100981:	00 
80100982:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
void
consoleinit(void)
{
  initlock(&cons.lock, "console");

  devsw[CONSOLE].write = consolewrite;
80100989:	c7 05 6c 09 11 80 70 	movl   $0x80100570,0x8011096c
80100990:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100993:	c7 05 68 09 11 80 70 	movl   $0x80100270,0x80110968
8010099a:	02 10 80 
  cons.locking = 1;
8010099d:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
801009a4:	00 00 00 

  ioapicenable(IRQ_KBD, 0);
801009a7:	e8 74 19 00 00       	call   80102320 <ioapicenable>
}
801009ac:	c9                   	leave  
801009ad:	c3                   	ret    
	...

801009b0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
801009b0:	55                   	push   %ebp
801009b1:	89 e5                	mov    %esp,%ebp
801009b3:	81 ec 38 01 00 00    	sub    $0x138,%esp
801009b9:	89 5d f4             	mov    %ebx,-0xc(%ebp)
801009bc:	89 75 f8             	mov    %esi,-0x8(%ebp)
801009bf:	89 7d fc             	mov    %edi,-0x4(%ebp)
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
801009c2:	e8 89 2d 00 00       	call   80103750 <myproc>
801009c7:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
801009cd:	e8 be 21 00 00       	call   80102b90 <begin_op>

  if((ip = namei(path)) == 0){
801009d2:	8b 55 08             	mov    0x8(%ebp),%edx
801009d5:	89 14 24             	mov    %edx,(%esp)
801009d8:	e8 b3 15 00 00       	call   80101f90 <namei>
801009dd:	85 c0                	test   %eax,%eax
801009df:	89 c3                	mov    %eax,%ebx
801009e1:	0f 84 42 02 00 00    	je     80100c29 <exec+0x279>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
801009e7:	89 04 24             	mov    %eax,(%esp)
801009ea:	e8 d1 0c 00 00       	call   801016c0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
801009ef:	8d 45 94             	lea    -0x6c(%ebp),%eax
801009f2:	c7 44 24 0c 34 00 00 	movl   $0x34,0xc(%esp)
801009f9:	00 
801009fa:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80100a01:	00 
80100a02:	89 44 24 04          	mov    %eax,0x4(%esp)
80100a06:	89 1c 24             	mov    %ebx,(%esp)
80100a09:	e8 92 0f 00 00       	call   801019a0 <readi>
80100a0e:	83 f8 34             	cmp    $0x34,%eax
80100a11:	74 25                	je     80100a38 <exec+0x88>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a13:	89 1c 24             	mov    %ebx,(%esp)
80100a16:	e8 35 0f 00 00       	call   80101950 <iunlockput>
    end_op();
80100a1b:	e8 e0 21 00 00       	call   80102c00 <end_op>
  }
  return -1;
80100a20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a25:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80100a28:	8b 75 f8             	mov    -0x8(%ebp),%esi
80100a2b:	8b 7d fc             	mov    -0x4(%ebp),%edi
80100a2e:	89 ec                	mov    %ebp,%esp
80100a30:	5d                   	pop    %ebp
80100a31:	c3                   	ret    
80100a32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100a38:	81 7d 94 7f 45 4c 46 	cmpl   $0x464c457f,-0x6c(%ebp)
80100a3f:	75 d2                	jne    80100a13 <exec+0x63>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100a41:	e8 6a 60 00 00       	call   80106ab0 <setupkvm>
80100a46:	85 c0                	test   %eax,%eax
80100a48:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100a4e:	74 c3                	je     80100a13 <exec+0x63>
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a50:	66 83 7d c0 00       	cmpw   $0x0,-0x40(%ebp)
80100a55:	8b 75 b0             	mov    -0x50(%ebp),%esi

  if((pgdir = setupkvm()) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
80100a58:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100a5f:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a62:	0f 84 cb 00 00 00    	je     80100b33 <exec+0x183>
80100a68:	31 ff                	xor    %edi,%edi
80100a6a:	eb 16                	jmp    80100a82 <exec+0xd2>
80100a6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100a70:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80100a74:	83 c7 01             	add    $0x1,%edi
#include "defs.h"
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
80100a77:	83 c6 20             	add    $0x20,%esi
  if((pgdir = setupkvm()) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a7a:	39 f8                	cmp    %edi,%eax
80100a7c:	0f 8e b1 00 00 00    	jle    80100b33 <exec+0x183>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100a82:	8d 4d c8             	lea    -0x38(%ebp),%ecx
80100a85:	c7 44 24 0c 20 00 00 	movl   $0x20,0xc(%esp)
80100a8c:	00 
80100a8d:	89 74 24 08          	mov    %esi,0x8(%esp)
80100a91:	89 4c 24 04          	mov    %ecx,0x4(%esp)
80100a95:	89 1c 24             	mov    %ebx,(%esp)
80100a98:	e8 03 0f 00 00       	call   801019a0 <readi>
80100a9d:	83 f8 20             	cmp    $0x20,%eax
80100aa0:	75 76                	jne    80100b18 <exec+0x168>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100aa2:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
80100aa6:	75 c8                	jne    80100a70 <exec+0xc0>
      continue;
    if(ph.memsz < ph.filesz)
80100aa8:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100aab:	3b 45 d8             	cmp    -0x28(%ebp),%eax
80100aae:	72 68                	jb     80100b18 <exec+0x168>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100ab0:	03 45 d0             	add    -0x30(%ebp),%eax
80100ab3:	72 63                	jb     80100b18 <exec+0x168>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100ab5:	89 44 24 08          	mov    %eax,0x8(%esp)
80100ab9:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100abf:	89 44 24 04          	mov    %eax,0x4(%esp)
80100ac3:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100ac9:	89 04 24             	mov    %eax,(%esp)
80100acc:	e8 2f 5e 00 00       	call   80106900 <allocuvm>
80100ad1:	85 c0                	test   %eax,%eax
80100ad3:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100ad9:	74 3d                	je     80100b18 <exec+0x168>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
80100adb:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100ade:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100ae3:	75 33                	jne    80100b18 <exec+0x168>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100ae5:	8b 55 d8             	mov    -0x28(%ebp),%edx
80100ae8:	89 44 24 04          	mov    %eax,0x4(%esp)
80100aec:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100af2:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80100af6:	89 54 24 10          	mov    %edx,0x10(%esp)
80100afa:	8b 55 cc             	mov    -0x34(%ebp),%edx
80100afd:	89 04 24             	mov    %eax,(%esp)
80100b00:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100b04:	e8 97 5c 00 00       	call   801067a0 <loaduvm>
80100b09:	85 c0                	test   %eax,%eax
80100b0b:	0f 89 5f ff ff ff    	jns    80100a70 <exec+0xc0>
80100b11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100b18:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100b1e:	89 04 24             	mov    %eax,(%esp)
80100b21:	e8 0a 5f 00 00       	call   80106a30 <freevm>
  if(ip){
80100b26:	85 db                	test   %ebx,%ebx
80100b28:	0f 85 e5 fe ff ff    	jne    80100a13 <exec+0x63>
80100b2e:	e9 ed fe ff ff       	jmp    80100a20 <exec+0x70>
    if(ph.vaddr % PGSIZE != 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100b33:	89 1c 24             	mov    %ebx,(%esp)
  end_op();
  ip = 0;
80100b36:	31 db                	xor    %ebx,%ebx
    if(ph.vaddr % PGSIZE != 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100b38:	e8 13 0e 00 00       	call   80101950 <iunlockput>
  end_op();
80100b3d:	e8 be 20 00 00       	call   80102c00 <end_op>
  ip = 0;

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100b42:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100b48:	05 ff 0f 00 00       	add    $0xfff,%eax
80100b4d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b52:	8d 90 00 20 00 00    	lea    0x2000(%eax),%edx
80100b58:	89 44 24 04          	mov    %eax,0x4(%esp)
80100b5c:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100b62:	89 54 24 08          	mov    %edx,0x8(%esp)
80100b66:	89 04 24             	mov    %eax,(%esp)
80100b69:	e8 92 5d 00 00       	call   80106900 <allocuvm>
80100b6e:	85 c0                	test   %eax,%eax
80100b70:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100b76:	74 a0                	je     80100b18 <exec+0x168>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100b78:	2d 00 20 00 00       	sub    $0x2000,%eax
80100b7d:	89 44 24 04          	mov    %eax,0x4(%esp)
80100b81:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100b87:	89 04 24             	mov    %eax,(%esp)
80100b8a:	e8 c1 5f 00 00       	call   80106b50 <clearpteu>
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100b8f:	8b 55 0c             	mov    0xc(%ebp),%edx
80100b92:	8b 02                	mov    (%edx),%eax
80100b94:	85 c0                	test   %eax,%eax
80100b96:	0f 84 af 00 00 00    	je     80100c4b <exec+0x29b>
#include "defs.h"
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
80100b9c:	89 d7                	mov    %edx,%edi
80100b9e:	8b 9d f0 fe ff ff    	mov    -0x110(%ebp),%ebx
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100ba4:	31 f6                	xor    %esi,%esi
#include "defs.h"
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
80100ba6:	83 c7 04             	add    $0x4,%edi
80100ba9:	89 d1                	mov    %edx,%ecx
80100bab:	eb 27                	jmp    80100bd4 <exec+0x224>
80100bad:	8d 76 00             	lea    0x0(%esi),%esi
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100bb0:	8b 07                	mov    (%edi),%eax
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
80100bb2:	8d 95 04 ff ff ff    	lea    -0xfc(%ebp),%edx
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100bb8:	89 f9                	mov    %edi,%ecx
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
80100bba:	89 9c b5 10 ff ff ff 	mov    %ebx,-0xf0(%ebp,%esi,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100bc1:	83 c6 01             	add    $0x1,%esi
80100bc4:	85 c0                	test   %eax,%eax
80100bc6:	0f 84 8d 00 00 00    	je     80100c59 <exec+0x2a9>
80100bcc:	83 c7 04             	add    $0x4,%edi
    if(argc >= MAXARG)
80100bcf:	83 fe 20             	cmp    $0x20,%esi
80100bd2:	74 4e                	je     80100c22 <exec+0x272>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100bd4:	89 8d e8 fe ff ff    	mov    %ecx,-0x118(%ebp)
80100bda:	89 04 24             	mov    %eax,(%esp)
80100bdd:	e8 7e 39 00 00       	call   80104560 <strlen>
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100be2:	8b 8d e8 fe ff ff    	mov    -0x118(%ebp),%ecx

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100be8:	f7 d0                	not    %eax
80100bea:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100bec:	8b 01                	mov    (%ecx),%eax

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100bee:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100bf1:	89 04 24             	mov    %eax,(%esp)
80100bf4:	e8 67 39 00 00       	call   80104560 <strlen>
80100bf9:	8b 8d e8 fe ff ff    	mov    -0x118(%ebp),%ecx
80100bff:	83 c0 01             	add    $0x1,%eax
80100c02:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100c06:	8b 01                	mov    (%ecx),%eax
80100c08:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80100c0c:	89 44 24 08          	mov    %eax,0x8(%esp)
80100c10:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100c16:	89 04 24             	mov    %eax,(%esp)
80100c19:	e8 62 60 00 00       	call   80106c80 <copyout>
80100c1e:	85 c0                	test   %eax,%eax
80100c20:	79 8e                	jns    80100bb0 <exec+0x200>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
  end_op();
  ip = 0;
80100c22:	31 db                	xor    %ebx,%ebx
80100c24:	e9 ef fe ff ff       	jmp    80100b18 <exec+0x168>
80100c29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  struct proc *curproc = myproc();

  begin_op();

  if((ip = namei(path)) == 0){
    end_op();
80100c30:	e8 cb 1f 00 00       	call   80102c00 <end_op>
    cprintf("exec: fail\n");
80100c35:	c7 04 24 a1 6d 10 80 	movl   $0x80106da1,(%esp)
80100c3c:	e8 0f fa ff ff       	call   80100650 <cprintf>
    return -1;
80100c41:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100c46:	e9 da fd ff ff       	jmp    80100a25 <exec+0x75>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c4b:	8b 9d f0 fe ff ff    	mov    -0x110(%ebp),%ebx
80100c51:	31 f6                	xor    %esi,%esi
80100c53:	8d 95 04 ff ff ff    	lea    -0xfc(%ebp),%edx
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c59:	8d 04 b5 04 00 00 00 	lea    0x4(,%esi,4),%eax
80100c60:	89 d9                	mov    %ebx,%ecx
80100c62:	29 c1                	sub    %eax,%ecx

  sp -= (3+argc+1) * 4;
80100c64:	8d 04 b5 10 00 00 00 	lea    0x10(,%esi,4),%eax
80100c6b:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c6d:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100c71:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100c77:	c7 84 b5 10 ff ff ff 	movl   $0x0,-0xf0(%ebp,%esi,4)
80100c7e:	00 00 00 00 
  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c82:	89 54 24 08          	mov    %edx,0x8(%esp)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
80100c86:	c7 85 04 ff ff ff ff 	movl   $0xffffffff,-0xfc(%ebp)
80100c8d:	ff ff ff 
  ustack[1] = argc;
80100c90:	89 b5 08 ff ff ff    	mov    %esi,-0xf8(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c96:	89 8d 0c ff ff ff    	mov    %ecx,-0xf4(%ebp)

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c9c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80100ca0:	89 04 24             	mov    %eax,(%esp)
80100ca3:	e8 d8 5f 00 00       	call   80106c80 <copyout>
80100ca8:	85 c0                	test   %eax,%eax
80100caa:	0f 88 72 ff ff ff    	js     80100c22 <exec+0x272>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100cb0:	8b 4d 08             	mov    0x8(%ebp),%ecx
80100cb3:	0f b6 11             	movzbl (%ecx),%edx
80100cb6:	84 d2                	test   %dl,%dl
80100cb8:	74 14                	je     80100cce <exec+0x31e>
#include "defs.h"
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
80100cba:	8d 41 01             	lea    0x1(%ecx),%eax
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
    if(*s == '/')
      last = s+1;
80100cbd:	80 fa 2f             	cmp    $0x2f,%dl
80100cc0:	0f 44 c8             	cmove  %eax,%ecx
80100cc3:	83 c0 01             	add    $0x1,%eax
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100cc6:	0f b6 50 ff          	movzbl -0x1(%eax),%edx
80100cca:	84 d2                	test   %dl,%dl
80100ccc:	75 ef                	jne    80100cbd <exec+0x30d>
    if(*s == '/')
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100cce:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100cd4:	89 4c 24 04          	mov    %ecx,0x4(%esp)
80100cd8:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80100cdf:	00 
80100ce0:	83 c0 6c             	add    $0x6c,%eax
80100ce3:	89 04 24             	mov    %eax,(%esp)
80100ce6:	e8 35 38 00 00       	call   80104520 <safestrcpy>

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
80100ceb:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  curproc->pgdir = pgdir;
80100cf1:	8b 95 ec fe ff ff    	mov    -0x114(%ebp),%edx
  curproc->sz = sz;
80100cf7:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
    if(*s == '/')
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
80100cfd:	8b 70 04             	mov    0x4(%eax),%esi
  curproc->pgdir = pgdir;
80100d00:	89 50 04             	mov    %edx,0x4(%eax)
  curproc->sz = sz;
80100d03:	89 08                	mov    %ecx,(%eax)
  curproc->tf->eip = elf.entry;  // main
80100d05:	8b 40 18             	mov    0x18(%eax),%eax
  curproc->tf->esp = sp;
80100d08:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
  curproc->pgdir = pgdir;
  curproc->sz = sz;
  curproc->tf->eip = elf.entry;  // main
80100d0e:	8b 55 ac             	mov    -0x54(%ebp),%edx
80100d11:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d14:	8b 41 18             	mov    0x18(%ecx),%eax
80100d17:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100d1a:	89 0c 24             	mov    %ecx,(%esp)
80100d1d:	e8 ee 58 00 00       	call   80106610 <switchuvm>
  freevm(oldpgdir);
80100d22:	89 34 24             	mov    %esi,(%esp)
80100d25:	e8 06 5d 00 00       	call   80106a30 <freevm>
  return 0;
80100d2a:	31 c0                	xor    %eax,%eax
80100d2c:	e9 f4 fc ff ff       	jmp    80100a25 <exec+0x75>
	...

80100d40 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100d40:	55                   	push   %ebp
80100d41:	89 e5                	mov    %esp,%ebp
80100d43:	83 ec 18             	sub    $0x18,%esp
  initlock(&ftable.lock, "ftable");
80100d46:	c7 44 24 04 ad 6d 10 	movl   $0x80106dad,0x4(%esp)
80100d4d:	80 
80100d4e:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100d55:	e8 b6 33 00 00       	call   80104110 <initlock>
}
80100d5a:	c9                   	leave  
80100d5b:	c3                   	ret    
80100d5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100d60 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d60:	55                   	push   %ebp
80100d61:	89 e5                	mov    %esp,%ebp
80100d63:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d64:	bb f4 ff 10 80       	mov    $0x8010fff4,%ebx
}

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d69:	83 ec 14             	sub    $0x14,%esp
  struct file *f;

  acquire(&ftable.lock);
80100d6c:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100d73:	e8 88 34 00 00       	call   80104200 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    if(f->ref == 0){
80100d78:	8b 15 f8 ff 10 80    	mov    0x8010fff8,%edx
80100d7e:	85 d2                	test   %edx,%edx
80100d80:	74 18                	je     80100d9a <filealloc+0x3a>
80100d82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
filealloc(void)
{
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d88:	83 c3 18             	add    $0x18,%ebx
80100d8b:	81 fb 54 09 11 80    	cmp    $0x80110954,%ebx
80100d91:	73 25                	jae    80100db8 <filealloc+0x58>
    if(f->ref == 0){
80100d93:	8b 43 04             	mov    0x4(%ebx),%eax
80100d96:	85 c0                	test   %eax,%eax
80100d98:	75 ee                	jne    80100d88 <filealloc+0x28>
      f->ref = 1;
80100d9a:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100da1:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100da8:	e8 33 35 00 00       	call   801042e0 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100dad:	83 c4 14             	add    $0x14,%esp
80100db0:	89 d8                	mov    %ebx,%eax
80100db2:	5b                   	pop    %ebx
80100db3:	5d                   	pop    %ebp
80100db4:	c3                   	ret    
80100db5:	8d 76 00             	lea    0x0(%esi),%esi
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100db8:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
  return 0;
80100dbf:	31 db                	xor    %ebx,%ebx
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100dc1:	e8 1a 35 00 00       	call   801042e0 <release>
  return 0;
}
80100dc6:	83 c4 14             	add    $0x14,%esp
80100dc9:	89 d8                	mov    %ebx,%eax
80100dcb:	5b                   	pop    %ebx
80100dcc:	5d                   	pop    %ebp
80100dcd:	c3                   	ret    
80100dce:	66 90                	xchg   %ax,%ax

80100dd0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100dd0:	55                   	push   %ebp
80100dd1:	89 e5                	mov    %esp,%ebp
80100dd3:	53                   	push   %ebx
80100dd4:	83 ec 14             	sub    $0x14,%esp
80100dd7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100dda:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100de1:	e8 1a 34 00 00       	call   80104200 <acquire>
  if(f->ref < 1)
80100de6:	8b 43 04             	mov    0x4(%ebx),%eax
80100de9:	85 c0                	test   %eax,%eax
80100deb:	7e 1a                	jle    80100e07 <filedup+0x37>
    panic("filedup");
  f->ref++;
80100ded:	83 c0 01             	add    $0x1,%eax
80100df0:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100df3:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100dfa:	e8 e1 34 00 00       	call   801042e0 <release>
  return f;
}
80100dff:	83 c4 14             	add    $0x14,%esp
80100e02:	89 d8                	mov    %ebx,%eax
80100e04:	5b                   	pop    %ebx
80100e05:	5d                   	pop    %ebp
80100e06:	c3                   	ret    
struct file*
filedup(struct file *f)
{
  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("filedup");
80100e07:	c7 04 24 b4 6d 10 80 	movl   $0x80106db4,(%esp)
80100e0e:	e8 5d f5 ff ff       	call   80100370 <panic>
80100e13:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100e19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e20 <fileclose>:
}

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e20:	55                   	push   %ebp
80100e21:	89 e5                	mov    %esp,%ebp
80100e23:	83 ec 38             	sub    $0x38,%esp
80100e26:	89 5d f4             	mov    %ebx,-0xc(%ebp)
80100e29:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100e2c:	89 75 f8             	mov    %esi,-0x8(%ebp)
80100e2f:	89 7d fc             	mov    %edi,-0x4(%ebp)
  struct file ff;

  acquire(&ftable.lock);
80100e32:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100e39:	e8 c2 33 00 00       	call   80104200 <acquire>
  if(f->ref < 1)
80100e3e:	8b 43 04             	mov    0x4(%ebx),%eax
80100e41:	85 c0                	test   %eax,%eax
80100e43:	0f 8e 9c 00 00 00    	jle    80100ee5 <fileclose+0xc5>
    panic("fileclose");
  if(--f->ref > 0){
80100e49:	83 e8 01             	sub    $0x1,%eax
80100e4c:	85 c0                	test   %eax,%eax
80100e4e:	89 43 04             	mov    %eax,0x4(%ebx)
80100e51:	74 1d                	je     80100e70 <fileclose+0x50>
    release(&ftable.lock);
80100e53:	c7 45 08 c0 ff 10 80 	movl   $0x8010ffc0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e5a:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80100e5d:	8b 75 f8             	mov    -0x8(%ebp),%esi
80100e60:	8b 7d fc             	mov    -0x4(%ebp),%edi
80100e63:	89 ec                	mov    %ebp,%esp
80100e65:	5d                   	pop    %ebp

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
80100e66:	e9 75 34 00 00       	jmp    801042e0 <release>
80100e6b:	90                   	nop
80100e6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return;
  }
  ff = *f;
80100e70:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
80100e74:	8b 33                	mov    (%ebx),%esi
  f->ref = 0;
  f->type = FD_NONE;
80100e76:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100e7c:	8b 7b 10             	mov    0x10(%ebx),%edi
80100e7f:	88 45 e7             	mov    %al,-0x19(%ebp)
80100e82:	8b 43 0c             	mov    0xc(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100e85:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100e8c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100e8f:	e8 4c 34 00 00       	call   801042e0 <release>

  if(ff.type == FD_PIPE)
80100e94:	83 fe 01             	cmp    $0x1,%esi
80100e97:	74 37                	je     80100ed0 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100e99:	83 fe 02             	cmp    $0x2,%esi
80100e9c:	74 12                	je     80100eb0 <fileclose+0x90>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e9e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80100ea1:	8b 75 f8             	mov    -0x8(%ebp),%esi
80100ea4:	8b 7d fc             	mov    -0x4(%ebp),%edi
80100ea7:	89 ec                	mov    %ebp,%esp
80100ea9:	5d                   	pop    %ebp
80100eaa:	c3                   	ret    
80100eab:	90                   	nop
80100eac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ftable.lock);

  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
    begin_op();
80100eb0:	e8 db 1c 00 00       	call   80102b90 <begin_op>
    iput(ff.ip);
80100eb5:	89 3c 24             	mov    %edi,(%esp)
80100eb8:	e8 33 09 00 00       	call   801017f0 <iput>
    end_op();
  }
}
80100ebd:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80100ec0:	8b 75 f8             	mov    -0x8(%ebp),%esi
80100ec3:	8b 7d fc             	mov    -0x4(%ebp),%edi
80100ec6:	89 ec                	mov    %ebp,%esp
80100ec8:	5d                   	pop    %ebp
  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
80100ec9:	e9 32 1d 00 00       	jmp    80102c00 <end_op>
80100ece:	66 90                	xchg   %ax,%ax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);

  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
80100ed0:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
80100ed4:	89 44 24 04          	mov    %eax,0x4(%esp)
80100ed8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100edb:	89 04 24             	mov    %eax,(%esp)
80100ede:	e8 0d 24 00 00       	call   801032f0 <pipeclose>
80100ee3:	eb b9                	jmp    80100e9e <fileclose+0x7e>
{
  struct file ff;

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
80100ee5:	c7 04 24 bc 6d 10 80 	movl   $0x80106dbc,(%esp)
80100eec:	e8 7f f4 ff ff       	call   80100370 <panic>
80100ef1:	eb 0d                	jmp    80100f00 <filestat>
80100ef3:	90                   	nop
80100ef4:	90                   	nop
80100ef5:	90                   	nop
80100ef6:	90                   	nop
80100ef7:	90                   	nop
80100ef8:	90                   	nop
80100ef9:	90                   	nop
80100efa:	90                   	nop
80100efb:	90                   	nop
80100efc:	90                   	nop
80100efd:	90                   	nop
80100efe:	90                   	nop
80100eff:	90                   	nop

80100f00 <filestat>:
}

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100f00:	55                   	push   %ebp
    ilock(f->ip);
    stati(f->ip, st);
    iunlock(f->ip);
    return 0;
  }
  return -1;
80100f01:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100f06:	89 e5                	mov    %esp,%ebp
80100f08:	53                   	push   %ebx
80100f09:	83 ec 14             	sub    $0x14,%esp
80100f0c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100f0f:	83 3b 02             	cmpl   $0x2,(%ebx)
80100f12:	75 2a                	jne    80100f3e <filestat+0x3e>
    ilock(f->ip);
80100f14:	8b 43 10             	mov    0x10(%ebx),%eax
80100f17:	89 04 24             	mov    %eax,(%esp)
80100f1a:	e8 a1 07 00 00       	call   801016c0 <ilock>
    stati(f->ip, st);
80100f1f:	8b 45 0c             	mov    0xc(%ebp),%eax
80100f22:	89 44 24 04          	mov    %eax,0x4(%esp)
80100f26:	8b 43 10             	mov    0x10(%ebx),%eax
80100f29:	89 04 24             	mov    %eax,(%esp)
80100f2c:	e8 3f 0a 00 00       	call   80101970 <stati>
    iunlock(f->ip);
80100f31:	8b 43 10             	mov    0x10(%ebx),%eax
80100f34:	89 04 24             	mov    %eax,(%esp)
80100f37:	e8 64 08 00 00       	call   801017a0 <iunlock>
    return 0;
80100f3c:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100f3e:	83 c4 14             	add    $0x14,%esp
80100f41:	5b                   	pop    %ebx
80100f42:	5d                   	pop    %ebp
80100f43:	c3                   	ret    
80100f44:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100f4a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100f50 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100f50:	55                   	push   %ebp
80100f51:	89 e5                	mov    %esp,%ebp
80100f53:	83 ec 28             	sub    $0x28,%esp
80100f56:	89 5d f4             	mov    %ebx,-0xc(%ebp)
80100f59:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f5c:	89 75 f8             	mov    %esi,-0x8(%ebp)
80100f5f:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f62:	89 7d fc             	mov    %edi,-0x4(%ebp)
80100f65:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100f68:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100f6c:	74 72                	je     80100fe0 <fileread+0x90>
    return -1;
  if(f->type == FD_PIPE)
80100f6e:	8b 03                	mov    (%ebx),%eax
80100f70:	83 f8 01             	cmp    $0x1,%eax
80100f73:	74 53                	je     80100fc8 <fileread+0x78>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100f75:	83 f8 02             	cmp    $0x2,%eax
80100f78:	75 6d                	jne    80100fe7 <fileread+0x97>
    ilock(f->ip);
80100f7a:	8b 43 10             	mov    0x10(%ebx),%eax
80100f7d:	89 04 24             	mov    %eax,(%esp)
80100f80:	e8 3b 07 00 00       	call   801016c0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f85:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80100f89:	8b 43 14             	mov    0x14(%ebx),%eax
80100f8c:	89 74 24 04          	mov    %esi,0x4(%esp)
80100f90:	89 44 24 08          	mov    %eax,0x8(%esp)
80100f94:	8b 43 10             	mov    0x10(%ebx),%eax
80100f97:	89 04 24             	mov    %eax,(%esp)
80100f9a:	e8 01 0a 00 00       	call   801019a0 <readi>
80100f9f:	85 c0                	test   %eax,%eax
80100fa1:	89 c6                	mov    %eax,%esi
80100fa3:	7e 03                	jle    80100fa8 <fileread+0x58>
      f->off += r;
80100fa5:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100fa8:	8b 43 10             	mov    0x10(%ebx),%eax
80100fab:	89 04 24             	mov    %eax,(%esp)
80100fae:	e8 ed 07 00 00       	call   801017a0 <iunlock>
    return r;
  }
  panic("fileread");
}
80100fb3:	89 f0                	mov    %esi,%eax
80100fb5:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80100fb8:	8b 75 f8             	mov    -0x8(%ebp),%esi
80100fbb:	8b 7d fc             	mov    -0x4(%ebp),%edi
80100fbe:	89 ec                	mov    %ebp,%esp
80100fc0:	5d                   	pop    %ebp
80100fc1:	c3                   	ret    
80100fc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80100fc8:	8b 43 0c             	mov    0xc(%ebx),%eax
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80100fcb:	8b 75 f8             	mov    -0x8(%ebp),%esi
80100fce:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80100fd1:	8b 7d fc             	mov    -0x4(%ebp),%edi
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80100fd4:	89 45 08             	mov    %eax,0x8(%ebp)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80100fd7:	89 ec                	mov    %ebp,%esp
80100fd9:	5d                   	pop    %ebp
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80100fda:	e9 a1 24 00 00       	jmp    80103480 <piperead>
80100fdf:	90                   	nop
fileread(struct file *f, char *addr, int n)
{
  int r;

  if(f->readable == 0)
    return -1;
80100fe0:	be ff ff ff ff       	mov    $0xffffffff,%esi
80100fe5:	eb cc                	jmp    80100fb3 <fileread+0x63>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
80100fe7:	c7 04 24 c6 6d 10 80 	movl   $0x80106dc6,(%esp)
80100fee:	e8 7d f3 ff ff       	call   80100370 <panic>
80100ff3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100ff9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101000 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101000:	55                   	push   %ebp
80101001:	89 e5                	mov    %esp,%ebp
80101003:	57                   	push   %edi
80101004:	56                   	push   %esi
80101005:	53                   	push   %ebx
80101006:	83 ec 2c             	sub    $0x2c,%esp
80101009:	8b 45 0c             	mov    0xc(%ebp),%eax
8010100c:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010100f:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101012:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80101015:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101019:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int r;

  if(f->writable == 0)
8010101c:	0f 84 ae 00 00 00    	je     801010d0 <filewrite+0xd0>
    return -1;
  if(f->type == FD_PIPE)
80101022:	8b 03                	mov    (%ebx),%eax
80101024:	83 f8 01             	cmp    $0x1,%eax
80101027:	0f 84 c6 00 00 00    	je     801010f3 <filewrite+0xf3>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010102d:	83 f8 02             	cmp    $0x2,%eax
80101030:	0f 85 db 00 00 00    	jne    80101111 <filewrite+0x111>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101036:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101039:	31 f6                	xor    %esi,%esi
8010103b:	85 c9                	test   %ecx,%ecx
8010103d:	7f 31                	jg     80101070 <filewrite+0x70>
8010103f:	e9 9c 00 00 00       	jmp    801010e0 <filewrite+0xe0>
80101044:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101048:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
8010104b:	8b 53 10             	mov    0x10(%ebx),%edx
8010104e:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101051:	89 14 24             	mov    %edx,(%esp)
80101054:	e8 47 07 00 00       	call   801017a0 <iunlock>
      end_op();
80101059:	e8 a2 1b 00 00       	call   80102c00 <end_op>
8010105e:	8b 45 dc             	mov    -0x24(%ebp),%eax

      if(r < 0)
        break;
      if(r != n1)
80101061:	39 f8                	cmp    %edi,%eax
80101063:	0f 85 9c 00 00 00    	jne    80101105 <filewrite+0x105>
        panic("short filewrite");
      i += r;
80101069:	01 c6                	add    %eax,%esi
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
8010106b:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
8010106e:	7e 70                	jle    801010e0 <filewrite+0xe0>
      int n1 = n - i;
80101070:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101073:	b8 00 06 00 00       	mov    $0x600,%eax
80101078:	29 f7                	sub    %esi,%edi
8010107a:	81 ff 00 06 00 00    	cmp    $0x600,%edi
80101080:	0f 4f f8             	cmovg  %eax,%edi
      if(n1 > max)
        n1 = max;

      begin_op();
80101083:	e8 08 1b 00 00       	call   80102b90 <begin_op>
      ilock(f->ip);
80101088:	8b 43 10             	mov    0x10(%ebx),%eax
8010108b:	89 04 24             	mov    %eax,(%esp)
8010108e:	e8 2d 06 00 00       	call   801016c0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101093:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80101097:	8b 43 14             	mov    0x14(%ebx),%eax
8010109a:	89 44 24 08          	mov    %eax,0x8(%esp)
8010109e:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010a1:	01 f0                	add    %esi,%eax
801010a3:	89 44 24 04          	mov    %eax,0x4(%esp)
801010a7:	8b 43 10             	mov    0x10(%ebx),%eax
801010aa:	89 04 24             	mov    %eax,(%esp)
801010ad:	e8 1e 0a 00 00       	call   80101ad0 <writei>
801010b2:	85 c0                	test   %eax,%eax
801010b4:	7f 92                	jg     80101048 <filewrite+0x48>
        f->off += r;
      iunlock(f->ip);
801010b6:	8b 53 10             	mov    0x10(%ebx),%edx
801010b9:	89 45 dc             	mov    %eax,-0x24(%ebp)
801010bc:	89 14 24             	mov    %edx,(%esp)
801010bf:	e8 dc 06 00 00       	call   801017a0 <iunlock>
      end_op();
801010c4:	e8 37 1b 00 00       	call   80102c00 <end_op>

      if(r < 0)
801010c9:	8b 45 dc             	mov    -0x24(%ebp),%eax
801010cc:	85 c0                	test   %eax,%eax
801010ce:	74 91                	je     80101061 <filewrite+0x61>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010d0:	83 c4 2c             	add    $0x2c,%esp
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
801010d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
801010d8:	5b                   	pop    %ebx
801010d9:	5e                   	pop    %esi
801010da:	5f                   	pop    %edi
801010db:	5d                   	pop    %ebp
801010dc:	c3                   	ret    
801010dd:	8d 76 00             	lea    0x0(%esi),%esi
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
801010e0:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
801010e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801010e8:	0f 44 c6             	cmove  %esi,%eax
  }
  panic("filewrite");
}
801010eb:	83 c4 2c             	add    $0x2c,%esp
801010ee:	5b                   	pop    %ebx
801010ef:	5e                   	pop    %esi
801010f0:	5f                   	pop    %edi
801010f1:	5d                   	pop    %ebp
801010f2:	c3                   	ret    
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
801010f3:	8b 43 0c             	mov    0xc(%ebx),%eax
801010f6:	89 45 08             	mov    %eax,0x8(%ebp)
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010f9:	83 c4 2c             	add    $0x2c,%esp
801010fc:	5b                   	pop    %ebx
801010fd:	5e                   	pop    %esi
801010fe:	5f                   	pop    %edi
801010ff:	5d                   	pop    %ebp
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
80101100:	e9 8b 22 00 00       	jmp    80103390 <pipewrite>
      end_op();

      if(r < 0)
        break;
      if(r != n1)
        panic("short filewrite");
80101105:	c7 04 24 cf 6d 10 80 	movl   $0x80106dcf,(%esp)
8010110c:	e8 5f f2 ff ff       	call   80100370 <panic>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
80101111:	c7 04 24 d5 6d 10 80 	movl   $0x80106dd5,(%esp)
80101118:	e8 53 f2 ff ff       	call   80100370 <panic>
8010111d:	00 00                	add    %al,(%eax)
	...

80101120 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101120:	55                   	push   %ebp
80101121:	89 e5                	mov    %esp,%ebp
80101123:	57                   	push   %edi
80101124:	89 d7                	mov    %edx,%edi
80101126:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101127:	31 f6                	xor    %esi,%esi
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101129:	53                   	push   %ebx
8010112a:	89 c3                	mov    %eax,%ebx
8010112c:	83 ec 2c             	sub    $0x2c,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
8010112f:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101136:	e8 c5 30 00 00       	call   80104200 <acquire>

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010113b:	b8 14 0a 11 80       	mov    $0x80110a14,%eax
80101140:	eb 16                	jmp    80101158 <iget+0x38>
80101142:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101148:	85 f6                	test   %esi,%esi
8010114a:	74 3c                	je     80101188 <iget+0x68>

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010114c:	05 90 00 00 00       	add    $0x90,%eax
80101151:	3d 34 26 11 80       	cmp    $0x80112634,%eax
80101156:	73 48                	jae    801011a0 <iget+0x80>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101158:	8b 48 08             	mov    0x8(%eax),%ecx
8010115b:	85 c9                	test   %ecx,%ecx
8010115d:	7e e9                	jle    80101148 <iget+0x28>
8010115f:	39 18                	cmp    %ebx,(%eax)
80101161:	75 e5                	jne    80101148 <iget+0x28>
80101163:	39 78 04             	cmp    %edi,0x4(%eax)
80101166:	75 e0                	jne    80101148 <iget+0x28>
      ip->ref++;
80101168:	83 c1 01             	add    $0x1,%ecx
8010116b:	89 48 08             	mov    %ecx,0x8(%eax)
      release(&icache.lock);
8010116e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101171:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101178:	e8 63 31 00 00       	call   801042e0 <release>
      return ip;
8010117d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);

  return ip;
}
80101180:	83 c4 2c             	add    $0x2c,%esp
80101183:	5b                   	pop    %ebx
80101184:	5e                   	pop    %esi
80101185:	5f                   	pop    %edi
80101186:	5d                   	pop    %ebp
80101187:	c3                   	ret    
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101188:	85 c9                	test   %ecx,%ecx
8010118a:	0f 44 f0             	cmove  %eax,%esi

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010118d:	05 90 00 00 00       	add    $0x90,%eax
80101192:	3d 34 26 11 80       	cmp    $0x80112634,%eax
80101197:	72 bf                	jb     80101158 <iget+0x38>
80101199:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801011a0:	85 f6                	test   %esi,%esi
801011a2:	74 29                	je     801011cd <iget+0xad>
    panic("iget: no inodes");

  ip = empty;
  ip->dev = dev;
801011a4:	89 1e                	mov    %ebx,(%esi)
  ip->inum = inum;
801011a6:	89 7e 04             	mov    %edi,0x4(%esi)
  ip->ref = 1;
801011a9:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801011b0:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801011b7:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801011be:	e8 1d 31 00 00       	call   801042e0 <release>

  return ip;
}
801011c3:	83 c4 2c             	add    $0x2c,%esp
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);

  return ip;
801011c6:	89 f0                	mov    %esi,%eax
}
801011c8:	5b                   	pop    %ebx
801011c9:	5e                   	pop    %esi
801011ca:	5f                   	pop    %edi
801011cb:	5d                   	pop    %ebp
801011cc:	c3                   	ret    
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
    panic("iget: no inodes");
801011cd:	c7 04 24 df 6d 10 80 	movl   $0x80106ddf,(%esp)
801011d4:	e8 97 f1 ff ff       	call   80100370 <panic>
801011d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801011e0 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801011e0:	55                   	push   %ebp
801011e1:	89 e5                	mov    %esp,%ebp
801011e3:	57                   	push   %edi
801011e4:	56                   	push   %esi
801011e5:	53                   	push   %ebx
801011e6:	83 ec 3c             	sub    $0x3c,%esp
801011e9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801011ec:	a1 c0 09 11 80       	mov    0x801109c0,%eax
801011f1:	85 c0                	test   %eax,%eax
801011f3:	0f 84 90 00 00 00    	je     80101289 <balloc+0xa9>
801011f9:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101200:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101203:	c1 f8 0c             	sar    $0xc,%eax
80101206:	03 05 d8 09 11 80    	add    0x801109d8,%eax
8010120c:	89 44 24 04          	mov    %eax,0x4(%esp)
80101210:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101213:	89 04 24             	mov    %eax,(%esp)
80101216:	e8 b5 ee ff ff       	call   801000d0 <bread>
8010121b:	8b 15 c0 09 11 80    	mov    0x801109c0,%edx
80101221:	8b 5d dc             	mov    -0x24(%ebp),%ebx
80101224:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101227:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010122a:	31 c0                	xor    %eax,%eax
8010122c:	eb 35                	jmp    80101263 <balloc+0x83>
8010122e:	66 90                	xchg   %ax,%ax
      m = 1 << (bi % 8);
80101230:	89 c1                	mov    %eax,%ecx
80101232:	bf 01 00 00 00       	mov    $0x1,%edi
80101237:	83 e1 07             	and    $0x7,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010123a:	89 c2                	mov    %eax,%edx

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
8010123c:	d3 e7                	shl    %cl,%edi
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010123e:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101241:	c1 fa 03             	sar    $0x3,%edx

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
80101244:	89 7d d4             	mov    %edi,-0x2c(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101247:	0f b6 74 11 5c       	movzbl 0x5c(%ecx,%edx,1),%esi
8010124c:	89 f1                	mov    %esi,%ecx
8010124e:	0f b6 f9             	movzbl %cl,%edi
80101251:	85 7d d4             	test   %edi,-0x2c(%ebp)
80101254:	74 42                	je     80101298 <balloc+0xb8>
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101256:	83 c0 01             	add    $0x1,%eax
80101259:	83 c3 01             	add    $0x1,%ebx
8010125c:	3d 00 10 00 00       	cmp    $0x1000,%eax
80101261:	74 05                	je     80101268 <balloc+0x88>
80101263:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
80101266:	72 c8                	jb     80101230 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101268:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010126b:	89 04 24             	mov    %eax,(%esp)
8010126e:	e8 6d ef ff ff       	call   801001e0 <brelse>
{
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101273:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
8010127a:	8b 55 dc             	mov    -0x24(%ebp),%edx
8010127d:	3b 15 c0 09 11 80    	cmp    0x801109c0,%edx
80101283:	0f 82 77 ff ff ff    	jb     80101200 <balloc+0x20>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
80101289:	c7 04 24 ef 6d 10 80 	movl   $0x80106def,(%esp)
80101290:	e8 db f0 ff ff       	call   80100370 <panic>
80101295:	8d 76 00             	lea    0x0(%esi),%esi
80101298:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use.
8010129b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010129e:	09 f1                	or     %esi,%ecx
801012a0:	88 4c 10 5c          	mov    %cl,0x5c(%eax,%edx,1)
        log_write(bp);
801012a4:	89 04 24             	mov    %eax,(%esp)
801012a7:	e8 84 1a 00 00       	call   80102d30 <log_write>
        brelse(bp);
801012ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801012af:	89 04 24             	mov    %eax,(%esp)
801012b2:	e8 29 ef ff ff       	call   801001e0 <brelse>
static void
bzero(int dev, int bno)
{
  struct buf *bp;

  bp = bread(dev, bno);
801012b7:	8b 45 d8             	mov    -0x28(%ebp),%eax
801012ba:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801012be:	89 04 24             	mov    %eax,(%esp)
801012c1:	e8 0a ee ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
801012c6:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
801012cd:	00 
801012ce:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801012d5:	00 
static void
bzero(int dev, int bno)
{
  struct buf *bp;

  bp = bread(dev, bno);
801012d6:	89 c6                	mov    %eax,%esi
  memset(bp->data, 0, BSIZE);
801012d8:	8d 40 5c             	lea    0x5c(%eax),%eax
801012db:	89 04 24             	mov    %eax,(%esp)
801012de:	e8 4d 30 00 00       	call   80104330 <memset>
  log_write(bp);
801012e3:	89 34 24             	mov    %esi,(%esp)
801012e6:	e8 45 1a 00 00       	call   80102d30 <log_write>
  brelse(bp);
801012eb:	89 34 24             	mov    %esi,(%esp)
801012ee:	e8 ed ee ff ff       	call   801001e0 <brelse>
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
}
801012f3:	83 c4 3c             	add    $0x3c,%esp
801012f6:	89 d8                	mov    %ebx,%eax
801012f8:	5b                   	pop    %ebx
801012f9:	5e                   	pop    %esi
801012fa:	5f                   	pop    %edi
801012fb:	5d                   	pop    %ebp
801012fc:	c3                   	ret    
801012fd:	8d 76 00             	lea    0x0(%esi),%esi

80101300 <bmap.part.0>:
// listed in block ip->addrs[NDIRECT].

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
80101300:	55                   	push   %ebp
80101301:	89 e5                	mov    %esp,%ebp
80101303:	83 ec 38             	sub    $0x38,%esp
80101306:	89 7d fc             	mov    %edi,-0x4(%ebp)
  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101309:	8d 7a f4             	lea    -0xc(%edx),%edi

  if(bn < NINDIRECT){
8010130c:	83 ff 7f             	cmp    $0x7f,%edi
// listed in block ip->addrs[NDIRECT].

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
8010130f:	89 5d f4             	mov    %ebx,-0xc(%ebp)
80101312:	89 c3                	mov    %eax,%ebx
80101314:	89 75 f8             	mov    %esi,-0x8(%ebp)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;

  if(bn < NINDIRECT){
80101317:	77 66                	ja     8010137f <bmap.part.0+0x7f>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101319:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
8010131f:	85 c0                	test   %eax,%eax
80101321:	74 4d                	je     80101370 <bmap.part.0+0x70>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
80101323:	89 44 24 04          	mov    %eax,0x4(%esp)
80101327:	8b 03                	mov    (%ebx),%eax
80101329:	89 04 24             	mov    %eax,(%esp)
8010132c:	e8 9f ed ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101331:	8d 7c b8 5c          	lea    0x5c(%eax,%edi,4),%edi

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
80101335:	89 c6                	mov    %eax,%esi
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101337:	8b 07                	mov    (%edi),%eax
80101339:	85 c0                	test   %eax,%eax
8010133b:	75 17                	jne    80101354 <bmap.part.0+0x54>
      a[bn] = addr = balloc(ip->dev);
8010133d:	8b 03                	mov    (%ebx),%eax
8010133f:	e8 9c fe ff ff       	call   801011e0 <balloc>
80101344:	89 07                	mov    %eax,(%edi)
      log_write(bp);
80101346:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101349:	89 34 24             	mov    %esi,(%esp)
8010134c:	e8 df 19 00 00       	call   80102d30 <log_write>
80101351:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    }
    brelse(bp);
80101354:	89 34 24             	mov    %esi,(%esp)
80101357:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010135a:	e8 81 ee ff ff       	call   801001e0 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
8010135f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101362:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80101365:	8b 75 f8             	mov    -0x8(%ebp),%esi
80101368:	8b 7d fc             	mov    -0x4(%ebp),%edi
8010136b:	89 ec                	mov    %ebp,%esp
8010136d:	5d                   	pop    %ebp
8010136e:	c3                   	ret    
8010136f:	90                   	nop
  bn -= NDIRECT;

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101370:	8b 03                	mov    (%ebx),%eax
80101372:	e8 69 fe ff ff       	call   801011e0 <balloc>
80101377:	89 83 8c 00 00 00    	mov    %eax,0x8c(%ebx)
8010137d:	eb a4                	jmp    80101323 <bmap.part.0+0x23>
    }
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
8010137f:	c7 04 24 05 6e 10 80 	movl   $0x80106e05,(%esp)
80101386:	e8 e5 ef ff ff       	call   80100370 <panic>
8010138b:	90                   	nop
8010138c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101390 <readsb>:
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
80101390:	55                   	push   %ebp
80101391:	89 e5                	mov    %esp,%ebp
80101393:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;

  bp = bread(dev, 1);
80101396:	8b 45 08             	mov    0x8(%ebp),%eax
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
80101399:	89 5d f8             	mov    %ebx,-0x8(%ebp)
8010139c:	89 75 fc             	mov    %esi,-0x4(%ebp)
8010139f:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct buf *bp;

  bp = bread(dev, 1);
801013a2:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801013a9:	00 
801013aa:	89 04 24             	mov    %eax,(%esp)
801013ad:	e8 1e ed ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801013b2:	89 34 24             	mov    %esi,(%esp)
801013b5:	c7 44 24 08 1c 00 00 	movl   $0x1c,0x8(%esp)
801013bc:	00 
void
readsb(int dev, struct superblock *sb)
{
  struct buf *bp;

  bp = bread(dev, 1);
801013bd:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801013bf:	8d 40 5c             	lea    0x5c(%eax),%eax
801013c2:	89 44 24 04          	mov    %eax,0x4(%esp)
801013c6:	e8 25 30 00 00       	call   801043f0 <memmove>
  brelse(bp);
}
801013cb:	8b 75 fc             	mov    -0x4(%ebp),%esi
{
  struct buf *bp;

  bp = bread(dev, 1);
  memmove(sb, bp->data, sizeof(*sb));
  brelse(bp);
801013ce:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801013d1:	8b 5d f8             	mov    -0x8(%ebp),%ebx
801013d4:	89 ec                	mov    %ebp,%esp
801013d6:	5d                   	pop    %ebp
{
  struct buf *bp;

  bp = bread(dev, 1);
  memmove(sb, bp->data, sizeof(*sb));
  brelse(bp);
801013d7:	e9 04 ee ff ff       	jmp    801001e0 <brelse>
801013dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801013e0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801013e0:	55                   	push   %ebp
801013e1:	89 e5                	mov    %esp,%ebp
801013e3:	83 ec 28             	sub    $0x28,%esp
801013e6:	89 75 f8             	mov    %esi,-0x8(%ebp)
801013e9:	89 d6                	mov    %edx,%esi
801013eb:	89 5d f4             	mov    %ebx,-0xc(%ebp)
801013ee:	89 c3                	mov    %eax,%ebx
801013f0:	89 7d fc             	mov    %edi,-0x4(%ebp)
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
801013f3:	89 04 24             	mov    %eax,(%esp)
801013f6:	c7 44 24 04 c0 09 11 	movl   $0x801109c0,0x4(%esp)
801013fd:	80 
801013fe:	e8 8d ff ff ff       	call   80101390 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
80101403:	89 f0                	mov    %esi,%eax
80101405:	c1 e8 0c             	shr    $0xc,%eax
80101408:	03 05 d8 09 11 80    	add    0x801109d8,%eax
8010140e:	89 1c 24             	mov    %ebx,(%esp)
  bi = b % BPB;
80101411:	89 f3                	mov    %esi,%ebx
80101413:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
{
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
80101419:	89 44 24 04          	mov    %eax,0x4(%esp)
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
8010141d:	c1 fb 03             	sar    $0x3,%ebx
{
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
80101420:	e8 ab ec ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
80101425:	89 f1                	mov    %esi,%ecx
80101427:	be 01 00 00 00       	mov    $0x1,%esi
8010142c:	83 e1 07             	and    $0x7,%ecx
8010142f:	d3 e6                	shl    %cl,%esi
  if((bp->data[bi/8] & m) == 0)
80101431:	0f b6 54 18 5c       	movzbl 0x5c(%eax,%ebx,1),%edx
{
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
80101436:	89 c7                	mov    %eax,%edi
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
80101438:	0f b6 c2             	movzbl %dl,%eax
8010143b:	85 f0                	test   %esi,%eax
8010143d:	74 27                	je     80101466 <bfree+0x86>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
8010143f:	89 f0                	mov    %esi,%eax
80101441:	f7 d0                	not    %eax
80101443:	21 d0                	and    %edx,%eax
80101445:	88 44 1f 5c          	mov    %al,0x5c(%edi,%ebx,1)
  log_write(bp);
80101449:	89 3c 24             	mov    %edi,(%esp)
8010144c:	e8 df 18 00 00       	call   80102d30 <log_write>
  brelse(bp);
80101451:	89 3c 24             	mov    %edi,(%esp)
80101454:	e8 87 ed ff ff       	call   801001e0 <brelse>
}
80101459:	8b 5d f4             	mov    -0xc(%ebp),%ebx
8010145c:	8b 75 f8             	mov    -0x8(%ebp),%esi
8010145f:	8b 7d fc             	mov    -0x4(%ebp),%edi
80101462:	89 ec                	mov    %ebp,%esp
80101464:	5d                   	pop    %ebp
80101465:	c3                   	ret    
  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
80101466:	c7 04 24 18 6e 10 80 	movl   $0x80106e18,(%esp)
8010146d:	e8 fe ee ff ff       	call   80100370 <panic>
80101472:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101479:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101480 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
80101480:	55                   	push   %ebp
80101481:	89 e5                	mov    %esp,%ebp
80101483:	53                   	push   %ebx
  int i = 0;
  
  initlock(&icache.lock, "icache");
  for(i = 0; i < NINODE; i++) {
80101484:	31 db                	xor    %ebx,%ebx
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
80101486:	83 ec 24             	sub    $0x24,%esp
  int i = 0;
  
  initlock(&icache.lock, "icache");
80101489:	c7 44 24 04 2b 6e 10 	movl   $0x80106e2b,0x4(%esp)
80101490:	80 
80101491:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101498:	e8 73 2c 00 00       	call   80104110 <initlock>
8010149d:	8d 76 00             	lea    0x0(%esi),%esi
  for(i = 0; i < NINODE; i++) {
    initsleeplock(&icache.inode[i].lock, "inode");
801014a0:	8d 04 db             	lea    (%ebx,%ebx,8),%eax
iinit(int dev)
{
  int i = 0;
  
  initlock(&icache.lock, "icache");
  for(i = 0; i < NINODE; i++) {
801014a3:	83 c3 01             	add    $0x1,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
801014a6:	c1 e0 04             	shl    $0x4,%eax
801014a9:	05 20 0a 11 80       	add    $0x80110a20,%eax
801014ae:	c7 44 24 04 32 6e 10 	movl   $0x80106e32,0x4(%esp)
801014b5:	80 
801014b6:	89 04 24             	mov    %eax,(%esp)
801014b9:	e8 42 2b 00 00       	call   80104000 <initsleeplock>
iinit(int dev)
{
  int i = 0;
  
  initlock(&icache.lock, "icache");
  for(i = 0; i < NINODE; i++) {
801014be:	83 fb 32             	cmp    $0x32,%ebx
801014c1:	75 dd                	jne    801014a0 <iinit+0x20>
    initsleeplock(&icache.inode[i].lock, "inode");
  }

  readsb(dev, &sb);
801014c3:	8b 45 08             	mov    0x8(%ebp),%eax
801014c6:	c7 44 24 04 c0 09 11 	movl   $0x801109c0,0x4(%esp)
801014cd:	80 
801014ce:	89 04 24             	mov    %eax,(%esp)
801014d1:	e8 ba fe ff ff       	call   80101390 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801014d6:	a1 d8 09 11 80       	mov    0x801109d8,%eax
801014db:	c7 04 24 98 6e 10 80 	movl   $0x80106e98,(%esp)
801014e2:	89 44 24 1c          	mov    %eax,0x1c(%esp)
801014e6:	a1 d4 09 11 80       	mov    0x801109d4,%eax
801014eb:	89 44 24 18          	mov    %eax,0x18(%esp)
801014ef:	a1 d0 09 11 80       	mov    0x801109d0,%eax
801014f4:	89 44 24 14          	mov    %eax,0x14(%esp)
801014f8:	a1 cc 09 11 80       	mov    0x801109cc,%eax
801014fd:	89 44 24 10          	mov    %eax,0x10(%esp)
80101501:	a1 c8 09 11 80       	mov    0x801109c8,%eax
80101506:	89 44 24 0c          	mov    %eax,0xc(%esp)
8010150a:	a1 c4 09 11 80       	mov    0x801109c4,%eax
8010150f:	89 44 24 08          	mov    %eax,0x8(%esp)
80101513:	a1 c0 09 11 80       	mov    0x801109c0,%eax
80101518:	89 44 24 04          	mov    %eax,0x4(%esp)
8010151c:	e8 2f f1 ff ff       	call   80100650 <cprintf>
 inodestart %d bmap start %d\n", sb.size, sb.nblocks,
          sb.ninodes, sb.nlog, sb.logstart, sb.inodestart,
          sb.bmapstart);
}
80101521:	83 c4 24             	add    $0x24,%esp
80101524:	5b                   	pop    %ebx
80101525:	5d                   	pop    %ebp
80101526:	c3                   	ret    
80101527:	89 f6                	mov    %esi,%esi
80101529:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101530 <ialloc>:
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
80101530:	55                   	push   %ebp
80101531:	89 e5                	mov    %esp,%ebp
80101533:	57                   	push   %edi
80101534:	56                   	push   %esi
80101535:	53                   	push   %ebx
80101536:	83 ec 2c             	sub    $0x2c,%esp
80101539:	8b 45 08             	mov    0x8(%ebp),%eax
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
8010153c:	83 3d c8 09 11 80 01 	cmpl   $0x1,0x801109c8
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
80101543:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101546:	0f b7 45 0c          	movzwl 0xc(%ebp),%eax
8010154a:	66 89 45 e2          	mov    %ax,-0x1e(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
8010154e:	0f 86 95 00 00 00    	jbe    801015e9 <ialloc+0xb9>
80101554:	be 01 00 00 00       	mov    $0x1,%esi
80101559:	bb 01 00 00 00       	mov    $0x1,%ebx
8010155e:	eb 15                	jmp    80101575 <ialloc+0x45>
80101560:	83 c3 01             	add    $0x1,%ebx
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
80101563:	89 3c 24             	mov    %edi,(%esp)
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101566:	89 de                	mov    %ebx,%esi
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
80101568:	e8 73 ec ff ff       	call   801001e0 <brelse>
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
8010156d:	3b 1d c8 09 11 80    	cmp    0x801109c8,%ebx
80101573:	73 74                	jae    801015e9 <ialloc+0xb9>
    bp = bread(dev, IBLOCK(inum, sb));
80101575:	89 f0                	mov    %esi,%eax
80101577:	c1 e8 03             	shr    $0x3,%eax
8010157a:	03 05 d4 09 11 80    	add    0x801109d4,%eax
80101580:	89 44 24 04          	mov    %eax,0x4(%esp)
80101584:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101587:	89 04 24             	mov    %eax,(%esp)
8010158a:	e8 41 eb ff ff       	call   801000d0 <bread>
8010158f:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
80101591:	89 f0                	mov    %esi,%eax
80101593:	83 e0 07             	and    $0x7,%eax
80101596:	c1 e0 06             	shl    $0x6,%eax
80101599:	8d 54 07 5c          	lea    0x5c(%edi,%eax,1),%edx
    if(dip->type == 0){  // a free inode
8010159d:	66 83 3a 00          	cmpw   $0x0,(%edx)
801015a1:	75 bd                	jne    80101560 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
801015a3:	89 14 24             	mov    %edx,(%esp)
801015a6:	89 55 dc             	mov    %edx,-0x24(%ebp)
801015a9:	c7 44 24 08 40 00 00 	movl   $0x40,0x8(%esp)
801015b0:	00 
801015b1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801015b8:	00 
801015b9:	e8 72 2d 00 00       	call   80104330 <memset>
      dip->type = type;
801015be:	8b 55 dc             	mov    -0x24(%ebp),%edx
801015c1:	0f b7 45 e2          	movzwl -0x1e(%ebp),%eax
801015c5:	66 89 02             	mov    %ax,(%edx)
      log_write(bp);   // mark it allocated on the disk
801015c8:	89 3c 24             	mov    %edi,(%esp)
801015cb:	e8 60 17 00 00       	call   80102d30 <log_write>
      brelse(bp);
801015d0:	89 3c 24             	mov    %edi,(%esp)
801015d3:	e8 08 ec ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
801015d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
801015db:	83 c4 2c             	add    $0x2c,%esp
801015de:	5b                   	pop    %ebx
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
801015df:	89 f2                	mov    %esi,%edx
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
801015e1:	5e                   	pop    %esi
801015e2:	5f                   	pop    %edi
801015e3:	5d                   	pop    %ebp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
801015e4:	e9 37 fb ff ff       	jmp    80101120 <iget>
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
801015e9:	c7 04 24 38 6e 10 80 	movl   $0x80106e38,(%esp)
801015f0:	e8 7b ed ff ff       	call   80100370 <panic>
801015f5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801015f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101600 <iupdate>:
// Must be called after every change to an ip->xxx field
// that lives on disk, since i-node cache is write-through.
// Caller must hold ip->lock.
void
iupdate(struct inode *ip)
{
80101600:	55                   	push   %ebp
80101601:	89 e5                	mov    %esp,%ebp
80101603:	56                   	push   %esi
80101604:	53                   	push   %ebx
80101605:	83 ec 10             	sub    $0x10,%esp
80101608:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010160b:	8b 43 04             	mov    0x4(%ebx),%eax
8010160e:	c1 e8 03             	shr    $0x3,%eax
80101611:	03 05 d4 09 11 80    	add    0x801109d4,%eax
80101617:	89 44 24 04          	mov    %eax,0x4(%esp)
8010161b:	8b 03                	mov    (%ebx),%eax
8010161d:	89 04 24             	mov    %eax,(%esp)
80101620:	e8 ab ea ff ff       	call   801000d0 <bread>
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  dip->type = ip->type;
80101625:	0f b7 53 50          	movzwl 0x50(%ebx),%edx
iupdate(struct inode *ip)
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101629:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010162b:	8b 43 04             	mov    0x4(%ebx),%eax
8010162e:	83 e0 07             	and    $0x7,%eax
80101631:	c1 e0 06             	shl    $0x6,%eax
80101634:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101638:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010163b:	0f b7 53 52          	movzwl 0x52(%ebx),%edx
8010163f:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
80101643:	0f b7 53 54          	movzwl 0x54(%ebx),%edx
80101647:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
8010164b:	0f b7 53 56          	movzwl 0x56(%ebx),%edx
8010164f:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
80101653:	8b 53 58             	mov    0x58(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101656:	83 c3 5c             	add    $0x5c,%ebx
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  dip->type = ip->type;
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
80101659:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010165c:	83 c0 0c             	add    $0xc,%eax
8010165f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101663:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
8010166a:	00 
8010166b:	89 04 24             	mov    %eax,(%esp)
8010166e:	e8 7d 2d 00 00       	call   801043f0 <memmove>
  log_write(bp);
80101673:	89 34 24             	mov    %esi,(%esp)
80101676:	e8 b5 16 00 00       	call   80102d30 <log_write>
  brelse(bp);
8010167b:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010167e:	83 c4 10             	add    $0x10,%esp
80101681:	5b                   	pop    %ebx
80101682:	5e                   	pop    %esi
80101683:	5d                   	pop    %ebp
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
  log_write(bp);
  brelse(bp);
80101684:	e9 57 eb ff ff       	jmp    801001e0 <brelse>
80101689:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101690 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
80101690:	55                   	push   %ebp
80101691:	89 e5                	mov    %esp,%ebp
80101693:	53                   	push   %ebx
80101694:	83 ec 14             	sub    $0x14,%esp
80101697:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010169a:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801016a1:	e8 5a 2b 00 00       	call   80104200 <acquire>
  ip->ref++;
801016a6:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
801016aa:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801016b1:	e8 2a 2c 00 00       	call   801042e0 <release>
  return ip;
}
801016b6:	83 c4 14             	add    $0x14,%esp
801016b9:	89 d8                	mov    %ebx,%eax
801016bb:	5b                   	pop    %ebx
801016bc:	5d                   	pop    %ebp
801016bd:	c3                   	ret    
801016be:	66 90                	xchg   %ax,%ax

801016c0 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
801016c0:	55                   	push   %ebp
801016c1:	89 e5                	mov    %esp,%ebp
801016c3:	56                   	push   %esi
801016c4:	53                   	push   %ebx
801016c5:	83 ec 10             	sub    $0x10,%esp
801016c8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
801016cb:	85 db                	test   %ebx,%ebx
801016cd:	0f 84 b3 00 00 00    	je     80101786 <ilock+0xc6>
801016d3:	8b 4b 08             	mov    0x8(%ebx),%ecx
801016d6:	85 c9                	test   %ecx,%ecx
801016d8:	0f 8e a8 00 00 00    	jle    80101786 <ilock+0xc6>
    panic("ilock");

  acquiresleep(&ip->lock);
801016de:	8d 43 0c             	lea    0xc(%ebx),%eax
801016e1:	89 04 24             	mov    %eax,(%esp)
801016e4:	e8 57 29 00 00       	call   80104040 <acquiresleep>

  if(ip->valid == 0){
801016e9:	8b 53 4c             	mov    0x4c(%ebx),%edx
801016ec:	85 d2                	test   %edx,%edx
801016ee:	74 08                	je     801016f8 <ilock+0x38>
    brelse(bp);
    ip->valid = 1;
    if(ip->type == 0)
      panic("ilock: no type");
  }
}
801016f0:	83 c4 10             	add    $0x10,%esp
801016f3:	5b                   	pop    %ebx
801016f4:	5e                   	pop    %esi
801016f5:	5d                   	pop    %ebp
801016f6:	c3                   	ret    
801016f7:	90                   	nop
    panic("ilock");

  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016f8:	8b 43 04             	mov    0x4(%ebx),%eax
801016fb:	c1 e8 03             	shr    $0x3,%eax
801016fe:	03 05 d4 09 11 80    	add    0x801109d4,%eax
80101704:	89 44 24 04          	mov    %eax,0x4(%esp)
80101708:	8b 03                	mov    (%ebx),%eax
8010170a:	89 04 24             	mov    %eax,(%esp)
8010170d:	e8 be e9 ff ff       	call   801000d0 <bread>
80101712:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101714:	8b 43 04             	mov    0x4(%ebx),%eax
80101717:	83 e0 07             	and    $0x7,%eax
8010171a:	c1 e0 06             	shl    $0x6,%eax
8010171d:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101721:	0f b7 10             	movzwl (%eax),%edx
80101724:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101728:	0f b7 50 02          	movzwl 0x2(%eax),%edx
8010172c:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
80101730:	0f b7 50 04          	movzwl 0x4(%eax),%edx
80101734:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101738:	0f b7 50 06          	movzwl 0x6(%eax),%edx
8010173c:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
80101740:	8b 50 08             	mov    0x8(%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101743:	83 c0 0c             	add    $0xc,%eax
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    ip->type = dip->type;
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
80101746:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101749:	89 44 24 04          	mov    %eax,0x4(%esp)
8010174d:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101750:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
80101757:	00 
80101758:	89 04 24             	mov    %eax,(%esp)
8010175b:	e8 90 2c 00 00       	call   801043f0 <memmove>
    brelse(bp);
80101760:	89 34 24             	mov    %esi,(%esp)
80101763:	e8 78 ea ff ff       	call   801001e0 <brelse>
    ip->valid = 1;
    if(ip->type == 0)
80101768:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    brelse(bp);
    ip->valid = 1;
8010176d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101774:	0f 85 76 ff ff ff    	jne    801016f0 <ilock+0x30>
      panic("ilock: no type");
8010177a:	c7 04 24 50 6e 10 80 	movl   $0x80106e50,(%esp)
80101781:	e8 ea eb ff ff       	call   80100370 <panic>
{
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
    panic("ilock");
80101786:	c7 04 24 4a 6e 10 80 	movl   $0x80106e4a,(%esp)
8010178d:	e8 de eb ff ff       	call   80100370 <panic>
80101792:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101799:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801017a0 <iunlock>:
}

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
801017a0:	55                   	push   %ebp
801017a1:	89 e5                	mov    %esp,%ebp
801017a3:	83 ec 18             	sub    $0x18,%esp
801017a6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
801017a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801017ac:	89 75 fc             	mov    %esi,-0x4(%ebp)
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801017af:	85 db                	test   %ebx,%ebx
801017b1:	74 27                	je     801017da <iunlock+0x3a>
801017b3:	8d 73 0c             	lea    0xc(%ebx),%esi
801017b6:	89 34 24             	mov    %esi,(%esp)
801017b9:	e8 22 29 00 00       	call   801040e0 <holdingsleep>
801017be:	85 c0                	test   %eax,%eax
801017c0:	74 18                	je     801017da <iunlock+0x3a>
801017c2:	8b 5b 08             	mov    0x8(%ebx),%ebx
801017c5:	85 db                	test   %ebx,%ebx
801017c7:	7e 11                	jle    801017da <iunlock+0x3a>
    panic("iunlock");

  releasesleep(&ip->lock);
801017c9:	89 75 08             	mov    %esi,0x8(%ebp)
}
801017cc:	8b 5d f8             	mov    -0x8(%ebp),%ebx
801017cf:	8b 75 fc             	mov    -0x4(%ebp),%esi
801017d2:	89 ec                	mov    %ebp,%esp
801017d4:	5d                   	pop    %ebp
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");

  releasesleep(&ip->lock);
801017d5:	e9 c6 28 00 00       	jmp    801040a0 <releasesleep>
// Unlock the given inode.
void
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");
801017da:	c7 04 24 5f 6e 10 80 	movl   $0x80106e5f,(%esp)
801017e1:	e8 8a eb ff ff       	call   80100370 <panic>
801017e6:	8d 76 00             	lea    0x0(%esi),%esi
801017e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801017f0 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
801017f0:	55                   	push   %ebp
801017f1:	89 e5                	mov    %esp,%ebp
801017f3:	83 ec 38             	sub    $0x38,%esp
801017f6:	89 75 f8             	mov    %esi,-0x8(%ebp)
801017f9:	8b 75 08             	mov    0x8(%ebp),%esi
801017fc:	89 7d fc             	mov    %edi,-0x4(%ebp)
801017ff:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  acquiresleep(&ip->lock);
80101802:	8d 7e 0c             	lea    0xc(%esi),%edi
80101805:	89 3c 24             	mov    %edi,(%esp)
80101808:	e8 33 28 00 00       	call   80104040 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
8010180d:	8b 46 4c             	mov    0x4c(%esi),%eax
80101810:	85 c0                	test   %eax,%eax
80101812:	74 07                	je     8010181b <iput+0x2b>
80101814:	66 83 7e 56 00       	cmpw   $0x0,0x56(%esi)
80101819:	74 35                	je     80101850 <iput+0x60>
      ip->type = 0;
      iupdate(ip);
      ip->valid = 0;
    }
  }
  releasesleep(&ip->lock);
8010181b:	89 3c 24             	mov    %edi,(%esp)
8010181e:	e8 7d 28 00 00       	call   801040a0 <releasesleep>

  acquire(&icache.lock);
80101823:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010182a:	e8 d1 29 00 00       	call   80104200 <acquire>
  ip->ref--;
8010182f:	83 6e 08 01          	subl   $0x1,0x8(%esi)
  release(&icache.lock);
}
80101833:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  }
  releasesleep(&ip->lock);

  acquire(&icache.lock);
  ip->ref--;
  release(&icache.lock);
80101836:	c7 45 08 e0 09 11 80 	movl   $0x801109e0,0x8(%ebp)
}
8010183d:	8b 75 f8             	mov    -0x8(%ebp),%esi
80101840:	8b 7d fc             	mov    -0x4(%ebp),%edi
80101843:	89 ec                	mov    %ebp,%esp
80101845:	5d                   	pop    %ebp
  }
  releasesleep(&ip->lock);

  acquire(&icache.lock);
  ip->ref--;
  release(&icache.lock);
80101846:	e9 95 2a 00 00       	jmp    801042e0 <release>
8010184b:	90                   	nop
8010184c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
void
iput(struct inode *ip)
{
  acquiresleep(&ip->lock);
  if(ip->valid && ip->nlink == 0){
    acquire(&icache.lock);
80101850:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101857:	e8 a4 29 00 00       	call   80104200 <acquire>
    int r = ip->ref;
8010185c:	8b 5e 08             	mov    0x8(%esi),%ebx
    release(&icache.lock);
8010185f:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101866:	e8 75 2a 00 00       	call   801042e0 <release>
    if(r == 1){
8010186b:	83 fb 01             	cmp    $0x1,%ebx
8010186e:	75 ab                	jne    8010181b <iput+0x2b>
// If that was the last reference and the inode has no links
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
80101870:	8d 4e 30             	lea    0x30(%esi),%ecx
  acquiresleep(&ip->lock);
  if(ip->valid && ip->nlink == 0){
    acquire(&icache.lock);
    int r = ip->ref;
    release(&icache.lock);
    if(r == 1){
80101873:	89 f3                	mov    %esi,%ebx
// If that was the last reference and the inode has no links
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
80101875:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101878:	89 cf                	mov    %ecx,%edi
8010187a:	eb 0b                	jmp    80101887 <iput+0x97>
8010187c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    if(ip->addrs[i]){
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
80101880:	83 c3 04             	add    $0x4,%ebx
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101883:	39 fb                	cmp    %edi,%ebx
80101885:	74 19                	je     801018a0 <iput+0xb0>
    if(ip->addrs[i]){
80101887:	8b 53 5c             	mov    0x5c(%ebx),%edx
8010188a:	85 d2                	test   %edx,%edx
8010188c:	74 f2                	je     80101880 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010188e:	8b 06                	mov    (%esi),%eax
80101890:	e8 4b fb ff ff       	call   801013e0 <bfree>
      ip->addrs[i] = 0;
80101895:	c7 43 5c 00 00 00 00 	movl   $0x0,0x5c(%ebx)
8010189c:	eb e2                	jmp    80101880 <iput+0x90>
8010189e:	66 90                	xchg   %ax,%ax
    }
  }

  if(ip->addrs[NDIRECT]){
801018a0:	8b 86 8c 00 00 00    	mov    0x8c(%esi),%eax
801018a6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801018a9:	85 c0                	test   %eax,%eax
801018ab:	75 2b                	jne    801018d8 <iput+0xe8>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
801018ad:	c7 46 58 00 00 00 00 	movl   $0x0,0x58(%esi)
  iupdate(ip);
801018b4:	89 34 24             	mov    %esi,(%esp)
801018b7:	e8 44 fd ff ff       	call   80101600 <iupdate>
    int r = ip->ref;
    release(&icache.lock);
    if(r == 1){
      // inode has no links and no other references: truncate and free.
      itrunc(ip);
      ip->type = 0;
801018bc:	66 c7 46 50 00 00    	movw   $0x0,0x50(%esi)
      iupdate(ip);
801018c2:	89 34 24             	mov    %esi,(%esp)
801018c5:	e8 36 fd ff ff       	call   80101600 <iupdate>
      ip->valid = 0;
801018ca:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
801018d1:	e9 45 ff ff ff       	jmp    8010181b <iput+0x2b>
801018d6:	66 90                	xchg   %ax,%ax
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018d8:	89 44 24 04          	mov    %eax,0x4(%esp)
801018dc:	8b 06                	mov    (%esi),%eax
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
801018de:	31 db                	xor    %ebx,%ebx
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018e0:	89 04 24             	mov    %eax,(%esp)
801018e3:	e8 e8 e7 ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
801018e8:	89 7d e0             	mov    %edi,-0x20(%ebp)
801018eb:	89 f7                	mov    %esi,%edi
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    a = (uint*)bp->data;
801018ed:	89 c1                	mov    %eax,%ecx
801018ef:	83 c1 5c             	add    $0x5c,%ecx
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018f2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
801018f5:	89 ce                	mov    %ecx,%esi
801018f7:	31 c0                	xor    %eax,%eax
801018f9:	eb 12                	jmp    8010190d <iput+0x11d>
801018fb:	90                   	nop
801018fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101900:	83 c3 01             	add    $0x1,%ebx
80101903:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
80101909:	89 d8                	mov    %ebx,%eax
8010190b:	74 10                	je     8010191d <iput+0x12d>
      if(a[j])
8010190d:	8b 14 86             	mov    (%esi,%eax,4),%edx
80101910:	85 d2                	test   %edx,%edx
80101912:	74 ec                	je     80101900 <iput+0x110>
        bfree(ip->dev, a[j]);
80101914:	8b 07                	mov    (%edi),%eax
80101916:	e8 c5 fa ff ff       	call   801013e0 <bfree>
8010191b:	eb e3                	jmp    80101900 <iput+0x110>
    }
    brelse(bp);
8010191d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101920:	89 fe                	mov    %edi,%esi
80101922:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101925:	89 04 24             	mov    %eax,(%esp)
80101928:	e8 b3 e8 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
8010192d:	8b 96 8c 00 00 00    	mov    0x8c(%esi),%edx
80101933:	8b 06                	mov    (%esi),%eax
80101935:	e8 a6 fa ff ff       	call   801013e0 <bfree>
    ip->addrs[NDIRECT] = 0;
8010193a:	c7 86 8c 00 00 00 00 	movl   $0x0,0x8c(%esi)
80101941:	00 00 00 
80101944:	e9 64 ff ff ff       	jmp    801018ad <iput+0xbd>
80101949:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101950 <iunlockput>:
}

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101950:	55                   	push   %ebp
80101951:	89 e5                	mov    %esp,%ebp
80101953:	53                   	push   %ebx
80101954:	83 ec 14             	sub    $0x14,%esp
80101957:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
8010195a:	89 1c 24             	mov    %ebx,(%esp)
8010195d:	e8 3e fe ff ff       	call   801017a0 <iunlock>
  iput(ip);
80101962:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80101965:	83 c4 14             	add    $0x14,%esp
80101968:	5b                   	pop    %ebx
80101969:	5d                   	pop    %ebp
// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
  iput(ip);
8010196a:	e9 81 fe ff ff       	jmp    801017f0 <iput>
8010196f:	90                   	nop

80101970 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101970:	55                   	push   %ebp
80101971:	89 e5                	mov    %esp,%ebp
80101973:	8b 55 08             	mov    0x8(%ebp),%edx
80101976:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101979:	8b 0a                	mov    (%edx),%ecx
8010197b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010197e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101981:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101984:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101988:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010198b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010198f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101993:	8b 52 58             	mov    0x58(%edx),%edx
80101996:	89 50 10             	mov    %edx,0x10(%eax)
}
80101999:	5d                   	pop    %ebp
8010199a:	c3                   	ret    
8010199b:	90                   	nop
8010199c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801019a0 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
801019a0:	55                   	push   %ebp
801019a1:	89 e5                	mov    %esp,%ebp
801019a3:	57                   	push   %edi
801019a4:	56                   	push   %esi
801019a5:	53                   	push   %ebx
801019a6:	83 ec 2c             	sub    $0x2c,%esp
801019a9:	8b 75 08             	mov    0x8(%ebp),%esi
801019ac:	8b 45 0c             	mov    0xc(%ebp),%eax
801019af:	8b 55 14             	mov    0x14(%ebp),%edx
801019b2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
801019b5:	66 83 7e 50 03       	cmpw   $0x3,0x50(%esi)
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
801019ba:	89 45 e0             	mov    %eax,-0x20(%ebp)
801019bd:	89 55 dc             	mov    %edx,-0x24(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
801019c0:	0f 84 da 00 00 00    	je     80101aa0 <readi+0x100>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
801019c6:	8b 56 58             	mov    0x58(%esi),%edx
    return -1;
801019c9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
801019ce:	39 da                	cmp    %ebx,%edx
801019d0:	0f 82 bd 00 00 00    	jb     80101a93 <readi+0xf3>
801019d6:	8b 4d dc             	mov    -0x24(%ebp),%ecx
801019d9:	01 d9                	add    %ebx,%ecx
801019db:	0f 82 b2 00 00 00    	jb     80101a93 <readi+0xf3>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
801019e1:	89 d0                	mov    %edx,%eax
801019e3:	29 d8                	sub    %ebx,%eax
801019e5:	39 ca                	cmp    %ecx,%edx
801019e7:	0f 43 45 dc          	cmovae -0x24(%ebp),%eax

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019eb:	85 c0                	test   %eax,%eax
  }

  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
801019ed:	89 45 dc             	mov    %eax,-0x24(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019f0:	0f 84 9a 00 00 00    	je     80101a90 <readi+0xf0>
801019f6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801019fd:	eb 6a                	jmp    80101a69 <readi+0xc9>
801019ff:	90                   	nop
{
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
80101a00:	8d 7a 14             	lea    0x14(%edx),%edi
80101a03:	8b 44 be 0c          	mov    0xc(%esi,%edi,4),%eax
80101a07:	85 c0                	test   %eax,%eax
80101a09:	74 75                	je     80101a80 <readi+0xe0>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a0b:	89 44 24 04          	mov    %eax,0x4(%esp)
80101a0f:	8b 06                	mov    (%esi),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101a11:	bf 00 02 00 00       	mov    $0x200,%edi
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a16:	89 04 24             	mov    %eax,(%esp)
80101a19:	e8 b2 e6 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101a1e:	8b 4d dc             	mov    -0x24(%ebp),%ecx
80101a21:	2b 4d e4             	sub    -0x1c(%ebp),%ecx
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a24:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101a26:	89 d8                	mov    %ebx,%eax
80101a28:	25 ff 01 00 00       	and    $0x1ff,%eax
80101a2d:	29 c7                	sub    %eax,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101a2f:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101a33:	39 cf                	cmp    %ecx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101a35:	89 44 24 04          	mov    %eax,0x4(%esp)
80101a39:	8b 45 e0             	mov    -0x20(%ebp),%eax
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101a3c:	0f 47 f9             	cmova  %ecx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101a3f:	89 55 d8             	mov    %edx,-0x28(%ebp)
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a42:	01 fb                	add    %edi,%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
80101a44:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101a48:	89 04 24             	mov    %eax,(%esp)
80101a4b:	e8 a0 29 00 00       	call   801043f0 <memmove>
    brelse(bp);
80101a50:	8b 55 d8             	mov    -0x28(%ebp),%edx
80101a53:	89 14 24             	mov    %edx,(%esp)
80101a56:	e8 85 e7 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a5b:	01 7d e4             	add    %edi,-0x1c(%ebp)
80101a5e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101a61:	01 7d e0             	add    %edi,-0x20(%ebp)
80101a64:	39 55 dc             	cmp    %edx,-0x24(%ebp)
80101a67:	76 27                	jbe    80101a90 <readi+0xf0>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a69:	89 da                	mov    %ebx,%edx
80101a6b:	c1 ea 09             	shr    $0x9,%edx
bmap(struct inode *ip, uint bn)
{
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101a6e:	83 fa 0b             	cmp    $0xb,%edx
80101a71:	76 8d                	jbe    80101a00 <readi+0x60>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
80101a73:	89 f0                	mov    %esi,%eax
80101a75:	e8 86 f8 ff ff       	call   80101300 <bmap.part.0>
80101a7a:	eb 8f                	jmp    80101a0b <readi+0x6b>
80101a7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101a80:	8b 06                	mov    (%esi),%eax
80101a82:	e8 59 f7 ff ff       	call   801011e0 <balloc>
80101a87:	89 44 be 0c          	mov    %eax,0xc(%esi,%edi,4)
80101a8b:	e9 7b ff ff ff       	jmp    80101a0b <readi+0x6b>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80101a90:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
80101a93:	83 c4 2c             	add    $0x2c,%esp
80101a96:	5b                   	pop    %ebx
80101a97:	5e                   	pop    %esi
80101a98:	5f                   	pop    %edi
80101a99:	5d                   	pop    %ebp
80101a9a:	c3                   	ret    
80101a9b:	90                   	nop
80101a9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101aa0:	0f b7 46 52          	movzwl 0x52(%esi),%eax
80101aa4:	66 83 f8 09          	cmp    $0x9,%ax
80101aa8:	77 18                	ja     80101ac2 <readi+0x122>
80101aaa:	98                   	cwtl   
80101aab:	8b 04 c5 60 09 11 80 	mov    -0x7feef6a0(,%eax,8),%eax
80101ab2:	85 c0                	test   %eax,%eax
80101ab4:	74 0c                	je     80101ac2 <readi+0x122>
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101ab6:	89 55 10             	mov    %edx,0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
}
80101ab9:	83 c4 2c             	add    $0x2c,%esp
80101abc:	5b                   	pop    %ebx
80101abd:	5e                   	pop    %esi
80101abe:	5f                   	pop    %edi
80101abf:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101ac0:	ff e0                	jmp    *%eax
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
80101ac2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ac7:	eb ca                	jmp    80101a93 <readi+0xf3>
80101ac9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101ad0 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101ad0:	55                   	push   %ebp
80101ad1:	89 e5                	mov    %esp,%ebp
80101ad3:	57                   	push   %edi
80101ad4:	56                   	push   %esi
80101ad5:	53                   	push   %ebx
80101ad6:	83 ec 2c             	sub    $0x2c,%esp
80101ad9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101adc:	8b 75 08             	mov    0x8(%ebp),%esi
80101adf:	8b 5d 10             	mov    0x10(%ebp),%ebx
80101ae2:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101ae5:	8b 4d 14             	mov    0x14(%ebp),%ecx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101ae8:	66 83 7e 50 03       	cmpw   $0x3,0x50(%esi)
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101aed:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101af0:	0f 84 f2 00 00 00    	je     80101be8 <writei+0x118>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101af6:	39 5e 58             	cmp    %ebx,0x58(%esi)
    return -1;
80101af9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101afe:	0f 82 d7 00 00 00    	jb     80101bdb <writei+0x10b>
80101b04:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101b07:	01 da                	add    %ebx,%edx
80101b09:	0f 82 cc 00 00 00    	jb     80101bdb <writei+0x10b>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101b0f:	81 fa 00 18 01 00    	cmp    $0x11800,%edx
80101b15:	0f 87 c0 00 00 00    	ja     80101bdb <writei+0x10b>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b1b:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101b1e:	85 c0                	test   %eax,%eax
80101b20:	0f 84 b2 00 00 00    	je     80101bd8 <writei+0x108>
80101b26:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101b2d:	eb 75                	jmp    80101ba4 <writei+0xd4>
80101b2f:	90                   	nop
{
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
80101b30:	8d 7a 14             	lea    0x14(%edx),%edi
80101b33:	8b 44 be 0c          	mov    0xc(%esi,%edi,4),%eax
80101b37:	85 c0                	test   %eax,%eax
80101b39:	74 7d                	je     80101bb8 <writei+0xe8>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b3b:	89 44 24 04          	mov    %eax,0x4(%esp)
80101b3f:	8b 06                	mov    (%esi),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b41:	bf 00 02 00 00       	mov    $0x200,%edi
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b46:	89 04 24             	mov    %eax,(%esp)
80101b49:	e8 82 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b4e:	8b 4d dc             	mov    -0x24(%ebp),%ecx
80101b51:	2b 4d e4             	sub    -0x1c(%ebp),%ecx
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b54:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101b56:	89 d8                	mov    %ebx,%eax
80101b58:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b5d:	29 c7                	sub    %eax,%edi
80101b5f:	39 cf                	cmp    %ecx,%edi
80101b61:	0f 47 f9             	cmova  %ecx,%edi
    memmove(bp->data + off%BSIZE, src, m);
80101b64:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101b67:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b6b:	01 fb                	add    %edi,%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(bp->data + off%BSIZE, src, m);
80101b6d:	89 55 d8             	mov    %edx,-0x28(%ebp)
80101b70:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101b74:	89 4c 24 04          	mov    %ecx,0x4(%esp)
80101b78:	89 04 24             	mov    %eax,(%esp)
80101b7b:	e8 70 28 00 00       	call   801043f0 <memmove>
    log_write(bp);
80101b80:	8b 55 d8             	mov    -0x28(%ebp),%edx
80101b83:	89 14 24             	mov    %edx,(%esp)
80101b86:	e8 a5 11 00 00       	call   80102d30 <log_write>
    brelse(bp);
80101b8b:	8b 55 d8             	mov    -0x28(%ebp),%edx
80101b8e:	89 14 24             	mov    %edx,(%esp)
80101b91:	e8 4a e6 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b96:	01 7d e4             	add    %edi,-0x1c(%ebp)
80101b99:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101b9c:	01 7d e0             	add    %edi,-0x20(%ebp)
80101b9f:	39 4d dc             	cmp    %ecx,-0x24(%ebp)
80101ba2:	76 24                	jbe    80101bc8 <writei+0xf8>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ba4:	89 da                	mov    %ebx,%edx
80101ba6:	c1 ea 09             	shr    $0x9,%edx
bmap(struct inode *ip, uint bn)
{
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101ba9:	83 fa 0b             	cmp    $0xb,%edx
80101bac:	76 82                	jbe    80101b30 <writei+0x60>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
80101bae:	89 f0                	mov    %esi,%eax
80101bb0:	e8 4b f7 ff ff       	call   80101300 <bmap.part.0>
80101bb5:	eb 84                	jmp    80101b3b <writei+0x6b>
80101bb7:	90                   	nop
80101bb8:	8b 06                	mov    (%esi),%eax
80101bba:	e8 21 f6 ff ff       	call   801011e0 <balloc>
80101bbf:	89 44 be 0c          	mov    %eax,0xc(%esi,%edi,4)
80101bc3:	e9 73 ff ff ff       	jmp    80101b3b <writei+0x6b>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
80101bc8:	39 5e 58             	cmp    %ebx,0x58(%esi)
80101bcb:	73 0b                	jae    80101bd8 <writei+0x108>
    ip->size = off;
80101bcd:	89 5e 58             	mov    %ebx,0x58(%esi)
    iupdate(ip);
80101bd0:	89 34 24             	mov    %esi,(%esp)
80101bd3:	e8 28 fa ff ff       	call   80101600 <iupdate>
  }
  return n;
80101bd8:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
80101bdb:	83 c4 2c             	add    $0x2c,%esp
80101bde:	5b                   	pop    %ebx
80101bdf:	5e                   	pop    %esi
80101be0:	5f                   	pop    %edi
80101be1:	5d                   	pop    %ebp
80101be2:	c3                   	ret    
80101be3:	90                   	nop
80101be4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101be8:	0f b7 46 52          	movzwl 0x52(%esi),%eax
80101bec:	66 83 f8 09          	cmp    $0x9,%ax
80101bf0:	77 18                	ja     80101c0a <writei+0x13a>
80101bf2:	98                   	cwtl   
80101bf3:	8b 04 c5 64 09 11 80 	mov    -0x7feef69c(,%eax,8),%eax
80101bfa:	85 c0                	test   %eax,%eax
80101bfc:	74 0c                	je     80101c0a <writei+0x13a>
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101bfe:	89 4d 10             	mov    %ecx,0x10(%ebp)
  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
}
80101c01:	83 c4 2c             	add    $0x2c,%esp
80101c04:	5b                   	pop    %ebx
80101c05:	5e                   	pop    %esi
80101c06:	5f                   	pop    %edi
80101c07:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101c08:	ff e0                	jmp    *%eax
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
80101c0a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101c0f:	eb ca                	jmp    80101bdb <writei+0x10b>
80101c11:	eb 0d                	jmp    80101c20 <namecmp>
80101c13:	90                   	nop
80101c14:	90                   	nop
80101c15:	90                   	nop
80101c16:	90                   	nop
80101c17:	90                   	nop
80101c18:	90                   	nop
80101c19:	90                   	nop
80101c1a:	90                   	nop
80101c1b:	90                   	nop
80101c1c:	90                   	nop
80101c1d:	90                   	nop
80101c1e:	90                   	nop
80101c1f:	90                   	nop

80101c20 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101c20:	55                   	push   %ebp
80101c21:	89 e5                	mov    %esp,%ebp
80101c23:	83 ec 18             	sub    $0x18,%esp
  return strncmp(s, t, DIRSIZ);
80101c26:	8b 45 0c             	mov    0xc(%ebp),%eax
80101c29:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101c30:	00 
80101c31:	89 44 24 04          	mov    %eax,0x4(%esp)
80101c35:	8b 45 08             	mov    0x8(%ebp),%eax
80101c38:	89 04 24             	mov    %eax,(%esp)
80101c3b:	e8 30 28 00 00       	call   80104470 <strncmp>
}
80101c40:	c9                   	leave  
80101c41:	c3                   	ret    
80101c42:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101c50 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101c50:	55                   	push   %ebp
80101c51:	89 e5                	mov    %esp,%ebp
80101c53:	57                   	push   %edi
80101c54:	56                   	push   %esi
80101c55:	53                   	push   %ebx
80101c56:	83 ec 2c             	sub    $0x2c,%esp
80101c59:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101c5c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101c61:	0f 85 8f 00 00 00    	jne    80101cf6 <dirlookup+0xa6>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101c67:	8b 43 58             	mov    0x58(%ebx),%eax
80101c6a:	31 f6                	xor    %esi,%esi
80101c6c:	8d 7d d8             	lea    -0x28(%ebp),%edi
80101c6f:	85 c0                	test   %eax,%eax
80101c71:	75 0d                	jne    80101c80 <dirlookup+0x30>
80101c73:	eb 6b                	jmp    80101ce0 <dirlookup+0x90>
80101c75:	8d 76 00             	lea    0x0(%esi),%esi
80101c78:	83 c6 10             	add    $0x10,%esi
80101c7b:	39 73 58             	cmp    %esi,0x58(%ebx)
80101c7e:	76 60                	jbe    80101ce0 <dirlookup+0x90>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101c80:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101c87:	00 
80101c88:	89 74 24 08          	mov    %esi,0x8(%esp)
80101c8c:	89 7c 24 04          	mov    %edi,0x4(%esp)
80101c90:	89 1c 24             	mov    %ebx,(%esp)
80101c93:	e8 08 fd ff ff       	call   801019a0 <readi>
80101c98:	83 f8 10             	cmp    $0x10,%eax
80101c9b:	75 4d                	jne    80101cea <dirlookup+0x9a>
      panic("dirlookup read");
    if(de.inum == 0)
80101c9d:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101ca2:	74 d4                	je     80101c78 <dirlookup+0x28>
      continue;
    if(namecmp(name, de.name) == 0){
80101ca4:	8d 45 da             	lea    -0x26(%ebp),%eax
80101ca7:	89 44 24 04          	mov    %eax,0x4(%esp)
80101cab:	8b 45 0c             	mov    0xc(%ebp),%eax
80101cae:	89 04 24             	mov    %eax,(%esp)
80101cb1:	e8 6a ff ff ff       	call   80101c20 <namecmp>
80101cb6:	85 c0                	test   %eax,%eax
80101cb8:	75 be                	jne    80101c78 <dirlookup+0x28>
      // entry matches path element
      if(poff)
80101cba:	8b 45 10             	mov    0x10(%ebp),%eax
80101cbd:	85 c0                	test   %eax,%eax
80101cbf:	74 05                	je     80101cc6 <dirlookup+0x76>
        *poff = off;
80101cc1:	8b 45 10             	mov    0x10(%ebp),%eax
80101cc4:	89 30                	mov    %esi,(%eax)
      inum = de.inum;
80101cc6:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101cca:	8b 03                	mov    (%ebx),%eax
80101ccc:	e8 4f f4 ff ff       	call   80101120 <iget>
    }
  }

  return 0;
}
80101cd1:	83 c4 2c             	add    $0x2c,%esp
80101cd4:	5b                   	pop    %ebx
80101cd5:	5e                   	pop    %esi
80101cd6:	5f                   	pop    %edi
80101cd7:	5d                   	pop    %ebp
80101cd8:	c3                   	ret    
80101cd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ce0:	83 c4 2c             	add    $0x2c,%esp
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
80101ce3:	31 c0                	xor    %eax,%eax
}
80101ce5:	5b                   	pop    %ebx
80101ce6:	5e                   	pop    %esi
80101ce7:	5f                   	pop    %edi
80101ce8:	5d                   	pop    %ebp
80101ce9:	c3                   	ret    
  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlookup read");
80101cea:	c7 04 24 79 6e 10 80 	movl   $0x80106e79,(%esp)
80101cf1:	e8 7a e6 ff ff       	call   80100370 <panic>
{
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");
80101cf6:	c7 04 24 67 6e 10 80 	movl   $0x80106e67,(%esp)
80101cfd:	e8 6e e6 ff ff       	call   80100370 <panic>
80101d02:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101d10 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101d10:	55                   	push   %ebp
80101d11:	89 e5                	mov    %esp,%ebp
80101d13:	57                   	push   %edi
80101d14:	56                   	push   %esi
80101d15:	53                   	push   %ebx
80101d16:	89 c3                	mov    %eax,%ebx
80101d18:	83 ec 2c             	sub    $0x2c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101d1b:	80 38 2f             	cmpb   $0x2f,(%eax)
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101d1e:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101d21:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  struct inode *ip, *next;

  if(*path == '/')
80101d24:	0f 84 1d 01 00 00    	je     80101e47 <namex+0x137>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101d2a:	e8 21 1a 00 00       	call   80103750 <myproc>
80101d2f:	8b 40 68             	mov    0x68(%eax),%eax
80101d32:	89 04 24             	mov    %eax,(%esp)
80101d35:	e8 56 f9 ff ff       	call   80101690 <idup>
80101d3a:	89 c7                	mov    %eax,%edi
80101d3c:	eb 05                	jmp    80101d43 <namex+0x33>
80101d3e:	66 90                	xchg   %ax,%ax
{
  char *s;
  int len;

  while(*path == '/')
    path++;
80101d40:	83 c3 01             	add    $0x1,%ebx
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
80101d43:	0f b6 03             	movzbl (%ebx),%eax
80101d46:	3c 2f                	cmp    $0x2f,%al
80101d48:	74 f6                	je     80101d40 <namex+0x30>
    path++;
  if(*path == 0)
80101d4a:	84 c0                	test   %al,%al
80101d4c:	75 1a                	jne    80101d68 <namex+0x58>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101d4e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101d51:	85 c0                	test   %eax,%eax
80101d53:	0f 85 3b 01 00 00    	jne    80101e94 <namex+0x184>
    iput(ip);
    return 0;
  }
  return ip;
}
80101d59:	83 c4 2c             	add    $0x2c,%esp
80101d5c:	89 f8                	mov    %edi,%eax
80101d5e:	5b                   	pop    %ebx
80101d5f:	5e                   	pop    %esi
80101d60:	5f                   	pop    %edi
80101d61:	5d                   	pop    %ebp
80101d62:	c3                   	ret    
80101d63:	90                   	nop
80101d64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101d68:	0f b6 03             	movzbl (%ebx),%eax
80101d6b:	89 de                	mov    %ebx,%esi
80101d6d:	84 c0                	test   %al,%al
80101d6f:	0f 84 a6 00 00 00    	je     80101e1b <namex+0x10b>
80101d75:	3c 2f                	cmp    $0x2f,%al
80101d77:	75 0b                	jne    80101d84 <namex+0x74>
80101d79:	e9 9d 00 00 00       	jmp    80101e1b <namex+0x10b>
80101d7e:	66 90                	xchg   %ax,%ax
80101d80:	3c 2f                	cmp    $0x2f,%al
80101d82:	74 0a                	je     80101d8e <namex+0x7e>
    path++;
80101d84:	83 c6 01             	add    $0x1,%esi
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101d87:	0f b6 06             	movzbl (%esi),%eax
80101d8a:	84 c0                	test   %al,%al
80101d8c:	75 f2                	jne    80101d80 <namex+0x70>
80101d8e:	89 f2                	mov    %esi,%edx
80101d90:	29 da                	sub    %ebx,%edx
    path++;
  len = path - s;
  if(len >= DIRSIZ)
80101d92:	83 fa 0d             	cmp    $0xd,%edx
80101d95:	0f 8e 85 00 00 00    	jle    80101e20 <namex+0x110>
    memmove(name, s, DIRSIZ);
80101d9b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d9e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
80101da2:	89 f3                	mov    %esi,%ebx
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
80101da4:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101dab:	00 
80101dac:	89 04 24             	mov    %eax,(%esp)
80101daf:	e8 3c 26 00 00       	call   801043f0 <memmove>
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101db4:	80 3e 2f             	cmpb   $0x2f,(%esi)
80101db7:	75 0f                	jne    80101dc8 <namex+0xb8>
80101db9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101dc0:	83 c3 01             	add    $0x1,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101dc3:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101dc6:	74 f8                	je     80101dc0 <namex+0xb0>
  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);

  while((path = skipelem(path, name)) != 0){
80101dc8:	85 db                	test   %ebx,%ebx
80101dca:	74 82                	je     80101d4e <namex+0x3e>
    ilock(ip);
80101dcc:	89 3c 24             	mov    %edi,(%esp)
80101dcf:	e8 ec f8 ff ff       	call   801016c0 <ilock>
    if(ip->type != T_DIR){
80101dd4:	66 83 7f 50 01       	cmpw   $0x1,0x50(%edi)
80101dd9:	0f 85 7e 00 00 00    	jne    80101e5d <namex+0x14d>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101ddf:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101de2:	85 c0                	test   %eax,%eax
80101de4:	74 09                	je     80101def <namex+0xdf>
80101de6:	80 3b 00             	cmpb   $0x0,(%ebx)
80101de9:	0f 84 93 00 00 00    	je     80101e82 <namex+0x172>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101def:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101df2:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80101df9:	00 
80101dfa:	89 3c 24             	mov    %edi,(%esp)
80101dfd:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e01:	e8 4a fe ff ff       	call   80101c50 <dirlookup>
      iunlockput(ip);
80101e06:	89 3c 24             	mov    %edi,(%esp)
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101e09:	85 c0                	test   %eax,%eax
80101e0b:	89 c6                	mov    %eax,%esi
80101e0d:	74 62                	je     80101e71 <namex+0x161>
      iunlockput(ip);
      return 0;
    }
    iunlockput(ip);
80101e0f:	e8 3c fb ff ff       	call   80101950 <iunlockput>
    ip = next;
80101e14:	89 f7                	mov    %esi,%edi
80101e16:	e9 28 ff ff ff       	jmp    80101d43 <namex+0x33>
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101e1b:	31 d2                	xor    %edx,%edx
80101e1d:	8d 76 00             	lea    0x0(%esi),%esi
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
80101e20:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101e23:	89 54 24 08          	mov    %edx,0x8(%esp)
80101e27:	89 5c 24 04          	mov    %ebx,0x4(%esp)
    name[len] = 0;
80101e2b:	89 f3                	mov    %esi,%ebx
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
80101e2d:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101e30:	89 04 24             	mov    %eax,(%esp)
80101e33:	e8 b8 25 00 00       	call   801043f0 <memmove>
    name[len] = 0;
80101e38:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101e3b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101e3e:	c6 04 10 00          	movb   $0x0,(%eax,%edx,1)
80101e42:	e9 6d ff ff ff       	jmp    80101db4 <namex+0xa4>
namex(char *path, int nameiparent, char *name)
{
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
80101e47:	ba 01 00 00 00       	mov    $0x1,%edx
80101e4c:	b8 01 00 00 00       	mov    $0x1,%eax
80101e51:	e8 ca f2 ff ff       	call   80101120 <iget>
80101e56:	89 c7                	mov    %eax,%edi
80101e58:	e9 e6 fe ff ff       	jmp    80101d43 <namex+0x33>
    ip = idup(myproc()->cwd);

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
      iunlockput(ip);
80101e5d:	89 3c 24             	mov    %edi,(%esp)
      return 0;
80101e60:	31 ff                	xor    %edi,%edi
    ip = idup(myproc()->cwd);

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
      iunlockput(ip);
80101e62:	e8 e9 fa ff ff       	call   80101950 <iunlockput>
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101e67:	83 c4 2c             	add    $0x2c,%esp
80101e6a:	89 f8                	mov    %edi,%eax
80101e6c:	5b                   	pop    %ebx
80101e6d:	5e                   	pop    %esi
80101e6e:	5f                   	pop    %edi
80101e6f:	5d                   	pop    %ebp
80101e70:	c3                   	ret    
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
80101e71:	e8 da fa ff ff       	call   80101950 <iunlockput>
      return 0;
80101e76:	31 ff                	xor    %edi,%edi
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101e78:	83 c4 2c             	add    $0x2c,%esp
80101e7b:	5b                   	pop    %ebx
80101e7c:	89 f8                	mov    %edi,%eax
80101e7e:	5e                   	pop    %esi
80101e7f:	5f                   	pop    %edi
80101e80:	5d                   	pop    %ebp
80101e81:	c3                   	ret    
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
80101e82:	89 3c 24             	mov    %edi,(%esp)
80101e85:	e8 16 f9 ff ff       	call   801017a0 <iunlock>
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101e8a:	83 c4 2c             	add    $0x2c,%esp
80101e8d:	89 f8                	mov    %edi,%eax
80101e8f:	5b                   	pop    %ebx
80101e90:	5e                   	pop    %esi
80101e91:	5f                   	pop    %edi
80101e92:	5d                   	pop    %ebp
80101e93:	c3                   	ret    
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
    iput(ip);
80101e94:	89 3c 24             	mov    %edi,(%esp)
    return 0;
80101e97:	31 ff                	xor    %edi,%edi
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
    iput(ip);
80101e99:	e8 52 f9 ff ff       	call   801017f0 <iput>
    return 0;
80101e9e:	e9 b6 fe ff ff       	jmp    80101d59 <namex+0x49>
80101ea3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101ea9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101eb0 <dirlink>:
}

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80101eb0:	55                   	push   %ebp
80101eb1:	89 e5                	mov    %esp,%ebp
80101eb3:	57                   	push   %edi
80101eb4:	56                   	push   %esi
80101eb5:	53                   	push   %ebx
80101eb6:	83 ec 2c             	sub    $0x2c,%esp
80101eb9:	8b 75 08             	mov    0x8(%ebp),%esi
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
80101ebc:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ebf:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80101ec6:	00 
80101ec7:	89 34 24             	mov    %esi,(%esp)
80101eca:	89 44 24 04          	mov    %eax,0x4(%esp)
80101ece:	e8 7d fd ff ff       	call   80101c50 <dirlookup>
80101ed3:	85 c0                	test   %eax,%eax
80101ed5:	0f 85 89 00 00 00    	jne    80101f64 <dirlink+0xb4>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80101edb:	8b 56 58             	mov    0x58(%esi),%edx
80101ede:	31 db                	xor    %ebx,%ebx
80101ee0:	8d 7d d8             	lea    -0x28(%ebp),%edi
80101ee3:	85 d2                	test   %edx,%edx
80101ee5:	75 11                	jne    80101ef8 <dirlink+0x48>
80101ee7:	eb 33                	jmp    80101f1c <dirlink+0x6c>
80101ee9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ef0:	83 c3 10             	add    $0x10,%ebx
80101ef3:	39 5e 58             	cmp    %ebx,0x58(%esi)
80101ef6:	76 24                	jbe    80101f1c <dirlink+0x6c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ef8:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101eff:	00 
80101f00:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80101f04:	89 7c 24 04          	mov    %edi,0x4(%esp)
80101f08:	89 34 24             	mov    %esi,(%esp)
80101f0b:	e8 90 fa ff ff       	call   801019a0 <readi>
80101f10:	83 f8 10             	cmp    $0x10,%eax
80101f13:	75 5e                	jne    80101f73 <dirlink+0xc3>
      panic("dirlink read");
    if(de.inum == 0)
80101f15:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101f1a:	75 d4                	jne    80101ef0 <dirlink+0x40>
      break;
  }

  strncpy(de.name, name, DIRSIZ);
80101f1c:	8b 45 0c             	mov    0xc(%ebp),%eax
80101f1f:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101f26:	00 
80101f27:	89 44 24 04          	mov    %eax,0x4(%esp)
80101f2b:	8d 45 da             	lea    -0x26(%ebp),%eax
80101f2e:	89 04 24             	mov    %eax,(%esp)
80101f31:	e8 9a 25 00 00       	call   801044d0 <strncpy>
  de.inum = inum;
80101f36:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f39:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101f40:	00 
80101f41:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80101f45:	89 7c 24 04          	mov    %edi,0x4(%esp)
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
80101f49:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f4d:	89 34 24             	mov    %esi,(%esp)
80101f50:	e8 7b fb ff ff       	call   80101ad0 <writei>
80101f55:	83 f8 10             	cmp    $0x10,%eax
80101f58:	75 25                	jne    80101f7f <dirlink+0xcf>
    panic("dirlink");

  return 0;
80101f5a:	31 c0                	xor    %eax,%eax
}
80101f5c:	83 c4 2c             	add    $0x2c,%esp
80101f5f:	5b                   	pop    %ebx
80101f60:	5e                   	pop    %esi
80101f61:	5f                   	pop    %edi
80101f62:	5d                   	pop    %ebp
80101f63:	c3                   	ret    
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
    iput(ip);
80101f64:	89 04 24             	mov    %eax,(%esp)
80101f67:	e8 84 f8 ff ff       	call   801017f0 <iput>
    return -1;
80101f6c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f71:	eb e9                	jmp    80101f5c <dirlink+0xac>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
80101f73:	c7 04 24 88 6e 10 80 	movl   $0x80106e88,(%esp)
80101f7a:	e8 f1 e3 ff ff       	call   80100370 <panic>
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("dirlink");
80101f7f:	c7 04 24 5e 74 10 80 	movl   $0x8010745e,(%esp)
80101f86:	e8 e5 e3 ff ff       	call   80100370 <panic>
80101f8b:	90                   	nop
80101f8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101f90 <namei>:
  return ip;
}

struct inode*
namei(char *path)
{
80101f90:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101f91:	31 d2                	xor    %edx,%edx
  return ip;
}

struct inode*
namei(char *path)
{
80101f93:	89 e5                	mov    %esp,%ebp
80101f95:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101f98:	8b 45 08             	mov    0x8(%ebp),%eax
80101f9b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101f9e:	e8 6d fd ff ff       	call   80101d10 <namex>
}
80101fa3:	c9                   	leave  
80101fa4:	c3                   	ret    
80101fa5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101fa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101fb0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101fb0:	55                   	push   %ebp
  return namex(path, 1, name);
80101fb1:	ba 01 00 00 00       	mov    $0x1,%edx
  return namex(path, 0, name);
}

struct inode*
nameiparent(char *path, char *name)
{
80101fb6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101fb8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101fbb:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101fbe:	5d                   	pop    %ebp
}

struct inode*
nameiparent(char *path, char *name)
{
  return namex(path, 1, name);
80101fbf:	e9 4c fd ff ff       	jmp    80101d10 <namex>
	...

80101fd0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101fd0:	55                   	push   %ebp
80101fd1:	89 e5                	mov    %esp,%ebp
80101fd3:	56                   	push   %esi
80101fd4:	89 c6                	mov    %eax,%esi
80101fd6:	53                   	push   %ebx
80101fd7:	83 ec 10             	sub    $0x10,%esp
  if(b == 0)
80101fda:	85 c0                	test   %eax,%eax
80101fdc:	0f 84 99 00 00 00    	je     8010207b <idestart+0xab>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101fe2:	8b 48 08             	mov    0x8(%eax),%ecx
80101fe5:	81 f9 e7 03 00 00    	cmp    $0x3e7,%ecx
80101feb:	0f 87 7e 00 00 00    	ja     8010206f <idestart+0x9f>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101ff1:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101ff6:	66 90                	xchg   %ax,%ax
80101ff8:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101ff9:	25 c0 00 00 00       	and    $0xc0,%eax
80101ffe:	83 f8 40             	cmp    $0x40,%eax
80102001:	75 f5                	jne    80101ff8 <idestart+0x28>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102003:	31 db                	xor    %ebx,%ebx
80102005:	ba f6 03 00 00       	mov    $0x3f6,%edx
8010200a:	89 d8                	mov    %ebx,%eax
8010200c:	ee                   	out    %al,(%dx)
8010200d:	ba f2 01 00 00       	mov    $0x1f2,%edx
80102012:	b8 01 00 00 00       	mov    $0x1,%eax
80102017:	ee                   	out    %al,(%dx)
80102018:	b2 f3                	mov    $0xf3,%dl
8010201a:	89 c8                	mov    %ecx,%eax
8010201c:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
8010201d:	89 c8                	mov    %ecx,%eax
8010201f:	b2 f4                	mov    $0xf4,%dl
80102021:	c1 f8 08             	sar    $0x8,%eax
80102024:	ee                   	out    %al,(%dx)
80102025:	b2 f5                	mov    $0xf5,%dl
80102027:	89 d8                	mov    %ebx,%eax
80102029:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010202a:	8b 46 04             	mov    0x4(%esi),%eax
8010202d:	b2 f6                	mov    $0xf6,%dl
8010202f:	83 e0 01             	and    $0x1,%eax
80102032:	c1 e0 04             	shl    $0x4,%eax
80102035:	83 c8 e0             	or     $0xffffffe0,%eax
80102038:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80102039:	f6 06 04             	testb  $0x4,(%esi)
8010203c:	75 12                	jne    80102050 <idestart+0x80>
8010203e:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102043:	b8 20 00 00 00       	mov    $0x20,%eax
80102048:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80102049:	83 c4 10             	add    $0x10,%esp
8010204c:	5b                   	pop    %ebx
8010204d:	5e                   	pop    %esi
8010204e:	5d                   	pop    %ebp
8010204f:	c3                   	ret    
80102050:	b2 f7                	mov    $0xf7,%dl
80102052:	b8 30 00 00 00       	mov    $0x30,%eax
80102057:	ee                   	out    %al,(%dx)
}

static inline void
outsl(int port, const void *addr, int cnt)
{
  asm volatile("cld; rep outsl" :
80102058:	b9 80 00 00 00       	mov    $0x80,%ecx
  outb(0x1f4, (sector >> 8) & 0xff);
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
8010205d:	83 c6 5c             	add    $0x5c,%esi
80102060:	ba f0 01 00 00       	mov    $0x1f0,%edx
80102065:	fc                   	cld    
80102066:	f3 6f                	rep outsl %ds:(%esi),(%dx)
  } else {
    outb(0x1f7, read_cmd);
  }
}
80102068:	83 c4 10             	add    $0x10,%esp
8010206b:	5b                   	pop    %ebx
8010206c:	5e                   	pop    %esi
8010206d:	5d                   	pop    %ebp
8010206e:	c3                   	ret    
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
  if(b->blockno >= FSSIZE)
    panic("incorrect blockno");
8010206f:	c7 04 24 f4 6e 10 80 	movl   $0x80106ef4,(%esp)
80102076:	e8 f5 e2 ff ff       	call   80100370 <panic>
// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
8010207b:	c7 04 24 eb 6e 10 80 	movl   $0x80106eeb,(%esp)
80102082:	e8 e9 e2 ff ff       	call   80100370 <panic>
80102087:	89 f6                	mov    %esi,%esi
80102089:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102090 <ideinit>:
  return 0;
}

void
ideinit(void)
{
80102090:	55                   	push   %ebp
80102091:	89 e5                	mov    %esp,%ebp
80102093:	83 ec 18             	sub    $0x18,%esp
  int i;

  initlock(&idelock, "ide");
80102096:	c7 44 24 04 06 6f 10 	movl   $0x80106f06,0x4(%esp)
8010209d:	80 
8010209e:	c7 04 24 60 a5 10 80 	movl   $0x8010a560,(%esp)
801020a5:	e8 66 20 00 00       	call   80104110 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801020aa:	a1 00 2d 11 80       	mov    0x80112d00,%eax
801020af:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
801020b6:	83 e8 01             	sub    $0x1,%eax
801020b9:	89 44 24 04          	mov    %eax,0x4(%esp)
801020bd:	e8 5e 02 00 00       	call   80102320 <ioapicenable>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020c2:	ba f7 01 00 00       	mov    $0x1f7,%edx
801020c7:	90                   	nop
801020c8:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801020c9:	25 c0 00 00 00       	and    $0xc0,%eax
801020ce:	83 f8 40             	cmp    $0x40,%eax
801020d1:	75 f5                	jne    801020c8 <ideinit+0x38>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801020d3:	ba f6 01 00 00       	mov    $0x1f6,%edx
801020d8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801020dd:	ee                   	out    %al,(%dx)
801020de:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020e3:	b2 f7                	mov    $0xf7,%dl
801020e5:	eb 06                	jmp    801020ed <ideinit+0x5d>
801020e7:	90                   	nop
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
801020e8:	83 e9 01             	sub    $0x1,%ecx
801020eb:	74 0f                	je     801020fc <ideinit+0x6c>
801020ed:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801020ee:	84 c0                	test   %al,%al
801020f0:	74 f6                	je     801020e8 <ideinit+0x58>
      havedisk1 = 1;
801020f2:	c7 05 94 a5 10 80 01 	movl   $0x1,0x8010a594
801020f9:	00 00 00 
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801020fc:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102101:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102106:	ee                   	out    %al,(%dx)
    }
  }

  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
}
80102107:	c9                   	leave  
80102108:	c3                   	ret    
80102109:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102110 <ideintr>:
}

// Interrupt handler.
void
ideintr(void)
{
80102110:	55                   	push   %ebp
80102111:	89 e5                	mov    %esp,%ebp
80102113:	57                   	push   %edi
80102114:	53                   	push   %ebx
80102115:	83 ec 10             	sub    $0x10,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102118:	c7 04 24 60 a5 10 80 	movl   $0x8010a560,(%esp)
8010211f:	e8 dc 20 00 00       	call   80104200 <acquire>

  if((b = idequeue) == 0){
80102124:	8b 1d 98 a5 10 80    	mov    0x8010a598,%ebx
8010212a:	85 db                	test   %ebx,%ebx
8010212c:	74 2d                	je     8010215b <ideintr+0x4b>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
8010212e:	8b 43 58             	mov    0x58(%ebx),%eax
80102131:	a3 98 a5 10 80       	mov    %eax,0x8010a598

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102136:	8b 0b                	mov    (%ebx),%ecx
80102138:	f6 c1 04             	test   $0x4,%cl
8010213b:	74 33                	je     80102170 <ideintr+0x60>
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
8010213d:	83 c9 02             	or     $0x2,%ecx
  b->flags &= ~B_DIRTY;
80102140:	83 e1 fb             	and    $0xfffffffb,%ecx
80102143:	89 0b                	mov    %ecx,(%ebx)
  wakeup(b);
80102145:	89 1c 24             	mov    %ebx,(%esp)
80102148:	e8 03 1d 00 00       	call   80103e50 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
8010214d:	a1 98 a5 10 80       	mov    0x8010a598,%eax
80102152:	85 c0                	test   %eax,%eax
80102154:	74 05                	je     8010215b <ideintr+0x4b>
    idestart(idequeue);
80102156:	e8 75 fe ff ff       	call   80101fd0 <idestart>

  release(&idelock);
8010215b:	c7 04 24 60 a5 10 80 	movl   $0x8010a560,(%esp)
80102162:	e8 79 21 00 00       	call   801042e0 <release>
}
80102167:	83 c4 10             	add    $0x10,%esp
8010216a:	5b                   	pop    %ebx
8010216b:	5f                   	pop    %edi
8010216c:	5d                   	pop    %ebp
8010216d:	c3                   	ret    
8010216e:	66 90                	xchg   %ax,%ax
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102170:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102175:	8d 76 00             	lea    0x0(%esi),%esi
80102178:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102179:	0f b6 c0             	movzbl %al,%eax
8010217c:	89 c7                	mov    %eax,%edi
8010217e:	81 e7 c0 00 00 00    	and    $0xc0,%edi
80102184:	83 ff 40             	cmp    $0x40,%edi
80102187:	75 ef                	jne    80102178 <ideintr+0x68>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
80102189:	a8 21                	test   $0x21,%al
8010218b:	75 b0                	jne    8010213d <ideintr+0x2d>
  }
  idequeue = b->qnext;

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
    insl(0x1f0, b->data, BSIZE/4);
8010218d:	8d 7b 5c             	lea    0x5c(%ebx),%edi
}

static inline void
insl(int port, void *addr, int cnt)
{
  asm volatile("cld; rep insl" :
80102190:	b9 80 00 00 00       	mov    $0x80,%ecx
80102195:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010219a:	fc                   	cld    
8010219b:	f3 6d                	rep insl (%dx),%es:(%edi)
8010219d:	8b 0b                	mov    (%ebx),%ecx
8010219f:	eb 9c                	jmp    8010213d <ideintr+0x2d>
801021a1:	eb 0d                	jmp    801021b0 <iderw>
801021a3:	90                   	nop
801021a4:	90                   	nop
801021a5:	90                   	nop
801021a6:	90                   	nop
801021a7:	90                   	nop
801021a8:	90                   	nop
801021a9:	90                   	nop
801021aa:	90                   	nop
801021ab:	90                   	nop
801021ac:	90                   	nop
801021ad:	90                   	nop
801021ae:	90                   	nop
801021af:	90                   	nop

801021b0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801021b0:	55                   	push   %ebp
801021b1:	89 e5                	mov    %esp,%ebp
801021b3:	53                   	push   %ebx
801021b4:	83 ec 14             	sub    $0x14,%esp
801021b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801021ba:	8d 43 0c             	lea    0xc(%ebx),%eax
801021bd:	89 04 24             	mov    %eax,(%esp)
801021c0:	e8 1b 1f 00 00       	call   801040e0 <holdingsleep>
801021c5:	85 c0                	test   %eax,%eax
801021c7:	0f 84 8f 00 00 00    	je     8010225c <iderw+0xac>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801021cd:	8b 03                	mov    (%ebx),%eax
801021cf:	83 e0 06             	and    $0x6,%eax
801021d2:	83 f8 02             	cmp    $0x2,%eax
801021d5:	0f 84 99 00 00 00    	je     80102274 <iderw+0xc4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801021db:	8b 53 04             	mov    0x4(%ebx),%edx
801021de:	85 d2                	test   %edx,%edx
801021e0:	74 09                	je     801021eb <iderw+0x3b>
801021e2:	a1 94 a5 10 80       	mov    0x8010a594,%eax
801021e7:	85 c0                	test   %eax,%eax
801021e9:	74 7d                	je     80102268 <iderw+0xb8>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
801021eb:	c7 04 24 60 a5 10 80 	movl   $0x8010a560,(%esp)
801021f2:	e8 09 20 00 00       	call   80104200 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801021f7:	a1 98 a5 10 80       	mov    0x8010a598,%eax
801021fc:	ba 98 a5 10 80       	mov    $0x8010a598,%edx
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
80102201:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102208:	85 c0                	test   %eax,%eax
8010220a:	74 0e                	je     8010221a <iderw+0x6a>
8010220c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102210:	8d 50 58             	lea    0x58(%eax),%edx
80102213:	8b 40 58             	mov    0x58(%eax),%eax
80102216:	85 c0                	test   %eax,%eax
80102218:	75 f6                	jne    80102210 <iderw+0x60>
    ;
  *pp = b;
8010221a:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
8010221c:	39 1d 98 a5 10 80    	cmp    %ebx,0x8010a598
80102222:	75 14                	jne    80102238 <iderw+0x88>
80102224:	eb 2d                	jmp    80102253 <iderw+0xa3>
80102226:	66 90                	xchg   %ax,%ax
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
    sleep(b, &idelock);
80102228:	c7 44 24 04 60 a5 10 	movl   $0x8010a560,0x4(%esp)
8010222f:	80 
80102230:	89 1c 24             	mov    %ebx,(%esp)
80102233:	e8 78 1a 00 00       	call   80103cb0 <sleep>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102238:	8b 03                	mov    (%ebx),%eax
8010223a:	83 e0 06             	and    $0x6,%eax
8010223d:	83 f8 02             	cmp    $0x2,%eax
80102240:	75 e6                	jne    80102228 <iderw+0x78>
    sleep(b, &idelock);
  }


  release(&idelock);
80102242:	c7 45 08 60 a5 10 80 	movl   $0x8010a560,0x8(%ebp)
}
80102249:	83 c4 14             	add    $0x14,%esp
8010224c:	5b                   	pop    %ebx
8010224d:	5d                   	pop    %ebp
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
    sleep(b, &idelock);
  }


  release(&idelock);
8010224e:	e9 8d 20 00 00       	jmp    801042e0 <release>
    ;
  *pp = b;

  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
80102253:	89 d8                	mov    %ebx,%eax
80102255:	e8 76 fd ff ff       	call   80101fd0 <idestart>
8010225a:	eb dc                	jmp    80102238 <iderw+0x88>
iderw(struct buf *b)
{
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
8010225c:	c7 04 24 0a 6f 10 80 	movl   $0x80106f0a,(%esp)
80102263:	e8 08 e1 ff ff       	call   80100370 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
    panic("iderw: ide disk 1 not present");
80102268:	c7 04 24 35 6f 10 80 	movl   $0x80106f35,(%esp)
8010226f:	e8 fc e0 ff ff       	call   80100370 <panic>
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
80102274:	c7 04 24 20 6f 10 80 	movl   $0x80106f20,(%esp)
8010227b:	e8 f0 e0 ff ff       	call   80100370 <panic>

80102280 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102280:	55                   	push   %ebp
80102281:	89 e5                	mov    %esp,%ebp
80102283:	56                   	push   %esi
80102284:	53                   	push   %ebx

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
  return ioapic->data;
80102285:	bb 00 00 c0 fe       	mov    $0xfec00000,%ebx
  ioapic->data = data;
}

void
ioapicinit(void)
{
8010228a:	83 ec 10             	sub    $0x10,%esp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010228d:	0f b6 15 60 27 11 80 	movzbl 0x80112760,%edx
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
80102294:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
8010229b:	00 00 00 
  return ioapic->data;
8010229e:	8b 35 10 00 c0 fe    	mov    0xfec00010,%esi
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
801022a4:	c7 05 00 00 c0 fe 00 	movl   $0x0,0xfec00000
801022ab:	00 00 00 
  return ioapic->data;
801022ae:	a1 10 00 c0 fe       	mov    0xfec00010,%eax
void
ioapicinit(void)
{
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801022b3:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
801022ba:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801022bd:	c1 ee 10             	shr    $0x10,%esi
  id = ioapicread(REG_ID) >> 24;
801022c0:	c1 e8 18             	shr    $0x18,%eax
ioapicinit(void)
{
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801022c3:	81 e6 ff 00 00 00    	and    $0xff,%esi
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801022c9:	39 c2                	cmp    %eax,%edx
801022cb:	74 12                	je     801022df <ioapicinit+0x5f>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801022cd:	c7 04 24 54 6f 10 80 	movl   $0x80106f54,(%esp)
801022d4:	e8 77 e3 ff ff       	call   80100650 <cprintf>
801022d9:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
  ioapic->data = data;
}

void
ioapicinit(void)
{
801022df:	ba 10 00 00 00       	mov    $0x10,%edx
801022e4:	31 c0                	xor    %eax,%eax
801022e6:	66 90                	xchg   %ax,%ax
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801022e8:	89 13                	mov    %edx,(%ebx)
  ioapic->data = data;
801022ea:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
}

void
ioapicinit(void)
801022f0:	8d 48 20             	lea    0x20(%eax),%ecx
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801022f3:	81 c9 00 00 01 00    	or     $0x10000,%ecx
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
801022f9:	83 c0 01             	add    $0x1,%eax

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
801022fc:	89 4b 10             	mov    %ecx,0x10(%ebx)
}

void
ioapicinit(void)
801022ff:	8d 4a 01             	lea    0x1(%edx),%ecx
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102302:	83 c2 02             	add    $0x2,%edx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102305:	89 0b                	mov    %ecx,(%ebx)
  ioapic->data = data;
80102307:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
8010230d:	39 c6                	cmp    %eax,%esi

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
8010230f:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102316:	7d d0                	jge    801022e8 <ioapicinit+0x68>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102318:	83 c4 10             	add    $0x10,%esp
8010231b:	5b                   	pop    %ebx
8010231c:	5e                   	pop    %esi
8010231d:	5d                   	pop    %ebp
8010231e:	c3                   	ret    
8010231f:	90                   	nop

80102320 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102320:	55                   	push   %ebp
80102321:	89 e5                	mov    %esp,%ebp
80102323:	8b 55 08             	mov    0x8(%ebp),%edx
80102326:	53                   	push   %ebx
80102327:	8b 45 0c             	mov    0xc(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010232a:	8d 5a 20             	lea    0x20(%edx),%ebx
8010232d:	8d 4c 12 10          	lea    0x10(%edx,%edx,1),%ecx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102331:	8b 15 34 26 11 80    	mov    0x80112634,%edx
{
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102337:	c1 e0 18             	shl    $0x18,%eax
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
8010233a:	89 0a                	mov    %ecx,(%edx)
  ioapic->data = data;
8010233c:	8b 15 34 26 11 80    	mov    0x80112634,%edx
{
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102342:	83 c1 01             	add    $0x1,%ecx

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
80102345:	89 5a 10             	mov    %ebx,0x10(%edx)
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102348:	89 0a                	mov    %ecx,(%edx)
  ioapic->data = data;
8010234a:	8b 15 34 26 11 80    	mov    0x80112634,%edx
80102350:	89 42 10             	mov    %eax,0x10(%edx)
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
80102353:	5b                   	pop    %ebx
80102354:	5d                   	pop    %ebp
80102355:	c3                   	ret    
	...

80102360 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102360:	55                   	push   %ebp
80102361:	89 e5                	mov    %esp,%ebp
80102363:	53                   	push   %ebx
80102364:	83 ec 14             	sub    $0x14,%esp
80102367:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010236a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102370:	75 7c                	jne    801023ee <kfree+0x8e>
80102372:	81 fb a8 54 11 80    	cmp    $0x801154a8,%ebx
80102378:	72 74                	jb     801023ee <kfree+0x8e>
8010237a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102380:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102385:	77 67                	ja     801023ee <kfree+0x8e>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102387:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010238e:	00 
8010238f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102396:	00 
80102397:	89 1c 24             	mov    %ebx,(%esp)
8010239a:	e8 91 1f 00 00       	call   80104330 <memset>

  if(kmem.use_lock)
8010239f:	8b 15 74 26 11 80    	mov    0x80112674,%edx
801023a5:	85 d2                	test   %edx,%edx
801023a7:	75 37                	jne    801023e0 <kfree+0x80>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
801023a9:	a1 78 26 11 80       	mov    0x80112678,%eax
801023ae:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
801023b0:	a1 74 26 11 80       	mov    0x80112674,%eax

  if(kmem.use_lock)
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
801023b5:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
801023bb:	85 c0                	test   %eax,%eax
801023bd:	75 09                	jne    801023c8 <kfree+0x68>
    release(&kmem.lock);
}
801023bf:	83 c4 14             	add    $0x14,%esp
801023c2:	5b                   	pop    %ebx
801023c3:	5d                   	pop    %ebp
801023c4:	c3                   	ret    
801023c5:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
801023c8:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
801023cf:	83 c4 14             	add    $0x14,%esp
801023d2:	5b                   	pop    %ebx
801023d3:	5d                   	pop    %ebp
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
801023d4:	e9 07 1f 00 00       	jmp    801042e0 <release>
801023d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);

  if(kmem.use_lock)
    acquire(&kmem.lock);
801023e0:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
801023e7:	e8 14 1e 00 00       	call   80104200 <acquire>
801023ec:	eb bb                	jmp    801023a9 <kfree+0x49>
kfree(char *v)
{
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
    panic("kfree");
801023ee:	c7 04 24 86 6f 10 80 	movl   $0x80106f86,(%esp)
801023f5:	e8 76 df ff ff       	call   80100370 <panic>
801023fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102400 <freerange>:
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
80102400:	55                   	push   %ebp
80102401:	89 e5                	mov    %esp,%ebp
80102403:	56                   	push   %esi
80102404:	53                   	push   %ebx
80102405:	83 ec 10             	sub    $0x10,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102408:	8b 55 08             	mov    0x8(%ebp),%edx
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
8010240b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010240e:	81 c2 ff 0f 00 00    	add    $0xfff,%edx
80102414:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010241a:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
80102420:	39 de                	cmp    %ebx,%esi
80102422:	73 08                	jae    8010242c <freerange+0x2c>
80102424:	eb 18                	jmp    8010243e <freerange+0x3e>
80102426:	66 90                	xchg   %ax,%ax
80102428:	89 da                	mov    %ebx,%edx
8010242a:	89 c3                	mov    %eax,%ebx
    kfree(p);
8010242c:	89 14 24             	mov    %edx,(%esp)
8010242f:	e8 2c ff ff ff       	call   80102360 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102434:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
8010243a:	39 f0                	cmp    %esi,%eax
8010243c:	76 ea                	jbe    80102428 <freerange+0x28>
    kfree(p);
}
8010243e:	83 c4 10             	add    $0x10,%esp
80102441:	5b                   	pop    %ebx
80102442:	5e                   	pop    %esi
80102443:	5d                   	pop    %ebp
80102444:	c3                   	ret    
80102445:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102449:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102450 <kinit2>:
  freerange(vstart, vend);
}

void
kinit2(void *vstart, void *vend)
{
80102450:	55                   	push   %ebp
80102451:	89 e5                	mov    %esp,%ebp
80102453:	83 ec 18             	sub    $0x18,%esp
  freerange(vstart, vend);
80102456:	8b 45 0c             	mov    0xc(%ebp),%eax
80102459:	89 44 24 04          	mov    %eax,0x4(%esp)
8010245d:	8b 45 08             	mov    0x8(%ebp),%eax
80102460:	89 04 24             	mov    %eax,(%esp)
80102463:	e8 98 ff ff ff       	call   80102400 <freerange>
  kmem.use_lock = 1;
80102468:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
8010246f:	00 00 00 
}
80102472:	c9                   	leave  
80102473:	c3                   	ret    
80102474:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010247a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80102480 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102480:	55                   	push   %ebp
80102481:	89 e5                	mov    %esp,%ebp
80102483:	83 ec 18             	sub    $0x18,%esp
80102486:	89 5d f8             	mov    %ebx,-0x8(%ebp)
80102489:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010248c:	89 75 fc             	mov    %esi,-0x4(%ebp)
8010248f:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102492:	c7 44 24 04 8c 6f 10 	movl   $0x80106f8c,0x4(%esp)
80102499:	80 
8010249a:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
801024a1:	e8 6a 1c 00 00       	call   80104110 <initlock>
  kmem.use_lock = 0;
  freerange(vstart, vend);
801024a6:	89 75 0c             	mov    %esi,0xc(%ebp)
}
801024a9:	8b 75 fc             	mov    -0x4(%ebp),%esi
void
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
  freerange(vstart, vend);
801024ac:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801024af:	8b 5d f8             	mov    -0x8(%ebp),%ebx
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
801024b2:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
801024b9:	00 00 00 
  freerange(vstart, vend);
}
801024bc:	89 ec                	mov    %ebp,%esp
801024be:	5d                   	pop    %ebp
void
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
  freerange(vstart, vend);
801024bf:	e9 3c ff ff ff       	jmp    80102400 <freerange>
801024c4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801024ca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801024d0 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
801024d0:	55                   	push   %ebp
  struct run *r;

  if(kmem.use_lock)
801024d1:	31 c0                	xor    %eax,%eax
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
801024d3:	89 e5                	mov    %esp,%ebp
801024d5:	53                   	push   %ebx
801024d6:	83 ec 14             	sub    $0x14,%esp
  struct run *r;

  if(kmem.use_lock)
801024d9:	8b 0d 74 26 11 80    	mov    0x80112674,%ecx
801024df:	85 c9                	test   %ecx,%ecx
801024e1:	75 2d                	jne    80102510 <kalloc+0x40>
    acquire(&kmem.lock);
  r = kmem.freelist;
801024e3:	8b 1d 78 26 11 80    	mov    0x80112678,%ebx
  if(r)
801024e9:	85 db                	test   %ebx,%ebx
801024eb:	74 08                	je     801024f5 <kalloc+0x25>
    kmem.freelist = r->next;
801024ed:	8b 13                	mov    (%ebx),%edx
801024ef:	89 15 78 26 11 80    	mov    %edx,0x80112678
  if(kmem.use_lock)
801024f5:	85 c0                	test   %eax,%eax
801024f7:	74 0c                	je     80102505 <kalloc+0x35>
    release(&kmem.lock);
801024f9:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
80102500:	e8 db 1d 00 00       	call   801042e0 <release>
  return (char*)r;
}
80102505:	83 c4 14             	add    $0x14,%esp
80102508:	89 d8                	mov    %ebx,%eax
8010250a:	5b                   	pop    %ebx
8010250b:	5d                   	pop    %ebp
8010250c:	c3                   	ret    
8010250d:	8d 76 00             	lea    0x0(%esi),%esi
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
    acquire(&kmem.lock);
80102510:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
80102517:	e8 e4 1c 00 00       	call   80104200 <acquire>
8010251c:	a1 74 26 11 80       	mov    0x80112674,%eax
80102521:	eb c0                	jmp    801024e3 <kalloc+0x13>
	...

80102530 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102530:	55                   	push   %ebp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102531:	ba 64 00 00 00       	mov    $0x64,%edx
80102536:	89 e5                	mov    %esp,%ebp
80102538:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102539:	a8 01                	test   $0x1,%al
    return -1;
8010253b:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102540:	74 3e                	je     80102580 <kbdgetc+0x50>
80102542:	b2 60                	mov    $0x60,%dl
80102544:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102545:	0f b6 c0             	movzbl %al,%eax

  if(data == 0xE0){
80102548:	3d e0 00 00 00       	cmp    $0xe0,%eax
8010254d:	0f 84 85 00 00 00    	je     801025d8 <kbdgetc+0xa8>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102553:	a8 80                	test   $0x80,%al
80102555:	74 31                	je     80102588 <kbdgetc+0x58>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102557:	8b 15 9c a5 10 80    	mov    0x8010a59c,%edx
8010255d:	89 c1                	mov    %eax,%ecx
8010255f:	83 e1 7f             	and    $0x7f,%ecx
80102562:	f6 c2 40             	test   $0x40,%dl
80102565:	0f 44 c1             	cmove  %ecx,%eax
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
80102568:	31 c9                	xor    %ecx,%ecx
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
8010256a:	0f b6 80 a0 6f 10 80 	movzbl -0x7fef9060(%eax),%eax
80102571:	83 c8 40             	or     $0x40,%eax
80102574:	0f b6 c0             	movzbl %al,%eax
80102577:	f7 d0                	not    %eax
80102579:	21 d0                	and    %edx,%eax
8010257b:	a3 9c a5 10 80       	mov    %eax,0x8010a59c
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102580:	89 c8                	mov    %ecx,%eax
80102582:	5d                   	pop    %ebp
80102583:	c3                   	ret    
80102584:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102588:	8b 0d 9c a5 10 80    	mov    0x8010a59c,%ecx
8010258e:	f6 c1 40             	test   $0x40,%cl
80102591:	74 05                	je     80102598 <kbdgetc+0x68>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102593:	0c 80                	or     $0x80,%al
    shift &= ~E0ESC;
80102595:	83 e1 bf             	and    $0xffffffbf,%ecx
  }

  shift |= shiftcode[data];
80102598:	0f b6 90 a0 6f 10 80 	movzbl -0x7fef9060(%eax),%edx
8010259f:	09 ca                	or     %ecx,%edx
  shift ^= togglecode[data];
801025a1:	0f b6 88 a0 70 10 80 	movzbl -0x7fef8f60(%eax),%ecx
801025a8:	31 ca                	xor    %ecx,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
801025aa:	89 d1                	mov    %edx,%ecx
801025ac:	83 e1 03             	and    $0x3,%ecx
801025af:	8b 0c 8d a0 71 10 80 	mov    -0x7fef8e60(,%ecx,4),%ecx
    data |= 0x80;
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
801025b6:	89 15 9c a5 10 80    	mov    %edx,0x8010a59c
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
801025bc:	83 e2 08             	and    $0x8,%edx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
801025bf:	0f b6 0c 01          	movzbl (%ecx,%eax,1),%ecx
  if(shift & CAPSLOCK){
801025c3:	74 bb                	je     80102580 <kbdgetc+0x50>
    if('a' <= c && c <= 'z')
801025c5:	8d 41 9f             	lea    -0x61(%ecx),%eax
801025c8:	83 f8 19             	cmp    $0x19,%eax
801025cb:	77 1b                	ja     801025e8 <kbdgetc+0xb8>
      c += 'A' - 'a';
801025cd:	83 e9 20             	sub    $0x20,%ecx
801025d0:	eb ae                	jmp    80102580 <kbdgetc+0x50>
801025d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
    return 0;
801025d8:	31 c9                	xor    %ecx,%ecx
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801025da:	89 c8                	mov    %ecx,%eax
  if((st & KBS_DIB) == 0)
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
801025dc:	83 0d 9c a5 10 80 40 	orl    $0x40,0x8010a59c
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801025e3:	5d                   	pop    %ebp
801025e4:	c3                   	ret    
801025e5:	8d 76 00             	lea    0x0(%esi),%esi
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
801025e8:	8d 51 bf             	lea    -0x41(%ecx),%edx
      c += 'a' - 'A';
801025eb:	8d 41 20             	lea    0x20(%ecx),%eax
801025ee:	83 fa 19             	cmp    $0x19,%edx
801025f1:	0f 46 c8             	cmovbe %eax,%ecx
  }
  return c;
801025f4:	eb 8a                	jmp    80102580 <kbdgetc+0x50>
801025f6:	8d 76 00             	lea    0x0(%esi),%esi
801025f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102600 <kbdintr>:
}

void
kbdintr(void)
{
80102600:	55                   	push   %ebp
80102601:	89 e5                	mov    %esp,%ebp
80102603:	83 ec 18             	sub    $0x18,%esp
  consoleintr(kbdgetc);
80102606:	c7 04 24 30 25 10 80 	movl   $0x80102530,(%esp)
8010260d:	e8 ae e1 ff ff       	call   801007c0 <consoleintr>
}
80102612:	c9                   	leave  
80102613:	c3                   	ret    
	...

80102620 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102620:	a1 7c 26 11 80       	mov    0x8011267c,%eax
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
80102625:	55                   	push   %ebp
80102626:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102628:	85 c0                	test   %eax,%eax
8010262a:	0f 84 c0 00 00 00    	je     801026f0 <lapicinit+0xd0>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102630:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102637:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010263a:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010263d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102644:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102647:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010264a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102651:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102654:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102657:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010265e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102661:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102664:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
8010266b:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010266e:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102671:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102678:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010267b:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010267e:	8b 50 30             	mov    0x30(%eax),%edx
80102681:	c1 ea 10             	shr    $0x10,%edx
80102684:	80 fa 03             	cmp    $0x3,%dl
80102687:	77 6f                	ja     801026f8 <lapicinit+0xd8>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102689:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102690:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102693:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102696:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010269d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026a0:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026a3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026aa:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026ad:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026b0:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801026b7:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026ba:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026bd:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
801026c4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026c7:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026ca:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801026d1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
801026d4:	8b 50 20             	mov    0x20(%eax),%edx
801026d7:	90                   	nop
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
801026d8:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801026de:	80 e6 10             	and    $0x10,%dh
801026e1:	75 f5                	jne    801026d8 <lapicinit+0xb8>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026e3:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801026ea:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026ed:	8b 40 20             	mov    0x20(%eax),%eax
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801026f0:	5d                   	pop    %ebp
801026f1:	c3                   	ret    
801026f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026f8:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
801026ff:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102702:	8b 50 20             	mov    0x20(%eax),%edx
80102705:	eb 82                	jmp    80102689 <lapicinit+0x69>
80102707:	89 f6                	mov    %esi,%esi
80102709:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102710 <lapicid>:
}

int
lapicid(void)
{
  if (!lapic)
80102710:	8b 15 7c 26 11 80    	mov    0x8011267c,%edx
    return 0;
80102716:	31 c0                	xor    %eax,%eax
  lapicw(TPR, 0);
}

int
lapicid(void)
{
80102718:	55                   	push   %ebp
80102719:	89 e5                	mov    %esp,%ebp
  if (!lapic)
8010271b:	85 d2                	test   %edx,%edx
8010271d:	74 06                	je     80102725 <lapicid+0x15>
    return 0;
  return lapic[ID] >> 24;
8010271f:	8b 42 20             	mov    0x20(%edx),%eax
80102722:	c1 e8 18             	shr    $0x18,%eax
}
80102725:	5d                   	pop    %ebp
80102726:	c3                   	ret    
80102727:	89 f6                	mov    %esi,%esi
80102729:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102730 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102730:	a1 7c 26 11 80       	mov    0x8011267c,%eax
}

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102735:	55                   	push   %ebp
80102736:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102738:	85 c0                	test   %eax,%eax
8010273a:	74 0d                	je     80102749 <lapiceoi+0x19>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010273c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102743:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102746:	8b 40 20             	mov    0x20(%eax),%eax
void
lapiceoi(void)
{
  if(lapic)
    lapicw(EOI, 0);
}
80102749:	5d                   	pop    %ebp
8010274a:	c3                   	ret    
8010274b:	90                   	nop
8010274c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102750 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102750:	55                   	push   %ebp
80102751:	89 e5                	mov    %esp,%ebp
}
80102753:	5d                   	pop    %ebp
80102754:	c3                   	ret    
80102755:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102759:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102760 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102760:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102761:	ba 70 00 00 00       	mov    $0x70,%edx
80102766:	89 e5                	mov    %esp,%ebp
80102768:	b8 0f 00 00 00       	mov    $0xf,%eax
8010276d:	53                   	push   %ebx
8010276e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102771:	0f b6 5d 08          	movzbl 0x8(%ebp),%ebx
80102775:	ee                   	out    %al,(%dx)
80102776:	b8 0a 00 00 00       	mov    $0xa,%eax
8010277b:	b2 71                	mov    $0x71,%dl
8010277d:	ee                   	out    %al,(%dx)
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
  wrv[1] = addr >> 4;
8010277e:	89 c8                	mov    %ecx,%eax
80102780:	c1 e8 04             	shr    $0x4,%eax
80102783:	66 a3 69 04 00 80    	mov    %ax,0x80000469

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102789:	a1 7c 26 11 80       	mov    0x8011267c,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
8010278e:	c1 e9 0c             	shr    $0xc,%ecx
  wrv[0] = 0;
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102791:	c1 e3 18             	shl    $0x18,%ebx
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102794:	80 cd 06             	or     $0x6,%ch
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102797:	66 c7 05 67 04 00 80 	movw   $0x0,0x80000467
8010279e:	00 00 

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027a0:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027a6:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027a9:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
801027b0:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027b3:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027b6:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801027bd:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027c0:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027c3:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027c9:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027cc:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027d2:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027d5:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027db:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027de:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027e4:	8b 40 20             	mov    0x20(%eax),%eax
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
801027e7:	5b                   	pop    %ebx
801027e8:	5d                   	pop    %ebp
801027e9:	c3                   	ret    
801027ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801027f0 <cmostime>:
  r->year   = cmos_read(YEAR);
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
801027f0:	55                   	push   %ebp
801027f1:	ba 70 00 00 00       	mov    $0x70,%edx
801027f6:	89 e5                	mov    %esp,%ebp
801027f8:	b8 0b 00 00 00       	mov    $0xb,%eax
801027fd:	57                   	push   %edi
801027fe:	56                   	push   %esi
801027ff:	53                   	push   %ebx
80102800:	83 ec 6c             	sub    $0x6c,%esp
80102803:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102804:	b2 71                	mov    $0x71,%dl
80102806:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80102807:	89 c2                	mov    %eax,%edx
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102809:	bb 70 00 00 00       	mov    $0x70,%ebx
8010280e:	83 e2 04             	and    $0x4,%edx
80102811:	89 55 a4             	mov    %edx,-0x5c(%ebp)
80102814:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102818:	31 c0                	xor    %eax,%eax
8010281a:	89 da                	mov    %ebx,%edx
8010281c:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010281d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102822:	89 ca                	mov    %ecx,%edx
80102824:	ec                   	in     (%dx),%al
static uint cmos_read(uint reg)
{
  outb(CMOS_PORT,  reg);
  microdelay(200);

  return inb(CMOS_RETURN);
80102825:	0f b6 f0             	movzbl %al,%esi
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102828:	89 da                	mov    %ebx,%edx
8010282a:	b8 02 00 00 00       	mov    $0x2,%eax
8010282f:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102830:	89 ca                	mov    %ecx,%edx
80102832:	ec                   	in     (%dx),%al
80102833:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102836:	89 da                	mov    %ebx,%edx
80102838:	89 45 b4             	mov    %eax,-0x4c(%ebp)
8010283b:	b8 04 00 00 00       	mov    $0x4,%eax
80102840:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102841:	89 ca                	mov    %ecx,%edx
80102843:	ec                   	in     (%dx),%al
80102844:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102847:	89 da                	mov    %ebx,%edx
80102849:	89 45 b0             	mov    %eax,-0x50(%ebp)
8010284c:	b8 07 00 00 00       	mov    $0x7,%eax
80102851:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102852:	89 ca                	mov    %ecx,%edx
80102854:	ec                   	in     (%dx),%al
80102855:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102858:	89 da                	mov    %ebx,%edx
8010285a:	89 45 ac             	mov    %eax,-0x54(%ebp)
8010285d:	b8 08 00 00 00       	mov    $0x8,%eax
80102862:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102863:	89 ca                	mov    %ecx,%edx
80102865:	ec                   	in     (%dx),%al
80102866:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102869:	89 da                	mov    %ebx,%edx
8010286b:	89 45 a8             	mov    %eax,-0x58(%ebp)
8010286e:	b8 09 00 00 00       	mov    $0x9,%eax
80102873:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102874:	89 ca                	mov    %ecx,%edx
80102876:	ec                   	in     (%dx),%al
80102877:	0f b6 f8             	movzbl %al,%edi
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010287a:	89 da                	mov    %ebx,%edx
8010287c:	b8 0a 00 00 00       	mov    $0xa,%eax
80102881:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102882:	89 ca                	mov    %ecx,%edx
80102884:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102885:	a8 80                	test   $0x80,%al
80102887:	75 8f                	jne    80102818 <cmostime+0x28>
80102889:	8b 45 b4             	mov    -0x4c(%ebp),%eax
8010288c:	8b 55 b0             	mov    -0x50(%ebp),%edx
8010288f:	89 75 b8             	mov    %esi,-0x48(%ebp)
80102892:	89 7d cc             	mov    %edi,-0x34(%ebp)
80102895:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102898:	8b 45 ac             	mov    -0x54(%ebp),%eax
8010289b:	89 55 c0             	mov    %edx,-0x40(%ebp)
8010289e:	8b 55 a8             	mov    -0x58(%ebp),%edx
801028a1:	89 45 c4             	mov    %eax,-0x3c(%ebp)
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028a4:	31 c0                	xor    %eax,%eax
801028a6:	89 55 c8             	mov    %edx,-0x38(%ebp)
801028a9:	89 da                	mov    %ebx,%edx
801028ab:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028ac:	89 ca                	mov    %ecx,%edx
801028ae:	ec                   	in     (%dx),%al
static uint cmos_read(uint reg)
{
  outb(CMOS_PORT,  reg);
  microdelay(200);

  return inb(CMOS_RETURN);
801028af:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028b2:	89 da                	mov    %ebx,%edx
801028b4:	89 45 d0             	mov    %eax,-0x30(%ebp)
801028b7:	b8 02 00 00 00       	mov    $0x2,%eax
801028bc:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028bd:	89 ca                	mov    %ecx,%edx
801028bf:	ec                   	in     (%dx),%al
801028c0:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028c3:	89 da                	mov    %ebx,%edx
801028c5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
801028c8:	b8 04 00 00 00       	mov    $0x4,%eax
801028cd:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028ce:	89 ca                	mov    %ecx,%edx
801028d0:	ec                   	in     (%dx),%al
801028d1:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028d4:	89 da                	mov    %ebx,%edx
801028d6:	89 45 d8             	mov    %eax,-0x28(%ebp)
801028d9:	b8 07 00 00 00       	mov    $0x7,%eax
801028de:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028df:	89 ca                	mov    %ecx,%edx
801028e1:	ec                   	in     (%dx),%al
801028e2:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028e5:	89 da                	mov    %ebx,%edx
801028e7:	89 45 dc             	mov    %eax,-0x24(%ebp)
801028ea:	b8 08 00 00 00       	mov    $0x8,%eax
801028ef:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028f0:	89 ca                	mov    %ecx,%edx
801028f2:	ec                   	in     (%dx),%al
801028f3:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028f6:	89 da                	mov    %ebx,%edx
801028f8:	89 45 e0             	mov    %eax,-0x20(%ebp)
801028fb:	b8 09 00 00 00       	mov    $0x9,%eax
80102900:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102901:	89 ca                	mov    %ecx,%edx
80102903:	ec                   	in     (%dx),%al
80102904:	0f b6 c8             	movzbl %al,%ecx
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102907:	8d 55 b8             	lea    -0x48(%ebp),%edx
8010290a:	8d 45 d0             	lea    -0x30(%ebp),%eax
static uint cmos_read(uint reg)
{
  outb(CMOS_PORT,  reg);
  microdelay(200);

  return inb(CMOS_RETURN);
8010290d:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102910:	c7 44 24 08 18 00 00 	movl   $0x18,0x8(%esp)
80102917:	00 
80102918:	89 44 24 04          	mov    %eax,0x4(%esp)
8010291c:	89 14 24             	mov    %edx,(%esp)
8010291f:	e8 6c 1a 00 00       	call   80104390 <memcmp>
80102924:	85 c0                	test   %eax,%eax
80102926:	0f 85 ec fe ff ff    	jne    80102818 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
8010292c:	8b 45 a4             	mov    -0x5c(%ebp),%eax
8010292f:	85 c0                	test   %eax,%eax
80102931:	75 78                	jne    801029ab <cmostime+0x1bb>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102933:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102936:	89 c2                	mov    %eax,%edx
80102938:	83 e0 0f             	and    $0xf,%eax
8010293b:	c1 ea 04             	shr    $0x4,%edx
8010293e:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102941:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102944:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102947:	8b 45 bc             	mov    -0x44(%ebp),%eax
8010294a:	89 c2                	mov    %eax,%edx
8010294c:	83 e0 0f             	and    $0xf,%eax
8010294f:	c1 ea 04             	shr    $0x4,%edx
80102952:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102955:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102958:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
8010295b:	8b 45 c0             	mov    -0x40(%ebp),%eax
8010295e:	89 c2                	mov    %eax,%edx
80102960:	83 e0 0f             	and    $0xf,%eax
80102963:	c1 ea 04             	shr    $0x4,%edx
80102966:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102969:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010296c:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
8010296f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102972:	89 c2                	mov    %eax,%edx
80102974:	83 e0 0f             	and    $0xf,%eax
80102977:	c1 ea 04             	shr    $0x4,%edx
8010297a:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010297d:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102980:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102983:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102986:	89 c2                	mov    %eax,%edx
80102988:	83 e0 0f             	and    $0xf,%eax
8010298b:	c1 ea 04             	shr    $0x4,%edx
8010298e:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102991:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102994:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102997:	8b 45 cc             	mov    -0x34(%ebp),%eax
8010299a:	89 c2                	mov    %eax,%edx
8010299c:	83 e0 0f             	and    $0xf,%eax
8010299f:	c1 ea 04             	shr    $0x4,%edx
801029a2:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029a5:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029a8:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
801029ab:	8b 55 08             	mov    0x8(%ebp),%edx
801029ae:	8b 45 b8             	mov    -0x48(%ebp),%eax
801029b1:	89 02                	mov    %eax,(%edx)
801029b3:	8b 45 bc             	mov    -0x44(%ebp),%eax
801029b6:	89 42 04             	mov    %eax,0x4(%edx)
801029b9:	8b 45 c0             	mov    -0x40(%ebp),%eax
801029bc:	89 42 08             	mov    %eax,0x8(%edx)
801029bf:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801029c2:	89 42 0c             	mov    %eax,0xc(%edx)
801029c5:	8b 45 c8             	mov    -0x38(%ebp),%eax
801029c8:	89 42 10             	mov    %eax,0x10(%edx)
801029cb:	8b 45 cc             	mov    -0x34(%ebp),%eax
801029ce:	89 42 14             	mov    %eax,0x14(%edx)
  r->year += 2000;
801029d1:	81 42 14 d0 07 00 00 	addl   $0x7d0,0x14(%edx)
}
801029d8:	83 c4 6c             	add    $0x6c,%esp
801029db:	5b                   	pop    %ebx
801029dc:	5e                   	pop    %esi
801029dd:	5f                   	pop    %edi
801029de:	5d                   	pop    %ebp
801029df:	c3                   	ret    

801029e0 <install_trans>:
}

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
801029e0:	55                   	push   %ebp
801029e1:	89 e5                	mov    %esp,%ebp
801029e3:	57                   	push   %edi
801029e4:	56                   	push   %esi
801029e5:	53                   	push   %ebx
801029e6:	83 ec 1c             	sub    $0x1c,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801029e9:	a1 c8 26 11 80       	mov    0x801126c8,%eax
801029ee:	85 c0                	test   %eax,%eax
801029f0:	7e 7a                	jle    80102a6c <install_trans+0x8c>
801029f2:	31 db                	xor    %ebx,%ebx
801029f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
801029f8:	a1 b4 26 11 80       	mov    0x801126b4,%eax
801029fd:	01 d8                	add    %ebx,%eax
801029ff:	83 c0 01             	add    $0x1,%eax
80102a02:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a06:	a1 c4 26 11 80       	mov    0x801126c4,%eax
80102a0b:	89 04 24             	mov    %eax,(%esp)
80102a0e:	e8 bd d6 ff ff       	call   801000d0 <bread>
80102a13:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a15:	8b 04 9d cc 26 11 80 	mov    -0x7feed934(,%ebx,4),%eax
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102a1c:	83 c3 01             	add    $0x1,%ebx
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a1f:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a23:	a1 c4 26 11 80       	mov    0x801126c4,%eax
80102a28:	89 04 24             	mov    %eax,(%esp)
80102a2b:	e8 a0 d6 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102a30:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80102a37:	00 
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a38:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102a3a:	8d 47 5c             	lea    0x5c(%edi),%eax
80102a3d:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a41:	8d 46 5c             	lea    0x5c(%esi),%eax
80102a44:	89 04 24             	mov    %eax,(%esp)
80102a47:	e8 a4 19 00 00       	call   801043f0 <memmove>
    bwrite(dbuf);  // write dst to disk
80102a4c:	89 34 24             	mov    %esi,(%esp)
80102a4f:	e8 4c d7 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102a54:	89 3c 24             	mov    %edi,(%esp)
80102a57:	e8 84 d7 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102a5c:	89 34 24             	mov    %esi,(%esp)
80102a5f:	e8 7c d7 ff ff       	call   801001e0 <brelse>
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102a64:	39 1d c8 26 11 80    	cmp    %ebx,0x801126c8
80102a6a:	7f 8c                	jg     801029f8 <install_trans+0x18>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf);
    brelse(dbuf);
  }
}
80102a6c:	83 c4 1c             	add    $0x1c,%esp
80102a6f:	5b                   	pop    %ebx
80102a70:	5e                   	pop    %esi
80102a71:	5f                   	pop    %edi
80102a72:	5d                   	pop    %ebp
80102a73:	c3                   	ret    
80102a74:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102a7a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80102a80 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102a80:	55                   	push   %ebp
80102a81:	89 e5                	mov    %esp,%ebp
80102a83:	57                   	push   %edi
80102a84:	56                   	push   %esi
80102a85:	53                   	push   %ebx
80102a86:	83 ec 1c             	sub    $0x1c,%esp
  struct buf *buf = bread(log.dev, log.start);
80102a89:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102a8e:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a92:	a1 c4 26 11 80       	mov    0x801126c4,%eax
80102a97:	89 04 24             	mov    %eax,(%esp)
80102a9a:	e8 31 d6 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102a9f:	8b 1d c8 26 11 80    	mov    0x801126c8,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102aa5:	85 db                	test   %ebx,%ebx
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102aa7:	89 c7                	mov    %eax,%edi
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102aa9:	89 58 5c             	mov    %ebx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102aac:	7e 1c                	jle    80102aca <write_head+0x4a>
80102aae:	31 d2                	xor    %edx,%edx
80102ab0:	8d 70 5c             	lea    0x5c(%eax),%esi
80102ab3:	90                   	nop
80102ab4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80102ab8:	8b 0c 95 cc 26 11 80 	mov    -0x7feed934(,%edx,4),%ecx
80102abf:	89 4c 96 04          	mov    %ecx,0x4(%esi,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102ac3:	83 c2 01             	add    $0x1,%edx
80102ac6:	39 da                	cmp    %ebx,%edx
80102ac8:	75 ee                	jne    80102ab8 <write_head+0x38>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
80102aca:	89 3c 24             	mov    %edi,(%esp)
80102acd:	e8 ce d6 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102ad2:	89 3c 24             	mov    %edi,(%esp)
80102ad5:	e8 06 d7 ff ff       	call   801001e0 <brelse>
}
80102ada:	83 c4 1c             	add    $0x1c,%esp
80102add:	5b                   	pop    %ebx
80102ade:	5e                   	pop    %esi
80102adf:	5f                   	pop    %edi
80102ae0:	5d                   	pop    %ebp
80102ae1:	c3                   	ret    
80102ae2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102ae9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102af0 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
80102af0:	55                   	push   %ebp
80102af1:	89 e5                	mov    %esp,%ebp
80102af3:	56                   	push   %esi
80102af4:	53                   	push   %ebx
80102af5:	83 ec 30             	sub    $0x30,%esp
80102af8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80102afb:	c7 44 24 04 b0 71 10 	movl   $0x801071b0,0x4(%esp)
80102b02:	80 
80102b03:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102b0a:	e8 01 16 00 00       	call   80104110 <initlock>
  readsb(dev, &sb);
80102b0f:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102b12:	89 44 24 04          	mov    %eax,0x4(%esp)
80102b16:	89 1c 24             	mov    %ebx,(%esp)
80102b19:	e8 72 e8 ff ff       	call   80101390 <readsb>
  log.start = sb.logstart;
80102b1e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  log.size = sb.nlog;
80102b21:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.dev = dev;
80102b24:	89 1d c4 26 11 80    	mov    %ebx,0x801126c4

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102b2a:	89 1c 24             	mov    %ebx,(%esp)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
80102b2d:	a3 b4 26 11 80       	mov    %eax,0x801126b4
  log.size = sb.nlog;
80102b32:	89 15 b8 26 11 80    	mov    %edx,0x801126b8

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102b38:	89 44 24 04          	mov    %eax,0x4(%esp)
80102b3c:	e8 8f d5 ff ff       	call   801000d0 <bread>
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102b41:	8b 58 5c             	mov    0x5c(%eax),%ebx
  for (i = 0; i < log.lh.n; i++) {
80102b44:	85 db                	test   %ebx,%ebx
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102b46:	89 1d c8 26 11 80    	mov    %ebx,0x801126c8
  for (i = 0; i < log.lh.n; i++) {
80102b4c:	7e 1c                	jle    80102b6a <initlog+0x7a>
80102b4e:	31 d2                	xor    %edx,%edx
80102b50:	8d 70 5c             	lea    0x5c(%eax),%esi
80102b53:	90                   	nop
80102b54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    log.lh.block[i] = lh->block[i];
80102b58:	8b 4c 96 04          	mov    0x4(%esi,%edx,4),%ecx
80102b5c:	89 0c 95 cc 26 11 80 	mov    %ecx,-0x7feed934(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80102b63:	83 c2 01             	add    $0x1,%edx
80102b66:	39 da                	cmp    %ebx,%edx
80102b68:	75 ee                	jne    80102b58 <initlog+0x68>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
80102b6a:	89 04 24             	mov    %eax,(%esp)
80102b6d:	e8 6e d6 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102b72:	e8 69 fe ff ff       	call   801029e0 <install_trans>
  log.lh.n = 0;
80102b77:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102b7e:	00 00 00 
  write_head(); // clear the log
80102b81:	e8 fa fe ff ff       	call   80102a80 <write_head>
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
  recover_from_log();
}
80102b86:	83 c4 30             	add    $0x30,%esp
80102b89:	5b                   	pop    %ebx
80102b8a:	5e                   	pop    %esi
80102b8b:	5d                   	pop    %ebp
80102b8c:	c3                   	ret    
80102b8d:	8d 76 00             	lea    0x0(%esi),%esi

80102b90 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102b90:	55                   	push   %ebp
80102b91:	89 e5                	mov    %esp,%ebp
80102b93:	83 ec 18             	sub    $0x18,%esp
  acquire(&log.lock);
80102b96:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102b9d:	e8 5e 16 00 00       	call   80104200 <acquire>
80102ba2:	eb 18                	jmp    80102bbc <begin_op+0x2c>
80102ba4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
80102ba8:	c7 44 24 04 80 26 11 	movl   $0x80112680,0x4(%esp)
80102baf:	80 
80102bb0:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102bb7:	e8 f4 10 00 00       	call   80103cb0 <sleep>
void
begin_op(void)
{
  acquire(&log.lock);
  while(1){
    if(log.committing){
80102bbc:	a1 c0 26 11 80       	mov    0x801126c0,%eax
80102bc1:	85 c0                	test   %eax,%eax
80102bc3:	75 e3                	jne    80102ba8 <begin_op+0x18>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102bc5:	8b 15 bc 26 11 80    	mov    0x801126bc,%edx
80102bcb:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102bd1:	83 c2 01             	add    $0x1,%edx
80102bd4:	8d 04 92             	lea    (%edx,%edx,4),%eax
80102bd7:	8d 04 41             	lea    (%ecx,%eax,2),%eax
80102bda:	83 f8 1e             	cmp    $0x1e,%eax
80102bdd:	7f c9                	jg     80102ba8 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102bdf:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
80102be6:	89 15 bc 26 11 80    	mov    %edx,0x801126bc
      release(&log.lock);
80102bec:	e8 ef 16 00 00       	call   801042e0 <release>
      break;
    }
  }
}
80102bf1:	c9                   	leave  
80102bf2:	c3                   	ret    
80102bf3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102bf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102c00 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102c00:	55                   	push   %ebp
80102c01:	89 e5                	mov    %esp,%ebp
80102c03:	57                   	push   %edi
80102c04:	56                   	push   %esi
80102c05:	53                   	push   %ebx
80102c06:	83 ec 1c             	sub    $0x1c,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102c09:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102c10:	e8 eb 15 00 00       	call   80104200 <acquire>
  log.outstanding -= 1;
80102c15:	a1 bc 26 11 80       	mov    0x801126bc,%eax
  if(log.committing)
80102c1a:	8b 15 c0 26 11 80    	mov    0x801126c0,%edx
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102c20:	83 e8 01             	sub    $0x1,%eax
  if(log.committing)
80102c23:	85 d2                	test   %edx,%edx
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102c25:	a3 bc 26 11 80       	mov    %eax,0x801126bc
  if(log.committing)
80102c2a:	0f 85 f3 00 00 00    	jne    80102d23 <end_op+0x123>
    panic("log.committing");
  if(log.outstanding == 0){
80102c30:	85 c0                	test   %eax,%eax
80102c32:	0f 85 cb 00 00 00    	jne    80102d03 <end_op+0x103>
    do_commit = 1;
    log.committing = 1;
80102c38:	c7 05 c0 26 11 80 01 	movl   $0x1,0x801126c0
80102c3f:	00 00 00 
}

static void
commit()
{
  if (log.lh.n > 0) {
80102c42:	31 db                	xor    %ebx,%ebx
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102c44:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102c4b:	e8 90 16 00 00       	call   801042e0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102c50:	a1 c8 26 11 80       	mov    0x801126c8,%eax
80102c55:	85 c0                	test   %eax,%eax
80102c57:	0f 8e 90 00 00 00    	jle    80102ced <end_op+0xed>
80102c5d:	8d 76 00             	lea    0x0(%esi),%esi
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102c60:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102c65:	01 d8                	add    %ebx,%eax
80102c67:	83 c0 01             	add    $0x1,%eax
80102c6a:	89 44 24 04          	mov    %eax,0x4(%esp)
80102c6e:	a1 c4 26 11 80       	mov    0x801126c4,%eax
80102c73:	89 04 24             	mov    %eax,(%esp)
80102c76:	e8 55 d4 ff ff       	call   801000d0 <bread>
80102c7b:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c7d:	8b 04 9d cc 26 11 80 	mov    -0x7feed934(,%ebx,4),%eax
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102c84:	83 c3 01             	add    $0x1,%ebx
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c87:	89 44 24 04          	mov    %eax,0x4(%esp)
80102c8b:	a1 c4 26 11 80       	mov    0x801126c4,%eax
80102c90:	89 04 24             	mov    %eax,(%esp)
80102c93:	e8 38 d4 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102c98:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80102c9f:	00 
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102ca0:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102ca2:	8d 40 5c             	lea    0x5c(%eax),%eax
80102ca5:	89 44 24 04          	mov    %eax,0x4(%esp)
80102ca9:	8d 46 5c             	lea    0x5c(%esi),%eax
80102cac:	89 04 24             	mov    %eax,(%esp)
80102caf:	e8 3c 17 00 00       	call   801043f0 <memmove>
    bwrite(to);  // write the log
80102cb4:	89 34 24             	mov    %esi,(%esp)
80102cb7:	e8 e4 d4 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102cbc:	89 3c 24             	mov    %edi,(%esp)
80102cbf:	e8 1c d5 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102cc4:	89 34 24             	mov    %esi,(%esp)
80102cc7:	e8 14 d5 ff ff       	call   801001e0 <brelse>
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102ccc:	3b 1d c8 26 11 80    	cmp    0x801126c8,%ebx
80102cd2:	7c 8c                	jl     80102c60 <end_op+0x60>
static void
commit()
{
  if (log.lh.n > 0) {
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102cd4:	e8 a7 fd ff ff       	call   80102a80 <write_head>
    install_trans(); // Now install writes to home locations
80102cd9:	e8 02 fd ff ff       	call   801029e0 <install_trans>
    log.lh.n = 0;
80102cde:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102ce5:	00 00 00 
    write_head();    // Erase the transaction from the log
80102ce8:	e8 93 fd ff ff       	call   80102a80 <write_head>

  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&log.lock);
80102ced:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102cf4:	e8 07 15 00 00       	call   80104200 <acquire>
    log.committing = 0;
80102cf9:	c7 05 c0 26 11 80 00 	movl   $0x0,0x801126c0
80102d00:	00 00 00 
    wakeup(&log);
80102d03:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102d0a:	e8 41 11 00 00       	call   80103e50 <wakeup>
    release(&log.lock);
80102d0f:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102d16:	e8 c5 15 00 00       	call   801042e0 <release>
  }
}
80102d1b:	83 c4 1c             	add    $0x1c,%esp
80102d1e:	5b                   	pop    %ebx
80102d1f:	5e                   	pop    %esi
80102d20:	5f                   	pop    %edi
80102d21:	5d                   	pop    %ebp
80102d22:	c3                   	ret    
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
80102d23:	c7 04 24 b4 71 10 80 	movl   $0x801071b4,(%esp)
80102d2a:	e8 41 d6 ff ff       	call   80100370 <panic>
80102d2f:	90                   	nop

80102d30 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102d30:	55                   	push   %ebp
80102d31:	89 e5                	mov    %esp,%ebp
80102d33:	53                   	push   %ebx
80102d34:	83 ec 14             	sub    $0x14,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102d37:	a1 c8 26 11 80       	mov    0x801126c8,%eax
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102d3c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102d3f:	83 f8 1d             	cmp    $0x1d,%eax
80102d42:	0f 8f 98 00 00 00    	jg     80102de0 <log_write+0xb0>
80102d48:	8b 15 b8 26 11 80    	mov    0x801126b8,%edx
80102d4e:	83 ea 01             	sub    $0x1,%edx
80102d51:	39 d0                	cmp    %edx,%eax
80102d53:	0f 8d 87 00 00 00    	jge    80102de0 <log_write+0xb0>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102d59:	8b 0d bc 26 11 80    	mov    0x801126bc,%ecx
80102d5f:	85 c9                	test   %ecx,%ecx
80102d61:	0f 8e 85 00 00 00    	jle    80102dec <log_write+0xbc>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102d67:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102d6e:	e8 8d 14 00 00       	call   80104200 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102d73:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102d79:	83 fa 00             	cmp    $0x0,%edx
80102d7c:	7e 53                	jle    80102dd1 <log_write+0xa1>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102d7e:	8b 4b 08             	mov    0x8(%ebx),%ecx
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80102d81:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102d83:	39 0d cc 26 11 80    	cmp    %ecx,0x801126cc
80102d89:	75 0e                	jne    80102d99 <log_write+0x69>
80102d8b:	eb 3b                	jmp    80102dc8 <log_write+0x98>
80102d8d:	8d 76 00             	lea    0x0(%esi),%esi
80102d90:	39 0c 85 cc 26 11 80 	cmp    %ecx,-0x7feed934(,%eax,4)
80102d97:	74 2f                	je     80102dc8 <log_write+0x98>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80102d99:	83 c0 01             	add    $0x1,%eax
80102d9c:	39 d0                	cmp    %edx,%eax
80102d9e:	75 f0                	jne    80102d90 <log_write+0x60>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80102da0:	89 0c 95 cc 26 11 80 	mov    %ecx,-0x7feed934(,%edx,4)
  if (i == log.lh.n)
    log.lh.n++;
80102da7:	83 c2 01             	add    $0x1,%edx
80102daa:	89 15 c8 26 11 80    	mov    %edx,0x801126c8
  b->flags |= B_DIRTY; // prevent eviction
80102db0:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102db3:	c7 45 08 80 26 11 80 	movl   $0x80112680,0x8(%ebp)
}
80102dba:	83 c4 14             	add    $0x14,%esp
80102dbd:	5b                   	pop    %ebx
80102dbe:	5d                   	pop    %ebp
  }
  log.lh.block[i] = b->blockno;
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
  release(&log.lock);
80102dbf:	e9 1c 15 00 00       	jmp    801042e0 <release>
80102dc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80102dc8:	89 0c 85 cc 26 11 80 	mov    %ecx,-0x7feed934(,%eax,4)
80102dcf:	eb df                	jmp    80102db0 <log_write+0x80>
80102dd1:	8b 43 08             	mov    0x8(%ebx),%eax
80102dd4:	a3 cc 26 11 80       	mov    %eax,0x801126cc
  if (i == log.lh.n)
80102dd9:	75 d5                	jne    80102db0 <log_write+0x80>
80102ddb:	eb ca                	jmp    80102da7 <log_write+0x77>
80102ddd:	8d 76 00             	lea    0x0(%esi),%esi
log_write(struct buf *b)
{
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    panic("too big a transaction");
80102de0:	c7 04 24 c3 71 10 80 	movl   $0x801071c3,(%esp)
80102de7:	e8 84 d5 ff ff       	call   80100370 <panic>
  if (log.outstanding < 1)
    panic("log_write outside of trans");
80102dec:	c7 04 24 d9 71 10 80 	movl   $0x801071d9,(%esp)
80102df3:	e8 78 d5 ff ff       	call   80100370 <panic>
	...

80102e00 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102e00:	55                   	push   %ebp
80102e01:	89 e5                	mov    %esp,%ebp
80102e03:	53                   	push   %ebx
80102e04:	83 ec 14             	sub    $0x14,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102e07:	e8 24 09 00 00       	call   80103730 <cpuid>
80102e0c:	89 c3                	mov    %eax,%ebx
80102e0e:	e8 1d 09 00 00       	call   80103730 <cpuid>
80102e13:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80102e17:	c7 04 24 f4 71 10 80 	movl   $0x801071f4,(%esp)
80102e1e:	89 44 24 04          	mov    %eax,0x4(%esp)
80102e22:	e8 29 d8 ff ff       	call   80100650 <cprintf>
  idtinit();       // load idt register
80102e27:	e8 74 27 00 00       	call   801055a0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102e2c:	e8 7f 08 00 00       	call   801036b0 <mycpu>
80102e31:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102e33:	b8 01 00 00 00       	mov    $0x1,%eax
80102e38:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102e3f:	e8 cc 0b 00 00       	call   80103a10 <scheduler>
80102e44:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102e4a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80102e50 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80102e50:	55                   	push   %ebp
80102e51:	89 e5                	mov    %esp,%ebp
80102e53:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102e56:	e8 95 37 00 00       	call   801065f0 <switchkvm>
  seginit();
80102e5b:	e8 b0 36 00 00       	call   80106510 <seginit>
  lapicinit();
80102e60:	e8 bb f7 ff ff       	call   80102620 <lapicinit>
  mpmain();
80102e65:	e8 96 ff ff ff       	call   80102e00 <mpmain>
80102e6a:	00 00                	add    %al,(%eax)
80102e6c:	00 00                	add    %al,(%eax)
	...

80102e70 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80102e70:	55                   	push   %ebp
80102e71:	89 e5                	mov    %esp,%ebp
80102e73:	53                   	push   %ebx
80102e74:	83 e4 f0             	and    $0xfffffff0,%esp
80102e77:	83 ec 10             	sub    $0x10,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102e7a:	c7 44 24 04 00 00 40 	movl   $0x80400000,0x4(%esp)
80102e81:	80 
80102e82:	c7 04 24 a8 54 11 80 	movl   $0x801154a8,(%esp)
80102e89:	e8 f2 f5 ff ff       	call   80102480 <kinit1>
  kvmalloc();      // kernel page table
80102e8e:	e8 9d 3c 00 00       	call   80106b30 <kvmalloc>
  mpinit();        // detect other processors
80102e93:	e8 68 01 00 00       	call   80103000 <mpinit>
  lapicinit();     // interrupt controller
80102e98:	e8 83 f7 ff ff       	call   80102620 <lapicinit>
80102e9d:	8d 76 00             	lea    0x0(%esi),%esi
  seginit();       // segment descriptors
80102ea0:	e8 6b 36 00 00       	call   80106510 <seginit>
  picinit();       // disable pic
80102ea5:	e8 26 03 00 00       	call   801031d0 <picinit>
  ioapicinit();    // another interrupt controller
80102eaa:	e8 d1 f3 ff ff       	call   80102280 <ioapicinit>
80102eaf:	90                   	nop
  consoleinit();   // console hardware
80102eb0:	e8 ab da ff ff       	call   80100960 <consoleinit>
  uartinit();      // serial port
80102eb5:	e8 16 2a 00 00       	call   801058d0 <uartinit>
  pinit();         // process table
80102eba:	e8 d1 07 00 00       	call   80103690 <pinit>
80102ebf:	90                   	nop
  tvinit();        // trap vectors
80102ec0:	e8 4b 26 00 00       	call   80105510 <tvinit>
  binit();         // buffer cache
80102ec5:	e8 76 d1 ff ff       	call   80100040 <binit>
  fileinit();      // file table
80102eca:	e8 71 de ff ff       	call   80100d40 <fileinit>
80102ecf:	90                   	nop
  ideinit();       // disk 
80102ed0:	e8 bb f1 ff ff       	call   80102090 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102ed5:	c7 44 24 08 8a 00 00 	movl   $0x8a,0x8(%esp)
80102edc:	00 
80102edd:	c7 44 24 04 8c a4 10 	movl   $0x8010a48c,0x4(%esp)
80102ee4:	80 
80102ee5:	c7 04 24 00 70 00 80 	movl   $0x80007000,(%esp)
80102eec:	e8 ff 14 00 00       	call   801043f0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102ef1:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80102ef8:	00 00 00 
80102efb:	05 80 27 11 80       	add    $0x80112780,%eax
80102f00:	3d 80 27 11 80       	cmp    $0x80112780,%eax
80102f05:	76 6c                	jbe    80102f73 <main+0x103>
80102f07:	bb 80 27 11 80       	mov    $0x80112780,%ebx
80102f0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(c == mycpu())  // We've started already.
80102f10:	e8 9b 07 00 00       	call   801036b0 <mycpu>
80102f15:	39 d8                	cmp    %ebx,%eax
80102f17:	74 41                	je     80102f5a <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102f19:	e8 b2 f5 ff ff       	call   801024d0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void**)(code-8) = mpenter;
80102f1e:	c7 05 f8 6f 00 80 50 	movl   $0x80102e50,0x80006ff8
80102f25:	2e 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102f28:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80102f2f:	90 10 00 

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
    *(void**)(code-4) = stack + KSTACKSIZE;
80102f32:	05 00 10 00 00       	add    $0x1000,%eax
80102f37:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    *(void**)(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80102f3c:	0f b6 03             	movzbl (%ebx),%eax
80102f3f:	c7 44 24 04 00 70 00 	movl   $0x7000,0x4(%esp)
80102f46:	00 
80102f47:	89 04 24             	mov    %eax,(%esp)
80102f4a:	e8 11 f8 ff ff       	call   80102760 <lapicstartap>
80102f4f:	90                   	nop

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102f50:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102f56:	85 c0                	test   %eax,%eax
80102f58:	74 f6                	je     80102f50 <main+0xe0>
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80102f5a:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80102f61:	00 00 00 
80102f64:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102f6a:	05 80 27 11 80       	add    $0x80112780,%eax
80102f6f:	39 c3                	cmp    %eax,%ebx
80102f71:	72 9d                	jb     80102f10 <main+0xa0>
  tvinit();        // trap vectors
  binit();         // buffer cache
  fileinit();      // file table
  ideinit();       // disk 
  startothers();   // start other processors
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102f73:	c7 44 24 04 00 00 00 	movl   $0x8e000000,0x4(%esp)
80102f7a:	8e 
80102f7b:	c7 04 24 00 00 40 80 	movl   $0x80400000,(%esp)
80102f82:	e8 c9 f4 ff ff       	call   80102450 <kinit2>
  userinit();      // first user process
80102f87:	e8 f4 07 00 00       	call   80103780 <userinit>
  mpmain();        // finish this processor's setup
80102f8c:	e8 6f fe ff ff       	call   80102e00 <mpmain>
	...

80102fa0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102fa0:	55                   	push   %ebp
  uchar *e, *p, *addr;

  addr = P2V(a);
80102fa1:	05 00 00 00 80       	add    $0x80000000,%eax
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102fa6:	89 e5                	mov    %esp,%ebp
80102fa8:	56                   	push   %esi
80102fa9:	53                   	push   %ebx
  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80102faa:	31 db                	xor    %ebx,%ebx
mpsearch1(uint a, int len)
{
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
80102fac:	8d 34 10             	lea    (%eax,%edx,1),%esi
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102faf:	83 ec 10             	sub    $0x10,%esp
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80102fb2:	39 f0                	cmp    %esi,%eax
80102fb4:	73 3d                	jae    80102ff3 <mpsearch1+0x53>
80102fb6:	89 c3                	mov    %eax,%ebx
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102fb8:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80102fbf:	00 
80102fc0:	c7 44 24 04 08 72 10 	movl   $0x80107208,0x4(%esp)
80102fc7:	80 
80102fc8:	89 1c 24             	mov    %ebx,(%esp)
80102fcb:	e8 c0 13 00 00       	call   80104390 <memcmp>
80102fd0:	85 c0                	test   %eax,%eax
80102fd2:	75 16                	jne    80102fea <mpsearch1+0x4a>
80102fd4:	31 d2                	xor    %edx,%edx
80102fd6:	66 90                	xchg   %ax,%ax
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
    sum += addr[i];
80102fd8:	0f b6 0c 03          	movzbl (%ebx,%eax,1),%ecx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80102fdc:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
80102fdf:	01 ca                	add    %ecx,%edx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80102fe1:	83 f8 10             	cmp    $0x10,%eax
80102fe4:	75 f2                	jne    80102fd8 <mpsearch1+0x38>
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102fe6:	84 d2                	test   %dl,%dl
80102fe8:	74 09                	je     80102ff3 <mpsearch1+0x53>
{
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80102fea:	83 c3 10             	add    $0x10,%ebx
80102fed:	39 de                	cmp    %ebx,%esi
80102fef:	77 c7                	ja     80102fb8 <mpsearch1+0x18>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80102ff1:	31 db                	xor    %ebx,%ebx
}
80102ff3:	83 c4 10             	add    $0x10,%esp
80102ff6:	89 d8                	mov    %ebx,%eax
80102ff8:	5b                   	pop    %ebx
80102ff9:	5e                   	pop    %esi
80102ffa:	5d                   	pop    %ebp
80102ffb:	c3                   	ret    
80102ffc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103000 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103000:	55                   	push   %ebp
80103001:	89 e5                	mov    %esp,%ebp
80103003:	57                   	push   %edi
80103004:	56                   	push   %esi
80103005:	53                   	push   %ebx
80103006:	83 ec 2c             	sub    $0x2c,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103009:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103010:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103017:	c1 e0 08             	shl    $0x8,%eax
8010301a:	09 d0                	or     %edx,%eax
8010301c:	c1 e0 04             	shl    $0x4,%eax
8010301f:	85 c0                	test   %eax,%eax
80103021:	75 1b                	jne    8010303e <mpinit+0x3e>
    if((mp = mpsearch1(p, 1024)))
      return mp;
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103023:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010302a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103031:	c1 e0 08             	shl    $0x8,%eax
80103034:	09 d0                	or     %edx,%eax
80103036:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103039:	2d 00 04 00 00       	sub    $0x400,%eax
8010303e:	ba 00 04 00 00       	mov    $0x400,%edx
80103043:	e8 58 ff ff ff       	call   80102fa0 <mpsearch1>
80103048:	85 c0                	test   %eax,%eax
8010304a:	89 c6                	mov    %eax,%esi
8010304c:	0f 84 38 01 00 00    	je     8010318a <mpinit+0x18a>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103052:	8b 5e 04             	mov    0x4(%esi),%ebx
80103055:	85 db                	test   %ebx,%ebx
80103057:	0f 84 46 01 00 00    	je     801031a3 <mpinit+0x1a3>
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010305d:	8d 93 00 00 00 80    	lea    -0x80000000(%ebx),%edx
80103063:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103066:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
8010306d:	00 
8010306e:	c7 44 24 04 0d 72 10 	movl   $0x8010720d,0x4(%esp)
80103075:	80 
80103076:	89 14 24             	mov    %edx,(%esp)
80103079:	e8 12 13 00 00       	call   80104390 <memcmp>
8010307e:	85 c0                	test   %eax,%eax
80103080:	0f 85 1d 01 00 00    	jne    801031a3 <mpinit+0x1a3>
    return 0;
  if(conf->version != 1 && conf->version != 4)
80103086:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
8010308d:	3c 04                	cmp    $0x4,%al
8010308f:	0f 85 1b 01 00 00    	jne    801031b0 <mpinit+0x1b0>
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
80103095:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
8010309c:	85 ff                	test   %edi,%edi
8010309e:	74 21                	je     801030c1 <mpinit+0xc1>
801030a0:	31 d2                	xor    %edx,%edx
801030a2:	31 c0                	xor    %eax,%eax
801030a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
801030a8:	0f b6 8c 03 00 00 00 	movzbl -0x80000000(%ebx,%eax,1),%ecx
801030af:	80 
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
801030b0:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
801030b3:	01 ca                	add    %ecx,%edx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
801030b5:	39 c7                	cmp    %eax,%edi
801030b7:	7f ef                	jg     801030a8 <mpinit+0xa8>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
801030b9:	84 d2                	test   %dl,%dl
801030bb:	0f 85 e2 00 00 00    	jne    801031a3 <mpinit+0x1a3>
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
801030c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801030c4:	85 c0                	test   %eax,%eax
801030c6:	0f 84 d7 00 00 00    	je     801031a3 <mpinit+0x1a3>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801030cc:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
801030d2:	89 75 e0             	mov    %esi,-0x20(%ebp)
801030d5:	a3 7c 26 11 80       	mov    %eax,0x8011267c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801030da:	0f b7 8b 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%ecx
801030e1:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
801030e7:	03 4d e4             	add    -0x1c(%ebp),%ecx
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
801030ea:	bb 01 00 00 00       	mov    $0x1,%ebx
801030ef:	90                   	nop
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801030f0:	39 c8                	cmp    %ecx,%eax
801030f2:	73 23                	jae    80103117 <mpinit+0x117>
801030f4:	0f b6 10             	movzbl (%eax),%edx
    switch(*p){
801030f7:	80 fa 04             	cmp    $0x4,%dl
801030fa:	76 07                	jbe    80103103 <mpinit+0x103>
    case MPIOINTR:
    case MPLINTR:
      p += 8;
      continue;
    default:
      ismp = 0;
801030fc:	31 db                	xor    %ebx,%ebx
  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
801030fe:	80 fa 04             	cmp    $0x4,%dl
80103101:	77 f9                	ja     801030fc <mpinit+0xfc>
80103103:	0f b6 d2             	movzbl %dl,%edx
80103106:	ff 24 95 4c 72 10 80 	jmp    *-0x7fef8db4(,%edx,4)
8010310d:	8d 76 00             	lea    0x0(%esi),%esi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103110:	83 c0 08             	add    $0x8,%eax

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103113:	39 c8                	cmp    %ecx,%eax
80103115:	72 dd                	jb     801030f4 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103117:	85 db                	test   %ebx,%ebx
80103119:	8b 75 e0             	mov    -0x20(%ebp),%esi
8010311c:	0f 84 98 00 00 00    	je     801031ba <mpinit+0x1ba>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80103122:	80 7e 0c 00          	cmpb   $0x0,0xc(%esi)
80103126:	74 12                	je     8010313a <mpinit+0x13a>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103128:	ba 22 00 00 00       	mov    $0x22,%edx
8010312d:	b8 70 00 00 00       	mov    $0x70,%eax
80103132:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103133:	b2 23                	mov    $0x23,%dl
80103135:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103136:	83 c8 01             	or     $0x1,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103139:	ee                   	out    %al,(%dx)
  }
}
8010313a:	83 c4 2c             	add    $0x2c,%esp
8010313d:	5b                   	pop    %ebx
8010313e:	5e                   	pop    %esi
8010313f:	5f                   	pop    %edi
80103140:	5d                   	pop    %ebp
80103141:	c3                   	ret    
80103142:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
80103148:	8b 15 00 2d 11 80    	mov    0x80112d00,%edx
8010314e:	83 fa 07             	cmp    $0x7,%edx
80103151:	7f 1b                	jg     8010316e <mpinit+0x16e>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103153:	0f b6 78 01          	movzbl 0x1(%eax),%edi
80103157:	69 d2 b0 00 00 00    	imul   $0xb0,%edx,%edx
        ncpu++;
8010315d:	83 05 00 2d 11 80 01 	addl   $0x1,0x80112d00
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103164:	89 d6                	mov    %edx,%esi
80103166:	89 fa                	mov    %edi,%edx
80103168:	88 96 80 27 11 80    	mov    %dl,-0x7feed880(%esi)
        ncpu++;
      }
      p += sizeof(struct mpproc);
8010316e:	83 c0 14             	add    $0x14,%eax
      continue;
80103171:	e9 7a ff ff ff       	jmp    801030f0 <mpinit+0xf0>
80103176:	66 90                	xchg   %ax,%ax
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
80103178:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
8010317c:	83 c0 08             	add    $0x8,%eax
      }
      p += sizeof(struct mpproc);
      continue;
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
8010317f:	88 15 60 27 11 80    	mov    %dl,0x80112760
      p += sizeof(struct mpioapic);
      continue;
80103185:	e9 66 ff ff ff       	jmp    801030f0 <mpinit+0xf0>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
8010318a:	ba 00 00 01 00       	mov    $0x10000,%edx
8010318f:	b8 00 00 0f 00       	mov    $0xf0000,%eax
80103194:	e8 07 fe ff ff       	call   80102fa0 <mpsearch1>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103199:	85 c0                	test   %eax,%eax
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
8010319b:	89 c6                	mov    %eax,%esi
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
8010319d:	0f 85 af fe ff ff    	jne    80103052 <mpinit+0x52>
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
801031a3:	c7 04 24 12 72 10 80 	movl   $0x80107212,(%esp)
801031aa:	e8 c1 d1 ff ff       	call   80100370 <panic>
801031af:	90                   	nop
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
801031b0:	3c 01                	cmp    $0x1,%al
801031b2:	0f 84 dd fe ff ff    	je     80103095 <mpinit+0x95>
801031b8:	eb e9                	jmp    801031a3 <mpinit+0x1a3>
      ismp = 0;
      break;
    }
  }
  if(!ismp)
    panic("Didn't find a suitable machine");
801031ba:	c7 04 24 2c 72 10 80 	movl   $0x8010722c,(%esp)
801031c1:	e8 aa d1 ff ff       	call   80100370 <panic>
	...

801031d0 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
801031d0:	55                   	push   %ebp
801031d1:	ba 21 00 00 00       	mov    $0x21,%edx
801031d6:	89 e5                	mov    %esp,%ebp
801031d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801031dd:	ee                   	out    %al,(%dx)
801031de:	b2 a1                	mov    $0xa1,%dl
801031e0:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
801031e1:	5d                   	pop    %ebp
801031e2:	c3                   	ret    
	...

801031f0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801031f0:	55                   	push   %ebp
801031f1:	89 e5                	mov    %esp,%ebp
801031f3:	83 ec 28             	sub    $0x28,%esp
801031f6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
801031f9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801031fc:	89 75 f8             	mov    %esi,-0x8(%ebp)
801031ff:	8b 75 08             	mov    0x8(%ebp),%esi
80103202:	89 7d fc             	mov    %edi,-0x4(%ebp)
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80103205:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
8010320b:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80103211:	e8 4a db ff ff       	call   80100d60 <filealloc>
80103216:	85 c0                	test   %eax,%eax
80103218:	89 06                	mov    %eax,(%esi)
8010321a:	0f 84 a6 00 00 00    	je     801032c6 <pipealloc+0xd6>
80103220:	e8 3b db ff ff       	call   80100d60 <filealloc>
80103225:	85 c0                	test   %eax,%eax
80103227:	89 03                	mov    %eax,(%ebx)
80103229:	0f 84 89 00 00 00    	je     801032b8 <pipealloc+0xc8>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
8010322f:	e8 9c f2 ff ff       	call   801024d0 <kalloc>
80103234:	85 c0                	test   %eax,%eax
80103236:	89 c7                	mov    %eax,%edi
80103238:	74 7e                	je     801032b8 <pipealloc+0xc8>
    goto bad;
  p->readopen = 1;
8010323a:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103241:	00 00 00 
  p->writeopen = 1;
80103244:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010324b:	00 00 00 
  p->nwrite = 0;
8010324e:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103255:	00 00 00 
  p->nread = 0;
80103258:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
8010325f:	00 00 00 
  initlock(&p->lock, "pipe");
80103262:	89 04 24             	mov    %eax,(%esp)
80103265:	c7 44 24 04 60 72 10 	movl   $0x80107260,0x4(%esp)
8010326c:	80 
8010326d:	e8 9e 0e 00 00       	call   80104110 <initlock>
  (*f0)->type = FD_PIPE;
80103272:	8b 06                	mov    (%esi),%eax
80103274:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
8010327a:	8b 06                	mov    (%esi),%eax
8010327c:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103280:	8b 06                	mov    (%esi),%eax
80103282:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103286:	8b 06                	mov    (%esi),%eax
80103288:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010328b:	8b 03                	mov    (%ebx),%eax
8010328d:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103293:	8b 03                	mov    (%ebx),%eax
80103295:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103299:	8b 03                	mov    (%ebx),%eax
8010329b:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
8010329f:	8b 03                	mov    (%ebx),%eax
  return 0;
801032a1:	31 db                	xor    %ebx,%ebx
  (*f0)->writable = 0;
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
801032a3:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801032a6:	89 d8                	mov    %ebx,%eax
801032a8:	8b 75 f8             	mov    -0x8(%ebp),%esi
801032ab:	8b 5d f4             	mov    -0xc(%ebp),%ebx
801032ae:	8b 7d fc             	mov    -0x4(%ebp),%edi
801032b1:	89 ec                	mov    %ebp,%esp
801032b3:	5d                   	pop    %ebp
801032b4:	c3                   	ret    
801032b5:	8d 76 00             	lea    0x0(%esi),%esi

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
801032b8:	8b 06                	mov    (%esi),%eax
801032ba:	85 c0                	test   %eax,%eax
801032bc:	74 08                	je     801032c6 <pipealloc+0xd6>
    fileclose(*f0);
801032be:	89 04 24             	mov    %eax,(%esp)
801032c1:	e8 5a db ff ff       	call   80100e20 <fileclose>
  if(*f1)
801032c6:	8b 03                	mov    (%ebx),%eax
    fileclose(*f1);
  return -1;
801032c8:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
    fileclose(*f0);
  if(*f1)
801032cd:	85 c0                	test   %eax,%eax
801032cf:	74 d5                	je     801032a6 <pipealloc+0xb6>
    fileclose(*f1);
801032d1:	89 04 24             	mov    %eax,(%esp)
801032d4:	e8 47 db ff ff       	call   80100e20 <fileclose>
  return -1;
}
801032d9:	89 d8                	mov    %ebx,%eax
801032db:	8b 75 f8             	mov    -0x8(%ebp),%esi
801032de:	8b 5d f4             	mov    -0xc(%ebp),%ebx
801032e1:	8b 7d fc             	mov    -0x4(%ebp),%edi
801032e4:	89 ec                	mov    %ebp,%esp
801032e6:	5d                   	pop    %ebp
801032e7:	c3                   	ret    
801032e8:	90                   	nop
801032e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801032f0 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801032f0:	55                   	push   %ebp
801032f1:	89 e5                	mov    %esp,%ebp
801032f3:	83 ec 18             	sub    $0x18,%esp
801032f6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
801032f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801032fc:	89 75 fc             	mov    %esi,-0x4(%ebp)
801032ff:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
80103302:	89 1c 24             	mov    %ebx,(%esp)
80103305:	e8 f6 0e 00 00       	call   80104200 <acquire>
  if(writable){
8010330a:	85 f6                	test   %esi,%esi
8010330c:	74 42                	je     80103350 <pipeclose+0x60>
    p->writeopen = 0;
8010330e:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80103315:	00 00 00 
    wakeup(&p->nread);
80103318:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
8010331e:	89 04 24             	mov    %eax,(%esp)
80103321:	e8 2a 0b 00 00       	call   80103e50 <wakeup>
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103326:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010332c:	85 d2                	test   %edx,%edx
8010332e:	75 0a                	jne    8010333a <pipeclose+0x4a>
80103330:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103336:	85 c0                	test   %eax,%eax
80103338:	74 36                	je     80103370 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010333a:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010333d:	8b 75 fc             	mov    -0x4(%ebp),%esi
80103340:	8b 5d f8             	mov    -0x8(%ebp),%ebx
80103343:	89 ec                	mov    %ebp,%esp
80103345:	5d                   	pop    %ebp
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80103346:	e9 95 0f 00 00       	jmp    801042e0 <release>
8010334b:	90                   	nop
8010334c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
80103350:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103357:	00 00 00 
    wakeup(&p->nwrite);
8010335a:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80103360:	89 04 24             	mov    %eax,(%esp)
80103363:	e8 e8 0a 00 00       	call   80103e50 <wakeup>
80103368:	eb bc                	jmp    80103326 <pipeclose+0x36>
8010336a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
80103370:	89 1c 24             	mov    %ebx,(%esp)
80103373:	e8 68 0f 00 00       	call   801042e0 <release>
    kfree((char*)p);
  } else
    release(&p->lock);
}
80103378:	8b 75 fc             	mov    -0x4(%ebp),%esi
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
8010337b:	89 5d 08             	mov    %ebx,0x8(%ebp)
  } else
    release(&p->lock);
}
8010337e:	8b 5d f8             	mov    -0x8(%ebp),%ebx
80103381:	89 ec                	mov    %ebp,%esp
80103383:	5d                   	pop    %ebp
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
80103384:	e9 d7 ef ff ff       	jmp    80102360 <kfree>
80103389:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103390 <pipewrite>:
}

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103390:	55                   	push   %ebp
80103391:	89 e5                	mov    %esp,%ebp
80103393:	57                   	push   %edi
80103394:	56                   	push   %esi
80103395:	53                   	push   %ebx
80103396:	83 ec 2c             	sub    $0x2c,%esp
80103399:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010339c:	89 1c 24             	mov    %ebx,(%esp)
8010339f:	e8 5c 0e 00 00       	call   80104200 <acquire>
  for(i = 0; i < n; i++){
801033a4:	8b 45 10             	mov    0x10(%ebp),%eax
801033a7:	85 c0                	test   %eax,%eax
801033a9:	0f 8e 97 00 00 00    	jle    80103446 <pipewrite+0xb6>
801033af:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801033b5:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
801033bb:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801033c2:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
801033c8:	eb 3a                	jmp    80103404 <pipewrite+0x74>
801033ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
801033d0:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801033d6:	85 c0                	test   %eax,%eax
801033d8:	0f 84 82 00 00 00    	je     80103460 <pipewrite+0xd0>
801033de:	e8 6d 03 00 00       	call   80103750 <myproc>
801033e3:	8b 48 24             	mov    0x24(%eax),%ecx
801033e6:	85 c9                	test   %ecx,%ecx
801033e8:	75 76                	jne    80103460 <pipewrite+0xd0>
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801033ea:	89 3c 24             	mov    %edi,(%esp)
801033ed:	e8 5e 0a 00 00       	call   80103e50 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801033f2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801033f6:	89 34 24             	mov    %esi,(%esp)
801033f9:	e8 b2 08 00 00       	call   80103cb0 <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801033fe:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
80103404:	8b 93 34 02 00 00    	mov    0x234(%ebx),%edx
8010340a:	81 c2 00 02 00 00    	add    $0x200,%edx
80103410:	39 d0                	cmp    %edx,%eax
80103412:	74 bc                	je     801033d0 <pipewrite+0x40>
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103414:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103417:	8b 55 e4             	mov    -0x1c(%ebp),%edx
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
8010341a:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
8010341e:	0f b6 14 11          	movzbl (%ecx,%edx,1),%edx
80103422:	88 55 e3             	mov    %dl,-0x1d(%ebp)
80103425:	0f b6 4d e3          	movzbl -0x1d(%ebp),%ecx
80103429:	89 c2                	mov    %eax,%edx
8010342b:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103431:	83 c0 01             	add    $0x1,%eax
80103434:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
80103438:	8b 55 10             	mov    0x10(%ebp),%edx
8010343b:	39 55 e4             	cmp    %edx,-0x1c(%ebp)
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
8010343e:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
80103444:	75 be                	jne    80103404 <pipewrite+0x74>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103446:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
8010344c:	89 04 24             	mov    %eax,(%esp)
8010344f:	e8 fc 09 00 00       	call   80103e50 <wakeup>
  release(&p->lock);
80103454:	89 1c 24             	mov    %ebx,(%esp)
80103457:	e8 84 0e 00 00       	call   801042e0 <release>
  return n;
8010345c:	eb 11                	jmp    8010346f <pipewrite+0xdf>
8010345e:	66 90                	xchg   %ax,%ax

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
80103460:	89 1c 24             	mov    %ebx,(%esp)
80103463:	e8 78 0e 00 00       	call   801042e0 <release>
        return -1;
80103468:	c7 45 10 ff ff ff ff 	movl   $0xffffffff,0x10(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
8010346f:	8b 45 10             	mov    0x10(%ebp),%eax
80103472:	83 c4 2c             	add    $0x2c,%esp
80103475:	5b                   	pop    %ebx
80103476:	5e                   	pop    %esi
80103477:	5f                   	pop    %edi
80103478:	5d                   	pop    %ebp
80103479:	c3                   	ret    
8010347a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103480 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103480:	55                   	push   %ebp
80103481:	89 e5                	mov    %esp,%ebp
80103483:	57                   	push   %edi
80103484:	56                   	push   %esi
80103485:	53                   	push   %ebx
80103486:	83 ec 1c             	sub    $0x1c,%esp
80103489:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010348c:	8b 7d 10             	mov    0x10(%ebp),%edi
  int i;

  acquire(&p->lock);
8010348f:	89 1c 24             	mov    %ebx,(%esp)
80103492:	e8 69 0d 00 00       	call   80104200 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103497:	8b 93 34 02 00 00    	mov    0x234(%ebx),%edx
8010349d:	3b 93 38 02 00 00    	cmp    0x238(%ebx),%edx
801034a3:	75 5b                	jne    80103500 <piperead+0x80>
801034a5:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801034ab:	85 c0                	test   %eax,%eax
801034ad:	74 51                	je     80103500 <piperead+0x80>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801034af:	8d b3 34 02 00 00    	lea    0x234(%ebx),%esi
801034b5:	eb 25                	jmp    801034dc <piperead+0x5c>
801034b7:	90                   	nop
801034b8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801034bc:	89 34 24             	mov    %esi,(%esp)
801034bf:	e8 ec 07 00 00       	call   80103cb0 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801034c4:	8b 93 34 02 00 00    	mov    0x234(%ebx),%edx
801034ca:	3b 93 38 02 00 00    	cmp    0x238(%ebx),%edx
801034d0:	75 2e                	jne    80103500 <piperead+0x80>
801034d2:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801034d8:	85 c0                	test   %eax,%eax
801034da:	74 24                	je     80103500 <piperead+0x80>
    if(myproc()->killed){
801034dc:	e8 6f 02 00 00       	call   80103750 <myproc>
801034e1:	8b 40 24             	mov    0x24(%eax),%eax
801034e4:	85 c0                	test   %eax,%eax
801034e6:	74 d0                	je     801034b8 <piperead+0x38>
      release(&p->lock);
801034e8:	89 1c 24             	mov    %ebx,(%esp)
      return -1;
801034eb:	be ff ff ff ff       	mov    $0xffffffff,%esi
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
    if(myproc()->killed){
      release(&p->lock);
801034f0:	e8 eb 0d 00 00       	call   801042e0 <release>
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
801034f5:	83 c4 1c             	add    $0x1c,%esp
801034f8:	89 f0                	mov    %esi,%eax
801034fa:	5b                   	pop    %ebx
801034fb:	5e                   	pop    %esi
801034fc:	5f                   	pop    %edi
801034fd:	5d                   	pop    %ebp
801034fe:	c3                   	ret    
801034ff:	90                   	nop
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103500:	31 f6                	xor    %esi,%esi
80103502:	85 ff                	test   %edi,%edi
80103504:	7e 39                	jle    8010353f <piperead+0xbf>
    if(p->nread == p->nwrite)
80103506:	3b 93 38 02 00 00    	cmp    0x238(%ebx),%edx
8010350c:	74 31                	je     8010353f <piperead+0xbf>
  release(&p->lock);
  return n;
}

int
piperead(struct pipe *p, char *addr, int n)
8010350e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103511:	29 d1                	sub    %edx,%ecx
80103513:	eb 0b                	jmp    80103520 <piperead+0xa0>
80103515:	8d 76 00             	lea    0x0(%esi),%esi
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    if(p->nread == p->nwrite)
80103518:	39 93 38 02 00 00    	cmp    %edx,0x238(%ebx)
8010351e:	74 1f                	je     8010353f <piperead+0xbf>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103520:	89 d0                	mov    %edx,%eax
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103522:	83 c6 01             	add    $0x1,%esi
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103525:	25 ff 01 00 00       	and    $0x1ff,%eax
8010352a:	0f b6 44 03 34       	movzbl 0x34(%ebx,%eax,1),%eax
8010352f:	88 04 11             	mov    %al,(%ecx,%edx,1)
80103532:	83 c2 01             	add    $0x1,%edx
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103535:	39 fe                	cmp    %edi,%esi
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103537:	89 93 34 02 00 00    	mov    %edx,0x234(%ebx)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010353d:	75 d9                	jne    80103518 <piperead+0x98>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010353f:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80103545:	89 04 24             	mov    %eax,(%esp)
80103548:	e8 03 09 00 00       	call   80103e50 <wakeup>
  release(&p->lock);
8010354d:	89 1c 24             	mov    %ebx,(%esp)
80103550:	e8 8b 0d 00 00       	call   801042e0 <release>
  return i;
}
80103555:	83 c4 1c             	add    $0x1c,%esp
80103558:	89 f0                	mov    %esi,%eax
8010355a:	5b                   	pop    %ebx
8010355b:	5e                   	pop    %esi
8010355c:	5f                   	pop    %edi
8010355d:	5d                   	pop    %ebp
8010355e:	c3                   	ret    
	...

80103560 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103560:	55                   	push   %ebp
80103561:	89 e5                	mov    %esp,%ebp
80103563:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103564:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103569:	83 ec 14             	sub    $0x14,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
8010356c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103573:	e8 88 0c 00 00       	call   80104200 <acquire>

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
80103578:	8b 15 60 2d 11 80    	mov    0x80112d60,%edx
8010357e:	85 d2                	test   %edx,%edx
80103580:	74 18                	je     8010359a <allocproc+0x3a>
80103582:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103588:	83 c3 7c             	add    $0x7c,%ebx
8010358b:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
80103591:	73 7d                	jae    80103610 <allocproc+0xb0>
    if(p->state == UNUSED)
80103593:	8b 43 0c             	mov    0xc(%ebx),%eax
80103596:	85 c0                	test   %eax,%eax
80103598:	75 ee                	jne    80103588 <allocproc+0x28>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
8010359a:	a1 00 a0 10 80       	mov    0x8010a000,%eax

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
8010359f:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
801035a6:	89 43 10             	mov    %eax,0x10(%ebx)
801035a9:	83 c0 01             	add    $0x1,%eax
801035ac:	a3 00 a0 10 80       	mov    %eax,0x8010a000

  release(&ptable.lock);
801035b1:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801035b8:	e8 23 0d 00 00       	call   801042e0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801035bd:	e8 0e ef ff ff       	call   801024d0 <kalloc>
801035c2:	85 c0                	test   %eax,%eax
801035c4:	89 43 08             	mov    %eax,0x8(%ebx)
801035c7:	74 5d                	je     80103626 <allocproc+0xc6>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801035c9:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
801035cf:	89 53 18             	mov    %edx,0x18(%ebx)
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;
801035d2:	c7 80 b0 0f 00 00 f8 	movl   $0x801054f8,0xfb0(%eax)
801035d9:	54 10 80 

  sp -= sizeof *p->context;
801035dc:	05 9c 0f 00 00       	add    $0xf9c,%eax
  p->context = (struct context*)sp;
801035e1:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
801035e4:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
801035eb:	00 
801035ec:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801035f3:	00 
801035f4:	89 04 24             	mov    %eax,(%esp)
801035f7:	e8 34 0d 00 00       	call   80104330 <memset>
  p->context->eip = (uint)forkret;
801035fc:	8b 43 1c             	mov    0x1c(%ebx),%eax
801035ff:	c7 40 10 40 36 10 80 	movl   $0x80103640,0x10(%eax)

  return p;
}
80103606:	83 c4 14             	add    $0x14,%esp
80103609:	89 d8                	mov    %ebx,%eax
8010360b:	5b                   	pop    %ebx
8010360c:	5d                   	pop    %ebp
8010360d:	c3                   	ret    
8010360e:	66 90                	xchg   %ax,%ax

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
80103610:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
  return 0;
80103617:	31 db                	xor    %ebx,%ebx

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
80103619:	e8 c2 0c 00 00       	call   801042e0 <release>
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  return p;
}
8010361e:	83 c4 14             	add    $0x14,%esp
80103621:	89 d8                	mov    %ebx,%eax
80103623:	5b                   	pop    %ebx
80103624:	5d                   	pop    %ebp
80103625:	c3                   	ret    

  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
80103626:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
8010362d:	31 db                	xor    %ebx,%ebx
8010362f:	eb d5                	jmp    80103606 <allocproc+0xa6>
80103631:	eb 0d                	jmp    80103640 <forkret>
80103633:	90                   	nop
80103634:	90                   	nop
80103635:	90                   	nop
80103636:	90                   	nop
80103637:	90                   	nop
80103638:	90                   	nop
80103639:	90                   	nop
8010363a:	90                   	nop
8010363b:	90                   	nop
8010363c:	90                   	nop
8010363d:	90                   	nop
8010363e:	90                   	nop
8010363f:	90                   	nop

80103640 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103640:	55                   	push   %ebp
80103641:	89 e5                	mov    %esp,%ebp
80103643:	83 ec 18             	sub    $0x18,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103646:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010364d:	e8 8e 0c 00 00       	call   801042e0 <release>

  if (first) {
80103652:	8b 0d 04 a0 10 80    	mov    0x8010a004,%ecx
80103658:	85 c9                	test   %ecx,%ecx
8010365a:	75 04                	jne    80103660 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010365c:	c9                   	leave  
8010365d:	c3                   	ret    
8010365e:	66 90                	xchg   %ax,%ax
  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
80103660:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
80103667:	c7 05 04 a0 10 80 00 	movl   $0x0,0x8010a004
8010366e:	00 00 00 
    iinit(ROOTDEV);
80103671:	e8 0a de ff ff       	call   80101480 <iinit>
    initlog(ROOTDEV);
80103676:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010367d:	e8 6e f4 ff ff       	call   80102af0 <initlog>
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103682:	c9                   	leave  
80103683:	c3                   	ret    
80103684:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010368a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103690 <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
80103690:	55                   	push   %ebp
80103691:	89 e5                	mov    %esp,%ebp
80103693:	83 ec 18             	sub    $0x18,%esp
  initlock(&ptable.lock, "ptable");
80103696:	c7 44 24 04 65 72 10 	movl   $0x80107265,0x4(%esp)
8010369d:	80 
8010369e:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801036a5:	e8 66 0a 00 00       	call   80104110 <initlock>
}
801036aa:	c9                   	leave  
801036ab:	c3                   	ret    
801036ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801036b0 <mycpu>:

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
801036b0:	55                   	push   %ebp
801036b1:	89 e5                	mov    %esp,%ebp
801036b3:	56                   	push   %esi
801036b4:	53                   	push   %ebx
801036b5:	83 ec 10             	sub    $0x10,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801036b8:	9c                   	pushf  
801036b9:	58                   	pop    %eax
  int apicid, i;
  
  if(readeflags()&FL_IF)
801036ba:	f6 c4 02             	test   $0x2,%ah
801036bd:	75 57                	jne    80103716 <mycpu+0x66>
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
801036bf:	e8 4c f0 ff ff       	call   80102710 <lapicid>
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
801036c4:	8b 35 00 2d 11 80    	mov    0x80112d00,%esi
801036ca:	85 f6                	test   %esi,%esi
801036cc:	7e 3c                	jle    8010370a <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
801036ce:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
801036d5:	39 c2                	cmp    %eax,%edx
801036d7:	74 2d                	je     80103706 <mycpu+0x56>
      return &cpus[i];
801036d9:	b9 30 28 11 80       	mov    $0x80112830,%ecx
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
801036de:	31 d2                	xor    %edx,%edx
801036e0:	83 c2 01             	add    $0x1,%edx
801036e3:	39 f2                	cmp    %esi,%edx
801036e5:	74 23                	je     8010370a <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
801036e7:	0f b6 19             	movzbl (%ecx),%ebx
801036ea:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
801036f0:	39 c3                	cmp    %eax,%ebx
801036f2:	75 ec                	jne    801036e0 <mycpu+0x30>
      return &cpus[i];
801036f4:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
  }
  panic("unknown apicid\n");
}
801036fa:	83 c4 10             	add    $0x10,%esp
801036fd:	5b                   	pop    %ebx
801036fe:	5e                   	pop    %esi
801036ff:	5d                   	pop    %ebp
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return &cpus[i];
80103700:	05 80 27 11 80       	add    $0x80112780,%eax
  }
  panic("unknown apicid\n");
}
80103705:	c3                   	ret    
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
80103706:	31 d2                	xor    %edx,%edx
80103708:	eb ea                	jmp    801036f4 <mycpu+0x44>
      return &cpus[i];
  }
  panic("unknown apicid\n");
8010370a:	c7 04 24 6c 72 10 80 	movl   $0x8010726c,(%esp)
80103711:	e8 5a cc ff ff       	call   80100370 <panic>
mycpu(void)
{
  int apicid, i;
  
  if(readeflags()&FL_IF)
    panic("mycpu called with interrupts enabled\n");
80103716:	c7 04 24 48 73 10 80 	movl   $0x80107348,(%esp)
8010371d:	e8 4e cc ff ff       	call   80100370 <panic>
80103722:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103729:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103730 <cpuid>:
  initlock(&ptable.lock, "ptable");
}

// Must be called with interrupts disabled
int
cpuid() {
80103730:	55                   	push   %ebp
80103731:	89 e5                	mov    %esp,%ebp
80103733:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103736:	e8 75 ff ff ff       	call   801036b0 <mycpu>
}
8010373b:	c9                   	leave  
}

// Must be called with interrupts disabled
int
cpuid() {
  return mycpu()-cpus;
8010373c:	2d 80 27 11 80       	sub    $0x80112780,%eax
80103741:	c1 f8 04             	sar    $0x4,%eax
80103744:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010374a:	c3                   	ret    
8010374b:	90                   	nop
8010374c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103750 <myproc>:
}

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
80103750:	55                   	push   %ebp
80103751:	89 e5                	mov    %esp,%ebp
80103753:	53                   	push   %ebx
80103754:	83 ec 04             	sub    $0x4,%esp
  struct cpu *c;
  struct proc *p;
  pushcli();
80103757:	e8 64 0a 00 00       	call   801041c0 <pushcli>
  c = mycpu();
8010375c:	e8 4f ff ff ff       	call   801036b0 <mycpu>
  p = c->proc;
80103761:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103767:	e8 04 0b 00 00       	call   80104270 <popcli>
  return p;
}
8010376c:	83 c4 04             	add    $0x4,%esp
8010376f:	89 d8                	mov    %ebx,%eax
80103771:	5b                   	pop    %ebx
80103772:	5d                   	pop    %ebp
80103773:	c3                   	ret    
80103774:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010377a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103780 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
80103780:	55                   	push   %ebp
80103781:	89 e5                	mov    %esp,%ebp
80103783:	53                   	push   %ebx
80103784:	83 ec 14             	sub    $0x14,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
80103787:	e8 d4 fd ff ff       	call   80103560 <allocproc>
8010378c:	89 c3                	mov    %eax,%ebx
  
  initproc = p;
8010378e:	a3 a0 a5 10 80       	mov    %eax,0x8010a5a0
  if((p->pgdir = setupkvm()) == 0)
80103793:	e8 18 33 00 00       	call   80106ab0 <setupkvm>
80103798:	85 c0                	test   %eax,%eax
8010379a:	89 43 04             	mov    %eax,0x4(%ebx)
8010379d:	0f 84 ce 00 00 00    	je     80103871 <userinit+0xf1>
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801037a3:	89 04 24             	mov    %eax,(%esp)
801037a6:	c7 44 24 08 2c 00 00 	movl   $0x2c,0x8(%esp)
801037ad:	00 
801037ae:	c7 44 24 04 60 a4 10 	movl   $0x8010a460,0x4(%esp)
801037b5:	80 
801037b6:	e8 55 2f 00 00       	call   80106710 <inituvm>
  p->sz = PGSIZE;
801037bb:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
801037c1:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
801037c8:	00 
801037c9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801037d0:	00 
801037d1:	8b 43 18             	mov    0x18(%ebx),%eax
801037d4:	89 04 24             	mov    %eax,(%esp)
801037d7:	e8 54 0b 00 00       	call   80104330 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801037dc:	8b 43 18             	mov    0x18(%ebx),%eax
801037df:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801037e5:	8b 43 18             	mov    0x18(%ebx),%eax
801037e8:	66 c7 40 2c 23 00    	movw   $0x23,0x2c(%eax)
  p->tf->es = p->tf->ds;
801037ee:	8b 43 18             	mov    0x18(%ebx),%eax
801037f1:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801037f5:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
801037f9:	8b 43 18             	mov    0x18(%ebx),%eax
801037fc:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103800:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103804:	8b 43 18             	mov    0x18(%ebx),%eax
80103807:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
8010380e:	8b 43 18             	mov    0x18(%ebx),%eax
80103811:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103818:	8b 43 18             	mov    0x18(%ebx),%eax
8010381b:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
80103822:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103825:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
8010382c:	00 
8010382d:	c7 44 24 04 95 72 10 	movl   $0x80107295,0x4(%esp)
80103834:	80 
80103835:	89 04 24             	mov    %eax,(%esp)
80103838:	e8 e3 0c 00 00       	call   80104520 <safestrcpy>
  p->cwd = namei("/");
8010383d:	c7 04 24 9e 72 10 80 	movl   $0x8010729e,(%esp)
80103844:	e8 47 e7 ff ff       	call   80101f90 <namei>
80103849:	89 43 68             	mov    %eax,0x68(%ebx)

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);
8010384c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103853:	e8 a8 09 00 00       	call   80104200 <acquire>

  p->state = RUNNABLE;
80103858:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)

  release(&ptable.lock);
8010385f:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103866:	e8 75 0a 00 00       	call   801042e0 <release>
}
8010386b:	83 c4 14             	add    $0x14,%esp
8010386e:	5b                   	pop    %ebx
8010386f:	5d                   	pop    %ebp
80103870:	c3                   	ret    

  p = allocproc();
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
80103871:	c7 04 24 7c 72 10 80 	movl   $0x8010727c,(%esp)
80103878:	e8 f3 ca ff ff       	call   80100370 <panic>
8010387d:	8d 76 00             	lea    0x0(%esi),%esi

80103880 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
80103880:	55                   	push   %ebp
80103881:	89 e5                	mov    %esp,%ebp
80103883:	83 ec 18             	sub    $0x18,%esp
80103886:	89 5d f8             	mov    %ebx,-0x8(%ebp)
80103889:	89 75 fc             	mov    %esi,-0x4(%ebp)
8010388c:	8b 75 08             	mov    0x8(%ebp),%esi
  uint sz;
  struct proc *curproc = myproc();
8010388f:	e8 bc fe ff ff       	call   80103750 <myproc>

  sz = curproc->sz;
  if(n > 0){
80103894:	83 fe 00             	cmp    $0x0,%esi
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
  uint sz;
  struct proc *curproc = myproc();
80103897:	89 c3                	mov    %eax,%ebx

  sz = curproc->sz;
80103899:	8b 10                	mov    (%eax),%edx
  if(n > 0){
8010389b:	7e 3b                	jle    801038d8 <growproc+0x58>
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
8010389d:	01 d6                	add    %edx,%esi
8010389f:	89 54 24 04          	mov    %edx,0x4(%esp)
801038a3:	89 74 24 08          	mov    %esi,0x8(%esp)
801038a7:	8b 40 04             	mov    0x4(%eax),%eax
801038aa:	89 04 24             	mov    %eax,(%esp)
801038ad:	e8 4e 30 00 00       	call   80106900 <allocuvm>
801038b2:	89 c2                	mov    %eax,%edx
      return -1;
801038b4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  uint sz;
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
801038b9:	85 d2                	test   %edx,%edx
801038bb:	74 0c                	je     801038c9 <growproc+0x49>
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
801038bd:	89 13                	mov    %edx,(%ebx)
  switchuvm(curproc);
801038bf:	89 1c 24             	mov    %ebx,(%esp)
801038c2:	e8 49 2d 00 00       	call   80106610 <switchuvm>
  return 0;
801038c7:	31 c0                	xor    %eax,%eax
}
801038c9:	8b 5d f8             	mov    -0x8(%ebp),%ebx
801038cc:	8b 75 fc             	mov    -0x4(%ebp),%esi
801038cf:	89 ec                	mov    %ebp,%esp
801038d1:	5d                   	pop    %ebp
801038d2:	c3                   	ret    
801038d3:	90                   	nop
801038d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
801038d8:	74 e3                	je     801038bd <growproc+0x3d>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
801038da:	01 d6                	add    %edx,%esi
801038dc:	89 54 24 04          	mov    %edx,0x4(%esp)
801038e0:	89 74 24 08          	mov    %esi,0x8(%esp)
801038e4:	8b 40 04             	mov    0x4(%eax),%eax
801038e7:	89 04 24             	mov    %eax,(%esp)
801038ea:	e8 71 2f 00 00       	call   80106860 <deallocuvm>
801038ef:	89 c2                	mov    %eax,%edx
      return -1;
801038f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
801038f6:	85 d2                	test   %edx,%edx
801038f8:	75 c3                	jne    801038bd <growproc+0x3d>
801038fa:	eb cd                	jmp    801038c9 <growproc+0x49>
801038fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103900 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
80103900:	55                   	push   %ebp
80103901:	89 e5                	mov    %esp,%ebp
80103903:	57                   	push   %edi
80103904:	56                   	push   %esi
80103905:	53                   	push   %ebx
80103906:	83 ec 2c             	sub    $0x2c,%esp
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();
80103909:	e8 42 fe ff ff       	call   80103750 <myproc>
8010390e:	89 c3                	mov    %eax,%ebx

  // Allocate process.
  if((np = allocproc()) == 0){
80103910:	e8 4b fc ff ff       	call   80103560 <allocproc>
80103915:	85 c0                	test   %eax,%eax
80103917:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010391a:	0f 84 c6 00 00 00    	je     801039e6 <fork+0xe6>
    return -1;
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103920:	8b 03                	mov    (%ebx),%eax
80103922:	89 44 24 04          	mov    %eax,0x4(%esp)
80103926:	8b 43 04             	mov    0x4(%ebx),%eax
80103929:	89 04 24             	mov    %eax,(%esp)
8010392c:	e8 4f 32 00 00       	call   80106b80 <copyuvm>
80103931:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103934:	85 c0                	test   %eax,%eax
80103936:	89 42 04             	mov    %eax,0x4(%edx)
80103939:	0f 84 ae 00 00 00    	je     801039ed <fork+0xed>
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
8010393f:	8b 03                	mov    (%ebx),%eax
  np->parent = curproc;
  *np->tf = *curproc->tf;
80103941:	b9 13 00 00 00       	mov    $0x13,%ecx
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
80103946:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103949:	89 02                	mov    %eax,(%edx)
  np->parent = curproc;
  *np->tf = *curproc->tf;
8010394b:	8b 42 18             	mov    0x18(%edx),%eax
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
  np->parent = curproc;
8010394e:	89 5a 14             	mov    %ebx,0x14(%edx)
  *np->tf = *curproc->tf;
80103951:	8b 73 18             	mov    0x18(%ebx),%esi
80103954:	89 c7                	mov    %eax,%edi
80103956:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80103958:	31 f6                	xor    %esi,%esi
  np->sz = curproc->sz;
  np->parent = curproc;
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
8010395a:	8b 42 18             	mov    0x18(%edx),%eax
8010395d:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
80103964:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
80103968:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
8010396c:	85 c0                	test   %eax,%eax
8010396e:	74 0f                	je     8010397f <fork+0x7f>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103970:	89 04 24             	mov    %eax,(%esp)
80103973:	e8 58 d4 ff ff       	call   80100dd0 <filedup>
80103978:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010397b:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
8010397f:	83 c6 01             	add    $0x1,%esi
80103982:	83 fe 10             	cmp    $0x10,%esi
80103985:	75 e1                	jne    80103968 <fork+0x68>
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
80103987:	8b 43 68             	mov    0x68(%ebx),%eax

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010398a:	83 c3 6c             	add    $0x6c,%ebx
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
8010398d:	89 04 24             	mov    %eax,(%esp)
80103990:	e8 fb dc ff ff       	call   80101690 <idup>
80103995:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103998:	89 42 68             	mov    %eax,0x68(%edx)

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010399b:	89 d0                	mov    %edx,%eax
8010399d:	83 c0 6c             	add    $0x6c,%eax
801039a0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801039a4:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
801039ab:	00 
801039ac:	89 04 24             	mov    %eax,(%esp)
801039af:	e8 6c 0b 00 00       	call   80104520 <safestrcpy>

  pid = np->pid;
801039b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801039b7:	8b 58 10             	mov    0x10(%eax),%ebx

  acquire(&ptable.lock);
801039ba:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801039c1:	e8 3a 08 00 00       	call   80104200 <acquire>

  np->state = RUNNABLE;
801039c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801039c9:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)

  release(&ptable.lock);
801039d0:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801039d7:	e8 04 09 00 00       	call   801042e0 <release>

  return pid;
}
801039dc:	83 c4 2c             	add    $0x2c,%esp
801039df:	89 d8                	mov    %ebx,%eax
801039e1:	5b                   	pop    %ebx
801039e2:	5e                   	pop    %esi
801039e3:	5f                   	pop    %edi
801039e4:	5d                   	pop    %ebp
801039e5:	c3                   	ret    
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
801039e6:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801039eb:	eb ef                	jmp    801039dc <fork+0xdc>
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
    kfree(np->kstack);
801039ed:	8b 42 08             	mov    0x8(%edx),%eax
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
801039f0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
    return -1;
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
    kfree(np->kstack);
801039f5:	89 04 24             	mov    %eax,(%esp)
801039f8:	e8 63 e9 ff ff       	call   80102360 <kfree>
    np->kstack = 0;
801039fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103a00:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    np->state = UNUSED;
80103a07:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return -1;
80103a0e:	eb cc                	jmp    801039dc <fork+0xdc>

80103a10 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
80103a10:	55                   	push   %ebp
80103a11:	89 e5                	mov    %esp,%ebp
80103a13:	57                   	push   %edi
80103a14:	56                   	push   %esi
80103a15:	53                   	push   %ebx
80103a16:	83 ec 1c             	sub    $0x1c,%esp
  struct proc *p;
  struct cpu *c = mycpu();
80103a19:	e8 92 fc ff ff       	call   801036b0 <mycpu>
80103a1e:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103a20:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103a27:	00 00 00 
80103a2a:	8d 78 04             	lea    0x4(%eax),%edi
80103a2d:	8d 76 00             	lea    0x0(%esi),%esi
}

static inline void
sti(void)
{
  asm volatile("sti");
80103a30:	fb                   	sti    
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a31:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80103a36:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103a3d:	e8 be 07 00 00       	call   80104200 <acquire>
80103a42:	eb 0f                	jmp    80103a53 <scheduler+0x43>
80103a44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a48:	83 c3 7c             	add    $0x7c,%ebx
80103a4b:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
80103a51:	73 45                	jae    80103a98 <scheduler+0x88>
      if(p->state != RUNNABLE)
80103a53:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103a57:	75 ef                	jne    80103a48 <scheduler+0x38>
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
80103a59:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103a5f:	89 1c 24             	mov    %ebx,(%esp)
80103a62:	e8 a9 2b 00 00       	call   80106610 <switchuvm>
      p->state = RUNNING;

      swtch(&(c->scheduler), p->context);
80103a67:	8b 43 1c             	mov    0x1c(%ebx),%eax
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
      p->state = RUNNING;
80103a6a:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a71:	83 c3 7c             	add    $0x7c,%ebx
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
      p->state = RUNNING;

      swtch(&(c->scheduler), p->context);
80103a74:	89 3c 24             	mov    %edi,(%esp)
80103a77:	89 44 24 04          	mov    %eax,0x4(%esp)
80103a7b:	e8 fc 0a 00 00       	call   8010457c <swtch>
      switchkvm();
80103a80:	e8 6b 2b 00 00       	call   801065f0 <switchkvm>
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a85:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
      swtch(&(c->scheduler), p->context);
      switchkvm();

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
80103a8b:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103a92:	00 00 00 
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a95:	72 bc                	jb     80103a53 <scheduler+0x43>
80103a97:	90                   	nop

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
    }
    release(&ptable.lock);
80103a98:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103a9f:	e8 3c 08 00 00       	call   801042e0 <release>

  }
80103aa4:	eb 8a                	jmp    80103a30 <scheduler+0x20>
80103aa6:	8d 76 00             	lea    0x0(%esi),%esi
80103aa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103ab0 <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
80103ab0:	55                   	push   %ebp
80103ab1:	89 e5                	mov    %esp,%ebp
80103ab3:	56                   	push   %esi
80103ab4:	53                   	push   %ebx
80103ab5:	83 ec 10             	sub    $0x10,%esp
  int intena;
  struct proc *p = myproc();
80103ab8:	e8 93 fc ff ff       	call   80103750 <myproc>

  if(!holding(&ptable.lock))
80103abd:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
// there's no process.
void
sched(void)
{
  int intena;
  struct proc *p = myproc();
80103ac4:	89 c3                	mov    %eax,%ebx

  if(!holding(&ptable.lock))
80103ac6:	e8 c5 06 00 00       	call   80104190 <holding>
80103acb:	85 c0                	test   %eax,%eax
80103acd:	74 4f                	je     80103b1e <sched+0x6e>
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
80103acf:	e8 dc fb ff ff       	call   801036b0 <mycpu>
80103ad4:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103adb:	75 65                	jne    80103b42 <sched+0x92>
    panic("sched locks");
  if(p->state == RUNNING)
80103add:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103ae1:	74 53                	je     80103b36 <sched+0x86>

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103ae3:	9c                   	pushf  
80103ae4:	58                   	pop    %eax
    panic("sched running");
  if(readeflags()&FL_IF)
80103ae5:	f6 c4 02             	test   $0x2,%ah
80103ae8:	75 40                	jne    80103b2a <sched+0x7a>
    panic("sched interruptible");
  intena = mycpu()->intena;
80103aea:	e8 c1 fb ff ff       	call   801036b0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103aef:	83 c3 1c             	add    $0x1c,%ebx
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
80103af2:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103af8:	e8 b3 fb ff ff       	call   801036b0 <mycpu>
80103afd:	8b 40 04             	mov    0x4(%eax),%eax
80103b00:	89 1c 24             	mov    %ebx,(%esp)
80103b03:	89 44 24 04          	mov    %eax,0x4(%esp)
80103b07:	e8 70 0a 00 00       	call   8010457c <swtch>
  mycpu()->intena = intena;
80103b0c:	e8 9f fb ff ff       	call   801036b0 <mycpu>
80103b11:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103b17:	83 c4 10             	add    $0x10,%esp
80103b1a:	5b                   	pop    %ebx
80103b1b:	5e                   	pop    %esi
80103b1c:	5d                   	pop    %ebp
80103b1d:	c3                   	ret    
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
80103b1e:	c7 04 24 a0 72 10 80 	movl   $0x801072a0,(%esp)
80103b25:	e8 46 c8 ff ff       	call   80100370 <panic>
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
80103b2a:	c7 04 24 cc 72 10 80 	movl   $0x801072cc,(%esp)
80103b31:	e8 3a c8 ff ff       	call   80100370 <panic>
  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
80103b36:	c7 04 24 be 72 10 80 	movl   $0x801072be,(%esp)
80103b3d:	e8 2e c8 ff ff       	call   80100370 <panic>
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
80103b42:	c7 04 24 b2 72 10 80 	movl   $0x801072b2,(%esp)
80103b49:	e8 22 c8 ff ff       	call   80100370 <panic>
80103b4e:	66 90                	xchg   %ax,%ax

80103b50 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80103b50:	55                   	push   %ebp
80103b51:	89 e5                	mov    %esp,%ebp
80103b53:	56                   	push   %esi
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
80103b54:	31 f6                	xor    %esi,%esi
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80103b56:	53                   	push   %ebx
80103b57:	83 ec 10             	sub    $0x10,%esp
  struct proc *curproc = myproc();
80103b5a:	e8 f1 fb ff ff       	call   80103750 <myproc>
  struct proc *p;
  int fd;

  if(curproc == initproc)
80103b5f:	3b 05 a0 a5 10 80    	cmp    0x8010a5a0,%eax
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
  struct proc *curproc = myproc();
80103b65:	89 c3                	mov    %eax,%ebx
  struct proc *p;
  int fd;

  if(curproc == initproc)
80103b67:	0f 84 ea 00 00 00    	je     80103c57 <exit+0x107>
80103b6d:	8d 76 00             	lea    0x0(%esi),%esi
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd]){
80103b70:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103b74:	85 c0                	test   %eax,%eax
80103b76:	74 10                	je     80103b88 <exit+0x38>
      fileclose(curproc->ofile[fd]);
80103b78:	89 04 24             	mov    %eax,(%esp)
80103b7b:	e8 a0 d2 ff ff       	call   80100e20 <fileclose>
      curproc->ofile[fd] = 0;
80103b80:	c7 44 b3 28 00 00 00 	movl   $0x0,0x28(%ebx,%esi,4)
80103b87:	00 

  if(curproc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80103b88:	83 c6 01             	add    $0x1,%esi
80103b8b:	83 fe 10             	cmp    $0x10,%esi
80103b8e:	75 e0                	jne    80103b70 <exit+0x20>
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }

  begin_op();
80103b90:	e8 fb ef ff ff       	call   80102b90 <begin_op>
  iput(curproc->cwd);
80103b95:	8b 43 68             	mov    0x68(%ebx),%eax
80103b98:	89 04 24             	mov    %eax,(%esp)
80103b9b:	e8 50 dc ff ff       	call   801017f0 <iput>
  end_op();
80103ba0:	e8 5b f0 ff ff       	call   80102c00 <end_op>
  curproc->cwd = 0;
80103ba5:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)

  acquire(&ptable.lock);
80103bac:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103bb3:	e8 48 06 00 00       	call   80104200 <acquire>

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);
80103bb8:	8b 43 14             	mov    0x14(%ebx),%eax
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103bbb:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103bc0:	eb 11                	jmp    80103bd3 <exit+0x83>
80103bc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103bc8:	83 c2 7c             	add    $0x7c,%edx
80103bcb:	81 fa 54 4c 11 80    	cmp    $0x80114c54,%edx
80103bd1:	73 1d                	jae    80103bf0 <exit+0xa0>
    if(p->state == SLEEPING && p->chan == chan)
80103bd3:	83 7a 0c 02          	cmpl   $0x2,0xc(%edx)
80103bd7:	75 ef                	jne    80103bc8 <exit+0x78>
80103bd9:	3b 42 20             	cmp    0x20(%edx),%eax
80103bdc:	75 ea                	jne    80103bc8 <exit+0x78>
      p->state = RUNNABLE;
80103bde:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103be5:	83 c2 7c             	add    $0x7c,%edx
80103be8:	81 fa 54 4c 11 80    	cmp    $0x80114c54,%edx
80103bee:	72 e3                	jb     80103bd3 <exit+0x83>
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
80103bf0:	a1 a0 a5 10 80       	mov    0x8010a5a0,%eax
80103bf5:	b9 54 2d 11 80       	mov    $0x80112d54,%ecx
80103bfa:	eb 0f                	jmp    80103c0b <exit+0xbb>
80103bfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103c00:	83 c1 7c             	add    $0x7c,%ecx
80103c03:	81 f9 54 4c 11 80    	cmp    $0x80114c54,%ecx
80103c09:	73 34                	jae    80103c3f <exit+0xef>
    if(p->parent == curproc){
80103c0b:	39 59 14             	cmp    %ebx,0x14(%ecx)
80103c0e:	75 f0                	jne    80103c00 <exit+0xb0>
      p->parent = initproc;
      if(p->state == ZOMBIE)
80103c10:	83 79 0c 05          	cmpl   $0x5,0xc(%ecx)
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
80103c14:	89 41 14             	mov    %eax,0x14(%ecx)
      if(p->state == ZOMBIE)
80103c17:	75 e7                	jne    80103c00 <exit+0xb0>
80103c19:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103c1e:	eb 0b                	jmp    80103c2b <exit+0xdb>
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103c20:	83 c2 7c             	add    $0x7c,%edx
80103c23:	81 fa 54 4c 11 80    	cmp    $0x80114c54,%edx
80103c29:	73 d5                	jae    80103c00 <exit+0xb0>
    if(p->state == SLEEPING && p->chan == chan)
80103c2b:	83 7a 0c 02          	cmpl   $0x2,0xc(%edx)
80103c2f:	75 ef                	jne    80103c20 <exit+0xd0>
80103c31:	3b 42 20             	cmp    0x20(%edx),%eax
80103c34:	75 ea                	jne    80103c20 <exit+0xd0>
      p->state = RUNNABLE;
80103c36:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
80103c3d:	eb e1                	jmp    80103c20 <exit+0xd0>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
80103c3f:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
80103c46:	e8 65 fe ff ff       	call   80103ab0 <sched>
  panic("zombie exit");
80103c4b:	c7 04 24 ed 72 10 80 	movl   $0x801072ed,(%esp)
80103c52:	e8 19 c7 ff ff       	call   80100370 <panic>
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
    panic("init exiting");
80103c57:	c7 04 24 e0 72 10 80 	movl   $0x801072e0,(%esp)
80103c5e:	e8 0d c7 ff ff       	call   80100370 <panic>
80103c63:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103c69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103c70 <yield>:
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
80103c70:	55                   	push   %ebp
80103c71:	89 e5                	mov    %esp,%ebp
80103c73:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103c76:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103c7d:	e8 7e 05 00 00       	call   80104200 <acquire>
  myproc()->state = RUNNABLE;
80103c82:	e8 c9 fa ff ff       	call   80103750 <myproc>
80103c87:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
80103c8e:	e8 1d fe ff ff       	call   80103ab0 <sched>
  release(&ptable.lock);
80103c93:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103c9a:	e8 41 06 00 00       	call   801042e0 <release>
}
80103c9f:	c9                   	leave  
80103ca0:	c3                   	ret    
80103ca1:	eb 0d                	jmp    80103cb0 <sleep>
80103ca3:	90                   	nop
80103ca4:	90                   	nop
80103ca5:	90                   	nop
80103ca6:	90                   	nop
80103ca7:	90                   	nop
80103ca8:	90                   	nop
80103ca9:	90                   	nop
80103caa:	90                   	nop
80103cab:	90                   	nop
80103cac:	90                   	nop
80103cad:	90                   	nop
80103cae:	90                   	nop
80103caf:	90                   	nop

80103cb0 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80103cb0:	55                   	push   %ebp
80103cb1:	89 e5                	mov    %esp,%ebp
80103cb3:	83 ec 28             	sub    $0x28,%esp
80103cb6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
80103cb9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80103cbc:	89 75 f8             	mov    %esi,-0x8(%ebp)
80103cbf:	8b 75 08             	mov    0x8(%ebp),%esi
80103cc2:	89 7d fc             	mov    %edi,-0x4(%ebp)
  struct proc *p = myproc();
80103cc5:	e8 86 fa ff ff       	call   80103750 <myproc>
  
  if(p == 0)
80103cca:	85 c0                	test   %eax,%eax
// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
80103ccc:	89 c7                	mov    %eax,%edi
  
  if(p == 0)
80103cce:	0f 84 8b 00 00 00    	je     80103d5f <sleep+0xaf>
    panic("sleep");

  if(lk == 0)
80103cd4:	85 db                	test   %ebx,%ebx
80103cd6:	74 7b                	je     80103d53 <sleep+0xa3>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103cd8:	81 fb 20 2d 11 80    	cmp    $0x80112d20,%ebx
80103cde:	74 50                	je     80103d30 <sleep+0x80>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103ce0:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103ce7:	e8 14 05 00 00       	call   80104200 <acquire>
    release(lk);
80103cec:	89 1c 24             	mov    %ebx,(%esp)
80103cef:	e8 ec 05 00 00       	call   801042e0 <release>
  }
  // Go to sleep.
  p->chan = chan;
80103cf4:	89 77 20             	mov    %esi,0x20(%edi)
  p->state = SLEEPING;
80103cf7:	c7 47 0c 02 00 00 00 	movl   $0x2,0xc(%edi)

  sched();
80103cfe:	e8 ad fd ff ff       	call   80103ab0 <sched>

  // Tidy up.
  p->chan = 0;
80103d03:	c7 47 20 00 00 00 00 	movl   $0x0,0x20(%edi)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
80103d0a:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103d11:	e8 ca 05 00 00       	call   801042e0 <release>
    acquire(lk);
  }
}
80103d16:	8b 75 f8             	mov    -0x8(%ebp),%esi
  p->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
80103d19:	89 5d 08             	mov    %ebx,0x8(%ebp)
  }
}
80103d1c:	8b 7d fc             	mov    -0x4(%ebp),%edi
80103d1f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80103d22:	89 ec                	mov    %ebp,%esp
80103d24:	5d                   	pop    %ebp
  p->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
80103d25:	e9 d6 04 00 00       	jmp    80104200 <acquire>
80103d2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(lk != &ptable.lock){  //DOC: sleeplock0
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }
  // Go to sleep.
  p->chan = chan;
80103d30:	89 70 20             	mov    %esi,0x20(%eax)
  p->state = SLEEPING;
80103d33:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)

  sched();
80103d3a:	e8 71 fd ff ff       	call   80103ab0 <sched>

  // Tidy up.
  p->chan = 0;
80103d3f:	c7 47 20 00 00 00 00 	movl   $0x0,0x20(%edi)
  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}
80103d46:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80103d49:	8b 75 f8             	mov    -0x8(%ebp),%esi
80103d4c:	8b 7d fc             	mov    -0x4(%ebp),%edi
80103d4f:	89 ec                	mov    %ebp,%esp
80103d51:	5d                   	pop    %ebp
80103d52:	c3                   	ret    
  
  if(p == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");
80103d53:	c7 04 24 ff 72 10 80 	movl   $0x801072ff,(%esp)
80103d5a:	e8 11 c6 ff ff       	call   80100370 <panic>
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
    panic("sleep");
80103d5f:	c7 04 24 f9 72 10 80 	movl   $0x801072f9,(%esp)
80103d66:	e8 05 c6 ff ff       	call   80100370 <panic>
80103d6b:	90                   	nop
80103d6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103d70 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80103d70:	55                   	push   %ebp
80103d71:	89 e5                	mov    %esp,%ebp
80103d73:	56                   	push   %esi
80103d74:	53                   	push   %ebx
80103d75:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
80103d78:	e8 d3 f9 ff ff       	call   80103750 <myproc>
  
  acquire(&ptable.lock);
80103d7d:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
int
wait(void)
{
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
80103d84:	89 c6                	mov    %eax,%esi
  
  acquire(&ptable.lock);
80103d86:	e8 75 04 00 00       	call   80104200 <acquire>
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
80103d8b:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d8d:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80103d92:	eb 0f                	jmp    80103da3 <wait+0x33>
80103d94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103d98:	83 c3 7c             	add    $0x7c,%ebx
80103d9b:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
80103da1:	73 1d                	jae    80103dc0 <wait+0x50>
      if(p->parent != curproc)
80103da3:	39 73 14             	cmp    %esi,0x14(%ebx)
80103da6:	75 f0                	jne    80103d98 <wait+0x28>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
80103da8:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103dac:	74 2f                	je     80103ddd <wait+0x6d>
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103dae:	83 c3 7c             	add    $0x7c,%ebx
      if(p->parent != curproc)
        continue;
      havekids = 1;
80103db1:	b8 01 00 00 00       	mov    $0x1,%eax
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103db6:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
80103dbc:	72 e5                	jb     80103da3 <wait+0x33>
80103dbe:	66 90                	xchg   %ax,%ax
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
80103dc0:	85 c0                	test   %eax,%eax
80103dc2:	74 6e                	je     80103e32 <wait+0xc2>
80103dc4:	8b 5e 24             	mov    0x24(%esi),%ebx
80103dc7:	85 db                	test   %ebx,%ebx
80103dc9:	75 67                	jne    80103e32 <wait+0xc2>
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80103dcb:	c7 44 24 04 20 2d 11 	movl   $0x80112d20,0x4(%esp)
80103dd2:	80 
80103dd3:	89 34 24             	mov    %esi,(%esp)
80103dd6:	e8 d5 fe ff ff       	call   80103cb0 <sleep>
  }
80103ddb:	eb ae                	jmp    80103d8b <wait+0x1b>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
80103ddd:	8b 43 08             	mov    0x8(%ebx),%eax
      if(p->parent != curproc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
80103de0:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80103de3:	89 04 24             	mov    %eax,(%esp)
80103de6:	e8 75 e5 ff ff       	call   80102360 <kfree>
        p->kstack = 0;
        freevm(p->pgdir);
80103deb:	8b 43 04             	mov    0x4(%ebx),%eax
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
80103dee:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80103df5:	89 04 24             	mov    %eax,(%esp)
80103df8:	e8 33 2c 00 00       	call   80106a30 <freevm>
        p->pid = 0;
80103dfd:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80103e04:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80103e0b:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80103e0f:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80103e16:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80103e1d:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103e24:	e8 b7 04 00 00       	call   801042e0 <release>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103e29:	83 c4 10             	add    $0x10,%esp
80103e2c:	89 f0                	mov    %esi,%eax
80103e2e:	5b                   	pop    %ebx
80103e2f:	5e                   	pop    %esi
80103e30:	5d                   	pop    %ebp
80103e31:	c3                   	ret    
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
80103e32:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
      return -1;
80103e39:	be ff ff ff ff       	mov    $0xffffffff,%esi
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
80103e3e:	e8 9d 04 00 00       	call   801042e0 <release>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103e43:	83 c4 10             	add    $0x10,%esp
80103e46:	89 f0                	mov    %esi,%eax
80103e48:	5b                   	pop    %ebx
80103e49:	5e                   	pop    %esi
80103e4a:	5d                   	pop    %ebp
80103e4b:	c3                   	ret    
80103e4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103e50 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80103e50:	55                   	push   %ebp
80103e51:	89 e5                	mov    %esp,%ebp
80103e53:	53                   	push   %ebx
80103e54:	83 ec 14             	sub    $0x14,%esp
80103e57:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80103e5a:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103e61:	e8 9a 03 00 00       	call   80104200 <acquire>
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e66:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103e6b:	eb 0d                	jmp    80103e7a <wakeup+0x2a>
80103e6d:	8d 76 00             	lea    0x0(%esi),%esi
80103e70:	83 c0 7c             	add    $0x7c,%eax
80103e73:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80103e78:	73 1e                	jae    80103e98 <wakeup+0x48>
    if(p->state == SLEEPING && p->chan == chan)
80103e7a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103e7e:	75 f0                	jne    80103e70 <wakeup+0x20>
80103e80:	3b 58 20             	cmp    0x20(%eax),%ebx
80103e83:	75 eb                	jne    80103e70 <wakeup+0x20>
      p->state = RUNNABLE;
80103e85:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e8c:	83 c0 7c             	add    $0x7c,%eax
80103e8f:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80103e94:	72 e4                	jb     80103e7a <wakeup+0x2a>
80103e96:	66 90                	xchg   %ax,%ax
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
80103e98:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
80103e9f:	83 c4 14             	add    $0x14,%esp
80103ea2:	5b                   	pop    %ebx
80103ea3:	5d                   	pop    %ebp
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
80103ea4:	e9 37 04 00 00       	jmp    801042e0 <release>
80103ea9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103eb0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80103eb0:	55                   	push   %ebp
80103eb1:	89 e5                	mov    %esp,%ebp
80103eb3:	53                   	push   %ebx
80103eb4:	83 ec 14             	sub    $0x14,%esp
80103eb7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80103eba:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103ec1:	e8 3a 03 00 00       	call   80104200 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ec6:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
    if(p->pid == pid){
80103ecb:	39 1d 64 2d 11 80    	cmp    %ebx,0x80112d64
80103ed1:	74 14                	je     80103ee7 <kill+0x37>
80103ed3:	90                   	nop
80103ed4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ed8:	83 c0 7c             	add    $0x7c,%eax
80103edb:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80103ee0:	73 36                	jae    80103f18 <kill+0x68>
    if(p->pid == pid){
80103ee2:	39 58 10             	cmp    %ebx,0x10(%eax)
80103ee5:	75 f1                	jne    80103ed8 <kill+0x28>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80103ee7:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
80103eeb:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80103ef2:	74 14                	je     80103f08 <kill+0x58>
        p->state = RUNNABLE;
      release(&ptable.lock);
80103ef4:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103efb:	e8 e0 03 00 00       	call   801042e0 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80103f00:	83 c4 14             	add    $0x14,%esp
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
80103f03:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80103f05:	5b                   	pop    %ebx
80103f06:	5d                   	pop    %ebp
80103f07:	c3                   	ret    
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
80103f08:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103f0f:	eb e3                	jmp    80103ef4 <kill+0x44>
80103f11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
80103f18:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103f1f:	e8 bc 03 00 00       	call   801042e0 <release>
  return -1;
}
80103f24:	83 c4 14             	add    $0x14,%esp
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
80103f27:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103f2c:	5b                   	pop    %ebx
80103f2d:	5d                   	pop    %ebp
80103f2e:	c3                   	ret    
80103f2f:	90                   	nop

80103f30 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80103f30:	55                   	push   %ebp
80103f31:	89 e5                	mov    %esp,%ebp
80103f33:	57                   	push   %edi
80103f34:	56                   	push   %esi
80103f35:	53                   	push   %ebx
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f36:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80103f3b:	83 ec 4c             	sub    $0x4c,%esp
//PAGEBREAK: 36
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
80103f3e:	8d 7d e8             	lea    -0x18(%ebp),%edi
80103f41:	eb 20                	jmp    80103f63 <procdump+0x33>
80103f43:	90                   	nop
80103f44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80103f48:	c7 04 24 77 76 10 80 	movl   $0x80107677,(%esp)
80103f4f:	e8 fc c6 ff ff       	call   80100650 <cprintf>
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f54:	83 c3 7c             	add    $0x7c,%ebx
80103f57:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
80103f5d:	0f 83 8d 00 00 00    	jae    80103ff0 <procdump+0xc0>
    if(p->state == UNUSED)
80103f63:	8b 43 0c             	mov    0xc(%ebx),%eax
80103f66:	85 c0                	test   %eax,%eax
80103f68:	74 ea                	je     80103f54 <procdump+0x24>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103f6a:	83 f8 05             	cmp    $0x5,%eax
      state = states[p->state];
    else
      state = "???";
80103f6d:	ba 10 73 10 80       	mov    $0x80107310,%edx
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103f72:	77 11                	ja     80103f85 <procdump+0x55>
80103f74:	8b 14 85 70 73 10 80 	mov    -0x7fef8c90(,%eax,4),%edx
      state = states[p->state];
    else
      state = "???";
80103f7b:	b8 10 73 10 80       	mov    $0x80107310,%eax
80103f80:	85 d2                	test   %edx,%edx
80103f82:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80103f85:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103f88:	89 44 24 0c          	mov    %eax,0xc(%esp)
80103f8c:	8b 43 10             	mov    0x10(%ebx),%eax
80103f8f:	89 54 24 08          	mov    %edx,0x8(%esp)
80103f93:	c7 04 24 14 73 10 80 	movl   $0x80107314,(%esp)
80103f9a:	89 44 24 04          	mov    %eax,0x4(%esp)
80103f9e:	e8 ad c6 ff ff       	call   80100650 <cprintf>
    if(p->state == SLEEPING){
80103fa3:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
80103fa7:	75 9f                	jne    80103f48 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80103fa9:	8d 45 c0             	lea    -0x40(%ebp),%eax
80103fac:	89 44 24 04          	mov    %eax,0x4(%esp)
80103fb0:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103fb3:	8d 75 c0             	lea    -0x40(%ebp),%esi
80103fb6:	8b 40 0c             	mov    0xc(%eax),%eax
80103fb9:	83 c0 08             	add    $0x8,%eax
80103fbc:	89 04 24             	mov    %eax,(%esp)
80103fbf:	e8 6c 01 00 00       	call   80104130 <getcallerpcs>
80103fc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
80103fc8:	8b 06                	mov    (%esi),%eax
80103fca:	85 c0                	test   %eax,%eax
80103fcc:	0f 84 76 ff ff ff    	je     80103f48 <procdump+0x18>
        cprintf(" %p", pc[i]);
80103fd2:	83 c6 04             	add    $0x4,%esi
80103fd5:	89 44 24 04          	mov    %eax,0x4(%esp)
80103fd9:	c7 04 24 61 6d 10 80 	movl   $0x80106d61,(%esp)
80103fe0:	e8 6b c6 ff ff       	call   80100650 <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
80103fe5:	39 fe                	cmp    %edi,%esi
80103fe7:	75 df                	jne    80103fc8 <procdump+0x98>
80103fe9:	e9 5a ff ff ff       	jmp    80103f48 <procdump+0x18>
80103fee:	66 90                	xchg   %ax,%ax
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
80103ff0:	83 c4 4c             	add    $0x4c,%esp
80103ff3:	5b                   	pop    %ebx
80103ff4:	5e                   	pop    %esi
80103ff5:	5f                   	pop    %edi
80103ff6:	5d                   	pop    %ebp
80103ff7:	c3                   	ret    
	...

80104000 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104000:	55                   	push   %ebp
80104001:	89 e5                	mov    %esp,%ebp
80104003:	53                   	push   %ebx
80104004:	83 ec 14             	sub    $0x14,%esp
80104007:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010400a:	c7 44 24 04 88 73 10 	movl   $0x80107388,0x4(%esp)
80104011:	80 
80104012:	8d 43 04             	lea    0x4(%ebx),%eax
80104015:	89 04 24             	mov    %eax,(%esp)
80104018:	e8 f3 00 00 00       	call   80104110 <initlock>
  lk->name = name;
8010401d:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80104020:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104026:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)

void
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
8010402d:	89 43 38             	mov    %eax,0x38(%ebx)
  lk->locked = 0;
  lk->pid = 0;
}
80104030:	83 c4 14             	add    $0x14,%esp
80104033:	5b                   	pop    %ebx
80104034:	5d                   	pop    %ebp
80104035:	c3                   	ret    
80104036:	8d 76 00             	lea    0x0(%esi),%esi
80104039:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104040 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104040:	55                   	push   %ebp
80104041:	89 e5                	mov    %esp,%ebp
80104043:	56                   	push   %esi
80104044:	53                   	push   %ebx
80104045:	83 ec 10             	sub    $0x10,%esp
80104048:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010404b:	8d 73 04             	lea    0x4(%ebx),%esi
8010404e:	89 34 24             	mov    %esi,(%esp)
80104051:	e8 aa 01 00 00       	call   80104200 <acquire>
  while (lk->locked) {
80104056:	8b 13                	mov    (%ebx),%edx
80104058:	85 d2                	test   %edx,%edx
8010405a:	74 16                	je     80104072 <acquiresleep+0x32>
8010405c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
80104060:	89 74 24 04          	mov    %esi,0x4(%esp)
80104064:	89 1c 24             	mov    %ebx,(%esp)
80104067:	e8 44 fc ff ff       	call   80103cb0 <sleep>

void
acquiresleep(struct sleeplock *lk)
{
  acquire(&lk->lk);
  while (lk->locked) {
8010406c:	8b 03                	mov    (%ebx),%eax
8010406e:	85 c0                	test   %eax,%eax
80104070:	75 ee                	jne    80104060 <acquiresleep+0x20>
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
80104072:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104078:	e8 d3 f6 ff ff       	call   80103750 <myproc>
8010407d:	8b 40 10             	mov    0x10(%eax),%eax
80104080:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104083:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104086:	83 c4 10             	add    $0x10,%esp
80104089:	5b                   	pop    %ebx
8010408a:	5e                   	pop    %esi
8010408b:	5d                   	pop    %ebp
  while (lk->locked) {
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
  lk->pid = myproc()->pid;
  release(&lk->lk);
8010408c:	e9 4f 02 00 00       	jmp    801042e0 <release>
80104091:	eb 0d                	jmp    801040a0 <releasesleep>
80104093:	90                   	nop
80104094:	90                   	nop
80104095:	90                   	nop
80104096:	90                   	nop
80104097:	90                   	nop
80104098:	90                   	nop
80104099:	90                   	nop
8010409a:	90                   	nop
8010409b:	90                   	nop
8010409c:	90                   	nop
8010409d:	90                   	nop
8010409e:	90                   	nop
8010409f:	90                   	nop

801040a0 <releasesleep>:
}

void
releasesleep(struct sleeplock *lk)
{
801040a0:	55                   	push   %ebp
801040a1:	89 e5                	mov    %esp,%ebp
801040a3:	83 ec 18             	sub    $0x18,%esp
801040a6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
801040a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801040ac:	89 75 fc             	mov    %esi,-0x4(%ebp)
  acquire(&lk->lk);
801040af:	8d 73 04             	lea    0x4(%ebx),%esi
801040b2:	89 34 24             	mov    %esi,(%esp)
801040b5:	e8 46 01 00 00       	call   80104200 <acquire>
  lk->locked = 0;
801040ba:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801040c0:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801040c7:	89 1c 24             	mov    %ebx,(%esp)
801040ca:	e8 81 fd ff ff       	call   80103e50 <wakeup>
  release(&lk->lk);
}
801040cf:	8b 5d f8             	mov    -0x8(%ebp),%ebx
{
  acquire(&lk->lk);
  lk->locked = 0;
  lk->pid = 0;
  wakeup(lk);
  release(&lk->lk);
801040d2:	89 75 08             	mov    %esi,0x8(%ebp)
}
801040d5:	8b 75 fc             	mov    -0x4(%ebp),%esi
801040d8:	89 ec                	mov    %ebp,%esp
801040da:	5d                   	pop    %ebp
{
  acquire(&lk->lk);
  lk->locked = 0;
  lk->pid = 0;
  wakeup(lk);
  release(&lk->lk);
801040db:	e9 00 02 00 00       	jmp    801042e0 <release>

801040e0 <holdingsleep>:
}

int
holdingsleep(struct sleeplock *lk)
{
801040e0:	55                   	push   %ebp
801040e1:	89 e5                	mov    %esp,%ebp
801040e3:	83 ec 18             	sub    $0x18,%esp
801040e6:	89 75 fc             	mov    %esi,-0x4(%ebp)
801040e9:	8b 75 08             	mov    0x8(%ebp),%esi
801040ec:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  int r;
  
  acquire(&lk->lk);
801040ef:	8d 5e 04             	lea    0x4(%esi),%ebx
801040f2:	89 1c 24             	mov    %ebx,(%esp)
801040f5:	e8 06 01 00 00       	call   80104200 <acquire>
  r = lk->locked;
801040fa:	8b 36                	mov    (%esi),%esi
  release(&lk->lk);
801040fc:	89 1c 24             	mov    %ebx,(%esp)
801040ff:	e8 dc 01 00 00       	call   801042e0 <release>
  return r;
}
80104104:	8b 5d f8             	mov    -0x8(%ebp),%ebx
80104107:	89 f0                	mov    %esi,%eax
80104109:	8b 75 fc             	mov    -0x4(%ebp),%esi
8010410c:	89 ec                	mov    %ebp,%esp
8010410e:	5d                   	pop    %ebp
8010410f:	c3                   	ret    

80104110 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104110:	55                   	push   %ebp
80104111:	89 e5                	mov    %esp,%ebp
80104113:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104116:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104119:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
  lk->name = name;
8010411f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
  lk->cpu = 0;
80104122:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104129:	5d                   	pop    %ebp
8010412a:	c3                   	ret    
8010412b:	90                   	nop
8010412c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104130 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104130:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104131:	31 c0                	xor    %eax,%eax
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104133:	89 e5                	mov    %esp,%ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104135:	8b 55 08             	mov    0x8(%ebp),%edx
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104138:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010413b:	53                   	push   %ebx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
8010413c:	83 ea 08             	sub    $0x8,%edx
8010413f:	90                   	nop
  for(i = 0; i < 10; i++){
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104140:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104146:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010414c:	77 1a                	ja     80104168 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010414e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104151:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104154:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
80104157:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104159:	83 f8 0a             	cmp    $0xa,%eax
8010415c:	75 e2                	jne    80104140 <getcallerpcs+0x10>
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010415e:	5b                   	pop    %ebx
8010415f:	5d                   	pop    %ebp
80104160:	c3                   	ret    
80104161:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
80104168:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
8010416f:	83 c0 01             	add    $0x1,%eax
80104172:	83 f8 0a             	cmp    $0xa,%eax
80104175:	74 e7                	je     8010415e <getcallerpcs+0x2e>
    pcs[i] = 0;
80104177:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
8010417e:	83 c0 01             	add    $0x1,%eax
80104181:	83 f8 0a             	cmp    $0xa,%eax
80104184:	75 e2                	jne    80104168 <getcallerpcs+0x38>
80104186:	eb d6                	jmp    8010415e <getcallerpcs+0x2e>
80104188:	90                   	nop
80104189:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104190 <holding>:
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104190:	55                   	push   %ebp
  return lock->locked && lock->cpu == mycpu();
80104191:	31 c0                	xor    %eax,%eax
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104193:	89 e5                	mov    %esp,%ebp
80104195:	53                   	push   %ebx
80104196:	83 ec 04             	sub    $0x4,%esp
80104199:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == mycpu();
8010419c:	8b 0a                	mov    (%edx),%ecx
8010419e:	85 c9                	test   %ecx,%ecx
801041a0:	75 06                	jne    801041a8 <holding+0x18>
}
801041a2:	83 c4 04             	add    $0x4,%esp
801041a5:	5b                   	pop    %ebx
801041a6:	5d                   	pop    %ebp
801041a7:	c3                   	ret    

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
801041a8:	8b 5a 08             	mov    0x8(%edx),%ebx
801041ab:	e8 00 f5 ff ff       	call   801036b0 <mycpu>
    pcs[i] = 0;
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
801041b0:	39 c3                	cmp    %eax,%ebx
{
  return lock->locked && lock->cpu == mycpu();
801041b2:	0f 94 c0             	sete   %al
}
801041b5:	83 c4 04             	add    $0x4,%esp

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
801041b8:	0f b6 c0             	movzbl %al,%eax
}
801041bb:	5b                   	pop    %ebx
801041bc:	5d                   	pop    %ebp
801041bd:	c3                   	ret    
801041be:	66 90                	xchg   %ax,%ax

801041c0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801041c0:	55                   	push   %ebp
801041c1:	89 e5                	mov    %esp,%ebp
801041c3:	53                   	push   %ebx
801041c4:	83 ec 04             	sub    $0x4,%esp
801041c7:	9c                   	pushf  
801041c8:	5b                   	pop    %ebx
}

static inline void
cli(void)
{
  asm volatile("cli");
801041c9:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
801041ca:	e8 e1 f4 ff ff       	call   801036b0 <mycpu>
801041cf:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801041d5:	85 c0                	test   %eax,%eax
801041d7:	75 11                	jne    801041ea <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
801041d9:	e8 d2 f4 ff ff       	call   801036b0 <mycpu>
801041de:	81 e3 00 02 00 00    	and    $0x200,%ebx
801041e4:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
801041ea:	e8 c1 f4 ff ff       	call   801036b0 <mycpu>
801041ef:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801041f6:	83 c4 04             	add    $0x4,%esp
801041f9:	5b                   	pop    %ebx
801041fa:	5d                   	pop    %ebp
801041fb:	c3                   	ret    
801041fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104200 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80104200:	55                   	push   %ebp
80104201:	89 e5                	mov    %esp,%ebp
80104203:	53                   	push   %ebx
80104204:	83 ec 14             	sub    $0x14,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104207:	e8 b4 ff ff ff       	call   801041c0 <pushcli>
  if(holding(lk))
8010420c:	8b 45 08             	mov    0x8(%ebp),%eax
8010420f:	89 04 24             	mov    %eax,(%esp)
80104212:	e8 79 ff ff ff       	call   80104190 <holding>
80104217:	85 c0                	test   %eax,%eax
80104219:	75 3c                	jne    80104257 <acquire+0x57>
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010421b:	b9 01 00 00 00       	mov    $0x1,%ecx
    panic("acquire");

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
80104220:	8b 55 08             	mov    0x8(%ebp),%edx
80104223:	89 c8                	mov    %ecx,%eax
80104225:	f0 87 02             	lock xchg %eax,(%edx)
80104228:	85 c0                	test   %eax,%eax
8010422a:	75 f4                	jne    80104220 <acquire+0x20>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
8010422c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
80104231:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104234:	e8 77 f4 ff ff       	call   801036b0 <mycpu>
80104239:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lk, lk->pcs);
8010423c:	8b 45 08             	mov    0x8(%ebp),%eax
8010423f:	83 c0 0c             	add    $0xc,%eax
80104242:	89 44 24 04          	mov    %eax,0x4(%esp)
80104246:	8d 45 08             	lea    0x8(%ebp),%eax
80104249:	89 04 24             	mov    %eax,(%esp)
8010424c:	e8 df fe ff ff       	call   80104130 <getcallerpcs>
}
80104251:	83 c4 14             	add    $0x14,%esp
80104254:	5b                   	pop    %ebx
80104255:	5d                   	pop    %ebp
80104256:	c3                   	ret    
void
acquire(struct spinlock *lk)
{
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
    panic("acquire");
80104257:	c7 04 24 93 73 10 80 	movl   $0x80107393,(%esp)
8010425e:	e8 0d c1 ff ff       	call   80100370 <panic>
80104263:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104269:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104270 <popcli>:
  mycpu()->ncli += 1;
}

void
popcli(void)
{
80104270:	55                   	push   %ebp
80104271:	89 e5                	mov    %esp,%ebp
80104273:	83 ec 18             	sub    $0x18,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104276:	9c                   	pushf  
80104277:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104278:	f6 c4 02             	test   $0x2,%ah
8010427b:	75 49                	jne    801042c6 <popcli+0x56>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010427d:	e8 2e f4 ff ff       	call   801036b0 <mycpu>
80104282:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104288:	83 ea 01             	sub    $0x1,%edx
8010428b:	85 d2                	test   %edx,%edx
8010428d:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
80104293:	78 25                	js     801042ba <popcli+0x4a>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104295:	e8 16 f4 ff ff       	call   801036b0 <mycpu>
8010429a:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801042a0:	85 c0                	test   %eax,%eax
801042a2:	74 04                	je     801042a8 <popcli+0x38>
    sti();
}
801042a4:	c9                   	leave  
801042a5:	c3                   	ret    
801042a6:	66 90                	xchg   %ax,%ax
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801042a8:	e8 03 f4 ff ff       	call   801036b0 <mycpu>
801042ad:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801042b3:	85 c0                	test   %eax,%eax
801042b5:	74 ed                	je     801042a4 <popcli+0x34>
}

static inline void
sti(void)
{
  asm volatile("sti");
801042b7:	fb                   	sti    
    sti();
}
801042b8:	c9                   	leave  
801042b9:	c3                   	ret    
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
    panic("popcli");
801042ba:	c7 04 24 b2 73 10 80 	movl   $0x801073b2,(%esp)
801042c1:	e8 aa c0 ff ff       	call   80100370 <panic>

void
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
801042c6:	c7 04 24 9b 73 10 80 	movl   $0x8010739b,(%esp)
801042cd:	e8 9e c0 ff ff       	call   80100370 <panic>
801042d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801042d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801042e0 <release>:
}

// Release the lock.
void
release(struct spinlock *lk)
{
801042e0:	55                   	push   %ebp
801042e1:	89 e5                	mov    %esp,%ebp
801042e3:	53                   	push   %ebx
801042e4:	83 ec 14             	sub    $0x14,%esp
801042e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
801042ea:	89 1c 24             	mov    %ebx,(%esp)
801042ed:	e8 9e fe ff ff       	call   80104190 <holding>
801042f2:	85 c0                	test   %eax,%eax
801042f4:	74 23                	je     80104319 <release+0x39>
    panic("release");

  lk->pcs[0] = 0;
801042f6:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801042fd:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
80104304:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104309:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)

  popcli();
}
8010430f:	83 c4 14             	add    $0x14,%esp
80104312:	5b                   	pop    %ebx
80104313:	5d                   	pop    %ebp
  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );

  popcli();
80104314:	e9 57 ff ff ff       	jmp    80104270 <popcli>
// Release the lock.
void
release(struct spinlock *lk)
{
  if(!holding(lk))
    panic("release");
80104319:	c7 04 24 b9 73 10 80 	movl   $0x801073b9,(%esp)
80104320:	e8 4b c0 ff ff       	call   80100370 <panic>
	...

80104330 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104330:	55                   	push   %ebp
80104331:	89 e5                	mov    %esp,%ebp
80104333:	83 ec 08             	sub    $0x8,%esp
80104336:	8b 55 08             	mov    0x8(%ebp),%edx
80104339:	89 5d f8             	mov    %ebx,-0x8(%ebp)
8010433c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010433f:	89 7d fc             	mov    %edi,-0x4(%ebp)
80104342:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
80104345:	f6 c2 03             	test   $0x3,%dl
80104348:	75 05                	jne    8010434f <memset+0x1f>
8010434a:	f6 c1 03             	test   $0x3,%cl
8010434d:	74 11                	je     80104360 <memset+0x30>
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
8010434f:	89 d7                	mov    %edx,%edi
80104351:	fc                   	cld    
80104352:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80104354:	8b 5d f8             	mov    -0x8(%ebp),%ebx
80104357:	89 d0                	mov    %edx,%eax
80104359:	8b 7d fc             	mov    -0x4(%ebp),%edi
8010435c:	89 ec                	mov    %ebp,%esp
8010435e:	5d                   	pop    %ebp
8010435f:	c3                   	ret    

void*
memset(void *dst, int c, uint n)
{
  if ((int)dst%4 == 0 && n%4 == 0){
    c &= 0xFF;
80104360:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104363:	89 f8                	mov    %edi,%eax
80104365:	89 fb                	mov    %edi,%ebx
80104367:	c1 e0 18             	shl    $0x18,%eax
8010436a:	c1 e3 10             	shl    $0x10,%ebx
8010436d:	09 d8                	or     %ebx,%eax
8010436f:	09 f8                	or     %edi,%eax
80104371:	c1 e7 08             	shl    $0x8,%edi
80104374:	09 f8                	or     %edi,%eax
}

static inline void
stosl(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosl" :
80104376:	89 d7                	mov    %edx,%edi
80104378:	c1 e9 02             	shr    $0x2,%ecx
8010437b:	fc                   	cld    
8010437c:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
8010437e:	8b 5d f8             	mov    -0x8(%ebp),%ebx
80104381:	89 d0                	mov    %edx,%eax
80104383:	8b 7d fc             	mov    -0x4(%ebp),%edi
80104386:	89 ec                	mov    %ebp,%esp
80104388:	5d                   	pop    %ebp
80104389:	c3                   	ret    
8010438a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104390 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104390:	55                   	push   %ebp
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
80104391:	31 c0                	xor    %eax,%eax
  return dst;
}

int
memcmp(const void *v1, const void *v2, uint n)
{
80104393:	89 e5                	mov    %esp,%ebp
80104395:	57                   	push   %edi
80104396:	8b 7d 10             	mov    0x10(%ebp),%edi
80104399:	56                   	push   %esi
8010439a:	8b 75 0c             	mov    0xc(%ebp),%esi
8010439d:	53                   	push   %ebx
8010439e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801043a1:	85 ff                	test   %edi,%edi
801043a3:	74 29                	je     801043ce <memcmp+0x3e>
    if(*s1 != *s2)
801043a5:	0f b6 03             	movzbl (%ebx),%eax
{
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801043a8:	83 ef 01             	sub    $0x1,%edi
801043ab:	31 d2                	xor    %edx,%edx
    if(*s1 != *s2)
801043ad:	0f b6 0e             	movzbl (%esi),%ecx
801043b0:	38 c8                	cmp    %cl,%al
801043b2:	74 14                	je     801043c8 <memcmp+0x38>
801043b4:	eb 22                	jmp    801043d8 <memcmp+0x48>
801043b6:	66 90                	xchg   %ax,%ax
801043b8:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
801043bd:	83 c2 01             	add    $0x1,%edx
801043c0:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
801043c4:	38 c8                	cmp    %cl,%al
801043c6:	75 10                	jne    801043d8 <memcmp+0x48>
{
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801043c8:	39 d7                	cmp    %edx,%edi
801043ca:	75 ec                	jne    801043b8 <memcmp+0x28>
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
801043cc:	31 c0                	xor    %eax,%eax
}
801043ce:	5b                   	pop    %ebx
801043cf:	5e                   	pop    %esi
801043d0:	5f                   	pop    %edi
801043d1:	5d                   	pop    %ebp
801043d2:	c3                   	ret    
801043d3:	90                   	nop
801043d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
801043d8:	0f b6 c0             	movzbl %al,%eax
801043db:	0f b6 c9             	movzbl %cl,%ecx
    s1++, s2++;
  }

  return 0;
}
801043de:	5b                   	pop    %ebx

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
801043df:	29 c8                	sub    %ecx,%eax
    s1++, s2++;
  }

  return 0;
}
801043e1:	5e                   	pop    %esi
801043e2:	5f                   	pop    %edi
801043e3:	5d                   	pop    %ebp
801043e4:	c3                   	ret    
801043e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801043e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801043f0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801043f0:	55                   	push   %ebp
801043f1:	89 e5                	mov    %esp,%ebp
801043f3:	57                   	push   %edi
801043f4:	8b 45 08             	mov    0x8(%ebp),%eax
801043f7:	56                   	push   %esi
801043f8:	8b 75 0c             	mov    0xc(%ebp),%esi
801043fb:	53                   	push   %ebx
801043fc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801043ff:	39 c6                	cmp    %eax,%esi
80104401:	73 35                	jae    80104438 <memmove+0x48>
80104403:	8d 0c 1e             	lea    (%esi,%ebx,1),%ecx
80104406:	39 c8                	cmp    %ecx,%eax
80104408:	73 2e                	jae    80104438 <memmove+0x48>
    s += n;
    d += n;
    while(n-- > 0)
8010440a:	85 db                	test   %ebx,%ebx
8010440c:	74 20                	je     8010442e <memmove+0x3e>

  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
8010440e:	8d 3c 18             	lea    (%eax,%ebx,1),%edi
80104411:	89 da                	mov    %ebx,%edx

  return 0;
}

void*
memmove(void *dst, const void *src, uint n)
80104413:	f7 db                	neg    %ebx
80104415:	8d 34 19             	lea    (%ecx,%ebx,1),%esi
80104418:	01 fb                	add    %edi,%ebx
8010441a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
80104420:	0f b6 4c 16 ff       	movzbl -0x1(%esi,%edx,1),%ecx
80104425:	88 4c 13 ff          	mov    %cl,-0x1(%ebx,%edx,1)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
80104429:	83 ea 01             	sub    $0x1,%edx
8010442c:	75 f2                	jne    80104420 <memmove+0x30>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010442e:	5b                   	pop    %ebx
8010442f:	5e                   	pop    %esi
80104430:	5f                   	pop    %edi
80104431:	5d                   	pop    %ebp
80104432:	c3                   	ret    
80104433:	90                   	nop
80104434:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80104438:	31 d2                	xor    %edx,%edx
8010443a:	85 db                	test   %ebx,%ebx
8010443c:	74 f0                	je     8010442e <memmove+0x3e>
8010443e:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80104440:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104444:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104447:	83 c2 01             	add    $0x1,%edx
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
8010444a:	39 d3                	cmp    %edx,%ebx
8010444c:	75 f2                	jne    80104440 <memmove+0x50>
      *d++ = *s++;

  return dst;
}
8010444e:	5b                   	pop    %ebx
8010444f:	5e                   	pop    %esi
80104450:	5f                   	pop    %edi
80104451:	5d                   	pop    %ebp
80104452:	c3                   	ret    
80104453:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104459:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104460 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104460:	55                   	push   %ebp
80104461:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104463:	5d                   	pop    %ebp

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104464:	e9 87 ff ff ff       	jmp    801043f0 <memmove>
80104469:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104470 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104470:	55                   	push   %ebp
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
80104471:	31 c0                	xor    %eax,%eax
  return memmove(dst, src, n);
}

int
strncmp(const char *p, const char *q, uint n)
{
80104473:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
80104475:	8b 55 10             	mov    0x10(%ebp),%edx
  return memmove(dst, src, n);
}

int
strncmp(const char *p, const char *q, uint n)
{
80104478:	57                   	push   %edi
80104479:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010447c:	56                   	push   %esi
8010447d:	53                   	push   %ebx
8010447e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(n > 0 && *p && *p == *q)
80104481:	85 d2                	test   %edx,%edx
80104483:	74 34                	je     801044b9 <strncmp+0x49>
80104485:	0f b6 01             	movzbl (%ecx),%eax
80104488:	0f b6 33             	movzbl (%ebx),%esi
8010448b:	84 c0                	test   %al,%al
8010448d:	74 31                	je     801044c0 <strncmp+0x50>
8010448f:	89 f2                	mov    %esi,%edx
80104491:	38 d0                	cmp    %dl,%al
80104493:	74 1c                	je     801044b1 <strncmp+0x41>
80104495:	eb 29                	jmp    801044c0 <strncmp+0x50>
80104497:	90                   	nop
    n--, p++, q++;
80104498:	83 c1 01             	add    $0x1,%ecx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
8010449b:	0f b6 73 01          	movzbl 0x1(%ebx),%esi
8010449f:	0f b6 01             	movzbl (%ecx),%eax
    n--, p++, q++;
801044a2:	8d 7b 01             	lea    0x1(%ebx),%edi
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
801044a5:	84 c0                	test   %al,%al
801044a7:	74 17                	je     801044c0 <strncmp+0x50>
801044a9:	89 f2                	mov    %esi,%edx
801044ab:	38 d0                	cmp    %dl,%al
801044ad:	75 11                	jne    801044c0 <strncmp+0x50>
    n--, p++, q++;
801044af:	89 fb                	mov    %edi,%ebx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
801044b1:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
801044b5:	75 e1                	jne    80104498 <strncmp+0x28>
    n--, p++, q++;
  if(n == 0)
    return 0;
801044b7:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}
801044b9:	5b                   	pop    %ebx
801044ba:	5e                   	pop    %esi
801044bb:	5f                   	pop    %edi
801044bc:	5d                   	pop    %ebp
801044bd:	c3                   	ret    
801044be:	66 90                	xchg   %ax,%ax
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
801044c0:	81 e6 ff 00 00 00    	and    $0xff,%esi
801044c6:	0f b6 c0             	movzbl %al,%eax
}
801044c9:	5b                   	pop    %ebx
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
801044ca:	29 f0                	sub    %esi,%eax
}
801044cc:	5e                   	pop    %esi
801044cd:	5f                   	pop    %edi
801044ce:	5d                   	pop    %ebp
801044cf:	c3                   	ret    

801044d0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801044d0:	55                   	push   %ebp
801044d1:	89 e5                	mov    %esp,%ebp
801044d3:	57                   	push   %edi
801044d4:	8b 7d 08             	mov    0x8(%ebp),%edi
801044d7:	56                   	push   %esi
801044d8:	8b 4d 10             	mov    0x10(%ebp),%ecx
801044db:	53                   	push   %ebx
801044dc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
801044df:	89 fa                	mov    %edi,%edx
801044e1:	eb 14                	jmp    801044f7 <strncpy+0x27>
801044e3:	90                   	nop
801044e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801044e8:	0f b6 03             	movzbl (%ebx),%eax
801044eb:	83 c3 01             	add    $0x1,%ebx
801044ee:	88 02                	mov    %al,(%edx)
801044f0:	83 c2 01             	add    $0x1,%edx
801044f3:	84 c0                	test   %al,%al
801044f5:	74 0a                	je     80104501 <strncpy+0x31>
801044f7:	83 e9 01             	sub    $0x1,%ecx
    return 0;
  return (uchar)*p - (uchar)*q;
}

char*
strncpy(char *s, const char *t, int n)
801044fa:	8d 71 01             	lea    0x1(%ecx),%esi
{
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
801044fd:	85 f6                	test   %esi,%esi
801044ff:	7f e7                	jg     801044e8 <strncpy+0x18>
    ;
  while(n-- > 0)
80104501:	85 c9                	test   %ecx,%ecx
    return 0;
  return (uchar)*p - (uchar)*q;
}

char*
strncpy(char *s, const char *t, int n)
80104503:	8d 04 0a             	lea    (%edx,%ecx,1),%eax
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
80104506:	7e 0a                	jle    80104512 <strncpy+0x42>
    *s++ = 0;
80104508:	c6 02 00             	movb   $0x0,(%edx)
8010450b:	83 c2 01             	add    $0x1,%edx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
8010450e:	39 c2                	cmp    %eax,%edx
80104510:	75 f6                	jne    80104508 <strncpy+0x38>
    *s++ = 0;
  return os;
}
80104512:	5b                   	pop    %ebx
80104513:	89 f8                	mov    %edi,%eax
80104515:	5e                   	pop    %esi
80104516:	5f                   	pop    %edi
80104517:	5d                   	pop    %ebp
80104518:	c3                   	ret    
80104519:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104520 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104520:	55                   	push   %ebp
80104521:	89 e5                	mov    %esp,%ebp
80104523:	8b 55 10             	mov    0x10(%ebp),%edx
80104526:	56                   	push   %esi
80104527:	8b 75 08             	mov    0x8(%ebp),%esi
8010452a:	53                   	push   %ebx
8010452b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  if(n <= 0)
8010452e:	85 d2                	test   %edx,%edx
80104530:	7e 1d                	jle    8010454f <safestrcpy+0x2f>
80104532:	89 f1                	mov    %esi,%ecx
80104534:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104538:	83 ea 01             	sub    $0x1,%edx
8010453b:	74 0f                	je     8010454c <safestrcpy+0x2c>
8010453d:	0f b6 03             	movzbl (%ebx),%eax
80104540:	83 c3 01             	add    $0x1,%ebx
80104543:	88 01                	mov    %al,(%ecx)
80104545:	83 c1 01             	add    $0x1,%ecx
80104548:	84 c0                	test   %al,%al
8010454a:	75 ec                	jne    80104538 <safestrcpy+0x18>
    ;
  *s = 0;
8010454c:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
8010454f:	89 f0                	mov    %esi,%eax
80104551:	5b                   	pop    %ebx
80104552:	5e                   	pop    %esi
80104553:	5d                   	pop    %ebp
80104554:	c3                   	ret    
80104555:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104559:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104560 <strlen>:

int
strlen(const char *s)
{
80104560:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104561:	31 c0                	xor    %eax,%eax
  return os;
}

int
strlen(const char *s)
{
80104563:	89 e5                	mov    %esp,%ebp
80104565:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
80104568:	80 3a 00             	cmpb   $0x0,(%edx)
8010456b:	74 0c                	je     80104579 <strlen+0x19>
8010456d:	8d 76 00             	lea    0x0(%esi),%esi
80104570:	83 c0 01             	add    $0x1,%eax
80104573:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104577:	75 f7                	jne    80104570 <strlen+0x10>
    ;
  return n;
}
80104579:	5d                   	pop    %ebp
8010457a:	c3                   	ret    
	...

8010457c <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010457c:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104580:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80104584:	55                   	push   %ebp
  pushl %ebx
80104585:	53                   	push   %ebx
  pushl %esi
80104586:	56                   	push   %esi
  pushl %edi
80104587:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104588:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
8010458a:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
8010458c:	5f                   	pop    %edi
  popl %esi
8010458d:	5e                   	pop    %esi
  popl %ebx
8010458e:	5b                   	pop    %ebx
  popl %ebp
8010458f:	5d                   	pop    %ebp
  ret
80104590:	c3                   	ret    
	...

801045a0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801045a0:	55                   	push   %ebp
801045a1:	89 e5                	mov    %esp,%ebp
801045a3:	53                   	push   %ebx
801045a4:	83 ec 04             	sub    $0x4,%esp
801045a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
801045aa:	e8 a1 f1 ff ff       	call   80103750 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801045af:	8b 10                	mov    (%eax),%edx
    return -1;
801045b1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
int
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801045b6:	39 da                	cmp    %ebx,%edx
801045b8:	76 10                	jbe    801045ca <fetchint+0x2a>
801045ba:	8d 4b 04             	lea    0x4(%ebx),%ecx
801045bd:	39 ca                	cmp    %ecx,%edx
801045bf:	72 09                	jb     801045ca <fetchint+0x2a>
    return -1;
  *ip = *(int*)(addr);
801045c1:	8b 45 0c             	mov    0xc(%ebp),%eax
801045c4:	8b 13                	mov    (%ebx),%edx
801045c6:	89 10                	mov    %edx,(%eax)
  return 0;
801045c8:	31 c0                	xor    %eax,%eax
}
801045ca:	83 c4 04             	add    $0x4,%esp
801045cd:	5b                   	pop    %ebx
801045ce:	5d                   	pop    %ebp
801045cf:	c3                   	ret    

801045d0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801045d0:	55                   	push   %ebp
801045d1:	89 e5                	mov    %esp,%ebp
801045d3:	53                   	push   %ebx
801045d4:	83 ec 04             	sub    $0x4,%esp
801045d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
801045da:	e8 71 f1 ff ff       	call   80103750 <myproc>

  if(addr >= curproc->sz)
    return -1;
801045df:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
fetchstr(uint addr, char **pp)
{
  char *s, *ep;
  struct proc *curproc = myproc();

  if(addr >= curproc->sz)
801045e4:	39 18                	cmp    %ebx,(%eax)
801045e6:	76 29                	jbe    80104611 <fetchstr+0x41>
    return -1;
  *pp = (char*)addr;
801045e8:	8b 55 0c             	mov    0xc(%ebp),%edx
801045eb:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
801045ed:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
801045ef:	39 d3                	cmp    %edx,%ebx
801045f1:	73 1e                	jae    80104611 <fetchstr+0x41>
    if(*s == 0)
801045f3:	31 c9                	xor    %ecx,%ecx
801045f5:	89 d8                	mov    %ebx,%eax
801045f7:	80 3b 00             	cmpb   $0x0,(%ebx)
801045fa:	75 09                	jne    80104605 <fetchstr+0x35>
801045fc:	eb 13                	jmp    80104611 <fetchstr+0x41>
801045fe:	66 90                	xchg   %ax,%ax
80104600:	80 38 00             	cmpb   $0x0,(%eax)
80104603:	74 1b                	je     80104620 <fetchstr+0x50>

  if(addr >= curproc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
80104605:	83 c0 01             	add    $0x1,%eax
80104608:	39 c2                	cmp    %eax,%edx
8010460a:	77 f4                	ja     80104600 <fetchstr+0x30>
    if(*s == 0)
      return s - *pp;
  }
  return -1;
8010460c:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
}
80104611:	83 c4 04             	add    $0x4,%esp
80104614:	89 c8                	mov    %ecx,%eax
80104616:	5b                   	pop    %ebx
80104617:	5d                   	pop    %ebp
80104618:	c3                   	ret    
80104619:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(addr >= curproc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
    if(*s == 0)
80104620:	89 c1                	mov    %eax,%ecx
      return s - *pp;
  }
  return -1;
}
80104622:	83 c4 04             	add    $0x4,%esp
  if(addr >= curproc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
    if(*s == 0)
80104625:	29 d9                	sub    %ebx,%ecx
      return s - *pp;
  }
  return -1;
}
80104627:	89 c8                	mov    %ecx,%eax
80104629:	5b                   	pop    %ebx
8010462a:	5d                   	pop    %ebp
8010462b:	c3                   	ret    
8010462c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104630 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104630:	55                   	push   %ebp
80104631:	89 e5                	mov    %esp,%ebp
80104633:	83 ec 08             	sub    $0x8,%esp
80104636:	89 5d f8             	mov    %ebx,-0x8(%ebp)
80104639:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010463c:	89 75 fc             	mov    %esi,-0x4(%ebp)
8010463f:	8b 75 0c             	mov    0xc(%ebp),%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104642:	e8 09 f1 ff ff       	call   80103750 <myproc>
80104647:	89 75 0c             	mov    %esi,0xc(%ebp)
}
8010464a:	8b 75 fc             	mov    -0x4(%ebp),%esi

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010464d:	8b 40 18             	mov    0x18(%eax),%eax
80104650:	8b 40 44             	mov    0x44(%eax),%eax
80104653:	8d 44 98 04          	lea    0x4(%eax,%ebx,4),%eax
}
80104657:	8b 5d f8             	mov    -0x8(%ebp),%ebx

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010465a:	89 45 08             	mov    %eax,0x8(%ebp)
}
8010465d:	89 ec                	mov    %ebp,%esp
8010465f:	5d                   	pop    %ebp

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104660:	e9 3b ff ff ff       	jmp    801045a0 <fetchint>
80104665:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104669:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104670 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104670:	55                   	push   %ebp
80104671:	89 e5                	mov    %esp,%ebp
80104673:	56                   	push   %esi
80104674:	53                   	push   %ebx
80104675:	83 ec 20             	sub    $0x20,%esp
80104678:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
8010467b:	e8 d0 f0 ff ff       	call   80103750 <myproc>
80104680:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80104682:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104685:	89 44 24 04          	mov    %eax,0x4(%esp)
80104689:	8b 45 08             	mov    0x8(%ebp),%eax
8010468c:	89 04 24             	mov    %eax,(%esp)
8010468f:	e8 9c ff ff ff       	call   80104630 <argint>
80104694:	85 c0                	test   %eax,%eax
80104696:	78 28                	js     801046c0 <argptr+0x50>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104698:	85 db                	test   %ebx,%ebx
8010469a:	78 24                	js     801046c0 <argptr+0x50>
8010469c:	8b 55 f4             	mov    -0xc(%ebp),%edx
    return -1;
8010469f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  int i;
  struct proc *curproc = myproc();
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801046a4:	8b 0e                	mov    (%esi),%ecx
801046a6:	39 ca                	cmp    %ecx,%edx
801046a8:	73 0d                	jae    801046b7 <argptr+0x47>
801046aa:	01 d3                	add    %edx,%ebx
801046ac:	39 d9                	cmp    %ebx,%ecx
801046ae:	72 07                	jb     801046b7 <argptr+0x47>
    return -1;
  *pp = (char*)i;
801046b0:	8b 45 0c             	mov    0xc(%ebp),%eax
801046b3:	89 10                	mov    %edx,(%eax)
  return 0;
801046b5:	31 c0                	xor    %eax,%eax
}
801046b7:	83 c4 20             	add    $0x20,%esp
801046ba:	5b                   	pop    %ebx
801046bb:	5e                   	pop    %esi
801046bc:	5d                   	pop    %ebp
801046bd:	c3                   	ret    
801046be:	66 90                	xchg   %ax,%ax
  struct proc *curproc = myproc();
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
    return -1;
801046c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801046c5:	eb f0                	jmp    801046b7 <argptr+0x47>
801046c7:	89 f6                	mov    %esi,%esi
801046c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801046d0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801046d0:	55                   	push   %ebp
801046d1:	89 e5                	mov    %esp,%ebp
801046d3:	83 ec 28             	sub    $0x28,%esp
  int addr;
  if(argint(n, &addr) < 0)
801046d6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801046d9:	89 44 24 04          	mov    %eax,0x4(%esp)
801046dd:	8b 45 08             	mov    0x8(%ebp),%eax
801046e0:	89 04 24             	mov    %eax,(%esp)
801046e3:	e8 48 ff ff ff       	call   80104630 <argint>
801046e8:	89 c2                	mov    %eax,%edx
    return -1;
801046ea:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
  int addr;
  if(argint(n, &addr) < 0)
801046ef:	85 d2                	test   %edx,%edx
801046f1:	78 12                	js     80104705 <argstr+0x35>
    return -1;
  return fetchstr(addr, pp);
801046f3:	8b 45 0c             	mov    0xc(%ebp),%eax
801046f6:	89 44 24 04          	mov    %eax,0x4(%esp)
801046fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046fd:	89 04 24             	mov    %eax,(%esp)
80104700:	e8 cb fe ff ff       	call   801045d0 <fetchstr>
}
80104705:	c9                   	leave  
80104706:	c3                   	ret    
80104707:	89 f6                	mov    %esi,%esi
80104709:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104710 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
80104710:	55                   	push   %ebp
80104711:	89 e5                	mov    %esp,%ebp
80104713:	83 ec 18             	sub    $0x18,%esp
80104716:	89 5d f8             	mov    %ebx,-0x8(%ebp)
80104719:	89 75 fc             	mov    %esi,-0x4(%ebp)
  int num;
  struct proc *curproc = myproc();
8010471c:	e8 2f f0 ff ff       	call   80103750 <myproc>

  num = curproc->tf->eax;
80104721:	8b 58 18             	mov    0x18(%eax),%ebx

void
syscall(void)
{
  int num;
  struct proc *curproc = myproc();
80104724:	89 c6                	mov    %eax,%esi

  num = curproc->tf->eax;
80104726:	8b 43 1c             	mov    0x1c(%ebx),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104729:	8d 50 ff             	lea    -0x1(%eax),%edx
8010472c:	83 fa 14             	cmp    $0x14,%edx
8010472f:	77 1f                	ja     80104750 <syscall+0x40>
80104731:	8b 14 85 e0 73 10 80 	mov    -0x7fef8c20(,%eax,4),%edx
80104738:	85 d2                	test   %edx,%edx
8010473a:	74 14                	je     80104750 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
8010473c:	ff d2                	call   *%edx
8010473e:	89 43 1c             	mov    %eax,0x1c(%ebx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104741:	8b 5d f8             	mov    -0x8(%ebp),%ebx
80104744:	8b 75 fc             	mov    -0x4(%ebp),%esi
80104747:	89 ec                	mov    %ebp,%esp
80104749:	5d                   	pop    %ebp
8010474a:	c3                   	ret    
8010474b:	90                   	nop
8010474c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  num = curproc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80104750:	89 44 24 0c          	mov    %eax,0xc(%esp)
            curproc->pid, curproc->name, num);
80104754:	8d 46 6c             	lea    0x6c(%esi),%eax
80104757:	89 44 24 08          	mov    %eax,0x8(%esp)

  num = curproc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
8010475b:	8b 46 10             	mov    0x10(%esi),%eax
8010475e:	c7 04 24 c1 73 10 80 	movl   $0x801073c1,(%esp)
80104765:	89 44 24 04          	mov    %eax,0x4(%esp)
80104769:	e8 e2 be ff ff       	call   80100650 <cprintf>
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
8010476e:	8b 46 18             	mov    0x18(%esi),%eax
80104771:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80104778:	8b 5d f8             	mov    -0x8(%ebp),%ebx
8010477b:	8b 75 fc             	mov    -0x4(%ebp),%esi
8010477e:	89 ec                	mov    %ebp,%esp
80104780:	5d                   	pop    %ebp
80104781:	c3                   	ret    
	...

80104790 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80104790:	55                   	push   %ebp
80104791:	89 e5                	mov    %esp,%ebp
80104793:	53                   	push   %ebx
80104794:	89 c3                	mov    %eax,%ebx
80104796:	83 ec 04             	sub    $0x4,%esp
  int fd;
  struct proc *curproc = myproc();
80104799:	e8 b2 ef ff ff       	call   80103750 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
8010479e:	31 d2                	xor    %edx,%edx
    if(curproc->ofile[fd] == 0){
801047a0:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
801047a4:	85 c9                	test   %ecx,%ecx
801047a6:	74 18                	je     801047c0 <fdalloc+0x30>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
801047a8:	83 c2 01             	add    $0x1,%edx
801047ab:	83 fa 10             	cmp    $0x10,%edx
801047ae:	75 f0                	jne    801047a0 <fdalloc+0x10>
      curproc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
}
801047b0:	83 c4 04             	add    $0x4,%esp
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
801047b3:	ba ff ff ff ff       	mov    $0xffffffff,%edx
}
801047b8:	89 d0                	mov    %edx,%eax
801047ba:	5b                   	pop    %ebx
801047bb:	5d                   	pop    %ebp
801047bc:	c3                   	ret    
801047bd:	8d 76 00             	lea    0x0(%esi),%esi
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
801047c0:	89 5c 90 28          	mov    %ebx,0x28(%eax,%edx,4)
      return fd;
    }
  }
  return -1;
}
801047c4:	83 c4 04             	add    $0x4,%esp
801047c7:	89 d0                	mov    %edx,%eax
801047c9:	5b                   	pop    %ebx
801047ca:	5d                   	pop    %ebp
801047cb:	c3                   	ret    
801047cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801047d0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
801047d0:	55                   	push   %ebp
801047d1:	89 e5                	mov    %esp,%ebp
801047d3:	83 ec 58             	sub    $0x58,%esp
801047d6:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
801047d9:	8b 4d 08             	mov    0x8(%ebp),%ecx
801047dc:	89 75 f8             	mov    %esi,-0x8(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801047df:	8d 75 d6             	lea    -0x2a(%ebp),%esi
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
801047e2:	89 7d fc             	mov    %edi,-0x4(%ebp)
801047e5:	89 d7                	mov    %edx,%edi
801047e7:	89 5d f4             	mov    %ebx,-0xc(%ebp)
801047ea:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801047ed:	89 74 24 04          	mov    %esi,0x4(%esp)
801047f1:	89 04 24             	mov    %eax,(%esp)
801047f4:	e8 b7 d7 ff ff       	call   80101fb0 <nameiparent>
801047f9:	85 c0                	test   %eax,%eax
801047fb:	0f 84 ff 00 00 00    	je     80104900 <create+0x130>
    return 0;
  ilock(dp);
80104801:	89 04 24             	mov    %eax,(%esp)
80104804:	89 45 bc             	mov    %eax,-0x44(%ebp)
80104807:	e8 b4 ce ff ff       	call   801016c0 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
8010480c:	8b 55 bc             	mov    -0x44(%ebp),%edx
8010480f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80104812:	89 44 24 08          	mov    %eax,0x8(%esp)
80104816:	89 74 24 04          	mov    %esi,0x4(%esp)
8010481a:	89 14 24             	mov    %edx,(%esp)
8010481d:	e8 2e d4 ff ff       	call   80101c50 <dirlookup>
80104822:	8b 55 bc             	mov    -0x44(%ebp),%edx
80104825:	85 c0                	test   %eax,%eax
80104827:	89 c3                	mov    %eax,%ebx
80104829:	74 4d                	je     80104878 <create+0xa8>
    iunlockput(dp);
8010482b:	89 14 24             	mov    %edx,(%esp)
8010482e:	e8 1d d1 ff ff       	call   80101950 <iunlockput>
    ilock(ip);
80104833:	89 1c 24             	mov    %ebx,(%esp)
80104836:	e8 85 ce ff ff       	call   801016c0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
8010483b:	66 83 ff 02          	cmp    $0x2,%di
8010483f:	75 17                	jne    80104858 <create+0x88>
80104841:	66 83 7b 50 02       	cmpw   $0x2,0x50(%ebx)
80104846:	75 10                	jne    80104858 <create+0x88>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104848:	89 d8                	mov    %ebx,%eax
8010484a:	8b 75 f8             	mov    -0x8(%ebp),%esi
8010484d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80104850:	8b 7d fc             	mov    -0x4(%ebp),%edi
80104853:	89 ec                	mov    %ebp,%esp
80104855:	5d                   	pop    %ebp
80104856:	c3                   	ret    
80104857:	90                   	nop
  if((ip = dirlookup(dp, name, &off)) != 0){
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
80104858:	89 1c 24             	mov    %ebx,(%esp)
    return 0;
8010485b:	31 db                	xor    %ebx,%ebx
  if((ip = dirlookup(dp, name, &off)) != 0){
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
8010485d:	e8 ee d0 ff ff       	call   80101950 <iunlockput>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104862:	89 d8                	mov    %ebx,%eax
80104864:	8b 75 f8             	mov    -0x8(%ebp),%esi
80104867:	8b 5d f4             	mov    -0xc(%ebp),%ebx
8010486a:	8b 7d fc             	mov    -0x4(%ebp),%edi
8010486d:	89 ec                	mov    %ebp,%esp
8010486f:	5d                   	pop    %ebp
80104870:	c3                   	ret    
80104871:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      return ip;
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80104878:	0f bf c7             	movswl %di,%eax
8010487b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010487f:	8b 02                	mov    (%edx),%eax
80104881:	89 55 bc             	mov    %edx,-0x44(%ebp)
80104884:	89 04 24             	mov    %eax,(%esp)
80104887:	e8 a4 cc ff ff       	call   80101530 <ialloc>
8010488c:	8b 55 bc             	mov    -0x44(%ebp),%edx
8010488f:	85 c0                	test   %eax,%eax
80104891:	89 c3                	mov    %eax,%ebx
80104893:	0f 84 d7 00 00 00    	je     80104970 <create+0x1a0>
    panic("create: ialloc");

  ilock(ip);
80104899:	89 55 bc             	mov    %edx,-0x44(%ebp)
8010489c:	89 04 24             	mov    %eax,(%esp)
8010489f:	e8 1c ce ff ff       	call   801016c0 <ilock>
  ip->major = major;
801048a4:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
  ip->minor = minor;
801048a8:	0f b7 4d c0          	movzwl -0x40(%ebp),%ecx
  ip->nlink = 1;
801048ac:	66 c7 43 56 01 00    	movw   $0x1,0x56(%ebx)

  if((ip = ialloc(dp->dev, type)) == 0)
    panic("create: ialloc");

  ilock(ip);
  ip->major = major;
801048b2:	66 89 43 52          	mov    %ax,0x52(%ebx)
  ip->minor = minor;
801048b6:	66 89 4b 54          	mov    %cx,0x54(%ebx)
  ip->nlink = 1;
  iupdate(ip);
801048ba:	89 1c 24             	mov    %ebx,(%esp)
801048bd:	e8 3e cd ff ff       	call   80101600 <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
801048c2:	66 83 ff 01          	cmp    $0x1,%di
801048c6:	8b 55 bc             	mov    -0x44(%ebp),%edx
801048c9:	74 3d                	je     80104908 <create+0x138>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }

  if(dirlink(dp, name, ip->inum) < 0)
801048cb:	8b 43 04             	mov    0x4(%ebx),%eax
801048ce:	89 14 24             	mov    %edx,(%esp)
801048d1:	89 55 bc             	mov    %edx,-0x44(%ebp)
801048d4:	89 74 24 04          	mov    %esi,0x4(%esp)
801048d8:	89 44 24 08          	mov    %eax,0x8(%esp)
801048dc:	e8 cf d5 ff ff       	call   80101eb0 <dirlink>
801048e1:	8b 55 bc             	mov    -0x44(%ebp),%edx
801048e4:	85 c0                	test   %eax,%eax
801048e6:	78 7c                	js     80104964 <create+0x194>
    panic("create: dirlink");

  iunlockput(dp);
801048e8:	89 14 24             	mov    %edx,(%esp)
801048eb:	e8 60 d0 ff ff       	call   80101950 <iunlockput>

  return ip;
}
801048f0:	89 d8                	mov    %ebx,%eax
801048f2:	8b 75 f8             	mov    -0x8(%ebp),%esi
801048f5:	8b 5d f4             	mov    -0xc(%ebp),%ebx
801048f8:	8b 7d fc             	mov    -0x4(%ebp),%edi
801048fb:	89 ec                	mov    %ebp,%esp
801048fd:	5d                   	pop    %ebp
801048fe:	c3                   	ret    
801048ff:	90                   	nop
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    return 0;
80104900:	31 db                	xor    %ebx,%ebx
80104902:	e9 41 ff ff ff       	jmp    80104848 <create+0x78>
80104907:	90                   	nop
  ip->minor = minor;
  ip->nlink = 1;
  iupdate(ip);

  if(type == T_DIR){  // Create . and .. entries.
    dp->nlink++;  // for ".."
80104908:	66 83 42 56 01       	addw   $0x1,0x56(%edx)
    iupdate(dp);
8010490d:	89 14 24             	mov    %edx,(%esp)
80104910:	89 55 bc             	mov    %edx,-0x44(%ebp)
80104913:	e8 e8 cc ff ff       	call   80101600 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104918:	8b 43 04             	mov    0x4(%ebx),%eax
8010491b:	c7 44 24 04 48 74 10 	movl   $0x80107448,0x4(%esp)
80104922:	80 
80104923:	89 1c 24             	mov    %ebx,(%esp)
80104926:	89 44 24 08          	mov    %eax,0x8(%esp)
8010492a:	e8 81 d5 ff ff       	call   80101eb0 <dirlink>
8010492f:	8b 55 bc             	mov    -0x44(%ebp),%edx
80104932:	85 c0                	test   %eax,%eax
80104934:	78 22                	js     80104958 <create+0x188>
80104936:	8b 42 04             	mov    0x4(%edx),%eax
80104939:	c7 44 24 04 47 74 10 	movl   $0x80107447,0x4(%esp)
80104940:	80 
80104941:	89 1c 24             	mov    %ebx,(%esp)
80104944:	89 44 24 08          	mov    %eax,0x8(%esp)
80104948:	e8 63 d5 ff ff       	call   80101eb0 <dirlink>
8010494d:	8b 55 bc             	mov    -0x44(%ebp),%edx
80104950:	85 c0                	test   %eax,%eax
80104952:	0f 89 73 ff ff ff    	jns    801048cb <create+0xfb>
      panic("create dots");
80104958:	c7 04 24 4a 74 10 80 	movl   $0x8010744a,(%esp)
8010495f:	e8 0c ba ff ff       	call   80100370 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");
80104964:	c7 04 24 56 74 10 80 	movl   $0x80107456,(%esp)
8010496b:	e8 00 ba ff ff       	call   80100370 <panic>
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
    panic("create: ialloc");
80104970:	c7 04 24 38 74 10 80 	movl   $0x80107438,(%esp)
80104977:	e8 f4 b9 ff ff       	call   80100370 <panic>
8010497c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104980 <argfd.constprop.0>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80104980:	55                   	push   %ebp
80104981:	89 e5                	mov    %esp,%ebp
80104983:	83 ec 38             	sub    $0x38,%esp
80104986:	89 5d f4             	mov    %ebx,-0xc(%ebp)
80104989:	89 c3                	mov    %eax,%ebx
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
8010498b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
8010498e:	89 75 f8             	mov    %esi,-0x8(%ebp)
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    return -1;
80104991:	be ff ff ff ff       	mov    $0xffffffff,%esi
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80104996:	89 7d fc             	mov    %edi,-0x4(%ebp)
80104999:	89 d7                	mov    %edx,%edi
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
8010499b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010499f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801049a6:	e8 85 fc ff ff       	call   80104630 <argint>
801049ab:	85 c0                	test   %eax,%eax
801049ad:	78 24                	js     801049d3 <argfd.constprop.0+0x53>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801049af:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
801049b3:	77 1e                	ja     801049d3 <argfd.constprop.0+0x53>
801049b5:	e8 96 ed ff ff       	call   80103750 <myproc>
801049ba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801049bd:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
801049c1:	85 c0                	test   %eax,%eax
801049c3:	74 0e                	je     801049d3 <argfd.constprop.0+0x53>
    return -1;
  if(pfd)
801049c5:	85 db                	test   %ebx,%ebx
801049c7:	74 02                	je     801049cb <argfd.constprop.0+0x4b>
    *pfd = fd;
801049c9:	89 13                	mov    %edx,(%ebx)
  if(pf)
    *pf = f;
  return 0;
801049cb:	31 f6                	xor    %esi,%esi
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    return -1;
  if(pfd)
    *pfd = fd;
  if(pf)
801049cd:	85 ff                	test   %edi,%edi
801049cf:	74 02                	je     801049d3 <argfd.constprop.0+0x53>
    *pf = f;
801049d1:	89 07                	mov    %eax,(%edi)
  return 0;
}
801049d3:	89 f0                	mov    %esi,%eax
801049d5:	8b 5d f4             	mov    -0xc(%ebp),%ebx
801049d8:	8b 75 f8             	mov    -0x8(%ebp),%esi
801049db:	8b 7d fc             	mov    -0x4(%ebp),%edi
801049de:	89 ec                	mov    %ebp,%esp
801049e0:	5d                   	pop    %ebp
801049e1:	c3                   	ret    
801049e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801049f0 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
801049f0:	55                   	push   %ebp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
801049f1:	31 c0                	xor    %eax,%eax
  return -1;
}

int
sys_dup(void)
{
801049f3:	89 e5                	mov    %esp,%ebp
801049f5:	53                   	push   %ebx
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
801049f6:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  return -1;
}

int
sys_dup(void)
{
801049fb:	83 ec 24             	sub    $0x24,%esp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
801049fe:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104a01:	e8 7a ff ff ff       	call   80104980 <argfd.constprop.0>
80104a06:	85 c0                	test   %eax,%eax
80104a08:	78 19                	js     80104a23 <sys_dup+0x33>
    return -1;
  if((fd=fdalloc(f)) < 0)
80104a0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a0d:	e8 7e fd ff ff       	call   80104790 <fdalloc>
80104a12:	85 c0                	test   %eax,%eax
80104a14:	89 c3                	mov    %eax,%ebx
80104a16:	78 18                	js     80104a30 <sys_dup+0x40>
    return -1;
  filedup(f);
80104a18:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a1b:	89 04 24             	mov    %eax,(%esp)
80104a1e:	e8 ad c3 ff ff       	call   80100dd0 <filedup>
  return fd;
}
80104a23:	83 c4 24             	add    $0x24,%esp
80104a26:	89 d8                	mov    %ebx,%eax
80104a28:	5b                   	pop    %ebx
80104a29:	5d                   	pop    %ebp
80104a2a:	c3                   	ret    
80104a2b:	90                   	nop
80104a2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
80104a30:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104a35:	eb ec                	jmp    80104a23 <sys_dup+0x33>
80104a37:	89 f6                	mov    %esi,%esi
80104a39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104a40 <sys_read>:
  return fd;
}

int
sys_read(void)
{
80104a40:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104a41:	31 c0                	xor    %eax,%eax
  return fd;
}

int
sys_read(void)
{
80104a43:	89 e5                	mov    %esp,%ebp
80104a45:	53                   	push   %ebx
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80104a46:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  return fd;
}

int
sys_read(void)
{
80104a4b:	83 ec 24             	sub    $0x24,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104a4e:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104a51:	e8 2a ff ff ff       	call   80104980 <argfd.constprop.0>
80104a56:	85 c0                	test   %eax,%eax
80104a58:	78 50                	js     80104aaa <sys_read+0x6a>
80104a5a:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104a5d:	89 44 24 04          	mov    %eax,0x4(%esp)
80104a61:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80104a68:	e8 c3 fb ff ff       	call   80104630 <argint>
80104a6d:	85 c0                	test   %eax,%eax
80104a6f:	78 39                	js     80104aaa <sys_read+0x6a>
80104a71:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104a74:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104a7b:	89 44 24 08          	mov    %eax,0x8(%esp)
80104a7f:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104a82:	89 44 24 04          	mov    %eax,0x4(%esp)
80104a86:	e8 e5 fb ff ff       	call   80104670 <argptr>
80104a8b:	85 c0                	test   %eax,%eax
80104a8d:	78 1b                	js     80104aaa <sys_read+0x6a>
    return -1;
  return fileread(f, p, n);
80104a8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104a92:	89 44 24 08          	mov    %eax,0x8(%esp)
80104a96:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a99:	89 44 24 04          	mov    %eax,0x4(%esp)
80104a9d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104aa0:	89 04 24             	mov    %eax,(%esp)
80104aa3:	e8 a8 c4 ff ff       	call   80100f50 <fileread>
80104aa8:	89 c3                	mov    %eax,%ebx
}
80104aaa:	83 c4 24             	add    $0x24,%esp
80104aad:	89 d8                	mov    %ebx,%eax
80104aaf:	5b                   	pop    %ebx
80104ab0:	5d                   	pop    %ebp
80104ab1:	c3                   	ret    
80104ab2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ab9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ac0 <sys_write>:

int
sys_write(void)
{
80104ac0:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104ac1:	31 c0                	xor    %eax,%eax
  return fileread(f, p, n);
}

int
sys_write(void)
{
80104ac3:	89 e5                	mov    %esp,%ebp
80104ac5:	53                   	push   %ebx
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80104ac6:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  return fileread(f, p, n);
}

int
sys_write(void)
{
80104acb:	83 ec 24             	sub    $0x24,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104ace:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104ad1:	e8 aa fe ff ff       	call   80104980 <argfd.constprop.0>
80104ad6:	85 c0                	test   %eax,%eax
80104ad8:	78 50                	js     80104b2a <sys_write+0x6a>
80104ada:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104add:	89 44 24 04          	mov    %eax,0x4(%esp)
80104ae1:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80104ae8:	e8 43 fb ff ff       	call   80104630 <argint>
80104aed:	85 c0                	test   %eax,%eax
80104aef:	78 39                	js     80104b2a <sys_write+0x6a>
80104af1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104af4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104afb:	89 44 24 08          	mov    %eax,0x8(%esp)
80104aff:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104b02:	89 44 24 04          	mov    %eax,0x4(%esp)
80104b06:	e8 65 fb ff ff       	call   80104670 <argptr>
80104b0b:	85 c0                	test   %eax,%eax
80104b0d:	78 1b                	js     80104b2a <sys_write+0x6a>
    return -1;
  return filewrite(f, p, n);
80104b0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104b12:	89 44 24 08          	mov    %eax,0x8(%esp)
80104b16:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b19:	89 44 24 04          	mov    %eax,0x4(%esp)
80104b1d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104b20:	89 04 24             	mov    %eax,(%esp)
80104b23:	e8 d8 c4 ff ff       	call   80101000 <filewrite>
80104b28:	89 c3                	mov    %eax,%ebx
}
80104b2a:	83 c4 24             	add    $0x24,%esp
80104b2d:	89 d8                	mov    %ebx,%eax
80104b2f:	5b                   	pop    %ebx
80104b30:	5d                   	pop    %ebp
80104b31:	c3                   	ret    
80104b32:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b40 <sys_close>:

int
sys_close(void)
{
80104b40:	55                   	push   %ebp
80104b41:	89 e5                	mov    %esp,%ebp
80104b43:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
80104b46:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104b49:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104b4c:	e8 2f fe ff ff       	call   80104980 <argfd.constprop.0>
    return -1;
80104b51:	ba ff ff ff ff       	mov    $0xffffffff,%edx
sys_close(void)
{
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
80104b56:	85 c0                	test   %eax,%eax
80104b58:	78 1d                	js     80104b77 <sys_close+0x37>
    return -1;
  myproc()->ofile[fd] = 0;
80104b5a:	e8 f1 eb ff ff       	call   80103750 <myproc>
80104b5f:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104b62:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104b69:	00 
  fileclose(f);
80104b6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b6d:	89 04 24             	mov    %eax,(%esp)
80104b70:	e8 ab c2 ff ff       	call   80100e20 <fileclose>
  return 0;
80104b75:	31 d2                	xor    %edx,%edx
}
80104b77:	89 d0                	mov    %edx,%eax
80104b79:	c9                   	leave  
80104b7a:	c3                   	ret    
80104b7b:	90                   	nop
80104b7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104b80 <sys_fstat>:

int
sys_fstat(void)
{
80104b80:	55                   	push   %ebp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104b81:	31 c0                	xor    %eax,%eax
  return 0;
}

int
sys_fstat(void)
{
80104b83:	89 e5                	mov    %esp,%ebp
80104b85:	53                   	push   %ebx
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
    return -1;
80104b86:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  return 0;
}

int
sys_fstat(void)
{
80104b8b:	83 ec 24             	sub    $0x24,%esp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104b8e:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104b91:	e8 ea fd ff ff       	call   80104980 <argfd.constprop.0>
80104b96:	85 c0                	test   %eax,%eax
80104b98:	78 33                	js     80104bcd <sys_fstat+0x4d>
80104b9a:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104b9d:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80104ba4:	00 
80104ba5:	89 44 24 04          	mov    %eax,0x4(%esp)
80104ba9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104bb0:	e8 bb fa ff ff       	call   80104670 <argptr>
80104bb5:	85 c0                	test   %eax,%eax
80104bb7:	78 14                	js     80104bcd <sys_fstat+0x4d>
    return -1;
  return filestat(f, st);
80104bb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bbc:	89 44 24 04          	mov    %eax,0x4(%esp)
80104bc0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104bc3:	89 04 24             	mov    %eax,(%esp)
80104bc6:	e8 35 c3 ff ff       	call   80100f00 <filestat>
80104bcb:	89 c3                	mov    %eax,%ebx
}
80104bcd:	83 c4 24             	add    $0x24,%esp
80104bd0:	89 d8                	mov    %ebx,%eax
80104bd2:	5b                   	pop    %ebx
80104bd3:	5d                   	pop    %ebp
80104bd4:	c3                   	ret    
80104bd5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104bd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104be0 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80104be0:	55                   	push   %ebp
80104be1:	89 e5                	mov    %esp,%ebp
80104be3:	57                   	push   %edi
80104be4:	56                   	push   %esi
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
    return -1;
80104be5:	be ff ff ff ff       	mov    $0xffffffff,%esi
}

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80104bea:	53                   	push   %ebx
80104beb:	83 ec 3c             	sub    $0x3c,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104bee:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80104bf1:	89 44 24 04          	mov    %eax,0x4(%esp)
80104bf5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104bfc:	e8 cf fa ff ff       	call   801046d0 <argstr>
80104c01:	85 c0                	test   %eax,%eax
80104c03:	0f 88 b1 00 00 00    	js     80104cba <sys_link+0xda>
80104c09:	8d 45 e0             	lea    -0x20(%ebp),%eax
80104c0c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104c10:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104c17:	e8 b4 fa ff ff       	call   801046d0 <argstr>
80104c1c:	85 c0                	test   %eax,%eax
80104c1e:	0f 88 96 00 00 00    	js     80104cba <sys_link+0xda>
    return -1;

  begin_op();
80104c24:	e8 67 df ff ff       	call   80102b90 <begin_op>
  if((ip = namei(old)) == 0){
80104c29:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104c2c:	89 04 24             	mov    %eax,(%esp)
80104c2f:	e8 5c d3 ff ff       	call   80101f90 <namei>
80104c34:	85 c0                	test   %eax,%eax
80104c36:	89 c3                	mov    %eax,%ebx
80104c38:	0f 84 d2 00 00 00    	je     80104d10 <sys_link+0x130>
    end_op();
    return -1;
  }

  ilock(ip);
80104c3e:	89 04 24             	mov    %eax,(%esp)
80104c41:	e8 7a ca ff ff       	call   801016c0 <ilock>
  if(ip->type == T_DIR){
80104c46:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104c4b:	0f 84 b7 00 00 00    	je     80104d08 <sys_link+0x128>
    iunlockput(ip);
    end_op();
    return -1;
  }

  ip->nlink++;
80104c51:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
80104c56:	8d 7d d2             	lea    -0x2e(%ebp),%edi
    end_op();
    return -1;
  }

  ip->nlink++;
  iupdate(ip);
80104c59:	89 1c 24             	mov    %ebx,(%esp)
80104c5c:	e8 9f c9 ff ff       	call   80101600 <iupdate>
  iunlock(ip);
80104c61:	89 1c 24             	mov    %ebx,(%esp)
80104c64:	e8 37 cb ff ff       	call   801017a0 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
80104c69:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104c6c:	89 7c 24 04          	mov    %edi,0x4(%esp)
80104c70:	89 04 24             	mov    %eax,(%esp)
80104c73:	e8 38 d3 ff ff       	call   80101fb0 <nameiparent>
80104c78:	85 c0                	test   %eax,%eax
80104c7a:	89 c6                	mov    %eax,%esi
80104c7c:	74 52                	je     80104cd0 <sys_link+0xf0>
    goto bad;
  ilock(dp);
80104c7e:	89 04 24             	mov    %eax,(%esp)
80104c81:	e8 3a ca ff ff       	call   801016c0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104c86:	8b 03                	mov    (%ebx),%eax
80104c88:	39 06                	cmp    %eax,(%esi)
80104c8a:	75 3c                	jne    80104cc8 <sys_link+0xe8>
80104c8c:	8b 43 04             	mov    0x4(%ebx),%eax
80104c8f:	89 7c 24 04          	mov    %edi,0x4(%esp)
80104c93:	89 34 24             	mov    %esi,(%esp)
80104c96:	89 44 24 08          	mov    %eax,0x8(%esp)
80104c9a:	e8 11 d2 ff ff       	call   80101eb0 <dirlink>
80104c9f:	85 c0                	test   %eax,%eax
80104ca1:	78 25                	js     80104cc8 <sys_link+0xe8>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
80104ca3:	89 34 24             	mov    %esi,(%esp)
  iput(ip);

  end_op();

  return 0;
80104ca6:	31 f6                	xor    %esi,%esi
  ilock(dp);
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
80104ca8:	e8 a3 cc ff ff       	call   80101950 <iunlockput>
  iput(ip);
80104cad:	89 1c 24             	mov    %ebx,(%esp)
80104cb0:	e8 3b cb ff ff       	call   801017f0 <iput>

  end_op();
80104cb5:	e8 46 df ff ff       	call   80102c00 <end_op>
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
80104cba:	83 c4 3c             	add    $0x3c,%esp
80104cbd:	89 f0                	mov    %esi,%eax
80104cbf:	5b                   	pop    %ebx
80104cc0:	5e                   	pop    %esi
80104cc1:	5f                   	pop    %edi
80104cc2:	5d                   	pop    %ebp
80104cc3:	c3                   	ret    
80104cc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
  ilock(dp);
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    iunlockput(dp);
80104cc8:	89 34 24             	mov    %esi,(%esp)
80104ccb:	e8 80 cc ff ff       	call   80101950 <iunlockput>
  end_op();

  return 0;

bad:
  ilock(ip);
80104cd0:	89 1c 24             	mov    %ebx,(%esp)
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
80104cd3:	be ff ff ff ff       	mov    $0xffffffff,%esi
  end_op();

  return 0;

bad:
  ilock(ip);
80104cd8:	e8 e3 c9 ff ff       	call   801016c0 <ilock>
  ip->nlink--;
80104cdd:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104ce2:	89 1c 24             	mov    %ebx,(%esp)
80104ce5:	e8 16 c9 ff ff       	call   80101600 <iupdate>
  iunlockput(ip);
80104cea:	89 1c 24             	mov    %ebx,(%esp)
80104ced:	e8 5e cc ff ff       	call   80101950 <iunlockput>
  end_op();
80104cf2:	e8 09 df ff ff       	call   80102c00 <end_op>
  return -1;
}
80104cf7:	83 c4 3c             	add    $0x3c,%esp
80104cfa:	89 f0                	mov    %esi,%eax
80104cfc:	5b                   	pop    %ebx
80104cfd:	5e                   	pop    %esi
80104cfe:	5f                   	pop    %edi
80104cff:	5d                   	pop    %ebp
80104d00:	c3                   	ret    
80104d01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  }

  ilock(ip);
  if(ip->type == T_DIR){
    iunlockput(ip);
80104d08:	89 1c 24             	mov    %ebx,(%esp)
80104d0b:	e8 40 cc ff ff       	call   80101950 <iunlockput>
    end_op();
80104d10:	e8 eb de ff ff       	call   80102c00 <end_op>
    return -1;
80104d15:	eb a3                	jmp    80104cba <sys_link+0xda>
80104d17:	89 f6                	mov    %esi,%esi
80104d19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d20 <sys_unlink>:
}

//PAGEBREAK!
int
sys_unlink(void)
{
80104d20:	55                   	push   %ebp
80104d21:	89 e5                	mov    %esp,%ebp
80104d23:	57                   	push   %edi
80104d24:	56                   	push   %esi
80104d25:	53                   	push   %ebx
80104d26:	83 ec 6c             	sub    $0x6c,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80104d29:	8d 45 e0             	lea    -0x20(%ebp),%eax
80104d2c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104d30:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104d37:	e8 94 f9 ff ff       	call   801046d0 <argstr>
80104d3c:	85 c0                	test   %eax,%eax
80104d3e:	0f 88 99 01 00 00    	js     80104edd <sys_unlink+0x1bd>
    return -1;

  begin_op();
80104d44:	e8 47 de ff ff       	call   80102b90 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80104d49:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104d4c:	8d 5d d2             	lea    -0x2e(%ebp),%ebx
80104d4f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104d53:	89 04 24             	mov    %eax,(%esp)
80104d56:	e8 55 d2 ff ff       	call   80101fb0 <nameiparent>
80104d5b:	85 c0                	test   %eax,%eax
80104d5d:	89 45 a4             	mov    %eax,-0x5c(%ebp)
80104d60:	0f 84 4d 01 00 00    	je     80104eb3 <sys_unlink+0x193>
    end_op();
    return -1;
  }

  ilock(dp);
80104d66:	8b 45 a4             	mov    -0x5c(%ebp),%eax
80104d69:	89 04 24             	mov    %eax,(%esp)
80104d6c:	e8 4f c9 ff ff       	call   801016c0 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80104d71:	c7 44 24 04 48 74 10 	movl   $0x80107448,0x4(%esp)
80104d78:	80 
80104d79:	89 1c 24             	mov    %ebx,(%esp)
80104d7c:	e8 9f ce ff ff       	call   80101c20 <namecmp>
80104d81:	85 c0                	test   %eax,%eax
80104d83:	0f 84 1f 01 00 00    	je     80104ea8 <sys_unlink+0x188>
80104d89:	c7 44 24 04 47 74 10 	movl   $0x80107447,0x4(%esp)
80104d90:	80 
80104d91:	89 1c 24             	mov    %ebx,(%esp)
80104d94:	e8 87 ce ff ff       	call   80101c20 <namecmp>
80104d99:	85 c0                	test   %eax,%eax
80104d9b:	0f 84 07 01 00 00    	je     80104ea8 <sys_unlink+0x188>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80104da1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80104da4:	89 44 24 08          	mov    %eax,0x8(%esp)
80104da8:	8b 45 a4             	mov    -0x5c(%ebp),%eax
80104dab:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104daf:	89 04 24             	mov    %eax,(%esp)
80104db2:	e8 99 ce ff ff       	call   80101c50 <dirlookup>
80104db7:	85 c0                	test   %eax,%eax
80104db9:	89 c6                	mov    %eax,%esi
80104dbb:	0f 84 e7 00 00 00    	je     80104ea8 <sys_unlink+0x188>
    goto bad;
  ilock(ip);
80104dc1:	89 04 24             	mov    %eax,(%esp)
80104dc4:	e8 f7 c8 ff ff       	call   801016c0 <ilock>

  if(ip->nlink < 1)
80104dc9:	66 83 7e 56 00       	cmpw   $0x0,0x56(%esi)
80104dce:	0f 8e 1f 01 00 00    	jle    80104ef3 <sys_unlink+0x1d3>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
80104dd4:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80104dd9:	74 7d                	je     80104e58 <sys_unlink+0x138>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
80104ddb:	8d 5d b2             	lea    -0x4e(%ebp),%ebx
80104dde:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80104de5:	00 
80104de6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80104ded:	00 
80104dee:	89 1c 24             	mov    %ebx,(%esp)
80104df1:	e8 3a f5 ff ff       	call   80104330 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104df6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104df9:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80104e00:	00 
80104e01:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104e05:	89 44 24 08          	mov    %eax,0x8(%esp)
80104e09:	8b 45 a4             	mov    -0x5c(%ebp),%eax
80104e0c:	89 04 24             	mov    %eax,(%esp)
80104e0f:	e8 bc cc ff ff       	call   80101ad0 <writei>
80104e14:	83 f8 10             	cmp    $0x10,%eax
80104e17:	0f 85 e2 00 00 00    	jne    80104eff <sys_unlink+0x1df>
    panic("unlink: writei");
  if(ip->type == T_DIR){
80104e1d:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80104e22:	0f 84 a0 00 00 00    	je     80104ec8 <sys_unlink+0x1a8>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
80104e28:	8b 45 a4             	mov    -0x5c(%ebp),%eax
80104e2b:	89 04 24             	mov    %eax,(%esp)
80104e2e:	e8 1d cb ff ff       	call   80101950 <iunlockput>

  ip->nlink--;
80104e33:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
  iupdate(ip);
80104e38:	89 34 24             	mov    %esi,(%esp)
80104e3b:	e8 c0 c7 ff ff       	call   80101600 <iupdate>
  iunlockput(ip);
80104e40:	89 34 24             	mov    %esi,(%esp)
80104e43:	e8 08 cb ff ff       	call   80101950 <iunlockput>

  end_op();
80104e48:	e8 b3 dd ff ff       	call   80102c00 <end_op>

  return 0;
80104e4d:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
80104e4f:	83 c4 6c             	add    $0x6c,%esp
80104e52:	5b                   	pop    %ebx
80104e53:	5e                   	pop    %esi
80104e54:	5f                   	pop    %edi
80104e55:	5d                   	pop    %ebp
80104e56:	c3                   	ret    
80104e57:	90                   	nop
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80104e58:	83 7e 58 20          	cmpl   $0x20,0x58(%esi)
80104e5c:	0f 86 79 ff ff ff    	jbe    80104ddb <sys_unlink+0xbb>
80104e62:	bb 20 00 00 00       	mov    $0x20,%ebx
80104e67:	8d 7d c2             	lea    -0x3e(%ebp),%edi
80104e6a:	eb 10                	jmp    80104e7c <sys_unlink+0x15c>
80104e6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e70:	83 c3 10             	add    $0x10,%ebx
80104e73:	3b 5e 58             	cmp    0x58(%esi),%ebx
80104e76:	0f 83 5f ff ff ff    	jae    80104ddb <sys_unlink+0xbb>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104e7c:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80104e83:	00 
80104e84:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80104e88:	89 7c 24 04          	mov    %edi,0x4(%esp)
80104e8c:	89 34 24             	mov    %esi,(%esp)
80104e8f:	e8 0c cb ff ff       	call   801019a0 <readi>
80104e94:	83 f8 10             	cmp    $0x10,%eax
80104e97:	75 4e                	jne    80104ee7 <sys_unlink+0x1c7>
      panic("isdirempty: readi");
    if(de.inum != 0)
80104e99:	66 83 7d c2 00       	cmpw   $0x0,-0x3e(%ebp)
80104e9e:	74 d0                	je     80104e70 <sys_unlink+0x150>
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
    iunlockput(ip);
80104ea0:	89 34 24             	mov    %esi,(%esp)
80104ea3:	e8 a8 ca ff ff       	call   80101950 <iunlockput>
  end_op();

  return 0;

bad:
  iunlockput(dp);
80104ea8:	8b 45 a4             	mov    -0x5c(%ebp),%eax
80104eab:	89 04 24             	mov    %eax,(%esp)
80104eae:	e8 9d ca ff ff       	call   80101950 <iunlockput>
  end_op();
80104eb3:	e8 48 dd ff ff       	call   80102c00 <end_op>
  return -1;
}
80104eb8:	83 c4 6c             	add    $0x6c,%esp
  return 0;

bad:
  iunlockput(dp);
  end_op();
  return -1;
80104ebb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104ec0:	5b                   	pop    %ebx
80104ec1:	5e                   	pop    %esi
80104ec2:	5f                   	pop    %edi
80104ec3:	5d                   	pop    %ebp
80104ec4:	c3                   	ret    
80104ec5:	8d 76 00             	lea    0x0(%esi),%esi

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
80104ec8:	8b 45 a4             	mov    -0x5c(%ebp),%eax
80104ecb:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
80104ed0:	89 04 24             	mov    %eax,(%esp)
80104ed3:	e8 28 c7 ff ff       	call   80101600 <iupdate>
80104ed8:	e9 4b ff ff ff       	jmp    80104e28 <sys_unlink+0x108>
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
    return -1;
80104edd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ee2:	e9 68 ff ff ff       	jmp    80104e4f <sys_unlink+0x12f>
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
80104ee7:	c7 04 24 78 74 10 80 	movl   $0x80107478,(%esp)
80104eee:	e8 7d b4 ff ff       	call   80100370 <panic>
  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
80104ef3:	c7 04 24 66 74 10 80 	movl   $0x80107466,(%esp)
80104efa:	e8 71 b4 ff ff       	call   80100370 <panic>
    goto bad;
  }

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
80104eff:	c7 04 24 8a 74 10 80 	movl   $0x8010748a,(%esp)
80104f06:	e8 65 b4 ff ff       	call   80100370 <panic>
80104f0b:	90                   	nop
80104f0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104f10 <sys_open>:
  return ip;
}

int
sys_open(void)
{
80104f10:	55                   	push   %ebp
80104f11:	89 e5                	mov    %esp,%ebp
80104f13:	57                   	push   %edi
80104f14:	56                   	push   %esi
80104f15:	53                   	push   %ebx
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
    return -1;
80104f16:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  return ip;
}

int
sys_open(void)
{
80104f1b:	83 ec 2c             	sub    $0x2c,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80104f1e:	8d 45 e0             	lea    -0x20(%ebp),%eax
80104f21:	89 44 24 04          	mov    %eax,0x4(%esp)
80104f25:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104f2c:	e8 9f f7 ff ff       	call   801046d0 <argstr>
80104f31:	85 c0                	test   %eax,%eax
80104f33:	0f 88 8c 00 00 00    	js     80104fc5 <sys_open+0xb5>
80104f39:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80104f3c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104f40:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104f47:	e8 e4 f6 ff ff       	call   80104630 <argint>
80104f4c:	85 c0                	test   %eax,%eax
80104f4e:	78 75                	js     80104fc5 <sys_open+0xb5>
    return -1;

  begin_op();
80104f50:	e8 3b dc ff ff       	call   80102b90 <begin_op>

  if(omode & O_CREATE){
80104f55:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80104f59:	75 75                	jne    80104fd0 <sys_open+0xc0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80104f5b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104f5e:	89 04 24             	mov    %eax,(%esp)
80104f61:	e8 2a d0 ff ff       	call   80101f90 <namei>
80104f66:	85 c0                	test   %eax,%eax
80104f68:	89 c7                	mov    %eax,%edi
80104f6a:	0f 84 8f 00 00 00    	je     80104fff <sys_open+0xef>
      end_op();
      return -1;
    }
    ilock(ip);
80104f70:	89 04 24             	mov    %eax,(%esp)
80104f73:	e8 48 c7 ff ff       	call   801016c0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80104f78:	66 83 7f 50 01       	cmpw   $0x1,0x50(%edi)
80104f7d:	74 71                	je     80104ff0 <sys_open+0xe0>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80104f7f:	e8 dc bd ff ff       	call   80100d60 <filealloc>
80104f84:	85 c0                	test   %eax,%eax
80104f86:	89 c6                	mov    %eax,%esi
80104f88:	0f 84 87 00 00 00    	je     80105015 <sys_open+0x105>
80104f8e:	e8 fd f7 ff ff       	call   80104790 <fdalloc>
80104f93:	85 c0                	test   %eax,%eax
80104f95:	89 c3                	mov    %eax,%ebx
80104f97:	78 6f                	js     80105008 <sys_open+0xf8>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80104f99:	89 3c 24             	mov    %edi,(%esp)
80104f9c:	e8 ff c7 ff ff       	call   801017a0 <iunlock>
  end_op();
80104fa1:	e8 5a dc ff ff       	call   80102c00 <end_op>

  f->type = FD_INODE;
80104fa6:	c7 06 02 00 00 00    	movl   $0x2,(%esi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80104fac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  }
  iunlock(ip);
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
80104faf:	89 7e 10             	mov    %edi,0x10(%esi)
  f->off = 0;
80104fb2:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
  f->readable = !(omode & O_WRONLY);
80104fb9:	a8 01                	test   $0x1,%al
80104fbb:	0f 94 46 08          	sete   0x8(%esi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80104fbf:	a8 03                	test   $0x3,%al
80104fc1:	0f 95 46 09          	setne  0x9(%esi)
  return fd;
}
80104fc5:	83 c4 2c             	add    $0x2c,%esp
80104fc8:	89 d8                	mov    %ebx,%eax
80104fca:	5b                   	pop    %ebx
80104fcb:	5e                   	pop    %esi
80104fcc:	5f                   	pop    %edi
80104fcd:	5d                   	pop    %ebp
80104fce:	c3                   	ret    
80104fcf:	90                   	nop
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
80104fd0:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104fd3:	31 c9                	xor    %ecx,%ecx
80104fd5:	ba 02 00 00 00       	mov    $0x2,%edx
80104fda:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104fe1:	e8 ea f7 ff ff       	call   801047d0 <create>
    if(ip == 0){
80104fe6:	85 c0                	test   %eax,%eax
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
80104fe8:	89 c7                	mov    %eax,%edi
    if(ip == 0){
80104fea:	75 93                	jne    80104f7f <sys_open+0x6f>
80104fec:	eb 11                	jmp    80104fff <sys_open+0xef>
80104fee:	66 90                	xchg   %ax,%ax
    if((ip = namei(path)) == 0){
      end_op();
      return -1;
    }
    ilock(ip);
    if(ip->type == T_DIR && omode != O_RDONLY){
80104ff0:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80104ff3:	85 f6                	test   %esi,%esi
80104ff5:	74 88                	je     80104f7f <sys_open+0x6f>
      iunlockput(ip);
80104ff7:	89 3c 24             	mov    %edi,(%esp)
80104ffa:	e8 51 c9 ff ff       	call   80101950 <iunlockput>
      end_op();
80104fff:	e8 fc db ff ff       	call   80102c00 <end_op>
      return -1;
80105004:	eb bf                	jmp    80104fc5 <sys_open+0xb5>
80105006:	66 90                	xchg   %ax,%ax
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
80105008:	89 34 24             	mov    %esi,(%esp)
8010500b:	90                   	nop
8010500c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105010:	e8 0b be ff ff       	call   80100e20 <fileclose>
    iunlockput(ip);
80105015:	89 3c 24             	mov    %edi,(%esp)
    end_op();
    return -1;
80105018:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    iunlockput(ip);
8010501d:	e8 2e c9 ff ff       	call   80101950 <iunlockput>
    end_op();
80105022:	e8 d9 db ff ff       	call   80102c00 <end_op>
    return -1;
80105027:	eb 9c                	jmp    80104fc5 <sys_open+0xb5>
80105029:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105030 <sys_mkdir>:
  return fd;
}

int
sys_mkdir(void)
{
80105030:	55                   	push   %ebp
80105031:	89 e5                	mov    %esp,%ebp
80105033:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105036:	e8 55 db ff ff       	call   80102b90 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010503b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010503e:	89 44 24 04          	mov    %eax,0x4(%esp)
80105042:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105049:	e8 82 f6 ff ff       	call   801046d0 <argstr>
8010504e:	85 c0                	test   %eax,%eax
80105050:	78 2e                	js     80105080 <sys_mkdir+0x50>
80105052:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105055:	31 c9                	xor    %ecx,%ecx
80105057:	ba 01 00 00 00       	mov    $0x1,%edx
8010505c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105063:	e8 68 f7 ff ff       	call   801047d0 <create>
80105068:	85 c0                	test   %eax,%eax
8010506a:	74 14                	je     80105080 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010506c:	89 04 24             	mov    %eax,(%esp)
8010506f:	e8 dc c8 ff ff       	call   80101950 <iunlockput>
  end_op();
80105074:	e8 87 db ff ff       	call   80102c00 <end_op>
  return 0;
80105079:	31 c0                	xor    %eax,%eax
}
8010507b:	c9                   	leave  
8010507c:	c3                   	ret    
8010507d:	8d 76 00             	lea    0x0(%esi),%esi
  char *path;
  struct inode *ip;

  begin_op();
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    end_op();
80105080:	e8 7b db ff ff       	call   80102c00 <end_op>
    return -1;
80105085:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
8010508a:	c9                   	leave  
8010508b:	c3                   	ret    
8010508c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105090 <sys_mknod>:

int
sys_mknod(void)
{
80105090:	55                   	push   %ebp
80105091:	89 e5                	mov    %esp,%ebp
80105093:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105096:	e8 f5 da ff ff       	call   80102b90 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010509b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010509e:	89 44 24 04          	mov    %eax,0x4(%esp)
801050a2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801050a9:	e8 22 f6 ff ff       	call   801046d0 <argstr>
801050ae:	85 c0                	test   %eax,%eax
801050b0:	78 5e                	js     80105110 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
801050b2:	8d 45 f0             	lea    -0x10(%ebp),%eax
801050b5:	89 44 24 04          	mov    %eax,0x4(%esp)
801050b9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801050c0:	e8 6b f5 ff ff       	call   80104630 <argint>
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
801050c5:	85 c0                	test   %eax,%eax
801050c7:	78 47                	js     80105110 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
801050c9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801050cc:	89 44 24 04          	mov    %eax,0x4(%esp)
801050d0:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
801050d7:	e8 54 f5 ff ff       	call   80104630 <argint>
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
801050dc:	85 c0                	test   %eax,%eax
801050de:	78 30                	js     80105110 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
801050e0:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
801050e4:	ba 03 00 00 00       	mov    $0x3,%edx
     (ip = create(path, T_DEV, major, minor)) == 0){
801050e9:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
801050ed:	89 04 24             	mov    %eax,(%esp)
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
801050f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801050f3:	e8 d8 f6 ff ff       	call   801047d0 <create>
801050f8:	85 c0                	test   %eax,%eax
801050fa:	74 14                	je     80105110 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
    return -1;
  }
  iunlockput(ip);
801050fc:	89 04 24             	mov    %eax,(%esp)
801050ff:	e8 4c c8 ff ff       	call   80101950 <iunlockput>
  end_op();
80105104:	e8 f7 da ff ff       	call   80102c00 <end_op>
  return 0;
80105109:	31 c0                	xor    %eax,%eax
}
8010510b:	c9                   	leave  
8010510c:	c3                   	ret    
8010510d:	8d 76 00             	lea    0x0(%esi),%esi
  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
80105110:	e8 eb da ff ff       	call   80102c00 <end_op>
    return -1;
80105115:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
8010511a:	c9                   	leave  
8010511b:	c3                   	ret    
8010511c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105120 <sys_chdir>:

int
sys_chdir(void)
{
80105120:	55                   	push   %ebp
80105121:	89 e5                	mov    %esp,%ebp
80105123:	56                   	push   %esi
80105124:	53                   	push   %ebx
80105125:	83 ec 20             	sub    $0x20,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105128:	e8 23 e6 ff ff       	call   80103750 <myproc>
8010512d:	89 c3                	mov    %eax,%ebx
  
  begin_op();
8010512f:	e8 5c da ff ff       	call   80102b90 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105134:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105137:	89 44 24 04          	mov    %eax,0x4(%esp)
8010513b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105142:	e8 89 f5 ff ff       	call   801046d0 <argstr>
80105147:	85 c0                	test   %eax,%eax
80105149:	78 4a                	js     80105195 <sys_chdir+0x75>
8010514b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010514e:	89 04 24             	mov    %eax,(%esp)
80105151:	e8 3a ce ff ff       	call   80101f90 <namei>
80105156:	85 c0                	test   %eax,%eax
80105158:	89 c6                	mov    %eax,%esi
8010515a:	74 39                	je     80105195 <sys_chdir+0x75>
    end_op();
    return -1;
  }
  ilock(ip);
8010515c:	89 04 24             	mov    %eax,(%esp)
8010515f:	e8 5c c5 ff ff       	call   801016c0 <ilock>
  if(ip->type != T_DIR){
80105164:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
    iunlockput(ip);
80105169:	89 34 24             	mov    %esi,(%esp)
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
    end_op();
    return -1;
  }
  ilock(ip);
  if(ip->type != T_DIR){
8010516c:	75 22                	jne    80105190 <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
8010516e:	e8 2d c6 ff ff       	call   801017a0 <iunlock>
  iput(curproc->cwd);
80105173:	8b 43 68             	mov    0x68(%ebx),%eax
80105176:	89 04 24             	mov    %eax,(%esp)
80105179:	e8 72 c6 ff ff       	call   801017f0 <iput>
  end_op();
8010517e:	e8 7d da ff ff       	call   80102c00 <end_op>
  curproc->cwd = ip;
  return 0;
80105183:	31 c0                	xor    %eax,%eax
    return -1;
  }
  iunlock(ip);
  iput(curproc->cwd);
  end_op();
  curproc->cwd = ip;
80105185:	89 73 68             	mov    %esi,0x68(%ebx)
  return 0;
}
80105188:	83 c4 20             	add    $0x20,%esp
8010518b:	5b                   	pop    %ebx
8010518c:	5e                   	pop    %esi
8010518d:	5d                   	pop    %ebp
8010518e:	c3                   	ret    
8010518f:	90                   	nop
    end_op();
    return -1;
  }
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
80105190:	e8 bb c7 ff ff       	call   80101950 <iunlockput>
    end_op();
80105195:	e8 66 da ff ff       	call   80102c00 <end_op>
  iunlock(ip);
  iput(curproc->cwd);
  end_op();
  curproc->cwd = ip;
  return 0;
}
8010519a:	83 c4 20             	add    $0x20,%esp
  }
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
    end_op();
    return -1;
8010519d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  iunlock(ip);
  iput(curproc->cwd);
  end_op();
  curproc->cwd = ip;
  return 0;
}
801051a2:	5b                   	pop    %ebx
801051a3:	5e                   	pop    %esi
801051a4:	5d                   	pop    %ebp
801051a5:	c3                   	ret    
801051a6:	8d 76 00             	lea    0x0(%esi),%esi
801051a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801051b0 <sys_exec>:

int
sys_exec(void)
{
801051b0:	55                   	push   %ebp
801051b1:	89 e5                	mov    %esp,%ebp
801051b3:	57                   	push   %edi
801051b4:	56                   	push   %esi
801051b5:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
801051b6:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  return 0;
}

int
sys_exec(void)
{
801051bb:	81 ec ac 00 00 00    	sub    $0xac,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801051c1:	8d 45 dc             	lea    -0x24(%ebp),%eax
801051c4:	89 44 24 04          	mov    %eax,0x4(%esp)
801051c8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801051cf:	e8 fc f4 ff ff       	call   801046d0 <argstr>
801051d4:	85 c0                	test   %eax,%eax
801051d6:	0f 88 82 00 00 00    	js     8010525e <sys_exec+0xae>
801051dc:	8d 45 e0             	lea    -0x20(%ebp),%eax
801051df:	89 44 24 04          	mov    %eax,0x4(%esp)
801051e3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801051ea:	e8 41 f4 ff ff       	call   80104630 <argint>
801051ef:	85 c0                	test   %eax,%eax
801051f1:	78 6b                	js     8010525e <sys_exec+0xae>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801051f3:	8d bd 5c ff ff ff    	lea    -0xa4(%ebp),%edi
  for(i=0;; i++){
    if(i >= NELEM(argv))
801051f9:	31 f6                	xor    %esi,%esi
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801051fb:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
80105202:	00 
  for(i=0;; i++){
80105203:	31 db                	xor    %ebx,%ebx
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105205:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010520c:	00 
8010520d:	89 3c 24             	mov    %edi,(%esp)
80105210:	e8 1b f1 ff ff       	call   80104330 <memset>
80105215:	8d 76 00             	lea    0x0(%esi),%esi
  for(i=0;; i++){
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105218:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010521b:	89 44 24 04          	mov    %eax,0x4(%esp)
  curproc->cwd = ip;
  return 0;
}

int
sys_exec(void)
8010521f:	8d 04 9d 00 00 00 00 	lea    0x0(,%ebx,4),%eax
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105226:	03 45 e0             	add    -0x20(%ebp),%eax
80105229:	89 04 24             	mov    %eax,(%esp)
8010522c:	e8 6f f3 ff ff       	call   801045a0 <fetchint>
80105231:	85 c0                	test   %eax,%eax
80105233:	78 24                	js     80105259 <sys_exec+0xa9>
      return -1;
    if(uarg == 0){
80105235:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105238:	85 c0                	test   %eax,%eax
8010523a:	74 34                	je     80105270 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
8010523c:	8d 14 b7             	lea    (%edi,%esi,4),%edx
8010523f:	89 54 24 04          	mov    %edx,0x4(%esp)
80105243:	89 04 24             	mov    %eax,(%esp)
80105246:	e8 85 f3 ff ff       	call   801045d0 <fetchstr>
8010524b:	85 c0                	test   %eax,%eax
8010524d:	78 0a                	js     80105259 <sys_exec+0xa9>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
8010524f:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105252:	83 fb 20             	cmp    $0x20,%ebx
80105255:	89 de                	mov    %ebx,%esi
80105257:	75 bf                	jne    80105218 <sys_exec+0x68>
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
80105259:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  }
  return exec(path, argv);
}
8010525e:	81 c4 ac 00 00 00    	add    $0xac,%esp
80105264:	89 d8                	mov    %ebx,%eax
80105266:	5b                   	pop    %ebx
80105267:	5e                   	pop    %esi
80105268:	5f                   	pop    %edi
80105269:	5d                   	pop    %ebp
8010526a:	c3                   	ret    
8010526b:	90                   	nop
8010526c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80105270:	8b 45 dc             	mov    -0x24(%ebp),%eax
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
80105273:	c7 84 9d 5c ff ff ff 	movl   $0x0,-0xa4(%ebp,%ebx,4)
8010527a:	00 00 00 00 
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
8010527e:	89 7c 24 04          	mov    %edi,0x4(%esp)
80105282:	89 04 24             	mov    %eax,(%esp)
80105285:	e8 26 b7 ff ff       	call   801009b0 <exec>
}
8010528a:	81 c4 ac 00 00 00    	add    $0xac,%esp
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80105290:	89 c3                	mov    %eax,%ebx
}
80105292:	89 d8                	mov    %ebx,%eax
80105294:	5b                   	pop    %ebx
80105295:	5e                   	pop    %esi
80105296:	5f                   	pop    %edi
80105297:	5d                   	pop    %ebp
80105298:	c3                   	ret    
80105299:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801052a0 <sys_pipe>:

int
sys_pipe(void)
{
801052a0:	55                   	push   %ebp
801052a1:	89 e5                	mov    %esp,%ebp
801052a3:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
801052a4:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  return exec(path, argv);
}

int
sys_pipe(void)
{
801052a9:	83 ec 24             	sub    $0x24,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801052ac:	8d 45 ec             	lea    -0x14(%ebp),%eax
801052af:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
801052b6:	00 
801052b7:	89 44 24 04          	mov    %eax,0x4(%esp)
801052bb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801052c2:	e8 a9 f3 ff ff       	call   80104670 <argptr>
801052c7:	85 c0                	test   %eax,%eax
801052c9:	78 3d                	js     80105308 <sys_pipe+0x68>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
801052cb:	8d 45 f4             	lea    -0xc(%ebp),%eax
801052ce:	89 44 24 04          	mov    %eax,0x4(%esp)
801052d2:	8d 45 f0             	lea    -0x10(%ebp),%eax
801052d5:	89 04 24             	mov    %eax,(%esp)
801052d8:	e8 13 df ff ff       	call   801031f0 <pipealloc>
801052dd:	85 c0                	test   %eax,%eax
801052df:	78 27                	js     80105308 <sys_pipe+0x68>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801052e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801052e4:	e8 a7 f4 ff ff       	call   80104790 <fdalloc>
801052e9:	85 c0                	test   %eax,%eax
801052eb:	89 c3                	mov    %eax,%ebx
801052ed:	78 2e                	js     8010531d <sys_pipe+0x7d>
801052ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801052f2:	e8 99 f4 ff ff       	call   80104790 <fdalloc>
801052f7:	85 c0                	test   %eax,%eax
801052f9:	78 15                	js     80105310 <sys_pipe+0x70>
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
801052fb:	8b 55 ec             	mov    -0x14(%ebp),%edx
801052fe:	89 1a                	mov    %ebx,(%edx)
  fd[1] = fd1;
80105300:	8b 55 ec             	mov    -0x14(%ebp),%edx
  return 0;
80105303:	31 db                	xor    %ebx,%ebx
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
  fd[1] = fd1;
80105305:	89 42 04             	mov    %eax,0x4(%edx)
  return 0;
}
80105308:	83 c4 24             	add    $0x24,%esp
8010530b:	89 d8                	mov    %ebx,%eax
8010530d:	5b                   	pop    %ebx
8010530e:	5d                   	pop    %ebp
8010530f:	c3                   	ret    
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
80105310:	e8 3b e4 ff ff       	call   80103750 <myproc>
80105315:	c7 44 98 28 00 00 00 	movl   $0x0,0x28(%eax,%ebx,4)
8010531c:	00 
    fileclose(rf);
8010531d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    fileclose(wf);
    return -1;
80105320:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105325:	89 04 24             	mov    %eax,(%esp)
80105328:	e8 f3 ba ff ff       	call   80100e20 <fileclose>
    fileclose(wf);
8010532d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105330:	89 04 24             	mov    %eax,(%esp)
80105333:	e8 e8 ba ff ff       	call   80100e20 <fileclose>
    return -1;
80105338:	eb ce                	jmp    80105308 <sys_pipe+0x68>
8010533a:	00 00                	add    %al,(%eax)
8010533c:	00 00                	add    %al,(%eax)
	...

80105340 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105340:	55                   	push   %ebp
80105341:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105343:	5d                   	pop    %ebp
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80105344:	e9 b7 e5 ff ff       	jmp    80103900 <fork>
80105349:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105350 <sys_exit>:
}

int
sys_exit(void)
{
80105350:	55                   	push   %ebp
80105351:	89 e5                	mov    %esp,%ebp
80105353:	83 ec 08             	sub    $0x8,%esp
  exit();
80105356:	e8 f5 e7 ff ff       	call   80103b50 <exit>
  return 0;  // not reached
}
8010535b:	31 c0                	xor    %eax,%eax
8010535d:	c9                   	leave  
8010535e:	c3                   	ret    
8010535f:	90                   	nop

80105360 <sys_wait>:

int
sys_wait(void)
{
80105360:	55                   	push   %ebp
80105361:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105363:	5d                   	pop    %ebp
}

int
sys_wait(void)
{
  return wait();
80105364:	e9 07 ea ff ff       	jmp    80103d70 <wait>
80105369:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105370 <sys_kill>:
}

int
sys_kill(void)
{
80105370:	55                   	push   %ebp
80105371:	89 e5                	mov    %esp,%ebp
80105373:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105376:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105379:	89 44 24 04          	mov    %eax,0x4(%esp)
8010537d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105384:	e8 a7 f2 ff ff       	call   80104630 <argint>
80105389:	89 c2                	mov    %eax,%edx
    return -1;
8010538b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
int
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
80105390:	85 d2                	test   %edx,%edx
80105392:	78 0b                	js     8010539f <sys_kill+0x2f>
    return -1;
  return kill(pid);
80105394:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105397:	89 04 24             	mov    %eax,(%esp)
8010539a:	e8 11 eb ff ff       	call   80103eb0 <kill>
}
8010539f:	c9                   	leave  
801053a0:	c3                   	ret    
801053a1:	eb 0d                	jmp    801053b0 <sys_getpid>
801053a3:	90                   	nop
801053a4:	90                   	nop
801053a5:	90                   	nop
801053a6:	90                   	nop
801053a7:	90                   	nop
801053a8:	90                   	nop
801053a9:	90                   	nop
801053aa:	90                   	nop
801053ab:	90                   	nop
801053ac:	90                   	nop
801053ad:	90                   	nop
801053ae:	90                   	nop
801053af:	90                   	nop

801053b0 <sys_getpid>:

int
sys_getpid(void)
{
801053b0:	55                   	push   %ebp
801053b1:	89 e5                	mov    %esp,%ebp
801053b3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
801053b6:	e8 95 e3 ff ff       	call   80103750 <myproc>
801053bb:	8b 40 10             	mov    0x10(%eax),%eax
}
801053be:	c9                   	leave  
801053bf:	c3                   	ret    

801053c0 <sys_sbrk>:

int
sys_sbrk(void)
{
801053c0:	55                   	push   %ebp
801053c1:	89 e5                	mov    %esp,%ebp
801053c3:	83 ec 28             	sub    $0x28,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
801053c6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  return myproc()->pid;
}

int
sys_sbrk(void)
{
801053c9:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
801053cc:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  return myproc()->pid;
}

int
sys_sbrk(void)
{
801053d1:	89 75 fc             	mov    %esi,-0x4(%ebp)
  int addr;
  int n;

  if(argint(0, &n) < 0)
801053d4:	89 44 24 04          	mov    %eax,0x4(%esp)
801053d8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801053df:	e8 4c f2 ff ff       	call   80104630 <argint>
801053e4:	85 c0                	test   %eax,%eax
801053e6:	78 17                	js     801053ff <sys_sbrk+0x3f>
    return -1;
  addr = myproc()->sz;
801053e8:	e8 63 e3 ff ff       	call   80103750 <myproc>
801053ed:	8b 30                	mov    (%eax),%esi
  if(growproc(n) < 0)
801053ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053f2:	89 04 24             	mov    %eax,(%esp)
801053f5:	e8 86 e4 ff ff       	call   80103880 <growproc>
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
801053fa:	85 c0                	test   %eax,%eax
801053fc:	0f 49 de             	cmovns %esi,%ebx
  if(growproc(n) < 0)
    return -1;
  return addr;
}
801053ff:	89 d8                	mov    %ebx,%eax
80105401:	8b 75 fc             	mov    -0x4(%ebp),%esi
80105404:	8b 5d f8             	mov    -0x8(%ebp),%ebx
80105407:	89 ec                	mov    %ebp,%esp
80105409:	5d                   	pop    %ebp
8010540a:	c3                   	ret    
8010540b:	90                   	nop
8010540c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105410 <sys_sleep>:

int
sys_sleep(void)
{
80105410:	55                   	push   %ebp
80105411:	89 e5                	mov    %esp,%ebp
80105413:	53                   	push   %ebx
80105414:	83 ec 24             	sub    $0x24,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105417:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010541a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010541e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105425:	e8 06 f2 ff ff       	call   80104630 <argint>
    return -1;
8010542a:	ba ff ff ff ff       	mov    $0xffffffff,%edx
sys_sleep(void)
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
8010542f:	85 c0                	test   %eax,%eax
80105431:	78 5a                	js     8010548d <sys_sleep+0x7d>
    return -1;
  acquire(&tickslock);
80105433:	c7 04 24 60 4c 11 80 	movl   $0x80114c60,(%esp)
8010543a:	e8 c1 ed ff ff       	call   80104200 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010543f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
80105442:	8b 1d a0 54 11 80    	mov    0x801154a0,%ebx
  while(ticks - ticks0 < n){
80105448:	85 d2                	test   %edx,%edx
8010544a:	75 24                	jne    80105470 <sys_sleep+0x60>
8010544c:	eb 4a                	jmp    80105498 <sys_sleep+0x88>
8010544e:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105450:	c7 44 24 04 60 4c 11 	movl   $0x80114c60,0x4(%esp)
80105457:	80 
80105458:	c7 04 24 a0 54 11 80 	movl   $0x801154a0,(%esp)
8010545f:	e8 4c e8 ff ff       	call   80103cb0 <sleep>

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105464:	a1 a0 54 11 80       	mov    0x801154a0,%eax
80105469:	29 d8                	sub    %ebx,%eax
8010546b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010546e:	73 28                	jae    80105498 <sys_sleep+0x88>
    if(myproc()->killed){
80105470:	e8 db e2 ff ff       	call   80103750 <myproc>
80105475:	8b 40 24             	mov    0x24(%eax),%eax
80105478:	85 c0                	test   %eax,%eax
8010547a:	74 d4                	je     80105450 <sys_sleep+0x40>
      release(&tickslock);
8010547c:	c7 04 24 60 4c 11 80 	movl   $0x80114c60,(%esp)
80105483:	e8 58 ee ff ff       	call   801042e0 <release>
      return -1;
80105488:	ba ff ff ff ff       	mov    $0xffffffff,%edx
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}
8010548d:	83 c4 24             	add    $0x24,%esp
80105490:	89 d0                	mov    %edx,%eax
80105492:	5b                   	pop    %ebx
80105493:	5d                   	pop    %ebp
80105494:	c3                   	ret    
80105495:	8d 76 00             	lea    0x0(%esi),%esi
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
80105498:	c7 04 24 60 4c 11 80 	movl   $0x80114c60,(%esp)
8010549f:	e8 3c ee ff ff       	call   801042e0 <release>
  return 0;
}
801054a4:	83 c4 24             	add    $0x24,%esp
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
801054a7:	31 d2                	xor    %edx,%edx
}
801054a9:	89 d0                	mov    %edx,%eax
801054ab:	5b                   	pop    %ebx
801054ac:	5d                   	pop    %ebp
801054ad:	c3                   	ret    
801054ae:	66 90                	xchg   %ax,%ax

801054b0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801054b0:	55                   	push   %ebp
801054b1:	89 e5                	mov    %esp,%ebp
801054b3:	53                   	push   %ebx
801054b4:	83 ec 14             	sub    $0x14,%esp
  uint xticks;

  acquire(&tickslock);
801054b7:	c7 04 24 60 4c 11 80 	movl   $0x80114c60,(%esp)
801054be:	e8 3d ed ff ff       	call   80104200 <acquire>
  xticks = ticks;
801054c3:	8b 1d a0 54 11 80    	mov    0x801154a0,%ebx
  release(&tickslock);
801054c9:	c7 04 24 60 4c 11 80 	movl   $0x80114c60,(%esp)
801054d0:	e8 0b ee ff ff       	call   801042e0 <release>
  return xticks;
}
801054d5:	83 c4 14             	add    $0x14,%esp
801054d8:	89 d8                	mov    %ebx,%eax
801054da:	5b                   	pop    %ebx
801054db:	5d                   	pop    %ebp
801054dc:	c3                   	ret    
801054dd:	00 00                	add    %al,(%eax)
	...

801054e0 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801054e0:	1e                   	push   %ds
  pushl %es
801054e1:	06                   	push   %es
  pushl %fs
801054e2:	0f a0                	push   %fs
  pushl %gs
801054e4:	0f a8                	push   %gs
  pushal
801054e6:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
801054e7:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801054eb:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801054ed:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
801054ef:	54                   	push   %esp
  call trap
801054f0:	e8 db 00 00 00       	call   801055d0 <trap>
  addl $4, %esp
801054f5:	83 c4 04             	add    $0x4,%esp

801054f8 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801054f8:	61                   	popa   
  popl %gs
801054f9:	0f a9                	pop    %gs
  popl %fs
801054fb:	0f a1                	pop    %fs
  popl %es
801054fd:	07                   	pop    %es
  popl %ds
801054fe:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801054ff:	83 c4 08             	add    $0x8,%esp
  iret
80105502:	cf                   	iret   
	...

80105510 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105510:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105511:	31 c0                	xor    %eax,%eax
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105513:	89 e5                	mov    %esp,%ebp
80105515:	ba a0 4c 11 80       	mov    $0x80114ca0,%edx
8010551a:	83 ec 18             	sub    $0x18,%esp
8010551d:	8d 76 00             	lea    0x0(%esi),%esi
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105520:	8b 0c 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%ecx
80105527:	66 89 0c c5 a0 4c 11 	mov    %cx,-0x7feeb360(,%eax,8)
8010552e:	80 
8010552f:	c1 e9 10             	shr    $0x10,%ecx
80105532:	66 c7 44 c2 02 08 00 	movw   $0x8,0x2(%edx,%eax,8)
80105539:	c6 44 c2 04 00       	movb   $0x0,0x4(%edx,%eax,8)
8010553e:	c6 44 c2 05 8e       	movb   $0x8e,0x5(%edx,%eax,8)
80105543:	66 89 4c c2 06       	mov    %cx,0x6(%edx,%eax,8)
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80105548:	83 c0 01             	add    $0x1,%eax
8010554b:	3d 00 01 00 00       	cmp    $0x100,%eax
80105550:	75 ce                	jne    80105520 <tvinit+0x10>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105552:	a1 08 a1 10 80       	mov    0x8010a108,%eax

  initlock(&tickslock, "time");
80105557:	c7 44 24 04 99 74 10 	movl   $0x80107499,0x4(%esp)
8010555e:	80 
8010555f:	c7 04 24 60 4c 11 80 	movl   $0x80114c60,(%esp)
{
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105566:	66 c7 05 a2 4e 11 80 	movw   $0x8,0x80114ea2
8010556d:	08 00 
8010556f:	66 a3 a0 4e 11 80    	mov    %ax,0x80114ea0
80105575:	c1 e8 10             	shr    $0x10,%eax
80105578:	c6 05 a4 4e 11 80 00 	movb   $0x0,0x80114ea4
8010557f:	c6 05 a5 4e 11 80 ef 	movb   $0xef,0x80114ea5
80105586:	66 a3 a6 4e 11 80    	mov    %ax,0x80114ea6

  initlock(&tickslock, "time");
8010558c:	e8 7f eb ff ff       	call   80104110 <initlock>
}
80105591:	c9                   	leave  
80105592:	c3                   	ret    
80105593:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105599:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801055a0 <idtinit>:

void
idtinit(void)
{
801055a0:	55                   	push   %ebp
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
  pd[1] = (uint)p;
801055a1:	b8 a0 4c 11 80       	mov    $0x80114ca0,%eax
801055a6:	89 e5                	mov    %esp,%ebp
801055a8:	83 ec 10             	sub    $0x10,%esp
static inline void
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
801055ab:	66 c7 45 fa ff 07    	movw   $0x7ff,-0x6(%ebp)
  pd[1] = (uint)p;
801055b1:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801055b5:	c1 e8 10             	shr    $0x10,%eax
801055b8:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
801055bc:	8d 45 fa             	lea    -0x6(%ebp),%eax
801055bf:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
801055c2:	c9                   	leave  
801055c3:	c3                   	ret    
801055c4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801055ca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801055d0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801055d0:	55                   	push   %ebp
801055d1:	89 e5                	mov    %esp,%ebp
801055d3:	83 ec 48             	sub    $0x48,%esp
801055d6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
801055d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801055dc:	89 75 f8             	mov    %esi,-0x8(%ebp)
801055df:	89 7d fc             	mov    %edi,-0x4(%ebp)
  if(tf->trapno == T_SYSCALL){
801055e2:	8b 43 30             	mov    0x30(%ebx),%eax
801055e5:	83 f8 40             	cmp    $0x40,%eax
801055e8:	0f 84 d2 01 00 00    	je     801057c0 <trap+0x1f0>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
801055ee:	83 e8 20             	sub    $0x20,%eax
801055f1:	83 f8 1f             	cmp    $0x1f,%eax
801055f4:	0f 86 fe 00 00 00    	jbe    801056f8 <trap+0x128>
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
801055fa:	e8 51 e1 ff ff       	call   80103750 <myproc>
801055ff:	85 c0                	test   %eax,%eax
80105601:	0f 84 10 02 00 00    	je     80105817 <trap+0x247>
80105607:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
8010560b:	0f 84 06 02 00 00    	je     80105817 <trap+0x247>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105611:	0f 20 d2             	mov    %cr2,%edx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105614:	8b 7b 38             	mov    0x38(%ebx),%edi
80105617:	89 55 dc             	mov    %edx,-0x24(%ebp)
8010561a:	e8 11 e1 ff ff       	call   80103730 <cpuid>
8010561f:	8b 4b 34             	mov    0x34(%ebx),%ecx
80105622:	89 c6                	mov    %eax,%esi
80105624:	8b 43 30             	mov    0x30(%ebx),%eax
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105627:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010562a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
8010562d:	e8 1e e1 ff ff       	call   80103750 <myproc>
80105632:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105635:	e8 16 e1 ff ff       	call   80103750 <myproc>
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010563a:	8b 55 dc             	mov    -0x24(%ebp),%edx
8010563d:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105640:	89 7c 24 18          	mov    %edi,0x18(%esp)
80105644:	89 74 24 14          	mov    %esi,0x14(%esp)
80105648:	89 54 24 1c          	mov    %edx,0x1c(%esp)
8010564c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010564f:	89 4c 24 10          	mov    %ecx,0x10(%esp)
80105653:	89 54 24 0c          	mov    %edx,0xc(%esp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105657:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010565a:	83 c2 6c             	add    $0x6c,%edx
8010565d:	89 54 24 08          	mov    %edx,0x8(%esp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105661:	8b 40 10             	mov    0x10(%eax),%eax
80105664:	c7 04 24 fc 74 10 80 	movl   $0x801074fc,(%esp)
8010566b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010566f:	e8 dc af ff ff       	call   80100650 <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80105674:	e8 d7 e0 ff ff       	call   80103750 <myproc>
80105679:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105680:	e8 cb e0 ff ff       	call   80103750 <myproc>
80105685:	85 c0                	test   %eax,%eax
80105687:	74 1c                	je     801056a5 <trap+0xd5>
80105689:	e8 c2 e0 ff ff       	call   80103750 <myproc>
8010568e:	8b 50 24             	mov    0x24(%eax),%edx
80105691:	85 d2                	test   %edx,%edx
80105693:	74 10                	je     801056a5 <trap+0xd5>
80105695:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105699:	83 e0 03             	and    $0x3,%eax
8010569c:	83 f8 03             	cmp    $0x3,%eax
8010569f:	0f 84 5b 01 00 00    	je     80105800 <trap+0x230>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
801056a5:	e8 a6 e0 ff ff       	call   80103750 <myproc>
801056aa:	85 c0                	test   %eax,%eax
801056ac:	74 11                	je     801056bf <trap+0xef>
801056ae:	66 90                	xchg   %ax,%ax
801056b0:	e8 9b e0 ff ff       	call   80103750 <myproc>
801056b5:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
801056b9:	0f 84 e1 00 00 00    	je     801057a0 <trap+0x1d0>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801056bf:	e8 8c e0 ff ff       	call   80103750 <myproc>
801056c4:	85 c0                	test   %eax,%eax
801056c6:	74 1c                	je     801056e4 <trap+0x114>
801056c8:	e8 83 e0 ff ff       	call   80103750 <myproc>
801056cd:	8b 40 24             	mov    0x24(%eax),%eax
801056d0:	85 c0                	test   %eax,%eax
801056d2:	74 10                	je     801056e4 <trap+0x114>
801056d4:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801056d8:	83 e0 03             	and    $0x3,%eax
801056db:	83 f8 03             	cmp    $0x3,%eax
801056de:	0f 84 05 01 00 00    	je     801057e9 <trap+0x219>
    exit();
}
801056e4:	8b 5d f4             	mov    -0xc(%ebp),%ebx
801056e7:	8b 75 f8             	mov    -0x8(%ebp),%esi
801056ea:	8b 7d fc             	mov    -0x4(%ebp),%edi
801056ed:	89 ec                	mov    %ebp,%esp
801056ef:	5d                   	pop    %ebp
801056f0:	c3                   	ret    
801056f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
801056f8:	ff 24 85 40 75 10 80 	jmp    *-0x7fef8ac0(,%eax,4)
801056ff:	90                   	nop
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80105700:	e8 0b ca ff ff       	call   80102110 <ideintr>
    lapiceoi();
80105705:	e8 26 d0 ff ff       	call   80102730 <lapiceoi>
    break;
8010570a:	e9 71 ff ff ff       	jmp    80105680 <trap+0xb0>
8010570f:	90                   	nop
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105710:	8b 7b 38             	mov    0x38(%ebx),%edi
80105713:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105717:	e8 14 e0 ff ff       	call   80103730 <cpuid>
8010571c:	c7 04 24 a4 74 10 80 	movl   $0x801074a4,(%esp)
80105723:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80105727:	89 74 24 08          	mov    %esi,0x8(%esp)
8010572b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010572f:	e8 1c af ff ff       	call   80100650 <cprintf>
            cpuid(), tf->cs, tf->eip);
    lapiceoi();
80105734:	e8 f7 cf ff ff       	call   80102730 <lapiceoi>
    break;
80105739:	e9 42 ff ff ff       	jmp    80105680 <trap+0xb0>
8010573e:	66 90                	xchg   %ax,%ax
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80105740:	e8 2b 02 00 00       	call   80105970 <uartintr>
    lapiceoi();
80105745:	e8 e6 cf ff ff       	call   80102730 <lapiceoi>
    break;
8010574a:	e9 31 ff ff ff       	jmp    80105680 <trap+0xb0>
8010574f:	90                   	nop
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80105750:	e8 ab ce ff ff       	call   80102600 <kbdintr>
    lapiceoi();
80105755:	e8 d6 cf ff ff       	call   80102730 <lapiceoi>
    break;
8010575a:	e9 21 ff ff ff       	jmp    80105680 <trap+0xb0>
8010575f:	90                   	nop
    return;
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
80105760:	e8 cb df ff ff       	call   80103730 <cpuid>
80105765:	85 c0                	test   %eax,%eax
80105767:	75 9c                	jne    80105705 <trap+0x135>
      acquire(&tickslock);
80105769:	c7 04 24 60 4c 11 80 	movl   $0x80114c60,(%esp)
80105770:	e8 8b ea ff ff       	call   80104200 <acquire>
      ticks++;
80105775:	83 05 a0 54 11 80 01 	addl   $0x1,0x801154a0
      wakeup(&ticks);
8010577c:	c7 04 24 a0 54 11 80 	movl   $0x801154a0,(%esp)
80105783:	e8 c8 e6 ff ff       	call   80103e50 <wakeup>
      release(&tickslock);
80105788:	c7 04 24 60 4c 11 80 	movl   $0x80114c60,(%esp)
8010578f:	e8 4c eb ff ff       	call   801042e0 <release>
80105794:	e9 6c ff ff ff       	jmp    80105705 <trap+0x135>
80105799:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
801057a0:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
801057a4:	0f 85 15 ff ff ff    	jne    801056bf <trap+0xef>
801057aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();
801057b0:	e8 bb e4 ff ff       	call   80103c70 <yield>
801057b5:	e9 05 ff ff ff       	jmp    801056bf <trap+0xef>
801057ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
801057c0:	e8 8b df ff ff       	call   80103750 <myproc>
801057c5:	8b 70 24             	mov    0x24(%eax),%esi
801057c8:	85 f6                	test   %esi,%esi
801057ca:	75 44                	jne    80105810 <trap+0x240>
      exit();
    myproc()->tf = tf;
801057cc:	e8 7f df ff ff       	call   80103750 <myproc>
801057d1:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
801057d4:	e8 37 ef ff ff       	call   80104710 <syscall>
    if(myproc()->killed)
801057d9:	e8 72 df ff ff       	call   80103750 <myproc>
801057de:	8b 48 24             	mov    0x24(%eax),%ecx
801057e1:	85 c9                	test   %ecx,%ecx
801057e3:	0f 84 fb fe ff ff    	je     801056e4 <trap+0x114>
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
    exit();
}
801057e9:	8b 5d f4             	mov    -0xc(%ebp),%ebx
801057ec:	8b 75 f8             	mov    -0x8(%ebp),%esi
801057ef:	8b 7d fc             	mov    -0x4(%ebp),%edi
801057f2:	89 ec                	mov    %ebp,%esp
801057f4:	5d                   	pop    %ebp
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
    exit();
801057f5:	e9 56 e3 ff ff       	jmp    80103b50 <exit>
801057fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
    exit();
80105800:	e8 4b e3 ff ff       	call   80103b50 <exit>
80105805:	e9 9b fe ff ff       	jmp    801056a5 <trap+0xd5>
8010580a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
      exit();
80105810:	e8 3b e3 ff ff       	call   80103b50 <exit>
80105815:	eb b5                	jmp    801057cc <trap+0x1fc>
80105817:	0f 20 d7             	mov    %cr2,%edi

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
8010581a:	8b 73 38             	mov    0x38(%ebx),%esi
8010581d:	8d 76 00             	lea    0x0(%esi),%esi
80105820:	e8 0b df ff ff       	call   80103730 <cpuid>
80105825:	89 7c 24 10          	mov    %edi,0x10(%esp)
80105829:	89 74 24 0c          	mov    %esi,0xc(%esp)
8010582d:	89 44 24 08          	mov    %eax,0x8(%esp)
80105831:	8b 43 30             	mov    0x30(%ebx),%eax
80105834:	c7 04 24 c8 74 10 80 	movl   $0x801074c8,(%esp)
8010583b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010583f:	e8 0c ae ff ff       	call   80100650 <cprintf>
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
80105844:	c7 04 24 9e 74 10 80 	movl   $0x8010749e,(%esp)
8010584b:	e8 20 ab ff ff       	call   80100370 <panic>

80105850 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105850:	a1 a4 a5 10 80       	mov    0x8010a5a4,%eax
    return -1;
80105855:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
8010585a:	55                   	push   %ebp
8010585b:	89 e5                	mov    %esp,%ebp
  if(!uart)
8010585d:	85 c0                	test   %eax,%eax
8010585f:	74 10                	je     80105871 <uartgetc+0x21>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105861:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105866:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105867:	a8 01                	test   $0x1,%al
80105869:	74 06                	je     80105871 <uartgetc+0x21>
8010586b:	b2 f8                	mov    $0xf8,%dl
8010586d:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
8010586e:	0f b6 c8             	movzbl %al,%ecx
}
80105871:	89 c8                	mov    %ecx,%eax
80105873:	5d                   	pop    %ebp
80105874:	c3                   	ret    
80105875:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105879:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105880 <uartputc>:
    uartputc(*p);
}

void
uartputc(int c)
{
80105880:	55                   	push   %ebp
80105881:	89 e5                	mov    %esp,%ebp
80105883:	56                   	push   %esi
80105884:	be fd 03 00 00       	mov    $0x3fd,%esi
80105889:	53                   	push   %ebx
  int i;

  if(!uart)
8010588a:	bb 80 00 00 00       	mov    $0x80,%ebx
    uartputc(*p);
}

void
uartputc(int c)
{
8010588f:	83 ec 10             	sub    $0x10,%esp
  int i;

  if(!uart)
80105892:	8b 15 a4 a5 10 80    	mov    0x8010a5a4,%edx
80105898:	85 d2                	test   %edx,%edx
8010589a:	75 15                	jne    801058b1 <uartputc+0x31>
8010589c:	eb 23                	jmp    801058c1 <uartputc+0x41>
8010589e:	66 90                	xchg   %ax,%ax
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
801058a0:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
801058a7:	e8 a4 ce ff ff       	call   80102750 <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801058ac:	83 eb 01             	sub    $0x1,%ebx
801058af:	74 07                	je     801058b8 <uartputc+0x38>
801058b1:	89 f2                	mov    %esi,%edx
801058b3:	ec                   	in     (%dx),%al
801058b4:	a8 20                	test   $0x20,%al
801058b6:	74 e8                	je     801058a0 <uartputc+0x20>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801058b8:	ba f8 03 00 00       	mov    $0x3f8,%edx
801058bd:	8b 45 08             	mov    0x8(%ebp),%eax
801058c0:	ee                   	out    %al,(%dx)
    microdelay(10);
  outb(COM1+0, c);
}
801058c1:	83 c4 10             	add    $0x10,%esp
801058c4:	5b                   	pop    %ebx
801058c5:	5e                   	pop    %esi
801058c6:	5d                   	pop    %ebp
801058c7:	c3                   	ret    
801058c8:	90                   	nop
801058c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801058d0 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
801058d0:	55                   	push   %ebp
801058d1:	31 c9                	xor    %ecx,%ecx
801058d3:	89 e5                	mov    %esp,%ebp
801058d5:	89 c8                	mov    %ecx,%eax
801058d7:	57                   	push   %edi
801058d8:	bf fa 03 00 00       	mov    $0x3fa,%edi
801058dd:	56                   	push   %esi
801058de:	89 fa                	mov    %edi,%edx
801058e0:	53                   	push   %ebx
801058e1:	83 ec 1c             	sub    $0x1c,%esp
801058e4:	ee                   	out    %al,(%dx)
801058e5:	bb fb 03 00 00       	mov    $0x3fb,%ebx
801058ea:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
801058ef:	89 da                	mov    %ebx,%edx
801058f1:	ee                   	out    %al,(%dx)
801058f2:	b8 0c 00 00 00       	mov    $0xc,%eax
801058f7:	b2 f8                	mov    $0xf8,%dl
801058f9:	ee                   	out    %al,(%dx)
801058fa:	be f9 03 00 00       	mov    $0x3f9,%esi
801058ff:	89 c8                	mov    %ecx,%eax
80105901:	89 f2                	mov    %esi,%edx
80105903:	ee                   	out    %al,(%dx)
80105904:	b8 03 00 00 00       	mov    $0x3,%eax
80105909:	89 da                	mov    %ebx,%edx
8010590b:	ee                   	out    %al,(%dx)
8010590c:	b2 fc                	mov    $0xfc,%dl
8010590e:	89 c8                	mov    %ecx,%eax
80105910:	ee                   	out    %al,(%dx)
80105911:	b8 01 00 00 00       	mov    $0x1,%eax
80105916:	89 f2                	mov    %esi,%edx
80105918:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105919:	b2 fd                	mov    $0xfd,%dl
8010591b:	ec                   	in     (%dx),%al
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
8010591c:	3c ff                	cmp    $0xff,%al
8010591e:	74 45                	je     80105965 <uartinit+0x95>
    return;
  uart = 1;
80105920:	c7 05 a4 a5 10 80 01 	movl   $0x1,0x8010a5a4
80105927:	00 00 00 
8010592a:	89 fa                	mov    %edi,%edx
8010592c:	ec                   	in     (%dx),%al
8010592d:	b2 f8                	mov    $0xf8,%dl
8010592f:	ec                   	in     (%dx),%al
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80105930:	bb c0 75 10 80       	mov    $0x801075c0,%ebx

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);
80105935:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010593c:	00 
8010593d:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80105944:	e8 d7 c9 ff ff       	call   80102320 <ioapicenable>

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80105949:	b8 78 00 00 00       	mov    $0x78,%eax
8010594e:	66 90                	xchg   %ax,%ax
    uartputc(*p);
80105950:	0f be c0             	movsbl %al,%eax
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80105953:	83 c3 01             	add    $0x1,%ebx
    uartputc(*p);
80105956:	89 04 24             	mov    %eax,(%esp)
80105959:	e8 22 ff ff ff       	call   80105880 <uartputc>
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
8010595e:	0f b6 03             	movzbl (%ebx),%eax
80105961:	84 c0                	test   %al,%al
80105963:	75 eb                	jne    80105950 <uartinit+0x80>
    uartputc(*p);
}
80105965:	83 c4 1c             	add    $0x1c,%esp
80105968:	5b                   	pop    %ebx
80105969:	5e                   	pop    %esi
8010596a:	5f                   	pop    %edi
8010596b:	5d                   	pop    %ebp
8010596c:	c3                   	ret    
8010596d:	8d 76 00             	lea    0x0(%esi),%esi

80105970 <uartintr>:
  return inb(COM1+0);
}

void
uartintr(void)
{
80105970:	55                   	push   %ebp
80105971:	89 e5                	mov    %esp,%ebp
80105973:	83 ec 18             	sub    $0x18,%esp
  consoleintr(uartgetc);
80105976:	c7 04 24 50 58 10 80 	movl   $0x80105850,(%esp)
8010597d:	e8 3e ae ff ff       	call   801007c0 <consoleintr>
}
80105982:	c9                   	leave  
80105983:	c3                   	ret    

80105984 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105984:	6a 00                	push   $0x0
  pushl $0
80105986:	6a 00                	push   $0x0
  jmp alltraps
80105988:	e9 53 fb ff ff       	jmp    801054e0 <alltraps>

8010598d <vector1>:
.globl vector1
vector1:
  pushl $0
8010598d:	6a 00                	push   $0x0
  pushl $1
8010598f:	6a 01                	push   $0x1
  jmp alltraps
80105991:	e9 4a fb ff ff       	jmp    801054e0 <alltraps>

80105996 <vector2>:
.globl vector2
vector2:
  pushl $0
80105996:	6a 00                	push   $0x0
  pushl $2
80105998:	6a 02                	push   $0x2
  jmp alltraps
8010599a:	e9 41 fb ff ff       	jmp    801054e0 <alltraps>

8010599f <vector3>:
.globl vector3
vector3:
  pushl $0
8010599f:	6a 00                	push   $0x0
  pushl $3
801059a1:	6a 03                	push   $0x3
  jmp alltraps
801059a3:	e9 38 fb ff ff       	jmp    801054e0 <alltraps>

801059a8 <vector4>:
.globl vector4
vector4:
  pushl $0
801059a8:	6a 00                	push   $0x0
  pushl $4
801059aa:	6a 04                	push   $0x4
  jmp alltraps
801059ac:	e9 2f fb ff ff       	jmp    801054e0 <alltraps>

801059b1 <vector5>:
.globl vector5
vector5:
  pushl $0
801059b1:	6a 00                	push   $0x0
  pushl $5
801059b3:	6a 05                	push   $0x5
  jmp alltraps
801059b5:	e9 26 fb ff ff       	jmp    801054e0 <alltraps>

801059ba <vector6>:
.globl vector6
vector6:
  pushl $0
801059ba:	6a 00                	push   $0x0
  pushl $6
801059bc:	6a 06                	push   $0x6
  jmp alltraps
801059be:	e9 1d fb ff ff       	jmp    801054e0 <alltraps>

801059c3 <vector7>:
.globl vector7
vector7:
  pushl $0
801059c3:	6a 00                	push   $0x0
  pushl $7
801059c5:	6a 07                	push   $0x7
  jmp alltraps
801059c7:	e9 14 fb ff ff       	jmp    801054e0 <alltraps>

801059cc <vector8>:
.globl vector8
vector8:
  pushl $8
801059cc:	6a 08                	push   $0x8
  jmp alltraps
801059ce:	e9 0d fb ff ff       	jmp    801054e0 <alltraps>

801059d3 <vector9>:
.globl vector9
vector9:
  pushl $0
801059d3:	6a 00                	push   $0x0
  pushl $9
801059d5:	6a 09                	push   $0x9
  jmp alltraps
801059d7:	e9 04 fb ff ff       	jmp    801054e0 <alltraps>

801059dc <vector10>:
.globl vector10
vector10:
  pushl $10
801059dc:	6a 0a                	push   $0xa
  jmp alltraps
801059de:	e9 fd fa ff ff       	jmp    801054e0 <alltraps>

801059e3 <vector11>:
.globl vector11
vector11:
  pushl $11
801059e3:	6a 0b                	push   $0xb
  jmp alltraps
801059e5:	e9 f6 fa ff ff       	jmp    801054e0 <alltraps>

801059ea <vector12>:
.globl vector12
vector12:
  pushl $12
801059ea:	6a 0c                	push   $0xc
  jmp alltraps
801059ec:	e9 ef fa ff ff       	jmp    801054e0 <alltraps>

801059f1 <vector13>:
.globl vector13
vector13:
  pushl $13
801059f1:	6a 0d                	push   $0xd
  jmp alltraps
801059f3:	e9 e8 fa ff ff       	jmp    801054e0 <alltraps>

801059f8 <vector14>:
.globl vector14
vector14:
  pushl $14
801059f8:	6a 0e                	push   $0xe
  jmp alltraps
801059fa:	e9 e1 fa ff ff       	jmp    801054e0 <alltraps>

801059ff <vector15>:
.globl vector15
vector15:
  pushl $0
801059ff:	6a 00                	push   $0x0
  pushl $15
80105a01:	6a 0f                	push   $0xf
  jmp alltraps
80105a03:	e9 d8 fa ff ff       	jmp    801054e0 <alltraps>

80105a08 <vector16>:
.globl vector16
vector16:
  pushl $0
80105a08:	6a 00                	push   $0x0
  pushl $16
80105a0a:	6a 10                	push   $0x10
  jmp alltraps
80105a0c:	e9 cf fa ff ff       	jmp    801054e0 <alltraps>

80105a11 <vector17>:
.globl vector17
vector17:
  pushl $17
80105a11:	6a 11                	push   $0x11
  jmp alltraps
80105a13:	e9 c8 fa ff ff       	jmp    801054e0 <alltraps>

80105a18 <vector18>:
.globl vector18
vector18:
  pushl $0
80105a18:	6a 00                	push   $0x0
  pushl $18
80105a1a:	6a 12                	push   $0x12
  jmp alltraps
80105a1c:	e9 bf fa ff ff       	jmp    801054e0 <alltraps>

80105a21 <vector19>:
.globl vector19
vector19:
  pushl $0
80105a21:	6a 00                	push   $0x0
  pushl $19
80105a23:	6a 13                	push   $0x13
  jmp alltraps
80105a25:	e9 b6 fa ff ff       	jmp    801054e0 <alltraps>

80105a2a <vector20>:
.globl vector20
vector20:
  pushl $0
80105a2a:	6a 00                	push   $0x0
  pushl $20
80105a2c:	6a 14                	push   $0x14
  jmp alltraps
80105a2e:	e9 ad fa ff ff       	jmp    801054e0 <alltraps>

80105a33 <vector21>:
.globl vector21
vector21:
  pushl $0
80105a33:	6a 00                	push   $0x0
  pushl $21
80105a35:	6a 15                	push   $0x15
  jmp alltraps
80105a37:	e9 a4 fa ff ff       	jmp    801054e0 <alltraps>

80105a3c <vector22>:
.globl vector22
vector22:
  pushl $0
80105a3c:	6a 00                	push   $0x0
  pushl $22
80105a3e:	6a 16                	push   $0x16
  jmp alltraps
80105a40:	e9 9b fa ff ff       	jmp    801054e0 <alltraps>

80105a45 <vector23>:
.globl vector23
vector23:
  pushl $0
80105a45:	6a 00                	push   $0x0
  pushl $23
80105a47:	6a 17                	push   $0x17
  jmp alltraps
80105a49:	e9 92 fa ff ff       	jmp    801054e0 <alltraps>

80105a4e <vector24>:
.globl vector24
vector24:
  pushl $0
80105a4e:	6a 00                	push   $0x0
  pushl $24
80105a50:	6a 18                	push   $0x18
  jmp alltraps
80105a52:	e9 89 fa ff ff       	jmp    801054e0 <alltraps>

80105a57 <vector25>:
.globl vector25
vector25:
  pushl $0
80105a57:	6a 00                	push   $0x0
  pushl $25
80105a59:	6a 19                	push   $0x19
  jmp alltraps
80105a5b:	e9 80 fa ff ff       	jmp    801054e0 <alltraps>

80105a60 <vector26>:
.globl vector26
vector26:
  pushl $0
80105a60:	6a 00                	push   $0x0
  pushl $26
80105a62:	6a 1a                	push   $0x1a
  jmp alltraps
80105a64:	e9 77 fa ff ff       	jmp    801054e0 <alltraps>

80105a69 <vector27>:
.globl vector27
vector27:
  pushl $0
80105a69:	6a 00                	push   $0x0
  pushl $27
80105a6b:	6a 1b                	push   $0x1b
  jmp alltraps
80105a6d:	e9 6e fa ff ff       	jmp    801054e0 <alltraps>

80105a72 <vector28>:
.globl vector28
vector28:
  pushl $0
80105a72:	6a 00                	push   $0x0
  pushl $28
80105a74:	6a 1c                	push   $0x1c
  jmp alltraps
80105a76:	e9 65 fa ff ff       	jmp    801054e0 <alltraps>

80105a7b <vector29>:
.globl vector29
vector29:
  pushl $0
80105a7b:	6a 00                	push   $0x0
  pushl $29
80105a7d:	6a 1d                	push   $0x1d
  jmp alltraps
80105a7f:	e9 5c fa ff ff       	jmp    801054e0 <alltraps>

80105a84 <vector30>:
.globl vector30
vector30:
  pushl $0
80105a84:	6a 00                	push   $0x0
  pushl $30
80105a86:	6a 1e                	push   $0x1e
  jmp alltraps
80105a88:	e9 53 fa ff ff       	jmp    801054e0 <alltraps>

80105a8d <vector31>:
.globl vector31
vector31:
  pushl $0
80105a8d:	6a 00                	push   $0x0
  pushl $31
80105a8f:	6a 1f                	push   $0x1f
  jmp alltraps
80105a91:	e9 4a fa ff ff       	jmp    801054e0 <alltraps>

80105a96 <vector32>:
.globl vector32
vector32:
  pushl $0
80105a96:	6a 00                	push   $0x0
  pushl $32
80105a98:	6a 20                	push   $0x20
  jmp alltraps
80105a9a:	e9 41 fa ff ff       	jmp    801054e0 <alltraps>

80105a9f <vector33>:
.globl vector33
vector33:
  pushl $0
80105a9f:	6a 00                	push   $0x0
  pushl $33
80105aa1:	6a 21                	push   $0x21
  jmp alltraps
80105aa3:	e9 38 fa ff ff       	jmp    801054e0 <alltraps>

80105aa8 <vector34>:
.globl vector34
vector34:
  pushl $0
80105aa8:	6a 00                	push   $0x0
  pushl $34
80105aaa:	6a 22                	push   $0x22
  jmp alltraps
80105aac:	e9 2f fa ff ff       	jmp    801054e0 <alltraps>

80105ab1 <vector35>:
.globl vector35
vector35:
  pushl $0
80105ab1:	6a 00                	push   $0x0
  pushl $35
80105ab3:	6a 23                	push   $0x23
  jmp alltraps
80105ab5:	e9 26 fa ff ff       	jmp    801054e0 <alltraps>

80105aba <vector36>:
.globl vector36
vector36:
  pushl $0
80105aba:	6a 00                	push   $0x0
  pushl $36
80105abc:	6a 24                	push   $0x24
  jmp alltraps
80105abe:	e9 1d fa ff ff       	jmp    801054e0 <alltraps>

80105ac3 <vector37>:
.globl vector37
vector37:
  pushl $0
80105ac3:	6a 00                	push   $0x0
  pushl $37
80105ac5:	6a 25                	push   $0x25
  jmp alltraps
80105ac7:	e9 14 fa ff ff       	jmp    801054e0 <alltraps>

80105acc <vector38>:
.globl vector38
vector38:
  pushl $0
80105acc:	6a 00                	push   $0x0
  pushl $38
80105ace:	6a 26                	push   $0x26
  jmp alltraps
80105ad0:	e9 0b fa ff ff       	jmp    801054e0 <alltraps>

80105ad5 <vector39>:
.globl vector39
vector39:
  pushl $0
80105ad5:	6a 00                	push   $0x0
  pushl $39
80105ad7:	6a 27                	push   $0x27
  jmp alltraps
80105ad9:	e9 02 fa ff ff       	jmp    801054e0 <alltraps>

80105ade <vector40>:
.globl vector40
vector40:
  pushl $0
80105ade:	6a 00                	push   $0x0
  pushl $40
80105ae0:	6a 28                	push   $0x28
  jmp alltraps
80105ae2:	e9 f9 f9 ff ff       	jmp    801054e0 <alltraps>

80105ae7 <vector41>:
.globl vector41
vector41:
  pushl $0
80105ae7:	6a 00                	push   $0x0
  pushl $41
80105ae9:	6a 29                	push   $0x29
  jmp alltraps
80105aeb:	e9 f0 f9 ff ff       	jmp    801054e0 <alltraps>

80105af0 <vector42>:
.globl vector42
vector42:
  pushl $0
80105af0:	6a 00                	push   $0x0
  pushl $42
80105af2:	6a 2a                	push   $0x2a
  jmp alltraps
80105af4:	e9 e7 f9 ff ff       	jmp    801054e0 <alltraps>

80105af9 <vector43>:
.globl vector43
vector43:
  pushl $0
80105af9:	6a 00                	push   $0x0
  pushl $43
80105afb:	6a 2b                	push   $0x2b
  jmp alltraps
80105afd:	e9 de f9 ff ff       	jmp    801054e0 <alltraps>

80105b02 <vector44>:
.globl vector44
vector44:
  pushl $0
80105b02:	6a 00                	push   $0x0
  pushl $44
80105b04:	6a 2c                	push   $0x2c
  jmp alltraps
80105b06:	e9 d5 f9 ff ff       	jmp    801054e0 <alltraps>

80105b0b <vector45>:
.globl vector45
vector45:
  pushl $0
80105b0b:	6a 00                	push   $0x0
  pushl $45
80105b0d:	6a 2d                	push   $0x2d
  jmp alltraps
80105b0f:	e9 cc f9 ff ff       	jmp    801054e0 <alltraps>

80105b14 <vector46>:
.globl vector46
vector46:
  pushl $0
80105b14:	6a 00                	push   $0x0
  pushl $46
80105b16:	6a 2e                	push   $0x2e
  jmp alltraps
80105b18:	e9 c3 f9 ff ff       	jmp    801054e0 <alltraps>

80105b1d <vector47>:
.globl vector47
vector47:
  pushl $0
80105b1d:	6a 00                	push   $0x0
  pushl $47
80105b1f:	6a 2f                	push   $0x2f
  jmp alltraps
80105b21:	e9 ba f9 ff ff       	jmp    801054e0 <alltraps>

80105b26 <vector48>:
.globl vector48
vector48:
  pushl $0
80105b26:	6a 00                	push   $0x0
  pushl $48
80105b28:	6a 30                	push   $0x30
  jmp alltraps
80105b2a:	e9 b1 f9 ff ff       	jmp    801054e0 <alltraps>

80105b2f <vector49>:
.globl vector49
vector49:
  pushl $0
80105b2f:	6a 00                	push   $0x0
  pushl $49
80105b31:	6a 31                	push   $0x31
  jmp alltraps
80105b33:	e9 a8 f9 ff ff       	jmp    801054e0 <alltraps>

80105b38 <vector50>:
.globl vector50
vector50:
  pushl $0
80105b38:	6a 00                	push   $0x0
  pushl $50
80105b3a:	6a 32                	push   $0x32
  jmp alltraps
80105b3c:	e9 9f f9 ff ff       	jmp    801054e0 <alltraps>

80105b41 <vector51>:
.globl vector51
vector51:
  pushl $0
80105b41:	6a 00                	push   $0x0
  pushl $51
80105b43:	6a 33                	push   $0x33
  jmp alltraps
80105b45:	e9 96 f9 ff ff       	jmp    801054e0 <alltraps>

80105b4a <vector52>:
.globl vector52
vector52:
  pushl $0
80105b4a:	6a 00                	push   $0x0
  pushl $52
80105b4c:	6a 34                	push   $0x34
  jmp alltraps
80105b4e:	e9 8d f9 ff ff       	jmp    801054e0 <alltraps>

80105b53 <vector53>:
.globl vector53
vector53:
  pushl $0
80105b53:	6a 00                	push   $0x0
  pushl $53
80105b55:	6a 35                	push   $0x35
  jmp alltraps
80105b57:	e9 84 f9 ff ff       	jmp    801054e0 <alltraps>

80105b5c <vector54>:
.globl vector54
vector54:
  pushl $0
80105b5c:	6a 00                	push   $0x0
  pushl $54
80105b5e:	6a 36                	push   $0x36
  jmp alltraps
80105b60:	e9 7b f9 ff ff       	jmp    801054e0 <alltraps>

80105b65 <vector55>:
.globl vector55
vector55:
  pushl $0
80105b65:	6a 00                	push   $0x0
  pushl $55
80105b67:	6a 37                	push   $0x37
  jmp alltraps
80105b69:	e9 72 f9 ff ff       	jmp    801054e0 <alltraps>

80105b6e <vector56>:
.globl vector56
vector56:
  pushl $0
80105b6e:	6a 00                	push   $0x0
  pushl $56
80105b70:	6a 38                	push   $0x38
  jmp alltraps
80105b72:	e9 69 f9 ff ff       	jmp    801054e0 <alltraps>

80105b77 <vector57>:
.globl vector57
vector57:
  pushl $0
80105b77:	6a 00                	push   $0x0
  pushl $57
80105b79:	6a 39                	push   $0x39
  jmp alltraps
80105b7b:	e9 60 f9 ff ff       	jmp    801054e0 <alltraps>

80105b80 <vector58>:
.globl vector58
vector58:
  pushl $0
80105b80:	6a 00                	push   $0x0
  pushl $58
80105b82:	6a 3a                	push   $0x3a
  jmp alltraps
80105b84:	e9 57 f9 ff ff       	jmp    801054e0 <alltraps>

80105b89 <vector59>:
.globl vector59
vector59:
  pushl $0
80105b89:	6a 00                	push   $0x0
  pushl $59
80105b8b:	6a 3b                	push   $0x3b
  jmp alltraps
80105b8d:	e9 4e f9 ff ff       	jmp    801054e0 <alltraps>

80105b92 <vector60>:
.globl vector60
vector60:
  pushl $0
80105b92:	6a 00                	push   $0x0
  pushl $60
80105b94:	6a 3c                	push   $0x3c
  jmp alltraps
80105b96:	e9 45 f9 ff ff       	jmp    801054e0 <alltraps>

80105b9b <vector61>:
.globl vector61
vector61:
  pushl $0
80105b9b:	6a 00                	push   $0x0
  pushl $61
80105b9d:	6a 3d                	push   $0x3d
  jmp alltraps
80105b9f:	e9 3c f9 ff ff       	jmp    801054e0 <alltraps>

80105ba4 <vector62>:
.globl vector62
vector62:
  pushl $0
80105ba4:	6a 00                	push   $0x0
  pushl $62
80105ba6:	6a 3e                	push   $0x3e
  jmp alltraps
80105ba8:	e9 33 f9 ff ff       	jmp    801054e0 <alltraps>

80105bad <vector63>:
.globl vector63
vector63:
  pushl $0
80105bad:	6a 00                	push   $0x0
  pushl $63
80105baf:	6a 3f                	push   $0x3f
  jmp alltraps
80105bb1:	e9 2a f9 ff ff       	jmp    801054e0 <alltraps>

80105bb6 <vector64>:
.globl vector64
vector64:
  pushl $0
80105bb6:	6a 00                	push   $0x0
  pushl $64
80105bb8:	6a 40                	push   $0x40
  jmp alltraps
80105bba:	e9 21 f9 ff ff       	jmp    801054e0 <alltraps>

80105bbf <vector65>:
.globl vector65
vector65:
  pushl $0
80105bbf:	6a 00                	push   $0x0
  pushl $65
80105bc1:	6a 41                	push   $0x41
  jmp alltraps
80105bc3:	e9 18 f9 ff ff       	jmp    801054e0 <alltraps>

80105bc8 <vector66>:
.globl vector66
vector66:
  pushl $0
80105bc8:	6a 00                	push   $0x0
  pushl $66
80105bca:	6a 42                	push   $0x42
  jmp alltraps
80105bcc:	e9 0f f9 ff ff       	jmp    801054e0 <alltraps>

80105bd1 <vector67>:
.globl vector67
vector67:
  pushl $0
80105bd1:	6a 00                	push   $0x0
  pushl $67
80105bd3:	6a 43                	push   $0x43
  jmp alltraps
80105bd5:	e9 06 f9 ff ff       	jmp    801054e0 <alltraps>

80105bda <vector68>:
.globl vector68
vector68:
  pushl $0
80105bda:	6a 00                	push   $0x0
  pushl $68
80105bdc:	6a 44                	push   $0x44
  jmp alltraps
80105bde:	e9 fd f8 ff ff       	jmp    801054e0 <alltraps>

80105be3 <vector69>:
.globl vector69
vector69:
  pushl $0
80105be3:	6a 00                	push   $0x0
  pushl $69
80105be5:	6a 45                	push   $0x45
  jmp alltraps
80105be7:	e9 f4 f8 ff ff       	jmp    801054e0 <alltraps>

80105bec <vector70>:
.globl vector70
vector70:
  pushl $0
80105bec:	6a 00                	push   $0x0
  pushl $70
80105bee:	6a 46                	push   $0x46
  jmp alltraps
80105bf0:	e9 eb f8 ff ff       	jmp    801054e0 <alltraps>

80105bf5 <vector71>:
.globl vector71
vector71:
  pushl $0
80105bf5:	6a 00                	push   $0x0
  pushl $71
80105bf7:	6a 47                	push   $0x47
  jmp alltraps
80105bf9:	e9 e2 f8 ff ff       	jmp    801054e0 <alltraps>

80105bfe <vector72>:
.globl vector72
vector72:
  pushl $0
80105bfe:	6a 00                	push   $0x0
  pushl $72
80105c00:	6a 48                	push   $0x48
  jmp alltraps
80105c02:	e9 d9 f8 ff ff       	jmp    801054e0 <alltraps>

80105c07 <vector73>:
.globl vector73
vector73:
  pushl $0
80105c07:	6a 00                	push   $0x0
  pushl $73
80105c09:	6a 49                	push   $0x49
  jmp alltraps
80105c0b:	e9 d0 f8 ff ff       	jmp    801054e0 <alltraps>

80105c10 <vector74>:
.globl vector74
vector74:
  pushl $0
80105c10:	6a 00                	push   $0x0
  pushl $74
80105c12:	6a 4a                	push   $0x4a
  jmp alltraps
80105c14:	e9 c7 f8 ff ff       	jmp    801054e0 <alltraps>

80105c19 <vector75>:
.globl vector75
vector75:
  pushl $0
80105c19:	6a 00                	push   $0x0
  pushl $75
80105c1b:	6a 4b                	push   $0x4b
  jmp alltraps
80105c1d:	e9 be f8 ff ff       	jmp    801054e0 <alltraps>

80105c22 <vector76>:
.globl vector76
vector76:
  pushl $0
80105c22:	6a 00                	push   $0x0
  pushl $76
80105c24:	6a 4c                	push   $0x4c
  jmp alltraps
80105c26:	e9 b5 f8 ff ff       	jmp    801054e0 <alltraps>

80105c2b <vector77>:
.globl vector77
vector77:
  pushl $0
80105c2b:	6a 00                	push   $0x0
  pushl $77
80105c2d:	6a 4d                	push   $0x4d
  jmp alltraps
80105c2f:	e9 ac f8 ff ff       	jmp    801054e0 <alltraps>

80105c34 <vector78>:
.globl vector78
vector78:
  pushl $0
80105c34:	6a 00                	push   $0x0
  pushl $78
80105c36:	6a 4e                	push   $0x4e
  jmp alltraps
80105c38:	e9 a3 f8 ff ff       	jmp    801054e0 <alltraps>

80105c3d <vector79>:
.globl vector79
vector79:
  pushl $0
80105c3d:	6a 00                	push   $0x0
  pushl $79
80105c3f:	6a 4f                	push   $0x4f
  jmp alltraps
80105c41:	e9 9a f8 ff ff       	jmp    801054e0 <alltraps>

80105c46 <vector80>:
.globl vector80
vector80:
  pushl $0
80105c46:	6a 00                	push   $0x0
  pushl $80
80105c48:	6a 50                	push   $0x50
  jmp alltraps
80105c4a:	e9 91 f8 ff ff       	jmp    801054e0 <alltraps>

80105c4f <vector81>:
.globl vector81
vector81:
  pushl $0
80105c4f:	6a 00                	push   $0x0
  pushl $81
80105c51:	6a 51                	push   $0x51
  jmp alltraps
80105c53:	e9 88 f8 ff ff       	jmp    801054e0 <alltraps>

80105c58 <vector82>:
.globl vector82
vector82:
  pushl $0
80105c58:	6a 00                	push   $0x0
  pushl $82
80105c5a:	6a 52                	push   $0x52
  jmp alltraps
80105c5c:	e9 7f f8 ff ff       	jmp    801054e0 <alltraps>

80105c61 <vector83>:
.globl vector83
vector83:
  pushl $0
80105c61:	6a 00                	push   $0x0
  pushl $83
80105c63:	6a 53                	push   $0x53
  jmp alltraps
80105c65:	e9 76 f8 ff ff       	jmp    801054e0 <alltraps>

80105c6a <vector84>:
.globl vector84
vector84:
  pushl $0
80105c6a:	6a 00                	push   $0x0
  pushl $84
80105c6c:	6a 54                	push   $0x54
  jmp alltraps
80105c6e:	e9 6d f8 ff ff       	jmp    801054e0 <alltraps>

80105c73 <vector85>:
.globl vector85
vector85:
  pushl $0
80105c73:	6a 00                	push   $0x0
  pushl $85
80105c75:	6a 55                	push   $0x55
  jmp alltraps
80105c77:	e9 64 f8 ff ff       	jmp    801054e0 <alltraps>

80105c7c <vector86>:
.globl vector86
vector86:
  pushl $0
80105c7c:	6a 00                	push   $0x0
  pushl $86
80105c7e:	6a 56                	push   $0x56
  jmp alltraps
80105c80:	e9 5b f8 ff ff       	jmp    801054e0 <alltraps>

80105c85 <vector87>:
.globl vector87
vector87:
  pushl $0
80105c85:	6a 00                	push   $0x0
  pushl $87
80105c87:	6a 57                	push   $0x57
  jmp alltraps
80105c89:	e9 52 f8 ff ff       	jmp    801054e0 <alltraps>

80105c8e <vector88>:
.globl vector88
vector88:
  pushl $0
80105c8e:	6a 00                	push   $0x0
  pushl $88
80105c90:	6a 58                	push   $0x58
  jmp alltraps
80105c92:	e9 49 f8 ff ff       	jmp    801054e0 <alltraps>

80105c97 <vector89>:
.globl vector89
vector89:
  pushl $0
80105c97:	6a 00                	push   $0x0
  pushl $89
80105c99:	6a 59                	push   $0x59
  jmp alltraps
80105c9b:	e9 40 f8 ff ff       	jmp    801054e0 <alltraps>

80105ca0 <vector90>:
.globl vector90
vector90:
  pushl $0
80105ca0:	6a 00                	push   $0x0
  pushl $90
80105ca2:	6a 5a                	push   $0x5a
  jmp alltraps
80105ca4:	e9 37 f8 ff ff       	jmp    801054e0 <alltraps>

80105ca9 <vector91>:
.globl vector91
vector91:
  pushl $0
80105ca9:	6a 00                	push   $0x0
  pushl $91
80105cab:	6a 5b                	push   $0x5b
  jmp alltraps
80105cad:	e9 2e f8 ff ff       	jmp    801054e0 <alltraps>

80105cb2 <vector92>:
.globl vector92
vector92:
  pushl $0
80105cb2:	6a 00                	push   $0x0
  pushl $92
80105cb4:	6a 5c                	push   $0x5c
  jmp alltraps
80105cb6:	e9 25 f8 ff ff       	jmp    801054e0 <alltraps>

80105cbb <vector93>:
.globl vector93
vector93:
  pushl $0
80105cbb:	6a 00                	push   $0x0
  pushl $93
80105cbd:	6a 5d                	push   $0x5d
  jmp alltraps
80105cbf:	e9 1c f8 ff ff       	jmp    801054e0 <alltraps>

80105cc4 <vector94>:
.globl vector94
vector94:
  pushl $0
80105cc4:	6a 00                	push   $0x0
  pushl $94
80105cc6:	6a 5e                	push   $0x5e
  jmp alltraps
80105cc8:	e9 13 f8 ff ff       	jmp    801054e0 <alltraps>

80105ccd <vector95>:
.globl vector95
vector95:
  pushl $0
80105ccd:	6a 00                	push   $0x0
  pushl $95
80105ccf:	6a 5f                	push   $0x5f
  jmp alltraps
80105cd1:	e9 0a f8 ff ff       	jmp    801054e0 <alltraps>

80105cd6 <vector96>:
.globl vector96
vector96:
  pushl $0
80105cd6:	6a 00                	push   $0x0
  pushl $96
80105cd8:	6a 60                	push   $0x60
  jmp alltraps
80105cda:	e9 01 f8 ff ff       	jmp    801054e0 <alltraps>

80105cdf <vector97>:
.globl vector97
vector97:
  pushl $0
80105cdf:	6a 00                	push   $0x0
  pushl $97
80105ce1:	6a 61                	push   $0x61
  jmp alltraps
80105ce3:	e9 f8 f7 ff ff       	jmp    801054e0 <alltraps>

80105ce8 <vector98>:
.globl vector98
vector98:
  pushl $0
80105ce8:	6a 00                	push   $0x0
  pushl $98
80105cea:	6a 62                	push   $0x62
  jmp alltraps
80105cec:	e9 ef f7 ff ff       	jmp    801054e0 <alltraps>

80105cf1 <vector99>:
.globl vector99
vector99:
  pushl $0
80105cf1:	6a 00                	push   $0x0
  pushl $99
80105cf3:	6a 63                	push   $0x63
  jmp alltraps
80105cf5:	e9 e6 f7 ff ff       	jmp    801054e0 <alltraps>

80105cfa <vector100>:
.globl vector100
vector100:
  pushl $0
80105cfa:	6a 00                	push   $0x0
  pushl $100
80105cfc:	6a 64                	push   $0x64
  jmp alltraps
80105cfe:	e9 dd f7 ff ff       	jmp    801054e0 <alltraps>

80105d03 <vector101>:
.globl vector101
vector101:
  pushl $0
80105d03:	6a 00                	push   $0x0
  pushl $101
80105d05:	6a 65                	push   $0x65
  jmp alltraps
80105d07:	e9 d4 f7 ff ff       	jmp    801054e0 <alltraps>

80105d0c <vector102>:
.globl vector102
vector102:
  pushl $0
80105d0c:	6a 00                	push   $0x0
  pushl $102
80105d0e:	6a 66                	push   $0x66
  jmp alltraps
80105d10:	e9 cb f7 ff ff       	jmp    801054e0 <alltraps>

80105d15 <vector103>:
.globl vector103
vector103:
  pushl $0
80105d15:	6a 00                	push   $0x0
  pushl $103
80105d17:	6a 67                	push   $0x67
  jmp alltraps
80105d19:	e9 c2 f7 ff ff       	jmp    801054e0 <alltraps>

80105d1e <vector104>:
.globl vector104
vector104:
  pushl $0
80105d1e:	6a 00                	push   $0x0
  pushl $104
80105d20:	6a 68                	push   $0x68
  jmp alltraps
80105d22:	e9 b9 f7 ff ff       	jmp    801054e0 <alltraps>

80105d27 <vector105>:
.globl vector105
vector105:
  pushl $0
80105d27:	6a 00                	push   $0x0
  pushl $105
80105d29:	6a 69                	push   $0x69
  jmp alltraps
80105d2b:	e9 b0 f7 ff ff       	jmp    801054e0 <alltraps>

80105d30 <vector106>:
.globl vector106
vector106:
  pushl $0
80105d30:	6a 00                	push   $0x0
  pushl $106
80105d32:	6a 6a                	push   $0x6a
  jmp alltraps
80105d34:	e9 a7 f7 ff ff       	jmp    801054e0 <alltraps>

80105d39 <vector107>:
.globl vector107
vector107:
  pushl $0
80105d39:	6a 00                	push   $0x0
  pushl $107
80105d3b:	6a 6b                	push   $0x6b
  jmp alltraps
80105d3d:	e9 9e f7 ff ff       	jmp    801054e0 <alltraps>

80105d42 <vector108>:
.globl vector108
vector108:
  pushl $0
80105d42:	6a 00                	push   $0x0
  pushl $108
80105d44:	6a 6c                	push   $0x6c
  jmp alltraps
80105d46:	e9 95 f7 ff ff       	jmp    801054e0 <alltraps>

80105d4b <vector109>:
.globl vector109
vector109:
  pushl $0
80105d4b:	6a 00                	push   $0x0
  pushl $109
80105d4d:	6a 6d                	push   $0x6d
  jmp alltraps
80105d4f:	e9 8c f7 ff ff       	jmp    801054e0 <alltraps>

80105d54 <vector110>:
.globl vector110
vector110:
  pushl $0
80105d54:	6a 00                	push   $0x0
  pushl $110
80105d56:	6a 6e                	push   $0x6e
  jmp alltraps
80105d58:	e9 83 f7 ff ff       	jmp    801054e0 <alltraps>

80105d5d <vector111>:
.globl vector111
vector111:
  pushl $0
80105d5d:	6a 00                	push   $0x0
  pushl $111
80105d5f:	6a 6f                	push   $0x6f
  jmp alltraps
80105d61:	e9 7a f7 ff ff       	jmp    801054e0 <alltraps>

80105d66 <vector112>:
.globl vector112
vector112:
  pushl $0
80105d66:	6a 00                	push   $0x0
  pushl $112
80105d68:	6a 70                	push   $0x70
  jmp alltraps
80105d6a:	e9 71 f7 ff ff       	jmp    801054e0 <alltraps>

80105d6f <vector113>:
.globl vector113
vector113:
  pushl $0
80105d6f:	6a 00                	push   $0x0
  pushl $113
80105d71:	6a 71                	push   $0x71
  jmp alltraps
80105d73:	e9 68 f7 ff ff       	jmp    801054e0 <alltraps>

80105d78 <vector114>:
.globl vector114
vector114:
  pushl $0
80105d78:	6a 00                	push   $0x0
  pushl $114
80105d7a:	6a 72                	push   $0x72
  jmp alltraps
80105d7c:	e9 5f f7 ff ff       	jmp    801054e0 <alltraps>

80105d81 <vector115>:
.globl vector115
vector115:
  pushl $0
80105d81:	6a 00                	push   $0x0
  pushl $115
80105d83:	6a 73                	push   $0x73
  jmp alltraps
80105d85:	e9 56 f7 ff ff       	jmp    801054e0 <alltraps>

80105d8a <vector116>:
.globl vector116
vector116:
  pushl $0
80105d8a:	6a 00                	push   $0x0
  pushl $116
80105d8c:	6a 74                	push   $0x74
  jmp alltraps
80105d8e:	e9 4d f7 ff ff       	jmp    801054e0 <alltraps>

80105d93 <vector117>:
.globl vector117
vector117:
  pushl $0
80105d93:	6a 00                	push   $0x0
  pushl $117
80105d95:	6a 75                	push   $0x75
  jmp alltraps
80105d97:	e9 44 f7 ff ff       	jmp    801054e0 <alltraps>

80105d9c <vector118>:
.globl vector118
vector118:
  pushl $0
80105d9c:	6a 00                	push   $0x0
  pushl $118
80105d9e:	6a 76                	push   $0x76
  jmp alltraps
80105da0:	e9 3b f7 ff ff       	jmp    801054e0 <alltraps>

80105da5 <vector119>:
.globl vector119
vector119:
  pushl $0
80105da5:	6a 00                	push   $0x0
  pushl $119
80105da7:	6a 77                	push   $0x77
  jmp alltraps
80105da9:	e9 32 f7 ff ff       	jmp    801054e0 <alltraps>

80105dae <vector120>:
.globl vector120
vector120:
  pushl $0
80105dae:	6a 00                	push   $0x0
  pushl $120
80105db0:	6a 78                	push   $0x78
  jmp alltraps
80105db2:	e9 29 f7 ff ff       	jmp    801054e0 <alltraps>

80105db7 <vector121>:
.globl vector121
vector121:
  pushl $0
80105db7:	6a 00                	push   $0x0
  pushl $121
80105db9:	6a 79                	push   $0x79
  jmp alltraps
80105dbb:	e9 20 f7 ff ff       	jmp    801054e0 <alltraps>

80105dc0 <vector122>:
.globl vector122
vector122:
  pushl $0
80105dc0:	6a 00                	push   $0x0
  pushl $122
80105dc2:	6a 7a                	push   $0x7a
  jmp alltraps
80105dc4:	e9 17 f7 ff ff       	jmp    801054e0 <alltraps>

80105dc9 <vector123>:
.globl vector123
vector123:
  pushl $0
80105dc9:	6a 00                	push   $0x0
  pushl $123
80105dcb:	6a 7b                	push   $0x7b
  jmp alltraps
80105dcd:	e9 0e f7 ff ff       	jmp    801054e0 <alltraps>

80105dd2 <vector124>:
.globl vector124
vector124:
  pushl $0
80105dd2:	6a 00                	push   $0x0
  pushl $124
80105dd4:	6a 7c                	push   $0x7c
  jmp alltraps
80105dd6:	e9 05 f7 ff ff       	jmp    801054e0 <alltraps>

80105ddb <vector125>:
.globl vector125
vector125:
  pushl $0
80105ddb:	6a 00                	push   $0x0
  pushl $125
80105ddd:	6a 7d                	push   $0x7d
  jmp alltraps
80105ddf:	e9 fc f6 ff ff       	jmp    801054e0 <alltraps>

80105de4 <vector126>:
.globl vector126
vector126:
  pushl $0
80105de4:	6a 00                	push   $0x0
  pushl $126
80105de6:	6a 7e                	push   $0x7e
  jmp alltraps
80105de8:	e9 f3 f6 ff ff       	jmp    801054e0 <alltraps>

80105ded <vector127>:
.globl vector127
vector127:
  pushl $0
80105ded:	6a 00                	push   $0x0
  pushl $127
80105def:	6a 7f                	push   $0x7f
  jmp alltraps
80105df1:	e9 ea f6 ff ff       	jmp    801054e0 <alltraps>

80105df6 <vector128>:
.globl vector128
vector128:
  pushl $0
80105df6:	6a 00                	push   $0x0
  pushl $128
80105df8:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80105dfd:	e9 de f6 ff ff       	jmp    801054e0 <alltraps>

80105e02 <vector129>:
.globl vector129
vector129:
  pushl $0
80105e02:	6a 00                	push   $0x0
  pushl $129
80105e04:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80105e09:	e9 d2 f6 ff ff       	jmp    801054e0 <alltraps>

80105e0e <vector130>:
.globl vector130
vector130:
  pushl $0
80105e0e:	6a 00                	push   $0x0
  pushl $130
80105e10:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80105e15:	e9 c6 f6 ff ff       	jmp    801054e0 <alltraps>

80105e1a <vector131>:
.globl vector131
vector131:
  pushl $0
80105e1a:	6a 00                	push   $0x0
  pushl $131
80105e1c:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80105e21:	e9 ba f6 ff ff       	jmp    801054e0 <alltraps>

80105e26 <vector132>:
.globl vector132
vector132:
  pushl $0
80105e26:	6a 00                	push   $0x0
  pushl $132
80105e28:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80105e2d:	e9 ae f6 ff ff       	jmp    801054e0 <alltraps>

80105e32 <vector133>:
.globl vector133
vector133:
  pushl $0
80105e32:	6a 00                	push   $0x0
  pushl $133
80105e34:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80105e39:	e9 a2 f6 ff ff       	jmp    801054e0 <alltraps>

80105e3e <vector134>:
.globl vector134
vector134:
  pushl $0
80105e3e:	6a 00                	push   $0x0
  pushl $134
80105e40:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80105e45:	e9 96 f6 ff ff       	jmp    801054e0 <alltraps>

80105e4a <vector135>:
.globl vector135
vector135:
  pushl $0
80105e4a:	6a 00                	push   $0x0
  pushl $135
80105e4c:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80105e51:	e9 8a f6 ff ff       	jmp    801054e0 <alltraps>

80105e56 <vector136>:
.globl vector136
vector136:
  pushl $0
80105e56:	6a 00                	push   $0x0
  pushl $136
80105e58:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80105e5d:	e9 7e f6 ff ff       	jmp    801054e0 <alltraps>

80105e62 <vector137>:
.globl vector137
vector137:
  pushl $0
80105e62:	6a 00                	push   $0x0
  pushl $137
80105e64:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80105e69:	e9 72 f6 ff ff       	jmp    801054e0 <alltraps>

80105e6e <vector138>:
.globl vector138
vector138:
  pushl $0
80105e6e:	6a 00                	push   $0x0
  pushl $138
80105e70:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80105e75:	e9 66 f6 ff ff       	jmp    801054e0 <alltraps>

80105e7a <vector139>:
.globl vector139
vector139:
  pushl $0
80105e7a:	6a 00                	push   $0x0
  pushl $139
80105e7c:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80105e81:	e9 5a f6 ff ff       	jmp    801054e0 <alltraps>

80105e86 <vector140>:
.globl vector140
vector140:
  pushl $0
80105e86:	6a 00                	push   $0x0
  pushl $140
80105e88:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80105e8d:	e9 4e f6 ff ff       	jmp    801054e0 <alltraps>

80105e92 <vector141>:
.globl vector141
vector141:
  pushl $0
80105e92:	6a 00                	push   $0x0
  pushl $141
80105e94:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80105e99:	e9 42 f6 ff ff       	jmp    801054e0 <alltraps>

80105e9e <vector142>:
.globl vector142
vector142:
  pushl $0
80105e9e:	6a 00                	push   $0x0
  pushl $142
80105ea0:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80105ea5:	e9 36 f6 ff ff       	jmp    801054e0 <alltraps>

80105eaa <vector143>:
.globl vector143
vector143:
  pushl $0
80105eaa:	6a 00                	push   $0x0
  pushl $143
80105eac:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80105eb1:	e9 2a f6 ff ff       	jmp    801054e0 <alltraps>

80105eb6 <vector144>:
.globl vector144
vector144:
  pushl $0
80105eb6:	6a 00                	push   $0x0
  pushl $144
80105eb8:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80105ebd:	e9 1e f6 ff ff       	jmp    801054e0 <alltraps>

80105ec2 <vector145>:
.globl vector145
vector145:
  pushl $0
80105ec2:	6a 00                	push   $0x0
  pushl $145
80105ec4:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80105ec9:	e9 12 f6 ff ff       	jmp    801054e0 <alltraps>

80105ece <vector146>:
.globl vector146
vector146:
  pushl $0
80105ece:	6a 00                	push   $0x0
  pushl $146
80105ed0:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80105ed5:	e9 06 f6 ff ff       	jmp    801054e0 <alltraps>

80105eda <vector147>:
.globl vector147
vector147:
  pushl $0
80105eda:	6a 00                	push   $0x0
  pushl $147
80105edc:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80105ee1:	e9 fa f5 ff ff       	jmp    801054e0 <alltraps>

80105ee6 <vector148>:
.globl vector148
vector148:
  pushl $0
80105ee6:	6a 00                	push   $0x0
  pushl $148
80105ee8:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80105eed:	e9 ee f5 ff ff       	jmp    801054e0 <alltraps>

80105ef2 <vector149>:
.globl vector149
vector149:
  pushl $0
80105ef2:	6a 00                	push   $0x0
  pushl $149
80105ef4:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80105ef9:	e9 e2 f5 ff ff       	jmp    801054e0 <alltraps>

80105efe <vector150>:
.globl vector150
vector150:
  pushl $0
80105efe:	6a 00                	push   $0x0
  pushl $150
80105f00:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80105f05:	e9 d6 f5 ff ff       	jmp    801054e0 <alltraps>

80105f0a <vector151>:
.globl vector151
vector151:
  pushl $0
80105f0a:	6a 00                	push   $0x0
  pushl $151
80105f0c:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80105f11:	e9 ca f5 ff ff       	jmp    801054e0 <alltraps>

80105f16 <vector152>:
.globl vector152
vector152:
  pushl $0
80105f16:	6a 00                	push   $0x0
  pushl $152
80105f18:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80105f1d:	e9 be f5 ff ff       	jmp    801054e0 <alltraps>

80105f22 <vector153>:
.globl vector153
vector153:
  pushl $0
80105f22:	6a 00                	push   $0x0
  pushl $153
80105f24:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80105f29:	e9 b2 f5 ff ff       	jmp    801054e0 <alltraps>

80105f2e <vector154>:
.globl vector154
vector154:
  pushl $0
80105f2e:	6a 00                	push   $0x0
  pushl $154
80105f30:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80105f35:	e9 a6 f5 ff ff       	jmp    801054e0 <alltraps>

80105f3a <vector155>:
.globl vector155
vector155:
  pushl $0
80105f3a:	6a 00                	push   $0x0
  pushl $155
80105f3c:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80105f41:	e9 9a f5 ff ff       	jmp    801054e0 <alltraps>

80105f46 <vector156>:
.globl vector156
vector156:
  pushl $0
80105f46:	6a 00                	push   $0x0
  pushl $156
80105f48:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80105f4d:	e9 8e f5 ff ff       	jmp    801054e0 <alltraps>

80105f52 <vector157>:
.globl vector157
vector157:
  pushl $0
80105f52:	6a 00                	push   $0x0
  pushl $157
80105f54:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80105f59:	e9 82 f5 ff ff       	jmp    801054e0 <alltraps>

80105f5e <vector158>:
.globl vector158
vector158:
  pushl $0
80105f5e:	6a 00                	push   $0x0
  pushl $158
80105f60:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80105f65:	e9 76 f5 ff ff       	jmp    801054e0 <alltraps>

80105f6a <vector159>:
.globl vector159
vector159:
  pushl $0
80105f6a:	6a 00                	push   $0x0
  pushl $159
80105f6c:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80105f71:	e9 6a f5 ff ff       	jmp    801054e0 <alltraps>

80105f76 <vector160>:
.globl vector160
vector160:
  pushl $0
80105f76:	6a 00                	push   $0x0
  pushl $160
80105f78:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80105f7d:	e9 5e f5 ff ff       	jmp    801054e0 <alltraps>

80105f82 <vector161>:
.globl vector161
vector161:
  pushl $0
80105f82:	6a 00                	push   $0x0
  pushl $161
80105f84:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80105f89:	e9 52 f5 ff ff       	jmp    801054e0 <alltraps>

80105f8e <vector162>:
.globl vector162
vector162:
  pushl $0
80105f8e:	6a 00                	push   $0x0
  pushl $162
80105f90:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80105f95:	e9 46 f5 ff ff       	jmp    801054e0 <alltraps>

80105f9a <vector163>:
.globl vector163
vector163:
  pushl $0
80105f9a:	6a 00                	push   $0x0
  pushl $163
80105f9c:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80105fa1:	e9 3a f5 ff ff       	jmp    801054e0 <alltraps>

80105fa6 <vector164>:
.globl vector164
vector164:
  pushl $0
80105fa6:	6a 00                	push   $0x0
  pushl $164
80105fa8:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80105fad:	e9 2e f5 ff ff       	jmp    801054e0 <alltraps>

80105fb2 <vector165>:
.globl vector165
vector165:
  pushl $0
80105fb2:	6a 00                	push   $0x0
  pushl $165
80105fb4:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80105fb9:	e9 22 f5 ff ff       	jmp    801054e0 <alltraps>

80105fbe <vector166>:
.globl vector166
vector166:
  pushl $0
80105fbe:	6a 00                	push   $0x0
  pushl $166
80105fc0:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80105fc5:	e9 16 f5 ff ff       	jmp    801054e0 <alltraps>

80105fca <vector167>:
.globl vector167
vector167:
  pushl $0
80105fca:	6a 00                	push   $0x0
  pushl $167
80105fcc:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80105fd1:	e9 0a f5 ff ff       	jmp    801054e0 <alltraps>

80105fd6 <vector168>:
.globl vector168
vector168:
  pushl $0
80105fd6:	6a 00                	push   $0x0
  pushl $168
80105fd8:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80105fdd:	e9 fe f4 ff ff       	jmp    801054e0 <alltraps>

80105fe2 <vector169>:
.globl vector169
vector169:
  pushl $0
80105fe2:	6a 00                	push   $0x0
  pushl $169
80105fe4:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80105fe9:	e9 f2 f4 ff ff       	jmp    801054e0 <alltraps>

80105fee <vector170>:
.globl vector170
vector170:
  pushl $0
80105fee:	6a 00                	push   $0x0
  pushl $170
80105ff0:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80105ff5:	e9 e6 f4 ff ff       	jmp    801054e0 <alltraps>

80105ffa <vector171>:
.globl vector171
vector171:
  pushl $0
80105ffa:	6a 00                	push   $0x0
  pushl $171
80105ffc:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106001:	e9 da f4 ff ff       	jmp    801054e0 <alltraps>

80106006 <vector172>:
.globl vector172
vector172:
  pushl $0
80106006:	6a 00                	push   $0x0
  pushl $172
80106008:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010600d:	e9 ce f4 ff ff       	jmp    801054e0 <alltraps>

80106012 <vector173>:
.globl vector173
vector173:
  pushl $0
80106012:	6a 00                	push   $0x0
  pushl $173
80106014:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106019:	e9 c2 f4 ff ff       	jmp    801054e0 <alltraps>

8010601e <vector174>:
.globl vector174
vector174:
  pushl $0
8010601e:	6a 00                	push   $0x0
  pushl $174
80106020:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106025:	e9 b6 f4 ff ff       	jmp    801054e0 <alltraps>

8010602a <vector175>:
.globl vector175
vector175:
  pushl $0
8010602a:	6a 00                	push   $0x0
  pushl $175
8010602c:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106031:	e9 aa f4 ff ff       	jmp    801054e0 <alltraps>

80106036 <vector176>:
.globl vector176
vector176:
  pushl $0
80106036:	6a 00                	push   $0x0
  pushl $176
80106038:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010603d:	e9 9e f4 ff ff       	jmp    801054e0 <alltraps>

80106042 <vector177>:
.globl vector177
vector177:
  pushl $0
80106042:	6a 00                	push   $0x0
  pushl $177
80106044:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106049:	e9 92 f4 ff ff       	jmp    801054e0 <alltraps>

8010604e <vector178>:
.globl vector178
vector178:
  pushl $0
8010604e:	6a 00                	push   $0x0
  pushl $178
80106050:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106055:	e9 86 f4 ff ff       	jmp    801054e0 <alltraps>

8010605a <vector179>:
.globl vector179
vector179:
  pushl $0
8010605a:	6a 00                	push   $0x0
  pushl $179
8010605c:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106061:	e9 7a f4 ff ff       	jmp    801054e0 <alltraps>

80106066 <vector180>:
.globl vector180
vector180:
  pushl $0
80106066:	6a 00                	push   $0x0
  pushl $180
80106068:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010606d:	e9 6e f4 ff ff       	jmp    801054e0 <alltraps>

80106072 <vector181>:
.globl vector181
vector181:
  pushl $0
80106072:	6a 00                	push   $0x0
  pushl $181
80106074:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106079:	e9 62 f4 ff ff       	jmp    801054e0 <alltraps>

8010607e <vector182>:
.globl vector182
vector182:
  pushl $0
8010607e:	6a 00                	push   $0x0
  pushl $182
80106080:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106085:	e9 56 f4 ff ff       	jmp    801054e0 <alltraps>

8010608a <vector183>:
.globl vector183
vector183:
  pushl $0
8010608a:	6a 00                	push   $0x0
  pushl $183
8010608c:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106091:	e9 4a f4 ff ff       	jmp    801054e0 <alltraps>

80106096 <vector184>:
.globl vector184
vector184:
  pushl $0
80106096:	6a 00                	push   $0x0
  pushl $184
80106098:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010609d:	e9 3e f4 ff ff       	jmp    801054e0 <alltraps>

801060a2 <vector185>:
.globl vector185
vector185:
  pushl $0
801060a2:	6a 00                	push   $0x0
  pushl $185
801060a4:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801060a9:	e9 32 f4 ff ff       	jmp    801054e0 <alltraps>

801060ae <vector186>:
.globl vector186
vector186:
  pushl $0
801060ae:	6a 00                	push   $0x0
  pushl $186
801060b0:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801060b5:	e9 26 f4 ff ff       	jmp    801054e0 <alltraps>

801060ba <vector187>:
.globl vector187
vector187:
  pushl $0
801060ba:	6a 00                	push   $0x0
  pushl $187
801060bc:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801060c1:	e9 1a f4 ff ff       	jmp    801054e0 <alltraps>

801060c6 <vector188>:
.globl vector188
vector188:
  pushl $0
801060c6:	6a 00                	push   $0x0
  pushl $188
801060c8:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801060cd:	e9 0e f4 ff ff       	jmp    801054e0 <alltraps>

801060d2 <vector189>:
.globl vector189
vector189:
  pushl $0
801060d2:	6a 00                	push   $0x0
  pushl $189
801060d4:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801060d9:	e9 02 f4 ff ff       	jmp    801054e0 <alltraps>

801060de <vector190>:
.globl vector190
vector190:
  pushl $0
801060de:	6a 00                	push   $0x0
  pushl $190
801060e0:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801060e5:	e9 f6 f3 ff ff       	jmp    801054e0 <alltraps>

801060ea <vector191>:
.globl vector191
vector191:
  pushl $0
801060ea:	6a 00                	push   $0x0
  pushl $191
801060ec:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801060f1:	e9 ea f3 ff ff       	jmp    801054e0 <alltraps>

801060f6 <vector192>:
.globl vector192
vector192:
  pushl $0
801060f6:	6a 00                	push   $0x0
  pushl $192
801060f8:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801060fd:	e9 de f3 ff ff       	jmp    801054e0 <alltraps>

80106102 <vector193>:
.globl vector193
vector193:
  pushl $0
80106102:	6a 00                	push   $0x0
  pushl $193
80106104:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106109:	e9 d2 f3 ff ff       	jmp    801054e0 <alltraps>

8010610e <vector194>:
.globl vector194
vector194:
  pushl $0
8010610e:	6a 00                	push   $0x0
  pushl $194
80106110:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106115:	e9 c6 f3 ff ff       	jmp    801054e0 <alltraps>

8010611a <vector195>:
.globl vector195
vector195:
  pushl $0
8010611a:	6a 00                	push   $0x0
  pushl $195
8010611c:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106121:	e9 ba f3 ff ff       	jmp    801054e0 <alltraps>

80106126 <vector196>:
.globl vector196
vector196:
  pushl $0
80106126:	6a 00                	push   $0x0
  pushl $196
80106128:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010612d:	e9 ae f3 ff ff       	jmp    801054e0 <alltraps>

80106132 <vector197>:
.globl vector197
vector197:
  pushl $0
80106132:	6a 00                	push   $0x0
  pushl $197
80106134:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106139:	e9 a2 f3 ff ff       	jmp    801054e0 <alltraps>

8010613e <vector198>:
.globl vector198
vector198:
  pushl $0
8010613e:	6a 00                	push   $0x0
  pushl $198
80106140:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106145:	e9 96 f3 ff ff       	jmp    801054e0 <alltraps>

8010614a <vector199>:
.globl vector199
vector199:
  pushl $0
8010614a:	6a 00                	push   $0x0
  pushl $199
8010614c:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106151:	e9 8a f3 ff ff       	jmp    801054e0 <alltraps>

80106156 <vector200>:
.globl vector200
vector200:
  pushl $0
80106156:	6a 00                	push   $0x0
  pushl $200
80106158:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010615d:	e9 7e f3 ff ff       	jmp    801054e0 <alltraps>

80106162 <vector201>:
.globl vector201
vector201:
  pushl $0
80106162:	6a 00                	push   $0x0
  pushl $201
80106164:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106169:	e9 72 f3 ff ff       	jmp    801054e0 <alltraps>

8010616e <vector202>:
.globl vector202
vector202:
  pushl $0
8010616e:	6a 00                	push   $0x0
  pushl $202
80106170:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106175:	e9 66 f3 ff ff       	jmp    801054e0 <alltraps>

8010617a <vector203>:
.globl vector203
vector203:
  pushl $0
8010617a:	6a 00                	push   $0x0
  pushl $203
8010617c:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106181:	e9 5a f3 ff ff       	jmp    801054e0 <alltraps>

80106186 <vector204>:
.globl vector204
vector204:
  pushl $0
80106186:	6a 00                	push   $0x0
  pushl $204
80106188:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010618d:	e9 4e f3 ff ff       	jmp    801054e0 <alltraps>

80106192 <vector205>:
.globl vector205
vector205:
  pushl $0
80106192:	6a 00                	push   $0x0
  pushl $205
80106194:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106199:	e9 42 f3 ff ff       	jmp    801054e0 <alltraps>

8010619e <vector206>:
.globl vector206
vector206:
  pushl $0
8010619e:	6a 00                	push   $0x0
  pushl $206
801061a0:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801061a5:	e9 36 f3 ff ff       	jmp    801054e0 <alltraps>

801061aa <vector207>:
.globl vector207
vector207:
  pushl $0
801061aa:	6a 00                	push   $0x0
  pushl $207
801061ac:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801061b1:	e9 2a f3 ff ff       	jmp    801054e0 <alltraps>

801061b6 <vector208>:
.globl vector208
vector208:
  pushl $0
801061b6:	6a 00                	push   $0x0
  pushl $208
801061b8:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801061bd:	e9 1e f3 ff ff       	jmp    801054e0 <alltraps>

801061c2 <vector209>:
.globl vector209
vector209:
  pushl $0
801061c2:	6a 00                	push   $0x0
  pushl $209
801061c4:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801061c9:	e9 12 f3 ff ff       	jmp    801054e0 <alltraps>

801061ce <vector210>:
.globl vector210
vector210:
  pushl $0
801061ce:	6a 00                	push   $0x0
  pushl $210
801061d0:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801061d5:	e9 06 f3 ff ff       	jmp    801054e0 <alltraps>

801061da <vector211>:
.globl vector211
vector211:
  pushl $0
801061da:	6a 00                	push   $0x0
  pushl $211
801061dc:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801061e1:	e9 fa f2 ff ff       	jmp    801054e0 <alltraps>

801061e6 <vector212>:
.globl vector212
vector212:
  pushl $0
801061e6:	6a 00                	push   $0x0
  pushl $212
801061e8:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801061ed:	e9 ee f2 ff ff       	jmp    801054e0 <alltraps>

801061f2 <vector213>:
.globl vector213
vector213:
  pushl $0
801061f2:	6a 00                	push   $0x0
  pushl $213
801061f4:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801061f9:	e9 e2 f2 ff ff       	jmp    801054e0 <alltraps>

801061fe <vector214>:
.globl vector214
vector214:
  pushl $0
801061fe:	6a 00                	push   $0x0
  pushl $214
80106200:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106205:	e9 d6 f2 ff ff       	jmp    801054e0 <alltraps>

8010620a <vector215>:
.globl vector215
vector215:
  pushl $0
8010620a:	6a 00                	push   $0x0
  pushl $215
8010620c:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106211:	e9 ca f2 ff ff       	jmp    801054e0 <alltraps>

80106216 <vector216>:
.globl vector216
vector216:
  pushl $0
80106216:	6a 00                	push   $0x0
  pushl $216
80106218:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010621d:	e9 be f2 ff ff       	jmp    801054e0 <alltraps>

80106222 <vector217>:
.globl vector217
vector217:
  pushl $0
80106222:	6a 00                	push   $0x0
  pushl $217
80106224:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106229:	e9 b2 f2 ff ff       	jmp    801054e0 <alltraps>

8010622e <vector218>:
.globl vector218
vector218:
  pushl $0
8010622e:	6a 00                	push   $0x0
  pushl $218
80106230:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106235:	e9 a6 f2 ff ff       	jmp    801054e0 <alltraps>

8010623a <vector219>:
.globl vector219
vector219:
  pushl $0
8010623a:	6a 00                	push   $0x0
  pushl $219
8010623c:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106241:	e9 9a f2 ff ff       	jmp    801054e0 <alltraps>

80106246 <vector220>:
.globl vector220
vector220:
  pushl $0
80106246:	6a 00                	push   $0x0
  pushl $220
80106248:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010624d:	e9 8e f2 ff ff       	jmp    801054e0 <alltraps>

80106252 <vector221>:
.globl vector221
vector221:
  pushl $0
80106252:	6a 00                	push   $0x0
  pushl $221
80106254:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106259:	e9 82 f2 ff ff       	jmp    801054e0 <alltraps>

8010625e <vector222>:
.globl vector222
vector222:
  pushl $0
8010625e:	6a 00                	push   $0x0
  pushl $222
80106260:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106265:	e9 76 f2 ff ff       	jmp    801054e0 <alltraps>

8010626a <vector223>:
.globl vector223
vector223:
  pushl $0
8010626a:	6a 00                	push   $0x0
  pushl $223
8010626c:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106271:	e9 6a f2 ff ff       	jmp    801054e0 <alltraps>

80106276 <vector224>:
.globl vector224
vector224:
  pushl $0
80106276:	6a 00                	push   $0x0
  pushl $224
80106278:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010627d:	e9 5e f2 ff ff       	jmp    801054e0 <alltraps>

80106282 <vector225>:
.globl vector225
vector225:
  pushl $0
80106282:	6a 00                	push   $0x0
  pushl $225
80106284:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106289:	e9 52 f2 ff ff       	jmp    801054e0 <alltraps>

8010628e <vector226>:
.globl vector226
vector226:
  pushl $0
8010628e:	6a 00                	push   $0x0
  pushl $226
80106290:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106295:	e9 46 f2 ff ff       	jmp    801054e0 <alltraps>

8010629a <vector227>:
.globl vector227
vector227:
  pushl $0
8010629a:	6a 00                	push   $0x0
  pushl $227
8010629c:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801062a1:	e9 3a f2 ff ff       	jmp    801054e0 <alltraps>

801062a6 <vector228>:
.globl vector228
vector228:
  pushl $0
801062a6:	6a 00                	push   $0x0
  pushl $228
801062a8:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801062ad:	e9 2e f2 ff ff       	jmp    801054e0 <alltraps>

801062b2 <vector229>:
.globl vector229
vector229:
  pushl $0
801062b2:	6a 00                	push   $0x0
  pushl $229
801062b4:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801062b9:	e9 22 f2 ff ff       	jmp    801054e0 <alltraps>

801062be <vector230>:
.globl vector230
vector230:
  pushl $0
801062be:	6a 00                	push   $0x0
  pushl $230
801062c0:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801062c5:	e9 16 f2 ff ff       	jmp    801054e0 <alltraps>

801062ca <vector231>:
.globl vector231
vector231:
  pushl $0
801062ca:	6a 00                	push   $0x0
  pushl $231
801062cc:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801062d1:	e9 0a f2 ff ff       	jmp    801054e0 <alltraps>

801062d6 <vector232>:
.globl vector232
vector232:
  pushl $0
801062d6:	6a 00                	push   $0x0
  pushl $232
801062d8:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801062dd:	e9 fe f1 ff ff       	jmp    801054e0 <alltraps>

801062e2 <vector233>:
.globl vector233
vector233:
  pushl $0
801062e2:	6a 00                	push   $0x0
  pushl $233
801062e4:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801062e9:	e9 f2 f1 ff ff       	jmp    801054e0 <alltraps>

801062ee <vector234>:
.globl vector234
vector234:
  pushl $0
801062ee:	6a 00                	push   $0x0
  pushl $234
801062f0:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801062f5:	e9 e6 f1 ff ff       	jmp    801054e0 <alltraps>

801062fa <vector235>:
.globl vector235
vector235:
  pushl $0
801062fa:	6a 00                	push   $0x0
  pushl $235
801062fc:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106301:	e9 da f1 ff ff       	jmp    801054e0 <alltraps>

80106306 <vector236>:
.globl vector236
vector236:
  pushl $0
80106306:	6a 00                	push   $0x0
  pushl $236
80106308:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010630d:	e9 ce f1 ff ff       	jmp    801054e0 <alltraps>

80106312 <vector237>:
.globl vector237
vector237:
  pushl $0
80106312:	6a 00                	push   $0x0
  pushl $237
80106314:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106319:	e9 c2 f1 ff ff       	jmp    801054e0 <alltraps>

8010631e <vector238>:
.globl vector238
vector238:
  pushl $0
8010631e:	6a 00                	push   $0x0
  pushl $238
80106320:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106325:	e9 b6 f1 ff ff       	jmp    801054e0 <alltraps>

8010632a <vector239>:
.globl vector239
vector239:
  pushl $0
8010632a:	6a 00                	push   $0x0
  pushl $239
8010632c:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106331:	e9 aa f1 ff ff       	jmp    801054e0 <alltraps>

80106336 <vector240>:
.globl vector240
vector240:
  pushl $0
80106336:	6a 00                	push   $0x0
  pushl $240
80106338:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010633d:	e9 9e f1 ff ff       	jmp    801054e0 <alltraps>

80106342 <vector241>:
.globl vector241
vector241:
  pushl $0
80106342:	6a 00                	push   $0x0
  pushl $241
80106344:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106349:	e9 92 f1 ff ff       	jmp    801054e0 <alltraps>

8010634e <vector242>:
.globl vector242
vector242:
  pushl $0
8010634e:	6a 00                	push   $0x0
  pushl $242
80106350:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106355:	e9 86 f1 ff ff       	jmp    801054e0 <alltraps>

8010635a <vector243>:
.globl vector243
vector243:
  pushl $0
8010635a:	6a 00                	push   $0x0
  pushl $243
8010635c:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106361:	e9 7a f1 ff ff       	jmp    801054e0 <alltraps>

80106366 <vector244>:
.globl vector244
vector244:
  pushl $0
80106366:	6a 00                	push   $0x0
  pushl $244
80106368:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010636d:	e9 6e f1 ff ff       	jmp    801054e0 <alltraps>

80106372 <vector245>:
.globl vector245
vector245:
  pushl $0
80106372:	6a 00                	push   $0x0
  pushl $245
80106374:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106379:	e9 62 f1 ff ff       	jmp    801054e0 <alltraps>

8010637e <vector246>:
.globl vector246
vector246:
  pushl $0
8010637e:	6a 00                	push   $0x0
  pushl $246
80106380:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106385:	e9 56 f1 ff ff       	jmp    801054e0 <alltraps>

8010638a <vector247>:
.globl vector247
vector247:
  pushl $0
8010638a:	6a 00                	push   $0x0
  pushl $247
8010638c:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106391:	e9 4a f1 ff ff       	jmp    801054e0 <alltraps>

80106396 <vector248>:
.globl vector248
vector248:
  pushl $0
80106396:	6a 00                	push   $0x0
  pushl $248
80106398:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010639d:	e9 3e f1 ff ff       	jmp    801054e0 <alltraps>

801063a2 <vector249>:
.globl vector249
vector249:
  pushl $0
801063a2:	6a 00                	push   $0x0
  pushl $249
801063a4:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801063a9:	e9 32 f1 ff ff       	jmp    801054e0 <alltraps>

801063ae <vector250>:
.globl vector250
vector250:
  pushl $0
801063ae:	6a 00                	push   $0x0
  pushl $250
801063b0:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801063b5:	e9 26 f1 ff ff       	jmp    801054e0 <alltraps>

801063ba <vector251>:
.globl vector251
vector251:
  pushl $0
801063ba:	6a 00                	push   $0x0
  pushl $251
801063bc:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801063c1:	e9 1a f1 ff ff       	jmp    801054e0 <alltraps>

801063c6 <vector252>:
.globl vector252
vector252:
  pushl $0
801063c6:	6a 00                	push   $0x0
  pushl $252
801063c8:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801063cd:	e9 0e f1 ff ff       	jmp    801054e0 <alltraps>

801063d2 <vector253>:
.globl vector253
vector253:
  pushl $0
801063d2:	6a 00                	push   $0x0
  pushl $253
801063d4:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801063d9:	e9 02 f1 ff ff       	jmp    801054e0 <alltraps>

801063de <vector254>:
.globl vector254
vector254:
  pushl $0
801063de:	6a 00                	push   $0x0
  pushl $254
801063e0:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801063e5:	e9 f6 f0 ff ff       	jmp    801054e0 <alltraps>

801063ea <vector255>:
.globl vector255
vector255:
  pushl $0
801063ea:	6a 00                	push   $0x0
  pushl $255
801063ec:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801063f1:	e9 ea f0 ff ff       	jmp    801054e0 <alltraps>
	...

80106400 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106400:	55                   	push   %ebp
80106401:	89 e5                	mov    %esp,%ebp
80106403:	83 ec 38             	sub    $0x38,%esp
80106406:	89 5d f4             	mov    %ebx,-0xc(%ebp)
80106409:	89 d3                	mov    %edx,%ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
8010640b:	c1 ea 16             	shr    $0x16,%edx
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
8010640e:	89 7d fc             	mov    %edi,-0x4(%ebp)
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106411:	8d 3c 90             	lea    (%eax,%edx,4),%edi
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106414:	89 75 f8             	mov    %esi,-0x8(%ebp)
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
80106417:	8b 37                	mov    (%edi),%esi
80106419:	89 f2                	mov    %esi,%edx
8010641b:	83 e2 01             	and    $0x1,%edx
8010641e:	74 28                	je     80106448 <walkpgdir+0x48>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106420:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
80106426:	81 c6 00 00 00 80    	add    $0x80000000,%esi
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
8010642c:	c1 eb 0a             	shr    $0xa,%ebx
8010642f:	81 e3 fc 0f 00 00    	and    $0xffc,%ebx
80106435:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
}
80106438:	8b 5d f4             	mov    -0xc(%ebp),%ebx
8010643b:	8b 75 f8             	mov    -0x8(%ebp),%esi
8010643e:	8b 7d fc             	mov    -0x4(%ebp),%edi
80106441:	89 ec                	mov    %ebp,%esp
80106443:	5d                   	pop    %ebp
80106444:	c3                   	ret    
80106445:	8d 76 00             	lea    0x0(%esi),%esi
  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
      return 0;
80106448:	31 c0                	xor    %eax,%eax

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
8010644a:	85 c9                	test   %ecx,%ecx
8010644c:	74 ea                	je     80106438 <walkpgdir+0x38>
8010644e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80106451:	e8 7a c0 ff ff       	call   801024d0 <kalloc>
      return 0;
80106456:	8b 55 e4             	mov    -0x1c(%ebp),%edx

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106459:	89 c6                	mov    %eax,%esi
      return 0;
8010645b:	89 d0                	mov    %edx,%eax

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
8010645d:	85 f6                	test   %esi,%esi
8010645f:	74 d7                	je     80106438 <walkpgdir+0x38>
      return 0;
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
80106461:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106468:	00 
80106469:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106470:	00 
80106471:	89 34 24             	mov    %esi,(%esp)
80106474:	e8 b7 de ff ff       	call   80104330 <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106479:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
8010647f:	83 c8 07             	or     $0x7,%eax
80106482:	89 07                	mov    %eax,(%edi)
80106484:	eb a6                	jmp    8010642c <walkpgdir+0x2c>
80106486:	8d 76 00             	lea    0x0(%esi),%esi
80106489:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106490 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106490:	55                   	push   %ebp
80106491:	89 e5                	mov    %esp,%ebp
80106493:	57                   	push   %edi
80106494:	56                   	push   %esi
80106495:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106496:	89 d3                	mov    %edx,%ebx
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106498:	8d 7c 0a ff          	lea    -0x1(%edx,%ecx,1),%edi
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
8010649c:	83 ec 2c             	sub    $0x2c,%esp
8010649f:	8b 75 08             	mov    0x8(%ebp),%esi
801064a2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
801064a5:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801064ab:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
801064b1:	83 4d 0c 01          	orl    $0x1,0xc(%ebp)
801064b5:	eb 1d                	jmp    801064d4 <mappages+0x44>
801064b7:	90                   	nop
  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
801064b8:	f6 00 01             	testb  $0x1,(%eax)
801064bb:	75 45                	jne    80106502 <mappages+0x72>
      panic("remap");
    *pte = pa | perm | PTE_P;
801064bd:	8b 55 0c             	mov    0xc(%ebp),%edx
801064c0:	09 f2                	or     %esi,%edx
    if(a == last)
801064c2:	39 fb                	cmp    %edi,%ebx
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
801064c4:	89 10                	mov    %edx,(%eax)
    if(a == last)
801064c6:	74 30                	je     801064f8 <mappages+0x68>
      break;
    a += PGSIZE;
801064c8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    pa += PGSIZE;
801064ce:	81 c6 00 10 00 00    	add    $0x1000,%esi
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801064d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801064d7:	b9 01 00 00 00       	mov    $0x1,%ecx
801064dc:	89 da                	mov    %ebx,%edx
801064de:	e8 1d ff ff ff       	call   80106400 <walkpgdir>
801064e3:	85 c0                	test   %eax,%eax
801064e5:	75 d1                	jne    801064b8 <mappages+0x28>
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
801064e7:	83 c4 2c             	add    $0x2c,%esp

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
801064ea:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
801064ef:	5b                   	pop    %ebx
801064f0:	5e                   	pop    %esi
801064f1:	5f                   	pop    %edi
801064f2:	5d                   	pop    %ebp
801064f3:	c3                   	ret    
801064f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801064f8:	83 c4 2c             	add    $0x2c,%esp
    if(a == last)
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
801064fb:	31 c0                	xor    %eax,%eax
}
801064fd:	5b                   	pop    %ebx
801064fe:	5e                   	pop    %esi
801064ff:	5f                   	pop    %edi
80106500:	5d                   	pop    %ebp
80106501:	c3                   	ret    
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
80106502:	c7 04 24 c8 75 10 80 	movl   $0x801075c8,(%esp)
80106509:	e8 62 9e ff ff       	call   80100370 <panic>
8010650e:	66 90                	xchg   %ax,%ax

80106510 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80106510:	55                   	push   %ebp
80106511:	89 e5                	mov    %esp,%ebp
80106513:	83 ec 18             	sub    $0x18,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
80106516:	e8 15 d2 ff ff       	call   80103730 <cpuid>
8010651b:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106521:	05 80 27 11 80       	add    $0x80112780,%eax
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106526:	c6 40 7d 9a          	movb   $0x9a,0x7d(%eax)
8010652a:	c6 40 7e cf          	movb   $0xcf,0x7e(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010652e:	c6 80 85 00 00 00 92 	movb   $0x92,0x85(%eax)
80106535:	c6 80 86 00 00 00 cf 	movb   $0xcf,0x86(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
8010653c:	c6 80 8d 00 00 00 fa 	movb   $0xfa,0x8d(%eax)
80106543:	c6 80 8e 00 00 00 cf 	movb   $0xcf,0x8e(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
8010654a:	c6 80 95 00 00 00 f2 	movb   $0xf2,0x95(%eax)
80106551:	c6 80 96 00 00 00 cf 	movb   $0xcf,0x96(%eax)
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106558:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
8010655e:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
80106564:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
80106568:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010656c:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
80106573:	ff ff 
80106575:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
8010657c:	00 00 
8010657e:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
80106585:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
8010658c:	66 c7 80 88 00 00 00 	movw   $0xffff,0x88(%eax)
80106593:	ff ff 
80106595:	66 c7 80 8a 00 00 00 	movw   $0x0,0x8a(%eax)
8010659c:	00 00 
8010659e:	c6 80 8c 00 00 00 00 	movb   $0x0,0x8c(%eax)
801065a5:	c6 80 8f 00 00 00 00 	movb   $0x0,0x8f(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801065ac:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
801065b3:	ff ff 
801065b5:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
801065bc:	00 00 
801065be:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
801065c5:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
801065cc:	83 c0 70             	add    $0x70,%eax
static inline void
lgdt(struct segdesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
801065cf:	66 c7 45 f2 2f 00    	movw   $0x2f,-0xe(%ebp)
  pd[1] = (uint)p;
801065d5:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
801065d9:	c1 e8 10             	shr    $0x10,%eax
801065dc:	66 89 45 f6          	mov    %ax,-0xa(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
801065e0:	8d 45 f2             	lea    -0xe(%ebp),%eax
801065e3:	0f 01 10             	lgdtl  (%eax)
}
801065e6:	c9                   	leave  
801065e7:	c3                   	ret    
801065e8:	90                   	nop
801065e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801065f0 <switchkvm>:
// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801065f0:	a1 a4 54 11 80       	mov    0x801154a4,%eax

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
801065f5:	55                   	push   %ebp
801065f6:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801065f8:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801065fd:	0f 22 d8             	mov    %eax,%cr3
}
80106600:	5d                   	pop    %ebp
80106601:	c3                   	ret    
80106602:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106609:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106610 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80106610:	55                   	push   %ebp
80106611:	89 e5                	mov    %esp,%ebp
80106613:	57                   	push   %edi
80106614:	56                   	push   %esi
80106615:	53                   	push   %ebx
80106616:	83 ec 2c             	sub    $0x2c,%esp
80106619:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
8010661c:	85 f6                	test   %esi,%esi
8010661e:	0f 84 c4 00 00 00    	je     801066e8 <switchuvm+0xd8>
    panic("switchuvm: no process");
  if(p->kstack == 0)
80106624:	8b 56 08             	mov    0x8(%esi),%edx
80106627:	85 d2                	test   %edx,%edx
80106629:	0f 84 d1 00 00 00    	je     80106700 <switchuvm+0xf0>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
8010662f:	8b 46 04             	mov    0x4(%esi),%eax
80106632:	85 c0                	test   %eax,%eax
80106634:	0f 84 ba 00 00 00    	je     801066f4 <switchuvm+0xe4>
    panic("switchuvm: no pgdir");

  pushcli();
8010663a:	e8 81 db ff ff       	call   801041c0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010663f:	e8 6c d0 ff ff       	call   801036b0 <mycpu>
80106644:	89 c3                	mov    %eax,%ebx
80106646:	e8 65 d0 ff ff       	call   801036b0 <mycpu>
8010664b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010664e:	e8 5d d0 ff ff       	call   801036b0 <mycpu>
80106653:	89 c7                	mov    %eax,%edi
80106655:	e8 56 d0 ff ff       	call   801036b0 <mycpu>
8010665a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010665d:	66 c7 83 98 00 00 00 	movw   $0x67,0x98(%ebx)
80106664:	67 00 
80106666:	c6 83 9d 00 00 00 99 	movb   $0x99,0x9d(%ebx)
8010666d:	c6 83 9e 00 00 00 40 	movb   $0x40,0x9e(%ebx)
80106674:	83 c2 08             	add    $0x8,%edx
80106677:	66 89 93 9a 00 00 00 	mov    %dx,0x9a(%ebx)
8010667e:	8d 57 08             	lea    0x8(%edi),%edx
80106681:	83 c0 08             	add    $0x8,%eax
80106684:	c1 ea 10             	shr    $0x10,%edx
80106687:	c1 e8 18             	shr    $0x18,%eax
8010668a:	88 93 9c 00 00 00    	mov    %dl,0x9c(%ebx)
80106690:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
80106696:	e8 15 d0 ff ff       	call   801036b0 <mycpu>
8010669b:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801066a2:	e8 09 d0 ff ff       	call   801036b0 <mycpu>
801066a7:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801066ad:	e8 fe cf ff ff       	call   801036b0 <mycpu>
801066b2:	8b 56 08             	mov    0x8(%esi),%edx
801066b5:	81 c2 00 10 00 00    	add    $0x1000,%edx
801066bb:	89 50 0c             	mov    %edx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801066be:	e8 ed cf ff ff       	call   801036b0 <mycpu>
801066c3:	66 c7 40 6e ff ff    	movw   $0xffff,0x6e(%eax)
}

static inline void
ltr(ushort sel)
{
  asm volatile("ltr %0" : : "r" (sel));
801066c9:	b8 28 00 00 00       	mov    $0x28,%eax
801066ce:	0f 00 d8             	ltr    %ax
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
801066d1:	8b 46 04             	mov    0x4(%esi),%eax
801066d4:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801066d9:	0f 22 d8             	mov    %eax,%cr3
  popcli();
}
801066dc:	83 c4 2c             	add    $0x2c,%esp
801066df:	5b                   	pop    %ebx
801066e0:	5e                   	pop    %esi
801066e1:	5f                   	pop    %edi
801066e2:	5d                   	pop    %ebp
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
801066e3:	e9 88 db ff ff       	jmp    80104270 <popcli>
// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
801066e8:	c7 04 24 ce 75 10 80 	movl   $0x801075ce,(%esp)
801066ef:	e8 7c 9c ff ff       	call   80100370 <panic>
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
    panic("switchuvm: no pgdir");
801066f4:	c7 04 24 f9 75 10 80 	movl   $0x801075f9,(%esp)
801066fb:	e8 70 9c ff ff       	call   80100370 <panic>
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
80106700:	c7 04 24 e4 75 10 80 	movl   $0x801075e4,(%esp)
80106707:	e8 64 9c ff ff       	call   80100370 <panic>
8010670c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106710 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80106710:	55                   	push   %ebp
80106711:	89 e5                	mov    %esp,%ebp
80106713:	83 ec 38             	sub    $0x38,%esp
80106716:	89 75 f8             	mov    %esi,-0x8(%ebp)
80106719:	8b 75 10             	mov    0x10(%ebp),%esi
8010671c:	8b 45 08             	mov    0x8(%ebp),%eax
8010671f:	89 7d fc             	mov    %edi,-0x4(%ebp)
80106722:	8b 7d 0c             	mov    0xc(%ebp),%edi
80106725:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  char *mem;

  if(sz >= PGSIZE)
80106728:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
8010672e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *mem;

  if(sz >= PGSIZE)
80106731:	77 59                	ja     8010678c <inituvm+0x7c>
    panic("inituvm: more than a page");
  mem = kalloc();
80106733:	e8 98 bd ff ff       	call   801024d0 <kalloc>
  memset(mem, 0, PGSIZE);
80106738:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010673f:	00 
80106740:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106747:	00 
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
80106748:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
8010674a:	89 04 24             	mov    %eax,(%esp)
8010674d:	e8 de db ff ff       	call   80104330 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106752:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106758:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010675d:	89 04 24             	mov    %eax,(%esp)
80106760:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106763:	31 d2                	xor    %edx,%edx
80106765:	c7 44 24 04 06 00 00 	movl   $0x6,0x4(%esp)
8010676c:	00 
8010676d:	e8 1e fd ff ff       	call   80106490 <mappages>
  memmove(mem, init, sz);
80106772:	89 75 10             	mov    %esi,0x10(%ebp)
}
80106775:	8b 75 f8             	mov    -0x8(%ebp),%esi
  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
  memset(mem, 0, PGSIZE);
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
  memmove(mem, init, sz);
80106778:	89 7d 0c             	mov    %edi,0xc(%ebp)
}
8010677b:	8b 7d fc             	mov    -0x4(%ebp),%edi
  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
  memset(mem, 0, PGSIZE);
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
  memmove(mem, init, sz);
8010677e:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106781:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80106784:	89 ec                	mov    %ebp,%esp
80106786:	5d                   	pop    %ebp
  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
  memset(mem, 0, PGSIZE);
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
  memmove(mem, init, sz);
80106787:	e9 64 dc ff ff       	jmp    801043f0 <memmove>
inituvm(pde_t *pgdir, char *init, uint sz)
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
8010678c:	c7 04 24 0d 76 10 80 	movl   $0x8010760d,(%esp)
80106793:	e8 d8 9b ff ff       	call   80100370 <panic>
80106798:	90                   	nop
80106799:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801067a0 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
801067a0:	55                   	push   %ebp
801067a1:	89 e5                	mov    %esp,%ebp
801067a3:	57                   	push   %edi
801067a4:	56                   	push   %esi
801067a5:	53                   	push   %ebx
801067a6:	83 ec 2c             	sub    $0x2c,%esp
801067a9:	8b 7d 0c             	mov    0xc(%ebp),%edi
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
801067ac:	f7 c7 ff 0f 00 00    	test   $0xfff,%edi
801067b2:	0f 85 96 00 00 00    	jne    8010684e <loaduvm+0xae>
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
801067b8:	8b 75 18             	mov    0x18(%ebp),%esi
801067bb:	31 db                	xor    %ebx,%ebx
801067bd:	85 f6                	test   %esi,%esi
801067bf:	75 18                	jne    801067d9 <loaduvm+0x39>
801067c1:	eb 75                	jmp    80106838 <loaduvm+0x98>
801067c3:	90                   	nop
801067c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801067c8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801067ce:	81 ee 00 10 00 00    	sub    $0x1000,%esi
801067d4:	39 5d 18             	cmp    %ebx,0x18(%ebp)
801067d7:	76 5f                	jbe    80106838 <loaduvm+0x98>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801067d9:	8b 45 08             	mov    0x8(%ebp),%eax
801067dc:	31 c9                	xor    %ecx,%ecx
}

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
801067de:	8d 14 1f             	lea    (%edi,%ebx,1),%edx
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801067e1:	e8 1a fc ff ff       	call   80106400 <walkpgdir>
801067e6:	85 c0                	test   %eax,%eax
801067e8:	74 58                	je     80106842 <loaduvm+0xa2>
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
801067ea:	8b 00                	mov    (%eax),%eax
    if(sz - i < PGSIZE)
801067ec:	ba 00 10 00 00       	mov    $0x1000,%edx
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
801067f1:	8b 4d 14             	mov    0x14(%ebp),%ecx
  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
801067f4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
801067f9:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
801067ff:	0f 46 d6             	cmovbe %esi,%edx
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106802:	05 00 00 00 80       	add    $0x80000000,%eax
80106807:	89 44 24 04          	mov    %eax,0x4(%esp)
8010680b:	8b 45 10             	mov    0x10(%ebp),%eax
8010680e:	01 d9                	add    %ebx,%ecx
80106810:	89 54 24 0c          	mov    %edx,0xc(%esp)
80106814:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80106817:	89 4c 24 08          	mov    %ecx,0x8(%esp)
8010681b:	89 04 24             	mov    %eax,(%esp)
8010681e:	e8 7d b1 ff ff       	call   801019a0 <readi>
80106823:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106826:	39 d0                	cmp    %edx,%eax
80106828:	74 9e                	je     801067c8 <loaduvm+0x28>
      return -1;
  }
  return 0;
}
8010682a:	83 c4 2c             	add    $0x2c,%esp
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
8010682d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
80106832:	5b                   	pop    %ebx
80106833:	5e                   	pop    %esi
80106834:	5f                   	pop    %edi
80106835:	5d                   	pop    %ebp
80106836:	c3                   	ret    
80106837:	90                   	nop
80106838:	83 c4 2c             	add    $0x2c,%esp
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
8010683b:	31 c0                	xor    %eax,%eax
}
8010683d:	5b                   	pop    %ebx
8010683e:	5e                   	pop    %esi
8010683f:	5f                   	pop    %edi
80106840:	5d                   	pop    %ebp
80106841:	c3                   	ret    

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
80106842:	c7 04 24 27 76 10 80 	movl   $0x80107627,(%esp)
80106849:	e8 22 9b ff ff       	call   80100370 <panic>
{
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
8010684e:	c7 04 24 c8 76 10 80 	movl   $0x801076c8,(%esp)
80106855:	e8 16 9b ff ff       	call   80100370 <panic>
8010685a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106860 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80106860:	55                   	push   %ebp
80106861:	89 e5                	mov    %esp,%ebp
80106863:	57                   	push   %edi
80106864:	56                   	push   %esi
80106865:	53                   	push   %ebx
80106866:	83 ec 2c             	sub    $0x2c,%esp
80106869:	8b 75 0c             	mov    0xc(%ebp),%esi
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
8010686c:	39 75 10             	cmp    %esi,0x10(%ebp)
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
8010686f:	8b 7d 08             	mov    0x8(%ebp),%edi
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;
80106872:	89 f0                	mov    %esi,%eax
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106874:	73 75                	jae    801068eb <deallocuvm+0x8b>
    return oldsz;

  a = PGROUNDUP(newsz);
80106876:	8b 5d 10             	mov    0x10(%ebp),%ebx
80106879:	81 c3 ff 0f 00 00    	add    $0xfff,%ebx
8010687f:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106885:	39 de                	cmp    %ebx,%esi
80106887:	77 3a                	ja     801068c3 <deallocuvm+0x63>
80106889:	eb 5d                	jmp    801068e8 <deallocuvm+0x88>
8010688b:	90                   	nop
8010688c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106890:	8b 10                	mov    (%eax),%edx
80106892:	f6 c2 01             	test   $0x1,%dl
80106895:	74 22                	je     801068b9 <deallocuvm+0x59>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80106897:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
8010689d:	74 54                	je     801068f3 <deallocuvm+0x93>
        panic("kfree");
      char *v = P2V(pa);
8010689f:	81 c2 00 00 00 80    	add    $0x80000000,%edx
      kfree(v);
801068a5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801068a8:	89 14 24             	mov    %edx,(%esp)
801068ab:	e8 b0 ba ff ff       	call   80102360 <kfree>
      *pte = 0;
801068b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801068b3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
801068b9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801068bf:	39 de                	cmp    %ebx,%esi
801068c1:	76 25                	jbe    801068e8 <deallocuvm+0x88>
    pte = walkpgdir(pgdir, (char*)a, 0);
801068c3:	31 c9                	xor    %ecx,%ecx
801068c5:	89 da                	mov    %ebx,%edx
801068c7:	89 f8                	mov    %edi,%eax
801068c9:	e8 32 fb ff ff       	call   80106400 <walkpgdir>
    if(!pte)
801068ce:	85 c0                	test   %eax,%eax
801068d0:	75 be                	jne    80106890 <deallocuvm+0x30>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
801068d2:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
801068d8:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
801068de:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801068e4:	39 de                	cmp    %ebx,%esi
801068e6:	77 db                	ja     801068c3 <deallocuvm+0x63>
      char *v = P2V(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
801068e8:	8b 45 10             	mov    0x10(%ebp),%eax
}
801068eb:	83 c4 2c             	add    $0x2c,%esp
801068ee:	5b                   	pop    %ebx
801068ef:	5e                   	pop    %esi
801068f0:	5f                   	pop    %edi
801068f1:	5d                   	pop    %ebp
801068f2:	c3                   	ret    
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
      pa = PTE_ADDR(*pte);
      if(pa == 0)
        panic("kfree");
801068f3:	c7 04 24 86 6f 10 80 	movl   $0x80106f86,(%esp)
801068fa:	e8 71 9a ff ff       	call   80100370 <panic>
801068ff:	90                   	nop

80106900 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80106900:	55                   	push   %ebp
80106901:	89 e5                	mov    %esp,%ebp
80106903:	57                   	push   %edi
80106904:	56                   	push   %esi
80106905:	53                   	push   %ebx
80106906:	83 ec 2c             	sub    $0x2c,%esp
80106909:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
8010690c:	85 ff                	test   %edi,%edi
8010690e:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80106911:	0f 88 c1 00 00 00    	js     801069d8 <allocuvm+0xd8>
    return 0;
  if(newsz < oldsz)
80106917:	8b 45 0c             	mov    0xc(%ebp),%eax
8010691a:	39 c7                	cmp    %eax,%edi
8010691c:	0f 82 a6 00 00 00    	jb     801069c8 <allocuvm+0xc8>
    return oldsz;

  a = PGROUNDUP(oldsz);
80106922:	8b 75 0c             	mov    0xc(%ebp),%esi
80106925:	81 c6 ff 0f 00 00    	add    $0xfff,%esi
8010692b:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80106931:	39 f7                	cmp    %esi,%edi
80106933:	77 51                	ja     80106986 <allocuvm+0x86>
80106935:	e9 91 00 00 00       	jmp    801069cb <allocuvm+0xcb>
8010693a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
80106940:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106947:	00 
80106948:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010694f:	00 
80106950:	89 04 24             	mov    %eax,(%esp)
80106953:	e8 d8 d9 ff ff       	call   80104330 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106958:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010695e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106963:	89 04 24             	mov    %eax,(%esp)
80106966:	8b 45 08             	mov    0x8(%ebp),%eax
80106969:	89 f2                	mov    %esi,%edx
8010696b:	c7 44 24 04 06 00 00 	movl   $0x6,0x4(%esp)
80106972:	00 
80106973:	e8 18 fb ff ff       	call   80106490 <mappages>
80106978:	85 c0                	test   %eax,%eax
8010697a:	78 74                	js     801069f0 <allocuvm+0xf0>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
8010697c:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106982:	39 f7                	cmp    %esi,%edi
80106984:	76 45                	jbe    801069cb <allocuvm+0xcb>
    mem = kalloc();
80106986:	e8 45 bb ff ff       	call   801024d0 <kalloc>
    if(mem == 0){
8010698b:	85 c0                	test   %eax,%eax
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
8010698d:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
8010698f:	75 af                	jne    80106940 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80106991:	c7 04 24 45 76 10 80 	movl   $0x80107645,(%esp)
80106998:	e8 b3 9c ff ff       	call   80100650 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
8010699d:	8b 45 0c             	mov    0xc(%ebp),%eax
801069a0:	89 7c 24 04          	mov    %edi,0x4(%esp)
801069a4:	89 44 24 08          	mov    %eax,0x8(%esp)
801069a8:	8b 45 08             	mov    0x8(%ebp),%eax
801069ab:	89 04 24             	mov    %eax,(%esp)
801069ae:	e8 ad fe ff ff       	call   80106860 <deallocuvm>
      return 0;
801069b3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
      kfree(mem);
      return 0;
    }
  }
  return newsz;
}
801069ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801069bd:	83 c4 2c             	add    $0x2c,%esp
801069c0:	5b                   	pop    %ebx
801069c1:	5e                   	pop    %esi
801069c2:	5f                   	pop    %edi
801069c3:	5d                   	pop    %ebp
801069c4:	c3                   	ret    
801069c5:	8d 76 00             	lea    0x0(%esi),%esi
  uint a;

  if(newsz >= KERNBASE)
    return 0;
  if(newsz < oldsz)
    return oldsz;
801069c8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      kfree(mem);
      return 0;
    }
  }
  return newsz;
}
801069cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801069ce:	83 c4 2c             	add    $0x2c,%esp
801069d1:	5b                   	pop    %ebx
801069d2:	5e                   	pop    %esi
801069d3:	5f                   	pop    %edi
801069d4:	5d                   	pop    %ebp
801069d5:	c3                   	ret    
801069d6:	66 90                	xchg   %ax,%ax
{
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
    return 0;
801069d8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
      kfree(mem);
      return 0;
    }
  }
  return newsz;
}
801069df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801069e2:	83 c4 2c             	add    $0x2c,%esp
801069e5:	5b                   	pop    %ebx
801069e6:	5e                   	pop    %esi
801069e7:	5f                   	pop    %edi
801069e8:	5d                   	pop    %ebp
801069e9:	c3                   	ret    
801069ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
801069f0:	c7 04 24 5d 76 10 80 	movl   $0x8010765d,(%esp)
801069f7:	e8 54 9c ff ff       	call   80100650 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
801069fc:	8b 45 0c             	mov    0xc(%ebp),%eax
801069ff:	89 7c 24 04          	mov    %edi,0x4(%esp)
80106a03:	89 44 24 08          	mov    %eax,0x8(%esp)
80106a07:	8b 45 08             	mov    0x8(%ebp),%eax
80106a0a:	89 04 24             	mov    %eax,(%esp)
80106a0d:	e8 4e fe ff ff       	call   80106860 <deallocuvm>
      kfree(mem);
80106a12:	89 1c 24             	mov    %ebx,(%esp)
80106a15:	e8 46 b9 ff ff       	call   80102360 <kfree>
      return 0;
80106a1a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }
  }
  return newsz;
}
80106a21:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106a24:	83 c4 2c             	add    $0x2c,%esp
80106a27:	5b                   	pop    %ebx
80106a28:	5e                   	pop    %esi
80106a29:	5f                   	pop    %edi
80106a2a:	5d                   	pop    %ebp
80106a2b:	c3                   	ret    
80106a2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106a30 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106a30:	55                   	push   %ebp
80106a31:	89 e5                	mov    %esp,%ebp
80106a33:	56                   	push   %esi
80106a34:	53                   	push   %ebx
80106a35:	83 ec 10             	sub    $0x10,%esp
80106a38:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint i;

  if(pgdir == 0)
80106a3b:	85 db                	test   %ebx,%ebx
80106a3d:	74 5e                	je     80106a9d <freevm+0x6d>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
80106a3f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80106a46:	00 
  for(i = 0; i < NPDENTRIES; i++){
80106a47:	31 f6                	xor    %esi,%esi
{
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
80106a49:	c7 44 24 04 00 00 00 	movl   $0x80000000,0x4(%esp)
80106a50:	80 
80106a51:	89 1c 24             	mov    %ebx,(%esp)
80106a54:	e8 07 fe ff ff       	call   80106860 <deallocuvm>
80106a59:	eb 10                	jmp    80106a6b <freevm+0x3b>
80106a5b:	90                   	nop
80106a5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(i = 0; i < NPDENTRIES; i++){
80106a60:	83 c6 01             	add    $0x1,%esi
80106a63:	81 fe 00 04 00 00    	cmp    $0x400,%esi
80106a69:	74 24                	je     80106a8f <freevm+0x5f>
    if(pgdir[i] & PTE_P){
80106a6b:	8b 04 b3             	mov    (%ebx,%esi,4),%eax
80106a6e:	a8 01                	test   $0x1,%al
80106a70:	74 ee                	je     80106a60 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106a72:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106a77:	83 c6 01             	add    $0x1,%esi
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106a7a:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80106a7f:	89 04 24             	mov    %eax,(%esp)
80106a82:	e8 d9 b8 ff ff       	call   80102360 <kfree>
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106a87:	81 fe 00 04 00 00    	cmp    $0x400,%esi
80106a8d:	75 dc                	jne    80106a6b <freevm+0x3b>
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80106a8f:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106a92:	83 c4 10             	add    $0x10,%esp
80106a95:	5b                   	pop    %ebx
80106a96:	5e                   	pop    %esi
80106a97:	5d                   	pop    %ebp
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80106a98:	e9 c3 b8 ff ff       	jmp    80102360 <kfree>
freevm(pde_t *pgdir)
{
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
80106a9d:	c7 04 24 79 76 10 80 	movl   $0x80107679,(%esp)
80106aa4:	e8 c7 98 ff ff       	call   80100370 <panic>
80106aa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106ab0 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80106ab0:	55                   	push   %ebp
80106ab1:	89 e5                	mov    %esp,%ebp
80106ab3:	56                   	push   %esi
80106ab4:	53                   	push   %ebx
80106ab5:	83 ec 10             	sub    $0x10,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80106ab8:	e8 13 ba ff ff       	call   801024d0 <kalloc>
80106abd:	85 c0                	test   %eax,%eax
80106abf:	89 c6                	mov    %eax,%esi
80106ac1:	74 47                	je     80106b0a <setupkvm+0x5a>
    return 0;
  memset(pgdir, 0, PGSIZE);
80106ac3:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106aca:	00 
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106acb:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
80106ad0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106ad7:	00 
80106ad8:	89 04 24             	mov    %eax,(%esp)
80106adb:	e8 50 d8 ff ff       	call   80104330 <memset>
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106ae0:	8b 53 0c             	mov    0xc(%ebx),%edx
80106ae3:	8b 43 04             	mov    0x4(%ebx),%eax
80106ae6:	8b 4b 08             	mov    0x8(%ebx),%ecx
80106ae9:	89 54 24 04          	mov    %edx,0x4(%esp)
80106aed:	8b 13                	mov    (%ebx),%edx
80106aef:	89 04 24             	mov    %eax,(%esp)
80106af2:	29 c1                	sub    %eax,%ecx
80106af4:	89 f0                	mov    %esi,%eax
80106af6:	e8 95 f9 ff ff       	call   80106490 <mappages>
80106afb:	85 c0                	test   %eax,%eax
80106afd:	78 19                	js     80106b18 <setupkvm+0x68>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106aff:	83 c3 10             	add    $0x10,%ebx
80106b02:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106b08:	72 d6                	jb     80106ae0 <setupkvm+0x30>
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
    }
  return pgdir;
}
80106b0a:	83 c4 10             	add    $0x10,%esp
80106b0d:	89 f0                	mov    %esi,%eax
80106b0f:	5b                   	pop    %ebx
80106b10:	5e                   	pop    %esi
80106b11:	5d                   	pop    %ebp
80106b12:	c3                   	ret    
80106b13:	90                   	nop
80106b14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
80106b18:	89 34 24             	mov    %esi,(%esp)
      return 0;
80106b1b:	31 f6                	xor    %esi,%esi
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
80106b1d:	e8 0e ff ff ff       	call   80106a30 <freevm>
      return 0;
    }
  return pgdir;
}
80106b22:	83 c4 10             	add    $0x10,%esp
80106b25:	89 f0                	mov    %esi,%eax
80106b27:	5b                   	pop    %ebx
80106b28:	5e                   	pop    %esi
80106b29:	5d                   	pop    %ebp
80106b2a:	c3                   	ret    
80106b2b:	90                   	nop
80106b2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106b30 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80106b30:	55                   	push   %ebp
80106b31:	89 e5                	mov    %esp,%ebp
80106b33:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106b36:	e8 75 ff ff ff       	call   80106ab0 <setupkvm>
80106b3b:	a3 a4 54 11 80       	mov    %eax,0x801154a4
// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106b40:	05 00 00 00 80       	add    $0x80000000,%eax
80106b45:	0f 22 d8             	mov    %eax,%cr3
void
kvmalloc(void)
{
  kpgdir = setupkvm();
  switchkvm();
}
80106b48:	c9                   	leave  
80106b49:	c3                   	ret    
80106b4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106b50 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106b50:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106b51:	31 c9                	xor    %ecx,%ecx

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106b53:	89 e5                	mov    %esp,%ebp
80106b55:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106b58:	8b 55 0c             	mov    0xc(%ebp),%edx
80106b5b:	8b 45 08             	mov    0x8(%ebp),%eax
80106b5e:	e8 9d f8 ff ff       	call   80106400 <walkpgdir>
  if(pte == 0)
80106b63:	85 c0                	test   %eax,%eax
80106b65:	74 05                	je     80106b6c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80106b67:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80106b6a:	c9                   	leave  
80106b6b:	c3                   	ret    
{
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80106b6c:	c7 04 24 8a 76 10 80 	movl   $0x8010768a,(%esp)
80106b73:	e8 f8 97 ff ff       	call   80100370 <panic>
80106b78:	90                   	nop
80106b79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106b80 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80106b80:	55                   	push   %ebp
80106b81:	89 e5                	mov    %esp,%ebp
80106b83:	57                   	push   %edi
80106b84:	56                   	push   %esi
80106b85:	53                   	push   %ebx
80106b86:	83 ec 2c             	sub    $0x2c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80106b89:	e8 22 ff ff ff       	call   80106ab0 <setupkvm>
80106b8e:	85 c0                	test   %eax,%eax
80106b90:	89 c6                	mov    %eax,%esi
80106b92:	0f 84 91 00 00 00    	je     80106c29 <copyuvm+0xa9>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106b98:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106b9b:	85 c9                	test   %ecx,%ecx
80106b9d:	0f 84 86 00 00 00    	je     80106c29 <copyuvm+0xa9>
80106ba3:	31 db                	xor    %ebx,%ebx
80106ba5:	eb 54                	jmp    80106bfb <copyuvm+0x7b>
80106ba7:	90                   	nop
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80106ba8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80106bab:	89 3c 24             	mov    %edi,(%esp)
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80106bae:	81 c7 00 00 00 80    	add    $0x80000000,%edi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80106bb4:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106bbb:	00 
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80106bbc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80106bc1:	05 00 00 00 80       	add    $0x80000000,%eax
80106bc6:	89 44 24 04          	mov    %eax,0x4(%esp)
80106bca:	e8 21 d8 ff ff       	call   801043f0 <memmove>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
80106bcf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80106bd2:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106bd7:	89 da                	mov    %ebx,%edx
80106bd9:	89 3c 24             	mov    %edi,(%esp)
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
80106bdc:	25 ff 0f 00 00       	and    $0xfff,%eax
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80106be1:	89 44 24 04          	mov    %eax,0x4(%esp)
80106be5:	89 f0                	mov    %esi,%eax
80106be7:	e8 a4 f8 ff ff       	call   80106490 <mappages>
80106bec:	85 c0                	test   %eax,%eax
80106bee:	78 2f                	js     80106c1f <copyuvm+0x9f>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106bf0:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106bf6:	39 5d 0c             	cmp    %ebx,0xc(%ebp)
80106bf9:	76 2e                	jbe    80106c29 <copyuvm+0xa9>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80106bfb:	8b 45 08             	mov    0x8(%ebp),%eax
80106bfe:	31 c9                	xor    %ecx,%ecx
80106c00:	89 da                	mov    %ebx,%edx
80106c02:	e8 f9 f7 ff ff       	call   80106400 <walkpgdir>
80106c07:	85 c0                	test   %eax,%eax
80106c09:	74 28                	je     80106c33 <copyuvm+0xb3>
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
80106c0b:	8b 00                	mov    (%eax),%eax
80106c0d:	a8 01                	test   $0x1,%al
80106c0f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106c12:	74 2b                	je     80106c3f <copyuvm+0xbf>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
80106c14:	e8 b7 b8 ff ff       	call   801024d0 <kalloc>
80106c19:	85 c0                	test   %eax,%eax
80106c1b:	89 c7                	mov    %eax,%edi
80106c1d:	75 89                	jne    80106ba8 <copyuvm+0x28>
      goto bad;
  }
  return d;

bad:
  freevm(d);
80106c1f:	89 34 24             	mov    %esi,(%esp)
  return 0;
80106c22:	31 f6                	xor    %esi,%esi
      goto bad;
  }
  return d;

bad:
  freevm(d);
80106c24:	e8 07 fe ff ff       	call   80106a30 <freevm>
  return 0;
}
80106c29:	83 c4 2c             	add    $0x2c,%esp
80106c2c:	89 f0                	mov    %esi,%eax
80106c2e:	5b                   	pop    %ebx
80106c2f:	5e                   	pop    %esi
80106c30:	5f                   	pop    %edi
80106c31:	5d                   	pop    %ebp
80106c32:	c3                   	ret    

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
80106c33:	c7 04 24 94 76 10 80 	movl   $0x80107694,(%esp)
80106c3a:	e8 31 97 ff ff       	call   80100370 <panic>
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
80106c3f:	c7 04 24 ae 76 10 80 	movl   $0x801076ae,(%esp)
80106c46:	e8 25 97 ff ff       	call   80100370 <panic>
80106c4b:	90                   	nop
80106c4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106c50 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106c50:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106c51:	31 c9                	xor    %ecx,%ecx

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106c53:	89 e5                	mov    %esp,%ebp
80106c55:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106c58:	8b 55 0c             	mov    0xc(%ebp),%edx
80106c5b:	8b 45 08             	mov    0x8(%ebp),%eax
80106c5e:	e8 9d f7 ff ff       	call   80106400 <walkpgdir>
  if((*pte & PTE_P) == 0)
80106c63:	8b 10                	mov    (%eax),%edx
    return 0;
80106c65:	31 c0                	xor    %eax,%eax
uva2ka(pde_t *pgdir, char *uva)
{
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
80106c67:	f6 c2 01             	test   $0x1,%dl
80106c6a:	74 11                	je     80106c7d <uva2ka+0x2d>
    return 0;
  if((*pte & PTE_U) == 0)
80106c6c:	f6 c2 04             	test   $0x4,%dl
80106c6f:	74 0c                	je     80106c7d <uva2ka+0x2d>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
80106c71:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106c77:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
}
80106c7d:	c9                   	leave  
80106c7e:	c3                   	ret    
80106c7f:	90                   	nop

80106c80 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80106c80:	55                   	push   %ebp
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
80106c81:	31 c0                	xor    %eax,%eax
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80106c83:	89 e5                	mov    %esp,%ebp
80106c85:	57                   	push   %edi
80106c86:	56                   	push   %esi
80106c87:	53                   	push   %ebx
80106c88:	83 ec 2c             	sub    $0x2c,%esp
80106c8b:	8b 5d 14             	mov    0x14(%ebp),%ebx
80106c8e:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106c91:	85 db                	test   %ebx,%ebx
80106c93:	74 64                	je     80106cf9 <copyout+0x79>
80106c95:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106c98:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80106c9b:	eb 36                	jmp    80106cd3 <copyout+0x53>
80106c9d:	8d 76 00             	lea    0x0(%esi),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80106ca0:	89 f7                	mov    %esi,%edi
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80106ca2:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80106ca5:	29 d7                	sub    %edx,%edi
80106ca7:	81 c7 00 10 00 00    	add    $0x1000,%edi
80106cad:	39 df                	cmp    %ebx,%edi
80106caf:	0f 47 fb             	cmova  %ebx,%edi
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80106cb2:	29 f2                	sub    %esi,%edx
80106cb4:	01 c2                	add    %eax,%edx
80106cb6:	89 14 24             	mov    %edx,(%esp)
80106cb9:	89 7c 24 08          	mov    %edi,0x8(%esp)
80106cbd:	89 4c 24 04          	mov    %ecx,0x4(%esp)
80106cc1:	e8 2a d7 ff ff       	call   801043f0 <memmove>
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
80106cc6:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    n = PGSIZE - (va - va0);
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
80106ccc:	01 7d e4             	add    %edi,-0x1c(%ebp)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106ccf:	29 fb                	sub    %edi,%ebx
80106cd1:	74 35                	je     80106d08 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
80106cd3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
80106cd6:	89 d6                	mov    %edx,%esi
80106cd8:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80106cde:	89 55 e0             	mov    %edx,-0x20(%ebp)
80106ce1:	89 74 24 04          	mov    %esi,0x4(%esp)
80106ce5:	89 0c 24             	mov    %ecx,(%esp)
80106ce8:	e8 63 ff ff ff       	call   80106c50 <uva2ka>
    if(pa0 == 0)
80106ced:	8b 55 e0             	mov    -0x20(%ebp),%edx
80106cf0:	85 c0                	test   %eax,%eax
80106cf2:	75 ac                	jne    80106ca0 <copyout+0x20>
      return -1;
80106cf4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
80106cf9:	83 c4 2c             	add    $0x2c,%esp
80106cfc:	5b                   	pop    %ebx
80106cfd:	5e                   	pop    %esi
80106cfe:	5f                   	pop    %edi
80106cff:	5d                   	pop    %ebp
80106d00:	c3                   	ret    
80106d01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d08:	83 c4 2c             	add    $0x2c,%esp
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
80106d0b:	31 c0                	xor    %eax,%eax
}
80106d0d:	5b                   	pop    %ebx
80106d0e:	5e                   	pop    %esi
80106d0f:	5f                   	pop    %edi
80106d10:	5d                   	pop    %ebp
80106d11:	c3                   	ret    
