---
layout: default
title: TamilCTF 2021
nav_order: 6
description: "Tamil CTF 2021"
permalink: /ctfs/tamilctf21
has_children: false
parent: CTF List
last_modified_date: 30-09-2021 10:32 AM +0530
---

# Tamil CTF 2021
{: .no_toc}
TamilCTF 2021 is the first CTF conducted by the Tamil Infosec community. This CTF competition is spear headed
by [tamilctf.com][1]. This being their first CTF hosting, I expected the challenges to be a bit lenient and 
easy to solve. But they were all high quality challenges and I could only attempt a meagre three challenges.   
{: .fs-5 .fw-300 }

The rules made it clear that the flags are of the format **`TamilCTF{...}`**.
{: .fs-5 .fw-300 }

## Challenge list
{: .no_toc .text-delta}

1. TOC
{:toc}


## Babymisc 🗂
Miscellaneous
{: .label .label-green .fs-1 .ml-0}

This was an interesting first challenge where in we are given a single file and the flag is guaranteed to be 
hidden within it. The file given to us can be downloaded from [here][2].  

On downloading the file, it is seen that the file is detected as a PDF by the file explorer in Linux and can also
be opened in a PDF viewer which contains a flag like text **`TamilCTF{challenge_is_awesome}`**. It was very clear
that there was much more to the challenge than this.  

As customary for any file related challenge, I ran **`exiftool`** followed by **`files`** and **`binwalk`**. The
**`binwalk`** command did the trick and the below was the output when ran against this file.  
```sh
┌──(cryptonic㉿cryptonic-kali)-[~/CTFs/tamilctf/babymisc]
└─$ binwalk Babymisc 

DECIMAL       HEXADECIMAL     DESCRIPTION
--------------------------------------------------------------------------------
0             0x0             PDF document, version: "1.6"
70            0x46            Zip archive data, at least v1.0 to extract, compressed size: 29, uncompressed size: 29, name: 10.pdf.txt
167           0xA7            Zip archive data, at least v1.0 to extract, compressed size: 29, uncompressed size: 29, name: 11.pdf.txt
264           0x108           Zip archive data, at least v1.0 to extract, compressed size: 31, uncompressed size: 31, name: 12.pdf.txt
363           0x16B           Zip archive data, at least v1.0 to extract, compressed size: 9, uncompressed size: 9, name: 13.pdf.txt
440           0x1B8           Zip archive data, at least v1.0 to extract, compressed size: 13, uncompressed size: 13, name: 1.pdf.txt
520           0x208           Zip archive data, at least v1.0 to extract, compressed size: 15, uncompressed size: 15, name: 2.pdf.txt
602           0x25A           Zip archive data, at least v2.0 to extract, compressed size: 51, uncompressed size: 54, name: 3.pdf.txt
720           0x2D0           Zip archive data, at least v2.0 to extract, compressed size: 49, uncompressed size: 52, name: 4.pdf.txt
836           0x344           Zip archive data, at least v1.0 to extract, compressed size: 17, uncompressed size: 17, name: 5.pdf.txt
920           0x398           Zip archive data, at least v1.0 to extract, compressed size: 36, uncompressed size: 36, name: 6.pdf.txt
1023          0x3FF           Zip archive data, at least v1.0 to extract, compressed size: 42, uncompressed size: 42, name: 7.pdf.txt
1132          0x46C           Zip archive data, at least v1.0 to extract, compressed size: 48, uncompressed size: 48, name: 8.pdf.txt
1247          0x4DF           Zip archive data, at least v1.0 to extract, compressed size: 13, uncompressed size: 13, name: 9.pdf.txt
2296          0x8F8           Zlib compressed data, default compression
9267          0x2433          Zlib compressed data, default compression
9644          0x25AC          Zlib compressed data, default compression
10949         0x2AC5          End of Zip archive, footer length: 22
```  

As **`binwalk`** detected both start of Zip magic bytes and End of Zip magic bytes, it was very clear that there is 
a zip file hidden within the given PDF format file. Also the above output suggests that the first Zip header is seen
at an offset of 70 bytes from the start of the file.  

I already have a handy command **`cutbytesrange 70 11348 Babymisc babymisc_fzip.zip`** defined in my aliases as such
file manipulation is very often required in CTF challenges. The **`cusbytesrange`** is a custom alias defined by me.
The code for this alias is available below:
```sh
cutbytesrange() {
  if [ "$#" -ne 4 ]; then
    echo "4 arguments expected in order - start_byte_val, end_byte_val(excluding), input_file, op_file"
  else
    num_bytes="$(($2-$1))"
    dd bs=$num_bytes count=1 iflag=skip_bytes skip=$1 if=$3 of=$4
  fi
}
```  

The function basically uses the **`dd`** command and rewrites the range of bytes from 70 - 11348 to a new file where
the total file size of the original file is 11348 bytes. As expected this turned out to be a valid **`zip`** file 
which on extracting gave a set of 13 text files.  

On opening each of them, particularly three text files had content which resembled parts of Base64 encoded strings 
whereas the others had decoy strings.  

The three Base64 encoded strings are given below:  
```text
VGFtaWxDVEYKe1IzdjNyU0VyCg==
X21BazNfQQo=
TTFzQ30K
```  

The Base64 decoded content of the above are given below: 
```text
TamilCTF
{R3v3rSEr

_mAk3_A

M1sC}
```  

Removing spaces and concatenating the strings gives us our final flag **`TamilCTF{R3v3rSEr_mAk3_AM1sC}`**.  


## Betacap 🦈
Forensics
{: .label .label-green .fs-1 .ml-0}

First in the forensics challenge, this was a bit tricky than I expected but had clues hidden in the
logical manner to proceed with the challenge. As the name suggests we are provided with the zip of
a network capture file which can be downloaded from [here][3].  

Extracting the zip as expected gave a **`.pcapng`** file which I immediately opened up in 
[**`Wireshark`**][4]. It opened up the complete request streams.  

To get a high level view of the packet capture, we first check the the capture file properties and
protocol hierarchy under the **`Statistics`** top level menu. The protocol hierarchy shows that there
are few HTTP requests and some specific responses with MediaType packets.  

As most of the data transfer happens in HTTP layer, we filter the packets by HTTP and then inspect one
by one. As shown in the below screenshot our inspection shows that there are quite a few zip file downloads
that has happened.  

![Zip file image][5]

On inspecting one file at a time, we follow each zip and download the bytes and save them as zip files. Below
is a short video on how to track a file response and save the response as the file. We follow the packet
requesting for the file named **`god.zip`** in frame #1913.  

![Filtering packets][6]  

Similarly there was another request to a url **`PUT /waste`** in frame #7633. The response content on inspecting
seemed like a PNG. So I saved the file as **`waste.png`** a copy of which can be downloaded [here][7]. This file
seemed to be a png as the stream content had the text like **`waste.png`** within it. However when tried to open
it seemed to be a corrupted file. I could confirm this by running **`exiftool`** over the file too.  

As I had hit a roadblock I decided to get back to Wireshark and find any other suspicious files. However I wanted
to just look into the raw contents of the file to see if there was anything of interest. So running **`cat waste.png`**
dumped the raw contents to the terminal.  

Voila 🪄 !! That gave me a distinct hexadecimal string hidden within the file as seen below.  
(Note: Contents truncated due to brevity)  
```text
pjQz..c...$..!WF.4..w..;5.....`.'......&
.y$.....5~.-.p..)..E...l.1=...@.u..l..V.'.8....V....n.....k...S.Q.....&..........z.N..[....v..wd...'...F...Y.8N...+W.V...u.;..h.|.p3.Q.....kD...u.........._..}..@3....2.tB..G.N.D.....5.n.+6[B."^h.....F7.9...mp4$.Ep.6..F...O...!.N...W..Sn......]..b..9=...8...s....W	!.+..1...,.|...1.....)X.LD93kHB..r....S\-..(........_....z.5.E../...r)..@.".9.1,
........!.T.S....KAi...<..(........E._...1.-.....s.;..t5...53b.@.r.bX.L.5A{54616d696c4354467b6c69746572616c6c795f695f686174655f796f755f61745f616c6c7d0a}....6..y...L1....GFh.S.@.r.bX.L\q.`....Oq'...uE.....".4DZr.bX.L|....,.EaU.h..Ff..o.....O..R.!
9/1,
&.9....M..%..D..J....n....!.8.1,
&!8.h..EQ..)q;.kSI....fG...1.....Q`.9..(.K.s.N...O.@_..	.Di.2.QU.+.....N..g....9.JMM}..K.Jt$....<."..e.....Hr.c........gvU.(?}.5..g..(w4....!Q...^....'.g.A....2....@s@G.	p....O.=D<E.F$.#.Lb.Q.	...S.?%.DM....,. .{6..^.6?......"-fgj1<Y.......m...~.a...:...E,&v..Y...Y."..].X..d.k^J.iR..........X..].....p.i...G..(.4...F.!...>....`Q0.,. ..U..;W....z)	....7X....1..S........h..6f....c... ....6m
...=(f...@+...X..%...|....R.9.'.M..u....q...#
.:.<.>.@.B.D.F.....*mc.
```  

The hex string shown below stands out in the contents of the file.
```text
54616d696c4354467b6c69746572616c6c795f695f686174655f796f755f61745f616c6c7d0a
```

Converting this hex to a string using any tool gives us the final flag **`TamilCTF{literally_i_hate_you_at_all}`**.  


## Dark night 🦇
Miscellaneous
{: .label .label-green .fs-1 .ml-0}

This was a relatively easy challenge that had a natural progression of solving. In this challenge we are provided
with a zip file which can be downloaded from [here][8]. This is all we have to obtain our flag.  

We unzip the file and find that it contains only a single pdf file **`dark_night.pdf`**. Opening the file we
find that there are lot of black background texts which seemed to hide data. Also as text can be hidden by
selecting foreground and background colors to be the same, I used the **`Select all`** option to highlight all the
text available in the pdf. This revealed way more content in the pdf.  

After selecting all the text I skimmed through the hidden text to find a line which contained the below:  
```text
84 97 109 105 108 67 84 70 123 49 95 108 48 118 51 95 98 98 52 52 116 116 95 109 97 110 125
```  

![Selected text pdf][9]  

As all these numbers seemed to be in the valid ASCII key range represented in decimal format, I quickly converted 
each of the numbers to its ASCII character and concatenating it gave the required flag.  

The final flag was **`TamilCTF{1_l0v3_bb44tt_man}`**.


[1]: https://tamilctf.com/
[2]: https://mega.nz/file/BtwVwQ4C#zOKDQkVZMrwXJPq629vTE4ngwdQl21YJMUOc3b2Vf6I
[3]: https://mega.nz/file/AkxnjAiJ#Qn5ftyG-vwcFM4MuhkvGH15E1etVq9iCtDHarAF2mvA
[4]: ../ctftools/wireshark
[5]: https://gcdn.pbrd.co/images/cy2qgQeeNYep.png?o=1
[6]: https://gcdn.pbrd.co/images/0EawEE1tqYWd.gif?o=1
[7]: https://mega.nz/file/d8gGDIIA#n9YLPtxzyZbwoN8yboZoNmTiyTFn-tglZXCe_mBwgaM
[8]: https://mega.nz/file/805GkSiZ#8ZZc936VgLRNImF9jHsWaiAAzJqZYQB3QDtk6eNCB6E
[9]: https://gcdn.pbrd.co/images/x5s6pDvonNsf.png?o=1