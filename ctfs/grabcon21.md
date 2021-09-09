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

[![Easy rev in action](https://asciinema.org/a/pg6Zv7ldafvIYQT6Qu1fZgNdr.svg)][10]

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
