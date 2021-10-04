---
layout: default
title: DeconstruCtf 2021
nav_order: 8
description: "Deconstruct CTF 2021 from VIT Vellore"
permalink: /ctfs/deconstructf21
has_children: false
parent: CTF List
last_modified_date: 04-10-2021 01:07 PM +0530
---

# DeconstruCTF 2021
{: .no_toc}  

Dconstruct CTF 2021 is the first CTF hosted by [GDSCVIT][1] from the Vellore Institute of Technology in Tamil
Nadu. To say the least, this was one of the best developer and pro friendly CTF's I have participated in till
date with some really good learning in the course of solving the challenges.  
{: .fs-5 .fw-300 }  

There we three waves of challenges that were released with a bit of skewed weightage to [Web][2] and [Crypto][3]
challenges. On the whole it was a really good managed and balance first CTF hosted. All kudos to the team behind
hosting such a fruitful event.  
{: .fs-5 .fw-300 }  

From the rules it was clear that the flags were always of the format **`dsc{...}`** and are defined by the regex
**`/^dsc{.*}$/`**. The sample flag **`dsc{th1s_i5_4_s4mpl3_fl4g’+!-.@#$%?}`** was also provided in the rules section.  
{: .fs-5 .fw-300 }  

I would be grouping the challenges category wise as there are quite a few challenges for which I would be writing the
solutions here.  
{: .fs-5 .fw-300 }  

## Challenge list
{: .no_toc .text-delta}

1. TOC
{:toc}


## Pirates 🏴‍☠️
Forensics  
{: .label .label-green .fs-1 .ml-0}

This was the first challenge under the Forensics category and as expected was a network capture challenge. We are 
provided with a network packet capture file which can be downloaded [here][4] and the below challenge instructions.

Challenge instructions:  
> Mr.Reed and his pirating ring has finally been caught by the police but unfortunately we dont have enough evidence  
> to indict him. All we could get is a network capture of his private network.Can you find any evidence to be used  
> against him ?  

My normal way to analyze a packet capture file is to use [Wireshark][5]. I quickly loaded the file into Wireshark and
started analyzing the packets. Looking at the protocol hierarchy from the **`Statistics`** menu we can see that there
are few HTTP packets which is where generally the application data is available.  

Filtering the packets by HTTP protocol reduces the search space to just 15 packets. Analyzing the packet data, we see
that the #frame 59 has the required flag in its data content as seen below.  

![Flag frame packet screen grab][6]  

The final flag as seen in the above image was **`dsc{H3_1S_th3_83sT_p1r4t3_1_H4V3_3V3r_s33n}`**.

## The Missing Journalist 🕵️‍♂️
Forensics
{: .label .label-green .fs-1 .ml-0}

The second challenge under forensics category, was easy to overlook and get lost in it. During my first attempt I saw
pieces of information but in my second try at the challenge I got to it.  

So we are given a lengthy prelude to the challenge as part of the challenge instructions as seen below along with a 
**`.gif`** file which can be downloaded [here][7].  

Challenge instructions:
> It's been a year since you've been a private investigator and you've made quite a name for yourself.  
> You sit there thinking about all the weird cases you've managed in the last year when suddenly, a   
> person bursts through your door saying something about her missing husband. You finally gather that  
> her husband, a renowned journalist who was tracking down a serial killer has suddenly gone missing  
> since last night. The hysterical wife has provided you with a picture of how he looks like.  
> Do you take the case?  

With above details we set off to solve the challenge. For any forensics challenge, we should as a rule of thumb use 
**`exiftool`** and **`binwalk`** if the challenge provides us with a file. Why so ?  

Well in general forensics challenges or in general any challenge where a file is given as part of the challenge 
instructions it is necessary to understand what the file contains and what the file contains is not what the file is
detected as by the OS. This is because the OS reads the first known magic byte and if the file can be read in that format
it is rendered without any errors. This does not mean that there arent any hidden parts to it. So **`exiftool`** extracts
any meta data associated with the file and **`binwalk`** basically walks through the byte values of the file and reports
any file type magic bytes detected. But the output of **`binwalk`** might some times be spurious as it relies on small
chunks of magic bytes which can be found normally in any other file too.  

As I had the above background I went ahead and ran the above two tools to get the below output.  
```sh
┌──(cryptonic㉿cryptonic-kali)-[~/CTFs/deconstructf/missingjounralist]
└─$ binwalk the_journalist.gif

DECIMAL       HEXADECIMAL     DESCRIPTION
--------------------------------------------------------------------------------
0             0x0             GIF image data, version "89a", 498 x 314
2267488       0x229960        Zip archive data, at least v1.0 to extract, name: message/
2267526       0x229986        Zip archive data, at least v2.0 to extract, compressed size: 112074, uncompressed size: 113455, name: message/message.pdf
2379840       0x245040        End of Zip archive, footer length: 22

                                                                                                                                                                
┌──(cryptonic㉿cryptonic-kali)-[~/CTFs/deconstructf/missingjounralist]
└─$ exiftool the_journalist.gif
ExifTool Version Number         : 12.16
File Name                       : the_journalist.gif
Directory                       : .
File Size                       : 2.3 MiB
File Modification Date/Time     : 2021:10:01 13:58:32+05:30
File Access Date/Time           : 2021:10:02 18:57:02+05:30
File Inode Change Date/Time     : 2021:10:01 13:58:51+05:30
File Permissions                : rw-r--r--
File Type                       : GIF
File Type Extension             : gif
MIME Type                       : image/gif
GIF Version                     : 89a
Image Width                     : 498
Image Height                    : 314
Has Color Map                   : Yes
Color Resolution Depth          : 8
Bits Per Pixel                  : 6
Background Color                : 0
Animation Iterations            : Infinite
XMP Toolkit                     : Image::ExifTool 10.40
Creator                         : Anish Raghavendra
Rights                          : aDNfdzQ1X2w0NXRfczMzbl80dF90aDRfbTB2MTM1
Title                           : The Journalist
Frame Count                     : 40
Duration                        : 4.00 s
Image Size                      : 498x314
Megapixels                      : 0.156
```  

Both the outputs give us valuable pieces of information.  

### Output from **`binwalk`**:
{: .no_toc}

The output from binwalk suggests that the **`.gif`** file
contains a **`.zip`** file hidden inside it and that the **`.zip`** file contains a file **`message/message.pdf`**.
This can be trusted due to the following reasons:  
1. it has found the **Magic Byte** for start of Zip data sections
2. also it has found the end of Zip archive **Magic Bytes** too
3. it also suggests the file path contained within it

With the above it is clear that there is a **`.zip`** file hidden where in the zip header starts at **`2267488`**
bytes and the zip end header starts at **`2379840`** bytes and no other signatures are found in the file. This means
we can safely assume that the files from **`2267488`** to the end of file contains the hidden **`.zip`** file.  

I have a small utility already written to perform extraction of range of bytes as this is something very commonly
required during CTF challenges. Using this utility I cut the required byte range to a new file. You can find the same
below.  

```sh
cutbytesrange() {
  if [ "$#" -ne 4 ]; then
    echo "4 arguments expected in order - start_byte_val, end_byte_val(excluding), input_file, op_file"
  else
    num_bytes="$(($2-$1))"
    dd bs=$num_bytes count=1 iflag=skip_bytes skip=$1 if=$3 of=$4
  fi
}

# Note 2379862 is the total byte size of the file obtained by **`ls -al`**
cutbytesrange 2267488 2379862 the_journalist.gif act.zip 
```  

### Output from **`exiftool`**:
{: .no_toc}

The output from exiftool gives us various meta information stored within the **`.gif`** image. Scanning through the
values, one of them stand out which is the value for **`Rights`**, **`aDNfdzQ1X2w0NXRfczMzbl80dF90aDRfbTB2MTM1`**. 
This is a typical **Base64** encoded value and quickly decoding it gives us the string **`h3_w45_l45t_s33n_4t_th4_m0v135`**.  


Now we have a string and a zip file to further work with. Extracting the zip file gives us a **`.pdf`** as expected, but
this pdf is password protected. Supplying the string obtained after **Base64** decoding opens up the pdf, which contains
the flag in it. The complete action can be seen below.  

![Full solution in action][8]  


The final flag was **`dsc{1_f0und_h1m_4nd_h35_my_fr13nd}`**.

## Teg Rads 📑
Forensics
{: .label .label-green .fs-1 .ml-0}  

This was one of the tougher forensic challenges mainly because there were quite a few parts to the flag hidden in various
places which we had to figure out. Also during the course of solving the challenge initially I did miss few hidden clues
due to which I was a bit lost in between. We are provided with a **`.pdf`** file in this challenge which can be downloaded
[here][9] along with the below challenge instructions.  

Challenge instructions:  
> Most of the times, what you seek is deep within the user. It starts with a writer, carries on with an actor and ends 
> with a producer.

On downloading the file, we see that is rendered as a proper **`.pdf`** file. Out of curiosity I did open up the pdf and found
few black patches within the only page available in the file. Selecting all the content in the page and pasting it in a text
editor I could find the below flags.  
```sh
dsc{f0r3n51x_15_fun}
dsc{n0t_h3r3_31th3r} 1
dsc{n1c3_try}
1
dsc{f00t_n0t3} would just be too obvious
``` 

All these are for sure decoy flags and obviously none of them would work. I did'nt even try these flags. So moving on as before
I ran **`exiftool`** and **`binwalk`** over the file. The output of **`exiftool`** does not give us anything interesting to
work on, however **`binwalk`** clearly tells us we have a hidden **`.zip`** file in it as seen from the below output.  
```sh
┌──(cryptonic㉿cryptonic-kali)-[~/CTFs/deconstructf/tegrads]
└─$ binwalk fdp.pdf           

DECIMAL       HEXADECIMAL     DESCRIPTION
--------------------------------------------------------------------------------
0             0x0             PDF document, version: "1.4"
48629         0xBDF5          Zip archive data, at least v1.0 to extract, name: sk1/
48691         0xBE33          Zip archive data, at least v2.0 to extract, compressed size: 95, uncompressed size: 108, name: sk1/p4.txt
49008         0xBF70          End of Zip archive, footer length: 22
```  

Similar to the previous challenge above, we can quickly extract the hidden zip file and extracting the zip file gives us a text file
named **`p4.txt`** contents of which can be seen below. The file name itself seems to suggest that it is the fourth part of the flag 
and the contents of the file did not lead me anywhere.  
```text
Caesar wasn't smart enough. He got outsmarted by Brutus lmao.
The key is our creator
The result is fq3gq10n_ 
```  

The contents above, clearly gave up that it was not a Caesar cipher but then the obvious next cipher which should have struck my mind did
not come by at the heat of the moment. So I was totally stuck at this moment but I knew there was more than one part to this flag. So I 
decided to return back to the **`.pdf`** file to see if we find any other interesting parts.  

One another useful tool is the **`strings`** command which dumps valid ASCII strings of specified length that are part of the file. Running
this tool on the initial **`.pdf`** file gives us a large list of strings. Analyzing it patiently gives us a lot of clues and parts of the 
flag. I have added the relevant parts of the output below followed by explanation and dealing with each individual part. 
```text
...
...
%% Original object ID: 1 0
2 0 obj
  /Author (Leplin)
  /Keywords (third section should be right here)
  /Producer (YjRubjNkfQ==)
  /Subject (third section closeby)
  /Title (dscpdf challenge)
  /Creator (alexa)
endobj
...
...
  <dc:subject>
   <rdf:Bag>
    <rdf:li>third section closeby</rdf:li>
   </rdf:Bag>
  </dc:subject>
  <dc:title>
   <rdf:Alt>
    <rdf:li xml:lang='x-default'>dscpdf challenge</rdf:li>
   </rdf:Alt>
  </dc:title>
 </rdf:Description>
 <rdf:Description rdf:about=''
  xmlns:pdf='http://ns.adobe.com/pdf/1.3/'>
  <pdf:Author>Leplin</pdf:Author>
  <pdf:Keywords>110000 1100110 1011111</pdf:Keywords>
 </rdf:Description>
</rdf:RDF>
</x:xmpmeta>
% Here's the first part of the flag:
% DONT ESCAPE FROM JAVASCRIPT
% `%64%73%63%7B%70%75%62%6C%31%63_`
...
...
endobj
// There are 5 pieces to the puzzle
%% Original object ID: 12 0
13 0 obj
  /Length 14 0 R
stream
/CIDInit /ProcSet findresource begin
...
...
8176
%%EOF
% Now you prolly tried ctrl+f but i wouldnt make it that easy, here ya go for slice #2 - (23958575899).toString(35) + String.fromCharCode(0x5F)
sk1/UT	
Vaux
...
...
```  

Some of the above details can be obtained by analyzing the properties of the file loaded via the Linux file explorer. An image of the
same is shown below.

![Details from PDF properties][10]

Let us navigate the details part by part:

### Third section first
{: .no_toc}

```text
...
...
%% Original object ID: 1 0
2 0 obj
  /Author (Leplin)
  /Keywords (third section should be right here)
  /Producer (YjRubjNkfQ==)
  /Subject (third section closeby)
  /Title (dscpdf challenge)
  /Creator (alexa)
endobj
...
...
```

The first artifact we inspect is the above section. This section contains a string that states that it gives the
third part of the flag followed by a string (**`YjRubjNkfQ==`**) that looks like Base64 encoded. Decoding it
gives us the string **`b4nn3d}`**. One thing to note is that this part of the flag contains the closing parenthesis
which suggests it is the last part of the flag. Note this fact and it will be useful later.  


### First and the Unknown
{: .no_toc}

Next we analyze the below section which is the longest length of string that is obtained from the **`strings`** 
command.  
```text
...
...
  <dc:subject>
   <rdf:Bag>
    <rdf:li>third section closeby</rdf:li>
   </rdf:Bag>
  </dc:subject>
  <dc:title>
   <rdf:Alt>
    <rdf:li xml:lang='x-default'>dscpdf challenge</rdf:li>
   </rdf:Alt>
  </dc:title>
 </rdf:Description>
 <rdf:Description rdf:about=''
  xmlns:pdf='http://ns.adobe.com/pdf/1.3/'>
  <pdf:Author>Leplin</pdf:Author>
  <pdf:Keywords>110000 1100110 1011111</pdf:Keywords>
 </rdf:Description>
</rdf:RDF>
</x:xmpmeta>
% Here's the first part of the flag:
% DONT ESCAPE FROM JAVASCRIPT
% `%64%73%63%7B%70%75%62%6C%31%63_`
...
...
```

The first part of the flag is obvious from the above part, which is given as a Percent Encoded/Url Encoded string.
Decoding the string **`%64%73%63%7B%70%75%62%6C%31%63_`** gives us the first part of the flag as **`dsc{publ1c_`**.  

Another part that is interesting is the binary string that is available. This was actually the last part I looked for
because the parts could not fit in proper order without this part. None the less I am convering it in an ideal flow.  

The binary string **`110000 1100110 1011111`** seems to be some string represented in binary. Converting the binary
to string as is in online tools gives us gibberish like **`Ã5.`**. However after starting at the binary string for
sometime I relaized that each character should be represented by 1 byte i.e 8 bits but some 0 padding bits are missing
in each byte. Plugging the missing zeros gives us the binary string **`00110000 01100110 01011111`** and converting it
to its string representation gives us **`0f_`**. We call this as **Unknown part** for now as there is no indication as
to where it might fit.  

### Five is the number
{: .no_toc}

The next part shown below gives us just an information that there are totally five parts to the flag. Yet it does not 
really give us the position of the **Unknown part**.  
```text
...
...
endobj
// There are 5 pieces to the puzzle
%% Original object ID: 12 0
13 0 obj
  /Length 14 0 R
stream
/CIDInit /ProcSet findresource begin
...
...
```  

### Second section  
{: .no_toc}

We will next analyze the below section which seems to give us the second part of the flag. It gives us a what looks like
a Javascript expression.  
```text
...
...
8176
%%EOF
% Now you prolly tried ctrl+f but i wouldnt make it that easy, here ya go for slice #2 - (23958575899).toString(35) + String.fromCharCode(0x5F)
sk1/UT	
Vaux
...
...
```

The part of interest is **`(23958575899).toString(35) + String.fromCharCode(0x5F)`** which when executed in a Javascript
console gives us the part **`d15pl4y_`**.

So summarizing upto now we have the following parts:  
- Part **`1`** of the flag as **`dsc{publ1c_`**
- Part **`2`** of the flag as **`d15pl4y_`**
- Part **`3`** of the flag as per clue as **`b4nn3d}`** but its the best candidate for being the last part of the flag
- Unknown part of the flag as **`0f_`**  


Now going back to the first part of the writeup where we found a file called **`p4.txt`** with the contents below.  
```text
Caesar wasn't smart enough. He got outsmarted by Brutus lmao.
The key is our creator
The result is fq3gq10n_ 
```  

This is the part where I became impatient. There was a hint released during the course of the challenge for trading 50
points. The hint read, **`Vigenere >> Caesar`**. That closed the gap. A quick search will give you the clue that the 
cipher used is **Vignere** cipher which needs a key to decipher.  

From the contents of **`p4.txt`** it is clear that *the key is our creator*. While skimming through the strings mentioned
under the section of **Third section first** we see that there is a text that says **`/Creator (alexa)`**. So now we have
all parts to decipher the content. Quickly navigating to [cryptii.com][11] and selecting the **`Vignere cipher`** for
deciphering, we get the fourth part as **`ff3ct10n_`**. One part that was tricky in this deciphering was the variant of 
Vignere cipher to use. As there were only four types listed in the site, looking at the various parts gives us a general
sense of what will fit in line with the other parts and so we use the variant as **`Variant Beaufort Cipher`** giving us
the correct fourth part.  

Right, so now we have three parts which are know to be in the given position which is Part 1 **`dsc{publ1c_`**, Part 2
which is **`d15pl4y_`** and Part 4 which is **`ff3ct10n_`**.  

The part mentioned as the 3<sup>rd</sup> part i.e **`b4nn3d}`** ends with a **`}`** which will necessarily be at the end, so
it has to be the 5<sup>th</sup> part.  

We are now left with the Unknown part **`0f_`** which fits in Part 3 which is the only free place.  

Based on the above observations we assemble the flag and get the final flag as **`dsc{publ1c_d14pl4y_0f_ff3ct10n_b4nn3d}`**.  


## RSA 1 🎯
Crypto
{: .label .label-green .fs-1 .ml-0}  

The first challenge in a series of cryptography challenges and first among a three part challenge involving RSA, this was a
warmup challenge. We are given the below challenge instructions and a file, the contents of which are available below the
challenge instructions.  

Challenge instructions:  
> I have a lot of big numbers. Here, have a few!  

big_numbers.txt:  
```text
Ever used RSA Encryption?

cyphertext = 10400286653072418349777706076384847966640064725838262071
n = 23519325203263800569051788832344215043304346715918641803
e = 71
```  

From the contents of the file it is clear that we are given the public modulus, **`n`** the encryption exponent **`e`** and a
cipher text. In order to be able to decrypt the cipher text, we should be able to exploit some inherent mathematical vulnerability
in the prime factors used to compute the public modulus **`n`**.  

There are various vulnerabilities that can be exploited which would be a tutorial on its own that I would not like to repeat. However
I will point to good resources to learn more about the vulnerabilities:  
1. [cryptohack.org][12]
2. [Introduction to RSA][13]

In addition to the above I would direct you towards the [RsaCtfTool][14] which is like a swisskeyrepo for RSA cryptography. It has
a collection of attacks that can be done on RSA by exploiting the weakness of the encryption parameters. A detailed account is
available in the repository.  

Also another important tool or rather website is the [factordb.com][15] which curates the largest collection of public modulus and
their factors, as cracking the factors of a modulus is at the heart of the working of RSA.  

Now getting back to the text file we have at hand, we can easily see that are public modulus is not large enough and should be easily
factorable. As factordb lookup is one of the attacks implemented within the **RsaCtfTool** we directly go ahead and run it.  

We use the command:  
```sh
┌──(cryptonic㉿cryptonic-kali)-[~/CTFs/deconstructf/bignumbers]
└─$ python3 ~/Tools/RsaCtfTool/RsaCtfTool.py -n 23519325203263800569051788832344215043304346715918641803 -e 71 \
 --uncipher 10400286653072418349777706076384847966640064725838262071
private argument is not set, the private key will not be displayed, even if recovered.

[*] Testing key /tmp/tmp0uq14whe.
[*] Performing factordb attack on /tmp/tmp0uq14whe.
[*] Attack success with factordb method !

Results for /tmp/tmp0uq14whe:

Unciphered data :
HEX : 0x6473637b7430305f6d7563685f6d3474685f383839387d
INT (big endian) : 9621269132073872010525638902903988134500010392708266109
INT (little endian) : 11993657127041496499871362328745731192598296696556057444
utf-8 : dsc{t00_much_m4th_8898}
STR : b'dsc{t00_much_m4th_8898}'
```  

As seen above, we can see that we have passed the available values to the tool which has performed a factordb attack to factorize the
public modulus to its prime numbers as a result of which we are able to decrypt the given cipher text leading us to the final flag as
**`dsc{t00_much_m4th_8898}`**.  


## RSA 2 💻
Crypto
{: .label .label-green .fs-1 .ml-0}  

The second in the RSA series, this was another challenge that tested our basics of RSA. In this challenge we are given the below
challenge instructions and a file whose contents are available below the instructions.  

Challenge instructions:
> Hey I heard you have a supercomputer at home. This is taking too long to compute on my computer.  
> Could you take a look on yours? I'm sure its a lot more precise than mine is, and faster too!  

supercomputer_food:  
```text
e: 3
c: 2780321436921227845269766067805604547641764672251687438825498122989499386967784164108893743279610287605669769995594639683212592165536863280639528420328182048065518360606262307313806591343147104009274770408926901136562839153074067955850912830877064811031354484452546219065027914838811744269912371819665118277221
n: 23571113171923293137414347535961677173798389971011031071091131271311371391491511571631671731791811911931971992112232272292332392412512572632692712772812832933073113133173313373473493533593673733793833893974014094194214314334394434494574614634674794874914995035095215235415475575635695715775875935996016076136176196316416436476536596616736776836917017097197277337397437517577617697737877978098118218238278298398538578598638778818838879079119199299379419479539679719779839919971009101310191431936117404941729571877755575331917062752829306305198341421305376800954281557410379953262534149212590443063350628712530148541217933209759909975139820841212346188350112608680453894647472456216566674289561525527394398888860917887112180144144965154878409149321280697460295807024856510864232914981820173542223592901476958693572703687098161888680486757805443187028074386001621827485207065876653623459779938558845775617779542038109532989486603799040658192890612331485359615639748042902366550066934348195272617921683
```  

As I said before, this is a really easy challenge if we are clear with the basics of RSA. To give an idea and backdrop to the solution for
those who are not much aware of the RSA crypto scheme, read below.  

<details markdown="block">
  <summary>
  Click here to view the basics of RSA
  </summary>

To understand RSA, we need to understand the general conventional names used for various pieces of information in a RSA scheme. I will list
some of them here so establish a common ground from where we can start off.  
1. **`n`** - the public modulus obtained by applying a formula to a pair of **large** prime numbers **`p`** and **`q`**
2. **`e`** - the public encryption exponent used to encrypt a plaintext message **`m`**
3. **`c`** - the encrypted message i.e the cipher text
4. **`d`** - the decryption exponent computed by applying a function over the **`p`**, **`q`** and **`n`**.

So now encryption using RSA can be mathematically expressed as:
> c = m<sup>e</sup> mod(n)  
> where **`mod`** is the modulus operator  

and decryption from RSA can be expressed as:
> m = c<sup>d</sup> mod(n)  
> where again **`mod`** is the modulus operator  

Now take a look at the encryption formula, and think what happens when the value of m<sup>e</sup> is smaller than the value of **`n`** 
or **`n`** is very large than the exponent **`e`**.  

Well you guessed it right, **`c`** i.e the cipher text would be equal to m<sup>e</sup> and the effect of encryption reduces to merely raising
the plaintext message to the power of the exponent **`e`**.  

Given the above background read ahead.  
</details>

We see that the public modulus **`n`** is much greater than the exponent **`e`** or rather the exponent is very weak. This means, that the
encryption operation reduces to merely an exponentiation operation. Read the basics above, if this statement does not makes sense to you.  

So now we know that encryption has been done by merely raising a given plaintext message to the power of three, the value of the encryption
exponent **`e`**. Thus decryption can be done by just finding the cube root of the cipher text and converting it to string. The script below
does exactly the same and gives us the required value.  
```sh
┌──(cryptonic㉿cryptonic-kali)-[~/CTFs/deconstructf/rsa2]
└─$ python3 -c "from Crypto.Util.number import long_to_bytes;from sympy import cbrt;m=cbrt(2780321436921227845269766067805604547641764672251687438825498122989499386967784164108893743279610287605669769995594639683212592165536863280639528420328182048065518360606262307313806591343147104009274770408926901136562839153074067955850912830877064811031354484452546219065027914838811744269912371819665118277221);print(long_to_bytes(m))"
b'dsc{t0-m355-w1th-m4th-t4k35-4-l0t-0f-sp1n3}'
```

The above basically uses the [PyCryptodome][16] to conver the resulting plaintext message from **`long`** to **`bytes`** and the [sympy][17]
library for performing safe computation of cube root of the cipher text represented as a **`long`** number. The final flag as seen above is
obtained as **`dsc{t0-m355-w1th-m4th-t4k35-4-l0t-0f-sp1n3}`**.  


## RSA 3 🗝
Crypto
{: .label .label-green .fs-1 .ml-0}  

The third and last RSA challenge in the Crypto category, this was a medium level challenge with some prior experience in Crypto. In this 
challenge we are given the below instructions and a public key file which can be downloaded [here][18].  

Challenge instructions:  
> Alright, this is the big leagues. You have someone's Public Key. This isn't unusual, if you want to send someone an encrypted message,  
> you have to have thier public key. Your job is to evaluate this public key, and obtain the value of the secret exponent or decryption  
> exponent (The value of "d" in an RSA encryption).  
> Wrap the number that you find with dsc{<number>}!  

Looking into the file we can see that we have a public key file which mainly is the pair (**`n`**, **`e`**) represented in a specific 
Base64 encoded format. Also from the challenge instructions it is clear that we need to get **`d`** which is the part of private key.
To get an idea of what kind of vulnerability might exist we would like to look at the public key parts. To extract the parts, we can 
use the [RsaCtfTool][14] using the command shown below.  
```sh
┌──(cryptonic㉿cryptonic-kali)-[~/CTFs/deconstructf/rsa3]
└─$ python3 ~/Tools/RsaCtfTool/RsaCtfTool.py --publickey mykey.pub --dumpkey
private argument is not set, the private key will not be displayed, even if recovered.
Details for mykey.pub:
n: 64064959164923876064874945473407049985543119992992738119252749231253142464203647518777455475109972581684732621072998898066728303433300585291527582979430276357787634026869116095391514311111174206395195817672737320837240364944609979844601986221462845364070396665723029902932653368943452652854174197070747631242101084260912287849286644699582292473152660004035330616149016496957012948833038931711943984563035784805193474921164625068468842927905314268942153720078680937345365121129404384633019183060347129778296640500935382186867850407893387920482141216498339346081106433144352485571795405717793040441238659925857198439433
e: 36222680858414256161375884602150640809062958718117141382923099494341733093172587117165920097285523276338274750598022486976083511178091392849986039384975758609343597548039166024042264614496506087597114091663955133779956176941325431822684716988128271384410010471755324833136859652978240297120618458534306923558546176110055737233883129780378153307730890915697357455996361736492022695824172516806204252765904924281272883818154621932085365817823019773860783687666788095035790491006333432295698178378520444810813882117817329847874531809530929345430796600870728736678389479159328119322587647856274762262358880664585675219093
```  

To check if the public modulus **`n`** is already factored I looked up the value at [factordb][15]. It turns out that the modulus is fully
factored and available in [factordb][15]. So now we run [RsaCtfTool][14] again but this time we ask it to print the private key. This can be
done by adding the **`--private`** option.  

<details markdown="block">  
  <summary>
  Click here to view the output
  </summary>  

```sh
┌──(cryptonic㉿cryptonic-kali)-[~/CTFs/deconstructf/rsa3]
└─$ python3 ~/Tools/RsaCtfTool/RsaCtfTool.py --publickey mykey.pub --dumpkey --private

[*] Testing key mykey.pub.
[*] Performing factordb attack on mykey.pub.
[*] Attack success with factordb method !

Results for mykey.pub:

Private key :
-----BEGIN RSA PRIVATE KEY-----
MIIEXwIBAAKCAQEB+34C7GuhHbhLHus9oqCfHR5N2e6WlnXb+MP5qCbY9fbjoWmg
VqKTRu8Zv81KjjlQ531oc8x4tf0H4kyuPjngAI0UjWdEcNnNWy7ErnJzdwW8jGrZ
Spj7BZe9eoPdo3l16lnTDQCxTnm/1YF+crA1Ek7wIQG5S0fguTGebiwLX79qVFcC
RvCccSQKhiuJiZjK0MOrWYlnm8O518tw0ZUuaFhgtFaBJyTI04aN5oTZF3gyuPDZ
8MCTp7wYoJ4CvcONlUpobAqSZ1/VIqDxlYM2Yo6h101wGzW/jucsg+8Np+V+4vHX
aSLpz6DOhA7TZIAozzL+4I5SfL0lzzfXSQB8CQKCAQEBHvBcAbNv9v7I/ZieaKjZ
xEclI5AXjA/igQcW4sz7uHPyt0/5aX5TGEkrfROs9renIw7JTkXeo9uArubEIcp4
7g4346dg5i0tmxbUzF/Pzz3JJGqygmhbVnIlMP93Iwm2VUOMuTSffK01NdmyysC7
xy0OudHb+GtzUv40H2rcTe6VqPuV0pVY5qivnjPeBKl5TVsxrwbyVXdj+1hjh2pw
c2fUZY1LZUAhybrxK/9d2LcZeidUK8IWV92zgE/AYbNDsbwruLR91iO9DTEH99z0
OIjMj/xnIkY/kb8j5lCdIITsU8VxAdzkx05IIa54t6o2+2vXKYfQgSwjeXRBywgg
lQJAehHdzEMx5okjFvPpElQjZWvTuYT9AG04F4b2MMWiMLeLPIt8Clma+tHt2G/A
BWuujnW/UDFVxGsk6KhvsIfWFQKBgQEJOVoWZwRXdfRDN0Ws3dF7NI5Ju9P65hyt
ByBC3WlEZH9R2utRURFIRfaxVmAedseDfUrurqFdWLSYGT2yawBoYQq2uDRVB6P7
5RiVZIhKJjeZllIlKAUwPqbcTpeyxsL9izDxZrq14PzvUjjpa9lpCD4jbEHGhiap
oQqApHMDVwKBgQHp17BSkIX1r+qAPtsBuOMeQIONQx5+8cl8CKpW9bOSWq3vWTYE
La8xGU7ri9Sg4p2pkHV3mZwIdSeGj7iOgLUykYoDzKWxwqxU5K9hYr7Jl64TLwJG
N8JKBRFvcWr1RTu6K9HV3jMqj7r/Y14QMYZevn+7XUFJ5MqsmVnGNdk/nwJAehHd
zEMx5okjFvPpElQjZWvTuYT9AG04F4b2MMWiMLeLPIt8Clma+tHt2G/ABWuujnW/
UDFVxGsk6KhvsIfWFQJAehHdzEMx5okjFvPpElQjZWvTuYT9AG04F4b2MMWiMLeL
PIt8Clma+tHt2G/ABWuujnW/UDFVxGsk6KhvsIfWFQKBgQDOrWptQGDlH1VYjTk2
PvGX6PEiClix9zUvEicK6naC7cyz0LvNY0FtVY/uwhyv2sFxceH1LxdlsPy+xWFN
/GHaIoCU00C0Anq6eOqDKynvPlt4YYNI5EtFoi/r/dzioxHTXCiwbOeIkYWytmKF
6OXjzPgDat8h322YbtYnj8mfXg==
-----END RSA PRIVATE KEY-----
n: 64064959164923876064874945473407049985543119992992738119252749231253142464203647518777455475109972581684732621072998898066728303433300585291527582979430276357787634026869116095391514311111174206395195817672737320837240364944609979844601986221462845364070396665723029902932653368943452652854174197070747631242101084260912287849286644699582292473152660004035330616149016496957012948833038931711943984563035784805193474921164625068468842927905314268942153720078680937345365121129404384633019183060347129778296640500935382186867850407893387920482141216498339346081106433144352485571795405717793040441238659925857198439433
e: 36222680858414256161375884602150640809062958718117141382923099494341733093172587117165920097285523276338274750598022486976083511178091392849986039384975758609343597548039166024042264614496506087597114091663955133779956176941325431822684716988128271384410010471755324833136859652978240297120618458534306923558546176110055737233883129780378153307730890915697357455996361736492022695824172516806204252765904924281272883818154621932085365817823019773860783687666788095035790491006333432295698178378520444810813882117817329847874531809530929345430796600870728736678389479159328119322587647856274762262358880664585675219093
d: 6393313697836242618414301946448995659516429576261871356767102021920538052481829568588047189447471873340140537810769433878383029164089236876209147584435733
p: 186246648244859911607711264996090931472855888819671042195031912614949637606087847869985018786102702075677574757904065755347302795775592228331239337528300940615230331822790830533866239838132543271015473522200950110622128503105755908781817068494167073494343838131720577929427076318200884590552419145720643388247
q: 343979125362283985018448529279849717865226132571940753531472371147063833056052296996560621963391117972766695130913691200805933469450333065947100791572361583779489645096118775405521473386236447881145306226283269737222216027483772716038172843353831106671840432335901895809418592551312176873714872038511716417439

Public key details for mykey.pub
n: 64064959164923876064874945473407049985543119992992738119252749231253142464203647518777455475109972581684732621072998898066728303433300585291527582979430276357787634026869116095391514311111174206395195817672737320837240364944609979844601986221462845364070396665723029902932653368943452652854174197070747631242101084260912287849286644699582292473152660004035330616149016496957012948833038931711943984563035784805193474921164625068468842927905314268942153720078680937345365121129404384633019183060347129778296640500935382186867850407893387920482141216498339346081106433144352485571795405717793040441238659925857198439433
e: 36222680858414256161375884602150640809062958718117141382923099494341733093172587117165920097285523276338274750598022486976083511178091392849986039384975758609343597548039166024042264614496506087597114091663955133779956176941325431822684716988128271384410010471755324833136859652978240297120618458534306923558546176110055737233883129780378153307730890915697357455996361736492022695824172516806204252765904924281272883818154621932085365817823019773860783687666788095035790491006333432295698178378520444810813882117817329847874531809530929345430796600870728736678389479159328119322587647856274762262358880664585675219093
```  
</details>  

Using the above command we get the required private key value **`d`** and the final flag as:  
**`dsc{6393313697836242618414301946448995659516429576261871356767102021920538052481829568588047189447471873340140537810769433878383029164089236876209147584435733}`**.  


## The Conspiracy 🚢
Crypto
{: .label .label-green .fs-1 .ml-0}  

One of the non-RSA cryptography challenges, it was again a good warmup to the challenges that followed in this category. In this challenge
we are given with the below instructions and a text file whose contents are available below the instructions.  

Challenge instructions:  
> There was once a sailor who travelled to many countries. He was a quirky old man. He said many many things,  
> and most of what he said never made sense to anyone. He considered himself ahead of his time, and said that  
> the people of his time were unworthy of his wisdom. Soon he was lost to the ages, but his diary wasn't.  
> Are you worthy of decoding his wisdom?  

diary.txt:  
```text
ZHNjeygtMTguMDU1NzI3MjkyODI3NTYsIDE3OC40NTcwMDE0MzEzMTY3NCksKDE5LjAyODI4Mjg1NzUwNTM5MiwgMTAzLjE0NDI2MDcxMjA3MTA3KSwoNDIuNTM2NzA1OTkxMjY2MTQ2LCAxLjQ5MzAzNDQ2MTIyNzY5MzMpLCgzOC41ODkzNjk3MjE3MzU0LCA2OC44MTYzMjUyMzA1ODk2NyksXywoNTAuODUxNTE4OTQ4MjA2Nzk1LCA0LjM2MDE4MDg1MzU4MTk4NiksKDcuNjcxODYzNTM4NDUzMzg2LCAzNi44MzcyNjA5NTY5ODk1MiksXywoMzguNjE5NTA2NzQwNTg3MDM1LCAzNC44NTUxMjY0MjcxMTAwNCksKDQ3LjQyODA2MTU3MTIzNTQ1LCAxOC45OTg0MjExMDE5MDM2MDIpLCgzMC4xOTM4NzE1ODM1MzkyMSwgMzEuMTI0OTY2MTE2MTI1NzMpLF8sKC0wLjIzMTc3NTU5NDI2MTExNTU4LCAtNzguNTAzMzk2MzA4Mzk0OSksKC0xMi44NTQ0NjkzNjczMzQ1NSwgMTMyLjc5MjYyNDMzODgzMjk4KSwoNDQuNDI0MjMxMjUyNTc3NDM1LCAyNC4zNTAyNDExNjYyNzkyMjYpLCgyNC44MTk1NjQ3NDEzOTIzLCAxMjAuOTcyMzY3NTQwMDUwNTgpLCgxOC41ODQ0NTY5NzQ0MDM0ODcsIC03Mi4zMTgxMjE4OTYxNDc3Mil9
```  

As always the above surely looks like a Base64 encoded content and from the instructions it is clear that we are dealing with some kind of
navigation, co-ordinates etc. So we have a look out for something related in the back of our mind.  

First we perform Base64 decoding of the above text content to obtain the below:  
```sh
┌──(cryptonic㉿cryptonic-kali)-[~/CTFs/deconstructf/theconspiracy]
└─$ python3 -c "import base64;print(base64.b64decode('ZHNjeygtMTguMDU1NzI3MjkyODI3NTYsIDE3OC40NTcwMDE0MzEzMTY3NCksKDE5LjAyODI4Mjg1NzUwNTM5MiwgMTAzLjE0NDI2MDcxMjA3MTA3KSwoNDIuNTM2NzA1OTkxMjY2MTQ2LCAxLjQ5MzAzNDQ2MTIyNzY5MzMpLCgzOC41ODkzNjk3MjE3MzU0LCA2OC44MTYzMjUyMzA1ODk2NyksXywoNTAuODUxNTE4OTQ4MjA2Nzk1LCA0LjM2MDE4MDg1MzU4MTk4NiksKDcuNjcxODYzNTM4NDUzMzg2LCAzNi44MzcyNjA5NTY5ODk1MiksXywoMzguNjE5NTA2NzQwNTg3MDM1LCAzNC44NTUxMjY0MjcxMTAwNCksKDQ3LjQyODA2MTU3MTIzNTQ1LCAxOC45OTg0MjExMDE5MDM2MDIpLCgzMC4xOTM4NzE1ODM1MzkyMSwgMzEuMTI0OTY2MTE2MTI1NzMpLF8sKC0wLjIzMTc3NTU5NDI2MTExNTU4LCAtNzguNTAzMzk2MzA4Mzk0OSksKC0xMi44NTQ0NjkzNjczMzQ1NSwgMTMyLjc5MjYyNDMzODgzMjk4KSwoNDQuNDI0MjMxMjUyNTc3NDM1LCAyNC4zNTAyNDExNjYyNzkyMjYpLCgyNC44MTk1NjQ3NDEzOTIzLCAxMjAuOTcyMzY3NTQwMDUwNTgpLCgxOC41ODQ0NTY5NzQ0MDM0ODcsIC03Mi4zMTgxMjE4OTYxNDc3Mil9'))"
b'dsc{(-18.05572729282756, 178.45700143131674),(19.028282857505392, 103.14426071207107),(42.536705991266146, 1.4930344612276933),(38.5893697217354, 68.81632523058967),_,(50.851518948206795, 4.360180853581986),(7.671863538453386, 36.83726095698952),_,(38.619506740587035, 34.85512642711004),(47.42806157123545, 18.998421101903602),(30.19387158353921, 31.12496611612573),_,(-0.23177559426111558, -78.5033963083949),(-12.85446936733455, 132.79262433883298),(44.424231252577435, 24.350241166279226),(24.8195647413923, 120.97236754005058),(18.584456974403487, -72.31812189614772)}'
```  

As expected we get a set of co-ordinates and also **`_`** symbols in between. It is clear that we need to find out the location
of the co-ordinates we have. I initially tried to do it manually but many sites did not allow reverse geocoding more than two or
three co-ordinates.  

So I tried to find a Python package for reverse geocoding and landed at [**`reverse-geocode`**][19]. I quickly installed this package
and wrote a small script to get the reverse geocoded value of all the co-ordinates.  

<details markdown="block">  
  <summary>
  Click here to view the script
  </summary>

```python
import reverse_geocode

coordinates = [
    (-18.05572729282756, 178.45700143131674),
    (19.028282857505392, 103.14426071207107),
    (42.536705991266146, 1.4930344612276933),
    (38.5893697217354, 68.81632523058967),
    (50.851518948206795, 4.360180853581986),
    (7.671863538453386, 36.83726095698952),
    (38.619506740587035, 34.85512642711004),
    (47.42806157123545, 18.998421101903602),
    (30.19387158353921, 31.12496611612573),
    (-0.23177559426111558, -78.5033963083949),
    (-12.85446936733455, 132.79262433883298),
    (44.424231252577435, 24.350241166279226),
    (24.8195647413923, 120.97236754005058),
    (18.584456974403487, -72.31812189614772),
]
result = reverse_geocode.search(coordinates)
print(result)

first_char_city = ""
first_char_country = ""
for loc in result:
    city = loc.get("city")
    country = loc.get("country")
    first_char_city += city[0]
    first_char_country += country[0]

print(first_char_city)
print(first_char_country)
```
</details>  

On analyzing the results it looks like we need to get some readable string using a consistent logic. I thought through this
patiently. The initial Base64 decoded value contained, **`_`** at some places and the co-ordinate pair at all other places.
So it looked as if we are looking for only one character per co-ordinate.  

The output of reverse geocoding contained **`country_code`**, **`city`** and **`country`**. For my above hypothesis, the country
code was not useful. So I decided to form two string one each for **`city`** and **`country`** values by combining the first
character of the corresponding field for all the co-ordinates.  

This gave me two strings out of which one of them was human readable and went like **`FLATBETHEEARTH`** which also reminded me
that the theory that the Earth was flat was a very denounced theory in among early sailors. So this was the string we are
looking for but still we have to place back the **`_`** values at the appropriate places from the Base64 decoded value.  

The final flag obtained after the above is **`dsc{FLAT_BE_THE_EARTH}`**.  


## Code decode 🔁
Crypto
{: .no-vertical-align-c .label .label-green .fs-1 .ml-0}

Reversing
{: .no-vertical-align-c .label .label-green .fs-1 .ml-0}

This was the next challenge in the non-RSA cryptography, however I found it to be partially a reversing challenge. In this 
challenge we are given a detailed instruction which tells us about an old encryption system accompanied by three files which
can be downloaded as a zip [here][20].  

Challenge instructions:  
> Around 5 years ago, I made this killer program that encodes the string into a cyphertext. The unique feature of this  
> program is that for the same exact plaintext, it generates a different cyphertext every time you run the program.  
> Yesterday I was nosing around in some old stuff and found an encrypted message!  
> **`2njlgkma2bv1i0v}22lv19vuo19va2bvl2{-5x`**  
> Sadly I realized that I lost the decryption program. I have the encryption program though. Do you think you can help 
>  me out and decrypt this message for me?  

From the challenge instruction it is clear that we need to decrypt a message. We proceed to look into the files. 

Looking into the **`cypher.txt`** file we find that it contains a dictionary i.e key-value pair where both the key and the
value doesnt make sense. We will refer to a single records key as **`encrypt_key`** and its value as **`character_key`**.  

We analyze the **`encrypter.py`** script next.  

<details markdown="block">
  <summary>
  Click here to view encrypter.py
  </summary>  

```python
from random import choice

inputstring = input("Enter plaintext: ")


def read_encryption_details():
    with open("cypher.txt") as file:
        encrypt_text = eval(file.read())
        encrypt_key = choice(list(encrypt_text.keys()))
        character_key = encrypt_text[encrypt_key]
    return encrypt_key, character_key


def create_encryption(character_key):
    charstring = "abcdefghijklmnopqrstuvwxyz1234567890 _+{}-,.:"
    final_encryption = {}
    for i, j in zip(charstring, character_key):
        final_encryption[i] = j
    return final_encryption


def convert_plaintext_to_cypher(inputstring, final_encryption, encrypt_key):
    cypher_text = ""
    for i in inputstring:
        cypher_text += final_encryption[i]
    cypher_text = encrypt_key[:3] + cypher_text + encrypt_key[3:]
    return cypher_text


encrypt_key, character_key = read_encryption_details()
final_encryption = create_encryption(character_key)
cypher_text = convert_plaintext_to_cypher(inputstring, final_encryption, encrypt_key)

print(cypher_text)
```  
</details>  

We first look at the method **`read_encryption_details`**. This method seems to load the **`cypher.txt`** file
which contains a large list of cypher keys. Once the file is read, it selects a random encryption key and gets the
character key i.e its value. The method simply returns these two values.  

Next we look into the **`create_encryption`** method which uses the **`character_key`** selected above. The method
simply creates a map between plain text characters and the characters present in the **`character_key`**. This meant
that the length of the **`charstring`** variable and the length of each of the keys present in **`cypher.txt`** must
all be equal and I verified the same. It also confirmed that at the heart of it, it was just an annoying substitution cipher.  

Finally we look into the **`convert_plaintext_to_cypher`** method, which uses the **`encrypt_key`**, the substitution map
generated in the above step and the plain text. It basically does a substitution for each character in the map and then
pads the encrypted value with the **`encrypt_key`** adding first three characters to the front and all but first three 
characters to the end of the actual encrypted value.  

So now we have a solid understanding of the encryption algorithm used. Now we basically need to reverse this process. 
Reversing the process involves the below:  
1. Our decrypter should use the reverse substitution map
2. The padding should be first removed
3. For the resulting actual encrypted string reverse substitution should be done  

Also the above process needs to be done for all keys as we have no idea on which key was actually used for the encryption
process. A way to smartly halt the process would be to take the benefit of the flag format **`dsc{`** and stop the process
as soon as we hit a decrypted string starting with the initial known part of the flag.  

Based on all the above understanding, I wrote the **`decrypter.py`** script which is basically the encrypter with the relevant
parts reversed as per the above understanding and a termination logic added.  
```python
from random import choice

inputstring = input("Enter ciphertext: ")


def read_encryption_details():
    with open("cypher.txt") as file:
        encrypt_text = eval(file.read())
    return encrypt_text


def create_decryption(character_key):
    charstring = "abcdefghijklmnopqrstuvwxyz1234567890 _+{}-,.:"
    final_encryption = {}
    for i, j in zip(charstring, character_key):
        final_encryption[j] = i
    return final_encryption


def convert_cypher_to_plaintext(inputstring, final_encryption, encrypt_key):
    # the actual cypher text is from the third to the third last characters
    # as the encrypt_key is always six characters in length
    inputstring = inputstring[3:-3]
    plaintext = ""
    for i in inputstring:
        plaintext += final_encryption[i]
    # cypher_text = encrypt_key[:3] + cypher_text + encrypt_key[3:]
    return plaintext


encrypt_text = read_encryption_details()
for encrypt_key in encrypt_text.keys():
    character_key = encrypt_text[encrypt_key]
    final_decryption = create_decryption(character_key=character_key)
    cypher_text = convert_cypher_to_plaintext(
        inputstring, final_decryption, encrypt_key
    )
    if cypher_text.startswith("dsc{"):
        print(cypher_text)
        break

print(cypher_text)
```  

Running the above script gives us the required flag **`dsc{y0u_4r3_g00d_4t_wh4t_y0u_d0}`**.  


## Behind the enemy lines 💂
Crypto
{: .label .label-green .fs-1 .ml-0}  

This was another Crypto challenge that does not involve RSA. Also by reading the name and the challenge instructions
it did surface to the back of my mind that it could be the [Enigma][21] cipher used during the days of World War. This
was also partly due to my exposure to Enigma cipher's in prior CTF's.  

However there was a hint available and I am pretty sure it would have given the clue to Enigma.  

We are presented with the below instructions and a couple of files named **`ciphertext.txt`** and **`instructions.pdf`**.
The files can be downloaded as a zip from [here][22].

Challenge instructions:  
> One of our soldiers managed to intercept an secret message and some files.  
> Help us decode it before the war is over.  

On analyzing the files, the **`ciphertext.txt`** contains random strings and is supposed to contain the encrypted text.
Next when we try to open the **`.pdf`** file we are challenged with a password prompt.  

Now we need to focus on getting the password for the **`.pdf`**. I tried tools like **`exiftool`**, **`binwalk`** and
**`string`** but nothing lead me to the password. This is when I realized we might have to brute force the password.  

There are some well know password crackers like [John the Ripper][23] and [hashcat][24] but as far as I knew these
crack passwords from their salt and hash. So I started searching for keys like *brute forcing pdf file password* and
landed [here][25].  

I followed the steps mentioned in the above article to locate **`pdf2john.pl`** script, generate the hash from the file
and then crack the password. One thing that I realized after starting **John the Ripper** with the default configuration
was that the word list used by it was trying to generate passwords from combinations of characters and digits due to which
it seemed to take a long time.  

I was pretty sure the password must be some very weak one such the JTR can crack it easily. So I aborted and re-ran JTR
by supplying the **`rockyou.txt`** wordlist file. You can locate the file in your installation by running the
**`locate <partial-file-name>`**.  

With the above minor change the password crack was pretty fast and revealed the password as **`ilovejohn`**. Take a look
at the whole process below.  

![Password crack using JTR][26]  

Opening the PDF at first we see just some text that asserts that the required instructions are available in the PDF. I was
always thinking about this being an Enigma cipher and so was looking for various cipher parameters required to decipher. As
these were not obviously available anywhere, I wanted to check if there was any hiding in plain sight.  

To confirm the same, I used *Select All* in the PDF viewer to select all available text and guess what, it revealed all the
required parameters for cracking the Enigma cipher. You can see a screen shot and the cipher parameters below.  

![Cipher parameters revealed][27]  

The cipher parameters obtained were:  
```text
Hidden Key
Swiss K
UKW 8H 7G
III 23 W 10J
I 12L 21U
II 17Q 14N
-- you really thought, I wont hide it here?
```  

Heading over to [cryptii][11] and selecting the necessary parameters as shown below I did get a deciphered text. But that did
not seemed like the actual flag. At this point I was a bit stuck and pinged the admins of the CTF. They said that I am close
and that I need to look even more closer.  

![Enigma solver Cryptii][28]  

Turned out there was lot of padding on both sides of the text leading to the gibberish and indeed joining the texts and looking
closer gave out the flag value as **`flagdscturinglovedmeflag`**. Removing the padding and inserting appropriate flag format 
symbols leads us to the final flag as **`dsc{turinglovedme}`**.  


## Here's the flag 🕸
Web
{: .label .label-green .fs-1 .ml-0}  

Web is a very interesting category due to the variety of vulnerabilities which can be exploited. This is one of the intriguing
categories for me as I have never been able to crack challenges in Web that are towards medium or hard category. However this
was the teaser challenge for this category and was pretty easy.  

We are provided with the below instructions and a web page. The instructions make it very clear that the flag is hidden in the
client side itself.  

Challenge instructions:  
> A quick teaser to get yourself ready for the challenges to come! Just look for/at the flag and perhaps try your hand at some frontend tomfoolery?
> very.uniquename.xyz:2086   

With the limited experience that I have in Web, I have formulated the below standard steps for approaching any Web category
challenge:
1. View the HTML page source
2. View the network request sent while loading the web page to analyze any clues hidden in Cookies or Headers
3. Look through any linked resources like scripts, images, hidden HTML content, stylesheets, favicons etc.  

Going by this order the first two did not give me any clues. However there were two other resources loaded from the web page.
One was a Javascript file **`index.js`** and another one was a stylesheet file **`style.css`**. The script file had the below
contents:  
```text
// aHR0cHM6Ly93d3cueW91dHViZS5jb20vd2F0Y2g_dj1kUXc0dzlXZ1hjUQ
// since this a warmup, i'll let you know that this is base64 encoded
// and you should check the yt comments of the decoded link
```  

We get a Base64 encoded string which when decdoed gives a [url][29] to the Youtube video of **Rick Astley - Never Gonna Give You Up**.
Such links are troll flags and so I moved on to the next file which was the **`style.css`**.  

This file gave a flag content as below:
```css
.contain-flag::after {
  z-index: -64209;
  caesar-cipher: +3;
  flag: "gvf{zh0frph_wr_ghfrqvwuxfwi}";
}
```  

From the above it is clear that the contents of **`flag`** are **`+3`** Caesar cipher shift of the original flag. Quickly
performing a **`-3`** shift of the given string at [cryptii][11] gives us the final flag **`dsc{we0come_to_deconstructf}`**.


## Please ⏳
Web
{: .label .label-green .fs-1 .ml-0}  

This was the second challenge in the web category, wherein we are given the below intructions and a url. It was more of a
step by step web challenge, where we had to prform modifications to the request to correct the errors spit out at every
stage to finally reach the flag.  

Challenge instructions:  
> Hi there! We used to work together back in our old company DEEMA. I recently had a problem with my computer and lost all  
> the files on it. I remember creating a backup of my files on the company's servers. I know it's been a while, but could you 
> please try to access those files? I would be very grateful!
> extremely.uniquename.xyz:2086  

As we have only the web page to work with, we open up the page and are presented with a web page that asks for a username.
Providing a random name, gives us back the response stating **`Clancy`** is the only user that can access it for now.  

Quickly supplyng **`Clancy`** as the user name, we are told that only **`Administrators`** are given access. As stated before
analyzing the network tab for the network sent shows us that the below cookies stand out which are set:  
```text
Cookie: Username=admin; Admin_Access=False
```  

Changing the cookie value of **`Admin_Access`** to **`true`** and sending back the request gives us the next clue which states
that only a special **`DeemaBrowser`** can access this site followed by our current User-Agent string. Changing the user agent
string to the given value gives us back another clue.  

This clue asks us to send an **`Authorization`** header with **`Basic`** passphrase authorization with the passphrase 
**`What'sTheMagicWord?`**. A quick search on **`Basic`** authorization header leads us to the fact that value for this header 
should be Base64 encoded. So we Base64 encode the given string and add in a new authorization header cookie to the request as
shown below.  
```text
Authorization: Basic V2hhdCdzVGhlTWFnaWNXb3JkPw==
```  

It leads to the next clue which states that the page was accessible only in **April 2021** and that the current date has not 
been provided. I thought this out a bit and then analyzed the response headers where I found a **`Date`** header as shown below:  
```text
Date: Mon, 04 Oct 2021 03:58:33 GMT
```  

I quickly coopied this header as is and included it in my request as a new header. Sending in the **`Date`** header with the 
wrong date value, gave back a response with the exact date string to be used as **`Monday, 5th April 2021, at 12:00:00 GMT`**.  

You can view this whole process below:  

![Please solve video][30]  

The final flag as seen in the above video was **`dsc{4ll-y0u-g0tt4-d0-15-r3qu35t-n1c3ly}`**.  


## Taxi Union problems 💉
Web
{: .label .label-green .fs-1 .ml-0}  

The third in the web category, this was a bit tricky with quite a few things to figure out. However, if we follow a structured
process to solve it, we can get past this challenge easily.  

In this challenge we are presented with a backstory and a web page link as seen in the below challenge instructions.  

Challenge instructions:  
> An important package has been stolen from Mr Nagaraj by a Taxi driver. We've tried to ask the local taxi union about 
> driver's location but they are refusing provide the same.  
> Since this package is required for a time sensitive matter we don't have time to negotiate with the union.  
> Your task is to obtain the location of the taxi using the given information  
> Taxi Lisence Plate: TN-06-AP-9879  
> 
> extremely.uniquename.xyz:2052  

We are also given an open hint which reads as below:  
> The flag is the location of the taxi (no caps)  

Navigating to the web page, we get a form which asks for the license plate number. Supplying the given license plate value we
get a table with three fields showing the name and the phone number in addition to the license plate. It looked as thought the
query parameter value in the request was being used to query a back end data base.  

To confirm the above hypothesis, I change one of the characters in the license plate number randomly and saw that I was getting
a response that stated that the taxi is not found.  

This confirmed that there was some DB involved in the backend. Also in web challenges that involve a user controlled value and a 
database at the back end, [SQL Injection][31] is the prime attack vector. Also one of the first payloads to try out and verify if
an SQLi injection is present or not is to by pass the **`WHERE`** clause by adding an **`OR`** condition that is always true.  

To visualize how our given value i.e the license plate number in normal cases would be used in the query in the backend, please see
below:  
```sql
SELECT <COLUMN _NAMES> FROM <TABLE_NAME> WHERE <COLUMN_NAME_FOR_LIC_PLATE> = '<USER_SUPPLIED_VALUE>'
```  

Also this would have been done without purging the supplied value by simply concatenating anything provided by the end user in the 
search box. To modify the where clause to make it always true we can use the payload as **`TN-06-AP-9879' OR '1'='1`**. By supplying
this value the query changes to the below:  
```sql
SELECT <COLUMN _NAMES> FROM <TABLE_NAME> WHERE <COLUMN_NAME_FOR_LIC_PLATE> = 'TN-06-AP-9879' OR '1'='1'
```  
> Note: In SQL injection your imagination and understanding of the backend is only the limit. The payloads can get really fancy and
> what I list here are the payloads that I used to crack this challenge. The payloads can vary from user to user as multiple payloads
> can lead to our end goal of exfiltrating the location data.  

Sending in the above payload returns us four values which confirms that there is an SQL injection vulnerability in the server.  

Now we need to find the location details of the taxi. We need to somehow extract the data using a fancy payload. To help speedup
the process there is a really good repository of various payloads that allow us to iterate fast. You can access the same [here][32].  

As we are sure our payload is being used in the **`WHERE`** clause only and that the required column does not seem to be available
in the current query used in the backend search, we might require to perform some kind of **`UNION`** query to include a new query
selecting the required column.  

But for this to work, we need to know the database being used and also the table name.  

In relational schema like MySQL and PostgreSQL there are specific schemas within each database that store the table information, which
we can query to see the data. My mistake was this assumption that it was a relational DB. I kept trying payloads for these DB.  

When nothing worked out I went through [this][33] section which highlighted ways to confirm the DB information. As I had already tried
relational databases, I decided to go for the SQLite database check. Instead of using **`'1'='1'`** to nullify the criteria I this
time used the SQLite specific information which would return the value if it is really an SQLite database or else return an error message.  

So I used the below payload:  
```sql
TN-06-AP-9879' or sqlite_version()=sqlite_version();--
```  
The above payload is a little different. Let me walk your through it. So we supply an always equal condition by comparing the return value
of SQLite DB version information which will be the same string in back to back invocations. However remember that there would a terminating
**`'`** mark originally intended to enclose the user input value would not be dangling. To overcome this issue, we terminate the current 
query with a **`;`** and pass in **`--`** which states that rest of the line is a comment. So this makes the query executable.  

Sending in the above payload gives us back the same result as we got orignally confirming that we are dealing with an SQLite database.  

Now we need to find the table name and there are various payloads to do this for SQLite DB. However the first one mentioned [here][34] works
with slight modifications as we are able to perform only a union query.  

From the result of the original query it is clear that we are dealing with a query that returns three string values. So any **`UNION`** query
should also return three columns preferrably a string. We simply repeat the **`tbl_name`** column three times and provide it in the **`UNION`**
query as below:  
```sql
TN-06-AP-9879' or '1'='1' union select tbl_name,tbl_name,tbl_name FROM sqlite_master WHERE type='table' and tbl_name NOT like 'sqlite_%';--
```  

This gives us the table name value as **`taxi`**. Similarly we use the payload for finding the column name and arrive at the column name as
**`location`**.  

We have all the unknowns to construct the final **`UNION`** query to spit out the location information. The final payload we use is as below:  
```sql
TN-06-AP-9879' or '1'='1' union select location, 1, 1 from taxi;--
```  

This gives us the location details of the four taxi's one of which is the required flag answer. Trying them out the final flag turned out to be
**`dsc{ayanavaram}`**. You can view the whole process in action in the below video.

![SQL Injection video][35]  


## Curly Fries 1 🇸🇪
Web
{: .label .label-green .fs-1 .ml-0}  

This was another three series part of challenges but unfortunately I could not crack it although it was really easy. The challenges in these series
involved a bit of guessing work, or rather would say we had to take a try-all approach to crack it.  

In this challenge we are given the below instructions and a web page which loads four different images as shown below the instructions.  

Challenge instructions:  
> Normal fries are nice, but everything's better with a curl in it. The flag is right in front of you.
> very.uniquename.xyz:8880  

![Screen grad of the page loaded][45]  

Connecting the images and also the bigger picture i.e the country flag we can easily find that the country was **Sweden** as all the images and the flag
lead to it. But then I was stuck after this. I tried quite a few things like loading the url **`/sweden`**, **`/sweden.png`** etc.  

It turned out we had to request the website with an **`Accept-Language`** header as **`sv-SE`** which is the language locale code for Swedish.  

Doing so returns a flag in platintext. There was no clue whatsover pointing towards this specific header which made the challenge a bit guessy. 

![Request web page with Swedish locale][46]  

The final flag was **`dsc{1_l0v3_sw3d3n}`**.  


## Extend Reality 🥽
OSINT  
{: .label .label-green .fs-1 .ml-0}  

The first open source intelligence challenge, this was actually quite easy but due to lack of presence of mind I did take a lot of time to solve
this challenge. We are clearly told that this is an OSINT challenge with the instructions given below.  

Challenge instructions:  
> XR is amazing! Why not let us teach you about it??  

Looking at the instructions it should strike us that **they** as in GDSCVIT is asking us to let them teach us about XR. One of the general ways
to teach is via Youtube webinars and a quick search in their [Youtube][36] channel leads us to a video on the topic **Extended Reality** streamed
on August 25th 2021 which can be viewed [here][37].  

In general flags would be present in the description, chat or comments section. As the description and comments did not give out any flag, I 
started fast forwarding the video while looking at the live chat. We can see that at around [1:11:17][38] into the video we get the required flag
as **`dsc{xr_15_4m4z1ng}`**. Also this flag was on the chat screen for almost five minutes and so was impossible to miss even at a faster playback
rate. A screen capture of the flag is available below.

![XR is amazing screen capture at 1:11:17][39]  


## Scraps 🔁
Reversing
{: .label .label-green .fs-1 .ml-0}  

This was the second reversing challenge among a set of two challenges alone in this category. In this challenge, we are provided with the below
challenge instructions along with a file which can be downloaded [here][40].

Challenge instructions:  
> One of our coders have locked down an application that is scheduled to be released tommorow.  
> Can you unlock the application as soon as possible.  

Downloading the file and running **`binwalk`** command over it, shows us that it is a valid ELF binary. I did load the binary in [Ghidra][41], to view
the code base. I saw that the **`main`** function was only really interesting but there was nothing obvious that gave the flag. But I did notice that
there were lot of load, store, compute operations involving various registers.  

As there was nothing available from the static analysis of the binary, I decided to load the binary into [GDB][42] and set breakpoints to view the register
values at runtime by stepping one instruction at a time. A run of the process can be seen by expanding the below.  

<details markdown="block">
  <summary>
  Click here to view debugging of the binary
  </summary>

![Binary debug view][43]
</details>

After stepping through few instructions, we find that the value in the **`RAX`** register seems to be a Base64 encoded value. Stepping through few more
iterations we can see the Base64 string increasing in length upto a point after which the register value remains constant at a specific value as shown below.

![Final Base64 encoded flag step][44]  

At this stage we copy the Base64 encoded value **`ZHNje3BVMjJMM19QaTNjMzJ9`** and decode it to get the final flag as **`dsc{pU22L3_Pi3c32}`**.  


[1]: https://ctftime.org/team/165779
[2]: ../#web-vulnerabilities
[3]: ../#crypto
[4]: https://mega.nz/file/hhQgnDjL#VCfjxfoNTPxi1fvnBgqlYAtdaOytglsyNyS_hbfCwiA
[5]: ../ctftools/wireshark
[6]: https://gcdn.pbrd.co/images/yC0zfUmlRlav.png?o=1
[7]: https://mega.nz/file/0pIi3TbQ#__qWZwbA3K-3HZ8mAbCXcZh0VUAsca0Wo2cg4B5WjFY
[8]: https://gcdn.pbrd.co/images/vpHT0IBWmeSs.gif?o=1
[9]: https://mega.nz/file/E0B0HZLQ#KQhPEVBe4Bx63-NOG7kGehrUBnrjN9Kw9lxbDHLimrY
[10]: https://gcdn.pbrd.co/images/2pa1l6Yln36I.png?o=1
[11]: https://cryptii.com/
[12]: https://cryptohack.org/
[13]: https://blog.sigmaprime.io/introduction-to-rsa.html
[14]: https://github.com/Ganapati/RsaCtfTool
[15]: http://factordb.com
[16]: https://www.pycryptodome.org/en/latest/src/util/util.html#Crypto.Util.number.long_to_bytes
[17]: https://www.tutorialspoint.com/sympy/sympy_quick_guide.htm
[18]: https://mega.nz/file/Z0Ai0bwZ#u2VSXr_hU_iJTyyL5gT867Ag9nvpgp3W5tRn4w9DUKo
[19]: https://pypi.org/project/reverse-geocode/
[20]: https://mega.nz/file/BtRQxTbZ#or4g0IRg_hsfobOeZFv1O44P2AS1NbH59EIBUHfFV0g
[21]: https://en.wikipedia.org/wiki/Enigma_machine
[22]: https://mega.nz/file/FtQiFBRI#bL7SBcDSLfjwytCUnT2KryPkj2QXkGvBsVG0Yct_J3g
[23]: https://linuxhint.com/john_ripper_ubuntu/
[24]: https://zoomadmin.com/HowToInstall/UbuntuPackage/hashcat
[25]: https://ourcodeworld.com/articles/read/939/how-to-crack-a-pdf-password-with-brute-force-using-john-the-ripper-in-kali-linux
[26]: https://gcdn.pbrd.co/images/qv7iFNIGXURI.gif?o=1
[27]: https://gcdn.pbrd.co/images/Og2xLVcNOSNy.png?o=1
[28]: https://gcdn.pbrd.co/images/haOw8pRQZ7ll.png?o=1
[29]: https://www.youtube.com/watch?v=dQw4w9WgXcQ
[30]: https://gcdn.pbrd.co/images/MuU5bBFZ1n7r.gif?o=1
[31]: https://portswigger.net/web-security/sql-injection
[32]: https://github.com/swisskyrepo/PayloadsAllTheThings/tree/master/SQL%20Injection
[33]: https://github.com/swisskyrepo/PayloadsAllTheThings/tree/master/SQL%20Injection#dbms-identification
[34]: https://github.com/swisskyrepo/PayloadsAllTheThings/blob/master/SQL%20Injection/SQLite%20Injection.md#integerstring-based---extract-table-name
[35]: https://gcdn.pbrd.co/images/7s2PFbEAgWKG.gif?o=1
[36]: https://www.youtube.com/c/DSCVITPoweredByGoogleDevelopers/videos
[37]: https://www.youtube.com/watch?v=AVdpVHoBCh4
[38]: https://youtu.be/AVdpVHoBCh4?t=4277
[39]: https://gcdn.pbrd.co/images/kgJLKIkgTJaP.png?o=1
[40]: https://mega.nz/file/gtglCSia#e6QqXy7pKiojI28KU4XZ7EBQx96h-E6jB9uPFKvokns
[41]: ../ctftools/ghidra
[42]: ../ctftools/gdb
[43]: https://gcdn.pbrd.co/images/RpQkuOigPtoa.gif?o=1
[44]: https://gcdn.pbrd.co/images/XkPH1RlDx5tE.png?o=1
[45]: https://gcdn.pbrd.co/images/WsqsOUTCP0X6.png?o=1
[46]: https://gcdn.pbrd.co/images/9O6cPzOqHc8p.gif?o=1