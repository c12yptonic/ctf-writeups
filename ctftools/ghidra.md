---
layout: default
title: Ghidra 🐲
nav_order: 1
description: "Ghidra - An introduction to reversing"
permalink: /ctftools/ghidra
has_children: false
parent: CTF Tools
---

## Ghidra 🐲
{: .no_toc}
Reversing
{: .label .label-green .fs-1 .ml-0}

Reversing is one of the niche categories and a regular one in most of the CTF
challenges. However this is one of the toughest categories to crack in a CTF.
One of the main reason for this is that a binary can have a lot of intricacies
and obfuscation layers built into it.  

This does not allow us to have a standard procedure to go ahead with the process
of reversing. However there are tools emerging for professional forensic analysis
of malware which provide near reproduction of source code from binary even for
native C/C++ op codes.  

The importance of such tools have gone to such extents that the NSA - National Security Agency
has released this binary reversing tool. Also this tool is Java based which means
tool as such can be run on any OS Platform.  

## Table of contents
{: .no_toc .text-delta}

1. TOC
{:toc}

### Installing Ghidra

Installation of Ghidra is pretty much easy. It requires JDK11 to be installed and then
requires us to uninstall the release zip which contains the required executable files.
For detailed installation details click [here][1].  

Runnig the command **`ghidraRun`** brings up the Ghidra GUI which gives us an UI to 
create a new project. After creating the project we are give a tool bench which includes
reversing, debugging and running the binary.  

Below is a walkthrough to create a new project, activate the reversing tool bench and then
load a binary file to it.

![Walkthrough to load a project in Ghidra][2]

### Tool bench view and options

The tool bench view, presents various sections which give us detailed information on the
binary. Also the main panel is split into the disassembled code and its corresponding
re-constructed code.  

We can navigate to any of the symbols from the dis-assembled code which automatically 
presents us the source code for the symbol and vice-versa. This helps us with a convenient
navigation.  

![Tool bench view][3]  


### Graph based view

In addition to the above, all conditional flows are easily represented as graph transitions in
the graph view. It gives a clear picture on the code flow jumps and the paths available in a 
code block.  

This is really useful to quickly get a birds eye view of the code flow and decide on the important
parts that we need to concentrate on. Also it gives us clear picture on what conditions and input
values lead us to specific code blocks.  


### Dynamic code flow

Ghidra also has provision for debugging the code similar to GDB and inspect the register, stack and
other data points. This really helps in reverse engineering and pwn based challenges. For detailed
help and documentation visit [here][4].




[1]: https://github.com/NationalSecurityAgency/ghidra#install
[2]: https://gcdn.pbrd.co/images/yBnbjiLCijoQ.gif?o=1
[3]: https://gcdn.pbrd.co/images/AuMygngoiwzj.png?o=1
[4]: https://htmlpreview.github.io/?https://github.com/NationalSecurityAgency/ghidra/blob/stable/GhidraDocs/InstallationGuide.html