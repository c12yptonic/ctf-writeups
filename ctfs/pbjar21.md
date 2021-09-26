---
layout: default
title: PBJar 2021
nav_order: 4
description: "Peanut Butter Jar 2021 CTF"
permalink: /ctfs/pbjar21
has_children: false
parent: CTF List
---

# Peanut Butter Jar CTF 2021
{: .no_toc}

This is one of the CTF's that beginners should surely attempt. The challenges, were
structured well. Some were easy and catered to the beginners and some hard ones were
actually informative and provided enough help during the course of solving it which
is really helpful for solving the challenges.  
{: .fs-5 .fw-300 }

However I attempted only a few and the solves for the same are available below. The
welcome flag was available in the discord channel #rules and the same was of the format
**`flag{...}`** with the actual flag being **`flag{thamks_for_joining_the_disc}`**.  
{: .fs-5 .fw-300 }

## Challenge list
{: .no_toc .text-delta}

1. TOC
{:toc}

## Convert 🔄
Miscellaneous
{: .label .label-green .fs-1 .ml-0}

This challenge was absolutely easy and meant to be for extreme beginners, probably those
who are attempting their first CTF. In this challenge we are given the below challenge
instructions and a zip file which contained only one text file with the contents also
mentioned below.

Challenge instructions:
> So this is supposed to be the challenge for absolute beginners. For this chall, you  
> will get a hexadecimal number, and have to convert it to text. If you don't know  
> how to do this, Google is your best friend!!! 

File contents:
```text
666c61677b6469735f69735f615f666c346767675f68317d
```

I am pretty sure most of them recognize it as a hexadecimal representation of a string or
rather atleast as a hexadecimal number. Also together with the challenge title it is clear
the flag is encoded in some manner as hexadecimal characters.  

There are many online utilities to convert a hexadecimal string to its actual ASCII
representation. Using one of them we can easily get the flag as **`flag{dis_is_a_fl4ggg_h1}`**.  

Also as this operation is pretty common and highly useful during CTF's, I have created the
below shell alias to convert any given hex string to its ASCII representation.  

```sh
hex2str() {
  if [ -z "$1" ]; then
    echo "Hex value not passed"
  else 
    if [ -z "$2" ]; then
      echo $1 | perl -CS -pe 's/[0-9A_Fa-f]{2}/chr(hex($&))/egi'
    else
      echo $1 | perl -CS -pe 's/[0-9A-Fa-f]{2}/chr(hex($&))/egi' > $2
    fi
  fi
}
```

We can source this file in our **`.bashrc`** file and use it as below:  
```sh
hex2str 666c61677b6469735f69735f615f666c346767675f68317d
flag{dis_is_a_fl4ggg_h1}
```


## Miner 👷
Blockchain
{: .label .label-green .fs-1 .ml-0}


There was a lot of focus on blockchain technology and gave me some exposure to various
terminologies of this tech. However the challenges in itself were pretty easy and more 
of OSINT style.  

To start with, this challenge was mainly focussed on finding the miner details of a specific
block in the Ethereum block chain. The challenge instructions are given below.

Challenge instructions:
> Block #11834380 on the Ethereum Blockchain was mined on Febuary 11th at 9:12:59 AM UTC.  
> What is the address of the miner who validated this block?   
> Flag format: flag{0x0000000000000000000000000000000000000000}  

To give a background, much of the details of public blockchains are available in their
respective websites. Here from the instructions it is very clear that we are dealing with
a specific block of the [**Ethereum**][1] blockchain.  

We can open up the website and search with any of the parameters like **block id**,
**transaction id**, **user id** and the like. Here we are given with a block id and on
searching for the same we land [here][2] the screen capture of which is shown below.

![Miner details of given block][3]

The final flag formed by obtaining the miner user id is:  
```text
flag{0xd224ca0c819e8e97ba0136b3b95ceff503b79f53}
```


## Read Flag 1 📒
Blockchain
{: .label .label-green .fs-1 .ml-0}

This is first of a series of blockchain based challenges. Again these were pretty easy and
more of an OSINT type of challenge.  

The challenge instructions for this challenge are given below and the instructions are 
sufficient to reach the flag.  

Challenge instructions:
> The address of my new smart contract is 0xf0674CD7D1C0c616063a786E7d1434340E09BadD, the  
> flag is inside it, and the code is published on Etherscan.  
> Important: This smart contract is on Ropsten  

We are given quite a few pieces of information in the instructions. The address of the contract
is available and the flag is part of the code used to publish this smart contract. Also this
smart contract seems to be available only in the test [**Ropsten**][4] network of Etherscan.  

We search for the given smart contract address and check the code for the smart contract. The same
can be seen by navigating [here][5] and read off the flag as **`flag{etherscan_S0urc3_c0de}`**.


## Read Flag 2 ⌨️
Blockchain
{: .label .label-green .fs-1 .ml-0}

After the easy to start with [Read Flag 1][13] challenge, this was a similar yet strategically
different one. Also as I am new to the blockchain technology I had to invest quite some time to
reach the correct facts for cracking the flag.  

The challenge instructions are the only thing available to us and the same is given below.  

Challenge instructions:
> I have republished the previous the contract at 0x585C403bC5c7eb62BF3630c7FeF1F837603bA866,  
> but this time no source code for you this time.   
> Luckily, the ABI of the smart contract is the same as the previous one.  
> Figure out how to "get()" the flag.  
> Important: This smart contract is on Ropsten  

After reading through the instructions, we understand that the smart contract can be viewed in the
Ropsten network similar to previous challenge. Heading over to the search by clicking the following
[link][14], we find this smart contracts code.  

As we are provided only with the byte code, we use the **Decompile byte code** option available in the
same page, which gives us the below code. 

<details markdown="block">
  <summary>
  Click here to view full decompiled code
  </summary>  

```python
#
#  Panoramix v4 Oct 2019 
#  Decompiled source of ropsten:0x585C403bC5c7eb62BF3630c7FeF1F837603bA866
# 
#  Let's make the world open source 
# 

def storage:
  stor0 is array of struct at storage 0

def _fallback() payable: # default function
  revert

def get() payable: 
  if bool(stor0.length):
      if bool(stor0.length) == stor0.length.field_1 < 32:
          revert with 'NH{q', 34
      if bool(stor0.length):
          if bool(stor0.length) == stor0.length.field_1 < 32:
              revert with 'NH{q', 34
          if stor0.length.field_1:
              if 31 < stor0.length.field_1:
                  mem[128] = uint256(stor0.field_0)
                  idx = 128
                  s = 0
                  while stor0.length.field_1 + 96 > idx:
                      mem[idx + 32] = stor0[s].field_256
                      idx = idx + 32
                      s = s + 1
                      continue 
                  return Array(len=2 * Mask(256, -1, stor0.length.field_1), data=mem[128 len ceil32(stor0.length.field_1)])
              mem[128] = 256 * stor0.length.field_8
      else:
          if bool(stor0.length) == stor0.length.field_1 < 32:
              revert with 'NH{q', 34
          if stor0.length.field_1:
              if 31 < stor0.length.field_1:
                  mem[128] = uint256(stor0.field_0)
                  idx = 128
                  s = 0
                  while stor0.length.field_1 + 96 > idx:
                      mem[idx + 32] = stor0[s].field_256
                      idx = idx + 32
                      s = s + 1
                      continue 
                  return Array(len=2 * Mask(256, -1, stor0.length.field_1), data=mem[128 len ceil32(stor0.length.field_1)])
              mem[128] = 256 * stor0.length.field_8
      mem[ceil32(stor0.length.field_1) + 192 len ceil32(stor0.length.field_1)] = mem[128 len ceil32(stor0.length.field_1)]
      if ceil32(stor0.length.field_1) > stor0.length.field_1:
          mem[ceil32(stor0.length.field_1) + stor0.length.field_1 + 192] = 0
      return Array(len=2 * Mask(256, -1, stor0.length.field_1), data=mem[128 len ceil32(stor0.length.field_1)], mem[(2 * ceil32(stor0.length.field_1)) + 192 len 2 * ceil32(stor0.length.field_1)]), 
  if bool(stor0.length) == stor0.length.field_1 < 32:
      revert with 'NH{q', 34
  if bool(stor0.length):
      if bool(stor0.length) == stor0.length.field_1 < 32:
          revert with 'NH{q', 34
      if stor0.length.field_1:
          if 31 < stor0.length.field_1:
              mem[128] = uint256(stor0.field_0)
              idx = 128
              s = 0
              while stor0.length.field_1 + 96 > idx:
                  mem[idx + 32] = stor0[s].field_256
                  idx = idx + 32
                  s = s + 1
                  continue 
              return Array(len=stor0.length % 128, data=mem[128 len ceil32(stor0.length.field_1)])
          mem[128] = 256 * stor0.length.field_8
  else:
      if bool(stor0.length) == stor0.length.field_1 < 32:
          revert with 'NH{q', 34
      if stor0.length.field_1:
          if 31 < stor0.length.field_1:
              mem[128] = uint256(stor0.field_0)
              idx = 128
              s = 0
              while stor0.length.field_1 + 96 > idx:
                  mem[idx + 32] = stor0[s].field_256
                  idx = idx + 32
                  s = s + 1
                  continue 
              return Array(len=stor0.length % 128, data=mem[128 len ceil32(stor0.length.field_1)])
          mem[128] = 256 * stor0.length.field_8
  mem[ceil32(stor0.length.field_1) + 192 len ceil32(stor0.length.field_1)] = mem[128 len ceil32(stor0.length.field_1)]
  if ceil32(stor0.length.field_1) > stor0.length.field_1:
      mem[ceil32(stor0.length.field_1) + stor0.length.field_1 + 192] = 0
  return Array(len=stor0.length % 128, data=mem[128 len ceil32(stor0.length.field_1)], mem[(2 * ceil32(stor0.length.field_1)) + 192 len 2 * ceil32(stor0.length.field_1)]), 
```
</details>  

I fiddled around some time with this code and tried to understand the same. I wasnt really successfull
in doing so. So I did start searching for the contract miner and the transaction details.  

The transaction in which this smart contract was created can be viewed [here][15] and the same is visible
as shown below.  

![Smart contract transaction link][16]  

In the transaction we can see a large hex string against the field **`Input data`**. I was curious to render
the hex as a string and just check if there is anything interesting hidden there. Also I found a handy option
to view the input data as **UTF-8** which would basically render the hex string into their equivalent ASCII
representation as interpreted by the browser.  

I was surprise when I found the flag in the last part of the input data. We could read off the final flag as
**`flag{web3js_plus_ABI_equalls_flag}`**. Refer the below image on how I could find the flag after navigating
to the transaction page link given above.  

![Smart contract transaction input data decoding][17]  


## Read Flag 3 ⛓
Blockchain
{: .label .label-green .fs-1 .ml-0}

The third of the blockchain series based challenges. This was again a pretty easy challenge. It
gave us and address to a [**Ropsten**][4] contract and a **`.sol`** file. The file was immaterial,
as the same source code is available in the web site too.  

Challenge instructions:
> 0xe2a9e67bdA26Dd48c8312ea1FE6a7C111e5D7a7A. Important: This smart contract is on Ropsten  

We navigate to this contract [here][6]. In this challenge, the flag was part of the constructor
arguments passed to the code. As the transaction execution information is also available to us
in the above link (a snap shot of which is available below) we read off the flag as 
**`flag{s3t_by_c0nstructor}`**.

![Read flag 3 constructor args][7]  


## Reallynot Secure Algorithm 🔏
Crypto
{: .label .label-green .fs-1 .ml-0}

From the challenge name itself, it is clear that the challenge per se has something to do with
RSA. In the challenge we are presented with the below instructions and a zip file which can be
downloaded [here][8].  

Challenge instructions:
> Here's the obligatory problem!!!  

The zip file consisted of a Python script **`script.py`** and its output **`out.txt`**. Both are
shown below.

**script.py**  
```python
from Crypto.Util.number import *
with open('flag.txt','rb') as f:
    flag = f.read().strip()
e=65537
p=getPrime(128)
q=getPrime(128)
n=p*q
m=bytes_to_long(flag)
ct=pow(m,e,n)


print (p)
print (q)
print (e)
print (ct)
```  

**out.txt**  
```text
194522226411154500868209046072773892801 #p
288543888189520095825105581859098503663 #q
65537                                   #e
2680665419605434578386620658057993903866911471752759293737529277281335077856  #ct
```  

As per the script and the output we are clear that we are provided with specific encryption
parameters like (**`p`**, **`q`**) the prime factors of the public key, **`e`** the exponent
and **`ct`** the ciphertext. Our goal is to find the plain text from the same.  

In general the Swiss Army tool for anything related to Crypto is the [**RsaCtfTool**][9]. More
so this being a beginner focussed challenge, I necessarily wanted to run the parameters through
the tool and the flag was available due to weakness in the chosen primes.  

The command used is given below:  
```sh
python3 ~/Tools/RsaCtfTool/RsaCtfTool.py -p 194522226411154500868209046072773892801 \
 -q 288543888189520095825105581859098503663 -e 65537 \
 --uncipher 2680665419605434578386620658057993903866911471752759293737529277281335077856
```  

The final flag is **`flag{n0t_to0_h4rd_rIt3_19290453}`** and the cracking can be
viewed below.

![RsaCtfTool cracking the challenge][10]


## cOrL 📶
Web
{: .label .label-green .fs-1 .ml-0}

This was a web category challenge where in we are presented with a web page to login as **`admin`**.
It was pretty straight forward to try out passwords like **`admin`**, **`password`** etc., as the
challenge instructions also indicate that the password is a really common one.  

Challenge instructions:
> Descriptions are hard give me a break.  
> (Think of common usernames and passwords for admin)  
> Link: http://147.182.172.217:42003/ 

On using the password and username as **`admin`** we get a different error message that reads as below:
> the admin must have **put** some additional security protections here  

The word **`put`** was specifically highlighted in the error message and also matches one of the 
[HTTP request methods][11]. So I was lead to resend the same request using the **`PUT`** request 
method instead of **`POST`**. Also technically the two request methods do not differ except for
the header value and a philosophical difference wherein **`PUT`** is used for updating a record
and **`POST`** is used for creating a new record.  

Doing the above gives us the required flag **`flag{HTTP_r3qu35t_m3th0d5_ftw}`**. The complete
action can be seen below.

![Request sent with PUT method][12]




[1]: https://www.etherchain.org
[2]: https://www.etherchain.org/block/11834380
[3]: https://gcdn.pbrd.co/images/GEHCl5xgqirQ.png?o=1
[4]: https://ropsten.etherscan.io
[5]: https://ropsten.etherscan.io/address/0xf0674CD7D1C0c616063a786E7d1434340E09BadD#code
[6]: https://ropsten.etherscan.io/address/0xe2a9e67bdA26Dd48c8312ea1FE6a7C111e5D7a7A#code
[7]: https://gcdn.pbrd.co/images/XSPqjBiuOohc.png?o=1
[8]: https://mega.nz/file/R94gATrC#CXC9VoZ87O3jtTVE-XgZXOtofzre5WiPx8gJSYRz9ww
[9]: https://github.com/Ganapati/RsaCtfTool
[10]: https://gcdn.pbrd.co/images/jSRBQbcvExnr.gif?o=1
[11]: https://developer.mozilla.org/en-US/docs/Web/HTTP/Methods
[12]: https://gcdn.pbrd.co/images/piswRHIQRxRl.gif?o=1
[13]: #read-flag-1-
[14]: https://ropsten.etherscan.io/address/0x585C403bC5c7eb62BF3630c7FeF1F837603bA866#code
[15]: https://ropsten.etherscan.io/tx/0xa50cc4d707d8874e2494148ec2bab6138977838783ea200a45a8269384faaed4
[16]: https://gcdn.pbrd.co/images/TE7Hae6kdYue.png?o=1
[17]: https://gcdn.pbrd.co/images/Rsn4XIbQgCBn.gif?o=1