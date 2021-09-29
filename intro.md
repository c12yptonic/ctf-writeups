---
layout: default
title: Introduction
nav_order: 1
description: "This journal is a detailed documentation of various CTF solves"
permalink: /
last_modified_date: 29-09-2021 02:36 AM +0530
---

# Welcome to cryp71x3rz CTF solves
{: .no_toc}

Hi, there. This is [cl2y7on1c][1] from [cryp71x3rz][2].
{: .fs-5 .fw-300 }


I intend to provide detailed write ups concentrating more on the thought process
that went behind solving the challenge along with the actual solves.
{: .fs-5 .fw-300 }

In general most of the CTF writeups lack giving a perspective on how to approach a 
challenge and assumes some amount of pre-exposure to tools and challenges. I would
strive to provide a detailed account to help anyone understand on how to approach
such challenges systematically.
{: .fs-5 .fw-300 }

A general heads up, I am more into **crypto** and **reversing**. So you could expect
majority of my writeups concentrating around these types of challenges including some
**miscellaneous** type of challenges.
{: .fs-5 .fw-300 }

> Note: This blog does assume that the reader has basic understanding of what a CTF is and intends to develop further from it. For more details on CTF head over to [CTF101][3].

## What is a CTF ?
{: .no_toc}

The main goal of all the challenges is to find hidden flags of the specified format. The format
of the flag is almost always made known in the rules page of the competition.

The flag is reachable via the clues/files/websites provided as part of the
challenge and does not require any kind of brute force methods to solve them.

CTF a.k.a **Capture the Flag** is a competitive hacking challenge. It includes challenges from
a variety of categories including:

## Table of contents
{: .no_toc .text-delta}

1. TOC
{:toc}

### Miscellaneous
A miscellaneous challenge includes random challenges which are not specific to any specialized
technique. These range from puzzles, riddles to challenges involving specific collaboration tools
and bot hacking.

### Pwn
A Pwn challenge has the main goal of owning the given server/binary. In general a Pwn challenge provides
access to a remote server and a specific code running on the server. The goal is to exploit the vulnerability
in the process running on the server, generally a buffer overflow or underflow forcing the code to accidentally
spill out flag contents stored in those memory locations.

### Reversing
Reversing mainly focusses on decompiling a binary using either static or dynamic tools. The focus lies
on finding the logic of the binary and making subtle changes or exploiting the correct code flow to
spill out the flag. There are even cases where the register values need to be monitored to obtain the flag
from the registers when the code is executing. It generally involves an ELF binary which can be debugged
using [GDB][4] on a linux box. In other cases it might be a windows binary requiring a windows equivalent of it.
Also [Ghidra][5] is a Java based platform neutral tool which ca be used to analyze a binary.

### Forensics
Forensic analysis involves literally performing a forensic analysis either a network dump or a backup image
created as part of triaging a security hack. The flags are generally made of 3 or 4 parts/pieces of information
which are detailed in the challenge. The goal is to find those pieces of information from the given file and
put them together in the specified format to obtain the final flag.

### Crypto
A crypto challenge typically involves any kind of cryptography. Generally these focus on RSA, visual cryptography
or any other type of cryptographic algorithms. For crypto challenges a thorough understanding of the algorithms
plays a major role in solving the challenge faster. As for tools, there are quite a few tools like [RsaCtfTool][6].

### Web vulnerabilities
Web based challenges mainly involve OWASP vulnerabilities or vulnerabilities within web server languages like
nodeJS that expose the hidden challenge. These type of challenges generally are provided with a web server code
base which explicitly hides a flag which is only available within the hosted service. The goal is to understand the
web server code and exploit the actual service in order to exfiltrate the required flag. This includes vulnerabilities
like XSS, SQLi, Cookie stealing and much more.

### Open source intelligence
OSINT challenges mainly rely on open source search, including search on web pages, youtubes, social media, dark web etc
to reach the required flag. These need to be approached with a mind set to first understand the search space using the
available clues and then perform the right search to obtain the flag either in total or parts.

[1]: https://ctftime.org/user/117599 
[2]: https://ctftime.org/team/135603
[3]: https://ctf101.org/
[4]: https://www.gnu.org/software/gdb/
[5]: https://ghidra-sre.org/
[6]: https://github.com/Ganapati/RsaCtfTool