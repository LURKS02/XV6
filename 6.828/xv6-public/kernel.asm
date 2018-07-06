
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
8010002d:	b8 f0 2d 10 80       	mov    $0x80102df0,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
	...

80100040 <binit>:
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx
80100044:	bb f4 b5 10 80       	mov    $0x8010b5f4,%ebx
80100049:	83 ec 14             	sub    $0x14,%esp
8010004c:	c7 44 24 04 40 6c 10 	movl   $0x80106c40,0x4(%esp)
80100053:	80 
80100054:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
8010005b:	e8 f0 3f 00 00       	call   80104050 <initlock>
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
80100094:	c7 44 24 04 47 6c 10 	movl   $0x80106c47,0x4(%esp)
8010009b:	80 
8010009c:	e8 9f 3e 00 00       	call   80103f40 <initsleeplock>
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
801000e6:	e8 55 40 00 00       	call   80104140 <acquire>
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
80100161:	e8 ca 40 00 00       	call   80104230 <release>
80100166:	8d 43 0c             	lea    0xc(%ebx),%eax
80100169:	89 04 24             	mov    %eax,(%esp)
8010016c:	e8 0f 3e 00 00       	call   80103f80 <acquiresleep>
80100171:	f6 03 02             	testb  $0x2,(%ebx)
80100174:	75 08                	jne    8010017e <bread+0xae>
80100176:	89 1c 24             	mov    %ebx,(%esp)
80100179:	e8 b2 1f 00 00       	call   80102130 <iderw>
8010017e:	83 c4 1c             	add    $0x1c,%esp
80100181:	89 d8                	mov    %ebx,%eax
80100183:	5b                   	pop    %ebx
80100184:	5e                   	pop    %esi
80100185:	5f                   	pop    %edi
80100186:	5d                   	pop    %ebp
80100187:	c3                   	ret    
80100188:	c7 04 24 4e 6c 10 80 	movl   $0x80106c4e,(%esp)
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
801001b0:	e8 6b 3e 00 00       	call   80104020 <holdingsleep>
801001b5:	85 c0                	test   %eax,%eax
801001b7:	74 10                	je     801001c9 <bwrite+0x29>
801001b9:	83 0b 04             	orl    $0x4,(%ebx)
801001bc:	89 5d 08             	mov    %ebx,0x8(%ebp)
801001bf:	83 c4 14             	add    $0x14,%esp
801001c2:	5b                   	pop    %ebx
801001c3:	5d                   	pop    %ebp
801001c4:	e9 67 1f 00 00       	jmp    80102130 <iderw>
801001c9:	c7 04 24 5f 6c 10 80 	movl   $0x80106c5f,(%esp)
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
801001f1:	e8 2a 3e 00 00       	call   80104020 <holdingsleep>
801001f6:	85 c0                	test   %eax,%eax
801001f8:	74 5b                	je     80100255 <brelse+0x75>
801001fa:	89 34 24             	mov    %esi,(%esp)
801001fd:	e8 de 3d 00 00       	call   80103fe0 <releasesleep>
80100202:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100209:	e8 32 3f 00 00       	call   80104140 <acquire>
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
80100250:	e9 db 3f 00 00       	jmp    80104230 <release>
80100255:	c7 04 24 66 6c 10 80 	movl   $0x80106c66,(%esp)
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
80100282:	e8 19 15 00 00       	call   801017a0 <iunlock>
80100287:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010028e:	e8 ad 3e 00 00       	call   80104140 <acquire>
80100293:	8b 55 10             	mov    0x10(%ebp),%edx
80100296:	85 d2                	test   %edx,%edx
80100298:	0f 8e bc 00 00 00    	jle    8010035a <consoleread+0xea>
8010029e:	8b 5d 10             	mov    0x10(%ebp),%ebx
801002a1:	eb 25                	jmp    801002c8 <consoleread+0x58>
801002a3:	90                   	nop
801002a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801002a8:	e8 f3 33 00 00       	call   801036a0 <myproc>
801002ad:	8b 40 24             	mov    0x24(%eax),%eax
801002b0:	85 c0                	test   %eax,%eax
801002b2:	75 74                	jne    80100328 <consoleread+0xb8>
801002b4:	c7 44 24 04 20 a5 10 	movl   $0x8010a520,0x4(%esp)
801002bb:	80 
801002bc:	c7 04 24 a0 ff 10 80 	movl   $0x8010ffa0,(%esp)
801002c3:	e8 38 39 00 00       	call   80103c00 <sleep>
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
80100311:	e8 1a 3f 00 00       	call   80104230 <release>
80100316:	89 3c 24             	mov    %edi,(%esp)
80100319:	e8 a2 13 00 00       	call   801016c0 <ilock>
8010031e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100321:	eb 1e                	jmp    80100341 <consoleread+0xd1>
80100323:	90                   	nop
80100324:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100328:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010032f:	e8 fc 3e 00 00       	call   80104230 <release>
80100334:	89 3c 24             	mov    %edi,(%esp)
80100337:	e8 84 13 00 00       	call   801016c0 <ilock>
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
80100376:	e8 e5 23 00 00       	call   80102760 <lapicid>
8010037b:	8d 75 f8             	lea    -0x8(%ebp),%esi
8010037e:	c7 04 24 6d 6c 10 80 	movl   $0x80106c6d,(%esp)
80100385:	89 44 24 04          	mov    %eax,0x4(%esp)
80100389:	e8 c2 02 00 00       	call   80100650 <cprintf>
8010038e:	8b 45 08             	mov    0x8(%ebp),%eax
80100391:	89 04 24             	mov    %eax,(%esp)
80100394:	e8 b7 02 00 00       	call   80100650 <cprintf>
80100399:	c7 04 24 77 76 10 80 	movl   $0x80107677,(%esp)
801003a0:	e8 ab 02 00 00       	call   80100650 <cprintf>
801003a5:	8d 45 08             	lea    0x8(%ebp),%eax
801003a8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801003ac:	89 04 24             	mov    %eax,(%esp)
801003af:	e8 bc 3c 00 00       	call   80104070 <getcallerpcs>
801003b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801003b8:	8b 03                	mov    (%ebx),%eax
801003ba:	83 c3 04             	add    $0x4,%ebx
801003bd:	c7 04 24 81 6c 10 80 	movl   $0x80106c81,(%esp)
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
80100409:	e8 a2 53 00 00       	call   801057b0 <uartputc>
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
801004b4:	e8 f7 52 00 00       	call   801057b0 <uartputc>
801004b9:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004c0:	e8 eb 52 00 00       	call   801057b0 <uartputc>
801004c5:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004cc:	e8 df 52 00 00       	call   801057b0 <uartputc>
801004d1:	e9 38 ff ff ff       	jmp    8010040e <consputc+0x2e>
801004d6:	c7 44 24 08 60 0e 00 	movl   $0xe60,0x8(%esp)
801004dd:	00 
801004de:	8d 73 b0             	lea    -0x50(%ebx),%esi
801004e1:	c7 44 24 04 a0 80 0b 	movl   $0x800b80a0,0x4(%esp)
801004e8:	80 
801004e9:	8d bc 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%edi
801004f0:	c7 04 24 00 80 0b 80 	movl   $0x800b8000,(%esp)
801004f7:	e8 24 3e 00 00       	call   80104320 <memmove>
801004fc:	b8 d0 07 00 00       	mov    $0x7d0,%eax
80100501:	29 d8                	sub    %ebx,%eax
80100503:	01 c0                	add    %eax,%eax
80100505:	89 3c 24             	mov    %edi,(%esp)
80100508:	89 44 24 08          	mov    %eax,0x8(%esp)
8010050c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100513:	00 
80100514:	e8 67 3d 00 00       	call   80104280 <memset>
80100519:	89 f9                	mov    %edi,%ecx
8010051b:	bf 07 00 00 00       	mov    $0x7,%edi
80100520:	e9 5b ff ff ff       	jmp    80100480 <consputc+0xa0>
80100525:	c7 04 24 85 6c 10 80 	movl   $0x80106c85,(%esp)
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
80100599:	0f b6 92 b0 6c 10 80 	movzbl -0x7fef9350(%edx),%edx
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
80100602:	e8 99 11 00 00       	call   801017a0 <iunlock>
80100607:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010060e:	e8 2d 3b 00 00       	call   80104140 <acquire>
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
80100636:	e8 f5 3b 00 00       	call   80104230 <release>
8010063b:	8b 45 08             	mov    0x8(%ebp),%eax
8010063e:	89 04 24             	mov    %eax,(%esp)
80100641:	e8 7a 10 00 00       	call   801016c0 <ilock>
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
801006f3:	e8 38 3b 00 00       	call   80104230 <release>
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
80100760:	b8 98 6c 10 80       	mov    $0x80106c98,%eax
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
80100797:	e8 a4 39 00 00       	call   80104140 <acquire>
8010079c:	e9 c8 fe ff ff       	jmp    80100669 <cprintf+0x19>
801007a1:	c7 04 24 9f 6c 10 80 	movl   $0x80106c9f,(%esp)
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
801007c5:	e8 76 39 00 00       	call   80104140 <acquire>
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
80100827:	e8 04 3a 00 00       	call   80104230 <release>
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
801008b2:	e8 d9 34 00 00       	call   80103d90 <wakeup>
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
80100927:	e9 44 35 00 00       	jmp    80103e70 <procdump>
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
80100956:	c7 44 24 04 a8 6c 10 	movl   $0x80106ca8,0x4(%esp)
8010095d:	80 
8010095e:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100965:	e8 e6 36 00 00       	call   80104050 <initlock>
8010096a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100971:	00 
80100972:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80100979:	c7 05 6c 09 11 80 f0 	movl   $0x801005f0,0x8011096c
80100980:	05 10 80 
80100983:	c7 05 68 09 11 80 70 	movl   $0x80100270,0x80110968
8010098a:	02 10 80 
8010098d:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
80100994:	00 00 00 
80100997:	e8 24 19 00 00       	call   801022c0 <ioapicenable>
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
801009ac:	e8 ef 2c 00 00       	call   801036a0 <myproc>
801009b1:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
801009b7:	e8 54 21 00 00       	call   80102b10 <begin_op>
801009bc:	8b 45 08             	mov    0x8(%ebp),%eax
801009bf:	89 04 24             	mov    %eax,(%esp)
801009c2:	e8 49 15 00 00       	call   80101f10 <namei>
801009c7:	85 c0                	test   %eax,%eax
801009c9:	89 c3                	mov    %eax,%ebx
801009cb:	0f 84 c2 01 00 00    	je     80100b93 <exec+0x1f3>
801009d1:	89 04 24             	mov    %eax,(%esp)
801009d4:	e8 e7 0c 00 00       	call   801016c0 <ilock>
801009d9:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
801009df:	c7 44 24 0c 34 00 00 	movl   $0x34,0xc(%esp)
801009e6:	00 
801009e7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801009ee:	00 
801009ef:	89 44 24 04          	mov    %eax,0x4(%esp)
801009f3:	89 1c 24             	mov    %ebx,(%esp)
801009f6:	e8 75 0f 00 00       	call   80101970 <readi>
801009fb:	83 f8 34             	cmp    $0x34,%eax
801009fe:	74 20                	je     80100a20 <exec+0x80>
80100a00:	89 1c 24             	mov    %ebx,(%esp)
80100a03:	e8 18 0f 00 00       	call   80101920 <iunlockput>
80100a08:	e8 73 21 00 00       	call   80102b80 <end_op>
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
80100a2c:	e8 5f 5f 00 00       	call   80106990 <setupkvm>
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
80100a8e:	e8 dd 0e 00 00       	call   80101970 <readi>
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
80100ad2:	e8 29 5d 00 00       	call   80106800 <allocuvm>
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
80100b13:	e8 28 5c 00 00       	call   80106740 <loaduvm>
80100b18:	85 c0                	test   %eax,%eax
80100b1a:	0f 89 40 ff ff ff    	jns    80100a60 <exec+0xc0>
80100b20:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100b26:	89 04 24             	mov    %eax,(%esp)
80100b29:	e8 e2 5d 00 00       	call   80106910 <freevm>
80100b2e:	e9 cd fe ff ff       	jmp    80100a00 <exec+0x60>
80100b33:	89 1c 24             	mov    %ebx,(%esp)
80100b36:	e8 e5 0d 00 00       	call   80101920 <iunlockput>
80100b3b:	90                   	nop
80100b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100b40:	e8 3b 20 00 00       	call   80102b80 <end_op>
80100b45:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100b4b:	05 ff 0f 00 00       	add    $0xfff,%eax
80100b50:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100b55:	8d 90 00 20 00 00    	lea    0x2000(%eax),%edx
80100b5b:	89 44 24 04          	mov    %eax,0x4(%esp)
80100b5f:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100b65:	89 54 24 08          	mov    %edx,0x8(%esp)
80100b69:	89 04 24             	mov    %eax,(%esp)
80100b6c:	e8 8f 5c 00 00       	call   80106800 <allocuvm>
80100b71:	85 c0                	test   %eax,%eax
80100b73:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
80100b79:	75 33                	jne    80100bae <exec+0x20e>
80100b7b:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100b81:	89 04 24             	mov    %eax,(%esp)
80100b84:	e8 87 5d 00 00       	call   80106910 <freevm>
80100b89:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100b8e:	e9 7f fe ff ff       	jmp    80100a12 <exec+0x72>
80100b93:	e8 e8 1f 00 00       	call   80102b80 <end_op>
80100b98:	c7 04 24 c1 6c 10 80 	movl   $0x80106cc1,(%esp)
80100b9f:	e8 ac fa ff ff       	call   80100650 <cprintf>
80100ba4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100ba9:	e9 64 fe ff ff       	jmp    80100a12 <exec+0x72>
80100bae:	8b 9d e8 fe ff ff    	mov    -0x118(%ebp),%ebx
80100bb4:	89 d8                	mov    %ebx,%eax
80100bb6:	2d 00 20 00 00       	sub    $0x2000,%eax
80100bbb:	89 44 24 04          	mov    %eax,0x4(%esp)
80100bbf:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100bc5:	89 04 24             	mov    %eax,(%esp)
80100bc8:	e8 73 5e 00 00       	call   80106a40 <clearpteu>
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
80100c01:	e8 9a 38 00 00       	call   801044a0 <strlen>
80100c06:	f7 d0                	not    %eax
80100c08:	01 c3                	add    %eax,%ebx
80100c0a:	8b 06                	mov    (%esi),%eax
80100c0c:	83 e3 fc             	and    $0xfffffffc,%ebx
80100c0f:	89 04 24             	mov    %eax,(%esp)
80100c12:	e8 89 38 00 00       	call   801044a0 <strlen>
80100c17:	83 c0 01             	add    $0x1,%eax
80100c1a:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100c1e:	8b 06                	mov    (%esi),%eax
80100c20:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80100c24:	89 44 24 08          	mov    %eax,0x8(%esp)
80100c28:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100c2e:	89 04 24             	mov    %eax,(%esp)
80100c31:	e8 6a 5f 00 00       	call   80106ba0 <copyout>
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
80100ca4:	e8 f7 5e 00 00       	call   80106ba0 <copyout>
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
80100cf1:	e8 6a 37 00 00       	call   80104460 <safestrcpy>
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
80100d1f:	e8 8c 58 00 00       	call   801065b0 <switchuvm>
80100d24:	89 34 24             	mov    %esi,(%esp)
80100d27:	e8 e4 5b 00 00       	call   80106910 <freevm>
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
80100d56:	c7 44 24 04 cd 6c 10 	movl   $0x80106ccd,0x4(%esp)
80100d5d:	80 
80100d5e:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100d65:	e8 e6 32 00 00       	call   80104050 <initlock>
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
80100d83:	e8 b8 33 00 00       	call   80104140 <acquire>
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
80100db0:	e8 7b 34 00 00       	call   80104230 <release>
80100db5:	83 c4 14             	add    $0x14,%esp
80100db8:	89 d8                	mov    %ebx,%eax
80100dba:	5b                   	pop    %ebx
80100dbb:	5d                   	pop    %ebp
80100dbc:	c3                   	ret    
80100dbd:	8d 76 00             	lea    0x0(%esi),%esi
80100dc0:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100dc7:	e8 64 34 00 00       	call   80104230 <release>
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
80100df1:	e8 4a 33 00 00       	call   80104140 <acquire>
80100df6:	8b 43 04             	mov    0x4(%ebx),%eax
80100df9:	85 c0                	test   %eax,%eax
80100dfb:	7e 1a                	jle    80100e17 <filedup+0x37>
80100dfd:	83 c0 01             	add    $0x1,%eax
80100e00:	89 43 04             	mov    %eax,0x4(%ebx)
80100e03:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100e0a:	e8 21 34 00 00       	call   80104230 <release>
80100e0f:	83 c4 14             	add    $0x14,%esp
80100e12:	89 d8                	mov    %ebx,%eax
80100e14:	5b                   	pop    %ebx
80100e15:	5d                   	pop    %ebp
80100e16:	c3                   	ret    
80100e17:	c7 04 24 d4 6c 10 80 	movl   $0x80106cd4,(%esp)
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
80100e43:	e8 f8 32 00 00       	call   80104140 <acquire>
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
80100e6b:	e9 c0 33 00 00       	jmp    80104230 <release>
80100e70:	0f b6 47 09          	movzbl 0x9(%edi),%eax
80100e74:	8b 37                	mov    (%edi),%esi
80100e76:	8b 5f 0c             	mov    0xc(%edi),%ebx
80100e79:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
80100e7f:	88 45 e7             	mov    %al,-0x19(%ebp)
80100e82:	8b 47 10             	mov    0x10(%edi),%eax
80100e85:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100e8c:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100e8f:	e8 9c 33 00 00       	call   80104230 <release>
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
80100eb3:	e8 a8 23 00 00       	call   80103260 <pipeclose>
80100eb8:	eb e4                	jmp    80100e9e <fileclose+0x6e>
80100eba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100ec0:	e8 4b 1c 00 00       	call   80102b10 <begin_op>
80100ec5:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100ec8:	89 04 24             	mov    %eax,(%esp)
80100ecb:	e8 10 09 00 00       	call   801017e0 <iput>
80100ed0:	83 c4 1c             	add    $0x1c,%esp
80100ed3:	5b                   	pop    %ebx
80100ed4:	5e                   	pop    %esi
80100ed5:	5f                   	pop    %edi
80100ed6:	5d                   	pop    %ebp
80100ed7:	e9 a4 1c 00 00       	jmp    80102b80 <end_op>
80100edc:	c7 04 24 dc 6c 10 80 	movl   $0x80106cdc,(%esp)
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
80100f05:	e8 b6 07 00 00       	call   801016c0 <ilock>
80100f0a:	8b 45 0c             	mov    0xc(%ebp),%eax
80100f0d:	89 44 24 04          	mov    %eax,0x4(%esp)
80100f11:	8b 43 10             	mov    0x10(%ebx),%eax
80100f14:	89 04 24             	mov    %eax,(%esp)
80100f17:	e8 24 0a 00 00       	call   80101940 <stati>
80100f1c:	8b 43 10             	mov    0x10(%ebx),%eax
80100f1f:	89 04 24             	mov    %eax,(%esp)
80100f22:	e8 79 08 00 00       	call   801017a0 <iunlock>
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
80100f6a:	e8 51 07 00 00       	call   801016c0 <ilock>
80100f6f:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80100f73:	8b 43 14             	mov    0x14(%ebx),%eax
80100f76:	89 74 24 04          	mov    %esi,0x4(%esp)
80100f7a:	89 44 24 08          	mov    %eax,0x8(%esp)
80100f7e:	8b 43 10             	mov    0x10(%ebx),%eax
80100f81:	89 04 24             	mov    %eax,(%esp)
80100f84:	e8 e7 09 00 00       	call   80101970 <readi>
80100f89:	85 c0                	test   %eax,%eax
80100f8b:	89 c6                	mov    %eax,%esi
80100f8d:	7e 03                	jle    80100f92 <fileread+0x52>
80100f8f:	01 43 14             	add    %eax,0x14(%ebx)
80100f92:	8b 43 10             	mov    0x10(%ebx),%eax
80100f95:	89 04 24             	mov    %eax,(%esp)
80100f98:	e8 03 08 00 00       	call   801017a0 <iunlock>
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
80100fb5:	e9 26 24 00 00       	jmp    801033e0 <piperead>
80100fba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100fc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100fc5:	eb d8                	jmp    80100f9f <fileread+0x5f>
80100fc7:	c7 04 24 e6 6c 10 80 	movl   $0x80106ce6,(%esp)
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
80101034:	e8 67 07 00 00       	call   801017a0 <iunlock>
80101039:	e8 42 1b 00 00       	call   80102b80 <end_op>
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
80101063:	e8 a8 1a 00 00       	call   80102b10 <begin_op>
80101068:	8b 47 10             	mov    0x10(%edi),%eax
8010106b:	89 04 24             	mov    %eax,(%esp)
8010106e:	e8 4d 06 00 00       	call   801016c0 <ilock>
80101073:	89 74 24 0c          	mov    %esi,0xc(%esp)
80101077:	8b 47 14             	mov    0x14(%edi),%eax
8010107a:	89 44 24 08          	mov    %eax,0x8(%esp)
8010107e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101081:	01 d8                	add    %ebx,%eax
80101083:	89 44 24 04          	mov    %eax,0x4(%esp)
80101087:	8b 47 10             	mov    0x10(%edi),%eax
8010108a:	89 04 24             	mov    %eax,(%esp)
8010108d:	e8 de 09 00 00       	call   80101a70 <writei>
80101092:	85 c0                	test   %eax,%eax
80101094:	7f 92                	jg     80101028 <filewrite+0x48>
80101096:	8b 4f 10             	mov    0x10(%edi),%ecx
80101099:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010109c:	89 0c 24             	mov    %ecx,(%esp)
8010109f:	e8 fc 06 00 00       	call   801017a0 <iunlock>
801010a4:	e8 d7 1a 00 00       	call   80102b80 <end_op>
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
801010dc:	e9 0f 22 00 00       	jmp    801032f0 <pipewrite>
801010e1:	c7 04 24 ef 6c 10 80 	movl   $0x80106cef,(%esp)
801010e8:	e8 73 f2 ff ff       	call   80100360 <panic>
801010ed:	c7 04 24 f5 6c 10 80 	movl   $0x80106cf5,(%esp)
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
801011a5:	c7 04 24 ff 6c 10 80 	movl   $0x80106cff,(%esp)
801011ac:	e8 af f1 ff ff       	call   80100360 <panic>
801011b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801011b8:	09 d9                	or     %ebx,%ecx
801011ba:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801011bd:	88 4c 13 5c          	mov    %cl,0x5c(%ebx,%edx,1)
801011c1:	89 1c 24             	mov    %ebx,(%esp)
801011c4:	e8 e7 1a 00 00       	call   80102cb0 <log_write>
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
801011f8:	e8 83 30 00 00       	call   80104280 <memset>
801011fd:	89 1c 24             	mov    %ebx,(%esp)
80101200:	e8 ab 1a 00 00       	call   80102cb0 <log_write>
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
8010123c:	e8 ff 2e 00 00       	call   80104140 <acquire>
80101241:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101244:	eb 14                	jmp    8010125a <iget+0x3a>
80101246:	66 90                	xchg   %ax,%ax
80101248:	85 f6                	test   %esi,%esi
8010124a:	74 3c                	je     80101288 <iget+0x68>
8010124c:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101252:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
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
80101279:	e8 b2 2f 00 00       	call   80104230 <release>
8010127e:	83 c4 1c             	add    $0x1c,%esp
80101281:	89 f0                	mov    %esi,%eax
80101283:	5b                   	pop    %ebx
80101284:	5e                   	pop    %esi
80101285:	5f                   	pop    %edi
80101286:	5d                   	pop    %ebp
80101287:	c3                   	ret    
80101288:	85 c9                	test   %ecx,%ecx
8010128a:	0f 44 f3             	cmove  %ebx,%esi
8010128d:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101293:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
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
801012be:	e8 6d 2f 00 00       	call   80104230 <release>
801012c3:	83 c4 1c             	add    $0x1c,%esp
801012c6:	89 f0                	mov    %esi,%eax
801012c8:	5b                   	pop    %ebx
801012c9:	5e                   	pop    %esi
801012ca:	5f                   	pop    %edi
801012cb:	5d                   	pop    %ebp
801012cc:	c3                   	ret    
801012cd:	c7 04 24 15 6d 10 80 	movl   $0x80106d15,(%esp)
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
801012eb:	83 fa 0b             	cmp    $0xb,%edx
801012ee:	77 18                	ja     80101308 <bmap+0x28>
801012f0:	8d 34 90             	lea    (%eax,%edx,4),%esi
801012f3:	8b 46 5c             	mov    0x5c(%esi),%eax
801012f6:	85 c0                	test   %eax,%eax
801012f8:	74 66                	je     80101360 <bmap+0x80>
801012fa:	83 c4 1c             	add    $0x1c,%esp
801012fd:	5b                   	pop    %ebx
801012fe:	5e                   	pop    %esi
801012ff:	5f                   	pop    %edi
80101300:	5d                   	pop    %ebp
80101301:	c3                   	ret    
80101302:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101308:	8d 72 f4             	lea    -0xc(%edx),%esi
8010130b:	83 fe 7f             	cmp    $0x7f,%esi
8010130e:	77 77                	ja     80101387 <bmap+0xa7>
80101310:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101316:	85 c0                	test   %eax,%eax
80101318:	74 5e                	je     80101378 <bmap+0x98>
8010131a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010131e:	8b 03                	mov    (%ebx),%eax
80101320:	89 04 24             	mov    %eax,(%esp)
80101323:	e8 a8 ed ff ff       	call   801000d0 <bread>
80101328:	8d 54 b0 5c          	lea    0x5c(%eax,%esi,4),%edx
8010132c:	89 c7                	mov    %eax,%edi
8010132e:	8b 32                	mov    (%edx),%esi
80101330:	85 f6                	test   %esi,%esi
80101332:	75 19                	jne    8010134d <bmap+0x6d>
80101334:	8b 03                	mov    (%ebx),%eax
80101336:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101339:	e8 c2 fd ff ff       	call   80101100 <balloc>
8010133e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101341:	89 02                	mov    %eax,(%edx)
80101343:	89 c6                	mov    %eax,%esi
80101345:	89 3c 24             	mov    %edi,(%esp)
80101348:	e8 63 19 00 00       	call   80102cb0 <log_write>
8010134d:	89 3c 24             	mov    %edi,(%esp)
80101350:	e8 8b ee ff ff       	call   801001e0 <brelse>
80101355:	83 c4 1c             	add    $0x1c,%esp
80101358:	89 f0                	mov    %esi,%eax
8010135a:	5b                   	pop    %ebx
8010135b:	5e                   	pop    %esi
8010135c:	5f                   	pop    %edi
8010135d:	5d                   	pop    %ebp
8010135e:	c3                   	ret    
8010135f:	90                   	nop
80101360:	8b 03                	mov    (%ebx),%eax
80101362:	e8 99 fd ff ff       	call   80101100 <balloc>
80101367:	89 46 5c             	mov    %eax,0x5c(%esi)
8010136a:	83 c4 1c             	add    $0x1c,%esp
8010136d:	5b                   	pop    %ebx
8010136e:	5e                   	pop    %esi
8010136f:	5f                   	pop    %edi
80101370:	5d                   	pop    %ebp
80101371:	c3                   	ret    
80101372:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101378:	8b 03                	mov    (%ebx),%eax
8010137a:	e8 81 fd ff ff       	call   80101100 <balloc>
8010137f:	89 83 8c 00 00 00    	mov    %eax,0x8c(%ebx)
80101385:	eb 93                	jmp    8010131a <bmap+0x3a>
80101387:	c7 04 24 25 6d 10 80 	movl   $0x80106d25,(%esp)
8010138e:	e8 cd ef ff ff       	call   80100360 <panic>
80101393:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101399:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801013a0 <readsb>:
801013a0:	55                   	push   %ebp
801013a1:	89 e5                	mov    %esp,%ebp
801013a3:	56                   	push   %esi
801013a4:	53                   	push   %ebx
801013a5:	83 ec 10             	sub    $0x10,%esp
801013a8:	8b 45 08             	mov    0x8(%ebp),%eax
801013ab:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801013b2:	00 
801013b3:	8b 75 0c             	mov    0xc(%ebp),%esi
801013b6:	89 04 24             	mov    %eax,(%esp)
801013b9:	e8 12 ed ff ff       	call   801000d0 <bread>
801013be:	89 34 24             	mov    %esi,(%esp)
801013c1:	c7 44 24 08 1c 00 00 	movl   $0x1c,0x8(%esp)
801013c8:	00 
801013c9:	89 c3                	mov    %eax,%ebx
801013cb:	8d 40 5c             	lea    0x5c(%eax),%eax
801013ce:	89 44 24 04          	mov    %eax,0x4(%esp)
801013d2:	e8 49 2f 00 00       	call   80104320 <memmove>
801013d7:	89 5d 08             	mov    %ebx,0x8(%ebp)
801013da:	83 c4 10             	add    $0x10,%esp
801013dd:	5b                   	pop    %ebx
801013de:	5e                   	pop    %esi
801013df:	5d                   	pop    %ebp
801013e0:	e9 fb ed ff ff       	jmp    801001e0 <brelse>
801013e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801013e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801013f0 <bfree>:
801013f0:	55                   	push   %ebp
801013f1:	89 e5                	mov    %esp,%ebp
801013f3:	57                   	push   %edi
801013f4:	89 d7                	mov    %edx,%edi
801013f6:	56                   	push   %esi
801013f7:	53                   	push   %ebx
801013f8:	89 c3                	mov    %eax,%ebx
801013fa:	83 ec 1c             	sub    $0x1c,%esp
801013fd:	89 04 24             	mov    %eax,(%esp)
80101400:	c7 44 24 04 c0 09 11 	movl   $0x801109c0,0x4(%esp)
80101407:	80 
80101408:	e8 93 ff ff ff       	call   801013a0 <readsb>
8010140d:	89 fa                	mov    %edi,%edx
8010140f:	c1 ea 0c             	shr    $0xc,%edx
80101412:	03 15 d8 09 11 80    	add    0x801109d8,%edx
80101418:	89 1c 24             	mov    %ebx,(%esp)
8010141b:	bb 01 00 00 00       	mov    $0x1,%ebx
80101420:	89 54 24 04          	mov    %edx,0x4(%esp)
80101424:	e8 a7 ec ff ff       	call   801000d0 <bread>
80101429:	89 f9                	mov    %edi,%ecx
8010142b:	81 e7 ff 0f 00 00    	and    $0xfff,%edi
80101431:	89 fa                	mov    %edi,%edx
80101433:	83 e1 07             	and    $0x7,%ecx
80101436:	c1 fa 03             	sar    $0x3,%edx
80101439:	d3 e3                	shl    %cl,%ebx
8010143b:	89 c6                	mov    %eax,%esi
8010143d:	0f b6 44 10 5c       	movzbl 0x5c(%eax,%edx,1),%eax
80101442:	0f b6 c8             	movzbl %al,%ecx
80101445:	85 d9                	test   %ebx,%ecx
80101447:	74 20                	je     80101469 <bfree+0x79>
80101449:	f7 d3                	not    %ebx
8010144b:	21 c3                	and    %eax,%ebx
8010144d:	88 5c 16 5c          	mov    %bl,0x5c(%esi,%edx,1)
80101451:	89 34 24             	mov    %esi,(%esp)
80101454:	e8 57 18 00 00       	call   80102cb0 <log_write>
80101459:	89 34 24             	mov    %esi,(%esp)
8010145c:	e8 7f ed ff ff       	call   801001e0 <brelse>
80101461:	83 c4 1c             	add    $0x1c,%esp
80101464:	5b                   	pop    %ebx
80101465:	5e                   	pop    %esi
80101466:	5f                   	pop    %edi
80101467:	5d                   	pop    %ebp
80101468:	c3                   	ret    
80101469:	c7 04 24 38 6d 10 80 	movl   $0x80106d38,(%esp)
80101470:	e8 eb ee ff ff       	call   80100360 <panic>
80101475:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101479:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101480 <iinit>:
80101480:	55                   	push   %ebp
80101481:	89 e5                	mov    %esp,%ebp
80101483:	53                   	push   %ebx
80101484:	bb 20 0a 11 80       	mov    $0x80110a20,%ebx
80101489:	83 ec 24             	sub    $0x24,%esp
8010148c:	c7 44 24 04 4b 6d 10 	movl   $0x80106d4b,0x4(%esp)
80101493:	80 
80101494:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010149b:	e8 b0 2b 00 00       	call   80104050 <initlock>
801014a0:	89 1c 24             	mov    %ebx,(%esp)
801014a3:	81 c3 90 00 00 00    	add    $0x90,%ebx
801014a9:	c7 44 24 04 52 6d 10 	movl   $0x80106d52,0x4(%esp)
801014b0:	80 
801014b1:	e8 8a 2a 00 00       	call   80103f40 <initsleeplock>
801014b6:	81 fb 40 26 11 80    	cmp    $0x80112640,%ebx
801014bc:	75 e2                	jne    801014a0 <iinit+0x20>
801014be:	8b 45 08             	mov    0x8(%ebp),%eax
801014c1:	c7 44 24 04 c0 09 11 	movl   $0x801109c0,0x4(%esp)
801014c8:	80 
801014c9:	89 04 24             	mov    %eax,(%esp)
801014cc:	e8 cf fe ff ff       	call   801013a0 <readsb>
801014d1:	a1 d8 09 11 80       	mov    0x801109d8,%eax
801014d6:	c7 04 24 b8 6d 10 80 	movl   $0x80106db8,(%esp)
801014dd:	89 44 24 1c          	mov    %eax,0x1c(%esp)
801014e1:	a1 d4 09 11 80       	mov    0x801109d4,%eax
801014e6:	89 44 24 18          	mov    %eax,0x18(%esp)
801014ea:	a1 d0 09 11 80       	mov    0x801109d0,%eax
801014ef:	89 44 24 14          	mov    %eax,0x14(%esp)
801014f3:	a1 cc 09 11 80       	mov    0x801109cc,%eax
801014f8:	89 44 24 10          	mov    %eax,0x10(%esp)
801014fc:	a1 c8 09 11 80       	mov    0x801109c8,%eax
80101501:	89 44 24 0c          	mov    %eax,0xc(%esp)
80101505:	a1 c4 09 11 80       	mov    0x801109c4,%eax
8010150a:	89 44 24 08          	mov    %eax,0x8(%esp)
8010150e:	a1 c0 09 11 80       	mov    0x801109c0,%eax
80101513:	89 44 24 04          	mov    %eax,0x4(%esp)
80101517:	e8 34 f1 ff ff       	call   80100650 <cprintf>
8010151c:	83 c4 24             	add    $0x24,%esp
8010151f:	5b                   	pop    %ebx
80101520:	5d                   	pop    %ebp
80101521:	c3                   	ret    
80101522:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101529:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101530 <ialloc>:
80101530:	55                   	push   %ebp
80101531:	89 e5                	mov    %esp,%ebp
80101533:	57                   	push   %edi
80101534:	56                   	push   %esi
80101535:	53                   	push   %ebx
80101536:	83 ec 2c             	sub    $0x2c,%esp
80101539:	8b 45 0c             	mov    0xc(%ebp),%eax
8010153c:	83 3d c8 09 11 80 01 	cmpl   $0x1,0x801109c8
80101543:	8b 7d 08             	mov    0x8(%ebp),%edi
80101546:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101549:	0f 86 a2 00 00 00    	jbe    801015f1 <ialloc+0xc1>
8010154f:	be 01 00 00 00       	mov    $0x1,%esi
80101554:	bb 01 00 00 00       	mov    $0x1,%ebx
80101559:	eb 1a                	jmp    80101575 <ialloc+0x45>
8010155b:	90                   	nop
8010155c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101560:	89 14 24             	mov    %edx,(%esp)
80101563:	83 c3 01             	add    $0x1,%ebx
80101566:	e8 75 ec ff ff       	call   801001e0 <brelse>
8010156b:	89 de                	mov    %ebx,%esi
8010156d:	3b 1d c8 09 11 80    	cmp    0x801109c8,%ebx
80101573:	73 7c                	jae    801015f1 <ialloc+0xc1>
80101575:	89 f0                	mov    %esi,%eax
80101577:	c1 e8 03             	shr    $0x3,%eax
8010157a:	03 05 d4 09 11 80    	add    0x801109d4,%eax
80101580:	89 3c 24             	mov    %edi,(%esp)
80101583:	89 44 24 04          	mov    %eax,0x4(%esp)
80101587:	e8 44 eb ff ff       	call   801000d0 <bread>
8010158c:	89 c2                	mov    %eax,%edx
8010158e:	89 f0                	mov    %esi,%eax
80101590:	83 e0 07             	and    $0x7,%eax
80101593:	c1 e0 06             	shl    $0x6,%eax
80101596:	8d 4c 02 5c          	lea    0x5c(%edx,%eax,1),%ecx
8010159a:	66 83 39 00          	cmpw   $0x0,(%ecx)
8010159e:	75 c0                	jne    80101560 <ialloc+0x30>
801015a0:	89 0c 24             	mov    %ecx,(%esp)
801015a3:	c7 44 24 08 40 00 00 	movl   $0x40,0x8(%esp)
801015aa:	00 
801015ab:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801015b2:	00 
801015b3:	89 55 dc             	mov    %edx,-0x24(%ebp)
801015b6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801015b9:	e8 c2 2c 00 00       	call   80104280 <memset>
801015be:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801015c2:	8b 55 dc             	mov    -0x24(%ebp),%edx
801015c5:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801015c8:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801015cb:	66 89 01             	mov    %ax,(%ecx)
801015ce:	89 14 24             	mov    %edx,(%esp)
801015d1:	e8 da 16 00 00       	call   80102cb0 <log_write>
801015d6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801015d9:	89 14 24             	mov    %edx,(%esp)
801015dc:	e8 ff eb ff ff       	call   801001e0 <brelse>
801015e1:	83 c4 2c             	add    $0x2c,%esp
801015e4:	89 f2                	mov    %esi,%edx
801015e6:	5b                   	pop    %ebx
801015e7:	89 f8                	mov    %edi,%eax
801015e9:	5e                   	pop    %esi
801015ea:	5f                   	pop    %edi
801015eb:	5d                   	pop    %ebp
801015ec:	e9 2f fc ff ff       	jmp    80101220 <iget>
801015f1:	c7 04 24 58 6d 10 80 	movl   $0x80106d58,(%esp)
801015f8:	e8 63 ed ff ff       	call   80100360 <panic>
801015fd:	8d 76 00             	lea    0x0(%esi),%esi

80101600 <iupdate>:
80101600:	55                   	push   %ebp
80101601:	89 e5                	mov    %esp,%ebp
80101603:	56                   	push   %esi
80101604:	53                   	push   %ebx
80101605:	83 ec 10             	sub    $0x10,%esp
80101608:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010160b:	8b 43 04             	mov    0x4(%ebx),%eax
8010160e:	83 c3 5c             	add    $0x5c,%ebx
80101611:	c1 e8 03             	shr    $0x3,%eax
80101614:	03 05 d4 09 11 80    	add    0x801109d4,%eax
8010161a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010161e:	8b 43 a4             	mov    -0x5c(%ebx),%eax
80101621:	89 04 24             	mov    %eax,(%esp)
80101624:	e8 a7 ea ff ff       	call   801000d0 <bread>
80101629:	8b 53 a8             	mov    -0x58(%ebx),%edx
8010162c:	83 e2 07             	and    $0x7,%edx
8010162f:	c1 e2 06             	shl    $0x6,%edx
80101632:	8d 54 10 5c          	lea    0x5c(%eax,%edx,1),%edx
80101636:	89 c6                	mov    %eax,%esi
80101638:	0f b7 43 f4          	movzwl -0xc(%ebx),%eax
8010163c:	83 c2 0c             	add    $0xc,%edx
8010163f:	66 89 42 f4          	mov    %ax,-0xc(%edx)
80101643:	0f b7 43 f6          	movzwl -0xa(%ebx),%eax
80101647:	66 89 42 f6          	mov    %ax,-0xa(%edx)
8010164b:	0f b7 43 f8          	movzwl -0x8(%ebx),%eax
8010164f:	66 89 42 f8          	mov    %ax,-0x8(%edx)
80101653:	0f b7 43 fa          	movzwl -0x6(%ebx),%eax
80101657:	66 89 42 fa          	mov    %ax,-0x6(%edx)
8010165b:	8b 43 fc             	mov    -0x4(%ebx),%eax
8010165e:	89 42 fc             	mov    %eax,-0x4(%edx)
80101661:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101665:	89 14 24             	mov    %edx,(%esp)
80101668:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
8010166f:	00 
80101670:	e8 ab 2c 00 00       	call   80104320 <memmove>
80101675:	89 34 24             	mov    %esi,(%esp)
80101678:	e8 33 16 00 00       	call   80102cb0 <log_write>
8010167d:	89 75 08             	mov    %esi,0x8(%ebp)
80101680:	83 c4 10             	add    $0x10,%esp
80101683:	5b                   	pop    %ebx
80101684:	5e                   	pop    %esi
80101685:	5d                   	pop    %ebp
80101686:	e9 55 eb ff ff       	jmp    801001e0 <brelse>
8010168b:	90                   	nop
8010168c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101690 <idup>:
80101690:	55                   	push   %ebp
80101691:	89 e5                	mov    %esp,%ebp
80101693:	53                   	push   %ebx
80101694:	83 ec 14             	sub    $0x14,%esp
80101697:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010169a:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801016a1:	e8 9a 2a 00 00       	call   80104140 <acquire>
801016a6:	83 43 08 01          	addl   $0x1,0x8(%ebx)
801016aa:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801016b1:	e8 7a 2b 00 00       	call   80104230 <release>
801016b6:	83 c4 14             	add    $0x14,%esp
801016b9:	89 d8                	mov    %ebx,%eax
801016bb:	5b                   	pop    %ebx
801016bc:	5d                   	pop    %ebp
801016bd:	c3                   	ret    
801016be:	66 90                	xchg   %ax,%ax

801016c0 <ilock>:
801016c0:	55                   	push   %ebp
801016c1:	89 e5                	mov    %esp,%ebp
801016c3:	56                   	push   %esi
801016c4:	53                   	push   %ebx
801016c5:	83 ec 10             	sub    $0x10,%esp
801016c8:	8b 5d 08             	mov    0x8(%ebp),%ebx
801016cb:	85 db                	test   %ebx,%ebx
801016cd:	0f 84 b3 00 00 00    	je     80101786 <ilock+0xc6>
801016d3:	8b 4b 08             	mov    0x8(%ebx),%ecx
801016d6:	85 c9                	test   %ecx,%ecx
801016d8:	0f 8e a8 00 00 00    	jle    80101786 <ilock+0xc6>
801016de:	8d 43 0c             	lea    0xc(%ebx),%eax
801016e1:	89 04 24             	mov    %eax,(%esp)
801016e4:	e8 97 28 00 00       	call   80103f80 <acquiresleep>
801016e9:	8b 53 4c             	mov    0x4c(%ebx),%edx
801016ec:	85 d2                	test   %edx,%edx
801016ee:	74 08                	je     801016f8 <ilock+0x38>
801016f0:	83 c4 10             	add    $0x10,%esp
801016f3:	5b                   	pop    %ebx
801016f4:	5e                   	pop    %esi
801016f5:	5d                   	pop    %ebp
801016f6:	c3                   	ret    
801016f7:	90                   	nop
801016f8:	8b 43 04             	mov    0x4(%ebx),%eax
801016fb:	c1 e8 03             	shr    $0x3,%eax
801016fe:	03 05 d4 09 11 80    	add    0x801109d4,%eax
80101704:	89 44 24 04          	mov    %eax,0x4(%esp)
80101708:	8b 03                	mov    (%ebx),%eax
8010170a:	89 04 24             	mov    %eax,(%esp)
8010170d:	e8 be e9 ff ff       	call   801000d0 <bread>
80101712:	8b 53 04             	mov    0x4(%ebx),%edx
80101715:	83 e2 07             	and    $0x7,%edx
80101718:	c1 e2 06             	shl    $0x6,%edx
8010171b:	8d 54 10 5c          	lea    0x5c(%eax,%edx,1),%edx
8010171f:	89 c6                	mov    %eax,%esi
80101721:	0f b7 02             	movzwl (%edx),%eax
80101724:	83 c2 0c             	add    $0xc,%edx
80101727:	66 89 43 50          	mov    %ax,0x50(%ebx)
8010172b:	0f b7 42 f6          	movzwl -0xa(%edx),%eax
8010172f:	66 89 43 52          	mov    %ax,0x52(%ebx)
80101733:	0f b7 42 f8          	movzwl -0x8(%edx),%eax
80101737:	66 89 43 54          	mov    %ax,0x54(%ebx)
8010173b:	0f b7 42 fa          	movzwl -0x6(%edx),%eax
8010173f:	66 89 43 56          	mov    %ax,0x56(%ebx)
80101743:	8b 42 fc             	mov    -0x4(%edx),%eax
80101746:	89 43 58             	mov    %eax,0x58(%ebx)
80101749:	8d 43 5c             	lea    0x5c(%ebx),%eax
8010174c:	89 54 24 04          	mov    %edx,0x4(%esp)
80101750:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
80101757:	00 
80101758:	89 04 24             	mov    %eax,(%esp)
8010175b:	e8 c0 2b 00 00       	call   80104320 <memmove>
80101760:	89 34 24             	mov    %esi,(%esp)
80101763:	e8 78 ea ff ff       	call   801001e0 <brelse>
80101768:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
8010176d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
80101774:	0f 85 76 ff ff ff    	jne    801016f0 <ilock+0x30>
8010177a:	c7 04 24 70 6d 10 80 	movl   $0x80106d70,(%esp)
80101781:	e8 da eb ff ff       	call   80100360 <panic>
80101786:	c7 04 24 6a 6d 10 80 	movl   $0x80106d6a,(%esp)
8010178d:	e8 ce eb ff ff       	call   80100360 <panic>
80101792:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101799:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801017a0 <iunlock>:
801017a0:	55                   	push   %ebp
801017a1:	89 e5                	mov    %esp,%ebp
801017a3:	56                   	push   %esi
801017a4:	53                   	push   %ebx
801017a5:	83 ec 10             	sub    $0x10,%esp
801017a8:	8b 5d 08             	mov    0x8(%ebp),%ebx
801017ab:	85 db                	test   %ebx,%ebx
801017ad:	74 24                	je     801017d3 <iunlock+0x33>
801017af:	8d 73 0c             	lea    0xc(%ebx),%esi
801017b2:	89 34 24             	mov    %esi,(%esp)
801017b5:	e8 66 28 00 00       	call   80104020 <holdingsleep>
801017ba:	85 c0                	test   %eax,%eax
801017bc:	74 15                	je     801017d3 <iunlock+0x33>
801017be:	8b 5b 08             	mov    0x8(%ebx),%ebx
801017c1:	85 db                	test   %ebx,%ebx
801017c3:	7e 0e                	jle    801017d3 <iunlock+0x33>
801017c5:	89 75 08             	mov    %esi,0x8(%ebp)
801017c8:	83 c4 10             	add    $0x10,%esp
801017cb:	5b                   	pop    %ebx
801017cc:	5e                   	pop    %esi
801017cd:	5d                   	pop    %ebp
801017ce:	e9 0d 28 00 00       	jmp    80103fe0 <releasesleep>
801017d3:	c7 04 24 7f 6d 10 80 	movl   $0x80106d7f,(%esp)
801017da:	e8 81 eb ff ff       	call   80100360 <panic>
801017df:	90                   	nop

801017e0 <iput>:
801017e0:	55                   	push   %ebp
801017e1:	89 e5                	mov    %esp,%ebp
801017e3:	57                   	push   %edi
801017e4:	56                   	push   %esi
801017e5:	53                   	push   %ebx
801017e6:	83 ec 1c             	sub    $0x1c,%esp
801017e9:	8b 75 08             	mov    0x8(%ebp),%esi
801017ec:	8d 7e 0c             	lea    0xc(%esi),%edi
801017ef:	89 3c 24             	mov    %edi,(%esp)
801017f2:	e8 89 27 00 00       	call   80103f80 <acquiresleep>
801017f7:	8b 46 4c             	mov    0x4c(%esi),%eax
801017fa:	85 c0                	test   %eax,%eax
801017fc:	74 07                	je     80101805 <iput+0x25>
801017fe:	66 83 7e 56 00       	cmpw   $0x0,0x56(%esi)
80101803:	74 2b                	je     80101830 <iput+0x50>
80101805:	89 3c 24             	mov    %edi,(%esp)
80101808:	e8 d3 27 00 00       	call   80103fe0 <releasesleep>
8010180d:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101814:	e8 27 29 00 00       	call   80104140 <acquire>
80101819:	83 6e 08 01          	subl   $0x1,0x8(%esi)
8010181d:	c7 45 08 e0 09 11 80 	movl   $0x801109e0,0x8(%ebp)
80101824:	83 c4 1c             	add    $0x1c,%esp
80101827:	5b                   	pop    %ebx
80101828:	5e                   	pop    %esi
80101829:	5f                   	pop    %edi
8010182a:	5d                   	pop    %ebp
8010182b:	e9 00 2a 00 00       	jmp    80104230 <release>
80101830:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101837:	e8 04 29 00 00       	call   80104140 <acquire>
8010183c:	8b 5e 08             	mov    0x8(%esi),%ebx
8010183f:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101846:	e8 e5 29 00 00       	call   80104230 <release>
8010184b:	83 fb 01             	cmp    $0x1,%ebx
8010184e:	75 b5                	jne    80101805 <iput+0x25>
80101850:	8d 4e 30             	lea    0x30(%esi),%ecx
80101853:	89 f3                	mov    %esi,%ebx
80101855:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101858:	89 cf                	mov    %ecx,%edi
8010185a:	eb 0b                	jmp    80101867 <iput+0x87>
8010185c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101860:	83 c3 04             	add    $0x4,%ebx
80101863:	39 fb                	cmp    %edi,%ebx
80101865:	74 19                	je     80101880 <iput+0xa0>
80101867:	8b 53 5c             	mov    0x5c(%ebx),%edx
8010186a:	85 d2                	test   %edx,%edx
8010186c:	74 f2                	je     80101860 <iput+0x80>
8010186e:	8b 06                	mov    (%esi),%eax
80101870:	e8 7b fb ff ff       	call   801013f0 <bfree>
80101875:	c7 43 5c 00 00 00 00 	movl   $0x0,0x5c(%ebx)
8010187c:	eb e2                	jmp    80101860 <iput+0x80>
8010187e:	66 90                	xchg   %ax,%ax
80101880:	8b 86 8c 00 00 00    	mov    0x8c(%esi),%eax
80101886:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101889:	85 c0                	test   %eax,%eax
8010188b:	75 2b                	jne    801018b8 <iput+0xd8>
8010188d:	c7 46 58 00 00 00 00 	movl   $0x0,0x58(%esi)
80101894:	89 34 24             	mov    %esi,(%esp)
80101897:	e8 64 fd ff ff       	call   80101600 <iupdate>
8010189c:	31 c0                	xor    %eax,%eax
8010189e:	66 89 46 50          	mov    %ax,0x50(%esi)
801018a2:	89 34 24             	mov    %esi,(%esp)
801018a5:	e8 56 fd ff ff       	call   80101600 <iupdate>
801018aa:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
801018b1:	e9 4f ff ff ff       	jmp    80101805 <iput+0x25>
801018b6:	66 90                	xchg   %ax,%ax
801018b8:	89 44 24 04          	mov    %eax,0x4(%esp)
801018bc:	8b 06                	mov    (%esi),%eax
801018be:	31 db                	xor    %ebx,%ebx
801018c0:	89 04 24             	mov    %eax,(%esp)
801018c3:	e8 08 e8 ff ff       	call   801000d0 <bread>
801018c8:	89 7d e0             	mov    %edi,-0x20(%ebp)
801018cb:	8d 48 5c             	lea    0x5c(%eax),%ecx
801018ce:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801018d1:	89 cf                	mov    %ecx,%edi
801018d3:	31 c0                	xor    %eax,%eax
801018d5:	eb 0e                	jmp    801018e5 <iput+0x105>
801018d7:	90                   	nop
801018d8:	83 c3 01             	add    $0x1,%ebx
801018db:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
801018e1:	89 d8                	mov    %ebx,%eax
801018e3:	74 10                	je     801018f5 <iput+0x115>
801018e5:	8b 14 87             	mov    (%edi,%eax,4),%edx
801018e8:	85 d2                	test   %edx,%edx
801018ea:	74 ec                	je     801018d8 <iput+0xf8>
801018ec:	8b 06                	mov    (%esi),%eax
801018ee:	e8 fd fa ff ff       	call   801013f0 <bfree>
801018f3:	eb e3                	jmp    801018d8 <iput+0xf8>
801018f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801018f8:	8b 7d e0             	mov    -0x20(%ebp),%edi
801018fb:	89 04 24             	mov    %eax,(%esp)
801018fe:	e8 dd e8 ff ff       	call   801001e0 <brelse>
80101903:	8b 96 8c 00 00 00    	mov    0x8c(%esi),%edx
80101909:	8b 06                	mov    (%esi),%eax
8010190b:	e8 e0 fa ff ff       	call   801013f0 <bfree>
80101910:	c7 86 8c 00 00 00 00 	movl   $0x0,0x8c(%esi)
80101917:	00 00 00 
8010191a:	e9 6e ff ff ff       	jmp    8010188d <iput+0xad>
8010191f:	90                   	nop

80101920 <iunlockput>:
80101920:	55                   	push   %ebp
80101921:	89 e5                	mov    %esp,%ebp
80101923:	53                   	push   %ebx
80101924:	83 ec 14             	sub    $0x14,%esp
80101927:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010192a:	89 1c 24             	mov    %ebx,(%esp)
8010192d:	e8 6e fe ff ff       	call   801017a0 <iunlock>
80101932:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101935:	83 c4 14             	add    $0x14,%esp
80101938:	5b                   	pop    %ebx
80101939:	5d                   	pop    %ebp
8010193a:	e9 a1 fe ff ff       	jmp    801017e0 <iput>
8010193f:	90                   	nop

80101940 <stati>:
80101940:	55                   	push   %ebp
80101941:	89 e5                	mov    %esp,%ebp
80101943:	8b 55 08             	mov    0x8(%ebp),%edx
80101946:	8b 45 0c             	mov    0xc(%ebp),%eax
80101949:	8b 0a                	mov    (%edx),%ecx
8010194b:	89 48 04             	mov    %ecx,0x4(%eax)
8010194e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101951:	89 48 08             	mov    %ecx,0x8(%eax)
80101954:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101958:	66 89 08             	mov    %cx,(%eax)
8010195b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010195f:	66 89 48 0c          	mov    %cx,0xc(%eax)
80101963:	8b 52 58             	mov    0x58(%edx),%edx
80101966:	89 50 10             	mov    %edx,0x10(%eax)
80101969:	5d                   	pop    %ebp
8010196a:	c3                   	ret    
8010196b:	90                   	nop
8010196c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101970 <readi>:
80101970:	55                   	push   %ebp
80101971:	89 e5                	mov    %esp,%ebp
80101973:	57                   	push   %edi
80101974:	56                   	push   %esi
80101975:	53                   	push   %ebx
80101976:	83 ec 2c             	sub    $0x2c,%esp
80101979:	8b 45 0c             	mov    0xc(%ebp),%eax
8010197c:	8b 7d 08             	mov    0x8(%ebp),%edi
8010197f:	8b 75 10             	mov    0x10(%ebp),%esi
80101982:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101985:	8b 45 14             	mov    0x14(%ebp),%eax
80101988:	66 83 7f 50 03       	cmpw   $0x3,0x50(%edi)
8010198d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101990:	0f 84 aa 00 00 00    	je     80101a40 <readi+0xd0>
80101996:	8b 47 58             	mov    0x58(%edi),%eax
80101999:	39 f0                	cmp    %esi,%eax
8010199b:	0f 82 c7 00 00 00    	jb     80101a68 <readi+0xf8>
801019a1:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801019a4:	89 da                	mov    %ebx,%edx
801019a6:	01 f2                	add    %esi,%edx
801019a8:	0f 82 ba 00 00 00    	jb     80101a68 <readi+0xf8>
801019ae:	89 c1                	mov    %eax,%ecx
801019b0:	29 f1                	sub    %esi,%ecx
801019b2:	39 d0                	cmp    %edx,%eax
801019b4:	0f 43 cb             	cmovae %ebx,%ecx
801019b7:	31 c0                	xor    %eax,%eax
801019b9:	85 c9                	test   %ecx,%ecx
801019bb:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801019be:	74 70                	je     80101a30 <readi+0xc0>
801019c0:	89 7d d8             	mov    %edi,-0x28(%ebp)
801019c3:	89 c7                	mov    %eax,%edi
801019c5:	8d 76 00             	lea    0x0(%esi),%esi
801019c8:	8b 5d d8             	mov    -0x28(%ebp),%ebx
801019cb:	89 f2                	mov    %esi,%edx
801019cd:	c1 ea 09             	shr    $0x9,%edx
801019d0:	89 d8                	mov    %ebx,%eax
801019d2:	e8 09 f9 ff ff       	call   801012e0 <bmap>
801019d7:	89 44 24 04          	mov    %eax,0x4(%esp)
801019db:	8b 03                	mov    (%ebx),%eax
801019dd:	bb 00 02 00 00       	mov    $0x200,%ebx
801019e2:	89 04 24             	mov    %eax,(%esp)
801019e5:	e8 e6 e6 ff ff       	call   801000d0 <bread>
801019ea:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801019ed:	29 f9                	sub    %edi,%ecx
801019ef:	89 c2                	mov    %eax,%edx
801019f1:	89 f0                	mov    %esi,%eax
801019f3:	25 ff 01 00 00       	and    $0x1ff,%eax
801019f8:	29 c3                	sub    %eax,%ebx
801019fa:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
801019fe:	39 cb                	cmp    %ecx,%ebx
80101a00:	89 44 24 04          	mov    %eax,0x4(%esp)
80101a04:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101a07:	0f 47 d9             	cmova  %ecx,%ebx
80101a0a:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80101a0e:	01 df                	add    %ebx,%edi
80101a10:	01 de                	add    %ebx,%esi
80101a12:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101a15:	89 04 24             	mov    %eax,(%esp)
80101a18:	e8 03 29 00 00       	call   80104320 <memmove>
80101a1d:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101a20:	89 14 24             	mov    %edx,(%esp)
80101a23:	e8 b8 e7 ff ff       	call   801001e0 <brelse>
80101a28:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101a2b:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101a2e:	77 98                	ja     801019c8 <readi+0x58>
80101a30:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101a33:	83 c4 2c             	add    $0x2c,%esp
80101a36:	5b                   	pop    %ebx
80101a37:	5e                   	pop    %esi
80101a38:	5f                   	pop    %edi
80101a39:	5d                   	pop    %ebp
80101a3a:	c3                   	ret    
80101a3b:	90                   	nop
80101a3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101a40:	0f bf 47 52          	movswl 0x52(%edi),%eax
80101a44:	66 83 f8 09          	cmp    $0x9,%ax
80101a48:	77 1e                	ja     80101a68 <readi+0xf8>
80101a4a:	8b 04 c5 60 09 11 80 	mov    -0x7feef6a0(,%eax,8),%eax
80101a51:	85 c0                	test   %eax,%eax
80101a53:	74 13                	je     80101a68 <readi+0xf8>
80101a55:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101a58:	89 75 10             	mov    %esi,0x10(%ebp)
80101a5b:	83 c4 2c             	add    $0x2c,%esp
80101a5e:	5b                   	pop    %ebx
80101a5f:	5e                   	pop    %esi
80101a60:	5f                   	pop    %edi
80101a61:	5d                   	pop    %ebp
80101a62:	ff e0                	jmp    *%eax
80101a64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101a68:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a6d:	eb c4                	jmp    80101a33 <readi+0xc3>
80101a6f:	90                   	nop

80101a70 <writei>:
80101a70:	55                   	push   %ebp
80101a71:	89 e5                	mov    %esp,%ebp
80101a73:	57                   	push   %edi
80101a74:	56                   	push   %esi
80101a75:	53                   	push   %ebx
80101a76:	83 ec 2c             	sub    $0x2c,%esp
80101a79:	8b 45 08             	mov    0x8(%ebp),%eax
80101a7c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101a7f:	8b 4d 14             	mov    0x14(%ebp),%ecx
80101a82:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
80101a87:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101a8a:	8b 75 10             	mov    0x10(%ebp),%esi
80101a8d:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a90:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101a93:	0f 84 b7 00 00 00    	je     80101b50 <writei+0xe0>
80101a99:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a9c:	39 70 58             	cmp    %esi,0x58(%eax)
80101a9f:	0f 82 e3 00 00 00    	jb     80101b88 <writei+0x118>
80101aa5:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101aa8:	89 c8                	mov    %ecx,%eax
80101aaa:	01 f0                	add    %esi,%eax
80101aac:	0f 82 d6 00 00 00    	jb     80101b88 <writei+0x118>
80101ab2:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101ab7:	0f 87 cb 00 00 00    	ja     80101b88 <writei+0x118>
80101abd:	85 c9                	test   %ecx,%ecx
80101abf:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101ac6:	74 77                	je     80101b3f <writei+0xcf>
80101ac8:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101acb:	89 f2                	mov    %esi,%edx
80101acd:	bb 00 02 00 00       	mov    $0x200,%ebx
80101ad2:	c1 ea 09             	shr    $0x9,%edx
80101ad5:	89 f8                	mov    %edi,%eax
80101ad7:	e8 04 f8 ff ff       	call   801012e0 <bmap>
80101adc:	89 44 24 04          	mov    %eax,0x4(%esp)
80101ae0:	8b 07                	mov    (%edi),%eax
80101ae2:	89 04 24             	mov    %eax,(%esp)
80101ae5:	e8 e6 e5 ff ff       	call   801000d0 <bread>
80101aea:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101aed:	2b 4d e4             	sub    -0x1c(%ebp),%ecx
80101af0:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101af3:	89 c7                	mov    %eax,%edi
80101af5:	89 f0                	mov    %esi,%eax
80101af7:	25 ff 01 00 00       	and    $0x1ff,%eax
80101afc:	29 c3                	sub    %eax,%ebx
80101afe:	39 cb                	cmp    %ecx,%ebx
80101b00:	0f 47 d9             	cmova  %ecx,%ebx
80101b03:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
80101b07:	01 de                	add    %ebx,%esi
80101b09:	89 54 24 04          	mov    %edx,0x4(%esp)
80101b0d:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80101b11:	89 04 24             	mov    %eax,(%esp)
80101b14:	e8 07 28 00 00       	call   80104320 <memmove>
80101b19:	89 3c 24             	mov    %edi,(%esp)
80101b1c:	e8 8f 11 00 00       	call   80102cb0 <log_write>
80101b21:	89 3c 24             	mov    %edi,(%esp)
80101b24:	e8 b7 e6 ff ff       	call   801001e0 <brelse>
80101b29:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101b2c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101b2f:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101b32:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101b35:	77 91                	ja     80101ac8 <writei+0x58>
80101b37:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b3a:	39 70 58             	cmp    %esi,0x58(%eax)
80101b3d:	72 39                	jb     80101b78 <writei+0x108>
80101b3f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101b42:	83 c4 2c             	add    $0x2c,%esp
80101b45:	5b                   	pop    %ebx
80101b46:	5e                   	pop    %esi
80101b47:	5f                   	pop    %edi
80101b48:	5d                   	pop    %ebp
80101b49:	c3                   	ret    
80101b4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101b50:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b54:	66 83 f8 09          	cmp    $0x9,%ax
80101b58:	77 2e                	ja     80101b88 <writei+0x118>
80101b5a:	8b 04 c5 64 09 11 80 	mov    -0x7feef69c(,%eax,8),%eax
80101b61:	85 c0                	test   %eax,%eax
80101b63:	74 23                	je     80101b88 <writei+0x118>
80101b65:	89 4d 10             	mov    %ecx,0x10(%ebp)
80101b68:	83 c4 2c             	add    $0x2c,%esp
80101b6b:	5b                   	pop    %ebx
80101b6c:	5e                   	pop    %esi
80101b6d:	5f                   	pop    %edi
80101b6e:	5d                   	pop    %ebp
80101b6f:	ff e0                	jmp    *%eax
80101b71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b78:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b7b:	89 70 58             	mov    %esi,0x58(%eax)
80101b7e:	89 04 24             	mov    %eax,(%esp)
80101b81:	e8 7a fa ff ff       	call   80101600 <iupdate>
80101b86:	eb b7                	jmp    80101b3f <writei+0xcf>
80101b88:	83 c4 2c             	add    $0x2c,%esp
80101b8b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b90:	5b                   	pop    %ebx
80101b91:	5e                   	pop    %esi
80101b92:	5f                   	pop    %edi
80101b93:	5d                   	pop    %ebp
80101b94:	c3                   	ret    
80101b95:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101b99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ba0 <namecmp>:
80101ba0:	55                   	push   %ebp
80101ba1:	89 e5                	mov    %esp,%ebp
80101ba3:	83 ec 18             	sub    $0x18,%esp
80101ba6:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ba9:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101bb0:	00 
80101bb1:	89 44 24 04          	mov    %eax,0x4(%esp)
80101bb5:	8b 45 08             	mov    0x8(%ebp),%eax
80101bb8:	89 04 24             	mov    %eax,(%esp)
80101bbb:	e8 e0 27 00 00       	call   801043a0 <strncmp>
80101bc0:	c9                   	leave  
80101bc1:	c3                   	ret    
80101bc2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101bc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101bd0 <dirlookup>:
80101bd0:	55                   	push   %ebp
80101bd1:	89 e5                	mov    %esp,%ebp
80101bd3:	57                   	push   %edi
80101bd4:	56                   	push   %esi
80101bd5:	53                   	push   %ebx
80101bd6:	83 ec 2c             	sub    $0x2c,%esp
80101bd9:	8b 5d 08             	mov    0x8(%ebp),%ebx
80101bdc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101be1:	0f 85 97 00 00 00    	jne    80101c7e <dirlookup+0xae>
80101be7:	8b 43 58             	mov    0x58(%ebx),%eax
80101bea:	31 ff                	xor    %edi,%edi
80101bec:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101bef:	85 c0                	test   %eax,%eax
80101bf1:	75 0d                	jne    80101c00 <dirlookup+0x30>
80101bf3:	eb 73                	jmp    80101c68 <dirlookup+0x98>
80101bf5:	8d 76 00             	lea    0x0(%esi),%esi
80101bf8:	83 c7 10             	add    $0x10,%edi
80101bfb:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101bfe:	76 68                	jbe    80101c68 <dirlookup+0x98>
80101c00:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101c07:	00 
80101c08:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101c0c:	89 74 24 04          	mov    %esi,0x4(%esp)
80101c10:	89 1c 24             	mov    %ebx,(%esp)
80101c13:	e8 58 fd ff ff       	call   80101970 <readi>
80101c18:	83 f8 10             	cmp    $0x10,%eax
80101c1b:	75 55                	jne    80101c72 <dirlookup+0xa2>
80101c1d:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101c22:	74 d4                	je     80101bf8 <dirlookup+0x28>
80101c24:	8d 45 da             	lea    -0x26(%ebp),%eax
80101c27:	89 44 24 04          	mov    %eax,0x4(%esp)
80101c2b:	8b 45 0c             	mov    0xc(%ebp),%eax
80101c2e:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101c35:	00 
80101c36:	89 04 24             	mov    %eax,(%esp)
80101c39:	e8 62 27 00 00       	call   801043a0 <strncmp>
80101c3e:	85 c0                	test   %eax,%eax
80101c40:	75 b6                	jne    80101bf8 <dirlookup+0x28>
80101c42:	8b 45 10             	mov    0x10(%ebp),%eax
80101c45:	85 c0                	test   %eax,%eax
80101c47:	74 05                	je     80101c4e <dirlookup+0x7e>
80101c49:	8b 45 10             	mov    0x10(%ebp),%eax
80101c4c:	89 38                	mov    %edi,(%eax)
80101c4e:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
80101c52:	8b 03                	mov    (%ebx),%eax
80101c54:	e8 c7 f5 ff ff       	call   80101220 <iget>
80101c59:	83 c4 2c             	add    $0x2c,%esp
80101c5c:	5b                   	pop    %ebx
80101c5d:	5e                   	pop    %esi
80101c5e:	5f                   	pop    %edi
80101c5f:	5d                   	pop    %ebp
80101c60:	c3                   	ret    
80101c61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c68:	83 c4 2c             	add    $0x2c,%esp
80101c6b:	31 c0                	xor    %eax,%eax
80101c6d:	5b                   	pop    %ebx
80101c6e:	5e                   	pop    %esi
80101c6f:	5f                   	pop    %edi
80101c70:	5d                   	pop    %ebp
80101c71:	c3                   	ret    
80101c72:	c7 04 24 99 6d 10 80 	movl   $0x80106d99,(%esp)
80101c79:	e8 e2 e6 ff ff       	call   80100360 <panic>
80101c7e:	c7 04 24 87 6d 10 80 	movl   $0x80106d87,(%esp)
80101c85:	e8 d6 e6 ff ff       	call   80100360 <panic>
80101c8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101c90 <namex>:
80101c90:	55                   	push   %ebp
80101c91:	89 e5                	mov    %esp,%ebp
80101c93:	57                   	push   %edi
80101c94:	89 cf                	mov    %ecx,%edi
80101c96:	56                   	push   %esi
80101c97:	53                   	push   %ebx
80101c98:	89 c3                	mov    %eax,%ebx
80101c9a:	83 ec 2c             	sub    $0x2c,%esp
80101c9d:	80 38 2f             	cmpb   $0x2f,(%eax)
80101ca0:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101ca3:	0f 84 51 01 00 00    	je     80101dfa <namex+0x16a>
80101ca9:	e8 f2 19 00 00       	call   801036a0 <myproc>
80101cae:	8b 70 68             	mov    0x68(%eax),%esi
80101cb1:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101cb8:	e8 83 24 00 00       	call   80104140 <acquire>
80101cbd:	83 46 08 01          	addl   $0x1,0x8(%esi)
80101cc1:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101cc8:	e8 63 25 00 00       	call   80104230 <release>
80101ccd:	eb 04                	jmp    80101cd3 <namex+0x43>
80101ccf:	90                   	nop
80101cd0:	83 c3 01             	add    $0x1,%ebx
80101cd3:	0f b6 03             	movzbl (%ebx),%eax
80101cd6:	3c 2f                	cmp    $0x2f,%al
80101cd8:	74 f6                	je     80101cd0 <namex+0x40>
80101cda:	84 c0                	test   %al,%al
80101cdc:	0f 84 ed 00 00 00    	je     80101dcf <namex+0x13f>
80101ce2:	0f b6 03             	movzbl (%ebx),%eax
80101ce5:	89 da                	mov    %ebx,%edx
80101ce7:	84 c0                	test   %al,%al
80101ce9:	0f 84 b1 00 00 00    	je     80101da0 <namex+0x110>
80101cef:	3c 2f                	cmp    $0x2f,%al
80101cf1:	75 0f                	jne    80101d02 <namex+0x72>
80101cf3:	e9 a8 00 00 00       	jmp    80101da0 <namex+0x110>
80101cf8:	3c 2f                	cmp    $0x2f,%al
80101cfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101d00:	74 0a                	je     80101d0c <namex+0x7c>
80101d02:	83 c2 01             	add    $0x1,%edx
80101d05:	0f b6 02             	movzbl (%edx),%eax
80101d08:	84 c0                	test   %al,%al
80101d0a:	75 ec                	jne    80101cf8 <namex+0x68>
80101d0c:	89 d1                	mov    %edx,%ecx
80101d0e:	29 d9                	sub    %ebx,%ecx
80101d10:	83 f9 0d             	cmp    $0xd,%ecx
80101d13:	0f 8e 8f 00 00 00    	jle    80101da8 <namex+0x118>
80101d19:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101d1d:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101d24:	00 
80101d25:	89 3c 24             	mov    %edi,(%esp)
80101d28:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101d2b:	e8 f0 25 00 00       	call   80104320 <memmove>
80101d30:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101d33:	89 d3                	mov    %edx,%ebx
80101d35:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101d38:	75 0e                	jne    80101d48 <namex+0xb8>
80101d3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101d40:	83 c3 01             	add    $0x1,%ebx
80101d43:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101d46:	74 f8                	je     80101d40 <namex+0xb0>
80101d48:	89 34 24             	mov    %esi,(%esp)
80101d4b:	e8 70 f9 ff ff       	call   801016c0 <ilock>
80101d50:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101d55:	0f 85 85 00 00 00    	jne    80101de0 <namex+0x150>
80101d5b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101d5e:	85 c0                	test   %eax,%eax
80101d60:	74 09                	je     80101d6b <namex+0xdb>
80101d62:	80 3b 00             	cmpb   $0x0,(%ebx)
80101d65:	0f 84 a5 00 00 00    	je     80101e10 <namex+0x180>
80101d6b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80101d72:	00 
80101d73:	89 7c 24 04          	mov    %edi,0x4(%esp)
80101d77:	89 34 24             	mov    %esi,(%esp)
80101d7a:	e8 51 fe ff ff       	call   80101bd0 <dirlookup>
80101d7f:	85 c0                	test   %eax,%eax
80101d81:	74 5d                	je     80101de0 <namex+0x150>
80101d83:	89 34 24             	mov    %esi,(%esp)
80101d86:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101d89:	e8 12 fa ff ff       	call   801017a0 <iunlock>
80101d8e:	89 34 24             	mov    %esi,(%esp)
80101d91:	e8 4a fa ff ff       	call   801017e0 <iput>
80101d96:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d99:	89 c6                	mov    %eax,%esi
80101d9b:	e9 33 ff ff ff       	jmp    80101cd3 <namex+0x43>
80101da0:	31 c9                	xor    %ecx,%ecx
80101da2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101da8:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80101dac:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101db0:	89 3c 24             	mov    %edi,(%esp)
80101db3:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101db6:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101db9:	e8 62 25 00 00       	call   80104320 <memmove>
80101dbe:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101dc1:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101dc4:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101dc8:	89 d3                	mov    %edx,%ebx
80101dca:	e9 66 ff ff ff       	jmp    80101d35 <namex+0xa5>
80101dcf:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101dd2:	85 c0                	test   %eax,%eax
80101dd4:	75 4c                	jne    80101e22 <namex+0x192>
80101dd6:	89 f0                	mov    %esi,%eax
80101dd8:	83 c4 2c             	add    $0x2c,%esp
80101ddb:	5b                   	pop    %ebx
80101ddc:	5e                   	pop    %esi
80101ddd:	5f                   	pop    %edi
80101dde:	5d                   	pop    %ebp
80101ddf:	c3                   	ret    
80101de0:	89 34 24             	mov    %esi,(%esp)
80101de3:	e8 b8 f9 ff ff       	call   801017a0 <iunlock>
80101de8:	89 34 24             	mov    %esi,(%esp)
80101deb:	e8 f0 f9 ff ff       	call   801017e0 <iput>
80101df0:	83 c4 2c             	add    $0x2c,%esp
80101df3:	31 c0                	xor    %eax,%eax
80101df5:	5b                   	pop    %ebx
80101df6:	5e                   	pop    %esi
80101df7:	5f                   	pop    %edi
80101df8:	5d                   	pop    %ebp
80101df9:	c3                   	ret    
80101dfa:	ba 01 00 00 00       	mov    $0x1,%edx
80101dff:	b8 01 00 00 00       	mov    $0x1,%eax
80101e04:	e8 17 f4 ff ff       	call   80101220 <iget>
80101e09:	89 c6                	mov    %eax,%esi
80101e0b:	e9 c3 fe ff ff       	jmp    80101cd3 <namex+0x43>
80101e10:	89 34 24             	mov    %esi,(%esp)
80101e13:	e8 88 f9 ff ff       	call   801017a0 <iunlock>
80101e18:	83 c4 2c             	add    $0x2c,%esp
80101e1b:	89 f0                	mov    %esi,%eax
80101e1d:	5b                   	pop    %ebx
80101e1e:	5e                   	pop    %esi
80101e1f:	5f                   	pop    %edi
80101e20:	5d                   	pop    %ebp
80101e21:	c3                   	ret    
80101e22:	89 34 24             	mov    %esi,(%esp)
80101e25:	e8 b6 f9 ff ff       	call   801017e0 <iput>
80101e2a:	31 c0                	xor    %eax,%eax
80101e2c:	eb aa                	jmp    80101dd8 <namex+0x148>
80101e2e:	66 90                	xchg   %ax,%ax

80101e30 <dirlink>:
80101e30:	55                   	push   %ebp
80101e31:	89 e5                	mov    %esp,%ebp
80101e33:	57                   	push   %edi
80101e34:	56                   	push   %esi
80101e35:	53                   	push   %ebx
80101e36:	83 ec 2c             	sub    $0x2c,%esp
80101e39:	8b 5d 08             	mov    0x8(%ebp),%ebx
80101e3c:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e3f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80101e46:	00 
80101e47:	89 1c 24             	mov    %ebx,(%esp)
80101e4a:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e4e:	e8 7d fd ff ff       	call   80101bd0 <dirlookup>
80101e53:	85 c0                	test   %eax,%eax
80101e55:	0f 85 8b 00 00 00    	jne    80101ee6 <dirlink+0xb6>
80101e5b:	8b 53 58             	mov    0x58(%ebx),%edx
80101e5e:	31 ff                	xor    %edi,%edi
80101e60:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e63:	85 d2                	test   %edx,%edx
80101e65:	75 13                	jne    80101e7a <dirlink+0x4a>
80101e67:	eb 35                	jmp    80101e9e <dirlink+0x6e>
80101e69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e70:	8d 57 10             	lea    0x10(%edi),%edx
80101e73:	39 53 58             	cmp    %edx,0x58(%ebx)
80101e76:	89 d7                	mov    %edx,%edi
80101e78:	76 24                	jbe    80101e9e <dirlink+0x6e>
80101e7a:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101e81:	00 
80101e82:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101e86:	89 74 24 04          	mov    %esi,0x4(%esp)
80101e8a:	89 1c 24             	mov    %ebx,(%esp)
80101e8d:	e8 de fa ff ff       	call   80101970 <readi>
80101e92:	83 f8 10             	cmp    $0x10,%eax
80101e95:	75 5e                	jne    80101ef5 <dirlink+0xc5>
80101e97:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e9c:	75 d2                	jne    80101e70 <dirlink+0x40>
80101e9e:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ea1:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101ea8:	00 
80101ea9:	89 44 24 04          	mov    %eax,0x4(%esp)
80101ead:	8d 45 da             	lea    -0x26(%ebp),%eax
80101eb0:	89 04 24             	mov    %eax,(%esp)
80101eb3:	e8 58 25 00 00       	call   80104410 <strncpy>
80101eb8:	8b 45 10             	mov    0x10(%ebp),%eax
80101ebb:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101ec2:	00 
80101ec3:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101ec7:	89 74 24 04          	mov    %esi,0x4(%esp)
80101ecb:	89 1c 24             	mov    %ebx,(%esp)
80101ece:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
80101ed2:	e8 99 fb ff ff       	call   80101a70 <writei>
80101ed7:	83 f8 10             	cmp    $0x10,%eax
80101eda:	75 25                	jne    80101f01 <dirlink+0xd1>
80101edc:	31 c0                	xor    %eax,%eax
80101ede:	83 c4 2c             	add    $0x2c,%esp
80101ee1:	5b                   	pop    %ebx
80101ee2:	5e                   	pop    %esi
80101ee3:	5f                   	pop    %edi
80101ee4:	5d                   	pop    %ebp
80101ee5:	c3                   	ret    
80101ee6:	89 04 24             	mov    %eax,(%esp)
80101ee9:	e8 f2 f8 ff ff       	call   801017e0 <iput>
80101eee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ef3:	eb e9                	jmp    80101ede <dirlink+0xae>
80101ef5:	c7 04 24 a8 6d 10 80 	movl   $0x80106da8,(%esp)
80101efc:	e8 5f e4 ff ff       	call   80100360 <panic>
80101f01:	c7 04 24 62 74 10 80 	movl   $0x80107462,(%esp)
80101f08:	e8 53 e4 ff ff       	call   80100360 <panic>
80101f0d:	8d 76 00             	lea    0x0(%esi),%esi

80101f10 <namei>:
80101f10:	55                   	push   %ebp
80101f11:	31 d2                	xor    %edx,%edx
80101f13:	89 e5                	mov    %esp,%ebp
80101f15:	83 ec 18             	sub    $0x18,%esp
80101f18:	8b 45 08             	mov    0x8(%ebp),%eax
80101f1b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101f1e:	e8 6d fd ff ff       	call   80101c90 <namex>
80101f23:	c9                   	leave  
80101f24:	c3                   	ret    
80101f25:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f30 <nameiparent>:
80101f30:	55                   	push   %ebp
80101f31:	ba 01 00 00 00       	mov    $0x1,%edx
80101f36:	89 e5                	mov    %esp,%ebp
80101f38:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101f3b:	8b 45 08             	mov    0x8(%ebp),%eax
80101f3e:	5d                   	pop    %ebp
80101f3f:	e9 4c fd ff ff       	jmp    80101c90 <namex>
	...

80101f50 <idestart>:
80101f50:	55                   	push   %ebp
80101f51:	89 e5                	mov    %esp,%ebp
80101f53:	56                   	push   %esi
80101f54:	89 c6                	mov    %eax,%esi
80101f56:	83 ec 14             	sub    $0x14,%esp
80101f59:	85 c0                	test   %eax,%eax
80101f5b:	0f 84 99 00 00 00    	je     80101ffa <idestart+0xaa>
80101f61:	8b 48 08             	mov    0x8(%eax),%ecx
80101f64:	81 f9 e7 03 00 00    	cmp    $0x3e7,%ecx
80101f6a:	0f 87 7e 00 00 00    	ja     80101fee <idestart+0x9e>
80101f70:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101f75:	8d 76 00             	lea    0x0(%esi),%esi
80101f78:	ec                   	in     (%dx),%al
80101f79:	83 e0 c0             	and    $0xffffffc0,%eax
80101f7c:	3c 40                	cmp    $0x40,%al
80101f7e:	75 f8                	jne    80101f78 <idestart+0x28>
80101f80:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101f85:	31 c0                	xor    %eax,%eax
80101f87:	ee                   	out    %al,(%dx)
80101f88:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101f8d:	b8 01 00 00 00       	mov    $0x1,%eax
80101f92:	ee                   	out    %al,(%dx)
80101f93:	0f b6 c1             	movzbl %cl,%eax
80101f96:	b2 f3                	mov    $0xf3,%dl
80101f98:	ee                   	out    %al,(%dx)
80101f99:	89 c8                	mov    %ecx,%eax
80101f9b:	b2 f4                	mov    $0xf4,%dl
80101f9d:	c1 f8 08             	sar    $0x8,%eax
80101fa0:	ee                   	out    %al,(%dx)
80101fa1:	31 c0                	xor    %eax,%eax
80101fa3:	b2 f5                	mov    $0xf5,%dl
80101fa5:	ee                   	out    %al,(%dx)
80101fa6:	0f b6 46 04          	movzbl 0x4(%esi),%eax
80101faa:	b2 f6                	mov    $0xf6,%dl
80101fac:	83 e0 01             	and    $0x1,%eax
80101faf:	c1 e0 04             	shl    $0x4,%eax
80101fb2:	83 c8 e0             	or     $0xffffffe0,%eax
80101fb5:	ee                   	out    %al,(%dx)
80101fb6:	f6 06 04             	testb  $0x4,(%esi)
80101fb9:	75 15                	jne    80101fd0 <idestart+0x80>
80101fbb:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101fc0:	b8 20 00 00 00       	mov    $0x20,%eax
80101fc5:	ee                   	out    %al,(%dx)
80101fc6:	83 c4 14             	add    $0x14,%esp
80101fc9:	5e                   	pop    %esi
80101fca:	5d                   	pop    %ebp
80101fcb:	c3                   	ret    
80101fcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101fd0:	b2 f7                	mov    $0xf7,%dl
80101fd2:	b8 30 00 00 00       	mov    $0x30,%eax
80101fd7:	ee                   	out    %al,(%dx)
80101fd8:	b9 80 00 00 00       	mov    $0x80,%ecx
80101fdd:	83 c6 5c             	add    $0x5c,%esi
80101fe0:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101fe5:	fc                   	cld    
80101fe6:	f3 6f                	rep outsl %ds:(%esi),(%dx)
80101fe8:	83 c4 14             	add    $0x14,%esp
80101feb:	5e                   	pop    %esi
80101fec:	5d                   	pop    %ebp
80101fed:	c3                   	ret    
80101fee:	c7 04 24 14 6e 10 80 	movl   $0x80106e14,(%esp)
80101ff5:	e8 66 e3 ff ff       	call   80100360 <panic>
80101ffa:	c7 04 24 0b 6e 10 80 	movl   $0x80106e0b,(%esp)
80102001:	e8 5a e3 ff ff       	call   80100360 <panic>
80102006:	8d 76 00             	lea    0x0(%esi),%esi
80102009:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102010 <ideinit>:
80102010:	55                   	push   %ebp
80102011:	89 e5                	mov    %esp,%ebp
80102013:	83 ec 18             	sub    $0x18,%esp
80102016:	c7 44 24 04 26 6e 10 	movl   $0x80106e26,0x4(%esp)
8010201d:	80 
8010201e:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
80102025:	e8 26 20 00 00       	call   80104050 <initlock>
8010202a:	a1 00 2d 11 80       	mov    0x80112d00,%eax
8010202f:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
80102036:	83 e8 01             	sub    $0x1,%eax
80102039:	89 44 24 04          	mov    %eax,0x4(%esp)
8010203d:	e8 7e 02 00 00       	call   801022c0 <ioapicenable>
80102042:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102047:	90                   	nop
80102048:	ec                   	in     (%dx),%al
80102049:	83 e0 c0             	and    $0xffffffc0,%eax
8010204c:	3c 40                	cmp    $0x40,%al
8010204e:	75 f8                	jne    80102048 <ideinit+0x38>
80102050:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102055:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010205a:	ee                   	out    %al,(%dx)
8010205b:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
80102060:	b2 f7                	mov    $0xf7,%dl
80102062:	eb 09                	jmp    8010206d <ideinit+0x5d>
80102064:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102068:	83 e9 01             	sub    $0x1,%ecx
8010206b:	74 0f                	je     8010207c <ideinit+0x6c>
8010206d:	ec                   	in     (%dx),%al
8010206e:	84 c0                	test   %al,%al
80102070:	74 f6                	je     80102068 <ideinit+0x58>
80102072:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
80102079:	00 00 00 
8010207c:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102081:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102086:	ee                   	out    %al,(%dx)
80102087:	c9                   	leave  
80102088:	c3                   	ret    
80102089:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102090 <ideintr>:
80102090:	55                   	push   %ebp
80102091:	89 e5                	mov    %esp,%ebp
80102093:	57                   	push   %edi
80102094:	56                   	push   %esi
80102095:	53                   	push   %ebx
80102096:	83 ec 1c             	sub    $0x1c,%esp
80102099:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
801020a0:	e8 9b 20 00 00       	call   80104140 <acquire>
801020a5:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
801020ab:	85 db                	test   %ebx,%ebx
801020ad:	74 30                	je     801020df <ideintr+0x4f>
801020af:	8b 43 58             	mov    0x58(%ebx),%eax
801020b2:	a3 64 a5 10 80       	mov    %eax,0x8010a564
801020b7:	8b 33                	mov    (%ebx),%esi
801020b9:	f7 c6 04 00 00 00    	test   $0x4,%esi
801020bf:	74 37                	je     801020f8 <ideintr+0x68>
801020c1:	83 e6 fb             	and    $0xfffffffb,%esi
801020c4:	83 ce 02             	or     $0x2,%esi
801020c7:	89 33                	mov    %esi,(%ebx)
801020c9:	89 1c 24             	mov    %ebx,(%esp)
801020cc:	e8 bf 1c 00 00       	call   80103d90 <wakeup>
801020d1:	a1 64 a5 10 80       	mov    0x8010a564,%eax
801020d6:	85 c0                	test   %eax,%eax
801020d8:	74 05                	je     801020df <ideintr+0x4f>
801020da:	e8 71 fe ff ff       	call   80101f50 <idestart>
801020df:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
801020e6:	e8 45 21 00 00       	call   80104230 <release>
801020eb:	83 c4 1c             	add    $0x1c,%esp
801020ee:	5b                   	pop    %ebx
801020ef:	5e                   	pop    %esi
801020f0:	5f                   	pop    %edi
801020f1:	5d                   	pop    %ebp
801020f2:	c3                   	ret    
801020f3:	90                   	nop
801020f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801020f8:	ba f7 01 00 00       	mov    $0x1f7,%edx
801020fd:	8d 76 00             	lea    0x0(%esi),%esi
80102100:	ec                   	in     (%dx),%al
80102101:	89 c1                	mov    %eax,%ecx
80102103:	83 e1 c0             	and    $0xffffffc0,%ecx
80102106:	80 f9 40             	cmp    $0x40,%cl
80102109:	75 f5                	jne    80102100 <ideintr+0x70>
8010210b:	a8 21                	test   $0x21,%al
8010210d:	75 b2                	jne    801020c1 <ideintr+0x31>
8010210f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
80102112:	b9 80 00 00 00       	mov    $0x80,%ecx
80102117:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010211c:	fc                   	cld    
8010211d:	f3 6d                	rep insl (%dx),%es:(%edi)
8010211f:	8b 33                	mov    (%ebx),%esi
80102121:	eb 9e                	jmp    801020c1 <ideintr+0x31>
80102123:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102129:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102130 <iderw>:
80102130:	55                   	push   %ebp
80102131:	89 e5                	mov    %esp,%ebp
80102133:	53                   	push   %ebx
80102134:	83 ec 14             	sub    $0x14,%esp
80102137:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010213a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010213d:	89 04 24             	mov    %eax,(%esp)
80102140:	e8 db 1e 00 00       	call   80104020 <holdingsleep>
80102145:	85 c0                	test   %eax,%eax
80102147:	0f 84 9e 00 00 00    	je     801021eb <iderw+0xbb>
8010214d:	8b 03                	mov    (%ebx),%eax
8010214f:	83 e0 06             	and    $0x6,%eax
80102152:	83 f8 02             	cmp    $0x2,%eax
80102155:	0f 84 a8 00 00 00    	je     80102203 <iderw+0xd3>
8010215b:	8b 53 04             	mov    0x4(%ebx),%edx
8010215e:	85 d2                	test   %edx,%edx
80102160:	74 0d                	je     8010216f <iderw+0x3f>
80102162:	a1 60 a5 10 80       	mov    0x8010a560,%eax
80102167:	85 c0                	test   %eax,%eax
80102169:	0f 84 88 00 00 00    	je     801021f7 <iderw+0xc7>
8010216f:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
80102176:	e8 c5 1f 00 00       	call   80104140 <acquire>
8010217b:	a1 64 a5 10 80       	mov    0x8010a564,%eax
80102180:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
80102187:	85 c0                	test   %eax,%eax
80102189:	75 07                	jne    80102192 <iderw+0x62>
8010218b:	eb 4e                	jmp    801021db <iderw+0xab>
8010218d:	8d 76 00             	lea    0x0(%esi),%esi
80102190:	89 d0                	mov    %edx,%eax
80102192:	8b 50 58             	mov    0x58(%eax),%edx
80102195:	85 d2                	test   %edx,%edx
80102197:	75 f7                	jne    80102190 <iderw+0x60>
80102199:	83 c0 58             	add    $0x58,%eax
8010219c:	89 18                	mov    %ebx,(%eax)
8010219e:	39 1d 64 a5 10 80    	cmp    %ebx,0x8010a564
801021a4:	74 3c                	je     801021e2 <iderw+0xb2>
801021a6:	8b 03                	mov    (%ebx),%eax
801021a8:	83 e0 06             	and    $0x6,%eax
801021ab:	83 f8 02             	cmp    $0x2,%eax
801021ae:	74 1a                	je     801021ca <iderw+0x9a>
801021b0:	c7 44 24 04 80 a5 10 	movl   $0x8010a580,0x4(%esp)
801021b7:	80 
801021b8:	89 1c 24             	mov    %ebx,(%esp)
801021bb:	e8 40 1a 00 00       	call   80103c00 <sleep>
801021c0:	8b 13                	mov    (%ebx),%edx
801021c2:	83 e2 06             	and    $0x6,%edx
801021c5:	83 fa 02             	cmp    $0x2,%edx
801021c8:	75 e6                	jne    801021b0 <iderw+0x80>
801021ca:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
801021d1:	83 c4 14             	add    $0x14,%esp
801021d4:	5b                   	pop    %ebx
801021d5:	5d                   	pop    %ebp
801021d6:	e9 55 20 00 00       	jmp    80104230 <release>
801021db:	b8 64 a5 10 80       	mov    $0x8010a564,%eax
801021e0:	eb ba                	jmp    8010219c <iderw+0x6c>
801021e2:	89 d8                	mov    %ebx,%eax
801021e4:	e8 67 fd ff ff       	call   80101f50 <idestart>
801021e9:	eb bb                	jmp    801021a6 <iderw+0x76>
801021eb:	c7 04 24 2a 6e 10 80 	movl   $0x80106e2a,(%esp)
801021f2:	e8 69 e1 ff ff       	call   80100360 <panic>
801021f7:	c7 04 24 55 6e 10 80 	movl   $0x80106e55,(%esp)
801021fe:	e8 5d e1 ff ff       	call   80100360 <panic>
80102203:	c7 04 24 40 6e 10 80 	movl   $0x80106e40,(%esp)
8010220a:	e8 51 e1 ff ff       	call   80100360 <panic>
	...

80102210 <ioapicinit>:
80102210:	55                   	push   %ebp
80102211:	89 e5                	mov    %esp,%ebp
80102213:	56                   	push   %esi
80102214:	53                   	push   %ebx
80102215:	83 ec 10             	sub    $0x10,%esp
80102218:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
8010221f:	00 c0 fe 
80102222:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102229:	00 00 00 
8010222c:	8b 15 34 26 11 80    	mov    0x80112634,%edx
80102232:	8b 42 10             	mov    0x10(%edx),%eax
80102235:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
8010223b:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
80102241:	0f b6 15 60 27 11 80 	movzbl 0x80112760,%edx
80102248:	c1 e8 10             	shr    $0x10,%eax
8010224b:	0f b6 f0             	movzbl %al,%esi
8010224e:	8b 43 10             	mov    0x10(%ebx),%eax
80102251:	c1 e8 18             	shr    $0x18,%eax
80102254:	39 c2                	cmp    %eax,%edx
80102256:	74 12                	je     8010226a <ioapicinit+0x5a>
80102258:	c7 04 24 74 6e 10 80 	movl   $0x80106e74,(%esp)
8010225f:	e8 ec e3 ff ff       	call   80100650 <cprintf>
80102264:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
8010226a:	ba 10 00 00 00       	mov    $0x10,%edx
8010226f:	31 c0                	xor    %eax,%eax
80102271:	eb 07                	jmp    8010227a <ioapicinit+0x6a>
80102273:	90                   	nop
80102274:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102278:	89 cb                	mov    %ecx,%ebx
8010227a:	89 13                	mov    %edx,(%ebx)
8010227c:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
80102282:	8d 48 20             	lea    0x20(%eax),%ecx
80102285:	81 c9 00 00 01 00    	or     $0x10000,%ecx
8010228b:	83 c0 01             	add    $0x1,%eax
8010228e:	89 4b 10             	mov    %ecx,0x10(%ebx)
80102291:	8d 4a 01             	lea    0x1(%edx),%ecx
80102294:	83 c2 02             	add    $0x2,%edx
80102297:	89 0b                	mov    %ecx,(%ebx)
80102299:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
8010229f:	39 c6                	cmp    %eax,%esi
801022a1:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
801022a8:	7d ce                	jge    80102278 <ioapicinit+0x68>
801022aa:	83 c4 10             	add    $0x10,%esp
801022ad:	5b                   	pop    %ebx
801022ae:	5e                   	pop    %esi
801022af:	5d                   	pop    %ebp
801022b0:	c3                   	ret    
801022b1:	eb 0d                	jmp    801022c0 <ioapicenable>
801022b3:	90                   	nop
801022b4:	90                   	nop
801022b5:	90                   	nop
801022b6:	90                   	nop
801022b7:	90                   	nop
801022b8:	90                   	nop
801022b9:	90                   	nop
801022ba:	90                   	nop
801022bb:	90                   	nop
801022bc:	90                   	nop
801022bd:	90                   	nop
801022be:	90                   	nop
801022bf:	90                   	nop

801022c0 <ioapicenable>:
801022c0:	55                   	push   %ebp
801022c1:	89 e5                	mov    %esp,%ebp
801022c3:	8b 55 08             	mov    0x8(%ebp),%edx
801022c6:	53                   	push   %ebx
801022c7:	8b 45 0c             	mov    0xc(%ebp),%eax
801022ca:	8d 5a 20             	lea    0x20(%edx),%ebx
801022cd:	8d 4c 12 10          	lea    0x10(%edx,%edx,1),%ecx
801022d1:	8b 15 34 26 11 80    	mov    0x80112634,%edx
801022d7:	c1 e0 18             	shl    $0x18,%eax
801022da:	89 0a                	mov    %ecx,(%edx)
801022dc:	8b 15 34 26 11 80    	mov    0x80112634,%edx
801022e2:	83 c1 01             	add    $0x1,%ecx
801022e5:	89 5a 10             	mov    %ebx,0x10(%edx)
801022e8:	89 0a                	mov    %ecx,(%edx)
801022ea:	8b 15 34 26 11 80    	mov    0x80112634,%edx
801022f0:	89 42 10             	mov    %eax,0x10(%edx)
801022f3:	5b                   	pop    %ebx
801022f4:	5d                   	pop    %ebp
801022f5:	c3                   	ret    
	...

80102300 <kfree>:
80102300:	55                   	push   %ebp
80102301:	89 e5                	mov    %esp,%ebp
80102303:	53                   	push   %ebx
80102304:	83 ec 14             	sub    $0x14,%esp
80102307:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010230a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102310:	75 7c                	jne    8010238e <kfree+0x8e>
80102312:	81 fb a8 54 11 80    	cmp    $0x801154a8,%ebx
80102318:	72 74                	jb     8010238e <kfree+0x8e>
8010231a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102320:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102325:	77 67                	ja     8010238e <kfree+0x8e>
80102327:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010232e:	00 
8010232f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102336:	00 
80102337:	89 1c 24             	mov    %ebx,(%esp)
8010233a:	e8 41 1f 00 00       	call   80104280 <memset>
8010233f:	8b 15 74 26 11 80    	mov    0x80112674,%edx
80102345:	85 d2                	test   %edx,%edx
80102347:	75 37                	jne    80102380 <kfree+0x80>
80102349:	a1 78 26 11 80       	mov    0x80112678,%eax
8010234e:	89 03                	mov    %eax,(%ebx)
80102350:	a1 74 26 11 80       	mov    0x80112674,%eax
80102355:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
8010235b:	85 c0                	test   %eax,%eax
8010235d:	75 09                	jne    80102368 <kfree+0x68>
8010235f:	83 c4 14             	add    $0x14,%esp
80102362:	5b                   	pop    %ebx
80102363:	5d                   	pop    %ebp
80102364:	c3                   	ret    
80102365:	8d 76 00             	lea    0x0(%esi),%esi
80102368:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
8010236f:	83 c4 14             	add    $0x14,%esp
80102372:	5b                   	pop    %ebx
80102373:	5d                   	pop    %ebp
80102374:	e9 b7 1e 00 00       	jmp    80104230 <release>
80102379:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102380:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
80102387:	e8 b4 1d 00 00       	call   80104140 <acquire>
8010238c:	eb bb                	jmp    80102349 <kfree+0x49>
8010238e:	c7 04 24 a6 6e 10 80 	movl   $0x80106ea6,(%esp)
80102395:	e8 c6 df ff ff       	call   80100360 <panic>
8010239a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801023a0 <freerange>:
801023a0:	55                   	push   %ebp
801023a1:	89 e5                	mov    %esp,%ebp
801023a3:	56                   	push   %esi
801023a4:	53                   	push   %ebx
801023a5:	83 ec 10             	sub    $0x10,%esp
801023a8:	8b 45 08             	mov    0x8(%ebp),%eax
801023ab:	8b 75 0c             	mov    0xc(%ebp),%esi
801023ae:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
801023b4:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
801023ba:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
801023c0:	39 de                	cmp    %ebx,%esi
801023c2:	73 08                	jae    801023cc <freerange+0x2c>
801023c4:	eb 18                	jmp    801023de <freerange+0x3e>
801023c6:	66 90                	xchg   %ax,%ax
801023c8:	89 da                	mov    %ebx,%edx
801023ca:	89 c3                	mov    %eax,%ebx
801023cc:	89 14 24             	mov    %edx,(%esp)
801023cf:	e8 2c ff ff ff       	call   80102300 <kfree>
801023d4:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
801023da:	39 f0                	cmp    %esi,%eax
801023dc:	76 ea                	jbe    801023c8 <freerange+0x28>
801023de:	83 c4 10             	add    $0x10,%esp
801023e1:	5b                   	pop    %ebx
801023e2:	5e                   	pop    %esi
801023e3:	5d                   	pop    %ebp
801023e4:	c3                   	ret    
801023e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801023e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801023f0 <kinit1>:
801023f0:	55                   	push   %ebp
801023f1:	89 e5                	mov    %esp,%ebp
801023f3:	56                   	push   %esi
801023f4:	53                   	push   %ebx
801023f5:	83 ec 10             	sub    $0x10,%esp
801023f8:	8b 75 0c             	mov    0xc(%ebp),%esi
801023fb:	c7 44 24 04 ac 6e 10 	movl   $0x80106eac,0x4(%esp)
80102402:	80 
80102403:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
8010240a:	e8 41 1c 00 00       	call   80104050 <initlock>
8010240f:	8b 45 08             	mov    0x8(%ebp),%eax
80102412:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
80102419:	00 00 00 
8010241c:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80102422:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80102428:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
8010242e:	39 de                	cmp    %ebx,%esi
80102430:	73 0a                	jae    8010243c <kinit1+0x4c>
80102432:	eb 1a                	jmp    8010244e <kinit1+0x5e>
80102434:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102438:	89 da                	mov    %ebx,%edx
8010243a:	89 c3                	mov    %eax,%ebx
8010243c:	89 14 24             	mov    %edx,(%esp)
8010243f:	e8 bc fe ff ff       	call   80102300 <kfree>
80102444:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
8010244a:	39 c6                	cmp    %eax,%esi
8010244c:	73 ea                	jae    80102438 <kinit1+0x48>
8010244e:	83 c4 10             	add    $0x10,%esp
80102451:	5b                   	pop    %ebx
80102452:	5e                   	pop    %esi
80102453:	5d                   	pop    %ebp
80102454:	c3                   	ret    
80102455:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102459:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102460 <kinit2>:
80102460:	55                   	push   %ebp
80102461:	89 e5                	mov    %esp,%ebp
80102463:	56                   	push   %esi
80102464:	53                   	push   %ebx
80102465:	83 ec 10             	sub    $0x10,%esp
80102468:	8b 45 08             	mov    0x8(%ebp),%eax
8010246b:	8b 75 0c             	mov    0xc(%ebp),%esi
8010246e:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80102474:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
8010247a:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
80102480:	39 de                	cmp    %ebx,%esi
80102482:	73 08                	jae    8010248c <kinit2+0x2c>
80102484:	eb 18                	jmp    8010249e <kinit2+0x3e>
80102486:	66 90                	xchg   %ax,%ax
80102488:	89 da                	mov    %ebx,%edx
8010248a:	89 c3                	mov    %eax,%ebx
8010248c:	89 14 24             	mov    %edx,(%esp)
8010248f:	e8 6c fe ff ff       	call   80102300 <kfree>
80102494:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
8010249a:	39 c6                	cmp    %eax,%esi
8010249c:	73 ea                	jae    80102488 <kinit2+0x28>
8010249e:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
801024a5:	00 00 00 
801024a8:	83 c4 10             	add    $0x10,%esp
801024ab:	5b                   	pop    %ebx
801024ac:	5e                   	pop    %esi
801024ad:	5d                   	pop    %ebp
801024ae:	c3                   	ret    
801024af:	90                   	nop

801024b0 <kalloc>:
801024b0:	55                   	push   %ebp
801024b1:	89 e5                	mov    %esp,%ebp
801024b3:	53                   	push   %ebx
801024b4:	83 ec 14             	sub    $0x14,%esp
801024b7:	a1 74 26 11 80       	mov    0x80112674,%eax
801024bc:	85 c0                	test   %eax,%eax
801024be:	75 30                	jne    801024f0 <kalloc+0x40>
801024c0:	8b 1d 78 26 11 80    	mov    0x80112678,%ebx
801024c6:	85 db                	test   %ebx,%ebx
801024c8:	74 08                	je     801024d2 <kalloc+0x22>
801024ca:	8b 13                	mov    (%ebx),%edx
801024cc:	89 15 78 26 11 80    	mov    %edx,0x80112678
801024d2:	85 c0                	test   %eax,%eax
801024d4:	74 0c                	je     801024e2 <kalloc+0x32>
801024d6:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
801024dd:	e8 4e 1d 00 00       	call   80104230 <release>
801024e2:	83 c4 14             	add    $0x14,%esp
801024e5:	89 d8                	mov    %ebx,%eax
801024e7:	5b                   	pop    %ebx
801024e8:	5d                   	pop    %ebp
801024e9:	c3                   	ret    
801024ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801024f0:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
801024f7:	e8 44 1c 00 00       	call   80104140 <acquire>
801024fc:	a1 74 26 11 80       	mov    0x80112674,%eax
80102501:	eb bd                	jmp    801024c0 <kalloc+0x10>
	...

80102510 <kbdgetc>:
80102510:	ba 64 00 00 00       	mov    $0x64,%edx
80102515:	ec                   	in     (%dx),%al
80102516:	a8 01                	test   $0x1,%al
80102518:	0f 84 ba 00 00 00    	je     801025d8 <kbdgetc+0xc8>
8010251e:	b2 60                	mov    $0x60,%dl
80102520:	ec                   	in     (%dx),%al
80102521:	0f b6 c8             	movzbl %al,%ecx
80102524:	81 f9 e0 00 00 00    	cmp    $0xe0,%ecx
8010252a:	0f 84 88 00 00 00    	je     801025b8 <kbdgetc+0xa8>
80102530:	84 c0                	test   %al,%al
80102532:	79 2c                	jns    80102560 <kbdgetc+0x50>
80102534:	8b 15 b4 a5 10 80    	mov    0x8010a5b4,%edx
8010253a:	f6 c2 40             	test   $0x40,%dl
8010253d:	75 05                	jne    80102544 <kbdgetc+0x34>
8010253f:	89 c1                	mov    %eax,%ecx
80102541:	83 e1 7f             	and    $0x7f,%ecx
80102544:	0f b6 81 e0 6f 10 80 	movzbl -0x7fef9020(%ecx),%eax
8010254b:	83 c8 40             	or     $0x40,%eax
8010254e:	0f b6 c0             	movzbl %al,%eax
80102551:	f7 d0                	not    %eax
80102553:	21 d0                	and    %edx,%eax
80102555:	a3 b4 a5 10 80       	mov    %eax,0x8010a5b4
8010255a:	31 c0                	xor    %eax,%eax
8010255c:	c3                   	ret    
8010255d:	8d 76 00             	lea    0x0(%esi),%esi
80102560:	55                   	push   %ebp
80102561:	89 e5                	mov    %esp,%ebp
80102563:	53                   	push   %ebx
80102564:	8b 1d b4 a5 10 80    	mov    0x8010a5b4,%ebx
8010256a:	f6 c3 40             	test   $0x40,%bl
8010256d:	74 09                	je     80102578 <kbdgetc+0x68>
8010256f:	83 c8 80             	or     $0xffffff80,%eax
80102572:	83 e3 bf             	and    $0xffffffbf,%ebx
80102575:	0f b6 c8             	movzbl %al,%ecx
80102578:	0f b6 91 e0 6f 10 80 	movzbl -0x7fef9020(%ecx),%edx
8010257f:	0f b6 81 e0 6e 10 80 	movzbl -0x7fef9120(%ecx),%eax
80102586:	09 da                	or     %ebx,%edx
80102588:	31 c2                	xor    %eax,%edx
8010258a:	89 d0                	mov    %edx,%eax
8010258c:	83 e0 03             	and    $0x3,%eax
8010258f:	8b 04 85 c0 6e 10 80 	mov    -0x7fef9140(,%eax,4),%eax
80102596:	89 15 b4 a5 10 80    	mov    %edx,0x8010a5b4
8010259c:	83 e2 08             	and    $0x8,%edx
8010259f:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
801025a3:	74 0b                	je     801025b0 <kbdgetc+0xa0>
801025a5:	8d 50 9f             	lea    -0x61(%eax),%edx
801025a8:	83 fa 19             	cmp    $0x19,%edx
801025ab:	77 1b                	ja     801025c8 <kbdgetc+0xb8>
801025ad:	83 e8 20             	sub    $0x20,%eax
801025b0:	5b                   	pop    %ebx
801025b1:	5d                   	pop    %ebp
801025b2:	c3                   	ret    
801025b3:	90                   	nop
801025b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801025b8:	83 0d b4 a5 10 80 40 	orl    $0x40,0x8010a5b4
801025bf:	31 c0                	xor    %eax,%eax
801025c1:	c3                   	ret    
801025c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801025c8:	8d 48 bf             	lea    -0x41(%eax),%ecx
801025cb:	8d 50 20             	lea    0x20(%eax),%edx
801025ce:	83 f9 19             	cmp    $0x19,%ecx
801025d1:	0f 46 c2             	cmovbe %edx,%eax
801025d4:	eb da                	jmp    801025b0 <kbdgetc+0xa0>
801025d6:	66 90                	xchg   %ax,%ax
801025d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801025dd:	c3                   	ret    
801025de:	66 90                	xchg   %ax,%ax

801025e0 <kbdintr>:
801025e0:	55                   	push   %ebp
801025e1:	89 e5                	mov    %esp,%ebp
801025e3:	83 ec 18             	sub    $0x18,%esp
801025e6:	c7 04 24 10 25 10 80 	movl   $0x80102510,(%esp)
801025ed:	e8 be e1 ff ff       	call   801007b0 <consoleintr>
801025f2:	c9                   	leave  
801025f3:	c3                   	ret    
	...

80102600 <fill_rtcdate>:
80102600:	55                   	push   %ebp
80102601:	89 c1                	mov    %eax,%ecx
80102603:	89 e5                	mov    %esp,%ebp
80102605:	ba 70 00 00 00       	mov    $0x70,%edx
8010260a:	31 c0                	xor    %eax,%eax
8010260c:	ee                   	out    %al,(%dx)
8010260d:	b2 71                	mov    $0x71,%dl
8010260f:	ec                   	in     (%dx),%al
80102610:	0f b6 c0             	movzbl %al,%eax
80102613:	b2 70                	mov    $0x70,%dl
80102615:	89 01                	mov    %eax,(%ecx)
80102617:	b8 02 00 00 00       	mov    $0x2,%eax
8010261c:	ee                   	out    %al,(%dx)
8010261d:	b2 71                	mov    $0x71,%dl
8010261f:	ec                   	in     (%dx),%al
80102620:	0f b6 c0             	movzbl %al,%eax
80102623:	b2 70                	mov    $0x70,%dl
80102625:	89 41 04             	mov    %eax,0x4(%ecx)
80102628:	b8 04 00 00 00       	mov    $0x4,%eax
8010262d:	ee                   	out    %al,(%dx)
8010262e:	b2 71                	mov    $0x71,%dl
80102630:	ec                   	in     (%dx),%al
80102631:	0f b6 c0             	movzbl %al,%eax
80102634:	b2 70                	mov    $0x70,%dl
80102636:	89 41 08             	mov    %eax,0x8(%ecx)
80102639:	b8 07 00 00 00       	mov    $0x7,%eax
8010263e:	ee                   	out    %al,(%dx)
8010263f:	b2 71                	mov    $0x71,%dl
80102641:	ec                   	in     (%dx),%al
80102642:	0f b6 c0             	movzbl %al,%eax
80102645:	b2 70                	mov    $0x70,%dl
80102647:	89 41 0c             	mov    %eax,0xc(%ecx)
8010264a:	b8 08 00 00 00       	mov    $0x8,%eax
8010264f:	ee                   	out    %al,(%dx)
80102650:	b2 71                	mov    $0x71,%dl
80102652:	ec                   	in     (%dx),%al
80102653:	0f b6 c0             	movzbl %al,%eax
80102656:	b2 70                	mov    $0x70,%dl
80102658:	89 41 10             	mov    %eax,0x10(%ecx)
8010265b:	b8 09 00 00 00       	mov    $0x9,%eax
80102660:	ee                   	out    %al,(%dx)
80102661:	b2 71                	mov    $0x71,%dl
80102663:	ec                   	in     (%dx),%al
80102664:	0f b6 c0             	movzbl %al,%eax
80102667:	89 41 14             	mov    %eax,0x14(%ecx)
8010266a:	5d                   	pop    %ebp
8010266b:	c3                   	ret    
8010266c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102670 <lapicinit>:
80102670:	a1 7c 26 11 80       	mov    0x8011267c,%eax
80102675:	55                   	push   %ebp
80102676:	89 e5                	mov    %esp,%ebp
80102678:	85 c0                	test   %eax,%eax
8010267a:	0f 84 c0 00 00 00    	je     80102740 <lapicinit+0xd0>
80102680:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102687:	01 00 00 
8010268a:	8b 50 20             	mov    0x20(%eax),%edx
8010268d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102694:	00 00 00 
80102697:	8b 50 20             	mov    0x20(%eax),%edx
8010269a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801026a1:	00 02 00 
801026a4:	8b 50 20             	mov    0x20(%eax),%edx
801026a7:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801026ae:	96 98 00 
801026b1:	8b 50 20             	mov    0x20(%eax),%edx
801026b4:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801026bb:	00 01 00 
801026be:	8b 50 20             	mov    0x20(%eax),%edx
801026c1:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801026c8:	00 01 00 
801026cb:	8b 50 20             	mov    0x20(%eax),%edx
801026ce:	8b 50 30             	mov    0x30(%eax),%edx
801026d1:	c1 ea 10             	shr    $0x10,%edx
801026d4:	80 fa 03             	cmp    $0x3,%dl
801026d7:	77 6f                	ja     80102748 <lapicinit+0xd8>
801026d9:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801026e0:	00 00 00 
801026e3:	8b 50 20             	mov    0x20(%eax),%edx
801026e6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026ed:	00 00 00 
801026f0:	8b 50 20             	mov    0x20(%eax),%edx
801026f3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026fa:	00 00 00 
801026fd:	8b 50 20             	mov    0x20(%eax),%edx
80102700:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102707:	00 00 00 
8010270a:	8b 50 20             	mov    0x20(%eax),%edx
8010270d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102714:	00 00 00 
80102717:	8b 50 20             	mov    0x20(%eax),%edx
8010271a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102721:	85 08 00 
80102724:	8b 50 20             	mov    0x20(%eax),%edx
80102727:	90                   	nop
80102728:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
8010272e:	80 e6 10             	and    $0x10,%dh
80102731:	75 f5                	jne    80102728 <lapicinit+0xb8>
80102733:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
8010273a:	00 00 00 
8010273d:	8b 40 20             	mov    0x20(%eax),%eax
80102740:	5d                   	pop    %ebp
80102741:	c3                   	ret    
80102742:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102748:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
8010274f:	00 01 00 
80102752:	8b 50 20             	mov    0x20(%eax),%edx
80102755:	eb 82                	jmp    801026d9 <lapicinit+0x69>
80102757:	89 f6                	mov    %esi,%esi
80102759:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102760 <lapicid>:
80102760:	a1 7c 26 11 80       	mov    0x8011267c,%eax
80102765:	55                   	push   %ebp
80102766:	89 e5                	mov    %esp,%ebp
80102768:	85 c0                	test   %eax,%eax
8010276a:	74 0c                	je     80102778 <lapicid+0x18>
8010276c:	8b 40 20             	mov    0x20(%eax),%eax
8010276f:	5d                   	pop    %ebp
80102770:	c1 e8 18             	shr    $0x18,%eax
80102773:	c3                   	ret    
80102774:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102778:	31 c0                	xor    %eax,%eax
8010277a:	5d                   	pop    %ebp
8010277b:	c3                   	ret    
8010277c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102780 <lapiceoi>:
80102780:	a1 7c 26 11 80       	mov    0x8011267c,%eax
80102785:	55                   	push   %ebp
80102786:	89 e5                	mov    %esp,%ebp
80102788:	85 c0                	test   %eax,%eax
8010278a:	74 0d                	je     80102799 <lapiceoi+0x19>
8010278c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102793:	00 00 00 
80102796:	8b 40 20             	mov    0x20(%eax),%eax
80102799:	5d                   	pop    %ebp
8010279a:	c3                   	ret    
8010279b:	90                   	nop
8010279c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801027a0 <microdelay>:
801027a0:	55                   	push   %ebp
801027a1:	89 e5                	mov    %esp,%ebp
801027a3:	5d                   	pop    %ebp
801027a4:	c3                   	ret    
801027a5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801027a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801027b0 <lapicstartap>:
801027b0:	55                   	push   %ebp
801027b1:	ba 70 00 00 00       	mov    $0x70,%edx
801027b6:	89 e5                	mov    %esp,%ebp
801027b8:	b8 0f 00 00 00       	mov    $0xf,%eax
801027bd:	53                   	push   %ebx
801027be:	8b 4d 08             	mov    0x8(%ebp),%ecx
801027c1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801027c4:	ee                   	out    %al,(%dx)
801027c5:	b8 0a 00 00 00       	mov    $0xa,%eax
801027ca:	b2 71                	mov    $0x71,%dl
801027cc:	ee                   	out    %al,(%dx)
801027cd:	31 c0                	xor    %eax,%eax
801027cf:	66 a3 67 04 00 80    	mov    %ax,0x80000467
801027d5:	89 d8                	mov    %ebx,%eax
801027d7:	c1 e8 04             	shr    $0x4,%eax
801027da:	66 a3 69 04 00 80    	mov    %ax,0x80000469
801027e0:	a1 7c 26 11 80       	mov    0x8011267c,%eax
801027e5:	c1 e1 18             	shl    $0x18,%ecx
801027e8:	c1 eb 0c             	shr    $0xc,%ebx
801027eb:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
801027f1:	8b 50 20             	mov    0x20(%eax),%edx
801027f4:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
801027fb:	c5 00 00 
801027fe:	8b 50 20             	mov    0x20(%eax),%edx
80102801:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102808:	85 00 00 
8010280b:	8b 50 20             	mov    0x20(%eax),%edx
8010280e:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
80102814:	8b 50 20             	mov    0x20(%eax),%edx
80102817:	89 da                	mov    %ebx,%edx
80102819:	80 ce 06             	or     $0x6,%dh
8010281c:	89 90 00 03 00 00    	mov    %edx,0x300(%eax)
80102822:	8b 58 20             	mov    0x20(%eax),%ebx
80102825:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
8010282b:	8b 48 20             	mov    0x20(%eax),%ecx
8010282e:	89 90 00 03 00 00    	mov    %edx,0x300(%eax)
80102834:	8b 40 20             	mov    0x20(%eax),%eax
80102837:	5b                   	pop    %ebx
80102838:	5d                   	pop    %ebp
80102839:	c3                   	ret    
8010283a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102840 <cmostime>:
80102840:	55                   	push   %ebp
80102841:	ba 70 00 00 00       	mov    $0x70,%edx
80102846:	89 e5                	mov    %esp,%ebp
80102848:	b8 0b 00 00 00       	mov    $0xb,%eax
8010284d:	57                   	push   %edi
8010284e:	56                   	push   %esi
8010284f:	53                   	push   %ebx
80102850:	83 ec 4c             	sub    $0x4c,%esp
80102853:	ee                   	out    %al,(%dx)
80102854:	b2 71                	mov    $0x71,%dl
80102856:	ec                   	in     (%dx),%al
80102857:	88 45 b7             	mov    %al,-0x49(%ebp)
8010285a:	8d 5d b8             	lea    -0x48(%ebp),%ebx
8010285d:	80 65 b7 04          	andb   $0x4,-0x49(%ebp)
80102861:	8d 7d d0             	lea    -0x30(%ebp),%edi
80102864:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102868:	be 70 00 00 00       	mov    $0x70,%esi
8010286d:	89 d8                	mov    %ebx,%eax
8010286f:	e8 8c fd ff ff       	call   80102600 <fill_rtcdate>
80102874:	b8 0a 00 00 00       	mov    $0xa,%eax
80102879:	89 f2                	mov    %esi,%edx
8010287b:	ee                   	out    %al,(%dx)
8010287c:	ba 71 00 00 00       	mov    $0x71,%edx
80102881:	ec                   	in     (%dx),%al
80102882:	84 c0                	test   %al,%al
80102884:	78 e7                	js     8010286d <cmostime+0x2d>
80102886:	89 f8                	mov    %edi,%eax
80102888:	e8 73 fd ff ff       	call   80102600 <fill_rtcdate>
8010288d:	c7 44 24 08 18 00 00 	movl   $0x18,0x8(%esp)
80102894:	00 
80102895:	89 7c 24 04          	mov    %edi,0x4(%esp)
80102899:	89 1c 24             	mov    %ebx,(%esp)
8010289c:	e8 2f 1a 00 00       	call   801042d0 <memcmp>
801028a1:	85 c0                	test   %eax,%eax
801028a3:	75 c3                	jne    80102868 <cmostime+0x28>
801028a5:	80 7d b7 00          	cmpb   $0x0,-0x49(%ebp)
801028a9:	75 78                	jne    80102923 <cmostime+0xe3>
801028ab:	8b 45 b8             	mov    -0x48(%ebp),%eax
801028ae:	89 c2                	mov    %eax,%edx
801028b0:	83 e0 0f             	and    $0xf,%eax
801028b3:	c1 ea 04             	shr    $0x4,%edx
801028b6:	8d 14 92             	lea    (%edx,%edx,4),%edx
801028b9:	8d 04 50             	lea    (%eax,%edx,2),%eax
801028bc:	89 45 b8             	mov    %eax,-0x48(%ebp)
801028bf:	8b 45 bc             	mov    -0x44(%ebp),%eax
801028c2:	89 c2                	mov    %eax,%edx
801028c4:	83 e0 0f             	and    $0xf,%eax
801028c7:	c1 ea 04             	shr    $0x4,%edx
801028ca:	8d 14 92             	lea    (%edx,%edx,4),%edx
801028cd:	8d 04 50             	lea    (%eax,%edx,2),%eax
801028d0:	89 45 bc             	mov    %eax,-0x44(%ebp)
801028d3:	8b 45 c0             	mov    -0x40(%ebp),%eax
801028d6:	89 c2                	mov    %eax,%edx
801028d8:	83 e0 0f             	and    $0xf,%eax
801028db:	c1 ea 04             	shr    $0x4,%edx
801028de:	8d 14 92             	lea    (%edx,%edx,4),%edx
801028e1:	8d 04 50             	lea    (%eax,%edx,2),%eax
801028e4:	89 45 c0             	mov    %eax,-0x40(%ebp)
801028e7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801028ea:	89 c2                	mov    %eax,%edx
801028ec:	83 e0 0f             	and    $0xf,%eax
801028ef:	c1 ea 04             	shr    $0x4,%edx
801028f2:	8d 14 92             	lea    (%edx,%edx,4),%edx
801028f5:	8d 04 50             	lea    (%eax,%edx,2),%eax
801028f8:	89 45 c4             	mov    %eax,-0x3c(%ebp)
801028fb:	8b 45 c8             	mov    -0x38(%ebp),%eax
801028fe:	89 c2                	mov    %eax,%edx
80102900:	83 e0 0f             	and    $0xf,%eax
80102903:	c1 ea 04             	shr    $0x4,%edx
80102906:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102909:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010290c:	89 45 c8             	mov    %eax,-0x38(%ebp)
8010290f:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102912:	89 c2                	mov    %eax,%edx
80102914:	83 e0 0f             	and    $0xf,%eax
80102917:	c1 ea 04             	shr    $0x4,%edx
8010291a:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010291d:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102920:	89 45 cc             	mov    %eax,-0x34(%ebp)
80102923:	8b 4d 08             	mov    0x8(%ebp),%ecx
80102926:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102929:	89 01                	mov    %eax,(%ecx)
8010292b:	8b 45 bc             	mov    -0x44(%ebp),%eax
8010292e:	89 41 04             	mov    %eax,0x4(%ecx)
80102931:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102934:	89 41 08             	mov    %eax,0x8(%ecx)
80102937:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010293a:	89 41 0c             	mov    %eax,0xc(%ecx)
8010293d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102940:	89 41 10             	mov    %eax,0x10(%ecx)
80102943:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102946:	89 41 14             	mov    %eax,0x14(%ecx)
80102949:	81 41 14 d0 07 00 00 	addl   $0x7d0,0x14(%ecx)
80102950:	83 c4 4c             	add    $0x4c,%esp
80102953:	5b                   	pop    %ebx
80102954:	5e                   	pop    %esi
80102955:	5f                   	pop    %edi
80102956:	5d                   	pop    %ebp
80102957:	c3                   	ret    
	...

80102960 <install_trans>:
80102960:	55                   	push   %ebp
80102961:	89 e5                	mov    %esp,%ebp
80102963:	57                   	push   %edi
80102964:	56                   	push   %esi
80102965:	53                   	push   %ebx
80102966:	31 db                	xor    %ebx,%ebx
80102968:	83 ec 1c             	sub    $0x1c,%esp
8010296b:	a1 c8 26 11 80       	mov    0x801126c8,%eax
80102970:	85 c0                	test   %eax,%eax
80102972:	7e 78                	jle    801029ec <install_trans+0x8c>
80102974:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102978:	a1 b4 26 11 80       	mov    0x801126b4,%eax
8010297d:	01 d8                	add    %ebx,%eax
8010297f:	83 c0 01             	add    $0x1,%eax
80102982:	89 44 24 04          	mov    %eax,0x4(%esp)
80102986:	a1 c4 26 11 80       	mov    0x801126c4,%eax
8010298b:	89 04 24             	mov    %eax,(%esp)
8010298e:	e8 3d d7 ff ff       	call   801000d0 <bread>
80102993:	89 c7                	mov    %eax,%edi
80102995:	8b 04 9d cc 26 11 80 	mov    -0x7feed934(,%ebx,4),%eax
8010299c:	83 c3 01             	add    $0x1,%ebx
8010299f:	89 44 24 04          	mov    %eax,0x4(%esp)
801029a3:	a1 c4 26 11 80       	mov    0x801126c4,%eax
801029a8:	89 04 24             	mov    %eax,(%esp)
801029ab:	e8 20 d7 ff ff       	call   801000d0 <bread>
801029b0:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
801029b7:	00 
801029b8:	89 c6                	mov    %eax,%esi
801029ba:	8d 47 5c             	lea    0x5c(%edi),%eax
801029bd:	89 44 24 04          	mov    %eax,0x4(%esp)
801029c1:	8d 46 5c             	lea    0x5c(%esi),%eax
801029c4:	89 04 24             	mov    %eax,(%esp)
801029c7:	e8 54 19 00 00       	call   80104320 <memmove>
801029cc:	89 34 24             	mov    %esi,(%esp)
801029cf:	e8 cc d7 ff ff       	call   801001a0 <bwrite>
801029d4:	89 3c 24             	mov    %edi,(%esp)
801029d7:	e8 04 d8 ff ff       	call   801001e0 <brelse>
801029dc:	89 34 24             	mov    %esi,(%esp)
801029df:	e8 fc d7 ff ff       	call   801001e0 <brelse>
801029e4:	39 1d c8 26 11 80    	cmp    %ebx,0x801126c8
801029ea:	7f 8c                	jg     80102978 <install_trans+0x18>
801029ec:	83 c4 1c             	add    $0x1c,%esp
801029ef:	5b                   	pop    %ebx
801029f0:	5e                   	pop    %esi
801029f1:	5f                   	pop    %edi
801029f2:	5d                   	pop    %ebp
801029f3:	c3                   	ret    
801029f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801029fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80102a00 <write_head>:
80102a00:	55                   	push   %ebp
80102a01:	89 e5                	mov    %esp,%ebp
80102a03:	57                   	push   %edi
80102a04:	56                   	push   %esi
80102a05:	53                   	push   %ebx
80102a06:	83 ec 1c             	sub    $0x1c,%esp
80102a09:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102a0e:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a12:	a1 c4 26 11 80       	mov    0x801126c4,%eax
80102a17:	89 04 24             	mov    %eax,(%esp)
80102a1a:	e8 b1 d6 ff ff       	call   801000d0 <bread>
80102a1f:	8b 1d c8 26 11 80    	mov    0x801126c8,%ebx
80102a25:	31 d2                	xor    %edx,%edx
80102a27:	85 db                	test   %ebx,%ebx
80102a29:	89 c7                	mov    %eax,%edi
80102a2b:	89 58 5c             	mov    %ebx,0x5c(%eax)
80102a2e:	8d 70 5c             	lea    0x5c(%eax),%esi
80102a31:	7e 17                	jle    80102a4a <write_head+0x4a>
80102a33:	90                   	nop
80102a34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102a38:	8b 0c 95 cc 26 11 80 	mov    -0x7feed934(,%edx,4),%ecx
80102a3f:	89 4c 96 04          	mov    %ecx,0x4(%esi,%edx,4)
80102a43:	83 c2 01             	add    $0x1,%edx
80102a46:	39 da                	cmp    %ebx,%edx
80102a48:	75 ee                	jne    80102a38 <write_head+0x38>
80102a4a:	89 3c 24             	mov    %edi,(%esp)
80102a4d:	e8 4e d7 ff ff       	call   801001a0 <bwrite>
80102a52:	89 3c 24             	mov    %edi,(%esp)
80102a55:	e8 86 d7 ff ff       	call   801001e0 <brelse>
80102a5a:	83 c4 1c             	add    $0x1c,%esp
80102a5d:	5b                   	pop    %ebx
80102a5e:	5e                   	pop    %esi
80102a5f:	5f                   	pop    %edi
80102a60:	5d                   	pop    %ebp
80102a61:	c3                   	ret    
80102a62:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102a70 <initlog>:
80102a70:	55                   	push   %ebp
80102a71:	89 e5                	mov    %esp,%ebp
80102a73:	56                   	push   %esi
80102a74:	53                   	push   %ebx
80102a75:	83 ec 30             	sub    $0x30,%esp
80102a78:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102a7b:	c7 44 24 04 e0 70 10 	movl   $0x801070e0,0x4(%esp)
80102a82:	80 
80102a83:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102a8a:	e8 c1 15 00 00       	call   80104050 <initlock>
80102a8f:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102a92:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a96:	89 1c 24             	mov    %ebx,(%esp)
80102a99:	e8 02 e9 ff ff       	call   801013a0 <readsb>
80102a9e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102aa1:	8b 55 e8             	mov    -0x18(%ebp),%edx
80102aa4:	89 1c 24             	mov    %ebx,(%esp)
80102aa7:	89 1d c4 26 11 80    	mov    %ebx,0x801126c4
80102aad:	89 44 24 04          	mov    %eax,0x4(%esp)
80102ab1:	89 15 b8 26 11 80    	mov    %edx,0x801126b8
80102ab7:	a3 b4 26 11 80       	mov    %eax,0x801126b4
80102abc:	e8 0f d6 ff ff       	call   801000d0 <bread>
80102ac1:	31 d2                	xor    %edx,%edx
80102ac3:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102ac6:	8d 70 5c             	lea    0x5c(%eax),%esi
80102ac9:	85 db                	test   %ebx,%ebx
80102acb:	89 1d c8 26 11 80    	mov    %ebx,0x801126c8
80102ad1:	7e 17                	jle    80102aea <initlog+0x7a>
80102ad3:	90                   	nop
80102ad4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102ad8:	8b 4c 96 04          	mov    0x4(%esi,%edx,4),%ecx
80102adc:	89 0c 95 cc 26 11 80 	mov    %ecx,-0x7feed934(,%edx,4)
80102ae3:	83 c2 01             	add    $0x1,%edx
80102ae6:	39 da                	cmp    %ebx,%edx
80102ae8:	75 ee                	jne    80102ad8 <initlog+0x68>
80102aea:	89 04 24             	mov    %eax,(%esp)
80102aed:	e8 ee d6 ff ff       	call   801001e0 <brelse>
80102af2:	e8 69 fe ff ff       	call   80102960 <install_trans>
80102af7:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102afe:	00 00 00 
80102b01:	e8 fa fe ff ff       	call   80102a00 <write_head>
80102b06:	83 c4 30             	add    $0x30,%esp
80102b09:	5b                   	pop    %ebx
80102b0a:	5e                   	pop    %esi
80102b0b:	5d                   	pop    %ebp
80102b0c:	c3                   	ret    
80102b0d:	8d 76 00             	lea    0x0(%esi),%esi

80102b10 <begin_op>:
80102b10:	55                   	push   %ebp
80102b11:	89 e5                	mov    %esp,%ebp
80102b13:	83 ec 18             	sub    $0x18,%esp
80102b16:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102b1d:	e8 1e 16 00 00       	call   80104140 <acquire>
80102b22:	eb 18                	jmp    80102b3c <begin_op+0x2c>
80102b24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102b28:	c7 44 24 04 80 26 11 	movl   $0x80112680,0x4(%esp)
80102b2f:	80 
80102b30:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102b37:	e8 c4 10 00 00       	call   80103c00 <sleep>
80102b3c:	8b 15 c0 26 11 80    	mov    0x801126c0,%edx
80102b42:	85 d2                	test   %edx,%edx
80102b44:	75 e2                	jne    80102b28 <begin_op+0x18>
80102b46:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102b4b:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102b51:	83 c0 01             	add    $0x1,%eax
80102b54:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102b57:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102b5a:	83 fa 1e             	cmp    $0x1e,%edx
80102b5d:	7f c9                	jg     80102b28 <begin_op+0x18>
80102b5f:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102b66:	a3 bc 26 11 80       	mov    %eax,0x801126bc
80102b6b:	e8 c0 16 00 00       	call   80104230 <release>
80102b70:	c9                   	leave  
80102b71:	c3                   	ret    
80102b72:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102b79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102b80 <end_op>:
80102b80:	55                   	push   %ebp
80102b81:	89 e5                	mov    %esp,%ebp
80102b83:	57                   	push   %edi
80102b84:	56                   	push   %esi
80102b85:	53                   	push   %ebx
80102b86:	83 ec 1c             	sub    $0x1c,%esp
80102b89:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102b90:	e8 ab 15 00 00       	call   80104140 <acquire>
80102b95:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102b9a:	8b 1d c0 26 11 80    	mov    0x801126c0,%ebx
80102ba0:	83 e8 01             	sub    $0x1,%eax
80102ba3:	85 db                	test   %ebx,%ebx
80102ba5:	a3 bc 26 11 80       	mov    %eax,0x801126bc
80102baa:	0f 85 f3 00 00 00    	jne    80102ca3 <end_op+0x123>
80102bb0:	85 c0                	test   %eax,%eax
80102bb2:	0f 85 cb 00 00 00    	jne    80102c83 <end_op+0x103>
80102bb8:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102bbf:	31 db                	xor    %ebx,%ebx
80102bc1:	c7 05 c0 26 11 80 01 	movl   $0x1,0x801126c0
80102bc8:	00 00 00 
80102bcb:	e8 60 16 00 00       	call   80104230 <release>
80102bd0:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102bd6:	85 c9                	test   %ecx,%ecx
80102bd8:	0f 8e 8f 00 00 00    	jle    80102c6d <end_op+0xed>
80102bde:	66 90                	xchg   %ax,%ax
80102be0:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102be5:	01 d8                	add    %ebx,%eax
80102be7:	83 c0 01             	add    $0x1,%eax
80102bea:	89 44 24 04          	mov    %eax,0x4(%esp)
80102bee:	a1 c4 26 11 80       	mov    0x801126c4,%eax
80102bf3:	89 04 24             	mov    %eax,(%esp)
80102bf6:	e8 d5 d4 ff ff       	call   801000d0 <bread>
80102bfb:	89 c6                	mov    %eax,%esi
80102bfd:	8b 04 9d cc 26 11 80 	mov    -0x7feed934(,%ebx,4),%eax
80102c04:	83 c3 01             	add    $0x1,%ebx
80102c07:	89 44 24 04          	mov    %eax,0x4(%esp)
80102c0b:	a1 c4 26 11 80       	mov    0x801126c4,%eax
80102c10:	89 04 24             	mov    %eax,(%esp)
80102c13:	e8 b8 d4 ff ff       	call   801000d0 <bread>
80102c18:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80102c1f:	00 
80102c20:	89 c7                	mov    %eax,%edi
80102c22:	8d 40 5c             	lea    0x5c(%eax),%eax
80102c25:	89 44 24 04          	mov    %eax,0x4(%esp)
80102c29:	8d 46 5c             	lea    0x5c(%esi),%eax
80102c2c:	89 04 24             	mov    %eax,(%esp)
80102c2f:	e8 ec 16 00 00       	call   80104320 <memmove>
80102c34:	89 34 24             	mov    %esi,(%esp)
80102c37:	e8 64 d5 ff ff       	call   801001a0 <bwrite>
80102c3c:	89 3c 24             	mov    %edi,(%esp)
80102c3f:	e8 9c d5 ff ff       	call   801001e0 <brelse>
80102c44:	89 34 24             	mov    %esi,(%esp)
80102c47:	e8 94 d5 ff ff       	call   801001e0 <brelse>
80102c4c:	3b 1d c8 26 11 80    	cmp    0x801126c8,%ebx
80102c52:	7c 8c                	jl     80102be0 <end_op+0x60>
80102c54:	e8 a7 fd ff ff       	call   80102a00 <write_head>
80102c59:	e8 02 fd ff ff       	call   80102960 <install_trans>
80102c5e:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102c65:	00 00 00 
80102c68:	e8 93 fd ff ff       	call   80102a00 <write_head>
80102c6d:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102c74:	e8 c7 14 00 00       	call   80104140 <acquire>
80102c79:	c7 05 c0 26 11 80 00 	movl   $0x0,0x801126c0
80102c80:	00 00 00 
80102c83:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102c8a:	e8 01 11 00 00       	call   80103d90 <wakeup>
80102c8f:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102c96:	e8 95 15 00 00       	call   80104230 <release>
80102c9b:	83 c4 1c             	add    $0x1c,%esp
80102c9e:	5b                   	pop    %ebx
80102c9f:	5e                   	pop    %esi
80102ca0:	5f                   	pop    %edi
80102ca1:	5d                   	pop    %ebp
80102ca2:	c3                   	ret    
80102ca3:	c7 04 24 e4 70 10 80 	movl   $0x801070e4,(%esp)
80102caa:	e8 b1 d6 ff ff       	call   80100360 <panic>
80102caf:	90                   	nop

80102cb0 <log_write>:
80102cb0:	55                   	push   %ebp
80102cb1:	89 e5                	mov    %esp,%ebp
80102cb3:	53                   	push   %ebx
80102cb4:	83 ec 14             	sub    $0x14,%esp
80102cb7:	a1 c8 26 11 80       	mov    0x801126c8,%eax
80102cbc:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102cbf:	83 f8 1d             	cmp    $0x1d,%eax
80102cc2:	0f 8f 98 00 00 00    	jg     80102d60 <log_write+0xb0>
80102cc8:	8b 0d b8 26 11 80    	mov    0x801126b8,%ecx
80102cce:	8d 51 ff             	lea    -0x1(%ecx),%edx
80102cd1:	39 d0                	cmp    %edx,%eax
80102cd3:	0f 8d 87 00 00 00    	jge    80102d60 <log_write+0xb0>
80102cd9:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102cde:	85 c0                	test   %eax,%eax
80102ce0:	0f 8e 86 00 00 00    	jle    80102d6c <log_write+0xbc>
80102ce6:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102ced:	e8 4e 14 00 00       	call   80104140 <acquire>
80102cf2:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102cf8:	83 fa 00             	cmp    $0x0,%edx
80102cfb:	7e 54                	jle    80102d51 <log_write+0xa1>
80102cfd:	8b 4b 08             	mov    0x8(%ebx),%ecx
80102d00:	31 c0                	xor    %eax,%eax
80102d02:	39 0d cc 26 11 80    	cmp    %ecx,0x801126cc
80102d08:	75 0f                	jne    80102d19 <log_write+0x69>
80102d0a:	eb 3c                	jmp    80102d48 <log_write+0x98>
80102d0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d10:	39 0c 85 cc 26 11 80 	cmp    %ecx,-0x7feed934(,%eax,4)
80102d17:	74 2f                	je     80102d48 <log_write+0x98>
80102d19:	83 c0 01             	add    $0x1,%eax
80102d1c:	39 d0                	cmp    %edx,%eax
80102d1e:	75 f0                	jne    80102d10 <log_write+0x60>
80102d20:	89 0c 95 cc 26 11 80 	mov    %ecx,-0x7feed934(,%edx,4)
80102d27:	83 c2 01             	add    $0x1,%edx
80102d2a:	89 15 c8 26 11 80    	mov    %edx,0x801126c8
80102d30:	83 0b 04             	orl    $0x4,(%ebx)
80102d33:	c7 45 08 80 26 11 80 	movl   $0x80112680,0x8(%ebp)
80102d3a:	83 c4 14             	add    $0x14,%esp
80102d3d:	5b                   	pop    %ebx
80102d3e:	5d                   	pop    %ebp
80102d3f:	e9 ec 14 00 00       	jmp    80104230 <release>
80102d44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d48:	89 0c 85 cc 26 11 80 	mov    %ecx,-0x7feed934(,%eax,4)
80102d4f:	eb df                	jmp    80102d30 <log_write+0x80>
80102d51:	8b 43 08             	mov    0x8(%ebx),%eax
80102d54:	a3 cc 26 11 80       	mov    %eax,0x801126cc
80102d59:	75 d5                	jne    80102d30 <log_write+0x80>
80102d5b:	eb ca                	jmp    80102d27 <log_write+0x77>
80102d5d:	8d 76 00             	lea    0x0(%esi),%esi
80102d60:	c7 04 24 f3 70 10 80 	movl   $0x801070f3,(%esp)
80102d67:	e8 f4 d5 ff ff       	call   80100360 <panic>
80102d6c:	c7 04 24 09 71 10 80 	movl   $0x80107109,(%esp)
80102d73:	e8 e8 d5 ff ff       	call   80100360 <panic>
	...

80102d80 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102d80:	55                   	push   %ebp
80102d81:	89 e5                	mov    %esp,%ebp
80102d83:	53                   	push   %ebx
80102d84:	83 ec 14             	sub    $0x14,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102d87:	e8 f4 08 00 00       	call   80103680 <cpuid>
80102d8c:	89 c3                	mov    %eax,%ebx
80102d8e:	e8 ed 08 00 00       	call   80103680 <cpuid>
80102d93:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80102d97:	c7 04 24 24 71 10 80 	movl   $0x80107124,(%esp)
80102d9e:	89 44 24 04          	mov    %eax,0x4(%esp)
80102da2:	e8 a9 d8 ff ff       	call   80100650 <cprintf>
  idtinit();       // load idt register
80102da7:	e8 34 27 00 00       	call   801054e0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102dac:	e8 4f 08 00 00       	call   80103600 <mycpu>
80102db1:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102db3:	b8 01 00 00 00       	mov    $0x1,%eax
80102db8:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102dbf:	e8 9c 0b 00 00       	call   80103960 <scheduler>
80102dc4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102dca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80102dd0 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80102dd0:	55                   	push   %ebp
80102dd1:	89 e5                	mov    %esp,%ebp
80102dd3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102dd6:	e8 b5 37 00 00       	call   80106590 <switchkvm>
  seginit();
80102ddb:	e8 f0 36 00 00       	call   801064d0 <seginit>
  lapicinit();
80102de0:	e8 8b f8 ff ff       	call   80102670 <lapicinit>
  mpmain();
80102de5:	e8 96 ff ff ff       	call   80102d80 <mpmain>
80102dea:	00 00                	add    %al,(%eax)
80102dec:	00 00                	add    %al,(%eax)
	...

80102df0 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80102df0:	55                   	push   %ebp
80102df1:	89 e5                	mov    %esp,%ebp
80102df3:	53                   	push   %ebx
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80102df4:	bb 80 27 11 80       	mov    $0x80112780,%ebx
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80102df9:	83 e4 f0             	and    $0xfffffff0,%esp
80102dfc:	83 ec 10             	sub    $0x10,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102dff:	c7 44 24 04 00 00 40 	movl   $0x80400000,0x4(%esp)
80102e06:	80 
80102e07:	c7 04 24 a8 54 11 80 	movl   $0x801154a8,(%esp)
80102e0e:	e8 dd f5 ff ff       	call   801023f0 <kinit1>
  kvmalloc();      // kernel page table
80102e13:	e8 08 3c 00 00       	call   80106a20 <kvmalloc>
  mpinit();        // detect other processors
80102e18:	e8 73 01 00 00       	call   80102f90 <mpinit>
80102e1d:	8d 76 00             	lea    0x0(%esi),%esi
  lapicinit();     // interrupt controller
80102e20:	e8 4b f8 ff ff       	call   80102670 <lapicinit>
  seginit();       // segment descriptors
80102e25:	e8 a6 36 00 00       	call   801064d0 <seginit>
  picinit();       // disable pic
80102e2a:	e8 21 03 00 00       	call   80103150 <picinit>
80102e2f:	90                   	nop
  ioapicinit();    // another interrupt controller
80102e30:	e8 db f3 ff ff       	call   80102210 <ioapicinit>
  consoleinit();   // console hardware
80102e35:	e8 16 db ff ff       	call   80100950 <consoleinit>
  uartinit();      // serial port
80102e3a:	e8 c1 29 00 00       	call   80105800 <uartinit>
80102e3f:	90                   	nop
  pinit();         // process table
80102e40:	e8 9b 07 00 00       	call   801035e0 <pinit>
  tvinit();        // trap vectors
80102e45:	e8 f6 25 00 00       	call   80105440 <tvinit>
  binit();         // buffer cache
80102e4a:	e8 f1 d1 ff ff       	call   80100040 <binit>
80102e4f:	90                   	nop
  fileinit();      // file table
80102e50:	e8 fb de ff ff       	call   80100d50 <fileinit>
  ideinit();       // disk 
80102e55:	e8 b6 f1 ff ff       	call   80102010 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102e5a:	c7 44 24 08 8a 00 00 	movl   $0x8a,0x8(%esp)
80102e61:	00 
80102e62:	c7 44 24 04 8c a4 10 	movl   $0x8010a48c,0x4(%esp)
80102e69:	80 
80102e6a:	c7 04 24 00 70 00 80 	movl   $0x80007000,(%esp)
80102e71:	e8 aa 14 00 00       	call   80104320 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102e76:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80102e7d:	00 00 00 
80102e80:	05 80 27 11 80       	add    $0x80112780,%eax
80102e85:	39 d8                	cmp    %ebx,%eax
80102e87:	76 6a                	jbe    80102ef3 <main+0x103>
80102e89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(c == mycpu())  // We've started already.
80102e90:	e8 6b 07 00 00       	call   80103600 <mycpu>
80102e95:	39 d8                	cmp    %ebx,%eax
80102e97:	74 41                	je     80102eda <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102e99:	e8 12 f6 ff ff       	call   801024b0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void**)(code-8) = mpenter;
80102e9e:	c7 05 f8 6f 00 80 d0 	movl   $0x80102dd0,0x80006ff8
80102ea5:	2d 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102ea8:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80102eaf:	90 10 00 

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
    *(void**)(code-4) = stack + KSTACKSIZE;
80102eb2:	05 00 10 00 00       	add    $0x1000,%eax
80102eb7:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    *(void**)(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80102ebc:	0f b6 03             	movzbl (%ebx),%eax
80102ebf:	c7 44 24 04 00 70 00 	movl   $0x7000,0x4(%esp)
80102ec6:	00 
80102ec7:	89 04 24             	mov    %eax,(%esp)
80102eca:	e8 e1 f8 ff ff       	call   801027b0 <lapicstartap>
80102ecf:	90                   	nop

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102ed0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102ed6:	85 c0                	test   %eax,%eax
80102ed8:	74 f6                	je     80102ed0 <main+0xe0>
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80102eda:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80102ee1:	00 00 00 
80102ee4:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102eea:	05 80 27 11 80       	add    $0x80112780,%eax
80102eef:	39 c3                	cmp    %eax,%ebx
80102ef1:	72 9d                	jb     80102e90 <main+0xa0>
  tvinit();        // trap vectors
  binit();         // buffer cache
  fileinit();      // file table
  ideinit();       // disk 
  startothers();   // start other processors
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102ef3:	c7 44 24 04 00 00 00 	movl   $0x8e000000,0x4(%esp)
80102efa:	8e 
80102efb:	c7 04 24 00 00 40 80 	movl   $0x80400000,(%esp)
80102f02:	e8 59 f5 ff ff       	call   80102460 <kinit2>
  userinit();      // first user process
80102f07:	e8 c4 07 00 00       	call   801036d0 <userinit>
  mpmain();        // finish this processor's setup
80102f0c:	e8 6f fe ff ff       	call   80102d80 <mpmain>
	...

80102f20 <mpsearch1>:
80102f20:	55                   	push   %ebp
80102f21:	89 e5                	mov    %esp,%ebp
80102f23:	56                   	push   %esi
80102f24:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
80102f2a:	53                   	push   %ebx
80102f2b:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
80102f2e:	83 ec 10             	sub    $0x10,%esp
80102f31:	39 de                	cmp    %ebx,%esi
80102f33:	73 3c                	jae    80102f71 <mpsearch1+0x51>
80102f35:	8d 76 00             	lea    0x0(%esi),%esi
80102f38:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80102f3f:	00 
80102f40:	c7 44 24 04 38 71 10 	movl   $0x80107138,0x4(%esp)
80102f47:	80 
80102f48:	89 34 24             	mov    %esi,(%esp)
80102f4b:	e8 80 13 00 00       	call   801042d0 <memcmp>
80102f50:	85 c0                	test   %eax,%eax
80102f52:	75 16                	jne    80102f6a <mpsearch1+0x4a>
80102f54:	31 c9                	xor    %ecx,%ecx
80102f56:	31 d2                	xor    %edx,%edx
80102f58:	0f b6 04 16          	movzbl (%esi,%edx,1),%eax
80102f5c:	83 c2 01             	add    $0x1,%edx
80102f5f:	01 c1                	add    %eax,%ecx
80102f61:	83 fa 10             	cmp    $0x10,%edx
80102f64:	75 f2                	jne    80102f58 <mpsearch1+0x38>
80102f66:	84 c9                	test   %cl,%cl
80102f68:	74 10                	je     80102f7a <mpsearch1+0x5a>
80102f6a:	83 c6 10             	add    $0x10,%esi
80102f6d:	39 f3                	cmp    %esi,%ebx
80102f6f:	77 c7                	ja     80102f38 <mpsearch1+0x18>
80102f71:	83 c4 10             	add    $0x10,%esp
80102f74:	31 c0                	xor    %eax,%eax
80102f76:	5b                   	pop    %ebx
80102f77:	5e                   	pop    %esi
80102f78:	5d                   	pop    %ebp
80102f79:	c3                   	ret    
80102f7a:	83 c4 10             	add    $0x10,%esp
80102f7d:	89 f0                	mov    %esi,%eax
80102f7f:	5b                   	pop    %ebx
80102f80:	5e                   	pop    %esi
80102f81:	5d                   	pop    %ebp
80102f82:	c3                   	ret    
80102f83:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102f89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102f90 <mpinit>:
80102f90:	55                   	push   %ebp
80102f91:	89 e5                	mov    %esp,%ebp
80102f93:	57                   	push   %edi
80102f94:	56                   	push   %esi
80102f95:	53                   	push   %ebx
80102f96:	83 ec 1c             	sub    $0x1c,%esp
80102f99:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80102fa0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80102fa7:	c1 e0 08             	shl    $0x8,%eax
80102faa:	09 d0                	or     %edx,%eax
80102fac:	c1 e0 04             	shl    $0x4,%eax
80102faf:	85 c0                	test   %eax,%eax
80102fb1:	75 1b                	jne    80102fce <mpinit+0x3e>
80102fb3:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80102fba:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80102fc1:	c1 e0 08             	shl    $0x8,%eax
80102fc4:	09 d0                	or     %edx,%eax
80102fc6:	c1 e0 0a             	shl    $0xa,%eax
80102fc9:	2d 00 04 00 00       	sub    $0x400,%eax
80102fce:	ba 00 04 00 00       	mov    $0x400,%edx
80102fd3:	e8 48 ff ff ff       	call   80102f20 <mpsearch1>
80102fd8:	85 c0                	test   %eax,%eax
80102fda:	89 c7                	mov    %eax,%edi
80102fdc:	0f 84 22 01 00 00    	je     80103104 <mpinit+0x174>
80102fe2:	8b 77 04             	mov    0x4(%edi),%esi
80102fe5:	85 f6                	test   %esi,%esi
80102fe7:	0f 84 30 01 00 00    	je     8010311d <mpinit+0x18d>
80102fed:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80102ff3:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80102ffa:	00 
80102ffb:	c7 44 24 04 3d 71 10 	movl   $0x8010713d,0x4(%esp)
80103002:	80 
80103003:	89 04 24             	mov    %eax,(%esp)
80103006:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103009:	e8 c2 12 00 00       	call   801042d0 <memcmp>
8010300e:	85 c0                	test   %eax,%eax
80103010:	0f 85 07 01 00 00    	jne    8010311d <mpinit+0x18d>
80103016:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
8010301d:	3c 04                	cmp    $0x4,%al
8010301f:	0f 85 0b 01 00 00    	jne    80103130 <mpinit+0x1a0>
80103025:	0f b7 86 04 00 00 80 	movzwl -0x7ffffffc(%esi),%eax
8010302c:	85 c0                	test   %eax,%eax
8010302e:	74 21                	je     80103051 <mpinit+0xc1>
80103030:	31 c9                	xor    %ecx,%ecx
80103032:	31 d2                	xor    %edx,%edx
80103034:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103038:	0f b6 9c 16 00 00 00 	movzbl -0x80000000(%esi,%edx,1),%ebx
8010303f:	80 
80103040:	83 c2 01             	add    $0x1,%edx
80103043:	01 d9                	add    %ebx,%ecx
80103045:	39 d0                	cmp    %edx,%eax
80103047:	7f ef                	jg     80103038 <mpinit+0xa8>
80103049:	84 c9                	test   %cl,%cl
8010304b:	0f 85 cc 00 00 00    	jne    8010311d <mpinit+0x18d>
80103051:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103054:	85 c0                	test   %eax,%eax
80103056:	0f 84 c1 00 00 00    	je     8010311d <mpinit+0x18d>
8010305c:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
80103062:	bb 01 00 00 00       	mov    $0x1,%ebx
80103067:	a3 7c 26 11 80       	mov    %eax,0x8011267c
8010306c:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
80103073:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
80103079:	03 55 e4             	add    -0x1c(%ebp),%edx
8010307c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103080:	39 c2                	cmp    %eax,%edx
80103082:	76 1b                	jbe    8010309f <mpinit+0x10f>
80103084:	0f b6 08             	movzbl (%eax),%ecx
80103087:	80 f9 04             	cmp    $0x4,%cl
8010308a:	77 74                	ja     80103100 <mpinit+0x170>
8010308c:	ff 24 8d 7c 71 10 80 	jmp    *-0x7fef8e84(,%ecx,4)
80103093:	90                   	nop
80103094:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103098:	83 c0 08             	add    $0x8,%eax
8010309b:	39 c2                	cmp    %eax,%edx
8010309d:	77 e5                	ja     80103084 <mpinit+0xf4>
8010309f:	85 db                	test   %ebx,%ebx
801030a1:	0f 84 93 00 00 00    	je     8010313a <mpinit+0x1aa>
801030a7:	80 7f 0c 00          	cmpb   $0x0,0xc(%edi)
801030ab:	74 12                	je     801030bf <mpinit+0x12f>
801030ad:	ba 22 00 00 00       	mov    $0x22,%edx
801030b2:	b8 70 00 00 00       	mov    $0x70,%eax
801030b7:	ee                   	out    %al,(%dx)
801030b8:	b2 23                	mov    $0x23,%dl
801030ba:	ec                   	in     (%dx),%al
801030bb:	83 c8 01             	or     $0x1,%eax
801030be:	ee                   	out    %al,(%dx)
801030bf:	83 c4 1c             	add    $0x1c,%esp
801030c2:	5b                   	pop    %ebx
801030c3:	5e                   	pop    %esi
801030c4:	5f                   	pop    %edi
801030c5:	5d                   	pop    %ebp
801030c6:	c3                   	ret    
801030c7:	90                   	nop
801030c8:	8b 35 00 2d 11 80    	mov    0x80112d00,%esi
801030ce:	83 fe 07             	cmp    $0x7,%esi
801030d1:	7f 17                	jg     801030ea <mpinit+0x15a>
801030d3:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
801030d7:	69 f6 b0 00 00 00    	imul   $0xb0,%esi,%esi
801030dd:	83 05 00 2d 11 80 01 	addl   $0x1,0x80112d00
801030e4:	88 8e 80 27 11 80    	mov    %cl,-0x7feed880(%esi)
801030ea:	83 c0 14             	add    $0x14,%eax
801030ed:	eb 91                	jmp    80103080 <mpinit+0xf0>
801030ef:	90                   	nop
801030f0:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
801030f4:	83 c0 08             	add    $0x8,%eax
801030f7:	88 0d 60 27 11 80    	mov    %cl,0x80112760
801030fd:	eb 81                	jmp    80103080 <mpinit+0xf0>
801030ff:	90                   	nop
80103100:	31 db                	xor    %ebx,%ebx
80103102:	eb 83                	jmp    80103087 <mpinit+0xf7>
80103104:	ba 00 00 01 00       	mov    $0x10000,%edx
80103109:	b8 00 00 0f 00       	mov    $0xf0000,%eax
8010310e:	e8 0d fe ff ff       	call   80102f20 <mpsearch1>
80103113:	85 c0                	test   %eax,%eax
80103115:	89 c7                	mov    %eax,%edi
80103117:	0f 85 c5 fe ff ff    	jne    80102fe2 <mpinit+0x52>
8010311d:	c7 04 24 42 71 10 80 	movl   $0x80107142,(%esp)
80103124:	e8 37 d2 ff ff       	call   80100360 <panic>
80103129:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103130:	3c 01                	cmp    $0x1,%al
80103132:	0f 84 ed fe ff ff    	je     80103025 <mpinit+0x95>
80103138:	eb e3                	jmp    8010311d <mpinit+0x18d>
8010313a:	c7 04 24 5c 71 10 80 	movl   $0x8010715c,(%esp)
80103141:	e8 1a d2 ff ff       	call   80100360 <panic>
	...

80103150 <picinit>:
80103150:	55                   	push   %ebp
80103151:	ba 21 00 00 00       	mov    $0x21,%edx
80103156:	89 e5                	mov    %esp,%ebp
80103158:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010315d:	ee                   	out    %al,(%dx)
8010315e:	b2 a1                	mov    $0xa1,%dl
80103160:	ee                   	out    %al,(%dx)
80103161:	5d                   	pop    %ebp
80103162:	c3                   	ret    
	...

80103170 <pipealloc>:
80103170:	55                   	push   %ebp
80103171:	89 e5                	mov    %esp,%ebp
80103173:	57                   	push   %edi
80103174:	56                   	push   %esi
80103175:	53                   	push   %ebx
80103176:	83 ec 1c             	sub    $0x1c,%esp
80103179:	8b 75 08             	mov    0x8(%ebp),%esi
8010317c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010317f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103185:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010318b:	e8 e0 db ff ff       	call   80100d70 <filealloc>
80103190:	85 c0                	test   %eax,%eax
80103192:	89 06                	mov    %eax,(%esi)
80103194:	0f 84 a4 00 00 00    	je     8010323e <pipealloc+0xce>
8010319a:	e8 d1 db ff ff       	call   80100d70 <filealloc>
8010319f:	85 c0                	test   %eax,%eax
801031a1:	89 03                	mov    %eax,(%ebx)
801031a3:	0f 84 87 00 00 00    	je     80103230 <pipealloc+0xc0>
801031a9:	e8 02 f3 ff ff       	call   801024b0 <kalloc>
801031ae:	85 c0                	test   %eax,%eax
801031b0:	89 c7                	mov    %eax,%edi
801031b2:	74 7c                	je     80103230 <pipealloc+0xc0>
801031b4:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801031bb:	00 00 00 
801031be:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801031c5:	00 00 00 
801031c8:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801031cf:	00 00 00 
801031d2:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801031d9:	00 00 00 
801031dc:	89 04 24             	mov    %eax,(%esp)
801031df:	c7 44 24 04 90 71 10 	movl   $0x80107190,0x4(%esp)
801031e6:	80 
801031e7:	e8 64 0e 00 00       	call   80104050 <initlock>
801031ec:	8b 06                	mov    (%esi),%eax
801031ee:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
801031f4:	8b 06                	mov    (%esi),%eax
801031f6:	c6 40 08 01          	movb   $0x1,0x8(%eax)
801031fa:	8b 06                	mov    (%esi),%eax
801031fc:	c6 40 09 00          	movb   $0x0,0x9(%eax)
80103200:	8b 06                	mov    (%esi),%eax
80103202:	89 78 0c             	mov    %edi,0xc(%eax)
80103205:	8b 03                	mov    (%ebx),%eax
80103207:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
8010320d:	8b 03                	mov    (%ebx),%eax
8010320f:	c6 40 08 00          	movb   $0x0,0x8(%eax)
80103213:	8b 03                	mov    (%ebx),%eax
80103215:	c6 40 09 01          	movb   $0x1,0x9(%eax)
80103219:	8b 03                	mov    (%ebx),%eax
8010321b:	31 db                	xor    %ebx,%ebx
8010321d:	89 78 0c             	mov    %edi,0xc(%eax)
80103220:	83 c4 1c             	add    $0x1c,%esp
80103223:	89 d8                	mov    %ebx,%eax
80103225:	5b                   	pop    %ebx
80103226:	5e                   	pop    %esi
80103227:	5f                   	pop    %edi
80103228:	5d                   	pop    %ebp
80103229:	c3                   	ret    
8010322a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103230:	8b 06                	mov    (%esi),%eax
80103232:	85 c0                	test   %eax,%eax
80103234:	74 08                	je     8010323e <pipealloc+0xce>
80103236:	89 04 24             	mov    %eax,(%esp)
80103239:	e8 f2 db ff ff       	call   80100e30 <fileclose>
8010323e:	8b 03                	mov    (%ebx),%eax
80103240:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103245:	85 c0                	test   %eax,%eax
80103247:	74 d7                	je     80103220 <pipealloc+0xb0>
80103249:	89 04 24             	mov    %eax,(%esp)
8010324c:	e8 df db ff ff       	call   80100e30 <fileclose>
80103251:	83 c4 1c             	add    $0x1c,%esp
80103254:	89 d8                	mov    %ebx,%eax
80103256:	5b                   	pop    %ebx
80103257:	5e                   	pop    %esi
80103258:	5f                   	pop    %edi
80103259:	5d                   	pop    %ebp
8010325a:	c3                   	ret    
8010325b:	90                   	nop
8010325c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103260 <pipeclose>:
80103260:	55                   	push   %ebp
80103261:	89 e5                	mov    %esp,%ebp
80103263:	56                   	push   %esi
80103264:	53                   	push   %ebx
80103265:	83 ec 10             	sub    $0x10,%esp
80103268:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010326b:	8b 75 0c             	mov    0xc(%ebp),%esi
8010326e:	89 1c 24             	mov    %ebx,(%esp)
80103271:	e8 ca 0e 00 00       	call   80104140 <acquire>
80103276:	85 f6                	test   %esi,%esi
80103278:	74 3e                	je     801032b8 <pipeclose+0x58>
8010327a:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103280:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80103287:	00 00 00 
8010328a:	89 04 24             	mov    %eax,(%esp)
8010328d:	e8 fe 0a 00 00       	call   80103d90 <wakeup>
80103292:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80103298:	85 d2                	test   %edx,%edx
8010329a:	75 0a                	jne    801032a6 <pipeclose+0x46>
8010329c:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801032a2:	85 c0                	test   %eax,%eax
801032a4:	74 32                	je     801032d8 <pipeclose+0x78>
801032a6:	89 5d 08             	mov    %ebx,0x8(%ebp)
801032a9:	83 c4 10             	add    $0x10,%esp
801032ac:	5b                   	pop    %ebx
801032ad:	5e                   	pop    %esi
801032ae:	5d                   	pop    %ebp
801032af:	e9 7c 0f 00 00       	jmp    80104230 <release>
801032b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801032b8:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
801032be:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801032c5:	00 00 00 
801032c8:	89 04 24             	mov    %eax,(%esp)
801032cb:	e8 c0 0a 00 00       	call   80103d90 <wakeup>
801032d0:	eb c0                	jmp    80103292 <pipeclose+0x32>
801032d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801032d8:	89 1c 24             	mov    %ebx,(%esp)
801032db:	e8 50 0f 00 00       	call   80104230 <release>
801032e0:	89 5d 08             	mov    %ebx,0x8(%ebp)
801032e3:	83 c4 10             	add    $0x10,%esp
801032e6:	5b                   	pop    %ebx
801032e7:	5e                   	pop    %esi
801032e8:	5d                   	pop    %ebp
801032e9:	e9 12 f0 ff ff       	jmp    80102300 <kfree>
801032ee:	66 90                	xchg   %ax,%ax

801032f0 <pipewrite>:
801032f0:	55                   	push   %ebp
801032f1:	89 e5                	mov    %esp,%ebp
801032f3:	57                   	push   %edi
801032f4:	56                   	push   %esi
801032f5:	53                   	push   %ebx
801032f6:	83 ec 1c             	sub    $0x1c,%esp
801032f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801032fc:	89 1c 24             	mov    %ebx,(%esp)
801032ff:	e8 3c 0e 00 00       	call   80104140 <acquire>
80103304:	8b 45 10             	mov    0x10(%ebp),%eax
80103307:	85 c0                	test   %eax,%eax
80103309:	0f 8e b2 00 00 00    	jle    801033c1 <pipewrite+0xd1>
8010330f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103312:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
80103318:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
8010331e:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103324:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103327:	03 4d 10             	add    0x10(%ebp),%ecx
8010332a:	89 4d e0             	mov    %ecx,-0x20(%ebp)
8010332d:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
80103333:	81 c1 00 02 00 00    	add    $0x200,%ecx
80103339:	39 c8                	cmp    %ecx,%eax
8010333b:	74 38                	je     80103375 <pipewrite+0x85>
8010333d:	eb 55                	jmp    80103394 <pipewrite+0xa4>
8010333f:	90                   	nop
80103340:	e8 5b 03 00 00       	call   801036a0 <myproc>
80103345:	8b 48 24             	mov    0x24(%eax),%ecx
80103348:	85 c9                	test   %ecx,%ecx
8010334a:	75 33                	jne    8010337f <pipewrite+0x8f>
8010334c:	89 3c 24             	mov    %edi,(%esp)
8010334f:	e8 3c 0a 00 00       	call   80103d90 <wakeup>
80103354:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80103358:	89 34 24             	mov    %esi,(%esp)
8010335b:	e8 a0 08 00 00       	call   80103c00 <sleep>
80103360:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103366:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010336c:	05 00 02 00 00       	add    $0x200,%eax
80103371:	39 c2                	cmp    %eax,%edx
80103373:	75 23                	jne    80103398 <pipewrite+0xa8>
80103375:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010337b:	85 c0                	test   %eax,%eax
8010337d:	75 c1                	jne    80103340 <pipewrite+0x50>
8010337f:	89 1c 24             	mov    %ebx,(%esp)
80103382:	e8 a9 0e 00 00       	call   80104230 <release>
80103387:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010338c:	83 c4 1c             	add    $0x1c,%esp
8010338f:	5b                   	pop    %ebx
80103390:	5e                   	pop    %esi
80103391:	5f                   	pop    %edi
80103392:	5d                   	pop    %ebp
80103393:	c3                   	ret    
80103394:	89 c2                	mov    %eax,%edx
80103396:	66 90                	xchg   %ax,%ax
80103398:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010339b:	8d 42 01             	lea    0x1(%edx),%eax
8010339e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801033a4:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
801033aa:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
801033ae:	0f b6 09             	movzbl (%ecx),%ecx
801033b1:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
801033b5:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801033b8:	3b 4d e0             	cmp    -0x20(%ebp),%ecx
801033bb:	0f 85 6c ff ff ff    	jne    8010332d <pipewrite+0x3d>
801033c1:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801033c7:	89 04 24             	mov    %eax,(%esp)
801033ca:	e8 c1 09 00 00       	call   80103d90 <wakeup>
801033cf:	89 1c 24             	mov    %ebx,(%esp)
801033d2:	e8 59 0e 00 00       	call   80104230 <release>
801033d7:	8b 45 10             	mov    0x10(%ebp),%eax
801033da:	eb b0                	jmp    8010338c <pipewrite+0x9c>
801033dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801033e0 <piperead>:
801033e0:	55                   	push   %ebp
801033e1:	89 e5                	mov    %esp,%ebp
801033e3:	57                   	push   %edi
801033e4:	56                   	push   %esi
801033e5:	53                   	push   %ebx
801033e6:	83 ec 1c             	sub    $0x1c,%esp
801033e9:	8b 75 08             	mov    0x8(%ebp),%esi
801033ec:	8b 7d 0c             	mov    0xc(%ebp),%edi
801033ef:	89 34 24             	mov    %esi,(%esp)
801033f2:	e8 49 0d 00 00       	call   80104140 <acquire>
801033f7:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801033fd:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103403:	75 5b                	jne    80103460 <piperead+0x80>
80103405:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
8010340b:	85 db                	test   %ebx,%ebx
8010340d:	74 51                	je     80103460 <piperead+0x80>
8010340f:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103415:	eb 25                	jmp    8010343c <piperead+0x5c>
80103417:	90                   	nop
80103418:	89 74 24 04          	mov    %esi,0x4(%esp)
8010341c:	89 1c 24             	mov    %ebx,(%esp)
8010341f:	e8 dc 07 00 00       	call   80103c00 <sleep>
80103424:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
8010342a:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103430:	75 2e                	jne    80103460 <piperead+0x80>
80103432:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103438:	85 d2                	test   %edx,%edx
8010343a:	74 24                	je     80103460 <piperead+0x80>
8010343c:	e8 5f 02 00 00       	call   801036a0 <myproc>
80103441:	8b 48 24             	mov    0x24(%eax),%ecx
80103444:	85 c9                	test   %ecx,%ecx
80103446:	74 d0                	je     80103418 <piperead+0x38>
80103448:	89 34 24             	mov    %esi,(%esp)
8010344b:	e8 e0 0d 00 00       	call   80104230 <release>
80103450:	83 c4 1c             	add    $0x1c,%esp
80103453:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103458:	5b                   	pop    %ebx
80103459:	5e                   	pop    %esi
8010345a:	5f                   	pop    %edi
8010345b:	5d                   	pop    %ebp
8010345c:	c3                   	ret    
8010345d:	8d 76 00             	lea    0x0(%esi),%esi
80103460:	8b 55 10             	mov    0x10(%ebp),%edx
80103463:	31 db                	xor    %ebx,%ebx
80103465:	85 d2                	test   %edx,%edx
80103467:	7f 2b                	jg     80103494 <piperead+0xb4>
80103469:	eb 31                	jmp    8010349c <piperead+0xbc>
8010346b:	90                   	nop
8010346c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103470:	8d 48 01             	lea    0x1(%eax),%ecx
80103473:	25 ff 01 00 00       	and    $0x1ff,%eax
80103478:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010347e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103483:	88 04 1f             	mov    %al,(%edi,%ebx,1)
80103486:	83 c3 01             	add    $0x1,%ebx
80103489:	3b 5d 10             	cmp    0x10(%ebp),%ebx
8010348c:	74 0e                	je     8010349c <piperead+0xbc>
8010348e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103494:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010349a:	75 d4                	jne    80103470 <piperead+0x90>
8010349c:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
801034a2:	89 04 24             	mov    %eax,(%esp)
801034a5:	e8 e6 08 00 00       	call   80103d90 <wakeup>
801034aa:	89 34 24             	mov    %esi,(%esp)
801034ad:	e8 7e 0d 00 00       	call   80104230 <release>
801034b2:	83 c4 1c             	add    $0x1c,%esp
801034b5:	89 d8                	mov    %ebx,%eax
801034b7:	5b                   	pop    %ebx
801034b8:	5e                   	pop    %esi
801034b9:	5f                   	pop    %edi
801034ba:	5d                   	pop    %ebp
801034bb:	c3                   	ret    
801034bc:	00 00                	add    %al,(%eax)
	...

801034c0 <allocproc>:
801034c0:	55                   	push   %ebp
801034c1:	89 e5                	mov    %esp,%ebp
801034c3:	53                   	push   %ebx
801034c4:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
801034c9:	83 ec 14             	sub    $0x14,%esp
801034cc:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801034d3:	e8 68 0c 00 00       	call   80104140 <acquire>
801034d8:	eb 11                	jmp    801034eb <allocproc+0x2b>
801034da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801034e0:	83 c3 7c             	add    $0x7c,%ebx
801034e3:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
801034e9:	74 7d                	je     80103568 <allocproc+0xa8>
801034eb:	8b 43 0c             	mov    0xc(%ebx),%eax
801034ee:	85 c0                	test   %eax,%eax
801034f0:	75 ee                	jne    801034e0 <allocproc+0x20>
801034f2:	a1 04 a0 10 80       	mov    0x8010a004,%eax
801034f7:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801034fe:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
80103505:	8d 50 01             	lea    0x1(%eax),%edx
80103508:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
8010350e:	89 43 10             	mov    %eax,0x10(%ebx)
80103511:	e8 1a 0d 00 00       	call   80104230 <release>
80103516:	e8 95 ef ff ff       	call   801024b0 <kalloc>
8010351b:	85 c0                	test   %eax,%eax
8010351d:	89 43 08             	mov    %eax,0x8(%ebx)
80103520:	74 5a                	je     8010357c <allocproc+0xbc>
80103522:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
80103528:	05 9c 0f 00 00       	add    $0xf9c,%eax
8010352d:	89 53 18             	mov    %edx,0x18(%ebx)
80103530:	c7 40 14 28 54 10 80 	movl   $0x80105428,0x14(%eax)
80103537:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
8010353e:	00 
8010353f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80103546:	00 
80103547:	89 04 24             	mov    %eax,(%esp)
8010354a:	89 43 1c             	mov    %eax,0x1c(%ebx)
8010354d:	e8 2e 0d 00 00       	call   80104280 <memset>
80103552:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103555:	c7 40 10 90 35 10 80 	movl   $0x80103590,0x10(%eax)
8010355c:	89 d8                	mov    %ebx,%eax
8010355e:	83 c4 14             	add    $0x14,%esp
80103561:	5b                   	pop    %ebx
80103562:	5d                   	pop    %ebp
80103563:	c3                   	ret    
80103564:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103568:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010356f:	e8 bc 0c 00 00       	call   80104230 <release>
80103574:	83 c4 14             	add    $0x14,%esp
80103577:	31 c0                	xor    %eax,%eax
80103579:	5b                   	pop    %ebx
8010357a:	5d                   	pop    %ebp
8010357b:	c3                   	ret    
8010357c:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
80103583:	eb d9                	jmp    8010355e <allocproc+0x9e>
80103585:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103589:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103590 <forkret>:
80103590:	55                   	push   %ebp
80103591:	89 e5                	mov    %esp,%ebp
80103593:	83 ec 18             	sub    $0x18,%esp
80103596:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010359d:	e8 8e 0c 00 00       	call   80104230 <release>
801035a2:	8b 15 00 a0 10 80    	mov    0x8010a000,%edx
801035a8:	85 d2                	test   %edx,%edx
801035aa:	75 04                	jne    801035b0 <forkret+0x20>
801035ac:	c9                   	leave  
801035ad:	c3                   	ret    
801035ae:	66 90                	xchg   %ax,%ax
801035b0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801035b7:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
801035be:	00 00 00 
801035c1:	e8 ba de ff ff       	call   80101480 <iinit>
801035c6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801035cd:	e8 9e f4 ff ff       	call   80102a70 <initlog>
801035d2:	c9                   	leave  
801035d3:	c3                   	ret    
801035d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801035da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801035e0 <pinit>:
801035e0:	55                   	push   %ebp
801035e1:	89 e5                	mov    %esp,%ebp
801035e3:	83 ec 18             	sub    $0x18,%esp
801035e6:	c7 44 24 04 95 71 10 	movl   $0x80107195,0x4(%esp)
801035ed:	80 
801035ee:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801035f5:	e8 56 0a 00 00       	call   80104050 <initlock>
801035fa:	c9                   	leave  
801035fb:	c3                   	ret    
801035fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103600 <mycpu>:
80103600:	55                   	push   %ebp
80103601:	89 e5                	mov    %esp,%ebp
80103603:	56                   	push   %esi
80103604:	53                   	push   %ebx
80103605:	83 ec 10             	sub    $0x10,%esp
80103608:	9c                   	pushf  
80103609:	58                   	pop    %eax
8010360a:	f6 c4 02             	test   $0x2,%ah
8010360d:	75 57                	jne    80103666 <mycpu+0x66>
8010360f:	e8 4c f1 ff ff       	call   80102760 <lapicid>
80103614:	8b 35 00 2d 11 80    	mov    0x80112d00,%esi
8010361a:	85 f6                	test   %esi,%esi
8010361c:	7e 3c                	jle    8010365a <mycpu+0x5a>
8010361e:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
80103625:	39 c2                	cmp    %eax,%edx
80103627:	74 2d                	je     80103656 <mycpu+0x56>
80103629:	b9 30 28 11 80       	mov    $0x80112830,%ecx
8010362e:	31 d2                	xor    %edx,%edx
80103630:	83 c2 01             	add    $0x1,%edx
80103633:	39 f2                	cmp    %esi,%edx
80103635:	74 23                	je     8010365a <mycpu+0x5a>
80103637:	0f b6 19             	movzbl (%ecx),%ebx
8010363a:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103640:	39 c3                	cmp    %eax,%ebx
80103642:	75 ec                	jne    80103630 <mycpu+0x30>
80103644:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
8010364a:	83 c4 10             	add    $0x10,%esp
8010364d:	5b                   	pop    %ebx
8010364e:	5e                   	pop    %esi
8010364f:	5d                   	pop    %ebp
80103650:	05 80 27 11 80       	add    $0x80112780,%eax
80103655:	c3                   	ret    
80103656:	31 d2                	xor    %edx,%edx
80103658:	eb ea                	jmp    80103644 <mycpu+0x44>
8010365a:	c7 04 24 9c 71 10 80 	movl   $0x8010719c,(%esp)
80103661:	e8 fa cc ff ff       	call   80100360 <panic>
80103666:	c7 04 24 78 72 10 80 	movl   $0x80107278,(%esp)
8010366d:	e8 ee cc ff ff       	call   80100360 <panic>
80103672:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103679:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103680 <cpuid>:
80103680:	55                   	push   %ebp
80103681:	89 e5                	mov    %esp,%ebp
80103683:	83 ec 08             	sub    $0x8,%esp
80103686:	e8 75 ff ff ff       	call   80103600 <mycpu>
8010368b:	c9                   	leave  
8010368c:	2d 80 27 11 80       	sub    $0x80112780,%eax
80103691:	c1 f8 04             	sar    $0x4,%eax
80103694:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
8010369a:	c3                   	ret    
8010369b:	90                   	nop
8010369c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801036a0 <myproc>:
801036a0:	55                   	push   %ebp
801036a1:	89 e5                	mov    %esp,%ebp
801036a3:	53                   	push   %ebx
801036a4:	83 ec 04             	sub    $0x4,%esp
801036a7:	e8 54 0a 00 00       	call   80104100 <pushcli>
801036ac:	e8 4f ff ff ff       	call   80103600 <mycpu>
801036b1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
801036b7:	e8 04 0b 00 00       	call   801041c0 <popcli>
801036bc:	83 c4 04             	add    $0x4,%esp
801036bf:	89 d8                	mov    %ebx,%eax
801036c1:	5b                   	pop    %ebx
801036c2:	5d                   	pop    %ebp
801036c3:	c3                   	ret    
801036c4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801036ca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801036d0 <userinit>:
801036d0:	55                   	push   %ebp
801036d1:	89 e5                	mov    %esp,%ebp
801036d3:	53                   	push   %ebx
801036d4:	83 ec 14             	sub    $0x14,%esp
801036d7:	e8 e4 fd ff ff       	call   801034c0 <allocproc>
801036dc:	89 c3                	mov    %eax,%ebx
801036de:	a3 b8 a5 10 80       	mov    %eax,0x8010a5b8
801036e3:	e8 a8 32 00 00       	call   80106990 <setupkvm>
801036e8:	85 c0                	test   %eax,%eax
801036ea:	89 43 04             	mov    %eax,0x4(%ebx)
801036ed:	0f 84 d4 00 00 00    	je     801037c7 <userinit+0xf7>
801036f3:	89 04 24             	mov    %eax,(%esp)
801036f6:	c7 44 24 08 2c 00 00 	movl   $0x2c,0x8(%esp)
801036fd:	00 
801036fe:	c7 44 24 04 60 a4 10 	movl   $0x8010a460,0x4(%esp)
80103705:	80 
80103706:	e8 b5 2f 00 00       	call   801066c0 <inituvm>
8010370b:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
80103711:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
80103718:	00 
80103719:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80103720:	00 
80103721:	8b 43 18             	mov    0x18(%ebx),%eax
80103724:	89 04 24             	mov    %eax,(%esp)
80103727:	e8 54 0b 00 00       	call   80104280 <memset>
8010372c:	8b 43 18             	mov    0x18(%ebx),%eax
8010372f:	b9 1b 00 00 00       	mov    $0x1b,%ecx
80103734:	ba 23 00 00 00       	mov    $0x23,%edx
80103739:	66 89 48 3c          	mov    %cx,0x3c(%eax)
8010373d:	8b 43 18             	mov    0x18(%ebx),%eax
80103740:	66 89 50 2c          	mov    %dx,0x2c(%eax)
80103744:	8b 43 18             	mov    0x18(%ebx),%eax
80103747:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
8010374b:	66 89 50 28          	mov    %dx,0x28(%eax)
8010374f:	8b 43 18             	mov    0x18(%ebx),%eax
80103752:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103756:	66 89 50 48          	mov    %dx,0x48(%eax)
8010375a:	8b 43 18             	mov    0x18(%ebx),%eax
8010375d:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
80103764:	8b 43 18             	mov    0x18(%ebx),%eax
80103767:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
8010376e:	8b 43 18             	mov    0x18(%ebx),%eax
80103771:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
80103778:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010377b:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80103782:	00 
80103783:	c7 44 24 04 c5 71 10 	movl   $0x801071c5,0x4(%esp)
8010378a:	80 
8010378b:	89 04 24             	mov    %eax,(%esp)
8010378e:	e8 cd 0c 00 00       	call   80104460 <safestrcpy>
80103793:	c7 04 24 ce 71 10 80 	movl   $0x801071ce,(%esp)
8010379a:	e8 71 e7 ff ff       	call   80101f10 <namei>
8010379f:	89 43 68             	mov    %eax,0x68(%ebx)
801037a2:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801037a9:	e8 92 09 00 00       	call   80104140 <acquire>
801037ae:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
801037b5:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801037bc:	e8 6f 0a 00 00       	call   80104230 <release>
801037c1:	83 c4 14             	add    $0x14,%esp
801037c4:	5b                   	pop    %ebx
801037c5:	5d                   	pop    %ebp
801037c6:	c3                   	ret    
801037c7:	c7 04 24 ac 71 10 80 	movl   $0x801071ac,(%esp)
801037ce:	e8 8d cb ff ff       	call   80100360 <panic>
801037d3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801037d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801037e0 <growproc>:
801037e0:	55                   	push   %ebp
801037e1:	89 e5                	mov    %esp,%ebp
801037e3:	56                   	push   %esi
801037e4:	53                   	push   %ebx
801037e5:	83 ec 10             	sub    $0x10,%esp
801037e8:	8b 75 08             	mov    0x8(%ebp),%esi
801037eb:	e8 b0 fe ff ff       	call   801036a0 <myproc>
801037f0:	83 fe 00             	cmp    $0x0,%esi
801037f3:	89 c3                	mov    %eax,%ebx
801037f5:	8b 00                	mov    (%eax),%eax
801037f7:	7e 2f                	jle    80103828 <growproc+0x48>
801037f9:	01 c6                	add    %eax,%esi
801037fb:	89 74 24 08          	mov    %esi,0x8(%esp)
801037ff:	89 44 24 04          	mov    %eax,0x4(%esp)
80103803:	8b 43 04             	mov    0x4(%ebx),%eax
80103806:	89 04 24             	mov    %eax,(%esp)
80103809:	e8 f2 2f 00 00       	call   80106800 <allocuvm>
8010380e:	85 c0                	test   %eax,%eax
80103810:	74 36                	je     80103848 <growproc+0x68>
80103812:	89 03                	mov    %eax,(%ebx)
80103814:	89 1c 24             	mov    %ebx,(%esp)
80103817:	e8 94 2d 00 00       	call   801065b0 <switchuvm>
8010381c:	31 c0                	xor    %eax,%eax
8010381e:	83 c4 10             	add    $0x10,%esp
80103821:	5b                   	pop    %ebx
80103822:	5e                   	pop    %esi
80103823:	5d                   	pop    %ebp
80103824:	c3                   	ret    
80103825:	8d 76 00             	lea    0x0(%esi),%esi
80103828:	74 e8                	je     80103812 <growproc+0x32>
8010382a:	01 c6                	add    %eax,%esi
8010382c:	89 74 24 08          	mov    %esi,0x8(%esp)
80103830:	89 44 24 04          	mov    %eax,0x4(%esp)
80103834:	8b 43 04             	mov    0x4(%ebx),%eax
80103837:	89 04 24             	mov    %eax,(%esp)
8010383a:	e8 b1 30 00 00       	call   801068f0 <deallocuvm>
8010383f:	85 c0                	test   %eax,%eax
80103841:	75 cf                	jne    80103812 <growproc+0x32>
80103843:	90                   	nop
80103844:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103848:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010384d:	eb cf                	jmp    8010381e <growproc+0x3e>
8010384f:	90                   	nop

80103850 <fork>:
80103850:	55                   	push   %ebp
80103851:	89 e5                	mov    %esp,%ebp
80103853:	57                   	push   %edi
80103854:	56                   	push   %esi
80103855:	53                   	push   %ebx
80103856:	83 ec 1c             	sub    $0x1c,%esp
80103859:	e8 42 fe ff ff       	call   801036a0 <myproc>
8010385e:	89 c3                	mov    %eax,%ebx
80103860:	e8 5b fc ff ff       	call   801034c0 <allocproc>
80103865:	85 c0                	test   %eax,%eax
80103867:	89 c7                	mov    %eax,%edi
80103869:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010386c:	0f 84 bc 00 00 00    	je     8010392e <fork+0xde>
80103872:	8b 03                	mov    (%ebx),%eax
80103874:	89 44 24 04          	mov    %eax,0x4(%esp)
80103878:	8b 43 04             	mov    0x4(%ebx),%eax
8010387b:	89 04 24             	mov    %eax,(%esp)
8010387e:	e8 ed 31 00 00       	call   80106a70 <copyuvm>
80103883:	85 c0                	test   %eax,%eax
80103885:	89 47 04             	mov    %eax,0x4(%edi)
80103888:	0f 84 a7 00 00 00    	je     80103935 <fork+0xe5>
8010388e:	8b 03                	mov    (%ebx),%eax
80103890:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103893:	89 01                	mov    %eax,(%ecx)
80103895:	8b 79 18             	mov    0x18(%ecx),%edi
80103898:	89 c8                	mov    %ecx,%eax
8010389a:	89 59 14             	mov    %ebx,0x14(%ecx)
8010389d:	8b 73 18             	mov    0x18(%ebx),%esi
801038a0:	b9 13 00 00 00       	mov    $0x13,%ecx
801038a5:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
801038a7:	31 f6                	xor    %esi,%esi
801038a9:	8b 40 18             	mov    0x18(%eax),%eax
801038ac:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
801038b3:	90                   	nop
801038b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801038b8:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
801038bc:	85 c0                	test   %eax,%eax
801038be:	74 0f                	je     801038cf <fork+0x7f>
801038c0:	89 04 24             	mov    %eax,(%esp)
801038c3:	e8 18 d5 ff ff       	call   80100de0 <filedup>
801038c8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801038cb:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
801038cf:	83 c6 01             	add    $0x1,%esi
801038d2:	83 fe 10             	cmp    $0x10,%esi
801038d5:	75 e1                	jne    801038b8 <fork+0x68>
801038d7:	8b 43 68             	mov    0x68(%ebx),%eax
801038da:	83 c3 6c             	add    $0x6c,%ebx
801038dd:	89 04 24             	mov    %eax,(%esp)
801038e0:	e8 ab dd ff ff       	call   80101690 <idup>
801038e5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801038e8:	89 47 68             	mov    %eax,0x68(%edi)
801038eb:	8d 47 6c             	lea    0x6c(%edi),%eax
801038ee:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801038f2:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
801038f9:	00 
801038fa:	89 04 24             	mov    %eax,(%esp)
801038fd:	e8 5e 0b 00 00       	call   80104460 <safestrcpy>
80103902:	8b 5f 10             	mov    0x10(%edi),%ebx
80103905:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010390c:	e8 2f 08 00 00       	call   80104140 <acquire>
80103911:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
80103918:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010391f:	e8 0c 09 00 00       	call   80104230 <release>
80103924:	89 d8                	mov    %ebx,%eax
80103926:	83 c4 1c             	add    $0x1c,%esp
80103929:	5b                   	pop    %ebx
8010392a:	5e                   	pop    %esi
8010392b:	5f                   	pop    %edi
8010392c:	5d                   	pop    %ebp
8010392d:	c3                   	ret    
8010392e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103933:	eb f1                	jmp    80103926 <fork+0xd6>
80103935:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103938:	8b 47 08             	mov    0x8(%edi),%eax
8010393b:	89 04 24             	mov    %eax,(%esp)
8010393e:	e8 bd e9 ff ff       	call   80102300 <kfree>
80103943:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103948:	c7 47 08 00 00 00 00 	movl   $0x0,0x8(%edi)
8010394f:	c7 47 0c 00 00 00 00 	movl   $0x0,0xc(%edi)
80103956:	eb ce                	jmp    80103926 <fork+0xd6>
80103958:	90                   	nop
80103959:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103960 <scheduler>:
80103960:	55                   	push   %ebp
80103961:	89 e5                	mov    %esp,%ebp
80103963:	57                   	push   %edi
80103964:	56                   	push   %esi
80103965:	53                   	push   %ebx
80103966:	83 ec 1c             	sub    $0x1c,%esp
80103969:	e8 92 fc ff ff       	call   80103600 <mycpu>
8010396e:	89 c6                	mov    %eax,%esi
80103970:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103977:	00 00 00 
8010397a:	8d 78 04             	lea    0x4(%eax),%edi
8010397d:	8d 76 00             	lea    0x0(%esi),%esi
80103980:	fb                   	sti    
80103981:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103988:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
8010398d:	e8 ae 07 00 00       	call   80104140 <acquire>
80103992:	eb 0f                	jmp    801039a3 <scheduler+0x43>
80103994:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103998:	83 c3 7c             	add    $0x7c,%ebx
8010399b:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
801039a1:	74 45                	je     801039e8 <scheduler+0x88>
801039a3:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
801039a7:	75 ef                	jne    80103998 <scheduler+0x38>
801039a9:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
801039af:	89 1c 24             	mov    %ebx,(%esp)
801039b2:	83 c3 7c             	add    $0x7c,%ebx
801039b5:	e8 f6 2b 00 00       	call   801065b0 <switchuvm>
801039ba:	8b 43 a0             	mov    -0x60(%ebx),%eax
801039bd:	c7 43 90 04 00 00 00 	movl   $0x4,-0x70(%ebx)
801039c4:	89 3c 24             	mov    %edi,(%esp)
801039c7:	89 44 24 04          	mov    %eax,0x4(%esp)
801039cb:	e8 ec 0a 00 00       	call   801044bc <swtch>
801039d0:	e8 bb 2b 00 00       	call   80106590 <switchkvm>
801039d5:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
801039db:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
801039e2:	00 00 00 
801039e5:	75 bc                	jne    801039a3 <scheduler+0x43>
801039e7:	90                   	nop
801039e8:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801039ef:	e8 3c 08 00 00       	call   80104230 <release>
801039f4:	eb 8a                	jmp    80103980 <scheduler+0x20>
801039f6:	8d 76 00             	lea    0x0(%esi),%esi
801039f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103a00 <sched>:
80103a00:	55                   	push   %ebp
80103a01:	89 e5                	mov    %esp,%ebp
80103a03:	56                   	push   %esi
80103a04:	53                   	push   %ebx
80103a05:	83 ec 10             	sub    $0x10,%esp
80103a08:	e8 93 fc ff ff       	call   801036a0 <myproc>
80103a0d:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103a14:	89 c3                	mov    %eax,%ebx
80103a16:	e8 b5 06 00 00       	call   801040d0 <holding>
80103a1b:	85 c0                	test   %eax,%eax
80103a1d:	74 4f                	je     80103a6e <sched+0x6e>
80103a1f:	e8 dc fb ff ff       	call   80103600 <mycpu>
80103a24:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103a2b:	75 65                	jne    80103a92 <sched+0x92>
80103a2d:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103a31:	74 53                	je     80103a86 <sched+0x86>
80103a33:	9c                   	pushf  
80103a34:	58                   	pop    %eax
80103a35:	f6 c4 02             	test   $0x2,%ah
80103a38:	75 40                	jne    80103a7a <sched+0x7a>
80103a3a:	e8 c1 fb ff ff       	call   80103600 <mycpu>
80103a3f:	83 c3 1c             	add    $0x1c,%ebx
80103a42:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
80103a48:	e8 b3 fb ff ff       	call   80103600 <mycpu>
80103a4d:	8b 40 04             	mov    0x4(%eax),%eax
80103a50:	89 1c 24             	mov    %ebx,(%esp)
80103a53:	89 44 24 04          	mov    %eax,0x4(%esp)
80103a57:	e8 60 0a 00 00       	call   801044bc <swtch>
80103a5c:	e8 9f fb ff ff       	call   80103600 <mycpu>
80103a61:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
80103a67:	83 c4 10             	add    $0x10,%esp
80103a6a:	5b                   	pop    %ebx
80103a6b:	5e                   	pop    %esi
80103a6c:	5d                   	pop    %ebp
80103a6d:	c3                   	ret    
80103a6e:	c7 04 24 d0 71 10 80 	movl   $0x801071d0,(%esp)
80103a75:	e8 e6 c8 ff ff       	call   80100360 <panic>
80103a7a:	c7 04 24 fc 71 10 80 	movl   $0x801071fc,(%esp)
80103a81:	e8 da c8 ff ff       	call   80100360 <panic>
80103a86:	c7 04 24 ee 71 10 80 	movl   $0x801071ee,(%esp)
80103a8d:	e8 ce c8 ff ff       	call   80100360 <panic>
80103a92:	c7 04 24 e2 71 10 80 	movl   $0x801071e2,(%esp)
80103a99:	e8 c2 c8 ff ff       	call   80100360 <panic>
80103a9e:	66 90                	xchg   %ax,%ax

80103aa0 <exit>:
80103aa0:	55                   	push   %ebp
80103aa1:	89 e5                	mov    %esp,%ebp
80103aa3:	56                   	push   %esi
80103aa4:	31 f6                	xor    %esi,%esi
80103aa6:	53                   	push   %ebx
80103aa7:	83 ec 10             	sub    $0x10,%esp
80103aaa:	e8 f1 fb ff ff       	call   801036a0 <myproc>
80103aaf:	3b 05 b8 a5 10 80    	cmp    0x8010a5b8,%eax
80103ab5:	89 c3                	mov    %eax,%ebx
80103ab7:	0f 84 ea 00 00 00    	je     80103ba7 <exit+0x107>
80103abd:	8d 76 00             	lea    0x0(%esi),%esi
80103ac0:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103ac4:	85 c0                	test   %eax,%eax
80103ac6:	74 10                	je     80103ad8 <exit+0x38>
80103ac8:	89 04 24             	mov    %eax,(%esp)
80103acb:	e8 60 d3 ff ff       	call   80100e30 <fileclose>
80103ad0:	c7 44 b3 28 00 00 00 	movl   $0x0,0x28(%ebx,%esi,4)
80103ad7:	00 
80103ad8:	83 c6 01             	add    $0x1,%esi
80103adb:	83 fe 10             	cmp    $0x10,%esi
80103ade:	75 e0                	jne    80103ac0 <exit+0x20>
80103ae0:	e8 2b f0 ff ff       	call   80102b10 <begin_op>
80103ae5:	8b 43 68             	mov    0x68(%ebx),%eax
80103ae8:	89 04 24             	mov    %eax,(%esp)
80103aeb:	e8 f0 dc ff ff       	call   801017e0 <iput>
80103af0:	e8 8b f0 ff ff       	call   80102b80 <end_op>
80103af5:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
80103afc:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103b03:	e8 38 06 00 00       	call   80104140 <acquire>
80103b08:	8b 43 14             	mov    0x14(%ebx),%eax
80103b0b:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103b10:	eb 11                	jmp    80103b23 <exit+0x83>
80103b12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103b18:	83 c2 7c             	add    $0x7c,%edx
80103b1b:	81 fa 54 4c 11 80    	cmp    $0x80114c54,%edx
80103b21:	74 1d                	je     80103b40 <exit+0xa0>
80103b23:	83 7a 0c 02          	cmpl   $0x2,0xc(%edx)
80103b27:	75 ef                	jne    80103b18 <exit+0x78>
80103b29:	3b 42 20             	cmp    0x20(%edx),%eax
80103b2c:	75 ea                	jne    80103b18 <exit+0x78>
80103b2e:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
80103b35:	83 c2 7c             	add    $0x7c,%edx
80103b38:	81 fa 54 4c 11 80    	cmp    $0x80114c54,%edx
80103b3e:	75 e3                	jne    80103b23 <exit+0x83>
80103b40:	a1 b8 a5 10 80       	mov    0x8010a5b8,%eax
80103b45:	b9 54 2d 11 80       	mov    $0x80112d54,%ecx
80103b4a:	eb 0f                	jmp    80103b5b <exit+0xbb>
80103b4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103b50:	83 c1 7c             	add    $0x7c,%ecx
80103b53:	81 f9 54 4c 11 80    	cmp    $0x80114c54,%ecx
80103b59:	74 34                	je     80103b8f <exit+0xef>
80103b5b:	39 59 14             	cmp    %ebx,0x14(%ecx)
80103b5e:	75 f0                	jne    80103b50 <exit+0xb0>
80103b60:	83 79 0c 05          	cmpl   $0x5,0xc(%ecx)
80103b64:	89 41 14             	mov    %eax,0x14(%ecx)
80103b67:	75 e7                	jne    80103b50 <exit+0xb0>
80103b69:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103b6e:	eb 0b                	jmp    80103b7b <exit+0xdb>
80103b70:	83 c2 7c             	add    $0x7c,%edx
80103b73:	81 fa 54 4c 11 80    	cmp    $0x80114c54,%edx
80103b79:	74 d5                	je     80103b50 <exit+0xb0>
80103b7b:	83 7a 0c 02          	cmpl   $0x2,0xc(%edx)
80103b7f:	75 ef                	jne    80103b70 <exit+0xd0>
80103b81:	3b 42 20             	cmp    0x20(%edx),%eax
80103b84:	75 ea                	jne    80103b70 <exit+0xd0>
80103b86:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
80103b8d:	eb e1                	jmp    80103b70 <exit+0xd0>
80103b8f:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
80103b96:	e8 65 fe ff ff       	call   80103a00 <sched>
80103b9b:	c7 04 24 1d 72 10 80 	movl   $0x8010721d,(%esp)
80103ba2:	e8 b9 c7 ff ff       	call   80100360 <panic>
80103ba7:	c7 04 24 10 72 10 80 	movl   $0x80107210,(%esp)
80103bae:	e8 ad c7 ff ff       	call   80100360 <panic>
80103bb3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103bb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103bc0 <yield>:
80103bc0:	55                   	push   %ebp
80103bc1:	89 e5                	mov    %esp,%ebp
80103bc3:	83 ec 18             	sub    $0x18,%esp
80103bc6:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103bcd:	e8 6e 05 00 00       	call   80104140 <acquire>
80103bd2:	e8 c9 fa ff ff       	call   801036a0 <myproc>
80103bd7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103bde:	e8 1d fe ff ff       	call   80103a00 <sched>
80103be3:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103bea:	e8 41 06 00 00       	call   80104230 <release>
80103bef:	c9                   	leave  
80103bf0:	c3                   	ret    
80103bf1:	eb 0d                	jmp    80103c00 <sleep>
80103bf3:	90                   	nop
80103bf4:	90                   	nop
80103bf5:	90                   	nop
80103bf6:	90                   	nop
80103bf7:	90                   	nop
80103bf8:	90                   	nop
80103bf9:	90                   	nop
80103bfa:	90                   	nop
80103bfb:	90                   	nop
80103bfc:	90                   	nop
80103bfd:	90                   	nop
80103bfe:	90                   	nop
80103bff:	90                   	nop

80103c00 <sleep>:
80103c00:	55                   	push   %ebp
80103c01:	89 e5                	mov    %esp,%ebp
80103c03:	57                   	push   %edi
80103c04:	56                   	push   %esi
80103c05:	53                   	push   %ebx
80103c06:	83 ec 1c             	sub    $0x1c,%esp
80103c09:	8b 7d 08             	mov    0x8(%ebp),%edi
80103c0c:	8b 75 0c             	mov    0xc(%ebp),%esi
80103c0f:	e8 8c fa ff ff       	call   801036a0 <myproc>
80103c14:	85 c0                	test   %eax,%eax
80103c16:	89 c3                	mov    %eax,%ebx
80103c18:	0f 84 7c 00 00 00    	je     80103c9a <sleep+0x9a>
80103c1e:	85 f6                	test   %esi,%esi
80103c20:	74 6c                	je     80103c8e <sleep+0x8e>
80103c22:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
80103c28:	74 46                	je     80103c70 <sleep+0x70>
80103c2a:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103c31:	e8 0a 05 00 00       	call   80104140 <acquire>
80103c36:	89 34 24             	mov    %esi,(%esp)
80103c39:	e8 f2 05 00 00       	call   80104230 <release>
80103c3e:	89 7b 20             	mov    %edi,0x20(%ebx)
80103c41:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
80103c48:	e8 b3 fd ff ff       	call   80103a00 <sched>
80103c4d:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
80103c54:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103c5b:	e8 d0 05 00 00       	call   80104230 <release>
80103c60:	89 75 08             	mov    %esi,0x8(%ebp)
80103c63:	83 c4 1c             	add    $0x1c,%esp
80103c66:	5b                   	pop    %ebx
80103c67:	5e                   	pop    %esi
80103c68:	5f                   	pop    %edi
80103c69:	5d                   	pop    %ebp
80103c6a:	e9 d1 04 00 00       	jmp    80104140 <acquire>
80103c6f:	90                   	nop
80103c70:	89 78 20             	mov    %edi,0x20(%eax)
80103c73:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
80103c7a:	e8 81 fd ff ff       	call   80103a00 <sched>
80103c7f:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
80103c86:	83 c4 1c             	add    $0x1c,%esp
80103c89:	5b                   	pop    %ebx
80103c8a:	5e                   	pop    %esi
80103c8b:	5f                   	pop    %edi
80103c8c:	5d                   	pop    %ebp
80103c8d:	c3                   	ret    
80103c8e:	c7 04 24 2f 72 10 80 	movl   $0x8010722f,(%esp)
80103c95:	e8 c6 c6 ff ff       	call   80100360 <panic>
80103c9a:	c7 04 24 29 72 10 80 	movl   $0x80107229,(%esp)
80103ca1:	e8 ba c6 ff ff       	call   80100360 <panic>
80103ca6:	8d 76 00             	lea    0x0(%esi),%esi
80103ca9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103cb0 <wait>:
80103cb0:	55                   	push   %ebp
80103cb1:	89 e5                	mov    %esp,%ebp
80103cb3:	56                   	push   %esi
80103cb4:	53                   	push   %ebx
80103cb5:	83 ec 10             	sub    $0x10,%esp
80103cb8:	e8 e3 f9 ff ff       	call   801036a0 <myproc>
80103cbd:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103cc4:	89 c6                	mov    %eax,%esi
80103cc6:	e8 75 04 00 00       	call   80104140 <acquire>
80103ccb:	31 c0                	xor    %eax,%eax
80103ccd:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80103cd2:	eb 0f                	jmp    80103ce3 <wait+0x33>
80103cd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103cd8:	83 c3 7c             	add    $0x7c,%ebx
80103cdb:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
80103ce1:	74 1d                	je     80103d00 <wait+0x50>
80103ce3:	39 73 14             	cmp    %esi,0x14(%ebx)
80103ce6:	75 f0                	jne    80103cd8 <wait+0x28>
80103ce8:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103cec:	74 2f                	je     80103d1d <wait+0x6d>
80103cee:	83 c3 7c             	add    $0x7c,%ebx
80103cf1:	b8 01 00 00 00       	mov    $0x1,%eax
80103cf6:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
80103cfc:	75 e5                	jne    80103ce3 <wait+0x33>
80103cfe:	66 90                	xchg   %ax,%ax
80103d00:	85 c0                	test   %eax,%eax
80103d02:	74 6e                	je     80103d72 <wait+0xc2>
80103d04:	8b 4e 24             	mov    0x24(%esi),%ecx
80103d07:	85 c9                	test   %ecx,%ecx
80103d09:	75 67                	jne    80103d72 <wait+0xc2>
80103d0b:	c7 44 24 04 20 2d 11 	movl   $0x80112d20,0x4(%esp)
80103d12:	80 
80103d13:	89 34 24             	mov    %esi,(%esp)
80103d16:	e8 e5 fe ff ff       	call   80103c00 <sleep>
80103d1b:	eb ae                	jmp    80103ccb <wait+0x1b>
80103d1d:	8b 43 08             	mov    0x8(%ebx),%eax
80103d20:	8b 73 10             	mov    0x10(%ebx),%esi
80103d23:	89 04 24             	mov    %eax,(%esp)
80103d26:	e8 d5 e5 ff ff       	call   80102300 <kfree>
80103d2b:	8b 43 04             	mov    0x4(%ebx),%eax
80103d2e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
80103d35:	89 04 24             	mov    %eax,(%esp)
80103d38:	e8 d3 2b 00 00       	call   80106910 <freevm>
80103d3d:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103d44:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
80103d4b:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
80103d52:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
80103d56:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
80103d5d:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
80103d64:	e8 c7 04 00 00       	call   80104230 <release>
80103d69:	83 c4 10             	add    $0x10,%esp
80103d6c:	89 f0                	mov    %esi,%eax
80103d6e:	5b                   	pop    %ebx
80103d6f:	5e                   	pop    %esi
80103d70:	5d                   	pop    %ebp
80103d71:	c3                   	ret    
80103d72:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103d79:	e8 b2 04 00 00       	call   80104230 <release>
80103d7e:	83 c4 10             	add    $0x10,%esp
80103d81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103d86:	5b                   	pop    %ebx
80103d87:	5e                   	pop    %esi
80103d88:	5d                   	pop    %ebp
80103d89:	c3                   	ret    
80103d8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103d90 <wakeup>:
80103d90:	55                   	push   %ebp
80103d91:	89 e5                	mov    %esp,%ebp
80103d93:	53                   	push   %ebx
80103d94:	83 ec 14             	sub    $0x14,%esp
80103d97:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103d9a:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103da1:	e8 9a 03 00 00       	call   80104140 <acquire>
80103da6:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103dab:	eb 0d                	jmp    80103dba <wakeup+0x2a>
80103dad:	8d 76 00             	lea    0x0(%esi),%esi
80103db0:	83 c0 7c             	add    $0x7c,%eax
80103db3:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80103db8:	74 1e                	je     80103dd8 <wakeup+0x48>
80103dba:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103dbe:	75 f0                	jne    80103db0 <wakeup+0x20>
80103dc0:	3b 58 20             	cmp    0x20(%eax),%ebx
80103dc3:	75 eb                	jne    80103db0 <wakeup+0x20>
80103dc5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103dcc:	83 c0 7c             	add    $0x7c,%eax
80103dcf:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80103dd4:	75 e4                	jne    80103dba <wakeup+0x2a>
80103dd6:	66 90                	xchg   %ax,%ax
80103dd8:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
80103ddf:	83 c4 14             	add    $0x14,%esp
80103de2:	5b                   	pop    %ebx
80103de3:	5d                   	pop    %ebp
80103de4:	e9 47 04 00 00       	jmp    80104230 <release>
80103de9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103df0 <kill>:
80103df0:	55                   	push   %ebp
80103df1:	89 e5                	mov    %esp,%ebp
80103df3:	53                   	push   %ebx
80103df4:	83 ec 14             	sub    $0x14,%esp
80103df7:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103dfa:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103e01:	e8 3a 03 00 00       	call   80104140 <acquire>
80103e06:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103e0b:	eb 0d                	jmp    80103e1a <kill+0x2a>
80103e0d:	8d 76 00             	lea    0x0(%esi),%esi
80103e10:	83 c0 7c             	add    $0x7c,%eax
80103e13:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80103e18:	74 36                	je     80103e50 <kill+0x60>
80103e1a:	39 58 10             	cmp    %ebx,0x10(%eax)
80103e1d:	75 f1                	jne    80103e10 <kill+0x20>
80103e1f:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103e23:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80103e2a:	74 14                	je     80103e40 <kill+0x50>
80103e2c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103e33:	e8 f8 03 00 00       	call   80104230 <release>
80103e38:	83 c4 14             	add    $0x14,%esp
80103e3b:	31 c0                	xor    %eax,%eax
80103e3d:	5b                   	pop    %ebx
80103e3e:	5d                   	pop    %ebp
80103e3f:	c3                   	ret    
80103e40:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103e47:	eb e3                	jmp    80103e2c <kill+0x3c>
80103e49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e50:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103e57:	e8 d4 03 00 00       	call   80104230 <release>
80103e5c:	83 c4 14             	add    $0x14,%esp
80103e5f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103e64:	5b                   	pop    %ebx
80103e65:	5d                   	pop    %ebp
80103e66:	c3                   	ret    
80103e67:	89 f6                	mov    %esi,%esi
80103e69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103e70 <procdump>:
80103e70:	55                   	push   %ebp
80103e71:	89 e5                	mov    %esp,%ebp
80103e73:	57                   	push   %edi
80103e74:	56                   	push   %esi
80103e75:	53                   	push   %ebx
80103e76:	bb c0 2d 11 80       	mov    $0x80112dc0,%ebx
80103e7b:	83 ec 4c             	sub    $0x4c,%esp
80103e7e:	8d 75 e8             	lea    -0x18(%ebp),%esi
80103e81:	eb 20                	jmp    80103ea3 <procdump+0x33>
80103e83:	90                   	nop
80103e84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e88:	c7 04 24 77 76 10 80 	movl   $0x80107677,(%esp)
80103e8f:	e8 bc c7 ff ff       	call   80100650 <cprintf>
80103e94:	83 c3 7c             	add    $0x7c,%ebx
80103e97:	81 fb c0 4c 11 80    	cmp    $0x80114cc0,%ebx
80103e9d:	0f 84 8d 00 00 00    	je     80103f30 <procdump+0xc0>
80103ea3:	8b 43 a0             	mov    -0x60(%ebx),%eax
80103ea6:	85 c0                	test   %eax,%eax
80103ea8:	74 ea                	je     80103e94 <procdump+0x24>
80103eaa:	83 f8 05             	cmp    $0x5,%eax
80103ead:	ba 40 72 10 80       	mov    $0x80107240,%edx
80103eb2:	77 11                	ja     80103ec5 <procdump+0x55>
80103eb4:	8b 14 85 a0 72 10 80 	mov    -0x7fef8d60(,%eax,4),%edx
80103ebb:	b8 40 72 10 80       	mov    $0x80107240,%eax
80103ec0:	85 d2                	test   %edx,%edx
80103ec2:	0f 44 d0             	cmove  %eax,%edx
80103ec5:	8b 43 a4             	mov    -0x5c(%ebx),%eax
80103ec8:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
80103ecc:	89 54 24 08          	mov    %edx,0x8(%esp)
80103ed0:	c7 04 24 44 72 10 80 	movl   $0x80107244,(%esp)
80103ed7:	89 44 24 04          	mov    %eax,0x4(%esp)
80103edb:	e8 70 c7 ff ff       	call   80100650 <cprintf>
80103ee0:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80103ee4:	75 a2                	jne    80103e88 <procdump+0x18>
80103ee6:	8d 45 c0             	lea    -0x40(%ebp),%eax
80103ee9:	89 44 24 04          	mov    %eax,0x4(%esp)
80103eed:	8b 43 b0             	mov    -0x50(%ebx),%eax
80103ef0:	8d 7d c0             	lea    -0x40(%ebp),%edi
80103ef3:	8b 40 0c             	mov    0xc(%eax),%eax
80103ef6:	83 c0 08             	add    $0x8,%eax
80103ef9:	89 04 24             	mov    %eax,(%esp)
80103efc:	e8 6f 01 00 00       	call   80104070 <getcallerpcs>
80103f01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f08:	8b 17                	mov    (%edi),%edx
80103f0a:	85 d2                	test   %edx,%edx
80103f0c:	0f 84 76 ff ff ff    	je     80103e88 <procdump+0x18>
80103f12:	89 54 24 04          	mov    %edx,0x4(%esp)
80103f16:	83 c7 04             	add    $0x4,%edi
80103f19:	c7 04 24 81 6c 10 80 	movl   $0x80106c81,(%esp)
80103f20:	e8 2b c7 ff ff       	call   80100650 <cprintf>
80103f25:	39 f7                	cmp    %esi,%edi
80103f27:	75 df                	jne    80103f08 <procdump+0x98>
80103f29:	e9 5a ff ff ff       	jmp    80103e88 <procdump+0x18>
80103f2e:	66 90                	xchg   %ax,%ax
80103f30:	83 c4 4c             	add    $0x4c,%esp
80103f33:	5b                   	pop    %ebx
80103f34:	5e                   	pop    %esi
80103f35:	5f                   	pop    %edi
80103f36:	5d                   	pop    %ebp
80103f37:	c3                   	ret    
	...

80103f40 <initsleeplock>:
80103f40:	55                   	push   %ebp
80103f41:	89 e5                	mov    %esp,%ebp
80103f43:	53                   	push   %ebx
80103f44:	83 ec 14             	sub    $0x14,%esp
80103f47:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103f4a:	c7 44 24 04 b8 72 10 	movl   $0x801072b8,0x4(%esp)
80103f51:	80 
80103f52:	8d 43 04             	lea    0x4(%ebx),%eax
80103f55:	89 04 24             	mov    %eax,(%esp)
80103f58:	e8 f3 00 00 00       	call   80104050 <initlock>
80103f5d:	8b 45 0c             	mov    0xc(%ebp),%eax
80103f60:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103f66:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
80103f6d:	89 43 38             	mov    %eax,0x38(%ebx)
80103f70:	83 c4 14             	add    $0x14,%esp
80103f73:	5b                   	pop    %ebx
80103f74:	5d                   	pop    %ebp
80103f75:	c3                   	ret    
80103f76:	8d 76 00             	lea    0x0(%esi),%esi
80103f79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103f80 <acquiresleep>:
80103f80:	55                   	push   %ebp
80103f81:	89 e5                	mov    %esp,%ebp
80103f83:	56                   	push   %esi
80103f84:	53                   	push   %ebx
80103f85:	83 ec 10             	sub    $0x10,%esp
80103f88:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103f8b:	8d 73 04             	lea    0x4(%ebx),%esi
80103f8e:	89 34 24             	mov    %esi,(%esp)
80103f91:	e8 aa 01 00 00       	call   80104140 <acquire>
80103f96:	8b 13                	mov    (%ebx),%edx
80103f98:	85 d2                	test   %edx,%edx
80103f9a:	74 16                	je     80103fb2 <acquiresleep+0x32>
80103f9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103fa0:	89 74 24 04          	mov    %esi,0x4(%esp)
80103fa4:	89 1c 24             	mov    %ebx,(%esp)
80103fa7:	e8 54 fc ff ff       	call   80103c00 <sleep>
80103fac:	8b 03                	mov    (%ebx),%eax
80103fae:	85 c0                	test   %eax,%eax
80103fb0:	75 ee                	jne    80103fa0 <acquiresleep+0x20>
80103fb2:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
80103fb8:	e8 e3 f6 ff ff       	call   801036a0 <myproc>
80103fbd:	8b 40 10             	mov    0x10(%eax),%eax
80103fc0:	89 43 3c             	mov    %eax,0x3c(%ebx)
80103fc3:	89 75 08             	mov    %esi,0x8(%ebp)
80103fc6:	83 c4 10             	add    $0x10,%esp
80103fc9:	5b                   	pop    %ebx
80103fca:	5e                   	pop    %esi
80103fcb:	5d                   	pop    %ebp
80103fcc:	e9 5f 02 00 00       	jmp    80104230 <release>
80103fd1:	eb 0d                	jmp    80103fe0 <releasesleep>
80103fd3:	90                   	nop
80103fd4:	90                   	nop
80103fd5:	90                   	nop
80103fd6:	90                   	nop
80103fd7:	90                   	nop
80103fd8:	90                   	nop
80103fd9:	90                   	nop
80103fda:	90                   	nop
80103fdb:	90                   	nop
80103fdc:	90                   	nop
80103fdd:	90                   	nop
80103fde:	90                   	nop
80103fdf:	90                   	nop

80103fe0 <releasesleep>:
80103fe0:	55                   	push   %ebp
80103fe1:	89 e5                	mov    %esp,%ebp
80103fe3:	56                   	push   %esi
80103fe4:	53                   	push   %ebx
80103fe5:	83 ec 10             	sub    $0x10,%esp
80103fe8:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103feb:	8d 73 04             	lea    0x4(%ebx),%esi
80103fee:	89 34 24             	mov    %esi,(%esp)
80103ff1:	e8 4a 01 00 00       	call   80104140 <acquire>
80103ff6:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103ffc:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
80104003:	89 1c 24             	mov    %ebx,(%esp)
80104006:	e8 85 fd ff ff       	call   80103d90 <wakeup>
8010400b:	89 75 08             	mov    %esi,0x8(%ebp)
8010400e:	83 c4 10             	add    $0x10,%esp
80104011:	5b                   	pop    %ebx
80104012:	5e                   	pop    %esi
80104013:	5d                   	pop    %ebp
80104014:	e9 17 02 00 00       	jmp    80104230 <release>
80104019:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104020 <holdingsleep>:
80104020:	55                   	push   %ebp
80104021:	89 e5                	mov    %esp,%ebp
80104023:	56                   	push   %esi
80104024:	53                   	push   %ebx
80104025:	83 ec 10             	sub    $0x10,%esp
80104028:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010402b:	8d 73 04             	lea    0x4(%ebx),%esi
8010402e:	89 34 24             	mov    %esi,(%esp)
80104031:	e8 0a 01 00 00       	call   80104140 <acquire>
80104036:	8b 1b                	mov    (%ebx),%ebx
80104038:	89 34 24             	mov    %esi,(%esp)
8010403b:	e8 f0 01 00 00       	call   80104230 <release>
80104040:	83 c4 10             	add    $0x10,%esp
80104043:	89 d8                	mov    %ebx,%eax
80104045:	5b                   	pop    %ebx
80104046:	5e                   	pop    %esi
80104047:	5d                   	pop    %ebp
80104048:	c3                   	ret    
80104049:	00 00                	add    %al,(%eax)
8010404b:	00 00                	add    %al,(%eax)
8010404d:	00 00                	add    %al,(%eax)
	...

80104050 <initlock>:
80104050:	55                   	push   %ebp
80104051:	89 e5                	mov    %esp,%ebp
80104053:	8b 45 08             	mov    0x8(%ebp),%eax
80104056:	8b 55 0c             	mov    0xc(%ebp),%edx
80104059:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
8010405f:	89 50 04             	mov    %edx,0x4(%eax)
80104062:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
80104069:	5d                   	pop    %ebp
8010406a:	c3                   	ret    
8010406b:	90                   	nop
8010406c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104070 <getcallerpcs>:
80104070:	55                   	push   %ebp
80104071:	89 e5                	mov    %esp,%ebp
80104073:	8b 45 08             	mov    0x8(%ebp),%eax
80104076:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104079:	53                   	push   %ebx
8010407a:	8d 50 f8             	lea    -0x8(%eax),%edx
8010407d:	31 c0                	xor    %eax,%eax
8010407f:	90                   	nop
80104080:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104086:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010408c:	77 1a                	ja     801040a8 <getcallerpcs+0x38>
8010408e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104091:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
80104094:	83 c0 01             	add    $0x1,%eax
80104097:	8b 12                	mov    (%edx),%edx
80104099:	83 f8 0a             	cmp    $0xa,%eax
8010409c:	75 e2                	jne    80104080 <getcallerpcs+0x10>
8010409e:	5b                   	pop    %ebx
8010409f:	5d                   	pop    %ebp
801040a0:	c3                   	ret    
801040a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801040a8:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
801040af:	83 c0 01             	add    $0x1,%eax
801040b2:	83 f8 0a             	cmp    $0xa,%eax
801040b5:	74 e7                	je     8010409e <getcallerpcs+0x2e>
801040b7:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
801040be:	83 c0 01             	add    $0x1,%eax
801040c1:	83 f8 0a             	cmp    $0xa,%eax
801040c4:	75 e2                	jne    801040a8 <getcallerpcs+0x38>
801040c6:	eb d6                	jmp    8010409e <getcallerpcs+0x2e>
801040c8:	90                   	nop
801040c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801040d0 <holding>:
801040d0:	55                   	push   %ebp
801040d1:	31 c0                	xor    %eax,%eax
801040d3:	89 e5                	mov    %esp,%ebp
801040d5:	53                   	push   %ebx
801040d6:	83 ec 04             	sub    $0x4,%esp
801040d9:	8b 55 08             	mov    0x8(%ebp),%edx
801040dc:	8b 0a                	mov    (%edx),%ecx
801040de:	85 c9                	test   %ecx,%ecx
801040e0:	74 10                	je     801040f2 <holding+0x22>
801040e2:	8b 5a 08             	mov    0x8(%edx),%ebx
801040e5:	e8 16 f5 ff ff       	call   80103600 <mycpu>
801040ea:	39 c3                	cmp    %eax,%ebx
801040ec:	0f 94 c0             	sete   %al
801040ef:	0f b6 c0             	movzbl %al,%eax
801040f2:	83 c4 04             	add    $0x4,%esp
801040f5:	5b                   	pop    %ebx
801040f6:	5d                   	pop    %ebp
801040f7:	c3                   	ret    
801040f8:	90                   	nop
801040f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104100 <pushcli>:
80104100:	55                   	push   %ebp
80104101:	89 e5                	mov    %esp,%ebp
80104103:	53                   	push   %ebx
80104104:	83 ec 04             	sub    $0x4,%esp
80104107:	9c                   	pushf  
80104108:	5b                   	pop    %ebx
80104109:	fa                   	cli    
8010410a:	e8 f1 f4 ff ff       	call   80103600 <mycpu>
8010410f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104115:	85 c0                	test   %eax,%eax
80104117:	75 11                	jne    8010412a <pushcli+0x2a>
80104119:	e8 e2 f4 ff ff       	call   80103600 <mycpu>
8010411e:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104124:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
8010412a:	e8 d1 f4 ff ff       	call   80103600 <mycpu>
8010412f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
80104136:	83 c4 04             	add    $0x4,%esp
80104139:	5b                   	pop    %ebx
8010413a:	5d                   	pop    %ebp
8010413b:	c3                   	ret    
8010413c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104140 <acquire>:
80104140:	55                   	push   %ebp
80104141:	89 e5                	mov    %esp,%ebp
80104143:	53                   	push   %ebx
80104144:	83 ec 14             	sub    $0x14,%esp
80104147:	e8 b4 ff ff ff       	call   80104100 <pushcli>
8010414c:	8b 55 08             	mov    0x8(%ebp),%edx
8010414f:	8b 02                	mov    (%edx),%eax
80104151:	85 c0                	test   %eax,%eax
80104153:	75 43                	jne    80104198 <acquire+0x58>
80104155:	b9 01 00 00 00       	mov    $0x1,%ecx
8010415a:	eb 07                	jmp    80104163 <acquire+0x23>
8010415c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104160:	8b 55 08             	mov    0x8(%ebp),%edx
80104163:	89 c8                	mov    %ecx,%eax
80104165:	f0 87 02             	lock xchg %eax,(%edx)
80104168:	85 c0                	test   %eax,%eax
8010416a:	75 f4                	jne    80104160 <acquire+0x20>
8010416c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
80104171:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104174:	e8 87 f4 ff ff       	call   80103600 <mycpu>
80104179:	89 43 08             	mov    %eax,0x8(%ebx)
8010417c:	8b 45 08             	mov    0x8(%ebp),%eax
8010417f:	83 c0 0c             	add    $0xc,%eax
80104182:	89 44 24 04          	mov    %eax,0x4(%esp)
80104186:	8d 45 08             	lea    0x8(%ebp),%eax
80104189:	89 04 24             	mov    %eax,(%esp)
8010418c:	e8 df fe ff ff       	call   80104070 <getcallerpcs>
80104191:	83 c4 14             	add    $0x14,%esp
80104194:	5b                   	pop    %ebx
80104195:	5d                   	pop    %ebp
80104196:	c3                   	ret    
80104197:	90                   	nop
80104198:	8b 5a 08             	mov    0x8(%edx),%ebx
8010419b:	e8 60 f4 ff ff       	call   80103600 <mycpu>
801041a0:	39 c3                	cmp    %eax,%ebx
801041a2:	74 05                	je     801041a9 <acquire+0x69>
801041a4:	8b 55 08             	mov    0x8(%ebp),%edx
801041a7:	eb ac                	jmp    80104155 <acquire+0x15>
801041a9:	c7 04 24 c3 72 10 80 	movl   $0x801072c3,(%esp)
801041b0:	e8 ab c1 ff ff       	call   80100360 <panic>
801041b5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801041b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801041c0 <popcli>:
801041c0:	55                   	push   %ebp
801041c1:	89 e5                	mov    %esp,%ebp
801041c3:	83 ec 18             	sub    $0x18,%esp
801041c6:	9c                   	pushf  
801041c7:	58                   	pop    %eax
801041c8:	f6 c4 02             	test   $0x2,%ah
801041cb:	75 49                	jne    80104216 <popcli+0x56>
801041cd:	e8 2e f4 ff ff       	call   80103600 <mycpu>
801041d2:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
801041d8:	8d 51 ff             	lea    -0x1(%ecx),%edx
801041db:	85 d2                	test   %edx,%edx
801041dd:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
801041e3:	78 25                	js     8010420a <popcli+0x4a>
801041e5:	e8 16 f4 ff ff       	call   80103600 <mycpu>
801041ea:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801041f0:	85 c0                	test   %eax,%eax
801041f2:	74 04                	je     801041f8 <popcli+0x38>
801041f4:	c9                   	leave  
801041f5:	c3                   	ret    
801041f6:	66 90                	xchg   %ax,%ax
801041f8:	e8 03 f4 ff ff       	call   80103600 <mycpu>
801041fd:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104203:	85 c0                	test   %eax,%eax
80104205:	74 ed                	je     801041f4 <popcli+0x34>
80104207:	fb                   	sti    
80104208:	c9                   	leave  
80104209:	c3                   	ret    
8010420a:	c7 04 24 e2 72 10 80 	movl   $0x801072e2,(%esp)
80104211:	e8 4a c1 ff ff       	call   80100360 <panic>
80104216:	c7 04 24 cb 72 10 80 	movl   $0x801072cb,(%esp)
8010421d:	e8 3e c1 ff ff       	call   80100360 <panic>
80104222:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104229:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104230 <release>:
80104230:	55                   	push   %ebp
80104231:	89 e5                	mov    %esp,%ebp
80104233:	56                   	push   %esi
80104234:	53                   	push   %ebx
80104235:	83 ec 10             	sub    $0x10,%esp
80104238:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010423b:	8b 03                	mov    (%ebx),%eax
8010423d:	85 c0                	test   %eax,%eax
8010423f:	75 0f                	jne    80104250 <release+0x20>
80104241:	c7 04 24 e9 72 10 80 	movl   $0x801072e9,(%esp)
80104248:	e8 13 c1 ff ff       	call   80100360 <panic>
8010424d:	8d 76 00             	lea    0x0(%esi),%esi
80104250:	8b 73 08             	mov    0x8(%ebx),%esi
80104253:	e8 a8 f3 ff ff       	call   80103600 <mycpu>
80104258:	39 c6                	cmp    %eax,%esi
8010425a:	75 e5                	jne    80104241 <release+0x11>
8010425c:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
80104263:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
8010426a:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
8010426f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80104275:	83 c4 10             	add    $0x10,%esp
80104278:	5b                   	pop    %ebx
80104279:	5e                   	pop    %esi
8010427a:	5d                   	pop    %ebp
8010427b:	e9 40 ff ff ff       	jmp    801041c0 <popcli>

80104280 <memset>:
80104280:	55                   	push   %ebp
80104281:	89 e5                	mov    %esp,%ebp
80104283:	8b 55 08             	mov    0x8(%ebp),%edx
80104286:	57                   	push   %edi
80104287:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010428a:	53                   	push   %ebx
8010428b:	f6 c2 03             	test   $0x3,%dl
8010428e:	75 05                	jne    80104295 <memset+0x15>
80104290:	f6 c1 03             	test   $0x3,%cl
80104293:	74 13                	je     801042a8 <memset+0x28>
80104295:	89 d7                	mov    %edx,%edi
80104297:	8b 45 0c             	mov    0xc(%ebp),%eax
8010429a:	fc                   	cld    
8010429b:	f3 aa                	rep stos %al,%es:(%edi)
8010429d:	5b                   	pop    %ebx
8010429e:	89 d0                	mov    %edx,%eax
801042a0:	5f                   	pop    %edi
801042a1:	5d                   	pop    %ebp
801042a2:	c3                   	ret    
801042a3:	90                   	nop
801042a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801042a8:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
801042ac:	c1 e9 02             	shr    $0x2,%ecx
801042af:	89 f8                	mov    %edi,%eax
801042b1:	89 fb                	mov    %edi,%ebx
801042b3:	c1 e0 18             	shl    $0x18,%eax
801042b6:	c1 e3 10             	shl    $0x10,%ebx
801042b9:	09 d8                	or     %ebx,%eax
801042bb:	09 f8                	or     %edi,%eax
801042bd:	c1 e7 08             	shl    $0x8,%edi
801042c0:	09 f8                	or     %edi,%eax
801042c2:	89 d7                	mov    %edx,%edi
801042c4:	fc                   	cld    
801042c5:	f3 ab                	rep stos %eax,%es:(%edi)
801042c7:	5b                   	pop    %ebx
801042c8:	89 d0                	mov    %edx,%eax
801042ca:	5f                   	pop    %edi
801042cb:	5d                   	pop    %ebp
801042cc:	c3                   	ret    
801042cd:	8d 76 00             	lea    0x0(%esi),%esi

801042d0 <memcmp>:
801042d0:	55                   	push   %ebp
801042d1:	89 e5                	mov    %esp,%ebp
801042d3:	8b 45 10             	mov    0x10(%ebp),%eax
801042d6:	57                   	push   %edi
801042d7:	56                   	push   %esi
801042d8:	8b 75 0c             	mov    0xc(%ebp),%esi
801042db:	53                   	push   %ebx
801042dc:	8b 5d 08             	mov    0x8(%ebp),%ebx
801042df:	85 c0                	test   %eax,%eax
801042e1:	8d 78 ff             	lea    -0x1(%eax),%edi
801042e4:	74 26                	je     8010430c <memcmp+0x3c>
801042e6:	0f b6 03             	movzbl (%ebx),%eax
801042e9:	31 d2                	xor    %edx,%edx
801042eb:	0f b6 0e             	movzbl (%esi),%ecx
801042ee:	38 c8                	cmp    %cl,%al
801042f0:	74 16                	je     80104308 <memcmp+0x38>
801042f2:	eb 24                	jmp    80104318 <memcmp+0x48>
801042f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801042f8:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
801042fd:	83 c2 01             	add    $0x1,%edx
80104300:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104304:	38 c8                	cmp    %cl,%al
80104306:	75 10                	jne    80104318 <memcmp+0x48>
80104308:	39 fa                	cmp    %edi,%edx
8010430a:	75 ec                	jne    801042f8 <memcmp+0x28>
8010430c:	5b                   	pop    %ebx
8010430d:	31 c0                	xor    %eax,%eax
8010430f:	5e                   	pop    %esi
80104310:	5f                   	pop    %edi
80104311:	5d                   	pop    %ebp
80104312:	c3                   	ret    
80104313:	90                   	nop
80104314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104318:	5b                   	pop    %ebx
80104319:	29 c8                	sub    %ecx,%eax
8010431b:	5e                   	pop    %esi
8010431c:	5f                   	pop    %edi
8010431d:	5d                   	pop    %ebp
8010431e:	c3                   	ret    
8010431f:	90                   	nop

80104320 <memmove>:
80104320:	55                   	push   %ebp
80104321:	89 e5                	mov    %esp,%ebp
80104323:	57                   	push   %edi
80104324:	8b 45 08             	mov    0x8(%ebp),%eax
80104327:	56                   	push   %esi
80104328:	8b 75 0c             	mov    0xc(%ebp),%esi
8010432b:	53                   	push   %ebx
8010432c:	8b 5d 10             	mov    0x10(%ebp),%ebx
8010432f:	39 c6                	cmp    %eax,%esi
80104331:	73 35                	jae    80104368 <memmove+0x48>
80104333:	8d 0c 1e             	lea    (%esi,%ebx,1),%ecx
80104336:	39 c8                	cmp    %ecx,%eax
80104338:	73 2e                	jae    80104368 <memmove+0x48>
8010433a:	85 db                	test   %ebx,%ebx
8010433c:	8d 3c 18             	lea    (%eax,%ebx,1),%edi
8010433f:	8d 53 ff             	lea    -0x1(%ebx),%edx
80104342:	74 1b                	je     8010435f <memmove+0x3f>
80104344:	f7 db                	neg    %ebx
80104346:	8d 34 19             	lea    (%ecx,%ebx,1),%esi
80104349:	01 fb                	add    %edi,%ebx
8010434b:	90                   	nop
8010434c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104350:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104354:	88 0c 13             	mov    %cl,(%ebx,%edx,1)
80104357:	83 ea 01             	sub    $0x1,%edx
8010435a:	83 fa ff             	cmp    $0xffffffff,%edx
8010435d:	75 f1                	jne    80104350 <memmove+0x30>
8010435f:	5b                   	pop    %ebx
80104360:	5e                   	pop    %esi
80104361:	5f                   	pop    %edi
80104362:	5d                   	pop    %ebp
80104363:	c3                   	ret    
80104364:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104368:	31 d2                	xor    %edx,%edx
8010436a:	85 db                	test   %ebx,%ebx
8010436c:	74 f1                	je     8010435f <memmove+0x3f>
8010436e:	66 90                	xchg   %ax,%ax
80104370:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104374:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104377:	83 c2 01             	add    $0x1,%edx
8010437a:	39 da                	cmp    %ebx,%edx
8010437c:	75 f2                	jne    80104370 <memmove+0x50>
8010437e:	5b                   	pop    %ebx
8010437f:	5e                   	pop    %esi
80104380:	5f                   	pop    %edi
80104381:	5d                   	pop    %ebp
80104382:	c3                   	ret    
80104383:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104389:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104390 <memcpy>:
80104390:	55                   	push   %ebp
80104391:	89 e5                	mov    %esp,%ebp
80104393:	5d                   	pop    %ebp
80104394:	e9 87 ff ff ff       	jmp    80104320 <memmove>
80104399:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801043a0 <strncmp>:
801043a0:	55                   	push   %ebp
801043a1:	89 e5                	mov    %esp,%ebp
801043a3:	56                   	push   %esi
801043a4:	8b 75 10             	mov    0x10(%ebp),%esi
801043a7:	53                   	push   %ebx
801043a8:	8b 4d 08             	mov    0x8(%ebp),%ecx
801043ab:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801043ae:	85 f6                	test   %esi,%esi
801043b0:	74 30                	je     801043e2 <strncmp+0x42>
801043b2:	0f b6 01             	movzbl (%ecx),%eax
801043b5:	84 c0                	test   %al,%al
801043b7:	74 2f                	je     801043e8 <strncmp+0x48>
801043b9:	0f b6 13             	movzbl (%ebx),%edx
801043bc:	38 d0                	cmp    %dl,%al
801043be:	75 46                	jne    80104406 <strncmp+0x66>
801043c0:	8d 51 01             	lea    0x1(%ecx),%edx
801043c3:	01 ce                	add    %ecx,%esi
801043c5:	eb 14                	jmp    801043db <strncmp+0x3b>
801043c7:	90                   	nop
801043c8:	0f b6 02             	movzbl (%edx),%eax
801043cb:	84 c0                	test   %al,%al
801043cd:	74 31                	je     80104400 <strncmp+0x60>
801043cf:	0f b6 19             	movzbl (%ecx),%ebx
801043d2:	83 c2 01             	add    $0x1,%edx
801043d5:	38 d8                	cmp    %bl,%al
801043d7:	75 17                	jne    801043f0 <strncmp+0x50>
801043d9:	89 cb                	mov    %ecx,%ebx
801043db:	39 f2                	cmp    %esi,%edx
801043dd:	8d 4b 01             	lea    0x1(%ebx),%ecx
801043e0:	75 e6                	jne    801043c8 <strncmp+0x28>
801043e2:	5b                   	pop    %ebx
801043e3:	31 c0                	xor    %eax,%eax
801043e5:	5e                   	pop    %esi
801043e6:	5d                   	pop    %ebp
801043e7:	c3                   	ret    
801043e8:	0f b6 1b             	movzbl (%ebx),%ebx
801043eb:	31 c0                	xor    %eax,%eax
801043ed:	8d 76 00             	lea    0x0(%esi),%esi
801043f0:	0f b6 d3             	movzbl %bl,%edx
801043f3:	29 d0                	sub    %edx,%eax
801043f5:	5b                   	pop    %ebx
801043f6:	5e                   	pop    %esi
801043f7:	5d                   	pop    %ebp
801043f8:	c3                   	ret    
801043f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104400:	0f b6 5b 01          	movzbl 0x1(%ebx),%ebx
80104404:	eb ea                	jmp    801043f0 <strncmp+0x50>
80104406:	89 d3                	mov    %edx,%ebx
80104408:	eb e6                	jmp    801043f0 <strncmp+0x50>
8010440a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104410 <strncpy>:
80104410:	55                   	push   %ebp
80104411:	89 e5                	mov    %esp,%ebp
80104413:	8b 45 08             	mov    0x8(%ebp),%eax
80104416:	56                   	push   %esi
80104417:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010441a:	53                   	push   %ebx
8010441b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010441e:	89 c2                	mov    %eax,%edx
80104420:	eb 19                	jmp    8010443b <strncpy+0x2b>
80104422:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104428:	83 c3 01             	add    $0x1,%ebx
8010442b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
8010442f:	83 c2 01             	add    $0x1,%edx
80104432:	84 c9                	test   %cl,%cl
80104434:	88 4a ff             	mov    %cl,-0x1(%edx)
80104437:	74 09                	je     80104442 <strncpy+0x32>
80104439:	89 f1                	mov    %esi,%ecx
8010443b:	85 c9                	test   %ecx,%ecx
8010443d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104440:	7f e6                	jg     80104428 <strncpy+0x18>
80104442:	31 c9                	xor    %ecx,%ecx
80104444:	85 f6                	test   %esi,%esi
80104446:	7e 0f                	jle    80104457 <strncpy+0x47>
80104448:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
8010444c:	89 f3                	mov    %esi,%ebx
8010444e:	83 c1 01             	add    $0x1,%ecx
80104451:	29 cb                	sub    %ecx,%ebx
80104453:	85 db                	test   %ebx,%ebx
80104455:	7f f1                	jg     80104448 <strncpy+0x38>
80104457:	5b                   	pop    %ebx
80104458:	5e                   	pop    %esi
80104459:	5d                   	pop    %ebp
8010445a:	c3                   	ret    
8010445b:	90                   	nop
8010445c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104460 <safestrcpy>:
80104460:	55                   	push   %ebp
80104461:	89 e5                	mov    %esp,%ebp
80104463:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104466:	56                   	push   %esi
80104467:	8b 45 08             	mov    0x8(%ebp),%eax
8010446a:	53                   	push   %ebx
8010446b:	8b 55 0c             	mov    0xc(%ebp),%edx
8010446e:	85 c9                	test   %ecx,%ecx
80104470:	7e 26                	jle    80104498 <safestrcpy+0x38>
80104472:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104476:	89 c1                	mov    %eax,%ecx
80104478:	eb 17                	jmp    80104491 <safestrcpy+0x31>
8010447a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104480:	83 c2 01             	add    $0x1,%edx
80104483:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104487:	83 c1 01             	add    $0x1,%ecx
8010448a:	84 db                	test   %bl,%bl
8010448c:	88 59 ff             	mov    %bl,-0x1(%ecx)
8010448f:	74 04                	je     80104495 <safestrcpy+0x35>
80104491:	39 f2                	cmp    %esi,%edx
80104493:	75 eb                	jne    80104480 <safestrcpy+0x20>
80104495:	c6 01 00             	movb   $0x0,(%ecx)
80104498:	5b                   	pop    %ebx
80104499:	5e                   	pop    %esi
8010449a:	5d                   	pop    %ebp
8010449b:	c3                   	ret    
8010449c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801044a0 <strlen>:
801044a0:	55                   	push   %ebp
801044a1:	31 c0                	xor    %eax,%eax
801044a3:	89 e5                	mov    %esp,%ebp
801044a5:	8b 55 08             	mov    0x8(%ebp),%edx
801044a8:	80 3a 00             	cmpb   $0x0,(%edx)
801044ab:	74 0c                	je     801044b9 <strlen+0x19>
801044ad:	8d 76 00             	lea    0x0(%esi),%esi
801044b0:	83 c0 01             	add    $0x1,%eax
801044b3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801044b7:	75 f7                	jne    801044b0 <strlen+0x10>
801044b9:	5d                   	pop    %ebp
801044ba:	c3                   	ret    
	...

801044bc <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
801044bc:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801044c0:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
801044c4:	55                   	push   %ebp
  pushl %ebx
801044c5:	53                   	push   %ebx
  pushl %esi
801044c6:	56                   	push   %esi
  pushl %edi
801044c7:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801044c8:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801044ca:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
801044cc:	5f                   	pop    %edi
  popl %esi
801044cd:	5e                   	pop    %esi
  popl %ebx
801044ce:	5b                   	pop    %ebx
  popl %ebp
801044cf:	5d                   	pop    %ebp
  ret
801044d0:	c3                   	ret    
	...

801044e0 <fetchint>:
801044e0:	55                   	push   %ebp
801044e1:	89 e5                	mov    %esp,%ebp
801044e3:	53                   	push   %ebx
801044e4:	83 ec 04             	sub    $0x4,%esp
801044e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
801044ea:	e8 b1 f1 ff ff       	call   801036a0 <myproc>
801044ef:	8b 00                	mov    (%eax),%eax
801044f1:	39 d8                	cmp    %ebx,%eax
801044f3:	76 1b                	jbe    80104510 <fetchint+0x30>
801044f5:	8d 53 04             	lea    0x4(%ebx),%edx
801044f8:	39 d0                	cmp    %edx,%eax
801044fa:	72 14                	jb     80104510 <fetchint+0x30>
801044fc:	8b 45 0c             	mov    0xc(%ebp),%eax
801044ff:	8b 13                	mov    (%ebx),%edx
80104501:	89 10                	mov    %edx,(%eax)
80104503:	31 c0                	xor    %eax,%eax
80104505:	83 c4 04             	add    $0x4,%esp
80104508:	5b                   	pop    %ebx
80104509:	5d                   	pop    %ebp
8010450a:	c3                   	ret    
8010450b:	90                   	nop
8010450c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104510:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104515:	eb ee                	jmp    80104505 <fetchint+0x25>
80104517:	89 f6                	mov    %esi,%esi
80104519:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104520 <fetchstr>:
80104520:	55                   	push   %ebp
80104521:	89 e5                	mov    %esp,%ebp
80104523:	53                   	push   %ebx
80104524:	83 ec 04             	sub    $0x4,%esp
80104527:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010452a:	e8 71 f1 ff ff       	call   801036a0 <myproc>
8010452f:	39 18                	cmp    %ebx,(%eax)
80104531:	76 26                	jbe    80104559 <fetchstr+0x39>
80104533:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104536:	89 da                	mov    %ebx,%edx
80104538:	89 19                	mov    %ebx,(%ecx)
8010453a:	8b 00                	mov    (%eax),%eax
8010453c:	39 c3                	cmp    %eax,%ebx
8010453e:	73 19                	jae    80104559 <fetchstr+0x39>
80104540:	80 3b 00             	cmpb   $0x0,(%ebx)
80104543:	75 0d                	jne    80104552 <fetchstr+0x32>
80104545:	eb 21                	jmp    80104568 <fetchstr+0x48>
80104547:	90                   	nop
80104548:	80 3a 00             	cmpb   $0x0,(%edx)
8010454b:	90                   	nop
8010454c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104550:	74 16                	je     80104568 <fetchstr+0x48>
80104552:	83 c2 01             	add    $0x1,%edx
80104555:	39 d0                	cmp    %edx,%eax
80104557:	77 ef                	ja     80104548 <fetchstr+0x28>
80104559:	83 c4 04             	add    $0x4,%esp
8010455c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104561:	5b                   	pop    %ebx
80104562:	5d                   	pop    %ebp
80104563:	c3                   	ret    
80104564:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104568:	83 c4 04             	add    $0x4,%esp
8010456b:	89 d0                	mov    %edx,%eax
8010456d:	29 d8                	sub    %ebx,%eax
8010456f:	5b                   	pop    %ebx
80104570:	5d                   	pop    %ebp
80104571:	c3                   	ret    
80104572:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104579:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104580 <argint>:
80104580:	55                   	push   %ebp
80104581:	89 e5                	mov    %esp,%ebp
80104583:	56                   	push   %esi
80104584:	8b 75 0c             	mov    0xc(%ebp),%esi
80104587:	53                   	push   %ebx
80104588:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010458b:	e8 10 f1 ff ff       	call   801036a0 <myproc>
80104590:	89 75 0c             	mov    %esi,0xc(%ebp)
80104593:	8b 40 18             	mov    0x18(%eax),%eax
80104596:	8b 40 44             	mov    0x44(%eax),%eax
80104599:	8d 44 98 04          	lea    0x4(%eax,%ebx,4),%eax
8010459d:	89 45 08             	mov    %eax,0x8(%ebp)
801045a0:	5b                   	pop    %ebx
801045a1:	5e                   	pop    %esi
801045a2:	5d                   	pop    %ebp
801045a3:	e9 38 ff ff ff       	jmp    801044e0 <fetchint>
801045a8:	90                   	nop
801045a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801045b0 <argptr>:
801045b0:	55                   	push   %ebp
801045b1:	89 e5                	mov    %esp,%ebp
801045b3:	56                   	push   %esi
801045b4:	53                   	push   %ebx
801045b5:	83 ec 20             	sub    $0x20,%esp
801045b8:	8b 5d 10             	mov    0x10(%ebp),%ebx
801045bb:	e8 e0 f0 ff ff       	call   801036a0 <myproc>
801045c0:	89 c6                	mov    %eax,%esi
801045c2:	8d 45 f4             	lea    -0xc(%ebp),%eax
801045c5:	89 44 24 04          	mov    %eax,0x4(%esp)
801045c9:	8b 45 08             	mov    0x8(%ebp),%eax
801045cc:	89 04 24             	mov    %eax,(%esp)
801045cf:	e8 ac ff ff ff       	call   80104580 <argint>
801045d4:	85 c0                	test   %eax,%eax
801045d6:	78 28                	js     80104600 <argptr+0x50>
801045d8:	85 db                	test   %ebx,%ebx
801045da:	78 24                	js     80104600 <argptr+0x50>
801045dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
801045df:	8b 06                	mov    (%esi),%eax
801045e1:	39 c2                	cmp    %eax,%edx
801045e3:	73 1b                	jae    80104600 <argptr+0x50>
801045e5:	01 d3                	add    %edx,%ebx
801045e7:	39 d8                	cmp    %ebx,%eax
801045e9:	72 15                	jb     80104600 <argptr+0x50>
801045eb:	8b 45 0c             	mov    0xc(%ebp),%eax
801045ee:	89 10                	mov    %edx,(%eax)
801045f0:	83 c4 20             	add    $0x20,%esp
801045f3:	31 c0                	xor    %eax,%eax
801045f5:	5b                   	pop    %ebx
801045f6:	5e                   	pop    %esi
801045f7:	5d                   	pop    %ebp
801045f8:	c3                   	ret    
801045f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104600:	83 c4 20             	add    $0x20,%esp
80104603:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104608:	5b                   	pop    %ebx
80104609:	5e                   	pop    %esi
8010460a:	5d                   	pop    %ebp
8010460b:	c3                   	ret    
8010460c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104610 <argstr>:
80104610:	55                   	push   %ebp
80104611:	89 e5                	mov    %esp,%ebp
80104613:	83 ec 28             	sub    $0x28,%esp
80104616:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104619:	89 44 24 04          	mov    %eax,0x4(%esp)
8010461d:	8b 45 08             	mov    0x8(%ebp),%eax
80104620:	89 04 24             	mov    %eax,(%esp)
80104623:	e8 58 ff ff ff       	call   80104580 <argint>
80104628:	85 c0                	test   %eax,%eax
8010462a:	78 14                	js     80104640 <argstr+0x30>
8010462c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010462f:	89 44 24 04          	mov    %eax,0x4(%esp)
80104633:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104636:	89 04 24             	mov    %eax,(%esp)
80104639:	e8 e2 fe ff ff       	call   80104520 <fetchstr>
8010463e:	c9                   	leave  
8010463f:	c3                   	ret    
80104640:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104645:	c9                   	leave  
80104646:	c3                   	ret    
80104647:	89 f6                	mov    %esi,%esi
80104649:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104650 <syscall>:
80104650:	55                   	push   %ebp
80104651:	89 e5                	mov    %esp,%ebp
80104653:	57                   	push   %edi
80104654:	56                   	push   %esi
80104655:	53                   	push   %ebx
80104656:	83 ec 1c             	sub    $0x1c,%esp
80104659:	e8 42 f0 ff ff       	call   801036a0 <myproc>
8010465e:	8b 78 18             	mov    0x18(%eax),%edi
80104661:	89 c3                	mov    %eax,%ebx
80104663:	8b 47 1c             	mov    0x1c(%edi),%eax
80104666:	8d 70 ff             	lea    -0x1(%eax),%esi
80104669:	83 fe 15             	cmp    $0x15,%esi
8010466c:	77 3a                	ja     801046a8 <syscall+0x58>
8010466e:	8b 14 85 e0 73 10 80 	mov    -0x7fef8c20(,%eax,4),%edx
80104675:	85 d2                	test   %edx,%edx
80104677:	74 2f                	je     801046a8 <syscall+0x58>
80104679:	ff d2                	call   *%edx
8010467b:	89 47 1c             	mov    %eax,0x1c(%edi)
8010467e:	8b 43 18             	mov    0x18(%ebx),%eax
80104681:	8b 40 1c             	mov    0x1c(%eax),%eax
80104684:	c7 04 24 f1 72 10 80 	movl   $0x801072f1,(%esp)
8010468b:	89 44 24 08          	mov    %eax,0x8(%esp)
8010468f:	8b 04 b5 80 73 10 80 	mov    -0x7fef8c80(,%esi,4),%eax
80104696:	89 44 24 04          	mov    %eax,0x4(%esp)
8010469a:	e8 b1 bf ff ff       	call   80100650 <cprintf>
8010469f:	83 c4 1c             	add    $0x1c,%esp
801046a2:	5b                   	pop    %ebx
801046a3:	5e                   	pop    %esi
801046a4:	5f                   	pop    %edi
801046a5:	5d                   	pop    %ebp
801046a6:	c3                   	ret    
801046a7:	90                   	nop
801046a8:	89 44 24 0c          	mov    %eax,0xc(%esp)
801046ac:	8d 43 6c             	lea    0x6c(%ebx),%eax
801046af:	89 44 24 08          	mov    %eax,0x8(%esp)
801046b3:	8b 43 10             	mov    0x10(%ebx),%eax
801046b6:	c7 04 24 fb 72 10 80 	movl   $0x801072fb,(%esp)
801046bd:	89 44 24 04          	mov    %eax,0x4(%esp)
801046c1:	e8 8a bf ff ff       	call   80100650 <cprintf>
801046c6:	8b 43 18             	mov    0x18(%ebx),%eax
801046c9:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
801046d0:	83 c4 1c             	add    $0x1c,%esp
801046d3:	5b                   	pop    %ebx
801046d4:	5e                   	pop    %esi
801046d5:	5f                   	pop    %edi
801046d6:	5d                   	pop    %ebp
801046d7:	c3                   	ret    
	...

801046e0 <fdalloc>:
801046e0:	55                   	push   %ebp
801046e1:	89 e5                	mov    %esp,%ebp
801046e3:	53                   	push   %ebx
801046e4:	89 c3                	mov    %eax,%ebx
801046e6:	83 ec 04             	sub    $0x4,%esp
801046e9:	e8 b2 ef ff ff       	call   801036a0 <myproc>
801046ee:	31 d2                	xor    %edx,%edx
801046f0:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
801046f4:	85 c9                	test   %ecx,%ecx
801046f6:	74 18                	je     80104710 <fdalloc+0x30>
801046f8:	83 c2 01             	add    $0x1,%edx
801046fb:	83 fa 10             	cmp    $0x10,%edx
801046fe:	75 f0                	jne    801046f0 <fdalloc+0x10>
80104700:	83 c4 04             	add    $0x4,%esp
80104703:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104708:	5b                   	pop    %ebx
80104709:	5d                   	pop    %ebp
8010470a:	c3                   	ret    
8010470b:	90                   	nop
8010470c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104710:	89 5c 90 28          	mov    %ebx,0x28(%eax,%edx,4)
80104714:	83 c4 04             	add    $0x4,%esp
80104717:	89 d0                	mov    %edx,%eax
80104719:	5b                   	pop    %ebx
8010471a:	5d                   	pop    %ebp
8010471b:	c3                   	ret    
8010471c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104720 <create>:
80104720:	55                   	push   %ebp
80104721:	89 e5                	mov    %esp,%ebp
80104723:	57                   	push   %edi
80104724:	56                   	push   %esi
80104725:	53                   	push   %ebx
80104726:	83 ec 4c             	sub    $0x4c,%esp
80104729:	89 4d c0             	mov    %ecx,-0x40(%ebp)
8010472c:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010472f:	8d 5d da             	lea    -0x26(%ebp),%ebx
80104732:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104736:	89 04 24             	mov    %eax,(%esp)
80104739:	89 55 c4             	mov    %edx,-0x3c(%ebp)
8010473c:	89 4d bc             	mov    %ecx,-0x44(%ebp)
8010473f:	e8 ec d7 ff ff       	call   80101f30 <nameiparent>
80104744:	85 c0                	test   %eax,%eax
80104746:	89 c7                	mov    %eax,%edi
80104748:	0f 84 da 00 00 00    	je     80104828 <create+0x108>
8010474e:	89 04 24             	mov    %eax,(%esp)
80104751:	e8 6a cf ff ff       	call   801016c0 <ilock>
80104756:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104759:	89 44 24 08          	mov    %eax,0x8(%esp)
8010475d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104761:	89 3c 24             	mov    %edi,(%esp)
80104764:	e8 67 d4 ff ff       	call   80101bd0 <dirlookup>
80104769:	85 c0                	test   %eax,%eax
8010476b:	89 c6                	mov    %eax,%esi
8010476d:	74 41                	je     801047b0 <create+0x90>
8010476f:	89 3c 24             	mov    %edi,(%esp)
80104772:	e8 a9 d1 ff ff       	call   80101920 <iunlockput>
80104777:	89 34 24             	mov    %esi,(%esp)
8010477a:	e8 41 cf ff ff       	call   801016c0 <ilock>
8010477f:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80104784:	75 12                	jne    80104798 <create+0x78>
80104786:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
8010478b:	89 f0                	mov    %esi,%eax
8010478d:	75 09                	jne    80104798 <create+0x78>
8010478f:	83 c4 4c             	add    $0x4c,%esp
80104792:	5b                   	pop    %ebx
80104793:	5e                   	pop    %esi
80104794:	5f                   	pop    %edi
80104795:	5d                   	pop    %ebp
80104796:	c3                   	ret    
80104797:	90                   	nop
80104798:	89 34 24             	mov    %esi,(%esp)
8010479b:	e8 80 d1 ff ff       	call   80101920 <iunlockput>
801047a0:	83 c4 4c             	add    $0x4c,%esp
801047a3:	31 c0                	xor    %eax,%eax
801047a5:	5b                   	pop    %ebx
801047a6:	5e                   	pop    %esi
801047a7:	5f                   	pop    %edi
801047a8:	5d                   	pop    %ebp
801047a9:	c3                   	ret    
801047aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801047b0:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801047b3:	89 44 24 04          	mov    %eax,0x4(%esp)
801047b7:	8b 07                	mov    (%edi),%eax
801047b9:	89 04 24             	mov    %eax,(%esp)
801047bc:	e8 6f cd ff ff       	call   80101530 <ialloc>
801047c1:	85 c0                	test   %eax,%eax
801047c3:	89 c6                	mov    %eax,%esi
801047c5:	0f 84 c0 00 00 00    	je     8010488b <create+0x16b>
801047cb:	89 04 24             	mov    %eax,(%esp)
801047ce:	e8 ed ce ff ff       	call   801016c0 <ilock>
801047d3:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
801047d7:	66 89 46 52          	mov    %ax,0x52(%esi)
801047db:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
801047df:	66 89 46 54          	mov    %ax,0x54(%esi)
801047e3:	b8 01 00 00 00       	mov    $0x1,%eax
801047e8:	66 89 46 56          	mov    %ax,0x56(%esi)
801047ec:	89 34 24             	mov    %esi,(%esp)
801047ef:	e8 0c ce ff ff       	call   80101600 <iupdate>
801047f4:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
801047f9:	74 35                	je     80104830 <create+0x110>
801047fb:	8b 46 04             	mov    0x4(%esi),%eax
801047fe:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104802:	89 3c 24             	mov    %edi,(%esp)
80104805:	89 44 24 08          	mov    %eax,0x8(%esp)
80104809:	e8 22 d6 ff ff       	call   80101e30 <dirlink>
8010480e:	85 c0                	test   %eax,%eax
80104810:	78 6d                	js     8010487f <create+0x15f>
80104812:	89 3c 24             	mov    %edi,(%esp)
80104815:	e8 06 d1 ff ff       	call   80101920 <iunlockput>
8010481a:	83 c4 4c             	add    $0x4c,%esp
8010481d:	89 f0                	mov    %esi,%eax
8010481f:	5b                   	pop    %ebx
80104820:	5e                   	pop    %esi
80104821:	5f                   	pop    %edi
80104822:	5d                   	pop    %ebp
80104823:	c3                   	ret    
80104824:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104828:	31 c0                	xor    %eax,%eax
8010482a:	e9 60 ff ff ff       	jmp    8010478f <create+0x6f>
8010482f:	90                   	nop
80104830:	66 83 47 56 01       	addw   $0x1,0x56(%edi)
80104835:	89 3c 24             	mov    %edi,(%esp)
80104838:	e8 c3 cd ff ff       	call   80101600 <iupdate>
8010483d:	8b 46 04             	mov    0x4(%esi),%eax
80104840:	c7 44 24 04 58 74 10 	movl   $0x80107458,0x4(%esp)
80104847:	80 
80104848:	89 34 24             	mov    %esi,(%esp)
8010484b:	89 44 24 08          	mov    %eax,0x8(%esp)
8010484f:	e8 dc d5 ff ff       	call   80101e30 <dirlink>
80104854:	85 c0                	test   %eax,%eax
80104856:	78 1b                	js     80104873 <create+0x153>
80104858:	8b 47 04             	mov    0x4(%edi),%eax
8010485b:	c7 44 24 04 57 74 10 	movl   $0x80107457,0x4(%esp)
80104862:	80 
80104863:	89 34 24             	mov    %esi,(%esp)
80104866:	89 44 24 08          	mov    %eax,0x8(%esp)
8010486a:	e8 c1 d5 ff ff       	call   80101e30 <dirlink>
8010486f:	85 c0                	test   %eax,%eax
80104871:	79 88                	jns    801047fb <create+0xdb>
80104873:	c7 04 24 4b 74 10 80 	movl   $0x8010744b,(%esp)
8010487a:	e8 e1 ba ff ff       	call   80100360 <panic>
8010487f:	c7 04 24 5a 74 10 80 	movl   $0x8010745a,(%esp)
80104886:	e8 d5 ba ff ff       	call   80100360 <panic>
8010488b:	c7 04 24 3c 74 10 80 	movl   $0x8010743c,(%esp)
80104892:	e8 c9 ba ff ff       	call   80100360 <panic>
80104897:	89 f6                	mov    %esi,%esi
80104899:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801048a0 <argfd.constprop.0>:
801048a0:	55                   	push   %ebp
801048a1:	89 e5                	mov    %esp,%ebp
801048a3:	56                   	push   %esi
801048a4:	89 c6                	mov    %eax,%esi
801048a6:	53                   	push   %ebx
801048a7:	89 d3                	mov    %edx,%ebx
801048a9:	83 ec 20             	sub    $0x20,%esp
801048ac:	8d 45 f4             	lea    -0xc(%ebp),%eax
801048af:	89 44 24 04          	mov    %eax,0x4(%esp)
801048b3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801048ba:	e8 c1 fc ff ff       	call   80104580 <argint>
801048bf:	85 c0                	test   %eax,%eax
801048c1:	78 2d                	js     801048f0 <argfd.constprop.0+0x50>
801048c3:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801048c7:	77 27                	ja     801048f0 <argfd.constprop.0+0x50>
801048c9:	e8 d2 ed ff ff       	call   801036a0 <myproc>
801048ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
801048d1:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
801048d5:	85 c0                	test   %eax,%eax
801048d7:	74 17                	je     801048f0 <argfd.constprop.0+0x50>
801048d9:	85 f6                	test   %esi,%esi
801048db:	74 02                	je     801048df <argfd.constprop.0+0x3f>
801048dd:	89 16                	mov    %edx,(%esi)
801048df:	85 db                	test   %ebx,%ebx
801048e1:	74 1d                	je     80104900 <argfd.constprop.0+0x60>
801048e3:	89 03                	mov    %eax,(%ebx)
801048e5:	31 c0                	xor    %eax,%eax
801048e7:	83 c4 20             	add    $0x20,%esp
801048ea:	5b                   	pop    %ebx
801048eb:	5e                   	pop    %esi
801048ec:	5d                   	pop    %ebp
801048ed:	c3                   	ret    
801048ee:	66 90                	xchg   %ax,%ax
801048f0:	83 c4 20             	add    $0x20,%esp
801048f3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801048f8:	5b                   	pop    %ebx
801048f9:	5e                   	pop    %esi
801048fa:	5d                   	pop    %ebp
801048fb:	c3                   	ret    
801048fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104900:	31 c0                	xor    %eax,%eax
80104902:	eb e3                	jmp    801048e7 <argfd.constprop.0+0x47>
80104904:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010490a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104910 <sys_dup>:
80104910:	55                   	push   %ebp
80104911:	31 c0                	xor    %eax,%eax
80104913:	89 e5                	mov    %esp,%ebp
80104915:	53                   	push   %ebx
80104916:	83 ec 24             	sub    $0x24,%esp
80104919:	8d 55 f4             	lea    -0xc(%ebp),%edx
8010491c:	e8 7f ff ff ff       	call   801048a0 <argfd.constprop.0>
80104921:	85 c0                	test   %eax,%eax
80104923:	78 23                	js     80104948 <sys_dup+0x38>
80104925:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104928:	e8 b3 fd ff ff       	call   801046e0 <fdalloc>
8010492d:	85 c0                	test   %eax,%eax
8010492f:	89 c3                	mov    %eax,%ebx
80104931:	78 15                	js     80104948 <sys_dup+0x38>
80104933:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104936:	89 04 24             	mov    %eax,(%esp)
80104939:	e8 a2 c4 ff ff       	call   80100de0 <filedup>
8010493e:	89 d8                	mov    %ebx,%eax
80104940:	83 c4 24             	add    $0x24,%esp
80104943:	5b                   	pop    %ebx
80104944:	5d                   	pop    %ebp
80104945:	c3                   	ret    
80104946:	66 90                	xchg   %ax,%ax
80104948:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010494d:	eb f1                	jmp    80104940 <sys_dup+0x30>
8010494f:	90                   	nop

80104950 <sys_read>:
80104950:	55                   	push   %ebp
80104951:	31 c0                	xor    %eax,%eax
80104953:	89 e5                	mov    %esp,%ebp
80104955:	83 ec 28             	sub    $0x28,%esp
80104958:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010495b:	e8 40 ff ff ff       	call   801048a0 <argfd.constprop.0>
80104960:	85 c0                	test   %eax,%eax
80104962:	78 54                	js     801049b8 <sys_read+0x68>
80104964:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104967:	89 44 24 04          	mov    %eax,0x4(%esp)
8010496b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80104972:	e8 09 fc ff ff       	call   80104580 <argint>
80104977:	85 c0                	test   %eax,%eax
80104979:	78 3d                	js     801049b8 <sys_read+0x68>
8010497b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010497e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104985:	89 44 24 08          	mov    %eax,0x8(%esp)
80104989:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010498c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104990:	e8 1b fc ff ff       	call   801045b0 <argptr>
80104995:	85 c0                	test   %eax,%eax
80104997:	78 1f                	js     801049b8 <sys_read+0x68>
80104999:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010499c:	89 44 24 08          	mov    %eax,0x8(%esp)
801049a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049a3:	89 44 24 04          	mov    %eax,0x4(%esp)
801049a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
801049aa:	89 04 24             	mov    %eax,(%esp)
801049ad:	e8 8e c5 ff ff       	call   80100f40 <fileread>
801049b2:	c9                   	leave  
801049b3:	c3                   	ret    
801049b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801049b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801049bd:	c9                   	leave  
801049be:	c3                   	ret    
801049bf:	90                   	nop

801049c0 <sys_write>:
801049c0:	55                   	push   %ebp
801049c1:	31 c0                	xor    %eax,%eax
801049c3:	89 e5                	mov    %esp,%ebp
801049c5:	83 ec 28             	sub    $0x28,%esp
801049c8:	8d 55 ec             	lea    -0x14(%ebp),%edx
801049cb:	e8 d0 fe ff ff       	call   801048a0 <argfd.constprop.0>
801049d0:	85 c0                	test   %eax,%eax
801049d2:	78 54                	js     80104a28 <sys_write+0x68>
801049d4:	8d 45 f0             	lea    -0x10(%ebp),%eax
801049d7:	89 44 24 04          	mov    %eax,0x4(%esp)
801049db:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
801049e2:	e8 99 fb ff ff       	call   80104580 <argint>
801049e7:	85 c0                	test   %eax,%eax
801049e9:	78 3d                	js     80104a28 <sys_write+0x68>
801049eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801049ee:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801049f5:	89 44 24 08          	mov    %eax,0x8(%esp)
801049f9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801049fc:	89 44 24 04          	mov    %eax,0x4(%esp)
80104a00:	e8 ab fb ff ff       	call   801045b0 <argptr>
80104a05:	85 c0                	test   %eax,%eax
80104a07:	78 1f                	js     80104a28 <sys_write+0x68>
80104a09:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104a0c:	89 44 24 08          	mov    %eax,0x8(%esp)
80104a10:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a13:	89 44 24 04          	mov    %eax,0x4(%esp)
80104a17:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104a1a:	89 04 24             	mov    %eax,(%esp)
80104a1d:	e8 be c5 ff ff       	call   80100fe0 <filewrite>
80104a22:	c9                   	leave  
80104a23:	c3                   	ret    
80104a24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a28:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a2d:	c9                   	leave  
80104a2e:	c3                   	ret    
80104a2f:	90                   	nop

80104a30 <sys_close>:
80104a30:	55                   	push   %ebp
80104a31:	89 e5                	mov    %esp,%ebp
80104a33:	83 ec 28             	sub    $0x28,%esp
80104a36:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104a39:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104a3c:	e8 5f fe ff ff       	call   801048a0 <argfd.constprop.0>
80104a41:	85 c0                	test   %eax,%eax
80104a43:	78 23                	js     80104a68 <sys_close+0x38>
80104a45:	e8 56 ec ff ff       	call   801036a0 <myproc>
80104a4a:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104a4d:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104a54:	00 
80104a55:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a58:	89 04 24             	mov    %eax,(%esp)
80104a5b:	e8 d0 c3 ff ff       	call   80100e30 <fileclose>
80104a60:	31 c0                	xor    %eax,%eax
80104a62:	c9                   	leave  
80104a63:	c3                   	ret    
80104a64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a68:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a6d:	c9                   	leave  
80104a6e:	c3                   	ret    
80104a6f:	90                   	nop

80104a70 <sys_fstat>:
80104a70:	55                   	push   %ebp
80104a71:	31 c0                	xor    %eax,%eax
80104a73:	89 e5                	mov    %esp,%ebp
80104a75:	83 ec 28             	sub    $0x28,%esp
80104a78:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104a7b:	e8 20 fe ff ff       	call   801048a0 <argfd.constprop.0>
80104a80:	85 c0                	test   %eax,%eax
80104a82:	78 34                	js     80104ab8 <sys_fstat+0x48>
80104a84:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104a87:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80104a8e:	00 
80104a8f:	89 44 24 04          	mov    %eax,0x4(%esp)
80104a93:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104a9a:	e8 11 fb ff ff       	call   801045b0 <argptr>
80104a9f:	85 c0                	test   %eax,%eax
80104aa1:	78 15                	js     80104ab8 <sys_fstat+0x48>
80104aa3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104aa6:	89 44 24 04          	mov    %eax,0x4(%esp)
80104aaa:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104aad:	89 04 24             	mov    %eax,(%esp)
80104ab0:	e8 3b c4 ff ff       	call   80100ef0 <filestat>
80104ab5:	c9                   	leave  
80104ab6:	c3                   	ret    
80104ab7:	90                   	nop
80104ab8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104abd:	c9                   	leave  
80104abe:	c3                   	ret    
80104abf:	90                   	nop

80104ac0 <sys_link>:
80104ac0:	55                   	push   %ebp
80104ac1:	89 e5                	mov    %esp,%ebp
80104ac3:	57                   	push   %edi
80104ac4:	56                   	push   %esi
80104ac5:	53                   	push   %ebx
80104ac6:	83 ec 3c             	sub    $0x3c,%esp
80104ac9:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104acc:	89 44 24 04          	mov    %eax,0x4(%esp)
80104ad0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104ad7:	e8 34 fb ff ff       	call   80104610 <argstr>
80104adc:	85 c0                	test   %eax,%eax
80104ade:	0f 88 e6 00 00 00    	js     80104bca <sys_link+0x10a>
80104ae4:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104ae7:	89 44 24 04          	mov    %eax,0x4(%esp)
80104aeb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104af2:	e8 19 fb ff ff       	call   80104610 <argstr>
80104af7:	85 c0                	test   %eax,%eax
80104af9:	0f 88 cb 00 00 00    	js     80104bca <sys_link+0x10a>
80104aff:	e8 0c e0 ff ff       	call   80102b10 <begin_op>
80104b04:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80104b07:	89 04 24             	mov    %eax,(%esp)
80104b0a:	e8 01 d4 ff ff       	call   80101f10 <namei>
80104b0f:	85 c0                	test   %eax,%eax
80104b11:	89 c3                	mov    %eax,%ebx
80104b13:	0f 84 ac 00 00 00    	je     80104bc5 <sys_link+0x105>
80104b19:	89 04 24             	mov    %eax,(%esp)
80104b1c:	e8 9f cb ff ff       	call   801016c0 <ilock>
80104b21:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104b26:	0f 84 91 00 00 00    	je     80104bbd <sys_link+0xfd>
80104b2c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
80104b31:	8d 7d da             	lea    -0x26(%ebp),%edi
80104b34:	89 1c 24             	mov    %ebx,(%esp)
80104b37:	e8 c4 ca ff ff       	call   80101600 <iupdate>
80104b3c:	89 1c 24             	mov    %ebx,(%esp)
80104b3f:	e8 5c cc ff ff       	call   801017a0 <iunlock>
80104b44:	8b 45 d0             	mov    -0x30(%ebp),%eax
80104b47:	89 7c 24 04          	mov    %edi,0x4(%esp)
80104b4b:	89 04 24             	mov    %eax,(%esp)
80104b4e:	e8 dd d3 ff ff       	call   80101f30 <nameiparent>
80104b53:	85 c0                	test   %eax,%eax
80104b55:	89 c6                	mov    %eax,%esi
80104b57:	74 4f                	je     80104ba8 <sys_link+0xe8>
80104b59:	89 04 24             	mov    %eax,(%esp)
80104b5c:	e8 5f cb ff ff       	call   801016c0 <ilock>
80104b61:	8b 03                	mov    (%ebx),%eax
80104b63:	39 06                	cmp    %eax,(%esi)
80104b65:	75 39                	jne    80104ba0 <sys_link+0xe0>
80104b67:	8b 43 04             	mov    0x4(%ebx),%eax
80104b6a:	89 7c 24 04          	mov    %edi,0x4(%esp)
80104b6e:	89 34 24             	mov    %esi,(%esp)
80104b71:	89 44 24 08          	mov    %eax,0x8(%esp)
80104b75:	e8 b6 d2 ff ff       	call   80101e30 <dirlink>
80104b7a:	85 c0                	test   %eax,%eax
80104b7c:	78 22                	js     80104ba0 <sys_link+0xe0>
80104b7e:	89 34 24             	mov    %esi,(%esp)
80104b81:	e8 9a cd ff ff       	call   80101920 <iunlockput>
80104b86:	89 1c 24             	mov    %ebx,(%esp)
80104b89:	e8 52 cc ff ff       	call   801017e0 <iput>
80104b8e:	e8 ed df ff ff       	call   80102b80 <end_op>
80104b93:	83 c4 3c             	add    $0x3c,%esp
80104b96:	31 c0                	xor    %eax,%eax
80104b98:	5b                   	pop    %ebx
80104b99:	5e                   	pop    %esi
80104b9a:	5f                   	pop    %edi
80104b9b:	5d                   	pop    %ebp
80104b9c:	c3                   	ret    
80104b9d:	8d 76 00             	lea    0x0(%esi),%esi
80104ba0:	89 34 24             	mov    %esi,(%esp)
80104ba3:	e8 78 cd ff ff       	call   80101920 <iunlockput>
80104ba8:	89 1c 24             	mov    %ebx,(%esp)
80104bab:	e8 10 cb ff ff       	call   801016c0 <ilock>
80104bb0:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
80104bb5:	89 1c 24             	mov    %ebx,(%esp)
80104bb8:	e8 43 ca ff ff       	call   80101600 <iupdate>
80104bbd:	89 1c 24             	mov    %ebx,(%esp)
80104bc0:	e8 5b cd ff ff       	call   80101920 <iunlockput>
80104bc5:	e8 b6 df ff ff       	call   80102b80 <end_op>
80104bca:	83 c4 3c             	add    $0x3c,%esp
80104bcd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104bd2:	5b                   	pop    %ebx
80104bd3:	5e                   	pop    %esi
80104bd4:	5f                   	pop    %edi
80104bd5:	5d                   	pop    %ebp
80104bd6:	c3                   	ret    
80104bd7:	89 f6                	mov    %esi,%esi
80104bd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104be0 <sys_unlink>:
80104be0:	55                   	push   %ebp
80104be1:	89 e5                	mov    %esp,%ebp
80104be3:	57                   	push   %edi
80104be4:	56                   	push   %esi
80104be5:	53                   	push   %ebx
80104be6:	83 ec 5c             	sub    $0x5c,%esp
80104be9:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104bec:	89 44 24 04          	mov    %eax,0x4(%esp)
80104bf0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104bf7:	e8 14 fa ff ff       	call   80104610 <argstr>
80104bfc:	85 c0                	test   %eax,%eax
80104bfe:	0f 88 76 01 00 00    	js     80104d7a <sys_unlink+0x19a>
80104c04:	e8 07 df ff ff       	call   80102b10 <begin_op>
80104c09:	8b 45 c0             	mov    -0x40(%ebp),%eax
80104c0c:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80104c0f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104c13:	89 04 24             	mov    %eax,(%esp)
80104c16:	e8 15 d3 ff ff       	call   80101f30 <nameiparent>
80104c1b:	85 c0                	test   %eax,%eax
80104c1d:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80104c20:	0f 84 4f 01 00 00    	je     80104d75 <sys_unlink+0x195>
80104c26:	8b 75 b4             	mov    -0x4c(%ebp),%esi
80104c29:	89 34 24             	mov    %esi,(%esp)
80104c2c:	e8 8f ca ff ff       	call   801016c0 <ilock>
80104c31:	c7 44 24 04 58 74 10 	movl   $0x80107458,0x4(%esp)
80104c38:	80 
80104c39:	89 1c 24             	mov    %ebx,(%esp)
80104c3c:	e8 5f cf ff ff       	call   80101ba0 <namecmp>
80104c41:	85 c0                	test   %eax,%eax
80104c43:	0f 84 21 01 00 00    	je     80104d6a <sys_unlink+0x18a>
80104c49:	c7 44 24 04 57 74 10 	movl   $0x80107457,0x4(%esp)
80104c50:	80 
80104c51:	89 1c 24             	mov    %ebx,(%esp)
80104c54:	e8 47 cf ff ff       	call   80101ba0 <namecmp>
80104c59:	85 c0                	test   %eax,%eax
80104c5b:	0f 84 09 01 00 00    	je     80104d6a <sys_unlink+0x18a>
80104c61:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104c64:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104c68:	89 44 24 08          	mov    %eax,0x8(%esp)
80104c6c:	89 34 24             	mov    %esi,(%esp)
80104c6f:	e8 5c cf ff ff       	call   80101bd0 <dirlookup>
80104c74:	85 c0                	test   %eax,%eax
80104c76:	89 c3                	mov    %eax,%ebx
80104c78:	0f 84 ec 00 00 00    	je     80104d6a <sys_unlink+0x18a>
80104c7e:	89 04 24             	mov    %eax,(%esp)
80104c81:	e8 3a ca ff ff       	call   801016c0 <ilock>
80104c86:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80104c8b:	0f 8e 24 01 00 00    	jle    80104db5 <sys_unlink+0x1d5>
80104c91:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104c96:	8d 75 d8             	lea    -0x28(%ebp),%esi
80104c99:	74 7d                	je     80104d18 <sys_unlink+0x138>
80104c9b:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80104ca2:	00 
80104ca3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80104caa:	00 
80104cab:	89 34 24             	mov    %esi,(%esp)
80104cae:	e8 cd f5 ff ff       	call   80104280 <memset>
80104cb3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80104cb6:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80104cbd:	00 
80104cbe:	89 74 24 04          	mov    %esi,0x4(%esp)
80104cc2:	89 44 24 08          	mov    %eax,0x8(%esp)
80104cc6:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104cc9:	89 04 24             	mov    %eax,(%esp)
80104ccc:	e8 9f cd ff ff       	call   80101a70 <writei>
80104cd1:	83 f8 10             	cmp    $0x10,%eax
80104cd4:	0f 85 cf 00 00 00    	jne    80104da9 <sys_unlink+0x1c9>
80104cda:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104cdf:	0f 84 a3 00 00 00    	je     80104d88 <sys_unlink+0x1a8>
80104ce5:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104ce8:	89 04 24             	mov    %eax,(%esp)
80104ceb:	e8 30 cc ff ff       	call   80101920 <iunlockput>
80104cf0:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
80104cf5:	89 1c 24             	mov    %ebx,(%esp)
80104cf8:	e8 03 c9 ff ff       	call   80101600 <iupdate>
80104cfd:	89 1c 24             	mov    %ebx,(%esp)
80104d00:	e8 1b cc ff ff       	call   80101920 <iunlockput>
80104d05:	e8 76 de ff ff       	call   80102b80 <end_op>
80104d0a:	83 c4 5c             	add    $0x5c,%esp
80104d0d:	31 c0                	xor    %eax,%eax
80104d0f:	5b                   	pop    %ebx
80104d10:	5e                   	pop    %esi
80104d11:	5f                   	pop    %edi
80104d12:	5d                   	pop    %ebp
80104d13:	c3                   	ret    
80104d14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104d18:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80104d1c:	0f 86 79 ff ff ff    	jbe    80104c9b <sys_unlink+0xbb>
80104d22:	bf 20 00 00 00       	mov    $0x20,%edi
80104d27:	eb 15                	jmp    80104d3e <sys_unlink+0x15e>
80104d29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d30:	8d 57 10             	lea    0x10(%edi),%edx
80104d33:	3b 53 58             	cmp    0x58(%ebx),%edx
80104d36:	0f 83 5f ff ff ff    	jae    80104c9b <sys_unlink+0xbb>
80104d3c:	89 d7                	mov    %edx,%edi
80104d3e:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80104d45:	00 
80104d46:	89 7c 24 08          	mov    %edi,0x8(%esp)
80104d4a:	89 74 24 04          	mov    %esi,0x4(%esp)
80104d4e:	89 1c 24             	mov    %ebx,(%esp)
80104d51:	e8 1a cc ff ff       	call   80101970 <readi>
80104d56:	83 f8 10             	cmp    $0x10,%eax
80104d59:	75 42                	jne    80104d9d <sys_unlink+0x1bd>
80104d5b:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80104d60:	74 ce                	je     80104d30 <sys_unlink+0x150>
80104d62:	89 1c 24             	mov    %ebx,(%esp)
80104d65:	e8 b6 cb ff ff       	call   80101920 <iunlockput>
80104d6a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104d6d:	89 04 24             	mov    %eax,(%esp)
80104d70:	e8 ab cb ff ff       	call   80101920 <iunlockput>
80104d75:	e8 06 de ff ff       	call   80102b80 <end_op>
80104d7a:	83 c4 5c             	add    $0x5c,%esp
80104d7d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d82:	5b                   	pop    %ebx
80104d83:	5e                   	pop    %esi
80104d84:	5f                   	pop    %edi
80104d85:	5d                   	pop    %ebp
80104d86:	c3                   	ret    
80104d87:	90                   	nop
80104d88:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104d8b:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
80104d90:	89 04 24             	mov    %eax,(%esp)
80104d93:	e8 68 c8 ff ff       	call   80101600 <iupdate>
80104d98:	e9 48 ff ff ff       	jmp    80104ce5 <sys_unlink+0x105>
80104d9d:	c7 04 24 7c 74 10 80 	movl   $0x8010747c,(%esp)
80104da4:	e8 b7 b5 ff ff       	call   80100360 <panic>
80104da9:	c7 04 24 8e 74 10 80 	movl   $0x8010748e,(%esp)
80104db0:	e8 ab b5 ff ff       	call   80100360 <panic>
80104db5:	c7 04 24 6a 74 10 80 	movl   $0x8010746a,(%esp)
80104dbc:	e8 9f b5 ff ff       	call   80100360 <panic>
80104dc1:	eb 0d                	jmp    80104dd0 <sys_open>
80104dc3:	90                   	nop
80104dc4:	90                   	nop
80104dc5:	90                   	nop
80104dc6:	90                   	nop
80104dc7:	90                   	nop
80104dc8:	90                   	nop
80104dc9:	90                   	nop
80104dca:	90                   	nop
80104dcb:	90                   	nop
80104dcc:	90                   	nop
80104dcd:	90                   	nop
80104dce:	90                   	nop
80104dcf:	90                   	nop

80104dd0 <sys_open>:
80104dd0:	55                   	push   %ebp
80104dd1:	89 e5                	mov    %esp,%ebp
80104dd3:	57                   	push   %edi
80104dd4:	56                   	push   %esi
80104dd5:	53                   	push   %ebx
80104dd6:	83 ec 2c             	sub    $0x2c,%esp
80104dd9:	8d 45 e0             	lea    -0x20(%ebp),%eax
80104ddc:	89 44 24 04          	mov    %eax,0x4(%esp)
80104de0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104de7:	e8 24 f8 ff ff       	call   80104610 <argstr>
80104dec:	85 c0                	test   %eax,%eax
80104dee:	0f 88 d1 00 00 00    	js     80104ec5 <sys_open+0xf5>
80104df4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80104df7:	89 44 24 04          	mov    %eax,0x4(%esp)
80104dfb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104e02:	e8 79 f7 ff ff       	call   80104580 <argint>
80104e07:	85 c0                	test   %eax,%eax
80104e09:	0f 88 b6 00 00 00    	js     80104ec5 <sys_open+0xf5>
80104e0f:	e8 fc dc ff ff       	call   80102b10 <begin_op>
80104e14:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80104e18:	0f 85 82 00 00 00    	jne    80104ea0 <sys_open+0xd0>
80104e1e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104e21:	89 04 24             	mov    %eax,(%esp)
80104e24:	e8 e7 d0 ff ff       	call   80101f10 <namei>
80104e29:	85 c0                	test   %eax,%eax
80104e2b:	89 c6                	mov    %eax,%esi
80104e2d:	0f 84 8d 00 00 00    	je     80104ec0 <sys_open+0xf0>
80104e33:	89 04 24             	mov    %eax,(%esp)
80104e36:	e8 85 c8 ff ff       	call   801016c0 <ilock>
80104e3b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80104e40:	0f 84 92 00 00 00    	je     80104ed8 <sys_open+0x108>
80104e46:	e8 25 bf ff ff       	call   80100d70 <filealloc>
80104e4b:	85 c0                	test   %eax,%eax
80104e4d:	89 c3                	mov    %eax,%ebx
80104e4f:	0f 84 93 00 00 00    	je     80104ee8 <sys_open+0x118>
80104e55:	e8 86 f8 ff ff       	call   801046e0 <fdalloc>
80104e5a:	85 c0                	test   %eax,%eax
80104e5c:	89 c7                	mov    %eax,%edi
80104e5e:	0f 88 94 00 00 00    	js     80104ef8 <sys_open+0x128>
80104e64:	89 34 24             	mov    %esi,(%esp)
80104e67:	e8 34 c9 ff ff       	call   801017a0 <iunlock>
80104e6c:	e8 0f dd ff ff       	call   80102b80 <end_op>
80104e71:	c7 03 02 00 00 00    	movl   $0x2,(%ebx)
80104e77:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104e7a:	89 73 10             	mov    %esi,0x10(%ebx)
80104e7d:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
80104e84:	89 c2                	mov    %eax,%edx
80104e86:	83 e2 01             	and    $0x1,%edx
80104e89:	83 f2 01             	xor    $0x1,%edx
80104e8c:	a8 03                	test   $0x3,%al
80104e8e:	88 53 08             	mov    %dl,0x8(%ebx)
80104e91:	89 f8                	mov    %edi,%eax
80104e93:	0f 95 43 09          	setne  0x9(%ebx)
80104e97:	83 c4 2c             	add    $0x2c,%esp
80104e9a:	5b                   	pop    %ebx
80104e9b:	5e                   	pop    %esi
80104e9c:	5f                   	pop    %edi
80104e9d:	5d                   	pop    %ebp
80104e9e:	c3                   	ret    
80104e9f:	90                   	nop
80104ea0:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104ea3:	31 c9                	xor    %ecx,%ecx
80104ea5:	ba 02 00 00 00       	mov    $0x2,%edx
80104eaa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104eb1:	e8 6a f8 ff ff       	call   80104720 <create>
80104eb6:	85 c0                	test   %eax,%eax
80104eb8:	89 c6                	mov    %eax,%esi
80104eba:	75 8a                	jne    80104e46 <sys_open+0x76>
80104ebc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104ec0:	e8 bb dc ff ff       	call   80102b80 <end_op>
80104ec5:	83 c4 2c             	add    $0x2c,%esp
80104ec8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ecd:	5b                   	pop    %ebx
80104ece:	5e                   	pop    %esi
80104ecf:	5f                   	pop    %edi
80104ed0:	5d                   	pop    %ebp
80104ed1:	c3                   	ret    
80104ed2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104ed8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104edb:	85 c0                	test   %eax,%eax
80104edd:	0f 84 63 ff ff ff    	je     80104e46 <sys_open+0x76>
80104ee3:	90                   	nop
80104ee4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104ee8:	89 34 24             	mov    %esi,(%esp)
80104eeb:	e8 30 ca ff ff       	call   80101920 <iunlockput>
80104ef0:	eb ce                	jmp    80104ec0 <sys_open+0xf0>
80104ef2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104ef8:	89 1c 24             	mov    %ebx,(%esp)
80104efb:	e8 30 bf ff ff       	call   80100e30 <fileclose>
80104f00:	eb e6                	jmp    80104ee8 <sys_open+0x118>
80104f02:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104f10 <sys_mkdir>:
80104f10:	55                   	push   %ebp
80104f11:	89 e5                	mov    %esp,%ebp
80104f13:	83 ec 28             	sub    $0x28,%esp
80104f16:	e8 f5 db ff ff       	call   80102b10 <begin_op>
80104f1b:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104f1e:	89 44 24 04          	mov    %eax,0x4(%esp)
80104f22:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104f29:	e8 e2 f6 ff ff       	call   80104610 <argstr>
80104f2e:	85 c0                	test   %eax,%eax
80104f30:	78 2e                	js     80104f60 <sys_mkdir+0x50>
80104f32:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f35:	31 c9                	xor    %ecx,%ecx
80104f37:	ba 01 00 00 00       	mov    $0x1,%edx
80104f3c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104f43:	e8 d8 f7 ff ff       	call   80104720 <create>
80104f48:	85 c0                	test   %eax,%eax
80104f4a:	74 14                	je     80104f60 <sys_mkdir+0x50>
80104f4c:	89 04 24             	mov    %eax,(%esp)
80104f4f:	e8 cc c9 ff ff       	call   80101920 <iunlockput>
80104f54:	e8 27 dc ff ff       	call   80102b80 <end_op>
80104f59:	31 c0                	xor    %eax,%eax
80104f5b:	c9                   	leave  
80104f5c:	c3                   	ret    
80104f5d:	8d 76 00             	lea    0x0(%esi),%esi
80104f60:	e8 1b dc ff ff       	call   80102b80 <end_op>
80104f65:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f6a:	c9                   	leave  
80104f6b:	c3                   	ret    
80104f6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104f70 <sys_mknod>:
80104f70:	55                   	push   %ebp
80104f71:	89 e5                	mov    %esp,%ebp
80104f73:	83 ec 28             	sub    $0x28,%esp
80104f76:	e8 95 db ff ff       	call   80102b10 <begin_op>
80104f7b:	8d 45 ec             	lea    -0x14(%ebp),%eax
80104f7e:	89 44 24 04          	mov    %eax,0x4(%esp)
80104f82:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104f89:	e8 82 f6 ff ff       	call   80104610 <argstr>
80104f8e:	85 c0                	test   %eax,%eax
80104f90:	78 5e                	js     80104ff0 <sys_mknod+0x80>
80104f92:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104f95:	89 44 24 04          	mov    %eax,0x4(%esp)
80104f99:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104fa0:	e8 db f5 ff ff       	call   80104580 <argint>
80104fa5:	85 c0                	test   %eax,%eax
80104fa7:	78 47                	js     80104ff0 <sys_mknod+0x80>
80104fa9:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104fac:	89 44 24 04          	mov    %eax,0x4(%esp)
80104fb0:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80104fb7:	e8 c4 f5 ff ff       	call   80104580 <argint>
80104fbc:	85 c0                	test   %eax,%eax
80104fbe:	78 30                	js     80104ff0 <sys_mknod+0x80>
80104fc0:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80104fc4:	ba 03 00 00 00       	mov    $0x3,%edx
80104fc9:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80104fcd:	89 04 24             	mov    %eax,(%esp)
80104fd0:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104fd3:	e8 48 f7 ff ff       	call   80104720 <create>
80104fd8:	85 c0                	test   %eax,%eax
80104fda:	74 14                	je     80104ff0 <sys_mknod+0x80>
80104fdc:	89 04 24             	mov    %eax,(%esp)
80104fdf:	e8 3c c9 ff ff       	call   80101920 <iunlockput>
80104fe4:	e8 97 db ff ff       	call   80102b80 <end_op>
80104fe9:	31 c0                	xor    %eax,%eax
80104feb:	c9                   	leave  
80104fec:	c3                   	ret    
80104fed:	8d 76 00             	lea    0x0(%esi),%esi
80104ff0:	e8 8b db ff ff       	call   80102b80 <end_op>
80104ff5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ffa:	c9                   	leave  
80104ffb:	c3                   	ret    
80104ffc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105000 <sys_chdir>:
80105000:	55                   	push   %ebp
80105001:	89 e5                	mov    %esp,%ebp
80105003:	56                   	push   %esi
80105004:	53                   	push   %ebx
80105005:	83 ec 20             	sub    $0x20,%esp
80105008:	e8 93 e6 ff ff       	call   801036a0 <myproc>
8010500d:	89 c6                	mov    %eax,%esi
8010500f:	e8 fc da ff ff       	call   80102b10 <begin_op>
80105014:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105017:	89 44 24 04          	mov    %eax,0x4(%esp)
8010501b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105022:	e8 e9 f5 ff ff       	call   80104610 <argstr>
80105027:	85 c0                	test   %eax,%eax
80105029:	78 4a                	js     80105075 <sys_chdir+0x75>
8010502b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010502e:	89 04 24             	mov    %eax,(%esp)
80105031:	e8 da ce ff ff       	call   80101f10 <namei>
80105036:	85 c0                	test   %eax,%eax
80105038:	89 c3                	mov    %eax,%ebx
8010503a:	74 39                	je     80105075 <sys_chdir+0x75>
8010503c:	89 04 24             	mov    %eax,(%esp)
8010503f:	e8 7c c6 ff ff       	call   801016c0 <ilock>
80105044:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105049:	89 1c 24             	mov    %ebx,(%esp)
8010504c:	75 22                	jne    80105070 <sys_chdir+0x70>
8010504e:	e8 4d c7 ff ff       	call   801017a0 <iunlock>
80105053:	8b 46 68             	mov    0x68(%esi),%eax
80105056:	89 04 24             	mov    %eax,(%esp)
80105059:	e8 82 c7 ff ff       	call   801017e0 <iput>
8010505e:	e8 1d db ff ff       	call   80102b80 <end_op>
80105063:	31 c0                	xor    %eax,%eax
80105065:	89 5e 68             	mov    %ebx,0x68(%esi)
80105068:	83 c4 20             	add    $0x20,%esp
8010506b:	5b                   	pop    %ebx
8010506c:	5e                   	pop    %esi
8010506d:	5d                   	pop    %ebp
8010506e:	c3                   	ret    
8010506f:	90                   	nop
80105070:	e8 ab c8 ff ff       	call   80101920 <iunlockput>
80105075:	e8 06 db ff ff       	call   80102b80 <end_op>
8010507a:	83 c4 20             	add    $0x20,%esp
8010507d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105082:	5b                   	pop    %ebx
80105083:	5e                   	pop    %esi
80105084:	5d                   	pop    %ebp
80105085:	c3                   	ret    
80105086:	8d 76 00             	lea    0x0(%esi),%esi
80105089:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105090 <sys_exec>:
80105090:	55                   	push   %ebp
80105091:	89 e5                	mov    %esp,%ebp
80105093:	57                   	push   %edi
80105094:	56                   	push   %esi
80105095:	53                   	push   %ebx
80105096:	81 ec ac 00 00 00    	sub    $0xac,%esp
8010509c:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
801050a2:	89 44 24 04          	mov    %eax,0x4(%esp)
801050a6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801050ad:	e8 5e f5 ff ff       	call   80104610 <argstr>
801050b2:	85 c0                	test   %eax,%eax
801050b4:	0f 88 84 00 00 00    	js     8010513e <sys_exec+0xae>
801050ba:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801050c0:	89 44 24 04          	mov    %eax,0x4(%esp)
801050c4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801050cb:	e8 b0 f4 ff ff       	call   80104580 <argint>
801050d0:	85 c0                	test   %eax,%eax
801050d2:	78 6a                	js     8010513e <sys_exec+0xae>
801050d4:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801050da:	31 db                	xor    %ebx,%ebx
801050dc:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
801050e3:	00 
801050e4:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
801050ea:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801050f1:	00 
801050f2:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
801050f8:	89 04 24             	mov    %eax,(%esp)
801050fb:	e8 80 f1 ff ff       	call   80104280 <memset>
80105100:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105106:	89 7c 24 04          	mov    %edi,0x4(%esp)
8010510a:	8d 04 98             	lea    (%eax,%ebx,4),%eax
8010510d:	89 04 24             	mov    %eax,(%esp)
80105110:	e8 cb f3 ff ff       	call   801044e0 <fetchint>
80105115:	85 c0                	test   %eax,%eax
80105117:	78 25                	js     8010513e <sys_exec+0xae>
80105119:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010511f:	85 c0                	test   %eax,%eax
80105121:	74 2d                	je     80105150 <sys_exec+0xc0>
80105123:	89 74 24 04          	mov    %esi,0x4(%esp)
80105127:	89 04 24             	mov    %eax,(%esp)
8010512a:	e8 f1 f3 ff ff       	call   80104520 <fetchstr>
8010512f:	85 c0                	test   %eax,%eax
80105131:	78 0b                	js     8010513e <sys_exec+0xae>
80105133:	83 c3 01             	add    $0x1,%ebx
80105136:	83 c6 04             	add    $0x4,%esi
80105139:	83 fb 20             	cmp    $0x20,%ebx
8010513c:	75 c2                	jne    80105100 <sys_exec+0x70>
8010513e:	81 c4 ac 00 00 00    	add    $0xac,%esp
80105144:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105149:	5b                   	pop    %ebx
8010514a:	5e                   	pop    %esi
8010514b:	5f                   	pop    %edi
8010514c:	5d                   	pop    %ebp
8010514d:	c3                   	ret    
8010514e:	66 90                	xchg   %ax,%ax
80105150:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105156:	89 44 24 04          	mov    %eax,0x4(%esp)
8010515a:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
80105160:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105167:	00 00 00 00 
8010516b:	89 04 24             	mov    %eax,(%esp)
8010516e:	e8 2d b8 ff ff       	call   801009a0 <exec>
80105173:	81 c4 ac 00 00 00    	add    $0xac,%esp
80105179:	5b                   	pop    %ebx
8010517a:	5e                   	pop    %esi
8010517b:	5f                   	pop    %edi
8010517c:	5d                   	pop    %ebp
8010517d:	c3                   	ret    
8010517e:	66 90                	xchg   %ax,%ax

80105180 <sys_pipe>:
80105180:	55                   	push   %ebp
80105181:	89 e5                	mov    %esp,%ebp
80105183:	53                   	push   %ebx
80105184:	83 ec 24             	sub    $0x24,%esp
80105187:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010518a:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
80105191:	00 
80105192:	89 44 24 04          	mov    %eax,0x4(%esp)
80105196:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010519d:	e8 0e f4 ff ff       	call   801045b0 <argptr>
801051a2:	85 c0                	test   %eax,%eax
801051a4:	78 6d                	js     80105213 <sys_pipe+0x93>
801051a6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801051a9:	89 44 24 04          	mov    %eax,0x4(%esp)
801051ad:	8d 45 f0             	lea    -0x10(%ebp),%eax
801051b0:	89 04 24             	mov    %eax,(%esp)
801051b3:	e8 b8 df ff ff       	call   80103170 <pipealloc>
801051b8:	85 c0                	test   %eax,%eax
801051ba:	78 57                	js     80105213 <sys_pipe+0x93>
801051bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801051bf:	e8 1c f5 ff ff       	call   801046e0 <fdalloc>
801051c4:	85 c0                	test   %eax,%eax
801051c6:	89 c3                	mov    %eax,%ebx
801051c8:	78 33                	js     801051fd <sys_pipe+0x7d>
801051ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051cd:	e8 0e f5 ff ff       	call   801046e0 <fdalloc>
801051d2:	85 c0                	test   %eax,%eax
801051d4:	78 1a                	js     801051f0 <sys_pipe+0x70>
801051d6:	8b 55 ec             	mov    -0x14(%ebp),%edx
801051d9:	89 1a                	mov    %ebx,(%edx)
801051db:	8b 55 ec             	mov    -0x14(%ebp),%edx
801051de:	89 42 04             	mov    %eax,0x4(%edx)
801051e1:	83 c4 24             	add    $0x24,%esp
801051e4:	31 c0                	xor    %eax,%eax
801051e6:	5b                   	pop    %ebx
801051e7:	5d                   	pop    %ebp
801051e8:	c3                   	ret    
801051e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801051f0:	e8 ab e4 ff ff       	call   801036a0 <myproc>
801051f5:	c7 44 98 28 00 00 00 	movl   $0x0,0x28(%eax,%ebx,4)
801051fc:	00 
801051fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105200:	89 04 24             	mov    %eax,(%esp)
80105203:	e8 28 bc ff ff       	call   80100e30 <fileclose>
80105208:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010520b:	89 04 24             	mov    %eax,(%esp)
8010520e:	e8 1d bc ff ff       	call   80100e30 <fileclose>
80105213:	83 c4 24             	add    $0x24,%esp
80105216:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010521b:	5b                   	pop    %ebx
8010521c:	5d                   	pop    %ebp
8010521d:	c3                   	ret    
	...

80105220 <sys_fork>:
80105220:	55                   	push   %ebp
80105221:	89 e5                	mov    %esp,%ebp
80105223:	5d                   	pop    %ebp
80105224:	e9 27 e6 ff ff       	jmp    80103850 <fork>
80105229:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105230 <sys_exit>:
80105230:	55                   	push   %ebp
80105231:	89 e5                	mov    %esp,%ebp
80105233:	83 ec 08             	sub    $0x8,%esp
80105236:	e8 65 e8 ff ff       	call   80103aa0 <exit>
8010523b:	31 c0                	xor    %eax,%eax
8010523d:	c9                   	leave  
8010523e:	c3                   	ret    
8010523f:	90                   	nop

80105240 <sys_wait>:
80105240:	55                   	push   %ebp
80105241:	89 e5                	mov    %esp,%ebp
80105243:	5d                   	pop    %ebp
80105244:	e9 67 ea ff ff       	jmp    80103cb0 <wait>
80105249:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105250 <sys_kill>:
80105250:	55                   	push   %ebp
80105251:	89 e5                	mov    %esp,%ebp
80105253:	83 ec 28             	sub    $0x28,%esp
80105256:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105259:	89 44 24 04          	mov    %eax,0x4(%esp)
8010525d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105264:	e8 17 f3 ff ff       	call   80104580 <argint>
80105269:	85 c0                	test   %eax,%eax
8010526b:	78 13                	js     80105280 <sys_kill+0x30>
8010526d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105270:	89 04 24             	mov    %eax,(%esp)
80105273:	e8 78 eb ff ff       	call   80103df0 <kill>
80105278:	c9                   	leave  
80105279:	c3                   	ret    
8010527a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105280:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105285:	c9                   	leave  
80105286:	c3                   	ret    
80105287:	89 f6                	mov    %esi,%esi
80105289:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105290 <sys_getpid>:
80105290:	55                   	push   %ebp
80105291:	89 e5                	mov    %esp,%ebp
80105293:	83 ec 08             	sub    $0x8,%esp
80105296:	e8 05 e4 ff ff       	call   801036a0 <myproc>
8010529b:	8b 40 10             	mov    0x10(%eax),%eax
8010529e:	c9                   	leave  
8010529f:	c3                   	ret    

801052a0 <sys_sbrk>:
801052a0:	55                   	push   %ebp
801052a1:	89 e5                	mov    %esp,%ebp
801052a3:	53                   	push   %ebx
801052a4:	83 ec 24             	sub    $0x24,%esp
801052a7:	8d 45 f4             	lea    -0xc(%ebp),%eax
801052aa:	89 44 24 04          	mov    %eax,0x4(%esp)
801052ae:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801052b5:	e8 c6 f2 ff ff       	call   80104580 <argint>
801052ba:	85 c0                	test   %eax,%eax
801052bc:	78 22                	js     801052e0 <sys_sbrk+0x40>
801052be:	e8 dd e3 ff ff       	call   801036a0 <myproc>
801052c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
801052c6:	8b 18                	mov    (%eax),%ebx
801052c8:	89 14 24             	mov    %edx,(%esp)
801052cb:	e8 10 e5 ff ff       	call   801037e0 <growproc>
801052d0:	85 c0                	test   %eax,%eax
801052d2:	78 0c                	js     801052e0 <sys_sbrk+0x40>
801052d4:	89 d8                	mov    %ebx,%eax
801052d6:	83 c4 24             	add    $0x24,%esp
801052d9:	5b                   	pop    %ebx
801052da:	5d                   	pop    %ebp
801052db:	c3                   	ret    
801052dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801052e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052e5:	eb ef                	jmp    801052d6 <sys_sbrk+0x36>
801052e7:	89 f6                	mov    %esi,%esi
801052e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801052f0 <sys_sleep>:
801052f0:	55                   	push   %ebp
801052f1:	89 e5                	mov    %esp,%ebp
801052f3:	53                   	push   %ebx
801052f4:	83 ec 24             	sub    $0x24,%esp
801052f7:	8d 45 f4             	lea    -0xc(%ebp),%eax
801052fa:	89 44 24 04          	mov    %eax,0x4(%esp)
801052fe:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105305:	e8 76 f2 ff ff       	call   80104580 <argint>
8010530a:	85 c0                	test   %eax,%eax
8010530c:	78 7e                	js     8010538c <sys_sleep+0x9c>
8010530e:	c7 04 24 60 4c 11 80 	movl   $0x80114c60,(%esp)
80105315:	e8 26 ee ff ff       	call   80104140 <acquire>
8010531a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010531d:	8b 1d a0 54 11 80    	mov    0x801154a0,%ebx
80105323:	85 d2                	test   %edx,%edx
80105325:	75 29                	jne    80105350 <sys_sleep+0x60>
80105327:	eb 4f                	jmp    80105378 <sys_sleep+0x88>
80105329:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105330:	c7 44 24 04 60 4c 11 	movl   $0x80114c60,0x4(%esp)
80105337:	80 
80105338:	c7 04 24 a0 54 11 80 	movl   $0x801154a0,(%esp)
8010533f:	e8 bc e8 ff ff       	call   80103c00 <sleep>
80105344:	a1 a0 54 11 80       	mov    0x801154a0,%eax
80105349:	29 d8                	sub    %ebx,%eax
8010534b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010534e:	73 28                	jae    80105378 <sys_sleep+0x88>
80105350:	e8 4b e3 ff ff       	call   801036a0 <myproc>
80105355:	8b 40 24             	mov    0x24(%eax),%eax
80105358:	85 c0                	test   %eax,%eax
8010535a:	74 d4                	je     80105330 <sys_sleep+0x40>
8010535c:	c7 04 24 60 4c 11 80 	movl   $0x80114c60,(%esp)
80105363:	e8 c8 ee ff ff       	call   80104230 <release>
80105368:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010536d:	83 c4 24             	add    $0x24,%esp
80105370:	5b                   	pop    %ebx
80105371:	5d                   	pop    %ebp
80105372:	c3                   	ret    
80105373:	90                   	nop
80105374:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105378:	c7 04 24 60 4c 11 80 	movl   $0x80114c60,(%esp)
8010537f:	e8 ac ee ff ff       	call   80104230 <release>
80105384:	83 c4 24             	add    $0x24,%esp
80105387:	31 c0                	xor    %eax,%eax
80105389:	5b                   	pop    %ebx
8010538a:	5d                   	pop    %ebp
8010538b:	c3                   	ret    
8010538c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105391:	eb da                	jmp    8010536d <sys_sleep+0x7d>
80105393:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105399:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801053a0 <sys_uptime>:
801053a0:	55                   	push   %ebp
801053a1:	89 e5                	mov    %esp,%ebp
801053a3:	53                   	push   %ebx
801053a4:	83 ec 14             	sub    $0x14,%esp
801053a7:	c7 04 24 60 4c 11 80 	movl   $0x80114c60,(%esp)
801053ae:	e8 8d ed ff ff       	call   80104140 <acquire>
801053b3:	8b 1d a0 54 11 80    	mov    0x801154a0,%ebx
801053b9:	c7 04 24 60 4c 11 80 	movl   $0x80114c60,(%esp)
801053c0:	e8 6b ee ff ff       	call   80104230 <release>
801053c5:	83 c4 14             	add    $0x14,%esp
801053c8:	89 d8                	mov    %ebx,%eax
801053ca:	5b                   	pop    %ebx
801053cb:	5d                   	pop    %ebp
801053cc:	c3                   	ret    
801053cd:	8d 76 00             	lea    0x0(%esi),%esi

801053d0 <sys_date>:
801053d0:	55                   	push   %ebp
801053d1:	89 e5                	mov    %esp,%ebp
801053d3:	83 ec 28             	sub    $0x28,%esp
801053d6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801053d9:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
801053e0:	00 
801053e1:	89 44 24 04          	mov    %eax,0x4(%esp)
801053e5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801053ec:	e8 bf f1 ff ff       	call   801045b0 <argptr>
801053f1:	85 c0                	test   %eax,%eax
801053f3:	78 13                	js     80105408 <sys_date+0x38>
801053f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053f8:	89 04 24             	mov    %eax,(%esp)
801053fb:	e8 40 d4 ff ff       	call   80102840 <cmostime>
80105400:	31 c0                	xor    %eax,%eax
80105402:	c9                   	leave  
80105403:	c3                   	ret    
80105404:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105408:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010540d:	c9                   	leave  
8010540e:	c3                   	ret    
	...

80105410 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105410:	1e                   	push   %ds
  pushl %es
80105411:	06                   	push   %es
  pushl %fs
80105412:	0f a0                	push   %fs
  pushl %gs
80105414:	0f a8                	push   %gs
  pushal
80105416:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105417:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
8010541b:	8e d8                	mov    %eax,%ds
  movw %ax, %es
8010541d:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
8010541f:	54                   	push   %esp
  call trap
80105420:	e8 eb 00 00 00       	call   80105510 <trap>
  addl $4, %esp
80105425:	83 c4 04             	add    $0x4,%esp

80105428 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105428:	61                   	popa   
  popl %gs
80105429:	0f a9                	pop    %gs
  popl %fs
8010542b:	0f a1                	pop    %fs
  popl %es
8010542d:	07                   	pop    %es
  popl %ds
8010542e:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
8010542f:	83 c4 08             	add    $0x8,%esp
  iret
80105432:	cf                   	iret   
	...

80105440 <tvinit>:
80105440:	31 c0                	xor    %eax,%eax
80105442:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105448:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
8010544f:	b9 08 00 00 00       	mov    $0x8,%ecx
80105454:	66 89 0c c5 a2 4c 11 	mov    %cx,-0x7feeb35e(,%eax,8)
8010545b:	80 
8010545c:	c6 04 c5 a4 4c 11 80 	movb   $0x0,-0x7feeb35c(,%eax,8)
80105463:	00 
80105464:	c6 04 c5 a5 4c 11 80 	movb   $0x8e,-0x7feeb35b(,%eax,8)
8010546b:	8e 
8010546c:	66 89 14 c5 a0 4c 11 	mov    %dx,-0x7feeb360(,%eax,8)
80105473:	80 
80105474:	c1 ea 10             	shr    $0x10,%edx
80105477:	66 89 14 c5 a6 4c 11 	mov    %dx,-0x7feeb35a(,%eax,8)
8010547e:	80 
8010547f:	83 c0 01             	add    $0x1,%eax
80105482:	3d 00 01 00 00       	cmp    $0x100,%eax
80105487:	75 bf                	jne    80105448 <tvinit+0x8>
80105489:	55                   	push   %ebp
8010548a:	ba 08 00 00 00       	mov    $0x8,%edx
8010548f:	89 e5                	mov    %esp,%ebp
80105491:	83 ec 18             	sub    $0x18,%esp
80105494:	a1 08 a1 10 80       	mov    0x8010a108,%eax
80105499:	c7 44 24 04 45 73 10 	movl   $0x80107345,0x4(%esp)
801054a0:	80 
801054a1:	c7 04 24 60 4c 11 80 	movl   $0x80114c60,(%esp)
801054a8:	66 89 15 a2 4e 11 80 	mov    %dx,0x80114ea2
801054af:	66 a3 a0 4e 11 80    	mov    %ax,0x80114ea0
801054b5:	c1 e8 10             	shr    $0x10,%eax
801054b8:	c6 05 a4 4e 11 80 00 	movb   $0x0,0x80114ea4
801054bf:	c6 05 a5 4e 11 80 ef 	movb   $0xef,0x80114ea5
801054c6:	66 a3 a6 4e 11 80    	mov    %ax,0x80114ea6
801054cc:	e8 7f eb ff ff       	call   80104050 <initlock>
801054d1:	c9                   	leave  
801054d2:	c3                   	ret    
801054d3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801054d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801054e0 <idtinit>:
801054e0:	55                   	push   %ebp
801054e1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
801054e6:	89 e5                	mov    %esp,%ebp
801054e8:	83 ec 10             	sub    $0x10,%esp
801054eb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
801054ef:	b8 a0 4c 11 80       	mov    $0x80114ca0,%eax
801054f4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
801054f8:	c1 e8 10             	shr    $0x10,%eax
801054fb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
801054ff:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105502:	0f 01 18             	lidtl  (%eax)
80105505:	c9                   	leave  
80105506:	c3                   	ret    
80105507:	89 f6                	mov    %esi,%esi
80105509:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105510 <trap>:
80105510:	55                   	push   %ebp
80105511:	89 e5                	mov    %esp,%ebp
80105513:	57                   	push   %edi
80105514:	56                   	push   %esi
80105515:	53                   	push   %ebx
80105516:	83 ec 3c             	sub    $0x3c,%esp
80105519:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010551c:	8b 43 30             	mov    0x30(%ebx),%eax
8010551f:	83 f8 40             	cmp    $0x40,%eax
80105522:	0f 84 a0 01 00 00    	je     801056c8 <trap+0x1b8>
80105528:	83 e8 20             	sub    $0x20,%eax
8010552b:	83 f8 1f             	cmp    $0x1f,%eax
8010552e:	77 08                	ja     80105538 <trap+0x28>
80105530:	ff 24 85 40 75 10 80 	jmp    *-0x7fef8ac0(,%eax,4)
80105537:	90                   	nop
80105538:	e8 63 e1 ff ff       	call   801036a0 <myproc>
8010553d:	85 c0                	test   %eax,%eax
8010553f:	90                   	nop
80105540:	0f 84 fa 01 00 00    	je     80105740 <trap+0x230>
80105546:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
8010554a:	0f 84 f0 01 00 00    	je     80105740 <trap+0x230>
80105550:	0f 20 d1             	mov    %cr2,%ecx
80105553:	8b 53 38             	mov    0x38(%ebx),%edx
80105556:	89 4d d8             	mov    %ecx,-0x28(%ebp)
80105559:	89 55 dc             	mov    %edx,-0x24(%ebp)
8010555c:	e8 1f e1 ff ff       	call   80103680 <cpuid>
80105561:	8b 73 30             	mov    0x30(%ebx),%esi
80105564:	89 c7                	mov    %eax,%edi
80105566:	8b 43 34             	mov    0x34(%ebx),%eax
80105569:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010556c:	e8 2f e1 ff ff       	call   801036a0 <myproc>
80105571:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105574:	e8 27 e1 ff ff       	call   801036a0 <myproc>
80105579:	8b 55 dc             	mov    -0x24(%ebp),%edx
8010557c:	89 74 24 0c          	mov    %esi,0xc(%esp)
80105580:	8b 75 e0             	mov    -0x20(%ebp),%esi
80105583:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105586:	89 7c 24 14          	mov    %edi,0x14(%esp)
8010558a:	89 54 24 18          	mov    %edx,0x18(%esp)
8010558e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80105591:	83 c6 6c             	add    $0x6c,%esi
80105594:	89 4c 24 1c          	mov    %ecx,0x1c(%esp)
80105598:	89 74 24 08          	mov    %esi,0x8(%esp)
8010559c:	89 54 24 10          	mov    %edx,0x10(%esp)
801055a0:	8b 40 10             	mov    0x10(%eax),%eax
801055a3:	c7 04 24 fc 74 10 80 	movl   $0x801074fc,(%esp)
801055aa:	89 44 24 04          	mov    %eax,0x4(%esp)
801055ae:	e8 9d b0 ff ff       	call   80100650 <cprintf>
801055b3:	e8 e8 e0 ff ff       	call   801036a0 <myproc>
801055b8:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
801055bf:	90                   	nop
801055c0:	e8 db e0 ff ff       	call   801036a0 <myproc>
801055c5:	85 c0                	test   %eax,%eax
801055c7:	74 0c                	je     801055d5 <trap+0xc5>
801055c9:	e8 d2 e0 ff ff       	call   801036a0 <myproc>
801055ce:	8b 40 24             	mov    0x24(%eax),%eax
801055d1:	85 c0                	test   %eax,%eax
801055d3:	75 4b                	jne    80105620 <trap+0x110>
801055d5:	e8 c6 e0 ff ff       	call   801036a0 <myproc>
801055da:	85 c0                	test   %eax,%eax
801055dc:	74 0d                	je     801055eb <trap+0xdb>
801055de:	66 90                	xchg   %ax,%ax
801055e0:	e8 bb e0 ff ff       	call   801036a0 <myproc>
801055e5:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
801055e9:	74 4d                	je     80105638 <trap+0x128>
801055eb:	e8 b0 e0 ff ff       	call   801036a0 <myproc>
801055f0:	85 c0                	test   %eax,%eax
801055f2:	74 1d                	je     80105611 <trap+0x101>
801055f4:	e8 a7 e0 ff ff       	call   801036a0 <myproc>
801055f9:	8b 40 24             	mov    0x24(%eax),%eax
801055fc:	85 c0                	test   %eax,%eax
801055fe:	74 11                	je     80105611 <trap+0x101>
80105600:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105604:	83 e0 03             	and    $0x3,%eax
80105607:	66 83 f8 03          	cmp    $0x3,%ax
8010560b:	0f 84 e8 00 00 00    	je     801056f9 <trap+0x1e9>
80105611:	83 c4 3c             	add    $0x3c,%esp
80105614:	5b                   	pop    %ebx
80105615:	5e                   	pop    %esi
80105616:	5f                   	pop    %edi
80105617:	5d                   	pop    %ebp
80105618:	c3                   	ret    
80105619:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105620:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105624:	83 e0 03             	and    $0x3,%eax
80105627:	66 83 f8 03          	cmp    $0x3,%ax
8010562b:	75 a8                	jne    801055d5 <trap+0xc5>
8010562d:	e8 6e e4 ff ff       	call   80103aa0 <exit>
80105632:	eb a1                	jmp    801055d5 <trap+0xc5>
80105634:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105638:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
8010563c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105640:	75 a9                	jne    801055eb <trap+0xdb>
80105642:	e8 79 e5 ff ff       	call   80103bc0 <yield>
80105647:	eb a2                	jmp    801055eb <trap+0xdb>
80105649:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105650:	e8 2b e0 ff ff       	call   80103680 <cpuid>
80105655:	85 c0                	test   %eax,%eax
80105657:	0f 84 b3 00 00 00    	je     80105710 <trap+0x200>
8010565d:	8d 76 00             	lea    0x0(%esi),%esi
80105660:	e8 1b d1 ff ff       	call   80102780 <lapiceoi>
80105665:	e9 56 ff ff ff       	jmp    801055c0 <trap+0xb0>
8010566a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105670:	e8 6b cf ff ff       	call   801025e0 <kbdintr>
80105675:	e8 06 d1 ff ff       	call   80102780 <lapiceoi>
8010567a:	e9 41 ff ff ff       	jmp    801055c0 <trap+0xb0>
8010567f:	90                   	nop
80105680:	e8 0b 02 00 00       	call   80105890 <uartintr>
80105685:	e8 f6 d0 ff ff       	call   80102780 <lapiceoi>
8010568a:	e9 31 ff ff ff       	jmp    801055c0 <trap+0xb0>
8010568f:	90                   	nop
80105690:	8b 7b 38             	mov    0x38(%ebx),%edi
80105693:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105697:	e8 e4 df ff ff       	call   80103680 <cpuid>
8010569c:	c7 04 24 a4 74 10 80 	movl   $0x801074a4,(%esp)
801056a3:	89 7c 24 0c          	mov    %edi,0xc(%esp)
801056a7:	89 74 24 08          	mov    %esi,0x8(%esp)
801056ab:	89 44 24 04          	mov    %eax,0x4(%esp)
801056af:	e8 9c af ff ff       	call   80100650 <cprintf>
801056b4:	e8 c7 d0 ff ff       	call   80102780 <lapiceoi>
801056b9:	e9 02 ff ff ff       	jmp    801055c0 <trap+0xb0>
801056be:	66 90                	xchg   %ax,%ax
801056c0:	e8 cb c9 ff ff       	call   80102090 <ideintr>
801056c5:	eb 96                	jmp    8010565d <trap+0x14d>
801056c7:	90                   	nop
801056c8:	90                   	nop
801056c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056d0:	e8 cb df ff ff       	call   801036a0 <myproc>
801056d5:	8b 40 24             	mov    0x24(%eax),%eax
801056d8:	85 c0                	test   %eax,%eax
801056da:	75 2c                	jne    80105708 <trap+0x1f8>
801056dc:	e8 bf df ff ff       	call   801036a0 <myproc>
801056e1:	89 58 18             	mov    %ebx,0x18(%eax)
801056e4:	e8 67 ef ff ff       	call   80104650 <syscall>
801056e9:	e8 b2 df ff ff       	call   801036a0 <myproc>
801056ee:	8b 40 24             	mov    0x24(%eax),%eax
801056f1:	85 c0                	test   %eax,%eax
801056f3:	0f 84 18 ff ff ff    	je     80105611 <trap+0x101>
801056f9:	83 c4 3c             	add    $0x3c,%esp
801056fc:	5b                   	pop    %ebx
801056fd:	5e                   	pop    %esi
801056fe:	5f                   	pop    %edi
801056ff:	5d                   	pop    %ebp
80105700:	e9 9b e3 ff ff       	jmp    80103aa0 <exit>
80105705:	8d 76 00             	lea    0x0(%esi),%esi
80105708:	e8 93 e3 ff ff       	call   80103aa0 <exit>
8010570d:	eb cd                	jmp    801056dc <trap+0x1cc>
8010570f:	90                   	nop
80105710:	c7 04 24 60 4c 11 80 	movl   $0x80114c60,(%esp)
80105717:	e8 24 ea ff ff       	call   80104140 <acquire>
8010571c:	c7 04 24 a0 54 11 80 	movl   $0x801154a0,(%esp)
80105723:	83 05 a0 54 11 80 01 	addl   $0x1,0x801154a0
8010572a:	e8 61 e6 ff ff       	call   80103d90 <wakeup>
8010572f:	c7 04 24 60 4c 11 80 	movl   $0x80114c60,(%esp)
80105736:	e8 f5 ea ff ff       	call   80104230 <release>
8010573b:	e9 1d ff ff ff       	jmp    8010565d <trap+0x14d>
80105740:	0f 20 d7             	mov    %cr2,%edi
80105743:	8b 73 38             	mov    0x38(%ebx),%esi
80105746:	e8 35 df ff ff       	call   80103680 <cpuid>
8010574b:	89 7c 24 10          	mov    %edi,0x10(%esp)
8010574f:	89 74 24 0c          	mov    %esi,0xc(%esp)
80105753:	89 44 24 08          	mov    %eax,0x8(%esp)
80105757:	8b 43 30             	mov    0x30(%ebx),%eax
8010575a:	c7 04 24 c8 74 10 80 	movl   $0x801074c8,(%esp)
80105761:	89 44 24 04          	mov    %eax,0x4(%esp)
80105765:	e8 e6 ae ff ff       	call   80100650 <cprintf>
8010576a:	c7 04 24 9d 74 10 80 	movl   $0x8010749d,(%esp)
80105771:	e8 ea ab ff ff       	call   80100360 <panic>
	...

80105780 <uartgetc>:
80105780:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
80105785:	55                   	push   %ebp
80105786:	89 e5                	mov    %esp,%ebp
80105788:	85 c0                	test   %eax,%eax
8010578a:	74 14                	je     801057a0 <uartgetc+0x20>
8010578c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105791:	ec                   	in     (%dx),%al
80105792:	a8 01                	test   $0x1,%al
80105794:	74 0a                	je     801057a0 <uartgetc+0x20>
80105796:	b2 f8                	mov    $0xf8,%dl
80105798:	ec                   	in     (%dx),%al
80105799:	0f b6 c0             	movzbl %al,%eax
8010579c:	5d                   	pop    %ebp
8010579d:	c3                   	ret    
8010579e:	66 90                	xchg   %ax,%ax
801057a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057a5:	5d                   	pop    %ebp
801057a6:	c3                   	ret    
801057a7:	89 f6                	mov    %esi,%esi
801057a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801057b0 <uartputc>:
801057b0:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
801057b6:	85 d2                	test   %edx,%edx
801057b8:	74 3e                	je     801057f8 <uartputc+0x48>
801057ba:	55                   	push   %ebp
801057bb:	89 e5                	mov    %esp,%ebp
801057bd:	56                   	push   %esi
801057be:	be fd 03 00 00       	mov    $0x3fd,%esi
801057c3:	53                   	push   %ebx
801057c4:	bb 80 00 00 00       	mov    $0x80,%ebx
801057c9:	83 ec 10             	sub    $0x10,%esp
801057cc:	eb 13                	jmp    801057e1 <uartputc+0x31>
801057ce:	66 90                	xchg   %ax,%ax
801057d0:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
801057d7:	e8 c4 cf ff ff       	call   801027a0 <microdelay>
801057dc:	83 eb 01             	sub    $0x1,%ebx
801057df:	74 07                	je     801057e8 <uartputc+0x38>
801057e1:	89 f2                	mov    %esi,%edx
801057e3:	ec                   	in     (%dx),%al
801057e4:	a8 20                	test   $0x20,%al
801057e6:	74 e8                	je     801057d0 <uartputc+0x20>
801057e8:	0f b6 45 08          	movzbl 0x8(%ebp),%eax
801057ec:	ba f8 03 00 00       	mov    $0x3f8,%edx
801057f1:	ee                   	out    %al,(%dx)
801057f2:	83 c4 10             	add    $0x10,%esp
801057f5:	5b                   	pop    %ebx
801057f6:	5e                   	pop    %esi
801057f7:	5d                   	pop    %ebp
801057f8:	f3 c3                	repz ret 
801057fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105800 <uartinit>:
80105800:	ba fa 03 00 00       	mov    $0x3fa,%edx
80105805:	31 c0                	xor    %eax,%eax
80105807:	ee                   	out    %al,(%dx)
80105808:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010580d:	b2 fb                	mov    $0xfb,%dl
8010580f:	ee                   	out    %al,(%dx)
80105810:	b8 0c 00 00 00       	mov    $0xc,%eax
80105815:	b2 f8                	mov    $0xf8,%dl
80105817:	ee                   	out    %al,(%dx)
80105818:	31 c0                	xor    %eax,%eax
8010581a:	b2 f9                	mov    $0xf9,%dl
8010581c:	ee                   	out    %al,(%dx)
8010581d:	b8 03 00 00 00       	mov    $0x3,%eax
80105822:	b2 fb                	mov    $0xfb,%dl
80105824:	ee                   	out    %al,(%dx)
80105825:	31 c0                	xor    %eax,%eax
80105827:	b2 fc                	mov    $0xfc,%dl
80105829:	ee                   	out    %al,(%dx)
8010582a:	b8 01 00 00 00       	mov    $0x1,%eax
8010582f:	b2 f9                	mov    $0xf9,%dl
80105831:	ee                   	out    %al,(%dx)
80105832:	b2 fd                	mov    $0xfd,%dl
80105834:	ec                   	in     (%dx),%al
80105835:	3c ff                	cmp    $0xff,%al
80105837:	74 4e                	je     80105887 <uartinit+0x87>
80105839:	55                   	push   %ebp
8010583a:	b2 fa                	mov    $0xfa,%dl
8010583c:	89 e5                	mov    %esp,%ebp
8010583e:	53                   	push   %ebx
8010583f:	83 ec 14             	sub    $0x14,%esp
80105842:	c7 05 bc a5 10 80 01 	movl   $0x1,0x8010a5bc
80105849:	00 00 00 
8010584c:	ec                   	in     (%dx),%al
8010584d:	b2 f8                	mov    $0xf8,%dl
8010584f:	ec                   	in     (%dx),%al
80105850:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105857:	00 
80105858:	bb c0 75 10 80       	mov    $0x801075c0,%ebx
8010585d:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80105864:	e8 57 ca ff ff       	call   801022c0 <ioapicenable>
80105869:	b8 78 00 00 00       	mov    $0x78,%eax
8010586e:	66 90                	xchg   %ax,%ax
80105870:	89 04 24             	mov    %eax,(%esp)
80105873:	83 c3 01             	add    $0x1,%ebx
80105876:	e8 35 ff ff ff       	call   801057b0 <uartputc>
8010587b:	0f be 03             	movsbl (%ebx),%eax
8010587e:	84 c0                	test   %al,%al
80105880:	75 ee                	jne    80105870 <uartinit+0x70>
80105882:	83 c4 14             	add    $0x14,%esp
80105885:	5b                   	pop    %ebx
80105886:	5d                   	pop    %ebp
80105887:	f3 c3                	repz ret 
80105889:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105890 <uartintr>:
80105890:	55                   	push   %ebp
80105891:	89 e5                	mov    %esp,%ebp
80105893:	83 ec 18             	sub    $0x18,%esp
80105896:	c7 04 24 80 57 10 80 	movl   $0x80105780,(%esp)
8010589d:	e8 0e af ff ff       	call   801007b0 <consoleintr>
801058a2:	c9                   	leave  
801058a3:	c3                   	ret    

801058a4 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801058a4:	6a 00                	push   $0x0
  pushl $0
801058a6:	6a 00                	push   $0x0
  jmp alltraps
801058a8:	e9 63 fb ff ff       	jmp    80105410 <alltraps>

801058ad <vector1>:
.globl vector1
vector1:
  pushl $0
801058ad:	6a 00                	push   $0x0
  pushl $1
801058af:	6a 01                	push   $0x1
  jmp alltraps
801058b1:	e9 5a fb ff ff       	jmp    80105410 <alltraps>

801058b6 <vector2>:
.globl vector2
vector2:
  pushl $0
801058b6:	6a 00                	push   $0x0
  pushl $2
801058b8:	6a 02                	push   $0x2
  jmp alltraps
801058ba:	e9 51 fb ff ff       	jmp    80105410 <alltraps>

801058bf <vector3>:
.globl vector3
vector3:
  pushl $0
801058bf:	6a 00                	push   $0x0
  pushl $3
801058c1:	6a 03                	push   $0x3
  jmp alltraps
801058c3:	e9 48 fb ff ff       	jmp    80105410 <alltraps>

801058c8 <vector4>:
.globl vector4
vector4:
  pushl $0
801058c8:	6a 00                	push   $0x0
  pushl $4
801058ca:	6a 04                	push   $0x4
  jmp alltraps
801058cc:	e9 3f fb ff ff       	jmp    80105410 <alltraps>

801058d1 <vector5>:
.globl vector5
vector5:
  pushl $0
801058d1:	6a 00                	push   $0x0
  pushl $5
801058d3:	6a 05                	push   $0x5
  jmp alltraps
801058d5:	e9 36 fb ff ff       	jmp    80105410 <alltraps>

801058da <vector6>:
.globl vector6
vector6:
  pushl $0
801058da:	6a 00                	push   $0x0
  pushl $6
801058dc:	6a 06                	push   $0x6
  jmp alltraps
801058de:	e9 2d fb ff ff       	jmp    80105410 <alltraps>

801058e3 <vector7>:
.globl vector7
vector7:
  pushl $0
801058e3:	6a 00                	push   $0x0
  pushl $7
801058e5:	6a 07                	push   $0x7
  jmp alltraps
801058e7:	e9 24 fb ff ff       	jmp    80105410 <alltraps>

801058ec <vector8>:
.globl vector8
vector8:
  pushl $8
801058ec:	6a 08                	push   $0x8
  jmp alltraps
801058ee:	e9 1d fb ff ff       	jmp    80105410 <alltraps>

801058f3 <vector9>:
.globl vector9
vector9:
  pushl $0
801058f3:	6a 00                	push   $0x0
  pushl $9
801058f5:	6a 09                	push   $0x9
  jmp alltraps
801058f7:	e9 14 fb ff ff       	jmp    80105410 <alltraps>

801058fc <vector10>:
.globl vector10
vector10:
  pushl $10
801058fc:	6a 0a                	push   $0xa
  jmp alltraps
801058fe:	e9 0d fb ff ff       	jmp    80105410 <alltraps>

80105903 <vector11>:
.globl vector11
vector11:
  pushl $11
80105903:	6a 0b                	push   $0xb
  jmp alltraps
80105905:	e9 06 fb ff ff       	jmp    80105410 <alltraps>

8010590a <vector12>:
.globl vector12
vector12:
  pushl $12
8010590a:	6a 0c                	push   $0xc
  jmp alltraps
8010590c:	e9 ff fa ff ff       	jmp    80105410 <alltraps>

80105911 <vector13>:
.globl vector13
vector13:
  pushl $13
80105911:	6a 0d                	push   $0xd
  jmp alltraps
80105913:	e9 f8 fa ff ff       	jmp    80105410 <alltraps>

80105918 <vector14>:
.globl vector14
vector14:
  pushl $14
80105918:	6a 0e                	push   $0xe
  jmp alltraps
8010591a:	e9 f1 fa ff ff       	jmp    80105410 <alltraps>

8010591f <vector15>:
.globl vector15
vector15:
  pushl $0
8010591f:	6a 00                	push   $0x0
  pushl $15
80105921:	6a 0f                	push   $0xf
  jmp alltraps
80105923:	e9 e8 fa ff ff       	jmp    80105410 <alltraps>

80105928 <vector16>:
.globl vector16
vector16:
  pushl $0
80105928:	6a 00                	push   $0x0
  pushl $16
8010592a:	6a 10                	push   $0x10
  jmp alltraps
8010592c:	e9 df fa ff ff       	jmp    80105410 <alltraps>

80105931 <vector17>:
.globl vector17
vector17:
  pushl $17
80105931:	6a 11                	push   $0x11
  jmp alltraps
80105933:	e9 d8 fa ff ff       	jmp    80105410 <alltraps>

80105938 <vector18>:
.globl vector18
vector18:
  pushl $0
80105938:	6a 00                	push   $0x0
  pushl $18
8010593a:	6a 12                	push   $0x12
  jmp alltraps
8010593c:	e9 cf fa ff ff       	jmp    80105410 <alltraps>

80105941 <vector19>:
.globl vector19
vector19:
  pushl $0
80105941:	6a 00                	push   $0x0
  pushl $19
80105943:	6a 13                	push   $0x13
  jmp alltraps
80105945:	e9 c6 fa ff ff       	jmp    80105410 <alltraps>

8010594a <vector20>:
.globl vector20
vector20:
  pushl $0
8010594a:	6a 00                	push   $0x0
  pushl $20
8010594c:	6a 14                	push   $0x14
  jmp alltraps
8010594e:	e9 bd fa ff ff       	jmp    80105410 <alltraps>

80105953 <vector21>:
.globl vector21
vector21:
  pushl $0
80105953:	6a 00                	push   $0x0
  pushl $21
80105955:	6a 15                	push   $0x15
  jmp alltraps
80105957:	e9 b4 fa ff ff       	jmp    80105410 <alltraps>

8010595c <vector22>:
.globl vector22
vector22:
  pushl $0
8010595c:	6a 00                	push   $0x0
  pushl $22
8010595e:	6a 16                	push   $0x16
  jmp alltraps
80105960:	e9 ab fa ff ff       	jmp    80105410 <alltraps>

80105965 <vector23>:
.globl vector23
vector23:
  pushl $0
80105965:	6a 00                	push   $0x0
  pushl $23
80105967:	6a 17                	push   $0x17
  jmp alltraps
80105969:	e9 a2 fa ff ff       	jmp    80105410 <alltraps>

8010596e <vector24>:
.globl vector24
vector24:
  pushl $0
8010596e:	6a 00                	push   $0x0
  pushl $24
80105970:	6a 18                	push   $0x18
  jmp alltraps
80105972:	e9 99 fa ff ff       	jmp    80105410 <alltraps>

80105977 <vector25>:
.globl vector25
vector25:
  pushl $0
80105977:	6a 00                	push   $0x0
  pushl $25
80105979:	6a 19                	push   $0x19
  jmp alltraps
8010597b:	e9 90 fa ff ff       	jmp    80105410 <alltraps>

80105980 <vector26>:
.globl vector26
vector26:
  pushl $0
80105980:	6a 00                	push   $0x0
  pushl $26
80105982:	6a 1a                	push   $0x1a
  jmp alltraps
80105984:	e9 87 fa ff ff       	jmp    80105410 <alltraps>

80105989 <vector27>:
.globl vector27
vector27:
  pushl $0
80105989:	6a 00                	push   $0x0
  pushl $27
8010598b:	6a 1b                	push   $0x1b
  jmp alltraps
8010598d:	e9 7e fa ff ff       	jmp    80105410 <alltraps>

80105992 <vector28>:
.globl vector28
vector28:
  pushl $0
80105992:	6a 00                	push   $0x0
  pushl $28
80105994:	6a 1c                	push   $0x1c
  jmp alltraps
80105996:	e9 75 fa ff ff       	jmp    80105410 <alltraps>

8010599b <vector29>:
.globl vector29
vector29:
  pushl $0
8010599b:	6a 00                	push   $0x0
  pushl $29
8010599d:	6a 1d                	push   $0x1d
  jmp alltraps
8010599f:	e9 6c fa ff ff       	jmp    80105410 <alltraps>

801059a4 <vector30>:
.globl vector30
vector30:
  pushl $0
801059a4:	6a 00                	push   $0x0
  pushl $30
801059a6:	6a 1e                	push   $0x1e
  jmp alltraps
801059a8:	e9 63 fa ff ff       	jmp    80105410 <alltraps>

801059ad <vector31>:
.globl vector31
vector31:
  pushl $0
801059ad:	6a 00                	push   $0x0
  pushl $31
801059af:	6a 1f                	push   $0x1f
  jmp alltraps
801059b1:	e9 5a fa ff ff       	jmp    80105410 <alltraps>

801059b6 <vector32>:
.globl vector32
vector32:
  pushl $0
801059b6:	6a 00                	push   $0x0
  pushl $32
801059b8:	6a 20                	push   $0x20
  jmp alltraps
801059ba:	e9 51 fa ff ff       	jmp    80105410 <alltraps>

801059bf <vector33>:
.globl vector33
vector33:
  pushl $0
801059bf:	6a 00                	push   $0x0
  pushl $33
801059c1:	6a 21                	push   $0x21
  jmp alltraps
801059c3:	e9 48 fa ff ff       	jmp    80105410 <alltraps>

801059c8 <vector34>:
.globl vector34
vector34:
  pushl $0
801059c8:	6a 00                	push   $0x0
  pushl $34
801059ca:	6a 22                	push   $0x22
  jmp alltraps
801059cc:	e9 3f fa ff ff       	jmp    80105410 <alltraps>

801059d1 <vector35>:
.globl vector35
vector35:
  pushl $0
801059d1:	6a 00                	push   $0x0
  pushl $35
801059d3:	6a 23                	push   $0x23
  jmp alltraps
801059d5:	e9 36 fa ff ff       	jmp    80105410 <alltraps>

801059da <vector36>:
.globl vector36
vector36:
  pushl $0
801059da:	6a 00                	push   $0x0
  pushl $36
801059dc:	6a 24                	push   $0x24
  jmp alltraps
801059de:	e9 2d fa ff ff       	jmp    80105410 <alltraps>

801059e3 <vector37>:
.globl vector37
vector37:
  pushl $0
801059e3:	6a 00                	push   $0x0
  pushl $37
801059e5:	6a 25                	push   $0x25
  jmp alltraps
801059e7:	e9 24 fa ff ff       	jmp    80105410 <alltraps>

801059ec <vector38>:
.globl vector38
vector38:
  pushl $0
801059ec:	6a 00                	push   $0x0
  pushl $38
801059ee:	6a 26                	push   $0x26
  jmp alltraps
801059f0:	e9 1b fa ff ff       	jmp    80105410 <alltraps>

801059f5 <vector39>:
.globl vector39
vector39:
  pushl $0
801059f5:	6a 00                	push   $0x0
  pushl $39
801059f7:	6a 27                	push   $0x27
  jmp alltraps
801059f9:	e9 12 fa ff ff       	jmp    80105410 <alltraps>

801059fe <vector40>:
.globl vector40
vector40:
  pushl $0
801059fe:	6a 00                	push   $0x0
  pushl $40
80105a00:	6a 28                	push   $0x28
  jmp alltraps
80105a02:	e9 09 fa ff ff       	jmp    80105410 <alltraps>

80105a07 <vector41>:
.globl vector41
vector41:
  pushl $0
80105a07:	6a 00                	push   $0x0
  pushl $41
80105a09:	6a 29                	push   $0x29
  jmp alltraps
80105a0b:	e9 00 fa ff ff       	jmp    80105410 <alltraps>

80105a10 <vector42>:
.globl vector42
vector42:
  pushl $0
80105a10:	6a 00                	push   $0x0
  pushl $42
80105a12:	6a 2a                	push   $0x2a
  jmp alltraps
80105a14:	e9 f7 f9 ff ff       	jmp    80105410 <alltraps>

80105a19 <vector43>:
.globl vector43
vector43:
  pushl $0
80105a19:	6a 00                	push   $0x0
  pushl $43
80105a1b:	6a 2b                	push   $0x2b
  jmp alltraps
80105a1d:	e9 ee f9 ff ff       	jmp    80105410 <alltraps>

80105a22 <vector44>:
.globl vector44
vector44:
  pushl $0
80105a22:	6a 00                	push   $0x0
  pushl $44
80105a24:	6a 2c                	push   $0x2c
  jmp alltraps
80105a26:	e9 e5 f9 ff ff       	jmp    80105410 <alltraps>

80105a2b <vector45>:
.globl vector45
vector45:
  pushl $0
80105a2b:	6a 00                	push   $0x0
  pushl $45
80105a2d:	6a 2d                	push   $0x2d
  jmp alltraps
80105a2f:	e9 dc f9 ff ff       	jmp    80105410 <alltraps>

80105a34 <vector46>:
.globl vector46
vector46:
  pushl $0
80105a34:	6a 00                	push   $0x0
  pushl $46
80105a36:	6a 2e                	push   $0x2e
  jmp alltraps
80105a38:	e9 d3 f9 ff ff       	jmp    80105410 <alltraps>

80105a3d <vector47>:
.globl vector47
vector47:
  pushl $0
80105a3d:	6a 00                	push   $0x0
  pushl $47
80105a3f:	6a 2f                	push   $0x2f
  jmp alltraps
80105a41:	e9 ca f9 ff ff       	jmp    80105410 <alltraps>

80105a46 <vector48>:
.globl vector48
vector48:
  pushl $0
80105a46:	6a 00                	push   $0x0
  pushl $48
80105a48:	6a 30                	push   $0x30
  jmp alltraps
80105a4a:	e9 c1 f9 ff ff       	jmp    80105410 <alltraps>

80105a4f <vector49>:
.globl vector49
vector49:
  pushl $0
80105a4f:	6a 00                	push   $0x0
  pushl $49
80105a51:	6a 31                	push   $0x31
  jmp alltraps
80105a53:	e9 b8 f9 ff ff       	jmp    80105410 <alltraps>

80105a58 <vector50>:
.globl vector50
vector50:
  pushl $0
80105a58:	6a 00                	push   $0x0
  pushl $50
80105a5a:	6a 32                	push   $0x32
  jmp alltraps
80105a5c:	e9 af f9 ff ff       	jmp    80105410 <alltraps>

80105a61 <vector51>:
.globl vector51
vector51:
  pushl $0
80105a61:	6a 00                	push   $0x0
  pushl $51
80105a63:	6a 33                	push   $0x33
  jmp alltraps
80105a65:	e9 a6 f9 ff ff       	jmp    80105410 <alltraps>

80105a6a <vector52>:
.globl vector52
vector52:
  pushl $0
80105a6a:	6a 00                	push   $0x0
  pushl $52
80105a6c:	6a 34                	push   $0x34
  jmp alltraps
80105a6e:	e9 9d f9 ff ff       	jmp    80105410 <alltraps>

80105a73 <vector53>:
.globl vector53
vector53:
  pushl $0
80105a73:	6a 00                	push   $0x0
  pushl $53
80105a75:	6a 35                	push   $0x35
  jmp alltraps
80105a77:	e9 94 f9 ff ff       	jmp    80105410 <alltraps>

80105a7c <vector54>:
.globl vector54
vector54:
  pushl $0
80105a7c:	6a 00                	push   $0x0
  pushl $54
80105a7e:	6a 36                	push   $0x36
  jmp alltraps
80105a80:	e9 8b f9 ff ff       	jmp    80105410 <alltraps>

80105a85 <vector55>:
.globl vector55
vector55:
  pushl $0
80105a85:	6a 00                	push   $0x0
  pushl $55
80105a87:	6a 37                	push   $0x37
  jmp alltraps
80105a89:	e9 82 f9 ff ff       	jmp    80105410 <alltraps>

80105a8e <vector56>:
.globl vector56
vector56:
  pushl $0
80105a8e:	6a 00                	push   $0x0
  pushl $56
80105a90:	6a 38                	push   $0x38
  jmp alltraps
80105a92:	e9 79 f9 ff ff       	jmp    80105410 <alltraps>

80105a97 <vector57>:
.globl vector57
vector57:
  pushl $0
80105a97:	6a 00                	push   $0x0
  pushl $57
80105a99:	6a 39                	push   $0x39
  jmp alltraps
80105a9b:	e9 70 f9 ff ff       	jmp    80105410 <alltraps>

80105aa0 <vector58>:
.globl vector58
vector58:
  pushl $0
80105aa0:	6a 00                	push   $0x0
  pushl $58
80105aa2:	6a 3a                	push   $0x3a
  jmp alltraps
80105aa4:	e9 67 f9 ff ff       	jmp    80105410 <alltraps>

80105aa9 <vector59>:
.globl vector59
vector59:
  pushl $0
80105aa9:	6a 00                	push   $0x0
  pushl $59
80105aab:	6a 3b                	push   $0x3b
  jmp alltraps
80105aad:	e9 5e f9 ff ff       	jmp    80105410 <alltraps>

80105ab2 <vector60>:
.globl vector60
vector60:
  pushl $0
80105ab2:	6a 00                	push   $0x0
  pushl $60
80105ab4:	6a 3c                	push   $0x3c
  jmp alltraps
80105ab6:	e9 55 f9 ff ff       	jmp    80105410 <alltraps>

80105abb <vector61>:
.globl vector61
vector61:
  pushl $0
80105abb:	6a 00                	push   $0x0
  pushl $61
80105abd:	6a 3d                	push   $0x3d
  jmp alltraps
80105abf:	e9 4c f9 ff ff       	jmp    80105410 <alltraps>

80105ac4 <vector62>:
.globl vector62
vector62:
  pushl $0
80105ac4:	6a 00                	push   $0x0
  pushl $62
80105ac6:	6a 3e                	push   $0x3e
  jmp alltraps
80105ac8:	e9 43 f9 ff ff       	jmp    80105410 <alltraps>

80105acd <vector63>:
.globl vector63
vector63:
  pushl $0
80105acd:	6a 00                	push   $0x0
  pushl $63
80105acf:	6a 3f                	push   $0x3f
  jmp alltraps
80105ad1:	e9 3a f9 ff ff       	jmp    80105410 <alltraps>

80105ad6 <vector64>:
.globl vector64
vector64:
  pushl $0
80105ad6:	6a 00                	push   $0x0
  pushl $64
80105ad8:	6a 40                	push   $0x40
  jmp alltraps
80105ada:	e9 31 f9 ff ff       	jmp    80105410 <alltraps>

80105adf <vector65>:
.globl vector65
vector65:
  pushl $0
80105adf:	6a 00                	push   $0x0
  pushl $65
80105ae1:	6a 41                	push   $0x41
  jmp alltraps
80105ae3:	e9 28 f9 ff ff       	jmp    80105410 <alltraps>

80105ae8 <vector66>:
.globl vector66
vector66:
  pushl $0
80105ae8:	6a 00                	push   $0x0
  pushl $66
80105aea:	6a 42                	push   $0x42
  jmp alltraps
80105aec:	e9 1f f9 ff ff       	jmp    80105410 <alltraps>

80105af1 <vector67>:
.globl vector67
vector67:
  pushl $0
80105af1:	6a 00                	push   $0x0
  pushl $67
80105af3:	6a 43                	push   $0x43
  jmp alltraps
80105af5:	e9 16 f9 ff ff       	jmp    80105410 <alltraps>

80105afa <vector68>:
.globl vector68
vector68:
  pushl $0
80105afa:	6a 00                	push   $0x0
  pushl $68
80105afc:	6a 44                	push   $0x44
  jmp alltraps
80105afe:	e9 0d f9 ff ff       	jmp    80105410 <alltraps>

80105b03 <vector69>:
.globl vector69
vector69:
  pushl $0
80105b03:	6a 00                	push   $0x0
  pushl $69
80105b05:	6a 45                	push   $0x45
  jmp alltraps
80105b07:	e9 04 f9 ff ff       	jmp    80105410 <alltraps>

80105b0c <vector70>:
.globl vector70
vector70:
  pushl $0
80105b0c:	6a 00                	push   $0x0
  pushl $70
80105b0e:	6a 46                	push   $0x46
  jmp alltraps
80105b10:	e9 fb f8 ff ff       	jmp    80105410 <alltraps>

80105b15 <vector71>:
.globl vector71
vector71:
  pushl $0
80105b15:	6a 00                	push   $0x0
  pushl $71
80105b17:	6a 47                	push   $0x47
  jmp alltraps
80105b19:	e9 f2 f8 ff ff       	jmp    80105410 <alltraps>

80105b1e <vector72>:
.globl vector72
vector72:
  pushl $0
80105b1e:	6a 00                	push   $0x0
  pushl $72
80105b20:	6a 48                	push   $0x48
  jmp alltraps
80105b22:	e9 e9 f8 ff ff       	jmp    80105410 <alltraps>

80105b27 <vector73>:
.globl vector73
vector73:
  pushl $0
80105b27:	6a 00                	push   $0x0
  pushl $73
80105b29:	6a 49                	push   $0x49
  jmp alltraps
80105b2b:	e9 e0 f8 ff ff       	jmp    80105410 <alltraps>

80105b30 <vector74>:
.globl vector74
vector74:
  pushl $0
80105b30:	6a 00                	push   $0x0
  pushl $74
80105b32:	6a 4a                	push   $0x4a
  jmp alltraps
80105b34:	e9 d7 f8 ff ff       	jmp    80105410 <alltraps>

80105b39 <vector75>:
.globl vector75
vector75:
  pushl $0
80105b39:	6a 00                	push   $0x0
  pushl $75
80105b3b:	6a 4b                	push   $0x4b
  jmp alltraps
80105b3d:	e9 ce f8 ff ff       	jmp    80105410 <alltraps>

80105b42 <vector76>:
.globl vector76
vector76:
  pushl $0
80105b42:	6a 00                	push   $0x0
  pushl $76
80105b44:	6a 4c                	push   $0x4c
  jmp alltraps
80105b46:	e9 c5 f8 ff ff       	jmp    80105410 <alltraps>

80105b4b <vector77>:
.globl vector77
vector77:
  pushl $0
80105b4b:	6a 00                	push   $0x0
  pushl $77
80105b4d:	6a 4d                	push   $0x4d
  jmp alltraps
80105b4f:	e9 bc f8 ff ff       	jmp    80105410 <alltraps>

80105b54 <vector78>:
.globl vector78
vector78:
  pushl $0
80105b54:	6a 00                	push   $0x0
  pushl $78
80105b56:	6a 4e                	push   $0x4e
  jmp alltraps
80105b58:	e9 b3 f8 ff ff       	jmp    80105410 <alltraps>

80105b5d <vector79>:
.globl vector79
vector79:
  pushl $0
80105b5d:	6a 00                	push   $0x0
  pushl $79
80105b5f:	6a 4f                	push   $0x4f
  jmp alltraps
80105b61:	e9 aa f8 ff ff       	jmp    80105410 <alltraps>

80105b66 <vector80>:
.globl vector80
vector80:
  pushl $0
80105b66:	6a 00                	push   $0x0
  pushl $80
80105b68:	6a 50                	push   $0x50
  jmp alltraps
80105b6a:	e9 a1 f8 ff ff       	jmp    80105410 <alltraps>

80105b6f <vector81>:
.globl vector81
vector81:
  pushl $0
80105b6f:	6a 00                	push   $0x0
  pushl $81
80105b71:	6a 51                	push   $0x51
  jmp alltraps
80105b73:	e9 98 f8 ff ff       	jmp    80105410 <alltraps>

80105b78 <vector82>:
.globl vector82
vector82:
  pushl $0
80105b78:	6a 00                	push   $0x0
  pushl $82
80105b7a:	6a 52                	push   $0x52
  jmp alltraps
80105b7c:	e9 8f f8 ff ff       	jmp    80105410 <alltraps>

80105b81 <vector83>:
.globl vector83
vector83:
  pushl $0
80105b81:	6a 00                	push   $0x0
  pushl $83
80105b83:	6a 53                	push   $0x53
  jmp alltraps
80105b85:	e9 86 f8 ff ff       	jmp    80105410 <alltraps>

80105b8a <vector84>:
.globl vector84
vector84:
  pushl $0
80105b8a:	6a 00                	push   $0x0
  pushl $84
80105b8c:	6a 54                	push   $0x54
  jmp alltraps
80105b8e:	e9 7d f8 ff ff       	jmp    80105410 <alltraps>

80105b93 <vector85>:
.globl vector85
vector85:
  pushl $0
80105b93:	6a 00                	push   $0x0
  pushl $85
80105b95:	6a 55                	push   $0x55
  jmp alltraps
80105b97:	e9 74 f8 ff ff       	jmp    80105410 <alltraps>

80105b9c <vector86>:
.globl vector86
vector86:
  pushl $0
80105b9c:	6a 00                	push   $0x0
  pushl $86
80105b9e:	6a 56                	push   $0x56
  jmp alltraps
80105ba0:	e9 6b f8 ff ff       	jmp    80105410 <alltraps>

80105ba5 <vector87>:
.globl vector87
vector87:
  pushl $0
80105ba5:	6a 00                	push   $0x0
  pushl $87
80105ba7:	6a 57                	push   $0x57
  jmp alltraps
80105ba9:	e9 62 f8 ff ff       	jmp    80105410 <alltraps>

80105bae <vector88>:
.globl vector88
vector88:
  pushl $0
80105bae:	6a 00                	push   $0x0
  pushl $88
80105bb0:	6a 58                	push   $0x58
  jmp alltraps
80105bb2:	e9 59 f8 ff ff       	jmp    80105410 <alltraps>

80105bb7 <vector89>:
.globl vector89
vector89:
  pushl $0
80105bb7:	6a 00                	push   $0x0
  pushl $89
80105bb9:	6a 59                	push   $0x59
  jmp alltraps
80105bbb:	e9 50 f8 ff ff       	jmp    80105410 <alltraps>

80105bc0 <vector90>:
.globl vector90
vector90:
  pushl $0
80105bc0:	6a 00                	push   $0x0
  pushl $90
80105bc2:	6a 5a                	push   $0x5a
  jmp alltraps
80105bc4:	e9 47 f8 ff ff       	jmp    80105410 <alltraps>

80105bc9 <vector91>:
.globl vector91
vector91:
  pushl $0
80105bc9:	6a 00                	push   $0x0
  pushl $91
80105bcb:	6a 5b                	push   $0x5b
  jmp alltraps
80105bcd:	e9 3e f8 ff ff       	jmp    80105410 <alltraps>

80105bd2 <vector92>:
.globl vector92
vector92:
  pushl $0
80105bd2:	6a 00                	push   $0x0
  pushl $92
80105bd4:	6a 5c                	push   $0x5c
  jmp alltraps
80105bd6:	e9 35 f8 ff ff       	jmp    80105410 <alltraps>

80105bdb <vector93>:
.globl vector93
vector93:
  pushl $0
80105bdb:	6a 00                	push   $0x0
  pushl $93
80105bdd:	6a 5d                	push   $0x5d
  jmp alltraps
80105bdf:	e9 2c f8 ff ff       	jmp    80105410 <alltraps>

80105be4 <vector94>:
.globl vector94
vector94:
  pushl $0
80105be4:	6a 00                	push   $0x0
  pushl $94
80105be6:	6a 5e                	push   $0x5e
  jmp alltraps
80105be8:	e9 23 f8 ff ff       	jmp    80105410 <alltraps>

80105bed <vector95>:
.globl vector95
vector95:
  pushl $0
80105bed:	6a 00                	push   $0x0
  pushl $95
80105bef:	6a 5f                	push   $0x5f
  jmp alltraps
80105bf1:	e9 1a f8 ff ff       	jmp    80105410 <alltraps>

80105bf6 <vector96>:
.globl vector96
vector96:
  pushl $0
80105bf6:	6a 00                	push   $0x0
  pushl $96
80105bf8:	6a 60                	push   $0x60
  jmp alltraps
80105bfa:	e9 11 f8 ff ff       	jmp    80105410 <alltraps>

80105bff <vector97>:
.globl vector97
vector97:
  pushl $0
80105bff:	6a 00                	push   $0x0
  pushl $97
80105c01:	6a 61                	push   $0x61
  jmp alltraps
80105c03:	e9 08 f8 ff ff       	jmp    80105410 <alltraps>

80105c08 <vector98>:
.globl vector98
vector98:
  pushl $0
80105c08:	6a 00                	push   $0x0
  pushl $98
80105c0a:	6a 62                	push   $0x62
  jmp alltraps
80105c0c:	e9 ff f7 ff ff       	jmp    80105410 <alltraps>

80105c11 <vector99>:
.globl vector99
vector99:
  pushl $0
80105c11:	6a 00                	push   $0x0
  pushl $99
80105c13:	6a 63                	push   $0x63
  jmp alltraps
80105c15:	e9 f6 f7 ff ff       	jmp    80105410 <alltraps>

80105c1a <vector100>:
.globl vector100
vector100:
  pushl $0
80105c1a:	6a 00                	push   $0x0
  pushl $100
80105c1c:	6a 64                	push   $0x64
  jmp alltraps
80105c1e:	e9 ed f7 ff ff       	jmp    80105410 <alltraps>

80105c23 <vector101>:
.globl vector101
vector101:
  pushl $0
80105c23:	6a 00                	push   $0x0
  pushl $101
80105c25:	6a 65                	push   $0x65
  jmp alltraps
80105c27:	e9 e4 f7 ff ff       	jmp    80105410 <alltraps>

80105c2c <vector102>:
.globl vector102
vector102:
  pushl $0
80105c2c:	6a 00                	push   $0x0
  pushl $102
80105c2e:	6a 66                	push   $0x66
  jmp alltraps
80105c30:	e9 db f7 ff ff       	jmp    80105410 <alltraps>

80105c35 <vector103>:
.globl vector103
vector103:
  pushl $0
80105c35:	6a 00                	push   $0x0
  pushl $103
80105c37:	6a 67                	push   $0x67
  jmp alltraps
80105c39:	e9 d2 f7 ff ff       	jmp    80105410 <alltraps>

80105c3e <vector104>:
.globl vector104
vector104:
  pushl $0
80105c3e:	6a 00                	push   $0x0
  pushl $104
80105c40:	6a 68                	push   $0x68
  jmp alltraps
80105c42:	e9 c9 f7 ff ff       	jmp    80105410 <alltraps>

80105c47 <vector105>:
.globl vector105
vector105:
  pushl $0
80105c47:	6a 00                	push   $0x0
  pushl $105
80105c49:	6a 69                	push   $0x69
  jmp alltraps
80105c4b:	e9 c0 f7 ff ff       	jmp    80105410 <alltraps>

80105c50 <vector106>:
.globl vector106
vector106:
  pushl $0
80105c50:	6a 00                	push   $0x0
  pushl $106
80105c52:	6a 6a                	push   $0x6a
  jmp alltraps
80105c54:	e9 b7 f7 ff ff       	jmp    80105410 <alltraps>

80105c59 <vector107>:
.globl vector107
vector107:
  pushl $0
80105c59:	6a 00                	push   $0x0
  pushl $107
80105c5b:	6a 6b                	push   $0x6b
  jmp alltraps
80105c5d:	e9 ae f7 ff ff       	jmp    80105410 <alltraps>

80105c62 <vector108>:
.globl vector108
vector108:
  pushl $0
80105c62:	6a 00                	push   $0x0
  pushl $108
80105c64:	6a 6c                	push   $0x6c
  jmp alltraps
80105c66:	e9 a5 f7 ff ff       	jmp    80105410 <alltraps>

80105c6b <vector109>:
.globl vector109
vector109:
  pushl $0
80105c6b:	6a 00                	push   $0x0
  pushl $109
80105c6d:	6a 6d                	push   $0x6d
  jmp alltraps
80105c6f:	e9 9c f7 ff ff       	jmp    80105410 <alltraps>

80105c74 <vector110>:
.globl vector110
vector110:
  pushl $0
80105c74:	6a 00                	push   $0x0
  pushl $110
80105c76:	6a 6e                	push   $0x6e
  jmp alltraps
80105c78:	e9 93 f7 ff ff       	jmp    80105410 <alltraps>

80105c7d <vector111>:
.globl vector111
vector111:
  pushl $0
80105c7d:	6a 00                	push   $0x0
  pushl $111
80105c7f:	6a 6f                	push   $0x6f
  jmp alltraps
80105c81:	e9 8a f7 ff ff       	jmp    80105410 <alltraps>

80105c86 <vector112>:
.globl vector112
vector112:
  pushl $0
80105c86:	6a 00                	push   $0x0
  pushl $112
80105c88:	6a 70                	push   $0x70
  jmp alltraps
80105c8a:	e9 81 f7 ff ff       	jmp    80105410 <alltraps>

80105c8f <vector113>:
.globl vector113
vector113:
  pushl $0
80105c8f:	6a 00                	push   $0x0
  pushl $113
80105c91:	6a 71                	push   $0x71
  jmp alltraps
80105c93:	e9 78 f7 ff ff       	jmp    80105410 <alltraps>

80105c98 <vector114>:
.globl vector114
vector114:
  pushl $0
80105c98:	6a 00                	push   $0x0
  pushl $114
80105c9a:	6a 72                	push   $0x72
  jmp alltraps
80105c9c:	e9 6f f7 ff ff       	jmp    80105410 <alltraps>

80105ca1 <vector115>:
.globl vector115
vector115:
  pushl $0
80105ca1:	6a 00                	push   $0x0
  pushl $115
80105ca3:	6a 73                	push   $0x73
  jmp alltraps
80105ca5:	e9 66 f7 ff ff       	jmp    80105410 <alltraps>

80105caa <vector116>:
.globl vector116
vector116:
  pushl $0
80105caa:	6a 00                	push   $0x0
  pushl $116
80105cac:	6a 74                	push   $0x74
  jmp alltraps
80105cae:	e9 5d f7 ff ff       	jmp    80105410 <alltraps>

80105cb3 <vector117>:
.globl vector117
vector117:
  pushl $0
80105cb3:	6a 00                	push   $0x0
  pushl $117
80105cb5:	6a 75                	push   $0x75
  jmp alltraps
80105cb7:	e9 54 f7 ff ff       	jmp    80105410 <alltraps>

80105cbc <vector118>:
.globl vector118
vector118:
  pushl $0
80105cbc:	6a 00                	push   $0x0
  pushl $118
80105cbe:	6a 76                	push   $0x76
  jmp alltraps
80105cc0:	e9 4b f7 ff ff       	jmp    80105410 <alltraps>

80105cc5 <vector119>:
.globl vector119
vector119:
  pushl $0
80105cc5:	6a 00                	push   $0x0
  pushl $119
80105cc7:	6a 77                	push   $0x77
  jmp alltraps
80105cc9:	e9 42 f7 ff ff       	jmp    80105410 <alltraps>

80105cce <vector120>:
.globl vector120
vector120:
  pushl $0
80105cce:	6a 00                	push   $0x0
  pushl $120
80105cd0:	6a 78                	push   $0x78
  jmp alltraps
80105cd2:	e9 39 f7 ff ff       	jmp    80105410 <alltraps>

80105cd7 <vector121>:
.globl vector121
vector121:
  pushl $0
80105cd7:	6a 00                	push   $0x0
  pushl $121
80105cd9:	6a 79                	push   $0x79
  jmp alltraps
80105cdb:	e9 30 f7 ff ff       	jmp    80105410 <alltraps>

80105ce0 <vector122>:
.globl vector122
vector122:
  pushl $0
80105ce0:	6a 00                	push   $0x0
  pushl $122
80105ce2:	6a 7a                	push   $0x7a
  jmp alltraps
80105ce4:	e9 27 f7 ff ff       	jmp    80105410 <alltraps>

80105ce9 <vector123>:
.globl vector123
vector123:
  pushl $0
80105ce9:	6a 00                	push   $0x0
  pushl $123
80105ceb:	6a 7b                	push   $0x7b
  jmp alltraps
80105ced:	e9 1e f7 ff ff       	jmp    80105410 <alltraps>

80105cf2 <vector124>:
.globl vector124
vector124:
  pushl $0
80105cf2:	6a 00                	push   $0x0
  pushl $124
80105cf4:	6a 7c                	push   $0x7c
  jmp alltraps
80105cf6:	e9 15 f7 ff ff       	jmp    80105410 <alltraps>

80105cfb <vector125>:
.globl vector125
vector125:
  pushl $0
80105cfb:	6a 00                	push   $0x0
  pushl $125
80105cfd:	6a 7d                	push   $0x7d
  jmp alltraps
80105cff:	e9 0c f7 ff ff       	jmp    80105410 <alltraps>

80105d04 <vector126>:
.globl vector126
vector126:
  pushl $0
80105d04:	6a 00                	push   $0x0
  pushl $126
80105d06:	6a 7e                	push   $0x7e
  jmp alltraps
80105d08:	e9 03 f7 ff ff       	jmp    80105410 <alltraps>

80105d0d <vector127>:
.globl vector127
vector127:
  pushl $0
80105d0d:	6a 00                	push   $0x0
  pushl $127
80105d0f:	6a 7f                	push   $0x7f
  jmp alltraps
80105d11:	e9 fa f6 ff ff       	jmp    80105410 <alltraps>

80105d16 <vector128>:
.globl vector128
vector128:
  pushl $0
80105d16:	6a 00                	push   $0x0
  pushl $128
80105d18:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80105d1d:	e9 ee f6 ff ff       	jmp    80105410 <alltraps>

80105d22 <vector129>:
.globl vector129
vector129:
  pushl $0
80105d22:	6a 00                	push   $0x0
  pushl $129
80105d24:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80105d29:	e9 e2 f6 ff ff       	jmp    80105410 <alltraps>

80105d2e <vector130>:
.globl vector130
vector130:
  pushl $0
80105d2e:	6a 00                	push   $0x0
  pushl $130
80105d30:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80105d35:	e9 d6 f6 ff ff       	jmp    80105410 <alltraps>

80105d3a <vector131>:
.globl vector131
vector131:
  pushl $0
80105d3a:	6a 00                	push   $0x0
  pushl $131
80105d3c:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80105d41:	e9 ca f6 ff ff       	jmp    80105410 <alltraps>

80105d46 <vector132>:
.globl vector132
vector132:
  pushl $0
80105d46:	6a 00                	push   $0x0
  pushl $132
80105d48:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80105d4d:	e9 be f6 ff ff       	jmp    80105410 <alltraps>

80105d52 <vector133>:
.globl vector133
vector133:
  pushl $0
80105d52:	6a 00                	push   $0x0
  pushl $133
80105d54:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80105d59:	e9 b2 f6 ff ff       	jmp    80105410 <alltraps>

80105d5e <vector134>:
.globl vector134
vector134:
  pushl $0
80105d5e:	6a 00                	push   $0x0
  pushl $134
80105d60:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80105d65:	e9 a6 f6 ff ff       	jmp    80105410 <alltraps>

80105d6a <vector135>:
.globl vector135
vector135:
  pushl $0
80105d6a:	6a 00                	push   $0x0
  pushl $135
80105d6c:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80105d71:	e9 9a f6 ff ff       	jmp    80105410 <alltraps>

80105d76 <vector136>:
.globl vector136
vector136:
  pushl $0
80105d76:	6a 00                	push   $0x0
  pushl $136
80105d78:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80105d7d:	e9 8e f6 ff ff       	jmp    80105410 <alltraps>

80105d82 <vector137>:
.globl vector137
vector137:
  pushl $0
80105d82:	6a 00                	push   $0x0
  pushl $137
80105d84:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80105d89:	e9 82 f6 ff ff       	jmp    80105410 <alltraps>

80105d8e <vector138>:
.globl vector138
vector138:
  pushl $0
80105d8e:	6a 00                	push   $0x0
  pushl $138
80105d90:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80105d95:	e9 76 f6 ff ff       	jmp    80105410 <alltraps>

80105d9a <vector139>:
.globl vector139
vector139:
  pushl $0
80105d9a:	6a 00                	push   $0x0
  pushl $139
80105d9c:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80105da1:	e9 6a f6 ff ff       	jmp    80105410 <alltraps>

80105da6 <vector140>:
.globl vector140
vector140:
  pushl $0
80105da6:	6a 00                	push   $0x0
  pushl $140
80105da8:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80105dad:	e9 5e f6 ff ff       	jmp    80105410 <alltraps>

80105db2 <vector141>:
.globl vector141
vector141:
  pushl $0
80105db2:	6a 00                	push   $0x0
  pushl $141
80105db4:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80105db9:	e9 52 f6 ff ff       	jmp    80105410 <alltraps>

80105dbe <vector142>:
.globl vector142
vector142:
  pushl $0
80105dbe:	6a 00                	push   $0x0
  pushl $142
80105dc0:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80105dc5:	e9 46 f6 ff ff       	jmp    80105410 <alltraps>

80105dca <vector143>:
.globl vector143
vector143:
  pushl $0
80105dca:	6a 00                	push   $0x0
  pushl $143
80105dcc:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80105dd1:	e9 3a f6 ff ff       	jmp    80105410 <alltraps>

80105dd6 <vector144>:
.globl vector144
vector144:
  pushl $0
80105dd6:	6a 00                	push   $0x0
  pushl $144
80105dd8:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80105ddd:	e9 2e f6 ff ff       	jmp    80105410 <alltraps>

80105de2 <vector145>:
.globl vector145
vector145:
  pushl $0
80105de2:	6a 00                	push   $0x0
  pushl $145
80105de4:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80105de9:	e9 22 f6 ff ff       	jmp    80105410 <alltraps>

80105dee <vector146>:
.globl vector146
vector146:
  pushl $0
80105dee:	6a 00                	push   $0x0
  pushl $146
80105df0:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80105df5:	e9 16 f6 ff ff       	jmp    80105410 <alltraps>

80105dfa <vector147>:
.globl vector147
vector147:
  pushl $0
80105dfa:	6a 00                	push   $0x0
  pushl $147
80105dfc:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80105e01:	e9 0a f6 ff ff       	jmp    80105410 <alltraps>

80105e06 <vector148>:
.globl vector148
vector148:
  pushl $0
80105e06:	6a 00                	push   $0x0
  pushl $148
80105e08:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80105e0d:	e9 fe f5 ff ff       	jmp    80105410 <alltraps>

80105e12 <vector149>:
.globl vector149
vector149:
  pushl $0
80105e12:	6a 00                	push   $0x0
  pushl $149
80105e14:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80105e19:	e9 f2 f5 ff ff       	jmp    80105410 <alltraps>

80105e1e <vector150>:
.globl vector150
vector150:
  pushl $0
80105e1e:	6a 00                	push   $0x0
  pushl $150
80105e20:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80105e25:	e9 e6 f5 ff ff       	jmp    80105410 <alltraps>

80105e2a <vector151>:
.globl vector151
vector151:
  pushl $0
80105e2a:	6a 00                	push   $0x0
  pushl $151
80105e2c:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80105e31:	e9 da f5 ff ff       	jmp    80105410 <alltraps>

80105e36 <vector152>:
.globl vector152
vector152:
  pushl $0
80105e36:	6a 00                	push   $0x0
  pushl $152
80105e38:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80105e3d:	e9 ce f5 ff ff       	jmp    80105410 <alltraps>

80105e42 <vector153>:
.globl vector153
vector153:
  pushl $0
80105e42:	6a 00                	push   $0x0
  pushl $153
80105e44:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80105e49:	e9 c2 f5 ff ff       	jmp    80105410 <alltraps>

80105e4e <vector154>:
.globl vector154
vector154:
  pushl $0
80105e4e:	6a 00                	push   $0x0
  pushl $154
80105e50:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80105e55:	e9 b6 f5 ff ff       	jmp    80105410 <alltraps>

80105e5a <vector155>:
.globl vector155
vector155:
  pushl $0
80105e5a:	6a 00                	push   $0x0
  pushl $155
80105e5c:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80105e61:	e9 aa f5 ff ff       	jmp    80105410 <alltraps>

80105e66 <vector156>:
.globl vector156
vector156:
  pushl $0
80105e66:	6a 00                	push   $0x0
  pushl $156
80105e68:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80105e6d:	e9 9e f5 ff ff       	jmp    80105410 <alltraps>

80105e72 <vector157>:
.globl vector157
vector157:
  pushl $0
80105e72:	6a 00                	push   $0x0
  pushl $157
80105e74:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80105e79:	e9 92 f5 ff ff       	jmp    80105410 <alltraps>

80105e7e <vector158>:
.globl vector158
vector158:
  pushl $0
80105e7e:	6a 00                	push   $0x0
  pushl $158
80105e80:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80105e85:	e9 86 f5 ff ff       	jmp    80105410 <alltraps>

80105e8a <vector159>:
.globl vector159
vector159:
  pushl $0
80105e8a:	6a 00                	push   $0x0
  pushl $159
80105e8c:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80105e91:	e9 7a f5 ff ff       	jmp    80105410 <alltraps>

80105e96 <vector160>:
.globl vector160
vector160:
  pushl $0
80105e96:	6a 00                	push   $0x0
  pushl $160
80105e98:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80105e9d:	e9 6e f5 ff ff       	jmp    80105410 <alltraps>

80105ea2 <vector161>:
.globl vector161
vector161:
  pushl $0
80105ea2:	6a 00                	push   $0x0
  pushl $161
80105ea4:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80105ea9:	e9 62 f5 ff ff       	jmp    80105410 <alltraps>

80105eae <vector162>:
.globl vector162
vector162:
  pushl $0
80105eae:	6a 00                	push   $0x0
  pushl $162
80105eb0:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80105eb5:	e9 56 f5 ff ff       	jmp    80105410 <alltraps>

80105eba <vector163>:
.globl vector163
vector163:
  pushl $0
80105eba:	6a 00                	push   $0x0
  pushl $163
80105ebc:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80105ec1:	e9 4a f5 ff ff       	jmp    80105410 <alltraps>

80105ec6 <vector164>:
.globl vector164
vector164:
  pushl $0
80105ec6:	6a 00                	push   $0x0
  pushl $164
80105ec8:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80105ecd:	e9 3e f5 ff ff       	jmp    80105410 <alltraps>

80105ed2 <vector165>:
.globl vector165
vector165:
  pushl $0
80105ed2:	6a 00                	push   $0x0
  pushl $165
80105ed4:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80105ed9:	e9 32 f5 ff ff       	jmp    80105410 <alltraps>

80105ede <vector166>:
.globl vector166
vector166:
  pushl $0
80105ede:	6a 00                	push   $0x0
  pushl $166
80105ee0:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80105ee5:	e9 26 f5 ff ff       	jmp    80105410 <alltraps>

80105eea <vector167>:
.globl vector167
vector167:
  pushl $0
80105eea:	6a 00                	push   $0x0
  pushl $167
80105eec:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80105ef1:	e9 1a f5 ff ff       	jmp    80105410 <alltraps>

80105ef6 <vector168>:
.globl vector168
vector168:
  pushl $0
80105ef6:	6a 00                	push   $0x0
  pushl $168
80105ef8:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80105efd:	e9 0e f5 ff ff       	jmp    80105410 <alltraps>

80105f02 <vector169>:
.globl vector169
vector169:
  pushl $0
80105f02:	6a 00                	push   $0x0
  pushl $169
80105f04:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80105f09:	e9 02 f5 ff ff       	jmp    80105410 <alltraps>

80105f0e <vector170>:
.globl vector170
vector170:
  pushl $0
80105f0e:	6a 00                	push   $0x0
  pushl $170
80105f10:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80105f15:	e9 f6 f4 ff ff       	jmp    80105410 <alltraps>

80105f1a <vector171>:
.globl vector171
vector171:
  pushl $0
80105f1a:	6a 00                	push   $0x0
  pushl $171
80105f1c:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80105f21:	e9 ea f4 ff ff       	jmp    80105410 <alltraps>

80105f26 <vector172>:
.globl vector172
vector172:
  pushl $0
80105f26:	6a 00                	push   $0x0
  pushl $172
80105f28:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80105f2d:	e9 de f4 ff ff       	jmp    80105410 <alltraps>

80105f32 <vector173>:
.globl vector173
vector173:
  pushl $0
80105f32:	6a 00                	push   $0x0
  pushl $173
80105f34:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80105f39:	e9 d2 f4 ff ff       	jmp    80105410 <alltraps>

80105f3e <vector174>:
.globl vector174
vector174:
  pushl $0
80105f3e:	6a 00                	push   $0x0
  pushl $174
80105f40:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80105f45:	e9 c6 f4 ff ff       	jmp    80105410 <alltraps>

80105f4a <vector175>:
.globl vector175
vector175:
  pushl $0
80105f4a:	6a 00                	push   $0x0
  pushl $175
80105f4c:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80105f51:	e9 ba f4 ff ff       	jmp    80105410 <alltraps>

80105f56 <vector176>:
.globl vector176
vector176:
  pushl $0
80105f56:	6a 00                	push   $0x0
  pushl $176
80105f58:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80105f5d:	e9 ae f4 ff ff       	jmp    80105410 <alltraps>

80105f62 <vector177>:
.globl vector177
vector177:
  pushl $0
80105f62:	6a 00                	push   $0x0
  pushl $177
80105f64:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80105f69:	e9 a2 f4 ff ff       	jmp    80105410 <alltraps>

80105f6e <vector178>:
.globl vector178
vector178:
  pushl $0
80105f6e:	6a 00                	push   $0x0
  pushl $178
80105f70:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80105f75:	e9 96 f4 ff ff       	jmp    80105410 <alltraps>

80105f7a <vector179>:
.globl vector179
vector179:
  pushl $0
80105f7a:	6a 00                	push   $0x0
  pushl $179
80105f7c:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80105f81:	e9 8a f4 ff ff       	jmp    80105410 <alltraps>

80105f86 <vector180>:
.globl vector180
vector180:
  pushl $0
80105f86:	6a 00                	push   $0x0
  pushl $180
80105f88:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80105f8d:	e9 7e f4 ff ff       	jmp    80105410 <alltraps>

80105f92 <vector181>:
.globl vector181
vector181:
  pushl $0
80105f92:	6a 00                	push   $0x0
  pushl $181
80105f94:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80105f99:	e9 72 f4 ff ff       	jmp    80105410 <alltraps>

80105f9e <vector182>:
.globl vector182
vector182:
  pushl $0
80105f9e:	6a 00                	push   $0x0
  pushl $182
80105fa0:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80105fa5:	e9 66 f4 ff ff       	jmp    80105410 <alltraps>

80105faa <vector183>:
.globl vector183
vector183:
  pushl $0
80105faa:	6a 00                	push   $0x0
  pushl $183
80105fac:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80105fb1:	e9 5a f4 ff ff       	jmp    80105410 <alltraps>

80105fb6 <vector184>:
.globl vector184
vector184:
  pushl $0
80105fb6:	6a 00                	push   $0x0
  pushl $184
80105fb8:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80105fbd:	e9 4e f4 ff ff       	jmp    80105410 <alltraps>

80105fc2 <vector185>:
.globl vector185
vector185:
  pushl $0
80105fc2:	6a 00                	push   $0x0
  pushl $185
80105fc4:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80105fc9:	e9 42 f4 ff ff       	jmp    80105410 <alltraps>

80105fce <vector186>:
.globl vector186
vector186:
  pushl $0
80105fce:	6a 00                	push   $0x0
  pushl $186
80105fd0:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80105fd5:	e9 36 f4 ff ff       	jmp    80105410 <alltraps>

80105fda <vector187>:
.globl vector187
vector187:
  pushl $0
80105fda:	6a 00                	push   $0x0
  pushl $187
80105fdc:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80105fe1:	e9 2a f4 ff ff       	jmp    80105410 <alltraps>

80105fe6 <vector188>:
.globl vector188
vector188:
  pushl $0
80105fe6:	6a 00                	push   $0x0
  pushl $188
80105fe8:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80105fed:	e9 1e f4 ff ff       	jmp    80105410 <alltraps>

80105ff2 <vector189>:
.globl vector189
vector189:
  pushl $0
80105ff2:	6a 00                	push   $0x0
  pushl $189
80105ff4:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80105ff9:	e9 12 f4 ff ff       	jmp    80105410 <alltraps>

80105ffe <vector190>:
.globl vector190
vector190:
  pushl $0
80105ffe:	6a 00                	push   $0x0
  pushl $190
80106000:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106005:	e9 06 f4 ff ff       	jmp    80105410 <alltraps>

8010600a <vector191>:
.globl vector191
vector191:
  pushl $0
8010600a:	6a 00                	push   $0x0
  pushl $191
8010600c:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106011:	e9 fa f3 ff ff       	jmp    80105410 <alltraps>

80106016 <vector192>:
.globl vector192
vector192:
  pushl $0
80106016:	6a 00                	push   $0x0
  pushl $192
80106018:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010601d:	e9 ee f3 ff ff       	jmp    80105410 <alltraps>

80106022 <vector193>:
.globl vector193
vector193:
  pushl $0
80106022:	6a 00                	push   $0x0
  pushl $193
80106024:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106029:	e9 e2 f3 ff ff       	jmp    80105410 <alltraps>

8010602e <vector194>:
.globl vector194
vector194:
  pushl $0
8010602e:	6a 00                	push   $0x0
  pushl $194
80106030:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106035:	e9 d6 f3 ff ff       	jmp    80105410 <alltraps>

8010603a <vector195>:
.globl vector195
vector195:
  pushl $0
8010603a:	6a 00                	push   $0x0
  pushl $195
8010603c:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106041:	e9 ca f3 ff ff       	jmp    80105410 <alltraps>

80106046 <vector196>:
.globl vector196
vector196:
  pushl $0
80106046:	6a 00                	push   $0x0
  pushl $196
80106048:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010604d:	e9 be f3 ff ff       	jmp    80105410 <alltraps>

80106052 <vector197>:
.globl vector197
vector197:
  pushl $0
80106052:	6a 00                	push   $0x0
  pushl $197
80106054:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106059:	e9 b2 f3 ff ff       	jmp    80105410 <alltraps>

8010605e <vector198>:
.globl vector198
vector198:
  pushl $0
8010605e:	6a 00                	push   $0x0
  pushl $198
80106060:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106065:	e9 a6 f3 ff ff       	jmp    80105410 <alltraps>

8010606a <vector199>:
.globl vector199
vector199:
  pushl $0
8010606a:	6a 00                	push   $0x0
  pushl $199
8010606c:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106071:	e9 9a f3 ff ff       	jmp    80105410 <alltraps>

80106076 <vector200>:
.globl vector200
vector200:
  pushl $0
80106076:	6a 00                	push   $0x0
  pushl $200
80106078:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010607d:	e9 8e f3 ff ff       	jmp    80105410 <alltraps>

80106082 <vector201>:
.globl vector201
vector201:
  pushl $0
80106082:	6a 00                	push   $0x0
  pushl $201
80106084:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106089:	e9 82 f3 ff ff       	jmp    80105410 <alltraps>

8010608e <vector202>:
.globl vector202
vector202:
  pushl $0
8010608e:	6a 00                	push   $0x0
  pushl $202
80106090:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106095:	e9 76 f3 ff ff       	jmp    80105410 <alltraps>

8010609a <vector203>:
.globl vector203
vector203:
  pushl $0
8010609a:	6a 00                	push   $0x0
  pushl $203
8010609c:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801060a1:	e9 6a f3 ff ff       	jmp    80105410 <alltraps>

801060a6 <vector204>:
.globl vector204
vector204:
  pushl $0
801060a6:	6a 00                	push   $0x0
  pushl $204
801060a8:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801060ad:	e9 5e f3 ff ff       	jmp    80105410 <alltraps>

801060b2 <vector205>:
.globl vector205
vector205:
  pushl $0
801060b2:	6a 00                	push   $0x0
  pushl $205
801060b4:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801060b9:	e9 52 f3 ff ff       	jmp    80105410 <alltraps>

801060be <vector206>:
.globl vector206
vector206:
  pushl $0
801060be:	6a 00                	push   $0x0
  pushl $206
801060c0:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801060c5:	e9 46 f3 ff ff       	jmp    80105410 <alltraps>

801060ca <vector207>:
.globl vector207
vector207:
  pushl $0
801060ca:	6a 00                	push   $0x0
  pushl $207
801060cc:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801060d1:	e9 3a f3 ff ff       	jmp    80105410 <alltraps>

801060d6 <vector208>:
.globl vector208
vector208:
  pushl $0
801060d6:	6a 00                	push   $0x0
  pushl $208
801060d8:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801060dd:	e9 2e f3 ff ff       	jmp    80105410 <alltraps>

801060e2 <vector209>:
.globl vector209
vector209:
  pushl $0
801060e2:	6a 00                	push   $0x0
  pushl $209
801060e4:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801060e9:	e9 22 f3 ff ff       	jmp    80105410 <alltraps>

801060ee <vector210>:
.globl vector210
vector210:
  pushl $0
801060ee:	6a 00                	push   $0x0
  pushl $210
801060f0:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801060f5:	e9 16 f3 ff ff       	jmp    80105410 <alltraps>

801060fa <vector211>:
.globl vector211
vector211:
  pushl $0
801060fa:	6a 00                	push   $0x0
  pushl $211
801060fc:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106101:	e9 0a f3 ff ff       	jmp    80105410 <alltraps>

80106106 <vector212>:
.globl vector212
vector212:
  pushl $0
80106106:	6a 00                	push   $0x0
  pushl $212
80106108:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010610d:	e9 fe f2 ff ff       	jmp    80105410 <alltraps>

80106112 <vector213>:
.globl vector213
vector213:
  pushl $0
80106112:	6a 00                	push   $0x0
  pushl $213
80106114:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106119:	e9 f2 f2 ff ff       	jmp    80105410 <alltraps>

8010611e <vector214>:
.globl vector214
vector214:
  pushl $0
8010611e:	6a 00                	push   $0x0
  pushl $214
80106120:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106125:	e9 e6 f2 ff ff       	jmp    80105410 <alltraps>

8010612a <vector215>:
.globl vector215
vector215:
  pushl $0
8010612a:	6a 00                	push   $0x0
  pushl $215
8010612c:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106131:	e9 da f2 ff ff       	jmp    80105410 <alltraps>

80106136 <vector216>:
.globl vector216
vector216:
  pushl $0
80106136:	6a 00                	push   $0x0
  pushl $216
80106138:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010613d:	e9 ce f2 ff ff       	jmp    80105410 <alltraps>

80106142 <vector217>:
.globl vector217
vector217:
  pushl $0
80106142:	6a 00                	push   $0x0
  pushl $217
80106144:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106149:	e9 c2 f2 ff ff       	jmp    80105410 <alltraps>

8010614e <vector218>:
.globl vector218
vector218:
  pushl $0
8010614e:	6a 00                	push   $0x0
  pushl $218
80106150:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106155:	e9 b6 f2 ff ff       	jmp    80105410 <alltraps>

8010615a <vector219>:
.globl vector219
vector219:
  pushl $0
8010615a:	6a 00                	push   $0x0
  pushl $219
8010615c:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106161:	e9 aa f2 ff ff       	jmp    80105410 <alltraps>

80106166 <vector220>:
.globl vector220
vector220:
  pushl $0
80106166:	6a 00                	push   $0x0
  pushl $220
80106168:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010616d:	e9 9e f2 ff ff       	jmp    80105410 <alltraps>

80106172 <vector221>:
.globl vector221
vector221:
  pushl $0
80106172:	6a 00                	push   $0x0
  pushl $221
80106174:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106179:	e9 92 f2 ff ff       	jmp    80105410 <alltraps>

8010617e <vector222>:
.globl vector222
vector222:
  pushl $0
8010617e:	6a 00                	push   $0x0
  pushl $222
80106180:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106185:	e9 86 f2 ff ff       	jmp    80105410 <alltraps>

8010618a <vector223>:
.globl vector223
vector223:
  pushl $0
8010618a:	6a 00                	push   $0x0
  pushl $223
8010618c:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106191:	e9 7a f2 ff ff       	jmp    80105410 <alltraps>

80106196 <vector224>:
.globl vector224
vector224:
  pushl $0
80106196:	6a 00                	push   $0x0
  pushl $224
80106198:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010619d:	e9 6e f2 ff ff       	jmp    80105410 <alltraps>

801061a2 <vector225>:
.globl vector225
vector225:
  pushl $0
801061a2:	6a 00                	push   $0x0
  pushl $225
801061a4:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801061a9:	e9 62 f2 ff ff       	jmp    80105410 <alltraps>

801061ae <vector226>:
.globl vector226
vector226:
  pushl $0
801061ae:	6a 00                	push   $0x0
  pushl $226
801061b0:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801061b5:	e9 56 f2 ff ff       	jmp    80105410 <alltraps>

801061ba <vector227>:
.globl vector227
vector227:
  pushl $0
801061ba:	6a 00                	push   $0x0
  pushl $227
801061bc:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801061c1:	e9 4a f2 ff ff       	jmp    80105410 <alltraps>

801061c6 <vector228>:
.globl vector228
vector228:
  pushl $0
801061c6:	6a 00                	push   $0x0
  pushl $228
801061c8:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801061cd:	e9 3e f2 ff ff       	jmp    80105410 <alltraps>

801061d2 <vector229>:
.globl vector229
vector229:
  pushl $0
801061d2:	6a 00                	push   $0x0
  pushl $229
801061d4:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801061d9:	e9 32 f2 ff ff       	jmp    80105410 <alltraps>

801061de <vector230>:
.globl vector230
vector230:
  pushl $0
801061de:	6a 00                	push   $0x0
  pushl $230
801061e0:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801061e5:	e9 26 f2 ff ff       	jmp    80105410 <alltraps>

801061ea <vector231>:
.globl vector231
vector231:
  pushl $0
801061ea:	6a 00                	push   $0x0
  pushl $231
801061ec:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801061f1:	e9 1a f2 ff ff       	jmp    80105410 <alltraps>

801061f6 <vector232>:
.globl vector232
vector232:
  pushl $0
801061f6:	6a 00                	push   $0x0
  pushl $232
801061f8:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801061fd:	e9 0e f2 ff ff       	jmp    80105410 <alltraps>

80106202 <vector233>:
.globl vector233
vector233:
  pushl $0
80106202:	6a 00                	push   $0x0
  pushl $233
80106204:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106209:	e9 02 f2 ff ff       	jmp    80105410 <alltraps>

8010620e <vector234>:
.globl vector234
vector234:
  pushl $0
8010620e:	6a 00                	push   $0x0
  pushl $234
80106210:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106215:	e9 f6 f1 ff ff       	jmp    80105410 <alltraps>

8010621a <vector235>:
.globl vector235
vector235:
  pushl $0
8010621a:	6a 00                	push   $0x0
  pushl $235
8010621c:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106221:	e9 ea f1 ff ff       	jmp    80105410 <alltraps>

80106226 <vector236>:
.globl vector236
vector236:
  pushl $0
80106226:	6a 00                	push   $0x0
  pushl $236
80106228:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010622d:	e9 de f1 ff ff       	jmp    80105410 <alltraps>

80106232 <vector237>:
.globl vector237
vector237:
  pushl $0
80106232:	6a 00                	push   $0x0
  pushl $237
80106234:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106239:	e9 d2 f1 ff ff       	jmp    80105410 <alltraps>

8010623e <vector238>:
.globl vector238
vector238:
  pushl $0
8010623e:	6a 00                	push   $0x0
  pushl $238
80106240:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106245:	e9 c6 f1 ff ff       	jmp    80105410 <alltraps>

8010624a <vector239>:
.globl vector239
vector239:
  pushl $0
8010624a:	6a 00                	push   $0x0
  pushl $239
8010624c:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106251:	e9 ba f1 ff ff       	jmp    80105410 <alltraps>

80106256 <vector240>:
.globl vector240
vector240:
  pushl $0
80106256:	6a 00                	push   $0x0
  pushl $240
80106258:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010625d:	e9 ae f1 ff ff       	jmp    80105410 <alltraps>

80106262 <vector241>:
.globl vector241
vector241:
  pushl $0
80106262:	6a 00                	push   $0x0
  pushl $241
80106264:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106269:	e9 a2 f1 ff ff       	jmp    80105410 <alltraps>

8010626e <vector242>:
.globl vector242
vector242:
  pushl $0
8010626e:	6a 00                	push   $0x0
  pushl $242
80106270:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106275:	e9 96 f1 ff ff       	jmp    80105410 <alltraps>

8010627a <vector243>:
.globl vector243
vector243:
  pushl $0
8010627a:	6a 00                	push   $0x0
  pushl $243
8010627c:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106281:	e9 8a f1 ff ff       	jmp    80105410 <alltraps>

80106286 <vector244>:
.globl vector244
vector244:
  pushl $0
80106286:	6a 00                	push   $0x0
  pushl $244
80106288:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010628d:	e9 7e f1 ff ff       	jmp    80105410 <alltraps>

80106292 <vector245>:
.globl vector245
vector245:
  pushl $0
80106292:	6a 00                	push   $0x0
  pushl $245
80106294:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106299:	e9 72 f1 ff ff       	jmp    80105410 <alltraps>

8010629e <vector246>:
.globl vector246
vector246:
  pushl $0
8010629e:	6a 00                	push   $0x0
  pushl $246
801062a0:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801062a5:	e9 66 f1 ff ff       	jmp    80105410 <alltraps>

801062aa <vector247>:
.globl vector247
vector247:
  pushl $0
801062aa:	6a 00                	push   $0x0
  pushl $247
801062ac:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801062b1:	e9 5a f1 ff ff       	jmp    80105410 <alltraps>

801062b6 <vector248>:
.globl vector248
vector248:
  pushl $0
801062b6:	6a 00                	push   $0x0
  pushl $248
801062b8:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801062bd:	e9 4e f1 ff ff       	jmp    80105410 <alltraps>

801062c2 <vector249>:
.globl vector249
vector249:
  pushl $0
801062c2:	6a 00                	push   $0x0
  pushl $249
801062c4:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801062c9:	e9 42 f1 ff ff       	jmp    80105410 <alltraps>

801062ce <vector250>:
.globl vector250
vector250:
  pushl $0
801062ce:	6a 00                	push   $0x0
  pushl $250
801062d0:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801062d5:	e9 36 f1 ff ff       	jmp    80105410 <alltraps>

801062da <vector251>:
.globl vector251
vector251:
  pushl $0
801062da:	6a 00                	push   $0x0
  pushl $251
801062dc:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801062e1:	e9 2a f1 ff ff       	jmp    80105410 <alltraps>

801062e6 <vector252>:
.globl vector252
vector252:
  pushl $0
801062e6:	6a 00                	push   $0x0
  pushl $252
801062e8:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801062ed:	e9 1e f1 ff ff       	jmp    80105410 <alltraps>

801062f2 <vector253>:
.globl vector253
vector253:
  pushl $0
801062f2:	6a 00                	push   $0x0
  pushl $253
801062f4:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801062f9:	e9 12 f1 ff ff       	jmp    80105410 <alltraps>

801062fe <vector254>:
.globl vector254
vector254:
  pushl $0
801062fe:	6a 00                	push   $0x0
  pushl $254
80106300:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106305:	e9 06 f1 ff ff       	jmp    80105410 <alltraps>

8010630a <vector255>:
.globl vector255
vector255:
  pushl $0
8010630a:	6a 00                	push   $0x0
  pushl $255
8010630c:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106311:	e9 fa f0 ff ff       	jmp    80105410 <alltraps>
	...

80106320 <walkpgdir>:
80106320:	55                   	push   %ebp
80106321:	89 e5                	mov    %esp,%ebp
80106323:	57                   	push   %edi
80106324:	56                   	push   %esi
80106325:	89 d6                	mov    %edx,%esi
80106327:	c1 ea 16             	shr    $0x16,%edx
8010632a:	53                   	push   %ebx
8010632b:	8d 3c 90             	lea    (%eax,%edx,4),%edi
8010632e:	83 ec 1c             	sub    $0x1c,%esp
80106331:	8b 1f                	mov    (%edi),%ebx
80106333:	f6 c3 01             	test   $0x1,%bl
80106336:	74 28                	je     80106360 <walkpgdir+0x40>
80106338:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
8010633e:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
80106344:	c1 ee 0a             	shr    $0xa,%esi
80106347:	83 c4 1c             	add    $0x1c,%esp
8010634a:	89 f2                	mov    %esi,%edx
8010634c:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106352:	8d 04 13             	lea    (%ebx,%edx,1),%eax
80106355:	5b                   	pop    %ebx
80106356:	5e                   	pop    %esi
80106357:	5f                   	pop    %edi
80106358:	5d                   	pop    %ebp
80106359:	c3                   	ret    
8010635a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106360:	85 c9                	test   %ecx,%ecx
80106362:	74 34                	je     80106398 <walkpgdir+0x78>
80106364:	e8 47 c1 ff ff       	call   801024b0 <kalloc>
80106369:	85 c0                	test   %eax,%eax
8010636b:	89 c3                	mov    %eax,%ebx
8010636d:	74 29                	je     80106398 <walkpgdir+0x78>
8010636f:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106376:	00 
80106377:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010637e:	00 
8010637f:	89 04 24             	mov    %eax,(%esp)
80106382:	e8 f9 de ff ff       	call   80104280 <memset>
80106387:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010638d:	83 c8 07             	or     $0x7,%eax
80106390:	89 07                	mov    %eax,(%edi)
80106392:	eb b0                	jmp    80106344 <walkpgdir+0x24>
80106394:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106398:	83 c4 1c             	add    $0x1c,%esp
8010639b:	31 c0                	xor    %eax,%eax
8010639d:	5b                   	pop    %ebx
8010639e:	5e                   	pop    %esi
8010639f:	5f                   	pop    %edi
801063a0:	5d                   	pop    %ebp
801063a1:	c3                   	ret    
801063a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801063a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801063b0 <mappages>:
801063b0:	55                   	push   %ebp
801063b1:	89 e5                	mov    %esp,%ebp
801063b3:	57                   	push   %edi
801063b4:	56                   	push   %esi
801063b5:	53                   	push   %ebx
801063b6:	89 d3                	mov    %edx,%ebx
801063b8:	83 ec 1c             	sub    $0x1c,%esp
801063bb:	8b 7d 08             	mov    0x8(%ebp),%edi
801063be:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
801063c4:	89 45 e0             	mov    %eax,-0x20(%ebp)
801063c7:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
801063cb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801063ce:	83 4d 0c 01          	orl    $0x1,0xc(%ebp)
801063d2:	81 65 e4 00 f0 ff ff 	andl   $0xfffff000,-0x1c(%ebp)
801063d9:	29 df                	sub    %ebx,%edi
801063db:	eb 18                	jmp    801063f5 <mappages+0x45>
801063dd:	8d 76 00             	lea    0x0(%esi),%esi
801063e0:	f6 00 01             	testb  $0x1,(%eax)
801063e3:	75 3d                	jne    80106422 <mappages+0x72>
801063e5:	0b 75 0c             	or     0xc(%ebp),%esi
801063e8:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
801063eb:	89 30                	mov    %esi,(%eax)
801063ed:	74 29                	je     80106418 <mappages+0x68>
801063ef:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801063f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
801063f8:	b9 01 00 00 00       	mov    $0x1,%ecx
801063fd:	89 da                	mov    %ebx,%edx
801063ff:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106402:	e8 19 ff ff ff       	call   80106320 <walkpgdir>
80106407:	85 c0                	test   %eax,%eax
80106409:	75 d5                	jne    801063e0 <mappages+0x30>
8010640b:	83 c4 1c             	add    $0x1c,%esp
8010640e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106413:	5b                   	pop    %ebx
80106414:	5e                   	pop    %esi
80106415:	5f                   	pop    %edi
80106416:	5d                   	pop    %ebp
80106417:	c3                   	ret    
80106418:	83 c4 1c             	add    $0x1c,%esp
8010641b:	31 c0                	xor    %eax,%eax
8010641d:	5b                   	pop    %ebx
8010641e:	5e                   	pop    %esi
8010641f:	5f                   	pop    %edi
80106420:	5d                   	pop    %ebp
80106421:	c3                   	ret    
80106422:	c7 04 24 c8 75 10 80 	movl   $0x801075c8,(%esp)
80106429:	e8 32 9f ff ff       	call   80100360 <panic>
8010642e:	66 90                	xchg   %ax,%ax

80106430 <deallocuvm.part.0>:
80106430:	55                   	push   %ebp
80106431:	89 e5                	mov    %esp,%ebp
80106433:	57                   	push   %edi
80106434:	89 c7                	mov    %eax,%edi
80106436:	56                   	push   %esi
80106437:	89 d6                	mov    %edx,%esi
80106439:	53                   	push   %ebx
8010643a:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
80106440:	83 ec 1c             	sub    $0x1c,%esp
80106443:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80106449:	39 d3                	cmp    %edx,%ebx
8010644b:	89 4d e0             	mov    %ecx,-0x20(%ebp)
8010644e:	72 3b                	jb     8010648b <deallocuvm.part.0+0x5b>
80106450:	eb 5e                	jmp    801064b0 <deallocuvm.part.0+0x80>
80106452:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106458:	8b 10                	mov    (%eax),%edx
8010645a:	f6 c2 01             	test   $0x1,%dl
8010645d:	74 22                	je     80106481 <deallocuvm.part.0+0x51>
8010645f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106465:	74 54                	je     801064bb <deallocuvm.part.0+0x8b>
80106467:	81 c2 00 00 00 80    	add    $0x80000000,%edx
8010646d:	89 14 24             	mov    %edx,(%esp)
80106470:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106473:	e8 88 be ff ff       	call   80102300 <kfree>
80106478:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010647b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80106481:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106487:	39 f3                	cmp    %esi,%ebx
80106489:	73 25                	jae    801064b0 <deallocuvm.part.0+0x80>
8010648b:	31 c9                	xor    %ecx,%ecx
8010648d:	89 da                	mov    %ebx,%edx
8010648f:	89 f8                	mov    %edi,%eax
80106491:	e8 8a fe ff ff       	call   80106320 <walkpgdir>
80106496:	85 c0                	test   %eax,%eax
80106498:	75 be                	jne    80106458 <deallocuvm.part.0+0x28>
8010649a:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
801064a0:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
801064a6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801064ac:	39 f3                	cmp    %esi,%ebx
801064ae:	72 db                	jb     8010648b <deallocuvm.part.0+0x5b>
801064b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
801064b3:	83 c4 1c             	add    $0x1c,%esp
801064b6:	5b                   	pop    %ebx
801064b7:	5e                   	pop    %esi
801064b8:	5f                   	pop    %edi
801064b9:	5d                   	pop    %ebp
801064ba:	c3                   	ret    
801064bb:	c7 04 24 a6 6e 10 80 	movl   $0x80106ea6,(%esp)
801064c2:	e8 99 9e ff ff       	call   80100360 <panic>
801064c7:	89 f6                	mov    %esi,%esi
801064c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801064d0 <seginit>:
801064d0:	55                   	push   %ebp
801064d1:	89 e5                	mov    %esp,%ebp
801064d3:	83 ec 18             	sub    $0x18,%esp
801064d6:	e8 a5 d1 ff ff       	call   80103680 <cpuid>
801064db:	31 c9                	xor    %ecx,%ecx
801064dd:	ba ff ff ff ff       	mov    $0xffffffff,%edx
801064e2:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
801064e8:	05 80 27 11 80       	add    $0x80112780,%eax
801064ed:	66 89 50 78          	mov    %dx,0x78(%eax)
801064f1:	ba ff ff ff ff       	mov    $0xffffffff,%edx
801064f6:	83 c0 70             	add    $0x70,%eax
801064f9:	66 89 48 0a          	mov    %cx,0xa(%eax)
801064fd:	31 c9                	xor    %ecx,%ecx
801064ff:	66 89 50 10          	mov    %dx,0x10(%eax)
80106503:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80106508:	66 89 48 12          	mov    %cx,0x12(%eax)
8010650c:	31 c9                	xor    %ecx,%ecx
8010650e:	66 89 50 18          	mov    %dx,0x18(%eax)
80106512:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80106517:	66 89 48 1a          	mov    %cx,0x1a(%eax)
8010651b:	31 c9                	xor    %ecx,%ecx
8010651d:	c6 40 0d 9a          	movb   $0x9a,0xd(%eax)
80106521:	c6 40 0e cf          	movb   $0xcf,0xe(%eax)
80106525:	c6 40 15 92          	movb   $0x92,0x15(%eax)
80106529:	c6 40 16 cf          	movb   $0xcf,0x16(%eax)
8010652d:	c6 40 1d fa          	movb   $0xfa,0x1d(%eax)
80106531:	c6 40 1e cf          	movb   $0xcf,0x1e(%eax)
80106535:	c6 40 25 f2          	movb   $0xf2,0x25(%eax)
80106539:	c6 40 26 cf          	movb   $0xcf,0x26(%eax)
8010653d:	66 89 50 20          	mov    %dx,0x20(%eax)
80106541:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106546:	c6 40 0c 00          	movb   $0x0,0xc(%eax)
8010654a:	c6 40 0f 00          	movb   $0x0,0xf(%eax)
8010654e:	c6 40 14 00          	movb   $0x0,0x14(%eax)
80106552:	c6 40 17 00          	movb   $0x0,0x17(%eax)
80106556:	c6 40 1c 00          	movb   $0x0,0x1c(%eax)
8010655a:	c6 40 1f 00          	movb   $0x0,0x1f(%eax)
8010655e:	66 89 48 22          	mov    %cx,0x22(%eax)
80106562:	c6 40 24 00          	movb   $0x0,0x24(%eax)
80106566:	c6 40 27 00          	movb   $0x0,0x27(%eax)
8010656a:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
8010656e:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
80106572:	c1 e8 10             	shr    $0x10,%eax
80106575:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
80106579:	8d 45 f2             	lea    -0xe(%ebp),%eax
8010657c:	0f 01 10             	lgdtl  (%eax)
8010657f:	c9                   	leave  
80106580:	c3                   	ret    
80106581:	eb 0d                	jmp    80106590 <switchkvm>
80106583:	90                   	nop
80106584:	90                   	nop
80106585:	90                   	nop
80106586:	90                   	nop
80106587:	90                   	nop
80106588:	90                   	nop
80106589:	90                   	nop
8010658a:	90                   	nop
8010658b:	90                   	nop
8010658c:	90                   	nop
8010658d:	90                   	nop
8010658e:	90                   	nop
8010658f:	90                   	nop

80106590 <switchkvm>:
80106590:	a1 a4 54 11 80       	mov    0x801154a4,%eax
80106595:	55                   	push   %ebp
80106596:	89 e5                	mov    %esp,%ebp
80106598:	05 00 00 00 80       	add    $0x80000000,%eax
8010659d:	0f 22 d8             	mov    %eax,%cr3
801065a0:	5d                   	pop    %ebp
801065a1:	c3                   	ret    
801065a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801065a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801065b0 <switchuvm>:
801065b0:	55                   	push   %ebp
801065b1:	89 e5                	mov    %esp,%ebp
801065b3:	57                   	push   %edi
801065b4:	56                   	push   %esi
801065b5:	53                   	push   %ebx
801065b6:	83 ec 1c             	sub    $0x1c,%esp
801065b9:	8b 75 08             	mov    0x8(%ebp),%esi
801065bc:	85 f6                	test   %esi,%esi
801065be:	0f 84 cd 00 00 00    	je     80106691 <switchuvm+0xe1>
801065c4:	8b 46 08             	mov    0x8(%esi),%eax
801065c7:	85 c0                	test   %eax,%eax
801065c9:	0f 84 da 00 00 00    	je     801066a9 <switchuvm+0xf9>
801065cf:	8b 46 04             	mov    0x4(%esi),%eax
801065d2:	85 c0                	test   %eax,%eax
801065d4:	0f 84 c3 00 00 00    	je     8010669d <switchuvm+0xed>
801065da:	e8 21 db ff ff       	call   80104100 <pushcli>
801065df:	e8 1c d0 ff ff       	call   80103600 <mycpu>
801065e4:	89 c3                	mov    %eax,%ebx
801065e6:	e8 15 d0 ff ff       	call   80103600 <mycpu>
801065eb:	89 c7                	mov    %eax,%edi
801065ed:	e8 0e d0 ff ff       	call   80103600 <mycpu>
801065f2:	83 c7 08             	add    $0x8,%edi
801065f5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801065f8:	e8 03 d0 ff ff       	call   80103600 <mycpu>
801065fd:	b9 67 00 00 00       	mov    $0x67,%ecx
80106602:	66 89 8b 98 00 00 00 	mov    %cx,0x98(%ebx)
80106609:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010660c:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106613:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80106618:	c6 83 9d 00 00 00 99 	movb   $0x99,0x9d(%ebx)
8010661f:	c6 83 9e 00 00 00 40 	movb   $0x40,0x9e(%ebx)
80106626:	83 c1 08             	add    $0x8,%ecx
80106629:	83 c0 08             	add    $0x8,%eax
8010662c:	c1 e9 10             	shr    $0x10,%ecx
8010662f:	c1 e8 18             	shr    $0x18,%eax
80106632:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106638:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
8010663e:	bb 10 00 00 00       	mov    $0x10,%ebx
80106643:	e8 b8 cf ff ff       	call   80103600 <mycpu>
80106648:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
8010664f:	e8 ac cf ff ff       	call   80103600 <mycpu>
80106654:	66 89 58 10          	mov    %bx,0x10(%eax)
80106658:	e8 a3 cf ff ff       	call   80103600 <mycpu>
8010665d:	8b 56 08             	mov    0x8(%esi),%edx
80106660:	8d 8a 00 10 00 00    	lea    0x1000(%edx),%ecx
80106666:	89 48 0c             	mov    %ecx,0xc(%eax)
80106669:	e8 92 cf ff ff       	call   80103600 <mycpu>
8010666e:	66 89 78 6e          	mov    %di,0x6e(%eax)
80106672:	b8 28 00 00 00       	mov    $0x28,%eax
80106677:	0f 00 d8             	ltr    %ax
8010667a:	8b 46 04             	mov    0x4(%esi),%eax
8010667d:	05 00 00 00 80       	add    $0x80000000,%eax
80106682:	0f 22 d8             	mov    %eax,%cr3
80106685:	83 c4 1c             	add    $0x1c,%esp
80106688:	5b                   	pop    %ebx
80106689:	5e                   	pop    %esi
8010668a:	5f                   	pop    %edi
8010668b:	5d                   	pop    %ebp
8010668c:	e9 2f db ff ff       	jmp    801041c0 <popcli>
80106691:	c7 04 24 ce 75 10 80 	movl   $0x801075ce,(%esp)
80106698:	e8 c3 9c ff ff       	call   80100360 <panic>
8010669d:	c7 04 24 f9 75 10 80 	movl   $0x801075f9,(%esp)
801066a4:	e8 b7 9c ff ff       	call   80100360 <panic>
801066a9:	c7 04 24 e4 75 10 80 	movl   $0x801075e4,(%esp)
801066b0:	e8 ab 9c ff ff       	call   80100360 <panic>
801066b5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801066b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801066c0 <inituvm>:
801066c0:	55                   	push   %ebp
801066c1:	89 e5                	mov    %esp,%ebp
801066c3:	57                   	push   %edi
801066c4:	56                   	push   %esi
801066c5:	53                   	push   %ebx
801066c6:	83 ec 1c             	sub    $0x1c,%esp
801066c9:	8b 75 10             	mov    0x10(%ebp),%esi
801066cc:	8b 45 08             	mov    0x8(%ebp),%eax
801066cf:	8b 7d 0c             	mov    0xc(%ebp),%edi
801066d2:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
801066d8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801066db:	77 54                	ja     80106731 <inituvm+0x71>
801066dd:	e8 ce bd ff ff       	call   801024b0 <kalloc>
801066e2:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801066e9:	00 
801066ea:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801066f1:	00 
801066f2:	89 c3                	mov    %eax,%ebx
801066f4:	89 04 24             	mov    %eax,(%esp)
801066f7:	e8 84 db ff ff       	call   80104280 <memset>
801066fc:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106702:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106707:	89 04 24             	mov    %eax,(%esp)
8010670a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010670d:	31 d2                	xor    %edx,%edx
8010670f:	c7 44 24 04 06 00 00 	movl   $0x6,0x4(%esp)
80106716:	00 
80106717:	e8 94 fc ff ff       	call   801063b0 <mappages>
8010671c:	89 75 10             	mov    %esi,0x10(%ebp)
8010671f:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106722:	89 5d 08             	mov    %ebx,0x8(%ebp)
80106725:	83 c4 1c             	add    $0x1c,%esp
80106728:	5b                   	pop    %ebx
80106729:	5e                   	pop    %esi
8010672a:	5f                   	pop    %edi
8010672b:	5d                   	pop    %ebp
8010672c:	e9 ef db ff ff       	jmp    80104320 <memmove>
80106731:	c7 04 24 0d 76 10 80 	movl   $0x8010760d,(%esp)
80106738:	e8 23 9c ff ff       	call   80100360 <panic>
8010673d:	8d 76 00             	lea    0x0(%esi),%esi

80106740 <loaduvm>:
80106740:	55                   	push   %ebp
80106741:	89 e5                	mov    %esp,%ebp
80106743:	57                   	push   %edi
80106744:	56                   	push   %esi
80106745:	53                   	push   %ebx
80106746:	83 ec 1c             	sub    $0x1c,%esp
80106749:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80106750:	0f 85 98 00 00 00    	jne    801067ee <loaduvm+0xae>
80106756:	8b 75 18             	mov    0x18(%ebp),%esi
80106759:	31 db                	xor    %ebx,%ebx
8010675b:	85 f6                	test   %esi,%esi
8010675d:	75 1a                	jne    80106779 <loaduvm+0x39>
8010675f:	eb 77                	jmp    801067d8 <loaduvm+0x98>
80106761:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106768:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010676e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80106774:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80106777:	76 5f                	jbe    801067d8 <loaduvm+0x98>
80106779:	8b 55 0c             	mov    0xc(%ebp),%edx
8010677c:	31 c9                	xor    %ecx,%ecx
8010677e:	8b 45 08             	mov    0x8(%ebp),%eax
80106781:	01 da                	add    %ebx,%edx
80106783:	e8 98 fb ff ff       	call   80106320 <walkpgdir>
80106788:	85 c0                	test   %eax,%eax
8010678a:	74 56                	je     801067e2 <loaduvm+0xa2>
8010678c:	8b 00                	mov    (%eax),%eax
8010678e:	bf 00 10 00 00       	mov    $0x1000,%edi
80106793:	8b 4d 14             	mov    0x14(%ebp),%ecx
80106796:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010679b:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
801067a1:	0f 42 fe             	cmovb  %esi,%edi
801067a4:	05 00 00 00 80       	add    $0x80000000,%eax
801067a9:	89 44 24 04          	mov    %eax,0x4(%esp)
801067ad:	8b 45 10             	mov    0x10(%ebp),%eax
801067b0:	01 d9                	add    %ebx,%ecx
801067b2:	89 7c 24 0c          	mov    %edi,0xc(%esp)
801067b6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
801067ba:	89 04 24             	mov    %eax,(%esp)
801067bd:	e8 ae b1 ff ff       	call   80101970 <readi>
801067c2:	39 f8                	cmp    %edi,%eax
801067c4:	74 a2                	je     80106768 <loaduvm+0x28>
801067c6:	83 c4 1c             	add    $0x1c,%esp
801067c9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801067ce:	5b                   	pop    %ebx
801067cf:	5e                   	pop    %esi
801067d0:	5f                   	pop    %edi
801067d1:	5d                   	pop    %ebp
801067d2:	c3                   	ret    
801067d3:	90                   	nop
801067d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801067d8:	83 c4 1c             	add    $0x1c,%esp
801067db:	31 c0                	xor    %eax,%eax
801067dd:	5b                   	pop    %ebx
801067de:	5e                   	pop    %esi
801067df:	5f                   	pop    %edi
801067e0:	5d                   	pop    %ebp
801067e1:	c3                   	ret    
801067e2:	c7 04 24 27 76 10 80 	movl   $0x80107627,(%esp)
801067e9:	e8 72 9b ff ff       	call   80100360 <panic>
801067ee:	c7 04 24 c8 76 10 80 	movl   $0x801076c8,(%esp)
801067f5:	e8 66 9b ff ff       	call   80100360 <panic>
801067fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106800 <allocuvm>:
80106800:	55                   	push   %ebp
80106801:	89 e5                	mov    %esp,%ebp
80106803:	57                   	push   %edi
80106804:	56                   	push   %esi
80106805:	53                   	push   %ebx
80106806:	83 ec 1c             	sub    $0x1c,%esp
80106809:	8b 7d 10             	mov    0x10(%ebp),%edi
8010680c:	85 ff                	test   %edi,%edi
8010680e:	0f 88 7e 00 00 00    	js     80106892 <allocuvm+0x92>
80106814:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106817:	8b 45 0c             	mov    0xc(%ebp),%eax
8010681a:	72 78                	jb     80106894 <allocuvm+0x94>
8010681c:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106822:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80106828:	39 df                	cmp    %ebx,%edi
8010682a:	77 4a                	ja     80106876 <allocuvm+0x76>
8010682c:	eb 72                	jmp    801068a0 <allocuvm+0xa0>
8010682e:	66 90                	xchg   %ax,%ax
80106830:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106837:	00 
80106838:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010683f:	00 
80106840:	89 04 24             	mov    %eax,(%esp)
80106843:	e8 38 da ff ff       	call   80104280 <memset>
80106848:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
8010684e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106853:	89 04 24             	mov    %eax,(%esp)
80106856:	8b 45 08             	mov    0x8(%ebp),%eax
80106859:	89 da                	mov    %ebx,%edx
8010685b:	c7 44 24 04 06 00 00 	movl   $0x6,0x4(%esp)
80106862:	00 
80106863:	e8 48 fb ff ff       	call   801063b0 <mappages>
80106868:	85 c0                	test   %eax,%eax
8010686a:	78 44                	js     801068b0 <allocuvm+0xb0>
8010686c:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106872:	39 df                	cmp    %ebx,%edi
80106874:	76 2a                	jbe    801068a0 <allocuvm+0xa0>
80106876:	e8 35 bc ff ff       	call   801024b0 <kalloc>
8010687b:	85 c0                	test   %eax,%eax
8010687d:	89 c6                	mov    %eax,%esi
8010687f:	75 af                	jne    80106830 <allocuvm+0x30>
80106881:	c7 04 24 45 76 10 80 	movl   $0x80107645,(%esp)
80106888:	e8 c3 9d ff ff       	call   80100650 <cprintf>
8010688d:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106890:	77 48                	ja     801068da <allocuvm+0xda>
80106892:	31 c0                	xor    %eax,%eax
80106894:	83 c4 1c             	add    $0x1c,%esp
80106897:	5b                   	pop    %ebx
80106898:	5e                   	pop    %esi
80106899:	5f                   	pop    %edi
8010689a:	5d                   	pop    %ebp
8010689b:	c3                   	ret    
8010689c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801068a0:	83 c4 1c             	add    $0x1c,%esp
801068a3:	89 f8                	mov    %edi,%eax
801068a5:	5b                   	pop    %ebx
801068a6:	5e                   	pop    %esi
801068a7:	5f                   	pop    %edi
801068a8:	5d                   	pop    %ebp
801068a9:	c3                   	ret    
801068aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801068b0:	c7 04 24 5d 76 10 80 	movl   $0x8010765d,(%esp)
801068b7:	e8 94 9d ff ff       	call   80100650 <cprintf>
801068bc:	3b 7d 0c             	cmp    0xc(%ebp),%edi
801068bf:	76 0d                	jbe    801068ce <allocuvm+0xce>
801068c1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801068c4:	89 fa                	mov    %edi,%edx
801068c6:	8b 45 08             	mov    0x8(%ebp),%eax
801068c9:	e8 62 fb ff ff       	call   80106430 <deallocuvm.part.0>
801068ce:	89 34 24             	mov    %esi,(%esp)
801068d1:	e8 2a ba ff ff       	call   80102300 <kfree>
801068d6:	31 c0                	xor    %eax,%eax
801068d8:	eb ba                	jmp    80106894 <allocuvm+0x94>
801068da:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801068dd:	89 fa                	mov    %edi,%edx
801068df:	8b 45 08             	mov    0x8(%ebp),%eax
801068e2:	e8 49 fb ff ff       	call   80106430 <deallocuvm.part.0>
801068e7:	31 c0                	xor    %eax,%eax
801068e9:	eb a9                	jmp    80106894 <allocuvm+0x94>
801068eb:	90                   	nop
801068ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801068f0 <deallocuvm>:
801068f0:	55                   	push   %ebp
801068f1:	89 e5                	mov    %esp,%ebp
801068f3:	8b 55 0c             	mov    0xc(%ebp),%edx
801068f6:	8b 4d 10             	mov    0x10(%ebp),%ecx
801068f9:	8b 45 08             	mov    0x8(%ebp),%eax
801068fc:	39 d1                	cmp    %edx,%ecx
801068fe:	73 08                	jae    80106908 <deallocuvm+0x18>
80106900:	5d                   	pop    %ebp
80106901:	e9 2a fb ff ff       	jmp    80106430 <deallocuvm.part.0>
80106906:	66 90                	xchg   %ax,%ax
80106908:	89 d0                	mov    %edx,%eax
8010690a:	5d                   	pop    %ebp
8010690b:	c3                   	ret    
8010690c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106910 <freevm>:
80106910:	55                   	push   %ebp
80106911:	89 e5                	mov    %esp,%ebp
80106913:	56                   	push   %esi
80106914:	53                   	push   %ebx
80106915:	83 ec 10             	sub    $0x10,%esp
80106918:	8b 75 08             	mov    0x8(%ebp),%esi
8010691b:	85 f6                	test   %esi,%esi
8010691d:	74 59                	je     80106978 <freevm+0x68>
8010691f:	31 c9                	xor    %ecx,%ecx
80106921:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106926:	89 f0                	mov    %esi,%eax
80106928:	31 db                	xor    %ebx,%ebx
8010692a:	e8 01 fb ff ff       	call   80106430 <deallocuvm.part.0>
8010692f:	eb 12                	jmp    80106943 <freevm+0x33>
80106931:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106938:	83 c3 01             	add    $0x1,%ebx
8010693b:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
80106941:	74 27                	je     8010696a <freevm+0x5a>
80106943:	8b 14 9e             	mov    (%esi,%ebx,4),%edx
80106946:	f6 c2 01             	test   $0x1,%dl
80106949:	74 ed                	je     80106938 <freevm+0x28>
8010694b:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106951:	83 c3 01             	add    $0x1,%ebx
80106954:	81 c2 00 00 00 80    	add    $0x80000000,%edx
8010695a:	89 14 24             	mov    %edx,(%esp)
8010695d:	e8 9e b9 ff ff       	call   80102300 <kfree>
80106962:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
80106968:	75 d9                	jne    80106943 <freevm+0x33>
8010696a:	89 75 08             	mov    %esi,0x8(%ebp)
8010696d:	83 c4 10             	add    $0x10,%esp
80106970:	5b                   	pop    %ebx
80106971:	5e                   	pop    %esi
80106972:	5d                   	pop    %ebp
80106973:	e9 88 b9 ff ff       	jmp    80102300 <kfree>
80106978:	c7 04 24 79 76 10 80 	movl   $0x80107679,(%esp)
8010697f:	e8 dc 99 ff ff       	call   80100360 <panic>
80106984:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010698a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106990 <setupkvm>:
80106990:	55                   	push   %ebp
80106991:	89 e5                	mov    %esp,%ebp
80106993:	56                   	push   %esi
80106994:	53                   	push   %ebx
80106995:	83 ec 10             	sub    $0x10,%esp
80106998:	e8 13 bb ff ff       	call   801024b0 <kalloc>
8010699d:	85 c0                	test   %eax,%eax
8010699f:	89 c6                	mov    %eax,%esi
801069a1:	74 6d                	je     80106a10 <setupkvm+0x80>
801069a3:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801069aa:	00 
801069ab:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
801069b0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801069b7:	00 
801069b8:	89 04 24             	mov    %eax,(%esp)
801069bb:	e8 c0 d8 ff ff       	call   80104280 <memset>
801069c0:	8b 53 0c             	mov    0xc(%ebx),%edx
801069c3:	8b 43 04             	mov    0x4(%ebx),%eax
801069c6:	8b 4b 08             	mov    0x8(%ebx),%ecx
801069c9:	89 54 24 04          	mov    %edx,0x4(%esp)
801069cd:	8b 13                	mov    (%ebx),%edx
801069cf:	89 04 24             	mov    %eax,(%esp)
801069d2:	29 c1                	sub    %eax,%ecx
801069d4:	89 f0                	mov    %esi,%eax
801069d6:	e8 d5 f9 ff ff       	call   801063b0 <mappages>
801069db:	85 c0                	test   %eax,%eax
801069dd:	78 19                	js     801069f8 <setupkvm+0x68>
801069df:	83 c3 10             	add    $0x10,%ebx
801069e2:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
801069e8:	72 d6                	jb     801069c0 <setupkvm+0x30>
801069ea:	89 f0                	mov    %esi,%eax
801069ec:	83 c4 10             	add    $0x10,%esp
801069ef:	5b                   	pop    %ebx
801069f0:	5e                   	pop    %esi
801069f1:	5d                   	pop    %ebp
801069f2:	c3                   	ret    
801069f3:	90                   	nop
801069f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801069f8:	89 34 24             	mov    %esi,(%esp)
801069fb:	e8 10 ff ff ff       	call   80106910 <freevm>
80106a00:	83 c4 10             	add    $0x10,%esp
80106a03:	31 c0                	xor    %eax,%eax
80106a05:	5b                   	pop    %ebx
80106a06:	5e                   	pop    %esi
80106a07:	5d                   	pop    %ebp
80106a08:	c3                   	ret    
80106a09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a10:	31 c0                	xor    %eax,%eax
80106a12:	eb d8                	jmp    801069ec <setupkvm+0x5c>
80106a14:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106a1a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106a20 <kvmalloc>:
80106a20:	55                   	push   %ebp
80106a21:	89 e5                	mov    %esp,%ebp
80106a23:	83 ec 08             	sub    $0x8,%esp
80106a26:	e8 65 ff ff ff       	call   80106990 <setupkvm>
80106a2b:	a3 a4 54 11 80       	mov    %eax,0x801154a4
80106a30:	05 00 00 00 80       	add    $0x80000000,%eax
80106a35:	0f 22 d8             	mov    %eax,%cr3
80106a38:	c9                   	leave  
80106a39:	c3                   	ret    
80106a3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106a40 <clearpteu>:
80106a40:	55                   	push   %ebp
80106a41:	31 c9                	xor    %ecx,%ecx
80106a43:	89 e5                	mov    %esp,%ebp
80106a45:	83 ec 18             	sub    $0x18,%esp
80106a48:	8b 55 0c             	mov    0xc(%ebp),%edx
80106a4b:	8b 45 08             	mov    0x8(%ebp),%eax
80106a4e:	e8 cd f8 ff ff       	call   80106320 <walkpgdir>
80106a53:	85 c0                	test   %eax,%eax
80106a55:	74 05                	je     80106a5c <clearpteu+0x1c>
80106a57:	83 20 fb             	andl   $0xfffffffb,(%eax)
80106a5a:	c9                   	leave  
80106a5b:	c3                   	ret    
80106a5c:	c7 04 24 8a 76 10 80 	movl   $0x8010768a,(%esp)
80106a63:	e8 f8 98 ff ff       	call   80100360 <panic>
80106a68:	90                   	nop
80106a69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106a70 <copyuvm>:
80106a70:	55                   	push   %ebp
80106a71:	89 e5                	mov    %esp,%ebp
80106a73:	57                   	push   %edi
80106a74:	56                   	push   %esi
80106a75:	53                   	push   %ebx
80106a76:	83 ec 2c             	sub    $0x2c,%esp
80106a79:	e8 12 ff ff ff       	call   80106990 <setupkvm>
80106a7e:	85 c0                	test   %eax,%eax
80106a80:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106a83:	0f 84 b2 00 00 00    	je     80106b3b <copyuvm+0xcb>
80106a89:	8b 45 0c             	mov    0xc(%ebp),%eax
80106a8c:	85 c0                	test   %eax,%eax
80106a8e:	0f 84 9c 00 00 00    	je     80106b30 <copyuvm+0xc0>
80106a94:	31 db                	xor    %ebx,%ebx
80106a96:	eb 48                	jmp    80106ae0 <copyuvm+0x70>
80106a98:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80106a9e:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106aa5:	00 
80106aa6:	89 7c 24 04          	mov    %edi,0x4(%esp)
80106aaa:	89 04 24             	mov    %eax,(%esp)
80106aad:	e8 6e d8 ff ff       	call   80104320 <memmove>
80106ab2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106ab5:	8d 96 00 00 00 80    	lea    -0x80000000(%esi),%edx
80106abb:	89 14 24             	mov    %edx,(%esp)
80106abe:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106ac3:	89 da                	mov    %ebx,%edx
80106ac5:	89 44 24 04          	mov    %eax,0x4(%esp)
80106ac9:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106acc:	e8 df f8 ff ff       	call   801063b0 <mappages>
80106ad1:	85 c0                	test   %eax,%eax
80106ad3:	78 41                	js     80106b16 <copyuvm+0xa6>
80106ad5:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106adb:	39 5d 0c             	cmp    %ebx,0xc(%ebp)
80106ade:	76 50                	jbe    80106b30 <copyuvm+0xc0>
80106ae0:	8b 45 08             	mov    0x8(%ebp),%eax
80106ae3:	31 c9                	xor    %ecx,%ecx
80106ae5:	89 da                	mov    %ebx,%edx
80106ae7:	e8 34 f8 ff ff       	call   80106320 <walkpgdir>
80106aec:	85 c0                	test   %eax,%eax
80106aee:	74 5b                	je     80106b4b <copyuvm+0xdb>
80106af0:	8b 30                	mov    (%eax),%esi
80106af2:	f7 c6 01 00 00 00    	test   $0x1,%esi
80106af8:	74 45                	je     80106b3f <copyuvm+0xcf>
80106afa:	89 f7                	mov    %esi,%edi
80106afc:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
80106b02:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80106b05:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80106b0b:	e8 a0 b9 ff ff       	call   801024b0 <kalloc>
80106b10:	85 c0                	test   %eax,%eax
80106b12:	89 c6                	mov    %eax,%esi
80106b14:	75 82                	jne    80106a98 <copyuvm+0x28>
80106b16:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106b19:	89 04 24             	mov    %eax,(%esp)
80106b1c:	e8 ef fd ff ff       	call   80106910 <freevm>
80106b21:	31 c0                	xor    %eax,%eax
80106b23:	83 c4 2c             	add    $0x2c,%esp
80106b26:	5b                   	pop    %ebx
80106b27:	5e                   	pop    %esi
80106b28:	5f                   	pop    %edi
80106b29:	5d                   	pop    %ebp
80106b2a:	c3                   	ret    
80106b2b:	90                   	nop
80106b2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106b30:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106b33:	83 c4 2c             	add    $0x2c,%esp
80106b36:	5b                   	pop    %ebx
80106b37:	5e                   	pop    %esi
80106b38:	5f                   	pop    %edi
80106b39:	5d                   	pop    %ebp
80106b3a:	c3                   	ret    
80106b3b:	31 c0                	xor    %eax,%eax
80106b3d:	eb e4                	jmp    80106b23 <copyuvm+0xb3>
80106b3f:	c7 04 24 ae 76 10 80 	movl   $0x801076ae,(%esp)
80106b46:	e8 15 98 ff ff       	call   80100360 <panic>
80106b4b:	c7 04 24 94 76 10 80 	movl   $0x80107694,(%esp)
80106b52:	e8 09 98 ff ff       	call   80100360 <panic>
80106b57:	89 f6                	mov    %esi,%esi
80106b59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106b60 <uva2ka>:
80106b60:	55                   	push   %ebp
80106b61:	31 c9                	xor    %ecx,%ecx
80106b63:	89 e5                	mov    %esp,%ebp
80106b65:	83 ec 08             	sub    $0x8,%esp
80106b68:	8b 55 0c             	mov    0xc(%ebp),%edx
80106b6b:	8b 45 08             	mov    0x8(%ebp),%eax
80106b6e:	e8 ad f7 ff ff       	call   80106320 <walkpgdir>
80106b73:	8b 00                	mov    (%eax),%eax
80106b75:	89 c2                	mov    %eax,%edx
80106b77:	83 e2 05             	and    $0x5,%edx
80106b7a:	83 fa 05             	cmp    $0x5,%edx
80106b7d:	75 11                	jne    80106b90 <uva2ka+0x30>
80106b7f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106b84:	05 00 00 00 80       	add    $0x80000000,%eax
80106b89:	c9                   	leave  
80106b8a:	c3                   	ret    
80106b8b:	90                   	nop
80106b8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106b90:	31 c0                	xor    %eax,%eax
80106b92:	c9                   	leave  
80106b93:	c3                   	ret    
80106b94:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106b9a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106ba0 <copyout>:
80106ba0:	55                   	push   %ebp
80106ba1:	89 e5                	mov    %esp,%ebp
80106ba3:	57                   	push   %edi
80106ba4:	56                   	push   %esi
80106ba5:	53                   	push   %ebx
80106ba6:	83 ec 1c             	sub    $0x1c,%esp
80106ba9:	8b 5d 14             	mov    0x14(%ebp),%ebx
80106bac:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106baf:	8b 7d 10             	mov    0x10(%ebp),%edi
80106bb2:	85 db                	test   %ebx,%ebx
80106bb4:	75 3a                	jne    80106bf0 <copyout+0x50>
80106bb6:	eb 68                	jmp    80106c20 <copyout+0x80>
80106bb8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106bbb:	89 f2                	mov    %esi,%edx
80106bbd:	89 7c 24 04          	mov    %edi,0x4(%esp)
80106bc1:	29 ca                	sub    %ecx,%edx
80106bc3:	81 c2 00 10 00 00    	add    $0x1000,%edx
80106bc9:	39 da                	cmp    %ebx,%edx
80106bcb:	0f 47 d3             	cmova  %ebx,%edx
80106bce:	29 f1                	sub    %esi,%ecx
80106bd0:	01 c8                	add    %ecx,%eax
80106bd2:	89 54 24 08          	mov    %edx,0x8(%esp)
80106bd6:	89 04 24             	mov    %eax,(%esp)
80106bd9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80106bdc:	e8 3f d7 ff ff       	call   80104320 <memmove>
80106be1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106be4:	8d 8e 00 10 00 00    	lea    0x1000(%esi),%ecx
80106bea:	01 d7                	add    %edx,%edi
80106bec:	29 d3                	sub    %edx,%ebx
80106bee:	74 30                	je     80106c20 <copyout+0x80>
80106bf0:	8b 45 08             	mov    0x8(%ebp),%eax
80106bf3:	89 ce                	mov    %ecx,%esi
80106bf5:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
80106bfb:	89 74 24 04          	mov    %esi,0x4(%esp)
80106bff:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80106c02:	89 04 24             	mov    %eax,(%esp)
80106c05:	e8 56 ff ff ff       	call   80106b60 <uva2ka>
80106c0a:	85 c0                	test   %eax,%eax
80106c0c:	75 aa                	jne    80106bb8 <copyout+0x18>
80106c0e:	83 c4 1c             	add    $0x1c,%esp
80106c11:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106c16:	5b                   	pop    %ebx
80106c17:	5e                   	pop    %esi
80106c18:	5f                   	pop    %edi
80106c19:	5d                   	pop    %ebp
80106c1a:	c3                   	ret    
80106c1b:	90                   	nop
80106c1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106c20:	83 c4 1c             	add    $0x1c,%esp
80106c23:	31 c0                	xor    %eax,%eax
80106c25:	5b                   	pop    %ebx
80106c26:	5e                   	pop    %esi
80106c27:	5f                   	pop    %edi
80106c28:	5d                   	pop    %ebp
80106c29:	c3                   	ret    
