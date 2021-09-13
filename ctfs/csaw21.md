---
layout: default
title: CSAW 2021
nav_order: 3
description: "CSAW 2021 qualification CTF"
permalink: /ctfs/csaw21
has_children: false
parent: CTF list
---

# CSAW qualification 2021
{: .no_toc}
The CSAW qualification 2021 is a [NYUSEC][1] event organized as an yearly event. This year's CSAW qualifications had a variety of
challenges including many categories. The discord invite link is available [here][2] and some of the challenge solves is
discussed in the discord community.  
{: .fs-5 .fw-300 }

Also this year the CSAW CTF included a new category of challenges involving **Industrial Control Systems (ICS)** with some great
challenges involving IOT system's data and packet captures. Was really good to know few different protocols and systems involving
[Modbus][3] and [BACNet][4].

I would be highlighting the solves for challenges that I attempted and/or solved.
{: .fs-5 .fw-300 }

From the rules and the welcome challenge it was clear that the flags were always of the format **`flag{...}`**. The
welcome flag was **`flag{W3Lcom3_7o_CS4w_D1ScoRD}`**. This was available in the channel **#Welcome** of their discord server.
{: .fs-5 .fw-300 }

## Challenge list
{: .no_toc .text-delta}

1. TOC
{:toc}

## Lazy Leaks 📦
Forensics
{: .label .label-green .fs-1 .ml-0}

The name and the description clearly gives away that this a network traffic challenge and the flag is hidden inside the traffic
capture. The challenge instruction is given below and the challenge file can be downloaded from [here][5] or [here][6].

Challenge instructions:
> Someone at a company was supposedly using an unsecured communication channel.
> A dump of company communications was created to find any sensitive info leaks.
> See if you can find anything suspicious or concerning.

A packet capture file is either in the **`.pacp`** or **`.pcapng`** format and both formats can be opened in [Wireshark][7], the goto
tool for analyzing packet captures.

We load the file in **Wireshark** and start analyzing the packets. On first analysis we skim through the packets and find that apart
from plain **TCP** there are **SSHv2** and **Telnet** traffic. In general application layer packets like **HTTP(s)**, **SSH** etc..
contain the real meat of the traffic/user data.

You can filter **SSH** and **Telnet** traffic easily by typing in **ssh** or **telnet** in the Wireshark display filter bar. And then 
start analyzing the contents.

Finally in telnet packet frame **`2043`** we find the flag **`flag{T00_L@ZY_4_$3CUR1TY}`**.

## Poem collection 📝
Web
{: .label .label-green .fs-1 .ml-0}

This challenge was part of the **warm-up** challenges and meant to be easy. From the challenege description it was clear that there is
a [web based vulnerability][8].

Challenge instructions:
> Hey! I made a cool website that shows off my favorite poems. See if you can find flag.txt somewhere!  
> http://web.chal.csaw.io:5003 (now down)

The website presented us with three buttons which read **`poem1.txt`**, **`poem2.txt`** and **`poem3.txt`**. On clicking each of them a
request was sent to the url **`/poems`** with a parameter named **`poem`** whose value was set to the corresponding file name selected.
So this meant the server code was simply reading the file contents and displaying.

Voila 🪄 !! We have an end-point which might include any random file and display its contents to us. To test it we send a request with
the value of **`poem`** set to **`/etc/passwd`**.  

But why specifically this file. Just because this is a file guaranteed by the Linux kernel to be present as this file is used to store 
the user details of the specific Linux box. You can find more details about this file [here][9].  

Also as expected for the above request we get the below content displayed in our browser which means that we can almost view
the contents of any file on that server.

![Output for /etc/passwd][10]

To crack the flag we need to make systematic guess for the location of **`flag.txt`** file. In general the flags are either present in
well know locations listed below but in this challenge it turned out to be a bit different and was within the web server itself.
```
/etc/flag.txt
/flag.txt
./flag.txt
```

In this case none of these worked out and after fiddling around a bit the **`nginx`** public html directory **`/var/www/html`** had the
file **`flag.txt`**.

![Output for flag.txt][11]

As seen in the above image the flag was indeed **`flag{l0c4l_f1l3_1nclusi0n_f0r_7h3_w1n}`**.

## Checker ⏪
Reversing
{: .label .label-green .fs-1 .ml-0}

This was also part of the warm up challenges to get a feel on **`reversing`** based chanllenges. We are presented with the below
instruction and a python code file **`cheker.py`**.

Challenge instructions:
> What's up with all the zeros and ones? Where are my letters and numbers? (This is a reversing challenge.)

<details markdown="block">
  <summary>
    Click to view contents of <b>checker.py</b> file
  </summary>  

  ```python
def up(x):
    x = [f"{ord(x[i]) << 1:08b}" for i in range(len(x))]
    return ''.join(x)

def down(x):
    x = ''.join(['1' if x[i] == '0' else '0' for i in range(len(x))])
    return x

def right(x,d):
    x = x[d:] + x[0:d]
    return x

def left(x,d):
    x = right(x,len(x)-d)
    return x[::-1]

def encode(plain):
    d = 24
    x = up(plain)
    x = right(x,d)
    x = down(x)
    x = left(x,d)
    return x

def main():
    flag = "redacted"
    encoded = encode(flag)
    
    print("What does this mean?")
    encoded = "1010000011111000101010101000001010100100110110001111111010001000100000101000111011000100101111011001100011011000101011001100100010011001110110001001000010001100101111001110010011001100"
    print(encoded)


if __name__ == "__main__":
  main()
  ```
</details>

On looking the code above we note the following:  
1. The **`flag`** variable had the original intended flag which was obviously redacted in this code.
2. The **`encoded`** variable's value is given and in the original intended code this was obtained by passing the original flag to the
**`encode(flag)`** method.
3. The encoded flag is a binary string.
4. The **`encode`** method has four different operations.

The **`up`** operator is the first encoding operation. This basically left shifts each character of the original flag by one (i.e 
multiply by 2) and interprets the result as a 8-bit binary string (**`:8b`** format specifier). Finally the method concatenates all the
binary strings and returns it. The **Reverse** of this method would be to interpret the binary string in chunks of 8 characters,
treating it as an integer, right shift by one and interpret it as a single character.

The **`right`** operator is very simple. It just interchanges the bit positions by moving the first 24 bits to the end of the binary
string as the value of **`d=24`**. The **Reverse** of this method is very simple but we would see in sometime that this is not even
required.

The **`down`** operator is just a simple substituion of **`1`** for **`0`** and **`0`** for **`1`**. The **Reverse** of this method is
itself.

The **`left`** operator calls the **`right`** operator with a value of **`d=len(bitstring) - d`**. Do you see what is happening here ?
This operation right here will nullify the original **`right`** operator call. Additionally this method returns the reversed array.
So effectively the **Reverse** of this method is just removing the original **`right`** operator and returning the reverse of the input.

Now that we have the full understanding, one last piece is to apply the operations in the reverse order of how its applied in the
**`encode`** method.  

Below is the reverse code that I wrote to crack the code:
```python
def reverse(x):
    # effective reverse of left operator applied first
    x = x[::-1]

    # effective reverse of down operator applied next
    x = ''.join(['0' if x[i] == '1' else '1' for i in range(len(x))])

    # right operator skipped

    # effective reverse of up operator applied last
    res = []
    for idx in range(0, len(x), 8):
        val = x[idx:idx+8]
        res.append(f"{int(val, 2) >> 1:c}")
    print("".join(res))
```

Running the given **`reverse`** method with the given encoded binary string we get the flag as **`flag{r3vers!nG_w@rm_Up}`**.

## A Pain in the BAC(net) 🏭
Industrial Control Systems
{: .label .label-green .fs-1 .ml-0}

It was an interesting challenge in the new category of **Industrial Control Systems**. From the name and the instructions of the challenge
it was clear that we are dealing with some kind of IOT traffic capture, more specifically building management network which contains many
sensors.

Challenge instructions:
> Attached is a packet capture taken from a building management network.  
> One of the analog sensors reported values way outside of its normal operating range.  
> Can you determine the object name of this analog sensor?  
> Flag Format: flag{Name-of-sensor}.  
> 
> For example if the object name of this analog sensor was "Sensor_Temp1", the flag would be flag{Sensor_Temp1}.  
> (Note: because there are a limited number of sensors, we're only giving you two guesses for this challenge, so please check your input carefully.)

Also from the title BAC or BACNet seemed to be something more than a random name. On searching the web more on it found that BACNet is a
building mangement network protocol/spec as available [here][4].

The challenge also included a capture file **`bacnet.pcap`** which can be downloaded from [here][12] or [here][13]. Also it being a 
**`.pcap`** file we can try opening it in [Wireshark][7] and see if it recognizes the BACNet protocol.  

It does and there is a complete documentation [here][14] by Wireshark for BACNet support.

On loading the file in Wireshark we find that there are a lot of packet frames and none of them obviously follow the normal traffic.
These packets contain a [BACNet APDU][16] (Application packet data unit) which further comprises of a [BACNet NPDU][15] (Network packet
data unit).  

Also on analyzing the packet more we find that the APDU is of a specific type [BACNet Virtual Link Control][17].  

In general the packets followed a function name where the function names included the following:
1. `object-name`
2. `units`
3. `event-state`
4. `present-value`

And each value reported by the sensors included all the above functions one after the other.  

From this I was able to understand that one of the sensors should have reported an abnormally high or low value and the corresponding
**`object-name`** function would have had the sensor name.  

So I understood I should be filtering the packets with the value of **`present-value`** function. An easy way to apply a filter is to
select any **`present-value`** packet, expand and select the exact node for **`Present-Value`** within the packet, followed by using the
**Apply as Filter** option in the context menu of Wireshark.

This will apply an **`bacapp.present_value.real == <value>`** filter. Just modify this filter as a greater than arbitrary number as shown
here **`bacapp.present_value.real > 1000`**. Most of the packets get filtered out and now we can analyze packet by packet for an arbitrarily
large value in it.

By doing the above I found that the packets **`1803`** and **`1833`** have values of **`99999.9921875`**. As both are from the same IP
address it was clear that both are the same device/sensor. After this it was very easy to locate the **`object-name`** by inspecting the
packets before and after one of those packet's with the same IP/MAC etc.

The sensor name was **`Sensor_12345`** and the final flag as per the instructions was **`flag{Sensor_12345}`**.

## Gotta decrypt them All 📟
Crypto
{: .label .label-green .fs-1 .ml-0}

This was a nice starter crypto challenge and the only one I could dare to attempt and solve. In this the challenge instructions only
provide us with a [**Netcat**][18] url. We can connect to it by entering the command **`nc crypto.chal.csaw.io 5001`** as given in the
instructions itself. Briefly netcat is a plain TCP protocol over which we can perform communication and read write data. It is similar
to socket based chats.

Also the challenge instructions clearly tell us that we need to solve for a series of phrases within a limited time which means the
server has a smaller timeout within which we have to crack all the levels/questions.

Challenge instructions:
> You are stuck in another dimension while you were riding Solgaleo.  
> You have Rotom-dex with you to contact your friends but he won't activate the GPS unless you can prove yourself to him. He is going
> to give you a series of phrases that only you should be able to decrypt and you have a limited amount of time to do so.  
> Can you decrypt them all?  
> nc crypto.chal.csaw.io 5001 (not active now)

With the above background we connect via netcat to the above url as we do not have any other details. On connecting we are presented
with the message - **What does this mean?** followed by a long string containing only **`.`**, **`-`** and **`/`**.

On looking closely the string resembles a morse code except for the literal **`/`** character. So I used an 
online [morse decoder][19] to decode the string. The morse decoding gave a list of space separate integers which
looked like a string expressed as a list of character ordinals.  

This confirmed it was a morse code and so tried to figure out to do the same via python. With little search I was able
to locate a Python package [**decoder**][22] which could perform a variety of decoding including morseDecode.

To do the same via Python code we use a handy collection of CTF utilities package called [**`pwnlib`**][20] which is the Swiss army 
knife for CTF's and similar challenges. It provides a method [**`remote`**][21] which allows us to connect with almost any network
protocol including Netcat.

We use the same to connect as shown below:
```python
# import pwn lib globals
from pwn import *

# host port details
HOST = "crypto.chal.csaw.io"
PORT = 5001

# connect to netcat
conn = remote(host=HOST, port=PORT)

# receive all upto a line starting with "-" and return only 
# the line starting with "-"
val: bytes = conn.recvline_startswith(b"-")
```

<details markdown="block">
  <summary>
  Click here to view the full string
  </summary>  

  ```text
---.. ....- / .---- ----- -.... / ....- ---.. / .---- ..--- ..--- / --... --... / .---- ..--- ..--- / .---- ----- ---.. / .---- ----- -.... / --... ---.. / ---.. ....- / ---.. ----. / ....- ---.. / --... ----. / -.... ---.. / -.... ..... / ..... ...-- / --... ---.. / -.... ---.. / .---- ----- --... / ..... ..--- / ----. ----- / .---- ----- ----. / ----. ----- / .---- ----- ..... / ----. ----- / .---- ----- -.... / ---.. .---- / ..... ..--- / --... --... / --... .---- / ---.. .---- / .---- ..--- ..--- / ----. ----- / .---- ----- -.... / ---.. .---- / .---- .---- ----. / ---.. ----. / ---.. ....- / --... ----- / .---- ----- ..... / --... --... / .---- ..--- ..--- / --... --... / ..... ...-- / --... --... / ---.. ....- / --... ----- / .---- ----- ..... / --... ----. / -.... ---.. / -.... ..... / ..... ...-- / ----. ----- / -.... ---.. / -.... ----. / .---- .---- ----. / ----. ----- / .---- ----- -.... / --... ...-- / .---- ..--- .---- / --... ---.. / .---- ..--- ..--- / -.... ----. / ..... .---- / --... --... / ---.. --... / ---.. ----. / .---- ..--- .---- / --... --... / .---- ..--- ..--- / ---.. ----. / ..... ..--- / --... ---.. / ---.. ....- / --... ----- / .---- ----- ---.. / ---.. ----. / .---- ----- -.... / ---.. ..... / ..... ...-- / ---.. ----. / ---.. ....- / ---.. .---- / ....- ----. / --... --... / .---- ----- -.... / .---- ----- ...-- / ....- ---.. / --... ----. / ---.. ....- / -.... ----. / ....- ---.. / ----. ----- / ---.. ....- / -.... ..... / ....- ----. / ---.. ----. / ..... ----- / ----. ----- / .---- ----- ..... / ---.. ----. / .---- ----- ----. / --... --... / ..... .---- / --... ---.. / .---- ----- ----. / ---.. -.... / .---- ----- ..... / --... ----. / -.... ---.. / ---.. .---- / ..... ----- / ---.. ----. / ---.. ....- / --... ....- / .---- ----- ....- / ---.. ----. / .---- ----- -.... / --... ----- / .---- ----- ----. / ----. ----- / ---.. ....- / --... ....- / .---- ----- ----. / --... --... / ---.. ....- / -.... ----. / .---- ..--- ----- / --... ----. / --... .---- / ---.. ..... / .---- ..--- ..--- / --... --... / -.... ---.. / --... ...-- / ..... .---- / ---.. ----. / .---- ..--- ..--- / --... --... / .---- ..--- .---- / --... ---.. / -.... ---.. / ---.. ..... / ..... ----- / --... --... / -.... ---.. / ----. ----. / .---- ..--- ..--- / ----. ----- / --... .---- / --... ---.. / .---- ----- --... / --... ---.. / -.... ---.. / .---- ----- ....- / .---- ----- --... / --... ---.. / ---.. ....- / ---.. ..--- / .---- ----- ..... / --... --... / .---- ----- ----. / --... ...-- / ....- ---.. / --... --... / .---- ----- ----. / --... ----- / .---- ----- ----. / --... ----. / --... .---- / ---.. ..... / ..... ...-- / --... ---.. / .---- ----- -.... / --... --... / .---- ..--- ..--- / --... ----. / ---.. --... / --... --... / ....- ----. / --... ---.. / .---- ----- -.... / ---.. .---- / ..... ..--- / --... --... / -.... ---.. / .---- ----- --... / ....- ---.. / --... ----. / ---.. ....- / .---- ----- ....- / .---- ----- ----. / ----. ----- / .---- ----- ----. / --... ....- / .---- ----- ----. / --... ---.. / -.... ---.. / .---- ----- ...-- / .---- .---- ----. / ----. ----- / -.... ---.. / --... ---.. / .---- ----- ----. / --... ---.. / -.... ---.. / -.... -.... / .---- ----- ....- / --... --... / ---.. --... / --... ...-- / .---- ..--- ..--- / --... --... / .---- ..--- ..--- / .---- ----- --... / .---- ..--- ----- / --... --... / ---.. --... / --... ...-- / ..... ..--- / --... --... / -.... ---.. / .---- ----- ---.. / .---- ----- --... / --... --... / ---.. ....- / -.... -.... / .---- ----- ----. / --... --... / .---- ----- -.... / --... ...-- / ..... .---- / --... --... / ---.. ....- / ----. ----. / .---- ..--- ----- / ----. ----- / .---- ----- -.... / --... ...-- / .---- ..--- ..--- / --... ---.. / .---- ----- -.... / .---- ----- ...-- / ....- ----. / --... --... / ---.. --... / ---.. -.... / .---- ----- ..... / --... ---.. / ---.. ....- / .---- ----- ---.. / .---- ----- ....- / --... ---.. / -.... ---.. / ---.. ..... / .---- ..--- .---- / --... ----. / -.... ---.. / ---.. .---- / ..... ...-- / --... --... / ---.. ....- / ---.. ..--- / .---- ----- ---.. / --... --... / -.... ---.. / ---.. -.... / .---- ----- -.... / ----. ----- / .---- ----- ----. / --... ....- / .---- ----- ..... / ---.. ----. / .---- ..--- ..--- / ----. ----. / ..... ----- / ----. ----- / ---.. --... / --... ...-- / ..... ..--- / --... ---.. / -.... ---.. / ----. ----- / .---- ----- ....- / --... --... / .---- ----- ----. / --... ----- / .---- ----- ..... / --... --... / ---.. --... / ----. ----- / .---- ----- ---.. / --... --... / .---- ----- ----. / ---.. ----. / .---- ..--- ----- / --... --... / ---.. ....- / -.... ----. / ..... ..--- / ----. ----- / ---.. ....- / --... --... / .---- .---- ----. / --... --... / .---- ----- -.... / .---- ----- ----- / .---- ----- -.... / --... --... / .---- ..--- ..--- / --... ...-- / ....- ---.. / --... ---.. / ---.. ....- / ---.. ----. / .---- .---- ----. / --... ---.. / .---- ..--- ..--- / --... ---.. / .---- ----- --... / ---.. ----. / ..... ----- / ---.. .---- / ....- ---.. / --... ----. / --... .---- / ---.. .---- / ....- ----. / --... ---.. / --... .---- / --... ...-- / .---- ..--- .---- / ---.. ----. / .---- ----- -.... / ---.. .---- / .---- ..--- .---- / ---.. ----. / ---.. --... / ---.. ----. / ..... ..--- / ----. ----- / ---.. ....- / .---- ----- --... / ..... ----- / --... --... / .---- ..--- ..--- / --... --... / ..... ...-- / ---.. ----. / .---- ..--- ..--- / ---.. ..... / ..... ----- / --... ---.. / -.... ---.. / .---- ----- ...-- / .---- .---- ----. / --... ----. / ---.. ....- / ---.. .---- / ..... ...-- / --... ----. / --... .---- / ----. ----- / .---- ----- ----. / ---.. ----. / .---- ----- ----. / ---.. ----. / ....- ---.. / --... ----. / -.... ---.. / -.... -.... / .---- ----- --... / --... --... / ..... ----- / ---.. ----. / ....- ---.. / --... --... / --... .---- / -.... ----. / .---- ..--- ----- / ---.. ----. / .---- ----- -.... / --... --... / .---- ..--- ..--- / --... ----. / ---.. ....- / -.... ----. / .---- ..--- ----- / ---.. ----. / .---- ----- -.... / .---- ----- ...-- / .---- .---- ----. / --... ----. / ---.. --... / ---.. .---- / .---- ..--- ----- / --... --... / --... .---- / ---.. ----. / .---- ..--- .---- / --... --... / .---- ----- -.... / ----. ----. / .---- ..--- ----- / --... ---.. / .---- ..--- ..--- / --... ----- / .---- ----- ----. / --... --... / .---- ----- -.... / --... --... / ..... ----- / --... ----. / -.... ---.. / ---.. ..... / .---- ..--- ----- / ----. ----- / ---.. --... / --... ...-- / ....- ----. / --... ----. / ---.. --... / -.... ----. / ....- ---.. / --... ---.. / ---.. ....- / --... ...-- / ..... ..--- / --... ---.. / -.... ---.. / .---- ----- --... / .---- ..--- ----- / --... ---.. / --... .---- / ---.. ..... / .---- .---- ----. / --... ---.. / ---.. --... / --... ---.. / .---- ----- ----. / ---.. ----. / .---- ----- ----. / --... ....- / .---- ----- -.... / --... ---.. / .---- ..--- ..--- / ----. ----- / .---- ----- ---.. / ---.. ----. / .---- ----- -.... / .---- ----- ...-- / ....- ---.. / --... ---.. / .---- ----- ----. / -.... ----. / .---- ..--- .---- / ---.. ----. / ---.. --... / --... ...-- / .---- ..--- ----- / ----. ----- / .---- ----- ----. / ---.. ..... / .---- ..--- .---- / ----. ----- / .---- ----- -.... / -.... ----. / .---- ..--- ----- / --... --... / ---.. ....- / .---- ----- ....- / .---- ----- ---.. / --... --... / .---- ..--- ..--- / -.... ..... / .---- ..--- .---- / --... ---.. / ..... ----- / --... --... / .---- ..--- ..--- / --... --... / .---- ----- -.... / ---.. .---- / ....- ----. / --... ---.. / .---- ----- -.... / -.... ..... / ..... .---- / --... --... / ..... ----- / ---.. ..--- / .---- ----- -.... / ----. ----- / -.... ---.. / ---.. .---- / ..... ..--- / ----. ----- / -.... ---.. / ---.. ..... / ....- ---.. / ---.. ----. / .---- ----- -.... / --... ....- / .---- ----- ..... / --... ---.. / -.... ---.. / --... ....- / .---- ----- ....- / ----. ----- / .---- ----- -.... / .---- ----- ....- / .---- ----- ---.. / --... ----. / ---.. ....- / ---.. ----. / .---- ..--- ..--- / --... --... / .---- ..--- ..--- / .---- ----- ---.. / .---- ----- -.... / --... ---.. / ---.. ....- / ---.. ----. / ....- ---.. / --... ----. / -.... ---.. / -.... ..... / ..... ...-- / --... ---.. / -.... ---.. / .---- ----- --... / ..... ..--- / ----. ----- / .---- ----- ----. / ----. ----- / .---- ----- ..... / ----. ----- / .---- ----- -.... / ---.. .---- / ..... ..--- / --... --... / --... .---- / ---.. .---- / .---- ..--- ..--- / ----. ----- / .---- ----- -.... / ---.. .---- / .---- .---- ----. / ---.. ----. / ---.. ....- / --... ----- / .---- ----- ..... / --... --... / .---- ..--- ..--- / --... --... / ..... ...-- / --... --... / ---.. ....- / --... ----- / .---- ----- ..... / --... ----. / -.... ---.. / -.... ..... / ..... ...-- / ----. ----- / -.... ---.. / -.... ----. / .---- .---- ----. / ----. ----- / .---- ----- -.... / --... ...-- / .---- ..--- .---- / --... ---.. / .---- ..--- ..--- / -.... ----. / ..... .---- / --... --... / ---.. --... / ---.. ----. / .---- ..--- .---- / --... --... / .---- ..--- ..--- / ---.. ----. / ..... ..--- / --... ---.. / ---.. ....- / --... ----- / .---- ----- ---.. / ---.. ----. / .---- ----- -.... / ---.. ..... / ..... ...-- / ---.. ----. / ---.. ....- / ---.. .---- / ....- ----. / --... --... / .---- ----- -.... / .---- ----- ...-- / ....- ---.. / --... ----. / ---.. ....- / -.... ----. / ....- ---.. / ----. ----- / ---.. ....- / -.... ..... / ....- ----. / ---.. ----. / ..... ----- / ----. ----- / .---- ----- ..... / ---.. ----. / .---- ----- ----. / --... --... / ..... .---- / --... ---.. / .---- ----- ----. / ---.. -.... / .---- ----- ..... / --... ----. / -.... ---.. / ---.. .---- / ..... ----- / ---.. ----. / ---.. ....- / --... ....- / .---- ----- ....- / ---.. ----. / .---- ----- -.... / --... ----- / .---- ----- ----. / ----. ----- / ---.. ....- / --... ....- / .---- ----- ----. / --... --... / ---.. ....- / -.... ----. / .---- ..--- ----- / --... ----. / --... .---- / ---.. ..... / .---- ..--- ..--- / --... --... / -.... ---.. / --... ...-- / ..... .---- / ---.. ----. / .---- ..--- ..--- / --... --... / .---- ..--- .---- / --... ---.. / -.... ---.. / ---.. ..... / ..... ----- / --... --... / -.... ---.. / ----. ----. / .---- ..--- ..--- / ----. ----- / --... .---- / --... ---.. / .---- ----- --... / --... ---.. / -.... ---.. / .---- ----- ....- / .---- ----- --... / --... ---.. / ---.. ....- / ---.. ..--- / .---- ----- ..... / --... --... / .---- ----- ----. / --... ...-- / ....- ---.. / --... --... / .---- ----- ----. / --... ----- / .---- ----- ----. / --... ----. / --... .---- / ---.. ..... / ..... ...-- / --... ---.. / .---- ----- ...-- / .---- .---- ..--- / .---- ----- ---.. / ---.. ----- / ---.. ....- / --... --... / --... ..... / ---.. ----. / .---- ..--- ..--- / ....- ---.. / .---- ..--- ----- / --... ---.. / ---.. ....- / --... ...-- / .---- ..--- ----- / --... ---.. / .---- ----- -.... / ----. ----. / ....- ---.. / --... --... / .---- ----- -.... / ---.. .---- / .---- ..--- .---- / --... ---.. / .---- ..--- ..--- / --... --... / ..... ...-- / --... ---.. / .---- ..--- ..--- / ----. ----. / ....- ---.. / --... --... / .---- ..--- ..--- / ---.. ----. / ..... .---- / --... --... / -.... ---.. / --... ...-- / ..... ..--- / --... ----. / ---.. ....- / -.... ..... / .---- ..--- .---- / --... ---.. / .---- ..--- ..--- / --... --... / .---- ..--- .---- / --... ---.. / .---- ..--- ..--- / ---.. .---- / ....- ----. / --... --... / -.... ---.. / -.... ----. / ..... .---- / --... --... / .---- ..--- ..--- / ---.. .---- / .---- .---- ----. / --... --... / ---.. ....- / --... ...-- / ..... .---- / --... ---.. / .---- ----- -.... / ---.. ..... / ..... ..--- / --... ----. / -.... ---.. / --... ...-- / ....- ---.. / --... ----. / -.... ---.. / ----. ----. / .---- .---- ----. / --... --... / -.... ---.. / .---- ----- ...-- / .---- ..--- ..--- / --... --... / .---- ..--- ..--- / .---- ----- ...-- / ..... ...-- / --... ---.. / .---- ..--- ..--- / --... --... / .---- ..--- .---- / --... --... / .---- ..--- ..--- / --... ...-- / ....- ----. / --... --... / -.... ---.. / --... ...-- / .---- ..--- ----- / --... ---.. / .---- ..--- ..--- / -.... ..... / .---- ..--- ..--- / --... ---.. / ---.. ....- / ---.. ----. / .---- ..--- ..--- / --... ---.. / .---- ..--- ..--- / ---.. ..... / .---- ..--- ----- / --... ---.. / -.... ---.. / .---- ----- ...-- / ..... ..--- / --... --... / ---.. ....- / .---- ----- ...-- / ..... ----- / --... --... / -.... ---.. / .---- ----- --... / ..... ----- / --... --... / .---- ----- -.... / -.... ----. / ..... ..--- / --... ---.. / .---- ----- -.... / --... --... / ..... ...-- / --... ---.. / .---- ..--- ..--- / ---.. ..... / .---- ..--- .---- / --... ---.. / ---.. ....- / ---.. ----. / -.... .----
  ```
</details>

Installed it and used its apis to perform the same via python. One issue while using this library was the untintended
**`/`** character. As I realized it was just denoting space, I split the string by the **`/`** character and stripped each
part off its start and end spaces, appended to a list and then performed morse decoding for each of the sequence.  

```python
from decoder.decoder import morseDecode

# convert to str and split by "/" that delimits the characters
# in the morse code
val = val.decode().split("/")

# perform morse code decoding
nums = [morseDecode(x).strip() for x in val]
```

<details markdown="block">
  <summary>
  Click here to view a sample after morse decoding
  </summary>  

  ```text
84 106 48 122 77 122 108 106 78 84 89 48 79 68 65 53 78 68 107 52 90 109 90 105 90 106 81 52 77 71 81 122 90 106 81 119 89 84 70 105 77 122 77 53 77 84 70 105 79 68 65 53 90 68 69 119 90 106 73 121 78 122 69 51 77 87 89 121 77 122 89 52 78 84 70 108 89 106 85 53 89 84 81 49 77 106 103 48 79 84 69 48 90 84 65 49 89 50 90 105 89 109 77 51 78 109 86 105 79 68 81 50 89 84 74 104 89 106 70 109 90 84 74 109 77 84 69 120 79 71 85 122 77 68 73 51 89 122 77 121 78 68 85 50 77 68 99 122 90 71 78 107 78 68 104 107 78 84 82 105 77 109 73 48 77 109 70 109 79 71 85 53 78 106 77 122 79 87 77 49 78 106 81 52 77 68 107 48 79 84 104 109 90 109 74 109 78 68 103 119 90 68 78 109 78 68 66 104 77 87 73 122 77 122 107 120 77 87 73 52 77 68 108 107 77 84 66 109 77 106 73 51 77 84 99 120 90 106 73 122 78 106 103 49 77 87 86 105 78 84 108 104 78 68 85 121 79 68 81 53 77 84 82 108 77 68 86 106 90 109 74 105 89 122 99 50 90 87 73 52 78 68 90 104 77 109 70 105 77 87 90 108 77 109 89 120 77 84 69 52 90 84 77 119 77 106 100 106 77 122 73 48 78 84 89 119 78 122 78 107 89 50 81 48 79 71 81 49 78 71 73 121 89 106 81 121 89 87 89 52 90 84 107 50 77 122 77 53 89 122 85 50 78 68 103 119 79 84 81 53 79 71 90 109 89 109 89 48 79 68 66 107 77 50 89 48 77 71 69 120 89 106 77 122 79 84 69 120 89 106 103 119 79 87 81 120 77 71 89 121 77 106 99 120 78 122 70 109 77 106 77 50 79 68 85 120 90 87 73 49 79 87 69 48 78 84 73 52 78 68 107 120 78 71 85 119 78 87 78 109 89 109 74 106 78 122 90 108 89 106 103 48 78 109 69 121 89 87 73 120 90 109 85 121 90 106 69 120 77 84 104 108 77 122 65 121 78 50 77 122 77 106 81 49 78 106 65 51 77 50 82 106 90 68 81 52 90 68 85 48 89 106 74 105 78 68 74 104 90 106 104 108 79 84 89 122 77 122 108 106 78 84 89 48 79 68 65 53 78 68 107 52 90 109 90 105 90 106 81 52 77 71 81 122 90 106 81 119 89 84 70 105 77 122 77 53 77 84 70 105 79 68 65 53 90 68 69 119 90 106 73 121 78 122 69 51 77 87 89 121 77 122 89 52 78 84 70 108 89 106 85 53 89 84 81 49 77 106 103 48 79 84 69 48 90 84 65 49 89 50 90 105 89 109 77 51 78 109 86 105 79 68 81 50 89 84 74 104 89 106 70 109 90 84 74 109 77 84 69 120 79 71 85 122 77 68 73 51 89 122 77 121 78 68 85 50 77 68 99 122 90 71 78 107 78 68 104 107 78 84 82 105 77 109 73 48 77 109 70 109 79 71 85 53 78 103 112 108 80 84 77 75 89 122 48 120 78 84 73 120 78 106 99 48 77 106 81 121 78 122 77 53 78 122 99 48 77 122 89 51 77 68 73 52 79 84 65 121 78 122 77 121 78 122 81 49 77 68 69 51 77 122 81 119 77 84 73 51 78 106 85 52 79 68 73 48 79 68 99 119 77 68 103 122 77 122 103 53 78 122 77 121 77 122 73 49 77 68 73 120 78 122 65 122 78 84 89 122 78 122 85 120 78 68 103 52 77 84 103 50 77 68 107 50 77 106 69 52 78 106 77 53 78 122 85 121 78 84 89 61
  ```
</details>

Now we have a list of integers which needs to be converted to characters and concatenated to form a string. This
was very easy to achieve using the below snippet.  
```python
# convert each number in the morse code decoded array to its
# respective character
strval = ""
for x in nums:
    strval = strval + chr(int(x))
```

<details markdown="block">
  <summary>
  Click here to view the sample string obtained after the above
  </summary>  

  ```text
Tj0zMzljNTY0ODA5NDk4ZmZiZjQ4MGQzZjQwYTFiMzM5MTFiODA5ZDEwZjIyNzE3MWYyMzY4NTFlYjU5YTQ1Mjg0OTE0ZTA1Y2ZiYmM3NmViODQ2YTJhYjFmZTJmMTExOGUzMDI3YzMyNDU2MDczZGNkNDhkNTRiMmI0MmFmOGU5NjMzOWM1NjQ4MDk0OThmZmJmNDgwZDNmNDBhMWIzMzkxMWI4MDlkMTBmMjI3MTcxZjIzNjg1MWViNTlhNDUyODQ5MTRlMDVjZmJiYzc2ZWI4NDZhMmFiMWZlMmYxMTE4ZTMwMjdjMzI0NTYwNzNkY2Q0OGQ1NGIyYjQyYWY4ZTk2MzM5YzU2NDgwOTQ5OGZmYmY0ODBkM2Y0MGExYjMzOTExYjgwOWQxMGYyMjcxNzFmMjM2ODUxZWI1OWE0NTI4NDkxNGUwNWNmYmJjNzZlYjg0NmEyYWIxZmUyZjExMThlMzAyN2MzMjQ1NjA3M2RjZDQ4ZDU0YjJiNDJhZjhlOTYzMzljNTY0ODA5NDk4ZmZiZjQ4MGQzZjQwYTFiMzM5MTFiODA5ZDEwZjIyNzE3MWYyMzY4NTFlYjU5YTQ1Mjg0OTE0ZTA1Y2ZiYmM3NmViODQ2YTJhYjFmZTJmMTExOGUzMDI3YzMyNDU2MDczZGNkNDhkNTRiMmI0MmFmOGU5NgplPTMKYz0xNTIxNjc0MjQyNzM5Nzc0MzY3MDI4OTAyNzMyNzQ1MDE3MzQwMTI3NjU4ODI0ODcwMDgzMzg5NzMyMzI1MDIxNzAzNTYzNzUxNDg4MTg2MDk2MjE4NjM5NzUyNTY=
  ```
</details>

The above operation gave us a string as shown above which is a typical base64 encoded string. So we immediately try
decoding it using base64.  
```python
from decoder.decoder import base64Decode

# Base64 decode the encoded string
expvals = base64Decode(strval)
```

<details markdown="block">
  <summary>
  Click here to view the sample string after base 64 decoding
  </summary>  

  ```text
N=339c564809498ffbf480d3f40a1b33911b809d10f227171f236851eb59a45284914e05cfbbc76eb846a2ab1fe2f1118e3027c32456073dcd48d54b2b42af8e96339c564809498ffbf480d3f40a1b33911b809d10f227171f236851eb59a45284914e05cfbbc76eb846a2ab1fe2f1118e3027c32456073dcd48d54b2b42af8e96339c564809498ffbf480d3f40a1b33911b809d10f227171f236851eb59a45284914e05cfbbc76eb846a2ab1fe2f1118e3027c32456073dcd48d54b2b42af8e96339c564809498ffbf480d3f40a1b33911b809d10f227171f236851eb59a45284914e05cfbbc76eb846a2ab1fe2f1118e3027c32456073dcd48d54b2b42af8e96
e=3
c=152167424273977436702890273274501734012765882487008338973232502170356375148818609621863975256
  ```
</details>

Base64 decoding operation gives us a long string containing specific values for **`N`**, **`e`** and **`c`**. In 
Cryptography these have special meaning. Refer this [link][23] for a birds eye view to understand the basics
in case you do not have any idea on RSA public key cryptography.  

In RSA **`N`** refers to the public key, **`e`** refers to the exponent used, **`c`** is the cipher text obtained
from **`p`** the plaintext. Also **`c`** is computed using the formula **`c = p ^ e mod(N)`**. Looking at this
formula initially it looks totally impossible to get the plain text, which needs to be computed to go ahead in
this challenge.

If **`N`** is factorable into their prime factor pairs easily then the plain text can be cracked. In addition to that
there are lot of tools which perform different types of attacks on the public key to exploit any inherent vulnerability.
Once such tool is the [**`RsaCtfTool`**][24]. So I quickly installed it and tried to crack the factors. But I hit a
great road block when the tool was not able to crack it.  

At this point I went back to the basics of reviewing the RSA formulae again and, looking at the encryption formula it
did strike me that what if **`p ^ e`** was originally less than **`N`**. Did you see what that would mean ?  

It would mean that **`c = p ^ e`**. Not clear yet, then read on. What is **`5 mod(10)`** ? Five right. So **`mod(N)`**
would have not effect if the original number is less than **`N`**. This seemed to be the only way out and I decided to
give it a try.

In our case, **`c`** the cipher text and **`e`** the exponent is known. So the plain text **`p`** would just be
the cube root of **`c`**. Again cube root of large numbers using the Python in built methods does behave weirdly at times.
So I decided to make use of [**`sympy`**][25] a scietific math library for Python to compute the cube root as below.
```python
from sympy import cbrt

# Split the string to an array each index containing N,e,c in that
# order making total of 3 indices in the str array
nec = expvals.split(os.linesep)

# obtain the value of the cipher text by splitting at the equals
# sign and getting the second part
c = int(nec[2].split("=")[1])

# find cube root of the cipher text to get the plain text
p = cbrt(c)

# assert the cube root computation is correct
assert c == pow(p, 3)
```

The plain text obtained after performing cuberoot is **`5338762031123926997889413968486`**. This is a long value and in 
general plain text and/or cipher text are converted to and from their long representations using **`Crypto.Util.number`**
package within [PyCryptodome][26].

We use **`long_to_bytes`** method within the above package to convert a number to its string and **`bytes_to_long`** to
the reverse of it.
```python
from Cipher.Util.number import long_to_bytes

# convert plain text long value to bytes string
pstr = long_to_bytes(p)
```

This gives us a string **`Cbxrzba Anzrf`**. Well this can be the answer to the question, but I had doubts as it was not a 
readable string. Still I did try it out as there were not negative points for attempts. Indeed my doubts were right and
it did not accept this as an answer.  

At this point I was exhausted and almost gave up even though I did try a lot to think through it and almost burried myself
in shame after cracking it finally. It was a damn simple [**ROT13**][27] substitution cipher. So how did I get hold of this
last piece of information.  

As I said I had almost given up and I could not think more. However it did look to me there is some kind of encoding done to
the original string. So I started searching for decoder websites online. Most of them just showed the results of specific
decoding done to a string given but [Dencode][28] came to my rescue.

This one showed almost an exhaustive list of decodings in a single page for any string entered. So I entered the string
obtained in the last step and scrolled through the decoded strings nonchalantly. My eyes almost popped out when I came
to the **ROT13** cipher column because it read **Pokemon Names**. Now that is something readable, I submitted it to confirm and
indeed it did work.

To perform the same using Python I used the ROT13 cipher present in the **decoder** package we used before.
```python
from decoder.decoder import rot13Decode

# perform ROT13 substitution cipher and return it
ans = rot13Decode(pstr.decode())
```  

So to summarize, for a single Morse code given the following need to be performed in order:
1. Morse decode
2. Convert each of the list of ordinals to character and concatenate to obtain the Base64 string
3. Decode the Base64 string to obtain the original string which contains each of **`N`**, **`e`** and **`c`** in their
   separate line.
4. Find the cube root of **`c`**, the cipher text to obtain the plain text **`p`**.
5. This would be a long number. Convert it to a string.
6. Finally perform ROT13 substitution cipher to obtain the answer. 

We need to send the final answer back to Netcat using the below:
```python
# The application prints a ">>" string before accepting the answer
# So sendlineafter will accept ">>" and once read, will write back
# the value of "ans". We encode() the "ans" object in order to convert
# it to bytes object which is more safe to use while dealing with
# netcat
conn.sendlineafter(b">>", ans.encode())
```

Now this is the operation that needs to be done for more than one MorseCode. Once answer is submitted we get the next morse code
to perform the operations again. There were totally six iterations to be done to reach the flag.

<details markdown="block">
  <summary>
  Click here to view the full code
  </summary>

```python
import os

# import pwn lib globals
from pwn import *
from decoder.decoder import morseDecode, base64Decode, rot13Decode
from sympy import cbrt
from Crypto.Util.number import long_to_bytes

# host port details
HOST = "crypto.chal.csaw.io"
PORT = 5001

# connect to netcat
conn = remote(host=HOST, port=PORT)


def decrypt(enc: bytes):
    # convert to str and split by "/" that delimits the characters
    # in the morse code
    enc = enc.decode().split("/")

    # perform morse code decoding
    nums = [morseDecode(x).strip() for x in enc]

    # convert each number in the morse code decoded array to its
    # respective character
    strval = ""
    for x in nums:
        strval = strval + chr(int(x))

    # Base64 decode the encoded string
    expvals = base64Decode(strval)

    # Split the string to an array each index containing N,e,c in that
    # order making total of 3 indices in the str array
    nec = expvals.split(os.linesep)

    # obtain the value of the cipher text by splitting at the equals
    # sign and getting the second part
    c = int(nec[2].split("=")[1])

    # find cube root of the cipher text to get the plain text
    p = cbrt(c)

    # assert the cube root computation is correct
    assert c == pow(p, 3)

    # convert plain text long value to bytes string
    pstr = long_to_bytes(p)

    # perform ROT13 substitution cipher and return it
    ans = rot13Decode(pstr.decode())
    print("rot13-", ans)
    return ans


while True:
    # receive all lines that dont start with a "-" i.e
    # the morse code line
    val: bytes = conn.recvline_pred(lambda line: not line.decode().startswith("-"))
    print(val.decode())
    try:
        # receive all upto a line starting with "-" and return only
        # the line starting with "-"
        val: bytes = conn.recvline_startswith(b"-")
    except:
        # in the last stage after crackng all 6 for printing
        # anything that is sent including the flag
        val: bytes = conn.recvline()
        print(val)

    # call decrypt method
    ans = decrypt(enc=val)

    # The application prints a ">>" string before accepting the answer
    # So sendlineafter will accept ">>" and once read, will write back
    # the value of ans. We encode() the str object in order to convert
    # it to bytes object which is more safe to use while dealing with
    # netcat
    conn.sendlineafter(b">>", ans.encode())
    rec = conn.recvline()
    print(rec)

  ```  

View the code in action below:

![Gotta decrypt them all][29]
</details>  
  
The final flag obtained is **`flag{We're_ALrEadY_0N_0uR_waY_7HE_j0UrnEY_57aR75_70day!}`**.


## Contact us 📨
Forensics
{: .label .label-green .fs-1 .ml-0}

This is a forensics challenge, with the challenge instructions and an additional hint to guide us to the correct
flag. We are given two files (ContactUs.pcap and sslkeyfile.txt) in this challenge and the same can be downloaded [here][30].

Challenge instructions:
> Veronica sent a message to her client via their website's Contact Us page. Can you find the message?

Additional hint:
> Some of you with eagle eyes may have noticed another flag hiding in the packet capture:  
> flag{$$L_d3crypt3d}  
> The author had a browser tab open when capturing packets for the challenge and was surfing the net for flags 
> because that's what you do when you're a challenge author.  
> Moreover knowing this flag will not help you get closer to the solve. There's no limit to the number of attempts
> to submit this particular flag so nobody was affected.  
> We do regret any time you lost though.  
> Also, there's a server associated with the challenge but it's not necessary to connect to it to solve the 
> challenge. We're therefore taking the server offline to streamline your effort with this task. Good luck!

As in the previous network analysis challenges, the **`.pcap`** file needs to be analyzed using [Wireshark][7]. The 
additional file **`sslkeyfile.txt`** suggests that the packet capture contains only the encrypted communication as
the communication has happened over a secure channel.  
As the SSL key change details are required to view the decrypted traffic the same is provided. You can read more on
the same [here][31].  

Based on the above details we open the **`ContactUs.pcap`** file in Wireshark and also load the **`sslkeyfile.txt`**
in it. After doing the same, Wireshark will automatically decrypt the traffic with the available SSL keys in the file.  

On a high level analysis of the available frames we see that there are very few **HTTP/1.1** and more of [**HTTP2**][32].
As there are no flag details available in the **HTTP/1.1** packets we need to go about analyzing the **HTTP2** packets.

There are roughly *3600* frames out of which around *539* are HTTP2 packets. The same can be seen by entering the display
filter in Wireshark as **http2**. Analyzing *539* packets is quite tiresome and I wanted to filter it more.  

Within **HTTP2** packets there are mainly two category of requests i.e HEADERS and DATA packets. HEADERS mainly contain
all the URL info and other request information which otherwise is available in plain text in HTTP/1.1. But HEADERS packet
do not contain any application/user data. This means we are looking only for data packets which can be filtered easily
in Wireshark by setting the display filter to **http2.type == 0**. This further reduces our search space to around *283* 
frames.  

After applying the above filters I could see mainly two types of packets **`DoH`**(DNS over HTTPs) and **`HTTP2`**. Often
our flags lie in the HTTP application data. So I decided to analyze the HTTP2 frames and found the required flag in 
frame **`2534`**.  

> Note:  
> Another really good filter that I discovered in the course of drafting this writeup is **`http2.data.data contains "flag"`**.
> This filters us down to just 9 frames which can be analyzed very easily.  
>
> A complete reference of the available filters can be searched from the index [here][33].  
> Protocol specific reference of display filters can be searched [here][34].  
> 
> For **`HTTP2`** the same is available [here][35].  


<details markdown="block">
  <summary>
  Click here to view the JSON data that contained the flag
  </summary>

```json
{
    "websiteId": "19460325-6441-4243-8b04-b46ca980c66e",
    "widgetId": "8255c38e-a587-47a4-a20e-59be4641c0ee",
    "pageId": "63d86d88-7512-46e2-b820-3b9933274865",
    "accountId": "f0800d6f-02ed-11ec-8235-3417ebe72601",
    "domainName": "diskretedevelopment.com",
    "optedToSubscribe": false,
    "locale": "en-MY",
    "metadata": {
        "formIdentifier": "CONTACT_US",
        "pathName": "/contact-us",
        "deviceType": "desktop",
        "deviceOs": "Linux",
        "browserName": "Firefox"
    },
    "formData": [
        {
            "label": "Name",
            "value": "Veronica Mars",
            "keyName": "name"
        },
        {
            "label": "Email",
            "value": "vmarsinvestigations87@gmail.com",
            "replyTo": true,
            "keyName": "email"
        },
        {
            "label": "Message",
            "value": "flag{m@r$hm3ll0w$}",
            "keyName": "message"
        },
        {
            "label": "_app_id",
            "value": ""
        }
    ],
    "recaptchaToken": "03AGdBq27seuHr1NzCgH4LKc0PErd_Z8rvPuNireiinjHmuqONbkC0cXTVOQL5xWue1quL9xgshpN00ns1gH6o4eGpiUmc39gqUcqT-YCgdaDVB5Z7UwM8ZBMJWXXiE2dLDt9Qb4LBxWVnVAo64_oRr1f8vS6xNMK0MLqOI2h83SlvfqJkFiJUc1pGNkjzNYjYMVbMcJVcUr6tjuU5seSUhWm_UzxhuO24LJP9kJvzRzhW_sYh_zLF525GUCOvDFXm6KaxNdOPMFFReEgHx1yoQIdcZhSJmO_W-0CPCiGmZQuEkhoT4i3vtukqbkjHDxU7Id72HS387zsCAUL8dvVWopnua2q6xPVkJQhpkeUZ5K2OWMHpqfxRvgOPfwp6df5sb86SupPle4LCFV2RBZyGoe4TYnOHSJhq1zzytQTxo3NXsPuR7buo4UFwN2B2o_TVjZC6Juxac-DvcL2RgHuUq4kTAykC1gcimQ"
}
```  
</details>

The final flag was available as the value of the **`Message`** field and read as **`flag{m@r$hm3ll0w$}`**.


[1]: https://ctftime.org/team/439
[2]: https://discord.gg/Zj2H6EaAkZ
[3]: https://www.modbustools.com/modbus.html
[4]: http://www.bacnet.org/
[5]: https://ctf.csaw.io/files/c02766e04dbe8a2a36ed93e16b4a2262/Lazy_Leaks.pcapng?token=eyJ1c2VyX2lkIjo5MDAsInRlYW1faWQiOm51bGwsImZpbGVfaWQiOjI5Njd9.YT7jtA.TzrFwwj-byaW5m5QEfmE-Z2iA24
[6]: https://mega.nz/file/F9AnmK6R#LGqVjweKw-80WnYr_BzHIwiEM79R0PcqM3UF9KuKjmM
[7]: https://www.wireshark.org/
[8]: https://owasp.org/www-project-top-ten/
[9]: https://linuxize.com/post/etc-passwd-file/
[10]: https://gcdn.pbrd.co/images/LaiFCckpn9QS.png?o=1
[11]: https://gcdn.pbrd.co/images/7OY9Cz74eqht.png?o=1
[12]: https://ctf.csaw.io/files/3d52efdaecfe45e79f863771171d5dfb/bacnet.pcap?token=eyJ1c2VyX2lkIjo5MDAsInRlYW1faWQiOm51bGwsImZpbGVfaWQiOjI5NzB9.YT8HMA.SDY721fspU2dbXF4VUk5AtrK-kg
[13]: https://mega.nz/file/oxZGXZbR#bRX-k5QRC0fJOmZG8nj0Lj7pl4DiTHHBL1fi5XnBt8w
[14]: https://wiki.wireshark.org/Protocols/bacnet
[15]: http://www.bacnetwiki.com/wiki/index.php?title=Network_Layer_Protocol_Data_Unit
[16]: http://www.bacnetwiki.com/wiki/index.php?title=APDU
[17]: http://www.bacnetwiki.com/wiki/index.php?title=BACnet_Virtual_Link_Layer
[18]: http://netcat.sourceforge.net/
[19]: https://morsedecoder.com/
[20]: https://docs.pwntools.com/en/stable/install.html
[21]: https://docs.pwntools.com/en/stable/globals.html
[22]: https://github.com/Anon-Exploiter/decoder
[23]: https://resources.infosecinstitute.com/topic/introduction-to-the-rivest-shamir-adleman-rsa-encryption-algorithm/
[24]: https://github.com/borari/RsaCtfTool
[25]: https://www.sympy.org/en/index.html
[26]: https://www.pycryptodome.org/en/latest/
[27]: https://en.wikipedia.org/wiki/ROT13
[28]: https://dencode.com/
[29]: https://gcdn.pbrd.co/images/KgEedvBcwA7h.gif?o=1
[30]: https://mega.nz/file/lxwBDSbR#JX2A5yNDLqtSkACP8Vs9qu9KwRXY3wpfBfqccWHS2oM
[31]: https://unit42.paloaltonetworks.com/wireshark-tutorial-decrypting-https-traffic/
[32]: https://httpwg.org/specs/rfc7540.html#DATA
[33]: https://www.wireshark.org/docs/dfref/
[34]: https://wiki.wireshark.org/ProtocolReference
[35]: https://www.wireshark.org/docs/dfref/h/http2.html