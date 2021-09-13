---
layout: default
title: GrabCON 2021
nav_order: 1
description: "GrabCON 2021 CTF solves"
permalink: /ctfs/grabcon21
has_children: false
parent: CTF list
---

# GrabCON 2021
{: .no_toc}
The GrabCON 2021 is a [CyberGrabs][1] event organized as an yearly event. This year's GrabCON had a variety of high quality
challenges including many categories. The discord invite link is available [here][2] and some of the challenge solves is
discussed in the discord community.
{: .fs-5 .fw-300 }

I would be highlighting the solves for challenges that I attempted and/or solved.
{: .fs-5 .fw-300 }

From the rules and the welcome challenge it was clear that the flags were always of the format **`GrabCON{...}`**. The
welcome flag was **`GrabCON{welcome_to_grabcon_2021}`**.
{: .fs-5 .fw-300 }

## Challenge list
{: .no_toc .text-delta}

1. TOC
{:toc}

## Youtube 📹
Miscellaneous
{: .label .label-green .fs-1 .ml-0}

This was a warmup challenge. This challenge gave the below hint:  
> Find us on Youtube

With this clue it was clear that the flag was either part of the video content or comments/description section of their
youtube videos.

So heading over to their [channel][3] we could see that there are only three published videos. Inspecting the obvious
aspects of these videos like comments, description etc, I noticed the below:

1. [Video 1][4] had the text **`0v3r_th3_lazy_d0g}`** in its extended description visible after clicking on the *Show more*
button. This looks like the last part of the flag as it ends in a `'}'`.
2. [Video 2][5] had the text **`br0wn_f0x_jumps_`**, again in its extended description which looks like some part of the flag.
3. And a third video (now delisted from YouTube) which contained the first part of the flag **`GrabCON{the_quick_`**.

Putting these three together we get the real flag **`GrabCON{the_quick_br0wn_f0x_jumps_0v3r_th3_lazy_d0g}`**.

## Discord 💬
Miscellaneous
{: .label .label-green .fs-1 .ml-0}

This challenge asked us to join their discord server. In general discord related flags are hidden in channel descriptions
or admin descriptions. Here too the flag was available within the description of **`#role`** channel of their discord
server.

The flag was **`GrabCON{s@n1ty_fl4g_1s_here}`**.

## Find me 🕵
Miscellaneous
{: .label .label-green .fs-1 .ml-0}

This challenge had the below clue in its challenge description:
> Checkout author's social media with the author name Offen5ive

On looking more for Offen5ive's twitter account etc. found the link https://offen5ive.me which pointed to all social media
urls of the author. It contained a GitHub account too which was https://github.com/offen5ive.

On looking more into the recent commits found the below repository - https://github.com/offen5ive/offensive.me
The **README** file of this repository showed a decoy flag **`GrabCON{n0_fl4g_h3r3}`** which obviously was not the
flag. But on fiddling through the GitHub commit history for some time, found [this][6] commit link which showed the changeset.
The changeset did show the flag **`GrabCON{1_w4s_hid33n_but_y0u_f0und_m3}`**.

## Easy reversing ⏪
Reversing
{: .label .label-green .fs-1 .ml-0}

This was a basic reversing challenge with the challenge text **Easy reversing** and a file download with the name **`baby_re_2`**.
The same can be downloaded [here][7] or [here][8].

As this is a reversing challenge the crux lies in understanding the logic of the binary. A quick use of `binwalk` command shows that
it is an ELF (Executable Linux Format) binary. This means we can use both GDB(GNU debugger) and Ghidra tool to reverse the binary.

Loading the binary in Ghidra shows that the binary expects a command line argument equal to highlighted hex value as shown below.  
![Checks for value 0x140685](https://gcdn.pbrd.co/images/0gfjhniCIYF2.png "Easy reverse code snippet") 

As all inputs are in decimal we convert the value to decimal and run the binary with the input **`1312389`**. Doing so the flag is
printed out in the command line as: **`GrabCON{y0u_g0t_it_8bb31}`**.

![Easy rev in action][20]

## Gangbusted 📦
Forensics
{: .label .label-green .fs-1 .ml-0}

This is a forensics challenge where the flag description is given elaborately as below along with the link to a challenge file.
The same can be downloaded from [here][11] or [here][12].

Challenge instructions:  
> Hi Everyone! We have recently busted one of the member of a gang and they were plotting something suspicious. They were discussing
> on one of the popular social media platform we need you to find some information for us.
>   1. Social Media Platform they were using. For example : **Facebook**  
>   2. Email used by that member. For example : **wolf@domain.com**  
>   3. What was the group name. For example : **Very Secret Plot**  
>   4. What was the name of the gang member : **bob chan**  
> 
> **`GrabCON{Facebook_wolf@domain.com_Very_Secret_Plot_bob_chan}`**

On analyzing the zip file with **`unzip -l <zip-file-name>`** it is seen that the zip file looks like an Android file system.
Also the file list had lot of entries for **`Skype`** app files which made it the prime suspect for the social media platform.
Suspecting *Skype* I decided to confirm my doubt by poking more into the files of this app. Also it is a well known fact that
all Android apps store data in **`SQLite`** DB.  

So next I started probing into the **`.db`** files of *Skype* app. SQLite DB files can be easily viewed using [DB Browser][13].

Probing multiple DB files finally the specific DB file listed below had all the other required details:  
`data/com.skype.raider/databases/s4l-live:.cid.6c41bc4408002e1f.db`  

Final details include the below:

| S.No | Information           | Value               |
| ---: | :-------------------- | :------------------ |
|    1 | Social media platform | Skype               |
|    2 | Email used            | sidemaf155@5ubo.com |
|    3 | Group name            | 31337_Hax0r_Plan    |
|    4 | Name of gange member  | evil mike           |

The flag formed based on the above details is **`GrabCON{Skype_sidemaf155@5ubo.com_31337_Hax0r_Plan_evil_mike}`**.

## Tampered 📦
Forensics
{: .label .label-green .fs-1 .ml-0}

This is another forensics challenge which I could reach very close but missed solving as I was stuck in a single line of thought
missing one piece of information. The challenge had the mentioned flag description and a file which can be downloaded from
[here][14] or [here][15].

Challenge instructions:
> In our company we caught one of the employee tampering a file so we took a some backup from his computer and 
> now we need your help to figure few things.
>   1. Name of the new file which our employee was tampering. Example : **important note.txt**
>   2. Which tool he was using ? Example : **random.exe**
>   3. What was the changed timestamp on the new file? Example : **2001-01-27_23:12:56** (YYYY-MM-DD)
>   4. Content inside the file? Example : **e977656fea7ea5b9a8887ecf730860af**
>  
> Example Flag : **`GrabCON{important_note.txt_random.exe_2001-01-27_23:12:56_e977656fea7ea5b9a8887ecf730860af}`**

The challenge file is a zip which when listed for files gives a single file named **`grab2.E01`**. As I had no idea on what file it was
I started off by using **`binwalk`** tool to list all the known file signatures found in the file. This started listing an almost
not ending list of file signatures as seen below:

```sh
┌──(cryptonic㉿cryptonic-kali)-[~/CTFs/grabcon/tampered]
└─$ binwalk grab2.E01 
DECIMAL       HEXADECIMAL     DESCRIPTION
-----------------------------------------------------------------------
89            0x59            Zlib compressed data, default compression
259           0x103           Zlib compressed data, default compression
1557          0x615           Zlib compressed data, default compression
22533         0x5805          Zlib compressed data, default compression
52161         0xCBC1          Zlib compressed data, default compression
81805         0x13F8D         Zlib compressed data, default compression
111551        0x1B3BF         Zlib compressed data, default compression
127816        0x1F348         Zlib compressed data, default compression
131259        0x200BB         Zlib compressed data, default compression
....
....
```

This made me think whether the output is really valid and on exploring a bit more on **`binwalk`** found that the tool mostly analyzes
well known magic sequence bytes and reports every address from where the magic bytes match for a specific signature. So this made me
poke the file more as I understood that the file had some other signature which was not being detected by **`binwalk`**

Next I headed over to **`hexdump`** utility to analyze the first few bytes of the file so as to see the raw bytes which usually make up
the file magic bytes.

```sh
┌──(cryptonic㉿cryptonic-kali)-[~/CTFs/grabcon/tampered]
└─$ hexdump -C grab2.E01 | head -10                               
00000000  45 56 46 09 0d 0a ff 00  01 01 00 00 00 68 65 61  |EVF..........hea|
00000010  64 65 72 00 00 00 00 00  00 00 00 00 00 b7 00 00  |der.............|
00000020  00 00 00 00 00 aa 00 00  00 00 00 00 00 00 00 00  |................|
00000030  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
00000050  00 00 00 00 00 cb 03 97  ef 78 9c 6d c8 41 0a 80  |.........x.m.A..|
00000060  20 10 05 d0 f5 f7 14 73  02 99 d1 ac b6 41 9b 4e  | ......s.....A.N|
00000070  d0 5a ca 40 48 8b d0 e8  f8 d1 be e5 7b a2 92 8f  |.Z.@H.......{...|
00000080  59 2d c8 f0 08 28 f0 37  8e 1b 09 15 27 2e 45 20  |Y-...(.7....'.E |
00000090  d4 5c 62 d9 c3 8a 0f c3  38 35 da 69 d6 16 73 cc  |.\b.....85.i..s.|
```

As seen in the output of the command, the magic bytes point to the header **`EVF..........header`**. This seemed to
be some good information. On searching for EVF as a header in the Web it lead me to the discovery that **`EVF`**
stands for **Expert Witness Disk Image** which is generally used to take secure backup of a specific machine which 
has been subject to an attack so as to perform forensic analysis later.

So next was to be able to load/mount the image. Again I presumed this to be a linux box image and so I tried to 
find linux based tools for mounting EVF files. During this search I stumbled upon [this][16] link which explained
on the installation and usage of **`ewf-tools`**.

Followed the steps mentioned to find details of the image using **`ewfinfo`** command and it showed the below details:
```sh
┌──(cryptonic㉿cryptonic-kali)-[~/CTFs/grabcon/tampered]
└─$ ewfinfo grab2.E01
ewfinfo 20140807

Acquiry information
	Case number:		 
	Description:		untitled
	Examiner name:		 
	Evidence number:	 
	Notes:			 
	Acquisition date:	Tue Aug 31 10:56:37 2021
	System date:		Tue Aug 31 10:56:37 2021
	Operating system used:	Win 201x
	Software version used:	ADI4.5.0.3
	Password:		N/A

EWF information
	File format:		FTK Imager
	Sectors per chunk:	64
	Compression method:	deflate
	Compression level:	no compression

Media information
	Media type:		fixed disk
	Is physical:		no
	Bytes per sector:	512
	Number of sectors:	4192256
	Media size:		1.9 GiB (2146435072 bytes)

Digest hash information
	MD5:			8583de6967627e81f7f2001ee5931947
	SHA1:			868072e56b981c05433ba0a2175cfaa312ef8207
```

In the above output the **File format** is shown as **FTK Imager** which sounded like some specific tool. On looking
up it did point me towards the [**FTK Imager**][17]. The public details available for this product did not give any
idea as to whether it works on Linux or Windows or both. Also to download this product, we had to register with a
mail id although the product as such is free. I was apprehensive and so continued using ewf-tools to try and mount 
the image.

This proved to be a big mistake. This is because, although I followed the steps mentioned in the blog cited in the 
previous section, I was not able to mount the image. After around 2-3 hours of valuable time, I decided to register
and see available downloads for **`FTK Imager`**.

This revealed that the software is available only for Windows installation as an **exe** which means the image is
also of a Windows machine. So I quickly jumped onto a Windows box and installed **`FTK Imager`** which allowed me
to mount the file as a drive in my Windows box.

Voila 🪄 !! I was able to look into the files and folders as if the image was a normal drive. On quickly scanning
I could find the file inside a backup of **`Mozilla firefox`** with the name **`don't open it.hidden`**. This clearly
shows this was the file. On checking the file properties I could see that the modified date was totally busted as
it was showing the same as **10th August 1969, 10:03:33PM**. Also the contents of the file was readily available.

The last piece of the puzzle was the name of the software/tool used by employee to tamper the file. But I
misunderstood it as the tool used to gain access to the machine. I know its a lot different but in the heat of things
I totally misunderstood. Due to this I got stuck in looking into the Mozilla browser history files, cookies and
browsing history data present inside the image.

But ideally the thought process should have been that, such a modification is not possible from the GUI in Windows.
This means the adversary has used some tool via a command line to execute the attack. So looking into the console
history was the right direction.

After performing a simple web search I landed on [this][18] article which clearly showed that the console history
is available in the below path for every user in Windows `C:\Users\%username%\AppData\Roaming\Microsoft\Windows\PowerShell\PSReadline`.
The username we are looking at is **`nick`** which is the only non-default user present in the image.

Navigating to this folder we find a file named **`ConsoleHost_history.txt`** which clearly gives away that the tool
used is **`timestomp.exe`**.

You can go through the below to find the whole process of discovering the required details:
![Image analysis using FTK Imager][19]

Final details include the below:

| S.No | Information       | Value                            |
| ---: | :---------------- | :------------------------------- |
|    1 | File name         | dont't open it.hidden            |
|    2 | Tool used         | timestomp.exe                    |
|    3 | Changed timestamp | 10th August 1969, 10:03:33PM     |
|    4 | Contents of file  | 6b751689f3cdaed05e552eff51115684 |

The final flag after applying the required formatting specified in the challenge instruction is:
**`GrabCON{don't_open_it.hidden_timestomp.exe_1969-08-10_22:03:33_6b751689f3cdaed05e552eff51115684}`**




[1]: https://thecybergrabs.org/grabcon/
[2]: https://discord.gg/8F9VMVCWb2
[3]: https://www.youtube.com/channel/UC_Z36GnY_s8R6_eLvI1R2bg/videos
[4]: https://www.youtube.com/watch?v=lTDs9HMlNvw
[5]: https://www.youtube.com/watch?v=JTrXOS8N9W0
[6]: https://github.com/offen5ive/offensive.me/commit/2d8cbf53b68ba44d151b3db7a60a7f799dcb36f0
[7]: https://ctf.thecybergrabs.org/files/bf79b00cbb0a930b29ef7a34054c751c/baby_re_2?token=eyJ1c2VyX2lkIjo4NDIsInRlYW1faWQiOjQxMSwiZmlsZV9pZCI6MjJ9.YTniBg.3dj5_Z5qBN6rFiew39Wcwrz84Lo
[8]: https://mega.nz/file/JwYGyZpA#MQ8Rf6UukIOj8Xm4AH3trKzSgLqogZB1RUKGNnPEzPo
[9]: https://gcdn.pbrd.co/images/0gfjhniCIYF2.png
[10]: https://asciinema.org/a/pg6Zv7ldafvIYQT6Qu1fZgNdr
[11]: https://storage.googleapis.com/grabcon/forensics/foren1_2.zip
[12]: https://mega.nz/file/ptx2FZ7D#bW5opab193E4DXER63Tm-JSxpfm329ZN9oyE9OLyXoU
[13]: https://sqlitebrowser.org/
[14]: https://storage.googleapis.com/grabcon/forensics/grabcon_dfir.zip
[15]: https://mega.nz/file/dxojEKhA#8n-g4JKmDCPtcA0lLSS8l--JWahVN2fK9w6ugp_Addc
[16]: https://dfir.science/2017/11/EWF-Tools-working-with-Expert-Witness-Files-in-Linux.html
[17]: https://accessdata.com/product-download/ftk-imager-version-4-2-1
[18]: https://itsallinthecode.com/powershell-where-is-the-command-history-stored/
[19]: https://gcdn.pbrd.co/images/GeOx9oNr5O3e.gif?o=1
[20]: https://gcdn.pbrd.co/images/g7OwHQtrLTAe.gif?o=1