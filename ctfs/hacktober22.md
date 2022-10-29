---
layout: default
title: Hacktober 2022
nav_order: 9
description: "Hacktober CTF 2022"
permalink: /ctfs/hacktober22
has_children: false
parent: CTF List
last_modified_date: 28-10-2022 08:38 PM +0530
---

# Hacktober 2022
{: .no_toc}  

Hacktober is part of the security month October celebrations at my organization. A great experience to be part of and hack on.  
{: .fs-5 .fw-300 }  

## Challenge list
{: .no_toc .text-delta}

1. TOC
{:toc}


## Sm4ll 🤏
Crypto  
{: .label .label-green .fs-1 .ml-0}

This was the first challenge under the Crypto category. From the name and the challenge instructions it was clear it was something meant to be just a starter for Crypto.

Challenge instructions:  
> e : 3
> 
> n : 14765134568806152380780177404154379680157040230731901116353016162964681854643419545272768229048378188500692186311711971409968124480927254907468083269653523327630158185734310958362033077646043542383054670674171052587899204361134700584572459629071848166981160988717625552212126387741734276602999549288330861599376036039530488202175376193130850009446769741050982169300916990092646546337482900162177684652409252900439784938827069053004233947304644066471498232649486591080194031440952809932046199120487596759504590419575284525037462347888619653142049456789290070496111786961265998678923040521931493766189863302763399965481
> 
> c : 159824947944933145124838839627897472995222726725778699635746503980986937892371422645291581403491484060915790946238870994753794392630740865865372702551885464356303363652373929602662877152309665601671912554391480434375650725791107527216573236081089654751390509689517054062236946737731831215596006696199941703676597321808361467919236770950757

From the instructions it is clear that the exponent **`e`** used in the RSA encryption is very small compared to the value of **`n`**. Why is this important ?

The formula for encryption is as given below:
> c = m pow(e) mod(n)

In this above formula it is clear that if **`n`** is sufficiently large then the modulus has no effect on the encryption and the cipher text reduces to a exponentiation of message i.e the below formula:
> c = m pow(e)

Due to this the message **`m`** can be easily retrieved by inverting the exponentiation.

We use the below code to invert the exponentiation and convert the resultant **`long`** value to **`bytes`**.

```sh
python3 -c "from Crypto.Util.number import long_to_bytes;from sympy import cbrt;m=cbrt(159824947944933145124838839627897472995222726725778699635746503980986937892371422645291581403491484060915790946238870994753794392630740865865372702551885464356303363652373929602662877152309665601671912554391480434375650725791107527216573236081089654751390509689517054062236946737731831215596006696199941703676597321808361467919236770950757);print(long_to_bytes(m))"
```

We obtain the flag **`ZCTF2022{e_is_too_sm4ll_better_e_next_time_pls}`** by running the above code.  


## Language of Gods 🗣
Misc
{: .label .label-green .fs-1 .ml-0}

This was one of the miscellaneous challenges. It required some logic to solve and follow the instructions.  

<details markdown="block">
  <summary>
  Click her to view the Challenge Instructions
  </summary>

> are you good with languages?
> 
> Astra Planeta :
> 
> The Astra Planeta were a group of five gods from Greek mythology, who were sometimes also referred to as the Astra.
> 
> Pyroeis, meaning Fiery One (Mars) is one of the Astra planeta tells the story of ancient greek glory in her/his language.
> 
> **`rchd qd zykdqncfcn wgc fhxcf, bfywczwyf, skn lswgcf yl sxx vynd skn gheskd.`**
> 
> which means
> 
> **`zeus is considered the ruler, protector, and father of all gods and humans.`**
> 
> **`tskwgyd ykc yl wgc qeeyfwsx gyfdcd yokcn jp wgc gcfy bcxchd skn gqd dyk szgqxxcd.`**
> 
> which means
> 
> **`xanthos one of the immortal horses owned by the hero peleus and his son achilles.`**
> 
> **`asdyk vfccm gcfy,mcfcd eykdwfyhd lcesxc dbqfqwd yl uqyxckw ncswg sfc ihsxqwp zgsfszwcfd.`**
> 
> which means
> 
> **`jason – greek hero,keres monstrous female spirits of violent death are quality characters.`**
> 
> He/she is saying somethin **`qk wgc ckn wgc gcfy q xqmc wgc eydw,esp pyh zsk zsxx gqe wgc uqxxqsk yf ogswcucf.....pyhf lxsv qd {mfswyd_wgc_sxeqvgwp_vyn_yl_osf}`**
> 
> Can you help me translate this?
>
> Hint: Add ZCTF2022{}

</details>

From the instructions it is clear that the text is encoded in different English characters. We have to decode it using the give samples.  

We write a simple python script to create a character by character map using the given samples and also verify if any of the characters have contradicting character maps. 

<details markdown="block">
  <summary>
  Click here to view the script
  </summary>


```python
from curses.ascii import isalpha


# map of gibberish to english
vals = {
    "rchd qd zykdqncfcn wgc fhxcf, bfywczwyf, skn lswgcf yl sxx vynd skn gheskd.": "zeus is considered the ruler, protector, and father of all gods and humans.",
    "tskwgyd ykc yl wgc qeeyfwsx gyfdcd yokcn jp wgc gcfy bcxchd skn gqd dyk szgqxxcd.": "xanthos one of the immortal horses owned by the hero peleus and his son achilles.",
    "asdyk vfccm gcfy,mcfcd eykdwfyhd lcesxc dbqfqwd yl uqyxckw ncswg sfc ihsxqwp zgsfszwcfd.": "jason greek hero,keres monstrous female spirits of violent death are quality characters.",
}

chr_map = {}

# creating character by character map
for x, y in vals.items():
    assert len(x) == len(y)
    for c, d in zip(x, y):
        if c in chr_map.keys() and d != chr_map[c]:
            # ensuring no character has conflicting mapping character
            print(
                "Error: key - {0}, new val - {1}, old val - {2}".format(
                    c, d, chr_map[c]
                )
            )
        else:
            chr_map[c] = d

print(chr_map)

# decode using the generated character map
val = "qk wgc ckn wgc gcfy q xqmc wgc eydw,esp pyh zsk zsxx gqe wgc uqxxqsk yf ogswcucf.....pyhf lxsv qd {mfswyd_wgc_sxeqvgwp_vyn_yl_osf}"
result = ""
for c in val:
    if c.isalpha():
        result = result + chr_map[c]
    else:
        result = result + c
print(result)

```
</details>


By running the above script we get the below output:  
```sh
┌──(cryptonic㉿cryptonic-kali)-[~/CTFs/hacktober22/languageofgods]
└─$ python3 decipher.py
{'r': 'z', 'c': 'e', 'h': 'u', 'd': 's', ' ': ' ', 'q': 'i', 'z': 'c', 'y': 'o', 'k': 'n', 'n': 'd', 'f': 'r', 'w': 't', 'g': 'h', 'x': 'l', ',': ',', 'b': 'p', 's': 'a', 'l': 'f', 'v': 'g', 'e': 'm', '.': '.', 't': 'x', 'o': 'w', 'j': 'b', 'p': 'y', 'a': 'j', 'm': 'k', 'u': 'v', 'i': 'q'}
in the end the hero i like the most,may you can call him the villian or whatever.....your flag is {kratos_the_almighty_god_of_war}
```

We use the hint to prefix `ZCTF2022` and get the flag as **`ZCTF2022{kratos_the_almighty_god_of_war}`**.


## Invisibility 🙈
Misc
{: .label .label-green .fs-1 .ml-0}

This was the first challenge in the miscellaneous category and supposed to be pretty easy. Let us go through the challenge instructions and then the step by step process involved to solve it.

Challenge instructions:
> An Exploding Fish from The Village Hidden in the Rain entered Konoha for destruction. Lord Fourth managed to hold it in a computer file and seal it with the Eight Trigrams Sealing Style.
>
> Team 7, your task is to find the fish that went in disguise as letters followed by numbers inside the computer file. You will find  your key to unlock the seal on your investigation path. Good luck Team 7.
>
> The challenge instructions also contained a link to a file which can be downloaded [here][1].

Given the above details we first download the file which is named as **`invisibility.png`**.  

As a standard rule you should never go by the file name's extension and always check via the file magic number. There are few tools like **`file`** command and **`binwalk`** which help us determine the actual file type.  

We run the below command and get the output as seen:
```sh
┌──(cryptonic㉿cryptonic-kali)-[~/CTFs/hacktober22/invisibility]
└─$ file ./invisiblity.png 
invisiblity.png: Zip archive data, at least v2.0 to extract
```  

It clearly shows that the file is not actually a PNG but a zip file. So we go ahead and rename the file as **`invisibility.zip`**.  
```sh
┌──(cryptonic㉿cryptonic-kali)-[~/CTFs/hacktober22/invisibility]
└─$ mv invisibility.png invisibility.zip
```  


The natural step next is to list the files present in the zip. We use the unzip command and see the output.  
<details markdown="block">
  <summary>
  Click here to view the output
  </summary>

```sh
┌──(cryptonic㉿cryptonic-kali)-[~/CTFs/hacktober22/invisibility]
└─$ unzip -l invisiblity.zip 
Archive:  invisiblity.zip
  Length      Date    Time    Name
---------  ---------- -----   ----
        0  2022-10-18 15:54   invisiblity/
        0  2022-10-18 15:53   invisiblity/.secret/
        0  2022-10-18 15:52   invisiblity/.secret/a/
        0  2022-10-18 15:52   invisiblity/.secret/a/s
        0  2022-10-18 15:52   invisiblity/.secret/b/
        0  2022-10-18 15:52   invisiblity/.secret/b/y
        0  2022-10-18 15:52   invisiblity/.secret/c/
        0  2022-10-18 15:52   invisiblity/.secret/c/d
        0  2022-10-18 15:52   invisiblity/.secret/d/
        0  2022-10-18 15:52   invisiblity/.secret/d/2
        0  2022-10-18 15:52   invisiblity/.secret/e/
        0  2022-10-18 15:52   invisiblity/.secret/e/B
        0  2022-10-18 15:52   invisiblity/.secret/f/
        0  2022-10-18 15:52   invisiblity/.secret/f/n
        0  2022-10-18 15:52   invisiblity/.secret/g/
        0  2022-10-18 15:52   invisiblity/.secret/g/p
        0  2022-10-18 15:52   invisiblity/.secret/h/
        0  2022-10-18 15:52   invisiblity/.secret/h/F
        0  2022-10-18 15:52   invisiblity/.secret/i/
        0  2022-10-18 15:52   invisiblity/.secret/i/P
        0  2022-10-18 15:52   invisiblity/.secret/j/
        0  2022-10-18 15:52   invisiblity/.secret/j/Z
        0  2022-10-18 15:52   invisiblity/.secret/k/
        0  2022-10-18 15:52   invisiblity/.secret/k/5
        0  2022-10-18 15:52   invisiblity/.secret/l/
        0  2022-10-18 15:52   invisiblity/.secret/l/D
        0  2022-10-18 15:52   invisiblity/.secret/m/
        0  2022-10-18 15:52   invisiblity/.secret/m/G
        0  2022-10-18 15:52   invisiblity/.secret/n/
        0  2022-10-18 15:52   invisiblity/.secret/n/a
        0  2022-10-18 15:52   invisiblity/.secret/o/
        0  2022-10-18 15:52   invisiblity/.secret/o/Z
        0  2022-10-18 15:52   invisiblity/.secret/p/
        0  2022-10-18 15:52   invisiblity/.secret/p/o
        0  2022-10-18 15:52   invisiblity/.secret/q/
        0  2022-10-18 15:52   invisiblity/.secret/q/W
        0  2022-10-18 15:52   invisiblity/.secret/r/
        0  2022-10-18 15:52   invisiblity/.secret/r/M
        0  2022-10-18 15:52   invisiblity/.secret/s/
        0  2022-10-18 15:52   invisiblity/.secret/s/T
        0  2022-10-18 15:52   invisiblity/.secret/t/
        0  2022-10-18 15:52   invisiblity/.secret/t/d
        0  2022-10-18 15:52   invisiblity/.secret/u/
        0  2022-10-18 15:52   invisiblity/.secret/u/s
        0  2022-10-18 15:52   invisiblity/.secret/v/
        0  2022-10-18 15:52   invisiblity/.secret/v/Q
        0  2022-10-18 15:52   invisiblity/.secret/w/
        0  2022-10-18 15:52   invisiblity/.secret/w/R
        0  2022-10-18 15:52   invisiblity/.secret/x/
        0  2022-10-18 15:52   invisiblity/.secret/x/e
        0  2022-10-18 15:52   invisiblity/.secret/y/
        0  2022-10-18 15:52   invisiblity/.secret/y/v
        0  2022-10-18 15:52   invisiblity/.secret/z/
        0  2022-10-18 15:52   invisiblity/.secret/z/U
        0  2022-10-18 15:52   invisiblity/.secret/1/
        0  2022-10-18 15:52   invisiblity/.secret/1/8
        0  2022-10-18 15:52   invisiblity/.secret/2/
        0  2022-10-18 15:52   invisiblity/.secret/2/B
        0  2022-10-18 15:52   invisiblity/.secret/3/
        0  2022-10-18 15:52   invisiblity/.secret/3/N
        0  2022-10-18 15:52   invisiblity/.secret/4/
        0  2022-10-18 15:52   invisiblity/.secret/4/x
        0  2022-10-18 15:52   invisiblity/.secret/5/
        0  2022-10-18 15:52   invisiblity/.secret/5/4
        0  2022-10-18 15:52   invisiblity/.secret/6/
        0  2022-10-18 15:52   invisiblity/.secret/6/i
        0  2022-10-18 15:52   invisiblity/.secret/7/
        0  2022-10-18 15:52   invisiblity/.secret/7/o
        0  2022-10-18 15:52   invisiblity/.secret/8/
        0  2022-10-18 15:52   invisiblity/.secret/8/S
        0  2022-10-18 15:52   invisiblity/.secret/9/
        0  2022-10-18 15:52   invisiblity/.secret/9/e
        0  2022-10-18 15:52   invisiblity/.secret/10/
        0  2022-10-18 15:52   invisiblity/.secret/10/U
        0  2022-10-18 15:52   invisiblity/.secret/11/
        0  2022-10-18 15:52   invisiblity/.secret/11/L
        0  2022-10-18 15:52   invisiblity/.secret/12/
        0  2022-10-18 15:52   invisiblity/.secret/12/H
        0  2022-10-18 15:52   invisiblity/.secret/13/
        0  2022-10-18 15:52   invisiblity/.secret/13/w
        0  2022-10-18 15:52   invisiblity/.secret/14/
        0  2022-10-18 15:52   invisiblity/.secret/14/s
        0  2022-10-18 15:52   invisiblity/.secret/15/
        0  2022-10-18 15:52   invisiblity/.secret/15/r
        0  2022-10-18 15:52   invisiblity/.secret/16/
        0  2022-10-18 15:52   invisiblity/.secret/16/r
        0  2022-10-18 15:52   invisiblity/.secret/17/
        0  2022-10-18 15:52   invisiblity/.secret/17/2
        0  2022-10-18 15:52   invisiblity/.secret/18/
        0  2022-10-18 15:52   invisiblity/.secret/18/y
        0  2022-10-18 15:52   invisiblity/.secret/19/
        0  2022-10-18 15:52   invisiblity/.secret/19/m
        0  2022-10-18 15:52   invisiblity/.secret/20/
        0  2022-10-18 15:52   invisiblity/.secret/20/3
        0  2022-10-18 15:52   invisiblity/.secret/21/
        0  2022-10-18 15:52   invisiblity/.secret/21/A
        0  2022-10-18 15:52   invisiblity/.secret/22/
        0  2022-10-18 15:52   invisiblity/.secret/22/M
        0  2022-10-18 15:52   invisiblity/.secret/23/
        0  2022-10-18 15:52   invisiblity/.secret/23/m
        0  2022-10-18 15:52   invisiblity/.secret/24/
        0  2022-10-18 15:52   invisiblity/.secret/24/d
        0  2022-10-18 15:52   invisiblity/.secret/25/
        0  2022-10-18 15:52   invisiblity/.secret/25/c
        0  2022-10-18 15:52   invisiblity/.secret/26/
        0  2022-10-18 15:52   invisiblity/.secret/26/5
        0  2022-10-18 15:52   invisiblity/.secret/27/
        0  2022-10-18 15:52   invisiblity/.secret/27/q
        0  2022-10-18 15:52   invisiblity/.secret/28/
        0  2022-10-18 15:52   invisiblity/.secret/28/Q
        0  2022-10-18 15:52   invisiblity/.secret/29/
        0  2022-10-18 15:52   invisiblity/.secret/29/R
        0  2022-10-18 15:52   invisiblity/.secret/30/
        0  2022-10-18 15:52   invisiblity/.secret/30/d
        0  2022-10-18 15:52   invisiblity/.secret/31/
        0  2022-10-18 15:52   invisiblity/.secret/31/S
        0  2022-10-18 15:52   invisiblity/.secret/32/
        0  2022-10-18 15:52   invisiblity/.secret/32/+
        0  2022-10-18 15:52   invisiblity/.secret/33/
        0  2022-10-18 15:52   invisiblity/.secret/33/8
        0  2022-10-18 15:52   invisiblity/.secret/34/
        0  2022-10-18 15:52   invisiblity/.secret/34/i
        0  2022-10-18 15:52   invisiblity/.secret/35/
        0  2022-10-18 15:52   invisiblity/.secret/35/2
        0  2022-10-18 15:52   invisiblity/.secret/36/
        0  2022-10-18 15:52   invisiblity/.secret/36/q
        0  2022-10-18 15:52   invisiblity/.secret/37/
        0  2022-10-18 15:52   invisiblity/.secret/37/D
        0  2022-10-18 15:52   invisiblity/.secret/38/
        0  2022-10-18 15:52   invisiblity/.secret/38/o
        0  2022-10-18 15:52   invisiblity/.secret/39/
        0  2022-10-18 15:52   invisiblity/.secret/39/r
        0  2022-10-18 15:52   invisiblity/.secret/40/
        0  2022-10-18 15:52   invisiblity/.secret/40/H
        0  2022-10-18 15:52   invisiblity/.secret/41/
        0  2022-10-18 15:52   invisiblity/.secret/41/M
        0  2022-10-18 15:52   invisiblity/.secret/42/
        0  2022-10-18 15:52   invisiblity/.secret/42/q
        0  2022-10-18 15:52   invisiblity/.secret/43/
        0  2022-10-18 15:52   invisiblity/.secret/43/p
        0  2022-10-18 15:52   invisiblity/.secret/44/
        0  2022-10-18 15:52   invisiblity/.secret/44/G
        0  2022-10-18 15:52   invisiblity/.secret/45/
        0  2022-10-18 15:52   invisiblity/.secret/45/S
        0  2022-10-18 15:52   invisiblity/.secret/46/
        0  2022-10-18 15:52   invisiblity/.secret/46/K
        0  2022-10-18 15:52   invisiblity/.secret/47/
        0  2022-10-18 15:52   invisiblity/.secret/47/0
        0  2022-10-18 15:52   invisiblity/.secret/48/
        0  2022-10-18 15:52   invisiblity/.secret/48/m
        0  2022-10-18 15:52   invisiblity/.secret/49/
        0  2022-10-18 15:52   invisiblity/.secret/49/f
        0  2022-10-18 15:52   invisiblity/.secret/50/
        0  2022-10-18 15:52   invisiblity/.secret/50/w
        0  2022-10-18 15:52   invisiblity/.secret/51/
        0  2022-10-18 15:52   invisiblity/.secret/51/y
        0  2022-10-18 15:52   invisiblity/.secret/52/
        0  2022-10-18 15:52   invisiblity/.secret/52/M
        0  2022-10-18 15:52   invisiblity/.secret/53/
        0  2022-10-18 15:52   invisiblity/.secret/53/L
        0  2022-10-18 15:52   invisiblity/.secret/54/
        0  2022-10-18 15:52   invisiblity/.secret/54/n
        0  2022-10-18 15:52   invisiblity/.secret/55/
        0  2022-10-18 15:52   invisiblity/.secret/55/B
        0  2022-10-18 15:52   invisiblity/.secret/56/
        0  2022-10-18 15:52   invisiblity/.secret/56/5
        0  2022-10-18 15:52   invisiblity/.secret/57/
        0  2022-10-18 15:52   invisiblity/.secret/57/l
        0  2022-10-18 15:52   invisiblity/.secret/58/
        0  2022-10-18 15:52   invisiblity/.secret/58/3
        0  2022-10-18 15:52   invisiblity/.secret/59/
        0  2022-10-18 15:52   invisiblity/.secret/59/w
        0  2022-10-18 15:52   invisiblity/.secret/60/
        0  2022-10-18 15:52   invisiblity/.secret/60/Q
        0  2022-10-18 15:52   invisiblity/.secret/61/
        0  2022-10-18 15:52   invisiblity/.secret/61/=
        0  2022-10-18 15:52   invisiblity/.secret/62/
        0  2022-10-18 15:52   invisiblity/.secret/62/=
       13  2022-10-18 15:54   invisiblity/flag.txt
---------                     -------
       13                     179 files
```
</details>  

On inspecting the output of the **`unzip`** command we find that it contains around **`64`** folders and **`1`** file per folder.  
The name of the files seem to form a Base64 encoded text. So we copy the output of the above command to a text editor and create a string using the file names alone.  

The final string obtained by concatenating the file names can be seen below:  
**`syd2BnpFPZ5DGaZoWMTdsQRevU8BNx4ioSeULHwsrr2ym3AMmdc5qQRdS+8i2qDorHMqpGSK0mfwyMLnB5l3wQ=`**  

We try to decode this content but we do not get a flag per se. So we understand that this could be a encrypted content represented as a Base64 encoded string.  

We also notice another file within the zip named as **`flag.txt`** the contents of which are **`key: zctf2022`**. This also points toward the fact that the content is encrypted and the possible key is **`zctf2022`**.  

Now one last part that we need to figure out is the type of encryption that could have been used.  
We use [this][2] online tool to run the decryption and tranformation in a fast way. It has support for various decryption schemes and we use them to find.  


However in hindisight going through the **challenge instructions** again gives us a clue on the encryption scheme. The clue talks about **`fish`** and there is an encryption scheme called **`Blowfish`**.  
So we run the **`Blowfish`** decryption algorithm using the above website with the below parameters:  

> **`From Base64`** transformation  
> **`Blowfish`** decryption  
> **`Key`** as stated above  
> **`IV`** same as key  
> **`UTF-8`** for **`Key`** and **`IV`** format  
> **`Raw`** for input format  

On running the above transformation we get the below string which is again Base64 encoded:  
**`WkNURjIwMjJ7RzBPRF9KMCRfWTB1X0YwVW45X3Q1M19mTEBnX2gzNjN9`**  

We Base64 decode it once more to get the flag as below:  
**`ZCTF2022{G0OD_J0$_Y0u_F0Un9_t53_fL@g_h363}`**. You can check the whole transformation [here][3].



[1]: https://mega.nz/file/d9oWFQgD#iA13Jhv-q8boF_B1KnV6MfVAV3wYKZF3jmwv6_SsxgQ
[2]: https://gchq.github.io/CyberChef/
[3]: https://gchq.github.io/CyberChef/#recipe=From_Base64('A-Za-z0-9%2B/%3D',true,false)Blowfish_Decrypt(%7B'option':'UTF8','string':'zctf2022'%7D,%7B'option':'UTF8','string':'zctf2022'%7D,'ECB','Raw','Raw')From_Base64('A-Za-z0-9%2B/%3D',true,false)&input=c3lkMkJucEZQWjVER2Fab1dNVGRzUVJldlU4Qk54NGlvU2VVTEh3c3JyMnltM0FNbWRjNXFRUmRTKzhpMnFEb3JITXFwR1NLMG1md3lNTG5CNWwzd1E9