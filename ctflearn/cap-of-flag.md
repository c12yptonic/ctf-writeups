---
layout: default
title: A CAPture of flag
nav_order: 1
description: "PCAP hidden flag"
permalink: /ctflearn/acapofflag
has_children: false
parent: CTF learn challenge list
---

## A capture of the flag 🪧
{: .no_toc}  
Forensics
{: .label .label-green .fs-1 .ml-0}

This is a basic forensics challenge which involves analysis of a **`.pcap`** file. A **PCAP** file is a 
network packet capture file that records all the packet transmissions that has occurred in the system
for the duration of the capture.

Complete challenge description can be viewed [here][1] and the challenge file can be downloaded [here][3].

This means the flag is hidden in one of the packets captured in this file. A **PCAP** file can be easily
analyzed using [**Wireshark**][2].

On loading the PCAP file we find that there are lot of packets captured. An organized way to go through
the capture is to follow the inverse network layer, starting with the application layer first. This means
we should tend to analyzed any specific application layer protocol packets like HTTP, HTTPs, SSH etc first.

Quickly we can see that **Packet 247** which is an HTTP packet with a string parameter **`msg`** whose
value seems to be **Base-64 encoded**. Such encoding techniques are common in order to bypass any flat
search knowing the flag format. So its always best to not ignore encoded content, but to ensure whether it
is an intended flag or not.

A screen shot of the packet is shown below:

![Packet 247][4]

The Base 64 encoded value is: **`ZmxhZ3tBRmxhZ0luUENBUH0=`**  
Decoding it we get the flag : **`flag{AFlagInPCAP}`**



[1]: https://ctflearn.com/challenge/356
[2]: https://www.wireshark.org/
[3]: https://mega.nz/#!3WhAWKwR!1T9cw2srN2CeOQWeuCm0ZVXgwk-E2v-TrPsZ4HUQ_f4
[4]: https://gcdn.pbrd.co/images/JuSEuVjl7vaG.png?o=1