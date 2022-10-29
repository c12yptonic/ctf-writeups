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
> $c = m^e \pmod n$

In this above formula it is clear that if **`n`** is sufficiently large then the modulus has no effect on the encryption and the cipher text reduces to a exponentiation of message i.e the below formula:
> $c = m^e$

Due to this the message **`m`** can be easily retrieved by taking inverting the exponentiation.

We use the below code to inverting the exponentiation and converting the resultant **`long`** value to **`bytes`**.

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
</details>

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

From the instructions it is clear that the text is encoded in different English characters. We have to decode it using the give samples.  

We write a simple python script to create a character by character map using the given samples and also verify if any of the characters have contradicting character maps. 

<details markdown="block">
  <summary>
  Click here to view the Python code
  </summary>

Code:  

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


