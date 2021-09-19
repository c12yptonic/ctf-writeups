---
layout: default
title: FWord 2021
nav_order: 2
description: "FWord 2021 CTF solves"
permalink: /ctfs/fword21
has_children: false
parent: CTF List
---

# FWord 2021
{: .no_toc}
The FWord 2021 is a [FWord][1] event organized as an yearly event. This year's FWord had a variety of challenges 
including many categories. The discord invite link is available [here][2] and some of the challenge solves is
discussed in the discord community.
{: .fs-5 .fw-300 }

I would be highlighting the solves for challenges that I attempted and/or solved.
{: .fs-5 .fw-300 }

From the rules and the welcome challenge it was clear that the flags were always of the format **`FwordCTF{...}`**.
{: .fs-5 .fw-300 }

## Challenge list
{: .no_toc .text-delta}

1. TOC
{:toc}

## Listen 📭
Forensics
{: .label .label-green .fs-1 .ml-0}

This was one of the easier challenges in forensics category. The challenge had a file attached to it with the name
**`challenge.pcap`**. To be clear **`.pacp`** is a **Packet Capture** file which means we would be using [Wireshark][3]
to analyze the packet capture.

A packet capture is basically a complete recording of network events in a format that be loaded back and analyzed using
various tools. So we expect to either find some information within the packet capture or some other sensitive information
which will allow us to go ahead in the challenge.

The challenge had the below instruction:
> How Deep Can You Possibly Dig?
> Flag Format: FwordCTF{....}

The challenge file can be downloaded from [here][8].

On loading the PCAP file into Wireshark, I found that there were a lot of requests with the **`User-agent: google-oauth-playground`**.
Finally a specific packet **Frame 19** seemed to have some access-token/refresh-token access requests for some Google API. Still we
are not sure which service it was authorized for. 

<details markdown="block">
  <summary>
    Full details of <b>Frame 19</b> packet can be viewed by expanding this section.  
    The relavent details are available below for brevity.
    <div class="language-plaintext highlighter-rouge">
        <div class="highlight">
<pre class="highlight"><code>=>Headers
Host: oauth2.googleapis.com
Content-length: 269
content-type: application/x-www-form-urlencoded
user-agent: google-oauth-playground
&nbsp;
=>Post body content
HTML Form URL Encoded: application/x-www-form-urlencoded
Form item: "client_secret" = "AER8VvrXuFfYfqjhidcekAM0"
Form item: "grant_type" = "refresh_token"
Form item: "refresh_token" = "1//044y6gZR87Kl0CgYIARAAGAQSNwF-L9IrkAFpIJPMhiGY0OPJpo5RiA5_7R-mHH-kuHwCMUeFL2JqxevGr23oBJmaxdnrD52t3X4"
Form item: "client_id" = "1097638694557-3v745luessc34bkoiqkf8tndqgvbqjpm.apps.googleusercontent.com"
Form item: "email" = "fwordplayground@gmail.com"</code></pre>
        </div>
    </div>
  </summary>  

```
Frame 19: 1481 bytes on wire (11848 bits), 1481 bytes captured (11848 bits)
Ethernet II, Src: VMware_4a:97:bf (00:0c:29:4a:97:bf), Dst: VMware_ee:46:d7 (00:50:56:ee:46:d7)
Internet Protocol Version 4, Src: 10.1.2.100, Dst: 172.217.171.234
    0100 .... = Version: 4
    .... 0101 = Header Length: 20 bytes (5)
Differentiated Services Field: 0x00 (DSCP: CS0, ECN: Not-ECT)
    Total Length: 1467
    Identification: 0x56f9 (22265)
    Flags: 0x40, Don't fragment
    Fragment Offset: 0
    Time to Live: 63
    Protocol: TCP (6)
    Header Checksum: 0x7a1b [validation disabled]
    [Header checksum status: Unverified]
    Source Address: 10.1.2.100
    Destination Address: 172.217.171.234
Transmission Control Protocol, Src Port: 55106, Dst Port: 80, Seq: 22, Ack: 1, Len: 1427
    Source Port: 55106
    Destination Port: 80
    [Stream index: 0]
    [TCP Segment Len: 1427]
    Sequence Number: 22    (relative sequence number)
    Sequence Number (raw): 4223254728
    [Next Sequence Number: 1449    (relative sequence number)]
    Acknowledgment Number: 1    (relative ack number)
    Acknowledgment number (raw): 677992636
    0101 .... = Header Length: 20 bytes (5)
    Flags: 0x010 (ACK)
        1.   .... .... = Reserved: Not set
        ...0 .... .... = Nonce: Not set
        .... 0... .... = Congestion Window Reduced (CWR): Not set
        .... .0.. .... = ECN-Echo: Not set
        .... ..0. .... = Urgent: Not set
        .... ...1 .... = Acknowledgment: Set
        .... .... 0... = Push: Not set
        .... .... .0.. = Reset: Not set
        .... .... ..0. = Syn: Not set
        .... .... ...0 = Fin: Not set
        [TCP Flags: ·······A····]
    Window: 64215
    [Calculated window size: 64215]
    [Window size scaling factor: -2 (no window scaling used)]
    Checksum: 0x1c05 [unverified]
    [Checksum Status: Unverified]
    Urgent Pointer: 0
    [SEQ/ACK analysis]
    [Timestamps]
        [Time since first frame in this TCP stream: 0.894912000 seconds]
        [Time since previous frame in this TCP stream: 0.000156000 seconds]
    TCP payload (1427 bytes)
    TCP segment data (1427 bytes)
[2 Reassembled TCP Segments (1448 bytes): #15(21), #19(1427)]
Hypertext Transfer Protocol
HTML Form URL Encoded: application/x-www-form-urlencoded
    Form item: "client_secret" = "AER8VvrXuFfYfqjhidcekAM0"
    Form item: "grant_type" = "refresh_token"
    Form item: "refresh_token" = "1//044y6gZR87Kl0CgYIARAAGAQSNwF-L9IrkAFpIJPMhiGY0OPJpo5RiA5_7R-mHH-kuHwCMUeFL2JqxevGr23oBJmaxdnrD52t3X4"
    Form item: "client_id" = "1097638694557-3v745luessc34bkoiqkf8tndqgvbqjpm.apps.googleusercontent.com"
Hypertext Transfer Protocol

PVîF×)J¿E»Vù@?z
d¬Ù«ê×BPû¹ÀÈ(iX¼Pú×Host: oauth2.googleapis.com
Content-length: 269
content-type: application/x-www-form-urlencoded
user-agent: google-oauth-playground

client_secret=AER8VvrXuFfYfqjhidcekAM0&grant_type=refresh_token&refresh_token=1%2F%2F044y6gZR87Kl0CgYIARAAGAQSNwF-L9IrkAFpIJPMhiGY0OPJpo5RiA5_7R-mHH-kuHwCMUeFL2JqxevGr23oBJmaxdnrD52t3X4&client_id=1097638694557-3v745luessc34bkoiqkf8tndqgvbqjpm.apps.googleusercontent.com&email=fwordplayground@gmail.com
HTTP/1.1 403 Forbidden
Vary: X-Origin
Vary: Referer
Content-Type: application/json; charset=UTF-8
Date: Fri, 27 Aug 2021 17:51:38 GMT
Server: scaffolding on HTTPServer2
Cache-Control: private
X-XSS-Protection: 0
X-Frame-Options: SAMEORIGIN
X-Content-Type-Options: nosniff
Accept-Ranges: none
Vary: Origin,Accept-Encoding
Transfer-Encoding: chunkedHTTP/1.1 403 Forbidden
Vary: X-Origin
Vary: Referer
Content-Type: application/json; charset=UTF-8
Date: Fri, 27 Aug 2021 18:10:48 GMT
Server: scaffolding on HTTPServer2
Cache-Control: private
X-XSS-Protection: 0
X-Frame-Options: SAMEORIGIN
X-Content-Type-Options: nosniff
Accept-Ranges: none
Vary: Origin,Accept-Encoding
Transfer-Encoding: chunkedHTTP/1.1 403 Forbidden
Vary: X-Origin
Vary: Referer
Content-Type: application/json; charset=UTF-8
Date: Fri, 27 Aug 2021 18:17:49 GMT
Server: scaffolding on HTTPServer2
Cache-Control: private
X-XSS-Protection: 0
X-Frame-Options: SAMEORIGIN
X-Content-Type-Options: nosniff
Accept-Ranges: none
Vary: 
```
</details>

From the above details it is clear that the client used was [**`google-oauth-playground`**][4]. Also the
required details to obtain an access token from refresh token is available to us.

In the OAuth2 playground, head over to **Step 2** and plug in the available **`refresh_token`**.
> Note: Remember to url decode the values before using them.  
> Also the refresh_token is not valid now and so you might get an error if you try it now.

The response of the above request is as below:
```json
{
  "access_token": "ya29.a0ARrdaM80z7_k77TwnPY5dar8UWgwjzuBqfQ4BUUdlObN9oGOUTfWUgY8JIfBERMDuYv2DYg3vmevAoj1b-GmxWMQ_MPsMqmb0vnOgsGWJ4VEEcQwcJk1GklOeISGnBe_KEtd46IldOjCmCNhSdcBqW2OOfWlDA", 
  "scope": "https://www.googleapis.com/auth/gmail.readonly", 
  "expires_in": 3599, 
  "token_type": "Bearer"
}
```

Voila 🪄 !! This presents us with another important piece of information i.e `scope` which tells
us that the `access_token` is valid for accessing GMail read only apis. This was the missing information
which helps us conclude that we need to access the mail box of `fwordplayground@gmail.com`.

We now select the GMail `thread` and `message` apis available [here][5].  

To identify the list of ids of messages required in the [/get][6] api, we need to send an initial request
to [/list][7] api which returns all the ids of the mails.

Now we have all the required details and access each message in the Gmail account of `fwordplayground@gmail.com`.
In one of the message ids **`17b7d85d21fc05ba`** we find the final flag:  
**`FwordCTF{email_forensics_is_interesting_73489nn7n4891}`**

[1]: https://ctftime.org/team/72251
[2]: https://discord.gg/beEcn8Q
[3]: https://www.wireshark.org/
[4]: https://developers.google.com/oauthplayground/
[5]: https://developers.google.com/gmail/api/reference/rest/v1/users.messages
[6]: https://developers.google.com/gmail/api/reference/rest/v1/users.messages/get
[7]: https://developers.google.com/gmail/api/reference/rest/v1/users.messages/list
[8]: https://mega.nz/file/J4JRxKYL#rCTefRhqDnOXfSIDIXeoIEuMk-MQzz8WAUR6oqBxL68
