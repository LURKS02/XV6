
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
8010002d:	b8 a0 2d 10 80       	mov    $0x80102da0,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
	...

80100040 <binit>:
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx
80100044:	bb f4 b5 10 80       	mov    $0x8010b5f4,%ebx
80100049:	83 ec 14             	sub    $0x14,%esp
8010004c:	c7 44 24 04 20 6e 10 	movl   $0x80106e20,0x4(%esp)
80100053:	80 
80100054:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
8010005b:	e8 e0 3f 00 00       	call   80104040 <initlock>
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
80100094:	c7 44 24 04 27 6e 10 	movl   $0x80106e27,0x4(%esp)
8010009b:	80 
8010009c:	e8 8f 3e 00 00       	call   80103f30 <initsleeplock>
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
801000e6:	e8 45 40 00 00       	call   80104130 <acquire>
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
80100161:	e8 ba 40 00 00       	call   80104220 <release>
80100166:	8d 43 0c             	lea    0xc(%ebx),%eax
80100169:	89 04 24             	mov    %eax,(%esp)
8010016c:	e8 ff 3d 00 00       	call   80103f70 <acquiresleep>
80100171:	f6 03 02             	testb  $0x2,(%ebx)
80100174:	75 08                	jne    8010017e <bread+0xae>
80100176:	89 1c 24             	mov    %ebx,(%esp)
80100179:	e8 62 1f 00 00       	call   801020e0 <iderw>
8010017e:	83 c4 1c             	add    $0x1c,%esp
80100181:	89 d8                	mov    %ebx,%eax
80100183:	5b                   	pop    %ebx
80100184:	5e                   	pop    %esi
80100185:	5f                   	pop    %edi
80100186:	5d                   	pop    %ebp
80100187:	c3                   	ret    
80100188:	c7 04 24 2e 6e 10 80 	movl   $0x80106e2e,(%esp)
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
801001b0:	e8 5b 3e 00 00       	call   80104010 <holdingsleep>
801001b5:	85 c0                	test   %eax,%eax
801001b7:	74 10                	je     801001c9 <bwrite+0x29>
801001b9:	83 0b 04             	orl    $0x4,(%ebx)
801001bc:	89 5d 08             	mov    %ebx,0x8(%ebp)
801001bf:	83 c4 14             	add    $0x14,%esp
801001c2:	5b                   	pop    %ebx
801001c3:	5d                   	pop    %ebp
801001c4:	e9 17 1f 00 00       	jmp    801020e0 <iderw>
801001c9:	c7 04 24 3f 6e 10 80 	movl   $0x80106e3f,(%esp)
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
801001f1:	e8 1a 3e 00 00       	call   80104010 <holdingsleep>
801001f6:	85 c0                	test   %eax,%eax
801001f8:	74 5b                	je     80100255 <brelse+0x75>
801001fa:	89 34 24             	mov    %esi,(%esp)
801001fd:	e8 ce 3d 00 00       	call   80103fd0 <releasesleep>
80100202:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100209:	e8 22 3f 00 00       	call   80104130 <acquire>
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
80100250:	e9 cb 3f 00 00       	jmp    80104220 <release>
80100255:	c7 04 24 46 6e 10 80 	movl   $0x80106e46,(%esp)
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
80100282:	e8 c9 14 00 00       	call   80101750 <iunlock>
80100287:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010028e:	e8 9d 3e 00 00       	call   80104130 <acquire>
80100293:	8b 55 10             	mov    0x10(%ebp),%edx
80100296:	85 d2                	test   %edx,%edx
80100298:	0f 8e bc 00 00 00    	jle    8010035a <consoleread+0xea>
8010029e:	8b 5d 10             	mov    0x10(%ebp),%ebx
801002a1:	eb 25                	jmp    801002c8 <consoleread+0x58>
801002a3:	90                   	nop
801002a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801002a8:	e8 b3 33 00 00       	call   80103660 <myproc>
801002ad:	8b 40 24             	mov    0x24(%eax),%eax
801002b0:	85 c0                	test   %eax,%eax
801002b2:	75 74                	jne    80100328 <consoleread+0xb8>
801002b4:	c7 44 24 04 20 a5 10 	movl   $0x8010a520,0x4(%esp)
801002bb:	80 
801002bc:	c7 04 24 a0 ff 10 80 	movl   $0x8010ffa0,(%esp)
801002c3:	e8 08 39 00 00       	call   80103bd0 <sleep>
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
80100311:	e8 0a 3f 00 00       	call   80104220 <release>
80100316:	89 3c 24             	mov    %edi,(%esp)
80100319:	e8 52 13 00 00       	call   80101670 <ilock>
8010031e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100321:	eb 1e                	jmp    80100341 <consoleread+0xd1>
80100323:	90                   	nop
80100324:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100328:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010032f:	e8 ec 3e 00 00       	call   80104220 <release>
80100334:	89 3c 24             	mov    %edi,(%esp)
80100337:	e8 34 13 00 00       	call   80101670 <ilock>
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
80100376:	e8 95 23 00 00       	call   80102710 <lapicid>
8010037b:	8d 75 f8             	lea    -0x8(%ebp),%esi
8010037e:	c7 04 24 4d 6e 10 80 	movl   $0x80106e4d,(%esp)
80100385:	89 44 24 04          	mov    %eax,0x4(%esp)
80100389:	e8 c2 02 00 00       	call   80100650 <cprintf>
8010038e:	8b 45 08             	mov    0x8(%ebp),%eax
80100391:	89 04 24             	mov    %eax,(%esp)
80100394:	e8 b7 02 00 00       	call   80100650 <cprintf>
80100399:	c7 04 24 d7 77 10 80 	movl   $0x801077d7,(%esp)
801003a0:	e8 ab 02 00 00       	call   80100650 <cprintf>
801003a5:	8d 45 08             	lea    0x8(%ebp),%eax
801003a8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801003ac:	89 04 24             	mov    %eax,(%esp)
801003af:	e8 ac 3c 00 00       	call   80104060 <getcallerpcs>
801003b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801003b8:	8b 03                	mov    (%ebx),%eax
801003ba:	83 c3 04             	add    $0x4,%ebx
801003bd:	c7 04 24 61 6e 10 80 	movl   $0x80106e61,(%esp)
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
80100409:	e8 62 55 00 00       	call   80105970 <uartputc>
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
801004b4:	e8 b7 54 00 00       	call   80105970 <uartputc>
801004b9:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004c0:	e8 ab 54 00 00       	call   80105970 <uartputc>
801004c5:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004cc:	e8 9f 54 00 00       	call   80105970 <uartputc>
801004d1:	e9 38 ff ff ff       	jmp    8010040e <consputc+0x2e>
801004d6:	c7 44 24 08 60 0e 00 	movl   $0xe60,0x8(%esp)
801004dd:	00 
801004de:	8d 73 b0             	lea    -0x50(%ebx),%esi
801004e1:	c7 44 24 04 a0 80 0b 	movl   $0x800b80a0,0x4(%esp)
801004e8:	80 
801004e9:	8d bc 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%edi
801004f0:	c7 04 24 00 80 0b 80 	movl   $0x800b8000,(%esp)
801004f7:	e8 14 3e 00 00       	call   80104310 <memmove>
801004fc:	b8 d0 07 00 00       	mov    $0x7d0,%eax
80100501:	29 d8                	sub    %ebx,%eax
80100503:	01 c0                	add    %eax,%eax
80100505:	89 3c 24             	mov    %edi,(%esp)
80100508:	89 44 24 08          	mov    %eax,0x8(%esp)
8010050c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100513:	00 
80100514:	e8 57 3d 00 00       	call   80104270 <memset>
80100519:	89 f9                	mov    %edi,%ecx
8010051b:	bf 07 00 00 00       	mov    $0x7,%edi
80100520:	e9 5b ff ff ff       	jmp    80100480 <consputc+0xa0>
80100525:	c7 04 24 65 6e 10 80 	movl   $0x80106e65,(%esp)
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
80100599:	0f b6 92 90 6e 10 80 	movzbl -0x7fef9170(%edx),%edx
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
80100602:	e8 49 11 00 00       	call   80101750 <iunlock>
80100607:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010060e:	e8 1d 3b 00 00       	call   80104130 <acquire>
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
80100636:	e8 e5 3b 00 00       	call   80104220 <release>
8010063b:	8b 45 08             	mov    0x8(%ebp),%eax
8010063e:	89 04 24             	mov    %eax,(%esp)
80100641:	e8 2a 10 00 00       	call   80101670 <ilock>
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
801006f3:	e8 28 3b 00 00       	call   80104220 <release>
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
80100760:	b8 78 6e 10 80       	mov    $0x80106e78,%eax
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
80100797:	e8 94 39 00 00       	call   80104130 <acquire>
8010079c:	e9 c8 fe ff ff       	jmp    80100669 <cprintf+0x19>
801007a1:	c7 04 24 7f 6e 10 80 	movl   $0x80106e7f,(%esp)
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
801007c5:	e8 66 39 00 00       	call   80104130 <acquire>
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
80100827:	e8 f4 39 00 00       	call   80104220 <release>
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
801008b2:	e8 b9 34 00 00       	call   80103d70 <wakeup>
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
80100927:	e9 34 35 00 00       	jmp    80103e60 <procdump>
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
80100956:	c7 44 24 04 88 6e 10 	movl   $0x80106e88,0x4(%esp)
8010095d:	80 
8010095e:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100965:	e8 d6 36 00 00       	call   80104040 <initlock>
8010096a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100971:	00 
80100972:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80100979:	c7 05 6c 09 11 80 f0 	movl   $0x801005f0,0x8011096c
80100980:	05 10 80 
80100983:	c7 05 68 09 11 80 70 	movl   $0x80100270,0x80110968
8010098a:	02 10 80 
8010098d:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
80100994:	00 00 00 
80100997:	e8 d4 18 00 00       	call   80102270 <ioapicenable>
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
801009ac:	e8 af 2c 00 00       	call   80103660 <myproc>
801009b1:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
801009b7:	e8 04 21 00 00       	call   80102ac0 <begin_op>
801009bc:	8b 45 08             	mov    0x8(%ebp),%eax
801009bf:	89 04 24             	mov    %eax,(%esp)
801009c2:	e8 f9 14 00 00       	call   80101ec0 <namei>
801009c7:	85 c0                	test   %eax,%eax
801009c9:	89 c3                	mov    %eax,%ebx
801009cb:	0f 84 c2 01 00 00    	je     80100b93 <exec+0x1f3>
801009d1:	89 04 24             	mov    %eax,(%esp)
801009d4:	e8 97 0c 00 00       	call   80101670 <ilock>
801009d9:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
801009df:	c7 44 24 0c 34 00 00 	movl   $0x34,0xc(%esp)
801009e6:	00 
801009e7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801009ee:	00 
801009ef:	89 44 24 04          	mov    %eax,0x4(%esp)
801009f3:	89 1c 24             	mov    %ebx,(%esp)
801009f6:	e8 25 0f 00 00       	call   80101920 <readi>
801009fb:	83 f8 34             	cmp    $0x34,%eax
801009fe:	74 20                	je     80100a20 <exec+0x80>
80100a00:	89 1c 24             	mov    %ebx,(%esp)
80100a03:	e8 c8 0e 00 00       	call   801018d0 <iunlockput>
80100a08:	e8 23 21 00 00       	call   80102b30 <end_op>
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
80100a2c:	e8 3f 61 00 00       	call   80106b70 <setupkvm>
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
80100a8e:	e8 8d 0e 00 00       	call   80101920 <readi>
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
80100ad2:	e8 f9 5e 00 00       	call   801069d0 <allocuvm>
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
80100b13:	e8 f8 5d 00 00       	call   80106910 <loaduvm>
80100b18:	85 c0                	test   %eax,%eax
80100b1a:	0f 89 40 ff ff ff    	jns    80100a60 <exec+0xc0>
80100b20:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100b26:	89 04 24             	mov    %eax,(%esp)
80100b29:	e8 c2 5f 00 00       	call   80106af0 <freevm>
80100b2e:	e9 cd fe ff ff       	jmp    80100a00 <exec+0x60>
80100b33:	89 1c 24             	mov    %ebx,(%esp)
80100b36:	e8 95 0d 00 00       	call   801018d0 <iunlockput>
80100b3b:	90                   	nop
80100b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100b40:	e8 eb 1f 00 00       	call   80102b30 <end_op>
80100b45:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100b4b:	05 ff 0f 00 00       	add    $0xfff,%eax
80100b50:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100b55:	8d 90 00 20 00 00    	lea    0x2000(%eax),%edx
80100b5b:	89 44 24 04          	mov    %eax,0x4(%esp)
80100b5f:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100b65:	89 54 24 08          	mov    %edx,0x8(%esp)
80100b69:	89 04 24             	mov    %eax,(%esp)
80100b6c:	e8 5f 5e 00 00       	call   801069d0 <allocuvm>
80100b71:	85 c0                	test   %eax,%eax
80100b73:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
80100b79:	75 33                	jne    80100bae <exec+0x20e>
80100b7b:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100b81:	89 04 24             	mov    %eax,(%esp)
80100b84:	e8 67 5f 00 00       	call   80106af0 <freevm>
80100b89:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100b8e:	e9 7f fe ff ff       	jmp    80100a12 <exec+0x72>
80100b93:	e8 98 1f 00 00       	call   80102b30 <end_op>
80100b98:	c7 04 24 a1 6e 10 80 	movl   $0x80106ea1,(%esp)
80100b9f:	e8 ac fa ff ff       	call   80100650 <cprintf>
80100ba4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100ba9:	e9 64 fe ff ff       	jmp    80100a12 <exec+0x72>
80100bae:	8b 9d e8 fe ff ff    	mov    -0x118(%ebp),%ebx
80100bb4:	89 d8                	mov    %ebx,%eax
80100bb6:	2d 00 20 00 00       	sub    $0x2000,%eax
80100bbb:	89 44 24 04          	mov    %eax,0x4(%esp)
80100bbf:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100bc5:	89 04 24             	mov    %eax,(%esp)
80100bc8:	e8 53 60 00 00       	call   80106c20 <clearpteu>
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
80100c01:	e8 8a 38 00 00       	call   80104490 <strlen>
80100c06:	f7 d0                	not    %eax
80100c08:	01 c3                	add    %eax,%ebx
80100c0a:	8b 06                	mov    (%esi),%eax
80100c0c:	83 e3 fc             	and    $0xfffffffc,%ebx
80100c0f:	89 04 24             	mov    %eax,(%esp)
80100c12:	e8 79 38 00 00       	call   80104490 <strlen>
80100c17:	83 c0 01             	add    $0x1,%eax
80100c1a:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100c1e:	8b 06                	mov    (%esi),%eax
80100c20:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80100c24:	89 44 24 08          	mov    %eax,0x8(%esp)
80100c28:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100c2e:	89 04 24             	mov    %eax,(%esp)
80100c31:	e8 4a 61 00 00       	call   80106d80 <copyout>
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
80100ca4:	e8 d7 60 00 00       	call   80106d80 <copyout>
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
80100cf1:	e8 5a 37 00 00       	call   80104450 <safestrcpy>
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
80100d1f:	e8 4c 5a 00 00       	call   80106770 <switchuvm>
80100d24:	89 34 24             	mov    %esi,(%esp)
80100d27:	e8 c4 5d 00 00       	call   80106af0 <freevm>
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
80100d56:	c7 44 24 04 ad 6e 10 	movl   $0x80106ead,0x4(%esp)
80100d5d:	80 
80100d5e:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100d65:	e8 d6 32 00 00       	call   80104040 <initlock>
80100d6a:	c9                   	leave  
80100d6b:	c3                   	ret    
80100d6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100d70 <filealloc>:
80100d70:	55                   	push   %ebp
80100d71:	89 e5                	mov    %esp,%ebp
80100d73:	83 ec 18             	sub    $0x18,%esp
80100d76:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100d7d:	e8 ae 33 00 00       	call   80104130 <acquire>
80100d82:	eb fe                	jmp    80100d82 <filealloc+0x12>
80100d84:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100d8a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100d90 <filedup>:
80100d90:	55                   	push   %ebp
80100d91:	89 e5                	mov    %esp,%ebp
80100d93:	53                   	push   %ebx
80100d94:	83 ec 14             	sub    $0x14,%esp
80100d97:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100d9a:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100da1:	e8 8a 33 00 00       	call   80104130 <acquire>
80100da6:	8b 43 04             	mov    0x4(%ebx),%eax
80100da9:	85 c0                	test   %eax,%eax
80100dab:	7e 1a                	jle    80100dc7 <filedup+0x37>
80100dad:	83 c0 01             	add    $0x1,%eax
80100db0:	89 43 04             	mov    %eax,0x4(%ebx)
80100db3:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100dba:	e8 61 34 00 00       	call   80104220 <release>
80100dbf:	83 c4 14             	add    $0x14,%esp
80100dc2:	89 d8                	mov    %ebx,%eax
80100dc4:	5b                   	pop    %ebx
80100dc5:	5d                   	pop    %ebp
80100dc6:	c3                   	ret    
80100dc7:	c7 04 24 b4 6e 10 80 	movl   $0x80106eb4,(%esp)
80100dce:	e8 8d f5 ff ff       	call   80100360 <panic>
80100dd3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100dd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100de0 <fileclose>:
80100de0:	55                   	push   %ebp
80100de1:	89 e5                	mov    %esp,%ebp
80100de3:	57                   	push   %edi
80100de4:	56                   	push   %esi
80100de5:	53                   	push   %ebx
80100de6:	83 ec 1c             	sub    $0x1c,%esp
80100de9:	8b 7d 08             	mov    0x8(%ebp),%edi
80100dec:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100df3:	e8 38 33 00 00       	call   80104130 <acquire>
80100df8:	8b 57 04             	mov    0x4(%edi),%edx
80100dfb:	85 d2                	test   %edx,%edx
80100dfd:	0f 8e 89 00 00 00    	jle    80100e8c <fileclose+0xac>
80100e03:	83 ea 01             	sub    $0x1,%edx
80100e06:	85 d2                	test   %edx,%edx
80100e08:	89 57 04             	mov    %edx,0x4(%edi)
80100e0b:	74 13                	je     80100e20 <fileclose+0x40>
80100e0d:	c7 45 08 c0 ff 10 80 	movl   $0x8010ffc0,0x8(%ebp)
80100e14:	83 c4 1c             	add    $0x1c,%esp
80100e17:	5b                   	pop    %ebx
80100e18:	5e                   	pop    %esi
80100e19:	5f                   	pop    %edi
80100e1a:	5d                   	pop    %ebp
80100e1b:	e9 00 34 00 00       	jmp    80104220 <release>
80100e20:	0f b6 47 09          	movzbl 0x9(%edi),%eax
80100e24:	8b 37                	mov    (%edi),%esi
80100e26:	8b 5f 0c             	mov    0xc(%edi),%ebx
80100e29:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
80100e2f:	88 45 e7             	mov    %al,-0x19(%ebp)
80100e32:	8b 47 10             	mov    0x10(%edi),%eax
80100e35:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100e3c:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100e3f:	e8 dc 33 00 00       	call   80104220 <release>
80100e44:	83 fe 01             	cmp    $0x1,%esi
80100e47:	74 0f                	je     80100e58 <fileclose+0x78>
80100e49:	83 fe 02             	cmp    $0x2,%esi
80100e4c:	74 22                	je     80100e70 <fileclose+0x90>
80100e4e:	83 c4 1c             	add    $0x1c,%esp
80100e51:	5b                   	pop    %ebx
80100e52:	5e                   	pop    %esi
80100e53:	5f                   	pop    %edi
80100e54:	5d                   	pop    %ebp
80100e55:	c3                   	ret    
80100e56:	66 90                	xchg   %ax,%ax
80100e58:	0f be 75 e7          	movsbl -0x19(%ebp),%esi
80100e5c:	89 1c 24             	mov    %ebx,(%esp)
80100e5f:	89 74 24 04          	mov    %esi,0x4(%esp)
80100e63:	e8 a8 23 00 00       	call   80103210 <pipeclose>
80100e68:	eb e4                	jmp    80100e4e <fileclose+0x6e>
80100e6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100e70:	e8 4b 1c 00 00       	call   80102ac0 <begin_op>
80100e75:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100e78:	89 04 24             	mov    %eax,(%esp)
80100e7b:	e8 10 09 00 00       	call   80101790 <iput>
80100e80:	83 c4 1c             	add    $0x1c,%esp
80100e83:	5b                   	pop    %ebx
80100e84:	5e                   	pop    %esi
80100e85:	5f                   	pop    %edi
80100e86:	5d                   	pop    %ebp
80100e87:	e9 a4 1c 00 00       	jmp    80102b30 <end_op>
80100e8c:	c7 04 24 bc 6e 10 80 	movl   $0x80106ebc,(%esp)
80100e93:	e8 c8 f4 ff ff       	call   80100360 <panic>
80100e98:	90                   	nop
80100e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ea0 <filestat>:
80100ea0:	55                   	push   %ebp
80100ea1:	89 e5                	mov    %esp,%ebp
80100ea3:	53                   	push   %ebx
80100ea4:	83 ec 14             	sub    $0x14,%esp
80100ea7:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100eaa:	83 3b 02             	cmpl   $0x2,(%ebx)
80100ead:	75 31                	jne    80100ee0 <filestat+0x40>
80100eaf:	8b 43 10             	mov    0x10(%ebx),%eax
80100eb2:	89 04 24             	mov    %eax,(%esp)
80100eb5:	e8 b6 07 00 00       	call   80101670 <ilock>
80100eba:	8b 45 0c             	mov    0xc(%ebp),%eax
80100ebd:	89 44 24 04          	mov    %eax,0x4(%esp)
80100ec1:	8b 43 10             	mov    0x10(%ebx),%eax
80100ec4:	89 04 24             	mov    %eax,(%esp)
80100ec7:	e8 24 0a 00 00       	call   801018f0 <stati>
80100ecc:	8b 43 10             	mov    0x10(%ebx),%eax
80100ecf:	89 04 24             	mov    %eax,(%esp)
80100ed2:	e8 79 08 00 00       	call   80101750 <iunlock>
80100ed7:	83 c4 14             	add    $0x14,%esp
80100eda:	31 c0                	xor    %eax,%eax
80100edc:	5b                   	pop    %ebx
80100edd:	5d                   	pop    %ebp
80100ede:	c3                   	ret    
80100edf:	90                   	nop
80100ee0:	83 c4 14             	add    $0x14,%esp
80100ee3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100ee8:	5b                   	pop    %ebx
80100ee9:	5d                   	pop    %ebp
80100eea:	c3                   	ret    
80100eeb:	90                   	nop
80100eec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100ef0 <fileread>:
80100ef0:	55                   	push   %ebp
80100ef1:	89 e5                	mov    %esp,%ebp
80100ef3:	57                   	push   %edi
80100ef4:	56                   	push   %esi
80100ef5:	53                   	push   %ebx
80100ef6:	83 ec 1c             	sub    $0x1c,%esp
80100ef9:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100efc:	8b 75 0c             	mov    0xc(%ebp),%esi
80100eff:	8b 7d 10             	mov    0x10(%ebp),%edi
80100f02:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100f06:	74 68                	je     80100f70 <fileread+0x80>
80100f08:	8b 03                	mov    (%ebx),%eax
80100f0a:	83 f8 01             	cmp    $0x1,%eax
80100f0d:	74 49                	je     80100f58 <fileread+0x68>
80100f0f:	83 f8 02             	cmp    $0x2,%eax
80100f12:	75 63                	jne    80100f77 <fileread+0x87>
80100f14:	8b 43 10             	mov    0x10(%ebx),%eax
80100f17:	89 04 24             	mov    %eax,(%esp)
80100f1a:	e8 51 07 00 00       	call   80101670 <ilock>
80100f1f:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80100f23:	8b 43 14             	mov    0x14(%ebx),%eax
80100f26:	89 74 24 04          	mov    %esi,0x4(%esp)
80100f2a:	89 44 24 08          	mov    %eax,0x8(%esp)
80100f2e:	8b 43 10             	mov    0x10(%ebx),%eax
80100f31:	89 04 24             	mov    %eax,(%esp)
80100f34:	e8 e7 09 00 00       	call   80101920 <readi>
80100f39:	85 c0                	test   %eax,%eax
80100f3b:	89 c6                	mov    %eax,%esi
80100f3d:	7e 03                	jle    80100f42 <fileread+0x52>
80100f3f:	01 43 14             	add    %eax,0x14(%ebx)
80100f42:	8b 43 10             	mov    0x10(%ebx),%eax
80100f45:	89 04 24             	mov    %eax,(%esp)
80100f48:	e8 03 08 00 00       	call   80101750 <iunlock>
80100f4d:	89 f0                	mov    %esi,%eax
80100f4f:	83 c4 1c             	add    $0x1c,%esp
80100f52:	5b                   	pop    %ebx
80100f53:	5e                   	pop    %esi
80100f54:	5f                   	pop    %edi
80100f55:	5d                   	pop    %ebp
80100f56:	c3                   	ret    
80100f57:	90                   	nop
80100f58:	8b 43 0c             	mov    0xc(%ebx),%eax
80100f5b:	89 45 08             	mov    %eax,0x8(%ebp)
80100f5e:	83 c4 1c             	add    $0x1c,%esp
80100f61:	5b                   	pop    %ebx
80100f62:	5e                   	pop    %esi
80100f63:	5f                   	pop    %edi
80100f64:	5d                   	pop    %ebp
80100f65:	e9 26 24 00 00       	jmp    80103390 <piperead>
80100f6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100f70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100f75:	eb d8                	jmp    80100f4f <fileread+0x5f>
80100f77:	c7 04 24 c6 6e 10 80 	movl   $0x80106ec6,(%esp)
80100f7e:	e8 dd f3 ff ff       	call   80100360 <panic>
80100f83:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100f89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100f90 <filewrite>:
80100f90:	55                   	push   %ebp
80100f91:	89 e5                	mov    %esp,%ebp
80100f93:	57                   	push   %edi
80100f94:	56                   	push   %esi
80100f95:	53                   	push   %ebx
80100f96:	83 ec 2c             	sub    $0x2c,%esp
80100f99:	8b 45 0c             	mov    0xc(%ebp),%eax
80100f9c:	8b 7d 08             	mov    0x8(%ebp),%edi
80100f9f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80100fa2:	8b 45 10             	mov    0x10(%ebp),%eax
80100fa5:	80 7f 09 00          	cmpb   $0x0,0x9(%edi)
80100fa9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100fac:	0f 84 ae 00 00 00    	je     80101060 <filewrite+0xd0>
80100fb2:	8b 07                	mov    (%edi),%eax
80100fb4:	83 f8 01             	cmp    $0x1,%eax
80100fb7:	0f 84 c2 00 00 00    	je     8010107f <filewrite+0xef>
80100fbd:	83 f8 02             	cmp    $0x2,%eax
80100fc0:	0f 85 d7 00 00 00    	jne    8010109d <filewrite+0x10d>
80100fc6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100fc9:	31 db                	xor    %ebx,%ebx
80100fcb:	85 c0                	test   %eax,%eax
80100fcd:	7f 31                	jg     80101000 <filewrite+0x70>
80100fcf:	e9 9c 00 00 00       	jmp    80101070 <filewrite+0xe0>
80100fd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100fd8:	8b 4f 10             	mov    0x10(%edi),%ecx
80100fdb:	01 47 14             	add    %eax,0x14(%edi)
80100fde:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100fe1:	89 0c 24             	mov    %ecx,(%esp)
80100fe4:	e8 67 07 00 00       	call   80101750 <iunlock>
80100fe9:	e8 42 1b 00 00       	call   80102b30 <end_op>
80100fee:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100ff1:	39 f0                	cmp    %esi,%eax
80100ff3:	0f 85 98 00 00 00    	jne    80101091 <filewrite+0x101>
80100ff9:	01 c3                	add    %eax,%ebx
80100ffb:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
80100ffe:	7e 70                	jle    80101070 <filewrite+0xe0>
80101000:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101003:	b8 00 06 00 00       	mov    $0x600,%eax
80101008:	29 de                	sub    %ebx,%esi
8010100a:	81 fe 00 06 00 00    	cmp    $0x600,%esi
80101010:	0f 4f f0             	cmovg  %eax,%esi
80101013:	e8 a8 1a 00 00       	call   80102ac0 <begin_op>
80101018:	8b 47 10             	mov    0x10(%edi),%eax
8010101b:	89 04 24             	mov    %eax,(%esp)
8010101e:	e8 4d 06 00 00       	call   80101670 <ilock>
80101023:	89 74 24 0c          	mov    %esi,0xc(%esp)
80101027:	8b 47 14             	mov    0x14(%edi),%eax
8010102a:	89 44 24 08          	mov    %eax,0x8(%esp)
8010102e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101031:	01 d8                	add    %ebx,%eax
80101033:	89 44 24 04          	mov    %eax,0x4(%esp)
80101037:	8b 47 10             	mov    0x10(%edi),%eax
8010103a:	89 04 24             	mov    %eax,(%esp)
8010103d:	e8 de 09 00 00       	call   80101a20 <writei>
80101042:	85 c0                	test   %eax,%eax
80101044:	7f 92                	jg     80100fd8 <filewrite+0x48>
80101046:	8b 4f 10             	mov    0x10(%edi),%ecx
80101049:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010104c:	89 0c 24             	mov    %ecx,(%esp)
8010104f:	e8 fc 06 00 00       	call   80101750 <iunlock>
80101054:	e8 d7 1a 00 00       	call   80102b30 <end_op>
80101059:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010105c:	85 c0                	test   %eax,%eax
8010105e:	74 91                	je     80100ff1 <filewrite+0x61>
80101060:	83 c4 2c             	add    $0x2c,%esp
80101063:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101068:	5b                   	pop    %ebx
80101069:	5e                   	pop    %esi
8010106a:	5f                   	pop    %edi
8010106b:	5d                   	pop    %ebp
8010106c:	c3                   	ret    
8010106d:	8d 76 00             	lea    0x0(%esi),%esi
80101070:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
80101073:	89 d8                	mov    %ebx,%eax
80101075:	75 e9                	jne    80101060 <filewrite+0xd0>
80101077:	83 c4 2c             	add    $0x2c,%esp
8010107a:	5b                   	pop    %ebx
8010107b:	5e                   	pop    %esi
8010107c:	5f                   	pop    %edi
8010107d:	5d                   	pop    %ebp
8010107e:	c3                   	ret    
8010107f:	8b 47 0c             	mov    0xc(%edi),%eax
80101082:	89 45 08             	mov    %eax,0x8(%ebp)
80101085:	83 c4 2c             	add    $0x2c,%esp
80101088:	5b                   	pop    %ebx
80101089:	5e                   	pop    %esi
8010108a:	5f                   	pop    %edi
8010108b:	5d                   	pop    %ebp
8010108c:	e9 0f 22 00 00       	jmp    801032a0 <pipewrite>
80101091:	c7 04 24 cf 6e 10 80 	movl   $0x80106ecf,(%esp)
80101098:	e8 c3 f2 ff ff       	call   80100360 <panic>
8010109d:	c7 04 24 d5 6e 10 80 	movl   $0x80106ed5,(%esp)
801010a4:	e8 b7 f2 ff ff       	call   80100360 <panic>
801010a9:	00 00                	add    %al,(%eax)
801010ab:	00 00                	add    %al,(%eax)
801010ad:	00 00                	add    %al,(%eax)
	...

801010b0 <balloc>:
801010b0:	55                   	push   %ebp
801010b1:	89 e5                	mov    %esp,%ebp
801010b3:	57                   	push   %edi
801010b4:	56                   	push   %esi
801010b5:	53                   	push   %ebx
801010b6:	83 ec 2c             	sub    $0x2c,%esp
801010b9:	89 45 d8             	mov    %eax,-0x28(%ebp)
801010bc:	a1 c0 09 11 80       	mov    0x801109c0,%eax
801010c1:	85 c0                	test   %eax,%eax
801010c3:	0f 84 8c 00 00 00    	je     80101155 <balloc+0xa5>
801010c9:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
801010d0:	8b 75 dc             	mov    -0x24(%ebp),%esi
801010d3:	89 f0                	mov    %esi,%eax
801010d5:	c1 f8 0c             	sar    $0xc,%eax
801010d8:	03 05 d8 09 11 80    	add    0x801109d8,%eax
801010de:	89 44 24 04          	mov    %eax,0x4(%esp)
801010e2:	8b 45 d8             	mov    -0x28(%ebp),%eax
801010e5:	89 04 24             	mov    %eax,(%esp)
801010e8:	e8 e3 ef ff ff       	call   801000d0 <bread>
801010ed:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801010f0:	a1 c0 09 11 80       	mov    0x801109c0,%eax
801010f5:	89 45 e0             	mov    %eax,-0x20(%ebp)
801010f8:	31 c0                	xor    %eax,%eax
801010fa:	eb 33                	jmp    8010112f <balloc+0x7f>
801010fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101100:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101103:	89 c2                	mov    %eax,%edx
80101105:	89 c1                	mov    %eax,%ecx
80101107:	c1 fa 03             	sar    $0x3,%edx
8010110a:	83 e1 07             	and    $0x7,%ecx
8010110d:	bf 01 00 00 00       	mov    $0x1,%edi
80101112:	d3 e7                	shl    %cl,%edi
80101114:	0f b6 5c 13 5c       	movzbl 0x5c(%ebx,%edx,1),%ebx
80101119:	89 f9                	mov    %edi,%ecx
8010111b:	0f b6 fb             	movzbl %bl,%edi
8010111e:	85 cf                	test   %ecx,%edi
80101120:	74 46                	je     80101168 <balloc+0xb8>
80101122:	83 c0 01             	add    $0x1,%eax
80101125:	83 c6 01             	add    $0x1,%esi
80101128:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010112d:	74 05                	je     80101134 <balloc+0x84>
8010112f:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80101132:	72 cc                	jb     80101100 <balloc+0x50>
80101134:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101137:	89 04 24             	mov    %eax,(%esp)
8010113a:	e8 a1 f0 ff ff       	call   801001e0 <brelse>
8010113f:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101146:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101149:	3b 05 c0 09 11 80    	cmp    0x801109c0,%eax
8010114f:	0f 82 7b ff ff ff    	jb     801010d0 <balloc+0x20>
80101155:	c7 04 24 df 6e 10 80 	movl   $0x80106edf,(%esp)
8010115c:	e8 ff f1 ff ff       	call   80100360 <panic>
80101161:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101168:	09 d9                	or     %ebx,%ecx
8010116a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010116d:	88 4c 13 5c          	mov    %cl,0x5c(%ebx,%edx,1)
80101171:	89 1c 24             	mov    %ebx,(%esp)
80101174:	e8 e7 1a 00 00       	call   80102c60 <log_write>
80101179:	89 1c 24             	mov    %ebx,(%esp)
8010117c:	e8 5f f0 ff ff       	call   801001e0 <brelse>
80101181:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101184:	89 74 24 04          	mov    %esi,0x4(%esp)
80101188:	89 04 24             	mov    %eax,(%esp)
8010118b:	e8 40 ef ff ff       	call   801000d0 <bread>
80101190:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80101197:	00 
80101198:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010119f:	00 
801011a0:	89 c3                	mov    %eax,%ebx
801011a2:	8d 40 5c             	lea    0x5c(%eax),%eax
801011a5:	89 04 24             	mov    %eax,(%esp)
801011a8:	e8 c3 30 00 00       	call   80104270 <memset>
801011ad:	89 1c 24             	mov    %ebx,(%esp)
801011b0:	e8 ab 1a 00 00       	call   80102c60 <log_write>
801011b5:	89 1c 24             	mov    %ebx,(%esp)
801011b8:	e8 23 f0 ff ff       	call   801001e0 <brelse>
801011bd:	83 c4 2c             	add    $0x2c,%esp
801011c0:	89 f0                	mov    %esi,%eax
801011c2:	5b                   	pop    %ebx
801011c3:	5e                   	pop    %esi
801011c4:	5f                   	pop    %edi
801011c5:	5d                   	pop    %ebp
801011c6:	c3                   	ret    
801011c7:	89 f6                	mov    %esi,%esi
801011c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801011d0 <iget>:
801011d0:	55                   	push   %ebp
801011d1:	89 e5                	mov    %esp,%ebp
801011d3:	57                   	push   %edi
801011d4:	89 c7                	mov    %eax,%edi
801011d6:	56                   	push   %esi
801011d7:	31 f6                	xor    %esi,%esi
801011d9:	53                   	push   %ebx
801011da:	bb 14 0a 11 80       	mov    $0x80110a14,%ebx
801011df:	83 ec 1c             	sub    $0x1c,%esp
801011e2:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801011e9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801011ec:	e8 3f 2f 00 00       	call   80104130 <acquire>
801011f1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801011f4:	eb 14                	jmp    8010120a <iget+0x3a>
801011f6:	66 90                	xchg   %ax,%ax
801011f8:	85 f6                	test   %esi,%esi
801011fa:	74 3c                	je     80101238 <iget+0x68>
801011fc:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101202:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
80101208:	74 46                	je     80101250 <iget+0x80>
8010120a:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010120d:	85 c9                	test   %ecx,%ecx
8010120f:	7e e7                	jle    801011f8 <iget+0x28>
80101211:	39 3b                	cmp    %edi,(%ebx)
80101213:	75 e3                	jne    801011f8 <iget+0x28>
80101215:	39 53 04             	cmp    %edx,0x4(%ebx)
80101218:	75 de                	jne    801011f8 <iget+0x28>
8010121a:	83 c1 01             	add    $0x1,%ecx
8010121d:	89 de                	mov    %ebx,%esi
8010121f:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101226:	89 4b 08             	mov    %ecx,0x8(%ebx)
80101229:	e8 f2 2f 00 00       	call   80104220 <release>
8010122e:	83 c4 1c             	add    $0x1c,%esp
80101231:	89 f0                	mov    %esi,%eax
80101233:	5b                   	pop    %ebx
80101234:	5e                   	pop    %esi
80101235:	5f                   	pop    %edi
80101236:	5d                   	pop    %ebp
80101237:	c3                   	ret    
80101238:	85 c9                	test   %ecx,%ecx
8010123a:	0f 44 f3             	cmove  %ebx,%esi
8010123d:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101243:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
80101249:	75 bf                	jne    8010120a <iget+0x3a>
8010124b:	90                   	nop
8010124c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101250:	85 f6                	test   %esi,%esi
80101252:	74 29                	je     8010127d <iget+0xad>
80101254:	89 3e                	mov    %edi,(%esi)
80101256:	89 56 04             	mov    %edx,0x4(%esi)
80101259:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
80101260:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
80101267:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010126e:	e8 ad 2f 00 00       	call   80104220 <release>
80101273:	83 c4 1c             	add    $0x1c,%esp
80101276:	89 f0                	mov    %esi,%eax
80101278:	5b                   	pop    %ebx
80101279:	5e                   	pop    %esi
8010127a:	5f                   	pop    %edi
8010127b:	5d                   	pop    %ebp
8010127c:	c3                   	ret    
8010127d:	c7 04 24 f5 6e 10 80 	movl   $0x80106ef5,(%esp)
80101284:	e8 d7 f0 ff ff       	call   80100360 <panic>
80101289:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101290 <bmap>:
80101290:	55                   	push   %ebp
80101291:	89 e5                	mov    %esp,%ebp
80101293:	57                   	push   %edi
80101294:	56                   	push   %esi
80101295:	53                   	push   %ebx
80101296:	89 c3                	mov    %eax,%ebx
80101298:	83 ec 1c             	sub    $0x1c,%esp
8010129b:	83 fa 0b             	cmp    $0xb,%edx
8010129e:	77 18                	ja     801012b8 <bmap+0x28>
801012a0:	8d 34 90             	lea    (%eax,%edx,4),%esi
801012a3:	8b 46 5c             	mov    0x5c(%esi),%eax
801012a6:	85 c0                	test   %eax,%eax
801012a8:	74 66                	je     80101310 <bmap+0x80>
801012aa:	83 c4 1c             	add    $0x1c,%esp
801012ad:	5b                   	pop    %ebx
801012ae:	5e                   	pop    %esi
801012af:	5f                   	pop    %edi
801012b0:	5d                   	pop    %ebp
801012b1:	c3                   	ret    
801012b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801012b8:	8d 72 f4             	lea    -0xc(%edx),%esi
801012bb:	83 fe 7f             	cmp    $0x7f,%esi
801012be:	77 77                	ja     80101337 <bmap+0xa7>
801012c0:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
801012c6:	85 c0                	test   %eax,%eax
801012c8:	74 5e                	je     80101328 <bmap+0x98>
801012ca:	89 44 24 04          	mov    %eax,0x4(%esp)
801012ce:	8b 03                	mov    (%ebx),%eax
801012d0:	89 04 24             	mov    %eax,(%esp)
801012d3:	e8 f8 ed ff ff       	call   801000d0 <bread>
801012d8:	8d 54 b0 5c          	lea    0x5c(%eax,%esi,4),%edx
801012dc:	89 c7                	mov    %eax,%edi
801012de:	8b 32                	mov    (%edx),%esi
801012e0:	85 f6                	test   %esi,%esi
801012e2:	75 19                	jne    801012fd <bmap+0x6d>
801012e4:	8b 03                	mov    (%ebx),%eax
801012e6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801012e9:	e8 c2 fd ff ff       	call   801010b0 <balloc>
801012ee:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801012f1:	89 02                	mov    %eax,(%edx)
801012f3:	89 c6                	mov    %eax,%esi
801012f5:	89 3c 24             	mov    %edi,(%esp)
801012f8:	e8 63 19 00 00       	call   80102c60 <log_write>
801012fd:	89 3c 24             	mov    %edi,(%esp)
80101300:	e8 db ee ff ff       	call   801001e0 <brelse>
80101305:	83 c4 1c             	add    $0x1c,%esp
80101308:	89 f0                	mov    %esi,%eax
8010130a:	5b                   	pop    %ebx
8010130b:	5e                   	pop    %esi
8010130c:	5f                   	pop    %edi
8010130d:	5d                   	pop    %ebp
8010130e:	c3                   	ret    
8010130f:	90                   	nop
80101310:	8b 03                	mov    (%ebx),%eax
80101312:	e8 99 fd ff ff       	call   801010b0 <balloc>
80101317:	89 46 5c             	mov    %eax,0x5c(%esi)
8010131a:	83 c4 1c             	add    $0x1c,%esp
8010131d:	5b                   	pop    %ebx
8010131e:	5e                   	pop    %esi
8010131f:	5f                   	pop    %edi
80101320:	5d                   	pop    %ebp
80101321:	c3                   	ret    
80101322:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101328:	8b 03                	mov    (%ebx),%eax
8010132a:	e8 81 fd ff ff       	call   801010b0 <balloc>
8010132f:	89 83 8c 00 00 00    	mov    %eax,0x8c(%ebx)
80101335:	eb 93                	jmp    801012ca <bmap+0x3a>
80101337:	c7 04 24 05 6f 10 80 	movl   $0x80106f05,(%esp)
8010133e:	e8 1d f0 ff ff       	call   80100360 <panic>
80101343:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101349:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101350 <readsb>:
80101350:	55                   	push   %ebp
80101351:	89 e5                	mov    %esp,%ebp
80101353:	56                   	push   %esi
80101354:	53                   	push   %ebx
80101355:	83 ec 10             	sub    $0x10,%esp
80101358:	8b 45 08             	mov    0x8(%ebp),%eax
8010135b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80101362:	00 
80101363:	8b 75 0c             	mov    0xc(%ebp),%esi
80101366:	89 04 24             	mov    %eax,(%esp)
80101369:	e8 62 ed ff ff       	call   801000d0 <bread>
8010136e:	89 34 24             	mov    %esi,(%esp)
80101371:	c7 44 24 08 1c 00 00 	movl   $0x1c,0x8(%esp)
80101378:	00 
80101379:	89 c3                	mov    %eax,%ebx
8010137b:	8d 40 5c             	lea    0x5c(%eax),%eax
8010137e:	89 44 24 04          	mov    %eax,0x4(%esp)
80101382:	e8 89 2f 00 00       	call   80104310 <memmove>
80101387:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010138a:	83 c4 10             	add    $0x10,%esp
8010138d:	5b                   	pop    %ebx
8010138e:	5e                   	pop    %esi
8010138f:	5d                   	pop    %ebp
80101390:	e9 4b ee ff ff       	jmp    801001e0 <brelse>
80101395:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101399:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801013a0 <bfree>:
801013a0:	55                   	push   %ebp
801013a1:	89 e5                	mov    %esp,%ebp
801013a3:	57                   	push   %edi
801013a4:	89 d7                	mov    %edx,%edi
801013a6:	56                   	push   %esi
801013a7:	53                   	push   %ebx
801013a8:	89 c3                	mov    %eax,%ebx
801013aa:	83 ec 1c             	sub    $0x1c,%esp
801013ad:	89 04 24             	mov    %eax,(%esp)
801013b0:	c7 44 24 04 c0 09 11 	movl   $0x801109c0,0x4(%esp)
801013b7:	80 
801013b8:	e8 93 ff ff ff       	call   80101350 <readsb>
801013bd:	89 fa                	mov    %edi,%edx
801013bf:	c1 ea 0c             	shr    $0xc,%edx
801013c2:	03 15 d8 09 11 80    	add    0x801109d8,%edx
801013c8:	89 1c 24             	mov    %ebx,(%esp)
801013cb:	bb 01 00 00 00       	mov    $0x1,%ebx
801013d0:	89 54 24 04          	mov    %edx,0x4(%esp)
801013d4:	e8 f7 ec ff ff       	call   801000d0 <bread>
801013d9:	89 f9                	mov    %edi,%ecx
801013db:	81 e7 ff 0f 00 00    	and    $0xfff,%edi
801013e1:	89 fa                	mov    %edi,%edx
801013e3:	83 e1 07             	and    $0x7,%ecx
801013e6:	c1 fa 03             	sar    $0x3,%edx
801013e9:	d3 e3                	shl    %cl,%ebx
801013eb:	89 c6                	mov    %eax,%esi
801013ed:	0f b6 44 10 5c       	movzbl 0x5c(%eax,%edx,1),%eax
801013f2:	0f b6 c8             	movzbl %al,%ecx
801013f5:	85 d9                	test   %ebx,%ecx
801013f7:	74 20                	je     80101419 <bfree+0x79>
801013f9:	f7 d3                	not    %ebx
801013fb:	21 c3                	and    %eax,%ebx
801013fd:	88 5c 16 5c          	mov    %bl,0x5c(%esi,%edx,1)
80101401:	89 34 24             	mov    %esi,(%esp)
80101404:	e8 57 18 00 00       	call   80102c60 <log_write>
80101409:	89 34 24             	mov    %esi,(%esp)
8010140c:	e8 cf ed ff ff       	call   801001e0 <brelse>
80101411:	83 c4 1c             	add    $0x1c,%esp
80101414:	5b                   	pop    %ebx
80101415:	5e                   	pop    %esi
80101416:	5f                   	pop    %edi
80101417:	5d                   	pop    %ebp
80101418:	c3                   	ret    
80101419:	c7 04 24 18 6f 10 80 	movl   $0x80106f18,(%esp)
80101420:	e8 3b ef ff ff       	call   80100360 <panic>
80101425:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101429:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101430 <iinit>:
80101430:	55                   	push   %ebp
80101431:	89 e5                	mov    %esp,%ebp
80101433:	53                   	push   %ebx
80101434:	bb 20 0a 11 80       	mov    $0x80110a20,%ebx
80101439:	83 ec 24             	sub    $0x24,%esp
8010143c:	c7 44 24 04 2b 6f 10 	movl   $0x80106f2b,0x4(%esp)
80101443:	80 
80101444:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010144b:	e8 f0 2b 00 00       	call   80104040 <initlock>
80101450:	89 1c 24             	mov    %ebx,(%esp)
80101453:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101459:	c7 44 24 04 32 6f 10 	movl   $0x80106f32,0x4(%esp)
80101460:	80 
80101461:	e8 ca 2a 00 00       	call   80103f30 <initsleeplock>
80101466:	81 fb 40 26 11 80    	cmp    $0x80112640,%ebx
8010146c:	75 e2                	jne    80101450 <iinit+0x20>
8010146e:	8b 45 08             	mov    0x8(%ebp),%eax
80101471:	c7 44 24 04 c0 09 11 	movl   $0x801109c0,0x4(%esp)
80101478:	80 
80101479:	89 04 24             	mov    %eax,(%esp)
8010147c:	e8 cf fe ff ff       	call   80101350 <readsb>
80101481:	a1 d8 09 11 80       	mov    0x801109d8,%eax
80101486:	c7 04 24 98 6f 10 80 	movl   $0x80106f98,(%esp)
8010148d:	89 44 24 1c          	mov    %eax,0x1c(%esp)
80101491:	a1 d4 09 11 80       	mov    0x801109d4,%eax
80101496:	89 44 24 18          	mov    %eax,0x18(%esp)
8010149a:	a1 d0 09 11 80       	mov    0x801109d0,%eax
8010149f:	89 44 24 14          	mov    %eax,0x14(%esp)
801014a3:	a1 cc 09 11 80       	mov    0x801109cc,%eax
801014a8:	89 44 24 10          	mov    %eax,0x10(%esp)
801014ac:	a1 c8 09 11 80       	mov    0x801109c8,%eax
801014b1:	89 44 24 0c          	mov    %eax,0xc(%esp)
801014b5:	a1 c4 09 11 80       	mov    0x801109c4,%eax
801014ba:	89 44 24 08          	mov    %eax,0x8(%esp)
801014be:	a1 c0 09 11 80       	mov    0x801109c0,%eax
801014c3:	89 44 24 04          	mov    %eax,0x4(%esp)
801014c7:	e8 84 f1 ff ff       	call   80100650 <cprintf>
801014cc:	83 c4 24             	add    $0x24,%esp
801014cf:	5b                   	pop    %ebx
801014d0:	5d                   	pop    %ebp
801014d1:	c3                   	ret    
801014d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801014d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801014e0 <ialloc>:
801014e0:	55                   	push   %ebp
801014e1:	89 e5                	mov    %esp,%ebp
801014e3:	57                   	push   %edi
801014e4:	56                   	push   %esi
801014e5:	53                   	push   %ebx
801014e6:	83 ec 2c             	sub    $0x2c,%esp
801014e9:	8b 45 0c             	mov    0xc(%ebp),%eax
801014ec:	83 3d c8 09 11 80 01 	cmpl   $0x1,0x801109c8
801014f3:	8b 7d 08             	mov    0x8(%ebp),%edi
801014f6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801014f9:	0f 86 a2 00 00 00    	jbe    801015a1 <ialloc+0xc1>
801014ff:	be 01 00 00 00       	mov    $0x1,%esi
80101504:	bb 01 00 00 00       	mov    $0x1,%ebx
80101509:	eb 1a                	jmp    80101525 <ialloc+0x45>
8010150b:	90                   	nop
8010150c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101510:	89 14 24             	mov    %edx,(%esp)
80101513:	83 c3 01             	add    $0x1,%ebx
80101516:	e8 c5 ec ff ff       	call   801001e0 <brelse>
8010151b:	89 de                	mov    %ebx,%esi
8010151d:	3b 1d c8 09 11 80    	cmp    0x801109c8,%ebx
80101523:	73 7c                	jae    801015a1 <ialloc+0xc1>
80101525:	89 f0                	mov    %esi,%eax
80101527:	c1 e8 03             	shr    $0x3,%eax
8010152a:	03 05 d4 09 11 80    	add    0x801109d4,%eax
80101530:	89 3c 24             	mov    %edi,(%esp)
80101533:	89 44 24 04          	mov    %eax,0x4(%esp)
80101537:	e8 94 eb ff ff       	call   801000d0 <bread>
8010153c:	89 c2                	mov    %eax,%edx
8010153e:	89 f0                	mov    %esi,%eax
80101540:	83 e0 07             	and    $0x7,%eax
80101543:	c1 e0 06             	shl    $0x6,%eax
80101546:	8d 4c 02 5c          	lea    0x5c(%edx,%eax,1),%ecx
8010154a:	66 83 39 00          	cmpw   $0x0,(%ecx)
8010154e:	75 c0                	jne    80101510 <ialloc+0x30>
80101550:	89 0c 24             	mov    %ecx,(%esp)
80101553:	c7 44 24 08 40 00 00 	movl   $0x40,0x8(%esp)
8010155a:	00 
8010155b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80101562:	00 
80101563:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101566:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101569:	e8 02 2d 00 00       	call   80104270 <memset>
8010156e:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101572:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101575:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101578:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010157b:	66 89 01             	mov    %ax,(%ecx)
8010157e:	89 14 24             	mov    %edx,(%esp)
80101581:	e8 da 16 00 00       	call   80102c60 <log_write>
80101586:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101589:	89 14 24             	mov    %edx,(%esp)
8010158c:	e8 4f ec ff ff       	call   801001e0 <brelse>
80101591:	83 c4 2c             	add    $0x2c,%esp
80101594:	89 f2                	mov    %esi,%edx
80101596:	5b                   	pop    %ebx
80101597:	89 f8                	mov    %edi,%eax
80101599:	5e                   	pop    %esi
8010159a:	5f                   	pop    %edi
8010159b:	5d                   	pop    %ebp
8010159c:	e9 2f fc ff ff       	jmp    801011d0 <iget>
801015a1:	c7 04 24 38 6f 10 80 	movl   $0x80106f38,(%esp)
801015a8:	e8 b3 ed ff ff       	call   80100360 <panic>
801015ad:	8d 76 00             	lea    0x0(%esi),%esi

801015b0 <iupdate>:
801015b0:	55                   	push   %ebp
801015b1:	89 e5                	mov    %esp,%ebp
801015b3:	56                   	push   %esi
801015b4:	53                   	push   %ebx
801015b5:	83 ec 10             	sub    $0x10,%esp
801015b8:	8b 5d 08             	mov    0x8(%ebp),%ebx
801015bb:	8b 43 04             	mov    0x4(%ebx),%eax
801015be:	83 c3 5c             	add    $0x5c,%ebx
801015c1:	c1 e8 03             	shr    $0x3,%eax
801015c4:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801015ca:	89 44 24 04          	mov    %eax,0x4(%esp)
801015ce:	8b 43 a4             	mov    -0x5c(%ebx),%eax
801015d1:	89 04 24             	mov    %eax,(%esp)
801015d4:	e8 f7 ea ff ff       	call   801000d0 <bread>
801015d9:	8b 53 a8             	mov    -0x58(%ebx),%edx
801015dc:	83 e2 07             	and    $0x7,%edx
801015df:	c1 e2 06             	shl    $0x6,%edx
801015e2:	8d 54 10 5c          	lea    0x5c(%eax,%edx,1),%edx
801015e6:	89 c6                	mov    %eax,%esi
801015e8:	0f b7 43 f4          	movzwl -0xc(%ebx),%eax
801015ec:	83 c2 0c             	add    $0xc,%edx
801015ef:	66 89 42 f4          	mov    %ax,-0xc(%edx)
801015f3:	0f b7 43 f6          	movzwl -0xa(%ebx),%eax
801015f7:	66 89 42 f6          	mov    %ax,-0xa(%edx)
801015fb:	0f b7 43 f8          	movzwl -0x8(%ebx),%eax
801015ff:	66 89 42 f8          	mov    %ax,-0x8(%edx)
80101603:	0f b7 43 fa          	movzwl -0x6(%ebx),%eax
80101607:	66 89 42 fa          	mov    %ax,-0x6(%edx)
8010160b:	8b 43 fc             	mov    -0x4(%ebx),%eax
8010160e:	89 42 fc             	mov    %eax,-0x4(%edx)
80101611:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101615:	89 14 24             	mov    %edx,(%esp)
80101618:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
8010161f:	00 
80101620:	e8 eb 2c 00 00       	call   80104310 <memmove>
80101625:	89 34 24             	mov    %esi,(%esp)
80101628:	e8 33 16 00 00       	call   80102c60 <log_write>
8010162d:	89 75 08             	mov    %esi,0x8(%ebp)
80101630:	83 c4 10             	add    $0x10,%esp
80101633:	5b                   	pop    %ebx
80101634:	5e                   	pop    %esi
80101635:	5d                   	pop    %ebp
80101636:	e9 a5 eb ff ff       	jmp    801001e0 <brelse>
8010163b:	90                   	nop
8010163c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101640 <idup>:
80101640:	55                   	push   %ebp
80101641:	89 e5                	mov    %esp,%ebp
80101643:	53                   	push   %ebx
80101644:	83 ec 14             	sub    $0x14,%esp
80101647:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010164a:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101651:	e8 da 2a 00 00       	call   80104130 <acquire>
80101656:	83 43 08 01          	addl   $0x1,0x8(%ebx)
8010165a:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101661:	e8 ba 2b 00 00       	call   80104220 <release>
80101666:	83 c4 14             	add    $0x14,%esp
80101669:	89 d8                	mov    %ebx,%eax
8010166b:	5b                   	pop    %ebx
8010166c:	5d                   	pop    %ebp
8010166d:	c3                   	ret    
8010166e:	66 90                	xchg   %ax,%ax

80101670 <ilock>:
80101670:	55                   	push   %ebp
80101671:	89 e5                	mov    %esp,%ebp
80101673:	56                   	push   %esi
80101674:	53                   	push   %ebx
80101675:	83 ec 10             	sub    $0x10,%esp
80101678:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010167b:	85 db                	test   %ebx,%ebx
8010167d:	0f 84 b3 00 00 00    	je     80101736 <ilock+0xc6>
80101683:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101686:	85 c9                	test   %ecx,%ecx
80101688:	0f 8e a8 00 00 00    	jle    80101736 <ilock+0xc6>
8010168e:	8d 43 0c             	lea    0xc(%ebx),%eax
80101691:	89 04 24             	mov    %eax,(%esp)
80101694:	e8 d7 28 00 00       	call   80103f70 <acquiresleep>
80101699:	8b 53 4c             	mov    0x4c(%ebx),%edx
8010169c:	85 d2                	test   %edx,%edx
8010169e:	74 08                	je     801016a8 <ilock+0x38>
801016a0:	83 c4 10             	add    $0x10,%esp
801016a3:	5b                   	pop    %ebx
801016a4:	5e                   	pop    %esi
801016a5:	5d                   	pop    %ebp
801016a6:	c3                   	ret    
801016a7:	90                   	nop
801016a8:	8b 43 04             	mov    0x4(%ebx),%eax
801016ab:	c1 e8 03             	shr    $0x3,%eax
801016ae:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801016b4:	89 44 24 04          	mov    %eax,0x4(%esp)
801016b8:	8b 03                	mov    (%ebx),%eax
801016ba:	89 04 24             	mov    %eax,(%esp)
801016bd:	e8 0e ea ff ff       	call   801000d0 <bread>
801016c2:	8b 53 04             	mov    0x4(%ebx),%edx
801016c5:	83 e2 07             	and    $0x7,%edx
801016c8:	c1 e2 06             	shl    $0x6,%edx
801016cb:	8d 54 10 5c          	lea    0x5c(%eax,%edx,1),%edx
801016cf:	89 c6                	mov    %eax,%esi
801016d1:	0f b7 02             	movzwl (%edx),%eax
801016d4:	83 c2 0c             	add    $0xc,%edx
801016d7:	66 89 43 50          	mov    %ax,0x50(%ebx)
801016db:	0f b7 42 f6          	movzwl -0xa(%edx),%eax
801016df:	66 89 43 52          	mov    %ax,0x52(%ebx)
801016e3:	0f b7 42 f8          	movzwl -0x8(%edx),%eax
801016e7:	66 89 43 54          	mov    %ax,0x54(%ebx)
801016eb:	0f b7 42 fa          	movzwl -0x6(%edx),%eax
801016ef:	66 89 43 56          	mov    %ax,0x56(%ebx)
801016f3:	8b 42 fc             	mov    -0x4(%edx),%eax
801016f6:	89 43 58             	mov    %eax,0x58(%ebx)
801016f9:	8d 43 5c             	lea    0x5c(%ebx),%eax
801016fc:	89 54 24 04          	mov    %edx,0x4(%esp)
80101700:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
80101707:	00 
80101708:	89 04 24             	mov    %eax,(%esp)
8010170b:	e8 00 2c 00 00       	call   80104310 <memmove>
80101710:	89 34 24             	mov    %esi,(%esp)
80101713:	e8 c8 ea ff ff       	call   801001e0 <brelse>
80101718:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
8010171d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
80101724:	0f 85 76 ff ff ff    	jne    801016a0 <ilock+0x30>
8010172a:	c7 04 24 50 6f 10 80 	movl   $0x80106f50,(%esp)
80101731:	e8 2a ec ff ff       	call   80100360 <panic>
80101736:	c7 04 24 4a 6f 10 80 	movl   $0x80106f4a,(%esp)
8010173d:	e8 1e ec ff ff       	call   80100360 <panic>
80101742:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101749:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101750 <iunlock>:
80101750:	55                   	push   %ebp
80101751:	89 e5                	mov    %esp,%ebp
80101753:	56                   	push   %esi
80101754:	53                   	push   %ebx
80101755:	83 ec 10             	sub    $0x10,%esp
80101758:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010175b:	85 db                	test   %ebx,%ebx
8010175d:	74 24                	je     80101783 <iunlock+0x33>
8010175f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101762:	89 34 24             	mov    %esi,(%esp)
80101765:	e8 a6 28 00 00       	call   80104010 <holdingsleep>
8010176a:	85 c0                	test   %eax,%eax
8010176c:	74 15                	je     80101783 <iunlock+0x33>
8010176e:	8b 5b 08             	mov    0x8(%ebx),%ebx
80101771:	85 db                	test   %ebx,%ebx
80101773:	7e 0e                	jle    80101783 <iunlock+0x33>
80101775:	89 75 08             	mov    %esi,0x8(%ebp)
80101778:	83 c4 10             	add    $0x10,%esp
8010177b:	5b                   	pop    %ebx
8010177c:	5e                   	pop    %esi
8010177d:	5d                   	pop    %ebp
8010177e:	e9 4d 28 00 00       	jmp    80103fd0 <releasesleep>
80101783:	c7 04 24 5f 6f 10 80 	movl   $0x80106f5f,(%esp)
8010178a:	e8 d1 eb ff ff       	call   80100360 <panic>
8010178f:	90                   	nop

80101790 <iput>:
80101790:	55                   	push   %ebp
80101791:	89 e5                	mov    %esp,%ebp
80101793:	57                   	push   %edi
80101794:	56                   	push   %esi
80101795:	53                   	push   %ebx
80101796:	83 ec 1c             	sub    $0x1c,%esp
80101799:	8b 75 08             	mov    0x8(%ebp),%esi
8010179c:	8d 7e 0c             	lea    0xc(%esi),%edi
8010179f:	89 3c 24             	mov    %edi,(%esp)
801017a2:	e8 c9 27 00 00       	call   80103f70 <acquiresleep>
801017a7:	8b 46 4c             	mov    0x4c(%esi),%eax
801017aa:	85 c0                	test   %eax,%eax
801017ac:	74 07                	je     801017b5 <iput+0x25>
801017ae:	66 83 7e 56 00       	cmpw   $0x0,0x56(%esi)
801017b3:	74 2b                	je     801017e0 <iput+0x50>
801017b5:	89 3c 24             	mov    %edi,(%esp)
801017b8:	e8 13 28 00 00       	call   80103fd0 <releasesleep>
801017bd:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801017c4:	e8 67 29 00 00       	call   80104130 <acquire>
801017c9:	83 6e 08 01          	subl   $0x1,0x8(%esi)
801017cd:	c7 45 08 e0 09 11 80 	movl   $0x801109e0,0x8(%ebp)
801017d4:	83 c4 1c             	add    $0x1c,%esp
801017d7:	5b                   	pop    %ebx
801017d8:	5e                   	pop    %esi
801017d9:	5f                   	pop    %edi
801017da:	5d                   	pop    %ebp
801017db:	e9 40 2a 00 00       	jmp    80104220 <release>
801017e0:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801017e7:	e8 44 29 00 00       	call   80104130 <acquire>
801017ec:	8b 5e 08             	mov    0x8(%esi),%ebx
801017ef:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801017f6:	e8 25 2a 00 00       	call   80104220 <release>
801017fb:	83 fb 01             	cmp    $0x1,%ebx
801017fe:	75 b5                	jne    801017b5 <iput+0x25>
80101800:	8d 4e 30             	lea    0x30(%esi),%ecx
80101803:	89 f3                	mov    %esi,%ebx
80101805:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101808:	89 cf                	mov    %ecx,%edi
8010180a:	eb 0b                	jmp    80101817 <iput+0x87>
8010180c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101810:	83 c3 04             	add    $0x4,%ebx
80101813:	39 fb                	cmp    %edi,%ebx
80101815:	74 19                	je     80101830 <iput+0xa0>
80101817:	8b 53 5c             	mov    0x5c(%ebx),%edx
8010181a:	85 d2                	test   %edx,%edx
8010181c:	74 f2                	je     80101810 <iput+0x80>
8010181e:	8b 06                	mov    (%esi),%eax
80101820:	e8 7b fb ff ff       	call   801013a0 <bfree>
80101825:	c7 43 5c 00 00 00 00 	movl   $0x0,0x5c(%ebx)
8010182c:	eb e2                	jmp    80101810 <iput+0x80>
8010182e:	66 90                	xchg   %ax,%ax
80101830:	8b 86 8c 00 00 00    	mov    0x8c(%esi),%eax
80101836:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101839:	85 c0                	test   %eax,%eax
8010183b:	75 2b                	jne    80101868 <iput+0xd8>
8010183d:	c7 46 58 00 00 00 00 	movl   $0x0,0x58(%esi)
80101844:	89 34 24             	mov    %esi,(%esp)
80101847:	e8 64 fd ff ff       	call   801015b0 <iupdate>
8010184c:	31 c0                	xor    %eax,%eax
8010184e:	66 89 46 50          	mov    %ax,0x50(%esi)
80101852:	89 34 24             	mov    %esi,(%esp)
80101855:	e8 56 fd ff ff       	call   801015b0 <iupdate>
8010185a:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
80101861:	e9 4f ff ff ff       	jmp    801017b5 <iput+0x25>
80101866:	66 90                	xchg   %ax,%ax
80101868:	89 44 24 04          	mov    %eax,0x4(%esp)
8010186c:	8b 06                	mov    (%esi),%eax
8010186e:	31 db                	xor    %ebx,%ebx
80101870:	89 04 24             	mov    %eax,(%esp)
80101873:	e8 58 e8 ff ff       	call   801000d0 <bread>
80101878:	89 7d e0             	mov    %edi,-0x20(%ebp)
8010187b:	8d 48 5c             	lea    0x5c(%eax),%ecx
8010187e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101881:	89 cf                	mov    %ecx,%edi
80101883:	31 c0                	xor    %eax,%eax
80101885:	eb 0e                	jmp    80101895 <iput+0x105>
80101887:	90                   	nop
80101888:	83 c3 01             	add    $0x1,%ebx
8010188b:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
80101891:	89 d8                	mov    %ebx,%eax
80101893:	74 10                	je     801018a5 <iput+0x115>
80101895:	8b 14 87             	mov    (%edi,%eax,4),%edx
80101898:	85 d2                	test   %edx,%edx
8010189a:	74 ec                	je     80101888 <iput+0xf8>
8010189c:	8b 06                	mov    (%esi),%eax
8010189e:	e8 fd fa ff ff       	call   801013a0 <bfree>
801018a3:	eb e3                	jmp    80101888 <iput+0xf8>
801018a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801018a8:	8b 7d e0             	mov    -0x20(%ebp),%edi
801018ab:	89 04 24             	mov    %eax,(%esp)
801018ae:	e8 2d e9 ff ff       	call   801001e0 <brelse>
801018b3:	8b 96 8c 00 00 00    	mov    0x8c(%esi),%edx
801018b9:	8b 06                	mov    (%esi),%eax
801018bb:	e8 e0 fa ff ff       	call   801013a0 <bfree>
801018c0:	c7 86 8c 00 00 00 00 	movl   $0x0,0x8c(%esi)
801018c7:	00 00 00 
801018ca:	e9 6e ff ff ff       	jmp    8010183d <iput+0xad>
801018cf:	90                   	nop

801018d0 <iunlockput>:
801018d0:	55                   	push   %ebp
801018d1:	89 e5                	mov    %esp,%ebp
801018d3:	53                   	push   %ebx
801018d4:	83 ec 14             	sub    $0x14,%esp
801018d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
801018da:	89 1c 24             	mov    %ebx,(%esp)
801018dd:	e8 6e fe ff ff       	call   80101750 <iunlock>
801018e2:	89 5d 08             	mov    %ebx,0x8(%ebp)
801018e5:	83 c4 14             	add    $0x14,%esp
801018e8:	5b                   	pop    %ebx
801018e9:	5d                   	pop    %ebp
801018ea:	e9 a1 fe ff ff       	jmp    80101790 <iput>
801018ef:	90                   	nop

801018f0 <stati>:
801018f0:	55                   	push   %ebp
801018f1:	89 e5                	mov    %esp,%ebp
801018f3:	8b 55 08             	mov    0x8(%ebp),%edx
801018f6:	8b 45 0c             	mov    0xc(%ebp),%eax
801018f9:	8b 0a                	mov    (%edx),%ecx
801018fb:	89 48 04             	mov    %ecx,0x4(%eax)
801018fe:	8b 4a 04             	mov    0x4(%edx),%ecx
80101901:	89 48 08             	mov    %ecx,0x8(%eax)
80101904:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101908:	66 89 08             	mov    %cx,(%eax)
8010190b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010190f:	66 89 48 0c          	mov    %cx,0xc(%eax)
80101913:	8b 52 58             	mov    0x58(%edx),%edx
80101916:	89 50 10             	mov    %edx,0x10(%eax)
80101919:	5d                   	pop    %ebp
8010191a:	c3                   	ret    
8010191b:	90                   	nop
8010191c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101920 <readi>:
80101920:	55                   	push   %ebp
80101921:	89 e5                	mov    %esp,%ebp
80101923:	57                   	push   %edi
80101924:	56                   	push   %esi
80101925:	53                   	push   %ebx
80101926:	83 ec 2c             	sub    $0x2c,%esp
80101929:	8b 45 0c             	mov    0xc(%ebp),%eax
8010192c:	8b 7d 08             	mov    0x8(%ebp),%edi
8010192f:	8b 75 10             	mov    0x10(%ebp),%esi
80101932:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101935:	8b 45 14             	mov    0x14(%ebp),%eax
80101938:	66 83 7f 50 03       	cmpw   $0x3,0x50(%edi)
8010193d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101940:	0f 84 aa 00 00 00    	je     801019f0 <readi+0xd0>
80101946:	8b 47 58             	mov    0x58(%edi),%eax
80101949:	39 f0                	cmp    %esi,%eax
8010194b:	0f 82 c7 00 00 00    	jb     80101a18 <readi+0xf8>
80101951:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101954:	89 da                	mov    %ebx,%edx
80101956:	01 f2                	add    %esi,%edx
80101958:	0f 82 ba 00 00 00    	jb     80101a18 <readi+0xf8>
8010195e:	89 c1                	mov    %eax,%ecx
80101960:	29 f1                	sub    %esi,%ecx
80101962:	39 d0                	cmp    %edx,%eax
80101964:	0f 43 cb             	cmovae %ebx,%ecx
80101967:	31 c0                	xor    %eax,%eax
80101969:	85 c9                	test   %ecx,%ecx
8010196b:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010196e:	74 70                	je     801019e0 <readi+0xc0>
80101970:	89 7d d8             	mov    %edi,-0x28(%ebp)
80101973:	89 c7                	mov    %eax,%edi
80101975:	8d 76 00             	lea    0x0(%esi),%esi
80101978:	8b 5d d8             	mov    -0x28(%ebp),%ebx
8010197b:	89 f2                	mov    %esi,%edx
8010197d:	c1 ea 09             	shr    $0x9,%edx
80101980:	89 d8                	mov    %ebx,%eax
80101982:	e8 09 f9 ff ff       	call   80101290 <bmap>
80101987:	89 44 24 04          	mov    %eax,0x4(%esp)
8010198b:	8b 03                	mov    (%ebx),%eax
8010198d:	bb 00 02 00 00       	mov    $0x200,%ebx
80101992:	89 04 24             	mov    %eax,(%esp)
80101995:	e8 36 e7 ff ff       	call   801000d0 <bread>
8010199a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010199d:	29 f9                	sub    %edi,%ecx
8010199f:	89 c2                	mov    %eax,%edx
801019a1:	89 f0                	mov    %esi,%eax
801019a3:	25 ff 01 00 00       	and    $0x1ff,%eax
801019a8:	29 c3                	sub    %eax,%ebx
801019aa:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
801019ae:	39 cb                	cmp    %ecx,%ebx
801019b0:	89 44 24 04          	mov    %eax,0x4(%esp)
801019b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
801019b7:	0f 47 d9             	cmova  %ecx,%ebx
801019ba:	89 5c 24 08          	mov    %ebx,0x8(%esp)
801019be:	01 df                	add    %ebx,%edi
801019c0:	01 de                	add    %ebx,%esi
801019c2:	89 55 dc             	mov    %edx,-0x24(%ebp)
801019c5:	89 04 24             	mov    %eax,(%esp)
801019c8:	e8 43 29 00 00       	call   80104310 <memmove>
801019cd:	8b 55 dc             	mov    -0x24(%ebp),%edx
801019d0:	89 14 24             	mov    %edx,(%esp)
801019d3:	e8 08 e8 ff ff       	call   801001e0 <brelse>
801019d8:	01 5d e0             	add    %ebx,-0x20(%ebp)
801019db:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801019de:	77 98                	ja     80101978 <readi+0x58>
801019e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801019e3:	83 c4 2c             	add    $0x2c,%esp
801019e6:	5b                   	pop    %ebx
801019e7:	5e                   	pop    %esi
801019e8:	5f                   	pop    %edi
801019e9:	5d                   	pop    %ebp
801019ea:	c3                   	ret    
801019eb:	90                   	nop
801019ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801019f0:	0f bf 47 52          	movswl 0x52(%edi),%eax
801019f4:	66 83 f8 09          	cmp    $0x9,%ax
801019f8:	77 1e                	ja     80101a18 <readi+0xf8>
801019fa:	8b 04 c5 60 09 11 80 	mov    -0x7feef6a0(,%eax,8),%eax
80101a01:	85 c0                	test   %eax,%eax
80101a03:	74 13                	je     80101a18 <readi+0xf8>
80101a05:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101a08:	89 75 10             	mov    %esi,0x10(%ebp)
80101a0b:	83 c4 2c             	add    $0x2c,%esp
80101a0e:	5b                   	pop    %ebx
80101a0f:	5e                   	pop    %esi
80101a10:	5f                   	pop    %edi
80101a11:	5d                   	pop    %ebp
80101a12:	ff e0                	jmp    *%eax
80101a14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101a18:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a1d:	eb c4                	jmp    801019e3 <readi+0xc3>
80101a1f:	90                   	nop

80101a20 <writei>:
80101a20:	55                   	push   %ebp
80101a21:	89 e5                	mov    %esp,%ebp
80101a23:	57                   	push   %edi
80101a24:	56                   	push   %esi
80101a25:	53                   	push   %ebx
80101a26:	83 ec 2c             	sub    $0x2c,%esp
80101a29:	8b 45 08             	mov    0x8(%ebp),%eax
80101a2c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101a2f:	8b 4d 14             	mov    0x14(%ebp),%ecx
80101a32:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
80101a37:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101a3a:	8b 75 10             	mov    0x10(%ebp),%esi
80101a3d:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a40:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101a43:	0f 84 b7 00 00 00    	je     80101b00 <writei+0xe0>
80101a49:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a4c:	39 70 58             	cmp    %esi,0x58(%eax)
80101a4f:	0f 82 e3 00 00 00    	jb     80101b38 <writei+0x118>
80101a55:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101a58:	89 c8                	mov    %ecx,%eax
80101a5a:	01 f0                	add    %esi,%eax
80101a5c:	0f 82 d6 00 00 00    	jb     80101b38 <writei+0x118>
80101a62:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101a67:	0f 87 cb 00 00 00    	ja     80101b38 <writei+0x118>
80101a6d:	85 c9                	test   %ecx,%ecx
80101a6f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101a76:	74 77                	je     80101aef <writei+0xcf>
80101a78:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101a7b:	89 f2                	mov    %esi,%edx
80101a7d:	bb 00 02 00 00       	mov    $0x200,%ebx
80101a82:	c1 ea 09             	shr    $0x9,%edx
80101a85:	89 f8                	mov    %edi,%eax
80101a87:	e8 04 f8 ff ff       	call   80101290 <bmap>
80101a8c:	89 44 24 04          	mov    %eax,0x4(%esp)
80101a90:	8b 07                	mov    (%edi),%eax
80101a92:	89 04 24             	mov    %eax,(%esp)
80101a95:	e8 36 e6 ff ff       	call   801000d0 <bread>
80101a9a:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101a9d:	2b 4d e4             	sub    -0x1c(%ebp),%ecx
80101aa0:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101aa3:	89 c7                	mov    %eax,%edi
80101aa5:	89 f0                	mov    %esi,%eax
80101aa7:	25 ff 01 00 00       	and    $0x1ff,%eax
80101aac:	29 c3                	sub    %eax,%ebx
80101aae:	39 cb                	cmp    %ecx,%ebx
80101ab0:	0f 47 d9             	cmova  %ecx,%ebx
80101ab3:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
80101ab7:	01 de                	add    %ebx,%esi
80101ab9:	89 54 24 04          	mov    %edx,0x4(%esp)
80101abd:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80101ac1:	89 04 24             	mov    %eax,(%esp)
80101ac4:	e8 47 28 00 00       	call   80104310 <memmove>
80101ac9:	89 3c 24             	mov    %edi,(%esp)
80101acc:	e8 8f 11 00 00       	call   80102c60 <log_write>
80101ad1:	89 3c 24             	mov    %edi,(%esp)
80101ad4:	e8 07 e7 ff ff       	call   801001e0 <brelse>
80101ad9:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101adc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101adf:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101ae2:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101ae5:	77 91                	ja     80101a78 <writei+0x58>
80101ae7:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101aea:	39 70 58             	cmp    %esi,0x58(%eax)
80101aed:	72 39                	jb     80101b28 <writei+0x108>
80101aef:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101af2:	83 c4 2c             	add    $0x2c,%esp
80101af5:	5b                   	pop    %ebx
80101af6:	5e                   	pop    %esi
80101af7:	5f                   	pop    %edi
80101af8:	5d                   	pop    %ebp
80101af9:	c3                   	ret    
80101afa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101b00:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b04:	66 83 f8 09          	cmp    $0x9,%ax
80101b08:	77 2e                	ja     80101b38 <writei+0x118>
80101b0a:	8b 04 c5 64 09 11 80 	mov    -0x7feef69c(,%eax,8),%eax
80101b11:	85 c0                	test   %eax,%eax
80101b13:	74 23                	je     80101b38 <writei+0x118>
80101b15:	89 4d 10             	mov    %ecx,0x10(%ebp)
80101b18:	83 c4 2c             	add    $0x2c,%esp
80101b1b:	5b                   	pop    %ebx
80101b1c:	5e                   	pop    %esi
80101b1d:	5f                   	pop    %edi
80101b1e:	5d                   	pop    %ebp
80101b1f:	ff e0                	jmp    *%eax
80101b21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b28:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b2b:	89 70 58             	mov    %esi,0x58(%eax)
80101b2e:	89 04 24             	mov    %eax,(%esp)
80101b31:	e8 7a fa ff ff       	call   801015b0 <iupdate>
80101b36:	eb b7                	jmp    80101aef <writei+0xcf>
80101b38:	83 c4 2c             	add    $0x2c,%esp
80101b3b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b40:	5b                   	pop    %ebx
80101b41:	5e                   	pop    %esi
80101b42:	5f                   	pop    %edi
80101b43:	5d                   	pop    %ebp
80101b44:	c3                   	ret    
80101b45:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101b49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101b50 <namecmp>:
80101b50:	55                   	push   %ebp
80101b51:	89 e5                	mov    %esp,%ebp
80101b53:	83 ec 18             	sub    $0x18,%esp
80101b56:	8b 45 0c             	mov    0xc(%ebp),%eax
80101b59:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101b60:	00 
80101b61:	89 44 24 04          	mov    %eax,0x4(%esp)
80101b65:	8b 45 08             	mov    0x8(%ebp),%eax
80101b68:	89 04 24             	mov    %eax,(%esp)
80101b6b:	e8 20 28 00 00       	call   80104390 <strncmp>
80101b70:	c9                   	leave  
80101b71:	c3                   	ret    
80101b72:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101b80 <dirlookup>:
80101b80:	55                   	push   %ebp
80101b81:	89 e5                	mov    %esp,%ebp
80101b83:	57                   	push   %edi
80101b84:	56                   	push   %esi
80101b85:	53                   	push   %ebx
80101b86:	83 ec 2c             	sub    $0x2c,%esp
80101b89:	8b 5d 08             	mov    0x8(%ebp),%ebx
80101b8c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101b91:	0f 85 97 00 00 00    	jne    80101c2e <dirlookup+0xae>
80101b97:	8b 43 58             	mov    0x58(%ebx),%eax
80101b9a:	31 ff                	xor    %edi,%edi
80101b9c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101b9f:	85 c0                	test   %eax,%eax
80101ba1:	75 0d                	jne    80101bb0 <dirlookup+0x30>
80101ba3:	eb 73                	jmp    80101c18 <dirlookup+0x98>
80101ba5:	8d 76 00             	lea    0x0(%esi),%esi
80101ba8:	83 c7 10             	add    $0x10,%edi
80101bab:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101bae:	76 68                	jbe    80101c18 <dirlookup+0x98>
80101bb0:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101bb7:	00 
80101bb8:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101bbc:	89 74 24 04          	mov    %esi,0x4(%esp)
80101bc0:	89 1c 24             	mov    %ebx,(%esp)
80101bc3:	e8 58 fd ff ff       	call   80101920 <readi>
80101bc8:	83 f8 10             	cmp    $0x10,%eax
80101bcb:	75 55                	jne    80101c22 <dirlookup+0xa2>
80101bcd:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101bd2:	74 d4                	je     80101ba8 <dirlookup+0x28>
80101bd4:	8d 45 da             	lea    -0x26(%ebp),%eax
80101bd7:	89 44 24 04          	mov    %eax,0x4(%esp)
80101bdb:	8b 45 0c             	mov    0xc(%ebp),%eax
80101bde:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101be5:	00 
80101be6:	89 04 24             	mov    %eax,(%esp)
80101be9:	e8 a2 27 00 00       	call   80104390 <strncmp>
80101bee:	85 c0                	test   %eax,%eax
80101bf0:	75 b6                	jne    80101ba8 <dirlookup+0x28>
80101bf2:	8b 45 10             	mov    0x10(%ebp),%eax
80101bf5:	85 c0                	test   %eax,%eax
80101bf7:	74 05                	je     80101bfe <dirlookup+0x7e>
80101bf9:	8b 45 10             	mov    0x10(%ebp),%eax
80101bfc:	89 38                	mov    %edi,(%eax)
80101bfe:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
80101c02:	8b 03                	mov    (%ebx),%eax
80101c04:	e8 c7 f5 ff ff       	call   801011d0 <iget>
80101c09:	83 c4 2c             	add    $0x2c,%esp
80101c0c:	5b                   	pop    %ebx
80101c0d:	5e                   	pop    %esi
80101c0e:	5f                   	pop    %edi
80101c0f:	5d                   	pop    %ebp
80101c10:	c3                   	ret    
80101c11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c18:	83 c4 2c             	add    $0x2c,%esp
80101c1b:	31 c0                	xor    %eax,%eax
80101c1d:	5b                   	pop    %ebx
80101c1e:	5e                   	pop    %esi
80101c1f:	5f                   	pop    %edi
80101c20:	5d                   	pop    %ebp
80101c21:	c3                   	ret    
80101c22:	c7 04 24 79 6f 10 80 	movl   $0x80106f79,(%esp)
80101c29:	e8 32 e7 ff ff       	call   80100360 <panic>
80101c2e:	c7 04 24 67 6f 10 80 	movl   $0x80106f67,(%esp)
80101c35:	e8 26 e7 ff ff       	call   80100360 <panic>
80101c3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101c40 <namex>:
80101c40:	55                   	push   %ebp
80101c41:	89 e5                	mov    %esp,%ebp
80101c43:	57                   	push   %edi
80101c44:	89 cf                	mov    %ecx,%edi
80101c46:	56                   	push   %esi
80101c47:	53                   	push   %ebx
80101c48:	89 c3                	mov    %eax,%ebx
80101c4a:	83 ec 2c             	sub    $0x2c,%esp
80101c4d:	80 38 2f             	cmpb   $0x2f,(%eax)
80101c50:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101c53:	0f 84 51 01 00 00    	je     80101daa <namex+0x16a>
80101c59:	e8 02 1a 00 00       	call   80103660 <myproc>
80101c5e:	8b 70 68             	mov    0x68(%eax),%esi
80101c61:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101c68:	e8 c3 24 00 00       	call   80104130 <acquire>
80101c6d:	83 46 08 01          	addl   $0x1,0x8(%esi)
80101c71:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101c78:	e8 a3 25 00 00       	call   80104220 <release>
80101c7d:	eb 04                	jmp    80101c83 <namex+0x43>
80101c7f:	90                   	nop
80101c80:	83 c3 01             	add    $0x1,%ebx
80101c83:	0f b6 03             	movzbl (%ebx),%eax
80101c86:	3c 2f                	cmp    $0x2f,%al
80101c88:	74 f6                	je     80101c80 <namex+0x40>
80101c8a:	84 c0                	test   %al,%al
80101c8c:	0f 84 ed 00 00 00    	je     80101d7f <namex+0x13f>
80101c92:	0f b6 03             	movzbl (%ebx),%eax
80101c95:	89 da                	mov    %ebx,%edx
80101c97:	84 c0                	test   %al,%al
80101c99:	0f 84 b1 00 00 00    	je     80101d50 <namex+0x110>
80101c9f:	3c 2f                	cmp    $0x2f,%al
80101ca1:	75 0f                	jne    80101cb2 <namex+0x72>
80101ca3:	e9 a8 00 00 00       	jmp    80101d50 <namex+0x110>
80101ca8:	3c 2f                	cmp    $0x2f,%al
80101caa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101cb0:	74 0a                	je     80101cbc <namex+0x7c>
80101cb2:	83 c2 01             	add    $0x1,%edx
80101cb5:	0f b6 02             	movzbl (%edx),%eax
80101cb8:	84 c0                	test   %al,%al
80101cba:	75 ec                	jne    80101ca8 <namex+0x68>
80101cbc:	89 d1                	mov    %edx,%ecx
80101cbe:	29 d9                	sub    %ebx,%ecx
80101cc0:	83 f9 0d             	cmp    $0xd,%ecx
80101cc3:	0f 8e 8f 00 00 00    	jle    80101d58 <namex+0x118>
80101cc9:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101ccd:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101cd4:	00 
80101cd5:	89 3c 24             	mov    %edi,(%esp)
80101cd8:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101cdb:	e8 30 26 00 00       	call   80104310 <memmove>
80101ce0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101ce3:	89 d3                	mov    %edx,%ebx
80101ce5:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101ce8:	75 0e                	jne    80101cf8 <namex+0xb8>
80101cea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101cf0:	83 c3 01             	add    $0x1,%ebx
80101cf3:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101cf6:	74 f8                	je     80101cf0 <namex+0xb0>
80101cf8:	89 34 24             	mov    %esi,(%esp)
80101cfb:	e8 70 f9 ff ff       	call   80101670 <ilock>
80101d00:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101d05:	0f 85 85 00 00 00    	jne    80101d90 <namex+0x150>
80101d0b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101d0e:	85 c0                	test   %eax,%eax
80101d10:	74 09                	je     80101d1b <namex+0xdb>
80101d12:	80 3b 00             	cmpb   $0x0,(%ebx)
80101d15:	0f 84 a5 00 00 00    	je     80101dc0 <namex+0x180>
80101d1b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80101d22:	00 
80101d23:	89 7c 24 04          	mov    %edi,0x4(%esp)
80101d27:	89 34 24             	mov    %esi,(%esp)
80101d2a:	e8 51 fe ff ff       	call   80101b80 <dirlookup>
80101d2f:	85 c0                	test   %eax,%eax
80101d31:	74 5d                	je     80101d90 <namex+0x150>
80101d33:	89 34 24             	mov    %esi,(%esp)
80101d36:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101d39:	e8 12 fa ff ff       	call   80101750 <iunlock>
80101d3e:	89 34 24             	mov    %esi,(%esp)
80101d41:	e8 4a fa ff ff       	call   80101790 <iput>
80101d46:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d49:	89 c6                	mov    %eax,%esi
80101d4b:	e9 33 ff ff ff       	jmp    80101c83 <namex+0x43>
80101d50:	31 c9                	xor    %ecx,%ecx
80101d52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101d58:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80101d5c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101d60:	89 3c 24             	mov    %edi,(%esp)
80101d63:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101d66:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101d69:	e8 a2 25 00 00       	call   80104310 <memmove>
80101d6e:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101d71:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101d74:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101d78:	89 d3                	mov    %edx,%ebx
80101d7a:	e9 66 ff ff ff       	jmp    80101ce5 <namex+0xa5>
80101d7f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101d82:	85 c0                	test   %eax,%eax
80101d84:	75 4c                	jne    80101dd2 <namex+0x192>
80101d86:	89 f0                	mov    %esi,%eax
80101d88:	83 c4 2c             	add    $0x2c,%esp
80101d8b:	5b                   	pop    %ebx
80101d8c:	5e                   	pop    %esi
80101d8d:	5f                   	pop    %edi
80101d8e:	5d                   	pop    %ebp
80101d8f:	c3                   	ret    
80101d90:	89 34 24             	mov    %esi,(%esp)
80101d93:	e8 b8 f9 ff ff       	call   80101750 <iunlock>
80101d98:	89 34 24             	mov    %esi,(%esp)
80101d9b:	e8 f0 f9 ff ff       	call   80101790 <iput>
80101da0:	83 c4 2c             	add    $0x2c,%esp
80101da3:	31 c0                	xor    %eax,%eax
80101da5:	5b                   	pop    %ebx
80101da6:	5e                   	pop    %esi
80101da7:	5f                   	pop    %edi
80101da8:	5d                   	pop    %ebp
80101da9:	c3                   	ret    
80101daa:	ba 01 00 00 00       	mov    $0x1,%edx
80101daf:	b8 01 00 00 00       	mov    $0x1,%eax
80101db4:	e8 17 f4 ff ff       	call   801011d0 <iget>
80101db9:	89 c6                	mov    %eax,%esi
80101dbb:	e9 c3 fe ff ff       	jmp    80101c83 <namex+0x43>
80101dc0:	89 34 24             	mov    %esi,(%esp)
80101dc3:	e8 88 f9 ff ff       	call   80101750 <iunlock>
80101dc8:	83 c4 2c             	add    $0x2c,%esp
80101dcb:	89 f0                	mov    %esi,%eax
80101dcd:	5b                   	pop    %ebx
80101dce:	5e                   	pop    %esi
80101dcf:	5f                   	pop    %edi
80101dd0:	5d                   	pop    %ebp
80101dd1:	c3                   	ret    
80101dd2:	89 34 24             	mov    %esi,(%esp)
80101dd5:	e8 b6 f9 ff ff       	call   80101790 <iput>
80101dda:	31 c0                	xor    %eax,%eax
80101ddc:	eb aa                	jmp    80101d88 <namex+0x148>
80101dde:	66 90                	xchg   %ax,%ax

80101de0 <dirlink>:
80101de0:	55                   	push   %ebp
80101de1:	89 e5                	mov    %esp,%ebp
80101de3:	57                   	push   %edi
80101de4:	56                   	push   %esi
80101de5:	53                   	push   %ebx
80101de6:	83 ec 2c             	sub    $0x2c,%esp
80101de9:	8b 5d 08             	mov    0x8(%ebp),%ebx
80101dec:	8b 45 0c             	mov    0xc(%ebp),%eax
80101def:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80101df6:	00 
80101df7:	89 1c 24             	mov    %ebx,(%esp)
80101dfa:	89 44 24 04          	mov    %eax,0x4(%esp)
80101dfe:	e8 7d fd ff ff       	call   80101b80 <dirlookup>
80101e03:	85 c0                	test   %eax,%eax
80101e05:	0f 85 8b 00 00 00    	jne    80101e96 <dirlink+0xb6>
80101e0b:	8b 53 58             	mov    0x58(%ebx),%edx
80101e0e:	31 ff                	xor    %edi,%edi
80101e10:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e13:	85 d2                	test   %edx,%edx
80101e15:	75 13                	jne    80101e2a <dirlink+0x4a>
80101e17:	eb 35                	jmp    80101e4e <dirlink+0x6e>
80101e19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e20:	8d 57 10             	lea    0x10(%edi),%edx
80101e23:	39 53 58             	cmp    %edx,0x58(%ebx)
80101e26:	89 d7                	mov    %edx,%edi
80101e28:	76 24                	jbe    80101e4e <dirlink+0x6e>
80101e2a:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101e31:	00 
80101e32:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101e36:	89 74 24 04          	mov    %esi,0x4(%esp)
80101e3a:	89 1c 24             	mov    %ebx,(%esp)
80101e3d:	e8 de fa ff ff       	call   80101920 <readi>
80101e42:	83 f8 10             	cmp    $0x10,%eax
80101e45:	75 5e                	jne    80101ea5 <dirlink+0xc5>
80101e47:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e4c:	75 d2                	jne    80101e20 <dirlink+0x40>
80101e4e:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e51:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101e58:	00 
80101e59:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e5d:	8d 45 da             	lea    -0x26(%ebp),%eax
80101e60:	89 04 24             	mov    %eax,(%esp)
80101e63:	e8 98 25 00 00       	call   80104400 <strncpy>
80101e68:	8b 45 10             	mov    0x10(%ebp),%eax
80101e6b:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101e72:	00 
80101e73:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101e77:	89 74 24 04          	mov    %esi,0x4(%esp)
80101e7b:	89 1c 24             	mov    %ebx,(%esp)
80101e7e:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
80101e82:	e8 99 fb ff ff       	call   80101a20 <writei>
80101e87:	83 f8 10             	cmp    $0x10,%eax
80101e8a:	75 25                	jne    80101eb1 <dirlink+0xd1>
80101e8c:	31 c0                	xor    %eax,%eax
80101e8e:	83 c4 2c             	add    $0x2c,%esp
80101e91:	5b                   	pop    %ebx
80101e92:	5e                   	pop    %esi
80101e93:	5f                   	pop    %edi
80101e94:	5d                   	pop    %ebp
80101e95:	c3                   	ret    
80101e96:	89 04 24             	mov    %eax,(%esp)
80101e99:	e8 f2 f8 ff ff       	call   80101790 <iput>
80101e9e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ea3:	eb e9                	jmp    80101e8e <dirlink+0xae>
80101ea5:	c7 04 24 88 6f 10 80 	movl   $0x80106f88,(%esp)
80101eac:	e8 af e4 ff ff       	call   80100360 <panic>
80101eb1:	c7 04 24 8a 75 10 80 	movl   $0x8010758a,(%esp)
80101eb8:	e8 a3 e4 ff ff       	call   80100360 <panic>
80101ebd:	8d 76 00             	lea    0x0(%esi),%esi

80101ec0 <namei>:
80101ec0:	55                   	push   %ebp
80101ec1:	31 d2                	xor    %edx,%edx
80101ec3:	89 e5                	mov    %esp,%ebp
80101ec5:	83 ec 18             	sub    $0x18,%esp
80101ec8:	8b 45 08             	mov    0x8(%ebp),%eax
80101ecb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101ece:	e8 6d fd ff ff       	call   80101c40 <namex>
80101ed3:	c9                   	leave  
80101ed4:	c3                   	ret    
80101ed5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101ed9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ee0 <nameiparent>:
80101ee0:	55                   	push   %ebp
80101ee1:	ba 01 00 00 00       	mov    $0x1,%edx
80101ee6:	89 e5                	mov    %esp,%ebp
80101ee8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101eeb:	8b 45 08             	mov    0x8(%ebp),%eax
80101eee:	5d                   	pop    %ebp
80101eef:	e9 4c fd ff ff       	jmp    80101c40 <namex>
	...

80101f00 <idestart>:
80101f00:	55                   	push   %ebp
80101f01:	89 e5                	mov    %esp,%ebp
80101f03:	56                   	push   %esi
80101f04:	89 c6                	mov    %eax,%esi
80101f06:	83 ec 14             	sub    $0x14,%esp
80101f09:	85 c0                	test   %eax,%eax
80101f0b:	0f 84 99 00 00 00    	je     80101faa <idestart+0xaa>
80101f11:	8b 48 08             	mov    0x8(%eax),%ecx
80101f14:	81 f9 e7 03 00 00    	cmp    $0x3e7,%ecx
80101f1a:	0f 87 7e 00 00 00    	ja     80101f9e <idestart+0x9e>
80101f20:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101f25:	8d 76 00             	lea    0x0(%esi),%esi
80101f28:	ec                   	in     (%dx),%al
80101f29:	83 e0 c0             	and    $0xffffffc0,%eax
80101f2c:	3c 40                	cmp    $0x40,%al
80101f2e:	75 f8                	jne    80101f28 <idestart+0x28>
80101f30:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101f35:	31 c0                	xor    %eax,%eax
80101f37:	ee                   	out    %al,(%dx)
80101f38:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101f3d:	b8 01 00 00 00       	mov    $0x1,%eax
80101f42:	ee                   	out    %al,(%dx)
80101f43:	0f b6 c1             	movzbl %cl,%eax
80101f46:	b2 f3                	mov    $0xf3,%dl
80101f48:	ee                   	out    %al,(%dx)
80101f49:	89 c8                	mov    %ecx,%eax
80101f4b:	b2 f4                	mov    $0xf4,%dl
80101f4d:	c1 f8 08             	sar    $0x8,%eax
80101f50:	ee                   	out    %al,(%dx)
80101f51:	31 c0                	xor    %eax,%eax
80101f53:	b2 f5                	mov    $0xf5,%dl
80101f55:	ee                   	out    %al,(%dx)
80101f56:	0f b6 46 04          	movzbl 0x4(%esi),%eax
80101f5a:	b2 f6                	mov    $0xf6,%dl
80101f5c:	83 e0 01             	and    $0x1,%eax
80101f5f:	c1 e0 04             	shl    $0x4,%eax
80101f62:	83 c8 e0             	or     $0xffffffe0,%eax
80101f65:	ee                   	out    %al,(%dx)
80101f66:	f6 06 04             	testb  $0x4,(%esi)
80101f69:	75 15                	jne    80101f80 <idestart+0x80>
80101f6b:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101f70:	b8 20 00 00 00       	mov    $0x20,%eax
80101f75:	ee                   	out    %al,(%dx)
80101f76:	83 c4 14             	add    $0x14,%esp
80101f79:	5e                   	pop    %esi
80101f7a:	5d                   	pop    %ebp
80101f7b:	c3                   	ret    
80101f7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f80:	b2 f7                	mov    $0xf7,%dl
80101f82:	b8 30 00 00 00       	mov    $0x30,%eax
80101f87:	ee                   	out    %al,(%dx)
80101f88:	b9 80 00 00 00       	mov    $0x80,%ecx
80101f8d:	83 c6 5c             	add    $0x5c,%esi
80101f90:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101f95:	fc                   	cld    
80101f96:	f3 6f                	rep outsl %ds:(%esi),(%dx)
80101f98:	83 c4 14             	add    $0x14,%esp
80101f9b:	5e                   	pop    %esi
80101f9c:	5d                   	pop    %ebp
80101f9d:	c3                   	ret    
80101f9e:	c7 04 24 f4 6f 10 80 	movl   $0x80106ff4,(%esp)
80101fa5:	e8 b6 e3 ff ff       	call   80100360 <panic>
80101faa:	c7 04 24 eb 6f 10 80 	movl   $0x80106feb,(%esp)
80101fb1:	e8 aa e3 ff ff       	call   80100360 <panic>
80101fb6:	8d 76 00             	lea    0x0(%esi),%esi
80101fb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101fc0 <ideinit>:
80101fc0:	55                   	push   %ebp
80101fc1:	89 e5                	mov    %esp,%ebp
80101fc3:	83 ec 18             	sub    $0x18,%esp
80101fc6:	c7 44 24 04 06 70 10 	movl   $0x80107006,0x4(%esp)
80101fcd:	80 
80101fce:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
80101fd5:	e8 66 20 00 00       	call   80104040 <initlock>
80101fda:	a1 00 2d 11 80       	mov    0x80112d00,%eax
80101fdf:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
80101fe6:	83 e8 01             	sub    $0x1,%eax
80101fe9:	89 44 24 04          	mov    %eax,0x4(%esp)
80101fed:	e8 7e 02 00 00       	call   80102270 <ioapicenable>
80101ff2:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101ff7:	90                   	nop
80101ff8:	ec                   	in     (%dx),%al
80101ff9:	83 e0 c0             	and    $0xffffffc0,%eax
80101ffc:	3c 40                	cmp    $0x40,%al
80101ffe:	75 f8                	jne    80101ff8 <ideinit+0x38>
80102000:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102005:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010200a:	ee                   	out    %al,(%dx)
8010200b:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
80102010:	b2 f7                	mov    $0xf7,%dl
80102012:	eb 09                	jmp    8010201d <ideinit+0x5d>
80102014:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102018:	83 e9 01             	sub    $0x1,%ecx
8010201b:	74 0f                	je     8010202c <ideinit+0x6c>
8010201d:	ec                   	in     (%dx),%al
8010201e:	84 c0                	test   %al,%al
80102020:	74 f6                	je     80102018 <ideinit+0x58>
80102022:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
80102029:	00 00 00 
8010202c:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102031:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102036:	ee                   	out    %al,(%dx)
80102037:	c9                   	leave  
80102038:	c3                   	ret    
80102039:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102040 <ideintr>:
80102040:	55                   	push   %ebp
80102041:	89 e5                	mov    %esp,%ebp
80102043:	57                   	push   %edi
80102044:	56                   	push   %esi
80102045:	53                   	push   %ebx
80102046:	83 ec 1c             	sub    $0x1c,%esp
80102049:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
80102050:	e8 db 20 00 00       	call   80104130 <acquire>
80102055:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
8010205b:	85 db                	test   %ebx,%ebx
8010205d:	74 30                	je     8010208f <ideintr+0x4f>
8010205f:	8b 43 58             	mov    0x58(%ebx),%eax
80102062:	a3 64 a5 10 80       	mov    %eax,0x8010a564
80102067:	8b 33                	mov    (%ebx),%esi
80102069:	f7 c6 04 00 00 00    	test   $0x4,%esi
8010206f:	74 37                	je     801020a8 <ideintr+0x68>
80102071:	83 e6 fb             	and    $0xfffffffb,%esi
80102074:	83 ce 02             	or     $0x2,%esi
80102077:	89 33                	mov    %esi,(%ebx)
80102079:	89 1c 24             	mov    %ebx,(%esp)
8010207c:	e8 ef 1c 00 00       	call   80103d70 <wakeup>
80102081:	a1 64 a5 10 80       	mov    0x8010a564,%eax
80102086:	85 c0                	test   %eax,%eax
80102088:	74 05                	je     8010208f <ideintr+0x4f>
8010208a:	e8 71 fe ff ff       	call   80101f00 <idestart>
8010208f:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
80102096:	e8 85 21 00 00       	call   80104220 <release>
8010209b:	83 c4 1c             	add    $0x1c,%esp
8010209e:	5b                   	pop    %ebx
8010209f:	5e                   	pop    %esi
801020a0:	5f                   	pop    %edi
801020a1:	5d                   	pop    %ebp
801020a2:	c3                   	ret    
801020a3:	90                   	nop
801020a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801020a8:	ba f7 01 00 00       	mov    $0x1f7,%edx
801020ad:	8d 76 00             	lea    0x0(%esi),%esi
801020b0:	ec                   	in     (%dx),%al
801020b1:	89 c1                	mov    %eax,%ecx
801020b3:	83 e1 c0             	and    $0xffffffc0,%ecx
801020b6:	80 f9 40             	cmp    $0x40,%cl
801020b9:	75 f5                	jne    801020b0 <ideintr+0x70>
801020bb:	a8 21                	test   $0x21,%al
801020bd:	75 b2                	jne    80102071 <ideintr+0x31>
801020bf:	8d 7b 5c             	lea    0x5c(%ebx),%edi
801020c2:	b9 80 00 00 00       	mov    $0x80,%ecx
801020c7:	ba f0 01 00 00       	mov    $0x1f0,%edx
801020cc:	fc                   	cld    
801020cd:	f3 6d                	rep insl (%dx),%es:(%edi)
801020cf:	8b 33                	mov    (%ebx),%esi
801020d1:	eb 9e                	jmp    80102071 <ideintr+0x31>
801020d3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801020d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801020e0 <iderw>:
801020e0:	55                   	push   %ebp
801020e1:	89 e5                	mov    %esp,%ebp
801020e3:	53                   	push   %ebx
801020e4:	83 ec 14             	sub    $0x14,%esp
801020e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
801020ea:	8d 43 0c             	lea    0xc(%ebx),%eax
801020ed:	89 04 24             	mov    %eax,(%esp)
801020f0:	e8 1b 1f 00 00       	call   80104010 <holdingsleep>
801020f5:	85 c0                	test   %eax,%eax
801020f7:	0f 84 9e 00 00 00    	je     8010219b <iderw+0xbb>
801020fd:	8b 03                	mov    (%ebx),%eax
801020ff:	83 e0 06             	and    $0x6,%eax
80102102:	83 f8 02             	cmp    $0x2,%eax
80102105:	0f 84 a8 00 00 00    	je     801021b3 <iderw+0xd3>
8010210b:	8b 53 04             	mov    0x4(%ebx),%edx
8010210e:	85 d2                	test   %edx,%edx
80102110:	74 0d                	je     8010211f <iderw+0x3f>
80102112:	a1 60 a5 10 80       	mov    0x8010a560,%eax
80102117:	85 c0                	test   %eax,%eax
80102119:	0f 84 88 00 00 00    	je     801021a7 <iderw+0xc7>
8010211f:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
80102126:	e8 05 20 00 00       	call   80104130 <acquire>
8010212b:	a1 64 a5 10 80       	mov    0x8010a564,%eax
80102130:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
80102137:	85 c0                	test   %eax,%eax
80102139:	75 07                	jne    80102142 <iderw+0x62>
8010213b:	eb 4e                	jmp    8010218b <iderw+0xab>
8010213d:	8d 76 00             	lea    0x0(%esi),%esi
80102140:	89 d0                	mov    %edx,%eax
80102142:	8b 50 58             	mov    0x58(%eax),%edx
80102145:	85 d2                	test   %edx,%edx
80102147:	75 f7                	jne    80102140 <iderw+0x60>
80102149:	83 c0 58             	add    $0x58,%eax
8010214c:	89 18                	mov    %ebx,(%eax)
8010214e:	39 1d 64 a5 10 80    	cmp    %ebx,0x8010a564
80102154:	74 3c                	je     80102192 <iderw+0xb2>
80102156:	8b 03                	mov    (%ebx),%eax
80102158:	83 e0 06             	and    $0x6,%eax
8010215b:	83 f8 02             	cmp    $0x2,%eax
8010215e:	74 1a                	je     8010217a <iderw+0x9a>
80102160:	c7 44 24 04 80 a5 10 	movl   $0x8010a580,0x4(%esp)
80102167:	80 
80102168:	89 1c 24             	mov    %ebx,(%esp)
8010216b:	e8 60 1a 00 00       	call   80103bd0 <sleep>
80102170:	8b 13                	mov    (%ebx),%edx
80102172:	83 e2 06             	and    $0x6,%edx
80102175:	83 fa 02             	cmp    $0x2,%edx
80102178:	75 e6                	jne    80102160 <iderw+0x80>
8010217a:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
80102181:	83 c4 14             	add    $0x14,%esp
80102184:	5b                   	pop    %ebx
80102185:	5d                   	pop    %ebp
80102186:	e9 95 20 00 00       	jmp    80104220 <release>
8010218b:	b8 64 a5 10 80       	mov    $0x8010a564,%eax
80102190:	eb ba                	jmp    8010214c <iderw+0x6c>
80102192:	89 d8                	mov    %ebx,%eax
80102194:	e8 67 fd ff ff       	call   80101f00 <idestart>
80102199:	eb bb                	jmp    80102156 <iderw+0x76>
8010219b:	c7 04 24 0a 70 10 80 	movl   $0x8010700a,(%esp)
801021a2:	e8 b9 e1 ff ff       	call   80100360 <panic>
801021a7:	c7 04 24 35 70 10 80 	movl   $0x80107035,(%esp)
801021ae:	e8 ad e1 ff ff       	call   80100360 <panic>
801021b3:	c7 04 24 20 70 10 80 	movl   $0x80107020,(%esp)
801021ba:	e8 a1 e1 ff ff       	call   80100360 <panic>
	...

801021c0 <ioapicinit>:
801021c0:	55                   	push   %ebp
801021c1:	89 e5                	mov    %esp,%ebp
801021c3:	56                   	push   %esi
801021c4:	53                   	push   %ebx
801021c5:	83 ec 10             	sub    $0x10,%esp
801021c8:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
801021cf:	00 c0 fe 
801021d2:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801021d9:	00 00 00 
801021dc:	8b 15 34 26 11 80    	mov    0x80112634,%edx
801021e2:	8b 42 10             	mov    0x10(%edx),%eax
801021e5:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
801021eb:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
801021f1:	0f b6 15 60 27 11 80 	movzbl 0x80112760,%edx
801021f8:	c1 e8 10             	shr    $0x10,%eax
801021fb:	0f b6 f0             	movzbl %al,%esi
801021fe:	8b 43 10             	mov    0x10(%ebx),%eax
80102201:	c1 e8 18             	shr    $0x18,%eax
80102204:	39 c2                	cmp    %eax,%edx
80102206:	74 12                	je     8010221a <ioapicinit+0x5a>
80102208:	c7 04 24 54 70 10 80 	movl   $0x80107054,(%esp)
8010220f:	e8 3c e4 ff ff       	call   80100650 <cprintf>
80102214:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
8010221a:	ba 10 00 00 00       	mov    $0x10,%edx
8010221f:	31 c0                	xor    %eax,%eax
80102221:	eb 07                	jmp    8010222a <ioapicinit+0x6a>
80102223:	90                   	nop
80102224:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102228:	89 cb                	mov    %ecx,%ebx
8010222a:	89 13                	mov    %edx,(%ebx)
8010222c:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
80102232:	8d 48 20             	lea    0x20(%eax),%ecx
80102235:	81 c9 00 00 01 00    	or     $0x10000,%ecx
8010223b:	83 c0 01             	add    $0x1,%eax
8010223e:	89 4b 10             	mov    %ecx,0x10(%ebx)
80102241:	8d 4a 01             	lea    0x1(%edx),%ecx
80102244:	83 c2 02             	add    $0x2,%edx
80102247:	89 0b                	mov    %ecx,(%ebx)
80102249:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
8010224f:	39 c6                	cmp    %eax,%esi
80102251:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
80102258:	7d ce                	jge    80102228 <ioapicinit+0x68>
8010225a:	83 c4 10             	add    $0x10,%esp
8010225d:	5b                   	pop    %ebx
8010225e:	5e                   	pop    %esi
8010225f:	5d                   	pop    %ebp
80102260:	c3                   	ret    
80102261:	eb 0d                	jmp    80102270 <ioapicenable>
80102263:	90                   	nop
80102264:	90                   	nop
80102265:	90                   	nop
80102266:	90                   	nop
80102267:	90                   	nop
80102268:	90                   	nop
80102269:	90                   	nop
8010226a:	90                   	nop
8010226b:	90                   	nop
8010226c:	90                   	nop
8010226d:	90                   	nop
8010226e:	90                   	nop
8010226f:	90                   	nop

80102270 <ioapicenable>:
80102270:	55                   	push   %ebp
80102271:	89 e5                	mov    %esp,%ebp
80102273:	8b 55 08             	mov    0x8(%ebp),%edx
80102276:	53                   	push   %ebx
80102277:	8b 45 0c             	mov    0xc(%ebp),%eax
8010227a:	8d 5a 20             	lea    0x20(%edx),%ebx
8010227d:	8d 4c 12 10          	lea    0x10(%edx,%edx,1),%ecx
80102281:	8b 15 34 26 11 80    	mov    0x80112634,%edx
80102287:	c1 e0 18             	shl    $0x18,%eax
8010228a:	89 0a                	mov    %ecx,(%edx)
8010228c:	8b 15 34 26 11 80    	mov    0x80112634,%edx
80102292:	83 c1 01             	add    $0x1,%ecx
80102295:	89 5a 10             	mov    %ebx,0x10(%edx)
80102298:	89 0a                	mov    %ecx,(%edx)
8010229a:	8b 15 34 26 11 80    	mov    0x80112634,%edx
801022a0:	89 42 10             	mov    %eax,0x10(%edx)
801022a3:	5b                   	pop    %ebx
801022a4:	5d                   	pop    %ebp
801022a5:	c3                   	ret    
	...

801022b0 <kfree>:
801022b0:	55                   	push   %ebp
801022b1:	89 e5                	mov    %esp,%ebp
801022b3:	53                   	push   %ebx
801022b4:	83 ec 14             	sub    $0x14,%esp
801022b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
801022ba:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801022c0:	75 7c                	jne    8010233e <kfree+0x8e>
801022c2:	81 fb a8 57 11 80    	cmp    $0x801157a8,%ebx
801022c8:	72 74                	jb     8010233e <kfree+0x8e>
801022ca:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801022d0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801022d5:	77 67                	ja     8010233e <kfree+0x8e>
801022d7:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801022de:	00 
801022df:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801022e6:	00 
801022e7:	89 1c 24             	mov    %ebx,(%esp)
801022ea:	e8 81 1f 00 00       	call   80104270 <memset>
801022ef:	8b 15 74 26 11 80    	mov    0x80112674,%edx
801022f5:	85 d2                	test   %edx,%edx
801022f7:	75 37                	jne    80102330 <kfree+0x80>
801022f9:	a1 78 26 11 80       	mov    0x80112678,%eax
801022fe:	89 03                	mov    %eax,(%ebx)
80102300:	a1 74 26 11 80       	mov    0x80112674,%eax
80102305:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
8010230b:	85 c0                	test   %eax,%eax
8010230d:	75 09                	jne    80102318 <kfree+0x68>
8010230f:	83 c4 14             	add    $0x14,%esp
80102312:	5b                   	pop    %ebx
80102313:	5d                   	pop    %ebp
80102314:	c3                   	ret    
80102315:	8d 76 00             	lea    0x0(%esi),%esi
80102318:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
8010231f:	83 c4 14             	add    $0x14,%esp
80102322:	5b                   	pop    %ebx
80102323:	5d                   	pop    %ebp
80102324:	e9 f7 1e 00 00       	jmp    80104220 <release>
80102329:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102330:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
80102337:	e8 f4 1d 00 00       	call   80104130 <acquire>
8010233c:	eb bb                	jmp    801022f9 <kfree+0x49>
8010233e:	c7 04 24 86 70 10 80 	movl   $0x80107086,(%esp)
80102345:	e8 16 e0 ff ff       	call   80100360 <panic>
8010234a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102350 <freerange>:
80102350:	55                   	push   %ebp
80102351:	89 e5                	mov    %esp,%ebp
80102353:	56                   	push   %esi
80102354:	53                   	push   %ebx
80102355:	83 ec 10             	sub    $0x10,%esp
80102358:	8b 45 08             	mov    0x8(%ebp),%eax
8010235b:	8b 75 0c             	mov    0xc(%ebp),%esi
8010235e:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80102364:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
8010236a:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
80102370:	39 de                	cmp    %ebx,%esi
80102372:	73 08                	jae    8010237c <freerange+0x2c>
80102374:	eb 18                	jmp    8010238e <freerange+0x3e>
80102376:	66 90                	xchg   %ax,%ax
80102378:	89 da                	mov    %ebx,%edx
8010237a:	89 c3                	mov    %eax,%ebx
8010237c:	89 14 24             	mov    %edx,(%esp)
8010237f:	e8 2c ff ff ff       	call   801022b0 <kfree>
80102384:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
8010238a:	39 f0                	cmp    %esi,%eax
8010238c:	76 ea                	jbe    80102378 <freerange+0x28>
8010238e:	83 c4 10             	add    $0x10,%esp
80102391:	5b                   	pop    %ebx
80102392:	5e                   	pop    %esi
80102393:	5d                   	pop    %ebp
80102394:	c3                   	ret    
80102395:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102399:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801023a0 <kinit1>:
801023a0:	55                   	push   %ebp
801023a1:	89 e5                	mov    %esp,%ebp
801023a3:	56                   	push   %esi
801023a4:	53                   	push   %ebx
801023a5:	83 ec 10             	sub    $0x10,%esp
801023a8:	8b 75 0c             	mov    0xc(%ebp),%esi
801023ab:	c7 44 24 04 8c 70 10 	movl   $0x8010708c,0x4(%esp)
801023b2:	80 
801023b3:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
801023ba:	e8 81 1c 00 00       	call   80104040 <initlock>
801023bf:	8b 45 08             	mov    0x8(%ebp),%eax
801023c2:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
801023c9:	00 00 00 
801023cc:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
801023d2:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
801023d8:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
801023de:	39 de                	cmp    %ebx,%esi
801023e0:	73 0a                	jae    801023ec <kinit1+0x4c>
801023e2:	eb 1a                	jmp    801023fe <kinit1+0x5e>
801023e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801023e8:	89 da                	mov    %ebx,%edx
801023ea:	89 c3                	mov    %eax,%ebx
801023ec:	89 14 24             	mov    %edx,(%esp)
801023ef:	e8 bc fe ff ff       	call   801022b0 <kfree>
801023f4:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
801023fa:	39 c6                	cmp    %eax,%esi
801023fc:	73 ea                	jae    801023e8 <kinit1+0x48>
801023fe:	83 c4 10             	add    $0x10,%esp
80102401:	5b                   	pop    %ebx
80102402:	5e                   	pop    %esi
80102403:	5d                   	pop    %ebp
80102404:	c3                   	ret    
80102405:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102410 <kinit2>:
80102410:	55                   	push   %ebp
80102411:	89 e5                	mov    %esp,%ebp
80102413:	56                   	push   %esi
80102414:	53                   	push   %ebx
80102415:	83 ec 10             	sub    $0x10,%esp
80102418:	8b 45 08             	mov    0x8(%ebp),%eax
8010241b:	8b 75 0c             	mov    0xc(%ebp),%esi
8010241e:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80102424:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
8010242a:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
80102430:	39 de                	cmp    %ebx,%esi
80102432:	73 08                	jae    8010243c <kinit2+0x2c>
80102434:	eb 18                	jmp    8010244e <kinit2+0x3e>
80102436:	66 90                	xchg   %ax,%ax
80102438:	89 da                	mov    %ebx,%edx
8010243a:	89 c3                	mov    %eax,%ebx
8010243c:	89 14 24             	mov    %edx,(%esp)
8010243f:	e8 6c fe ff ff       	call   801022b0 <kfree>
80102444:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
8010244a:	39 c6                	cmp    %eax,%esi
8010244c:	73 ea                	jae    80102438 <kinit2+0x28>
8010244e:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
80102455:	00 00 00 
80102458:	83 c4 10             	add    $0x10,%esp
8010245b:	5b                   	pop    %ebx
8010245c:	5e                   	pop    %esi
8010245d:	5d                   	pop    %ebp
8010245e:	c3                   	ret    
8010245f:	90                   	nop

80102460 <kalloc>:
80102460:	55                   	push   %ebp
80102461:	89 e5                	mov    %esp,%ebp
80102463:	53                   	push   %ebx
80102464:	83 ec 14             	sub    $0x14,%esp
80102467:	a1 74 26 11 80       	mov    0x80112674,%eax
8010246c:	85 c0                	test   %eax,%eax
8010246e:	75 30                	jne    801024a0 <kalloc+0x40>
80102470:	8b 1d 78 26 11 80    	mov    0x80112678,%ebx
80102476:	85 db                	test   %ebx,%ebx
80102478:	74 08                	je     80102482 <kalloc+0x22>
8010247a:	8b 13                	mov    (%ebx),%edx
8010247c:	89 15 78 26 11 80    	mov    %edx,0x80112678
80102482:	85 c0                	test   %eax,%eax
80102484:	74 0c                	je     80102492 <kalloc+0x32>
80102486:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
8010248d:	e8 8e 1d 00 00       	call   80104220 <release>
80102492:	83 c4 14             	add    $0x14,%esp
80102495:	89 d8                	mov    %ebx,%eax
80102497:	5b                   	pop    %ebx
80102498:	5d                   	pop    %ebp
80102499:	c3                   	ret    
8010249a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801024a0:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
801024a7:	e8 84 1c 00 00       	call   80104130 <acquire>
801024ac:	a1 74 26 11 80       	mov    0x80112674,%eax
801024b1:	eb bd                	jmp    80102470 <kalloc+0x10>
	...

801024c0 <kbdgetc>:
801024c0:	ba 64 00 00 00       	mov    $0x64,%edx
801024c5:	ec                   	in     (%dx),%al
801024c6:	a8 01                	test   $0x1,%al
801024c8:	0f 84 ba 00 00 00    	je     80102588 <kbdgetc+0xc8>
801024ce:	b2 60                	mov    $0x60,%dl
801024d0:	ec                   	in     (%dx),%al
801024d1:	0f b6 c8             	movzbl %al,%ecx
801024d4:	81 f9 e0 00 00 00    	cmp    $0xe0,%ecx
801024da:	0f 84 88 00 00 00    	je     80102568 <kbdgetc+0xa8>
801024e0:	84 c0                	test   %al,%al
801024e2:	79 2c                	jns    80102510 <kbdgetc+0x50>
801024e4:	8b 15 b4 a5 10 80    	mov    0x8010a5b4,%edx
801024ea:	f6 c2 40             	test   $0x40,%dl
801024ed:	75 05                	jne    801024f4 <kbdgetc+0x34>
801024ef:	89 c1                	mov    %eax,%ecx
801024f1:	83 e1 7f             	and    $0x7f,%ecx
801024f4:	0f b6 81 c0 71 10 80 	movzbl -0x7fef8e40(%ecx),%eax
801024fb:	83 c8 40             	or     $0x40,%eax
801024fe:	0f b6 c0             	movzbl %al,%eax
80102501:	f7 d0                	not    %eax
80102503:	21 d0                	and    %edx,%eax
80102505:	a3 b4 a5 10 80       	mov    %eax,0x8010a5b4
8010250a:	31 c0                	xor    %eax,%eax
8010250c:	c3                   	ret    
8010250d:	8d 76 00             	lea    0x0(%esi),%esi
80102510:	55                   	push   %ebp
80102511:	89 e5                	mov    %esp,%ebp
80102513:	53                   	push   %ebx
80102514:	8b 1d b4 a5 10 80    	mov    0x8010a5b4,%ebx
8010251a:	f6 c3 40             	test   $0x40,%bl
8010251d:	74 09                	je     80102528 <kbdgetc+0x68>
8010251f:	83 c8 80             	or     $0xffffff80,%eax
80102522:	83 e3 bf             	and    $0xffffffbf,%ebx
80102525:	0f b6 c8             	movzbl %al,%ecx
80102528:	0f b6 91 c0 71 10 80 	movzbl -0x7fef8e40(%ecx),%edx
8010252f:	0f b6 81 c0 70 10 80 	movzbl -0x7fef8f40(%ecx),%eax
80102536:	09 da                	or     %ebx,%edx
80102538:	31 c2                	xor    %eax,%edx
8010253a:	89 d0                	mov    %edx,%eax
8010253c:	83 e0 03             	and    $0x3,%eax
8010253f:	8b 04 85 a0 70 10 80 	mov    -0x7fef8f60(,%eax,4),%eax
80102546:	89 15 b4 a5 10 80    	mov    %edx,0x8010a5b4
8010254c:	83 e2 08             	and    $0x8,%edx
8010254f:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
80102553:	74 0b                	je     80102560 <kbdgetc+0xa0>
80102555:	8d 50 9f             	lea    -0x61(%eax),%edx
80102558:	83 fa 19             	cmp    $0x19,%edx
8010255b:	77 1b                	ja     80102578 <kbdgetc+0xb8>
8010255d:	83 e8 20             	sub    $0x20,%eax
80102560:	5b                   	pop    %ebx
80102561:	5d                   	pop    %ebp
80102562:	c3                   	ret    
80102563:	90                   	nop
80102564:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102568:	83 0d b4 a5 10 80 40 	orl    $0x40,0x8010a5b4
8010256f:	31 c0                	xor    %eax,%eax
80102571:	c3                   	ret    
80102572:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102578:	8d 48 bf             	lea    -0x41(%eax),%ecx
8010257b:	8d 50 20             	lea    0x20(%eax),%edx
8010257e:	83 f9 19             	cmp    $0x19,%ecx
80102581:	0f 46 c2             	cmovbe %edx,%eax
80102584:	eb da                	jmp    80102560 <kbdgetc+0xa0>
80102586:	66 90                	xchg   %ax,%ax
80102588:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010258d:	c3                   	ret    
8010258e:	66 90                	xchg   %ax,%ax

80102590 <kbdintr>:
80102590:	55                   	push   %ebp
80102591:	89 e5                	mov    %esp,%ebp
80102593:	83 ec 18             	sub    $0x18,%esp
80102596:	c7 04 24 c0 24 10 80 	movl   $0x801024c0,(%esp)
8010259d:	e8 0e e2 ff ff       	call   801007b0 <consoleintr>
801025a2:	c9                   	leave  
801025a3:	c3                   	ret    
	...

801025b0 <fill_rtcdate>:
801025b0:	55                   	push   %ebp
801025b1:	89 c1                	mov    %eax,%ecx
801025b3:	89 e5                	mov    %esp,%ebp
801025b5:	ba 70 00 00 00       	mov    $0x70,%edx
801025ba:	31 c0                	xor    %eax,%eax
801025bc:	ee                   	out    %al,(%dx)
801025bd:	b2 71                	mov    $0x71,%dl
801025bf:	ec                   	in     (%dx),%al
801025c0:	0f b6 c0             	movzbl %al,%eax
801025c3:	b2 70                	mov    $0x70,%dl
801025c5:	89 01                	mov    %eax,(%ecx)
801025c7:	b8 02 00 00 00       	mov    $0x2,%eax
801025cc:	ee                   	out    %al,(%dx)
801025cd:	b2 71                	mov    $0x71,%dl
801025cf:	ec                   	in     (%dx),%al
801025d0:	0f b6 c0             	movzbl %al,%eax
801025d3:	b2 70                	mov    $0x70,%dl
801025d5:	89 41 04             	mov    %eax,0x4(%ecx)
801025d8:	b8 04 00 00 00       	mov    $0x4,%eax
801025dd:	ee                   	out    %al,(%dx)
801025de:	b2 71                	mov    $0x71,%dl
801025e0:	ec                   	in     (%dx),%al
801025e1:	0f b6 c0             	movzbl %al,%eax
801025e4:	b2 70                	mov    $0x70,%dl
801025e6:	89 41 08             	mov    %eax,0x8(%ecx)
801025e9:	b8 07 00 00 00       	mov    $0x7,%eax
801025ee:	ee                   	out    %al,(%dx)
801025ef:	b2 71                	mov    $0x71,%dl
801025f1:	ec                   	in     (%dx),%al
801025f2:	0f b6 c0             	movzbl %al,%eax
801025f5:	b2 70                	mov    $0x70,%dl
801025f7:	89 41 0c             	mov    %eax,0xc(%ecx)
801025fa:	b8 08 00 00 00       	mov    $0x8,%eax
801025ff:	ee                   	out    %al,(%dx)
80102600:	b2 71                	mov    $0x71,%dl
80102602:	ec                   	in     (%dx),%al
80102603:	0f b6 c0             	movzbl %al,%eax
80102606:	b2 70                	mov    $0x70,%dl
80102608:	89 41 10             	mov    %eax,0x10(%ecx)
8010260b:	b8 09 00 00 00       	mov    $0x9,%eax
80102610:	ee                   	out    %al,(%dx)
80102611:	b2 71                	mov    $0x71,%dl
80102613:	ec                   	in     (%dx),%al
80102614:	0f b6 c0             	movzbl %al,%eax
80102617:	89 41 14             	mov    %eax,0x14(%ecx)
8010261a:	5d                   	pop    %ebp
8010261b:	c3                   	ret    
8010261c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102620 <lapicinit>:
80102620:	a1 7c 26 11 80       	mov    0x8011267c,%eax
80102625:	55                   	push   %ebp
80102626:	89 e5                	mov    %esp,%ebp
80102628:	85 c0                	test   %eax,%eax
8010262a:	0f 84 c0 00 00 00    	je     801026f0 <lapicinit+0xd0>
80102630:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102637:	01 00 00 
8010263a:	8b 50 20             	mov    0x20(%eax),%edx
8010263d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102644:	00 00 00 
80102647:	8b 50 20             	mov    0x20(%eax),%edx
8010264a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102651:	00 02 00 
80102654:	8b 50 20             	mov    0x20(%eax),%edx
80102657:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010265e:	96 98 00 
80102661:	8b 50 20             	mov    0x20(%eax),%edx
80102664:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
8010266b:	00 01 00 
8010266e:	8b 50 20             	mov    0x20(%eax),%edx
80102671:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102678:	00 01 00 
8010267b:	8b 50 20             	mov    0x20(%eax),%edx
8010267e:	8b 50 30             	mov    0x30(%eax),%edx
80102681:	c1 ea 10             	shr    $0x10,%edx
80102684:	80 fa 03             	cmp    $0x3,%dl
80102687:	77 6f                	ja     801026f8 <lapicinit+0xd8>
80102689:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102690:	00 00 00 
80102693:	8b 50 20             	mov    0x20(%eax),%edx
80102696:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010269d:	00 00 00 
801026a0:	8b 50 20             	mov    0x20(%eax),%edx
801026a3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026aa:	00 00 00 
801026ad:	8b 50 20             	mov    0x20(%eax),%edx
801026b0:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801026b7:	00 00 00 
801026ba:	8b 50 20             	mov    0x20(%eax),%edx
801026bd:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
801026c4:	00 00 00 
801026c7:	8b 50 20             	mov    0x20(%eax),%edx
801026ca:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801026d1:	85 08 00 
801026d4:	8b 50 20             	mov    0x20(%eax),%edx
801026d7:	90                   	nop
801026d8:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801026de:	80 e6 10             	and    $0x10,%dh
801026e1:	75 f5                	jne    801026d8 <lapicinit+0xb8>
801026e3:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801026ea:	00 00 00 
801026ed:	8b 40 20             	mov    0x20(%eax),%eax
801026f0:	5d                   	pop    %ebp
801026f1:	c3                   	ret    
801026f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801026f8:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
801026ff:	00 01 00 
80102702:	8b 50 20             	mov    0x20(%eax),%edx
80102705:	eb 82                	jmp    80102689 <lapicinit+0x69>
80102707:	89 f6                	mov    %esi,%esi
80102709:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102710 <lapicid>:
80102710:	a1 7c 26 11 80       	mov    0x8011267c,%eax
80102715:	55                   	push   %ebp
80102716:	89 e5                	mov    %esp,%ebp
80102718:	85 c0                	test   %eax,%eax
8010271a:	74 0c                	je     80102728 <lapicid+0x18>
8010271c:	8b 40 20             	mov    0x20(%eax),%eax
8010271f:	5d                   	pop    %ebp
80102720:	c1 e8 18             	shr    $0x18,%eax
80102723:	c3                   	ret    
80102724:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102728:	31 c0                	xor    %eax,%eax
8010272a:	5d                   	pop    %ebp
8010272b:	c3                   	ret    
8010272c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102730 <lapiceoi>:
80102730:	a1 7c 26 11 80       	mov    0x8011267c,%eax
80102735:	55                   	push   %ebp
80102736:	89 e5                	mov    %esp,%ebp
80102738:	85 c0                	test   %eax,%eax
8010273a:	74 0d                	je     80102749 <lapiceoi+0x19>
8010273c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102743:	00 00 00 
80102746:	8b 40 20             	mov    0x20(%eax),%eax
80102749:	5d                   	pop    %ebp
8010274a:	c3                   	ret    
8010274b:	90                   	nop
8010274c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102750 <microdelay>:
80102750:	55                   	push   %ebp
80102751:	89 e5                	mov    %esp,%ebp
80102753:	5d                   	pop    %ebp
80102754:	c3                   	ret    
80102755:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102759:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102760 <lapicstartap>:
80102760:	55                   	push   %ebp
80102761:	ba 70 00 00 00       	mov    $0x70,%edx
80102766:	89 e5                	mov    %esp,%ebp
80102768:	b8 0f 00 00 00       	mov    $0xf,%eax
8010276d:	53                   	push   %ebx
8010276e:	8b 4d 08             	mov    0x8(%ebp),%ecx
80102771:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80102774:	ee                   	out    %al,(%dx)
80102775:	b8 0a 00 00 00       	mov    $0xa,%eax
8010277a:	b2 71                	mov    $0x71,%dl
8010277c:	ee                   	out    %al,(%dx)
8010277d:	31 c0                	xor    %eax,%eax
8010277f:	66 a3 67 04 00 80    	mov    %ax,0x80000467
80102785:	89 d8                	mov    %ebx,%eax
80102787:	c1 e8 04             	shr    $0x4,%eax
8010278a:	66 a3 69 04 00 80    	mov    %ax,0x80000469
80102790:	a1 7c 26 11 80       	mov    0x8011267c,%eax
80102795:	c1 e1 18             	shl    $0x18,%ecx
80102798:	c1 eb 0c             	shr    $0xc,%ebx
8010279b:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
801027a1:	8b 50 20             	mov    0x20(%eax),%edx
801027a4:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
801027ab:	c5 00 00 
801027ae:	8b 50 20             	mov    0x20(%eax),%edx
801027b1:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801027b8:	85 00 00 
801027bb:	8b 50 20             	mov    0x20(%eax),%edx
801027be:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
801027c4:	8b 50 20             	mov    0x20(%eax),%edx
801027c7:	89 da                	mov    %ebx,%edx
801027c9:	80 ce 06             	or     $0x6,%dh
801027cc:	89 90 00 03 00 00    	mov    %edx,0x300(%eax)
801027d2:	8b 58 20             	mov    0x20(%eax),%ebx
801027d5:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
801027db:	8b 48 20             	mov    0x20(%eax),%ecx
801027de:	89 90 00 03 00 00    	mov    %edx,0x300(%eax)
801027e4:	8b 40 20             	mov    0x20(%eax),%eax
801027e7:	5b                   	pop    %ebx
801027e8:	5d                   	pop    %ebp
801027e9:	c3                   	ret    
801027ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801027f0 <cmostime>:
801027f0:	55                   	push   %ebp
801027f1:	ba 70 00 00 00       	mov    $0x70,%edx
801027f6:	89 e5                	mov    %esp,%ebp
801027f8:	b8 0b 00 00 00       	mov    $0xb,%eax
801027fd:	57                   	push   %edi
801027fe:	56                   	push   %esi
801027ff:	53                   	push   %ebx
80102800:	83 ec 4c             	sub    $0x4c,%esp
80102803:	ee                   	out    %al,(%dx)
80102804:	b2 71                	mov    $0x71,%dl
80102806:	ec                   	in     (%dx),%al
80102807:	88 45 b7             	mov    %al,-0x49(%ebp)
8010280a:	8d 5d b8             	lea    -0x48(%ebp),%ebx
8010280d:	80 65 b7 04          	andb   $0x4,-0x49(%ebp)
80102811:	8d 7d d0             	lea    -0x30(%ebp),%edi
80102814:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102818:	be 70 00 00 00       	mov    $0x70,%esi
8010281d:	89 d8                	mov    %ebx,%eax
8010281f:	e8 8c fd ff ff       	call   801025b0 <fill_rtcdate>
80102824:	b8 0a 00 00 00       	mov    $0xa,%eax
80102829:	89 f2                	mov    %esi,%edx
8010282b:	ee                   	out    %al,(%dx)
8010282c:	ba 71 00 00 00       	mov    $0x71,%edx
80102831:	ec                   	in     (%dx),%al
80102832:	84 c0                	test   %al,%al
80102834:	78 e7                	js     8010281d <cmostime+0x2d>
80102836:	89 f8                	mov    %edi,%eax
80102838:	e8 73 fd ff ff       	call   801025b0 <fill_rtcdate>
8010283d:	c7 44 24 08 18 00 00 	movl   $0x18,0x8(%esp)
80102844:	00 
80102845:	89 7c 24 04          	mov    %edi,0x4(%esp)
80102849:	89 1c 24             	mov    %ebx,(%esp)
8010284c:	e8 6f 1a 00 00       	call   801042c0 <memcmp>
80102851:	85 c0                	test   %eax,%eax
80102853:	75 c3                	jne    80102818 <cmostime+0x28>
80102855:	80 7d b7 00          	cmpb   $0x0,-0x49(%ebp)
80102859:	75 78                	jne    801028d3 <cmostime+0xe3>
8010285b:	8b 45 b8             	mov    -0x48(%ebp),%eax
8010285e:	89 c2                	mov    %eax,%edx
80102860:	83 e0 0f             	and    $0xf,%eax
80102863:	c1 ea 04             	shr    $0x4,%edx
80102866:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102869:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010286c:	89 45 b8             	mov    %eax,-0x48(%ebp)
8010286f:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102872:	89 c2                	mov    %eax,%edx
80102874:	83 e0 0f             	and    $0xf,%eax
80102877:	c1 ea 04             	shr    $0x4,%edx
8010287a:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010287d:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102880:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102883:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102886:	89 c2                	mov    %eax,%edx
80102888:	83 e0 0f             	and    $0xf,%eax
8010288b:	c1 ea 04             	shr    $0x4,%edx
8010288e:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102891:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102894:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102897:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010289a:	89 c2                	mov    %eax,%edx
8010289c:	83 e0 0f             	and    $0xf,%eax
8010289f:	c1 ea 04             	shr    $0x4,%edx
801028a2:	8d 14 92             	lea    (%edx,%edx,4),%edx
801028a5:	8d 04 50             	lea    (%eax,%edx,2),%eax
801028a8:	89 45 c4             	mov    %eax,-0x3c(%ebp)
801028ab:	8b 45 c8             	mov    -0x38(%ebp),%eax
801028ae:	89 c2                	mov    %eax,%edx
801028b0:	83 e0 0f             	and    $0xf,%eax
801028b3:	c1 ea 04             	shr    $0x4,%edx
801028b6:	8d 14 92             	lea    (%edx,%edx,4),%edx
801028b9:	8d 04 50             	lea    (%eax,%edx,2),%eax
801028bc:	89 45 c8             	mov    %eax,-0x38(%ebp)
801028bf:	8b 45 cc             	mov    -0x34(%ebp),%eax
801028c2:	89 c2                	mov    %eax,%edx
801028c4:	83 e0 0f             	and    $0xf,%eax
801028c7:	c1 ea 04             	shr    $0x4,%edx
801028ca:	8d 14 92             	lea    (%edx,%edx,4),%edx
801028cd:	8d 04 50             	lea    (%eax,%edx,2),%eax
801028d0:	89 45 cc             	mov    %eax,-0x34(%ebp)
801028d3:	8b 4d 08             	mov    0x8(%ebp),%ecx
801028d6:	8b 45 b8             	mov    -0x48(%ebp),%eax
801028d9:	89 01                	mov    %eax,(%ecx)
801028db:	8b 45 bc             	mov    -0x44(%ebp),%eax
801028de:	89 41 04             	mov    %eax,0x4(%ecx)
801028e1:	8b 45 c0             	mov    -0x40(%ebp),%eax
801028e4:	89 41 08             	mov    %eax,0x8(%ecx)
801028e7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801028ea:	89 41 0c             	mov    %eax,0xc(%ecx)
801028ed:	8b 45 c8             	mov    -0x38(%ebp),%eax
801028f0:	89 41 10             	mov    %eax,0x10(%ecx)
801028f3:	8b 45 cc             	mov    -0x34(%ebp),%eax
801028f6:	89 41 14             	mov    %eax,0x14(%ecx)
801028f9:	81 41 14 d0 07 00 00 	addl   $0x7d0,0x14(%ecx)
80102900:	83 c4 4c             	add    $0x4c,%esp
80102903:	5b                   	pop    %ebx
80102904:	5e                   	pop    %esi
80102905:	5f                   	pop    %edi
80102906:	5d                   	pop    %ebp
80102907:	c3                   	ret    
	...

80102910 <install_trans>:
80102910:	55                   	push   %ebp
80102911:	89 e5                	mov    %esp,%ebp
80102913:	57                   	push   %edi
80102914:	56                   	push   %esi
80102915:	53                   	push   %ebx
80102916:	31 db                	xor    %ebx,%ebx
80102918:	83 ec 1c             	sub    $0x1c,%esp
8010291b:	a1 c8 26 11 80       	mov    0x801126c8,%eax
80102920:	85 c0                	test   %eax,%eax
80102922:	7e 78                	jle    8010299c <install_trans+0x8c>
80102924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102928:	a1 b4 26 11 80       	mov    0x801126b4,%eax
8010292d:	01 d8                	add    %ebx,%eax
8010292f:	83 c0 01             	add    $0x1,%eax
80102932:	89 44 24 04          	mov    %eax,0x4(%esp)
80102936:	a1 c4 26 11 80       	mov    0x801126c4,%eax
8010293b:	89 04 24             	mov    %eax,(%esp)
8010293e:	e8 8d d7 ff ff       	call   801000d0 <bread>
80102943:	89 c7                	mov    %eax,%edi
80102945:	8b 04 9d cc 26 11 80 	mov    -0x7feed934(,%ebx,4),%eax
8010294c:	83 c3 01             	add    $0x1,%ebx
8010294f:	89 44 24 04          	mov    %eax,0x4(%esp)
80102953:	a1 c4 26 11 80       	mov    0x801126c4,%eax
80102958:	89 04 24             	mov    %eax,(%esp)
8010295b:	e8 70 d7 ff ff       	call   801000d0 <bread>
80102960:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80102967:	00 
80102968:	89 c6                	mov    %eax,%esi
8010296a:	8d 47 5c             	lea    0x5c(%edi),%eax
8010296d:	89 44 24 04          	mov    %eax,0x4(%esp)
80102971:	8d 46 5c             	lea    0x5c(%esi),%eax
80102974:	89 04 24             	mov    %eax,(%esp)
80102977:	e8 94 19 00 00       	call   80104310 <memmove>
8010297c:	89 34 24             	mov    %esi,(%esp)
8010297f:	e8 1c d8 ff ff       	call   801001a0 <bwrite>
80102984:	89 3c 24             	mov    %edi,(%esp)
80102987:	e8 54 d8 ff ff       	call   801001e0 <brelse>
8010298c:	89 34 24             	mov    %esi,(%esp)
8010298f:	e8 4c d8 ff ff       	call   801001e0 <brelse>
80102994:	39 1d c8 26 11 80    	cmp    %ebx,0x801126c8
8010299a:	7f 8c                	jg     80102928 <install_trans+0x18>
8010299c:	83 c4 1c             	add    $0x1c,%esp
8010299f:	5b                   	pop    %ebx
801029a0:	5e                   	pop    %esi
801029a1:	5f                   	pop    %edi
801029a2:	5d                   	pop    %ebp
801029a3:	c3                   	ret    
801029a4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801029aa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801029b0 <write_head>:
801029b0:	55                   	push   %ebp
801029b1:	89 e5                	mov    %esp,%ebp
801029b3:	57                   	push   %edi
801029b4:	56                   	push   %esi
801029b5:	53                   	push   %ebx
801029b6:	83 ec 1c             	sub    $0x1c,%esp
801029b9:	a1 b4 26 11 80       	mov    0x801126b4,%eax
801029be:	89 44 24 04          	mov    %eax,0x4(%esp)
801029c2:	a1 c4 26 11 80       	mov    0x801126c4,%eax
801029c7:	89 04 24             	mov    %eax,(%esp)
801029ca:	e8 01 d7 ff ff       	call   801000d0 <bread>
801029cf:	8b 1d c8 26 11 80    	mov    0x801126c8,%ebx
801029d5:	31 d2                	xor    %edx,%edx
801029d7:	85 db                	test   %ebx,%ebx
801029d9:	89 c7                	mov    %eax,%edi
801029db:	89 58 5c             	mov    %ebx,0x5c(%eax)
801029de:	8d 70 5c             	lea    0x5c(%eax),%esi
801029e1:	7e 17                	jle    801029fa <write_head+0x4a>
801029e3:	90                   	nop
801029e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801029e8:	8b 0c 95 cc 26 11 80 	mov    -0x7feed934(,%edx,4),%ecx
801029ef:	89 4c 96 04          	mov    %ecx,0x4(%esi,%edx,4)
801029f3:	83 c2 01             	add    $0x1,%edx
801029f6:	39 da                	cmp    %ebx,%edx
801029f8:	75 ee                	jne    801029e8 <write_head+0x38>
801029fa:	89 3c 24             	mov    %edi,(%esp)
801029fd:	e8 9e d7 ff ff       	call   801001a0 <bwrite>
80102a02:	89 3c 24             	mov    %edi,(%esp)
80102a05:	e8 d6 d7 ff ff       	call   801001e0 <brelse>
80102a0a:	83 c4 1c             	add    $0x1c,%esp
80102a0d:	5b                   	pop    %ebx
80102a0e:	5e                   	pop    %esi
80102a0f:	5f                   	pop    %edi
80102a10:	5d                   	pop    %ebp
80102a11:	c3                   	ret    
80102a12:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102a20 <initlog>:
80102a20:	55                   	push   %ebp
80102a21:	89 e5                	mov    %esp,%ebp
80102a23:	56                   	push   %esi
80102a24:	53                   	push   %ebx
80102a25:	83 ec 30             	sub    $0x30,%esp
80102a28:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102a2b:	c7 44 24 04 c0 72 10 	movl   $0x801072c0,0x4(%esp)
80102a32:	80 
80102a33:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102a3a:	e8 01 16 00 00       	call   80104040 <initlock>
80102a3f:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102a42:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a46:	89 1c 24             	mov    %ebx,(%esp)
80102a49:	e8 02 e9 ff ff       	call   80101350 <readsb>
80102a4e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102a51:	8b 55 e8             	mov    -0x18(%ebp),%edx
80102a54:	89 1c 24             	mov    %ebx,(%esp)
80102a57:	89 1d c4 26 11 80    	mov    %ebx,0x801126c4
80102a5d:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a61:	89 15 b8 26 11 80    	mov    %edx,0x801126b8
80102a67:	a3 b4 26 11 80       	mov    %eax,0x801126b4
80102a6c:	e8 5f d6 ff ff       	call   801000d0 <bread>
80102a71:	31 d2                	xor    %edx,%edx
80102a73:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102a76:	8d 70 5c             	lea    0x5c(%eax),%esi
80102a79:	85 db                	test   %ebx,%ebx
80102a7b:	89 1d c8 26 11 80    	mov    %ebx,0x801126c8
80102a81:	7e 17                	jle    80102a9a <initlog+0x7a>
80102a83:	90                   	nop
80102a84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102a88:	8b 4c 96 04          	mov    0x4(%esi,%edx,4),%ecx
80102a8c:	89 0c 95 cc 26 11 80 	mov    %ecx,-0x7feed934(,%edx,4)
80102a93:	83 c2 01             	add    $0x1,%edx
80102a96:	39 da                	cmp    %ebx,%edx
80102a98:	75 ee                	jne    80102a88 <initlog+0x68>
80102a9a:	89 04 24             	mov    %eax,(%esp)
80102a9d:	e8 3e d7 ff ff       	call   801001e0 <brelse>
80102aa2:	e8 69 fe ff ff       	call   80102910 <install_trans>
80102aa7:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102aae:	00 00 00 
80102ab1:	e8 fa fe ff ff       	call   801029b0 <write_head>
80102ab6:	83 c4 30             	add    $0x30,%esp
80102ab9:	5b                   	pop    %ebx
80102aba:	5e                   	pop    %esi
80102abb:	5d                   	pop    %ebp
80102abc:	c3                   	ret    
80102abd:	8d 76 00             	lea    0x0(%esi),%esi

80102ac0 <begin_op>:
80102ac0:	55                   	push   %ebp
80102ac1:	89 e5                	mov    %esp,%ebp
80102ac3:	83 ec 18             	sub    $0x18,%esp
80102ac6:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102acd:	e8 5e 16 00 00       	call   80104130 <acquire>
80102ad2:	eb 18                	jmp    80102aec <begin_op+0x2c>
80102ad4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102ad8:	c7 44 24 04 80 26 11 	movl   $0x80112680,0x4(%esp)
80102adf:	80 
80102ae0:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102ae7:	e8 e4 10 00 00       	call   80103bd0 <sleep>
80102aec:	8b 15 c0 26 11 80    	mov    0x801126c0,%edx
80102af2:	85 d2                	test   %edx,%edx
80102af4:	75 e2                	jne    80102ad8 <begin_op+0x18>
80102af6:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102afb:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102b01:	83 c0 01             	add    $0x1,%eax
80102b04:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102b07:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102b0a:	83 fa 1e             	cmp    $0x1e,%edx
80102b0d:	7f c9                	jg     80102ad8 <begin_op+0x18>
80102b0f:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102b16:	a3 bc 26 11 80       	mov    %eax,0x801126bc
80102b1b:	e8 00 17 00 00       	call   80104220 <release>
80102b20:	c9                   	leave  
80102b21:	c3                   	ret    
80102b22:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102b29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102b30 <end_op>:
80102b30:	55                   	push   %ebp
80102b31:	89 e5                	mov    %esp,%ebp
80102b33:	57                   	push   %edi
80102b34:	56                   	push   %esi
80102b35:	53                   	push   %ebx
80102b36:	83 ec 1c             	sub    $0x1c,%esp
80102b39:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102b40:	e8 eb 15 00 00       	call   80104130 <acquire>
80102b45:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102b4a:	8b 1d c0 26 11 80    	mov    0x801126c0,%ebx
80102b50:	83 e8 01             	sub    $0x1,%eax
80102b53:	85 db                	test   %ebx,%ebx
80102b55:	a3 bc 26 11 80       	mov    %eax,0x801126bc
80102b5a:	0f 85 f3 00 00 00    	jne    80102c53 <end_op+0x123>
80102b60:	85 c0                	test   %eax,%eax
80102b62:	0f 85 cb 00 00 00    	jne    80102c33 <end_op+0x103>
80102b68:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102b6f:	31 db                	xor    %ebx,%ebx
80102b71:	c7 05 c0 26 11 80 01 	movl   $0x1,0x801126c0
80102b78:	00 00 00 
80102b7b:	e8 a0 16 00 00       	call   80104220 <release>
80102b80:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102b86:	85 c9                	test   %ecx,%ecx
80102b88:	0f 8e 8f 00 00 00    	jle    80102c1d <end_op+0xed>
80102b8e:	66 90                	xchg   %ax,%ax
80102b90:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102b95:	01 d8                	add    %ebx,%eax
80102b97:	83 c0 01             	add    $0x1,%eax
80102b9a:	89 44 24 04          	mov    %eax,0x4(%esp)
80102b9e:	a1 c4 26 11 80       	mov    0x801126c4,%eax
80102ba3:	89 04 24             	mov    %eax,(%esp)
80102ba6:	e8 25 d5 ff ff       	call   801000d0 <bread>
80102bab:	89 c6                	mov    %eax,%esi
80102bad:	8b 04 9d cc 26 11 80 	mov    -0x7feed934(,%ebx,4),%eax
80102bb4:	83 c3 01             	add    $0x1,%ebx
80102bb7:	89 44 24 04          	mov    %eax,0x4(%esp)
80102bbb:	a1 c4 26 11 80       	mov    0x801126c4,%eax
80102bc0:	89 04 24             	mov    %eax,(%esp)
80102bc3:	e8 08 d5 ff ff       	call   801000d0 <bread>
80102bc8:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80102bcf:	00 
80102bd0:	89 c7                	mov    %eax,%edi
80102bd2:	8d 40 5c             	lea    0x5c(%eax),%eax
80102bd5:	89 44 24 04          	mov    %eax,0x4(%esp)
80102bd9:	8d 46 5c             	lea    0x5c(%esi),%eax
80102bdc:	89 04 24             	mov    %eax,(%esp)
80102bdf:	e8 2c 17 00 00       	call   80104310 <memmove>
80102be4:	89 34 24             	mov    %esi,(%esp)
80102be7:	e8 b4 d5 ff ff       	call   801001a0 <bwrite>
80102bec:	89 3c 24             	mov    %edi,(%esp)
80102bef:	e8 ec d5 ff ff       	call   801001e0 <brelse>
80102bf4:	89 34 24             	mov    %esi,(%esp)
80102bf7:	e8 e4 d5 ff ff       	call   801001e0 <brelse>
80102bfc:	3b 1d c8 26 11 80    	cmp    0x801126c8,%ebx
80102c02:	7c 8c                	jl     80102b90 <end_op+0x60>
80102c04:	e8 a7 fd ff ff       	call   801029b0 <write_head>
80102c09:	e8 02 fd ff ff       	call   80102910 <install_trans>
80102c0e:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102c15:	00 00 00 
80102c18:	e8 93 fd ff ff       	call   801029b0 <write_head>
80102c1d:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102c24:	e8 07 15 00 00       	call   80104130 <acquire>
80102c29:	c7 05 c0 26 11 80 00 	movl   $0x0,0x801126c0
80102c30:	00 00 00 
80102c33:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102c3a:	e8 31 11 00 00       	call   80103d70 <wakeup>
80102c3f:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102c46:	e8 d5 15 00 00       	call   80104220 <release>
80102c4b:	83 c4 1c             	add    $0x1c,%esp
80102c4e:	5b                   	pop    %ebx
80102c4f:	5e                   	pop    %esi
80102c50:	5f                   	pop    %edi
80102c51:	5d                   	pop    %ebp
80102c52:	c3                   	ret    
80102c53:	c7 04 24 c4 72 10 80 	movl   $0x801072c4,(%esp)
80102c5a:	e8 01 d7 ff ff       	call   80100360 <panic>
80102c5f:	90                   	nop

80102c60 <log_write>:
80102c60:	55                   	push   %ebp
80102c61:	89 e5                	mov    %esp,%ebp
80102c63:	53                   	push   %ebx
80102c64:	83 ec 14             	sub    $0x14,%esp
80102c67:	a1 c8 26 11 80       	mov    0x801126c8,%eax
80102c6c:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102c6f:	83 f8 1d             	cmp    $0x1d,%eax
80102c72:	0f 8f 98 00 00 00    	jg     80102d10 <log_write+0xb0>
80102c78:	8b 0d b8 26 11 80    	mov    0x801126b8,%ecx
80102c7e:	8d 51 ff             	lea    -0x1(%ecx),%edx
80102c81:	39 d0                	cmp    %edx,%eax
80102c83:	0f 8d 87 00 00 00    	jge    80102d10 <log_write+0xb0>
80102c89:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102c8e:	85 c0                	test   %eax,%eax
80102c90:	0f 8e 86 00 00 00    	jle    80102d1c <log_write+0xbc>
80102c96:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102c9d:	e8 8e 14 00 00       	call   80104130 <acquire>
80102ca2:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102ca8:	83 fa 00             	cmp    $0x0,%edx
80102cab:	7e 54                	jle    80102d01 <log_write+0xa1>
80102cad:	8b 4b 08             	mov    0x8(%ebx),%ecx
80102cb0:	31 c0                	xor    %eax,%eax
80102cb2:	39 0d cc 26 11 80    	cmp    %ecx,0x801126cc
80102cb8:	75 0f                	jne    80102cc9 <log_write+0x69>
80102cba:	eb 3c                	jmp    80102cf8 <log_write+0x98>
80102cbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102cc0:	39 0c 85 cc 26 11 80 	cmp    %ecx,-0x7feed934(,%eax,4)
80102cc7:	74 2f                	je     80102cf8 <log_write+0x98>
80102cc9:	83 c0 01             	add    $0x1,%eax
80102ccc:	39 d0                	cmp    %edx,%eax
80102cce:	75 f0                	jne    80102cc0 <log_write+0x60>
80102cd0:	89 0c 95 cc 26 11 80 	mov    %ecx,-0x7feed934(,%edx,4)
80102cd7:	83 c2 01             	add    $0x1,%edx
80102cda:	89 15 c8 26 11 80    	mov    %edx,0x801126c8
80102ce0:	83 0b 04             	orl    $0x4,(%ebx)
80102ce3:	c7 45 08 80 26 11 80 	movl   $0x80112680,0x8(%ebp)
80102cea:	83 c4 14             	add    $0x14,%esp
80102ced:	5b                   	pop    %ebx
80102cee:	5d                   	pop    %ebp
80102cef:	e9 2c 15 00 00       	jmp    80104220 <release>
80102cf4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102cf8:	89 0c 85 cc 26 11 80 	mov    %ecx,-0x7feed934(,%eax,4)
80102cff:	eb df                	jmp    80102ce0 <log_write+0x80>
80102d01:	8b 43 08             	mov    0x8(%ebx),%eax
80102d04:	a3 cc 26 11 80       	mov    %eax,0x801126cc
80102d09:	75 d5                	jne    80102ce0 <log_write+0x80>
80102d0b:	eb ca                	jmp    80102cd7 <log_write+0x77>
80102d0d:	8d 76 00             	lea    0x0(%esi),%esi
80102d10:	c7 04 24 d3 72 10 80 	movl   $0x801072d3,(%esp)
80102d17:	e8 44 d6 ff ff       	call   80100360 <panic>
80102d1c:	c7 04 24 e9 72 10 80 	movl   $0x801072e9,(%esp)
80102d23:	e8 38 d6 ff ff       	call   80100360 <panic>
	...

80102d30 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102d30:	55                   	push   %ebp
80102d31:	89 e5                	mov    %esp,%ebp
80102d33:	53                   	push   %ebx
80102d34:	83 ec 14             	sub    $0x14,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102d37:	e8 04 09 00 00       	call   80103640 <cpuid>
80102d3c:	89 c3                	mov    %eax,%ebx
80102d3e:	e8 fd 08 00 00       	call   80103640 <cpuid>
80102d43:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80102d47:	c7 04 24 04 73 10 80 	movl   $0x80107304,(%esp)
80102d4e:	89 44 24 04          	mov    %eax,0x4(%esp)
80102d52:	e8 f9 d8 ff ff       	call   80100650 <cprintf>
  idtinit();       // load idt register
80102d57:	e8 24 28 00 00       	call   80105580 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102d5c:	e8 5f 08 00 00       	call   801035c0 <mycpu>
80102d61:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102d63:	b8 01 00 00 00       	mov    $0x1,%eax
80102d68:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102d6f:	e8 ac 0b 00 00       	call   80103920 <scheduler>
80102d74:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102d7a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80102d80 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80102d80:	55                   	push   %ebp
80102d81:	89 e5                	mov    %esp,%ebp
80102d83:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102d86:	e8 c5 39 00 00       	call   80106750 <switchkvm>
  seginit();
80102d8b:	e8 80 38 00 00       	call   80106610 <seginit>
  lapicinit();
80102d90:	e8 8b f8 ff ff       	call   80102620 <lapicinit>
  mpmain();
80102d95:	e8 96 ff ff ff       	call   80102d30 <mpmain>
80102d9a:	00 00                	add    %al,(%eax)
80102d9c:	00 00                	add    %al,(%eax)
	...

80102da0 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80102da0:	55                   	push   %ebp
80102da1:	89 e5                	mov    %esp,%ebp
80102da3:	53                   	push   %ebx
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80102da4:	bb 80 27 11 80       	mov    $0x80112780,%ebx
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80102da9:	83 e4 f0             	and    $0xfffffff0,%esp
80102dac:	83 ec 10             	sub    $0x10,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102daf:	c7 44 24 04 00 00 40 	movl   $0x80400000,0x4(%esp)
80102db6:	80 
80102db7:	c7 04 24 a8 57 11 80 	movl   $0x801157a8,(%esp)
80102dbe:	e8 dd f5 ff ff       	call   801023a0 <kinit1>
  kvmalloc();      // kernel page table
80102dc3:	e8 38 3e 00 00       	call   80106c00 <kvmalloc>
  mpinit();        // detect other processors
80102dc8:	e8 73 01 00 00       	call   80102f40 <mpinit>
80102dcd:	8d 76 00             	lea    0x0(%esi),%esi
  lapicinit();     // interrupt controller
80102dd0:	e8 4b f8 ff ff       	call   80102620 <lapicinit>
  seginit();       // segment descriptors
80102dd5:	e8 36 38 00 00       	call   80106610 <seginit>
  picinit();       // disable pic
80102dda:	e8 21 03 00 00       	call   80103100 <picinit>
80102ddf:	90                   	nop
  ioapicinit();    // another interrupt controller
80102de0:	e8 db f3 ff ff       	call   801021c0 <ioapicinit>
  consoleinit();   // console hardware
80102de5:	e8 66 db ff ff       	call   80100950 <consoleinit>
  uartinit();      // serial port
80102dea:	e8 d1 2b 00 00       	call   801059c0 <uartinit>
80102def:	90                   	nop
  pinit();         // process table
80102df0:	e8 ab 07 00 00       	call   801035a0 <pinit>
  tvinit();        // trap vectors
80102df5:	e8 e6 26 00 00       	call   801054e0 <tvinit>
  binit();         // buffer cache
80102dfa:	e8 41 d2 ff ff       	call   80100040 <binit>
80102dff:	90                   	nop
  fileinit();      // file table
80102e00:	e8 4b df ff ff       	call   80100d50 <fileinit>
  ideinit();       // disk 
80102e05:	e8 b6 f1 ff ff       	call   80101fc0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102e0a:	c7 44 24 08 8a 00 00 	movl   $0x8a,0x8(%esp)
80102e11:	00 
80102e12:	c7 44 24 04 8c a4 10 	movl   $0x8010a48c,0x4(%esp)
80102e19:	80 
80102e1a:	c7 04 24 00 70 00 80 	movl   $0x80007000,(%esp)
80102e21:	e8 ea 14 00 00       	call   80104310 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102e26:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80102e2d:	00 00 00 
80102e30:	05 80 27 11 80       	add    $0x80112780,%eax
80102e35:	39 d8                	cmp    %ebx,%eax
80102e37:	76 6a                	jbe    80102ea3 <main+0x103>
80102e39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(c == mycpu())  // We've started already.
80102e40:	e8 7b 07 00 00       	call   801035c0 <mycpu>
80102e45:	39 d8                	cmp    %ebx,%eax
80102e47:	74 41                	je     80102e8a <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102e49:	e8 12 f6 ff ff       	call   80102460 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void**)(code-8) = mpenter;
80102e4e:	c7 05 f8 6f 00 80 80 	movl   $0x80102d80,0x80006ff8
80102e55:	2d 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102e58:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80102e5f:	90 10 00 

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
    *(void**)(code-4) = stack + KSTACKSIZE;
80102e62:	05 00 10 00 00       	add    $0x1000,%eax
80102e67:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    *(void**)(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80102e6c:	0f b6 03             	movzbl (%ebx),%eax
80102e6f:	c7 44 24 04 00 70 00 	movl   $0x7000,0x4(%esp)
80102e76:	00 
80102e77:	89 04 24             	mov    %eax,(%esp)
80102e7a:	e8 e1 f8 ff ff       	call   80102760 <lapicstartap>
80102e7f:	90                   	nop

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102e80:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102e86:	85 c0                	test   %eax,%eax
80102e88:	74 f6                	je     80102e80 <main+0xe0>
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80102e8a:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80102e91:	00 00 00 
80102e94:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102e9a:	05 80 27 11 80       	add    $0x80112780,%eax
80102e9f:	39 c3                	cmp    %eax,%ebx
80102ea1:	72 9d                	jb     80102e40 <main+0xa0>
  tvinit();        // trap vectors
  binit();         // buffer cache
  fileinit();      // file table
  ideinit();       // disk 
  startothers();   // start other processors
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102ea3:	c7 44 24 04 00 00 00 	movl   $0x8e000000,0x4(%esp)
80102eaa:	8e 
80102eab:	c7 04 24 00 00 40 80 	movl   $0x80400000,(%esp)
80102eb2:	e8 59 f5 ff ff       	call   80102410 <kinit2>
  userinit();      // first user process
80102eb7:	e8 d4 07 00 00       	call   80103690 <userinit>
  mpmain();        // finish this processor's setup
80102ebc:	e8 6f fe ff ff       	call   80102d30 <mpmain>
	...

80102ed0 <mpsearch1>:
80102ed0:	55                   	push   %ebp
80102ed1:	89 e5                	mov    %esp,%ebp
80102ed3:	56                   	push   %esi
80102ed4:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
80102eda:	53                   	push   %ebx
80102edb:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
80102ede:	83 ec 10             	sub    $0x10,%esp
80102ee1:	39 de                	cmp    %ebx,%esi
80102ee3:	73 3c                	jae    80102f21 <mpsearch1+0x51>
80102ee5:	8d 76 00             	lea    0x0(%esi),%esi
80102ee8:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80102eef:	00 
80102ef0:	c7 44 24 04 18 73 10 	movl   $0x80107318,0x4(%esp)
80102ef7:	80 
80102ef8:	89 34 24             	mov    %esi,(%esp)
80102efb:	e8 c0 13 00 00       	call   801042c0 <memcmp>
80102f00:	85 c0                	test   %eax,%eax
80102f02:	75 16                	jne    80102f1a <mpsearch1+0x4a>
80102f04:	31 c9                	xor    %ecx,%ecx
80102f06:	31 d2                	xor    %edx,%edx
80102f08:	0f b6 04 16          	movzbl (%esi,%edx,1),%eax
80102f0c:	83 c2 01             	add    $0x1,%edx
80102f0f:	01 c1                	add    %eax,%ecx
80102f11:	83 fa 10             	cmp    $0x10,%edx
80102f14:	75 f2                	jne    80102f08 <mpsearch1+0x38>
80102f16:	84 c9                	test   %cl,%cl
80102f18:	74 10                	je     80102f2a <mpsearch1+0x5a>
80102f1a:	83 c6 10             	add    $0x10,%esi
80102f1d:	39 f3                	cmp    %esi,%ebx
80102f1f:	77 c7                	ja     80102ee8 <mpsearch1+0x18>
80102f21:	83 c4 10             	add    $0x10,%esp
80102f24:	31 c0                	xor    %eax,%eax
80102f26:	5b                   	pop    %ebx
80102f27:	5e                   	pop    %esi
80102f28:	5d                   	pop    %ebp
80102f29:	c3                   	ret    
80102f2a:	83 c4 10             	add    $0x10,%esp
80102f2d:	89 f0                	mov    %esi,%eax
80102f2f:	5b                   	pop    %ebx
80102f30:	5e                   	pop    %esi
80102f31:	5d                   	pop    %ebp
80102f32:	c3                   	ret    
80102f33:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102f39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102f40 <mpinit>:
80102f40:	55                   	push   %ebp
80102f41:	89 e5                	mov    %esp,%ebp
80102f43:	57                   	push   %edi
80102f44:	56                   	push   %esi
80102f45:	53                   	push   %ebx
80102f46:	83 ec 1c             	sub    $0x1c,%esp
80102f49:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80102f50:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80102f57:	c1 e0 08             	shl    $0x8,%eax
80102f5a:	09 d0                	or     %edx,%eax
80102f5c:	c1 e0 04             	shl    $0x4,%eax
80102f5f:	85 c0                	test   %eax,%eax
80102f61:	75 1b                	jne    80102f7e <mpinit+0x3e>
80102f63:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80102f6a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80102f71:	c1 e0 08             	shl    $0x8,%eax
80102f74:	09 d0                	or     %edx,%eax
80102f76:	c1 e0 0a             	shl    $0xa,%eax
80102f79:	2d 00 04 00 00       	sub    $0x400,%eax
80102f7e:	ba 00 04 00 00       	mov    $0x400,%edx
80102f83:	e8 48 ff ff ff       	call   80102ed0 <mpsearch1>
80102f88:	85 c0                	test   %eax,%eax
80102f8a:	89 c7                	mov    %eax,%edi
80102f8c:	0f 84 22 01 00 00    	je     801030b4 <mpinit+0x174>
80102f92:	8b 77 04             	mov    0x4(%edi),%esi
80102f95:	85 f6                	test   %esi,%esi
80102f97:	0f 84 30 01 00 00    	je     801030cd <mpinit+0x18d>
80102f9d:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80102fa3:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80102faa:	00 
80102fab:	c7 44 24 04 1d 73 10 	movl   $0x8010731d,0x4(%esp)
80102fb2:	80 
80102fb3:	89 04 24             	mov    %eax,(%esp)
80102fb6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80102fb9:	e8 02 13 00 00       	call   801042c0 <memcmp>
80102fbe:	85 c0                	test   %eax,%eax
80102fc0:	0f 85 07 01 00 00    	jne    801030cd <mpinit+0x18d>
80102fc6:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
80102fcd:	3c 04                	cmp    $0x4,%al
80102fcf:	0f 85 0b 01 00 00    	jne    801030e0 <mpinit+0x1a0>
80102fd5:	0f b7 86 04 00 00 80 	movzwl -0x7ffffffc(%esi),%eax
80102fdc:	85 c0                	test   %eax,%eax
80102fde:	74 21                	je     80103001 <mpinit+0xc1>
80102fe0:	31 c9                	xor    %ecx,%ecx
80102fe2:	31 d2                	xor    %edx,%edx
80102fe4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102fe8:	0f b6 9c 16 00 00 00 	movzbl -0x80000000(%esi,%edx,1),%ebx
80102fef:	80 
80102ff0:	83 c2 01             	add    $0x1,%edx
80102ff3:	01 d9                	add    %ebx,%ecx
80102ff5:	39 d0                	cmp    %edx,%eax
80102ff7:	7f ef                	jg     80102fe8 <mpinit+0xa8>
80102ff9:	84 c9                	test   %cl,%cl
80102ffb:	0f 85 cc 00 00 00    	jne    801030cd <mpinit+0x18d>
80103001:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103004:	85 c0                	test   %eax,%eax
80103006:	0f 84 c1 00 00 00    	je     801030cd <mpinit+0x18d>
8010300c:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
80103012:	bb 01 00 00 00       	mov    $0x1,%ebx
80103017:	a3 7c 26 11 80       	mov    %eax,0x8011267c
8010301c:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
80103023:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
80103029:	03 55 e4             	add    -0x1c(%ebp),%edx
8010302c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103030:	39 c2                	cmp    %eax,%edx
80103032:	76 1b                	jbe    8010304f <mpinit+0x10f>
80103034:	0f b6 08             	movzbl (%eax),%ecx
80103037:	80 f9 04             	cmp    $0x4,%cl
8010303a:	77 74                	ja     801030b0 <mpinit+0x170>
8010303c:	ff 24 8d 5c 73 10 80 	jmp    *-0x7fef8ca4(,%ecx,4)
80103043:	90                   	nop
80103044:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103048:	83 c0 08             	add    $0x8,%eax
8010304b:	39 c2                	cmp    %eax,%edx
8010304d:	77 e5                	ja     80103034 <mpinit+0xf4>
8010304f:	85 db                	test   %ebx,%ebx
80103051:	0f 84 93 00 00 00    	je     801030ea <mpinit+0x1aa>
80103057:	80 7f 0c 00          	cmpb   $0x0,0xc(%edi)
8010305b:	74 12                	je     8010306f <mpinit+0x12f>
8010305d:	ba 22 00 00 00       	mov    $0x22,%edx
80103062:	b8 70 00 00 00       	mov    $0x70,%eax
80103067:	ee                   	out    %al,(%dx)
80103068:	b2 23                	mov    $0x23,%dl
8010306a:	ec                   	in     (%dx),%al
8010306b:	83 c8 01             	or     $0x1,%eax
8010306e:	ee                   	out    %al,(%dx)
8010306f:	83 c4 1c             	add    $0x1c,%esp
80103072:	5b                   	pop    %ebx
80103073:	5e                   	pop    %esi
80103074:	5f                   	pop    %edi
80103075:	5d                   	pop    %ebp
80103076:	c3                   	ret    
80103077:	90                   	nop
80103078:	8b 35 00 2d 11 80    	mov    0x80112d00,%esi
8010307e:	83 fe 07             	cmp    $0x7,%esi
80103081:	7f 17                	jg     8010309a <mpinit+0x15a>
80103083:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
80103087:	69 f6 b0 00 00 00    	imul   $0xb0,%esi,%esi
8010308d:	83 05 00 2d 11 80 01 	addl   $0x1,0x80112d00
80103094:	88 8e 80 27 11 80    	mov    %cl,-0x7feed880(%esi)
8010309a:	83 c0 14             	add    $0x14,%eax
8010309d:	eb 91                	jmp    80103030 <mpinit+0xf0>
8010309f:	90                   	nop
801030a0:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
801030a4:	83 c0 08             	add    $0x8,%eax
801030a7:	88 0d 60 27 11 80    	mov    %cl,0x80112760
801030ad:	eb 81                	jmp    80103030 <mpinit+0xf0>
801030af:	90                   	nop
801030b0:	31 db                	xor    %ebx,%ebx
801030b2:	eb 83                	jmp    80103037 <mpinit+0xf7>
801030b4:	ba 00 00 01 00       	mov    $0x10000,%edx
801030b9:	b8 00 00 0f 00       	mov    $0xf0000,%eax
801030be:	e8 0d fe ff ff       	call   80102ed0 <mpsearch1>
801030c3:	85 c0                	test   %eax,%eax
801030c5:	89 c7                	mov    %eax,%edi
801030c7:	0f 85 c5 fe ff ff    	jne    80102f92 <mpinit+0x52>
801030cd:	c7 04 24 22 73 10 80 	movl   $0x80107322,(%esp)
801030d4:	e8 87 d2 ff ff       	call   80100360 <panic>
801030d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801030e0:	3c 01                	cmp    $0x1,%al
801030e2:	0f 84 ed fe ff ff    	je     80102fd5 <mpinit+0x95>
801030e8:	eb e3                	jmp    801030cd <mpinit+0x18d>
801030ea:	c7 04 24 3c 73 10 80 	movl   $0x8010733c,(%esp)
801030f1:	e8 6a d2 ff ff       	call   80100360 <panic>
	...

80103100 <picinit>:
80103100:	55                   	push   %ebp
80103101:	ba 21 00 00 00       	mov    $0x21,%edx
80103106:	89 e5                	mov    %esp,%ebp
80103108:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010310d:	ee                   	out    %al,(%dx)
8010310e:	b2 a1                	mov    $0xa1,%dl
80103110:	ee                   	out    %al,(%dx)
80103111:	5d                   	pop    %ebp
80103112:	c3                   	ret    
	...

80103120 <pipealloc>:
80103120:	55                   	push   %ebp
80103121:	89 e5                	mov    %esp,%ebp
80103123:	57                   	push   %edi
80103124:	56                   	push   %esi
80103125:	53                   	push   %ebx
80103126:	83 ec 1c             	sub    $0x1c,%esp
80103129:	8b 75 08             	mov    0x8(%ebp),%esi
8010312c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010312f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103135:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010313b:	e8 30 dc ff ff       	call   80100d70 <filealloc>
80103140:	85 c0                	test   %eax,%eax
80103142:	89 06                	mov    %eax,(%esi)
80103144:	0f 84 a4 00 00 00    	je     801031ee <pipealloc+0xce>
8010314a:	e8 21 dc ff ff       	call   80100d70 <filealloc>
8010314f:	85 c0                	test   %eax,%eax
80103151:	89 03                	mov    %eax,(%ebx)
80103153:	0f 84 87 00 00 00    	je     801031e0 <pipealloc+0xc0>
80103159:	e8 02 f3 ff ff       	call   80102460 <kalloc>
8010315e:	85 c0                	test   %eax,%eax
80103160:	89 c7                	mov    %eax,%edi
80103162:	74 7c                	je     801031e0 <pipealloc+0xc0>
80103164:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010316b:	00 00 00 
8010316e:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103175:	00 00 00 
80103178:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010317f:	00 00 00 
80103182:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103189:	00 00 00 
8010318c:	89 04 24             	mov    %eax,(%esp)
8010318f:	c7 44 24 04 70 73 10 	movl   $0x80107370,0x4(%esp)
80103196:	80 
80103197:	e8 a4 0e 00 00       	call   80104040 <initlock>
8010319c:	8b 06                	mov    (%esi),%eax
8010319e:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
801031a4:	8b 06                	mov    (%esi),%eax
801031a6:	c6 40 08 01          	movb   $0x1,0x8(%eax)
801031aa:	8b 06                	mov    (%esi),%eax
801031ac:	c6 40 09 00          	movb   $0x0,0x9(%eax)
801031b0:	8b 06                	mov    (%esi),%eax
801031b2:	89 78 0c             	mov    %edi,0xc(%eax)
801031b5:	8b 03                	mov    (%ebx),%eax
801031b7:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
801031bd:	8b 03                	mov    (%ebx),%eax
801031bf:	c6 40 08 00          	movb   $0x0,0x8(%eax)
801031c3:	8b 03                	mov    (%ebx),%eax
801031c5:	c6 40 09 01          	movb   $0x1,0x9(%eax)
801031c9:	8b 03                	mov    (%ebx),%eax
801031cb:	31 db                	xor    %ebx,%ebx
801031cd:	89 78 0c             	mov    %edi,0xc(%eax)
801031d0:	83 c4 1c             	add    $0x1c,%esp
801031d3:	89 d8                	mov    %ebx,%eax
801031d5:	5b                   	pop    %ebx
801031d6:	5e                   	pop    %esi
801031d7:	5f                   	pop    %edi
801031d8:	5d                   	pop    %ebp
801031d9:	c3                   	ret    
801031da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801031e0:	8b 06                	mov    (%esi),%eax
801031e2:	85 c0                	test   %eax,%eax
801031e4:	74 08                	je     801031ee <pipealloc+0xce>
801031e6:	89 04 24             	mov    %eax,(%esp)
801031e9:	e8 f2 db ff ff       	call   80100de0 <fileclose>
801031ee:	8b 03                	mov    (%ebx),%eax
801031f0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801031f5:	85 c0                	test   %eax,%eax
801031f7:	74 d7                	je     801031d0 <pipealloc+0xb0>
801031f9:	89 04 24             	mov    %eax,(%esp)
801031fc:	e8 df db ff ff       	call   80100de0 <fileclose>
80103201:	83 c4 1c             	add    $0x1c,%esp
80103204:	89 d8                	mov    %ebx,%eax
80103206:	5b                   	pop    %ebx
80103207:	5e                   	pop    %esi
80103208:	5f                   	pop    %edi
80103209:	5d                   	pop    %ebp
8010320a:	c3                   	ret    
8010320b:	90                   	nop
8010320c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103210 <pipeclose>:
80103210:	55                   	push   %ebp
80103211:	89 e5                	mov    %esp,%ebp
80103213:	56                   	push   %esi
80103214:	53                   	push   %ebx
80103215:	83 ec 10             	sub    $0x10,%esp
80103218:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010321b:	8b 75 0c             	mov    0xc(%ebp),%esi
8010321e:	89 1c 24             	mov    %ebx,(%esp)
80103221:	e8 0a 0f 00 00       	call   80104130 <acquire>
80103226:	85 f6                	test   %esi,%esi
80103228:	74 3e                	je     80103268 <pipeclose+0x58>
8010322a:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103230:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80103237:	00 00 00 
8010323a:	89 04 24             	mov    %eax,(%esp)
8010323d:	e8 2e 0b 00 00       	call   80103d70 <wakeup>
80103242:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80103248:	85 d2                	test   %edx,%edx
8010324a:	75 0a                	jne    80103256 <pipeclose+0x46>
8010324c:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103252:	85 c0                	test   %eax,%eax
80103254:	74 32                	je     80103288 <pipeclose+0x78>
80103256:	89 5d 08             	mov    %ebx,0x8(%ebp)
80103259:	83 c4 10             	add    $0x10,%esp
8010325c:	5b                   	pop    %ebx
8010325d:	5e                   	pop    %esi
8010325e:	5d                   	pop    %ebp
8010325f:	e9 bc 0f 00 00       	jmp    80104220 <release>
80103264:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103268:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
8010326e:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103275:	00 00 00 
80103278:	89 04 24             	mov    %eax,(%esp)
8010327b:	e8 f0 0a 00 00       	call   80103d70 <wakeup>
80103280:	eb c0                	jmp    80103242 <pipeclose+0x32>
80103282:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103288:	89 1c 24             	mov    %ebx,(%esp)
8010328b:	e8 90 0f 00 00       	call   80104220 <release>
80103290:	89 5d 08             	mov    %ebx,0x8(%ebp)
80103293:	83 c4 10             	add    $0x10,%esp
80103296:	5b                   	pop    %ebx
80103297:	5e                   	pop    %esi
80103298:	5d                   	pop    %ebp
80103299:	e9 12 f0 ff ff       	jmp    801022b0 <kfree>
8010329e:	66 90                	xchg   %ax,%ax

801032a0 <pipewrite>:
801032a0:	55                   	push   %ebp
801032a1:	89 e5                	mov    %esp,%ebp
801032a3:	57                   	push   %edi
801032a4:	56                   	push   %esi
801032a5:	53                   	push   %ebx
801032a6:	83 ec 1c             	sub    $0x1c,%esp
801032a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801032ac:	89 1c 24             	mov    %ebx,(%esp)
801032af:	e8 7c 0e 00 00       	call   80104130 <acquire>
801032b4:	8b 45 10             	mov    0x10(%ebp),%eax
801032b7:	85 c0                	test   %eax,%eax
801032b9:	0f 8e b2 00 00 00    	jle    80103371 <pipewrite+0xd1>
801032bf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801032c2:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
801032c8:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
801032ce:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
801032d4:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801032d7:	03 4d 10             	add    0x10(%ebp),%ecx
801032da:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801032dd:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
801032e3:	81 c1 00 02 00 00    	add    $0x200,%ecx
801032e9:	39 c8                	cmp    %ecx,%eax
801032eb:	74 38                	je     80103325 <pipewrite+0x85>
801032ed:	eb 55                	jmp    80103344 <pipewrite+0xa4>
801032ef:	90                   	nop
801032f0:	e8 6b 03 00 00       	call   80103660 <myproc>
801032f5:	8b 48 24             	mov    0x24(%eax),%ecx
801032f8:	85 c9                	test   %ecx,%ecx
801032fa:	75 33                	jne    8010332f <pipewrite+0x8f>
801032fc:	89 3c 24             	mov    %edi,(%esp)
801032ff:	e8 6c 0a 00 00       	call   80103d70 <wakeup>
80103304:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80103308:	89 34 24             	mov    %esi,(%esp)
8010330b:	e8 c0 08 00 00       	call   80103bd0 <sleep>
80103310:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103316:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010331c:	05 00 02 00 00       	add    $0x200,%eax
80103321:	39 c2                	cmp    %eax,%edx
80103323:	75 23                	jne    80103348 <pipewrite+0xa8>
80103325:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010332b:	85 c0                	test   %eax,%eax
8010332d:	75 c1                	jne    801032f0 <pipewrite+0x50>
8010332f:	89 1c 24             	mov    %ebx,(%esp)
80103332:	e8 e9 0e 00 00       	call   80104220 <release>
80103337:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010333c:	83 c4 1c             	add    $0x1c,%esp
8010333f:	5b                   	pop    %ebx
80103340:	5e                   	pop    %esi
80103341:	5f                   	pop    %edi
80103342:	5d                   	pop    %ebp
80103343:	c3                   	ret    
80103344:	89 c2                	mov    %eax,%edx
80103346:	66 90                	xchg   %ax,%ax
80103348:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010334b:	8d 42 01             	lea    0x1(%edx),%eax
8010334e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103354:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
8010335a:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
8010335e:	0f b6 09             	movzbl (%ecx),%ecx
80103361:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
80103365:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103368:	3b 4d e0             	cmp    -0x20(%ebp),%ecx
8010336b:	0f 85 6c ff ff ff    	jne    801032dd <pipewrite+0x3d>
80103371:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103377:	89 04 24             	mov    %eax,(%esp)
8010337a:	e8 f1 09 00 00       	call   80103d70 <wakeup>
8010337f:	89 1c 24             	mov    %ebx,(%esp)
80103382:	e8 99 0e 00 00       	call   80104220 <release>
80103387:	8b 45 10             	mov    0x10(%ebp),%eax
8010338a:	eb b0                	jmp    8010333c <pipewrite+0x9c>
8010338c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103390 <piperead>:
80103390:	55                   	push   %ebp
80103391:	89 e5                	mov    %esp,%ebp
80103393:	57                   	push   %edi
80103394:	56                   	push   %esi
80103395:	53                   	push   %ebx
80103396:	83 ec 1c             	sub    $0x1c,%esp
80103399:	8b 75 08             	mov    0x8(%ebp),%esi
8010339c:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010339f:	89 34 24             	mov    %esi,(%esp)
801033a2:	e8 89 0d 00 00       	call   80104130 <acquire>
801033a7:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801033ad:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
801033b3:	75 5b                	jne    80103410 <piperead+0x80>
801033b5:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
801033bb:	85 db                	test   %ebx,%ebx
801033bd:	74 51                	je     80103410 <piperead+0x80>
801033bf:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801033c5:	eb 25                	jmp    801033ec <piperead+0x5c>
801033c7:	90                   	nop
801033c8:	89 74 24 04          	mov    %esi,0x4(%esp)
801033cc:	89 1c 24             	mov    %ebx,(%esp)
801033cf:	e8 fc 07 00 00       	call   80103bd0 <sleep>
801033d4:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801033da:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
801033e0:	75 2e                	jne    80103410 <piperead+0x80>
801033e2:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
801033e8:	85 d2                	test   %edx,%edx
801033ea:	74 24                	je     80103410 <piperead+0x80>
801033ec:	e8 6f 02 00 00       	call   80103660 <myproc>
801033f1:	8b 48 24             	mov    0x24(%eax),%ecx
801033f4:	85 c9                	test   %ecx,%ecx
801033f6:	74 d0                	je     801033c8 <piperead+0x38>
801033f8:	89 34 24             	mov    %esi,(%esp)
801033fb:	e8 20 0e 00 00       	call   80104220 <release>
80103400:	83 c4 1c             	add    $0x1c,%esp
80103403:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103408:	5b                   	pop    %ebx
80103409:	5e                   	pop    %esi
8010340a:	5f                   	pop    %edi
8010340b:	5d                   	pop    %ebp
8010340c:	c3                   	ret    
8010340d:	8d 76 00             	lea    0x0(%esi),%esi
80103410:	8b 55 10             	mov    0x10(%ebp),%edx
80103413:	31 db                	xor    %ebx,%ebx
80103415:	85 d2                	test   %edx,%edx
80103417:	7f 2b                	jg     80103444 <piperead+0xb4>
80103419:	eb 31                	jmp    8010344c <piperead+0xbc>
8010341b:	90                   	nop
8010341c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103420:	8d 48 01             	lea    0x1(%eax),%ecx
80103423:	25 ff 01 00 00       	and    $0x1ff,%eax
80103428:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010342e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103433:	88 04 1f             	mov    %al,(%edi,%ebx,1)
80103436:	83 c3 01             	add    $0x1,%ebx
80103439:	3b 5d 10             	cmp    0x10(%ebp),%ebx
8010343c:	74 0e                	je     8010344c <piperead+0xbc>
8010343e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103444:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010344a:	75 d4                	jne    80103420 <piperead+0x90>
8010344c:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103452:	89 04 24             	mov    %eax,(%esp)
80103455:	e8 16 09 00 00       	call   80103d70 <wakeup>
8010345a:	89 34 24             	mov    %esi,(%esp)
8010345d:	e8 be 0d 00 00       	call   80104220 <release>
80103462:	83 c4 1c             	add    $0x1c,%esp
80103465:	89 d8                	mov    %ebx,%eax
80103467:	5b                   	pop    %ebx
80103468:	5e                   	pop    %esi
80103469:	5f                   	pop    %edi
8010346a:	5d                   	pop    %ebp
8010346b:	c3                   	ret    
8010346c:	00 00                	add    %al,(%eax)
	...

80103470 <allocproc>:
80103470:	55                   	push   %ebp
80103471:	89 e5                	mov    %esp,%ebp
80103473:	53                   	push   %ebx
80103474:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80103479:	83 ec 14             	sub    $0x14,%esp
8010347c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103483:	e8 a8 0c 00 00       	call   80104130 <acquire>
80103488:	eb 18                	jmp    801034a2 <allocproc+0x32>
8010348a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103490:	81 c3 88 00 00 00    	add    $0x88,%ebx
80103496:	81 fb 54 4f 11 80    	cmp    $0x80114f54,%ebx
8010349c:	0f 84 86 00 00 00    	je     80103528 <allocproc+0xb8>
801034a2:	8b 43 0c             	mov    0xc(%ebx),%eax
801034a5:	85 c0                	test   %eax,%eax
801034a7:	75 e7                	jne    80103490 <allocproc+0x20>
801034a9:	a1 04 a0 10 80       	mov    0x8010a004,%eax
801034ae:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801034b5:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
801034bc:	8d 50 01             	lea    0x1(%eax),%edx
801034bf:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
801034c5:	89 43 10             	mov    %eax,0x10(%ebx)
801034c8:	e8 53 0d 00 00       	call   80104220 <release>
801034cd:	e8 8e ef ff ff       	call   80102460 <kalloc>
801034d2:	85 c0                	test   %eax,%eax
801034d4:	89 43 08             	mov    %eax,0x8(%ebx)
801034d7:	74 63                	je     8010353c <allocproc+0xcc>
801034d9:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
801034df:	05 9c 0f 00 00       	add    $0xf9c,%eax
801034e4:	89 53 18             	mov    %edx,0x18(%ebx)
801034e7:	c7 40 14 d0 54 10 80 	movl   $0x801054d0,0x14(%eax)
801034ee:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
801034f5:	00 
801034f6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801034fd:	00 
801034fe:	89 04 24             	mov    %eax,(%esp)
80103501:	89 43 1c             	mov    %eax,0x1c(%ebx)
80103504:	e8 67 0d 00 00       	call   80104270 <memset>
80103509:	8b 43 1c             	mov    0x1c(%ebx),%eax
8010350c:	c7 40 10 50 35 10 80 	movl   $0x80103550,0x10(%eax)
80103513:	89 d8                	mov    %ebx,%eax
80103515:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
8010351c:	00 00 00 
8010351f:	83 c4 14             	add    $0x14,%esp
80103522:	5b                   	pop    %ebx
80103523:	5d                   	pop    %ebp
80103524:	c3                   	ret    
80103525:	8d 76 00             	lea    0x0(%esi),%esi
80103528:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010352f:	e8 ec 0c 00 00       	call   80104220 <release>
80103534:	83 c4 14             	add    $0x14,%esp
80103537:	31 c0                	xor    %eax,%eax
80103539:	5b                   	pop    %ebx
8010353a:	5d                   	pop    %ebp
8010353b:	c3                   	ret    
8010353c:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
80103543:	eb da                	jmp    8010351f <allocproc+0xaf>
80103545:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103549:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103550 <forkret>:
80103550:	55                   	push   %ebp
80103551:	89 e5                	mov    %esp,%ebp
80103553:	83 ec 18             	sub    $0x18,%esp
80103556:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010355d:	e8 be 0c 00 00       	call   80104220 <release>
80103562:	8b 15 00 a0 10 80    	mov    0x8010a000,%edx
80103568:	85 d2                	test   %edx,%edx
8010356a:	75 04                	jne    80103570 <forkret+0x20>
8010356c:	c9                   	leave  
8010356d:	c3                   	ret    
8010356e:	66 90                	xchg   %ax,%ax
80103570:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103577:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
8010357e:	00 00 00 
80103581:	e8 aa de ff ff       	call   80101430 <iinit>
80103586:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010358d:	e8 8e f4 ff ff       	call   80102a20 <initlog>
80103592:	c9                   	leave  
80103593:	c3                   	ret    
80103594:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010359a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801035a0 <pinit>:
801035a0:	55                   	push   %ebp
801035a1:	89 e5                	mov    %esp,%ebp
801035a3:	83 ec 18             	sub    $0x18,%esp
801035a6:	c7 44 24 04 75 73 10 	movl   $0x80107375,0x4(%esp)
801035ad:	80 
801035ae:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801035b5:	e8 86 0a 00 00       	call   80104040 <initlock>
801035ba:	c9                   	leave  
801035bb:	c3                   	ret    
801035bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801035c0 <mycpu>:
801035c0:	55                   	push   %ebp
801035c1:	89 e5                	mov    %esp,%ebp
801035c3:	56                   	push   %esi
801035c4:	53                   	push   %ebx
801035c5:	83 ec 10             	sub    $0x10,%esp
801035c8:	9c                   	pushf  
801035c9:	58                   	pop    %eax
801035ca:	f6 c4 02             	test   $0x2,%ah
801035cd:	75 57                	jne    80103626 <mycpu+0x66>
801035cf:	e8 3c f1 ff ff       	call   80102710 <lapicid>
801035d4:	8b 35 00 2d 11 80    	mov    0x80112d00,%esi
801035da:	85 f6                	test   %esi,%esi
801035dc:	7e 3c                	jle    8010361a <mycpu+0x5a>
801035de:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
801035e5:	39 c2                	cmp    %eax,%edx
801035e7:	74 2d                	je     80103616 <mycpu+0x56>
801035e9:	b9 30 28 11 80       	mov    $0x80112830,%ecx
801035ee:	31 d2                	xor    %edx,%edx
801035f0:	83 c2 01             	add    $0x1,%edx
801035f3:	39 f2                	cmp    %esi,%edx
801035f5:	74 23                	je     8010361a <mycpu+0x5a>
801035f7:	0f b6 19             	movzbl (%ecx),%ebx
801035fa:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103600:	39 c3                	cmp    %eax,%ebx
80103602:	75 ec                	jne    801035f0 <mycpu+0x30>
80103604:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
8010360a:	83 c4 10             	add    $0x10,%esp
8010360d:	5b                   	pop    %ebx
8010360e:	5e                   	pop    %esi
8010360f:	5d                   	pop    %ebp
80103610:	05 80 27 11 80       	add    $0x80112780,%eax
80103615:	c3                   	ret    
80103616:	31 d2                	xor    %edx,%edx
80103618:	eb ea                	jmp    80103604 <mycpu+0x44>
8010361a:	c7 04 24 7c 73 10 80 	movl   $0x8010737c,(%esp)
80103621:	e8 3a cd ff ff       	call   80100360 <panic>
80103626:	c7 04 24 58 74 10 80 	movl   $0x80107458,(%esp)
8010362d:	e8 2e cd ff ff       	call   80100360 <panic>
80103632:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103639:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103640 <cpuid>:
80103640:	55                   	push   %ebp
80103641:	89 e5                	mov    %esp,%ebp
80103643:	83 ec 08             	sub    $0x8,%esp
80103646:	e8 75 ff ff ff       	call   801035c0 <mycpu>
8010364b:	c9                   	leave  
8010364c:	2d 80 27 11 80       	sub    $0x80112780,%eax
80103651:	c1 f8 04             	sar    $0x4,%eax
80103654:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
8010365a:	c3                   	ret    
8010365b:	90                   	nop
8010365c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103660 <myproc>:
80103660:	55                   	push   %ebp
80103661:	89 e5                	mov    %esp,%ebp
80103663:	53                   	push   %ebx
80103664:	83 ec 04             	sub    $0x4,%esp
80103667:	e8 84 0a 00 00       	call   801040f0 <pushcli>
8010366c:	e8 4f ff ff ff       	call   801035c0 <mycpu>
80103671:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
80103677:	e8 34 0b 00 00       	call   801041b0 <popcli>
8010367c:	83 c4 04             	add    $0x4,%esp
8010367f:	89 d8                	mov    %ebx,%eax
80103681:	5b                   	pop    %ebx
80103682:	5d                   	pop    %ebp
80103683:	c3                   	ret    
80103684:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010368a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103690 <userinit>:
80103690:	55                   	push   %ebp
80103691:	89 e5                	mov    %esp,%ebp
80103693:	53                   	push   %ebx
80103694:	83 ec 14             	sub    $0x14,%esp
80103697:	e8 d4 fd ff ff       	call   80103470 <allocproc>
8010369c:	89 c3                	mov    %eax,%ebx
8010369e:	a3 b8 a5 10 80       	mov    %eax,0x8010a5b8
801036a3:	e8 c8 34 00 00       	call   80106b70 <setupkvm>
801036a8:	85 c0                	test   %eax,%eax
801036aa:	89 43 04             	mov    %eax,0x4(%ebx)
801036ad:	0f 84 d4 00 00 00    	je     80103787 <userinit+0xf7>
801036b3:	89 04 24             	mov    %eax,(%esp)
801036b6:	c7 44 24 08 2c 00 00 	movl   $0x2c,0x8(%esp)
801036bd:	00 
801036be:	c7 44 24 04 60 a4 10 	movl   $0x8010a460,0x4(%esp)
801036c5:	80 
801036c6:	e8 b5 31 00 00       	call   80106880 <inituvm>
801036cb:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
801036d1:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
801036d8:	00 
801036d9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801036e0:	00 
801036e1:	8b 43 18             	mov    0x18(%ebx),%eax
801036e4:	89 04 24             	mov    %eax,(%esp)
801036e7:	e8 84 0b 00 00       	call   80104270 <memset>
801036ec:	8b 43 18             	mov    0x18(%ebx),%eax
801036ef:	b9 1b 00 00 00       	mov    $0x1b,%ecx
801036f4:	ba 23 00 00 00       	mov    $0x23,%edx
801036f9:	66 89 48 3c          	mov    %cx,0x3c(%eax)
801036fd:	8b 43 18             	mov    0x18(%ebx),%eax
80103700:	66 89 50 2c          	mov    %dx,0x2c(%eax)
80103704:	8b 43 18             	mov    0x18(%ebx),%eax
80103707:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
8010370b:	66 89 50 28          	mov    %dx,0x28(%eax)
8010370f:	8b 43 18             	mov    0x18(%ebx),%eax
80103712:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103716:	66 89 50 48          	mov    %dx,0x48(%eax)
8010371a:	8b 43 18             	mov    0x18(%ebx),%eax
8010371d:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
80103724:	8b 43 18             	mov    0x18(%ebx),%eax
80103727:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
8010372e:	8b 43 18             	mov    0x18(%ebx),%eax
80103731:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
80103738:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010373b:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80103742:	00 
80103743:	c7 44 24 04 a5 73 10 	movl   $0x801073a5,0x4(%esp)
8010374a:	80 
8010374b:	89 04 24             	mov    %eax,(%esp)
8010374e:	e8 fd 0c 00 00       	call   80104450 <safestrcpy>
80103753:	c7 04 24 ae 73 10 80 	movl   $0x801073ae,(%esp)
8010375a:	e8 61 e7 ff ff       	call   80101ec0 <namei>
8010375f:	89 43 68             	mov    %eax,0x68(%ebx)
80103762:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103769:	e8 c2 09 00 00       	call   80104130 <acquire>
8010376e:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
80103775:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010377c:	e8 9f 0a 00 00       	call   80104220 <release>
80103781:	83 c4 14             	add    $0x14,%esp
80103784:	5b                   	pop    %ebx
80103785:	5d                   	pop    %ebp
80103786:	c3                   	ret    
80103787:	c7 04 24 8c 73 10 80 	movl   $0x8010738c,(%esp)
8010378e:	e8 cd cb ff ff       	call   80100360 <panic>
80103793:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103799:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801037a0 <growproc>:
801037a0:	55                   	push   %ebp
801037a1:	89 e5                	mov    %esp,%ebp
801037a3:	56                   	push   %esi
801037a4:	53                   	push   %ebx
801037a5:	83 ec 10             	sub    $0x10,%esp
801037a8:	8b 75 08             	mov    0x8(%ebp),%esi
801037ab:	e8 b0 fe ff ff       	call   80103660 <myproc>
801037b0:	83 fe 00             	cmp    $0x0,%esi
801037b3:	89 c3                	mov    %eax,%ebx
801037b5:	8b 00                	mov    (%eax),%eax
801037b7:	7e 2f                	jle    801037e8 <growproc+0x48>
801037b9:	01 c6                	add    %eax,%esi
801037bb:	89 74 24 08          	mov    %esi,0x8(%esp)
801037bf:	89 44 24 04          	mov    %eax,0x4(%esp)
801037c3:	8b 43 04             	mov    0x4(%ebx),%eax
801037c6:	89 04 24             	mov    %eax,(%esp)
801037c9:	e8 02 32 00 00       	call   801069d0 <allocuvm>
801037ce:	85 c0                	test   %eax,%eax
801037d0:	74 36                	je     80103808 <growproc+0x68>
801037d2:	89 03                	mov    %eax,(%ebx)
801037d4:	89 1c 24             	mov    %ebx,(%esp)
801037d7:	e8 94 2f 00 00       	call   80106770 <switchuvm>
801037dc:	31 c0                	xor    %eax,%eax
801037de:	83 c4 10             	add    $0x10,%esp
801037e1:	5b                   	pop    %ebx
801037e2:	5e                   	pop    %esi
801037e3:	5d                   	pop    %ebp
801037e4:	c3                   	ret    
801037e5:	8d 76 00             	lea    0x0(%esi),%esi
801037e8:	74 e8                	je     801037d2 <growproc+0x32>
801037ea:	01 c6                	add    %eax,%esi
801037ec:	89 74 24 08          	mov    %esi,0x8(%esp)
801037f0:	89 44 24 04          	mov    %eax,0x4(%esp)
801037f4:	8b 43 04             	mov    0x4(%ebx),%eax
801037f7:	89 04 24             	mov    %eax,(%esp)
801037fa:	e8 d1 32 00 00       	call   80106ad0 <deallocuvm>
801037ff:	85 c0                	test   %eax,%eax
80103801:	75 cf                	jne    801037d2 <growproc+0x32>
80103803:	90                   	nop
80103804:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103808:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010380d:	eb cf                	jmp    801037de <growproc+0x3e>
8010380f:	90                   	nop

80103810 <fork>:
80103810:	55                   	push   %ebp
80103811:	89 e5                	mov    %esp,%ebp
80103813:	57                   	push   %edi
80103814:	56                   	push   %esi
80103815:	53                   	push   %ebx
80103816:	83 ec 1c             	sub    $0x1c,%esp
80103819:	e8 42 fe ff ff       	call   80103660 <myproc>
8010381e:	89 c3                	mov    %eax,%ebx
80103820:	e8 4b fc ff ff       	call   80103470 <allocproc>
80103825:	85 c0                	test   %eax,%eax
80103827:	89 c7                	mov    %eax,%edi
80103829:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010382c:	0f 84 bc 00 00 00    	je     801038ee <fork+0xde>
80103832:	8b 03                	mov    (%ebx),%eax
80103834:	89 44 24 04          	mov    %eax,0x4(%esp)
80103838:	8b 43 04             	mov    0x4(%ebx),%eax
8010383b:	89 04 24             	mov    %eax,(%esp)
8010383e:	e8 0d 34 00 00       	call   80106c50 <copyuvm>
80103843:	85 c0                	test   %eax,%eax
80103845:	89 47 04             	mov    %eax,0x4(%edi)
80103848:	0f 84 a7 00 00 00    	je     801038f5 <fork+0xe5>
8010384e:	8b 03                	mov    (%ebx),%eax
80103850:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103853:	89 01                	mov    %eax,(%ecx)
80103855:	8b 79 18             	mov    0x18(%ecx),%edi
80103858:	89 c8                	mov    %ecx,%eax
8010385a:	89 59 14             	mov    %ebx,0x14(%ecx)
8010385d:	8b 73 18             	mov    0x18(%ebx),%esi
80103860:	b9 13 00 00 00       	mov    $0x13,%ecx
80103865:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
80103867:	31 f6                	xor    %esi,%esi
80103869:	8b 40 18             	mov    0x18(%eax),%eax
8010386c:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
80103873:	90                   	nop
80103874:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103878:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
8010387c:	85 c0                	test   %eax,%eax
8010387e:	74 0f                	je     8010388f <fork+0x7f>
80103880:	89 04 24             	mov    %eax,(%esp)
80103883:	e8 08 d5 ff ff       	call   80100d90 <filedup>
80103888:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010388b:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
8010388f:	83 c6 01             	add    $0x1,%esi
80103892:	83 fe 10             	cmp    $0x10,%esi
80103895:	75 e1                	jne    80103878 <fork+0x68>
80103897:	8b 43 68             	mov    0x68(%ebx),%eax
8010389a:	83 c3 6c             	add    $0x6c,%ebx
8010389d:	89 04 24             	mov    %eax,(%esp)
801038a0:	e8 9b dd ff ff       	call   80101640 <idup>
801038a5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801038a8:	89 47 68             	mov    %eax,0x68(%edi)
801038ab:	8d 47 6c             	lea    0x6c(%edi),%eax
801038ae:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801038b2:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
801038b9:	00 
801038ba:	89 04 24             	mov    %eax,(%esp)
801038bd:	e8 8e 0b 00 00       	call   80104450 <safestrcpy>
801038c2:	8b 5f 10             	mov    0x10(%edi),%ebx
801038c5:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801038cc:	e8 5f 08 00 00       	call   80104130 <acquire>
801038d1:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
801038d8:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801038df:	e8 3c 09 00 00       	call   80104220 <release>
801038e4:	89 d8                	mov    %ebx,%eax
801038e6:	83 c4 1c             	add    $0x1c,%esp
801038e9:	5b                   	pop    %ebx
801038ea:	5e                   	pop    %esi
801038eb:	5f                   	pop    %edi
801038ec:	5d                   	pop    %ebp
801038ed:	c3                   	ret    
801038ee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801038f3:	eb f1                	jmp    801038e6 <fork+0xd6>
801038f5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801038f8:	8b 47 08             	mov    0x8(%edi),%eax
801038fb:	89 04 24             	mov    %eax,(%esp)
801038fe:	e8 ad e9 ff ff       	call   801022b0 <kfree>
80103903:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103908:	c7 47 08 00 00 00 00 	movl   $0x0,0x8(%edi)
8010390f:	c7 47 0c 00 00 00 00 	movl   $0x0,0xc(%edi)
80103916:	eb ce                	jmp    801038e6 <fork+0xd6>
80103918:	90                   	nop
80103919:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103920 <scheduler>:
80103920:	55                   	push   %ebp
80103921:	89 e5                	mov    %esp,%ebp
80103923:	57                   	push   %edi
80103924:	56                   	push   %esi
80103925:	53                   	push   %ebx
80103926:	83 ec 1c             	sub    $0x1c,%esp
80103929:	e8 92 fc ff ff       	call   801035c0 <mycpu>
8010392e:	89 c6                	mov    %eax,%esi
80103930:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103937:	00 00 00 
8010393a:	8d 78 04             	lea    0x4(%eax),%edi
8010393d:	8d 76 00             	lea    0x0(%esi),%esi
80103940:	fb                   	sti    
80103941:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103948:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
8010394d:	e8 de 07 00 00       	call   80104130 <acquire>
80103952:	eb 12                	jmp    80103966 <scheduler+0x46>
80103954:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103958:	81 c3 88 00 00 00    	add    $0x88,%ebx
8010395e:	81 fb 54 4f 11 80    	cmp    $0x80114f54,%ebx
80103964:	74 4a                	je     801039b0 <scheduler+0x90>
80103966:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
8010396a:	75 ec                	jne    80103958 <scheduler+0x38>
8010396c:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
80103972:	89 1c 24             	mov    %ebx,(%esp)
80103975:	81 c3 88 00 00 00    	add    $0x88,%ebx
8010397b:	e8 f0 2d 00 00       	call   80106770 <switchuvm>
80103980:	8b 43 94             	mov    -0x6c(%ebx),%eax
80103983:	c7 43 84 04 00 00 00 	movl   $0x4,-0x7c(%ebx)
8010398a:	89 3c 24             	mov    %edi,(%esp)
8010398d:	89 44 24 04          	mov    %eax,0x4(%esp)
80103991:	e8 16 0b 00 00       	call   801044ac <swtch>
80103996:	e8 b5 2d 00 00       	call   80106750 <switchkvm>
8010399b:	81 fb 54 4f 11 80    	cmp    $0x80114f54,%ebx
801039a1:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
801039a8:	00 00 00 
801039ab:	75 b9                	jne    80103966 <scheduler+0x46>
801039ad:	8d 76 00             	lea    0x0(%esi),%esi
801039b0:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801039b7:	e8 64 08 00 00       	call   80104220 <release>
801039bc:	eb 82                	jmp    80103940 <scheduler+0x20>
801039be:	66 90                	xchg   %ax,%ax

801039c0 <sched>:
801039c0:	55                   	push   %ebp
801039c1:	89 e5                	mov    %esp,%ebp
801039c3:	56                   	push   %esi
801039c4:	53                   	push   %ebx
801039c5:	83 ec 10             	sub    $0x10,%esp
801039c8:	e8 93 fc ff ff       	call   80103660 <myproc>
801039cd:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801039d4:	89 c3                	mov    %eax,%ebx
801039d6:	e8 e5 06 00 00       	call   801040c0 <holding>
801039db:	85 c0                	test   %eax,%eax
801039dd:	74 4f                	je     80103a2e <sched+0x6e>
801039df:	e8 dc fb ff ff       	call   801035c0 <mycpu>
801039e4:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
801039eb:	75 65                	jne    80103a52 <sched+0x92>
801039ed:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
801039f1:	74 53                	je     80103a46 <sched+0x86>
801039f3:	9c                   	pushf  
801039f4:	58                   	pop    %eax
801039f5:	f6 c4 02             	test   $0x2,%ah
801039f8:	75 40                	jne    80103a3a <sched+0x7a>
801039fa:	e8 c1 fb ff ff       	call   801035c0 <mycpu>
801039ff:	83 c3 1c             	add    $0x1c,%ebx
80103a02:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
80103a08:	e8 b3 fb ff ff       	call   801035c0 <mycpu>
80103a0d:	8b 40 04             	mov    0x4(%eax),%eax
80103a10:	89 1c 24             	mov    %ebx,(%esp)
80103a13:	89 44 24 04          	mov    %eax,0x4(%esp)
80103a17:	e8 90 0a 00 00       	call   801044ac <swtch>
80103a1c:	e8 9f fb ff ff       	call   801035c0 <mycpu>
80103a21:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
80103a27:	83 c4 10             	add    $0x10,%esp
80103a2a:	5b                   	pop    %ebx
80103a2b:	5e                   	pop    %esi
80103a2c:	5d                   	pop    %ebp
80103a2d:	c3                   	ret    
80103a2e:	c7 04 24 b0 73 10 80 	movl   $0x801073b0,(%esp)
80103a35:	e8 26 c9 ff ff       	call   80100360 <panic>
80103a3a:	c7 04 24 dc 73 10 80 	movl   $0x801073dc,(%esp)
80103a41:	e8 1a c9 ff ff       	call   80100360 <panic>
80103a46:	c7 04 24 ce 73 10 80 	movl   $0x801073ce,(%esp)
80103a4d:	e8 0e c9 ff ff       	call   80100360 <panic>
80103a52:	c7 04 24 c2 73 10 80 	movl   $0x801073c2,(%esp)
80103a59:	e8 02 c9 ff ff       	call   80100360 <panic>
80103a5e:	66 90                	xchg   %ax,%ax

80103a60 <exit>:
80103a60:	55                   	push   %ebp
80103a61:	89 e5                	mov    %esp,%ebp
80103a63:	56                   	push   %esi
80103a64:	31 f6                	xor    %esi,%esi
80103a66:	53                   	push   %ebx
80103a67:	83 ec 10             	sub    $0x10,%esp
80103a6a:	e8 f1 fb ff ff       	call   80103660 <myproc>
80103a6f:	3b 05 b8 a5 10 80    	cmp    0x8010a5b8,%eax
80103a75:	89 c3                	mov    %eax,%ebx
80103a77:	0f 84 fd 00 00 00    	je     80103b7a <exit+0x11a>
80103a7d:	8d 76 00             	lea    0x0(%esi),%esi
80103a80:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103a84:	85 c0                	test   %eax,%eax
80103a86:	74 10                	je     80103a98 <exit+0x38>
80103a88:	89 04 24             	mov    %eax,(%esp)
80103a8b:	e8 50 d3 ff ff       	call   80100de0 <fileclose>
80103a90:	c7 44 b3 28 00 00 00 	movl   $0x0,0x28(%ebx,%esi,4)
80103a97:	00 
80103a98:	83 c6 01             	add    $0x1,%esi
80103a9b:	83 fe 10             	cmp    $0x10,%esi
80103a9e:	75 e0                	jne    80103a80 <exit+0x20>
80103aa0:	e8 1b f0 ff ff       	call   80102ac0 <begin_op>
80103aa5:	8b 43 68             	mov    0x68(%ebx),%eax
80103aa8:	89 04 24             	mov    %eax,(%esp)
80103aab:	e8 e0 dc ff ff       	call   80101790 <iput>
80103ab0:	e8 7b f0 ff ff       	call   80102b30 <end_op>
80103ab5:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
80103abc:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103ac3:	e8 68 06 00 00       	call   80104130 <acquire>
80103ac8:	8b 43 14             	mov    0x14(%ebx),%eax
80103acb:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103ad0:	eb 14                	jmp    80103ae6 <exit+0x86>
80103ad2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103ad8:	81 c2 88 00 00 00    	add    $0x88,%edx
80103ade:	81 fa 54 4f 11 80    	cmp    $0x80114f54,%edx
80103ae4:	74 20                	je     80103b06 <exit+0xa6>
80103ae6:	83 7a 0c 02          	cmpl   $0x2,0xc(%edx)
80103aea:	75 ec                	jne    80103ad8 <exit+0x78>
80103aec:	3b 42 20             	cmp    0x20(%edx),%eax
80103aef:	75 e7                	jne    80103ad8 <exit+0x78>
80103af1:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
80103af8:	81 c2 88 00 00 00    	add    $0x88,%edx
80103afe:	81 fa 54 4f 11 80    	cmp    $0x80114f54,%edx
80103b04:	75 e0                	jne    80103ae6 <exit+0x86>
80103b06:	a1 b8 a5 10 80       	mov    0x8010a5b8,%eax
80103b0b:	b9 54 2d 11 80       	mov    $0x80112d54,%ecx
80103b10:	eb 14                	jmp    80103b26 <exit+0xc6>
80103b12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103b18:	81 c1 88 00 00 00    	add    $0x88,%ecx
80103b1e:	81 f9 54 4f 11 80    	cmp    $0x80114f54,%ecx
80103b24:	74 3c                	je     80103b62 <exit+0x102>
80103b26:	39 59 14             	cmp    %ebx,0x14(%ecx)
80103b29:	75 ed                	jne    80103b18 <exit+0xb8>
80103b2b:	83 79 0c 05          	cmpl   $0x5,0xc(%ecx)
80103b2f:	89 41 14             	mov    %eax,0x14(%ecx)
80103b32:	75 e4                	jne    80103b18 <exit+0xb8>
80103b34:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103b39:	eb 13                	jmp    80103b4e <exit+0xee>
80103b3b:	90                   	nop
80103b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103b40:	81 c2 88 00 00 00    	add    $0x88,%edx
80103b46:	81 fa 54 4f 11 80    	cmp    $0x80114f54,%edx
80103b4c:	74 ca                	je     80103b18 <exit+0xb8>
80103b4e:	83 7a 0c 02          	cmpl   $0x2,0xc(%edx)
80103b52:	75 ec                	jne    80103b40 <exit+0xe0>
80103b54:	3b 42 20             	cmp    0x20(%edx),%eax
80103b57:	75 e7                	jne    80103b40 <exit+0xe0>
80103b59:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
80103b60:	eb de                	jmp    80103b40 <exit+0xe0>
80103b62:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
80103b69:	e8 52 fe ff ff       	call   801039c0 <sched>
80103b6e:	c7 04 24 fd 73 10 80 	movl   $0x801073fd,(%esp)
80103b75:	e8 e6 c7 ff ff       	call   80100360 <panic>
80103b7a:	c7 04 24 f0 73 10 80 	movl   $0x801073f0,(%esp)
80103b81:	e8 da c7 ff ff       	call   80100360 <panic>
80103b86:	8d 76 00             	lea    0x0(%esi),%esi
80103b89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103b90 <yield>:
80103b90:	55                   	push   %ebp
80103b91:	89 e5                	mov    %esp,%ebp
80103b93:	83 ec 18             	sub    $0x18,%esp
80103b96:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103b9d:	e8 8e 05 00 00       	call   80104130 <acquire>
80103ba2:	e8 b9 fa ff ff       	call   80103660 <myproc>
80103ba7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103bae:	e8 0d fe ff ff       	call   801039c0 <sched>
80103bb3:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103bba:	e8 61 06 00 00       	call   80104220 <release>
80103bbf:	c9                   	leave  
80103bc0:	c3                   	ret    
80103bc1:	eb 0d                	jmp    80103bd0 <sleep>
80103bc3:	90                   	nop
80103bc4:	90                   	nop
80103bc5:	90                   	nop
80103bc6:	90                   	nop
80103bc7:	90                   	nop
80103bc8:	90                   	nop
80103bc9:	90                   	nop
80103bca:	90                   	nop
80103bcb:	90                   	nop
80103bcc:	90                   	nop
80103bcd:	90                   	nop
80103bce:	90                   	nop
80103bcf:	90                   	nop

80103bd0 <sleep>:
80103bd0:	55                   	push   %ebp
80103bd1:	89 e5                	mov    %esp,%ebp
80103bd3:	57                   	push   %edi
80103bd4:	56                   	push   %esi
80103bd5:	53                   	push   %ebx
80103bd6:	83 ec 1c             	sub    $0x1c,%esp
80103bd9:	8b 7d 08             	mov    0x8(%ebp),%edi
80103bdc:	8b 75 0c             	mov    0xc(%ebp),%esi
80103bdf:	e8 7c fa ff ff       	call   80103660 <myproc>
80103be4:	85 c0                	test   %eax,%eax
80103be6:	89 c3                	mov    %eax,%ebx
80103be8:	0f 84 7c 00 00 00    	je     80103c6a <sleep+0x9a>
80103bee:	85 f6                	test   %esi,%esi
80103bf0:	74 6c                	je     80103c5e <sleep+0x8e>
80103bf2:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
80103bf8:	74 46                	je     80103c40 <sleep+0x70>
80103bfa:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103c01:	e8 2a 05 00 00       	call   80104130 <acquire>
80103c06:	89 34 24             	mov    %esi,(%esp)
80103c09:	e8 12 06 00 00       	call   80104220 <release>
80103c0e:	89 7b 20             	mov    %edi,0x20(%ebx)
80103c11:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
80103c18:	e8 a3 fd ff ff       	call   801039c0 <sched>
80103c1d:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
80103c24:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103c2b:	e8 f0 05 00 00       	call   80104220 <release>
80103c30:	89 75 08             	mov    %esi,0x8(%ebp)
80103c33:	83 c4 1c             	add    $0x1c,%esp
80103c36:	5b                   	pop    %ebx
80103c37:	5e                   	pop    %esi
80103c38:	5f                   	pop    %edi
80103c39:	5d                   	pop    %ebp
80103c3a:	e9 f1 04 00 00       	jmp    80104130 <acquire>
80103c3f:	90                   	nop
80103c40:	89 78 20             	mov    %edi,0x20(%eax)
80103c43:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
80103c4a:	e8 71 fd ff ff       	call   801039c0 <sched>
80103c4f:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
80103c56:	83 c4 1c             	add    $0x1c,%esp
80103c59:	5b                   	pop    %ebx
80103c5a:	5e                   	pop    %esi
80103c5b:	5f                   	pop    %edi
80103c5c:	5d                   	pop    %ebp
80103c5d:	c3                   	ret    
80103c5e:	c7 04 24 0f 74 10 80 	movl   $0x8010740f,(%esp)
80103c65:	e8 f6 c6 ff ff       	call   80100360 <panic>
80103c6a:	c7 04 24 09 74 10 80 	movl   $0x80107409,(%esp)
80103c71:	e8 ea c6 ff ff       	call   80100360 <panic>
80103c76:	8d 76 00             	lea    0x0(%esi),%esi
80103c79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103c80 <wait>:
80103c80:	55                   	push   %ebp
80103c81:	89 e5                	mov    %esp,%ebp
80103c83:	56                   	push   %esi
80103c84:	53                   	push   %ebx
80103c85:	83 ec 10             	sub    $0x10,%esp
80103c88:	e8 d3 f9 ff ff       	call   80103660 <myproc>
80103c8d:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103c94:	89 c6                	mov    %eax,%esi
80103c96:	e8 95 04 00 00       	call   80104130 <acquire>
80103c9b:	31 c0                	xor    %eax,%eax
80103c9d:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80103ca2:	eb 12                	jmp    80103cb6 <wait+0x36>
80103ca4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103ca8:	81 c3 88 00 00 00    	add    $0x88,%ebx
80103cae:	81 fb 54 4f 11 80    	cmp    $0x80114f54,%ebx
80103cb4:	74 22                	je     80103cd8 <wait+0x58>
80103cb6:	39 73 14             	cmp    %esi,0x14(%ebx)
80103cb9:	75 ed                	jne    80103ca8 <wait+0x28>
80103cbb:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103cbf:	74 34                	je     80103cf5 <wait+0x75>
80103cc1:	81 c3 88 00 00 00    	add    $0x88,%ebx
80103cc7:	b8 01 00 00 00       	mov    $0x1,%eax
80103ccc:	81 fb 54 4f 11 80    	cmp    $0x80114f54,%ebx
80103cd2:	75 e2                	jne    80103cb6 <wait+0x36>
80103cd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103cd8:	85 c0                	test   %eax,%eax
80103cda:	74 6e                	je     80103d4a <wait+0xca>
80103cdc:	8b 4e 24             	mov    0x24(%esi),%ecx
80103cdf:	85 c9                	test   %ecx,%ecx
80103ce1:	75 67                	jne    80103d4a <wait+0xca>
80103ce3:	c7 44 24 04 20 2d 11 	movl   $0x80112d20,0x4(%esp)
80103cea:	80 
80103ceb:	89 34 24             	mov    %esi,(%esp)
80103cee:	e8 dd fe ff ff       	call   80103bd0 <sleep>
80103cf3:	eb a6                	jmp    80103c9b <wait+0x1b>
80103cf5:	8b 43 08             	mov    0x8(%ebx),%eax
80103cf8:	8b 73 10             	mov    0x10(%ebx),%esi
80103cfb:	89 04 24             	mov    %eax,(%esp)
80103cfe:	e8 ad e5 ff ff       	call   801022b0 <kfree>
80103d03:	8b 43 04             	mov    0x4(%ebx),%eax
80103d06:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
80103d0d:	89 04 24             	mov    %eax,(%esp)
80103d10:	e8 db 2d 00 00       	call   80106af0 <freevm>
80103d15:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103d1c:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
80103d23:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
80103d2a:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
80103d2e:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
80103d35:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
80103d3c:	e8 df 04 00 00       	call   80104220 <release>
80103d41:	83 c4 10             	add    $0x10,%esp
80103d44:	89 f0                	mov    %esi,%eax
80103d46:	5b                   	pop    %ebx
80103d47:	5e                   	pop    %esi
80103d48:	5d                   	pop    %ebp
80103d49:	c3                   	ret    
80103d4a:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103d51:	e8 ca 04 00 00       	call   80104220 <release>
80103d56:	83 c4 10             	add    $0x10,%esp
80103d59:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103d5e:	5b                   	pop    %ebx
80103d5f:	5e                   	pop    %esi
80103d60:	5d                   	pop    %ebp
80103d61:	c3                   	ret    
80103d62:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103d70 <wakeup>:
80103d70:	55                   	push   %ebp
80103d71:	89 e5                	mov    %esp,%ebp
80103d73:	53                   	push   %ebx
80103d74:	83 ec 14             	sub    $0x14,%esp
80103d77:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103d7a:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103d81:	e8 aa 03 00 00       	call   80104130 <acquire>
80103d86:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103d8b:	eb 0f                	jmp    80103d9c <wakeup+0x2c>
80103d8d:	8d 76 00             	lea    0x0(%esi),%esi
80103d90:	05 88 00 00 00       	add    $0x88,%eax
80103d95:	3d 54 4f 11 80       	cmp    $0x80114f54,%eax
80103d9a:	74 24                	je     80103dc0 <wakeup+0x50>
80103d9c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103da0:	75 ee                	jne    80103d90 <wakeup+0x20>
80103da2:	3b 58 20             	cmp    0x20(%eax),%ebx
80103da5:	75 e9                	jne    80103d90 <wakeup+0x20>
80103da7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103dae:	05 88 00 00 00       	add    $0x88,%eax
80103db3:	3d 54 4f 11 80       	cmp    $0x80114f54,%eax
80103db8:	75 e2                	jne    80103d9c <wakeup+0x2c>
80103dba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103dc0:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
80103dc7:	83 c4 14             	add    $0x14,%esp
80103dca:	5b                   	pop    %ebx
80103dcb:	5d                   	pop    %ebp
80103dcc:	e9 4f 04 00 00       	jmp    80104220 <release>
80103dd1:	eb 0d                	jmp    80103de0 <kill>
80103dd3:	90                   	nop
80103dd4:	90                   	nop
80103dd5:	90                   	nop
80103dd6:	90                   	nop
80103dd7:	90                   	nop
80103dd8:	90                   	nop
80103dd9:	90                   	nop
80103dda:	90                   	nop
80103ddb:	90                   	nop
80103ddc:	90                   	nop
80103ddd:	90                   	nop
80103dde:	90                   	nop
80103ddf:	90                   	nop

80103de0 <kill>:
80103de0:	55                   	push   %ebp
80103de1:	89 e5                	mov    %esp,%ebp
80103de3:	53                   	push   %ebx
80103de4:	83 ec 14             	sub    $0x14,%esp
80103de7:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103dea:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103df1:	e8 3a 03 00 00       	call   80104130 <acquire>
80103df6:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103dfb:	eb 0f                	jmp    80103e0c <kill+0x2c>
80103dfd:	8d 76 00             	lea    0x0(%esi),%esi
80103e00:	05 88 00 00 00       	add    $0x88,%eax
80103e05:	3d 54 4f 11 80       	cmp    $0x80114f54,%eax
80103e0a:	74 3c                	je     80103e48 <kill+0x68>
80103e0c:	39 58 10             	cmp    %ebx,0x10(%eax)
80103e0f:	75 ef                	jne    80103e00 <kill+0x20>
80103e11:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103e15:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80103e1c:	74 1a                	je     80103e38 <kill+0x58>
80103e1e:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103e25:	e8 f6 03 00 00       	call   80104220 <release>
80103e2a:	83 c4 14             	add    $0x14,%esp
80103e2d:	31 c0                	xor    %eax,%eax
80103e2f:	5b                   	pop    %ebx
80103e30:	5d                   	pop    %ebp
80103e31:	c3                   	ret    
80103e32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103e38:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103e3f:	eb dd                	jmp    80103e1e <kill+0x3e>
80103e41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e48:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103e4f:	e8 cc 03 00 00       	call   80104220 <release>
80103e54:	83 c4 14             	add    $0x14,%esp
80103e57:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103e5c:	5b                   	pop    %ebx
80103e5d:	5d                   	pop    %ebp
80103e5e:	c3                   	ret    
80103e5f:	90                   	nop

80103e60 <procdump>:
80103e60:	55                   	push   %ebp
80103e61:	89 e5                	mov    %esp,%ebp
80103e63:	57                   	push   %edi
80103e64:	56                   	push   %esi
80103e65:	53                   	push   %ebx
80103e66:	bb c0 2d 11 80       	mov    $0x80112dc0,%ebx
80103e6b:	83 ec 4c             	sub    $0x4c,%esp
80103e6e:	8d 75 e8             	lea    -0x18(%ebp),%esi
80103e71:	eb 23                	jmp    80103e96 <procdump+0x36>
80103e73:	90                   	nop
80103e74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e78:	c7 04 24 d7 77 10 80 	movl   $0x801077d7,(%esp)
80103e7f:	e8 cc c7 ff ff       	call   80100650 <cprintf>
80103e84:	81 c3 88 00 00 00    	add    $0x88,%ebx
80103e8a:	81 fb c0 4f 11 80    	cmp    $0x80114fc0,%ebx
80103e90:	0f 84 8a 00 00 00    	je     80103f20 <procdump+0xc0>
80103e96:	8b 43 a0             	mov    -0x60(%ebx),%eax
80103e99:	85 c0                	test   %eax,%eax
80103e9b:	74 e7                	je     80103e84 <procdump+0x24>
80103e9d:	83 f8 05             	cmp    $0x5,%eax
80103ea0:	ba 20 74 10 80       	mov    $0x80107420,%edx
80103ea5:	77 11                	ja     80103eb8 <procdump+0x58>
80103ea7:	8b 14 85 80 74 10 80 	mov    -0x7fef8b80(,%eax,4),%edx
80103eae:	b8 20 74 10 80       	mov    $0x80107420,%eax
80103eb3:	85 d2                	test   %edx,%edx
80103eb5:	0f 44 d0             	cmove  %eax,%edx
80103eb8:	8b 43 a4             	mov    -0x5c(%ebx),%eax
80103ebb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
80103ebf:	89 54 24 08          	mov    %edx,0x8(%esp)
80103ec3:	c7 04 24 24 74 10 80 	movl   $0x80107424,(%esp)
80103eca:	89 44 24 04          	mov    %eax,0x4(%esp)
80103ece:	e8 7d c7 ff ff       	call   80100650 <cprintf>
80103ed3:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80103ed7:	75 9f                	jne    80103e78 <procdump+0x18>
80103ed9:	8d 45 c0             	lea    -0x40(%ebp),%eax
80103edc:	89 44 24 04          	mov    %eax,0x4(%esp)
80103ee0:	8b 43 b0             	mov    -0x50(%ebx),%eax
80103ee3:	8d 7d c0             	lea    -0x40(%ebp),%edi
80103ee6:	8b 40 0c             	mov    0xc(%eax),%eax
80103ee9:	83 c0 08             	add    $0x8,%eax
80103eec:	89 04 24             	mov    %eax,(%esp)
80103eef:	e8 6c 01 00 00       	call   80104060 <getcallerpcs>
80103ef4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103ef8:	8b 17                	mov    (%edi),%edx
80103efa:	85 d2                	test   %edx,%edx
80103efc:	0f 84 76 ff ff ff    	je     80103e78 <procdump+0x18>
80103f02:	89 54 24 04          	mov    %edx,0x4(%esp)
80103f06:	83 c7 04             	add    $0x4,%edi
80103f09:	c7 04 24 61 6e 10 80 	movl   $0x80106e61,(%esp)
80103f10:	e8 3b c7 ff ff       	call   80100650 <cprintf>
80103f15:	39 f7                	cmp    %esi,%edi
80103f17:	75 df                	jne    80103ef8 <procdump+0x98>
80103f19:	e9 5a ff ff ff       	jmp    80103e78 <procdump+0x18>
80103f1e:	66 90                	xchg   %ax,%ax
80103f20:	83 c4 4c             	add    $0x4c,%esp
80103f23:	5b                   	pop    %ebx
80103f24:	5e                   	pop    %esi
80103f25:	5f                   	pop    %edi
80103f26:	5d                   	pop    %ebp
80103f27:	c3                   	ret    
	...

80103f30 <initsleeplock>:
80103f30:	55                   	push   %ebp
80103f31:	89 e5                	mov    %esp,%ebp
80103f33:	53                   	push   %ebx
80103f34:	83 ec 14             	sub    $0x14,%esp
80103f37:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103f3a:	c7 44 24 04 98 74 10 	movl   $0x80107498,0x4(%esp)
80103f41:	80 
80103f42:	8d 43 04             	lea    0x4(%ebx),%eax
80103f45:	89 04 24             	mov    %eax,(%esp)
80103f48:	e8 f3 00 00 00       	call   80104040 <initlock>
80103f4d:	8b 45 0c             	mov    0xc(%ebp),%eax
80103f50:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103f56:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
80103f5d:	89 43 38             	mov    %eax,0x38(%ebx)
80103f60:	83 c4 14             	add    $0x14,%esp
80103f63:	5b                   	pop    %ebx
80103f64:	5d                   	pop    %ebp
80103f65:	c3                   	ret    
80103f66:	8d 76 00             	lea    0x0(%esi),%esi
80103f69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103f70 <acquiresleep>:
80103f70:	55                   	push   %ebp
80103f71:	89 e5                	mov    %esp,%ebp
80103f73:	56                   	push   %esi
80103f74:	53                   	push   %ebx
80103f75:	83 ec 10             	sub    $0x10,%esp
80103f78:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103f7b:	8d 73 04             	lea    0x4(%ebx),%esi
80103f7e:	89 34 24             	mov    %esi,(%esp)
80103f81:	e8 aa 01 00 00       	call   80104130 <acquire>
80103f86:	8b 13                	mov    (%ebx),%edx
80103f88:	85 d2                	test   %edx,%edx
80103f8a:	74 16                	je     80103fa2 <acquiresleep+0x32>
80103f8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f90:	89 74 24 04          	mov    %esi,0x4(%esp)
80103f94:	89 1c 24             	mov    %ebx,(%esp)
80103f97:	e8 34 fc ff ff       	call   80103bd0 <sleep>
80103f9c:	8b 03                	mov    (%ebx),%eax
80103f9e:	85 c0                	test   %eax,%eax
80103fa0:	75 ee                	jne    80103f90 <acquiresleep+0x20>
80103fa2:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
80103fa8:	e8 b3 f6 ff ff       	call   80103660 <myproc>
80103fad:	8b 40 10             	mov    0x10(%eax),%eax
80103fb0:	89 43 3c             	mov    %eax,0x3c(%ebx)
80103fb3:	89 75 08             	mov    %esi,0x8(%ebp)
80103fb6:	83 c4 10             	add    $0x10,%esp
80103fb9:	5b                   	pop    %ebx
80103fba:	5e                   	pop    %esi
80103fbb:	5d                   	pop    %ebp
80103fbc:	e9 5f 02 00 00       	jmp    80104220 <release>
80103fc1:	eb 0d                	jmp    80103fd0 <releasesleep>
80103fc3:	90                   	nop
80103fc4:	90                   	nop
80103fc5:	90                   	nop
80103fc6:	90                   	nop
80103fc7:	90                   	nop
80103fc8:	90                   	nop
80103fc9:	90                   	nop
80103fca:	90                   	nop
80103fcb:	90                   	nop
80103fcc:	90                   	nop
80103fcd:	90                   	nop
80103fce:	90                   	nop
80103fcf:	90                   	nop

80103fd0 <releasesleep>:
80103fd0:	55                   	push   %ebp
80103fd1:	89 e5                	mov    %esp,%ebp
80103fd3:	56                   	push   %esi
80103fd4:	53                   	push   %ebx
80103fd5:	83 ec 10             	sub    $0x10,%esp
80103fd8:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103fdb:	8d 73 04             	lea    0x4(%ebx),%esi
80103fde:	89 34 24             	mov    %esi,(%esp)
80103fe1:	e8 4a 01 00 00       	call   80104130 <acquire>
80103fe6:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103fec:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
80103ff3:	89 1c 24             	mov    %ebx,(%esp)
80103ff6:	e8 75 fd ff ff       	call   80103d70 <wakeup>
80103ffb:	89 75 08             	mov    %esi,0x8(%ebp)
80103ffe:	83 c4 10             	add    $0x10,%esp
80104001:	5b                   	pop    %ebx
80104002:	5e                   	pop    %esi
80104003:	5d                   	pop    %ebp
80104004:	e9 17 02 00 00       	jmp    80104220 <release>
80104009:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104010 <holdingsleep>:
80104010:	55                   	push   %ebp
80104011:	89 e5                	mov    %esp,%ebp
80104013:	56                   	push   %esi
80104014:	53                   	push   %ebx
80104015:	83 ec 10             	sub    $0x10,%esp
80104018:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010401b:	8d 73 04             	lea    0x4(%ebx),%esi
8010401e:	89 34 24             	mov    %esi,(%esp)
80104021:	e8 0a 01 00 00       	call   80104130 <acquire>
80104026:	8b 1b                	mov    (%ebx),%ebx
80104028:	89 34 24             	mov    %esi,(%esp)
8010402b:	e8 f0 01 00 00       	call   80104220 <release>
80104030:	83 c4 10             	add    $0x10,%esp
80104033:	89 d8                	mov    %ebx,%eax
80104035:	5b                   	pop    %ebx
80104036:	5e                   	pop    %esi
80104037:	5d                   	pop    %ebp
80104038:	c3                   	ret    
80104039:	00 00                	add    %al,(%eax)
8010403b:	00 00                	add    %al,(%eax)
8010403d:	00 00                	add    %al,(%eax)
	...

80104040 <initlock>:
80104040:	55                   	push   %ebp
80104041:	89 e5                	mov    %esp,%ebp
80104043:	8b 45 08             	mov    0x8(%ebp),%eax
80104046:	8b 55 0c             	mov    0xc(%ebp),%edx
80104049:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
8010404f:	89 50 04             	mov    %edx,0x4(%eax)
80104052:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
80104059:	5d                   	pop    %ebp
8010405a:	c3                   	ret    
8010405b:	90                   	nop
8010405c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104060 <getcallerpcs>:
80104060:	55                   	push   %ebp
80104061:	89 e5                	mov    %esp,%ebp
80104063:	8b 45 08             	mov    0x8(%ebp),%eax
80104066:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104069:	53                   	push   %ebx
8010406a:	8d 50 f8             	lea    -0x8(%eax),%edx
8010406d:	31 c0                	xor    %eax,%eax
8010406f:	90                   	nop
80104070:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104076:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010407c:	77 1a                	ja     80104098 <getcallerpcs+0x38>
8010407e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104081:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
80104084:	83 c0 01             	add    $0x1,%eax
80104087:	8b 12                	mov    (%edx),%edx
80104089:	83 f8 0a             	cmp    $0xa,%eax
8010408c:	75 e2                	jne    80104070 <getcallerpcs+0x10>
8010408e:	5b                   	pop    %ebx
8010408f:	5d                   	pop    %ebp
80104090:	c3                   	ret    
80104091:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104098:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
8010409f:	83 c0 01             	add    $0x1,%eax
801040a2:	83 f8 0a             	cmp    $0xa,%eax
801040a5:	74 e7                	je     8010408e <getcallerpcs+0x2e>
801040a7:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
801040ae:	83 c0 01             	add    $0x1,%eax
801040b1:	83 f8 0a             	cmp    $0xa,%eax
801040b4:	75 e2                	jne    80104098 <getcallerpcs+0x38>
801040b6:	eb d6                	jmp    8010408e <getcallerpcs+0x2e>
801040b8:	90                   	nop
801040b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801040c0 <holding>:
801040c0:	55                   	push   %ebp
801040c1:	31 c0                	xor    %eax,%eax
801040c3:	89 e5                	mov    %esp,%ebp
801040c5:	53                   	push   %ebx
801040c6:	83 ec 04             	sub    $0x4,%esp
801040c9:	8b 55 08             	mov    0x8(%ebp),%edx
801040cc:	8b 0a                	mov    (%edx),%ecx
801040ce:	85 c9                	test   %ecx,%ecx
801040d0:	74 10                	je     801040e2 <holding+0x22>
801040d2:	8b 5a 08             	mov    0x8(%edx),%ebx
801040d5:	e8 e6 f4 ff ff       	call   801035c0 <mycpu>
801040da:	39 c3                	cmp    %eax,%ebx
801040dc:	0f 94 c0             	sete   %al
801040df:	0f b6 c0             	movzbl %al,%eax
801040e2:	83 c4 04             	add    $0x4,%esp
801040e5:	5b                   	pop    %ebx
801040e6:	5d                   	pop    %ebp
801040e7:	c3                   	ret    
801040e8:	90                   	nop
801040e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801040f0 <pushcli>:
801040f0:	55                   	push   %ebp
801040f1:	89 e5                	mov    %esp,%ebp
801040f3:	53                   	push   %ebx
801040f4:	83 ec 04             	sub    $0x4,%esp
801040f7:	9c                   	pushf  
801040f8:	5b                   	pop    %ebx
801040f9:	fa                   	cli    
801040fa:	e8 c1 f4 ff ff       	call   801035c0 <mycpu>
801040ff:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104105:	85 c0                	test   %eax,%eax
80104107:	75 11                	jne    8010411a <pushcli+0x2a>
80104109:	e8 b2 f4 ff ff       	call   801035c0 <mycpu>
8010410e:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104114:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
8010411a:	e8 a1 f4 ff ff       	call   801035c0 <mycpu>
8010411f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
80104126:	83 c4 04             	add    $0x4,%esp
80104129:	5b                   	pop    %ebx
8010412a:	5d                   	pop    %ebp
8010412b:	c3                   	ret    
8010412c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104130 <acquire>:
80104130:	55                   	push   %ebp
80104131:	89 e5                	mov    %esp,%ebp
80104133:	53                   	push   %ebx
80104134:	83 ec 14             	sub    $0x14,%esp
80104137:	e8 b4 ff ff ff       	call   801040f0 <pushcli>
8010413c:	8b 55 08             	mov    0x8(%ebp),%edx
8010413f:	8b 02                	mov    (%edx),%eax
80104141:	85 c0                	test   %eax,%eax
80104143:	75 43                	jne    80104188 <acquire+0x58>
80104145:	b9 01 00 00 00       	mov    $0x1,%ecx
8010414a:	eb 07                	jmp    80104153 <acquire+0x23>
8010414c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104150:	8b 55 08             	mov    0x8(%ebp),%edx
80104153:	89 c8                	mov    %ecx,%eax
80104155:	f0 87 02             	lock xchg %eax,(%edx)
80104158:	85 c0                	test   %eax,%eax
8010415a:	75 f4                	jne    80104150 <acquire+0x20>
8010415c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
80104161:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104164:	e8 57 f4 ff ff       	call   801035c0 <mycpu>
80104169:	89 43 08             	mov    %eax,0x8(%ebx)
8010416c:	8b 45 08             	mov    0x8(%ebp),%eax
8010416f:	83 c0 0c             	add    $0xc,%eax
80104172:	89 44 24 04          	mov    %eax,0x4(%esp)
80104176:	8d 45 08             	lea    0x8(%ebp),%eax
80104179:	89 04 24             	mov    %eax,(%esp)
8010417c:	e8 df fe ff ff       	call   80104060 <getcallerpcs>
80104181:	83 c4 14             	add    $0x14,%esp
80104184:	5b                   	pop    %ebx
80104185:	5d                   	pop    %ebp
80104186:	c3                   	ret    
80104187:	90                   	nop
80104188:	8b 5a 08             	mov    0x8(%edx),%ebx
8010418b:	e8 30 f4 ff ff       	call   801035c0 <mycpu>
80104190:	39 c3                	cmp    %eax,%ebx
80104192:	74 05                	je     80104199 <acquire+0x69>
80104194:	8b 55 08             	mov    0x8(%ebp),%edx
80104197:	eb ac                	jmp    80104145 <acquire+0x15>
80104199:	c7 04 24 a3 74 10 80 	movl   $0x801074a3,(%esp)
801041a0:	e8 bb c1 ff ff       	call   80100360 <panic>
801041a5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801041a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801041b0 <popcli>:
801041b0:	55                   	push   %ebp
801041b1:	89 e5                	mov    %esp,%ebp
801041b3:	83 ec 18             	sub    $0x18,%esp
801041b6:	9c                   	pushf  
801041b7:	58                   	pop    %eax
801041b8:	f6 c4 02             	test   $0x2,%ah
801041bb:	75 49                	jne    80104206 <popcli+0x56>
801041bd:	e8 fe f3 ff ff       	call   801035c0 <mycpu>
801041c2:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
801041c8:	8d 51 ff             	lea    -0x1(%ecx),%edx
801041cb:	85 d2                	test   %edx,%edx
801041cd:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
801041d3:	78 25                	js     801041fa <popcli+0x4a>
801041d5:	e8 e6 f3 ff ff       	call   801035c0 <mycpu>
801041da:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801041e0:	85 c0                	test   %eax,%eax
801041e2:	74 04                	je     801041e8 <popcli+0x38>
801041e4:	c9                   	leave  
801041e5:	c3                   	ret    
801041e6:	66 90                	xchg   %ax,%ax
801041e8:	e8 d3 f3 ff ff       	call   801035c0 <mycpu>
801041ed:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801041f3:	85 c0                	test   %eax,%eax
801041f5:	74 ed                	je     801041e4 <popcli+0x34>
801041f7:	fb                   	sti    
801041f8:	c9                   	leave  
801041f9:	c3                   	ret    
801041fa:	c7 04 24 c2 74 10 80 	movl   $0x801074c2,(%esp)
80104201:	e8 5a c1 ff ff       	call   80100360 <panic>
80104206:	c7 04 24 ab 74 10 80 	movl   $0x801074ab,(%esp)
8010420d:	e8 4e c1 ff ff       	call   80100360 <panic>
80104212:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104219:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104220 <release>:
80104220:	55                   	push   %ebp
80104221:	89 e5                	mov    %esp,%ebp
80104223:	56                   	push   %esi
80104224:	53                   	push   %ebx
80104225:	83 ec 10             	sub    $0x10,%esp
80104228:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010422b:	8b 03                	mov    (%ebx),%eax
8010422d:	85 c0                	test   %eax,%eax
8010422f:	75 0f                	jne    80104240 <release+0x20>
80104231:	c7 04 24 c9 74 10 80 	movl   $0x801074c9,(%esp)
80104238:	e8 23 c1 ff ff       	call   80100360 <panic>
8010423d:	8d 76 00             	lea    0x0(%esi),%esi
80104240:	8b 73 08             	mov    0x8(%ebx),%esi
80104243:	e8 78 f3 ff ff       	call   801035c0 <mycpu>
80104248:	39 c6                	cmp    %eax,%esi
8010424a:	75 e5                	jne    80104231 <release+0x11>
8010424c:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
80104253:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
8010425a:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
8010425f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80104265:	83 c4 10             	add    $0x10,%esp
80104268:	5b                   	pop    %ebx
80104269:	5e                   	pop    %esi
8010426a:	5d                   	pop    %ebp
8010426b:	e9 40 ff ff ff       	jmp    801041b0 <popcli>

80104270 <memset>:
80104270:	55                   	push   %ebp
80104271:	89 e5                	mov    %esp,%ebp
80104273:	8b 55 08             	mov    0x8(%ebp),%edx
80104276:	57                   	push   %edi
80104277:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010427a:	53                   	push   %ebx
8010427b:	f6 c2 03             	test   $0x3,%dl
8010427e:	75 05                	jne    80104285 <memset+0x15>
80104280:	f6 c1 03             	test   $0x3,%cl
80104283:	74 13                	je     80104298 <memset+0x28>
80104285:	89 d7                	mov    %edx,%edi
80104287:	8b 45 0c             	mov    0xc(%ebp),%eax
8010428a:	fc                   	cld    
8010428b:	f3 aa                	rep stos %al,%es:(%edi)
8010428d:	5b                   	pop    %ebx
8010428e:	89 d0                	mov    %edx,%eax
80104290:	5f                   	pop    %edi
80104291:	5d                   	pop    %ebp
80104292:	c3                   	ret    
80104293:	90                   	nop
80104294:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104298:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
8010429c:	c1 e9 02             	shr    $0x2,%ecx
8010429f:	89 f8                	mov    %edi,%eax
801042a1:	89 fb                	mov    %edi,%ebx
801042a3:	c1 e0 18             	shl    $0x18,%eax
801042a6:	c1 e3 10             	shl    $0x10,%ebx
801042a9:	09 d8                	or     %ebx,%eax
801042ab:	09 f8                	or     %edi,%eax
801042ad:	c1 e7 08             	shl    $0x8,%edi
801042b0:	09 f8                	or     %edi,%eax
801042b2:	89 d7                	mov    %edx,%edi
801042b4:	fc                   	cld    
801042b5:	f3 ab                	rep stos %eax,%es:(%edi)
801042b7:	5b                   	pop    %ebx
801042b8:	89 d0                	mov    %edx,%eax
801042ba:	5f                   	pop    %edi
801042bb:	5d                   	pop    %ebp
801042bc:	c3                   	ret    
801042bd:	8d 76 00             	lea    0x0(%esi),%esi

801042c0 <memcmp>:
801042c0:	55                   	push   %ebp
801042c1:	89 e5                	mov    %esp,%ebp
801042c3:	8b 45 10             	mov    0x10(%ebp),%eax
801042c6:	57                   	push   %edi
801042c7:	56                   	push   %esi
801042c8:	8b 75 0c             	mov    0xc(%ebp),%esi
801042cb:	53                   	push   %ebx
801042cc:	8b 5d 08             	mov    0x8(%ebp),%ebx
801042cf:	85 c0                	test   %eax,%eax
801042d1:	8d 78 ff             	lea    -0x1(%eax),%edi
801042d4:	74 26                	je     801042fc <memcmp+0x3c>
801042d6:	0f b6 03             	movzbl (%ebx),%eax
801042d9:	31 d2                	xor    %edx,%edx
801042db:	0f b6 0e             	movzbl (%esi),%ecx
801042de:	38 c8                	cmp    %cl,%al
801042e0:	74 16                	je     801042f8 <memcmp+0x38>
801042e2:	eb 24                	jmp    80104308 <memcmp+0x48>
801042e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801042e8:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
801042ed:	83 c2 01             	add    $0x1,%edx
801042f0:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
801042f4:	38 c8                	cmp    %cl,%al
801042f6:	75 10                	jne    80104308 <memcmp+0x48>
801042f8:	39 fa                	cmp    %edi,%edx
801042fa:	75 ec                	jne    801042e8 <memcmp+0x28>
801042fc:	5b                   	pop    %ebx
801042fd:	31 c0                	xor    %eax,%eax
801042ff:	5e                   	pop    %esi
80104300:	5f                   	pop    %edi
80104301:	5d                   	pop    %ebp
80104302:	c3                   	ret    
80104303:	90                   	nop
80104304:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104308:	5b                   	pop    %ebx
80104309:	29 c8                	sub    %ecx,%eax
8010430b:	5e                   	pop    %esi
8010430c:	5f                   	pop    %edi
8010430d:	5d                   	pop    %ebp
8010430e:	c3                   	ret    
8010430f:	90                   	nop

80104310 <memmove>:
80104310:	55                   	push   %ebp
80104311:	89 e5                	mov    %esp,%ebp
80104313:	57                   	push   %edi
80104314:	8b 45 08             	mov    0x8(%ebp),%eax
80104317:	56                   	push   %esi
80104318:	8b 75 0c             	mov    0xc(%ebp),%esi
8010431b:	53                   	push   %ebx
8010431c:	8b 5d 10             	mov    0x10(%ebp),%ebx
8010431f:	39 c6                	cmp    %eax,%esi
80104321:	73 35                	jae    80104358 <memmove+0x48>
80104323:	8d 0c 1e             	lea    (%esi,%ebx,1),%ecx
80104326:	39 c8                	cmp    %ecx,%eax
80104328:	73 2e                	jae    80104358 <memmove+0x48>
8010432a:	85 db                	test   %ebx,%ebx
8010432c:	8d 3c 18             	lea    (%eax,%ebx,1),%edi
8010432f:	8d 53 ff             	lea    -0x1(%ebx),%edx
80104332:	74 1b                	je     8010434f <memmove+0x3f>
80104334:	f7 db                	neg    %ebx
80104336:	8d 34 19             	lea    (%ecx,%ebx,1),%esi
80104339:	01 fb                	add    %edi,%ebx
8010433b:	90                   	nop
8010433c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104340:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104344:	88 0c 13             	mov    %cl,(%ebx,%edx,1)
80104347:	83 ea 01             	sub    $0x1,%edx
8010434a:	83 fa ff             	cmp    $0xffffffff,%edx
8010434d:	75 f1                	jne    80104340 <memmove+0x30>
8010434f:	5b                   	pop    %ebx
80104350:	5e                   	pop    %esi
80104351:	5f                   	pop    %edi
80104352:	5d                   	pop    %ebp
80104353:	c3                   	ret    
80104354:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104358:	31 d2                	xor    %edx,%edx
8010435a:	85 db                	test   %ebx,%ebx
8010435c:	74 f1                	je     8010434f <memmove+0x3f>
8010435e:	66 90                	xchg   %ax,%ax
80104360:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104364:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104367:	83 c2 01             	add    $0x1,%edx
8010436a:	39 da                	cmp    %ebx,%edx
8010436c:	75 f2                	jne    80104360 <memmove+0x50>
8010436e:	5b                   	pop    %ebx
8010436f:	5e                   	pop    %esi
80104370:	5f                   	pop    %edi
80104371:	5d                   	pop    %ebp
80104372:	c3                   	ret    
80104373:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104379:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104380 <memcpy>:
80104380:	55                   	push   %ebp
80104381:	89 e5                	mov    %esp,%ebp
80104383:	5d                   	pop    %ebp
80104384:	e9 87 ff ff ff       	jmp    80104310 <memmove>
80104389:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104390 <strncmp>:
80104390:	55                   	push   %ebp
80104391:	89 e5                	mov    %esp,%ebp
80104393:	56                   	push   %esi
80104394:	8b 75 10             	mov    0x10(%ebp),%esi
80104397:	53                   	push   %ebx
80104398:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010439b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010439e:	85 f6                	test   %esi,%esi
801043a0:	74 30                	je     801043d2 <strncmp+0x42>
801043a2:	0f b6 01             	movzbl (%ecx),%eax
801043a5:	84 c0                	test   %al,%al
801043a7:	74 2f                	je     801043d8 <strncmp+0x48>
801043a9:	0f b6 13             	movzbl (%ebx),%edx
801043ac:	38 d0                	cmp    %dl,%al
801043ae:	75 46                	jne    801043f6 <strncmp+0x66>
801043b0:	8d 51 01             	lea    0x1(%ecx),%edx
801043b3:	01 ce                	add    %ecx,%esi
801043b5:	eb 14                	jmp    801043cb <strncmp+0x3b>
801043b7:	90                   	nop
801043b8:	0f b6 02             	movzbl (%edx),%eax
801043bb:	84 c0                	test   %al,%al
801043bd:	74 31                	je     801043f0 <strncmp+0x60>
801043bf:	0f b6 19             	movzbl (%ecx),%ebx
801043c2:	83 c2 01             	add    $0x1,%edx
801043c5:	38 d8                	cmp    %bl,%al
801043c7:	75 17                	jne    801043e0 <strncmp+0x50>
801043c9:	89 cb                	mov    %ecx,%ebx
801043cb:	39 f2                	cmp    %esi,%edx
801043cd:	8d 4b 01             	lea    0x1(%ebx),%ecx
801043d0:	75 e6                	jne    801043b8 <strncmp+0x28>
801043d2:	5b                   	pop    %ebx
801043d3:	31 c0                	xor    %eax,%eax
801043d5:	5e                   	pop    %esi
801043d6:	5d                   	pop    %ebp
801043d7:	c3                   	ret    
801043d8:	0f b6 1b             	movzbl (%ebx),%ebx
801043db:	31 c0                	xor    %eax,%eax
801043dd:	8d 76 00             	lea    0x0(%esi),%esi
801043e0:	0f b6 d3             	movzbl %bl,%edx
801043e3:	29 d0                	sub    %edx,%eax
801043e5:	5b                   	pop    %ebx
801043e6:	5e                   	pop    %esi
801043e7:	5d                   	pop    %ebp
801043e8:	c3                   	ret    
801043e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801043f0:	0f b6 5b 01          	movzbl 0x1(%ebx),%ebx
801043f4:	eb ea                	jmp    801043e0 <strncmp+0x50>
801043f6:	89 d3                	mov    %edx,%ebx
801043f8:	eb e6                	jmp    801043e0 <strncmp+0x50>
801043fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104400 <strncpy>:
80104400:	55                   	push   %ebp
80104401:	89 e5                	mov    %esp,%ebp
80104403:	8b 45 08             	mov    0x8(%ebp),%eax
80104406:	56                   	push   %esi
80104407:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010440a:	53                   	push   %ebx
8010440b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010440e:	89 c2                	mov    %eax,%edx
80104410:	eb 19                	jmp    8010442b <strncpy+0x2b>
80104412:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104418:	83 c3 01             	add    $0x1,%ebx
8010441b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
8010441f:	83 c2 01             	add    $0x1,%edx
80104422:	84 c9                	test   %cl,%cl
80104424:	88 4a ff             	mov    %cl,-0x1(%edx)
80104427:	74 09                	je     80104432 <strncpy+0x32>
80104429:	89 f1                	mov    %esi,%ecx
8010442b:	85 c9                	test   %ecx,%ecx
8010442d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104430:	7f e6                	jg     80104418 <strncpy+0x18>
80104432:	31 c9                	xor    %ecx,%ecx
80104434:	85 f6                	test   %esi,%esi
80104436:	7e 0f                	jle    80104447 <strncpy+0x47>
80104438:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
8010443c:	89 f3                	mov    %esi,%ebx
8010443e:	83 c1 01             	add    $0x1,%ecx
80104441:	29 cb                	sub    %ecx,%ebx
80104443:	85 db                	test   %ebx,%ebx
80104445:	7f f1                	jg     80104438 <strncpy+0x38>
80104447:	5b                   	pop    %ebx
80104448:	5e                   	pop    %esi
80104449:	5d                   	pop    %ebp
8010444a:	c3                   	ret    
8010444b:	90                   	nop
8010444c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104450 <safestrcpy>:
80104450:	55                   	push   %ebp
80104451:	89 e5                	mov    %esp,%ebp
80104453:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104456:	56                   	push   %esi
80104457:	8b 45 08             	mov    0x8(%ebp),%eax
8010445a:	53                   	push   %ebx
8010445b:	8b 55 0c             	mov    0xc(%ebp),%edx
8010445e:	85 c9                	test   %ecx,%ecx
80104460:	7e 26                	jle    80104488 <safestrcpy+0x38>
80104462:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104466:	89 c1                	mov    %eax,%ecx
80104468:	eb 17                	jmp    80104481 <safestrcpy+0x31>
8010446a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104470:	83 c2 01             	add    $0x1,%edx
80104473:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104477:	83 c1 01             	add    $0x1,%ecx
8010447a:	84 db                	test   %bl,%bl
8010447c:	88 59 ff             	mov    %bl,-0x1(%ecx)
8010447f:	74 04                	je     80104485 <safestrcpy+0x35>
80104481:	39 f2                	cmp    %esi,%edx
80104483:	75 eb                	jne    80104470 <safestrcpy+0x20>
80104485:	c6 01 00             	movb   $0x0,(%ecx)
80104488:	5b                   	pop    %ebx
80104489:	5e                   	pop    %esi
8010448a:	5d                   	pop    %ebp
8010448b:	c3                   	ret    
8010448c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104490 <strlen>:
80104490:	55                   	push   %ebp
80104491:	31 c0                	xor    %eax,%eax
80104493:	89 e5                	mov    %esp,%ebp
80104495:	8b 55 08             	mov    0x8(%ebp),%edx
80104498:	80 3a 00             	cmpb   $0x0,(%edx)
8010449b:	74 0c                	je     801044a9 <strlen+0x19>
8010449d:	8d 76 00             	lea    0x0(%esi),%esi
801044a0:	83 c0 01             	add    $0x1,%eax
801044a3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801044a7:	75 f7                	jne    801044a0 <strlen+0x10>
801044a9:	5d                   	pop    %ebp
801044aa:	c3                   	ret    
	...

801044ac <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
801044ac:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801044b0:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
801044b4:	55                   	push   %ebp
  pushl %ebx
801044b5:	53                   	push   %ebx
  pushl %esi
801044b6:	56                   	push   %esi
  pushl %edi
801044b7:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801044b8:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801044ba:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
801044bc:	5f                   	pop    %edi
  popl %esi
801044bd:	5e                   	pop    %esi
  popl %ebx
801044be:	5b                   	pop    %ebx
  popl %ebp
801044bf:	5d                   	pop    %ebp
  ret
801044c0:	c3                   	ret    
	...

801044d0 <fetchint>:
801044d0:	55                   	push   %ebp
801044d1:	89 e5                	mov    %esp,%ebp
801044d3:	53                   	push   %ebx
801044d4:	83 ec 04             	sub    $0x4,%esp
801044d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
801044da:	e8 81 f1 ff ff       	call   80103660 <myproc>
801044df:	8b 00                	mov    (%eax),%eax
801044e1:	39 d8                	cmp    %ebx,%eax
801044e3:	76 1b                	jbe    80104500 <fetchint+0x30>
801044e5:	8d 53 04             	lea    0x4(%ebx),%edx
801044e8:	39 d0                	cmp    %edx,%eax
801044ea:	72 14                	jb     80104500 <fetchint+0x30>
801044ec:	8b 45 0c             	mov    0xc(%ebp),%eax
801044ef:	8b 13                	mov    (%ebx),%edx
801044f1:	89 10                	mov    %edx,(%eax)
801044f3:	31 c0                	xor    %eax,%eax
801044f5:	83 c4 04             	add    $0x4,%esp
801044f8:	5b                   	pop    %ebx
801044f9:	5d                   	pop    %ebp
801044fa:	c3                   	ret    
801044fb:	90                   	nop
801044fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104500:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104505:	eb ee                	jmp    801044f5 <fetchint+0x25>
80104507:	89 f6                	mov    %esi,%esi
80104509:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104510 <fetchstr>:
80104510:	55                   	push   %ebp
80104511:	89 e5                	mov    %esp,%ebp
80104513:	53                   	push   %ebx
80104514:	83 ec 04             	sub    $0x4,%esp
80104517:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010451a:	e8 41 f1 ff ff       	call   80103660 <myproc>
8010451f:	39 18                	cmp    %ebx,(%eax)
80104521:	76 26                	jbe    80104549 <fetchstr+0x39>
80104523:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104526:	89 da                	mov    %ebx,%edx
80104528:	89 19                	mov    %ebx,(%ecx)
8010452a:	8b 00                	mov    (%eax),%eax
8010452c:	39 c3                	cmp    %eax,%ebx
8010452e:	73 19                	jae    80104549 <fetchstr+0x39>
80104530:	80 3b 00             	cmpb   $0x0,(%ebx)
80104533:	75 0d                	jne    80104542 <fetchstr+0x32>
80104535:	eb 21                	jmp    80104558 <fetchstr+0x48>
80104537:	90                   	nop
80104538:	80 3a 00             	cmpb   $0x0,(%edx)
8010453b:	90                   	nop
8010453c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104540:	74 16                	je     80104558 <fetchstr+0x48>
80104542:	83 c2 01             	add    $0x1,%edx
80104545:	39 d0                	cmp    %edx,%eax
80104547:	77 ef                	ja     80104538 <fetchstr+0x28>
80104549:	83 c4 04             	add    $0x4,%esp
8010454c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104551:	5b                   	pop    %ebx
80104552:	5d                   	pop    %ebp
80104553:	c3                   	ret    
80104554:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104558:	83 c4 04             	add    $0x4,%esp
8010455b:	89 d0                	mov    %edx,%eax
8010455d:	29 d8                	sub    %ebx,%eax
8010455f:	5b                   	pop    %ebx
80104560:	5d                   	pop    %ebp
80104561:	c3                   	ret    
80104562:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104569:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104570 <argint>:
80104570:	55                   	push   %ebp
80104571:	89 e5                	mov    %esp,%ebp
80104573:	56                   	push   %esi
80104574:	8b 75 0c             	mov    0xc(%ebp),%esi
80104577:	53                   	push   %ebx
80104578:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010457b:	e8 e0 f0 ff ff       	call   80103660 <myproc>
80104580:	89 75 0c             	mov    %esi,0xc(%ebp)
80104583:	8b 40 18             	mov    0x18(%eax),%eax
80104586:	8b 40 44             	mov    0x44(%eax),%eax
80104589:	8d 44 98 04          	lea    0x4(%eax,%ebx,4),%eax
8010458d:	89 45 08             	mov    %eax,0x8(%ebp)
80104590:	5b                   	pop    %ebx
80104591:	5e                   	pop    %esi
80104592:	5d                   	pop    %ebp
80104593:	e9 38 ff ff ff       	jmp    801044d0 <fetchint>
80104598:	90                   	nop
80104599:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801045a0 <argptr>:
801045a0:	55                   	push   %ebp
801045a1:	89 e5                	mov    %esp,%ebp
801045a3:	56                   	push   %esi
801045a4:	53                   	push   %ebx
801045a5:	83 ec 20             	sub    $0x20,%esp
801045a8:	8b 5d 10             	mov    0x10(%ebp),%ebx
801045ab:	e8 b0 f0 ff ff       	call   80103660 <myproc>
801045b0:	89 c6                	mov    %eax,%esi
801045b2:	8d 45 f4             	lea    -0xc(%ebp),%eax
801045b5:	89 44 24 04          	mov    %eax,0x4(%esp)
801045b9:	8b 45 08             	mov    0x8(%ebp),%eax
801045bc:	89 04 24             	mov    %eax,(%esp)
801045bf:	e8 ac ff ff ff       	call   80104570 <argint>
801045c4:	85 c0                	test   %eax,%eax
801045c6:	78 28                	js     801045f0 <argptr+0x50>
801045c8:	85 db                	test   %ebx,%ebx
801045ca:	78 24                	js     801045f0 <argptr+0x50>
801045cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
801045cf:	8b 06                	mov    (%esi),%eax
801045d1:	39 c2                	cmp    %eax,%edx
801045d3:	73 1b                	jae    801045f0 <argptr+0x50>
801045d5:	01 d3                	add    %edx,%ebx
801045d7:	39 d8                	cmp    %ebx,%eax
801045d9:	72 15                	jb     801045f0 <argptr+0x50>
801045db:	8b 45 0c             	mov    0xc(%ebp),%eax
801045de:	89 10                	mov    %edx,(%eax)
801045e0:	83 c4 20             	add    $0x20,%esp
801045e3:	31 c0                	xor    %eax,%eax
801045e5:	5b                   	pop    %ebx
801045e6:	5e                   	pop    %esi
801045e7:	5d                   	pop    %ebp
801045e8:	c3                   	ret    
801045e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045f0:	83 c4 20             	add    $0x20,%esp
801045f3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801045f8:	5b                   	pop    %ebx
801045f9:	5e                   	pop    %esi
801045fa:	5d                   	pop    %ebp
801045fb:	c3                   	ret    
801045fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104600 <argstr>:
80104600:	55                   	push   %ebp
80104601:	89 e5                	mov    %esp,%ebp
80104603:	83 ec 28             	sub    $0x28,%esp
80104606:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104609:	89 44 24 04          	mov    %eax,0x4(%esp)
8010460d:	8b 45 08             	mov    0x8(%ebp),%eax
80104610:	89 04 24             	mov    %eax,(%esp)
80104613:	e8 58 ff ff ff       	call   80104570 <argint>
80104618:	85 c0                	test   %eax,%eax
8010461a:	78 14                	js     80104630 <argstr+0x30>
8010461c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010461f:	89 44 24 04          	mov    %eax,0x4(%esp)
80104623:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104626:	89 04 24             	mov    %eax,(%esp)
80104629:	e8 e2 fe ff ff       	call   80104510 <fetchstr>
8010462e:	c9                   	leave  
8010462f:	c3                   	ret    
80104630:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104635:	c9                   	leave  
80104636:	c3                   	ret    
80104637:	89 f6                	mov    %esi,%esi
80104639:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104640 <syscall>:
80104640:	55                   	push   %ebp
80104641:	89 e5                	mov    %esp,%ebp
80104643:	56                   	push   %esi
80104644:	53                   	push   %ebx
80104645:	83 ec 10             	sub    $0x10,%esp
80104648:	e8 13 f0 ff ff       	call   80103660 <myproc>
8010464d:	8b 70 18             	mov    0x18(%eax),%esi
80104650:	89 c3                	mov    %eax,%ebx
80104652:	8b 46 1c             	mov    0x1c(%esi),%eax
80104655:	8d 50 ff             	lea    -0x1(%eax),%edx
80104658:	83 fa 17             	cmp    $0x17,%edx
8010465b:	77 1b                	ja     80104678 <syscall+0x38>
8010465d:	8b 14 85 00 75 10 80 	mov    -0x7fef8b00(,%eax,4),%edx
80104664:	85 d2                	test   %edx,%edx
80104666:	74 10                	je     80104678 <syscall+0x38>
80104668:	ff d2                	call   *%edx
8010466a:	89 46 1c             	mov    %eax,0x1c(%esi)
8010466d:	83 c4 10             	add    $0x10,%esp
80104670:	5b                   	pop    %ebx
80104671:	5e                   	pop    %esi
80104672:	5d                   	pop    %ebp
80104673:	c3                   	ret    
80104674:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104678:	89 44 24 0c          	mov    %eax,0xc(%esp)
8010467c:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010467f:	89 44 24 08          	mov    %eax,0x8(%esp)
80104683:	8b 43 10             	mov    0x10(%ebx),%eax
80104686:	c7 04 24 d1 74 10 80 	movl   $0x801074d1,(%esp)
8010468d:	89 44 24 04          	mov    %eax,0x4(%esp)
80104691:	e8 ba bf ff ff       	call   80100650 <cprintf>
80104696:	8b 43 18             	mov    0x18(%ebx),%eax
80104699:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
801046a0:	83 c4 10             	add    $0x10,%esp
801046a3:	5b                   	pop    %ebx
801046a4:	5e                   	pop    %esi
801046a5:	5d                   	pop    %ebp
801046a6:	c3                   	ret    
	...

801046b0 <argfd>:
801046b0:	55                   	push   %ebp
801046b1:	89 e5                	mov    %esp,%ebp
801046b3:	56                   	push   %esi
801046b4:	89 d6                	mov    %edx,%esi
801046b6:	53                   	push   %ebx
801046b7:	89 cb                	mov    %ecx,%ebx
801046b9:	83 ec 20             	sub    $0x20,%esp
801046bc:	8d 55 f4             	lea    -0xc(%ebp),%edx
801046bf:	89 54 24 04          	mov    %edx,0x4(%esp)
801046c3:	89 04 24             	mov    %eax,(%esp)
801046c6:	e8 a5 fe ff ff       	call   80104570 <argint>
801046cb:	85 c0                	test   %eax,%eax
801046cd:	78 31                	js     80104700 <argfd+0x50>
801046cf:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801046d3:	77 2b                	ja     80104700 <argfd+0x50>
801046d5:	e8 86 ef ff ff       	call   80103660 <myproc>
801046da:	8b 55 f4             	mov    -0xc(%ebp),%edx
801046dd:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
801046e1:	85 c0                	test   %eax,%eax
801046e3:	74 1b                	je     80104700 <argfd+0x50>
801046e5:	85 f6                	test   %esi,%esi
801046e7:	74 02                	je     801046eb <argfd+0x3b>
801046e9:	89 16                	mov    %edx,(%esi)
801046eb:	85 db                	test   %ebx,%ebx
801046ed:	74 21                	je     80104710 <argfd+0x60>
801046ef:	89 03                	mov    %eax,(%ebx)
801046f1:	31 c0                	xor    %eax,%eax
801046f3:	83 c4 20             	add    $0x20,%esp
801046f6:	5b                   	pop    %ebx
801046f7:	5e                   	pop    %esi
801046f8:	5d                   	pop    %ebp
801046f9:	c3                   	ret    
801046fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104700:	83 c4 20             	add    $0x20,%esp
80104703:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104708:	5b                   	pop    %ebx
80104709:	5e                   	pop    %esi
8010470a:	5d                   	pop    %ebp
8010470b:	c3                   	ret    
8010470c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104710:	31 c0                	xor    %eax,%eax
80104712:	eb df                	jmp    801046f3 <argfd+0x43>
80104714:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010471a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104720 <fdalloc>:
80104720:	55                   	push   %ebp
80104721:	89 e5                	mov    %esp,%ebp
80104723:	53                   	push   %ebx
80104724:	89 c3                	mov    %eax,%ebx
80104726:	83 ec 04             	sub    $0x4,%esp
80104729:	e8 32 ef ff ff       	call   80103660 <myproc>
8010472e:	31 d2                	xor    %edx,%edx
80104730:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80104734:	85 c9                	test   %ecx,%ecx
80104736:	74 18                	je     80104750 <fdalloc+0x30>
80104738:	83 c2 01             	add    $0x1,%edx
8010473b:	83 fa 10             	cmp    $0x10,%edx
8010473e:	75 f0                	jne    80104730 <fdalloc+0x10>
80104740:	83 c4 04             	add    $0x4,%esp
80104743:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104748:	5b                   	pop    %ebx
80104749:	5d                   	pop    %ebp
8010474a:	c3                   	ret    
8010474b:	90                   	nop
8010474c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104750:	89 5c 90 28          	mov    %ebx,0x28(%eax,%edx,4)
80104754:	83 c4 04             	add    $0x4,%esp
80104757:	89 d0                	mov    %edx,%eax
80104759:	5b                   	pop    %ebx
8010475a:	5d                   	pop    %ebp
8010475b:	c3                   	ret    
8010475c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104760 <create>:
80104760:	55                   	push   %ebp
80104761:	89 e5                	mov    %esp,%ebp
80104763:	57                   	push   %edi
80104764:	56                   	push   %esi
80104765:	53                   	push   %ebx
80104766:	83 ec 4c             	sub    $0x4c,%esp
80104769:	89 4d c0             	mov    %ecx,-0x40(%ebp)
8010476c:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010476f:	8d 5d da             	lea    -0x26(%ebp),%ebx
80104772:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104776:	89 04 24             	mov    %eax,(%esp)
80104779:	89 55 c4             	mov    %edx,-0x3c(%ebp)
8010477c:	89 4d bc             	mov    %ecx,-0x44(%ebp)
8010477f:	e8 5c d7 ff ff       	call   80101ee0 <nameiparent>
80104784:	85 c0                	test   %eax,%eax
80104786:	89 c7                	mov    %eax,%edi
80104788:	0f 84 da 00 00 00    	je     80104868 <create+0x108>
8010478e:	89 04 24             	mov    %eax,(%esp)
80104791:	e8 da ce ff ff       	call   80101670 <ilock>
80104796:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104799:	89 44 24 08          	mov    %eax,0x8(%esp)
8010479d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801047a1:	89 3c 24             	mov    %edi,(%esp)
801047a4:	e8 d7 d3 ff ff       	call   80101b80 <dirlookup>
801047a9:	85 c0                	test   %eax,%eax
801047ab:	89 c6                	mov    %eax,%esi
801047ad:	74 41                	je     801047f0 <create+0x90>
801047af:	89 3c 24             	mov    %edi,(%esp)
801047b2:	e8 19 d1 ff ff       	call   801018d0 <iunlockput>
801047b7:	89 34 24             	mov    %esi,(%esp)
801047ba:	e8 b1 ce ff ff       	call   80101670 <ilock>
801047bf:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
801047c4:	75 12                	jne    801047d8 <create+0x78>
801047c6:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
801047cb:	89 f0                	mov    %esi,%eax
801047cd:	75 09                	jne    801047d8 <create+0x78>
801047cf:	83 c4 4c             	add    $0x4c,%esp
801047d2:	5b                   	pop    %ebx
801047d3:	5e                   	pop    %esi
801047d4:	5f                   	pop    %edi
801047d5:	5d                   	pop    %ebp
801047d6:	c3                   	ret    
801047d7:	90                   	nop
801047d8:	89 34 24             	mov    %esi,(%esp)
801047db:	e8 f0 d0 ff ff       	call   801018d0 <iunlockput>
801047e0:	83 c4 4c             	add    $0x4c,%esp
801047e3:	31 c0                	xor    %eax,%eax
801047e5:	5b                   	pop    %ebx
801047e6:	5e                   	pop    %esi
801047e7:	5f                   	pop    %edi
801047e8:	5d                   	pop    %ebp
801047e9:	c3                   	ret    
801047ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801047f0:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801047f3:	89 44 24 04          	mov    %eax,0x4(%esp)
801047f7:	8b 07                	mov    (%edi),%eax
801047f9:	89 04 24             	mov    %eax,(%esp)
801047fc:	e8 df cc ff ff       	call   801014e0 <ialloc>
80104801:	85 c0                	test   %eax,%eax
80104803:	89 c6                	mov    %eax,%esi
80104805:	0f 84 c0 00 00 00    	je     801048cb <create+0x16b>
8010480b:	89 04 24             	mov    %eax,(%esp)
8010480e:	e8 5d ce ff ff       	call   80101670 <ilock>
80104813:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80104817:	66 89 46 52          	mov    %ax,0x52(%esi)
8010481b:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
8010481f:	66 89 46 54          	mov    %ax,0x54(%esi)
80104823:	b8 01 00 00 00       	mov    $0x1,%eax
80104828:	66 89 46 56          	mov    %ax,0x56(%esi)
8010482c:	89 34 24             	mov    %esi,(%esp)
8010482f:	e8 7c cd ff ff       	call   801015b0 <iupdate>
80104834:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
80104839:	74 35                	je     80104870 <create+0x110>
8010483b:	8b 46 04             	mov    0x4(%esi),%eax
8010483e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104842:	89 3c 24             	mov    %edi,(%esp)
80104845:	89 44 24 08          	mov    %eax,0x8(%esp)
80104849:	e8 92 d5 ff ff       	call   80101de0 <dirlink>
8010484e:	85 c0                	test   %eax,%eax
80104850:	78 6d                	js     801048bf <create+0x15f>
80104852:	89 3c 24             	mov    %edi,(%esp)
80104855:	e8 76 d0 ff ff       	call   801018d0 <iunlockput>
8010485a:	83 c4 4c             	add    $0x4c,%esp
8010485d:	89 f0                	mov    %esi,%eax
8010485f:	5b                   	pop    %ebx
80104860:	5e                   	pop    %esi
80104861:	5f                   	pop    %edi
80104862:	5d                   	pop    %ebp
80104863:	c3                   	ret    
80104864:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104868:	31 c0                	xor    %eax,%eax
8010486a:	e9 60 ff ff ff       	jmp    801047cf <create+0x6f>
8010486f:	90                   	nop
80104870:	66 83 47 56 01       	addw   $0x1,0x56(%edi)
80104875:	89 3c 24             	mov    %edi,(%esp)
80104878:	e8 33 cd ff ff       	call   801015b0 <iupdate>
8010487d:	8b 46 04             	mov    0x4(%esi),%eax
80104880:	c7 44 24 04 80 75 10 	movl   $0x80107580,0x4(%esp)
80104887:	80 
80104888:	89 34 24             	mov    %esi,(%esp)
8010488b:	89 44 24 08          	mov    %eax,0x8(%esp)
8010488f:	e8 4c d5 ff ff       	call   80101de0 <dirlink>
80104894:	85 c0                	test   %eax,%eax
80104896:	78 1b                	js     801048b3 <create+0x153>
80104898:	8b 47 04             	mov    0x4(%edi),%eax
8010489b:	c7 44 24 04 7f 75 10 	movl   $0x8010757f,0x4(%esp)
801048a2:	80 
801048a3:	89 34 24             	mov    %esi,(%esp)
801048a6:	89 44 24 08          	mov    %eax,0x8(%esp)
801048aa:	e8 31 d5 ff ff       	call   80101de0 <dirlink>
801048af:	85 c0                	test   %eax,%eax
801048b1:	79 88                	jns    8010483b <create+0xdb>
801048b3:	c7 04 24 73 75 10 80 	movl   $0x80107573,(%esp)
801048ba:	e8 a1 ba ff ff       	call   80100360 <panic>
801048bf:	c7 04 24 82 75 10 80 	movl   $0x80107582,(%esp)
801048c6:	e8 95 ba ff ff       	call   80100360 <panic>
801048cb:	c7 04 24 64 75 10 80 	movl   $0x80107564,(%esp)
801048d2:	e8 89 ba ff ff       	call   80100360 <panic>
801048d7:	89 f6                	mov    %esi,%esi
801048d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801048e0 <sys_dup>:
801048e0:	55                   	push   %ebp
801048e1:	31 d2                	xor    %edx,%edx
801048e3:	89 e5                	mov    %esp,%ebp
801048e5:	31 c0                	xor    %eax,%eax
801048e7:	53                   	push   %ebx
801048e8:	83 ec 24             	sub    $0x24,%esp
801048eb:	8d 4d f4             	lea    -0xc(%ebp),%ecx
801048ee:	e8 bd fd ff ff       	call   801046b0 <argfd>
801048f3:	85 c0                	test   %eax,%eax
801048f5:	78 21                	js     80104918 <sys_dup+0x38>
801048f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048fa:	e8 21 fe ff ff       	call   80104720 <fdalloc>
801048ff:	85 c0                	test   %eax,%eax
80104901:	89 c3                	mov    %eax,%ebx
80104903:	78 13                	js     80104918 <sys_dup+0x38>
80104905:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104908:	89 04 24             	mov    %eax,(%esp)
8010490b:	e8 80 c4 ff ff       	call   80100d90 <filedup>
80104910:	89 d8                	mov    %ebx,%eax
80104912:	83 c4 24             	add    $0x24,%esp
80104915:	5b                   	pop    %ebx
80104916:	5d                   	pop    %ebp
80104917:	c3                   	ret    
80104918:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010491d:	eb f3                	jmp    80104912 <sys_dup+0x32>
8010491f:	90                   	nop

80104920 <sys_read>:
80104920:	55                   	push   %ebp
80104921:	31 d2                	xor    %edx,%edx
80104923:	89 e5                	mov    %esp,%ebp
80104925:	31 c0                	xor    %eax,%eax
80104927:	83 ec 28             	sub    $0x28,%esp
8010492a:	8d 4d ec             	lea    -0x14(%ebp),%ecx
8010492d:	e8 7e fd ff ff       	call   801046b0 <argfd>
80104932:	85 c0                	test   %eax,%eax
80104934:	78 52                	js     80104988 <sys_read+0x68>
80104936:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104939:	89 44 24 04          	mov    %eax,0x4(%esp)
8010493d:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80104944:	e8 27 fc ff ff       	call   80104570 <argint>
80104949:	85 c0                	test   %eax,%eax
8010494b:	78 3b                	js     80104988 <sys_read+0x68>
8010494d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104950:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104957:	89 44 24 08          	mov    %eax,0x8(%esp)
8010495b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010495e:	89 44 24 04          	mov    %eax,0x4(%esp)
80104962:	e8 39 fc ff ff       	call   801045a0 <argptr>
80104967:	85 c0                	test   %eax,%eax
80104969:	78 1d                	js     80104988 <sys_read+0x68>
8010496b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010496e:	89 44 24 08          	mov    %eax,0x8(%esp)
80104972:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104975:	89 44 24 04          	mov    %eax,0x4(%esp)
80104979:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010497c:	89 04 24             	mov    %eax,(%esp)
8010497f:	e8 6c c5 ff ff       	call   80100ef0 <fileread>
80104984:	c9                   	leave  
80104985:	c3                   	ret    
80104986:	66 90                	xchg   %ax,%ax
80104988:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010498d:	c9                   	leave  
8010498e:	c3                   	ret    
8010498f:	90                   	nop

80104990 <sys_write>:
80104990:	55                   	push   %ebp
80104991:	31 d2                	xor    %edx,%edx
80104993:	89 e5                	mov    %esp,%ebp
80104995:	31 c0                	xor    %eax,%eax
80104997:	83 ec 28             	sub    $0x28,%esp
8010499a:	8d 4d ec             	lea    -0x14(%ebp),%ecx
8010499d:	e8 0e fd ff ff       	call   801046b0 <argfd>
801049a2:	85 c0                	test   %eax,%eax
801049a4:	78 52                	js     801049f8 <sys_write+0x68>
801049a6:	8d 45 f0             	lea    -0x10(%ebp),%eax
801049a9:	89 44 24 04          	mov    %eax,0x4(%esp)
801049ad:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
801049b4:	e8 b7 fb ff ff       	call   80104570 <argint>
801049b9:	85 c0                	test   %eax,%eax
801049bb:	78 3b                	js     801049f8 <sys_write+0x68>
801049bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801049c0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801049c7:	89 44 24 08          	mov    %eax,0x8(%esp)
801049cb:	8d 45 f4             	lea    -0xc(%ebp),%eax
801049ce:	89 44 24 04          	mov    %eax,0x4(%esp)
801049d2:	e8 c9 fb ff ff       	call   801045a0 <argptr>
801049d7:	85 c0                	test   %eax,%eax
801049d9:	78 1d                	js     801049f8 <sys_write+0x68>
801049db:	8b 45 f0             	mov    -0x10(%ebp),%eax
801049de:	89 44 24 08          	mov    %eax,0x8(%esp)
801049e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049e5:	89 44 24 04          	mov    %eax,0x4(%esp)
801049e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801049ec:	89 04 24             	mov    %eax,(%esp)
801049ef:	e8 9c c5 ff ff       	call   80100f90 <filewrite>
801049f4:	c9                   	leave  
801049f5:	c3                   	ret    
801049f6:	66 90                	xchg   %ax,%ax
801049f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801049fd:	c9                   	leave  
801049fe:	c3                   	ret    
801049ff:	90                   	nop

80104a00 <sys_close>:
80104a00:	55                   	push   %ebp
80104a01:	31 c0                	xor    %eax,%eax
80104a03:	89 e5                	mov    %esp,%ebp
80104a05:	83 ec 18             	sub    $0x18,%esp
80104a08:	8d 4d f4             	lea    -0xc(%ebp),%ecx
80104a0b:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104a0e:	e8 9d fc ff ff       	call   801046b0 <argfd>
80104a13:	85 c0                	test   %eax,%eax
80104a15:	78 19                	js     80104a30 <sys_close+0x30>
80104a17:	e8 44 ec ff ff       	call   80103660 <myproc>
80104a1c:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104a1f:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104a26:	00 
80104a27:	31 c0                	xor    %eax,%eax
80104a29:	c9                   	leave  
80104a2a:	c3                   	ret    
80104a2b:	90                   	nop
80104a2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a35:	c9                   	leave  
80104a36:	c3                   	ret    
80104a37:	89 f6                	mov    %esi,%esi
80104a39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104a40 <sys_fstat>:
80104a40:	55                   	push   %ebp
80104a41:	31 d2                	xor    %edx,%edx
80104a43:	89 e5                	mov    %esp,%ebp
80104a45:	31 c0                	xor    %eax,%eax
80104a47:	83 ec 28             	sub    $0x28,%esp
80104a4a:	8d 4d f0             	lea    -0x10(%ebp),%ecx
80104a4d:	e8 5e fc ff ff       	call   801046b0 <argfd>
80104a52:	85 c0                	test   %eax,%eax
80104a54:	78 3a                	js     80104a90 <sys_fstat+0x50>
80104a56:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104a59:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80104a60:	00 
80104a61:	89 44 24 04          	mov    %eax,0x4(%esp)
80104a65:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104a6c:	e8 2f fb ff ff       	call   801045a0 <argptr>
80104a71:	85 c0                	test   %eax,%eax
80104a73:	78 1b                	js     80104a90 <sys_fstat+0x50>
80104a75:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a78:	89 44 24 04          	mov    %eax,0x4(%esp)
80104a7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104a7f:	89 04 24             	mov    %eax,(%esp)
80104a82:	e8 19 c4 ff ff       	call   80100ea0 <filestat>
80104a87:	c9                   	leave  
80104a88:	c3                   	ret    
80104a89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a95:	c9                   	leave  
80104a96:	c3                   	ret    
80104a97:	89 f6                	mov    %esi,%esi
80104a99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104aa0 <sys_link>:
80104aa0:	55                   	push   %ebp
80104aa1:	89 e5                	mov    %esp,%ebp
80104aa3:	57                   	push   %edi
80104aa4:	56                   	push   %esi
80104aa5:	53                   	push   %ebx
80104aa6:	83 ec 3c             	sub    $0x3c,%esp
80104aa9:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104aac:	89 44 24 04          	mov    %eax,0x4(%esp)
80104ab0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104ab7:	e8 44 fb ff ff       	call   80104600 <argstr>
80104abc:	85 c0                	test   %eax,%eax
80104abe:	0f 88 de 00 00 00    	js     80104ba2 <sys_link+0x102>
80104ac4:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104ac7:	89 44 24 04          	mov    %eax,0x4(%esp)
80104acb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104ad2:	e8 29 fb ff ff       	call   80104600 <argstr>
80104ad7:	85 c0                	test   %eax,%eax
80104ad9:	0f 88 c3 00 00 00    	js     80104ba2 <sys_link+0x102>
80104adf:	e8 dc df ff ff       	call   80102ac0 <begin_op>
80104ae4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80104ae7:	89 04 24             	mov    %eax,(%esp)
80104aea:	e8 d1 d3 ff ff       	call   80101ec0 <namei>
80104aef:	85 c0                	test   %eax,%eax
80104af1:	89 c3                	mov    %eax,%ebx
80104af3:	0f 84 a4 00 00 00    	je     80104b9d <sys_link+0xfd>
80104af9:	89 04 24             	mov    %eax,(%esp)
80104afc:	e8 6f cb ff ff       	call   80101670 <ilock>
80104b01:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104b06:	0f 84 89 00 00 00    	je     80104b95 <sys_link+0xf5>
80104b0c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
80104b11:	8d 7d da             	lea    -0x26(%ebp),%edi
80104b14:	89 1c 24             	mov    %ebx,(%esp)
80104b17:	e8 94 ca ff ff       	call   801015b0 <iupdate>
80104b1c:	8b 45 d0             	mov    -0x30(%ebp),%eax
80104b1f:	89 7c 24 04          	mov    %edi,0x4(%esp)
80104b23:	89 04 24             	mov    %eax,(%esp)
80104b26:	e8 b5 d3 ff ff       	call   80101ee0 <nameiparent>
80104b2b:	85 c0                	test   %eax,%eax
80104b2d:	89 c6                	mov    %eax,%esi
80104b2f:	74 4f                	je     80104b80 <sys_link+0xe0>
80104b31:	89 04 24             	mov    %eax,(%esp)
80104b34:	e8 37 cb ff ff       	call   80101670 <ilock>
80104b39:	8b 03                	mov    (%ebx),%eax
80104b3b:	39 06                	cmp    %eax,(%esi)
80104b3d:	75 39                	jne    80104b78 <sys_link+0xd8>
80104b3f:	8b 43 04             	mov    0x4(%ebx),%eax
80104b42:	89 7c 24 04          	mov    %edi,0x4(%esp)
80104b46:	89 34 24             	mov    %esi,(%esp)
80104b49:	89 44 24 08          	mov    %eax,0x8(%esp)
80104b4d:	e8 8e d2 ff ff       	call   80101de0 <dirlink>
80104b52:	85 c0                	test   %eax,%eax
80104b54:	78 22                	js     80104b78 <sys_link+0xd8>
80104b56:	89 34 24             	mov    %esi,(%esp)
80104b59:	e8 72 cd ff ff       	call   801018d0 <iunlockput>
80104b5e:	89 1c 24             	mov    %ebx,(%esp)
80104b61:	e8 2a cc ff ff       	call   80101790 <iput>
80104b66:	e8 c5 df ff ff       	call   80102b30 <end_op>
80104b6b:	83 c4 3c             	add    $0x3c,%esp
80104b6e:	31 c0                	xor    %eax,%eax
80104b70:	5b                   	pop    %ebx
80104b71:	5e                   	pop    %esi
80104b72:	5f                   	pop    %edi
80104b73:	5d                   	pop    %ebp
80104b74:	c3                   	ret    
80104b75:	8d 76 00             	lea    0x0(%esi),%esi
80104b78:	89 34 24             	mov    %esi,(%esp)
80104b7b:	e8 50 cd ff ff       	call   801018d0 <iunlockput>
80104b80:	89 1c 24             	mov    %ebx,(%esp)
80104b83:	e8 e8 ca ff ff       	call   80101670 <ilock>
80104b88:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
80104b8d:	89 1c 24             	mov    %ebx,(%esp)
80104b90:	e8 1b ca ff ff       	call   801015b0 <iupdate>
80104b95:	89 1c 24             	mov    %ebx,(%esp)
80104b98:	e8 33 cd ff ff       	call   801018d0 <iunlockput>
80104b9d:	e8 8e df ff ff       	call   80102b30 <end_op>
80104ba2:	83 c4 3c             	add    $0x3c,%esp
80104ba5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104baa:	5b                   	pop    %ebx
80104bab:	5e                   	pop    %esi
80104bac:	5f                   	pop    %edi
80104bad:	5d                   	pop    %ebp
80104bae:	c3                   	ret    
80104baf:	90                   	nop

80104bb0 <sys_unlink>:
80104bb0:	55                   	push   %ebp
80104bb1:	89 e5                	mov    %esp,%ebp
80104bb3:	57                   	push   %edi
80104bb4:	56                   	push   %esi
80104bb5:	53                   	push   %ebx
80104bb6:	83 ec 5c             	sub    $0x5c,%esp
80104bb9:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104bbc:	89 44 24 04          	mov    %eax,0x4(%esp)
80104bc0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104bc7:	e8 34 fa ff ff       	call   80104600 <argstr>
80104bcc:	85 c0                	test   %eax,%eax
80104bce:	0f 88 76 01 00 00    	js     80104d4a <sys_unlink+0x19a>
80104bd4:	e8 e7 de ff ff       	call   80102ac0 <begin_op>
80104bd9:	8b 45 c0             	mov    -0x40(%ebp),%eax
80104bdc:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80104bdf:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104be3:	89 04 24             	mov    %eax,(%esp)
80104be6:	e8 f5 d2 ff ff       	call   80101ee0 <nameiparent>
80104beb:	85 c0                	test   %eax,%eax
80104bed:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80104bf0:	0f 84 4f 01 00 00    	je     80104d45 <sys_unlink+0x195>
80104bf6:	8b 75 b4             	mov    -0x4c(%ebp),%esi
80104bf9:	89 34 24             	mov    %esi,(%esp)
80104bfc:	e8 6f ca ff ff       	call   80101670 <ilock>
80104c01:	c7 44 24 04 80 75 10 	movl   $0x80107580,0x4(%esp)
80104c08:	80 
80104c09:	89 1c 24             	mov    %ebx,(%esp)
80104c0c:	e8 3f cf ff ff       	call   80101b50 <namecmp>
80104c11:	85 c0                	test   %eax,%eax
80104c13:	0f 84 21 01 00 00    	je     80104d3a <sys_unlink+0x18a>
80104c19:	c7 44 24 04 7f 75 10 	movl   $0x8010757f,0x4(%esp)
80104c20:	80 
80104c21:	89 1c 24             	mov    %ebx,(%esp)
80104c24:	e8 27 cf ff ff       	call   80101b50 <namecmp>
80104c29:	85 c0                	test   %eax,%eax
80104c2b:	0f 84 09 01 00 00    	je     80104d3a <sys_unlink+0x18a>
80104c31:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104c34:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104c38:	89 44 24 08          	mov    %eax,0x8(%esp)
80104c3c:	89 34 24             	mov    %esi,(%esp)
80104c3f:	e8 3c cf ff ff       	call   80101b80 <dirlookup>
80104c44:	85 c0                	test   %eax,%eax
80104c46:	89 c3                	mov    %eax,%ebx
80104c48:	0f 84 ec 00 00 00    	je     80104d3a <sys_unlink+0x18a>
80104c4e:	89 04 24             	mov    %eax,(%esp)
80104c51:	e8 1a ca ff ff       	call   80101670 <ilock>
80104c56:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80104c5b:	0f 8e 24 01 00 00    	jle    80104d85 <sys_unlink+0x1d5>
80104c61:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104c66:	8d 75 d8             	lea    -0x28(%ebp),%esi
80104c69:	74 7d                	je     80104ce8 <sys_unlink+0x138>
80104c6b:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80104c72:	00 
80104c73:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80104c7a:	00 
80104c7b:	89 34 24             	mov    %esi,(%esp)
80104c7e:	e8 ed f5 ff ff       	call   80104270 <memset>
80104c83:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80104c86:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80104c8d:	00 
80104c8e:	89 74 24 04          	mov    %esi,0x4(%esp)
80104c92:	89 44 24 08          	mov    %eax,0x8(%esp)
80104c96:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104c99:	89 04 24             	mov    %eax,(%esp)
80104c9c:	e8 7f cd ff ff       	call   80101a20 <writei>
80104ca1:	83 f8 10             	cmp    $0x10,%eax
80104ca4:	0f 85 cf 00 00 00    	jne    80104d79 <sys_unlink+0x1c9>
80104caa:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104caf:	0f 84 a3 00 00 00    	je     80104d58 <sys_unlink+0x1a8>
80104cb5:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104cb8:	89 04 24             	mov    %eax,(%esp)
80104cbb:	e8 10 cc ff ff       	call   801018d0 <iunlockput>
80104cc0:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
80104cc5:	89 1c 24             	mov    %ebx,(%esp)
80104cc8:	e8 e3 c8 ff ff       	call   801015b0 <iupdate>
80104ccd:	89 1c 24             	mov    %ebx,(%esp)
80104cd0:	e8 fb cb ff ff       	call   801018d0 <iunlockput>
80104cd5:	e8 56 de ff ff       	call   80102b30 <end_op>
80104cda:	83 c4 5c             	add    $0x5c,%esp
80104cdd:	31 c0                	xor    %eax,%eax
80104cdf:	5b                   	pop    %ebx
80104ce0:	5e                   	pop    %esi
80104ce1:	5f                   	pop    %edi
80104ce2:	5d                   	pop    %ebp
80104ce3:	c3                   	ret    
80104ce4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104ce8:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80104cec:	0f 86 79 ff ff ff    	jbe    80104c6b <sys_unlink+0xbb>
80104cf2:	bf 20 00 00 00       	mov    $0x20,%edi
80104cf7:	eb 15                	jmp    80104d0e <sys_unlink+0x15e>
80104cf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d00:	8d 57 10             	lea    0x10(%edi),%edx
80104d03:	3b 53 58             	cmp    0x58(%ebx),%edx
80104d06:	0f 83 5f ff ff ff    	jae    80104c6b <sys_unlink+0xbb>
80104d0c:	89 d7                	mov    %edx,%edi
80104d0e:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80104d15:	00 
80104d16:	89 7c 24 08          	mov    %edi,0x8(%esp)
80104d1a:	89 74 24 04          	mov    %esi,0x4(%esp)
80104d1e:	89 1c 24             	mov    %ebx,(%esp)
80104d21:	e8 fa cb ff ff       	call   80101920 <readi>
80104d26:	83 f8 10             	cmp    $0x10,%eax
80104d29:	75 42                	jne    80104d6d <sys_unlink+0x1bd>
80104d2b:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80104d30:	74 ce                	je     80104d00 <sys_unlink+0x150>
80104d32:	89 1c 24             	mov    %ebx,(%esp)
80104d35:	e8 96 cb ff ff       	call   801018d0 <iunlockput>
80104d3a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104d3d:	89 04 24             	mov    %eax,(%esp)
80104d40:	e8 8b cb ff ff       	call   801018d0 <iunlockput>
80104d45:	e8 e6 dd ff ff       	call   80102b30 <end_op>
80104d4a:	83 c4 5c             	add    $0x5c,%esp
80104d4d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d52:	5b                   	pop    %ebx
80104d53:	5e                   	pop    %esi
80104d54:	5f                   	pop    %edi
80104d55:	5d                   	pop    %ebp
80104d56:	c3                   	ret    
80104d57:	90                   	nop
80104d58:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104d5b:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
80104d60:	89 04 24             	mov    %eax,(%esp)
80104d63:	e8 48 c8 ff ff       	call   801015b0 <iupdate>
80104d68:	e9 48 ff ff ff       	jmp    80104cb5 <sys_unlink+0x105>
80104d6d:	c7 04 24 a4 75 10 80 	movl   $0x801075a4,(%esp)
80104d74:	e8 e7 b5 ff ff       	call   80100360 <panic>
80104d79:	c7 04 24 b6 75 10 80 	movl   $0x801075b6,(%esp)
80104d80:	e8 db b5 ff ff       	call   80100360 <panic>
80104d85:	c7 04 24 92 75 10 80 	movl   $0x80107592,(%esp)
80104d8c:	e8 cf b5 ff ff       	call   80100360 <panic>
80104d91:	eb 0d                	jmp    80104da0 <sys_open>
80104d93:	90                   	nop
80104d94:	90                   	nop
80104d95:	90                   	nop
80104d96:	90                   	nop
80104d97:	90                   	nop
80104d98:	90                   	nop
80104d99:	90                   	nop
80104d9a:	90                   	nop
80104d9b:	90                   	nop
80104d9c:	90                   	nop
80104d9d:	90                   	nop
80104d9e:	90                   	nop
80104d9f:	90                   	nop

80104da0 <sys_open>:
80104da0:	55                   	push   %ebp
80104da1:	89 e5                	mov    %esp,%ebp
80104da3:	57                   	push   %edi
80104da4:	56                   	push   %esi
80104da5:	53                   	push   %ebx
80104da6:	83 ec 2c             	sub    $0x2c,%esp
80104da9:	8d 45 e0             	lea    -0x20(%ebp),%eax
80104dac:	89 44 24 04          	mov    %eax,0x4(%esp)
80104db0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104db7:	e8 44 f8 ff ff       	call   80104600 <argstr>
80104dbc:	85 c0                	test   %eax,%eax
80104dbe:	0f 88 d1 00 00 00    	js     80104e95 <sys_open+0xf5>
80104dc4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80104dc7:	89 44 24 04          	mov    %eax,0x4(%esp)
80104dcb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104dd2:	e8 99 f7 ff ff       	call   80104570 <argint>
80104dd7:	85 c0                	test   %eax,%eax
80104dd9:	0f 88 b6 00 00 00    	js     80104e95 <sys_open+0xf5>
80104ddf:	e8 dc dc ff ff       	call   80102ac0 <begin_op>
80104de4:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80104de8:	0f 85 82 00 00 00    	jne    80104e70 <sys_open+0xd0>
80104dee:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104df1:	89 04 24             	mov    %eax,(%esp)
80104df4:	e8 c7 d0 ff ff       	call   80101ec0 <namei>
80104df9:	85 c0                	test   %eax,%eax
80104dfb:	89 c6                	mov    %eax,%esi
80104dfd:	0f 84 8d 00 00 00    	je     80104e90 <sys_open+0xf0>
80104e03:	89 04 24             	mov    %eax,(%esp)
80104e06:	e8 65 c8 ff ff       	call   80101670 <ilock>
80104e0b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80104e10:	0f 84 92 00 00 00    	je     80104ea8 <sys_open+0x108>
80104e16:	e8 55 bf ff ff       	call   80100d70 <filealloc>
80104e1b:	85 c0                	test   %eax,%eax
80104e1d:	89 c3                	mov    %eax,%ebx
80104e1f:	0f 84 93 00 00 00    	je     80104eb8 <sys_open+0x118>
80104e25:	e8 f6 f8 ff ff       	call   80104720 <fdalloc>
80104e2a:	85 c0                	test   %eax,%eax
80104e2c:	89 c7                	mov    %eax,%edi
80104e2e:	0f 88 94 00 00 00    	js     80104ec8 <sys_open+0x128>
80104e34:	89 34 24             	mov    %esi,(%esp)
80104e37:	e8 14 c9 ff ff       	call   80101750 <iunlock>
80104e3c:	e8 ef dc ff ff       	call   80102b30 <end_op>
80104e41:	c7 03 02 00 00 00    	movl   $0x2,(%ebx)
80104e47:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104e4a:	89 73 10             	mov    %esi,0x10(%ebx)
80104e4d:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
80104e54:	89 c2                	mov    %eax,%edx
80104e56:	83 e2 01             	and    $0x1,%edx
80104e59:	83 f2 01             	xor    $0x1,%edx
80104e5c:	a8 03                	test   $0x3,%al
80104e5e:	88 53 08             	mov    %dl,0x8(%ebx)
80104e61:	89 f8                	mov    %edi,%eax
80104e63:	0f 95 43 09          	setne  0x9(%ebx)
80104e67:	83 c4 2c             	add    $0x2c,%esp
80104e6a:	5b                   	pop    %ebx
80104e6b:	5e                   	pop    %esi
80104e6c:	5f                   	pop    %edi
80104e6d:	5d                   	pop    %ebp
80104e6e:	c3                   	ret    
80104e6f:	90                   	nop
80104e70:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104e73:	31 c9                	xor    %ecx,%ecx
80104e75:	ba 02 00 00 00       	mov    $0x2,%edx
80104e7a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104e81:	e8 da f8 ff ff       	call   80104760 <create>
80104e86:	85 c0                	test   %eax,%eax
80104e88:	89 c6                	mov    %eax,%esi
80104e8a:	75 8a                	jne    80104e16 <sys_open+0x76>
80104e8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e90:	e8 9b dc ff ff       	call   80102b30 <end_op>
80104e95:	83 c4 2c             	add    $0x2c,%esp
80104e98:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e9d:	5b                   	pop    %ebx
80104e9e:	5e                   	pop    %esi
80104e9f:	5f                   	pop    %edi
80104ea0:	5d                   	pop    %ebp
80104ea1:	c3                   	ret    
80104ea2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104ea8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104eab:	85 c0                	test   %eax,%eax
80104ead:	0f 84 63 ff ff ff    	je     80104e16 <sys_open+0x76>
80104eb3:	90                   	nop
80104eb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104eb8:	89 34 24             	mov    %esi,(%esp)
80104ebb:	e8 10 ca ff ff       	call   801018d0 <iunlockput>
80104ec0:	eb ce                	jmp    80104e90 <sys_open+0xf0>
80104ec2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104ec8:	89 1c 24             	mov    %ebx,(%esp)
80104ecb:	e8 10 bf ff ff       	call   80100de0 <fileclose>
80104ed0:	eb e6                	jmp    80104eb8 <sys_open+0x118>
80104ed2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ed9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ee0 <sys_mkdir>:
80104ee0:	55                   	push   %ebp
80104ee1:	89 e5                	mov    %esp,%ebp
80104ee3:	83 ec 28             	sub    $0x28,%esp
80104ee6:	e8 d5 db ff ff       	call   80102ac0 <begin_op>
80104eeb:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104eee:	89 44 24 04          	mov    %eax,0x4(%esp)
80104ef2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104ef9:	e8 02 f7 ff ff       	call   80104600 <argstr>
80104efe:	85 c0                	test   %eax,%eax
80104f00:	78 2e                	js     80104f30 <sys_mkdir+0x50>
80104f02:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f05:	31 c9                	xor    %ecx,%ecx
80104f07:	ba 01 00 00 00       	mov    $0x1,%edx
80104f0c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104f13:	e8 48 f8 ff ff       	call   80104760 <create>
80104f18:	85 c0                	test   %eax,%eax
80104f1a:	74 14                	je     80104f30 <sys_mkdir+0x50>
80104f1c:	89 04 24             	mov    %eax,(%esp)
80104f1f:	e8 ac c9 ff ff       	call   801018d0 <iunlockput>
80104f24:	e8 07 dc ff ff       	call   80102b30 <end_op>
80104f29:	31 c0                	xor    %eax,%eax
80104f2b:	c9                   	leave  
80104f2c:	c3                   	ret    
80104f2d:	8d 76 00             	lea    0x0(%esi),%esi
80104f30:	e8 fb db ff ff       	call   80102b30 <end_op>
80104f35:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f3a:	c9                   	leave  
80104f3b:	c3                   	ret    
80104f3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104f40 <sys_mknod>:
80104f40:	55                   	push   %ebp
80104f41:	89 e5                	mov    %esp,%ebp
80104f43:	83 ec 28             	sub    $0x28,%esp
80104f46:	e8 75 db ff ff       	call   80102ac0 <begin_op>
80104f4b:	8d 45 ec             	lea    -0x14(%ebp),%eax
80104f4e:	89 44 24 04          	mov    %eax,0x4(%esp)
80104f52:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104f59:	e8 a2 f6 ff ff       	call   80104600 <argstr>
80104f5e:	85 c0                	test   %eax,%eax
80104f60:	78 5e                	js     80104fc0 <sys_mknod+0x80>
80104f62:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104f65:	89 44 24 04          	mov    %eax,0x4(%esp)
80104f69:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104f70:	e8 fb f5 ff ff       	call   80104570 <argint>
80104f75:	85 c0                	test   %eax,%eax
80104f77:	78 47                	js     80104fc0 <sys_mknod+0x80>
80104f79:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104f7c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104f80:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80104f87:	e8 e4 f5 ff ff       	call   80104570 <argint>
80104f8c:	85 c0                	test   %eax,%eax
80104f8e:	78 30                	js     80104fc0 <sys_mknod+0x80>
80104f90:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80104f94:	ba 03 00 00 00       	mov    $0x3,%edx
80104f99:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80104f9d:	89 04 24             	mov    %eax,(%esp)
80104fa0:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104fa3:	e8 b8 f7 ff ff       	call   80104760 <create>
80104fa8:	85 c0                	test   %eax,%eax
80104faa:	74 14                	je     80104fc0 <sys_mknod+0x80>
80104fac:	89 04 24             	mov    %eax,(%esp)
80104faf:	e8 1c c9 ff ff       	call   801018d0 <iunlockput>
80104fb4:	e8 77 db ff ff       	call   80102b30 <end_op>
80104fb9:	31 c0                	xor    %eax,%eax
80104fbb:	c9                   	leave  
80104fbc:	c3                   	ret    
80104fbd:	8d 76 00             	lea    0x0(%esi),%esi
80104fc0:	e8 6b db ff ff       	call   80102b30 <end_op>
80104fc5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fca:	c9                   	leave  
80104fcb:	c3                   	ret    
80104fcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104fd0 <sys_chdir>:
80104fd0:	55                   	push   %ebp
80104fd1:	89 e5                	mov    %esp,%ebp
80104fd3:	56                   	push   %esi
80104fd4:	53                   	push   %ebx
80104fd5:	83 ec 20             	sub    $0x20,%esp
80104fd8:	e8 83 e6 ff ff       	call   80103660 <myproc>
80104fdd:	89 c6                	mov    %eax,%esi
80104fdf:	e8 dc da ff ff       	call   80102ac0 <begin_op>
80104fe4:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104fe7:	89 44 24 04          	mov    %eax,0x4(%esp)
80104feb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104ff2:	e8 09 f6 ff ff       	call   80104600 <argstr>
80104ff7:	85 c0                	test   %eax,%eax
80104ff9:	78 4a                	js     80105045 <sys_chdir+0x75>
80104ffb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ffe:	89 04 24             	mov    %eax,(%esp)
80105001:	e8 ba ce ff ff       	call   80101ec0 <namei>
80105006:	85 c0                	test   %eax,%eax
80105008:	89 c3                	mov    %eax,%ebx
8010500a:	74 39                	je     80105045 <sys_chdir+0x75>
8010500c:	89 04 24             	mov    %eax,(%esp)
8010500f:	e8 5c c6 ff ff       	call   80101670 <ilock>
80105014:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105019:	89 1c 24             	mov    %ebx,(%esp)
8010501c:	75 22                	jne    80105040 <sys_chdir+0x70>
8010501e:	e8 2d c7 ff ff       	call   80101750 <iunlock>
80105023:	8b 46 68             	mov    0x68(%esi),%eax
80105026:	89 04 24             	mov    %eax,(%esp)
80105029:	e8 62 c7 ff ff       	call   80101790 <iput>
8010502e:	e8 fd da ff ff       	call   80102b30 <end_op>
80105033:	31 c0                	xor    %eax,%eax
80105035:	89 5e 68             	mov    %ebx,0x68(%esi)
80105038:	83 c4 20             	add    $0x20,%esp
8010503b:	5b                   	pop    %ebx
8010503c:	5e                   	pop    %esi
8010503d:	5d                   	pop    %ebp
8010503e:	c3                   	ret    
8010503f:	90                   	nop
80105040:	e8 8b c8 ff ff       	call   801018d0 <iunlockput>
80105045:	e8 e6 da ff ff       	call   80102b30 <end_op>
8010504a:	83 c4 20             	add    $0x20,%esp
8010504d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105052:	5b                   	pop    %ebx
80105053:	5e                   	pop    %esi
80105054:	5d                   	pop    %ebp
80105055:	c3                   	ret    
80105056:	8d 76 00             	lea    0x0(%esi),%esi
80105059:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105060 <sys_exec>:
80105060:	55                   	push   %ebp
80105061:	89 e5                	mov    %esp,%ebp
80105063:	57                   	push   %edi
80105064:	56                   	push   %esi
80105065:	53                   	push   %ebx
80105066:	81 ec ac 00 00 00    	sub    $0xac,%esp
8010506c:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
80105072:	89 44 24 04          	mov    %eax,0x4(%esp)
80105076:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010507d:	e8 7e f5 ff ff       	call   80104600 <argstr>
80105082:	85 c0                	test   %eax,%eax
80105084:	0f 88 84 00 00 00    	js     8010510e <sys_exec+0xae>
8010508a:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105090:	89 44 24 04          	mov    %eax,0x4(%esp)
80105094:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010509b:	e8 d0 f4 ff ff       	call   80104570 <argint>
801050a0:	85 c0                	test   %eax,%eax
801050a2:	78 6a                	js     8010510e <sys_exec+0xae>
801050a4:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801050aa:	31 db                	xor    %ebx,%ebx
801050ac:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
801050b3:	00 
801050b4:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
801050ba:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801050c1:	00 
801050c2:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
801050c8:	89 04 24             	mov    %eax,(%esp)
801050cb:	e8 a0 f1 ff ff       	call   80104270 <memset>
801050d0:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801050d6:	89 7c 24 04          	mov    %edi,0x4(%esp)
801050da:	8d 04 98             	lea    (%eax,%ebx,4),%eax
801050dd:	89 04 24             	mov    %eax,(%esp)
801050e0:	e8 eb f3 ff ff       	call   801044d0 <fetchint>
801050e5:	85 c0                	test   %eax,%eax
801050e7:	78 25                	js     8010510e <sys_exec+0xae>
801050e9:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801050ef:	85 c0                	test   %eax,%eax
801050f1:	74 2d                	je     80105120 <sys_exec+0xc0>
801050f3:	89 74 24 04          	mov    %esi,0x4(%esp)
801050f7:	89 04 24             	mov    %eax,(%esp)
801050fa:	e8 11 f4 ff ff       	call   80104510 <fetchstr>
801050ff:	85 c0                	test   %eax,%eax
80105101:	78 0b                	js     8010510e <sys_exec+0xae>
80105103:	83 c3 01             	add    $0x1,%ebx
80105106:	83 c6 04             	add    $0x4,%esi
80105109:	83 fb 20             	cmp    $0x20,%ebx
8010510c:	75 c2                	jne    801050d0 <sys_exec+0x70>
8010510e:	81 c4 ac 00 00 00    	add    $0xac,%esp
80105114:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105119:	5b                   	pop    %ebx
8010511a:	5e                   	pop    %esi
8010511b:	5f                   	pop    %edi
8010511c:	5d                   	pop    %ebp
8010511d:	c3                   	ret    
8010511e:	66 90                	xchg   %ax,%ax
80105120:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105126:	89 44 24 04          	mov    %eax,0x4(%esp)
8010512a:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
80105130:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105137:	00 00 00 00 
8010513b:	89 04 24             	mov    %eax,(%esp)
8010513e:	e8 5d b8 ff ff       	call   801009a0 <exec>
80105143:	81 c4 ac 00 00 00    	add    $0xac,%esp
80105149:	5b                   	pop    %ebx
8010514a:	5e                   	pop    %esi
8010514b:	5f                   	pop    %edi
8010514c:	5d                   	pop    %ebp
8010514d:	c3                   	ret    
8010514e:	66 90                	xchg   %ax,%ax

80105150 <sys_pipe>:
80105150:	55                   	push   %ebp
80105151:	89 e5                	mov    %esp,%ebp
80105153:	53                   	push   %ebx
80105154:	83 ec 24             	sub    $0x24,%esp
80105157:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010515a:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
80105161:	00 
80105162:	89 44 24 04          	mov    %eax,0x4(%esp)
80105166:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010516d:	e8 2e f4 ff ff       	call   801045a0 <argptr>
80105172:	85 c0                	test   %eax,%eax
80105174:	78 6d                	js     801051e3 <sys_pipe+0x93>
80105176:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105179:	89 44 24 04          	mov    %eax,0x4(%esp)
8010517d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105180:	89 04 24             	mov    %eax,(%esp)
80105183:	e8 98 df ff ff       	call   80103120 <pipealloc>
80105188:	85 c0                	test   %eax,%eax
8010518a:	78 57                	js     801051e3 <sys_pipe+0x93>
8010518c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010518f:	e8 8c f5 ff ff       	call   80104720 <fdalloc>
80105194:	85 c0                	test   %eax,%eax
80105196:	89 c3                	mov    %eax,%ebx
80105198:	78 33                	js     801051cd <sys_pipe+0x7d>
8010519a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010519d:	e8 7e f5 ff ff       	call   80104720 <fdalloc>
801051a2:	85 c0                	test   %eax,%eax
801051a4:	78 1a                	js     801051c0 <sys_pipe+0x70>
801051a6:	8b 55 ec             	mov    -0x14(%ebp),%edx
801051a9:	89 1a                	mov    %ebx,(%edx)
801051ab:	8b 55 ec             	mov    -0x14(%ebp),%edx
801051ae:	89 42 04             	mov    %eax,0x4(%edx)
801051b1:	83 c4 24             	add    $0x24,%esp
801051b4:	31 c0                	xor    %eax,%eax
801051b6:	5b                   	pop    %ebx
801051b7:	5d                   	pop    %ebp
801051b8:	c3                   	ret    
801051b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801051c0:	e8 9b e4 ff ff       	call   80103660 <myproc>
801051c5:	c7 44 98 28 00 00 00 	movl   $0x0,0x28(%eax,%ebx,4)
801051cc:	00 
801051cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801051d0:	89 04 24             	mov    %eax,(%esp)
801051d3:	e8 08 bc ff ff       	call   80100de0 <fileclose>
801051d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051db:	89 04 24             	mov    %eax,(%esp)
801051de:	e8 fd bb ff ff       	call   80100de0 <fileclose>
801051e3:	83 c4 24             	add    $0x24,%esp
801051e6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051eb:	5b                   	pop    %ebx
801051ec:	5d                   	pop    %ebp
801051ed:	c3                   	ret    
801051ee:	66 90                	xchg   %ax,%ax

801051f0 <sys_dup2>:
801051f0:	55                   	push   %ebp
801051f1:	31 c0                	xor    %eax,%eax
801051f3:	89 e5                	mov    %esp,%ebp
801051f5:	83 ec 28             	sub    $0x28,%esp
801051f8:	8d 4d f0             	lea    -0x10(%ebp),%ecx
801051fb:	8d 55 e8             	lea    -0x18(%ebp),%edx
801051fe:	e8 ad f4 ff ff       	call   801046b0 <argfd>
80105203:	85 c0                	test   %eax,%eax
80105205:	78 61                	js     80105268 <sys_dup2+0x78>
80105207:	8d 4d f4             	lea    -0xc(%ebp),%ecx
8010520a:	b8 01 00 00 00       	mov    $0x1,%eax
8010520f:	8d 55 ec             	lea    -0x14(%ebp),%edx
80105212:	e8 99 f4 ff ff       	call   801046b0 <argfd>
80105217:	85 c0                	test   %eax,%eax
80105219:	78 4d                	js     80105268 <sys_dup2+0x78>
8010521b:	e8 40 e4 ff ff       	call   80103660 <myproc>
80105220:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105223:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
8010522a:	00 
8010522b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010522e:	89 04 24             	mov    %eax,(%esp)
80105231:	e8 aa bb ff ff       	call   80100de0 <fileclose>
80105236:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105239:	e8 e2 f4 ff ff       	call   80104720 <fdalloc>
8010523e:	85 c0                	test   %eax,%eax
80105240:	89 45 ec             	mov    %eax,-0x14(%ebp)
80105243:	78 13                	js     80105258 <sys_dup2+0x68>
80105245:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105248:	89 04 24             	mov    %eax,(%esp)
8010524b:	e8 40 bb ff ff       	call   80100d90 <filedup>
80105250:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105253:	c9                   	leave  
80105254:	c3                   	ret    
80105255:	8d 76 00             	lea    0x0(%esi),%esi
80105258:	c7 04 24 c5 75 10 80 	movl   $0x801075c5,(%esp)
8010525f:	e8 ec b3 ff ff       	call   80100650 <cprintf>
80105264:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105268:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010526d:	c9                   	leave  
8010526e:	c3                   	ret    
	...

80105270 <sys_fork>:
80105270:	55                   	push   %ebp
80105271:	89 e5                	mov    %esp,%ebp
80105273:	5d                   	pop    %ebp
80105274:	e9 97 e5 ff ff       	jmp    80103810 <fork>
80105279:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105280 <sys_exit>:
80105280:	55                   	push   %ebp
80105281:	89 e5                	mov    %esp,%ebp
80105283:	83 ec 08             	sub    $0x8,%esp
80105286:	e8 d5 e7 ff ff       	call   80103a60 <exit>
8010528b:	31 c0                	xor    %eax,%eax
8010528d:	c9                   	leave  
8010528e:	c3                   	ret    
8010528f:	90                   	nop

80105290 <sys_wait>:
80105290:	55                   	push   %ebp
80105291:	89 e5                	mov    %esp,%ebp
80105293:	5d                   	pop    %ebp
80105294:	e9 e7 e9 ff ff       	jmp    80103c80 <wait>
80105299:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801052a0 <sys_kill>:
801052a0:	55                   	push   %ebp
801052a1:	89 e5                	mov    %esp,%ebp
801052a3:	83 ec 28             	sub    $0x28,%esp
801052a6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801052a9:	89 44 24 04          	mov    %eax,0x4(%esp)
801052ad:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801052b4:	e8 b7 f2 ff ff       	call   80104570 <argint>
801052b9:	85 c0                	test   %eax,%eax
801052bb:	78 13                	js     801052d0 <sys_kill+0x30>
801052bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801052c0:	89 04 24             	mov    %eax,(%esp)
801052c3:	e8 18 eb ff ff       	call   80103de0 <kill>
801052c8:	c9                   	leave  
801052c9:	c3                   	ret    
801052ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801052d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052d5:	c9                   	leave  
801052d6:	c3                   	ret    
801052d7:	89 f6                	mov    %esi,%esi
801052d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801052e0 <sys_getpid>:
801052e0:	55                   	push   %ebp
801052e1:	89 e5                	mov    %esp,%ebp
801052e3:	83 ec 08             	sub    $0x8,%esp
801052e6:	e8 75 e3 ff ff       	call   80103660 <myproc>
801052eb:	8b 40 10             	mov    0x10(%eax),%eax
801052ee:	c9                   	leave  
801052ef:	c3                   	ret    

801052f0 <sys_sbrk>:
801052f0:	55                   	push   %ebp
801052f1:	89 e5                	mov    %esp,%ebp
801052f3:	53                   	push   %ebx
801052f4:	83 ec 24             	sub    $0x24,%esp
801052f7:	8d 45 f4             	lea    -0xc(%ebp),%eax
801052fa:	89 44 24 04          	mov    %eax,0x4(%esp)
801052fe:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105305:	e8 66 f2 ff ff       	call   80104570 <argint>
8010530a:	85 c0                	test   %eax,%eax
8010530c:	78 1a                	js     80105328 <sys_sbrk+0x38>
8010530e:	e8 4d e3 ff ff       	call   80103660 <myproc>
80105313:	8b 18                	mov    (%eax),%ebx
80105315:	e8 46 e3 ff ff       	call   80103660 <myproc>
8010531a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010531d:	01 10                	add    %edx,(%eax)
8010531f:	89 d8                	mov    %ebx,%eax
80105321:	83 c4 24             	add    $0x24,%esp
80105324:	5b                   	pop    %ebx
80105325:	5d                   	pop    %ebp
80105326:	c3                   	ret    
80105327:	90                   	nop
80105328:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010532d:	eb f2                	jmp    80105321 <sys_sbrk+0x31>
8010532f:	90                   	nop

80105330 <sys_sleep>:
80105330:	55                   	push   %ebp
80105331:	89 e5                	mov    %esp,%ebp
80105333:	53                   	push   %ebx
80105334:	83 ec 24             	sub    $0x24,%esp
80105337:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010533a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010533e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105345:	e8 26 f2 ff ff       	call   80104570 <argint>
8010534a:	85 c0                	test   %eax,%eax
8010534c:	78 7e                	js     801053cc <sys_sleep+0x9c>
8010534e:	c7 04 24 60 4f 11 80 	movl   $0x80114f60,(%esp)
80105355:	e8 d6 ed ff ff       	call   80104130 <acquire>
8010535a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010535d:	8b 1d a0 57 11 80    	mov    0x801157a0,%ebx
80105363:	85 d2                	test   %edx,%edx
80105365:	75 29                	jne    80105390 <sys_sleep+0x60>
80105367:	eb 4f                	jmp    801053b8 <sys_sleep+0x88>
80105369:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105370:	c7 44 24 04 60 4f 11 	movl   $0x80114f60,0x4(%esp)
80105377:	80 
80105378:	c7 04 24 a0 57 11 80 	movl   $0x801157a0,(%esp)
8010537f:	e8 4c e8 ff ff       	call   80103bd0 <sleep>
80105384:	a1 a0 57 11 80       	mov    0x801157a0,%eax
80105389:	29 d8                	sub    %ebx,%eax
8010538b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010538e:	73 28                	jae    801053b8 <sys_sleep+0x88>
80105390:	e8 cb e2 ff ff       	call   80103660 <myproc>
80105395:	8b 40 24             	mov    0x24(%eax),%eax
80105398:	85 c0                	test   %eax,%eax
8010539a:	74 d4                	je     80105370 <sys_sleep+0x40>
8010539c:	c7 04 24 60 4f 11 80 	movl   $0x80114f60,(%esp)
801053a3:	e8 78 ee ff ff       	call   80104220 <release>
801053a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053ad:	83 c4 24             	add    $0x24,%esp
801053b0:	5b                   	pop    %ebx
801053b1:	5d                   	pop    %ebp
801053b2:	c3                   	ret    
801053b3:	90                   	nop
801053b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801053b8:	c7 04 24 60 4f 11 80 	movl   $0x80114f60,(%esp)
801053bf:	e8 5c ee ff ff       	call   80104220 <release>
801053c4:	83 c4 24             	add    $0x24,%esp
801053c7:	31 c0                	xor    %eax,%eax
801053c9:	5b                   	pop    %ebx
801053ca:	5d                   	pop    %ebp
801053cb:	c3                   	ret    
801053cc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053d1:	eb da                	jmp    801053ad <sys_sleep+0x7d>
801053d3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801053d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801053e0 <sys_uptime>:
801053e0:	55                   	push   %ebp
801053e1:	89 e5                	mov    %esp,%ebp
801053e3:	53                   	push   %ebx
801053e4:	83 ec 14             	sub    $0x14,%esp
801053e7:	c7 04 24 60 4f 11 80 	movl   $0x80114f60,(%esp)
801053ee:	e8 3d ed ff ff       	call   80104130 <acquire>
801053f3:	8b 1d a0 57 11 80    	mov    0x801157a0,%ebx
801053f9:	c7 04 24 60 4f 11 80 	movl   $0x80114f60,(%esp)
80105400:	e8 1b ee ff ff       	call   80104220 <release>
80105405:	83 c4 14             	add    $0x14,%esp
80105408:	89 d8                	mov    %ebx,%eax
8010540a:	5b                   	pop    %ebx
8010540b:	5d                   	pop    %ebp
8010540c:	c3                   	ret    
8010540d:	8d 76 00             	lea    0x0(%esi),%esi

80105410 <sys_date>:
80105410:	55                   	push   %ebp
80105411:	89 e5                	mov    %esp,%ebp
80105413:	83 ec 28             	sub    $0x28,%esp
80105416:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105419:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80105420:	00 
80105421:	89 44 24 04          	mov    %eax,0x4(%esp)
80105425:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010542c:	e8 6f f1 ff ff       	call   801045a0 <argptr>
80105431:	85 c0                	test   %eax,%eax
80105433:	78 13                	js     80105448 <sys_date+0x38>
80105435:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105438:	89 04 24             	mov    %eax,(%esp)
8010543b:	e8 b0 d3 ff ff       	call   801027f0 <cmostime>
80105440:	31 c0                	xor    %eax,%eax
80105442:	c9                   	leave  
80105443:	c3                   	ret    
80105444:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105448:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010544d:	c9                   	leave  
8010544e:	c3                   	ret    
8010544f:	90                   	nop

80105450 <sys_alarm>:
80105450:	55                   	push   %ebp
80105451:	89 e5                	mov    %esp,%ebp
80105453:	83 ec 28             	sub    $0x28,%esp
80105456:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105459:	89 44 24 04          	mov    %eax,0x4(%esp)
8010545d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105464:	e8 07 f1 ff ff       	call   80104570 <argint>
80105469:	85 c0                	test   %eax,%eax
8010546b:	78 43                	js     801054b0 <sys_alarm+0x60>
8010546d:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105470:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
80105477:	00 
80105478:	89 44 24 04          	mov    %eax,0x4(%esp)
8010547c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105483:	e8 18 f1 ff ff       	call   801045a0 <argptr>
80105488:	85 c0                	test   %eax,%eax
8010548a:	78 24                	js     801054b0 <sys_alarm+0x60>
8010548c:	e8 cf e1 ff ff       	call   80103660 <myproc>
80105491:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105494:	89 50 7c             	mov    %edx,0x7c(%eax)
80105497:	e8 c4 e1 ff ff       	call   80103660 <myproc>
8010549c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010549f:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
801054a5:	31 c0                	xor    %eax,%eax
801054a7:	c9                   	leave  
801054a8:	c3                   	ret    
801054a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801054b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054b5:	c9                   	leave  
801054b6:	c3                   	ret    
	...

801054b8 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801054b8:	1e                   	push   %ds
  pushl %es
801054b9:	06                   	push   %es
  pushl %fs
801054ba:	0f a0                	push   %fs
  pushl %gs
801054bc:	0f a8                	push   %gs
  pushal
801054be:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
801054bf:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801054c3:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801054c5:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
801054c7:	54                   	push   %esp
  call trap
801054c8:	e8 e3 00 00 00       	call   801055b0 <trap>
  addl $4, %esp
801054cd:	83 c4 04             	add    $0x4,%esp

801054d0 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801054d0:	61                   	popa   
  popl %gs
801054d1:	0f a9                	pop    %gs
  popl %fs
801054d3:	0f a1                	pop    %fs
  popl %es
801054d5:	07                   	pop    %es
  popl %ds
801054d6:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801054d7:	83 c4 08             	add    $0x8,%esp
  iret
801054da:	cf                   	iret   
801054db:	00 00                	add    %al,(%eax)
801054dd:	00 00                	add    %al,(%eax)
	...

801054e0 <tvinit>:
801054e0:	31 c0                	xor    %eax,%eax
801054e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801054e8:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
801054ef:	b9 08 00 00 00       	mov    $0x8,%ecx
801054f4:	66 89 0c c5 a2 4f 11 	mov    %cx,-0x7feeb05e(,%eax,8)
801054fb:	80 
801054fc:	c6 04 c5 a4 4f 11 80 	movb   $0x0,-0x7feeb05c(,%eax,8)
80105503:	00 
80105504:	c6 04 c5 a5 4f 11 80 	movb   $0x8e,-0x7feeb05b(,%eax,8)
8010550b:	8e 
8010550c:	66 89 14 c5 a0 4f 11 	mov    %dx,-0x7feeb060(,%eax,8)
80105513:	80 
80105514:	c1 ea 10             	shr    $0x10,%edx
80105517:	66 89 14 c5 a6 4f 11 	mov    %dx,-0x7feeb05a(,%eax,8)
8010551e:	80 
8010551f:	83 c0 01             	add    $0x1,%eax
80105522:	3d 00 01 00 00       	cmp    $0x100,%eax
80105527:	75 bf                	jne    801054e8 <tvinit+0x8>
80105529:	55                   	push   %ebp
8010552a:	ba 08 00 00 00       	mov    $0x8,%edx
8010552f:	89 e5                	mov    %esp,%ebp
80105531:	83 ec 18             	sub    $0x18,%esp
80105534:	a1 08 a1 10 80       	mov    0x8010a108,%eax
80105539:	c7 44 24 04 d6 75 10 	movl   $0x801075d6,0x4(%esp)
80105540:	80 
80105541:	c7 04 24 60 4f 11 80 	movl   $0x80114f60,(%esp)
80105548:	66 89 15 a2 51 11 80 	mov    %dx,0x801151a2
8010554f:	66 a3 a0 51 11 80    	mov    %ax,0x801151a0
80105555:	c1 e8 10             	shr    $0x10,%eax
80105558:	c6 05 a4 51 11 80 00 	movb   $0x0,0x801151a4
8010555f:	c6 05 a5 51 11 80 ef 	movb   $0xef,0x801151a5
80105566:	66 a3 a6 51 11 80    	mov    %ax,0x801151a6
8010556c:	e8 cf ea ff ff       	call   80104040 <initlock>
80105571:	c9                   	leave  
80105572:	c3                   	ret    
80105573:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105579:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105580 <idtinit>:
80105580:	55                   	push   %ebp
80105581:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105586:	89 e5                	mov    %esp,%ebp
80105588:	83 ec 10             	sub    $0x10,%esp
8010558b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
8010558f:	b8 a0 4f 11 80       	mov    $0x80114fa0,%eax
80105594:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80105598:	c1 e8 10             	shr    $0x10,%eax
8010559b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
8010559f:	8d 45 fa             	lea    -0x6(%ebp),%eax
801055a2:	0f 01 18             	lidtl  (%eax)
801055a5:	c9                   	leave  
801055a6:	c3                   	ret    
801055a7:	89 f6                	mov    %esi,%esi
801055a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801055b0 <trap>:
801055b0:	55                   	push   %ebp
801055b1:	89 e5                	mov    %esp,%ebp
801055b3:	57                   	push   %edi
801055b4:	56                   	push   %esi
801055b5:	53                   	push   %ebx
801055b6:	83 ec 3c             	sub    $0x3c,%esp
801055b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801055bc:	8b 43 30             	mov    0x30(%ebx),%eax
801055bf:	83 f8 40             	cmp    $0x40,%eax
801055c2:	0f 84 38 01 00 00    	je     80105700 <trap+0x150>
801055c8:	83 f8 0e             	cmp    $0xe,%eax
801055cb:	0f 84 ff 01 00 00    	je     801057d0 <trap+0x220>
801055d1:	83 e8 20             	sub    $0x20,%eax
801055d4:	83 f8 1f             	cmp    $0x1f,%eax
801055d7:	0f 87 63 01 00 00    	ja     80105740 <trap+0x190>
801055dd:	ff 24 85 a0 76 10 80 	jmp    *-0x7fef8960(,%eax,4)
801055e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801055e8:	e8 53 e0 ff ff       	call   80103640 <cpuid>
801055ed:	85 c0                	test   %eax,%eax
801055ef:	90                   	nop
801055f0:	0f 84 72 02 00 00    	je     80105868 <trap+0x2b8>
801055f6:	e8 65 e0 ff ff       	call   80103660 <myproc>
801055fb:	85 c0                	test   %eax,%eax
801055fd:	8d 76 00             	lea    0x0(%esi),%esi
80105600:	74 11                	je     80105613 <trap+0x63>
80105602:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105606:	83 e0 03             	and    $0x3,%eax
80105609:	66 83 f8 03          	cmp    $0x3,%ax
8010560d:	0f 84 85 02 00 00    	je     80105898 <trap+0x2e8>
80105613:	e8 18 d1 ff ff       	call   80102730 <lapiceoi>
80105618:	e8 43 e0 ff ff       	call   80103660 <myproc>
8010561d:	85 c0                	test   %eax,%eax
8010561f:	90                   	nop
80105620:	74 0c                	je     8010562e <trap+0x7e>
80105622:	e8 39 e0 ff ff       	call   80103660 <myproc>
80105627:	8b 40 24             	mov    0x24(%eax),%eax
8010562a:	85 c0                	test   %eax,%eax
8010562c:	75 4a                	jne    80105678 <trap+0xc8>
8010562e:	e8 2d e0 ff ff       	call   80103660 <myproc>
80105633:	85 c0                	test   %eax,%eax
80105635:	74 0b                	je     80105642 <trap+0x92>
80105637:	e8 24 e0 ff ff       	call   80103660 <myproc>
8010563c:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105640:	74 4e                	je     80105690 <trap+0xe0>
80105642:	e8 19 e0 ff ff       	call   80103660 <myproc>
80105647:	85 c0                	test   %eax,%eax
80105649:	74 22                	je     8010566d <trap+0xbd>
8010564b:	90                   	nop
8010564c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105650:	e8 0b e0 ff ff       	call   80103660 <myproc>
80105655:	8b 40 24             	mov    0x24(%eax),%eax
80105658:	85 c0                	test   %eax,%eax
8010565a:	74 11                	je     8010566d <trap+0xbd>
8010565c:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105660:	83 e0 03             	and    $0x3,%eax
80105663:	66 83 f8 03          	cmp    $0x3,%ax
80105667:	0f 84 c0 00 00 00    	je     8010572d <trap+0x17d>
8010566d:	83 c4 3c             	add    $0x3c,%esp
80105670:	5b                   	pop    %ebx
80105671:	5e                   	pop    %esi
80105672:	5f                   	pop    %edi
80105673:	5d                   	pop    %ebp
80105674:	c3                   	ret    
80105675:	8d 76 00             	lea    0x0(%esi),%esi
80105678:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
8010567c:	83 e0 03             	and    $0x3,%eax
8010567f:	66 83 f8 03          	cmp    $0x3,%ax
80105683:	75 a9                	jne    8010562e <trap+0x7e>
80105685:	e8 d6 e3 ff ff       	call   80103a60 <exit>
8010568a:	eb a2                	jmp    8010562e <trap+0x7e>
8010568c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105690:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105694:	75 ac                	jne    80105642 <trap+0x92>
80105696:	e8 f5 e4 ff ff       	call   80103b90 <yield>
8010569b:	eb a5                	jmp    80105642 <trap+0x92>
8010569d:	8d 76 00             	lea    0x0(%esi),%esi
801056a0:	e8 eb ce ff ff       	call   80102590 <kbdintr>
801056a5:	e8 86 d0 ff ff       	call   80102730 <lapiceoi>
801056aa:	e9 69 ff ff ff       	jmp    80105618 <trap+0x68>
801056af:	90                   	nop
801056b0:	e8 9b 03 00 00       	call   80105a50 <uartintr>
801056b5:	e8 76 d0 ff ff       	call   80102730 <lapiceoi>
801056ba:	e9 59 ff ff ff       	jmp    80105618 <trap+0x68>
801056bf:	90                   	nop
801056c0:	8b 7b 38             	mov    0x38(%ebx),%edi
801056c3:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
801056c7:	e8 74 df ff ff       	call   80103640 <cpuid>
801056cc:	c7 04 24 04 76 10 80 	movl   $0x80107604,(%esp)
801056d3:	89 7c 24 0c          	mov    %edi,0xc(%esp)
801056d7:	89 74 24 08          	mov    %esi,0x8(%esp)
801056db:	89 44 24 04          	mov    %eax,0x4(%esp)
801056df:	e8 6c af ff ff       	call   80100650 <cprintf>
801056e4:	e8 47 d0 ff ff       	call   80102730 <lapiceoi>
801056e9:	e9 2a ff ff ff       	jmp    80105618 <trap+0x68>
801056ee:	66 90                	xchg   %ax,%ax
801056f0:	e8 4b c9 ff ff       	call   80102040 <ideintr>
801056f5:	e9 19 ff ff ff       	jmp    80105613 <trap+0x63>
801056fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105700:	e8 5b df ff ff       	call   80103660 <myproc>
80105705:	8b 40 24             	mov    0x24(%eax),%eax
80105708:	85 c0                	test   %eax,%eax
8010570a:	0f 85 48 01 00 00    	jne    80105858 <trap+0x2a8>
80105710:	e8 4b df ff ff       	call   80103660 <myproc>
80105715:	89 58 18             	mov    %ebx,0x18(%eax)
80105718:	e8 23 ef ff ff       	call   80104640 <syscall>
8010571d:	e8 3e df ff ff       	call   80103660 <myproc>
80105722:	8b 40 24             	mov    0x24(%eax),%eax
80105725:	85 c0                	test   %eax,%eax
80105727:	0f 84 40 ff ff ff    	je     8010566d <trap+0xbd>
8010572d:	83 c4 3c             	add    $0x3c,%esp
80105730:	5b                   	pop    %ebx
80105731:	5e                   	pop    %esi
80105732:	5f                   	pop    %edi
80105733:	5d                   	pop    %ebp
80105734:	e9 27 e3 ff ff       	jmp    80103a60 <exit>
80105739:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105740:	e8 1b df ff ff       	call   80103660 <myproc>
80105745:	85 c0                	test   %eax,%eax
80105747:	0f 84 b6 01 00 00    	je     80105903 <trap+0x353>
8010574d:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105751:	0f 84 ac 01 00 00    	je     80105903 <trap+0x353>
80105757:	0f 20 d1             	mov    %cr2,%ecx
8010575a:	8b 53 38             	mov    0x38(%ebx),%edx
8010575d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
80105760:	89 55 dc             	mov    %edx,-0x24(%ebp)
80105763:	e8 d8 de ff ff       	call   80103640 <cpuid>
80105768:	8b 73 30             	mov    0x30(%ebx),%esi
8010576b:	89 c7                	mov    %eax,%edi
8010576d:	8b 43 34             	mov    0x34(%ebx),%eax
80105770:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80105773:	e8 e8 de ff ff       	call   80103660 <myproc>
80105778:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010577b:	e8 e0 de ff ff       	call   80103660 <myproc>
80105780:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105783:	89 74 24 0c          	mov    %esi,0xc(%esp)
80105787:	8b 75 e0             	mov    -0x20(%ebp),%esi
8010578a:	8b 55 dc             	mov    -0x24(%ebp),%edx
8010578d:	89 7c 24 14          	mov    %edi,0x14(%esp)
80105791:	89 4c 24 1c          	mov    %ecx,0x1c(%esp)
80105795:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105798:	83 c6 6c             	add    $0x6c,%esi
8010579b:	89 54 24 18          	mov    %edx,0x18(%esp)
8010579f:	89 74 24 08          	mov    %esi,0x8(%esp)
801057a3:	89 4c 24 10          	mov    %ecx,0x10(%esp)
801057a7:	8b 40 10             	mov    0x10(%eax),%eax
801057aa:	c7 04 24 5c 76 10 80 	movl   $0x8010765c,(%esp)
801057b1:	89 44 24 04          	mov    %eax,0x4(%esp)
801057b5:	e8 96 ae ff ff       	call   80100650 <cprintf>
801057ba:	e8 a1 de ff ff       	call   80103660 <myproc>
801057bf:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
801057c6:	e9 4d fe ff ff       	jmp    80105618 <trap+0x68>
801057cb:	90                   	nop
801057cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801057d0:	e8 8b cc ff ff       	call   80102460 <kalloc>
801057d5:	85 c0                	test   %eax,%eax
801057d7:	89 c3                	mov    %eax,%ebx
801057d9:	0f 84 11 01 00 00    	je     801058f0 <trap+0x340>
801057df:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801057e6:	00 
801057e7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801057ee:	00 
801057ef:	89 04 24             	mov    %eax,(%esp)
801057f2:	e8 79 ea ff ff       	call   80104270 <memset>
801057f7:	0f 20 d6             	mov    %cr2,%esi
801057fa:	e8 61 de ff ff       	call   80103660 <myproc>
801057ff:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
80105805:	8d 93 00 00 00 80    	lea    -0x80000000(%ebx),%edx
8010580b:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
80105812:	00 
80105813:	89 54 24 0c          	mov    %edx,0xc(%esp)
80105817:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010581e:	00 
8010581f:	89 74 24 04          	mov    %esi,0x4(%esp)
80105823:	8b 40 04             	mov    0x4(%eax),%eax
80105826:	89 04 24             	mov    %eax,(%esp)
80105829:	e8 a2 0e 00 00       	call   801066d0 <mappages>
8010582e:	85 c0                	test   %eax,%eax
80105830:	0f 89 37 fe ff ff    	jns    8010566d <trap+0xbd>
80105836:	c7 04 24 f1 75 10 80 	movl   $0x801075f1,(%esp)
8010583d:	e8 0e ae ff ff       	call   80100650 <cprintf>
80105842:	89 5d 08             	mov    %ebx,0x8(%ebp)
80105845:	83 c4 3c             	add    $0x3c,%esp
80105848:	5b                   	pop    %ebx
80105849:	5e                   	pop    %esi
8010584a:	5f                   	pop    %edi
8010584b:	5d                   	pop    %ebp
8010584c:	e9 5f ca ff ff       	jmp    801022b0 <kfree>
80105851:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105858:	e8 03 e2 ff ff       	call   80103a60 <exit>
8010585d:	e9 ae fe ff ff       	jmp    80105710 <trap+0x160>
80105862:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105868:	c7 04 24 60 4f 11 80 	movl   $0x80114f60,(%esp)
8010586f:	e8 bc e8 ff ff       	call   80104130 <acquire>
80105874:	c7 04 24 a0 57 11 80 	movl   $0x801157a0,(%esp)
8010587b:	83 05 a0 57 11 80 01 	addl   $0x1,0x801157a0
80105882:	e8 e9 e4 ff ff       	call   80103d70 <wakeup>
80105887:	c7 04 24 60 4f 11 80 	movl   $0x80114f60,(%esp)
8010588e:	e8 8d e9 ff ff       	call   80104220 <release>
80105893:	e9 5e fd ff ff       	jmp    801055f6 <trap+0x46>
80105898:	e8 c3 dd ff ff       	call   80103660 <myproc>
8010589d:	83 80 84 00 00 00 01 	addl   $0x1,0x84(%eax)
801058a4:	e8 b7 dd ff ff       	call   80103660 <myproc>
801058a9:	8b b0 84 00 00 00    	mov    0x84(%eax),%esi
801058af:	e8 ac dd ff ff       	call   80103660 <myproc>
801058b4:	3b 70 7c             	cmp    0x7c(%eax),%esi
801058b7:	0f 8c 56 fd ff ff    	jl     80105613 <trap+0x63>
801058bd:	e8 9e dd ff ff       	call   80103660 <myproc>
801058c2:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%eax)
801058c9:	00 00 00 
801058cc:	8b 43 44             	mov    0x44(%ebx),%eax
801058cf:	8d 50 fc             	lea    -0x4(%eax),%edx
801058d2:	89 53 44             	mov    %edx,0x44(%ebx)
801058d5:	8b 53 38             	mov    0x38(%ebx),%edx
801058d8:	89 50 fc             	mov    %edx,-0x4(%eax)
801058db:	e8 80 dd ff ff       	call   80103660 <myproc>
801058e0:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
801058e6:	89 43 38             	mov    %eax,0x38(%ebx)
801058e9:	e9 25 fd ff ff       	jmp    80105613 <trap+0x63>
801058ee:	66 90                	xchg   %ax,%ax
801058f0:	c7 45 08 db 75 10 80 	movl   $0x801075db,0x8(%ebp)
801058f7:	83 c4 3c             	add    $0x3c,%esp
801058fa:	5b                   	pop    %ebx
801058fb:	5e                   	pop    %esi
801058fc:	5f                   	pop    %edi
801058fd:	5d                   	pop    %ebp
801058fe:	e9 4d ad ff ff       	jmp    80100650 <cprintf>
80105903:	0f 20 d7             	mov    %cr2,%edi
80105906:	8b 73 38             	mov    0x38(%ebx),%esi
80105909:	e8 32 dd ff ff       	call   80103640 <cpuid>
8010590e:	89 7c 24 10          	mov    %edi,0x10(%esp)
80105912:	89 74 24 0c          	mov    %esi,0xc(%esp)
80105916:	89 44 24 08          	mov    %eax,0x8(%esp)
8010591a:	8b 43 30             	mov    0x30(%ebx),%eax
8010591d:	c7 04 24 28 76 10 80 	movl   $0x80107628,(%esp)
80105924:	89 44 24 04          	mov    %eax,0x4(%esp)
80105928:	e8 23 ad ff ff       	call   80100650 <cprintf>
8010592d:	c7 04 24 ff 75 10 80 	movl   $0x801075ff,(%esp)
80105934:	e8 27 aa ff ff       	call   80100360 <panic>
80105939:	00 00                	add    %al,(%eax)
8010593b:	00 00                	add    %al,(%eax)
8010593d:	00 00                	add    %al,(%eax)
	...

80105940 <uartgetc>:
80105940:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
80105945:	55                   	push   %ebp
80105946:	89 e5                	mov    %esp,%ebp
80105948:	85 c0                	test   %eax,%eax
8010594a:	74 14                	je     80105960 <uartgetc+0x20>
8010594c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105951:	ec                   	in     (%dx),%al
80105952:	a8 01                	test   $0x1,%al
80105954:	74 0a                	je     80105960 <uartgetc+0x20>
80105956:	b2 f8                	mov    $0xf8,%dl
80105958:	ec                   	in     (%dx),%al
80105959:	0f b6 c0             	movzbl %al,%eax
8010595c:	5d                   	pop    %ebp
8010595d:	c3                   	ret    
8010595e:	66 90                	xchg   %ax,%ax
80105960:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105965:	5d                   	pop    %ebp
80105966:	c3                   	ret    
80105967:	89 f6                	mov    %esi,%esi
80105969:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105970 <uartputc>:
80105970:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
80105976:	85 d2                	test   %edx,%edx
80105978:	74 3e                	je     801059b8 <uartputc+0x48>
8010597a:	55                   	push   %ebp
8010597b:	89 e5                	mov    %esp,%ebp
8010597d:	56                   	push   %esi
8010597e:	be fd 03 00 00       	mov    $0x3fd,%esi
80105983:	53                   	push   %ebx
80105984:	bb 80 00 00 00       	mov    $0x80,%ebx
80105989:	83 ec 10             	sub    $0x10,%esp
8010598c:	eb 13                	jmp    801059a1 <uartputc+0x31>
8010598e:	66 90                	xchg   %ax,%ax
80105990:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
80105997:	e8 b4 cd ff ff       	call   80102750 <microdelay>
8010599c:	83 eb 01             	sub    $0x1,%ebx
8010599f:	74 07                	je     801059a8 <uartputc+0x38>
801059a1:	89 f2                	mov    %esi,%edx
801059a3:	ec                   	in     (%dx),%al
801059a4:	a8 20                	test   $0x20,%al
801059a6:	74 e8                	je     80105990 <uartputc+0x20>
801059a8:	0f b6 45 08          	movzbl 0x8(%ebp),%eax
801059ac:	ba f8 03 00 00       	mov    $0x3f8,%edx
801059b1:	ee                   	out    %al,(%dx)
801059b2:	83 c4 10             	add    $0x10,%esp
801059b5:	5b                   	pop    %ebx
801059b6:	5e                   	pop    %esi
801059b7:	5d                   	pop    %ebp
801059b8:	f3 c3                	repz ret 
801059ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801059c0 <uartinit>:
801059c0:	ba fa 03 00 00       	mov    $0x3fa,%edx
801059c5:	31 c0                	xor    %eax,%eax
801059c7:	ee                   	out    %al,(%dx)
801059c8:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
801059cd:	b2 fb                	mov    $0xfb,%dl
801059cf:	ee                   	out    %al,(%dx)
801059d0:	b8 0c 00 00 00       	mov    $0xc,%eax
801059d5:	b2 f8                	mov    $0xf8,%dl
801059d7:	ee                   	out    %al,(%dx)
801059d8:	31 c0                	xor    %eax,%eax
801059da:	b2 f9                	mov    $0xf9,%dl
801059dc:	ee                   	out    %al,(%dx)
801059dd:	b8 03 00 00 00       	mov    $0x3,%eax
801059e2:	b2 fb                	mov    $0xfb,%dl
801059e4:	ee                   	out    %al,(%dx)
801059e5:	31 c0                	xor    %eax,%eax
801059e7:	b2 fc                	mov    $0xfc,%dl
801059e9:	ee                   	out    %al,(%dx)
801059ea:	b8 01 00 00 00       	mov    $0x1,%eax
801059ef:	b2 f9                	mov    $0xf9,%dl
801059f1:	ee                   	out    %al,(%dx)
801059f2:	b2 fd                	mov    $0xfd,%dl
801059f4:	ec                   	in     (%dx),%al
801059f5:	3c ff                	cmp    $0xff,%al
801059f7:	74 4e                	je     80105a47 <uartinit+0x87>
801059f9:	55                   	push   %ebp
801059fa:	b2 fa                	mov    $0xfa,%dl
801059fc:	89 e5                	mov    %esp,%ebp
801059fe:	53                   	push   %ebx
801059ff:	83 ec 14             	sub    $0x14,%esp
80105a02:	c7 05 bc a5 10 80 01 	movl   $0x1,0x8010a5bc
80105a09:	00 00 00 
80105a0c:	ec                   	in     (%dx),%al
80105a0d:	b2 f8                	mov    $0xf8,%dl
80105a0f:	ec                   	in     (%dx),%al
80105a10:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105a17:	00 
80105a18:	bb 20 77 10 80       	mov    $0x80107720,%ebx
80105a1d:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80105a24:	e8 47 c8 ff ff       	call   80102270 <ioapicenable>
80105a29:	b8 78 00 00 00       	mov    $0x78,%eax
80105a2e:	66 90                	xchg   %ax,%ax
80105a30:	89 04 24             	mov    %eax,(%esp)
80105a33:	83 c3 01             	add    $0x1,%ebx
80105a36:	e8 35 ff ff ff       	call   80105970 <uartputc>
80105a3b:	0f be 03             	movsbl (%ebx),%eax
80105a3e:	84 c0                	test   %al,%al
80105a40:	75 ee                	jne    80105a30 <uartinit+0x70>
80105a42:	83 c4 14             	add    $0x14,%esp
80105a45:	5b                   	pop    %ebx
80105a46:	5d                   	pop    %ebp
80105a47:	f3 c3                	repz ret 
80105a49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105a50 <uartintr>:
80105a50:	55                   	push   %ebp
80105a51:	89 e5                	mov    %esp,%ebp
80105a53:	83 ec 18             	sub    $0x18,%esp
80105a56:	c7 04 24 40 59 10 80 	movl   $0x80105940,(%esp)
80105a5d:	e8 4e ad ff ff       	call   801007b0 <consoleintr>
80105a62:	c9                   	leave  
80105a63:	c3                   	ret    

80105a64 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105a64:	6a 00                	push   $0x0
  pushl $0
80105a66:	6a 00                	push   $0x0
  jmp alltraps
80105a68:	e9 4b fa ff ff       	jmp    801054b8 <alltraps>

80105a6d <vector1>:
.globl vector1
vector1:
  pushl $0
80105a6d:	6a 00                	push   $0x0
  pushl $1
80105a6f:	6a 01                	push   $0x1
  jmp alltraps
80105a71:	e9 42 fa ff ff       	jmp    801054b8 <alltraps>

80105a76 <vector2>:
.globl vector2
vector2:
  pushl $0
80105a76:	6a 00                	push   $0x0
  pushl $2
80105a78:	6a 02                	push   $0x2
  jmp alltraps
80105a7a:	e9 39 fa ff ff       	jmp    801054b8 <alltraps>

80105a7f <vector3>:
.globl vector3
vector3:
  pushl $0
80105a7f:	6a 00                	push   $0x0
  pushl $3
80105a81:	6a 03                	push   $0x3
  jmp alltraps
80105a83:	e9 30 fa ff ff       	jmp    801054b8 <alltraps>

80105a88 <vector4>:
.globl vector4
vector4:
  pushl $0
80105a88:	6a 00                	push   $0x0
  pushl $4
80105a8a:	6a 04                	push   $0x4
  jmp alltraps
80105a8c:	e9 27 fa ff ff       	jmp    801054b8 <alltraps>

80105a91 <vector5>:
.globl vector5
vector5:
  pushl $0
80105a91:	6a 00                	push   $0x0
  pushl $5
80105a93:	6a 05                	push   $0x5
  jmp alltraps
80105a95:	e9 1e fa ff ff       	jmp    801054b8 <alltraps>

80105a9a <vector6>:
.globl vector6
vector6:
  pushl $0
80105a9a:	6a 00                	push   $0x0
  pushl $6
80105a9c:	6a 06                	push   $0x6
  jmp alltraps
80105a9e:	e9 15 fa ff ff       	jmp    801054b8 <alltraps>

80105aa3 <vector7>:
.globl vector7
vector7:
  pushl $0
80105aa3:	6a 00                	push   $0x0
  pushl $7
80105aa5:	6a 07                	push   $0x7
  jmp alltraps
80105aa7:	e9 0c fa ff ff       	jmp    801054b8 <alltraps>

80105aac <vector8>:
.globl vector8
vector8:
  pushl $8
80105aac:	6a 08                	push   $0x8
  jmp alltraps
80105aae:	e9 05 fa ff ff       	jmp    801054b8 <alltraps>

80105ab3 <vector9>:
.globl vector9
vector9:
  pushl $0
80105ab3:	6a 00                	push   $0x0
  pushl $9
80105ab5:	6a 09                	push   $0x9
  jmp alltraps
80105ab7:	e9 fc f9 ff ff       	jmp    801054b8 <alltraps>

80105abc <vector10>:
.globl vector10
vector10:
  pushl $10
80105abc:	6a 0a                	push   $0xa
  jmp alltraps
80105abe:	e9 f5 f9 ff ff       	jmp    801054b8 <alltraps>

80105ac3 <vector11>:
.globl vector11
vector11:
  pushl $11
80105ac3:	6a 0b                	push   $0xb
  jmp alltraps
80105ac5:	e9 ee f9 ff ff       	jmp    801054b8 <alltraps>

80105aca <vector12>:
.globl vector12
vector12:
  pushl $12
80105aca:	6a 0c                	push   $0xc
  jmp alltraps
80105acc:	e9 e7 f9 ff ff       	jmp    801054b8 <alltraps>

80105ad1 <vector13>:
.globl vector13
vector13:
  pushl $13
80105ad1:	6a 0d                	push   $0xd
  jmp alltraps
80105ad3:	e9 e0 f9 ff ff       	jmp    801054b8 <alltraps>

80105ad8 <vector14>:
.globl vector14
vector14:
  pushl $14
80105ad8:	6a 0e                	push   $0xe
  jmp alltraps
80105ada:	e9 d9 f9 ff ff       	jmp    801054b8 <alltraps>

80105adf <vector15>:
.globl vector15
vector15:
  pushl $0
80105adf:	6a 00                	push   $0x0
  pushl $15
80105ae1:	6a 0f                	push   $0xf
  jmp alltraps
80105ae3:	e9 d0 f9 ff ff       	jmp    801054b8 <alltraps>

80105ae8 <vector16>:
.globl vector16
vector16:
  pushl $0
80105ae8:	6a 00                	push   $0x0
  pushl $16
80105aea:	6a 10                	push   $0x10
  jmp alltraps
80105aec:	e9 c7 f9 ff ff       	jmp    801054b8 <alltraps>

80105af1 <vector17>:
.globl vector17
vector17:
  pushl $17
80105af1:	6a 11                	push   $0x11
  jmp alltraps
80105af3:	e9 c0 f9 ff ff       	jmp    801054b8 <alltraps>

80105af8 <vector18>:
.globl vector18
vector18:
  pushl $0
80105af8:	6a 00                	push   $0x0
  pushl $18
80105afa:	6a 12                	push   $0x12
  jmp alltraps
80105afc:	e9 b7 f9 ff ff       	jmp    801054b8 <alltraps>

80105b01 <vector19>:
.globl vector19
vector19:
  pushl $0
80105b01:	6a 00                	push   $0x0
  pushl $19
80105b03:	6a 13                	push   $0x13
  jmp alltraps
80105b05:	e9 ae f9 ff ff       	jmp    801054b8 <alltraps>

80105b0a <vector20>:
.globl vector20
vector20:
  pushl $0
80105b0a:	6a 00                	push   $0x0
  pushl $20
80105b0c:	6a 14                	push   $0x14
  jmp alltraps
80105b0e:	e9 a5 f9 ff ff       	jmp    801054b8 <alltraps>

80105b13 <vector21>:
.globl vector21
vector21:
  pushl $0
80105b13:	6a 00                	push   $0x0
  pushl $21
80105b15:	6a 15                	push   $0x15
  jmp alltraps
80105b17:	e9 9c f9 ff ff       	jmp    801054b8 <alltraps>

80105b1c <vector22>:
.globl vector22
vector22:
  pushl $0
80105b1c:	6a 00                	push   $0x0
  pushl $22
80105b1e:	6a 16                	push   $0x16
  jmp alltraps
80105b20:	e9 93 f9 ff ff       	jmp    801054b8 <alltraps>

80105b25 <vector23>:
.globl vector23
vector23:
  pushl $0
80105b25:	6a 00                	push   $0x0
  pushl $23
80105b27:	6a 17                	push   $0x17
  jmp alltraps
80105b29:	e9 8a f9 ff ff       	jmp    801054b8 <alltraps>

80105b2e <vector24>:
.globl vector24
vector24:
  pushl $0
80105b2e:	6a 00                	push   $0x0
  pushl $24
80105b30:	6a 18                	push   $0x18
  jmp alltraps
80105b32:	e9 81 f9 ff ff       	jmp    801054b8 <alltraps>

80105b37 <vector25>:
.globl vector25
vector25:
  pushl $0
80105b37:	6a 00                	push   $0x0
  pushl $25
80105b39:	6a 19                	push   $0x19
  jmp alltraps
80105b3b:	e9 78 f9 ff ff       	jmp    801054b8 <alltraps>

80105b40 <vector26>:
.globl vector26
vector26:
  pushl $0
80105b40:	6a 00                	push   $0x0
  pushl $26
80105b42:	6a 1a                	push   $0x1a
  jmp alltraps
80105b44:	e9 6f f9 ff ff       	jmp    801054b8 <alltraps>

80105b49 <vector27>:
.globl vector27
vector27:
  pushl $0
80105b49:	6a 00                	push   $0x0
  pushl $27
80105b4b:	6a 1b                	push   $0x1b
  jmp alltraps
80105b4d:	e9 66 f9 ff ff       	jmp    801054b8 <alltraps>

80105b52 <vector28>:
.globl vector28
vector28:
  pushl $0
80105b52:	6a 00                	push   $0x0
  pushl $28
80105b54:	6a 1c                	push   $0x1c
  jmp alltraps
80105b56:	e9 5d f9 ff ff       	jmp    801054b8 <alltraps>

80105b5b <vector29>:
.globl vector29
vector29:
  pushl $0
80105b5b:	6a 00                	push   $0x0
  pushl $29
80105b5d:	6a 1d                	push   $0x1d
  jmp alltraps
80105b5f:	e9 54 f9 ff ff       	jmp    801054b8 <alltraps>

80105b64 <vector30>:
.globl vector30
vector30:
  pushl $0
80105b64:	6a 00                	push   $0x0
  pushl $30
80105b66:	6a 1e                	push   $0x1e
  jmp alltraps
80105b68:	e9 4b f9 ff ff       	jmp    801054b8 <alltraps>

80105b6d <vector31>:
.globl vector31
vector31:
  pushl $0
80105b6d:	6a 00                	push   $0x0
  pushl $31
80105b6f:	6a 1f                	push   $0x1f
  jmp alltraps
80105b71:	e9 42 f9 ff ff       	jmp    801054b8 <alltraps>

80105b76 <vector32>:
.globl vector32
vector32:
  pushl $0
80105b76:	6a 00                	push   $0x0
  pushl $32
80105b78:	6a 20                	push   $0x20
  jmp alltraps
80105b7a:	e9 39 f9 ff ff       	jmp    801054b8 <alltraps>

80105b7f <vector33>:
.globl vector33
vector33:
  pushl $0
80105b7f:	6a 00                	push   $0x0
  pushl $33
80105b81:	6a 21                	push   $0x21
  jmp alltraps
80105b83:	e9 30 f9 ff ff       	jmp    801054b8 <alltraps>

80105b88 <vector34>:
.globl vector34
vector34:
  pushl $0
80105b88:	6a 00                	push   $0x0
  pushl $34
80105b8a:	6a 22                	push   $0x22
  jmp alltraps
80105b8c:	e9 27 f9 ff ff       	jmp    801054b8 <alltraps>

80105b91 <vector35>:
.globl vector35
vector35:
  pushl $0
80105b91:	6a 00                	push   $0x0
  pushl $35
80105b93:	6a 23                	push   $0x23
  jmp alltraps
80105b95:	e9 1e f9 ff ff       	jmp    801054b8 <alltraps>

80105b9a <vector36>:
.globl vector36
vector36:
  pushl $0
80105b9a:	6a 00                	push   $0x0
  pushl $36
80105b9c:	6a 24                	push   $0x24
  jmp alltraps
80105b9e:	e9 15 f9 ff ff       	jmp    801054b8 <alltraps>

80105ba3 <vector37>:
.globl vector37
vector37:
  pushl $0
80105ba3:	6a 00                	push   $0x0
  pushl $37
80105ba5:	6a 25                	push   $0x25
  jmp alltraps
80105ba7:	e9 0c f9 ff ff       	jmp    801054b8 <alltraps>

80105bac <vector38>:
.globl vector38
vector38:
  pushl $0
80105bac:	6a 00                	push   $0x0
  pushl $38
80105bae:	6a 26                	push   $0x26
  jmp alltraps
80105bb0:	e9 03 f9 ff ff       	jmp    801054b8 <alltraps>

80105bb5 <vector39>:
.globl vector39
vector39:
  pushl $0
80105bb5:	6a 00                	push   $0x0
  pushl $39
80105bb7:	6a 27                	push   $0x27
  jmp alltraps
80105bb9:	e9 fa f8 ff ff       	jmp    801054b8 <alltraps>

80105bbe <vector40>:
.globl vector40
vector40:
  pushl $0
80105bbe:	6a 00                	push   $0x0
  pushl $40
80105bc0:	6a 28                	push   $0x28
  jmp alltraps
80105bc2:	e9 f1 f8 ff ff       	jmp    801054b8 <alltraps>

80105bc7 <vector41>:
.globl vector41
vector41:
  pushl $0
80105bc7:	6a 00                	push   $0x0
  pushl $41
80105bc9:	6a 29                	push   $0x29
  jmp alltraps
80105bcb:	e9 e8 f8 ff ff       	jmp    801054b8 <alltraps>

80105bd0 <vector42>:
.globl vector42
vector42:
  pushl $0
80105bd0:	6a 00                	push   $0x0
  pushl $42
80105bd2:	6a 2a                	push   $0x2a
  jmp alltraps
80105bd4:	e9 df f8 ff ff       	jmp    801054b8 <alltraps>

80105bd9 <vector43>:
.globl vector43
vector43:
  pushl $0
80105bd9:	6a 00                	push   $0x0
  pushl $43
80105bdb:	6a 2b                	push   $0x2b
  jmp alltraps
80105bdd:	e9 d6 f8 ff ff       	jmp    801054b8 <alltraps>

80105be2 <vector44>:
.globl vector44
vector44:
  pushl $0
80105be2:	6a 00                	push   $0x0
  pushl $44
80105be4:	6a 2c                	push   $0x2c
  jmp alltraps
80105be6:	e9 cd f8 ff ff       	jmp    801054b8 <alltraps>

80105beb <vector45>:
.globl vector45
vector45:
  pushl $0
80105beb:	6a 00                	push   $0x0
  pushl $45
80105bed:	6a 2d                	push   $0x2d
  jmp alltraps
80105bef:	e9 c4 f8 ff ff       	jmp    801054b8 <alltraps>

80105bf4 <vector46>:
.globl vector46
vector46:
  pushl $0
80105bf4:	6a 00                	push   $0x0
  pushl $46
80105bf6:	6a 2e                	push   $0x2e
  jmp alltraps
80105bf8:	e9 bb f8 ff ff       	jmp    801054b8 <alltraps>

80105bfd <vector47>:
.globl vector47
vector47:
  pushl $0
80105bfd:	6a 00                	push   $0x0
  pushl $47
80105bff:	6a 2f                	push   $0x2f
  jmp alltraps
80105c01:	e9 b2 f8 ff ff       	jmp    801054b8 <alltraps>

80105c06 <vector48>:
.globl vector48
vector48:
  pushl $0
80105c06:	6a 00                	push   $0x0
  pushl $48
80105c08:	6a 30                	push   $0x30
  jmp alltraps
80105c0a:	e9 a9 f8 ff ff       	jmp    801054b8 <alltraps>

80105c0f <vector49>:
.globl vector49
vector49:
  pushl $0
80105c0f:	6a 00                	push   $0x0
  pushl $49
80105c11:	6a 31                	push   $0x31
  jmp alltraps
80105c13:	e9 a0 f8 ff ff       	jmp    801054b8 <alltraps>

80105c18 <vector50>:
.globl vector50
vector50:
  pushl $0
80105c18:	6a 00                	push   $0x0
  pushl $50
80105c1a:	6a 32                	push   $0x32
  jmp alltraps
80105c1c:	e9 97 f8 ff ff       	jmp    801054b8 <alltraps>

80105c21 <vector51>:
.globl vector51
vector51:
  pushl $0
80105c21:	6a 00                	push   $0x0
  pushl $51
80105c23:	6a 33                	push   $0x33
  jmp alltraps
80105c25:	e9 8e f8 ff ff       	jmp    801054b8 <alltraps>

80105c2a <vector52>:
.globl vector52
vector52:
  pushl $0
80105c2a:	6a 00                	push   $0x0
  pushl $52
80105c2c:	6a 34                	push   $0x34
  jmp alltraps
80105c2e:	e9 85 f8 ff ff       	jmp    801054b8 <alltraps>

80105c33 <vector53>:
.globl vector53
vector53:
  pushl $0
80105c33:	6a 00                	push   $0x0
  pushl $53
80105c35:	6a 35                	push   $0x35
  jmp alltraps
80105c37:	e9 7c f8 ff ff       	jmp    801054b8 <alltraps>

80105c3c <vector54>:
.globl vector54
vector54:
  pushl $0
80105c3c:	6a 00                	push   $0x0
  pushl $54
80105c3e:	6a 36                	push   $0x36
  jmp alltraps
80105c40:	e9 73 f8 ff ff       	jmp    801054b8 <alltraps>

80105c45 <vector55>:
.globl vector55
vector55:
  pushl $0
80105c45:	6a 00                	push   $0x0
  pushl $55
80105c47:	6a 37                	push   $0x37
  jmp alltraps
80105c49:	e9 6a f8 ff ff       	jmp    801054b8 <alltraps>

80105c4e <vector56>:
.globl vector56
vector56:
  pushl $0
80105c4e:	6a 00                	push   $0x0
  pushl $56
80105c50:	6a 38                	push   $0x38
  jmp alltraps
80105c52:	e9 61 f8 ff ff       	jmp    801054b8 <alltraps>

80105c57 <vector57>:
.globl vector57
vector57:
  pushl $0
80105c57:	6a 00                	push   $0x0
  pushl $57
80105c59:	6a 39                	push   $0x39
  jmp alltraps
80105c5b:	e9 58 f8 ff ff       	jmp    801054b8 <alltraps>

80105c60 <vector58>:
.globl vector58
vector58:
  pushl $0
80105c60:	6a 00                	push   $0x0
  pushl $58
80105c62:	6a 3a                	push   $0x3a
  jmp alltraps
80105c64:	e9 4f f8 ff ff       	jmp    801054b8 <alltraps>

80105c69 <vector59>:
.globl vector59
vector59:
  pushl $0
80105c69:	6a 00                	push   $0x0
  pushl $59
80105c6b:	6a 3b                	push   $0x3b
  jmp alltraps
80105c6d:	e9 46 f8 ff ff       	jmp    801054b8 <alltraps>

80105c72 <vector60>:
.globl vector60
vector60:
  pushl $0
80105c72:	6a 00                	push   $0x0
  pushl $60
80105c74:	6a 3c                	push   $0x3c
  jmp alltraps
80105c76:	e9 3d f8 ff ff       	jmp    801054b8 <alltraps>

80105c7b <vector61>:
.globl vector61
vector61:
  pushl $0
80105c7b:	6a 00                	push   $0x0
  pushl $61
80105c7d:	6a 3d                	push   $0x3d
  jmp alltraps
80105c7f:	e9 34 f8 ff ff       	jmp    801054b8 <alltraps>

80105c84 <vector62>:
.globl vector62
vector62:
  pushl $0
80105c84:	6a 00                	push   $0x0
  pushl $62
80105c86:	6a 3e                	push   $0x3e
  jmp alltraps
80105c88:	e9 2b f8 ff ff       	jmp    801054b8 <alltraps>

80105c8d <vector63>:
.globl vector63
vector63:
  pushl $0
80105c8d:	6a 00                	push   $0x0
  pushl $63
80105c8f:	6a 3f                	push   $0x3f
  jmp alltraps
80105c91:	e9 22 f8 ff ff       	jmp    801054b8 <alltraps>

80105c96 <vector64>:
.globl vector64
vector64:
  pushl $0
80105c96:	6a 00                	push   $0x0
  pushl $64
80105c98:	6a 40                	push   $0x40
  jmp alltraps
80105c9a:	e9 19 f8 ff ff       	jmp    801054b8 <alltraps>

80105c9f <vector65>:
.globl vector65
vector65:
  pushl $0
80105c9f:	6a 00                	push   $0x0
  pushl $65
80105ca1:	6a 41                	push   $0x41
  jmp alltraps
80105ca3:	e9 10 f8 ff ff       	jmp    801054b8 <alltraps>

80105ca8 <vector66>:
.globl vector66
vector66:
  pushl $0
80105ca8:	6a 00                	push   $0x0
  pushl $66
80105caa:	6a 42                	push   $0x42
  jmp alltraps
80105cac:	e9 07 f8 ff ff       	jmp    801054b8 <alltraps>

80105cb1 <vector67>:
.globl vector67
vector67:
  pushl $0
80105cb1:	6a 00                	push   $0x0
  pushl $67
80105cb3:	6a 43                	push   $0x43
  jmp alltraps
80105cb5:	e9 fe f7 ff ff       	jmp    801054b8 <alltraps>

80105cba <vector68>:
.globl vector68
vector68:
  pushl $0
80105cba:	6a 00                	push   $0x0
  pushl $68
80105cbc:	6a 44                	push   $0x44
  jmp alltraps
80105cbe:	e9 f5 f7 ff ff       	jmp    801054b8 <alltraps>

80105cc3 <vector69>:
.globl vector69
vector69:
  pushl $0
80105cc3:	6a 00                	push   $0x0
  pushl $69
80105cc5:	6a 45                	push   $0x45
  jmp alltraps
80105cc7:	e9 ec f7 ff ff       	jmp    801054b8 <alltraps>

80105ccc <vector70>:
.globl vector70
vector70:
  pushl $0
80105ccc:	6a 00                	push   $0x0
  pushl $70
80105cce:	6a 46                	push   $0x46
  jmp alltraps
80105cd0:	e9 e3 f7 ff ff       	jmp    801054b8 <alltraps>

80105cd5 <vector71>:
.globl vector71
vector71:
  pushl $0
80105cd5:	6a 00                	push   $0x0
  pushl $71
80105cd7:	6a 47                	push   $0x47
  jmp alltraps
80105cd9:	e9 da f7 ff ff       	jmp    801054b8 <alltraps>

80105cde <vector72>:
.globl vector72
vector72:
  pushl $0
80105cde:	6a 00                	push   $0x0
  pushl $72
80105ce0:	6a 48                	push   $0x48
  jmp alltraps
80105ce2:	e9 d1 f7 ff ff       	jmp    801054b8 <alltraps>

80105ce7 <vector73>:
.globl vector73
vector73:
  pushl $0
80105ce7:	6a 00                	push   $0x0
  pushl $73
80105ce9:	6a 49                	push   $0x49
  jmp alltraps
80105ceb:	e9 c8 f7 ff ff       	jmp    801054b8 <alltraps>

80105cf0 <vector74>:
.globl vector74
vector74:
  pushl $0
80105cf0:	6a 00                	push   $0x0
  pushl $74
80105cf2:	6a 4a                	push   $0x4a
  jmp alltraps
80105cf4:	e9 bf f7 ff ff       	jmp    801054b8 <alltraps>

80105cf9 <vector75>:
.globl vector75
vector75:
  pushl $0
80105cf9:	6a 00                	push   $0x0
  pushl $75
80105cfb:	6a 4b                	push   $0x4b
  jmp alltraps
80105cfd:	e9 b6 f7 ff ff       	jmp    801054b8 <alltraps>

80105d02 <vector76>:
.globl vector76
vector76:
  pushl $0
80105d02:	6a 00                	push   $0x0
  pushl $76
80105d04:	6a 4c                	push   $0x4c
  jmp alltraps
80105d06:	e9 ad f7 ff ff       	jmp    801054b8 <alltraps>

80105d0b <vector77>:
.globl vector77
vector77:
  pushl $0
80105d0b:	6a 00                	push   $0x0
  pushl $77
80105d0d:	6a 4d                	push   $0x4d
  jmp alltraps
80105d0f:	e9 a4 f7 ff ff       	jmp    801054b8 <alltraps>

80105d14 <vector78>:
.globl vector78
vector78:
  pushl $0
80105d14:	6a 00                	push   $0x0
  pushl $78
80105d16:	6a 4e                	push   $0x4e
  jmp alltraps
80105d18:	e9 9b f7 ff ff       	jmp    801054b8 <alltraps>

80105d1d <vector79>:
.globl vector79
vector79:
  pushl $0
80105d1d:	6a 00                	push   $0x0
  pushl $79
80105d1f:	6a 4f                	push   $0x4f
  jmp alltraps
80105d21:	e9 92 f7 ff ff       	jmp    801054b8 <alltraps>

80105d26 <vector80>:
.globl vector80
vector80:
  pushl $0
80105d26:	6a 00                	push   $0x0
  pushl $80
80105d28:	6a 50                	push   $0x50
  jmp alltraps
80105d2a:	e9 89 f7 ff ff       	jmp    801054b8 <alltraps>

80105d2f <vector81>:
.globl vector81
vector81:
  pushl $0
80105d2f:	6a 00                	push   $0x0
  pushl $81
80105d31:	6a 51                	push   $0x51
  jmp alltraps
80105d33:	e9 80 f7 ff ff       	jmp    801054b8 <alltraps>

80105d38 <vector82>:
.globl vector82
vector82:
  pushl $0
80105d38:	6a 00                	push   $0x0
  pushl $82
80105d3a:	6a 52                	push   $0x52
  jmp alltraps
80105d3c:	e9 77 f7 ff ff       	jmp    801054b8 <alltraps>

80105d41 <vector83>:
.globl vector83
vector83:
  pushl $0
80105d41:	6a 00                	push   $0x0
  pushl $83
80105d43:	6a 53                	push   $0x53
  jmp alltraps
80105d45:	e9 6e f7 ff ff       	jmp    801054b8 <alltraps>

80105d4a <vector84>:
.globl vector84
vector84:
  pushl $0
80105d4a:	6a 00                	push   $0x0
  pushl $84
80105d4c:	6a 54                	push   $0x54
  jmp alltraps
80105d4e:	e9 65 f7 ff ff       	jmp    801054b8 <alltraps>

80105d53 <vector85>:
.globl vector85
vector85:
  pushl $0
80105d53:	6a 00                	push   $0x0
  pushl $85
80105d55:	6a 55                	push   $0x55
  jmp alltraps
80105d57:	e9 5c f7 ff ff       	jmp    801054b8 <alltraps>

80105d5c <vector86>:
.globl vector86
vector86:
  pushl $0
80105d5c:	6a 00                	push   $0x0
  pushl $86
80105d5e:	6a 56                	push   $0x56
  jmp alltraps
80105d60:	e9 53 f7 ff ff       	jmp    801054b8 <alltraps>

80105d65 <vector87>:
.globl vector87
vector87:
  pushl $0
80105d65:	6a 00                	push   $0x0
  pushl $87
80105d67:	6a 57                	push   $0x57
  jmp alltraps
80105d69:	e9 4a f7 ff ff       	jmp    801054b8 <alltraps>

80105d6e <vector88>:
.globl vector88
vector88:
  pushl $0
80105d6e:	6a 00                	push   $0x0
  pushl $88
80105d70:	6a 58                	push   $0x58
  jmp alltraps
80105d72:	e9 41 f7 ff ff       	jmp    801054b8 <alltraps>

80105d77 <vector89>:
.globl vector89
vector89:
  pushl $0
80105d77:	6a 00                	push   $0x0
  pushl $89
80105d79:	6a 59                	push   $0x59
  jmp alltraps
80105d7b:	e9 38 f7 ff ff       	jmp    801054b8 <alltraps>

80105d80 <vector90>:
.globl vector90
vector90:
  pushl $0
80105d80:	6a 00                	push   $0x0
  pushl $90
80105d82:	6a 5a                	push   $0x5a
  jmp alltraps
80105d84:	e9 2f f7 ff ff       	jmp    801054b8 <alltraps>

80105d89 <vector91>:
.globl vector91
vector91:
  pushl $0
80105d89:	6a 00                	push   $0x0
  pushl $91
80105d8b:	6a 5b                	push   $0x5b
  jmp alltraps
80105d8d:	e9 26 f7 ff ff       	jmp    801054b8 <alltraps>

80105d92 <vector92>:
.globl vector92
vector92:
  pushl $0
80105d92:	6a 00                	push   $0x0
  pushl $92
80105d94:	6a 5c                	push   $0x5c
  jmp alltraps
80105d96:	e9 1d f7 ff ff       	jmp    801054b8 <alltraps>

80105d9b <vector93>:
.globl vector93
vector93:
  pushl $0
80105d9b:	6a 00                	push   $0x0
  pushl $93
80105d9d:	6a 5d                	push   $0x5d
  jmp alltraps
80105d9f:	e9 14 f7 ff ff       	jmp    801054b8 <alltraps>

80105da4 <vector94>:
.globl vector94
vector94:
  pushl $0
80105da4:	6a 00                	push   $0x0
  pushl $94
80105da6:	6a 5e                	push   $0x5e
  jmp alltraps
80105da8:	e9 0b f7 ff ff       	jmp    801054b8 <alltraps>

80105dad <vector95>:
.globl vector95
vector95:
  pushl $0
80105dad:	6a 00                	push   $0x0
  pushl $95
80105daf:	6a 5f                	push   $0x5f
  jmp alltraps
80105db1:	e9 02 f7 ff ff       	jmp    801054b8 <alltraps>

80105db6 <vector96>:
.globl vector96
vector96:
  pushl $0
80105db6:	6a 00                	push   $0x0
  pushl $96
80105db8:	6a 60                	push   $0x60
  jmp alltraps
80105dba:	e9 f9 f6 ff ff       	jmp    801054b8 <alltraps>

80105dbf <vector97>:
.globl vector97
vector97:
  pushl $0
80105dbf:	6a 00                	push   $0x0
  pushl $97
80105dc1:	6a 61                	push   $0x61
  jmp alltraps
80105dc3:	e9 f0 f6 ff ff       	jmp    801054b8 <alltraps>

80105dc8 <vector98>:
.globl vector98
vector98:
  pushl $0
80105dc8:	6a 00                	push   $0x0
  pushl $98
80105dca:	6a 62                	push   $0x62
  jmp alltraps
80105dcc:	e9 e7 f6 ff ff       	jmp    801054b8 <alltraps>

80105dd1 <vector99>:
.globl vector99
vector99:
  pushl $0
80105dd1:	6a 00                	push   $0x0
  pushl $99
80105dd3:	6a 63                	push   $0x63
  jmp alltraps
80105dd5:	e9 de f6 ff ff       	jmp    801054b8 <alltraps>

80105dda <vector100>:
.globl vector100
vector100:
  pushl $0
80105dda:	6a 00                	push   $0x0
  pushl $100
80105ddc:	6a 64                	push   $0x64
  jmp alltraps
80105dde:	e9 d5 f6 ff ff       	jmp    801054b8 <alltraps>

80105de3 <vector101>:
.globl vector101
vector101:
  pushl $0
80105de3:	6a 00                	push   $0x0
  pushl $101
80105de5:	6a 65                	push   $0x65
  jmp alltraps
80105de7:	e9 cc f6 ff ff       	jmp    801054b8 <alltraps>

80105dec <vector102>:
.globl vector102
vector102:
  pushl $0
80105dec:	6a 00                	push   $0x0
  pushl $102
80105dee:	6a 66                	push   $0x66
  jmp alltraps
80105df0:	e9 c3 f6 ff ff       	jmp    801054b8 <alltraps>

80105df5 <vector103>:
.globl vector103
vector103:
  pushl $0
80105df5:	6a 00                	push   $0x0
  pushl $103
80105df7:	6a 67                	push   $0x67
  jmp alltraps
80105df9:	e9 ba f6 ff ff       	jmp    801054b8 <alltraps>

80105dfe <vector104>:
.globl vector104
vector104:
  pushl $0
80105dfe:	6a 00                	push   $0x0
  pushl $104
80105e00:	6a 68                	push   $0x68
  jmp alltraps
80105e02:	e9 b1 f6 ff ff       	jmp    801054b8 <alltraps>

80105e07 <vector105>:
.globl vector105
vector105:
  pushl $0
80105e07:	6a 00                	push   $0x0
  pushl $105
80105e09:	6a 69                	push   $0x69
  jmp alltraps
80105e0b:	e9 a8 f6 ff ff       	jmp    801054b8 <alltraps>

80105e10 <vector106>:
.globl vector106
vector106:
  pushl $0
80105e10:	6a 00                	push   $0x0
  pushl $106
80105e12:	6a 6a                	push   $0x6a
  jmp alltraps
80105e14:	e9 9f f6 ff ff       	jmp    801054b8 <alltraps>

80105e19 <vector107>:
.globl vector107
vector107:
  pushl $0
80105e19:	6a 00                	push   $0x0
  pushl $107
80105e1b:	6a 6b                	push   $0x6b
  jmp alltraps
80105e1d:	e9 96 f6 ff ff       	jmp    801054b8 <alltraps>

80105e22 <vector108>:
.globl vector108
vector108:
  pushl $0
80105e22:	6a 00                	push   $0x0
  pushl $108
80105e24:	6a 6c                	push   $0x6c
  jmp alltraps
80105e26:	e9 8d f6 ff ff       	jmp    801054b8 <alltraps>

80105e2b <vector109>:
.globl vector109
vector109:
  pushl $0
80105e2b:	6a 00                	push   $0x0
  pushl $109
80105e2d:	6a 6d                	push   $0x6d
  jmp alltraps
80105e2f:	e9 84 f6 ff ff       	jmp    801054b8 <alltraps>

80105e34 <vector110>:
.globl vector110
vector110:
  pushl $0
80105e34:	6a 00                	push   $0x0
  pushl $110
80105e36:	6a 6e                	push   $0x6e
  jmp alltraps
80105e38:	e9 7b f6 ff ff       	jmp    801054b8 <alltraps>

80105e3d <vector111>:
.globl vector111
vector111:
  pushl $0
80105e3d:	6a 00                	push   $0x0
  pushl $111
80105e3f:	6a 6f                	push   $0x6f
  jmp alltraps
80105e41:	e9 72 f6 ff ff       	jmp    801054b8 <alltraps>

80105e46 <vector112>:
.globl vector112
vector112:
  pushl $0
80105e46:	6a 00                	push   $0x0
  pushl $112
80105e48:	6a 70                	push   $0x70
  jmp alltraps
80105e4a:	e9 69 f6 ff ff       	jmp    801054b8 <alltraps>

80105e4f <vector113>:
.globl vector113
vector113:
  pushl $0
80105e4f:	6a 00                	push   $0x0
  pushl $113
80105e51:	6a 71                	push   $0x71
  jmp alltraps
80105e53:	e9 60 f6 ff ff       	jmp    801054b8 <alltraps>

80105e58 <vector114>:
.globl vector114
vector114:
  pushl $0
80105e58:	6a 00                	push   $0x0
  pushl $114
80105e5a:	6a 72                	push   $0x72
  jmp alltraps
80105e5c:	e9 57 f6 ff ff       	jmp    801054b8 <alltraps>

80105e61 <vector115>:
.globl vector115
vector115:
  pushl $0
80105e61:	6a 00                	push   $0x0
  pushl $115
80105e63:	6a 73                	push   $0x73
  jmp alltraps
80105e65:	e9 4e f6 ff ff       	jmp    801054b8 <alltraps>

80105e6a <vector116>:
.globl vector116
vector116:
  pushl $0
80105e6a:	6a 00                	push   $0x0
  pushl $116
80105e6c:	6a 74                	push   $0x74
  jmp alltraps
80105e6e:	e9 45 f6 ff ff       	jmp    801054b8 <alltraps>

80105e73 <vector117>:
.globl vector117
vector117:
  pushl $0
80105e73:	6a 00                	push   $0x0
  pushl $117
80105e75:	6a 75                	push   $0x75
  jmp alltraps
80105e77:	e9 3c f6 ff ff       	jmp    801054b8 <alltraps>

80105e7c <vector118>:
.globl vector118
vector118:
  pushl $0
80105e7c:	6a 00                	push   $0x0
  pushl $118
80105e7e:	6a 76                	push   $0x76
  jmp alltraps
80105e80:	e9 33 f6 ff ff       	jmp    801054b8 <alltraps>

80105e85 <vector119>:
.globl vector119
vector119:
  pushl $0
80105e85:	6a 00                	push   $0x0
  pushl $119
80105e87:	6a 77                	push   $0x77
  jmp alltraps
80105e89:	e9 2a f6 ff ff       	jmp    801054b8 <alltraps>

80105e8e <vector120>:
.globl vector120
vector120:
  pushl $0
80105e8e:	6a 00                	push   $0x0
  pushl $120
80105e90:	6a 78                	push   $0x78
  jmp alltraps
80105e92:	e9 21 f6 ff ff       	jmp    801054b8 <alltraps>

80105e97 <vector121>:
.globl vector121
vector121:
  pushl $0
80105e97:	6a 00                	push   $0x0
  pushl $121
80105e99:	6a 79                	push   $0x79
  jmp alltraps
80105e9b:	e9 18 f6 ff ff       	jmp    801054b8 <alltraps>

80105ea0 <vector122>:
.globl vector122
vector122:
  pushl $0
80105ea0:	6a 00                	push   $0x0
  pushl $122
80105ea2:	6a 7a                	push   $0x7a
  jmp alltraps
80105ea4:	e9 0f f6 ff ff       	jmp    801054b8 <alltraps>

80105ea9 <vector123>:
.globl vector123
vector123:
  pushl $0
80105ea9:	6a 00                	push   $0x0
  pushl $123
80105eab:	6a 7b                	push   $0x7b
  jmp alltraps
80105ead:	e9 06 f6 ff ff       	jmp    801054b8 <alltraps>

80105eb2 <vector124>:
.globl vector124
vector124:
  pushl $0
80105eb2:	6a 00                	push   $0x0
  pushl $124
80105eb4:	6a 7c                	push   $0x7c
  jmp alltraps
80105eb6:	e9 fd f5 ff ff       	jmp    801054b8 <alltraps>

80105ebb <vector125>:
.globl vector125
vector125:
  pushl $0
80105ebb:	6a 00                	push   $0x0
  pushl $125
80105ebd:	6a 7d                	push   $0x7d
  jmp alltraps
80105ebf:	e9 f4 f5 ff ff       	jmp    801054b8 <alltraps>

80105ec4 <vector126>:
.globl vector126
vector126:
  pushl $0
80105ec4:	6a 00                	push   $0x0
  pushl $126
80105ec6:	6a 7e                	push   $0x7e
  jmp alltraps
80105ec8:	e9 eb f5 ff ff       	jmp    801054b8 <alltraps>

80105ecd <vector127>:
.globl vector127
vector127:
  pushl $0
80105ecd:	6a 00                	push   $0x0
  pushl $127
80105ecf:	6a 7f                	push   $0x7f
  jmp alltraps
80105ed1:	e9 e2 f5 ff ff       	jmp    801054b8 <alltraps>

80105ed6 <vector128>:
.globl vector128
vector128:
  pushl $0
80105ed6:	6a 00                	push   $0x0
  pushl $128
80105ed8:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80105edd:	e9 d6 f5 ff ff       	jmp    801054b8 <alltraps>

80105ee2 <vector129>:
.globl vector129
vector129:
  pushl $0
80105ee2:	6a 00                	push   $0x0
  pushl $129
80105ee4:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80105ee9:	e9 ca f5 ff ff       	jmp    801054b8 <alltraps>

80105eee <vector130>:
.globl vector130
vector130:
  pushl $0
80105eee:	6a 00                	push   $0x0
  pushl $130
80105ef0:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80105ef5:	e9 be f5 ff ff       	jmp    801054b8 <alltraps>

80105efa <vector131>:
.globl vector131
vector131:
  pushl $0
80105efa:	6a 00                	push   $0x0
  pushl $131
80105efc:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80105f01:	e9 b2 f5 ff ff       	jmp    801054b8 <alltraps>

80105f06 <vector132>:
.globl vector132
vector132:
  pushl $0
80105f06:	6a 00                	push   $0x0
  pushl $132
80105f08:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80105f0d:	e9 a6 f5 ff ff       	jmp    801054b8 <alltraps>

80105f12 <vector133>:
.globl vector133
vector133:
  pushl $0
80105f12:	6a 00                	push   $0x0
  pushl $133
80105f14:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80105f19:	e9 9a f5 ff ff       	jmp    801054b8 <alltraps>

80105f1e <vector134>:
.globl vector134
vector134:
  pushl $0
80105f1e:	6a 00                	push   $0x0
  pushl $134
80105f20:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80105f25:	e9 8e f5 ff ff       	jmp    801054b8 <alltraps>

80105f2a <vector135>:
.globl vector135
vector135:
  pushl $0
80105f2a:	6a 00                	push   $0x0
  pushl $135
80105f2c:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80105f31:	e9 82 f5 ff ff       	jmp    801054b8 <alltraps>

80105f36 <vector136>:
.globl vector136
vector136:
  pushl $0
80105f36:	6a 00                	push   $0x0
  pushl $136
80105f38:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80105f3d:	e9 76 f5 ff ff       	jmp    801054b8 <alltraps>

80105f42 <vector137>:
.globl vector137
vector137:
  pushl $0
80105f42:	6a 00                	push   $0x0
  pushl $137
80105f44:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80105f49:	e9 6a f5 ff ff       	jmp    801054b8 <alltraps>

80105f4e <vector138>:
.globl vector138
vector138:
  pushl $0
80105f4e:	6a 00                	push   $0x0
  pushl $138
80105f50:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80105f55:	e9 5e f5 ff ff       	jmp    801054b8 <alltraps>

80105f5a <vector139>:
.globl vector139
vector139:
  pushl $0
80105f5a:	6a 00                	push   $0x0
  pushl $139
80105f5c:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80105f61:	e9 52 f5 ff ff       	jmp    801054b8 <alltraps>

80105f66 <vector140>:
.globl vector140
vector140:
  pushl $0
80105f66:	6a 00                	push   $0x0
  pushl $140
80105f68:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80105f6d:	e9 46 f5 ff ff       	jmp    801054b8 <alltraps>

80105f72 <vector141>:
.globl vector141
vector141:
  pushl $0
80105f72:	6a 00                	push   $0x0
  pushl $141
80105f74:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80105f79:	e9 3a f5 ff ff       	jmp    801054b8 <alltraps>

80105f7e <vector142>:
.globl vector142
vector142:
  pushl $0
80105f7e:	6a 00                	push   $0x0
  pushl $142
80105f80:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80105f85:	e9 2e f5 ff ff       	jmp    801054b8 <alltraps>

80105f8a <vector143>:
.globl vector143
vector143:
  pushl $0
80105f8a:	6a 00                	push   $0x0
  pushl $143
80105f8c:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80105f91:	e9 22 f5 ff ff       	jmp    801054b8 <alltraps>

80105f96 <vector144>:
.globl vector144
vector144:
  pushl $0
80105f96:	6a 00                	push   $0x0
  pushl $144
80105f98:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80105f9d:	e9 16 f5 ff ff       	jmp    801054b8 <alltraps>

80105fa2 <vector145>:
.globl vector145
vector145:
  pushl $0
80105fa2:	6a 00                	push   $0x0
  pushl $145
80105fa4:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80105fa9:	e9 0a f5 ff ff       	jmp    801054b8 <alltraps>

80105fae <vector146>:
.globl vector146
vector146:
  pushl $0
80105fae:	6a 00                	push   $0x0
  pushl $146
80105fb0:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80105fb5:	e9 fe f4 ff ff       	jmp    801054b8 <alltraps>

80105fba <vector147>:
.globl vector147
vector147:
  pushl $0
80105fba:	6a 00                	push   $0x0
  pushl $147
80105fbc:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80105fc1:	e9 f2 f4 ff ff       	jmp    801054b8 <alltraps>

80105fc6 <vector148>:
.globl vector148
vector148:
  pushl $0
80105fc6:	6a 00                	push   $0x0
  pushl $148
80105fc8:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80105fcd:	e9 e6 f4 ff ff       	jmp    801054b8 <alltraps>

80105fd2 <vector149>:
.globl vector149
vector149:
  pushl $0
80105fd2:	6a 00                	push   $0x0
  pushl $149
80105fd4:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80105fd9:	e9 da f4 ff ff       	jmp    801054b8 <alltraps>

80105fde <vector150>:
.globl vector150
vector150:
  pushl $0
80105fde:	6a 00                	push   $0x0
  pushl $150
80105fe0:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80105fe5:	e9 ce f4 ff ff       	jmp    801054b8 <alltraps>

80105fea <vector151>:
.globl vector151
vector151:
  pushl $0
80105fea:	6a 00                	push   $0x0
  pushl $151
80105fec:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80105ff1:	e9 c2 f4 ff ff       	jmp    801054b8 <alltraps>

80105ff6 <vector152>:
.globl vector152
vector152:
  pushl $0
80105ff6:	6a 00                	push   $0x0
  pushl $152
80105ff8:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80105ffd:	e9 b6 f4 ff ff       	jmp    801054b8 <alltraps>

80106002 <vector153>:
.globl vector153
vector153:
  pushl $0
80106002:	6a 00                	push   $0x0
  pushl $153
80106004:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106009:	e9 aa f4 ff ff       	jmp    801054b8 <alltraps>

8010600e <vector154>:
.globl vector154
vector154:
  pushl $0
8010600e:	6a 00                	push   $0x0
  pushl $154
80106010:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106015:	e9 9e f4 ff ff       	jmp    801054b8 <alltraps>

8010601a <vector155>:
.globl vector155
vector155:
  pushl $0
8010601a:	6a 00                	push   $0x0
  pushl $155
8010601c:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106021:	e9 92 f4 ff ff       	jmp    801054b8 <alltraps>

80106026 <vector156>:
.globl vector156
vector156:
  pushl $0
80106026:	6a 00                	push   $0x0
  pushl $156
80106028:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010602d:	e9 86 f4 ff ff       	jmp    801054b8 <alltraps>

80106032 <vector157>:
.globl vector157
vector157:
  pushl $0
80106032:	6a 00                	push   $0x0
  pushl $157
80106034:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106039:	e9 7a f4 ff ff       	jmp    801054b8 <alltraps>

8010603e <vector158>:
.globl vector158
vector158:
  pushl $0
8010603e:	6a 00                	push   $0x0
  pushl $158
80106040:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106045:	e9 6e f4 ff ff       	jmp    801054b8 <alltraps>

8010604a <vector159>:
.globl vector159
vector159:
  pushl $0
8010604a:	6a 00                	push   $0x0
  pushl $159
8010604c:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106051:	e9 62 f4 ff ff       	jmp    801054b8 <alltraps>

80106056 <vector160>:
.globl vector160
vector160:
  pushl $0
80106056:	6a 00                	push   $0x0
  pushl $160
80106058:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010605d:	e9 56 f4 ff ff       	jmp    801054b8 <alltraps>

80106062 <vector161>:
.globl vector161
vector161:
  pushl $0
80106062:	6a 00                	push   $0x0
  pushl $161
80106064:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106069:	e9 4a f4 ff ff       	jmp    801054b8 <alltraps>

8010606e <vector162>:
.globl vector162
vector162:
  pushl $0
8010606e:	6a 00                	push   $0x0
  pushl $162
80106070:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106075:	e9 3e f4 ff ff       	jmp    801054b8 <alltraps>

8010607a <vector163>:
.globl vector163
vector163:
  pushl $0
8010607a:	6a 00                	push   $0x0
  pushl $163
8010607c:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106081:	e9 32 f4 ff ff       	jmp    801054b8 <alltraps>

80106086 <vector164>:
.globl vector164
vector164:
  pushl $0
80106086:	6a 00                	push   $0x0
  pushl $164
80106088:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010608d:	e9 26 f4 ff ff       	jmp    801054b8 <alltraps>

80106092 <vector165>:
.globl vector165
vector165:
  pushl $0
80106092:	6a 00                	push   $0x0
  pushl $165
80106094:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106099:	e9 1a f4 ff ff       	jmp    801054b8 <alltraps>

8010609e <vector166>:
.globl vector166
vector166:
  pushl $0
8010609e:	6a 00                	push   $0x0
  pushl $166
801060a0:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801060a5:	e9 0e f4 ff ff       	jmp    801054b8 <alltraps>

801060aa <vector167>:
.globl vector167
vector167:
  pushl $0
801060aa:	6a 00                	push   $0x0
  pushl $167
801060ac:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801060b1:	e9 02 f4 ff ff       	jmp    801054b8 <alltraps>

801060b6 <vector168>:
.globl vector168
vector168:
  pushl $0
801060b6:	6a 00                	push   $0x0
  pushl $168
801060b8:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801060bd:	e9 f6 f3 ff ff       	jmp    801054b8 <alltraps>

801060c2 <vector169>:
.globl vector169
vector169:
  pushl $0
801060c2:	6a 00                	push   $0x0
  pushl $169
801060c4:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801060c9:	e9 ea f3 ff ff       	jmp    801054b8 <alltraps>

801060ce <vector170>:
.globl vector170
vector170:
  pushl $0
801060ce:	6a 00                	push   $0x0
  pushl $170
801060d0:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801060d5:	e9 de f3 ff ff       	jmp    801054b8 <alltraps>

801060da <vector171>:
.globl vector171
vector171:
  pushl $0
801060da:	6a 00                	push   $0x0
  pushl $171
801060dc:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801060e1:	e9 d2 f3 ff ff       	jmp    801054b8 <alltraps>

801060e6 <vector172>:
.globl vector172
vector172:
  pushl $0
801060e6:	6a 00                	push   $0x0
  pushl $172
801060e8:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801060ed:	e9 c6 f3 ff ff       	jmp    801054b8 <alltraps>

801060f2 <vector173>:
.globl vector173
vector173:
  pushl $0
801060f2:	6a 00                	push   $0x0
  pushl $173
801060f4:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801060f9:	e9 ba f3 ff ff       	jmp    801054b8 <alltraps>

801060fe <vector174>:
.globl vector174
vector174:
  pushl $0
801060fe:	6a 00                	push   $0x0
  pushl $174
80106100:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106105:	e9 ae f3 ff ff       	jmp    801054b8 <alltraps>

8010610a <vector175>:
.globl vector175
vector175:
  pushl $0
8010610a:	6a 00                	push   $0x0
  pushl $175
8010610c:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106111:	e9 a2 f3 ff ff       	jmp    801054b8 <alltraps>

80106116 <vector176>:
.globl vector176
vector176:
  pushl $0
80106116:	6a 00                	push   $0x0
  pushl $176
80106118:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010611d:	e9 96 f3 ff ff       	jmp    801054b8 <alltraps>

80106122 <vector177>:
.globl vector177
vector177:
  pushl $0
80106122:	6a 00                	push   $0x0
  pushl $177
80106124:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106129:	e9 8a f3 ff ff       	jmp    801054b8 <alltraps>

8010612e <vector178>:
.globl vector178
vector178:
  pushl $0
8010612e:	6a 00                	push   $0x0
  pushl $178
80106130:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106135:	e9 7e f3 ff ff       	jmp    801054b8 <alltraps>

8010613a <vector179>:
.globl vector179
vector179:
  pushl $0
8010613a:	6a 00                	push   $0x0
  pushl $179
8010613c:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106141:	e9 72 f3 ff ff       	jmp    801054b8 <alltraps>

80106146 <vector180>:
.globl vector180
vector180:
  pushl $0
80106146:	6a 00                	push   $0x0
  pushl $180
80106148:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010614d:	e9 66 f3 ff ff       	jmp    801054b8 <alltraps>

80106152 <vector181>:
.globl vector181
vector181:
  pushl $0
80106152:	6a 00                	push   $0x0
  pushl $181
80106154:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106159:	e9 5a f3 ff ff       	jmp    801054b8 <alltraps>

8010615e <vector182>:
.globl vector182
vector182:
  pushl $0
8010615e:	6a 00                	push   $0x0
  pushl $182
80106160:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106165:	e9 4e f3 ff ff       	jmp    801054b8 <alltraps>

8010616a <vector183>:
.globl vector183
vector183:
  pushl $0
8010616a:	6a 00                	push   $0x0
  pushl $183
8010616c:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106171:	e9 42 f3 ff ff       	jmp    801054b8 <alltraps>

80106176 <vector184>:
.globl vector184
vector184:
  pushl $0
80106176:	6a 00                	push   $0x0
  pushl $184
80106178:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010617d:	e9 36 f3 ff ff       	jmp    801054b8 <alltraps>

80106182 <vector185>:
.globl vector185
vector185:
  pushl $0
80106182:	6a 00                	push   $0x0
  pushl $185
80106184:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106189:	e9 2a f3 ff ff       	jmp    801054b8 <alltraps>

8010618e <vector186>:
.globl vector186
vector186:
  pushl $0
8010618e:	6a 00                	push   $0x0
  pushl $186
80106190:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106195:	e9 1e f3 ff ff       	jmp    801054b8 <alltraps>

8010619a <vector187>:
.globl vector187
vector187:
  pushl $0
8010619a:	6a 00                	push   $0x0
  pushl $187
8010619c:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801061a1:	e9 12 f3 ff ff       	jmp    801054b8 <alltraps>

801061a6 <vector188>:
.globl vector188
vector188:
  pushl $0
801061a6:	6a 00                	push   $0x0
  pushl $188
801061a8:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801061ad:	e9 06 f3 ff ff       	jmp    801054b8 <alltraps>

801061b2 <vector189>:
.globl vector189
vector189:
  pushl $0
801061b2:	6a 00                	push   $0x0
  pushl $189
801061b4:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801061b9:	e9 fa f2 ff ff       	jmp    801054b8 <alltraps>

801061be <vector190>:
.globl vector190
vector190:
  pushl $0
801061be:	6a 00                	push   $0x0
  pushl $190
801061c0:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801061c5:	e9 ee f2 ff ff       	jmp    801054b8 <alltraps>

801061ca <vector191>:
.globl vector191
vector191:
  pushl $0
801061ca:	6a 00                	push   $0x0
  pushl $191
801061cc:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801061d1:	e9 e2 f2 ff ff       	jmp    801054b8 <alltraps>

801061d6 <vector192>:
.globl vector192
vector192:
  pushl $0
801061d6:	6a 00                	push   $0x0
  pushl $192
801061d8:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801061dd:	e9 d6 f2 ff ff       	jmp    801054b8 <alltraps>

801061e2 <vector193>:
.globl vector193
vector193:
  pushl $0
801061e2:	6a 00                	push   $0x0
  pushl $193
801061e4:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801061e9:	e9 ca f2 ff ff       	jmp    801054b8 <alltraps>

801061ee <vector194>:
.globl vector194
vector194:
  pushl $0
801061ee:	6a 00                	push   $0x0
  pushl $194
801061f0:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801061f5:	e9 be f2 ff ff       	jmp    801054b8 <alltraps>

801061fa <vector195>:
.globl vector195
vector195:
  pushl $0
801061fa:	6a 00                	push   $0x0
  pushl $195
801061fc:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106201:	e9 b2 f2 ff ff       	jmp    801054b8 <alltraps>

80106206 <vector196>:
.globl vector196
vector196:
  pushl $0
80106206:	6a 00                	push   $0x0
  pushl $196
80106208:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010620d:	e9 a6 f2 ff ff       	jmp    801054b8 <alltraps>

80106212 <vector197>:
.globl vector197
vector197:
  pushl $0
80106212:	6a 00                	push   $0x0
  pushl $197
80106214:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106219:	e9 9a f2 ff ff       	jmp    801054b8 <alltraps>

8010621e <vector198>:
.globl vector198
vector198:
  pushl $0
8010621e:	6a 00                	push   $0x0
  pushl $198
80106220:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106225:	e9 8e f2 ff ff       	jmp    801054b8 <alltraps>

8010622a <vector199>:
.globl vector199
vector199:
  pushl $0
8010622a:	6a 00                	push   $0x0
  pushl $199
8010622c:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106231:	e9 82 f2 ff ff       	jmp    801054b8 <alltraps>

80106236 <vector200>:
.globl vector200
vector200:
  pushl $0
80106236:	6a 00                	push   $0x0
  pushl $200
80106238:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010623d:	e9 76 f2 ff ff       	jmp    801054b8 <alltraps>

80106242 <vector201>:
.globl vector201
vector201:
  pushl $0
80106242:	6a 00                	push   $0x0
  pushl $201
80106244:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106249:	e9 6a f2 ff ff       	jmp    801054b8 <alltraps>

8010624e <vector202>:
.globl vector202
vector202:
  pushl $0
8010624e:	6a 00                	push   $0x0
  pushl $202
80106250:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106255:	e9 5e f2 ff ff       	jmp    801054b8 <alltraps>

8010625a <vector203>:
.globl vector203
vector203:
  pushl $0
8010625a:	6a 00                	push   $0x0
  pushl $203
8010625c:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106261:	e9 52 f2 ff ff       	jmp    801054b8 <alltraps>

80106266 <vector204>:
.globl vector204
vector204:
  pushl $0
80106266:	6a 00                	push   $0x0
  pushl $204
80106268:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010626d:	e9 46 f2 ff ff       	jmp    801054b8 <alltraps>

80106272 <vector205>:
.globl vector205
vector205:
  pushl $0
80106272:	6a 00                	push   $0x0
  pushl $205
80106274:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106279:	e9 3a f2 ff ff       	jmp    801054b8 <alltraps>

8010627e <vector206>:
.globl vector206
vector206:
  pushl $0
8010627e:	6a 00                	push   $0x0
  pushl $206
80106280:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106285:	e9 2e f2 ff ff       	jmp    801054b8 <alltraps>

8010628a <vector207>:
.globl vector207
vector207:
  pushl $0
8010628a:	6a 00                	push   $0x0
  pushl $207
8010628c:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106291:	e9 22 f2 ff ff       	jmp    801054b8 <alltraps>

80106296 <vector208>:
.globl vector208
vector208:
  pushl $0
80106296:	6a 00                	push   $0x0
  pushl $208
80106298:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010629d:	e9 16 f2 ff ff       	jmp    801054b8 <alltraps>

801062a2 <vector209>:
.globl vector209
vector209:
  pushl $0
801062a2:	6a 00                	push   $0x0
  pushl $209
801062a4:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801062a9:	e9 0a f2 ff ff       	jmp    801054b8 <alltraps>

801062ae <vector210>:
.globl vector210
vector210:
  pushl $0
801062ae:	6a 00                	push   $0x0
  pushl $210
801062b0:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801062b5:	e9 fe f1 ff ff       	jmp    801054b8 <alltraps>

801062ba <vector211>:
.globl vector211
vector211:
  pushl $0
801062ba:	6a 00                	push   $0x0
  pushl $211
801062bc:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801062c1:	e9 f2 f1 ff ff       	jmp    801054b8 <alltraps>

801062c6 <vector212>:
.globl vector212
vector212:
  pushl $0
801062c6:	6a 00                	push   $0x0
  pushl $212
801062c8:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801062cd:	e9 e6 f1 ff ff       	jmp    801054b8 <alltraps>

801062d2 <vector213>:
.globl vector213
vector213:
  pushl $0
801062d2:	6a 00                	push   $0x0
  pushl $213
801062d4:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801062d9:	e9 da f1 ff ff       	jmp    801054b8 <alltraps>

801062de <vector214>:
.globl vector214
vector214:
  pushl $0
801062de:	6a 00                	push   $0x0
  pushl $214
801062e0:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801062e5:	e9 ce f1 ff ff       	jmp    801054b8 <alltraps>

801062ea <vector215>:
.globl vector215
vector215:
  pushl $0
801062ea:	6a 00                	push   $0x0
  pushl $215
801062ec:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801062f1:	e9 c2 f1 ff ff       	jmp    801054b8 <alltraps>

801062f6 <vector216>:
.globl vector216
vector216:
  pushl $0
801062f6:	6a 00                	push   $0x0
  pushl $216
801062f8:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801062fd:	e9 b6 f1 ff ff       	jmp    801054b8 <alltraps>

80106302 <vector217>:
.globl vector217
vector217:
  pushl $0
80106302:	6a 00                	push   $0x0
  pushl $217
80106304:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106309:	e9 aa f1 ff ff       	jmp    801054b8 <alltraps>

8010630e <vector218>:
.globl vector218
vector218:
  pushl $0
8010630e:	6a 00                	push   $0x0
  pushl $218
80106310:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106315:	e9 9e f1 ff ff       	jmp    801054b8 <alltraps>

8010631a <vector219>:
.globl vector219
vector219:
  pushl $0
8010631a:	6a 00                	push   $0x0
  pushl $219
8010631c:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106321:	e9 92 f1 ff ff       	jmp    801054b8 <alltraps>

80106326 <vector220>:
.globl vector220
vector220:
  pushl $0
80106326:	6a 00                	push   $0x0
  pushl $220
80106328:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010632d:	e9 86 f1 ff ff       	jmp    801054b8 <alltraps>

80106332 <vector221>:
.globl vector221
vector221:
  pushl $0
80106332:	6a 00                	push   $0x0
  pushl $221
80106334:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106339:	e9 7a f1 ff ff       	jmp    801054b8 <alltraps>

8010633e <vector222>:
.globl vector222
vector222:
  pushl $0
8010633e:	6a 00                	push   $0x0
  pushl $222
80106340:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106345:	e9 6e f1 ff ff       	jmp    801054b8 <alltraps>

8010634a <vector223>:
.globl vector223
vector223:
  pushl $0
8010634a:	6a 00                	push   $0x0
  pushl $223
8010634c:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106351:	e9 62 f1 ff ff       	jmp    801054b8 <alltraps>

80106356 <vector224>:
.globl vector224
vector224:
  pushl $0
80106356:	6a 00                	push   $0x0
  pushl $224
80106358:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010635d:	e9 56 f1 ff ff       	jmp    801054b8 <alltraps>

80106362 <vector225>:
.globl vector225
vector225:
  pushl $0
80106362:	6a 00                	push   $0x0
  pushl $225
80106364:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106369:	e9 4a f1 ff ff       	jmp    801054b8 <alltraps>

8010636e <vector226>:
.globl vector226
vector226:
  pushl $0
8010636e:	6a 00                	push   $0x0
  pushl $226
80106370:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106375:	e9 3e f1 ff ff       	jmp    801054b8 <alltraps>

8010637a <vector227>:
.globl vector227
vector227:
  pushl $0
8010637a:	6a 00                	push   $0x0
  pushl $227
8010637c:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106381:	e9 32 f1 ff ff       	jmp    801054b8 <alltraps>

80106386 <vector228>:
.globl vector228
vector228:
  pushl $0
80106386:	6a 00                	push   $0x0
  pushl $228
80106388:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010638d:	e9 26 f1 ff ff       	jmp    801054b8 <alltraps>

80106392 <vector229>:
.globl vector229
vector229:
  pushl $0
80106392:	6a 00                	push   $0x0
  pushl $229
80106394:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106399:	e9 1a f1 ff ff       	jmp    801054b8 <alltraps>

8010639e <vector230>:
.globl vector230
vector230:
  pushl $0
8010639e:	6a 00                	push   $0x0
  pushl $230
801063a0:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801063a5:	e9 0e f1 ff ff       	jmp    801054b8 <alltraps>

801063aa <vector231>:
.globl vector231
vector231:
  pushl $0
801063aa:	6a 00                	push   $0x0
  pushl $231
801063ac:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801063b1:	e9 02 f1 ff ff       	jmp    801054b8 <alltraps>

801063b6 <vector232>:
.globl vector232
vector232:
  pushl $0
801063b6:	6a 00                	push   $0x0
  pushl $232
801063b8:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801063bd:	e9 f6 f0 ff ff       	jmp    801054b8 <alltraps>

801063c2 <vector233>:
.globl vector233
vector233:
  pushl $0
801063c2:	6a 00                	push   $0x0
  pushl $233
801063c4:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801063c9:	e9 ea f0 ff ff       	jmp    801054b8 <alltraps>

801063ce <vector234>:
.globl vector234
vector234:
  pushl $0
801063ce:	6a 00                	push   $0x0
  pushl $234
801063d0:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801063d5:	e9 de f0 ff ff       	jmp    801054b8 <alltraps>

801063da <vector235>:
.globl vector235
vector235:
  pushl $0
801063da:	6a 00                	push   $0x0
  pushl $235
801063dc:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801063e1:	e9 d2 f0 ff ff       	jmp    801054b8 <alltraps>

801063e6 <vector236>:
.globl vector236
vector236:
  pushl $0
801063e6:	6a 00                	push   $0x0
  pushl $236
801063e8:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801063ed:	e9 c6 f0 ff ff       	jmp    801054b8 <alltraps>

801063f2 <vector237>:
.globl vector237
vector237:
  pushl $0
801063f2:	6a 00                	push   $0x0
  pushl $237
801063f4:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801063f9:	e9 ba f0 ff ff       	jmp    801054b8 <alltraps>

801063fe <vector238>:
.globl vector238
vector238:
  pushl $0
801063fe:	6a 00                	push   $0x0
  pushl $238
80106400:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106405:	e9 ae f0 ff ff       	jmp    801054b8 <alltraps>

8010640a <vector239>:
.globl vector239
vector239:
  pushl $0
8010640a:	6a 00                	push   $0x0
  pushl $239
8010640c:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106411:	e9 a2 f0 ff ff       	jmp    801054b8 <alltraps>

80106416 <vector240>:
.globl vector240
vector240:
  pushl $0
80106416:	6a 00                	push   $0x0
  pushl $240
80106418:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010641d:	e9 96 f0 ff ff       	jmp    801054b8 <alltraps>

80106422 <vector241>:
.globl vector241
vector241:
  pushl $0
80106422:	6a 00                	push   $0x0
  pushl $241
80106424:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106429:	e9 8a f0 ff ff       	jmp    801054b8 <alltraps>

8010642e <vector242>:
.globl vector242
vector242:
  pushl $0
8010642e:	6a 00                	push   $0x0
  pushl $242
80106430:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106435:	e9 7e f0 ff ff       	jmp    801054b8 <alltraps>

8010643a <vector243>:
.globl vector243
vector243:
  pushl $0
8010643a:	6a 00                	push   $0x0
  pushl $243
8010643c:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106441:	e9 72 f0 ff ff       	jmp    801054b8 <alltraps>

80106446 <vector244>:
.globl vector244
vector244:
  pushl $0
80106446:	6a 00                	push   $0x0
  pushl $244
80106448:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010644d:	e9 66 f0 ff ff       	jmp    801054b8 <alltraps>

80106452 <vector245>:
.globl vector245
vector245:
  pushl $0
80106452:	6a 00                	push   $0x0
  pushl $245
80106454:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106459:	e9 5a f0 ff ff       	jmp    801054b8 <alltraps>

8010645e <vector246>:
.globl vector246
vector246:
  pushl $0
8010645e:	6a 00                	push   $0x0
  pushl $246
80106460:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106465:	e9 4e f0 ff ff       	jmp    801054b8 <alltraps>

8010646a <vector247>:
.globl vector247
vector247:
  pushl $0
8010646a:	6a 00                	push   $0x0
  pushl $247
8010646c:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106471:	e9 42 f0 ff ff       	jmp    801054b8 <alltraps>

80106476 <vector248>:
.globl vector248
vector248:
  pushl $0
80106476:	6a 00                	push   $0x0
  pushl $248
80106478:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010647d:	e9 36 f0 ff ff       	jmp    801054b8 <alltraps>

80106482 <vector249>:
.globl vector249
vector249:
  pushl $0
80106482:	6a 00                	push   $0x0
  pushl $249
80106484:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106489:	e9 2a f0 ff ff       	jmp    801054b8 <alltraps>

8010648e <vector250>:
.globl vector250
vector250:
  pushl $0
8010648e:	6a 00                	push   $0x0
  pushl $250
80106490:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106495:	e9 1e f0 ff ff       	jmp    801054b8 <alltraps>

8010649a <vector251>:
.globl vector251
vector251:
  pushl $0
8010649a:	6a 00                	push   $0x0
  pushl $251
8010649c:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801064a1:	e9 12 f0 ff ff       	jmp    801054b8 <alltraps>

801064a6 <vector252>:
.globl vector252
vector252:
  pushl $0
801064a6:	6a 00                	push   $0x0
  pushl $252
801064a8:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801064ad:	e9 06 f0 ff ff       	jmp    801054b8 <alltraps>

801064b2 <vector253>:
.globl vector253
vector253:
  pushl $0
801064b2:	6a 00                	push   $0x0
  pushl $253
801064b4:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801064b9:	e9 fa ef ff ff       	jmp    801054b8 <alltraps>

801064be <vector254>:
.globl vector254
vector254:
  pushl $0
801064be:	6a 00                	push   $0x0
  pushl $254
801064c0:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801064c5:	e9 ee ef ff ff       	jmp    801054b8 <alltraps>

801064ca <vector255>:
.globl vector255
vector255:
  pushl $0
801064ca:	6a 00                	push   $0x0
  pushl $255
801064cc:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801064d1:	e9 e2 ef ff ff       	jmp    801054b8 <alltraps>
	...

801064e0 <walkpgdir>:
801064e0:	55                   	push   %ebp
801064e1:	89 e5                	mov    %esp,%ebp
801064e3:	57                   	push   %edi
801064e4:	56                   	push   %esi
801064e5:	89 d6                	mov    %edx,%esi
801064e7:	c1 ea 16             	shr    $0x16,%edx
801064ea:	53                   	push   %ebx
801064eb:	8d 3c 90             	lea    (%eax,%edx,4),%edi
801064ee:	83 ec 1c             	sub    $0x1c,%esp
801064f1:	8b 1f                	mov    (%edi),%ebx
801064f3:	f6 c3 01             	test   $0x1,%bl
801064f6:	74 28                	je     80106520 <walkpgdir+0x40>
801064f8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
801064fe:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
80106504:	c1 ee 0a             	shr    $0xa,%esi
80106507:	83 c4 1c             	add    $0x1c,%esp
8010650a:	89 f2                	mov    %esi,%edx
8010650c:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106512:	8d 04 13             	lea    (%ebx,%edx,1),%eax
80106515:	5b                   	pop    %ebx
80106516:	5e                   	pop    %esi
80106517:	5f                   	pop    %edi
80106518:	5d                   	pop    %ebp
80106519:	c3                   	ret    
8010651a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106520:	85 c9                	test   %ecx,%ecx
80106522:	74 34                	je     80106558 <walkpgdir+0x78>
80106524:	e8 37 bf ff ff       	call   80102460 <kalloc>
80106529:	85 c0                	test   %eax,%eax
8010652b:	89 c3                	mov    %eax,%ebx
8010652d:	74 29                	je     80106558 <walkpgdir+0x78>
8010652f:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106536:	00 
80106537:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010653e:	00 
8010653f:	89 04 24             	mov    %eax,(%esp)
80106542:	e8 29 dd ff ff       	call   80104270 <memset>
80106547:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010654d:	83 c8 07             	or     $0x7,%eax
80106550:	89 07                	mov    %eax,(%edi)
80106552:	eb b0                	jmp    80106504 <walkpgdir+0x24>
80106554:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106558:	83 c4 1c             	add    $0x1c,%esp
8010655b:	31 c0                	xor    %eax,%eax
8010655d:	5b                   	pop    %ebx
8010655e:	5e                   	pop    %esi
8010655f:	5f                   	pop    %edi
80106560:	5d                   	pop    %ebp
80106561:	c3                   	ret    
80106562:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106569:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106570 <deallocuvm.part.0>:
80106570:	55                   	push   %ebp
80106571:	89 e5                	mov    %esp,%ebp
80106573:	57                   	push   %edi
80106574:	89 c7                	mov    %eax,%edi
80106576:	56                   	push   %esi
80106577:	89 d6                	mov    %edx,%esi
80106579:	53                   	push   %ebx
8010657a:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
80106580:	83 ec 1c             	sub    $0x1c,%esp
80106583:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80106589:	39 d3                	cmp    %edx,%ebx
8010658b:	89 4d e0             	mov    %ecx,-0x20(%ebp)
8010658e:	72 3b                	jb     801065cb <deallocuvm.part.0+0x5b>
80106590:	eb 5e                	jmp    801065f0 <deallocuvm.part.0+0x80>
80106592:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106598:	8b 10                	mov    (%eax),%edx
8010659a:	f6 c2 01             	test   $0x1,%dl
8010659d:	74 22                	je     801065c1 <deallocuvm.part.0+0x51>
8010659f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
801065a5:	74 54                	je     801065fb <deallocuvm.part.0+0x8b>
801065a7:	81 c2 00 00 00 80    	add    $0x80000000,%edx
801065ad:	89 14 24             	mov    %edx,(%esp)
801065b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801065b3:	e8 f8 bc ff ff       	call   801022b0 <kfree>
801065b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801065bb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801065c1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801065c7:	39 f3                	cmp    %esi,%ebx
801065c9:	73 25                	jae    801065f0 <deallocuvm.part.0+0x80>
801065cb:	31 c9                	xor    %ecx,%ecx
801065cd:	89 da                	mov    %ebx,%edx
801065cf:	89 f8                	mov    %edi,%eax
801065d1:	e8 0a ff ff ff       	call   801064e0 <walkpgdir>
801065d6:	85 c0                	test   %eax,%eax
801065d8:	75 be                	jne    80106598 <deallocuvm.part.0+0x28>
801065da:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
801065e0:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
801065e6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801065ec:	39 f3                	cmp    %esi,%ebx
801065ee:	72 db                	jb     801065cb <deallocuvm.part.0+0x5b>
801065f0:	8b 45 e0             	mov    -0x20(%ebp),%eax
801065f3:	83 c4 1c             	add    $0x1c,%esp
801065f6:	5b                   	pop    %ebx
801065f7:	5e                   	pop    %esi
801065f8:	5f                   	pop    %edi
801065f9:	5d                   	pop    %ebp
801065fa:	c3                   	ret    
801065fb:	c7 04 24 86 70 10 80 	movl   $0x80107086,(%esp)
80106602:	e8 59 9d ff ff       	call   80100360 <panic>
80106607:	89 f6                	mov    %esi,%esi
80106609:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106610 <seginit>:
80106610:	55                   	push   %ebp
80106611:	89 e5                	mov    %esp,%ebp
80106613:	83 ec 18             	sub    $0x18,%esp
80106616:	e8 25 d0 ff ff       	call   80103640 <cpuid>
8010661b:	31 c9                	xor    %ecx,%ecx
8010661d:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80106622:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106628:	05 80 27 11 80       	add    $0x80112780,%eax
8010662d:	66 89 50 78          	mov    %dx,0x78(%eax)
80106631:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80106636:	83 c0 70             	add    $0x70,%eax
80106639:	66 89 48 0a          	mov    %cx,0xa(%eax)
8010663d:	31 c9                	xor    %ecx,%ecx
8010663f:	66 89 50 10          	mov    %dx,0x10(%eax)
80106643:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80106648:	66 89 48 12          	mov    %cx,0x12(%eax)
8010664c:	31 c9                	xor    %ecx,%ecx
8010664e:	66 89 50 18          	mov    %dx,0x18(%eax)
80106652:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80106657:	66 89 48 1a          	mov    %cx,0x1a(%eax)
8010665b:	31 c9                	xor    %ecx,%ecx
8010665d:	c6 40 0d 9a          	movb   $0x9a,0xd(%eax)
80106661:	c6 40 0e cf          	movb   $0xcf,0xe(%eax)
80106665:	c6 40 15 92          	movb   $0x92,0x15(%eax)
80106669:	c6 40 16 cf          	movb   $0xcf,0x16(%eax)
8010666d:	c6 40 1d fa          	movb   $0xfa,0x1d(%eax)
80106671:	c6 40 1e cf          	movb   $0xcf,0x1e(%eax)
80106675:	c6 40 25 f2          	movb   $0xf2,0x25(%eax)
80106679:	c6 40 26 cf          	movb   $0xcf,0x26(%eax)
8010667d:	66 89 50 20          	mov    %dx,0x20(%eax)
80106681:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106686:	c6 40 0c 00          	movb   $0x0,0xc(%eax)
8010668a:	c6 40 0f 00          	movb   $0x0,0xf(%eax)
8010668e:	c6 40 14 00          	movb   $0x0,0x14(%eax)
80106692:	c6 40 17 00          	movb   $0x0,0x17(%eax)
80106696:	c6 40 1c 00          	movb   $0x0,0x1c(%eax)
8010669a:	c6 40 1f 00          	movb   $0x0,0x1f(%eax)
8010669e:	66 89 48 22          	mov    %cx,0x22(%eax)
801066a2:	c6 40 24 00          	movb   $0x0,0x24(%eax)
801066a6:	c6 40 27 00          	movb   $0x0,0x27(%eax)
801066aa:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
801066ae:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
801066b2:	c1 e8 10             	shr    $0x10,%eax
801066b5:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
801066b9:	8d 45 f2             	lea    -0xe(%ebp),%eax
801066bc:	0f 01 10             	lgdtl  (%eax)
801066bf:	c9                   	leave  
801066c0:	c3                   	ret    
801066c1:	eb 0d                	jmp    801066d0 <mappages>
801066c3:	90                   	nop
801066c4:	90                   	nop
801066c5:	90                   	nop
801066c6:	90                   	nop
801066c7:	90                   	nop
801066c8:	90                   	nop
801066c9:	90                   	nop
801066ca:	90                   	nop
801066cb:	90                   	nop
801066cc:	90                   	nop
801066cd:	90                   	nop
801066ce:	90                   	nop
801066cf:	90                   	nop

801066d0 <mappages>:
801066d0:	55                   	push   %ebp
801066d1:	89 e5                	mov    %esp,%ebp
801066d3:	57                   	push   %edi
801066d4:	56                   	push   %esi
801066d5:	53                   	push   %ebx
801066d6:	83 ec 1c             	sub    $0x1c,%esp
801066d9:	8b 45 0c             	mov    0xc(%ebp),%eax
801066dc:	8b 55 10             	mov    0x10(%ebp),%edx
801066df:	8b 7d 14             	mov    0x14(%ebp),%edi
801066e2:	83 4d 18 01          	orl    $0x1,0x18(%ebp)
801066e6:	89 c3                	mov    %eax,%ebx
801066e8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
801066ee:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
801066f2:	29 df                	sub    %ebx,%edi
801066f4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801066f7:	81 65 e4 00 f0 ff ff 	andl   $0xfffff000,-0x1c(%ebp)
801066fe:	eb 15                	jmp    80106715 <mappages+0x45>
80106700:	f6 00 01             	testb  $0x1,(%eax)
80106703:	75 3d                	jne    80106742 <mappages+0x72>
80106705:	0b 75 18             	or     0x18(%ebp),%esi
80106708:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
8010670b:	89 30                	mov    %esi,(%eax)
8010670d:	74 29                	je     80106738 <mappages+0x68>
8010670f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106715:	8b 45 08             	mov    0x8(%ebp),%eax
80106718:	b9 01 00 00 00       	mov    $0x1,%ecx
8010671d:	89 da                	mov    %ebx,%edx
8010671f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106722:	e8 b9 fd ff ff       	call   801064e0 <walkpgdir>
80106727:	85 c0                	test   %eax,%eax
80106729:	75 d5                	jne    80106700 <mappages+0x30>
8010672b:	83 c4 1c             	add    $0x1c,%esp
8010672e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106733:	5b                   	pop    %ebx
80106734:	5e                   	pop    %esi
80106735:	5f                   	pop    %edi
80106736:	5d                   	pop    %ebp
80106737:	c3                   	ret    
80106738:	83 c4 1c             	add    $0x1c,%esp
8010673b:	31 c0                	xor    %eax,%eax
8010673d:	5b                   	pop    %ebx
8010673e:	5e                   	pop    %esi
8010673f:	5f                   	pop    %edi
80106740:	5d                   	pop    %ebp
80106741:	c3                   	ret    
80106742:	c7 04 24 28 77 10 80 	movl   $0x80107728,(%esp)
80106749:	e8 12 9c ff ff       	call   80100360 <panic>
8010674e:	66 90                	xchg   %ax,%ax

80106750 <switchkvm>:
80106750:	a1 a4 57 11 80       	mov    0x801157a4,%eax
80106755:	55                   	push   %ebp
80106756:	89 e5                	mov    %esp,%ebp
80106758:	05 00 00 00 80       	add    $0x80000000,%eax
8010675d:	0f 22 d8             	mov    %eax,%cr3
80106760:	5d                   	pop    %ebp
80106761:	c3                   	ret    
80106762:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106769:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106770 <switchuvm>:
80106770:	55                   	push   %ebp
80106771:	89 e5                	mov    %esp,%ebp
80106773:	57                   	push   %edi
80106774:	56                   	push   %esi
80106775:	53                   	push   %ebx
80106776:	83 ec 1c             	sub    $0x1c,%esp
80106779:	8b 75 08             	mov    0x8(%ebp),%esi
8010677c:	85 f6                	test   %esi,%esi
8010677e:	0f 84 cd 00 00 00    	je     80106851 <switchuvm+0xe1>
80106784:	8b 46 08             	mov    0x8(%esi),%eax
80106787:	85 c0                	test   %eax,%eax
80106789:	0f 84 da 00 00 00    	je     80106869 <switchuvm+0xf9>
8010678f:	8b 46 04             	mov    0x4(%esi),%eax
80106792:	85 c0                	test   %eax,%eax
80106794:	0f 84 c3 00 00 00    	je     8010685d <switchuvm+0xed>
8010679a:	e8 51 d9 ff ff       	call   801040f0 <pushcli>
8010679f:	e8 1c ce ff ff       	call   801035c0 <mycpu>
801067a4:	89 c3                	mov    %eax,%ebx
801067a6:	e8 15 ce ff ff       	call   801035c0 <mycpu>
801067ab:	89 c7                	mov    %eax,%edi
801067ad:	e8 0e ce ff ff       	call   801035c0 <mycpu>
801067b2:	83 c7 08             	add    $0x8,%edi
801067b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801067b8:	e8 03 ce ff ff       	call   801035c0 <mycpu>
801067bd:	b9 67 00 00 00       	mov    $0x67,%ecx
801067c2:	66 89 8b 98 00 00 00 	mov    %cx,0x98(%ebx)
801067c9:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801067cc:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
801067d3:	bf ff ff ff ff       	mov    $0xffffffff,%edi
801067d8:	c6 83 9d 00 00 00 99 	movb   $0x99,0x9d(%ebx)
801067df:	c6 83 9e 00 00 00 40 	movb   $0x40,0x9e(%ebx)
801067e6:	83 c1 08             	add    $0x8,%ecx
801067e9:	83 c0 08             	add    $0x8,%eax
801067ec:	c1 e9 10             	shr    $0x10,%ecx
801067ef:	c1 e8 18             	shr    $0x18,%eax
801067f2:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
801067f8:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
801067fe:	bb 10 00 00 00       	mov    $0x10,%ebx
80106803:	e8 b8 cd ff ff       	call   801035c0 <mycpu>
80106808:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
8010680f:	e8 ac cd ff ff       	call   801035c0 <mycpu>
80106814:	66 89 58 10          	mov    %bx,0x10(%eax)
80106818:	e8 a3 cd ff ff       	call   801035c0 <mycpu>
8010681d:	8b 56 08             	mov    0x8(%esi),%edx
80106820:	8d 8a 00 10 00 00    	lea    0x1000(%edx),%ecx
80106826:	89 48 0c             	mov    %ecx,0xc(%eax)
80106829:	e8 92 cd ff ff       	call   801035c0 <mycpu>
8010682e:	66 89 78 6e          	mov    %di,0x6e(%eax)
80106832:	b8 28 00 00 00       	mov    $0x28,%eax
80106837:	0f 00 d8             	ltr    %ax
8010683a:	8b 46 04             	mov    0x4(%esi),%eax
8010683d:	05 00 00 00 80       	add    $0x80000000,%eax
80106842:	0f 22 d8             	mov    %eax,%cr3
80106845:	83 c4 1c             	add    $0x1c,%esp
80106848:	5b                   	pop    %ebx
80106849:	5e                   	pop    %esi
8010684a:	5f                   	pop    %edi
8010684b:	5d                   	pop    %ebp
8010684c:	e9 5f d9 ff ff       	jmp    801041b0 <popcli>
80106851:	c7 04 24 2e 77 10 80 	movl   $0x8010772e,(%esp)
80106858:	e8 03 9b ff ff       	call   80100360 <panic>
8010685d:	c7 04 24 59 77 10 80 	movl   $0x80107759,(%esp)
80106864:	e8 f7 9a ff ff       	call   80100360 <panic>
80106869:	c7 04 24 44 77 10 80 	movl   $0x80107744,(%esp)
80106870:	e8 eb 9a ff ff       	call   80100360 <panic>
80106875:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106879:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106880 <inituvm>:
80106880:	55                   	push   %ebp
80106881:	89 e5                	mov    %esp,%ebp
80106883:	57                   	push   %edi
80106884:	56                   	push   %esi
80106885:	53                   	push   %ebx
80106886:	83 ec 2c             	sub    $0x2c,%esp
80106889:	8b 75 10             	mov    0x10(%ebp),%esi
8010688c:	8b 55 08             	mov    0x8(%ebp),%edx
8010688f:	8b 7d 0c             	mov    0xc(%ebp),%edi
80106892:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106898:	77 64                	ja     801068fe <inituvm+0x7e>
8010689a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010689d:	e8 be bb ff ff       	call   80102460 <kalloc>
801068a2:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801068a9:	00 
801068aa:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801068b1:	00 
801068b2:	89 04 24             	mov    %eax,(%esp)
801068b5:	89 c3                	mov    %eax,%ebx
801068b7:	e8 b4 d9 ff ff       	call   80104270 <memset>
801068bc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801068bf:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801068c5:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
801068cc:	00 
801068cd:	89 44 24 0c          	mov    %eax,0xc(%esp)
801068d1:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801068d8:	00 
801068d9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801068e0:	00 
801068e1:	89 14 24             	mov    %edx,(%esp)
801068e4:	e8 e7 fd ff ff       	call   801066d0 <mappages>
801068e9:	89 75 10             	mov    %esi,0x10(%ebp)
801068ec:	89 7d 0c             	mov    %edi,0xc(%ebp)
801068ef:	89 5d 08             	mov    %ebx,0x8(%ebp)
801068f2:	83 c4 2c             	add    $0x2c,%esp
801068f5:	5b                   	pop    %ebx
801068f6:	5e                   	pop    %esi
801068f7:	5f                   	pop    %edi
801068f8:	5d                   	pop    %ebp
801068f9:	e9 12 da ff ff       	jmp    80104310 <memmove>
801068fe:	c7 04 24 6d 77 10 80 	movl   $0x8010776d,(%esp)
80106905:	e8 56 9a ff ff       	call   80100360 <panic>
8010690a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106910 <loaduvm>:
80106910:	55                   	push   %ebp
80106911:	89 e5                	mov    %esp,%ebp
80106913:	57                   	push   %edi
80106914:	56                   	push   %esi
80106915:	53                   	push   %ebx
80106916:	83 ec 1c             	sub    $0x1c,%esp
80106919:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80106920:	0f 85 98 00 00 00    	jne    801069be <loaduvm+0xae>
80106926:	8b 75 18             	mov    0x18(%ebp),%esi
80106929:	31 db                	xor    %ebx,%ebx
8010692b:	85 f6                	test   %esi,%esi
8010692d:	75 1a                	jne    80106949 <loaduvm+0x39>
8010692f:	eb 77                	jmp    801069a8 <loaduvm+0x98>
80106931:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106938:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010693e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80106944:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80106947:	76 5f                	jbe    801069a8 <loaduvm+0x98>
80106949:	8b 55 0c             	mov    0xc(%ebp),%edx
8010694c:	31 c9                	xor    %ecx,%ecx
8010694e:	8b 45 08             	mov    0x8(%ebp),%eax
80106951:	01 da                	add    %ebx,%edx
80106953:	e8 88 fb ff ff       	call   801064e0 <walkpgdir>
80106958:	85 c0                	test   %eax,%eax
8010695a:	74 56                	je     801069b2 <loaduvm+0xa2>
8010695c:	8b 00                	mov    (%eax),%eax
8010695e:	bf 00 10 00 00       	mov    $0x1000,%edi
80106963:	8b 4d 14             	mov    0x14(%ebp),%ecx
80106966:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010696b:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
80106971:	0f 42 fe             	cmovb  %esi,%edi
80106974:	05 00 00 00 80       	add    $0x80000000,%eax
80106979:	89 44 24 04          	mov    %eax,0x4(%esp)
8010697d:	8b 45 10             	mov    0x10(%ebp),%eax
80106980:	01 d9                	add    %ebx,%ecx
80106982:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80106986:	89 4c 24 08          	mov    %ecx,0x8(%esp)
8010698a:	89 04 24             	mov    %eax,(%esp)
8010698d:	e8 8e af ff ff       	call   80101920 <readi>
80106992:	39 f8                	cmp    %edi,%eax
80106994:	74 a2                	je     80106938 <loaduvm+0x28>
80106996:	83 c4 1c             	add    $0x1c,%esp
80106999:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010699e:	5b                   	pop    %ebx
8010699f:	5e                   	pop    %esi
801069a0:	5f                   	pop    %edi
801069a1:	5d                   	pop    %ebp
801069a2:	c3                   	ret    
801069a3:	90                   	nop
801069a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801069a8:	83 c4 1c             	add    $0x1c,%esp
801069ab:	31 c0                	xor    %eax,%eax
801069ad:	5b                   	pop    %ebx
801069ae:	5e                   	pop    %esi
801069af:	5f                   	pop    %edi
801069b0:	5d                   	pop    %ebp
801069b1:	c3                   	ret    
801069b2:	c7 04 24 87 77 10 80 	movl   $0x80107787,(%esp)
801069b9:	e8 a2 99 ff ff       	call   80100360 <panic>
801069be:	c7 04 24 28 78 10 80 	movl   $0x80107828,(%esp)
801069c5:	e8 96 99 ff ff       	call   80100360 <panic>
801069ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801069d0 <allocuvm>:
801069d0:	55                   	push   %ebp
801069d1:	89 e5                	mov    %esp,%ebp
801069d3:	57                   	push   %edi
801069d4:	56                   	push   %esi
801069d5:	53                   	push   %ebx
801069d6:	83 ec 2c             	sub    $0x2c,%esp
801069d9:	8b 7d 10             	mov    0x10(%ebp),%edi
801069dc:	85 ff                	test   %edi,%edi
801069de:	0f 88 8f 00 00 00    	js     80106a73 <allocuvm+0xa3>
801069e4:	3b 7d 0c             	cmp    0xc(%ebp),%edi
801069e7:	8b 45 0c             	mov    0xc(%ebp),%eax
801069ea:	0f 82 85 00 00 00    	jb     80106a75 <allocuvm+0xa5>
801069f0:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801069f6:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
801069fc:	39 df                	cmp    %ebx,%edi
801069fe:	77 57                	ja     80106a57 <allocuvm+0x87>
80106a00:	eb 7e                	jmp    80106a80 <allocuvm+0xb0>
80106a02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106a08:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106a0f:	00 
80106a10:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106a17:	00 
80106a18:	89 04 24             	mov    %eax,(%esp)
80106a1b:	e8 50 d8 ff ff       	call   80104270 <memset>
80106a20:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106a26:	89 44 24 0c          	mov    %eax,0xc(%esp)
80106a2a:	8b 45 08             	mov    0x8(%ebp),%eax
80106a2d:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
80106a34:	00 
80106a35:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106a3c:	00 
80106a3d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80106a41:	89 04 24             	mov    %eax,(%esp)
80106a44:	e8 87 fc ff ff       	call   801066d0 <mappages>
80106a49:	85 c0                	test   %eax,%eax
80106a4b:	78 43                	js     80106a90 <allocuvm+0xc0>
80106a4d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106a53:	39 df                	cmp    %ebx,%edi
80106a55:	76 29                	jbe    80106a80 <allocuvm+0xb0>
80106a57:	e8 04 ba ff ff       	call   80102460 <kalloc>
80106a5c:	85 c0                	test   %eax,%eax
80106a5e:	89 c6                	mov    %eax,%esi
80106a60:	75 a6                	jne    80106a08 <allocuvm+0x38>
80106a62:	c7 04 24 a5 77 10 80 	movl   $0x801077a5,(%esp)
80106a69:	e8 e2 9b ff ff       	call   80100650 <cprintf>
80106a6e:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106a71:	77 47                	ja     80106aba <allocuvm+0xea>
80106a73:	31 c0                	xor    %eax,%eax
80106a75:	83 c4 2c             	add    $0x2c,%esp
80106a78:	5b                   	pop    %ebx
80106a79:	5e                   	pop    %esi
80106a7a:	5f                   	pop    %edi
80106a7b:	5d                   	pop    %ebp
80106a7c:	c3                   	ret    
80106a7d:	8d 76 00             	lea    0x0(%esi),%esi
80106a80:	83 c4 2c             	add    $0x2c,%esp
80106a83:	89 f8                	mov    %edi,%eax
80106a85:	5b                   	pop    %ebx
80106a86:	5e                   	pop    %esi
80106a87:	5f                   	pop    %edi
80106a88:	5d                   	pop    %ebp
80106a89:	c3                   	ret    
80106a8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106a90:	c7 04 24 bd 77 10 80 	movl   $0x801077bd,(%esp)
80106a97:	e8 b4 9b ff ff       	call   80100650 <cprintf>
80106a9c:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106a9f:	76 0d                	jbe    80106aae <allocuvm+0xde>
80106aa1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106aa4:	89 fa                	mov    %edi,%edx
80106aa6:	8b 45 08             	mov    0x8(%ebp),%eax
80106aa9:	e8 c2 fa ff ff       	call   80106570 <deallocuvm.part.0>
80106aae:	89 34 24             	mov    %esi,(%esp)
80106ab1:	e8 fa b7 ff ff       	call   801022b0 <kfree>
80106ab6:	31 c0                	xor    %eax,%eax
80106ab8:	eb bb                	jmp    80106a75 <allocuvm+0xa5>
80106aba:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106abd:	89 fa                	mov    %edi,%edx
80106abf:	8b 45 08             	mov    0x8(%ebp),%eax
80106ac2:	e8 a9 fa ff ff       	call   80106570 <deallocuvm.part.0>
80106ac7:	31 c0                	xor    %eax,%eax
80106ac9:	eb aa                	jmp    80106a75 <allocuvm+0xa5>
80106acb:	90                   	nop
80106acc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106ad0 <deallocuvm>:
80106ad0:	55                   	push   %ebp
80106ad1:	89 e5                	mov    %esp,%ebp
80106ad3:	8b 55 0c             	mov    0xc(%ebp),%edx
80106ad6:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106ad9:	8b 45 08             	mov    0x8(%ebp),%eax
80106adc:	39 d1                	cmp    %edx,%ecx
80106ade:	73 08                	jae    80106ae8 <deallocuvm+0x18>
80106ae0:	5d                   	pop    %ebp
80106ae1:	e9 8a fa ff ff       	jmp    80106570 <deallocuvm.part.0>
80106ae6:	66 90                	xchg   %ax,%ax
80106ae8:	89 d0                	mov    %edx,%eax
80106aea:	5d                   	pop    %ebp
80106aeb:	c3                   	ret    
80106aec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106af0 <freevm>:
80106af0:	55                   	push   %ebp
80106af1:	89 e5                	mov    %esp,%ebp
80106af3:	56                   	push   %esi
80106af4:	53                   	push   %ebx
80106af5:	83 ec 10             	sub    $0x10,%esp
80106af8:	8b 75 08             	mov    0x8(%ebp),%esi
80106afb:	85 f6                	test   %esi,%esi
80106afd:	74 59                	je     80106b58 <freevm+0x68>
80106aff:	31 c9                	xor    %ecx,%ecx
80106b01:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106b06:	89 f0                	mov    %esi,%eax
80106b08:	31 db                	xor    %ebx,%ebx
80106b0a:	e8 61 fa ff ff       	call   80106570 <deallocuvm.part.0>
80106b0f:	eb 12                	jmp    80106b23 <freevm+0x33>
80106b11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106b18:	83 c3 01             	add    $0x1,%ebx
80106b1b:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
80106b21:	74 27                	je     80106b4a <freevm+0x5a>
80106b23:	8b 14 9e             	mov    (%esi,%ebx,4),%edx
80106b26:	f6 c2 01             	test   $0x1,%dl
80106b29:	74 ed                	je     80106b18 <freevm+0x28>
80106b2b:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106b31:	83 c3 01             	add    $0x1,%ebx
80106b34:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106b3a:	89 14 24             	mov    %edx,(%esp)
80106b3d:	e8 6e b7 ff ff       	call   801022b0 <kfree>
80106b42:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
80106b48:	75 d9                	jne    80106b23 <freevm+0x33>
80106b4a:	89 75 08             	mov    %esi,0x8(%ebp)
80106b4d:	83 c4 10             	add    $0x10,%esp
80106b50:	5b                   	pop    %ebx
80106b51:	5e                   	pop    %esi
80106b52:	5d                   	pop    %ebp
80106b53:	e9 58 b7 ff ff       	jmp    801022b0 <kfree>
80106b58:	c7 04 24 d9 77 10 80 	movl   $0x801077d9,(%esp)
80106b5f:	e8 fc 97 ff ff       	call   80100360 <panic>
80106b64:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106b6a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106b70 <setupkvm>:
80106b70:	55                   	push   %ebp
80106b71:	89 e5                	mov    %esp,%ebp
80106b73:	56                   	push   %esi
80106b74:	53                   	push   %ebx
80106b75:	83 ec 20             	sub    $0x20,%esp
80106b78:	e8 e3 b8 ff ff       	call   80102460 <kalloc>
80106b7d:	85 c0                	test   %eax,%eax
80106b7f:	89 c6                	mov    %eax,%esi
80106b81:	74 75                	je     80106bf8 <setupkvm+0x88>
80106b83:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106b8a:	00 
80106b8b:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
80106b90:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106b97:	00 
80106b98:	89 04 24             	mov    %eax,(%esp)
80106b9b:	e8 d0 d6 ff ff       	call   80104270 <memset>
80106ba0:	8b 53 0c             	mov    0xc(%ebx),%edx
80106ba3:	8b 43 04             	mov    0x4(%ebx),%eax
80106ba6:	89 34 24             	mov    %esi,(%esp)
80106ba9:	89 54 24 10          	mov    %edx,0x10(%esp)
80106bad:	8b 53 08             	mov    0x8(%ebx),%edx
80106bb0:	89 44 24 0c          	mov    %eax,0xc(%esp)
80106bb4:	29 c2                	sub    %eax,%edx
80106bb6:	8b 03                	mov    (%ebx),%eax
80106bb8:	89 54 24 08          	mov    %edx,0x8(%esp)
80106bbc:	89 44 24 04          	mov    %eax,0x4(%esp)
80106bc0:	e8 0b fb ff ff       	call   801066d0 <mappages>
80106bc5:	85 c0                	test   %eax,%eax
80106bc7:	78 17                	js     80106be0 <setupkvm+0x70>
80106bc9:	83 c3 10             	add    $0x10,%ebx
80106bcc:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106bd2:	72 cc                	jb     80106ba0 <setupkvm+0x30>
80106bd4:	89 f0                	mov    %esi,%eax
80106bd6:	83 c4 20             	add    $0x20,%esp
80106bd9:	5b                   	pop    %ebx
80106bda:	5e                   	pop    %esi
80106bdb:	5d                   	pop    %ebp
80106bdc:	c3                   	ret    
80106bdd:	8d 76 00             	lea    0x0(%esi),%esi
80106be0:	89 34 24             	mov    %esi,(%esp)
80106be3:	e8 08 ff ff ff       	call   80106af0 <freevm>
80106be8:	83 c4 20             	add    $0x20,%esp
80106beb:	31 c0                	xor    %eax,%eax
80106bed:	5b                   	pop    %ebx
80106bee:	5e                   	pop    %esi
80106bef:	5d                   	pop    %ebp
80106bf0:	c3                   	ret    
80106bf1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106bf8:	31 c0                	xor    %eax,%eax
80106bfa:	eb da                	jmp    80106bd6 <setupkvm+0x66>
80106bfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106c00 <kvmalloc>:
80106c00:	55                   	push   %ebp
80106c01:	89 e5                	mov    %esp,%ebp
80106c03:	83 ec 08             	sub    $0x8,%esp
80106c06:	e8 65 ff ff ff       	call   80106b70 <setupkvm>
80106c0b:	a3 a4 57 11 80       	mov    %eax,0x801157a4
80106c10:	05 00 00 00 80       	add    $0x80000000,%eax
80106c15:	0f 22 d8             	mov    %eax,%cr3
80106c18:	c9                   	leave  
80106c19:	c3                   	ret    
80106c1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106c20 <clearpteu>:
80106c20:	55                   	push   %ebp
80106c21:	31 c9                	xor    %ecx,%ecx
80106c23:	89 e5                	mov    %esp,%ebp
80106c25:	83 ec 18             	sub    $0x18,%esp
80106c28:	8b 55 0c             	mov    0xc(%ebp),%edx
80106c2b:	8b 45 08             	mov    0x8(%ebp),%eax
80106c2e:	e8 ad f8 ff ff       	call   801064e0 <walkpgdir>
80106c33:	85 c0                	test   %eax,%eax
80106c35:	74 05                	je     80106c3c <clearpteu+0x1c>
80106c37:	83 20 fb             	andl   $0xfffffffb,(%eax)
80106c3a:	c9                   	leave  
80106c3b:	c3                   	ret    
80106c3c:	c7 04 24 ea 77 10 80 	movl   $0x801077ea,(%esp)
80106c43:	e8 18 97 ff ff       	call   80100360 <panic>
80106c48:	90                   	nop
80106c49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106c50 <copyuvm>:
80106c50:	55                   	push   %ebp
80106c51:	89 e5                	mov    %esp,%ebp
80106c53:	57                   	push   %edi
80106c54:	56                   	push   %esi
80106c55:	53                   	push   %ebx
80106c56:	83 ec 2c             	sub    $0x2c,%esp
80106c59:	e8 12 ff ff ff       	call   80106b70 <setupkvm>
80106c5e:	85 c0                	test   %eax,%eax
80106c60:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106c63:	0f 84 ba 00 00 00    	je     80106d23 <copyuvm+0xd3>
80106c69:	8b 45 0c             	mov    0xc(%ebp),%eax
80106c6c:	85 c0                	test   %eax,%eax
80106c6e:	0f 84 a4 00 00 00    	je     80106d18 <copyuvm+0xc8>
80106c74:	31 db                	xor    %ebx,%ebx
80106c76:	eb 51                	jmp    80106cc9 <copyuvm+0x79>
80106c78:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80106c7e:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106c85:	00 
80106c86:	89 7c 24 04          	mov    %edi,0x4(%esp)
80106c8a:	89 04 24             	mov    %eax,(%esp)
80106c8d:	e8 7e d6 ff ff       	call   80104310 <memmove>
80106c92:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106c95:	8d 96 00 00 00 80    	lea    -0x80000000(%esi),%edx
80106c9b:	89 54 24 0c          	mov    %edx,0xc(%esp)
80106c9f:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106ca6:	00 
80106ca7:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80106cab:	89 44 24 10          	mov    %eax,0x10(%esp)
80106caf:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106cb2:	89 04 24             	mov    %eax,(%esp)
80106cb5:	e8 16 fa ff ff       	call   801066d0 <mappages>
80106cba:	85 c0                	test   %eax,%eax
80106cbc:	78 45                	js     80106d03 <copyuvm+0xb3>
80106cbe:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106cc4:	39 5d 0c             	cmp    %ebx,0xc(%ebp)
80106cc7:	76 4f                	jbe    80106d18 <copyuvm+0xc8>
80106cc9:	8b 45 08             	mov    0x8(%ebp),%eax
80106ccc:	31 c9                	xor    %ecx,%ecx
80106cce:	89 da                	mov    %ebx,%edx
80106cd0:	e8 0b f8 ff ff       	call   801064e0 <walkpgdir>
80106cd5:	85 c0                	test   %eax,%eax
80106cd7:	74 5a                	je     80106d33 <copyuvm+0xe3>
80106cd9:	8b 30                	mov    (%eax),%esi
80106cdb:	f7 c6 01 00 00 00    	test   $0x1,%esi
80106ce1:	74 44                	je     80106d27 <copyuvm+0xd7>
80106ce3:	89 f7                	mov    %esi,%edi
80106ce5:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
80106ceb:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80106cee:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80106cf4:	e8 67 b7 ff ff       	call   80102460 <kalloc>
80106cf9:	85 c0                	test   %eax,%eax
80106cfb:	89 c6                	mov    %eax,%esi
80106cfd:	0f 85 75 ff ff ff    	jne    80106c78 <copyuvm+0x28>
80106d03:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106d06:	89 04 24             	mov    %eax,(%esp)
80106d09:	e8 e2 fd ff ff       	call   80106af0 <freevm>
80106d0e:	31 c0                	xor    %eax,%eax
80106d10:	83 c4 2c             	add    $0x2c,%esp
80106d13:	5b                   	pop    %ebx
80106d14:	5e                   	pop    %esi
80106d15:	5f                   	pop    %edi
80106d16:	5d                   	pop    %ebp
80106d17:	c3                   	ret    
80106d18:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106d1b:	83 c4 2c             	add    $0x2c,%esp
80106d1e:	5b                   	pop    %ebx
80106d1f:	5e                   	pop    %esi
80106d20:	5f                   	pop    %edi
80106d21:	5d                   	pop    %ebp
80106d22:	c3                   	ret    
80106d23:	31 c0                	xor    %eax,%eax
80106d25:	eb e9                	jmp    80106d10 <copyuvm+0xc0>
80106d27:	c7 04 24 0e 78 10 80 	movl   $0x8010780e,(%esp)
80106d2e:	e8 2d 96 ff ff       	call   80100360 <panic>
80106d33:	c7 04 24 f4 77 10 80 	movl   $0x801077f4,(%esp)
80106d3a:	e8 21 96 ff ff       	call   80100360 <panic>
80106d3f:	90                   	nop

80106d40 <uva2ka>:
80106d40:	55                   	push   %ebp
80106d41:	31 c9                	xor    %ecx,%ecx
80106d43:	89 e5                	mov    %esp,%ebp
80106d45:	83 ec 08             	sub    $0x8,%esp
80106d48:	8b 55 0c             	mov    0xc(%ebp),%edx
80106d4b:	8b 45 08             	mov    0x8(%ebp),%eax
80106d4e:	e8 8d f7 ff ff       	call   801064e0 <walkpgdir>
80106d53:	8b 00                	mov    (%eax),%eax
80106d55:	89 c2                	mov    %eax,%edx
80106d57:	83 e2 05             	and    $0x5,%edx
80106d5a:	83 fa 05             	cmp    $0x5,%edx
80106d5d:	75 11                	jne    80106d70 <uva2ka+0x30>
80106d5f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106d64:	05 00 00 00 80       	add    $0x80000000,%eax
80106d69:	c9                   	leave  
80106d6a:	c3                   	ret    
80106d6b:	90                   	nop
80106d6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106d70:	31 c0                	xor    %eax,%eax
80106d72:	c9                   	leave  
80106d73:	c3                   	ret    
80106d74:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106d7a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106d80 <copyout>:
80106d80:	55                   	push   %ebp
80106d81:	89 e5                	mov    %esp,%ebp
80106d83:	57                   	push   %edi
80106d84:	56                   	push   %esi
80106d85:	53                   	push   %ebx
80106d86:	83 ec 1c             	sub    $0x1c,%esp
80106d89:	8b 5d 14             	mov    0x14(%ebp),%ebx
80106d8c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106d8f:	8b 7d 10             	mov    0x10(%ebp),%edi
80106d92:	85 db                	test   %ebx,%ebx
80106d94:	75 3a                	jne    80106dd0 <copyout+0x50>
80106d96:	eb 68                	jmp    80106e00 <copyout+0x80>
80106d98:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106d9b:	89 f2                	mov    %esi,%edx
80106d9d:	89 7c 24 04          	mov    %edi,0x4(%esp)
80106da1:	29 ca                	sub    %ecx,%edx
80106da3:	81 c2 00 10 00 00    	add    $0x1000,%edx
80106da9:	39 da                	cmp    %ebx,%edx
80106dab:	0f 47 d3             	cmova  %ebx,%edx
80106dae:	29 f1                	sub    %esi,%ecx
80106db0:	01 c8                	add    %ecx,%eax
80106db2:	89 54 24 08          	mov    %edx,0x8(%esp)
80106db6:	89 04 24             	mov    %eax,(%esp)
80106db9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80106dbc:	e8 4f d5 ff ff       	call   80104310 <memmove>
80106dc1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106dc4:	8d 8e 00 10 00 00    	lea    0x1000(%esi),%ecx
80106dca:	01 d7                	add    %edx,%edi
80106dcc:	29 d3                	sub    %edx,%ebx
80106dce:	74 30                	je     80106e00 <copyout+0x80>
80106dd0:	8b 45 08             	mov    0x8(%ebp),%eax
80106dd3:	89 ce                	mov    %ecx,%esi
80106dd5:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
80106ddb:	89 74 24 04          	mov    %esi,0x4(%esp)
80106ddf:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80106de2:	89 04 24             	mov    %eax,(%esp)
80106de5:	e8 56 ff ff ff       	call   80106d40 <uva2ka>
80106dea:	85 c0                	test   %eax,%eax
80106dec:	75 aa                	jne    80106d98 <copyout+0x18>
80106dee:	83 c4 1c             	add    $0x1c,%esp
80106df1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106df6:	5b                   	pop    %ebx
80106df7:	5e                   	pop    %esi
80106df8:	5f                   	pop    %edi
80106df9:	5d                   	pop    %ebp
80106dfa:	c3                   	ret    
80106dfb:	90                   	nop
80106dfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106e00:	83 c4 1c             	add    $0x1c,%esp
80106e03:	31 c0                	xor    %eax,%eax
80106e05:	5b                   	pop    %ebx
80106e06:	5e                   	pop    %esi
80106e07:	5f                   	pop    %edi
80106e08:	5d                   	pop    %ebp
80106e09:	c3                   	ret    
