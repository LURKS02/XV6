
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
80100028:	bc c0 b5 10 80       	mov    $0x8010b5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 40 2f 10 80       	mov    $0x80102f40,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
	...

80100040 <binit>:
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx
80100044:	bb f4 b5 10 80       	mov    $0x8010b5f4,%ebx
80100049:	83 ec 14             	sub    $0x14,%esp
8010004c:	c7 44 24 04 c0 6f 10 	movl   $0x80106fc0,0x4(%esp)
80100053:	80 
80100054:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
8010005b:	e8 80 41 00 00       	call   801041e0 <initlock>
80100060:	ba bc fc 10 80       	mov    $0x8010fcbc,%edx
80100065:	c7 05 0c fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd0c
8010006c:	fc 10 80 
8010006f:	c7 05 10 fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd10
80100076:	fc 10 80 
80100079:	eb 09                	jmp    80100084 <binit+0x44>
8010007b:	90                   	nop
8010007c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 da                	mov    %ebx,%edx
80100082:	89 c3                	mov    %eax,%ebx
80100084:	8d 43 0c             	lea    0xc(%ebx),%eax
80100087:	89 53 54             	mov    %edx,0x54(%ebx)
8010008a:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
80100091:	89 04 24             	mov    %eax,(%esp)
80100094:	c7 44 24 04 c7 6f 10 	movl   $0x80106fc7,0x4(%esp)
8010009b:	80 
8010009c:	e8 2f 40 00 00       	call   801040d0 <initsleeplock>
801000a1:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
801000a6:	89 58 50             	mov    %ebx,0x50(%eax)
801000a9:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
801000af:	3d bc fc 10 80       	cmp    $0x8010fcbc,%eax
801000b4:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
801000ba:	75 c4                	jne    80100080 <binit+0x40>
801000bc:	83 c4 14             	add    $0x14,%esp
801000bf:	5b                   	pop    %ebx
801000c0:	5d                   	pop    %ebp
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801000d0 <bread>:
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 1c             	sub    $0x1c,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
801000e3:	8b 7d 0c             	mov    0xc(%ebp),%edi
801000e6:	e8 e5 41 00 00       	call   801042d0 <acquire>
801000eb:	8b 1d 10 fd 10 80    	mov    0x8010fd10,%ebx
801000f1:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
801000f7:	75 12                	jne    8010010b <bread+0x3b>
801000f9:	eb 25                	jmp    80100120 <bread+0x50>
801000fb:	90                   	nop
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100120:	8b 1d 0c fd 10 80    	mov    0x8010fd0c,%ebx
80100126:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 58                	jmp    80100188 <bread+0xb8>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100139:	74 4d                	je     80100188 <bread+0xb8>
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
8010015a:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100161:	e8 5a 42 00 00       	call   801043c0 <release>
80100166:	8d 43 0c             	lea    0xc(%ebx),%eax
80100169:	89 04 24             	mov    %eax,(%esp)
8010016c:	e8 9f 3f 00 00       	call   80104110 <acquiresleep>
80100171:	f6 03 02             	testb  $0x2,(%ebx)
80100174:	75 08                	jne    8010017e <bread+0xae>
80100176:	89 1c 24             	mov    %ebx,(%esp)
80100179:	e8 b2 20 00 00       	call   80102230 <iderw>
8010017e:	83 c4 1c             	add    $0x1c,%esp
80100181:	89 d8                	mov    %ebx,%eax
80100183:	5b                   	pop    %ebx
80100184:	5e                   	pop    %esi
80100185:	5f                   	pop    %edi
80100186:	5d                   	pop    %ebp
80100187:	c3                   	ret    
80100188:	c7 04 24 ce 6f 10 80 	movl   $0x80106fce,(%esp)
8010018f:	e8 cc 01 00 00       	call   80100360 <panic>
80100194:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010019a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801001a0 <bwrite>:
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 14             	sub    $0x14,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	89 04 24             	mov    %eax,(%esp)
801001b0:	e8 fb 3f 00 00       	call   801041b0 <holdingsleep>
801001b5:	85 c0                	test   %eax,%eax
801001b7:	74 10                	je     801001c9 <bwrite+0x29>
801001b9:	83 0b 04             	orl    $0x4,(%ebx)
801001bc:	89 5d 08             	mov    %ebx,0x8(%ebp)
801001bf:	83 c4 14             	add    $0x14,%esp
801001c2:	5b                   	pop    %ebx
801001c3:	5d                   	pop    %ebp
801001c4:	e9 67 20 00 00       	jmp    80102230 <iderw>
801001c9:	c7 04 24 df 6f 10 80 	movl   $0x80106fdf,(%esp)
801001d0:	e8 8b 01 00 00       	call   80100360 <panic>
801001d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	83 ec 10             	sub    $0x10,%esp
801001e8:	8b 5d 08             	mov    0x8(%ebp),%ebx
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	89 34 24             	mov    %esi,(%esp)
801001f1:	e8 ba 3f 00 00       	call   801041b0 <holdingsleep>
801001f6:	85 c0                	test   %eax,%eax
801001f8:	74 5b                	je     80100255 <brelse+0x75>
801001fa:	89 34 24             	mov    %esi,(%esp)
801001fd:	e8 6e 3f 00 00       	call   80104170 <releasesleep>
80100202:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100209:	e8 c2 40 00 00       	call   801042d0 <acquire>
8010020e:	83 6b 4c 01          	subl   $0x1,0x4c(%ebx)
80100212:	75 2f                	jne    80100243 <brelse+0x63>
80100214:	8b 43 54             	mov    0x54(%ebx),%eax
80100217:	8b 53 50             	mov    0x50(%ebx),%edx
8010021a:	89 50 50             	mov    %edx,0x50(%eax)
8010021d:	8b 43 50             	mov    0x50(%ebx),%eax
80100220:	8b 53 54             	mov    0x54(%ebx),%edx
80100223:	89 50 54             	mov    %edx,0x54(%eax)
80100226:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
8010022b:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
80100232:	89 43 54             	mov    %eax,0x54(%ebx)
80100235:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
8010023a:	89 58 50             	mov    %ebx,0x50(%eax)
8010023d:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
80100243:	c7 45 08 c0 b5 10 80 	movl   $0x8010b5c0,0x8(%ebp)
8010024a:	83 c4 10             	add    $0x10,%esp
8010024d:	5b                   	pop    %ebx
8010024e:	5e                   	pop    %esi
8010024f:	5d                   	pop    %ebp
80100250:	e9 6b 41 00 00       	jmp    801043c0 <release>
80100255:	c7 04 24 e6 6f 10 80 	movl   $0x80106fe6,(%esp)
8010025c:	e8 ff 00 00 00       	call   80100360 <panic>
	...

80100270 <consoleread>:
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 1c             	sub    $0x1c,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010027f:	89 3c 24             	mov    %edi,(%esp)
80100282:	e8 19 16 00 00       	call   801018a0 <iunlock>
80100287:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010028e:	e8 3d 40 00 00       	call   801042d0 <acquire>
80100293:	8b 55 10             	mov    0x10(%ebp),%edx
80100296:	85 d2                	test   %edx,%edx
80100298:	0f 8e bc 00 00 00    	jle    8010035a <consoleread+0xea>
8010029e:	8b 5d 10             	mov    0x10(%ebp),%ebx
801002a1:	eb 25                	jmp    801002c8 <consoleread+0x58>
801002a3:	90                   	nop
801002a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801002a8:	e8 53 35 00 00       	call   80103800 <myproc>
801002ad:	8b 40 24             	mov    0x24(%eax),%eax
801002b0:	85 c0                	test   %eax,%eax
801002b2:	75 74                	jne    80100328 <consoleread+0xb8>
801002b4:	c7 44 24 04 20 a5 10 	movl   $0x8010a520,0x4(%esp)
801002bb:	80 
801002bc:	c7 04 24 a0 ff 10 80 	movl   $0x8010ffa0,(%esp)
801002c3:	e8 a8 3a 00 00       	call   80103d70 <sleep>
801002c8:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801002cd:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801002d3:	74 d3                	je     801002a8 <consoleread+0x38>
801002d5:	8d 50 01             	lea    0x1(%eax),%edx
801002d8:	89 15 a0 ff 10 80    	mov    %edx,0x8010ffa0
801002de:	89 c2                	mov    %eax,%edx
801002e0:	83 e2 7f             	and    $0x7f,%edx
801002e3:	0f b6 8a 20 ff 10 80 	movzbl -0x7fef00e0(%edx),%ecx
801002ea:	0f be d1             	movsbl %cl,%edx
801002ed:	83 fa 04             	cmp    $0x4,%edx
801002f0:	74 57                	je     80100349 <consoleread+0xd9>
801002f2:	83 c6 01             	add    $0x1,%esi
801002f5:	83 eb 01             	sub    $0x1,%ebx
801002f8:	83 fa 0a             	cmp    $0xa,%edx
801002fb:	88 4e ff             	mov    %cl,-0x1(%esi)
801002fe:	74 53                	je     80100353 <consoleread+0xe3>
80100300:	85 db                	test   %ebx,%ebx
80100302:	75 c4                	jne    801002c8 <consoleread+0x58>
80100304:	8b 45 10             	mov    0x10(%ebp),%eax
80100307:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010030e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100311:	e8 aa 40 00 00       	call   801043c0 <release>
80100316:	89 3c 24             	mov    %edi,(%esp)
80100319:	e8 a2 14 00 00       	call   801017c0 <ilock>
8010031e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100321:	eb 1e                	jmp    80100341 <consoleread+0xd1>
80100323:	90                   	nop
80100324:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100328:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010032f:	e8 8c 40 00 00       	call   801043c0 <release>
80100334:	89 3c 24             	mov    %edi,(%esp)
80100337:	e8 84 14 00 00       	call   801017c0 <ilock>
8010033c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100341:	83 c4 1c             	add    $0x1c,%esp
80100344:	5b                   	pop    %ebx
80100345:	5e                   	pop    %esi
80100346:	5f                   	pop    %edi
80100347:	5d                   	pop    %ebp
80100348:	c3                   	ret    
80100349:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010034c:	76 05                	jbe    80100353 <consoleread+0xe3>
8010034e:	a3 a0 ff 10 80       	mov    %eax,0x8010ffa0
80100353:	8b 45 10             	mov    0x10(%ebp),%eax
80100356:	29 d8                	sub    %ebx,%eax
80100358:	eb ad                	jmp    80100307 <consoleread+0x97>
8010035a:	31 c0                	xor    %eax,%eax
8010035c:	eb a9                	jmp    80100307 <consoleread+0x97>
8010035e:	66 90                	xchg   %ax,%ax

80100360 <panic>:
80100360:	55                   	push   %ebp
80100361:	89 e5                	mov    %esp,%ebp
80100363:	56                   	push   %esi
80100364:	53                   	push   %ebx
80100365:	83 ec 40             	sub    $0x40,%esp
80100368:	fa                   	cli    
80100369:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
80100370:	00 00 00 
80100373:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100376:	e8 e5 24 00 00       	call   80102860 <lapicid>
8010037b:	8d 75 f8             	lea    -0x8(%ebp),%esi
8010037e:	c7 04 24 ed 6f 10 80 	movl   $0x80106fed,(%esp)
80100385:	89 44 24 04          	mov    %eax,0x4(%esp)
80100389:	e8 c2 02 00 00       	call   80100650 <cprintf>
8010038e:	8b 45 08             	mov    0x8(%ebp),%eax
80100391:	89 04 24             	mov    %eax,(%esp)
80100394:	e8 b7 02 00 00       	call   80100650 <cprintf>
80100399:	c7 04 24 b7 79 10 80 	movl   $0x801079b7,(%esp)
801003a0:	e8 ab 02 00 00       	call   80100650 <cprintf>
801003a5:	8d 45 08             	lea    0x8(%ebp),%eax
801003a8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801003ac:	89 04 24             	mov    %eax,(%esp)
801003af:	e8 4c 3e 00 00       	call   80104200 <getcallerpcs>
801003b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801003b8:	8b 03                	mov    (%ebx),%eax
801003ba:	83 c3 04             	add    $0x4,%ebx
801003bd:	c7 04 24 01 70 10 80 	movl   $0x80107001,(%esp)
801003c4:	89 44 24 04          	mov    %eax,0x4(%esp)
801003c8:	e8 83 02 00 00       	call   80100650 <cprintf>
801003cd:	39 f3                	cmp    %esi,%ebx
801003cf:	75 e7                	jne    801003b8 <panic+0x58>
801003d1:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
801003d8:	00 00 00 
801003db:	eb fe                	jmp    801003db <panic+0x7b>
801003dd:	8d 76 00             	lea    0x0(%esi),%esi

801003e0 <consputc>:
801003e0:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
801003e6:	85 d2                	test   %edx,%edx
801003e8:	74 06                	je     801003f0 <consputc+0x10>
801003ea:	fa                   	cli    
801003eb:	eb fe                	jmp    801003eb <consputc+0xb>
801003ed:	8d 76 00             	lea    0x0(%esi),%esi
801003f0:	55                   	push   %ebp
801003f1:	89 e5                	mov    %esp,%ebp
801003f3:	57                   	push   %edi
801003f4:	56                   	push   %esi
801003f5:	89 c6                	mov    %eax,%esi
801003f7:	53                   	push   %ebx
801003f8:	83 ec 1c             	sub    $0x1c,%esp
801003fb:	3d 00 01 00 00       	cmp    $0x100,%eax
80100400:	0f 84 a7 00 00 00    	je     801004ad <consputc+0xcd>
80100406:	89 04 24             	mov    %eax,(%esp)
80100409:	e8 02 57 00 00       	call   80105b10 <uartputc>
8010040e:	ba d4 03 00 00       	mov    $0x3d4,%edx
80100413:	b8 0e 00 00 00       	mov    $0xe,%eax
80100418:	ee                   	out    %al,(%dx)
80100419:	b2 d5                	mov    $0xd5,%dl
8010041b:	ec                   	in     (%dx),%al
8010041c:	0f b6 c8             	movzbl %al,%ecx
8010041f:	b2 d4                	mov    $0xd4,%dl
80100421:	c1 e1 08             	shl    $0x8,%ecx
80100424:	b8 0f 00 00 00       	mov    $0xf,%eax
80100429:	ee                   	out    %al,(%dx)
8010042a:	b2 d5                	mov    $0xd5,%dl
8010042c:	ec                   	in     (%dx),%al
8010042d:	0f b6 c0             	movzbl %al,%eax
80100430:	09 c1                	or     %eax,%ecx
80100432:	83 fe 0a             	cmp    $0xa,%esi
80100435:	0f 84 0f 01 00 00    	je     8010054a <consputc+0x16a>
8010043b:	81 fe 00 01 00 00    	cmp    $0x100,%esi
80100441:	0f 84 ea 00 00 00    	je     80100531 <consputc+0x151>
80100447:	89 f0                	mov    %esi,%eax
80100449:	0f b6 f0             	movzbl %al,%esi
8010044c:	66 81 ce 00 07       	or     $0x700,%si
80100451:	8d 59 01             	lea    0x1(%ecx),%ebx
80100454:	66 89 b4 09 00 80 0b 	mov    %si,-0x7ff48000(%ecx,%ecx,1)
8010045b:	80 
8010045c:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
80100462:	0f 87 bd 00 00 00    	ja     80100525 <consputc+0x145>
80100468:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
8010046e:	7f 66                	jg     801004d6 <consputc+0xf6>
80100470:	89 d8                	mov    %ebx,%eax
80100472:	89 de                	mov    %ebx,%esi
80100474:	c1 e8 08             	shr    $0x8,%eax
80100477:	89 c7                	mov    %eax,%edi
80100479:	8d 8c 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%ecx
80100480:	ba d4 03 00 00       	mov    $0x3d4,%edx
80100485:	b8 0e 00 00 00       	mov    $0xe,%eax
8010048a:	ee                   	out    %al,(%dx)
8010048b:	b2 d5                	mov    $0xd5,%dl
8010048d:	89 f8                	mov    %edi,%eax
8010048f:	ee                   	out    %al,(%dx)
80100490:	b8 0f 00 00 00       	mov    $0xf,%eax
80100495:	b2 d4                	mov    $0xd4,%dl
80100497:	ee                   	out    %al,(%dx)
80100498:	b2 d5                	mov    $0xd5,%dl
8010049a:	89 f0                	mov    %esi,%eax
8010049c:	ee                   	out    %al,(%dx)
8010049d:	bb 20 07 00 00       	mov    $0x720,%ebx
801004a2:	66 89 19             	mov    %bx,(%ecx)
801004a5:	83 c4 1c             	add    $0x1c,%esp
801004a8:	5b                   	pop    %ebx
801004a9:	5e                   	pop    %esi
801004aa:	5f                   	pop    %edi
801004ab:	5d                   	pop    %ebp
801004ac:	c3                   	ret    
801004ad:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004b4:	e8 57 56 00 00       	call   80105b10 <uartputc>
801004b9:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004c0:	e8 4b 56 00 00       	call   80105b10 <uartputc>
801004c5:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004cc:	e8 3f 56 00 00       	call   80105b10 <uartputc>
801004d1:	e9 38 ff ff ff       	jmp    8010040e <consputc+0x2e>
801004d6:	c7 44 24 08 60 0e 00 	movl   $0xe60,0x8(%esp)
801004dd:	00 
801004de:	8d 73 b0             	lea    -0x50(%ebx),%esi
801004e1:	c7 44 24 04 a0 80 0b 	movl   $0x800b80a0,0x4(%esp)
801004e8:	80 
801004e9:	8d bc 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%edi
801004f0:	c7 04 24 00 80 0b 80 	movl   $0x800b8000,(%esp)
801004f7:	e8 b4 3f 00 00       	call   801044b0 <memmove>
801004fc:	b8 d0 07 00 00       	mov    $0x7d0,%eax
80100501:	29 d8                	sub    %ebx,%eax
80100503:	01 c0                	add    %eax,%eax
80100505:	89 3c 24             	mov    %edi,(%esp)
80100508:	89 44 24 08          	mov    %eax,0x8(%esp)
8010050c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100513:	00 
80100514:	e8 f7 3e 00 00       	call   80104410 <memset>
80100519:	89 f9                	mov    %edi,%ecx
8010051b:	bf 07 00 00 00       	mov    $0x7,%edi
80100520:	e9 5b ff ff ff       	jmp    80100480 <consputc+0xa0>
80100525:	c7 04 24 05 70 10 80 	movl   $0x80107005,(%esp)
8010052c:	e8 2f fe ff ff       	call   80100360 <panic>
80100531:	85 c9                	test   %ecx,%ecx
80100533:	8d 59 ff             	lea    -0x1(%ecx),%ebx
80100536:	0f 85 20 ff ff ff    	jne    8010045c <consputc+0x7c>
8010053c:	b9 00 80 0b 80       	mov    $0x800b8000,%ecx
80100541:	31 f6                	xor    %esi,%esi
80100543:	31 ff                	xor    %edi,%edi
80100545:	e9 36 ff ff ff       	jmp    80100480 <consputc+0xa0>
8010054a:	89 c8                	mov    %ecx,%eax
8010054c:	ba 67 66 66 66       	mov    $0x66666667,%edx
80100551:	f7 ea                	imul   %edx
80100553:	c1 ea 05             	shr    $0x5,%edx
80100556:	8d 04 92             	lea    (%edx,%edx,4),%eax
80100559:	c1 e0 04             	shl    $0x4,%eax
8010055c:	8d 58 50             	lea    0x50(%eax),%ebx
8010055f:	e9 f8 fe ff ff       	jmp    8010045c <consputc+0x7c>
80100564:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010056a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100570 <printint>:
80100570:	55                   	push   %ebp
80100571:	89 e5                	mov    %esp,%ebp
80100573:	57                   	push   %edi
80100574:	56                   	push   %esi
80100575:	89 d6                	mov    %edx,%esi
80100577:	53                   	push   %ebx
80100578:	83 ec 1c             	sub    $0x1c,%esp
8010057b:	85 c9                	test   %ecx,%ecx
8010057d:	74 61                	je     801005e0 <printint+0x70>
8010057f:	85 c0                	test   %eax,%eax
80100581:	79 5d                	jns    801005e0 <printint+0x70>
80100583:	f7 d8                	neg    %eax
80100585:	bf 01 00 00 00       	mov    $0x1,%edi
8010058a:	31 c9                	xor    %ecx,%ecx
8010058c:	eb 04                	jmp    80100592 <printint+0x22>
8010058e:	66 90                	xchg   %ax,%ax
80100590:	89 d9                	mov    %ebx,%ecx
80100592:	31 d2                	xor    %edx,%edx
80100594:	f7 f6                	div    %esi
80100596:	8d 59 01             	lea    0x1(%ecx),%ebx
80100599:	0f b6 92 30 70 10 80 	movzbl -0x7fef8fd0(%edx),%edx
801005a0:	85 c0                	test   %eax,%eax
801005a2:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
801005a6:	75 e8                	jne    80100590 <printint+0x20>
801005a8:	85 ff                	test   %edi,%edi
801005aa:	89 d8                	mov    %ebx,%eax
801005ac:	74 08                	je     801005b6 <printint+0x46>
801005ae:	8d 59 02             	lea    0x2(%ecx),%ebx
801005b1:	c6 44 05 d8 2d       	movb   $0x2d,-0x28(%ebp,%eax,1)
801005b6:	83 eb 01             	sub    $0x1,%ebx
801005b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801005c0:	0f be 44 1d d8       	movsbl -0x28(%ebp,%ebx,1),%eax
801005c5:	83 eb 01             	sub    $0x1,%ebx
801005c8:	e8 13 fe ff ff       	call   801003e0 <consputc>
801005cd:	83 fb ff             	cmp    $0xffffffff,%ebx
801005d0:	75 ee                	jne    801005c0 <printint+0x50>
801005d2:	83 c4 1c             	add    $0x1c,%esp
801005d5:	5b                   	pop    %ebx
801005d6:	5e                   	pop    %esi
801005d7:	5f                   	pop    %edi
801005d8:	5d                   	pop    %ebp
801005d9:	c3                   	ret    
801005da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005e0:	31 ff                	xor    %edi,%edi
801005e2:	eb a6                	jmp    8010058a <printint+0x1a>
801005e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801005f0 <consolewrite>:
801005f0:	55                   	push   %ebp
801005f1:	89 e5                	mov    %esp,%ebp
801005f3:	57                   	push   %edi
801005f4:	56                   	push   %esi
801005f5:	53                   	push   %ebx
801005f6:	83 ec 1c             	sub    $0x1c,%esp
801005f9:	8b 45 08             	mov    0x8(%ebp),%eax
801005fc:	8b 75 10             	mov    0x10(%ebp),%esi
801005ff:	89 04 24             	mov    %eax,(%esp)
80100602:	e8 99 12 00 00       	call   801018a0 <iunlock>
80100607:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010060e:	e8 bd 3c 00 00       	call   801042d0 <acquire>
80100613:	8b 7d 0c             	mov    0xc(%ebp),%edi
80100616:	85 f6                	test   %esi,%esi
80100618:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010061b:	7e 12                	jle    8010062f <consolewrite+0x3f>
8010061d:	8d 76 00             	lea    0x0(%esi),%esi
80100620:	0f b6 07             	movzbl (%edi),%eax
80100623:	83 c7 01             	add    $0x1,%edi
80100626:	e8 b5 fd ff ff       	call   801003e0 <consputc>
8010062b:	39 df                	cmp    %ebx,%edi
8010062d:	75 f1                	jne    80100620 <consolewrite+0x30>
8010062f:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100636:	e8 85 3d 00 00       	call   801043c0 <release>
8010063b:	8b 45 08             	mov    0x8(%ebp),%eax
8010063e:	89 04 24             	mov    %eax,(%esp)
80100641:	e8 7a 11 00 00       	call   801017c0 <ilock>
80100646:	83 c4 1c             	add    $0x1c,%esp
80100649:	89 f0                	mov    %esi,%eax
8010064b:	5b                   	pop    %ebx
8010064c:	5e                   	pop    %esi
8010064d:	5f                   	pop    %edi
8010064e:	5d                   	pop    %ebp
8010064f:	c3                   	ret    

80100650 <cprintf>:
80100650:	55                   	push   %ebp
80100651:	89 e5                	mov    %esp,%ebp
80100653:	57                   	push   %edi
80100654:	56                   	push   %esi
80100655:	53                   	push   %ebx
80100656:	83 ec 1c             	sub    $0x1c,%esp
80100659:	a1 54 a5 10 80       	mov    0x8010a554,%eax
8010065e:	85 c0                	test   %eax,%eax
80100660:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100663:	0f 85 27 01 00 00    	jne    80100790 <cprintf+0x140>
80100669:	8b 45 08             	mov    0x8(%ebp),%eax
8010066c:	85 c0                	test   %eax,%eax
8010066e:	89 c1                	mov    %eax,%ecx
80100670:	0f 84 2b 01 00 00    	je     801007a1 <cprintf+0x151>
80100676:	0f b6 00             	movzbl (%eax),%eax
80100679:	31 db                	xor    %ebx,%ebx
8010067b:	89 cf                	mov    %ecx,%edi
8010067d:	8d 75 0c             	lea    0xc(%ebp),%esi
80100680:	85 c0                	test   %eax,%eax
80100682:	75 4c                	jne    801006d0 <cprintf+0x80>
80100684:	eb 5f                	jmp    801006e5 <cprintf+0x95>
80100686:	66 90                	xchg   %ax,%ax
80100688:	83 c3 01             	add    $0x1,%ebx
8010068b:	0f b6 14 1f          	movzbl (%edi,%ebx,1),%edx
8010068f:	85 d2                	test   %edx,%edx
80100691:	74 52                	je     801006e5 <cprintf+0x95>
80100693:	83 fa 70             	cmp    $0x70,%edx
80100696:	74 72                	je     8010070a <cprintf+0xba>
80100698:	7f 66                	jg     80100700 <cprintf+0xb0>
8010069a:	83 fa 25             	cmp    $0x25,%edx
8010069d:	8d 76 00             	lea    0x0(%esi),%esi
801006a0:	0f 84 a2 00 00 00    	je     80100748 <cprintf+0xf8>
801006a6:	83 fa 64             	cmp    $0x64,%edx
801006a9:	75 7d                	jne    80100728 <cprintf+0xd8>
801006ab:	8d 46 04             	lea    0x4(%esi),%eax
801006ae:	b9 01 00 00 00       	mov    $0x1,%ecx
801006b3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006b6:	8b 06                	mov    (%esi),%eax
801006b8:	ba 0a 00 00 00       	mov    $0xa,%edx
801006bd:	e8 ae fe ff ff       	call   80100570 <printint>
801006c2:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801006c5:	83 c3 01             	add    $0x1,%ebx
801006c8:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006cc:	85 c0                	test   %eax,%eax
801006ce:	74 15                	je     801006e5 <cprintf+0x95>
801006d0:	83 f8 25             	cmp    $0x25,%eax
801006d3:	74 b3                	je     80100688 <cprintf+0x38>
801006d5:	e8 06 fd ff ff       	call   801003e0 <consputc>
801006da:	83 c3 01             	add    $0x1,%ebx
801006dd:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006e1:	85 c0                	test   %eax,%eax
801006e3:	75 eb                	jne    801006d0 <cprintf+0x80>
801006e5:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801006e8:	85 c9                	test   %ecx,%ecx
801006ea:	74 0c                	je     801006f8 <cprintf+0xa8>
801006ec:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801006f3:	e8 c8 3c 00 00       	call   801043c0 <release>
801006f8:	83 c4 1c             	add    $0x1c,%esp
801006fb:	5b                   	pop    %ebx
801006fc:	5e                   	pop    %esi
801006fd:	5f                   	pop    %edi
801006fe:	5d                   	pop    %ebp
801006ff:	c3                   	ret    
80100700:	83 fa 73             	cmp    $0x73,%edx
80100703:	74 53                	je     80100758 <cprintf+0x108>
80100705:	83 fa 78             	cmp    $0x78,%edx
80100708:	75 1e                	jne    80100728 <cprintf+0xd8>
8010070a:	8d 46 04             	lea    0x4(%esi),%eax
8010070d:	31 c9                	xor    %ecx,%ecx
8010070f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100712:	8b 06                	mov    (%esi),%eax
80100714:	ba 10 00 00 00       	mov    $0x10,%edx
80100719:	e8 52 fe ff ff       	call   80100570 <printint>
8010071e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80100721:	eb a2                	jmp    801006c5 <cprintf+0x75>
80100723:	90                   	nop
80100724:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100728:	b8 25 00 00 00       	mov    $0x25,%eax
8010072d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80100730:	e8 ab fc ff ff       	call   801003e0 <consputc>
80100735:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80100738:	89 d0                	mov    %edx,%eax
8010073a:	e8 a1 fc ff ff       	call   801003e0 <consputc>
8010073f:	eb 99                	jmp    801006da <cprintf+0x8a>
80100741:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100748:	b8 25 00 00 00       	mov    $0x25,%eax
8010074d:	e8 8e fc ff ff       	call   801003e0 <consputc>
80100752:	e9 6e ff ff ff       	jmp    801006c5 <cprintf+0x75>
80100757:	90                   	nop
80100758:	8d 46 04             	lea    0x4(%esi),%eax
8010075b:	8b 36                	mov    (%esi),%esi
8010075d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100760:	b8 18 70 10 80       	mov    $0x80107018,%eax
80100765:	85 f6                	test   %esi,%esi
80100767:	0f 44 f0             	cmove  %eax,%esi
8010076a:	0f be 06             	movsbl (%esi),%eax
8010076d:	84 c0                	test   %al,%al
8010076f:	74 16                	je     80100787 <cprintf+0x137>
80100771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100778:	83 c6 01             	add    $0x1,%esi
8010077b:	e8 60 fc ff ff       	call   801003e0 <consputc>
80100780:	0f be 06             	movsbl (%esi),%eax
80100783:	84 c0                	test   %al,%al
80100785:	75 f1                	jne    80100778 <cprintf+0x128>
80100787:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010078a:	e9 36 ff ff ff       	jmp    801006c5 <cprintf+0x75>
8010078f:	90                   	nop
80100790:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100797:	e8 34 3b 00 00       	call   801042d0 <acquire>
8010079c:	e9 c8 fe ff ff       	jmp    80100669 <cprintf+0x19>
801007a1:	c7 04 24 1f 70 10 80 	movl   $0x8010701f,(%esp)
801007a8:	e8 b3 fb ff ff       	call   80100360 <panic>
801007ad:	8d 76 00             	lea    0x0(%esi),%esi

801007b0 <consoleintr>:
801007b0:	55                   	push   %ebp
801007b1:	89 e5                	mov    %esp,%ebp
801007b3:	57                   	push   %edi
801007b4:	56                   	push   %esi
801007b5:	31 f6                	xor    %esi,%esi
801007b7:	53                   	push   %ebx
801007b8:	83 ec 1c             	sub    $0x1c,%esp
801007bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
801007be:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801007c5:	e8 06 3b 00 00       	call   801042d0 <acquire>
801007ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801007d0:	ff d3                	call   *%ebx
801007d2:	85 c0                	test   %eax,%eax
801007d4:	89 c7                	mov    %eax,%edi
801007d6:	78 48                	js     80100820 <consoleintr+0x70>
801007d8:	83 ff 10             	cmp    $0x10,%edi
801007db:	0f 84 2f 01 00 00    	je     80100910 <consoleintr+0x160>
801007e1:	7e 5d                	jle    80100840 <consoleintr+0x90>
801007e3:	83 ff 15             	cmp    $0x15,%edi
801007e6:	0f 84 d4 00 00 00    	je     801008c0 <consoleintr+0x110>
801007ec:	83 ff 7f             	cmp    $0x7f,%edi
801007ef:	90                   	nop
801007f0:	75 53                	jne    80100845 <consoleintr+0x95>
801007f2:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801007f7:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801007fd:	74 d1                	je     801007d0 <consoleintr+0x20>
801007ff:	83 e8 01             	sub    $0x1,%eax
80100802:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
80100807:	b8 00 01 00 00       	mov    $0x100,%eax
8010080c:	e8 cf fb ff ff       	call   801003e0 <consputc>
80100811:	ff d3                	call   *%ebx
80100813:	85 c0                	test   %eax,%eax
80100815:	89 c7                	mov    %eax,%edi
80100817:	79 bf                	jns    801007d8 <consoleintr+0x28>
80100819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100820:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100827:	e8 94 3b 00 00       	call   801043c0 <release>
8010082c:	85 f6                	test   %esi,%esi
8010082e:	0f 85 ec 00 00 00    	jne    80100920 <consoleintr+0x170>
80100834:	83 c4 1c             	add    $0x1c,%esp
80100837:	5b                   	pop    %ebx
80100838:	5e                   	pop    %esi
80100839:	5f                   	pop    %edi
8010083a:	5d                   	pop    %ebp
8010083b:	c3                   	ret    
8010083c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100840:	83 ff 08             	cmp    $0x8,%edi
80100843:	74 ad                	je     801007f2 <consoleintr+0x42>
80100845:	85 ff                	test   %edi,%edi
80100847:	74 87                	je     801007d0 <consoleintr+0x20>
80100849:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010084e:	89 c2                	mov    %eax,%edx
80100850:	2b 15 a0 ff 10 80    	sub    0x8010ffa0,%edx
80100856:	83 fa 7f             	cmp    $0x7f,%edx
80100859:	0f 87 71 ff ff ff    	ja     801007d0 <consoleintr+0x20>
8010085f:	8d 50 01             	lea    0x1(%eax),%edx
80100862:	83 e0 7f             	and    $0x7f,%eax
80100865:	83 ff 0d             	cmp    $0xd,%edi
80100868:	89 15 a8 ff 10 80    	mov    %edx,0x8010ffa8
8010086e:	0f 84 b8 00 00 00    	je     8010092c <consoleintr+0x17c>
80100874:	89 f9                	mov    %edi,%ecx
80100876:	88 88 20 ff 10 80    	mov    %cl,-0x7fef00e0(%eax)
8010087c:	89 f8                	mov    %edi,%eax
8010087e:	e8 5d fb ff ff       	call   801003e0 <consputc>
80100883:	83 ff 04             	cmp    $0x4,%edi
80100886:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010088b:	74 19                	je     801008a6 <consoleintr+0xf6>
8010088d:	83 ff 0a             	cmp    $0xa,%edi
80100890:	74 14                	je     801008a6 <consoleintr+0xf6>
80100892:	8b 0d a0 ff 10 80    	mov    0x8010ffa0,%ecx
80100898:	8d 91 80 00 00 00    	lea    0x80(%ecx),%edx
8010089e:	39 d0                	cmp    %edx,%eax
801008a0:	0f 85 2a ff ff ff    	jne    801007d0 <consoleintr+0x20>
801008a6:	c7 04 24 a0 ff 10 80 	movl   $0x8010ffa0,(%esp)
801008ad:	a3 a4 ff 10 80       	mov    %eax,0x8010ffa4
801008b2:	e8 59 36 00 00       	call   80103f10 <wakeup>
801008b7:	e9 14 ff ff ff       	jmp    801007d0 <consoleintr+0x20>
801008bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801008c0:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801008c5:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801008cb:	75 2b                	jne    801008f8 <consoleintr+0x148>
801008cd:	e9 fe fe ff ff       	jmp    801007d0 <consoleintr+0x20>
801008d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801008d8:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
801008dd:	b8 00 01 00 00       	mov    $0x100,%eax
801008e2:	e8 f9 fa ff ff       	call   801003e0 <consputc>
801008e7:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801008ec:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801008f2:	0f 84 d8 fe ff ff    	je     801007d0 <consoleintr+0x20>
801008f8:	83 e8 01             	sub    $0x1,%eax
801008fb:	89 c2                	mov    %eax,%edx
801008fd:	83 e2 7f             	and    $0x7f,%edx
80100900:	80 ba 20 ff 10 80 0a 	cmpb   $0xa,-0x7fef00e0(%edx)
80100907:	75 cf                	jne    801008d8 <consoleintr+0x128>
80100909:	e9 c2 fe ff ff       	jmp    801007d0 <consoleintr+0x20>
8010090e:	66 90                	xchg   %ax,%ax
80100910:	be 01 00 00 00       	mov    $0x1,%esi
80100915:	e9 b6 fe ff ff       	jmp    801007d0 <consoleintr+0x20>
8010091a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100920:	83 c4 1c             	add    $0x1c,%esp
80100923:	5b                   	pop    %ebx
80100924:	5e                   	pop    %esi
80100925:	5f                   	pop    %edi
80100926:	5d                   	pop    %ebp
80100927:	e9 d4 36 00 00       	jmp    80104000 <procdump>
8010092c:	c6 80 20 ff 10 80 0a 	movb   $0xa,-0x7fef00e0(%eax)
80100933:	b8 0a 00 00 00       	mov    $0xa,%eax
80100938:	e8 a3 fa ff ff       	call   801003e0 <consputc>
8010093d:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100942:	e9 5f ff ff ff       	jmp    801008a6 <consoleintr+0xf6>
80100947:	89 f6                	mov    %esi,%esi
80100949:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100950 <consoleinit>:
80100950:	55                   	push   %ebp
80100951:	89 e5                	mov    %esp,%ebp
80100953:	83 ec 18             	sub    $0x18,%esp
80100956:	c7 44 24 04 28 70 10 	movl   $0x80107028,0x4(%esp)
8010095d:	80 
8010095e:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100965:	e8 76 38 00 00       	call   801041e0 <initlock>
8010096a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100971:	00 
80100972:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80100979:	c7 05 6c 09 11 80 f0 	movl   $0x801005f0,0x8011096c
80100980:	05 10 80 
80100983:	c7 05 68 09 11 80 70 	movl   $0x80100270,0x80110968
8010098a:	02 10 80 
8010098d:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
80100994:	00 00 00 
80100997:	e8 24 1a 00 00       	call   801023c0 <ioapicenable>
8010099c:	c9                   	leave  
8010099d:	c3                   	ret    
	...

801009a0 <exec>:
801009a0:	55                   	push   %ebp
801009a1:	89 e5                	mov    %esp,%ebp
801009a3:	57                   	push   %edi
801009a4:	56                   	push   %esi
801009a5:	53                   	push   %ebx
801009a6:	81 ec 2c 01 00 00    	sub    $0x12c,%esp
801009ac:	e8 4f 2e 00 00       	call   80103800 <myproc>
801009b1:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
801009b7:	e8 84 22 00 00       	call   80102c40 <begin_op>
801009bc:	8b 45 08             	mov    0x8(%ebp),%eax
801009bf:	89 04 24             	mov    %eax,(%esp)
801009c2:	e8 49 16 00 00       	call   80102010 <namei>
801009c7:	85 c0                	test   %eax,%eax
801009c9:	89 c3                	mov    %eax,%ebx
801009cb:	0f 84 c2 01 00 00    	je     80100b93 <exec+0x1f3>
801009d1:	89 04 24             	mov    %eax,(%esp)
801009d4:	e8 e7 0d 00 00       	call   801017c0 <ilock>
801009d9:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
801009df:	c7 44 24 0c 34 00 00 	movl   $0x34,0xc(%esp)
801009e6:	00 
801009e7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801009ee:	00 
801009ef:	89 44 24 04          	mov    %eax,0x4(%esp)
801009f3:	89 1c 24             	mov    %ebx,(%esp)
801009f6:	e8 75 10 00 00       	call   80101a70 <readi>
801009fb:	83 f8 34             	cmp    $0x34,%eax
801009fe:	74 20                	je     80100a20 <exec+0x80>
80100a00:	89 1c 24             	mov    %ebx,(%esp)
80100a03:	e8 18 10 00 00       	call   80101a20 <iunlockput>
80100a08:	e8 a3 22 00 00       	call   80102cb0 <end_op>
80100a0d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100a12:	81 c4 2c 01 00 00    	add    $0x12c,%esp
80100a18:	5b                   	pop    %ebx
80100a19:	5e                   	pop    %esi
80100a1a:	5f                   	pop    %edi
80100a1b:	5d                   	pop    %ebp
80100a1c:	c3                   	ret    
80100a1d:	8d 76 00             	lea    0x0(%esi),%esi
80100a20:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a27:	45 4c 46 
80100a2a:	75 d4                	jne    80100a00 <exec+0x60>
80100a2c:	e8 df 62 00 00       	call   80106d10 <setupkvm>
80100a31:	85 c0                	test   %eax,%eax
80100a33:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100a39:	74 c5                	je     80100a00 <exec+0x60>
80100a3b:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100a42:	00 
80100a43:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100a49:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
80100a50:	00 00 00 
80100a53:	0f 84 da 00 00 00    	je     80100b33 <exec+0x193>
80100a59:	31 ff                	xor    %edi,%edi
80100a5b:	eb 18                	jmp    80100a75 <exec+0xd5>
80100a5d:	8d 76 00             	lea    0x0(%esi),%esi
80100a60:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100a67:	83 c7 01             	add    $0x1,%edi
80100a6a:	83 c6 20             	add    $0x20,%esi
80100a6d:	39 f8                	cmp    %edi,%eax
80100a6f:	0f 8e be 00 00 00    	jle    80100b33 <exec+0x193>
80100a75:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100a7b:	c7 44 24 0c 20 00 00 	movl   $0x20,0xc(%esp)
80100a82:	00 
80100a83:	89 74 24 08          	mov    %esi,0x8(%esp)
80100a87:	89 44 24 04          	mov    %eax,0x4(%esp)
80100a8b:	89 1c 24             	mov    %ebx,(%esp)
80100a8e:	e8 dd 0f 00 00       	call   80101a70 <readi>
80100a93:	83 f8 20             	cmp    $0x20,%eax
80100a96:	0f 85 84 00 00 00    	jne    80100b20 <exec+0x180>
80100a9c:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100aa3:	75 bb                	jne    80100a60 <exec+0xc0>
80100aa5:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100aab:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100ab1:	72 6d                	jb     80100b20 <exec+0x180>
80100ab3:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100ab9:	72 65                	jb     80100b20 <exec+0x180>
80100abb:	89 44 24 08          	mov    %eax,0x8(%esp)
80100abf:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100ac5:	89 44 24 04          	mov    %eax,0x4(%esp)
80100ac9:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100acf:	89 04 24             	mov    %eax,(%esp)
80100ad2:	e8 99 60 00 00       	call   80106b70 <allocuvm>
80100ad7:	85 c0                	test   %eax,%eax
80100ad9:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100adf:	74 3f                	je     80100b20 <exec+0x180>
80100ae1:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100ae7:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100aec:	75 32                	jne    80100b20 <exec+0x180>
80100aee:	8b 95 14 ff ff ff    	mov    -0xec(%ebp),%edx
80100af4:	89 44 24 04          	mov    %eax,0x4(%esp)
80100af8:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100afe:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80100b02:	89 54 24 10          	mov    %edx,0x10(%esp)
80100b06:	8b 95 08 ff ff ff    	mov    -0xf8(%ebp),%edx
80100b0c:	89 04 24             	mov    %eax,(%esp)
80100b0f:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100b13:	e8 98 5f 00 00       	call   80106ab0 <loaduvm>
80100b18:	85 c0                	test   %eax,%eax
80100b1a:	0f 89 40 ff ff ff    	jns    80100a60 <exec+0xc0>
80100b20:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100b26:	89 04 24             	mov    %eax,(%esp)
80100b29:	e8 62 61 00 00       	call   80106c90 <freevm>
80100b2e:	e9 cd fe ff ff       	jmp    80100a00 <exec+0x60>
80100b33:	89 1c 24             	mov    %ebx,(%esp)
80100b36:	e8 e5 0e 00 00       	call   80101a20 <iunlockput>
80100b3b:	90                   	nop
80100b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100b40:	e8 6b 21 00 00       	call   80102cb0 <end_op>
80100b45:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100b4b:	05 ff 0f 00 00       	add    $0xfff,%eax
80100b50:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100b55:	8d 90 00 20 00 00    	lea    0x2000(%eax),%edx
80100b5b:	89 44 24 04          	mov    %eax,0x4(%esp)
80100b5f:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100b65:	89 54 24 08          	mov    %edx,0x8(%esp)
80100b69:	89 04 24             	mov    %eax,(%esp)
80100b6c:	e8 ff 5f 00 00       	call   80106b70 <allocuvm>
80100b71:	85 c0                	test   %eax,%eax
80100b73:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
80100b79:	75 33                	jne    80100bae <exec+0x20e>
80100b7b:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100b81:	89 04 24             	mov    %eax,(%esp)
80100b84:	e8 07 61 00 00       	call   80106c90 <freevm>
80100b89:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100b8e:	e9 7f fe ff ff       	jmp    80100a12 <exec+0x72>
80100b93:	e8 18 21 00 00       	call   80102cb0 <end_op>
80100b98:	c7 04 24 41 70 10 80 	movl   $0x80107041,(%esp)
80100b9f:	e8 ac fa ff ff       	call   80100650 <cprintf>
80100ba4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100ba9:	e9 64 fe ff ff       	jmp    80100a12 <exec+0x72>
80100bae:	8b 9d e8 fe ff ff    	mov    -0x118(%ebp),%ebx
80100bb4:	89 d8                	mov    %ebx,%eax
80100bb6:	2d 00 20 00 00       	sub    $0x2000,%eax
80100bbb:	89 44 24 04          	mov    %eax,0x4(%esp)
80100bbf:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100bc5:	89 04 24             	mov    %eax,(%esp)
80100bc8:	e8 f3 61 00 00       	call   80106dc0 <clearpteu>
80100bcd:	8b 45 0c             	mov    0xc(%ebp),%eax
80100bd0:	8b 00                	mov    (%eax),%eax
80100bd2:	85 c0                	test   %eax,%eax
80100bd4:	0f 84 59 01 00 00    	je     80100d33 <exec+0x393>
80100bda:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80100bdd:	31 d2                	xor    %edx,%edx
80100bdf:	8d 71 04             	lea    0x4(%ecx),%esi
80100be2:	89 cf                	mov    %ecx,%edi
80100be4:	89 d1                	mov    %edx,%ecx
80100be6:	89 f2                	mov    %esi,%edx
80100be8:	89 fe                	mov    %edi,%esi
80100bea:	89 cf                	mov    %ecx,%edi
80100bec:	eb 0a                	jmp    80100bf8 <exec+0x258>
80100bee:	66 90                	xchg   %ax,%ax
80100bf0:	83 c2 04             	add    $0x4,%edx
80100bf3:	83 ff 20             	cmp    $0x20,%edi
80100bf6:	74 83                	je     80100b7b <exec+0x1db>
80100bf8:	89 04 24             	mov    %eax,(%esp)
80100bfb:	89 95 ec fe ff ff    	mov    %edx,-0x114(%ebp)
80100c01:	e8 2a 3a 00 00       	call   80104630 <strlen>
80100c06:	f7 d0                	not    %eax
80100c08:	01 c3                	add    %eax,%ebx
80100c0a:	8b 06                	mov    (%esi),%eax
80100c0c:	83 e3 fc             	and    $0xfffffffc,%ebx
80100c0f:	89 04 24             	mov    %eax,(%esp)
80100c12:	e8 19 3a 00 00       	call   80104630 <strlen>
80100c17:	83 c0 01             	add    $0x1,%eax
80100c1a:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100c1e:	8b 06                	mov    (%esi),%eax
80100c20:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80100c24:	89 44 24 08          	mov    %eax,0x8(%esp)
80100c28:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100c2e:	89 04 24             	mov    %eax,(%esp)
80100c31:	e8 ea 62 00 00       	call   80106f20 <copyout>
80100c36:	85 c0                	test   %eax,%eax
80100c38:	0f 88 3d ff ff ff    	js     80100b7b <exec+0x1db>
80100c3e:	8b 95 ec fe ff ff    	mov    -0x114(%ebp),%edx
80100c44:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
80100c4a:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
80100c51:	83 c7 01             	add    $0x1,%edi
80100c54:	8b 02                	mov    (%edx),%eax
80100c56:	89 d6                	mov    %edx,%esi
80100c58:	85 c0                	test   %eax,%eax
80100c5a:	75 94                	jne    80100bf0 <exec+0x250>
80100c5c:	89 fa                	mov    %edi,%edx
80100c5e:	c7 84 95 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edx,4)
80100c65:	00 00 00 00 
80100c69:	8d 04 95 04 00 00 00 	lea    0x4(,%edx,4),%eax
80100c70:	89 95 5c ff ff ff    	mov    %edx,-0xa4(%ebp)
80100c76:	89 da                	mov    %ebx,%edx
80100c78:	29 c2                	sub    %eax,%edx
80100c7a:	83 c0 0c             	add    $0xc,%eax
80100c7d:	29 c3                	sub    %eax,%ebx
80100c7f:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100c83:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100c89:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80100c8d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80100c91:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100c98:	ff ff ff 
80100c9b:	89 04 24             	mov    %eax,(%esp)
80100c9e:	89 95 60 ff ff ff    	mov    %edx,-0xa0(%ebp)
80100ca4:	e8 77 62 00 00       	call   80106f20 <copyout>
80100ca9:	85 c0                	test   %eax,%eax
80100cab:	0f 88 ca fe ff ff    	js     80100b7b <exec+0x1db>
80100cb1:	8b 45 08             	mov    0x8(%ebp),%eax
80100cb4:	0f b6 10             	movzbl (%eax),%edx
80100cb7:	84 d2                	test   %dl,%dl
80100cb9:	74 19                	je     80100cd4 <exec+0x334>
80100cbb:	8b 4d 08             	mov    0x8(%ebp),%ecx
80100cbe:	83 c0 01             	add    $0x1,%eax
80100cc1:	80 fa 2f             	cmp    $0x2f,%dl
80100cc4:	0f b6 10             	movzbl (%eax),%edx
80100cc7:	0f 44 c8             	cmove  %eax,%ecx
80100cca:	83 c0 01             	add    $0x1,%eax
80100ccd:	84 d2                	test   %dl,%dl
80100ccf:	75 f0                	jne    80100cc1 <exec+0x321>
80100cd1:	89 4d 08             	mov    %ecx,0x8(%ebp)
80100cd4:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100cda:	8b 45 08             	mov    0x8(%ebp),%eax
80100cdd:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80100ce4:	00 
80100ce5:	89 44 24 04          	mov    %eax,0x4(%esp)
80100ce9:	89 f8                	mov    %edi,%eax
80100ceb:	83 c0 6c             	add    $0x6c,%eax
80100cee:	89 04 24             	mov    %eax,(%esp)
80100cf1:	e8 fa 38 00 00       	call   801045f0 <safestrcpy>
80100cf6:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
80100cfc:	8b 77 04             	mov    0x4(%edi),%esi
80100cff:	8b 47 18             	mov    0x18(%edi),%eax
80100d02:	89 4f 04             	mov    %ecx,0x4(%edi)
80100d05:	8b 8d e8 fe ff ff    	mov    -0x118(%ebp),%ecx
80100d0b:	89 0f                	mov    %ecx,(%edi)
80100d0d:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d13:	89 50 38             	mov    %edx,0x38(%eax)
80100d16:	8b 47 18             	mov    0x18(%edi),%eax
80100d19:	89 58 44             	mov    %ebx,0x44(%eax)
80100d1c:	89 3c 24             	mov    %edi,(%esp)
80100d1f:	e8 ec 5b 00 00       	call   80106910 <switchuvm>
80100d24:	89 34 24             	mov    %esi,(%esp)
80100d27:	e8 64 5f 00 00       	call   80106c90 <freevm>
80100d2c:	31 c0                	xor    %eax,%eax
80100d2e:	e9 df fc ff ff       	jmp    80100a12 <exec+0x72>
80100d33:	8b 9d e8 fe ff ff    	mov    -0x118(%ebp),%ebx
80100d39:	31 d2                	xor    %edx,%edx
80100d3b:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
80100d41:	e9 18 ff ff ff       	jmp    80100c5e <exec+0x2be>
	...

80100d50 <fileinit>:
80100d50:	55                   	push   %ebp
80100d51:	89 e5                	mov    %esp,%ebp
80100d53:	83 ec 18             	sub    $0x18,%esp
80100d56:	c7 44 24 04 4d 70 10 	movl   $0x8010704d,0x4(%esp)
80100d5d:	80 
80100d5e:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100d65:	e8 76 34 00 00       	call   801041e0 <initlock>
80100d6a:	c9                   	leave  
80100d6b:	c3                   	ret    
80100d6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100d70 <filealloc>:
80100d70:	55                   	push   %ebp
80100d71:	89 e5                	mov    %esp,%ebp
80100d73:	53                   	push   %ebx
80100d74:	bb f4 ff 10 80       	mov    $0x8010fff4,%ebx
80100d79:	83 ec 14             	sub    $0x14,%esp
80100d7c:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100d83:	e8 48 35 00 00       	call   801042d0 <acquire>
80100d88:	eb 11                	jmp    80100d9b <filealloc+0x2b>
80100d8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100d90:	83 c3 18             	add    $0x18,%ebx
80100d93:	81 fb 54 09 11 80    	cmp    $0x80110954,%ebx
80100d99:	74 25                	je     80100dc0 <filealloc+0x50>
80100d9b:	8b 43 04             	mov    0x4(%ebx),%eax
80100d9e:	85 c0                	test   %eax,%eax
80100da0:	75 ee                	jne    80100d90 <filealloc+0x20>
80100da2:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100da9:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
80100db0:	e8 0b 36 00 00       	call   801043c0 <release>
80100db5:	83 c4 14             	add    $0x14,%esp
80100db8:	89 d8                	mov    %ebx,%eax
80100dba:	5b                   	pop    %ebx
80100dbb:	5d                   	pop    %ebp
80100dbc:	c3                   	ret    
80100dbd:	8d 76 00             	lea    0x0(%esi),%esi
80100dc0:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100dc7:	e8 f4 35 00 00       	call   801043c0 <release>
80100dcc:	83 c4 14             	add    $0x14,%esp
80100dcf:	31 c0                	xor    %eax,%eax
80100dd1:	5b                   	pop    %ebx
80100dd2:	5d                   	pop    %ebp
80100dd3:	c3                   	ret    
80100dd4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100dda:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100de0 <filedup>:
80100de0:	55                   	push   %ebp
80100de1:	89 e5                	mov    %esp,%ebp
80100de3:	53                   	push   %ebx
80100de4:	83 ec 14             	sub    $0x14,%esp
80100de7:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100dea:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100df1:	e8 da 34 00 00       	call   801042d0 <acquire>
80100df6:	8b 43 04             	mov    0x4(%ebx),%eax
80100df9:	85 c0                	test   %eax,%eax
80100dfb:	7e 1a                	jle    80100e17 <filedup+0x37>
80100dfd:	83 c0 01             	add    $0x1,%eax
80100e00:	89 43 04             	mov    %eax,0x4(%ebx)
80100e03:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100e0a:	e8 b1 35 00 00       	call   801043c0 <release>
80100e0f:	83 c4 14             	add    $0x14,%esp
80100e12:	89 d8                	mov    %ebx,%eax
80100e14:	5b                   	pop    %ebx
80100e15:	5d                   	pop    %ebp
80100e16:	c3                   	ret    
80100e17:	c7 04 24 54 70 10 80 	movl   $0x80107054,(%esp)
80100e1e:	e8 3d f5 ff ff       	call   80100360 <panic>
80100e23:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100e29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e30 <fileclose>:
80100e30:	55                   	push   %ebp
80100e31:	89 e5                	mov    %esp,%ebp
80100e33:	57                   	push   %edi
80100e34:	56                   	push   %esi
80100e35:	53                   	push   %ebx
80100e36:	83 ec 1c             	sub    $0x1c,%esp
80100e39:	8b 7d 08             	mov    0x8(%ebp),%edi
80100e3c:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100e43:	e8 88 34 00 00       	call   801042d0 <acquire>
80100e48:	8b 57 04             	mov    0x4(%edi),%edx
80100e4b:	85 d2                	test   %edx,%edx
80100e4d:	0f 8e 89 00 00 00    	jle    80100edc <fileclose+0xac>
80100e53:	83 ea 01             	sub    $0x1,%edx
80100e56:	85 d2                	test   %edx,%edx
80100e58:	89 57 04             	mov    %edx,0x4(%edi)
80100e5b:	74 13                	je     80100e70 <fileclose+0x40>
80100e5d:	c7 45 08 c0 ff 10 80 	movl   $0x8010ffc0,0x8(%ebp)
80100e64:	83 c4 1c             	add    $0x1c,%esp
80100e67:	5b                   	pop    %ebx
80100e68:	5e                   	pop    %esi
80100e69:	5f                   	pop    %edi
80100e6a:	5d                   	pop    %ebp
80100e6b:	e9 50 35 00 00       	jmp    801043c0 <release>
80100e70:	0f b6 47 09          	movzbl 0x9(%edi),%eax
80100e74:	8b 37                	mov    (%edi),%esi
80100e76:	8b 5f 0c             	mov    0xc(%edi),%ebx
80100e79:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
80100e7f:	88 45 e7             	mov    %al,-0x19(%ebp)
80100e82:	8b 47 10             	mov    0x10(%edi),%eax
80100e85:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100e8c:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100e8f:	e8 2c 35 00 00       	call   801043c0 <release>
80100e94:	83 fe 01             	cmp    $0x1,%esi
80100e97:	74 0f                	je     80100ea8 <fileclose+0x78>
80100e99:	83 fe 02             	cmp    $0x2,%esi
80100e9c:	74 22                	je     80100ec0 <fileclose+0x90>
80100e9e:	83 c4 1c             	add    $0x1c,%esp
80100ea1:	5b                   	pop    %ebx
80100ea2:	5e                   	pop    %esi
80100ea3:	5f                   	pop    %edi
80100ea4:	5d                   	pop    %ebp
80100ea5:	c3                   	ret    
80100ea6:	66 90                	xchg   %ax,%ax
80100ea8:	0f be 75 e7          	movsbl -0x19(%ebp),%esi
80100eac:	89 1c 24             	mov    %ebx,(%esp)
80100eaf:	89 74 24 04          	mov    %esi,0x4(%esp)
80100eb3:	e8 f8 24 00 00       	call   801033b0 <pipeclose>
80100eb8:	eb e4                	jmp    80100e9e <fileclose+0x6e>
80100eba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100ec0:	e8 7b 1d 00 00       	call   80102c40 <begin_op>
80100ec5:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100ec8:	89 04 24             	mov    %eax,(%esp)
80100ecb:	e8 10 0a 00 00       	call   801018e0 <iput>
80100ed0:	83 c4 1c             	add    $0x1c,%esp
80100ed3:	5b                   	pop    %ebx
80100ed4:	5e                   	pop    %esi
80100ed5:	5f                   	pop    %edi
80100ed6:	5d                   	pop    %ebp
80100ed7:	e9 d4 1d 00 00       	jmp    80102cb0 <end_op>
80100edc:	c7 04 24 5c 70 10 80 	movl   $0x8010705c,(%esp)
80100ee3:	e8 78 f4 ff ff       	call   80100360 <panic>
80100ee8:	90                   	nop
80100ee9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ef0 <filestat>:
80100ef0:	55                   	push   %ebp
80100ef1:	89 e5                	mov    %esp,%ebp
80100ef3:	53                   	push   %ebx
80100ef4:	83 ec 14             	sub    $0x14,%esp
80100ef7:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100efa:	83 3b 02             	cmpl   $0x2,(%ebx)
80100efd:	75 31                	jne    80100f30 <filestat+0x40>
80100eff:	8b 43 10             	mov    0x10(%ebx),%eax
80100f02:	89 04 24             	mov    %eax,(%esp)
80100f05:	e8 b6 08 00 00       	call   801017c0 <ilock>
80100f0a:	8b 45 0c             	mov    0xc(%ebp),%eax
80100f0d:	89 44 24 04          	mov    %eax,0x4(%esp)
80100f11:	8b 43 10             	mov    0x10(%ebx),%eax
80100f14:	89 04 24             	mov    %eax,(%esp)
80100f17:	e8 24 0b 00 00       	call   80101a40 <stati>
80100f1c:	8b 43 10             	mov    0x10(%ebx),%eax
80100f1f:	89 04 24             	mov    %eax,(%esp)
80100f22:	e8 79 09 00 00       	call   801018a0 <iunlock>
80100f27:	83 c4 14             	add    $0x14,%esp
80100f2a:	31 c0                	xor    %eax,%eax
80100f2c:	5b                   	pop    %ebx
80100f2d:	5d                   	pop    %ebp
80100f2e:	c3                   	ret    
80100f2f:	90                   	nop
80100f30:	83 c4 14             	add    $0x14,%esp
80100f33:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100f38:	5b                   	pop    %ebx
80100f39:	5d                   	pop    %ebp
80100f3a:	c3                   	ret    
80100f3b:	90                   	nop
80100f3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f40 <fileread>:
80100f40:	55                   	push   %ebp
80100f41:	89 e5                	mov    %esp,%ebp
80100f43:	57                   	push   %edi
80100f44:	56                   	push   %esi
80100f45:	53                   	push   %ebx
80100f46:	83 ec 1c             	sub    $0x1c,%esp
80100f49:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f4c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f4f:	8b 7d 10             	mov    0x10(%ebp),%edi
80100f52:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100f56:	74 68                	je     80100fc0 <fileread+0x80>
80100f58:	8b 03                	mov    (%ebx),%eax
80100f5a:	83 f8 01             	cmp    $0x1,%eax
80100f5d:	74 49                	je     80100fa8 <fileread+0x68>
80100f5f:	83 f8 02             	cmp    $0x2,%eax
80100f62:	75 63                	jne    80100fc7 <fileread+0x87>
80100f64:	8b 43 10             	mov    0x10(%ebx),%eax
80100f67:	89 04 24             	mov    %eax,(%esp)
80100f6a:	e8 51 08 00 00       	call   801017c0 <ilock>
80100f6f:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80100f73:	8b 43 14             	mov    0x14(%ebx),%eax
80100f76:	89 74 24 04          	mov    %esi,0x4(%esp)
80100f7a:	89 44 24 08          	mov    %eax,0x8(%esp)
80100f7e:	8b 43 10             	mov    0x10(%ebx),%eax
80100f81:	89 04 24             	mov    %eax,(%esp)
80100f84:	e8 e7 0a 00 00       	call   80101a70 <readi>
80100f89:	85 c0                	test   %eax,%eax
80100f8b:	89 c6                	mov    %eax,%esi
80100f8d:	7e 03                	jle    80100f92 <fileread+0x52>
80100f8f:	01 43 14             	add    %eax,0x14(%ebx)
80100f92:	8b 43 10             	mov    0x10(%ebx),%eax
80100f95:	89 04 24             	mov    %eax,(%esp)
80100f98:	e8 03 09 00 00       	call   801018a0 <iunlock>
80100f9d:	89 f0                	mov    %esi,%eax
80100f9f:	83 c4 1c             	add    $0x1c,%esp
80100fa2:	5b                   	pop    %ebx
80100fa3:	5e                   	pop    %esi
80100fa4:	5f                   	pop    %edi
80100fa5:	5d                   	pop    %ebp
80100fa6:	c3                   	ret    
80100fa7:	90                   	nop
80100fa8:	8b 43 0c             	mov    0xc(%ebx),%eax
80100fab:	89 45 08             	mov    %eax,0x8(%ebp)
80100fae:	83 c4 1c             	add    $0x1c,%esp
80100fb1:	5b                   	pop    %ebx
80100fb2:	5e                   	pop    %esi
80100fb3:	5f                   	pop    %edi
80100fb4:	5d                   	pop    %ebp
80100fb5:	e9 76 25 00 00       	jmp    80103530 <piperead>
80100fba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100fc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100fc5:	eb d8                	jmp    80100f9f <fileread+0x5f>
80100fc7:	c7 04 24 66 70 10 80 	movl   $0x80107066,(%esp)
80100fce:	e8 8d f3 ff ff       	call   80100360 <panic>
80100fd3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100fd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100fe0 <filewrite>:
80100fe0:	55                   	push   %ebp
80100fe1:	89 e5                	mov    %esp,%ebp
80100fe3:	57                   	push   %edi
80100fe4:	56                   	push   %esi
80100fe5:	53                   	push   %ebx
80100fe6:	83 ec 2c             	sub    $0x2c,%esp
80100fe9:	8b 45 0c             	mov    0xc(%ebp),%eax
80100fec:	8b 7d 08             	mov    0x8(%ebp),%edi
80100fef:	89 45 dc             	mov    %eax,-0x24(%ebp)
80100ff2:	8b 45 10             	mov    0x10(%ebp),%eax
80100ff5:	80 7f 09 00          	cmpb   $0x0,0x9(%edi)
80100ff9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100ffc:	0f 84 ae 00 00 00    	je     801010b0 <filewrite+0xd0>
80101002:	8b 07                	mov    (%edi),%eax
80101004:	83 f8 01             	cmp    $0x1,%eax
80101007:	0f 84 c2 00 00 00    	je     801010cf <filewrite+0xef>
8010100d:	83 f8 02             	cmp    $0x2,%eax
80101010:	0f 85 d7 00 00 00    	jne    801010ed <filewrite+0x10d>
80101016:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101019:	31 db                	xor    %ebx,%ebx
8010101b:	85 d2                	test   %edx,%edx
8010101d:	7f 31                	jg     80101050 <filewrite+0x70>
8010101f:	e9 9c 00 00 00       	jmp    801010c0 <filewrite+0xe0>
80101024:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101028:	8b 4f 10             	mov    0x10(%edi),%ecx
8010102b:	01 47 14             	add    %eax,0x14(%edi)
8010102e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101031:	89 0c 24             	mov    %ecx,(%esp)
80101034:	e8 67 08 00 00       	call   801018a0 <iunlock>
80101039:	e8 72 1c 00 00       	call   80102cb0 <end_op>
8010103e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101041:	39 f0                	cmp    %esi,%eax
80101043:	0f 85 98 00 00 00    	jne    801010e1 <filewrite+0x101>
80101049:	01 c3                	add    %eax,%ebx
8010104b:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
8010104e:	7e 70                	jle    801010c0 <filewrite+0xe0>
80101050:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101053:	b8 00 06 00 00       	mov    $0x600,%eax
80101058:	29 de                	sub    %ebx,%esi
8010105a:	81 fe 00 06 00 00    	cmp    $0x600,%esi
80101060:	0f 4f f0             	cmovg  %eax,%esi
80101063:	e8 d8 1b 00 00       	call   80102c40 <begin_op>
80101068:	8b 47 10             	mov    0x10(%edi),%eax
8010106b:	89 04 24             	mov    %eax,(%esp)
8010106e:	e8 4d 07 00 00       	call   801017c0 <ilock>
80101073:	89 74 24 0c          	mov    %esi,0xc(%esp)
80101077:	8b 47 14             	mov    0x14(%edi),%eax
8010107a:	89 44 24 08          	mov    %eax,0x8(%esp)
8010107e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101081:	01 d8                	add    %ebx,%eax
80101083:	89 44 24 04          	mov    %eax,0x4(%esp)
80101087:	8b 47 10             	mov    0x10(%edi),%eax
8010108a:	89 04 24             	mov    %eax,(%esp)
8010108d:	e8 de 0a 00 00       	call   80101b70 <writei>
80101092:	85 c0                	test   %eax,%eax
80101094:	7f 92                	jg     80101028 <filewrite+0x48>
80101096:	8b 4f 10             	mov    0x10(%edi),%ecx
80101099:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010109c:	89 0c 24             	mov    %ecx,(%esp)
8010109f:	e8 fc 07 00 00       	call   801018a0 <iunlock>
801010a4:	e8 07 1c 00 00       	call   80102cb0 <end_op>
801010a9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010ac:	85 c0                	test   %eax,%eax
801010ae:	74 91                	je     80101041 <filewrite+0x61>
801010b0:	83 c4 2c             	add    $0x2c,%esp
801010b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801010b8:	5b                   	pop    %ebx
801010b9:	5e                   	pop    %esi
801010ba:	5f                   	pop    %edi
801010bb:	5d                   	pop    %ebp
801010bc:	c3                   	ret    
801010bd:	8d 76 00             	lea    0x0(%esi),%esi
801010c0:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
801010c3:	89 d8                	mov    %ebx,%eax
801010c5:	75 e9                	jne    801010b0 <filewrite+0xd0>
801010c7:	83 c4 2c             	add    $0x2c,%esp
801010ca:	5b                   	pop    %ebx
801010cb:	5e                   	pop    %esi
801010cc:	5f                   	pop    %edi
801010cd:	5d                   	pop    %ebp
801010ce:	c3                   	ret    
801010cf:	8b 47 0c             	mov    0xc(%edi),%eax
801010d2:	89 45 08             	mov    %eax,0x8(%ebp)
801010d5:	83 c4 2c             	add    $0x2c,%esp
801010d8:	5b                   	pop    %ebx
801010d9:	5e                   	pop    %esi
801010da:	5f                   	pop    %edi
801010db:	5d                   	pop    %ebp
801010dc:	e9 5f 23 00 00       	jmp    80103440 <pipewrite>
801010e1:	c7 04 24 6f 70 10 80 	movl   $0x8010706f,(%esp)
801010e8:	e8 73 f2 ff ff       	call   80100360 <panic>
801010ed:	c7 04 24 75 70 10 80 	movl   $0x80107075,(%esp)
801010f4:	e8 67 f2 ff ff       	call   80100360 <panic>
801010f9:	00 00                	add    %al,(%eax)
801010fb:	00 00                	add    %al,(%eax)
801010fd:	00 00                	add    %al,(%eax)
	...

80101100 <balloc>:
80101100:	55                   	push   %ebp
80101101:	89 e5                	mov    %esp,%ebp
80101103:	57                   	push   %edi
80101104:	56                   	push   %esi
80101105:	53                   	push   %ebx
80101106:	83 ec 2c             	sub    $0x2c,%esp
80101109:	89 45 d8             	mov    %eax,-0x28(%ebp)
8010110c:	a1 c0 09 11 80       	mov    0x801109c0,%eax
80101111:	85 c0                	test   %eax,%eax
80101113:	0f 84 8c 00 00 00    	je     801011a5 <balloc+0xa5>
80101119:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
80101120:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101123:	89 f0                	mov    %esi,%eax
80101125:	c1 f8 0c             	sar    $0xc,%eax
80101128:	03 05 d8 09 11 80    	add    0x801109d8,%eax
8010112e:	89 44 24 04          	mov    %eax,0x4(%esp)
80101132:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101135:	89 04 24             	mov    %eax,(%esp)
80101138:	e8 93 ef ff ff       	call   801000d0 <bread>
8010113d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101140:	a1 c0 09 11 80       	mov    0x801109c0,%eax
80101145:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101148:	31 c0                	xor    %eax,%eax
8010114a:	eb 33                	jmp    8010117f <balloc+0x7f>
8010114c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101150:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101153:	89 c2                	mov    %eax,%edx
80101155:	89 c1                	mov    %eax,%ecx
80101157:	c1 fa 03             	sar    $0x3,%edx
8010115a:	83 e1 07             	and    $0x7,%ecx
8010115d:	bf 01 00 00 00       	mov    $0x1,%edi
80101162:	d3 e7                	shl    %cl,%edi
80101164:	0f b6 5c 13 5c       	movzbl 0x5c(%ebx,%edx,1),%ebx
80101169:	89 f9                	mov    %edi,%ecx
8010116b:	0f b6 fb             	movzbl %bl,%edi
8010116e:	85 cf                	test   %ecx,%edi
80101170:	74 46                	je     801011b8 <balloc+0xb8>
80101172:	83 c0 01             	add    $0x1,%eax
80101175:	83 c6 01             	add    $0x1,%esi
80101178:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010117d:	74 05                	je     80101184 <balloc+0x84>
8010117f:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80101182:	72 cc                	jb     80101150 <balloc+0x50>
80101184:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101187:	89 04 24             	mov    %eax,(%esp)
8010118a:	e8 51 f0 ff ff       	call   801001e0 <brelse>
8010118f:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101196:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101199:	3b 05 c0 09 11 80    	cmp    0x801109c0,%eax
8010119f:	0f 82 7b ff ff ff    	jb     80101120 <balloc+0x20>
801011a5:	c7 04 24 7f 70 10 80 	movl   $0x8010707f,(%esp)
801011ac:	e8 af f1 ff ff       	call   80100360 <panic>
801011b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801011b8:	09 d9                	or     %ebx,%ecx
801011ba:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801011bd:	88 4c 13 5c          	mov    %cl,0x5c(%ebx,%edx,1)
801011c1:	89 1c 24             	mov    %ebx,(%esp)
801011c4:	e8 37 1c 00 00       	call   80102e00 <log_write>
801011c9:	89 1c 24             	mov    %ebx,(%esp)
801011cc:	e8 0f f0 ff ff       	call   801001e0 <brelse>
801011d1:	8b 45 d8             	mov    -0x28(%ebp),%eax
801011d4:	89 74 24 04          	mov    %esi,0x4(%esp)
801011d8:	89 04 24             	mov    %eax,(%esp)
801011db:	e8 f0 ee ff ff       	call   801000d0 <bread>
801011e0:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
801011e7:	00 
801011e8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801011ef:	00 
801011f0:	89 c3                	mov    %eax,%ebx
801011f2:	8d 40 5c             	lea    0x5c(%eax),%eax
801011f5:	89 04 24             	mov    %eax,(%esp)
801011f8:	e8 13 32 00 00       	call   80104410 <memset>
801011fd:	89 1c 24             	mov    %ebx,(%esp)
80101200:	e8 fb 1b 00 00       	call   80102e00 <log_write>
80101205:	89 1c 24             	mov    %ebx,(%esp)
80101208:	e8 d3 ef ff ff       	call   801001e0 <brelse>
8010120d:	83 c4 2c             	add    $0x2c,%esp
80101210:	89 f0                	mov    %esi,%eax
80101212:	5b                   	pop    %ebx
80101213:	5e                   	pop    %esi
80101214:	5f                   	pop    %edi
80101215:	5d                   	pop    %ebp
80101216:	c3                   	ret    
80101217:	89 f6                	mov    %esi,%esi
80101219:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101220 <iget>:
80101220:	55                   	push   %ebp
80101221:	89 e5                	mov    %esp,%ebp
80101223:	57                   	push   %edi
80101224:	89 c7                	mov    %eax,%edi
80101226:	56                   	push   %esi
80101227:	31 f6                	xor    %esi,%esi
80101229:	53                   	push   %ebx
8010122a:	bb 14 0a 11 80       	mov    $0x80110a14,%ebx
8010122f:	83 ec 1c             	sub    $0x1c,%esp
80101232:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101239:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010123c:	e8 8f 30 00 00       	call   801042d0 <acquire>
80101241:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101244:	eb 14                	jmp    8010125a <iget+0x3a>
80101246:	66 90                	xchg   %ax,%ax
80101248:	85 f6                	test   %esi,%esi
8010124a:	74 3c                	je     80101288 <iget+0x68>
8010124c:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
80101252:	81 fb 6c 25 11 80    	cmp    $0x8011256c,%ebx
80101258:	74 46                	je     801012a0 <iget+0x80>
8010125a:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010125d:	85 c9                	test   %ecx,%ecx
8010125f:	7e e7                	jle    80101248 <iget+0x28>
80101261:	39 3b                	cmp    %edi,(%ebx)
80101263:	75 e3                	jne    80101248 <iget+0x28>
80101265:	39 53 04             	cmp    %edx,0x4(%ebx)
80101268:	75 de                	jne    80101248 <iget+0x28>
8010126a:	83 c1 01             	add    $0x1,%ecx
8010126d:	89 de                	mov    %ebx,%esi
8010126f:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101276:	89 4b 08             	mov    %ecx,0x8(%ebx)
80101279:	e8 42 31 00 00       	call   801043c0 <release>
8010127e:	83 c4 1c             	add    $0x1c,%esp
80101281:	89 f0                	mov    %esi,%eax
80101283:	5b                   	pop    %ebx
80101284:	5e                   	pop    %esi
80101285:	5f                   	pop    %edi
80101286:	5d                   	pop    %ebp
80101287:	c3                   	ret    
80101288:	85 c9                	test   %ecx,%ecx
8010128a:	0f 44 f3             	cmove  %ebx,%esi
8010128d:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
80101293:	81 fb 6c 25 11 80    	cmp    $0x8011256c,%ebx
80101299:	75 bf                	jne    8010125a <iget+0x3a>
8010129b:	90                   	nop
8010129c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801012a0:	85 f6                	test   %esi,%esi
801012a2:	74 29                	je     801012cd <iget+0xad>
801012a4:	89 3e                	mov    %edi,(%esi)
801012a6:	89 56 04             	mov    %edx,0x4(%esi)
801012a9:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
801012b0:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
801012b7:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801012be:	e8 fd 30 00 00       	call   801043c0 <release>
801012c3:	83 c4 1c             	add    $0x1c,%esp
801012c6:	89 f0                	mov    %esi,%eax
801012c8:	5b                   	pop    %ebx
801012c9:	5e                   	pop    %esi
801012ca:	5f                   	pop    %edi
801012cb:	5d                   	pop    %ebp
801012cc:	c3                   	ret    
801012cd:	c7 04 24 95 70 10 80 	movl   $0x80107095,(%esp)
801012d4:	e8 87 f0 ff ff       	call   80100360 <panic>
801012d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801012e0 <bmap>:
801012e0:	55                   	push   %ebp
801012e1:	89 e5                	mov    %esp,%ebp
801012e3:	57                   	push   %edi
801012e4:	56                   	push   %esi
801012e5:	53                   	push   %ebx
801012e6:	89 c3                	mov    %eax,%ebx
801012e8:	83 ec 1c             	sub    $0x1c,%esp
801012eb:	83 fa 0a             	cmp    $0xa,%edx
801012ee:	77 18                	ja     80101308 <bmap+0x28>
801012f0:	8d 34 90             	lea    (%eax,%edx,4),%esi
801012f3:	8b 46 5c             	mov    0x5c(%esi),%eax
801012f6:	85 c0                	test   %eax,%eax
801012f8:	0f 84 da 00 00 00    	je     801013d8 <bmap+0xf8>
801012fe:	83 c4 1c             	add    $0x1c,%esp
80101301:	5b                   	pop    %ebx
80101302:	5e                   	pop    %esi
80101303:	5f                   	pop    %edi
80101304:	5d                   	pop    %ebp
80101305:	c3                   	ret    
80101306:	66 90                	xchg   %ax,%ax
80101308:	8d 72 f5             	lea    -0xb(%edx),%esi
8010130b:	83 fe 7f             	cmp    $0x7f,%esi
8010130e:	0f 86 84 00 00 00    	jbe    80101398 <bmap+0xb8>
80101314:	8d b2 75 ff ff ff    	lea    -0x8b(%edx),%esi
8010131a:	81 fe ff 3f 00 00    	cmp    $0x3fff,%esi
80101320:	0f 87 64 01 00 00    	ja     8010148a <bmap+0x1aa>
80101326:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
8010132c:	85 c0                	test   %eax,%eax
8010132e:	0f 84 44 01 00 00    	je     80101478 <bmap+0x198>
80101334:	89 44 24 04          	mov    %eax,0x4(%esp)
80101338:	8b 03                	mov    (%ebx),%eax
8010133a:	89 f7                	mov    %esi,%edi
8010133c:	c1 ee 07             	shr    $0x7,%esi
8010133f:	83 e7 7f             	and    $0x7f,%edi
80101342:	89 04 24             	mov    %eax,(%esp)
80101345:	e8 86 ed ff ff       	call   801000d0 <bread>
8010134a:	8d 54 b0 5c          	lea    0x5c(%eax,%esi,4),%edx
8010134e:	89 c1                	mov    %eax,%ecx
80101350:	8b 32                	mov    (%edx),%esi
80101352:	85 f6                	test   %esi,%esi
80101354:	0f 84 de 00 00 00    	je     80101438 <bmap+0x158>
8010135a:	89 0c 24             	mov    %ecx,(%esp)
8010135d:	e8 7e ee ff ff       	call   801001e0 <brelse>
80101362:	8b 03                	mov    (%ebx),%eax
80101364:	89 74 24 04          	mov    %esi,0x4(%esp)
80101368:	89 04 24             	mov    %eax,(%esp)
8010136b:	e8 60 ed ff ff       	call   801000d0 <bread>
80101370:	8d 7c b8 5c          	lea    0x5c(%eax,%edi,4),%edi
80101374:	89 c2                	mov    %eax,%edx
80101376:	8b 37                	mov    (%edi),%esi
80101378:	85 f6                	test   %esi,%esi
8010137a:	0f 84 90 00 00 00    	je     80101410 <bmap+0x130>
80101380:	89 14 24             	mov    %edx,(%esp)
80101383:	e8 58 ee ff ff       	call   801001e0 <brelse>
80101388:	83 c4 1c             	add    $0x1c,%esp
8010138b:	89 f0                	mov    %esi,%eax
8010138d:	5b                   	pop    %ebx
8010138e:	5e                   	pop    %esi
8010138f:	5f                   	pop    %edi
80101390:	5d                   	pop    %ebp
80101391:	c3                   	ret    
80101392:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101398:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
8010139e:	85 c0                	test   %eax,%eax
801013a0:	0f 84 ba 00 00 00    	je     80101460 <bmap+0x180>
801013a6:	89 44 24 04          	mov    %eax,0x4(%esp)
801013aa:	8b 03                	mov    (%ebx),%eax
801013ac:	89 04 24             	mov    %eax,(%esp)
801013af:	e8 1c ed ff ff       	call   801000d0 <bread>
801013b4:	8d 54 b0 5c          	lea    0x5c(%eax,%esi,4),%edx
801013b8:	89 c7                	mov    %eax,%edi
801013ba:	8b 32                	mov    (%edx),%esi
801013bc:	85 f6                	test   %esi,%esi
801013be:	74 30                	je     801013f0 <bmap+0x110>
801013c0:	89 3c 24             	mov    %edi,(%esp)
801013c3:	e8 18 ee ff ff       	call   801001e0 <brelse>
801013c8:	83 c4 1c             	add    $0x1c,%esp
801013cb:	89 f0                	mov    %esi,%eax
801013cd:	5b                   	pop    %ebx
801013ce:	5e                   	pop    %esi
801013cf:	5f                   	pop    %edi
801013d0:	5d                   	pop    %ebp
801013d1:	c3                   	ret    
801013d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801013d8:	8b 03                	mov    (%ebx),%eax
801013da:	e8 21 fd ff ff       	call   80101100 <balloc>
801013df:	89 46 5c             	mov    %eax,0x5c(%esi)
801013e2:	83 c4 1c             	add    $0x1c,%esp
801013e5:	5b                   	pop    %ebx
801013e6:	5e                   	pop    %esi
801013e7:	5f                   	pop    %edi
801013e8:	5d                   	pop    %ebp
801013e9:	c3                   	ret    
801013ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801013f0:	8b 03                	mov    (%ebx),%eax
801013f2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801013f5:	e8 06 fd ff ff       	call   80101100 <balloc>
801013fa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801013fd:	89 02                	mov    %eax,(%edx)
801013ff:	89 c6                	mov    %eax,%esi
80101401:	89 3c 24             	mov    %edi,(%esp)
80101404:	e8 f7 19 00 00       	call   80102e00 <log_write>
80101409:	eb b5                	jmp    801013c0 <bmap+0xe0>
8010140b:	90                   	nop
8010140c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101410:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101413:	8b 03                	mov    (%ebx),%eax
80101415:	e8 e6 fc ff ff       	call   80101100 <balloc>
8010141a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010141d:	89 07                	mov    %eax,(%edi)
8010141f:	89 c6                	mov    %eax,%esi
80101421:	89 14 24             	mov    %edx,(%esp)
80101424:	e8 d7 19 00 00       	call   80102e00 <log_write>
80101429:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010142c:	e9 4f ff ff ff       	jmp    80101380 <bmap+0xa0>
80101431:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101438:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010143b:	8b 03                	mov    (%ebx),%eax
8010143d:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101440:	e8 bb fc ff ff       	call   80101100 <balloc>
80101445:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101448:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010144b:	89 02                	mov    %eax,(%edx)
8010144d:	89 c6                	mov    %eax,%esi
8010144f:	89 0c 24             	mov    %ecx,(%esp)
80101452:	e8 a9 19 00 00       	call   80102e00 <log_write>
80101457:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010145a:	e9 fb fe ff ff       	jmp    8010135a <bmap+0x7a>
8010145f:	90                   	nop
80101460:	8b 03                	mov    (%ebx),%eax
80101462:	e8 99 fc ff ff       	call   80101100 <balloc>
80101467:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
8010146d:	e9 34 ff ff ff       	jmp    801013a6 <bmap+0xc6>
80101472:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101478:	8b 03                	mov    (%ebx),%eax
8010147a:	e8 81 fc ff ff       	call   80101100 <balloc>
8010147f:	89 83 8c 00 00 00    	mov    %eax,0x8c(%ebx)
80101485:	e9 aa fe ff ff       	jmp    80101334 <bmap+0x54>
8010148a:	c7 04 24 a5 70 10 80 	movl   $0x801070a5,(%esp)
80101491:	e8 ca ee ff ff       	call   80100360 <panic>
80101496:	8d 76 00             	lea    0x0(%esi),%esi
80101499:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801014a0 <readsb>:
801014a0:	55                   	push   %ebp
801014a1:	89 e5                	mov    %esp,%ebp
801014a3:	56                   	push   %esi
801014a4:	53                   	push   %ebx
801014a5:	83 ec 10             	sub    $0x10,%esp
801014a8:	8b 45 08             	mov    0x8(%ebp),%eax
801014ab:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801014b2:	00 
801014b3:	8b 75 0c             	mov    0xc(%ebp),%esi
801014b6:	89 04 24             	mov    %eax,(%esp)
801014b9:	e8 12 ec ff ff       	call   801000d0 <bread>
801014be:	89 34 24             	mov    %esi,(%esp)
801014c1:	c7 44 24 08 1c 00 00 	movl   $0x1c,0x8(%esp)
801014c8:	00 
801014c9:	89 c3                	mov    %eax,%ebx
801014cb:	8d 40 5c             	lea    0x5c(%eax),%eax
801014ce:	89 44 24 04          	mov    %eax,0x4(%esp)
801014d2:	e8 d9 2f 00 00       	call   801044b0 <memmove>
801014d7:	89 5d 08             	mov    %ebx,0x8(%ebp)
801014da:	83 c4 10             	add    $0x10,%esp
801014dd:	5b                   	pop    %ebx
801014de:	5e                   	pop    %esi
801014df:	5d                   	pop    %ebp
801014e0:	e9 fb ec ff ff       	jmp    801001e0 <brelse>
801014e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801014e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801014f0 <bfree>:
801014f0:	55                   	push   %ebp
801014f1:	89 e5                	mov    %esp,%ebp
801014f3:	57                   	push   %edi
801014f4:	89 d7                	mov    %edx,%edi
801014f6:	56                   	push   %esi
801014f7:	53                   	push   %ebx
801014f8:	89 c3                	mov    %eax,%ebx
801014fa:	83 ec 1c             	sub    $0x1c,%esp
801014fd:	89 04 24             	mov    %eax,(%esp)
80101500:	c7 44 24 04 c0 09 11 	movl   $0x801109c0,0x4(%esp)
80101507:	80 
80101508:	e8 93 ff ff ff       	call   801014a0 <readsb>
8010150d:	89 fa                	mov    %edi,%edx
8010150f:	c1 ea 0c             	shr    $0xc,%edx
80101512:	03 15 d8 09 11 80    	add    0x801109d8,%edx
80101518:	89 1c 24             	mov    %ebx,(%esp)
8010151b:	bb 01 00 00 00       	mov    $0x1,%ebx
80101520:	89 54 24 04          	mov    %edx,0x4(%esp)
80101524:	e8 a7 eb ff ff       	call   801000d0 <bread>
80101529:	89 f9                	mov    %edi,%ecx
8010152b:	81 e7 ff 0f 00 00    	and    $0xfff,%edi
80101531:	89 fa                	mov    %edi,%edx
80101533:	83 e1 07             	and    $0x7,%ecx
80101536:	c1 fa 03             	sar    $0x3,%edx
80101539:	d3 e3                	shl    %cl,%ebx
8010153b:	89 c6                	mov    %eax,%esi
8010153d:	0f b6 44 10 5c       	movzbl 0x5c(%eax,%edx,1),%eax
80101542:	0f b6 c8             	movzbl %al,%ecx
80101545:	85 d9                	test   %ebx,%ecx
80101547:	74 20                	je     80101569 <bfree+0x79>
80101549:	f7 d3                	not    %ebx
8010154b:	21 c3                	and    %eax,%ebx
8010154d:	88 5c 16 5c          	mov    %bl,0x5c(%esi,%edx,1)
80101551:	89 34 24             	mov    %esi,(%esp)
80101554:	e8 a7 18 00 00       	call   80102e00 <log_write>
80101559:	89 34 24             	mov    %esi,(%esp)
8010155c:	e8 7f ec ff ff       	call   801001e0 <brelse>
80101561:	83 c4 1c             	add    $0x1c,%esp
80101564:	5b                   	pop    %ebx
80101565:	5e                   	pop    %esi
80101566:	5f                   	pop    %edi
80101567:	5d                   	pop    %ebp
80101568:	c3                   	ret    
80101569:	c7 04 24 b8 70 10 80 	movl   $0x801070b8,(%esp)
80101570:	e8 eb ed ff ff       	call   80100360 <panic>
80101575:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101579:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101580 <iinit>:
80101580:	55                   	push   %ebp
80101581:	89 e5                	mov    %esp,%ebp
80101583:	53                   	push   %ebx
80101584:	bb 20 0a 11 80       	mov    $0x80110a20,%ebx
80101589:	83 ec 24             	sub    $0x24,%esp
8010158c:	c7 44 24 04 cb 70 10 	movl   $0x801070cb,0x4(%esp)
80101593:	80 
80101594:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010159b:	e8 40 2c 00 00       	call   801041e0 <initlock>
801015a0:	89 1c 24             	mov    %ebx,(%esp)
801015a3:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
801015a9:	c7 44 24 04 d2 70 10 	movl   $0x801070d2,0x4(%esp)
801015b0:	80 
801015b1:	e8 1a 2b 00 00       	call   801040d0 <initsleeplock>
801015b6:	81 fb 78 25 11 80    	cmp    $0x80112578,%ebx
801015bc:	75 e2                	jne    801015a0 <iinit+0x20>
801015be:	8b 45 08             	mov    0x8(%ebp),%eax
801015c1:	c7 44 24 04 c0 09 11 	movl   $0x801109c0,0x4(%esp)
801015c8:	80 
801015c9:	89 04 24             	mov    %eax,(%esp)
801015cc:	e8 cf fe ff ff       	call   801014a0 <readsb>
801015d1:	a1 d8 09 11 80       	mov    0x801109d8,%eax
801015d6:	c7 04 24 38 71 10 80 	movl   $0x80107138,(%esp)
801015dd:	89 44 24 1c          	mov    %eax,0x1c(%esp)
801015e1:	a1 d4 09 11 80       	mov    0x801109d4,%eax
801015e6:	89 44 24 18          	mov    %eax,0x18(%esp)
801015ea:	a1 d0 09 11 80       	mov    0x801109d0,%eax
801015ef:	89 44 24 14          	mov    %eax,0x14(%esp)
801015f3:	a1 cc 09 11 80       	mov    0x801109cc,%eax
801015f8:	89 44 24 10          	mov    %eax,0x10(%esp)
801015fc:	a1 c8 09 11 80       	mov    0x801109c8,%eax
80101601:	89 44 24 0c          	mov    %eax,0xc(%esp)
80101605:	a1 c4 09 11 80       	mov    0x801109c4,%eax
8010160a:	89 44 24 08          	mov    %eax,0x8(%esp)
8010160e:	a1 c0 09 11 80       	mov    0x801109c0,%eax
80101613:	89 44 24 04          	mov    %eax,0x4(%esp)
80101617:	e8 34 f0 ff ff       	call   80100650 <cprintf>
8010161c:	83 c4 24             	add    $0x24,%esp
8010161f:	5b                   	pop    %ebx
80101620:	5d                   	pop    %ebp
80101621:	c3                   	ret    
80101622:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101629:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101630 <ialloc>:
80101630:	55                   	push   %ebp
80101631:	89 e5                	mov    %esp,%ebp
80101633:	57                   	push   %edi
80101634:	56                   	push   %esi
80101635:	53                   	push   %ebx
80101636:	83 ec 2c             	sub    $0x2c,%esp
80101639:	8b 45 0c             	mov    0xc(%ebp),%eax
8010163c:	83 3d c8 09 11 80 01 	cmpl   $0x1,0x801109c8
80101643:	8b 7d 08             	mov    0x8(%ebp),%edi
80101646:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101649:	0f 86 a2 00 00 00    	jbe    801016f1 <ialloc+0xc1>
8010164f:	be 01 00 00 00       	mov    $0x1,%esi
80101654:	bb 01 00 00 00       	mov    $0x1,%ebx
80101659:	eb 1a                	jmp    80101675 <ialloc+0x45>
8010165b:	90                   	nop
8010165c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101660:	89 14 24             	mov    %edx,(%esp)
80101663:	83 c3 01             	add    $0x1,%ebx
80101666:	e8 75 eb ff ff       	call   801001e0 <brelse>
8010166b:	89 de                	mov    %ebx,%esi
8010166d:	3b 1d c8 09 11 80    	cmp    0x801109c8,%ebx
80101673:	73 7c                	jae    801016f1 <ialloc+0xc1>
80101675:	89 f0                	mov    %esi,%eax
80101677:	c1 e8 03             	shr    $0x3,%eax
8010167a:	03 05 d4 09 11 80    	add    0x801109d4,%eax
80101680:	89 3c 24             	mov    %edi,(%esp)
80101683:	89 44 24 04          	mov    %eax,0x4(%esp)
80101687:	e8 44 ea ff ff       	call   801000d0 <bread>
8010168c:	89 c2                	mov    %eax,%edx
8010168e:	89 f0                	mov    %esi,%eax
80101690:	83 e0 07             	and    $0x7,%eax
80101693:	c1 e0 06             	shl    $0x6,%eax
80101696:	8d 4c 02 5c          	lea    0x5c(%edx,%eax,1),%ecx
8010169a:	66 83 39 00          	cmpw   $0x0,(%ecx)
8010169e:	75 c0                	jne    80101660 <ialloc+0x30>
801016a0:	89 0c 24             	mov    %ecx,(%esp)
801016a3:	c7 44 24 08 40 00 00 	movl   $0x40,0x8(%esp)
801016aa:	00 
801016ab:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801016b2:	00 
801016b3:	89 55 dc             	mov    %edx,-0x24(%ebp)
801016b6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801016b9:	e8 52 2d 00 00       	call   80104410 <memset>
801016be:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801016c2:	8b 55 dc             	mov    -0x24(%ebp),%edx
801016c5:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801016c8:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801016cb:	66 89 01             	mov    %ax,(%ecx)
801016ce:	89 14 24             	mov    %edx,(%esp)
801016d1:	e8 2a 17 00 00       	call   80102e00 <log_write>
801016d6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801016d9:	89 14 24             	mov    %edx,(%esp)
801016dc:	e8 ff ea ff ff       	call   801001e0 <brelse>
801016e1:	83 c4 2c             	add    $0x2c,%esp
801016e4:	89 f2                	mov    %esi,%edx
801016e6:	5b                   	pop    %ebx
801016e7:	89 f8                	mov    %edi,%eax
801016e9:	5e                   	pop    %esi
801016ea:	5f                   	pop    %edi
801016eb:	5d                   	pop    %ebp
801016ec:	e9 2f fb ff ff       	jmp    80101220 <iget>
801016f1:	c7 04 24 d8 70 10 80 	movl   $0x801070d8,(%esp)
801016f8:	e8 63 ec ff ff       	call   80100360 <panic>
801016fd:	8d 76 00             	lea    0x0(%esi),%esi

80101700 <iupdate>:
80101700:	55                   	push   %ebp
80101701:	89 e5                	mov    %esp,%ebp
80101703:	56                   	push   %esi
80101704:	53                   	push   %ebx
80101705:	83 ec 10             	sub    $0x10,%esp
80101708:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010170b:	8b 43 04             	mov    0x4(%ebx),%eax
8010170e:	83 c3 5c             	add    $0x5c,%ebx
80101711:	c1 e8 03             	shr    $0x3,%eax
80101714:	03 05 d4 09 11 80    	add    0x801109d4,%eax
8010171a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010171e:	8b 43 a4             	mov    -0x5c(%ebx),%eax
80101721:	89 04 24             	mov    %eax,(%esp)
80101724:	e8 a7 e9 ff ff       	call   801000d0 <bread>
80101729:	8b 53 a8             	mov    -0x58(%ebx),%edx
8010172c:	83 e2 07             	and    $0x7,%edx
8010172f:	c1 e2 06             	shl    $0x6,%edx
80101732:	8d 54 10 5c          	lea    0x5c(%eax,%edx,1),%edx
80101736:	89 c6                	mov    %eax,%esi
80101738:	0f b7 43 f4          	movzwl -0xc(%ebx),%eax
8010173c:	83 c2 0c             	add    $0xc,%edx
8010173f:	66 89 42 f4          	mov    %ax,-0xc(%edx)
80101743:	0f b7 43 f6          	movzwl -0xa(%ebx),%eax
80101747:	66 89 42 f6          	mov    %ax,-0xa(%edx)
8010174b:	0f b7 43 f8          	movzwl -0x8(%ebx),%eax
8010174f:	66 89 42 f8          	mov    %ax,-0x8(%edx)
80101753:	0f b7 43 fa          	movzwl -0x6(%ebx),%eax
80101757:	66 89 42 fa          	mov    %ax,-0x6(%edx)
8010175b:	8b 43 fc             	mov    -0x4(%ebx),%eax
8010175e:	89 42 fc             	mov    %eax,-0x4(%edx)
80101761:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101765:	89 14 24             	mov    %edx,(%esp)
80101768:	c7 44 24 08 30 00 00 	movl   $0x30,0x8(%esp)
8010176f:	00 
80101770:	e8 3b 2d 00 00       	call   801044b0 <memmove>
80101775:	89 34 24             	mov    %esi,(%esp)
80101778:	e8 83 16 00 00       	call   80102e00 <log_write>
8010177d:	89 75 08             	mov    %esi,0x8(%ebp)
80101780:	83 c4 10             	add    $0x10,%esp
80101783:	5b                   	pop    %ebx
80101784:	5e                   	pop    %esi
80101785:	5d                   	pop    %ebp
80101786:	e9 55 ea ff ff       	jmp    801001e0 <brelse>
8010178b:	90                   	nop
8010178c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101790 <idup>:
80101790:	55                   	push   %ebp
80101791:	89 e5                	mov    %esp,%ebp
80101793:	53                   	push   %ebx
80101794:	83 ec 14             	sub    $0x14,%esp
80101797:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010179a:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801017a1:	e8 2a 2b 00 00       	call   801042d0 <acquire>
801017a6:	83 43 08 01          	addl   $0x1,0x8(%ebx)
801017aa:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801017b1:	e8 0a 2c 00 00       	call   801043c0 <release>
801017b6:	83 c4 14             	add    $0x14,%esp
801017b9:	89 d8                	mov    %ebx,%eax
801017bb:	5b                   	pop    %ebx
801017bc:	5d                   	pop    %ebp
801017bd:	c3                   	ret    
801017be:	66 90                	xchg   %ax,%ax

801017c0 <ilock>:
801017c0:	55                   	push   %ebp
801017c1:	89 e5                	mov    %esp,%ebp
801017c3:	56                   	push   %esi
801017c4:	53                   	push   %ebx
801017c5:	83 ec 10             	sub    $0x10,%esp
801017c8:	8b 5d 08             	mov    0x8(%ebp),%ebx
801017cb:	85 db                	test   %ebx,%ebx
801017cd:	0f 84 b3 00 00 00    	je     80101886 <ilock+0xc6>
801017d3:	8b 4b 08             	mov    0x8(%ebx),%ecx
801017d6:	85 c9                	test   %ecx,%ecx
801017d8:	0f 8e a8 00 00 00    	jle    80101886 <ilock+0xc6>
801017de:	8d 43 0c             	lea    0xc(%ebx),%eax
801017e1:	89 04 24             	mov    %eax,(%esp)
801017e4:	e8 27 29 00 00       	call   80104110 <acquiresleep>
801017e9:	8b 53 4c             	mov    0x4c(%ebx),%edx
801017ec:	85 d2                	test   %edx,%edx
801017ee:	74 08                	je     801017f8 <ilock+0x38>
801017f0:	83 c4 10             	add    $0x10,%esp
801017f3:	5b                   	pop    %ebx
801017f4:	5e                   	pop    %esi
801017f5:	5d                   	pop    %ebp
801017f6:	c3                   	ret    
801017f7:	90                   	nop
801017f8:	8b 43 04             	mov    0x4(%ebx),%eax
801017fb:	c1 e8 03             	shr    $0x3,%eax
801017fe:	03 05 d4 09 11 80    	add    0x801109d4,%eax
80101804:	89 44 24 04          	mov    %eax,0x4(%esp)
80101808:	8b 03                	mov    (%ebx),%eax
8010180a:	89 04 24             	mov    %eax,(%esp)
8010180d:	e8 be e8 ff ff       	call   801000d0 <bread>
80101812:	8b 53 04             	mov    0x4(%ebx),%edx
80101815:	83 e2 07             	and    $0x7,%edx
80101818:	c1 e2 06             	shl    $0x6,%edx
8010181b:	8d 54 10 5c          	lea    0x5c(%eax,%edx,1),%edx
8010181f:	89 c6                	mov    %eax,%esi
80101821:	0f b7 02             	movzwl (%edx),%eax
80101824:	83 c2 0c             	add    $0xc,%edx
80101827:	66 89 43 50          	mov    %ax,0x50(%ebx)
8010182b:	0f b7 42 f6          	movzwl -0xa(%edx),%eax
8010182f:	66 89 43 52          	mov    %ax,0x52(%ebx)
80101833:	0f b7 42 f8          	movzwl -0x8(%edx),%eax
80101837:	66 89 43 54          	mov    %ax,0x54(%ebx)
8010183b:	0f b7 42 fa          	movzwl -0x6(%edx),%eax
8010183f:	66 89 43 56          	mov    %ax,0x56(%ebx)
80101843:	8b 42 fc             	mov    -0x4(%edx),%eax
80101846:	89 43 58             	mov    %eax,0x58(%ebx)
80101849:	8d 43 5c             	lea    0x5c(%ebx),%eax
8010184c:	89 54 24 04          	mov    %edx,0x4(%esp)
80101850:	c7 44 24 08 30 00 00 	movl   $0x30,0x8(%esp)
80101857:	00 
80101858:	89 04 24             	mov    %eax,(%esp)
8010185b:	e8 50 2c 00 00       	call   801044b0 <memmove>
80101860:	89 34 24             	mov    %esi,(%esp)
80101863:	e8 78 e9 ff ff       	call   801001e0 <brelse>
80101868:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
8010186d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
80101874:	0f 85 76 ff ff ff    	jne    801017f0 <ilock+0x30>
8010187a:	c7 04 24 f0 70 10 80 	movl   $0x801070f0,(%esp)
80101881:	e8 da ea ff ff       	call   80100360 <panic>
80101886:	c7 04 24 ea 70 10 80 	movl   $0x801070ea,(%esp)
8010188d:	e8 ce ea ff ff       	call   80100360 <panic>
80101892:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101899:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801018a0 <iunlock>:
801018a0:	55                   	push   %ebp
801018a1:	89 e5                	mov    %esp,%ebp
801018a3:	56                   	push   %esi
801018a4:	53                   	push   %ebx
801018a5:	83 ec 10             	sub    $0x10,%esp
801018a8:	8b 5d 08             	mov    0x8(%ebp),%ebx
801018ab:	85 db                	test   %ebx,%ebx
801018ad:	74 24                	je     801018d3 <iunlock+0x33>
801018af:	8d 73 0c             	lea    0xc(%ebx),%esi
801018b2:	89 34 24             	mov    %esi,(%esp)
801018b5:	e8 f6 28 00 00       	call   801041b0 <holdingsleep>
801018ba:	85 c0                	test   %eax,%eax
801018bc:	74 15                	je     801018d3 <iunlock+0x33>
801018be:	8b 5b 08             	mov    0x8(%ebx),%ebx
801018c1:	85 db                	test   %ebx,%ebx
801018c3:	7e 0e                	jle    801018d3 <iunlock+0x33>
801018c5:	89 75 08             	mov    %esi,0x8(%ebp)
801018c8:	83 c4 10             	add    $0x10,%esp
801018cb:	5b                   	pop    %ebx
801018cc:	5e                   	pop    %esi
801018cd:	5d                   	pop    %ebp
801018ce:	e9 9d 28 00 00       	jmp    80104170 <releasesleep>
801018d3:	c7 04 24 ff 70 10 80 	movl   $0x801070ff,(%esp)
801018da:	e8 81 ea ff ff       	call   80100360 <panic>
801018df:	90                   	nop

801018e0 <iput>:
801018e0:	55                   	push   %ebp
801018e1:	89 e5                	mov    %esp,%ebp
801018e3:	57                   	push   %edi
801018e4:	56                   	push   %esi
801018e5:	53                   	push   %ebx
801018e6:	83 ec 1c             	sub    $0x1c,%esp
801018e9:	8b 75 08             	mov    0x8(%ebp),%esi
801018ec:	8d 7e 0c             	lea    0xc(%esi),%edi
801018ef:	89 3c 24             	mov    %edi,(%esp)
801018f2:	e8 19 28 00 00       	call   80104110 <acquiresleep>
801018f7:	8b 46 4c             	mov    0x4c(%esi),%eax
801018fa:	85 c0                	test   %eax,%eax
801018fc:	74 07                	je     80101905 <iput+0x25>
801018fe:	66 83 7e 56 00       	cmpw   $0x0,0x56(%esi)
80101903:	74 2b                	je     80101930 <iput+0x50>
80101905:	89 3c 24             	mov    %edi,(%esp)
80101908:	e8 63 28 00 00       	call   80104170 <releasesleep>
8010190d:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101914:	e8 b7 29 00 00       	call   801042d0 <acquire>
80101919:	83 6e 08 01          	subl   $0x1,0x8(%esi)
8010191d:	c7 45 08 e0 09 11 80 	movl   $0x801109e0,0x8(%ebp)
80101924:	83 c4 1c             	add    $0x1c,%esp
80101927:	5b                   	pop    %ebx
80101928:	5e                   	pop    %esi
80101929:	5f                   	pop    %edi
8010192a:	5d                   	pop    %ebp
8010192b:	e9 90 2a 00 00       	jmp    801043c0 <release>
80101930:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101937:	e8 94 29 00 00       	call   801042d0 <acquire>
8010193c:	8b 5e 08             	mov    0x8(%esi),%ebx
8010193f:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101946:	e8 75 2a 00 00       	call   801043c0 <release>
8010194b:	83 fb 01             	cmp    $0x1,%ebx
8010194e:	75 b5                	jne    80101905 <iput+0x25>
80101950:	8d 4e 2c             	lea    0x2c(%esi),%ecx
80101953:	89 f3                	mov    %esi,%ebx
80101955:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101958:	89 cf                	mov    %ecx,%edi
8010195a:	eb 0b                	jmp    80101967 <iput+0x87>
8010195c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101960:	83 c3 04             	add    $0x4,%ebx
80101963:	39 fb                	cmp    %edi,%ebx
80101965:	74 19                	je     80101980 <iput+0xa0>
80101967:	8b 53 5c             	mov    0x5c(%ebx),%edx
8010196a:	85 d2                	test   %edx,%edx
8010196c:	74 f2                	je     80101960 <iput+0x80>
8010196e:	8b 06                	mov    (%esi),%eax
80101970:	e8 7b fb ff ff       	call   801014f0 <bfree>
80101975:	c7 43 5c 00 00 00 00 	movl   $0x0,0x5c(%ebx)
8010197c:	eb e2                	jmp    80101960 <iput+0x80>
8010197e:	66 90                	xchg   %ax,%ax
80101980:	8b 86 88 00 00 00    	mov    0x88(%esi),%eax
80101986:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101989:	85 c0                	test   %eax,%eax
8010198b:	75 2b                	jne    801019b8 <iput+0xd8>
8010198d:	c7 46 58 00 00 00 00 	movl   $0x0,0x58(%esi)
80101994:	89 34 24             	mov    %esi,(%esp)
80101997:	e8 64 fd ff ff       	call   80101700 <iupdate>
8010199c:	31 c0                	xor    %eax,%eax
8010199e:	66 89 46 50          	mov    %ax,0x50(%esi)
801019a2:	89 34 24             	mov    %esi,(%esp)
801019a5:	e8 56 fd ff ff       	call   80101700 <iupdate>
801019aa:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
801019b1:	e9 4f ff ff ff       	jmp    80101905 <iput+0x25>
801019b6:	66 90                	xchg   %ax,%ax
801019b8:	89 44 24 04          	mov    %eax,0x4(%esp)
801019bc:	8b 06                	mov    (%esi),%eax
801019be:	31 db                	xor    %ebx,%ebx
801019c0:	89 04 24             	mov    %eax,(%esp)
801019c3:	e8 08 e7 ff ff       	call   801000d0 <bread>
801019c8:	89 7d e0             	mov    %edi,-0x20(%ebp)
801019cb:	8d 48 5c             	lea    0x5c(%eax),%ecx
801019ce:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801019d1:	89 cf                	mov    %ecx,%edi
801019d3:	31 c0                	xor    %eax,%eax
801019d5:	eb 0e                	jmp    801019e5 <iput+0x105>
801019d7:	90                   	nop
801019d8:	83 c3 01             	add    $0x1,%ebx
801019db:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
801019e1:	89 d8                	mov    %ebx,%eax
801019e3:	74 10                	je     801019f5 <iput+0x115>
801019e5:	8b 14 87             	mov    (%edi,%eax,4),%edx
801019e8:	85 d2                	test   %edx,%edx
801019ea:	74 ec                	je     801019d8 <iput+0xf8>
801019ec:	8b 06                	mov    (%esi),%eax
801019ee:	e8 fd fa ff ff       	call   801014f0 <bfree>
801019f3:	eb e3                	jmp    801019d8 <iput+0xf8>
801019f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801019f8:	8b 7d e0             	mov    -0x20(%ebp),%edi
801019fb:	89 04 24             	mov    %eax,(%esp)
801019fe:	e8 dd e7 ff ff       	call   801001e0 <brelse>
80101a03:	8b 96 88 00 00 00    	mov    0x88(%esi),%edx
80101a09:	8b 06                	mov    (%esi),%eax
80101a0b:	e8 e0 fa ff ff       	call   801014f0 <bfree>
80101a10:	c7 86 88 00 00 00 00 	movl   $0x0,0x88(%esi)
80101a17:	00 00 00 
80101a1a:	e9 6e ff ff ff       	jmp    8010198d <iput+0xad>
80101a1f:	90                   	nop

80101a20 <iunlockput>:
80101a20:	55                   	push   %ebp
80101a21:	89 e5                	mov    %esp,%ebp
80101a23:	53                   	push   %ebx
80101a24:	83 ec 14             	sub    $0x14,%esp
80101a27:	8b 5d 08             	mov    0x8(%ebp),%ebx
80101a2a:	89 1c 24             	mov    %ebx,(%esp)
80101a2d:	e8 6e fe ff ff       	call   801018a0 <iunlock>
80101a32:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101a35:	83 c4 14             	add    $0x14,%esp
80101a38:	5b                   	pop    %ebx
80101a39:	5d                   	pop    %ebp
80101a3a:	e9 a1 fe ff ff       	jmp    801018e0 <iput>
80101a3f:	90                   	nop

80101a40 <stati>:
80101a40:	55                   	push   %ebp
80101a41:	89 e5                	mov    %esp,%ebp
80101a43:	8b 55 08             	mov    0x8(%ebp),%edx
80101a46:	8b 45 0c             	mov    0xc(%ebp),%eax
80101a49:	8b 0a                	mov    (%edx),%ecx
80101a4b:	89 48 04             	mov    %ecx,0x4(%eax)
80101a4e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101a51:	89 48 08             	mov    %ecx,0x8(%eax)
80101a54:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101a58:	66 89 08             	mov    %cx,(%eax)
80101a5b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101a5f:	66 89 48 0c          	mov    %cx,0xc(%eax)
80101a63:	8b 52 58             	mov    0x58(%edx),%edx
80101a66:	89 50 10             	mov    %edx,0x10(%eax)
80101a69:	5d                   	pop    %ebp
80101a6a:	c3                   	ret    
80101a6b:	90                   	nop
80101a6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101a70 <readi>:
80101a70:	55                   	push   %ebp
80101a71:	89 e5                	mov    %esp,%ebp
80101a73:	57                   	push   %edi
80101a74:	56                   	push   %esi
80101a75:	53                   	push   %ebx
80101a76:	83 ec 2c             	sub    $0x2c,%esp
80101a79:	8b 45 0c             	mov    0xc(%ebp),%eax
80101a7c:	8b 7d 08             	mov    0x8(%ebp),%edi
80101a7f:	8b 75 10             	mov    0x10(%ebp),%esi
80101a82:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101a85:	8b 45 14             	mov    0x14(%ebp),%eax
80101a88:	66 83 7f 50 03       	cmpw   $0x3,0x50(%edi)
80101a8d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101a90:	0f 84 aa 00 00 00    	je     80101b40 <readi+0xd0>
80101a96:	8b 47 58             	mov    0x58(%edi),%eax
80101a99:	39 f0                	cmp    %esi,%eax
80101a9b:	0f 82 c7 00 00 00    	jb     80101b68 <readi+0xf8>
80101aa1:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101aa4:	89 da                	mov    %ebx,%edx
80101aa6:	01 f2                	add    %esi,%edx
80101aa8:	0f 82 ba 00 00 00    	jb     80101b68 <readi+0xf8>
80101aae:	89 c1                	mov    %eax,%ecx
80101ab0:	29 f1                	sub    %esi,%ecx
80101ab2:	39 d0                	cmp    %edx,%eax
80101ab4:	0f 43 cb             	cmovae %ebx,%ecx
80101ab7:	31 c0                	xor    %eax,%eax
80101ab9:	85 c9                	test   %ecx,%ecx
80101abb:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101abe:	74 70                	je     80101b30 <readi+0xc0>
80101ac0:	89 7d d8             	mov    %edi,-0x28(%ebp)
80101ac3:	89 c7                	mov    %eax,%edi
80101ac5:	8d 76 00             	lea    0x0(%esi),%esi
80101ac8:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101acb:	89 f2                	mov    %esi,%edx
80101acd:	c1 ea 09             	shr    $0x9,%edx
80101ad0:	89 d8                	mov    %ebx,%eax
80101ad2:	e8 09 f8 ff ff       	call   801012e0 <bmap>
80101ad7:	89 44 24 04          	mov    %eax,0x4(%esp)
80101adb:	8b 03                	mov    (%ebx),%eax
80101add:	bb 00 02 00 00       	mov    $0x200,%ebx
80101ae2:	89 04 24             	mov    %eax,(%esp)
80101ae5:	e8 e6 e5 ff ff       	call   801000d0 <bread>
80101aea:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101aed:	29 f9                	sub    %edi,%ecx
80101aef:	89 c2                	mov    %eax,%edx
80101af1:	89 f0                	mov    %esi,%eax
80101af3:	25 ff 01 00 00       	and    $0x1ff,%eax
80101af8:	29 c3                	sub    %eax,%ebx
80101afa:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
80101afe:	39 cb                	cmp    %ecx,%ebx
80101b00:	89 44 24 04          	mov    %eax,0x4(%esp)
80101b04:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101b07:	0f 47 d9             	cmova  %ecx,%ebx
80101b0a:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80101b0e:	01 df                	add    %ebx,%edi
80101b10:	01 de                	add    %ebx,%esi
80101b12:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101b15:	89 04 24             	mov    %eax,(%esp)
80101b18:	e8 93 29 00 00       	call   801044b0 <memmove>
80101b1d:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101b20:	89 14 24             	mov    %edx,(%esp)
80101b23:	e8 b8 e6 ff ff       	call   801001e0 <brelse>
80101b28:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101b2b:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101b2e:	77 98                	ja     80101ac8 <readi+0x58>
80101b30:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101b33:	83 c4 2c             	add    $0x2c,%esp
80101b36:	5b                   	pop    %ebx
80101b37:	5e                   	pop    %esi
80101b38:	5f                   	pop    %edi
80101b39:	5d                   	pop    %ebp
80101b3a:	c3                   	ret    
80101b3b:	90                   	nop
80101b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101b40:	0f bf 47 52          	movswl 0x52(%edi),%eax
80101b44:	66 83 f8 09          	cmp    $0x9,%ax
80101b48:	77 1e                	ja     80101b68 <readi+0xf8>
80101b4a:	8b 04 c5 60 09 11 80 	mov    -0x7feef6a0(,%eax,8),%eax
80101b51:	85 c0                	test   %eax,%eax
80101b53:	74 13                	je     80101b68 <readi+0xf8>
80101b55:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101b58:	89 75 10             	mov    %esi,0x10(%ebp)
80101b5b:	83 c4 2c             	add    $0x2c,%esp
80101b5e:	5b                   	pop    %ebx
80101b5f:	5e                   	pop    %esi
80101b60:	5f                   	pop    %edi
80101b61:	5d                   	pop    %ebp
80101b62:	ff e0                	jmp    *%eax
80101b64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101b68:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b6d:	eb c4                	jmp    80101b33 <readi+0xc3>
80101b6f:	90                   	nop

80101b70 <writei>:
80101b70:	55                   	push   %ebp
80101b71:	89 e5                	mov    %esp,%ebp
80101b73:	57                   	push   %edi
80101b74:	56                   	push   %esi
80101b75:	53                   	push   %ebx
80101b76:	83 ec 2c             	sub    $0x2c,%esp
80101b79:	8b 45 08             	mov    0x8(%ebp),%eax
80101b7c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101b7f:	8b 4d 14             	mov    0x14(%ebp),%ecx
80101b82:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
80101b87:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101b8a:	8b 75 10             	mov    0x10(%ebp),%esi
80101b8d:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101b90:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101b93:	0f 84 b7 00 00 00    	je     80101c50 <writei+0xe0>
80101b99:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b9c:	39 70 58             	cmp    %esi,0x58(%eax)
80101b9f:	0f 82 e3 00 00 00    	jb     80101c88 <writei+0x118>
80101ba5:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101ba8:	89 c8                	mov    %ecx,%eax
80101baa:	01 f0                	add    %esi,%eax
80101bac:	0f 82 d6 00 00 00    	jb     80101c88 <writei+0x118>
80101bb2:	3d 00 16 81 00       	cmp    $0x811600,%eax
80101bb7:	0f 87 cb 00 00 00    	ja     80101c88 <writei+0x118>
80101bbd:	85 c9                	test   %ecx,%ecx
80101bbf:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101bc6:	74 77                	je     80101c3f <writei+0xcf>
80101bc8:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101bcb:	89 f2                	mov    %esi,%edx
80101bcd:	bb 00 02 00 00       	mov    $0x200,%ebx
80101bd2:	c1 ea 09             	shr    $0x9,%edx
80101bd5:	89 f8                	mov    %edi,%eax
80101bd7:	e8 04 f7 ff ff       	call   801012e0 <bmap>
80101bdc:	89 44 24 04          	mov    %eax,0x4(%esp)
80101be0:	8b 07                	mov    (%edi),%eax
80101be2:	89 04 24             	mov    %eax,(%esp)
80101be5:	e8 e6 e4 ff ff       	call   801000d0 <bread>
80101bea:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101bed:	2b 4d e4             	sub    -0x1c(%ebp),%ecx
80101bf0:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101bf3:	89 c7                	mov    %eax,%edi
80101bf5:	89 f0                	mov    %esi,%eax
80101bf7:	25 ff 01 00 00       	and    $0x1ff,%eax
80101bfc:	29 c3                	sub    %eax,%ebx
80101bfe:	39 cb                	cmp    %ecx,%ebx
80101c00:	0f 47 d9             	cmova  %ecx,%ebx
80101c03:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
80101c07:	01 de                	add    %ebx,%esi
80101c09:	89 54 24 04          	mov    %edx,0x4(%esp)
80101c0d:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80101c11:	89 04 24             	mov    %eax,(%esp)
80101c14:	e8 97 28 00 00       	call   801044b0 <memmove>
80101c19:	89 3c 24             	mov    %edi,(%esp)
80101c1c:	e8 df 11 00 00       	call   80102e00 <log_write>
80101c21:	89 3c 24             	mov    %edi,(%esp)
80101c24:	e8 b7 e5 ff ff       	call   801001e0 <brelse>
80101c29:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101c2c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101c2f:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101c32:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101c35:	77 91                	ja     80101bc8 <writei+0x58>
80101c37:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c3a:	39 70 58             	cmp    %esi,0x58(%eax)
80101c3d:	72 39                	jb     80101c78 <writei+0x108>
80101c3f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101c42:	83 c4 2c             	add    $0x2c,%esp
80101c45:	5b                   	pop    %ebx
80101c46:	5e                   	pop    %esi
80101c47:	5f                   	pop    %edi
80101c48:	5d                   	pop    %ebp
80101c49:	c3                   	ret    
80101c4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101c50:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101c54:	66 83 f8 09          	cmp    $0x9,%ax
80101c58:	77 2e                	ja     80101c88 <writei+0x118>
80101c5a:	8b 04 c5 64 09 11 80 	mov    -0x7feef69c(,%eax,8),%eax
80101c61:	85 c0                	test   %eax,%eax
80101c63:	74 23                	je     80101c88 <writei+0x118>
80101c65:	89 4d 10             	mov    %ecx,0x10(%ebp)
80101c68:	83 c4 2c             	add    $0x2c,%esp
80101c6b:	5b                   	pop    %ebx
80101c6c:	5e                   	pop    %esi
80101c6d:	5f                   	pop    %edi
80101c6e:	5d                   	pop    %ebp
80101c6f:	ff e0                	jmp    *%eax
80101c71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c78:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c7b:	89 70 58             	mov    %esi,0x58(%eax)
80101c7e:	89 04 24             	mov    %eax,(%esp)
80101c81:	e8 7a fa ff ff       	call   80101700 <iupdate>
80101c86:	eb b7                	jmp    80101c3f <writei+0xcf>
80101c88:	83 c4 2c             	add    $0x2c,%esp
80101c8b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101c90:	5b                   	pop    %ebx
80101c91:	5e                   	pop    %esi
80101c92:	5f                   	pop    %edi
80101c93:	5d                   	pop    %ebp
80101c94:	c3                   	ret    
80101c95:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101c99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ca0 <namecmp>:
80101ca0:	55                   	push   %ebp
80101ca1:	89 e5                	mov    %esp,%ebp
80101ca3:	83 ec 18             	sub    $0x18,%esp
80101ca6:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ca9:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101cb0:	00 
80101cb1:	89 44 24 04          	mov    %eax,0x4(%esp)
80101cb5:	8b 45 08             	mov    0x8(%ebp),%eax
80101cb8:	89 04 24             	mov    %eax,(%esp)
80101cbb:	e8 70 28 00 00       	call   80104530 <strncmp>
80101cc0:	c9                   	leave  
80101cc1:	c3                   	ret    
80101cc2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101cd0 <dirlookup>:
80101cd0:	55                   	push   %ebp
80101cd1:	89 e5                	mov    %esp,%ebp
80101cd3:	57                   	push   %edi
80101cd4:	56                   	push   %esi
80101cd5:	53                   	push   %ebx
80101cd6:	83 ec 2c             	sub    $0x2c,%esp
80101cd9:	8b 5d 08             	mov    0x8(%ebp),%ebx
80101cdc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101ce1:	0f 85 97 00 00 00    	jne    80101d7e <dirlookup+0xae>
80101ce7:	8b 43 58             	mov    0x58(%ebx),%eax
80101cea:	31 ff                	xor    %edi,%edi
80101cec:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101cef:	85 c0                	test   %eax,%eax
80101cf1:	75 0d                	jne    80101d00 <dirlookup+0x30>
80101cf3:	eb 73                	jmp    80101d68 <dirlookup+0x98>
80101cf5:	8d 76 00             	lea    0x0(%esi),%esi
80101cf8:	83 c7 10             	add    $0x10,%edi
80101cfb:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101cfe:	76 68                	jbe    80101d68 <dirlookup+0x98>
80101d00:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101d07:	00 
80101d08:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101d0c:	89 74 24 04          	mov    %esi,0x4(%esp)
80101d10:	89 1c 24             	mov    %ebx,(%esp)
80101d13:	e8 58 fd ff ff       	call   80101a70 <readi>
80101d18:	83 f8 10             	cmp    $0x10,%eax
80101d1b:	75 55                	jne    80101d72 <dirlookup+0xa2>
80101d1d:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101d22:	74 d4                	je     80101cf8 <dirlookup+0x28>
80101d24:	8d 45 da             	lea    -0x26(%ebp),%eax
80101d27:	89 44 24 04          	mov    %eax,0x4(%esp)
80101d2b:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d2e:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101d35:	00 
80101d36:	89 04 24             	mov    %eax,(%esp)
80101d39:	e8 f2 27 00 00       	call   80104530 <strncmp>
80101d3e:	85 c0                	test   %eax,%eax
80101d40:	75 b6                	jne    80101cf8 <dirlookup+0x28>
80101d42:	8b 45 10             	mov    0x10(%ebp),%eax
80101d45:	85 c0                	test   %eax,%eax
80101d47:	74 05                	je     80101d4e <dirlookup+0x7e>
80101d49:	8b 45 10             	mov    0x10(%ebp),%eax
80101d4c:	89 38                	mov    %edi,(%eax)
80101d4e:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
80101d52:	8b 03                	mov    (%ebx),%eax
80101d54:	e8 c7 f4 ff ff       	call   80101220 <iget>
80101d59:	83 c4 2c             	add    $0x2c,%esp
80101d5c:	5b                   	pop    %ebx
80101d5d:	5e                   	pop    %esi
80101d5e:	5f                   	pop    %edi
80101d5f:	5d                   	pop    %ebp
80101d60:	c3                   	ret    
80101d61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d68:	83 c4 2c             	add    $0x2c,%esp
80101d6b:	31 c0                	xor    %eax,%eax
80101d6d:	5b                   	pop    %ebx
80101d6e:	5e                   	pop    %esi
80101d6f:	5f                   	pop    %edi
80101d70:	5d                   	pop    %ebp
80101d71:	c3                   	ret    
80101d72:	c7 04 24 19 71 10 80 	movl   $0x80107119,(%esp)
80101d79:	e8 e2 e5 ff ff       	call   80100360 <panic>
80101d7e:	c7 04 24 07 71 10 80 	movl   $0x80107107,(%esp)
80101d85:	e8 d6 e5 ff ff       	call   80100360 <panic>
80101d8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101d90 <namex>:
80101d90:	55                   	push   %ebp
80101d91:	89 e5                	mov    %esp,%ebp
80101d93:	57                   	push   %edi
80101d94:	89 cf                	mov    %ecx,%edi
80101d96:	56                   	push   %esi
80101d97:	53                   	push   %ebx
80101d98:	89 c3                	mov    %eax,%ebx
80101d9a:	83 ec 2c             	sub    $0x2c,%esp
80101d9d:	80 38 2f             	cmpb   $0x2f,(%eax)
80101da0:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101da3:	0f 84 51 01 00 00    	je     80101efa <namex+0x16a>
80101da9:	e8 52 1a 00 00       	call   80103800 <myproc>
80101dae:	8b 70 68             	mov    0x68(%eax),%esi
80101db1:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101db8:	e8 13 25 00 00       	call   801042d0 <acquire>
80101dbd:	83 46 08 01          	addl   $0x1,0x8(%esi)
80101dc1:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101dc8:	e8 f3 25 00 00       	call   801043c0 <release>
80101dcd:	eb 04                	jmp    80101dd3 <namex+0x43>
80101dcf:	90                   	nop
80101dd0:	83 c3 01             	add    $0x1,%ebx
80101dd3:	0f b6 03             	movzbl (%ebx),%eax
80101dd6:	3c 2f                	cmp    $0x2f,%al
80101dd8:	74 f6                	je     80101dd0 <namex+0x40>
80101dda:	84 c0                	test   %al,%al
80101ddc:	0f 84 ed 00 00 00    	je     80101ecf <namex+0x13f>
80101de2:	0f b6 03             	movzbl (%ebx),%eax
80101de5:	89 da                	mov    %ebx,%edx
80101de7:	84 c0                	test   %al,%al
80101de9:	0f 84 b1 00 00 00    	je     80101ea0 <namex+0x110>
80101def:	3c 2f                	cmp    $0x2f,%al
80101df1:	75 0f                	jne    80101e02 <namex+0x72>
80101df3:	e9 a8 00 00 00       	jmp    80101ea0 <namex+0x110>
80101df8:	3c 2f                	cmp    $0x2f,%al
80101dfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101e00:	74 0a                	je     80101e0c <namex+0x7c>
80101e02:	83 c2 01             	add    $0x1,%edx
80101e05:	0f b6 02             	movzbl (%edx),%eax
80101e08:	84 c0                	test   %al,%al
80101e0a:	75 ec                	jne    80101df8 <namex+0x68>
80101e0c:	89 d1                	mov    %edx,%ecx
80101e0e:	29 d9                	sub    %ebx,%ecx
80101e10:	83 f9 0d             	cmp    $0xd,%ecx
80101e13:	0f 8e 8f 00 00 00    	jle    80101ea8 <namex+0x118>
80101e19:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101e1d:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101e24:	00 
80101e25:	89 3c 24             	mov    %edi,(%esp)
80101e28:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101e2b:	e8 80 26 00 00       	call   801044b0 <memmove>
80101e30:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101e33:	89 d3                	mov    %edx,%ebx
80101e35:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101e38:	75 0e                	jne    80101e48 <namex+0xb8>
80101e3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101e40:	83 c3 01             	add    $0x1,%ebx
80101e43:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101e46:	74 f8                	je     80101e40 <namex+0xb0>
80101e48:	89 34 24             	mov    %esi,(%esp)
80101e4b:	e8 70 f9 ff ff       	call   801017c0 <ilock>
80101e50:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101e55:	0f 85 85 00 00 00    	jne    80101ee0 <namex+0x150>
80101e5b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101e5e:	85 c0                	test   %eax,%eax
80101e60:	74 09                	je     80101e6b <namex+0xdb>
80101e62:	80 3b 00             	cmpb   $0x0,(%ebx)
80101e65:	0f 84 a5 00 00 00    	je     80101f10 <namex+0x180>
80101e6b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80101e72:	00 
80101e73:	89 7c 24 04          	mov    %edi,0x4(%esp)
80101e77:	89 34 24             	mov    %esi,(%esp)
80101e7a:	e8 51 fe ff ff       	call   80101cd0 <dirlookup>
80101e7f:	85 c0                	test   %eax,%eax
80101e81:	74 5d                	je     80101ee0 <namex+0x150>
80101e83:	89 34 24             	mov    %esi,(%esp)
80101e86:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101e89:	e8 12 fa ff ff       	call   801018a0 <iunlock>
80101e8e:	89 34 24             	mov    %esi,(%esp)
80101e91:	e8 4a fa ff ff       	call   801018e0 <iput>
80101e96:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101e99:	89 c6                	mov    %eax,%esi
80101e9b:	e9 33 ff ff ff       	jmp    80101dd3 <namex+0x43>
80101ea0:	31 c9                	xor    %ecx,%ecx
80101ea2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101ea8:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80101eac:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101eb0:	89 3c 24             	mov    %edi,(%esp)
80101eb3:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101eb6:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101eb9:	e8 f2 25 00 00       	call   801044b0 <memmove>
80101ebe:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101ec1:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101ec4:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101ec8:	89 d3                	mov    %edx,%ebx
80101eca:	e9 66 ff ff ff       	jmp    80101e35 <namex+0xa5>
80101ecf:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101ed2:	85 c0                	test   %eax,%eax
80101ed4:	75 4c                	jne    80101f22 <namex+0x192>
80101ed6:	89 f0                	mov    %esi,%eax
80101ed8:	83 c4 2c             	add    $0x2c,%esp
80101edb:	5b                   	pop    %ebx
80101edc:	5e                   	pop    %esi
80101edd:	5f                   	pop    %edi
80101ede:	5d                   	pop    %ebp
80101edf:	c3                   	ret    
80101ee0:	89 34 24             	mov    %esi,(%esp)
80101ee3:	e8 b8 f9 ff ff       	call   801018a0 <iunlock>
80101ee8:	89 34 24             	mov    %esi,(%esp)
80101eeb:	e8 f0 f9 ff ff       	call   801018e0 <iput>
80101ef0:	83 c4 2c             	add    $0x2c,%esp
80101ef3:	31 c0                	xor    %eax,%eax
80101ef5:	5b                   	pop    %ebx
80101ef6:	5e                   	pop    %esi
80101ef7:	5f                   	pop    %edi
80101ef8:	5d                   	pop    %ebp
80101ef9:	c3                   	ret    
80101efa:	ba 01 00 00 00       	mov    $0x1,%edx
80101eff:	b8 01 00 00 00       	mov    $0x1,%eax
80101f04:	e8 17 f3 ff ff       	call   80101220 <iget>
80101f09:	89 c6                	mov    %eax,%esi
80101f0b:	e9 c3 fe ff ff       	jmp    80101dd3 <namex+0x43>
80101f10:	89 34 24             	mov    %esi,(%esp)
80101f13:	e8 88 f9 ff ff       	call   801018a0 <iunlock>
80101f18:	83 c4 2c             	add    $0x2c,%esp
80101f1b:	89 f0                	mov    %esi,%eax
80101f1d:	5b                   	pop    %ebx
80101f1e:	5e                   	pop    %esi
80101f1f:	5f                   	pop    %edi
80101f20:	5d                   	pop    %ebp
80101f21:	c3                   	ret    
80101f22:	89 34 24             	mov    %esi,(%esp)
80101f25:	e8 b6 f9 ff ff       	call   801018e0 <iput>
80101f2a:	31 c0                	xor    %eax,%eax
80101f2c:	eb aa                	jmp    80101ed8 <namex+0x148>
80101f2e:	66 90                	xchg   %ax,%ax

80101f30 <dirlink>:
80101f30:	55                   	push   %ebp
80101f31:	89 e5                	mov    %esp,%ebp
80101f33:	57                   	push   %edi
80101f34:	56                   	push   %esi
80101f35:	53                   	push   %ebx
80101f36:	83 ec 2c             	sub    $0x2c,%esp
80101f39:	8b 5d 08             	mov    0x8(%ebp),%ebx
80101f3c:	8b 45 0c             	mov    0xc(%ebp),%eax
80101f3f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80101f46:	00 
80101f47:	89 1c 24             	mov    %ebx,(%esp)
80101f4a:	89 44 24 04          	mov    %eax,0x4(%esp)
80101f4e:	e8 7d fd ff ff       	call   80101cd0 <dirlookup>
80101f53:	85 c0                	test   %eax,%eax
80101f55:	0f 85 8b 00 00 00    	jne    80101fe6 <dirlink+0xb6>
80101f5b:	8b 53 58             	mov    0x58(%ebx),%edx
80101f5e:	31 ff                	xor    %edi,%edi
80101f60:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101f63:	85 d2                	test   %edx,%edx
80101f65:	75 13                	jne    80101f7a <dirlink+0x4a>
80101f67:	eb 35                	jmp    80101f9e <dirlink+0x6e>
80101f69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f70:	8d 57 10             	lea    0x10(%edi),%edx
80101f73:	39 53 58             	cmp    %edx,0x58(%ebx)
80101f76:	89 d7                	mov    %edx,%edi
80101f78:	76 24                	jbe    80101f9e <dirlink+0x6e>
80101f7a:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101f81:	00 
80101f82:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101f86:	89 74 24 04          	mov    %esi,0x4(%esp)
80101f8a:	89 1c 24             	mov    %ebx,(%esp)
80101f8d:	e8 de fa ff ff       	call   80101a70 <readi>
80101f92:	83 f8 10             	cmp    $0x10,%eax
80101f95:	75 5e                	jne    80101ff5 <dirlink+0xc5>
80101f97:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101f9c:	75 d2                	jne    80101f70 <dirlink+0x40>
80101f9e:	8b 45 0c             	mov    0xc(%ebp),%eax
80101fa1:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101fa8:	00 
80101fa9:	89 44 24 04          	mov    %eax,0x4(%esp)
80101fad:	8d 45 da             	lea    -0x26(%ebp),%eax
80101fb0:	89 04 24             	mov    %eax,(%esp)
80101fb3:	e8 e8 25 00 00       	call   801045a0 <strncpy>
80101fb8:	8b 45 10             	mov    0x10(%ebp),%eax
80101fbb:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101fc2:	00 
80101fc3:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101fc7:	89 74 24 04          	mov    %esi,0x4(%esp)
80101fcb:	89 1c 24             	mov    %ebx,(%esp)
80101fce:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
80101fd2:	e8 99 fb ff ff       	call   80101b70 <writei>
80101fd7:	83 f8 10             	cmp    $0x10,%eax
80101fda:	75 25                	jne    80102001 <dirlink+0xd1>
80101fdc:	31 c0                	xor    %eax,%eax
80101fde:	83 c4 2c             	add    $0x2c,%esp
80101fe1:	5b                   	pop    %ebx
80101fe2:	5e                   	pop    %esi
80101fe3:	5f                   	pop    %edi
80101fe4:	5d                   	pop    %ebp
80101fe5:	c3                   	ret    
80101fe6:	89 04 24             	mov    %eax,(%esp)
80101fe9:	e8 f2 f8 ff ff       	call   801018e0 <iput>
80101fee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ff3:	eb e9                	jmp    80101fde <dirlink+0xae>
80101ff5:	c7 04 24 28 71 10 80 	movl   $0x80107128,(%esp)
80101ffc:	e8 5f e3 ff ff       	call   80100360 <panic>
80102001:	c7 04 24 6a 77 10 80 	movl   $0x8010776a,(%esp)
80102008:	e8 53 e3 ff ff       	call   80100360 <panic>
8010200d:	8d 76 00             	lea    0x0(%esi),%esi

80102010 <namei>:
80102010:	55                   	push   %ebp
80102011:	31 d2                	xor    %edx,%edx
80102013:	89 e5                	mov    %esp,%ebp
80102015:	83 ec 18             	sub    $0x18,%esp
80102018:	8b 45 08             	mov    0x8(%ebp),%eax
8010201b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
8010201e:	e8 6d fd ff ff       	call   80101d90 <namex>
80102023:	c9                   	leave  
80102024:	c3                   	ret    
80102025:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102029:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102030 <nameiparent>:
80102030:	55                   	push   %ebp
80102031:	ba 01 00 00 00       	mov    $0x1,%edx
80102036:	89 e5                	mov    %esp,%ebp
80102038:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010203b:	8b 45 08             	mov    0x8(%ebp),%eax
8010203e:	5d                   	pop    %ebp
8010203f:	e9 4c fd ff ff       	jmp    80101d90 <namex>
	...

80102050 <idestart>:
80102050:	55                   	push   %ebp
80102051:	89 e5                	mov    %esp,%ebp
80102053:	56                   	push   %esi
80102054:	89 c6                	mov    %eax,%esi
80102056:	83 ec 14             	sub    $0x14,%esp
80102059:	85 c0                	test   %eax,%eax
8010205b:	0f 84 99 00 00 00    	je     801020fa <idestart+0xaa>
80102061:	8b 48 08             	mov    0x8(%eax),%ecx
80102064:	81 f9 1f 4e 00 00    	cmp    $0x4e1f,%ecx
8010206a:	0f 87 7e 00 00 00    	ja     801020ee <idestart+0x9e>
80102070:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102075:	8d 76 00             	lea    0x0(%esi),%esi
80102078:	ec                   	in     (%dx),%al
80102079:	83 e0 c0             	and    $0xffffffc0,%eax
8010207c:	3c 40                	cmp    $0x40,%al
8010207e:	75 f8                	jne    80102078 <idestart+0x28>
80102080:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102085:	31 c0                	xor    %eax,%eax
80102087:	ee                   	out    %al,(%dx)
80102088:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010208d:	b8 01 00 00 00       	mov    $0x1,%eax
80102092:	ee                   	out    %al,(%dx)
80102093:	0f b6 c1             	movzbl %cl,%eax
80102096:	b2 f3                	mov    $0xf3,%dl
80102098:	ee                   	out    %al,(%dx)
80102099:	89 c8                	mov    %ecx,%eax
8010209b:	b2 f4                	mov    $0xf4,%dl
8010209d:	c1 f8 08             	sar    $0x8,%eax
801020a0:	ee                   	out    %al,(%dx)
801020a1:	31 c0                	xor    %eax,%eax
801020a3:	b2 f5                	mov    $0xf5,%dl
801020a5:	ee                   	out    %al,(%dx)
801020a6:	0f b6 46 04          	movzbl 0x4(%esi),%eax
801020aa:	b2 f6                	mov    $0xf6,%dl
801020ac:	83 e0 01             	and    $0x1,%eax
801020af:	c1 e0 04             	shl    $0x4,%eax
801020b2:	83 c8 e0             	or     $0xffffffe0,%eax
801020b5:	ee                   	out    %al,(%dx)
801020b6:	f6 06 04             	testb  $0x4,(%esi)
801020b9:	75 15                	jne    801020d0 <idestart+0x80>
801020bb:	ba f7 01 00 00       	mov    $0x1f7,%edx
801020c0:	b8 20 00 00 00       	mov    $0x20,%eax
801020c5:	ee                   	out    %al,(%dx)
801020c6:	83 c4 14             	add    $0x14,%esp
801020c9:	5e                   	pop    %esi
801020ca:	5d                   	pop    %ebp
801020cb:	c3                   	ret    
801020cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801020d0:	b2 f7                	mov    $0xf7,%dl
801020d2:	b8 30 00 00 00       	mov    $0x30,%eax
801020d7:	ee                   	out    %al,(%dx)
801020d8:	b9 80 00 00 00       	mov    $0x80,%ecx
801020dd:	83 c6 5c             	add    $0x5c,%esi
801020e0:	ba f0 01 00 00       	mov    $0x1f0,%edx
801020e5:	fc                   	cld    
801020e6:	f3 6f                	rep outsl %ds:(%esi),(%dx)
801020e8:	83 c4 14             	add    $0x14,%esp
801020eb:	5e                   	pop    %esi
801020ec:	5d                   	pop    %ebp
801020ed:	c3                   	ret    
801020ee:	c7 04 24 94 71 10 80 	movl   $0x80107194,(%esp)
801020f5:	e8 66 e2 ff ff       	call   80100360 <panic>
801020fa:	c7 04 24 8b 71 10 80 	movl   $0x8010718b,(%esp)
80102101:	e8 5a e2 ff ff       	call   80100360 <panic>
80102106:	8d 76 00             	lea    0x0(%esi),%esi
80102109:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102110 <ideinit>:
80102110:	55                   	push   %ebp
80102111:	89 e5                	mov    %esp,%ebp
80102113:	83 ec 18             	sub    $0x18,%esp
80102116:	c7 44 24 04 a6 71 10 	movl   $0x801071a6,0x4(%esp)
8010211d:	80 
8010211e:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
80102125:	e8 b6 20 00 00       	call   801041e0 <initlock>
8010212a:	a1 40 2c 11 80       	mov    0x80112c40,%eax
8010212f:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
80102136:	83 e8 01             	sub    $0x1,%eax
80102139:	89 44 24 04          	mov    %eax,0x4(%esp)
8010213d:	e8 7e 02 00 00       	call   801023c0 <ioapicenable>
80102142:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102147:	90                   	nop
80102148:	ec                   	in     (%dx),%al
80102149:	83 e0 c0             	and    $0xffffffc0,%eax
8010214c:	3c 40                	cmp    $0x40,%al
8010214e:	75 f8                	jne    80102148 <ideinit+0x38>
80102150:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102155:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010215a:	ee                   	out    %al,(%dx)
8010215b:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
80102160:	b2 f7                	mov    $0xf7,%dl
80102162:	eb 09                	jmp    8010216d <ideinit+0x5d>
80102164:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102168:	83 e9 01             	sub    $0x1,%ecx
8010216b:	74 0f                	je     8010217c <ideinit+0x6c>
8010216d:	ec                   	in     (%dx),%al
8010216e:	84 c0                	test   %al,%al
80102170:	74 f6                	je     80102168 <ideinit+0x58>
80102172:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
80102179:	00 00 00 
8010217c:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102181:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102186:	ee                   	out    %al,(%dx)
80102187:	c9                   	leave  
80102188:	c3                   	ret    
80102189:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102190 <ideintr>:
80102190:	55                   	push   %ebp
80102191:	89 e5                	mov    %esp,%ebp
80102193:	57                   	push   %edi
80102194:	56                   	push   %esi
80102195:	53                   	push   %ebx
80102196:	83 ec 1c             	sub    $0x1c,%esp
80102199:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
801021a0:	e8 2b 21 00 00       	call   801042d0 <acquire>
801021a5:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
801021ab:	85 db                	test   %ebx,%ebx
801021ad:	74 30                	je     801021df <ideintr+0x4f>
801021af:	8b 43 58             	mov    0x58(%ebx),%eax
801021b2:	a3 64 a5 10 80       	mov    %eax,0x8010a564
801021b7:	8b 33                	mov    (%ebx),%esi
801021b9:	f7 c6 04 00 00 00    	test   $0x4,%esi
801021bf:	74 37                	je     801021f8 <ideintr+0x68>
801021c1:	83 e6 fb             	and    $0xfffffffb,%esi
801021c4:	83 ce 02             	or     $0x2,%esi
801021c7:	89 33                	mov    %esi,(%ebx)
801021c9:	89 1c 24             	mov    %ebx,(%esp)
801021cc:	e8 3f 1d 00 00       	call   80103f10 <wakeup>
801021d1:	a1 64 a5 10 80       	mov    0x8010a564,%eax
801021d6:	85 c0                	test   %eax,%eax
801021d8:	74 05                	je     801021df <ideintr+0x4f>
801021da:	e8 71 fe ff ff       	call   80102050 <idestart>
801021df:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
801021e6:	e8 d5 21 00 00       	call   801043c0 <release>
801021eb:	83 c4 1c             	add    $0x1c,%esp
801021ee:	5b                   	pop    %ebx
801021ef:	5e                   	pop    %esi
801021f0:	5f                   	pop    %edi
801021f1:	5d                   	pop    %ebp
801021f2:	c3                   	ret    
801021f3:	90                   	nop
801021f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801021f8:	ba f7 01 00 00       	mov    $0x1f7,%edx
801021fd:	8d 76 00             	lea    0x0(%esi),%esi
80102200:	ec                   	in     (%dx),%al
80102201:	89 c1                	mov    %eax,%ecx
80102203:	83 e1 c0             	and    $0xffffffc0,%ecx
80102206:	80 f9 40             	cmp    $0x40,%cl
80102209:	75 f5                	jne    80102200 <ideintr+0x70>
8010220b:	a8 21                	test   $0x21,%al
8010220d:	75 b2                	jne    801021c1 <ideintr+0x31>
8010220f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
80102212:	b9 80 00 00 00       	mov    $0x80,%ecx
80102217:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010221c:	fc                   	cld    
8010221d:	f3 6d                	rep insl (%dx),%es:(%edi)
8010221f:	8b 33                	mov    (%ebx),%esi
80102221:	eb 9e                	jmp    801021c1 <ideintr+0x31>
80102223:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102229:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102230 <iderw>:
80102230:	55                   	push   %ebp
80102231:	89 e5                	mov    %esp,%ebp
80102233:	53                   	push   %ebx
80102234:	83 ec 14             	sub    $0x14,%esp
80102237:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010223a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010223d:	89 04 24             	mov    %eax,(%esp)
80102240:	e8 6b 1f 00 00       	call   801041b0 <holdingsleep>
80102245:	85 c0                	test   %eax,%eax
80102247:	0f 84 9e 00 00 00    	je     801022eb <iderw+0xbb>
8010224d:	8b 03                	mov    (%ebx),%eax
8010224f:	83 e0 06             	and    $0x6,%eax
80102252:	83 f8 02             	cmp    $0x2,%eax
80102255:	0f 84 a8 00 00 00    	je     80102303 <iderw+0xd3>
8010225b:	8b 53 04             	mov    0x4(%ebx),%edx
8010225e:	85 d2                	test   %edx,%edx
80102260:	74 0d                	je     8010226f <iderw+0x3f>
80102262:	a1 60 a5 10 80       	mov    0x8010a560,%eax
80102267:	85 c0                	test   %eax,%eax
80102269:	0f 84 88 00 00 00    	je     801022f7 <iderw+0xc7>
8010226f:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
80102276:	e8 55 20 00 00       	call   801042d0 <acquire>
8010227b:	a1 64 a5 10 80       	mov    0x8010a564,%eax
80102280:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
80102287:	85 c0                	test   %eax,%eax
80102289:	75 07                	jne    80102292 <iderw+0x62>
8010228b:	eb 4e                	jmp    801022db <iderw+0xab>
8010228d:	8d 76 00             	lea    0x0(%esi),%esi
80102290:	89 d0                	mov    %edx,%eax
80102292:	8b 50 58             	mov    0x58(%eax),%edx
80102295:	85 d2                	test   %edx,%edx
80102297:	75 f7                	jne    80102290 <iderw+0x60>
80102299:	83 c0 58             	add    $0x58,%eax
8010229c:	89 18                	mov    %ebx,(%eax)
8010229e:	39 1d 64 a5 10 80    	cmp    %ebx,0x8010a564
801022a4:	74 3c                	je     801022e2 <iderw+0xb2>
801022a6:	8b 03                	mov    (%ebx),%eax
801022a8:	83 e0 06             	and    $0x6,%eax
801022ab:	83 f8 02             	cmp    $0x2,%eax
801022ae:	74 1a                	je     801022ca <iderw+0x9a>
801022b0:	c7 44 24 04 80 a5 10 	movl   $0x8010a580,0x4(%esp)
801022b7:	80 
801022b8:	89 1c 24             	mov    %ebx,(%esp)
801022bb:	e8 b0 1a 00 00       	call   80103d70 <sleep>
801022c0:	8b 13                	mov    (%ebx),%edx
801022c2:	83 e2 06             	and    $0x6,%edx
801022c5:	83 fa 02             	cmp    $0x2,%edx
801022c8:	75 e6                	jne    801022b0 <iderw+0x80>
801022ca:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
801022d1:	83 c4 14             	add    $0x14,%esp
801022d4:	5b                   	pop    %ebx
801022d5:	5d                   	pop    %ebp
801022d6:	e9 e5 20 00 00       	jmp    801043c0 <release>
801022db:	b8 64 a5 10 80       	mov    $0x8010a564,%eax
801022e0:	eb ba                	jmp    8010229c <iderw+0x6c>
801022e2:	89 d8                	mov    %ebx,%eax
801022e4:	e8 67 fd ff ff       	call   80102050 <idestart>
801022e9:	eb bb                	jmp    801022a6 <iderw+0x76>
801022eb:	c7 04 24 aa 71 10 80 	movl   $0x801071aa,(%esp)
801022f2:	e8 69 e0 ff ff       	call   80100360 <panic>
801022f7:	c7 04 24 d5 71 10 80 	movl   $0x801071d5,(%esp)
801022fe:	e8 5d e0 ff ff       	call   80100360 <panic>
80102303:	c7 04 24 c0 71 10 80 	movl   $0x801071c0,(%esp)
8010230a:	e8 51 e0 ff ff       	call   80100360 <panic>
	...

80102310 <ioapicinit>:
80102310:	55                   	push   %ebp
80102311:	89 e5                	mov    %esp,%ebp
80102313:	56                   	push   %esi
80102314:	53                   	push   %ebx
80102315:	83 ec 10             	sub    $0x10,%esp
80102318:	c7 05 6c 25 11 80 00 	movl   $0xfec00000,0x8011256c
8010231f:	00 c0 fe 
80102322:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102329:	00 00 00 
8010232c:	8b 15 6c 25 11 80    	mov    0x8011256c,%edx
80102332:	8b 42 10             	mov    0x10(%edx),%eax
80102335:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
8010233b:	8b 1d 6c 25 11 80    	mov    0x8011256c,%ebx
80102341:	0f b6 15 a0 26 11 80 	movzbl 0x801126a0,%edx
80102348:	c1 e8 10             	shr    $0x10,%eax
8010234b:	0f b6 f0             	movzbl %al,%esi
8010234e:	8b 43 10             	mov    0x10(%ebx),%eax
80102351:	c1 e8 18             	shr    $0x18,%eax
80102354:	39 c2                	cmp    %eax,%edx
80102356:	74 12                	je     8010236a <ioapicinit+0x5a>
80102358:	c7 04 24 f4 71 10 80 	movl   $0x801071f4,(%esp)
8010235f:	e8 ec e2 ff ff       	call   80100650 <cprintf>
80102364:	8b 1d 6c 25 11 80    	mov    0x8011256c,%ebx
8010236a:	ba 10 00 00 00       	mov    $0x10,%edx
8010236f:	31 c0                	xor    %eax,%eax
80102371:	eb 07                	jmp    8010237a <ioapicinit+0x6a>
80102373:	90                   	nop
80102374:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102378:	89 cb                	mov    %ecx,%ebx
8010237a:	89 13                	mov    %edx,(%ebx)
8010237c:	8b 1d 6c 25 11 80    	mov    0x8011256c,%ebx
80102382:	8d 48 20             	lea    0x20(%eax),%ecx
80102385:	81 c9 00 00 01 00    	or     $0x10000,%ecx
8010238b:	83 c0 01             	add    $0x1,%eax
8010238e:	89 4b 10             	mov    %ecx,0x10(%ebx)
80102391:	8d 4a 01             	lea    0x1(%edx),%ecx
80102394:	83 c2 02             	add    $0x2,%edx
80102397:	89 0b                	mov    %ecx,(%ebx)
80102399:	8b 0d 6c 25 11 80    	mov    0x8011256c,%ecx
8010239f:	39 c6                	cmp    %eax,%esi
801023a1:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
801023a8:	7d ce                	jge    80102378 <ioapicinit+0x68>
801023aa:	83 c4 10             	add    $0x10,%esp
801023ad:	5b                   	pop    %ebx
801023ae:	5e                   	pop    %esi
801023af:	5d                   	pop    %ebp
801023b0:	c3                   	ret    
801023b1:	eb 0d                	jmp    801023c0 <ioapicenable>
801023b3:	90                   	nop
801023b4:	90                   	nop
801023b5:	90                   	nop
801023b6:	90                   	nop
801023b7:	90                   	nop
801023b8:	90                   	nop
801023b9:	90                   	nop
801023ba:	90                   	nop
801023bb:	90                   	nop
801023bc:	90                   	nop
801023bd:	90                   	nop
801023be:	90                   	nop
801023bf:	90                   	nop

801023c0 <ioapicenable>:
801023c0:	55                   	push   %ebp
801023c1:	89 e5                	mov    %esp,%ebp
801023c3:	8b 55 08             	mov    0x8(%ebp),%edx
801023c6:	53                   	push   %ebx
801023c7:	8b 45 0c             	mov    0xc(%ebp),%eax
801023ca:	8d 5a 20             	lea    0x20(%edx),%ebx
801023cd:	8d 4c 12 10          	lea    0x10(%edx,%edx,1),%ecx
801023d1:	8b 15 6c 25 11 80    	mov    0x8011256c,%edx
801023d7:	c1 e0 18             	shl    $0x18,%eax
801023da:	89 0a                	mov    %ecx,(%edx)
801023dc:	8b 15 6c 25 11 80    	mov    0x8011256c,%edx
801023e2:	83 c1 01             	add    $0x1,%ecx
801023e5:	89 5a 10             	mov    %ebx,0x10(%edx)
801023e8:	89 0a                	mov    %ecx,(%edx)
801023ea:	8b 15 6c 25 11 80    	mov    0x8011256c,%edx
801023f0:	89 42 10             	mov    %eax,0x10(%edx)
801023f3:	5b                   	pop    %ebx
801023f4:	5d                   	pop    %ebp
801023f5:	c3                   	ret    
	...

80102400 <kfree>:
80102400:	55                   	push   %ebp
80102401:	89 e5                	mov    %esp,%ebp
80102403:	53                   	push   %ebx
80102404:	83 ec 14             	sub    $0x14,%esp
80102407:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010240a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102410:	75 7c                	jne    8010248e <kfree+0x8e>
80102412:	81 fb e8 56 11 80    	cmp    $0x801156e8,%ebx
80102418:	72 74                	jb     8010248e <kfree+0x8e>
8010241a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102420:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102425:	77 67                	ja     8010248e <kfree+0x8e>
80102427:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010242e:	00 
8010242f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102436:	00 
80102437:	89 1c 24             	mov    %ebx,(%esp)
8010243a:	e8 d1 1f 00 00       	call   80104410 <memset>
8010243f:	8b 15 b4 25 11 80    	mov    0x801125b4,%edx
80102445:	85 d2                	test   %edx,%edx
80102447:	75 37                	jne    80102480 <kfree+0x80>
80102449:	a1 b8 25 11 80       	mov    0x801125b8,%eax
8010244e:	89 03                	mov    %eax,(%ebx)
80102450:	a1 b4 25 11 80       	mov    0x801125b4,%eax
80102455:	89 1d b8 25 11 80    	mov    %ebx,0x801125b8
8010245b:	85 c0                	test   %eax,%eax
8010245d:	75 09                	jne    80102468 <kfree+0x68>
8010245f:	83 c4 14             	add    $0x14,%esp
80102462:	5b                   	pop    %ebx
80102463:	5d                   	pop    %ebp
80102464:	c3                   	ret    
80102465:	8d 76 00             	lea    0x0(%esi),%esi
80102468:	c7 45 08 80 25 11 80 	movl   $0x80112580,0x8(%ebp)
8010246f:	83 c4 14             	add    $0x14,%esp
80102472:	5b                   	pop    %ebx
80102473:	5d                   	pop    %ebp
80102474:	e9 47 1f 00 00       	jmp    801043c0 <release>
80102479:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102480:	c7 04 24 80 25 11 80 	movl   $0x80112580,(%esp)
80102487:	e8 44 1e 00 00       	call   801042d0 <acquire>
8010248c:	eb bb                	jmp    80102449 <kfree+0x49>
8010248e:	c7 04 24 26 72 10 80 	movl   $0x80107226,(%esp)
80102495:	e8 c6 de ff ff       	call   80100360 <panic>
8010249a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801024a0 <freerange>:
801024a0:	55                   	push   %ebp
801024a1:	89 e5                	mov    %esp,%ebp
801024a3:	56                   	push   %esi
801024a4:	53                   	push   %ebx
801024a5:	83 ec 10             	sub    $0x10,%esp
801024a8:	8b 45 08             	mov    0x8(%ebp),%eax
801024ab:	8b 75 0c             	mov    0xc(%ebp),%esi
801024ae:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
801024b4:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
801024ba:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
801024c0:	39 de                	cmp    %ebx,%esi
801024c2:	73 08                	jae    801024cc <freerange+0x2c>
801024c4:	eb 18                	jmp    801024de <freerange+0x3e>
801024c6:	66 90                	xchg   %ax,%ax
801024c8:	89 da                	mov    %ebx,%edx
801024ca:	89 c3                	mov    %eax,%ebx
801024cc:	89 14 24             	mov    %edx,(%esp)
801024cf:	e8 2c ff ff ff       	call   80102400 <kfree>
801024d4:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
801024da:	39 f0                	cmp    %esi,%eax
801024dc:	76 ea                	jbe    801024c8 <freerange+0x28>
801024de:	83 c4 10             	add    $0x10,%esp
801024e1:	5b                   	pop    %ebx
801024e2:	5e                   	pop    %esi
801024e3:	5d                   	pop    %ebp
801024e4:	c3                   	ret    
801024e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801024e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801024f0 <kinit1>:
801024f0:	55                   	push   %ebp
801024f1:	89 e5                	mov    %esp,%ebp
801024f3:	56                   	push   %esi
801024f4:	53                   	push   %ebx
801024f5:	83 ec 10             	sub    $0x10,%esp
801024f8:	8b 75 0c             	mov    0xc(%ebp),%esi
801024fb:	c7 44 24 04 2c 72 10 	movl   $0x8010722c,0x4(%esp)
80102502:	80 
80102503:	c7 04 24 80 25 11 80 	movl   $0x80112580,(%esp)
8010250a:	e8 d1 1c 00 00       	call   801041e0 <initlock>
8010250f:	8b 45 08             	mov    0x8(%ebp),%eax
80102512:	c7 05 b4 25 11 80 00 	movl   $0x0,0x801125b4
80102519:	00 00 00 
8010251c:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80102522:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80102528:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
8010252e:	39 de                	cmp    %ebx,%esi
80102530:	73 0a                	jae    8010253c <kinit1+0x4c>
80102532:	eb 1a                	jmp    8010254e <kinit1+0x5e>
80102534:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102538:	89 da                	mov    %ebx,%edx
8010253a:	89 c3                	mov    %eax,%ebx
8010253c:	89 14 24             	mov    %edx,(%esp)
8010253f:	e8 bc fe ff ff       	call   80102400 <kfree>
80102544:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
8010254a:	39 c6                	cmp    %eax,%esi
8010254c:	73 ea                	jae    80102538 <kinit1+0x48>
8010254e:	83 c4 10             	add    $0x10,%esp
80102551:	5b                   	pop    %ebx
80102552:	5e                   	pop    %esi
80102553:	5d                   	pop    %ebp
80102554:	c3                   	ret    
80102555:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102559:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102560 <kinit2>:
80102560:	55                   	push   %ebp
80102561:	89 e5                	mov    %esp,%ebp
80102563:	56                   	push   %esi
80102564:	53                   	push   %ebx
80102565:	83 ec 10             	sub    $0x10,%esp
80102568:	8b 45 08             	mov    0x8(%ebp),%eax
8010256b:	8b 75 0c             	mov    0xc(%ebp),%esi
8010256e:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80102574:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
8010257a:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
80102580:	39 de                	cmp    %ebx,%esi
80102582:	73 08                	jae    8010258c <kinit2+0x2c>
80102584:	eb 18                	jmp    8010259e <kinit2+0x3e>
80102586:	66 90                	xchg   %ax,%ax
80102588:	89 da                	mov    %ebx,%edx
8010258a:	89 c3                	mov    %eax,%ebx
8010258c:	89 14 24             	mov    %edx,(%esp)
8010258f:	e8 6c fe ff ff       	call   80102400 <kfree>
80102594:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
8010259a:	39 c6                	cmp    %eax,%esi
8010259c:	73 ea                	jae    80102588 <kinit2+0x28>
8010259e:	c7 05 b4 25 11 80 01 	movl   $0x1,0x801125b4
801025a5:	00 00 00 
801025a8:	83 c4 10             	add    $0x10,%esp
801025ab:	5b                   	pop    %ebx
801025ac:	5e                   	pop    %esi
801025ad:	5d                   	pop    %ebp
801025ae:	c3                   	ret    
801025af:	90                   	nop

801025b0 <kalloc>:
801025b0:	55                   	push   %ebp
801025b1:	89 e5                	mov    %esp,%ebp
801025b3:	53                   	push   %ebx
801025b4:	83 ec 14             	sub    $0x14,%esp
801025b7:	a1 b4 25 11 80       	mov    0x801125b4,%eax
801025bc:	85 c0                	test   %eax,%eax
801025be:	75 30                	jne    801025f0 <kalloc+0x40>
801025c0:	8b 1d b8 25 11 80    	mov    0x801125b8,%ebx
801025c6:	85 db                	test   %ebx,%ebx
801025c8:	74 08                	je     801025d2 <kalloc+0x22>
801025ca:	8b 13                	mov    (%ebx),%edx
801025cc:	89 15 b8 25 11 80    	mov    %edx,0x801125b8
801025d2:	85 c0                	test   %eax,%eax
801025d4:	74 0c                	je     801025e2 <kalloc+0x32>
801025d6:	c7 04 24 80 25 11 80 	movl   $0x80112580,(%esp)
801025dd:	e8 de 1d 00 00       	call   801043c0 <release>
801025e2:	83 c4 14             	add    $0x14,%esp
801025e5:	89 d8                	mov    %ebx,%eax
801025e7:	5b                   	pop    %ebx
801025e8:	5d                   	pop    %ebp
801025e9:	c3                   	ret    
801025ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801025f0:	c7 04 24 80 25 11 80 	movl   $0x80112580,(%esp)
801025f7:	e8 d4 1c 00 00       	call   801042d0 <acquire>
801025fc:	a1 b4 25 11 80       	mov    0x801125b4,%eax
80102601:	eb bd                	jmp    801025c0 <kalloc+0x10>
	...

80102610 <kbdgetc>:
80102610:	ba 64 00 00 00       	mov    $0x64,%edx
80102615:	ec                   	in     (%dx),%al
80102616:	a8 01                	test   $0x1,%al
80102618:	0f 84 ba 00 00 00    	je     801026d8 <kbdgetc+0xc8>
8010261e:	b2 60                	mov    $0x60,%dl
80102620:	ec                   	in     (%dx),%al
80102621:	0f b6 c8             	movzbl %al,%ecx
80102624:	81 f9 e0 00 00 00    	cmp    $0xe0,%ecx
8010262a:	0f 84 88 00 00 00    	je     801026b8 <kbdgetc+0xa8>
80102630:	84 c0                	test   %al,%al
80102632:	79 2c                	jns    80102660 <kbdgetc+0x50>
80102634:	8b 15 b4 a5 10 80    	mov    0x8010a5b4,%edx
8010263a:	f6 c2 40             	test   $0x40,%dl
8010263d:	75 05                	jne    80102644 <kbdgetc+0x34>
8010263f:	89 c1                	mov    %eax,%ecx
80102641:	83 e1 7f             	and    $0x7f,%ecx
80102644:	0f b6 81 60 73 10 80 	movzbl -0x7fef8ca0(%ecx),%eax
8010264b:	83 c8 40             	or     $0x40,%eax
8010264e:	0f b6 c0             	movzbl %al,%eax
80102651:	f7 d0                	not    %eax
80102653:	21 d0                	and    %edx,%eax
80102655:	a3 b4 a5 10 80       	mov    %eax,0x8010a5b4
8010265a:	31 c0                	xor    %eax,%eax
8010265c:	c3                   	ret    
8010265d:	8d 76 00             	lea    0x0(%esi),%esi
80102660:	55                   	push   %ebp
80102661:	89 e5                	mov    %esp,%ebp
80102663:	53                   	push   %ebx
80102664:	8b 1d b4 a5 10 80    	mov    0x8010a5b4,%ebx
8010266a:	f6 c3 40             	test   $0x40,%bl
8010266d:	74 09                	je     80102678 <kbdgetc+0x68>
8010266f:	83 c8 80             	or     $0xffffff80,%eax
80102672:	83 e3 bf             	and    $0xffffffbf,%ebx
80102675:	0f b6 c8             	movzbl %al,%ecx
80102678:	0f b6 91 60 73 10 80 	movzbl -0x7fef8ca0(%ecx),%edx
8010267f:	0f b6 81 60 72 10 80 	movzbl -0x7fef8da0(%ecx),%eax
80102686:	09 da                	or     %ebx,%edx
80102688:	31 c2                	xor    %eax,%edx
8010268a:	89 d0                	mov    %edx,%eax
8010268c:	83 e0 03             	and    $0x3,%eax
8010268f:	8b 04 85 40 72 10 80 	mov    -0x7fef8dc0(,%eax,4),%eax
80102696:	89 15 b4 a5 10 80    	mov    %edx,0x8010a5b4
8010269c:	83 e2 08             	and    $0x8,%edx
8010269f:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
801026a3:	74 0b                	je     801026b0 <kbdgetc+0xa0>
801026a5:	8d 50 9f             	lea    -0x61(%eax),%edx
801026a8:	83 fa 19             	cmp    $0x19,%edx
801026ab:	77 1b                	ja     801026c8 <kbdgetc+0xb8>
801026ad:	83 e8 20             	sub    $0x20,%eax
801026b0:	5b                   	pop    %ebx
801026b1:	5d                   	pop    %ebp
801026b2:	c3                   	ret    
801026b3:	90                   	nop
801026b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801026b8:	83 0d b4 a5 10 80 40 	orl    $0x40,0x8010a5b4
801026bf:	31 c0                	xor    %eax,%eax
801026c1:	c3                   	ret    
801026c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801026c8:	8d 48 bf             	lea    -0x41(%eax),%ecx
801026cb:	8d 50 20             	lea    0x20(%eax),%edx
801026ce:	83 f9 19             	cmp    $0x19,%ecx
801026d1:	0f 46 c2             	cmovbe %edx,%eax
801026d4:	eb da                	jmp    801026b0 <kbdgetc+0xa0>
801026d6:	66 90                	xchg   %ax,%ax
801026d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801026dd:	c3                   	ret    
801026de:	66 90                	xchg   %ax,%ax

801026e0 <kbdintr>:
801026e0:	55                   	push   %ebp
801026e1:	89 e5                	mov    %esp,%ebp
801026e3:	83 ec 18             	sub    $0x18,%esp
801026e6:	c7 04 24 10 26 10 80 	movl   $0x80102610,(%esp)
801026ed:	e8 be e0 ff ff       	call   801007b0 <consoleintr>
801026f2:	c9                   	leave  
801026f3:	c3                   	ret    
	...

80102700 <fill_rtcdate>:
80102700:	55                   	push   %ebp
80102701:	89 c1                	mov    %eax,%ecx
80102703:	89 e5                	mov    %esp,%ebp
80102705:	ba 70 00 00 00       	mov    $0x70,%edx
8010270a:	31 c0                	xor    %eax,%eax
8010270c:	ee                   	out    %al,(%dx)
8010270d:	b2 71                	mov    $0x71,%dl
8010270f:	ec                   	in     (%dx),%al
80102710:	0f b6 c0             	movzbl %al,%eax
80102713:	b2 70                	mov    $0x70,%dl
80102715:	89 01                	mov    %eax,(%ecx)
80102717:	b8 02 00 00 00       	mov    $0x2,%eax
8010271c:	ee                   	out    %al,(%dx)
8010271d:	b2 71                	mov    $0x71,%dl
8010271f:	ec                   	in     (%dx),%al
80102720:	0f b6 c0             	movzbl %al,%eax
80102723:	b2 70                	mov    $0x70,%dl
80102725:	89 41 04             	mov    %eax,0x4(%ecx)
80102728:	b8 04 00 00 00       	mov    $0x4,%eax
8010272d:	ee                   	out    %al,(%dx)
8010272e:	b2 71                	mov    $0x71,%dl
80102730:	ec                   	in     (%dx),%al
80102731:	0f b6 c0             	movzbl %al,%eax
80102734:	b2 70                	mov    $0x70,%dl
80102736:	89 41 08             	mov    %eax,0x8(%ecx)
80102739:	b8 07 00 00 00       	mov    $0x7,%eax
8010273e:	ee                   	out    %al,(%dx)
8010273f:	b2 71                	mov    $0x71,%dl
80102741:	ec                   	in     (%dx),%al
80102742:	0f b6 c0             	movzbl %al,%eax
80102745:	b2 70                	mov    $0x70,%dl
80102747:	89 41 0c             	mov    %eax,0xc(%ecx)
8010274a:	b8 08 00 00 00       	mov    $0x8,%eax
8010274f:	ee                   	out    %al,(%dx)
80102750:	b2 71                	mov    $0x71,%dl
80102752:	ec                   	in     (%dx),%al
80102753:	0f b6 c0             	movzbl %al,%eax
80102756:	b2 70                	mov    $0x70,%dl
80102758:	89 41 10             	mov    %eax,0x10(%ecx)
8010275b:	b8 09 00 00 00       	mov    $0x9,%eax
80102760:	ee                   	out    %al,(%dx)
80102761:	b2 71                	mov    $0x71,%dl
80102763:	ec                   	in     (%dx),%al
80102764:	0f b6 c0             	movzbl %al,%eax
80102767:	89 41 14             	mov    %eax,0x14(%ecx)
8010276a:	5d                   	pop    %ebp
8010276b:	c3                   	ret    
8010276c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102770 <lapicinit>:
80102770:	a1 bc 25 11 80       	mov    0x801125bc,%eax
80102775:	55                   	push   %ebp
80102776:	89 e5                	mov    %esp,%ebp
80102778:	85 c0                	test   %eax,%eax
8010277a:	0f 84 c0 00 00 00    	je     80102840 <lapicinit+0xd0>
80102780:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102787:	01 00 00 
8010278a:	8b 50 20             	mov    0x20(%eax),%edx
8010278d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102794:	00 00 00 
80102797:	8b 50 20             	mov    0x20(%eax),%edx
8010279a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801027a1:	00 02 00 
801027a4:	8b 50 20             	mov    0x20(%eax),%edx
801027a7:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801027ae:	96 98 00 
801027b1:	8b 50 20             	mov    0x20(%eax),%edx
801027b4:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801027bb:	00 01 00 
801027be:	8b 50 20             	mov    0x20(%eax),%edx
801027c1:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801027c8:	00 01 00 
801027cb:	8b 50 20             	mov    0x20(%eax),%edx
801027ce:	8b 50 30             	mov    0x30(%eax),%edx
801027d1:	c1 ea 10             	shr    $0x10,%edx
801027d4:	80 fa 03             	cmp    $0x3,%dl
801027d7:	77 6f                	ja     80102848 <lapicinit+0xd8>
801027d9:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801027e0:	00 00 00 
801027e3:	8b 50 20             	mov    0x20(%eax),%edx
801027e6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801027ed:	00 00 00 
801027f0:	8b 50 20             	mov    0x20(%eax),%edx
801027f3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801027fa:	00 00 00 
801027fd:	8b 50 20             	mov    0x20(%eax),%edx
80102800:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102807:	00 00 00 
8010280a:	8b 50 20             	mov    0x20(%eax),%edx
8010280d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102814:	00 00 00 
80102817:	8b 50 20             	mov    0x20(%eax),%edx
8010281a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102821:	85 08 00 
80102824:	8b 50 20             	mov    0x20(%eax),%edx
80102827:	90                   	nop
80102828:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
8010282e:	80 e6 10             	and    $0x10,%dh
80102831:	75 f5                	jne    80102828 <lapicinit+0xb8>
80102833:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
8010283a:	00 00 00 
8010283d:	8b 40 20             	mov    0x20(%eax),%eax
80102840:	5d                   	pop    %ebp
80102841:	c3                   	ret    
80102842:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102848:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
8010284f:	00 01 00 
80102852:	8b 50 20             	mov    0x20(%eax),%edx
80102855:	eb 82                	jmp    801027d9 <lapicinit+0x69>
80102857:	89 f6                	mov    %esi,%esi
80102859:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102860 <lapicid>:
80102860:	a1 bc 25 11 80       	mov    0x801125bc,%eax
80102865:	55                   	push   %ebp
80102866:	89 e5                	mov    %esp,%ebp
80102868:	85 c0                	test   %eax,%eax
8010286a:	74 0c                	je     80102878 <lapicid+0x18>
8010286c:	8b 40 20             	mov    0x20(%eax),%eax
8010286f:	5d                   	pop    %ebp
80102870:	c1 e8 18             	shr    $0x18,%eax
80102873:	c3                   	ret    
80102874:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102878:	31 c0                	xor    %eax,%eax
8010287a:	5d                   	pop    %ebp
8010287b:	c3                   	ret    
8010287c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102880 <lapiceoi>:
80102880:	a1 bc 25 11 80       	mov    0x801125bc,%eax
80102885:	55                   	push   %ebp
80102886:	89 e5                	mov    %esp,%ebp
80102888:	85 c0                	test   %eax,%eax
8010288a:	74 0d                	je     80102899 <lapiceoi+0x19>
8010288c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102893:	00 00 00 
80102896:	8b 40 20             	mov    0x20(%eax),%eax
80102899:	5d                   	pop    %ebp
8010289a:	c3                   	ret    
8010289b:	90                   	nop
8010289c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801028a0 <microdelay>:
801028a0:	55                   	push   %ebp
801028a1:	89 e5                	mov    %esp,%ebp
801028a3:	5d                   	pop    %ebp
801028a4:	c3                   	ret    
801028a5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801028a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801028b0 <lapicstartap>:
801028b0:	55                   	push   %ebp
801028b1:	ba 70 00 00 00       	mov    $0x70,%edx
801028b6:	89 e5                	mov    %esp,%ebp
801028b8:	b8 0f 00 00 00       	mov    $0xf,%eax
801028bd:	53                   	push   %ebx
801028be:	8b 4d 08             	mov    0x8(%ebp),%ecx
801028c1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801028c4:	ee                   	out    %al,(%dx)
801028c5:	b8 0a 00 00 00       	mov    $0xa,%eax
801028ca:	b2 71                	mov    $0x71,%dl
801028cc:	ee                   	out    %al,(%dx)
801028cd:	31 c0                	xor    %eax,%eax
801028cf:	66 a3 67 04 00 80    	mov    %ax,0x80000467
801028d5:	89 d8                	mov    %ebx,%eax
801028d7:	c1 e8 04             	shr    $0x4,%eax
801028da:	66 a3 69 04 00 80    	mov    %ax,0x80000469
801028e0:	a1 bc 25 11 80       	mov    0x801125bc,%eax
801028e5:	c1 e1 18             	shl    $0x18,%ecx
801028e8:	c1 eb 0c             	shr    $0xc,%ebx
801028eb:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
801028f1:	8b 50 20             	mov    0x20(%eax),%edx
801028f4:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
801028fb:	c5 00 00 
801028fe:	8b 50 20             	mov    0x20(%eax),%edx
80102901:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102908:	85 00 00 
8010290b:	8b 50 20             	mov    0x20(%eax),%edx
8010290e:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
80102914:	8b 50 20             	mov    0x20(%eax),%edx
80102917:	89 da                	mov    %ebx,%edx
80102919:	80 ce 06             	or     $0x6,%dh
8010291c:	89 90 00 03 00 00    	mov    %edx,0x300(%eax)
80102922:	8b 58 20             	mov    0x20(%eax),%ebx
80102925:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
8010292b:	8b 48 20             	mov    0x20(%eax),%ecx
8010292e:	89 90 00 03 00 00    	mov    %edx,0x300(%eax)
80102934:	8b 40 20             	mov    0x20(%eax),%eax
80102937:	5b                   	pop    %ebx
80102938:	5d                   	pop    %ebp
80102939:	c3                   	ret    
8010293a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102940 <cmostime>:
80102940:	55                   	push   %ebp
80102941:	ba 70 00 00 00       	mov    $0x70,%edx
80102946:	89 e5                	mov    %esp,%ebp
80102948:	b8 0b 00 00 00       	mov    $0xb,%eax
8010294d:	57                   	push   %edi
8010294e:	56                   	push   %esi
8010294f:	53                   	push   %ebx
80102950:	83 ec 4c             	sub    $0x4c,%esp
80102953:	ee                   	out    %al,(%dx)
80102954:	b2 71                	mov    $0x71,%dl
80102956:	ec                   	in     (%dx),%al
80102957:	88 45 b7             	mov    %al,-0x49(%ebp)
8010295a:	8d 5d b8             	lea    -0x48(%ebp),%ebx
8010295d:	80 65 b7 04          	andb   $0x4,-0x49(%ebp)
80102961:	8d 7d d0             	lea    -0x30(%ebp),%edi
80102964:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102968:	be 70 00 00 00       	mov    $0x70,%esi
8010296d:	89 d8                	mov    %ebx,%eax
8010296f:	e8 8c fd ff ff       	call   80102700 <fill_rtcdate>
80102974:	b8 0a 00 00 00       	mov    $0xa,%eax
80102979:	89 f2                	mov    %esi,%edx
8010297b:	ee                   	out    %al,(%dx)
8010297c:	ba 71 00 00 00       	mov    $0x71,%edx
80102981:	ec                   	in     (%dx),%al
80102982:	84 c0                	test   %al,%al
80102984:	78 e7                	js     8010296d <cmostime+0x2d>
80102986:	89 f8                	mov    %edi,%eax
80102988:	e8 73 fd ff ff       	call   80102700 <fill_rtcdate>
8010298d:	c7 44 24 08 18 00 00 	movl   $0x18,0x8(%esp)
80102994:	00 
80102995:	89 7c 24 04          	mov    %edi,0x4(%esp)
80102999:	89 1c 24             	mov    %ebx,(%esp)
8010299c:	e8 bf 1a 00 00       	call   80104460 <memcmp>
801029a1:	85 c0                	test   %eax,%eax
801029a3:	75 c3                	jne    80102968 <cmostime+0x28>
801029a5:	80 7d b7 00          	cmpb   $0x0,-0x49(%ebp)
801029a9:	75 78                	jne    80102a23 <cmostime+0xe3>
801029ab:	8b 45 b8             	mov    -0x48(%ebp),%eax
801029ae:	89 c2                	mov    %eax,%edx
801029b0:	83 e0 0f             	and    $0xf,%eax
801029b3:	c1 ea 04             	shr    $0x4,%edx
801029b6:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029b9:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029bc:	89 45 b8             	mov    %eax,-0x48(%ebp)
801029bf:	8b 45 bc             	mov    -0x44(%ebp),%eax
801029c2:	89 c2                	mov    %eax,%edx
801029c4:	83 e0 0f             	and    $0xf,%eax
801029c7:	c1 ea 04             	shr    $0x4,%edx
801029ca:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029cd:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029d0:	89 45 bc             	mov    %eax,-0x44(%ebp)
801029d3:	8b 45 c0             	mov    -0x40(%ebp),%eax
801029d6:	89 c2                	mov    %eax,%edx
801029d8:	83 e0 0f             	and    $0xf,%eax
801029db:	c1 ea 04             	shr    $0x4,%edx
801029de:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029e1:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029e4:	89 45 c0             	mov    %eax,-0x40(%ebp)
801029e7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801029ea:	89 c2                	mov    %eax,%edx
801029ec:	83 e0 0f             	and    $0xf,%eax
801029ef:	c1 ea 04             	shr    $0x4,%edx
801029f2:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029f5:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029f8:	89 45 c4             	mov    %eax,-0x3c(%ebp)
801029fb:	8b 45 c8             	mov    -0x38(%ebp),%eax
801029fe:	89 c2                	mov    %eax,%edx
80102a00:	83 e0 0f             	and    $0xf,%eax
80102a03:	c1 ea 04             	shr    $0x4,%edx
80102a06:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102a09:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102a0c:	89 45 c8             	mov    %eax,-0x38(%ebp)
80102a0f:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102a12:	89 c2                	mov    %eax,%edx
80102a14:	83 e0 0f             	and    $0xf,%eax
80102a17:	c1 ea 04             	shr    $0x4,%edx
80102a1a:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102a1d:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102a20:	89 45 cc             	mov    %eax,-0x34(%ebp)
80102a23:	8b 4d 08             	mov    0x8(%ebp),%ecx
80102a26:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102a29:	89 01                	mov    %eax,(%ecx)
80102a2b:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102a2e:	89 41 04             	mov    %eax,0x4(%ecx)
80102a31:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102a34:	89 41 08             	mov    %eax,0x8(%ecx)
80102a37:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102a3a:	89 41 0c             	mov    %eax,0xc(%ecx)
80102a3d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102a40:	89 41 10             	mov    %eax,0x10(%ecx)
80102a43:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102a46:	89 41 14             	mov    %eax,0x14(%ecx)
80102a49:	81 41 14 d0 07 00 00 	addl   $0x7d0,0x14(%ecx)
80102a50:	83 c4 4c             	add    $0x4c,%esp
80102a53:	5b                   	pop    %ebx
80102a54:	5e                   	pop    %esi
80102a55:	5f                   	pop    %edi
80102a56:	5d                   	pop    %ebp
80102a57:	c3                   	ret    
	...

80102a60 <install_trans>:
80102a60:	55                   	push   %ebp
80102a61:	89 e5                	mov    %esp,%ebp
80102a63:	57                   	push   %edi
80102a64:	56                   	push   %esi
80102a65:	53                   	push   %ebx
80102a66:	31 db                	xor    %ebx,%ebx
80102a68:	83 ec 1c             	sub    $0x1c,%esp
80102a6b:	a1 08 26 11 80       	mov    0x80112608,%eax
80102a70:	85 c0                	test   %eax,%eax
80102a72:	0f 8e 8f 00 00 00    	jle    80102b07 <install_trans+0xa7>
80102a78:	8b 04 9d 0c 26 11 80 	mov    -0x7feed9f4(,%ebx,4),%eax
80102a7f:	c7 04 24 60 74 10 80 	movl   $0x80107460,(%esp)
80102a86:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a8a:	e8 c1 db ff ff       	call   80100650 <cprintf>
80102a8f:	a1 f4 25 11 80       	mov    0x801125f4,%eax
80102a94:	01 d8                	add    %ebx,%eax
80102a96:	83 c0 01             	add    $0x1,%eax
80102a99:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a9d:	a1 04 26 11 80       	mov    0x80112604,%eax
80102aa2:	89 04 24             	mov    %eax,(%esp)
80102aa5:	e8 26 d6 ff ff       	call   801000d0 <bread>
80102aaa:	89 c7                	mov    %eax,%edi
80102aac:	8b 04 9d 0c 26 11 80 	mov    -0x7feed9f4(,%ebx,4),%eax
80102ab3:	83 c3 01             	add    $0x1,%ebx
80102ab6:	89 44 24 04          	mov    %eax,0x4(%esp)
80102aba:	a1 04 26 11 80       	mov    0x80112604,%eax
80102abf:	89 04 24             	mov    %eax,(%esp)
80102ac2:	e8 09 d6 ff ff       	call   801000d0 <bread>
80102ac7:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80102ace:	00 
80102acf:	89 c6                	mov    %eax,%esi
80102ad1:	8d 47 5c             	lea    0x5c(%edi),%eax
80102ad4:	89 44 24 04          	mov    %eax,0x4(%esp)
80102ad8:	8d 46 5c             	lea    0x5c(%esi),%eax
80102adb:	89 04 24             	mov    %eax,(%esp)
80102ade:	e8 cd 19 00 00       	call   801044b0 <memmove>
80102ae3:	89 34 24             	mov    %esi,(%esp)
80102ae6:	e8 b5 d6 ff ff       	call   801001a0 <bwrite>
80102aeb:	89 3c 24             	mov    %edi,(%esp)
80102aee:	e8 ed d6 ff ff       	call   801001e0 <brelse>
80102af3:	89 34 24             	mov    %esi,(%esp)
80102af6:	e8 e5 d6 ff ff       	call   801001e0 <brelse>
80102afb:	39 1d 08 26 11 80    	cmp    %ebx,0x80112608
80102b01:	0f 8f 71 ff ff ff    	jg     80102a78 <install_trans+0x18>
80102b07:	83 c4 1c             	add    $0x1c,%esp
80102b0a:	5b                   	pop    %ebx
80102b0b:	5e                   	pop    %esi
80102b0c:	5f                   	pop    %edi
80102b0d:	5d                   	pop    %ebp
80102b0e:	c3                   	ret    
80102b0f:	90                   	nop

80102b10 <write_head>:
80102b10:	55                   	push   %ebp
80102b11:	89 e5                	mov    %esp,%ebp
80102b13:	57                   	push   %edi
80102b14:	56                   	push   %esi
80102b15:	53                   	push   %ebx
80102b16:	83 ec 1c             	sub    $0x1c,%esp
80102b19:	a1 f4 25 11 80       	mov    0x801125f4,%eax
80102b1e:	89 44 24 04          	mov    %eax,0x4(%esp)
80102b22:	a1 04 26 11 80       	mov    0x80112604,%eax
80102b27:	89 04 24             	mov    %eax,(%esp)
80102b2a:	e8 a1 d5 ff ff       	call   801000d0 <bread>
80102b2f:	8b 1d 08 26 11 80    	mov    0x80112608,%ebx
80102b35:	31 d2                	xor    %edx,%edx
80102b37:	85 db                	test   %ebx,%ebx
80102b39:	89 c7                	mov    %eax,%edi
80102b3b:	89 58 5c             	mov    %ebx,0x5c(%eax)
80102b3e:	8d 70 5c             	lea    0x5c(%eax),%esi
80102b41:	7e 17                	jle    80102b5a <write_head+0x4a>
80102b43:	90                   	nop
80102b44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102b48:	8b 0c 95 0c 26 11 80 	mov    -0x7feed9f4(,%edx,4),%ecx
80102b4f:	89 4c 96 04          	mov    %ecx,0x4(%esi,%edx,4)
80102b53:	83 c2 01             	add    $0x1,%edx
80102b56:	39 da                	cmp    %ebx,%edx
80102b58:	75 ee                	jne    80102b48 <write_head+0x38>
80102b5a:	89 3c 24             	mov    %edi,(%esp)
80102b5d:	e8 3e d6 ff ff       	call   801001a0 <bwrite>
80102b62:	89 3c 24             	mov    %edi,(%esp)
80102b65:	e8 76 d6 ff ff       	call   801001e0 <brelse>
80102b6a:	83 c4 1c             	add    $0x1c,%esp
80102b6d:	5b                   	pop    %ebx
80102b6e:	5e                   	pop    %esi
80102b6f:	5f                   	pop    %edi
80102b70:	5d                   	pop    %ebp
80102b71:	c3                   	ret    
80102b72:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102b79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102b80 <initlog>:
80102b80:	55                   	push   %ebp
80102b81:	89 e5                	mov    %esp,%ebp
80102b83:	56                   	push   %esi
80102b84:	53                   	push   %ebx
80102b85:	83 ec 30             	sub    $0x30,%esp
80102b88:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102b8b:	c7 44 24 04 6c 74 10 	movl   $0x8010746c,0x4(%esp)
80102b92:	80 
80102b93:	c7 04 24 c0 25 11 80 	movl   $0x801125c0,(%esp)
80102b9a:	e8 41 16 00 00       	call   801041e0 <initlock>
80102b9f:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102ba2:	89 44 24 04          	mov    %eax,0x4(%esp)
80102ba6:	89 1c 24             	mov    %ebx,(%esp)
80102ba9:	e8 f2 e8 ff ff       	call   801014a0 <readsb>
80102bae:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102bb1:	8b 55 e8             	mov    -0x18(%ebp),%edx
80102bb4:	89 1c 24             	mov    %ebx,(%esp)
80102bb7:	89 1d 04 26 11 80    	mov    %ebx,0x80112604
80102bbd:	89 44 24 04          	mov    %eax,0x4(%esp)
80102bc1:	89 15 f8 25 11 80    	mov    %edx,0x801125f8
80102bc7:	a3 f4 25 11 80       	mov    %eax,0x801125f4
80102bcc:	e8 ff d4 ff ff       	call   801000d0 <bread>
80102bd1:	31 d2                	xor    %edx,%edx
80102bd3:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102bd6:	8d 70 5c             	lea    0x5c(%eax),%esi
80102bd9:	85 db                	test   %ebx,%ebx
80102bdb:	89 1d 08 26 11 80    	mov    %ebx,0x80112608
80102be1:	7e 17                	jle    80102bfa <initlog+0x7a>
80102be3:	90                   	nop
80102be4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102be8:	8b 4c 96 04          	mov    0x4(%esi,%edx,4),%ecx
80102bec:	89 0c 95 0c 26 11 80 	mov    %ecx,-0x7feed9f4(,%edx,4)
80102bf3:	83 c2 01             	add    $0x1,%edx
80102bf6:	39 da                	cmp    %ebx,%edx
80102bf8:	75 ee                	jne    80102be8 <initlog+0x68>
80102bfa:	89 04 24             	mov    %eax,(%esp)
80102bfd:	e8 de d5 ff ff       	call   801001e0 <brelse>
80102c02:	a1 08 26 11 80       	mov    0x80112608,%eax
80102c07:	c7 04 24 70 74 10 80 	movl   $0x80107470,(%esp)
80102c0e:	89 44 24 04          	mov    %eax,0x4(%esp)
80102c12:	e8 39 da ff ff       	call   80100650 <cprintf>
80102c17:	e8 44 fe ff ff       	call   80102a60 <install_trans>
80102c1c:	c7 05 08 26 11 80 00 	movl   $0x0,0x80112608
80102c23:	00 00 00 
80102c26:	e8 e5 fe ff ff       	call   80102b10 <write_head>
80102c2b:	83 c4 30             	add    $0x30,%esp
80102c2e:	5b                   	pop    %ebx
80102c2f:	5e                   	pop    %esi
80102c30:	5d                   	pop    %ebp
80102c31:	c3                   	ret    
80102c32:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102c39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102c40 <begin_op>:
80102c40:	55                   	push   %ebp
80102c41:	89 e5                	mov    %esp,%ebp
80102c43:	83 ec 18             	sub    $0x18,%esp
80102c46:	c7 04 24 c0 25 11 80 	movl   $0x801125c0,(%esp)
80102c4d:	e8 7e 16 00 00       	call   801042d0 <acquire>
80102c52:	eb 18                	jmp    80102c6c <begin_op+0x2c>
80102c54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c58:	c7 44 24 04 c0 25 11 	movl   $0x801125c0,0x4(%esp)
80102c5f:	80 
80102c60:	c7 04 24 c0 25 11 80 	movl   $0x801125c0,(%esp)
80102c67:	e8 04 11 00 00       	call   80103d70 <sleep>
80102c6c:	8b 15 00 26 11 80    	mov    0x80112600,%edx
80102c72:	85 d2                	test   %edx,%edx
80102c74:	75 e2                	jne    80102c58 <begin_op+0x18>
80102c76:	a1 fc 25 11 80       	mov    0x801125fc,%eax
80102c7b:	8b 15 08 26 11 80    	mov    0x80112608,%edx
80102c81:	83 c0 01             	add    $0x1,%eax
80102c84:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102c87:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102c8a:	83 fa 1e             	cmp    $0x1e,%edx
80102c8d:	7f c9                	jg     80102c58 <begin_op+0x18>
80102c8f:	c7 04 24 c0 25 11 80 	movl   $0x801125c0,(%esp)
80102c96:	a3 fc 25 11 80       	mov    %eax,0x801125fc
80102c9b:	e8 20 17 00 00       	call   801043c0 <release>
80102ca0:	c9                   	leave  
80102ca1:	c3                   	ret    
80102ca2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102ca9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102cb0 <end_op>:
80102cb0:	55                   	push   %ebp
80102cb1:	89 e5                	mov    %esp,%ebp
80102cb3:	57                   	push   %edi
80102cb4:	56                   	push   %esi
80102cb5:	53                   	push   %ebx
80102cb6:	83 ec 1c             	sub    $0x1c,%esp
80102cb9:	c7 04 24 c0 25 11 80 	movl   $0x801125c0,(%esp)
80102cc0:	e8 0b 16 00 00       	call   801042d0 <acquire>
80102cc5:	a1 fc 25 11 80       	mov    0x801125fc,%eax
80102cca:	8b 1d 00 26 11 80    	mov    0x80112600,%ebx
80102cd0:	83 e8 01             	sub    $0x1,%eax
80102cd3:	85 db                	test   %ebx,%ebx
80102cd5:	a3 fc 25 11 80       	mov    %eax,0x801125fc
80102cda:	0f 85 0b 01 00 00    	jne    80102deb <end_op+0x13b>
80102ce0:	85 c0                	test   %eax,%eax
80102ce2:	0f 85 e3 00 00 00    	jne    80102dcb <end_op+0x11b>
80102ce8:	c7 04 24 c0 25 11 80 	movl   $0x801125c0,(%esp)
80102cef:	c7 05 00 26 11 80 01 	movl   $0x1,0x80112600
80102cf6:	00 00 00 
80102cf9:	e8 c2 16 00 00       	call   801043c0 <release>
80102cfe:	a1 08 26 11 80       	mov    0x80112608,%eax
80102d03:	85 c0                	test   %eax,%eax
80102d05:	0f 8e aa 00 00 00    	jle    80102db5 <end_op+0x105>
80102d0b:	89 44 24 04          	mov    %eax,0x4(%esp)
80102d0f:	31 db                	xor    %ebx,%ebx
80102d11:	c7 04 24 9c 74 10 80 	movl   $0x8010749c,(%esp)
80102d18:	e8 33 d9 ff ff       	call   80100650 <cprintf>
80102d1d:	8b 0d 08 26 11 80    	mov    0x80112608,%ecx
80102d23:	85 c9                	test   %ecx,%ecx
80102d25:	7e 75                	jle    80102d9c <end_op+0xec>
80102d27:	90                   	nop
80102d28:	a1 f4 25 11 80       	mov    0x801125f4,%eax
80102d2d:	01 d8                	add    %ebx,%eax
80102d2f:	83 c0 01             	add    $0x1,%eax
80102d32:	89 44 24 04          	mov    %eax,0x4(%esp)
80102d36:	a1 04 26 11 80       	mov    0x80112604,%eax
80102d3b:	89 04 24             	mov    %eax,(%esp)
80102d3e:	e8 8d d3 ff ff       	call   801000d0 <bread>
80102d43:	89 c6                	mov    %eax,%esi
80102d45:	8b 04 9d 0c 26 11 80 	mov    -0x7feed9f4(,%ebx,4),%eax
80102d4c:	83 c3 01             	add    $0x1,%ebx
80102d4f:	89 44 24 04          	mov    %eax,0x4(%esp)
80102d53:	a1 04 26 11 80       	mov    0x80112604,%eax
80102d58:	89 04 24             	mov    %eax,(%esp)
80102d5b:	e8 70 d3 ff ff       	call   801000d0 <bread>
80102d60:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80102d67:	00 
80102d68:	89 c7                	mov    %eax,%edi
80102d6a:	8d 40 5c             	lea    0x5c(%eax),%eax
80102d6d:	89 44 24 04          	mov    %eax,0x4(%esp)
80102d71:	8d 46 5c             	lea    0x5c(%esi),%eax
80102d74:	89 04 24             	mov    %eax,(%esp)
80102d77:	e8 34 17 00 00       	call   801044b0 <memmove>
80102d7c:	89 34 24             	mov    %esi,(%esp)
80102d7f:	e8 1c d4 ff ff       	call   801001a0 <bwrite>
80102d84:	89 3c 24             	mov    %edi,(%esp)
80102d87:	e8 54 d4 ff ff       	call   801001e0 <brelse>
80102d8c:	89 34 24             	mov    %esi,(%esp)
80102d8f:	e8 4c d4 ff ff       	call   801001e0 <brelse>
80102d94:	3b 1d 08 26 11 80    	cmp    0x80112608,%ebx
80102d9a:	7c 8c                	jl     80102d28 <end_op+0x78>
80102d9c:	e8 6f fd ff ff       	call   80102b10 <write_head>
80102da1:	e8 ba fc ff ff       	call   80102a60 <install_trans>
80102da6:	c7 05 08 26 11 80 00 	movl   $0x0,0x80112608
80102dad:	00 00 00 
80102db0:	e8 5b fd ff ff       	call   80102b10 <write_head>
80102db5:	c7 04 24 c0 25 11 80 	movl   $0x801125c0,(%esp)
80102dbc:	e8 0f 15 00 00       	call   801042d0 <acquire>
80102dc1:	c7 05 00 26 11 80 00 	movl   $0x0,0x80112600
80102dc8:	00 00 00 
80102dcb:	c7 04 24 c0 25 11 80 	movl   $0x801125c0,(%esp)
80102dd2:	e8 39 11 00 00       	call   80103f10 <wakeup>
80102dd7:	c7 04 24 c0 25 11 80 	movl   $0x801125c0,(%esp)
80102dde:	e8 dd 15 00 00       	call   801043c0 <release>
80102de3:	83 c4 1c             	add    $0x1c,%esp
80102de6:	5b                   	pop    %ebx
80102de7:	5e                   	pop    %esi
80102de8:	5f                   	pop    %edi
80102de9:	5d                   	pop    %ebp
80102dea:	c3                   	ret    
80102deb:	c7 04 24 8d 74 10 80 	movl   $0x8010748d,(%esp)
80102df2:	e8 69 d5 ff ff       	call   80100360 <panic>
80102df7:	89 f6                	mov    %esi,%esi
80102df9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102e00 <log_write>:
80102e00:	55                   	push   %ebp
80102e01:	89 e5                	mov    %esp,%ebp
80102e03:	53                   	push   %ebx
80102e04:	83 ec 14             	sub    $0x14,%esp
80102e07:	a1 08 26 11 80       	mov    0x80112608,%eax
80102e0c:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102e0f:	83 f8 1d             	cmp    $0x1d,%eax
80102e12:	0f 8f 98 00 00 00    	jg     80102eb0 <log_write+0xb0>
80102e18:	8b 0d f8 25 11 80    	mov    0x801125f8,%ecx
80102e1e:	8d 51 ff             	lea    -0x1(%ecx),%edx
80102e21:	39 d0                	cmp    %edx,%eax
80102e23:	0f 8d 87 00 00 00    	jge    80102eb0 <log_write+0xb0>
80102e29:	a1 fc 25 11 80       	mov    0x801125fc,%eax
80102e2e:	85 c0                	test   %eax,%eax
80102e30:	0f 8e 86 00 00 00    	jle    80102ebc <log_write+0xbc>
80102e36:	c7 04 24 c0 25 11 80 	movl   $0x801125c0,(%esp)
80102e3d:	e8 8e 14 00 00       	call   801042d0 <acquire>
80102e42:	8b 15 08 26 11 80    	mov    0x80112608,%edx
80102e48:	83 fa 00             	cmp    $0x0,%edx
80102e4b:	7e 54                	jle    80102ea1 <log_write+0xa1>
80102e4d:	8b 4b 08             	mov    0x8(%ebx),%ecx
80102e50:	31 c0                	xor    %eax,%eax
80102e52:	39 0d 0c 26 11 80    	cmp    %ecx,0x8011260c
80102e58:	75 0f                	jne    80102e69 <log_write+0x69>
80102e5a:	eb 3c                	jmp    80102e98 <log_write+0x98>
80102e5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102e60:	39 0c 85 0c 26 11 80 	cmp    %ecx,-0x7feed9f4(,%eax,4)
80102e67:	74 2f                	je     80102e98 <log_write+0x98>
80102e69:	83 c0 01             	add    $0x1,%eax
80102e6c:	39 d0                	cmp    %edx,%eax
80102e6e:	75 f0                	jne    80102e60 <log_write+0x60>
80102e70:	89 0c 95 0c 26 11 80 	mov    %ecx,-0x7feed9f4(,%edx,4)
80102e77:	83 c2 01             	add    $0x1,%edx
80102e7a:	89 15 08 26 11 80    	mov    %edx,0x80112608
80102e80:	83 0b 04             	orl    $0x4,(%ebx)
80102e83:	c7 45 08 c0 25 11 80 	movl   $0x801125c0,0x8(%ebp)
80102e8a:	83 c4 14             	add    $0x14,%esp
80102e8d:	5b                   	pop    %ebx
80102e8e:	5d                   	pop    %ebp
80102e8f:	e9 2c 15 00 00       	jmp    801043c0 <release>
80102e94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102e98:	89 0c 85 0c 26 11 80 	mov    %ecx,-0x7feed9f4(,%eax,4)
80102e9f:	eb df                	jmp    80102e80 <log_write+0x80>
80102ea1:	8b 43 08             	mov    0x8(%ebx),%eax
80102ea4:	a3 0c 26 11 80       	mov    %eax,0x8011260c
80102ea9:	75 d5                	jne    80102e80 <log_write+0x80>
80102eab:	eb ca                	jmp    80102e77 <log_write+0x77>
80102ead:	8d 76 00             	lea    0x0(%esi),%esi
80102eb0:	c7 04 24 ab 74 10 80 	movl   $0x801074ab,(%esp)
80102eb7:	e8 a4 d4 ff ff       	call   80100360 <panic>
80102ebc:	c7 04 24 c1 74 10 80 	movl   $0x801074c1,(%esp)
80102ec3:	e8 98 d4 ff ff       	call   80100360 <panic>
	...

80102ed0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102ed0:	55                   	push   %ebp
80102ed1:	89 e5                	mov    %esp,%ebp
80102ed3:	53                   	push   %ebx
80102ed4:	83 ec 14             	sub    $0x14,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102ed7:	e8 04 09 00 00       	call   801037e0 <cpuid>
80102edc:	89 c3                	mov    %eax,%ebx
80102ede:	e8 fd 08 00 00       	call   801037e0 <cpuid>
80102ee3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80102ee7:	c7 04 24 dc 74 10 80 	movl   $0x801074dc,(%esp)
80102eee:	89 44 24 04          	mov    %eax,0x4(%esp)
80102ef2:	e8 59 d7 ff ff       	call   80100650 <cprintf>
  idtinit();       // load idt register
80102ef7:	e8 24 28 00 00       	call   80105720 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102efc:	e8 5f 08 00 00       	call   80103760 <mycpu>
80102f01:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102f03:	b8 01 00 00 00       	mov    $0x1,%eax
80102f08:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102f0f:	e8 ac 0b 00 00       	call   80103ac0 <scheduler>
80102f14:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102f1a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80102f20 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80102f20:	55                   	push   %ebp
80102f21:	89 e5                	mov    %esp,%ebp
80102f23:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102f26:	e8 c5 39 00 00       	call   801068f0 <switchkvm>
  seginit();
80102f2b:	e8 80 38 00 00       	call   801067b0 <seginit>
  lapicinit();
80102f30:	e8 3b f8 ff ff       	call   80102770 <lapicinit>
  mpmain();
80102f35:	e8 96 ff ff ff       	call   80102ed0 <mpmain>
80102f3a:	00 00                	add    %al,(%eax)
80102f3c:	00 00                	add    %al,(%eax)
	...

80102f40 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80102f40:	55                   	push   %ebp
80102f41:	89 e5                	mov    %esp,%ebp
80102f43:	53                   	push   %ebx
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80102f44:	bb c0 26 11 80       	mov    $0x801126c0,%ebx
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80102f49:	83 e4 f0             	and    $0xfffffff0,%esp
80102f4c:	83 ec 10             	sub    $0x10,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102f4f:	c7 44 24 04 00 00 40 	movl   $0x80400000,0x4(%esp)
80102f56:	80 
80102f57:	c7 04 24 e8 56 11 80 	movl   $0x801156e8,(%esp)
80102f5e:	e8 8d f5 ff ff       	call   801024f0 <kinit1>
  kvmalloc();      // kernel page table
80102f63:	e8 38 3e 00 00       	call   80106da0 <kvmalloc>
  mpinit();        // detect other processors
80102f68:	e8 73 01 00 00       	call   801030e0 <mpinit>
80102f6d:	8d 76 00             	lea    0x0(%esi),%esi
  lapicinit();     // interrupt controller
80102f70:	e8 fb f7 ff ff       	call   80102770 <lapicinit>
  seginit();       // segment descriptors
80102f75:	e8 36 38 00 00       	call   801067b0 <seginit>
  picinit();       // disable pic
80102f7a:	e8 21 03 00 00       	call   801032a0 <picinit>
80102f7f:	90                   	nop
  ioapicinit();    // another interrupt controller
80102f80:	e8 8b f3 ff ff       	call   80102310 <ioapicinit>
  consoleinit();   // console hardware
80102f85:	e8 c6 d9 ff ff       	call   80100950 <consoleinit>
  uartinit();      // serial port
80102f8a:	e8 d1 2b 00 00       	call   80105b60 <uartinit>
80102f8f:	90                   	nop
  pinit();         // process table
80102f90:	e8 ab 07 00 00       	call   80103740 <pinit>
  tvinit();        // trap vectors
80102f95:	e8 e6 26 00 00       	call   80105680 <tvinit>
  binit();         // buffer cache
80102f9a:	e8 a1 d0 ff ff       	call   80100040 <binit>
80102f9f:	90                   	nop
  fileinit();      // file table
80102fa0:	e8 ab dd ff ff       	call   80100d50 <fileinit>
  ideinit();       // disk 
80102fa5:	e8 66 f1 ff ff       	call   80102110 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102faa:	c7 44 24 08 8a 00 00 	movl   $0x8a,0x8(%esp)
80102fb1:	00 
80102fb2:	c7 44 24 04 8c a4 10 	movl   $0x8010a48c,0x4(%esp)
80102fb9:	80 
80102fba:	c7 04 24 00 70 00 80 	movl   $0x80007000,(%esp)
80102fc1:	e8 ea 14 00 00       	call   801044b0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102fc6:	69 05 40 2c 11 80 b0 	imul   $0xb0,0x80112c40,%eax
80102fcd:	00 00 00 
80102fd0:	05 c0 26 11 80       	add    $0x801126c0,%eax
80102fd5:	39 d8                	cmp    %ebx,%eax
80102fd7:	76 6a                	jbe    80103043 <main+0x103>
80102fd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(c == mycpu())  // We've started already.
80102fe0:	e8 7b 07 00 00       	call   80103760 <mycpu>
80102fe5:	39 d8                	cmp    %ebx,%eax
80102fe7:	74 41                	je     8010302a <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102fe9:	e8 c2 f5 ff ff       	call   801025b0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void**)(code-8) = mpenter;
80102fee:	c7 05 f8 6f 00 80 20 	movl   $0x80102f20,0x80006ff8
80102ff5:	2f 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102ff8:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80102fff:	90 10 00 

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
    *(void**)(code-4) = stack + KSTACKSIZE;
80103002:	05 00 10 00 00       	add    $0x1000,%eax
80103007:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    *(void**)(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
8010300c:	0f b6 03             	movzbl (%ebx),%eax
8010300f:	c7 44 24 04 00 70 00 	movl   $0x7000,0x4(%esp)
80103016:	00 
80103017:	89 04 24             	mov    %eax,(%esp)
8010301a:	e8 91 f8 ff ff       	call   801028b0 <lapicstartap>
8010301f:	90                   	nop

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103020:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103026:	85 c0                	test   %eax,%eax
80103028:	74 f6                	je     80103020 <main+0xe0>
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
8010302a:	69 05 40 2c 11 80 b0 	imul   $0xb0,0x80112c40,%eax
80103031:	00 00 00 
80103034:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
8010303a:	05 c0 26 11 80       	add    $0x801126c0,%eax
8010303f:	39 c3                	cmp    %eax,%ebx
80103041:	72 9d                	jb     80102fe0 <main+0xa0>
  tvinit();        // trap vectors
  binit();         // buffer cache
  fileinit();      // file table
  ideinit();       // disk 
  startothers();   // start other processors
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103043:	c7 44 24 04 00 00 00 	movl   $0x8e000000,0x4(%esp)
8010304a:	8e 
8010304b:	c7 04 24 00 00 40 80 	movl   $0x80400000,(%esp)
80103052:	e8 09 f5 ff ff       	call   80102560 <kinit2>
  userinit();      // first user process
80103057:	e8 d4 07 00 00       	call   80103830 <userinit>
  mpmain();        // finish this processor's setup
8010305c:	e8 6f fe ff ff       	call   80102ed0 <mpmain>
	...

80103070 <mpsearch1>:
80103070:	55                   	push   %ebp
80103071:	89 e5                	mov    %esp,%ebp
80103073:	56                   	push   %esi
80103074:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
8010307a:	53                   	push   %ebx
8010307b:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
8010307e:	83 ec 10             	sub    $0x10,%esp
80103081:	39 de                	cmp    %ebx,%esi
80103083:	73 3c                	jae    801030c1 <mpsearch1+0x51>
80103085:	8d 76 00             	lea    0x0(%esi),%esi
80103088:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
8010308f:	00 
80103090:	c7 44 24 04 f0 74 10 	movl   $0x801074f0,0x4(%esp)
80103097:	80 
80103098:	89 34 24             	mov    %esi,(%esp)
8010309b:	e8 c0 13 00 00       	call   80104460 <memcmp>
801030a0:	85 c0                	test   %eax,%eax
801030a2:	75 16                	jne    801030ba <mpsearch1+0x4a>
801030a4:	31 c9                	xor    %ecx,%ecx
801030a6:	31 d2                	xor    %edx,%edx
801030a8:	0f b6 04 16          	movzbl (%esi,%edx,1),%eax
801030ac:	83 c2 01             	add    $0x1,%edx
801030af:	01 c1                	add    %eax,%ecx
801030b1:	83 fa 10             	cmp    $0x10,%edx
801030b4:	75 f2                	jne    801030a8 <mpsearch1+0x38>
801030b6:	84 c9                	test   %cl,%cl
801030b8:	74 10                	je     801030ca <mpsearch1+0x5a>
801030ba:	83 c6 10             	add    $0x10,%esi
801030bd:	39 f3                	cmp    %esi,%ebx
801030bf:	77 c7                	ja     80103088 <mpsearch1+0x18>
801030c1:	83 c4 10             	add    $0x10,%esp
801030c4:	31 c0                	xor    %eax,%eax
801030c6:	5b                   	pop    %ebx
801030c7:	5e                   	pop    %esi
801030c8:	5d                   	pop    %ebp
801030c9:	c3                   	ret    
801030ca:	83 c4 10             	add    $0x10,%esp
801030cd:	89 f0                	mov    %esi,%eax
801030cf:	5b                   	pop    %ebx
801030d0:	5e                   	pop    %esi
801030d1:	5d                   	pop    %ebp
801030d2:	c3                   	ret    
801030d3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801030d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801030e0 <mpinit>:
801030e0:	55                   	push   %ebp
801030e1:	89 e5                	mov    %esp,%ebp
801030e3:	57                   	push   %edi
801030e4:	56                   	push   %esi
801030e5:	53                   	push   %ebx
801030e6:	83 ec 1c             	sub    $0x1c,%esp
801030e9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
801030f0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
801030f7:	c1 e0 08             	shl    $0x8,%eax
801030fa:	09 d0                	or     %edx,%eax
801030fc:	c1 e0 04             	shl    $0x4,%eax
801030ff:	85 c0                	test   %eax,%eax
80103101:	75 1b                	jne    8010311e <mpinit+0x3e>
80103103:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010310a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103111:	c1 e0 08             	shl    $0x8,%eax
80103114:	09 d0                	or     %edx,%eax
80103116:	c1 e0 0a             	shl    $0xa,%eax
80103119:	2d 00 04 00 00       	sub    $0x400,%eax
8010311e:	ba 00 04 00 00       	mov    $0x400,%edx
80103123:	e8 48 ff ff ff       	call   80103070 <mpsearch1>
80103128:	85 c0                	test   %eax,%eax
8010312a:	89 c7                	mov    %eax,%edi
8010312c:	0f 84 22 01 00 00    	je     80103254 <mpinit+0x174>
80103132:	8b 77 04             	mov    0x4(%edi),%esi
80103135:	85 f6                	test   %esi,%esi
80103137:	0f 84 30 01 00 00    	je     8010326d <mpinit+0x18d>
8010313d:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80103143:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
8010314a:	00 
8010314b:	c7 44 24 04 f5 74 10 	movl   $0x801074f5,0x4(%esp)
80103152:	80 
80103153:	89 04 24             	mov    %eax,(%esp)
80103156:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103159:	e8 02 13 00 00       	call   80104460 <memcmp>
8010315e:	85 c0                	test   %eax,%eax
80103160:	0f 85 07 01 00 00    	jne    8010326d <mpinit+0x18d>
80103166:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
8010316d:	3c 04                	cmp    $0x4,%al
8010316f:	0f 85 0b 01 00 00    	jne    80103280 <mpinit+0x1a0>
80103175:	0f b7 86 04 00 00 80 	movzwl -0x7ffffffc(%esi),%eax
8010317c:	85 c0                	test   %eax,%eax
8010317e:	74 21                	je     801031a1 <mpinit+0xc1>
80103180:	31 c9                	xor    %ecx,%ecx
80103182:	31 d2                	xor    %edx,%edx
80103184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103188:	0f b6 9c 16 00 00 00 	movzbl -0x80000000(%esi,%edx,1),%ebx
8010318f:	80 
80103190:	83 c2 01             	add    $0x1,%edx
80103193:	01 d9                	add    %ebx,%ecx
80103195:	39 d0                	cmp    %edx,%eax
80103197:	7f ef                	jg     80103188 <mpinit+0xa8>
80103199:	84 c9                	test   %cl,%cl
8010319b:	0f 85 cc 00 00 00    	jne    8010326d <mpinit+0x18d>
801031a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801031a4:	85 c0                	test   %eax,%eax
801031a6:	0f 84 c1 00 00 00    	je     8010326d <mpinit+0x18d>
801031ac:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
801031b2:	bb 01 00 00 00       	mov    $0x1,%ebx
801031b7:	a3 bc 25 11 80       	mov    %eax,0x801125bc
801031bc:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
801031c3:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
801031c9:	03 55 e4             	add    -0x1c(%ebp),%edx
801031cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801031d0:	39 c2                	cmp    %eax,%edx
801031d2:	76 1b                	jbe    801031ef <mpinit+0x10f>
801031d4:	0f b6 08             	movzbl (%eax),%ecx
801031d7:	80 f9 04             	cmp    $0x4,%cl
801031da:	77 74                	ja     80103250 <mpinit+0x170>
801031dc:	ff 24 8d 34 75 10 80 	jmp    *-0x7fef8acc(,%ecx,4)
801031e3:	90                   	nop
801031e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801031e8:	83 c0 08             	add    $0x8,%eax
801031eb:	39 c2                	cmp    %eax,%edx
801031ed:	77 e5                	ja     801031d4 <mpinit+0xf4>
801031ef:	85 db                	test   %ebx,%ebx
801031f1:	0f 84 93 00 00 00    	je     8010328a <mpinit+0x1aa>
801031f7:	80 7f 0c 00          	cmpb   $0x0,0xc(%edi)
801031fb:	74 12                	je     8010320f <mpinit+0x12f>
801031fd:	ba 22 00 00 00       	mov    $0x22,%edx
80103202:	b8 70 00 00 00       	mov    $0x70,%eax
80103207:	ee                   	out    %al,(%dx)
80103208:	b2 23                	mov    $0x23,%dl
8010320a:	ec                   	in     (%dx),%al
8010320b:	83 c8 01             	or     $0x1,%eax
8010320e:	ee                   	out    %al,(%dx)
8010320f:	83 c4 1c             	add    $0x1c,%esp
80103212:	5b                   	pop    %ebx
80103213:	5e                   	pop    %esi
80103214:	5f                   	pop    %edi
80103215:	5d                   	pop    %ebp
80103216:	c3                   	ret    
80103217:	90                   	nop
80103218:	8b 35 40 2c 11 80    	mov    0x80112c40,%esi
8010321e:	83 fe 07             	cmp    $0x7,%esi
80103221:	7f 17                	jg     8010323a <mpinit+0x15a>
80103223:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
80103227:	69 f6 b0 00 00 00    	imul   $0xb0,%esi,%esi
8010322d:	83 05 40 2c 11 80 01 	addl   $0x1,0x80112c40
80103234:	88 8e c0 26 11 80    	mov    %cl,-0x7feed940(%esi)
8010323a:	83 c0 14             	add    $0x14,%eax
8010323d:	eb 91                	jmp    801031d0 <mpinit+0xf0>
8010323f:	90                   	nop
80103240:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
80103244:	83 c0 08             	add    $0x8,%eax
80103247:	88 0d a0 26 11 80    	mov    %cl,0x801126a0
8010324d:	eb 81                	jmp    801031d0 <mpinit+0xf0>
8010324f:	90                   	nop
80103250:	31 db                	xor    %ebx,%ebx
80103252:	eb 83                	jmp    801031d7 <mpinit+0xf7>
80103254:	ba 00 00 01 00       	mov    $0x10000,%edx
80103259:	b8 00 00 0f 00       	mov    $0xf0000,%eax
8010325e:	e8 0d fe ff ff       	call   80103070 <mpsearch1>
80103263:	85 c0                	test   %eax,%eax
80103265:	89 c7                	mov    %eax,%edi
80103267:	0f 85 c5 fe ff ff    	jne    80103132 <mpinit+0x52>
8010326d:	c7 04 24 fa 74 10 80 	movl   $0x801074fa,(%esp)
80103274:	e8 e7 d0 ff ff       	call   80100360 <panic>
80103279:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103280:	3c 01                	cmp    $0x1,%al
80103282:	0f 84 ed fe ff ff    	je     80103175 <mpinit+0x95>
80103288:	eb e3                	jmp    8010326d <mpinit+0x18d>
8010328a:	c7 04 24 14 75 10 80 	movl   $0x80107514,(%esp)
80103291:	e8 ca d0 ff ff       	call   80100360 <panic>
	...

801032a0 <picinit>:
801032a0:	55                   	push   %ebp
801032a1:	ba 21 00 00 00       	mov    $0x21,%edx
801032a6:	89 e5                	mov    %esp,%ebp
801032a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801032ad:	ee                   	out    %al,(%dx)
801032ae:	b2 a1                	mov    $0xa1,%dl
801032b0:	ee                   	out    %al,(%dx)
801032b1:	5d                   	pop    %ebp
801032b2:	c3                   	ret    
	...

801032c0 <pipealloc>:
801032c0:	55                   	push   %ebp
801032c1:	89 e5                	mov    %esp,%ebp
801032c3:	57                   	push   %edi
801032c4:	56                   	push   %esi
801032c5:	53                   	push   %ebx
801032c6:	83 ec 1c             	sub    $0x1c,%esp
801032c9:	8b 75 08             	mov    0x8(%ebp),%esi
801032cc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801032cf:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
801032d5:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801032db:	e8 90 da ff ff       	call   80100d70 <filealloc>
801032e0:	85 c0                	test   %eax,%eax
801032e2:	89 06                	mov    %eax,(%esi)
801032e4:	0f 84 a4 00 00 00    	je     8010338e <pipealloc+0xce>
801032ea:	e8 81 da ff ff       	call   80100d70 <filealloc>
801032ef:	85 c0                	test   %eax,%eax
801032f1:	89 03                	mov    %eax,(%ebx)
801032f3:	0f 84 87 00 00 00    	je     80103380 <pipealloc+0xc0>
801032f9:	e8 b2 f2 ff ff       	call   801025b0 <kalloc>
801032fe:	85 c0                	test   %eax,%eax
80103300:	89 c7                	mov    %eax,%edi
80103302:	74 7c                	je     80103380 <pipealloc+0xc0>
80103304:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010330b:	00 00 00 
8010330e:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103315:	00 00 00 
80103318:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010331f:	00 00 00 
80103322:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103329:	00 00 00 
8010332c:	89 04 24             	mov    %eax,(%esp)
8010332f:	c7 44 24 04 48 75 10 	movl   $0x80107548,0x4(%esp)
80103336:	80 
80103337:	e8 a4 0e 00 00       	call   801041e0 <initlock>
8010333c:	8b 06                	mov    (%esi),%eax
8010333e:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
80103344:	8b 06                	mov    (%esi),%eax
80103346:	c6 40 08 01          	movb   $0x1,0x8(%eax)
8010334a:	8b 06                	mov    (%esi),%eax
8010334c:	c6 40 09 00          	movb   $0x0,0x9(%eax)
80103350:	8b 06                	mov    (%esi),%eax
80103352:	89 78 0c             	mov    %edi,0xc(%eax)
80103355:	8b 03                	mov    (%ebx),%eax
80103357:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
8010335d:	8b 03                	mov    (%ebx),%eax
8010335f:	c6 40 08 00          	movb   $0x0,0x8(%eax)
80103363:	8b 03                	mov    (%ebx),%eax
80103365:	c6 40 09 01          	movb   $0x1,0x9(%eax)
80103369:	8b 03                	mov    (%ebx),%eax
8010336b:	31 db                	xor    %ebx,%ebx
8010336d:	89 78 0c             	mov    %edi,0xc(%eax)
80103370:	83 c4 1c             	add    $0x1c,%esp
80103373:	89 d8                	mov    %ebx,%eax
80103375:	5b                   	pop    %ebx
80103376:	5e                   	pop    %esi
80103377:	5f                   	pop    %edi
80103378:	5d                   	pop    %ebp
80103379:	c3                   	ret    
8010337a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103380:	8b 06                	mov    (%esi),%eax
80103382:	85 c0                	test   %eax,%eax
80103384:	74 08                	je     8010338e <pipealloc+0xce>
80103386:	89 04 24             	mov    %eax,(%esp)
80103389:	e8 a2 da ff ff       	call   80100e30 <fileclose>
8010338e:	8b 03                	mov    (%ebx),%eax
80103390:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103395:	85 c0                	test   %eax,%eax
80103397:	74 d7                	je     80103370 <pipealloc+0xb0>
80103399:	89 04 24             	mov    %eax,(%esp)
8010339c:	e8 8f da ff ff       	call   80100e30 <fileclose>
801033a1:	83 c4 1c             	add    $0x1c,%esp
801033a4:	89 d8                	mov    %ebx,%eax
801033a6:	5b                   	pop    %ebx
801033a7:	5e                   	pop    %esi
801033a8:	5f                   	pop    %edi
801033a9:	5d                   	pop    %ebp
801033aa:	c3                   	ret    
801033ab:	90                   	nop
801033ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801033b0 <pipeclose>:
801033b0:	55                   	push   %ebp
801033b1:	89 e5                	mov    %esp,%ebp
801033b3:	56                   	push   %esi
801033b4:	53                   	push   %ebx
801033b5:	83 ec 10             	sub    $0x10,%esp
801033b8:	8b 5d 08             	mov    0x8(%ebp),%ebx
801033bb:	8b 75 0c             	mov    0xc(%ebp),%esi
801033be:	89 1c 24             	mov    %ebx,(%esp)
801033c1:	e8 0a 0f 00 00       	call   801042d0 <acquire>
801033c6:	85 f6                	test   %esi,%esi
801033c8:	74 3e                	je     80103408 <pipeclose+0x58>
801033ca:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801033d0:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
801033d7:	00 00 00 
801033da:	89 04 24             	mov    %eax,(%esp)
801033dd:	e8 2e 0b 00 00       	call   80103f10 <wakeup>
801033e2:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801033e8:	85 d2                	test   %edx,%edx
801033ea:	75 0a                	jne    801033f6 <pipeclose+0x46>
801033ec:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801033f2:	85 c0                	test   %eax,%eax
801033f4:	74 32                	je     80103428 <pipeclose+0x78>
801033f6:	89 5d 08             	mov    %ebx,0x8(%ebp)
801033f9:	83 c4 10             	add    $0x10,%esp
801033fc:	5b                   	pop    %ebx
801033fd:	5e                   	pop    %esi
801033fe:	5d                   	pop    %ebp
801033ff:	e9 bc 0f 00 00       	jmp    801043c0 <release>
80103404:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103408:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
8010340e:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103415:	00 00 00 
80103418:	89 04 24             	mov    %eax,(%esp)
8010341b:	e8 f0 0a 00 00       	call   80103f10 <wakeup>
80103420:	eb c0                	jmp    801033e2 <pipeclose+0x32>
80103422:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103428:	89 1c 24             	mov    %ebx,(%esp)
8010342b:	e8 90 0f 00 00       	call   801043c0 <release>
80103430:	89 5d 08             	mov    %ebx,0x8(%ebp)
80103433:	83 c4 10             	add    $0x10,%esp
80103436:	5b                   	pop    %ebx
80103437:	5e                   	pop    %esi
80103438:	5d                   	pop    %ebp
80103439:	e9 c2 ef ff ff       	jmp    80102400 <kfree>
8010343e:	66 90                	xchg   %ax,%ax

80103440 <pipewrite>:
80103440:	55                   	push   %ebp
80103441:	89 e5                	mov    %esp,%ebp
80103443:	57                   	push   %edi
80103444:	56                   	push   %esi
80103445:	53                   	push   %ebx
80103446:	83 ec 1c             	sub    $0x1c,%esp
80103449:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010344c:	89 1c 24             	mov    %ebx,(%esp)
8010344f:	e8 7c 0e 00 00       	call   801042d0 <acquire>
80103454:	8b 45 10             	mov    0x10(%ebp),%eax
80103457:	85 c0                	test   %eax,%eax
80103459:	0f 8e b2 00 00 00    	jle    80103511 <pipewrite+0xd1>
8010345f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103462:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
80103468:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
8010346e:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103474:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103477:	03 4d 10             	add    0x10(%ebp),%ecx
8010347a:	89 4d e0             	mov    %ecx,-0x20(%ebp)
8010347d:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
80103483:	81 c1 00 02 00 00    	add    $0x200,%ecx
80103489:	39 c8                	cmp    %ecx,%eax
8010348b:	74 38                	je     801034c5 <pipewrite+0x85>
8010348d:	eb 55                	jmp    801034e4 <pipewrite+0xa4>
8010348f:	90                   	nop
80103490:	e8 6b 03 00 00       	call   80103800 <myproc>
80103495:	8b 48 24             	mov    0x24(%eax),%ecx
80103498:	85 c9                	test   %ecx,%ecx
8010349a:	75 33                	jne    801034cf <pipewrite+0x8f>
8010349c:	89 3c 24             	mov    %edi,(%esp)
8010349f:	e8 6c 0a 00 00       	call   80103f10 <wakeup>
801034a4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801034a8:	89 34 24             	mov    %esi,(%esp)
801034ab:	e8 c0 08 00 00       	call   80103d70 <sleep>
801034b0:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801034b6:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
801034bc:	05 00 02 00 00       	add    $0x200,%eax
801034c1:	39 c2                	cmp    %eax,%edx
801034c3:	75 23                	jne    801034e8 <pipewrite+0xa8>
801034c5:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801034cb:	85 c0                	test   %eax,%eax
801034cd:	75 c1                	jne    80103490 <pipewrite+0x50>
801034cf:	89 1c 24             	mov    %ebx,(%esp)
801034d2:	e8 e9 0e 00 00       	call   801043c0 <release>
801034d7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801034dc:	83 c4 1c             	add    $0x1c,%esp
801034df:	5b                   	pop    %ebx
801034e0:	5e                   	pop    %esi
801034e1:	5f                   	pop    %edi
801034e2:	5d                   	pop    %ebp
801034e3:	c3                   	ret    
801034e4:	89 c2                	mov    %eax,%edx
801034e6:	66 90                	xchg   %ax,%ax
801034e8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801034eb:	8d 42 01             	lea    0x1(%edx),%eax
801034ee:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801034f4:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
801034fa:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
801034fe:	0f b6 09             	movzbl (%ecx),%ecx
80103501:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
80103505:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103508:	3b 4d e0             	cmp    -0x20(%ebp),%ecx
8010350b:	0f 85 6c ff ff ff    	jne    8010347d <pipewrite+0x3d>
80103511:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103517:	89 04 24             	mov    %eax,(%esp)
8010351a:	e8 f1 09 00 00       	call   80103f10 <wakeup>
8010351f:	89 1c 24             	mov    %ebx,(%esp)
80103522:	e8 99 0e 00 00       	call   801043c0 <release>
80103527:	8b 45 10             	mov    0x10(%ebp),%eax
8010352a:	eb b0                	jmp    801034dc <pipewrite+0x9c>
8010352c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103530 <piperead>:
80103530:	55                   	push   %ebp
80103531:	89 e5                	mov    %esp,%ebp
80103533:	57                   	push   %edi
80103534:	56                   	push   %esi
80103535:	53                   	push   %ebx
80103536:	83 ec 1c             	sub    $0x1c,%esp
80103539:	8b 75 08             	mov    0x8(%ebp),%esi
8010353c:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010353f:	89 34 24             	mov    %esi,(%esp)
80103542:	e8 89 0d 00 00       	call   801042d0 <acquire>
80103547:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
8010354d:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103553:	75 5b                	jne    801035b0 <piperead+0x80>
80103555:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
8010355b:	85 db                	test   %ebx,%ebx
8010355d:	74 51                	je     801035b0 <piperead+0x80>
8010355f:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103565:	eb 25                	jmp    8010358c <piperead+0x5c>
80103567:	90                   	nop
80103568:	89 74 24 04          	mov    %esi,0x4(%esp)
8010356c:	89 1c 24             	mov    %ebx,(%esp)
8010356f:	e8 fc 07 00 00       	call   80103d70 <sleep>
80103574:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
8010357a:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103580:	75 2e                	jne    801035b0 <piperead+0x80>
80103582:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103588:	85 d2                	test   %edx,%edx
8010358a:	74 24                	je     801035b0 <piperead+0x80>
8010358c:	e8 6f 02 00 00       	call   80103800 <myproc>
80103591:	8b 48 24             	mov    0x24(%eax),%ecx
80103594:	85 c9                	test   %ecx,%ecx
80103596:	74 d0                	je     80103568 <piperead+0x38>
80103598:	89 34 24             	mov    %esi,(%esp)
8010359b:	e8 20 0e 00 00       	call   801043c0 <release>
801035a0:	83 c4 1c             	add    $0x1c,%esp
801035a3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801035a8:	5b                   	pop    %ebx
801035a9:	5e                   	pop    %esi
801035aa:	5f                   	pop    %edi
801035ab:	5d                   	pop    %ebp
801035ac:	c3                   	ret    
801035ad:	8d 76 00             	lea    0x0(%esi),%esi
801035b0:	8b 55 10             	mov    0x10(%ebp),%edx
801035b3:	31 db                	xor    %ebx,%ebx
801035b5:	85 d2                	test   %edx,%edx
801035b7:	7f 2b                	jg     801035e4 <piperead+0xb4>
801035b9:	eb 31                	jmp    801035ec <piperead+0xbc>
801035bb:	90                   	nop
801035bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801035c0:	8d 48 01             	lea    0x1(%eax),%ecx
801035c3:	25 ff 01 00 00       	and    $0x1ff,%eax
801035c8:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
801035ce:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
801035d3:	88 04 1f             	mov    %al,(%edi,%ebx,1)
801035d6:	83 c3 01             	add    $0x1,%ebx
801035d9:	3b 5d 10             	cmp    0x10(%ebp),%ebx
801035dc:	74 0e                	je     801035ec <piperead+0xbc>
801035de:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801035e4:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
801035ea:	75 d4                	jne    801035c0 <piperead+0x90>
801035ec:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
801035f2:	89 04 24             	mov    %eax,(%esp)
801035f5:	e8 16 09 00 00       	call   80103f10 <wakeup>
801035fa:	89 34 24             	mov    %esi,(%esp)
801035fd:	e8 be 0d 00 00       	call   801043c0 <release>
80103602:	83 c4 1c             	add    $0x1c,%esp
80103605:	89 d8                	mov    %ebx,%eax
80103607:	5b                   	pop    %ebx
80103608:	5e                   	pop    %esi
80103609:	5f                   	pop    %edi
8010360a:	5d                   	pop    %ebp
8010360b:	c3                   	ret    
8010360c:	00 00                	add    %al,(%eax)
	...

80103610 <allocproc>:
80103610:	55                   	push   %ebp
80103611:	89 e5                	mov    %esp,%ebp
80103613:	53                   	push   %ebx
80103614:	bb 94 2c 11 80       	mov    $0x80112c94,%ebx
80103619:	83 ec 14             	sub    $0x14,%esp
8010361c:	c7 04 24 60 2c 11 80 	movl   $0x80112c60,(%esp)
80103623:	e8 a8 0c 00 00       	call   801042d0 <acquire>
80103628:	eb 18                	jmp    80103642 <allocproc+0x32>
8010362a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103630:	81 c3 88 00 00 00    	add    $0x88,%ebx
80103636:	81 fb 94 4e 11 80    	cmp    $0x80114e94,%ebx
8010363c:	0f 84 86 00 00 00    	je     801036c8 <allocproc+0xb8>
80103642:	8b 43 0c             	mov    0xc(%ebx),%eax
80103645:	85 c0                	test   %eax,%eax
80103647:	75 e7                	jne    80103630 <allocproc+0x20>
80103649:	a1 04 a0 10 80       	mov    0x8010a004,%eax
8010364e:	c7 04 24 60 2c 11 80 	movl   $0x80112c60,(%esp)
80103655:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
8010365c:	8d 50 01             	lea    0x1(%eax),%edx
8010365f:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
80103665:	89 43 10             	mov    %eax,0x10(%ebx)
80103668:	e8 53 0d 00 00       	call   801043c0 <release>
8010366d:	e8 3e ef ff ff       	call   801025b0 <kalloc>
80103672:	85 c0                	test   %eax,%eax
80103674:	89 43 08             	mov    %eax,0x8(%ebx)
80103677:	74 63                	je     801036dc <allocproc+0xcc>
80103679:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
8010367f:	05 9c 0f 00 00       	add    $0xf9c,%eax
80103684:	89 53 18             	mov    %edx,0x18(%ebx)
80103687:	c7 40 14 70 56 10 80 	movl   $0x80105670,0x14(%eax)
8010368e:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80103695:	00 
80103696:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010369d:	00 
8010369e:	89 04 24             	mov    %eax,(%esp)
801036a1:	89 43 1c             	mov    %eax,0x1c(%ebx)
801036a4:	e8 67 0d 00 00       	call   80104410 <memset>
801036a9:	8b 43 1c             	mov    0x1c(%ebx),%eax
801036ac:	c7 40 10 f0 36 10 80 	movl   $0x801036f0,0x10(%eax)
801036b3:	89 d8                	mov    %ebx,%eax
801036b5:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
801036bc:	00 00 00 
801036bf:	83 c4 14             	add    $0x14,%esp
801036c2:	5b                   	pop    %ebx
801036c3:	5d                   	pop    %ebp
801036c4:	c3                   	ret    
801036c5:	8d 76 00             	lea    0x0(%esi),%esi
801036c8:	c7 04 24 60 2c 11 80 	movl   $0x80112c60,(%esp)
801036cf:	e8 ec 0c 00 00       	call   801043c0 <release>
801036d4:	83 c4 14             	add    $0x14,%esp
801036d7:	31 c0                	xor    %eax,%eax
801036d9:	5b                   	pop    %ebx
801036da:	5d                   	pop    %ebp
801036db:	c3                   	ret    
801036dc:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
801036e3:	eb da                	jmp    801036bf <allocproc+0xaf>
801036e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801036e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801036f0 <forkret>:
801036f0:	55                   	push   %ebp
801036f1:	89 e5                	mov    %esp,%ebp
801036f3:	83 ec 18             	sub    $0x18,%esp
801036f6:	c7 04 24 60 2c 11 80 	movl   $0x80112c60,(%esp)
801036fd:	e8 be 0c 00 00       	call   801043c0 <release>
80103702:	8b 15 00 a0 10 80    	mov    0x8010a000,%edx
80103708:	85 d2                	test   %edx,%edx
8010370a:	75 04                	jne    80103710 <forkret+0x20>
8010370c:	c9                   	leave  
8010370d:	c3                   	ret    
8010370e:	66 90                	xchg   %ax,%ax
80103710:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103717:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
8010371e:	00 00 00 
80103721:	e8 5a de ff ff       	call   80101580 <iinit>
80103726:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010372d:	e8 4e f4 ff ff       	call   80102b80 <initlog>
80103732:	c9                   	leave  
80103733:	c3                   	ret    
80103734:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010373a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103740 <pinit>:
80103740:	55                   	push   %ebp
80103741:	89 e5                	mov    %esp,%ebp
80103743:	83 ec 18             	sub    $0x18,%esp
80103746:	c7 44 24 04 4d 75 10 	movl   $0x8010754d,0x4(%esp)
8010374d:	80 
8010374e:	c7 04 24 60 2c 11 80 	movl   $0x80112c60,(%esp)
80103755:	e8 86 0a 00 00       	call   801041e0 <initlock>
8010375a:	c9                   	leave  
8010375b:	c3                   	ret    
8010375c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103760 <mycpu>:
80103760:	55                   	push   %ebp
80103761:	89 e5                	mov    %esp,%ebp
80103763:	56                   	push   %esi
80103764:	53                   	push   %ebx
80103765:	83 ec 10             	sub    $0x10,%esp
80103768:	9c                   	pushf  
80103769:	58                   	pop    %eax
8010376a:	f6 c4 02             	test   $0x2,%ah
8010376d:	75 57                	jne    801037c6 <mycpu+0x66>
8010376f:	e8 ec f0 ff ff       	call   80102860 <lapicid>
80103774:	8b 35 40 2c 11 80    	mov    0x80112c40,%esi
8010377a:	85 f6                	test   %esi,%esi
8010377c:	7e 3c                	jle    801037ba <mycpu+0x5a>
8010377e:	0f b6 15 c0 26 11 80 	movzbl 0x801126c0,%edx
80103785:	39 c2                	cmp    %eax,%edx
80103787:	74 2d                	je     801037b6 <mycpu+0x56>
80103789:	b9 70 27 11 80       	mov    $0x80112770,%ecx
8010378e:	31 d2                	xor    %edx,%edx
80103790:	83 c2 01             	add    $0x1,%edx
80103793:	39 f2                	cmp    %esi,%edx
80103795:	74 23                	je     801037ba <mycpu+0x5a>
80103797:	0f b6 19             	movzbl (%ecx),%ebx
8010379a:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
801037a0:	39 c3                	cmp    %eax,%ebx
801037a2:	75 ec                	jne    80103790 <mycpu+0x30>
801037a4:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
801037aa:	83 c4 10             	add    $0x10,%esp
801037ad:	5b                   	pop    %ebx
801037ae:	5e                   	pop    %esi
801037af:	5d                   	pop    %ebp
801037b0:	05 c0 26 11 80       	add    $0x801126c0,%eax
801037b5:	c3                   	ret    
801037b6:	31 d2                	xor    %edx,%edx
801037b8:	eb ea                	jmp    801037a4 <mycpu+0x44>
801037ba:	c7 04 24 54 75 10 80 	movl   $0x80107554,(%esp)
801037c1:	e8 9a cb ff ff       	call   80100360 <panic>
801037c6:	c7 04 24 30 76 10 80 	movl   $0x80107630,(%esp)
801037cd:	e8 8e cb ff ff       	call   80100360 <panic>
801037d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801037d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801037e0 <cpuid>:
801037e0:	55                   	push   %ebp
801037e1:	89 e5                	mov    %esp,%ebp
801037e3:	83 ec 08             	sub    $0x8,%esp
801037e6:	e8 75 ff ff ff       	call   80103760 <mycpu>
801037eb:	c9                   	leave  
801037ec:	2d c0 26 11 80       	sub    $0x801126c0,%eax
801037f1:	c1 f8 04             	sar    $0x4,%eax
801037f4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
801037fa:	c3                   	ret    
801037fb:	90                   	nop
801037fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103800 <myproc>:
80103800:	55                   	push   %ebp
80103801:	89 e5                	mov    %esp,%ebp
80103803:	53                   	push   %ebx
80103804:	83 ec 04             	sub    $0x4,%esp
80103807:	e8 84 0a 00 00       	call   80104290 <pushcli>
8010380c:	e8 4f ff ff ff       	call   80103760 <mycpu>
80103811:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
80103817:	e8 34 0b 00 00       	call   80104350 <popcli>
8010381c:	83 c4 04             	add    $0x4,%esp
8010381f:	89 d8                	mov    %ebx,%eax
80103821:	5b                   	pop    %ebx
80103822:	5d                   	pop    %ebp
80103823:	c3                   	ret    
80103824:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010382a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103830 <userinit>:
80103830:	55                   	push   %ebp
80103831:	89 e5                	mov    %esp,%ebp
80103833:	53                   	push   %ebx
80103834:	83 ec 14             	sub    $0x14,%esp
80103837:	e8 d4 fd ff ff       	call   80103610 <allocproc>
8010383c:	89 c3                	mov    %eax,%ebx
8010383e:	a3 b8 a5 10 80       	mov    %eax,0x8010a5b8
80103843:	e8 c8 34 00 00       	call   80106d10 <setupkvm>
80103848:	85 c0                	test   %eax,%eax
8010384a:	89 43 04             	mov    %eax,0x4(%ebx)
8010384d:	0f 84 d4 00 00 00    	je     80103927 <userinit+0xf7>
80103853:	89 04 24             	mov    %eax,(%esp)
80103856:	c7 44 24 08 2c 00 00 	movl   $0x2c,0x8(%esp)
8010385d:	00 
8010385e:	c7 44 24 04 60 a4 10 	movl   $0x8010a460,0x4(%esp)
80103865:	80 
80103866:	e8 b5 31 00 00       	call   80106a20 <inituvm>
8010386b:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
80103871:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
80103878:	00 
80103879:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80103880:	00 
80103881:	8b 43 18             	mov    0x18(%ebx),%eax
80103884:	89 04 24             	mov    %eax,(%esp)
80103887:	e8 84 0b 00 00       	call   80104410 <memset>
8010388c:	8b 43 18             	mov    0x18(%ebx),%eax
8010388f:	b9 1b 00 00 00       	mov    $0x1b,%ecx
80103894:	ba 23 00 00 00       	mov    $0x23,%edx
80103899:	66 89 48 3c          	mov    %cx,0x3c(%eax)
8010389d:	8b 43 18             	mov    0x18(%ebx),%eax
801038a0:	66 89 50 2c          	mov    %dx,0x2c(%eax)
801038a4:	8b 43 18             	mov    0x18(%ebx),%eax
801038a7:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801038ab:	66 89 50 28          	mov    %dx,0x28(%eax)
801038af:	8b 43 18             	mov    0x18(%ebx),%eax
801038b2:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801038b6:	66 89 50 48          	mov    %dx,0x48(%eax)
801038ba:	8b 43 18             	mov    0x18(%ebx),%eax
801038bd:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
801038c4:	8b 43 18             	mov    0x18(%ebx),%eax
801038c7:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
801038ce:	8b 43 18             	mov    0x18(%ebx),%eax
801038d1:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
801038d8:	8d 43 6c             	lea    0x6c(%ebx),%eax
801038db:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
801038e2:	00 
801038e3:	c7 44 24 04 7d 75 10 	movl   $0x8010757d,0x4(%esp)
801038ea:	80 
801038eb:	89 04 24             	mov    %eax,(%esp)
801038ee:	e8 fd 0c 00 00       	call   801045f0 <safestrcpy>
801038f3:	c7 04 24 86 75 10 80 	movl   $0x80107586,(%esp)
801038fa:	e8 11 e7 ff ff       	call   80102010 <namei>
801038ff:	89 43 68             	mov    %eax,0x68(%ebx)
80103902:	c7 04 24 60 2c 11 80 	movl   $0x80112c60,(%esp)
80103909:	e8 c2 09 00 00       	call   801042d0 <acquire>
8010390e:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
80103915:	c7 04 24 60 2c 11 80 	movl   $0x80112c60,(%esp)
8010391c:	e8 9f 0a 00 00       	call   801043c0 <release>
80103921:	83 c4 14             	add    $0x14,%esp
80103924:	5b                   	pop    %ebx
80103925:	5d                   	pop    %ebp
80103926:	c3                   	ret    
80103927:	c7 04 24 64 75 10 80 	movl   $0x80107564,(%esp)
8010392e:	e8 2d ca ff ff       	call   80100360 <panic>
80103933:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103939:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103940 <growproc>:
80103940:	55                   	push   %ebp
80103941:	89 e5                	mov    %esp,%ebp
80103943:	56                   	push   %esi
80103944:	53                   	push   %ebx
80103945:	83 ec 10             	sub    $0x10,%esp
80103948:	8b 75 08             	mov    0x8(%ebp),%esi
8010394b:	e8 b0 fe ff ff       	call   80103800 <myproc>
80103950:	83 fe 00             	cmp    $0x0,%esi
80103953:	89 c3                	mov    %eax,%ebx
80103955:	8b 00                	mov    (%eax),%eax
80103957:	7e 2f                	jle    80103988 <growproc+0x48>
80103959:	01 c6                	add    %eax,%esi
8010395b:	89 74 24 08          	mov    %esi,0x8(%esp)
8010395f:	89 44 24 04          	mov    %eax,0x4(%esp)
80103963:	8b 43 04             	mov    0x4(%ebx),%eax
80103966:	89 04 24             	mov    %eax,(%esp)
80103969:	e8 02 32 00 00       	call   80106b70 <allocuvm>
8010396e:	85 c0                	test   %eax,%eax
80103970:	74 36                	je     801039a8 <growproc+0x68>
80103972:	89 03                	mov    %eax,(%ebx)
80103974:	89 1c 24             	mov    %ebx,(%esp)
80103977:	e8 94 2f 00 00       	call   80106910 <switchuvm>
8010397c:	31 c0                	xor    %eax,%eax
8010397e:	83 c4 10             	add    $0x10,%esp
80103981:	5b                   	pop    %ebx
80103982:	5e                   	pop    %esi
80103983:	5d                   	pop    %ebp
80103984:	c3                   	ret    
80103985:	8d 76 00             	lea    0x0(%esi),%esi
80103988:	74 e8                	je     80103972 <growproc+0x32>
8010398a:	01 c6                	add    %eax,%esi
8010398c:	89 74 24 08          	mov    %esi,0x8(%esp)
80103990:	89 44 24 04          	mov    %eax,0x4(%esp)
80103994:	8b 43 04             	mov    0x4(%ebx),%eax
80103997:	89 04 24             	mov    %eax,(%esp)
8010399a:	e8 d1 32 00 00       	call   80106c70 <deallocuvm>
8010399f:	85 c0                	test   %eax,%eax
801039a1:	75 cf                	jne    80103972 <growproc+0x32>
801039a3:	90                   	nop
801039a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801039a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801039ad:	eb cf                	jmp    8010397e <growproc+0x3e>
801039af:	90                   	nop

801039b0 <fork>:
801039b0:	55                   	push   %ebp
801039b1:	89 e5                	mov    %esp,%ebp
801039b3:	57                   	push   %edi
801039b4:	56                   	push   %esi
801039b5:	53                   	push   %ebx
801039b6:	83 ec 1c             	sub    $0x1c,%esp
801039b9:	e8 42 fe ff ff       	call   80103800 <myproc>
801039be:	89 c3                	mov    %eax,%ebx
801039c0:	e8 4b fc ff ff       	call   80103610 <allocproc>
801039c5:	85 c0                	test   %eax,%eax
801039c7:	89 c7                	mov    %eax,%edi
801039c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801039cc:	0f 84 bc 00 00 00    	je     80103a8e <fork+0xde>
801039d2:	8b 03                	mov    (%ebx),%eax
801039d4:	89 44 24 04          	mov    %eax,0x4(%esp)
801039d8:	8b 43 04             	mov    0x4(%ebx),%eax
801039db:	89 04 24             	mov    %eax,(%esp)
801039de:	e8 0d 34 00 00       	call   80106df0 <copyuvm>
801039e3:	85 c0                	test   %eax,%eax
801039e5:	89 47 04             	mov    %eax,0x4(%edi)
801039e8:	0f 84 a7 00 00 00    	je     80103a95 <fork+0xe5>
801039ee:	8b 03                	mov    (%ebx),%eax
801039f0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801039f3:	89 01                	mov    %eax,(%ecx)
801039f5:	8b 79 18             	mov    0x18(%ecx),%edi
801039f8:	89 c8                	mov    %ecx,%eax
801039fa:	89 59 14             	mov    %ebx,0x14(%ecx)
801039fd:	8b 73 18             	mov    0x18(%ebx),%esi
80103a00:	b9 13 00 00 00       	mov    $0x13,%ecx
80103a05:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
80103a07:	31 f6                	xor    %esi,%esi
80103a09:	8b 40 18             	mov    0x18(%eax),%eax
80103a0c:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
80103a13:	90                   	nop
80103a14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103a18:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103a1c:	85 c0                	test   %eax,%eax
80103a1e:	74 0f                	je     80103a2f <fork+0x7f>
80103a20:	89 04 24             	mov    %eax,(%esp)
80103a23:	e8 b8 d3 ff ff       	call   80100de0 <filedup>
80103a28:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103a2b:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
80103a2f:	83 c6 01             	add    $0x1,%esi
80103a32:	83 fe 10             	cmp    $0x10,%esi
80103a35:	75 e1                	jne    80103a18 <fork+0x68>
80103a37:	8b 43 68             	mov    0x68(%ebx),%eax
80103a3a:	83 c3 6c             	add    $0x6c,%ebx
80103a3d:	89 04 24             	mov    %eax,(%esp)
80103a40:	e8 4b dd ff ff       	call   80101790 <idup>
80103a45:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103a48:	89 47 68             	mov    %eax,0x68(%edi)
80103a4b:	8d 47 6c             	lea    0x6c(%edi),%eax
80103a4e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80103a52:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80103a59:	00 
80103a5a:	89 04 24             	mov    %eax,(%esp)
80103a5d:	e8 8e 0b 00 00       	call   801045f0 <safestrcpy>
80103a62:	8b 5f 10             	mov    0x10(%edi),%ebx
80103a65:	c7 04 24 60 2c 11 80 	movl   $0x80112c60,(%esp)
80103a6c:	e8 5f 08 00 00       	call   801042d0 <acquire>
80103a71:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
80103a78:	c7 04 24 60 2c 11 80 	movl   $0x80112c60,(%esp)
80103a7f:	e8 3c 09 00 00       	call   801043c0 <release>
80103a84:	89 d8                	mov    %ebx,%eax
80103a86:	83 c4 1c             	add    $0x1c,%esp
80103a89:	5b                   	pop    %ebx
80103a8a:	5e                   	pop    %esi
80103a8b:	5f                   	pop    %edi
80103a8c:	5d                   	pop    %ebp
80103a8d:	c3                   	ret    
80103a8e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103a93:	eb f1                	jmp    80103a86 <fork+0xd6>
80103a95:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103a98:	8b 47 08             	mov    0x8(%edi),%eax
80103a9b:	89 04 24             	mov    %eax,(%esp)
80103a9e:	e8 5d e9 ff ff       	call   80102400 <kfree>
80103aa3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103aa8:	c7 47 08 00 00 00 00 	movl   $0x0,0x8(%edi)
80103aaf:	c7 47 0c 00 00 00 00 	movl   $0x0,0xc(%edi)
80103ab6:	eb ce                	jmp    80103a86 <fork+0xd6>
80103ab8:	90                   	nop
80103ab9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103ac0 <scheduler>:
80103ac0:	55                   	push   %ebp
80103ac1:	89 e5                	mov    %esp,%ebp
80103ac3:	57                   	push   %edi
80103ac4:	56                   	push   %esi
80103ac5:	53                   	push   %ebx
80103ac6:	83 ec 1c             	sub    $0x1c,%esp
80103ac9:	e8 92 fc ff ff       	call   80103760 <mycpu>
80103ace:	89 c6                	mov    %eax,%esi
80103ad0:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103ad7:	00 00 00 
80103ada:	8d 78 04             	lea    0x4(%eax),%edi
80103add:	8d 76 00             	lea    0x0(%esi),%esi
80103ae0:	fb                   	sti    
80103ae1:	c7 04 24 60 2c 11 80 	movl   $0x80112c60,(%esp)
80103ae8:	bb 94 2c 11 80       	mov    $0x80112c94,%ebx
80103aed:	e8 de 07 00 00       	call   801042d0 <acquire>
80103af2:	eb 12                	jmp    80103b06 <scheduler+0x46>
80103af4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103af8:	81 c3 88 00 00 00    	add    $0x88,%ebx
80103afe:	81 fb 94 4e 11 80    	cmp    $0x80114e94,%ebx
80103b04:	74 4a                	je     80103b50 <scheduler+0x90>
80103b06:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103b0a:	75 ec                	jne    80103af8 <scheduler+0x38>
80103b0c:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
80103b12:	89 1c 24             	mov    %ebx,(%esp)
80103b15:	81 c3 88 00 00 00    	add    $0x88,%ebx
80103b1b:	e8 f0 2d 00 00       	call   80106910 <switchuvm>
80103b20:	8b 43 94             	mov    -0x6c(%ebx),%eax
80103b23:	c7 43 84 04 00 00 00 	movl   $0x4,-0x7c(%ebx)
80103b2a:	89 3c 24             	mov    %edi,(%esp)
80103b2d:	89 44 24 04          	mov    %eax,0x4(%esp)
80103b31:	e8 16 0b 00 00       	call   8010464c <swtch>
80103b36:	e8 b5 2d 00 00       	call   801068f0 <switchkvm>
80103b3b:	81 fb 94 4e 11 80    	cmp    $0x80114e94,%ebx
80103b41:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103b48:	00 00 00 
80103b4b:	75 b9                	jne    80103b06 <scheduler+0x46>
80103b4d:	8d 76 00             	lea    0x0(%esi),%esi
80103b50:	c7 04 24 60 2c 11 80 	movl   $0x80112c60,(%esp)
80103b57:	e8 64 08 00 00       	call   801043c0 <release>
80103b5c:	eb 82                	jmp    80103ae0 <scheduler+0x20>
80103b5e:	66 90                	xchg   %ax,%ax

80103b60 <sched>:
80103b60:	55                   	push   %ebp
80103b61:	89 e5                	mov    %esp,%ebp
80103b63:	56                   	push   %esi
80103b64:	53                   	push   %ebx
80103b65:	83 ec 10             	sub    $0x10,%esp
80103b68:	e8 93 fc ff ff       	call   80103800 <myproc>
80103b6d:	c7 04 24 60 2c 11 80 	movl   $0x80112c60,(%esp)
80103b74:	89 c3                	mov    %eax,%ebx
80103b76:	e8 e5 06 00 00       	call   80104260 <holding>
80103b7b:	85 c0                	test   %eax,%eax
80103b7d:	74 4f                	je     80103bce <sched+0x6e>
80103b7f:	e8 dc fb ff ff       	call   80103760 <mycpu>
80103b84:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103b8b:	75 65                	jne    80103bf2 <sched+0x92>
80103b8d:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103b91:	74 53                	je     80103be6 <sched+0x86>
80103b93:	9c                   	pushf  
80103b94:	58                   	pop    %eax
80103b95:	f6 c4 02             	test   $0x2,%ah
80103b98:	75 40                	jne    80103bda <sched+0x7a>
80103b9a:	e8 c1 fb ff ff       	call   80103760 <mycpu>
80103b9f:	83 c3 1c             	add    $0x1c,%ebx
80103ba2:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
80103ba8:	e8 b3 fb ff ff       	call   80103760 <mycpu>
80103bad:	8b 40 04             	mov    0x4(%eax),%eax
80103bb0:	89 1c 24             	mov    %ebx,(%esp)
80103bb3:	89 44 24 04          	mov    %eax,0x4(%esp)
80103bb7:	e8 90 0a 00 00       	call   8010464c <swtch>
80103bbc:	e8 9f fb ff ff       	call   80103760 <mycpu>
80103bc1:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
80103bc7:	83 c4 10             	add    $0x10,%esp
80103bca:	5b                   	pop    %ebx
80103bcb:	5e                   	pop    %esi
80103bcc:	5d                   	pop    %ebp
80103bcd:	c3                   	ret    
80103bce:	c7 04 24 88 75 10 80 	movl   $0x80107588,(%esp)
80103bd5:	e8 86 c7 ff ff       	call   80100360 <panic>
80103bda:	c7 04 24 b4 75 10 80 	movl   $0x801075b4,(%esp)
80103be1:	e8 7a c7 ff ff       	call   80100360 <panic>
80103be6:	c7 04 24 a6 75 10 80 	movl   $0x801075a6,(%esp)
80103bed:	e8 6e c7 ff ff       	call   80100360 <panic>
80103bf2:	c7 04 24 9a 75 10 80 	movl   $0x8010759a,(%esp)
80103bf9:	e8 62 c7 ff ff       	call   80100360 <panic>
80103bfe:	66 90                	xchg   %ax,%ax

80103c00 <exit>:
80103c00:	55                   	push   %ebp
80103c01:	89 e5                	mov    %esp,%ebp
80103c03:	56                   	push   %esi
80103c04:	31 f6                	xor    %esi,%esi
80103c06:	53                   	push   %ebx
80103c07:	83 ec 10             	sub    $0x10,%esp
80103c0a:	e8 f1 fb ff ff       	call   80103800 <myproc>
80103c0f:	3b 05 b8 a5 10 80    	cmp    0x8010a5b8,%eax
80103c15:	89 c3                	mov    %eax,%ebx
80103c17:	0f 84 fd 00 00 00    	je     80103d1a <exit+0x11a>
80103c1d:	8d 76 00             	lea    0x0(%esi),%esi
80103c20:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103c24:	85 c0                	test   %eax,%eax
80103c26:	74 10                	je     80103c38 <exit+0x38>
80103c28:	89 04 24             	mov    %eax,(%esp)
80103c2b:	e8 00 d2 ff ff       	call   80100e30 <fileclose>
80103c30:	c7 44 b3 28 00 00 00 	movl   $0x0,0x28(%ebx,%esi,4)
80103c37:	00 
80103c38:	83 c6 01             	add    $0x1,%esi
80103c3b:	83 fe 10             	cmp    $0x10,%esi
80103c3e:	75 e0                	jne    80103c20 <exit+0x20>
80103c40:	e8 fb ef ff ff       	call   80102c40 <begin_op>
80103c45:	8b 43 68             	mov    0x68(%ebx),%eax
80103c48:	89 04 24             	mov    %eax,(%esp)
80103c4b:	e8 90 dc ff ff       	call   801018e0 <iput>
80103c50:	e8 5b f0 ff ff       	call   80102cb0 <end_op>
80103c55:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
80103c5c:	c7 04 24 60 2c 11 80 	movl   $0x80112c60,(%esp)
80103c63:	e8 68 06 00 00       	call   801042d0 <acquire>
80103c68:	8b 43 14             	mov    0x14(%ebx),%eax
80103c6b:	ba 94 2c 11 80       	mov    $0x80112c94,%edx
80103c70:	eb 14                	jmp    80103c86 <exit+0x86>
80103c72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103c78:	81 c2 88 00 00 00    	add    $0x88,%edx
80103c7e:	81 fa 94 4e 11 80    	cmp    $0x80114e94,%edx
80103c84:	74 20                	je     80103ca6 <exit+0xa6>
80103c86:	83 7a 0c 02          	cmpl   $0x2,0xc(%edx)
80103c8a:	75 ec                	jne    80103c78 <exit+0x78>
80103c8c:	3b 42 20             	cmp    0x20(%edx),%eax
80103c8f:	75 e7                	jne    80103c78 <exit+0x78>
80103c91:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
80103c98:	81 c2 88 00 00 00    	add    $0x88,%edx
80103c9e:	81 fa 94 4e 11 80    	cmp    $0x80114e94,%edx
80103ca4:	75 e0                	jne    80103c86 <exit+0x86>
80103ca6:	a1 b8 a5 10 80       	mov    0x8010a5b8,%eax
80103cab:	b9 94 2c 11 80       	mov    $0x80112c94,%ecx
80103cb0:	eb 14                	jmp    80103cc6 <exit+0xc6>
80103cb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103cb8:	81 c1 88 00 00 00    	add    $0x88,%ecx
80103cbe:	81 f9 94 4e 11 80    	cmp    $0x80114e94,%ecx
80103cc4:	74 3c                	je     80103d02 <exit+0x102>
80103cc6:	39 59 14             	cmp    %ebx,0x14(%ecx)
80103cc9:	75 ed                	jne    80103cb8 <exit+0xb8>
80103ccb:	83 79 0c 05          	cmpl   $0x5,0xc(%ecx)
80103ccf:	89 41 14             	mov    %eax,0x14(%ecx)
80103cd2:	75 e4                	jne    80103cb8 <exit+0xb8>
80103cd4:	ba 94 2c 11 80       	mov    $0x80112c94,%edx
80103cd9:	eb 13                	jmp    80103cee <exit+0xee>
80103cdb:	90                   	nop
80103cdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103ce0:	81 c2 88 00 00 00    	add    $0x88,%edx
80103ce6:	81 fa 94 4e 11 80    	cmp    $0x80114e94,%edx
80103cec:	74 ca                	je     80103cb8 <exit+0xb8>
80103cee:	83 7a 0c 02          	cmpl   $0x2,0xc(%edx)
80103cf2:	75 ec                	jne    80103ce0 <exit+0xe0>
80103cf4:	3b 42 20             	cmp    0x20(%edx),%eax
80103cf7:	75 e7                	jne    80103ce0 <exit+0xe0>
80103cf9:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
80103d00:	eb de                	jmp    80103ce0 <exit+0xe0>
80103d02:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
80103d09:	e8 52 fe ff ff       	call   80103b60 <sched>
80103d0e:	c7 04 24 d5 75 10 80 	movl   $0x801075d5,(%esp)
80103d15:	e8 46 c6 ff ff       	call   80100360 <panic>
80103d1a:	c7 04 24 c8 75 10 80 	movl   $0x801075c8,(%esp)
80103d21:	e8 3a c6 ff ff       	call   80100360 <panic>
80103d26:	8d 76 00             	lea    0x0(%esi),%esi
80103d29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103d30 <yield>:
80103d30:	55                   	push   %ebp
80103d31:	89 e5                	mov    %esp,%ebp
80103d33:	83 ec 18             	sub    $0x18,%esp
80103d36:	c7 04 24 60 2c 11 80 	movl   $0x80112c60,(%esp)
80103d3d:	e8 8e 05 00 00       	call   801042d0 <acquire>
80103d42:	e8 b9 fa ff ff       	call   80103800 <myproc>
80103d47:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103d4e:	e8 0d fe ff ff       	call   80103b60 <sched>
80103d53:	c7 04 24 60 2c 11 80 	movl   $0x80112c60,(%esp)
80103d5a:	e8 61 06 00 00       	call   801043c0 <release>
80103d5f:	c9                   	leave  
80103d60:	c3                   	ret    
80103d61:	eb 0d                	jmp    80103d70 <sleep>
80103d63:	90                   	nop
80103d64:	90                   	nop
80103d65:	90                   	nop
80103d66:	90                   	nop
80103d67:	90                   	nop
80103d68:	90                   	nop
80103d69:	90                   	nop
80103d6a:	90                   	nop
80103d6b:	90                   	nop
80103d6c:	90                   	nop
80103d6d:	90                   	nop
80103d6e:	90                   	nop
80103d6f:	90                   	nop

80103d70 <sleep>:
80103d70:	55                   	push   %ebp
80103d71:	89 e5                	mov    %esp,%ebp
80103d73:	57                   	push   %edi
80103d74:	56                   	push   %esi
80103d75:	53                   	push   %ebx
80103d76:	83 ec 1c             	sub    $0x1c,%esp
80103d79:	8b 7d 08             	mov    0x8(%ebp),%edi
80103d7c:	8b 75 0c             	mov    0xc(%ebp),%esi
80103d7f:	e8 7c fa ff ff       	call   80103800 <myproc>
80103d84:	85 c0                	test   %eax,%eax
80103d86:	89 c3                	mov    %eax,%ebx
80103d88:	0f 84 7c 00 00 00    	je     80103e0a <sleep+0x9a>
80103d8e:	85 f6                	test   %esi,%esi
80103d90:	74 6c                	je     80103dfe <sleep+0x8e>
80103d92:	81 fe 60 2c 11 80    	cmp    $0x80112c60,%esi
80103d98:	74 46                	je     80103de0 <sleep+0x70>
80103d9a:	c7 04 24 60 2c 11 80 	movl   $0x80112c60,(%esp)
80103da1:	e8 2a 05 00 00       	call   801042d0 <acquire>
80103da6:	89 34 24             	mov    %esi,(%esp)
80103da9:	e8 12 06 00 00       	call   801043c0 <release>
80103dae:	89 7b 20             	mov    %edi,0x20(%ebx)
80103db1:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
80103db8:	e8 a3 fd ff ff       	call   80103b60 <sched>
80103dbd:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
80103dc4:	c7 04 24 60 2c 11 80 	movl   $0x80112c60,(%esp)
80103dcb:	e8 f0 05 00 00       	call   801043c0 <release>
80103dd0:	89 75 08             	mov    %esi,0x8(%ebp)
80103dd3:	83 c4 1c             	add    $0x1c,%esp
80103dd6:	5b                   	pop    %ebx
80103dd7:	5e                   	pop    %esi
80103dd8:	5f                   	pop    %edi
80103dd9:	5d                   	pop    %ebp
80103dda:	e9 f1 04 00 00       	jmp    801042d0 <acquire>
80103ddf:	90                   	nop
80103de0:	89 78 20             	mov    %edi,0x20(%eax)
80103de3:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
80103dea:	e8 71 fd ff ff       	call   80103b60 <sched>
80103def:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
80103df6:	83 c4 1c             	add    $0x1c,%esp
80103df9:	5b                   	pop    %ebx
80103dfa:	5e                   	pop    %esi
80103dfb:	5f                   	pop    %edi
80103dfc:	5d                   	pop    %ebp
80103dfd:	c3                   	ret    
80103dfe:	c7 04 24 e7 75 10 80 	movl   $0x801075e7,(%esp)
80103e05:	e8 56 c5 ff ff       	call   80100360 <panic>
80103e0a:	c7 04 24 e1 75 10 80 	movl   $0x801075e1,(%esp)
80103e11:	e8 4a c5 ff ff       	call   80100360 <panic>
80103e16:	8d 76 00             	lea    0x0(%esi),%esi
80103e19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103e20 <wait>:
80103e20:	55                   	push   %ebp
80103e21:	89 e5                	mov    %esp,%ebp
80103e23:	56                   	push   %esi
80103e24:	53                   	push   %ebx
80103e25:	83 ec 10             	sub    $0x10,%esp
80103e28:	e8 d3 f9 ff ff       	call   80103800 <myproc>
80103e2d:	c7 04 24 60 2c 11 80 	movl   $0x80112c60,(%esp)
80103e34:	89 c6                	mov    %eax,%esi
80103e36:	e8 95 04 00 00       	call   801042d0 <acquire>
80103e3b:	31 c0                	xor    %eax,%eax
80103e3d:	bb 94 2c 11 80       	mov    $0x80112c94,%ebx
80103e42:	eb 12                	jmp    80103e56 <wait+0x36>
80103e44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e48:	81 c3 88 00 00 00    	add    $0x88,%ebx
80103e4e:	81 fb 94 4e 11 80    	cmp    $0x80114e94,%ebx
80103e54:	74 22                	je     80103e78 <wait+0x58>
80103e56:	39 73 14             	cmp    %esi,0x14(%ebx)
80103e59:	75 ed                	jne    80103e48 <wait+0x28>
80103e5b:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103e5f:	74 34                	je     80103e95 <wait+0x75>
80103e61:	81 c3 88 00 00 00    	add    $0x88,%ebx
80103e67:	b8 01 00 00 00       	mov    $0x1,%eax
80103e6c:	81 fb 94 4e 11 80    	cmp    $0x80114e94,%ebx
80103e72:	75 e2                	jne    80103e56 <wait+0x36>
80103e74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e78:	85 c0                	test   %eax,%eax
80103e7a:	74 6e                	je     80103eea <wait+0xca>
80103e7c:	8b 4e 24             	mov    0x24(%esi),%ecx
80103e7f:	85 c9                	test   %ecx,%ecx
80103e81:	75 67                	jne    80103eea <wait+0xca>
80103e83:	c7 44 24 04 60 2c 11 	movl   $0x80112c60,0x4(%esp)
80103e8a:	80 
80103e8b:	89 34 24             	mov    %esi,(%esp)
80103e8e:	e8 dd fe ff ff       	call   80103d70 <sleep>
80103e93:	eb a6                	jmp    80103e3b <wait+0x1b>
80103e95:	8b 43 08             	mov    0x8(%ebx),%eax
80103e98:	8b 73 10             	mov    0x10(%ebx),%esi
80103e9b:	89 04 24             	mov    %eax,(%esp)
80103e9e:	e8 5d e5 ff ff       	call   80102400 <kfree>
80103ea3:	8b 43 04             	mov    0x4(%ebx),%eax
80103ea6:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
80103ead:	89 04 24             	mov    %eax,(%esp)
80103eb0:	e8 db 2d 00 00       	call   80106c90 <freevm>
80103eb5:	c7 04 24 60 2c 11 80 	movl   $0x80112c60,(%esp)
80103ebc:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
80103ec3:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
80103eca:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
80103ece:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
80103ed5:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
80103edc:	e8 df 04 00 00       	call   801043c0 <release>
80103ee1:	83 c4 10             	add    $0x10,%esp
80103ee4:	89 f0                	mov    %esi,%eax
80103ee6:	5b                   	pop    %ebx
80103ee7:	5e                   	pop    %esi
80103ee8:	5d                   	pop    %ebp
80103ee9:	c3                   	ret    
80103eea:	c7 04 24 60 2c 11 80 	movl   $0x80112c60,(%esp)
80103ef1:	e8 ca 04 00 00       	call   801043c0 <release>
80103ef6:	83 c4 10             	add    $0x10,%esp
80103ef9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103efe:	5b                   	pop    %ebx
80103eff:	5e                   	pop    %esi
80103f00:	5d                   	pop    %ebp
80103f01:	c3                   	ret    
80103f02:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103f10 <wakeup>:
80103f10:	55                   	push   %ebp
80103f11:	89 e5                	mov    %esp,%ebp
80103f13:	53                   	push   %ebx
80103f14:	83 ec 14             	sub    $0x14,%esp
80103f17:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103f1a:	c7 04 24 60 2c 11 80 	movl   $0x80112c60,(%esp)
80103f21:	e8 aa 03 00 00       	call   801042d0 <acquire>
80103f26:	b8 94 2c 11 80       	mov    $0x80112c94,%eax
80103f2b:	eb 0f                	jmp    80103f3c <wakeup+0x2c>
80103f2d:	8d 76 00             	lea    0x0(%esi),%esi
80103f30:	05 88 00 00 00       	add    $0x88,%eax
80103f35:	3d 94 4e 11 80       	cmp    $0x80114e94,%eax
80103f3a:	74 24                	je     80103f60 <wakeup+0x50>
80103f3c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103f40:	75 ee                	jne    80103f30 <wakeup+0x20>
80103f42:	3b 58 20             	cmp    0x20(%eax),%ebx
80103f45:	75 e9                	jne    80103f30 <wakeup+0x20>
80103f47:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103f4e:	05 88 00 00 00       	add    $0x88,%eax
80103f53:	3d 94 4e 11 80       	cmp    $0x80114e94,%eax
80103f58:	75 e2                	jne    80103f3c <wakeup+0x2c>
80103f5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103f60:	c7 45 08 60 2c 11 80 	movl   $0x80112c60,0x8(%ebp)
80103f67:	83 c4 14             	add    $0x14,%esp
80103f6a:	5b                   	pop    %ebx
80103f6b:	5d                   	pop    %ebp
80103f6c:	e9 4f 04 00 00       	jmp    801043c0 <release>
80103f71:	eb 0d                	jmp    80103f80 <kill>
80103f73:	90                   	nop
80103f74:	90                   	nop
80103f75:	90                   	nop
80103f76:	90                   	nop
80103f77:	90                   	nop
80103f78:	90                   	nop
80103f79:	90                   	nop
80103f7a:	90                   	nop
80103f7b:	90                   	nop
80103f7c:	90                   	nop
80103f7d:	90                   	nop
80103f7e:	90                   	nop
80103f7f:	90                   	nop

80103f80 <kill>:
80103f80:	55                   	push   %ebp
80103f81:	89 e5                	mov    %esp,%ebp
80103f83:	53                   	push   %ebx
80103f84:	83 ec 14             	sub    $0x14,%esp
80103f87:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103f8a:	c7 04 24 60 2c 11 80 	movl   $0x80112c60,(%esp)
80103f91:	e8 3a 03 00 00       	call   801042d0 <acquire>
80103f96:	b8 94 2c 11 80       	mov    $0x80112c94,%eax
80103f9b:	eb 0f                	jmp    80103fac <kill+0x2c>
80103f9d:	8d 76 00             	lea    0x0(%esi),%esi
80103fa0:	05 88 00 00 00       	add    $0x88,%eax
80103fa5:	3d 94 4e 11 80       	cmp    $0x80114e94,%eax
80103faa:	74 3c                	je     80103fe8 <kill+0x68>
80103fac:	39 58 10             	cmp    %ebx,0x10(%eax)
80103faf:	75 ef                	jne    80103fa0 <kill+0x20>
80103fb1:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103fb5:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80103fbc:	74 1a                	je     80103fd8 <kill+0x58>
80103fbe:	c7 04 24 60 2c 11 80 	movl   $0x80112c60,(%esp)
80103fc5:	e8 f6 03 00 00       	call   801043c0 <release>
80103fca:	83 c4 14             	add    $0x14,%esp
80103fcd:	31 c0                	xor    %eax,%eax
80103fcf:	5b                   	pop    %ebx
80103fd0:	5d                   	pop    %ebp
80103fd1:	c3                   	ret    
80103fd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103fd8:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103fdf:	eb dd                	jmp    80103fbe <kill+0x3e>
80103fe1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103fe8:	c7 04 24 60 2c 11 80 	movl   $0x80112c60,(%esp)
80103fef:	e8 cc 03 00 00       	call   801043c0 <release>
80103ff4:	83 c4 14             	add    $0x14,%esp
80103ff7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103ffc:	5b                   	pop    %ebx
80103ffd:	5d                   	pop    %ebp
80103ffe:	c3                   	ret    
80103fff:	90                   	nop

80104000 <procdump>:
80104000:	55                   	push   %ebp
80104001:	89 e5                	mov    %esp,%ebp
80104003:	57                   	push   %edi
80104004:	56                   	push   %esi
80104005:	53                   	push   %ebx
80104006:	bb 00 2d 11 80       	mov    $0x80112d00,%ebx
8010400b:	83 ec 4c             	sub    $0x4c,%esp
8010400e:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104011:	eb 23                	jmp    80104036 <procdump+0x36>
80104013:	90                   	nop
80104014:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104018:	c7 04 24 b7 79 10 80 	movl   $0x801079b7,(%esp)
8010401f:	e8 2c c6 ff ff       	call   80100650 <cprintf>
80104024:	81 c3 88 00 00 00    	add    $0x88,%ebx
8010402a:	81 fb 00 4f 11 80    	cmp    $0x80114f00,%ebx
80104030:	0f 84 8a 00 00 00    	je     801040c0 <procdump+0xc0>
80104036:	8b 43 a0             	mov    -0x60(%ebx),%eax
80104039:	85 c0                	test   %eax,%eax
8010403b:	74 e7                	je     80104024 <procdump+0x24>
8010403d:	83 f8 05             	cmp    $0x5,%eax
80104040:	ba f8 75 10 80       	mov    $0x801075f8,%edx
80104045:	77 11                	ja     80104058 <procdump+0x58>
80104047:	8b 14 85 58 76 10 80 	mov    -0x7fef89a8(,%eax,4),%edx
8010404e:	b8 f8 75 10 80       	mov    $0x801075f8,%eax
80104053:	85 d2                	test   %edx,%edx
80104055:	0f 44 d0             	cmove  %eax,%edx
80104058:	8b 43 a4             	mov    -0x5c(%ebx),%eax
8010405b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
8010405f:	89 54 24 08          	mov    %edx,0x8(%esp)
80104063:	c7 04 24 fc 75 10 80 	movl   $0x801075fc,(%esp)
8010406a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010406e:	e8 dd c5 ff ff       	call   80100650 <cprintf>
80104073:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80104077:	75 9f                	jne    80104018 <procdump+0x18>
80104079:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010407c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104080:	8b 43 b0             	mov    -0x50(%ebx),%eax
80104083:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104086:	8b 40 0c             	mov    0xc(%eax),%eax
80104089:	83 c0 08             	add    $0x8,%eax
8010408c:	89 04 24             	mov    %eax,(%esp)
8010408f:	e8 6c 01 00 00       	call   80104200 <getcallerpcs>
80104094:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104098:	8b 17                	mov    (%edi),%edx
8010409a:	85 d2                	test   %edx,%edx
8010409c:	0f 84 76 ff ff ff    	je     80104018 <procdump+0x18>
801040a2:	89 54 24 04          	mov    %edx,0x4(%esp)
801040a6:	83 c7 04             	add    $0x4,%edi
801040a9:	c7 04 24 01 70 10 80 	movl   $0x80107001,(%esp)
801040b0:	e8 9b c5 ff ff       	call   80100650 <cprintf>
801040b5:	39 f7                	cmp    %esi,%edi
801040b7:	75 df                	jne    80104098 <procdump+0x98>
801040b9:	e9 5a ff ff ff       	jmp    80104018 <procdump+0x18>
801040be:	66 90                	xchg   %ax,%ax
801040c0:	83 c4 4c             	add    $0x4c,%esp
801040c3:	5b                   	pop    %ebx
801040c4:	5e                   	pop    %esi
801040c5:	5f                   	pop    %edi
801040c6:	5d                   	pop    %ebp
801040c7:	c3                   	ret    
	...

801040d0 <initsleeplock>:
801040d0:	55                   	push   %ebp
801040d1:	89 e5                	mov    %esp,%ebp
801040d3:	53                   	push   %ebx
801040d4:	83 ec 14             	sub    $0x14,%esp
801040d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
801040da:	c7 44 24 04 70 76 10 	movl   $0x80107670,0x4(%esp)
801040e1:	80 
801040e2:	8d 43 04             	lea    0x4(%ebx),%eax
801040e5:	89 04 24             	mov    %eax,(%esp)
801040e8:	e8 f3 00 00 00       	call   801041e0 <initlock>
801040ed:	8b 45 0c             	mov    0xc(%ebp),%eax
801040f0:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
801040f6:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
801040fd:	89 43 38             	mov    %eax,0x38(%ebx)
80104100:	83 c4 14             	add    $0x14,%esp
80104103:	5b                   	pop    %ebx
80104104:	5d                   	pop    %ebp
80104105:	c3                   	ret    
80104106:	8d 76 00             	lea    0x0(%esi),%esi
80104109:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104110 <acquiresleep>:
80104110:	55                   	push   %ebp
80104111:	89 e5                	mov    %esp,%ebp
80104113:	56                   	push   %esi
80104114:	53                   	push   %ebx
80104115:	83 ec 10             	sub    $0x10,%esp
80104118:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010411b:	8d 73 04             	lea    0x4(%ebx),%esi
8010411e:	89 34 24             	mov    %esi,(%esp)
80104121:	e8 aa 01 00 00       	call   801042d0 <acquire>
80104126:	8b 13                	mov    (%ebx),%edx
80104128:	85 d2                	test   %edx,%edx
8010412a:	74 16                	je     80104142 <acquiresleep+0x32>
8010412c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104130:	89 74 24 04          	mov    %esi,0x4(%esp)
80104134:	89 1c 24             	mov    %ebx,(%esp)
80104137:	e8 34 fc ff ff       	call   80103d70 <sleep>
8010413c:	8b 03                	mov    (%ebx),%eax
8010413e:	85 c0                	test   %eax,%eax
80104140:	75 ee                	jne    80104130 <acquiresleep+0x20>
80104142:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
80104148:	e8 b3 f6 ff ff       	call   80103800 <myproc>
8010414d:	8b 40 10             	mov    0x10(%eax),%eax
80104150:	89 43 3c             	mov    %eax,0x3c(%ebx)
80104153:	89 75 08             	mov    %esi,0x8(%ebp)
80104156:	83 c4 10             	add    $0x10,%esp
80104159:	5b                   	pop    %ebx
8010415a:	5e                   	pop    %esi
8010415b:	5d                   	pop    %ebp
8010415c:	e9 5f 02 00 00       	jmp    801043c0 <release>
80104161:	eb 0d                	jmp    80104170 <releasesleep>
80104163:	90                   	nop
80104164:	90                   	nop
80104165:	90                   	nop
80104166:	90                   	nop
80104167:	90                   	nop
80104168:	90                   	nop
80104169:	90                   	nop
8010416a:	90                   	nop
8010416b:	90                   	nop
8010416c:	90                   	nop
8010416d:	90                   	nop
8010416e:	90                   	nop
8010416f:	90                   	nop

80104170 <releasesleep>:
80104170:	55                   	push   %ebp
80104171:	89 e5                	mov    %esp,%ebp
80104173:	56                   	push   %esi
80104174:	53                   	push   %ebx
80104175:	83 ec 10             	sub    $0x10,%esp
80104178:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010417b:	8d 73 04             	lea    0x4(%ebx),%esi
8010417e:	89 34 24             	mov    %esi,(%esp)
80104181:	e8 4a 01 00 00       	call   801042d0 <acquire>
80104186:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
8010418c:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
80104193:	89 1c 24             	mov    %ebx,(%esp)
80104196:	e8 75 fd ff ff       	call   80103f10 <wakeup>
8010419b:	89 75 08             	mov    %esi,0x8(%ebp)
8010419e:	83 c4 10             	add    $0x10,%esp
801041a1:	5b                   	pop    %ebx
801041a2:	5e                   	pop    %esi
801041a3:	5d                   	pop    %ebp
801041a4:	e9 17 02 00 00       	jmp    801043c0 <release>
801041a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801041b0 <holdingsleep>:
801041b0:	55                   	push   %ebp
801041b1:	89 e5                	mov    %esp,%ebp
801041b3:	56                   	push   %esi
801041b4:	53                   	push   %ebx
801041b5:	83 ec 10             	sub    $0x10,%esp
801041b8:	8b 5d 08             	mov    0x8(%ebp),%ebx
801041bb:	8d 73 04             	lea    0x4(%ebx),%esi
801041be:	89 34 24             	mov    %esi,(%esp)
801041c1:	e8 0a 01 00 00       	call   801042d0 <acquire>
801041c6:	8b 1b                	mov    (%ebx),%ebx
801041c8:	89 34 24             	mov    %esi,(%esp)
801041cb:	e8 f0 01 00 00       	call   801043c0 <release>
801041d0:	83 c4 10             	add    $0x10,%esp
801041d3:	89 d8                	mov    %ebx,%eax
801041d5:	5b                   	pop    %ebx
801041d6:	5e                   	pop    %esi
801041d7:	5d                   	pop    %ebp
801041d8:	c3                   	ret    
801041d9:	00 00                	add    %al,(%eax)
801041db:	00 00                	add    %al,(%eax)
801041dd:	00 00                	add    %al,(%eax)
	...

801041e0 <initlock>:
801041e0:	55                   	push   %ebp
801041e1:	89 e5                	mov    %esp,%ebp
801041e3:	8b 45 08             	mov    0x8(%ebp),%eax
801041e6:	8b 55 0c             	mov    0xc(%ebp),%edx
801041e9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801041ef:	89 50 04             	mov    %edx,0x4(%eax)
801041f2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
801041f9:	5d                   	pop    %ebp
801041fa:	c3                   	ret    
801041fb:	90                   	nop
801041fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104200 <getcallerpcs>:
80104200:	55                   	push   %ebp
80104201:	89 e5                	mov    %esp,%ebp
80104203:	8b 45 08             	mov    0x8(%ebp),%eax
80104206:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104209:	53                   	push   %ebx
8010420a:	8d 50 f8             	lea    -0x8(%eax),%edx
8010420d:	31 c0                	xor    %eax,%eax
8010420f:	90                   	nop
80104210:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104216:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010421c:	77 1a                	ja     80104238 <getcallerpcs+0x38>
8010421e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104221:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
80104224:	83 c0 01             	add    $0x1,%eax
80104227:	8b 12                	mov    (%edx),%edx
80104229:	83 f8 0a             	cmp    $0xa,%eax
8010422c:	75 e2                	jne    80104210 <getcallerpcs+0x10>
8010422e:	5b                   	pop    %ebx
8010422f:	5d                   	pop    %ebp
80104230:	c3                   	ret    
80104231:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104238:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
8010423f:	83 c0 01             	add    $0x1,%eax
80104242:	83 f8 0a             	cmp    $0xa,%eax
80104245:	74 e7                	je     8010422e <getcallerpcs+0x2e>
80104247:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
8010424e:	83 c0 01             	add    $0x1,%eax
80104251:	83 f8 0a             	cmp    $0xa,%eax
80104254:	75 e2                	jne    80104238 <getcallerpcs+0x38>
80104256:	eb d6                	jmp    8010422e <getcallerpcs+0x2e>
80104258:	90                   	nop
80104259:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104260 <holding>:
80104260:	55                   	push   %ebp
80104261:	31 c0                	xor    %eax,%eax
80104263:	89 e5                	mov    %esp,%ebp
80104265:	53                   	push   %ebx
80104266:	83 ec 04             	sub    $0x4,%esp
80104269:	8b 55 08             	mov    0x8(%ebp),%edx
8010426c:	8b 0a                	mov    (%edx),%ecx
8010426e:	85 c9                	test   %ecx,%ecx
80104270:	74 10                	je     80104282 <holding+0x22>
80104272:	8b 5a 08             	mov    0x8(%edx),%ebx
80104275:	e8 e6 f4 ff ff       	call   80103760 <mycpu>
8010427a:	39 c3                	cmp    %eax,%ebx
8010427c:	0f 94 c0             	sete   %al
8010427f:	0f b6 c0             	movzbl %al,%eax
80104282:	83 c4 04             	add    $0x4,%esp
80104285:	5b                   	pop    %ebx
80104286:	5d                   	pop    %ebp
80104287:	c3                   	ret    
80104288:	90                   	nop
80104289:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104290 <pushcli>:
80104290:	55                   	push   %ebp
80104291:	89 e5                	mov    %esp,%ebp
80104293:	53                   	push   %ebx
80104294:	83 ec 04             	sub    $0x4,%esp
80104297:	9c                   	pushf  
80104298:	5b                   	pop    %ebx
80104299:	fa                   	cli    
8010429a:	e8 c1 f4 ff ff       	call   80103760 <mycpu>
8010429f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801042a5:	85 c0                	test   %eax,%eax
801042a7:	75 11                	jne    801042ba <pushcli+0x2a>
801042a9:	e8 b2 f4 ff ff       	call   80103760 <mycpu>
801042ae:	81 e3 00 02 00 00    	and    $0x200,%ebx
801042b4:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
801042ba:	e8 a1 f4 ff ff       	call   80103760 <mycpu>
801042bf:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
801042c6:	83 c4 04             	add    $0x4,%esp
801042c9:	5b                   	pop    %ebx
801042ca:	5d                   	pop    %ebp
801042cb:	c3                   	ret    
801042cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801042d0 <acquire>:
801042d0:	55                   	push   %ebp
801042d1:	89 e5                	mov    %esp,%ebp
801042d3:	53                   	push   %ebx
801042d4:	83 ec 14             	sub    $0x14,%esp
801042d7:	e8 b4 ff ff ff       	call   80104290 <pushcli>
801042dc:	8b 55 08             	mov    0x8(%ebp),%edx
801042df:	8b 02                	mov    (%edx),%eax
801042e1:	85 c0                	test   %eax,%eax
801042e3:	75 43                	jne    80104328 <acquire+0x58>
801042e5:	b9 01 00 00 00       	mov    $0x1,%ecx
801042ea:	eb 07                	jmp    801042f3 <acquire+0x23>
801042ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801042f0:	8b 55 08             	mov    0x8(%ebp),%edx
801042f3:	89 c8                	mov    %ecx,%eax
801042f5:	f0 87 02             	lock xchg %eax,(%edx)
801042f8:	85 c0                	test   %eax,%eax
801042fa:	75 f4                	jne    801042f0 <acquire+0x20>
801042fc:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
80104301:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104304:	e8 57 f4 ff ff       	call   80103760 <mycpu>
80104309:	89 43 08             	mov    %eax,0x8(%ebx)
8010430c:	8b 45 08             	mov    0x8(%ebp),%eax
8010430f:	83 c0 0c             	add    $0xc,%eax
80104312:	89 44 24 04          	mov    %eax,0x4(%esp)
80104316:	8d 45 08             	lea    0x8(%ebp),%eax
80104319:	89 04 24             	mov    %eax,(%esp)
8010431c:	e8 df fe ff ff       	call   80104200 <getcallerpcs>
80104321:	83 c4 14             	add    $0x14,%esp
80104324:	5b                   	pop    %ebx
80104325:	5d                   	pop    %ebp
80104326:	c3                   	ret    
80104327:	90                   	nop
80104328:	8b 5a 08             	mov    0x8(%edx),%ebx
8010432b:	e8 30 f4 ff ff       	call   80103760 <mycpu>
80104330:	39 c3                	cmp    %eax,%ebx
80104332:	74 05                	je     80104339 <acquire+0x69>
80104334:	8b 55 08             	mov    0x8(%ebp),%edx
80104337:	eb ac                	jmp    801042e5 <acquire+0x15>
80104339:	c7 04 24 7b 76 10 80 	movl   $0x8010767b,(%esp)
80104340:	e8 1b c0 ff ff       	call   80100360 <panic>
80104345:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104349:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104350 <popcli>:
80104350:	55                   	push   %ebp
80104351:	89 e5                	mov    %esp,%ebp
80104353:	83 ec 18             	sub    $0x18,%esp
80104356:	9c                   	pushf  
80104357:	58                   	pop    %eax
80104358:	f6 c4 02             	test   $0x2,%ah
8010435b:	75 49                	jne    801043a6 <popcli+0x56>
8010435d:	e8 fe f3 ff ff       	call   80103760 <mycpu>
80104362:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
80104368:	8d 51 ff             	lea    -0x1(%ecx),%edx
8010436b:	85 d2                	test   %edx,%edx
8010436d:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
80104373:	78 25                	js     8010439a <popcli+0x4a>
80104375:	e8 e6 f3 ff ff       	call   80103760 <mycpu>
8010437a:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104380:	85 c0                	test   %eax,%eax
80104382:	74 04                	je     80104388 <popcli+0x38>
80104384:	c9                   	leave  
80104385:	c3                   	ret    
80104386:	66 90                	xchg   %ax,%ax
80104388:	e8 d3 f3 ff ff       	call   80103760 <mycpu>
8010438d:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104393:	85 c0                	test   %eax,%eax
80104395:	74 ed                	je     80104384 <popcli+0x34>
80104397:	fb                   	sti    
80104398:	c9                   	leave  
80104399:	c3                   	ret    
8010439a:	c7 04 24 9a 76 10 80 	movl   $0x8010769a,(%esp)
801043a1:	e8 ba bf ff ff       	call   80100360 <panic>
801043a6:	c7 04 24 83 76 10 80 	movl   $0x80107683,(%esp)
801043ad:	e8 ae bf ff ff       	call   80100360 <panic>
801043b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801043b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801043c0 <release>:
801043c0:	55                   	push   %ebp
801043c1:	89 e5                	mov    %esp,%ebp
801043c3:	56                   	push   %esi
801043c4:	53                   	push   %ebx
801043c5:	83 ec 10             	sub    $0x10,%esp
801043c8:	8b 5d 08             	mov    0x8(%ebp),%ebx
801043cb:	8b 03                	mov    (%ebx),%eax
801043cd:	85 c0                	test   %eax,%eax
801043cf:	75 0f                	jne    801043e0 <release+0x20>
801043d1:	c7 04 24 a1 76 10 80 	movl   $0x801076a1,(%esp)
801043d8:	e8 83 bf ff ff       	call   80100360 <panic>
801043dd:	8d 76 00             	lea    0x0(%esi),%esi
801043e0:	8b 73 08             	mov    0x8(%ebx),%esi
801043e3:	e8 78 f3 ff ff       	call   80103760 <mycpu>
801043e8:	39 c6                	cmp    %eax,%esi
801043ea:	75 e5                	jne    801043d1 <release+0x11>
801043ec:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
801043f3:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
801043fa:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
801043ff:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80104405:	83 c4 10             	add    $0x10,%esp
80104408:	5b                   	pop    %ebx
80104409:	5e                   	pop    %esi
8010440a:	5d                   	pop    %ebp
8010440b:	e9 40 ff ff ff       	jmp    80104350 <popcli>

80104410 <memset>:
80104410:	55                   	push   %ebp
80104411:	89 e5                	mov    %esp,%ebp
80104413:	8b 55 08             	mov    0x8(%ebp),%edx
80104416:	57                   	push   %edi
80104417:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010441a:	53                   	push   %ebx
8010441b:	f6 c2 03             	test   $0x3,%dl
8010441e:	75 05                	jne    80104425 <memset+0x15>
80104420:	f6 c1 03             	test   $0x3,%cl
80104423:	74 13                	je     80104438 <memset+0x28>
80104425:	89 d7                	mov    %edx,%edi
80104427:	8b 45 0c             	mov    0xc(%ebp),%eax
8010442a:	fc                   	cld    
8010442b:	f3 aa                	rep stos %al,%es:(%edi)
8010442d:	5b                   	pop    %ebx
8010442e:	89 d0                	mov    %edx,%eax
80104430:	5f                   	pop    %edi
80104431:	5d                   	pop    %ebp
80104432:	c3                   	ret    
80104433:	90                   	nop
80104434:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104438:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
8010443c:	c1 e9 02             	shr    $0x2,%ecx
8010443f:	89 f8                	mov    %edi,%eax
80104441:	89 fb                	mov    %edi,%ebx
80104443:	c1 e0 18             	shl    $0x18,%eax
80104446:	c1 e3 10             	shl    $0x10,%ebx
80104449:	09 d8                	or     %ebx,%eax
8010444b:	09 f8                	or     %edi,%eax
8010444d:	c1 e7 08             	shl    $0x8,%edi
80104450:	09 f8                	or     %edi,%eax
80104452:	89 d7                	mov    %edx,%edi
80104454:	fc                   	cld    
80104455:	f3 ab                	rep stos %eax,%es:(%edi)
80104457:	5b                   	pop    %ebx
80104458:	89 d0                	mov    %edx,%eax
8010445a:	5f                   	pop    %edi
8010445b:	5d                   	pop    %ebp
8010445c:	c3                   	ret    
8010445d:	8d 76 00             	lea    0x0(%esi),%esi

80104460 <memcmp>:
80104460:	55                   	push   %ebp
80104461:	89 e5                	mov    %esp,%ebp
80104463:	8b 45 10             	mov    0x10(%ebp),%eax
80104466:	57                   	push   %edi
80104467:	56                   	push   %esi
80104468:	8b 75 0c             	mov    0xc(%ebp),%esi
8010446b:	53                   	push   %ebx
8010446c:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010446f:	85 c0                	test   %eax,%eax
80104471:	8d 78 ff             	lea    -0x1(%eax),%edi
80104474:	74 26                	je     8010449c <memcmp+0x3c>
80104476:	0f b6 03             	movzbl (%ebx),%eax
80104479:	31 d2                	xor    %edx,%edx
8010447b:	0f b6 0e             	movzbl (%esi),%ecx
8010447e:	38 c8                	cmp    %cl,%al
80104480:	74 16                	je     80104498 <memcmp+0x38>
80104482:	eb 24                	jmp    801044a8 <memcmp+0x48>
80104484:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104488:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
8010448d:	83 c2 01             	add    $0x1,%edx
80104490:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104494:	38 c8                	cmp    %cl,%al
80104496:	75 10                	jne    801044a8 <memcmp+0x48>
80104498:	39 fa                	cmp    %edi,%edx
8010449a:	75 ec                	jne    80104488 <memcmp+0x28>
8010449c:	5b                   	pop    %ebx
8010449d:	31 c0                	xor    %eax,%eax
8010449f:	5e                   	pop    %esi
801044a0:	5f                   	pop    %edi
801044a1:	5d                   	pop    %ebp
801044a2:	c3                   	ret    
801044a3:	90                   	nop
801044a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801044a8:	5b                   	pop    %ebx
801044a9:	29 c8                	sub    %ecx,%eax
801044ab:	5e                   	pop    %esi
801044ac:	5f                   	pop    %edi
801044ad:	5d                   	pop    %ebp
801044ae:	c3                   	ret    
801044af:	90                   	nop

801044b0 <memmove>:
801044b0:	55                   	push   %ebp
801044b1:	89 e5                	mov    %esp,%ebp
801044b3:	57                   	push   %edi
801044b4:	8b 45 08             	mov    0x8(%ebp),%eax
801044b7:	56                   	push   %esi
801044b8:	8b 75 0c             	mov    0xc(%ebp),%esi
801044bb:	53                   	push   %ebx
801044bc:	8b 5d 10             	mov    0x10(%ebp),%ebx
801044bf:	39 c6                	cmp    %eax,%esi
801044c1:	73 35                	jae    801044f8 <memmove+0x48>
801044c3:	8d 0c 1e             	lea    (%esi,%ebx,1),%ecx
801044c6:	39 c8                	cmp    %ecx,%eax
801044c8:	73 2e                	jae    801044f8 <memmove+0x48>
801044ca:	85 db                	test   %ebx,%ebx
801044cc:	8d 3c 18             	lea    (%eax,%ebx,1),%edi
801044cf:	8d 53 ff             	lea    -0x1(%ebx),%edx
801044d2:	74 1b                	je     801044ef <memmove+0x3f>
801044d4:	f7 db                	neg    %ebx
801044d6:	8d 34 19             	lea    (%ecx,%ebx,1),%esi
801044d9:	01 fb                	add    %edi,%ebx
801044db:	90                   	nop
801044dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801044e0:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
801044e4:	88 0c 13             	mov    %cl,(%ebx,%edx,1)
801044e7:	83 ea 01             	sub    $0x1,%edx
801044ea:	83 fa ff             	cmp    $0xffffffff,%edx
801044ed:	75 f1                	jne    801044e0 <memmove+0x30>
801044ef:	5b                   	pop    %ebx
801044f0:	5e                   	pop    %esi
801044f1:	5f                   	pop    %edi
801044f2:	5d                   	pop    %ebp
801044f3:	c3                   	ret    
801044f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801044f8:	31 d2                	xor    %edx,%edx
801044fa:	85 db                	test   %ebx,%ebx
801044fc:	74 f1                	je     801044ef <memmove+0x3f>
801044fe:	66 90                	xchg   %ax,%ax
80104500:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104504:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104507:	83 c2 01             	add    $0x1,%edx
8010450a:	39 da                	cmp    %ebx,%edx
8010450c:	75 f2                	jne    80104500 <memmove+0x50>
8010450e:	5b                   	pop    %ebx
8010450f:	5e                   	pop    %esi
80104510:	5f                   	pop    %edi
80104511:	5d                   	pop    %ebp
80104512:	c3                   	ret    
80104513:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104519:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104520 <memcpy>:
80104520:	55                   	push   %ebp
80104521:	89 e5                	mov    %esp,%ebp
80104523:	5d                   	pop    %ebp
80104524:	e9 87 ff ff ff       	jmp    801044b0 <memmove>
80104529:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104530 <strncmp>:
80104530:	55                   	push   %ebp
80104531:	89 e5                	mov    %esp,%ebp
80104533:	56                   	push   %esi
80104534:	8b 75 10             	mov    0x10(%ebp),%esi
80104537:	53                   	push   %ebx
80104538:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010453b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010453e:	85 f6                	test   %esi,%esi
80104540:	74 30                	je     80104572 <strncmp+0x42>
80104542:	0f b6 01             	movzbl (%ecx),%eax
80104545:	84 c0                	test   %al,%al
80104547:	74 2f                	je     80104578 <strncmp+0x48>
80104549:	0f b6 13             	movzbl (%ebx),%edx
8010454c:	38 d0                	cmp    %dl,%al
8010454e:	75 46                	jne    80104596 <strncmp+0x66>
80104550:	8d 51 01             	lea    0x1(%ecx),%edx
80104553:	01 ce                	add    %ecx,%esi
80104555:	eb 14                	jmp    8010456b <strncmp+0x3b>
80104557:	90                   	nop
80104558:	0f b6 02             	movzbl (%edx),%eax
8010455b:	84 c0                	test   %al,%al
8010455d:	74 31                	je     80104590 <strncmp+0x60>
8010455f:	0f b6 19             	movzbl (%ecx),%ebx
80104562:	83 c2 01             	add    $0x1,%edx
80104565:	38 d8                	cmp    %bl,%al
80104567:	75 17                	jne    80104580 <strncmp+0x50>
80104569:	89 cb                	mov    %ecx,%ebx
8010456b:	39 f2                	cmp    %esi,%edx
8010456d:	8d 4b 01             	lea    0x1(%ebx),%ecx
80104570:	75 e6                	jne    80104558 <strncmp+0x28>
80104572:	5b                   	pop    %ebx
80104573:	31 c0                	xor    %eax,%eax
80104575:	5e                   	pop    %esi
80104576:	5d                   	pop    %ebp
80104577:	c3                   	ret    
80104578:	0f b6 1b             	movzbl (%ebx),%ebx
8010457b:	31 c0                	xor    %eax,%eax
8010457d:	8d 76 00             	lea    0x0(%esi),%esi
80104580:	0f b6 d3             	movzbl %bl,%edx
80104583:	29 d0                	sub    %edx,%eax
80104585:	5b                   	pop    %ebx
80104586:	5e                   	pop    %esi
80104587:	5d                   	pop    %ebp
80104588:	c3                   	ret    
80104589:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104590:	0f b6 5b 01          	movzbl 0x1(%ebx),%ebx
80104594:	eb ea                	jmp    80104580 <strncmp+0x50>
80104596:	89 d3                	mov    %edx,%ebx
80104598:	eb e6                	jmp    80104580 <strncmp+0x50>
8010459a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801045a0 <strncpy>:
801045a0:	55                   	push   %ebp
801045a1:	89 e5                	mov    %esp,%ebp
801045a3:	8b 45 08             	mov    0x8(%ebp),%eax
801045a6:	56                   	push   %esi
801045a7:	8b 4d 10             	mov    0x10(%ebp),%ecx
801045aa:	53                   	push   %ebx
801045ab:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801045ae:	89 c2                	mov    %eax,%edx
801045b0:	eb 19                	jmp    801045cb <strncpy+0x2b>
801045b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801045b8:	83 c3 01             	add    $0x1,%ebx
801045bb:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
801045bf:	83 c2 01             	add    $0x1,%edx
801045c2:	84 c9                	test   %cl,%cl
801045c4:	88 4a ff             	mov    %cl,-0x1(%edx)
801045c7:	74 09                	je     801045d2 <strncpy+0x32>
801045c9:	89 f1                	mov    %esi,%ecx
801045cb:	85 c9                	test   %ecx,%ecx
801045cd:	8d 71 ff             	lea    -0x1(%ecx),%esi
801045d0:	7f e6                	jg     801045b8 <strncpy+0x18>
801045d2:	31 c9                	xor    %ecx,%ecx
801045d4:	85 f6                	test   %esi,%esi
801045d6:	7e 0f                	jle    801045e7 <strncpy+0x47>
801045d8:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
801045dc:	89 f3                	mov    %esi,%ebx
801045de:	83 c1 01             	add    $0x1,%ecx
801045e1:	29 cb                	sub    %ecx,%ebx
801045e3:	85 db                	test   %ebx,%ebx
801045e5:	7f f1                	jg     801045d8 <strncpy+0x38>
801045e7:	5b                   	pop    %ebx
801045e8:	5e                   	pop    %esi
801045e9:	5d                   	pop    %ebp
801045ea:	c3                   	ret    
801045eb:	90                   	nop
801045ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801045f0 <safestrcpy>:
801045f0:	55                   	push   %ebp
801045f1:	89 e5                	mov    %esp,%ebp
801045f3:	8b 4d 10             	mov    0x10(%ebp),%ecx
801045f6:	56                   	push   %esi
801045f7:	8b 45 08             	mov    0x8(%ebp),%eax
801045fa:	53                   	push   %ebx
801045fb:	8b 55 0c             	mov    0xc(%ebp),%edx
801045fe:	85 c9                	test   %ecx,%ecx
80104600:	7e 26                	jle    80104628 <safestrcpy+0x38>
80104602:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104606:	89 c1                	mov    %eax,%ecx
80104608:	eb 17                	jmp    80104621 <safestrcpy+0x31>
8010460a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104610:	83 c2 01             	add    $0x1,%edx
80104613:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104617:	83 c1 01             	add    $0x1,%ecx
8010461a:	84 db                	test   %bl,%bl
8010461c:	88 59 ff             	mov    %bl,-0x1(%ecx)
8010461f:	74 04                	je     80104625 <safestrcpy+0x35>
80104621:	39 f2                	cmp    %esi,%edx
80104623:	75 eb                	jne    80104610 <safestrcpy+0x20>
80104625:	c6 01 00             	movb   $0x0,(%ecx)
80104628:	5b                   	pop    %ebx
80104629:	5e                   	pop    %esi
8010462a:	5d                   	pop    %ebp
8010462b:	c3                   	ret    
8010462c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104630 <strlen>:
80104630:	55                   	push   %ebp
80104631:	31 c0                	xor    %eax,%eax
80104633:	89 e5                	mov    %esp,%ebp
80104635:	8b 55 08             	mov    0x8(%ebp),%edx
80104638:	80 3a 00             	cmpb   $0x0,(%edx)
8010463b:	74 0c                	je     80104649 <strlen+0x19>
8010463d:	8d 76 00             	lea    0x0(%esi),%esi
80104640:	83 c0 01             	add    $0x1,%eax
80104643:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104647:	75 f7                	jne    80104640 <strlen+0x10>
80104649:	5d                   	pop    %ebp
8010464a:	c3                   	ret    
	...

8010464c <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010464c:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104650:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80104654:	55                   	push   %ebp
  pushl %ebx
80104655:	53                   	push   %ebx
  pushl %esi
80104656:	56                   	push   %esi
  pushl %edi
80104657:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104658:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
8010465a:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
8010465c:	5f                   	pop    %edi
  popl %esi
8010465d:	5e                   	pop    %esi
  popl %ebx
8010465e:	5b                   	pop    %ebx
  popl %ebp
8010465f:	5d                   	pop    %ebp
  ret
80104660:	c3                   	ret    
	...

80104670 <fetchint>:
80104670:	55                   	push   %ebp
80104671:	89 e5                	mov    %esp,%ebp
80104673:	53                   	push   %ebx
80104674:	83 ec 04             	sub    $0x4,%esp
80104677:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010467a:	e8 81 f1 ff ff       	call   80103800 <myproc>
8010467f:	8b 00                	mov    (%eax),%eax
80104681:	39 d8                	cmp    %ebx,%eax
80104683:	76 1b                	jbe    801046a0 <fetchint+0x30>
80104685:	8d 53 04             	lea    0x4(%ebx),%edx
80104688:	39 d0                	cmp    %edx,%eax
8010468a:	72 14                	jb     801046a0 <fetchint+0x30>
8010468c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010468f:	8b 13                	mov    (%ebx),%edx
80104691:	89 10                	mov    %edx,(%eax)
80104693:	31 c0                	xor    %eax,%eax
80104695:	83 c4 04             	add    $0x4,%esp
80104698:	5b                   	pop    %ebx
80104699:	5d                   	pop    %ebp
8010469a:	c3                   	ret    
8010469b:	90                   	nop
8010469c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801046a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801046a5:	eb ee                	jmp    80104695 <fetchint+0x25>
801046a7:	89 f6                	mov    %esi,%esi
801046a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801046b0 <fetchstr>:
801046b0:	55                   	push   %ebp
801046b1:	89 e5                	mov    %esp,%ebp
801046b3:	53                   	push   %ebx
801046b4:	83 ec 04             	sub    $0x4,%esp
801046b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
801046ba:	e8 41 f1 ff ff       	call   80103800 <myproc>
801046bf:	39 18                	cmp    %ebx,(%eax)
801046c1:	76 26                	jbe    801046e9 <fetchstr+0x39>
801046c3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801046c6:	89 da                	mov    %ebx,%edx
801046c8:	89 19                	mov    %ebx,(%ecx)
801046ca:	8b 00                	mov    (%eax),%eax
801046cc:	39 c3                	cmp    %eax,%ebx
801046ce:	73 19                	jae    801046e9 <fetchstr+0x39>
801046d0:	80 3b 00             	cmpb   $0x0,(%ebx)
801046d3:	75 0d                	jne    801046e2 <fetchstr+0x32>
801046d5:	eb 21                	jmp    801046f8 <fetchstr+0x48>
801046d7:	90                   	nop
801046d8:	80 3a 00             	cmpb   $0x0,(%edx)
801046db:	90                   	nop
801046dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801046e0:	74 16                	je     801046f8 <fetchstr+0x48>
801046e2:	83 c2 01             	add    $0x1,%edx
801046e5:	39 d0                	cmp    %edx,%eax
801046e7:	77 ef                	ja     801046d8 <fetchstr+0x28>
801046e9:	83 c4 04             	add    $0x4,%esp
801046ec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801046f1:	5b                   	pop    %ebx
801046f2:	5d                   	pop    %ebp
801046f3:	c3                   	ret    
801046f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801046f8:	83 c4 04             	add    $0x4,%esp
801046fb:	89 d0                	mov    %edx,%eax
801046fd:	29 d8                	sub    %ebx,%eax
801046ff:	5b                   	pop    %ebx
80104700:	5d                   	pop    %ebp
80104701:	c3                   	ret    
80104702:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104709:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104710 <argint>:
80104710:	55                   	push   %ebp
80104711:	89 e5                	mov    %esp,%ebp
80104713:	56                   	push   %esi
80104714:	8b 75 0c             	mov    0xc(%ebp),%esi
80104717:	53                   	push   %ebx
80104718:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010471b:	e8 e0 f0 ff ff       	call   80103800 <myproc>
80104720:	89 75 0c             	mov    %esi,0xc(%ebp)
80104723:	8b 40 18             	mov    0x18(%eax),%eax
80104726:	8b 40 44             	mov    0x44(%eax),%eax
80104729:	8d 44 98 04          	lea    0x4(%eax,%ebx,4),%eax
8010472d:	89 45 08             	mov    %eax,0x8(%ebp)
80104730:	5b                   	pop    %ebx
80104731:	5e                   	pop    %esi
80104732:	5d                   	pop    %ebp
80104733:	e9 38 ff ff ff       	jmp    80104670 <fetchint>
80104738:	90                   	nop
80104739:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104740 <argptr>:
80104740:	55                   	push   %ebp
80104741:	89 e5                	mov    %esp,%ebp
80104743:	56                   	push   %esi
80104744:	53                   	push   %ebx
80104745:	83 ec 20             	sub    $0x20,%esp
80104748:	8b 5d 10             	mov    0x10(%ebp),%ebx
8010474b:	e8 b0 f0 ff ff       	call   80103800 <myproc>
80104750:	89 c6                	mov    %eax,%esi
80104752:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104755:	89 44 24 04          	mov    %eax,0x4(%esp)
80104759:	8b 45 08             	mov    0x8(%ebp),%eax
8010475c:	89 04 24             	mov    %eax,(%esp)
8010475f:	e8 ac ff ff ff       	call   80104710 <argint>
80104764:	85 c0                	test   %eax,%eax
80104766:	78 28                	js     80104790 <argptr+0x50>
80104768:	85 db                	test   %ebx,%ebx
8010476a:	78 24                	js     80104790 <argptr+0x50>
8010476c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010476f:	8b 06                	mov    (%esi),%eax
80104771:	39 c2                	cmp    %eax,%edx
80104773:	73 1b                	jae    80104790 <argptr+0x50>
80104775:	01 d3                	add    %edx,%ebx
80104777:	39 d8                	cmp    %ebx,%eax
80104779:	72 15                	jb     80104790 <argptr+0x50>
8010477b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010477e:	89 10                	mov    %edx,(%eax)
80104780:	83 c4 20             	add    $0x20,%esp
80104783:	31 c0                	xor    %eax,%eax
80104785:	5b                   	pop    %ebx
80104786:	5e                   	pop    %esi
80104787:	5d                   	pop    %ebp
80104788:	c3                   	ret    
80104789:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104790:	83 c4 20             	add    $0x20,%esp
80104793:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104798:	5b                   	pop    %ebx
80104799:	5e                   	pop    %esi
8010479a:	5d                   	pop    %ebp
8010479b:	c3                   	ret    
8010479c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801047a0 <argstr>:
801047a0:	55                   	push   %ebp
801047a1:	89 e5                	mov    %esp,%ebp
801047a3:	83 ec 28             	sub    $0x28,%esp
801047a6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801047a9:	89 44 24 04          	mov    %eax,0x4(%esp)
801047ad:	8b 45 08             	mov    0x8(%ebp),%eax
801047b0:	89 04 24             	mov    %eax,(%esp)
801047b3:	e8 58 ff ff ff       	call   80104710 <argint>
801047b8:	85 c0                	test   %eax,%eax
801047ba:	78 14                	js     801047d0 <argstr+0x30>
801047bc:	8b 45 0c             	mov    0xc(%ebp),%eax
801047bf:	89 44 24 04          	mov    %eax,0x4(%esp)
801047c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047c6:	89 04 24             	mov    %eax,(%esp)
801047c9:	e8 e2 fe ff ff       	call   801046b0 <fetchstr>
801047ce:	c9                   	leave  
801047cf:	c3                   	ret    
801047d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801047d5:	c9                   	leave  
801047d6:	c3                   	ret    
801047d7:	89 f6                	mov    %esi,%esi
801047d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801047e0 <syscall>:
801047e0:	55                   	push   %ebp
801047e1:	89 e5                	mov    %esp,%ebp
801047e3:	56                   	push   %esi
801047e4:	53                   	push   %ebx
801047e5:	83 ec 10             	sub    $0x10,%esp
801047e8:	e8 13 f0 ff ff       	call   80103800 <myproc>
801047ed:	8b 70 18             	mov    0x18(%eax),%esi
801047f0:	89 c3                	mov    %eax,%ebx
801047f2:	8b 46 1c             	mov    0x1c(%esi),%eax
801047f5:	8d 50 ff             	lea    -0x1(%eax),%edx
801047f8:	83 fa 17             	cmp    $0x17,%edx
801047fb:	77 1b                	ja     80104818 <syscall+0x38>
801047fd:	8b 14 85 e0 76 10 80 	mov    -0x7fef8920(,%eax,4),%edx
80104804:	85 d2                	test   %edx,%edx
80104806:	74 10                	je     80104818 <syscall+0x38>
80104808:	ff d2                	call   *%edx
8010480a:	89 46 1c             	mov    %eax,0x1c(%esi)
8010480d:	83 c4 10             	add    $0x10,%esp
80104810:	5b                   	pop    %ebx
80104811:	5e                   	pop    %esi
80104812:	5d                   	pop    %ebp
80104813:	c3                   	ret    
80104814:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104818:	89 44 24 0c          	mov    %eax,0xc(%esp)
8010481c:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010481f:	89 44 24 08          	mov    %eax,0x8(%esp)
80104823:	8b 43 10             	mov    0x10(%ebx),%eax
80104826:	c7 04 24 a9 76 10 80 	movl   $0x801076a9,(%esp)
8010482d:	89 44 24 04          	mov    %eax,0x4(%esp)
80104831:	e8 1a be ff ff       	call   80100650 <cprintf>
80104836:	8b 43 18             	mov    0x18(%ebx),%eax
80104839:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
80104840:	83 c4 10             	add    $0x10,%esp
80104843:	5b                   	pop    %ebx
80104844:	5e                   	pop    %esi
80104845:	5d                   	pop    %ebp
80104846:	c3                   	ret    
	...

80104850 <argfd>:
80104850:	55                   	push   %ebp
80104851:	89 e5                	mov    %esp,%ebp
80104853:	56                   	push   %esi
80104854:	89 d6                	mov    %edx,%esi
80104856:	53                   	push   %ebx
80104857:	89 cb                	mov    %ecx,%ebx
80104859:	83 ec 20             	sub    $0x20,%esp
8010485c:	8d 55 f4             	lea    -0xc(%ebp),%edx
8010485f:	89 54 24 04          	mov    %edx,0x4(%esp)
80104863:	89 04 24             	mov    %eax,(%esp)
80104866:	e8 a5 fe ff ff       	call   80104710 <argint>
8010486b:	85 c0                	test   %eax,%eax
8010486d:	78 31                	js     801048a0 <argfd+0x50>
8010486f:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104873:	77 2b                	ja     801048a0 <argfd+0x50>
80104875:	e8 86 ef ff ff       	call   80103800 <myproc>
8010487a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010487d:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104881:	85 c0                	test   %eax,%eax
80104883:	74 1b                	je     801048a0 <argfd+0x50>
80104885:	85 f6                	test   %esi,%esi
80104887:	74 02                	je     8010488b <argfd+0x3b>
80104889:	89 16                	mov    %edx,(%esi)
8010488b:	85 db                	test   %ebx,%ebx
8010488d:	74 21                	je     801048b0 <argfd+0x60>
8010488f:	89 03                	mov    %eax,(%ebx)
80104891:	31 c0                	xor    %eax,%eax
80104893:	83 c4 20             	add    $0x20,%esp
80104896:	5b                   	pop    %ebx
80104897:	5e                   	pop    %esi
80104898:	5d                   	pop    %ebp
80104899:	c3                   	ret    
8010489a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801048a0:	83 c4 20             	add    $0x20,%esp
801048a3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801048a8:	5b                   	pop    %ebx
801048a9:	5e                   	pop    %esi
801048aa:	5d                   	pop    %ebp
801048ab:	c3                   	ret    
801048ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801048b0:	31 c0                	xor    %eax,%eax
801048b2:	eb df                	jmp    80104893 <argfd+0x43>
801048b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801048ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801048c0 <fdalloc>:
801048c0:	55                   	push   %ebp
801048c1:	89 e5                	mov    %esp,%ebp
801048c3:	53                   	push   %ebx
801048c4:	89 c3                	mov    %eax,%ebx
801048c6:	83 ec 04             	sub    $0x4,%esp
801048c9:	e8 32 ef ff ff       	call   80103800 <myproc>
801048ce:	31 d2                	xor    %edx,%edx
801048d0:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
801048d4:	85 c9                	test   %ecx,%ecx
801048d6:	74 18                	je     801048f0 <fdalloc+0x30>
801048d8:	83 c2 01             	add    $0x1,%edx
801048db:	83 fa 10             	cmp    $0x10,%edx
801048de:	75 f0                	jne    801048d0 <fdalloc+0x10>
801048e0:	83 c4 04             	add    $0x4,%esp
801048e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801048e8:	5b                   	pop    %ebx
801048e9:	5d                   	pop    %ebp
801048ea:	c3                   	ret    
801048eb:	90                   	nop
801048ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801048f0:	89 5c 90 28          	mov    %ebx,0x28(%eax,%edx,4)
801048f4:	83 c4 04             	add    $0x4,%esp
801048f7:	89 d0                	mov    %edx,%eax
801048f9:	5b                   	pop    %ebx
801048fa:	5d                   	pop    %ebp
801048fb:	c3                   	ret    
801048fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104900 <create>:
80104900:	55                   	push   %ebp
80104901:	89 e5                	mov    %esp,%ebp
80104903:	57                   	push   %edi
80104904:	56                   	push   %esi
80104905:	53                   	push   %ebx
80104906:	83 ec 4c             	sub    $0x4c,%esp
80104909:	89 4d c0             	mov    %ecx,-0x40(%ebp)
8010490c:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010490f:	8d 5d da             	lea    -0x26(%ebp),%ebx
80104912:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104916:	89 04 24             	mov    %eax,(%esp)
80104919:	89 55 c4             	mov    %edx,-0x3c(%ebp)
8010491c:	89 4d bc             	mov    %ecx,-0x44(%ebp)
8010491f:	e8 0c d7 ff ff       	call   80102030 <nameiparent>
80104924:	85 c0                	test   %eax,%eax
80104926:	89 c7                	mov    %eax,%edi
80104928:	0f 84 da 00 00 00    	je     80104a08 <create+0x108>
8010492e:	89 04 24             	mov    %eax,(%esp)
80104931:	e8 8a ce ff ff       	call   801017c0 <ilock>
80104936:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104939:	89 44 24 08          	mov    %eax,0x8(%esp)
8010493d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104941:	89 3c 24             	mov    %edi,(%esp)
80104944:	e8 87 d3 ff ff       	call   80101cd0 <dirlookup>
80104949:	85 c0                	test   %eax,%eax
8010494b:	89 c6                	mov    %eax,%esi
8010494d:	74 41                	je     80104990 <create+0x90>
8010494f:	89 3c 24             	mov    %edi,(%esp)
80104952:	e8 c9 d0 ff ff       	call   80101a20 <iunlockput>
80104957:	89 34 24             	mov    %esi,(%esp)
8010495a:	e8 61 ce ff ff       	call   801017c0 <ilock>
8010495f:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80104964:	75 12                	jne    80104978 <create+0x78>
80104966:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
8010496b:	89 f0                	mov    %esi,%eax
8010496d:	75 09                	jne    80104978 <create+0x78>
8010496f:	83 c4 4c             	add    $0x4c,%esp
80104972:	5b                   	pop    %ebx
80104973:	5e                   	pop    %esi
80104974:	5f                   	pop    %edi
80104975:	5d                   	pop    %ebp
80104976:	c3                   	ret    
80104977:	90                   	nop
80104978:	89 34 24             	mov    %esi,(%esp)
8010497b:	e8 a0 d0 ff ff       	call   80101a20 <iunlockput>
80104980:	83 c4 4c             	add    $0x4c,%esp
80104983:	31 c0                	xor    %eax,%eax
80104985:	5b                   	pop    %ebx
80104986:	5e                   	pop    %esi
80104987:	5f                   	pop    %edi
80104988:	5d                   	pop    %ebp
80104989:	c3                   	ret    
8010498a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104990:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80104993:	89 44 24 04          	mov    %eax,0x4(%esp)
80104997:	8b 07                	mov    (%edi),%eax
80104999:	89 04 24             	mov    %eax,(%esp)
8010499c:	e8 8f cc ff ff       	call   80101630 <ialloc>
801049a1:	85 c0                	test   %eax,%eax
801049a3:	89 c6                	mov    %eax,%esi
801049a5:	0f 84 c0 00 00 00    	je     80104a6b <create+0x16b>
801049ab:	89 04 24             	mov    %eax,(%esp)
801049ae:	e8 0d ce ff ff       	call   801017c0 <ilock>
801049b3:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
801049b7:	66 89 46 52          	mov    %ax,0x52(%esi)
801049bb:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
801049bf:	66 89 46 54          	mov    %ax,0x54(%esi)
801049c3:	b8 01 00 00 00       	mov    $0x1,%eax
801049c8:	66 89 46 56          	mov    %ax,0x56(%esi)
801049cc:	89 34 24             	mov    %esi,(%esp)
801049cf:	e8 2c cd ff ff       	call   80101700 <iupdate>
801049d4:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
801049d9:	74 35                	je     80104a10 <create+0x110>
801049db:	8b 46 04             	mov    0x4(%esi),%eax
801049de:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801049e2:	89 3c 24             	mov    %edi,(%esp)
801049e5:	89 44 24 08          	mov    %eax,0x8(%esp)
801049e9:	e8 42 d5 ff ff       	call   80101f30 <dirlink>
801049ee:	85 c0                	test   %eax,%eax
801049f0:	78 6d                	js     80104a5f <create+0x15f>
801049f2:	89 3c 24             	mov    %edi,(%esp)
801049f5:	e8 26 d0 ff ff       	call   80101a20 <iunlockput>
801049fa:	83 c4 4c             	add    $0x4c,%esp
801049fd:	89 f0                	mov    %esi,%eax
801049ff:	5b                   	pop    %ebx
80104a00:	5e                   	pop    %esi
80104a01:	5f                   	pop    %edi
80104a02:	5d                   	pop    %ebp
80104a03:	c3                   	ret    
80104a04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a08:	31 c0                	xor    %eax,%eax
80104a0a:	e9 60 ff ff ff       	jmp    8010496f <create+0x6f>
80104a0f:	90                   	nop
80104a10:	66 83 47 56 01       	addw   $0x1,0x56(%edi)
80104a15:	89 3c 24             	mov    %edi,(%esp)
80104a18:	e8 e3 cc ff ff       	call   80101700 <iupdate>
80104a1d:	8b 46 04             	mov    0x4(%esi),%eax
80104a20:	c7 44 24 04 60 77 10 	movl   $0x80107760,0x4(%esp)
80104a27:	80 
80104a28:	89 34 24             	mov    %esi,(%esp)
80104a2b:	89 44 24 08          	mov    %eax,0x8(%esp)
80104a2f:	e8 fc d4 ff ff       	call   80101f30 <dirlink>
80104a34:	85 c0                	test   %eax,%eax
80104a36:	78 1b                	js     80104a53 <create+0x153>
80104a38:	8b 47 04             	mov    0x4(%edi),%eax
80104a3b:	c7 44 24 04 5f 77 10 	movl   $0x8010775f,0x4(%esp)
80104a42:	80 
80104a43:	89 34 24             	mov    %esi,(%esp)
80104a46:	89 44 24 08          	mov    %eax,0x8(%esp)
80104a4a:	e8 e1 d4 ff ff       	call   80101f30 <dirlink>
80104a4f:	85 c0                	test   %eax,%eax
80104a51:	79 88                	jns    801049db <create+0xdb>
80104a53:	c7 04 24 53 77 10 80 	movl   $0x80107753,(%esp)
80104a5a:	e8 01 b9 ff ff       	call   80100360 <panic>
80104a5f:	c7 04 24 62 77 10 80 	movl   $0x80107762,(%esp)
80104a66:	e8 f5 b8 ff ff       	call   80100360 <panic>
80104a6b:	c7 04 24 44 77 10 80 	movl   $0x80107744,(%esp)
80104a72:	e8 e9 b8 ff ff       	call   80100360 <panic>
80104a77:	89 f6                	mov    %esi,%esi
80104a79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104a80 <sys_dup>:
80104a80:	55                   	push   %ebp
80104a81:	31 d2                	xor    %edx,%edx
80104a83:	89 e5                	mov    %esp,%ebp
80104a85:	31 c0                	xor    %eax,%eax
80104a87:	53                   	push   %ebx
80104a88:	83 ec 24             	sub    $0x24,%esp
80104a8b:	8d 4d f4             	lea    -0xc(%ebp),%ecx
80104a8e:	e8 bd fd ff ff       	call   80104850 <argfd>
80104a93:	85 c0                	test   %eax,%eax
80104a95:	78 21                	js     80104ab8 <sys_dup+0x38>
80104a97:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a9a:	e8 21 fe ff ff       	call   801048c0 <fdalloc>
80104a9f:	85 c0                	test   %eax,%eax
80104aa1:	89 c3                	mov    %eax,%ebx
80104aa3:	78 13                	js     80104ab8 <sys_dup+0x38>
80104aa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104aa8:	89 04 24             	mov    %eax,(%esp)
80104aab:	e8 30 c3 ff ff       	call   80100de0 <filedup>
80104ab0:	89 d8                	mov    %ebx,%eax
80104ab2:	83 c4 24             	add    $0x24,%esp
80104ab5:	5b                   	pop    %ebx
80104ab6:	5d                   	pop    %ebp
80104ab7:	c3                   	ret    
80104ab8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104abd:	eb f3                	jmp    80104ab2 <sys_dup+0x32>
80104abf:	90                   	nop

80104ac0 <sys_read>:
80104ac0:	55                   	push   %ebp
80104ac1:	31 d2                	xor    %edx,%edx
80104ac3:	89 e5                	mov    %esp,%ebp
80104ac5:	31 c0                	xor    %eax,%eax
80104ac7:	83 ec 28             	sub    $0x28,%esp
80104aca:	8d 4d ec             	lea    -0x14(%ebp),%ecx
80104acd:	e8 7e fd ff ff       	call   80104850 <argfd>
80104ad2:	85 c0                	test   %eax,%eax
80104ad4:	78 52                	js     80104b28 <sys_read+0x68>
80104ad6:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104ad9:	89 44 24 04          	mov    %eax,0x4(%esp)
80104add:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80104ae4:	e8 27 fc ff ff       	call   80104710 <argint>
80104ae9:	85 c0                	test   %eax,%eax
80104aeb:	78 3b                	js     80104b28 <sys_read+0x68>
80104aed:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104af0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104af7:	89 44 24 08          	mov    %eax,0x8(%esp)
80104afb:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104afe:	89 44 24 04          	mov    %eax,0x4(%esp)
80104b02:	e8 39 fc ff ff       	call   80104740 <argptr>
80104b07:	85 c0                	test   %eax,%eax
80104b09:	78 1d                	js     80104b28 <sys_read+0x68>
80104b0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104b0e:	89 44 24 08          	mov    %eax,0x8(%esp)
80104b12:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b15:	89 44 24 04          	mov    %eax,0x4(%esp)
80104b19:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104b1c:	89 04 24             	mov    %eax,(%esp)
80104b1f:	e8 1c c4 ff ff       	call   80100f40 <fileread>
80104b24:	c9                   	leave  
80104b25:	c3                   	ret    
80104b26:	66 90                	xchg   %ax,%ax
80104b28:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b2d:	c9                   	leave  
80104b2e:	c3                   	ret    
80104b2f:	90                   	nop

80104b30 <sys_write>:
80104b30:	55                   	push   %ebp
80104b31:	31 d2                	xor    %edx,%edx
80104b33:	89 e5                	mov    %esp,%ebp
80104b35:	31 c0                	xor    %eax,%eax
80104b37:	83 ec 28             	sub    $0x28,%esp
80104b3a:	8d 4d ec             	lea    -0x14(%ebp),%ecx
80104b3d:	e8 0e fd ff ff       	call   80104850 <argfd>
80104b42:	85 c0                	test   %eax,%eax
80104b44:	78 52                	js     80104b98 <sys_write+0x68>
80104b46:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104b49:	89 44 24 04          	mov    %eax,0x4(%esp)
80104b4d:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80104b54:	e8 b7 fb ff ff       	call   80104710 <argint>
80104b59:	85 c0                	test   %eax,%eax
80104b5b:	78 3b                	js     80104b98 <sys_write+0x68>
80104b5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104b60:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104b67:	89 44 24 08          	mov    %eax,0x8(%esp)
80104b6b:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104b6e:	89 44 24 04          	mov    %eax,0x4(%esp)
80104b72:	e8 c9 fb ff ff       	call   80104740 <argptr>
80104b77:	85 c0                	test   %eax,%eax
80104b79:	78 1d                	js     80104b98 <sys_write+0x68>
80104b7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104b7e:	89 44 24 08          	mov    %eax,0x8(%esp)
80104b82:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b85:	89 44 24 04          	mov    %eax,0x4(%esp)
80104b89:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104b8c:	89 04 24             	mov    %eax,(%esp)
80104b8f:	e8 4c c4 ff ff       	call   80100fe0 <filewrite>
80104b94:	c9                   	leave  
80104b95:	c3                   	ret    
80104b96:	66 90                	xchg   %ax,%ax
80104b98:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b9d:	c9                   	leave  
80104b9e:	c3                   	ret    
80104b9f:	90                   	nop

80104ba0 <sys_close>:
80104ba0:	55                   	push   %ebp
80104ba1:	31 c0                	xor    %eax,%eax
80104ba3:	89 e5                	mov    %esp,%ebp
80104ba5:	83 ec 18             	sub    $0x18,%esp
80104ba8:	8d 4d f4             	lea    -0xc(%ebp),%ecx
80104bab:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104bae:	e8 9d fc ff ff       	call   80104850 <argfd>
80104bb3:	85 c0                	test   %eax,%eax
80104bb5:	78 19                	js     80104bd0 <sys_close+0x30>
80104bb7:	e8 44 ec ff ff       	call   80103800 <myproc>
80104bbc:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104bbf:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104bc6:	00 
80104bc7:	31 c0                	xor    %eax,%eax
80104bc9:	c9                   	leave  
80104bca:	c3                   	ret    
80104bcb:	90                   	nop
80104bcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104bd0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104bd5:	c9                   	leave  
80104bd6:	c3                   	ret    
80104bd7:	89 f6                	mov    %esi,%esi
80104bd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104be0 <sys_fstat>:
80104be0:	55                   	push   %ebp
80104be1:	31 d2                	xor    %edx,%edx
80104be3:	89 e5                	mov    %esp,%ebp
80104be5:	31 c0                	xor    %eax,%eax
80104be7:	83 ec 28             	sub    $0x28,%esp
80104bea:	8d 4d f0             	lea    -0x10(%ebp),%ecx
80104bed:	e8 5e fc ff ff       	call   80104850 <argfd>
80104bf2:	85 c0                	test   %eax,%eax
80104bf4:	78 3a                	js     80104c30 <sys_fstat+0x50>
80104bf6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104bf9:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80104c00:	00 
80104c01:	89 44 24 04          	mov    %eax,0x4(%esp)
80104c05:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104c0c:	e8 2f fb ff ff       	call   80104740 <argptr>
80104c11:	85 c0                	test   %eax,%eax
80104c13:	78 1b                	js     80104c30 <sys_fstat+0x50>
80104c15:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c18:	89 44 24 04          	mov    %eax,0x4(%esp)
80104c1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104c1f:	89 04 24             	mov    %eax,(%esp)
80104c22:	e8 c9 c2 ff ff       	call   80100ef0 <filestat>
80104c27:	c9                   	leave  
80104c28:	c3                   	ret    
80104c29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c35:	c9                   	leave  
80104c36:	c3                   	ret    
80104c37:	89 f6                	mov    %esi,%esi
80104c39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c40 <sys_link>:
80104c40:	55                   	push   %ebp
80104c41:	89 e5                	mov    %esp,%ebp
80104c43:	57                   	push   %edi
80104c44:	56                   	push   %esi
80104c45:	53                   	push   %ebx
80104c46:	83 ec 3c             	sub    $0x3c,%esp
80104c49:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104c4c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104c50:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104c57:	e8 44 fb ff ff       	call   801047a0 <argstr>
80104c5c:	85 c0                	test   %eax,%eax
80104c5e:	0f 88 de 00 00 00    	js     80104d42 <sys_link+0x102>
80104c64:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104c67:	89 44 24 04          	mov    %eax,0x4(%esp)
80104c6b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104c72:	e8 29 fb ff ff       	call   801047a0 <argstr>
80104c77:	85 c0                	test   %eax,%eax
80104c79:	0f 88 c3 00 00 00    	js     80104d42 <sys_link+0x102>
80104c7f:	e8 bc df ff ff       	call   80102c40 <begin_op>
80104c84:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80104c87:	89 04 24             	mov    %eax,(%esp)
80104c8a:	e8 81 d3 ff ff       	call   80102010 <namei>
80104c8f:	85 c0                	test   %eax,%eax
80104c91:	89 c3                	mov    %eax,%ebx
80104c93:	0f 84 a4 00 00 00    	je     80104d3d <sys_link+0xfd>
80104c99:	89 04 24             	mov    %eax,(%esp)
80104c9c:	e8 1f cb ff ff       	call   801017c0 <ilock>
80104ca1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104ca6:	0f 84 89 00 00 00    	je     80104d35 <sys_link+0xf5>
80104cac:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
80104cb1:	8d 7d da             	lea    -0x26(%ebp),%edi
80104cb4:	89 1c 24             	mov    %ebx,(%esp)
80104cb7:	e8 44 ca ff ff       	call   80101700 <iupdate>
80104cbc:	8b 45 d0             	mov    -0x30(%ebp),%eax
80104cbf:	89 7c 24 04          	mov    %edi,0x4(%esp)
80104cc3:	89 04 24             	mov    %eax,(%esp)
80104cc6:	e8 65 d3 ff ff       	call   80102030 <nameiparent>
80104ccb:	85 c0                	test   %eax,%eax
80104ccd:	89 c6                	mov    %eax,%esi
80104ccf:	74 4f                	je     80104d20 <sys_link+0xe0>
80104cd1:	89 04 24             	mov    %eax,(%esp)
80104cd4:	e8 e7 ca ff ff       	call   801017c0 <ilock>
80104cd9:	8b 03                	mov    (%ebx),%eax
80104cdb:	39 06                	cmp    %eax,(%esi)
80104cdd:	75 39                	jne    80104d18 <sys_link+0xd8>
80104cdf:	8b 43 04             	mov    0x4(%ebx),%eax
80104ce2:	89 7c 24 04          	mov    %edi,0x4(%esp)
80104ce6:	89 34 24             	mov    %esi,(%esp)
80104ce9:	89 44 24 08          	mov    %eax,0x8(%esp)
80104ced:	e8 3e d2 ff ff       	call   80101f30 <dirlink>
80104cf2:	85 c0                	test   %eax,%eax
80104cf4:	78 22                	js     80104d18 <sys_link+0xd8>
80104cf6:	89 34 24             	mov    %esi,(%esp)
80104cf9:	e8 22 cd ff ff       	call   80101a20 <iunlockput>
80104cfe:	89 1c 24             	mov    %ebx,(%esp)
80104d01:	e8 da cb ff ff       	call   801018e0 <iput>
80104d06:	e8 a5 df ff ff       	call   80102cb0 <end_op>
80104d0b:	83 c4 3c             	add    $0x3c,%esp
80104d0e:	31 c0                	xor    %eax,%eax
80104d10:	5b                   	pop    %ebx
80104d11:	5e                   	pop    %esi
80104d12:	5f                   	pop    %edi
80104d13:	5d                   	pop    %ebp
80104d14:	c3                   	ret    
80104d15:	8d 76 00             	lea    0x0(%esi),%esi
80104d18:	89 34 24             	mov    %esi,(%esp)
80104d1b:	e8 00 cd ff ff       	call   80101a20 <iunlockput>
80104d20:	89 1c 24             	mov    %ebx,(%esp)
80104d23:	e8 98 ca ff ff       	call   801017c0 <ilock>
80104d28:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
80104d2d:	89 1c 24             	mov    %ebx,(%esp)
80104d30:	e8 cb c9 ff ff       	call   80101700 <iupdate>
80104d35:	89 1c 24             	mov    %ebx,(%esp)
80104d38:	e8 e3 cc ff ff       	call   80101a20 <iunlockput>
80104d3d:	e8 6e df ff ff       	call   80102cb0 <end_op>
80104d42:	83 c4 3c             	add    $0x3c,%esp
80104d45:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d4a:	5b                   	pop    %ebx
80104d4b:	5e                   	pop    %esi
80104d4c:	5f                   	pop    %edi
80104d4d:	5d                   	pop    %ebp
80104d4e:	c3                   	ret    
80104d4f:	90                   	nop

80104d50 <sys_unlink>:
80104d50:	55                   	push   %ebp
80104d51:	89 e5                	mov    %esp,%ebp
80104d53:	57                   	push   %edi
80104d54:	56                   	push   %esi
80104d55:	53                   	push   %ebx
80104d56:	83 ec 5c             	sub    $0x5c,%esp
80104d59:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104d5c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104d60:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104d67:	e8 34 fa ff ff       	call   801047a0 <argstr>
80104d6c:	85 c0                	test   %eax,%eax
80104d6e:	0f 88 76 01 00 00    	js     80104eea <sys_unlink+0x19a>
80104d74:	e8 c7 de ff ff       	call   80102c40 <begin_op>
80104d79:	8b 45 c0             	mov    -0x40(%ebp),%eax
80104d7c:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80104d7f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104d83:	89 04 24             	mov    %eax,(%esp)
80104d86:	e8 a5 d2 ff ff       	call   80102030 <nameiparent>
80104d8b:	85 c0                	test   %eax,%eax
80104d8d:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80104d90:	0f 84 4f 01 00 00    	je     80104ee5 <sys_unlink+0x195>
80104d96:	8b 75 b4             	mov    -0x4c(%ebp),%esi
80104d99:	89 34 24             	mov    %esi,(%esp)
80104d9c:	e8 1f ca ff ff       	call   801017c0 <ilock>
80104da1:	c7 44 24 04 60 77 10 	movl   $0x80107760,0x4(%esp)
80104da8:	80 
80104da9:	89 1c 24             	mov    %ebx,(%esp)
80104dac:	e8 ef ce ff ff       	call   80101ca0 <namecmp>
80104db1:	85 c0                	test   %eax,%eax
80104db3:	0f 84 21 01 00 00    	je     80104eda <sys_unlink+0x18a>
80104db9:	c7 44 24 04 5f 77 10 	movl   $0x8010775f,0x4(%esp)
80104dc0:	80 
80104dc1:	89 1c 24             	mov    %ebx,(%esp)
80104dc4:	e8 d7 ce ff ff       	call   80101ca0 <namecmp>
80104dc9:	85 c0                	test   %eax,%eax
80104dcb:	0f 84 09 01 00 00    	je     80104eda <sys_unlink+0x18a>
80104dd1:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104dd4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104dd8:	89 44 24 08          	mov    %eax,0x8(%esp)
80104ddc:	89 34 24             	mov    %esi,(%esp)
80104ddf:	e8 ec ce ff ff       	call   80101cd0 <dirlookup>
80104de4:	85 c0                	test   %eax,%eax
80104de6:	89 c3                	mov    %eax,%ebx
80104de8:	0f 84 ec 00 00 00    	je     80104eda <sys_unlink+0x18a>
80104dee:	89 04 24             	mov    %eax,(%esp)
80104df1:	e8 ca c9 ff ff       	call   801017c0 <ilock>
80104df6:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80104dfb:	0f 8e 24 01 00 00    	jle    80104f25 <sys_unlink+0x1d5>
80104e01:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104e06:	8d 75 d8             	lea    -0x28(%ebp),%esi
80104e09:	74 7d                	je     80104e88 <sys_unlink+0x138>
80104e0b:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80104e12:	00 
80104e13:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80104e1a:	00 
80104e1b:	89 34 24             	mov    %esi,(%esp)
80104e1e:	e8 ed f5 ff ff       	call   80104410 <memset>
80104e23:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80104e26:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80104e2d:	00 
80104e2e:	89 74 24 04          	mov    %esi,0x4(%esp)
80104e32:	89 44 24 08          	mov    %eax,0x8(%esp)
80104e36:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104e39:	89 04 24             	mov    %eax,(%esp)
80104e3c:	e8 2f cd ff ff       	call   80101b70 <writei>
80104e41:	83 f8 10             	cmp    $0x10,%eax
80104e44:	0f 85 cf 00 00 00    	jne    80104f19 <sys_unlink+0x1c9>
80104e4a:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104e4f:	0f 84 a3 00 00 00    	je     80104ef8 <sys_unlink+0x1a8>
80104e55:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104e58:	89 04 24             	mov    %eax,(%esp)
80104e5b:	e8 c0 cb ff ff       	call   80101a20 <iunlockput>
80104e60:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
80104e65:	89 1c 24             	mov    %ebx,(%esp)
80104e68:	e8 93 c8 ff ff       	call   80101700 <iupdate>
80104e6d:	89 1c 24             	mov    %ebx,(%esp)
80104e70:	e8 ab cb ff ff       	call   80101a20 <iunlockput>
80104e75:	e8 36 de ff ff       	call   80102cb0 <end_op>
80104e7a:	83 c4 5c             	add    $0x5c,%esp
80104e7d:	31 c0                	xor    %eax,%eax
80104e7f:	5b                   	pop    %ebx
80104e80:	5e                   	pop    %esi
80104e81:	5f                   	pop    %edi
80104e82:	5d                   	pop    %ebp
80104e83:	c3                   	ret    
80104e84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e88:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80104e8c:	0f 86 79 ff ff ff    	jbe    80104e0b <sys_unlink+0xbb>
80104e92:	bf 20 00 00 00       	mov    $0x20,%edi
80104e97:	eb 15                	jmp    80104eae <sys_unlink+0x15e>
80104e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ea0:	8d 57 10             	lea    0x10(%edi),%edx
80104ea3:	3b 53 58             	cmp    0x58(%ebx),%edx
80104ea6:	0f 83 5f ff ff ff    	jae    80104e0b <sys_unlink+0xbb>
80104eac:	89 d7                	mov    %edx,%edi
80104eae:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80104eb5:	00 
80104eb6:	89 7c 24 08          	mov    %edi,0x8(%esp)
80104eba:	89 74 24 04          	mov    %esi,0x4(%esp)
80104ebe:	89 1c 24             	mov    %ebx,(%esp)
80104ec1:	e8 aa cb ff ff       	call   80101a70 <readi>
80104ec6:	83 f8 10             	cmp    $0x10,%eax
80104ec9:	75 42                	jne    80104f0d <sys_unlink+0x1bd>
80104ecb:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80104ed0:	74 ce                	je     80104ea0 <sys_unlink+0x150>
80104ed2:	89 1c 24             	mov    %ebx,(%esp)
80104ed5:	e8 46 cb ff ff       	call   80101a20 <iunlockput>
80104eda:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104edd:	89 04 24             	mov    %eax,(%esp)
80104ee0:	e8 3b cb ff ff       	call   80101a20 <iunlockput>
80104ee5:	e8 c6 dd ff ff       	call   80102cb0 <end_op>
80104eea:	83 c4 5c             	add    $0x5c,%esp
80104eed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ef2:	5b                   	pop    %ebx
80104ef3:	5e                   	pop    %esi
80104ef4:	5f                   	pop    %edi
80104ef5:	5d                   	pop    %ebp
80104ef6:	c3                   	ret    
80104ef7:	90                   	nop
80104ef8:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104efb:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
80104f00:	89 04 24             	mov    %eax,(%esp)
80104f03:	e8 f8 c7 ff ff       	call   80101700 <iupdate>
80104f08:	e9 48 ff ff ff       	jmp    80104e55 <sys_unlink+0x105>
80104f0d:	c7 04 24 84 77 10 80 	movl   $0x80107784,(%esp)
80104f14:	e8 47 b4 ff ff       	call   80100360 <panic>
80104f19:	c7 04 24 96 77 10 80 	movl   $0x80107796,(%esp)
80104f20:	e8 3b b4 ff ff       	call   80100360 <panic>
80104f25:	c7 04 24 72 77 10 80 	movl   $0x80107772,(%esp)
80104f2c:	e8 2f b4 ff ff       	call   80100360 <panic>
80104f31:	eb 0d                	jmp    80104f40 <sys_open>
80104f33:	90                   	nop
80104f34:	90                   	nop
80104f35:	90                   	nop
80104f36:	90                   	nop
80104f37:	90                   	nop
80104f38:	90                   	nop
80104f39:	90                   	nop
80104f3a:	90                   	nop
80104f3b:	90                   	nop
80104f3c:	90                   	nop
80104f3d:	90                   	nop
80104f3e:	90                   	nop
80104f3f:	90                   	nop

80104f40 <sys_open>:
80104f40:	55                   	push   %ebp
80104f41:	89 e5                	mov    %esp,%ebp
80104f43:	57                   	push   %edi
80104f44:	56                   	push   %esi
80104f45:	53                   	push   %ebx
80104f46:	83 ec 2c             	sub    $0x2c,%esp
80104f49:	8d 45 e0             	lea    -0x20(%ebp),%eax
80104f4c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104f50:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104f57:	e8 44 f8 ff ff       	call   801047a0 <argstr>
80104f5c:	85 c0                	test   %eax,%eax
80104f5e:	0f 88 d1 00 00 00    	js     80105035 <sys_open+0xf5>
80104f64:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80104f67:	89 44 24 04          	mov    %eax,0x4(%esp)
80104f6b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104f72:	e8 99 f7 ff ff       	call   80104710 <argint>
80104f77:	85 c0                	test   %eax,%eax
80104f79:	0f 88 b6 00 00 00    	js     80105035 <sys_open+0xf5>
80104f7f:	e8 bc dc ff ff       	call   80102c40 <begin_op>
80104f84:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80104f88:	0f 85 82 00 00 00    	jne    80105010 <sys_open+0xd0>
80104f8e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104f91:	89 04 24             	mov    %eax,(%esp)
80104f94:	e8 77 d0 ff ff       	call   80102010 <namei>
80104f99:	85 c0                	test   %eax,%eax
80104f9b:	89 c6                	mov    %eax,%esi
80104f9d:	0f 84 8d 00 00 00    	je     80105030 <sys_open+0xf0>
80104fa3:	89 04 24             	mov    %eax,(%esp)
80104fa6:	e8 15 c8 ff ff       	call   801017c0 <ilock>
80104fab:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80104fb0:	0f 84 92 00 00 00    	je     80105048 <sys_open+0x108>
80104fb6:	e8 b5 bd ff ff       	call   80100d70 <filealloc>
80104fbb:	85 c0                	test   %eax,%eax
80104fbd:	89 c3                	mov    %eax,%ebx
80104fbf:	0f 84 93 00 00 00    	je     80105058 <sys_open+0x118>
80104fc5:	e8 f6 f8 ff ff       	call   801048c0 <fdalloc>
80104fca:	85 c0                	test   %eax,%eax
80104fcc:	89 c7                	mov    %eax,%edi
80104fce:	0f 88 94 00 00 00    	js     80105068 <sys_open+0x128>
80104fd4:	89 34 24             	mov    %esi,(%esp)
80104fd7:	e8 c4 c8 ff ff       	call   801018a0 <iunlock>
80104fdc:	e8 cf dc ff ff       	call   80102cb0 <end_op>
80104fe1:	c7 03 02 00 00 00    	movl   $0x2,(%ebx)
80104fe7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104fea:	89 73 10             	mov    %esi,0x10(%ebx)
80104fed:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
80104ff4:	89 c2                	mov    %eax,%edx
80104ff6:	83 e2 01             	and    $0x1,%edx
80104ff9:	83 f2 01             	xor    $0x1,%edx
80104ffc:	a8 03                	test   $0x3,%al
80104ffe:	88 53 08             	mov    %dl,0x8(%ebx)
80105001:	89 f8                	mov    %edi,%eax
80105003:	0f 95 43 09          	setne  0x9(%ebx)
80105007:	83 c4 2c             	add    $0x2c,%esp
8010500a:	5b                   	pop    %ebx
8010500b:	5e                   	pop    %esi
8010500c:	5f                   	pop    %edi
8010500d:	5d                   	pop    %ebp
8010500e:	c3                   	ret    
8010500f:	90                   	nop
80105010:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105013:	31 c9                	xor    %ecx,%ecx
80105015:	ba 02 00 00 00       	mov    $0x2,%edx
8010501a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105021:	e8 da f8 ff ff       	call   80104900 <create>
80105026:	85 c0                	test   %eax,%eax
80105028:	89 c6                	mov    %eax,%esi
8010502a:	75 8a                	jne    80104fb6 <sys_open+0x76>
8010502c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105030:	e8 7b dc ff ff       	call   80102cb0 <end_op>
80105035:	83 c4 2c             	add    $0x2c,%esp
80105038:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010503d:	5b                   	pop    %ebx
8010503e:	5e                   	pop    %esi
8010503f:	5f                   	pop    %edi
80105040:	5d                   	pop    %ebp
80105041:	c3                   	ret    
80105042:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105048:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010504b:	85 c0                	test   %eax,%eax
8010504d:	0f 84 63 ff ff ff    	je     80104fb6 <sys_open+0x76>
80105053:	90                   	nop
80105054:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105058:	89 34 24             	mov    %esi,(%esp)
8010505b:	e8 c0 c9 ff ff       	call   80101a20 <iunlockput>
80105060:	eb ce                	jmp    80105030 <sys_open+0xf0>
80105062:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105068:	89 1c 24             	mov    %ebx,(%esp)
8010506b:	e8 c0 bd ff ff       	call   80100e30 <fileclose>
80105070:	eb e6                	jmp    80105058 <sys_open+0x118>
80105072:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105079:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105080 <sys_mkdir>:
80105080:	55                   	push   %ebp
80105081:	89 e5                	mov    %esp,%ebp
80105083:	83 ec 28             	sub    $0x28,%esp
80105086:	e8 b5 db ff ff       	call   80102c40 <begin_op>
8010508b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010508e:	89 44 24 04          	mov    %eax,0x4(%esp)
80105092:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105099:	e8 02 f7 ff ff       	call   801047a0 <argstr>
8010509e:	85 c0                	test   %eax,%eax
801050a0:	78 2e                	js     801050d0 <sys_mkdir+0x50>
801050a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050a5:	31 c9                	xor    %ecx,%ecx
801050a7:	ba 01 00 00 00       	mov    $0x1,%edx
801050ac:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801050b3:	e8 48 f8 ff ff       	call   80104900 <create>
801050b8:	85 c0                	test   %eax,%eax
801050ba:	74 14                	je     801050d0 <sys_mkdir+0x50>
801050bc:	89 04 24             	mov    %eax,(%esp)
801050bf:	e8 5c c9 ff ff       	call   80101a20 <iunlockput>
801050c4:	e8 e7 db ff ff       	call   80102cb0 <end_op>
801050c9:	31 c0                	xor    %eax,%eax
801050cb:	c9                   	leave  
801050cc:	c3                   	ret    
801050cd:	8d 76 00             	lea    0x0(%esi),%esi
801050d0:	e8 db db ff ff       	call   80102cb0 <end_op>
801050d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050da:	c9                   	leave  
801050db:	c3                   	ret    
801050dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801050e0 <sys_mknod>:
801050e0:	55                   	push   %ebp
801050e1:	89 e5                	mov    %esp,%ebp
801050e3:	83 ec 28             	sub    $0x28,%esp
801050e6:	e8 55 db ff ff       	call   80102c40 <begin_op>
801050eb:	8d 45 ec             	lea    -0x14(%ebp),%eax
801050ee:	89 44 24 04          	mov    %eax,0x4(%esp)
801050f2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801050f9:	e8 a2 f6 ff ff       	call   801047a0 <argstr>
801050fe:	85 c0                	test   %eax,%eax
80105100:	78 5e                	js     80105160 <sys_mknod+0x80>
80105102:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105105:	89 44 24 04          	mov    %eax,0x4(%esp)
80105109:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105110:	e8 fb f5 ff ff       	call   80104710 <argint>
80105115:	85 c0                	test   %eax,%eax
80105117:	78 47                	js     80105160 <sys_mknod+0x80>
80105119:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010511c:	89 44 24 04          	mov    %eax,0x4(%esp)
80105120:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80105127:	e8 e4 f5 ff ff       	call   80104710 <argint>
8010512c:	85 c0                	test   %eax,%eax
8010512e:	78 30                	js     80105160 <sys_mknod+0x80>
80105130:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80105134:	ba 03 00 00 00       	mov    $0x3,%edx
80105139:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
8010513d:	89 04 24             	mov    %eax,(%esp)
80105140:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105143:	e8 b8 f7 ff ff       	call   80104900 <create>
80105148:	85 c0                	test   %eax,%eax
8010514a:	74 14                	je     80105160 <sys_mknod+0x80>
8010514c:	89 04 24             	mov    %eax,(%esp)
8010514f:	e8 cc c8 ff ff       	call   80101a20 <iunlockput>
80105154:	e8 57 db ff ff       	call   80102cb0 <end_op>
80105159:	31 c0                	xor    %eax,%eax
8010515b:	c9                   	leave  
8010515c:	c3                   	ret    
8010515d:	8d 76 00             	lea    0x0(%esi),%esi
80105160:	e8 4b db ff ff       	call   80102cb0 <end_op>
80105165:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010516a:	c9                   	leave  
8010516b:	c3                   	ret    
8010516c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105170 <sys_chdir>:
80105170:	55                   	push   %ebp
80105171:	89 e5                	mov    %esp,%ebp
80105173:	56                   	push   %esi
80105174:	53                   	push   %ebx
80105175:	83 ec 20             	sub    $0x20,%esp
80105178:	e8 83 e6 ff ff       	call   80103800 <myproc>
8010517d:	89 c6                	mov    %eax,%esi
8010517f:	e8 bc da ff ff       	call   80102c40 <begin_op>
80105184:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105187:	89 44 24 04          	mov    %eax,0x4(%esp)
8010518b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105192:	e8 09 f6 ff ff       	call   801047a0 <argstr>
80105197:	85 c0                	test   %eax,%eax
80105199:	78 4a                	js     801051e5 <sys_chdir+0x75>
8010519b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010519e:	89 04 24             	mov    %eax,(%esp)
801051a1:	e8 6a ce ff ff       	call   80102010 <namei>
801051a6:	85 c0                	test   %eax,%eax
801051a8:	89 c3                	mov    %eax,%ebx
801051aa:	74 39                	je     801051e5 <sys_chdir+0x75>
801051ac:	89 04 24             	mov    %eax,(%esp)
801051af:	e8 0c c6 ff ff       	call   801017c0 <ilock>
801051b4:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801051b9:	89 1c 24             	mov    %ebx,(%esp)
801051bc:	75 22                	jne    801051e0 <sys_chdir+0x70>
801051be:	e8 dd c6 ff ff       	call   801018a0 <iunlock>
801051c3:	8b 46 68             	mov    0x68(%esi),%eax
801051c6:	89 04 24             	mov    %eax,(%esp)
801051c9:	e8 12 c7 ff ff       	call   801018e0 <iput>
801051ce:	e8 dd da ff ff       	call   80102cb0 <end_op>
801051d3:	31 c0                	xor    %eax,%eax
801051d5:	89 5e 68             	mov    %ebx,0x68(%esi)
801051d8:	83 c4 20             	add    $0x20,%esp
801051db:	5b                   	pop    %ebx
801051dc:	5e                   	pop    %esi
801051dd:	5d                   	pop    %ebp
801051de:	c3                   	ret    
801051df:	90                   	nop
801051e0:	e8 3b c8 ff ff       	call   80101a20 <iunlockput>
801051e5:	e8 c6 da ff ff       	call   80102cb0 <end_op>
801051ea:	83 c4 20             	add    $0x20,%esp
801051ed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051f2:	5b                   	pop    %ebx
801051f3:	5e                   	pop    %esi
801051f4:	5d                   	pop    %ebp
801051f5:	c3                   	ret    
801051f6:	8d 76 00             	lea    0x0(%esi),%esi
801051f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105200 <sys_exec>:
80105200:	55                   	push   %ebp
80105201:	89 e5                	mov    %esp,%ebp
80105203:	57                   	push   %edi
80105204:	56                   	push   %esi
80105205:	53                   	push   %ebx
80105206:	81 ec ac 00 00 00    	sub    $0xac,%esp
8010520c:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
80105212:	89 44 24 04          	mov    %eax,0x4(%esp)
80105216:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010521d:	e8 7e f5 ff ff       	call   801047a0 <argstr>
80105222:	85 c0                	test   %eax,%eax
80105224:	0f 88 84 00 00 00    	js     801052ae <sys_exec+0xae>
8010522a:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105230:	89 44 24 04          	mov    %eax,0x4(%esp)
80105234:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010523b:	e8 d0 f4 ff ff       	call   80104710 <argint>
80105240:	85 c0                	test   %eax,%eax
80105242:	78 6a                	js     801052ae <sys_exec+0xae>
80105244:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
8010524a:	31 db                	xor    %ebx,%ebx
8010524c:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
80105253:	00 
80105254:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
8010525a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105261:	00 
80105262:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105268:	89 04 24             	mov    %eax,(%esp)
8010526b:	e8 a0 f1 ff ff       	call   80104410 <memset>
80105270:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105276:	89 7c 24 04          	mov    %edi,0x4(%esp)
8010527a:	8d 04 98             	lea    (%eax,%ebx,4),%eax
8010527d:	89 04 24             	mov    %eax,(%esp)
80105280:	e8 eb f3 ff ff       	call   80104670 <fetchint>
80105285:	85 c0                	test   %eax,%eax
80105287:	78 25                	js     801052ae <sys_exec+0xae>
80105289:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010528f:	85 c0                	test   %eax,%eax
80105291:	74 2d                	je     801052c0 <sys_exec+0xc0>
80105293:	89 74 24 04          	mov    %esi,0x4(%esp)
80105297:	89 04 24             	mov    %eax,(%esp)
8010529a:	e8 11 f4 ff ff       	call   801046b0 <fetchstr>
8010529f:	85 c0                	test   %eax,%eax
801052a1:	78 0b                	js     801052ae <sys_exec+0xae>
801052a3:	83 c3 01             	add    $0x1,%ebx
801052a6:	83 c6 04             	add    $0x4,%esi
801052a9:	83 fb 20             	cmp    $0x20,%ebx
801052ac:	75 c2                	jne    80105270 <sys_exec+0x70>
801052ae:	81 c4 ac 00 00 00    	add    $0xac,%esp
801052b4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052b9:	5b                   	pop    %ebx
801052ba:	5e                   	pop    %esi
801052bb:	5f                   	pop    %edi
801052bc:	5d                   	pop    %ebp
801052bd:	c3                   	ret    
801052be:	66 90                	xchg   %ax,%ax
801052c0:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801052c6:	89 44 24 04          	mov    %eax,0x4(%esp)
801052ca:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
801052d0:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801052d7:	00 00 00 00 
801052db:	89 04 24             	mov    %eax,(%esp)
801052de:	e8 bd b6 ff ff       	call   801009a0 <exec>
801052e3:	81 c4 ac 00 00 00    	add    $0xac,%esp
801052e9:	5b                   	pop    %ebx
801052ea:	5e                   	pop    %esi
801052eb:	5f                   	pop    %edi
801052ec:	5d                   	pop    %ebp
801052ed:	c3                   	ret    
801052ee:	66 90                	xchg   %ax,%ax

801052f0 <sys_pipe>:
801052f0:	55                   	push   %ebp
801052f1:	89 e5                	mov    %esp,%ebp
801052f3:	53                   	push   %ebx
801052f4:	83 ec 24             	sub    $0x24,%esp
801052f7:	8d 45 ec             	lea    -0x14(%ebp),%eax
801052fa:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
80105301:	00 
80105302:	89 44 24 04          	mov    %eax,0x4(%esp)
80105306:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010530d:	e8 2e f4 ff ff       	call   80104740 <argptr>
80105312:	85 c0                	test   %eax,%eax
80105314:	78 6d                	js     80105383 <sys_pipe+0x93>
80105316:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105319:	89 44 24 04          	mov    %eax,0x4(%esp)
8010531d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105320:	89 04 24             	mov    %eax,(%esp)
80105323:	e8 98 df ff ff       	call   801032c0 <pipealloc>
80105328:	85 c0                	test   %eax,%eax
8010532a:	78 57                	js     80105383 <sys_pipe+0x93>
8010532c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010532f:	e8 8c f5 ff ff       	call   801048c0 <fdalloc>
80105334:	85 c0                	test   %eax,%eax
80105336:	89 c3                	mov    %eax,%ebx
80105338:	78 33                	js     8010536d <sys_pipe+0x7d>
8010533a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010533d:	e8 7e f5 ff ff       	call   801048c0 <fdalloc>
80105342:	85 c0                	test   %eax,%eax
80105344:	78 1a                	js     80105360 <sys_pipe+0x70>
80105346:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105349:	89 1a                	mov    %ebx,(%edx)
8010534b:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010534e:	89 42 04             	mov    %eax,0x4(%edx)
80105351:	83 c4 24             	add    $0x24,%esp
80105354:	31 c0                	xor    %eax,%eax
80105356:	5b                   	pop    %ebx
80105357:	5d                   	pop    %ebp
80105358:	c3                   	ret    
80105359:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105360:	e8 9b e4 ff ff       	call   80103800 <myproc>
80105365:	c7 44 98 28 00 00 00 	movl   $0x0,0x28(%eax,%ebx,4)
8010536c:	00 
8010536d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105370:	89 04 24             	mov    %eax,(%esp)
80105373:	e8 b8 ba ff ff       	call   80100e30 <fileclose>
80105378:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010537b:	89 04 24             	mov    %eax,(%esp)
8010537e:	e8 ad ba ff ff       	call   80100e30 <fileclose>
80105383:	83 c4 24             	add    $0x24,%esp
80105386:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010538b:	5b                   	pop    %ebx
8010538c:	5d                   	pop    %ebp
8010538d:	c3                   	ret    
8010538e:	66 90                	xchg   %ax,%ax

80105390 <sys_dup2>:
80105390:	55                   	push   %ebp
80105391:	31 c0                	xor    %eax,%eax
80105393:	89 e5                	mov    %esp,%ebp
80105395:	83 ec 28             	sub    $0x28,%esp
80105398:	8d 4d f0             	lea    -0x10(%ebp),%ecx
8010539b:	8d 55 e8             	lea    -0x18(%ebp),%edx
8010539e:	e8 ad f4 ff ff       	call   80104850 <argfd>
801053a3:	85 c0                	test   %eax,%eax
801053a5:	78 61                	js     80105408 <sys_dup2+0x78>
801053a7:	8d 4d f4             	lea    -0xc(%ebp),%ecx
801053aa:	b8 01 00 00 00       	mov    $0x1,%eax
801053af:	8d 55 ec             	lea    -0x14(%ebp),%edx
801053b2:	e8 99 f4 ff ff       	call   80104850 <argfd>
801053b7:	85 c0                	test   %eax,%eax
801053b9:	78 4d                	js     80105408 <sys_dup2+0x78>
801053bb:	e8 40 e4 ff ff       	call   80103800 <myproc>
801053c0:	8b 55 ec             	mov    -0x14(%ebp),%edx
801053c3:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
801053ca:	00 
801053cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053ce:	89 04 24             	mov    %eax,(%esp)
801053d1:	e8 5a ba ff ff       	call   80100e30 <fileclose>
801053d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053d9:	e8 e2 f4 ff ff       	call   801048c0 <fdalloc>
801053de:	85 c0                	test   %eax,%eax
801053e0:	89 45 ec             	mov    %eax,-0x14(%ebp)
801053e3:	78 13                	js     801053f8 <sys_dup2+0x68>
801053e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053e8:	89 04 24             	mov    %eax,(%esp)
801053eb:	e8 f0 b9 ff ff       	call   80100de0 <filedup>
801053f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801053f3:	c9                   	leave  
801053f4:	c3                   	ret    
801053f5:	8d 76 00             	lea    0x0(%esi),%esi
801053f8:	c7 04 24 a5 77 10 80 	movl   $0x801077a5,(%esp)
801053ff:	e8 4c b2 ff ff       	call   80100650 <cprintf>
80105404:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105408:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010540d:	c9                   	leave  
8010540e:	c3                   	ret    
	...

80105410 <sys_fork>:
80105410:	55                   	push   %ebp
80105411:	89 e5                	mov    %esp,%ebp
80105413:	5d                   	pop    %ebp
80105414:	e9 97 e5 ff ff       	jmp    801039b0 <fork>
80105419:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105420 <sys_exit>:
80105420:	55                   	push   %ebp
80105421:	89 e5                	mov    %esp,%ebp
80105423:	83 ec 08             	sub    $0x8,%esp
80105426:	e8 d5 e7 ff ff       	call   80103c00 <exit>
8010542b:	31 c0                	xor    %eax,%eax
8010542d:	c9                   	leave  
8010542e:	c3                   	ret    
8010542f:	90                   	nop

80105430 <sys_wait>:
80105430:	55                   	push   %ebp
80105431:	89 e5                	mov    %esp,%ebp
80105433:	5d                   	pop    %ebp
80105434:	e9 e7 e9 ff ff       	jmp    80103e20 <wait>
80105439:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105440 <sys_kill>:
80105440:	55                   	push   %ebp
80105441:	89 e5                	mov    %esp,%ebp
80105443:	83 ec 28             	sub    $0x28,%esp
80105446:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105449:	89 44 24 04          	mov    %eax,0x4(%esp)
8010544d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105454:	e8 b7 f2 ff ff       	call   80104710 <argint>
80105459:	85 c0                	test   %eax,%eax
8010545b:	78 13                	js     80105470 <sys_kill+0x30>
8010545d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105460:	89 04 24             	mov    %eax,(%esp)
80105463:	e8 18 eb ff ff       	call   80103f80 <kill>
80105468:	c9                   	leave  
80105469:	c3                   	ret    
8010546a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105470:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105475:	c9                   	leave  
80105476:	c3                   	ret    
80105477:	89 f6                	mov    %esi,%esi
80105479:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105480 <sys_getpid>:
80105480:	55                   	push   %ebp
80105481:	89 e5                	mov    %esp,%ebp
80105483:	83 ec 08             	sub    $0x8,%esp
80105486:	e8 75 e3 ff ff       	call   80103800 <myproc>
8010548b:	8b 40 10             	mov    0x10(%eax),%eax
8010548e:	c9                   	leave  
8010548f:	c3                   	ret    

80105490 <sys_sbrk>:
80105490:	55                   	push   %ebp
80105491:	89 e5                	mov    %esp,%ebp
80105493:	53                   	push   %ebx
80105494:	83 ec 24             	sub    $0x24,%esp
80105497:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010549a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010549e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801054a5:	e8 66 f2 ff ff       	call   80104710 <argint>
801054aa:	85 c0                	test   %eax,%eax
801054ac:	78 1a                	js     801054c8 <sys_sbrk+0x38>
801054ae:	e8 4d e3 ff ff       	call   80103800 <myproc>
801054b3:	8b 18                	mov    (%eax),%ebx
801054b5:	e8 46 e3 ff ff       	call   80103800 <myproc>
801054ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
801054bd:	01 10                	add    %edx,(%eax)
801054bf:	89 d8                	mov    %ebx,%eax
801054c1:	83 c4 24             	add    $0x24,%esp
801054c4:	5b                   	pop    %ebx
801054c5:	5d                   	pop    %ebp
801054c6:	c3                   	ret    
801054c7:	90                   	nop
801054c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054cd:	eb f2                	jmp    801054c1 <sys_sbrk+0x31>
801054cf:	90                   	nop

801054d0 <sys_sleep>:
801054d0:	55                   	push   %ebp
801054d1:	89 e5                	mov    %esp,%ebp
801054d3:	53                   	push   %ebx
801054d4:	83 ec 24             	sub    $0x24,%esp
801054d7:	8d 45 f4             	lea    -0xc(%ebp),%eax
801054da:	89 44 24 04          	mov    %eax,0x4(%esp)
801054de:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801054e5:	e8 26 f2 ff ff       	call   80104710 <argint>
801054ea:	85 c0                	test   %eax,%eax
801054ec:	78 7e                	js     8010556c <sys_sleep+0x9c>
801054ee:	c7 04 24 a0 4e 11 80 	movl   $0x80114ea0,(%esp)
801054f5:	e8 d6 ed ff ff       	call   801042d0 <acquire>
801054fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
801054fd:	8b 1d e0 56 11 80    	mov    0x801156e0,%ebx
80105503:	85 d2                	test   %edx,%edx
80105505:	75 29                	jne    80105530 <sys_sleep+0x60>
80105507:	eb 4f                	jmp    80105558 <sys_sleep+0x88>
80105509:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105510:	c7 44 24 04 a0 4e 11 	movl   $0x80114ea0,0x4(%esp)
80105517:	80 
80105518:	c7 04 24 e0 56 11 80 	movl   $0x801156e0,(%esp)
8010551f:	e8 4c e8 ff ff       	call   80103d70 <sleep>
80105524:	a1 e0 56 11 80       	mov    0x801156e0,%eax
80105529:	29 d8                	sub    %ebx,%eax
8010552b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010552e:	73 28                	jae    80105558 <sys_sleep+0x88>
80105530:	e8 cb e2 ff ff       	call   80103800 <myproc>
80105535:	8b 40 24             	mov    0x24(%eax),%eax
80105538:	85 c0                	test   %eax,%eax
8010553a:	74 d4                	je     80105510 <sys_sleep+0x40>
8010553c:	c7 04 24 a0 4e 11 80 	movl   $0x80114ea0,(%esp)
80105543:	e8 78 ee ff ff       	call   801043c0 <release>
80105548:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010554d:	83 c4 24             	add    $0x24,%esp
80105550:	5b                   	pop    %ebx
80105551:	5d                   	pop    %ebp
80105552:	c3                   	ret    
80105553:	90                   	nop
80105554:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105558:	c7 04 24 a0 4e 11 80 	movl   $0x80114ea0,(%esp)
8010555f:	e8 5c ee ff ff       	call   801043c0 <release>
80105564:	83 c4 24             	add    $0x24,%esp
80105567:	31 c0                	xor    %eax,%eax
80105569:	5b                   	pop    %ebx
8010556a:	5d                   	pop    %ebp
8010556b:	c3                   	ret    
8010556c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105571:	eb da                	jmp    8010554d <sys_sleep+0x7d>
80105573:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105579:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105580 <sys_uptime>:
80105580:	55                   	push   %ebp
80105581:	89 e5                	mov    %esp,%ebp
80105583:	53                   	push   %ebx
80105584:	83 ec 14             	sub    $0x14,%esp
80105587:	c7 04 24 a0 4e 11 80 	movl   $0x80114ea0,(%esp)
8010558e:	e8 3d ed ff ff       	call   801042d0 <acquire>
80105593:	8b 1d e0 56 11 80    	mov    0x801156e0,%ebx
80105599:	c7 04 24 a0 4e 11 80 	movl   $0x80114ea0,(%esp)
801055a0:	e8 1b ee ff ff       	call   801043c0 <release>
801055a5:	83 c4 14             	add    $0x14,%esp
801055a8:	89 d8                	mov    %ebx,%eax
801055aa:	5b                   	pop    %ebx
801055ab:	5d                   	pop    %ebp
801055ac:	c3                   	ret    
801055ad:	8d 76 00             	lea    0x0(%esi),%esi

801055b0 <sys_date>:
801055b0:	55                   	push   %ebp
801055b1:	89 e5                	mov    %esp,%ebp
801055b3:	83 ec 28             	sub    $0x28,%esp
801055b6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801055b9:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
801055c0:	00 
801055c1:	89 44 24 04          	mov    %eax,0x4(%esp)
801055c5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801055cc:	e8 6f f1 ff ff       	call   80104740 <argptr>
801055d1:	85 c0                	test   %eax,%eax
801055d3:	78 13                	js     801055e8 <sys_date+0x38>
801055d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055d8:	89 04 24             	mov    %eax,(%esp)
801055db:	e8 60 d3 ff ff       	call   80102940 <cmostime>
801055e0:	31 c0                	xor    %eax,%eax
801055e2:	c9                   	leave  
801055e3:	c3                   	ret    
801055e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801055e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055ed:	c9                   	leave  
801055ee:	c3                   	ret    
801055ef:	90                   	nop

801055f0 <sys_alarm>:
801055f0:	55                   	push   %ebp
801055f1:	89 e5                	mov    %esp,%ebp
801055f3:	83 ec 28             	sub    $0x28,%esp
801055f6:	8d 45 f0             	lea    -0x10(%ebp),%eax
801055f9:	89 44 24 04          	mov    %eax,0x4(%esp)
801055fd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105604:	e8 07 f1 ff ff       	call   80104710 <argint>
80105609:	85 c0                	test   %eax,%eax
8010560b:	78 43                	js     80105650 <sys_alarm+0x60>
8010560d:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105610:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
80105617:	00 
80105618:	89 44 24 04          	mov    %eax,0x4(%esp)
8010561c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105623:	e8 18 f1 ff ff       	call   80104740 <argptr>
80105628:	85 c0                	test   %eax,%eax
8010562a:	78 24                	js     80105650 <sys_alarm+0x60>
8010562c:	e8 cf e1 ff ff       	call   80103800 <myproc>
80105631:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105634:	89 50 7c             	mov    %edx,0x7c(%eax)
80105637:	e8 c4 e1 ff ff       	call   80103800 <myproc>
8010563c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010563f:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
80105645:	31 c0                	xor    %eax,%eax
80105647:	c9                   	leave  
80105648:	c3                   	ret    
80105649:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105650:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105655:	c9                   	leave  
80105656:	c3                   	ret    
	...

80105658 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105658:	1e                   	push   %ds
  pushl %es
80105659:	06                   	push   %es
  pushl %fs
8010565a:	0f a0                	push   %fs
  pushl %gs
8010565c:	0f a8                	push   %gs
  pushal
8010565e:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
8010565f:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105663:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105665:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105667:	54                   	push   %esp
  call trap
80105668:	e8 e3 00 00 00       	call   80105750 <trap>
  addl $4, %esp
8010566d:	83 c4 04             	add    $0x4,%esp

80105670 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105670:	61                   	popa   
  popl %gs
80105671:	0f a9                	pop    %gs
  popl %fs
80105673:	0f a1                	pop    %fs
  popl %es
80105675:	07                   	pop    %es
  popl %ds
80105676:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105677:	83 c4 08             	add    $0x8,%esp
  iret
8010567a:	cf                   	iret   
8010567b:	00 00                	add    %al,(%eax)
8010567d:	00 00                	add    %al,(%eax)
	...

80105680 <tvinit>:
80105680:	31 c0                	xor    %eax,%eax
80105682:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105688:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
8010568f:	b9 08 00 00 00       	mov    $0x8,%ecx
80105694:	66 89 0c c5 e2 4e 11 	mov    %cx,-0x7feeb11e(,%eax,8)
8010569b:	80 
8010569c:	c6 04 c5 e4 4e 11 80 	movb   $0x0,-0x7feeb11c(,%eax,8)
801056a3:	00 
801056a4:	c6 04 c5 e5 4e 11 80 	movb   $0x8e,-0x7feeb11b(,%eax,8)
801056ab:	8e 
801056ac:	66 89 14 c5 e0 4e 11 	mov    %dx,-0x7feeb120(,%eax,8)
801056b3:	80 
801056b4:	c1 ea 10             	shr    $0x10,%edx
801056b7:	66 89 14 c5 e6 4e 11 	mov    %dx,-0x7feeb11a(,%eax,8)
801056be:	80 
801056bf:	83 c0 01             	add    $0x1,%eax
801056c2:	3d 00 01 00 00       	cmp    $0x100,%eax
801056c7:	75 bf                	jne    80105688 <tvinit+0x8>
801056c9:	55                   	push   %ebp
801056ca:	ba 08 00 00 00       	mov    $0x8,%edx
801056cf:	89 e5                	mov    %esp,%ebp
801056d1:	83 ec 18             	sub    $0x18,%esp
801056d4:	a1 08 a1 10 80       	mov    0x8010a108,%eax
801056d9:	c7 44 24 04 b6 77 10 	movl   $0x801077b6,0x4(%esp)
801056e0:	80 
801056e1:	c7 04 24 a0 4e 11 80 	movl   $0x80114ea0,(%esp)
801056e8:	66 89 15 e2 50 11 80 	mov    %dx,0x801150e2
801056ef:	66 a3 e0 50 11 80    	mov    %ax,0x801150e0
801056f5:	c1 e8 10             	shr    $0x10,%eax
801056f8:	c6 05 e4 50 11 80 00 	movb   $0x0,0x801150e4
801056ff:	c6 05 e5 50 11 80 ef 	movb   $0xef,0x801150e5
80105706:	66 a3 e6 50 11 80    	mov    %ax,0x801150e6
8010570c:	e8 cf ea ff ff       	call   801041e0 <initlock>
80105711:	c9                   	leave  
80105712:	c3                   	ret    
80105713:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105719:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105720 <idtinit>:
80105720:	55                   	push   %ebp
80105721:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105726:	89 e5                	mov    %esp,%ebp
80105728:	83 ec 10             	sub    $0x10,%esp
8010572b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
8010572f:	b8 e0 4e 11 80       	mov    $0x80114ee0,%eax
80105734:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80105738:	c1 e8 10             	shr    $0x10,%eax
8010573b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
8010573f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105742:	0f 01 18             	lidtl  (%eax)
80105745:	c9                   	leave  
80105746:	c3                   	ret    
80105747:	89 f6                	mov    %esi,%esi
80105749:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105750 <trap>:
80105750:	55                   	push   %ebp
80105751:	89 e5                	mov    %esp,%ebp
80105753:	57                   	push   %edi
80105754:	56                   	push   %esi
80105755:	53                   	push   %ebx
80105756:	83 ec 3c             	sub    $0x3c,%esp
80105759:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010575c:	8b 43 30             	mov    0x30(%ebx),%eax
8010575f:	83 f8 40             	cmp    $0x40,%eax
80105762:	0f 84 38 01 00 00    	je     801058a0 <trap+0x150>
80105768:	83 f8 0e             	cmp    $0xe,%eax
8010576b:	0f 84 ff 01 00 00    	je     80105970 <trap+0x220>
80105771:	83 e8 20             	sub    $0x20,%eax
80105774:	83 f8 1f             	cmp    $0x1f,%eax
80105777:	0f 87 63 01 00 00    	ja     801058e0 <trap+0x190>
8010577d:	ff 24 85 80 78 10 80 	jmp    *-0x7fef8780(,%eax,4)
80105784:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105788:	e8 53 e0 ff ff       	call   801037e0 <cpuid>
8010578d:	85 c0                	test   %eax,%eax
8010578f:	90                   	nop
80105790:	0f 84 72 02 00 00    	je     80105a08 <trap+0x2b8>
80105796:	e8 65 e0 ff ff       	call   80103800 <myproc>
8010579b:	85 c0                	test   %eax,%eax
8010579d:	8d 76 00             	lea    0x0(%esi),%esi
801057a0:	74 11                	je     801057b3 <trap+0x63>
801057a2:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801057a6:	83 e0 03             	and    $0x3,%eax
801057a9:	66 83 f8 03          	cmp    $0x3,%ax
801057ad:	0f 84 85 02 00 00    	je     80105a38 <trap+0x2e8>
801057b3:	e8 c8 d0 ff ff       	call   80102880 <lapiceoi>
801057b8:	e8 43 e0 ff ff       	call   80103800 <myproc>
801057bd:	85 c0                	test   %eax,%eax
801057bf:	90                   	nop
801057c0:	74 0c                	je     801057ce <trap+0x7e>
801057c2:	e8 39 e0 ff ff       	call   80103800 <myproc>
801057c7:	8b 40 24             	mov    0x24(%eax),%eax
801057ca:	85 c0                	test   %eax,%eax
801057cc:	75 4a                	jne    80105818 <trap+0xc8>
801057ce:	e8 2d e0 ff ff       	call   80103800 <myproc>
801057d3:	85 c0                	test   %eax,%eax
801057d5:	74 0b                	je     801057e2 <trap+0x92>
801057d7:	e8 24 e0 ff ff       	call   80103800 <myproc>
801057dc:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
801057e0:	74 4e                	je     80105830 <trap+0xe0>
801057e2:	e8 19 e0 ff ff       	call   80103800 <myproc>
801057e7:	85 c0                	test   %eax,%eax
801057e9:	74 22                	je     8010580d <trap+0xbd>
801057eb:	90                   	nop
801057ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801057f0:	e8 0b e0 ff ff       	call   80103800 <myproc>
801057f5:	8b 40 24             	mov    0x24(%eax),%eax
801057f8:	85 c0                	test   %eax,%eax
801057fa:	74 11                	je     8010580d <trap+0xbd>
801057fc:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105800:	83 e0 03             	and    $0x3,%eax
80105803:	66 83 f8 03          	cmp    $0x3,%ax
80105807:	0f 84 c0 00 00 00    	je     801058cd <trap+0x17d>
8010580d:	83 c4 3c             	add    $0x3c,%esp
80105810:	5b                   	pop    %ebx
80105811:	5e                   	pop    %esi
80105812:	5f                   	pop    %edi
80105813:	5d                   	pop    %ebp
80105814:	c3                   	ret    
80105815:	8d 76 00             	lea    0x0(%esi),%esi
80105818:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
8010581c:	83 e0 03             	and    $0x3,%eax
8010581f:	66 83 f8 03          	cmp    $0x3,%ax
80105823:	75 a9                	jne    801057ce <trap+0x7e>
80105825:	e8 d6 e3 ff ff       	call   80103c00 <exit>
8010582a:	eb a2                	jmp    801057ce <trap+0x7e>
8010582c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105830:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105834:	75 ac                	jne    801057e2 <trap+0x92>
80105836:	e8 f5 e4 ff ff       	call   80103d30 <yield>
8010583b:	eb a5                	jmp    801057e2 <trap+0x92>
8010583d:	8d 76 00             	lea    0x0(%esi),%esi
80105840:	e8 9b ce ff ff       	call   801026e0 <kbdintr>
80105845:	e8 36 d0 ff ff       	call   80102880 <lapiceoi>
8010584a:	e9 69 ff ff ff       	jmp    801057b8 <trap+0x68>
8010584f:	90                   	nop
80105850:	e8 9b 03 00 00       	call   80105bf0 <uartintr>
80105855:	e8 26 d0 ff ff       	call   80102880 <lapiceoi>
8010585a:	e9 59 ff ff ff       	jmp    801057b8 <trap+0x68>
8010585f:	90                   	nop
80105860:	8b 7b 38             	mov    0x38(%ebx),%edi
80105863:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105867:	e8 74 df ff ff       	call   801037e0 <cpuid>
8010586c:	c7 04 24 e4 77 10 80 	movl   $0x801077e4,(%esp)
80105873:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80105877:	89 74 24 08          	mov    %esi,0x8(%esp)
8010587b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010587f:	e8 cc ad ff ff       	call   80100650 <cprintf>
80105884:	e8 f7 cf ff ff       	call   80102880 <lapiceoi>
80105889:	e9 2a ff ff ff       	jmp    801057b8 <trap+0x68>
8010588e:	66 90                	xchg   %ax,%ax
80105890:	e8 fb c8 ff ff       	call   80102190 <ideintr>
80105895:	e9 19 ff ff ff       	jmp    801057b3 <trap+0x63>
8010589a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801058a0:	e8 5b df ff ff       	call   80103800 <myproc>
801058a5:	8b 40 24             	mov    0x24(%eax),%eax
801058a8:	85 c0                	test   %eax,%eax
801058aa:	0f 85 48 01 00 00    	jne    801059f8 <trap+0x2a8>
801058b0:	e8 4b df ff ff       	call   80103800 <myproc>
801058b5:	89 58 18             	mov    %ebx,0x18(%eax)
801058b8:	e8 23 ef ff ff       	call   801047e0 <syscall>
801058bd:	e8 3e df ff ff       	call   80103800 <myproc>
801058c2:	8b 40 24             	mov    0x24(%eax),%eax
801058c5:	85 c0                	test   %eax,%eax
801058c7:	0f 84 40 ff ff ff    	je     8010580d <trap+0xbd>
801058cd:	83 c4 3c             	add    $0x3c,%esp
801058d0:	5b                   	pop    %ebx
801058d1:	5e                   	pop    %esi
801058d2:	5f                   	pop    %edi
801058d3:	5d                   	pop    %ebp
801058d4:	e9 27 e3 ff ff       	jmp    80103c00 <exit>
801058d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058e0:	e8 1b df ff ff       	call   80103800 <myproc>
801058e5:	85 c0                	test   %eax,%eax
801058e7:	0f 84 b6 01 00 00    	je     80105aa3 <trap+0x353>
801058ed:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
801058f1:	0f 84 ac 01 00 00    	je     80105aa3 <trap+0x353>
801058f7:	0f 20 d1             	mov    %cr2,%ecx
801058fa:	8b 53 38             	mov    0x38(%ebx),%edx
801058fd:	89 4d d8             	mov    %ecx,-0x28(%ebp)
80105900:	89 55 dc             	mov    %edx,-0x24(%ebp)
80105903:	e8 d8 de ff ff       	call   801037e0 <cpuid>
80105908:	8b 73 30             	mov    0x30(%ebx),%esi
8010590b:	89 c7                	mov    %eax,%edi
8010590d:	8b 43 34             	mov    0x34(%ebx),%eax
80105910:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80105913:	e8 e8 de ff ff       	call   80103800 <myproc>
80105918:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010591b:	e8 e0 de ff ff       	call   80103800 <myproc>
80105920:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105923:	89 74 24 0c          	mov    %esi,0xc(%esp)
80105927:	8b 75 e0             	mov    -0x20(%ebp),%esi
8010592a:	8b 55 dc             	mov    -0x24(%ebp),%edx
8010592d:	89 7c 24 14          	mov    %edi,0x14(%esp)
80105931:	89 4c 24 1c          	mov    %ecx,0x1c(%esp)
80105935:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105938:	83 c6 6c             	add    $0x6c,%esi
8010593b:	89 54 24 18          	mov    %edx,0x18(%esp)
8010593f:	89 74 24 08          	mov    %esi,0x8(%esp)
80105943:	89 4c 24 10          	mov    %ecx,0x10(%esp)
80105947:	8b 40 10             	mov    0x10(%eax),%eax
8010594a:	c7 04 24 3c 78 10 80 	movl   $0x8010783c,(%esp)
80105951:	89 44 24 04          	mov    %eax,0x4(%esp)
80105955:	e8 f6 ac ff ff       	call   80100650 <cprintf>
8010595a:	e8 a1 de ff ff       	call   80103800 <myproc>
8010595f:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80105966:	e9 4d fe ff ff       	jmp    801057b8 <trap+0x68>
8010596b:	90                   	nop
8010596c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105970:	e8 3b cc ff ff       	call   801025b0 <kalloc>
80105975:	85 c0                	test   %eax,%eax
80105977:	89 c3                	mov    %eax,%ebx
80105979:	0f 84 11 01 00 00    	je     80105a90 <trap+0x340>
8010597f:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80105986:	00 
80105987:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010598e:	00 
8010598f:	89 04 24             	mov    %eax,(%esp)
80105992:	e8 79 ea ff ff       	call   80104410 <memset>
80105997:	0f 20 d6             	mov    %cr2,%esi
8010599a:	e8 61 de ff ff       	call   80103800 <myproc>
8010599f:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
801059a5:	8d 93 00 00 00 80    	lea    -0x80000000(%ebx),%edx
801059ab:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
801059b2:	00 
801059b3:	89 54 24 0c          	mov    %edx,0xc(%esp)
801059b7:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801059be:	00 
801059bf:	89 74 24 04          	mov    %esi,0x4(%esp)
801059c3:	8b 40 04             	mov    0x4(%eax),%eax
801059c6:	89 04 24             	mov    %eax,(%esp)
801059c9:	e8 a2 0e 00 00       	call   80106870 <mappages>
801059ce:	85 c0                	test   %eax,%eax
801059d0:	0f 89 37 fe ff ff    	jns    8010580d <trap+0xbd>
801059d6:	c7 04 24 d1 77 10 80 	movl   $0x801077d1,(%esp)
801059dd:	e8 6e ac ff ff       	call   80100650 <cprintf>
801059e2:	89 5d 08             	mov    %ebx,0x8(%ebp)
801059e5:	83 c4 3c             	add    $0x3c,%esp
801059e8:	5b                   	pop    %ebx
801059e9:	5e                   	pop    %esi
801059ea:	5f                   	pop    %edi
801059eb:	5d                   	pop    %ebp
801059ec:	e9 0f ca ff ff       	jmp    80102400 <kfree>
801059f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059f8:	e8 03 e2 ff ff       	call   80103c00 <exit>
801059fd:	e9 ae fe ff ff       	jmp    801058b0 <trap+0x160>
80105a02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105a08:	c7 04 24 a0 4e 11 80 	movl   $0x80114ea0,(%esp)
80105a0f:	e8 bc e8 ff ff       	call   801042d0 <acquire>
80105a14:	c7 04 24 e0 56 11 80 	movl   $0x801156e0,(%esp)
80105a1b:	83 05 e0 56 11 80 01 	addl   $0x1,0x801156e0
80105a22:	e8 e9 e4 ff ff       	call   80103f10 <wakeup>
80105a27:	c7 04 24 a0 4e 11 80 	movl   $0x80114ea0,(%esp)
80105a2e:	e8 8d e9 ff ff       	call   801043c0 <release>
80105a33:	e9 5e fd ff ff       	jmp    80105796 <trap+0x46>
80105a38:	e8 c3 dd ff ff       	call   80103800 <myproc>
80105a3d:	83 80 84 00 00 00 01 	addl   $0x1,0x84(%eax)
80105a44:	e8 b7 dd ff ff       	call   80103800 <myproc>
80105a49:	8b b0 84 00 00 00    	mov    0x84(%eax),%esi
80105a4f:	e8 ac dd ff ff       	call   80103800 <myproc>
80105a54:	3b 70 7c             	cmp    0x7c(%eax),%esi
80105a57:	0f 8c 56 fd ff ff    	jl     801057b3 <trap+0x63>
80105a5d:	e8 9e dd ff ff       	call   80103800 <myproc>
80105a62:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%eax)
80105a69:	00 00 00 
80105a6c:	8b 43 44             	mov    0x44(%ebx),%eax
80105a6f:	8d 50 fc             	lea    -0x4(%eax),%edx
80105a72:	89 53 44             	mov    %edx,0x44(%ebx)
80105a75:	8b 53 38             	mov    0x38(%ebx),%edx
80105a78:	89 50 fc             	mov    %edx,-0x4(%eax)
80105a7b:	e8 80 dd ff ff       	call   80103800 <myproc>
80105a80:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80105a86:	89 43 38             	mov    %eax,0x38(%ebx)
80105a89:	e9 25 fd ff ff       	jmp    801057b3 <trap+0x63>
80105a8e:	66 90                	xchg   %ax,%ax
80105a90:	c7 45 08 bb 77 10 80 	movl   $0x801077bb,0x8(%ebp)
80105a97:	83 c4 3c             	add    $0x3c,%esp
80105a9a:	5b                   	pop    %ebx
80105a9b:	5e                   	pop    %esi
80105a9c:	5f                   	pop    %edi
80105a9d:	5d                   	pop    %ebp
80105a9e:	e9 ad ab ff ff       	jmp    80100650 <cprintf>
80105aa3:	0f 20 d7             	mov    %cr2,%edi
80105aa6:	8b 73 38             	mov    0x38(%ebx),%esi
80105aa9:	e8 32 dd ff ff       	call   801037e0 <cpuid>
80105aae:	89 7c 24 10          	mov    %edi,0x10(%esp)
80105ab2:	89 74 24 0c          	mov    %esi,0xc(%esp)
80105ab6:	89 44 24 08          	mov    %eax,0x8(%esp)
80105aba:	8b 43 30             	mov    0x30(%ebx),%eax
80105abd:	c7 04 24 08 78 10 80 	movl   $0x80107808,(%esp)
80105ac4:	89 44 24 04          	mov    %eax,0x4(%esp)
80105ac8:	e8 83 ab ff ff       	call   80100650 <cprintf>
80105acd:	c7 04 24 df 77 10 80 	movl   $0x801077df,(%esp)
80105ad4:	e8 87 a8 ff ff       	call   80100360 <panic>
80105ad9:	00 00                	add    %al,(%eax)
80105adb:	00 00                	add    %al,(%eax)
80105add:	00 00                	add    %al,(%eax)
	...

80105ae0 <uartgetc>:
80105ae0:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
80105ae5:	55                   	push   %ebp
80105ae6:	89 e5                	mov    %esp,%ebp
80105ae8:	85 c0                	test   %eax,%eax
80105aea:	74 14                	je     80105b00 <uartgetc+0x20>
80105aec:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105af1:	ec                   	in     (%dx),%al
80105af2:	a8 01                	test   $0x1,%al
80105af4:	74 0a                	je     80105b00 <uartgetc+0x20>
80105af6:	b2 f8                	mov    $0xf8,%dl
80105af8:	ec                   	in     (%dx),%al
80105af9:	0f b6 c0             	movzbl %al,%eax
80105afc:	5d                   	pop    %ebp
80105afd:	c3                   	ret    
80105afe:	66 90                	xchg   %ax,%ax
80105b00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b05:	5d                   	pop    %ebp
80105b06:	c3                   	ret    
80105b07:	89 f6                	mov    %esi,%esi
80105b09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105b10 <uartputc>:
80105b10:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
80105b16:	85 d2                	test   %edx,%edx
80105b18:	74 3e                	je     80105b58 <uartputc+0x48>
80105b1a:	55                   	push   %ebp
80105b1b:	89 e5                	mov    %esp,%ebp
80105b1d:	56                   	push   %esi
80105b1e:	be fd 03 00 00       	mov    $0x3fd,%esi
80105b23:	53                   	push   %ebx
80105b24:	bb 80 00 00 00       	mov    $0x80,%ebx
80105b29:	83 ec 10             	sub    $0x10,%esp
80105b2c:	eb 13                	jmp    80105b41 <uartputc+0x31>
80105b2e:	66 90                	xchg   %ax,%ax
80105b30:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
80105b37:	e8 64 cd ff ff       	call   801028a0 <microdelay>
80105b3c:	83 eb 01             	sub    $0x1,%ebx
80105b3f:	74 07                	je     80105b48 <uartputc+0x38>
80105b41:	89 f2                	mov    %esi,%edx
80105b43:	ec                   	in     (%dx),%al
80105b44:	a8 20                	test   $0x20,%al
80105b46:	74 e8                	je     80105b30 <uartputc+0x20>
80105b48:	0f b6 45 08          	movzbl 0x8(%ebp),%eax
80105b4c:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105b51:	ee                   	out    %al,(%dx)
80105b52:	83 c4 10             	add    $0x10,%esp
80105b55:	5b                   	pop    %ebx
80105b56:	5e                   	pop    %esi
80105b57:	5d                   	pop    %ebp
80105b58:	f3 c3                	repz ret 
80105b5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105b60 <uartinit>:
80105b60:	ba fa 03 00 00       	mov    $0x3fa,%edx
80105b65:	31 c0                	xor    %eax,%eax
80105b67:	ee                   	out    %al,(%dx)
80105b68:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105b6d:	b2 fb                	mov    $0xfb,%dl
80105b6f:	ee                   	out    %al,(%dx)
80105b70:	b8 0c 00 00 00       	mov    $0xc,%eax
80105b75:	b2 f8                	mov    $0xf8,%dl
80105b77:	ee                   	out    %al,(%dx)
80105b78:	31 c0                	xor    %eax,%eax
80105b7a:	b2 f9                	mov    $0xf9,%dl
80105b7c:	ee                   	out    %al,(%dx)
80105b7d:	b8 03 00 00 00       	mov    $0x3,%eax
80105b82:	b2 fb                	mov    $0xfb,%dl
80105b84:	ee                   	out    %al,(%dx)
80105b85:	31 c0                	xor    %eax,%eax
80105b87:	b2 fc                	mov    $0xfc,%dl
80105b89:	ee                   	out    %al,(%dx)
80105b8a:	b8 01 00 00 00       	mov    $0x1,%eax
80105b8f:	b2 f9                	mov    $0xf9,%dl
80105b91:	ee                   	out    %al,(%dx)
80105b92:	b2 fd                	mov    $0xfd,%dl
80105b94:	ec                   	in     (%dx),%al
80105b95:	3c ff                	cmp    $0xff,%al
80105b97:	74 4e                	je     80105be7 <uartinit+0x87>
80105b99:	55                   	push   %ebp
80105b9a:	b2 fa                	mov    $0xfa,%dl
80105b9c:	89 e5                	mov    %esp,%ebp
80105b9e:	53                   	push   %ebx
80105b9f:	83 ec 14             	sub    $0x14,%esp
80105ba2:	c7 05 bc a5 10 80 01 	movl   $0x1,0x8010a5bc
80105ba9:	00 00 00 
80105bac:	ec                   	in     (%dx),%al
80105bad:	b2 f8                	mov    $0xf8,%dl
80105baf:	ec                   	in     (%dx),%al
80105bb0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105bb7:	00 
80105bb8:	bb 00 79 10 80       	mov    $0x80107900,%ebx
80105bbd:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80105bc4:	e8 f7 c7 ff ff       	call   801023c0 <ioapicenable>
80105bc9:	b8 78 00 00 00       	mov    $0x78,%eax
80105bce:	66 90                	xchg   %ax,%ax
80105bd0:	89 04 24             	mov    %eax,(%esp)
80105bd3:	83 c3 01             	add    $0x1,%ebx
80105bd6:	e8 35 ff ff ff       	call   80105b10 <uartputc>
80105bdb:	0f be 03             	movsbl (%ebx),%eax
80105bde:	84 c0                	test   %al,%al
80105be0:	75 ee                	jne    80105bd0 <uartinit+0x70>
80105be2:	83 c4 14             	add    $0x14,%esp
80105be5:	5b                   	pop    %ebx
80105be6:	5d                   	pop    %ebp
80105be7:	f3 c3                	repz ret 
80105be9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105bf0 <uartintr>:
80105bf0:	55                   	push   %ebp
80105bf1:	89 e5                	mov    %esp,%ebp
80105bf3:	83 ec 18             	sub    $0x18,%esp
80105bf6:	c7 04 24 e0 5a 10 80 	movl   $0x80105ae0,(%esp)
80105bfd:	e8 ae ab ff ff       	call   801007b0 <consoleintr>
80105c02:	c9                   	leave  
80105c03:	c3                   	ret    

80105c04 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105c04:	6a 00                	push   $0x0
  pushl $0
80105c06:	6a 00                	push   $0x0
  jmp alltraps
80105c08:	e9 4b fa ff ff       	jmp    80105658 <alltraps>

80105c0d <vector1>:
.globl vector1
vector1:
  pushl $0
80105c0d:	6a 00                	push   $0x0
  pushl $1
80105c0f:	6a 01                	push   $0x1
  jmp alltraps
80105c11:	e9 42 fa ff ff       	jmp    80105658 <alltraps>

80105c16 <vector2>:
.globl vector2
vector2:
  pushl $0
80105c16:	6a 00                	push   $0x0
  pushl $2
80105c18:	6a 02                	push   $0x2
  jmp alltraps
80105c1a:	e9 39 fa ff ff       	jmp    80105658 <alltraps>

80105c1f <vector3>:
.globl vector3
vector3:
  pushl $0
80105c1f:	6a 00                	push   $0x0
  pushl $3
80105c21:	6a 03                	push   $0x3
  jmp alltraps
80105c23:	e9 30 fa ff ff       	jmp    80105658 <alltraps>

80105c28 <vector4>:
.globl vector4
vector4:
  pushl $0
80105c28:	6a 00                	push   $0x0
  pushl $4
80105c2a:	6a 04                	push   $0x4
  jmp alltraps
80105c2c:	e9 27 fa ff ff       	jmp    80105658 <alltraps>

80105c31 <vector5>:
.globl vector5
vector5:
  pushl $0
80105c31:	6a 00                	push   $0x0
  pushl $5
80105c33:	6a 05                	push   $0x5
  jmp alltraps
80105c35:	e9 1e fa ff ff       	jmp    80105658 <alltraps>

80105c3a <vector6>:
.globl vector6
vector6:
  pushl $0
80105c3a:	6a 00                	push   $0x0
  pushl $6
80105c3c:	6a 06                	push   $0x6
  jmp alltraps
80105c3e:	e9 15 fa ff ff       	jmp    80105658 <alltraps>

80105c43 <vector7>:
.globl vector7
vector7:
  pushl $0
80105c43:	6a 00                	push   $0x0
  pushl $7
80105c45:	6a 07                	push   $0x7
  jmp alltraps
80105c47:	e9 0c fa ff ff       	jmp    80105658 <alltraps>

80105c4c <vector8>:
.globl vector8
vector8:
  pushl $8
80105c4c:	6a 08                	push   $0x8
  jmp alltraps
80105c4e:	e9 05 fa ff ff       	jmp    80105658 <alltraps>

80105c53 <vector9>:
.globl vector9
vector9:
  pushl $0
80105c53:	6a 00                	push   $0x0
  pushl $9
80105c55:	6a 09                	push   $0x9
  jmp alltraps
80105c57:	e9 fc f9 ff ff       	jmp    80105658 <alltraps>

80105c5c <vector10>:
.globl vector10
vector10:
  pushl $10
80105c5c:	6a 0a                	push   $0xa
  jmp alltraps
80105c5e:	e9 f5 f9 ff ff       	jmp    80105658 <alltraps>

80105c63 <vector11>:
.globl vector11
vector11:
  pushl $11
80105c63:	6a 0b                	push   $0xb
  jmp alltraps
80105c65:	e9 ee f9 ff ff       	jmp    80105658 <alltraps>

80105c6a <vector12>:
.globl vector12
vector12:
  pushl $12
80105c6a:	6a 0c                	push   $0xc
  jmp alltraps
80105c6c:	e9 e7 f9 ff ff       	jmp    80105658 <alltraps>

80105c71 <vector13>:
.globl vector13
vector13:
  pushl $13
80105c71:	6a 0d                	push   $0xd
  jmp alltraps
80105c73:	e9 e0 f9 ff ff       	jmp    80105658 <alltraps>

80105c78 <vector14>:
.globl vector14
vector14:
  pushl $14
80105c78:	6a 0e                	push   $0xe
  jmp alltraps
80105c7a:	e9 d9 f9 ff ff       	jmp    80105658 <alltraps>

80105c7f <vector15>:
.globl vector15
vector15:
  pushl $0
80105c7f:	6a 00                	push   $0x0
  pushl $15
80105c81:	6a 0f                	push   $0xf
  jmp alltraps
80105c83:	e9 d0 f9 ff ff       	jmp    80105658 <alltraps>

80105c88 <vector16>:
.globl vector16
vector16:
  pushl $0
80105c88:	6a 00                	push   $0x0
  pushl $16
80105c8a:	6a 10                	push   $0x10
  jmp alltraps
80105c8c:	e9 c7 f9 ff ff       	jmp    80105658 <alltraps>

80105c91 <vector17>:
.globl vector17
vector17:
  pushl $17
80105c91:	6a 11                	push   $0x11
  jmp alltraps
80105c93:	e9 c0 f9 ff ff       	jmp    80105658 <alltraps>

80105c98 <vector18>:
.globl vector18
vector18:
  pushl $0
80105c98:	6a 00                	push   $0x0
  pushl $18
80105c9a:	6a 12                	push   $0x12
  jmp alltraps
80105c9c:	e9 b7 f9 ff ff       	jmp    80105658 <alltraps>

80105ca1 <vector19>:
.globl vector19
vector19:
  pushl $0
80105ca1:	6a 00                	push   $0x0
  pushl $19
80105ca3:	6a 13                	push   $0x13
  jmp alltraps
80105ca5:	e9 ae f9 ff ff       	jmp    80105658 <alltraps>

80105caa <vector20>:
.globl vector20
vector20:
  pushl $0
80105caa:	6a 00                	push   $0x0
  pushl $20
80105cac:	6a 14                	push   $0x14
  jmp alltraps
80105cae:	e9 a5 f9 ff ff       	jmp    80105658 <alltraps>

80105cb3 <vector21>:
.globl vector21
vector21:
  pushl $0
80105cb3:	6a 00                	push   $0x0
  pushl $21
80105cb5:	6a 15                	push   $0x15
  jmp alltraps
80105cb7:	e9 9c f9 ff ff       	jmp    80105658 <alltraps>

80105cbc <vector22>:
.globl vector22
vector22:
  pushl $0
80105cbc:	6a 00                	push   $0x0
  pushl $22
80105cbe:	6a 16                	push   $0x16
  jmp alltraps
80105cc0:	e9 93 f9 ff ff       	jmp    80105658 <alltraps>

80105cc5 <vector23>:
.globl vector23
vector23:
  pushl $0
80105cc5:	6a 00                	push   $0x0
  pushl $23
80105cc7:	6a 17                	push   $0x17
  jmp alltraps
80105cc9:	e9 8a f9 ff ff       	jmp    80105658 <alltraps>

80105cce <vector24>:
.globl vector24
vector24:
  pushl $0
80105cce:	6a 00                	push   $0x0
  pushl $24
80105cd0:	6a 18                	push   $0x18
  jmp alltraps
80105cd2:	e9 81 f9 ff ff       	jmp    80105658 <alltraps>

80105cd7 <vector25>:
.globl vector25
vector25:
  pushl $0
80105cd7:	6a 00                	push   $0x0
  pushl $25
80105cd9:	6a 19                	push   $0x19
  jmp alltraps
80105cdb:	e9 78 f9 ff ff       	jmp    80105658 <alltraps>

80105ce0 <vector26>:
.globl vector26
vector26:
  pushl $0
80105ce0:	6a 00                	push   $0x0
  pushl $26
80105ce2:	6a 1a                	push   $0x1a
  jmp alltraps
80105ce4:	e9 6f f9 ff ff       	jmp    80105658 <alltraps>

80105ce9 <vector27>:
.globl vector27
vector27:
  pushl $0
80105ce9:	6a 00                	push   $0x0
  pushl $27
80105ceb:	6a 1b                	push   $0x1b
  jmp alltraps
80105ced:	e9 66 f9 ff ff       	jmp    80105658 <alltraps>

80105cf2 <vector28>:
.globl vector28
vector28:
  pushl $0
80105cf2:	6a 00                	push   $0x0
  pushl $28
80105cf4:	6a 1c                	push   $0x1c
  jmp alltraps
80105cf6:	e9 5d f9 ff ff       	jmp    80105658 <alltraps>

80105cfb <vector29>:
.globl vector29
vector29:
  pushl $0
80105cfb:	6a 00                	push   $0x0
  pushl $29
80105cfd:	6a 1d                	push   $0x1d
  jmp alltraps
80105cff:	e9 54 f9 ff ff       	jmp    80105658 <alltraps>

80105d04 <vector30>:
.globl vector30
vector30:
  pushl $0
80105d04:	6a 00                	push   $0x0
  pushl $30
80105d06:	6a 1e                	push   $0x1e
  jmp alltraps
80105d08:	e9 4b f9 ff ff       	jmp    80105658 <alltraps>

80105d0d <vector31>:
.globl vector31
vector31:
  pushl $0
80105d0d:	6a 00                	push   $0x0
  pushl $31
80105d0f:	6a 1f                	push   $0x1f
  jmp alltraps
80105d11:	e9 42 f9 ff ff       	jmp    80105658 <alltraps>

80105d16 <vector32>:
.globl vector32
vector32:
  pushl $0
80105d16:	6a 00                	push   $0x0
  pushl $32
80105d18:	6a 20                	push   $0x20
  jmp alltraps
80105d1a:	e9 39 f9 ff ff       	jmp    80105658 <alltraps>

80105d1f <vector33>:
.globl vector33
vector33:
  pushl $0
80105d1f:	6a 00                	push   $0x0
  pushl $33
80105d21:	6a 21                	push   $0x21
  jmp alltraps
80105d23:	e9 30 f9 ff ff       	jmp    80105658 <alltraps>

80105d28 <vector34>:
.globl vector34
vector34:
  pushl $0
80105d28:	6a 00                	push   $0x0
  pushl $34
80105d2a:	6a 22                	push   $0x22
  jmp alltraps
80105d2c:	e9 27 f9 ff ff       	jmp    80105658 <alltraps>

80105d31 <vector35>:
.globl vector35
vector35:
  pushl $0
80105d31:	6a 00                	push   $0x0
  pushl $35
80105d33:	6a 23                	push   $0x23
  jmp alltraps
80105d35:	e9 1e f9 ff ff       	jmp    80105658 <alltraps>

80105d3a <vector36>:
.globl vector36
vector36:
  pushl $0
80105d3a:	6a 00                	push   $0x0
  pushl $36
80105d3c:	6a 24                	push   $0x24
  jmp alltraps
80105d3e:	e9 15 f9 ff ff       	jmp    80105658 <alltraps>

80105d43 <vector37>:
.globl vector37
vector37:
  pushl $0
80105d43:	6a 00                	push   $0x0
  pushl $37
80105d45:	6a 25                	push   $0x25
  jmp alltraps
80105d47:	e9 0c f9 ff ff       	jmp    80105658 <alltraps>

80105d4c <vector38>:
.globl vector38
vector38:
  pushl $0
80105d4c:	6a 00                	push   $0x0
  pushl $38
80105d4e:	6a 26                	push   $0x26
  jmp alltraps
80105d50:	e9 03 f9 ff ff       	jmp    80105658 <alltraps>

80105d55 <vector39>:
.globl vector39
vector39:
  pushl $0
80105d55:	6a 00                	push   $0x0
  pushl $39
80105d57:	6a 27                	push   $0x27
  jmp alltraps
80105d59:	e9 fa f8 ff ff       	jmp    80105658 <alltraps>

80105d5e <vector40>:
.globl vector40
vector40:
  pushl $0
80105d5e:	6a 00                	push   $0x0
  pushl $40
80105d60:	6a 28                	push   $0x28
  jmp alltraps
80105d62:	e9 f1 f8 ff ff       	jmp    80105658 <alltraps>

80105d67 <vector41>:
.globl vector41
vector41:
  pushl $0
80105d67:	6a 00                	push   $0x0
  pushl $41
80105d69:	6a 29                	push   $0x29
  jmp alltraps
80105d6b:	e9 e8 f8 ff ff       	jmp    80105658 <alltraps>

80105d70 <vector42>:
.globl vector42
vector42:
  pushl $0
80105d70:	6a 00                	push   $0x0
  pushl $42
80105d72:	6a 2a                	push   $0x2a
  jmp alltraps
80105d74:	e9 df f8 ff ff       	jmp    80105658 <alltraps>

80105d79 <vector43>:
.globl vector43
vector43:
  pushl $0
80105d79:	6a 00                	push   $0x0
  pushl $43
80105d7b:	6a 2b                	push   $0x2b
  jmp alltraps
80105d7d:	e9 d6 f8 ff ff       	jmp    80105658 <alltraps>

80105d82 <vector44>:
.globl vector44
vector44:
  pushl $0
80105d82:	6a 00                	push   $0x0
  pushl $44
80105d84:	6a 2c                	push   $0x2c
  jmp alltraps
80105d86:	e9 cd f8 ff ff       	jmp    80105658 <alltraps>

80105d8b <vector45>:
.globl vector45
vector45:
  pushl $0
80105d8b:	6a 00                	push   $0x0
  pushl $45
80105d8d:	6a 2d                	push   $0x2d
  jmp alltraps
80105d8f:	e9 c4 f8 ff ff       	jmp    80105658 <alltraps>

80105d94 <vector46>:
.globl vector46
vector46:
  pushl $0
80105d94:	6a 00                	push   $0x0
  pushl $46
80105d96:	6a 2e                	push   $0x2e
  jmp alltraps
80105d98:	e9 bb f8 ff ff       	jmp    80105658 <alltraps>

80105d9d <vector47>:
.globl vector47
vector47:
  pushl $0
80105d9d:	6a 00                	push   $0x0
  pushl $47
80105d9f:	6a 2f                	push   $0x2f
  jmp alltraps
80105da1:	e9 b2 f8 ff ff       	jmp    80105658 <alltraps>

80105da6 <vector48>:
.globl vector48
vector48:
  pushl $0
80105da6:	6a 00                	push   $0x0
  pushl $48
80105da8:	6a 30                	push   $0x30
  jmp alltraps
80105daa:	e9 a9 f8 ff ff       	jmp    80105658 <alltraps>

80105daf <vector49>:
.globl vector49
vector49:
  pushl $0
80105daf:	6a 00                	push   $0x0
  pushl $49
80105db1:	6a 31                	push   $0x31
  jmp alltraps
80105db3:	e9 a0 f8 ff ff       	jmp    80105658 <alltraps>

80105db8 <vector50>:
.globl vector50
vector50:
  pushl $0
80105db8:	6a 00                	push   $0x0
  pushl $50
80105dba:	6a 32                	push   $0x32
  jmp alltraps
80105dbc:	e9 97 f8 ff ff       	jmp    80105658 <alltraps>

80105dc1 <vector51>:
.globl vector51
vector51:
  pushl $0
80105dc1:	6a 00                	push   $0x0
  pushl $51
80105dc3:	6a 33                	push   $0x33
  jmp alltraps
80105dc5:	e9 8e f8 ff ff       	jmp    80105658 <alltraps>

80105dca <vector52>:
.globl vector52
vector52:
  pushl $0
80105dca:	6a 00                	push   $0x0
  pushl $52
80105dcc:	6a 34                	push   $0x34
  jmp alltraps
80105dce:	e9 85 f8 ff ff       	jmp    80105658 <alltraps>

80105dd3 <vector53>:
.globl vector53
vector53:
  pushl $0
80105dd3:	6a 00                	push   $0x0
  pushl $53
80105dd5:	6a 35                	push   $0x35
  jmp alltraps
80105dd7:	e9 7c f8 ff ff       	jmp    80105658 <alltraps>

80105ddc <vector54>:
.globl vector54
vector54:
  pushl $0
80105ddc:	6a 00                	push   $0x0
  pushl $54
80105dde:	6a 36                	push   $0x36
  jmp alltraps
80105de0:	e9 73 f8 ff ff       	jmp    80105658 <alltraps>

80105de5 <vector55>:
.globl vector55
vector55:
  pushl $0
80105de5:	6a 00                	push   $0x0
  pushl $55
80105de7:	6a 37                	push   $0x37
  jmp alltraps
80105de9:	e9 6a f8 ff ff       	jmp    80105658 <alltraps>

80105dee <vector56>:
.globl vector56
vector56:
  pushl $0
80105dee:	6a 00                	push   $0x0
  pushl $56
80105df0:	6a 38                	push   $0x38
  jmp alltraps
80105df2:	e9 61 f8 ff ff       	jmp    80105658 <alltraps>

80105df7 <vector57>:
.globl vector57
vector57:
  pushl $0
80105df7:	6a 00                	push   $0x0
  pushl $57
80105df9:	6a 39                	push   $0x39
  jmp alltraps
80105dfb:	e9 58 f8 ff ff       	jmp    80105658 <alltraps>

80105e00 <vector58>:
.globl vector58
vector58:
  pushl $0
80105e00:	6a 00                	push   $0x0
  pushl $58
80105e02:	6a 3a                	push   $0x3a
  jmp alltraps
80105e04:	e9 4f f8 ff ff       	jmp    80105658 <alltraps>

80105e09 <vector59>:
.globl vector59
vector59:
  pushl $0
80105e09:	6a 00                	push   $0x0
  pushl $59
80105e0b:	6a 3b                	push   $0x3b
  jmp alltraps
80105e0d:	e9 46 f8 ff ff       	jmp    80105658 <alltraps>

80105e12 <vector60>:
.globl vector60
vector60:
  pushl $0
80105e12:	6a 00                	push   $0x0
  pushl $60
80105e14:	6a 3c                	push   $0x3c
  jmp alltraps
80105e16:	e9 3d f8 ff ff       	jmp    80105658 <alltraps>

80105e1b <vector61>:
.globl vector61
vector61:
  pushl $0
80105e1b:	6a 00                	push   $0x0
  pushl $61
80105e1d:	6a 3d                	push   $0x3d
  jmp alltraps
80105e1f:	e9 34 f8 ff ff       	jmp    80105658 <alltraps>

80105e24 <vector62>:
.globl vector62
vector62:
  pushl $0
80105e24:	6a 00                	push   $0x0
  pushl $62
80105e26:	6a 3e                	push   $0x3e
  jmp alltraps
80105e28:	e9 2b f8 ff ff       	jmp    80105658 <alltraps>

80105e2d <vector63>:
.globl vector63
vector63:
  pushl $0
80105e2d:	6a 00                	push   $0x0
  pushl $63
80105e2f:	6a 3f                	push   $0x3f
  jmp alltraps
80105e31:	e9 22 f8 ff ff       	jmp    80105658 <alltraps>

80105e36 <vector64>:
.globl vector64
vector64:
  pushl $0
80105e36:	6a 00                	push   $0x0
  pushl $64
80105e38:	6a 40                	push   $0x40
  jmp alltraps
80105e3a:	e9 19 f8 ff ff       	jmp    80105658 <alltraps>

80105e3f <vector65>:
.globl vector65
vector65:
  pushl $0
80105e3f:	6a 00                	push   $0x0
  pushl $65
80105e41:	6a 41                	push   $0x41
  jmp alltraps
80105e43:	e9 10 f8 ff ff       	jmp    80105658 <alltraps>

80105e48 <vector66>:
.globl vector66
vector66:
  pushl $0
80105e48:	6a 00                	push   $0x0
  pushl $66
80105e4a:	6a 42                	push   $0x42
  jmp alltraps
80105e4c:	e9 07 f8 ff ff       	jmp    80105658 <alltraps>

80105e51 <vector67>:
.globl vector67
vector67:
  pushl $0
80105e51:	6a 00                	push   $0x0
  pushl $67
80105e53:	6a 43                	push   $0x43
  jmp alltraps
80105e55:	e9 fe f7 ff ff       	jmp    80105658 <alltraps>

80105e5a <vector68>:
.globl vector68
vector68:
  pushl $0
80105e5a:	6a 00                	push   $0x0
  pushl $68
80105e5c:	6a 44                	push   $0x44
  jmp alltraps
80105e5e:	e9 f5 f7 ff ff       	jmp    80105658 <alltraps>

80105e63 <vector69>:
.globl vector69
vector69:
  pushl $0
80105e63:	6a 00                	push   $0x0
  pushl $69
80105e65:	6a 45                	push   $0x45
  jmp alltraps
80105e67:	e9 ec f7 ff ff       	jmp    80105658 <alltraps>

80105e6c <vector70>:
.globl vector70
vector70:
  pushl $0
80105e6c:	6a 00                	push   $0x0
  pushl $70
80105e6e:	6a 46                	push   $0x46
  jmp alltraps
80105e70:	e9 e3 f7 ff ff       	jmp    80105658 <alltraps>

80105e75 <vector71>:
.globl vector71
vector71:
  pushl $0
80105e75:	6a 00                	push   $0x0
  pushl $71
80105e77:	6a 47                	push   $0x47
  jmp alltraps
80105e79:	e9 da f7 ff ff       	jmp    80105658 <alltraps>

80105e7e <vector72>:
.globl vector72
vector72:
  pushl $0
80105e7e:	6a 00                	push   $0x0
  pushl $72
80105e80:	6a 48                	push   $0x48
  jmp alltraps
80105e82:	e9 d1 f7 ff ff       	jmp    80105658 <alltraps>

80105e87 <vector73>:
.globl vector73
vector73:
  pushl $0
80105e87:	6a 00                	push   $0x0
  pushl $73
80105e89:	6a 49                	push   $0x49
  jmp alltraps
80105e8b:	e9 c8 f7 ff ff       	jmp    80105658 <alltraps>

80105e90 <vector74>:
.globl vector74
vector74:
  pushl $0
80105e90:	6a 00                	push   $0x0
  pushl $74
80105e92:	6a 4a                	push   $0x4a
  jmp alltraps
80105e94:	e9 bf f7 ff ff       	jmp    80105658 <alltraps>

80105e99 <vector75>:
.globl vector75
vector75:
  pushl $0
80105e99:	6a 00                	push   $0x0
  pushl $75
80105e9b:	6a 4b                	push   $0x4b
  jmp alltraps
80105e9d:	e9 b6 f7 ff ff       	jmp    80105658 <alltraps>

80105ea2 <vector76>:
.globl vector76
vector76:
  pushl $0
80105ea2:	6a 00                	push   $0x0
  pushl $76
80105ea4:	6a 4c                	push   $0x4c
  jmp alltraps
80105ea6:	e9 ad f7 ff ff       	jmp    80105658 <alltraps>

80105eab <vector77>:
.globl vector77
vector77:
  pushl $0
80105eab:	6a 00                	push   $0x0
  pushl $77
80105ead:	6a 4d                	push   $0x4d
  jmp alltraps
80105eaf:	e9 a4 f7 ff ff       	jmp    80105658 <alltraps>

80105eb4 <vector78>:
.globl vector78
vector78:
  pushl $0
80105eb4:	6a 00                	push   $0x0
  pushl $78
80105eb6:	6a 4e                	push   $0x4e
  jmp alltraps
80105eb8:	e9 9b f7 ff ff       	jmp    80105658 <alltraps>

80105ebd <vector79>:
.globl vector79
vector79:
  pushl $0
80105ebd:	6a 00                	push   $0x0
  pushl $79
80105ebf:	6a 4f                	push   $0x4f
  jmp alltraps
80105ec1:	e9 92 f7 ff ff       	jmp    80105658 <alltraps>

80105ec6 <vector80>:
.globl vector80
vector80:
  pushl $0
80105ec6:	6a 00                	push   $0x0
  pushl $80
80105ec8:	6a 50                	push   $0x50
  jmp alltraps
80105eca:	e9 89 f7 ff ff       	jmp    80105658 <alltraps>

80105ecf <vector81>:
.globl vector81
vector81:
  pushl $0
80105ecf:	6a 00                	push   $0x0
  pushl $81
80105ed1:	6a 51                	push   $0x51
  jmp alltraps
80105ed3:	e9 80 f7 ff ff       	jmp    80105658 <alltraps>

80105ed8 <vector82>:
.globl vector82
vector82:
  pushl $0
80105ed8:	6a 00                	push   $0x0
  pushl $82
80105eda:	6a 52                	push   $0x52
  jmp alltraps
80105edc:	e9 77 f7 ff ff       	jmp    80105658 <alltraps>

80105ee1 <vector83>:
.globl vector83
vector83:
  pushl $0
80105ee1:	6a 00                	push   $0x0
  pushl $83
80105ee3:	6a 53                	push   $0x53
  jmp alltraps
80105ee5:	e9 6e f7 ff ff       	jmp    80105658 <alltraps>

80105eea <vector84>:
.globl vector84
vector84:
  pushl $0
80105eea:	6a 00                	push   $0x0
  pushl $84
80105eec:	6a 54                	push   $0x54
  jmp alltraps
80105eee:	e9 65 f7 ff ff       	jmp    80105658 <alltraps>

80105ef3 <vector85>:
.globl vector85
vector85:
  pushl $0
80105ef3:	6a 00                	push   $0x0
  pushl $85
80105ef5:	6a 55                	push   $0x55
  jmp alltraps
80105ef7:	e9 5c f7 ff ff       	jmp    80105658 <alltraps>

80105efc <vector86>:
.globl vector86
vector86:
  pushl $0
80105efc:	6a 00                	push   $0x0
  pushl $86
80105efe:	6a 56                	push   $0x56
  jmp alltraps
80105f00:	e9 53 f7 ff ff       	jmp    80105658 <alltraps>

80105f05 <vector87>:
.globl vector87
vector87:
  pushl $0
80105f05:	6a 00                	push   $0x0
  pushl $87
80105f07:	6a 57                	push   $0x57
  jmp alltraps
80105f09:	e9 4a f7 ff ff       	jmp    80105658 <alltraps>

80105f0e <vector88>:
.globl vector88
vector88:
  pushl $0
80105f0e:	6a 00                	push   $0x0
  pushl $88
80105f10:	6a 58                	push   $0x58
  jmp alltraps
80105f12:	e9 41 f7 ff ff       	jmp    80105658 <alltraps>

80105f17 <vector89>:
.globl vector89
vector89:
  pushl $0
80105f17:	6a 00                	push   $0x0
  pushl $89
80105f19:	6a 59                	push   $0x59
  jmp alltraps
80105f1b:	e9 38 f7 ff ff       	jmp    80105658 <alltraps>

80105f20 <vector90>:
.globl vector90
vector90:
  pushl $0
80105f20:	6a 00                	push   $0x0
  pushl $90
80105f22:	6a 5a                	push   $0x5a
  jmp alltraps
80105f24:	e9 2f f7 ff ff       	jmp    80105658 <alltraps>

80105f29 <vector91>:
.globl vector91
vector91:
  pushl $0
80105f29:	6a 00                	push   $0x0
  pushl $91
80105f2b:	6a 5b                	push   $0x5b
  jmp alltraps
80105f2d:	e9 26 f7 ff ff       	jmp    80105658 <alltraps>

80105f32 <vector92>:
.globl vector92
vector92:
  pushl $0
80105f32:	6a 00                	push   $0x0
  pushl $92
80105f34:	6a 5c                	push   $0x5c
  jmp alltraps
80105f36:	e9 1d f7 ff ff       	jmp    80105658 <alltraps>

80105f3b <vector93>:
.globl vector93
vector93:
  pushl $0
80105f3b:	6a 00                	push   $0x0
  pushl $93
80105f3d:	6a 5d                	push   $0x5d
  jmp alltraps
80105f3f:	e9 14 f7 ff ff       	jmp    80105658 <alltraps>

80105f44 <vector94>:
.globl vector94
vector94:
  pushl $0
80105f44:	6a 00                	push   $0x0
  pushl $94
80105f46:	6a 5e                	push   $0x5e
  jmp alltraps
80105f48:	e9 0b f7 ff ff       	jmp    80105658 <alltraps>

80105f4d <vector95>:
.globl vector95
vector95:
  pushl $0
80105f4d:	6a 00                	push   $0x0
  pushl $95
80105f4f:	6a 5f                	push   $0x5f
  jmp alltraps
80105f51:	e9 02 f7 ff ff       	jmp    80105658 <alltraps>

80105f56 <vector96>:
.globl vector96
vector96:
  pushl $0
80105f56:	6a 00                	push   $0x0
  pushl $96
80105f58:	6a 60                	push   $0x60
  jmp alltraps
80105f5a:	e9 f9 f6 ff ff       	jmp    80105658 <alltraps>

80105f5f <vector97>:
.globl vector97
vector97:
  pushl $0
80105f5f:	6a 00                	push   $0x0
  pushl $97
80105f61:	6a 61                	push   $0x61
  jmp alltraps
80105f63:	e9 f0 f6 ff ff       	jmp    80105658 <alltraps>

80105f68 <vector98>:
.globl vector98
vector98:
  pushl $0
80105f68:	6a 00                	push   $0x0
  pushl $98
80105f6a:	6a 62                	push   $0x62
  jmp alltraps
80105f6c:	e9 e7 f6 ff ff       	jmp    80105658 <alltraps>

80105f71 <vector99>:
.globl vector99
vector99:
  pushl $0
80105f71:	6a 00                	push   $0x0
  pushl $99
80105f73:	6a 63                	push   $0x63
  jmp alltraps
80105f75:	e9 de f6 ff ff       	jmp    80105658 <alltraps>

80105f7a <vector100>:
.globl vector100
vector100:
  pushl $0
80105f7a:	6a 00                	push   $0x0
  pushl $100
80105f7c:	6a 64                	push   $0x64
  jmp alltraps
80105f7e:	e9 d5 f6 ff ff       	jmp    80105658 <alltraps>

80105f83 <vector101>:
.globl vector101
vector101:
  pushl $0
80105f83:	6a 00                	push   $0x0
  pushl $101
80105f85:	6a 65                	push   $0x65
  jmp alltraps
80105f87:	e9 cc f6 ff ff       	jmp    80105658 <alltraps>

80105f8c <vector102>:
.globl vector102
vector102:
  pushl $0
80105f8c:	6a 00                	push   $0x0
  pushl $102
80105f8e:	6a 66                	push   $0x66
  jmp alltraps
80105f90:	e9 c3 f6 ff ff       	jmp    80105658 <alltraps>

80105f95 <vector103>:
.globl vector103
vector103:
  pushl $0
80105f95:	6a 00                	push   $0x0
  pushl $103
80105f97:	6a 67                	push   $0x67
  jmp alltraps
80105f99:	e9 ba f6 ff ff       	jmp    80105658 <alltraps>

80105f9e <vector104>:
.globl vector104
vector104:
  pushl $0
80105f9e:	6a 00                	push   $0x0
  pushl $104
80105fa0:	6a 68                	push   $0x68
  jmp alltraps
80105fa2:	e9 b1 f6 ff ff       	jmp    80105658 <alltraps>

80105fa7 <vector105>:
.globl vector105
vector105:
  pushl $0
80105fa7:	6a 00                	push   $0x0
  pushl $105
80105fa9:	6a 69                	push   $0x69
  jmp alltraps
80105fab:	e9 a8 f6 ff ff       	jmp    80105658 <alltraps>

80105fb0 <vector106>:
.globl vector106
vector106:
  pushl $0
80105fb0:	6a 00                	push   $0x0
  pushl $106
80105fb2:	6a 6a                	push   $0x6a
  jmp alltraps
80105fb4:	e9 9f f6 ff ff       	jmp    80105658 <alltraps>

80105fb9 <vector107>:
.globl vector107
vector107:
  pushl $0
80105fb9:	6a 00                	push   $0x0
  pushl $107
80105fbb:	6a 6b                	push   $0x6b
  jmp alltraps
80105fbd:	e9 96 f6 ff ff       	jmp    80105658 <alltraps>

80105fc2 <vector108>:
.globl vector108
vector108:
  pushl $0
80105fc2:	6a 00                	push   $0x0
  pushl $108
80105fc4:	6a 6c                	push   $0x6c
  jmp alltraps
80105fc6:	e9 8d f6 ff ff       	jmp    80105658 <alltraps>

80105fcb <vector109>:
.globl vector109
vector109:
  pushl $0
80105fcb:	6a 00                	push   $0x0
  pushl $109
80105fcd:	6a 6d                	push   $0x6d
  jmp alltraps
80105fcf:	e9 84 f6 ff ff       	jmp    80105658 <alltraps>

80105fd4 <vector110>:
.globl vector110
vector110:
  pushl $0
80105fd4:	6a 00                	push   $0x0
  pushl $110
80105fd6:	6a 6e                	push   $0x6e
  jmp alltraps
80105fd8:	e9 7b f6 ff ff       	jmp    80105658 <alltraps>

80105fdd <vector111>:
.globl vector111
vector111:
  pushl $0
80105fdd:	6a 00                	push   $0x0
  pushl $111
80105fdf:	6a 6f                	push   $0x6f
  jmp alltraps
80105fe1:	e9 72 f6 ff ff       	jmp    80105658 <alltraps>

80105fe6 <vector112>:
.globl vector112
vector112:
  pushl $0
80105fe6:	6a 00                	push   $0x0
  pushl $112
80105fe8:	6a 70                	push   $0x70
  jmp alltraps
80105fea:	e9 69 f6 ff ff       	jmp    80105658 <alltraps>

80105fef <vector113>:
.globl vector113
vector113:
  pushl $0
80105fef:	6a 00                	push   $0x0
  pushl $113
80105ff1:	6a 71                	push   $0x71
  jmp alltraps
80105ff3:	e9 60 f6 ff ff       	jmp    80105658 <alltraps>

80105ff8 <vector114>:
.globl vector114
vector114:
  pushl $0
80105ff8:	6a 00                	push   $0x0
  pushl $114
80105ffa:	6a 72                	push   $0x72
  jmp alltraps
80105ffc:	e9 57 f6 ff ff       	jmp    80105658 <alltraps>

80106001 <vector115>:
.globl vector115
vector115:
  pushl $0
80106001:	6a 00                	push   $0x0
  pushl $115
80106003:	6a 73                	push   $0x73
  jmp alltraps
80106005:	e9 4e f6 ff ff       	jmp    80105658 <alltraps>

8010600a <vector116>:
.globl vector116
vector116:
  pushl $0
8010600a:	6a 00                	push   $0x0
  pushl $116
8010600c:	6a 74                	push   $0x74
  jmp alltraps
8010600e:	e9 45 f6 ff ff       	jmp    80105658 <alltraps>

80106013 <vector117>:
.globl vector117
vector117:
  pushl $0
80106013:	6a 00                	push   $0x0
  pushl $117
80106015:	6a 75                	push   $0x75
  jmp alltraps
80106017:	e9 3c f6 ff ff       	jmp    80105658 <alltraps>

8010601c <vector118>:
.globl vector118
vector118:
  pushl $0
8010601c:	6a 00                	push   $0x0
  pushl $118
8010601e:	6a 76                	push   $0x76
  jmp alltraps
80106020:	e9 33 f6 ff ff       	jmp    80105658 <alltraps>

80106025 <vector119>:
.globl vector119
vector119:
  pushl $0
80106025:	6a 00                	push   $0x0
  pushl $119
80106027:	6a 77                	push   $0x77
  jmp alltraps
80106029:	e9 2a f6 ff ff       	jmp    80105658 <alltraps>

8010602e <vector120>:
.globl vector120
vector120:
  pushl $0
8010602e:	6a 00                	push   $0x0
  pushl $120
80106030:	6a 78                	push   $0x78
  jmp alltraps
80106032:	e9 21 f6 ff ff       	jmp    80105658 <alltraps>

80106037 <vector121>:
.globl vector121
vector121:
  pushl $0
80106037:	6a 00                	push   $0x0
  pushl $121
80106039:	6a 79                	push   $0x79
  jmp alltraps
8010603b:	e9 18 f6 ff ff       	jmp    80105658 <alltraps>

80106040 <vector122>:
.globl vector122
vector122:
  pushl $0
80106040:	6a 00                	push   $0x0
  pushl $122
80106042:	6a 7a                	push   $0x7a
  jmp alltraps
80106044:	e9 0f f6 ff ff       	jmp    80105658 <alltraps>

80106049 <vector123>:
.globl vector123
vector123:
  pushl $0
80106049:	6a 00                	push   $0x0
  pushl $123
8010604b:	6a 7b                	push   $0x7b
  jmp alltraps
8010604d:	e9 06 f6 ff ff       	jmp    80105658 <alltraps>

80106052 <vector124>:
.globl vector124
vector124:
  pushl $0
80106052:	6a 00                	push   $0x0
  pushl $124
80106054:	6a 7c                	push   $0x7c
  jmp alltraps
80106056:	e9 fd f5 ff ff       	jmp    80105658 <alltraps>

8010605b <vector125>:
.globl vector125
vector125:
  pushl $0
8010605b:	6a 00                	push   $0x0
  pushl $125
8010605d:	6a 7d                	push   $0x7d
  jmp alltraps
8010605f:	e9 f4 f5 ff ff       	jmp    80105658 <alltraps>

80106064 <vector126>:
.globl vector126
vector126:
  pushl $0
80106064:	6a 00                	push   $0x0
  pushl $126
80106066:	6a 7e                	push   $0x7e
  jmp alltraps
80106068:	e9 eb f5 ff ff       	jmp    80105658 <alltraps>

8010606d <vector127>:
.globl vector127
vector127:
  pushl $0
8010606d:	6a 00                	push   $0x0
  pushl $127
8010606f:	6a 7f                	push   $0x7f
  jmp alltraps
80106071:	e9 e2 f5 ff ff       	jmp    80105658 <alltraps>

80106076 <vector128>:
.globl vector128
vector128:
  pushl $0
80106076:	6a 00                	push   $0x0
  pushl $128
80106078:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010607d:	e9 d6 f5 ff ff       	jmp    80105658 <alltraps>

80106082 <vector129>:
.globl vector129
vector129:
  pushl $0
80106082:	6a 00                	push   $0x0
  pushl $129
80106084:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106089:	e9 ca f5 ff ff       	jmp    80105658 <alltraps>

8010608e <vector130>:
.globl vector130
vector130:
  pushl $0
8010608e:	6a 00                	push   $0x0
  pushl $130
80106090:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106095:	e9 be f5 ff ff       	jmp    80105658 <alltraps>

8010609a <vector131>:
.globl vector131
vector131:
  pushl $0
8010609a:	6a 00                	push   $0x0
  pushl $131
8010609c:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801060a1:	e9 b2 f5 ff ff       	jmp    80105658 <alltraps>

801060a6 <vector132>:
.globl vector132
vector132:
  pushl $0
801060a6:	6a 00                	push   $0x0
  pushl $132
801060a8:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801060ad:	e9 a6 f5 ff ff       	jmp    80105658 <alltraps>

801060b2 <vector133>:
.globl vector133
vector133:
  pushl $0
801060b2:	6a 00                	push   $0x0
  pushl $133
801060b4:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801060b9:	e9 9a f5 ff ff       	jmp    80105658 <alltraps>

801060be <vector134>:
.globl vector134
vector134:
  pushl $0
801060be:	6a 00                	push   $0x0
  pushl $134
801060c0:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801060c5:	e9 8e f5 ff ff       	jmp    80105658 <alltraps>

801060ca <vector135>:
.globl vector135
vector135:
  pushl $0
801060ca:	6a 00                	push   $0x0
  pushl $135
801060cc:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801060d1:	e9 82 f5 ff ff       	jmp    80105658 <alltraps>

801060d6 <vector136>:
.globl vector136
vector136:
  pushl $0
801060d6:	6a 00                	push   $0x0
  pushl $136
801060d8:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801060dd:	e9 76 f5 ff ff       	jmp    80105658 <alltraps>

801060e2 <vector137>:
.globl vector137
vector137:
  pushl $0
801060e2:	6a 00                	push   $0x0
  pushl $137
801060e4:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801060e9:	e9 6a f5 ff ff       	jmp    80105658 <alltraps>

801060ee <vector138>:
.globl vector138
vector138:
  pushl $0
801060ee:	6a 00                	push   $0x0
  pushl $138
801060f0:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801060f5:	e9 5e f5 ff ff       	jmp    80105658 <alltraps>

801060fa <vector139>:
.globl vector139
vector139:
  pushl $0
801060fa:	6a 00                	push   $0x0
  pushl $139
801060fc:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106101:	e9 52 f5 ff ff       	jmp    80105658 <alltraps>

80106106 <vector140>:
.globl vector140
vector140:
  pushl $0
80106106:	6a 00                	push   $0x0
  pushl $140
80106108:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010610d:	e9 46 f5 ff ff       	jmp    80105658 <alltraps>

80106112 <vector141>:
.globl vector141
vector141:
  pushl $0
80106112:	6a 00                	push   $0x0
  pushl $141
80106114:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106119:	e9 3a f5 ff ff       	jmp    80105658 <alltraps>

8010611e <vector142>:
.globl vector142
vector142:
  pushl $0
8010611e:	6a 00                	push   $0x0
  pushl $142
80106120:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106125:	e9 2e f5 ff ff       	jmp    80105658 <alltraps>

8010612a <vector143>:
.globl vector143
vector143:
  pushl $0
8010612a:	6a 00                	push   $0x0
  pushl $143
8010612c:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106131:	e9 22 f5 ff ff       	jmp    80105658 <alltraps>

80106136 <vector144>:
.globl vector144
vector144:
  pushl $0
80106136:	6a 00                	push   $0x0
  pushl $144
80106138:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010613d:	e9 16 f5 ff ff       	jmp    80105658 <alltraps>

80106142 <vector145>:
.globl vector145
vector145:
  pushl $0
80106142:	6a 00                	push   $0x0
  pushl $145
80106144:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106149:	e9 0a f5 ff ff       	jmp    80105658 <alltraps>

8010614e <vector146>:
.globl vector146
vector146:
  pushl $0
8010614e:	6a 00                	push   $0x0
  pushl $146
80106150:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106155:	e9 fe f4 ff ff       	jmp    80105658 <alltraps>

8010615a <vector147>:
.globl vector147
vector147:
  pushl $0
8010615a:	6a 00                	push   $0x0
  pushl $147
8010615c:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106161:	e9 f2 f4 ff ff       	jmp    80105658 <alltraps>

80106166 <vector148>:
.globl vector148
vector148:
  pushl $0
80106166:	6a 00                	push   $0x0
  pushl $148
80106168:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010616d:	e9 e6 f4 ff ff       	jmp    80105658 <alltraps>

80106172 <vector149>:
.globl vector149
vector149:
  pushl $0
80106172:	6a 00                	push   $0x0
  pushl $149
80106174:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106179:	e9 da f4 ff ff       	jmp    80105658 <alltraps>

8010617e <vector150>:
.globl vector150
vector150:
  pushl $0
8010617e:	6a 00                	push   $0x0
  pushl $150
80106180:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106185:	e9 ce f4 ff ff       	jmp    80105658 <alltraps>

8010618a <vector151>:
.globl vector151
vector151:
  pushl $0
8010618a:	6a 00                	push   $0x0
  pushl $151
8010618c:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106191:	e9 c2 f4 ff ff       	jmp    80105658 <alltraps>

80106196 <vector152>:
.globl vector152
vector152:
  pushl $0
80106196:	6a 00                	push   $0x0
  pushl $152
80106198:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010619d:	e9 b6 f4 ff ff       	jmp    80105658 <alltraps>

801061a2 <vector153>:
.globl vector153
vector153:
  pushl $0
801061a2:	6a 00                	push   $0x0
  pushl $153
801061a4:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801061a9:	e9 aa f4 ff ff       	jmp    80105658 <alltraps>

801061ae <vector154>:
.globl vector154
vector154:
  pushl $0
801061ae:	6a 00                	push   $0x0
  pushl $154
801061b0:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801061b5:	e9 9e f4 ff ff       	jmp    80105658 <alltraps>

801061ba <vector155>:
.globl vector155
vector155:
  pushl $0
801061ba:	6a 00                	push   $0x0
  pushl $155
801061bc:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801061c1:	e9 92 f4 ff ff       	jmp    80105658 <alltraps>

801061c6 <vector156>:
.globl vector156
vector156:
  pushl $0
801061c6:	6a 00                	push   $0x0
  pushl $156
801061c8:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801061cd:	e9 86 f4 ff ff       	jmp    80105658 <alltraps>

801061d2 <vector157>:
.globl vector157
vector157:
  pushl $0
801061d2:	6a 00                	push   $0x0
  pushl $157
801061d4:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801061d9:	e9 7a f4 ff ff       	jmp    80105658 <alltraps>

801061de <vector158>:
.globl vector158
vector158:
  pushl $0
801061de:	6a 00                	push   $0x0
  pushl $158
801061e0:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801061e5:	e9 6e f4 ff ff       	jmp    80105658 <alltraps>

801061ea <vector159>:
.globl vector159
vector159:
  pushl $0
801061ea:	6a 00                	push   $0x0
  pushl $159
801061ec:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801061f1:	e9 62 f4 ff ff       	jmp    80105658 <alltraps>

801061f6 <vector160>:
.globl vector160
vector160:
  pushl $0
801061f6:	6a 00                	push   $0x0
  pushl $160
801061f8:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801061fd:	e9 56 f4 ff ff       	jmp    80105658 <alltraps>

80106202 <vector161>:
.globl vector161
vector161:
  pushl $0
80106202:	6a 00                	push   $0x0
  pushl $161
80106204:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106209:	e9 4a f4 ff ff       	jmp    80105658 <alltraps>

8010620e <vector162>:
.globl vector162
vector162:
  pushl $0
8010620e:	6a 00                	push   $0x0
  pushl $162
80106210:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106215:	e9 3e f4 ff ff       	jmp    80105658 <alltraps>

8010621a <vector163>:
.globl vector163
vector163:
  pushl $0
8010621a:	6a 00                	push   $0x0
  pushl $163
8010621c:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106221:	e9 32 f4 ff ff       	jmp    80105658 <alltraps>

80106226 <vector164>:
.globl vector164
vector164:
  pushl $0
80106226:	6a 00                	push   $0x0
  pushl $164
80106228:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010622d:	e9 26 f4 ff ff       	jmp    80105658 <alltraps>

80106232 <vector165>:
.globl vector165
vector165:
  pushl $0
80106232:	6a 00                	push   $0x0
  pushl $165
80106234:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106239:	e9 1a f4 ff ff       	jmp    80105658 <alltraps>

8010623e <vector166>:
.globl vector166
vector166:
  pushl $0
8010623e:	6a 00                	push   $0x0
  pushl $166
80106240:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106245:	e9 0e f4 ff ff       	jmp    80105658 <alltraps>

8010624a <vector167>:
.globl vector167
vector167:
  pushl $0
8010624a:	6a 00                	push   $0x0
  pushl $167
8010624c:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106251:	e9 02 f4 ff ff       	jmp    80105658 <alltraps>

80106256 <vector168>:
.globl vector168
vector168:
  pushl $0
80106256:	6a 00                	push   $0x0
  pushl $168
80106258:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010625d:	e9 f6 f3 ff ff       	jmp    80105658 <alltraps>

80106262 <vector169>:
.globl vector169
vector169:
  pushl $0
80106262:	6a 00                	push   $0x0
  pushl $169
80106264:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106269:	e9 ea f3 ff ff       	jmp    80105658 <alltraps>

8010626e <vector170>:
.globl vector170
vector170:
  pushl $0
8010626e:	6a 00                	push   $0x0
  pushl $170
80106270:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106275:	e9 de f3 ff ff       	jmp    80105658 <alltraps>

8010627a <vector171>:
.globl vector171
vector171:
  pushl $0
8010627a:	6a 00                	push   $0x0
  pushl $171
8010627c:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106281:	e9 d2 f3 ff ff       	jmp    80105658 <alltraps>

80106286 <vector172>:
.globl vector172
vector172:
  pushl $0
80106286:	6a 00                	push   $0x0
  pushl $172
80106288:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010628d:	e9 c6 f3 ff ff       	jmp    80105658 <alltraps>

80106292 <vector173>:
.globl vector173
vector173:
  pushl $0
80106292:	6a 00                	push   $0x0
  pushl $173
80106294:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106299:	e9 ba f3 ff ff       	jmp    80105658 <alltraps>

8010629e <vector174>:
.globl vector174
vector174:
  pushl $0
8010629e:	6a 00                	push   $0x0
  pushl $174
801062a0:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801062a5:	e9 ae f3 ff ff       	jmp    80105658 <alltraps>

801062aa <vector175>:
.globl vector175
vector175:
  pushl $0
801062aa:	6a 00                	push   $0x0
  pushl $175
801062ac:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801062b1:	e9 a2 f3 ff ff       	jmp    80105658 <alltraps>

801062b6 <vector176>:
.globl vector176
vector176:
  pushl $0
801062b6:	6a 00                	push   $0x0
  pushl $176
801062b8:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801062bd:	e9 96 f3 ff ff       	jmp    80105658 <alltraps>

801062c2 <vector177>:
.globl vector177
vector177:
  pushl $0
801062c2:	6a 00                	push   $0x0
  pushl $177
801062c4:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801062c9:	e9 8a f3 ff ff       	jmp    80105658 <alltraps>

801062ce <vector178>:
.globl vector178
vector178:
  pushl $0
801062ce:	6a 00                	push   $0x0
  pushl $178
801062d0:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801062d5:	e9 7e f3 ff ff       	jmp    80105658 <alltraps>

801062da <vector179>:
.globl vector179
vector179:
  pushl $0
801062da:	6a 00                	push   $0x0
  pushl $179
801062dc:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801062e1:	e9 72 f3 ff ff       	jmp    80105658 <alltraps>

801062e6 <vector180>:
.globl vector180
vector180:
  pushl $0
801062e6:	6a 00                	push   $0x0
  pushl $180
801062e8:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801062ed:	e9 66 f3 ff ff       	jmp    80105658 <alltraps>

801062f2 <vector181>:
.globl vector181
vector181:
  pushl $0
801062f2:	6a 00                	push   $0x0
  pushl $181
801062f4:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801062f9:	e9 5a f3 ff ff       	jmp    80105658 <alltraps>

801062fe <vector182>:
.globl vector182
vector182:
  pushl $0
801062fe:	6a 00                	push   $0x0
  pushl $182
80106300:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106305:	e9 4e f3 ff ff       	jmp    80105658 <alltraps>

8010630a <vector183>:
.globl vector183
vector183:
  pushl $0
8010630a:	6a 00                	push   $0x0
  pushl $183
8010630c:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106311:	e9 42 f3 ff ff       	jmp    80105658 <alltraps>

80106316 <vector184>:
.globl vector184
vector184:
  pushl $0
80106316:	6a 00                	push   $0x0
  pushl $184
80106318:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010631d:	e9 36 f3 ff ff       	jmp    80105658 <alltraps>

80106322 <vector185>:
.globl vector185
vector185:
  pushl $0
80106322:	6a 00                	push   $0x0
  pushl $185
80106324:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106329:	e9 2a f3 ff ff       	jmp    80105658 <alltraps>

8010632e <vector186>:
.globl vector186
vector186:
  pushl $0
8010632e:	6a 00                	push   $0x0
  pushl $186
80106330:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106335:	e9 1e f3 ff ff       	jmp    80105658 <alltraps>

8010633a <vector187>:
.globl vector187
vector187:
  pushl $0
8010633a:	6a 00                	push   $0x0
  pushl $187
8010633c:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106341:	e9 12 f3 ff ff       	jmp    80105658 <alltraps>

80106346 <vector188>:
.globl vector188
vector188:
  pushl $0
80106346:	6a 00                	push   $0x0
  pushl $188
80106348:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010634d:	e9 06 f3 ff ff       	jmp    80105658 <alltraps>

80106352 <vector189>:
.globl vector189
vector189:
  pushl $0
80106352:	6a 00                	push   $0x0
  pushl $189
80106354:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106359:	e9 fa f2 ff ff       	jmp    80105658 <alltraps>

8010635e <vector190>:
.globl vector190
vector190:
  pushl $0
8010635e:	6a 00                	push   $0x0
  pushl $190
80106360:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106365:	e9 ee f2 ff ff       	jmp    80105658 <alltraps>

8010636a <vector191>:
.globl vector191
vector191:
  pushl $0
8010636a:	6a 00                	push   $0x0
  pushl $191
8010636c:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106371:	e9 e2 f2 ff ff       	jmp    80105658 <alltraps>

80106376 <vector192>:
.globl vector192
vector192:
  pushl $0
80106376:	6a 00                	push   $0x0
  pushl $192
80106378:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010637d:	e9 d6 f2 ff ff       	jmp    80105658 <alltraps>

80106382 <vector193>:
.globl vector193
vector193:
  pushl $0
80106382:	6a 00                	push   $0x0
  pushl $193
80106384:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106389:	e9 ca f2 ff ff       	jmp    80105658 <alltraps>

8010638e <vector194>:
.globl vector194
vector194:
  pushl $0
8010638e:	6a 00                	push   $0x0
  pushl $194
80106390:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106395:	e9 be f2 ff ff       	jmp    80105658 <alltraps>

8010639a <vector195>:
.globl vector195
vector195:
  pushl $0
8010639a:	6a 00                	push   $0x0
  pushl $195
8010639c:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801063a1:	e9 b2 f2 ff ff       	jmp    80105658 <alltraps>

801063a6 <vector196>:
.globl vector196
vector196:
  pushl $0
801063a6:	6a 00                	push   $0x0
  pushl $196
801063a8:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801063ad:	e9 a6 f2 ff ff       	jmp    80105658 <alltraps>

801063b2 <vector197>:
.globl vector197
vector197:
  pushl $0
801063b2:	6a 00                	push   $0x0
  pushl $197
801063b4:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801063b9:	e9 9a f2 ff ff       	jmp    80105658 <alltraps>

801063be <vector198>:
.globl vector198
vector198:
  pushl $0
801063be:	6a 00                	push   $0x0
  pushl $198
801063c0:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801063c5:	e9 8e f2 ff ff       	jmp    80105658 <alltraps>

801063ca <vector199>:
.globl vector199
vector199:
  pushl $0
801063ca:	6a 00                	push   $0x0
  pushl $199
801063cc:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801063d1:	e9 82 f2 ff ff       	jmp    80105658 <alltraps>

801063d6 <vector200>:
.globl vector200
vector200:
  pushl $0
801063d6:	6a 00                	push   $0x0
  pushl $200
801063d8:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801063dd:	e9 76 f2 ff ff       	jmp    80105658 <alltraps>

801063e2 <vector201>:
.globl vector201
vector201:
  pushl $0
801063e2:	6a 00                	push   $0x0
  pushl $201
801063e4:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801063e9:	e9 6a f2 ff ff       	jmp    80105658 <alltraps>

801063ee <vector202>:
.globl vector202
vector202:
  pushl $0
801063ee:	6a 00                	push   $0x0
  pushl $202
801063f0:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801063f5:	e9 5e f2 ff ff       	jmp    80105658 <alltraps>

801063fa <vector203>:
.globl vector203
vector203:
  pushl $0
801063fa:	6a 00                	push   $0x0
  pushl $203
801063fc:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106401:	e9 52 f2 ff ff       	jmp    80105658 <alltraps>

80106406 <vector204>:
.globl vector204
vector204:
  pushl $0
80106406:	6a 00                	push   $0x0
  pushl $204
80106408:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010640d:	e9 46 f2 ff ff       	jmp    80105658 <alltraps>

80106412 <vector205>:
.globl vector205
vector205:
  pushl $0
80106412:	6a 00                	push   $0x0
  pushl $205
80106414:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106419:	e9 3a f2 ff ff       	jmp    80105658 <alltraps>

8010641e <vector206>:
.globl vector206
vector206:
  pushl $0
8010641e:	6a 00                	push   $0x0
  pushl $206
80106420:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106425:	e9 2e f2 ff ff       	jmp    80105658 <alltraps>

8010642a <vector207>:
.globl vector207
vector207:
  pushl $0
8010642a:	6a 00                	push   $0x0
  pushl $207
8010642c:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106431:	e9 22 f2 ff ff       	jmp    80105658 <alltraps>

80106436 <vector208>:
.globl vector208
vector208:
  pushl $0
80106436:	6a 00                	push   $0x0
  pushl $208
80106438:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010643d:	e9 16 f2 ff ff       	jmp    80105658 <alltraps>

80106442 <vector209>:
.globl vector209
vector209:
  pushl $0
80106442:	6a 00                	push   $0x0
  pushl $209
80106444:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106449:	e9 0a f2 ff ff       	jmp    80105658 <alltraps>

8010644e <vector210>:
.globl vector210
vector210:
  pushl $0
8010644e:	6a 00                	push   $0x0
  pushl $210
80106450:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106455:	e9 fe f1 ff ff       	jmp    80105658 <alltraps>

8010645a <vector211>:
.globl vector211
vector211:
  pushl $0
8010645a:	6a 00                	push   $0x0
  pushl $211
8010645c:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106461:	e9 f2 f1 ff ff       	jmp    80105658 <alltraps>

80106466 <vector212>:
.globl vector212
vector212:
  pushl $0
80106466:	6a 00                	push   $0x0
  pushl $212
80106468:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010646d:	e9 e6 f1 ff ff       	jmp    80105658 <alltraps>

80106472 <vector213>:
.globl vector213
vector213:
  pushl $0
80106472:	6a 00                	push   $0x0
  pushl $213
80106474:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106479:	e9 da f1 ff ff       	jmp    80105658 <alltraps>

8010647e <vector214>:
.globl vector214
vector214:
  pushl $0
8010647e:	6a 00                	push   $0x0
  pushl $214
80106480:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106485:	e9 ce f1 ff ff       	jmp    80105658 <alltraps>

8010648a <vector215>:
.globl vector215
vector215:
  pushl $0
8010648a:	6a 00                	push   $0x0
  pushl $215
8010648c:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106491:	e9 c2 f1 ff ff       	jmp    80105658 <alltraps>

80106496 <vector216>:
.globl vector216
vector216:
  pushl $0
80106496:	6a 00                	push   $0x0
  pushl $216
80106498:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010649d:	e9 b6 f1 ff ff       	jmp    80105658 <alltraps>

801064a2 <vector217>:
.globl vector217
vector217:
  pushl $0
801064a2:	6a 00                	push   $0x0
  pushl $217
801064a4:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801064a9:	e9 aa f1 ff ff       	jmp    80105658 <alltraps>

801064ae <vector218>:
.globl vector218
vector218:
  pushl $0
801064ae:	6a 00                	push   $0x0
  pushl $218
801064b0:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801064b5:	e9 9e f1 ff ff       	jmp    80105658 <alltraps>

801064ba <vector219>:
.globl vector219
vector219:
  pushl $0
801064ba:	6a 00                	push   $0x0
  pushl $219
801064bc:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801064c1:	e9 92 f1 ff ff       	jmp    80105658 <alltraps>

801064c6 <vector220>:
.globl vector220
vector220:
  pushl $0
801064c6:	6a 00                	push   $0x0
  pushl $220
801064c8:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801064cd:	e9 86 f1 ff ff       	jmp    80105658 <alltraps>

801064d2 <vector221>:
.globl vector221
vector221:
  pushl $0
801064d2:	6a 00                	push   $0x0
  pushl $221
801064d4:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801064d9:	e9 7a f1 ff ff       	jmp    80105658 <alltraps>

801064de <vector222>:
.globl vector222
vector222:
  pushl $0
801064de:	6a 00                	push   $0x0
  pushl $222
801064e0:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801064e5:	e9 6e f1 ff ff       	jmp    80105658 <alltraps>

801064ea <vector223>:
.globl vector223
vector223:
  pushl $0
801064ea:	6a 00                	push   $0x0
  pushl $223
801064ec:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801064f1:	e9 62 f1 ff ff       	jmp    80105658 <alltraps>

801064f6 <vector224>:
.globl vector224
vector224:
  pushl $0
801064f6:	6a 00                	push   $0x0
  pushl $224
801064f8:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801064fd:	e9 56 f1 ff ff       	jmp    80105658 <alltraps>

80106502 <vector225>:
.globl vector225
vector225:
  pushl $0
80106502:	6a 00                	push   $0x0
  pushl $225
80106504:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106509:	e9 4a f1 ff ff       	jmp    80105658 <alltraps>

8010650e <vector226>:
.globl vector226
vector226:
  pushl $0
8010650e:	6a 00                	push   $0x0
  pushl $226
80106510:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106515:	e9 3e f1 ff ff       	jmp    80105658 <alltraps>

8010651a <vector227>:
.globl vector227
vector227:
  pushl $0
8010651a:	6a 00                	push   $0x0
  pushl $227
8010651c:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106521:	e9 32 f1 ff ff       	jmp    80105658 <alltraps>

80106526 <vector228>:
.globl vector228
vector228:
  pushl $0
80106526:	6a 00                	push   $0x0
  pushl $228
80106528:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010652d:	e9 26 f1 ff ff       	jmp    80105658 <alltraps>

80106532 <vector229>:
.globl vector229
vector229:
  pushl $0
80106532:	6a 00                	push   $0x0
  pushl $229
80106534:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106539:	e9 1a f1 ff ff       	jmp    80105658 <alltraps>

8010653e <vector230>:
.globl vector230
vector230:
  pushl $0
8010653e:	6a 00                	push   $0x0
  pushl $230
80106540:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106545:	e9 0e f1 ff ff       	jmp    80105658 <alltraps>

8010654a <vector231>:
.globl vector231
vector231:
  pushl $0
8010654a:	6a 00                	push   $0x0
  pushl $231
8010654c:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106551:	e9 02 f1 ff ff       	jmp    80105658 <alltraps>

80106556 <vector232>:
.globl vector232
vector232:
  pushl $0
80106556:	6a 00                	push   $0x0
  pushl $232
80106558:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010655d:	e9 f6 f0 ff ff       	jmp    80105658 <alltraps>

80106562 <vector233>:
.globl vector233
vector233:
  pushl $0
80106562:	6a 00                	push   $0x0
  pushl $233
80106564:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106569:	e9 ea f0 ff ff       	jmp    80105658 <alltraps>

8010656e <vector234>:
.globl vector234
vector234:
  pushl $0
8010656e:	6a 00                	push   $0x0
  pushl $234
80106570:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106575:	e9 de f0 ff ff       	jmp    80105658 <alltraps>

8010657a <vector235>:
.globl vector235
vector235:
  pushl $0
8010657a:	6a 00                	push   $0x0
  pushl $235
8010657c:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106581:	e9 d2 f0 ff ff       	jmp    80105658 <alltraps>

80106586 <vector236>:
.globl vector236
vector236:
  pushl $0
80106586:	6a 00                	push   $0x0
  pushl $236
80106588:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010658d:	e9 c6 f0 ff ff       	jmp    80105658 <alltraps>

80106592 <vector237>:
.globl vector237
vector237:
  pushl $0
80106592:	6a 00                	push   $0x0
  pushl $237
80106594:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106599:	e9 ba f0 ff ff       	jmp    80105658 <alltraps>

8010659e <vector238>:
.globl vector238
vector238:
  pushl $0
8010659e:	6a 00                	push   $0x0
  pushl $238
801065a0:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801065a5:	e9 ae f0 ff ff       	jmp    80105658 <alltraps>

801065aa <vector239>:
.globl vector239
vector239:
  pushl $0
801065aa:	6a 00                	push   $0x0
  pushl $239
801065ac:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801065b1:	e9 a2 f0 ff ff       	jmp    80105658 <alltraps>

801065b6 <vector240>:
.globl vector240
vector240:
  pushl $0
801065b6:	6a 00                	push   $0x0
  pushl $240
801065b8:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801065bd:	e9 96 f0 ff ff       	jmp    80105658 <alltraps>

801065c2 <vector241>:
.globl vector241
vector241:
  pushl $0
801065c2:	6a 00                	push   $0x0
  pushl $241
801065c4:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801065c9:	e9 8a f0 ff ff       	jmp    80105658 <alltraps>

801065ce <vector242>:
.globl vector242
vector242:
  pushl $0
801065ce:	6a 00                	push   $0x0
  pushl $242
801065d0:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801065d5:	e9 7e f0 ff ff       	jmp    80105658 <alltraps>

801065da <vector243>:
.globl vector243
vector243:
  pushl $0
801065da:	6a 00                	push   $0x0
  pushl $243
801065dc:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801065e1:	e9 72 f0 ff ff       	jmp    80105658 <alltraps>

801065e6 <vector244>:
.globl vector244
vector244:
  pushl $0
801065e6:	6a 00                	push   $0x0
  pushl $244
801065e8:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801065ed:	e9 66 f0 ff ff       	jmp    80105658 <alltraps>

801065f2 <vector245>:
.globl vector245
vector245:
  pushl $0
801065f2:	6a 00                	push   $0x0
  pushl $245
801065f4:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801065f9:	e9 5a f0 ff ff       	jmp    80105658 <alltraps>

801065fe <vector246>:
.globl vector246
vector246:
  pushl $0
801065fe:	6a 00                	push   $0x0
  pushl $246
80106600:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106605:	e9 4e f0 ff ff       	jmp    80105658 <alltraps>

8010660a <vector247>:
.globl vector247
vector247:
  pushl $0
8010660a:	6a 00                	push   $0x0
  pushl $247
8010660c:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106611:	e9 42 f0 ff ff       	jmp    80105658 <alltraps>

80106616 <vector248>:
.globl vector248
vector248:
  pushl $0
80106616:	6a 00                	push   $0x0
  pushl $248
80106618:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010661d:	e9 36 f0 ff ff       	jmp    80105658 <alltraps>

80106622 <vector249>:
.globl vector249
vector249:
  pushl $0
80106622:	6a 00                	push   $0x0
  pushl $249
80106624:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106629:	e9 2a f0 ff ff       	jmp    80105658 <alltraps>

8010662e <vector250>:
.globl vector250
vector250:
  pushl $0
8010662e:	6a 00                	push   $0x0
  pushl $250
80106630:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106635:	e9 1e f0 ff ff       	jmp    80105658 <alltraps>

8010663a <vector251>:
.globl vector251
vector251:
  pushl $0
8010663a:	6a 00                	push   $0x0
  pushl $251
8010663c:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106641:	e9 12 f0 ff ff       	jmp    80105658 <alltraps>

80106646 <vector252>:
.globl vector252
vector252:
  pushl $0
80106646:	6a 00                	push   $0x0
  pushl $252
80106648:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010664d:	e9 06 f0 ff ff       	jmp    80105658 <alltraps>

80106652 <vector253>:
.globl vector253
vector253:
  pushl $0
80106652:	6a 00                	push   $0x0
  pushl $253
80106654:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106659:	e9 fa ef ff ff       	jmp    80105658 <alltraps>

8010665e <vector254>:
.globl vector254
vector254:
  pushl $0
8010665e:	6a 00                	push   $0x0
  pushl $254
80106660:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106665:	e9 ee ef ff ff       	jmp    80105658 <alltraps>

8010666a <vector255>:
.globl vector255
vector255:
  pushl $0
8010666a:	6a 00                	push   $0x0
  pushl $255
8010666c:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106671:	e9 e2 ef ff ff       	jmp    80105658 <alltraps>
	...

80106680 <walkpgdir>:
80106680:	55                   	push   %ebp
80106681:	89 e5                	mov    %esp,%ebp
80106683:	57                   	push   %edi
80106684:	56                   	push   %esi
80106685:	89 d6                	mov    %edx,%esi
80106687:	c1 ea 16             	shr    $0x16,%edx
8010668a:	53                   	push   %ebx
8010668b:	8d 3c 90             	lea    (%eax,%edx,4),%edi
8010668e:	83 ec 1c             	sub    $0x1c,%esp
80106691:	8b 1f                	mov    (%edi),%ebx
80106693:	f6 c3 01             	test   $0x1,%bl
80106696:	74 28                	je     801066c0 <walkpgdir+0x40>
80106698:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
8010669e:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
801066a4:	c1 ee 0a             	shr    $0xa,%esi
801066a7:	83 c4 1c             	add    $0x1c,%esp
801066aa:	89 f2                	mov    %esi,%edx
801066ac:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801066b2:	8d 04 13             	lea    (%ebx,%edx,1),%eax
801066b5:	5b                   	pop    %ebx
801066b6:	5e                   	pop    %esi
801066b7:	5f                   	pop    %edi
801066b8:	5d                   	pop    %ebp
801066b9:	c3                   	ret    
801066ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801066c0:	85 c9                	test   %ecx,%ecx
801066c2:	74 34                	je     801066f8 <walkpgdir+0x78>
801066c4:	e8 e7 be ff ff       	call   801025b0 <kalloc>
801066c9:	85 c0                	test   %eax,%eax
801066cb:	89 c3                	mov    %eax,%ebx
801066cd:	74 29                	je     801066f8 <walkpgdir+0x78>
801066cf:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801066d6:	00 
801066d7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801066de:	00 
801066df:	89 04 24             	mov    %eax,(%esp)
801066e2:	e8 29 dd ff ff       	call   80104410 <memset>
801066e7:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801066ed:	83 c8 07             	or     $0x7,%eax
801066f0:	89 07                	mov    %eax,(%edi)
801066f2:	eb b0                	jmp    801066a4 <walkpgdir+0x24>
801066f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801066f8:	83 c4 1c             	add    $0x1c,%esp
801066fb:	31 c0                	xor    %eax,%eax
801066fd:	5b                   	pop    %ebx
801066fe:	5e                   	pop    %esi
801066ff:	5f                   	pop    %edi
80106700:	5d                   	pop    %ebp
80106701:	c3                   	ret    
80106702:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106709:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106710 <deallocuvm.part.0>:
80106710:	55                   	push   %ebp
80106711:	89 e5                	mov    %esp,%ebp
80106713:	57                   	push   %edi
80106714:	89 c7                	mov    %eax,%edi
80106716:	56                   	push   %esi
80106717:	89 d6                	mov    %edx,%esi
80106719:	53                   	push   %ebx
8010671a:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
80106720:	83 ec 1c             	sub    $0x1c,%esp
80106723:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80106729:	39 d3                	cmp    %edx,%ebx
8010672b:	89 4d e0             	mov    %ecx,-0x20(%ebp)
8010672e:	72 3b                	jb     8010676b <deallocuvm.part.0+0x5b>
80106730:	eb 5e                	jmp    80106790 <deallocuvm.part.0+0x80>
80106732:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106738:	8b 10                	mov    (%eax),%edx
8010673a:	f6 c2 01             	test   $0x1,%dl
8010673d:	74 22                	je     80106761 <deallocuvm.part.0+0x51>
8010673f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106745:	74 54                	je     8010679b <deallocuvm.part.0+0x8b>
80106747:	81 c2 00 00 00 80    	add    $0x80000000,%edx
8010674d:	89 14 24             	mov    %edx,(%esp)
80106750:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106753:	e8 a8 bc ff ff       	call   80102400 <kfree>
80106758:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010675b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80106761:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106767:	39 f3                	cmp    %esi,%ebx
80106769:	73 25                	jae    80106790 <deallocuvm.part.0+0x80>
8010676b:	31 c9                	xor    %ecx,%ecx
8010676d:	89 da                	mov    %ebx,%edx
8010676f:	89 f8                	mov    %edi,%eax
80106771:	e8 0a ff ff ff       	call   80106680 <walkpgdir>
80106776:	85 c0                	test   %eax,%eax
80106778:	75 be                	jne    80106738 <deallocuvm.part.0+0x28>
8010677a:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80106780:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
80106786:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010678c:	39 f3                	cmp    %esi,%ebx
8010678e:	72 db                	jb     8010676b <deallocuvm.part.0+0x5b>
80106790:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106793:	83 c4 1c             	add    $0x1c,%esp
80106796:	5b                   	pop    %ebx
80106797:	5e                   	pop    %esi
80106798:	5f                   	pop    %edi
80106799:	5d                   	pop    %ebp
8010679a:	c3                   	ret    
8010679b:	c7 04 24 26 72 10 80 	movl   $0x80107226,(%esp)
801067a2:	e8 b9 9b ff ff       	call   80100360 <panic>
801067a7:	89 f6                	mov    %esi,%esi
801067a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801067b0 <seginit>:
801067b0:	55                   	push   %ebp
801067b1:	89 e5                	mov    %esp,%ebp
801067b3:	83 ec 18             	sub    $0x18,%esp
801067b6:	e8 25 d0 ff ff       	call   801037e0 <cpuid>
801067bb:	31 c9                	xor    %ecx,%ecx
801067bd:	ba ff ff ff ff       	mov    $0xffffffff,%edx
801067c2:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
801067c8:	05 c0 26 11 80       	add    $0x801126c0,%eax
801067cd:	66 89 50 78          	mov    %dx,0x78(%eax)
801067d1:	ba ff ff ff ff       	mov    $0xffffffff,%edx
801067d6:	83 c0 70             	add    $0x70,%eax
801067d9:	66 89 48 0a          	mov    %cx,0xa(%eax)
801067dd:	31 c9                	xor    %ecx,%ecx
801067df:	66 89 50 10          	mov    %dx,0x10(%eax)
801067e3:	ba ff ff ff ff       	mov    $0xffffffff,%edx
801067e8:	66 89 48 12          	mov    %cx,0x12(%eax)
801067ec:	31 c9                	xor    %ecx,%ecx
801067ee:	66 89 50 18          	mov    %dx,0x18(%eax)
801067f2:	ba ff ff ff ff       	mov    $0xffffffff,%edx
801067f7:	66 89 48 1a          	mov    %cx,0x1a(%eax)
801067fb:	31 c9                	xor    %ecx,%ecx
801067fd:	c6 40 0d 9a          	movb   $0x9a,0xd(%eax)
80106801:	c6 40 0e cf          	movb   $0xcf,0xe(%eax)
80106805:	c6 40 15 92          	movb   $0x92,0x15(%eax)
80106809:	c6 40 16 cf          	movb   $0xcf,0x16(%eax)
8010680d:	c6 40 1d fa          	movb   $0xfa,0x1d(%eax)
80106811:	c6 40 1e cf          	movb   $0xcf,0x1e(%eax)
80106815:	c6 40 25 f2          	movb   $0xf2,0x25(%eax)
80106819:	c6 40 26 cf          	movb   $0xcf,0x26(%eax)
8010681d:	66 89 50 20          	mov    %dx,0x20(%eax)
80106821:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106826:	c6 40 0c 00          	movb   $0x0,0xc(%eax)
8010682a:	c6 40 0f 00          	movb   $0x0,0xf(%eax)
8010682e:	c6 40 14 00          	movb   $0x0,0x14(%eax)
80106832:	c6 40 17 00          	movb   $0x0,0x17(%eax)
80106836:	c6 40 1c 00          	movb   $0x0,0x1c(%eax)
8010683a:	c6 40 1f 00          	movb   $0x0,0x1f(%eax)
8010683e:	66 89 48 22          	mov    %cx,0x22(%eax)
80106842:	c6 40 24 00          	movb   $0x0,0x24(%eax)
80106846:	c6 40 27 00          	movb   $0x0,0x27(%eax)
8010684a:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
8010684e:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
80106852:	c1 e8 10             	shr    $0x10,%eax
80106855:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
80106859:	8d 45 f2             	lea    -0xe(%ebp),%eax
8010685c:	0f 01 10             	lgdtl  (%eax)
8010685f:	c9                   	leave  
80106860:	c3                   	ret    
80106861:	eb 0d                	jmp    80106870 <mappages>
80106863:	90                   	nop
80106864:	90                   	nop
80106865:	90                   	nop
80106866:	90                   	nop
80106867:	90                   	nop
80106868:	90                   	nop
80106869:	90                   	nop
8010686a:	90                   	nop
8010686b:	90                   	nop
8010686c:	90                   	nop
8010686d:	90                   	nop
8010686e:	90                   	nop
8010686f:	90                   	nop

80106870 <mappages>:
80106870:	55                   	push   %ebp
80106871:	89 e5                	mov    %esp,%ebp
80106873:	57                   	push   %edi
80106874:	56                   	push   %esi
80106875:	53                   	push   %ebx
80106876:	83 ec 1c             	sub    $0x1c,%esp
80106879:	8b 45 0c             	mov    0xc(%ebp),%eax
8010687c:	8b 55 10             	mov    0x10(%ebp),%edx
8010687f:	8b 7d 14             	mov    0x14(%ebp),%edi
80106882:	83 4d 18 01          	orl    $0x1,0x18(%ebp)
80106886:	89 c3                	mov    %eax,%ebx
80106888:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
8010688e:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
80106892:	29 df                	sub    %ebx,%edi
80106894:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106897:	81 65 e4 00 f0 ff ff 	andl   $0xfffff000,-0x1c(%ebp)
8010689e:	eb 15                	jmp    801068b5 <mappages+0x45>
801068a0:	f6 00 01             	testb  $0x1,(%eax)
801068a3:	75 3d                	jne    801068e2 <mappages+0x72>
801068a5:	0b 75 18             	or     0x18(%ebp),%esi
801068a8:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
801068ab:	89 30                	mov    %esi,(%eax)
801068ad:	74 29                	je     801068d8 <mappages+0x68>
801068af:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801068b5:	8b 45 08             	mov    0x8(%ebp),%eax
801068b8:	b9 01 00 00 00       	mov    $0x1,%ecx
801068bd:	89 da                	mov    %ebx,%edx
801068bf:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
801068c2:	e8 b9 fd ff ff       	call   80106680 <walkpgdir>
801068c7:	85 c0                	test   %eax,%eax
801068c9:	75 d5                	jne    801068a0 <mappages+0x30>
801068cb:	83 c4 1c             	add    $0x1c,%esp
801068ce:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801068d3:	5b                   	pop    %ebx
801068d4:	5e                   	pop    %esi
801068d5:	5f                   	pop    %edi
801068d6:	5d                   	pop    %ebp
801068d7:	c3                   	ret    
801068d8:	83 c4 1c             	add    $0x1c,%esp
801068db:	31 c0                	xor    %eax,%eax
801068dd:	5b                   	pop    %ebx
801068de:	5e                   	pop    %esi
801068df:	5f                   	pop    %edi
801068e0:	5d                   	pop    %ebp
801068e1:	c3                   	ret    
801068e2:	c7 04 24 08 79 10 80 	movl   $0x80107908,(%esp)
801068e9:	e8 72 9a ff ff       	call   80100360 <panic>
801068ee:	66 90                	xchg   %ax,%ax

801068f0 <switchkvm>:
801068f0:	a1 e4 56 11 80       	mov    0x801156e4,%eax
801068f5:	55                   	push   %ebp
801068f6:	89 e5                	mov    %esp,%ebp
801068f8:	05 00 00 00 80       	add    $0x80000000,%eax
801068fd:	0f 22 d8             	mov    %eax,%cr3
80106900:	5d                   	pop    %ebp
80106901:	c3                   	ret    
80106902:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106909:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106910 <switchuvm>:
80106910:	55                   	push   %ebp
80106911:	89 e5                	mov    %esp,%ebp
80106913:	57                   	push   %edi
80106914:	56                   	push   %esi
80106915:	53                   	push   %ebx
80106916:	83 ec 1c             	sub    $0x1c,%esp
80106919:	8b 75 08             	mov    0x8(%ebp),%esi
8010691c:	85 f6                	test   %esi,%esi
8010691e:	0f 84 cd 00 00 00    	je     801069f1 <switchuvm+0xe1>
80106924:	8b 46 08             	mov    0x8(%esi),%eax
80106927:	85 c0                	test   %eax,%eax
80106929:	0f 84 da 00 00 00    	je     80106a09 <switchuvm+0xf9>
8010692f:	8b 46 04             	mov    0x4(%esi),%eax
80106932:	85 c0                	test   %eax,%eax
80106934:	0f 84 c3 00 00 00    	je     801069fd <switchuvm+0xed>
8010693a:	e8 51 d9 ff ff       	call   80104290 <pushcli>
8010693f:	e8 1c ce ff ff       	call   80103760 <mycpu>
80106944:	89 c3                	mov    %eax,%ebx
80106946:	e8 15 ce ff ff       	call   80103760 <mycpu>
8010694b:	89 c7                	mov    %eax,%edi
8010694d:	e8 0e ce ff ff       	call   80103760 <mycpu>
80106952:	83 c7 08             	add    $0x8,%edi
80106955:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106958:	e8 03 ce ff ff       	call   80103760 <mycpu>
8010695d:	b9 67 00 00 00       	mov    $0x67,%ecx
80106962:	66 89 8b 98 00 00 00 	mov    %cx,0x98(%ebx)
80106969:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010696c:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106973:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80106978:	c6 83 9d 00 00 00 99 	movb   $0x99,0x9d(%ebx)
8010697f:	c6 83 9e 00 00 00 40 	movb   $0x40,0x9e(%ebx)
80106986:	83 c1 08             	add    $0x8,%ecx
80106989:	83 c0 08             	add    $0x8,%eax
8010698c:	c1 e9 10             	shr    $0x10,%ecx
8010698f:	c1 e8 18             	shr    $0x18,%eax
80106992:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106998:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
8010699e:	bb 10 00 00 00       	mov    $0x10,%ebx
801069a3:	e8 b8 cd ff ff       	call   80103760 <mycpu>
801069a8:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
801069af:	e8 ac cd ff ff       	call   80103760 <mycpu>
801069b4:	66 89 58 10          	mov    %bx,0x10(%eax)
801069b8:	e8 a3 cd ff ff       	call   80103760 <mycpu>
801069bd:	8b 56 08             	mov    0x8(%esi),%edx
801069c0:	8d 8a 00 10 00 00    	lea    0x1000(%edx),%ecx
801069c6:	89 48 0c             	mov    %ecx,0xc(%eax)
801069c9:	e8 92 cd ff ff       	call   80103760 <mycpu>
801069ce:	66 89 78 6e          	mov    %di,0x6e(%eax)
801069d2:	b8 28 00 00 00       	mov    $0x28,%eax
801069d7:	0f 00 d8             	ltr    %ax
801069da:	8b 46 04             	mov    0x4(%esi),%eax
801069dd:	05 00 00 00 80       	add    $0x80000000,%eax
801069e2:	0f 22 d8             	mov    %eax,%cr3
801069e5:	83 c4 1c             	add    $0x1c,%esp
801069e8:	5b                   	pop    %ebx
801069e9:	5e                   	pop    %esi
801069ea:	5f                   	pop    %edi
801069eb:	5d                   	pop    %ebp
801069ec:	e9 5f d9 ff ff       	jmp    80104350 <popcli>
801069f1:	c7 04 24 0e 79 10 80 	movl   $0x8010790e,(%esp)
801069f8:	e8 63 99 ff ff       	call   80100360 <panic>
801069fd:	c7 04 24 39 79 10 80 	movl   $0x80107939,(%esp)
80106a04:	e8 57 99 ff ff       	call   80100360 <panic>
80106a09:	c7 04 24 24 79 10 80 	movl   $0x80107924,(%esp)
80106a10:	e8 4b 99 ff ff       	call   80100360 <panic>
80106a15:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106a19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106a20 <inituvm>:
80106a20:	55                   	push   %ebp
80106a21:	89 e5                	mov    %esp,%ebp
80106a23:	57                   	push   %edi
80106a24:	56                   	push   %esi
80106a25:	53                   	push   %ebx
80106a26:	83 ec 2c             	sub    $0x2c,%esp
80106a29:	8b 75 10             	mov    0x10(%ebp),%esi
80106a2c:	8b 55 08             	mov    0x8(%ebp),%edx
80106a2f:	8b 7d 0c             	mov    0xc(%ebp),%edi
80106a32:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106a38:	77 64                	ja     80106a9e <inituvm+0x7e>
80106a3a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80106a3d:	e8 6e bb ff ff       	call   801025b0 <kalloc>
80106a42:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106a49:	00 
80106a4a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106a51:	00 
80106a52:	89 04 24             	mov    %eax,(%esp)
80106a55:	89 c3                	mov    %eax,%ebx
80106a57:	e8 b4 d9 ff ff       	call   80104410 <memset>
80106a5c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106a5f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106a65:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
80106a6c:	00 
80106a6d:	89 44 24 0c          	mov    %eax,0xc(%esp)
80106a71:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106a78:	00 
80106a79:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106a80:	00 
80106a81:	89 14 24             	mov    %edx,(%esp)
80106a84:	e8 e7 fd ff ff       	call   80106870 <mappages>
80106a89:	89 75 10             	mov    %esi,0x10(%ebp)
80106a8c:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106a8f:	89 5d 08             	mov    %ebx,0x8(%ebp)
80106a92:	83 c4 2c             	add    $0x2c,%esp
80106a95:	5b                   	pop    %ebx
80106a96:	5e                   	pop    %esi
80106a97:	5f                   	pop    %edi
80106a98:	5d                   	pop    %ebp
80106a99:	e9 12 da ff ff       	jmp    801044b0 <memmove>
80106a9e:	c7 04 24 4d 79 10 80 	movl   $0x8010794d,(%esp)
80106aa5:	e8 b6 98 ff ff       	call   80100360 <panic>
80106aaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106ab0 <loaduvm>:
80106ab0:	55                   	push   %ebp
80106ab1:	89 e5                	mov    %esp,%ebp
80106ab3:	57                   	push   %edi
80106ab4:	56                   	push   %esi
80106ab5:	53                   	push   %ebx
80106ab6:	83 ec 1c             	sub    $0x1c,%esp
80106ab9:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80106ac0:	0f 85 98 00 00 00    	jne    80106b5e <loaduvm+0xae>
80106ac6:	8b 75 18             	mov    0x18(%ebp),%esi
80106ac9:	31 db                	xor    %ebx,%ebx
80106acb:	85 f6                	test   %esi,%esi
80106acd:	75 1a                	jne    80106ae9 <loaduvm+0x39>
80106acf:	eb 77                	jmp    80106b48 <loaduvm+0x98>
80106ad1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ad8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106ade:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80106ae4:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80106ae7:	76 5f                	jbe    80106b48 <loaduvm+0x98>
80106ae9:	8b 55 0c             	mov    0xc(%ebp),%edx
80106aec:	31 c9                	xor    %ecx,%ecx
80106aee:	8b 45 08             	mov    0x8(%ebp),%eax
80106af1:	01 da                	add    %ebx,%edx
80106af3:	e8 88 fb ff ff       	call   80106680 <walkpgdir>
80106af8:	85 c0                	test   %eax,%eax
80106afa:	74 56                	je     80106b52 <loaduvm+0xa2>
80106afc:	8b 00                	mov    (%eax),%eax
80106afe:	bf 00 10 00 00       	mov    $0x1000,%edi
80106b03:	8b 4d 14             	mov    0x14(%ebp),%ecx
80106b06:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106b0b:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
80106b11:	0f 42 fe             	cmovb  %esi,%edi
80106b14:	05 00 00 00 80       	add    $0x80000000,%eax
80106b19:	89 44 24 04          	mov    %eax,0x4(%esp)
80106b1d:	8b 45 10             	mov    0x10(%ebp),%eax
80106b20:	01 d9                	add    %ebx,%ecx
80106b22:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80106b26:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80106b2a:	89 04 24             	mov    %eax,(%esp)
80106b2d:	e8 3e af ff ff       	call   80101a70 <readi>
80106b32:	39 f8                	cmp    %edi,%eax
80106b34:	74 a2                	je     80106ad8 <loaduvm+0x28>
80106b36:	83 c4 1c             	add    $0x1c,%esp
80106b39:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b3e:	5b                   	pop    %ebx
80106b3f:	5e                   	pop    %esi
80106b40:	5f                   	pop    %edi
80106b41:	5d                   	pop    %ebp
80106b42:	c3                   	ret    
80106b43:	90                   	nop
80106b44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106b48:	83 c4 1c             	add    $0x1c,%esp
80106b4b:	31 c0                	xor    %eax,%eax
80106b4d:	5b                   	pop    %ebx
80106b4e:	5e                   	pop    %esi
80106b4f:	5f                   	pop    %edi
80106b50:	5d                   	pop    %ebp
80106b51:	c3                   	ret    
80106b52:	c7 04 24 67 79 10 80 	movl   $0x80107967,(%esp)
80106b59:	e8 02 98 ff ff       	call   80100360 <panic>
80106b5e:	c7 04 24 08 7a 10 80 	movl   $0x80107a08,(%esp)
80106b65:	e8 f6 97 ff ff       	call   80100360 <panic>
80106b6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106b70 <allocuvm>:
80106b70:	55                   	push   %ebp
80106b71:	89 e5                	mov    %esp,%ebp
80106b73:	57                   	push   %edi
80106b74:	56                   	push   %esi
80106b75:	53                   	push   %ebx
80106b76:	83 ec 2c             	sub    $0x2c,%esp
80106b79:	8b 7d 10             	mov    0x10(%ebp),%edi
80106b7c:	85 ff                	test   %edi,%edi
80106b7e:	0f 88 8f 00 00 00    	js     80106c13 <allocuvm+0xa3>
80106b84:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106b87:	8b 45 0c             	mov    0xc(%ebp),%eax
80106b8a:	0f 82 85 00 00 00    	jb     80106c15 <allocuvm+0xa5>
80106b90:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106b96:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80106b9c:	39 df                	cmp    %ebx,%edi
80106b9e:	77 57                	ja     80106bf7 <allocuvm+0x87>
80106ba0:	eb 7e                	jmp    80106c20 <allocuvm+0xb0>
80106ba2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106ba8:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106baf:	00 
80106bb0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106bb7:	00 
80106bb8:	89 04 24             	mov    %eax,(%esp)
80106bbb:	e8 50 d8 ff ff       	call   80104410 <memset>
80106bc0:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106bc6:	89 44 24 0c          	mov    %eax,0xc(%esp)
80106bca:	8b 45 08             	mov    0x8(%ebp),%eax
80106bcd:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
80106bd4:	00 
80106bd5:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106bdc:	00 
80106bdd:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80106be1:	89 04 24             	mov    %eax,(%esp)
80106be4:	e8 87 fc ff ff       	call   80106870 <mappages>
80106be9:	85 c0                	test   %eax,%eax
80106beb:	78 43                	js     80106c30 <allocuvm+0xc0>
80106bed:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106bf3:	39 df                	cmp    %ebx,%edi
80106bf5:	76 29                	jbe    80106c20 <allocuvm+0xb0>
80106bf7:	e8 b4 b9 ff ff       	call   801025b0 <kalloc>
80106bfc:	85 c0                	test   %eax,%eax
80106bfe:	89 c6                	mov    %eax,%esi
80106c00:	75 a6                	jne    80106ba8 <allocuvm+0x38>
80106c02:	c7 04 24 85 79 10 80 	movl   $0x80107985,(%esp)
80106c09:	e8 42 9a ff ff       	call   80100650 <cprintf>
80106c0e:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106c11:	77 47                	ja     80106c5a <allocuvm+0xea>
80106c13:	31 c0                	xor    %eax,%eax
80106c15:	83 c4 2c             	add    $0x2c,%esp
80106c18:	5b                   	pop    %ebx
80106c19:	5e                   	pop    %esi
80106c1a:	5f                   	pop    %edi
80106c1b:	5d                   	pop    %ebp
80106c1c:	c3                   	ret    
80106c1d:	8d 76 00             	lea    0x0(%esi),%esi
80106c20:	83 c4 2c             	add    $0x2c,%esp
80106c23:	89 f8                	mov    %edi,%eax
80106c25:	5b                   	pop    %ebx
80106c26:	5e                   	pop    %esi
80106c27:	5f                   	pop    %edi
80106c28:	5d                   	pop    %ebp
80106c29:	c3                   	ret    
80106c2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106c30:	c7 04 24 9d 79 10 80 	movl   $0x8010799d,(%esp)
80106c37:	e8 14 9a ff ff       	call   80100650 <cprintf>
80106c3c:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106c3f:	76 0d                	jbe    80106c4e <allocuvm+0xde>
80106c41:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106c44:	89 fa                	mov    %edi,%edx
80106c46:	8b 45 08             	mov    0x8(%ebp),%eax
80106c49:	e8 c2 fa ff ff       	call   80106710 <deallocuvm.part.0>
80106c4e:	89 34 24             	mov    %esi,(%esp)
80106c51:	e8 aa b7 ff ff       	call   80102400 <kfree>
80106c56:	31 c0                	xor    %eax,%eax
80106c58:	eb bb                	jmp    80106c15 <allocuvm+0xa5>
80106c5a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106c5d:	89 fa                	mov    %edi,%edx
80106c5f:	8b 45 08             	mov    0x8(%ebp),%eax
80106c62:	e8 a9 fa ff ff       	call   80106710 <deallocuvm.part.0>
80106c67:	31 c0                	xor    %eax,%eax
80106c69:	eb aa                	jmp    80106c15 <allocuvm+0xa5>
80106c6b:	90                   	nop
80106c6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106c70 <deallocuvm>:
80106c70:	55                   	push   %ebp
80106c71:	89 e5                	mov    %esp,%ebp
80106c73:	8b 55 0c             	mov    0xc(%ebp),%edx
80106c76:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106c79:	8b 45 08             	mov    0x8(%ebp),%eax
80106c7c:	39 d1                	cmp    %edx,%ecx
80106c7e:	73 08                	jae    80106c88 <deallocuvm+0x18>
80106c80:	5d                   	pop    %ebp
80106c81:	e9 8a fa ff ff       	jmp    80106710 <deallocuvm.part.0>
80106c86:	66 90                	xchg   %ax,%ax
80106c88:	89 d0                	mov    %edx,%eax
80106c8a:	5d                   	pop    %ebp
80106c8b:	c3                   	ret    
80106c8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106c90 <freevm>:
80106c90:	55                   	push   %ebp
80106c91:	89 e5                	mov    %esp,%ebp
80106c93:	56                   	push   %esi
80106c94:	53                   	push   %ebx
80106c95:	83 ec 10             	sub    $0x10,%esp
80106c98:	8b 75 08             	mov    0x8(%ebp),%esi
80106c9b:	85 f6                	test   %esi,%esi
80106c9d:	74 59                	je     80106cf8 <freevm+0x68>
80106c9f:	31 c9                	xor    %ecx,%ecx
80106ca1:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106ca6:	89 f0                	mov    %esi,%eax
80106ca8:	31 db                	xor    %ebx,%ebx
80106caa:	e8 61 fa ff ff       	call   80106710 <deallocuvm.part.0>
80106caf:	eb 12                	jmp    80106cc3 <freevm+0x33>
80106cb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106cb8:	83 c3 01             	add    $0x1,%ebx
80106cbb:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
80106cc1:	74 27                	je     80106cea <freevm+0x5a>
80106cc3:	8b 14 9e             	mov    (%esi,%ebx,4),%edx
80106cc6:	f6 c2 01             	test   $0x1,%dl
80106cc9:	74 ed                	je     80106cb8 <freevm+0x28>
80106ccb:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106cd1:	83 c3 01             	add    $0x1,%ebx
80106cd4:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106cda:	89 14 24             	mov    %edx,(%esp)
80106cdd:	e8 1e b7 ff ff       	call   80102400 <kfree>
80106ce2:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
80106ce8:	75 d9                	jne    80106cc3 <freevm+0x33>
80106cea:	89 75 08             	mov    %esi,0x8(%ebp)
80106ced:	83 c4 10             	add    $0x10,%esp
80106cf0:	5b                   	pop    %ebx
80106cf1:	5e                   	pop    %esi
80106cf2:	5d                   	pop    %ebp
80106cf3:	e9 08 b7 ff ff       	jmp    80102400 <kfree>
80106cf8:	c7 04 24 b9 79 10 80 	movl   $0x801079b9,(%esp)
80106cff:	e8 5c 96 ff ff       	call   80100360 <panic>
80106d04:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106d0a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106d10 <setupkvm>:
80106d10:	55                   	push   %ebp
80106d11:	89 e5                	mov    %esp,%ebp
80106d13:	56                   	push   %esi
80106d14:	53                   	push   %ebx
80106d15:	83 ec 20             	sub    $0x20,%esp
80106d18:	e8 93 b8 ff ff       	call   801025b0 <kalloc>
80106d1d:	85 c0                	test   %eax,%eax
80106d1f:	89 c6                	mov    %eax,%esi
80106d21:	74 75                	je     80106d98 <setupkvm+0x88>
80106d23:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106d2a:	00 
80106d2b:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
80106d30:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106d37:	00 
80106d38:	89 04 24             	mov    %eax,(%esp)
80106d3b:	e8 d0 d6 ff ff       	call   80104410 <memset>
80106d40:	8b 53 0c             	mov    0xc(%ebx),%edx
80106d43:	8b 43 04             	mov    0x4(%ebx),%eax
80106d46:	89 34 24             	mov    %esi,(%esp)
80106d49:	89 54 24 10          	mov    %edx,0x10(%esp)
80106d4d:	8b 53 08             	mov    0x8(%ebx),%edx
80106d50:	89 44 24 0c          	mov    %eax,0xc(%esp)
80106d54:	29 c2                	sub    %eax,%edx
80106d56:	8b 03                	mov    (%ebx),%eax
80106d58:	89 54 24 08          	mov    %edx,0x8(%esp)
80106d5c:	89 44 24 04          	mov    %eax,0x4(%esp)
80106d60:	e8 0b fb ff ff       	call   80106870 <mappages>
80106d65:	85 c0                	test   %eax,%eax
80106d67:	78 17                	js     80106d80 <setupkvm+0x70>
80106d69:	83 c3 10             	add    $0x10,%ebx
80106d6c:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106d72:	72 cc                	jb     80106d40 <setupkvm+0x30>
80106d74:	89 f0                	mov    %esi,%eax
80106d76:	83 c4 20             	add    $0x20,%esp
80106d79:	5b                   	pop    %ebx
80106d7a:	5e                   	pop    %esi
80106d7b:	5d                   	pop    %ebp
80106d7c:	c3                   	ret    
80106d7d:	8d 76 00             	lea    0x0(%esi),%esi
80106d80:	89 34 24             	mov    %esi,(%esp)
80106d83:	e8 08 ff ff ff       	call   80106c90 <freevm>
80106d88:	83 c4 20             	add    $0x20,%esp
80106d8b:	31 c0                	xor    %eax,%eax
80106d8d:	5b                   	pop    %ebx
80106d8e:	5e                   	pop    %esi
80106d8f:	5d                   	pop    %ebp
80106d90:	c3                   	ret    
80106d91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d98:	31 c0                	xor    %eax,%eax
80106d9a:	eb da                	jmp    80106d76 <setupkvm+0x66>
80106d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106da0 <kvmalloc>:
80106da0:	55                   	push   %ebp
80106da1:	89 e5                	mov    %esp,%ebp
80106da3:	83 ec 08             	sub    $0x8,%esp
80106da6:	e8 65 ff ff ff       	call   80106d10 <setupkvm>
80106dab:	a3 e4 56 11 80       	mov    %eax,0x801156e4
80106db0:	05 00 00 00 80       	add    $0x80000000,%eax
80106db5:	0f 22 d8             	mov    %eax,%cr3
80106db8:	c9                   	leave  
80106db9:	c3                   	ret    
80106dba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106dc0 <clearpteu>:
80106dc0:	55                   	push   %ebp
80106dc1:	31 c9                	xor    %ecx,%ecx
80106dc3:	89 e5                	mov    %esp,%ebp
80106dc5:	83 ec 18             	sub    $0x18,%esp
80106dc8:	8b 55 0c             	mov    0xc(%ebp),%edx
80106dcb:	8b 45 08             	mov    0x8(%ebp),%eax
80106dce:	e8 ad f8 ff ff       	call   80106680 <walkpgdir>
80106dd3:	85 c0                	test   %eax,%eax
80106dd5:	74 05                	je     80106ddc <clearpteu+0x1c>
80106dd7:	83 20 fb             	andl   $0xfffffffb,(%eax)
80106dda:	c9                   	leave  
80106ddb:	c3                   	ret    
80106ddc:	c7 04 24 ca 79 10 80 	movl   $0x801079ca,(%esp)
80106de3:	e8 78 95 ff ff       	call   80100360 <panic>
80106de8:	90                   	nop
80106de9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106df0 <copyuvm>:
80106df0:	55                   	push   %ebp
80106df1:	89 e5                	mov    %esp,%ebp
80106df3:	57                   	push   %edi
80106df4:	56                   	push   %esi
80106df5:	53                   	push   %ebx
80106df6:	83 ec 2c             	sub    $0x2c,%esp
80106df9:	e8 12 ff ff ff       	call   80106d10 <setupkvm>
80106dfe:	85 c0                	test   %eax,%eax
80106e00:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106e03:	0f 84 ba 00 00 00    	je     80106ec3 <copyuvm+0xd3>
80106e09:	8b 45 0c             	mov    0xc(%ebp),%eax
80106e0c:	85 c0                	test   %eax,%eax
80106e0e:	0f 84 a4 00 00 00    	je     80106eb8 <copyuvm+0xc8>
80106e14:	31 db                	xor    %ebx,%ebx
80106e16:	eb 51                	jmp    80106e69 <copyuvm+0x79>
80106e18:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80106e1e:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106e25:	00 
80106e26:	89 7c 24 04          	mov    %edi,0x4(%esp)
80106e2a:	89 04 24             	mov    %eax,(%esp)
80106e2d:	e8 7e d6 ff ff       	call   801044b0 <memmove>
80106e32:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106e35:	8d 96 00 00 00 80    	lea    -0x80000000(%esi),%edx
80106e3b:	89 54 24 0c          	mov    %edx,0xc(%esp)
80106e3f:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106e46:	00 
80106e47:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80106e4b:	89 44 24 10          	mov    %eax,0x10(%esp)
80106e4f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106e52:	89 04 24             	mov    %eax,(%esp)
80106e55:	e8 16 fa ff ff       	call   80106870 <mappages>
80106e5a:	85 c0                	test   %eax,%eax
80106e5c:	78 45                	js     80106ea3 <copyuvm+0xb3>
80106e5e:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106e64:	39 5d 0c             	cmp    %ebx,0xc(%ebp)
80106e67:	76 4f                	jbe    80106eb8 <copyuvm+0xc8>
80106e69:	8b 45 08             	mov    0x8(%ebp),%eax
80106e6c:	31 c9                	xor    %ecx,%ecx
80106e6e:	89 da                	mov    %ebx,%edx
80106e70:	e8 0b f8 ff ff       	call   80106680 <walkpgdir>
80106e75:	85 c0                	test   %eax,%eax
80106e77:	74 5a                	je     80106ed3 <copyuvm+0xe3>
80106e79:	8b 30                	mov    (%eax),%esi
80106e7b:	f7 c6 01 00 00 00    	test   $0x1,%esi
80106e81:	74 44                	je     80106ec7 <copyuvm+0xd7>
80106e83:	89 f7                	mov    %esi,%edi
80106e85:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
80106e8b:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80106e8e:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80106e94:	e8 17 b7 ff ff       	call   801025b0 <kalloc>
80106e99:	85 c0                	test   %eax,%eax
80106e9b:	89 c6                	mov    %eax,%esi
80106e9d:	0f 85 75 ff ff ff    	jne    80106e18 <copyuvm+0x28>
80106ea3:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106ea6:	89 04 24             	mov    %eax,(%esp)
80106ea9:	e8 e2 fd ff ff       	call   80106c90 <freevm>
80106eae:	31 c0                	xor    %eax,%eax
80106eb0:	83 c4 2c             	add    $0x2c,%esp
80106eb3:	5b                   	pop    %ebx
80106eb4:	5e                   	pop    %esi
80106eb5:	5f                   	pop    %edi
80106eb6:	5d                   	pop    %ebp
80106eb7:	c3                   	ret    
80106eb8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106ebb:	83 c4 2c             	add    $0x2c,%esp
80106ebe:	5b                   	pop    %ebx
80106ebf:	5e                   	pop    %esi
80106ec0:	5f                   	pop    %edi
80106ec1:	5d                   	pop    %ebp
80106ec2:	c3                   	ret    
80106ec3:	31 c0                	xor    %eax,%eax
80106ec5:	eb e9                	jmp    80106eb0 <copyuvm+0xc0>
80106ec7:	c7 04 24 ee 79 10 80 	movl   $0x801079ee,(%esp)
80106ece:	e8 8d 94 ff ff       	call   80100360 <panic>
80106ed3:	c7 04 24 d4 79 10 80 	movl   $0x801079d4,(%esp)
80106eda:	e8 81 94 ff ff       	call   80100360 <panic>
80106edf:	90                   	nop

80106ee0 <uva2ka>:
80106ee0:	55                   	push   %ebp
80106ee1:	31 c9                	xor    %ecx,%ecx
80106ee3:	89 e5                	mov    %esp,%ebp
80106ee5:	83 ec 08             	sub    $0x8,%esp
80106ee8:	8b 55 0c             	mov    0xc(%ebp),%edx
80106eeb:	8b 45 08             	mov    0x8(%ebp),%eax
80106eee:	e8 8d f7 ff ff       	call   80106680 <walkpgdir>
80106ef3:	8b 00                	mov    (%eax),%eax
80106ef5:	89 c2                	mov    %eax,%edx
80106ef7:	83 e2 05             	and    $0x5,%edx
80106efa:	83 fa 05             	cmp    $0x5,%edx
80106efd:	75 11                	jne    80106f10 <uva2ka+0x30>
80106eff:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106f04:	05 00 00 00 80       	add    $0x80000000,%eax
80106f09:	c9                   	leave  
80106f0a:	c3                   	ret    
80106f0b:	90                   	nop
80106f0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106f10:	31 c0                	xor    %eax,%eax
80106f12:	c9                   	leave  
80106f13:	c3                   	ret    
80106f14:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106f1a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106f20 <copyout>:
80106f20:	55                   	push   %ebp
80106f21:	89 e5                	mov    %esp,%ebp
80106f23:	57                   	push   %edi
80106f24:	56                   	push   %esi
80106f25:	53                   	push   %ebx
80106f26:	83 ec 1c             	sub    $0x1c,%esp
80106f29:	8b 5d 14             	mov    0x14(%ebp),%ebx
80106f2c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106f2f:	8b 7d 10             	mov    0x10(%ebp),%edi
80106f32:	85 db                	test   %ebx,%ebx
80106f34:	75 3a                	jne    80106f70 <copyout+0x50>
80106f36:	eb 68                	jmp    80106fa0 <copyout+0x80>
80106f38:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106f3b:	89 f2                	mov    %esi,%edx
80106f3d:	89 7c 24 04          	mov    %edi,0x4(%esp)
80106f41:	29 ca                	sub    %ecx,%edx
80106f43:	81 c2 00 10 00 00    	add    $0x1000,%edx
80106f49:	39 da                	cmp    %ebx,%edx
80106f4b:	0f 47 d3             	cmova  %ebx,%edx
80106f4e:	29 f1                	sub    %esi,%ecx
80106f50:	01 c8                	add    %ecx,%eax
80106f52:	89 54 24 08          	mov    %edx,0x8(%esp)
80106f56:	89 04 24             	mov    %eax,(%esp)
80106f59:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80106f5c:	e8 4f d5 ff ff       	call   801044b0 <memmove>
80106f61:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106f64:	8d 8e 00 10 00 00    	lea    0x1000(%esi),%ecx
80106f6a:	01 d7                	add    %edx,%edi
80106f6c:	29 d3                	sub    %edx,%ebx
80106f6e:	74 30                	je     80106fa0 <copyout+0x80>
80106f70:	8b 45 08             	mov    0x8(%ebp),%eax
80106f73:	89 ce                	mov    %ecx,%esi
80106f75:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
80106f7b:	89 74 24 04          	mov    %esi,0x4(%esp)
80106f7f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80106f82:	89 04 24             	mov    %eax,(%esp)
80106f85:	e8 56 ff ff ff       	call   80106ee0 <uva2ka>
80106f8a:	85 c0                	test   %eax,%eax
80106f8c:	75 aa                	jne    80106f38 <copyout+0x18>
80106f8e:	83 c4 1c             	add    $0x1c,%esp
80106f91:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106f96:	5b                   	pop    %ebx
80106f97:	5e                   	pop    %esi
80106f98:	5f                   	pop    %edi
80106f99:	5d                   	pop    %ebp
80106f9a:	c3                   	ret    
80106f9b:	90                   	nop
80106f9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106fa0:	83 c4 1c             	add    $0x1c,%esp
80106fa3:	31 c0                	xor    %eax,%eax
80106fa5:	5b                   	pop    %ebx
80106fa6:	5e                   	pop    %esi
80106fa7:	5f                   	pop    %edi
80106fa8:	5d                   	pop    %ebp
80106fa9:	c3                   	ret    
