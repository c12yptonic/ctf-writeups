---
layout: default
title: Every bit counts
nav_order: 2
description: "Every bit counts (while reversing)!!"
permalink: /ctflearn/everybitcounts
has_children: false
parent: CTF Learn
---

## Every bit counts 👨‍💻
{: .no_toc}  
Reversing
{: .label .label-green .fs-1 .ml-0}

The challenge was part of the reversing challenges, and was medium-to-hard difficulty.
In this challenge we are presented with the below challenge instructions and a file which
can be downloaded from [here][1] or [here][2].

Challenge instructions:  
> My colleague is a senior C developer and he had a bad experience in his job assignment. He 
> was developing applications for a real-time embedded operating system named "Buggy OS™". 
> He had to implement workarounds to avoid using the standard C library in some cases. 
> 
> For instance the memcmp shouldn't be used to test command-line argument because of obscure
> reason resulting in some bits were not checked. Instead he implemented its own function 
> to check each bit of the command-line and it was working fine.  
> 
> To show case how painful it was, he showed me one of its application implementing his new 
> function, but he forgot the supported command-line parameter.

> Note: Solution with cool effects shared in comments section of the challenge

We are given a binary file with no extension. In general based on prior coding experience
such files are mostly executable.  

To determine the file type we can use any of the utilities mentioned below on a Linux box:
1. `files every_bit_counts`
2. `exiftool every_bit_counts`

Both the commands give us the information that the given binary is an [**ELF**][3] executable.
ELF stands for **Executable Linux Format**. I recommend everyone not familiar with ELF to read
the linked document for a comprehensive introduction.

<details markdown="block">
  <summary>
  Click here to view full output of the commands
  </summary>

```
┌──(cryptonic㉿cryptonic-kali)-[~/CtfLearn/everybitcounts]
└─$ exiftool every_bit_counts     
ExifTool Version Number         : 12.16
File Name                       : every_bit_counts
Directory                       : .
File Size                       : 16 KiB
File Modification Date/Time     : 2021:08:29 19:27:05+05:30
File Access Date/Time           : 2021:09:14 21:21:44+05:30
File Inode Change Date/Time     : 2021:08:29 19:27:55+05:30
File Permissions                : rwxr-xr-x
File Type                       : ELF executable
File Type Extension             : 
MIME Type                       : application/octet-stream
CPU Architecture                : 64 bit
CPU Byte Order                  : Little endian
Object File Type                : Executable file
CPU Type                        : AMD x86-64
                                                                                                                                                                
┌──(cryptonic㉿cryptonic-kali)-[~/CtfLearn/everybitcounts]
└─$ file every_bit_counts 
every_bit_counts: ELF 64-bit LSB executable, x86-64, version 1 (SYSV), dynamically linked, interpreter /lib64/ld-linux-x86-64.so.2, stripped
```
</details>

So now we are clear that it is some Linux executable and we run it to see what the binary does.
Obviously we wont be that lucky and the binary spit out some error messages as seen below.  

![Every bit counts initial execution][4]

Another check that is often done to check if the flag is not hidden as a normal string within
the binary is to use the **`strings`** command. This command basically prints out all strings
that are made of human readable characters and with a minimum length. Again obviously this 
challenge was not meant to be that easy.

From the error messages it is clear that it expects some kind of input or the flag is hidden
behind the binariy's logic. Also standing with the challenge category it is pretty evident that
we need to reverse engineer the binary and look into its logic.  

A quick web search on reversing binaries lead us to a tool from the NSA, named [Ghidra][5]. This
helps us to quickly create a project and load the source code from the binary. The loaded project
within the tool looks as below:
![Ghidra project load view][6]

The above view shows a disassembled code in the main pane and its corresponding unobfuscated code
to its right. The left pane has all kinds of navigation aids to go through the code.  

> Note:  
> 
> The retrieved code is just a representation of the original source and might  
> miss some parts due to obfuscation techniques used by the adversary as 
> highlighted [here][7]. So be sure to always look at the code with some 
> suspicion in real CTF challenges.  

Once the binary is loaded into the tool, we need to find the **`main`** method which is generally
the initial entry to our source code. But the actual entry point in the binary is different from 
the actual **`main`** method and in Ghidra it is generally indicated as the **`_entry`** under
the **Functions** list.  

We pop open the source of the **`_entry`** method which ultimately just calls the **`main`** method
along with its other parameters. You can view a glmipse of the code in the below image:  

![Reversed main method][8]

<details markdown="block">
  <summary>
  Click here to view the complete code  
  <br>
  Note: Its an awfully long code
  </summary>  

{% raw %}
```java
undefined8 main(int param_1,undefined8 *param_2)
{
  undefined8 uVar1;
  size_t sVar2;
  
  if (param_1 == 2) {
    sVar2 = strlen((char *)param_2[1]);
    if (sVar2 == 0x34) {
      if (((((((((((*(byte *)(param_2[1] + 0x1c) & 0x20) == 0) &&
                 ((*(byte *)(param_2[1] + 0x24) & 0x10) != 0)) &&
                ((*(byte *)(param_2[1] + 0x2f) & 0x20) != 0)) &&
               (((*(byte *)(param_2[1] + 0x20) & 0x20) != 0 &&
                ((*(byte *)(param_2[1] + 0x2b) & 4) != 0)))) &&
              ((((int)*(char *)(param_2[1] + 0x32) & 0x80U) == 0 &&
               (((*(byte *)(param_2[1] + 8) & 1) != 0 && ((*(byte *)(param_2[1] + 0x2e) & 4) != 0)))
               ))) && (((((int)*(char *)(param_2[1] + 0x20) & 0x80U) == 0 &&
                        ((((((*(byte *)(param_2[1] + 8) & 4) == 0 &&
                            ((*(byte *)(param_2[1] + 0x30) & 0x10) != 0)) &&
                           (((int)*(char *)(param_2[1] + 0x10) & 0x80U) == 0)) &&
                          ((((*(byte *)(param_2[1] + 0x13) & 8) == 0 &&
                            ((*(byte *)(param_2[1] + 8) & 0x40) != 0)) &&
                           (((*(byte *)(param_2[1] + 0x2b) & 0x10) != 0 &&
                            (((*(byte *)(param_2[1] + 0xf) & 4) != 0 &&
                             ((*(byte *)param_2[1] & 4) == 0)))))))) &&
                         ((*(byte *)(param_2[1] + 0x2b) & 8) == 0)))) &&
                       (((((*(byte *)(param_2[1] + 0x19) & 0x40) != 0 &&
                          ((*(byte *)(param_2[1] + 4) & 1) != 0)) &&
                         (((int)*(char *)(param_2[1] + 0x2b) & 0x80U) == 0)) &&
                        ((((*(byte *)(param_2[1] + 0x2c) & 8) == 0 &&
                          ((*(byte *)(param_2[1] + 0x21) & 0x20) != 0)) &&
                         (((*(byte *)(param_2[1] + 0x1d) & 0x10) == 0 &&
                          (((*(byte *)(param_2[1] + 0x21) & 1) != 0 &&
                           ((*(byte *)(param_2[1] + 0x1c) & 0x40) != 0)))))))))))) &&
            ((((((*(byte *)(param_2[1] + 0x17) & 0x40) != 0 &&
                (((((*(byte *)(param_2[1] + 0x18) & 1) != 0 &&
                   ((*(byte *)(param_2[1] + 0x27) & 0x20) != 0)) &&
                  ((*(byte *)(param_2[1] + 0x25) & 4) == 0)) &&
                 ((((int)*(char *)(param_2[1] + 0xd) & 0x80U) == 0 &&
                  ((*(byte *)(param_2[1] + 0x31) & 0x20) != 0)))))) &&
               ((((((*(byte *)(param_2[1] + 9) & 4) != 0 &&
                   (((*(byte *)(param_2[1] + 7) & 0x20) != 0 &&
                    ((*(byte *)(param_2[1] + 0x30) & 4) == 0)))) &&
                  ((*(byte *)(param_2[1] + 0x12) & 4) == 0)) &&
                 (((((*(byte *)(param_2[1] + 0x2d) & 4) == 0 &&
                    ((*(byte *)(param_2[1] + 0x1e) & 0x10) != 0)) &&
                   ((*(byte *)(param_2[1] + 7) & 0x10) == 0)) &&
                  ((((*(byte *)(param_2[1] + 0x31) & 0x40) != 0 &&
                    (((int)*(char *)(param_2[1] + 2) & 0x80U) == 0)) &&
                   (((*(byte *)(param_2[1] + 0xc) & 0x40) != 0 &&
                    (((*(byte *)(param_2[1] + 0x25) & 8) == 0 &&
                     ((*(byte *)(param_2[1] + 0x1d) & 8) == 0)))))))))) &&
                (((*(byte *)(param_2[1] + 0x1d) & 0x20) != 0 &&
                 ((((*(byte *)(param_2[1] + 0x32) & 2) != 0 &&
                   ((*(byte *)(param_2[1] + 0x2d) & 1) == 0)) &&
                  ((*(byte *)(param_2[1] + 10) & 0x10) != 0)))))))) &&
              ((((((int)*(char *)(param_2[1] + 0x28) & 0x80U) == 0 &&
                 ((*(byte *)(param_2[1] + 0x12) & 2) == 0)) &&
                (((*(byte *)(param_2[1] + 0x2b) & 1) != 0 &&
                 ((((int)*(char *)(param_2[1] + 0x1a) & 0x80U) == 0 &&
                  (((int)*(char *)(param_2[1] + 0x33) & 0x80U) == 0)))))) &&
               ((*(byte *)(param_2[1] + 0x14) & 4) != 0)))) &&
             ((((((((*(byte *)(param_2[1] + 0x1e) & 8) != 0 &&
                   ((*(byte *)(param_2[1] + 4) & 0x10) == 0)) &&
                  (((int)*(char *)(param_2[1] + 4) & 0x80U) == 0)) &&
                 (((*(byte *)(param_2[1] + 0x15) & 0x40) != 0 &&
                  (((int)*(char *)(param_2[1] + 0x17) & 0x80U) == 0)))) &&
                ((*(byte *)(param_2[1] + 0xc) & 0x10) != 0)) &&
               ((((*(byte *)(param_2[1] + 0x29) & 1) != 0 &&
                 ((*(byte *)(param_2[1] + 0xd) & 0x20) != 0)) &&
                (((*(byte *)(param_2[1] + 0x24) & 1) == 0 &&
                 ((((*(byte *)(param_2[1] + 1) & 1) == 0 &&
                   (((int)*(char *)(param_2[1] + 0x13) & 0x80U) == 0)) &&
                  (((int)*(char *)(param_2[1] + 5) & 0x80U) == 0)))))))) &&
              ((((*(byte *)(param_2[1] + 0x32) & 0x40) == 0 &&
                ((*(byte *)(param_2[1] + 8) & 0x10) != 0)) &&
               (((*(byte *)(param_2[1] + 0x23) & 8) == 0 &&
                ((((((*(byte *)(param_2[1] + 9) & 8) == 0 && ((*(byte *)param_2[1] & 2) != 0)) &&
                   ((((int)*(char *)(param_2[1] + 0x15) & 0x80U) == 0 &&
                    ((((*(byte *)(param_2[1] + 7) & 1) == 0 &&
                      ((*(byte *)(param_2[1] + 0x29) & 8) != 0)) &&
                     (((int)*(char *)(param_2[1] + 3) & 0x80U) == 0)))))) &&
                  (((*(byte *)(param_2[1] + 0xe) & 2) != 0 &&
                   ((*(byte *)(param_2[1] + 0x16) & 2) != 0)))) &&
                 ((*(byte *)(param_2[1] + 0x17) & 1) != 0)))))))))))) &&
           (((((((*(byte *)(param_2[1] + 0x27) & 2) != 0 &&
                ((*(byte *)(param_2[1] + 0x10) & 0x20) == 0)) &&
               (((*(byte *)(param_2[1] + 6) & 8) == 0 &&
                (((((*(byte *)(param_2[1] + 0x1a) & 1) == 0 &&
                   ((*(byte *)(param_2[1] + 0x1e) & 4) != 0)) &&
                  ((*(byte *)(param_2[1] + 0x1a) & 2) != 0)) &&
                 ((((int)*(char *)(param_2[1] + 0x1e) & 0x80U) == 0 &&
                  (((int)*(char *)(param_2[1] + 0x16) & 0x80U) == 0)))))))) &&
              ((*(byte *)(param_2[1] + 0x23) & 0x10) == 0)) &&
             (((*(byte *)(param_2[1] + 0x30) & 1) != 0 && ((*(byte *)(param_2[1] + 0x21) & 4) != 0))
             )) && (((((*(byte *)(param_2[1] + 4) & 4) != 0 &&
                      (((((int)*(char *)(param_2[1] + 0x24) & 0x80U) == 0 &&
                        ((*(byte *)(param_2[1] + 0x1f) & 8) != 0)) &&
                       ((*(byte *)(param_2[1] + 1) & 2) == 0)))) &&
                     ((((*(byte *)(param_2[1] + 0x22) & 4) != 0 &&
                       ((*(byte *)(param_2[1] + 0x10) & 1) != 0)) &&
                      ((*(byte *)(param_2[1] + 3) & 0x10) == 0)))) &&
                    (((((*(byte *)(param_2[1] + 0x16) & 0x10) != 0 &&
                       ((*(byte *)(param_2[1] + 0x2a) & 1) != 0)) &&
                      ((((*(byte *)(param_2[1] + 0xb) & 1) != 0 &&
                        ((((*(byte *)(param_2[1] + 1) & 0x10) != 0 &&
                          ((*(byte *)(param_2[1] + 2) & 4) != 0)) &&
                         ((*(byte *)(param_2[1] + 10) & 8) == 0)))) &&
                       (((*(byte *)(param_2[1] + 0x13) & 1) != 0 &&
                        ((*(byte *)(param_2[1] + 0x24) & 8) == 0)))))) &&
                     ((((*(byte *)(param_2[1] + 4) & 8) == 0 &&
                       (((((*(byte *)(param_2[1] + 2) & 1) == 0 &&
                          ((*(byte *)(param_2[1] + 0x1b) & 0x10) == 0)) &&
                         (((*(byte *)(param_2[1] + 9) & 1) != 0 &&
                          (((((*(byte *)(param_2[1] + 0xd) & 2) == 0 &&
                             ((*(byte *)(param_2[1] + 5) & 0x20) != 0)) &&
                            ((*(byte *)(param_2[1] + 0x11) & 0x10) == 0)) &&
                           (((*(byte *)(param_2[1] + 0xd) & 0x10) != 0 &&
                            ((*(byte *)(param_2[1] + 0xd) & 0x40) != 0)))))))) &&
                        ((*(byte *)(param_2[1] + 3) & 4) != 0)))) &&
                      (((*(byte *)(param_2[1] + 7) & 2) != 0 &&
                       ((*(byte *)(param_2[1] + 0x10) & 2) != 0)))))))))))) &&
          (((((((*(byte *)(param_2[1] + 0x20) & 8) == 0 &&
               ((((*(byte *)(param_2[1] + 0x23) & 2) == 0 &&
                 ((*(byte *)(param_2[1] + 0x31) & 8) == 0)) &&
                ((*(byte *)(param_2[1] + 0x1b) & 4) != 0)))) &&
              (((((int)*(char *)(param_2[1] + 0x2f) & 0x80U) == 0 &&
                ((*(byte *)(param_2[1] + 0xd) & 8) != 0)) &&
               (((int)*(char *)(param_2[1] + 1) & 0x80U) == 0)))) &&
             (((((int)*(char *)(param_2[1] + 0x26) & 0x80U) == 0 &&
               ((*(byte *)(param_2[1] + 0x24) & 4) == 0)) &&
              (((*(byte *)(param_2[1] + 0x33) & 0x10) != 0 &&
               ((((*(byte *)(param_2[1] + 0x17) & 0x20) == 0 &&
                 ((*(byte *)(param_2[1] + 6) & 2) != 0)) &&
                (((int)*(char *)(param_2[1] + 0x23) & 0x80U) == 0)))))))) &&
            ((((*(byte *)(param_2[1] + 0x14) & 0x20) != 0 &&
              ((*(byte *)(param_2[1] + 9) & 0x20) != 0)) &&
             (((*(byte *)(param_2[1] + 0x2d) & 0x20) != 0 &&
              ((((*(byte *)(param_2[1] + 0xc) & 2) != 0 && ((*(byte *)(param_2[1] + 6) & 0x10) != 0)
                ) && (((*(byte *)(param_2[1] + 0x22) & 8) != 0 &&
                      (((((((*(byte *)(param_2[1] + 0x1a) & 0x20) != 0 &&
                           ((*(byte *)(param_2[1] + 0x17) & 2) == 0)) &&
                          ((*(byte *)(param_2[1] + 0xe) & 0x10) == 0)) &&
                         (((*(byte *)(param_2[1] + 0xc) & 8) != 0 &&
                          (((int)*(char *)(param_2[1] + 0x22) & 0x80U) == 0)))) &&
                        ((*(byte *)(param_2[1] + 0x10) & 4) != 0)) &&
                       (((*(byte *)(param_2[1] + 3) & 2) == 0 &&
                        ((*(byte *)(param_2[1] + 0x31) & 2) != 0)))))))))))))) &&
           (((((((*(byte *)(param_2[1] + 0x16) & 0x20) == 0 &&
                (((((*(byte *)(param_2[1] + 0x15) & 0x20) != 0 &&
                   ((*(byte *)(param_2[1] + 0x29) & 0x20) == 0)) &&
                  ((*(byte *)(param_2[1] + 0x25) & 2) != 0)) &&
                 ((((int)*(char *)(param_2[1] + 0x12) & 0x80U) == 0 &&
                  ((*(byte *)(param_2[1] + 7) & 4) != 0)))))) &&
               (((((*(byte *)(param_2[1] + 0x2f) & 4) != 0 &&
                  (((*(byte *)(param_2[1] + 10) & 2) == 0 &&
                   (((int)*(char *)(param_2[1] + 0xb) & 0x80U) == 0)))) &&
                 ((*(byte *)(param_2[1] + 0x20) & 4) == 0)) &&
                ((((*(byte *)(param_2[1] + 0x26) & 0x40) != 0 && ((*(byte *)param_2[1] & 0x10) == 0)
                  ) && ((*(byte *)(param_2[1] + 2) & 0x40) != 0)))))) &&
              ((((((int)*(char *)(param_2[1] + 0x1c) & 0x80U) == 0 &&
                 ((*(byte *)(param_2[1] + 0x2b) & 0x40) != 0)) &&
                (((*(byte *)(param_2[1] + 0x2f) & 8) != 0 &&
                 (((*(byte *)(param_2[1] + 0x2c) & 0x20) != 0 &&
                  ((*(byte *)(param_2[1] + 0x18) & 0x20) != 0)))))) &&
               ((*(byte *)(param_2[1] + 9) & 2) != 0)))) &&
             (((((((((*(byte *)(param_2[1] + 6) & 4) == 0 &&
                    ((*(byte *)(param_2[1] + 0x31) & 4) == 0)) && ((*(byte *)param_2[1] & 8) == 0))
                  && (((*(byte *)(param_2[1] + 0xb) & 0x40) != 0 &&
                      ((*(byte *)(param_2[1] + 5) & 1) != 0)))) &&
                 (((*(byte *)(param_2[1] + 0x14) & 8) != 0 &&
                  (((*(byte *)(param_2[1] + 0x2f) & 0x40) != 0 &&
                   ((*(byte *)(param_2[1] + 0x26) & 8) != 0)))))) &&
                ((*(byte *)(param_2[1] + 0x19) & 4) != 0)) &&
               (((((((int)*(char *)(param_2[1] + 0x21) & 0x80U) == 0 &&
                   ((*(byte *)(param_2[1] + 5) & 8) == 0)) &&
                  ((*(byte *)(param_2[1] + 0x28) & 0x10) == 0)) &&
                 ((((*(byte *)(param_2[1] + 0x19) & 0x10) != 0 &&
                   ((*(byte *)(param_2[1] + 0x25) & 1) != 0)) &&
                  (((*(byte *)(param_2[1] + 2) & 8) == 0 &&
                   (((*(byte *)(param_2[1] + 0x2a) & 0x40) != 0 &&
                    ((*(byte *)(param_2[1] + 9) & 0x10) != 0)))))))) &&
                ((((int)*(char *)(param_2[1] + 0x2e) & 0x80U) == 0 &&
                 (((((((*(byte *)(param_2[1] + 0x29) & 4) != 0 &&
                      ((*(byte *)(param_2[1] + 0x29) & 0x10) != 0)) &&
                     (((int)*(char *)(param_2[1] + 0x1d) & 0x80U) == 0)) &&
                    ((((*(byte *)param_2[1] & 0x20) == 0 &&
                      ((*(byte *)(param_2[1] + 0x25) & 0x40) == 0)) &&
                     ((((int)*(char *)(param_2[1] + 0x19) & 0x80U) == 0 &&
                      (((*(byte *)(param_2[1] + 0x17) & 0x10) == 0 &&
                       ((*(byte *)(param_2[1] + 0x1b) & 1) == 0)))))))) &&
                   ((*(byte *)(param_2[1] + 0xf) & 0x10) != 0)) &&
                  (((((*(byte *)(param_2[1] + 0x1f) & 0x40) != 0 &&
                     ((*(byte *)(param_2[1] + 0x2a) & 0x10) == 0)) &&
                    ((*(byte *)(param_2[1] + 10) & 0x20) != 0)) &&
                   (((*(byte *)(param_2[1] + 0x30) & 0x40) == 0 &&
                    (((int)*(char *)(param_2[1] + 0xf) & 0x80U) == 0)))))))))))) &&
              ((((((*(byte *)(param_2[1] + 0x1c) & 8) == 0 &&
                  (((*(byte *)(param_2[1] + 0x27) & 1) != 0 &&
                   ((*(byte *)(param_2[1] + 0x28) & 2) != 0)))) &&
                 ((*(byte *)(param_2[1] + 0x32) & 4) == 0)) &&
                ((((*(byte *)(param_2[1] + 0x27) & 0x10) != 0 &&
                  ((*(byte *)(param_2[1] + 0x2a) & 4) != 0)) &&
                 ((*(byte *)(param_2[1] + 0x2d) & 8) != 0)))) &&
               (((*(byte *)(param_2[1] + 0xd) & 4) == 0 &&
                ((*(byte *)(param_2[1] + 0x33) & 0x20) != 0)))))))) &&
            ((((((*(byte *)(param_2[1] + 0x15) & 8) == 0 &&
                (((*(byte *)(param_2[1] + 0x20) & 2) == 0 &&
                 ((*(byte *)(param_2[1] + 0x1d) & 4) != 0)))) &&
               ((*(byte *)(param_2[1] + 0x1e) & 1) != 0)) &&
              (((((*(byte *)(param_2[1] + 0x2c) & 2) != 0 && ((*(byte *)(param_2[1] + 3) & 8) != 0))
                && (((int)*(char *)(param_2[1] + 10) & 0x80U) == 0)) &&
               ((((*(byte *)(param_2[1] + 0x33) & 2) == 0 &&
                 ((*(byte *)(param_2[1] + 0x26) & 1) != 0)) &&
                (((*(byte *)(param_2[1] + 0x13) & 0x40) != 0 &&
                 (((*(byte *)(param_2[1] + 0x27) & 0x40) != 0 &&
                  ((*(byte *)(param_2[1] + 0x1b) & 0x20) != 0)))))))))) &&
             ((*(byte *)(param_2[1] + 0x2d) & 0x40) != 0)))))))) &&
         (((((((((*(byte *)(param_2[1] + 2) & 2) != 0 && ((*(byte *)(param_2[1] + 0x1b) & 8) != 0))
               && ((*(byte *)(param_2[1] + 0xb) & 0x10) != 0)) &&
              (((*(byte *)(param_2[1] + 0x18) & 0x40) != 0 && ((*(byte *)(param_2[1] + 5) & 2) == 0)
               ))) && ((*(byte *)(param_2[1] + 0x19) & 2) != 0)) &&
            ((((*(byte *)(param_2[1] + 0x1a) & 0x40) != 0 &&
              ((*(byte *)(param_2[1] + 0x18) & 4) == 0)) &&
             (((*(byte *)(param_2[1] + 4) & 0x40) != 0 &&
              ((((*(byte *)(param_2[1] + 0x2f) & 0x10) == 0 &&
                ((*(byte *)(param_2[1] + 0x29) & 0x40) != 0)) &&
               ((*(byte *)(param_2[1] + 0x22) & 0x10) != 0)))))))) &&
           ((((((((*(byte *)(param_2[1] + 0x23) & 0x40) != 0 &&
                 ((*(byte *)(param_2[1] + 5) & 4) == 0)) &&
                ((*(byte *)(param_2[1] + 0x15) & 2) == 0)) &&
               (((*(byte *)(param_2[1] + 0x2d) & 0x10) == 0 &&
                ((*(byte *)(param_2[1] + 0x24) & 2) != 0)))) &&
              ((((*(byte *)(param_2[1] + 0x28) & 0x40) != 0 &&
                ((((*(byte *)(param_2[1] + 0x15) & 4) != 0 &&
                  ((*(byte *)(param_2[1] + 0x13) & 4) != 0)) &&
                 (((int)*(char *)(param_2[1] + 0xc) & 0x80U) == 0)))) &&
               ((((((*(byte *)(param_2[1] + 0x2a) & 2) == 0 &&
                   ((*(byte *)(param_2[1] + 1) & 8) == 0)) &&
                  (((*(byte *)(param_2[1] + 0x10) & 0x10) != 0 &&
                   ((((*(byte *)(param_2[1] + 0x23) & 4) == 0 &&
                     ((*(byte *)(param_2[1] + 0xd) & 1) != 0)) &&
                    (((*(byte *)(param_2[1] + 1) & 0x40) != 0 &&
                     (((((*(byte *)(param_2[1] + 0x2e) & 1) != 0 &&
                        ((*(byte *)(param_2[1] + 0x1f) & 0x10) != 0)) &&
                       ((*(byte *)(param_2[1] + 0x26) & 4) != 0)) &&
                      (((*(byte *)(param_2[1] + 0x2f) & 2) != 0 &&
                       ((*(byte *)(param_2[1] + 0x26) & 2) != 0)))))))))))) &&
                 (((int)*(char *)(param_2[1] + 0x25) & 0x80U) == 0)) &&
                ((((*(byte *)(param_2[1] + 0x1c) & 2) == 0 &&
                  ((*(byte *)(param_2[1] + 10) & 0x40) == 0)) &&
                 ((((*(byte *)(param_2[1] + 0x2e) & 0x10) != 0 &&
                   (((((int)*(char *)(param_2[1] + 0x27) & 0x80U) == 0 &&
                     ((*(byte *)(param_2[1] + 0x2e) & 0x20) == 0)) &&
                    ((*(byte *)(param_2[1] + 0x1f) & 1) != 0)))) &&
                  ((((*(byte *)(param_2[1] + 0x25) & 0x10) != 0 && ((*(byte *)param_2[1] & 1) != 0))
                   && ((*(byte *)(param_2[1] + 0x11) & 0x20) != 0)))))))))))) &&
             ((((((*(byte *)(param_2[1] + 0xb) & 0x20) != 0 &&
                 (((int)*(char *)(param_2[1] + 0x31) & 0x80U) == 0)) &&
                (((*(byte *)(param_2[1] + 0x12) & 8) == 0 &&
                 ((((*(byte *)(param_2[1] + 0x16) & 0x40) != 0 &&
                   ((*(byte *)(param_2[1] + 0x1c) & 4) == 0)) &&
                  ((*(byte *)(param_2[1] + 0xe) & 8) != 0)))))) &&
               (((*(byte *)(param_2[1] + 0x30) & 8) == 0 &&
                ((*(byte *)(param_2[1] + 6) & 0x40) != 0)))) &&
              (((((*(byte *)(param_2[1] + 0xc) & 0x20) == 0 &&
                 ((((((((*(byte *)(param_2[1] + 0x30) & 0x20) != 0 &&
                       ((*(byte *)(param_2[1] + 0x1f) & 4) == 0)) &&
                      (((*(byte *)(param_2[1] + 0x2e) & 0x40) != 0 &&
                       (((((*(byte *)(param_2[1] + 0x21) & 8) == 0 &&
                          (((int)*(char *)(param_2[1] + 0x2a) & 0x80U) == 0)) &&
                         ((*(byte *)(param_2[1] + 0xf) & 1) != 0)) &&
                        ((((int)*(char *)(param_2[1] + 0x18) & 0x80U) == 0 &&
                         ((*(byte *)(param_2[1] + 0xc) & 4) != 0)))))))) &&
                     ((*(byte *)(param_2[1] + 0x15) & 0x10) == 0)) &&
                    (((*(byte *)(param_2[1] + 0x15) & 1) == 0 &&
                     ((*(byte *)(param_2[1] + 0x1f) & 0x20) != 0)))) &&
                   ((((*(byte *)(param_2[1] + 0x1a) & 4) != 0 &&
                     ((((*(byte *)(param_2[1] + 0x33) & 0x40) != 0 &&
                       ((*(byte *)(param_2[1] + 0x2a) & 0x20) != 0)) &&
                      ((*(byte *)(param_2[1] + 0xc) & 1) != 0)))) &&
                    ((((*(byte *)(param_2[1] + 0xf) & 8) == 0 &&
                      (((int)*(char *)(param_2[1] + 0x1b) & 0x80U) == 0)) &&
                     ((*(byte *)(param_2[1] + 0x22) & 2) != 0)))))) &&
                  (((*(byte *)(param_2[1] + 6) & 0x20) != 0 &&
                   ((*(byte *)(param_2[1] + 0x17) & 8) != 0)))))) &&
                (((*(byte *)(param_2[1] + 0x27) & 4) == 0 &&
                 ((((*(byte *)(param_2[1] + 0x12) & 1) == 0 &&
                   ((*(byte *)(param_2[1] + 0x20) & 0x10) != 0)) &&
                  ((*(byte *)(param_2[1] + 0x1c) & 1) == 0)))))) &&
               ((((*(byte *)(param_2[1] + 0x2e) & 2) != 0 &&
                 ((*(byte *)(param_2[1] + 0xb) & 2) != 0)) &&
                ((*(byte *)(param_2[1] + 0x1c) & 0x10) == 0)))))))) &&
            (((((*(byte *)(param_2[1] + 0x1d) & 2) != 0 && ((*(byte *)(param_2[1] + 0x2f) & 1) == 0)
               ) && (((*(byte *)(param_2[1] + 0x11) & 4) != 0 &&
                     ((((((*(byte *)(param_2[1] + 0xe) & 0x20) != 0 &&
                         ((*(byte *)(param_2[1] + 0x2b) & 2) == 0)) &&
                        (((int)*(char *)(param_2[1] + 0x1f) & 0x80U) == 0)) &&
                       (((*(byte *)(param_2[1] + 0x1f) & 2) == 0 &&
                        ((*(byte *)(param_2[1] + 0x23) & 0x20) == 0)))) &&
                      ((*(byte *)(param_2[1] + 0xf) & 0x40) != 0)))))) &&
             ((((*(byte *)(param_2[1] + 0x1e) & 0x20) == 0 &&
               (((int)*(char *)(param_2[1] + 0x2d) & 0x80U) == 0)) &&
              (((*(byte *)(param_2[1] + 9) & 0x40) != 0 &&
               ((((*(byte *)(param_2[1] + 7) & 8) != 0 && (((int)*(char *)param_2[1] & 0x80U) == 0))
                && ((*(byte *)(param_2[1] + 0x26) & 0x20) == 0)))))))))))) &&
          ((((((((*(byte *)(param_2[1] + 0x25) & 0x20) != 0 &&
                ((*(byte *)(param_2[1] + 0x16) & 1) != 0)) &&
               (((*(byte *)(param_2[1] + 0x32) & 0x10) != 0 &&
                (((*(byte *)(param_2[1] + 0x33) & 4) != 0 &&
                 ((*(byte *)(param_2[1] + 0x2c) & 0x10) == 0)))))) &&
              ((*(byte *)(param_2[1] + 0x19) & 0x20) == 0)) &&
             (((((*(byte *)(param_2[1] + 0x22) & 0x20) == 0 &&
                (((int)*(char *)(param_2[1] + 0x2c) & 0x80U) == 0)) &&
               ((*(byte *)(param_2[1] + 5) & 0x10) == 0)) &&
              (((*(byte *)param_2[1] & 0x40) != 0 && ((*(byte *)(param_2[1] + 0x14) & 0x10) == 0))))
             )) && ((((((((*(byte *)(param_2[1] + 8) & 8) != 0 &&
                         ((((int)*(char *)(param_2[1] + 0x11) & 0x80U) == 0 &&
                          ((*(byte *)(param_2[1] + 0x23) & 1) != 0)))) &&
                        ((*(byte *)(param_2[1] + 0x21) & 0x10) != 0)) &&
                       (((((((*(byte *)(param_2[1] + 0x20) & 1) == 0 &&
                            ((*(byte *)(param_2[1] + 0x27) & 8) == 0)) &&
                           ((*(byte *)(param_2[1] + 4) & 0x20) != 0)) &&
                          (((*(byte *)(param_2[1] + 0x16) & 4) != 0 &&
                           (((int)*(char *)(param_2[1] + 0xe) & 0x80U) == 0)))) &&
                         ((((int)*(char *)(param_2[1] + 0x14) & 0x80U) == 0 &&
                          (((*(byte *)(param_2[1] + 0x14) & 2) != 0 &&
                           ((*(byte *)(param_2[1] + 0x17) & 4) != 0)))))) &&
                        ((*(byte *)(param_2[1] + 0x2b) & 0x20) != 0)))) &&
                      (((((*(byte *)(param_2[1] + 0x22) & 1) != 0 &&
                         ((*(byte *)(param_2[1] + 0x24) & 0x20) != 0)) &&
                        ((*(byte *)(param_2[1] + 0x2e) & 8) != 0)) &&
                       (((((*(byte *)(param_2[1] + 0x1e) & 2) != 0 &&
                          ((*(byte *)(param_2[1] + 8) & 0x20) != 0)) &&
                         (((*(byte *)(param_2[1] + 0x11) & 2) != 0 &&
                          (((*(byte *)(param_2[1] + 0x1b) & 2) == 0 &&
                           ((*(byte *)(param_2[1] + 0x13) & 2) == 0)))))) &&
                        (((int)*(char *)(param_2[1] + 7) & 0x80U) == 0)))))) &&
                     ((((*(byte *)(param_2[1] + 3) & 1) == 0 &&
                       ((*(byte *)(param_2[1] + 1) & 0x20) == 0)) &&
                      ((*(byte *)(param_2[1] + 0x1e) & 0x40) != 0)))) &&
                    (((*(byte *)(param_2[1] + 5) & 0x40) != 0 &&
                     ((*(byte *)(param_2[1] + 0x22) & 0x40) != 0)))))) &&
           ((((((*(byte *)(param_2[1] + 0x1a) & 0x10) == 0 &&
               (((*(byte *)(param_2[1] + 3) & 0x40) != 0 &&
                (((int)*(char *)(param_2[1] + 0x29) & 0x80U) == 0)))) &&
              (((*(byte *)(param_2[1] + 0x28) & 1) != 0 &&
               (((((*(byte *)(param_2[1] + 0x2d) & 2) == 0 && ((*(byte *)(param_2[1] + 1) & 4) != 0)
                  ) && ((*(byte *)(param_2[1] + 0x1a) & 8) == 0)) &&
                ((((int)*(char *)(param_2[1] + 0x30) & 0x80U) == 0 &&
                 ((*(byte *)(param_2[1] + 0x19) & 8) != 0)))))))) &&
             ((((*(byte *)(param_2[1] + 0x11) & 0x40) != 0 &&
               (((*(byte *)(param_2[1] + 0x1d) & 1) != 0 &&
                ((*(byte *)(param_2[1] + 0x21) & 0x40) != 0)))) &&
              (((*(byte *)(param_2[1] + 0x1b) & 0x40) != 0 &&
               ((((((((((*(byte *)(param_2[1] + 0x19) & 1) != 0 &&
                       ((*(byte *)(param_2[1] + 10) & 1) == 0)) &&
                      ((*(byte *)(param_2[1] + 4) & 2) == 0)) &&
                     ((((*(byte *)(param_2[1] + 0x28) & 4) != 0 &&
                       ((*(byte *)(param_2[1] + 8) & 2) != 0)) &&
                      (((*(byte *)(param_2[1] + 0xf) & 2) == 0 &&
                       (((*(byte *)(param_2[1] + 0xe) & 1) != 0 &&
                        ((*(byte *)(param_2[1] + 10) & 4) == 0)))))))) &&
                    ((*(byte *)(param_2[1] + 0x2a) & 8) != 0)) &&
                   (((((*(byte *)(param_2[1] + 0x32) & 8) == 0 &&
                      ((*(byte *)(param_2[1] + 0x26) & 0x10) != 0)) &&
                     ((*(byte *)(param_2[1] + 0x32) & 1) != 0)) &&
                    ((((*(byte *)(param_2[1] + 2) & 0x10) == 0 &&
                      ((*(byte *)(param_2[1] + 0x33) & 1) != 0)) &&
                     ((((*(byte *)(param_2[1] + 0x2c) & 4) == 0 &&
                       (((*(byte *)(param_2[1] + 0x1d) & 0x40) != 0 &&
                        ((*(byte *)(param_2[1] + 0x10) & 0x40) != 0)))) &&
                      ((*(byte *)(param_2[1] + 0x18) & 0x10) != 0)))))))) &&
                  ((((((((*(byte *)(param_2[1] + 0x12) & 0x20) != 0 &&
                        ((*(byte *)(param_2[1] + 0x12) & 0x40) == 0)) &&
                       ((*(byte *)(param_2[1] + 0x14) & 0x40) != 0)) &&
                      (((*(byte *)(param_2[1] + 0x20) & 0x40) == 0 &&
                       ((*(byte *)(param_2[1] + 0xb) & 4) != 0)))) &&
                     ((*(byte *)(param_2[1] + 3) & 0x20) != 0)) &&
                    (((*(byte *)(param_2[1] + 2) & 0x20) == 0 &&
                     ((*(byte *)(param_2[1] + 7) & 0x40) != 0)))) &&
                   (((*(byte *)(param_2[1] + 0x29) & 2) != 0 &&
                    ((((*(byte *)(param_2[1] + 0x31) & 0x10) == 0 &&
                      (((int)*(char *)(param_2[1] + 9) & 0x80U) == 0)) &&
                     ((*(byte *)(param_2[1] + 0x30) & 2) == 0)))))))) &&
                 (((((*(byte *)(param_2[1] + 0x18) & 2) == 0 &&
                    ((*(byte *)(param_2[1] + 0x24) & 0x40) != 0)) &&
                   ((*(byte *)(param_2[1] + 0x11) & 1) == 0)) &&
                  (((*(byte *)(param_2[1] + 0x12) & 0x10) != 0 &&
                   ((*(byte *)(param_2[1] + 0x13) & 0x10) != 0)))))) &&
                ((((*(byte *)(param_2[1] + 0x32) & 0x20) != 0 &&
                  ((((*(byte *)(param_2[1] + 0x28) & 0x20) != 0 &&
                    ((*(byte *)(param_2[1] + 0x2c) & 0x40) != 0)) &&
                   ((*(byte *)(param_2[1] + 0x33) & 8) != 0)))) &&
                 ((((*(byte *)(param_2[1] + 0xe) & 4) != 0 &&
                   (((int)*(char *)(param_2[1] + 6) & 0x80U) == 0)) &&
                  (((*(byte *)(param_2[1] + 0x11) & 8) == 0 &&
                   ((((*(byte *)(param_2[1] + 0x16) & 8) != 0 &&
                     ((*(byte *)(param_2[1] + 0x21) & 2) == 0)) &&
                    (((*(byte *)(param_2[1] + 0x14) & 1) == 0 &&
                     (((((*(byte *)(param_2[1] + 6) & 1) == 0 &&
                        ((*(byte *)(param_2[1] + 0x13) & 0x20) != 0)) &&
                       (((int)*(char *)(param_2[1] + 8) & 0x80U) == 0)) &&
                      (((*(byte *)(param_2[1] + 0x10) & 8) != 0 &&
                       ((*(byte *)(param_2[1] + 0xf) & 0x20) != 0)))))))))))))))))))))) &&
            (((*(byte *)(param_2[1] + 0xb) & 8) == 0 &&
             ((((*(byte *)(param_2[1] + 0x18) & 8) != 0 &&
               ((*(byte *)(param_2[1] + 0xe) & 0x40) != 0)) &&
              (((*(byte *)(param_2[1] + 0x28) & 8) != 0 &&
               (((*(byte *)(param_2[1] + 0x31) & 1) != 0 &&
                ((*(byte *)(param_2[1] + 0x2c) & 1) != 0)))))))))))))))) {
        printf(s_Wow_you_found_my_flag!_00603802);
        uVar1 = 0;
      }
      else {
        printf(s_This_is_not_my_flag!_0060381a);
        uVar1 = 1;
      }
    }
    else {
      printf(s_%s:_fatal_error:_flag_has_bad_le_006037dc,*param_2);
      uVar1 = 2;
    }
  }
  else {
    printf(s_%s:_fatal_error:_no_input_flag_006037bc,*param_2);
    uVar1 = 2;
  }
  return uVar1;
}
```
{% endraw %}
</details>

The part of the logic that first struck me was the last part which prints the error/success
messages. The same is shown in the image below. The part marked with (a) just prints that 
we have found the flag and all the other paths lead to one or the other error message.  

![Main logic part][9]

This means that we need to be able to pass some argument which passes the humongous condition
which when true prints the success message. What !? How is it even possible to do such a thing ?  

We I too had similar reaction and tried lots of crazy stuffs like just taking the hex values
converting them to integers and looking up their ASCII characters in a hope that it was the
real challenge. Nothing did work out.  

So we had effectively hit a roadblock and when we get stuck the Web comes to our rescure. I 
resorted to web searches which went by the lines **'Equation solver in python'**, 
**'Find values satisfying an equation'** etc.  

After a trail of searches I landed on a Python tool from Microsoft called [z3 solver][10]. This
was a theorem prover or in more sane terms an equation solver. It seemed intriguing and also had
mentions in a lot of CTF write-ups at [CTFTime][12] for challenges that had similar equation 
solving at the heart of it.  

Now I knew we need to use some equation solver but what is the equation that we need to solve ?  

Looking into the long check I tried to wrap my head around it a bit. I took it part by part and
that is exactly how I will break the code for you.

To start with we are presented with a check **`param_1 == 2`** which needs to evaluate to **`true`**
in order to be let into the check. Also the **`else`** part of this check presented us with an error
message that indicated that we need to enter atleast one parameter. This means it was an **`argc`** 
check. Remember the default input fields for the **`main`** method, right the **`argc`** and **`argv`**.
The **`param_1`** corresponded to **`argc`** and **`param_2`** corresponded to **`argv`**.  

So to pass this check all we had to do was pass some parameter which verifies with our initial 
random execution of the binary.  

Next was a check of **`strlen((char*)param_2[1] == 0x34)`**. This means that the length of whatever was
the parameter that we had to send was **`52`** characters. We can verify this by sending in some random
string of exactly **`52`** characters in length which would produce the message stating that it was not
the correct flag instead of the message that states bad length.  

Now we need to address the huge equation. Let us taken the first few parts of the equation:  
{% raw %}
```java
if ((((((((((
    (*(byte *)(param_2[1] + 0x1c) & 0x20) == 0) &&
    ((*(byte *)(param_2[1] + 0x24) & 0x10) != 0)) &&
    ((*(byte *)(param_2[1] + 0x2f) & 0x20) != 0)) &&
    (((*(byte *)(param_2[1] + 0x20) & 0x20) != 0 &&
    ((*(byte *)(param_2[1] + 0x2b) & 4) != 0)))) &&
    ...
    ...
```
{% endraw %}

On seeing the equation we actually find the following points upfront:
1. Each condition was identical in the sense that:
   - it took a specific character from the string
   - performed a bitwise **`&`** operation with some number
   - finally checked if the result was equal to **`0`** in some cases and otherwise in some cases
2. Next each of the conditions were all connected with the logical **`&&`** operator. What this meant
   is that we can squash out all the brackets used to group the parts. It was just equivalent to all
   equations connected by a logical **`&&`** as one huge equation. The order does not matter.
3. There were one or two exceptions mentioned below but they were just variants of the above meant to
   confuse us.
   - some parts had no equality check which inherently means that it check if the result is **`0`**.
   - some parts used decimal number or unsigned integers to provide either the offset or the value to
     perform the bitwise operation.
   - this meant we had to be a bit more careful while feed int the equation.  

So now we have the required parts:
1. The tool to be used to solve an equation.
2. A basic understanding of how to use it.
3. A thorough understanding of the actual equation to be solved.

How do we even feed in such an equation to the solver ? Well this is where our creative skills come into
play. I first just copied the whole equation to a text editor and applied few regex based find and replace
to extract the required parts:
1. The offset in the string
2. The value used to perform a bitwise **`&`** with indication as to whether it was decimal or hex
3. Whether it checked for an equal, not equal to 0 or did not check anything.

I formed this data a list of Python tuples which can then be iterated and fed into the [**`z3.add()`**][13]
method to actually form the equation. The execution of the code with the result can be seen below:

![Solver execution][14]

<details markdown="block">
  <summary>
  Click here to view the <b>solver.py</b> file
  </summary>

```python
from z3 import *

inp = BitVecs(" ".join(["inp_" + str(idx) for idx in range(53)]), 8)

s = Solver()
y = BitVecVal(5, 8)

vals = [
    (0x1C, 0x20, True),
    (0x24, 0x10, False),
    (0x2F, 0x20, False),
    (0x20, 0x20, False),
    (0x2B, 4, False),
    (0x32, 0x80, True),
    (0x2E, 4, False),
    (0x20, 0x80, True),
    (8, 4, True),
    (0x30, 0x10, False),
    (0x10, 0x80, True),
    (0x13, 8, True),
    (8, 0x40, False),
    (0x2B, 0x10, False),
    (0xF, 4, False),
    (0, 4, True),
    (0x2B, 8, True),
    (0x19, 0x40, False),
    (4, 1, False),
    (0x2B, 0x80, True),
    (0x2C, 8, True),
    (0x21, 0x20, False),
    (0x1D, 0x10, True),
    (0x21, 1, False),
    (0x1C, 0x40, False),
    (0x17, 0x40, False),
    (0x18, 1, False),
    (0x27, 0x20, False),
    (0x25, 4, True),
    (0xD, 0x80, True),
    (0x31, 0x20, False),
    (9, 4, False),
    (7, 0x20, False),
    (0x30, 4, True),
    (0x12, 4, True),
    (0x2D, 4, True),
    (0x1E, 0x10, False),
    (7, 0x10, True),
    (0x31, 0x40, False),
    (2, 0x80, True),
    (0xC, 0x40, False),
    (0x25, 8, True),
    (0x1D, 8, True),
    (0x1D, 0x20, False),
    (0x32, 2, False),
    (0x2D, 1, True),
    (10, 0x10, False),
    (0x28, 0x80, True),
    (0x12, 2, True),
    (0x2B, 1, False),
    (0x1A, 0x80, True),
    (0x33, 0x80, True),
    (0x14, 4, False),
    (0x1E, 8, False),
    (4, 0x10, True),
    (4, 0x80, True),
    (0x15, 0x40, False),
    (0x17, 0x80, True),
    (0xC, 0x10, False),
    (0x29, 1, False),
    (0xD, 0x20, False),
    (0x24, 1, True),
    (1, 1, True),
    (0x13, 0x80, True),
    (5, 0x80, True),
    (0x32, 0x40, True),
    (8, 0x10, False),
    (0x23, 8, True),
    (9, 8, True),
    (0, 2, False),
    (0x15, 0x80, True),
    (7, 1, True),
    (0x29, 8, False),
    (3, 0x80, True),
    (0xE, 2, False),
    (0x16, 2, False),
    (0x17, 1, False),
    (0x27, 2, False),
    (0x10, 0x20, True),
    (6, 8, True),
    (0x1A, 1, True),
    (0x1E, 4, False),
    (0x1A, 2, False),
    (0x1E, 0x80, True),
    (0x16, 0x80, True),
    (0x23, 0x10, True),
    (0x30, 1, False),
    (0x21, 4, False),
    (4, 4, False),
    (0x24, 0x80, True),
    (0x1F, 8, False),
    (1, 2, True),
    (0x22, 4, False),
    (0x10, 1, False),
    (3, 0x10, True),
    (0x16, 0x10, False),
    (0x2A, 1, False),
    (0xB, 1, False),
    (1, 0x10, False),
    (2, 4, False),
    (10, 8, True),
    (0x13, 1, False),
    (0x24, 8, True),
    (4, 8, True),
    (2, 1, True),
    (0x1B, 0x10, True),
    (9, 1, False),
    (0xD, 2, True),
    (5, 0x20, False),
    (0x11, 0x10, True),
    (0xD, 0x10, False),
    (0xD, 0x40, False),
    (3, 4, False),
    (7, 2, False),
    (0x10, 2, False),
    (0x20, 8, True),
    (0x23, 2, True),
    (0x31, 8, True),
    (0x1B, 4, False),
    (0x2F, 0x80, True),
    (0xD, 8, False),
    (1, 0x80, True),
    (0x26, 0x80, True),
    (0x24, 4, True),
    (0x33, 0x10, False),
    (0x17, 0x20, True),
    (6, 2, False),
    (0x23, 0x80, True),
    (0x14, 0x20, False),
    (9, 0x20, False),
    (0x2D, 0x20, False),
    (0xC, 2, False),
    (6, 0x10, False),
    (0x22, 8, False),
    (0x1A, 0x20, False),
    (0x17, 2, True),
    (0xE, 0x10, True),
    (0xC, 8, False),
    (0x22, 0x80, True),
    (0x10, 4, False),
    (3, 2, True),
    (0x31, 2, False),
    (0x16, 0x20, True),
    (0x15, 0x20, False),
    (0x29, 0x20, True),
    (0x25, 2, False),
    (0x12, 0x80, True),
    (7, 4, False),
    (0x2F, 4, False),
    (10, 2, True),
    (0xB, 0x80, True),
    (0x20, 4, True),
    (0x26, 0x40, False),
    (0, 0x10, True),
    (2, 0x40, False),
    (0x1C, 0x80, True),
    (0x2B, 0x40, False),
    (0x2F, 8, False),
    (0x2C, 0x20, False),
    (0x18, 0x20, False),
    (9, 2, False),
    (6, 4, True),
    (0x31, 4, True),
    (0, 8, True),
    (0xB, 0x40, False),
    (5, 1, False),
    (0x14, 8, False),
    (0x2F, 0x40, False),
    (0x26, 8, False),
    (0x19, 4, False),
    (0x21, 0x80, True),
    (5, 8, True),
    (0x28, 0x10, True),
    (0x19, 0x10, False),
    (0x25, 1, False),
    (2, 8, True),
    (0x2A, 0x40, False),
    (9, 0x10, False),
    (0x2E, 0x80, True),
    (0x29, 4, False),
    (0x29, 0x10, False),
    (0x1D, 0x80, True),
    (0, 0x20, True),
    (0x25, 0x40, True),
    (0x19, 0x80, True),
    (0x17, 0x10, True),
    (0x1B, 1, True),
    (0xF, 0x10, False),
    (0x1F, 0x40, False),
    (0x2A, 0x10, True),
    (10, 0x20, False),
    (0x30, 0x40, True),
    (0xF, 0x80, True),
    (0x1C, 8, True),
    (0x27, 1, False),
    (0x28, 2, False),
    (0x32, 4, True),
    (0x27, 0x10, False),
    (0x2A, 4, False),
    (0x2D, 8, False),
    (0xD, 4, True),
    (0x33, 0x20, False),
    (0x15, 8, True),
    (0x20, 2, True),
    (0x1D, 4, False),
    (0x1E, 1, False),
    (0x2C, 2, False),
    (3, 8, False),
    (10, 0x80, True),
    (0x33, 2, True),
    (0x26, 1, False),
    (0x13, 0x40, False),
    (0x27, 0x40, False),
    (0x1B, 0x20, False),
    (0x2D, 0x40, False),
    (2, 2, False),
    (0x1B, 8, False),
    (0xB, 0x10, False),
    (0x18, 0x40, False),
    (5, 2, True),
    (0x19, 2, False),
    (0x1A, 0x40, False),
    (0x18, 4, True),
    (4, 0x40, False),
    (0x2F, 0x10, True),
    (0x29, 0x40, False),
    (0x22, 0x10, False),
    (0x23, 0x40, False),
    (5, 4, True),
    (0x15, 2, True),
    (0x2D, 0x10, True),
    (0x24, 2, False),
    (0x28, 0x40, False),
    (0x15, 4, False),
    (0x13, 4, False),
    (0xC, 0x80, True),
    (0x2A, 2, True),
    (1, 8, True),
    (0x10, 0x10, False),
    (0x23, 4, True),
    (0xD, 1, False),
    (1, 0x40, False),
    (0x2E, 1, False),
    (0x1F, 0x10, False),
    (0x26, 4, False),
    (0x2F, 2, False),
    (0x26, 2, False),
    (0x25, 0x80, True),
    (0x1C, 2, True),
    (10, 0x40, True),
    (0x2E, 0x10, False),
    (0x27, 0x80, True),
    (0x2E, 0x20, True),
    (0x1F, 1, False),
    (0x25, 0x10, False),
    (0, 1, False),
    (0x11, 0x20, False),
    (0xB, 0x20, False),
    (0x31, 0x80, True),
    (0x12, 8, True),
    (0x16, 0x40, False),
    (0x1C, 4, True),
    (0xE, 8, False),
    (0x30, 8, True),
    (6, 0x40, False),
    (0xC, 0x20, True),
    (0x30, 0x20, False),
    (0x1F, 4, True),
    (0x2E, 0x40, False),
    (0x21, 8, True),
    (0x2A, 0x80, True),
    (0xF, 1, False),
    (0x18, 0x80, True),
    (0xC, 4, False),
    (0x15, 0x10, True),
    (0x15, 1, True),
    (0x1F, 0x20, False),
    (0x1A, 4, False),
    (0x33, 0x40, False),
    (0x2A, 0x20, False),
    (0xC, 1, False),
    (0xF, 8, True),
    (0x1B, 0x80, True),
    (0x22, 2, False),
    (6, 0x20, False),
    (0x17, 8, False),
    (0x27, 4, True),
    (0x12, 1, True),
    (0x20, 0x10, False),
    (0x1C, 1, True),
    (0x2E, 2, False),
    (0xB, 2, False),
    (0x1C, 0x10, True),
    (0x1D, 2, False),
    (0x2F, 1, True),
    (0x11, 4, False),
    (0xE, 0x20, False),
    (0x2B, 2, True),
    (0x1F, 0x80, True),
    (0x1F, 2, True),
    (0x23, 0x20, True),
    (0xF, 0x40, False),
    (0x1E, 0x20, True),
    (0x2D, 0x80, True),
    (9, 0x40, False),
    (7, 8, False),
    (0, 0x80, True),
    (0x26, 0x20, True),
    (0x25, 0x20, False),
    (0x16, 1, False),
    (0x32, 0x10, False),
    (0x33, 4, False),
    (0x2C, 0x10, True),
    (0x19, 0x20, True),
    (0x22, 0x20, True),
    (0x2C, 0x80, True),
    (5, 0x10, True),
    (0, 0x40, False),
    (0x14, 0x10, True),
    (8, 8, False),
    (0x11, 0x80, True),
    (0x23, 1, False),
    (0x21, 0x10, False),
    (0x20, 1, True),
    (0x27, 8, True),
    (4, 0x20, False),
    (0x16, 4, False),
    (0xE, 0x80, True),
    (0x14, 0x80, True),
    (0x14, 2, False),
    (0x17, 4, False),
    (0x2B, 0x20, False),
    (0x22, 1, False),
    (0x24, 0x20, False),
    (0x2E, 8, False),
    (0x1E, 2, False),
    (8, 0x20, False),
    (0x11, 2, False),
    (0x1B, 2, True),
    (0x13, 2, True),
    (7, 0x80, True),
    (3, 1, True),
    (1, 0x20, True),
    (0x1E, 0x40, False),
    (5, 0x40, False),
    (0x22, 0x40, False),
    (0x1A, 0x10, True),
    (3, 0x40, False),
    (0x29, 0x80, True),
    (0x28, 1, False),
    (0x2D, 2, True),
    (1, 4, False),
    (0x1A, 8, True),
    (0x30, 0x80, True),
    (0x19, 8, False),
    (0x11, 0x40, False),
    (0x1D, 1, False),
    (0x21, 0x40, False),
    (0x1B, 0x40, False),
    (0x19, 1, False),
    (10, 1, True),
    (4, 2, True),
    (0x28, 4, False),
    (8, 2, False),
    (0xF, 2, True),
    (0xE, 1, False),
    (10, 4, True),
    (0x2A, 8, False),
    (0x32, 8, True),
    (0x26, 0x10, False),
    (0x32, 1, False),
    (2, 0x10, True),
    (0x33, 1, False),
    (0x2C, 4, True),
    (0x1D, 0x40, False),
    (0x10, 0x40, False),
    (0x18, 0x10, False),
    (0x12, 0x20, False),
    (0x12, 0x40, True),
    (0x14, 0x40, False),
    (0x20, 0x40, True),
    (0xB, 4, False),
    (3, 0x20, False),
    (2, 0x20, True),
    (7, 0x40, False),
    (0x29, 2, False),
    (0x31, 0x10, True),
    (9, 0x80, True),
    (0x30, 2, True),
    (0x18, 2, True),
    (0x24, 0x40, False),
    (0x11, 1, True),
    (0x12, 0x10, False),
    (0x13, 0x10, False),
    (0x32, 0x20, False),
    (0x28, 0x20, False),
    (0x2C, 0x40, False),
    (0x33, 8, False),
    (0xE, 4, False),
    (6, 0x80, True),
    (0x11, 8, True),
    (0x16, 8, False),
    (0x21, 2, True),
    (0x14, 1, True),
    (6, 1, True),
    (0x13, 0x20, False),
    (8, 0x80, True),
    (0x10, 8, False),
    (0xF, 0x20, False),
    (0xB, 8, True),
    (0x18, 8, False),
    (0xE, 0x40, False),
    (0x28, 8, False),
    (0x31, 1, False),
    (0x2C, 1, False),
]


def getexpr(offset: int, bitwiseval: int, is_equal_zero: True):
    global inp

    if is_equal_zero is None:
        return inp[1 + offset] & BitVecVal(bitwiseval, 8)
    elif is_equal_zero:
        return (inp[1 + offset] & BitVecVal(bitwiseval, 8)) == 0
    else:
        return (inp[1 + offset] & BitVecVal(bitwiseval, 8)) != 0


s.add(And([getexpr(off, bw, is_eq) for (off, bw, is_eq) in vals]))

print(s.check())
print(s.model())
```
</details>

The above solves the equation for us and gives us with an array with the
input id denoted by **`inp_<index of character>`** (eg: **`inp_10`**). We need
to copy the resulting model, sort it by the **`index`** and then convert each
integer to its character. I used a some regex to format the output as a list of 
Python tuples and then process it with a small Python snippet.

<details markdown="block">
  <summary>
  Click here to view the snippet
  </summary>

```python
# output obtained from Z3 solve.py
x = [("inp_16",117),("inp_50",99),("inp_1",67),("inp_31",95),("inp_21",110),("inp_44",117),
     ("inp_37",114),("inp_35",95),("inp_9",122),("inp_24",77),("inp_48",110),("inp_34",117),
     ("inp_51",51),("inp_19",48),("inp_49",49),("inp_20",117),("inp_15",111),("inp_28",108),
     ("inp_33",48),("inp_26",95),("inp_36",65),("inp_5",101),("inp_46",104),("inp_18",102),
     ("inp_47",95),("inp_27",102),("inp_43",109),("inp_17",95),("inp_4",108),("inp_41",111),
     ("inp_13",95),("inp_8",110),("inp_23",95),("inp_39",95),("inp_25",121),("inp_45",99),
     ("inp_38",51),("inp_12",119),("inp_30",103),("inp_52",125),("inp_40",115),("inp_11",48),
     ("inp_14",121),("inp_6",97),("inp_3",70),("inp_10",119),("inp_2",84),("inp_29",64),
     ("inp_42",95),("inp_32",121),("inp_22",100),("inp_7",114)]

# sort the list by the integer after inp_ in the 
# first entry of each tuple in the list
x.sort(key=lambda x: int(x[0].split("_")[1]))

# convert each value to its character and concatenate
"".join([chr(y) for z,y in x])
```
</details>

After the above we get a flag string as **`CTFlearnzw0w_you_f0und_My_fl@g_y0u_Ar3_so_much_n1c3}`**, but
the actual flag is of the format **`CTFlearn{...}`**. So I presume I had copied some specific value wrong
in the equation leading to this discrepancy, however it was obvious the **`z`** needs to be replaced with
**`{`**. The actual flag was **`CTFlearn{w0w_you_f0und_My_fl@g_y0u_Ar3_so_much_n1c3}`**.



[1]: https://ctflearn.com/challenge/download/921
[2]: https://mega.nz/file/lthQ0RRR#zfA_6iiM6Pd748BYGlqL6Yx6en3qAh6zYWclm51UqHQ
[3]: https://linuxhint.com/understanding_elf_file_format/
[4]: https://gcdn.pbrd.co/images/ceEWI2Wdu9jS.gif?o=1
[5]: https://ghidra-sre.org/
[6]: https://gcdn.pbrd.co/images/EJmhzdf8usvL.png?o=1
[7]: https://0xpat.github.io/Malware_development_part_6/
[8]: https://gcdn.pbrd.co/images/uWHZCffQaToe.gif?o=1
[9]: https://gcdn.pbrd.co/images/vOxmI7AdKVhU.png?o=1
[10]: https://github.com/Z3Prover/z3
[11]: http://theory.stanford.edu/~nikolaj/programmingz3.html
[12]: https://ctftime.org
[13]: http://theory.stanford.edu/~nikolaj/programmingz3.html#sec-logical-interface
[14]: https://gcdn.pbrd.co/images/XqH72wkzFtpS.gif?o=1