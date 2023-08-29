
_buffer_overflow:     file format elf32-i386


Disassembly of section .text:

00000000 <foo>:
#include "types.h"
#include "user.h"
#include "fcntl.h"

void foo()
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 08             	sub    $0x8,%esp
    printf(1, "SECRET_STRING");
   6:	83 ec 08             	sub    $0x8,%esp
   9:	68 14 08 00 00       	push   $0x814
   e:	6a 01                	push   $0x1
  10:	e8 48 04 00 00       	call   45d <printf>
  15:	83 c4 10             	add    $0x10,%esp
}
  18:	90                   	nop
  19:	c9                   	leave  
  1a:	c3                   	ret    

0000001b <vulnerable_func>:


void vulnerable_func(char *payload)
{
  1b:	55                   	push   %ebp
  1c:	89 e5                	mov    %esp,%ebp
  1e:	83 ec 18             	sub    $0x18,%esp
    char buffer[4];
    strcpy(buffer, payload);
  21:	83 ec 08             	sub    $0x8,%esp
  24:	ff 75 08             	push   0x8(%ebp)
  27:	8d 45 f4             	lea    -0xc(%ebp),%eax
  2a:	50                   	push   %eax
  2b:	e8 88 00 00 00       	call   b8 <strcpy>
  30:	83 c4 10             	add    $0x10,%esp
}
  33:	90                   	nop
  34:	c9                   	leave  
  35:	c3                   	ret    

00000036 <main>:

int main(int argc, char *argv[])
{
  36:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  3a:	83 e4 f0             	and    $0xfffffff0,%esp
  3d:	ff 71 fc             	push   -0x4(%ecx)
  40:	55                   	push   %ebp
  41:	89 e5                	mov    %esp,%ebp
  43:	51                   	push   %ecx
  44:	83 ec 74             	sub    $0x74,%esp
    int fd;

    fd = open("payload", O_RDONLY);
  47:	83 ec 08             	sub    $0x8,%esp
  4a:	6a 00                	push   $0x0
  4c:	68 22 08 00 00       	push   $0x822
  51:	e8 d3 02 00 00       	call   329 <open>
  56:	83 c4 10             	add    $0x10,%esp
  59:	89 45 f4             	mov    %eax,-0xc(%ebp)
    char payload[100];

    read(fd, payload, 100);
  5c:	83 ec 04             	sub    $0x4,%esp
  5f:	6a 64                	push   $0x64
  61:	8d 45 90             	lea    -0x70(%ebp),%eax
  64:	50                   	push   %eax
  65:	ff 75 f4             	push   -0xc(%ebp)
  68:	e8 94 02 00 00       	call   301 <read>
  6d:	83 c4 10             	add    $0x10,%esp

    vulnerable_func(payload);
  70:	83 ec 0c             	sub    $0xc,%esp
  73:	8d 45 90             	lea    -0x70(%ebp),%eax
  76:	50                   	push   %eax
  77:	e8 9f ff ff ff       	call   1b <vulnerable_func>
  7c:	83 c4 10             	add    $0x10,%esp

    close(fd);
  7f:	83 ec 0c             	sub    $0xc,%esp
  82:	ff 75 f4             	push   -0xc(%ebp)
  85:	e8 87 02 00 00       	call   311 <close>
  8a:	83 c4 10             	add    $0x10,%esp
    exit();
  8d:	e8 57 02 00 00       	call   2e9 <exit>

00000092 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  92:	55                   	push   %ebp
  93:	89 e5                	mov    %esp,%ebp
  95:	57                   	push   %edi
  96:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  97:	8b 4d 08             	mov    0x8(%ebp),%ecx
  9a:	8b 55 10             	mov    0x10(%ebp),%edx
  9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  a0:	89 cb                	mov    %ecx,%ebx
  a2:	89 df                	mov    %ebx,%edi
  a4:	89 d1                	mov    %edx,%ecx
  a6:	fc                   	cld    
  a7:	f3 aa                	rep stos %al,%es:(%edi)
  a9:	89 ca                	mov    %ecx,%edx
  ab:	89 fb                	mov    %edi,%ebx
  ad:	89 5d 08             	mov    %ebx,0x8(%ebp)
  b0:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  b3:	90                   	nop
  b4:	5b                   	pop    %ebx
  b5:	5f                   	pop    %edi
  b6:	5d                   	pop    %ebp
  b7:	c3                   	ret    

000000b8 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  b8:	55                   	push   %ebp
  b9:	89 e5                	mov    %esp,%ebp
  bb:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  be:	8b 45 08             	mov    0x8(%ebp),%eax
  c1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  c4:	90                   	nop
  c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  c8:	8d 42 01             	lea    0x1(%edx),%eax
  cb:	89 45 0c             	mov    %eax,0xc(%ebp)
  ce:	8b 45 08             	mov    0x8(%ebp),%eax
  d1:	8d 48 01             	lea    0x1(%eax),%ecx
  d4:	89 4d 08             	mov    %ecx,0x8(%ebp)
  d7:	0f b6 12             	movzbl (%edx),%edx
  da:	88 10                	mov    %dl,(%eax)
  dc:	0f b6 00             	movzbl (%eax),%eax
  df:	84 c0                	test   %al,%al
  e1:	75 e2                	jne    c5 <strcpy+0xd>
    ;
  return os;
  e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  e6:	c9                   	leave  
  e7:	c3                   	ret    

000000e8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  e8:	55                   	push   %ebp
  e9:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  eb:	eb 08                	jmp    f5 <strcmp+0xd>
    p++, q++;
  ed:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  f1:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
  f5:	8b 45 08             	mov    0x8(%ebp),%eax
  f8:	0f b6 00             	movzbl (%eax),%eax
  fb:	84 c0                	test   %al,%al
  fd:	74 10                	je     10f <strcmp+0x27>
  ff:	8b 45 08             	mov    0x8(%ebp),%eax
 102:	0f b6 10             	movzbl (%eax),%edx
 105:	8b 45 0c             	mov    0xc(%ebp),%eax
 108:	0f b6 00             	movzbl (%eax),%eax
 10b:	38 c2                	cmp    %al,%dl
 10d:	74 de                	je     ed <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 10f:	8b 45 08             	mov    0x8(%ebp),%eax
 112:	0f b6 00             	movzbl (%eax),%eax
 115:	0f b6 d0             	movzbl %al,%edx
 118:	8b 45 0c             	mov    0xc(%ebp),%eax
 11b:	0f b6 00             	movzbl (%eax),%eax
 11e:	0f b6 c8             	movzbl %al,%ecx
 121:	89 d0                	mov    %edx,%eax
 123:	29 c8                	sub    %ecx,%eax
}
 125:	5d                   	pop    %ebp
 126:	c3                   	ret    

00000127 <strlen>:

uint
strlen(const char *s)
{
 127:	55                   	push   %ebp
 128:	89 e5                	mov    %esp,%ebp
 12a:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 12d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 134:	eb 04                	jmp    13a <strlen+0x13>
 136:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 13a:	8b 55 fc             	mov    -0x4(%ebp),%edx
 13d:	8b 45 08             	mov    0x8(%ebp),%eax
 140:	01 d0                	add    %edx,%eax
 142:	0f b6 00             	movzbl (%eax),%eax
 145:	84 c0                	test   %al,%al
 147:	75 ed                	jne    136 <strlen+0xf>
    ;
  return n;
 149:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 14c:	c9                   	leave  
 14d:	c3                   	ret    

0000014e <memset>:

void*
memset(void *dst, int c, uint n)
{
 14e:	55                   	push   %ebp
 14f:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 151:	8b 45 10             	mov    0x10(%ebp),%eax
 154:	50                   	push   %eax
 155:	ff 75 0c             	push   0xc(%ebp)
 158:	ff 75 08             	push   0x8(%ebp)
 15b:	e8 32 ff ff ff       	call   92 <stosb>
 160:	83 c4 0c             	add    $0xc,%esp
  return dst;
 163:	8b 45 08             	mov    0x8(%ebp),%eax
}
 166:	c9                   	leave  
 167:	c3                   	ret    

00000168 <strchr>:

char*
strchr(const char *s, char c)
{
 168:	55                   	push   %ebp
 169:	89 e5                	mov    %esp,%ebp
 16b:	83 ec 04             	sub    $0x4,%esp
 16e:	8b 45 0c             	mov    0xc(%ebp),%eax
 171:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 174:	eb 14                	jmp    18a <strchr+0x22>
    if(*s == c)
 176:	8b 45 08             	mov    0x8(%ebp),%eax
 179:	0f b6 00             	movzbl (%eax),%eax
 17c:	38 45 fc             	cmp    %al,-0x4(%ebp)
 17f:	75 05                	jne    186 <strchr+0x1e>
      return (char*)s;
 181:	8b 45 08             	mov    0x8(%ebp),%eax
 184:	eb 13                	jmp    199 <strchr+0x31>
  for(; *s; s++)
 186:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 18a:	8b 45 08             	mov    0x8(%ebp),%eax
 18d:	0f b6 00             	movzbl (%eax),%eax
 190:	84 c0                	test   %al,%al
 192:	75 e2                	jne    176 <strchr+0xe>
  return 0;
 194:	b8 00 00 00 00       	mov    $0x0,%eax
}
 199:	c9                   	leave  
 19a:	c3                   	ret    

0000019b <gets>:

char*
gets(char *buf, int max)
{
 19b:	55                   	push   %ebp
 19c:	89 e5                	mov    %esp,%ebp
 19e:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1a1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1a8:	eb 42                	jmp    1ec <gets+0x51>
    cc = read(0, &c, 1);
 1aa:	83 ec 04             	sub    $0x4,%esp
 1ad:	6a 01                	push   $0x1
 1af:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1b2:	50                   	push   %eax
 1b3:	6a 00                	push   $0x0
 1b5:	e8 47 01 00 00       	call   301 <read>
 1ba:	83 c4 10             	add    $0x10,%esp
 1bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1c0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1c4:	7e 33                	jle    1f9 <gets+0x5e>
      break;
    buf[i++] = c;
 1c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1c9:	8d 50 01             	lea    0x1(%eax),%edx
 1cc:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1cf:	89 c2                	mov    %eax,%edx
 1d1:	8b 45 08             	mov    0x8(%ebp),%eax
 1d4:	01 c2                	add    %eax,%edx
 1d6:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1da:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1dc:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1e0:	3c 0a                	cmp    $0xa,%al
 1e2:	74 16                	je     1fa <gets+0x5f>
 1e4:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1e8:	3c 0d                	cmp    $0xd,%al
 1ea:	74 0e                	je     1fa <gets+0x5f>
  for(i=0; i+1 < max; ){
 1ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1ef:	83 c0 01             	add    $0x1,%eax
 1f2:	39 45 0c             	cmp    %eax,0xc(%ebp)
 1f5:	7f b3                	jg     1aa <gets+0xf>
 1f7:	eb 01                	jmp    1fa <gets+0x5f>
      break;
 1f9:	90                   	nop
      break;
  }
  buf[i] = '\0';
 1fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1fd:	8b 45 08             	mov    0x8(%ebp),%eax
 200:	01 d0                	add    %edx,%eax
 202:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 205:	8b 45 08             	mov    0x8(%ebp),%eax
}
 208:	c9                   	leave  
 209:	c3                   	ret    

0000020a <stat>:

int
stat(const char *n, struct stat *st)
{
 20a:	55                   	push   %ebp
 20b:	89 e5                	mov    %esp,%ebp
 20d:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 210:	83 ec 08             	sub    $0x8,%esp
 213:	6a 00                	push   $0x0
 215:	ff 75 08             	push   0x8(%ebp)
 218:	e8 0c 01 00 00       	call   329 <open>
 21d:	83 c4 10             	add    $0x10,%esp
 220:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 223:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 227:	79 07                	jns    230 <stat+0x26>
    return -1;
 229:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 22e:	eb 25                	jmp    255 <stat+0x4b>
  r = fstat(fd, st);
 230:	83 ec 08             	sub    $0x8,%esp
 233:	ff 75 0c             	push   0xc(%ebp)
 236:	ff 75 f4             	push   -0xc(%ebp)
 239:	e8 03 01 00 00       	call   341 <fstat>
 23e:	83 c4 10             	add    $0x10,%esp
 241:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 244:	83 ec 0c             	sub    $0xc,%esp
 247:	ff 75 f4             	push   -0xc(%ebp)
 24a:	e8 c2 00 00 00       	call   311 <close>
 24f:	83 c4 10             	add    $0x10,%esp
  return r;
 252:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 255:	c9                   	leave  
 256:	c3                   	ret    

00000257 <atoi>:

int
atoi(const char *s)
{
 257:	55                   	push   %ebp
 258:	89 e5                	mov    %esp,%ebp
 25a:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 25d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 264:	eb 25                	jmp    28b <atoi+0x34>
    n = n*10 + *s++ - '0';
 266:	8b 55 fc             	mov    -0x4(%ebp),%edx
 269:	89 d0                	mov    %edx,%eax
 26b:	c1 e0 02             	shl    $0x2,%eax
 26e:	01 d0                	add    %edx,%eax
 270:	01 c0                	add    %eax,%eax
 272:	89 c1                	mov    %eax,%ecx
 274:	8b 45 08             	mov    0x8(%ebp),%eax
 277:	8d 50 01             	lea    0x1(%eax),%edx
 27a:	89 55 08             	mov    %edx,0x8(%ebp)
 27d:	0f b6 00             	movzbl (%eax),%eax
 280:	0f be c0             	movsbl %al,%eax
 283:	01 c8                	add    %ecx,%eax
 285:	83 e8 30             	sub    $0x30,%eax
 288:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 28b:	8b 45 08             	mov    0x8(%ebp),%eax
 28e:	0f b6 00             	movzbl (%eax),%eax
 291:	3c 2f                	cmp    $0x2f,%al
 293:	7e 0a                	jle    29f <atoi+0x48>
 295:	8b 45 08             	mov    0x8(%ebp),%eax
 298:	0f b6 00             	movzbl (%eax),%eax
 29b:	3c 39                	cmp    $0x39,%al
 29d:	7e c7                	jle    266 <atoi+0xf>
  return n;
 29f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2a2:	c9                   	leave  
 2a3:	c3                   	ret    

000002a4 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2a4:	55                   	push   %ebp
 2a5:	89 e5                	mov    %esp,%ebp
 2a7:	83 ec 10             	sub    $0x10,%esp
  char *dst;
  const char *src;

  dst = vdst;
 2aa:	8b 45 08             	mov    0x8(%ebp),%eax
 2ad:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 2b0:	8b 45 0c             	mov    0xc(%ebp),%eax
 2b3:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2b6:	eb 17                	jmp    2cf <memmove+0x2b>
    *dst++ = *src++;
 2b8:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2bb:	8d 42 01             	lea    0x1(%edx),%eax
 2be:	89 45 f8             	mov    %eax,-0x8(%ebp)
 2c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2c4:	8d 48 01             	lea    0x1(%eax),%ecx
 2c7:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 2ca:	0f b6 12             	movzbl (%edx),%edx
 2cd:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 2cf:	8b 45 10             	mov    0x10(%ebp),%eax
 2d2:	8d 50 ff             	lea    -0x1(%eax),%edx
 2d5:	89 55 10             	mov    %edx,0x10(%ebp)
 2d8:	85 c0                	test   %eax,%eax
 2da:	7f dc                	jg     2b8 <memmove+0x14>
  return vdst;
 2dc:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2df:	c9                   	leave  
 2e0:	c3                   	ret    

000002e1 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2e1:	b8 01 00 00 00       	mov    $0x1,%eax
 2e6:	cd 40                	int    $0x40
 2e8:	c3                   	ret    

000002e9 <exit>:
SYSCALL(exit)
 2e9:	b8 02 00 00 00       	mov    $0x2,%eax
 2ee:	cd 40                	int    $0x40
 2f0:	c3                   	ret    

000002f1 <wait>:
SYSCALL(wait)
 2f1:	b8 03 00 00 00       	mov    $0x3,%eax
 2f6:	cd 40                	int    $0x40
 2f8:	c3                   	ret    

000002f9 <pipe>:
SYSCALL(pipe)
 2f9:	b8 04 00 00 00       	mov    $0x4,%eax
 2fe:	cd 40                	int    $0x40
 300:	c3                   	ret    

00000301 <read>:
SYSCALL(read)
 301:	b8 05 00 00 00       	mov    $0x5,%eax
 306:	cd 40                	int    $0x40
 308:	c3                   	ret    

00000309 <write>:
SYSCALL(write)
 309:	b8 10 00 00 00       	mov    $0x10,%eax
 30e:	cd 40                	int    $0x40
 310:	c3                   	ret    

00000311 <close>:
SYSCALL(close)
 311:	b8 15 00 00 00       	mov    $0x15,%eax
 316:	cd 40                	int    $0x40
 318:	c3                   	ret    

00000319 <kill>:
SYSCALL(kill)
 319:	b8 06 00 00 00       	mov    $0x6,%eax
 31e:	cd 40                	int    $0x40
 320:	c3                   	ret    

00000321 <exec>:
SYSCALL(exec)
 321:	b8 07 00 00 00       	mov    $0x7,%eax
 326:	cd 40                	int    $0x40
 328:	c3                   	ret    

00000329 <open>:
SYSCALL(open)
 329:	b8 0f 00 00 00       	mov    $0xf,%eax
 32e:	cd 40                	int    $0x40
 330:	c3                   	ret    

00000331 <mknod>:
SYSCALL(mknod)
 331:	b8 11 00 00 00       	mov    $0x11,%eax
 336:	cd 40                	int    $0x40
 338:	c3                   	ret    

00000339 <unlink>:
SYSCALL(unlink)
 339:	b8 12 00 00 00       	mov    $0x12,%eax
 33e:	cd 40                	int    $0x40
 340:	c3                   	ret    

00000341 <fstat>:
SYSCALL(fstat)
 341:	b8 08 00 00 00       	mov    $0x8,%eax
 346:	cd 40                	int    $0x40
 348:	c3                   	ret    

00000349 <link>:
SYSCALL(link)
 349:	b8 13 00 00 00       	mov    $0x13,%eax
 34e:	cd 40                	int    $0x40
 350:	c3                   	ret    

00000351 <mkdir>:
SYSCALL(mkdir)
 351:	b8 14 00 00 00       	mov    $0x14,%eax
 356:	cd 40                	int    $0x40
 358:	c3                   	ret    

00000359 <chdir>:
SYSCALL(chdir)
 359:	b8 09 00 00 00       	mov    $0x9,%eax
 35e:	cd 40                	int    $0x40
 360:	c3                   	ret    

00000361 <dup>:
SYSCALL(dup)
 361:	b8 0a 00 00 00       	mov    $0xa,%eax
 366:	cd 40                	int    $0x40
 368:	c3                   	ret    

00000369 <getpid>:
SYSCALL(getpid)
 369:	b8 0b 00 00 00       	mov    $0xb,%eax
 36e:	cd 40                	int    $0x40
 370:	c3                   	ret    

00000371 <sbrk>:
SYSCALL(sbrk)
 371:	b8 0c 00 00 00       	mov    $0xc,%eax
 376:	cd 40                	int    $0x40
 378:	c3                   	ret    

00000379 <sleep>:
SYSCALL(sleep)
 379:	b8 0d 00 00 00       	mov    $0xd,%eax
 37e:	cd 40                	int    $0x40
 380:	c3                   	ret    

00000381 <uptime>:
SYSCALL(uptime)
 381:	b8 0e 00 00 00       	mov    $0xe,%eax
 386:	cd 40                	int    $0x40
 388:	c3                   	ret    

00000389 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 389:	55                   	push   %ebp
 38a:	89 e5                	mov    %esp,%ebp
 38c:	83 ec 18             	sub    $0x18,%esp
 38f:	8b 45 0c             	mov    0xc(%ebp),%eax
 392:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 395:	83 ec 04             	sub    $0x4,%esp
 398:	6a 01                	push   $0x1
 39a:	8d 45 f4             	lea    -0xc(%ebp),%eax
 39d:	50                   	push   %eax
 39e:	ff 75 08             	push   0x8(%ebp)
 3a1:	e8 63 ff ff ff       	call   309 <write>
 3a6:	83 c4 10             	add    $0x10,%esp
}
 3a9:	90                   	nop
 3aa:	c9                   	leave  
 3ab:	c3                   	ret    

000003ac <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3ac:	55                   	push   %ebp
 3ad:	89 e5                	mov    %esp,%ebp
 3af:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3b2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3b9:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3bd:	74 17                	je     3d6 <printint+0x2a>
 3bf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3c3:	79 11                	jns    3d6 <printint+0x2a>
    neg = 1;
 3c5:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3cc:	8b 45 0c             	mov    0xc(%ebp),%eax
 3cf:	f7 d8                	neg    %eax
 3d1:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3d4:	eb 06                	jmp    3dc <printint+0x30>
  } else {
    x = xx;
 3d6:	8b 45 0c             	mov    0xc(%ebp),%eax
 3d9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3dc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3e3:	8b 4d 10             	mov    0x10(%ebp),%ecx
 3e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3e9:	ba 00 00 00 00       	mov    $0x0,%edx
 3ee:	f7 f1                	div    %ecx
 3f0:	89 d1                	mov    %edx,%ecx
 3f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3f5:	8d 50 01             	lea    0x1(%eax),%edx
 3f8:	89 55 f4             	mov    %edx,-0xc(%ebp)
 3fb:	0f b6 91 b8 0a 00 00 	movzbl 0xab8(%ecx),%edx
 402:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
 406:	8b 4d 10             	mov    0x10(%ebp),%ecx
 409:	8b 45 ec             	mov    -0x14(%ebp),%eax
 40c:	ba 00 00 00 00       	mov    $0x0,%edx
 411:	f7 f1                	div    %ecx
 413:	89 45 ec             	mov    %eax,-0x14(%ebp)
 416:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 41a:	75 c7                	jne    3e3 <printint+0x37>
  if(neg)
 41c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 420:	74 2d                	je     44f <printint+0xa3>
    buf[i++] = '-';
 422:	8b 45 f4             	mov    -0xc(%ebp),%eax
 425:	8d 50 01             	lea    0x1(%eax),%edx
 428:	89 55 f4             	mov    %edx,-0xc(%ebp)
 42b:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 430:	eb 1d                	jmp    44f <printint+0xa3>
    putc(fd, buf[i]);
 432:	8d 55 dc             	lea    -0x24(%ebp),%edx
 435:	8b 45 f4             	mov    -0xc(%ebp),%eax
 438:	01 d0                	add    %edx,%eax
 43a:	0f b6 00             	movzbl (%eax),%eax
 43d:	0f be c0             	movsbl %al,%eax
 440:	83 ec 08             	sub    $0x8,%esp
 443:	50                   	push   %eax
 444:	ff 75 08             	push   0x8(%ebp)
 447:	e8 3d ff ff ff       	call   389 <putc>
 44c:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 44f:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 453:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 457:	79 d9                	jns    432 <printint+0x86>
}
 459:	90                   	nop
 45a:	90                   	nop
 45b:	c9                   	leave  
 45c:	c3                   	ret    

0000045d <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 45d:	55                   	push   %ebp
 45e:	89 e5                	mov    %esp,%ebp
 460:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 463:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 46a:	8d 45 0c             	lea    0xc(%ebp),%eax
 46d:	83 c0 04             	add    $0x4,%eax
 470:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 473:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 47a:	e9 59 01 00 00       	jmp    5d8 <printf+0x17b>
    c = fmt[i] & 0xff;
 47f:	8b 55 0c             	mov    0xc(%ebp),%edx
 482:	8b 45 f0             	mov    -0x10(%ebp),%eax
 485:	01 d0                	add    %edx,%eax
 487:	0f b6 00             	movzbl (%eax),%eax
 48a:	0f be c0             	movsbl %al,%eax
 48d:	25 ff 00 00 00       	and    $0xff,%eax
 492:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 495:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 499:	75 2c                	jne    4c7 <printf+0x6a>
      if(c == '%'){
 49b:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 49f:	75 0c                	jne    4ad <printf+0x50>
        state = '%';
 4a1:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4a8:	e9 27 01 00 00       	jmp    5d4 <printf+0x177>
      } else {
        putc(fd, c);
 4ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4b0:	0f be c0             	movsbl %al,%eax
 4b3:	83 ec 08             	sub    $0x8,%esp
 4b6:	50                   	push   %eax
 4b7:	ff 75 08             	push   0x8(%ebp)
 4ba:	e8 ca fe ff ff       	call   389 <putc>
 4bf:	83 c4 10             	add    $0x10,%esp
 4c2:	e9 0d 01 00 00       	jmp    5d4 <printf+0x177>
      }
    } else if(state == '%'){
 4c7:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4cb:	0f 85 03 01 00 00    	jne    5d4 <printf+0x177>
      if(c == 'd'){
 4d1:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4d5:	75 1e                	jne    4f5 <printf+0x98>
        printint(fd, *ap, 10, 1);
 4d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4da:	8b 00                	mov    (%eax),%eax
 4dc:	6a 01                	push   $0x1
 4de:	6a 0a                	push   $0xa
 4e0:	50                   	push   %eax
 4e1:	ff 75 08             	push   0x8(%ebp)
 4e4:	e8 c3 fe ff ff       	call   3ac <printint>
 4e9:	83 c4 10             	add    $0x10,%esp
        ap++;
 4ec:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4f0:	e9 d8 00 00 00       	jmp    5cd <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 4f5:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 4f9:	74 06                	je     501 <printf+0xa4>
 4fb:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 4ff:	75 1e                	jne    51f <printf+0xc2>
        printint(fd, *ap, 16, 0);
 501:	8b 45 e8             	mov    -0x18(%ebp),%eax
 504:	8b 00                	mov    (%eax),%eax
 506:	6a 00                	push   $0x0
 508:	6a 10                	push   $0x10
 50a:	50                   	push   %eax
 50b:	ff 75 08             	push   0x8(%ebp)
 50e:	e8 99 fe ff ff       	call   3ac <printint>
 513:	83 c4 10             	add    $0x10,%esp
        ap++;
 516:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 51a:	e9 ae 00 00 00       	jmp    5cd <printf+0x170>
      } else if(c == 's'){
 51f:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 523:	75 43                	jne    568 <printf+0x10b>
        s = (char*)*ap;
 525:	8b 45 e8             	mov    -0x18(%ebp),%eax
 528:	8b 00                	mov    (%eax),%eax
 52a:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 52d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 531:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 535:	75 25                	jne    55c <printf+0xff>
          s = "(null)";
 537:	c7 45 f4 2a 08 00 00 	movl   $0x82a,-0xc(%ebp)
        while(*s != 0){
 53e:	eb 1c                	jmp    55c <printf+0xff>
          putc(fd, *s);
 540:	8b 45 f4             	mov    -0xc(%ebp),%eax
 543:	0f b6 00             	movzbl (%eax),%eax
 546:	0f be c0             	movsbl %al,%eax
 549:	83 ec 08             	sub    $0x8,%esp
 54c:	50                   	push   %eax
 54d:	ff 75 08             	push   0x8(%ebp)
 550:	e8 34 fe ff ff       	call   389 <putc>
 555:	83 c4 10             	add    $0x10,%esp
          s++;
 558:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 55c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 55f:	0f b6 00             	movzbl (%eax),%eax
 562:	84 c0                	test   %al,%al
 564:	75 da                	jne    540 <printf+0xe3>
 566:	eb 65                	jmp    5cd <printf+0x170>
        }
      } else if(c == 'c'){
 568:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 56c:	75 1d                	jne    58b <printf+0x12e>
        putc(fd, *ap);
 56e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 571:	8b 00                	mov    (%eax),%eax
 573:	0f be c0             	movsbl %al,%eax
 576:	83 ec 08             	sub    $0x8,%esp
 579:	50                   	push   %eax
 57a:	ff 75 08             	push   0x8(%ebp)
 57d:	e8 07 fe ff ff       	call   389 <putc>
 582:	83 c4 10             	add    $0x10,%esp
        ap++;
 585:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 589:	eb 42                	jmp    5cd <printf+0x170>
      } else if(c == '%'){
 58b:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 58f:	75 17                	jne    5a8 <printf+0x14b>
        putc(fd, c);
 591:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 594:	0f be c0             	movsbl %al,%eax
 597:	83 ec 08             	sub    $0x8,%esp
 59a:	50                   	push   %eax
 59b:	ff 75 08             	push   0x8(%ebp)
 59e:	e8 e6 fd ff ff       	call   389 <putc>
 5a3:	83 c4 10             	add    $0x10,%esp
 5a6:	eb 25                	jmp    5cd <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5a8:	83 ec 08             	sub    $0x8,%esp
 5ab:	6a 25                	push   $0x25
 5ad:	ff 75 08             	push   0x8(%ebp)
 5b0:	e8 d4 fd ff ff       	call   389 <putc>
 5b5:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 5b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5bb:	0f be c0             	movsbl %al,%eax
 5be:	83 ec 08             	sub    $0x8,%esp
 5c1:	50                   	push   %eax
 5c2:	ff 75 08             	push   0x8(%ebp)
 5c5:	e8 bf fd ff ff       	call   389 <putc>
 5ca:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 5cd:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 5d4:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 5d8:	8b 55 0c             	mov    0xc(%ebp),%edx
 5db:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5de:	01 d0                	add    %edx,%eax
 5e0:	0f b6 00             	movzbl (%eax),%eax
 5e3:	84 c0                	test   %al,%al
 5e5:	0f 85 94 fe ff ff    	jne    47f <printf+0x22>
    }
  }
}
 5eb:	90                   	nop
 5ec:	90                   	nop
 5ed:	c9                   	leave  
 5ee:	c3                   	ret    

000005ef <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5ef:	55                   	push   %ebp
 5f0:	89 e5                	mov    %esp,%ebp
 5f2:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5f5:	8b 45 08             	mov    0x8(%ebp),%eax
 5f8:	83 e8 08             	sub    $0x8,%eax
 5fb:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5fe:	a1 d4 0a 00 00       	mov    0xad4,%eax
 603:	89 45 fc             	mov    %eax,-0x4(%ebp)
 606:	eb 24                	jmp    62c <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 608:	8b 45 fc             	mov    -0x4(%ebp),%eax
 60b:	8b 00                	mov    (%eax),%eax
 60d:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 610:	72 12                	jb     624 <free+0x35>
 612:	8b 45 f8             	mov    -0x8(%ebp),%eax
 615:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 618:	77 24                	ja     63e <free+0x4f>
 61a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 61d:	8b 00                	mov    (%eax),%eax
 61f:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 622:	72 1a                	jb     63e <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 624:	8b 45 fc             	mov    -0x4(%ebp),%eax
 627:	8b 00                	mov    (%eax),%eax
 629:	89 45 fc             	mov    %eax,-0x4(%ebp)
 62c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 62f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 632:	76 d4                	jbe    608 <free+0x19>
 634:	8b 45 fc             	mov    -0x4(%ebp),%eax
 637:	8b 00                	mov    (%eax),%eax
 639:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 63c:	73 ca                	jae    608 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 63e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 641:	8b 40 04             	mov    0x4(%eax),%eax
 644:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 64b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 64e:	01 c2                	add    %eax,%edx
 650:	8b 45 fc             	mov    -0x4(%ebp),%eax
 653:	8b 00                	mov    (%eax),%eax
 655:	39 c2                	cmp    %eax,%edx
 657:	75 24                	jne    67d <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 659:	8b 45 f8             	mov    -0x8(%ebp),%eax
 65c:	8b 50 04             	mov    0x4(%eax),%edx
 65f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 662:	8b 00                	mov    (%eax),%eax
 664:	8b 40 04             	mov    0x4(%eax),%eax
 667:	01 c2                	add    %eax,%edx
 669:	8b 45 f8             	mov    -0x8(%ebp),%eax
 66c:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 66f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 672:	8b 00                	mov    (%eax),%eax
 674:	8b 10                	mov    (%eax),%edx
 676:	8b 45 f8             	mov    -0x8(%ebp),%eax
 679:	89 10                	mov    %edx,(%eax)
 67b:	eb 0a                	jmp    687 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 67d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 680:	8b 10                	mov    (%eax),%edx
 682:	8b 45 f8             	mov    -0x8(%ebp),%eax
 685:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 687:	8b 45 fc             	mov    -0x4(%ebp),%eax
 68a:	8b 40 04             	mov    0x4(%eax),%eax
 68d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 694:	8b 45 fc             	mov    -0x4(%ebp),%eax
 697:	01 d0                	add    %edx,%eax
 699:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 69c:	75 20                	jne    6be <free+0xcf>
    p->s.size += bp->s.size;
 69e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a1:	8b 50 04             	mov    0x4(%eax),%edx
 6a4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a7:	8b 40 04             	mov    0x4(%eax),%eax
 6aa:	01 c2                	add    %eax,%edx
 6ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6af:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6b2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b5:	8b 10                	mov    (%eax),%edx
 6b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ba:	89 10                	mov    %edx,(%eax)
 6bc:	eb 08                	jmp    6c6 <free+0xd7>
  } else
    p->s.ptr = bp;
 6be:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c1:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6c4:	89 10                	mov    %edx,(%eax)
  freep = p;
 6c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c9:	a3 d4 0a 00 00       	mov    %eax,0xad4
}
 6ce:	90                   	nop
 6cf:	c9                   	leave  
 6d0:	c3                   	ret    

000006d1 <morecore>:

static Header*
morecore(uint nu)
{
 6d1:	55                   	push   %ebp
 6d2:	89 e5                	mov    %esp,%ebp
 6d4:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6d7:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6de:	77 07                	ja     6e7 <morecore+0x16>
    nu = 4096;
 6e0:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 6e7:	8b 45 08             	mov    0x8(%ebp),%eax
 6ea:	c1 e0 03             	shl    $0x3,%eax
 6ed:	83 ec 0c             	sub    $0xc,%esp
 6f0:	50                   	push   %eax
 6f1:	e8 7b fc ff ff       	call   371 <sbrk>
 6f6:	83 c4 10             	add    $0x10,%esp
 6f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 6fc:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 700:	75 07                	jne    709 <morecore+0x38>
    return 0;
 702:	b8 00 00 00 00       	mov    $0x0,%eax
 707:	eb 26                	jmp    72f <morecore+0x5e>
  hp = (Header*)p;
 709:	8b 45 f4             	mov    -0xc(%ebp),%eax
 70c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 70f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 712:	8b 55 08             	mov    0x8(%ebp),%edx
 715:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 718:	8b 45 f0             	mov    -0x10(%ebp),%eax
 71b:	83 c0 08             	add    $0x8,%eax
 71e:	83 ec 0c             	sub    $0xc,%esp
 721:	50                   	push   %eax
 722:	e8 c8 fe ff ff       	call   5ef <free>
 727:	83 c4 10             	add    $0x10,%esp
  return freep;
 72a:	a1 d4 0a 00 00       	mov    0xad4,%eax
}
 72f:	c9                   	leave  
 730:	c3                   	ret    

00000731 <malloc>:

void*
malloc(uint nbytes)
{
 731:	55                   	push   %ebp
 732:	89 e5                	mov    %esp,%ebp
 734:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 737:	8b 45 08             	mov    0x8(%ebp),%eax
 73a:	83 c0 07             	add    $0x7,%eax
 73d:	c1 e8 03             	shr    $0x3,%eax
 740:	83 c0 01             	add    $0x1,%eax
 743:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 746:	a1 d4 0a 00 00       	mov    0xad4,%eax
 74b:	89 45 f0             	mov    %eax,-0x10(%ebp)
 74e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 752:	75 23                	jne    777 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 754:	c7 45 f0 cc 0a 00 00 	movl   $0xacc,-0x10(%ebp)
 75b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 75e:	a3 d4 0a 00 00       	mov    %eax,0xad4
 763:	a1 d4 0a 00 00       	mov    0xad4,%eax
 768:	a3 cc 0a 00 00       	mov    %eax,0xacc
    base.s.size = 0;
 76d:	c7 05 d0 0a 00 00 00 	movl   $0x0,0xad0
 774:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 777:	8b 45 f0             	mov    -0x10(%ebp),%eax
 77a:	8b 00                	mov    (%eax),%eax
 77c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 77f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 782:	8b 40 04             	mov    0x4(%eax),%eax
 785:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 788:	77 4d                	ja     7d7 <malloc+0xa6>
      if(p->s.size == nunits)
 78a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 78d:	8b 40 04             	mov    0x4(%eax),%eax
 790:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 793:	75 0c                	jne    7a1 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 795:	8b 45 f4             	mov    -0xc(%ebp),%eax
 798:	8b 10                	mov    (%eax),%edx
 79a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 79d:	89 10                	mov    %edx,(%eax)
 79f:	eb 26                	jmp    7c7 <malloc+0x96>
      else {
        p->s.size -= nunits;
 7a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a4:	8b 40 04             	mov    0x4(%eax),%eax
 7a7:	2b 45 ec             	sub    -0x14(%ebp),%eax
 7aa:	89 c2                	mov    %eax,%edx
 7ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7af:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b5:	8b 40 04             	mov    0x4(%eax),%eax
 7b8:	c1 e0 03             	shl    $0x3,%eax
 7bb:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7be:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c1:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7c4:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ca:	a3 d4 0a 00 00       	mov    %eax,0xad4
      return (void*)(p + 1);
 7cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d2:	83 c0 08             	add    $0x8,%eax
 7d5:	eb 3b                	jmp    812 <malloc+0xe1>
    }
    if(p == freep)
 7d7:	a1 d4 0a 00 00       	mov    0xad4,%eax
 7dc:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7df:	75 1e                	jne    7ff <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 7e1:	83 ec 0c             	sub    $0xc,%esp
 7e4:	ff 75 ec             	push   -0x14(%ebp)
 7e7:	e8 e5 fe ff ff       	call   6d1 <morecore>
 7ec:	83 c4 10             	add    $0x10,%esp
 7ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7f2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7f6:	75 07                	jne    7ff <malloc+0xce>
        return 0;
 7f8:	b8 00 00 00 00       	mov    $0x0,%eax
 7fd:	eb 13                	jmp    812 <malloc+0xe1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
 802:	89 45 f0             	mov    %eax,-0x10(%ebp)
 805:	8b 45 f4             	mov    -0xc(%ebp),%eax
 808:	8b 00                	mov    (%eax),%eax
 80a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 80d:	e9 6d ff ff ff       	jmp    77f <malloc+0x4e>
  }
}
 812:	c9                   	leave  
 813:	c3                   	ret    
