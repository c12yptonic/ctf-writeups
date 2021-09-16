---
layout: default
title: Up for a little challenge
nav_order: 3
description: "Find the flag from the challenge file"
permalink: /ctflearn/upforalittlechall
has_children: false
parent: CTF Learn
---

## Up for a Little Challenge ⛳
{: .no_toc}  
Forensics
{: .label .label-green .fs-1 .ml-0}

This is a good starter challenge for forensics that provide us an opening to explore various
tools etc to be used for forensic analysis. The main reason for this is the way the challenge
description is crafted to not give away anything. The challenge instructions are givn below.
We are also provided with a file for this challenge which can be downloaded from [here][1].

Challenge instructions:
> Up For A Little Challenge?  
>
> Link to file
> You Know What To Do ...

This means that everything required for the challenge is available within this file itself.
We go ahead and download the file which gives us a **`jpg`** file by the name **`Begin Hack.jpg`**.  

As this is an image file there are few things that came to my mind which are the general
strategies used to hunt for a flag within an image:
1. **`exiftool`** to analyze the file headers and other details
2. **`string`** to dump any ascii printable coherent strings hidden in the file
3. **`hexdump`** to see if there are any patterns of interest in the file
4. **`gimp`** to load the image and analyze for any hidden layers of the image

Lets now see the results of each of the above steps and see if we get any clue. To start
with we run the **`exiftool`** command and get the below results:
```sh
┌──(cryptonic㉿cryptonic-kali)-[~/CtfLearn/upforalittlechall]
└─$ exiftool Begin\ Hack.jpg                        
ExifTool Version Number         : 12.16
File Name                       : Begin Hack.jpg
Directory                       : .
File Size                       : 21 KiB
File Modification Date/Time     : 2021:08:23 13:04:54+05:30
File Access Date/Time           : 2021:09:15 22:35:24+05:30
File Inode Change Date/Time     : 2021:08:23 13:05:29+05:30
File Permissions                : rw-r--r--
File Type                       : JPEG
File Type Extension             : jpg
MIME Type                       : image/jpeg
JFIF Version                    : 1.01
Exif Byte Order                 : Big-endian (Motorola, MM)
X Resolution                    : 72
Y Resolution                    : 72
Resolution Unit                 : inches
Color Space                     : sRGB
Exif Image Width                : 320
Exif Image Height               : 448
Focal Plane X Resolution        : 72
Focal Plane Y Resolution        : 72
Focal Plane Resolution Unit     : None
Current IPTC Digest             : d41d8cd98f00b204e9800998ecf8427e
IPTC Digest                     : d41d8cd98f00b204e9800998ecf8427e
Image Width                     : 320
Image Height                    : 448
Encoding Process                : Progressive DCT, Huffman coding
Bits Per Sample                 : 8
Color Components                : 3
Y Cb Cr Sub Sampling            : YCbCr4:2:0 (2 2)
Image Size                      : 320x448
Megapixels                      : 0.143
```  

The output of **`exiftool`** commands does not give us much. Its a normal output of
the image headers. We move on to **`strings`** command to extract all the readable
strings present within the hexdump of the image. Find the truncated results below
highlighting the necessary parts:
```sh
┌──(cryptonic㉿cryptonic-kali)-[~/CtfLearn/upforalittlechall]
└─$ strings Begin\ Hack.jpg          
JFIF
Exif
8Photoshop 3.0
8BIM
8BIM
S@%c
&T6d
...
...
...
1exh
1yjyw(
'Trj
`- https://mega.nz/#!z8hACJbb!vQB569ptyQjNEoxIwHrUhwWu5WCj1JWmU-OFjf90Prg -N17hGnFBfJliykJxXu8 -
=u}B
{Y4B
R_:/
/bTK
T8(w
}SPF*
...
...
...
?s$X0?]
4@a4
=reg#
9*fL'
Mp real_unlock_key: Nothing Is As It SeemsU
~t>?
pb}X8a
;>)I$
...
...
...
yDYUE
 password: Really? Again
3oC=
S MWX
lwPBj
XR0W'
@t-%
flag{Not_So_Simple...}
?@};
7b,,*
...
...
...
```

We find some strings of interest which are specifically listed below:
```text
1. `- https://mega.nz/#!z8hACJbb!vQB569ptyQjNEoxIwHrUhwWu5WCj1JWmU-OFjf90Prg -N17hGnFBfJliykJxXu8 -
2. Mp real_unlock_key: Nothing Is As It SeemsU
3. password: Really? Again
4. flag{Not_So_Simple...}
```

On seeing the above, we understand that we have an url, which needs to followed to see if
we get anything important. Followed by a password and few decoy messages.  

Given this background we follow the link to see what we have. The links leads us to a zip file
named **Up For A Little Challenge.zip**. On examining the contents of the zip we can find the 
below contents.  
![Contents of "Up for a little challenge.zip"][2]

Here we find another image file and an unknown hidden file with the name **`.Processing.cerb4`**.
In the interest of knowing what this specific file is, we can run the **`file`** command. The output
of the same can be found below:
```sh
┌──(cryptonic㉿cryptonic-kali)-[~/CtfLearn/upforalittlechall/Did I Forget Again?]
└─$ file .Processing.cerb4 
.Processing.cerb4: Zip archive data, at least v2.0 to extract
```

It clearly shows us this specific file is actually a **`zip`** archive in itself. We inspect the
contents of this file and find the below.
![Contents of hidden zip ".Processing.cerb4"][3]

As seen above, we find an image file **`skypcoder.jpg`** but are requested for a password when
tried to be opened. 

At this point I remembered that we had seen a string from the initial **`Begin Hack.jpg`** which read
as below:  
`Mp real_unlock_key: Nothing Is As It SeemsU`  

I wanted to give the above as a password for this file and check. After quite a few combinations, the
above string without the last character **`U`** worked out and gave me the below image:
![Final skycoder image with flag][4]

If we closely observe all parts of the image, we find that in the bottom right corner of the image, we
have a string of the flag format. Zooming into the image with a good image viewer gives us the final
flag which reads as **`flag{hack_complete}`**.

This was more of a forensic fact finding challenge which did not require much knowledge on specific
tools which is one of the reason I found this more fun to crack.





[1]: https://mega.nz/#!LoABFK5K!0sEKbsU3sBUG8zWxpBfD1bQx_JY_MuYEWQvLrFIqWZ0
[2]: https://gcdn.pbrd.co/images/F7VqCe0XsSd0.png?o=1
[3]: https://gcdn.pbrd.co/images/UsbCewSeaQDx.png?o=1
[4]: https://gcdn.pbrd.co/images/zitPLnJ3sfSE.jpg?o=1