---
layout: default
title: GDB 🐞
nav_order: 3
description: "GDB - An introduction to GNU Debugger"
permalink: /ctftools/gdb
has_children: false
parent: CTF Tools
last_modified_at: 29-09-2021 11:05 PM +0530
---

## GNU Debugger 🐞
{: .no_toc}
Reversing
{: .label .label-green .fs-1 .ml-0}

The GDB or GNU Debugger is one of the command line utilities which can be used efficiently
to debug the execution of any unknown binary. It provides various facilities like stepping
through code execution, inspecting stack, registers etc. and also setting breakpoints at
specific address and/or function names.  

It also provides convenient commands to statically inspect the binary sections, its headers
and the symbol tables. Function names can be also extracted out from the binary to facilitate
setting breakpoints at known execution points.  

I generally use GDB in combination with [Ghidra][1] where in I prefer GDB for breakpoint and
dynamic analysis and Ghidra for disassembling and reconstruting the source code. Somehow the
execution of binary in Ghidra does not appeal me.  


## Table of contents
{: .no_toc .text-delta}

1. TOC
{:toc}


### Installing GDB  

Installing [GDB][2], the GNU Debugger is quite easy on Linux based systems. However if you are 
using Linux distro's focussed towards penetration testing like [Kali linux][3] or [Parrot OS][4], 
GDB would most probably be already available in your box.  

To test the same run **`gdb --version`** from your terminal. If the output gives details on the
version of GDB installed, then you are good to proceed further. Otherwise follow rest of this 
section.  

GDB can be installed using one of the below two methods:  
1. from pre-built packages available in your distro's package manager (recommended)
2. compile GDB from source and install

#### Pre-built installation

If you are running a Linux distribution with either **`yum`** or **`apt`** package manager, proceed
to install from your package manager.  

On a [Debian][5] based system with **`apt`** package manager run the below commands:  
```sh
$ sudo apt-get update
$ sudo apt-get install gdb
```  

On a [RedHat][6] based system with **`yum`** package manager run the below commands:  
```sh
$ sudo yum update
$ sudo yum install gdb
```  

Once the installation has succeeded re-open a new terminal and run the command **`gdb --version`**
to ensure that the installation is proper and usable.  

#### Compiling from sources

If you are not able to use the above method, or wish to use a recent version of GDB than available in
the official repository proceed with compiling from the sources.  

Download the latest release of GDB supported for your OS version from [here][7] and extract it. 
```sh
$ wget "http://ftp.gnu.org/gnu/gdb/gdb-7.11.tar.gz"
$ tar -xvzf gdb-7.11.tar.gz
```  

Configure GDB and compile it as per your system environment. This step will take quite some time and
you need to be patient and let the compilation complete.  
```sh
$ cd gdb-7.11
gdb-7.11/$ ./configure
gdb-7.11/$ make
```  

Install GDB now.  
```sh
$ make install
```  

Once the above steps completed without any errors, run the command **`gdb --version`** to ensure that
the installation is proper and usable.  


### Using GDB  

GDB is a debugger and a disassembler which supports a variety of binaries written in different languages.
A comprehensive list of languages supported by GDB is available [here][8]. To start GDB, we need to have
a supported binary with executable permissions and run the command **`gdb <path-to-binary>`**.  

This will load the binary into GDB in the background and provide us with the GDB prompt. The GDB prompt
is a new command line which takes in GDB specific commands using which we can analyze, debug and visualize
the control flow of the binary loaded.  

In general the below are the basic commands which are necessarily run to understand the binary:
- **`info functions`** : Prints all the functions available in the binary along with its address offset.
- **`br <function-name>`** : Sets a break point at the starting address of the given function name.
- **`disassemble <function-name>`** : Prints the machine op codes of the given function name along with the
  address offsets of each of the op codes.
- **`br *0x<hex-address>`** : This sets a breakpoint at the specified hex address.
- **`run <cmd-line-args-if-any>`** : It will run the binary with the args passed.
- **`continue`** : Continues to program execution untill the next breakpoint.
- **`step <number-of-lines>`** : This will step through execution for the specified number of lines. If number
  is not specified, it will step one line at a time.
- **`quit`** : Quits the GDB and falls back to the terminal prompt.

A complete reference of the GDB commands is available [here][9]. A more concise and easy to use cheat sheet
is available [here][10].  


### Installing PWNDBG  

Vanilla GDB is not user friendly and needs us to have a lot of knowledge on the base architecture of the OS on
which it is running and the behavior has to be understood with respect to the OS on which it is running. To 
overcome this problem and also provide some extra useful commands various plugins for GDB are developed.  

One of the widely used plugins is [pwndbg][11] which provides extra commands catered to pwning binaries. Also
it normalizes many architecture based differences that plague GDB. I highly recommend installing this plugin
as it gives a nice view of the stack, registers and program execution flow while hitting breakpoints or seg
faulting.  

To install pwndbg, refer [here][12]. The steps are pretty simple and need to be installed by compiling the
source. We can ensure the installation by running **`gdb`** with a binary again. This time the prompt for
**`gdb`** terminal would change to **`pwndbg`** instead of the previously seen **`gdb`** prompt.  


### Working with PWNDBG  

All commands that run on GDB will also run in PWNDBG terminal. So that way if you are used to GDB, you can
additionally install PWNDBG for the [extra commands][13] provided by it.  

One of the handy commands is **`cyclic <number-of-bytes>`**. This generates a cyclic pattern string which can
be given as input to a buffer overflow scenario. The use is that we can easily find the offset of the value
loaded into the required stack frame or register. This offset will help us to identify the number of bytes
after which our overflow payload should be put so that it fills the exact stack location that contains the
return address which will be called when the next **`RET`** instruction is executed.  

An example of the same can be viewed [here][14] which helps in solving one of the CTF challenges.  





[1]: ctftools/ghidra
[2]: https://www.gnu.org/software/gdb/
[3]: https://www.kali.org/
[4]: https://www.parrotsec.org/security-edition/
[5]: https://www.debian.org/
[6]: https://www.redhat.com/en
[7]: http://ftp.gnu.org/gnu/gdb/
[8]: https://www.gnu.org/software/gdb/
[9]: https://sourceware.org/gdb/current/onlinedocs/gdb/
[10]: http://www.gdbtutorial.com/gdb_commands
[11]: https://github.com/pwndbg/pwndbg
[12]: https://github.com/pwndbg/pwndbg#how
[13]: https://github.com/pwndbg/pwndbg/blob/dev/FEATURES.md
[14]: ../ctfs/downunder21#deadcode-%EF%B8%8F